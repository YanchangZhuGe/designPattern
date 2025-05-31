<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	Calendar cal=Calendar.getInstance();
	cal.setTime(new Date());
	cal.set(Calendar.DAY_OF_WEEK, Calendar.FRIDAY);
	String friDate = format.format(cal.getTime());
	System.out.println(format.format(cal.getTime()));
%>
<html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
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

<!--Remark JavaScript定义-->
<script language="javaScript">
var cruTitle = "新建--采集项目情况情况CRU";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['BGP_WR_ACQ_PROJECT_INFO']
);
var defaultTableName = 'BGP_WR_ACQ_PROJECT_INFO';
/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
   4最大输入长度，
   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
           其他默认值
   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
   9 Column Name，10 Event,11 Table Name
*/

function save(){
	var org_id=document.getElementById("org_id").value;
	var org_subjection_id=document.getElementById("org_subjection_id").value;
	var week_date=document.getElementById("week_date").value;

		
	var rowParams = new Array();
	for(var i=0;i<2;i++){
		var rowParam = {};
					
		var acqproject_id = document.getElementsByName("acqproject_id"+i)[0].value;			
		var country = document.getElementsByName("country"+i)[0].value;			
		var prepare_num = document.getElementsByName("prepare_num"+i)[0].value;
		var construct_num = document.getElementsByName("construct_num"+i)[0].value;
		var end_num = document.getElementsByName("end_num"+i)[0].value;
		
		rowParam['org_id'] = org_id;
		rowParam['org_subjection_id'] = org_subjection_id;
		rowParam['week_date'] = week_date;
		
		rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
		rowParam['create_date'] = '<%=curDate%>';
		rowParam['mondify_date'] = '<%=curDate%>';
		
		rowParam['bsflag'] = '0';
		rowParam['subflag'] = '0';
		rowParam['project_type'] = '1';
		
		rowParam['acqproject_id'] = acqproject_id;
		rowParam['country'] = country;
		rowParam['prepare_num'] = prepare_num;
		rowParam['construct_num'] = construct_num;
		rowParam['end_num'] = end_num;
		
		rowParams[rowParams.length] = rowParam;
	}
		var rows=JSON.stringify(rowParams)
		saveFunc("BGP_WR_ACQ_PROJECT_INFO",rows);	
}


function page_init(){
	
	var data_org_id = '<%=request.getParameter("org_id")%>';
	var data_week_date = '<%=request.getParameter("week_date")%>';
	var data_week_end_date = '<%=request.getParameter("week_end_date")%>';
	var action = '<%=request.getParameter("action")%>';
	if(data_week_date!='null' ){
		document.getElementsByName("week_date")[0].value = data_week_date;
		document.getElementsByName("week_end_date")[0].value = data_week_end_date;
		var querySql = "select t.* from BGP_WR_ACQ_PROJECT_INFO t where t.org_id = '" + data_org_id + "' and to_char(t.week_date,'yyyy-MM-dd') = '" + data_week_date + "' and t.bsflag='0' and t.project_type = '1' order by country";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		//如果datas为空，并且是新增或修改页面，进行数据抽取
		if(action!='view' && datas.length==0){
			cruConfig.contextPath='<%=contextPath%>';
			queryRet = jcdpCallService('DataExtractSrv','getAcqProjectInfo','week_date='+data_week_date+'&week_end_date='+data_week_end_date+'&org_id='+data_org_id);
			datas = queryRet.datas;
		}// 抽取完成
		
		for (var i = 0; datas && i < 2; i++) {
			document.getElementsByName("acqproject_id"+i)[0].value=datas[i].acqproject_id ? datas[i].acqproject_id : "";
			document.getElementsByName("prepare_num"+i)[0].value=datas[i].prepare_num ? datas[i].prepare_num : "";
			document.getElementsByName("construct_num"+i)[0].value=datas[i].construct_num ? datas[i].construct_num : "";
			document.getElementsByName("end_num"+i)[0].value=datas[i].end_num ? datas[i].end_num : "";
		}
		
	}
	
}

//提示提交结果
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
</script>
</head>
<body onload="page_init()" style="background:#fff">
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
  
<input type="hidden" name="org_id" id="org_id" value="<%=user.getCodeAffordOrgID()%>">
<input type="hidden" name="org_subjection_id" id="org_subjection_id" value="<%=user.getSubOrgIDofAffordOrg()%>">

<table border="0" cellpadding="0" cellspacing="0" id="lineTable"  width="100%" class="tab_line_height">
    <tr class="bt_info">
      <td  colspan="4" >项目状态</td>  
    </tr>
    <tr class="odd">
      <td align="inquire_item4">&nbsp;</td>
      <td align="inquire_form4">正在准备项目(个)</td>
      <td align="inquire_form4">正在施工项目(个)</td>
      <td align="inquire_form4">累计结束项目(个)</td> 
    </tr>
    <tr class="even">
      <td align="inquire_item4">国内<input name="acqproject_id0" value="" type="hidden"/><input type="hidden" name="country0" id="country0" value="1"></td>
      <td align="inquire_form4"><input type="text" name="prepare_num0" id="prepare_num0" value=""></td>
      <td align="inquire_form4"><input type="text" name="construct_num0" id="construct_num0" value=""></td>
      <td align="inquire_form4"><input type="text" name="end_num0" id="end_num0" value=""></td> 
    </tr>
    <tr class="odd">
      <td align="inquire_item4">国际<input name="acqproject_id1" value="" type="hidden"/><input type="hidden" name="country1" id="country1" value="2"></td>
      <td align="inquire_form4"><input type="text" name="prepare_num1" id="prepare_num1" value=""></td>
      <td align="inquire_form4"><input type="text" name="construct_num1" id="construct_num1" value=""></td>
      <td align="inquire_form4"><input type="text" name="end_num1" id="end_num1" value=""></td> 
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
</html>
