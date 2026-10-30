CREATE OR REPLACE VIEW churn_analysis AS
SELECT
  c.customer_id,
  c.age,
  c.gender,
  c.region,
  c.city,
  c.acquisition_channel,
  s.plan_type,
  s.contract_type,
  s.payment_method,
  s.monthly_charge,
  s.churn_reason,
  s.start_date,
  s.end_date,
  CASE WHEN s.end_date IS NOT NULL THEN 1 ELSE 0 END AS churned,
  TIMESTAMPDIFF(MONTH, s.start_date, COALESCE(s.end_date, '2025-06-30')) AS tenure_months,
  COALESCE(t.ticket_count, 0) AS ticket_count,
  t.avg_satisfaction,
  u.avg_logins,
  u.total_late_payments
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
LEFT JOIN (
  SELECT customer_id,
         COUNT(*) AS ticket_count,
         AVG(satisfaction_score) AS avg_satisfaction
  FROM support_tickets
  GROUP BY customer_id
) t ON c.customer_id = t.customer_id
LEFT JOIN (
  SELECT customer_id,
         AVG(logins) AS avg_logins,
         SUM(late_payments) AS total_late_payments
  FROM monthly_usage
  GROUP BY customer_id
) u ON c.customer_id = u.customer_id;