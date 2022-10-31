*&---------------------------------------------------------------------*
*& Report  Z_ALV_TEST
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report z_alv_test.
*doing all the necessary declarations.*
class my_alv definition deferred.
data: alvd     type ref to my_alv,
      alv_cont type ref to cl_gui_docking_container,
      alv_grid type ref to cl_gui_alv_grid,
      layout   type lvc_s_layo,
      sel_carr type sflight-carrid.
selection-screen: begin of block block_1 with frame title text-001.
select-options: s_carrid for sel_carr.
selection-screen: end   of block block_1.
class my_alv definition.
  public section.
    data: rec_data type standard table of sflight.
    methods: fetch_data ,
      display_data,

      user_command for event user_command of cl_gui_alv_grid
        importing e_ucomm.
endclass.

class my_alv implementation.
  method fetch_data.
    select * from sflight into table rec_data where carrid in s_carrid.
    if sy-dbcnt = 0.
      message s398(00) WITH 'No data selected'.
    endif.
    export data = me->rec_data to memory id sy-cprog.
  endmethod.
  method display_data.
    data: variant type disvariant,
          repid   type sy-repid.
    import data = me->rec_data from memory id sy-cprog.
    free memory id sy-cprog.
    check me->rec_data is not initial.
    repid = sy-repid.
    variant-report = sy-repid.
    variant-username = sy-uname.
    layout-zebra = 'X'.
    check alv_cont is initial.
    create object alv_cont
      exporting
*       parent    =
        repid     = repid
        dynnr     = sy-dynnr
        side      = alv_cont->dock_at_bottom
        extension = 200
*       style     =
*       lifetime  = lifetime_default
*       caption   =
*       metric    = 0
*       ratio     =
*       no_autodef_progid_dynnr     =
*       name      =
*      exceptions
*       cntl_error                  = 1
*       cntl_system_error           = 2
*       create_error                = 3
*       lifetime_error              = 4
*       lifetime_dynpro_dynpro_link = 5
*       others    = 6
      .
    if sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    create object alv_grid
      exporting
*       i_shellstyle      = 0
*       i_lifetime        =
        i_parent = alv_cont
*       i_appl_events     = space
*       i_parentdbg       =
*       i_applogparent    =
*       i_graphicsparent  =
*       i_name   =
*       i_fcat_complete   = SPACE
*      exceptions
*       error_cntl_create = 1
*       error_cntl_init   = 2
*       error_cntl_link   = 3
*       error_dp_create   = 4
*       others   = 5
      .
    if sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.

    set handler user_command FOR ALV_GRID.
    call method alv_grid->set_table_for_first_display
  exporting
*    i_buffer_active               =
*    i_bypassing_buffer            =
*    i_consistency_check           =
     i_structure_name              = 'SFLIGHT'
     is_variant                    = variant
     i_save                        = 'U'
*    i_default                     = 'X'
     is_layout                     = layout
*    is_print                      =
*    it_special_groups             =
*    it_toolbar_excluding          =
*    it_hyperlink                  =
*    it_alv_graphics               =
*    it_except_qinfo               =
*    ir_salv_adapter               =
      changing
        it_outtab =          me->rec_data
*       it_fieldcatalog               =
*       it_sort   =
*       it_filter =
*  exceptions
*       invalid_parameter_combination = 1
*       program_error                 = 2
*       too_many_lines                = 3
*       others    = 4
      .
    if sy-subrc <> 0.
* Implement suitable error handling here
    endif.



  endmethod.
  method user_command.
    if e_ucomm = ' '.

    endif.
  endmethod.
endclass.
INITIALIZATION.
CREATE OBJECT alvd.
CALL METHOD alvd->display_data.
START-OF-SELECTION.
CALL METHOD ALVD->fetch_data.
