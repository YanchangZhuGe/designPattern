<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

<%
  String contextPath = request.getContextPath();
  UserToken user = OMSMVCUtil.getUserToken(request);
  String projectInfoNo = user.getProjectInfoNo();
  String wz_type = request.getParameter("wz_type");
  String selectWzId = request.getParameter("selectWzId");
  if(selectWzId!=null&&(selectWzId.equals("undefined")||selectWzId.equals("null"))){
	  selectWzId = "";
  }
  String teamOutId = request.getParameter("teamOutId");
  if(teamOutId!=null&&(teamOutId.equals("null")||teamOutId.equals("undefined"))){
	  teamOutId = "";
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
</head>
<body onload='refreshData()'>
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
		<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">物资编码：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_id" name="s_wz_id" type="text" /></td>
		 	     <td class="ali_cdn_name">物资名称：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_name" name="s_wz_name" type="text" /></td>
				<auth:ListButton functionId="" css="cx" event="onclick='refreshData()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <td>&nbsp;</td>
			    <td></td>
			    <td></td>
			    <td></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
      <div id="table_box" >
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="lineTable">
          <tr>
          <td class="bt_info_even"><input type='checkbox' name='rdo_entity_name' value='' onclick='check()'/></td>
          <td class="bt_info_odd">序号</td>
          <td class="bt_info_even">物资编码</td>
          <td class="bt_info_odd">物资名称</td>
          <td class="bt_info_even">计量单位</td>
          <td class="bt_info_odd">入库数量</td>
          <td class="bt_info_even">参考单价</td>
          <td class="bt_info_odd">已发放数量</td>
          </tr>
        </table>
      </div>
      <table id="fenye_box_table">
      </table>

</div>
    
<div id="oper_div"><span class="tj_btn"><a href="#"
  onclick="save()"></a></span> <span class="gb_btn"><a href="#"
  onclick="newClose()"></a></span></div>
</div>
</div>
</form>
</body>
<script type="text/javascript">
  cruConfig.contextPath =  "<%=contextPath%>";
  cruConfig.cdtType = 'form';
  cruConfig.queryStr = "";
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
  
  function refreshData(){
//    var sql ="select a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from (select  i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='<%=projectInfoNo%>' and mti.if_input='0' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.project_info_no='<%=projectInfoNo%>' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0'   where t.stock_num > '0' and t.project_info_no = '<%=projectInfoNo%>') a order by a.wz_id asc";
//    cruConfig.cdtType = 'form';
//    cruConfig.queryStr = sql;
//    queryData(1);

//    cruConfig.queryService = "MatItemSrv";
//    cruConfig.queryOp = "getOtherGantOut";
    
//    queryData(1);
  var wz_type = "<%=wz_type%>";
  var checkSql = "";
  var teamOutId = "<%=teamOutId%>";
  var s_wz_id = document.getElementById("s_wz_id").value;
  var s_wz_name = document.getElementById("s_wz_name").value;
  
  debugger;
  var table=document.getElementById("lineTable");
  var autoOrder = document.getElementById("lineTable").rows.length;
  for(var i=autoOrder-1;i>0;i--){
	  table.deleteRow(i);
  }
  
  var retObj;
  retObj = jcdpCallService("MatItemSrv", "getSelectRepOut", "wz_type="+wz_type+"&teamOutId="+teamOutId+"&s_wz_id="+s_wz_id+"&s_wz_name="+s_wz_name+"&selectWzId="+selectWzId);
  var datas = retObj.list;
  debugger;
	if(datas==null||datas==""){
	}else{
		for (var i = 0; i<datas.length; i++) {		
			toAddLine(
					datas[i].wzId ? datas[i].wzId : "",
					datas[i].wzName ? datas[i].wzName : "",
					datas[i].wzPrickie ? datas[i].wzPrickie : "",
					datas[i].matNum ? datas[i].matNum : "",
					datas[i].wzPrice ? datas[i].wzPrice : "",
					datas[i].outNum ? datas[i].outNum : "",
					i+1		
				);
		}		
	}
  }
  
  
  function clearQueryText(){
	  document.getElementById("s_wz_name").value = "";
	  document.getElementById("s_wz_id").value = "";
  }
  
  function toAddLine(wz_ids,wz_names,wz_prickies,mat_nums,wz_prices,out_nums,num){
		var wz_id = "";
		var wz_name = "";
		var wz_prickie = "";
		var mat_num = "";
		var wz_price = "";
		var out_num = "";
		
		if(wz_ids != null && wz_ids != ""){
			wz_id=wz_ids;
		}
		if(wz_names != null && wz_names != ""){
			wz_name = wz_names;
		}
		if(wz_prickies != null && wz_prickies != ""){
			wz_prickie = wz_prickies;
		}
		if(mat_nums != null && mat_nums != ""){
			mat_num = mat_nums;
		}
		if(wz_prices != null && wz_prices != ""){
			wz_price = wz_prices;
		}
		if(out_nums != null && out_nums != ""){
			out_num = out_nums;
		}
		var table=document.getElementById("lineTable");
		var autoOrder = document.getElementById("lineTable").rows.length;
		var newTR = document.getElementById("lineTable").insertRow(autoOrder);
		var tdClass = 'even';
		if(autoOrder%2==0){
			tdClass = 'odd';
		}
		
		var td = newTR.insertCell(0);
		td.innerHTML = "<input type='checkbox' name='rdo_entity_name' value='" + wz_id + "'/>";
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		   
		td = newTR.insertCell(1);
		td.innerHTML = num;
		td.className =tdClass+'_even'
		   if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}   
		
		td = newTR.insertCell(2);
		td.innerHTML = wz_id;
		td.className =tdClass+'_even'
		   if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}   
		
		td = newTR.insertCell(3);
		td.innerHTML = wz_name;
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		   
		td = newTR.insertCell(4);
		td.innerHTML = wz_prickie;
		td.className =tdClass+'_even'
		   if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}   
		
		td = newTR.insertCell(5);
		td.innerHTML = mat_num;
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
		   
		td = newTR.insertCell(6);
		td.innerHTML = wz_price;
		td.className =tdClass+'_even'
		   if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}   
		
		td = newTR.insertCell(7);
		td.innerHTML = out_num;
		td.className = tdClass+'_odd';
		   if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	}
  
  
  
  function save(){  
    //if (!checkForm()) return;
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