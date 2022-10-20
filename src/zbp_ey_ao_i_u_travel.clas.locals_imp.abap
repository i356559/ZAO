CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES tt_travel_failed type table for failed ZEY_AO_I_U_TRAVEL.
    TYPES tt_travel_reported type table for REPORTED ZEY_AO_I_U_TRAVEL.


    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ Travel RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Travel.
    METHODS set_status_booked FOR MODIFY
      IMPORTING keys FOR ACTION Travel~set_status_booked RESULT result.

*    Map messages from our old code to RAP messages
    METHODS map_messages
    IMPORTING
        cid type string OPTIONAL
        travel_id type /dmo/travel_id OPTIONAL
        messages type /dmo/t_message
    EXPORTING
        failed_added type abap_bool
    changing
        failed type tt_travel_failed
        reported type tt_travel_reported.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.

    data: messages type /dmo/t_message,
          travel_in type /dmo/travel,
          travel_out type /dmo/travel.

    "Step 1: Loop at all the data come from Fiori App
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel_create>).

        "Step 2: Map the data which was received to the input structure
        travel_in = CORRESPONDING #( <travel_create> mapping from entity using control ).

        "Step 3: Imaging in your company you have OLD code - FM, Class, Report..
        append travel_in to zbp_ey_ao_i_u_travel=>mt_create_buffer_2 .

*        /dmo/cl_flight_legacy=>get_instance(  )->create_travel(
*          EXPORTING
*            is_travel             = CORRESPONDING /dmo/s_travel_in( travel_in )
*            iv_numbering_mode = /dmo/if_flight_legacy=>numbering_mode-early
*          IMPORTING
*             es_travel             = travel_out
*             et_messages           = data(lt_messages)
*        ).
*
*        /dmo/cl_flight_legacy=>get_instance(  )->convert_messages(
*          EXPORTING
*            it_messages = lt_messages
*          IMPORTING
*            et_messages = messages
*        ).
*
*        map_messages(
*          EXPORTING
*             cid          = <travel_create>-%cid
*             messages     = messages
*         IMPORTING
*            failed_added = data(failed_added)
*          CHANGING
*            failed       = failed-travel
*            reported     = reported-travel
*        ).
*        if failed_added = abap_false.
*
*            INSERT value #(
*                            %cid = <travel_create>-%cid
*                            travelid = travel_out-travel_id
*             ) into table mapped-travel.
*
*        ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.
    DATA: messages TYPE /dmo/t_message,
          travel   TYPE /dmo/travel,
          travelx  TYPE /dmo/s_travel_inx. "refers to x structure (> BAPIs)

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel_update>).

      travel = CORRESPONDING #( <travel_update> MAPPING FROM ENTITY ).

      travelx-travel_id = <travel_update>-TravelID.
      travelx-_intx     = CORRESPONDING #( <travel_update> MAPPING FROM ENTITY ).


      call FUNCTION '/DMO/FLIGHT_TRAVEL_UPDATE'
        EXPORTING
          is_travel              = CORRESPONDING /dmo/s_travel_in( travel )
          is_travelx             = travelx
*          it_booking             =
*          it_bookingx            =
*          it_booking_supplement  =
*          it_booking_supplementx =
        IMPORTING
*          es_travel              =
*          et_booking             =
*          et_booking_supplement  =
          et_messages            = messages
        .
*      /dmo/cl_flight_legacy=>get_instance( )->update_travel(
*        EXPORTING
*          is_travel              = CORRESPONDING /dmo/s_travel_in( travel )
*          is_travelx             = travelx
*        IMPORTING
*           et_messages            =  data(lt_messages)
*      ).
*
*      /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
*                                                        IMPORTING et_messages = messages ).


      map_messages(
          EXPORTING
            cid       = <travel_update>-%cid_ref
            travel_id = <travel_update>-travelid
            messages  = messages
          CHANGING
            failed    = failed-travel
            reported  = reported-travel
        ).

    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
DATA: messages TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<travel_delete>).

      data lt_messages .

      call FUNCTION '/DMO/FLIGHT_TRAVEL_DELETE'
        EXPORTING
          iv_travel_id = <travel_delete>-travelid
        IMPORTING
          et_messages  = messages
        .

*        /dmo/cl_flight_legacy=>get_instance( )->delete_travel(
*        EXPORTING
*          iv_travel_id = <travel_delete>-travelid
*        IMPORTING
*          et_messages  = data(lt_messages)
*      ).

