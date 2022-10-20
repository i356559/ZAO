CLASS zey_aspr_test_rap_bo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    data lv_type TYPE c VALUE 'R'.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zey_aspr_test_rap_bo IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  case lv_type.
  WHEN 'R'.
     READ ENTITIES OF ZEY_Aspr_I_U_TRAVEL
            ENTITY Travel
            ALL FIELDS WITH
            value #( ( TravelId = '888111' ) )
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
WHEN 'C'.

WHEN 'U'.

WHEN 'D'.
        ENDCASE.
  ENDMETHOD.
ENDCLASS.
