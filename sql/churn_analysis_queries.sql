-- OVERALL CHURN RATE
SELECT 
	COUNT(*) AS total_customers, 
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers, 
    ROUND(
		100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1)
        AS churned_rate_pct 
 FROM subscriptions;
  
  -- CHURN RATE BY CONTRACT TYPE
SELECT 
	contract_type,
    COUNT(*) AS total_customers, 
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers, 
    ROUND(
		100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1)
        AS churned_rate_pct 
FROM subscriptions
GROUP BY contract_type 
ORDER BY churned_rate_pct DESC;

-- CHURN RATE BY PLAN TYPE
SELECT 
	plan_type,
    COUNT(*) AS total_customers, 
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers, 
    ROUND(
		100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1)
        AS churned_rate_pct 
FROM subscriptions
GROUP BY plan_type
ORDER BY churned_rate_pct DESC;

-- CHURN RATE BY PAYMENT METHOD
SELECT 
	payment_method,
    COUNT(*) AS total_customers, 
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers, 
    ROUND(
		100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1)
        AS churned_rate_pct 
FROM subscriptions
GROUP BY payment_method
ORDER BY churned_rate_pct DESC;

-- CHURN RATE BY REGION
SELECT 
	c.region,
    COUNT(*) AS total_customers, 
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers, 
    ROUND(
		100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1)
        AS churned_rate_pct 
FROM subscriptions s
JOIN customers c
	ON s.customer_id = c.customer_id
GROUP BY c.region
ORDER BY churned_rate_pct DESC;

-- CHURN RATE BY GENDER
SELECT 
	c.gender,
    COUNT(*) AS total_customers, 
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers, 
    ROUND(
		100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1)
        AS churned_rate_pct 
FROM subscriptions s
JOIN customers c
	ON s.customer_id = c.customer_id
GROUP BY c.gender
ORDER BY churned_rate_pct DESC;

-- CHURN RATE BY CITY
SELECT 
	c.city,
    COUNT(*) AS total_customers, 
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers, 
    ROUND(
		100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1)
        AS churned_rate_pct 
FROM subscriptions s
JOIN customers c
	ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY churned_rate_pct DESC;

-- CHURN RATE BY ACQUSITION CHANNEL
SELECT 
	c.acquisition_channel,
    COUNT(*) AS total_customers, 
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers, 
    ROUND(
		100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1)
        AS churned_rate_pct 
FROM subscriptions s
JOIN customers c
	ON s.customer_id = c.customer_id
GROUP BY c.acquisition_channel
ORDER BY churned_rate_pct DESC;

-- CHURN RATE BY AGE BAND
SELECT
	CASE 
		WHEN c.age IS NULL THEN 'Unknown'
		WHEN c.age < 25 THEN '18-24'
		WHEN c.age < 35 THEN '25-34'
		WHEN c.age < 45 THEN '35-44'
		WHEN c.age < 55 THEN '45-54'
		WHEN c.age < 65 THEN '55-64'
        ELSE '65+'
	END AS age_band,
 COUNT(*) AS total_customers, 
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers, 
    ROUND(
		100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1)
        AS churned_rate_pct 
FROM subscriptions s
JOIN customers c
	ON s.customer_id = c.customer_id
GROUP BY age_band
ORDER BY age_band;

SELECT
  CASE
    WHEN tenure_months <= 6 THEN '0-6 months'
    WHEN tenure_months <= 12 THEN '7-12 months'
    WHEN tenure_months <= 24 THEN '13-24 months'
    ELSE '25+ months'
  END AS tenure_bucket,
  COUNT(*) AS total_customers,
  SUM(churned) AS churned_customers,
  ROUND(100.0 * SUM(churned) / COUNT(*), 1) AS churn_rate_pct
FROM (
  SELECT
    TIMESTAMPDIFF(MONTH, start_date, COALESCE(end_date, '2025-06-30')) AS tenure_months,
    CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END AS churned
  FROM subscriptions
) t
GROUP BY tenure_bucket
ORDER BY MIN(tenure_months);

SELECT
  YEAR(start_date) AS signup_year,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(100.0 * SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_rate_pct
FROM subscriptions
GROUP BY YEAR(start_date)
ORDER BY signup_year;

SELECT
  CASE
    WHEN COALESCE(t.ticket_count, 0) = 0 THEN '0 tickets'
    WHEN t.ticket_count <= 2 THEN '1-2 tickets'
    ELSE '3+ tickets'
  END AS ticket_group,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN s.end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(100.0 * SUM(CASE WHEN s.end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_rate_pct
FROM subscriptions s
LEFT JOIN (
  SELECT customer_id, COUNT(*) AS ticket_count
  FROM support_tickets
  GROUP BY customer_id
) t ON s.customer_id = t.customer_id
GROUP BY ticket_group
ORDER BY MIN(COALESCE(t.ticket_count, 0));

SELECT
  CASE
    WHEN t.avg_score < 3 THEN 'Low (under 3)'
    WHEN t.avg_score < 4 THEN 'Medium (3-3.9)'
    ELSE 'High (4+)'
  END AS satisfaction_group,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN s.end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(100.0 * SUM(CASE WHEN s.end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_rate_pct
FROM subscriptions s
JOIN (
  SELECT customer_id, AVG(satisfaction_score) AS avg_score
  FROM support_tickets
  GROUP BY customer_id
) t ON s.customer_id = t.customer_id
GROUP BY satisfaction_group
ORDER BY MIN(t.avg_score);

SELECT
  CASE WHEN s.end_date IS NOT NULL THEN 'Churned' ELSE 'Retained' END AS status,
  COUNT(*) AS customers,
  ROUND(AVG(u.avg_logins), 1) AS avg_monthly_logins
FROM subscriptions s
JOIN (
  SELECT customer_id, AVG(logins) AS avg_logins
  FROM monthly_usage
  GROUP BY customer_id
) u ON s.customer_id = u.customer_id
GROUP BY status;

SELECT
  CASE WHEN u.late_total = 0 THEN 'No late payments' ELSE '1+ late payments' END AS payment_behaviour,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN s.end_date IS NOT NULL THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(100.0 * SUM(CASE WHEN s.end_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_rate_pct
FROM subscriptions s
JOIN (
  SELECT customer_id, SUM(late_payments) AS late_total
  FROM monthly_usage
  GROUP BY customer_id
) u ON s.customer_id = u.customer_id
GROUP BY payment_behaviour;

SELECT
  churn_reason,
  COUNT(*) AS churned_customers,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_churn
FROM subscriptions
WHERE end_date IS NOT NULL
GROUP BY churn_reason
ORDER BY churned_customers DESC;