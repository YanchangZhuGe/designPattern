<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

 <title>项目页面</title> 
 </head> 
 <%---
 <body style="background:#fff" onload="refreshData();getApplyTeam();">
  --%>
    <body style="background:#fff" onload="refreshData();getApplyTeam();">
    
    
      	<div id="list_table">
      	 <%---
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>		
			  	<td  width="4%">姓名</td>
			    <td width="5%"  ><input style="width:100px;" id="s_employee_name" name="s_employee_name" value=""/></td>	
			  	<td width="5%" >&nbsp;班组</td>
			    <td width="5%" ><select style="width:100px;" id="s_apply_team" name="s_apply_team"></select></td>	
			    <td width="8%" >&nbsp;用工性质</td>
			    <td width="5%" >
			    <select style="width:100px;" id="s_employee_gz" name="s_employee_gz">
			    <option value="">请选择</option><option value="0110000019000000001">合同化员工</option><option value="0110000019000000002">市场化用工</option>
			    <option value="0110000059000000005">临时季节性用工</option><option value="0110000059000000001">再就业</option><option value="0110000059000000003">劳务用工</option>
			    </select>
			    </td>	
			    <td class="ali_query">
			    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
		        </td>
		        <td class="ali_query">
			    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
		    	</td>        
			    <td>&nbsp;</td>
			   
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>  	 
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			--%>
			<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">						  
			   <tr>
			     <td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{employee_id}-{employee_gz}' id='rdo_entity_id_{employee_id}'/>" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{employee_name}">员工姓名</td>
			  	    <td class="bt_info_odd" 	 exp="{employee_gender}" isShow="Hide" style="display:none">性别</td>
					<td class="bt_info_odd" 	 exp="{employee_cd}" isShow="Hide" style="display:none">人员编号</td>
					<td class="bt_info_odd" 	 exp="{id_code}" isShow="Hide" style="display:none">身份证号</td>
					<td class="bt_info_odd" 	 exp="{employee_birth_date}" isShow="Hide" style="display:none">出生年月</td> 
					
			      <td class="bt_info_odd" exp="{org_name}">组织机构</td>
			      <td class="bt_info_even" exp="{team_name}">班组</td>
			      <td class="bt_info_odd" exp="{work_post_name}">岗位</td>
			      <td class="bt_info_even" exp="{actual_start_date}">实际进入项目实际</td>
			      <td class="bt_info_odd" exp="{employee_gz_name}">用工性质</td>
			      
			      
			     </tr> 			        			        
			  </table>		 		  
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<%---- 
			<div class="lashen" id="line"></div>
			<div style="width:100%;height:250px">
			<iframe width="100%" height="100%" name="mes" id="mes" frameborder="0" src="" marginheight="0" marginwidth="0" >
			</iframe>
			</div>
	--%>
		 </div>
</body>
<script type="text/javascript">
function setTabBoxHeight1(){
	if(lashened==0){
		$("#table_box").css("height",$(window).height()*0.91);
	}
	$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-10);
	$("#tab_box .tab_box_content").each(function(){
		if($(this).children('iframe').length > 0){
			$(this).css('overflow-y','hidden');
		}
	});
}
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight1();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

debugger;
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var taskIds = '<%=taskId%>';
	var projectInfoNos = '<%=projectInfoNo%>';

	//alert("进入人员列表页projectInfoNos:"+projectInfoNos);
 
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var q_file_name = document.getElementById("s_employee_name").value;
			refreshData(undefined, q_file_name);
		}
	}
	

	function simpleSearch(){
		
		var s_employee_name = document.getElementById("s_employee_name").value; 
		var s_employee_gz = document.getElementById("s_employee_gz").value; 
		var s_apply_team = document.getElementById("s_apply_team").value;
		
		var str = " 1=1 ";
		if(s_employee_name!=''){
			str += " and employee_name like '%"+s_employee_name+"%' ";
		}
		if(s_employee_gz!=''){
			str += " and employee_gz like '%"+s_employee_gz+"%' ";
		}
		if(s_apply_team != ''){
			str+=" and team='"+s_apply_team+"'";
		}

		cruConfig.cdtStr = str;
		refreshData();

	}
 
	function clearQueryText(){ 
		 document.getElementById("s_employee_name").value=""; 
		 document.getElementById("s_employee_gz").value=""; 
		 document.getElementById("s_apply_team").value="";
	     cruConfig.cdtStr = "";
	}
	
	function refreshData(taskId,projectInfoNo,arrObj){
		if(taskId==undefined){
			taskId = taskIds;
		}
		if(projectInfoNo==undefined){
			projectInfoNo = projectInfoNos;
		}
 
		 var str= "select decode(t.employee_gender,'0','女','1','男') employee_gender ,t.EMPLOYEE_ID,t.EMPLOYEE_NAME,  t.ORG_NAME,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name,       t.dalei,    t.xiaolei ,T.EMPLOYEE_CD,T.ID_CODE, T.EMPLOYEE_BIRTH_DATE   from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id  left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where t.project_info_no =  '"+projectInfoNo+"' and t.actual_start_date is not null and  t.actual_end_date is null  ";
    
     	for(var key in arrObj) { 
 			//alert(arrObj[key].label+arrObj[key].value);
 			if(arrObj[key].value!=undefined && arrObj[key].value!='')
 			str += "and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
 		}
     	
	    var str1=" order by t.EMPLOYEE_GZ,t.EMPLOYEE_NAME  ";
	    str=str+str1;
		cruConfig.queryStr=str;
     	cruConfig.currentPageUrl = "/rm/em/singleHuman/humanLedger/rootPlanList.jsp";
		queryData(1); 
	 
	}

	
	var selectedTagIndex = 0;
	//var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanLedger/doc_search.jsp');
	}
	

 

    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(ids){
    	var id = ids.split("-")[0];
    	if("0110000019000000001,0110000019000000002".indexOf(ids.split("-")[1]) != -1){
    		document.getElementById("mes").src ="<%=contextPath%>/rm/em/commHumanInfo/commHumanList1.jsp?employeeId="+id+"&projectInfoNo="+projectInfoNos;		
    	}else{
    		document.getElementById("mes").src ="<%=contextPath%>/rm/em/commHumanInfo/commHumanList2.jsp?employeeId="+id+"&projectInfoNo="+projectInfoNos;		
    	}
			
	 }
	
    function getApplyTeam(){
    	var selectObj = document.getElementById("s_apply_team"); 
    	document.getElementById("s_apply_team").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);

    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");	
    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
    		var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    	}   	

    }

    

	
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
</script>
</html>