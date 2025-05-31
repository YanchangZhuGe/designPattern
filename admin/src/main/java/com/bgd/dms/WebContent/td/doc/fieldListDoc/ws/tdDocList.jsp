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
	String userName = (user==null)?"":user.getUserName();
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
	
	String businessType_s = request.getParameter("businessType_s");
	if(businessType_s==null || "".equals(businessType_s)){
		businessType_s = resultMsg.getValue("businessType_s");
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
  <title>野外资料清单</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData('')">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <% 
			  		  if(ifPorject.equals("2")){
			    %>
			  	<td class="ali_cdn_name">上交人</td>
			    <td class="ali_cdn_input"><input class="input_width" id="s_title_name" name="s_title_name" type="text"  /></td>
			    
			    			 <%
			   		 } else{
			   			 
			   			if(businessType.equals("0110000061100000024") ){
  				%> 
  				  	<td class="ali_cdn_name">是否处理解释</td>
			   	    <td class="ali_cdn_input"> 
			   	    <select name="s_title_name" id="s_title_name" class="select_width" >
				    <option value="">请选择</option>
				    <option value="yes">是</option>
				    <option value="no">否</option>
				    </select> 
			   	    
			   	    </td>
  				
  			    <%
			   			}else{	
			   			
			    %> 
			   	 	<td class="ali_cdn_name">上交人</td>
			    	<td class="ali_cdn_input"><input class="input_width" id="s_title_name" name="s_title_name" type="text"  /></td>
			   				
			     <%		
			   			}
			   			
			   		 }  
  				%> 
  				
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
 
  				<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
 
  				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
  				  				 <%
			   		 } else{
			   			 
			   			if(businessType.equals("0110000061100000024") ){
  				%> 
  				 <auth:ListButton functionId="" css="tj" event="onclick='toSubmitAdd()'" title="JCDP_btn_submit"></auth:ListButton>
  						 <%
			   			}
			   			
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id'  {disasss}  value='{tecnical_id},{proc_status},{project_info_no},{project_name},{test_type_s}' id='rdo_entity_id_{tecnical_id}'  />" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td>
			     <% 
			  		  if(ifPorject.equals("1")){
			    %>
			      <td class="bt_info_even"  exp="{project_name}">项目名称</td>	
			     <%
			   		 } 
  				%> 
  				
			      <td class="bt_info_odd" exp="<a style='color:blue;' href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>{file_name}</a>">资料清单名称</td>
			      <td class="bt_info_even"  exp="{written_unit}">接收单位</td>	
			      <td class="bt_info_odd" exp="{writer}">上交人</td>
			      <td class="bt_info_even" exp="{written_time}">上交时间</td>
			      <td class="bt_info_odd" exp="{auditor}">接收人</td>
 
			      <td class="bt_info_even" exp="{proc_status_name}">单据状态</td>	
 			     <% 
			  		  if(ifPorject.equals("1")){
			  			if(businessType.equals("0110000061100000024") ){
			    %>
			      <td class="bt_info_odd"  exp="{test_type_s}"> 是否处理解释</td>	
			     <%
			   		 	} 
			  		  }
  				%> 
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
 
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">审批流程</a></li>	  
 
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
			<table id="tableDoc" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
								<tr>
									<td class="inquire_item6">接收单位：</td>
									<td class="inquire_form6" colspan="3">
									<input name="tecnical_id" id="tecnical_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
							           			         <input name="i_sum" id="i_sum" class="input_width" value="0" type="hidden" readonly="readonly"/>
										<input type="text" id="written_unit" name="written_unit" value="" style="width:92%;height:24px;line-height: 24px;border:#a4b2c0 1px solid;background-color:#FFF;"/>
									</td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td class="inquire_item6">上交时间：</td>
									<td class="inquire_form6">
										<input type="text" id="written_time" name="written_time" value="" class="input_width" readonly="readonly"/>
									 
									</td>
									<td class="inquire_item6"><span class="red_star">*</span>上交人：</td>
									<td class="inquire_form6"><input type="text" id="writer" name="writer" value="" class="input_width"/></td>
									<td class="inquire_item6"><span class="red_star">*</span>接收人：</td>
									<td class="inquire_form6"><input type="text" id="auditor" name="auditor" value="" class="input_width"/></td>
								 
								</tr>
								<tr>
									<td class="inquire_item6">资料清单：</td>
									<td colspan="3">
 
										<div id="down_<%=businessType%>_0"></div>
									</td>
									<td></td>
									 
								</tr>
							</table>	
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>		
				</div>
 
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		
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
 
		if(businessType =="0110000061100000024" ){
	         var  querySql1 = "  select t.project_info_no, t.tecnical_id  from gp_ws_tecnical_basic t   left join common_busi_wf_middle te  on te.business_id = t.tecnical_id  and te.bsflag = '0'  and te.business_type = '5110000004100001084'  where t.bsflag = '0'  and t.business_type = '0110000061100000024'  and te.proc_status = '3' and t.test_type is null " ;
	         var  queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=6000&querySql='+encodeURI(encodeURI(querySql1)));
	        
		       	if(queryRet1.returnCode=='0'){
		       		var	  datas1 = queryRet1.datas;	 
		       		if(datas1 != null && datas1 != ''){	  
		    			var appearances="";
	    				var identifications="";
	    				var m_performances=""; 

	    				for(var i = 0; i<datas1.length; i++){	 
		       				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
		       				var submitStr = 'JCDP_TABLE_NAME=GP_WS_TECNICAL_BASIC&JCDP_TABLE_ID='+datas1[i].tecnical_id +'&test_type=yes';  
		       			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		

		       			}
		
		       		}
		       		
		       	}
		   
		  }
			
		
		if(ifPorject =='1'){ 
			cruConfig.queryStr ="select t.* from (select  case  when t.test_type='no'  then '' else 'disabled' end disasss, nvl(t.test_type,'no') test_type,t.test_type as test_type_s, te.proc_status,decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name,t.project_info_no,p.project_name,t.tecnical_id,t.title,t.written_unit,t.written_time,t.auditor,t.writer,f.ucm_id as ucm_id,f.file_name as file_name from gp_ws_tecnical_basic t left join (select * from bgp_doc_gms_file where ucm_id in(select max(ucm_id) from bgp_doc_gms_file where doc_file_type='<%=businessType%>' and bsflag='0' group by relation_id,doc_file_type))f on t.tecnical_id=f.relation_id      left join gp_task_project  p  on p.project_info_no=t.project_info_no and p.bsflag='0'   left join common_busi_wf_middle te on    te.business_id=t.tecnical_id  and te.bsflag='0' and te.business_type='<%=businessType_s%>'  where t.bsflag = '0'  and t.business_type = '<%=businessType%>'  order by te.proc_status asc, t.modifi_date desc) t"+str ;
			queryData(1);
		}else if (ifPorject=='2'){
			cruConfig.queryStr ="select t.* from (select '' disasss,nvl(t.test_type,'no') test_type, t.test_type  as test_type_s,te.proc_status,decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name, t.project_info_no,p.project_name,t.tecnical_id,t.title,t.written_unit,t.written_time,t.auditor,t.writer,f.ucm_id as ucm_id,f.file_name as file_name from gp_ws_tecnical_basic t left join (select * from bgp_doc_gms_file where ucm_id in(select max(ucm_id) from bgp_doc_gms_file where doc_file_type='<%=businessType%>' and bsflag='0' group by relation_id,doc_file_type))f on t.tecnical_id=f.relation_id     left join gp_task_project  p  on p.project_info_no=t.project_info_no and p.bsflag='0'   left join common_busi_wf_middle te on    te.business_id=t.tecnical_id   and te.bsflag='0' and te.business_type='<%=businessType_s%>'  where t.bsflag = '0' and t.project_info_no = '<%=projectInfoNo%>' and t.business_type = '<%=businessType%>'   order by te.proc_status asc,t.modifi_date desc) t  "+str;
			queryData(1);
		}
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");


    function loadDataDetail(ids){
    	
    	
    	  processNecessaryInfo={         
  	    		businessTableName:"gp_ws_tecnical_basic",    //置入流程管控的业务表的主表表明
  	    		businessType:"<%=businessType_s%>",        //业务类型 即为之前设置的业务大类
  	    		businessId: ids.split(",")[0],         //业务主表主键值
  	    		businessInfo:"上交清单审核",        //用于待审批界面展示业务信息
  	    		applicantDate:'<%=appDate%>'       //流程发起时间
  	    	}; 
  	    	processAppendInfo={ 	    		 
  	    				id: ids.split(",")[0], 
  						projectInfoNo:ids.split(",")[2],
  						projectName:ids.split(",")[3]  ,
  						fileAbbr:fileAbbr,
  						parent_file_id:"<%=parent_file_id%>",
  						businessType:businessType
  	     	};   
  	    loadProcessHistoryInfo();
  	    
    	 // 4 清除上一条数据文档，起到刷新作用
		var inum=0;
		var isnum=document.getElementById("i_sum").value;
 
		  if(isnum!=null){
			  if(isnum==0){
				  document.getElementById('down_<%=businessType%>_0').innerHTML="";
			  }else if (isnum==1){ 
				  document.getElementById('down_<%=businessType%>_0').innerHTML="";
				  document.getElementById('down_<%=businessType%>_1').innerHTML="";
			  }else  {
				  for(var j=0;j<isnum;j++){ 
					  document.getElementById('down_<%=businessType%>_'+j).innerHTML="";
				  }
			  }
		  }
		  
		  
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split(",")[0];
   	   var  fileId=ids.split(",")[0];
   	 if(fileId!='null'){
 		var querySql = " select * from(select t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.file_name,b.tecnical_id,b.title,b.writer,b.written_unit,b.written_time ,b.auditor from gp_ws_tecnical_basic b left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where m.tecnical_id ='"+fileId+"'";
 		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
 		var datas = queryRet.datas;
 		if(datas!=null && datas.length>0){
 			document.getElementById("tecnical_id").value = datas[0].tecnical_id;
 			document.getElementById("written_time").value = datas[0].written_time;
 			document.getElementById("writer").value = datas[0].writer;
 			document.getElementById("written_unit").value = datas[0].written_unit;
 			document.getElementById("auditor").value = datas[0].auditor;
 			var ii=-1;
 			var jj=-1;
 			for(var i=0;i<datas.length;i++){
 				if(""!=datas[i].ucm_id){
 					var ucmId=datas[i].ucm_id;
 					if(i>=1){
 						inum=datas.length; // 1
 						addRow();
 					}
 					  document.getElementById('down_<%=businessType%>_'+i).innerHTML="";// 2 
 					var str=datas[i].file_name==""?"":datas[i].file_name.substr(0,20)+'...';
 					$("#down_<%=businessType%>_"+i).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>"+str+"</a>");
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
    	td.innerHTML=" <div id='down_<%=businessType%>_"+num+"'></div>";
   
    	tr.insertCell(2).innerHTML="";
    	 
    }
    
    
	function toSubmit(){
		ids = getSelectedValue();
		var id=ids.split(",")[0];
		if (id == '') {
			alert("请选择一条记录!");
			return;
		}	
		if (!window.confirm("确认要提交吗?")) {
			return;
		}		
		submitProcessInfo(); 
		
		refreshData('');
	}
	function toSubmitAdd(){
		ids = getSelectedValue(); 
		var id=ids.split(",")[0];
		if (id == '') {
			alert("请选择一条记录!");
			return;
		}	
		var test_type=ids.split(",")[4];
		if(test_type=='no'){
			if (!window.confirm("确认要生成任务书吗?")) {
				return;
			}		 
		    	var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
				var submitStr = 'JCDP_TABLE_NAME=GP_WS_VSP_COMMITMENTS&JCDP_TABLE_ID=&tecnical_id='+id +'&project_info_no='+ids.split(",")[2]+'&bsflag=0&doc_type=0110000061200000001&create_date=<%=appDate%>&creator_id=<%=userName%>'; 
			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存处理解释任务书信息	
			   
				var submitStr_Z = 'JCDP_TABLE_NAME=GP_WS_TECNICAL_BASIC&JCDP_TABLE_ID='+id +'&test_type=yes';  
    			   syncRequest('Post',path,encodeURI(encodeURI(submitStr_Z)));  //保存主表信息	 
    			   
    				refreshData('');
		}else{
			alert('不可操作');
		}

	}
	
	
	
    function toAdd(){
    	popWindow('<%=contextPath%>/td/doc/fieldListDoc/ws/add_tdDocModify.jsp?businessType='+businessType+'&fileAbbr='+fileAbbr+'&parent_file_id=<%=parent_file_id%>&businessType_s=<%=businessType_s%>','800:680');
    }
	function dbclickRow(ids){
		popWindow('<%=contextPath%>/td/doc/fieldListDoc/ws/add_tdDocModify.jsp?businessType='+businessType+'&id='+ids.split(",")[0]+'&parent_file_id=<%=parent_file_id%>&businessType_s=<%=businessType_s%>','800:680');
	}
	
	function toEdit() {
		ids = getSelectedValue();
		var id=ids.split(",")[0];
		if (id == '') {
			alert("请选择一条记录!");
			return;
		}
		if(ids.split(",")[1] == '1' ){
			alert("该申请单待审批不可修改!");
			return;
		}
		if( ids.split(",")[1] == '3'){
			alert("该申请单申请通过不可修改!");
			return;
		}
		
		popWindow('<%=contextPath%>/td/doc/fieldListDoc/ws/add_tdDocModify.jsp?businessType='+businessType+'&id='+id+'&parent_file_id=<%=parent_file_id%>&businessType_s=<%=businessType_s%>','800:680');
	}
	
	function toDelete(){
		ids = getSelIds('rdo_entity_id');
		var id=ids.split(",")[0];
		if (id == '') {
			alert("请选择一条记录!");
			return;
		}	
		if(ids.split(",")[1] == '1' ){
			alert("该申请单待审批不可修改!");
			return;
		}
		if( ids.split(",")[1] == '3'){
			alert("该申请单申请通过不可修改!");
			return;
		}
	    if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WsTecnicalBasicSrv", "deleteTdDoc", "ids="+id);
			queryData(cruConfig.currentPage);
		}
		refreshData('');
	}
	

	// 简单查询
	function simpleSearch(){
		var title_name = document.getElementById("s_title_name").value;
		
		var str = " ";

		if(title_name!=''){
			if(ifPorject =='1'){ 
				if(businessType =="0110000061100000024" ){
					str += " where   t.test_type = '"+title_name+"' ";
				} else{
					
					str += " where   t.writer like '%"+title_name+"%' ";
				}
			}else{
				str += " where   t.writer like '%"+title_name+"%' ";
			}
		}
		refreshData(str);
	}
	
	function clearQueryText(){ 
		document.getElementById("s_title_name").value='';
	}
</script>
</html>