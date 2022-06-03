-- depends_on: {{ ref('stripe__customer_monthly_revenue') }}

select *
from {{ metrics.metric(
    metric_name='stripe__churned_customer_revenue_monthly',
    grain='month',
    dimensions=[],
    secondary_calculations=[]
)}}
