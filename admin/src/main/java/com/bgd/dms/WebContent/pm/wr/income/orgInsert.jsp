<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    Date now = new Date();
	
    String orgSubjectionId = "";
	String orgId = request.getParameter("orgId");
	System.out.println(orgId);
	String sql = "select * from comm_org_subjection t where t.locked_if='0' and t.bsflag='0' and t.org_id='"+orgId+"'";
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	for(int i= 0;i<list.size();i++){
		Map map=(Map)list.get(i);
		orgSubjectionId=(String)map.get("orgSubjectionId") ;
		
	}
	String orgSql = "select * from comm_org_information m where m.org_id='"+orgId+"'";
	Map orgMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgSql);
	String orgAbbreviation = orgMap.get("orgAbbreviation").toString();
	if(orgId.equals("C6000000000017")){
		orgAbbreviation="西安装备分公司";
	}
	if(orgId.equals("C6000000006451")){
		orgAbbreviation="英洛瓦物探装备";
	}
	
	String weekDate="";
	if(orgId!=null){
		String sql2 ="select max(t.week_date) week_date from bgp_wr_income_money t where t.bsflag = '0' and t.org_type = '0' and t.type = '1' and t.org_id = '"+orgId+"'";
		Map map2 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql2);
		if(map2.get("weekDate")!=null&&!map2.get("weekDate").equals("")){
			weekDate = (String)map2.get("weekDate");
		}
	}
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<title>落实收入</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>

</head>

<body>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
    <tr class="odd">
    	<td class="rtCRUFdName">周报开始日期：</td>
      	<td class="rtCRUFdValue"><input type="text" id="week_date" class="input_width"  name="week_date" value="" readonly onchange="set_week_end_date(this.value)">
      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16"  style="cursor:hand;" onmouseover="fridaySelector(week_date,tributton0);"/>
      	</td>
      	<td class="rtCRUFdName">周报结束日期：</td>
      	<td class="rtCRUFdValue"><input type="text" id="week_end_date" class="input_width"  name="week_end_date" value="" readonly>
      	</td>
    </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" id="lineTable" class="form_info" width="100%" style="margin-top:-1px;">
    <tr class="odd">
       <td class="inquire_form_dynamic1">单位</td>
      <td class="inquire_form_dynamic1">分布</td>
      <td class="inquire_form_dynamic1">本周新增<br>(万元)</td>
      <td class="inquire_form_dynamic1">结转<br>(万元)</td>
      <td class="inquire_form_dynamic1">本年新签<br>(万元)</td>
      <td class="inquire_form_dynamic1">落实<br>(万元)</td> 
      <td class="inquire_form_dynamic1">分布</td>
      <td class="inquire_form_dynamic1">本周新增<br>(万元)</td>
      <td class="inquire_form_dynamic1">结转<br>(万美元)</td>
      <td class="inquire_form_dynamic1">结转<br>(万元)</td>
      <td class="inquire_form_dynamic1">本年新签<br>(万美元)</td>
      <td class="inquire_form_dynamic1">本年新签<br>(万元)</td>
      <td class="inquire_form_dynamic1">落实<br>(万美元)</td> 
      <td class="inquire_form_dynamic1">落实<br>(万元)</td> 
    </tr> 
    
    <tr class="even">
      <td><input name="org_id" value="<%=orgId %>" type="hidden"/>
      <input name="org_subjection_id" value="<%=orgSubjectionId %>" type="hidden"/><%=orgAbbreviation %></td>
      <td><input name="income_id0" value="" type="hidden"/>
      <input name="country0" value="1" type="hidden"/>国内</td>
      <td><input name="new_sign0" value="" size="8" onchange="addNewSign()"/></td>
      <td><input name="carryover0"  size="8" onchange="addCarryover()"/></td> 
      <td><input name="new_get0"  size="8"/></td>
      <td><input name="carryout0"  size="8"/></td> 
      <td><input name="income_id1" value="" type="hidden"/>
      <input name="country1" value="2" type="hidden"/>国际</td>
      <td><input name="new_sign1" value="" size="8" onchange="addNewSign1()"/></td>
      <td><input name="carryovey_dollar1"  size="8"/></td> 
      <td><input name="carryover1"  size="8"  onchange="addCarryover1()"/></td> 
      <td><input name="new_get_dollar1"  size="8"/></td> 
      <td><input name="new_get1" size="8"/></td>
      <td><input name="carryout_dollar1" size="8" /></td>
      <td><input name="carryout1" size="8" /></td> 
    </tr>	   
   
    
