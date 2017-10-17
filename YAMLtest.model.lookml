
- connection: colorescience_edw

- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards


- explore: related_products
  joins:
    - join: product
      foreign_key: product_id

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []

    - join: related_product
      from: product
      foreign_key: related_product_id

    - join: related_product_translation
      from: product_translation
      relationship: many_to_one
      sql_on: ${related_product.id} = ${related_product_translation.translatable_id} AND ${related_product_translation.locale} = 'en'
      fields: [name]

    - join: product_variant
      relationship: many_to_one
      from: variant
      sql_on: ${product.id} = ${product_variant.product_id} AND ${product_variant.is_master} = 'Yes'

    - join: related_product_variant
      relationship: many_to_one
      from: variant
      sql_on: ${related_product.id} = ${related_product_variant.product_id} AND ${related_product_variant.is_master} = 'Yes'

- explore: crowdtwist_profile
- explore: crowdtwist_activity
- explore: crowdtwist_redemption

- explore: order_lookup
  fields: [ALL_FIELDS*, -order.order_adjustment_dependencies*, -order.user_dependencies*, -order.user_history_dependencies*, -order.address_dependencies*, -order.promotion_coupon_dependencies*, -order.order_facts_dependencies*]
  joins:
    - join: order
      relationship: one_to_one
      sql_on: ${order_lookup.order_id} = ${order.id}

    - join: customer
      relationship: many_to_one
      sql_on: ${customer.id} = ${order.customer_id}
      required_joins: [order]

    - join: capacity_pick_ticket
      relationship: one_to_one
      sql_on: ${capacity_pick_ticket.intuitive_order_id} = ${order.intuitive_number}

- explore: capacity_board_ecomm
- explore: crowd_twist_events
- explore: product_ingredients
- explore: salesforce_location
  fields: [ALL_FIELDS*, -intuitive_customer.order_line_dependencies*]

  joins:
    - join: intuitive_ship_to
      relationship: one_to_one
      sql_on: ${salesforce_location.cs_location_number} = concat('CSL', ${intuitive_ship_to.intuitive_ship_to_key})

    - join: intuitive_customer
      relationship: many_to_one
      sql_on: ${intuitive_ship_to.intuitive_customer_key} = ${intuitive_customer.intuitive_customer_key}

    - join: intuitive_wholesale_customer_facts
      relationship: many_to_one
      sql_on: ${intuitive_wholesale_customer_facts.master_intuitive_customer_key} = ${intuitive_customer.intuitive_customer_key}

    - join: intuitive_territory
      relationship: many_to_one
      sql_on: ${intuitive_territory.intuitive_territory_key} = ${intuitive_ship_to.intuitive_territory_key}

    - join: salesforce_account
      relationship: many_to_one
      sql_on: ${salesforce_account.salesforce_id} = ${salesforce_location.account_salesforce_id}

    - join: colorescience_partners
      relationship: many_to_one
      sql_on: ${intuitive_customer.customer_id} = ${colorescience_partners.customer_id}
      fields: [is_lbr_partner]

- explore: capacity_open_orders
  joins:
    - join: order
      relationship: many_to_one
      sql_on: order.intuitive_number = capacity_open_orders.intuitive_order_id
      fields: [ALL_FIELDS*, -order.user_dependencies*, -order.user_history_dependencies*, -order.address_dependencies*, -order.promotion_coupon_dependencies*]

    - join: order_adjustment
      foreign_key: order.id
      required_joins: [order]


- explore: offline_purchases
  joins:
    - join: offline_purchase_items
      relationship: one_to_many
      sql_on: offline_purchases.id = offline_purchase_items.purchase_id

    - join: offline_partners
      fields: []
      relationship: many_to_one
      sql_on: offline_purchases.partner_id = offline_partners.id

    - join: intuitive_customer
      required_joins: [offline_partners]
      fields: [basic_fields*, -intuitive_customer.channel]
      relationship: many_to_one
      sql_on: offline_partners.customer_number = ${intuitive_customer.customer_id}

    - join: intuitive_ship_to
      relationship: one_to_many
      sql_on: ${intuitive_customer.intuitive_customer_key} = ${intuitive_ship_to.intuitive_customer_key}

    - join: intuitive_territory
      relationship: many_to_one
      sql_on: ${intuitive_territory.intuitive_territory_key} = ${intuitive_ship_to.intuitive_territory_key}

    - join: user
      relationship: many_to_one
      sql_on: offline_purchases.customer_id = user.id

    - join: customer
      foreign_key: customer_id

- explore: promotion_coupon_redemptions
  joins:
    - join: promotion_coupon
      relationship: many_to_one
      sql_on: promotion_coupon.id = promotion_coupon_redemptions.coupon_id

    - join: offline_partners
      relationship: many_to_one
      sql_on: offline_partners.id = promotion_coupon_redemptions.partner_id

    - join: intuitive_customer
      relationship: many_to_one
      required_joins: [offline_partners]
      fields: [basic_fields*, -intuitive_customer.channel]
      sql_on: offline_partners.customer_number = ${intuitive_customer.customer_id}

    - join: sylius_customer
      relationship: many_to_one
      from: customer
      sql_on: promotion_coupon_redemptions.redeemed_by = ${sylius_customer.id}


