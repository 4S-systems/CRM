CREATE OR REPLACE FORCE VIEW "OFOUK_UNIT"."FORM_COSTS" ("FORM_NO", "FORM_TOTAL", "ISTLAM", "FORM_ADD_DEDUC", "ATTACHMENTS", "LAND_AREA", "LAND_PRICE", "BUILDINGS_AREA", "BUILDING_PRICE", "STAGE", "SECTION", "BUILDING_TYPE", "SAMPLE", "BUILDING_CODE", "UNIT") AS 
  SELECT distinct RESERVATION_FORM_M.reserve_form_no as form_no   ,0+isnull((select sum(instalment_value) from client_instalment a where a.reserve_form_no=RESERVATION_FORM_M.reserve_form_no   and a.date_falling_due <=today()   and a.inst_flag > 2   ),0) as form_total  ,0+isnull((select sum(instalment_value) from client_instalment a where a.reserve_form_no=RESERVATION_FORM_M.reserve_form_no   and a.inst_flag =4  ),0) as Istlam  ,  0+isnull((SELECT sum(b.VALUE *sign) FROM client_instalment a, RESERVE_DEDUC b,  DEDUC_ADD_REASONS  c  WHERE a.reserve_form_no=RESERVATION_FORM_M.reserve_form_no   and a.inst_flag > 2   and a.reserve_form_no= b.RESERVE_FORM_NO and a.INSTALMENT_SERIAL=b.INSTALMENT_SERIAL   and  b.deduc_date <=today()   and   b.D_TYPE = c.CODE  and  c.ON_FORM_TOTAL = '0' ),0) as form_add_deduc  , 0+isnull((           select sum(TOTAL_VALUE) from RESERVE_FORM_ADDED_INSTS where RESERVE_FORM_NO=RESERVATION_FORM_M.reserve_form_no),0) as attachments  , RESERVE_FORM_UNITS.LAND_AREA as LAND_AREA , RESERVE_FORM_UNITS.LAND_AREA_PRICE as LAND_PRICE , RESERVE_FORM_UNITS.BUILDINGS_AREA as BUILDINGS_AREA , RESERVE_FORM_UNITS.BUILDING_AREA_PRICE as BUILDING_PRICE   , RESERVE_FORM_UNITS.stage_CODE as stage  , RESERVE_FORM_UNITS.SECTION_CODE as section, RESERVE_FORM_UNITS.building_type as building_type, RESERVE_FORM_UNITS.sample_CODE as sample  , RESERVE_FORM_UNITS.building_code as building_code  , RESERVE_FORM_UNITS.unit_CODE as unit      FROM RESERVATION_FORM_M, RESERVE_FORM_UNITS, units_c   where RESERVATION_FORM_M.RESERVE_FORM_NO=RESERVE_FORM_UNITS.FORM_NO    and RESERVE_FORM_UNITS.unit_CODE    = UNITS_C.UNIT_CODE (+)     and RESERVE_FORM_UNITS.SAMPLE_CODE  = UNITS_C.SAMPLE_CODE (+)   and RESERVE_FORM_UNITS.STAGE_CODE   = UNITS_C.STAGE_CODE (+)       and RESERVE_FORM_UNITS.building_code= UNITS_C.BUILDING_CODE (+)   and RESERVE_FORM_UNITS.BUILDING_TYPE= UNITS_C.BUILDING_TYPE (+)      and RESERVE_FORM_UNITS.SECTION_CODE = UNITS_C.SECTION_CODE (+)  and not (RESERVE_FORM_UNITS.BUILDING_TYPE='0' and RESERVE_FORM_UNITS.SAMPLE_CODE = '0' )    union   SELECT     RESERVATION_FORM_M.reserve_form_no as form_no    ,0+isnull((select sum(instalment_value) from client_instalment a where a.reserve_form_no=RESERVATION_FORM_M.reserve_form_no   and a.date_falling_due <=today()    and a.inst_flag > 2   ),0) as form_total  ,0+isnull((select sum(instalment_value) from client_instalment a where a.reserve_form_no=RESERVATION_FORM_M.reserve_form_no   and a.inst_flag =4  ),0) as Istlam  ,  0+isnull((SELECT sum(b.VALUE *sign) FROM client_instalment a, RESERVE_DEDUC b,  DEDUC_ADD_REASONS  c  WHERE  a.reserve_form_no=RESERVATION_FORM_M.reserve_form_no and a.reserve_form_no= b.RESERVE_FORM_NO   and  b.deduc_date <=today()    and a.INSTALMENT_SERIAL=b.INSTALMENT_SERIAL   and a.inst_flag > 2   and    b.D_TYPE = c.CODE  and  c.ON_FORM_TOTAL = '0' ),0) as form_add_deduc  , 0+isnull((           select sum(TOTAL_VALUE) from RESERVE_FORM_ADDED_INSTS where RESERVE_FORM_NO=RESERVATION_FORM_M.reserve_form_no),0) as attachments  , RESERVE_FORM_UNITS.LAND_AREA , RESERVE_FORM_UNITS.LAND_AREA_PRICE   , 0 , 0      , RESERVE_FORM_UNITS.stage_CODE           , RESERVE_FORM_UNITS.SECTION_CODE           , RESERVE_FORM_UNITS.building_type as building_type  , '0'                                       , RESERVE_FORM_UNITS.building_code as building_code  , RESERVE_FORM_UNITS.unit_CODE as unit    FROM RESERVATION_FORM_M, RESERVE_FORM_UNITS, GROUND_LIST    where RESERVATION_FORM_M.RESERVE_FORM_NO=RESERVE_FORM_UNITS.FORM_NO    and RESERVE_FORM_UNITS.STAGE_CODE    = GROUND_LIST.STAGE (+)   and RESERVE_FORM_UNITS.building_code = GROUND_LIST.SAMPLE_CODE (+)   and RESERVE_FORM_UNITS.SECTION_CODE  = GROUND_LIST.SECTION (+)   and RESERVE_FORM_UNITS.building_type ='0'  AND (RESERVE_FORM_UNITS.SAMPLE_CODE ='999' OR RESERVE_FORM_UNITS.SAMPLE_CODE = '0')    order by form_no  ;


