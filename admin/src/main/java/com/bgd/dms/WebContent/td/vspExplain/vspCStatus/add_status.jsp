<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = (user==null)?"":user.getEmpId();
	String userName = (user==null)?"":user.getUserName();
	String projectInfoNo = user.getProjectInfoNo();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());
	
	String businessType = request.getParameter("docType")==null?"":request.getParameter("docType");
	String parent_file_id = request.getParameter("parent_file_id")==null?"":request.getParameter("parent_file_id");
	String id = request.getParameter("id")==null?"":request.getParameter("id");
	String fileAbbr = request.getParameter("fileAbbr")==null?"":request.getParameter("fileAbbr");
	String p_type = request.getParameter("p_type")==null?"":request.getParameter("p_type");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

</head>
<body onload="page_init();">
<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
    <div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	 <tr>
 	       <td class="inquire_item6">项目名称：</td>
           <td class="inquire_form6"> 
            <input name="cstatus_id" id="cstatus_id" class="input_width" value="" type="hidden" readonly="readonly"/>
			<input name="doc_type" id="doc_type" class="input_width" value="" type="hidden" readonly="readonly"/>
            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
	        <input name="project_info_no" id="project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>           
           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>          
           	<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/> 
           	<input name="parent_file_id" id="parent_file_id" class="input_width" value="<%=parent_file_id%>" type="hidden" readonly="readonly"/>
			 <input name="project_name" id="project_name" class="input_width" style="width:250px;height:19px" value="" type="text" readonly="readonly"/>
           </td>
           <td class="inquire_item6">采集资料上交清单：</td>
           <td  colspan="3" >
            <% 
			  		  if(businessType.equals("0110000061200000002")){
			    %>
  			    				
  			   <div id="down_0110000061100000024"></div>
  			   <%
			   		 } else{
  				%> 
  					   <div id="down_0110000061100000124"></div>
  				 <%
			   		 }  
  				%> 

           </td>
 
	    </tr>	 
 	   <tr>
 	       <td class="inquire_item6">处理解释任务书：</td>
           <td class="inquire_form6"> 
 
           			  <% 
			  		  if(businessType.equals("0110000061200000002")){
			    %>
  			    				
  			        <div id="down_0110000061200000001"></div>
  			   <%
			   		 } else{
  				%> 
  					    <div id="down_0110000061200000006"></div>
  				 <%
			   		 }  
  				%> 
           </td>
           <td class="inquire_item6">下达人：</td>
           <td class="inquire_form6"> 
                 <input name="give_people " id="give_people" class="input_width"  style="height:19px" value="" type="text" readonly="readonly"/>
           </td>
           <td class="inquire_item6">下达时间：</td>
           <td class="inquire_form6"> 
                <input name="give_time" id="give_time" class="input_width" value=""  style="height:19px" type="text" readonly="readonly"/>
           </td>
	    </tr>	      
	     
	      <tr>	
			 <td colspan="3" align="center">
			 	<table width="80%"    cellspacing="0" cellpadding="0"  align="left"  border="0" style=" border:1px solid #000000;"    >

					  <tr >
					    <td  >处理人员：</td>
					    <td  >    <input name="todeal_people" id="todeal_people" class="input_width" value="" type="text" readonly="readonly"/></td>
					  </tr>
					    <tr>
					    <td  >处理计划开始时间：</td>
					    <td >    <input name="t_start_time" id="t_start_time" class="input_width" value="" type="text" readonly="readonly"/></td>
					  </tr>
					    <tr>
					    <td  >处理计划完成时间：</td>
					    <td  >    <input name="t_end_time" id="t_end_time" class="input_width" value="" type="text" readonly="readonly"/></td>
					  </tr>
					  			 		  <% 
			  		  if(businessType.equals("0110000061200000002")){
			    %>
					   <tr>
					    <td align="left" >	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;处理环节：</td>
					    <td > </td>
					  </tr>
					   <tr>
					    <td  align="left">
							<input type="hidden" id="process_steps" name="process_steps" value=""/>
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected" value="1">预处理</input>
						</td>
					    <td  align="left"> 
					    <input type="checkbox"  name="selected" value="2">波场分离</input>
					    </td>
					  </tr>
					  <tr>
					    <td   align="left"> 
				      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	<input type="checkbox"  name="selected" value="3">激发点静校正</input> 
						</td>
					    <td   align="left"> 
					    <input type="checkbox"  name="selected" value="4"> 反褶积</input>
					    </td>
					  </tr>
					   <tr>
					    <td  align="left">
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected" value="5">初至拾取、计算速度</input> 
						</td>
					    <td  align="left">
					    <input type="checkbox"  name="selected" value="6">  上行波拉平</input>;
					    </td>
					  </tr>
					     <tr>
					    <td  align="left">
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected" value="7">  水平分量旋转</input> 
						</td>
					    <td  align="left">
					    <input type="checkbox"  name="selected" value="8">  走廊切除、叠加、VSP成像</input> 
					    </td>
					  </tr>
					    <tr>
					    <td  align="left"> 
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected" value="9">  三分量旋转</input> 
						</td>
					    <td  align="left"> 
					    <input type="checkbox"  name="selected" value="10">   振幅补偿</input> 
					    </td>
					  </tr>
					  	 <tr>
					    <td align="right">
				      	  <input type="checkbox"  name="selected" value="11"> </input> 
						</td>
					    <td  align="left"> <input name="process_input" id="process_input" class="input_width" value="" type="text" /> 
	 				    </td>
					  </tr>
					   <tr>
					    <td >
				      	<span class="red_star">*</span>  处理状态：
						</td>
					    <td> 
					    <select name="process_state" id="process_state" class="input_width" >
						    <option value="1">未进行</option>
						    <option value="2">进行中</option>
						    <option value="3">已完成</option>
						</select>
			    
	 				    </td>
					  </tr>
					    <tr>
					    <td >
				      	相关文档：
				   	   <input name="checkout_status_0" id="checkout_status_0" class="input_width" value="0" type="hidden" /> 
						</td>
					    <td > 
					      <input type="hidden" id="pk_0110000061200000002_0" name="pk_0110000061200000002_0" value=""/>
						  <input type="file" name="0110000061200000002_0" id="0110000061200000002_0" class="input_width"/>
			  		
	 				    </td>
					  </tr>
					  	 <tr>
					    <td align="center" colspan="3" >
				     <div id="down_0110000061200000002_0"></div>
						</td>
					  
					  </tr>
				   <%
			   		 } else{
  				%> 
  				<tr>
					    <td >
				      	<span class="red_star">*</span>  处理状态：
						</td>
					    <td> 
					    <select name="process_state" id="process_state" class="input_width" >
						    <option value="1">未进行</option>
						    <option value="2">进行中</option>
						    <option value="3">已完成</option>
						</select>
			    
	 				    </td>
					  </tr>
  				 <tr>
					    <td >
				      	相关文档：
				   	   <input name="checkout_status_0" id="checkout_status_0" class="input_width" value="0" type="hidden" /> 
						</td>
					    <td > 
					      <input type="hidden" id="pk_0110000061200000002_2" name="pk_0110000061200000002_2" value=""/>
						  <input type="file" name="0110000061200000002_2" id="0110000061200000002_2" class="input_width"/>
			  		
	 				    </td>
					  </tr>
					  	 <tr>
					    <td align="center" colspan="3" >
				     <div id="down_0110000061200000002_2"></div>
						</td>
					  
					  </tr>
			  <%
			   		 }  
  				%> 
					</table>
 
					
			</td>
		  <td colspan="3" align="center"> 
		  	<table width="95%"    cellspacing="0" cellpadding="0"  align="left"  border="0" style=" border:1px solid #000000;"    >

					  <tr >
					    <td  >解释人员：</td>
					    <td  >    <input name="explain_people" id="explain_people" class="input_width" value="" type="text" readonly="readonly"/></td>
					  </tr>
					    <tr>
					    <td  >解释计划开始时间：</td>
					    <td >    <input name="e_start_time" id="e_start_time" class="input_width" value="" type="text" readonly="readonly"/></td>
					  </tr>
					    <tr>
					    <td  >解释计划完成时间：</td>
					    <td  >    <input name="e_end_time" id="e_end_time" class="input_width" value="" type="text" readonly="readonly"/></td>
					  </tr>
					  		  				 		  <% 
			  		  if(businessType.equals("0110000061200000002")){
			    %>
					   <tr>
					    <td align="left" >	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;解释环节：</td>
					    <td > </td>
					  </tr> 
					   <tr>
					    <td  align="left">
							<input type="hidden" id="explain_steps" name="explain_steps" value=""/>
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected_a" value="1">速度计算</input>
						</td>
					    <td  align="left"> 
					    <input type="checkbox"  name="selected_a" value="2">储层精细标定</input>
					    </td>
					  </tr>
					  <tr>
					    <td   align="left"> 
				      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	<input type="checkbox"  name="selected_a" value="3"> 速度对比</input> 
						</td>
					    <td   align="left"> 
					    <input type="checkbox"  name="selected_a" value="4"> 储层预测</input>
					    </td>
					  </tr>
					   <tr>
					    <td  align="left">
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected_a" value="5">  层位标定</input> 
						</td>
					    <td  align="left">
					    <input type="checkbox"  name="selected_a" value="6">   地震资料解释成图</input>;
					    </td>
					  </tr>
					     <tr>
					    <td  align="left">
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected_a" value="7"> 联合标定</input> 
						</td>
					    <td  align="left">
 
					    </td>
					  </tr>
					     
					  	 <tr>
					    <td align="right">
				      	  <input type="checkbox"  name="selected_a" value="8"> </input> 
						</td>
					    <td  align="left"> <input name="explain_input" id="explain_input" class="input_width" value="" type="text" /> 
	 				    </td>
					  </tr>
					   <tr>
					    <td >
				      	  <span class="red_star">*</span>解释状态：
						</td>
					    <td> 
					    <select name="explain_state" id="explain_state" class="input_width" >
						    <option value="1">未进行</option>
						    <option value="2">进行中</option>
						    <option value="3">已完成</option>
						</select>
			    
	 				    </td>
					  </tr>
					    <tr>
					    <td >
				      	相关文档：
				      	   <input name="checkout_status_1" id="checkout_status_1" class="input_width" value="1" type="hidden" /> 
						</td>
					    <td > 
					      <input type="hidden" id="pk_0110000061200000002_1" name="pk_0110000061200000002_1" value=""/>
						  <input type="file" name="0110000061200000002_1" id="0110000061200000002_1" class="input_width"/>
					      		
	 				    </td>
					  </tr>
					  	 <tr>
					    <td align="center" colspan="3" >
				     <div id="down_0110000061200000002_1"></div>
						</td>
					  
					  </tr>
					  		   <tr>
					    <td align="center" colspan="3" >
				     
						</td>
					  
					  </tr>
			  <%
			   		 } else{
  				%> 
  				  <tr>
					    <td >
				      	  <span class="red_star">*</span>解释状态：
						</td>
					    <td> 
					    <select name="explain_state" id="explain_state" class="input_width" >
						    <option value="1">未进行</option>
						    <option value="2">进行中</option>
						    <option value="3">已完成</option>
						</select>
			    
	 				    </td>
					  </tr>
					    <tr>
					    <td >
				      	相关文档：
				      	   <input name="checkout_status_1" id="checkout_status_1" class="input_width" value="1" type="hidden" /> 
						</td>
					    <td > 
					      <input type="hidden" id="pk_0110000061200000002_3" name="pk_0110000061200000002_3" value=""/>
						  <input type="file" name="0110000061200000002_3" id="0110000061200000002_3" class="input_width"/>
					      		
	 				    </td>
					  </tr>
					  	 <tr>
					    <td align="center" colspan="3" >
				     <div id="down_0110000061200000002_3"></div>
						</td>
					  
					  </tr>
					  		 
					  		 <%
			   		 }  
  				%> 
			
					</table>
			</td>
	  </tr>	 
				 
 	</table>
	</div>  

    <div id="oper_div">
		<span class="tj_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</form>
