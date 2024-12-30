METHOD customerset_get_entityset.
  "Create ranges for collecting all the filters that are part of the request.
  DATA: lra_first TYPE RANGE OF ad_namefir, "range table
        wa_first LIKE LINE OF lra_first,
        lra_last TYPE RANGE OF ad_namelas, "range table
        wa_last LIKE LINE OF lra_last,
        lra_email TYPE RANGE OF e_email, "range table
        wa_email LIKE LINE OF lra_email,
        lra_gender TYPE RANGE OF bp_sex, "range table
        wa_gender LIKE LINE OF lra_gender,
        lv_order_by TYPE string.

  "Get access to query parameters like sorter and filter which are part of the request.
  DATA(lr_filter) = io_tech_request_context->get_filter().
  DATA(lr_filter_select_options) = lr_filter->get_filter_select_options().
  DATA(lt_order_by) = io_tech_request_context->get_orderby().

  "If there are any filters loop over all the filters and create ranges for follow up read request.
  LOOP AT lr_filter_select_options INTO DATA(ls_filter_select_options).
    "If a filter for the property Firstname was sent as a request, we'll handle this request in the follwoing IF statement.
    IF ls_filter_select_options-property EQ 'FIRSTNAME'.
      LOOP AT ls_filter_select_options-select_options INTO DATA(ls_select_option).
        wa_first-sign = ls_select_option-sign.
        wa_first-option = ls_select_option-option.
        wa_first-low = ls_select_option-low.
        wa_first-high = ls_select_option-high.
        APPEND wa_first TO lra_first.
      ENDLOOP.
    ELSEIF ls_filter_select_options-property EQ 'LASTNAME'.
      LOOP AT ls_filter_select_options-select_options INTO ls_select_option.
        wa_last-sign = ls_select_option-sign.
        wa_last-option = ls_select_option-option.
        wa_last-low = ls_select_option-low.
        wa_last-high = ls_select_option-high.
        APPEND wa_last TO lra_last.
      ENDLOOP.
    ELSEIF ls_filter_select_options-property EQ 'EMAIL'.
      LOOP AT ls_filter_select_options-select_options INTO ls_select_option.
        wa_email-sign = ls_select_option-sign.
        wa_email-option = ls_select_option-option.
        wa_email-low = ls_select_option-low.
        wa_email-high = ls_select_option-high.
        APPEND wa_email TO lra_email.
      ENDLOOP.
    ELSEIF ls_filter_select_options-property EQ 'GENDER'.
      LOOP AT ls_filter_select_options-select_options INTO ls_select_option.
        wa_gender-sign = ls_select_option-sign.
        wa_gender-option = ls_select_option-option.
        wa_gender-low = ls_select_option-low.
        wa_gender-high = ls_select_option-high.
        APPEND wa_gender TO lra_gender.
      ENDLOOP.
    ENDIF.
  ENDLOOP.

  "Extract the query parameters regarding sorting
  LOOP AT lt_order_by INTO DATA(ls_order_by).
    lv_order_by = |{ lv_order_by } { ls_order_by-property }|.
    IF ls_order_by-order = 'asc'.
      lv_order_by = |{ lv_order_by } ASCENDING|.
    ELSEIF ls_order_by-order = 'desc'.
      lv_order_by = |{ lv_order_by } DESCENDING|.
    ENDIF.
  ENDLOOP.

  "Perform the select request on the database table using the extracted parameters.
  SELECT * FROM zcustomer INTO TABLE @DATA(lt_customers)
    WHERE lastname IN @lra_last
      AND firstname IN @lra_first
      AND gender IN @lra_gender
      AND email IN @lra_email
    ORDER BY (lv_order_by).

  "Assign the internal table to the parameter ET_ENTITYSET. This data will be sent back to the consumer, who requested the data.
  et_entityset = lt_customers.
ENDMETHOD.