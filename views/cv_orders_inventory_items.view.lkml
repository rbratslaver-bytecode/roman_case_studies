view: cv_orders_inventory_items {

  set: detail {
    fields: [order_items.id,order_items.order_id,users.id,order_items.created_date,users.age_tier,products.brand,products.category,
      users.gender,users.city,users.state,users.country]
  }

  drill_fields: [detail*]

  dimension: inventory_item_id {
    sql: ${order_items.inventory_item_id} ;;
    primary_key: yes
    hidden: yes
  }

  measure: total_gross_margin_amount {
    view_label: "Order Items"
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: number
    sql: ${order_items.total_gross_revenue} - ${inventory_items.total_cost} ;;
    value_format_name: usd_0

  }


  # measure: average_gross_margin {
  #   view_label: "Order Items"
  #   description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
  #   type: average
  #   sql: ${total_gross_margin_amount} ;;
  #   value_format_name: usd_0
  # }


  measure: gross_margin_perc {
    label: "Gross Margin %"
    view_label: "Order Items"
    description: "Total Gross Margin Amount / Total Gross Revenue"
    type: number
    sql: 1.0 * ${total_gross_margin_amount} / NULLIF(${order_items.total_gross_revenue},0);;
    value_format_name: percent_0
  }
 }
