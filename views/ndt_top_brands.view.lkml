# If necessary, uncomment the line below to include explore_source.

# include: "roman_case_studies.model.lkml"

view: ndt_top_brands {

  set: detail {
    fields: [order_items.id,order_items.order_id,users.id,order_items.created_date,users.age_tier,products.brand,products.category,
      users.gender,users.city,users.state,users.country]
  }

  drill_fields: [detail*]

  label: "Top Brands"
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_gross_revenue {}
      column: gross_margin_perc { field: cv_orders_inventory_items.gross_margin_perc }
      derived_column: gross_margin_perc_rank {
        sql: DENSE_RANK() OVER(ORDER BY gross_margin_perc DESC) ;;
      }
      derived_column: gross_revenue_all {
        sql: SUM(total_gross_revenue) OVER() ;;
      }
      derived_column: gross_revenue_rank {
        sql: DENSE_RANK() OVER(ORDER BY total_gross_revenue DESC) ;;
      }
    }
  }
  dimension: brand {
    primary_key: yes
  }
  dimension: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    value_format: "$#,##0"
    type: number
  }
  dimension: gross_margin_perc {
    label: "Gross Margin Perc"
    description: "Total Gross Margin Amount / Total Gross Revenue"
    value_format: "#,##0%"
    type: number
  }
  dimension: gross_margin_perc_rank {
    type: number
  }
  dimension: gross_revenue_all {
    type: number
  }
  dimension: gross_revenue_rank {
    type: number
  }

  measure: m_gross_margin_perc {
    label: "Gross Margin %"
    type: max
    sql: ${gross_margin_perc} ;;
    value_format_name: percent_0
  }

  measure: m_total_gross_revenue {
    type: sum
    sql: ${total_gross_revenue};;
    value_format_name: usd_0
  }

  measure: m_gross_revenue_all {
    type: max
    sql: ${gross_revenue_all} ;;
    value_format_name: usd_0
  }

  measure: perc_total_revenue {
    label: "% Of Total Revenue"
    type: number
    sql: ${m_total_gross_revenue} / ${m_gross_revenue_all} ;;
    value_format_name: percent_0
    drill_fields: [products.category,products.name,products.brand,products.department]
  }
}
