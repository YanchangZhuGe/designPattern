<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	String contextPath = request.getContextPath();
	String id = request.getParameter("id");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
	String orgname = user.getOrgName();
	String orgid = user.getOrgId();
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript">
	function submitInfo(state){
		//给参数拼上
		var submiturl = "<%=contextPath%>/rm/dm/saveRFIDInfo.srq";
		
		document.getElementById("form1").action = submiturl;
		document.getElementById("form1").submit();
	}
	
	function initPage1233(){
		var sql = "select * from GMS_DEVICE_RFID t where t.id='<%=id%>'";
		var rfidRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
		var retObj = rfidRet.datas;
		$.each(retObj[0],function(i,k){
			$("[name='"+i+"']").val(k);
		});
	}
</script>
<title>RFID修改界面</title>
</head>
<body class="bgColor_f3f3f3" onload="initPage1233()">
<form name="form1" id="form1" method="post" action="">
<input name="id" id="id" class="input_width" type="hidden" value="<%=id%>"/>
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend >基本信息</legend>
      	<table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			<tr>
				<td class="inquire_item4" >EPC编号:</td>
          		<td class="inquire_form4" colspan="3">
          			<input name="epc_code" id="epc_code" class="input_width" type="text"/>
          		</td>
        	</tr>
        	<tr>
          		<td class="inquire_item4" >TAGID:</td>
          		<td class="inquire_form4" colspan="3">
		          	<input name="tagid" id="tagid" class="input_width" type="text"/>
				</td>
        	</tr>
        	<tr>
	          <td class="inquire_item4" >所属单位:</td>
	          <td class="inquire_form4" colspan="3">
	          	<%=orgname %>
	          	<input name="ownorg_suborg_id" id="ownorg_suborg_id" class="input_width" type="hidden"  value="<%=orgsubid %>" readonly/>
	          	<input name="ownorg_id" id="ownorg_id" class="input_width" type="hidden"  value="<%=orgid %>" readonly/>
	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item4" >标签状态:</td>
	          <td class="inquire_form4" colspan="3">
	          	<select name="stauts" id="stauts"><option value="1">生效</option><option value="0">失效</option></select>
	          </td>
	        </tr>
	        <tr>
	          <td class="inquire_item4" >备注:</td>
	          <td class="inquire_form4" colspan="3">
	          	<textarea cols="45" rows="5" name="rfid_desc" id="rfid_desc"></textarea>
	          </td>
	        </tr>
      	</table>
      </fieldSet>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
</html>