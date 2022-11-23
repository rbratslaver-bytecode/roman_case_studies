# Define the database connection to be used for this model.
connection: "looker_partner_demo"
case_sensitive: no

include: "/explores/*.explore"
# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

# datagroup: roman_case_studies_default_datagroup {
#   # sql_trigger: SELECT MAX(id) FROM etl_log;;
#   max_cache_age: "1 hour"
# }


datagroup: refresh {
  sql_trigger: SELECT max(orderid) from order_items ;;
  max_cache_age: "24 hours"
  description: "Triggered when new ID is added to order_items"
}


persist_with: refresh
