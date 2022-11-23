view: user_order_patterns {
  derived_table: {
    # persist_for: "12 hours"
    sql: select id,
        user_id,
        created_at,
        dense_rank() over (partition by user_id order by created_at ) as order_sequence,
        lead(created_at,1) over (partition by user_id order by created_at ) as next_order_date,
        date_diff(lead(created_at,1) over (partition by user_id order by created_at ),created_at, day) as days_between_orders,
        count(user_id) over(partition by user_id) as total_orders
    from looker-partners.thelook.order_items
 ;;
    }

    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.ID ;;
    }

    dimension: user_id {
      type: number
      sql: ${TABLE}.USER_ID ;;
    }

    dimension_group: order_created {
      type: time
      timeframes: [raw,date,month]
      sql: ${TABLE}.CREATED_AT ;;
    }

    dimension: order_sequence {
      type: number
      sql: ${TABLE}.ORDER_SEQUENCE ;;
    }


    dimension_group: next_order {
      type: time
      timeframes: [raw,date,month]
      sql: ${TABLE}.NEXT_ORDER_DATE ;;
    }


    dimension: days_between_orders {
      type: number
      sql: ${TABLE}.DAYS_BETWEEN_ORDERS  ;;
    }

    dimension: total_orders {
      hidden: yes
      type: number
      sql: ${TABLE}.TOTAL_ORDERS  ;;
    }

    measure: total_users {
      type: count_distinct
      sql: ${user_id} ;;
    }

    measure: avg_days_between_orders {
      type: number
      sql: SUM(${days_between_orders})/NULLIF(SUM(${total_orders}),0);;

    }

    dimension: is_first_order {
      type: yesno
      sql: (${order_sequence} = 1) ;;
    }

    dimension: has_subsequent_order {
      type: yesno
      sql: (${total_orders} > 1) ;;
    }

    measure: sixty_day_repeat_rate_user_count {
      type: count_distinct
      sql: ${user_id} ;;
      filters: [days_between_orders: ">=1 AND <=60"]
    }

    measure: total_cust_60_day_repeat_rate {
      type: number
      sql: 1.0*${sixty_day_repeat_rate_user_count}/NULLIF(${total_users},0);;
      value_format_name: percent_2
    }
  }
