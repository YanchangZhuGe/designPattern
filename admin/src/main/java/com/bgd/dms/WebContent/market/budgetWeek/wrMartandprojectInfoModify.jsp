<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.List"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	
    String weekDate = resultMsg.getValue("weekDate");
    String weekEndDate = resultMsg.getValue("weekEndDate");
    String orgId = resultMsg.getValue("orgId");
    String action = resultMsg.getValue("action");
    
    List<MsgElement> list1 = resultMsg.getMsgElements("list1");
    List<MsgElement> list2 = resultMsg.getMsgElements("list2");
    List<MsgElement> list3 = resultMsg.getMsgElements("list3");
    List<MsgElement> list4 = resultMsg.getMsgElements("list4");
    List<MsgElement> list5 = resultMsg.getMsgElements("list5");
    Map map1 =new HashMap();
    Map map2 =new HashMap();
    Map map3 =new HashMap();
    Map map4 =new HashMap();
    Map map5 =new HashMap();
    if(list1!=null){
  		 for(int i= 0;i<list1.size();i++){
			map1=list1.get(i).toMap();
  		 }
    }
    if(list2!=null){
 		 for(int i= 0;i<list2.size();i++){
			map2=list2.get(i).toMap();
 		 }
   }
    if(list3!=null){
 		 for(int i= 0;i<list3.size();i++){
			map3=list3.get(i).toMap();
 		 }
   }
    if(list4!=null){
 		 for(int i= 0;i<list4.size();i++){
			map4=list4.get(i).toMap();
 		 }
   }
    if(list5!=null){
 		 for(int i= 0;i<list5.size();i++){
			map5=list5.get(i).toMap();
 		 }
   }
    
    String adf =(String)map1.get("martandproId");
    String adf2 =(String)map2.get("martandproId");
    String adf3 =(String)map3.get("martandproId");
    String a4=(String)map4.get("martandproId");
    String adf5 =(String)map5.get("martandproId");
	
	System.out.println(map1);
	System.out.println(map2);
	System.out.println(map3);
	System.out.println(map4);
	System.out.println(map5);
	
    
%>
<html>
<head>
<title>生产经营情况</title>
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
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/week/updateWeekReport.srq">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
	<input name="orgId" type="hidden" value="<%=orgId%>"/>
	
    <tr class="odd">
    	<td class="rtCRUFdName">周报开始日期：</td>
      	<td class="rtCRUFdValue"><input type="text" id="week_date" class="input_width"  name="week_date" value="<%=weekDate %>" readonly onchange="set_week_end_date(this.value)">
      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16"  style="cursor:hand;" onmouseover="fridaySelector(week_date,tributton0);"/>
      	</td>
      	<td class="rtCRUFdName">周报结束日期：</td>
      	<td class="rtCRUFdValue"><input type="text" id="week_end_date" class="input_width"  name="week_end_date" value="<%=weekEndDate %>" readonly>
      	</td>
    </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" id="lineTable" class="form_info" width="100%" style="margin-top:-1px;">
    <tr class="bt_info">
      <td  class="tableHeader" width="20%">类别</td>
      <td class="tableHeader" width="40%">内容</td>
    </tr>
 
	<tr>
      <td>本周中标及新签价值工作量情况说明</td>
      <input name="martandId1" id="martandId1" type="hidden" value="<%=(String)map1.get("martandproId") %>"/>
      <td colspan="3" ><textarea  id="typeOne" name="typeOne" ><%=(String)map1.get("content") %></textarea></td> 
    </tr>
    <tr>
      <td>投标项目跟踪</td>
      <input name="martandId2" id="martandId2" type="hidden" value="<%=(String)map2.get("martandproId") %>"/>
      <td colspan="3" ><textarea  id="typeTwo" name="typeTwo" ><%=(String)map2.get("content") %></textarea></td> 
    </tr>
	<tr>
      <td>市场开发动态</td>
      <input name="martandId3" id="martandId3" type="hidden" value="<%=(String)map3.get("martandproId") %>"/>
      <td colspan="3" ><textarea  id="typeThree" name="typeThree" ><%=(String)map3.get("content") %></textarea></td> 
    </tr>
    <tr>
      <td>油田公司动态</td>
      <input name="martandId4" id="martandId4" type="hidden" value="<%=(String)map4.get("martandproId") %>"/>
      <td><textarea  id="typeFour" name="typeFour"><%=(String)map4.get("content") %></textarea></td> 
    </tr>
    <tr>
      <td>物探公司动态</td>
      <input name="martandId5" id="martandId5" type="hidden" value="<%=(String)map5.get("martandproId") %>"/>
      <td><textarea  id="typeFive" name="typeFive" ><%=(String)map5.get("content") %></textarea></td> 
    </tr>
