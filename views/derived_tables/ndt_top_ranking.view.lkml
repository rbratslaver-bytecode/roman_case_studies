# If necessary, uncomment the line below to include explore_source.

include: "/explores/order_items.explore.lkml"

view: ndt_top_ranking {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_sale_price {}
      column: distinct_customers {}
      column: count {}
      derived_column: ranking {
        sql: dense_rank() over(order by {% parameter brand_rank_measure_selection%}  desc) ;;
      }
      bind_all_filters: yes
    }
  }






  dimension: brand {
    primary_key: yes
    description: ""
  }
  dimension: total_sale_price {
    description: "Total sales from items sold"
    value_format: "$#,##0"
    type: number
  }
  dimension: distinct_customers {
    description: "Total distinct customers"
    value_format: "#,##0"
    type: number
  }
  dimension: brand_rank {
    sql: ${TABLE}.ranking ;;
  }



parameter: top_rank_limit {
  type: unquoted
  default_value: "1"
  allowed_value: {
    label: "Top 1"
    value: "1"
  }
  allowed_value: {
    label: "Top 5"
    value: "5"
  }
  allowed_value: {
    label: "Top 10"
    value: "10"
  }
  allowed_value: {
    label: "Top 20"
    value: "20"
  }
}

  dimension: brand_name_top_brands {
    order_by_field: brand_rank_top_brands
    type: string
    sql:
      CASE
        WHEN ${brand_rank}<={% parameter top_rank_limit %} THEN ${brand_rank}||'-'||${brand}
        ELSE 'Other'
      END
    ;;
  }



  dimension: brand_rank_top_brands {
    label_from_parameter: top_rank_limit
    type: string
    sql:
      CASE
        WHEN ${brand_rank}<={% parameter top_rank_limit %}
          THEN
            CASE
              WHEN ${brand_rank}<10 THEN  CONCAT('0', CAST(${brand_rank} AS STRING))
              ELSE CAST(${brand_rank} AS STRING)
            END
        ELSE 'Other'
      END
    ;;
  }


  parameter: brand_rank_measure_selection {
    type: unquoted
    default_value: "total_sale_price"
    allowed_value: {
      label: "total_sale_price"
      value: "total_sale_price"
    }
    allowed_value: {
      label: "distinct_customers"
      value: "distinct_customers"
    }
    allowed_value: {
      label: "count"
      value: "count"
    }


  }



  measure: dynamic_measure {
    label_from_parameter: brand_rank_measure_selection
    type: number
    sql:
      {% if brand_rank_measure_selection._parameter_value == 'total_sale_price' %} ${order_items.total_sale_price}
      {% elsif brand_rank_measure_selection._parameter_value == 'distinct_customers' %}  ${order_items.distinct_customers}
      {% else %}  ${order_items.count}
      {% endif %}
    ;;
}







}
