<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    
    String orgId = request.getParameter("orgId");
    System.out.println(orgId);
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
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>


<!--Remark JavaScript定义-->
<script language="javaScript">
var cruTitle = "新建--重点项目动态CRU";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['bgp_wr_stress_project_info']
);
var defaultTableName = 'bgp_wr_stress_project_info';
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
cruConfig.contextPath = '<%=contextPath%>';

function save(){
	var orgId = "<%=orgId%>";
	var week_date = document.getElementsByName('week_date')[0].value;
	if(week_date==''){
		alert('请选择周报日期');
		return false;
	}
	var week_end_date = document.getElementsByName('week_end_date')[0].value;
	if(week_end_date==''){
		alert('请选择周报结束日期');
		return false;
	}
	
	// 检查是否已存在
	var checkSql="select * from bgp_wr_martandproject_info where to_char(week_date,'yyyy-MM-dd')='" + week_date + "' and org_id='"+orgId+"' and bsflag='0' and type='1'";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	var martandpro_id="";
	var subflag="0";
	var action="add";
	if(datas && datas[0] && datas[0].martandpro_id){// 数据已存在
		martandpro_id = datas[0].martandpro_id;
		subflag=datas[0].subflag;
		action="edit";
	}
	
	if(subflag=="1"){// 数据已提交
	    //alert("数据已提交，只能查看，不能修改");
	    //return;
	    if(orgId=="C6000000000025"){
	    	if(datas && datas[0] && datas[0].martandpro_id){
				alert("日期已存在，请重新选择日期！");
			}else{
			window.location="<%=contextPath%>/market/week/addWeekReport.srq?week_date="+week_date+"&week_end_date="+week_end_date+"&orgId=<%=orgId%>&action=view";
			}
	    }else{
	    	if(datas && datas[0] && datas[0].martandpro_id){
				alert("日期已存在，请重新选择日期！");
			}else{
			window.location="wrMartandprojectInfoModify.jsp?week_date="+week_date+"&week_end_date="+week_end_date+"&org_id=<%=user.getCodeAffordOrgID()%>&action=view&isSecond=false&orgId=<%=orgId%>";
	    	}
	    }
	}else{
		if(orgId=="C6000000000025"){
			if(datas && datas[0] && datas[0].martandpro_id){
				alert("日期已存在，请重新选择日期！");
			}else{
			window.location="<%=contextPath%>/market/week/addWeekReport.srq?week_date="+week_date+"&week_end_date="+week_end_date+"&orgId=<%=orgId%>&action=add";
			}
		}else{
			if(datas && datas[0] && datas[0].martandpro_id){
				alert("日期已存在，请重新选择日期！");
			}else{
			window.location="<%=contextPath%>/market/budgetWeek/orgAddMartandprojectInfoModify.jsp?week_date="+week_date+"&week_end_date="+week_end_date+"&org_id=<%=user.getCodeAffordOrgID()%>&isSecond=false&orgId=<%=orgId%>&action="+action;
			}
		}
	}
}

function cancel()
{
	window.location="<%=contextPath%>/market/week/weekReport.srq?orgId=<%=orgId%>";
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


function get_week_num(week_date,week_end_date){

	var date1= week_end_date.substring(0,4)+"/01/01";//存放第一期的开始日期，初始为元旦

	var milliseconds = Date.parse(date1);

	while(true){// 元旦前的第一个周五为实际的第一期开始日期

		var date2 = new Date();
		
		date2.setTime(milliseconds);

		if(date2.getDay()==5) break;

		milliseconds -= 86400000;
	}

	var reg = new RegExp("-","g"); //创建正则RegExp对象       

	var date3= week_date.replace(reg,"\/");

	var curMilliseconds = Date.parse(date3);
	
	var week_num = parseInt((curMilliseconds-milliseconds)/86400000/7) + 1;
	
	return week_num;
}

</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
    <tr class="even">
    	<td class="rtCRUFdName">周报开始日期：</td>
      	<td class="rtCRUFdValue"><input type="text" readonly name="week_date" onchange="set_week_end_date(this.value)">
      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16"  style="cursor:hand;" onmouseover="fridaySelector(week_date,tributton0);"/>
      	</td>
      	<td class="rtCRUFdName">周报结束日期：</td>
      	<td class="rtCRUFdValue"><input type="text" readonly name="week_end_date">
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
