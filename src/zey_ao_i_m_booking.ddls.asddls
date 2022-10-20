@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity for composition with Travel'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEY_AO_I_M_BOOKING as select from /dmo/booking as Booking
composition[0..*] of ZEY_AO_I_M_BOOK_SUPPL as _BookSuppl 
association to parent ZEY_AO_I_M_TRAVEL as _Travel on
$projection.TravelId = _Travel.TravelId
association[1..1] to ZEY_AO_U_CUSTOMER as _Customer on 
$projection.CustomerId = _Customer.CustomerId
association[1..1] to /DMO/I_Carrier as _Carrier on
$projection.CarrierId = _Carrier.AirlineID
association[1..1] to /DMO/I_Connection as _Connection on
$projection.CarrierId = _Connection.AirlineID and
$projection.ConnectionId = _Connection.ConnectionID
{
    key Booking.travel_id as TravelId,
    key Booking.booking_id as BookingId,
    Booking.booking_date as BookingDate,
    Booking.customer_id as CustomerId,
    Booking.carrier_id as CarrierId,
    Booking.connection_id as ConnectionId,
    Booking.flight_date as FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Booking.flight_price as FlightPrice,
    Booking.currency_code as CurrencyCode,
    @UI.hidden: true
    _Travel.Lastchangedat,
    _Travel,
    _Customer,
    _Carrier,
    _Connection,
    _BookSuppl
    
    
}
