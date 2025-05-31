<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.op.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = request.getParameter("project_info_no");
	String cost_project_schema_id = request.getParameter("cost_project_schema_id");
	if(cost_project_schema_id==null){
		cost_project_schema_id = "";
	}
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String user_id = user.getUserName();
	String exploration_method = OPCommonUtil.getProjectType(project_info_no);//2维、3维
	String project_type = request.getParameter("project_type");
	if(project_type!=null && project_type.trim().equals("5000100004000000002")){
		project_type = "5000100004000000010";
	}
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
 <body><!-- class="bgColor_f3f3f3"  onload="page_init()"> --> 
 <form name="fileForm" id="fileForm" method="post" action=""> <!--target="hidden_frame" enctype="multipart/form-data" --> 
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
    <%if(exploration_method!=null && exploration_method.trim().equals("2")){ %>
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<tr>
			<td class="inquire_item4"><font color="red">*</font>方案名称：</td>
			<td class="inquire_form4"> <input name="schema_name" id="schema_name" class="input_width" value="" type="text"  />
				</td>
			<td class="inquire_item4">方案描述：</td>
			<td class="inquire_form4"> <input name="schema_desc" id="schema_desc" value="" class="input_width" type="text"  /> </td>
		</tr>
     	<tr>
			<td class="inquire_item4">观测系统类型：</td>
			<td class="inquire_form4"> <input name="tech_001" id="tech_001" class="input_width" value="" type="text"  />
				<input name="cost_project_detail_id" id="cost_project_detail_id" class="input_width" value="" type="hidden" /> 
				<input name="spare5" id="spare5" class="input_width" value="1" type="hidden" /></td>
			<td class="inquire_item4">设计线束：</td>
			<td class="inquire_form4"> <input name="tech_002" id="tech_002" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>	
			<td class="inquire_item4"><font color="red" >*</font><input type="radio" name="workload" id="workload1" value="1" checked="checked"/>满覆盖工作量</td>
			<td class="inquire_form4"> <input name="tech_003" id="tech_003" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4"><font color="red">*</font><input type="radio" name="workload" id="workload2" value="2"/>实物工作量</td>
			<td class="inquire_form4"> <input name="tech_004" id="tech_004" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>
			<td class="inquire_item4">井炮生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_005" id="tech_005" value="" class="input_width" type="text"  onkeyup="setTech008()" onkeydown="javascript:return checkIfNum(event);"/> </td>
			<td class="inquire_item4">震源生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_006" id="tech_006" value="" class="input_width" type="text"  onkeyup="setTech008()" onkeydown="javascript:return checkIfNum(event);"/> </td>
		</tr>
		<tr>	
			<td class="inquire_item4">气枪生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_007" id="tech_007" class="input_width" value="" type="text"  onkeyup="setTech008()" onkeydown="javascript:return checkIfNum(event);"/> </td>
			<td class="inquire_item4"><font color="red">*</font>总生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_008" id="tech_008" class="input_width" value="" type="text"  disabled="disabled"/> </td>
		</tr>
		<tr>
			<td class="inquire_item4">微测井：</td>
			<td class="inquire_form4"> <input name="tech_009" id="tech_009" class="input_width" value="" type="text"  /> </td>
			<td class="inquire_item4">小折射：</td>
			<td class="inquire_form4"> <input name="tech_010" id="tech_010" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>	
			<td class="inquire_item4"><font color="red">*</font>接收道数：</td>
			<td class="inquire_form4"> <input name="tech_011" id="tech_011" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4"><font color="red">*</font>检波器串数：</td>
			<td class="inquire_form4"> <input name="tech_012" id="tech_012" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>
			<td class="inquire_item4">覆盖次数：</td>
			<td class="inquire_form4"> <input name="tech_013" id="tech_013" class="input_width" value="" type="text"  /> </td>
			<td class="inquire_item4">道间距：</td>
			<td class="inquire_form4"> <input name="tech_014" id="tech_014" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr id="jz">
			<td class="inquire_item4">井下仪器级数：</td>
			<td class="inquire_form4"> <input name="spare1" id="spare1" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4">采集点数：</td>
			<td class="inquire_form4"> <input name="spare2" id="spare2" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>	
			<td class="inquire_item4">炮点距：</td>
			<td class="inquire_form4"> <input name="tech_015" id="tech_015" value="" class="input_width" type="text"  /> </td>
		</tr>
    </table> 
    <%}else{ %>
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
     	<tr>
			<td class="inquire_item4"><font color="red">*</font>方案名称：</td>
			<td class="inquire_form4"> <input name="schema_name" id="schema_name" class="input_width" value="" type="text"  />
				</td>
			<td class="inquire_item4">方案描述：</td>
			<td class="inquire_form4"> <input name="schema_desc" id="schema_desc" value="" class="input_width" type="text"  /> </td>
		</tr>
     	<tr>
			<td class="inquire_item4">观测系统类型：</td>
			<td class="inquire_form4"> <input name="tech_001" id="tech_001" class="input_width" value="" type="text"  />
				<input name="cost_project_detail_id" id="cost_project_detail_id" class="input_width" value="" type="hidden" /> 
				<input name="spare5" id="spare5" class="input_width" value="1" type="hidden" /></td>
			<td class="inquire_item4">设计线束：</td>
			<td class="inquire_form4"> <input name="tech_002" id="tech_002" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>	
			<td class="inquire_item4"><font color="red">*</font><input type="radio" name="workload" id="workload1" value="1" checked="checked"/>满覆盖工作量</td>
			<td class="inquire_form4"> <input name="tech_003" id="tech_003" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4"><font color="red">*</font><input type="radio" name="workload" id="workload2" value="2"/>实物工作量</td>
			<td class="inquire_form4"> <input name="tech_004" id="tech_004" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>
			<td class="inquire_item4">井炮生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_005" id="tech_005" value="" class="input_width" type="text"  onkeyup="setTech008()" onkeydown="javascript:return checkIfNum(event);"/> </td>
			<td class="inquire_item4">震源生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_006" id="tech_006" value="" class="input_width" type="text"  onkeyup="setTech008()" onkeydown="javascript:return checkIfNum(event);"/> </td>
		</tr>
		<tr>	
			<td class="inquire_item4">气枪生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_007" id="tech_007" class="input_width" value="" type="text"  onkeyup="setTech008()" onkeydown="javascript:return checkIfNum(event);"/> </td>
			<td class="inquire_item4"><font color="red">*</font>总生产炮数：</td>
			<td class="inquire_form4"> <input name="tech_008" id="tech_008" class="input_width" value="" type="text"  disabled="disabled"/> </td>
		</tr>
		<tr>
			<td class="inquire_item4">微测井：</td>
			<td class="inquire_form4"> <input name="tech_009" id="tech_009" class="input_width" value="" type="text"  /> </td>
			<td class="inquire_item4">小折射：</td>
			<td class="inquire_form4"> <input name="tech_010" id="tech_010" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>	
			<td class="inquire_item4"><font color="red">*</font>接收道数：</td>
			<td class="inquire_form4"> <input name="tech_011" id="tech_011" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4"><font color="red">*</font>检波器串数：</td>
			<td class="inquire_form4"> <input name="tech_012" id="tech_012" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>
			<td class="inquire_item4">覆盖次数：</td>
			<td class="inquire_form4"> <input name="tech_013" id="tech_013" class="input_width" value="" type="text"  /> </td>
			<td class="inquire_item4">道间距：</td>
			<td class="inquire_form4"> <input name="tech_014" id="tech_014" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>	
			<td class="inquire_item4">炮点距：</td>
			<td class="inquire_form4"> <input name="tech_015" id="tech_015" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4">接收线距：</td>
			<td class="inquire_form4"> <input name="tech_016" id="tech_016" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr>
			<td class="inquire_item4">炮线距：</td>
			<td class="inquire_form4"> <input name="tech_017" id="tech_017" class="input_width" value="" type="text"  /> </td>
			<td class="inquire_item4">单线道数：</td>
			<td class="inquire_form4"> <input name="tech_018" id="tech_018" class="input_width" value="" type="text"  /> </td>
		</tr>
		<tr>	
			<td class="inquire_item4">滚动接收线数：</td>
			<td class="inquire_form4"> <input name="tech_019" id="tech_019" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4">面元：</td>
			<td class="inquire_form4"> <input name="tech_020" id="tech_020" value="" class="input_width" type="text"  /> </td>
		</tr>
		<tr id="jz">
			<td class="inquire_item4">井下仪器级数：</td>
			<td class="inquire_form4"> <input name="spare1" id="spare1" value="" class="input_width" type="text"  /> </td>
			<td class="inquire_item4">采集点数：</td>
			<td class="inquire_form4"> <input name="spare2" id="spare2" value="" class="input_width" type="text"  /> </td>
		</tr>
    </table> 
    <%} %>
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
	function refreshData(){
		var project_info_no  = '<%=project_info_no%>';
		var exploration_method  = '<%=exploration_method%>';
		var id  = '<%=cost_project_schema_id%>';
		var querySql = "select * from bgp_op_cost_project_schema where bsflag='0' and project_info_no = '"+project_info_no+"' and cost_project_schema_id = '"+id+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		if(retObj!=null && retObj.returnCode=='0' && retObj.datas!=null && retObj.datas[0]!=null){
			var map = retObj.datas[0];
			with(map){
				document.getElementById("schema_name").value = schema_name;
				document.getElementById("schema_desc").value = schema_desc;
				document.getElementById("tech_001").value = tech_001;
				document.getElementById("tech_002").value = tech_002;
				document.getElementById("tech_003").value = tech_003;
				document.getElementById("tech_004").value = tech_004;
				document.getElementById("tech_005").value = tech_005;
				document.getElementById("tech_006").value = tech_006;
				document.getElementById("tech_007").value = tech_007;
				document.getElementById("tech_008").value = tech_008;
				document.getElementById("tech_009").value = tech_009;
				document.getElementById("tech_010").value = tech_010;
				document.getElementById("tech_011").value = tech_011;
				document.getElementById("tech_012").value = tech_012;
				document.getElementById("tech_013").value = tech_013;
				document.getElementById("tech_014").value = tech_014;
				document.getElementById("tech_015").value = tech_015;
				if(exploration_method=='3'){
					document.getElementById("tech_016").value = tech_016;
					document.getElementById("tech_017").value = tech_017;
					document.getElementById("tech_018").value = tech_018;
					document.getElementById("tech_019").value = tech_019;
					document.getElementById("tech_020").value = tech_020;
				}
				if(spare5=='2'){
					document.getElementById("workload2").checked = true;
				} 
				document.getElementById("spare1").value = spare1;
				document.getElementById("spare2").value = spare2;
			}
		}
		var project_type = '<%=project_type%>';
		if(project_type =='5000100004000000008'){
			var font = document.getElementsByTagName("font");
			for(var i =1 ;i<font.length;i++){
				font[i].style.display = 'none';
			}
		}else{
			document.getElementById("jz").style.display= 'none';
		}
	}
	refreshData();
	function newSubmit() {
		var project_type = '<%=project_type%>';
		if(project_type =='5000100004000000008'){
			var obj = document.getElementById("schema_name") ;
			var value = obj.value ;
			if(obj ==null || value==''){
				alert("方案名称不能为空!");
				return false;
			}else{
				value = value.replace(/\d+/g,'');
		  		if(value==''){
		  			alert("方案名称不能是数字!");
		  			return false;
		  		}
			}
		}else{
			if(checkValue() == false){
				return ;
			}
		}
		
		var cost_project_schema_id = '<%=cost_project_schema_id%>';
		var project_info_no = '<%=project_info_no %>';
		var exploration_method = '<%=exploration_method %>';
		var schema_name = document.getElementById("schema_name").value ;
		var schema_desc = document.getElementById("schema_desc").value ;
		var tech_001 = document.getElementById("tech_001").value ;
		var tech_002 = document.getElementById("tech_002").value ;
		var tech_003 = document.getElementById("tech_003").value ;
		var tech_004 = document.getElementById("tech_004").value ;
		var tech_005 = document.getElementById("tech_005").value ;
		var tech_006 = document.getElementById("tech_006").value ;
		var tech_007 = document.getElementById("tech_007").value ;
		var tech_008 = document.getElementById("tech_008").value ;
		var tech_009 = document.getElementById("tech_009").value ;
		var tech_010 = document.getElementById("tech_010").value ;
		var tech_011 = document.getElementById("tech_011").value ;
		var tech_012 = document.getElementById("tech_012").value ;
		var tech_013 = document.getElementById("tech_013").value ;
		var tech_014 = document.getElementById("tech_014").value ;
		var tech_015 = document.getElementById("tech_015").value ;
		
		var tech_016 = "" ;
		var tech_017 = "" ;
		var tech_018 = "" ;
		var tech_019 = "" ;
		var tech_020 = "" ;
		if(exploration_method=='3'){
			var tech_016 = document.getElementById("tech_016").value ;
			var tech_017 = document.getElementById("tech_017").value ;
			var tech_018 = document.getElementById("tech_018").value ;
			var tech_019 = document.getElementById("tech_019").value ;
			var tech_020 = document.getElementById("tech_020").value ;
		}
		var spare1 = document.getElementById("spare1").value ;
		var spare2 = document.getElementById("spare2").value ;
		
		var checked = document.getElementById("workload1").checked; 
		var spare5 = '2';
		if(checked =='true' || checked==true){
			spare5 = '1';
		}
		
		var sql = "";
		if(cost_project_schema_id!=null && cost_project_schema_id!=''){
			sql = "update bgp_op_cost_project_schema t set schema_name='"+schema_name+"',schema_desc='"+schema_desc+"',tech_001='"+tech_001+"',"+
			" tech_002='"+tech_002+"',tech_003='"+tech_003+"',tech_004='"+tech_004+"',tech_005='"+tech_005+"',tech_006='"+tech_006+"',tech_007='"+tech_007+"', "+
			" tech_008='"+tech_008+"',tech_009='"+tech_009+"',tech_010='"+tech_010+"',tech_011='"+tech_011+"',tech_012='"+tech_012+"',tech_013='"+tech_013+"', "+
			" tech_014='"+tech_014+"',tech_015='"+tech_015+"',tech_016='"+tech_016+"',tech_017='"+tech_017+"',tech_018='"+tech_018+"',tech_019='"+tech_019+"', "+
			" tech_020='"+tech_020+"',spare5='"+spare5+"',spare1='"+spare1+"',spare2='"+spare2+"' where t.cost_project_schema_id='"+cost_project_schema_id+"';";
		}else{
			var querySql = "select lower(sys_guid()) key_id from dual";
			var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var key_id = retObj.datas[0].key_id;
			sql = "insert into bgp_op_cost_project_schema(cost_project_schema_id,project_info_no,schema_name,schema_desc,tech_001,tech_002,tech_003,"+
			"tech_004,tech_005,tech_006,tech_007,tech_008,tech_009,tech_010,tech_011,tech_012,tech_013,tech_014,tech_015,tech_016,tech_017,tech_018,"+
			"tech_019,tech_020,org_id,org_subjection_id,creator,create_date,updator,modifi_date,bsflag,spare4,spare5,spare1,spare2)values('"+key_id+"','<%=project_info_no%>',"+
			"'"+schema_name+"','"+schema_desc+"','"+tech_001+"','"+tech_002+"','"+tech_003+"','"+tech_004+"','"+tech_005+"','"+tech_006+"','"+tech_007+"',"+
			"'"+tech_008+"','"+tech_009+"','"+tech_010+"','"+tech_011+"','"+tech_012+"','"+tech_013+"','"+tech_014+"','"+tech_015+"','"+tech_016+"','"+tech_017+"',"+
			"'"+tech_018+"','"+tech_019+"','"+tech_020+"','<%=org_id%>','<%=org_subjection_id%>','<%=user_id%>',sysdate,'<%=user_id%>',sysdate,'0',sysdate,'"+spare5+"','"+spare1+"','"+spare2+"');";
			
			var cost_project_schema_id = key_id;
			var project_info_no = '<%=project_info_no%>';
			sql +="insert into bgp_op_cost_project_info(gp_cost_project_id,template_id,project_info_no,node_code,cost_name,cost_desc,order_code,cost_type,"+
			" parent_id,spare4,bsflag,cost_project_schema_id) select lower(sys_guid()),t.template_id, '"+project_info_no+"',t.node_code,"+
			" t.cost_name,t.cost_desc,t.order_code,t.cost_type,(select gp_cost_project_id from bgp_op_cost_project_info where bsflag ='0' and template_id = t.parent_id"+
			" and project_info_no ='"+project_info_no+"' and cost_project_schema_id ='"+cost_project_schema_id+"')"+
			" ,sysdate,'0','"+cost_project_schema_id+"' "+
			" from bgp_op_cost_template t where t.bsflag ='0' and t.spare1='<%=project_type%>' and t.template_id not in (select template_id from bgp_op_cost_project_info "+
			" where bsflag ='0' and project_info_no ='"+project_info_no+"' and cost_project_schema_id ='"+cost_project_schema_id+"');";
						
			sql +="update bgp_op_cost_project_info t set t.parent_id =(select (select p.gp_cost_project_id from bgp_op_cost_project_info p where p.template_id = ct.parent_id"+
			" and p.project_info_no=t.project_info_no and p.cost_project_schema_id=t.cost_project_schema_id) from bgp_op_cost_template ct where ct.bsflag ='0' and ct.template_id = t.template_id) "+
			" where t.bsflag ='0' and t.project_info_no = '" + project_info_no + "' and t.cost_project_schema_id='" + cost_project_schema_id + "';";
						
			sql +="update bgp_op_cost_project_info t set t.parent_id='01' where parent_id is null and project_info_no = '" + project_info_no+ "' and cost_project_schema_id='" + cost_project_schema_id + "';";
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
		var obj = document.getElementById("schema_name") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("方案名称不能为空!");
			return false;
		}else{
			value = value.replace(/\d+/g,'');
	  		if(value==''){
	  			alert("方案名称不能是数字!");
	  			return false;
	  		}
		}
		var checked = document.getElementById("workload1").checked;
		if(checked=='true' || checked == true){
			obj = document.getElementById("tech_003") ;
			var value = obj.value ;
			debugger;
			if(obj ==null || value==''){
				alert("满覆盖工作量不能为空!");
				return false;
			}
		}else{
			obj = document.getElementById("tech_004") ;
			var value = obj.value ;
			if(obj ==null || value==''){
				alert("实物工作量不能为空!");
				return false;
			}
		}
		obj = document.getElementById("tech_003") ;
		var value = obj.value ;
		debugger;
		if(obj !=null && value!=''){
			var reg = /^[0-9]+(.\d+)?$/g;
	  		if(!reg.test(value)){
	  			alert("满覆盖工作量不是数字!");
	  			return false;
	  		}
		}
		obj = document.getElementById("tech_004") ;
		var value = obj.value ;
		if(obj !=null && value !=''){
			var reg = /\d+.\d+$|\d+$/g;
		  	if(!reg.test(value)){
	  			alert("实物工作量不是数字!");
	  			return false;
	  		}
		}
		obj = document.getElementById("tech_008") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("炮数不能为空!");
			return false;
		}else{
			var reg = /\d+$/g;
		  	if(!reg.test(value)){
	  			alert("炮数不是整数!");
	  			return false;
	  		}
			var tech_005 = document.getElementById("tech_005").value ;
			tech_005 = tech_005 ==null || tech_005==''?"0":tech_005;
			var tech_006 = document.getElementById("tech_006").value ;
			tech_006 = tech_006 ==null || tech_006==''?"0":tech_006;
			var tech_007 = document.getElementById("tech_007").value ;
			tech_007 = tech_007 ==null || tech_007==''?"0":tech_007;
			if(value!=tech_005-(-tech_006)-(-tech_007) ){
				alert("井炮生产炮数、震源生产炮数、气枪生产炮数的和不等于炮数!");
				return false;
			}
		}
		obj = document.getElementById("tech_011") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("接收道数不能为空!");
			return false;
		}else{
			var reg = /\d+$/g;
		  	if(!reg.test(value)){
	  			alert("接收道数不是整数!");
	  			return false;
	  		}
		}
		obj = document.getElementById("tech_012") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("检波器串数不能为空!");
			return false;
		}else{
			var reg = /\d+$/g;
		  	if(!reg.test(value)){
	  			alert("检波器串数不是整数!");
	  			return false;
	  		}
		}
	}
	function setTech008(){
		var tech_005 = document.getElementById("tech_005").value;
		var tech_006 = document.getElementById("tech_006").value;
		var tech_007 = document.getElementById("tech_007").value;
		if(tech_005==null || tech_005==''){
			tech_005 = 0;
		}
		if(tech_006==null || tech_006==''){
			tech_006 = 0;
		}
		if(tech_007==null || tech_007==''){
			tech_007 = 0;
		}
		document.getElementById("tech_008").value = tech_005 -(-tech_006)-(-tech_007);
	}
	/* 输入的是否是数字 */
	function checkIfNum(event){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			return false;
		}
	}
</script>
</body>
</html>