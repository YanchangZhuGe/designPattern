<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();

	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String hse_evaluation_id = request.getParameter("hse_evaluation_id");
	if(hse_evaluation_id==null){
		hse_evaluation_id = "";
	}
	String evaluation_type = "";
	String evaluation_date = "";
	
//	String index = "1";
	if(resultMsg!=null){
	 hse_evaluation_id = resultMsg.getValue("hse_evaluation_id");
	 evaluation_type = resultMsg.getValue("evaluation_type");
	 evaluation_date = resultMsg.getValue("evaluation_date");
	}
	
	String isProject = request.getParameter("isProject");
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
<input type="hidden" id="hse_evaluation_id" name="hse_evaluation_id" value="<%=hse_evaluation_id %>"/>
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
			     	<td class="inquire_item6"><font color="red">*</font>评价类别：</td>
			      	<td class="inquire_form6">
			      	<select id="evaluation_type" name="evaluation_type" class="select_width">
				       <option value="0" >请选择</option>
				       <option value="1" >岗前</option>
				       <option value="2" >岗中</option>
					</select>
			      	</td>
			    	<td class="inquire_item6"><font color="red">*</font>评价日期：</td>
			      	<td class="inquire_form6"><input type="text" id="evaluation_date" name="evaluation_date" class="input_width"   value="<%=evaluation_date %>" readonly="readonly"/>
			      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(evaluation_date,tributton1);" />&nbsp;</td>
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

document.getElementById("evaluation_type").value='<%=evaluation_type%>';
var hse_accident_id = '<%=hse_evaluation_id%>';

cruConfig.contextPath =  "<%=contextPath%>";
	//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8 || event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
	}

	function queryOrg(){
		var retObj = jcdpCallService("HseSrv", "queryOrg", "");
		if(retObj.returnCode =='0'){
			if(retObj.list!=null){
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
		var hse_evaluation_id = '<%=hse_evaluation_id%>';
		retObj = jcdpCallService("HseOperationSrv", "getEvaluationDetail", "hse_evaluation_id="+hse_evaluation_id);
		if(retObj.returnCode =='0'){
			var map = retObj.evaluationMap;
			if(map!=null){
				document.getElementById("hse_evaluation_id").value =hse_evaluation_id;
				document.getElementById("second_org").value =map.second_org;
				document.getElementById("third_org").value =map.third_org;
				document.getElementById("fourth_org").value =map.fourth_org;
				document.getElementById("second_org2").value =map.second_name;
				document.getElementById("third_org2").value =map.third_name;
				document.getElementById("fourth_org2").value =map.fourth_name;
				document.getElementById("evaluation_date").value = map.evaluation_date;
				var evaluation_type = document.getElementById("evaluation_type");
				var value = map.evaluation_type;
				if(evaluation_type!=null && evaluation_type.options.length>0){
					for(var i =0; i<evaluation_type.options.length;i++){
						var option = evaluation_type.options[i];
						if(value == option.value){
							option.selected = true;
						}
					}
				}
			}
		}
	}

	function outMust(){
		if(document.getElementById("out_flag").value=="1"){
			document.getElementById("out_must1").style.display="";
			document.getElementById("out_must2").style.display="";
		}else{
			document.getElementById("out_must1").style.display="none";
			document.getElementById("out_must2").style.display="none";
		}
	}
	
	function submitButton(){
		var form = document.getElementById("form");
		var ctt = top.frames['list'];
		if(checkText0()){
			return;
		}
		var hse_evaluation_id = document.getElementById("hse_evaluation_id").value;	
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var evaluation_type = document.getElementById("evaluation_type").value;
		var evaluation_date = document.getElementById("evaluation_date").value;
		var substr = 'second_org='+second_org+'&third_org='+third_org+
		'&fourth_org='+fourth_org+'&evaluation_type='+evaluation_type+'&evaluation_date='+evaluation_date+'&isProject=<%=isProject%>';
		if(hse_evaluation_id!=null && hse_evaluation_id!=''){
			substr = substr +'&hse_evaluation_id='+hse_evaluation_id;
		}
		var obj = jcdpCallService("HseOperationSrv", "saveEvaluation", substr);
		if(obj.returnCode == '0'){
			var keyId = obj.hse_evaluation_id;
			var obj = new Object();
			//obj.name='dddd';
			window.showModalDialog('<%=contextPath%>/hse/orgAndResource/staffEvaluation/editEvaluationStaff.jsp?isProject=<%=isProject%>&hse_evaluation_id='+keyId+'&evaluation_date='+evaluation_date,
						obj,'dialogWidth=1280px;dialogHeight=768px');
			ctt.refreshData();
			newClose();
			<%-- window.open('<%=contextPath%>/hse/orgAndResource/staffEvaluation/editEvaluationStaff.jsp?hse_evaluation_id='+keyId,
					'staff', 'height=100, width=400, top=0,left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no'); --%>
		}
		
	}
	
	function closeButton(){
		var ctt = top.frames('list');
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
		var evaluation_type=document.getElementById("evaluation_type").value;
		var evaluation_date=document.getElementById("evaluation_date").value;
		if(second_org2==""){
			document.getElementById("second_org").value = "";
		}
		if(third_org2==""){
			document.getElementById("third_org").value="";
		}
		if(fourth_org2==""){
			document.getElementById("fourth_org").value="";
		}
		if(evaluation_type=="0"){
			alert("评价类别不能为空，请填写！");
			return true;
		}
		if(evaluation_date==""){
			alert("评价日期不能为空，请选择！");
			return true;
		}
		return false;
	}

</script>
</html>