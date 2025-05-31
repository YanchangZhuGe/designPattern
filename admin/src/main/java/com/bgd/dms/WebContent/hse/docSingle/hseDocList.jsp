<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectInfoNo = user.getProjectInfoNo();
	String projectType = user.getProjectType();
	String fileAbbr = request.getParameter("fileAbbr");
	if(fileAbbr==null || "".equals(fileAbbr)){
		fileAbbr = resultMsg.getValue("fileAbbr");
	}
	String parent_file_id = "";
	String sql = "select * from bgp_doc_gms_file f where f.bsflag='0' and is_file='0' and f.project_info_no='"+projectInfoNo+"' and f.file_abbr='"+fileAbbr+"'";
	Map map  = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		parent_file_id = (String)map.get("fileId");
	}
	
	String readonly = request.getParameter("readonly");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">文档名称</td>
			    <td class="ali_cdn_input"><input id="fileName" name="fileName" type="text" /></td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <%if(readonly==null||!readonly.equals("1")){ %>
			  	<auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>	  		
  				<auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> 
  				<%} %>
			  	<auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  	<%if(readonly==null||!readonly.equals("1")){ %>
			  	<auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  	<%} %>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}' id='rdo_entity_id_{file_id}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>{file_name}</a>">文档名称</td>
			      <td class="bt_info_even" exp="{user_name}" isExport='Hide' >创建人</td>
			      <td class="bt_info_odd" exp="{create_date}" isExport='Hide' >创建时间</td>		  
			      
			       <td  class="bt_info_odd"  exp="{file_name}"  isShow="Hide"  isExport='Show' >文档名称</td> 
			       <td class="bt_info_even" exp="{user_name}" isShow="Hide"  isExport='Show'>创建人</td>
				   <td class="bt_info_odd" exp="{create_date}" isShow="Hide"  isExport='Show'>创建时间</td>		
				   
			     </tr> 			        
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">备注</a></li>
			    <%if(fileAbbr!=null){	
			    if(fileAbbr.equals("HSEZYJHS")||fileAbbr.equals("YJSG")||fileAbbr.equals("CTBQ")){ %>
			    <li id='tag3_1'><a href="#" onclick="getTab3(1)">审批流程</a></li>
			    <%}} %>	    		    
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo   title=""/>
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

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	var fileAbbr = '<%=fileAbbr%>';
	
	function refreshData(){
		cruConfig.queryStr = " select t.file_id,t.file_name,t.ucm_id,to_char(t.create_date,'yyyy-MM-dd') create_date,e.user_name from bgp_doc_gms_file t left join p_auth_user e on t.creator_id=e.user_id and e.bsflag='0'  where t.bsflag='0' and t.is_file='1' and t.project_info_no='<%=projectInfoNo%>' and t.parent_file_id='<%=parent_file_id%>'  order by t.modifi_date desc ";
		cruConfig.currentPageUrl = "/hse/docSingle/hseDocList.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/docSingle/hseDocList.jsp";
		queryData(1);
	}

	// 简单查询
	function simpleSearch(){
		var fileName = document.getElementById("fileName").value;
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select t.file_id,t.file_name,t.ucm_id,to_char(t.create_date,'yyyy-MM-dd') create_date,e.user_name from bgp_doc_gms_file t left join p_auth_user e on t.creator_id=e.user_id and e.bsflag='0'  where t.bsflag='0' and t.is_file='1' and t.project_info_no='<%=projectInfoNo%>' and t.file_name like '%"+fileName+"%' order by t.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/docMultiple/hseDoc_list.jsp";
		queryData(1);
	}
	
	function clearQueryText(){
		document.getElementById("fileName").value = "";
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");



    function loadDataDetail(shuaId){
    	    	    		
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
	   	var fileAbbr = "<%=fileAbbr%>";
	   	var projectType = "<%=projectType %>";
	   	if(fileAbbr=="HSEZYJHS"||fileAbbr=="YJSG"||fileAbbr=="CTBQ"){
	   		var cordingId = "";
	   		var name = "";
	   		if(fileAbbr=="HSEZYJHS"){
	   			if(projectType=="5000100004000000008"){
	   				cordingId = "5110000004100001077";
	   			}else{
	   				cordingId = "5110000004100000065";
	   			}
		   			name = "HSE作业计划审批";
	   		}else if(fileAbbr=="YJSG"){
	   			if(projectType=="5000100004000000008"){
	   				cordingId = "5110000004100001076";
	   			}else{
	   				cordingId = "5110000004100000066";
	   			}
	   			name = "夜间施工计划审批";
	   		}else if(fileAbbr=="CTBQ"){
	   			if(projectType=="5000100004000000008"){
	   				cordingId = "5110000004100001074";
	   			}else{
		   			cordingId = "5110000004100000073";
	   			}
	   			name = "长途搬迁计划审批"
	   		}
	   		if(shuaId!= undefined){
				debugger;
				processNecessaryInfo={
						businessTableName:"bgp_doc_gms_file",	
						businessType:cordingId,             //编码管理中的编码ID
						businessId: shuaId,
						businessInfo:name,					
						applicantDate: '<%=appDate%>'
						};
						
						processAppendInfo = {
								file_id:shuaId
						};
						loadProcessHistoryInfo();
			}else{
				var ids = document.getElementById('rdo_entity_id').value;
			    if(ids==''){ 
				    alert("请先选中一条记录!");
			    		return;
			    }
			}
	   	}
    }
    
    function toAdd(){
    	popWindow('<%=contextPath%>/hse/docSingle/add_hseDocModify.jsp?fileAbbr='+fileAbbr,'800:600');
    }
    
	function toEdit() {
	    
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/hse/docSingle/add_hseDocModify.jsp?id='+ids,'800:600');
	}
	
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	
	function toDelete(){
		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteDoc", "file_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}
	
	function toSearch(){
		popWindow("<%=contextPath%>/hse/docSingle/hseDoc_search.jsp?projectInfoNo=<%=projectInfoNo%>&fileAbbr=<%=fileAbbr%>");
	}
	
</script>
</html>