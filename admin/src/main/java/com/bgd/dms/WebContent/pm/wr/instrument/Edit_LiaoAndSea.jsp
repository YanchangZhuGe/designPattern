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
    
	String orgId = (user==null)?"":user.getCodeAffordOrgID();
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();
	String org_name=user.getOrgName();
	String[] equipment_names={"408UL","428","I/O SCORPION","ARIES","数字400系列"};
	String[] equipment_ids={"5000300003000000009","5000300003000000010","5000300003000000011","5000300003000000012","5000300003000000013"};
%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>周报录入</title>
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


<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" media="all" /> 

</head>
<body style="background:#fff">
<form>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	  <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	  <td background="<%=contextPath%>/images/list_15.png">
			<table border="0" cellpadding="0" cellspacing="0"  width="100%" >
  				<tr>
  				<td class="ali3"><font color=red>*</font>&nbsp;周报日期：</td>
    			<td class="ali1"><input type="text" id="week_date" class="input_width"  name="week_date" value="" readonly>
      &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton" width="16" height="16"  style="cursor:hand;" onMouseOver="calDateSelector(week_date,tributton);"/></td>
        		<td class="ali3">&nbsp;单位名称：</td>
	    		<td class="ali1">&nbsp;<%=org_name %></td>
    		</tr>
    		
</table>
		</td>
	  </tr>
</table>
<div id="c_div" style="margin-top:2px;">
  <table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%" style="margin-top:-1px;">
	<tr class="bt_info">
	  <td>&nbsp;</td>
	  <td>型号</td>
	  <td>总量</td>
	  <td>在用</td>
	  <td>计划投入</td>
	  <td>可调用</td>
	  <td style= "display:none ">闲置</td>
	  <td style= "display:none ">安保原因停用</td>
	</tr>
	 <th rowspan="6"  style="text-align: center;background-color: #e8eaeb" >主机</th>
	<%for(int i=0;i<equipment_names.length;i++) {%>
	<tr <%if(i%2==0) {%>class="odd" <%}else  {%> class="even" <%} %>  >
	  <td ><%=equipment_names[i] %> <input name="<%="instrument_id"+i%>" value=""  type="hidden"/><input name="<%= "equipment_type"+i%>" value="<%=equipment_ids[i] %>"  type="hidden"/></td>
	  <td ><input type="text" name="<%= "total_num"+i %>" value="" onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "use_num"+i%>" value="" onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "plan_num"+i%>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "trusfer_num"+i %>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td  style= "display:none "><input type="text" name="<%= "notuse_num"+i%>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td  style= "display:none "><input type="text" name="<%= "safety_num"+i%>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	</tr> 
	<%} %>
  </table>
</div>
<div id="c_div" style="margin-top:2px;">
  <table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%" style="margin-top:-1px;">
	<tr class="bt_info">
	   <td>&nbsp;</td>
	  <td>型号</td>
	  <td>总量</td>
	  <td>在用</td>
	  <td>计划投入</td>
	  <td>可调用</td>
	  <td style= "display:none ">闲置</td>
	  <td style= "display:none ">安保原因停用</td>
	</tr>
	
	  <th rowspan="6"  style="text-align: center;background-color: #e8eaeb" >道数</th>
	<%for(int j=0, i=equipment_names.length;j<equipment_names.length;j++,i++) { %>
	<tr <%if(j%2==0) {%>class="odd" <%}else  {%> class="even" <%} %>  >
	  <td ><%=equipment_names[j] %> <input name="<%="instrument_id"+i%>" value=""  type="hidden"/><input name="<%= "equipment_type"+i%>" value="<%=equipment_ids[j] %>"  type="hidden"/></td>
	  <td ><input type="text" name="<%= "total_num"+i %>" value="" onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "use_num"+i%>" value="" onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "plan_num"+i%>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "trusfer_num"+i %>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td  style= "display:none "><input type="text" name="<%= "notuse_num"+i%>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td  style= "display:none "><input type="text" name="<%= "safety_num"+i%>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	</tr>
	<% } %>
	
  </table>