</table>

<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;">
  <tr class="odd">
    <td colspan="4" class="ali3">
       		<% if(action.equals("edit")){%>
        	<input name="Submit2" type="button" class="iButton2" style="display:<%="view".equals(request.getParameter("action"))?"none":"" %>" onClick="save()" value="保存" />
       		<%	}%>
       		<input name="Submit2" type="button" class="iButton2" onClick="cancel()" value="返回" />   	
    	
    </td>
  </tr> 
</table>
</form>
</body>
<script type="text/javascript">

	function initData(){			
		var data=['tableName:bgp_wr_martandproject_info','text:T','count:N','number:NN','date:D'];
		return data;
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
	//提示提交结果
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
			window.location = "<%=contextPath%>/market/month/monthReport.srq?orgId=<%=orgId%>";
		}
	}
	function cancel()
	{
		window.location="<%=contextPath%>/market/week/weekReport.srq?orgId=<%=orgId%>";
	}

	function cancelNext()
	{
		window.parent.getNextTab();
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
	
	var data_org_id = '<%=orgId%>';
	var data_week_date = '<%=request.getParameter("week_date")%>';
	var data_week_end_date = '<%=request.getParameter("week_end_date")%>';
	var action = '<%=request.getParameter("action")%>';
	var isSecond = '<%=request.getParameter("isSecond")%>';

	if(data_week_date!='null'){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = '<%=request.getParameter("week_end_date")%>';
		
		var querySql = "select i.* from bgp_wr_martandproject_info i where i.org_id = '" + data_org_id + "' and to_char(i.week_date,'yyyy-MM-dd') = '" + data_week_date + "' and i.bsflag='0' and i.type='2' order by typeid";
		
		if(isSecond == 'false' && action == 'add'){
			
			querySql = "select i.typeid,i.content from bgp_wr_martandproject_info i where to_char(i.week_date,'yyyy-MM-dd') = '" + data_week_date + "' and  i.org_id = '" + data_org_id + "' and i.bsflag='0' and i.type='2' order by typeid";
		}
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);

		var datas = queryRet.datas;
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
        if(data_org_id !='null' || data_week_date !='null' || data_week_end_date !='null'){
        	doSave();
        } else{
	        var querySql = "select i.* from bgp_wr_martandproject_info i where i.org_id = '<%=orgId%>' and to_char(i.week_date,'yyyy-MM-dd') = '" + week_date + "' and i.bsflag='0' and i.type='2' order by typeid";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
			var datas = queryRet.datas;
			if(datas != null && queryRet.datas.length){
				var flag=false;
					if(confirm("周报开始日期已存在,修改该记录请点确定,否则取消!")){
						flag=true;
						var datas = queryRet.datas;
						for (var i = 0; datas && i < 5; i++) {
							document.getElementsByName("martandpro_id"+i)[0].value=datas[i].martandpro_id;
						}	
					 }
					
					if(flag){
						doSave();
					}										
			}else{
				doSave();
			}
        }
	}

	function doSave(){
		document.getElementById("form1").submit();
	}

	
</script>
</html>
