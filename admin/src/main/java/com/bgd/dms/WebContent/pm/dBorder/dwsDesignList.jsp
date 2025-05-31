<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
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
<title>工区设计边框</title> 
</head>
<body style="background:#fff" onload="refreshData('')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">			 
			  <tr>
			    <td class="ali_cdn_name">边框类型</td>
			    <td class="ali_cdn_input">
				    <select id="borderStyle" name="borderStyle" class="select_width">
   						<option value="1">边框设计数据</option>
   						<option value="2">边框成果数据</option>
   					</select>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{wa3d_design_no}' id='rdo_entity_id_{wa3d_design_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" exp="{frame_shape}">边框类型</td>
			      <td class="bt_info_odd" exp="{data_type}">数据类型</td>
			      <td class="bt_info_even" exp="{border_break_point}">边界拐点</td>
			      <td class="bt_info_even" exp="{point_x}">X坐标</td>
			      <td class="bt_info_even" exp="{point_y}">Y坐标</td>
			      <td class="bt_info_even" exp="{altitude}">海拔</td>
			      <td class="bt_info_even" exp="{locked_if}">状态</td>
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
			    <li class="selectTag" id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
			      <td class="inquire_item6">边框类型：</td>
			      <td class="inquire_form6" ><input id="frameShape" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">数据类型：</td>
			      <td class="inquire_form6" ><input id="dataType" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">边界拐点：</td>
			      <td class="inquire_form6" ><input id="borderBreakPoint" class="input_width_no_color" type="text" /></td>
			      </tr>
			    <tr>
			      <td class="inquire_item6">海拔：</td>
			      <td class="inquire_form6" ><input id="altitude" class="input_width_no_color" type="text" /></td>
			      </td>
			      <td class="inquire_item6">X坐标：</td>
			      <td class="inquire_form6" ><input id="pointX" class="input_width_no_color" type="text" /></td>
			      <td class="inquire_item6">Y坐标：</td>
			      <td class="inquire_form6"><input id="pointY" class="input_width_no_color" type="text" /></td>
			     </tr>
				</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: auto;"></iframe>
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
		document.getElementById("borderStyle").value = "";
		document.getElementById("borderStyle").focus();
	}
	
	// 简单查询
	function simpleRefreshData(){
		var borderStyle = document.getElementById("borderStyle").value;
		var s_filter=" frame_shape ='"+borderStyle+"'";
		refreshData(s_filter);
	}
	
	function refreshData(filter){
		var s_filter="";
		if(filter!="" && filter!=undefined){
			s_filter = " and " + filter;
		}
		cruConfig.queryStr = "select wa3d_design_no,case frame_shape when '1' then '边框设计数据' when '2' then '边框成果数据' else '' end as frame_shape, case data_type when '1' then '炮点' when '2' then '检波点' when '3' then '满覆盖' when '4' then '一次覆盖' when '5' then '施工面积' else '' end as data_type,border_break_point,altitude,point_x,point_y from gp_ops_3dws_design where bsflag='0' and project_info_no ='"+projectInfoNo+"'" + s_filter;
		queryData(1);
	}

	function loadDataDetail(ids){
		//var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		// 加载当前行信息
		var retObj = jcdpCallService("BorderDesignSrv", "getDwsDesignById", "wa3dDesignNo="+ids);
		document.getElementById("frameShape").value = retObj.dBorder.frame_shape_text;
		document.getElementById("dataType").value = retObj.dBorder.data_type_text;
		document.getElementById("borderBreakPoint").value = retObj.dBorder.border_break_point;
		document.getElementById("altitude").value = retObj.dBorder.altitude;
		document.getElementById("pointX").value = retObj.dBorder.point_x;
		document.getElementById("pointY").value = retObj.dBorder.point_y;
		
		// 备注
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		//popWindow('<%=contextPath%>/pm/dBorder/dwsDesignSearch.jsp');
	}
	
	function toEdit() {	    
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/pm/dBorder/modifyDwsDesign.jsp?wa3dDesignNo='+ids);
	}
	
	function toSave(){
		//
	}
	function toSelectP(){

	}
	
	function toAdd(){
		popWindow('<%=contextPath%>/pm/dBorder/adddwsDesign.jsp');
	}
	
	function toDelete(){ 		
	  ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("BorderDesignSrv", "deleteDwsDesign", "wa3dDesignNo="+ids);
			queryData(cruConfig.currentPage);
		}
		if(retObj.actionStatus=='ok'){
			alert("删除操作成功!");
		}
	}
	
	$(document).ready(lashen);
</script>
</html>