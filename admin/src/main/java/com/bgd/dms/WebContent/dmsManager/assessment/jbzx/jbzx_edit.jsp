<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId=user.getCodeAffordOrgID();//user.getOrgId();
	String orgSubId=user.getSubOrgIDofAffordOrg();   //user.getOrgSubjectionId();
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String id=request.getParameter("id");
	if(null==id){
		id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<title>指标上报编辑信息</title>
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
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/assess/jbzx/saveOrUpdateJbzxInfo.srq?flag=<%=flag%>" >
		<!--指标信息ID -->
		<input name="info_id" id="info_id" type="hidden"/>
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="inquire_item6">上报日期：</td>
				  				<td class="inquire_form6">
							   		<input id="assess_date" name="assess_date" type="text" class="input_width"  style="width:120px;" readonly="readonly" />
					   				<img width="20px" height="20px" id="cal_button" style="cursor: hand;" onmouseover="ymSelector('assess_date','cal_button');" src="<%=contextPath%>/images/calendar.gif" />
							  	</td>
								<td class="inquire_item6">单位：</td>
				  				<td class="inquire_form6">
				  					<!--所属单位 -->
									<input name="org_id" id="org_id" type="hidden"/>
									<!--所属机构隶属单位 -->
									<input name="org_subjection_id" id="org_subjection_id" type="hidden"/>
							   		<input id="org_name" name="org_name" type="text" class="input_width" style="width:200px;" readonly="readonly"/>
							   		<img id="org_button" src="<%=contextPath%>/images/magnifier.gif"  width="20px" height="20px" style="cursor:hand;" onclick="selectOrgInfo()" />
							  	</td>
								<td><span style="font-size:16px;color:red;">&nbsp;&nbsp;说明：累计完成值单位为万元</span></td>
								<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="上报"></auth:ListButton>
								<auth:ListButton functionId="" css="gb" event="onclick='toClose()'" title="关闭"></auth:ListButton>
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
				<tr id="table_0_h">
					<td width="5%" class="bt_info_odd">序号</td>
					<td width="35%" class="bt_info_even">指标名称</td>
					<td width="20%" class="bt_info_odd">上年基础数据(元)</td>
					<td width="20%" class="bt_info_even">控制目标（万元）</td>
					<td width="20%" class="bt_info_odd">累计完成值（万元）</td>
				</tr>
			</table>
		</div>
	</form>
</body>
<script type="text/javascript">
	//新增修改标志
	var flag="<%=flag%>"; 
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
	});
	//加载数据
	function loadDate(){
		if("add"==flag){
			//给上报日期赋值
			var _date=new Date(); 
			var y=_date.getFullYear(); 
			var m=_date.getMonth()+1; 
			m=m <10? "0"+m:m; 
			$("#assess_date").val(y + "-" + m);
			if("C105"!="<%=orgSubId%>"){
				//隐藏选择单位按钮
				$("#org_button").hide();
				//给单位赋值
				$("#org_id").val("<%=orgId%>");
				$("#org_subjection_id").val("<%=orgSubId%>");
				//显示单位名称
				var retObj = jcdpCallService("IndexAssessSrv", "getOrgName","org_sub_id=<%=orgSubId%>&org_id=<%=orgId%>");
				if(typeof retObj.data!="undefined"){
					var data = retObj.data;
					$("#org_name").val(data.org_name);
				}	
				//插入表格数据
				var retObj = jcdpCallService("IndexAssessSrv", "getAddJbzxData","org_sub_id=<%=orgSubId%>&org_id=<%=orgId%>");
				if(typeof retObj.datas!="undefined"){
					var datas = retObj.datas;
					insertTr("queryRetTable_0",datas,"add");
					//修改样式
					changeTable("queryRetTable_0",1,3);
				}	
			}
		}
		if("update"==flag){
			//隐藏选择单位按钮
			$("#org_button").hide();
			//隐藏选择日期按钮
			$("#cal_button").hide();
			var retObj = jcdpCallService("IndexAssessSrv", "getJbzxInfoData","id=<%=id%>");
			// 给指标信息ID 所属单位 所属机构隶属单位 单位名称 上报日期 赋值
			if(typeof retObj.map!="undefined"){
				var map = retObj.map;
				$.each(map, function(k, v){
					if(null!=v && ""!=v){
						$("#"+k).val(v);
					}
				});
			}	
			//初始化编辑表格并赋值
			if(typeof retObj.datas!="undefined"){
				var datas = retObj.datas;
				insertTr("queryRetTable_0",datas,"update");
				//修改样式
				changeTable("queryRetTable_0",1,3);
			}	
		}
		
	}
	
	//指标考核表序号
	var order=1;
	//插入行
	function insertTr(id,datas,flag){
		var fTable = document.getElementById(id);
		for(var i=0;i<datas.length && datas[i]!=null;i++){
			var map = datas[i];
			if(map!=null){
				with(map){
					var tr = fTable.insertRow(i+1);
					var td = tr.insertCell(0);
					td.innerHTML = order;//序号					
					td = tr.insertCell(1);
					td.innerHTML = "<a href='javascript:void(0)' onclick=popJbzkAnal('"+item_id+"')><font color='blue'>"+item_name+"</font></a>";//指标名称
					td = tr.insertCell(2);
					td.innerHTML = basic_data;//上年基础数据
					td = tr.insertCell(3);
					td.innerHTML = control_target;//control_target
					td = tr.insertCell(4);
					if("add"==flag){
						//新增时 detail_id，cumu_report为空，不进行赋值
						td.innerHTML = "<input name='detail_id_"+order+"' id='detail_id_"+order+"' type='hidden' />"+
						"<input name='conf_id_"+order+"' id='conf_id_"+order+"' type='hidden' value='"+conf_id+"' />"+
						"<input name='cumu_report_"+order+"' id='cumu_report_"+order+"' type='text' style='height:20px;width:97%;' onkeyup='checkNumber(this)' />";
					}else{
						//修改时给 detail_id，cumu_report赋值
						td.innerHTML = "<input name='detail_id_"+order+"' id='detail_id_"+order+"' type='hidden' value='"+detail_id+"' />"+
						"<input name='conf_id_"+order+"' id='conf_id_"+order+"' type='hidden' value='"+conf_id+"' />"+
						"<input name='cumu_report_"+order+"' id='cumu_report_"+order+"' type='text' style='height:20px;width:97%;' value='"+cumu_report+"' onkeyup='checkNumber(this)' />";
					}
				}
				order++;
			}
		}
	}
	//校验
	function checkNumber(item){
		var re =/^-?\d+\.?\d{0,2}$/;
		//检查所有的数量字段 
		if(!re.test(item.value)){
			alert("最多请输入2位小数!");
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
		if(null==$("#org_subjection_id").val() || ""==$("#org_subjection_id").val()){
			alert("请选择单位");
			return;
		}
		if(null==$("#assess_date").val() || ""==$("#assess_date").val()){
			alert("请选择日期");
			return;
		}
		if("add"==flag){
			//获取是否添加数据
			var assess_date=$("#assess_date").val();
			var org_id=$("#org_id").val();
			var org_sub_id=$("#org_subjection_id").val();
			var retObj = jcdpCallService("IndexAssessSrv", "getIsReportData","org_sub_id="+org_sub_id+"&org_id="+org_id+"&assess_date="+assess_date);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				if(data.iflag=='0'){
					var subForm = $("#form");
					subForm.submit();
				}else{
					alert("该单位当前年月数据已上报！");
				}
			}
		}else{
			var subForm = $("#form");
			subForm.submit();
		}
		
	}
	//关闭操作
	function toClose(){
		window.location.href='<%=contextPath %>/dmsManager/assessment/jbzx/jbzx_list.jsp';	
	}
	//选择年月
	function ymSelector(inputField,tributton){    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    true,
			step	       :	1
	    });
	}
	//选择组织机构树
	function selectOrgInfo(){
		var returnValue={
				orgInfo:"",
				orgName:""
			};
		window.showModalDialog("<%=contextPath%>/dmsManager/assessment/jbzx/selectOrgWtc.jsp",returnValue,"dialogWidth=550px;dialogHeight=480px");
		$("#org_id").val(returnValue.orgInfo.split("_")[0]);
		$("#org_subjection_id").val(returnValue.orgInfo.split("_")[1]);
		$("#org_name").val(returnValue.orgName);
		//删除表格以前数据
		$("#queryRetTable_0 tr[id!='table_0_h']").remove();
		//表格索引初始化
		order=1;
		//插入表格数据
		var retObj = jcdpCallService("IndexAssessSrv", "getAddJbzxData","org_sub_id="+returnValue.orgInfo.split("_")[1]+"&org_id="+returnValue.orgInfo.split("_")[0]);
		if(typeof retObj.datas!="undefined"){
			var datas = retObj.datas;
			insertTr("queryRetTable_0",datas,"add");
			//修改样式
			changeTable("queryRetTable_0",1,3);
		}	
	}
	//指标分析
	function popJbzkAnal(item_id){
		var aOrgSubId=$("#org_subjection_id").val();
		popWindow('<%=contextPath%>/dmsManager/assessment/jbzx/jbzx_anal.jsp?item_id='+item_id+'&org_sub_id='+aOrgSubId+'&isDisplay=no','850:640');		
	}
</script>
</html>

