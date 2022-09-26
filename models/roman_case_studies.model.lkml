# Define the database connection to be used for this model.
connection: "looker_partner_demo"

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: roman_case_studies_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: roman_case_studies_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Roman Case Studies"

explore: users {
  label: "Customers"
}


explore: order_items {

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

  join: ndt_top_brands {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.brand} = ${ndt_top_brands.brand} ;;
  }


}
