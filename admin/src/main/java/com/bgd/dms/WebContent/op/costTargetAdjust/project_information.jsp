<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String tartget_basic_id = request.getParameter("tartget_basic_id");
	String status = request.getParameter("status");
	String querySql = "select t.* ,t.rowid from gp_task_project t where t.bsflag ='0' and t.project_info_no ="+
	"(select project_info_no from bgp_op_target_project_basic t where t.bsflag ='0' and t.tartget_basic_id='"+tartget_basic_id+"' and rownum=1)";
	Map map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(querySql);
	String exploration_method = map==null ||map.get("exploration_method")==null?"":(String)map.get("exploration_method");
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
 </head> 
 <body><!-- class="bgColor_f3f3f3"  onload="page_init()"> --> 
 <form name="fileForm" id="fileForm" method="post" > <!--target="hidden_frame" enctype="multipart/form-data" --> 
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
  	<input type="hidden" name="tartget_basic_id" id="tartget_basic_id" value="<%=tartget_basic_id %>" />
  	<input type="hidden" name="indicator_change_id" id="indicator_change_id" value="" />
  	<input name="spare5" id="spare5" value="" class="input_width" type="hidden" />
	<input name="tech_020" id="tech_020" value="" class="input_width" type="hidden" />
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	    <tr>
	    	<td class="inquire_item4" style="float: left;" colspan="2"><font color="red">技术指标:</font></td>
	    </tr>
	    <tr>
			<td class="inquire_item4">观测系统类型：</td>
			<td class="inquire_form4"> <input name="tech_001" id="tech_001" class="input_width" value="" type="text"  /></td>
			<td class="inquire_item4">设计线束：</td>
			<td class="inquire_form4"> <input name="tech_002" id="tech_002" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>	
			<td class="inquire_item4"><font color="red">*</font><input type="radio" name="workload" id="workload1" value="1" checked="checked"/>满覆盖工作量</td>
			<td class="inquire_form4"> <input name="tech_005" id="tech_005" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4"><font color="red">*</font><input type="radio" name="workload" id="workload2" value="2"/>实物工作量</td>
			<td class="inquire_form4"> <input name="tech_006" id="tech_006" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>
			<td class="inquire_item4">井炮生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_022" id="tech_022" value="" class="input_width" type="text" onkeydown="javascript:return checkIfNum(event);"/> </td>
			<td class="inquire_item4">震源生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_021" id="tech_021" value="" class="input_width" type="text" onkeydown="javascript:return checkIfNum(event);"/> </td>
		</tr>
		<tr>	
			<td class="inquire_item4">气枪生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_023" id="tech_023" class="input_width" value="" type="text" onkeydown="javascript:return checkIfNum(event);"/> </td>
			<td class="inquire_item4"><font color="red">*</font>总生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_004" id="tech_004" class="input_width" value="" type="text" disabled="disabled"/> </td>
		</tr>
		<tr>
			<td class="inquire_item4">微测井：</td>
			<td class="inquire_form4"> <input name="tech_018" id="tech_018" class="input_width" value="" type="text"  /> </td>
			<td class="inquire_item4">小折射：</td>
			<td class="inquire_form4"> <input name="tech_003" id="tech_003" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>	
			<td class="inquire_item4"><font color="red">*</font>接收道数：</td>
			<td class="inquire_form4"> <input name="tech_008" id="tech_008" value="" class="input_width" type="text"  onkeydown="javascript:return checkIfNum(event);"/> </td>
			<td class="inquire_item4"><font color="red">*</font>检波器串数：</td>
			<td class="inquire_form4"> <input name="tech_019" id="tech_019" value="" class="input_width" type="text"  onkeydown="javascript:return checkIfNum(event);"/> </td>
		</tr>
		<tr>
			<td class="inquire_item4">覆盖次数：</td>
			<td class="inquire_form4"> <input name="tech_007" id="tech_007" class="input_width" value="" type="text"  /> </td>
			<td class="inquire_item4">道间距：</td>
			<td class="inquire_form4"> <input name="tech_009" id="tech_009" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>	
			<td class="inquire_item4">炮点距：</td>
			<td class="inquire_form4"> <input name="tech_010" id="tech_010" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4" id="second1">接收线距：</td>
			<td class="inquire_form4" id="second2"> <input name="tech_011" id="tech_011" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr id="second3">
			<td class="inquire_item4">炮线距：</td>
			<td class="inquire_form4"> <input name="tech_012" id="tech_012" class="input_width" value="" type="text"  /> </td>
			<td class="inquire_item4">单线道数：</td>
			<td class="inquire_form4"> <input name="tech_013" id="tech_013" class="input_width" value="" type="text"  /> </td>
		</tr>
		<tr id="second4">
			<td class="inquire_item4">滚动接收线数：</td>
			<td class="inquire_form4"> <input name="tech_014" id="tech_014" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4">面元：</td>
			<td class="inquire_form4"> <input name="tech_015" id="tech_015" value="" class="input_width" type="text"  /> </td>
		</tr>
	    
    </table> 
  </div> 
  <div id="oper_div">
  	<%if(status!=null && status.trim().equals("true")){ %>
	<span class="bc_btn"><a href="#" onclick="newSubmit()"></a></span>
	<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	<%} %>
  </div>
  </div> 
  </div>
