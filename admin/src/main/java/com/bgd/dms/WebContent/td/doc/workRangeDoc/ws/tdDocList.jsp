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
	
	String ifPorject = request.getParameter("ifPorject");
	if(ifPorject==null || "".equals(ifPorject)){
		ifPorject ="2";
	}
	
	String projectInfoNo = request.getParameter("projectInfoNo");
	if(projectInfoNo==null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
		
	String businessType = request.getParameter("businessType")==null?"":request.getParameter("businessType");
	
	String fileAbbr = request.getParameter("fileAbbr");
	if(fileAbbr==null || "".equals(fileAbbr)){
		if(resultMsg != null && resultMsg.getValue("fileAbbr") != null ){
			fileAbbr = resultMsg.getValue("fileAbbr");
		}
	}
	
	
	String parent_file_id = "";
	String sql = "select * from bgp_doc_gms_file f where f.bsflag='0' and is_file='0' and f.project_info_no='"+projectInfoNo+"' and f.file_abbr='"+fileAbbr+"'";
	Map map  = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		parent_file_id = (String)map.get("fileId");
	}
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
  <title>工区踏勘</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData('')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">工区名称</td>
			    <td class="ali_cdn_input"><input class="input_width" id="s_title_name" name="s_title_name" type="text"  /></td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			        	       <% 
			  		  if(ifPorject.equals("2")){
			    %>
			    
			  	<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>	  		
  				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> 
  				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
  					    <%
			   		 } 
  				%> 
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
			       <td class="bt_info_odd" exp="{title}">工区名称</td>
			      <td class="bt_info_even" exp="<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>{file_name}</a>">踏勘报告</td>
 
			      <td class="bt_info_odd" exp="{writer}">编写人</td>
			      <td class="bt_info_even" exp="{auditor}">审核人</td>
			      <td class="bt_info_odd" exp="{leader}">负责人</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>	    	    
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
			 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
								<tr style="display:none;">
									<td class="inquire_item4">勘探组织单位：</td>
									<td class="inquire_form4" colspan="2">
											<input type="text" id="written_unit" name="written_unit" value="" class="input_width"/></td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>工区名称：</td>
									<td class="inquire_form4"> 
									<input name="tecnical_id" id="tecnical_id" class="input_width" value="" type="hidden" readonly="readonly"/>
									<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
						            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
							        <input name="project_info_no" id="project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>           
						           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
									<input type="text" id="title" name="title" value="" style="width:82%;height:24px;line-height: 24px;border:#a4b2c0 1px solid;background-color:#FFF;"/>
							
									</td>
									<td class="inquire_item4">结束日期：</td>
									<td class="inquire_form4">
										<input type="text" id="test_end_date" name="test_end_date" value="" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(test_end_date,tributton2);" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">编写人：</td>
									<td class="inquire_form4"><input type="text" id="writer" name="writer" value="" class="input_width"/></td>
									<td class="inquire_item4">开始日期：</td>
									<td class="inquire_form4">
										<input type="text" id="test_start_date" name="test_start_date" value="" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(test_start_date,tributton1);" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">审核人：</td>
									<td class="inquire_form4"><input type="text" id="auditor" name="auditor" value="" class="input_width" /></td>
									<td class="inquire_item4">负责人：</td>
									<td class="inquire_form4"><input type="text" id="leader" name="leader" value="" class="input_width" /></td>
								</tr>
								<tr>
									<td class="inquire_item4">影响施工因素：</td>
									<td class="inquire_form4" colspan="3"><textarea id="memo"  name="memo" cols="45" rows="5" class="textarea"></textarea></td>
								</tr>
								<tr>
									<td class="inquire_item4">工区地理位置图：</td>
									<td colspan="2">
							 
					    				<div id="down_0110000061100000016"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4">工区卫片图：</td>
									<td colspan="2">
				 
										<div id="down_0110000061000000070"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4">典型地表照片：</td>
									<td colspan="2">
						 
										<div id="down_0110000061100000017"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4">踏勘报告：</td>
									<td colspan="2">
				 
										<div id="down_0110000061100000018"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
							</table>
				</iframe>	
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
	var businessType = '<%=businessType%>';
	var fileAbbr = '<%=fileAbbr%>';
	var ifPorject='<%=ifPorject%>';
	
	function refreshData(str){
		
		if(ifPorject =='1'){
			cruConfig.queryStr = "select t.* from (select f.ucm_id,f.file_name,t.project_info_no, t.tecnical_id, t.title,t.test_start_date,t.test_end_date,t.written_unit,t.writer,t.auditor,t.leader "+
			"from gp_ws_tecnical_basic t "+
			"left join bgp_doc_gms_file f on t.tecnical_id = f.relation_id and f.doc_file_type = '0110000061100000018' and f.bsflag = '0' "+
			"where t.bsflag = '0'   and t.business_type = '<%=businessType%>' "+str+" order by t.modifi_date desc) t";
			queryData(1);
		}else if (ifPorject=='2'){
			cruConfig.queryStr = "select t.* from (select f.ucm_id,f.file_name,t.project_info_no, t.tecnical_id, t.title,t.test_start_date,t.test_end_date,t.written_unit,t.writer,t.auditor,t.leader "+
			"from gp_ws_tecnical_basic t "+
			"left join bgp_doc_gms_file f on t.tecnical_id = f.relation_id and f.doc_file_type = '0110000061100000018' and f.bsflag = '0' "+
			"where t.bsflag = '0' and t.project_info_no = '<%=projectInfoNo%>' and t.business_type = '<%=businessType%>' "+str+" order by t.modifi_date desc) t";
			queryData(1);
		}
		
		

	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");


    function loadDataDetail(ids){
	     document.getElementById("down_0110000061100000016").innerHTML="";// 1 
	     document.getElementById("down_0110000061000000070").innerHTML="";// 2 
	     document.getElementById("down_0110000061100000017").innerHTML="";// 3 
	     document.getElementById("down_0110000061100000018").innerHTML="";// 4
	     
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	    var  fileId=ids;
   		if(fileId!='null'){
   			var querySql = " select * from(select t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.file_name,b.tecnical_id,b.title,b.test_start_date,b.test_end_date,b.written_unit,b.memo,b.writer,b.auditor,b.leader from gp_ws_tecnical_basic b left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where m.tecnical_id ='"+fileId+"'";
   			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
   			var datas = queryRet.datas;
   			if(datas!=null && datas.length>0){
   				document.getElementById("tecnical_id").value = datas[0].tecnical_id;
   				document.getElementById("title").value = datas[0].title;
   				document.getElementById("test_start_date").value = datas[0].test_start_date;
   				document.getElementById("test_end_date").value = datas[0].test_end_date;
   				document.getElementById("written_unit").value = datas[0].written_unit;
   				document.getElementById("writer").value = datas[0].writer;
   				document.getElementById("auditor").value = datas[0].auditor;
   				document.getElementById("leader").value = datas[0].leader;
   				document.getElementById("memo").value = datas[0].memo;
   				for(var i=0;i<datas.length;i++){
   					var ucmId=datas[i].ucm_id;
   				 
   					$("#down_"+datas[i].doc_file_type).html("");
   					$("#down_"+datas[i].doc_file_type).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>"+datas[i].file_name+"</a>");
   				}
   			}
   		}
    }
    
    function toAdd(){
    	popWindow('<%=contextPath%>/td/doc/workRangeDoc/ws/add_tdDocModify.jsp?businessType='+businessType+'&fileAbbr='+fileAbbr+'&parent_file_id=<%=parent_file_id%>','800:680');
    }
	function dbclickRow(ids){
		popWindow('<%=contextPath%>/td/doc/workRangeDoc/ws/add_tdDocModify.jsp?businessType='+businessType+'&id='+ids+'&parent_file_id=<%=parent_file_id%>','800:680');
	}
	function toEdit() {
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/td/doc/workRangeDoc/ws/add_tdDocModify.jsp?businessType='+businessType+'&id='+ids+'&parent_file_id=<%=parent_file_id%>','800:680');
	}
	
	function toDelete(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		
	    if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WsTecnicalBasicSrv", "deleteTdDoc", "ids="+ids);
			queryData(cruConfig.currentPage);
		}
		refreshData('');
	}
	

	// 简单查询
	function simpleSearch(){
		var title_name = document.getElementById("s_title_name").value;
		
		var str = "";

		if(title_name!=''){
			str += " and t.title like '%"+title_name+"%' ";
		}
		refreshData(str);
	}
	
	function clearQueryText(){ 
		document.getElementById("s_title_name").value='';
	}
</script>
</html>