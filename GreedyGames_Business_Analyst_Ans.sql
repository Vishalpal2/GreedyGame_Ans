
--------------------- Q1 Ans

with cte as(
select u.user_id as user_id, month(u.date) as month, s.utm_source as utm_source,
sum(r.total_revenue_in_paise) as total_revenue_in_paise
from [dbo].[Q2_User offer completion data] u 
join [dbo].[Q2_rewards details] r
on u.reward_id = r.reward_id
join [dbo].[Q2_users signup] s
on u.user_id = s.user_id
group by u.user_id, month(u.date)
),acv(
select user_id, utm_source, 
avg(total_revenue_in_paise) as ACV
from cte 
group by user_id, utm_source
),
max_min_puchases(
Select user_id, utm_source,
MAX(date) as max_date,
MIN(date) as min_date
from acv
group by 
user_id, utm_source
),Lifespan_calculation(
select user_id, utm_source
DATEDIFF(DAY,max_date,min_date)/30 as month_in_between_purchases
from max_min_puchases
),
avg_lifespan(
select user_id, utm_source,
AVG(month_in_between_purchases)
from Lifespan_calculation
group by user_id, utm_source
)SELECT 
user_id, utm_source,
  ACV / ACL as LTV 
From 
  avg_lifespan 
  join acv on 1 = 1


-----------------------------------------------------------------------------

--------------------------- Q2

-- 1

select count(u.app_id) as sikka_count from [dbo].[Q2_users signup] u
join [dbo].[Q2_User offer data] o on
u.user_id = o.user_id
where u.app_id = 'sikka'
and o.started_at is not null

-- for sikka_pro

select count(u.app_id) as sikka_pro_count from [dbo].[Q2_users signup] u
join [dbo].[Q2_User offer data] o on
u.user_id = o.user_id
where u.app_id = 'sikka_pro'
and o.started_at is not null


--2 

--Offer completion by user


select count(u.app_id) as sikka_count from [dbo].[Q2_users signup] u
join [dbo].[Q2_User offer data] o on
u.user_id = o.user_id
where u.app_id = 'sikka'
and o.status = 'COMPLETED'


----- sikka_pro

select count(u.app_id) as sikka_pro_count from [dbo].[Q2_users signup] u
join [dbo].[Q2_User offer data] o on
u.user_id = o.user_id
where u.app_id = 'sikka_pro'
and o.status = 'COMPLETED'

-- 3

-- Rewards earn by user



select SUM(r.total_payout_in_paise) from [dbo].[Q2_User offer completion data] e
join [dbo].[Q2_rewards details] r
on e.reward_id = r.reward_id
where e.app_id = 'sikka'

---- Sikka_pro

select SUM(r.total_payout_in_paise) from [dbo].[Q2_User offer completion data] e
join [dbo].[Q2_rewards details] r
on e.reward_id = r.reward_id
where e.app_id = 'sikka_pro'

--- 4

-- Revenue

select SUM(r.total_revenue_in_paise) from [dbo].[Q2_User offer completion data] e
join [dbo].[Q2_rewards details] r
on e.reward_id = r.reward_id
where e.app_id = 'sikka'


-- Sikka_pro

select SUM(r.total_revenue_in_paise) from [dbo].[Q2_User offer completion data] e
join [dbo].[Q2_rewards details] r
on e.reward_id = r.reward_id
where e.app_id = 'sikka_pro'


---------------------------------------------------------------------------------------------
----------------------------- Q3

with cte as(
select DATE, dau, referrals,
cast(Referrals as Decimal(18,8))/cast(DAU as decimal(18,8)) as ratio from [Q3_Sikka data]
),vte as
( select t1.date as date, t1.dau as dau, 
t1.referrals as referrals, ROUND(t1.ratio,2) as ratio
from cte as t1
)
select  
ROUND(AVG(v1.ratio),2) as referrals
from vte as v1

-- 0.040


select date, dau*0.04 as referrals from [Q3_Sikka data]
where date >'2022-10-31 00:00:00.0000000'


