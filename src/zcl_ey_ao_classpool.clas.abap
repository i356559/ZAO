CLASS zcl_ey_ao_classpool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ey_ao_classpool IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    data(lo_earth) = new zcl_earth(  ).
    data(lo_other1) = new zcl_planet1(  ).
    data(lo_mars) = new zcl_mars( ).

    out->write( lo_earth->launch( ) ).
    out->write( lo_earth->leave_orbit( ) ).
    out->write( lo_other1->enter_orbit( ) ).
    out->write( lo_other1->leave_orbit(  ) ).
    out->write( lo_mars->enter_planet( ) ).
    out->write( lo_mars->mars_menuvour( ) ).
    out->write( lo_mars->send_data_to_station(  ) ).



  ENDMETHOD.
ENDCLASS.
