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
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId =(user==null)?"":user.getOrgSubjectionId();	
	 
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
 
<title>设备设施使用管理有效性  </title>
</head>

<body style="background:#fff"  onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">有效性编号</td>
			    <td class="inquire_form6"> 
				<input type="text" id="changeName" name="changeName"   value="" />	
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span> 
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{usefacilities_no}' value='{usefacilities_no}' onclick=doCheck(this) />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{management_number}">管理有效性编号</td>
			      <td class="bt_info_even" exp="{inspection_date}">检查/检验日期</td>
			      <td class="bt_info_odd" exp="{completion_date}">整改完成日期</td>
			      <td class="bt_info_even" exp="{effective_date}">检验有效日期</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">管理设备列表</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">管理有效性信息</a></li>	
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
	                <span class="bc"  onclick="toUpdate1()"><a href="#"></a></span> 
	                  </td>
	                  <td width="5"></td>
	                </tr>
	              </table>
	              <table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="hseTableInfo">
			          	<tr > 	 
			          	    <TD  class="bt_info_even"  width="12%">设备设施名称</TD>
			          		<TD  class="bt_info_odd" width="11%" >规格型号</TD>	          		
			          	    <TD  class="bt_info_even"  width="11%">技术状况</TD>
			          		<TD  class="bt_info_odd" width="11%" >使用状况</TD>	          		
			          	    <TD  class="bt_info_even"  width="11%">出厂日期</TD>
			          		<TD  class="bt_info_odd" width="11%" >牌照号</TD>
			           	    <TD  class="bt_info_even"  width="11%">设施类别一</TD>
			          		<TD  class="bt_info_odd" width="11%" > 设施类别二</TD>
			          		
			          		<input type="hidden" id="equipmentSize" name="equipmentSize"   value="0" />
			          		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
			          		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />	
			          		<input type="hidden" id="lineNum" value="0"/>
			          		<TD class="bt_info_even" width="5%">操作</TD>
			          	</tr> 
	              </table>	 
	         </div>
			 
				
		  <div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="right" height="30">
                  <td>&nbsp;</td>
                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()"></a></span></td>
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
			          	<td class="inquire_item6">二级单位：</td>
			        	<td class="inquire_form6">
			        	 <input type="hidden" id="second_org" name="second_org" class="input_width" />
				    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
			        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
			        	<%} %>
			        	</td>    	  
				  </tr>					  
					<tr>								 
					  <td class="inquire_item6">基层单位：</td>
				      	<td class="inquire_form6">
			 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
				      	<input type="hidden" id="create_date" name="create_date" value="" />
				      	<input type="hidden" id="creator" name="creator" value="" />
				      	<input type="hidden" id="usefacilities_no" name="usefacilities_no"   />
				     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
				      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
				      	<%}%>
				      	</td> 
				    <td class="inquire_item6"><font color="red">*</font>管理有效性编号：</td>
				    <td class="inquire_form6">
				    <input type="text" id="management_number" name="management_number" class="input_width"  style="color:gray;" value="自动生成"   readonly="readonly" />    					    
				    </td>					    
					</tr>						
				  <tr>	
				    <td class="inquire_item6"><font color="red">*</font>检查/检验日期：</td>
				    <td class="inquire_form6"><input type="text" id="inspection_date" name="inspection_date"   class="input_width"   readonly="readonly"  />
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(inspection_date,tributton1);" />&nbsp;</td>
				    </td>  
				    <td class="inquire_item6">整改完成日期：</td>
				    <td class="inquire_form6"><input type="text" id="completion_date" name="completion_date"   class="input_width"   readonly="readonly"  />
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(completion_date,tributton2);" />&nbsp;</td>
				    </td> 
				</tr>						
				<tr> 
				    <td class="inquire_item6">检验有效日期：</td>
				    <td class="inquire_form6"><input type="text" id="effective_date" name="effective_date"   class="input_width"   readonly="readonly"  />
				    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(effective_date,tributton3);" />&nbsp;</td>
				    </td> 
			   </tr>	 
				  </table>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
				  <tr>       
				    <td class="inquire_item6">存在问题：</td> 					   
				    <td class="inquire_form6" colspan="3" align="center" ><textarea  style="width:480px;height:60px;" id="problems" name="problems"   class="textarea" ></textarea></td>
				    <td class="inquire_form6"  align="center" >    
				    </td>
				  </tr>		
				  <tr>   
				    <td class="inquire_item6">整改情况：</td> 					   
				    <td class="inquire_form6" colspan="3" align="center" ><textarea  style="width:480px;height:60px;" id="rectification" name="rectification"   class="textarea" ></textarea></td>
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

