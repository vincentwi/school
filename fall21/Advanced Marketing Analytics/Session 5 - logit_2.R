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
                    FROM acts
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

# Logit model after replacement with a new combination of terms
model = multinom(formula = loyal ~ (recency * frequency) + log(recency) + log(frequency),
                 data = data)

# Get coefficients, standard errors
coeff = t(summary(model)$coefficients)
stder = t(summary(model)$standard.errors)
zvalues = coeff / stder
pvalues = (1 - pnorm(abs(zvalues), 0, 1)) * 2

# Print results
print("coefficients:")
print(coeff)
print("standard deviations:")
print(stder)
print("p-values")
print(pvalues)
