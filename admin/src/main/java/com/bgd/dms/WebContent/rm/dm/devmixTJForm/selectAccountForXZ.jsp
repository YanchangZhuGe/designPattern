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
			    <td class="ali_cdn_name">设备编码</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_type" name="s_dev_type" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_name" name="s_dev_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_model" name="s_dev_model" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	
			    </td>
			    <td>&nbsp;</td>
			  </tr>
			  <tr>
			    <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_self_num" name="s_dev_ci_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">实物标识号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_sign" name="s_dev_sign" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_license_num" name="s_license_num" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td>&nbsp;</td>
			  </tr>
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
					<td class="bt_info_odd" exp={dev_type}>设备编码</td>
					<td class="bt_info_even" exp={dev_name}>设备名称</td>
					<td class="bt_info_odd" exp={dev_model}>规格型号</td>
					<td class="bt_info_even" exp={self_num}>自编号</td>
					<td class="bt_info_odd" exp={dev_sign}>实物标识号</td>
					<td class="bt_info_even" exp={license_num}>牌照号</td>
					<td class="bt_info_odd" exp={asset_coding}>AMIS资产编号</td>
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
		var v_dev_sign = $("#s_dev_sign").val();
		var v_self_num = $("#s_self_num").val();
		var v_license_num = $("#s_license_num").val();
		var v_dev_type = $("#s_dev_type").val();
		refreshData(v_dev_ci_name,v_dev_ci_model,v_dev_sign,v_self_num,v_license_num,v_dev_type);
	}
	
	var out_org_id='<%=out_org_id%>';
	
	function refreshData(v_dev_ci_name,v_dev_ci_model,v_dev_sign,v_self_num,v_license_num,v_dev_type){
		var str = "select t.dev_acc_id,  t.asset_coding,  t.dev_coding,   t.self_num, t.dev_sign, t.license_num, t.dev_name,t.dev_model, t.dev_type ";
		str += " from gms_device_account t inner join(comm_org_subjection s inner join comm_org_information org on s.org_id = org.org_id) on t.owning_sub_id = s.org_subjection_id ";
		str += " left join comm_org_information i on t.usage_org_id =  i.org_id  and i.bsflag = '0'   left join gp_task_project p on t.project_info_no =   p.project_info_no  and p.bsflag = '0' ";
		str += " left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no  and d.bsflag = '0' ";
		str += "  left join dms_device_tree tree on tree.device_code=t.dev_type  ";

		str += " left join comm_org_information pi on d.org_id =pi.org_id   and pi.bsflag = '0' ";
		str += "  where t.bsflag = '0'  and t.saveflag='0'   and using_stat = '0110000007000000002' and t.ifunused='1'  and t.ifproduction = '5110000186000000001'  and t.account_stat != '0110000013000000005'  and (tree.dev_tree_id  like 'D003%' OR tree.dev_tree_id like 'D006%' OR tree.dev_tree_id like 'D004%')    ";
		
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and t.dev_name like '%"+v_dev_ci_name+"%' ";
		}
		if(out_org_id!=undefined && out_org_id!=''){
			str += "and t.owning_sub_id like '%"+out_org_id+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and t.dev_model like '%"+v_dev_ci_model+"%' ";
		}
		if(v_dev_sign!=undefined && v_dev_sign!=''){
			str += "and t.dev_sign like '%"+v_dev_sign+"%' ";
		}
		if(v_self_num!=undefined && v_self_num!=''){
			str += "and t.self_num like '%"+v_self_num+"%' ";
		}
		if(v_license_num!=undefined && v_license_num!=''){
			str += "and t.license_num like '%"+v_license_num+"%' ";
		}
		if(v_dev_type!=undefined && v_dev_type!=''){
			str += "and t.dev_type like '%"+v_dev_type+"%' ";
		}
		if(selectWzId!=undefined && selectWzId!=''&&selectWzId!='null'){
			str += "and t.dev_acc_id not in ("+selectWzId+") ";
		}
		str += " order by t.dev_type";
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
		  var wz_ids = "";
		  if(selectWzId!=null&&selectWzId!=""){
				wz_ids = selectWzId;
			  }
		  debugger;
		  window.returnValue = wz_ids;
		  window.close();
	  }
	
 
</script>
</html>