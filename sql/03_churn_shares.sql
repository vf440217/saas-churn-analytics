-- 1. Churn share by plan tier (account level)
select f.plan_tier, total, churn, segment,
round((segment / total::numeric) * 100, 2) as share_percent
from
(select plan_tier, count(*) as total
 from accounts a
 group by plan_tier) f
join
(select plan_tier,
        case when ce.account_id is not null then 'churn' else 'no' end as churn,
        count(distinct a.account_id) as segment
 from accounts a
 left join churn_events ce on a.account_id = ce.account_id
 group by churn, plan_tier
 order by segment) s on f.plan_tier = s.plan_tier;

-- Finding: churn share is similar across plan tiers


-- 2. Churn share by billing frequency (subscription level)
select billing_frequency,
count(s.subscription_id),
sum(case when churn_flag is true then 1 else 0 end) as churn,
sum(case when churn_flag is false then 1 else 0 end) as no,
round((sum(case when churn_flag is true then 1 else 0 end) / count(s.subscription_id)::decimal) * 100, 2) as percent_churn
from subscriptions s
group by billing_frequency;

-- Finding: annual churn is slightly higher than monthly, but the gap is small


-- 3. Churn share by seats group (account level)
-- Run separately for 1-10, 11-30, and 31-200 seats
select count(seats),
sum(case when accs.churn = 'churn' then 1 else 0 end) as churn,
sum(case when accs.churn = 'no' then 1 else 0 end) as not_churn,
round((sum(case when accs.churn = 'churn' then 1 else 0 end)) / count(seats)::numeric * 100, 2) as percent
from
(select account_id, seats
 from accounts a) sit
join
(select distinct a.account_id,
        case when ce.account_id is not null then 'churn' else 'no' end as churn
 from accounts a
 left join churn_events ce on a.account_id = ce.account_id) accs
on accs.account_id = sit.account_id
where seats between 1 and 10;