*     /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
*                                                        IMPORTING et_messages = messages ).


      map_messages(
          EXPORTING
            cid       = <travel_delete>-%cid_ref
            travel_id = <travel_delete>-travelid
            messages  = messages
          CHANGING
            failed    = failed-travel
            reported  = reported-travel
        ).

    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  DATA: travel_out TYPE /dmo/travel,
          messages   TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<travel_to_read>) GROUP BY <travel_to_read>-%tky.


        /dmo/cl_flight_legacy=>get_instance( )->get_travel( EXPORTING iv_travel_id          = <travel_to_read>-travelid
                                                                      iv_include_buffer     = ABAP_FALSE
                                                      IMPORTING es_travel             = travel_out
                                                                et_messages           = DATA(lt_messages) ).

        /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
                                                            IMPORTING et_messages = messages ).

      map_messages(
          EXPORTING
            travel_id        = <travel_to_read>-TravelID
            messages         = messages
          IMPORTING
            failed_added = DATA(failed_added)
          CHANGING
            failed           = failed-travel
            reported         = reported-travel
        ).

      IF failed_added = abap_false.
        INSERT CORRESPONDING #( travel_out MAPPING TO ENTITY ) INTO TABLE result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.

*    data(lo_lock) = cl_abap_lock_object_factory=>get_instance( iv_name = '/DMO/ETRAVEL' ).
*    loop at keys ASSIGNING FIELD-SYMBOL(<travel>).
*
*        lo_lock->enqueue(
*          it_parameter  = VALUE #( ( name = 'TRAVEL_ID' VALUE = REF #( <travel>-TravelId ) ) )
*        ).
*        CATCH cx_abap_foreign_lock.
*        CATCH cx_abap_lock_failure.


*    ENDLOOP.


  ENDMETHOD.

  METHOD map_messages.

    failed_added = abap_false.

    loop at messages into data(message).
        if message-msgty = 'E' or message-msgty = 'A'.
            append value #( %cid = cid
                            travelid = travel_id
                            %fail-cause = /dmo/cl_travel_auxiliary=>get_cause_from_message(
                                            msgid        = message-msgid
                                            msgno        = message-msgno
*                                            is_dependend = abap_false
                                          )
            ) to failed.

            failed_added = abap_true.
        ENDIF.

        append value #( %msg = new_message(
                                            id = message-msgid
                                            number = message-msgno
                                            v1 = message-msgv1
                                            v2 = message-msgv2
                                            v3 = message-msgv3
                                            v4 = message-msgv4
                                            severity = if_abap_behv_message=>severity-error
                                          )
                        %cid = cid
                        travelid = travel_id
            ) to reported.
    ENDLOOP.



  ENDMETHOD.

  METHOD set_status_booked.

    DATA: messages                 TYPE /dmo/t_message,
          travel_out               TYPE /dmo/travel,
          travel_set_status_booked LIKE LINE OF result.

    CLEAR result.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<travel_set_status_booked>).

      DATA(travelid) = <travel_set_status_booked>-travelid.


      /dmo/cl_flight_legacy=>get_instance( )->set_status_to_booked( EXPORTING iv_travel_id = travelid
                                                                IMPORTING et_messages  = DATA(lt_messages) ).

      /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages  = lt_messages
                                                            IMPORTING et_messages  = messages ).

      map_messages(
          EXPORTING
            travel_id        = <travel_set_status_booked>-TravelID
            messages         = messages
          IMPORTING
            failed_added = DATA(failed_added)
          CHANGING
            failed           = failed-travel
            reported         = reported-travel
        ).

      IF failed_added = abap_false.

        /dmo/cl_flight_legacy=>get_instance( )->get_travel( EXPORTING iv_travel_id          = travelid
                                                                      iv_include_buffer     = ABAP_FALSE
                                                      IMPORTING es_travel             = travel_out ).

        travel_set_status_booked-travelid        = travelid.
        travel_set_status_booked-%param          = CORRESPONDING #( travel_out MAPPING TO ENTITY ).
        travel_set_status_booked-%param-travelid = travelid.
        APPEND travel_set_status_booked TO result.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZEY_AO_I_U_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PUBLIC SECTION.

  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZEY_AO_I_U_TRAVEL IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
     INSERT /dmo/travel FROM TABLE @zbp_ey_ao_i_u_travel=>mt_create_buffer_2.
     /dmo/cl_flight_legacy=>get_instance(  )->save(  ).
  ENDMETHOD.

  METHOD cleanup.
    /dmo/cl_flight_legacy=>get_instance(  )->initialize(   ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
