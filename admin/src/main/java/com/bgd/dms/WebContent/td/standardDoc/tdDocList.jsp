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
  <title>标准申请</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();queryDocList()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">标准名称</td>
			    <td class="ali_cdn_input"><input class="input_width" id="s_file_name" name="s_file_name" type="text"  /></td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			  	<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>	  		
  				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> 
  				<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{file_id}-{proc_status}-{coding_name}-{project_info_no}-{project_name}' id='rdo_entity_id_{file_id}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{coding_name}">标准类型</td>
			      <td class="bt_info_even" exp="{proc_status_name}">单据状态</td>	
			      <td class="bt_info_odd" exp="{employee_name}">申请人</td>
			      <td class="bt_info_even" exp="{upload_date}">申请日期</td>		   
			      <td class="bt_info_odd" exp="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>附件</a>">申请领取标准列表</td>   
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">审批流程</a></li>	    
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		
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
	
	
	function refreshData(){

		cruConfig.queryStr = "  select t.* from ( select te.proc_status, decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name,t.file_id,t.file_name,t.ucm_id,to_char(t.upload_date,'yyyy-MM-dd') upload_date,e.employee_name,t.doc_type,d.coding_name,t.project_info_no,p.project_name from bgp_doc_gms_file t left join comm_human_employee e on t.creator_id=e.employee_id and e.bsflag='0' left join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' left join comm_coding_sort_detail d on t.doc_file_type=d.coding_code_id and d.bsflag='0' left join common_busi_wf_middle te on    te.business_id=t.file_id   and te.bsflag='0' and te.business_type='5110000004100000062' where t.bsflag='0' and t.project_info_no='<%=projectInfoNo%>' and t.doc_type='0110000061000000029' order by t.upload_date desc ) t where 1=1  ";
		cruConfig.currentPageUrl = "/td/doc/tdDocList.jsp";
		queryData(1);
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSubmit(){
		ids = getSelectedValue();

		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if (!window.confirm("确认要提交吗?")) {
			return;
		}		
		submitProcessInfo();
		refreshData();
	}

    function loadDataDetail(ids){
    	
  	  processNecessaryInfo={         
	    		businessTableName:"bgp_doc_gms_file",    //置入流程管控的业务表的主表表明
	    		businessType:"5110000004100000062",        //业务类型 即为之前设置的业务大类
	    		businessId: ids.split("-")[0],         //业务主表主键值
	    		businessInfo:ids.split("-")[2]+"申请审核",        //用于待审批界面展示业务信息
	    		applicantDate:'<%=appDate%>'       //流程发起时间
	    
	    	}; 
	    	processAppendInfo={ 	    		 
	    				id: ids.split("-")[0],
	    				projectInfoNo:ids.split("-")[3],
	    				projectName:ids.split("-")[4]
	     	};   
	    loadProcessHistoryInfo();
	    
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
		
    }
    
    function toAdd(){
    	popWindow('<%=contextPath%>/td/standardDoc/add_tdDocModify.jsp?docType=0110000061000000029','800:600');
    }
    
	function toEdit() {
	    
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/td/standardDoc/add_tdDocModify.jsp?id='+ids.split("-")[0],'800:600');
	}
	function toDelete(){

		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if (!window.confirm("确认要删除吗?")) {
			return;
		}

		if(ids.split("-").length == 2){
			if(ids.split("-")[1] == '1' || ids.split("-")[1] == '3'){
				alert("该申请单已提交!");
				return;
			}
		}
		var id = "'"+ids.split("-")[0]+"'";
		
		jcdpCallService("TdDocServiceSrv","deleteTdDoc","id="+id);	
		
		var sql = "update bgp_doc_gms_file t set t.bsflag='1' where t.file_id in ("+id+") ";

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

	// 简单查询
	function simpleSearch(){
		var file_name = document.getElementById("s_file_name").value;
		
		var str = "";

		if(file_name!=''){
			str += " and  file_name like '%"+file_name+"%' ";
		}
		cruConfig.cdtStr = str;
		refreshData();
	}
	
	function clearQueryText(){ 
		document.getElementById("s_file_name").value='';
	}
</script>
</html>