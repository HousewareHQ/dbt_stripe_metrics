with balance_transaction as (

	select *
	from {{ var('balance_transaction') }}

), charge as (

	select *
	from {{ var('charge')}}

), customer as (

	select *
	from {{ var('customer')}}
), subscription as (

	select *
	from {{ var('subscription') }}
), invoice as (

	select *
	from {{ var('invoice') }}
), invoice_line_item as (

	select *
	from {{ var('invoice_line_item') }}
), plan as (

	select *
	from {{ var('plan') }}
), refund as (

	select *
	from {{ var('refund')}}
),
invoice_details as (
  select
    invoice.invoice_id,
    invoice.created_at,
    invoice.status,
    invoice_line_item.subscription_id as subscription_id,
    DATE(invoice_line_item.period_start, 'UTC') as period_start,
    DATE(invoice_line_item.period_end, 'UTC') as period_end,
  from invoice_line_item
  join invoice
    on invoice.invoice_id = invoice_line_item.invoice_id
  join plan
    on invoice_line_item.plan_id = plan.plan_id
), grouped_line_items as (

  select
    invoice_id,
    created_at as invoice_created_at,
    status as invoice_status,
    subscription_id as subscription_id,
    min(period_start) as min_line_item_period_start,
    max(period_end) as max_line_item_period_end,
  from invoice_details
  group by 1,2,3,4
)

select
	subscription.subscription_id,
	customer.customer_id,
	customer.description as customer_description,
	customer.email as customer_email,
	subscription.status as subscription_status,
	subscription.billing,
	subscription.billing_cycle_anchor,
	subscription.created_at as subscription_created_at,
	subscription.cancel_at as subscription_cancel_at,
	subscription.canceled_at as subscription_canceled_at,
	subscription.ended_at as subscription_ended_at,
	subscription.current_period_start,
	subscription.current_period_end,
	grouped_line_items.invoice_id,
	grouped_line_items.invoice_created_at,
	grouped_line_items.invoice_status,
	grouped_line_items.min_line_item_period_start,
	grouped_line_items.max_line_item_period_end,
	ROUND(DATE_DIFF(grouped_line_items.max_line_item_period_end, grouped_line_items.min_line_item_period_start, DAY)/30) as invoice_period,
	balance_transaction.balance_transaction_id,
	balance_transaction.created_at,
	balance_transaction.available_on,
	balance_transaction.currency,
	balance_transaction.description as balance_transaction_description,
	balance_transaction.amount/100 as balance_transaction_amount,
	coalesce(charge.amount_refunded, 0)/100 as refund_amount,
	balance_transaction.fee/100 as balance_transaction_fee,
	balance_transaction.net/100 as balance_transaction_net,
	balance_transaction.type as balance_transaction_type,
	refund.metadata as refund_metadata

from balance_transaction
left join refund
  on balance_transaction.balance_transaction_id=refund.balance_transaction_id
left join charge
  on charge.balance_transaction_id = balance_transaction.balance_transaction_id
left join customer
  on charge.customer_id = customer.customer_id
left join grouped_line_items
  on charge.invoice_id = grouped_line_items.invoice_id
left join subscription
  on grouped_line_items.subscription_id = subscription.subscription_id
