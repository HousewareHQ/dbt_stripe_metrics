select
	*,
	(balance_transaction_amount - refund_amount) / invoice_period as monthly_revenue,
	case
		when min_line_item_period_start < cast(created_at as DATE) then cast(created_at as DATE)
		else min_line_item_period_start
	end as revenue_starting_date,
	case
		when subscription_ended_at is not null
		and cast(subscription_ended_at as DATE) < max_line_item_period_end then cast(subscription_ended_at as DATE)
		else max_line_item_period_end
	end as revenue_ending_date
from
	{{ ref('stripe__main_transactions') }}
where
	invoice_period is not null
	and invoice_period != 0
	and not (balance_transaction_type = 'stripe_fee')
