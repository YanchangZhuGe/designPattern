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
	//String[] focus_names={"KZ28","KZ34","ION","SM26"};
	//String[] focus_ids={"5000300003000000020","5000300003000000021","5000300003000000022","5000300003000000023"};
	
	IPureJdbcDao pureDao = (IPureJdbcDao)BeanFactory.getPureJdbcDAO();
	//选择数据，排序要先按照coding_code排，区分两种大类，以便后续维护。
	String sql="select coding_code_id,coding_name from comm_coding_sort_detail where coding_sort_id = '5000300003' and bsflag = '0' and (coding_code like '03%') order by coding_code,coding_code_id";
	List<Map> datas=pureDao.queryRecords(sql);
	Iterator<Map> it=datas.iterator();
	List<String> s1=new ArrayList<String>();
	List<String> s2=new ArrayList<String>();
	Map m;
	String tmp1,tmp2,code_id="'";
	
	for(int i=0,j=0;it.hasNext();i++){
		m=it.next();
		tmp1=(String)m.get("coding_name");
		tmp2=(String)m.get("coding_code_id");
		if(tmp2.equals("5000300003000000014")){//国际可控震源 继续
			continue;
		}
		s1.add(j, tmp1);	
		s2.add(j, tmp2);
		j++;
		code_id=code_id+tmp2+"','";
	}
	Object[] focus_names=s1.toArray(); 
	Object[] focus_ids=s2.toArray(); 
	
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
  <table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%" style="margin-top:-1px;">
	<tr class="bt_info">
	  <td>型号</td>
	  <td>总量（台）</td>
	  <td>在用（台）</td>
	  <td>计划投入（台）</td>
	  <td>停用（台）</td>
	  <td>闲置</td>
	  <td>停用说明</td>
	  <td>备注</td>
	</tr>
	
	<%for(int i=0;i<focus_names.length;i++) { %>
	<tr <%if(i%2==0) {%>class="odd" <%}else  {%> class="even" <%} %>  >
	  <td ><%=focus_names[i] %> <input name="<%="focus_id"+i%>" value=""  type="hidden"/><input name="<%= "equipment_type"+i%>" value="<%=focus_ids[i] %>"  type="hidden"/></td>
	  <td ><input type="text" name="<%= "total_num"+i %>" value="" onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "use_num"+i%>" value="" onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "plan_num"+i%>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "notuse_num"+i %>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "stopuser_num"+i %>" value=""  onkeypress="return key_press_check1(this)" style="ime-mode:disabled" onkeydown="fncKeyStop(event)" onpaste="return false" oncontextmenu = "return false;"></td>
	  <td ><input type="text" name="<%= "exlain_info"+i%>" value=""  ></td>
	  <td ><input type="text" name="<%= "notes"+i%>" value="" ></td>
	</tr> 
	<% } %>
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
	function initData(){			
		var data=['tableName:BGP_WR_FOCUS_INFO','text:T','count:N','number:NN','date:D'];
		return data;
	}

	cruConfig.contextPath = "<%=contextPath%>";
	var org_subjection_id="<%=orgSubjectionId%>";
	var typeid=["1","2"];//可控震源1，测量仪器2,没用到
	var data_org_id = '<%=request.getParameter("org_id")%>';
	var data_week_date = '<%=request.getParameter("week_date")%>';
	var action = '<%=request.getParameter("action")%>';
	
	var length=<%=focus_names.length%>;
	var code_id="<%=code_id%>";
	
	function save(){
		var week_date=getObj("week_date").value;
		var rowParams = new Array();
		for(var i=0;i<length;i++){
			var focus_id=document.getElementsByName("focus_id"+i)[0].value;
			var total_num = document.getElementsByName("total_num"+i)[0].value;
			var use_num = document.getElementsByName("use_num"+i)[0].value;
			var plan_num = document.getElementsByName("plan_num"+i)[0].value;
			var notuse_num = document.getElementsByName("notuse_num"+i)[0].value;
			var stopuser_num = document.getElementsByName("stopuser_num"+i)[0].value;
			var exlain_info= document.getElementsByName("exlain_info"+i)[0].value;
			var equipment_type= document.getElementsByName("equipment_type"+i)[0].value;
			var notes= document.getElementsByName("notes"+i)[0].value;
			
			var rowParam = {};//对应一行库表数据
			rowParam['focus_id'] = focus_id;
			rowParam['week_date'] = week_date;
			rowParam['org_id'] = '<%=orgId%>';
			rowParam['org_subjection_id'] = '<%=orgSubjectionId%>';
			rowParam['typeid'] = '1';//可控震源
			rowParam['country'] = '2';//国际
			rowParam['total_num'] = total_num;
			rowParam['use_num'] = use_num;
			rowParam['plan_num'] = plan_num;
			rowParam['notuse_num'] = notuse_num;
			rowParam['stopuser_num'] = stopuser_num;
			rowParam['exlain_info'] = encodeURI(encodeURI(exlain_info));
			rowParam['equipment_type'] = equipment_type;
			rowParam['notes'] = encodeURI(encodeURI(notes));
			
			rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] = '<%=curDate%>';
			rowParam['mondify_date'] = '<%=curDate%>';
			rowParam['bsflag'] = '0';
			rowParam['subflag'] = '0';

			rowParams[rowParams.length] = rowParam;
		}
		var rows=rowParams.toJSONString();
		saveFunc("BGP_WR_FOCUS_INFO",rows);
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

	function fncKeyStop(evt) { 
		if(!window.event) { 
			var keycode = evt.keyCode; 
			var key = String.fromCharCode(keycode).toLowerCase(); 
			if(evt.ctrlKey && key == "v") { 
				evt.preventDefault(); evt.stopPropagation();
				} 
			} 
	}
	// 获取数据
	var dataFlag=false;//用于标识提取的数据
	if(data_week_date!='null'){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = '<%=request.getParameter("week_end_date")%>';
		
		var querySql = "select t.focus_id,t.total_num,t.use_num,t.plan_num,t.notuse_num,t.stopuser_num,t.exlain_info,t.equipment_type,t.notes from BGP_WR_FOCUS_INFO t where t.org_id='"+data_org_id+"' and t.week_date = to_date('"+data_week_date+"','yyyy/MM/dd') and equipment_type in ("+code_id+") and t.bsflag='0' and t.country='2' order by typeid desc,equipment_type ";
		var queryRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		if(queryRet.datas.length!='0'){//view,edit,add三种情况，都是先选取本期数据，如果有，进行填充
			fillDatas(queryRet.datas);
		}else if(action=='add'||action=='edit'){//view没本期数据的话，空白；add和edit，无本期数据，选择上期数据，不带ID
			querySql = "select t.total_num,t.use_num,t.plan_num,t.notuse_num,t.stopuser_num,t.exlain_info,t.equipment_type,t.notes from BGP_WR_FOCUS_INFO t where t.org_id='"+data_org_id+"' and t.week_date = (select week_date from (select week_date from BGP_WR_FOCUS_INFO where subflag='1' and bsflag='0' order by week_date desc) where rownum='1' ) and equipment_type in ("+code_id+") and t.bsflag='0' and t.subflag='1' and t.country='2' order by typeid desc,equipment_type ";
			queryRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
			if(queryRet.datas.length!='0'){
				dataFlag=true;
				fillDatas(queryRet.datas);
				document.getElementById("msg").innerHTML="<font color='red'>注意：显示为上次审批通过的数据，请修改后点击“下一步”</font> <input type='reset' class='iButton2' value='清空'/>";
			}
		}
	}
	function fillDatas(datas){
		 for(var i=0;i<datas.length;i++){
			 var data = datas[i]; //if(i>8)alert(queryOrgRet.datas.length);
			 if(data==null)continue;
			//alert(data.total_num);
			 if(dataFlag==true)data.focus_id='';
			document.getElementsByName("focus_id"+i)[0].value=data.focus_id;
			document.getElementsByName("total_num"+i)[0].value=data.total_num;
			document.getElementsByName("use_num"+i)[0].value=data.use_num;
			document.getElementsByName("plan_num"+i)[0].value=data.plan_num;
			document.getElementsByName("notuse_num"+i)[0].value=data.notuse_num;
			document.getElementsByName("stopuser_num"+i)[0].value=data.stopuser_num;
			document.getElementsByName("exlain_info"+i)[0].value=data.exlain_info;
			document.getElementsByName("equipment_type"+i)[0].value=data.equipment_type;
			document.getElementsByName("notes"+i)[0].value=data.notes;
	     }
		 dataFlag=false;
	}
	// 如果是查看页面，设置为readonly
	function setReadOnly(){
		for(var i=0;i<length;i++){
			document.getElementsByName("total_num"+i)[0].readOnly=true;
			document.getElementsByName("use_num"+i)[0].readOnly=true;
			document.getElementsByName("plan_num"+i)[0].readOnly=true;
			document.getElementsByName("notuse_num"+i)[0].readOnly=true;
			document.getElementsByName("stopuser_num"+i)[0].readOnly=true;
			document.getElementsByName("exlain_info"+i)[0].readOnly=true;
			document.getElementsByName("notes"+i)[0].readOnly=true;
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