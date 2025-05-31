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
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	String orgSubId =(user==null)?"":user.getOrgSubjectionId();	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
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
 
<title>隐患管理</title>
</head>

<body style="background:#fff"  onload="refreshData();getHazardBig();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">隐患名称</td>
			    <td class="inquire_form6"><input id="changeName" name="changeName" type="text" />			   
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
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{hidden_no}' value='{hidden_no}' onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{hidden_name}">隐患名称</td>
			      <td class="bt_info_even" exp="{report_date}">上报日期</td>
			      <td class="bt_info_odd" exp="{risk_levels}">风险级别</td>
			      <td class="bt_info_even" exp="{rectification_state}">整改状态</td>
			      <td class="bt_info_odd" exp="{reward_state}">奖励状态</td>

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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">隐患信息</a></li>
			   </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
 
				<div id="tab_box_content0" class="tab_box_content">
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
						  <td class="inquire_item6">下属单位：</td>
					      	<td class="inquire_form6">
					    	<input type="hidden" id="aa" name="aa" value="" />
					       	<input type="hidden" id="bb" name="bb" value="" />
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					      	<input type="hidden" id="hidden_no" name="hidden_no"   />
					    	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
					      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
					      	<%}%>
					      	</td>
					    <td class="inquire_item6"><font color="red">*</font>作业场所/岗位：</td>
					    <td class="inquire_form6">
					    <input type="text" id="operation_post" name="operation_post" class="input_width"   />    					    
					    </td>					    
						</tr>						
					  <tr>	
					    <td class="inquire_item6"><font color="red">*</font>隐患名称：</td>
					    <td class="inquire_form6"><input type="text" id="hidden_name" name="hidden_name" class="input_width"    /></td>					 
			 		    <td class="inquire_item6"><font color="red">*</font>识别方法：</td>
					    <td class="inquire_form6">  
					    <select id="identification_method" name="identification_method" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >集中识别</option>
					       <option value="2" >随机识别</option>
					       <option value="3" >专项识别</option>
					       <option value="4" >来访者识别</option>
						</select> 		
					    </td>
					  </tr>		
				 
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>危害因素大类：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="hazard_big" name="hazard_big" class="select_width" onchange="getHazardCenter()"></select> 	
					    </td>
					    <td class="inquire_item6"><font color="red">*</font>危害因素中类：</td>
					    <td class="inquire_form6"> 
					    <select id="hazard_center" name="hazard_center" class="select_width">
						</select> 			
					    </td>
					    </tr>	
					    
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>是否新增：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <select id="whether_new" name="whether_new" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >是</option>
						       <option value="2" >否</option> 
							</select> 	
						    </td>
						    <td class="inquire_item6"><font color="red">*</font>识别人：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="recognition_people" name="recognition_people" class="input_width"   />    		
						    </td>
						    </tr>	
							  <tr>
							    <td class="inquire_item6"><font color="red">*</font>上报日期：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <input type="text" id="report_date" name="report_date" class="input_width"    readonly="readonly"/>
							    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(report_date,tributton1);" />&nbsp;</td>
							    <td class="inquire_item6"><font color="red">*</font>风险级别：</td>
							    <td class="inquire_form6"> 				 
                                <input style=" border-bottom-color:#3333FF; border-bottom-width:1px; background:transparent;  border-top-style:none;   border-left-style:none;   border-right-style:none;" type="text" id="risk_levels" name="risk_levels" value=""  onclick="openFile1()" readonly="readonly" />
                                 <input type="hidden" id="assessment_no" name="assessment_no" class="input_width"   />    	
							    </td>
							    </tr>	
								  <tr>
								    <td class="inquire_item6"><font color="red">*</font>整改状态：</td> 					   
								    <td class="inquire_form6"  align="center" > 
								    <input style=" border-bottom-color:#3333FF; border-bottom-width:1px; background:transparent;  border-top-style:none;   border-left-style:none;   border-right-style:none;" type="text" id="rectification_state" name="rectification_state" value=""  onclick="openFile2()" readonly="readonly" />
								    <input type="hidden" id="corrective_no" name="corrective_no" class="input_width"   />   
								   </td>  
								    <td class="inquire_item6"><font color="red">*</font>奖励状态：</td>
								    <td class="inquire_form6"> 
								    <input style=" border-bottom-color:#3333FF; border-bottom-width:1px; background:transparent;  border-top-style:none;   border-left-style:none;   border-right-style:none;" type="text" id="reward_state" name="reward_state" value=""  onclick="openFile3()" readonly="readonly" />
								    <input type="hidden" id="reward_no" name="reward_no" class="input_width"   />   
								    </td>
								    </tr>	
					    
					     </table>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>隐患描述：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:720px; height:60px;" id="hidden_description" name="hidden_description"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
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
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = " select  tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date,tr.risk_levels,  tr.rectification_state,tr.reward_state,tr.hidden_description  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HIDDEN_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'    order by tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/hseOptionPage/hiddeniInformation/hiddeniInformation.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
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
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "  select  tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date,tr.risk_levels,  tr.rectification_state,tr.reward_state,tr.hidden_description  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HIDDEN_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'  and tr.hidden_name like '%"+changeName+"%'  order by tr.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/hseOptionPage/hiddeniInformation/hiddeniInformation.jsp";
					queryData(1);
				}else{
					alert('请输入查询内容！');
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("changeName").value = "";
	}
	function getHazardBig(){
		var selectObj = document.getElementById("hazard_big"); 
		document.getElementById("hazard_big").innerHTML="";
		selectObj.add(new Option('请选择',""),0);

		var queryHazardBig=jcdpCallService("HseOperationSrv","queryHazardBig","");	
	 
		for(var i=0;i<queryHazardBig.detailInfo.length;i++){
			var templateMap = queryHazardBig.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		var selectObj1 = document.getElementById("hazard_center");
		document.getElementById("hazard_center").innerHTML="";
		selectObj1.add(new Option('请选择',""),0);
	}

	function getHazardCenter(){
	    var hazardBig = "hazardBig="+document.getElementById("hazard_big").value;   
		var HazardCenter=jcdpCallService("HseOperationSrv","queryHazardCenter",hazardBig);	

		var selectObj = document.getElementById("hazard_center");
		document.getElementById("hazard_center").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
		if(HazardCenter.detailInfo!=null){
			for(var i=0;i<HazardCenter.detailInfo.length;i++){
				var templateMap = HazardCenter.detailInfo[i];
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
			}
		}
	}

	function loadDataDetail(shuaId){
		if(shuaId !=null){
			var querySql = "";
			var queryRet = null;
			var  datas =null;	
			querySql = "   select  tr.org_sub_id,tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date,tr.risk_levels,  tr.rectification_state,tr.reward_state,tr.hidden_description  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HIDDEN_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0' and tr.hidden_no='"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 
					 document.getElementsByName("hidden_no")[0].value=datas[0].hidden_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	
	    		     document.getElementsByName("aa")[0].value=datas[0].hazard_big;	    		    
	    			 document.getElementsByName("bb")[0].value=datas[0].hazard_center;	
	    		    document.getElementsByName("operation_post")[0].value=datas[0].operation_post;
	    			document.getElementsByName("hidden_name")[0].value=datas[0].hidden_name;		
	    			document.getElementsByName("identification_method")[0].value=datas[0].identification_method;			
	    		    document.getElementsByName("hazard_big")[0].value=datas[0].hazard_big;		
	    			document.getElementsByName("hazard_center")[0].value=datas[0].hazard_center;		
	    		    document.getElementsByName("whether_new")[0].value=datas[0].whether_new;				    	 		
	    			document.getElementsByName("recognition_people")[0].value=datas[0].recognition_people;
	    			document.getElementsByName("report_date")[0].value=datas[0].report_date;		
	    		    document.getElementsByName("risk_levels")[0].value=datas[0].risk_levels;		
	    		 	document.getElementsByName("rectification_state")[0].value=datas[0].rectification_state;		
	    			document.getElementsByName("reward_state")[0].value=datas[0].reward_state;	
	    		    document.getElementsByName("hidden_description")[0].value=datas[0].hidden_description;		
	    			   if(datas[0].risk_levels ==""){
						   document.getElementsByName("assessment_no")[0].value="";
					   } 
		    	
	    			   if(datas[0].rectification_state ==""){
						   document.getElementsByName("corrective_no")[0].value="";
					   } 
		    			 	
	    			   if(datas[0].reward_state ==""){
						   document.getElementsByName("reward_no")[0].value="";
					   } 
		    			 	
	    			   
	    			   
		         	}					
			
		    	}		
			
			
			querySql = "  select dil.hidden_no ,dil.assessment_no,decode(ion.risk_levels,'1','低风险','2','中风险','3','高风险')risk_levels  from BGP_ASSESSMENT_DETAIL dil left join  BGP_ASSESSMENT_INFORMATION ion on ion.assessment_no=dil.assessment_no and dil.bsflag='0' where ion.bsflag='0' and dil.hidden_no='"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){
					   document.getElementsByName("risk_levels")[0].value=datas[0].risk_levels;	 
					   document.getElementsByName("assessment_no")[0].value=datas[0].assessment_no;	
					 
				}
				}
			
			querySql = "select dil.hidden_no , dil.corrective_no,decode(ion.rectification_state,'1','已整改','2','未整改','3','正在整改')rectification_state  from BGP_CORRECTINVE_DETAIL dil left join  BGP_CORRECTINVE_INFORMATION ion on ion.CORRECTIVE_NO=dil.CORRECTIVE_NO and dil.bsflag='0' where ion.bsflag='0' and dil.hidden_no='"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){
					document.getElementsByName("rectification_state")[0].value=datas[0].rectification_state;	
					   document.getElementsByName("corrective_no")[0].value=datas[0].corrective_no;	
				}
				}
			
			querySql = "  select dil.hidden_no,dil.reward_no,ion.reward_state  from BGP_REWARD_DETAIL dil left join  BGP_REWARD_INFORMATION  ion on ion.REWARD_NO=dil.REWARD_NO and dil.bsflag='0' where ion.bsflag='0'  and dil.hidden_no='"+ shuaId +"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){
					document.getElementsByName("reward_state")[0].value=datas[0].reward_state;	
					   document.getElementsByName("reward_no")[0].value=datas[0].reward_no;	
				}
				}
			
			
			
			
		}
		exitSelect();
	}
	
	
	function openFile1(){
		var assessment_no = document.getElementsByName("assessment_no")[0].value;		
    	popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/riskLevels.jsp?assessment_no="+assessment_no);
		  
	}  		 	  
	    
		function openFile2(){
			var corrective_no = document.getElementsByName("corrective_no")[0].value;		
	    	popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/rectificationState.jsp?corrective_no="+corrective_no);
			  
		} 	
	   function openFile3(){
			var reward_no = document.getElementsByName("reward_no")[0].value;		
	    	popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/rewardState.jsp?reward_no="+reward_no);
			  
		} 
	
	   
	//處理選中的值selected
	 function exitSelect(){
		 
			var selectObj = document.getElementById("hazard_big");  
			var aa = document.getElementById("aa").value; 
			var bb = document.getElementById("bb").value;  
		    for(var i = 0; i<selectObj.length; i++){ 
		        if(selectObj.options[i].value == aa){ 
		        	selectObj.options[i].selected = 'selected';     
		        } 
		       }  
		    var hazardBig = "hazardBig="+ document.getElementById("aa").value;
		    var HazardCenter=jcdpCallService("HseOperationSrv","queryHazardCenter",hazardBig);		 
			var selectObj2 = document.getElementById("hazard_center");
			document.getElementById("hazard_center").innerHTML="";
			selectObj2.add(new Option('请选择',""),0);

			if(HazardCenter.detailInfo!=null){
				for(var t=0;t<HazardCenter.detailInfo.length;t++){
					var templateMap = HazardCenter.detailInfo[t];
					selectObj2.add(new Option(templateMap.label,templateMap.value),t+1);
				}
			}
		    for(var j = 0; j<selectObj2.length; j++){ 
		        if(selectObj2.options[j].value == bb){ 
		        	selectObj2.options[j].selected = 'selected';     
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
		popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/addHiddeniInformation.jsp");
		
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
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/addHiddeniInformation.jsp?hidden_no="+ids);
	  	
	} 
	
	 
	function toDelete(){
 		
	    ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		deleteEntities("update BGP_HIDDEN_INFORMATION e set e.bsflag='1' where e.hidden_no='"+ids+"'");
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/accidentNews/accident_search.jsp");
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

		
	function toUpdate(){
		
		var rowParams = new Array(); 
		var rowParam = {};			
	
		var hidden_no = document.getElementsByName("hidden_no")[0].value;		
				 
		  if(hidden_no !=null && hidden_no !=''){		

				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;			
				
				var operation_post = document.getElementsByName("operation_post")[0].value;
				var hidden_name = document.getElementsByName("hidden_name")[0].value;		
				var identification_method = document.getElementsByName("identification_method")[0].value;			
				var hazard_big = document.getElementsByName("hazard_big")[0].value;		
				var hazard_center = document.getElementsByName("hazard_center")[0].value;		
				var whether_new = document.getElementsByName("whether_new")[0].value;			
		 		
				var recognition_people = document.getElementsByName("recognition_people")[0].value;
				var report_date = document.getElementsByName("report_date")[0].value;		
				var risk_levels = document.getElementsByName("risk_levels")[0].value;		
				var rectification_state = document.getElementsByName("rectification_state")[0].value;		
				var reward_state = document.getElementsByName("reward_state")[0].value;	
				var hidden_description = document.getElementsByName("hidden_description")[0].value;			
				 
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;			
				
				rowParam['operation_post'] = encodeURI(encodeURI(operation_post));
				rowParam['hidden_name'] = encodeURI(encodeURI(hidden_name));
				rowParam['identification_method'] = encodeURI(encodeURI(identification_method));
				rowParam['hazard_big'] = encodeURI(encodeURI(hazard_big));		 		
				rowParam['hazard_center'] = encodeURI(encodeURI(hazard_center));
				rowParam['whether_new'] = encodeURI(encodeURI(whether_new));
						
				rowParam['recognition_people'] = encodeURI(encodeURI(recognition_people));
				rowParam['report_date'] = '<%=curDate%>';
				rowParam['risk_levels'] = encodeURI(encodeURI(risk_levels));
				rowParam['rectification_state'] = encodeURI(encodeURI(rectification_state));		 		
				rowParam['reward_state'] = encodeURI(encodeURI(reward_state));
				rowParam['hidden_description'] = encodeURI(encodeURI(hidden_description));
						 
			    rowParam['hidden_no'] = hidden_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
	 		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_HIDDEN_INFORMATION",rows);	
			    refreshData();	
				alert(保存成功！);
				  
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}
 
 
	 
	function getNum(selectValue){

		applypost_str='<option value="">请选择</option>';
		 
			//选择当前班组
			if(selectValue=='1'){
				applypost_str+='<option value="'+templateMap.value+'" selected="selected" >'+templateMap.label+'</option>';			
			}else{
				applypost_str+='<option value="'+templateMap.value+'" >'+templateMap.label+'</option>';
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

