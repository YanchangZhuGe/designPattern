<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	String orgId = (user==null)?"":user.getCodeAffordOrgID();
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();
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
      <td class="inquire_form_dynamic1">新签</td>
      <td class="inquire_form_dynamic1">落实</td> 
      <td class="inquire_form_dynamic1">备注</td> 
      <td class="inquire_form_dynamic1">分布</td>
      <td class="inquire_form_dynamic1">新签</td>
      <td class="inquire_form_dynamic1">落实</td> 
      <td class="inquire_form_dynamic1">备注</td>
    </tr>
    
    <tr class="even">
      <td><input name="org_id0" value="C0000000000232" type="hidden"/>
      <input name="org_subjection_id0" value="C105005000" type="hidden"/>华北物探处</td>
      <td><input name="income_id00" value="" type="hidden"/><input name="country00" value="1" type="hidden"/>国内</td>
      <td><input name="new_get00" /></td>
      <td><input name="carryout00" /></td> 
      <td><input name="notes00" /></td> 
      <td><input name="income_id01" value="" type="hidden"/><input name="country01" value="2" type="hidden"/>国外</td>
      <td><input name="new_get01" /></td>
      <td><input name="carryout01" /></td> 
      <td><input name="notes01" /></td> 
    </tr>	   
	<tr class="odd">
      <td><input name="org_id1" value="C6000000000003" type="hidden"/>
      <input name="org_subjection_id1" value="C105002" type="hidden"/>国际勘探事业部</td>
      <td><input name="income_id10" value="" type="hidden"/><input name="country10" value="1" type="hidden"/>国内</td>
      <td><input name="new_get10" /></td>
      <td><input name="carryout10" /></td> 
      <td><input name="notes10" /></td> 
      <td><input name="income_id11" value="" type="hidden"/><input name="country11" value="2" type="hidden"/>国外</td>
      <td><input name="new_get11" /></td>
      <td><input name="carryout11" /></td> 
      <td><input name="notes11" /></td> 
    </tr>	
    <tr class="even">
      <td><input name="org_id2" value="C6000000000004" type="hidden"/>
      <input name="org_subjection_id2" value="C105003" type="hidden"/>研究院</td>
      <td><input name="income_id20" value="" type="hidden"/><input name="country20" value="1" type="hidden"/>国内</td>
      <td><input name="new_get20" /></td>
      <td><input name="carryout20" /></td> 
      <td><input name="notes20" /></td> 
      <td><input name="income_id21" value="" type="hidden"/><input name="country21" value="2" type="hidden"/>国外</td>
      <td><input name="new_get21" /></td>
      <td><input name="carryout21" /></td> 
      <td><input name="notes21" /></td>
    </tr>	
    <tr class="odd">
      <td><input name="org_id3" value="C6000000000005" type="hidden"/>
      <input name="org_subjection_id3" value="C105004" type="hidden"/>物探技术研究中心</td>
      <td><input name="income_id30" value="" type="hidden"/><input name="country30" value="1" type="hidden"/>国内</td>
      <td><input name="new_get30" /></td>
      <td><input name="carryout30" /></td> 
      <td><input name="notes30" /></td> 
      <td><input name="income_id31" value="" type="hidden"/><input name="country31" value="2" type="hidden"/>国外</td>
      <td><input name="new_get31" /></td>
      <td><input name="carryout31" /></td> 
      <td><input name="notes31" /></td>
    </tr>	
    <tr class="even">
      <td><input name="org_id4" value="C6000000000007" type="hidden"/>
      <input name="org_subjection_id4" value="C105006" type="hidden"/>装备事业部</td>
      <td><input name="income_id40" value="" type="hidden"/><input name="country40" value="1" type="hidden"/>国内</td>
      <td><input name="new_get40" /></td>
      <td><input name="carryout40" /></td> 
      <td><input name="notes40" /></td> 
      <td><input name="income_id41" value="" type="hidden"/><input name="country41" value="2" type="hidden"/>国外</td>
      <td><input name="new_get41" /></td>
      <td><input name="carryout41" /></td> 
      <td><input name="notes41" /></td>
    </tr>	
    <tr class="odd">
      <td><input name="org_id5" value="C6000000000008" type="hidden"/>
      <input name="org_subjection_id5" value="C105007" type="hidden"/>海上勘探事业部</td>
      <td><input name="income_id50" value="" type="hidden"/><input name="country50" value="1" type="hidden"/>国内</td>
      <td><input name="new_get50" /></td>
      <td><input name="carryout50" /></td> 
      <td><input name="notes50" /></td> 
      <td><input name="income_id51" value="" type="hidden"/><input name="country51" value="2" type="hidden"/>国外</td>
      <td><input name="new_get51" /></td>
      <td><input name="carryout51" /></td> 
      <td><input name="notes51" /></td>
    </tr>
    <tr class="even">
      <td><input name="org_id6" value="C6000000000009" type="hidden"/>
      <input name="org_subjection_id6" value="C105008" type="hidden"/>综合物化探事业部</td>
      <td><input name="income_id60" value="" type="hidden"/><input name="country60" value="1" type="hidden"/>国内</td>
      <td><input name="new_get60" /></td>
      <td><input name="carryout60" /></td> 
      <td><input name="notes60" /></td> 
      <td><input name="income_id61" value="" type="hidden"/><input name="country61" value="2" type="hidden"/>国外</td>
      <td><input name="new_get61" /></td>
      <td><input name="carryout61" /></td> 
      <td><input name="notes61" /></td>
    </tr>	 
   	<tr class="odd">
      <td><input name="org_id7" value="C6000000000010" type="hidden"/>
      <input name="org_subjection_id7" value="C105001005" type="hidden"/>塔里木经理部</td>
      <td><input name="income_id70" value="" type="hidden"/><input name="country70" value="1" type="hidden"/>国内</td>
      <td><input name="new_get70" /></td>
      <td><input name="carryout70" /></td> 
      <td><input name="notes70" /></td> 
      <td><input name="income_id71" value="" type="hidden"/><input name="country71" value="2" type="hidden"/>国外</td>
      <td><input name="new_get71" /></td>
      <td><input name="carryout71" /></td> 
      <td><input name="notes71" /></td>
    </tr>
    <tr class="even">
      <td><input name="org_id8" value="C6000000000011" type="hidden"/>
      <input name="org_subjection_id8" value="C105001002" type="hidden"/>北疆经理部</td>
      <td><input name="income_id80" value="" type="hidden"/><input name="country80" value="1" type="hidden"/>国内</td>
      <td><input name="new_get80" /></td>
      <td><input name="carryout80" /></td> 
      <td><input name="notes80" /></td> 
      <td><input name="income_id81" value="" type="hidden"/><input name="country81" value="2" type="hidden"/>国外</td>
      <td><input name="new_get81" /></td>
      <td><input name="carryout81" /></td> 
      <td><input name="notes81" /></td>
    </tr>	 
    <tr class="odd">
      <td><input name="org_id9" value="C6000000000012" type="hidden"/>
      <input name="org_subjection_id9" value="C105001004" type="hidden"/>敦煌经理部</td>
      <td><input name="income_id90" value="" type="hidden"/><input name="country90" value="1" type="hidden"/>国内</td>
      <td><input name="new_get90" /></td>
      <td><input name="carryout90" /></td> 
      <td><input name="notes90" /></td> 
      <td><input name="income_id91" value="" type="hidden"/><input name="country91" value="2" type="hidden"/>国外</td>
      <td><input name="new_get91" /></td>
      <td><input name="carryout91" /></td> 
      <td><input name="notes91" /></td>
    </tr>
    <tr class="even">
      <td><input name="org_id10" value="C6000000000013" type="hidden"/>
      <input name="org_subjection_id10" value="C105001003" type="hidden"/>吐哈经理部</td>
      <td><input name="income_id100" value="" type="hidden"/><input name="country100" value="1" type="hidden"/>国内</td>
      <td><input name="new_get100" /></td>
      <td><input name="carryout100" /></td> 
      <td><input name="notes100" /></td> 
      <td><input name="income_id101" value="" type="hidden"/><input name="country101" value="2" type="hidden"/>国外</td>
      <td><input name="new_get101" /></td>
      <td><input name="carryout101" /></td> 
      <td><input name="notes101" /></td>
    </tr>
    <tr class="odd">
      <td><input name="org_id11" value="C6000000000015" type="hidden"/>
      <input name="org_subjection_id11" value="C105014" type="hidden"/>信息技术中心</td>
      <td><input name="income_id110" value="" type="hidden"/><input name="country110" value="1" type="hidden"/>国内</td>
      <td><input name="new_get110" /></td>
      <td><input name="carryout110" /></td> 
      <td><input name="notes110" /></td> 
      <td><input name="income_id111" value="" type="hidden"/><input name="country111" value="2" type="hidden"/>国外</td>
      <td><input name="new_get111" /></td>
      <td><input name="carryout111" /></td> 
      <td><input name="notes111" /></td>
    </tr>	
	<tr class="even">
      <td><input name="org_id12" value="C6000000000045" type="hidden"/>
      <input name="org_subjection_id12" value="C105005004" type="hidden"/>长庆物探处</td>
      <td><input name="income_id120" value="" type="hidden"/><input name="country120" value="1" type="hidden"/>国内</td>
      <td><input name="new_get120" /></td>
      <td><input name="carryout120" /></td> 
      <td><input name="notes120" /></td> 
      <td><input name="income_id121" value="" type="hidden"/><input name="country121" value="2" type="hidden"/>国外</td>
      <td><input name="new_get121" /></td>
      <td><input name="carryout121" /></td> 
      <td><input name="notes121" /></td>
    </tr>
    <tr class="odd">
      <td><input name="org_id13" value="C6000000000060" type="hidden"/>
      <input name="org_subjection_id13" value="C105005001" type="hidden"/>新兴物探开发处</td>
      <td><input name="income_id130" value="" type="hidden"/><input name="country130" value="1" type="hidden"/>国内</td>
      <td><input name="new_get130" /></td>
      <td><input name="carryout130" /></td> 
      <td><input name="notes130" /></td> 
      <td><input name="income_id131" value="" type="hidden"/><input name="country131" value="2" type="hidden"/>国外</td>
      <td><input name="new_get131" /></td>
      <td><input name="carryout131" /></td> 
      <td><input name="notes131" /></td>
    </tr>
	<tr class="even">
      <td><input name="org_id14" value="C6000000001888" type="hidden"/>
      <input name="org_subjection_id14" value="C105063" type="hidden"/>辽河物探分公司</td>
      <td><input name="income_id140" value="" type="hidden"/><input name="country140" value="1" type="hidden"/>国内</td>
      <td><input name="new_get140" /></td>
      <td><input name="carryout140" /></td> 
      <td><input name="notes140" /></td> 
      <td><input name="income_id141" value="" type="hidden"/><input name="country141" value="2" type="hidden"/>国外</td>
      <td><input name="new_get141" /></td>
      <td><input name="carryout141" /></td> 
      <td><input name="notes141" /></td>
    </tr>
   <tr class="odd">
      <td><input name="org_id15" value="C6000000005575" type="hidden"/>
      <input name="org_subjection_id15" value="C105079" type="hidden"/>装备制造事业部</td>
      <td><input name="income_id150" value="" type="hidden"/><input name="country150" value="1" type="hidden"/>国内</td>
      <td><input name="new_get150" /></td>
      <td><input name="carryout150" /></td> 
      <td><input name="notes150" /></td> 
      <td><input name="income_id151" value="" type="hidden"/><input name="country151" value="2" type="hidden"/>国外</td>
      <td><input name="new_get151" /></td>
      <td><input name="carryout151" /></td> 
      <td><input name="notes151" /></td>
   </tr>		
    
