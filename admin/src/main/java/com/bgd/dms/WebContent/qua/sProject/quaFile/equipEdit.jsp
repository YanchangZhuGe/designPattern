<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import ="com.bgp.mcs.service.qua.service.QualitySrv" %>
<%@ taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectName = user.getProjectName();
	if(projectName==null){
		projectName = "";
	}
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String monitor_id = request.getParameter("monitor_id");
	if(monitor_id==null){
		monitor_id = "";
	}
	String history_id = request.getParameter("history_id");
	if(history_id==null){
		history_id = "";
	}
	String org_id = user.getOrgId();
	Map map = QualitySrv.getOrgName(org_id);
	String org_name = (String)map.get("org_name");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head> 
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <title>sdsdsd</title>
 </head> 
 <body><!-- class="bgColor_f3f3f3"  onload="page_init()"> --> 
 <form name="fileForm" id="fileForm" method="post" > <!--target="hidden_frame" enctype="multipart/form-data" --> 
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<tr>
     		<input type="hidden" name="monitor_id" id="monitor_id" value="<%=monitor_id %>" />
     		<input type="hidden" name="history_id" id="history_id" value="<%=history_id %>" />
	    	<td class="inquire_item4">项目名称</td>
	    	<td class="inquire_form4">
	    		<input name="project_name" id="project_name" type="text" class="input_width" value="<%=projectName %>" disabled="disabled"/></td>
	    	<td class="inquire_item4">分类代码</td>
	    	<td class="inquire_form4">
	    		<input name="sort_id" id="sort_id" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">统一编码</td>
	    	<td class="inquire_form4">
	    		<input name="unite_code" id="unite_code" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">分类编码</td>
	    	<td class="inquire_form4">
	    		<input name="sort_code" id="sort_code" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4"><font color="red">*</font>名称</td>
	    	<td class="inquire_form4"><input name="equip_id" id="equip_id" type="hidden" class="input_width" value="" />
	    		<input name="equip_name" id="equip_name" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4"><font color="red">*</font>型号</td>
	    	<td class="inquire_form4">
	    		<input name="model_code" id="model_code" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">测量范围</td>
	    	<td class="inquire_form4">
	    		<input name="measure" id="measure" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">精准度</td>
	    	<td class="inquire_form4">
	    		<input name="accurate" id="accurate" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">生产厂家</td>
	    	<td class="inquire_form4">
	    		<input name="producor" id="producor" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">出厂编号</td>
	    	<td class="inquire_form4">
	    		<input name="ident_code" id="ident_code" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4"><font color="red">*</font>使用部门</td>
	    	<td class="inquire_form4"><input name="depart" id="depart" type="text" class="input_width" value="<%=org_name %>" /></td>
	    	<td class="inquire_item4">配套设备</td>
	    	<td class="inquire_form4">
	    		<input name="facilities" id="facilities" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">管理状况</td>
	    	<td class="inquire_form4">
	    		<input name="status" id="status" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">检定部门</td>
	    	<td class="inquire_form4"><input name="detect_depart" id="detect_depart" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">检定周期</td>
	    	<td class="inquire_form4">
	    		<input name="detect_cycle" id="detect_cycle" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">检定日期</td>
	    	<td class="inquire_form4">
	    		<input name="detect_date" id="detect_date" type="text" class="input_width" value="" readonly="readonly"/>
	    		<img width="16" height="16" id="cal_button6" style="cursor: hand;" onmouseover="calDateSelector(detect_date,cal_button6);" src="<%=contextPath %>/images/calendar.gif" /></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">有效日期</td>
	    	<td class="inquire_form4">
	    		<input name="valid_date" id="valid_date" type="text" class="input_width" value="" readonly="readonly"/>
	    		<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(valid_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
	    	<td class="inquire_item4">检定结果</td>
	    	<td class="inquire_form4">
	    		<select id="detect_result" name="detect_result" class="select_width">
	    			<option value="1">合格</option>
	    			<option value="2">不合格</option>
	    		</select></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">ABC</td>
	    	<td class="inquire_form4">
	    		<input name="abc" id="abc" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">到队日期</td>
	    	<td class="inquire_form4">
	    		<input name="spare1" id="spare1" type="text" class="input_width" value="" readonly="readonly"/>
	    		<img width="16" height="16" id="cal_button8" style="cursor: hand;" onmouseover="calDateSelector(spare1,cal_button8);" src="<%=contextPath %>/images/calendar.gif" /></td>
	    </tr>
	    <tr>
	    	
	    	<td class="inquire_item4">备注</td>
	    	<td class="inquire_form4">
	    		<input name="notes" id="notes" type="text" class="input_width" value="" /></td>
	    </tr>
    </table> 
  </div> 
  <div id="oper_div">
	<span class="bc_btn"><a href="#" onclick="newSubmit()"></a></span>
 	<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
  </div> 
  </div>
</form> 
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
	function checkIfNum(){
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8){
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	function refreshData(){
		var id  = '<%=monitor_id%>';
		var retObj = jcdpCallService("QualityItemsSrv" , "getEquipmentDetail", "monitor_id="+id);
		if(retObj.returnCode =='0'){
			var map = retObj.equipmentDetail;
			if(map!=null){
				document.getElementById("history_id").value = map.history_id;
				document.getElementById("sort_id").value = map.sort_id;
				document.getElementById("unite_code").value = map.unite_code;
				document.getElementById("sort_code").value = map.sort_code;
				document.getElementById("equip_id").value = map.equip_id;
				document.getElementById("equip_name").value = map.equip_name;
				document.getElementById("model_code").value = map.model_code;
				document.getElementById("measure").value = map.measure;
				document.getElementById("accurate").value = map.accurate;
				document.getElementById("producor").value = map.producor;
				document.getElementById("ident_code").value = map.ident_code;
				document.getElementById("depart").value = map.depart;
				document.getElementById("facilities").value = map.facilities;
				document.getElementById("status").value = map.status;
				document.getElementById("detect_depart").value = map.detect_depart;
				document.getElementById("detect_cycle").value = map.detect_cycle;
				document.getElementById("detect_date").value = map.detect_date;
				document.getElementById("valid_date").value = map.valid_date;
				document.getElementById("abc").value = map.abc;
				document.getElementById("spare1").value = map.spare1;
				document.getElementById("notes").value = map.notes;
				var detect_result =  map.detect_result;
				var select = document.getElementById("detect_result");
				for(var i=0; i< select.options.length;i++){
					if(select.options[i].value == detect_result){
						select.options[i].selected = 'selected';
					}
				}
			}
		}
		
	}
	refreshData();
	function newSubmit() {
		if(checkValue()==false){
			return;
		}
		var form = document.getElementById("fileForm");
		form.action = '<%=contextPath%>/qua/sProject/equipment/saveEquipment.srq';
		form.submit();
	}
	
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
	function checkValue(){
		var obj = document.getElementById("equip_name") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("设备名称不能为空!");
			return false;
		}
		obj = document.getElementById("model_code") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("型号不能为空!");
			return false;
		}
		obj = document.getElementById("depart") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("使用部门不能为空!");
			return false;
		}
	}
</script>
</body>
</html>