<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	//班组检查表主键
	String inspectionTeamId = request.getParameter("inspectionTeamId");
	//班组
	String teamId = request.getParameter("teamId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
	<title>单机检查</title>
</head>

<body style="background: #cdddef">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
					  			<td class="ali_cdn_name">实物标识号：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_dev_sign" name="dev_sign" type="text" class="input_width" />
					   			</td>
					  			<td class="ali_cdn_name">自编号：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_self_num" name="self_num" type="text" class="input_width" />
					   			</td>
					  			<td class="ali_cdn_name">牌照号：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_license_num" name="license_num" type="text" class="input_width" />
					   			</td>
				  				<td class="ali_query">
				   					<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								</td>
								<td class="ali_query">
							 		<span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
								</td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
								<auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title="返回"></auth:ListButton>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td style="width:40px;" class="bt_info_odd" exp="<input type='radio' name='rdo_entity_id' value='{dev_acc_id}_{dev_type}_{dev_state}_{inspection_id}' id='rdo_entity_id_{dev_acc_id}'/>" >选择</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_state_name}">检查状态</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
						</label>
					</td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
	</div>
</body>
<script type="text/javascript">
	function frameSize(){
		$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-5);
	}
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
	});
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.pageSize = "20";
	cruConfig.queryService = "DevTeamCheckSrv";
	cruConfig.queryOp = "queryDevCheckList";
	var path = "<%=contextPath%>";
	var inspectionTeamId="<%=inspectionTeamId%>";
	var teamId="<%=teamId%>";
	// 复杂查询
	function refreshData(q_dev_sign,q_self_num,q_license_num){
		var temp = "inspectionTeamId="+inspectionTeamId+"&teamId="+teamId;
		if(typeof q_dev_sign!="undefined" && q_dev_sign!=""){
			temp += "&devSign="+q_dev_sign;
		}
		if(typeof q_self_num!="undefined" && q_self_num!=""){
			temp += "&selfNum="+q_self_num;
		}
		if(typeof q_license_num!="undefined" && q_license_num!=""){
			temp += "&licenseNum="+q_license_num;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}
	
	refreshData("","","");
	
	
	//简单查询
	function simpleSearch(){
	 	var q_dev_sign = $("#q_dev_sign").val(); 
	 	var q_self_num = $("#q_self_num").val(); 
	 	var q_license_num = $("#q_license_num").val(); 
		refreshData(q_dev_sign,q_self_num,q_license_num);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("q_dev_sign").value = "";
		document.getElementById("q_self_num").value = "";
		document.getElementById("q_license_num").value = "";
		refreshData("","","");
	}
	refreshData();
	//双击事件
	function dbclickRow(ids){	
		//cruConfig.submitStr = "per_id="+ids;	
		//queryData(1);
	}
	function toBack(){
		window.location.href='<%=contextPath %>/rm/dm/devTeamCheck/devTeamCheckList.jsp';	
	}
	//增加
	function toAdd(){ 
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请选择记录!");
	     	return;
	    }
	    var devAccId=ids.split("_")[0];//设备台账id
	    var devType=ids.split("_")[1];//设备类型
	    var devState=ids.split("_")[2];//检查状态
	    if("0"==devState){
	    	///轻便钻机检查:S060102,推土机检查:S070301,车装钻机检查 :S060101,S060199,运输车辆检查:S08(不含S0808),发电机组:S0901,运输船舶:S0808（不含S080805 ）,挂机:S08080501,可控震源:S0623
			if ((-1 != devType.indexOf("S060102"))
					|| (-1 != devType.indexOf("S070301"))
					|| (-1 != devType.indexOf("S060101"))
					|| (-1 != devType.indexOf("S060199"))
					|| ((-1 != devType.indexOf("S08")) && (-1==devType
							.indexOf("S0808")))
					|| (-1 != devType.indexOf("S0901"))
					|| ((-1 != devType.indexOf("S0808")) && (-1 == devType
							.indexOf("S080805")))
					|| (-1 != devType.indexOf("S08080501"))
					|| (-1 != devType.indexOf("S0623"))) {
				popWindow('<%=contextPath%>/rm/dm/devTeamCheck/singleDevCheckEdit.jsp?inspectionTeamId='+inspectionTeamId+'&devAccId='+devAccId+'&devType='+devType);
			}else{
				alert("只能检查设备型号为:轻便钻机,推土机,车装钻机,运输车辆,发电机组,运输船舶,挂机,可控震源的设备！");
			}
	    }else{
	    	alert("该设备已检查,请选择未检查设备！");
	    }
	}
	//删除
	function toDelete(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
	    	alert("请选择记录!");
	     	return;
	    }
	    var devState=ids.split("_")[2];//检查状态
	    var inspectionId=ids.split("_")[3];//单机检查id
	    if("0"==devState){
	    	alert("该设备未检查，不能删除！");
	    }else{
	    	if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevTeamCheckSrv", "deleteInspectionInfo", "id="+inspectionId);
				if(typeof retObj.operationFlag!="undefined"){
					var dOperationFlag=retObj.operationFlag;
					if(''!=dOperationFlag){
						if("failed"==dOperationFlag){
							alert("删除失败！");
						}	
						if("success"==dOperationFlag){
							alert("删除成功！");
							queryData(cruConfig.currentPage);
						}
					}
				}
			}
	    }
	}
</script>
</html>

