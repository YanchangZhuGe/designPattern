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
	String projectInfoNo = user.getProjectInfoNo();
	
	String fileAbbr = request.getParameter("fileAbbr");
	if(fileAbbr==null || "".equals(fileAbbr)){
		fileAbbr = resultMsg.getValue("fileAbbr");
	}
	
	String doc_type = request.getParameter("doc_type");
	if(doc_type==null || "".equals(doc_type)){
		doc_type = resultMsg.getValue("doc_type");
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
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<title>内部审核</title> 
</head> 
 
 <body style="background:#fff" onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  
			    	<td class="ali_cdn_name">项目名称</td>
			    <td  width="20%" > <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
    			<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text"   />   
    			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>   </td>
			  	<td class="ali_cdn_name">任务状态</td>
			    <td class="ali_cdn_input"><select name="s_proc_status" id="s_proc_status" class="select_width" >
			    <option value="">请选择</option>
			    <option value="0">未上传</option>
			    <option value="1">已上传</option>
			    </select></td>
			    <td class="ali_cdn_name">年度</td>
			    <td class="ali_cdn_input"><select name="s_proc_year" id="s_proc_year" class="select_width" >
			    <option value="">请选择</option>
			    <option value="2012">2012</option>
			   	    <option value="2013">2013</option>
			   	    	    <option value="2014">2014</option>
			   	    	    	    <option value="2015">2015</option>
			   	    	    	    	    <option value="2016">2016</option>
			   	    	    	    	    	    <option value="2017">2017</option>
			   	    	    	    	    	    	    <option value="2018">2018</option>
			   	    	    	    	    	    	    	    <option value="2019">2019</option>
			   	    	    	    	    	    	    	    	    <option value="2020">2020</option>
			   	    	    	    	    	    	    	    	    	    <option value="2021">2021</option>
			   	    	    	    	    	    	    	    	    	    	    <option value="2022">2022</option>
			   	    	    	    	    	    	    	    	    	    	    	    <option value="2023">2023</option>
			   	    	    	    	    	    	    	    	    	    	    	     <option value="2024">2024</option>
			   	    	    	    	    	    	    	    	    	    	    	      <option value="2025">2025</option>
			   	    	    	    	    	    	    	    	    	    	    	    
			    </select></td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			  	<auth:ListButton functionId="" css="xg" event="onclick='toAdd()'" title="JCDP_btn_edit"></auth:ListButton>	  
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{audit_id}-{upload_status}-{project_info_no}-{ucm_id}-{optioning_type}' id='rdo_entity_id_{audit_id}'  onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}" width="200">项目名称</td>	
			      <td class="bt_info_even" exp="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>{file_name}</a>">成果报告</td>
			      <td class="bt_info_odd" exp="{the_heir}">上传人</td>
			      <td class="bt_info_even" exp="{upload_time}">上传时间</td>
			      <td class="bt_info_odd" exp="{upload_status_name}">上传状态</td> 
 
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
 					<table id="tableDoc" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4">文档编号：</td>
									<td class="inquire_form4">
							             <input name="audit_id" id="audit_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="doc_type" id="doc_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>          
							           	<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/> 
							        	 <input name="i_sum" id="i_sum" class="input_width" value="0" type="hidden" readonly="readonly"/>
										<input  name="ucm_id_a" id="ucm_id_a" class="input_width" value="自动生成" type="text" readonly="readonly"/>
									</td>
									<td class="inquire_item4">项目名称：</td>
									<td class="inquire_form4"> <input name="project_name" id="project_name" class="input_width" value="" type="text" readonly="readonly"/></td> 
				 
								</tr>
								<tr>
									<td class="inquire_item4">上传人：</td>
									<td class="inquire_form4"><input type="text" id="the_heir" name="the_heir" value=" " class="input_width" /></td>
									<td class="inquire_item4">上传时间：</td>
									<td class="inquire_form4"> 
										<input type="text" id="upload_time" name="upload_time" value=" " class="input_width" readonly="readonly"/> 
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(upload_time,tributton1);" />
								 
									</td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>成果报告：</td>
									<td colspan="3"> 
									 <% 
							  		  if(doc_type.equals("0110000061200000003")){
							    %>
				  			 	<div id="down_0110000061200000003_0"></div>
				  			   <%
							   		 } else{
				  				%> 
				  						<div id="down_0110000061200000008_0"></div>
				  				 <%
							   		 }  
				  				%> 
  				
									
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
	var sub_doc_type='<%=doc_type%>';
	var cstatus_type="";
 
	 if(sub_doc_type == "0110000061200000003"){
		 cstatus_type="0110000061200000002";		  
	 }else{
		 cstatus_type="0110000061200000007";		 
	 }
	
	function refreshData(str){
		
		 var querySql1="";
         var queryRet1=null;
         var datas1 =null;
         querySql1 = "  select t.project_info_no, t.cstatus_id,t.table_type optioning_type   from GP_WS_VSP_CSTATUS t where t.bsflag = '0'   and t.doc_type = '"+cstatus_type+"'   and t.process_state='3'   and t.explain_state='3'   and t.cstatus_id not in       (select vc.cstatus_id    from GP_WS_VSP_AUDIT vc         where vc.bsflag = '0'  and vc.doc_type= '<%=doc_type%>' ) " ;
         queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=6000&querySql='+encodeURI(encodeURI(querySql1)));
        
	       	if(queryRet1.returnCode=='0'){
	       	  datas1 = queryRet1.datas;	 
	       		if(datas1 != null && datas1 != ''){	  
	    			var appearances="";
    				var identifications="";
    				var m_performances=""; 

    				for(var i = 0; i<datas1.length; i++){	 
	       				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
	       				var submitStr = 'JCDP_TABLE_NAME=GP_WS_VSP_AUDIT&JCDP_TABLE_ID=&cstatus_id='+datas1[i].cstatus_id +'&project_info_no='+datas1[i].project_info_no+'&bsflag=0&doc_type=<%=doc_type%>&upload_status=0&create_date=<%=appDate%>&creator_id=<%=userName%>&table_type='+datas1[i].optioning_type; 
	       			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		

	       			}
	
	       		}
	       		
	       	}
	       	
			cruConfig.queryStr = "  select t.*   from (select t.table_type optioning_type,t.project_info_no, to_char( t.upload_time,'yyyy') year_s, p.project_name,decode( t.upload_status,'0','未上传','1','已上传',  t.upload_status) upload_status_name,    t.audit_id,t.the_heir,t.upload_time, nvl(t.upload_status,0)upload_status,    f.ucm_id          as ucm_id,     f.file_name       as file_name ,t.modifi_date       from GP_WS_VSP_AUDIT t       left join (      select *     from bgp_doc_gms_file    where ucm_id in     (select max(ucm_id)     from bgp_doc_gms_file  where doc_file_type = '<%=doc_type%>'    and bsflag = '0'    group by relation_id, doc_file_type)   ) f    on t.audit_id = f.relation_id              left join ( select p.project_info_no ,p.project_name  from  gp_task_project p  where p.bsflag='0'          union all         select  pt.ws_detail_no as project_info_no,pt.project_name    from  GP_WS_PROJECT_DETAIL pt where pt.bsflag='0' ) p  on p.project_info_no = t.project_info_no  where t.bsflag = '0'   and t.doc_type = '<%=doc_type%>'    order by  t.modifi_date desc,t.upload_status  asc ) t  ";
			cruConfig.currentPageUrl = "/td/vspExplain/vspAudit/auditList.jsp";
			queryData(1);
			
		 
	}
	//选择项目
	function selectTeam(){

	    var result = window.showModalDialog('<%=contextPath%>/td/vspExplain/vdzCommitments/searchJzProjectList.jsp','');
	    if(result!=""){
	    	var checkStr = result.split("-");	
		        document.getElementById("s_project_info_no").value = checkStr[0];
		        document.getElementById("s_project_name").value = checkStr[1];
	    }
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	 

    function loadDataDetail(ids){ 
  	  	 
	    // 4 清除上一条数据文档，起到刷新作用
		var inum=0;
		var isnum=document.getElementById("i_sum").value;
 
		  if(isnum!=null){
			  if(isnum==0){
				  document.getElementById('down_<%=doc_type%>_0').innerHTML="";
			  }else if (isnum==1){ 
				  document.getElementById('down_<%=doc_type%>_0').innerHTML="";
				  document.getElementById('down_<%=doc_type%>_1').innerHTML="";
			  }else  {
				  for(var j=0;j<isnum;j++){ 
					  document.getElementById('down_<%=doc_type%>_'+j).innerHTML="";
				  }
			  }
		  }
		  
		  
	    //deleteTableTr("hseTableInfo3"); 
	    var  fileId=ids.split("-")[0];
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
 
	   	 if(fileId!=''){
	 		var querySql = "select t.*   from (select t.project_info_no,t.doc_type, p.project_name,decode( t.upload_status,'0','未上传','1','已上传',  t.upload_status) upload_status_name,    t.audit_id,t.the_heir,t.upload_time, nvl(t.upload_status,0)upload_status,    f.ucm_id  ,     f.file_name, f.file_id,f.file_abbr       from GP_WS_VSP_AUDIT t       left join bgp_doc_gms_file f   on t.audit_id = f.relation_id   and f.bsflag='0'      left join ( select p.project_info_no ,p.project_name  from  gp_task_project p  where p.bsflag='0'          union all         select  pt.ws_detail_no as project_info_no,pt.project_name    from  GP_WS_PROJECT_DETAIL pt where pt.bsflag='0' ) p  on p.project_info_no = t.project_info_no  where t.bsflag = '0'   and t.doc_type = '<%=doc_type%>' and t.audit_id='"+fileId+"'   ) t ";
	 		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
	 		var datas = queryRet.datas; 
	 		if(datas!=null && datas.length>0){  
 
				   document.getElementById("project_name").value = datas[0].project_name; 
					document.getElementById("ucm_id_a").value = datas[0].ucm_id;
					document.getElementById("the_heir").value = datas[0].the_heir;
					document.getElementById("upload_time").value = datas[0].upload_time;
			 
	 			
	 			for(var i=0;i<datas.length;i++){ 	
	 				if(""!=datas[i].ucm_id){
	 					var ucmId=datas[i].ucm_id; 
	 					if(i>=1){  
	 						inum=datas.length; // 1
	 						addRow();
	 					} 
	 					  document.getElementById('down_<%=doc_type%>_'+i).innerHTML="";// 2 
	 					var str=datas[i].file_name==""?"":datas[i].file_name.substr(0,50)+'...   ';
	 					$("#down_<%=doc_type%>_"+i).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>"+str+"</a>");
	 					  
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
    	td.innerHTML=" <div id='down_<%=doc_type%>_"+num+"'></div>";
 
    	 
    }
    
 
    function toAdd(){
    	ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
	    var parent_file_id="";
	    
	    var optioning_type =ids.split("-")[4];
 		if(optioning_type =='jz'){
 			parent_file_id ="01A8DE665EA27111111111111111101";
 			fileAbbr = "JZVSPPROJECT"; 
 		}else{
 			 var querySql ="select * from bgp_doc_gms_file f where f.bsflag='0' and is_file='0' and f.project_info_no='"+ids.split("-")[2]+"' and f.file_abbr='"+fileAbbr+"'";
 			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
 			var datas = queryRet.datas;
 			if(datas!=null && datas.length>0){
 				parent_file_id = datas[0].file_id; 
 			}  
 		}
	   
		
    	popWindow('<%=contextPath%>/td/vspExplain/vspAudit/add_audit.jsp?docType=<%=doc_type%>&fileAbbr='+fileAbbr+'&parent_file_id='+parent_file_id+'&id='+ids.split("-")[0]+'&p_type='+ids.split("-")[1],'800:680');
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
		
		var s_project_info_no = document.getElementById("s_project_name").value;
		var s_proc_status = document.getElementById("s_proc_status").value;
		var s_proc_year = document.getElementById("s_proc_year").value;
		
		var str = " 1=1 ";
		
		if(s_project_info_no!=''){			
			str += " and project_name like '%"+s_project_info_no+"%' ";						
		}	
		if(s_proc_status!=''){		
			str += " and upload_status = '"+s_proc_status+"' ";				
		}
		if(s_proc_year!=''){			
			str += " and year_s = '"+s_proc_year+"' ";						
		}
		
		cruConfig.cdtStr = str;
		refreshData();
	}
	
	
	
	function clearQueryText(){ 
		document.getElementById("s_project_info_no").value="";
		document.getElementById("s_project_name").value="";
		document.getElementById("s_proc_status").value="";
		document.getElementById("s_proc_year").value="";
		
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