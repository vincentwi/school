USE ma_charity_small;

# How much money is collected every year?
SELECT YEAR(act_date) as `year`, SUM(Amount)
FROM acts
GROUP BY year
# HAVING year >= 2008
ORDER BY year;

# How much money is collected through classic donations
# and automatic deductions
SELECT part.`year` as `year`,
       part.act_type_id as donation_type,
       part.sum as amount,
       ROUND(part.sum * 100/ total.sum, 2) as percent
FROM (
    SELECT YEAR(act_date) as `year`, act_type_id, SUM(Amount) as sum
    FROM acts
    GROUP BY year, act_type_id
    ) part, (
    SELECT YEAR(act_date) as `year`, SUM(Amount) as sum
    FROM acts
    GROUP BY year
    ) total
WHERE part.year = total.year AND part.year >= 2008
ORDER BY year;

# more efficient version
WITH partial AS (
    SELECT YEAR(act_date) as year,
           act_type_id,
           SUM(Amount) as amount
    FROM acts ac
    GROUP BY year, act_type_id
),
total AS (
    SELECT year, SUM(amount) as total_amount
    FROM partial
    GROUP BY year
)
SELECT pa.year,
       pa.act_type_id,
       pa.amount,
       ROUND(pa.amount * 100 / tot.total_amount, 2) as percent
FROM partial pa JOIN total tot
    ON pa.year = tot.year
WHERE pa.year >= 2008
ORDER BY 1;

# How many contacts are there in the database?
SELECT COUNT(id) as num_contacts
FROM contacts
WHERE active = 1;

# How many solicitations did we send?
SELECT COUNT(DISTINCT contact_id) as num_donors
FROM actions;

# How many donors have we had?
SELECT COUNT(DISTINCT contact_id) as num_donors
FROM acts;

# How many donated within the last 2 years
WITH last_donation AS (
    SELECT contact_id, MAX(act_date)
    FROM acts
    GROUP BY contact_id
    HAVING MAX(act_date) >= 20160626
)
SELECT COUNT(contact_id) as num_donors
FROM last_donation;

# How many donated within the last 1 year
WITH last_donation AS (
    SELECT contact_id, MAX(act_date)
    FROM acts
    GROUP BY contact_id
    HAVING MAX(act_date) >= 20170626
)
SELECT COUNT(contact_id) as num_donors
FROM last_donation;

WITH second_half AS (
    SELECT contact_id,
           amount,
           act_type_id,
           CASE
               WHEN act_date BETWEEN 20171226 AND 20180625 THEN 0
               WHEN act_date BETWEEN 20161226 AND 20170625 THEN 1
               WHEN act_date BETWEEN 20151226 AND 20160625 THEN 2
               WHEN act_date BETWEEN 20141226 AND 20150625 THEN 3
               WHEN act_date BETWEEN 20131226 AND 20140625 THEN 4
               ELSE 5
               END as period
    FROM acts
)
SELECT period,
       act_type_id,
       SUM(amount) as total_donation,
       COUNT(DISTINCT contact_id) as num_donors
FROM second_half
WHERE period != 5
GROUP BY period, act_type_id;