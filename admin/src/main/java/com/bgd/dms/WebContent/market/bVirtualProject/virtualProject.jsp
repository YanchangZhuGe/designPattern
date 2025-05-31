<%@ page contentType="text/html;charset=UTF-8"  language="java" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String project_info_no = user.getProjectInfoNo();
    String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();	
    
	String org_subjection_id = user.getOrgSubjectionId();
	if(org_subjection_id == null){
		org_subjection_id = "";
	}
 
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>


<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<title>虚拟项目立项</title>
</head>

<body style="background:#fff"  onload="refreshData();">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			   <!--  <td class="ali_cdn_name">事故名称</td>
			    <td class="ali_cdn_input"><input id="accidentName" name="accidentName" type="text" /></td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td> -->

			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table>
			</td>
			  </tr>
			</table>
		</div>
		<div id="table_box">
	    	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr >
			      	<td class="bt_info_odd" exp="<input type='checkbox' name='chx_entity_id' value='{virtualproject_id},{proc_status}' id='chx_entity_id{virtualproject_id}' onclick='chooseOne(this);'  />" >选择</td>
			     	<td class="bt_info_even" autoOrder="1">序号</td> 
			      	<td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      	<td class="bt_info_even" exp="{jiafang_name}">甲方单位</td>
			      	<td class="bt_info_odd" exp="{c_team_name}">地区区域</td>
			      	<td class="bt_info_even" exp="{surface_type_name}">地表类型</td>
			      	<td class="bt_info_odd" exp="{proc_status_name}">审核状态</td>
 
			    </tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">审批流程</a></li>
			    
		    </ul>
		</div>
		<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
				<input type="hidden" id="hse_evaluation_id" name="hse_evaluation_id" value=""></input>
	 
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
							<td>&nbsp;</td>
				 
		                </tr>
		            </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item6">项目名称：</td>
					      	<td class="inquire_form6">
					     	<input type="text" id="project_name" name="project_name" class="input_width" />
					      	</td>
					     	<td class="inquire_item6">甲方单位：</td>
					      	<td class="inquire_form6">
					      	<input type="text" id="jiafang" name="jiafang" class="input_width" />
					      	 
					      	</td>
					      	<td class="inquire_item6">地区区域：</td>
					      	<td class="inquire_form6">
					     	<input type="text" id="c_team" name="c_team" class="input_width" />
					      	</td>
					    </tr>
					    <tr>
				      		<td class="inquire_item6"><font color="red">*</font>地表类型：</td>
				      		<td class="inquire_form6">
				      	 	<input type="text" id="surface_type" name="surface_type" class="input_width" />
				      		</td>
				    		<td class="inquire_item6"><font color="red">*</font>招标时间：</td>
				      		<td class="inquire_form6"><input type="text" id="bidding_time" name="bidding_time" class="input_width"    readonly="readonly"/>
				     
			    		<td class="inquire_item6"><font color="red">*</font>投标时间：</td>
			      		<td class="inquire_form6"><input type="text" id="bid_time" name="bid_time" class="input_width"     readonly="readonly"/>
			      		 
			             </tr> 
					</table>
				</div>
				
				 <div id="tab_box_content1" class="tab_box_content" style="display:none;">
			        <iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
			        </iframe>  
			        </div>
			        <div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>	
					</div>
			        <div id="tab_box_content3" class="tab_box_content" style="display:none;">
			        <wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>  
			        </div>
			        
			        
			</form>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;overflow: hidden;">
				<iframe id="competent_deal" name="competent_deal" src="" width="100%" frameborder="0" ></iframe>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
