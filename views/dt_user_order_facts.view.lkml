view: dt_user_order_facts {
  derived_table: {
    sql: select user_id,
      min(created_at) first_order,
      max(created_at) latest_order,
      sum(sale_price) lifetime_revenue,
      count(distinct order_id) lifetime_orders

      from order_items

      group by 1
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: tier_lifetime_orders {
    type: tier
    sql: ${lifetime_orders} ;;
    tiers: [1,2,3,6,10]
    style: integer
  }

  dimension: tier_lifetime_revenue {
    type: string
    case: {
      when: {
        sql: ${lifetime_revenue} <5 ;;
        label: "$0.00 - $4.99"
      }
      when: {
        sql: ${lifetime_revenue} >=5 and ${lifetime_revenue} <20 ;;
        label: "$5.00 - $19.99"
      }
      when: {
        sql: ${lifetime_revenue} >=20 and ${lifetime_revenue} <50 ;;
        label: "$20.00 - $49.99"
      }
      when: {
        sql: ${lifetime_revenue} >=50 and ${lifetime_revenue} <100 ;;
        label: "$50.00 - $99.99"
      }
      when: {
        sql: ${lifetime_revenue} >=100 and ${lifetime_revenue} <500 ;;
        label: "$100.00 - $499.99"
      }
      when: {
        sql: ${lifetime_revenue} >=500 and ${lifetime_revenue} <1000 ;;
        label: "$500.00 - $999.99"
      }
      else: "$1000.00+"
    }
  }

  #--- measures

  measure: total_lifetime_orders {
    type: sum
    sql: ${lifetime_orders} ;;
    value_format_name: decimal_0
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${lifetime_revenue} ;;
    value_format_name: usd_0
  }

  measure: avg_lifetime_orders {
    type: average
    sql: ${lifetime_orders} ;;
    value_format_name: decimal_1
  }




  set: detail {
    fields: [user_id, first_order_time, latest_order_time, lifetime_revenue, lifetime_orders]
  }
}
