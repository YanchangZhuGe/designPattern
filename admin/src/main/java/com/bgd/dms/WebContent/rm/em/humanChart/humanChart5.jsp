<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>

<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<div id="chart_CA7EB0BEBD5B0030E0430A15082C0030" style="width:100%;height:100%;">
<table id="ageMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						    	<tr class="bt_info">
						    	    <td>年龄</td>
						            <td>人数</td>
						        </tr>            
					        </table>
</div>

<script type="text/javascript">
var querySql1 = "select t.age label,count(t.age) value  from (select case when t.age<=25 then '25以下' when t.age>25 and t.age<=30 then '26-30岁' when t.age>30 and t.age<=35 then '31-35岁' when t.age>35 and t.age<=40 then '35-40岁' when t.age>40 and t.age<=45 then '40-45岁' when t.age>45 and t.age<=50 then '46-50岁'  when t.age>50 and t.age<=55 then '50-55岁' when t.age>55 and t.age<=60 then '56-60岁'  else '61岁以上' end age   from ( select to_char(sysdate,'yyyy')- to_char(p.EMPLOYEE_BIRTH_DATE,'yyyy') as age from view_human_project_relation p  left join comm_coding_sort_detail d on p.WORK_POST=d.coding_code_id  where  p.PROJECT_INFO_NO='"+projectInfoNo+"') t) t group by t.age";
var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
var datas1 = queryRet1.datas;

if(datas1 != null){
	for (var i = 0; i< queryRet1.datas.length ; i++) {
		
	var tr = document.getElementById("ageMap").insertRow();		
		
   	if(i % 2 == 1){  
   		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}
		
		var td = tr.insertCell(0);
		td.innerHTML = datas1[i].label;
		
		var td = tr.insertCell(1);
		td.innerHTML = datas1[i].value;				
	}
}

</script> 
