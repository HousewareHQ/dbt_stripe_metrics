-- depends_on: {{ ref('stripe__main_transactions') }}

select *
from {{ metrics.metric(
    metric_name='stripe__bookings_monthly',
    grain='month',
    dimensions=[],
    secondary_calculations=[]
)}}
