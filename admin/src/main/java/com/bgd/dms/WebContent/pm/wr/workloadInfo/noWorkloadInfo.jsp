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
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<title></title>
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

<table border="0" cellpadding="0" cellspacing="0" id="lineTable"  width="100%" class="tab_line_height">
    <tr class="bt_info">
    	<td colspan="6" align="center"><span id="country0" value="1">国内</span><td>
    </tr>
    <tr class="odd">
    <td class="inquire_item6"><input type="hidden" name="workload_id0" value="">周重磁工作量:</td>
    <td class="inquire_form6">
    <input type="text" name="week_zc_workload0" value=""  onkeypress="return key_press_check(this)" />
    </td>
    <td class="inquire_item6">周电法工作量：</td>
    <td class="inquire_form6"><input type="text" name="week_df_workload0" value=""  onkeypress="return key_press_check(this)" /></td>
    <td class="inquire_item6">周化探工作量：</td>
    <td class="inquire_form6"><input type="text" name="week_ht_workload0" value=""  onkeypress="return key_press_check(this)" /></td>
    </tr>
    <tr class="even">
      <td class="inquire_item6">年累重磁工作量:</td>
      <td class="inquire_form6"><input type="text" name="year_zc_workload0" value=""  onkeypress="return key_press_check(this)" /></td>
      <td class="inquire_item6">年累电法工作量：</td>
      <td class="inquire_form6"><input type="text" name="year_df_workload0" value=""  onkeypress="return key_press_check(this)" /></td> 
      <td class="inquire_item6">年累化探工作量：</td>
      <td class="inquire_form6"><input type="text" name="year_ht_workload0" value="" onkeypress="return key_press_check(this)" / ></td>
      </tr>
     
	<tr class="odd">
	  <td class="inquire_item6">完成价值工作量：</td>
	  <td class="inquire_form6" colspan="6">
        <input type="text" name="complete_2d_money0" value="" onkeypress="return key_press_check(this)" />
	  </td>
    </tr>
    <tr class="bt_info">
    <td colspan="6" align="center"><span id="country1" value="2">国际</span><td>
    </tr>
    <tr class="odd">
    <td class="inquire_item6"><input type="hidden" name="workload_id1" value="">周重磁工作量:</td>
    <td class="inquire_form6">
    <input type="text" name="week_zc_workload1" value=""  onkeypress="return key_press_check(this)" />
    </td>
    <td class="inquire_item6">周电法工作量：</td>
    <td class="inquire_form6"><input type="text" name="week_df_workload1" value=""  onkeypress="return key_press_check(this)" /></td>
    <td class="inquire_item6">周化探工作量：</td>
    <td class="inquire_form6"><input type="text" name="week_ht_workload1" value=""  onkeypress="return key_press_check(this)" /></td>
    </tr>
    <tr class="even">
      <td class="inquire_item6">年累重磁工作量:</td>
      <td class="inquire_form6"><input type="text" name="year_zc_workload1" value=""   onkeypress="return key_press_check(this)" /></td>
      <td class="inquire_item6">年累电法工作量：</td>
      <td class="inquire_form6"><input type="text" name="year_df_workload1" value=""   onkeypress="return key_press_check(this)" /></td> 
      <td class="inquire_item6">年累化探工作量：</td>
      <td class="inquire_form6"><input type="text" name="year_ht_workload1" value=""   onkeypress="return key_press_check(this)" /></td>
      </tr>
     
	<tr class="odd">
	  <td class="inquire_item6">完成价值工作量：</td>
	  <td class="inquire_form6" colspan="6">
      <input type="text" name="complete_2d_money1" value="" onkeypress="return key_press_check(this)" />
	  </td>
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

