with main_transactions as (
	select
		*
	from
		{{ ref('stripe__mrr_main_transactions') }}
	where
		created_at >= '2010-01-31'
),
distinct_customers as (
	select
		distinct(customer_id) as customer_id
	from
		main_transactions
),
days as (
	{{ dbt_utils.date_spine(
		datepart = "month",
		start_date = "cast('2010-01-31' as date)",
		end_date = "cast('2030-12-31' as date)"
	)}}
),
customer_calendar as (
	select
		distinct_customers.customer_id,
		days.date_month as date_month_end
	from
		distinct_customers
		cross join days
),
monthly_revenue as (
	select
		customer_calendar.date_month_end as date_month,
		main_transactions.revenue_starting_date,
		main_transactions.revenue_ending_date,
		customer_calendar.customer_id,
		coalesce(main_transactions.monthly_revenue, 0) as current_month_revenue
	from
		customer_calendar
		left outer join main_transactions on customer_calendar.customer_id = main_transactions.customer_id
		and
		(
			(
				concat(cast(extract(year from customer_calendar.date_month_end) as string), '-', cast(extract(month from customer_calendar.date_month_end) as string))
				=
				concat(cast(extract(year from main_transactions.revenue_starting_date) as string), '-', cast(extract(month from main_transactions.revenue_starting_date) as string))
			)
			or
			(
				customer_calendar.date_month_end > main_transactions.revenue_starting_date
				and
				customer_calendar.date_month_end < main_transactions.revenue_ending_date
			)
		)
)
select
	date_month,
	revenue_starting_date,
	revenue_ending_date,
	customer_id,
	current_month_revenue,
	coalesce(
		sum(current_month_revenue) OVER (
			partition by customer_id
			ORDER BY
				date_month ROWS BETWEEN UNBOUNDED PRECEDING
				AND 1 PRECEDING
		),
		0
	) as revenue_till_previous_month,
	coalesce(
		LAG(current_month_revenue) OVER (
			partition by customer_id
			ORDER BY
				date_month
		),
		0
	) as previous_month_revenue,
	current_month_revenue * 12 as current_annual_recurring_revenue
from
	monthly_revenue
