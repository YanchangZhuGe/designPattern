<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();    
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();	
	String userOrgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/Calendar1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>单项目-定人定机(综合物化探)</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input" style="width:105px"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input" style="width:105px"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input" style="width:105px"><input id="s_self_num" name="s_self_num" type="text" /></td>
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input" style="width:105px"><input id="s_license_num" name="s_license_num" type="text" /></td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
      			 <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
      			
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddDJ()'" title="分配操作手"></auth:ListButton>
				<auth:ListButton functionId="" css="xg" event="onclick='toEditDJ()'" title="修改操作手"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' operid='{operator_id}' id='rdo_entity_id_{dev_acc_id}'/>" >选择</td>					
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<!-- <td class="bt_info_even" exp="{erp_id}">ERP设备编号</td>	
					<td class="bt_info_odd" exp="{account_stat_desc}">资产状况</td> -->
					<td class="bt_info_even" exp="{org_abbreviation}">所属单位</td>
					<td class="bt_info_odd" exp="{alloprinfo}">操作手</td>
					<td class="bt_info_even" exp="{actual_in_time}">进队日期</td>
					<td class="bt_info_odd" exp="{actual_out_time}">离队日期</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">设备名称</td>
						    <td class="inquire_form6"><input id="dev_acc_name" name=""  class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">规格型号</td>
						    <td class="inquire_form6"><input id="dev_acc_model" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">设备编码</td>
						    <td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text" readonly/></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">ERP设备编号</td>
						    <td class="inquire_form6"><input id="dev_acc_erpid" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">实物标识号</td>
						    <td class="inquire_form6"><input id="dev_acc_sign" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">自编号</td>
						    <td class="inquire_form6"><input id="dev_acc_self" name="" class="input_width" type="text" readonly/></td>
						  </tr>
						    <tr>
						    <td class="inquire_item6">主机序列号</td>
						    <td class="inquire_form6"><input id="" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">出厂编号</td>
						    <td class="inquire_form6"><input id="" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">出厂日期</td>
						    <td class="inquire_form6"><input id="dev_acc_producting_date" name="" class="input_width" type="text" readonly/></td>
						  </tr>
						   <tr>
						    <td class="inquire_item6">牌照号</td>
						    <td class="inquire_form6"><input id="dev_acc_license" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">发动机号</td>
						    <td class="inquire_form6"><input id="dev_acc_engine_num" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">底盘号</td>
						    <td class="inquire_form6"><input id="dev_acc_chassis_num" name="" class="input_width" type="text" readonly/></td>
						  </tr>
						    <tr>
						    <td class="inquire_item6">资产状况</td>
						    <td class="inquire_form6"><input id="dev_acc_asset_stat" name="" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">技术状况</td>
						    <td class="inquire_form6"><input id="dev_acc_tech_stat" name="" class="input_width" type="text" readonly/></td>
						  </tr>
						               
			        </table>
				</div>
				
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
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
		if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid+"&sonFlag="+sonFlag);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid+"&sonFlag="+sonFlag);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid+"&sonFlag="+sonFlag);
		}
		
		$(filternotobj).hide();
		$(filterobj).show();
	}
