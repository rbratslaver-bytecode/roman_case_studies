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
}
