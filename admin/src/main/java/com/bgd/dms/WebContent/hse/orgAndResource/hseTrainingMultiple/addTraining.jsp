<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String hse_plan_id = request.getParameter("hse_plan_id");
	
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
</head>
<body onload="queryOrg()">
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_plan_id" name="hse_plan_id" value=""></input>
<input type="hidden" id="hse_detail_id" name="hse_detail_id" value=""></input>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					  <tr>
				     	<td class="inquire_item6">单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
				      	<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				      	<%} %>
				      	</td>
				     	<td class="inquire_item6">基层单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
				      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				      	<%} %>
				      	</td>
				     </tr>
					 <tr>
				    	<td class="inquire_item6"><font color="red">*</font>培训对象：</td>
				      	<td class="inquire_form6">
				      		<select id="train_object" name="train_object" class="select_width" >
				      			<option value="职工">职工</option>
				      			<option value="合同工">合同工</option>
				      			<option value="分包方">分包方</option>
				      			<option value="外来人员">外来人员</option>
				      		</select>
				      	</td>
				     	<td class="inquire_item6"><font color="red">*</font>培训地点：</td>
				      	<td class="inquire_form6"><input type="text" id="train_address" name="train_address" class="input_width"   value=""/></td>
				     </tr>
				     <tr>
				     	<td class="inquire_item6">项目名称：</td>
				      	<td class="inquire_form6"><input type="text" id="project_name" name="project_name" class="input_width" value=""/></td>
				    	<td class="inquire_item6"><font color="red">*</font>培训时间：</td>
				      	<td class="inquire_form6"><input type="text" id="train_time" name="train_time" class="input_width" value=""></input></td>
				     </tr>
				     
				       
				     <tr>
				    	<td class="inquire_item6"><font color="red">*</font>是否领导宣贯：</td>
				      	<td class="inquire_form6">
				      		<select id="lead_type" name="lead_type" class="select_width" >
				      			<option value="1" >是</option>
				      			<option value="0" selected >否</option>
 
				      		</select>
				      	</td>
				     	<td class="inquire_item6"> </td>
				      	<td class="inquire_form6"> </td>
				     </tr>
				     
				     <tr>
				    	<td class="inquire_item6"><font color="red">*</font>培训目的：</td>
				      	<td class="inquire_form6" colspan="3"><textarea id="train_purpose" name="train_purpose" class="textarea"></textarea></td>
				      </tr>
				      <tr>	
				     	<td class="inquire_item6"><font color="red">*</font>培训内容：</td>
				      	<td class="inquire_form6" colspan="3">
				      		<textarea  id="train_content" name="train_content" class="textarea" rows="" cols=""></textarea>
				      	</td>
				     </tr>
				   
				     
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
					 <tr class="bt_info" align="center">
				    	    <td>人数</td>
				            <td>学时</td>
				            <td>授课费</td>		
				            <td>交通费</td>
				            <td>材料费</td>
				            <td>场地费</td>
				            <td>食宿费</td>
				            <td>其它费用</td>
				            <td>费用合计</td>
				        </tr>
				        <tr class="odd" align="center">
				        	<td ><input type="text" id="train_num" name="train_num" class="input_width" onchange=""/></input></td>
				        	<td ><input type="text" id="train_class" name="train_class" class="input_width"  onchange=""/></td>
				        	<td ><input type="text" id="train_cost" name="train_cost" class="input_width"  onchange="changeMoney();"/></td>
				        	<td ><input type="text" id="train_transport" name="train_transport" class="input_width" onchange="changeMoney();"/></input></td>
				        	<td ><input type="text" id="train_material" name="train_material" class="input_width"  onchange="changeMoney();"/></td>
				        	<td ><input type="text" id="train_places" name="train_places" class="input_width"  onchange="changeMoney();"/></td>
				        	<td ><input type="text" id="train_accommodation" name="train_accommodation" class="input_width" onchange="changeMoney();"/></input></td>
				        	<td ><input type="text" id="train_other" name="train_other" class="input_width"  onchange="changeMoney();"/></td>
				        	<td ><input type="text" id="train_total" name="train_total" class="input_width"  onchange=""/></td>
				        </tr>
					
					</table>
				</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

cruConfig.contextPath =  "<%=contextPath%>";
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}

	function queryOrg(){
		retObj = jcdpCallService("HseSrv", "queryOrg", "");
		if(retObj.flag!="false"){
			var len = retObj.list.length;
			if(len>0){
				document.getElementById("second_org").value=retObj.list[0].orgSubId;
				document.getElementById("second_org2").value=retObj.list[0].orgAbbreviation;
			}
			if(len>1){
				document.getElementById("third_org").value=retObj.list[1].orgSubId;
				document.getElementById("third_org2").value=retObj.list[1].orgAbbreviation;
			}
		}
	}

function submitButton(){
	var form = document.getElementById("form");
		if(checkText()){
			return;
		}
debugger;
	form.action="<%=contextPath%>/hse/hseTraining/addHseTraining.srq";
	form.submit();
}

function closeButton(){
	var ctt = top.frames('list');
	ctt.refreshData();
	newClose();
}


