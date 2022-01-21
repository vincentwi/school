# Load the package
library(RODBC)

# Connect to MySQL (my credentials are mysql_server_64/root/.)
db = odbcConnect("mysql_server_64", uid="root", pwd="")
sqlQuery(db, "USE ma_charity_small")

# Extract data from database
query = "SELECT a.contact_id,
                AVG(a.amount) AS 'avgamount',
                MAX(a.amount) AS 'maxamount',
                c.target
         FROM acts a
         INNER JOIN (SELECT contact_id, AVG(amount) AS target
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

# Plot the data
plot(x = log(data$avgamount), y = log(data$target))

# Simple linear regression
model = lm(formula = log(target) ~ log(avgamount) + log(maxamount), data = data)

# Print model results
print(summary(model))
