<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>物资供应动态</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
</head>

<body style="background:#fff">
<form>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    <td background="<%=contextPath%>/images/list_15.png">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali3">周报开始日期：</td>
			    <td class="ali1"><input type="text" id="week_date" class="input_width4"  name="week_date" value="" readonly></td>
			    <td class="ali3">周报结束日期：</td>
			    <td class="ali1"><input type="text" id="week_end_date" class="input_width4"  name="week_end_date" value="" readonly></td>
			  </tr>
			</table>
		</td>
	    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
	  </tr>
</table></table>

<table border="0" cellpadding="0" cellspacing="0" class="lineTable" width="100%" style="margin-top:0px;">
	<tr class="bt_info">
	  <td>基层单位</td>
	  <td>服务小队(项目)</td>
	  <td>现场服务人员</td>
	  <td>期末库存(万元)</td>
	  <td>正在服务项目数量</td>
	  <td>准备启动项目数量</td>
	  <td>情况说明</td>
	</tr>
	<tr class="even">
      <td><input name="material_id0" value="" type="hidden"/><span id="org_id0" value="C6000000005373"></span>塔里木分中心:</td>
      <td><input name="service_info0" /><input name="org_subjection_id0" value="C105078015" type="hidden"/></td>
      <td><input name="user_num0" onblur="totalusernum()"/>名</td> 
      <td><input name="stock_num0" onblur="totalstocknum()"/></td> 
      <td><input name="service_project_num0" onblur="totalserviceprojectnum()"/></td> 
      <td><input name="start_project_num0" onblur="totalstartprojectnum()"/></td> 
	  <td><input name="case_description0" type="text" size="30"/></td>
    </tr>	
	<tr class="odd">
      <td><input name="material_id1" value="" type="hidden"/><span id="org_id1" value="C6000000005369">北疆分中心:</span></td>
      <td><input name="service_info1" /><input name="org_subjection_id1" value="C105078011" type="hidden"/></td>
      <td><input name="user_num1" onblur="totalusernum()"/>名</td> 
      <td><input name="stock_num1" onblur="totalstocknum()"/></td> 
      <td><input name="service_project_num1" onblur="totalserviceprojectnum()"/></td> 
      <td><input name="start_project_num1" onblur="totalstartprojectnum()"/></td> 
      <td><input name="case_description1" type="text" size="30"/></td>
    </tr>
	<tr class="even">
      <td><input name="material_id2" value="" type="hidden"/><span id="org_id2" value="C6000000005371">敦煌分中心:</span></td>
      <td><input name="service_info2" /><input name="org_subjection_id2" value="C105078013" type="hidden"/></td>
      <td><input name="user_num2" onblur="totalusernum()"/>名</td> 
      <td><input name="stock_num2" onblur="totalstocknum()"/></td> 
      <td><input name="service_project_num2" onblur="totalserviceprojectnum()"/></td> 
      <td><input name="start_project_num2" onblur="totalstartprojectnum()"/></td> 
      <td><input name="case_description2" type="text" size="30"/></td>
    </tr>	
	<tr class="odd">
      <td><input name="material_id3" value="" type="hidden"/><span id="org_id3" value="C6000000005376">吐哈分中心:</span></td>
      <td><input name="service_info3" /><input name="org_subjection_id3" value="C105078016" type="hidden"/></td>
      <td><input name="user_num3" onblur="totalusernum()"/>名</td> 
      <td><input name="stock_num3" onblur="totalstocknum()"/></td> 
      <td><input name="service_project_num3" onblur="totalserviceprojectnum()"/></td> 
      <td><input name="start_project_num3" onblur="totalstartprojectnum()"/></td> 
      <td><input name="case_description3" type="text" size="30"/></td>
    </tr>
	<tr class="even">
      <td><input name="material_id4" value="" type="hidden"/><span id="org_id4" value="C6000000005377">涿州分中心:</span></td>
      <td><input name="service_info4" /><input name="org_subjection_id4" value="C105078017" type="hidden"/></td>
      <td><input name="user_num4" onblur="totalusernum()"/>名</td> 
      <td><input name="stock_num4" onblur="totalstocknum()"/></td> 
      <td><input name="service_project_num4" onblur="totalserviceprojectnum()"/></td> 
      <td><input name="start_project_num4" onblur="totalstartprojectnum()"/></td> 
      <td><input name="case_description4" type="text" size="30"/></td>
    </tr>	
	<tr class="odd">
      <td><input name="material_id5" value="" type="hidden"/><span id="org_id5" value="C6000000005372">任丘分中心:</span></td>
      <td><input name="service_info5" /><input name="org_subjection_id5" value="C105078014" type="hidden"/></td>
      <td><input name="user_num5" onblur="totalusernum()"/>名</td> 
      <td><input name="stock_num5" onblur="totalstocknum()"/></td> 
      <td><input name="service_project_num5" onblur="totalserviceprojectnum()"/></td> 
      <td><input name="start_project_num5" onblur="totalstartprojectnum()"/></td> 
      <td><input name="case_description5" type="text" size="30"/></td>
    </tr>
	<tr class="even">
      <td><input name="material_id6" value="" type="hidden"/><span id="org_id6" value="C6000000005370">大港分中心:</span></td>
      <td><input name="service_info6" /><input name="org_subjection_id6" value="C105078012" type="hidden"/></td>
      <td><input name="user_num6" onblur="totalusernum()"/>名</td> 
      <td><input name="stock_num6" onblur="totalstocknum()"/></td> 
      <td><input name="service_project_num6" onblur="totalserviceprojectnum()"/></td> 
      <td><input name="start_project_num6" onblur="totalstartprojectnum()"/></td> 
      <td><input name="case_description6" type="text" size="30"/></td>
    </tr>	
	<tr class="odd">
      <td><input name="material_id7" value="" type="hidden"/><span id="org_id7" value="C6000000005368">长庆分中心:</span></td>
      <td><input name="service_info7" /><input name="org_subjection_id7" value="C105078010" type="hidden"/></td>
      <td><input name="user_num7" onblur="totalusernum()"/>名</td> 
      <td><input name="stock_num7" onblur="totalstocknum()"/></td> 
      <td><input name="service_project_num7" onblur="totalserviceprojectnum()"/></td> 
      <td><input name="start_project_num7" onblur="totalstartprojectnum()"/></td> 
      <td><input name="case_description7" type="text" size="30"/></td>
    </tr>
	<tr class="even">
      <td><input name="material_id8" value="" type="hidden"/><span id="org_id8" value="C6000000005378">国际项目支持分中心:</span></td>
      <td><input name="service_info8" /><input name="org_subjection_id8" value="C105078018" type="hidden"/></td>
      <td><input name="user_num8"  onblur="totalusernum()"/>名</td> 
      <td><input name="stock_num8" onblur="totalstocknum()"/></td> 
      <td><input name="service_project_num8" onblur="totalserviceprojectnum()"/></td> 
      <td><input name="start_project_num8" onblur="totalstartprojectnum()"/></td> 
      <td><input name="case_description8" type="text" size="30"/></td>
    </tr>	
	<tr class="odd">
      <td><input name="material_id9" value="" type="hidden"/><span id="org_id9" value="C6000000001929">辽河分中心:</span></td>
      <td><input name="service_info9"/><input name="org_subjection_id9" value="C105078020" type="hidden"/></td>
      <td><input name="user_num9" onblur="totalusernum()" />名</td> 
      <td><input name="stock_num9" onblur="totalstocknum()"/></td> 
      <td><input name="service_project_num9" onblur="totalserviceprojectnum()"/></td> 
      <td><input name="start_project_num9" onblur="totalstartprojectnum()"/></td> 
      <td><input name="case_description9" type="text" size="30"/></td>
    </tr>
	<tr class="even">
      <td><span>合计:</span></td>
      <td><input name="total_service_info" /></td>
      <td><input name="total_user_num"/>名</td> 
      <td><input name="total_stock_num"/></td> 
      <td><input name="total_service_project_num"/></td> 
      <td><input name="total_start_project_num"/></td>
      <td>——</td>
    </tr>	   
