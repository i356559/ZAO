@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Master data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEY_AO_U_CUSTOMER as select from /dmo/customer as Customer 
association[1] to I_Country as _Country on
$projection.CountryCode = _Country.Country
{
    key customer_id as CustomerId,
    first_name as FirstName,
    last_name as LastName,
    title as Title,
    street as Street,
    postal_code as PostalCode,
    city as City,
    country_code as CountryCode,
    phone_number as PhoneNumber,
    email_address as EmailAddress,
    _Country
}