function changeMoney(){
	var train_num = document.getElementById("train_num").value;
	var train_class = document.getElementById("train_class").value;
	
	var train_cost = document.getElementById("train_cost").value;
	var train_transport = document.getElementById("train_transport").value;
	var train_material = document.getElementById("train_material").value;
	var train_places = document.getElementById("train_places").value;
	var train_accommodation = document.getElementById("train_accommodation").value;
	var train_other = document.getElementById("train_other").value;
	
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  
	
	if(train_num!=""){
		if (!re.test(train_num))
		   {
		       alert("人数请输入数字！");
		       return;
		    }
	}
	if(train_class!=""){
		if (!re.test(train_class))
		   {
		       alert("学时请输入数字！");
		       return;
		    }
	}
	if(train_cost!=""){
		if (!re.test(train_cost))
		   {
		       alert("授课费请输入数字！");
		       return;
		    }
	}
	if(train_transport!=""){
		if (!re.test(train_transport))
		   {
		       alert("交通费请输入数字！");
		       return;
		    }
	}
	if(train_material!=""){
		if (!re.test(train_material))
		   {
		       alert("材料费请输入数字！");
		       return;
		    }
	}
	if(train_places!=""){
		if (!re.test(train_places))
		   {
		       alert("场地费请输入数字！");
		       return;
		    }
	}
	if(train_accommodation!=""){
		if (!re.test(train_accommodation))
		   {
		       alert("食宿费请输入数字！");
		       return;
		    }
	}
	if(train_other!=""){
		if (!re.test(train_other))
		   {
		       alert("其它费用请输入数字！");
		       return;
		    }
	}
	
	document.getElementById("train_total").value = toDecimal(toDecimal(Number(train_cost))+toDecimal(Number(train_transport))+toDecimal(Number(train_material))+toDecimal(Number(train_places))+toDecimal(Number(train_accommodation))+toDecimal(Number(train_other)));
}

//保留小数后几位   四舍五入
function toDecimal(x) {   
    var f = parseFloat(x);   
    if (isNaN(f)) {   
        return;   
    }   
    f = Math.round(x*1000)/1000;   
    return f;   
}

function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	document.getElementById("second_org").value = teamInfo.fkValue;
        document.getElementById("second_org2").value = teamInfo.value;
    }
}

function selectOrg2(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("second_org").value;
	var org_id="";
		var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
	   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
		}else{
			org_id = datas[0].org_id; 
	    }
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("third_org").value = teamInfo.fkValue;
		        document.getElementById("third_org2").value = teamInfo.value;
			}
}
toEdit();
function toEdit(){
	
	 	var checkSql="select tp.hse_plan_id,tp.lead_type, tp.train_object,tp.train_address,oi.org_abbreviation  second_org_name,oi1.org_abbreviation third_org_name,tp.project_name,tp.train_time,tp.second_org,tp.third_org,tp.bsflag,tp.modifi_date,tp.train_content,td.hse_detail_id, td.train_num,td.train_class,td.train_cost,td.train_transport,td.train_material,td.train_places,td.train_accommodation,td.train_other,td.train_total,tp.train_purpose from bgp_hse_train_plan tp left join bgp_hse_train_detail td on tp.hse_plan_id=td.hse_plan_id  left join comm_org_subjection os on tp.second_org = os.org_subjection_id and os.bsflag = '0' left join comm_org_information oi on os.org_id = oi.org_id and oi.bsflag = '0'  left join comm_org_subjection os1 on tp.third_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on os1.org_id = oi1.org_id and oi1.bsflag = '0' where tp.bsflag = '0' and tp.hse_plan_id ='<%=hse_plan_id%>'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
		if(datas==null||datas==""){
			
		}else{
			document.getElementById("hse_plan_id").value = datas[0].hse_plan_id;
			document.getElementById("hse_detail_id").value = datas[0].hse_detail_id;
			
			document.getElementById("lead_type").value = datas[0].lead_type;
			document.getElementById("second_org").value = datas[0].second_org;
			document.getElementById("second_org2").value = datas[0].second_org_name;
			document.getElementById("third_org").value = datas[0].third_org;
			document.getElementById("third_org2").value = datas[0].third_org_name;
			document.getElementById("train_object").value = datas[0].train_object;
			document.getElementById("train_address").value = datas[0].train_address;
			document.getElementById("project_name").value = datas[0].project_name;
			document.getElementById("train_time").value = datas[0].train_time;
			document.getElementById("train_purpose").value = datas[0].train_purpose;
			document.getElementById("train_content").value = datas[0].train_content;
			
			document.getElementById("train_num").value = datas[0].train_num;
			document.getElementById("train_class").value = datas[0].train_class;
			document.getElementById("train_cost").value = datas[0].train_cost;
			document.getElementById("train_transport").value = datas[0].train_transport;
			document.getElementById("train_material").value = datas[0].train_material;
			document.getElementById("train_places").value = datas[0].train_places;
			document.getElementById("train_accommodation").value = datas[0].train_accommodation;
			document.getElementById("train_other").value = datas[0].train_other;
			document.getElementById("train_total").value = datas[0].train_total;
		}
} 



function checkText(){
	var second_org2=document.getElementById("second_org2").value;
	var third_org2=document.getElementById("third_org2").value;
	
	var train_object = document.getElementById("train_object").value;
	var train_address = document.getElementById("train_address").value;
	var train_time = document.getElementById("train_time").value;
	var train_purpose = document.getElementById("train_purpose").value;
	var train_content = document.getElementById("train_content").value;
	if(second_org2==""){
		document.getElementById("second_org").value = "";
	}
	if(third_org2==""){
		document.getElementById("third_org").value="";
	}
	if(train_object==""){
		alert("培训对象不能为空，请选择！");
		return true;
	}
	if(train_address==""){
		alert("培训地址不能为空，请填写！");
		return true;
	}
	if(train_time==""){
		alert("培训时间不能为空，请填写！");
		return true;
	}
	if(train_purpose==""){
		alert("培训目的不能为空，请选择！");
		return true;
	}
	if(train_content==""){
		alert("培训内容不能为空，请选择！");
		return true;
	}
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

	return false;
}


</script>
</html>