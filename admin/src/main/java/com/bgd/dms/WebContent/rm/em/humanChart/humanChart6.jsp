<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>

<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<div id="chart_CA7EB486972140DAE0430A15082C40DA" style="width:100%;height:100%;">
<table id="ageMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						    	<tr class="bt_info">
						    	    <td>学历</td>
						            <td>人数</td>
						        </tr>            
					        </table>
</div>

<script type="text/javascript">
var querySql = "select d.coding_name label,count(p.EMPLOYEE_ID) value from view_human_project_relation p left join comm_coding_sort_detail d on p.EMPLOYEE_EDUCATION_LEVEL=d.coding_code_id  where  p.PROJECT_INFO_NO='"+projectInfoNo+"' and p.EMPLOYEE_EDUCATION_LEVEL is not null group by d.coding_name";
var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
var datas = queryRet.datas;

if(datas != null){
	for (var i = 0; i< queryRet.datas.length ; i++) {
		
	var tr = document.getElementById("educationMap").insertRow();		
		
   	if(i % 2 == 1){  
   		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}
		
		var td = tr.insertCell(0);
		td.innerHTML = datas[i].label;
		
		var td = tr.insertCell(1);
		td.innerHTML = datas[i].value;				
	}
}	

</script> 
