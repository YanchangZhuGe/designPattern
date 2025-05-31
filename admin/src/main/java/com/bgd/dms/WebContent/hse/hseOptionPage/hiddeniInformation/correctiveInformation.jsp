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
 
<title>整改信息</title>
</head>

<body style="background:#fff"  onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">整改状态</td>
			    <td class="inquire_form6">	 
			    <select id="changeName" name="changeName" class="select_width">
			       <option value="" >请选择</option>
			       <option value="1" >已整改</option>
			       <option value="2" >未整改</option> 
			       <option value="3" >正在整改</option> 
				</select> 	
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{corrective_no}' value='{corrective_no}' onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{rectification_numbers}">整改编号</td>
			      <td class="bt_info_even" exp="{rectification_state}">整改状态</td>
			      <td class="bt_info_odd" exp="{rectification_measures_type}">整改措施类型</td>
			      <td class="bt_info_even" exp="{rectification_date}">整改完成日期</td>
			      <td class="bt_info_odd" exp="{control_effect}">控制效果</td>

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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">整改隐患列表</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">整改信息</a></li>	
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
	          	    <TD  class="bt_info_even"  width="35%"><font color=red>隐患名称</font></TD>
	          		<TD  class="bt_info_odd" width="35%" ><font color=red>评价日期</font></TD>
	          	   <TD  class="bt_info_even"  width="20%"><font color=red>风险级别</font></TD>
	          		<input type="hidden" id="equipmentSize" name="equipmentSize"   value="0" />
	          		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
	          		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />	
	          		<input type="hidden" id="lineNum" value="0"/>
	          		<TD class="bt_info_odd" width="5%">操作</TD>
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
					  <td class="inquire_item6"><font color="red">*</font>基层单位：</td>
				      	<td class="inquire_form6">
			 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
				      	<input type="hidden" id="create_date" name="create_date" value="" />
				      	<input type="hidden" id="creator" name="creator" value="" />
				      	<input type="hidden" id="corrective_no" name="corrective_no"   />
				     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
				      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
				      	<%}%>
				      	</td> 
				        <td class="inquire_item6"><font color="red">*</font>整改编号：</td>
					    <td class="inquire_form6">
					    <input type="text" id="rectification_numbers" name="rectification_numbers" class="input_width"  style="color:gray;" value="自动生成"   readonly="readonly" />    					    
					    </td>						    
					</tr>						
				  <tr>	
				  <td class="inquire_item6"><font color="red">*</font>整改状态：</td>
				    <td class="inquire_form6">
				    <select id="rectification_state" name="rectification_state" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >已整改</option>
				       <option value="2" >未整改</option> 
				       <option value="3" >正在整改</option>  
					</select> 
				    </td>	 	 
				    <td class="inquire_item6"><font color="red">*</font>整改措施类型：</td> 					   
				    <td class="inquire_form6"  align="center" > 
				    <select id="rectification_measures_type" name="rectification_measures_type" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >消除</option>
				       <option value="2" >工程/设计</option> 
				       <option value="3" >行政/程序</option> 
				       <option value="4" >劳保</option>   
					</select> 	
				    </td>   

				    </tr>	
					  <tr>	
					    <td class="inquire_item6"><font color="red">*</font>整改措施：</td>
					    <td class="inquire_form6"><input type="text" id="rectification_measures" name="rectification_measures" class="input_width"    /></td>	 
					    <td class="inquire_item6"><font color="red">*</font>控制效果：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="control_effect" name="control_effect" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >消除</option>
					       <option value="2" >降低</option> 
						</select>  
					    </td>
					    </tr>	
					    <tr>	
					    <td class="inquire_item6"><font color="red">*</font>整改完成时间：</td>
					    <td class="inquire_form6"><input type="text" id="rectification_date" name="rectification_date" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(rectification_date,tributton1);" />&nbsp;</td>
					  </tr>	 
			   </table>
			   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
				  <tr>
				    <td class="inquire_item6"><font color="red"></font>未整改原因：</td> 					   
				    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:720px; height:60px;" id="rectification_reason" name="rectification_reason"   class="textarea" ></textarea></td>
				    <td class="inquire_item6"> </td> 				 
				  </tr>		
				  <tr>  
				    <td class="inquire_item6"><font color="red"></font>整改计划：</td> 					   
				    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:720px; height:60px;" id="action_plan" name="action_plan"   class="textarea" ></textarea></td>
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
		cruConfig.queryStr = "   select  decode(tr.rectification_state,'1','已整改','2','未整改','3','正在整改')rectification_state,decode(tr.rectification_measures_type,'1','消除','2','工程/设计','3','行政/程序','4','劳保') rectification_measures_type,decode(tr.control_effect,'1','消除','2','降低') control_effect, tr.org_sub_id, tr.corrective_no,tr.rectification_numbers,tr.rectification_measures,tr.rectification_date, tr.rectification_reason,tr.action_plan  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_CORRECTINVE_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'  order by tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/hseOptionPage/hiddeniInformation/correctiveInformation.jsp";
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
					cruConfig.queryStr = "   select  tr.org_sub_id,tr.corrective_no,tr.evaluation_numbers,tr.evaluation_date,tr.evaluation_level,tr.evaluation_personnel,tr.main_methods,tr.risk_levels,tr.evaluation_state  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_ASSESSMENT_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'  and tr.evaluation_level='"+ changeName +"'  order by tr.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/hseOptionPage/hiddeniInformation/correctiveInformation.jsp";
					queryData(1);
				}else{
					alert('请输入查询内容！');
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
			querySql = "    select  tr.org_sub_id, tr.corrective_no,tr.rectification_numbers,tr.rectification_state,tr.rectification_measures,tr.rectification_measures_type,tr.rectification_date,tr.control_effect, tr.rectification_reason,tr.action_plan  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_CORRECTINVE_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0' and tr.corrective_no='"+ shuaId +"'";	 				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 
					 document.getElementsByName("corrective_no")[0].value=datas[0].corrective_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	 
		    		 
		    		 document.getElementsByName("rectification_numbers")[0].value=datas[0].rectification_numbers;
		    		 document.getElementsByName("rectification_state")[0].value=datas[0].rectification_state;	 
	    		     document.getElementsByName("rectification_measures")[0].value=datas[0].rectification_measures;	    		    
	    			 document.getElementsByName("rectification_measures_type")[0].value=datas[0].rectification_measures_type;	
	    		    document.getElementsByName("rectification_date")[0].value=datas[0].rectification_date;
	    			document.getElementsByName("control_effect")[0].value=datas[0].control_effect;		
	    			document.getElementsByName("rectification_reason")[0].value=datas[0].rectification_reason;				    			
	    		    document.getElementsByName("action_plan")[0].value=datas[0].action_plan;	 
		         	}					
			
		    	}		
				
				 var querySql1="";
				 var queryRet1=null;
				 var datas1 =null;
				 deleteTableTr("hseTableInfo");
		    	 document.getElementById("lineNum").value="0";	
		     
				   querySql1 = " select  cdl.cdetail_no,cdl.corrective_no,cdl.hidden_no,cdl.chidden_name,cdl.creport_date,cdl.crisk_levels , cdl.creator,cdl.create_date,cdl.updator,cdl.modifi_date,cdl.bsflag  from BGP_CORRECTINVE_DETAIL cdl  where cdl.bsflag='0' and cdl.corrective_no='" + shuaId + "'  order by  cdl.modifi_date";
				   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
					if(queryRet1.returnCode=='0'){
					  datas1 = queryRet1.datas;	
	
						if(datas1 != null && datas1 != ''){							 
						  						 
							for(var i = 0; i<datas1.length; i++){	 	
					      addLine1(datas1[i].cdetail_no,datas1[i].corrective_no,datas1[i].hidden_no,datas1[i].chidden_name,datas1[i].creport_date,datas1[i].crisk_levels,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
					       				      
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
		popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/addCorrective.jsp");
		
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
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/addCorrective.jsp?corrective_no="+ids);
	  	
	} 
	
	 
	function toDelete(){
 		
	    ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	     var querySql1="";
         var queryRet1=null;
         var datas1 =null; 
         querySql1 = "select dil.hidden_no    from BGP_CORRECTINVE_DETAIL dil left join  BGP_CORRECTINVE_INFORMATION ion on ion.CORRECTIVE_NO=dil.CORRECTIVE_NO and dil.bsflag='0' where ion.bsflag='0' and  ion.corrective_no='"+ ids +"'";;
         queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
	        
	       	if(queryRet1.returnCode=='0'){
	       	  datas1 = queryRet1.datas;	 
	       		if(datas1 != null && datas1 != ''){	 
	       			var rectification_Char=""; 
	       			for(var i = 0; i<datas1.length; i++){ 
	       				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	       				var submitStr = 'JCDP_TABLE_NAME=BGP_HIDDEN_INFORMATION&JCDP_TABLE_ID='+datas1[i].hidden_no +'&rectification_state='+rectification_Char
	       				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
	       			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
	        
	       			}
	
	       		}
	       		
	       	}
       	
		deleteEntities("update BGP_CORRECTINVE_INFORMATION e set e.bsflag='1' where e.corrective_no='"+ids+"'");
	 
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
	
		var corrective_no = document.getElementsByName("corrective_no")[0].value;		
				 
		  if(corrective_no !=null && corrective_no !=''){		
				var corrective_no = document.getElementsByName("corrective_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;		
			
				 var rectification_numbers=document.getElementsByName("rectification_numbers")[0].value;
				 var rectification_state=document.getElementsByName("rectification_state")[0].value;	 
				 var rectification_measures=document.getElementsByName("rectification_measures")[0].value;	    		    
				 var rectification_measures_type=document.getElementsByName("rectification_measures_type")[0].value;	
				 var rectification_date=document.getElementsByName("rectification_date")[0].value;
				 var control_effect=document.getElementsByName("control_effect")[0].value;		
				 var rectification_reason=document.getElementsByName("rectification_reason")[0].value;				    			
				 var action_plan=document.getElementsByName("action_plan")[0].value;		
 
				 if(rectification_state =="2"){
					 if(rectification_reason ==""){
						 alert("整改状态选择未整改时,未整改原因必填!");
						 return;
					 }
					 if(action_plan ==""){
						 alert("整改状态选择未整改时,整改计划必填!");
						 return;
					 }
				 }
				 
		            
	             var querySql1="";
	             var queryRet1=null;
	             var datas1 =null; 
	              querySql1 = "select dil.hidden_no    from BGP_CORRECTINVE_DETAIL dil left join  BGP_CORRECTINVE_INFORMATION ion on ion.CORRECTIVE_NO=dil.CORRECTIVE_NO and dil.bsflag='0' where ion.bsflag='0' and  ion.corrective_no='"+ corrective_no +"'";;
	              queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
	             
	            	if(queryRet1.returnCode=='0'){
	            	  datas1 = queryRet1.datas;	 
	            		if(datas1 != null && datas1 != ''){	 
	            			var rectification_Char="";
	            			if(rectification_state =='1'){
	            				rectification_Char="已整改";
	            			}else if(rectification_state =='2'){
	            				rectification_Char="未整改";
	            			}else if(rectification_state =='3'){
	            				rectification_Char="正在整改";
	            			} 
	            			for(var i = 0; i<datas1.length; i++){ 
	            				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	            				var submitStr = 'JCDP_TABLE_NAME=BGP_HIDDEN_INFORMATION&JCDP_TABLE_ID='+datas1[i].hidden_no +'&rectification_state='+rectification_Char
	            				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
	            			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
	             
	            			}
 
	            		}
	            		
	            	}
	                
	                
				 
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;							
				rowParam['rectification_numbers'] = encodeURI(encodeURI(rectification_numbers));
				rowParam['rectification_state'] =  rectification_state;
				rowParam['rectification_measures'] = encodeURI(encodeURI(rectification_measures));
				rowParam['rectification_measures_type'] = encodeURI(encodeURI(rectification_measures_type));
				rowParam['rectification_date'] = encodeURI(encodeURI(rectification_date));
				rowParam['control_effect'] = encodeURI(encodeURI(control_effect));
				rowParam['rectification_reason'] = encodeURI(encodeURI(rectification_reason));
				rowParam['action_plan'] = encodeURI(encodeURI(action_plan));
				
			    rowParam['corrective_no'] = corrective_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
	 		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_CORRECTINVE_INFORMATION",rows);	
			    refreshData();	
				alert(保存成功！);
				  
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}

	function toUpdate1(){	
		var rowNum = document.getElementById("lineNum").value;			
		var rowParams = new Array();
		var corrective_nos = document.getElementsByName("corrective_no")[0].value;	
					
		 if(corrective_nos !=null && corrective_nos !=''){
		for(var i=0;i<rowNum;i++){
			var rowParam = {};			
			
			var cdetail_no =document.getElementsByName("cdetail_no_"+i)[0].value; 
			var corrective_no =document.getElementsByName("corrective_no_"+i)[0].value;
			var hidden_no = document.getElementsByName("hidden_no_"+i)[0].value;
			var chidden_name = document.getElementsByName("chidden_name_"+i)[0].value;
			var creport_date =document.getElementsByName("creport_date_"+i)[0].value;
			var crisk_levels =document.getElementsByName("crisk_levels_"+i)[0].value;
			
			var creator = document.getElementsByName("creator_"+i)[0].value;
			var create_date = document.getElementsByName("create_date_"+i)[0].value;
			var updator = document.getElementsByName("updator_"+i)[0].value;
			var modifi_date =document.getElementsByName("modifi_date_"+i)[0].value;
			var bsflag =document.getElementsByName("bsflag_"+i)[0].value;
			if(cdetail_no !=null && cdetail_no !=''){			
 				rowParam['chidden_name'] = encodeURI(encodeURI(chidden_name));
				rowParam['creport_date'] = encodeURI(encodeURI(creport_date));
				rowParam['crisk_levels'] = encodeURI(encodeURI(crisk_levels));				
				rowParam['hidden_no'] = encodeURI(encodeURI(hidden_no));
			 
			    rowParam['cdetail_no'] = cdetail_no;
			    rowParam['corrective_no'] = corrective_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;	
				
			}else{
				rowParam['chidden_name'] = encodeURI(encodeURI(chidden_name));
				rowParam['creport_date'] = encodeURI(encodeURI(creport_date));
				rowParam['crisk_levels'] = encodeURI(encodeURI(crisk_levels));				
				rowParam['hidden_no'] = encodeURI(encodeURI(hidden_no));
			 		
			    rowParam['corrective_no'] = corrective_nos;
				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
			}
				rowParams[rowParams.length] = rowParam; 
 
		}
			var rows=JSON.stringify(rowParams);			 
			saveFunc("BGP_CORRECTINVE_DETAIL",rows);	
			frames[2].refreshData();	
			alert('保存成功！');	
			
      }else{			  
			  alert("请先选中一条记录!");
		     	return;		
      }				
		
}
	
	function openAdd(){
		 window.open("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/ChomeFrame.jsp?optionP=1",'homeMain','height=500,width=1000px,left=100px,top=100px,menubar=no,status=no,toolbar=no ', '');
		
	}
	
 	function addLine1(cdetail_nos,corrective_nos,hidden_nos,chidden_names,creport_dates,crisk_levelss,creators,create_dates,updators,modifi_dates,bsflags){
 	 
		var cdetail_no = "";
		var corrective_no = "";
		var hidden_no = "";
		var chidden_name = "";
		var creport_date = "";
		var crisk_levels = "";
	
		var creator = "";
		var create_date = "";
		var updator = "";
		var modifi_date = "";
		var bsflag = "";
		
		
		if(cdetail_nos != null && cdetail_nos != ""){
			cdetail_no=cdetail_nos;
		}
		if(corrective_nos != null && corrective_nos != ""){
			corrective_no=corrective_nos;
		}
		if(hidden_nos != null && hidden_nos != ""){
			hidden_no=hidden_nos;
		}
		
		if(chidden_names != null && chidden_names != ""){
			chidden_name=chidden_names;
		}
		if(creport_dates != null && creport_dates != ""){
			creport_date=creport_dates;
		}
		
		if(crisk_levelss != null && crisk_levelss != ""){
			crisk_levels=crisk_levelss;
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
		
		tr.insertCell().innerHTML = '<input type="hidden"  name="cdetail_no' + '_' + rowNum + '" value="'+cdetail_no+'"/>'+'<input type="text" style="width:360px;" class="input_width" name="chidden_name' + '_' + rowNum + '" value="'+chidden_name+'" readonly="readonly"  />'+'<input type="hidden"  name="corrective_no' + '_' + rowNum + '" value="'+corrective_no+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
		tr.insertCell().innerHTML = '<input type="hidden"  name="hidden_no' + '_' + rowNum + '" value="'+hidden_no+'"/>'+'<input type="text" style="width:300px;" class="input_width" name="creport_date' + '_' + rowNum + '" value="'+creport_date+'"  readonly="readonly" />';
		tr.insertCell().innerHTML = '<input type="text" style="width:330px;" class="input_width" name="crisk_levels' + '_' + rowNum + '" value="'+crisk_levels+'"  readonly="readonly" />';
		 
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

