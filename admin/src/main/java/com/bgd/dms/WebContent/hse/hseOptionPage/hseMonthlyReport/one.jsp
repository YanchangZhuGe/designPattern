<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath();
	String month_no = "";
	String org_sub_id = "";
	String record_id = "";
	String action = "";
    String subflag= ""; 
	if(request.getParameter("month_no")!=null && request.getParameter("month_no")!="" )month_no = request.getParameter("month_no");	
	if(request.getParameter("org_sub_id")!=null && request.getParameter("org_sub_id")!="" )org_sub_id = request.getParameter("org_sub_id");
	if(request.getParameter("record_id")!=null && request.getParameter("record_id")!="" )record_id = request.getParameter("record_id");
	if(request.getParameter("action")!=null && request.getParameter("action")!="" )action = request.getParameter("action");
	if(request.getParameter("subflag")!=null && request.getParameter("subflag")!="" )subflag = request.getParameter("subflag");

	Date now = new Date();	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
		//(user==null)?"":user.getEmpId();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

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
<title>HSE管理基本信息：</title>
</head>
  <style type="text/css">
   <!--.tnt {Writing-mode:tb-rl;Text-align:center;vertical-align:top;}-->

   </style>

<body class="bgColor_f3f3f3"  >       
      	<div id="list_table" >
			<div id="inq_tool_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" id="bc" css="bc" event="onclick='toAdd()'" title=""></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='toBack()'" title=""></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
		</table>
	   </div>
			<div id="table_box" >
			  <table width="173%" height="497" border="1" cellpadding="0" cellspacing="0" class="tab_info" id="queryRetTable">
			<tr class="bt_info">
				<td height="34" colspan="5">用工总人数</td>
				<td colspan="5" >用工总工时</td>
				</tr>
			<tr class="bt_info">
			  <td width="5%" height="40" >野外员工</td>
			  <td width="5%">二线员工</td>
				<td width="6%">集团承包工时</td>
				<td width="6%">外部承包工时</td>
				<td width="6%">合计</td>
				<td width="5%">野外工时</td>
				<td width="5%">二线工时</td>
				<td width="6%">集团承包工时</td>
				<td width="7%">外部承包工时</td>
				<td width="5%">合计</td>
				</tr>
				<tr class="even">
				  <td height="47" >
				    	<input type="hidden" id="bsflag" name="bsflag" value="0" />
				      	<input type="hidden" id="month_no" name="month_no" value="" />
				      	<input type="hidden" id="recore_id" name="recore_id" value="" />
						<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />
						<input type="hidden" id="mrmanagement_no" name="mrmanagement_no" class="input_width" />
					    <input type="text" id="field_staff"   name="field_staff" class="input_width"  onblur="sumNum1()" />
				  </td> 
				  <td>	    <input type="text" id="two_employees"   name="two_employees" class="input_width" onblur="sumNum1()"/></td>
				  <td>	    <input type="text" id="group_contractors"   name="group_contractors" class="input_width" onblur="sumNum1()" /></td>
				  <td>	    <input type="text" id="external_contractor"   name="external_contractor" class="input_width"  onblur="sumNum1()"/></td>
				  <td>	    <input type="text" id="o_aggreagte"   name="o_aggreagte" class="input_width"  readonly="readonly" /></td>
				  <td>	    <input type="text" id="field_workhours"   name="field_workhours" class="input_width"  onblur="sumNum2()"/></td>
				  <td>	    <input type="text" id="secondline_workhours"   name="secondline_workhours" class="input_width"  onblur="sumNum2()"/></td>
				  <td>	    <input type="text" id="group_workhours"   name="group_workhours" class="input_width" onblur="sumNum2()" /></td>
				  <td>	    <input type="text" id="external_workhours"   name="external_workhours" class="input_width" onblur="sumNum2()"  /></td>
				  <td>	    <input type="text" id="t_aggreagte"   name="t_aggreagte" class="input_width"   readonly="readonly"/></td>
			    </tr>
				
				<tr class="bt_info">
				  <td height="44" colspan="3">HSE 奖励</td>
				  <td colspan="7">HSE 处罚</td>
			    </tr>
			<tr class="bt_info">
			  <td width="5%" height="44">单位</td>
			  <td width="5%">个人</td>
			  <td width="6%">金额（元）</td>
			  <td width="6%">单位</td>
			  <td width="6%">待岗</td>
			  <td width="5%">离岗</td>
			  <td width="5%">辞退</td>
			  <td width="6%">经济处罚</td>
			  <td colspan="2">金额（元）</td>
			  </tr>
				<tr class="even">
				  <td height="47" >	    <input type="text" id="o_unit"   name="o_unit" class="input_width" onblur="sumNum3()"/></td>
				  <td>	    <input type="text" id="personal"   name="personal" class="input_width"  onblur="sumNum3()" /></td>
				  <td>	    <input type="text" id="o_amount"   name="o_amount" class="input_width"  readonly="readonly"/></td>
				  <td>	    <input type="text" id="t_unit"   name="t_unit" class="input_width"   onblur="sumNum4()" /></td>
				  <td>	    <input type="text" id="daigang"   name="daigang" class="input_width" onblur="sumNum4()" /></td>
				  <td>	    <input type="text" id="leave"   name="leave" class="input_width" onblur="sumNum4()" /></td>
				  <td>	    <input type="text" id="dismissal"   name="dismissal" class="input_width" onblur="sumNum4()" /></td>
				  <td>	    <input type="text" id="economic_punishment"   name="economic_punishment" class="input_width" onblur="sumNum4()" /></td>
				  <td colspan="2">	    <input type="text" id="t_amount"   name="t_amount" class="input_width"  readonly="readonly"/></td>
			    </tr>
				<tr class="even">
				  <td height="111" colspan="2" >其他工作：</td>
				  <td colspan="8">&nbsp;<textarea id="other_work" name="other_work"   style="height:100px;" class="textarea" ></textarea></td>
		        </tr>
				<tr class="even">
				  <td height="128" colspan="2" >第三方伤害：</td>
				  <td colspan="8">&nbsp;<textarea id="third_damage" name="third_damage"   style="height:100px;"   class="textarea" ></textarea></td>
		        </tr>
			  </table>
			</div>
 
		  </div>
 
