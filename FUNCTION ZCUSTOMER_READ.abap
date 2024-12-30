FUNCTION zcustomer_read.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_CUSTOMER_ID) TYPE SYSUUID_X16
*"  EXPORTING
*"     REFERENCE(ES_CUSTOMER) TYPE ZCUSTOMER_S
*"  EXCEPTIONS
*"     ENTRY_NOT_FOUND
*"----------------------------------------------------------------------
  SELECT SINGLE * FROM zcustomer
    WHERE customer_id = @iv_customer_id
    INTO @es_customer.
  
  IF sy-subrc NE 0.
    " Error Handling
    RAISE entry_not_found.
  ENDIF.
ENDFUNCTION.