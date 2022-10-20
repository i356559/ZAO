CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES tt_travel_failed type table for failed ZEY_AO_I_M_TRAVEL.
    TYPES tt_travel_reported type table for REPORTED ZEY_AO_I_M_TRAVEL.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS createTravelByTemplate FOR MODIFY
      IMPORTING keys FOR ACTION Travel~createTravelByTemplate RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.
    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateStatus.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Travel.

    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE Travel\_Bookings.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD createTravelByTemplate.

    "Step 1 : Extract max travel id in the system
    select max( travel_id ) from /dmo/travel into @data(lv_travel_id).

    "Step 2 : Read the record data which needs to be copied by EML
    read entities of ZEY_AO_I_M_TRAVEL in LOCAL MODE
    ENTITY travel
    fields ( travelid agencyid customerid bookingfee totalprice currencycode )
    with CORRESPONDING #( keys )
    RESULT data(lt_read_result)
    FAILED failed
    REPORTED reported.

    "Step 3 : increment the travel id by 1 and use EML to insert new data
    data(lv_today) = cl_abap_context_info=>get_system_date(  ).

    data lt_create type table for create ZEY_AO_I_M_TRAVEL.
    lt_create = value #( for row in lt_read_result index into idx
                                (
                                    %cid = row-TravelId
                                    travelid = lv_travel_id + idx
                                    agencyid = row-AgencyId
                                    customerid = row-CustomerId
                                    BeginDate = lv_today
                                    EndDate = lv_today + 30
                                    BookingFee = row-BookingFee
                                    TotalPrice = row-TotalPrice
                                    CurrencyCode = row-CurrencyCode
                                    Description = 'Auto created by Copy'
                                    Status = 'N'
                                )

    ).

    MODIFY entities of ZEY_AO_I_M_TRAVEL in LOCAL MODE
    ENTITY travel
    create fields ( travelid agencyid customerid begindate enddate
    bookingfee totalprice currencycode description status )
    with lt_create
    mapped mapped
    FAILED data(lt_failed)
    REPORTED data(lt_reported).

    failed-travel = CORRESPONDING #( base ( failed-travel ) lt_failed-travel mapping travelid = %cid ).
    reported-travel = CORRESPONDING #( base ( reported-travel ) lt_reported-travel mapping travelid = %cid ).

    "Step 4 : Read the newly created data and return in mapped structure
    read entities of ZEY_AO_I_M_TRAVEL in LOCAL MODE
    ENTITY travel
    all fields
    with CORRESPONDING #( mapped-travel )
    RESULT data(lt_read_created).


    result = value #( for key in mapped-travel index into idx (
                        %cid_ref = keys[ key entity %key = key-%cid ]-%cid_ref
                        %key = key-%cid
                        %param-%tky = key-%tky
                     )
     ).

     result = CORRESPONDING #( result from lt_read_created using key
                                entity %key = %param-%key
                                mapping %param = %data except *
     ).


  ENDMETHOD.

  METHOD get_instance_features.

  READ ENTITIES OF ZEY_AO_I_M_TRAVEL in local mode
  ENTITY travel
  FIELDS ( status )
  WITH CORRESPONDING #( keys )
  RESULT data(lt_result) FAILED failed.

  result = value #( for ls_travel in lt_result (
                            %tky = ls_travel-%tky
                            %field-travelid = if_abap_behv=>fc-f-read_only
                            %features-%action-rejectTravel = cond #( when ls_travel-Status = 'X'
                                                                     then if_abap_behv=>fc-o-disabled
                                                                     else if_abap_behv=>fc-o-enabled
                            )
                            %features-%action-acceptTravel =  cond #( when ls_travel-Status = 'A'
                                                                     then if_abap_behv=>fc-o-disabled
                                                                     else if_abap_behv=>fc-o-enabled
                            )   ) ).



  ENDMETHOD.

  METHOD acceptTravel.

  MODIFY ENTities of ZEY_AO_I_M_TRAVEL in local mode
    entity Travel
    update fields ( status )
    with value #(  for key in keys ( %tky = key-%tky status = 'A' ) )
    FAILED failed
    REPORTED reported
    .

  READ ENTITIES OF ZEY_AO_I_M_TRAVEL in local mode
  ENTITY travel
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT data(lt_result).

  result = VALUE #( for travel in lt_result ( %tky = travel-%tky %param = travel ) ).

  ENDMETHOD.

  METHOD rejectTravel.


  MODIFY ENTities of ZEY_AO_I_M_TRAVEL in local mode
    entity Travel
    update fields ( status )
    with value #(  for key in keys ( %tky = key-%tky status = 'X' ) )
    FAILED failed
    REPORTED reported
    .

  READ ENTITIES OF ZEY_AO_I_M_TRAVEL in local mode
  ENTITY travel
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT data(lt_result).

  result = VALUE #( for travel in lt_result ( %tky = travel-%tky %param = travel ) ).

  ENDMETHOD.

