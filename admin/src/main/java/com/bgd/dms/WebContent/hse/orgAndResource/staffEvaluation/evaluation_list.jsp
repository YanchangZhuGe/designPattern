<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
	if(project_info_no == null){
		project_info_no = "";
	}
	String org_subjection_id = user.getOrgSubjectionId();
	if(org_subjection_id == null){
		org_subjection_id = "";
	}
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String now = df.format(new Date());
	
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData();">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			   <!--  <td class="ali_cdn_name">事故名称</td>
			    <td class="ali_cdn_input"><input id="accidentName" name="accidentName" type="text" /></td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td> -->

			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  </tr>
			</table>
			</td>
			  </tr>
			</table>
		</div>
		<div id="table_box">
	    	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr >
			      	<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{hse_evaluation_id}' id='chk_entity_id_{hse_evaluation_id}' />" >选择</td>
			     	<td class="bt_info_even" autoOrder="1">序号</td> 
			      	<td class="bt_info_odd" exp="{second_name}">单位</td>
			      	<td class="bt_info_even" exp="{third_name}">基层单位</td>
			      	<td class="bt_info_odd" exp="{fourth_name}">下属单位</td>
			      	<td class="bt_info_even" exp="{evaluation_type}">评价类别</td>
			      	<td class="bt_info_odd" exp="{appraiser}">评价人</td>
			      	<td class="bt_info_even" exp="{evaluation_date}">评价日期</td>
			    </tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				<tr>
				    <td align="right">第1/1页，共0条记录</td>
				    <td width="10">&nbsp;</td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				    <td width="50">到 
				      <label>
				        <input type="text" name="textfield" id="textfield" style="width:20px;" />
				      </label></td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			    </tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">不胜任情况的处置</a></li>
		    </ul>
		</div>
		<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
				<input type="hidden" id="hse_evaluation_id" name="hse_evaluation_id" value=""></input>
				<input type="hidden" id="isProject" name="isProject" value="<%=isProject%>"></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
							<td>&nbsp;</td>
							<td width="30"><span class="bc"><a href="#" onclick="toUpdate()" title="保存"></a></span></td>
							<td width="5"></td>
		                </tr>
		            </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
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
				      		<td class="inquire_form6"><input type="text" id="evaluation_date" name="evaluation_date" class="input_width"   value="" readonly="readonly"/>
				      		&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(evaluation_date,tributton1);" />&nbsp;</td>
				        </tr>
					</table>
				</div>
			</form>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;overflow: hidden;">
				<iframe id="competent_deal" name="competent_deal" src="" width="100%" frameborder="0" ></iframe>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
function frameSize(){
	setTabBoxHeight();
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);


