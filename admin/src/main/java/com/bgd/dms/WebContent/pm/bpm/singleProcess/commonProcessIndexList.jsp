<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String businessType=resultMsg.getValue("businessType");
	String queryBuilder=resultMsg.getValue("queryBuilder");
	String queryBuilderMean=resultMsg.getValue("queryBuilderMean");
	String listBuilder=resultMsg.getValue("listBuilder");
	String listBuilderMean=resultMsg.getValue("listBuilderMean");


	String[] queryBuilders=queryBuilder==null?new String[0]:queryBuilder.split(",");
	String[] queryBuilderMeans=queryBuilderMean==null?new String[0]:queryBuilderMean.split(",");
	String[] listBuilders=listBuilder==null?new String[0]:listBuilder.split(",");
	String[] listBuilderMeans=listBuilderMean==null?new String[0]:listBuilderMean.split(",");
%>
<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" />
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script>
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
 	  var pageTitle = "";
 	  cruConfig.contextPath = "<%=contextPath%>";
	  var jcdp_codes_items = null;
	  var jcdp_codes = new Array();
	  function page_init() {
	    var titleObj = getObj("cruTitle");
	    if (titleObj != undefined) titleObj.innerHTML = pageTitle;
	    cruConfig.queryService = 'WFCommonSrv';
	    cruConfig.queryOp = 'getWFProcessList';
	    cdt_init();
	    cruConfig.queryStr = "";
	    cruConfig.currentPageUrl = "/bpm/common/toGetProcessList.srq";
	    <%
	    if(businessType!=null&&!"".equals(businessType)){
	    %>
	    	cruConfig.submitStr="businessType="+<%=businessType%>+"";
	    <%
	    }
	    %>
	    queryData(1);
	  }
  	  var fields = new Array();
      <%for(int i=0;i<queryBuilders.length;i++) {
		 String query=queryBuilders[i];
		 String queryMean=queryBuilderMeans[i];
	  %>
	     fields[<%=i%>] = ['<%=query%>', '<%=queryMean%>', 'TEXT'];
	  <%} %>
	  function basicQuery() {
	    var qStr = generateBasicQueryStr();
	    cruConfig.cdtStr = qStr;
	    queryData(1);
	  }
	  function cmpQuery() {
	    var qStr = generateCmpQueryStr();
	    cruConfig.cdtStr = qStr;
	    <%for(int i=0;i<queryBuilders.length;i++) {
			String query=queryBuilders[i];
			out.println("var "+query+"=document.getElementById('"+query+"').value;");
			out.println("	if("+query+"!=''){");
			out.println("	cruConfig.submitStr +='&"+query+"='+"+query+";");
			out.println("	}");
		%>
		<%}%>

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
	    var params = cruConfig.editTableParams + "&rowParams=" + rowParams.toJSONString();
	    var retObject = syncRequest('Post', path, params);
	    if (retObject == null) return false;
	    if (retObject.returnCode != 0) {
	      alert(retObject.returnMsg);
	      return false;
	    } else return true;
	  }

	  function JcdpButton0OnClick(){
			var ids = getSelIds('chx_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     return;
		    }
			var tempa = ids.split(',');
			var businessId=tempa[0];
			var entityId=tempa[1];
			var procinstId=tempa[2];
			var taskinstId=tempa[3];
			var businessType=tempa[4];

			var nodeLink=tempa[5];
			var nodeLinkType=tempa[6];

			if(nodeLinkType!='1'){
				var editUrl = "/bpm/common/toGetProcessInfo.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType="+<%=businessType%>;
				window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
			}else{
				nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId+"&businessType="+<%=businessType%>;
				window.location=cruConfig.contextPath+nodeLink+"&backUrl="+cruConfig.currentPageUrl;
			}
		}

	  function JcdpButton1OnClick(){
		  var ids = getSelIds('chx_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     return;
		    }
			var tempa = ids.split(',');
			var businessId=tempa[0];
			var entityId=tempa[1];
			var procinstId=tempa[2];
			var taskinstId=tempa[3];
			var businessType=tempa[4];

			var nodeLink=tempa[5];
			var nodeLinkType=tempa[6];
			var editUrl="/ibp/bpm/viewProcinst.jsp?procinstId="+procinstId;
			window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
	  }
	  </script>
  <title>列表页面</title>
 </head>
 <body class="bgColor" onload="page_init()">

 <%if(queryBuilders.length>0) {%>
  <div id="searchDiv" class="searchBar wrap">
   <div class="tt">
    <h2>查找</h2>
   </div>
   <div class="ctt">
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
  </div>
  <%} %>
  <div class="dataList wrap">
   <div class="tt">
    <h2 id="cruTitle">数据列表</h2>
   </div>
   <div class="ctt">
    <div id="buttonDiv" class="ctrlBtn">
     <input id="btn_normal" type="button" class="btn btn_normal"  value="审核" onclick="JcdpButton0OnClick()" style="" />
     <input id="btn_normal" type="button" class="btn btn_normal"  value="流程轨迹" onclick="JcdpButton1OnClick()" style="" />
    </div>
    <div class="pageNumber" id="pageNumDiv">
     <a href="#" class="first fl"></a>
     <a href="#" class="prev fl"></a>
     <div class="pageNumber_cur fl" id="dataRowHint">
       第
      <input id="changePage" type="text" size="2" onkeydown="javascript:changePage()" /> 页 共 5 页
     </div>
     <a href="#" class="next fl"></a>
     <a href="#" class="last fl"></a>
     <div class="clear"></div>
    </div>
    <!--end table_pageNumber-->
    <!--Remark 查询结果显示区域-->
    <div class="tableWrap">
     <table id="queryRetTable" class="table_list" cellpadding="0" cellspacing="0">
      <tr>
       <th exp="<input type='radio' name='chx_entity_id' value='{businessId},{entityId},{procinstId},{taskinstId},{businessType},{nodeLink},{nodeLinkType}'>">选择</th>
       <th exp="{currentNode}">当前审批环节</th>
       <th exp="{currentProcName}">流程名称</th>
       <th exp="{currentcreateDate}">流程创建时间</th>
       <%for(int i=0;i<listBuilders.length;i++) {%>
       <th exp="{<%=listBuilders[i] %>}"><%= listBuilderMeans[i]%></th>
   		<%} %>
      </tr>
     </table>
    </div>
    <!--end table_body-->
   </div>
   <!--end ctt-->
  </div>
  <!--end dataList-->
  <script type="text/javascript">
	function popWindow(url,size){
		var path = cruConfig.currentPageUrl;
		if(path.indexOf("/epcomp") == 0){   //如果是组件包里的pmd文件
			path = path.substr("/epcomp".length);
		}
		if(url.indexOf('/') == 0){
			if(url.indexOf(cruConfig.contextPath) != 0){
				url = cruConfig.contextPath + url;
			}
		}
		else {
				path = path.substr(0,path.lastIndexOf("/")+1);
				if(path.lastIndexOf("/") == (path.length - 1)){
						url = cruConfig.contextPath + path + url;
				}
				else url = cruConfig.contextPath + path + '/' + url;
		}
		var height = 680;
		var width = 740;
		if(size != null){
			if(typeof size=='number'){
				height=size;
				}
			if(typeof size=='string'&&size.indexOf(':')>0){
				height = eval(size.split(':')[1]);
			  width = eval(size.split(':')[0]);
		  }
		}
		dialogOpen("",width,height,url);
	}

  </script>
 </body>
</html>
