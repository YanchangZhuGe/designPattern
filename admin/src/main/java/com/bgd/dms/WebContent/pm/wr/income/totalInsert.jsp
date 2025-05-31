<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
	String orgId = (user==null)?"":user.getCodeAffordOrgID();
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();
	
	String weekDate = resultMsg.getValue("weekDate");
	String weekEndDate = resultMsg.getValue("weekEndDate");
	String qwe = resultMsg.getValue("qwe");
 	
	 List<MsgElement> list0 = resultMsg.getMsgElements("list0");
	 List<MsgElement> list1 = resultMsg.getMsgElements("list1");
	 List<MsgElement> list2 = resultMsg.getMsgElements("list2");
	 List<MsgElement> list3 = resultMsg.getMsgElements("list3");
	 List<MsgElement> list4 = resultMsg.getMsgElements("list4");
	 List<MsgElement> list5 = resultMsg.getMsgElements("list5");
	 List<MsgElement> list6 = resultMsg.getMsgElements("list6");
	 List<MsgElement> list7 = resultMsg.getMsgElements("list7");
	 List<MsgElement> list8 = resultMsg.getMsgElements("list8");
	 List<MsgElement> list9 = resultMsg.getMsgElements("list9");
	 List<MsgElement> list10 = resultMsg.getMsgElements("list10");
	 List<MsgElement> list11 = resultMsg.getMsgElements("list11");
	 List<MsgElement> list12 = resultMsg.getMsgElements("list12");
	 List<MsgElement> list13 = resultMsg.getMsgElements("list13");
	 List<MsgElement> list14 = resultMsg.getMsgElements("list14");
	
	
	
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<title>落实收入</title>
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

</head>

<body>
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%">
    <tr class="odd">
    	<td class="rtCRUFdName">周报开始日期：</td>
      	<td class="rtCRUFdValue"><input type="text" id="week_date" class="input_width"  name="week_date" value="<%=weekDate %>" readonly >
      	</td>
      	<td class="rtCRUFdName">周报结束日期：</td>
      	<td class="rtCRUFdValue"><input type="text" id="week_end_date" class="input_width"  name="week_end_date" value="<%=weekEndDate %>" readonly>
      	</td>
    </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" id="lineTable" class="form_info" width="100%" style="margin-top:-1px;">
    <tr class="odd">
       <td class="inquire_form_dynamic1">单位</td>
      <td class="inquire_form_dynamic1">分布</td>
      <td class="inquire_form_dynamic1">本周新增<br>(万元)</td>
      <td class="inquire_form_dynamic1">结转<br>(万元)</td>
      <td class="inquire_form_dynamic1">本年新签<br>(万元)</td>
      <td class="inquire_form_dynamic1">落实<br>(万元)</td> 
      <td class="inquire_form_dynamic1">分布</td>
      <td class="inquire_form_dynamic1">本周新增<br>(万元)</td>
      <td class="inquire_form_dynamic1">结转<br>(万美元)</td>
      <td class="inquire_form_dynamic1">结转<br>(万元)</td>
      <td class="inquire_form_dynamic1">本年新签<br>(万美元)</td>
      <td class="inquire_form_dynamic1">本年新签<br>(万元)</td>
      <td class="inquire_form_dynamic1">落实<br>(万美元)</td> 
      <td class="inquire_form_dynamic1">落实<br>(万元)</td> 
    </tr> 
   	<%
   	String new_sign00 = "";
   	String new_get00 = "";
	String carryout00 = "";
	String carryover00 = "";
	String new_sign01 = "";
	String new_get01 = "";
	String carryout01 = "";
	String carryover01 = "";
	String new_get_dollar01 ="" ;
	String carryout_dollar01 = "";
	String carryovey_dollar01 = "";
   	if(list0!=null){
   		for(int i=0;i<list0.size();i++){
   			Map map=list0.get(i).toMap();
   			if(i==0){
   				 new_get00 = map.get("newGet").toString();
   				 carryout00 = map.get("carryout").toString();
   				 carryover00 = map.get("carryover").toString();
   				 new_sign00= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign01 = map.get("newSign").toString();
   				 new_get01 = map.get("newGet").toString();
   				 carryout01 = map.get("carryout").toString();
   				 carryover01 = map.get("carryover").toString();
   				 new_get_dollar01 = map.get("newGetDollar").toString();
   				 carryout_dollar01 = map.get("carryoutDollar").toString();
   				 carryovey_dollar01 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    
    <tr class="even">
      <td><input name="org_id0" value="C6000000000003" type="hidden"/>
      <input name="org_subjection_id0" value="C105002" type="hidden"/>国际勘探事业部</td>
      <td><input name="income_id00" value="" type="hidden"/>
      <input name="country00" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign00" value="<%=new_sign00 %>" size="8"/></td>
      <td><input name="carryover00" value="<%=carryover00 %>" size="8"/></td> 
      <td><input name="new_get00" value="<%=new_get00 %>" size="8"/></td>
      <td><input name="carryout00" value="<%=carryout00 %>" size="8"/></td> 
      <td><input name="income_id01" value="" type="hidden"/>
      <input name="country01" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign01" value="<%=new_sign01 %>" size="8"/></td>
      <td><input name="carryovey_dollar01" value="<%=carryovey_dollar01 %>"  size="8"/></td> 
      <td><input name="carryover01" value="<%=carryover01 %>"  size="8"/></td> 
      <td><input name="new_get_dollar01" value="<%=new_get_dollar01 %>"  size="8"/></td> 
      <td><input name="new_get01" value="<%=new_get01 %>" size="8"/></td>
      <td><input name="carryout_dollar01" value="<%=carryout_dollar01 %>" size="8" /></td>
      <td><input name="carryout01" value="<%=carryout01 %>" size="8" /></td> 
    </tr>	   
   <%		
   String new_sign10 = "";
   	String new_get10 = "";
	String carryout10 = "";
	String carryover10 = "";
	String new_sign11 = "";
	String new_get11 = "";
	String carryout11 = "";
	String carryover11 = "";
	String new_get_dollar11 ="" ;
	String carryout_dollar11 = "";
	String carryovey_dollar11 = "";
   
   if(list1!=null){
   		for(int i=0;i<list1.size();i++){
   			Map map=list1.get(i).toMap();
   			if(i==0){
   				new_get10 = map.get("newGet").toString();
   				carryout10 = map.get("carryout").toString();
   				carryover10 = map.get("carryover").toString();
   				new_sign10= map.get("newSign").toString();
   			}else if(i==1){
   			   new_sign11 = map.get("newSign").toString();
   				new_get11 = map.get("newGet").toString();
   				carryout11 = map.get("carryout").toString();
   				carryover11 = map.get("carryover").toString();
   				new_get_dollar11 = map.get("newGetDollar").toString();
   				carryout_dollar11 = map.get("carryoutDollar").toString();
   				carryovey_dollar11 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
	<tr class="odd">
      <td><input name="org_id1" value="C6000000000004" type="hidden"/>
      <input name="org_subjection_id1" value="C105003" type="hidden"/>研究院</td>
      <td><input name="income_id10" value="" type="hidden"/><input name="country10" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign10" value="<%=new_sign10 %>" size="8"/></td>
      <td><input name="carryover10"  value="<%=carryover10 %>"  size="8"/></td> 
      <td><input name="new_get10"  value="<%=new_get10 %>"  size="8"/></td>
      <td><input name="carryout10"  value="<%=carryout10 %>"  size="8"/></td> 
      <td><input name="income_id11" value="" type="hidden"/><input name="country11" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign11" value="<%=new_sign11 %>" size="8"/></td>
      <td><input name="carryovey_dollar11" value="<%=carryovey_dollar11 %>"  size="8"/></td>
      <td><input name="carryover11" value="<%=carryover11 %>"  size="8"/></td> 
      <td><input name="new_get_dollar11"  value="<%=new_get_dollar11 %>" size="8"/></td> 
      <td><input name="new_get11"  value="<%=new_get11 %>"  size="8"/></td>
      <td><input name="carryout_dollar11" value="<%=carryout_dollar11 %>" size="8" /></td>
      <td><input name="carryout11" value="<%=carryout11 %>" size="8" /></td> 
    </tr>	
    <%	
    String new_sign20 = "";
    String new_get20 = "";
	String carryout20 = "";
	String carryover20 = "";
	String new_sign21 = "";
	String new_get21 = "";
	String carryout21 = "";
	String carryover21 = "";
	String new_get_dollar21 ="" ;
	String carryout_dollar21 = "";
	String carryovey_dollar21 = "";
    if(list2!=null){
   		for(int i=0;i<list2.size();i++){
   			Map map=list2.get(i).toMap();
   			if(i==0){
   				new_get20 = map.get("newGet").toString();
   				carryout20 = map.get("carryout").toString();
   				carryover20 = map.get("carryover").toString();
   				new_sign20= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign21 = map.get("newSign").toString();
   				new_get21 = map.get("newGet").toString();
   				carryout21 = map.get("carryout").toString();
   				carryover21 = map.get("carryover").toString();
   				new_get_dollar21 = map.get("newGetDollar").toString();
   				carryout_dollar21 = map.get("carryoutDollar").toString();
   				carryovey_dollar21 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="even">
      <td><input name="org_id2" value="C6000000000010" type="hidden"/>
      <input name="org_subjection_id2" value="C105001005" type="hidden"/>塔里木物探处</td>
      <td><input name="income_id20" value="" type="hidden"/><input name="country20" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign20" value="<%=new_sign20 %>" size="8"/></td>
      <td><input name="carryover20"  value="<%=carryover20 %>"  size="8"/></td> 
      <td><input name="new_get20" value="<%=new_get20 %>"  size="8" /></td>
      <td><input name="carryout20"  value="<%=carryout20 %>"  size="8"/></td> 
      <td><input name="income_id21" value="" type="hidden"/><input name="country21" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign21" value="<%=new_sign21 %>" size="8"/></td>
      <td><input name="carryovey_dollar21" value="<%=carryovey_dollar21 %>"  size="8"/></td>
      <td><input name="carryover21"  value="<%=carryover21 %>" size="8"/></td> 
      <td><input name="new_get_dollar21"  value="<%=new_get_dollar21 %>" size="8"/></td> 
      <td><input name="new_get21" value="<%=new_get21 %>"   size="8"/></td>
      <td><input name="carryout_dollar21" value="<%=carryout_dollar21 %>" size="8" /></td>
      <td><input name="carryout21" value="<%=carryout21 %>" size="8" /></td> 
    </tr>	
    <%	
    String new_sign30 = "";
    String new_get30 = "";
	String carryout30 = "";
	String carryover30 = "";
	String new_sign31 = "";
	String new_get31 = "";
	String carryout31 = "";
	String carryover31 = "";
	String new_get_dollar31 ="" ;
	String carryout_dollar31 = "";
	String carryovey_dollar31 = "";
    if(list3!=null){
   		for(int i=0;i<list3.size();i++){
   			Map map=list3.get(i).toMap();
   			if(i==0){
   				 new_get30 = map.get("newGet").toString();
   				 carryout30 = map.get("carryout").toString();
   				 carryover30 = map.get("carryover").toString();
   				new_sign30= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign31 = map.get("newSign").toString();
   				 new_get31 = map.get("newGet").toString();
   				 carryout31 = map.get("carryout").toString();
   				 carryover31 = map.get("carryover").toString();
   				 new_get_dollar31 = map.get("newGetDollar").toString();
   				 carryout_dollar31 = map.get("carryoutDollar").toString();
   				 carryovey_dollar31 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="odd">
      <td><input name="org_id3" value="C6000000000011" type="hidden"/>
      <input name="org_subjection_id3" value="C105001002" type="hidden"/>新疆物探处</td>
      <td><input name="income_id30" value="" type="hidden"/><input name="country30" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign30" value="<%=new_sign30 %>" size="8"/></td>
      <td><input name="carryover30"  value="<%=carryover30 %>" size="8" /></td> 
      <td><input name="new_get30"  value="<%=new_get30 %>"  size="8"/></td>
      <td><input name="carryout30"  value="<%=carryout30 %>"  size="8"/></td> 
      <td><input name="income_id31" value="" type="hidden"/><input name="country31" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign31" value="<%=new_sign31 %>" size="8"/></td>
      <td><input name="carryovey_dollar31" value="<%=carryovey_dollar31 %>"  size="8"/></td>
      <td><input name="carryover31" value="<%=carryover31 %>"  size="8"/></td> 
      <td><input name="new_get_dollar31"  value="<%=new_get_dollar31 %>" size="8"/></td> 
      <td><input name="new_get31" value="<%=new_get31 %>"  size="8" /></td>
      <td><input name="carryout_dollar31" value="<%=carryout_dollar31 %>" size="8" /></td>
      <td><input name="carryout31" value="<%=carryout31 %>" size="8" /></td> 
    </tr>	
    <%	
    String new_sign40 = "";
    String new_get40 = "";
	String carryout40 = "";
	String carryover40 = "";
	String new_sign41 = "";
	String new_get41 = "";
	String carryout41 = "";
	String carryover41 = "";
	String new_get_dollar41 ="" ;
	String carryout_dollar41 = "";
	String carryovey_dollar41 = "";
    if(list4!=null){
   		for(int i=0;i<list4.size();i++){
   			Map map=list4.get(i).toMap();
   			if(i==0){
   				 new_get40 = map.get("newGet").toString();
   				 carryout40 = map.get("carryout").toString();
   				 carryover40 = map.get("carryover").toString();
   				new_sign40= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign41 = map.get("newSign").toString();
   				 new_get41 = map.get("newGet").toString();
   				 carryout41 = map.get("carryout").toString();
   				 carryover41 = map.get("carryover").toString();
   				 new_get_dollar41 = map.get("newGetDollar").toString();
   				 carryout_dollar41 = map.get("carryoutDollar").toString();
   				 carryovey_dollar41 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="even">
      <td><input name="org_id4" value="C6000000000013" type="hidden"/>
      <input name="org_subjection_id4" value="C105001003" type="hidden"/>吐哈物探处</td>
      <td><input name="income_id40" value="" type="hidden"/><input name="country40" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign40" value="<%=new_sign40 %>" size="8"/></td>
      <td><input name="carryover40"  value="<%=carryover40 %>"  size="8"/></td> 
      <td><input name="new_get40" value="<%=new_get40 %>"  size="8" /></td>
      <td><input name="carryout40"  value="<%=carryout40 %>"  size="8"/></td> 
      <td><input name="income_id41" value="" type="hidden"/><input name="country41" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign41" value="<%=new_sign41 %>" size="8"/></td>
      <td><input name="carryovey_dollar41" value="<%=carryovey_dollar41 %>"  size="8"/></td>
      <td><input name="carryover41"  value="<%=carryover41 %>" size="8"/></td> 
      <td><input name="new_get_dollar41" value="<%=new_get_dollar41 %>"  size="8"/></td> 
      <td><input name="new_get41" value="<%=new_get41 %>"  size="8" /></td>
      <td><input name="carryout_dollar41" value="<%=carryout_dollar41 %>" size="8" /></td>
      <td><input name="carryout41" value="<%=carryout41 %>" size="8" /></td> 
    </tr>	
    <%	
    String new_sign50 = "";
    String new_get50 = "";
	String carryout50 = "";
	String carryover50 = "";
	String new_sign51 = "";
	String new_get51 = "";
	String carryout51 = "";
	String carryover51 = "";
	String new_get_dollar51 ="" ;
	String carryout_dollar51 = "";
	String carryovey_dollar51 = "";
    if(list5!=null){
   		for(int i=0;i<list5.size();i++){
   			Map map=list5.get(i).toMap();
   			if(i==0){
   				 new_get50 = map.get("newGet").toString();
   				 carryout50 = map.get("carryout").toString();
   				 carryover50 = map.get("carryover").toString();
   				new_sign50= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign51 = map.get("newSign").toString();
   				 new_get51 = map.get("newGet").toString();
   				 carryout51 = map.get("carryout").toString();
   				 carryover51 = map.get("carryover").toString();
   				 new_get_dollar51 = map.get("newGetDollar").toString();
   				 carryout_dollar51 = map.get("carryoutDollar").toString();
   				 carryovey_dollar51 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="odd">
      <td><input name="org_id5" value="C6000000000012" type="hidden"/>
      <input name="org_subjection_id5" value="C105001004" type="hidden"/>青海物探处</td>
      <td><input name="income_id50" value="" type="hidden"/><input name="country50" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign50" value="<%=new_sign50 %>" size="8"/></td>
      <td><input name="carryover50"  value="<%=carryover50 %>"  size="8"/></td> 
      <td><input name="new_get50"  value="<%=new_get50 %>" size="8" /></td>
      <td><input name="carryout50"  value="<%=carryout50 %>"  size="8"/></td> 
      <td><input name="income_id51" value="" type="hidden"/><input name="country51" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign51" value="<%=new_sign51 %>" size="8"/></td>
      <td><input name="carryovey_dollar51" value="<%=carryovey_dollar51 %>"  size="8"/></td>
      <td><input name="carryover51"  value="<%=carryover51 %>" size="8"/></td> 
      <td><input name="new_get_dollar51" value="<%=new_get_dollar51 %>"  size="8"/></td> 
      <td><input name="new_get51" value="<%=new_get51 %>"  size="8" /></td>
      <td><input name="carryout_dollar51" value="<%=carryout_dollar51 %>" size="8" /></td>
      <td><input name="carryout51" value="<%=carryout51 %>" size="8" /></td> 
    </tr>
    <%	
    String new_sign60 = "";
    String new_get60 = "";
	String carryout60 = "";
	String carryover60 = "";
	String new_sign61 = "";
	String new_get61 = "";
	String carryout61 = "";
	String carryover61 = "";
	String new_get_dollar61 ="" ;
	String carryout_dollar61 = "";
	String carryovey_dollar61 = "";
    if(list6!=null){
   		for(int i=0;i<list6.size();i++){
   			Map map=list6.get(i).toMap();
   			if(i==0){
   				 new_get60 = map.get("newGet").toString();
   				 carryout60 = map.get("carryout").toString();
   				 carryover60 = map.get("carryover").toString();
   				new_sign60= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign61 = map.get("newSign").toString();
   				 new_get61 = map.get("newGet").toString();
   				 carryout61 = map.get("carryout").toString();
   				 carryover61 = map.get("carryover").toString();
   				 new_get_dollar61 = map.get("newGetDollar").toString();
   				 carryout_dollar61 = map.get("carryoutDollar").toString();
   				 carryovey_dollar61 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="even">
      <td><input name="org_id6" value="C6000000000045" type="hidden"/>
      <input name="org_subjection_id6" value="C105005004" type="hidden"/>长庆物探处</td>
      <td><input name="income_id60" value="" type="hidden"/><input name="country60" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign60" value="<%=new_sign60 %>" size="8"/></td>
      <td><input name="carryover60"  value="<%=carryover60 %>"  size="8"/></td> 
      <td><input name="new_get60"  value="<%=new_get60 %>" size="8" /></td>
      <td><input name="carryout60"  value="<%=carryout60 %>" size="8" /></td> 
      <td><input name="income_id61" value="" type="hidden"/><input name="country61" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign61" value="<%=new_sign61 %>" size="8"/></td>
      <td><input name="carryovey_dollar61" value="<%=carryovey_dollar61 %>"  size="8"/></td>
      <td><input name="carryover61" value="<%=carryover61 %>"  size="8"/></td> 
      <td><input name="new_get_dollar61"  value="<%=new_get_dollar61 %>" size="8"/></td> 
      <td><input name="new_get61"  value="<%=new_get61 %>" size="8" /></td>
      <td><input name="carryout_dollar61" value="<%=carryout_dollar61 %>" size="8" /></td>
      <td><input name="carryout61" value="<%=carryout61 %>" size="8" /></td> 
    </tr>	 
    <%	
    String new_sign70 = "";
    String new_get70 = "";
	String carryout70 = "";
	String carryover70 = "";
	String new_sign71 = "";
	String new_get71 = "";
	String carryout71 = "";
	String carryover71 = "";
	String new_get_dollar71 ="" ;
	String carryout_dollar71 = "";
	String carryovey_dollar71 = "";
    if(list7!=null){
   		for(int i=0;i<list7.size();i++){
   			Map map=list7.get(i).toMap();
   			if(i==0){
   				 new_get70 = map.get("newGet").toString();
   				 carryout70 = map.get("carryout").toString();
   				 carryover70 = map.get("carryover").toString();
   				new_sign70= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign71 = map.get("newSign").toString();
   				 new_get71 = map.get("newGet").toString();
   				 carryout71 = map.get("carryout").toString();
   				 carryover71 = map.get("carryover").toString();
   				 new_get_dollar71 = map.get("newGetDollar").toString();
   				 carryout_dollar71 = map.get("carryoutDollar").toString();
   				 carryovey_dollar71 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
   	<tr class="odd">
      <td><input name="org_id7" value="C6000000000008" type="hidden"/>
      <input name="org_subjection_id7" value="C105007" type="hidden"/>大港物探处</td>
      <td><input name="income_id70" value="" type="hidden"/><input name="country70" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign70" value="<%=new_sign70 %>" size="8"/></td>
      <td><input name="carryover70" value="<%=carryover70 %>"  size="8" /></td> 
      <td><input name="new_get70"  value="<%=new_get70 %>"  size="8"/></td>
      <td><input name="carryout70"  value="<%=carryout70 %>" size="8" /></td> 
      <td><input name="income_id71" value="" type="hidden"/><input name="country71" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign71" value="<%=new_sign71 %>" size="8"/></td>
      <td><input name="carryovey_dollar71" value="<%=carryovey_dollar71 %>"  size="8"/></td>
      <td><input name="carryover71" value="<%=carryover71 %>"  size="8"/></td> 
      <td><input name="new_get_dollar71" value="<%=new_get_dollar71 %>"  size="8"/></td> 
      <td><input name="new_get71" value="<%=new_get71 %>"  size="8" /></td>
      <td><input name="carryout_dollar71" value="<%=carryout_dollar71 %>" size="8" /></td>
      <td><input name="carryout71" value="<%=carryout71 %>" size="8" /></td> 
    </tr>
    <%	
    String new_sign80 = "";
    String new_get80 = "";
	String carryout80 = "";
	String carryover80 = "";
	String new_sign81 = "";
	String new_get81 = "";
	String carryout81 = "";
	String carryover81 = "";
	String new_get_dollar81 ="" ;
	String carryout_dollar81 = "";
	String carryovey_dollar81 = "";
    if(list8!=null){
   		for(int i=0;i<list8.size();i++){
   			Map map=list8.get(i).toMap();
   			if(i==0){
   				 new_get80 = map.get("newGet").toString();
   				 carryout80 = map.get("carryout").toString();
   				 carryover80 = map.get("carryover").toString();
   				new_sign80= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign81 = map.get("newSign").toString();
   				 new_get81 = map.get("newGet").toString();
   				 carryout81 = map.get("carryout").toString();
   				 carryover81 = map.get("carryover").toString();
   				 new_get_dollar81 = map.get("newGetDollar").toString();
   				 carryout_dollar81 = map.get("carryoutDollar").toString();
   				 carryovey_dollar81 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="even">
      <td><input name="org_id8" value="C6000000001888" type="hidden"/>
      <input name="org_subjection_id8" value="C105063" type="hidden"/>辽河物探处</td>
      <td><input name="income_id80" value="" type="hidden"/><input name="country80" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign80" value="<%=new_sign80 %>" size="8"/></td>
      <td><input name="carryover80" value="<%=carryover80 %>" size="8" /></td> 
      <td><input name="new_get80" value="<%=new_get80 %>"  size="8" /></td>
      <td><input name="carryout80"  value="<%=carryout80 %>" size="8" /></td> 
      <td><input name="income_id81" value="" type="hidden"/><input name="country81" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign81" value="<%=new_sign81 %>" size="8"/></td>
      <td><input name="carryovey_dollar81" value="<%=carryovey_dollar81 %>"  size="8"/></td>
      <td><input name="carryover81" value="<%=carryover81 %>"  size="8"/></td> 
      <td><input name="new_get_dollar81" value="<%=new_get_dollar81 %>"  size="8"/></td> 
      <td><input name="new_get81" value="<%=new_get81 %>"  size="8" /></td>
      <td><input name="carryout_dollar81" value="<%=carryout_dollar81 %>" size="8" /></td>
      <td><input name="carryout81" value="<%=carryout81 %>" size="8" /></td> 
    </tr>	
    <%	
    String new_sign90 = "";
    String new_get90 = "";
	String carryout90 = "";
	String carryover90 = "";
	String new_sign91 = "";
	String new_get91 = "";
	String carryout91 = "";
	String carryover91 = "";
	String new_get_dollar91 ="" ;
	String carryout_dollar91 = "";
	String carryovey_dollar91 = "";
    if(list9!=null){
   		for(int i=0;i<list9.size();i++){
   			Map map=list9.get(i).toMap();
   			if(i==0){
   				 new_get90 = map.get("newGet").toString();
   				 carryout90 = map.get("carryout").toString();
   				 carryover90 = map.get("carryover").toString();
   				new_sign90= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign91 = map.get("newSign").toString();
   				 new_get91 = map.get("newGet").toString();
   				 carryout91 = map.get("carryout").toString();
   				 carryover91 = map.get("carryover").toString();
   				 new_get_dollar91 = map.get("newGetDollar").toString();
   				 carryout_dollar91 = map.get("carryoutDollar").toString();
   				 carryovey_dollar91 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%> 
    <tr class="odd">
      <td><input name="org_id9" value="C0000000000232" type="hidden"/>
      <input name="org_subjection_id9" value="C105005000" type="hidden"/>华北物探处</td>
      <td><input name="income_id90" value="" type="hidden"/><input name="country90" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign90" value="<%=new_sign90 %>" size="8"/></td>
      <td><input name="carryover90" value="<%=carryover90 %>"  size="8" /></td> 
      <td><input name="new_get90"  value="<%=new_get90 %>"  size="8"/></td>
      <td><input name="carryout90"  value="<%=carryout90 %>"  size="8"/></td> 
      <td><input name="income_id91" value="" type="hidden"/><input name="country91" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign91" value="<%=new_sign91 %>" size="8"/></td>
      <td><input name="carryovey_dollar91" value="<%=carryovey_dollar91 %>"  size="8"/></td>
      <td><input name="carryover91" value="<%=carryover91 %>"  size="8"/></td> 
      <td><input name="new_get_dollar91" value="<%=new_get_dollar91 %>"  size="8"/></td> 
      <td><input name="new_get91"  value="<%=new_get91 %>" size="8" /></td>
      <td><input name="carryout_dollar91" value="<%=carryout_dollar91 %>" size="8" /></td>
      <td><input name="carryout91" value="<%=carryout91 %>" size="8" /></td> 
    </tr>
    <%	
    String new_sign100 = "";
    String new_get100 = "";
	String carryout100 = "";
	String carryover100 = "";
	String new_sign101 = "";
	String new_get101 = "";
	String carryout101 = "";
	String carryover101 = "";
	String new_get_dollar101 ="" ;
	String carryout_dollar101 = "";
	String carryovey_dollar101 = "";
    if(list10!=null){
   		for(int i=0;i<list10.size();i++){
   			Map map=list10.get(i).toMap();
   			if(i==0){
   				 new_get100 = map.get("newGet").toString();
   				 carryout100 = map.get("carryout").toString();
   				 carryover100 = map.get("carryover").toString();
   				new_sign100= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign101 = map.get("newSign").toString();
   				 new_get101 = map.get("newGet").toString();
   				 carryout101 = map.get("carryout").toString();
   				 carryover101 = map.get("carryover").toString();
   				 new_get_dollar101 = map.get("newGetDollar").toString();
   				 carryout_dollar101 = map.get("carryoutDollar").toString();
   				 carryovey_dollar101 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="even">
      <td><input name="org_id10" value="C6000000000060" type="hidden"/>
      <input name="org_subjection_id10" value="C105005001" type="hidden"/>新兴物探开发处</td>
      <td><input name="income_id100" value="" type="hidden"/><input name="country100" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign100" value="<%=new_sign100 %>" size="8"/></td>
      <td><input name="carryover100"  value="<%=carryover100 %>"  size="8"/></td> 
      <td><input name="new_get100" value="<%=new_get100 %>"  size="8" /></td>
      <td><input name="carryout100"  value="<%=carryout100 %>"  size="8"/></td> 
      <td><input name="income_id101" value="" type="hidden"/><input name="country101" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign101" value="<%=new_sign101 %>" size="8"/></td>
      <td><input name="carryovey_dollar101" value="<%=carryovey_dollar101 %>"  size="8"/></td>
      <td><input name="carryover101" value="<%=carryover101 %>"  size="8"/></td> 
      <td><input name="new_get_dollar101"  value="<%=new_get_dollar101 %>" size="8"/></td> 
      <td><input name="new_get101"  value="<%=new_get101 %>" size="8" /></td>
      <td><input name="carryout_dollar101" value="<%=carryout_dollar101 %>" size="8" /></td>
      <td><input name="carryout101" value="<%=carryout101 %>" size="8" /></td> 
    </tr>
    <%	
    String new_sign110 = "";
    String new_get110 = "";
	String carryout110 = "";
	String carryover110 = "";
	String new_sign111 = "";
	String new_get111 = "";
	String carryout111 = "";
	String carryover111 = "";
	String new_get_dollar111 ="" ;
	String carryout_dollar111 = "";
	String carryovey_dollar111 = "";
    if(list11!=null){
   		for(int i=0;i<list11.size();i++){
   			Map map=list11.get(i).toMap();
   			if(i==0){
   				 new_get110 = map.get("newGet").toString();
   				 carryout110 = map.get("carryout").toString();
   				 carryover110 = map.get("carryover").toString();
   				 new_sign110= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign111 = map.get("newSign").toString();
   				 new_get111 = map.get("newGet").toString();
   				 carryout111 = map.get("carryout").toString();
   				 carryover111 = map.get("carryover").toString();
   				 new_get_dollar111 = map.get("newGetDollar").toString();
   				 carryout_dollar111 = map.get("carryoutDollar").toString();
   				 carryovey_dollar111 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="odd">
      <td><input name="org_id11" value="C6000000000009" type="hidden"/>
      <input name="org_subjection_id11" value="C105008" type="hidden"/>综合物化探处</td>
      <td><input name="income_id110" value="" type="hidden"/><input name="country110" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign110" value="<%=new_sign110 %>" size="8"/></td>
      <td><input name="carryover110"  value="<%=carryover110 %>"  size="8"/></td> 
      <td><input name="new_get110"  value="<%=new_get110 %>"  size="8"/></td>
      <td><input name="carryout110"  value="<%=carryout110 %>"  size="8"/></td> 
      <td><input name="income_id111" value="" type="hidden"/><input name="country111" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign111" value="<%=new_sign111 %>" size="8"/></td>
      <td><input name="carryovey_dollar111"  value="<%=carryovey_dollar111 %>" size="8"/></td>
      <td><input name="carryover111"  value="<%=carryover111 %>" size="8"/></td> 
      <td><input name="new_get_dollar111" value="<%=new_get_dollar111 %>"  size="8"/></td> 
      <td><input name="new_get111"  value="<%=new_get111 %>"  size="8"/></td>
      <td><input name="carryout_dollar111" value="<%=carryout_dollar111 %>" size="8" /></td>
      <td><input name="carryout111" value="<%=carryout111 %>" size="8" /></td> 
    </tr>	
    
    <%	
    String new_sign120 = "";
    String new_get120 = "";
	String carryout120 = "";
	String carryover120 = "";
	String new_sign121 = "";
	String new_get121 = "";
	String carryout121 = "";
	String carryover121 = "";
	String new_get_dollar121 ="" ;
	String carryout_dollar121 = "";
	String carryovey_dollar121 = "";
    if(list12!=null){
   		for(int i=0;i<list12.size();i++){
   			Map map=list12.get(i).toMap();
   			if(i==0){
   				 new_get120 = map.get("newGet").toString();
   				 carryout120 = map.get("carryout").toString();
   				 carryover120 = map.get("carryover").toString();
   				 new_sign120= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign121 = map.get("newSign").toString();
   				 new_get121 = map.get("newGet").toString();
   				 carryout121 = map.get("carryout").toString();
   				 carryover121 = map.get("carryover").toString();
   				 new_get_dollar121 = map.get("newGetDollar").toString();
   				 carryout_dollar121 = map.get("carryoutDollar").toString();
   				 carryovey_dollar121 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="even">
      <td><input name="org_id12" value="C6000000000015" type="hidden"/>
      <input name="org_subjection_id12" value="C105014" type="hidden"/>信息技术中心</td>
      <td><input name="income_id120" value="" type="hidden"/>
      <input name="country120" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign120" value="<%=new_sign120 %>" size="8"/></td>
      <td><input name="carryover120"  value="<%=carryover120 %>"  size="8"/></td> 
      <td><input name="new_get120"  value="<%=new_get120 %>"  size="8"/></td>
      <td><input name="carryout120"  value="<%=carryout120 %>"  size="8"/></td> 
      <td><input name="income_id121" value="" type="hidden"/>
      <input name="country121" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign121" value="<%=new_sign121 %>" size="8"/></td>
      <td><input name="carryovey_dollar121"  value="<%=carryovey_dollar121 %>" size="8"/></td>
      <td><input name="carryover121"  value="<%=carryover121 %>" size="8"/></td> 
      <td><input name="new_get_dollar121" value="<%=new_get_dollar121 %>"  size="8"/></td> 
      <td><input name="new_get121"  value="<%=new_get121 %>"  size="8"/></td>
      <td><input name="carryout_dollar121" value="<%=carryout_dollar121 %>" size="8" /></td>
      <td><input name="carryout121" value="<%=carryout121 %>" size="8" /></td> 
    </tr>	
    
    <%	
    String new_sign130 = "";
    String new_get130 = "";
	String carryout130 = "";
	String carryover130 = "";
	String new_sign131 = "";
	String new_get131 = "";
	String carryout131 = "";
	String carryover131 = "";
	String new_get_dollar131 ="" ;
	String carryout_dollar131 = "";
	String carryovey_dollar131 = "";
    if(list13!=null){
   		for(int i=0;i<list13.size();i++){
   			Map map=list13.get(i).toMap();
   			if(i==0){
   				 new_get130 = map.get("newGet").toString();
   				 carryout130 = map.get("carryout").toString();
   				 carryover130 = map.get("carryover").toString();
   				 new_sign130= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign131 = map.get("newSign").toString();
   				 new_get131 = map.get("newGet").toString();
   				 carryout131 = map.get("carryout").toString();
   				 carryover131 = map.get("carryover").toString();
   				 new_get_dollar131 = map.get("newGetDollar").toString();
   				 carryout_dollar131 = map.get("carryoutDollar").toString();
   				 carryovey_dollar131 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="odd">
      <td><input name="org_id13" value="C6000000000017" type="hidden"/>
      <input name="org_subjection_id13" value="C105016" type="hidden"/>西安装备分公司</td>
      <td><input name="income_id130" value="" type="hidden"/>
      <input name="country130" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign130" value="<%=new_sign130 %>" size="8"/></td>
      <td><input name="carryover130"  value="<%=carryover130 %>"  size="8"/></td> 
      <td><input name="new_get130"  value="<%=new_get130 %>"  size="8"/></td>
      <td><input name="carryout130"  value="<%=carryout130 %>"  size="8"/></td> 
      <td><input name="income_id131" value="" type="hidden"/>
      <input name="country131" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign131" value="<%=new_sign131 %>" size="8"/></td>
      <td><input name="carryovey_dollar131"  value="<%=carryovey_dollar131 %>" size="8"/></td>
      <td><input name="carryover131"  value="<%=carryover131 %>" size="8"/></td> 
      <td><input name="new_get_dollar131" value="<%=new_get_dollar131 %>"  size="8"/></td> 
      <td><input name="new_get131"  value="<%=new_get131 %>"  size="8"/></td>
      <td><input name="carryout_dollar131" value="<%=carryout_dollar131 %>" size="8" /></td>
      <td><input name="carryout131" value="<%=carryout131 %>" size="8" /></td> 
    </tr>
    
     <%	
    String new_sign140 = "";
    String new_get140 = "";
	String carryout140 = "";
	String carryover140 = "";
	String new_sign141 = "";
	String new_get141 = "";
	String carryout141 = "";
	String carryover141 = "";
	String new_get_dollar141 ="" ;
	String carryout_dollar141 = "";
	String carryovey_dollar141 = "";
    if(list14!=null){
   		for(int i=0;i<list14.size();i++){
   			Map map=list14.get(i).toMap();
   			if(i==0){
   				 new_get140 = map.get("newGet").toString();
   				 carryout140 = map.get("carryout").toString();
   				 carryover140 = map.get("carryover").toString();
   				 new_sign140= map.get("newSign").toString();
   			}else if(i==1){
   				new_sign141 = map.get("newSign").toString();
   				 new_get141 = map.get("newGet").toString();
   				 carryout141 = map.get("carryout").toString();
   				 carryover141 = map.get("carryover").toString();
   				 new_get_dollar141 = map.get("newGetDollar").toString();
   				 carryout_dollar141 = map.get("carryoutDollar").toString();
   				 carryovey_dollar141 = map.get("carryoveyDollar").toString();
   			}
   		}
   	}
   	%>
    <tr class="even">
      <td><input name="org_id14" value="C6000000006451" type="hidden"/>
      <input name="org_subjection_id14" value="C105079001" type="hidden"/>英洛瓦物探装备</td>
      <td><input name="income_id140" value="" type="hidden"/>
      <input name="country140" value="1" type="hidden"/>国内</td>
       <td><input name="new_sign140" value="<%=new_sign140 %>" size="8"/></td>
      <td><input name="carryover140"  value="<%=carryover140 %>"  size="8"/></td> 
      <td><input name="new_get140"  value="<%=new_get140 %>"  size="8"/></td>
      <td><input name="carryout140"  value="<%=carryout140 %>"  size="8"/></td> 
      <td><input name="income_id141" value="" type="hidden"/>
      <input name="country141" value="2" type="hidden"/>国际</td>
       <td><input name="new_sign141" value="<%=new_sign141 %>" size="8"/></td>
      <td><input name="carryovey_dollar141"  value="<%=carryovey_dollar141 %>" size="8"/></td>
      <td><input name="carryover141"  value="<%=carryover141 %>" size="8"/></td> 
      <td><input name="new_get_dollar141" value="<%=new_get_dollar141 %>"  size="8"/></td> 
      <td><input name="new_get141"  value="<%=new_get141 %>"  size="8"/></td>
      <td><input name="carryout_dollar141" value="<%=carryout_dollar141 %>" size="8" /></td>
      <td><input name="carryout141" value="<%=carryout141 %>" size="8" /></td> 
    </tr>	
    
    <%
    DecimalFormat df=new DecimalFormat("#.00"); 
    double new_sign0 = new_sign00 == "" ? 0 : Double.parseDouble(new_sign00);
    double new_sign1 = new_sign10 == "" ? 0 : Double.parseDouble(new_sign10);
    double new_sign2 = new_sign20 == "" ? 0 : Double.parseDouble(new_sign20);
    double new_sign3 = new_sign30 == "" ? 0 : Double.parseDouble(new_sign30);
    double new_sign4 = new_sign40 == "" ? 0 : Double.parseDouble(new_sign40);
    double new_sign5 = new_sign50 == "" ? 0 : Double.parseDouble(new_sign50);
    double new_sign6 = new_sign60 == "" ? 0 : Double.parseDouble(new_sign60);
    double new_sign7 = new_sign70 == "" ? 0 : Double.parseDouble(new_sign70);
    double new_sign8 = new_sign80 == "" ? 0 : Double.parseDouble(new_sign80);
    double new_sign9 = new_sign90 == "" ? 0 : Double.parseDouble(new_sign90);
    double new_sign1111 = new_sign100 == "" ? 0 : Double.parseDouble(new_sign100);
    double new_sign12 = new_sign110 == "" ? 0 : Double.parseDouble(new_sign110);
    double new_sign13 = new_sign120 == "" ? 0 : Double.parseDouble(new_sign120);
    double new_sign14 = new_sign130 == "" ? 0 : Double.parseDouble(new_sign130);
    double new_sign15 = new_sign140 == "" ? 0 : Double.parseDouble(new_sign140);
    double totalSign = new_sign0+new_sign1+new_sign2+new_sign3+new_sign4+new_sign5+new_sign6+new_sign7+new_sign8+new_sign9+new_sign1111+new_sign12+new_sign13+new_sign14+new_sign15;
    totalSign = Double.parseDouble(df.format(totalSign));
    
    double new_sign000 = new_sign01 == "" ? 0 : Double.parseDouble(new_sign01);
    double new_sign001 = new_sign11 == "" ? 0 : Double.parseDouble(new_sign11);
    double new_sign002 = new_sign21 == "" ? 0 : Double.parseDouble(new_sign21);
    double new_sign003 = new_sign31 == "" ? 0 : Double.parseDouble(new_sign31);
    double new_sign004 = new_sign41 == "" ? 0 : Double.parseDouble(new_sign41);
    double new_sign005 = new_sign51 == "" ? 0 : Double.parseDouble(new_sign51);
    double new_sign006 = new_sign61 == "" ? 0 : Double.parseDouble(new_sign61);
    double new_sign007 = new_sign71 == "" ? 0 : Double.parseDouble(new_sign71);
    double new_sign008 = new_sign81 == "" ? 0 : Double.parseDouble(new_sign81);
    double new_sign009 = new_sign91 == "" ? 0 : Double.parseDouble(new_sign91);
    double new_sign011 = new_sign101 == "" ? 0 : Double.parseDouble(new_sign101);
    double new_sign012 = new_sign111 == "" ? 0 : Double.parseDouble(new_sign111);
    double new_sign013 = new_sign121 == "" ? 0 : Double.parseDouble(new_sign121);
    double new_sign014 = new_sign131 == "" ? 0 : Double.parseDouble(new_sign131);
    double new_sign015 = new_sign141 == "" ? 0 : Double.parseDouble(new_sign141);
    double totalSign1 = new_sign000+new_sign001+new_sign002+new_sign003+new_sign004+new_sign005+new_sign006+new_sign009+new_sign011+new_sign013+new_sign014+new_sign015;
    totalSign1 = Double.parseDouble(df.format(totalSign1));
    
    double carryover001 = carryover00 == "" ? 0 :Double.parseDouble(carryover00);
    double carryover002 = carryover10 == "" ? 0 :Double.parseDouble(carryover10);
    double carryover003 = carryover20 == "" ? 0 :Double.parseDouble(carryover20);
    double carryover004 = carryover30 == "" ? 0 :Double.parseDouble(carryover30);
    double carryover005 = carryover40 == "" ? 0 :Double.parseDouble(carryover40);
    double carryover006 = carryover50 == "" ? 0 :Double.parseDouble(carryover50);
    double carryover007 = carryover60 == "" ? 0 :Double.parseDouble(carryover60);
    double carryover008 = carryover70 == "" ? 0 :Double.parseDouble(carryover70);
    double carryover009 = carryover80 == "" ? 0 :Double.parseDouble(carryover80);
    double carryover010 = carryover90 == "" ? 0 :Double.parseDouble(carryover90);
    double carryover011 = carryover100 == "" ? 0 :Double.parseDouble(carryover100);
    double carryover012 = carryover110 == "" ? 0 :Double.parseDouble(carryover110);
    double carryover013 = carryover120 == "" ? 0 :Double.parseDouble(carryover120);
    double carryover014 = carryover130 == "" ? 0 :Double.parseDouble(carryover130);
    double carryover015 = carryover140 == "" ? 0 :Double.parseDouble(carryover140);
    double carryover0 = carryover001+carryover002+carryover003+carryover004+carryover005+carryover006+carryover007+carryover008+carryover009+carryover010+carryover011+carryover012+carryover013+carryover014+carryover015;
    carryover0 = Double.parseDouble(df.format(carryover0));
    
    double new_get001 = new_get00 == "" ? 0 :Double.parseDouble(new_get00);
    double new_get002 = new_get10 == "" ? 0 :Double.parseDouble(new_get10);
    double new_get003 = new_get20 == "" ? 0 :Double.parseDouble(new_get20);
    double new_get004 = new_get30 == "" ? 0 :Double.parseDouble(new_get30);
    double new_get005 = new_get40 == "" ? 0 :Double.parseDouble(new_get40);
    double new_get006 = new_get50 == "" ? 0 :Double.parseDouble(new_get50);
    double new_get007 = new_get60 == "" ? 0 :Double.parseDouble(new_get60);
    double new_get008 = new_get70 == "" ? 0 :Double.parseDouble(new_get70);
    double new_get009 = new_get80 == "" ? 0 :Double.parseDouble(new_get80);
    double new_get010 = new_get90 == "" ? 0 :Double.parseDouble(new_get90);
    double new_get011 = new_get100 == "" ? 0 :Double.parseDouble(new_get100);
    double new_get012 = new_get110 == "" ? 0 :Double.parseDouble(new_get110);
    double new_get013 = new_get120 == "" ? 0 :Double.parseDouble(new_get120);
    double new_get014 = new_get130 == "" ? 0 :Double.parseDouble(new_get130);
    double new_get015 = new_get140 == "" ? 0 :Double.parseDouble(new_get140);
    double new_get0 = new_get001+new_get002+new_get003+new_get004+new_get005+new_get006+new_get007+new_get008+new_get009+new_get010+new_get011+new_get012+new_get013+new_get014+new_get015;
    new_get0 = Double.parseDouble(df.format(new_get0));
    
    double carryout001 = carryout00 == "" ? 0 :Double.parseDouble(carryout00);
    double carryout002 = carryout10 == "" ? 0 :Double.parseDouble(carryout10);
    double carryout003 = carryout20 == "" ? 0 :Double.parseDouble(carryout20);
    double carryout004 = carryout30 == "" ? 0 :Double.parseDouble(carryout30);
    double carryout005 = carryout40 == "" ? 0 :Double.parseDouble(carryout40);
    double carryout006 = carryout50 == "" ? 0 :Double.parseDouble(carryout50);
    double carryout007 = carryout60 == "" ? 0 :Double.parseDouble(carryout60);
    double carryout008 = carryout70 == "" ? 0 :Double.parseDouble(carryout70);
    double carryout009 = carryout80 == "" ? 0 :Double.parseDouble(carryout80);
    double carryout010 = carryout90 == "" ? 0 :Double.parseDouble(carryout90);
    double carryout011 = carryout100 == "" ? 0 :Double.parseDouble(carryout100);
    double carryout012 = carryout110 == "" ? 0 :Double.parseDouble(carryout110);
    double carryout013 = carryout120 == "" ? 0 :Double.parseDouble(carryout120);
    double carryout014 = carryout130 == "" ? 0 :Double.parseDouble(carryout130);
    double carryout015 = carryout140 == "" ? 0 :Double.parseDouble(carryout140);
    double carryout0 = carryout001+carryout002+carryout003+carryout004+carryout005+carryout006+carryout007+carryout008+carryout009+carryout010+carryout011+carryout012+carryout013+carryout014+carryout015;
    carryout0 = Double.parseDouble(df.format(carryout0));
    
    double carryovey_dollar001 = carryovey_dollar01 == "" ? 0 :Double.parseDouble(carryovey_dollar01);
    double carryovey_dollar002 = carryovey_dollar11 == "" ? 0 :Double.parseDouble(carryovey_dollar11);
    double carryovey_dollar003 = carryovey_dollar21 == "" ? 0 :Double.parseDouble(carryovey_dollar21);
    double carryovey_dollar004 = carryovey_dollar31 == "" ? 0 :Double.parseDouble(carryovey_dollar31);
    double carryovey_dollar005 = carryovey_dollar41 == "" ? 0 :Double.parseDouble(carryovey_dollar41);
    double carryovey_dollar006 = carryovey_dollar51 == "" ? 0 :Double.parseDouble(carryovey_dollar51);
    double carryovey_dollar007 = carryovey_dollar61 == "" ? 0 :Double.parseDouble(carryovey_dollar61);
    double carryovey_dollar008 = carryovey_dollar71 == "" ? 0 :Double.parseDouble(carryovey_dollar71);
    double carryovey_dollar009 = carryovey_dollar81 == "" ? 0 :Double.parseDouble(carryovey_dollar81);
    double carryovey_dollar010 = carryovey_dollar91 == "" ? 0 :Double.parseDouble(carryovey_dollar91);
    double carryovey_dollar011 = carryovey_dollar101 == "" ? 0 :Double.parseDouble(carryovey_dollar101);
    double carryovey_dollar012 = carryovey_dollar111 == "" ? 0 :Double.parseDouble(carryovey_dollar111);
    double carryovey_dollar013 = carryovey_dollar121 == "" ? 0 :Double.parseDouble(carryovey_dollar121);
    double carryovey_dollar014 = carryovey_dollar131 == "" ? 0 :Double.parseDouble(carryovey_dollar131);
    double carryovey_dollar015 = carryovey_dollar141 == "" ? 0 :Double.parseDouble(carryovey_dollar141);
    double carryovey_dollar1 = carryovey_dollar001+carryovey_dollar002+carryovey_dollar003+carryovey_dollar004+carryovey_dollar005+carryovey_dollar006+carryovey_dollar007+carryovey_dollar010+carryovey_dollar011+carryovey_dollar013+carryovey_dollar014+carryovey_dollar015;
    carryovey_dollar1 = Double.parseDouble(df.format(carryovey_dollar1));
    
    double carryovey0001 = carryover01 == "" ? 0 :Double.parseDouble(carryover01);
    double carryovey0002 = carryover11 == "" ? 0 :Double.parseDouble(carryover11);
    double carryovey0003 = carryover21 == "" ? 0 :Double.parseDouble(carryover21);
    double carryovey0004 = carryover31 == "" ? 0 :Double.parseDouble(carryover31);
    double carryovey0005 = carryover41 == "" ? 0 :Double.parseDouble(carryover41);
    double carryovey0006 = carryover51 == "" ? 0 :Double.parseDouble(carryover51);
    double carryovey0007 = carryover61 == "" ? 0 :Double.parseDouble(carryover61);
    double carryovey0008 = carryover71 == "" ? 0 :Double.parseDouble(carryover71);
    double carryovey0009 = carryover81 == "" ? 0 :Double.parseDouble(carryover81);
    double carryovey0010 = carryover91 == "" ? 0 :Double.parseDouble(carryover91);
    double carryovey0011 = carryover101 == "" ? 0 :Double.parseDouble(carryover101);
    double carryovey0012 = carryover111 == "" ? 0 :Double.parseDouble(carryover111);
    double carryovey0013 = carryover121 == "" ? 0 :Double.parseDouble(carryover121);
    double carryovey0014 = carryover131 == "" ? 0 :Double.parseDouble(carryover131);
    double carryovey0015 = carryover141 == "" ? 0 :Double.parseDouble(carryover141);
    double carryovey1 = carryovey0001+carryovey0002+carryovey0003+carryovey0004+carryovey0005+carryovey0006+carryovey0007+carryovey0010+carryovey0011+carryovey0013+carryovey0014+carryovey0015;
    carryovey1 = Double.parseDouble(df.format(carryovey1));
    
    double new_get_dollar001 = new_get_dollar01 == "" ? 0 :Double.parseDouble(new_get_dollar01);
    double new_get_dollar002 = new_get_dollar11 == "" ? 0 :Double.parseDouble(new_get_dollar11);
    double new_get_dollar003 = new_get_dollar21 == "" ? 0 :Double.parseDouble(new_get_dollar21);
    double new_get_dollar004 = new_get_dollar31 == "" ? 0 :Double.parseDouble(new_get_dollar31);
    double new_get_dollar005 = new_get_dollar41 == "" ? 0 :Double.parseDouble(new_get_dollar41);
    double new_get_dollar006 = new_get_dollar51 == "" ? 0 :Double.parseDouble(new_get_dollar51);
    double new_get_dollar007 = new_get_dollar61 == "" ? 0 :Double.parseDouble(new_get_dollar61);
    double new_get_dollar008 = new_get_dollar71 == "" ? 0 :Double.parseDouble(new_get_dollar71);
    double new_get_dollar009 = new_get_dollar81 == "" ? 0 :Double.parseDouble(new_get_dollar81);
    double new_get_dollar010 = new_get_dollar91 == "" ? 0 :Double.parseDouble(new_get_dollar91);
    double new_get_dollar011 = new_get_dollar101 == "" ? 0 :Double.parseDouble(new_get_dollar101);
    double new_get_dollar012 = new_get_dollar111 == "" ? 0 :Double.parseDouble(new_get_dollar111);
    double new_get_dollar013 = new_get_dollar121 == "" ? 0 :Double.parseDouble(new_get_dollar121);
    double new_get_dollar014 = new_get_dollar131 == "" ? 0 :Double.parseDouble(new_get_dollar131);
    double new_get_dollar015 = new_get_dollar141 == "" ? 0 :Double.parseDouble(new_get_dollar141);
    double new_get_dollar1 = new_get_dollar001+new_get_dollar002+new_get_dollar003+new_get_dollar004+new_get_dollar005+new_get_dollar006+new_get_dollar007+new_get_dollar010+new_get_dollar011+new_get_dollar013+new_get_dollar014+new_get_dollar015;
    new_get_dollar1 = Double.parseDouble(df.format(new_get_dollar1));
    
    double new_get0001 = new_get01 == "" ? 0 :Double.parseDouble(new_get01);
    double new_get0002 = new_get11 == "" ? 0 :Double.parseDouble(new_get11);
    double new_get0003 = new_get21 == "" ? 0 :Double.parseDouble(new_get21);
    double new_get0004 = new_get31 == "" ? 0 :Double.parseDouble(new_get31);
    double new_get0005 = new_get41 == "" ? 0 :Double.parseDouble(new_get41);
    double new_get0006 = new_get51 == "" ? 0 :Double.parseDouble(new_get51);
    double new_get0007 = new_get61 == "" ? 0 :Double.parseDouble(new_get61);
    double new_get0008 = new_get71 == "" ? 0 :Double.parseDouble(new_get71);
    double new_get0009 = new_get81 == "" ? 0 :Double.parseDouble(new_get81);
    double new_get0010 = new_get91 == "" ? 0 :Double.parseDouble(new_get91);
    double new_get0011 = new_get101 == "" ? 0 :Double.parseDouble(new_get101);
    double new_get0012 = new_get111 == "" ? 0 :Double.parseDouble(new_get111);
    double new_get0013 = new_get121 == "" ? 0 :Double.parseDouble(new_get121);
    double new_get0014 = new_get131 == "" ? 0 :Double.parseDouble(new_get131);
    double new_get0015 = new_get141 == "" ? 0 :Double.parseDouble(new_get141);
    double new_get1 = new_get0001+new_get0002+new_get0003+new_get0004+new_get0005+new_get0006+new_get0007+new_get0010+new_get0011+new_get0013+new_get0014+new_get0015;
    new_get1 = Double.parseDouble(df.format(new_get1));
    
    double carryout_dollar001 = carryout_dollar01 == "" ? 0 :Double.parseDouble(carryout_dollar01);
    double carryout_dollar002 = carryout_dollar11 == "" ? 0 :Double.parseDouble(carryout_dollar11);
    double carryout_dollar003 = carryout_dollar21 == "" ? 0 :Double.parseDouble(carryout_dollar21);
    double carryout_dollar004 = carryout_dollar31 == "" ? 0 :Double.parseDouble(carryout_dollar31);
    double carryout_dollar005 = carryout_dollar41 == "" ? 0 :Double.parseDouble(carryout_dollar41);
    double carryout_dollar006 = carryout_dollar51 == "" ? 0 :Double.parseDouble(carryout_dollar51);
    double carryout_dollar007 = carryout_dollar61 == "" ? 0 :Double.parseDouble(carryout_dollar61);
    double carryout_dollar008 = carryout_dollar71 == "" ? 0 :Double.parseDouble(carryout_dollar71);
    double carryout_dollar009 = carryout_dollar81 == "" ? 0 :Double.parseDouble(carryout_dollar81);
    double carryout_dollar010 = carryout_dollar91 == "" ? 0 :Double.parseDouble(carryout_dollar91);
    double carryout_dollar011 = carryout_dollar101 == "" ? 0 :Double.parseDouble(carryout_dollar101);
    double carryout_dollar012 = carryout_dollar111 == "" ? 0 :Double.parseDouble(carryout_dollar111);
    double carryout_dollar013 = carryout_dollar121 == "" ? 0 :Double.parseDouble(carryout_dollar121);
    double carryout_dollar014 = carryout_dollar131 == "" ? 0 :Double.parseDouble(carryout_dollar131);
    double carryout_dollar015 = carryout_dollar141 == "" ? 0 :Double.parseDouble(carryout_dollar141);
    double carryout_dollar1 = carryout_dollar001+carryout_dollar002+carryout_dollar003+carryout_dollar004+carryout_dollar005+carryout_dollar006+carryout_dollar007+carryout_dollar010+carryout_dollar011+carryout_dollar013+carryout_dollar014+carryout_dollar015;
    carryout_dollar1 = Double.parseDouble(df.format(carryout_dollar1));
    
    double carryout0001 = carryout01 == "" ? 0 :Double.parseDouble(carryout01);
    double carryout0002 = carryout11 == "" ? 0 :Double.parseDouble(carryout11);
    double carryout0003 = carryout21 == "" ? 0 :Double.parseDouble(carryout21);
    double carryout0004 = carryout31 == "" ? 0 :Double.parseDouble(carryout31);
    double carryout0005 = carryout41 == "" ? 0 :Double.parseDouble(carryout41);
    double carryout0006 = carryout51 == "" ? 0 :Double.parseDouble(carryout51);
    double carryout0007 = carryout61 == "" ? 0 :Double.parseDouble(carryout61);
    double carryout0008 = carryout71 == "" ? 0 :Double.parseDouble(carryout71);
    double carryout0009 = carryout81 == "" ? 0 :Double.parseDouble(carryout81);
    double carryout0010 = carryout91 == "" ? 0 :Double.parseDouble(carryout91);
    double carryout0011 = carryout101 == "" ? 0 :Double.parseDouble(carryout101);
    double carryout0012 = carryout111 == "" ? 0 :Double.parseDouble(carryout111);
    double carryout0013 = carryout121 == "" ? 0 :Double.parseDouble(carryout121);
    double carryout0014 = carryout131 == "" ? 0 :Double.parseDouble(carryout131);
    double carryout0015 = carryout141 == "" ? 0 :Double.parseDouble(carryout141);
    double carryout1 = carryout0001+carryout0002+carryout0003+carryout0004+carryout0005+carryout0006+carryout0007+carryout0010+carryout0011+carryout0013+carryout0014+carryout0015;
    carryout1 = Double.parseDouble(df.format(carryout1));
    %>
    <tr class="odd">
      <td>合计</td>
      <td>国内</td>
       <td><input name="totalSign" value="<%=totalSign %>" size="8"/></td>
      <td><input name="carryover"  value="<%=carryover0 %>"  size="8"/></td> 
      <td><input name="new_get"  value="<%=new_get0 %>"  size="8"/></td>
      <td><input name="carryout"  value="<%=carryout0 %>"  size="8"/></td> 
      <td><input name="income_id" value="" type="hidden"/>
      <input name="country" value="2" type="hidden"/>国际</td>
       <td><input name="totalSign" value="<%=totalSign1 %>" size="8"/></td>
      <td><input name="carryovey_dollar"  value="<%=carryovey_dollar1 %>" size="8"/></td>
      <td><input name="carryover"  value="<%=carryovey1 %>" size="8"/></td> 
      <td><input name="new_get_dollar" value="<%=new_get_dollar1 %>"  size="8"/></td> 
      <td><input name="new_get"  value="<%=new_get1 %>"  size="8"/></td>
      <td><input name="carryout_dollar" value="<%=carryout_dollar1 %>" size="8" /></td>
      <td><input name="carryout" value="<%=carryout1 %>" size="8" /></td> 
    </tr>	
    
</table>

<table  border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;">
  <tr class="odd">
    <td colspan="4" class="ali3">
    	<input name="Submit2" type="button" class="iButton2" style="display:<%="view".equals(request.getParameter("action"))?"none":"" %>" onClick="save()" value="保存" />
    	<input name="Submit2" type="button" class="iButton2" onClick="cancel()" value="返回" />&nbsp;
    </td>
  </tr> 
</table>

</body>
<script type="text/javascript">

	function initData(){			
		var data=['tableName:bgp_wr_income_money','text:T','count:N','number:NN','date:D'];
		//var data=['tableName:drill_mud_oillayer_protec','task_assign_info_id:T','oil_gas_level:N','oil_soaktime:NN','oilgaslayer_date:D','oil_start_depth:S1@subSyses','oil_end_depth:S2@0,是@1,否','layer-wellbore_id:P@<%=contextPath%>/ibp/auth/func/funcList2Link.lpmd'];
		return data;
	}
	function afterSave(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '提交成功';
		if(failHint==undefined) failHint = '提交失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			cancel();
		}
	}
	
	function afterSubmit(retObject,successHint,failHint){
		if(successHint==undefined) successHint = '提交成功';
		if(failHint==undefined) failHint = '提交失败';
		if (retObject.returnCode != "0") alert(failHint);
		else{
			window.location = "<%=contextPath%>/market/income/incomeReport.srq";
		}
	}
	function cancel()
	{
		window.location="<%=contextPath%>/market/income/incomeReport.srq";
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
		        if (date.getDay() != 5) {
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
	function key_press_check(obj)
	{
		var keycode = event.keyCode;

		if(keycode > 57 || keycode < 45 || keycode==47)
		{
			return false;
		}

		var reg = /^[0-9]{0,2}(\.[0-9]{0,2})?$/;

		var nextvalue = obj.value+String.fromCharCode(keycode);
		
		if(!(reg.test(nextvalue) || nextvalue=="100"))
		{
			return false;
		}
	}

	function save(){
		
		var week_date=document.getElementsByName("week_date")[0].value;
		if(week_date==''){
			alert('请选择周报开始日期');
			return false;
		}
		var week_end_date = document.getElementsByName('week_end_date')[0].value;
		if(week_end_date==''){
			alert('请选择周报结束日期');
			return false;
		}
					
		var querySql = "select t.* from bgp_wr_income_money t where t.week_date = to_date('" + week_date + "','yyyy-MM-dd') and t.bsflag='0' and t.org_type='1' and t.type='1' order by org_id,country";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+querySql);
		var datas = queryRet.datas;
		if(datas != null && queryRet.datas.length){
			var flag=false;
			if(confirm("周报开始日期已存在,修改该记录请点确定,否则取消!")){
				flag=true;
				var datas = queryRet.datas;
				for(var i = 0; datas && i < 30; i+=2){
					for (var j = 0; j < 2; j++) {
						document.getElementsByName("income_id"+i/2+j)[0].value=datas[i+j].income_id;
					}
				}	
			}
			if(flag){
				doSave();
			}										
		}else{
			doSave();
		}
		
	}
	
	function doSave(){
		var week_date=document.getElementsByName("week_date")[0].value;

		var week_end_date = document.getElementsByName('week_end_date')[0].value;
		
		var rowParams = new Array();
		
		for(var i=0;i<15;i++){
			debugger;

			var org_id = document.getElementsByName("org_id"+i)[0].value;		
			var org_subjection_id = document.getElementsByName("org_subjection_id"+i)[0].value;		
			
			for(var j=0;j<2;j++){
				var rowParam = {};
				var income_id = document.getElementsByName("income_id"+i+j)[0].value;		
				var country = document.getElementsByName("country"+i+j)[0].value;			
				var new_get = document.getElementsByName("new_get"+i+j)[0].value;
				var carryout = document.getElementsByName("carryout"+i+j)[0].value;	
				var carryover = document.getElementsByName("carryover"+i+j)[0].value;
				var new_sign =	document.getElementsByName("new_sign"+i+j)[0].value;
				if(j=="1"){
				var new_get_dollar = document.getElementsByName("new_get_dollar"+i+j)[0].value;
				var carryout_dollar = document.getElementsByName("carryout_dollar"+i+j)[0].value;
				var carryovey_dollar = document.getElementsByName("carryovey_dollar"+i+j)[0].value;
				rowParam['new_get_dollar'] = new_get_dollar;
				rowParam['carryout_dollar'] = carryout_dollar;
				rowParam['carryovey_dollar'] = carryovey_dollar;
				}
				rowParam['new_sign'] = new_sign;
				rowParam['week_date'] = week_date;
				rowParam['week_end_date'] = week_end_date;
				rowParam['create_user'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['mondify_user'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] = '<%=curDate%>';
				rowParam['mondify_date'] = '<%=curDate%>';
				rowParam['bsflag'] = '0';
				rowParam['subflag'] = '0';
				rowParam['org_type'] = '1';
				rowParam['type'] = '1';
				rowParam['org_id'] = org_id;
				rowParam['org_subjection_id'] = org_subjection_id;
				
				rowParam['income_id'] = income_id;
				rowParam['country'] = country;
				rowParam['new_get'] = new_get;
				rowParam['carryout'] = carryout;
				rowParam['carryover'] = carryover;
				
				rowParams[rowParams.length] = rowParam;
			}
						

		}
		var rows=JSON.stringify(rowParams);
		saveFunc("bgp_wr_income_money",rows);
	}


	
</script>
</html>
