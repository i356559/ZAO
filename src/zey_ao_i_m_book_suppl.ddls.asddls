@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplements'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEY_AO_I_M_BOOK_SUPPL as select from /dmo/book_suppl as BookSuppl
association to parent ZEY_AO_I_M_BOOKING as _Bookings
on $projection.TravelId = _Bookings.TravelId and
   $projection.BookingId = _Bookings.BookingId
association[1] to ZEY_AO_I_M_TRAVEL as _Travel
on $projection.TravelId = _Travel.TravelId   
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
    _Travel,
    _Bookings
    
}
