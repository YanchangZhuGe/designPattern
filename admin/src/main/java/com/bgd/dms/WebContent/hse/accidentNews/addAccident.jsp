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
	String hse_accident_id ="";
	String second_org = "";
	String third_org = "";
	String second_org2 = "";
	String third_org2 = "";
	String accident_name = "";
	String accident_type = "";
	String accident_date = "";
	String accident_place = "";
	String workplace_flag = "";
	String out_flag = "";
	String out_name = "";
	String out_type = "";
	String accident_money = "";
	String number_die = "";
	String number_harm = "";
	String number_injure = "";
	String number_lose = "";
	String accident_process = "";
	String accident_reason = "";
	String accident_result = "";
	String accident_sugg = "";
	String write_date = "";
	String write_name = "";
	String duty_name = "";
	
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
	
//	String index = "1";
	if(resultMsg!=null){
	 hse_accident_id = resultMsg.getValue("hse_accident_id");
	 second_org = resultMsg.getValue("second_org");
	 third_org = resultMsg.getValue("third_org");
	 second_org2 = resultMsg.getValue("second_org2");
	 third_org2 = resultMsg.getValue("third_org2");
	 accident_name = resultMsg.getValue("accident_name");
	 accident_type = resultMsg.getValue("accident_type");
     accident_date = resultMsg.getValue("accident_date");
	 accident_place = resultMsg.getValue("accident_place");
	 workplace_flag = resultMsg.getValue("workplace_flag");
	 out_flag = resultMsg.getValue("out_flag");
	 out_name = resultMsg.getValue("out_name");
	 out_type = resultMsg.getValue("out_type");
	 accident_money = resultMsg.getValue("accident_money");
	 number_die = resultMsg.getValue("number_die");
	 number_harm = resultMsg.getValue("number_harm");
	 number_injure = resultMsg.getValue("number_injure");
	 number_lose = resultMsg.getValue("number_lose");
	 accident_process = resultMsg.getValue("accident_process");
	 accident_reason = resultMsg.getValue("accident_reason");
	 accident_result = resultMsg.getValue("accident_result");
	 accident_sugg = resultMsg.getValue("accident_sugg");
	 write_date = resultMsg.getValue("write_date");
	 write_name = resultMsg.getValue("write_name");
	 duty_name = resultMsg.getValue("duty_name");

//	 index = resultMsg.getValue("index");
	}