function frameSize(){
	setTabBoxHeight();
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
 
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
var org_subjection_idA="<%=orgSubjectionId%>";
var selectedTagIndex = 0; 
var showTabBox = document.getElementById("tab_box_content0");


	// 复杂查询
	function refreshData(){ 
 
		cruConfig.queryStr = " select  t.virtualproject_id,t.jiafang,t.project_name,t.c_team,t.surface_type,t.bidding_time,t.bid_time,t.bsflag,t.create_date ,   decode(te.proc_status,   '1',  '待审批',   '3',  '审批通过',   '4',   '审批不通过', te.proc_status) proc_status_name,     nvl(te.proc_status, '0') proc_status , oi.org_abbreviation as c_team_name,   ccsd.coding_name as jiafang_name,  ccsl.coding_name as surface_type_name     from BGP_MARKET_VIRTUALPROJECT t    left join  common_busi_wf_middle te     on te.business_id = t.virtualproject_id     and te.bsflag = '0'    left join comm_org_information oi on oi.org_id = t.c_team  and oi.bsflag = '0'    left join comm_coding_sort_detail ccsd on t.jiafang = ccsd.coding_code_id and ccsd.bsflag = '0'   left join comm_coding_sort_detail ccsl on t.surface_type =ccsl.coding_code_id and ccsl.bsflag='0'    where t.bsflag='0'   and t.second_org like'"+org_subjection_idA+"%'  order by  te.proc_status asc, t.create_date desc  ";
		cruConfig.currentPageUrl = "/market/bVirtualProject/virtualProject.jsp";
		queryData(1);
		 
	}
	 
 
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("chx_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
 
	var rowIndex = 0; 
	
	function loadDataDetail(ids){
        var tempa = ids.split(','); 	    
 	    var virtualproject_id = tempa[0];    
	    var proc_status =  tempa[1];
	    
	    processNecessaryInfo={         
	    		businessTableName:"BGP_MARKET_VIRTUALPROJECT",    //置入流程管控的业务表的主表表明
	    		businessType:"5110000004100000078",        //业务类型 即为之前设置的业务大类
	    		businessId:virtualproject_id,         //业务主表主键值
	    		businessInfo:"市场虚拟项目立项流程",        //用于待审批界面展示业务信息
	    		applicantDate:'<%=appDate%>'       //流程发起时间
	    	}; 
	    	processAppendInfo={ 
	    			id: virtualproject_id,
	    			 buttonView:"false"
	 
	    	};   
	    	
         document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+virtualproject_id;  	    
 	     document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+virtualproject_id;
 		loadProcessHistoryInfo();
 		
 		var  querySql1=" select  t.virtualproject_id,t.jiafang,t.project_name,t.c_team,t.surface_type,t.bidding_time,t.bid_time,t.bsflag,t.create_date ,   decode(te.proc_status,   '1',  '待审批',   '3',  '审批通过',   '4',   '审批不通过', te.proc_status) proc_status_name,     nvl(te.proc_status, '0') proc_status ,  oi.org_abbreviation as c_team_name,   ccsd.coding_name as jiafang_name,  ccsl.coding_name as surface_type_name     from BGP_MARKET_VIRTUALPROJECT t    left join  common_busi_wf_middle te     on te.business_id = t.virtualproject_id     and te.bsflag = '0'    left join comm_org_information oi on oi.org_id = t.c_team  and oi.bsflag = '0'    left join comm_coding_sort_detail ccsd on t.jiafang = ccsd.coding_code_id and ccsd.bsflag = '0'   left join comm_coding_sort_detail ccsl on t.surface_type =ccsl.coding_code_id and ccsl.bsflag='0'   where t.bsflag='0'    and t.virtualproject_id='"+virtualproject_id+"' "; 
  		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql1);
 		var datas = queryRet1.datas;
 	 
 		document.getElementById("project_name").value=datas[0].project_name;
 		document.getElementById("jiafang").value=datas[0].jiafang_name;
 		document.getElementById("c_team").value=datas[0].c_team_name;
 		document.getElementById("surface_type").value=datas[0].surface_type_name;
 		document.getElementById("bidding_time").value=datas[0].bidding_time;
 		document.getElementById("bid_time").value=datas[0].bid_time;
 		
	}
	
	
	
	function toSubmit(){
		
		ids = getSelectedValue(); 
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 

	    var tempa = ids.split(',');
	    var virtualproject_id = tempa[0];    
	    var proc_status =  tempa[1];
	    
 	 
	    if(proc_status == 3){
	    	alert("该信息已审核通过,不允许再次审核");
	    	return;
	    }
	    if(proc_status == 1){
	    	alert("该信息已提交,不允许再次提交");
	    	return;
	    }
	 
		var sql = "update BGP_MARKET_VIRTUALPROJECT set modifi_date=sysdate ,work_flow='2'  where virtualproject_id ='"+virtualproject_id+"'";
		updateEntitiesBySql(sql,"提交");
		submitProcessInfo();
		refreshData();
		alert('提交成功!');
	}
	
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/market/bVirtualProject/addVirtualProject.jsp?buttonView=true");
		
	}
	
	function toEdit(){   
		ids = getSelectedValue(); 
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	 
	    var tempa = ids.split(',');		
	    var virtualproject_id = tempa[0];    
	    var proc_status =  tempa[1];
	    	  
	    if(proc_status == 3 ){
	        alert("该信息单已审核通过不能修改!");
	    	return;
	    }
		 
	    if(proc_status == 1){
	    	alert("该信息已提交,不允许修改");
	    	return;
	    }
	     
	  	popWindow("<%=contextPath%>/market/bVirtualProject/addVirtualProject.jsp?buttonView=true&virtualproject_id="+virtualproject_id);
	  	
	}  
	 
 
	function toDelete(){
		ids = getSelectedValue(); 
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	 
	    var tempa = ids.split(',');
	    var virtualproject_id = tempa[0];    
	    var proc_status =  tempa[1];
	    	  
	    if(proc_status == 3){
	    	alert("该信息已审核通过,不允许删除");
	    	return;
	    }
			 	 
	    if(proc_status == 1){
	    	alert("该信息已提交,不允许删除");
	    	return;
	    }
	   
		var sql = "update BGP_MARKET_VIRTUALPROJECT set bsflag='1' where virtualproject_id ='"+virtualproject_id+"'";
		deleteEntities(sql);
		
	}

  
</script>

</html>