$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';

	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_self_num = document.getElementById("s_self_num").value;
		var v_license_num = document.getElementById("s_license_num").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"self_num","value":v_self_num});
		obj.push({"label":"license_num","value":v_license_num});

		refreshData(obj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
		document.getElementById("s_dev_model").value="";
		document.getElementById("s_self_num").value="";
		document.getElementById("s_license_num").value="";
    }
	
	function refreshData(arrObj){
		var userid = '<%=userOrgId%>';
		
		var unitSql = "select sd.note ";
			unitSql += "from comm_coding_sort_detail sd "; 
			unitSql += "where coding_sort_id ='5110000165' order by coding_code";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+unitSql+'&pageSize=1000');
		retObj = unitRet.datas;
		
		var str = "select acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_coding as erp_id,org.org_abbreviation,";
			str += "oper.operator_id,acc.dev_acc_id,acc.dev_sign,accountsd.coding_name as account_stat_desc,emp.employee_name as alloprinfo ";
			str += "from gms_device_appmix_detail t ";
			str += "left join gms_device_equipment_operator oper on t.dev_acc_id = oper.fk_dev_acc_id and oper.project_info_id = t.project_no and oper.bsflag='0' ";
			str += "left join comm_human_employee emp on emp.employee_id = oper.operator_id ";
			str += "left join gms_device_account acc on t.dev_acc_id = acc.dev_acc_id and acc.bsflag = '0' ";
			str += "left join comm_coding_sort_detail accountsd on acc.account_stat=accountsd.coding_code_id ";
			str += "left join comm_org_information org on acc.owning_org_id=org.org_id ";
	        str += "where t.project_no='"+projectInfoNos+"' and (";	        
		
		for(var index=0;index<retObj.length;index++){
            if(index == retObj.length-1){
            	str += "acc.dev_type like '"+retObj[index].note+"%' )";
            }else{
        		str += "acc.dev_type like '"+retObj[index].note+"%' or ";
            }
		}
		str += "order by acc.dev_type desc ";
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	var actualOutTime;
	var devType;
    function loadDataDetail(shuaId){
		
    	var retObj;
    	$("#queryRetTable :checked").removeAttr("checked");
    	$("#rdo_entity_id_"+shuaId).attr("checked","checked");
		if(shuaId!=null){
			var querySql="select (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,t.dev_coding as erp_id,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from GMS_DEVICE_ACCOUNT t where dev_acc_id= '"+shuaId+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			retObj = queryRet.datas;
		}else{
			var ids = getSelIds('rdo_entity_id');
			
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var querySql="select (select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc, t.*,t.dev_coding as erp_id,(select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc,(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc from GMS_DEVICE_ACCOUNT t where dev_acc_id= '"+ids+"'"  ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
		}
		
		document.getElementById("dev_acc_name").value =retObj[0].dev_name;
		document.getElementById("dev_acc_sign").value =retObj[0].dev_sign;
		document.getElementById("dev_acc_model").value =retObj[0].dev_model;
		document.getElementById("dev_acc_self").value =retObj[0].self_num;
		document.getElementById("dev_acc_license").value =retObj[0].license_num;
		document.getElementById("dev_acc_erpid").value =retObj[0].erp_id;
		document.getElementById("dev_acc_tech_stat").value =retObj[0].tech_stat_desc;
		document.getElementById("dev_acc_producting_date").value =retObj[0].producting_date;
		document.getElementById("dev_acc_engine_num").value =retObj[0].engine_num;
		document.getElementById("dev_acc_chassis_num").value =retObj[0].chassis_num;
		document.getElementById("dev_acc_asset_stat").value =retObj[0].account_stat_desc;

		actualOutTime = retObj[0].actual_out_time;
		devType=retObj[0].dev_type;		
		
		document.getElementById("dev_type").value =retObj[0].dev_type;

    }	
        
    function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/device-xd/devquery.jsp');
    }

	  /*****************************************************************************************************************************
	   * 公共复选框选择
	   */
	  function setGl2(obj,divid){
		var tableobj = obj.parentNode;
    	$("#"+tableobj.id+">tr:odd>td:odd","#"+divid).css("background-color","#e3e3e3");
		$("#"+tableobj.id+">tr:even>td:odd","#"+divid).css("background-color","#ebebeb");
		$("#"+tableobj.id+">tr:odd>td:even","#"+divid).css("background-color","#f6f6f6");
		$("#"+tableobj.id+">tr:even>td:even","#"+divid).css("background-color","#FFFFFF");
		$("input[type='checkbox']","#"+divid).removeAttr("checked");
    	var columnsObj=obj.cells;
    	columnsObj[0].childNodes[0].checked=true;
    	for(var i=0;i<columnsObj.length;i++){
    		columnsObj[i].style.background="#ffc580";
    	}
    }
		//打开新增界面
	 function toAddDJ(){
		    
		var ids;
		var operid;
		$("input[type='checkbox'][name='rdo_entity_id']").each(function(i){
			if(this.checked){
				ids = this.value;
				operid = this.operid;
			}
		});
		if(ids==undefined){ 
			   alert("请先选中一条记录!");
			   return;
		}
		if(operid!=''){ 
			   alert("操作员已分配!");
			   return;
		}
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/zhdj.jsp?ids="+ids,"800:680");  
	 	
	 }

    //修改界面
     function toEditDJ(obj){  
     	if(obj==undefined){
     		$("input[type='checkbox']", "#djMap").each(function(){
     			if(this.checked){
     				obj = this.parentNode.parentNode;
     			}
     		});
     	}
     	var ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/zhdj.jsp?ids="+ids); 
	  } 
	  
	  function toDeleteDJ(){
 		ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteUpdate", "deviceId="+ids);
				
				queryData(cruConfig.currentPage);
				
			}

	}
	
</script>

</html>