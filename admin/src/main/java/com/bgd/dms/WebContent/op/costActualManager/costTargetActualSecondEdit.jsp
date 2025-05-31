<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	String target_matare_id = request.getParameter("target_matare_id");
	if(target_matare_id==null){
		target_matare_id = "";
	}
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String user_id = user.getUserId();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String now = df.format(new Date());
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
  <title></title> 
 </head> 
 <body><!-- class="bgColor_f3f3f3" onload="page_init()"> --> 
 <form name="fileForm" id="fileForm" method="post" action=""> <!--target="hidden_frame" enctype="multipart/form-data" --> 
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
  	<input type="hidden" name="target_matare_id" id="target_matare_id" value="<%=target_matare_id %>" />
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<tr>	
	    	<td class="inquire_item4"><font color="red">*</font>数量:</td>
	    	<td class="inquire_form4"><input name="dev_count" id="dev_count" type="text" class="input_width" value="" onkeydown="javascript:return checkIfNum(event);"/></td>
	    	<td class="inquire_item4"><font color="red">*</font>维修日期:</td>
	    	<td class="inquire_form4"><input name="update_date" id="update_date" type="text" class="input_width" value="<%=now %>" disabled="disabled"  /></td>
	    </tr>
     	<tr>
	    	<td class="inquire_item4">名称:</td>
	    	<td class="inquire_form4"><select id="dev_name" name="dev_name" onchange="changeDevName();" class="select_width">
				<option value="采集站">采集站</option>
				<option value="电源站">电源站</option>
			    <option value="交叉站">交叉站</option>
			    <option value="充电机">充电机</option>
			    <option value="数字三分量检波器">数字三分量检波器</option>
			    <option value="光电转换盒">光电转换盒</option>
			    <option value="重复站">重复站</option>
			    <option value="dsu1">dsu1</option>
			    <option value="dsu3">dsu3</option>
			    <option value="光缆">光缆</option>
			    <option value="数传光缆">数传光缆</option>
			    <option value="爆炸机">爆炸机</option>
			    <option value="小折射仪（R24、SE4）">小折射仪（R24、SE4）</option>
			    <option value="小折射仪（其他型号）">小折射仪（其他型号）</option>
			    <option value="车载电台">车载电台</option>
			    <option value="手持电台">手持电台</option>
			    <option value="通讯差转台">通讯差转台</option>
			    <option value="小炮盒">小炮盒</option>
	    	</select></td>
	    	<td class="inquire_item4"><font color="red">*</font>修理单价(元):</td>
	    	<td class="inquire_form4"><input name="taxi_unit" id="taxi_unit" type="text" class="input_width" value="" disabled="disabled"/></td>
	    </tr>
    	
	    <tr id="model">
	    	<td class="inquire_item4">型号:</td>
	    	<td class="inquire_form4"><select id="dev_model" name="dev_model" onchange="changeUnit();" class="select_width">
				<option value="428">428</option>
				<option value="408">408</option>
				<option value="ARIES">ARIES</option>
				<option value="SCORPION">SCORPION</option>
				<option value="G3i">G3i</option>
				<option value="FIREFLY">FIREFLY</option>
				<option value="ES109">ES109</option>
	    	</select></td>
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
	function refreshData(){
		var id  = '<%=target_matare_id%>';
		var querySql = "select * from bgp_op_target_device_matare where bsflag='0' and if_change = '2' and mataxi_type ='1' and target_matare_id = '"+id+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		if(retObj!=null && retObj.returnCode=='0' && retObj.datas!=null && retObj.datas[0]!=null){
			var map = retObj.datas[0];
			with(map){
				document.getElementById("target_matare_id").value = target_matare_id;
				document.getElementById("dev_name").value = dev_name;
				document.getElementById("dev_model").value = dev_model;
				document.getElementById("dev_count").value = dev_count;
				document.getElementById("taxi_unit").value = taxi_unit;
			}
		}
		changeDevName();
		changeUnit();
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var target_matare_id = document.getElementById("target_matare_id").value ;
		var dev_name = document.getElementById("dev_name").value;
		var dev_model = document.getElementById("dev_model").value ;
		var dev_count = document.getElementById("dev_count").value ;
		var taxi_unit = document.getElementById("taxi_unit").value ;
		var update_date = document.getElementById("update_date").value ;
		var name = getDevModel();
		if(name==''){
			dev_model = '';
		}
		var sql = "";
		if(target_matare_id!=null && target_matare_id!=''){
			sql = "update bgp_op_target_device_matare t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.dev_count='"+dev_count+"',"+
			" t.taxi_unit='"+taxi_unit+"',t.update_date =to_date('"+update_date+"','yyyy-MM-dd') where t.target_matare_id='"+target_matare_id+"';";
		}else{
			sql = "insert into bgp_op_target_device_matare(target_matare_id,project_info_no,dev_name,dev_model,"+
			"dev_count,mataxi_type,taxi_unit,org_id,org_subjection_id,creator,create_date,updator,"+
			"bsflag,if_change,update_date) values((lower(sys_guid())),'<%=project_info_no%>','"+dev_name+"',"+
			"'"+dev_model+"','"+dev_count+"','1','"+taxi_unit+"','<%=org_id%>','<%=org_subjection_id%>',"+
			"'<%=user_id%>',sysdate,'<%=user_id%>','0','2',to_date('"+update_date+"','yyyy-MM-dd'));";
		}
		sql = encodeURI(encodeURI(sql)); 
		var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
		if(retObj!=null && retObj.returnCode == '0'){
			alert("保存成功!");
			top.frames['list'].refreshData();
			newClose();
		}else{
			alert("保存失败!");
		}
	}
	function checkValue(){
		var obj = document.getElementById("dev_count") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("数量不能为空!");
			return false;
		}
	}
	function changeDevName(){
		var name = getDevModel();
		if(name==''){
			name = "3000_爆炸机,3900_小折射仪（R24、SE4）,5000_小折射仪（其他型号）,0450_车载电台,0250_手持电台,0900_通讯差转台,0150_小炮盒";
			document.getElementById("model").style.display = 'none';
			var dev_name = document.getElementById("dev_name").value;
			var index = name.indexOf(dev_name);
			var taxi_unit = name.substring(index-5,index-1);
			 document.getElementById("taxi_unit").value = parseFloat(taxi_unit);
		}else{
			document.getElementById("model").style.display = 'block';
			var dev_model = document.getElementById("dev_model");
			debugger;
			for(var i = dev_model.options.length-1;i>=0;i--){
				dev_model.remove(i);
			}
			var dev_models = name.split(',');
			for(var model in dev_models){
				dev_model.options.add(new Option(dev_models[model].split('_')[1],dev_models[model].split('_')[1]));
			}
			changeUnit();
		}
		
	}
	function changeUnit(){
		var name = getDevModel();
		if(name!=null && name!=''){
			var dev_model = document.getElementById("dev_model").value;
			var index = name.indexOf(dev_model);
			var taxi_unit = name.substring(index-5,index-1);
			 document.getElementById("taxi_unit").value = parseFloat(taxi_unit);
		}
	}
	function getDevModel(){
		var name = "3000_爆炸机,3900_小折射仪（R24、SE4）,5000_小折射仪（其他型号）,0450_车载电台,0250_手持电台,0900_通讯差转台,0150_小炮盒";
		var dev_name = document.getElementById("dev_name").value;
		if(name.indexOf(dev_name)!=-1){
			return '';
		}else{
			if(dev_name=='采集站'){
				name = "1200_428,1200_408,2000_ARIES,1400_SCORPION,2000_G3i,2000_FIREFLY,1200_ES109";
				return name;
			}else if(dev_name=='电源站'){
				name = "4000_428,4000_408,3500_SCORPION,4000_G3i,3000_ES109";
				return name;
			}else if(dev_name=='交叉站'){
				name = "5200_428,5200_408,4500_ARIES,4500_SCORPION,6000_G3i,4000_ES109";
				return name;
			}else if(dev_name=='充电机'){
				name = "3000_ARIES";
				return name;
			}else if(dev_name=='数字三分量检波器'){
				name = "4500_SCORPION";
				return name;
			}else if(dev_name=='光电转换盒'){
				name = "1500_428,4000_SCORPION";
				return name;
			}else if(dev_name=='重复站'){
				name = "1300_428";
				return name;
			}else if(dev_name=='dsu1'){
				name = "2400_428,2400_408";
				return name;
			}else if(dev_name=='dsu3'){
				name = "3000_428";
				return name;
			}else if(dev_name=='光缆'){
				name = "0500_428,1200_SCORPION,1200_G3i";
				return name;
			}else if(dev_name=='数传光缆'){
				name = "0960_第一个断点,0640_第二个断点,0320_第三个断点";
				return name;
			}
		}
	}
</script>
</body>
</html>