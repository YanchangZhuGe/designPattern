<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	Map mapInfo = resultMsg.getMsgElement("map").toMap();
	
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
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
</head>
<body>
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_safeshare_id" name="hse_safeshare_id" value="<%=(String)mapInfo.get("hseSafeshareId") %>"/>
<input type="hidden" id="isProject" name="isProject" value="<%=isProject %>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
			<tr>
				<td class="inquire_item6"><font color="red">*</font>标题：</td>
				<td class="inquire_form6" colspan="5"><input type="text" id="safe_name" name="safe_name" class="input_width" value="<%=(String)mapInfo.get("safeName") %>"></input></td>
			</tr>
			<tr>
				<td class="inquire_item6">单位：</td>
				<td class="inquire_form6">
					<input type="hidden" id="second_org" name="second_org" class="input_width" value="<%=mapInfo.get("secondOrg")%>"/>
					<input type="text" id="second_org2" name="second_org2" class="input_width" <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"  value="<%=mapInfo.get("secondOrgName") %>" />
					<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
					<%} %>
				</td>
				<td class="inquire_item6">基层单位：</td>
				<td class="inquire_form6">
					<input type="hidden" id="third_org" name="third_org" class="input_width" value="<%=mapInfo.get("thirdOrg") %>"/>
					<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"  value="<%=mapInfo.get("thirdOrgName")%>"/>
					<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
					<%} %>
				</td>
				<td class="inquire_item6">下属单位：</td>
				<td class="inquire_form6">
					<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" value="<%=mapInfo.get("fourthOrg") %>"/>
					<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"  value="<%=mapInfo.get("fourthOrgName")%>"/>
					<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					<%} %>
				</td>
			</tr>
			<tr>
				<td class="inquire_item6"><font color="red">*</font>发表时间：</td>
				<td class="inquire_form6"><input type="text" id="safe_date" name="safe_date" class="input_width" value="<%=(String)mapInfo.get("safeDate") %>" readonly="readonly"/>
				&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(safe_date,tributton1);" />&nbsp;
				</td>
				<td class="inquire_item6"><font color="red">*</font>安全经验类别：</td>
				<td class="inquire_form6">
					<select id="safe_type" name="safe_type" class="select_width">
						<option value="" >请选择</option>
						<% String sql = "select * from comm_coding_sort_detail where  coding_sort_id='5110000026' order by coding_show_id"; 
							List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
							for(int i= 0;i<list.size();i++){
								Map map=(Map)list.get(i);
								String coding_code = (String)map.get("codingCode");
								String coding_name = (String)map.get("codingName");
						%>
						<option value="<%=coding_code %>" ><%=coding_name %></option>
						<%} %>
					</select>
				</td>
				<td class="inquire_item6"><font color="red">*</font>材料类型：</td>
				<td class="inquire_form6">
					<select id="info_type" name="info_type" class="select_width">
						<option value="" >请选择</option>
						<% String sql2 = "select * from comm_coding_sort_detail where  coding_sort_id='5110000027' order by coding_show_id"; 
							List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
							for(int i= 0;i<list2.size();i++){
								Map map=(Map)list2.get(i);
								String coding_code = (String)map.get("codingCode");
								String coding_name = (String)map.get("codingName");
						%>
						<option value="<%=coding_code %>" ><%=coding_name %></option>
						<%} %>
					</select>
				</td>
			</tr>
			<tr>
				<td class="inquire_item6"><font color="red">*</font>分享人：</td>
				<td class="inquire_form6"><input type="text" id="share_person" name="share_person" value="<%=(String)mapInfo.get("sharePerson") %>" class="input_width"></input></td>
				<td class="inquire_item6">分享场合：</td>
				<td class="inquire_form6"><input type="text" id="share_occasion" name="share_occasion" value="<%=(String)mapInfo.get("shareOccasion") %>" class="input_width"></input></td>
				<td class="inquire_item6"><font color="red">*</font>上传人：</td>
				<td class="inquire_form6"><input type="text" id="upload_person" name="upload_person" value="<%=(String)mapInfo.get("uploadPerson") %>" class="input_width"></input></td>
			</tr>	
			<tr>
				<td class="inquire_item6"><font color="red">*</font>内容：</td>
				<td class="inquire_form6" colspan="5"><textarea id="content" name="content" class="textarea"><%=(String)mapInfo.get("content") %></textarea></td>
			</tr>
		</table>
	</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
document.getElementById("safe_type").value="<%=(String)mapInfo.get("safeType") %>";
document.getElementById("info_type").value="<%=(String)mapInfo.get("infoType") %>";

//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
	}
}

function submitButton(){
	var form = document.getElementById("form");
		if(checkText()){
			return;
		}
	form.action="<%=contextPath%>/hse/safe/addSafeShare.srq";
	form.submit();
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

function checkText(){
	var safe_name=document.getElementById("safe_name").value;
	var second_org2=document.getElementById("second_org2").value;
	var third_org2=document.getElementById("third_org2").value;
	var fourth_org2=document.getElementById("fourth_org2").value;
	var safe_date=document.getElementById("safe_date").value;
	var safe_type=document.getElementById("safe_type").value;
	var info_type=document.getElementById("info_type").value;
	var upload_person=document.getElementById("upload_person").value;
	var share_person=document.getElementById("share_person").value;
	var content=document.getElementById("content").value;
	if(safe_name==""){
		alert("标题不能为空，请填写！");
		return true;
	}
	if(second_org2==""){
		document.getElementById("second_org").value = "";
	}
	if(third_org2==""){
		document.getElementById("third_org").value="";
	}
	if(fourth_org2==""){
		document.getElementById("fourth_org").value="";
	}
	if(safe_date==""){
		alert("发表时间不能为空，请选择！");
		return true;
	}
	if(safe_type==""){
		alert("安全经验类别不能为空，请选择！");
		return true;
	}
	if(info_type==""){
		alert("材料类型不能为空，请选择！");
		return true;
	}
	if(share_person==""){
		alert("分享人不能为空，请填写！");
		return true;
	}
	if(upload_person==""){
		alert("上传人不能为空，请填写！");
		return true;
	}
	
	if(content==""){
		alert("内容不能为空，请填写！");
		return true;
	}
	if(content.length>2000){
		alert("字数不能超过2000，您已经输入了"+content.length+"个字");
		return true;
	}
	return false;
}

</script>
</html>