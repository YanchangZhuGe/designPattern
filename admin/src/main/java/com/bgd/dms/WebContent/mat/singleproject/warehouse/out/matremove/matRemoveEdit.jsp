<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String startDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date()); 
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	String applyDate = sdf.format(new Date());
	
	String wz_type = request.getParameter("wz_type");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/aside.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/listTable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
</head>
<body onload="refreshData()">
<form name="form1" id="form1" method="post"
	action="">
	<input type='hidden' name='laborId' id='laborId' value=''/>
	<input type="hidden" name="wz_types" id="wz_types" value="<%=wz_type%>">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%">
	<tr>
    	<td colspan="6" align="center">库存转出</td>
    </tr>
	<tr>
		<td class="inquire_item6">转出项目：</td>
		<td class="inquire_item6"><input type="text"name="project_info_no" id="project_info_no" class="input_width"value="<%=projectName %>"></input>
		</td>
		<td class="inquire_item6">转入项目：</td>
		<td class="inquire_item6">
		<input type="text"name="input_name" id="input_name" class="input_width"value="" readonly />
		<input type="hidden"name="input_org" id="input_org" class="input_width"value="" readonly />
		<input type='button' style='width:20px' value='...' onclick='showDevPage()'/>
		</td>
		<td class="inquire_item6">操作人：</td>
		<td class="inquire_item6"><input type="text" name="operator" id="operator"class="input_width"value="" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">转出时间：</td>
		<td class="inquire_item6"><input type="text"
			name="out_date" id="out_date" class="input_width"
			value="<%=startDate %>" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(out_date,tributton1);" /></td>
		<td class="inquire_item6">合计金额：</td>
		<td class="inquire_item6"><input type="text" name="total_money" id="total_money"class="input_width"value="" /></td>
		<td class="inquire_item6">接受库：</td>
	   	<td class="inquire_item6">
	   		<select id="wz_type" name="wz_type" class="select_width" onchange=''>
		   		<option value='4'>在帐物资</option>
		   		<option value='2'>可重复利用物资</option>
		   		<option value='1'>自采购物资</option>
	   		</select>
	   	</td>
	</tr>
</table>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input name = 'rdo_entity_id' id = 'rdo_entity_id' type='checkbox' checked='true' value='{wz_id}' onclick=''/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_odd" exp="{wz_id}">物资编码</td>
				<td class="bt_info_even" exp="{wz_name}">名称</td>
				<td class="bt_info_odd" exp="{wz_prickie}">单位</td>
				<td class="bt_info_even" exp="{stock_num}">剩余数量</td>
				<td class="bt_info_odd" exp="<input type='text' name='out_num_{wz_id}' id='out_num_{wz_id}' value='{stock_num}'  style='width:80px' onkeyup='loadDataDetail()'/>">转出数量</td>
				<td class="bt_info_even" exp="{wz_price}">物资单价</td>
				<td class="bt_info_odd" exp="<input type='text' name='total_money_{wz_id}' id='total_money_{wz_id}' value='{total_money}' readonly style='width:80px;'/>">金额</td>
			</tr>
		</table>
	</div>
	<table id="fenye_box_table">
			</table>
</div>
		
<div id="oper_div"><span class="bc_btn"><a href="#"
	onclick="save()"></a></span> <span class="gb_btn"><a href="#"
	onclick="newClose()"></a></span></div>
</div>
</div>
<div id="dialog-modal" title="正在执行" style="display:none;">
	请不要关闭
