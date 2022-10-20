CLASS lhc_ZEY_AO_I_M_TRAVEL_PROCESSO DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_create FOR MODIFY
      IMPORTING entities FOR CREATE zey_ao_i_m_travel_processor.

ENDCLASS.

CLASS lhc_ZEY_AO_I_M_TRAVEL_PROCESSO IMPLEMENTATION.

  METHOD augment_create.

  DATA: travel_create TYPE TABLE FOR CREATE ZEY_AO_I_M_TRAVEL.

    travel_create = CORRESPONDING #( entities ).
    LOOP AT travel_create ASSIGNING FIELD-SYMBOL(<travel>).
      <travel>-agencyid = '070012'.
      <travel>-status  = 'O'.
      <travel>-%control-agencyid = if_abap_behv=>mk-on.
      <travel>-%control-status = if_abap_behv=>mk-on.
    ENDLOOP.

    MODIFY AUGMENTING ENTITIES OF ZEY_AO_I_M_TRAVEL ENTITY Travel CREATE FROM travel_create.

  ENDMETHOD.

ENDCLASS.
