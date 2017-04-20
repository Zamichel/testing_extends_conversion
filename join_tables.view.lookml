

- view: account
  sql_table_name: public.account
  fields:

  - dimension: accountid
    primary_key: true
    type: number
    sql: ${TABLE}.accountid

  - dimension: accountcode
    type: string
    sql: ${TABLE}.accountcode




- view: genericresponse
  sql_table_name: public.genericresponsecode
  fields:

  - dimension: description
    type: string
    sql: ${TABLE}.description

  - dimension: responsecode
    type: number
    sql: ${TABLE}.responsecode




- view: paymentflag
  sql_table_name: public.paymentflag
  fields:

  - dimension: paymentflagid
    primary_key: true
    type: number
    sql: ${TABLE}.paymentflagid

  - dimension: flag
    type: string
    sql: ${TABLE}.flag

