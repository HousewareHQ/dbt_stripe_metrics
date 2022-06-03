-- depends_on: {{ ref('stripe__customer_monthly_revenue') }}

select *
from {{ metrics.metric(
    metric_name='stripe__mrr',
    grain='month',
    dimensions=[],
    secondary_calculations=[metrics.rolling(aggregate="average", interval=3, alias="roll_avg_quarter")]
)}}
