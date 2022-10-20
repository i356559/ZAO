CLASS zey_ao_test_rap_bo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    data lv_type type c value 'A'.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zey_ao_test_rap_bo IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    out->write(
              EXPORTING
                data   = |Execution Started with mode { lv_type }|
*                name   =
*              RECEIVING
*                output =
            ).
    case lv_type.
      when 'R'.
        READ ENTITIES OF ZEY_AO_I_U_TRAVEL
            ENTITY Travel
            ALL FIELDS WITH
            value #( ( TravelId = '858585' ) )
            RESULT data(lt_result)
            failed data(lt_failed)
            reported data(lt_reported).

        if lt_result is not initial.
            out->write(
              EXPORTING
                data   = lt_result
            ).
        else.
            out->write(
              EXPORTING
                data   = lt_failed
            ).
        endif.

      when 'C'.

            data(lv_description) = 'Anubhav is testing RAP BO'.
            data(lv_agency) = '070048'.
            data(lv_my_agency) = '070099'.

            select single customer_id from /dmo/customer into @data(lv_customer_id).

            out->write(
              EXPORTING
                data   = 'Execution Started'
*                name   =
*              RECEIVING
*                output =
            ).

            MODIFY ENTITIES OF ZEY_AO_I_U_TRAVEL
            ENTITY Travel
            CREATE FIELDS ( travelid agencyid customerid begindate enddate description status )
            with value #( ( %cid = 'CID_001'
                            travelid = '959277'
                            agencyid = lv_agency
                            customerid = lv_customer_id
                            begindate = cl_abap_context_info=>get_system_date( )
                            enddate = cl_abap_context_info=>get_system_date( ) + 30
                            description = lv_description
                            status = conv #( /dmo/if_flight_legacy=>travel_status-new )
             ) )
             MAPPED data(lt_mapped)
             failed lt_failed
             reported lt_reported.

             COMMIT ENTITIES.

*             READ ENTITIES OF ZEY_AO_I_U_TRAVEL
*            ENTITY Travel
*            ALL FIELDS WITH
*            value #( ( TravelId = lt_mapped-travel[ 1 ]-travelid ) )
*            RESULT lt_result
*            failed lt_failed
*            reported lt_reported.
*
*            out->write(
*              EXPORTING
*                data   = lt_result
**                name   =
**              RECEIVING
**                output =
*            ).


      when 'U'.
            MODIFY ENTITIES OF ZEY_AO_I_U_TRAVEL
            ENTITY Travel
            UPDATE FIELDS ( agencyid description )
            with value #( (
                            travelid = '959277'
                            agencyid = '070017'
                            description = 'This was gift from EML' )
             )
             failed lt_failed
             reported lt_reported.

             COMMIT ENTITIES.
      when 'D'.
            MODIFY ENTITIES OF ZEY_AO_I_U_TRAVEL
            ENTITY Travel
            DELETE from value #( (
                            travelid = '959277' )
             )
             failed lt_failed
             reported lt_reported.

             COMMIT ENTITIES.
      when 'A'.
            MODIFY ENTITIES OF ZEY_AO_I_U_TRAVEL
            ENTITY Travel
            EXECUTE set_status_booked
            from value #( (
                            travelid = '959277' )
             )
             failed lt_failed
             reported lt_reported.

             COMMIT ENTITIES.
    endcase.


  ENDMETHOD.
ENDCLASS.
