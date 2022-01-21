# Load the package
library(RODBC)

# Connect to MySQL (use your own credentials)
db = odbcConnect("mysql_server_64", uid="root", pwd="qwertY12#")
sqlQuery(db, "USE ma_charity_small")

# Extract data from database
query = "SELECT a.contact_id,
                DATEDIFF(20170625, MAX(a.act_date)) / 365 AS 'recency',
                COUNT(a.amount) AS 'frequency',
                AVG(a.amount) AS 'avgamount',
                DATEDIFF(20170625, MIN(a.act_date)) / 365 AS 'firstdonation',
                IF(c.counter IS NULL, 0, 1) AS 'loyal'
         FROM acts a
         LEFT JOIN (SELECT contact_id, COUNT(amount) AS counter
                    FROM acts
                    WHERE (act_date >= 20170625) AND
                          (act_date <  20180625) AND
                          (act_type_id = 'DO')
                    GROUP BY contact_id) AS c
         ON c.contact_id = a.contact_id
         WHERE (act_type_id = 'DO') AND (act_date < 20170625)
         GROUP BY 1"
data = sqlQuery(db, query)

# Close the connection
odbcClose(db)

# Assign contact id as row names, remove id from data
rownames(data) = data$contact_id
data = data[, -1]

# Load the library that contains the classification tree procedure
# Don't forget to install the libraries first
library(rpart)
library(rpart.plot)

# Create a decision tree model
tree = rpart(formula = loyal ~ ., data = data, cp=.002)

# Print
print(tree)

# Visualize the decision tree with rpart.plot
rpart.plot(tree, box.palette = "RdBu", shadow.col = "gray", nn = TRUE)

install.packages("RMariaDB")

