-- depends_on: {{ ref('stripe__monthly_customer_revenue') }}

select *
from {{ metrics.calculate(
    metric('stripe__mrr'),
    grain='month',
    dimensions=[],
    secondary_calculations=[metrics.rolling(aggregate="average", interval=3, alias="roll_avg_quarter")]
)}}
