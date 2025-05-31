<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="code" prefix="code"%> 
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String org_name = user.getOrgName();
	String user_name = user.getUserName();
	String user_id = user.getUserId();
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no ==null){
		project_info_no = "";
	}

	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String now = df.format(new Date());
	String hse_evaluation_id =request.getParameter("hse_evaluation_id");
	String evaluation_type = "";
	String isAction = request.getParameter("isAction");
	String evaluation_date = request.getParameter("evaluation_date");
	if(evaluation_date==null||evaluation_date.equals("")){
		evaluation_date = now;
	}
	
	
	
	if(isAction!=null&&isAction.equals("edit")){
		if(hse_evaluation_id!=null&&!hse_evaluation_id.equals("")){
			String sql = "select * from bgp_hse_evaluation t where t.hse_evaluation_id='"+hse_evaluation_id+"'";
			Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
			if(map!=null){
				user_name = (String)map.get("appraiser");
				evaluation_date = (String)map.get("evaluationDate");
				String second_org = (String)map.get("secondOrg");
				String third_org = (String)map.get("thirdOrg");
				String fourth_org = (String)map.get("fourthOrg");
				Map mapOrgName = null;
				if(fourth_org!=null&&!fourth_org.equals("")){
					String sqlOrgName = "select oi.org_name from comm_org_information oi join comm_org_subjection os on oi.org_id=os.org_id and os.bsflag='0' where oi.bsflag='0' and os.org_subjection_id='"+fourth_org+"'";
					mapOrgName = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlOrgName);
				}else if(third_org!=null&&!third_org.equals("")){
					String sqlOrgName = "select oi.org_name from comm_org_information oi join comm_org_subjection os on oi.org_id=os.org_id and os.bsflag='0' where oi.bsflag='0' and os.org_subjection_id='"+third_org+"'";
					mapOrgName = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlOrgName);
				}else if(second_org!=null&&!second_org.equals("")){
					String sqlOrgName = "select oi.org_name from comm_org_information oi join comm_org_subjection os on oi.org_id=os.org_id and os.bsflag='0' where oi.bsflag='0' and os.org_subjection_id='"+second_org+"'";
					mapOrgName = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlOrgName);
				}
				if(mapOrgName!=null){
					org_name = (String)mapOrgName.get("orgName"); 
				}
			}
		}
	}
	
	if(resultMsg!=null){
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
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/orgAndResource/staffEvaluation/evaluation.js"></script>
<style type="text/css">
#new_table_box {
	width:1280px;
	height:640px;
}
#new_table_box_content {
	width:1260px;
	height:660px;
	border:1px #999 solid;
	background:#fff;
	padding:10px;
}
#new_table_box_bg {
	width:1240px;
	height:600px;
	border:1px #aebccb solid;
	background:#f1f2f3;
	padding:10px;
	overflow:auto;
}
</style>
</head>
<body >
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="hse_evaluation_id" name="hse_evaluation_id" value="<%=hse_evaluation_id %>"/>
<input type="hidden" id="project_info_no" name="project_info_no" value="<%=project_info_no %>"/>
<input type="hidden" id="user_id" name="user_id" value="<%=user_id %>"/>
<div id="new_table_box">
  <div id="new_table_box_content">
  	<div id="new_table_box_bg">
		<table id="staff"  width="100%" border="1px" bordercolor="black" cellspacing="1px" cellpadding="1px" class="tab_line_height" style="margin-top: 10px;" >
			<tr>
				<td colspan="14" align="center"><font size="5"><strong >员工能力评价表</strong></font></td>
			</tr>
			<tr>
				<td colspan="1" align="right"><font color="red">*</font><strong >单位：</strong></td>
			   	<td colspan="9"><input type="text" id="staff_org" name="staff_org" class="input_width" value="<%=org_name%>"/></td>
				<td colspan="4" align="right"><strong >BGP-HSE-JL5.4-1</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td rowspan="3" align="center"><font color="red">*</font><strong >姓名</strong></td>
				<td rowspan="3" align="center"><strong >岗位</strong></td>
				<td colspan="10" align="center"><strong >评  价  内  容</strong></td>
				<td align="center"><strong >评 价 结 果</strong></td>
				<td   align="center"><strong >操作</strong></td>
			</tr>
			<tr>
				<td  colspan="2" align="center"><strong >身体状况</strong></td>
				<td  colspan="3" align="center"><strong >岗位资历要求</strong></td>
				<td  colspan="3" align="center"><strong >岗位培训情况</strong></td>
				<td  rowspan="2" align="center"><strong >工作责任心</strong></td>
				<td  rowspan="2" align="center"><strong >岗位所需的应急处理能力</strong></td>
				<td  rowspan="2" align="center"><font color="red">*</font><strong >能否胜任</strong></td>
			    <auth:ListButton functionId="" css="dr" event="onclick='toUploadFile()'" title="导入" ></auth:ListButton>
			</tr>
			<tr>
				<td align="center"><strong >健康状况</strong></td>
				<td align="center"><strong >职业禁忌症</strong></td>
				<td align="center"><strong >文化程度</strong></td>
				<td align="center"><strong >工作经历</strong></td>
				<td align="center"><strong >面试考核</strong></td>
				<td align="center"><strong >资格证书</strong></td>
				<td align="center"><strong >理论考试</strong></td>
				<td align="center"><strong >&nbsp;&nbsp;实际操作&nbsp;&nbsp;</strong></td>
				<auth:ListButton functionId="" css="zj" event="onclick=addOne('')" title="JCDP_btn_add"></auth:ListButton>
			</tr>
		   <%--  <tr>
				<td ><input type="hidden" name="hse_evaluation_staff" class="input_width"/>
					<input type="text" name="staff_name" class="input_width" value="夏"/>
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/></td>
				<td ><input type="text" name="staff_position"  value="岗位" class="input_width" /></td>
				<td ><input type="text" name="staff_health" value="健康" class="input_width"/></td>
				<td ><input type="text" name="constraindication" value="职业" class="input_width"/></td>
				<td ><input type="text" name="degrees" value="文化" class="input_width"/></td>
				<td ><input type="text" name="work_experience" value="经历" class="input_width"/></td>
				<td ><input type="text" name="interview" value="面试" class="input_width"/></td>
				<td ><input type="text" name="qualification" value="证书" class="input_width"/></td>
				<td ><input type="text" name="exam" value="98" onkeydown="javascript:return checkIfNum(event);" onblur="checkNum(event)" class="input_width" /></td>
				<td ><select name="subversion" class="select_width" >
			    	<option value="" >请选择</option>
			    	<option value="1" >合格</option>
			       	<option value="0" >不合格</option>
				</select></td>
				<td ><input type="text" id="work_ethic" name="work_ethic" value="责任心" class="input_width"/></td>
				<td ><input type="text" id="emergency_power" name="emergency_power" value="能力" class="input_width"/></td>
				<td ><select name="competent" onchange="checkNum(event)" class="select_width" >
			    	<option value="" >请选择</option>
			    	<option value="1" >√</option>
			       	<option value="0" >X</option>
				</select></td>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			</tr>  --%>
			<tr>
		    	<td align="right"><strong >评价日期：</strong></td>
		      	<td colspan="6"><input type="text" id="evaluation_date" name="evaluation_date" class="input_width"   value="<%=evaluation_date %>" readonly="readonly"/>
		      <div  style="display:none">	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" name="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="timeSelector(evaluation_date,tributton1);" />&nbsp;</div></td>
	     		<td align="right"><font color="red">*</font><strong >评价人：</strong></td>
		      	<td colspan="6"><input type="text" id="appraiser" name="appraiser" class="input_width"   value="<%=user_name %>" /></td>
	     	</tr>
	     	<tr>
		    	<td align="left"  colspan="14" style="width:100%;word-wrap : break-word;word-break: break-all;">注：1、评价依据为岗位作业指导书或岗位说明书中明确的上岗条件。2、评价内容的1-5项为否决项，一项不胜任即可认定能力评价不合格。3、评价结果由评价单位留存。评价单位评价后，更新、替换之前的评价表。
		    	<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4、应能提供表中所列评价项目相关的体检证明、学历证明、工作履历、培训证明、绩效考核结果等证实性资料。5、理论考试填写具体考试分数，低于70分为不胜任；实际操作结果为“合格”“不合格”。
		    	<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6、评价结果：胜任打“√”，不胜任打“×”。</td>
	     	</tr>
		</table>
		</div>
	<div id="oper_div">
		<% if(isAction==null){%>
		<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
		<span class="gb_btn"><a href="#" onclick="closeButton()"></a></span>
		<%} %>
	</div>
	</div>
	</div>
