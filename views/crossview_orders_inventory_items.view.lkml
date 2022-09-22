view: crossview_orders_inventory_items {

  measure: total_gross_margin_amount {
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: number
    sql: ${order_items.total_gross_revenue} - ${inventory_items.total_cost} ;;
    value_format_name: usd_0
  }

  measure: average_gross_margin {
    description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: number
    sql: avg(${order_items.total_gross_revenue} - ${inventory_items.total_cost}) ;;
    value_format_name: usd_0
  }

 }