</table>

<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;">
  <tr class="odd">
    <td colspan="4" class="ali3">
    	<input name="Submit2" type="button" class="iButton2" style="display:<%="view".equals(request.getParameter("action"))?"none":"" %>" onClick="save()" value="保存" />
    	<input name="Submit2" type="button" class="iButton2" onClick="cancel()" value="返回" />&nbsp;
    </td>
  </tr> 
</table>

</body>
<script type="text/javascript">

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
			window.location = cruConfig.contextPath+cruConfig.openerUrl;
		}
	}
	function cancel()
	{
		window.location="list.lpmd";
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
		        if (date.getDay() != 5) {
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
					
		var querySql = "select t.* from bgp_wr_income_money t where t.week_date = to_date('" + week_date + "','yyyy-MM-dd') and t.bsflag='0' order by org_id,country";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+querySql);
		var datas = queryRet.datas;
		if(datas != null && queryRet.datas.length){
			var flag=false;
			if(confirm("周报开始日期已存在,修改该记录请点确定,否则取消!")){
				flag=true;
				var datas = queryRet.datas;
				for(var i = 0; datas && i < 32; i+=2){
					for (var j = 0; j < 2; j++) {
						document.getElementsByName("income_id"+i/2+j)[0].value=datas[i+j].income_id;
					}
				}	
			}
			if(flag){
				doSave();
			}										
		}else{
			doSave();
		}
		
	}
	
	function doSave(){
		var week_date=document.getElementsByName("week_date")[0].value;

		var week_end_date = document.getElementsByName('week_end_date')[0].value;
		
		var rowParams = new Array();
		
		for(var i=0;i<16;i++){

			var org_id = document.getElementsByName("org_id"+i)[0].value;		
			var org_subjection_id = document.getElementsByName("org_subjection_id"+i)[0].value;		
			
			for(var j=0;j<2;j++){
				var rowParam = {};
				var income_id = document.getElementsByName("income_id"+i+j)[0].value;		
				var country = document.getElementsByName("country"+i+j)[0].value;			
				var new_get = document.getElementsByName("new_get"+i+j)[0].value;
				var carryout = document.getElementsByName("carryout"+i+j)[0].value;
				var notes = document.getElementsByName("notes"+i+j)[0].value;
				
				rowParam['week_date'] = week_date;
				rowParam['week_end_date'] = week_end_date;
				rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] = '<%=curDate%>';
				rowParam['mondify_date'] = '<%=curDate%>';
				rowParam['bsflag'] = '0';
				rowParam['subflag'] = '0';
				rowParam['org_id'] = org_id;
				rowParam['org_subjection_id'] = org_subjection_id;
				
				rowParam['income_id'] = income_id;
				rowParam['country'] = country;
				rowParam['new_get'] = new_get;
				rowParam['carryout'] = carryout;
				rowParam['notes'] = encodeURI(encodeURI(notes));
				
				rowParams[rowParams.length] = rowParam;
			}
						

		}
		var rows=JSON.stringify(rowParams);
		saveFunc("bgp_wr_income_money",rows);
	}


	var data_week_date = '<%=request.getParameter("week_date")%>';
	var action = '<%=request.getParameter("action")%>';
	if(data_week_date!='null'){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = '<%=request.getParameter("week_end_date")%>';
		var querySql = "select t.* from bgp_wr_income_money t where to_char(t.week_date,'yyyy-MM-dd') = '" + data_week_date + "' and bsflag='0' order by org_id,country";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		for(var i = 0; datas && i < 32; i+=2){
			for (var j = 0; j < 2; j++) {
				document.getElementsByName("income_id"+i/2+j)[0].value=datas[i+j].income_id;			
				document.getElementsByName("new_get"+i/2+j)[0].value=datas[i+j].new_get;
				document.getElementsByName("carryout"+i/2+j)[0].value=datas[i+j].carryout;
				document.getElementsByName("notes"+i/2+j)[0].value=datas[i+j].notes;
			}
		}

		
	}
</script>
</html>