</body>
<script type="text/javascript">

	function initData(){			
		var data=['tableName:BGP_WR_WORKLOAD_INFO','text:T','count:N','number:NN','date:D'];
		//var data=['tableName:drill_mud_oillayer_protec','task_assign_info_id:T','oil_gas_level:N','oil_soaktime:NN','oilgaslayer_date:D','oil_start_depth:S1@subSyses','oil_end_depth:S2@0,是@1,否','layer-wellbore_id:P@<%=contextPath%>/ibp/auth/func/funcList2Link.lpmd'];
		return data;
	}
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '提交成功';
		if(failHint==undefined) failHint = '提交失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			alert(successHint);
			cancel();
		}
	}
	function cancel()
	{
		//window.parent.getNextTab();
	}

	//判断是否为数字格式
	function key_press_check(obj)
	{
		var keycode = event.keyCode;

		if(keycode > 57 || keycode < 45 || keycode==47)
		{
			return false;
		}

		var reg = /\d+(\.\d+)?/;
		var nextvalue = obj.value+String.fromCharCode(keycode);
		
		if(!(reg.test(nextvalue) || nextvalue=="100"))
		{
			return false;
		}
	}

	function save(){
		var week_date=document.getElementsByName("week_date")[0].value;
		
		var rowParams = new Array();
		
		for(var i=0;i<2;i++){
			var rowParam = {};

			var workload_id = document.getElementsByName("workload_id"+i)[0].value;	
			var country = document.getElementsByName("country"+i)[0].value;				
			var week_zc_workload = document.getElementsByName("week_zc_workload"+i)[0].value;			
			var week_df_workload = document.getElementsByName("week_df_workload"+i)[0].value;
			var week_ht_workload = document.getElementsByName("week_ht_workload"+i)[0].value;
			
			var year_zc_workload = document.getElementsByName("year_zc_workload"+i)[0].value;
			var year_df_workload = document.getElementsByName("year_df_workload"+i)[0].value;
			var year_ht_workload = document.getElementsByName("year_ht_workload"+i)[0].value;
			
			var complete_2d_money = document.getElementsByName("complete_2d_money"+i)[0].value;

			
			rowParam['week_date'] = week_date;
			rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] = '<%=curDate%>';
			rowParam['mondify_date'] = '<%=curDate%>';
			rowParam['bsflag'] = '0';
			rowParam['subflag'] = '0';
			rowParam['org_id'] = '<%=orgId%>';
			rowParam['org_subjection_id'] = '<%=orgSubjectionId%>';
			
			rowParam['workload_id'] = workload_id;
			rowParam['country'] = country;
			rowParam['week_zc_workload'] = week_zc_workload;
			rowParam['week_df_workload'] = week_df_workload;
			rowParam['week_ht_workload'] = week_ht_workload;
			rowParam['year_zc_workload'] = year_zc_workload;
			rowParam['year_df_workload'] = year_df_workload;
			rowParam['year_ht_workload'] = year_ht_workload;
			rowParam['complete_2d_money'] = complete_2d_money;

			
			rowParams[rowParams.length] = rowParam;
		}
		var rows=JSON.stringify(rowParams);
		saveFunc("BGP_WR_WORKLOAD_INFO",rows);	
	}

	var data_org_id = '<%=request.getParameter("org_id")%>';
	var data_week_date = '<%=request.getParameter("week_date")%>';
	var data_week_end_date = '<%=request.getParameter("week_end_date")%>';
	var action = '<%=request.getParameter("action")%>';
	if(data_week_date!='null'){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = data_week_end_date;
		var querySql = "select t.* from BGP_WR_WORKLOAD_INFO t where t.org_id = '" + data_org_id + "' and to_char(t.week_date,'yyyy-MM-dd') = '" + data_week_date + "' and t.bsflag='0'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;

		//如果datas为空，并且是新增或修改页面，进行数据抽取
		if(action!='view' && datas.length==0){
			cruConfig.contextPath='<%=contextPath%>';
			queryRet = jcdpCallService('DataExtractSrv','getNoWorkloadInfo','week_date='+data_week_date+'&week_end_date='+data_week_end_date+'&org_id='+data_org_id);
			datas = queryRet.datas;
		}// 抽取完成
		
		for (var i = 0; datas && i <2; i++) {
			document.getElementsByName("workload_id"+i)[0].value=datas[i].workload_id ? datas[i].workload_id : "";
			document.getElementsByName("country"+i)[0].value=datas[i].country ? datas[i].country : "";			
			document.getElementsByName("week_zc_workload"+i)[0].value=datas[i].week_zc_workload ? datas[i].week_zc_workload : "";
			document.getElementsByName("week_df_workload"+i)[0].value=datas[i].week_df_workload ? datas[i].week_df_workload : "";
			document.getElementsByName("week_ht_workload"+i)[0].value=datas[i].week_ht_workload ? datas[i].week_ht_workload : "";
			
			document.getElementsByName("year_zc_workload"+i)[0].value=datas[i].year_zc_workload ? datas[i].year_zc_workload : "";
			document.getElementsByName("year_df_workload"+i)[0].value=datas[i].year_df_workload ? datas[i].year_df_workload : "";	
			document.getElementsByName("year_ht_workload"+i)[0].value=datas[i].year_ht_workload ? datas[i].year_ht_workload : "";
			
			document.getElementsByName("complete_2d_money"+i)[0].value=datas[i].complete_2d_money ? datas[i].complete_2d_money : "";

		}
		
	}
</script>
</html>
