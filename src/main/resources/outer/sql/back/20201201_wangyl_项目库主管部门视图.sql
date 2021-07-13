--主管部门查询数据源sql
create or replace view DSY_V_ELE_AG_ZGBM as
select * from DSY_V_ELE_AG 
WHERE length(code)!=3 AND (ZWDWLX=20 or ZWDWLX=2 or ZWDWLX=1) 
AND GUID IN (SELECT superguid FROM dsy_v_ele_ag WHERE superguid is not null)