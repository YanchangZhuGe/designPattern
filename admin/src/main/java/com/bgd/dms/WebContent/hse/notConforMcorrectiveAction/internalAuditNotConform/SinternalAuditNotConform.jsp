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
	String projectInfoNo = user.getProjectInfoNo();
	if (projectInfoNo == null || projectInfoNo.equals("")){
		projectInfoNo = "";
	}
	
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
 
<title>内审不符合项</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">验证情况</td>
			    <td class="ali_cdn_input">
			    <select id="ifBuild" name="ifBuild" class="select_width">
			       <option value="" >请选择</option>
			       <option value="1" >合格</option>
			       <option value="2" >不合格</option>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{inter_no}' value='{inter_no}' onclick=doCheck(this) />" >
			      <input type='checkbox' name='chx_entity_id' id='chx_entity_id' value='' onclick='check(this)' /></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td>
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{not_conform_num}">不符合条款号</td> 
			      <td class="bt_info_even" exp="{completion_date}">整改完成日期</td> 
			      <td class="bt_info_odd" exp="{verify_date}">验证日期</td> 
			      <td class="bt_info_even" exp="{situation_name}">验证情况</td> 
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
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
						    <td class="inquire_item6"><font color="red">*</font>单位：</td>
				        	<td class="inquire_form6">
				        	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />					     
					      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				        	<%} %>
				        	</td>
				          	<td class="inquire_item6"><font color="red">*</font>基层单位：</td>
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
						      	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
						      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
						      	<input type="hidden" id="create_date" name="create_date" value="" />
						    	<input type="hidden" id="project_no" name="project_no" value="" />
						      	<input type="hidden" id="creator" name="creator" value="" />
						      	<input type="hidden" id="inter_no" name="inter_no"   />
						       	<input type="hidden" id="third_org" name="third_org" class="input_width" />
						      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
						      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
						      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
						      	<%}%>
						      	</td>
						      
		     			      	 <td class="inquire_item6"><font color="red">*</font>不符合条款号：</td>
								    <td class="inquire_form6">
								    <input type="text" id="not_conform_num" name="not_conform_num"    class="input_width"/>
								    </td>
						  </tr>					  
							<tr> 
							 <td class="inquire_item6"><font color="red">*</font>整改完成日期：</td>
							    <td class="inquire_form6">
							    <input type="text" id="completion_date" name="completion_date" class="input_width"    readonly="readonly"/>
							    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(completion_date,tributton1);" />&nbsp;</td>
						  
							    </td>					
							
					        <td class="inquire_item6"><font color="red">*</font>验证日期：</td>					 
						    <td class="inquire_form6"> 
						    <input type="text" id="verify_date" name="verify_date" class="input_width"    readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(verify_date,tributton2);" />&nbsp;</td>
					  
	 					    </td>	
							</tr>
							
						  <tr>	 
						   <td class="inquire_item6"><font color="red">*</font>验证情况：</td>
						    <td class="inquire_form6">
						    <select id="validation_situation" name="validation_situation" class="select_width">
						       <option value="" >请选择</option>
						       <option value="1" >合格</option>
						       <option value="2" >不合格</option>
							</select>
						    </td>					   			   
						  </tr>	
						</table>
						  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>不符合项内容：</td> 					   
						    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:700px; height:60px;" id="close_content" name="close_content"   class="textarea" ></textarea>
						    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectContent()"/>
						    </td>
						    <td class="inquire_item6"></td>
						  </tr>	
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>整改要求：</td> 					   
						    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:700px;height:60px;" id="requirements" name="requirements"   class="textarea" ></textarea></td>
						    <td class="inquire_item6"></td>
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
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = " select  decode(tr.validation_situation,'1','合格','2','不合格') situation_name, tr.org_sub_id,tr.inter_no,tr.not_conform_num,tr.completion_date,tr.verify_date,tr.validation_situation,tr.not_content,tr.requirements ,  tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name from BGP_INTER_NOT_CONFORM tr    join comm_org_subjection os1   on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'  join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  join comm_org_information oi2  on oi2.org_id = os2.org_id  and oi2.bsflag = '0'  join comm_org_information ion  on ion.org_id = os1.org_id  where tr.bsflag = '0'   order by tr.modifi_date desc ";
		cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/internalAuditNotConform/internalAuditNotConform.jsp";
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
			var ifBuild = document.getElementById("ifBuild").value;
				if(ifBuild!=''&& ifBuild!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "select  decode(tr.validation_situation,'1','合格','2','不合格') situation_name, tr.org_sub_id,tr.inter_no,tr.not_conform_num,tr.completion_date,tr.verify_date,tr.validation_situation,tr.not_content,tr.requirements ,  tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name from BGP_INTER_NOT_CONFORM tr    join comm_org_subjection os1   on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'  join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  join comm_org_information oi2  on oi2.org_id = os2.org_id  and oi2.bsflag = '0'  join comm_org_information ion  on ion.org_id = os1.org_id  where tr.bsflag = '0'  and tr.validation_situation='"+ ifBuild +"'  order by tr.modifi_date desc ";
					cruConfig.currentPageUrl = "/hse/notConforMcorrectiveAction/internalAuditNotConform/internalAuditNotConform.jsp";
					queryData(1);
				}else{
					alert('请输入查询信息');
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("projectNames").value = "";
	}

	function loadDataDetail(shuaId){
		var obj = event.srcElement;
		if(obj.tagName.toLowerCase() =='td'){
			obj.parentNode.cells[0].firstChild.checked = 'checked';
		}
		if(shuaId !=null){		 
			var querySql = "";
			var queryRet = null;
			var  datas =null;		
			
			querySql = "  select  tr.org_sub_id,tr.inter_no,tr.not_conform_num,tr.completion_date,tr.verify_date,tr.validation_situation,tr.not_content,tr.requirements ,  tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name from BGP_INTER_NOT_CONFORM tr    join comm_org_subjection os1   on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'  join comm_org_subjection os2  on tr.third_org = os2.org_subjection_id  and os2.bsflag = '0'  join comm_org_information oi2  on oi2.org_id = os2.org_id  and oi2.bsflag = '0'  join comm_org_information ion  on ion.org_id = os1.org_id  where tr.bsflag = '0' and tr.inter_no='"+shuaId+"'";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){	
		             document.getElementsByName("inter_no")[0].value=datas[0].inter_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		      		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name;
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;		    		 		 
		    		 document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	    		 
		    			
		    		 document.getElementsByName("not_conform_num")[0].value=datas[0].not_conform_num;
		    		 document.getElementsByName("completion_date")[0].value=datas[0].completion_date;		
		    		 document.getElementsByName("verify_date")[0].value=datas[0].verify_date;			
		    		 document.getElementsByName("validation_situation")[0].value=datas[0].validation_situation;			
		    		 document.getElementsByName("close_content")[0].value=datas[0].not_content;
		    		 document.getElementsByName("requirements")[0].value=datas[0].requirements;
		    			
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
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/internalAuditNotConform/addNotConform.jsp?projectInfoNo=<%=projectInfoNo%>");
		
	} 
	
	function selectContent(){
		window.open('<%=contextPath%>/hse/notConforMcorrectiveAction/doseNotConformClose/orderList.jsp','pagename','height=400,width=550px,left=350px,top=160px,menubar=no,status=no,toolbar=no');
	}
	function dbclickRow(ids){
		popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/internalAuditNotConform/addNotConform.jsp?projectInfoNo=<%=projectInfoNo%>&inter_no="+ids);
	}
	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/notConforMcorrectiveAction/internalAuditNotConform/addNotConform.jsp?projectInfoNo=<%=projectInfoNo%>&inter_no="+ids);
	  	
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
 
		deleteEntities("update BGP_INTER_NOT_CONFORM e set e.bsflag='1' where e.inter_no in ("+id+")");
	 
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
		var inter_no = document.getElementsByName("inter_no")[0].value;						 
		  if(inter_no !=null && inter_no !=''){
		 
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;		
				
				var not_conform_num = document.getElementsByName("not_conform_num")[0].value;
				var completion_date = document.getElementsByName("completion_date")[0].value;		
				var verify_date = document.getElementsByName("verify_date")[0].value;			
				var validation_situation = document.getElementsByName("validation_situation")[0].value;			
				var not_content = document.getElementsByName("close_content")[0].value;
				var requirements = document.getElementsByName("requirements")[0].value;
				var project_no = document.getElementsByName("project_no")[0].value;						 
				
				 if(project_no !=null && project_no !=''){
						rowParam['project_no'] =project_no;	
					}else{
						rowParam['project_no'] ='<%=projectInfoNo%>';
					}
				 
				rowParam['org_sub_id'] =org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org; 
				rowParam['not_conform_num'] = encodeURI(encodeURI(not_conform_num));
				rowParam['completion_date'] = encodeURI(encodeURI(completion_date)); 
				rowParam['verify_date'] = encodeURI(encodeURI(verify_date));
				rowParam['validation_situation'] = encodeURI(encodeURI(validation_situation)); 
				rowParam['not_content'] = encodeURI(encodeURI(not_content));
				rowParam['requirements'] = encodeURI(encodeURI(requirements));  
			 		 
				    rowParam['inter_no'] = inter_no;
					rowParam['creator'] = encodeURI(encodeURI(creator));
					rowParam['create_date'] =create_date;
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		
					rowParam['bsflag'] = bsflag;
					 
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_INTER_NOT_CONFORM",rows);	
				 refreshData();	 
	 
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
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

