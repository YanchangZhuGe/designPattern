--2020072115_zhuangrx_是否选择专家评分（湖南）
DELETE FROM DSY_T_SYS_PARAM where d_id = '0F94B7458EB7471CAC0B1102AC8CDFF9';
insert into DSY_T_SYS_PARAM (D_ID, D_CODE, D_NAME, D_VALUE, D_DESC, SYS_ID, IS_VISIBLE, IS_EDIT, PARAM_VALUESET, PARAM_SHOWTYPE, GROUP_NAME, L_OP_USER, L_OP_DATE, AD_CODE, SET_YEAR)
values ('0F94B7458EB7471CAC0B1102AC8CDFF9', 'IS_ZJ', '是否为选择专家评分', '0', null, 'debt', '1', '1', '0#有专家进行评分+1#没有专家进行评分', '0', null, null, null, '87', '2020');