- explore: variant_cost
  joins:
    - join: variant
      relationship: many_to_one
      sql_on: variant.variant_id = variant_cost.variant_id

    - join: product
      foreign_key: variant.product_id
      required_joins: [variant]

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []


- explore: product_content
  joins:
    - join: product
      foreign_key: product_id
      required_joins: []

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []

- explore: product_translation

- explore: inventory
  joins:
    - join: variant
      foreign_key: variant_id

    - join: product
      foreign_key: variant.product_id
      required_joins: [variant]

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []


    - join: order_item_sales_trend
      sql_on: order_item_sales_trend.variant_id = variant.id
      relationship: many_to_one
      required_joins: [variant]

- explore: capacity_inventory
  joins:
    - join: variant
      relationship: many_to_one
      sql_on: ${variant.sku} = ${capacity_inventory.short_sku}

    - join: intuitive_inventory_at_capacity
      relationship: one_to_many
      sql_on: ${variant.id} = ${intuitive_inventory_at_capacity.variant_id}

    - join: product
      relationship: many_to_one
      foreign_key: variant.product_id
      required_joins: [variant]

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []

    - join: order_item_sales_trend
      sql_on: order_item_sales_trend.variant_id = variant.id
      relationship: many_to_one
      required_joins: [variant]

    - join: current_month_sku_forecast
      from: sku_forecast
      relationship: many_to_one
      sql_on: current_month_sku_forecast.sku = ${capacity_inventory.short_sku} AND year(current_month_sku_forecast.month_starting) = year(curdate()) and month(current_month_sku_forecast.month_starting) = month(curdate())

    - join: next_month_sku_forecast
      from: sku_forecast
      relationship: many_to_one
      sql_on: next_month_sku_forecast.sku = ${capacity_inventory.short_sku} AND year(next_month_sku_forecast.month_starting) = year(date_add(curdate(), INTERVAL 1 MONTH)) and month(next_month_sku_forecast.month_starting) = month(date_add(curdate(), INTERVAL 1 MONTH))

    - join: plus_two_month_sku_forecast
      from: sku_forecast
      relationship: many_to_one
      sql_on: plus_two_month_sku_forecast.sku = ${capacity_inventory.short_sku} AND year(plus_two_month_sku_forecast.month_starting) = year(date_add(curdate(), INTERVAL 2 MONTH)) and month(plus_two_month_sku_forecast.month_starting) = month(date_add(curdate(), INTERVAL 2 MONTH))

    - join: plus_three_month_sku_forecast
      from: sku_forecast
      relationship: many_to_one
      sql_on: plus_three_month_sku_forecast.sku = ${capacity_inventory.short_sku} AND year(plus_three_month_sku_forecast.month_starting) = year(date_add(curdate(), INTERVAL 3 MONTH)) and month(plus_three_month_sku_forecast.month_starting) = month(date_add(curdate(), INTERVAL 3 MONTH))

    - join: plus_four_month_sku_forecast
      from: sku_forecast
      relationship: many_to_one
      sql_on: plus_four_month_sku_forecast.sku = ${capacity_inventory.short_sku} AND year(plus_four_month_sku_forecast.month_starting) = year(date_add(curdate(), INTERVAL 4 MONTH)) and month(plus_four_month_sku_forecast.month_starting) = month(date_add(curdate(), INTERVAL 4 MONTH))

- explore: capacity_inventory_by_sku
  joins:

    - join: intuitive_inventory_at_capacity_by_sku
      relationship: many_to_one
      sql_on: ${capacity_inventory_by_sku.sku} = ${intuitive_inventory_at_capacity_by_sku.sku}

    - join: current_month_sku_forecast
      from: sku_forecast
      relationship: many_to_one
      sql_on: current_month_sku_forecast.sku = ${capacity_inventory_by_sku.sku} AND year(current_month_sku_forecast.month_starting) = year(curdate()) and month(current_month_sku_forecast.month_starting) = month(curdate())

    - join: next_month_sku_forecast
      from: sku_forecast
      relationship: many_to_one
      sql_on: next_month_sku_forecast.sku = ${capacity_inventory_by_sku.sku} AND year(next_month_sku_forecast.month_starting) = year(date_add(curdate(), INTERVAL 1 MONTH)) and month(next_month_sku_forecast.month_starting) = month(date_add(curdate(), INTERVAL 1 MONTH))

    - join: plus_two_month_sku_forecast
      from: sku_forecast
      relationship: many_to_one
      sql_on: plus_two_month_sku_forecast.sku = ${capacity_inventory_by_sku.sku} AND year(plus_two_month_sku_forecast.month_starting) = year(date_add(curdate(), INTERVAL 2 MONTH)) and month(plus_two_month_sku_forecast.month_starting) = month(date_add(curdate(), INTERVAL 2 MONTH))

    - join: plus_three_month_sku_forecast
      from: sku_forecast
      relationship: many_to_one
      sql_on: plus_three_month_sku_forecast.sku = ${capacity_inventory_by_sku.sku} AND year(plus_three_month_sku_forecast.month_starting) = year(date_add(curdate(), INTERVAL 3 MONTH)) and month(plus_three_month_sku_forecast.month_starting) = month(date_add(curdate(), INTERVAL 3 MONTH))

    - join: plus_four_month_sku_forecast
      from: sku_forecast
      relationship: many_to_one
      sql_on: plus_four_month_sku_forecast.sku = ${capacity_inventory_by_sku.sku} AND year(plus_four_month_sku_forecast.month_starting) = year(date_add(curdate(), INTERVAL 4 MONTH)) and month(plus_four_month_sku_forecast.month_starting) = month(date_add(curdate(), INTERVAL 4 MONTH))