</form>
</body>

<script type="text/javascript">
var obj = window.dialogArguments;
//alert(obj.name);
var hse_evaluation_id = '<%=hse_evaluation_id%>';
cruConfig.contextPath =  "<%=contextPath%>";
debugger;
refreshData();
//键盘上只有删除键，和左右键好用
function noEdit(event){
	if(event.keyCode==8 || event.keyCode ==37 || event.keyCode ==39){
		return true;
	}else{
		return false;
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
	if(checkText0()){
		return;
	}
}

function closeButton(){
	window.close();
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
        value:"",
        is_employee:"",
    };
    window.showModalDialog('<%=contextPath%>/hse/orgAndResource/staffEvaluation/evaluation_tree.jsp',
    		teamInfo,'dialogWidth=310px;dialogHeight=768px');
    if(teamInfo.fkValue!=null && teamInfo.fkValue !=""){
    	debugger;
    	if(teamInfo.is_employee!=null && teamInfo.is_employee=="false"){
    		cruConfig.pageSize = 1000;
    		var checkSql="select t.employee_name name,sd.coding_name from comm_human_employee t left join comm_human_employee_hr hr on t.employee_id= hr.employee_id and hr.bsflag='0' left join comm_coding_sort_detail sd on hr.post_sort=sd.coding_code_id and sd.bsflag='0' where t.bsflag='0' and t.org_id ='"+teamInfo.fkValue+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&pageSize='+cruConfig.pageSize);
			if(queryRet.returnCode =='0'){
				var datas = queryRet.datas;
				if(datas!=null && datas!=""){
					for(var i =0;i<datas.length;i++){

						var name = datas[i].name;
						var post = datas[i].coding_name;
						
						var autoOrder = document.getElementById("staff").rows.length;
					   	var tr = document.getElementById("staff").rows[autoOrder-3];
					   	tr.cells[0].children[1].value = name;
					   	tr.cells[1].firstChild.value = post;
					   	if(i!=datas.length-1){
						addOne("");
					   	}
					}
				}
			}
    	}else if(teamInfo.is_employee!=null && teamInfo.is_employee=="true"){
    		var employeeId = teamInfo.fkValue;
    		var checkSql = "select sd.coding_name from comm_human_employee_hr hr join comm_coding_sort_detail sd on hr.post_sort=sd.coding_code_id and sd.bsflag='0' where hr.bsflag='0' and hr.employee_id='"+employeeId+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql+'&pageSize='+cruConfig.pageSize);
		   	var datas = queryRet.datas;
		   	if(datas!=null&&datas!=""){
		   		var post = datas[0].coding_name;
		   	}
		   	var autoOrder = document.getElementById("staff").rows.length;
		   	var tr = document.getElementById("staff").rows[autoOrder-3];
		   	tr.cells[0].children[1].value = teamInfo.value;
		   	tr.cells[1].firstChild.value = post;
    		addOne("");
    	}
    }
}


function toUploadFile(){
	var obj=window.showModalDialog('<%=contextPath%>/hse/orgAndResource/staffEvaluation/humanImportFile.jsp',"","dialogHeight:500px;dialogWidth:600px");
	 
	if(obj!="" && obj!=undefined ){		
		var checkStr = obj.split(",");
		for(var i=0;i<checkStr.length-1;i++){ 
			var check = checkStr[i].split("@");   
			 addOnes(check[0],check[1],check[2],check[3],check[4],check[5],check[6],check[7],check[8], check[9], check[10], check[11], check[12]);
		}
		
	}

}

</script>
</html>