CREATE OR REPLACE FORCE VIEW "OFOUK_UNIT"."FORM_PAYMENTS" ("FORM_NO", "CCASH", "CCHECKS", "CTRANSFER") AS 
  SELECT RECEIPT_VOUCHER_DETAIL.reserve_form_no as form_no  ,(SUM(case when payment_method=1 then AMOUNT_PAYMENT else 0 end) ) as ccash   ,(SUM(case when payment_method=2 then AMOUNT_PAYMENT else 0 end) ) as cchecks   ,SUM(case when payment_method=3 then AMOUNT_PAYMENT else 0 end) as ctransfer  FROM RECEIPT_VOUCHER_DETAIL, receipt_voucher, units_c  , recpay_receipt  , client_instalment a    where RECEIPT_VOUCHER_DETAIL.RECEIPT_VOUCHER_no=receipt_voucher.receipt_voucher_no   and RECEIPT_VOUCHER_DETAIL.install_type ='1'   and RECEIPT_VOUCHER_DETAIL.UNIT_no      = UNITS_C.UNIT_CODE     (+)   and RECEIPT_VOUCHER_DETAIL.SAMPLE_no    = UNITS_C.SAMPLE_CODE   (+)   and RECEIPT_VOUCHER_DETAIL.STAGE_no     = UNITS_C.STAGE_CODE    (+)   and RECEIPT_VOUCHER_DETAIL.BUILDING_no  = UNITS_C.BUILDING_CODE (+)   and RECEIPT_VOUCHER_DETAIL.BUILDING_TYPE= UNITS_C.BUILDING_TYPE (+)   and RECEIPT_VOUCHER_DETAIL.SECTION_no   = UNITS_C.SECTION_CODE  (+)    and RECEIPT_VOUCHER_DETAIL.reserve_form_no=recpay_receipt.reserve_form_no (+)   and RECEIPT_VOUCHER_DETAIL.install_type=recpay_receipt.instal_type(+) and RECEIPT_VOUCHER_DETAIL.instalment_serial=recpay_receipt.instalment_serial(+)   and RECEIPT_VOUCHER_DETAIL.instalment_finishing=recpay_receipt.instalment_finishing(+) and RECEIPT_VOUCHER_DETAIL.check_serial=recpay_receipt.check_serial(+)   and RECEIPT_VOUCHER_DETAIL.check_type=recpay_receipt.check_type(+) and RECEIPT_VOUCHER_DETAIL.issue_year=recpay_receipt.issue_year(+)   and RECEIPT_VOUCHER_DETAIL.c_d=recpay_receipt.c_d(+) and recpay_receipt.check_type (+)<> '.' and recpay_receipt.status (+)=2  and a.reserve_form_no=RECEIPT_VOUCHER_DETAIL.reserve_form_no  and a.instalment_serial=RECEIPT_VOUCHER_DETAIL.instalment_serial  and a.install_type='1'   and a.date_falling_due <=today()   and a.inst_flag > 2     group by  RECEIPT_VOUCHER_DETAIL.reserve_form_no  order by RECEIPT_VOUCHER_DETAIL.reserve_form_no  ;

