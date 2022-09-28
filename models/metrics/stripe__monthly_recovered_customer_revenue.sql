-- depends_on: {{ ref('stripe__monthly_customer_revenue') }}

select *
from {{ metrics.calculate(
    metric('stripe__monthly_recovered_customer_revenue'),
    grain='month',
    dimensions=[],
    secondary_calculations=[]
)}}
