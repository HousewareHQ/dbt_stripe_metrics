-- depends_on: {{ ref('stripe__monthly_customer_revenue') }}

select *
from {{ metrics.metric(
    metric_name='stripe__monthly_new_customer_revenue',
    grain='month',
    dimensions=[],
    secondary_calculations=[]
)}}
