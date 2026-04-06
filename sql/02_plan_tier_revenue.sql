-- Revenue by plan tier (subscription level)
select
plan_tier,
count(*) as total,
sum(mrr_amount) as total_mrr
from subscriptions s
group by plan_tier
order by total_mrr desc;

-- Current finding: plan tiers are similar by number of subscriptions,
-- but Enterprise dominates by MRR
