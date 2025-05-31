<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/ext-min";
	UserToken user = OMSMVCUtil.getUserToken(request);
    String action = request.getParameter("action")==null?"":request.getParameter("action");
    String codingCodeId = request.getParameter("codingCodeId")==null?"":request.getParameter("codingCodeId");
    String codingLever = request.getParameter("codingLever")==null?"":request.getParameter("codingLever");
    String codingSortId = request.getParameter("codingSortId")==null?"":request.getParameter("codingSortId");
    String signle = request.getParameter("signle")==null?"":request.getParameter("signle");
    String projectInfoNo =request.getParameter("projectInfoNo")==null?"":request.getParameter("projectInfoNo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<link rel="stylesheet" type="text/css" href="<%=extPath%>/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=extPath%>/ext-all.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script language="javaScript">
cruConfig.contextPath =  "<%=contextPath%>";
var codingSortId="<%=codingSortId%>";
var codingCodeId="<%=codingCodeId%>"
var codingLever="<%=codingLever%>"	
var action="<%=action%>";
var signle="<%=signle%>"
function save(){
	var params = $("#myForm").serialize();
	var obj = jcdpCallService("HumanCommInfoSrv","saveHumanCodingSortDetail",params);
	//top.frames('list').refreshTree();
	parent.list.frames[1].location.reload();
	newClose();
}

function page_init(){
	document.getElementById("coding_sort_id").value=codingSortId;
	if("edit"==action){//修改
		var querySql = "select t.* from comm_human_coding_sort_detail t where t.coding_code_id='"+codingCodeId+"' and t.project_info_no='<%=projectInfoNo%>'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(null!=datas&&datas.length>0){
			document.getElementById("detail_id").value=datas[0].detail_id;
			document.getElementById("coding_name").value=datas[0].coding_name;
			document.getElementById("superior_code_id").value=datas[0].superior_code_id;
			document.getElementById("coding_code_id").value=datas[0].coding_code_id;
			document.getElementById("coding_lever").value=datas[0].coding_lever;
		}
	}else{//新增
		var querySql = "select decode(max(coding_code_id),'','100000000100000000',max(coding_code_id)+1) as coding_code_id from comm_human_coding_sort_detail";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(null!=datas&&datas.length>0){
			document.getElementById("superior_code_id").value=codingCodeId;
			document.getElementById("coding_code_id").value=datas[0].coding_code_id;
			document.getElementById("coding_lever").value=Number(codingLever)+1;
		}
	}
}
</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();">
    <div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:100%">
    <form name="myForm" id="myForm"  method="post" action="">
	 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	 	 <tr>
	 	       <td class="inquire_item4">编码：</td>
	           <td class="inquire_form4"><input name="coding_code_id" id="coding_code_id" class="input_width" value="" type="text" readonly="readonly"/></td>
	           <td class="inquire_item4">名称：</td>
	           <td class="inquire_form4">
		       		<input name="coding_name" id="coding_name" class="input_width" value="" type="text" />   
		       		<input name="detail_id" id="detail_id" class="input_width" value="" type="hidden" />            
		            <input name="superior_code_id" id="superior_code_id" class="input_width" value="" type="hidden" />
	             	<input name="coding_sort_id" id="coding_sort_id" class="input_width" value="" type="hidden" /> 
	             	<input name="coding_lever" id="coding_lever" class="input_width" value="" type="hidden" /> 
	             	<input name="project_info_no" id="project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" />   
	           </td>
		  </tr>
	 	</table>
	 </form>
	</div>  
    <div id="oper_div">
    	<span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
</html>