//	int index22 = Integer.parseInt(index);
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
<input type="hidden" id="hse_accident_id" name="hse_accident_id" value="<%=hse_accident_id %>"/>
<input type="hidden" id="isProject" name="isProject" value="<%=isProject %>"/>
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
				      	<td class="inquire_item6">下属单位：</td>
				      	<td class="inquire_form6">
				      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
				      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
				      	<%}%>
				      	</td>
				     </tr>
					 <tr>
				    	<td class="inquire_item6"><font color="red">*</font>事故名称：</td>
				      	<td class="inquire_form6"><input type="text" id="accident_name" name="accident_name" class="input_width"  value="<%=accident_name%>"/></td>
				     	<td class="inquire_item6"><font color="red">*</font>事故类型：</td>
				      	<td class="inquire_form6">
				      	<select id="accident_type" name="accident_type" class="select_width">
					       <option value="" >请选择</option>
					       <%
					          	String sql = "select * from comm_coding_sort_detail where coding_sort_id='5110000042' and superior_code_id='0' and bsflag='0' order by coding_show_id desc";
					          	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
					          	for(int i=0;i<list.size();i++){
					          		Map map = (Map)list.get(i);
					          		String coding_id = (String)map.get("codingCodeId");
					          		String coding_name = (String)map.get("codingName");
					       %>
					       <option value="<%=coding_id %>" ><%=coding_name %></option>
					       <%} %>
						</select>
				      	</td>
				    	<td class="inquire_item6"><font color="red">*</font>事故日期：</td>
				      	<td class="inquire_form6"><input type="text" id="accident_date" name="accident_date" class="input_width"   value="<%=accident_date %>" readonly="readonly"/>
				      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="timeSelector(accident_date,tributton1);" />&nbsp;</td>
				     </tr>
				     <tr>
				     	<td class="inquire_item6"><font color="red">*</font>事故地点：</td>
				      	<td class="inquire_form6"><input type="text" id="accident_place" name="accident_place" class="input_width"   value="<%=accident_place %>"/></td>
				    	<td class="inquire_item6"><font color="red">*</font>是否属于工作场所：</td>
				      	<td class="inquire_form6">
				      	<select id="workplace_flag" name="workplace_flag" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
				      	</td>
				     	<td class="inquire_item6"><font color="red">*</font>是否为承包商：</td>
				      	<td class="inquire_form6">
				      	<select id="out_flag" name="out_flag" class="select_width" onclick="outMust()">
					       <option value="" >请选择</option>
					       <option value="1" >是</option>
					       <option value="0" >否</option>
						</select>
				      	</td>
				     </tr>
				     <tr>
				    	<td class="inquire_item6"><font color="red" id="out_must1" style="display: none">*</font>承包商名称：</td>
				      	<td class="inquire_form6"><input type="text" id="out_name" name="out_name" class="input_width"   value="<%=out_name %>"/></td>
				     	<td class="inquire_item6"><font color="red" id="out_must2" style="display: none">*</font>承包商类型：</td>
				      	<td class="inquire_form6">
				      	<select id="out_type" name="out_type" class="select_width" d>
					       <option value="" >请选择</option>
					       <option value="1" >集团内</option>
					       <option value="0" >集团外</option>
						</select>
				      	</td>
				    	<td class="inquire_item6"><font color="red">*</font>初步估计经济损失：</td>
				      	<td class="inquire_form6"><input type="text" id="accident_money" name="accident_money" class="input_width"   value="<%=accident_money %>"/>元</td>
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

//var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
//var showTabBox = document.getElementById("tab_box_content0");

document.getElementById("workplace_flag").value='<%=workplace_flag%>';
document.getElementById("out_flag").value='<%=out_flag%>';
document.getElementById("out_type").value='<%=out_type%>';
document.getElementById("accident_type").value='<%=accident_type%>';
var hse_accident_id = '<%=hse_accident_id%>';

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
			if(len>2){
				document.getElementById("fourth_org").value=retObj.list[2].orgSubId;
				document.getElementById("fourth_org2").value=retObj.list[2].orgAbbreviation;
			}
		}
	}




function outMust(){
	if(document.getElementById("out_flag").value=="1"){
		document.getElementById("out_must1").style.display="";
		document.getElementById("out_must2").style.display="";
		document.getElementById("out_name").disabled="";
		document.getElementById("out_type").disabled="";
	}else{
		document.getElementById("out_must1").style.display="none";
		document.getElementById("out_must2").style.display="none";
		document.getElementById("out_name").disabled="disabled";
		document.getElementById("out_type").disabled="disabled";
	}
}

function submitButton(){
	var form = document.getElementById("form");
		if(checkText0()){
			return;
		}
		form.action="<%=contextPath%>/hse/accident/addNewsInfo2.srq";
	form.submit();
}

