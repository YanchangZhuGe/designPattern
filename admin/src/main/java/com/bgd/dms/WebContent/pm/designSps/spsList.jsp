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
<title>设计SPS信息</title>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{sps_file_no}' id='rdo_entity_id_{sps_file_no}' onclick=doCheck(this)/>" >选择</td>
			      <td class="bt_info_even" exp="{line_group_id}">线束号</td>
			      <td class="bt_info_odd" exp="{creator}">创建人</td>
			      <td class="bt_info_even" exp="{create_date}">创建时间</td>
			      <!-- <td class="bt_info_odd" exp="{locked_if}">审核状态</td> -->
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
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
			   <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">附件</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content"  style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			     <tr>
			      <td class="inquire_item6">R文件：</td>
			      <td class="inquire_form6" id="td_file_r"></td>
			      <td class="inquire_item6"></td>
			      <td class="inquire_form6"></td>
			      <td class="inquire_item6"></td>
			      <td class="inquire_form6"></td>
			     </tr>
			     <tr>
			      <td class="inquire_item6">S文件：</td>
			      <td class="inquire_form6" id="td_file_s"></td>
			      <td class="inquire_item6"></td>
			      <td class="inquire_form6"></td>
			      <td class="inquire_item6"></td>
			      <td class="inquire_form6"></td>
			     </tr>
			     <tr>
			      <td class="inquire_item6">X文件：</td>
			      <td class="inquire_form6" id="td_file_x"></td>
			      <td class="inquire_item6"></td>
			      <td class="inquire_form6"></td>
			      <td class="inquire_item6"></td>
			      <td class="inquire_form6"></td>
			     </tr>
			     <tr>
			      <td class="inquire_item6">其他文件：</td>
			      <td class="inquire_form6" id="td_file_other"></td>
			      <td class="inquire_item6"></td>
			      <td class="inquire_form6"></td>
			      <td class="inquire_item6"></td>
			      <td class="inquire_form6"></td>
			     </tr>
				</table>
			</div>
		</div>
</body>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";

	cruConfig.queryStr = "";
	cruConfig.cdtType = 'form';
//  cruConfig.queryRetTable_id = "";
	var orgSubId = "<%=orgSubId%>";	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
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
		cruConfig.queryStr = "select sps_file_no,line_group_id,creator,to_char(create_date,'yyyy-MM-dd') as create_date,'待审核' as locked_if from gp_ops_sps_data where bsflag='0' and project_info_no ='"+projectInfoNo+"'" + s_filter;
		queryData(1);
	}
	
	function toEdit() {	    
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/pm/designSps/modifySps.jsp?spsfileNo='+ids);
	}
	function toAdd(){
		popWindow('<%=contextPath%>/pm/designSps/addSps.jsp');
	}
	
	function toDelete(){ 		
	 	ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
		
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("DesignSpsSrv", "deleteDesignSps", "spsfileNos="+ids);
			queryData(cruConfig.currentPage);
		}
		if(retObj.actionStatus=='ok'){
			alert("删除操作成功!");
		}
	}
	
	function loadDataDetail(ids){
		//var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
	    
	    var retObj = jcdpCallService("DesignSpsSrv", "getDesignSpsById", "spsfileNo="+ids);
		if(retObj.project != null){
			document.getElementById("tab_box_content0").style.display="block";
			var rsize = retObj.project.rsize;
			var ssize = retObj.project.ssize;
			var xsize = retObj.project.xsize;
			var osize = retObj.project.osize;
			if(rsize>0){
				document.getElementById("td_file_r").innerHTML = '&nbsp;<a href="#" onclick="toDownloadAnnex(\''+ids+'\',\'r_data\')">下载</a>';
			}
			if(ssize>0){
				document.getElementById("td_file_s").innerHTML = '&nbsp;<a href="#" onclick="toDownloadAnnex(\''+ids+'\',\'s_data\')">下载</a>';
			}
			if(xsize>0){
				document.getElementById("td_file_x").innerHTML = '&nbsp;<a href="#" onclick="toDownloadAnnex(\''+ids+'\',\'x_data\')">下载</a>';
			}
			if(osize>0){
				document.getElementById("td_file_other").innerHTML = '&nbsp;<a href="#" onclick="toDownloadAnnex(\''+ids+'\',\'other_file\')">下载</a>';
			}
		}
	}
	
	function toDownloadAnnex(spsfileno, colname){
		if(spsfileno != "" && colname != ""){
			window.location.href="<%=contextPath%>/pm/spsdocDownload.srq?spsfileNo="+spsfileno+"&colName="+colname;
		}
	}
	
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
	$(document).ready(lashen);
</script>
</html>