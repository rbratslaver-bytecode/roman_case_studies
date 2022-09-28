view: ndt_user_order_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: first_order {}
      column: latest_order {}
      column: customer_lifetime_revenue {field: order_items.total_gross_revenue}
      column: customer_lifetime_orders {field: order_items.distinct_orders}
    }
  }
  dimension: user_id {
    type: number
  }
  dimension: first_order {
    type: number
  }
  dimension: latest_order {
    type: number
  }
  dimension: total_sale_price {
    description: "Total sales from items sold"
    value_format: "$#,##0"
    type: number
  }
  dimension: customer_lifetime_orders {
    type: number
  }
  dimension: lifetime_orders_group {
    type: tier
    sql:${customer_lifetime_orders} ;;
    tiers: [1,2,3,6,10]
    style: integer
  }

 #---------------------------------measures----------------------------------------------------

measure: total_lifetime_orders {
  type: sum
  sql: ${customer_lifetime_orders} ;;
}










}