</table>
<div id="oper_div">
<%
if(!"view".equals(request.getParameter("action"))){
%>
<span class="bc_btn"><a href="#" onclick="save()"></a></span>
<%	
}
%>
</div>
</form>
</body>
<script type="text/javascript">
	function totalusernum(){
		if (!checkUserNum()) return;
		var total_user_num=0;
		for(var i=0;i<10;i++){
			if(document.getElementsByName("user_num"+i)[0].value==""){
				document.getElementsByName("user_num"+i)[0].value=0;
			}
			total_user_num+=parseInt(document.getElementsByName("user_num"+i)[0].value);
		}
		document.getElementsByName("total_user_num")[0].value=total_user_num;
	}
	
	function totalstocknum(){
		if (!checkStockNum()) return;
		var total_stock_num=0;
		for(var i=0;i<10;i++){
			if(document.getElementsByName("stock_num"+i)[0].value==""){
				document.getElementsByName("stock_num"+i)[0].value=0;
			}
			total_stock_num+=parseFloat(document.getElementsByName("stock_num"+i)[0].value);
			
		}
		var nums=total_stock_num.toFixed(2);
		document.getElementsByName("total_stock_num")[0].value=nums;
	}
	function totalserviceprojectnum(){
		if (!checkServiceProjectNum()) return;
		var total_service_project_num=0;
		for(var i=0;i<10;i++){
			if(document.getElementsByName("service_project_num"+i)[0].value==""){
				document.getElementsByName("service_project_num"+i)[0].value=0;
			}
			total_service_project_num+=parseInt(document.getElementsByName("service_project_num"+i)[0].value);
		}
		document.getElementsByName("total_service_project_num")[0].value=total_service_project_num;
	}
	function totalstartprojectnum(){
		if (!checkStartProjectNum()) return;
		var total_start_project_num=0;
		for(var i=0;i<10;i++){
			if(document.getElementsByName("start_project_num"+i)[0].value==""){
				document.getElementsByName("start_project_num"+i)[0].value=0;
			}
			total_start_project_num+=parseInt(document.getElementsByName("start_project_num"+i)[0].value);
		}
		document.getElementsByName("total_start_project_num")[0].value=total_start_project_num;
	}
	
	
	function initData(){			
		var data=['tableName:BGP_WR_MATERIAL_INFO','text:T','count:N','number:NN','date:D'];
		return data;
	}	
	
	function save(){
		var week_date=document.getElementsByName("week_date")[0].value;	
		var rowParams = new Array();	
		for(var i=0;i<10;i++){
			var rowParam = {};

			var material_id = document.getElementsByName("material_id"+i)[0].value;	
			var org_id = document.getElementsByName("org_id"+i)[0].value;		
			var service_info = document.getElementsByName("service_info"+i)[0].value;			
			var user_num = document.getElementsByName("user_num"+i)[0].value;
			var stock_num = document.getElementsByName("stock_num"+i)[0].value;
			var service_project_num = document.getElementsByName("service_project_num"+i)[0].value;
			var start_project_num = document.getElementsByName("start_project_num"+i)[0].value;
			var case_description=document.getElementsByName("case_description"+i)[0].value;
			var org_subjection_id=document.getElementsByName("org_subjection_id"+i)[0].value;
			
			rowParam['week_date'] = week_date;
			rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] = '<%=curDate%>';
			rowParam['mondify_date'] = '<%=curDate%>';
			rowParam['bsflag'] = '0';
			rowParam['subflag'] = '0';
						
			rowParam['material_id'] = material_id;
			rowParam['service_info'] = encodeURI(encodeURI(service_info));
			rowParam['user_num'] = user_num;
			rowParam['stock_num'] = stock_num;
			rowParam['service_project_num'] = service_project_num;
			rowParam['start_project_num'] = start_project_num;
			rowParam['case_description'] = encodeURI(encodeURI(case_description));
			rowParam['org_id'] = org_id;
			rowParam['org_subjection_id'] = org_subjection_id;
			
			rowParams[rowParams.length] = rowParam;
		}
		var rows=JSON.stringify(rowParams);
		saveFunc("BGP_WR_MATERIAL_INFO",rows);	
	}
	//提示提交结果
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '提交成功';
		if(failHint==undefined) failHint = '提交失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			alert(successHint);
			//cancel();
		}
	}
	function cancel()
	{
		//window.parent.getNextTab();
	}

	function maxyymmSelector(inputField,tributton)
	{    
    Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        weekNumbers    :    false,
		singleClick    :    true,
		step	       :	1,
		onUpdate : (function (){
				var dateValue=inputField.value;
				var daysArray= new Array();   
				daysArray=dateValue.split('-');   
		        var sdate=new Date(daysArray[0],parseInt(daysArray[1]-1),daysArray[2]);   
		        if(sdate.getDay()!=5){
		        	alert("周报日期只能选择周五，请重新选择");  
		        	inputField.value="";
		        }			
		})
    });
	}
	
	var data_week_date = '<%=request.getParameter("week_date")%>';
	var action = '<%=request.getParameter("action")%>';
	var totaluser=0;
	var totalstock=0;
	var totalservice=0;
	var totalstart=0;
	if(data_week_date!='null'){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = '<%=request.getParameter("week_end_date")%>';
		var querySql = "select m.material_id,m.org_id,m.service_info,m.user_num,m.stock_num,m.service_project_num,m.start_project_num,m.case_description from bgp_wr_material_info m where m.bsflag='0' and to_char(m.week_date,'yyyy-MM-dd') = '" + data_week_date + "'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		for (var i = 0; datas && i < 10; i++) {
			document.getElementsByName("material_id"+i)[0].value=datas[i].material_id;
			document.getElementsByName("org_id"+i)[0].value=datas[i].org_id;			
			document.getElementsByName("service_info"+i)[0].value=datas[i].service_info;			
			document.getElementsByName("user_num"+i)[0].value=datas[i].user_num;
			document.getElementsByName("stock_num"+i)[0].value=datas[i].stock_num;
			document.getElementsByName("service_project_num"+i)[0].value=datas[i].service_project_num;
			document.getElementsByName("start_project_num"+i)[0].value=datas[i].start_project_num;
			document.getElementsByName("case_description"+i)[0].value=datas[i].case_description;
			totaluser+=parseInt(datas[i].user_num);
			totalstock+=parseFloat(datas[i].stock_num);
			totalservice+=parseInt(datas[i].service_project_num);
			totalstart+=parseInt(datas[i].start_project_num);
		}
		var gettotalstock=totalstock.toFixed(2);
		if(isNaN(totaluser)){
			document.getElementsByName("total_user_num")[0].value="";
		}
		else{
			document.getElementsByName("total_user_num")[0].value=totaluser;
		}
		
		if(isNaN(gettotalstock)){
			document.getElementsByName("total_stock_num")[0].value="";
		}
		else{
			document.getElementsByName("total_stock_num")[0].value=gettotalstock;
		}
		
		if(isNaN(totalservice)){
			document.getElementsByName("total_service_project_num")[0].value="";
		}
		else{
			document.getElementsByName("total_service_project_num")[0].value=totalservice;
		}
		
		if(isNaN(totalstart)){
			document.getElementsByName("total_start_project_num")[0].value="";
		}
		else{
			document.getElementsByName("total_start_project_num")[0].value=totalstart;
		}
	}
	function checkUserNum() { 	
	 	for(var i=0;i<10;i++){
	 		if (!isValidFloatProperty7_0("user_num"+i, "现场服务人员")) {
				document.getElementsByName("user_num"+i)[0].value="";
				document.getElementsByName("user_num"+i)[0].focus();
				return false;	
			}		
	 	}
		return true;
	}
	function checkStockNum() { 	
	 	for(var i=0;i<10;i++){
	 		if (!isValidFloatProperty7_2("stock_num"+i, "期末库存")) {
	 			document.getElementsByName("stock_num"+i)[0].value="";
				document.getElementsByName("stock_num"+i)[0].focus();
				return false;	
			}		
	 	}
		return true;
	}
	function checkServiceProjectNum() { 	
	 	for(var i=0;i<10;i++){
	 		if (!isValidFloatProperty7_0("service_project_num"+i, "正在服务项目数量")) {
	 			document.getElementsByName("service_project_num"+i)[0].value="";
				document.getElementsByName("service_project_num"+i)[0].focus();
				return false;	
			}		
	 	}
		return true;
	}
	function checkStartProjectNum() { 	
	 	for(var i=0;i<10;i++){
	 		if (!isValidFloatProperty7_0("start_project_num"+i, "准备启动项目数量")) {
	 			document.getElementsByName("start_project_num"+i)[0].value="";
				document.getElementsByName("start_project_num"+i)[0].focus();
				return false;	
			}		
	 	}
		return true;
	}
</script>
</html>
