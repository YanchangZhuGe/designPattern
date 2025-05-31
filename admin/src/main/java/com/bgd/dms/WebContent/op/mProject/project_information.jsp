<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String tartget_basic_id = request.getParameter("tartget_basic_id");
	String status = request.getParameter("status");
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
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
    	<tr>
	    	<td class="inquire_item4" style="float: left;" colspan="2"><font color="red">项目概况:</font></td>
	    </tr>
     	<tr>
	    	<td class="inquire_item4">施工地区</td>
	    	<td class="inquire_form4"><input name="work_load" id="work_load" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">地形</td>
	    	<td class="inquire_form4"><input name="work_situation" id="work_situation" type="text" class="input_width" value="" /></td> 
	    </tr>
	    <tr>
	    	<td class="inquire_item4">物理点</td>
	    	<td class="inquire_form4"><input name="work_factor" id="work_factor" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">公里</td>
	    	<td class="inquire_form4"><input name="work_reason" id="work_reason" type="text" class="input_width" value="" /></td> 
	    </tr>
	    <tr>
	    	<td class="inquire_item4">搬迁距离(km)</td>
	    	<td class="inquire_form4"><input name="work_person" id="work_person" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">搬迁方式</td>
	    	<td class="inquire_form4"><input name="work_device" id="work_device" type="text" class="input_width" value="" /></td> 
	    </tr>
	    <tr>
	    	<td class="inquire_item4">施工方法</td>
	    	<td class="inquire_form4"><input name="construct_mean" id="construct_mean" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">测网</td>
	    	<td class="inquire_form4"><input name="network" id="network" type="text" class="input_width" value="" /></td> 
	    </tr>
	    <tr>
	    	<td class="inquire_item4">班组</td>
	    	<td class="inquire_form4"><input name="team_no" id="team_no" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">工期(施工月)</td>
	    	<td class="inquire_form4"><input name="work_days" id="work_days" type="text" class="input_width" value="" /></td> 
	    </tr>
	    <tr>
	    	<td class="inquire_item4" style="float: left;" colspan="2"><font color="red">人力及设备配备:</font></td>
	    </tr>
	    <tr>
	    	<td class="inquire_item4">合同化员工</td>
	    	<td class="inquire_form4"><input name="office_num" id="office_num" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">市场化员工</td>
	    	<td class="inquire_form4"><input name="market_num" id="market_num" type="text" class="input_width" value="" /></td> 
	    </tr>
	    <tr>
	    	<td class="inquire_item4">再就业员工</td>
	    	<td class="inquire_form4"><input name="employ_num" id="employ_num" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">招聘员工</td>
	    	<td class="inquire_form4"><input name="recruit_num" id="recruit_num" type="text" class="input_width" value="" /></td> 
	    </tr>
	    <tr>
	    	<td class="inquire_item4">采集仪器</td>
	    	<td class="inquire_form4"><input name="coll_equip" id="coll_equip" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">测量仪器</td>
	    	<td class="inquire_form4"><input name="meas_equip" id="meas_equip" type="text" class="input_width" value="" /></td> 
	    </tr>
	    <tr>
	    	<td class="inquire_item4">运载车辆</td>
	    	<td class="inquire_form4"><input name="tran_equip" id="tran_equip" type="text" class="input_width" value="" /></td>
	    	<td class="inquire_item4">辅助设备</td>
	    	<td class="inquire_form4"><input name="assist_equip" id="assist_equip" type="text" class="input_width" value="" /></td> 
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
		work_load:"2",
		work_situation:"",
		work_factor:"",
		work_reason:"",
		work_person:"",
		work_device:"",
		construct_mean:"",
		network:"",
		team_no:"",
		work_days:"",
		office_num:"",
		market_num:"",
		employ_num:"",
		recruit_num:"",
		coll_equip:"",
		meas_equip:"",
		tran_equip:"",
		assist_equip:""

	}
	function refreshData(){
		var tartget_basic_id = '<%=tartget_basic_id%>';
		var sql = "select * from bgp_op_target_project_basic t where t.bsflag ='0' and t.tartget_basic_id='"+tartget_basic_id+"' and rownum =1";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
		if(retObj!=null && retObj.returnCode =='0' && retObj.datas[0]!=null){
			var map = retObj.datas[0];
			for(var name in project_information){
				document.getElementById(name).value = map[name];
				
			}
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var submit = "table_name=bgp_op_target_project_basic&tartget_basic_id="+document.getElementById("tartget_basic_id").value;
		for(var name in project_information){
			submit += "&"+name + "="+document.getElementById(name).value ;
		}
		var retObj = jcdpCallService("OPCostSrv","savedDatasByMap",submit);
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