</body>


<!--Remark JavaScript定义-->
<script language="javaScript">
var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['comm_coding_sort_deatil']
);
var defaultTableName = 'comm_coding_sort_deatil';
/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
   4最大输入长度，
   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
           其他默认值
   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
   9 Column Name，10 Event,11 Table Name
*/
	
cruConfig.contextPath =  "<%=contextPath%>";
var p_type="<%=p_type%>";
var sub_doc_type='<%=businessType%>';
var commitments_type="";
var doc_listType="";
var a_typs="";
var b_typs="";
 if(sub_doc_type == "0110000061200000002"){
	 commitments_type="0110000061200000001";
	 doc_listType="0110000061100000024";
	  a_typs="0110000061200000002_0";
	  b_typs="0110000061200000002_1";
		
 }else{
	 commitments_type="0110000061200000006";
	 doc_listType="0110000061100000124";
	  a_typs="0110000061200000002_2";
	  b_typs="0110000061200000002_3";
 }

function page_init(){

	var fileId = '<%=request.getParameter("id")%>';	
	var fileAbbr = '<%=request.getParameter("fileAbbr")%>';	
	
	if(fileId!='null'){
		var querySql = "  select t.* from ( select sc.cstatus_id,sc.doc_type,wt.file_id file_id_b,wt.checkout_status,wt.ucm_id ucm_id_b,wt.file_abbr file_abbr_b, wt.file_name file_name_b, sc.process_steps,sc.process_input,sc.explain_steps,sc.explain_input,sc.process_state, sc.explain_state, decode(sc.process_state,'1','未进行','2','进行中','3','已完成',sc.process_state)process_state_name ,decode(sc.explain_state,'1','未进行','2','进行中','3','已完成',sc.explain_state)explain_state_name , t.commitments_id,  to_char( t.give_time,'yyyy') year_s,t.project_info_no,  p.project_name,  t.tecnical_id,decode(t.status_type,   '1',   '未下达',  '2',  '已下达', t.status_type) proc_status_name,  t.give_people,t.outsourcing,t.todeal_people,t.todeal_people_s,t.t_start_time,t.t_end_time,t.explain_people,t.explain_people_s,t.e_start_time,t.e_end_time,t.give_time,nvl(t.status_type,0)status_type ,  f.ucm_id as ucm_id,  f.file_name as file_name,  f2.ucm_id as ucm_id_a,  f2.file_name as file_name_a   from  GP_WS_VSP_CSTATUS sc   left join  GP_WS_VSP_COMMITMENTS t on t.commitments_id=sc.commitments_id and t.bsflag='0'   left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '"+doc_listType+"'  and bsflag = '0'  group by relation_id,  doc_file_type)) f  on t.tecnical_id = f.relation_id   left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '"+commitments_type+"'  and bsflag = '0'  group by relation_id,  doc_file_type)) f2  on t.commitments_id = f2.relation_id     left join ( select p.project_info_no ,p.project_name  from  gp_task_project p  where p.bsflag='0'          union all         select  pt.ws_detail_no as project_info_no,pt.project_name    from  GP_WS_PROJECT_DETAIL pt where pt.bsflag='0' ) p  on p.project_info_no = t.project_info_no   left join bgp_doc_gms_file wt   on sc.cstatus_id = wt.relation_id     and wt.bsflag = '0'  where sc.bsflag = '0'    and sc.doc_type = '<%=businessType%>' and sc.cstatus_id='"+fileId+"'  ) t  ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas!=null && datas.length>0){
			 //公共
			document.getElementById("cstatus_id").value = datas[0].cstatus_id;
			document.getElementById("doc_type").value = datas[0].doc_type;
			document.getElementById("business_type").value = "<%=businessType%>"; 
			document.getElementById("project_name").value = datas[0].project_name;
			document.getElementById("project_info_no").value = datas[0].project_info_no;
			document.getElementById("file_abbr").value = "<%=fileAbbr%>";
			document.getElementById("parent_file_id").value = "<%=parent_file_id%>";
  
			var str=datas[0].file_name==""?"":datas[0].file_name.substr(0,50)+'...';
			$("#down_"+doc_listType).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+datas[0].ucm_id+"&emflag=0>"+str+"</a>");
			if(datas[0].ucm_id_a!=""){ 
					var str_a=datas[0].file_name_a==""?"":datas[0].file_name_a.substr(0,50)+'...';
					$("#down_"+commitments_type).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+datas[0].ucm_id_a+"&emflag=0>"+str_a+"</a>");
		  		 }
			
			document.getElementById("give_people").value = datas[0].give_people;
			document.getElementById("give_time").value = datas[0].give_time;
			document.getElementById("todeal_people").value = datas[0].todeal_people;
			document.getElementById("explain_people").value = datas[0].explain_people;
			document.getElementById("t_start_time").value = datas[0].t_start_time;
			document.getElementById("t_end_time").value = datas[0].t_end_time;
			document.getElementById("e_start_time").value = datas[0].e_start_time;
			document.getElementById("e_end_time").value = datas[0].e_end_time;
			
		 	 if(sub_doc_type == "0110000061200000002"){
					var process_steps = datas[0].process_steps;
					var selected = document.getElementsByName("selected"); 
					var temp = process_steps.split(",");
					for(var i=0;i<temp.length;i++){
						for(var j=0;j<selected.length;j++){
							if(temp[i]==selected[j].value){
								selected[j].checked = true;
							}
						}
					} 
					document.getElementById("process_steps").value = process_steps;
					
					var explain_steps = datas[0].explain_steps;
					var selected_a = document.getElementsByName("selected_a"); 
					var temp_a = explain_steps.split(",");
					for(var a=0;a<temp_a.length;a++){
						for(var b=0;b<selected_a.length;b++){
							if(temp_a[a]==selected_a[b].value){
								selected_a[b].checked = true;
							}
						}
					} 
					document.getElementById("explain_steps").value = explain_steps;
					
					document.getElementById("process_input").value =  datas[0].process_input;
					document.getElementById("explain_input").value =  datas[0].explain_input;
		 	 }
			document.getElementById("process_state").value = datas[0].process_state;
			document.getElementById("explain_state").value = datas[0].explain_state;
			 
			
			for(var c=0;c<datas.length;c++){
				if(""!=datas[c].ucm_id_b){
					var checkout_status=datas[c].checkout_status;
					if(checkout_status =="0"){
						var ucmId_b=datas[c].ucm_id_b; 
						document.getElementById("pk_"+a_typs).value =ucmId_b;
						var str_b=datas[c].file_name_b==""?"":datas[c].file_name_b.substr(0,20)+'...';
						$("#down_"+a_typs).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId_b+"&emflag=0>"+str_b+"</a>");
					}else{
						var ucmId_c=datas[c].ucm_id_b; 
						document.getElementById("pk_"+b_typs).value =ucmId_c;
						var str_c=datas[c].file_name_b==""?"":datas[c].file_name_b.substr(0,20)+'...';
						$("#down_"+b_typs).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId_c+"&emflag=0>"+str_c+"</a>");
						
					}
					
				}
			}
			
			
		}
						
	} 
		
}
 