</body>

<script type="text/javascript">
	$("#table_box").css("height",$(window).height()-40);
	cruConfig.contextPath =  "<%=contextPath%>";	 
	cruConfig.cdtType = 'form';	 
	var recore_id='<%=record_id%>'; 
	var month_no='<%=month_no%>';
	var org_sub_id='<%=org_sub_id%>';
	var action='<%=action%>';
	var subflag='<%=subflag%>';
	if(subflag!="未提交" && subflag!="0" ){
		document.getElementById("bc").style.display="none";
	}else{
		document.getElementById("bc").style.display="true";
	}
	if(subflag!="审批不通过" && subflag!="4" ){
		document.getElementById("bc").style.display="none";
	}else{
		document.getElementById("bc").style.display="true";
	}
	
	function sumNum1(){				 
	    var sum_num=0; 
		var  num1=document.getElementsByName("field_staff")[0].value;					
		var num2 =document.getElementsByName("two_employees")[0].value;			
		var num3 =document.getElementsByName("group_contractors")[0].value;	
		var num4 =document.getElementsByName("external_contractor")[0].value;	
		
	if(checkNaN("field_staff")){
		sum_num = parseFloat(sum_num)+parseFloat(num1); 
	 	}
	if(checkNaN("two_employees")){
		sum_num = parseFloat(sum_num)+parseFloat(num2);
	}
	if(checkNaN("group_contractors")){
		sum_num = parseFloat(sum_num)+parseFloat(num3);
	}
	if(checkNaN("external_contractor")){
		sum_num = parseFloat(sum_num)+parseFloat(num4);
	}
 
	document.getElementById("o_aggreagte").value=substrin(sum_num);
 
}
	
	function sumNum2(){				 
	    var sum_num=0; 	  
		var  num1=document.getElementsByName("field_workhours")[0].value;					
		var num2 =document.getElementsByName("secondline_workhours")[0].value;			
		var num3 =document.getElementsByName("group_workhours")[0].value;	
		var num4 =document.getElementsByName("external_workhours")[0].value;	
		
	if(checkNaN("field_workhours")){
		sum_num = parseFloat(sum_num)+parseFloat(num1); 
	 	}
	if(checkNaN("secondline_workhours")){
		sum_num = parseFloat(sum_num)+parseFloat(num2);
	}
	if(checkNaN("group_workhours")){
		sum_num = parseFloat(sum_num)+parseFloat(num3);
	}
	if(checkNaN("external_workhours")){
		sum_num = parseFloat(sum_num)+parseFloat(num4);
		}
 
	document.getElementById("t_aggreagte").value=substrin(sum_num);
 
}
	function sumNum3(){				 
	    var sum_num=0; 	  		 
		var  num1=document.getElementsByName("o_unit")[0].value;					
		var num2 =document.getElementsByName("personal")[0].value;			
	 		
	if(checkNaN("o_unit")){
		sum_num = parseFloat(sum_num)+parseFloat(num1); 
	 	}
	if(checkNaN("personal")){
		sum_num = parseFloat(sum_num)+parseFloat(num2);
	}
 
	document.getElementById("o_amount").value=substrin(sum_num);
 
}
	
	function sumNum4(){				 
	    var sum_num=0; 	  
 		
		var  num1=document.getElementsByName("t_unit")[0].value;					
		var num2 =document.getElementsByName("daigang")[0].value;			
		var num3 =document.getElementsByName("leave")[0].value;	
		var num4 =document.getElementsByName("dismissal")[0].value;	
		var num5 =document.getElementsByName("economic_punishment")[0].value;	
	if(checkNaN("t_unit")){
		sum_num = parseFloat(sum_num)+parseFloat(num1); 
	 	}
	if(checkNaN("daigang")){
		sum_num = parseFloat(sum_num)+parseFloat(num2);
	}
	if(checkNaN("leave")){
		sum_num = parseFloat(sum_num)+parseFloat(num3);
	}
	if(checkNaN("dismissal")){
		sum_num = parseFloat(sum_num)+parseFloat(num4);
		}
	if(checkNaN("economic_punishment")){
		sum_num = parseFloat(sum_num)+parseFloat(num5);
		}
 
	document.getElementById("t_amount").value=substrin(sum_num);
 
}
	
	
	function checkNaN(numids){
		 var str =document.getElementsByName(numids)[0].value;
		 if(str!=""){		 
			if(isNaN(str)){
				alert("请输入数字");
				document.getElementsByName(numids)[0].value="";
				return false;
			}else{
				return true;
			}
		  }

	}
	
	function substrin(str)
	{ 
		str = Math.round(str * 10000) / 10000;
		return(str); 
	 }
	
 
	
	function toAdd(){		
		var rowParams = new Array(); 
		var rowParam = {};			
 
				var mrmanagement_no = document.getElementsByName("mrmanagement_no")[0].value;
				var recore_id = document.getElementsByName("recore_id")[0].value;
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;			
				var month_no = document.getElementsByName("month_no")[0].value;			
				var field_staff = document.getElementsByName("field_staff")[0].value;
				var two_employees = document.getElementsByName("two_employees")[0].value;		
				var group_contractors = document.getElementsByName("group_contractors")[0].value;
				var external_contractor = document.getElementsByName("external_contractor")[0].value;
				var o_aggreagte = document.getElementsByName("o_aggreagte")[0].value;			
				var field_workhours = document.getElementsByName("field_workhours")[0].value;			
				
				var secondline_workhours = document.getElementsByName("secondline_workhours")[0].value;
				var group_workhours = document.getElementsByName("group_workhours")[0].value;		
				var external_workhours = document.getElementsByName("external_workhours")[0].value;
				var t_aggreagte = document.getElementsByName("t_aggreagte")[0].value;
				var o_unit = document.getElementsByName("o_unit")[0].value;			
				var personal = document.getElementsByName("personal")[0].value;			
				var o_amount = document.getElementsByName("o_amount")[0].value;
				var t_unit = document.getElementsByName("t_unit")[0].value;		
				
				var daigang = document.getElementsByName("daigang")[0].value;
				var leave = document.getElementsByName("leave")[0].value;		
				var dismissal = document.getElementsByName("dismissal")[0].value;
				var economic_punishment = document.getElementsByName("economic_punishment")[0].value;
				var t_amount = document.getElementsByName("t_amount")[0].value;			
				var other_work = document.getElementsByName("other_work")[0].value;			
				var third_damage = document.getElementsByName("third_damage")[0].value;
   
			 if(mrmanagement_no !=null && mrmanagement_no !=''){
				 
				    rowParam['mrmanagement_no'] = mrmanagement_no;
				    rowParam['recore_id'] = recore_id;
				    rowParam['org_sub_id'] = org_sub_id;
				    rowParam['month_no'] = month_no;
				    rowParam['field_staff'] = field_staff;
				    rowParam['two_employees'] = two_employees;
				    rowParam['group_contractors'] = group_contractors;
				    rowParam['external_contractor'] = external_contractor;
				    rowParam['o_aggreagte'] = o_aggreagte;
				    rowParam['field_workhours'] = field_workhours;				    
				    rowParam['secondline_workhours'] = secondline_workhours;
				    rowParam['group_workhours'] = group_workhours;
				    rowParam['external_workhours'] = external_workhours;
				    rowParam['t_aggreagte'] = t_aggreagte;
				    rowParam['o_unit'] = o_unit;
				    rowParam['personal'] = personal;
				    rowParam['o_amount'] = o_amount;
				    rowParam['t_unit'] = t_unit;
				    rowParam['daigang'] = daigang;
				    rowParam['leave'] = leave;
 
				    rowParam['dismissal'] = dismissal;
				    rowParam['economic_punishment'] = economic_punishment;
				    rowParam['t_amount'] = t_amount;
	 
					rowParam['other_work'] = encodeURI(encodeURI(other_work));
					rowParam['third_damage'] = encodeURI(encodeURI(third_damage));	 
				    rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] ='<%=curDate%>';
					
			 }else{
 
				    rowParam['recore_id'] = '<%=record_id%>';
				    rowParam['org_sub_id'] = '<%=org_sub_id%>';
				    rowParam['month_no'] = '<%=month_no%>';
				    rowParam['field_staff'] = field_staff;
				    rowParam['two_employees'] = two_employees;
				    rowParam['group_contractors'] = group_contractors;
				    rowParam['external_contractor'] = external_contractor;
				    rowParam['o_aggreagte'] = o_aggreagte;
				    rowParam['field_workhours'] = field_workhours;				    
				    rowParam['secondline_workhours'] = secondline_workhours;
				    rowParam['group_workhours'] = group_workhours;
				    rowParam['external_workhours'] = external_workhours;
				    rowParam['t_aggreagte'] = t_aggreagte;
				    rowParam['o_unit'] = o_unit;
				    rowParam['personal'] = personal;
				    rowParam['o_amount'] = o_amount;
				    rowParam['t_unit'] = t_unit;
				    rowParam['daigang'] = daigang;
				    rowParam['leave'] = leave; 
				    rowParam['dismissal'] = dismissal;
				    rowParam['economic_punishment'] = economic_punishment;
				    rowParam['t_amount'] = t_amount;	 
					rowParam['other_work'] = encodeURI(encodeURI(other_work));
					rowParam['third_damage'] = encodeURI(encodeURI(third_damage));	 

					rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['create_date'] ='<%=curDate%>';
				    rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] ='<%=curDate%>';
					 
			 }		
						
				rowParam['bsflag'] = '0';				  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);		 
				saveFunc("BGP_MONTH_RECORD_MANAGEMENT",rows);	
	}
	
	if(action=="edit"){		
		var querySql = "";
		var queryRet = null;
		var  datas =null;				
		querySql = " select tr.mrmanagement_no,tr.recore_id,tr.org_sub_id,tr.month_no,tr.field_staff,tr.two_employees,tr.group_contractors,tr.external_contractor,tr.o_aggreagte,tr.field_workhours,tr.secondline_workhours,tr.group_workhours,tr.external_workhours,tr.t_aggreagte,tr.o_unit,tr.personal,tr.o_amount,tr.t_unit,tr.daigang,tr.leave,tr.dismissal,tr.economic_punishment,tr.t_amount,tr.other_work,tr.third_damage  from   BGP_MONTH_RECORD_MANAGEMENT  tr  where  tr.bsflag='0' and  tr.recore_id='"+recore_id+"' and tr.month_no='"+month_no+"' and tr.org_sub_id='"+org_sub_id+"' ";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
 
			if(datas != null && datas != ''  ){			 
		 		 document.getElementsByName("mrmanagement_no")[0].value=datas[0].mrmanagement_no;
				 document.getElementsByName("recore_id")[0].value=datas[0].recore_id;
				 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;			
				 document.getElementsByName("month_no")[0].value=datas[0].month_no;			
				 document.getElementsByName("field_staff")[0].value=datas[0].field_staff;
				 document.getElementsByName("two_employees")[0].value=datas[0].two_employees;		
				 document.getElementsByName("group_contractors")[0].value=datas[0].group_contractors;
				 document.getElementsByName("external_contractor")[0].value=datas[0].external_contractor;
				 document.getElementsByName("o_aggreagte")[0].value=datas[0].o_aggreagte;			
		         document.getElementsByName("field_workhours")[0].value=datas[0].field_workhours;			
					
			    document.getElementsByName("secondline_workhours")[0].value=datas[0].secondline_workhours;
		    	document.getElementsByName("group_workhours")[0].value=datas[0].group_workhours;		
			    document.getElementsByName("external_workhours")[0].value=datas[0].external_workhours;
				document.getElementsByName("t_aggreagte")[0].value=datas[0].t_aggreagte;
				document.getElementsByName("o_unit")[0].value=datas[0].o_unit;			
				document.getElementsByName("personal")[0].value=datas[0].personal;			
				document.getElementsByName("o_amount")[0].value=datas[0].o_amount;
		    	document.getElementsByName("t_unit")[0].value=datas[0].t_unit;		
				
				 document.getElementsByName("daigang")[0].value=datas[0].daigang;
				 document.getElementsByName("leave")[0].value=datas[0].leave;		
				 document.getElementsByName("dismissal")[0].value=datas[0].dismissal;
				 document.getElementsByName("economic_punishment")[0].value=datas[0].economic_punishment;
				 document.getElementsByName("t_amount")[0].value=datas[0].t_amount;			
				 document.getElementsByName("other_work")[0].value=datas[0].other_work;			
				 document.getElementsByName("third_damage")[0].value=datas[0].third_damage;
			}					
		
	    	}			
		
 
		
	}
 	function toBack(){
		window.parent.parent.location='mainPage.jsp';
	}
	
	
</script>

</html>

