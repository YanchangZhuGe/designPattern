<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.icg.dao.IPureJdbcDao"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    
	String orgId = (user==null)?"":user.getCodeAffordOrgID();
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();
	
	IPureJdbcDao pureDao = (IPureJdbcDao)BeanFactory.getPureJdbcDAO();
	//选择数据，排序要先按照coding_code排，区分两种大类，以便后续维护。
	String sql="select coding_code_id,coding_name from comm_coding_sort_detail where coding_sort_id = '5000300003' and bsflag = '0' and (coding_code like '01%' or coding_code like '02%') order by coding_code,coding_code_id";
	List<Map> datas=pureDao.queryRecords(sql);
	Iterator<Map> it=datas.iterator();
	List<String> s1=new ArrayList<String>();
	List<String> s2=new ArrayList<String>();
	List<String> s3=new ArrayList<String>();
	List<String> s4=new ArrayList<String>();
	Map m;
	String tmp1,tmp2,code_id="'";
	
	for(int i=0,j=0;it.hasNext();i++){
		m=it.next();
		tmp1=(String)m.get("coding_name");
		tmp2=(String)m.get("coding_code_id");
		if(tmp2.equals("5000300003000000001")){//国际 继续
			continue;
		}else if(tmp2.equals("5000300003000000008")){//国内 跳出
			break;
		}else{
			s1.add(j, tmp1);	
			s2.add(j, tmp2);
			j++;
			code_id=code_id+tmp2+"','";
		}
	}
	Object[] wai_name=s1.toArray(); 
	Object[] wai_id=s2.toArray(); 
	for(int i=0,j=0;it.hasNext();i++){
		m=it.next();
		tmp1=(String)m.get("coding_name");
		tmp2=(String)m.get("coding_code_id");
		if(tmp2.equals("5000300003000000028")){//国内 继续
			continue;
		}else{
			s3.add(j, tmp1);	
			s4.add(j, tmp2);
			j++;
			code_id=code_id+tmp2+"','";
		}
	}
	System.out.println(code_id);
	Object[] nei_name=s3.toArray(); 
	Object[] nei_id=s4.toArray(); 
	code_id=code_id.substring(0, code_id.lastIndexOf(","));
%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
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
</table>

