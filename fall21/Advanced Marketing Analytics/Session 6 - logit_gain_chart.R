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

# Logit model
model = multinom(formula = loyal ~ (recency * frequency) + log(recency) + log(frequency),
                 data = data)

# Obtain predictions (on the same data set)
probs  = predict(object = model, newdata = data, type = "probs")

# Rank order target variable in decreasing order of (predicted) probability
target = data$loyal[order(probs, decreasing=TRUE)] / sum(data$loyal)
gainchart = c(0, cumsum(target))

# Create a random selection sequence
random = seq(0, to = 1, length.out = length(data$loyal))

# Create the "perfect" selection sequence
perfect = data$loyal[order(data$loyal, decreasing=TRUE)] / sum(data$loyal)
perfect = c(0, cumsum(perfect))

# Plot gain chart, add random line
plot(gainchart)
lines(random)
lines(perfect)

# Compute 1%, 5%, 10%, and 25% lift and improvement
q = c(0.01, 0.05, 0.10, 0.25)
x = quantile(gainchart, probs = q)
z = quantile(perfect,   probs = q)

print("Hit rate:")
print(x)
print("Lift:")
print(x/q)
print("Improvement:")
print((x-q)/(z-q))
