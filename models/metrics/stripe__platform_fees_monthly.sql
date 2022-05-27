-- depends_on: {{ ref('stripe__platform_fees') }}

select *
from {{ metrics.metric(
	metric_name='stripe__platform_fees_monthly',
	grain='month',
	dimensions=[],
	secondary_calculations=[]
)}}