function closeButton(){
	var ctt = top.frames['list'];
	ctt.refreshData();
	newClose();
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

function checkText0(){
	var second_org2=document.getElementById("second_org2").value;
	var third_org2=document.getElementById("third_org2").value;
	var fourth_org2=document.getElementById("fourth_org2").value;
	var accident_name=document.getElementById("accident_name").value;
	var accident_type=document.getElementById("accident_type").value;
	var accident_date=document.getElementById("accident_date").value;
	var accident_place=document.getElementById("accident_place").value;
	var workplace_flag = document.getElementById("workplace_flag").value;
	var accident_money = document.getElementById("accident_money").value;
	var out_flag = document.getElementById("out_flag").value;
	var out_name = document.getElementById("out_name").value;
	var out_type = document.getElementById("out_type").value;
	if(second_org2==""){
		document.getElementById("second_org").value = "";
	}
	if(third_org2==""){
		document.getElementById("third_org").value="";
	}
	if(fourth_org2==""){
		document.getElementById("fourth_org").value="";
	}
	if(accident_name==""){
		alert("事故名称不能为空，请填写！");
		return true;
	}
	if(accident_type==""){
		alert("事故类型不能为空，请选择！");
		return true;
	}
	if(accident_date==""){
		alert("事故日期不能为空，请填写！");
		return true;
	}
	if(accident_place==""){
		alert("事故地点不能为空，请填写！");
		return true;
	}
	if(workplace_flag==""){
		alert("是否属于工作场所不能为空，请选择！");
		return true;
	}
	if(out_flag==""){
		alert("是否为承包商不能为空，请选择！");
		return true;
	}
	if(out_flag=="1"){
		if(out_name==""){
			alert("承包商名称不能为空，请填写！");
			return true;
		}
		if(out_type==""){
			alert("承包商类型不能为空，请选择！");
			return true;
		}
	}
	if(accident_money==""){
		alert("初步估计经济损失不能为空，请填写！");
		return true;
	}
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    if (!re.test(accident_money))
   {
       alert("初步估计经济损失请输入数字！");
       return true;
    }
	return false;
}

function checkText1(){
	var number_die = document.getElementById("number_die").value;
	var number_harm=document.getElementById("number_harm").value;
	var number_injure=document.getElementById("number_injure").value;
	var number_lose=document.getElementById("number_lose").value;
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    
	if(number_die==""){
		alert("死亡人数不能为空，请填写！");
		return true;
	}
	if (!re.test(number_die))
	   {
	       alert("死亡人数请输入数字！");
	       return true;
	    }
	if(number_harm==""){
		alert("重伤人数不能为空，请填写！");
		return true;
	}
	if (!re.test(number_harm))
	   {
	       alert("重伤人数请输入数字！");
	       return true;
	    }
	if(number_injure==""){
		alert("轻伤人数不能为空，请填写！");
		return true;
	}
	if (!re.test(number_injure))
	   {
	       alert("轻伤人数请输入数字！");
	       return true;
	    }
	if(number_lose==""){
		alert("失踪人数不能为空，请填写！");
		return true;
	}
	if (!re.test(number_lose))
	   {
	       alert("失踪人数请输入数字！");
	       return true;
	    }
	return false;
}

function checkText2(){
	var write_date=document.getElementById("write_date").value;
	var write_name=document.getElementById("write_name").value;
	var duty_name = document.getElementById("duty_name").value;
	var accident_process=document.getElementById("accident_process").value;
	var accident_reason=document.getElementById("accident_reason").value;
	var accident_result=document.getElementById("accident_result").value;
	var accident_sugg=document.getElementById("accident_sugg").value;
	if(write_date==""){
		alert("填报日期不能为空，请填写！");
		return true;
	}
	if(write_name==""){
		alert("填报人不能为空，请填写！");
		return true;
	}
	if(duty_name==""){
		alert("负责人不能为空，请填写！");
		return true;
	}
	if(accident_process==""){
		alert("事故简要经过不能为空，请填写！");
		return true;
	}
	if(accident_process.length<50){
		alert("事故简要经过不得小于50字！");
		return true;
	}
	if(accident_reason==""){
		alert("初步原因分析不能为空，请填写！");
		return true;
	}
	if(accident_reason.length<30){
		alert("初步原因分析不得小于30字！");
		return true;
	}
	if(accident_result==""){
		alert("目前处理情况不能为空，请填写！");
		return true;
	}
	if(accident_sugg==""){
		alert("意见不能为空，请选择！");
		return true;
	}
	return false;
}



</script>
</html>