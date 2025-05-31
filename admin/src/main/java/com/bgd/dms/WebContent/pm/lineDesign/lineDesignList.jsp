<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = request.getParameter("orgSubId");
	String projectInfoNo = user.getProjectInfoNo();
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>线束设计信息</title>
</head>
<body style="background:#fff" onload="refreshData('')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">			 
			  <tr>
			    <td class="ali_cdn_name">线束号</td>
			    <td class="ali_cdn_input">
				    <input id="line_group_id" name="line_group_id" type="text" class="input_width"/>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			    <auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{group_design_no}' id='rdo_entity_id_{group_design_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" exp="{line_group_id}">线束号</td>
			      <td class="bt_info_odd" exp="{shot_array_num}">炮排数</td>
			      <td class="bt_info_even" exp="{group_design_shot_num}">单束线设计炮数</td>
			      <td class="bt_info_even" exp="{receiveing_num}">接收线数</td>
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
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
			      <td class="inquire_item6">线束号：</td>
			      <td class="inquire_form6" ><input id="lineGroupId" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">设计加密炮数：</td>
			      <td class="inquire_form6" ><input id="designInfillSpNum" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">接收线起始点号：</td>
			      <td class="inquire_form6" ><input id="receivingLineStartLoc" class="input_width_no_color" type="text" /></td>
			      </tr>
			    <tr>
			      <td class="inquire_item6">接收线终止点号：</td>
			      <td class="inquire_form6" ><input id="receivingLineEndLoc" class="input_width_no_color" type="text" /></td>
			      </td>
			      <td class="inquire_item6">接收线起始线号：</td>
			      <td class="inquire_form6" ><input id="receivingLineStartLine" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">接收线终止线号：</td>
			      <td class="inquire_form6"><input id="receivingLineEndLine" class="input_width_no_color" type="text" /></td>
			     </tr>
			     <tr>
			      <td class="inquire_item6">炮线起始点号：</td>
			      <td class="inquire_form6" ><input id="shotLineStartLoc" class="input_width_no_color" type="text" /></td>
			      </td>
			      <td class="inquire_item6">炮线终止点号：</td>
			      <td class="inquire_form6" ><input id="shotLineEndLoc" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">炮线起始线号：</td>
			      <td class="inquire_form6"><input id="shotLineStartLine" class="input_width_no_color" type="text" /></td>
			     </tr> 
			     <tr>
			      <td class="inquire_item6">炮线终止线号：</td>
			      <td class="inquire_form6" ><input id="shotLineEndLine" class="input_width_no_color" type="text" /></td>
			      </td>
			      <td class="inquire_item6">炮排数：</td>
			      <td class="inquire_form6" ><input id="shotArrayNum" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">单束线设计炮数：</td>
			      <td class="inquire_form6"><input id="groupDesignShotNum" class="input_width_no_color" type="text" /></td>
			     </tr>			     
			     <tr>
			      <td class="inquire_item6">接收线数：</td>
			      <td class="inquire_form6" ><input id="receivingLineNum" class="input_width_no_color" type="text" /></td>
			      </td>
			      <td class="inquire_item6">总检波点数：</td>
			      <td class="inquire_form6" ><input id="geophonePoint" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">炮点面积(km&sup2)：</td>
			      <td class="inquire_form6"><input id="shotArea" class="input_width_no_color" type="text" /></td>
			     </tr>
			     <tr>
			      <td class="inquire_item6">施工面积(km&sup2)：</td>
			      <td class="inquire_form6" ><input id="constructionArea" class="input_width_no_color" type="text" /></td>
			      </td>
			      <td class="inquire_item6">炮密度：</td>
			      <td class="inquire_form6" ><input id="shotDensity" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">设计总炮数：</td>
			      <td class="inquire_form6"><input id="designSpNum" class="input_width_no_color" type="text" /></td>
			     </tr>
			     <tr>
			      <td class="inquire_item6">道距(m)：</td>
			      <td class="inquire_form6" ><input id="traceInterval" class="input_width_no_color" type="text" /></td>
			      </td>
			      <td class="inquire_item6">覆盖次数：</td>
			      <td class="inquire_form6" ><input id="fold" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">设计满覆盖工作量(km&sup2)：</td>
			      <td class="inquire_form6"><input id="actualFullfoldArea" class="input_width_no_color" type="text" /></td>
			     </tr>
			      
			     <tr>
			      <td class="inquire_item6">线束表层设计点数：</td>
			      <td class="inquire_form6" ><input id="designSurface3dSpNum" class="input_width_no_color" type="text" /></td>
			      </td>
			      <td class="inquire_item6">总物理点数：</td>
			      <td class="inquire_form6" ><input id="totalPointNum" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6"></td>
			      <td class="inquire_form6"></td>
			     </tr>
			</table>
			</div>
			</div>
		  </div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
</script> 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";

	cruConfig.queryStr = "";
	cruConfig.cdtType = 'form';
//  cruConfig.queryRetTable_id = "";
	var orgSubId = "<%=orgSubId%>";	
	
	projectInfoNo = "<%=projectInfoNo%>";
	function clearQueryText(){
		document.getElementById("line_group_id").value = "";
		document.getElementById("line_group_id").focus();
	}
	
	// 简单查询
	function simpleRefreshData(){
		var line_group_id = document.getElementById("line_group_id").value;
		var s_filter=" line_group_id like'%"+line_group_id+"%'";
		refreshData(s_filter);
	}
	
	function refreshData(filter){
		var s_filter="";
		if(filter!="" && filter!=undefined){
			s_filter = " and " + filter;
		}
		cruConfig.queryStr = "select * from gp_ops_3dwa_group_design where bsflag='0' and project_info_no ='"+projectInfoNo+"'" + s_filter;
		queryData(1);
	}

	function loadDataDetail(ids){
		//var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		// 加载当前行信息
		var retObj = jcdpCallService("LineGroupDesignSrv", "getLineGroupDesignById", "groupDesignNo="+ids);
		document.getElementById("lineGroupId").value = retObj.lineGroupDesgin.line_group_id;
		document.getElementById("designInfillSpNum").value = retObj.lineGroupDesgin.design_infill_sp_num;
		document.getElementById("receivingLineStartLoc").value = retObj.lineGroupDesgin.receiving_line_start_loc;
		document.getElementById("receivingLineEndLoc").value = retObj.lineGroupDesgin.receiving_line_end_loc;
		document.getElementById("receivingLineStartLine").value = retObj.lineGroupDesgin.receiving_line_start_line;
		document.getElementById("receivingLineEndLine").value = retObj.lineGroupDesgin.receiving_line_end_line;
		document.getElementById("shotLineStartLoc").value = retObj.lineGroupDesgin.shot_line_start_loc;
		document.getElementById("shotLineEndLoc").value = retObj.lineGroupDesgin.shot_line_end_loc;
		document.getElementById("shotLineStartLine").value = retObj.lineGroupDesgin.shot_line_start_line;
		document.getElementById("shotLineEndLine").value = retObj.lineGroupDesgin.shot_line_end_line;
		document.getElementById("shotArrayNum").value = retObj.lineGroupDesgin.shot_array_num;
		document.getElementById("groupDesignShotNum").value = retObj.lineGroupDesgin.group_design_shot_num;
		document.getElementById("receivingLineNum").value = retObj.lineGroupDesgin.receiveing_line_num;
		document.getElementById("geophonePoint").value = retObj.lineGroupDesgin.geophone_point;
		document.getElementById("shotArea").value = retObj.lineGroupDesgin.shot_area;
		document.getElementById("constructionArea").value = retObj.lineGroupDesgin.construction_area;
		document.getElementById("shotDensity").value = retObj.lineGroupDesgin.shot_density;
		document.getElementById("designSpNum").value = retObj.lineGroupDesgin.design_sp_num;
		document.getElementById("fold").value = retObj.lineGroupDesgin.fold;
		document.getElementById("actualFullfoldArea").value = retObj.lineGroupDesgin.actual_fullfold_area;
		document.getElementById("designSurface3dSpNum").value = retObj.lineGroupDesgin.design_surface_3d_sp_num;
		document.getElementById("totalPointNum").value = retObj.lineGroupDesgin.total_point_num;
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		//popWindow('<%=contextPath%>/pm/lineDesign/lineDesignSearch.jsp');
	}
	
	function toEdit() {	    
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/pm/lineDesign/modifyLineDesign.jsp?groupDesignNo='+ids);
	}
	
	function toSelectP(){

	}
	
	function toAdd(){
		popWindow('<%=contextPath%>/pm/lineDesign/addLineDesign.jsp');
	}
	
	function toDelete(){ 		
	  ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("LineGroupDesignSrv", "deleteLineGroupDesign", "groupDesingNo="+ids);
			queryData(cruConfig.currentPage);
		}
		if(retObj.actionStatus=='ok'){
			alert("删除操作成功!");
		}
	}
	
	$(document).ready(lashen);
</script>
</html>