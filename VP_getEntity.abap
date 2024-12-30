METHOD /iwbep/if_mgw_appl_srv_runtime~get_entity.
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
    
      super->/iwbep/if_mgw_appl_srv_runtime~get_entity(
        EXPORTING iv_entity_name               = iv_entity_name
                  iv_entity_set_name           = iv_entity_set_name
                  iv_source_name               = iv_source_name
                  it_key_tab                   = it_key_tab
                  it_navigation_path           = it_navigation_path
                  io_tech_request_context      = io_tech_request_context
        IMPORTING er_entity                    = er_entity
                  es_response_context          = es_response_context ).
    
      CLEAR /flexus/cl_http_session=>gt_http_header.
    
    ENDMETHOD.