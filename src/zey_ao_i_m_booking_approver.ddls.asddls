@EndUserText.label: 'Booking Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo:{
    typeName: 'Booking',
    typeNamePlural: 'Bookings',
    title: {value: 'BookingId', label: 'Booking Id'},
    description: { label: 'Airline', value: 'CarrierId'}
}
@Metadata.allowExtensions: true
define view entity ZEY_AO_I_M_BOOKING_APPROVER as projection on ZEY_AO_I_M_BOOKING {
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    Lastchangedat,
    /* Associations */
    _Carrier,
    _Connection,
    _Customer,
    _Travel: redirected to parent ZEY_AO_I_M_TRAVEL_APPROVER,
    _BookSuppl: redirected to composition child ZEY_AO_I_M_BK_SUPP_APPROVER
}
