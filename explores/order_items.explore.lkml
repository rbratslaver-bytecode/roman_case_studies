include: "/views/**/*.view"

explore: order_items {
  view_name: order_items

  join: users {
    type: full_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: inventory_items {
    fields: []
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }

  join: cv_orders_inventory_items {
    relationship: one_to_one
    sql:  ;;
  }

  join: products {
  type: left_outer
  relationship:  many_to_one
  sql_on: ${order_items.product_id} = ${products.id} ;;
  }

  join: dt_user_order_facts {
    fields: []
  type: left_outer
  sql_on: ${order_items.user_id} = ${dt_user_order_facts.user_id} ;;
  relationship: many_to_one
  }

  # join: ndt_top_ranking {
  #   view_label: "Brand/Category Ranking"
  #   type: left_outer
  #   sql_on: ${products.brand} = ${ndt_top_ranking.brand} ;;
  #   relationship: many_to_one
  # }

  join: product_comparison {
    type: left_outer
    sql_on: ${products.category} = ${product_comparison.category} and
    ${products.brand} = ${product_comparison.brand};;
    relationship: many_to_one
  }


}
