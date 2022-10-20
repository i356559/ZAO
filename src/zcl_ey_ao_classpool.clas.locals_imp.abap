*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class zcl_earth DEFINITION.

    PUBLIC SECTION.
        METHODS launch RETURNING VALUE(e_status) TYPE string.
        METHODS leave_orbit RETURNING VALUE(e_status) TYPE string.

ENDCLASS.

CLASS zcl_earth IMPLEMENTATION.

  METHOD launch.
    e_status = 'The launch was successful, Roger!!'.
  ENDMETHOD.

  METHOD leave_orbit.
    e_status = 'The Shuttle left earth orbit'.
  ENDMETHOD.

ENDCLASS.

class zcl_planet1 DEFINITION.

    PUBLIC SECTION.
        METHODS enter_orbit RETURNING VALUE(e_status) TYPE string.
        METHODS leave_orbit RETURNING VALUE(e_status) TYPE string.

ENDCLASS.

CLASS zcl_planet1 IMPLEMENTATION.

  METHOD enter_orbit.
    e_status = 'The Shuttle Entered into other planet orbit'.
  ENDMETHOD.

  METHOD leave_orbit.
    e_status = 'The Shuttle left Other planet orbit'.
  ENDMETHOD.

ENDCLASS.

class zcl_mars DEFINITION.

    PUBLIC SECTION.
        METHODS mars_menuvour RETURNING VALUE(e_status) TYPE string.
        METHODS enter_planet RETURNING VALUE(e_status) TYPE string.
        METHODS send_data_to_station RETURNING VALUE(e_status) TYPE string.

ENDCLASS.

CLASS zcl_mars IMPLEMENTATION.

  METHOD enter_planet.
    e_status = 'Orbit insertion successful'.
  ENDMETHOD.

  METHOD mars_menuvour.
    e_status = 'Starting mark manuvour for landing'.
  ENDMETHOD.

  METHOD send_data_to_station.
    e_status = 'Receiving feed from Mars - the Orange Planet'.
  ENDMETHOD.

ENDCLASS.
