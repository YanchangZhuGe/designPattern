<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	//String orgsubid = DevConstants.MIXTYPE_ZHUANGBEI_ORGSUBID;
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String out_org_id= request.getParameter("out_org_id");
	String selectId = request.getParameter("selectId");
	if(selectId!=null&&(selectId.equals("undefined")||selectId.equals("null"))){
	 selectId = "";
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
			    <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_self_num" name="s_self_num" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_license_num" name="s_license_num" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">实物标识号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_sign" name="s_dev_sign" type="text" class="input_width" />
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
					<td class="bt_info_odd" exp={dev_name}>设备名称</td>
					<td class="bt_info_even" exp={dev_model}>规格型号</td>
					<td class="bt_info_odd" exp={self_num}>自编号</td>
					<td class="bt_info_even" exp={license_num}>牌照号</td>
					<td class="bt_info_odd" exp={dev_sign}>实物标识号</td>
					<td class="bt_info_even" exp={owning_name}>所属单位</td>
					<td class="bt_info_odd" exp={usage_name}>所在单位</td>
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
	var selectId = "<%=selectId%>";
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var obj = window.dialogArguments;
	function searchDevData(){
		var v_dev_ci_name = $("#s_dev_name").val();
		var v_dev_ci_model = $("#s_dev_model").val();
		var s_self_num = $("#s_self_num").val();
		var s_license_num = $("#s_license_num").val();
		var s_dev_sign = $("#s_dev_sign").val();
		refreshData(v_dev_ci_name,v_dev_ci_model,s_self_num,s_license_num,s_dev_sign);
	}
	
	var out_org_id='<%=out_org_id%>';
	
	// 如果设备 所在单位 为空，则条件 查找 设备 所属单位，否则查找 设备 所在单位
	function refreshData(v_dev_ci_name,v_dev_ci_model,s_self_num,s_license_num,s_dev_sign){
		var str = "select acc.*,inf1.org_abbreviation as owning_name,inf2.org_abbreviation as usage_name from gms_device_account acc ";
		str +=" left join comm_org_subjection sub1 on acc.owning_sub_id=sub1.org_subjection_id and sub1.bsflag='0' "; 
		str +=" left join comm_org_information inf1 on sub1.org_id=inf1.org_id and inf1.bsflag='0' "; 
		str +=" left join comm_org_subjection sub2 on acc.usage_sub_id=sub2.org_subjection_id and sub2.bsflag='0' "; 
		str +=" left join comm_org_information inf2 on sub2.org_id=inf2.org_id and inf2.bsflag='0' "; 
		str +=" where acc.bsflag = '0' and acc.spare5 is null "; 
		if("C105"!=out_org_id){
			str += "and ( ( acc.owning_sub_id='"+out_org_id+"' and acc.usage_sub_id is null )  or acc.usage_sub_id='"+out_org_id+"' ) ";
		}
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and acc.dev_name like '%"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and acc.dev_model like '%"+v_dev_ci_model+"%' ";
		}
		if(s_self_num!=undefined && s_self_num!=''){
			str += "and acc.self_num like '%"+s_self_num+"%' ";
		}
		if(s_license_num!=undefined && s_license_num!=''){
			str += "and acc.license_num like '%"+s_license_num+"%' ";
		}
		if(s_dev_sign!=undefined && s_dev_sign!=''){
			str += "and acc.dev_sign like '%"+s_dev_sign+"%' ";
		}
		if(selectId!=undefined && selectId!=''){
			str += "and acc.dev_acc_id not in ( "+selectId+" )";
		}
		str += "order by acc.dev_coding";
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
		  window.returnValue = wz_ids;
	  	  window.close();
	  }
	  function newClose(){
		  window.close();
	  }
	
 
</script>
</html>