</form> 
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	/* 输入的是否是数字 */
	function checkIfNum(){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}
	var project_information = {
		work_load:"",
		work_situation:"",
		work_factor:"",
		work_reason:"",
		work_person:"",
		work_device:""

	}
	var project_indicato = {
		tech_001:'',
		tech_002:'',
		
		spare5:'',
		tech_005:'',
		tech_006:'',
		tech_020:'',
		
		tech_022:'',
		tech_021:'',
		tech_023:'',
		tech_004:'',
		
		tech_018:'',
		tech_003:'',
		tech_008:'',
		tech_019:'',
		
		tech_007:'',
		tech_009:'',
		tech_010:'',
		
		tech_011:'',
		tech_012:'',
		tech_013:'',
		tech_014:'',
		tech_015:''
	};
	function refreshData(){
		var tartget_basic_id = '<%=tartget_basic_id%>';
		<%-- var sql = "select * from bgp_op_target_project_basic t where t.bsflag ='0' and t.tartget_basic_id='"+tartget_basic_id+"' and rownum =1";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
		if(retObj!=null && retObj.returnCode =='0' && retObj.datas[0]!=null){
			var map = retObj.datas[0];
			for(var name in project_information){
				document.getElementById(name).value = map[name];
				
			}
		} --%>
		//载入技术指标信息
		var querySql="select * from bgp_op_target_indicato_change where bsflag='0' and tartget_basic_id='"+tartget_basic_id+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		if(retObj!=null && retObj.returnCode =='0' && retObj.datas[0]!=null){
			var map = retObj.datas[0];
			for(var name in project_indicato){
				document.getElementById(name).value = map[name];
			}
			document.getElementById("indicator_change_id").value = map.indicator_change_id;
		}
		var spare5 = document.getElementById("spare5").value;
		if(spare5==2 || spare5 =='2'){
			document.getElementById("workload2").checked = true;
		}
		var exploration_method = '<%=exploration_method%>';
		if(exploration_method==null || exploration_method==''){
			alert("该项目既不是二维也不是三维!");
		}else if(exploration_method!=null && exploration_method=='0300100012000000002'){
			document.getElementById("second1").style.display = 'none';
			document.getElementById("second2").style.display = 'none';
			document.getElementById("second3").style.display = 'none';
			document.getElementById("second4").style.display = 'none';
		}else if(exploration_method!=null && exploration_method=='0300100012000000003'){
			document.getElementById("second1").style.display = 'block';
			document.getElementById("second2").style.display = 'block';
			document.getElementById("second3").style.display = 'block';
			document.getElementById("second4").style.display = 'block';
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		/* var submit = "table_name=bgp_op_target_project_basic&tartget_basic_id="+document.getElementById("tartget_basic_id").value;
		for(var name in project_information){
			submit += "&"+name + "="+document.getElementById(name).value ;
		}
		var retObj = jcdpCallService("OPCostSrv","savedDatasByMap",submit); */
		
		document.getElementById("spare5").value = 1;
		document.getElementById("tech_020").value = document.getElementById("tech_005").value;
		var checked = document.getElementById("workload2").checked;
		if(checked=='true' || checked ==true){
			document.getElementById("spare5").value = 2;
			document.getElementById("tech_020").value = document.getElementById("tech_006").value;
		}
		submit = "table_name=bgp_op_target_indicato_change&indicator_change_id="+document.getElementById("indicator_change_id").value;
		for(var name in project_indicato){
			submit += "&"+name + "="+document.getElementById(name).value ;
		}
		retObj = jcdpCallService("OPCostSrv","savedDatasByMap",submit);
		if(retObj!=null && retObj.returnCode=='0'){
			alert("修改成功!");
			newClose();
		}
	}
	function checkValue(){
		/* var obj = document.getElementById("qc_title");
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("QC课题不能为空!");
			return false;
		}
		obj = document.getElementById("org_id");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("施工单位不能为空!");
			return false;
		} */
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
	function newClose(){
		window.close();
	}
</script>
</body>
</html>