<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=GBK"%>
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


<!--Remark JavaScript����-->
<script language="javaScript">
var cruTitle = "�½�--�ص���Ŀ��̬CRU";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 ���ֶ�Ҫ��������ݿ����
*/
var tables = new Array(
['bgp_wr_stress_project_info']
);
var defaultTableName = 'bgp_wr_stress_project_info';
/**0�ֶ�����1��ʾlabel��2�Ƿ���ʾ��༭��Hide,Edit,ReadOnly��
   3�ֶ����ͣ�TEXT(�ı�),N(����),NN(����),D(����),EMAIL,ET(Ӣ��)��
             MEMO(��ע)��SEL_Codes(�����),SEL_OPs(�Զ��������б�) ��FK(�����)��
   4������볤�ȣ�
   5Ĭ��ֵ��'CURRENT_DATE'��ǰ���ڣ�'CURRENT_DATE_TIME'��ǰ����ʱ�䣬
           �༭���޸�ʱ���Ϊ�ձ�ʾȡ0�ֶ�����Ӧ��ֵ��'{ENTITY.fieldName}'��ʾȡfieldName��Ӧ��ֵ��
           ����Ĭ��ֵ
   6�����ĳ��ȣ�7�������ֵ�򵯳�ҳ������ӣ�8 �Ƿ�ǿգ�ȡֵΪnon-empty�����������*
   9 Column Name��10 Event,11 Table Name
*/
cruConfig.contextPath = '<%=contextPath%>';

function save(){
	var orgId = "<%=orgId%>";
	var week_date = document.getElementsByName('week_date')[0].value;
	if(week_date==''){
		alert('��ѡ���±�����');
		return false;
	}
	var week_end_date = document.getElementsByName('week_end_date')[0].value;
	if(week_end_date==''){
		alert('��ѡ���±���������');
		return false;
	}
	
	// ����Ƿ��Ѵ���
	var checkSql="select * from bgp_wr_martandproject_info where to_char(week_date,'yyyy-MM-dd')='" + week_date + "' and org_id='"+orgId+"' and bsflag='0' and type='2'";
    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
	var datas = queryRet.datas;
	var martandpro_id="";
	var subflag="0";
	var action="add";
	if(datas && datas[0] && datas[0].martandpro_id){// �����Ѵ���
		martandpro_id = datas[0].martandpro_id;
		subflag=datas[0].subflag;
		action="edit";
	}
	
	if(subflag=="1"){// �������ύ
	    //alert("�������ύ��ֻ�ܲ鿴�������޸�");
	    //return;
	    if(orgId=="C6000000000025"){
	    	if(datas && datas[0] && datas[0].martandpro_id){
				alert("�����Ѵ��ڣ�������ѡ�����ڣ�");
			}else{
			window.location="<%=contextPath%>/market/month/addMonthReport.srq?week_date="+week_date+"&week_end_date="+week_end_date+"&orgId=<%=orgId%>&action=view";
			}
	    }else{
	    	if(datas && datas[0] && datas[0].martandpro_id){
				alert("�����Ѵ��ڣ�������ѡ�����ڣ�");
			}else{
			window.location="wrMartandprojectInfoModify.jsp?week_date="+week_date+"&week_end_date="+week_end_date+"&org_id=<%=user.getCodeAffordOrgID()%>&action=view&isSecond=false&orgId=<%=orgId%>";
	    	}
	    }
	}else{
		if(orgId=="C6000000000025"){
			if(datas && datas[0] && datas[0].martandpro_id){
				alert("�����Ѵ��ڣ�������ѡ�����ڣ�");
			}else{
			window.location="<%=contextPath%>/market/month/addMonthReport.srq?week_date="+week_date+"&week_end_date="+week_end_date+"&orgId=<%=orgId%>&action=add";
			}
		}else{
			if(datas && datas[0] && datas[0].martandpro_id){
				alert("�����Ѵ��ڣ�������ѡ�����ڣ�");
			}else{
			window.location="<%=contextPath%>/market/budgetMonth/orgAddMartandprojectInfoModify.jsp?week_date="+week_date+"&week_end_date="+week_end_date+"&org_id=<%=user.getCodeAffordOrgID()%>&isSecond=false&orgId=<%=orgId%>&action="+action;
			}
		}	
	}
}

function cancel()
{
	window.location="<%=contextPath%>/market/month/monthReport.srq?orgId=<%=orgId%>";
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
	        if (date.getDate() != 26) {
	            return true;
	        } else {
	            return false;
	        }
	    }
	    });
}

function set_week_end_date(week_date){

	var reg = new RegExp("-","g"); //��������RegExp����       

	var date1= week_date.replace(reg,"\/");

	var startMilliseconds = Date.parse(date1);
	
	var endMilliseconds = startMilliseconds + 6*24*60*60*1000;

	var date2 = new Date();
	
	date2.setTime(endMilliseconds);
	date2.setDate(25);
	
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

	var date1= week_end_date.substring(0,4)+"/01/01";//��ŵ�һ�ڵĿ�ʼ���ڣ���ʼΪԪ��

	var milliseconds = Date.parse(date1);

	while(true){// Ԫ��ǰ�ĵ�һ������Ϊʵ�ʵĵ�һ�ڿ�ʼ����

		var date2 = new Date();
		
		date2.setTime(milliseconds);

		if(date2.getDay()==5) break;

		milliseconds -= 86400000;
	}

	var reg = new RegExp("-","g"); //��������RegExp����       

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
    	<td class="rtCRUFdName">�±���ʼ���ڣ�</td>
      	<td class="rtCRUFdValue"><input type="text" readonly name="week_date" onchange="set_week_end_date(this.value)">
      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton0" width="16" height="16"  style="cursor:hand;" onmouseover="fridaySelector(week_date,tributton0);"/>
      	</td>
      	<td class="rtCRUFdName">�±��������ڣ�</td>
      	<td class="rtCRUFdValue"><input type="text" readonly name="week_end_date">
      	</td>
    </tr>
</table>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;">
  <tr class="odd">
    <td colspan="4" class="ali3">
    	<input name="Submit2" type="button" class="iButton2" onClick="save()" value="ȷ��" />
    	<input name="Submit2" type="button" class="iButton2" onClick="cancel()" value="����" />&nbsp;
    </td>
  </tr> 
</table>

</body>
</html>
