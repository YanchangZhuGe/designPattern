<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String unit_id=request.getParameter("unit_id");
	if(null==unit_id){
		unit_id="";
	}
	String org_id=request.getParameter("org_id");
	if(null==org_id){
		org_id="";
	}
	String subOrg_id=request.getParameter("subOrg_id");
	if(null==subOrg_id){
		subOrg_id="";
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
	<title>单位指标编辑信息</title>
</head>

<body style="background:#cdddef"  scroll="no">
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/assess/indexAssess/saveOrUpdateIndexOrgInfo.srq?flag=<%=flag%>">
		<div id="new_table_box">
			<div id="new_table_box_content">
		    	<div id="new_table_box_bg">
		    		<!-- 关联表ID -->
		    		<input type="hidden" id="unit_id" class="main" name="unit_id" />
		    		<fieldset style="margin-left:2px">
		    			<legend>单位指标基本信息</legend>
						<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
							<tr>
						  		<td class="inquire_item6">单位：</td>
				    			<td class="inquire_form6">
				    				<input type="hidden" id="org_id" name="org_id" class="main"/>
				    				<input type="hidden" id="org_subjection_id" name="org_subjection_id" class="main"/>
				    				<input type="text" id="org_name" name="org_name" class="input_width main" readonly="readonly"/>
				    			</td>
								<td class="inquire_item6">指标名称：</td>
				    			<td class="inquire_form6">
				    				<select id="indexconf_id" name="indexconf_id" class="select_width main">
			          				</select>
				    			</td>
				        	</tr>
						</table>
					</fieldset>
					<fieldset style="margin-left:2px;height:280px;overflow-y:auto;" >
						<legend>指标项信息</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
							<tr>
								<td>
									<input type="button" value="    选择" style="width:70px;height:25px;background-image:url(<%=contextPath%>/css/dms_home/images/ico-xuanze.png); background-repeat:no-repeat; background-position:5px 2px;" onclick="selectIndexConfItems()"/>
								</td>
							</tr>
							<tr>
								<td class="inquire_form6" colspan="4">
		  	  						<input type="hidden" id="item_ids" name="item_ids" class="main"/>
									<textarea id="item_names" name="item_names" rows="4" cols="80" class="main" readonly></textarea>
								</td>
							</tr>		  	
	  					</table>
					</fieldset>	
					<div>
					    <div id="oper_div">
					    	<auth:ListButton functionId="" css="tj_btn" event="onclick='toSubmit()'"></auth:ListButton>
					        <auth:ListButton functionId="" css="gb_btn" event="onclick='toClose()'"></auth:ListButton>        
					    </div>
					</div>
				</div> 
			</div>
		</div>
	</form>
</body>
<script type="text/javascript">
	var contextpath= "<%=contextPath%>";
	//关联表ID
	var unit_id= "<%=unit_id%>";
	//增加修改标志
	var flag="<%=flag%>";
	$(function(){
		var retObj = jcdpCallService("IndexAssessSrv", "getIndexConfItemInfo", "");
		if(typeof retObj.datas!="undefined"){
			var datas = retObj.datas;
			for(var i=0;i<datas.length;i++){
				var data=datas[i];
				$("#indexconf_id").append("<option value='"+data.id+"'>"+data.name+"</option>");
			}
		}
		if("add"==flag){
			var retObj = jcdpCallService("IndexAssessSrv", "getOrgNameInfo", "subOrg_id=<%=subOrg_id%>");
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				$("#org_name").val(data.org_name);
			}
			$("#org_id").val("<%=org_id%>");
			$("#org_subjection_id").val("<%=subOrg_id%>");
		}
		if("update"==flag){
			var retObj = jcdpCallService("IndexAssessSrv", "getIndexOrgInfo", "unit_id="+unit_id);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(data[temp] != undefined ? data[temp]:"");
				});
			}
		}
	});
	
	//保存
	function toSubmit(){
		if(""==$("#item_ids").val()||null==$("#item_ids").val()){
			alert("请选择指标项信息");
			return;
		}
		var subForm = $("#form");
		subForm.submit();
	}
	//关闭
	function toClose(){
		newClose();
	}
	//选择配置项
	function selectIndexConfItems(){
		var indexconfId= $("#indexconf_id").val();
		if(""==indexconfId){
			alert("请选择指标名称");
			return;
		}
		var obj = new Object();
		var checkedCodes="";
		var codes = $("#item_ids").val();
		
		if(""!=codes){
			var sCodes=codes.split(',');
			for(var i=0;i<sCodes.length;i++){
				checkedCodes += ",'" + sCodes[i]+"'";
			}
			checkedCodes = checkedCodes=="" ? "" : checkedCodes.substr(1);
		}
		obj.checkedCodes=checkedCodes;
		obj.indexconfId=indexconfId;
		var vReturnValue = window.showModalDialog("<%=contextPath%>/dmsManager/assessment/indexAssess/selectIndexConfItems.jsp",obj,"dialogWidth=550px;dialogHeight=480px");
		if(typeof vReturnValue!="undefined"){
			$("#item_ids").val(vReturnValue.checkIds);
			$("#item_names").val(vReturnValue.checkNames);
		}
	}
</script>
</html>