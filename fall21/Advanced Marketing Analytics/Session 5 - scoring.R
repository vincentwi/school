# Load the package
library(RODBC)

# Connect to MySQL (my credentials are mysql_server_64/root/.)
db = odbcConnect("mysql_server_64", uid="root", pwd="")
sqlQuery(db, "USE ma_charity_small")

# Extract calibration data from database
query = "SELECT a.contact_id,
                DATEDIFF(20170626, MAX(a.act_date)) / 365 AS 'recency',
                COUNT(a.amount) AS 'frequency',
                AVG(a.amount) AS 'avgamount',
                MAX(a.amount) AS 'maxamount',
                IF(c.counter IS NULL, 0, 1) AS 'loyal',
                c.targetamount AS 'targetamount'
         FROM acts a
         LEFT JOIN (SELECT contact_id, COUNT(amount) AS counter, AVG(amount) AS targetamount
                    FROM acts
                    WHERE (act_date >= 20170626) AND
                          (act_date <  20180626) AND
                          (act_type_id = 'DO')
                    GROUP BY contact_id) AS c
         ON c.contact_id = a.contact_id
         WHERE (act_type_id = 'DO') AND (act_date < 20170626)
         GROUP BY 1"
data = sqlQuery(db, query)

# Show data
print(head(data))

# In-sample, probability model
library(nnet)
prob.model = multinom(formula = loyal ~ (recency * frequency) + log(recency) + log(frequency),
                      data = data)

# In-sample, donation amount model
# Note that the amount model only applies to a subset of donors...
z = which(!is.na(data$targetamount))
print(head(data[z, ]))
amount.model = lm(formula = log(targetamount) ~ log(avgamount) + log(maxamount),
                  data = data[z, ])

# Extract prediction data from database
query = "SELECT contact_id,
                DATEDIFF(20180626, MAX(act_date)) / 365 AS 'recency',
                COUNT(amount) AS 'frequency',
                AVG(amount) AS 'avgamount',
                MAX(amount) AS 'maxamount'
         FROM acts
         WHERE (act_type_id = 'DO')
         GROUP BY 1"
newdata = sqlQuery(db, query)
print(head(newdata))

# Close the connection
odbcClose(db)

# Out-of-sample predictions
# Do NOT forget to re-transform "log(amount)" into "amount"
out = data.frame(contact_id = newdata$contact_id)
out$probs  = predict(object = prob.model, newdata = newdata, type = "probs")
out$amount = exp(predict(object = amount.model, newdata = newdata))
out$score  = out$probs * out$amount

# Show results
print(head(out))

# Who is likely to be worth more than 5 EUR?
z = which(out$score > 5)
print(length(z))
