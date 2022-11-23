view: brand_rankings {
  derived_table: {
    sql:  SELECT brand,
 count(*) as count,
 RANK() OVER(ORDER BY COUNT(*) DESC) as rank

FROM order_items
LEFT JOIN products ON order_items.product_id = products.id
GROUP BY 1
order by 2 desc ;;

datagroup_trigger: refresh
}




  dimension: brand {
    type: string
    primary_key: yes
    sql: ${TABLE}.brand ;;
  }

  dimension: rank_raw {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }


  parameter: max_brands {
    type: number
  }

  dimension: rank {
    type: string
    sql: CASE WHEN ${rank_raw} <= {% parameter max_brands %} THEN CAST(${rank_raw} AS STRING) ELSE 'Other' END;;
  }

  dimension: rank_and_brand {
    type: string
    sql: CASE WHEN ${rank} = 'Other' THEN 'Other' ELSE ${rank} || '-' || ${brand} END;;
  }
}