var checked = false;
function check(){
	var chk = document.getElementsByName("chx_entity_id");
	for(var i = 0; i < chk.length; i++){ 
		if(!checked){ 
			chk[i].checked = true; 
		}
		else{
			chk[i].checked = false;
		}
	} 
	if(checked){
		checked = false;
	}
	else{
		checked = true;
	}
}


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
		cruConfig.queryStr = "    select  tr.org_sub_id, tr.usefacilities_no,tr.management_number,tr.inspection_date,tr.problems,tr.rectification,tr.completion_date,tr.effective_date  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_USEFACILITIES_STAND tr   left  join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id      where tr.bsflag = '0' "+querySqlAdd+" order by tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/hseOptionPage/useFacilitiesStandbook/useFacilitiesStandbook.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/hseOptionPage/useFacilitiesStandbook/useFacilitiesStandbook.jsp";
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
				if(changeName!=''&& changeName!=null){
					var isProject = "<%=isProject%>";
					var querySqlAdd = "";
					if(isProject=="1"){
						querySqlAdd = getMultipleSql2("tr.");
					}else if(isProject=="2"){
						querySqlAdd = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
					}
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "    select  tr.org_sub_id, tr.usefacilities_no,tr.management_number,tr.inspection_date,tr.problems,tr.rectification,tr.completion_date,tr.effective_date  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_USEFACILITIES_STAND tr     left  join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id       where tr.bsflag = '0' "+querySqlAdd+"  and tr.management_number like '%"+changeName +"%'   order by tr.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/hseOptionPage/useFacilitiesStandbook/useFacilitiesStandbook.jsp";
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
			querySql = "    select  tr.org_sub_id, tr.usefacilities_no,tr.management_number,tr.inspection_date,tr.problems,tr.rectification,tr.completion_date,tr.effective_date  ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_USEFACILITIES_STAND tr      left  join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id        where tr.bsflag = '0' and tr.usefacilities_no='"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 
					 document.getElementsByName("usefacilities_no")[0].value=datas[0].usefacilities_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;		    
		    		 document.getElementsByName("management_number")[0].value=datas[0].management_number;
		    		 document.getElementsByName("inspection_date")[0].value=datas[0].inspection_date; 
		    		 document.getElementsByName("problems")[0].value=datas[0].problems;
		    		 document.getElementsByName("rectification")[0].value=datas[0].rectification;	 		    		 
		    		 document.getElementsByName("completion_date")[0].value=datas[0].completion_date;
		    		 document.getElementsByName("effective_date")[0].value=datas[0].effective_date;	
 
					}					
			
		    	}		
				
				 var querySql1="";
				 var queryRet1=null;
				 var datas1 =null;
				 deleteTableTr("hseTableInfo");
		    	 document.getElementById("lineNum").value="0";	
				   querySql1 = " select   dl.udetail_no,dl.usefacilities_no,dl.facilities_no,dl.facilities_name,dl.specifications,dl.technical_conditions,dl.use_situation,dl.release_date,dl.paizhaohao,dl.equipment_one,dl.equipment_two, dl.creator,dl.create_date,dl.updator,dl.modifi_date,dl.bsflag  from BGP_USEFACILITIES_DETAIL dl  where dl.bsflag='0'  and dl.usefacilities_no='" + shuaId + "'  order by  dl.modifi_date";
				   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
					if(queryRet1.returnCode=='0'){
					  datas1 = queryRet1.datas;	
	
						if(datas1 != null && datas1 != ''){				 
 							for(var i = 0; i<datas1.length; i++){ 
 					       addLine1(datas1[i].udetail_no,datas1[i].usefacilities_no,datas1[i].facilities_no,datas1[i].facilities_name,datas1[i].specifications,datas1[i].technical_conditions,datas1[i].use_situation,datas1[i].release_date,datas1[i].paizhaohao,datas1[i].equipment_one,datas1[i].equipment_two,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
					       				      
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
		popWindow("<%=contextPath%>/hse/hseOptionPage/useFacilitiesStandbook/addUseFacilities.jsp?isProject=<%=isProject%>");
		
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
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/useFacilitiesStandbook/addUseFacilities.jsp?usefacilities_no="+ids);
	  	
	} 
	
	 
	function toDeletes(){ 
	    ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	  
		deleteEntities("update BGP_USEFACILITIES_STAND e set e.bsflag='1' where e.usefacilities_no='"+ids+"'");
	 
	}

	function toDelete(){
 		
	    ids = getSelIds('chx_entity_id');
	   
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	    var tempIds = ids.split(",");
		var id = "";
		for(var i=0;i<tempIds.length;i++){
			id = id + "'" + tempIds[i] + "'";
			if(i != tempIds.length -1){
				id = id + ",";
			
			}
		}
		deleteEntities("update BGP_USEFACILITIES_STAND e set e.bsflag='1' where e.usefacilities_no in ("+id+")");
	 
	}



	function toSearch(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/useFacilitiesStandbook/hse_search.jsp?isProject=<%=isProject%>");
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
			
    		var management_number=document.getElementsByName("management_number")[0].value;
    		var inspection_date=document.getElementsByName("inspection_date")[0].value;
			
			
	 		if(org_sub_id==""){
	 			document.getElementById("org_sub_id").value = "";
	 		}
	 		if(second_org==""){
	 			document.getElementById("second_org").value="";
	 		}
	 		if(third_org==""){
	 			document.getElementById("third_org").value="";
	 		}
	 		if(management_number==""){
	 			alert("管理有效性编号不能为空，请填写！");
	 			return true;
	 		}
	 		if(inspection_date==""){
	 			alert("检查/检验日期不能为空，请选择！");
	 			return true;
	 		}
	 		  
	 		return false;
	 	}
	 	
		
	function toUpdate(){
		var rowParams = new Array(); 
		var rowParam = {};				
		var usefacilities_no = document.getElementsByName("usefacilities_no")[0].value;						 
		  if(usefacilities_no !=null && usefacilities_no !=''){		
				if(checkJudge()){
					return;
				}
				
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;	 
				
	    		var management_number=document.getElementsByName("management_number")[0].value;
	    		var inspection_date=document.getElementsByName("inspection_date")[0].value;
	    		var problems=document.getElementsByName("problems")[0].value;
	    		var rectification=document.getElementsByName("rectification")[0].value;		    		 
	    		var completion_date=document.getElementsByName("completion_date")[0].value;
	    		var effective_date=document.getElementsByName("effective_date")[0].value;
	 
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			
				
				rowParam['management_number'] = encodeURI(encodeURI(management_number));
				rowParam['inspection_date'] = encodeURI(encodeURI(inspection_date));
				rowParam['problems'] = encodeURI(encodeURI(problems));
				rowParam['rectification'] = encodeURI(encodeURI(rectification));
				rowParam['completion_date'] = encodeURI(encodeURI(completion_date));
				rowParam['effective_date'] = encodeURI(encodeURI(effective_date));
				
			    rowParam['usefacilities_no'] = usefacilities_no;
//				rowParam['creator'] = encodeURI(encodeURI(creator));
//				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
	 		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_USEFACILITIES_STAND",rows);	
			    refreshData();	
 
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}

	function toUpdate1(){	
		var rowNum = document.getElementById("lineNum").value;			
		var rowParams = new Array();
		var usefacilities_nos = document.getElementsByName("usefacilities_no")[0].value;	
					
		 if(usefacilities_nos !=null && usefacilities_nos !=''){
		for(var i=0;i<rowNum;i++){
			var rowParam = {};			
			var udetail_no =document.getElementsByName("udetail_no_"+i)[0].value; 
			var usefacilities_no =document.getElementsByName("usefacilities_no_"+i)[0].value;
			var facilities_no = document.getElementsByName("facilities_no_"+i)[0].value;
	  
			var facilities_name = document.getElementsByName("facilities_name_"+i)[0].value;
			var specifications =document.getElementsByName("specifications_"+i)[0].value;			
			var technical_conditions =document.getElementsByName("technical_conditions_"+i)[0].value; 
			var use_situation =document.getElementsByName("use_situation_"+i)[0].value;
			var release_date = document.getElementsByName("release_date_"+i)[0].value;
			var paizhaohao = document.getElementsByName("paizhaohao_"+i)[0].value;
			var equipment_one = document.getElementsByName("equipment_one_"+i)[0].value;
			var equipment_two = document.getElementsByName("equipment_two_"+i)[0].value;
			
			var creator = document.getElementsByName("creator_"+i)[0].value;
			var create_date = document.getElementsByName("create_date_"+i)[0].value;
			var updator = document.getElementsByName("updator_"+i)[0].value;
			var modifi_date =document.getElementsByName("modifi_date_"+i)[0].value;
			var bsflag =document.getElementsByName("bsflag_"+i)[0].value; 
		   
			if(udetail_no !=null && udetail_no !=''){			
 				rowParam['facilities_name'] = encodeURI(encodeURI(facilities_name));
				rowParam['specifications'] = encodeURI(encodeURI(specifications));
				rowParam['technical_conditions'] = encodeURI(encodeURI(technical_conditions));
				rowParam['use_situation'] = encodeURI(encodeURI(use_situation));
				rowParam['release_date'] = encodeURI(encodeURI(release_date));
				rowParam['paizhaohao'] = encodeURI(encodeURI(paizhaohao));
				rowParam['equipment_one'] = encodeURI(encodeURI(equipment_one));
				rowParam['equipment_two'] = encodeURI(encodeURI(equipment_two));
				
				rowParam['facilities_no'] = encodeURI(encodeURI(facilities_no)); 
			    rowParam['udetail_no'] = udetail_no;
			    rowParam['usefacilities_no'] = usefacilities_no;
//				rowParam['creator'] = encodeURI(encodeURI(creator));
//				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;	
				
			}else{
 				rowParam['facilities_name'] = encodeURI(encodeURI(facilities_name));
				rowParam['specifications'] = encodeURI(encodeURI(specifications));
				rowParam['technical_conditions'] = encodeURI(encodeURI(technical_conditions));
				rowParam['use_situation'] = encodeURI(encodeURI(use_situation));
				rowParam['release_date'] = encodeURI(encodeURI(release_date));
				rowParam['paizhaohao'] = encodeURI(encodeURI(paizhaohao));
				rowParam['equipment_one'] = encodeURI(encodeURI(equipment_one));
				rowParam['equipment_two'] = encodeURI(encodeURI(equipment_two));
				
			    rowParam['udetail_no'] = "";
				rowParam['facilities_no'] = encodeURI(encodeURI(facilities_no));			 		
			    rowParam['usefacilities_no'] = usefacilities_nos;
//				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
//				rowParam['create_date'] ='<%=curDate%>';	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
			}
				rowParams[rowParams.length] = rowParam; 
 
		}
			var rows=JSON.stringify(rowParams);		 
			saveFunc("BGP_USEFACILITIES_DETAIL",rows);	
		    frames[1].refreshData();	
 
			
      }else{			  
			  alert("请先选中一条记录!");
		     	return;		
      }				
		
}
	
	function openAdd(){
	 
			var isProject = "<%=isProject%>";
		 
			if(isProject=="1"){
				 window.open("<%=contextPath%>/hse/hseOptionPage/useFacilitiesStandbook/homeFrame.jsp?addTypes=2&optionP=1",'homeMain','height=500,width=1000px,left=100px,top=100px,menubar=no,status=no,toolbar=no ', '');
					
			}else if(isProject=="2"){
				 window.open("<%=contextPath%>/hse/hseOptionPage/useFacilitiesStandbook/homeFrameP.jsp?addTypes=2&optionP=1",'homeMain','height=500,width=1000px,left=100px,top=100px,menubar=no,status=no,toolbar=no ', '');
					 
			}
			
			
	}
 
 	function addLine1(udetail_nos,usefacilities_nos,facilities_nos,facilities_names,specificationss,technical_conditionss,use_situations,release_dates,paizhaohaos,equipment_ones,equipment_twos,creators,create_dates,updators,modifi_dates,bsflags){
 	 
		var udetail_no = "";
		var usefacilities_no = "";
		var facilities_no = "";
  
		var facilities_name = "";
		var specifications = "";
		var technical_conditions ="";
		var use_situation ="";
		var release_date ="";
		var paizhaohao ="";
		var equipment_one ="";
		var equipment_two ="";
		
		var creator = "";
		var create_date = "";
		var updator = "";
		var modifi_date = "";
		var bsflag = "";

		if(udetail_nos != null && udetail_nos != ""){
			udetail_no=udetail_nos;
		}
		if(usefacilities_nos != null && usefacilities_nos != ""){
			usefacilities_no=usefacilities_nos;
		}
		if(facilities_nos != null && facilities_nos != ""){
			facilities_no=facilities_nos;
		}
		
		if(facilities_names != null && facilities_names != ""){
			facilities_name=facilities_names;
		}
		if(specificationss != null && specificationss != ""){
			specifications=specificationss;
		}
	 
		if(technical_conditionss != null && technical_conditionss != ""){
			technical_conditions=technical_conditionss;
		}
		 
		if(use_situations != null && use_situations != ""){
			use_situation=use_situations;
		}
		if(release_dates != null && release_dates != ""){
			release_date=release_dates;
		}
		if(paizhaohaos != null && paizhaohaos != ""){
			paizhaohao=paizhaohaos;
		}
		
		if(equipment_ones != null && equipment_ones != ""){
			equipment_one=equipment_ones;
		}
		if(equipment_twos != null && equipment_twos != ""){
			equipment_two=equipment_twos;
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
 
		tr.insertCell().innerHTML = '<input type="hidden"  name="udetail_no' + '_' + rowNum + '" value="'+udetail_no+'"/>'+'<input type="text" style="width:130px;" class="input_width" name="facilities_name' + '_' + rowNum + '" value="'+facilities_name+'" readonly="readonly"  />'+'<input type="hidden"  name="usefacilities_no' + '_' + rowNum + '" value="'+usefacilities_no+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="'+bsflag+'"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
		tr.insertCell().innerHTML = '<input type="hidden"  name="facilities_no' + '_' + rowNum + '" value="'+facilities_no+'"/>'+'<input type="text" style="width:130px;" class="input_width" name="specifications' + '_' + rowNum + '" value="'+specifications+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:130px;" class="input_width" name="technical_conditions' + '_' + rowNum + '" value="'+technical_conditions+'"  readonly="readonly" />';
	 
		tr.insertCell().innerHTML ='<input type="text" style="width:100px;" class="input_width" name="use_situation' + '_' + rowNum + '" value="'+use_situation+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:100px;" class="input_width" name="release_date' + '_' + rowNum + '" value="'+release_date+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:100px;" class="input_width" name="paizhaohao' + '_' + rowNum + '" value="'+paizhaohao+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:100px;" class="input_width" name="equipment_one' + '_' + rowNum + '" value="'+equipment_one+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:100px;" class="input_width" name="equipment_two' + '_' + rowNum + '" value="'+equipment_two+'"  readonly="readonly" />';
  
		var td = tr.insertCell(); 
		td.style.display = "";
		td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
		
		document.getElementById("lineNum").value = parseInt(rowNum) + 1;			 
		
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