- explore: etl_log

- explore: nps
  label: 'NPS'
  joins:
    - join: customer
      relationship: many_to_one
      sql_on: customer.email = nps.email

    - join: customer_history_facts
      foreign_key: customer.id
      required_joins: [customer]

- explore: email_target
  fields: [ALL_FIELDS*, -order.user_dependencies*, -order.user_history_dependencies*, -order.address_dependencies*, -order.promotion_coupon_dependencies*, -order.order_facts_dependencies*]
  joins:
    - join: order
      required_joins: [customer]
      relationship: many_to_one
      sql_on: order.customer_id = customer.id

    - join: order_adjustment
      foreign_key: order.id
      required_joins: [order]

    - join: customer
      relationship: many_to_one
      sql_on: customer.email = email_target.email

- explore: dsr
- explore: user_rfm_change
  always_filter:
    purchase_period: '8 days ago for 7 days'
    pre_purchase_period: 'before 8 days ago'
    pre_purchase_period_end: 'before 1 day ago'

- explore: order_item_refund
  fields: [ALL_FIELDS*, -order.order_adjustment_dependencies*, -order.user_dependencies*, -order.user_history_dependencies*, -order.address_dependencies*, -order.promotion_coupon_dependencies*, -order.order_facts_dependencies*]
  joins:
    - join: variant
      foreign_key: variant_id

    - join: order
      foreign_key: order_id

    - join: order_adjustment
      foreign_key: order.id
      required_joins: [order]

    - join: product
      required_joins: [variant]
      foreign_key: variant.product_id

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []


    - join: variant_attributes
      from: product_variant_attributes
      fields: []
      foreign_key: variant.id

    - join: variant_category
      required_joins: [variant]
      foreign_key: variant_attributes.category_key

    - join: customer
      required_joins: [order]
      foreign_key: order.customer_id

- explore: order_item_sales_trend
  joins:
    - join: product_feed
      foreign_key: variant_id

    - join: product
      required_joins: []
      foreign_key: product_id

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []


    - join: variant
      foreign_key: variant_id

- explore: product_feed
  joins:
    - join: variant
      foreign_key: variant_id

    - join: product
      foreign_key: parent_id

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []


    - join: order_item_sales_trend
      foreign_key: variant_id

- explore: colorescience_dealers
  label: Dealer

- explore: user_lifetime_value_facts_acq_1_2_yrs
  joins:
    - join: user
      foreign_key: id

    - join: customer_acquisition_product_facts
      foreign_key: id

- explore: page_traffic
  view: page_traffic
  joins:
    - join: page_path
      foreign_key: page_path_key

- explore: site_traffic
  view: site_traffic

- explore: earn_churn_history

- explore: product
  joins:

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []

    - join: cmf_seo_metadata
      foreign_key: seo_metadata

    - join: tax_category
      foreign_key: tax_category_id

    - join: shipping_category
      foreign_key: shipping_category_id

    - join: variant
      sql_on: variant.product_id = product.id
      relationship: many_to_one

    - join: inventory
      sql_on: inventory.variant_id = variant.id
      relationship: many_to_one

    - join: order_item_sales_trend
      sql_on: order_item_sales_trend.variant_id = variant.id
      relationship: many_to_one

    - join: upc
      sql_on: upc.variant_id = variant.id
      relationship: many_to_one

- explore: referral_source
  view: referral_source
  hidden: true

- explore: referral_path
  hidden: true
  view: referral_path

- explore: referral_traffic
  view: referral_traffic
  joins:
    - join: referral_source
      foreign_key: referral_source_key

    - join: referral_path
      foreign_key: referral_path_key

- explore: review
  joins:
    - join: product
      foreign_key: product_id

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []

    - join: reviewer_customer
      from: customer
      foreign_key: author_id

    - join: tax_category
      foreign_key: product.tax_category_id

    - join: shipping_category
      foreign_key: product.shipping_category_id

#     - join: referral_sources
#       foreign_key: user.referral_source_id

