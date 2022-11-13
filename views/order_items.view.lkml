# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker-partners.thelook.order_items`
    ;;

  set: detail {
    fields: [order_items.id,order_items.order_id,users.id,created_date,users.age_tier,products.brand,products.category,
      users.gender,users.city,users.state,users.country]
  }
  drill_fields: [detail*]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    label: "Order Item ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }



  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }



  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    label: "OrderID"
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_sequence {
    type: number
    sql: dense_rank() over(partition by user_id order by ${created_raw}) ;;
  }



  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: return_after_first_order {
    type: duration
    sql_start: ${dt_user_order_facts.first_order_raw} ;;
    sql_end: ${created_raw} ;;
  }


#########################################brand tmeplated filter###############################

  filter: brand_filter {
    type: string
    suggest_dimension: products.brand
  }

  dimension: brand_comparison {
    type: string
    sql: case when {% condition brand_filter %} ${products.brand} {% endcondition %} then
    ${products.brand} else "Other" end ;;
  }

###############################################################################################






  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: distinct_order_items {
    type: count_distinct
    sql: ${id} ;;
  }

  measure: distinct_orders  {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sale_price {
    description: "Total sales from items sold"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: average_sale_price {
    description: "Average sale price of items sold"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: cumulative_total_sales {
    description: "Cumulative total sales from items sold (also known as a running total"
    type: running_total
    sql: ${total_sale_price};;
    value_format_name: usd_0
  }

  measure: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    sql: ${sale_price} ;;
    filters: [status: "-Returned,-Cancelled"]
    value_format_name: usd_0
    # drill_fields: [user_id,users.created_at,users.days_since_signup,users.is_new_user]
    }


  measure: number_items_returned {
    description: "Number of items that were returned by dissatisfied customers"
    type: count_distinct
    sql: ${id} ;;
    filters: [status: "Returned"]
    value_format_name: decimal_0
  }

  measure: item_return_rate {
    description: "Number of Items Returned / Total number of items sold"
    type: number
    sql: 1.0 * ${number_items_returned} / NULLIF(${distinct_order_items},0) ;;
    value_format_name: percent_0
  }

  measure: distinct_customers {
    description: "Total distinct customers"
    type: count_distinct
    sql: ${user_id} ;;
    value_format_name: decimal_0
  }

  measure: number_of_customers_returning_items {
    description: "Number of users who have returned an item at some point"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status: "Returned"]
    value_format_name: decimal_0
  }


  measure: perc_users_with_returns {
    description: "Number of Customer Returning Items / total number of customers"
    type: number
    sql: 1.0 * ${number_of_customers_returning_items} / NULLIF(${distinct_customers},0) ;;
    value_format_name: percent_0
  }

  measure: avg_spend_per_customer {
    label: "Avg Customer Spend"
    description: "Total sale price / Total number of customers"
    type: number
    sql: 1.0 * ${total_sale_price} / NULLIF(${distinct_customers},0) ;;
    value_format_name: usd_0
  }

  measure: first_order {
    type: date
    sql: MIN(${created_raw}) ;;
  }

  measure: latest_order {
    type: date
    sql: MAX(${created_raw}) ;;
  }



}
