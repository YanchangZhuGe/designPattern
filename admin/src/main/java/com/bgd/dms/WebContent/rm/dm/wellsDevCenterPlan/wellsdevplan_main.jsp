<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
	
	String idinfo = request.getParameter("deviceallappid")==null?"":request.getParameter("deviceallappid");
	
	//点击节点的类型 1 root 2 wbs 3 叶子节点
	String teamtype="1";

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>多项目-井中设备分中心-编辑明细子页面</title> 
</head> 
 
<body style="background:#fff" onload="refreshData();">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			    	<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    	<td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  			<tr>
			  				<td class="ali_cdn_name">设备名称</td>
			    			<td class="ali_cdn_input">
			    				<input id="s_dev_ci_name" name="s_dev_ci_name" type="text" class="input_width" />
			    			</td>
			    			<td class="ali_cdn_name">规格型号</td>
			    			<td class="ali_cdn_input">
			    				<input id="s_dev_ci_model" name="s_dev_ci_model" type="text" class="input_width" />
			    			</td>
			    			<td class="ali_query">
			    				<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    			</td>
			    			<td class="ali_query">
				    			<span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    			</td>
			    			<td>&nbsp;</td>
			    			<auth:ListButton functionId="" css="zj" event="onclick='toAddPage()'" title="添加"></auth:ListButton>
			    			<auth:ListButton functionId="" css="xg" event="onclick='toModifyPage()'" title="修改"></auth:ListButton>
			    			<auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="删除"></auth:ListButton>
			  			</tr>
					</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_allapp_detid}' name='device_allapp_detid'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_allapp_detid}~{seqinfo}' id='selectedbox_{device_allapp_detid}' onclick='chooseOne(this)'/>" >选择</td>
			     	<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_ci_model}">规格型号</td>
					<td class="bt_info_odd" exp="{unitname}">单位</td>
					<td class="bt_info_even" exp="{apply_num}">需求数量</td>
					<td class="bt_info_even" exp="{plan_start_date}">开始时间</td>
					<td class="bt_info_even" exp="{plan_end_date}">结束时间</td>
					<td class="bt_info_odd" exp="{purpose}">备注</td> 
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>			    
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
				<table id="detailMap" name="detailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef">
					<tr>
				     <td class="inquire_item6">申请单名称：</td>
				     <td class="inquire_form6"><input id="device_allapp_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td class="inquire_item6">&nbsp;申请单号：</td>
				     <td class="inquire_form6"><input id="device_allapp_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td class="inquire_item6">设备名称：</td>
				     <td class="inquire_form6"><input id="dev_ci_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				    </tr>
				    <tr>				     
				     <td class="inquire_item6">&nbsp;规格型号：</td>
				     <td class="inquire_form6"><input id="dev_ci_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td class="inquire_item6">需求数量：</td>
				     <td class="inquire_form6"><input id="apply_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td class="inquire_item6">单位：</td>
				     <td class="inquire_form6"><input id="unitname" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>				    
				     <td class="inquire_item6">&nbsp;用途：</td>
				      <td class="inquire_form6"  ><input id="purpose" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
				</table>
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
	function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
			}
		});
		
		$(filternotobj).hide();
		$(filterobj).show();
	}