- explore: order
  conditionally_filter:
    is_completed_order: yes
    is_valid_b2c_order: yes
    completed_date: last 30 days
    unless: [completed_date]

  joins:
    - join: order_facts
      foreign_key: id

    - join: order_referral
      foreign_key: intuitive_number

    - join: capacity_shipment
      relationship: one_to_many
      sql_on: ${capacity_shipment.sales_order_id} = order.intuitive_number

    - join: capacity_open_orders
      relationship: one_to_many
      sql_on: capacity_open_orders.intuitive_order_id = order.intuitive_number

    - join: intuitive_order_line
      fields: [intuitive_order_line.last_modified_date, intuitive_order_line.last_modified_time, intuitive_order_line.is_deleted, intuitive_order_line.is_cancelled, intuitive_order_line.ship_date, intuitive_order_line.weekdays_since_sales_order_date]
      relationship: one_to_many
      sql_on: intuitive_order_line.som_salesorderid = order.intuitive_number

    - join: billing_zipcode
      from: zipcode
      foreign_key: billing_address.zipcode
      required_joins: [billing_address]

    - join: shipping_zipcode
      from: zipcode
      foreign_key: shipping_address.zipcode
      required_joins: [shipping_address]

    - join: shipment
      sql_on: order.id = shipment.order_id
      relationship: one_to_one

    - join: shipping_method
      sql_on: shipment.method_id = shipping_method.id
      relationship: many_to_one
      required_joins: [shipment]

    - join: tracking_number
      sql_on: order.id = tracking_number.order_id
      relationship: many_to_one

    - join: concierge_user
      from: user
      foreign_key: placed_by
      fields: [username]

    - join: customer_historical_purchase_facts
      type: inner
      foreign_key: customer_id

    - join: customer_history_facts
      foreign_key: customer_id

    - join: order_adjustment
      relationship: one_to_one
      foreign_key: id

    - join: referral_sources
      foreign_key: referral_source_id

    - join: payment
      sql_on: payment.order_id = order.id AND payment.state != 'failed'
      relationship: one_to_one

    - join: customer
      sql_on: customer.id = order.customer_id
      relationship: many_to_one

    - join: user
      sql_on: user.customer_id = customer.id
      required_joins: [customer]
      relationship: many_to_one

    - join: promotion_order
      sql_on: promotion_order.order_id = order.id
      relationship: one_to_many

    - join: promotion_coupon
      sql_on: promotion_coupon.id = order.promotion_coupon_id
      relationship: many_to_one

    - join: promotion
      foreign_key: promotion_order.promotion_id
      required_joins: [promotion_order]

    - join: order_last_year
      foreign_key: completed_date

    - join: billing_address
      foreign_key: billing_address_id

    - join: shipping_address
      foreign_key: shipping_address_id

    - join: order_ship_date
      foreign_key: id

    - join: order_margin
      foreign_key: id

    - join: fraud_detection_log
      relationship: many_to_one
      sql_on: fraud_detection_log.order_id = order.id

    - join: order_ip
      relationship: many_to_one
      sql_on: order_ip.order_id = order.id

    - join: credit_card
      relationship: one_to_one
      required_joins: [payment]
      sql_on: payment.credit_card_id = credit_card.id

    - join: ip_location
      relationship: one_to_one
      required_joins: [order_ip]
      sql_on: ip_location.ip = order_ip.ip_address

    - join: offline_partners
      fields: []
      relationship: many_to_one
      sql_on: order.partner_id = offline_partners.id

    - join: lbr_partner
      view_label: 'LBR Partner'
      from: intuitive_customer
      required_joins: [offline_partners]
      fields: [basic_fields*, -lbr_partner.channel]
      relationship: many_to_one
      sql_on: offline_partners.customer_number = ${lbr_partner.customer_id}


- explore: user_recency_history
  view: user_recency_history

