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
		
	String docType = request.getParameter("docType")==null?"":request.getParameter("docType");
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
  <title>基础资料检查</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>

			    <td>&nbsp;</td>
	  			<auth:ListButton functionId="" css="ck" event="onclick='toView()'" title="JCDP_btn_view"></auth:ListButton>
	  			<auth:ListButton functionId="" css="tj" event="onclick='toSubmit1()'" title="JCDP_Auditby"></auth:ListButton>
	  			<auth:ListButton functionId="" css="gb" event="onclick='toSubmit2()'" title="JCDP_Auditnotby"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{check_id}-{check_type}' id='rdo_entity_id_{check_id}' onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_odd" exp="{exploration_method_name}">勘探方法</td>
			      <td class="bt_info_even" exp="{employee_name}">检查人</td>		      
			      <td class="bt_info_odd" exp="{upload_date}">检查时间</td>		      
			      <td class="bt_info_even" exp="{check_type_name}">审核情况</td>		      
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">详情</a></li>
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">备注</a></li>				    	    
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content" >
					<table id="checkList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				            <td>检查项目</td>
				            <td>是否齐全</td>		
				            <td>是否合格</td>
				            <td>备注</td>
				        </tr>            
			        </table>				
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
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
	var docType = '<%=docType%>';
	var projectInfoNo = '<%=projectInfoNo%>';
	
	function refreshData(){
		var str="";
		if(""!=docType){
			str=" and t.doc_type='"+docType+"' " 
		}
		cruConfig.queryStr = " select t.* from ( select t.check_id,t.project_info_no,p.project_name,decode(t.doc_type,'5110000058000000001','测量','5110000068000000002','重力','5110000068000000003','磁力','5110000068000000004','化学勘探','5110000068000000005','人工场源电法','5110000068000000006','天然场源电法','5110000068000000007','工程','') as exploration_method_name,"+
		"t.upload_id,e.employee_name,t.upload_date,t.check_date,t.check_type,decode(t.check_type ,'0','待审核','1','审核通过','2','审核不通过','') check_type_name from bgp_doc_td_file_check t left join gp_task_project p on t.project_info_no=p.project_info_no left join comm_human_employee e on t.upload_id=e.employee_id  where t.bsflag='0' and t.project_info_no='"+projectInfoNo+"' "+str+" and t.check_type is not null order by t.upload_date  desc  ) t where 1=1 ";
		cruConfig.currentPageUrl = "/td/checkDoc/wt/auditDocList.jsp";
		queryData(1);
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");



    function loadDataDetail(ids){
    	    	    		
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
		
   	    
   	    var querySql = "select rownum,decode(d.is_complete,'0','是','1','否','') is_complete,decode(d.is_pass,'0','是','1','否','') is_pass , d.check_code_name ,d.notes from bgp_doc_td_file_check_data d left join bgp_doc_td_file_check c on c.check_id=d.check_id  where d.bsflag='0' and  c.check_id='"+ids.split("-")[0]+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		deleteTableTr("checkList");

		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				
			var tr = document.getElementById("checkList").insertRow();		
				
           	    if(i % 2 == 1){  
           			tr.className = "odd";
				}else{ 
					tr.className = "even";
				}

           	
				var td = tr.insertCell(0);
				td.innerHTML = datas[i].rownum;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].check_code_name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].is_complete;

				var td = tr.insertCell(3);
				td.innerHTML = datas[i].is_pass;
				
				var td = tr.insertCell(4);
				td.innerHTML = datas[i].notes;
				
			}
		}	
    }
    
	function toView() {
	    
		ids = getSelectedValue();
		if(ids==''){ 
			alert("请先选中一条记录!");
		    return;
		}

		popWindow('<%=contextPath%>/td/toCheckDocView.srq?id='+ids.split("-")[0]+'&docType='+docType,'800:600');
	}
	
	function toSubmit1() {
	    
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if(ids.split("-")[1] == "1" || ids.split("-")[1] == "2"){
			alert("该基础检查表已审核");
			return;
		}
		if (!window.confirm("确认要提交吗?")) {
			return;
		}
		
		var sql = "update bgp_doc_td_file_check t set t.check_type='1',modifi_date=sysdate where t.check_id = '"+ids.split("-")[0]+"' ";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		var retObject = syncRequest('Post',path,params);
		refreshData();
	}
	
	function toSubmit2() {
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if(ids.split("-")[1] == "1" || ids.split("-")[1] == "2"){
			alert("该基础检查表已审核");
			return;
		}
		if (!window.confirm("确认要提交吗?")) {
			return;
		}
		
		var sql = "update bgp_doc_td_file_check t set t.check_type='2',modifi_date=sysdate where t.check_id = '"+ids.split("-")[0]+"' ";

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
			str += " and file_name like '%"+file_name+"%' ";
		}
		cruConfig.cdtStr = str;
		refreshData();
	}
	
	function clearQueryText(){ 
		document.getElementById("s_file_name").value='';
		cruConfig.cdtStr = "";
	}

	//chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    } 
</script>
</html>