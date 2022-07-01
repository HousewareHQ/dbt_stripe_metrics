-- depends_on: {{ ref('stripe__main_transactions') }}

select *
from {{ metrics.metric(
	metric_name='stripe__monthly_platform_fees',
	grain='month',
	dimensions=[],
	secondary_calculations=[]
)}}
