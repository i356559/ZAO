@EndUserText.label: 'Projection on booking supplements'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZEY_AO_I_M_BK_SUPP_APPROVER as projection on ZEY_AO_I_M_BOOK_SUPPL {
    @Search.defaultSearchElement: true
    key TravelId,
    @Search.defaultSearchElement: true
    key BookingId,
    @Search.defaultSearchElement: true
    key BookingSupplementId,
    SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    CurrencyCode,
    /* Associations */
    _Bookings : redirected to parent ZEY_AO_I_M_BOOKING_APPROVER,
    _Travel
}
