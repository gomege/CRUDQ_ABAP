METHOD /iwbep/if_mgw_appl_srv_runtime~get_entityset.
*"----------------------------------------------------------------------
*" Autor.........: Carlo Martines
*" Firma.........: Flexus AG
*" Angelegt am...: 08.02.2021
*"----------------------------------------------------------------------
*" Beschreibung:
*" Request Header für spätere sichern
*"----------------------------------------------------------------------
*" Datum       Autor     Info
*"----------------------------------------------------------------------
*"
*"----------------------------------------------------------------------

    DATA lr_dp_facade TYPE REF TO /iwbep/if_mgw_dp_facade.
    
      lr_dp_facade = /iwbep/if_mgw_conv_srv_runtime~get_dp_facade( ).
      /flexus/cl_http_session=>gt_http_header = lr_dp_facade->get_request_header( ).
    
      super->/iwbep/if_mgw_appl_srv_runtime~get_entityset(
        EXPORTING iv_entity_name               = iv_entity_name
                  iv_entity_set_name           = iv_entity_set_name
                  iv_source_name               = iv_source_name
                  it_filter_select_options     = it_filter_select_options
                  it_order                     = it_order
                  is_paging                    = is_paging
                  it_navigation_path           = it_navigation_path
                  it_key_tab                   = it_key_tab
                  iv_filter_string             = iv_filter_string
                  iv_search_string             = iv_search_string
                  io_tech_request_context      = io_tech_request_context
        IMPORTING er_entityset                 = er_entityset
                  es_response_context          = es_response_context ).
    
      CLEAR /flexus/cl_http_session=>gt_http_header.
    
ENDMETHOD.