</table>

<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;">
  <tr class="odd">
    <td colspan="4" class="ali3">
    	<input name="Submit2" id="Submit2" type="button" class="iButton2" style="display:<%="view".equals(request.getParameter("action"))?"none":"" %>" onClick="save()" value="保存" />
    	<input name="Submit3" type="button" class="iButton2" onClick="cancel()" value="返回" />&nbsp;
    </td>
  </tr> 
</table>

</body>
<script type="text/javascript">
var action = '<%=request.getParameter("action")%>';

	function initData(){			
		var data=['tableName:bgp_wr_income_money','text:T','count:N','number:NN','date:D'];
		//var data=['tableName:drill_mud_oillayer_protec','task_assign_info_id:T','oil_gas_level:N','oil_soaktime:NN','oilgaslayer_date:D','oil_start_depth:S1@subSyses','oil_end_depth:S2@0,是@1,否','layer-wellbore_id:P@<%=contextPath%>/ibp/auth/func/funcList2Link.lpmd'];
		return data;
	}
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '提交成功';
		if(failHint==undefined) failHint = '提交失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			cancel();
		}
	}
	
	function afterSubmit(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '提交成功';
		if(failHint==undefined) failHint = '提交失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			window.location = "<%=contextPath%>/market/income/incomeReport.srq?orgId=<%=orgId%>";
		}
	}
	function cancel()
	{
		window.location="<%=contextPath%>/market/income/incomeReport.srq?orgId=<%=orgId%>";
	}

	function fridaySelector(inputField,tributton)
	{    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y-%m-%d",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    true,
			singleClick    :    true,
			step        : 1,
			disableFunc: function(date) {
		        if (date.getDay() != 0) {
		            return true;
		        } else {
		            return false;
		        }
		    }
		    });
	}

	function set_week_end_date(week_date){

		var reg = new RegExp("-","g"); //创建正则RegExp对象       

		var date1= week_date.replace(reg,"\/");

		var startMilliseconds = Date.parse(date1);
		
		var endMilliseconds = startMilliseconds + 6*24*60*60*1000;

		var date2 = new Date();
		
		date2.setTime(endMilliseconds);

		var week_end_date = date2.getFullYear()+"-";
		
		var month = date2.getMonth()+1;

		if(month<10) week_end_date += "0";

		week_end_date += month + "-";

		var day = date2.getDate();
		
		if(day<10) week_end_date += "0";

		week_end_date += day;
		
		document.getElementsByName("week_end_date")[0].value=week_end_date;
	}
	function key_press_check(obj)
	{
		var keycode = event.keyCode;

		if(keycode > 57 || keycode < 45 || keycode==47)
		{
			return false;
		}

		var reg = /^[0-9]{0,2}(\.[0-9]{0,2})?$/;

		var nextvalue = obj.value+String.fromCharCode(keycode);
		
		if(!(reg.test(nextvalue) || nextvalue=="100"))
		{
			return false;
		}
	}

	function save(){
		
		var week_date=document.getElementsByName("week_date")[0].value;
		if(week_date==''){
			alert('请选择周报开始日期');
			return false;
		}
		var week_end_date = document.getElementsByName('week_end_date')[0].value;
		if(week_end_date==''){
			alert('请选择周报结束日期');
			return false;
		}
		
		var querySql = "select t.* from bgp_wr_income_money t where t.week_date = to_date('" + week_date + "','yyyy-MM-dd') and t.bsflag='0' and t.org_type='0' and t.type='1' and t.org_id='<%=orgId%>' order by org_id,country";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null && queryRet.datas.length){
			var flag=false;
			if(confirm("周报开始日期已存在,修改该记录请点确定,否则取消!")){
				flag=true;
				var datas = queryRet.datas;
				for (var j = 0; j < 2; j++) {
					document.getElementsByName("income_id"+j)[0].value=datas[j].income_id;
					}
			}
			if(flag){
				doSave();
				var title = "在周市场落实价值工作量中修改了一条周报开始日期为：“"+week_date+"”的信息";
				var operationPlace = "周市场落实价值工作量";
				var rowParams = new Array();
				var rowParam = {};
				rowParam['operation_title'] = encodeURI(encodeURI(title));
				rowParam['operation_place'] = encodeURI(encodeURI(operationPlace));
				rowParam['create_date'] = '<%=now%>';
				rowParam['modify_date'] = '<%=now%>';
				rowParam['bsflag'] = '0';
				rowParams[rowParams.length] = rowParam;
				var rows2=JSON.stringify(rowParams);
				saveFunc("comm_operation_log",rows2);
			}										
		}else{
			document.getElementById("Submit2").disabled=true;
			doSave();
			var title = "在周市场落实价值工作量中添加了一条周报开始日期为：“"+week_date+"”的信息";
			var operationPlace = "周市场落实价值工作量";
			var rowParams = new Array();
			var rowParam = {};
			rowParam['operation_title'] = encodeURI(encodeURI(title));
			rowParam['operation_place'] = encodeURI(encodeURI(operationPlace));
			rowParam['create_date'] = '<%=now%>';
			rowParam['modify_date'] = '<%=now%>';
			rowParam['bsflag'] = '0';
			rowParams[rowParams.length] = rowParam;
			var rows1=JSON.stringify(rowParams);
			saveFunc("comm_operation_log",rows1);
		}
		
	}
	
	function doSave(){
		var week_date=document.getElementsByName("week_date")[0].value;
		var week_end_date = document.getElementsByName('week_end_date')[0].value;
	
		var rowParams = new Array();
		
			var org_id = document.getElementsByName("org_id")[0].value;		
			var org_subjection_id = document.getElementsByName("org_subjection_id")[0].value;		
			
			for(var j=0;j<2;j++){
				var rowParam = {};
				var income_id = document.getElementsByName("income_id"+j)[0].value;		
				var country = document.getElementsByName("country"+j)[0].value;			
				var new_get = document.getElementsByName("new_get"+j)[0].value;
				var carryout = document.getElementsByName("carryout"+j)[0].value;
				var carryover = document.getElementsByName("carryover"+j)[0].value;
				var new_sign =	document.getElementsByName("new_sign"+j)[0].value;
				if(j=="1"){
				var new_get_dollar = document.getElementsByName("new_get_dollar"+j)[0].value;
				var carryout_dollar = document.getElementsByName("carryout_dollar"+j)[0].value;
				var carryovey_dollar = document.getElementsByName("carryovey_dollar"+j)[0].value;
				rowParam['new_get_dollar'] = new_get_dollar;
				rowParam['carryout_dollar'] = carryout_dollar;
				rowParam['carryovey_dollar'] = carryovey_dollar;
				}
				
				rowParam['new_sign'] = new_sign;
				rowParam['week_date'] = week_date;
				rowParam['week_end_date'] = week_end_date;
				rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
				if(action!="edit"){
				rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] = '<%=now%>';
				}
				rowParam['mondify_date'] = '<%=now%>';
				rowParam['bsflag'] = '0';
				rowParam['subflag'] = '0';
				rowParam['org_type'] = '0';
				rowParam['type'] = '1';
				rowParam['org_id'] = org_id;
				rowParam['org_subjection_id'] = org_subjection_id;
				
				rowParam['income_id'] = income_id;
				rowParam['country'] = country;
				rowParam['new_get'] = new_get;
				rowParam['carryout'] = carryout;
				rowParam['carryover'] = carryover;
				
				rowParams[rowParams.length] = rowParam;
			}
						
		var rows=JSON.stringify(rowParams);
		saveFunc("bgp_wr_income_money",rows);
	}


	
	if(action=="add"){
		var week_date_1 = '<%=weekDate%>';
		if(week_date_1!='null'){
			var querySql = "select t.* from bgp_wr_income_money t where to_char(t.week_date,'yyyy-MM-dd') = '" + week_date_1 + "' and bsflag='0' and  t.org_type='0' and t.type='1' and t.org_id='<%=orgId%>'  order by org_id,country";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
			
			var datas = queryRet.datas;
			if(datas!=null&&datas!=""){
				for (var j = 0; j < 2; j++) {
					document.getElementsByName("new_get"+j)[0].value=datas[j].new_get;
					document.getElementsByName("carryout"+j)[0].value=datas[j].carryout;
					document.getElementsByName("carryover"+j)[0].value=datas[j].carryover;
					if(j=="1"){
						document.getElementsByName("new_get_dollar"+j)[0].value=datas[j].new_get_dollar;
						document.getElementsByName("carryout_dollar"+j)[0].value=datas[j].carryout_dollar;
						document.getElementsByName("carryovey_dollar"+j)[0].value=datas[j].carryovey_dollar;
					}
				}
			}
		}
	}else{
	var data_week_date = '<%=request.getParameter("week_date")%>';
	if(data_week_date!='null'){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = '<%=request.getParameter("week_end_date")%>';
		var querySql = "select t.* from bgp_wr_income_money t where to_char(t.week_date,'yyyy-MM-dd') = '" + data_week_date + "' and bsflag='0' and  t.org_type='0' and t.type='1' and t.org_id='<%=orgId%>'  order by org_id,country";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
			for (var j = 0; j < 2; j++) {
				document.getElementsByName("income_id"+j)[0].value=datas[j].income_id;			
				document.getElementsByName("new_get"+j)[0].value=datas[j].new_get;
				document.getElementsByName("carryout"+j)[0].value=datas[j].carryout;
				document.getElementsByName("carryover"+j)[0].value=datas[j].carryover;
				document.getElementsByName("new_sign"+j)[0].value=datas[j].new_sign;
				if(j=="1"){
					document.getElementsByName("new_get_dollar"+j)[0].value=datas[j].new_get_dollar;
					document.getElementsByName("carryout_dollar"+j)[0].value=datas[j].carryout_dollar;
					document.getElementsByName("carryovey_dollar"+j)[0].value=datas[j].carryovey_dollar;
				}
			}
		}
	}
	
	var x=document.getElementById("new_get0").value;
	var xx = document.getElementById("new_sign0").value;
	var old_sing0 = Number(xx);
	function addNewSign(){
			var new_sign0=document.getElementById("new_sign0").value;
			var carryover0=document.getElementById("carryover0").value;
			new_sign0 = Number(new_sign0);
			var new_get0 = Number(x);
			carryover0 = Number(carryover0);
			document.getElementById("new_get0").value=new_sign0+new_get0-old_sing0;
			document.getElementById("carryout0").value=new_sign0+new_get0+carryover0-old_sing0;
	}
	
	function addCarryover(){
			var carryover0=document.getElementById("carryover0").value;
			var new_get0=document.getElementById("new_get0").value;
			carryover0 = Number(carryover0);
			new_get0 = Number(new_get0);
			document.getElementById("carryout0").value=carryover0+new_get0;
	}
	
	var y=document.getElementById("new_get1").value;
	var yy = document.getElementById("new_sign1").value;
	var old_sign1 = Number(yy);
	function addNewSign1(){
			var new_sign1=document.getElementById("new_sign1").value;
			var carryover1=document.getElementById("carryover1").value;
			new_sign1 = Number(new_sign1);
			var new_get1 = Number(y);
			carryover1 = Number(carryover1);
			document.getElementById("new_get1").value=new_sign1+new_get1-old_sign1;
			document.getElementById("carryout1").value=new_sign1+new_get1+carryover1-old_sign1;
	}
	
	function addCarryover1(){
			var carryover1=document.getElementById("carryover1").value;
			var new_get1=document.getElementById("new_get1").value;
			carryover1 = Number(carryover1);
			new_get1 = Number(new_get1);
			document.getElementById("carryout1").value=carryover1+new_get1;
	}
</script>
</html>
