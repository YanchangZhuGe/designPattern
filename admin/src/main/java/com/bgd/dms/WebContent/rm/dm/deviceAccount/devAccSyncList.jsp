<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userOrgId = user.getSubOrgIDofAffordOrg();	
	String devid = request.getParameter("deviceId");
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
 <title>设备同步台账</title> 
 </head> 
 <body style="background:#F1F2F3" onload="refreshData()">
      	<div id="list_table" style="width:100%;height: 480px;">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_cdn_name" >牌照号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_license_num" name="s_license_num" type="text" /></td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>		
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="jh" event="onclick='toSync()'" title="同步"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>				
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" style="width:100%;height: 480px;">
			  <table style="width:98.5%" border="0" cellspacing="0" class="tab_info" id="queryRetTable">
			     <tr >
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}~{spare4}~{using_stat}~{saveflag}' id='rdo_entity_id_{dev_acc_id}' />" >选择</td>
					<!-- <td class="bt_info_even" exp="{dev_type}">设备编码</td> -->
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>	
					<td class="bt_info_even" exp="{erp_id}">ERP设备编号</td>
					<td class="bt_info_odd" exp="{producting_date}">投产日期</td>
					<td class="bt_info_even" exp="{asset_value}">固定资产原值</td>
					<td class="bt_info_odd" exp="{net_value}">固定资产净值</td>
					<td class="bt_info_even" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{dev_position}">所在位置</td>
					<td class="bt_info_even" exp="{ifcountry_tmp}">国内/国外</td>
					<td class="bt_info_odd" exp="{asset_coding}">AMIS资产编号</td>
					<td class="bt_info_even" exp="{cont_num}">合同编号</td>
					<td class="bt_info_odd" exp="{turn_num}">转资单号</td>									
			     </tr> 
			  </table>
			</div>
			<div id="fenye_box"  style="display:block">
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
				      </label>
				    </td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				  </tr>
				</table>
			</div>
		<div class="lashen" id="line"></div>	
</div>

</body>
<script type="text/javascript">
function frameSize(){
	$("#table_box").css("height",$(window).height()*0.85);
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

	var devid = '<%=devid%>';
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_license_num = document.getElementById("s_license_num").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"license_num","value":v_license_num});
		refreshData(obj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
    	document.getElementById("s_dev_model").value="";
		document.getElementById("s_license_num").value="";		
    }

	function refreshData(arrObj,content){
		var userid = '<%=userOrgId%>';
		var orgLength = userid.length;
		var str = "";
		if(orgLength==4){
			str += "select aa.*,(case when aa.owning_org_name_desc=aa.use_name then '' else aa.use_name end)use_name_desc from (select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, "+
			" nvl(t.ifcountry, '国内') as ifcountry_tmp,(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,t.*,substr(t.foreign_key,8) as erp_id,"+
			" p.project_name as project_name_desc,"+
			" case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' when t.owning_sub_id like 'C105001002%' then '新疆物探处' when t.owning_sub_id like 'C105001003%' then '吐哈物探处' when t.owning_sub_id like 'C105001004%' then '青海物探处' when t.owning_sub_id like 'C105005004%' then '长庆物探处' when t.owning_sub_id like 'C105005000%' then '华北物探处' when t.owning_sub_id like 'C105005001%' then '新兴物探开发处' when t.owning_sub_id like 'C105007%' then '大港物探处' when t.owning_sub_id like 'C105063%' then '辽河物探处' when t.owning_sub_id like 'C105006%' then '装备服务处' when t.owning_sub_id like 'C105002%' then '国际勘探事业部' when t.owning_sub_id like 'C105003%' then '研究院' when t.owning_sub_id like 'C105008%' then '综合物化处' when t.owning_sub_id like 'C105015%' then '井中地震中心' when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end as owning_org_name_desc ,i.org_abbreviation usage_org_name_desc ,nvl(pi.org_abbreviation,org.org_abbreviation) use_name,"+
			" (select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc "+
			" from gms_device_account t inner join (comm_org_subjection s inner join comm_org_information org on s.org_id=org.org_id) on t.owning_sub_id=s.org_subjection_id "+
			" left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag ='0'"+
			" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" left join comm_org_information pi on d.org_id = pi.org_id and pi.bsflag ='0'";
		}else{
			str += "select aa.*,aa.use_name use_name_desc from (select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, "+
			" nvl(t.ifcountry, '国内') as ifcountry_tmp,(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,t.*,substr(t.foreign_key,8) as erp_id,"+
			" (select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_no) as project_name_desc,"+
			" org.org_abbreviation as owning_org_name_desc ,i.org_abbreviation usage_org_name_desc ,pi.org_abbreviation use_name,"+
			" (select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc "+
			" from gms_device_account t inner join (comm_org_subjection s inner join comm_org_information org on s.org_id=org.org_id) on t.owning_sub_id=s.org_subjection_id "+
			" left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag ='0'"+
			" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" left join comm_org_information pi on d.org_id = pi.org_id and pi.bsflag ='0'";
			}
		str += " where t.bsflag='I' and t.owning_sub_id like '"+userid+"%' ";
		for(var key in arrObj){
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				str += "and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
			}
		}
		if(content!=null&&content!=""){
			str += content;
		}
		str += ")aa ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	//点击记录查询明细信息
    function loadDataDetail(shuaId){
    	var retObj;
    	var info = shuaId.split("~" , -1);
		if(shuaId!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+info[0]);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+info[0]);
		}
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
        for (i=0; i<obj.length; i++){   
            obj[i].checked = false;   
             
        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr("checked","checked");
    }

	//打开查询条件页面
    function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/deviceAccount/devquery_erp.jsp');
    }
    
    function toSync(){  
		ids = getSelIds('rdo_entity_id');  
		if(ids==''){  alert("请选择需要同步的设备!");  return; }  
		
		var localdevid = window.parent.frames["mainRightframe"].getLocalDevId();
		selId = ids.split('~',-1);
		popWindow('<%=contextPath%>/rm/dm/deviceAccount/devAccSync.jsp?devsyncaccid='+selId[0]+'&devlocalaccid='+localdevid,'1210:680','设备比对页面');
    }
    //刷新页面
    function refreshParent(){
    	refreshData();
    	window.parent.frames["mainRightframe"].refreshData();
    }
</script>
</html>