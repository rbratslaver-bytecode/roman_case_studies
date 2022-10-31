view: dt_user_order_facts {
  label: "User Order Facts"
  derived_table: {
    sql: select user_id,
      min(created_at) first_order,
      max(created_at) last_order,
      sum(sale_price) lifetime_revenue,
      count(distinct order_id) lifetime_orders

      from order_items

      group by 1
      ;;
  }


  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [month,raw]
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: last_order {
    type: time
    sql: ${TABLE}.last_order ;;
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

  dimension: is_active_customer {
    type: yesno
    sql: ${last_order_date} >= current_date() - 90 ;;
  }

  dimension: days_since_last_order {
    type: number
    sql: date_diff(current_date(),${last_order_date},DAY) ;;
  }

  dimension: is_repeat_customer {
    type: yesno
    sql: ${lifetime_orders}>1 ;;
  }

  #---------------------------------------measures----------------------------------------------

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


  measure: avg_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
    value_format_name: usd_0
  }

  measure: avg_days_since_last_orders {
    type: average
    sql: ${days_since_last_order} ;;
  }

  measure: lifetime_revenue_all {
    type: number
    sql: sum(${total_lifetime_revenue}) over() ;;
    value_format_name: usd_0
  }






  set: detail {
    fields: [user_id, first_order_raw, last_order_time, lifetime_revenue, lifetime_orders]
  }
}
