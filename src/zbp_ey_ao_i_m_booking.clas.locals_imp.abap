CLASS lhc_ZEY_AO_I_M_BOOKING DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zey_ao_i_m_booking RESULT result.
    METHODS calculatetotalflightprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR booking~calculatetotalflightprice.

ENDCLASS.

CLASS lhc_ZEY_AO_I_M_BOOKING IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF ZEY_AO_I_M_TRAVEL in LOCAL MODE
    ENTITY Booking
    FIELDS ( CarrierId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_bookings).

    result = value #( for ls_booking in lt_bookings ( %tky = ls_booking-%tky
                                                      %field-BookingId = if_abap_behv=>fc-f-read_only
                                                      %field-BookingDate = if_abap_behv=>fc-f-read_only
                                                      %field-CustomerId = cond #( when ls_booking-CarrierId = 'AA'
                                                        then if_abap_behv=>fc-f-read_only
                                                        else if_abap_behv=>fc-f-unrestricted
                                                      )

     ) ).




  ENDMETHOD.

  METHOD calculateTotalFlightPrice.

  "Step 1: Define an internal table of all amount, currency code = curr_tab
        TYPES: BEGIN OF ty_amount_per_currencycode,
                 amount        TYPE /dmo/total_price,
                 currency_code TYPE /dmo/currency_code,
               END OF ty_amount_per_currencycode.

        DATA: amount_per_currencycode TYPE STANDARD TABLE OF ty_amount_per_currencycode.

        "Step 2: Read the data for booking fee and currency = send to curr_tab
        " Read all relevant travel instances.
        READ ENTITIES OF ZEY_AO_I_M_TRAVEL IN LOCAL MODE
             ENTITY Travel
                FIELDS ( bookingfee currencycode )
                WITH CORRESPONDING #( keys )
             RESULT DATA(lt_travel).


        DELETE lt_travel WHERE currencycode IS INITIAL.

        LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel>).
          " Set the start for the calculation by adding the booking fee.
          amount_per_currencycode = VALUE #( ( amount        = <fs_travel>-bookingfee
                                               currency_code = <fs_travel>-currencycode ) ).

          "Step 3: for Each travel read the asssociated booking data flight price currency
          " Read all associated bookings and add them to the total price.
          READ ENTITIES OF ZEY_AO_I_M_TRAVEL IN LOCAL MODE
            ENTITY Travel BY \_Bookings
              FIELDS ( flightprice currencycode )
            WITH VALUE #( ( %tky = <fs_travel>-%tky ) )
            RESULT DATA(lt_booking).

          "step 4: Loop and collect the value to curr_tab
          LOOP AT lt_booking INTO DATA(booking) WHERE currencycode IS NOT INITIAL.
            COLLECT VALUE ty_amount_per_currencycode( amount        = booking-flightprice
                                                      currency_code = booking-currencycode ) INTO amount_per_currencycode.
          ENDLOOP.



          CLEAR <fs_travel>-totalprice.

          "step 5: loop at curr_tab, convert forign amounts to common currency
          LOOP AT amount_per_currencycode INTO DATA(single_amount_per_currencycode).
            " If needed do a Currency Conversion
            IF single_amount_per_currencycode-currency_code = <fs_travel>-currencycode.
            "Step 6: Total amount
              <fs_travel>-totalprice += single_amount_per_currencycode-amount.
            ELSE.
              TRY  .
                  /dmo/cl_flight_amdp=>convert_currency(
                     EXPORTING
                       iv_amount                   =  single_amount_per_currencycode-amount
                       iv_currency_code_source     =  single_amount_per_currencycode-currency_code
                       iv_currency_code_target     =  <fs_travel>-currencycode
                       iv_exchange_rate_date       =  cl_abap_context_info=>get_system_date( )
                     IMPORTING
                       ev_amount                   = DATA(total_booking_price_per_curr)
                    ).
                CATCH cx_amdp_execution_failed.

              ENDTRY.
              "Step 6: Total amount
              <fs_travel>-totalprice += total_booking_price_per_curr.
            ENDIF.
          ENDLOOP.
        ENDLOOP.

        "Step 7: Change the data in the BO
        " write back the modified total_price of travels
        MODIFY ENTITIES OF ZEY_AO_I_M_TRAVEL IN LOCAL MODE
          ENTITY travel
            UPDATE FIELDS ( totalprice )
            WITH CORRESPONDING #( lt_travel ).

  ENDMETHOD.

ENDCLASS.
