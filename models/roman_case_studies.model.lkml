# Define the database connection to be used for this model.
connection: "looker_partner_demo"
case_sensitive: no

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: roman_case_studies_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}


datagroup: refresh {
  sql_trigger: SELECT current_date() ;;
  max_cache_age: "24 hours"
  description: "Triggered when new ID is added to order_items"
}


persist_with: roman_case_studies_default_datagroup


access_grant: my_test {
  user_attribute: can_see_sensitive_data
  allowed_values: ["yes"]
}





explore: order_items {

  # access_filter: {
  #   field: order_items.user_id
  #   user_attribute: order_user_id
  # }


  # always_filter: {
  #   filters: [order_items.status: "Complete"]
  # }

  # sql_always_where: ${status} = "Complete" ;;

  # sql_always_having: ${products.count}>=300 ;;

# conditionally_filter: {
#   filters: [order_items.status: "Complete"]
#   unless: [created_date]
# }



  join: users {
    type: full_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: inventory_items {
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
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${dt_user_order_facts.user_id} ;;
  }

  join: brand_rankings {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.brand} = ${brand_rankings.brand} ;;
  }
}
