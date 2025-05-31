<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    String orgSubIdFirst =(user==null)?"":user.getOrgSubjectionId();		
    String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0'    start with t.org_sub_id = '"+orgSubIdFirst+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	
	System.out.println("sql ="+sql);	
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	String father_id = "";
	String orgSubId = "";
	String father_organ_flag = "";
	String organ_flag = "";
	if(list.size()>1){
	 	Map map = (Map)list.get(0);
	 	Map mapOrg = (Map)list.get(1);
	 	father_id = (String)map.get("orgSubId");
	 	orgSubId = (String)mapOrg.get("orgSubId");
	 	father_organ_flag = (String)map.get("organFlag");
	 	organ_flag = (String)mapOrg.get("organFlag");
	 	if(father_organ_flag.equals("0")||user.getOrgSubjectionId().equals("C105")){
	 		father_id = "C105";
	 		organ_flag = "0";
	 	}
	}
	
    String projectInfoNo ="";
	if(request.getParameter("projectInfoNo") != null){
		projectInfoNo=request.getParameter("projectInfoNo");	    		
	}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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

<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<!--Remark JavaScript定义-->
<script language="javaScript">
cruConfig.contextPath = '<%=contextPath%>';
var month_no = '<%=request.getParameter("month_no")%>';
var org_sub_id = '<%=request.getParameter("org_sub_id")%>';
var record_id = '<%=request.getParameter("record_id")%>';
var action = '<%=request.getParameter("action")%>';
if(month_no=='null') month_no='';
if(org_sub_id=='null') org_sub_id='<%=orgSubId%>';
if(record_id=='null') record_id='';
if(action=='null') action='';

function save(){

	month_no = document.getElementsByName('month_no2')[0].value;
	if(month_no==''){
		alert('请选择月份');
		return false;
	}

 
	// 计算月报开始日期和月报结束日期
	var month_start_date='';
	var month_end_date='';
	var year = month_no.substring(0,4);
	var month = month_no.substring(5,7);
	month = parseInt(month,10);
	var pre_month = month-1;
	
	if(pre_month<10){
		month_start_date = year+'-0'+pre_month+'-26';
	}else{
		month_start_date = year+'-'+pre_month+'-26';
	}
	
	if(month<10){
		month_end_date = year+'-0'+month+'-25';
	}else{
		month_end_date = year+'-'+month+'-25';
	}
	
	if(month==1){
		month_start_date = year+'-01-01';
	}else if(month==12){
		month_end_date = year+'-12-31';
	}
 
//	// 提交数据
	var submitStr='JCDP_TABLE_NAME=BGP_HSE_MONTH_RECORD&JCDP_TABLE_ID=';
	submitStr += '&month_no=' + month_no;
	submitStr += '&org_sub_id='+org_sub_id; 
	submitStr += '&month_start_date='+month_start_date;
	submitStr += '&month_end_date='+month_end_date;
	submitStr += '&creator=' + encodeURI(encodeURI('<%=userName%>'));
	submitStr += '&create_date=' + encodeURI(encodeURI('<%=curDate%>'));
	submitStr += '&updator=' + encodeURI(encodeURI('<%=userName%>'));
	submitStr += '&modifi_date=' + encodeURI(encodeURI('<%=curDate%>'));
	submitStr += '&bsflag=0&subflag=0&unit_subflag=0&project_no=<%=projectInfoNo%>';
	
	var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	var retObject = syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息	
	if (retObject.returnCode != "0") alert('提交失败');
	else{
		var record_ids=retObject.entity_id; //获得 主表id 	 
		var querySql = "";
		var queryRet = null;
		var  datas =null;				
		querySql = "select   i.org_abbreviation as org_name  from    comm_org_subjection s   join comm_org_information i    on s.org_id = i.org_id   and i.bsflag = '0'   where   s.org_subjection_id='"+org_sub_id+"'  and s.bsflag = '0'   ";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
 
			if(datas != null && datas != ''  ){			 
		 		 var org_name=datas[0].org_name;
			}
		}
		window.location="monthlyMenu.jsp?month_no="+month_no+"&org_sub_id="+org_sub_id+"&record_id="+record_ids+"&action="+action+"&subflag=0"+"&org_name="+org_name;
	}
	//window.location="monthlyMenu.jsp";
}

function cancel()
{
	// window.parent.opener.top.frames('list').getTab3('0'); 
	 window.location="unitMonthlyReportList.jsp";
}

function calMonthSelector(inputField,tributton)
{    
    Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y-%m",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        onUpdate       :    null,
        weekNumbers    :    false,
		singleClick    :    false,
		step	       :	1
    });
}


function getRecordInfo(month_no){ 		
	var querySql = "";
	var queryRet = null;
	var  datas =null;				
	querySql ="select * from BGP_HSE_MONTH_RECORD where month_no='" + month_no + "' and org_sub_id='"+org_sub_id+"' and bsflag='0'";				 	 
	queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
	if(queryRet.returnCode=='0'){
		datas = queryRet.datas;
		if(datas != null && datas != ''  ){		
			  alert('日期月份已存在！'); 	
			  document.getElementsByName('month_no2')[0].value="";
		}
	}
	 
 
}
</script>
</head>
<body>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
    <tr class="even">
    	<td class="rtCRUFdName">月份：</td>
      	<td class="rtCRUFdValue"><input type="text" readonly name="month_no2" onchange="getRecordInfo(this.value)">
      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16"  style="cursor:hand;" onmouseover="calMonthSelector(month_no2,tributton0);"/>
      	</td>
 
    </tr>
</table>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;">
  <tr class="odd">
    <td colspan="4" class="ali3">
    	<input name="Submit2" type="button" class="iButton2" onClick="save()" value="确定" />
    	<input name="Submit2" type="button" class="iButton2" onClick="cancel()" value="返回" />&nbsp;
    </td>
  </tr> 
</table>

</body>

</html>