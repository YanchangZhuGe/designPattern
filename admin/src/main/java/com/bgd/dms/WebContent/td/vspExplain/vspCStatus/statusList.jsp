<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory,com.bgp.gms.service.td.srv.TdDocServiceSrv"%> 

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

  <title>处理解释任务书</title> 
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
			    <option value="1">未完成</option>
			    <option value="2">已完成</option>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{cstatus_id}-{process_state}-{project_info_no}-{ucm_id}-{optioning_type}' id='rdo_entity_id_{cstatus_id}' onclick='chooseOne(this);' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id}&emflag=0>{file_name}</a>">采集资料上交清单 </td>	
			      <td class="bt_info_odd" exp="<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId={ucm_id_a}&emflag=0>{file_name_a}</a>">处理解释任务书</td>
			      <td class="bt_info_even" exp="{give_people}">下达人</td>		
			      <td class="bt_info_odd" exp="{give_time}">下达时间</td>
			      <td class="bt_info_even" exp="{todeal_people}">处理人员</td>
			      <td class="bt_info_odd" exp="{process_state_name}">处理状态</td>
			      <td class="bt_info_even" exp="{explain_people}">解释人员</td>
			      <td class="bt_info_odd" exp="{explain_state_name}">解释状态</td>	
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
			 <input name="project_name" id="project_name" class="input_width" style="width:250px;height:19px" value="" type="text" readonly="readonly"/>
           </td>
           <td class="inquire_item6">采集资料上交清单：</td>
           <td  colspan="3" >
                <% 
			  		  if(doc_type.equals("0110000061200000002")){
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
			  		  if(doc_type.equals("0110000061200000002")){
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
			 	<table width="90%"    cellspacing="0" cellpadding="0"  align="left"  border="0"    >

  			    
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
			  		  if(doc_type.equals("0110000061200000002")){
			    %>
					   <tr>
					    <td align="left" >	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;处理环节：</td>
					    <td > </td>
					  </tr>
					   <tr>
					    <td  align="left">
							<input type="hidden" id="process_steps" name="process_steps" value=""/>
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected" value="1">预处理</input>
						</td>
					    <td  align="left"> 
					    <input type="checkbox"  name="selected" value="2">波场分离</input>
					    </td>
					  </tr>
					  <tr>
					    <td   align="left"> 
				      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	<input type="checkbox"  name="selected" value="3">激发点静校正</input> 
						</td>
					    <td   align="left"> 
					    <input type="checkbox"  name="selected" value="4"> 反褶积</input>
					    </td>
					  </tr>
					   <tr>
					    <td  align="left">
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected" value="5">初至拾取、计算速度</input> 
						</td>
					    <td  align="left">
					    <input type="checkbox"  name="selected" value="6">  上行波拉平</input>;
					    </td>
					  </tr>
					     <tr>
					    <td  align="left">
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected" value="7">  水平分量旋转</input> 
						</td>
					    <td  align="left">
					    <input type="checkbox"  name="selected" value="8">  走廊切除、叠加、VSP成像</input> 
					    </td>
					  </tr>
					    <tr>
					    <td  align="left"> 
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected" value="9">  三分量旋转</input> 
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
					    <td align="left" > 
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
					    <td align="left" > 
				     <div id="down_0110000061200000002_2"></div>
 
	 				    </td>
					  </tr>
  				 <%
			   		 }  
  				%> 
			
					</table>
 
					
			</td>
		  <td colspan="3" align="center"> 
		  	<table width="90%"    cellspacing="0" cellpadding="0"  align="left"  border="0"    >

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
			  		  if(doc_type.equals("0110000061200000002")){
			    %>
  			    
					   <tr>
					    <td align="left" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;解释环节：</td>
					    <td > </td>
					  </tr> 
					   <tr>
					    <td  align="left">
							<input type="hidden" id="explain_steps" name="explain_steps" value=""/>
				      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected_a" value="1">速度计算</input>
						</td>
					    <td  align="left"> 
					    <input type="checkbox"  name="selected_a" value="2">储层精细标定</input>
					    </td>
					  </tr>
					  <tr>
					    <td   align="left"> 
				      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected_a" value="3"> 速度对比</input> 
						</td>
					    <td   align="left"> 
					    <input type="checkbox"  name="selected_a" value="4"> 储层预测</input>
					    </td>
					  </tr>
					   <tr>
					    <td  align="left">
				      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected_a" value="5">  层位标定</input> 
						</td>
					    <td  align="left">
					    <input type="checkbox"  name="selected_a" value="6">   地震资料解释成图</input>;
					    </td>
					  </tr>
					     <tr>
					    <td  align="left">
				      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  name="selected_a" value="7"> 联合标定</input> 
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
					    <td align="left"> 
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
					    <td align="left"> 
					     		     <div id="down_0110000061200000002_3"></div>
					      		
	 				    </td>
					  </tr>
					  	 
					  		   <tr>
					    <td align="center" colspan="3" >
				     
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
	function refreshData(){

		 var querySql1="";
         var queryRet1=null;
         var datas1 =null;
         querySql1 = "  select t.project_info_no, t.commitments_id,t.spare2   from GP_WS_VSP_COMMITMENTS t   where t.bsflag = '0'   and t.doc_type = '"+commitments_type+"' and t.status_type = '2' and t.outsourcing='1'   and t.commitments_id not in (select vc.commitments_id     from GP_WS_VSP_CSTATUS vc         where vc.bsflag = '0' and vc.doc_type= '<%=doc_type%>' )" ;
         queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=6000&querySql='+encodeURI(encodeURI(querySql1)));
        
	       	if(queryRet1.returnCode=='0'){
	       	  datas1 = queryRet1.datas;	 
	       		if(datas1 != null && datas1 != ''){	  
	    			var appearances="";
    				var identifications="";
    				var m_performances=""; 

    				for(var i = 0; i<datas1.length; i++){	 
	       				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
	       				var submitStr = 'JCDP_TABLE_NAME=GP_WS_VSP_CSTATUS&JCDP_TABLE_ID=&commitments_id='+datas1[i].commitments_id +'&project_info_no='+datas1[i].project_info_no+'&bsflag=0&doc_type=<%=doc_type%>&create_date=<%=appDate%>&creator_id=<%=userName%>&table_type='+datas1[i].spare2; 
	       			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		

	       			}
	
	       		}
	       		
	       	}
	
	       	
		cruConfig.queryStr = "  select t.* from ( select sc.table_type optioning_type, sc.cstatus_id, sc.process_steps,sc.process_input,sc.explain_steps,sc.explain_input,nvl(sc.process_state,0)process_state,nvl(sc.explain_state,0)explain_state, decode(sc.process_state,'1','未进行','2','进行中','3','已完成',sc.process_state)process_state_name ,decode(sc.explain_state,'1','未进行','2','进行中','3','已完成',sc.explain_state)explain_state_name , t.commitments_id,  to_char( t.give_time,'yyyy') year_s,t.project_info_no,  p.project_name,  t.tecnical_id,decode(t.status_type,   '1',   '未下达',  '2',  '已下达', t.status_type) proc_status_name,  t.give_people,t.outsourcing,t.todeal_people,t.todeal_people_s,t.t_start_time,t.t_end_time,t.explain_people,t.explain_people_s,t.e_start_time,t.e_end_time,t.give_time,nvl(t.status_type,0)status_type ,  f.ucm_id as ucm_id,  f.file_name as file_name,  f2.ucm_id as ucm_id_a,  f2.file_name as file_name_a ,sc.modifi_date  from  GP_WS_VSP_CSTATUS sc   left join  GP_WS_VSP_COMMITMENTS t on t.commitments_id=sc.commitments_id and t.bsflag='0'   left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '"+doc_listType+"'  and bsflag = '0'  group by relation_id,  doc_file_type)) f  on t.tecnical_id = f.relation_id   left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '"+commitments_type+"'  and bsflag = '0'  group by relation_id,  doc_file_type)) f2  on t.commitments_id = f2.relation_id     left join ( select p.project_info_no ,p.project_name  from  gp_task_project p  where p.bsflag='0'          union all         select  pt.ws_detail_no as project_info_no,pt.project_name    from  GP_WS_PROJECT_DETAIL pt where pt.bsflag='0' ) p  on p.project_info_no = t.project_info_no  where sc.bsflag = '0'    and sc.doc_type = '<%=doc_type%>'  ) t order by t.modifi_date desc,t.process_state asc   ";
		cruConfig.currentPageUrl = "/td/vspExplain/vspCommitments/commitmentsList.jsp";
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
 
	   var  fileId=ids.split("-")[0];
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
   	 if(sub_doc_type == "0110000061200000002"){
   	  	document.getElementById("down_0110000061100000024").innerHTML="";
   	  	document.getElementById("down_0110000061200000001").innerHTML="";
   	  	document.getElementById("down_0110000061200000002_0").innerHTML="";
   	  	document.getElementById("down_0110000061200000002_1").innerHTML="";
   	  }else{
   		document.getElementById("down_0110000061100000124").innerHTML="";
   	  	document.getElementById("down_0110000061200000006").innerHTML="";
   	  	document.getElementById("down_0110000061200000002_2").innerHTML="";
   	  	document.getElementById("down_0110000061200000002_3").innerHTML="";
   	  }
   	        document.getElementById("todeal_people").value ="";
			document.getElementById("t_start_time").value = "";
			document.getElementById("t_end_time").value = "";
			document.getElementById("explain_people").value ="";     					 
			document.getElementById("e_start_time").value ="";
			document.getElementById("e_end_time").value = "";
 
			var selected = document.getElementsByName("selected"); 
  
					for(var e=0;e<selected.length;e++){
						 
							selected[e].checked = false;
					 
					}
					var selected_a = document.getElementsByName("selected_a"); 
					  
					for(var f=0;f<selected_a.length;f++){
						 
						selected_a[f].checked = false;
					 
					}
				
   		if(fileId !='null'){
   			var querySql = "  select t.* from ( select sc.cstatus_id,sc.doc_type,wt.file_id file_id_b,wt.checkout_status,wt.ucm_id ucm_id_b,wt.file_abbr file_abbr_b, wt.file_name file_name_b, sc.process_steps,sc.process_input,sc.explain_steps,sc.explain_input,sc.process_state, sc.explain_state, decode(sc.process_state,'1','未进行','2','进行中','3','已完成',sc.process_state)process_state_name ,decode(sc.explain_state,'1','未进行','2','进行中','3','已完成',sc.explain_state)explain_state_name , t.commitments_id,  to_char( t.give_time,'yyyy') year_s,t.project_info_no,  p.project_name,  t.tecnical_id,decode(t.status_type,   '1',   '未下达',  '2',  '已下达', t.status_type) proc_status_name,  t.give_people,t.outsourcing,t.todeal_people,t.todeal_people_s,t.t_start_time,t.t_end_time,t.explain_people,t.explain_people_s,t.e_start_time,t.e_end_time,t.give_time,nvl(t.status_type,0)status_type ,  f.ucm_id as ucm_id,  f.file_name as file_name,  f2.ucm_id as ucm_id_a,  f2.file_name as file_name_a   from  GP_WS_VSP_CSTATUS sc   left join  GP_WS_VSP_COMMITMENTS t on t.commitments_id=sc.commitments_id and t.bsflag='0'   left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '"+doc_listType+"'  and bsflag = '0'  group by relation_id,  doc_file_type)) f  on t.tecnical_id = f.relation_id   left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '"+commitments_type+"'  and bsflag = '0'  group by relation_id,  doc_file_type)) f2  on t.commitments_id = f2.relation_id    left join ( select p.project_info_no ,p.project_name  from  gp_task_project p  where p.bsflag='0'          union all         select  pt.ws_detail_no as project_info_no,pt.project_name    from  GP_WS_PROJECT_DETAIL pt where pt.bsflag='0' ) p  on p.project_info_no = t.project_info_no left join bgp_doc_gms_file wt   on sc.cstatus_id = wt.relation_id     and wt.bsflag = '0'  where sc.bsflag = '0'    and sc.doc_type = '<%=doc_type%>' and sc.cstatus_id='"+fileId+"'  ) t  ";
   			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
   			var datas = queryRet.datas;
   			
   			if(datas!=null && datas.length>0){
   				 //公共
   				document.getElementById("cstatus_id").value = datas[0].cstatus_id;
   				document.getElementById("doc_type").value = datas[0].doc_type;
 
   				document.getElementById("project_name").value = datas[0].project_name;
   				document.getElementById("project_info_no").value = datas[0].project_info_no;
   				document.getElementById("file_abbr").value = "<%=fileAbbr%>";
   	  
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
 
   							var str_b=datas[c].file_name_b==""?"":datas[c].file_name_b.substr(0,20)+'...';
   							$("#down_"+a_typs).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId_b+"&emflag=0>"+str_b+"</a>");
   						}else{
   							var ucmId_c=datas[c].ucm_id_b; 
 
   							var str_c=datas[c].file_name_b==""?"":datas[c].file_name_b.substr(0,20)+'...';
   							$("#down_"+b_typs).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId_c+"&emflag=0>"+str_c+"</a>");
   							
   						}
   						
   					}
   				}
   				
   				
   			}
   		} 	
		

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
	 
    	popWindow('<%=contextPath%>/td/vspExplain/vspCStatus/add_status.jsp?docType=<%=doc_type%>&fileAbbr='+fileAbbr+'&parent_file_id='+parent_file_id+'&id='+ids.split("-")[0]+'&p_type='+ids.split("-")[1],'960:750');
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
			if(s_proc_status=='2'){ 
				str += " and process_state='3' and explain_state='3' ";	
			}else{
				str += " and process_state='2' and explain_state='2' ";	
			}
						
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