<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = request.getParameter("orgSubjectionId");
	String wz_id = request.getParameter("laborId");
	String ifOrgSubjectionId = "";
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>物资台账编辑管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />

</head>
<body >
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<input type="hidden" name="recyclemat_info" id='recyclemat_info' class="input_width" value=""/>
  	<tr>
    	<td colspan="4" align="center">可重复利用台账编辑</td>
    </tr>
    <%if(user.getOrgSubjectionId().startsWith("C105008")){ 
    	ifOrgSubjectionId = "1";
    %>
    <tr>
    	<td class="inquire_item4">选择区域：</td>
      	<td class="inquire_form4">
      		<select id="org_subjection_id" name="org_subjection_id" class="select_width" onchange="toEdit()">
      			<option value="C105008042567">固城物资管理小站</option>
      			<option value="C105008042568">库尔勒物资管理小站</option>
      		</select>
		</td>
		<td class="inquire_item4"></td>
      	<td class="inquire_form4"></td>
    </tr>   
   <%} %> 
    <tr>
    	<td class="inquire_item4">可用总数：</td>
      	<td class="inquire_form4"><input type="text" name="total_num" id = 'total_num' class="input_width" value="" onchange="changeTotalNum()"/></td>
      	<td class="inquire_item4">报废数量</td>
      	<td class="inquire_form4"><input type="text" name="broken_num" id='broken_num' class="input_width" value="" onchange="changeBrokenNum()"/></td>
    </tr>
     <tr>
    </tr>
</table>
</div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
	toEdit();
    
	function save(){	
		var form = document.getElementById("form1");
		var total_num = document.getElementById("total_num").value;
		if(Number(total_num)<0){
			alert("可用总数必须大于0!");
			return;
		}
		form.action="<%=contextPath%>/mat/multiproject/matLed/repmat/repMatLedgerUpdate.srq";
		form.submit();
	}
	
	function toEdit(){
		var ifOrgSubjectionId = "<%=ifOrgSubjectionId%>";
		var orgSubjectionId  = "<%=orgSubjectionId%>";
		if(ifOrgSubjectionId=="1"){
			orgSubjectionId = document.getElementById("org_subjection_id").value;
		}
		
		var checkSql="select * from gms_mat_recyclemat_info t where t.bsflag='0' and t.wz_type = '2' and  t.wz_id='<%=wz_id%>' and t.org_subjection_id='"+orgSubjectionId+"'";
	    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
		var datas = queryRet.datas;
	    debugger;
		if(datas!=null&&datas!=""){
			document.getElementById("recyclemat_info").value=datas[0].recyclemat_info;
			document.getElementById("total_num").value=datas[0].total_num;
			document.getElementById("broken_num").value=datas[0].broken_num;
		}
	}
	
	var num = document.getElementById("total_num").value;
	var broken_num_old = document.getElementById("broken_num").value;
	function changeTotalNum(){
		num = document.getElementById("total_num").value;
	}
	
	function changeBrokenNum(){
		var broken_num = document.getElementById("broken_num").value;
		document.getElementById("total_num").value = Number(num)-Number(broken_num)+Number(broken_num_old);
	}
	
</script>
</html>