-- depends_on: {{ ref('stripe__main_transactions') }}

select *
from {{ metrics.calculate(
    metric('stripe__monthly_bookings'),
    grain='month',
    dimensions=[],
    secondary_calculations=[]
)}}
