# If necessary, uncomment the line below to include explore_source.

# include: "order_items.explore.lkml"

view: product_comparison {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: category { field: products.category }
      column: total_gross_revenue {}
      column: distinct_orders {}
    }
  }


  dimension: primary_key {
    primary_key: yes
    sql: ${brand}||${category} ;;
  }
  dimension: brand {
    description: ""
  }
  dimension: category {
    description: ""
  }
  dimension: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    value_format: "$#,##0"
    type: number
  }
  dimension: distinct_orders {
    description: ""
    type: number
  }
  parameter: brand_select_parameter {
    suggest_explore: order_items
    suggest_dimension: products.brand
  }
  dimension: is_comparison_brand {
    type: yesno
    sql: ${brand}={{brand_select_parameter._parameter_value}} ;;
  }
parameter: desired_metric {
  type: unquoted
  allowed_value: {
    label: "Revenue"
    value: "total_gross_revenue"
  }allowed_value: {
    label: "Orders"
    value: "distinct_orders"
  }
}

measure: total_gross_revenue_base {
  type: sum
  sql: ${total_gross_revenue} ;;
  filters: [is_comparison_brand: "yes"]
  value_format_name: usd
}
measure: total_gross_revenue_compare {
  type: sum
  sql: ${total_gross_revenue} ;;
  filters: [is_comparison_brand: "no"]
  value_format_name: usd
}
measure: distinct_orders_base {
  type: sum
  sql: ${distinct_orders} ;;
  filters: [is_comparison_brand: "yes"]
  value_format_name: decimal_0
}
measure: distinct_orders_compare {
  type: sum
  sql: ${distinct_orders} ;;
  filters: [is_comparison_brand: "no"]
  value_format_name: decimal_0
}


measure: desired_metric_base {
  type: number
  label_from_parameter: desired_metric
  sql:
  {% if desired_metric._parameter_value == 'total_gross_revenue' %} ${total_gross_revenue_base}
  {% elsif desired_metric._parameter_value == 'distinct_orders' %} ${distinct_orders_base}
  {% endif %};;
  html:
  {% if desired_metric._parameter_value == 'total_gross_revenue' %} {{total_gross_revenue_base._rendered_value}}
  {% elsif desired_metric._parameter_value == 'distinct_orders' %} {{distinct_orders_base._rendered_value}}
  {% endif %};;
}
measure: desired_metric_compare {
  label_from_parameter: desired_metric
  type: number
  sql:
  {% if desired_metric._parameter_value == 'total_gross_revenue' %} ${total_gross_revenue_compare}
  {% elsif desired_metric._parameter_value == 'distinct_orders' %} ${distinct_orders_compare}
  {% else %}
  null
  {% endif %};;
  html:
  {% if desired_metric._parameter_value == 'total_gross_revenue' %} {{total_gross_revenue_compare._rendered_value}}
  {% elsif desired_metric._parameter_value == 'distinct_orders' %} {{distinct_orders_compare._rendered_value}}
  {% endif %};;
}









}


explore: product_comparison {}
