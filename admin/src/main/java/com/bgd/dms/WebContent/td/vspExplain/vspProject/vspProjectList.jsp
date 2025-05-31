<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.util.AppCrypt" %> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory,com.bgp.gms.service.td.srv.TdDocServiceSrv"%> 

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectInfoNo = user.getProjectInfoNo();
	
	String optionType = request.getParameter("optionType");
	if(optionType==null || "".equals(optionType)){
		optionType = resultMsg.getValue("optionType");
	}
	
	//String t=AppCrypt.decrypt("79372D3EB76349B1").toString();
	//System.out.println(t);
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
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

  <title>项目维护</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input class="input_width" id="project_name_s" name="project_name_s" type="text"  /></td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dk" event="onclick='toSon()'" title="子项目管理"></auth:ListButton>
			  	<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新建年度项目"></auth:ListButton>	  		
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{ws_project_no}-{option_type}-{project_name}' id='rdo_entity_id_{ws_project_no}'  onclick='chooseOne(this);' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="{project_type_name}">项目类型</td>	
			      <td class="bt_info_odd" exp="{market_classify_name}">市场范围</td>
			      <td class="bt_info_even" exp="{project_year}">年度</td>		      
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
			  <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">基本信息</a></li>	
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">子项目信息</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>	      
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				 <table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>项目名：</td>
								<td class="inquire_form4" id="item0_0"> 
								<input type="text"
									id="project_name" name="project_name" value=""
									class="input_width" /></td>
								<td class="inquire_item4">项目编号：</td>
								<td class="inquire_form4" id="item0_1"><input type="text"
									id="project_id" name="project_id" value="从ERP系统自动获取"
									disabled="disabled" class="input_width" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">项目类型：</td>
								<td class="inquire_form4" id="item0_2"><input type="text"
									id="project_type" name="project_type" value=""
									class="input_width" />  </td>
								<td class="inquire_item4"><span class="red_star">*</span>市场范围：</td>
								<td class="inquire_form4" id="item0_4"> <input
									id="market_classify_name" name="market_classify_name" value=""
									type="text" class="input_width" readonly="readonly" />
									&nbsp;&nbsp; </td>
							</tr>
							<tr>
								
								<td class="inquire_item4">年度：</td>
								<td class="inquire_form4" id="item0_5">
								<input type="text"
									id="project_year" name="project_year" value=""
									class="input_width" /> 
						      </td>
							</tr>
							 
						</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				 <table id="projectMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr  class="bt_info">
			    	    <td>序号</td>
			            <td>项目名称</td>
			            <td>甲方单位</td>		
			            <td>井号</td>
			            <td>项目业务类型</td>			
			            <td>项目开始时间</td>           
			            <td>项目结束时间</td>
			            <td>项目重要程度</td> 
			        </tr>            
			        </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
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
  
	function refreshData(){ 
		cruConfig.queryStr = "  select t.* from ( select s1.coding_name project_type_name,s2.coding_name market_classify_name ,pt.ws_project_no,pt.project_name,pt.project_id,pt.project_year,pt.project_type,pt.market_classify,pt.option_type,pt.bsflag  from GP_WS_PROJECT  pt   left join comm_coding_sort_detail s1   on pt.project_type = s1.coding_code_id   and s1.bsflag = '0'    left join comm_coding_sort_detail s2    on pt.market_classify = s2.coding_code_id   and s2.bsflag = '0'   where pt.bsflag='0' and pt.option_type='<%=optionType%>'  order by pt.modifi_date desc ) t   ";
		cruConfig.currentPageUrl = "/td/vspExplain/vspProject/vspProjectList.jsp";
		queryData(1);
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

  
    function loadDataDetail(ids){
    	 
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
 
		 var querySql = "  select s1.coding_name project_type_name,s2.coding_name market_classify_name ,pt.ws_project_no,pt.project_name,pt.project_id,pt.project_year,pt.project_type,pt.market_classify,pt.option_type,pt.bsflag  from GP_WS_PROJECT  pt   left join comm_coding_sort_detail s1   on pt.project_type = s1.coding_code_id   and s1.bsflag = '0'    left join comm_coding_sort_detail s2    on pt.market_classify = s2.coding_code_id   and s2.bsflag = '0'   where pt.bsflag='0' and pt.option_type='<%=optionType%>'  and pt.ws_project_no='"+ids.split("-")[0]+"' ";				 	 
		 var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			var  datas = queryRet.datas;
			if(datas != null){		 
 
	         	 document.getElementsByName("project_type")[0].value=datas[0].project_type_name;  
				 document.getElementsByName("project_name")[0].value=datas[0].project_name;  
				 document.getElementsByName("market_classify_name")[0].value=datas[0].market_classify_name;  
 
				 document.getElementsByName("project_year")[0].value=datas[0].project_year; 
	    		 
			}					
			
 		}	
		
		var querySqlA = "select  rownum,ccsd.coding_name as manage_org_name,decode(pdt.project_type,'5000100004000000008','井中地震')project_type_name,decode(pdt.project_country,'1','国内','2','国外')project_country_name,decode(pdt.is_main_project,'1','集团重点','2','地区（局）重点','3','正常')is_main_name,decode(pdt.project_business_type,'1','处理','2','解释','3','处理,解释') business_type_name, pdt.ws_detail_no ,pdt.ws_project_no,pdt.project_name,pdt.project_id,pdt.project_year,pdt.project_type,pdt.market_classify,pdt.well_no,pdt.option_type,pdt.start_time,pdt.end_time,pdt.is_main_project,pdt.project_country,pdt.manage_org,pdt.prctr,pdt.prctr_name,pdt.project_business_type  from  GP_WS_PROJECT_DETAIL pdt  left join comm_coding_sort_detail ccsd on pdt.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0'   where pdt.bsflag='0' and pdt.option_type='<%=optionType%>' and pdt.ws_project_no='"+ids.split("-")[0]+"' ";
		var queryRetA = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySqlA);		
		var datasA = queryRetA.datas;
		 
		deleteTableTr("projectMap");
		
		if(datasA != null){
			for (var i = 0; i< queryRetA.datas.length; i++) { 
				var tr = document.getElementById("projectMap").insertRow();		
				
	          	if(i % 2 == 1){  
	          		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}

				var td = tr.insertCell(0);
				td.innerHTML = datasA[i].rownum;
				
				var td = tr.insertCell(1);
				td.innerHTML = datasA[i].project_name;
				 
				var td = tr.insertCell(2);
				td.innerHTML = datasA[i].manage_org_name;
				
				var td = tr.insertCell(3);
				td.innerHTML = datasA[i].well_no;
				
				var td = tr.insertCell(4);
				td.innerHTML = datasA[i].business_type_name;

				var td = tr.insertCell(5);
				td.innerHTML = datasA[i].start_time;

				var td = tr.insertCell(6);
				td.innerHTML = datasA[i].end_time;
				
				var td = tr.insertCell(7);
				td.innerHTML = datasA[i].is_main_name;
				
			}
		}
			
		
		
    }
    
 
    function toAdd(){
    	popWindow('<%=contextPath%>/td/vspExplain/vspProject/fatherProject.jsp?projectType=5000100004000000008&optionType=<%=optionType%>','750:700');
 
    }
	function toEdit() {
	    
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
    	popWindow('<%=contextPath%>/td/vspExplain/vspProject/fatherProject.jsp?projectType=5000100004000000008&optionType=<%=optionType%>&ws_project_no='+ids.split("-")[0],'750:700');
 
  	}
	
	function toSon(){ 
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		var projectFatherName=encodeURI(encodeURI(ids.split("-")[2]));
		popWindow('<%=contextPath%>/td/vspExplain/vspProject/subProjectList.jsp?projectFatherName='+projectFatherName+'&projectFatherNo='+ids.split("-")[0]+'&optionType=<%=optionType%>','1100:850');

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
	
	var optionTypes='<%=optionType%>'; 
	
	function toDelete(){ 
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	

		var querySql="";
		if(optionTypes =='vsp'){
			 // 是否关联处理解释任务书
	        querySql= " select project_info_no from GP_WS_VSP_COMMITMENTS   where  doc_type = '0110000061200000001'  and bsflag='0'  and project_info_no  in (select ws_detail_no  from GP_WS_PROJECT_DETAIL where  ws_project_no='"+ids.split("-")[0]+"' and bsflag='0')   ";
		 
		}else {
		    querySql= " select project_info_no from GP_WS_VSP_COMMITMENTS   where  doc_type = '0110000061200000006'  and bsflag='0'  and project_info_no  in (select ws_detail_no  from GP_WS_PROJECT_DETAIL where  ws_project_no='"+ids.split("-")[0]+"' and bsflag='0')   ";
			 
		}
      	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
        if(datas.length>0){
        	alert('以下子项目已在处理解释任务书中创建,不能删除');
        	return;
        }
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
        var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	
        //同时删除 父、子项目信息 
		var querySql3 = " select dl.ws_detail_no  from GP_WS_PROJECT_DETAIL dl  where dl.ws_project_no='"+ids.split("-")[0]+"' and dl.bsflag='0'  ";
		var queryRet3 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql3);
		var datas3 = queryRet3.datas;
		if(datas3 != null){	 
		     for (var k = 0; k< queryRet3.datas.length; k++) {    
		    	 var ws_detail_nos=datas3[k].ws_detail_no; 
		 		var submitStrs = 'JCDP_TABLE_NAME=GP_WS_PROJECT_DETAIL&JCDP_TABLE_ID='+ws_detail_nos +'&bsflag=1';
			    syncRequest('Post',paths,encodeURI(encodeURI(submitStrs)));   
			 
		     } 
		}
		
		var sql = "update GP_WS_PROJECT t set t.bsflag='1' where t.ws_project_no ='"+ids.split("-")[0]+"' "; 
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids.split("-")[0];
		var retObject = syncRequest('Post',path,params);
		 
		refreshData();
		
	}
	// 简单查询
	function simpleSearch(){
		var file_name = document.getElementById("project_name_s").value;
		
		var str = "  1=1  ";

		if(file_name!=''){
			str += " and project_name like '%"+file_name+"%' ";
		}
		cruConfig.cdtStr = str;
		refreshData();
	}
	
	function clearQueryText(){ 
		document.getElementById("project_name_s").value='';
	}
	
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