- explore: order_item
  symmetric_aggregates: true
  conditionally_filter:
    order.is_completed_order: yes
    order.is_valid_b2c_order: yes
    order.completed_date: last 30 days
    unless: [order.completed_date]

  joins:
    - join: order_referral
      required_joins: [order]
      foreign_key: order.intuitive_number

    - join: order_facts
      type: inner
      relationship: many_to_one
      sql_on: order_facts.order_id = order_item.order_id
      required_joins: [product, variant, variant_category]

    - join: capacity_open_orders
      relationship: one_to_many
      required_joins: [order]
      sql_on: capacity_open_orders.intuitive_order_id = order.intuitive_number

    - join: billing_zipcode
      from: zipcode
      foreign_key: billing_address.zipcode
      required_joins: [billing_address]

    - join: shipping_zipcode
      from: zipcode
      foreign_key: shipping_address.zipcode
      required_joins: [shipping_address]

    - join: shipment
      sql_on: order.id = shipment.order_id
      required_joins: [order]
      relationship: one_to_many

    - join: order_item_refund
      sql_on: order_item.order_id = order_item_refund.order_id AND order_item.variant_id = order_item_refund.variant_id
      relationship: one_to_one

    - join: shipping_method
      sql_on: shipment.method_id = shipping_method.id
      relationship: many_to_one
      required_joins: [shipment]


    - join: tracking_number
      sql_on: order.id = tracking_number.order_id
      relationship: one_to_many
      required_joins: [order]

    - join: concierge_user
      from: user
      foreign_key: order.placed_by
      required_joins: [order]
      fields: [username]

    - join: order_item_refund_invoices
      sql_on: order.id = order_item_refund_invoices.order_id AND variant.id = order_item_refund_invoices.variant_id
      relationship: many_to_one
      required_joins: [order,variant]

    - join: order_adjustment
      sql_on: order_adjustment.order_id = order.id
      relationship: many_to_one
      required_joins: [order]
      fields: [ ]

    - join: discount_adjustment
      from: adjustment
      relationship: many_to_one
      sql_on: ${order_item.id} = ${discount_adjustment.order_item_id}

    - join: tax_and_shipping_adjustment
      from: adjustment
      relationship: many_to_one
      sql_on: order.id = tax_and_shipping_adjustment.order_id
      required_joins: [order]

    - join: billing_address
      foreign_key: order.billing_address_id

    - join: shipping_address
      foreign_key: order.shipping_address_id

    - join: variant
      foreign_key: variant_id

    - join: product_variant_attributes
      required_joins: [variant]
      foreign_key: variant.id

    - join: variant_category
      required_joins: [product_variant_attributes]
      foreign_key: product_variant_attributes.category_key

    - join: variant_sub_category
      required_joins: [product_variant_attributes]
      foreign_key: product_variant_attributes.sub_category_key

    - join: variant_format
      required_joins: [product_variant_attributes]
      foreign_key: product_variant_attributes.format_key

    - join: product
      foreign_key: variant.product_id
      required_joins: [variant, product_translation]

    - join: product_translation
      sql_on: ${variant.product_id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      relationship: many_to_one
      required_joins: [variant]
      fields: [name]

    - join: promotion_order
      required_joins: [order]
      relationship: one_to_many
      sql: |
        LEFT JOIN sylius_promotion_order promotion_order ON promotion_order.order_id = order.id

    - join: promotion_coupon
      sql_on: promotion_coupon.id = order.promotion_coupon_id
      relationship: many_to_one
      required_joins: [order]

    - join: promotion
      foreign_key: promotion_order.promotion_id
      required_joins: [promotion_order]

    - join: order
      foreign_key: order_id
      relationship: many_to_one

    - join: referral_sources
      foreign_key: order.referral_source_id

    - join: payment
      foreign_key: order.payment_id

    - join: customer
      sql_on: customer.id = order.customer_id
      relationship: many_to_one

    - join: user
      sql_on: user.customer_id = customer.id
      required_joins: [customer]
      relationship: many_to_one

    - join: customer_order_facts
      foreign_key: order.customer_id

    - join: order_free_giveaway
      foreign_key: order_id

    - join: user_lifetime_value_facts_acq_1_2_yrs
      foreign_key: order.user_id

    - join: customer_historical_purchase_facts
      relationship: one_to_many
      sql:  |
        INNER JOIN looker_scratch.customer_historical_purchase_facts as customer_historical_purchase_facts ON customer_historical_purchase_facts.customer_id = order.customer_id

    - join: customer_history_facts
      foreign_key: order.customer_id
      required_joins: [order]

    - join: customer_order_item_facts
      foreign_key: order.customer_id

    - join: order_ship_date
      foreign_key: order_id
      required_joins: [order]

    - join: variant_cost
      sql_on: variant_cost.variant_id = order_item.variant_id
      relationship: many_to_one

    - join: offline_partners
      fields: []
      relationship: many_to_one
      sql_on: order.partner_id = offline_partners.id

    - join: lbr_partner
      view_label: 'LBR Partner'
      from: intuitive_customer
      required_joins: [offline_partners]
      fields: [basic_fields*, -lbr_partner.channel]
      relationship: many_to_one
      sql_on: offline_partners.customer_number = ${lbr_partner.customer_id}


- explore: variant_category
- explore: variant_format
- explore: variant_sub_category
- explore: user
  joins:
    - join: referral_sources
      foreign_key: customer.referral_source_id

    - join: user_lifetime_value_facts_acq_1_2_yrs
      foreign_key: id

    - join: customer
      foreign_key: customer_id

    - join: billing_address
      required_joins: [customer]
      foreign_key: customer.billing_address_id

    - join: shipping_address
      required_joins: [customer]
      foreign_key: customer.shipping_address_id

    - join: customer_historical_purchase_facts
      relationship: one_to_one
      foreign_key: id

    - join: customer_history_facts
      foreign_key: customer_id


- explore: variant
  joins:
    - join: product
      foreign_key: product_id

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []

    - join: order_item_refund_invoices
      relationship: many_to_one
      sql_on: order_item_refund_invoices.variant_id = variant.id

    - join: tax_category
      foreign_key: product.tax_category_id

    - join: shipping_category
      foreign_key: product.shipping_category_id

    - join: product_variant_attributes
      foreign_key: variant.id

    - join: variant_category
      required_joins: [product_variant_attributes]
      foreign_key: product_variant_attributes.category_key

    - join: variant_sub_category
      required_joins: [product_variant_attributes]
      foreign_key: product_variant_attributes.sub_category_key

    - join: variant_format
      required_joins: [product_variant_attributes]
      foreign_key: product_variant_attributes.format_key

    - join: product_taxon
      required_joins: [product]
      fields: []
      relationship: many_to_one
      sql_on: product.id = product_taxon.product_id

    - join: inventory
      relationship: many_to_one
      sql_on: inventory.variant_id = variant.id
      required_joins: [order_item_sales_trend]

    - join: order_item_sales_trend
      foreign_key: variant.id

    - join: upc
      relationship: many_to_one
      sql_on: upc.variant_id = variant.id

    - join: taxon
      required_joins: [product_taxon]
      foreign_key: product_taxon.taxon_id

    - join: taxon_translation
      relationship: many_to_one
      sql_on: ${taxon.id} = ${taxon_translation.translatable_id} AND ${taxon_translation.locale} = 'en'
      fields: []
      required_joins: [taxon]




- explore: user_product_affinity
- explore: order_product_affinity
- explore: user_category_affinity
- explore: user_top_category_affinity
- explore: order_category_affinity
- explore: user_sub_category_affinity
- explore: order_sub_category_affinity

- explore: customers_earned_churned_last_7

- explore: billing_address
  hidden: true
  joins:
    - join: country
      foreign_key: country_id

- explore: shipping_address
  hidden: true
  joins:
    - join: country
      foreign_key: country_id

# - explore: facebook_promotion

- explore: unbounce_promotion

- explore: email_campaign
  joins:
    - join: transactional_email_template
      from: email_template
      relationship: many_to_one
      sql_on: email_campaign.title = transactional_email_template.name

    - join: email_list
      foreign_key: email_list_key



- explore: email_campaign_legacy
  fields: [ALL_FIELDS*, -order.user_dependencies*, -order.address_dependencies*, -order.order_facts_dependencies*]
  joins:
    - join: email_list
      foreign_key: email_list_key

    - join: referral_sources
      relationship: one_to_many
      sql_on: ${referral_sources.mailchimp_campaign_id} = ${email_campaign_legacy.mailchimp_campaign_id}

    - join: order
      relationship: one_to_many
      sql_on: referral_sources.id = order.referral_source_id
      required_joins: [referral_sources]

    - join: referral_facts
      relationship: one_to_many
      sql_on: ${referral_sources.id} = ${referral_facts.referral_source_id}


    - join: order_adjustment
      relationship: one_to_many
      sql_on: order_adjustment.order_id = order.id
      required_joins: [order]

    - join: customer_history_facts
      relationship: one_to_many
      sql_on: order.customer_id = customer_id
      required_joins: [order]
      fields: []

    - join: promotion_coupon
      sql_on: promotion_coupon.id = order.promotion_coupon_id
      relationship: many_to_one
      required_joins: [order]
      fields: []

- explore: email_action
  hidden: true

- explore: email_address
  hidden: true

- explore: email_list
  hidden: true

- explore: email_url
  hidden: true

- explore: email_activity
  fields: [ALL_FIELDS*, -order.order_facts_dependencies*]
  joins:

    - join: email_campaign
      from: email_campaign_legacy
      foreign_key: email_campaign_key

    - join: referral_facts
      relationship: many_to_one
      sql_on: ${referral_sources.id} = ${referral_facts.referral_source_id}

    - join: email_action
      foreign_key: email_action_key

    - join: email_address
      foreign_key: email_key

    - join: email_url
      foreign_key: email_url_key

    # Looker required cruft
    - join: referral_sources
      relationship: one_to_many
      sql_on: ${referral_sources.mailchimp_campaign_id} = ${email_campaign.mailchimp_campaign_id}
      fields: []

    - join: order
      relationship: one_to_many
      sql_on: referral_sources.id = order.referral_source_id
      required_joins: [referral_sources]
      fields: [order_base*,-order_facts_dependencies*]

    - join: order_adjustment
      relationship: one_to_many
      sql_on: order_adjustment.order_id = order.id
      required_joins: [order]

    - join: customer_history_facts
      foreign_key: order.customer_id
      required_joins: [order]
      fields: []

- explore: quantcast_performance
  symmetric_aggregates: true
  joins:
  - join: order_adjustment
    foreign_key: order.id
    required_joins: [order]

  - join: quantcast_conversions
    sql_on: quantcast_performance.date = quantcast_conversions.date and quantcast_performance.qc_creative = quantcast_conversions.qc_creative and quantcast_performance.qc_flight=quantcast_conversions.qc_flight
    relationship: one_to_many

  - join: order
    sql_on: concat('WEB00', quantcast_conversions.order_id) = order.intuitive_number
    required_joins: [quantcast_conversions]
    relationship: many_to_one
    fields: [count, average_order_value, revenue, new_customer_order]

  - join: customer_history_facts
    required_joins: [quantcast_conversions, order]
    foreign_key: order.customer_id

  - join: referral_sources
    required_joins: [quantcast_conversions, order]
    relationship: many_to_one
    sql_on: order.referral_source_id = referral_sources.id

- explore: quantcast_performance_by_impression_date
  view: quantcast_performance
  symmetric_aggregates: true
  joins:
  - join: quantcast_conversions
    sql_on: quantcast_performance.date = ${quantcast_conversions.impression_date} and quantcast_performance.qc_creative = quantcast_conversions.qc_creative and quantcast_performance.qc_flight=quantcast_conversions.qc_flight
    relationship: one_to_many

  - join: order
    sql_on: concat('WEB00', quantcast_conversions.order_id) = order.intuitive_number
    required_joins: [quantcast_conversions]
    relationship: many_to_one
    fields: [count, average_order_value, revenue, new_customer_order]

  - join: order_adjustment
    foreign_key: order.id
    required_joins: [order]

  - join: customer_history_facts
    required_joins: [quantcast_conversions, order]
    foreign_key: order.customer_id

  - join: referral_sources
    required_joins: [quantcast_conversions, order]
    relationship: many_to_one
    sql_on: order.referral_source_id = referral_sources.id

- explore: quantcast_conversions
  symmetric_aggregates: true

  joins:
  - join: order
    sql_on: concat('WEB00', quantcast_conversions.order_id) = order.intuitive_number
    fields: [count, average_order_value, revenue, new_customer_order]
    relationship: one_to_one

  - join: order_adjustment
    foreign_key: order.id

  - join: order_item
    sql_on: order.id = order_item.order_id
    relationship: many_to_one
    required_joins: [order]
    fields: [-discount_metrics*, -shipping_metrics*, -tax_metrics*, paid_count, -order_facts_dependencies*]

  - join: variant
    foreign_key: order_item.variant_id
    required_joins: [order, order_item]

  - join: product
    foreign_key: variant.product_id
    required_joins: [order, order_item, variant]

  - join: product_translation
    relationship: many_to_one
    sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
    fields: []


  - join: customer_history_facts
    required_joins: order
    relationship: many_to_one
    foreign_key: order.customer_id

  - join: referral_sources
    required_joins: [order]
    relationship: many_to_one
    sql_on: order.referral_source_id = referral_sources.id

  - join: quantcast_performance
    sql_on: quantcast_performance.date = quantcast_conversions.date and quantcast_performance.qc_creative = quantcast_conversions.qc_creative
    relationship: many_to_one

- explore: criteo_conversions

  symmetric_aggregates: true

  joins:
  - join: order
    relationship: many_to_one
    sql_on: concat('WEB00', criteo_conversions.order_id) = order.intuitive_number
    fields: [count, average_order_value, revenue, new_customer_order]


  - join: order_adjustment
    relationship: many_to_one
    foreign_key: order.id
    required_joins: [order]

  - join: order_item
    relationship: many_to_one
    sql_on: order.id = order_item.order_id
    fields: [-discount_metrics*, -shipping_metrics*, -tax_metrics*, -order_facts_dependencies*]
    required_joins: [order]

  - join: variant
    foreign_key: order_item.variant_id
    required_joins: [order, order_item]

  - join: product
    foreign_key: variant.product_id
    required_joins: [order, order_item, variant]

  - join: product_translation
    sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
    relationship: many_to_one
    fields: []

  - join: customer_history_facts
    required_joins: [order]
    foreign_key: order.customer_id

  - join: referral_sources
    required_joins: [order]
    relationship: many_to_one
    sql_on: order.referral_source_id = referral_sources.id

- explore: criteo_performance
  symmetric_aggregates: true

  joins:
  - join: criteo_conversions
    sql_on: criteo_conversions.action_date = criteo_performance.Date and {% condition criteo_performance.days_after %} ${criteo_conversions.days_after} {% endcondition %} and {% condition criteo_performance.action %} criteo_conversions.action {% endcondition %}
    relationship: one_to_many

  - join: order
    sql_on: concat('WEB00', criteo_conversions.order_id) = order.intuitive_number
    fields: [count, average_order_value, revenue, new_customer_order]
    required_joins: [criteo_conversions]
    relationship: one_to_many

  - join: order_adjustment
    foreign_key: order.id
    required_joins: [order]


  - join: customer_history_facts
    foreign_key: order.customer_id
    required_joins: [order]
    fields: []

- explore: trial_customer_facts
  fields: [ALL_FIELDS*, -subsequent_order.user_dependencies*, -subsequent_order.address_dependencies*, -order.order_facts_dependencies*]

  always_filter:
    product_name: 'Sunforgettable Mineral Sunscreen Brush SPF 50 - Trial Size,Sunforgettable Mineral Sunscreen Brush SPF 50 - Mini Size'

  joins:
    - join: initial_customer
      from: customer
      foreign_key: customer_id


    - join: customer_order_facts
      foreign_key: customer_id

    - join: promotion_coupon
      sql_on: promotion_coupon.id = order.promotion_coupon_id
      relationship: many_to_one
      required_joins: [order]


    - join: subsequent_order
      from: order
      relationship: one_to_many
      fields: [-order_facts_dependencies*]
      sql_on:   |
        ${subsequent_order.completed_date} > ${trial_customer_facts.first_order_date}
        AND ${subsequent_order.customer_id} = ${trial_customer_facts.customer_id}

    - join: subsequent_order_item
      from: order_item
      sql_on: ${subsequent_order_item.order_id} = ${subsequent_order.id}
      relationship: one_to_many
      fields: [-discount_metrics*, -shipping_metrics*, -tax_metrics*, paid_count]
#       fields: [orderz*]

    - join: subsequent_variant
      from: variant
      foreign_key: subsequent_order_item.variant_id

    - join: subsequent_product
      from: product
      foreign_key: subsequent_variant.product_id

    - join: subsequent_variant_attributes
      from: product_variant_attributes
      fields: []
      foreign_key: subsequent_order_item.variant_id

    - join: subsequent_variant_category
      from: variant_category
      foreign_key: subsequent_variant_attributes.category_key

    - join: subsequent_customer
      from: customer
      foreign_key: subsequent_order.customer_id


    # unused cruft required by Looker
    - join: customer_history_facts
      foreign_key: subsequent_order.customer_id
      fields: []

    - join: order_adjustment
      from: order_adjustment
      foreign_key: subsequent_order.id

    - join: order
      foreign_key: subsequent_order.id
      fields: []

    - join: product
      foreign_key: subsequent_variant.product_id
      fields: []

    - join: product_translation
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      relationship: many_to_one
      fields: []

    - join: order_free_giveaway
      foreign_key: subsequent_order.id

- explore: promotion
  joins:
    - join: promotion_coupon
      sql_on: ${promotion.id} = ${promotion_coupon.promotion_id}
      relationship: one_to_many

    - join: promotion_action
      sql_on: ${promotion.id} = ${promotion_action.promotion_id}
      relationship: one_to_many

    - join: promotion_rule
      sql_on: ${promotion.id} = ${promotion_rule.promotion_id}
      relationship: one_to_many

- explore: repurchase_performance_by_month

- explore: repurchase_performance_by_customer
  label: 'Repurchase Performance By Customer'
  symmetric_aggregates: true
  fields: [ALL_FIELDS*, -order.order_adjustment_dependencies*, -order.user_dependencies*, -order.user_history_dependencies*, -order.address_dependencies*, -order.order_facts_dependencies*]

  joins:
    - join: customer_historical_purchase_facts
      relationship: many_to_one
      type: inner
      sql_on: ${customer_historical_purchase_facts.customer_id} = ${repurchase_performance_by_customer.customer_id}

    - join: customer_acquisition_product_facts
      relationship: many_to_one
      type: inner
      sql_on: ${customer_acquisition_product_facts.customer_id} = ${repurchase_performance_by_customer.customer_id}

    - join: product
      view_label: 'Acquisition Product'
      relationship: many_to_one
      sql_on: ${customer_acquisition_product_facts.product_id} = ${product.id}

    - join: referral_sources
      view_label: 'Acquisition Referral Source'
      relationship: many_to_one
      sql_on: ${customer_acquisition_facts.referral_source_id} = ${referral_sources.id}

    - join: product_translation
      relationship: many_to_one
      sql_on: ${product.id} = ${product_translation.translatable_id} AND ${product_translation.locale} = 'en'
      fields: []

    - join: variant
      relationship: many_to_one
      view_label: 'Acquisition Variant'
      sql_on: ${customer_acquisition_product_facts.variant_id} = ${variant.id}

    - join: variant_attributes
      from: product_variant_attributes
      fields: []
      foreign_key: variant.id

    - join: variant_category
      view_label: 'Acquisition Variant Category'
      foreign_key: variant_attributes.category_key

    - join: variant_sub_category
      view_label: 'Acquisition Variant Sub Category'
      foreign_key: variant_attributes.sub_category_key

    - join: customer_acquisition_facts
      relationship: many_to_one
      type: inner
      sql_on: ${customer_acquisition_facts.customer_id} = ${repurchase_performance_by_customer.customer_id}

    - join: order
      view_label: 'Initial Order'
      relationship: many_to_one
      type: inner
      sql_on: ${customer_acquisition_facts.order_id} = ${order.id}

    - join: promotion_coupon
      view_label: 'Initial Order Promotion Coupon'
      sql_on: ${promotion_coupon.id} = ${order.promotion_coupon_id}
      type: inner
      relationship: many_to_one
      required_joins: [order]
      #fields: [code]



- explore: sales_forecast
  view: sales_forecast
  joins:
    - join: month_to_date_actuals
      sql_on: ${sales_forecast.date_month} = month_to_date_actuals.completed_month
      relationship: one_to_one

    - join: last_year_month_to_date_actuals
      from: month_to_date_actuals
      sql_on: DATE_FORMAT(DATE_SUB(sales_forecast.date, INTERVAL 1 YEAR),'%Y-%m') = last_year_month_to_date_actuals.completed_month
      relationship: many_to_one

- explore: taxon
  label: 'Site Category (Taxon)'
  joins:
    - join: cmf_seo_metadata
      foreign_key: seo_metadata

    - join: taxon_translation
      relationship: many_to_one
      sql_on: ${id} = ${taxon_translation.translatable_id} AND ${taxon_translation.locale} = 'en'
      fields: []

- explore: scratch_net_rev
  view: scratch_net_rev
  joins:
    - join: scratch_customer_table
      relationship: many_to_one
      sql_on: ${scratch_customer_table.customer_id} = ${scratch_net_rev.customer_id}
