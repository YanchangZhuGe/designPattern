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
	Date date = new Date();
	int year = date.getYear()+1900;
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
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
			    <td class="ali_cdn_name">统计年份</td>
			    <td class="ali_cdn_input"><select id="year" name="year" class="select_width">
			    		<option value="" >请选择</option>
			    <% for(int i = year ; i>=2002 ; i--){%>
				       <option value="<%=i %>" ><%=i %></option>
				<% }%>
					</select></td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

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
			      	<td class="bt_info_odd" exp="<input type='checkbox' name='chk_entity_id' value='{duty_id}' />" >选择</td>
			     	<td class="bt_info_even" autoOrder="1">序号</td> 
			      	<td class="bt_info_odd" exp="{second_name}">单位</td>
			      	<td class="bt_info_even" exp="{third_name}">基层单位</td>
			      	<td class="bt_info_odd" exp="{fourth_name}">下属单位</td>
			      	<td class="bt_info_even" exp="{duty_year}">录入年份</td>
			      	<td class="bt_info_odd" exp="{task}">作业性质</td>
			      	<td class="bt_info_even" exp="{duty_module}">板块属性</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">签订情况</a></li>
		    </ul>
		</div>
		<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
				<input type="hidden" id="duty_id" name="duty_id" value=""></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
							<td>&nbsp;</td>
							<td width="30"><span class="bc"><a href="#" onclick="toUpdate()"></a></span></td>
							<td width="5"></td>
		                </tr>
		            </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
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
				      		<td class="inquire_item6"><font color="red">*</font>录入年份：</td>
				      		<td class="inquire_form6"><select id="duty_year" name="duty_year" class="select_width">
				      					<option value="" >请选择</option>
							    <% for(int i = year ; i>=2002 ; i--){%>
								       <option value="<%=i %>" ><%=i %></option>
								<% }%>
									</select></td>
				      		<td class="inquire_item6"><font color="red">*</font>作业性质：</td>
				      		<td class="inquire_form6"><select id="task" name="task" class="select_width">
							       <option value="0" >请选择</option>
							       <option value="1" >野外一线</option>
							       <option value="2" >固定场所</option>
							       <option value="3" >科研单位</option>
							       <option value="4" >培训接待</option>
							       <option value="5" >矿区</option>
								</select>
				      		</td>
				      		<td class="inquire_item6"><font color="red">*</font>板块属性：</td>
				      		<td class="inquire_form6"><select id="duty_module" name="duty_module" class="select_width">
							       <option value="0" >请选择</option>
							       <option value="1" >机关管理</option>
							       <option value="2" >二线</option>
							       <option value="3" >野外一线</option>
								</select>
				      		</td>
				        </tr>
				        <tr>
					     	<td class="inquire_item6"><font color="red">*</font>与直线主管签订责任书数量：</td>
					      	<td class="inquire_form6"><input type="text" id="master_num" name="master_num"   class="input_width" value="" onkeydown="return checkIfNum(event)"/></td>
					    	<td class="inquire_item6"><font color="red">*</font>与关键岗位员工签订责任书数量：</td>
					      	<td class="inquire_form6"><input type="text" id="employee_num" name="employee_num"   class="input_width" value="" onkeydown="retirn checkIfNum(event)"/></td>
					    </tr>
					</table>
				</div>
			</form>
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
		var sql = '';
		var retObj = jcdpCallService("HseSrv", "queryOrg", "");
		if(retObj.returnCode =='0'){
			if(retObj.list!=null){
				var len = retObj.list.length;
				if(len==1){
					sql = "and t.second_org = '" + retObj.list[0].orgSubId +"'";
				}
				if(len==2){
					sql = "and t.third_org = '" + retObj.list[1].orgSubId +"'";
				}
				if(len>2){
					sql = "and t.fourth_org = '" + retObj.list[2].orgSubId +"'";
				}
			}
		}
		
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd =getMultipleSql();
		}else if(isProject=="2"){
			querySqlAdd = "  and t.project_info_no='<%=user.getProjectInfoNo()%>'  ";
		}
		
		var duty_year = document.getElementById("year").value;
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select t.duty_id ,t.second_org ,inf1.org_abbreviation second_name ,t.third_org ,"+
		" inf2.org_abbreviation third_name  ,t.fourth_org ,inf3.org_abbreviation fourth_name ," +
		" t.duty_year ,decode(t.task,'1','野外一线','2','固定场所','3','科研单位','4','培训接待','5','矿区','') task ,"+
		" decode(t.duty_module,'1','机关管理','2','二线','3','野外一线','') duty_module ,t.master_num ,t.employee_num"+
		" from bgp_hse_duty_book t"+
		" left join comm_org_subjection sub1 on t.second_org = sub1.org_subjection_id and sub1.bsflag='0'"+
		" left join comm_org_information inf1 on sub1.org_id = inf1.org_id and inf1.bsflag='0'"+
		" left join comm_org_subjection sub2 on t.third_org = sub2.org_subjection_id and sub2.bsflag='0'" +
		" left join comm_org_information inf2 on sub2.org_id = inf2.org_id and inf2.bsflag='0'"+
		" left join comm_org_subjection sub3 on t.fourth_org = sub3.org_subjection_id and sub3.bsflag='0'"+
		" left join comm_org_information inf3 on sub3.org_id = inf3.org_id and inf3.bsflag='0'"+
		" where t.bsflag ='0' "+sql+querySqlAdd+" and t.duty_year like'"+duty_year+"%'"+
		" order by t.duty_year desc";
		cruConfig.currentPageUrl = "<%=contextPath%>/hse/objAndTarget/hseDutyBook/duty_book_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "<%=contextPath%>/hse/objAndTarget/hseDutyBook/duty_book_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chk_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}
	
	// 简单查询
	function simpleSearch(){
		refreshData();
	}
	
	function clearQueryText(){
		document.getElementById("year").options[0].selected = true;
	}
	var rowIndex = 0;
	function loadDataDetail(shuaId){
  
		var retObj = '';
		if(shuaId!=null){
			retObj = jcdpCallService("HseOperationSrv", "getDutyBookDetail", "duty_id="+shuaId);
		}else{
			var ids = getSelIds('chk_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseOperationSrv", "getDutyBookDetail", "duty_id="+ids);
		}
		if(retObj.returnCode =='0'){
			var map = retObj.dutyMap;
			if(map!=null){
				document.getElementById("duty_id").value =shuaId;
				document.getElementById("second_org").value =map.second_org;
				document.getElementById("third_org").value =map.second_org;
				document.getElementById("fourth_org").value =map.fourth_org;
				document.getElementById("second_org2").value =map.second_name;
				document.getElementById("third_org2").value =map.third_name;
				document.getElementById("fourth_org2").value =map.fourth_name;
				document.getElementById("master_num").value = map.master_num;
				document.getElementById("employee_num").value = map.employee_num;
				
				var duty_year = document.getElementById("duty_year");
				var value = map.duty_year;
				if(duty_year!=null && duty_year.options.length>0){
					for(var i =0; i<duty_year.options.length;i++){
						var option = duty_year.options[i];
						if(value == option.value){
							option.selected = true;
						}
					}
				}
				var task = document.getElementById("task");
				var value = map.task;
				if(task!=null && task.options.length>0){
					for(var i =0; i<task.options.length;i++){
						var option = task.options[i];
						if(value == option.value){
							option.selected = true;
						}
					}
				}
				var duty_module = document.getElementById("duty_module");
				var value = map.duty_module;
				if(duty_module!=null && duty_module.options.length>0){
					for(var i =0; i<duty_module.options.length;i++){
						var option = duty_module.options[i];
						if(value == option.value){
							option.selected = true;
						}
					}
				}
			}
		}
	}
	function toAdd(){
		popWindow("<%=contextPath%>/hse/objAndTarget/hseDutyBook/duty_book_add.jsp");
	}
	
	function toEdit(){  
		var duty_id = document.getElementById("duty_id").value;
	  	if(duty_id==''|| duty_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	popWindow("<%=contextPath%>/hse/objAndTarget/hseDutyBook/duty_book_add.jsp?duty_id="+duty_id);
	  	
	} 
	function dbclickRow(ids){
		popWindow("<%=contextPath%>/hse/objAndTarget/hseDutyBook/duty_book_add.jsp?duty_id="+ids);
	}
	function toUpdate(){  
		var form = document.getElementById("form");
		if(checkText0()){
			return;
		}
		var duty_id = document.getElementById("duty_id").value;	
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var duty_year=document.getElementById("duty_year").value;
		var task=document.getElementById("task").value;
		var duty_module=document.getElementById("duty_module").value;
		var master_num=document.getElementById("master_num").value;
		var employee_num=document.getElementById("employee_num").value;
		var substr = 'second_org='+second_org+'&third_org='+third_org +
		'&fourth_org='+fourth_org+'&duty_year='+duty_year+'&task='+task +
		'&duty_module='+duty_module+'&master_num='+master_num+'&employee_num='+employee_num;
		if(duty_id!=null && duty_id!=''){
			substr = substr +'&duty_id='+duty_id;
		}
		var obj = jcdpCallService("HseOperationSrv", "saveDutyBook", substr);
		if(obj.returnCode =='0'){
			alert("保存成功!");
			refreshData();
		}
		
	} 
	
	
	function checkText0(){
		var second_org2=document.getElementById("second_org2").value;
		var third_org2=document.getElementById("third_org2").value;
		var fourth_org2=document.getElementById("fourth_org2").value;
		var duty_year=document.getElementById("duty_year").value;
		var task=document.getElementById("task").value;
		var duty_module=document.getElementById("duty_module").value;
		var master_num=document.getElementById("master_num").value;
		var employee_num=document.getElementById("employee_num").value;
		/*
		if(second_org2==""){
			document.getElementById("second_org").value = "";
			alert("单位不能为空，请选择！");
			return true;
		}
		if(third_org2==""){
			document.getElementById("third_org").value="";
			alert("基层单位不能为空，请选择！");
			return true;
		}
		if(fourth_org2==""){
			document.getElementById("fourth_org").value="";
			alert("下属单位不能为空，请选择！");
			return true;
		}*/
		if(second_org2==""){
			document.getElementById("second_org").value = "";
		}
		if(third_org2==""){
			document.getElementById("third_org").value="";
		}
		if(fourth_org2==""){
			document.getElementById("fourth_org").value="";
		}
		
		if(duty_year==""){
			alert("录入年份不能为空，请选择！");
			return true;
		}
		if(task==""){
			alert("作业性质不能为空，请选择！");
			return true;
		}
		if(duty_module==""){
			alert("板块属性不能为空，请选择！");
			return true;
		}
		if(master_num==""){
			alert("与直线主管签订责任书数量不能为空，请填写！");
			return true;
		}
		if(employee_num==""){
			alert("与关键岗位员工签订责任书数量不能为空，请填写！");
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
				substr =substr + "update bgp_hse_duty_book t set t.bsflag ='1' where duty_id ='"+id[i]+"';";
			} 
			var retObj = jcdpCallService("HseOperationSrv", "saveEvaluationStaff", "sql="+substr); 
			refreshData();
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/objAndTarget/hseDutyBook/duty_book_search.jsp?isProject=<%=isProject%>");
	}
	
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId=C6000000000001',teamInfo);
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

</html>