</div>

<div id="c_div" style="margin-top:2px;">
  <table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%" style="margin-top:-1px;">
    <tr class="text11">
  	  <td class="inquire_item6" >&nbsp;备注：</td>
      <td class="inquire_from6"  colspan="6">
	    	<textarea name="notes" id="notes"  cols="60" rows="3" maxLength="1000"/>
            </textarea>
	    </td>
	</tr>
    </table>
 </div>
 
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
	function initData(){			
		var data=['tableName:bgp_wr_instrument_info','text:T','count:N','number:NN','date:D'];
		return data;
	}

	cruConfig.contextPath = "<%=contextPath%>";
	var org_id="<%=orgId%>";
	var org_subjection_id="<%=orgSubjectionId%>";
	var country=["1","2"];//国内1，国外2
	var instrument_type=["1","2"];//主机1，道数2
	var data_org_id = '<%=request.getParameter("org_id")%>';
	var data_week_date = '<%=request.getParameter("week_date")%>';
	var action = '<%=request.getParameter("action")%>';
	
	var week_date ="";
	var length=<%=equipment_names.length*2%>;
	
	function fncKeyStop(evt) { 
		if(!window.event) { 
			var keycode = evt.keyCode; 
			var key = String.fromCharCode(keycode).toLowerCase(); 
			if(evt.ctrlKey && key == "v") { 
				evt.preventDefault(); evt.stopPropagation();
				} 
			} 
	}
	
	function save(){
		
		var week_date=getObj("week_date").value;
		var notes = getObj("notes").value;
		
		if(week_date==""){
			alert("请选择周报日期");
			return false;
		}
		
		var exist=checkExist(week_date,org_id);
		if(exist!="" && week_date==exist){
			alert("本周的数据已存在");
			return false;
		}
		
		var rowParams = new Array();
        
       
		for(var i=0;i<length;i++){
			
			var instrument_id=document.getElementsByName("instrument_id"+i)[0].value;
			var total_num = document.getElementsByName("total_num"+i)[0].value;
			var use_num = document.getElementsByName("use_num"+i)[0].value;
			var plan_num = document.getElementsByName("plan_num"+i)[0].value;
			var trusfer_num = document.getElementsByName("trusfer_num"+i)[0].value;
			var notuse_num = document.getElementsByName("notuse_num"+i)[0].value;
			var safety_num= document.getElementsByName("safety_num"+i)[0].value;
			var equipment_type= document.getElementsByName("equipment_type"+i)[0].value;
			
			//alert(total_num);
			var rowParam = {};//对应一行库表数据
			rowParam['instrument_id'] = instrument_id;
			rowParam['week_date'] = week_date;
			rowParam['notes'] = notes;
			rowParam['org_id'] = '<%=orgId%>';
			rowParam['org_subjection_id'] = '<%=orgSubjectionId%>';
			
			rowParam['country'] = '0';
			rowParam['instrument_type'] = i<5?instrument_type[0]:instrument_type[1];
			
			rowParam['total_num'] = total_num==null?'0':total_num;
			rowParam['use_num'] = use_num==null?'0':use_num;
			rowParam['plan_num'] = plan_num==null?'0':plan_num;
			rowParam['trusfer_num'] = trusfer_num==null?'0':trusfer_num;
			rowParam['notuse_num'] = notuse_num==null?'0':notuse_num;
			rowParam['safety_num'] = safety_num==null?'0':safety_num;
			rowParam['equipment_type'] = equipment_type==null?'0':equipment_type;
			
			
			rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] = '<%=curDate%>';
			rowParam['mondify_date'] = '<%=curDate%>';
			rowParam['bsflag'] = '0';
			rowParam['subflag'] = '0';

			rowParams[rowParams.length] = rowParam;
		}
		
		var rows=JSON.stringify(rowParams);
		
		saveFunc("BGP_WR_INSTRUMENT_INFO",rows);
		
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
	
	// 检查一个单位一个周期的数据是否存在
	function checkExist(week_date,ord_id){
	
		var querySql = "select t.week_date from BGP_WR_INSTRUMENT_INFO t where t.org_id='"+org_id+"' and  t.bsflag='0' and  t.week_date=to_date('"+week_date+"','yyyy-MM-dd')";
		var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas[0]) return queryOrgRet.datas[0].week_date;
		else return ""; 
	}
	

	function cancel(){
		//window.location='<%=contextPath%>/pm/wr/instrument/List_LiaoAndSea.lpmd';
	}

	// 获取数据
	function getData(){
		
		var querySql = "select t.week_date,t.org_id,t.notes from BGP_WR_INSTRUMENT_INFO t where t.org_id='"+data_org_id+"' and t.week_date = to_date('"+data_week_date+"','yyyy/MM/dd') and t.bsflag='0' ";
		var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas[0]){
			 var data = queryOrgRet.datas[0];
			 getObj("week_date").value=data.week_date;
			 getObj("notes").value=data.notes;
			 org_id=data.org_id;
			 //alert(data.notes);
		}

		querySql = "select t.instrument_id,t.total_num,t.use_num,t.plan_num,t.trusfer_num,t.notuse_num,t.safety_num,t.equipment_type  from BGP_WR_INSTRUMENT_INFO t where t.org_id='"+data_org_id+"' and t.week_date = to_date('"+data_week_date+"','yyyy/MM/dd') and t.bsflag='0' order by country,instrument_type ";
		queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
		if(queryOrgRet.datas){
		     var datas = queryOrgRet.datas;
		     for(var i=0;i<length;i++){
				 var data = queryOrgRet.datas[i];
				 if(data==null)continue;
				//alert(data.total_num);
				document.getElementsByName("instrument_id"+i)[0].value=data.instrument_id;
				document.getElementsByName("total_num"+i)[0].value=data.total_num;
				document.getElementsByName("use_num"+i)[0].value=data.use_num;
				document.getElementsByName("plan_num"+i)[0].value=data.plan_num;
				document.getElementsByName("trusfer_num"+i)[0].value=data.trusfer_num;
				document.getElementsByName("notuse_num"+i)[0].value=data.notuse_num;
				document.getElementsByName("safety_num"+i)[0].value=data.safety_num;
				document.getElementsByName("equipment_type"+i)[0].value=data.equipment_type;
				
		     }
		}
		
		
	}
	if(action=='view'||action=='edit') getData();

	// 如果是查看页面，设置为readonly
	function setReadOnly(){

		getObj("notes").readOnly = true;
				
		for(var i=0;i<length;i++){
			document.getElementsByName("total_num"+i)[0].readOnly=true;
			document.getElementsByName("use_num"+i)[0].readOnly=true;
			document.getElementsByName("plan_num"+i)[0].readOnly=true;
			document.getElementsByName("trusfer_num"+i)[0].readOnly=true;
			document.getElementsByName("notuse_num"+i)[0].readOnly=true;
			document.getElementsByName("safety_num"+i)[0].readOnly=true;
	    }
        getObj("tributton").style.display="none";
	    
	    
	}

	if(action=='view' )setReadOnly();


	// 检查number(15,2)
	function key_press_check1(obj)
	{
		var keycode = event.keyCode;

		if(keycode > 57 || keycode < 45 || keycode==47)
		{
			return false;
		}

		var reg = /^[0-9]{0,13}(\.[0-9]{0,2})?$/;

		var nextvalue = obj.value+String.fromCharCode(keycode);
		
		if(!(reg.test(nextvalue)))
		{
			return false;
		}
		return true;
	}

</script>
</html>