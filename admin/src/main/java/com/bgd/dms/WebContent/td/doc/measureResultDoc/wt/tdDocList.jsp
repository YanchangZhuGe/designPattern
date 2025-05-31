<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String orgCode=user.getOrgCode();
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo==null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
		
	String businessType = request.getParameter("businessType");
	if(businessType==null || "".equals(businessType)){
		businessType = resultMsg.getValue("businessType");
	}
	
	String fileAbbr = request.getParameter("fileAbbr");
	if(fileAbbr==null || "".equals(fileAbbr)){
		if(resultMsg != null && resultMsg.getValue("fileAbbr") != null ){
			fileAbbr = resultMsg.getValue("fileAbbr");
		}
	}
	
	String isSingle = request.getParameter("isSingle")==null?"":request.getParameter("isSingle");
	if(isSingle==null || "".equals(isSingle)){
		if(resultMsg != null && resultMsg.getValue("isSingle") != null ){
			isSingle = resultMsg.getValue("isSingle")==null?"":resultMsg.getValue("isSingle");
		}
	}
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
  <title>测量技术报告</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData('')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
		  	  <%
		      	if("false".equals(isSingle)){
		      %>
		        <td class="ali_cdn_name">项目名称</td>
			    <td  width="20%">
			    <input name="s_project_info_id" id="s_project_info_id" class="input_width" value="" type="hidden" readonly="readonly"/>
     			<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text" readonly="readonly"/>   
    		    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/> 
			    </td>
		      <%} %>
			  	<td class="ali_cdn_name">测量技术报告</td>
			    <td class="ali_cdn_input"><input class="input_width" id="s_title_name" name="s_title_name" type="text"  /></td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			  	<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>	  		
  				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> 
  				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{tecnical_id}' id='rdo_entity_id_{tecnical_id}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <%
			      	if("false".equals(isSingle)){
			      %>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <%} %>
			      <td class="bt_info_odd" exp="<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>{file_name}</a>">测量技术报告</td>
			      <td class="bt_info_odd" exp="{writer}">编写人</td>
			      <td class="bt_info_odd" exp="{auditor}">审核人</td>
			      <td class="bt_info_odd" exp="{written_time}">编写时间</td>
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
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
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
</script>
 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var orgCode='<%=orgCode%>';
	
	//文档类型分类 
	var businessType = '<%=businessType%>';
	var fileAbbr = '<%=fileAbbr%>';
	var isSingle='<%=isSingle%>';
	
	function refreshData(str){
		var projStr="";
		if("false"!=isSingle){
			projStr=" and t.project_info_no = '<%=projectInfoNo%>'";
		}
		cruConfig.queryStr = "select t.* from (select t.project_info_no,t.tecnical_id,t.title,t.written_time,t.test_start_date,t.writer,t.auditor,t.memo,f.ucm_id,f.file_name,p.project_name from gp_ws_tecnical_basic t  left join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' left join bgp_doc_gms_file f on t.tecnical_id = f.relation_id and f.bsflag = '0' where t.bsflag = '0' "+projStr+" and t.business_type = '<%=businessType%>' "+str+" order by t.modifi_date desc) t";
		queryData(1);
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");


    function loadDataDetail(ids){
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
    }
    
    function toAdd(){
    	popWindow('<%=contextPath%>/td/doc/measureResultDoc/wt/add_tdDocModify.jsp?businessType='+businessType+'&fileAbbr='+fileAbbr+'&isSingle='+isSingle,'800:680');
    }
    
	function toEdit() {
		id = getSelIds("rdo_entity_id").split("-")[0];
		if (""==id) {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/td/doc/measureResultDoc/wt/add_tdDocModify.jsp?businessType='+businessType+'&id='+id+'&isSingle='+isSingle,'800:680');
	}
	
	function toDelete(){
		id = getSelIds("rdo_entity_id").split("-")[0];
		if (""==id) {
			alert("请选择一条记录!");
			return;
		}
	    if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WsTecnicalBasicSrv", "deleteTdDoc", "ids="+id);
			queryData(cruConfig.currentPage);
		}
		refreshData('');
	}
	
	 //选择项目
   function selectTeam(){

       var result = window.showModalDialog('<%=contextPath%>/td/searchProjectList.jsp?orgCode='+orgCode,'');
       if(result!=""){
       	var checkStr = result.split("-");	
	        document.getElementById("s_project_info_id").value = checkStr[0];
	        document.getElementById("s_project_name").value = checkStr[1];
       }
   }
	   
	// 简单查询
	function simpleSearch(){
		var title_name = document.getElementById("s_title_name").value;
		var s_project_info_id =document.getElementById("s_project_info_id")==null?"":document.getElementById("s_project_info_id").value;
		var str = "";
		if(''!=title_name){
			str += " and f.file_name like '%"+title_name+"%' ";
		}
		if(''!=s_project_info_id){
			str += " and t.project_info_no = '"+s_project_info_id+"' ";
		}
		refreshData(str);
	}
	
	function clearQueryText(){ 
		document.getElementById("s_title_name").value='';
	}
</script>
</html>