cruConfig.contextPath =  "<%=contextPath%>";
var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
var showTabBox = document.getElementById("tab_box_content0");
//键盘上只有删除键，和左右键好用
	function noEdit(event){
		if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
			return true;
		}else{
			return false;
		}
		
	}
	
	// 复杂查询
	function refreshData(){
		var project_info_no = '<%=project_info_no%>';
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql();
		}else if(isProject=="2"){
			querySqlAdd = "and t.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select t.hse_evaluation_id ,t.second_org ,inf1.org_abbreviation second_name ,t.third_org ,"+
		" inf2.org_abbreviation third_name ,t.fourth_org ,inf3.org_abbreviation fourth_name ," +
		" decode(t.evaluation_type ,'1','岗前','2','岗中','') evaluation_type ,t.appraiser , "+
		" to_char(t.evaluation_date,'yyyy-MM-dd')evaluation_date ,months_between(sysdate ,t.evaluation_date) mon"+
		" from bgp_hse_evaluation t"+
		" left join comm_org_subjection sub1 on t.second_org = sub1.org_subjection_id and sub1.bsflag='0'"+
		" left join comm_org_information inf1 on sub1.org_id = inf1.org_id and inf1.bsflag='0'"+
		" left join comm_org_subjection sub2 on t.third_org = sub2.org_subjection_id and sub2.bsflag='0'" +
		" left join comm_org_information inf2 on sub2.org_id = inf2.org_id and inf2.bsflag='0'"+
		" left join comm_org_subjection sub3 on t.fourth_org = sub3.org_subjection_id and sub3.bsflag='0'"+
		" left join comm_org_information inf3 on sub3.org_id = inf3.org_id and inf3.bsflag='0'"+
		<%-- " where t.bsflag ='0' and t.second_org like'<%=org_subjection_id%>%' order by t.evaluation_date desc"; --%>
		" where t.bsflag ='0' "+querySqlAdd+" order by t.evaluation_date desc";
		cruConfig.currentPageUrl = "<%=contextPath%>/hse/orgAndResource/staffEvaluation/evaluation_list.jsp";
		queryData(1);
		var obj = document.getElementById("queryRetTable");
		for(var i = 1;i<obj.rows.length;i++){
			var tr = obj.rows[i];
			tr.ondblclick = function(){
				var hse_evaluation_id ='';
				var obj = event.srcElement;
				if(obj.tagName.toLowerCase() == 'td'){
					hse_evaluation_id = obj.parentNode.cells[0].firstChild.value;
				}else if(obj.tagName.toLowerCase() == 'input'){
					hse_evaluation_id = obj.parentNode.parentNode.cells[0].firstChild.value;
				}
				var object = new Object();
				window.showModalDialog('<%=contextPath%>/hse/orgAndResource/staffEvaluation/editEvaluationStaff.jsp?isAction=edit&isProject=<%=isProject%>&hse_evaluation_id='+hse_evaluation_id,
						object,'dialogWidth=1280px;dialogHeight=768px');
				refreshData();
			}
		} 
		warning();
	}
	
	
	function warning(){
		var obj = document.getElementById("queryRetTable");
		var row = 10;
		if(cruConfig.totalRows <10){
			row = cruConfig.totalRows;
		}
		for(var i =1 ; i<= row ;i++){
			var tr = obj.rows[i];
			if(warningOrNot(i)){
				for(var j =0 ;j<tr.cells.length ;j++){
					tr.cells[j].style.background = "yellow";
				}
			}
		}
	}
	function warningOrNot(i){
		var obj = document.getElementById("queryRetTable");
		var tr = obj.rows[i];
		var date = tr.cells[7].innerHTML;
		var sd=date.split("-");
		date = new Date(sd[0],sd[1],sd[2]);
		var now = '<%=now%>';
		sd=now.split("-");
		now = new Date(sd[0],sd[1],sd[2]);
		if((now - date)/1000/3600/24 >=365){
			
			return true;
		}
		return false;
	}
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "<%=contextPath%>/hse/orgAndResource/staffEvaluation/evaluation_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chk_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}
	
	
	function clearQueryText(){
		document.getElementById("accidentName").value = "";
	}
	var rowIndex = 0;
	
	
	function loadDataDetail(shuaId){
		var temp = 0;
		var obj = event.srcElement;
		if(rowIndex!=0 && warningOrNot(rowIndex) && rowIndex !=temp){
			var obj = document.getElementById("queryRetTable");
			var tr = obj.rows[rowIndex];
			for(var j =0 ;j<tr.cells.length ;j++){
				tr.cells[j].style.background = "yellow";
			}
		}
		rowIndex = temp;
		
		var retObj = '';
		if(shuaId!=null){
			 retObj = jcdpCallService("HseOperationSrv", "getEvaluationDetail", "hse_evaluation_id="+shuaId);
		}else{
			var ids = getSelIds('chk_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseOperationSrv", "getEvaluationDetail", "hse_evaluation_id="+ids);
		}
		document.getElementById("competent_deal").src ='<%=contextPath%>/hse/orgAndResource/staffEvaluation/competent_deal.jsp?hse_evaluation_id='+shuaId;
		if(retObj.returnCode =='0'){
			var map = retObj.evaluationMap;
			if(map!=null){
				document.getElementById("hse_evaluation_id").value =shuaId;
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
	function toAdd(){
		popWindow("<%=contextPath%>/hse/orgAndResource/staffEvaluation/addEvaluation.jsp?isProject=<%=isProject%>");
		
	}
	
	function toEdit(){  
		var hse_evaluation_id = document.getElementById("hse_evaluation_id").value;
	  	if(hse_evaluation_id==null||hse_evaluation_id==''){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	popWindow("<%=contextPath%>/hse/orgAndResource/staffEvaluation/addEvaluation.jsp?isProject=<%=isProject%>&hse_evaluation_id="+hse_evaluation_id);
	  	
	} 
	
	function toUpdate(){  
		var form = document.getElementById("form");
		form.action="<%=contextPath%>/hse/accident/updateNewsInfo.srq";
		if(checkText0()){
			return;
		}
		var hse_evaluation_id = document.getElementById("hse_evaluation_id").value;	
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var evaluation_type = document.getElementById("evaluation_type").value;
		var evaluation_date = document.getElementById("evaluation_date").value;
		var substr = 'hse_evaluation_id='+hse_evaluation_id+'&second_org='+second_org+'&third_org='+third_org+
			'&fourth_org='+fourth_org+'&evaluation_type='+evaluation_type+'&evaluation_date='+evaluation_date+'&isProject=<%=isProject%>';
		var obj = jcdpCallService("HseOperationSrv", "saveEvaluation", substr);
		if(obj.returnCode =='0'){
			alert("保存成功!");
			refreshData();
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

	function toDelete(){
 		var substr ="";
	    ids = getSelIds('chk_entity_id');
	    if(ids==''){ 
	    	alert("请先选中一条记录!");
	     	return;
	    }	
	    if(window.confirm('确定要删除吗?')){
	    	var id = ids.split(",");
			for(var i =0 ;i<id.length ;i++){
				substr =substr + "update bgp_hse_evaluation t set t.bsflag ='1' where t.hse_evaluation_id ='"+id[i]+"';";
			} 
			var retObj = jcdpCallService("HseOperationSrv", "saveEvaluationStaff", "sql="+substr); 
			refreshData();
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/orgAndResource/staffEvaluation/evaluation_search.jsp?isProject=<%=isProject%>");
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

