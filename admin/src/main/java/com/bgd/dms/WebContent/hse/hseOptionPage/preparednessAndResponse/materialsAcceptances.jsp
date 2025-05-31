<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath();	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId =(user==null)?"":user.getOrgSubjectionId();		
	String projectInfoNo = user.getProjectInfoNo();
	if (projectInfoNo == null || projectInfoNo.equals("")){
		projectInfoNo = "";
	}
	
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
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
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
 
<title>应急物资验收 </title>
</head>

<body style="background:#fff"  onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">验收编号</td>
			    <td class="ali_cdn_input"> 
				<input type="text" id="changeName" name="changeName"   value="" />	
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>    
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{materials_no}' value='{materials_no}' onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{acceptance_numbers}">验收编号</td>
			      <td class="bt_info_even" exp="{acceptance_time}">验收时间</td>
 			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">验收物资列表</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">验收信息</a></li>	
			   </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
 
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="60" id="buttonDis1" >
	                <span class='zj'><a href='#' onclick='openAdd()'  title='新增'></a></span>		 		                
	                <span class="bc"  onclick="toUpdate1()" title="保存"><a href="#"></a></span> 
	                  </td>
	                  <td width="5"></td>
	                </tr>
	              </table>
	              <table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="hseTableInfo">
	          	<tr > 	
	          	    <TD  class="bt_info_even"  width="15%">物资名称</TD>
	          		<TD  class="bt_info_odd" width="15%" >物资类别</TD>	          		
	          	  <TD  class="bt_info_even"  width="15%">购置时间</TD>
	          		<TD  class="bt_info_odd" width="15%" >外观</TD>	          		
	          	  <TD  class="bt_info_even"  width="15%">标识</TD>
	          		<TD  class="bt_info_odd" width="15%" >性能</TD>
	          		<input type="hidden" id="equipmentSize" name="equipmentSize"   value="0" />
	          		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
	          		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />	
	          		<input type="hidden" id="lineNum" value="0"/>
	          		<TD class="bt_info_even" width="10%">操作</TD>
	          	</tr>
	          		 
	          </table>	 
	             	  
				</div>
			 
				
		  <div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="right" height="30">
                  <td>&nbsp;</td>
                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()" title="保存"></a></span></td>
                  <td width="5"></td>
                </tr>
         	   </table>
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
			    <tr>						   
				  <td class="inquire_item6">单位：</td>
		        	<td class="inquire_form6">
		        	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />					     
			      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
		        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
		        	<%} %>
		        	</td>
		          	<td class="inquire_item6">基层单位：</td>
		        	<td class="inquire_form6">
		        	 <input type="hidden" id="second_org" name="second_org" class="input_width" />
			    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
		        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
		        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
		        	<%} %>
		        	</td>    	  
			  </tr>					  
				<tr>								 
				  <td class="inquire_item6">下属单位：</td>
			      	<td class="inquire_form6">
		 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
			      	<input type="hidden" id="create_date" name="create_date" value="" />
			      	<input type="hidden" id="creator" name="creator" value="" />
			      	<input type="hidden" id="materials_no" name="materials_no"   />
			    	<input type="hidden" id="project_no" name="project_no" value="" />
			     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
			      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
			      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
			      	<%}%>
			      	</td> 
			    <td class="inquire_item6"><font color="red">*</font>验收编号：</td>
			    <td class="inquire_form6">
			    <input type="text" id="acceptance_numbers" name="acceptance_numbers" class="input_width"  style="color:gray;" value="自动生成"   readonly="readonly" />    					    
			    </td>					    
				</tr>						
			  <tr>	
			    <td class="inquire_item6"><font color="red">*</font>验收时间：</td>
			    <td class="inquire_form6"><input type="text" id="acceptance_time" name="acceptance_time"   class="input_width"   readonly="readonly"  />
			    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(acceptance_time,tributton1);" />&nbsp;</td>
			    </td> 
			    <td class="inquire_item6"><font color="red">*</font>验收人：</td> 					   
			    <td class="inquire_form6"  align="center" > 
			    <input type="text" id="acceptance_people" name="acceptance_people" class="input_width" />
			    </td>
			  </tr>	 
			  </table>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
			  <tr> 
			    <td class="inquire_item6">其他验收内容：</td> 					   
			    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:490px;height:60px;" id="acceptance_content" name="acceptance_content"   class="textarea" ></textarea></td>
			    <td class="inquire_form6"  align="center" >  
			    </td>
			  </tr>		
			  <tr>
			    <td class="inquire_item6"><font color="red">*</font>验收意见：</td> 					   
			    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:490px;height:60px;" id="acceptance_opinion" name="acceptance_opinion"   class="textarea" ></textarea></td>
			    <td class="inquire_form6"  align="center" >			    
			    </td>
			  </tr>	
			</table>	
			   
				  </div> 
				</form>
			</div>
		  </div>

