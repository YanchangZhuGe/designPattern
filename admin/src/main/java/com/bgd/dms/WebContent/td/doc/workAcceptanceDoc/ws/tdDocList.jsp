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
  <title>收工验收材料</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData('')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">标题</td>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{tecnical_id}-{f_no}' id='rdo_entity_id_{tecnical_id}'  onclick='chooseOne(this);' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{title}">标题</td>
			      <td class="bt_info_odd" exp="<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>{file_name}</a>">收工验收报告</td>
			      <td class="bt_info_even" exp="{written_time}">验收时间</td>
			      <td class="bt_info_odd" exp="{writer}">参加人员</td>
			      <td class="bt_info_even" exp="{auditor}">负责人</td>
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
			<table id="tableDoc"   width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>标题：</td>
									<td class="inquire_form4" colspan="2">
									<input name="tecnical_id" id="tecnical_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	         <input name="i_sum" id="i_sum" class="input_width" value="0" type="hidden" readonly="readonly"/>
										<input type="text" id="title" name="title" value="" style="width:92%;height:24px;line-height: 24px;border:#a4b2c0 1px solid;background-color:#FFF;"/>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">参加人员：</td>
									<td class="inquire_form4"><input type="text" id="writer" name="writer" value="" class="input_width"/></td>
									<td class="inquire_item4">验收时间：</td>
									<td class="inquire_form4">
										<input type="text" id="written_time" name="written_time" value="" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(written_time,tributton1);" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">负责人：</td>
									<td class="inquire_form4"><input type="text" id="auditor" name="auditor" value="" class="input_width" /></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td class="inquire_item4">收工验收报告：</td>
									<td colspan="2">
 
					    				<div id="down_0110000061100000013"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
								<td class="inquire_item4">收工验收检查表：</td>
								<td colspan="2">
 
									<div id="down_0110000061100000131_0"></div>
								</td>
			 
							 
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
//		cruConfig.queryStr = "select t.* from (select t.project_info_no,t.tecnical_id,t.title,t.written_time,t.writer,t.leader,f.ucm_id ,f.file_name from gp_ws_tecnical_basic t left join bgp_doc_gms_file f on t.tecnical_id=f.relation_id and f.bsflag='0' where t.bsflag = '0' and t.project_info_no = '<%=projectInfoNo%>' and t.business_type = '<%=businessType%>' "+str+" order by t.modifi_date desc) t";
//		queryData(1);
//		
		var father_no="";
		 
        var  querySql1 = "  select t.project_father_no  from gp_task_project t  where  t.project_type='5000100004000000008' and t.bsflag='0'  and  t.project_common='1' and t.project_info_no='<%=projectInfoNo%>' " ;
        var  queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=6000&querySql='+encodeURI(encodeURI(querySql1)));
       
	       	if(queryRet1.returnCode=='0'){
	       		var  datas1 = queryRet1.datas;	 
	       		if(datas1 != null && datas1 != ''){	  
	       			father_no=datas1[0].project_father_no;
   			  
	       		} 
	       	}
	
		if(ifPorject =='1'){
			cruConfig.queryStr = "select t.* ,'' f_no from (select f.ucm_id,f.file_name,t.project_info_no, t.tecnical_id, t.title,written_time,t.writer,t.auditor "+
			"from gp_ws_tecnical_basic t "+
			"left join bgp_doc_gms_file f on t.tecnical_id = f.relation_id and f.doc_file_type = '0110000061100000013' and f.bsflag = '0' "+
			"where t.bsflag = '0'   and t.business_type = '<%=businessType%>' "+str+" order by t.modifi_date desc) t";
			queryData(1);
		}else if (ifPorject=='2'){
			cruConfig.queryStr = "select t.* , '1' f_no from (select f.ucm_id,f.file_name,t.project_info_no, t.tecnical_id, t.title,written_time,t.writer,t.auditor "+
			"from gp_ws_tecnical_basic t "+
			"left join bgp_doc_gms_file f on t.tecnical_id = f.relation_id and f.doc_file_type = '0110000061100000013' and f.bsflag = '0' "+
			"where t.bsflag = '0' and t.project_info_no = '"+father_no+"' and t.business_type = '<%=businessType%>' "+str+" order by t.modifi_date desc) t union all "+				
				"select w.* , '0' f_no  from (select f.ucm_id,f.file_name,t.project_info_no, t.tecnical_id, t.title,written_time,t.writer,t.auditor "+
			"from gp_ws_tecnical_basic t "+
			"left join bgp_doc_gms_file f on t.tecnical_id = f.relation_id and f.doc_file_type = '0110000061100000013' and f.bsflag = '0' "+
			"where t.bsflag = '0' and t.project_info_no = '<%=projectInfoNo%>' and t.business_type = '<%=businessType%>' "+str+" order by t.modifi_date desc)  w ";
			queryData(1);
		}
		
		
		
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");


    function loadDataDetail(ids){
    	
    	  document.getElementById("down_0110000061100000013").innerHTML="";// 1 down_0110000061100000131_0
          // 4 清除上一条数据文档，起到刷新作用
  		var inum=0;
  		var isnum=document.getElementById("i_sum").value;
   
  		  if(isnum!=null){
  			  if(isnum==0){
  				  document.getElementById('down_0110000061100000131_0').innerHTML="";
  			  }else if (isnum==1){ 
  				  document.getElementById('down_0110000061100000131_0').innerHTML="";
  				  document.getElementById('down_0110000061100000131_1').innerHTML="";
  			  }else  {
  				  for(var j=0;j<isnum;j++){ 
  					  document.getElementById('down_0110000061100000131_'+j).innerHTML="";
  				  }
  			  }
  		  }
  		  
  		  
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
   	   var  fileId=ids.split("-")[0];
   	 if(fileId!='null'){
   	  
 		
 		var querySql = " select * from(select  b.business_type, b.tecnical_id,b.title,b.written_time,b.writer,b.auditor from gp_ws_tecnical_basic b  )m where     m.tecnical_id ='"+fileId+"'";
 		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
 		var datas = queryRet.datas;
 			if(datas!=null && datas.length>0){
 				document.getElementById("tecnical_id").value = datas[0].tecnical_id;
 				document.getElementById("title").value = datas[0].title;
 				document.getElementById("written_time").value = datas[0].written_time;
 				document.getElementById("writer").value = datas[0].writer;
 				document.getElementById("auditor").value = datas[0].auditor;
 				
 			 
 			}
 			var querySqlA = " select * from(select t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.file_name,b.tecnical_id,b.line_no,b.title,b.writer,b.point ,t.create_date  from gp_ws_tecnical_basic b left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where   m.doc_file_type='0110000061100000131'  and  m.tecnical_id ='"+fileId+"'  order by  create_date asc ";
 			var queryRetA = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySqlA);
 			var datasA = queryRetA.datas;
 			if(datasA!=null && datasA.length>0){
 	 
 				for(var i=0;i<datasA.length;i++){
 					if(""!=datasA[i].ucm_id){
 						var ucmIdA=datasA[i].ucm_id;
 						if(i>=1){
 							inum=datasA.length; // 1
 							addRow();
 						}
 						  document.getElementById('down_0110000061100000131_'+i).innerHTML="";// 2 
 						var str=datasA[i].file_name==""?"":datasA[i].file_name.substr(0,10)+'...';
 						$("#down_0110000061100000131_"+i).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmIdA+"&emflag=0>"+str+"</a>");
 	 
 					}
 				}
 			}
 			
 			var querySqlB = " select * from(select t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.file_name,b.tecnical_id,b.title,b.written_time,b.writer,b.auditor from gp_ws_tecnical_basic b left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where  m.doc_file_type='0110000061100000013'  and m.tecnical_id ='"+fileId+"'";
 			var queryRetB = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySqlB);
 			var datasB = queryRetB.datas;
 				if(datasB!=null && datasB.length>0){ 
 					for(var i=0;i<datasB.length;i++){
 						if(""!=datasB[i].ucm_id){
 							var ucmIdB=datasB[i].ucm_id; 
 		 
 							$("#down_"+datasB[i].doc_file_type).html("");
 							$("#down_"+datasB[i].doc_file_type).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmIdB+"&emflag=0>"+datasB[i].file_name+"</a>");
 						}
 					}
 				}
 		
 		 
 		
 	}
   	 
     document.getElementById("i_sum").value = inum; // 3
    }
 
    
    var t=0;
    function addRow(){    
    	var num=++t; 
    	var tr=document.all.tableDoc.insertRow();
      	tr.insertCell(0).innerHTML=" ";  
      	
    	var td = tr.insertCell(1);
    	td.setAttribute("colspan",3);
    	td.innerHTML=" <div id='down_0110000061100000131_"+num+"'></div>";
   
    	tr.insertCell(2).innerHTML="";
    	tr.insertCell(3).innerHTML="";
    }
    
    
    function toAdd(){
    	popWindow('<%=contextPath%>/td/doc/workAcceptanceDoc/ws/add_tdDocModify.jsp?businessType='+businessType+'&fileAbbr='+fileAbbr+'&parent_file_id=<%=parent_file_id%>','800:680');
    }
    
	function dbclickRow(ids){
		popWindow('<%=contextPath%>/td/doc/workAcceptanceDoc/ws/add_tdDocModify.jsp?businessType='+businessType+'&id='+ids.split("-")[0]+'&parent_file_id=<%=parent_file_id%>','800:680');
	}
	
	function toEdit() {
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		var f_no=ids.split("-")[1];
		if(f_no =='1'){
			alert('年度项目文档不能修改!'); return;
		}
		popWindow('<%=contextPath%>/td/doc/workAcceptanceDoc/ws/add_tdDocModify.jsp?businessType='+businessType+'&id='+ids.split("-")[0]+'&parent_file_id=<%=parent_file_id%>','800:680');
	}
	
	function toDelete(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		var f_no=ids.split("-")[1];
		if(f_no =='1'){
			alert('年度项目文档不能修改!'); return;
		}
	    if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WsTecnicalBasicSrv", "deleteTdDoc", "ids="+ids.split("-")[0]);
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