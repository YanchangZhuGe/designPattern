<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String extPath = contextPath + "/js/extjs";
	String orgSubId = user.getCodeAffordOrgID(); 
%>
<html>
 <head> 
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_list_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_search_var.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cute/rt_list_new.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/updateListTable.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cute/kdy_search.js"></script>
  <script type="text/javascript">
  var pageTitle = "用户列表"; cruConfig.contextPath = "<%=contextPath%>";   appConfig.queryListAction = "/ibp/auth2/queryCommUsersByOrg.srq"; 
  var userStatus = new Array( ['0','有效'],['1','禁用'],['2','作废']); 
  var jcdp_codes_items = null; var jcdp_codes = new Array(); 
  function page_init(){  setCruTitle();  cruConfig.cruAction = 'list2Select';  var submitStr = "toSelColumnName=user_id";  submitStr += "&rlTableName=p_auth_user_role_dms";  submitStr += "&rlColumnName=role_id";  submitStr += "&rlColumnValue=<%=request.getParameter("role_id")%>";
				cruConfig.relationParams = submitStr;
				queryRelationedIds(submitStr);
				cdt_init();
				cruConfig.queryStr = "select  r.*  from p_auth_user r, comm_org_subjection n   where r.org_id = n.org_id    and n.bsflag='0' ";
				cruConfig.currentPageUrl = "/ibp/auth2/role/userListSelect.lpmd";
				queryData(1);
			}
			function selectEntities() {
				var addRet = addSelectEntities();
				if (addRet.returnCode != '0') {
					alert(addRet.returnMsg);
					return;
				}
				refreshData();
				newClose();
			}
			var fields = new Array();
			fields[0] = [ 'login_id', '登录Id', 'TEXT', , , , , ];
			fields[1] = [ 'user_name', '用户名', 'TEXT', , , , , ];
			fields[2] = [ 'email', '邮箱', 'TEXT', , , , , ];
			fields[3] = [ 'user_status', '状态', 'TEXT', , , 'SEL_OPs',
					userStatus, ];
			function basicQuery() {
				var qStr = generateBasicQueryStr();
				cruConfig.cdtStr = qStr;
				queryData(1);
			}
			function cmpQuery() {
				var qStr = generateCmpQueryStr();
				cruConfig.cdtStr = qStr;
				queryData(1);
			}
			function classicQuery() {
				var qStr = generateClassicQueryStr();
				cruConfig.cdtStr = qStr;
				queryData(1);
			}
			function onlineEdit(rowParams) {
				var path = cruConfig.contextPath + cruConfig.editAction;
				Object.prototype.toJSONString = JSON.objectToJSONString;
				var params = cruConfig.editTableParams + "&rowParams="
						+ rowParams.toJSONString();
				var retObject = syncRequest('Post', path, params);
				if (retObject == null)
					return false;
				if (retObject.returnCode != 0) {
					alert(retObject.returnMsg);
					return false;
				} else
					return true;
			}
		</script> 
  <!--<script type="text/javascript">
var JSON = {}; 
JSON.objectToJSONString = Object.prototype.toJSONString;
</script>--> 
  <title>选择页面</title> 
 </head> 
 <body class="bgColor_f3f3f3" onload="page_init()"> 
  <div id="searchDiv" class="searchBar_dialog"> 
   <form> 
    <div class="searchList fl"> 
     <table id="ComplexTable" class="table_search" cellpadding="0" cellspacing="0" onkeydown="if(event.keyCode==13){return false;}"> 
      <tbody>
       <tr> 
        <td><select onchange="updateCmpOption(this)" name="cmp_field"> </select></td> 
        <td><select name="cmp_cdt"> </select></td> 
        <td><input type="text" name="cmp_input" /><select name="cmp_sel"></select></td> 
       </tr> 
      </tbody>
     </table> 
    </div> 
    <div class="searchBtn fl"> 
     <input type="button" value="" class="btn btn_search" onclick="cmpQuery()" /> 
     <input type="button" value="" class="btn btn_addSR" onclick="addSearchRow()" /> 
     <input type="button" value="" class="btn btn_delSR" onclick="deleteSearchRow()" /> 
    </div> 
    <div class="clear"></div> 
   </form> 
  </div> 
  <div id="buttonDiv" class="ctrlBtn"> 
   <input id="btn_add" type="button" class="btn btn_add" value=" " style="display:none" /> 
   <input id="btn_edit" type="button" class="btn btn_edit" value=" " onclick="alert(1)" style="display:none" /> 
   <input id="btn_del" type="button" class="btn btn_del" value=" " onclick="" style="display:none" /> 
   <input id="btn_submit" type="button" class="btn btn_submit" value=" " onclick="selectEntities()" style="visibility:visible" /> 
   <input id="btn_back" type="button" class="btn btn_back" value=" " onclick="" style="display:none" /> 
   <input id="btn_close" type="button" class="btn btn_close" value=" " onclick="newClose()" style="visibility:visible" /> 
   <input id="btn_normal" type="button" class="btn btn_normal" value=" " onclick="" style="display:none" /> 
  </div> 
  <div class="pageNumber" id="pageNumDiv"> 
   <a href="#" class="first fl"></a> 
   <a href="#" class="prev fl"></a> 
   <div class="pageNumber_cur fl" id="dataRowHint">
     第 
    <input type="text" size="2" id="changePage" onkeydown="javascript:changePage()" />页 共 5 页 
   </div> 
   <a href="#" class="next fl"></a> 
   <a href="#" class="last fl"></a> 
   <div class="clear"></div> 
  </div> 
  <!--end table_pageNumber--> 
  <div class="tableWrap"> 
   <table id="queryRetTable" class="table_list" cellpadding="0" cellspacing="0"> 
    <tr>
     <th exp="<input type='checkbox' name='chx_entity_id' value='{user_id}'>"><input type="checkbox" id="headChxBox" onclick="head_chx_box_changed(this)" /></th>
     <th exp="{user_name}">用户名</th>
     <th exp="{email}">邮箱</th>
     <th exp="{login_id}">登录Id</th>
     <th exp="{user_status}" func="getOpValue,userStatus">状态</th>
    </tr>
   </table> 
  </div> 
  <!--end table_body-->  
  <script type="text/javascript">
function dataListCttHeight(){
	var tableWrapHeight = $(window).height()-$(".searchBar_dialog").height()-$(".ctrlBtn").height()-$(".pageNumber").height()-10;
	$(".tableWrap").css("height",tableWrapHeight);
};
dataListCttHeight();
function refreshData(){
	var ctt = top.frames[1].frames['list'];
	if(ctt.frames.length == 1){
			ctt.refreshData();
	}else{
			ctt.frames[1].frames[1].refreshData();
	}
}

var $parent = top.$;
function setCruTitle(){
	top.setDialogTitle(window,pageTitle);
}
$(function(){
	addSearchRow = (function(orgFunc){
		return function(){
			var result = orgFunc.apply(this,arguments);
			dataListCttHeight();
			if(result) return result;
		}
		
	})(addSearchRow);
	deleteSearchRow = (function(orgFunc){
		return function(){
			var result = orgFunc.apply(this,arguments);
			dataListCttHeight();
			if(result) return result;
		}
	})(deleteSearchRow);
});	

  </script>  
 </body>
</html>
