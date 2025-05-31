<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgSubjectionId();
	String organ_flag = "";
	String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	if(list.size()>1){
		Map map = (Map)list.get(0);
		organ_flag = (String)map.get("organFlag");
		if(organ_flag.equals("0")){
			org_id = "C105";		
		}else{
			Map map1 = (Map)list.get(1);
			organ_flag = (String)map1.get("organFlag");
			org_id = (String)map1.get("orgSubId");
			if(organ_flag.equals("0")){
				org_id = (String)map.get("orgSubId");
			}
		}
	}
	if(user.getOrgSubjectionId().equals("C105")){
		organ_flag = "0";
	}
	
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
	
/*	
	System.out.println("————————————————————————————————org==="+org_id);
	String fatherId = "";
	String sql = "select os2.father_org_id from comm_org_subjection os1 join comm_org_subjection os2 on os1.code_afford_org_id=os2.org_id where os1.bsflag='0' and os2.bsflag='0' and os1.org_subjection_id = '"+org_id+"'";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		fatherId = (String)map.get("fatherOrgId");
		int length = fatherId.length();
		if(fatherId.equals("C1")){
			org_id = org_id.substring(0,4);
		}else if(fatherId.equals(org_id.substring(0,org_id.length()-6))){
			org_id = org_id.substring(0,org_id.length()-3);
		}
	}
	System.out.println("————————————————————————————————org==="+org_id);
*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
<style type="text/css">
.ali_cdn_input{
	width: 180px;
	text-align: left; 
}

.ali_cdn_input input{
	width: 80%;
}

.myButton {
	BORDER: #deddde 1px solid;
	font-size: 12px;
	background:#2C83C1;
	CURSOR:  hand;
	COLOR: #FFFFFF;
	padding-top: 2px;
	padding-left: 2px;
	padding-right: 2px;
	height:22px;
}

</style>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">开始日期</td>
			    <td class="ali_cdn_input">
			    <input id="startDate" name="startDate" type="text" readonly="readonly"/>
			    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16"  style="cursor:hand;" onmouseover="fridaySelector(startDate,tributton0);"/> &nbsp;
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
				    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
				    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="tj" event="onclick='toSubmit()'" title="提交"></auth:ListButton>
				    <auth:ListButton functionId="F_HSE_WEEK_MUL,F_HSE_WEEK_SINGLE" css="sptg" event="onclick='toPass()'" title="审批通过"></auth:ListButton>
				    <auth:ListButton functionId="F_HSE_WEEK_MUL,F_HSE_WEEK_SINGLE" css="spbtg" event="onclick='toNoPass()'" title="审批不通过"></auth:ListButton>
<!-- 				<%// if(JcdpMVCUtil.hasPermission("F_HSE_WEEK_MUL", request)||JcdpMVCUtil.hasPermission("F_HSE_WEEK_SINGLE", request)){ %>
				    <td align="right" style="width: 40px;"><input type="button" name="button2" value="审批通过"  class="myButton"  onclick="toPass()"/></td>
				    <td align="right" style="width: 40px;padding-left: 5px;"><input type="button" name="button2" value="审批不通过"  class="myButton"  onclick="toNoPass()"/></td>
				    <%// } %>
 -->				    
				<!-- <auth:ListButton functionId="" id="下一步" css="myButton" event="onclick='toAddSelect()'" title="下一步"></auth:ListButton> -->   
				    
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_common_id},{subflag},{org_id}' id='rdo_entity_id_{hse_common_id}'  onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{week_start_date}">开始日期</td>
			      <td class="bt_info_even" exp="{week_end_date}">结束日期</td>
			      <td class="bt_info_odd" exp="{org_name}">单位</td>
			      <td class="bt_info_odd" exp="{subflag}">状态</td>
			      <td class="bt_info_even" exp="{user_name}">填写人</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
		  </div>
</body>

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	var org_id = '<%=org_id%>';
	// 复杂查询
	function refreshData(){
		var isProject = "<%=isProject%>";
		var org_subjection_id = "<%=user.getOrgSubjectionId() %>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql3("s.",org_subjection_id);
		}else if(isProject=="2"){
			querySqlAdd = "and c.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select c.hse_common_id,c.org_id,c.week_start_date,c.week_end_date,c.creator_id,u.user_name,c.modifi_date,decode(c.subflag,'0','未提交','1','审批通过','2','审批未通过','3','已提交') as subflag,i.org_abbreviation as org_name from bgp_hse_common c join comm_org_subjection s on c.org_id = s.org_subjection_id and s.bsflag = '0' join comm_org_information i on s.org_id = i.org_id and i.bsflag='0'  join p_auth_user u on c.creator_id = u.user_id and u.bsflag='0'"
		+" where c.bsflag='0'";
		cruConfig.queryStr = cruConfig.queryStr+querySqlAdd;
//		if(org_id=="C105"){
//			cruConfig.queryStr = cruConfig.queryStr+" and (s.father_org_id = 'C105' or s.org_subjection_id='C105')";
//		}else{
//			cruConfig.queryStr = cruConfig.queryStr+" and s.org_subjection_id = '<%=org_id %>'";
//		}
		cruConfig.queryStr = cruConfig.queryStr+" order by c.week_start_date desc,c.modifi_date desc";
		debugger;
		cruConfig.currentPageUrl = "/hse/weekReport/week_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/weekReport/week_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
		debugger;
			var startDate = document.getElementById("startDate").value;
				if(startDate!=''&&startDate!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "select c.hse_common_id,c.org_id,c.week_start_date,c.week_end_date,c.creator_id,u.user_name,c.modifi_date,decode(c.subflag,'0','未提交','1','审批通过','2','审批未通过','3','已提交') as subflag,i.org_abbreviation as org_name from bgp_hse_common c join comm_org_subjection s on c.org_id = s.org_subjection_id and s.bsflag = '0' join comm_org_information i on s.org_id = i.org_id and i.bsflag='0'  join p_auth_user u on c.creator_id = u.user_id and u.bsflag='0'"
						+" where c.bsflag='0'";
						if(org_id=="C105"){
							cruConfig.queryStr = cruConfig.queryStr+" and (s.father_org_id = 'C105' or s.org_subjection_id='C105')";
						}else{
							cruConfig.queryStr = cruConfig.queryStr+" and s.org_subjection_id = '<%=org_id %>'";
						}
					cruConfig.queryStr = cruConfig.queryStr+" and c.week_start_date=to_date('"+startDate+"','yyyy-MM-dd') order by c.week_start_date desc,c.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/weekReport/week_list.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("startDate").value = "";
	}
	
	
	function renderTable(tbObj,tbCfg){
		//更新导航栏
		renderNaviTable(tbObj,tbCfg);
		//删除上次的查询结果
		var headChxBox = getObj("headChxBox");
		if(headChxBox!=undefined) headChxBox.checked = false;
		for(var i=tbObj.rows.length-1;i>0;i--)
			tbObj.deleteRow(i);

		var titleRow = tbObj.rows(0);

		//设置选中的行号为0 
		tbObj.selectedRow = 0;
		tbObj.selectedValue = '';
		
		//给每一类添加exp属性，在ie9+iframe的情况下，td标签内的exp属性识别不出
		for(var j=0;j<titleRow.cells.length;j++){
			var tCell = titleRow.cells(j);
			tCell.exp = tCell.getAttribute("exp");
			tCell.cellClass = tCell.getAttribute("cellClass");
		}// end
		
		var datas = tbCfg.items;
		if(datas!=null)
		for(var i=0;i<datas.length;i++){
			var data = datas[i];
			var vTr = tbObj.insertRow();
			vTr.orderNum = i+1;
			// 选中行高亮
			vTr.ondblclick = function(){
				//alert(tbObj.selectedRow);
				// 取消之前高亮的行
				if(tbObj.selectedRow>0){
					var oldTr = tbObj.rows[tbObj.selectedRow];
					var cells = oldTr.cells;
					for(var j=0;j<cells.length;j++){
						cells[j].style.background="#96baf6";
						// 设置列样式
						if(tbObj.selectedRow%2==0){
							if(j%2==1) cells[j].style.background = "#FFFFFF";
							else cells[j].style.background = "#f6f6f6";
						}else{
							if(j%2==1) cells[j].style.background = "#ebebeb";
							else cells[j].style.background = "#e3e3e3";
						}
					}
				}
				tbObj.selectedRow=this.orderNum;
				// 设置新行高亮
				var cells = this.cells;
				for(var i=0;i<cells.length;i++){
					cells[i].style.background="#ffc580";
				}
				tbObj.selectedValue = cells[0].childNodes[0].value;
				// 加载Tab数据
				loadDataDetail(cells[0].childNodes[0].value);
			}
			
			if(cruConfig.cruAction=='list2Link'){//列表页面选择坐父页面某元素的外键
				vTr.onclick = function(){
					eval(rowSelFuncName+"(this)");
				}
				vTr.onmouseover = function(){this.className = "trSel";}
				vTr.onmouseout = function(){this.className = this.initClassName;}
			}

			for(var j=0;j<titleRow.cells.length;j++){
				var tCell = titleRow.cells(j);
				var vCell = vTr.insertCell();
				// 设置列样式
				if(i%2==1){
					if(j%2==1) vCell.className = "even_even";
					else vCell.className = "even_odd";
				}else{
					if(j%2==1) vCell.className = "odd_even";
					else vCell.className = "odd_odd";
				}
				// 自动计算序号
				if(tCell.autoOrder=='1' || tCell.getAttribute('autoOrder')=='1'){
					vCell.innerHTML=((tbCfg.currentPage-1) * tbCfg.pageSize + 1 + i);
					continue;
				}
				
				var outputValue = getOutputValue(tCell,data);
				var cellValue = outputValue;
				
				if(tCell.isShow=="Edit"){
					cellValue = "<input type=text onclick=tableInputEditable(this) onkeydown=tableInputkeydown(this) class=rtTableInputReadOnly";
					if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName
					else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2);
					if(tCell.size!=undefined) cellValue += " size="+tCell.size;
					else cellValue += " size=8";
					cellValue += " value='"+outputValue+"'>";
				}
				else if(tCell.isShow=="Hide"){
					cellValue = "<input type=text value="+outputValue;
					if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName+">"
					else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2)+">";
					vCell.style.display = 'none';
				}else if(tCell.isShow=="TextHide"){
					vCell.style.display = 'none';
				}
	//alert(typeof cellValue);alert(cellValue == undefined);
				if(cellValue == undefined || cellValue == 'undefined') cellValue = "";
				if(cellValue=='') {cellValue = "&nbsp;";}
				else if(cellValue.indexOf("undefined")!=-1){
				   cellValue = cellValue.replace("undefined","");
				}

				vCell.innerHTML = cellValue;
			}
		}
		for(var i=datas.length;i<tbCfg.pageSize;i++){
			var vTr = tbObj.insertRow();
			for(var j=0;j<titleRow.cells.length;j++){
				var tCell = titleRow.cells(j);
				var vCell = vTr.insertCell();
				// 设置列样式
				if(i%2==1){
					if(j%2==1) vCell.className = "even_even";
					else vCell.className = "even_odd";
				}else{
					if(j%2==1) vCell.className = "odd_even";
					else vCell.className = "odd_odd";
				}
				vCell.innerHTML = "&nbsp;";
			}
		}
		
		createNewTitleTable();
		resizeNewTitleTable();
}

	
	
	function loadDataDetail(shuaId){
		
		var retObj;
		if(shuaId!=null){
			 var temp = shuaId.split(',');
			 var hse_common_id = temp[0];
			 retObj = jcdpCallService("HseSrv", "viewWeek", "hse_common_id="+hse_common_id);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var temp2 = ids.split(',');
			var hse_common_id = temp2[0];
		    retObj = jcdpCallService("HseSrv", "viewWeek", "hse_common_id="+hse_common_id);
		}
		var week_start_date =retObj.map.weekStartDate;
		var week_end_date =retObj.map.weekEndDate;
		var subflag =retObj.map.subflag;
		var org_id =retObj.map.orgId;
		window.location="<%=contextPath%>/hse/weekReport/weekMenu.jsp?isProject=<%=isProject%>&org_id="+org_id+"&week_date="+week_start_date+"&subflag="+subflag+"&week_end_date="+week_end_date+"&action=edit&organ_flag=<%=organ_flag%>";
	}

	
	function toAdd(){
		window.location='<%=contextPath%>/hse/weekReport/selectWeek.jsp?isProject=<%=isProject%>';
	}
	
	function toSubmit(){
	 		debugger;
		    ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
		    var temp = ids.split(',');
			var hse_common_id = temp[0];
			var subflag = temp[1];
			var org_id = temp[2];
			if(org_id=="<%=org_id%>"){
				if(subflag=="已提交"||subflag=="审批通过"){
				    	alert("该记录"+subflag+"，不能提交!");
				    	return;
				}else{
					var sql = "update bgp_hse_common set subflag='3' where  bsflag='0' and hse_common_id='"+hse_common_id+"'";
					if (!window.confirm("确认要提交吗?")) {
						return;
					}
					var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
					var params = "sql="+sql;
					params += "&ids="+ids;
					var retObject = syncRequest('Post',path,params);
					if(retObject.returnCode!=0) alert(retObject.returnMsg);
					else queryData(cruConfig.currentPage);
				}
			}else{
				alert("只能对本单位记录进行操作!");
		    	return;
			}
		}
	
	function toPass(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
	    var temp = ids.split(',');
		var hse_common_id = temp[0];
		var subflag = temp[1];
		var org_id = temp[2];
		debugger;
		var tempId = "<%=org_id%>";
		if(org_id.length>tempId.length){
		org_id =  org_id.substr(0,tempId.length);
		if(org_id=="<%=org_id%>"){
			if(subflag=="已提交"){
				var sql = "update bgp_hse_common set subflag='1' where  bsflag='0' and hse_common_id='"+hse_common_id+"'";
				if (!window.confirm("确认审批通过吗?")) {
					return;
				}
				var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
				var params = "sql="+sql;
				params += "&ids="+ids;
				var retObject = syncRequest('Post',path,params);
				if(retObject.returnCode!=0) alert(retObject.returnMsg);
				else queryData(cruConfig.currentPage);
			}else{
				alert("该记录"+subflag+"，不能审批!");
		    	return;
			}
		}else{
			alert("只能对本单位记录进行操作!");
	    	return;
		}
		}
	}
	
	function toNoPass(){
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
	    var temp = ids.split(',');
		var hse_common_id = temp[0];
		var subflag = temp[1];
		var org_id = temp[2];
		var tempId = "<%=org_id%>";
		if(org_id.length>tempId.length){
		org_id =  org_id.substr(0,tempId.length);
		if(org_id=="<%=org_id%>"){
			if(subflag=="已提交"){
				var sql = "update bgp_hse_common set subflag='2' where  bsflag='0' and hse_common_id='"+hse_common_id+"'";
				if (!window.confirm("确认审批不通过吗?")) {
					return;
				}
				var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
				var params = "sql="+sql;
				params += "&ids="+ids;
				var retObject = syncRequest('Post',path,params);
				if(retObject.returnCode!=0) alert(retObject.returnMsg);
				else queryData(cruConfig.currentPage);
			}else{
				alert("该记录"+subflag+"，不能审批!");
		    	return;
			}
		}else{
			alert("只能对本单位记录进行操作!");
	    	return;
		}
		}
	}

	function toDelete(){
 		debugger;
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    var temp = ids.split(',');
	    var hse_common_id = temp[0];
	    var subflag = temp[1];
	    var org_id = temp[2];
	    if(org_id=="<%=org_id%>"){	
		    if(subflag=="已提交"||subflag=="审批通过"){
		    	alert("该记录"+subflag+"，不能删除!");
		    	return;
		    }else{
				if(confirm('确定要删除吗?')){  
					var retObj = jcdpCallService("HseSrv", "deleteWeek", "hse_common_id="+hse_common_id);
					queryData(cruConfig.currentPage);
				}
		    }
	    }else{
	    	alert("只能对本单位记录进行操作!");
	    	return;
	    }
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/weekReport/week_search.jsp");
	}
	
	function fridaySelector(inputField,tributton)
	{    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m-%d",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    true,
			singleClick    :    true,
			step        : 1,
			disableFunc: function(date) {
		        if (date.getDay() != 5) {
		            return true;
		        } else {
		            return false;
		        }
		    }
		    });
	}
	
</script>

</html>

