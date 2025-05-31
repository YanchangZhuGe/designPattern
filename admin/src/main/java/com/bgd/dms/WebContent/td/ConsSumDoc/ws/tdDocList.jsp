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
	String fileAbbr = request.getParameter("fileAbbr");
	String ifPorject = request.getParameter("ifPorject");
	if(ifPorject==null || "".equals(ifPorject)){
		ifPorject ="2";
	}
	
	if(fileAbbr==null || "".equals(fileAbbr)){
		fileAbbr = resultMsg.getValue("fileAbbr");
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
<title>井中施工总结</title> 
</head> 
 
 <body style="background:#fff" onload="refreshData('');">
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
  				<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{tecnical_id}-{proc_status}-{project_info_no}-{project_name}' id='rdo_entity_id_{tecnical_id}'  onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{title}" width="200">标题</td>	
			      <td class="bt_info_even" exp="{written_time}">编写日期</td>
			      <td class="bt_info_odd" exp="{writer}">编写人</td>
			      <td class="bt_info_even" exp="{auditor}">审核人</td>
			      <td class="bt_info_even" exp="{proc_status_name_s}">确认状态</td> 
			      <td class="bt_info_odd" exp="{proc_status_name}">单据状态</td> 
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
									<td class="inquire_item6"><span class="red_star">*</span>标题：</td>
									<td class="inquire_form6" colspan="3">
									<input name="tecnical_id" id="tecnical_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>           
								     	<input name="doc_type" id="doc_type" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
								          <input name="i_sum" id="i_sum" class="input_width" value="0" type="hidden" readonly="readonly"/>
										<input type="text" id="title" name="title" value="" style="width:92%;height:24px;line-height: 24px;border:#a4b2c0 1px solid;background-color:#FFF;"/>
									</td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td class="inquire_item6">编写人：</td>
									<td class="inquire_form6"><input type="text" id="writer" name="writer" value="" class="input_width" /></td>
									<td class="inquire_item6">审核人：</td>
									<td class="inquire_form6"><input type="text" id="auditor" name="auditor" value="" class="input_width" /></td>
									<td class="inquire_item6">编写日期：</td>
									<td class="inquire_form6">
										<input type="text" id="written_time" name="written_time" value="" class="input_width" readonly="readonly"/>
							 
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(written_time,tributton1);" />
									 
									</td>
								</tr>
								<tr id="rec">
									<td class="inquire_item6">施工总结报告：</td>
									<td colspan="3">
					 
										<div id="down_0110000061100000013_0"></div>
									</td>
									<td></td>
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
	var businessType="5110000004100000086";
	var ifPorject='<%=ifPorject%>';
	
	function refreshData(str){
		
		if(ifPorject =='1'){
			cruConfig.queryStr = " select t.* from (select te.proc_status,decode(te.proc_status,'1','待审批','3','审批通过','4','审批不通过','未提交') proc_status_name,   t.status_type  proc_status_s,decode(t.status_type,'1','未确认','3','已确认','') proc_status_name_s,t.project_info_no,t.tecnical_id,t.title,t.written_time,t.writer,t.auditor,p.project_name from gp_ws_tecnical_basic t  left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag = '0'  left join common_busi_wf_middle te on te.business_id = t.tecnical_id and te.bsflag = '0' and te.business_type = '"+businessType+"'    where t.bsflag = '0'  and t.business_type = '"+businessType+"' "+str+"order by t.create_date desc) t where 1 = 1 ";
			queryData(1);
		}else if (ifPorject=='2'){
			cruConfig.queryStr = " select t.* from (select te.proc_status,decode(te.proc_status,'1','待审批','3','审批通过','4','审批不通过','未提交') proc_status_name,   t.status_type  proc_status_s,decode(t.status_type,'1','未确认','3','已确认','') proc_status_name_s,t.project_info_no,t.tecnical_id,t.title,t.written_time,t.writer,t.auditor,p.project_name from gp_ws_tecnical_basic t  left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag = '0' left join common_busi_wf_middle te on te.business_id = t.tecnical_id and te.bsflag = '0' and te.business_type = '"+businessType+"' where t.bsflag = '0' and t.project_info_no = '<%=projectInfoNo%>' and t.business_type = '"+businessType+"' "+str+"order by t.create_date desc) t where 1 = 1 ";
			queryData(1);
		}
		 
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSubmit(){
		ids = getSelectedValue();

		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
/* 		if(ids.split("-")[1] == '3'){
			alert("该申请单已提交!");
			return;
		} */
		if(ids.split("-")[1] == '1' || ids.split("-")[1] == '3'){
			alert("该申请单已提交!");
			return;
		}
		
		if (!window.confirm("确认要提交吗?")) {
			return;
		}		
	 	submitProcessInfo();
		  var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
			var submitStr = 'JCDP_TABLE_NAME=GP_WS_TECNICAL_BASIC&JCDP_TABLE_ID='+ids.split("-")[0] +'&status_type=3';
		    syncRequest('Post',paths,encodeURI(encodeURI(submitStr)));   
		    
	
		refreshData('');
	}

    function loadDataDetail(ids){ 
  	  		processNecessaryInfo={         
	    		businessTableName:"gp_ws_tecnical_basic",    //置入流程管控的业务表的主表表明
	    		businessType:businessType,        //业务类型 即为之前设置的业务大类
	    		businessId: ids.split("-")[0],         //业务主表主键值
	    		businessInfo:"施工总结文档审核",        //用于待审批界面展示业务信息
	    		applicantDate:'<%=appDate%>'       //流程发起时间
	  	}; 
	    	processAppendInfo={ 	    		 
   			 	id: ids.split("-")[0],	
   		 		projectInfoNo:ids.split("-")[2],
   		 		projectName:ids.split("-")[3],
   		 		action:"view" 		
	     	};   
	    loadProcessHistoryInfo();  
	    
	    // 4 清除上一条数据文档，起到刷新作用
		var inum=0;
		var isnum=document.getElementById("i_sum").value;
 
		  if(isnum!=null){
			  if(isnum==0){
				  document.getElementById('down_0110000061100000013_0').innerHTML="";
			  }else if (isnum==1){ 
				  document.getElementById('down_0110000061100000013_0').innerHTML="";
				  document.getElementById('down_0110000061100000013_1').innerHTML="";
			  }else  {
				  for(var j=0;j<isnum;j++){ 
					  document.getElementById('down_0110000061100000013_'+j).innerHTML="";
				  }
			  }
		  }
		  
		  
	    //deleteTableTr("hseTableInfo3"); 
	    var  fileId=ids.split("-")[0];
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
 
	   	 if(fileId!=''){
	 		var querySql = " select * from(select t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.doc_type,t.file_name,b.tecnical_id,b.title,b.written_unit,b.written_time,b.writer,b.auditor,b.leader from gp_ws_tecnical_basic b left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where m.tecnical_id ='"+fileId+"'";
	 		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	 		var datas = queryRet.datas; 
	 		if(datas!=null && datas.length>0){  
	 			
	 			document.getElementById("tecnical_id").value = datas[0].tecnical_id;
	 			document.getElementById("title").value = datas[0].title;
	 			document.getElementById("written_time").value = datas[0].written_time;
	 			document.getElementById("writer").value = datas[0].writer;
	 			document.getElementById("auditor").value = datas[0].auditor;
	 			document.getElementById("doc_type").value = datas[0].doc_type;
	 			 
	 		
	 			
	 			for(var i=0;i<datas.length;i++){ 	
	 				if(""!=datas[i].ucm_id){
	 					var ucmId=datas[i].ucm_id; 
	 					if(i>=1){  
	 						inum=datas.length; // 1
	 						addRow();
	 					} 
	 					  document.getElementById('down_0110000061100000013_'+i).innerHTML="";// 2 
	 					var str=datas[i].file_name==""?"":datas[i].file_name.substr(0,20)+'...   ';
	 					$("#down_0110000061100000013_"+i).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>"+str+"</a>");
	 					  
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
    	td.innerHTML=" <div id='down_0110000061100000013_"+num+"'></div>";
   
    	tr.insertCell(2).innerHTML="";
    	 
    }
    
    
    function toAdd(){
    	popWindow('<%=contextPath%>/td/ConsSumDoc/ws/add_tdDocModify.jsp?docType=0110000061100000007&businessType='+businessType+'&fileAbbr='+fileAbbr+'&parent_file_id=<%=parent_file_id%>','750:680');
    }
    
	function toEdit() {
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		if(ids.split("-")[1] == '1' || ids.split("-")[1] == '3'){
			alert("该申请单已提交不能修改!");
			return;
		}
		popWindow('<%=contextPath%>/td/ConsSumDoc/ws/add_tdDocModify.jsp?id='+ids.split("-")[0]+'&parent_file_id=<%=parent_file_id%>','750:680');
	}
	
	function toDelete(){
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if(ids.split("-")[1] == '1' || ids.split("-")[1] == '3'){
			alert("该申请单已提交不能删除!");
			return;
		}
	    var id =ids.split("-")[0];
	    if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WsTecnicalBasicSrv", "deleteTdDocJz", "ids="+id);
			queryData(cruConfig.currentPage);
		}
		refreshData('');
		
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