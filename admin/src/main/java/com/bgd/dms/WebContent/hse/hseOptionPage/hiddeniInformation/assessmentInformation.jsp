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
 
<title>评价信息</title>
</head>

<body style="background:#fff"  onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">评价级别</td>
			    <td class="inquire_form6">		
			    <select id="changeName" name="changeName" class="select_width">
			       <option value="" >请选择</option>
			       <option value="1" >公司</option>
			       <option value="2" >二级单位</option> 
			       <option value="3" >基层单位</option> 
			       <option value="4" >基层单位下属单位</option>  
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{assessment_no}' value='{assessment_no}' onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{evaluation_numbers}">评价编号</td>
			      <td class="bt_info_even" exp="{evaluation_date}">评价日期</td>
			      <td class="bt_info_odd" exp="{evaluation_level}">评价级别</td>
			      <td class="bt_info_even" exp="{risk_levels}">风险级别</td>
			      <td class="bt_info_odd" exp="{evaluation_state}">评价状态</td>

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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">评价隐患列表</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">评价信息</a></li>	
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
	          	    <TD  class="bt_info_even"  width="45%"><font color=red>隐患名称</font></TD>
	          		<TD  class="bt_info_odd" width="45%" ><font color=red>上报日期</font></TD>
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
					  <td class="inquire_item6"><font color="red">*</font>基层单位：</td>
				      	<td class="inquire_form6">
			 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
				      	<input type="hidden" id="create_date" name="create_date" value="" />
				      	<input type="hidden" id="creator" name="creator" value="" />
				      	<input type="hidden" id="assessment_no" name="assessment_no"   />
				     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
				      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
				      	<%}%>
				      	</td> 
				    <td class="inquire_item6"><font color="red">*</font>评价编号：</td>
				    <td class="inquire_form6">
				    <input type="text" id="evaluation_numbers" name="evaluation_numbers" class="input_width"  readonly="readonly" />    					    
				    </td>					    
					</tr>						
				  <tr>	
				    <td class="inquire_item6"><font color="red">*</font>评价日期：</td>
				    <td class="inquire_form6"><input type="text" id="evaluation_date" name="evaluation_date" class="input_width"   readonly="readonly"  /></td>	 
				    <td class="inquire_item6"><font color="red">*</font>评价级别：</td> 					   
				    <td class="inquire_form6"  align="center" > 
				    <select id="evaluation_level" name="evaluation_level" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >公司</option>
				       <option value="2" >二级单位</option> 
				       <option value="3" >基层单位</option> 
				       <option value="4" >基层单位下属单位</option>  
					</select> 	
				    </td>
				    </tr>	
					  <tr>	
					    <td class="inquire_item6"><font color="red">*</font>评价人员：</td>
					    <td class="inquire_form6"><input type="text" id="evaluation_personnel" name="evaluation_personnel" class="input_width"    /></td>	 
					    <td class="inquire_item6"><font color="red">*</font>主要评价方法：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="main_methods" name="main_methods" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >矩阵法</option>
					       <option value="2" >LEC</option> 
					       <option value="3" >HAZOP</option>
					       <option value="4" >专家评估法</option> 
					       <option value="5" >安全检查表法</option>
					       <option value="6" >默认为矩阵法</option> 
						</select>  
					    </td>
					    </tr>	
					    <tr>	
					    <td class="inquire_item6"><font color="red">*</font>评价状态：</td>
					    <td class="inquire_form6"><input type="text" id="evaluation_state" name="evaluation_state" class="input_width"     readonly="readonly"       /></td>	 
					    <td class="inquire_item6"><font color="red">*</font>风险级别：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="risk_levels" name="risk_levels" class="select_width">
					       <option value="" >请选择</option>
					       <option value="1" >低风险</option>
					       <option value="2" >中风险</option> 
					       <option value="3" >高风险</option> 
						</select> 	
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
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "   select  tr.org_sub_id,tr.assessment_no,tr.evaluation_numbers,tr.evaluation_date,tr.evaluation_personnel,tr.main_methods, decode(tr.evaluation_level,'1','公司','2','二级单位','3','基层单位','4','基层单位下属单位')evaluation_level,decode(tr.risk_levels,'1','低风险','2','中风险','3','高风险') risk_levels,tr.evaluation_state  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_ASSESSMENT_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'   order by tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/hseOptionPage/hiddeniInformation/assessmentInformation.jsp";
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
					cruConfig.queryStr = "   select  tr.org_sub_id,tr.assessment_no,tr.evaluation_numbers,tr.evaluation_date,tr.evaluation_level,tr.evaluation_personnel,tr.main_methods,tr.risk_levels,tr.evaluation_state  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_ASSESSMENT_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'  and tr.evaluation_level='"+ changeName +"'  order by tr.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/hseOptionPage/hiddeniInformation/assessmentInformation.jsp";
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
			querySql = "    select  tr.org_sub_id,tr.assessment_no,tr.evaluation_numbers,tr.evaluation_date,tr.evaluation_level,tr.evaluation_personnel,tr.main_methods,tr.risk_levels,tr.evaluation_state  ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_ASSESSMENT_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0' and tr.assessment_no='"+ shuaId +"'";					 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 
					 document.getElementsByName("assessment_no")[0].value=datas[0].assessment_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	
		    		 
	    		     document.getElementsByName("evaluation_numbers")[0].value=datas[0].evaluation_numbers;	    		    
	    			 document.getElementsByName("evaluation_date")[0].value=datas[0].evaluation_date;	
	    		    document.getElementsByName("evaluation_level")[0].value=datas[0].evaluation_level;
	    			document.getElementsByName("evaluation_personnel")[0].value=datas[0].evaluation_personnel;		
	    			document.getElementsByName("main_methods")[0].value=datas[0].main_methods;				    			
	    		    document.getElementsByName("risk_levels")[0].value=datas[0].risk_levels;		
	    			document.getElementsByName("evaluation_state")[0].value=datas[0].evaluation_state;		
	         	     	  
		         	}					
			
		    	}		
				
				 var querySql1="";
				 var queryRet1=null;
				 var datas1 =null;
				 deleteTableTr("hseTableInfo");
		    	 document.getElementById("lineNum").value="0";	
				   querySql1 = " select dl.adetail_no ,dl.assessment_no,dl.hidden_no,dl.hidden_name,dl.report_date, dl.creator,dl.create_date,dl.updator,dl.modifi_date,dl.bsflag  from BGP_ASSESSMENT_DETAIL dl  where dl.bsflag='0' and dl.assessment_no='" + shuaId + "'  order by  dl.modifi_date";
				   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
					if(queryRet1.returnCode=='0'){
					  datas1 = queryRet1.datas;	
	
						if(datas1 != null && datas1 != ''){							 
						  						 
							for(var i = 0; i<datas1.length; i++){	 	
					       addLine1(datas1[i].adetail_no,datas1[i].assessment_no,datas1[i].hidden_no,datas1[i].hidden_name,datas1[i].report_date,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
					       				      
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
		popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/addAssessment.jsp");
		
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
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/addAssessment.jsp?assessment_no="+ids);
	  	
	} 
	
	 
	function toDelete(){
 		
	    ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	 
	     var querySql1="";
         var queryRet1=null;
         var datas1 =null;
         querySql1 = "select dil.hidden_no  from BGP_ASSESSMENT_DETAIL dil left join  BGP_ASSESSMENT_INFORMATION ion on ion.assessment_no=dil.assessment_no and dil.bsflag='0' where ion.bsflag='0' and  ion.assessment_no='"+ ids +"'";;
         queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
        
	       	if(queryRet1.returnCode=='0'){
	       	  datas1 = queryRet1.datas;	 
	       		if(datas1 != null && datas1 != ''){	  
	       			var risk_levelsChar="";       	 
	       			for(var i = 0; i<datas1.length; i++){	 
	       				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	       				var submitStr = 'JCDP_TABLE_NAME=BGP_HIDDEN_INFORMATION&JCDP_TABLE_ID='+datas1[i].hidden_no +'&risk_levels='+risk_levelsChar
	       				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
	       			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
	        
	       			}
	
	       		}
	       		
	       	}
           
		deleteEntities("update BGP_ASSESSMENT_INFORMATION e set e.bsflag='1' where e.assessment_no='"+ids+"'");
	 
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
	
		var assessment_no = document.getElementsByName("assessment_no")[0].value;		
				 
		  if(assessment_no !=null && assessment_no !=''){		
				var assessment_no = document.getElementsByName("assessment_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;		
			
				var evaluation_numbers = document.getElementsByName("evaluation_numbers")[0].value;
				var evaluation_date = document.getElementsByName("evaluation_date")[0].value;		
				 
	    		   var evaluation_level=document.getElementsByName("evaluation_level")[0].value;
	    		   var evaluation_personnel=document.getElementsByName("evaluation_personnel")[0].value;		
	    		   var main_methods=document.getElementsByName("main_methods")[0].value;				    			
	    		   var risk_levels=document.getElementsByName("risk_levels")[0].value;		
	    		   var evaluation_state=document.getElementsByName("evaluation_state")[0].value;		
	                if(main_methods ==""){
	                	main_methods="1";	                	
	                }				 
	                
	             var querySql1="";
	             var queryRet1=null;
	             var datas1 =null;
 
	              querySql1 = "select dil.hidden_no  from BGP_ASSESSMENT_DETAIL dil left join  BGP_ASSESSMENT_INFORMATION ion on ion.assessment_no=dil.assessment_no and dil.bsflag='0' where ion.bsflag='0' and  ion.assessment_no='"+ assessment_no +"'";;
	              queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
	             
	            	if(queryRet1.returnCode=='0'){
	            	  datas1 = queryRet1.datas;	 
	            		if(datas1 != null && datas1 != ''){	  
	            			var risk_levelsChar="";
	            			if(risk_levels =='1'){
	            				risk_levelsChar="低风险";
	            			}else if(risk_levels =='2'){
	            				risk_levelsChar="中风险";
	            			}else if(risk_levels =='3'){
	            				risk_levelsChar="高风险";
	            			} 
	            			for(var i = 0; i<datas1.length; i++){	 
	            				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	            				var submitStr = 'JCDP_TABLE_NAME=BGP_HIDDEN_INFORMATION&JCDP_TABLE_ID='+datas1[i].hidden_no +'&risk_levels='+risk_levelsChar
	            				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
	            			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
	             
	            			}
 
	            		}
	            		
	            	}
	                
	                
	                
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;							
				rowParam['evaluation_numbers'] = encodeURI(encodeURI(evaluation_numbers));
				rowParam['evaluation_date'] =  '<%=curDate%>';
				rowParam['evaluation_level'] = encodeURI(encodeURI(evaluation_level));
				rowParam['evaluation_personnel'] = encodeURI(encodeURI(evaluation_personnel));
				rowParam['main_methods'] = encodeURI(encodeURI(main_methods));
				rowParam['risk_levels'] = encodeURI(encodeURI(risk_levels));
				rowParam['evaluation_state'] = encodeURI(encodeURI(evaluation_state));
				
			    rowParam['assessment_no'] = assessment_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
	 		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_ASSESSMENT_INFORMATION",rows);	
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
		var assessment_nos = document.getElementsByName("assessment_no")[0].value;	
					
		 if(assessment_nos !=null && assessment_nos !=''){
		for(var i=0;i<rowNum;i++){
			var rowParam = {};			
 
			var adetail_no =document.getElementsByName("adetail_no_"+i)[0].value; 
			var assessment_no =document.getElementsByName("assessment_no_"+i)[0].value;
			var hidden_no = document.getElementsByName("hidden_no_"+i)[0].value;
			var hidden_name = document.getElementsByName("hidden_name_"+i)[0].value;
			var report_date =document.getElementsByName("report_date_"+i)[0].value;
 
			var creator = document.getElementsByName("creator_"+i)[0].value;
			var create_date = document.getElementsByName("create_date_"+i)[0].value;
			var updator = document.getElementsByName("updator_"+i)[0].value;
			var modifi_date =document.getElementsByName("modifi_date_"+i)[0].value;
			var bsflag =document.getElementsByName("bsflag_"+i)[0].value;
			if(adetail_no !=null && adetail_no !=''){			
 				rowParam['hidden_name'] = encodeURI(encodeURI(hidden_name));
				rowParam['report_date'] = encodeURI(encodeURI(report_date));
				rowParam['hidden_no'] = encodeURI(encodeURI(hidden_no));
			 
			    rowParam['adetail_no'] = adetail_no;
			    rowParam['assessment_no'] = assessment_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;	
				
			}else{
				rowParam['hidden_name'] = encodeURI(encodeURI(hidden_name));
				rowParam['report_date'] = encodeURI(encodeURI(report_date));
				rowParam['hidden_no'] = encodeURI(encodeURI(hidden_no));
			 		
			    rowParam['assessment_no'] = assessment_nos;
				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
			}
				rowParams[rowParams.length] = rowParam; 
 
		}
			var rows=JSON.stringify(rowParams);			 
			saveFunc("BGP_ASSESSMENT_DETAIL",rows);	
			frames[1].refreshData();	
			alert('保存成功！');	
			
      }else{			  
			  alert("请先选中一条记录!");
		     	return;		
      }				
		
}
	
	function openAdd(){
		 window.open("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/homeFrame.jsp?optionP=1",'homeMain','height=500,width=1000px,left=100px,top=100px,menubar=no,status=no,toolbar=no ', '');
		
	}
 	function addLine1(adetail_nos,assessment_nos,hidden_nos,hidden_names,report_dates,creators,create_dates,updators,modifi_dates,bsflags){
 	 
		var adetail_no = "";
		var assessment_no = "";
		var hidden_no = "";
		var hidden_name = "";
		var report_date = "";
		
		var creator = "";
		var create_date = "";
		var updator = "";
		var modifi_date = "";
		var bsflag = "";

		if(adetail_nos != null && adetail_nos != ""){
			adetail_no=adetail_nos;
		}
		if(assessment_nos != null && assessment_nos != ""){
			assessment_no=assessment_nos;
		}
		if(hidden_nos != null && hidden_nos != ""){
			hidden_no=hidden_nos;
		}
		
		if(hidden_names != null && hidden_names != ""){
			hidden_name=hidden_names;
		}
		if(report_dates != null && report_dates != ""){
			report_date=report_dates;
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
 
		tr.insertCell().innerHTML = '<input type="hidden"  name="adetail_no' + '_' + rowNum + '" value="'+adetail_no+'"/>'+'<input type="text" style="width:360px;" class="input_width" name="hidden_name' + '_' + rowNum + '" value="'+hidden_name+'" readonly="readonly"  />'+'<input type="hidden"  name="assessment_no' + '_' + rowNum + '" value="'+assessment_no+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="'+bsflag+'"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
		tr.insertCell().innerHTML = '<input type="hidden"  name="hidden_no' + '_' + rowNum + '" value="'+hidden_no+'"/>'+'<input type="text" style="width:360px;" class="input_width" name="report_date' + '_' + rowNum + '" value="'+report_date+'"  readonly="readonly" />';
 
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

