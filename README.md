# Stripe Metrics dbt Package ([Docs](https://housewarehq.github.io/dbt_stripe_metrics))

# 📣 What does this dbt package do?
This package provides pre-built metrics for Stripe data from [Fivetran's connector](https://fivetran.com/docs/applications/stripe). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/stripe#schemainformation).

This package enables you to access commonly used metrics on top of Stripe transactions.

## Metrics 

This package contains transformed models built on top of [Fivetran Stripe source package](https://github.com/fivetran/dbt_stripe_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The metrics offered by this package are described below

| **metric**                          | **description**                                                                                                                                                                                                                              |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [stripe__bookings_monthly](https://github.com/HousewareHQ/dbt_stripe_metrics/blob/main/models/metrics/stripe__metrics.yml#L138-L150)    | Monthly revenue from all transactions.                
| [stripe__churned_customer_revenue_monthly](https://github.com/HousewareHQ/dbt_stripe_metrics/blob/main/models/metrics/stripe__metrics.yml#L84-L99)      | Monthly revenue lost due to churned customers.                         
| [stripe__churned_customers_monthly](https://github.com/HousewareHQ/dbt_stripe_metrics/blob/main/models/metrics/stripe__metrics.yml#L30-L45)    | Monthly count of customers that churned.
| [stripe__mrr](https://github.com/HousewareHQ/dbt_stripe_metrics/blob/main/models/metrics/stripe__metrics.yml#L19-L28)    | Monthly recurring revenue.
| [stripe__new_customer_revenue_monthly](https://github.com/HousewareHQ/dbt_stripe_metrics/blob/main/models/metrics/stripe__metrics.yml#L121-L136)    |         Monthly revenue due to customers that signed up for the first time.                                                               |
| [stripe__new_customers_monthly](https://github.com/HousewareHQ/dbt_stripe_metrics/blob/main/models/metrics/stripe__metrics.yml#L67-L82)    |  Monthly count of customers that signed up for the first time.                                     |
| [stripe__platform_fees_monthly](https://github.com/HousewareHQ/dbt_stripe_metrics/blob/main/models/metrics/stripe__metrics.yml#L5-L17)    | Monthly fees paid to Stripe.                                                         |
| [stripe__recovered_customer_revenue_monthly](https://github.com/HousewareHQ/dbt_stripe_metrics/blob/main/models/metrics/stripe__metrics.yml#L101-L119)    | Monthly revenue due to recovery of previously churned customers.               |
| [stripe__recovered_customers_monthly](https://github.com/HousewareHQ/dbt_stripe_metrics/blob/main/models/metrics/stripe__metrics.yml#L47-L65)    | Monthly count of previously churned customers who signed up again.|                                                                                                                                 

# 🎯 How do I use the dbt package?
## Step 1: Prerequisites
To use this dbt package, you must have the following:
- At least one Fivetran stripe connector syncing data into your destination. 
- A **BigQuery**, **Snowflake**, **Redshift**, or **PostgreSQL** destination.


## Step 2: Install the package

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - git: "git@github.com:HousewareHQ/dbt_stripe_metrics.git"
    revision: 0.1.0
```

## Step 3: Define database and schema variables

By default, this package will look for your Stripe data in the `stripe` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Stripe data is, please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
  stripe_source:
    stripe_database: your_database_name
    stripe_schema: your_schema_name
```

For additional configurations for the source models, please visit the [Stripe source package](https://github.com/fivetran/dbt_stripe_source).

## (Optional) Step 4: Change build schema
By default this package will build the Stripe staging models within a schema titled (<target_schema> + `_stg_stripe`) and the Stripe metrics within a schema titled (<target_schema> + `_stripe_metrics`) in your target database. If this is not where you would like your modeled Stripe data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
  stripe_metrics:
    +schema: my_new_schema_name # leave blank for just the target_schema
  stripe_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
```


# 🗄 Which warehouses are supported?
This package has been tested on BigQuery, Snowflake.


# 🙌 Can I contribute?

Additional contributions to this package are very welcome! Please create issues
or open PRs against `main`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.


# 🏪 Are there any resources available?
- Provide [feedback](https://airtable.com/shrPHxTmfkjq3P6Eh) on what you'd like to see next
- Have questions, feedback, or need help? Email us at nipun@houseware.io
- Check out [Houseware's blog](https://www.houseware.io/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices