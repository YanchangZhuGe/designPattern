<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy");
    String curDate = format.format(new Date());

%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>年度预算</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
</head>

<body onload="page_init()">
<form>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
    <tr class="odd">
    	<td class="rtCRUFdName">年度：</td>
      	<td class="rtCRUFdValue"><input type="text" id="year" class="input_width"  name="year" value="" readonly>
      	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1"
					width="16" height="16" style="cursor: hand;"
					onmouseover="yearSelector(year,tributton1);" />
      	</td>
      	<td class="rtCRUFdName">&nbsp;</td>
      	<td class="rtCRUFdValue">&nbsp;</td>
    </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;">

	<tr class="odd">
	  <td>单位</td>
	  <td>国内预算收入</td>
	  <td>国际预算收入</td>	  
	  <td>国内新签指标</td>
	  <td>国际新签指标</td>
	<!-- <td>国内上年结转</td>
	  <td>国际上年结转</td> -->  
	  <td>备注</td>
	</tr>
	 <tr class="even">
      <td><input name="budget_id0" value="" type="hidden"/><input name="org_id0" value="C0000000000232" type="hidden"/>
      <input name="org_subjection_id0" value="C105005000" type="hidden"/>华北物探处</td>
      <td><input name="budget_money_in0" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out0" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get0" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out0" onkeypress="return key_press_check1(this)"/></td> 
  <!-- <td><input name="prior_year_carry0" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="prior_year_carry_out0" onkeypress="return key_press_check1(this)"/></td>  -->    
      <td><input name="notes0" /></td> 
    </tr>	   
	<tr class="odd">
      <td><input name="budget_id1" value="" type="hidden"/><input name="org_id1" value="C6000000000003" type="hidden"/>
      <input name="org_subjection_id1" value="C105002" type="hidden"/>国际勘探事业部</td>
      <td><input name="budget_money_in1" onkeypress="return key_press_check1(this)" /></td>
      <td><input name="budget_money_out1" onkeypress="return key_press_check1(this)" /></td>     	
      <td><input name="new_get1" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out1" onkeypress="return key_press_check1(this)"/></td> 
    <!--   <td><input name="prior_year_carry1" onkeypress="return key_press_check1(this)"/></td>      
      <td><input name="prior_year_carry_out1" onkeypress="return key_press_check1(this)"/></td>  -->    
      <td><input name="notes1" /></td> 
    </tr>	
    <tr class="even">
      <td><input name="budget_id2" value="" type="hidden"/><input name="org_id2" value="C6000000000004" type="hidden"/>
      <input name="org_subjection_id2" value="C105003" type="hidden"/>研究院</td>
      <td><input name="budget_money_in2" onkeypress="return key_press_check1(this)" /></td>
      <td><input name="budget_money_out2" onkeypress="return key_press_check1(this)" /></td>     	
      <td><input name="new_get2" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out2" onkeypress="return key_press_check1(this)"/></td>       
      <!-- <td><input name="prior_year_carry2" onkeypress="return key_press_check1(this)"/></td>    
      <td><input name="prior_year_carry_out2" onkeypress="return key_press_check1(this)"/></td>  -->  
      <td><input name="notes2" /></td> 
    </tr>	
<!--     <tr class="odd">
      <td><input name="budget_id3" value="" type="hidden"/><input name="org_id3" value="C6000000000005" type="hidden"/>
      <input name="org_subjection_id3" value="C105004" type="hidden"/>物探技术研究中心</td>
      <td><input name="budget_money_in3" onkeypress="return key_press_check1(this)" /></td>
      <td><input name="budget_money_out3" onkeypress="return key_press_check1(this)" /></td>     	
      <td><input name="new_get3" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out3" onkeypress="return key_press_check1(this)"/></td>       
    <td><input name="prior_year_carry3" onkeypress="return key_press_check1(this)"/></td>       
      <td><input name="prior_year_carry_out3" onkeypress="return key_press_check1(this)"/></td>   
      <td><input name="notes3" /></td> 
    </tr>	

    <tr class="even">
      <td><input name="budget_id4" value="" type="hidden"/><input name="org_id4" value="C6000000000007" type="hidden"/>
      <input name="org_subjection_id4" value="C105006" type="hidden"/>装备服务处</td>
      <td><input name="budget_money_in4" onkeypress="return key_press_check1(this)" /></td>
      <td><input name="budget_money_out4" onkeypress="return key_press_check1(this)" /></td>     	
      <td><input name="new_get4" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out4" onkeypress="return key_press_check1(this)"/></td>      
      <td><input name="prior_year_carry4" onkeypress="return key_press_check1(this)"/></td>    
      <td><input name="prior_year_carry_out4" onkeypress="return key_press_check1(this)"/></td>   
      <td><input name="notes4" /></td> 
    </tr>	
--> 
    <tr class="odd">
      <td><input name="budget_id3" value="" type="hidden"/><input name="org_id3" value="C6000000000008" type="hidden"/>
      <input name="org_subjection_id3" value="C105007" type="hidden"/>大港物探处</td>
      <td><input name="budget_money_in3" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out3" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get3" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out3" onkeypress="return key_press_check1(this)"/></td> 
      <!-- <td><input name="prior_year_carry3" onkeypress="return key_press_check1(this)"/></td>       
      <td><input name="prior_year_carry_out3" onkeypress="return key_press_check1(this)"/></td>  -->
      <td><input name="notes3" /></td> 
    </tr>
    <tr class="even">
      <td><input name="budget_id4" value="" type="hidden"/><input name="org_id4" value="C6000000000009" type="hidden"/>
      <input name="org_subjection_id4" value="C105008" type="hidden"/>综合物化探处</td>
      <td><input name="budget_money_in4" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out4" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get4" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out4" onkeypress="return key_press_check1(this)"/></td>       
      <!-- <td><input name="prior_year_carry6" onkeypress="return key_press_check1(this)"/></td>    
      <td><input name="prior_year_carry_out6" onkeypress="return key_press_check1(this)"/></td>  -->   
      <td><input name="notes4" /></td> 
    </tr>	 
   	<tr class="odd">
      <td><input name="budget_id5" value="" type="hidden"/><input name="org_id5" value="C6000000000010" type="hidden"/>
      <input name="org_subjection_id5" value="C105001005" type="hidden"/>塔里木物探处 </td>
      <td><input name="budget_money_in5" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out5" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get5" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out5" onkeypress="return key_press_check1(this)"/></td>      
      <!-- <td><input name="prior_year_carry7" onkeypress="return key_press_check1(this)"/></td>       
      <td><input name="prior_year_carry_out7" onkeypress="return key_press_check1(this)"/></td>  -->
      <td><input name="notes5" /></td> 
    </tr>
    <tr class="even">
      <td><input name="budget_id6" value="" type="hidden"/><input name="org_id6" value="C6000000000011" type="hidden"/>
      <input name="org_subjection_id6" value="C105001002" type="hidden"/>新疆物探处</td>
      <td><input name="budget_money_in6" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out6" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get6" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out6" onkeypress="return key_press_check1(this)"/></td>       
      <!-- <td><input name="prior_year_carry8" onkeypress="return key_press_check1(this)"/></td>      
      <td><input name="prior_year_carry_out8" onkeypress="return key_press_check1(this)"/></td>  --> 
      <td><input name="notes6" /></td> 
    </tr>	 
    <tr class="odd">
      <td><input name="budget_id7" value="" type="hidden"/><input name="org_id7" value="C6000000000012" type="hidden"/>
      <input name="org_subjection_id7" value="C105001004" type="hidden"/>青海物探处</td>
      <td><input name="budget_money_in7" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out7" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get7" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out7" onkeypress="return key_press_check1(this)"/></td>       
      <!-- <td><input name="prior_year_carry9" onkeypress="return key_press_check1(this)"/></td>    
      <td><input name="prior_year_carry_out9" onkeypress="return key_press_check1(this)"/></td>  -->   
      <td><input name="notes7" /></td> 
    </tr>
    <tr class="even">
      <td><input name="budget_id8" value="" type="hidden"/><input name="org_id8" value="C6000000000013" type="hidden"/>
      <input name="org_subjection_id8" value="C105001003" type="hidden"/>吐哈物探处</td>
      <td><input name="budget_money_in8" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out8" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get8" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="new_get_out8" onkeypress="return key_press_check1(this)"/></td>        
      <!-- <td><input name="prior_year_carry10" onkeypress="return key_press_check1(this)"/></td>     
      <td><input name="prior_year_carry_out10" onkeypress="return key_press_check1(this)"/></td>  --> 
      <td><input name="notes8" /></td> 
    </tr>
    <tr class="odd">
      <td><input name="budget_id9" value="" type="hidden"/><input name="org_id9" value="C6000000000015" type="hidden"/>
      <input name="org_subjection_id9" value="C105014" type="hidden"/>信息技术中心</td>
      <td><input name="budget_money_in9" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out9" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get9" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out9" onkeypress="return key_press_check1(this)"/></td>      
     <!-- <td><input name="prior_year_carry11" onkeypress="return key_press_check1(this)"/></td>      
      <td><input name="prior_year_carry_out11" onkeypress="return key_press_check1(this)"/></td> -->   
      <td><input name="notes9" /></td> 
    </tr>	
    
    <tr class="even">
      <td><input name="budget_id10" value="" type="hidden"/><input name="org_id10" value="C6000000000017" type="hidden"/>
      <input name="org_subjection_id10" value="C105016" type="hidden"/>西安装备分公司</td>
      <td><input name="budget_money_in10" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out10" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get10" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out10" onkeypress="return key_press_check1(this)"/></td>      
     <!-- <td><input name="prior_year_carry11" onkeypress="return key_press_check1(this)"/></td>      
      <td><input name="prior_year_carry_out11" onkeypress="return key_press_check1(this)"/></td> -->   
      <td><input name="notes10" /></td> 
    </tr>	
    
	<tr class="odd">
      <td><input name="budget_id11" value="" type="hidden"/><input name="org_id11" value="C6000000000045" type="hidden"/>
      <input name="org_subjection_id11" value="C105005004" type="hidden"/>长庆物探处</td>
      <td><input name="budget_money_in11" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out11" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get11" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out11" onkeypress="return key_press_check1(this)"/></td>       
      <!-- <td><input name="prior_year_carry12" onkeypress="return key_press_check1(this)"/></td>       
      <td><input name="prior_year_carry_out12" onkeypress="return key_press_check1(this)"/></td>  --> 
      <td><input name="notes11" /></td> 
    </tr>
    <tr class="even">
      <td><input name="budget_id12" value="" type="hidden"/><input name="org_id12" value="C6000000000060" type="hidden"/>
      <input name="org_subjection_id12" value="C105005001" type="hidden"/>新兴物探开发处</td>
      <td><input name="budget_money_in12" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out12" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get12" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out12" onkeypress="return key_press_check1(this)"/></td>       
      <!-- <td><input name="prior_year_carry13" onkeypress="return key_press_check1(this)"/></td>  
      <td><input name="prior_year_carry_out13" onkeypress="return key_press_check1(this)"/></td>  -->      
      <td><input name="notes12" /></td> 
    </tr>
	<tr class="odd">
      <td><input name="budget_id13" value="" type="hidden"/><input name="org_id13" value="C6000000001888" type="hidden"/>
      <input name="org_subjection_id13" value="C105063" type="hidden"/>辽河物探处</td>
      <td><input name="budget_money_in13" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out13" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get13" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out13" onkeypress="return key_press_check1(this)"/></td>      
      <!-- <td><input name="prior_year_carry14" onkeypress="return key_press_check1(this)"/></td>      
      <td><input name="prior_year_carry_out14" onkeypress="return key_press_check1(this)"/></td>  -->  
      <td><input name="notes13" /></td> 
    </tr>
    <tr class="even">
      <td><input name="budget_id14" value="" type="hidden"/><input name="org_id14" value="C6000000006451" type="hidden"/>
      <input name="org_subjection_id14" value="C105079001" type="hidden"/>英洛瓦物探装备</td>
      <td><input name="budget_money_in14" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out14" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get14" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="new_get_out14" onkeypress="return key_press_check1(this)"/></td>      
      <!-- <td><input name="prior_year_carry14" onkeypress="return key_press_check1(this)"/></td>      
      <td><input name="prior_year_carry_out14" onkeypress="return key_press_check1(this)"/></td>  -->  
      <td><input name="notes14" /></td> 
    </tr>
<!--    <tr class="odd">
      <td><input name="budget_id15" value="" type="hidden"/><input name="org_id15" value="C6000000005575" type="hidden"/>
      <input name="org_subjection_id15" value="C105079" type="hidden"/>装备制造事业部</td>
      <td><input name="budget_money_in15" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="budget_money_out15" onkeypress="return key_press_check1(this)"/></td>     	
      <td><input name="new_get15" onkeypress="return key_press_check1(this)"/></td>
      <td><input name="new_get_out15" onkeypress="return key_press_check1(this)"/></td>       
      <td><input name="prior_year_carry15" onkeypress="return key_press_check1(this)"/></td>      
      <td><input name="prior_year_carry_out15" onkeypress="return key_press_check1(this)"/></td> 
      <td><input name="notes15" /></td> 
   </tr>
--> 		
</table>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;">
  <tr class="odd">
    <td colspan="4" class="ali3">
   	 	<input name="Submit2" type="button" class="iButton2" style="display:<%="view".equals(request.getParameter("action"))?"none":"" %>" onClick="save()" value="保存" />
    	<input name="Submit2" type="button" class="iButton2" onClick="cancel()" value="返回" />&nbsp;
    </td>
  </tr> 
</table>
</form>
</body>
<script type="text/javascript">

// 如果是查看页面，设置为readonly
var action = '<%=request.getParameter("action")%>';
if(action == 'view'){
	setReadOnly();
}

function setReadOnly(){				
	for(var i=0;i<15;i++){
		document.getElementsByName("budget_money_in"+i)[0].readOnly = true;
		document.getElementsByName("budget_money_out"+i)[0].readOnly = true;
		document.getElementsByName("new_get"+i)[0].readOnly = true;
		document.getElementsByName("new_get_out"+i)[0].readOnly = true;
		document.getElementsByName("notes"+i)[0].readOnly = true;
	}  
}

function yearSelector(inputField,tributton)
{    
    Calendar.setup({
        inputField     :    inputField,   // id of the input field
        ifFormat       :    "%Y",       // format of the input field
        align          :    "Br",
		button         :    tributton,
        weekNumbers    :    false,
		singleClick    :    true,
		step	       :	1
    });
}

	
	
	function initData(){			
		var data=['tableName:bgp_wr_budget_year','text:T','count:N','number:NN','date:D'];
		return data;
	}	
	function save(){
	debugger;
			var year=document.getElementsByName("year")[0].value;	
						
			if(year != ""){
				var querySql = "select t.* from BGP_WR_BUDGET_YEAR t where t.year like '" + year + "' and t.bsflag='0' order by t.org_id  ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+querySql);
				var datas = queryRet.datas;
				if(datas != null && queryRet.datas.length){
					var flag=false;
					if(confirm("年度已存在,修改该年记录请点确定,否则取消修改年度!")){
						flag=true;
						for (var i =0;i<15;i++) {	
							document.getElementsByName("budget_id"+i)[0].value=datas[i].budget_id;
						}	
					}
					if(flag){
						doSave();
					}										
				}else{
					doSave();
				}
			}else{
				alert("请输入年度!");
				return;
			}	
	}
	
	function doSave(){
		
		var year=document.getElementsByName("year")[0].value;
		var rowParams = new Array();	
			
		for(var i=0;i<15;i++){
		
			var budget_money_in = "";
			var budget_money_out = "";
			var rowParam = {};
			var budget_id = document.getElementsByName("budget_id"+i)[0].value;	
			var org_id = document.getElementsByName("org_id"+i)[0].value;		
			var org_subjection_id = document.getElementsByName("org_subjection_id"+i)[0].value;			
								
			if(document.getElementsByName("budget_money_in"+i)[0].value!=""&&document.getElementsByName("budget_money_in"+i)[0].value!='null'){
				budget_money_in = parseFloat(document.getElementsByName("budget_money_in"+i)[0].value);
			}else{
				budget_money_in = 0;
			}
		
			if(document.getElementsByName("budget_money_out"+i)[0].value!=""&&document.getElementsByName("budget_money_out"+i)[0].value!='null'){
				budget_money_out = parseFloat(document.getElementsByName("budget_money_out"+i)[0].value);
			}else{
				budget_money_out = 0;
			}			
			var budget_money = Math.round(parseFloat(budget_money_in + budget_money_out)*1000)/1000;			
			var new_get = document.getElementsByName("new_get"+i)[0].value;
			var new_get_out = document.getElementsByName("new_get_out"+i)[0].value;
			var notes = document.getElementsByName("notes"+i)[0].value;
			
			rowParam['year'] = year;
			rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
			if(action != 'edit'){
				rowParam['create_date'] = '<%=curDate%>';
			}			
			rowParam['mondify_date'] = '<%=curDate%>';
			rowParam['bsflag'] = '0';
			rowParam['subflag'] = '0';
						
			rowParam['budget_id'] = budget_id;
			rowParam['org_id'] = org_id;
			rowParam['org_subjection_id'] = org_subjection_id;
			rowParam['budget_money'] = budget_money;
			rowParam['budget_money_in'] = budget_money_in;
			rowParam['budget_money_out'] = budget_money_out;
			rowParam['new_get'] = new_get;
			rowParam['new_get_out'] = new_get_out;
			rowParam['notes'] = encodeURI(encodeURI(notes));
			
			rowParams[rowParams.length] = rowParam;
		}

		var rows=JSON.stringify(rowParams);
		saveFunc("BGP_WR_BUDGET_YEAR",rows);	


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
	function cancel()
	{
		window.parent.getNextTab();
	}
	
	function afterSubmit(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '提交成功';
		if(failHint==undefined) failHint = '提交失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			window.location = cruConfig.contextPath+cruConfig.openerUrl;
		}
	}
	//提示提交结果
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '提交成功';
		if(failHint==undefined) failHint = '提交失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			window.location="<%=contextPath%>/pm/wr/wrBudGet/wrBudGetYear.lpmd";
		}
	}

	function cancel()
	{
		window.location="<%=contextPath%>/pm/wr/wrBudGet/wrBudGetYear.lpmd";
	}
	
	function page_init(){
		var year = '<%=request.getParameter("year")%>';		
		var action = '<%=request.getParameter("action")%>';
		if(year!='null'){
			document.getElementsByName("year")[0].value = year;
			var querySql = "select t.* from BGP_WR_BUDGET_YEAR t where t.year like '" + year + "' and t.bsflag='0' order by t.org_id  ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+querySql);
			var datas = queryRet.datas;
//			for (var i = 0; datas && queryRet.datas.length; i++) {
			for (var i = 0; i<15; i++) {
				document.getElementsByName("budget_id"+i)[0].value=datas[i].budget_id;
				document.getElementsByName("budget_money_in"+i)[0].value=datas[i].budget_money_in;
				document.getElementsByName("budget_money_out"+i)[0].value=datas[i].budget_money_out;
				document.getElementsByName("new_get"+i)[0].value=datas[i].new_get;
				document.getElementsByName("new_get_out"+i)[0].value=datas[i].new_get_out;
				document.getElementsByName("notes"+i)[0].value=datas[i].notes;
			}			
		}
	}

	// 检查number(12,3)
	function key_press_check1(obj)
	{
		var keycode = event.keyCode;

		if(keycode > 57 || keycode < 45 || keycode==47)
		{
			return false;
		}

		var reg = /^[0-9]{0,12}(\.[0-9]{0,3})?$/;

		var nextvalue = obj.value+String.fromCharCode(keycode);
		
		if(!(reg.test(nextvalue)))
		{
			return false;
		}
	}
	// 求预算收入总和
	function total_budget_money(i)
	{
		var budget_money_in = "";
		var budget_money_out = "";
		var total_budget_money = "";
		if(document.getElementsByName("budget_money_in"+i)[0].value!=""&&document.getElementsByName("budget_money_in"+i)[0].value!='null'){
			budget_money_in = parseFloat(document.getElementsByName("budget_money_in"+i)[0].value);
		}else{
			budget_money_in = 0;
		}
		
		if(document.getElementsByName("budget_money_out"+i)[0].value!=""&&document.getElementsByName("budget_money_out"+i)[0].value!='null'){
			budget_money_out = parseFloat(document.getElementsByName("budget_money_out"+i)[0].value);
		}else{
			budget_money_out = 0;
		}								
		total_budget_money = Math.round(parseFloat(budget_money_in + budget_money_out)*1000)/1000;
		if(total_budget_money == 0){
			document.getElementsByName("budget_money"+i)[0].value = "";
		}else{
			document.getElementsByName("budget_money"+i)[0].value = total_budget_money;		
		}
	}
</script>
</html>
