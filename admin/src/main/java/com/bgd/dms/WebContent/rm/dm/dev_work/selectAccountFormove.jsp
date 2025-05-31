<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	//String orgsubid = DevConstants.MIXTYPE_ZHUANGBEI_ORGSUBID;
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userSubId = user.getSubOrgIDofAffordOrg();
	String out_org_id= request.getParameter("out_org_id");
	 String selectWzId = request.getParameter("selectWzId");
	  if(selectWzId!=null&&(selectWzId.equals("undefined")||selectWzId.equals("null"))){
		  selectWzId = "";
	  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=7"/>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

 <title>查询闲置设备台帐</title> 
 </head> 
 
 <body style="background:#F1F2F3" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box" style="height:64px;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_131.png" width="6" height="64" /></td>
			    <td background="<%=contextPath%>/images/list_151.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_name" name="s_dev_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_model" name="s_dev_model" type="text" class="input_width" />
			    </td>
			    	<td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			      <td>&nbsp;</td>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_171.png" width="4" height="64" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			    	<tr id='dev_acc_id_{dev_acc_id}' name='dev_acc_id' idinfo='{dev_acc_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_name' value='{dev_acc_id}' id='rdo_entity_name_{dev_acc_id}' {selectflag}/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp={dev_name}>设备名称</td>
					<td class="bt_info_odd" exp={dev_model}>规格型号</td>
					<td class="bt_info_odd" exp={unit_name}>单位</td>
					<td class="bt_info_even" exp={usage_org_name}>所在单位</td>
					<td class="bt_info_odd" exp={wanhao_num}>完好数量</td>
					<td class="bt_info_odd" exp={daibaofei_num}>待报废数量</td>
					<td class="bt_info_odd" exp={weixiu_num}>待修数量</td>
					<td class="bt_info_odd" exp={zaixiu_num}>在修数量</td>
					<td class="bt_info_odd" exp={huisun_num}>毁损数量</td>
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
		 </div>
	<div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">
var selectWzId = "<%=selectWzId%>";
	var usersubid = '<%=userSubId%>';
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var obj = window.dialogArguments;
	function searchDevData(){
		var v_dev_ci_name = $("#s_dev_name").val();
		var v_dev_ci_model = $("#s_dev_model").val();
		refreshData(v_dev_ci_name,v_dev_ci_model);
	}
	
	var out_org_id='<%=out_org_id%>';
	
	function refreshData(v_dev_ci_name,v_dev_ci_model){
		var str = "select acc.device_id,  acc.dev_acc_id,acc.dev_unit,  acc.dev_model,  acc.dev_name, nvl(teach.good_num,0) as wanhao_num, nvl(teach.touseless_num, 0) as daibaofei_num,  nvl(teach.torepair_num, 0) as weixiu_num , ";
		str += " nvl(teach.repairing_num, 0) as zaixiu_num, nvl(teach.destroy_num, 0) as huisun_num,  case when acc.ifcountry = '000' then  '国内' else acc.ifcountry end as ifcountry, ci.dev_code, l.coding_name as dev_type,usageorg.org_abbreviation as usage_org_name,owingorg.org_abbreviation as owning_org_name,";
		str += " unitsd.coding_name as unit_name,  org.org_abbreviation as org_name, acc.usage_sub_id,acc.usage_org_id,acc.owning_org_id, acc.owning_sub_id, suborg.org_subjection_id, ";
		str += " case when usageorg.org_abbreviation = '塔里木作业部' then  'C105001005'  when usageorg.org_abbreviation = '北疆作业部' then 'C105001002'   when usageorg.org_abbreviation = '吐哈作业部' then  'C105001003' ";
		str += " when usageorg.org_abbreviation = '敦煌作业部' then   'C105001004'  when usageorg.org_abbreviation = '长庆作业部' then 'C105005004'  when usageorg.org_abbreviation = '辽河作业部' then  'C105063' ";
		str +="  when usageorg.org_abbreviation = '华北作业部' then  'C105005000'   when usageorg.org_abbreviation = '新区作业部' then 'C105005001'  when usageorg.org_abbreviation = '大港作业分部' then  'C105007'  when usageorg.org_abbreviation = '仪器设备服务中心' then  'C105007'  else  ''  end as org_id ";
		str += " from gms_device_coll_account acc   left join comm_coding_sort_detail l on l.coding_code_id = acc.type_id  and l.coding_sort_id like  '5110000031' ";
		str += " left join gms_device_collectinfo ci on acc.device_id =ci.device_id   left join comm_org_information org on acc.owning_org_id = org.org_id and org.bsflag = '0'    ";
		str +="  left join comm_org_information usageorg on acc.usage_org_id = usageorg.org_id and usageorg.bsflag = '0'  left join comm_org_information owingorg on acc.owning_org_id =owingorg.org_id and owingorg.bsflag = '0' ";
		str +="  left join comm_org_subjection suborg on acc.owning_org_id = suborg.org_id  and suborg.bsflag = '0'  left join comm_coding_sort_detail unitsd on acc.dev_unit =unitsd.coding_code_id left join gms_device_coll_account_tech teach on teach.dev_acc_id =acc.dev_acc_id ";
		str +="  where acc.bsflag = '0'  and ci.is_leaf = '1' and (ci.dev_code like '01%' or ci.dev_code like '02%' or ci.dev_code like '03%' or ci.dev_code like '05%' ) and acc.usage_sub_id like '"+out_org_id+"%'   "; 
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and acc.dev_name like '%"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and acc.dev_model like '%"+v_dev_ci_model+"%' ";
		}
		if(selectWzId!=undefined && selectWzId!=''){
			str += "and acc.dev_acc_id not in ( "+selectWzId+" )";
		}
		
		str += "order by ci.dev_code";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
 
	  function submitInfo(){  
		  var ids = "";
		    ids = getSelIds('rdo_entity_name');
		      if (ids == "") {
		        alert("请选择一条记录!");
		        return;
		      }
		      var temp = ids.split(",");
				var wz_ids = "";
				for(var i=0;i<temp.length;i++){
					if(wz_ids!=""){
						wz_ids += ","; 
					}
					wz_ids += "'"+temp[i]+"'";
				}
				var wz_id = wz_ids.split(",");
				 window.returnValue = wz_ids;
			  	 window.close();
	  }
	  function newClose(){
		  window.close();
	  }
	
 
</script>
</html>