function save(){
	 
	
	 if (!checkForm()) return;
	 if(sub_doc_type == "0110000061200000002"){
			var pInput=document.getElementsByName("selected");
			var p_input=document.getElementById("process_input").value;
		    if(pInput[10].checked){
		    	if(p_input==""){ 
		    		alert('请填写处理环节文本');return;
		    	}
		    	
		    } 
		 
			var eInput=document.getElementsByName("selected_a");
			var e_input=document.getElementById("explain_input").value;
		    if(eInput[7].checked){
		    	if(e_input==""){ 
		    	alert('请填写解释环节文本');return;
		    	}
		    } 
		    
			var process_steps = "";
			var selected = document.getElementsByName("selected");
			for(var i=0; i<selected.length;i++){
				if(selected[i].checked){
					if(process_steps!="") process_steps += ",";
					process_steps +=selected[i].value;
				}
			}
			document.getElementById("process_steps").value = process_steps ;
			
			var explain_steps = "";
			var selected_a = document.getElementsByName("selected_a");
			for(var a=0; a<selected_a.length;a++){
				if(selected_a[a].checked){
					if(explain_steps!="") explain_steps += ",";
					explain_steps +=selected_a[a].value;
				}
			}
			document.getElementById("explain_steps").value = explain_steps ;
	 }	
			
 
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/td/ws/toSaveVspStatus.srq?businessType=<%=businessType%>";
		form.submit();
		newClose();
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

function checkForm(){
	if(!notNullForCheck("process_state","处理状态")) return false;
	if(!notNullForCheck("explain_state","解释状态")) return false;
 
	return true;
}



</script>

</html>
