<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Date"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String orgName = user.getOrgName();
	String str = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date()); 
	String org_id = user.getOrgId();
	String owning_org_id = "";
	if(org_id!=null&&(org_id.equals("C6000000000039")||org_id.equals("C6000000000040")||org_id.equals("C6000000005275")||org_id.equals("C6000000005277")||org_id.equals("C6000000005278")||org_id.equals("C6000000005279")||org_id.equals("C6000000005280"))){
		owning_org_id = org_id;
	}else{
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body >
<form name="form1" id="form1" method="post"
	action="">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
<table border="0" cellpadding="0" cellspacing="0"class="tab_line_height" width="100%">
	<tr>
    	<td colspan="6" align="center">单机退库</td>
    </tr>
	<tr>
		<td class="inquire_item6">编号：</td>
		<td class="inquire_item6"><input type="text"
			name="invoices_id" id="invoices_id" class="input_width"
			value="" />
			</td>
		<td class="inquire_item6">退货时间：</td>
		<td class="inquire_item6"><input type="text" name="out_date" id="out_date"
			class="input_width"
			value="<%=str %>" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(out_date,tributton1);" />
			</td>
		<td class="inquire_item6">使用设备：</td>
		<td class="inquire_item6">
			<input type='hidden' name='device_code' id='device_code' value=''/>
			<input type='hidden' name='dev_acc_id' id='dev_acc_id' value=''/>
			<input type='text' name='device_name' id='device_name' class="input_width" >
			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevPage()"  />
		</td>
	</tr>
	<tr>
	<td class="inquire_item6">牌照号：</td>
		<td class="inquire_item6"><input type="text" name="license_num" id="license_num" class="input_width" value="" readonly="readonly"/></td>
		<td class="inquire_item6">自编号：</td>
		<td class="inquire_item6"><input type="text" name="self_num" id="self_num" class="input_width" value="" readonly="readonly"/></td>
		<td class="inquire_item6">合计金额：</td>
		<td class="inquire_item6"><input type="text" name="total_money" id="total_money"class="input_width"	value="" readonly/></td>
	</tr>
	<tr>
		<td class="inquire_item6">经办：</td>
		<td class="inquire_item6"><input type="text"
			name="operator" id="operator" class="input_width"
			value=""  /></td>
		<td class="inquire_item6">备注：</td>
		<td class="inquire_item6"><input type="text" name="note" id="note"
			class="input_width"
			value="" />
		</td>
	</tr>
</table>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input name = 'rdo_entity_id' id = 'rdo_entity_id' type='checkbox' checked='true' value='{wz_id}' onclick='loadDataDetail();sumChecked()'/>" ><input type='checkbox' name='rdo_entity_id' value='' onclick='check()'/></td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_odd" exp="{wz_id}">物资编码</td>
				<td class="bt_info_even" exp="{wz_name}">名称</td>
				<td class="bt_info_odd" exp="{wz_prickie}">计量单位</td>
				<td class="bt_info_even" exp="{out_num}">领用数量</td>
				<td class="bt_info_odd" exp="{back_num}">已退库量</td>
				<td class="bt_info_odd" exp="<input type='text' name='mat_num_{wz_id}'  style='width:40px' value='' onkeyup='loadDataDetail()'/>">退库数量</td>
				<td class="bt_info_even"exp="<input name='wz_price_{wz_id}' type='text'  style='width:40px' value='{actual_price}' onkeyup='loadDataDetail()'/>">单价</td>
				<td class="bt_info_odd"exp="<input type='text' name='total_money_{wz_id}' style='width:40px' value='{total_money}'readonly/>">金额</td>
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
</form>
</body>
<script type="text/javascript">
	var projectInfoNo = '<%=projectInfoNo%>';
	cruConfig.contextPath =  "<%=contextPath%>";
	var checkIds="";
	function refreshData(value){
		var sql ='';
		sql +="select * from (select aa.wz_id,aa.wz_name,aa.wz_prickie,aa.out_num,nvl(bb.back_num,'0') as back_num,aa.actual_price from (select i.wz_id, i.wz_name, i.wz_prickie, sum(t.mat_num) out_num, t.actual_price";
		sql+=" from gms_mat_teammat_out o";
		sql+=" inner join(gms_mat_teammat_out_detail t";
		sql+=" inner join gms_mat_infomation i";
		sql+=" on t.wz_id = i.wz_id";
		sql+=" and i.bsflag = '0') on o.teammat_out_id = t.teammat_out_id and t.bsflag = '0'";
		sql+=" where o.project_info_no = '<%=projectInfoNo%>'";
		sql+=" and o.dev_acc_id = '"+value+"'";
		sql+=" and o.bsflag = '0'";
		sql+=" group by i.wz_id, i.wz_name, i.wz_prickie,t.actual_price)aa";
		sql+=" left join(";
		sql+=" select det.wz_id,sum(det.out_num)back_num from gms_mat_out_info info left join gms_mat_out_info_detail det on info.out_info_id=det.out_info_id where info.storeroom='"+value+"' and info.project_info_no='<%=projectInfoNo%>' group by det.wz_id";
		sql+=" )bb on aa.wz_id=bb.wz_id)cc where cc.out_num>cc.back_num";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/warehouse/accept/rettrac/matOut.jsp";
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
		 else{
			document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/accept/devtrac/devMatRet.srq?laborId="+ids;
			document.getElementById("form1").submit();
		 }
	}
	function loadDataDetail(shuaId){
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var cell_7 = row[i].cells[7].firstChild.value;
			var cell_8 = row[i].cells[8].firstChild.value;
			if(cell_8!=undefined && cell_7!=undefined){
				
					if(cell_7==""){
						outNum=0;
						}
					else{
						outNum=cell_7;
						}
					
					if(cell_8==""){
						wzPrice=0;
						}
					else{
						wzPrice=cell_8;
						}
					
				row[i].cells[9].firstChild.value=outNum*wzPrice;
				totalMoney+=(Math.round((row[i].cells[9].firstChild.value)*1000)/1000);
			}
		}
		document.getElementById("total_money").value=Math.round(totalMoney*1000)/1000;
	}
	function showDevPage(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccount.jsp?org_id=<%=owning_org_id%>&projectinfono="+projectInfoNo,obj,"dialogWidth=900px;dialogHeight=500px");

		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			var deviceId = returnvalues[0];
			var deviceName = returnvalues[2];
			var selfNum = returnvalues[4];
			var licenseNum = returnvalues[6];
			
			var checkSql="select * from gms_device_account_dui where dev_acc_id='"+deviceId+"'";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas!=null&&datas!=""){
				for (var i = 0; i<datas.length; i++) {
					var deviceCode = datas[0].dev_type;		
				}
			}
			document.getElementById("device_name").value = deviceName;
			document.getElementById("device_code").value = deviceCode;
			document.getElementById("dev_acc_id").value = deviceId;
			document.getElementById("self_num").value = selfNum;
			document.getElementById("license_num").value = licenseNum;
		}
		getTeamDatas();
	}		
	
	  function getTeamDatas(){
			var dev_acc_id = document.getElementById("dev_acc_id").value;
			refreshData(dev_acc_id);
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