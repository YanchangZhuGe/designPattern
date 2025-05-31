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
	String org_id = user.getOrgId();
	String wz_type = "";
	 if(org_id!=null&&(org_id.equals("C6000000000039")||org_id.equals("C6000000000040")||org_id.equals("C6000000005275")||org_id.equals("C6000000005277")||org_id.equals("C6000000005278")||org_id.equals("C6000000005279")||org_id.equals("C6000000005280"))){
		  wz_type = "11";
	  }else{
		  wz_type = "22";
	  }
	
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
	<input type="hidden" name="wz_types" id="wz_types" value="3">
	<input type="hidden" name="wz_type" id="wz_type" value="<%=wz_type %>"></input>
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
	</tr>
</table>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input name = 'rdo_entity_id' id = 'rdo_entity_id' type='checkbox'  value='{wz_id}' onclick='loadDataDetail()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_odd" exp="{wz_id}">物资编码</td>
<!-- 			<td class="bt_info_even" exp="{coding_code_id}">物资分类码</td>   -->
				<td class="bt_info_odd" exp="{wz_name}<input type='text' style='display:none' name='wz_name_{wz_id}' id='wz_name_{wz_id}' value='{wz_name}' />">名称</td>
				<td class="bt_info_even" exp="{wz_prickie}">单位</td>
				<td class="bt_info_odd" exp="{stock_num}">库存数量</td>
				<td class="bt_info_odd" exp="<input type='text' style='width:50px;text-align:center;' name='stock_num_{wz_id}' id='stock_num_{wz_id}' value='0' onkeyup='changenumber(this)'/>">转出数量</td>
				<td class="bt_info_even" exp="{wz_price}<input type='text' style='display:none' name='wz_price_{wz_id}' id='wz_price_{wz_id}' value='{wz_price}' />">物资单价</td>
				<td class="bt_info_odd" exp="<input type='text' style='width:60px;text-align:center;' name='total_money_{wz_id}' id='total_money_{wz_id}' value='0' />">金额</td>
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
		cruConfig.queryService = "MatItemSrv";
//		cruConfig.queryOp = "getRemoveLeaf";
//		queryData(1);
//		checkIds=getSelIds('rdo_entity_id');

			cruConfig.queryOp = "getOtherPurOutDg";
			//cruConfig.queryOp = "getOtherGantOut";
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
		 	loadDataDetail();
			document.getElementById("laborId").value = ids;
			document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouseDg/out/matremove/saveRemoveDg.srq";
			document.getElementById("form1").submit();
			openMask();
	}
//	function showDevPage(){
//		popWindow('<%=contextPath%>/mat/singleproject/warehouseDg/out/matremove/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view','800:600');
//   }
	 function showDevPage(){
			ret =  window.showModalDialog("<%=contextPath%>/mat/singleproject/warehouseDg/out/matremove/selectProject.jsp?backUrl=/pm/project/multiProject/projectList.jsp&action=view",null,"dialogWidth=800px;dialogHeight=600px");
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
		var name = returnvalues[0].substr(returnvalues[0].indexOf(':')+1);
		var id = returnvalues[1].substr(returnvalues[1].indexOf(':')+1);
		document.getElementById("input_name").value = name;
		document.getElementById("input_org").value = id;
	 	}
	function loadDataDetail(shuaId){
		
		var tab =document.getElementById("queryRetTable");
		var totalMoney=0;
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			debugger;
			if(row[i].cells[0].firstChild.checked==true){
				if(row[i].cells[8].getElementsByTagName("input")[0].value == "&nbsp;"){
					totalMoney+=0;
					}
				else{
					totalMoney+=Math.round(Number(row[i].cells[8].getElementsByTagName("input")[0].value)*1000)/1000;
				}
			}
		}
		document.getElementById("total_money").value=Math.round((totalMoney)*1000)/1000;
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
	function changenumber(number){
		//检测输入是否数字
		var re = /^[0-9]+\.?[0-9]*$/; 
	    if (!re.test(number.value))
	   {
	    	number.value=0;
	       alert("请输入数字！");
	       return true;
	    }
	    //默认总金额为0
		var totalMoney=0;
		//获得当前点击的物资金额  数量*单价=金额
		debugger;
		var money_dan=number.parentNode.parentNode.all[12].getElementsByTagName("input")[0].value; //单个总金额
		//获得当前点击物资的单价
		var wz_price = number.parentNode.parentNode.all[11].defaultValue;   
		//获得当前点击的物资库存 
		var num=number.parentNode.parentNode.all[7].innerHTML;
		//输入转出的物资转换成数字类型            
		var shu=parseInt(number.value,10);
		//判断是否大于库存
			if(parseInt(num,10)>=shu){
			totalMoney=Math.round(wz_price*shu*1000)/1000;
			}else{
				totalMoney=wz_price*parseInt(num,10);
				number.value=number.parentNode.parentNode.all[7].innerHTML; 
			}
		    //当前物资的金额   数量*单价=金额
			number.parentNode.parentNode.all[12].getElementsByTagName("input")[0].value=totalMoney;
			//获得表单的物资总金额（所有的物资）
			var money =document.getElementById("total_money").value;
			//总金额赋值
			//document.getElementById("total_money").value=Math.round(Number(money)*1000)/1000-Math.round(Number(money_dan)*1000)/1000+Math.round(Number(totalMoney)*1000)/1000;
			//判断当前输入框的转出物资数量小于等于0就默认该条物资为不选中状态
			if(number.value<=0){
				number.parentNode.parentNode.all[1].checked = false;
				}else{
					number.parentNode.parentNode.all[1].checked = true;
					}
		}
	
</script>
</html>