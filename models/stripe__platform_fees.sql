select
    *
from
    {{ ref('stripe__main_transactions') }}
where balance_transaction_type = 'stripe_fee'