</div>
</form>
</body>
<script type="text/javascript">
function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>
<script type="text/javascript"><!--
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var checkIds="";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	function refreshData(value){
//		var sql ="select i.wz_id,i.coding_code_id,i.wz_name,i.wz_prickie,t.stock_num,t.actual_price,(t.stock_num*t.actual_price) total_money from gms_mat_teammat_info t inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' where t.project_info_no='<%=projectInfoNo%>' and t.stock_num>0 and t.bsflag='0'";
//		cruConfig.queryService = "MatItemSrv";
//		cruConfig.queryOp = "getRemoveLeaf";
//		queryData(1);
//		checkIds=getSelIds('rdo_entity_id');

		cruConfig.queryService = "MatItemSrv";
		
		var wz_types = document.getElementById("wz_types").value;
		debugger;
		if(wz_types!=null&&wz_types=="1"){
			document.getElementById("wz_type").value="2";
			document.getElementById("wz_type").disabled = true;
			cruConfig.queryOp = "getOtherRepOut";
		}else if(wz_types!=null&&wz_types=="2"){
			document.getElementById("wz_type").value="1";
			document.getElementById("wz_type").disabled = true;
			cruConfig.queryOp = "getOtherPurOut";
		}else{
			cruConfig.queryOp = "getOtherGantOut";
		}
		cruConfig.submitStr = "";
		queryData(1);
		loadDataDetail();
		
	}							
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
		 if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
		 }
		 var input_org = document.getElementById("input_org").value;
		 if(input_org==""){
			 alert("请选择转入项目!");
			 return;
		 }
			document.getElementById("laborId").value = ids;
			var wzType = document.getElementById("wz_type").value;
			if(loadDataDetail()){
			document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/out/matremove/saveRemove.srq?wzType="+wzType;
			document.getElementById("form1").submit();
			openMask();
			}
	}
//	function showDevPage(){
//		popWindow('<%=contextPath%>/mat/singleproject/warehouse/out/matremove/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view','800:600');
//   }
 function showDevPage(){
			ret =  window.showModalDialog("<%=contextPath%>/mat/singleproject/warehouse/out/matremove/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view",null,"dialogWidth=800px;dialogHeight=600px");
			if(ret!=null){
				getMessage(ret);
			}				
		}
	 function getMessage(arg){
		 var datas = "";
		 for(var i=0;i<arg.length;i++){
				datas +=arg[i];
				}
		var returnvalues = datas.split('@');
		alert(returnvalues);
		var name = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
		var id = returnvalues[1].substr(returnvalues[1].indexOf(':')+1);
		document.getElementById("input_name").value = name;
		document.getElementById("input_org").value = id;
	 	}
	 function loadDataDetail(shuaId){
			var tab =document.getElementById("queryRetTable");
			var totalMoney=0;
			var flag = true;
			var row = tab.rows;
			
			var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

			for(var i=1;i<row.length;i++){
				if(row[i].cells[0].firstChild.checked==true){
					var cell_5 = row[i].cells[5].innerHTML;
					var cell_6 = row[i].cells[6].firstChild.value;
					var cell_7 = row[i].cells[7].innerHTML;
					var cell_8 = row[i].cells[8].firstChild.value;
					debugger;
					if(cell_6==""||cell_6==undefined){
						cell_6 = 0;
					}
					if(cell_7=="&nbsp;"){
						cell_7 = 0;
					}
					if(cell_5=="&nbsp;"){
						cell_5 = 0;
					}
					
				    if (!re.test(cell_6))
				   {
				       alert("第"+i+"行转出数量请输入数字!");
				       flag = false;
						return;
				    }
					
					if(Number(cell_6)>Number(cell_5)){
						alert("第"+i+"行转出数量已大于剩余数量,请修改!");
						flag = false;
						return;
					}
					cell_8 = row[i].cells[8].firstChild.value = Math.round((Number(cell_6)*Number(cell_7))*1000)/1000;
					
					if(cell_8 == ""||cell_8==undefined){
						totalMoney+=0;
						}
					else{
						totalMoney+=Number(cell_8);
					}
				}
			}
			document.getElementById("total_money").value=Math.round((totalMoney)*1000)/1000;
			return flag;
		}

	function openMask(){
		$( "#dialog-modal" ).dialog({
			height: 140,
			modal: true,
			draggable: false
		});
	}
	var checked = false;
  	function check(){
		var chk = document.getElementsByName("rdo_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
</script>
</html>