</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
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
	
	// 复杂查询
	function refreshData(){
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "   select  tr.org_sub_id, tr.materials_no ,tr.acceptance_numbers,tr.acceptance_content,tr.acceptance_opinion,tr.acceptance_people,tr.acceptance_time  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_MATERIALS_ACCEPTANCE tr left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0'  left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'   left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id  and ose.bsflag = '0' left  join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0' "+querySqlAdd+"  order by tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/hseOptionPage/preparednessAndResponse/materialsAcceptances.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/hseOptionPage/preparednessAndResponse/materialsAcceptances.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chx_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
		var changeName = document.getElementById("changeName").value;
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		if(changeName!=''&& changeName!=null){
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = " select  tr.org_sub_id, tr.materials_no ,tr.acceptance_numbers,tr.acceptance_content,tr.acceptance_opinion,tr.acceptance_people,tr.acceptance_time  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_MATERIALS_ACCEPTANCE tr  left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0'  left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'   left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id  and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0' "+querySqlAdd+" and tr.acceptance_numbers like '%"+changeName +"%'   order by tr.modifi_date desc";
			cruConfig.currentPageUrl = "/hse/hseOptionPage/preparednessAndResponse/materialsAcceptances.jsp";
			queryData(1);
		}else{
			refreshData();
		}
	}
	
	function clearQueryText(){
		document.getElementById("changeName").value = "";
	}
 
	function loadDataDetail(shuaId){
		if(shuaId !=null){
			var querySql = "";
			var queryRet = null;
			var  datas =null;	
			querySql = "    select   tr.project_no,tr.org_sub_id, tr.materials_no ,tr.acceptance_numbers,tr.acceptance_content,tr.acceptance_opinion,tr.acceptance_people,tr.acceptance_time  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_MATERIALS_ACCEPTANCE tr  left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0'  left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0'   left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id  and ose.bsflag = '0' left  join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0' and tr.materials_no='"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 
					 document.getElementsByName("materials_no")[0].value=datas[0].materials_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;		   
		    		  document.getElementsByName("project_no")[0].value=datas[0].project_no;		  
		  		    
		    		 document.getElementsByName("acceptance_numbers")[0].value=datas[0].acceptance_numbers;
		    		 document.getElementsByName("acceptance_time")[0].value=datas[0].acceptance_time;	 		    		 
		    		 document.getElementsByName("acceptance_people")[0].value=datas[0].acceptance_people;
		    		 document.getElementsByName("acceptance_content")[0].value=datas[0].acceptance_content;	
		    		 document.getElementsByName("acceptance_opinion")[0].value=datas[0].acceptance_opinion;
					}					
			
		    	}		
		 
				 var querySql1="";
				 var queryRet1=null;
				 var datas1 =null;
				 deleteTableTr("hseTableInfo");
		    	 document.getElementById("lineNum").value="0";	
				   querySql1 = " select   dl.mdetail_no,dl.materials_no,dl.emergency_no,dl.supplies_name,dl.supplies_category,dl.acuisition_time,dl.appearance,dl.identification,dl.m_performance, dl.creator,dl.create_date,dl.updator,dl.modifi_date,dl.bsflag  from BGP_MATERIALS_DETAIL dl  where dl.bsflag='0'  and dl.materials_no='" + shuaId + "'  order by  dl.modifi_date";
				   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
					if(queryRet1.returnCode=='0'){
					  datas1 = queryRet1.datas;	
	
						if(datas1 != null && datas1 != ''){				 
 							for(var i = 0; i<datas1.length; i++){
 					       addLine1(datas1[i].mdetail_no,datas1[i].materials_no,datas1[i].emergency_no,datas1[i].supplies_name,datas1[i].supplies_category,datas1[i].acuisition_time,datas1[i].appearance,datas1[i].identification,datas1[i].m_performance,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
					       				      
							}
							
						}
				    }	
			
		 
		}
 
	}
	 
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
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
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/addMaterialsAcceptance.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>");
		
	}
 
	function selectTeam1(){
		
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/rm/em/humanLabor/selectProject.lpmd',teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById("project_id").value = teamInfo.fkValue;
	        document.getElementById("project_name").value = teamInfo.value;
	    }
	}

	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/addMaterialsAcceptance.jsp?isProject=<%=isProject%>&projectInfoNo=<%=projectInfoNo%>&materials_no="+ids);
	  	
	} 
	
	 
	function toDelete(){
 		
	    ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	 
	     var querySql1="";
         var queryRet1=null;
         var datas1 =null;
         querySql1 = "select dil.emergency_no  from BGP_MATERIALS_DETAIL dil left join  BGP_MATERIALS_ACCEPTANCE  ion on ion.materials_no=dil.materials_no and dil.bsflag='0' where ion.bsflag='0' and  ion.materials_no='"+ ids +"'";;
         queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
        
	       	if(queryRet1.returnCode=='0'){
	       	  datas1 = queryRet1.datas;	 
	       		if(datas1 != null && datas1 != ''){	  
	    			var appearances="";
    				var identifications="";
    				var m_performances=""; 
    				for(var i = 0; i<datas1.length; i++){	 
	       				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
	       				var submitStr = 'JCDP_TABLE_NAME=BGP_EMERGENCY_STANDBOOK&JCDP_TABLE_ID='+datas1[i].emergency_no +'&appearance='+appearances +'&identification='+identifications +'&performance_s='+m_performances
	       				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
	       			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
	        
		       			var submitStrs = 'JCDP_TABLE_NAME=BGP_EMERGENCY_INFORMATION&JCDP_TABLE_ID='+datas1[i].emergency_no +'&appearance='+appearances +'&identification='+identifications +'&performance_s='+m_performances
	       				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
	       			   syncRequest('Post',path,encodeURI(encodeURI(submitStrs)));  //保存主表信息		
	       			}
	
	       		}
	       		
	       	}
           
		deleteEntities("update BGP_MATERIALS_ACCEPTANCE e set e.bsflag='1' where e.materials_no='"+ids+"'");
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/hse_search2.jsp?isProject=<%=isProject%>");
	}
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("chx_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
	
	 
	 
	//键盘上只有删除键，和左右键好用
	 function noEdit(event){
	 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
	 		return true;
	 	}else{
	 		return false;
	 	}
	 }
	 
	 
	 function selectOrg(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
		    if(teamInfo.fkValue!=""){
		    	document.getElementById("org_sub_id").value = teamInfo.fkValue;
		        document.getElementById("org_sub_id2").value = teamInfo.value;
		    }
		}

		function selectOrg2(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var second = document.getElementById("org_sub_id").value;
			var org_id="";
				var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
			   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
				var datas = queryRet.datas;
				if(datas==null||datas==""){
				}else{
					org_id = datas[0].org_id; 
			    }
				    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
				    if(teamInfo.fkValue!=""){
				    	 document.getElementById("second_org").value = teamInfo.fkValue; 
				        document.getElementById("second_org2").value = teamInfo.value;
					}
		   
		}

		function selectOrg3(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var third = document.getElementById("second_org").value;
			var org_id="";
				var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
			   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
				var datas = queryRet.datas;
				if(datas==null||datas==""){
				}else{
					org_id = datas[0].org_id; 
			    }
				    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
				    if(teamInfo.fkValue!=""){
				    	 document.getElementById("third_org").value = teamInfo.fkValue;
				        document.getElementById("third_org2").value = teamInfo.value;
					}
		}

		function checkJudge(){
	 		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
			var second_org = document.getElementsByName("second_org2")[0].value;			
			var third_org = document.getElementsByName("third_org2")[0].value;			
			
			var acceptance_time=document.getElementsByName("acceptance_time")[0].value; 		    		 
    		var acceptance_people=document.getElementsByName("acceptance_people")[0].value;
    		var acceptance_opinion=document.getElementsByName("acceptance_opinion")[0].value;
			
	 		if(org_sub_id==""){
	 			document.getElementById("org_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("second_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("third_org").value="";
	 		}
	 		if(acceptance_time==""){
	 			alert("验收时间不能为空，请填写！");
	 			return true;
	 		}
	 		if(acceptance_people==""){
	 			alert("验收人不能为空，请选择！");
	 			return true;
	 		}
	  
			if(acceptance_opinion==""){
	 			alert("验收意见不能为空，请填写！");
	 			return true;
	 		}
		 
	 		
	 		return false;
	 	}
	 	
	 	
		
	function toUpdate(){
		var rowParams = new Array(); 
		var rowParam = {};				
		var materials_no = document.getElementsByName("materials_no")[0].value;						 
		  if(materials_no !=null && materials_no !=''){		
				if(checkJudge()){
					return;
				}
				
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;	 
				
	    		var acceptance_numbers=document.getElementsByName("acceptance_numbers")[0].value;
	    		var acceptance_time=document.getElementsByName("acceptance_time")[0].value; 		    		 
	    		var acceptance_people=document.getElementsByName("acceptance_people")[0].value;
	    		var acceptance_content=document.getElementsByName("acceptance_content")[0].value;
	    		var acceptance_opinion=document.getElementsByName("acceptance_opinion")[0].value;
	    		var project_no = document.getElementsByName("project_no")[0].value;						 
				
				 
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			
				
				rowParam['acceptance_numbers'] = encodeURI(encodeURI(acceptance_numbers));
				rowParam['acceptance_time'] = encodeURI(encodeURI(acceptance_time));
				rowParam['acceptance_people'] = encodeURI(encodeURI(acceptance_people));
				rowParam['acceptance_content'] = encodeURI(encodeURI(acceptance_content));
				rowParam['acceptance_opinion'] = encodeURI(encodeURI(acceptance_opinion));
 				
			    rowParam['materials_no'] = materials_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
	 		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_MATERIALS_ACCEPTANCE",rows);	
			    refreshData();	
 
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}

	function toUpdate1(){	
		var rowNum = document.getElementById("lineNum").value;			
		var rowParams = new Array();
		var materials_nos = document.getElementsByName("materials_no")[0].value;	
					
		 if(materials_nos !=null && materials_nos !=''){
		for(var i=0;i<rowNum;i++){
			var rowParam = {};			
			var mdetail_no =document.getElementsByName("mdetail_no_"+i)[0].value; 
			var materials_no =document.getElementsByName("materials_no_"+i)[0].value;
			var emergency_no = document.getElementsByName("emergency_no_"+i)[0].value;
			var supplies_name = document.getElementsByName("supplies_name_"+i)[0].value;
			var supplies_category =document.getElementsByName("supplies_category_"+i)[0].value;			
			var acuisition_time =document.getElementsByName("acuisition_time_"+i)[0].value; 
			var appearance =document.getElementsByName("appearance_"+i)[0].value;
			var identification = document.getElementsByName("identification_"+i)[0].value;
			var m_performance = document.getElementsByName("m_performance_"+i)[0].value;
    
			var creator = document.getElementsByName("creator_"+i)[0].value;
			var create_date = document.getElementsByName("create_date_"+i)[0].value;
			var updator = document.getElementsByName("updator_"+i)[0].value;
			var modifi_date =document.getElementsByName("modifi_date_"+i)[0].value;
			var bsflag =document.getElementsByName("bsflag_"+i)[0].value; 
		    if(bsflag =="1"){
				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
				var appearances="";
				var identifications="";
				var m_performances=""; 
   				var submitStr = 'JCDP_TABLE_NAME=BGP_EMERGENCY_STANDBOOK&JCDP_TABLE_ID='+emergency_no +'&appearance='+appearances +'&identification='+identifications +'&performance_s='+m_performances
   				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
   			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
      
   			   var submitStrs = 'JCDP_TABLE_NAME=BGP_EMERGENCY_INFORMATION&JCDP_TABLE_ID='+emergency_no +'&appearance='+appearances +'&identification='+identifications +'&performance_s='+m_performances
				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
			   syncRequest('Post',path,encodeURI(encodeURI(submitStrs)));  //保存主表信息		
  
		    }else{    			 
				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
   				var submitStr = 'JCDP_TABLE_NAME=BGP_EMERGENCY_STANDBOOK&JCDP_TABLE_ID='+emergency_no +'&appearance='+appearance +'&identification='+identification +'&performance_s='+m_performance
   				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
   			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		

   			   var submitStrs = 'JCDP_TABLE_NAME=BGP_EMERGENCY_INFORMATION&JCDP_TABLE_ID='+emergency_no +'&appearance='+appearance +'&identification='+identification +'&performance_s='+m_performance
				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
			   syncRequest('Post',path,encodeURI(encodeURI(submitStrs)));  //保存主表信息		
		    }
   		
			if(mdetail_no !=null && mdetail_no !=''){			
 				rowParam['supplies_name'] = encodeURI(encodeURI(supplies_name));
				rowParam['supplies_category'] = encodeURI(encodeURI(supplies_category));
				rowParam['appearance'] = encodeURI(encodeURI(appearance));
				rowParam['acuisition_time'] = encodeURI(encodeURI(acuisition_time));
				rowParam['identification'] = encodeURI(encodeURI(identification));
				rowParam['m_performance'] = encodeURI(encodeURI(m_performance));
				
				rowParam['emergency_no'] = encodeURI(encodeURI(emergency_no)); 
			    rowParam['mdetail_no'] = mdetail_no;
			    rowParam['materials_no'] = materials_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;	
				
			}else{
				rowParam['supplies_name'] = encodeURI(encodeURI(supplies_name));
				rowParam['supplies_category'] = encodeURI(encodeURI(supplies_category));
				rowParam['appearance'] = encodeURI(encodeURI(appearance));
				rowParam['acuisition_time'] = encodeURI(encodeURI(acuisition_time));
				rowParam['identification'] = encodeURI(encodeURI(identification));
				rowParam['m_performance'] = encodeURI(encodeURI(m_performance));
			    rowParam['mdetail_no'] = "";
				rowParam['emergency_no'] = encodeURI(encodeURI(emergency_no));			 		
			    rowParam['materials_no'] = materials_nos;
				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
			}
				rowParams[rowParams.length] = rowParam; 
 
		}
			var rows=JSON.stringify(rowParams);		 
			saveFunc("BGP_MATERIALS_DETAIL",rows);	
		    frames[1].refreshData();	
 
			
      }else{			  
			  alert("请先选中一条记录!");
		     	return;		
      }				
		
}
	
	function openAdd(){
		 window.open("<%=contextPath%>/hse/hseOptionPage/preparednessAndResponse/homeFrame.jsp?addTypes=2&optionP=1&isProject=<%=isProject%>",'homeMain','height=500,width=1000px,left=100px,top=100px,menubar=no,status=no,toolbar=no ', '');
		
	}
	var num_str="";
	var num_stra="";
	var num_strb="";
 	function addLine1(mdetail_nos,materials_nos,emergency_nos,supplies_names,supplies_categorys,acuisition_times,appearances,identifications,m_performances,creators,create_dates,updators,modifi_dates,bsflags){
 	 
		var mdetail_no = "";
		var materials_no = "";
		var emergency_no = "";
		var supplies_name = "";
		var acuisition_time = "";
		var supplies_category ="";
		var appearance ="";
		var identification ="";
		var m_performance ="";
		
		var creator = "";
		var create_date = "";
		var updator = "";
		var modifi_date = "";
		var bsflag = "";

		if(mdetail_nos != null && mdetail_nos != ""){
			mdetail_no=mdetail_nos;
		}
		if(materials_nos != null && materials_nos != ""){
			materials_no=materials_nos;
		}
		if(emergency_nos != null && emergency_nos != ""){
			emergency_no=emergency_nos;
		}
		
		if(supplies_names != null && supplies_names != ""){
			supplies_name=supplies_names;
		}
		if(acuisition_times != null && acuisition_times != ""){
			acuisition_time=acuisition_times;
		}
	 
		if(supplies_categorys != null && supplies_categorys != ""){
			supplies_category=supplies_categorys;
		}
		
		
		if(appearances != null && appearances != ""){
			appearance=appearances;
		}
		if(identifications != null && identifications != ""){
			identification=identifications;
		}
		if(m_performances != null && m_performances != ""){
			m_performance=m_performances;
		}
		
		  
		if(creators != null && creators != ""){
			creator=creators;
		}
		
		if(create_dates != null && create_dates != ""){
			create_date=create_dates;
		}
		if(updators != null && updators != ""){
			updator=updators;
		}
		if(modifi_dates != null && modifi_dates != ""){
			modifi_date=modifi_dates;
		}
		if(bsflags != null && bsflags != ""){
			bsflag=bsflags;
		}
		 
		var rowNum = document.getElementById("lineNum").value;	
		
		var tr = document.getElementById("hseTableInfo").insertRow();
		
		tr.align="center";		
 
	  	if(rowNum % 2 == 1){  
	  		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}	
		tr.id = "row_" + rowNum + "_";   
 
		tr.insertCell().innerHTML = '<input type="hidden"  name="mdetail_no' + '_' + rowNum + '" value="'+mdetail_no+'"/>'+'<input type="text" style="width:160px;" class="input_width" name="supplies_name' + '_' + rowNum + '" value="'+supplies_name+'" readonly="readonly"  />'+'<input type="hidden"  name="materials_no' + '_' + rowNum + '" value="'+materials_no+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="'+bsflag+'"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
		tr.insertCell().innerHTML = '<input type="hidden"  name="emergency_no' + '_' + rowNum + '" value="'+emergency_no+'"/>'+'<input type="text" style="width:160px;" class="input_width" name="supplies_category' + '_' + rowNum + '" value="'+supplies_category+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:160px;" class="input_width" name="acuisition_time' + '_' + rowNum + '" value="'+acuisition_time+'"  readonly="readonly" />';
	 
		if(appearance == ""){
	 		tr.insertCell().innerHTML ='<select  style="width:150px;"  name="appearance' + '_' + rowNum + '" id="appearance' + '_' + rowNum + '"  ><option value="">请选择</option><option value="1" >完好</option><option value="2">不完好</option></select>';
	 	}else{
	 		getNum(appearance);
	 			tr.insertCell().innerHTML = '<select  style="width:150px;"  name="appearance' + '_' + rowNum + '" id="appearance' + '_' + rowNum + '"  > '+num_str+'</select>';
	 	}
	 	if(identification == ""){
	 		tr.insertCell().innerHTML ='<select  style="width:150px;"  name="identification' + '_' + rowNum + '" id="identification' + '_' + rowNum + '"  ><option value="">请选择</option><option value="1" >符合</option><option value="2">不符合</option></select>';
	 	}else{
	 		getNum1(identification);
	 			tr.insertCell().innerHTML = '<select  style="width:150px;"  name="identification' + '_' + rowNum + '" id="identification' + '_' + rowNum + '"  > '+num_stra+'</select>';
	 	}
		
	 	if(m_performance == ""){
	 		tr.insertCell().innerHTML ='<select  style="width:150px;"  name="m_performance' + '_' + rowNum + '" id="m_performance' + '_' + rowNum + '"  ><option value="">请选择</option><option value="1" >有效</option><option value="2">失效</option></select>';
	 	}else{
	 		getNum2(m_performance);
	 			tr.insertCell().innerHTML = '<select  style="width:150px;"  name="m_performance' + '_' + rowNum + '" id="m_performance' + '_' + rowNum + '"  > '+num_strb+'</select>';
	 	}
		 
		var td = tr.insertCell(); 
		td.style.display = "";
		td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
		
		document.getElementById("lineNum").value = parseInt(rowNum) + 1;			 
		
	}
 	
 	function getNum(selectValue){
		num_str='<option value="">请选择</option>';
		  
			if(selectValue=='1'){
				num_str+='<option value="1" selected="selected" >完好</option>';	
				num_str+='<option value="2" >不完好</option>';
			}else{
				num_str+='<option value="2" selected="selected"  >不完好</option>';
				num_str+='<option value="1"  >完好</option>';	
			}
	 
	}
 	function getNum1(selectValue){
		num_stra='<option value="">请选择</option>';
 
			if(selectValue=='1'){
				num_stra+='<option value="1" selected="selected" >符合</option>';	
				num_stra+='<option value="2" >不符合</option>';
			}else{
				num_stra+='<option value="2" selected="selected"  >不符合</option>';
				num_stra+='<option value="1"  >符合</option>';	
			}
	 
	}
 	function getNum2(selectValue){
		num_strb='<option value="">请选择</option>';
 
			if(selectValue=='1'){
				num_strb+='<option value="1" selected="selected" >有效</option>';	
				num_strb+='<option value="2" >失效</option>';
			}else{
				num_strb+='<option value="2" selected="selected"  >失效</option>';
				num_strb+='<option value="1"  >有效</option>';	
			}
	 
	}
 	
	 function deleteLine(lineId){		
			var rowNum = lineId.split('_')[1];
			var line = document.getElementById(lineId);		

			var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
			if(bsflag!=""){
				line.style.display = 'none';
				document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
			}else{
				line.parentNode.removeChild(line);
			}	
		}

</script>

</html>

