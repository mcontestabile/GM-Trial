CLASS z_class_prova_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_CLASS_PROVA_2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA dest TYPE REF TO if_rfc_dest.
    DATA myobj  TYPE REF TO z_prova2.

    DATA delimiter TYPE z_prova2=>so_text001.
    DATA get_sorted TYPE z_prova2=>boole_d.
    DATA no_data TYPE z_prova2=>so_text001.
    DATA query_table TYPE z_prova2=>tabname.
    DATA rowcount TYPE z_prova2=>so_int.
    DATA rowskips TYPE z_prova2=>so_int.
    DATA use_et_data_4_return TYPE z_prova2=>boole_d.
    DATA et_data TYPE z_prova2=>sdti_result_tab.
    DATA data TYPE z_prova2=>_tab512.
    DATA lv_root TYPE REF TO cx_root.
    DATA fields TYPE z_prova2=>_rfc_db_fld.
    DATA options TYPE z_prova2=>_rfc_db_opt.

    TRY.
        dest = cl_rfc_destination_provider=>create_by_cloud_destination( i_name = 'BDT' ).

        CREATE OBJECT myobj
          EXPORTING
            destination = dest.
      CATCH cx_rfc_dest_provider_error INTO lv_root.
        " handle CX_RFC_DEST_PROVIDER_ERROR
    ENDTRY.
    TRY.
        query_table = 'SFLIGHT'.
        myobj->rfc_read_table(
           EXPORTING
             "delimiter = delimiter
             "get_sorted = get_sorted
             "no_data = no_data
             query_table = query_table
             "rowcount = rowcount
             "rowskips = rowskips
             "use_et_data_4_return = use_et_data_4_return
          IMPORTING
             et_data = et_data
           CHANGING
             data = data
             fields = fields
             options = options
         ).
        LOOP AT data INTO DATA(ls_wa).
          out->write( ls_wa-wa ).
        ENDLOOP.

      CATCH  cx_aco_communication_failure INTO DATA(lcx_comm).
        out->write( lcx_comm->get_longtext( ) ).
        " handle CX_ACO_COMMUNICATION_FAILURE (sy-msg* in lcx_comm->IF_T100_MESSAGE~T100KEY)
      CATCH cx_aco_system_failure INTO DATA(lcx_sys).
        out->write( lcx_sys->get_longtext( ) ).
        " handle CX_ACO_SYSTEM_FAILURE (sy-msg* in lcx_sys->IF_T100_MESSAGE~T100KEY)
      CATCH cx_aco_application_exception INTO DATA(lcx_appl).
        " handle APPLICATION_EXCEPTIONS (sy-msg* in lcx_appl->IF_T100_MESSAGE~T100KEY)
        CASE lcx_appl->get_exception_id( ).
          WHEN 'DATA_BUFFER_EXCEEDED'.
            "handle DATA_BUFFER_EXCEEDED.
          WHEN 'FIELD_NOT_VALID'.
            "handle FIELD_NOT_VALID.
          WHEN 'NOT_AUTHORIZED'.
            "handle NOT_AUTHORIZED.
          WHEN 'OPTION_NOT_VALID'.
            "handle OPTION_NOT_VALID.
          WHEN 'TABLE_NOT_AVAILABLE'.
            "handle TABLE_NOT_AVAILABLE.
          WHEN 'TABLE_WITHOUT_DATA'.
            "handle TABLE_WITHOUT_DATA.
        ENDCASE.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
