CLASS zrap_generate_demo_data_gme DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZRAP_GENERATE_DEMO_DATA_GME IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  "Delete existing records
  DELETE FROM zrap_atrav_gem.
  DELETE FROM zrap_abook_gem.

  "Insert new records
  INSERT zrap_atrav_gem FROM (
  SELECT
  FROM /dmo/travel
  FIELDS
    uuid( ) as travel_uuid,
    travel_id as travel_id,
    agency_id,
    customer_id,
    begin_date,
    end_date,
    booking_fee,
    total_price,
    currency_code,
    description,
    CASE status
        WHEN 'B' then 'A'
        WHEN 'X' THEN 'X'
        ELSE 'O'
    END as  overall_status,
    createdby as created_by,
    createdat as created_at,
    lastchangedby as last_changed_by,
    lastchangedat as last_changed_at,
    lastchangedat as local_last_changed_at
    ORDER BY travel_id up to 200 rows
    ).
    commit work.

    insert zrap_abook_gem FROM (
    SELECT
    FROM /dmo/booking as booking
    JOIN zrap_atrav_gem as z
      ON booking~travel_id = z~travel_id
      FIELDS
      uuid( ) as booking_uuid,
      z~travel_uuid,
      booking~booking_id,
      booking~booking_date,
      booking~customer_id,
      booking~carrier_id,
      booking~connection_id,
      booking~flight_date,
      booking~flight_price,
      booking~currency_code,
      z~created_by,
      z~last_changed_by,
      z~last_changed_at as local_last_changed_by
     ).
     commit work.

    out->write( 'Travel and booking demo data inserted' ).
  ENDMETHOD.
ENDCLASS.