CREATE OR replace FORCE VIEW "OFOUK_UNIT"."CLIENTS_UNITS_VIEW_NEW" 
("FORM_NO", "RESERVE_FORM_DATE", "CLIENT_CODE", "STAGE_CODE", 
"STAGE_DESCRIPTION", "BUILDING_TYPE", "BUILDING_TYPE_DESCRIPTION", "UNIT_CODE", 
"BUILDING_CODE", "BUILDING_DESCRIPTION", "DATE_SIGN_CONTRACT", "BUILDINGS_AREA", 
"LAND_AREA", "CLIENT_NAME", "SALES_REP_CODE", "SALES_REP_NAME", "SUBMIT_DATE", 
"NOT_PAYED", "FORM_TOTAL", "FORM_ADD_DEDUC", "ATTACHMENTS", "CCASH", "CCHECKS", 
"CTRANSFER", "ISTLAM") 
AS 
  SELECT u.form_no, 
         m.reserve_form_date, 
         m.client_code, 
         u.stage_code, 
         stage_description, 
         u.building_type, 
         building_type_description, 
         u.unit_code, 
         u.building_code, 
         building_description, 
         m.date_sign_contract, 
         ccc.buildings_area, 
         ccc.land_area, 
         c.client_name, 
         m.sales_rep_code, 
         Sp.sales_rep_name, 
         (SELECT x.submit_date 
          FROM   unit_dates x 
          WHERE  u.stage_code = x.stage_code 
                 AND u.section_code = x.section_code 
                 AND u.sample_code = x.sample_code 
                 AND u.unit_code = x.unit_code 
                 AND u.building_code = x.building_code 
                 AND u.building_type = x.building_type) AS submit_date, 
         0 
         + Isnull((ccc.form_total + ccc.form_add_deduc ) -( Pp.ccash + 
         Pp.cchecks+ 
         Pp.ctransfer), 0)                              AS not_payed, 
         ccc.form_total, 
         ccc.form_add_deduc, 
         ccc.attachments, 
         Pp.ccash, 
         Pp.cchecks, 
         Pp.ctransfer, 
         istlam 
  FROM   reservation_form_m m 
         left join sales_representative Sp 
                ON m.sales_rep_code = Sp.sales_rep_code, 
         reserve_form_units u 
         left join form_costs ccc 
                ON ccc.form_no = u.form_no 
         left join form_payments Pp 
                ON Pp.form_no = u.form_no, 
         clients_m c, 
         stage_c st, 
         sections_c sc, 
         building_types_c bb, 
         building_c bc 
  WHERE  m.reserve_form_no = u.form_no 
         AND m.client_code = c.client_code 
         AND u.stage_code = st.stage_code 
         AND u.stage_code = sc.stage_code 
         AND u.section_code = sc.section_code 
         AND u.building_type = bb.building_type_code 
         AND u.stage_code = bc.stage_code 
         AND u.section_code = bc.section_code 
         AND u.sample_code = bc.sample_code 
         AND u.building_code = bc.building_code 
         AND u.building_type = bc.building_type_code 
  ORDER  BY u.form_no;