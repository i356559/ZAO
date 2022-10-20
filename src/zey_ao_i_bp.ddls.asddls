@AbapCatalog.sqlViewName: 'ZEYAOIBP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Partner Basic, Interface'
define view ZEY_AO_I_BP as select from zey_ao_bpa {
    key bp_id as BpId,
    bp_role as BpRole,
    company_name as CompanyName,
    street as Street,
    city as City,
    country as Country,
    region as Region
}