$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var idinfo="<%=idinfo%>"; //计划的id

	function clearQueryText(){
		document.getElementById("s_dev_ci_name").value = "";
		document.getElementById("s_dev_ci_model").value = "";
	}

	function searchDevData(){
		var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
		var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
		refreshData(v_dev_ci_name, v_dev_ci_model);
	}
	
	function refreshData(v_dev_ci_name,v_dev_ci_model){
		var str = "select alldet.device_allapp_detid,devapp.device_allapp_id,sd.coding_name as unitname,teamsd.coding_name as teamname,alldet.dev_ci_code,";
			str += "alldet.dev_name as dev_ci_name,alldet.dev_type as dev_ci_model,alldet.apply_num,alldet.approve_num,";
			str += "alldet.teamid,alldet.team,alldet.purpose,alldet.employee_id,emp.employee_name, ";
			str += "alldet.plan_start_date,alldet.plan_end_date,'单台管理' as managetype,case when alldet.oper_state='pass' then '已处理' else'未处理' end as oper_state,'0' as seqinfo ";
			str += "from gms_device_allapp_detail alldet ";
			str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
			str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
			str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
			str += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
			str += "left join gms_device_codetype ct on alldet.dev_ci_code = ct.dev_ct_code ";
			str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
			str += "where devapp.device_allapp_id = '"+idinfo+"' and alldet.bsflag='0' and devapp.allapp_type = 'S10002' ";
			
			if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
				str += "and alldet.dev_name like '%"+v_dev_ci_name+"%' ";
			}
			if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
				str += "and alldet.dev_type like '%"+v_dev_ci_model+"%' ";
			}
			
			cruConfig.queryStr = str;
			queryData(cruConfig.currentPage);
	}
	
	function loadDataDetail(device_allapp_detid){
    	var retObj;
    	var deviceallappdetid;
		if(device_allapp_detid!=null){
			deviceallappdetid = device_allapp_detid;
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    deviceallappdetid = ids;
		}
		
		deviceallappdetid = deviceallappdetid.substr(0,deviceallappdetid.length-2);
		
    	var str = "select devapp.device_allapp_name,devapp.device_allapp_no,alldet.device_allapp_detid,alldet.project_info_no,sd.coding_name as unitname, ";
		str += "alldet.dev_name as dev_ci_name,alldet.dev_type as dev_ci_model,";
		str += "alldet.apply_num,alldet.teamid,teamsd.coding_name as teamname, ";
		str += "alldet.purpose,alldet.employee_id,emp.employee_name, ";
		str += "alldet.plan_start_date,alldet.plan_end_date  ";
		str += "from gms_device_allapp_detail alldet ";
		str += "left join gms_device_allapp devapp on alldet.device_allapp_id = devapp.device_allapp_id ";
		str += "left join comm_coding_sort_detail teamsd on alldet.team = teamsd.coding_code_id ";
		str += "left join comm_coding_sort_detail sd on alldet.unitinfo = sd.coding_code_id ";
		str += "left join gms_device_codeinfo ci on alldet.dev_ci_code = ci.dev_ci_code ";
		str += "left join gms_device_codetype ct on alldet.dev_ci_code = ct.dev_ct_code ";
		str += "left join comm_human_employee emp on alldet.employee_id = emp.employee_id ";
		str += "where alldet.device_allapp_detid = '"+deviceallappdetid+"' ";
		str += "and devapp.bsflag = '0' ";
		
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		
		$("#purpose","#detailMap").val(retObj[0].purpose);
		$("#dev_ci_name","#detailMap").val(retObj[0].dev_ci_name);
		$("#dev_ci_model","#detailMap").val(retObj[0].dev_ci_model);
		$("#apply_num","#detailMap").val(retObj[0].apply_num);
		$("#unitname","#detailMap").val(retObj[0].unitname);
		$("#plan_start_date","#detailMap").val(retObj[0].plan_start_date);
		$("#plan_end_date","#detailMap").val(retObj[0].plan_end_date);
		$("#device_allapp_name","#detailMap").val(retObj[0].device_allapp_name);
		$("#device_allapp_no","#detailMap").val(retObj[0].device_allapp_no);
    }
	    
	function toAddPage(){
		popWindow("<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevplan_add.jsp?deviceallappid="+idinfo,"900:680");
	}

    function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }  

    function toDelRecord(){
		var length = 0;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择一条记录！");
			return;
		}
		if(confirm("一共选择了"+length+"条记录，是否执行删除？")){
			var selectedid = "";
			var checkindex = 0;
			$("input[type='checkbox'][name='selectedbox']").each(function(i){
				if(this.checked == true){
					if(checkindex!=0){
						selectedid += ",";
					}
					selectedid += "'"+this.value.split("~",-1)[0]+"'";
					checkindex ++;
				}
			});
			var sql="";
			var getsql = "select * from gms_device_allapp_detail t where t.device_allapp_detid in ("+selectedid+")";
			var retDatas = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+getsql);
			if(retDatas.datas != ""){
				sql = "update gms_device_allapp_detail set bsflag='1' where device_allapp_detid in ("+selectedid+")";
			}else{
				sql = "update gms_device_allapp_colldetail set bsflag='1' where device_allapp_detid in ("+selectedid+")";
			}
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}

    //打开修改界面
	function toModifyPage(){
		var length = 0;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
				length = length+1;
			}
		});
		if(length!=1){
			alert("请选择一条记录！");
			return;
		}
		var selectedid = null;
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked == true){
				selectedid = this.value;
			}
		});
		popWindow("<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevplan_modify.jsp?deviceallappid="+idinfo+"&deviceallappdetid="+selectedid,"900:680");
	}
</script>
</html>