<form>
<div id="c_div" style="margin-top:2px;">
  <table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%" style="margin-top:-1px;table-layout: fixed">
	<tr class="bt_info">
	  <td rowspan="2">&nbsp;</td>
	  <td rowspan="2">型号</td>
	  <td colspan="2">总量</td>
	  <td colspan="2">在用</td>
	  <td rowspan="2">利用率</td>
	  <td colspan="2">计划投入</td>
	  <td colspan="2">闲置</td>
	  <td colspan="2">安保原因停用</td>
	  <td rowspan="2">备注</td>
	</tr>
	<tr class="bt_info">
	  <td>主机（台）</td>
	  <td>道数（道）</td>
	  <td>主机（台）</td>
	  <td>道数（道）</td>
	  <td>主机（台）</td>
	  <td>道数（道）</td>
	  <td>主机（台）</td>
	  <td>道数（道）</td>
	  <td>主机（台）</td>
	  <td>道数（道）</td>
	</tr>
	<th rowspan="8"  style="text-align: center;background-color: #e8eaeb" >国际</th>
		<%for(int j=0, i=0;j<wai_name.length;j++,i++) { %>
	<tr <%if(j%2==0) {%>class="odd" <%}else  {%> class="even" <%} %>  >
	  <td ><%=wai_name[j] %>  
	  <input name="<%= "model_name"+i%>" value="<%=wai_name[j] %>"  type="hidden"/>
	  <input name="<%= "equipment_type"+i%>" value="<%=wai_id[j] %>"  type="hidden"/></td>
	  <td ><input name="<%="instrument_id"+i%>" value=""  type="hidden"/><input type="text" name="<%= "total_num"+i %>" value="" onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input name="<%="instrument_id"+i%>" value=""  type="hidden"/><input type="text" name="<%= "total_num"+i %>" value="" onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "use_num"+i%>" value="" onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "use_num"+i%>" value="" onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "use_rate"+i%>" value="" onkeypress="return key_press_check1(this)" style="margin-left:5px; ime-mode:disabled;width: 70px" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;">%&nbsp;</td>
	  <td ><input type="text" name="<%= "plan_num"+i%>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "plan_num"+i%>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "notuse_num"+i%>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "notuse_num"+i%>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "safety_num"+i%>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "safety_num"+i%>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "notes"+i%>" value="" ></td>
	</tr> 
	<% } %>
  </table>
  <div id="c_div" style="margin-top:2px;">
  <table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%" style="margin-top:-1px;table-layout: fixed">
	<tr class="bt_info">
	<td rowspan="2">&nbsp;</td>
	  <td rowspan="2">型号</td>
	  <td colspan="2">总量</td>
	  <td colspan="2">在用</td>
	  <td rowspan="2">利用率%</td>
	  <td colspan="2">计划投入</td>
	  <td rowspan="2">占用率%</td>
	  <td colspan="2">待报废数量</td>
	  <td colspan="2">可调用</td>
	  <td rowspan="2">备注</td>
	</tr>
	<tr class="bt_info">
	  <td>主机（台）</td>
	  <td>道数（道）</td>
	  <td>主机（台）</td>
	  <td>道数（道）</td>
	  <td>主机（台）</td>
	  <td>道数（道）</td>
	  <td>主机（台）</td>
	  <td>道数（道）</td>
	  <td>主机（台）</td>
	  <td>道数（道）</td>
	</tr>
	<th rowspan="8"  style="text-align: center;background-color: #e8eaeb" >国内</th>
	<%for(int j=0, i=wai_name.length;j<nei_name.length;j++,i++) { %>
	<tr <%if(j%2==0) {%>class="odd" <%}else  {%> class="even" <%} %>  >
	  <td ><%=nei_name[j] %> 
	  <input name="<%= "model_name"+i%>" value="<%=nei_name[j] %>"  type="hidden"/>
	  <input name="<%= "equipment_type"+i%>" value="<%=nei_id[j] %>"  type="hidden"/></td>
	  <td ><input name="<%="instrument_id"+i%>" value=""  type="hidden"/><input type="text" name="<%= "total_num"+i %>" value="" onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input name="<%="instrument_id"+i%>" value=""  type="hidden"/><input type="text" name="<%= "total_num"+i %>" value="" onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "use_num"+i%>" value="" onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "use_num"+i%>" value="" onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "use_rate"+i%>" value="" onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;">%&nbsp;</td>
	  <td ><input type="text" name="<%= "plan_num"+i%>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "plan_num"+i%>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "occupy_rate"+i%>" value="" onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;">%&nbsp;</td>
	  <td ><input type="text" name="<%= "safety_num"+i%>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "safety_num"+i%>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "trusfer_num"+i %>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "trusfer_num"+i %>" value=""  onkeypress="return key_press_check1(this)"  onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "notes"+i %>" value="" ></td>
	</tr> 
	<% } %>
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
	var data_org_id = '<%=request.getParameter("org_id")%>';
	var data_week_date = '<%=request.getParameter("week_date")%>';
	var action = '<%=request.getParameter("action")%>';
	
	var length=<%=wai_name.length%>+<%=nei_name.length%>;
	var len=<%=wai_name.length%>;
	var code_id="<%=code_id%>";
	
	function save(){
		var week_date=getObj("week_date").value;
		var rowParams = new Array();
		for(var i=0;i<length;i++){//length为仪器名称数组的长度，决定保存的数据条数。
			for(var j=0;j<2;j++){
					var total_num = document.getElementsByName("total_num"+i)[j].value;
					var use_num = document.getElementsByName("use_num"+i)[j].value;
					var plan_num = document.getElementsByName("plan_num"+i)[j].value;
					if(i<len){
						var notuse_num = document.getElementsByName("notuse_num"+i)[j].value;
						var safety_num= document.getElementsByName("safety_num"+i)[j].value;
					}else{
						var trusfer_num = document.getElementsByName("trusfer_num"+i)[j].value;
						var safety_num= document.getElementsByName("safety_num"+i)[j].value;
						var occupy_rate = document.getElementsByName("occupy_rate"+i)[0].value;
					}
					var instrument_id=document.getElementsByName("instrument_id"+i)[j].value;
					var equipment_type= document.getElementsByName("equipment_type"+i)[0].value;
					var use_rate = document.getElementsByName("use_rate"+i)[0].value;
					var notes = document.getElementsByName("notes"+i)[0].value;
					
					var rowParam = {};//对应一行库表数据
					rowParam['instrument_id'] = instrument_id;
					rowParam['week_date'] = week_date;
					rowParam['org_id'] = org_id;
					rowParam['org_subjection_id'] = org_subjection_id;
					
					if(j==0)rowParam['instrument_type'] = '1';    //主机1，道数2
					if(j==1)rowParam['instrument_type'] = '2';
					
					rowParam['country'] = i<(len)?'2':'1';//国内1，国外2
					rowParam['total_num'] = total_num;
					rowParam['use_num'] = use_num;
					rowParam['plan_num'] = plan_num;
					rowParam['trusfer_num'] = trusfer_num;
					rowParam['notuse_num'] = notuse_num;
					rowParam['safety_num'] = safety_num;
					rowParam['equipment_type'] = equipment_type;
					rowParam['use_rate'] = use_rate;
					rowParam['occupy_rate'] = occupy_rate;
					rowParam['notes'] = encodeURI(encodeURI(notes));
					rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['create_date'] = '<%=curDate%>';
					rowParam['mondify_date'] = '<%=curDate%>';
					rowParam['bsflag'] = '0';
					rowParam['subflag'] = '0';
		
					rowParams[rowParams.length] = rowParam;
			}
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
	function fncKeyStop(evt) { 
		if(!window.event) { 
			var keycode = evt.keyCode; 
			var key = String.fromCharCode(keycode).toLowerCase(); 
			if(evt.ctrlKey && key == "v") { 
				evt.preventDefault(); evt.stopPropagation();
				} 
			} 
	}
	function cancel()
	{
		//window.parent.getNextTab();
	}
	// 获取数据  辽河与海上的数据与其他部门的数据是通过org_id权限来区分的，故superadmin添加的数据会造成数据重复。
	var dataFlag=false;//用于标识提取的数据
	if(data_week_date!='null'){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = '<%=request.getParameter("week_end_date")%>';
	
		var querySql = "select t.instrument_id,t.total_num,t.use_num,t.plan_num,t.trusfer_num,t.notuse_num,t.safety_num,t.equipment_type,t.notes,t.use_rate,t.occupy_rate  from BGP_WR_INSTRUMENT_INFO t where t.org_id='"+data_org_id+"' and t.week_date = to_date('"+data_week_date+"','yyyy/MM/dd') and equipment_type in ("+code_id+") and t.bsflag='0' order by country desc,equipment_type,instrument_type ";
		var queryRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		if(queryRet.datas.length!='0'){//view,edit,add三种情况，都是先选取本期数据，如果有，进行填充
			fillDatas(queryRet.datas);
		}else if(action=='add'||action=='edit'){//view没本期数据的话，空白；add和edit，无本期数据，选择上期数据，不带ID
			
			//抽取数据,若为辽河或海上录入则取上期数据，否则从系统中的设备台账中抽取
			<% if(orgSubjectionId.startsWith("C105007")||orgSubjectionId.startsWith("C105063")){%>			
				querySql = "select t.total_num,t.use_num,t.plan_num,t.trusfer_num,t.notuse_num,t.safety_num,t.equipment_type,t.notes,t.use_rate,t.occupy_rate  from BGP_WR_INSTRUMENT_INFO t where t.org_id='"+data_org_id+"' and t.week_date =(select week_date from (select week_date from bgp_wr_instrument_info where subflag='1' and bsflag='0' order by week_date desc) where rownum='1' ) and equipment_type in ("+code_id+") and t.bsflag='0' order by country desc,equipment_type,instrument_type ";
				queryRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
				if(queryRet.datas.length!='0'){
					dataFlag=true;
					fillDatas(queryRet.datas);
					document.getElementById("msg").innerHTML="<font color='red'>注意：显示为上次审批通过的数据，请修改后点击“下一步”</font> <input type='reset' class='iButton2' value='清空'/>";
				}
			<% }else{%>
				queryRet = jcdpCallService('DataExtractSrv','getSeismicInstrumentInfo','');
				var datas = queryRet.datas;
				if(datas.length!='0'){
					dataFlag=true;
					fillExtractDatas(datas);
					document.getElementById("msg").innerHTML="<font color='red'>注意：显示为系统抽取的数据，请修改后点击“下一步”</font> <input type='reset' class='iButton2' value='清空'/>";
				}
			<% }%>
		}
	}
	
	function fillExtractDatas(datas){
		var i='<%=wai_name.length%>';
		for(var i=<%=wai_name.length%>;i<<%=wai_name.length+nei_name.length%>;i++){
			for(var j=0;j<datas.length;j++){
				var data=datas[j];
				var modelName=document.getElementsByName("model_name"+i)[0].value;
				if(modelName==data.classifyModel){
					document.getElementsByName("total_num"+i)[0].value=data.allNum;
					document.getElementsByName("total_num"+i)[1].value=data.allTracksNum;
					document.getElementsByName("use_num"+i)[0].value=data.useNum;
					document.getElementsByName("use_num"+i)[1].value=data.useTracksNum;
					document.getElementsByName("safety_num"+i)[0].value=data.obsolescentNum;
					document.getElementsByName("safety_num"+i)[1].value=data.obsolescentTracksNum;
					document.getElementsByName("trusfer_num"+i)[0].value=data.allTracksNum-data.useTracksNum-data.obsolescentTracksNum;
					document.getElementsByName("trusfer_num"+i)[1].value=data.allTracksNum-data.useTracksNum-data.obsolescentTracksNum;
					document.getElementsByName("occupy_rate"+i)[0].value='';
					if(dataFlag==true){
						data.instrument_id='';
					}
					document.getElementsByName("instrument_id"+i)[0].value=data.instrument_id;
					document.getElementsByName("instrument_id"+i)[1].value=data.instrument_id;
					document.getElementsByName("use_rate"+i)[0].value='';
					datas.splice(j,1);
					break;
				}
			}
		}
	}
	
	function fillDatas(datas){
		for(var i=0;i<(datas.length/2);i++){
			 var data_1 = datas[2*i]; 
			 var data_2 = datas[2*i+1]; 
			 var data;
			 //alert(datas.length/2);
			 if(data_1==null||data_2==null)continue;
			 for(var j=0;j<2;j++){
				 if(j==0)data=data_1;
				 if(j==1)data=data_2;
				 if(data.equipment_type==document.getElementsByName("equipment_type"+i)[0].value){
						document.getElementsByName("total_num"+i)[j].value=data.total_num;
						document.getElementsByName("use_num"+i)[j].value=data.use_num;
						document.getElementsByName("plan_num"+i)[j].value=data.plan_num;
						if(i<len){
							document.getElementsByName("notuse_num"+i)[j].value=data.notuse_num;
							document.getElementsByName("safety_num"+i)[j].value=data.safety_num;
						}else{
							document.getElementsByName("trusfer_num"+i)[j].value=data.trusfer_num;
							document.getElementsByName("occupy_rate"+i)[0].value=data.occupy_rate;
							document.getElementsByName("safety_num"+i)[j].value=data.safety_num;
						}
						if(dataFlag==true){
							data.instrument_id='';
						}
						document.getElementsByName("instrument_id"+i)[j].value=data.instrument_id;
						document.getElementsByName("use_rate"+i)[0].value=data.use_rate;
						document.getElementsByName("notes"+i)[0].value=data.notes;
				 }
			 }
	     }
		dataFlag=false;
	}
	// 如果是查看页面，设置为readonly
	function setReadOnly(){
		for(var i=0;i<len;i++){
			for(var j=0;j<2;j++){
				document.getElementsByName("total_num"+i)[j].readOnly=true;
				document.getElementsByName("use_num"+i)[j].readOnly=true;
				document.getElementsByName("plan_num"+i)[j].readOnly=true;
				document.getElementsByName("notuse_num"+i)[j].readOnly=true;
				document.getElementsByName("safety_num"+i)[j].readOnly=true;
		 	}
			document.getElementsByName("notes"+i)[0].readOnly=true;
			document.getElementsByName("use_rate"+i)[0].readOnly=true;
	    }
		for(var i=len;i<length;i++){
			for(var j=0;j<2;j++){
				document.getElementsByName("total_num"+i)[j].readOnly=true;
				document.getElementsByName("use_num"+i)[j].readOnly=true;
				document.getElementsByName("plan_num"+i)[j].readOnly=true;
				document.getElementsByName("trusfer_num"+i)[j].readOnly=true;
		 	}
			document.getElementsByName("notes"+i)[0].readOnly=true;
			document.getElementsByName("use_rate"+i)[0].readOnly=true;
			document.getElementsByName("occupy_rate"+i)[0].readOnly=true;
	    }
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
		if(!(reg.test(nextvalue)))return false;
		return true;
	}
</script>
</html>