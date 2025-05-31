<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
  String contextPath = request.getContextPath();
  UserToken user = OMSMVCUtil.getUserToken(request);
  String code = request.getParameter("code");
  String userOrgId = user.getSubOrgIDofAffordOrg();
  String selectWzId = request.getParameter("selectWzId");
  if(selectWzId!=null&&(selectWzId.equals("undefined")||selectWzId.equals("null"))){
	  selectWzId = "";
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

 <title>查询单项目-震源中心-可控震源台账</title> 
 </head> 
 
 <body style="background:#F1F2F3;overflow-x: scroll;overflow-y: scroll;" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			   <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input"><input id="s_self_num" name="s_self_num" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="tj" event="onclick='submitInfo()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
		
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			      <tr id='dev_acc_id_{dev_acc_id}' name='dev_acc_id' idinfo='{dev_acc_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_name' value='{dev_acc_id}' id='rdo_entity_name_{dev_acc_id}' {selectflag}/>" >选择</td>
					 <td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{account_stat_desc}">资产状况</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{dev_position}">所在位置</td>
					<td class="bt_info_even" exp="{using_stat_desc}">使用情况</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td>
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
	</div>
	<!--  
	<div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>-->
</body>
<script type="text/javascript">
  cruConfig.contextPath =  "<%=contextPath%>";
  cruConfig.cdtType = 'form';
  cruConfig.queryStr = "";
  cruConfig.pageSize=110;
  var selectWzId = "<%=selectWzId%>";
  
  var checked = false;
	function check(){
		var chk = document.getElementsByName("rdo_entity_name");
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
  
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	//下拉时查询
	function selectRefreshData(){
	    searchDevData();
	}
	function searchDevData(){
		var v_self_num = document.getElementById("s_self_num").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		
		var obj = new Array();
		obj.push({"label":"self_num","value":v_self_num});
		refreshData(obj,v_dev_model);
	}
	 //清空查询条件
    function clearQueryText(){
		document.getElementById("s_self_num").value="";
		document.getElementById("s_dev_model").value="";
    }
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	function refreshData(arrObj,v_dev_model){
		var userid = '<%=userOrgId%>';
		var orgLength = userid.length;
		var str = "";
		str+="select (select coding_name  from comm_coding_sort_detail c where t.using_stat = c.coding_code_id) as using_stat_desc,";
		str+=" (select coding_name  from comm_coding_sort_detail c  where t.tech_stat =  c.coding_code_id) as tech_stat_desc, (select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc ";
		str+=" , t.*  , (select coding_name   from comm_coding_sort_detail co   where co.coding_code_id =  t.account_stat) as account_stat_desc from gms_device_account t";
		//str+=" left join comm_org_information f on f.org_id=t.owning_org_id ";
		//str+="  where  t.owning_sub_id like 'C105006%'  and t.dev_type like 'S062301%'     and t.account_stat='0110000013000000003'  and (ifcountry='国内' or ifcountry is null)   ";
		str+="  where  t.bsflag='0' and  t.owning_sub_id = '"+userid+"'  and t.dev_type like 'S062301%'    and  t.dev_acc_id not in (select fk_dev_acc_id from gms_device_account_dui dui  where dui.bsflag = '0'  and dui.dev_type like 'S062301%' and dui.actual_out_time is null and dui.is_leaving='0'  and dui.self_num is not null    ) and (ifcountry='国内' or ifcountry is null) ";
		
		//if(selectWzId!="")
			//{	
				//str+=" and  t.dev_acc_id not in("+selectWzId+") ";
		//	}
		for(var key in arrObj) {
			if(arrObj[key].value!=undefined && arrObj[key].value!='')
			str += "and "+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
		}
		if(v_dev_model!=undefined&&v_dev_model!=null){
			str+="   and   dev_model like '%"+v_dev_model+"%'";
		}
		str += "  order by  self_num asc, dev_type asc ";
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
  
  
  function clearQueryText(){
	  document.getElementById("s_self_num").value = "";
	  document.getElementById("s_dev_model").value="";
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
			if(selectWzId!=null&&selectWzId!=""){
				wz_ids += ","+selectWzId;
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