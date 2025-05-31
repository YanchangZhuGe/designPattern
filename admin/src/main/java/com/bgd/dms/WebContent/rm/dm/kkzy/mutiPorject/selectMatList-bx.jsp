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
	String projectInfoNo=user.getProjectInfoNo();
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
<script type="text/javascript">
function checkAll(ischecked){
	$("input[type='checkbox'][name='rdo_entity_name']").each(function(){
		$(this).attr("checked",ischecked);
	});
}
</script>

 <title>查询备件</title> 
 </head> 

 
 <body style="background:#F1F2F3;overflow-x: scroll;overflow-y: scroll;" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">物资名称</td>
				<td class="ali_cdn_input"><input id="s_wz_name"	name="s_wz_name" type="text" /></td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="tj"
									event="onclick='submitInfo()'" title="JCDP_btn_submit"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
		
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			      <tr id='wz_id_{wz_id}' name='wz_id' idinfo='{wz_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_name' value='{wz_id}' id='rdo_entity_name_{wz_id}' {selectflag}/>" >全选<input  onclick="checkAll(this.checked)"  type='checkbox'  id='allCheck' ></td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{wz_id}">物资编号</td>
					<!-- <td class="bt_info_odd" exp="-">序列号</td> -->
					<td class="bt_info_even" exp="{wz_name}">物资名称</td>
					<td class="bt_info_even" exp="{wz_prickie}">计量单位</td>
					<td class="bt_info_even" exp="{wz_price}">实际价格</td>
					<td class="bt_info_even" exp="-">库存数量</td>
					<td class="bt_info_even" exp="-">排序号</td>
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
	<div id="oper_div"  style="display: none;">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">
  cruConfig.contextPath =  "<%=contextPath%>";
  cruConfig.cdtType = 'form';
  cruConfig.queryStr = "";
  cruConfig.pageSize=10;
  cruConfig.queryService = "DevInsSrv";
  cruConfig.queryOp = "getwxbyMatInfo";
  var selectWzId = "<%=selectWzId%>";
  
  var checked = false;
	function check(){
		var chk = document.getElementsByName("rdo_entity_name");
		for(var i = 0; i < chk.length; i++){
			if(!checked){
				chk[i].checked = true; 
			}else{
				chk[i].checked = false;
			}
		}
		if(checked){
			checked = false;
		}else{
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
		refreshData();
	}
	function refreshData(){
		var wz_name=$("#s_wz_name").val();
		var temp = "wz_name="+wz_name;
		/* for(var key in arrObj) {
			if(arrObj[key].value!=undefined && arrObj[key].value!='')
			temp += "&"+arrObj[key].label+"="+arrObj[key].value;
		} */
		cruConfig.submitStr = temp;
		queryData(cruConfig.currentPage);
	}
  
  
  function clearQueryText(){
	  document.getElementById("s_wz_name").value = "";
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
	  window.returnValue = wz_ids;
	  window.close();
  }
  
  
</script>
</html>