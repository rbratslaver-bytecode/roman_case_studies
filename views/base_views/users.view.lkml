# The name of this view in Looker is "Users"
view: users {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `thelook.users`;;

  set: detail {
    fields: [order_items.id,order_items.order_id,users.id,created_date,users.age_tier,products.brand,products.category,
      users.gender,users.city,users.state,users.country]
  }
  drill_fields: [detail*]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    label: "UserID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Age" in Explore.

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }



  dimension: age_tier {
    type: tier
    sql: ${age} ;;
    tiers: [0,15,26,36,51,66]
    style: integer
  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }


  dimension_group: signup_length {
    type: duration
    sql_start: ${created_raw} ;;
    sql_end: current_timestamp();;
    intervals: [day,month]
  }

  dimension: signup_tier {
    type: tier
    sql: ${months_signup_length} ;;
    tiers: [3,6,9,12]
    style: integer
  }



  dimension: is_new_user {
    type: string
    sql: CASE WHEN ${days_signup_length} <= 90 then "New User" ELSE "Existing User" END ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ' '  || ${last_name} ;;
  }



  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }



  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }


  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }



###################################dynamic dimension############################################
  parameter: select_geo_level {
    type: unquoted
    allowed_value: {
      value: "city"
    }
    allowed_value: {
      value: "state"
    }
    allowed_value: {
      value: "country"
    }
  }


  dimension: geo_level  {
    type: string
    sql: ${TABLE}.{%parameter select_geo_level%};;
  }

#################################################################################################


#################################measures#########################################################

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.


  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  measure: distinct_users {
    type: count_distinct
    sql: ${id} ;;
  }




  measure: avg_days_since_signup {
    type: average
    sql: ${days_signup_length} ;;
  }

  measure: avg_months_since_signup {
    type: average
    sql: ${months_signup_length} ;;
  }

  measure: count {
    type: count
  }



}


############################refinement#################################################################


# view: +users {
#   measure: max_age {
#     type: max
#     sql: ${age} ;;
#   }
# }

#####################################################################################################
