-- 1. Unique accounts and accounts with at least one churn event
select count(distinct a.account_id), count(distinct ce.account_id)
from accounts a
left join churn_events ce on a.account_id = ce.account_id;

-- Current dataset result: 500 / 352


-- 2. Top churn reasons (event level)
select reason_code, count(*)
from churn_events ce
group by ce.reason_code
order by count(*) desc;

-- Top reasons: features, support, budget


-- 3. Trial vs paid subscriptions
select
sum(case when is_trial = true then 1 else 0 end) as trial,
sum(case when is_trial = false then 1 else 0 end) as paid
from subscriptions s;

-- Current dataset result: 778 / 4222


-- 4. Total MRR / ARR without trial subscriptions
select
sum(mrr_amount) as month,
sum(arr_amount) as year
from subscriptions s
where is_trial = false;

-- Current dataset result: 11 338 747 / 136 064 964


-- 5. Satisfaction score distribution
select
satisfaction_score,
count(*)
from support_tickets st
group by satisfaction_score
order by satisfaction_score desc;
