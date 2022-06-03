-- depends_on: {{ ref('stripe__main_transactions') }}

select *
from {{ metrics.metric(
	metric_name='stripe__platform_fees_monthly',
	grain='month',
	dimensions=[],
	secondary_calculations=[]
)}}
