# Load the package
library(RODBC)

# Connect to MySQL (my credentials are mysql_server_64/root/.)
db = odbcConnect("mysql_server_64", uid="root", pwd="")
sqlQuery(db, "USE ma_charity_small")

# Extract data from database
query = "SELECT a.contact_id,
                DATEDIFF(20170626, MAX(a.act_date)) / 365 AS 'recency',
                COUNT(a.amount) AS 'frequency',
                AVG(a.amount) AS 'avgamount',
                DATEDIFF(20170626, MIN(a.act_date)) / 365 AS 'firstdonation',
                IF(c.counter IS NULL, 0, 1) AS 'loyal'
         FROM acts a
         LEFT JOIN (SELECT contact_id, COUNT(amount) AS counter
                    FROM Acts
                    WHERE (act_date >= 20170626) AND
                          (act_date <  20180626) AND
                          (act_type_id = 'DO')
                    GROUP BY contact_id) AS c
         ON c.contact_id = a.contact_id
         WHERE (act_type_id = 'DO') AND (act_date < 20170626)
         GROUP BY 1"
data = sqlQuery(db, query)

# Close the connection
odbcClose(db)

# Assign contact id as row names, remove id from data
rownames(data) = data$contact_id
data = data[, -1]

# One of the libraries available for (multinomial) logit model
library(nnet)

# Compute the logit model on the entire data set
# These are the predictions you need to use later on
formula = "loyal ~ (recency * frequency) + log(recency) + log(frequency)"
model = multinom(formula, data)

# Run a nfold cross-validation
nfold = 5
nobs  = nrow(data)
index = rep(1:nfold, length.out = nobs)
probs = rep(0, nobs)
for (i in 1:nfold) {

   # Assign in-sample and out-of-sample observations
   insample  = which(index != i)
   outsample = which(index == i)

   # Run model on in-sample data only
   submodel = multinom(formula, data[insample, ])

   # Obtain predicted probabilities on out-of-sample data
   probs[outsample] = predict(object = submodel, newdata = data[outsample, ], type = "probs")

}

# Print cross-validated probabilities
print(head(probs))

# How many loyal donors among the top 2000
# in terms of (out-of-sample) probabilities?
pred = data.frame(model = probs, truth = data$loyal)
pred = pred[order(pred$model, decreasing = TRUE), ]
print(sum(pred$truth[1:2000]) / 2000)

# vs. full model used to make actual predictions
probs = predict(object = model, newdata = data, type = "probs")
pred = data.frame(model = probs, truth = data$loyal)
pred = pred[order(pred$model, decreasing = TRUE), ]
print(sum(pred$truth[1:2000]) / 2000)