METHOD validateCustomer.

    "Step 1: Read the entity data customer ID
    READ ENTITIES OF ZEY_AO_I_M_TRAVEL IN LOCAL MODE
        ENTITY Travel
          FIELDS ( customerid )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel)
        FAILED DATA(lt_failed).

    "Step 2: mapped failed
    failed =  CORRESPONDING #( DEEP lt_failed  ).

    DATA lt_customer TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    "Step 3: Get all the unique customer IDs to a internal table
    " Optimization of DB select: extract distinct non-initial customer IDs
    lt_customer = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = customerid EXCEPT * ).
    DELETE lt_customer WHERE customer_id IS INITIAL.

    IF  lt_customer IS NOT INITIAL.
      " Check if customer ID exists
      "Step 4: Select from customer master table and fetch info - itab
      SELECT FROM /dmo/customer FIELDS customer_id
                                FOR ALL ENTRIES IN @lt_customer
                                WHERE customer_id = @lt_customer-customer_id
      INTO TABLE @DATA(lt_customer_db).
    ENDIF.

    " Raise message for non existing customer id
    "Step 5: Loop at each travel record, check if itab has that customerId
    LOOP AT lt_travel INTO DATA(ls_travel).

      APPEND VALUE #(  %tky                 = ls_travel-%tky
                       %state_area          = 'VALIDATE_CUSTOMER' ) TO reported-travel.

      "Step 6: if we not find - Throw Error 1
      IF ls_travel-customerid IS  INITIAL.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.
        "Step 7: Return the %tky, %state_area, %element, %msg
        APPEND VALUE #( %tky                = ls_travel-%tky
                        %state_area         = 'VALIDATE_CUSTOMER'
                        %msg                = NEW /dmo/cm_flight_messages(
                                                                textid = /dmo/cm_flight_messages=>enter_customer_id
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-customerid = if_abap_behv=>mk-on ) TO reported-travel.

      "Step 6: if we not find -  Not Valid - Throw Error2
      ELSEIF ls_travel-customerid IS NOT INITIAL AND NOT line_exists( lt_customer_db[ customer_id = ls_travel-customerid ] ).
        APPEND VALUE #(  %tky = ls_travel-%tky ) TO failed-travel.
        "Step 7: Return the %tky, %state_area, %element, %msg
        APPEND VALUE #(  %tky                = ls_travel-%tky
                         %state_area         = 'VALIDATE_CUSTOMER'
                         %msg                = NEW /dmo/cm_flight_messages(
                                                                customer_id = ls_travel-CustomerId
                                                                textid = /dmo/cm_flight_messages=>customer_unkown
                                                                severity = if_abap_behv_message=>severity-error )
                         %element-customerid = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
     ENDLOOP.

  ENDMETHOD.

  METHOD validateDates.
    READ ENTITIES OF ZEY_AO_I_M_TRAVEL IN LOCAL MODE
     ENTITY Travel
       FIELDS (  begindate enddate travelid )
       WITH CORRESPONDING #( keys )
     RESULT DATA(lt_travel)
     FAILED DATA(lt_failed).

    failed =  CORRESPONDING #( DEEP lt_failed  ).

    LOOP AT lt_travel INTO DATA(ls_travel).

      APPEND VALUE #(  %tky               = ls_travel-%tky
                       %state_area          = 'VALIDATE_DATES' ) TO reported-travel.

      IF ls_travel-begindate IS INITIAL.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky               = ls_travel-%tky
                        %state_area        = 'VALIDATE_DATES'
                         %msg                = NEW /dmo/cm_flight_messages(
                                                                textid = /dmo/cm_flight_messages=>enter_begin_date
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-begindate = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
      IF ls_travel-enddate IS INITIAL.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky               = ls_travel-%tky
                        %state_area        = 'VALIDATE_DATES'
                         %msg                = NEW /dmo/cm_flight_messages(
                                                                textid = /dmo/cm_flight_messages=>enter_end_date
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-enddate   = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
      IF ls_travel-enddate < ls_travel-begindate AND ls_travel-begindate IS NOT INITIAL
                                                 AND ls_travel-enddate IS NOT INITIAL.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky               = ls_travel-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW /dmo/cm_flight_messages(
                                                                textid = /dmo/cm_flight_messages=>begin_date_bef_end_date
                                                                begin_date = ls_travel-begindate
                                                                end_date   = ls_travel-enddate
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-begindate = if_abap_behv=>mk-on
                        %element-enddate   = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
      IF ls_travel-begindate < cl_abap_context_info=>get_system_date( ) AND ls_travel-begindate IS NOT INITIAL.
        APPEND VALUE #( %tky               = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky               = ls_travel-%tky
                        %state_area        = 'VALIDATE_DATES'
                         %msg                = NEW /dmo/cm_flight_messages(
                                                                begin_date = ls_travel-begindate
                                                                textid = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-begindate = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateStatus.
   READ ENTITIES OF ZEY_AO_I_M_TRAVEL IN LOCAL MODE
    ENTITY Travel
    FIELDS (  status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_result)
    FAILED DATA(lt_failed).

        LOOP AT lt_travel_result INTO DATA(ls_travel_result).
          CASE ls_travel_result-status.
            WHEN 'O'.  " Open
            WHEN 'X'.  " Cancelled
            WHEN 'A'.  " Accepted
            WHEN 'N'.  " New
            WHEN OTHERS.

              APPEND VALUE #( %tky = ls_travel_result-%tky ) TO failed-travel.

              APPEND VALUE #( %tky = ls_travel_result-%tky
                              %msg = new_message_with_text(
                                       severity = if_abap_behv_message=>severity-error
                                       text     = 'Invalid Status'
                                     )
                              %element-status = if_abap_behv=>mk-on ) TO reported-travel.
          ENDCASE.

        ENDLOOP.
  ENDMETHOD.


  METHOD earlynumbering_create.
" Mapping for already assigned travel IDs (e.g. during draft activation)
     mapped-travel = VALUE #( FOR entity IN entities WHERE ( travelid IS NOT INITIAL )
                                                          ( %cid      = entity-%cid
                                                            %is_draft = entity-%is_draft
                                                            %key      = entity-%key ) ).

    " This should be a number range. But for the demo purpose, avoiding the need to configure this in each and every system, we select the max value ...

    SELECT MAX( travel_id ) FROM /dmo/travel INTO @DATA(max_travel_id).
    SELECT MAX( travelid ) FROM zey_ao_d_trav INTO @DATA(max_d_travel_id).

    IF max_d_travel_id > max_travel_id.  max_travel_id = max_d_travel_id.  ENDIF.

    " Mapping for newly assigned travel IDs
    mapped-travel = VALUE #( BASE mapped-travel FOR entity IN entities INDEX INTO i
                                                    USING KEY entity
                                                    WHERE ( travelid IS INITIAL )
                                                          ( %cid      = entity-%cid
                                                            %is_draft = entity-%is_draft
                                                            travelid  = max_travel_id + i ) ).

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
        DATA: max_booking_id TYPE /dmo/booking_id.

    READ ENTITIES OF ZEY_AO_I_M_TRAVEL IN LOCAL MODE
      ENTITY Travel BY \_Bookings
        FIELDS ( bookingid )
          WITH CORRESPONDING #( entities )
          RESULT DATA(bookings)
          FAILED failed.

    LOOP AT entities INTO DATA(entity).
      CLEAR: max_booking_id.
      LOOP AT bookings INTO DATA(booking) USING KEY draft WHERE %is_draft = entity-%is_draft
                                                          AND   travelid  = entity-Travelid.
        IF booking-Bookingid > max_booking_id.
            max_booking_id = booking-Bookingid.
        ENDIF.
      ENDLOOP.
      " Map bookings that already have a BookingID.
      LOOP AT entity-%target INTO DATA(already_mapped_target) WHERE Bookingid IS NOT INITIAL.
        APPEND CORRESPONDING #( already_mapped_target ) TO mapped-booking.
        IF already_mapped_target-Bookingid > max_booking_id.
            max_booking_id = already_mapped_target-Bookingid.
        ENDIF.
      ENDLOOP.
      " Map bookings with new BookingIDs.
      LOOP AT entity-%target INTO DATA(target) WHERE Bookingid IS INITIAL.
        max_booking_id += 5.
        APPEND CORRESPONDING #( target ) TO mapped-booking ASSIGNING FIELD-SYMBOL(<mapped_booking>).
        <mapped_booking>-Bookingid = max_booking_id.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
