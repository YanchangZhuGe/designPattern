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
	String projectInfoNo = user.getProjectInfoNo();
		
	String codingCodeId = request.getParameter("codingCodeId");
	if(codingCodeId==null || "".equals(codingCodeId)){
		codingCodeId = resultMsg.getValue("codingCodeId");
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
			    <td class="ali_cdn_input"><input class="input_width" id="s_file_name" name="s_file_name" type="text"  /></td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}-{is_template}' id='rdo_entity_id_{file_id}'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>{file_name}</a>">文档名称</td>
			      <td class="bt_info_even" exp="{employee_name}">创建人</td>
			      <td class="bt_info_odd" exp="{is_template_name}">审批结果</td>
			      <td class="bt_info_even" exp="{create_date}">创建时间</td>		      
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
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">审核</a></li>		    
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				<div id="tab_box_content1" class="tab_box_content">
					<div id="inq_tool_box">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
								<td background="<%=contextPath%>/images/list_15.png">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr align="right">
											<td>&nbsp;</td>
											<auth:ListButton css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
										</tr>
									</table></td>
								<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
							</tr>
						</table>
					</div>
					<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				 	<tr>
				         <td class="inquire_item4">审批结果：</td>
				         <td class="inquire_form4">
							<select id="isTemplate" name="isTemplate" class="select_width"><option value="" >请选择</option><option value="0">正常</option><option value="1">不正常</option></select>
				         </td>
				         <td class="inquire_item4">&nbsp;</td>
				         <td class="inquire_form4">&nbsp;</td>
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

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	//文档类型分类
	var codingCodeId = '<%=codingCodeId%>';
	
	function refreshData(){

		cruConfig.queryStr = " select t.* from ( select t.file_id,t.file_name,t.ucm_id,to_char(t.create_date,'yyyy-MM-dd') create_date,e.employee_name,t.doc_type,t.is_template,decode(t.is_template,'0','正常','1','不正常','') is_template_name from bgp_doc_gms_file t left join comm_human_employee e on t.creator_id=e.employee_id and e.bsflag='0' where t.bsflag='0' and t.project_info_no='<%=projectInfoNo%>' and t.doc_type='<%=codingCodeId%>' order by t.create_date desc ) t where 1=1 ";
		cruConfig.currentPageUrl = "/td/doc/tdDocList.jsp";
		queryData(1);
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");



    function loadDataDetail(ids){
    	    	    		
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
   	    var isTemplate = document.getElementById("isTemplate");
   	    for(var i=0;i<isTemplate.options.length;i++){
   	    	if(isTemplate.options[i].value == ids.split("-")[1]){
   	    		isTemplate.options[i].selected = "selected";
   	    		break;
   	    	}
   	    }		
   	    
    }
    
    function toSubmit(){
    	
    	ids = getSelectedValue();
    	
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		if(!notNullForCheck("isTemplate","审批结果")) return false;
		
    	var isTemplate = document.getElementById("isTemplate").value;
		
		var sql = "update bgp_doc_gms_file t set t.is_template='"+isTemplate+"' where t.file_id = '"+ids.split("-")[0]+"' ";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		var retObject = syncRequest('Post',path,params);
		refreshData();
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
	
	function notNullForCheck(filedName,fieldInfo){

		if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
			alert(fieldInfo+"不能为空");
			document.getElementById(filedName).onfocus="true";
			return false;
		}else{
			return true;
		}
	}
	
	// 简单查询
	function simpleSearch(){

		var file_name = document.getElementById("s_file_name").value;
		
		var str = "";
		if(file_name!=''){
			str += " and t.file_name like '%"+file_name+"%' ";
		}
		cruConfig.cdtStr = str;
		refreshData();
	}
	
	function clearQueryText(){ 
		document.getElementById("s_file_name").value='';
		cruConfig.cdtStr = "";
	}
	
</script>
</html>