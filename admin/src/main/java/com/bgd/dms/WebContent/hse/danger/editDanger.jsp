<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    Map map=resultMsg.getMsgElement("map").toMap();
    String hse_danger_id=resultMsg.getValue("hse_danger_id");
   
    
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>

</head>
<body>
<form name="form1" id="form1"  method="post" action="<%=contextPath%>/hse/editDanger.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
		<input type="hidden" id="hse_danger_id" name="hse_danger_id" value="<%=hse_danger_id %>">
    <tr>
     	<td class="inquire_item6">单位：</td>
		<td class="inquire_form6">
			<input type="hidden" id="second_org" name="second_org" class="input_width" value="<%=map.get("secondOrg")%>"/>
			<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"  value="<%=map.get("secondOrgName") %>" />
			<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
			<%} %>
		</td>
		<td class="inquire_item6">基层单位：</td>
		<td class="inquire_form6">
			<input type="hidden" id="third_org" name="third_org" class="input_width" value="<%=map.get("thirdOrg") %>"/>
			<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"  value="<%=map.get("thirdOrgName")%>"/>
			<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
			<%} %>
		</td>
		<td class="inquire_item6">下属单位：</td>
		<td class="inquire_form6">
			<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" value="<%=map.get("fourthOrg") %>"/>
			<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"  value="<%=map.get("fourthOrgName")%>"/>
			<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
			<%} %>
		</td>
    </tr>
    <tr>
    	<td class="inquire_item6"><font color="red">*</font>隐患名称：</td>
      	<td class="inquire_form6"><input type="text" id="danger_name" name="danger_name" class="input_width" value="<%=(String)map.get("dangerName") %>" /></td>
    	<td class="inquire_item6"><font color="red">*</font>隐患级别：</td>
		<td class="inquire_form6">
			<select id="danger_level" name="danger_level"  class="select_width">
				<option value="" >请选择</option>
				<option value="一般" >一般</option>
				<option value="较大" >较大</option>
				<option value="重大" >重大</option>
				<option value="特大" >特大</option>
			</select>
		</td>
    	<td class="inquire_item6"><font color="red">*</font>隐患类型：</td>
      	<td class="inquire_form6"><input type="text" id="danger_type" name="danger_type" class="input_width" value="<%=(String)map.get("dangerType") %>" /></td>
    </tr>
    <tr>
    	<td class="inquire_item6"><font color="red">*</font>上报日期：</td>
      	<td class="inquire_form6"><input type="text" id="danger_date" name="danger_date" class="input_width" value="<%=(String)map.get("dangerDate") %>"  />
      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(danger_date,tributton1);" />&nbsp;</td>
    	<td class="inquire_item6"><font color="red">*</font>危害因素大类：</td>
      	<td class="inquire_form6"><input type="text" id="danger_big" name="danger_big" class="input_width" value="<%=(String)map.get("dangerBig") %>" /></td>
     	<td class="inquire_item6"><font color="red">*</font>危害因素中类：</td>
      	<td class="inquire_form6"><input type="text" id="danger_midd" name="danger_midd" class="input_width" value="<%=(String)map.get("dangerMidd") %>" /></td>
    </tr>
    <tr>
     	<td class="inquire_item6"><font color="red">*</font>作业场所：</td>
      	<td class="inquire_form6"><input type="text" id="danger_place" name="danger_place" class="input_width" value="<%=(String)map.get("dangerPlace") %>" /></td>
     	<td class="inquire_item6"></td>
      	<td class="inquire_form6"></td>
     	<td class="inquire_item6"></td>
      	<td class="inquire_form6"></td>
    </tr>
    <tr>
		<td class="inquire_item6"><font color="red">*</font>危害影响：</td>
		<td class="inquire_form6" colspan="5"><textarea id="danger_effect" name="danger_effect"  class="textarea"><%=(String)map.get("dangerEffect") %></textarea></td>
	</tr>	
	<tr>
		<td class="inquire_item6"><font color="red">*</font>隐患描述：</td>
		<td class="inquire_form6" colspan="5"><textarea id="danger_des" name="danger_des"  class="textarea"><%=(String)map.get("dangerDes") %></textarea></td>
	<tr>	
</table>
</div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submit()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

document.getElementById("danger_level").value="<%=(String)map.get("dangerLevel")%>";


//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}

	function submit(){
		if(checkText()){
			return;
		}
		document.getElementById("form1").submit();
	}
	
	
	function checkText(){
		var second_org2=document.getElementById("second_org2").value;
		var third_org2=document.getElementById("third_org2").value;
		var fourth_org2=document.getElementById("fourth_org2").value;
		var danger_name=document.getElementById("danger_name").value;
		var danger_level=document.getElementById("danger_level").value;
		var danger_date=document.getElementById("danger_date").value;
		var danger_type=document.getElementById("danger_type").value;
		var danger_place=document.getElementById("danger_place").value;
		var danger_big = document.getElementById("danger_big").value;
		var danger_midd = document.getElementById("danger_midd").value;
		if(second_org2==""){
			document.getElementById("second_org").value = "";
		}
		if(third_org2==""){
			document.getElementById("third_org").value="";
		}
		if(fourth_org2==""){
			document.getElementById("fourth_org").value="";
		}
		if(danger_name==""){
			alert("隐患名称不能为空，请填写！");
			return true;
		}
		if(danger_level==""){
			alert("隐患级别不能为空，请选择！");
			return true;
		}
		if(danger_date==""){
			alert("上报日期不能为空，请填写！");
			return true;
		}
		if(danger_type==""){
			alert("隐患类型不能为空，请填写！");
			return true;
		}
		if(danger_place==""){
			alert("作业场所不能为空，请填写！");
			return true;
		}
		if(danger_big==""){
			alert("危害因素大类不能为空，请填写！");
			return true;
		}
		if(danger_midd==""){
			alert("危害因素中类不能为空，请填写！");
			return true;
		}
		return false;
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
	
	function selectOrg3(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("third_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
			        document.getElementById("fourth_org2").value = teamInfo.value;
				}
	}
	
</script>
</html>