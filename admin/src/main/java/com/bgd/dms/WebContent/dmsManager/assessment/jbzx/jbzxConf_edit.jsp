<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	//点击打开页面时responseDTO为空，当保存编辑页面跳转到该页面时responseDTO不为空
	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
	String operationFlag ="";
	if(null!=responseDTO){
		operationFlag = responseDTO.getValue("operationFlag");
	}
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
	<title>设备物资降本增效五项指标配置信息</title>
	<style type="text/css">
		.tab_info td{
			font:100% Arial, Helvetica, sans-serif; 
			line-height: 30px;
			border:1px solid #fff;
		}
		th{
			background:#1E90FF;color:#fff;
			}
		th{text-align:center;padding:.5em;border:1px solid #fff;}
		tab_info {
			FONT-SIZE: 12px;
			height:30px;
			BORDER: #aebbcb 1px solid;
			line-height: 30px;
			width:100%;
			margin-top:2px;
		}
		.tab_info TD {
			FONT-SIZE: 12px;
			height:30px;
			line-height: 30px;
			word-break:keep-all;
			white-space:nowrap;
		}
		
		.bt_info_odd {
			FONT-SIZE: 12px;
			COLOR: #296184;
			font-family:"微软雅黑", Arial, Helvetica, sans-serif;
			font-weight:normal;
			text-align: center;
			vertical-align: middle;
			height:30px;
			line-height: 30px;
			background:#96baf6
		}
		.bt_info_even {
			FONT-SIZE: 12px;
			COLOR: #296184;
			font-family:"微软雅黑", Arial, Helvetica, sans-serif;
			font-weight:normal;
			text-align: center;
			vertical-align: middle;
			height:30px;
			line-height: 30px;
			background:#a4c7ff
		}
	</style>
</head>

<body style="background:#cdddef"  scroll="no">
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/assess/jbzx/saveOrUpdateJbzxConfInfo.srq" enctype="multipart/form-data">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="保存"></auth:ListButton>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box_0" style="overflow-x:hidden;overflow-y:auto;">
			<table  style="table-layout:fixed" width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id="queryRetTable_0">
				<tr>
					<td width="5%" class="bt_info_odd">序号</td>
					<td width="20%" class="bt_info_even">单位</td>
					<td width="20%" class="bt_info_odd">指标名称</td>
					<td width="15%" class="bt_info_even">基础数据(元)</td>
					<td width="25%" class="bt_info_odd">全年考核内容</td>
					<td width="15%" class="bt_info_even">控制目标（万元）</td>
				</tr>
			</table>
		</div>
	</form>
</body>
<script type="text/javascript">
	//设置表格高度
	function frameSize(){
		$("#table_box_0").css("height",$(window).height()-$("#inq_tool_box").height()-$("#title_box_0").height()-5);
	}
	//页面初始化信息
	$(function(){
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		//加载数据
		loadDate();
		//保存操作完成后,跳转到该页面进行的判断
		var operationFlag="<%=operationFlag%>";
		if(''!=operationFlag){
			if("failed"==operationFlag){
				alert("保存失败！");
			}	
			if("success"==operationFlag){
				alert("保存成功！");
			}
		}
	});
	//加载数据
	function loadDate(){
		var retObj = jcdpCallService("IndexAssessSrv", "getJbzxConfData","");	
		//初始化编辑表格并赋值
		if(typeof retObj.datas!="undefined"){
			var datas = retObj.datas;
			insertTr("queryRetTable_0",datas);
			//修改样式
			changeTable("queryRetTable_0",1,2);
		}	
	}
	
	//指标考核表序号
	var order=1;
	function insertTr(id,datas){
		var fTable = document.getElementById(id);
		for(var i=0;i<datas.length && datas[i]!=null;i++){
			var map = datas[i];
			if(map!=null){
				with(map){
					var tr = fTable.insertRow(i+1);
					var td = tr.insertCell(0);
					td.innerHTML = order;//序号					
					td = tr.insertCell(1);
					td.innerHTML = org_name;//单位名称
					td = tr.insertCell(2);
					td.innerHTML = item_name;//指标名称
					td = tr.insertCell(3);
					td.innerHTML = "<input name='conf_id_"+order+"' id='conf_id_"+order+"' type='hidden' value='"+conf_id+"' />"+
					"<input name='org_id_"+order+"' id='org_id_"+order+"' type='hidden' value='"+org_id+"' />"+
					"<input name='org_subjection_id_"+order+"' id='org_subjection_id_"+order+"' type='hidden' value='"+org_subjection_id+"' />"+
					"<input name='item_id_"+order+"' id='item_id_"+order+"' type='hidden' value='"+item_id+"' />"+
					"<input name='basic_data_"+order+"' id='basic_data_"+order+"' type='text' style='height:20px;width:97%;' value='"+basic_data+"' onkeyup='checkNumber(this,2)' />";
					td = tr.insertCell(4);
					td.innerHTML = "<input name='assess_content_"+order+"' id='assess_content_"+order+"' type='text' style='height:20px;width:97%;' value='"+assess_content+"' />";
					td = tr.insertCell(5);
					td.innerHTML = "<input name='control_target_"+order+"' id='control_target_"+order+"' type='text' style='height:20px;width:97%;' value='"+control_target+"' onkeyup='checkNumber(this,2)' />";
				}
				order++;
			}
		}
	}
	//校验
	function checkNumber(item,precision){
		var re;
		if(2==precision){
			 re =/^-?\d+\.?\d{0,2}$/;
		}
		if(4==precision){
		 	re =/^-?\d+\.?\d{0,4}$/;
		}
		//检查所有的数量字段 
		if(!re.test(item.value)){
			alert("最多请输入"+precision+"位小数!");
			item.value = "";
		}
	}
	//修改表格样式
	function changeTable(id,rowIndex,colIndex){
		var table = document.getElementById(id);
		for(var i =rowIndex ;i<table.rows.length;i++){
			var tr = table.rows[i];
			for(var j =0 ;j<= colIndex;j++){
				tr.cells[j].align ='center';
				tr.cells[j].style.background ='#e3e3e3';
			}
		}
	}
	//提交方法
	function toSubmit(){
		var subForm = $("#form");
		subForm.submit();
	}
</script>
</html>

