METHOD customerset_get_entity.
  "Prepare some variables that will be used throughout this coding.
  DATA: ls_key_values LIKE er_entity,
        ls_customer  LIKE er_entity,
        lv_customer_uuid TYPE sysuuid_x16,
        lv_msg_type TYPE symsgty,
        lv_msg_text TYPE bapi_msg.

  "Extract the primary key(s) from the request to know which data should be read from the table.
  io_tech_request_context->get_converted_keys(
    IMPORTING
      es_key_values = ls_key_values
  ).

  "Perform the read request, which is outsourced in a function call.
  lv_customer_uuid = ls_key_values-customer_id.
  CALL FUNCTION 'ZCUSTOMER_READ'
    EXPORTING
      iv_customer_id = lv_customer_uuid
    IMPORTING
      es_customer = ls_customer
    EXCEPTIONS
      entry_not_found = 1
      OTHERS = 2.

  "Error handling, if the entry is not found or some other error occurs.
  IF sy-subrc <> 0.
    lv_msg_type = 'E'.
    IF sy-subrc = 1.
      lv_msg_text = 'Customer not found'.
    ELSE.
      lv_msg_text = 'An error occurred'.
    ENDIF.
    mo_context->get_message_container( )->add_message_text_only(
      iv_msg_type = lv_msg_type
      iv_msg_text = lv_msg_text
    ).
    "Raise a business exception by sending a proper error message back to the consumer.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        textid = /iwbep/cx_mgw_busi_exception=>business_error
        message_container = mo_context->get_message_container( ).
  ENDIF.

  "Assign the data that was saved into the ls_customer to the parameter er_entity.
  "This data will be sent back to the consumer.
  er_entity = ls_customer.
ENDMETHOD.