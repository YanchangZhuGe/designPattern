<%@page contentType="text/html;charset=utf-8" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
     
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String action = respMsg.getValue("action");
	if(action==null){
		action="";
	}
	System.out.println("----------action----------:"+action);
	String lineUnit= request.getParameter("lineUnit")==null?"":request.getParameter("lineUnit");
	String unit="";
	if("1".equals(lineUnit)){
		unit="(m)";
	}else if("2".equals(lineUnit)){
		unit="(km)";
	}else  if("3".equals(lineUnit)){
		unit="(m&sup2)";
	}else if("4".equals(lineUnit)){
		unit="(km&sup2)";
	}
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectName = "";
	if(respMsg.getValue("projectName") != null){
		projectName = respMsg.getValue("projectName");
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    
    List<MsgElement> showWtMeasureList = null;
    String flag = "empty";
    if(respMsg.getMsgElements("showWtMeasureList") != null){
    	  showWtMeasureList = respMsg.getMsgElements("showWtMeasureList");
    	  flag = "notempty";
    }else{
    	System.out.println("empty");
    }
	String total_jb_gy_one = "";
	String total_jb_gy_two = "";
	String total_jb_gy_three = "";
	String total_jb_gy_four = "";
	String total_jb_mountain_one="";
	String total_jb_mountain_two="";
	String total_jb_zz_one="";
	String total_jb_zz_two="";
	String total_jb_zz_three="";
	String total_jb_zz_four="";
	String total_jb_desert_one = "";
	String total_jb_desert_two = "";
	String total_jb_desert_three = "";
	String total_jb_hty_one = "";
	String total_jb_hty_two = "";
	String total_jb_cy_one = "";
	String total_jb_cy_two = "";
	String total_jb_py_one = "";
	String total_jb_py_two = "";
	String view_measurement = "";
	
    if(respMsg.getValue("total_jb_gy_one") != null && !"0.0".equals(respMsg.getValue("total_jb_gy_one").toString())){
    	total_jb_gy_one = respMsg.getValue("total_jb_gy_one").substring(0,respMsg.getValue("total_jb_gy_one").indexOf("."));
    }
    if(respMsg.getValue("total_jb_gy_two") != null && !"0.0".equals(respMsg.getValue("total_jb_gy_two").toString())){
    	total_jb_gy_two = respMsg.getValue("total_jb_gy_two").substring(0,respMsg.getValue("total_jb_gy_two").indexOf("."));
    }
    if(respMsg.getValue("total_jb_gy_three") != null && !"0.0".equals(respMsg.getValue("total_jb_gy_three").toString())){
    	total_jb_gy_three = respMsg.getValue("total_jb_gy_three").substring(0,respMsg.getValue("total_jb_gy_three").indexOf("."));
    }
    if(respMsg.getValue("total_jb_gy_four") != null && !"0.0".equals(respMsg.getValue("total_jb_gy_four").toString())){
    	total_jb_gy_four = respMsg.getValue("total_jb_gy_four").substring(0,respMsg.getValue("total_jb_gy_four").indexOf("."));
    }
    
    if(respMsg.getValue("total_jb_mountain_one") != null && !"0.0".equals(respMsg.getValue("total_jb_mountain_one").toString())){
    	total_jb_mountain_one = respMsg.getValue("total_jb_mountain_one").substring(0,respMsg.getValue("total_jb_mountain_one").indexOf("."));
    }
    if(respMsg.getValue("total_jb_mountain_two") != null && !"0.0".equals(respMsg.getValue("total_jb_mountain_two").toString())){
    	total_jb_mountain_two = respMsg.getValue("total_jb_mountain_two").substring(0,respMsg.getValue("total_jb_mountain_two").indexOf("."));
    }
    
    if(respMsg.getValue("total_jb_zz_one") != null && !"0.0".equals(respMsg.getValue("total_jb_zz_one").toString())){
    	total_jb_zz_one = respMsg.getValue("total_jb_zz_one").substring(0,respMsg.getValue("total_jb_zz_one").indexOf("."));
    }
    if(respMsg.getValue("total_jb_zz_two") != null && !"0.0".equals(respMsg.getValue("total_jb_zz_two").toString())){
    	total_jb_zz_two = respMsg.getValue("total_jb_zz_two").substring(0,respMsg.getValue("total_jb_zz_two").indexOf("."));
    }
    if(respMsg.getValue("total_jb_zz_three") != null && !"0.0".equals(respMsg.getValue("total_jb_zz_three").toString())){
    	total_jb_zz_three = respMsg.getValue("total_jb_zz_three").substring(0,respMsg.getValue("total_jb_zz_three").indexOf("."));
    }
    if(respMsg.getValue("total_jb_zz_four") != null && !"0.0".equals(respMsg.getValue("total_jb_zz_four").toString())){
    	total_jb_zz_four = respMsg.getValue("total_jb_zz_four").substring(0,respMsg.getValue("total_jb_zz_four").indexOf("."));
    }
 
    if(respMsg.getValue("total_jb_desert_one") != null && !"0.0".equals(respMsg.getValue("total_jb_desert_one").toString())){
    	total_jb_desert_one = respMsg.getValue("total_jb_desert_one").substring(0,respMsg.getValue("total_jb_desert_one").indexOf("."));
    }
    if(respMsg.getValue("total_jb_desert_two") != null && !"0.0".equals(respMsg.getValue("total_jb_desert_two").toString())){
    	total_jb_desert_two = respMsg.getValue("total_jb_desert_two").substring(0,respMsg.getValue("total_jb_desert_two").indexOf("."));
    }
    if(respMsg.getValue("total_jb_desert_three") != null && !"0.0".equals(respMsg.getValue("total_jb_desert_three").toString())){
    	total_jb_desert_three = respMsg.getValue("total_jb_desert_three").substring(0,respMsg.getValue("total_jb_desert_three").indexOf("."));
    }
    
    if(respMsg.getValue("total_jb_hty_one") != null && !"0.0".equals(respMsg.getValue("total_jb_hty_one").toString())){
    	total_jb_hty_one = respMsg.getValue("total_jb_hty_one").substring(0,respMsg.getValue("total_jb_hty_one").indexOf("."));
    }
    if(respMsg.getValue("total_jb_hty_two") != null && !"0.0".equals(respMsg.getValue("total_jb_hty_two").toString())){
    	total_jb_hty_two = respMsg.getValue("total_jb_hty_two").substring(0,respMsg.getValue("total_jb_hty_two").indexOf("."));
    }
    
    if(respMsg.getValue("total_jb_cy_one") != null && !"0.0".equals(respMsg.getValue("total_jb_cy_one").toString())){
    	total_jb_cy_one = respMsg.getValue("total_jb_cy_one").substring(0,respMsg.getValue("total_jb_cy_one").indexOf("."));
    }
    if(respMsg.getValue("total_jb_cy_two") != null && !"0.0".equals(respMsg.getValue("total_jb_cy_two").toString())){
    	total_jb_cy_two = respMsg.getValue("total_jb_cy_two").substring(0,respMsg.getValue("total_jb_cy_two").indexOf("."));
    }
    
    if(respMsg.getValue("total_jb_py_one") != null && !"0.0".equals(respMsg.getValue("total_jb_py_one").toString())){
    	total_jb_py_one = respMsg.getValue("total_jb_py_one").substring(0,respMsg.getValue("total_jb_py_one").indexOf("."));
    }
    if(respMsg.getValue("total_jb_py_two") != null && !"0.0".equals(respMsg.getValue("total_jb_py_two").toString())){
    	total_jb_py_two = respMsg.getValue("total_jb_py_two").substring(0,respMsg.getValue("total_jb_py_two").indexOf("."));
    }
    
    //viewmeasurement
    if(respMsg.getValue("viewmeasurement") != null && respMsg.getValue("viewmeasurement") != ""){
    	view_measurement = respMsg.getValue("viewmeasurement");
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/measurement/myjson.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<title>测量测算表</title>
</head>
<body class="bgColor_f3f3f3" style="overflow-y: auto;">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:98%">
    <div id="new_table_box_bg" style="width:98%">
    		  <table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tr align="right">
			  		<td class="ali_query" colspan="18">
			  		<%if(!"1".equals(view_measurement) && view_measurement != "1"){ %>
			  			<auth:ListButton functionId="" css="zj" id="addRow" event="onclick='addCollRows()'" title="添加一条数据"></auth:ListButton>
			    		<auth:ListButton functionId="" css="sc" id="delRow" event="onclick='delCollRows()'" title="删除一条数据"></auth:ListButton>
			  		<%} %>
			    	<auth:ListButton functionId="" css="dc" event="onclick='measureExportData()'" title="导出excel"></auth:ListButton>
			    	</td>
				</tr>
			  </table>
			  <table width="99%" id="queryRetTable" name="queryRetTable" border="1" cellspacing="0" cellpadding="0" style="word-break :keep-all;" >
			   <tr class = "bt_info_even">
					<td colspan="21" align="center">
						<font size="3"><%=projectName %>测量测算表<%=unit%></font>
					</td>
			   </tr>
		       <tr>
		       		<td class = "bt_info_even" rowspan="2" width="4%"><input type="checkbox" name="selectall" id="selectall"/></td>
		       		<td class = "bt_info_even" rowspan="2">序号</td>
					<td class = "bt_info_even" colspan="4" width="15%">高原</td>
					<td class = "bt_info_even" colspan="2" width="15%">山地</td>
					<td class = "bt_info_even" colspan="4" width="10%">海滩沼泽</td>
					<td class = "bt_info_even" colspan="3" width="6%">沙漠</td>
					<td class = "bt_info_even" colspan="2" width="7%">黄土塬</td>
					<td class = "bt_info_even" colspan="2"  width="7%">戈壁草原</td>
					<td class = "bt_info_even" colspan="2"  width="7%">平原</td>
				</tr>
				<tr>
					<td class = "bt_info_even" width="5%"><a title="作业区平均海拔高度为3500m以下，开始有高原反应">I类</a></td>
					<td class = "bt_info_even" width="5%"><a title="作业区平均海拔高度在3501m-4000m，寒冷氧气稀薄，经常有高原反应，工区内居住人少">II类</a></td>
					<td class = "bt_info_even" width="5%"><a title="作业区平均海拔高度为4001m－4500m，高寒缺氧，高原反应较严重，工区内人烟稀少">III类</a></td>
					<td class = "bt_info_even" width="5%"><a title="作业区平均海拔高度为4501m以上，高寒严重缺氧，高原反应严重，无人居住区">Ⅳ类</a></td>
					<td class = "bt_info_even" width="5%"><a title="山体较大，测线经过地形平均相对高差300m以下，工区内遍布丘陵、低山、冲沟，不少于50%的工作量采用人抬化钻机施工">I类</a></td>
					<td class = "bt_info_even" width="5%"><a title="山体大，测线经过地形平均相对高差在300m以上，或山体陡度大于45度，工区内遍布断崖、深沟，人抬化钻机施工">II类</a></td>
					<td class = "bt_info_even" width="5%"><a title="海岸线附近的沼泽地，各大湖区">I类</a></td>
					<td class = "bt_info_even" width="5%"><a title="枯潮线与海岸线之间的潮间带，多为淤泥、沙滩，受潮汐影响严重">II类</a></td>
					<td class = "bt_info_even" width="5%"><a title="作业区在低潮位，5米水深以下海域，适用于在该区域海上作业的职工;作业区在低潮位，5米水深以下海域。适用于主要工作与生活在岸上为采集项目支持与服务的职工">III类</a></td>
					<td class = "bt_info_even" width="5%"><a title="作业区在低潮位，5～300米水深海域。适用于在该区域海上作业的职工;作业区在低潮位，5～300米水深海域。适用于主要工作与生活在岸上为采集项目支持与服务的职工">Ⅳ类</a></td>
					<td class = "bt_info_even" width="5%"><a title="沙漠边缘地区，沙地">I类</a></td>
					<td class = "bt_info_even" width="5%"><a title="大沙漠腹地">II类</a></td>
					<td class = "bt_info_even" width="5%"><a title="浮土地">III类</a></td>
					<td class = "bt_info_even" width="5%"><a title="相对高差小于100m的黄土高原区，地表起伏较大">I类</a></td>
					<td class = "bt_info_even" width="5%"><a title="相对高差100m以上黄土高原区，地表起伏大，由塬、昴、梁、沟组成，运载车辆不能直达测线">II类</a></td>
					<td class = "bt_info_even" width="5%"><a title="草原、戈壁地区">I类</a></td>
					<td class = "bt_info_even" width="5%"><a title="丘陵地区：海拔在200m－500m之间，坡度较缓和，没有明显的脉络">II类</a></td>
					<td class = "bt_info_even" width="5%"><a title="地形平坦的农田区">I类</a></td>
					<td class = "bt_info_even" width="5%"><a title="施工期日平均气温低于-15℃的地区">II类</a></td>
				</tr>
			     <tbody id="processtable1" name="processtable1" >
			    <%if(showWtMeasureList != null){ 
					Map<String,String> measureMap = new HashMap<String,String>();
					for(int i=0;i<showWtMeasureList.size();i++){
						measureMap = ((MsgElement)showWtMeasureList.get(i)).toMap();
				%>
					<tr id='tr<%=i+1 %>' name='tr<%=i+1 %>' collseq='<%=i+1%>'>
					<td align="center"><input type='checkbox' name='selectrow' value='<%=measureMap.get("terrain_measure_id") %>' id='<%=i+1 %>'/></td>
					<td>&nbsp;&nbsp;<%=i+1 %>&nbsp;&nbsp;
					<input type='hidden' value='<%=measureMap.get("terrain_measure_id") %>' name='measure_id<%=i+1 %>' id='measure_id<%=i+1 %>'/>
					</td>
					<td><input name='input_jb_gy_one_<%=i+1 %>' readonly="readonly" id='input_jb_gy_one_<%=i+1 %>' value='<%=measureMap.get("jb_gy_one") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_gy_two_<%=i+1 %>' readonly="readonly" id='input_jb_gy_two_<%=i+1 %>' value='<%=measureMap.get("jb_gy_two") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_gy_three_<%=i+1 %>' readonly="readonly" id='input_jb_gy_three_<%=i+1 %>' value='<%=measureMap.get("jb_gy_three") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_gy_four_<%=i+1 %>' readonly="readonly" id='input_jb_gy_four_<%=i+1 %>' value='<%=measureMap.get("jb_gy_four") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					
					<td><input name='input_jb_mountain_one_<%=i+1 %>' readonly="readonly" id='input_jb_mountain_one_<%=i+1 %>' value='<%=measureMap.get("jb_mountain_one") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_mountain_two_<%=i+1 %>' readonly="readonly" id='input_jb_mountain_two_<%=i+1 %>' value='<%=measureMap.get("jb_mountain_two") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					
					<td><input name='input_jb_zz_one_<%=i+1 %>' readonly="readonly" id='input_jb_zz_one_<%=i+1 %>' value='<%=measureMap.get("jb_zz_one") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_zz_two_<%=i+1 %>' readonly="readonly" id='input_jb_zz_two_<%=i+1 %>' value='<%=measureMap.get("jb_zz_two") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_zz_three_<%=i+1 %>' readonly="readonly" id='input_jb_zz_three_<%=i+1 %>' value='<%=measureMap.get("jb_zz_three") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_zz_four_<%=i+1 %>' readonly="readonly" id='input_jb_zz_four_<%=i+1 %>' value='<%=measureMap.get("jb_zz_four") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					
					<td><input name='input_jb_desert_one_<%=i+1 %>' readonly="readonly" id='input_jb_desert_one_<%=i+1 %>' value='<%=measureMap.get("jb_desert_one") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_desert_two_<%=i+1 %>' readonly="readonly" id='input_jb_desert_two_<%=i+1 %>' value='<%=measureMap.get("jb_desert_two") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_desert_three_<%=i+1 %>' readonly="readonly" id='input_jb_desert_three_<%=i+1 %>' value='<%=measureMap.get("jb_desert_three") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					
					<td><input name='input_jb_hty_one_<%=i+1 %>' readonly="readonly" id='input_jb_hty_one_<%=i+1 %>' value='<%=measureMap.get("jb_hty_one") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_hty_two_<%=i+1 %>' readonly="readonly" id='input_jb_hty_two_<%=i+1 %>' value='<%=measureMap.get("jb_hty_two") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					
					<td><input name='input_jb_cy_one_<%=i+1 %>' readonly="readonly" id='input_jb_cy_one_<%=i+1 %>' value='<%=measureMap.get("jb_cy_one") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_cy_two_<%=i+1 %>' readonly="readonly" id='input_jb_cy_two_<%=i+1 %>' value='<%=measureMap.get("jb_cy_two") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					
					<td><input name='input_jb_py_one_<%=i+1 %>' readonly="readonly" id='input_jb_py_one_<%=i+1 %>' value='<%=measureMap.get("jb_py_one") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_py_two_<%=i+1 %>' readonly="readonly" id='input_jb_py_two_<%=i+1 %>' value='<%=measureMap.get("jb_py_two") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					</tr>
				<% 
					}	
				}
			    %>
			    </tbody>
			    <tr>
					<td class="">合计</td>
					<td class="">&nbsp;&nbsp;</td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_gy_one %>" name="jb_gy_one_sum" id="jb_gy_one_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_gy_two %>" name="jb_gy_two_sum" id="jb_gy_two_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_gy_three%>" name="jb_gy_three_sum" id="jb_gy_three_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_gy_four%>" name="jb_gy_four_sum" id="jb_gy_four_sum" size="7"/></td>
					
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_mountain_one%>" name="jb_mountain_one_sum" id="jb_mountain_one_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_mountain_two%>" name="jb_mountain_two_sum" id="jb_mountain_two_sum" size="7"/></td>
					
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_zz_one%>" name="jb_zz_one_sum" id="jb_zz_one_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_zz_two%>" name="jb_zz_two_sum" id="jb_zz_two_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_zz_three%>" name="jb_zz_three_sum" id="jb_zz_three_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_zz_four%>" name="jb_zz_four_sum" id="jb_zz_four_sum" size="7"/></td>
					
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_desert_one%>" name="jb_desert_one_sum" id="jb_desert_one_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_desert_two%>" name="jb_desert_two_sum" id="jb_desert_two_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_desert_three%>" name="jb_desert_three_sum" id="jb_desert_three_sum" size="7"/></td>
					
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_hty_one %>" name="jb_hty_one_sum" id="jb_hty_one_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_hty_two %>" name="jb_hty_two_sum" id="jb_hty_two_sum" size="7"/></td>

					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_cy_one %>" name="jb_cy_one_sum" id="jb_cy_one_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_cy_two %>" name="jb_cy_two_sum" id="jb_cy_two_sum" size="7"/></td>
					
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_py_one %>" name="jb_py_one_sum" id="jb_py_one_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_py_two %>" name="jb_py_two_sum" id="jb_py_two_sum" size="7"/></td>	
				</tr>
		      </table>

    </div>
    <div id="oper_div">
    <% if(!action.equals("view")){ %>
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    <% }%>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	//debugger;
	cruConfig.contextPath =  "<%=contextPath%>";		
	var project_info_no = "<%=projectInfoNo%>";
	
	$("input[type=text][name^=input_]").removeAttr("readonly");
	//var flag = 0;
	var flag = 1;
	$("#selectall").click(function(){
		if($("input[name='selectall']").attr("checked") == "checked"){
			$("input[name='selectrow']").attr("checked",true);
		}else{
			$("input[name='selectrow']").attr("checked",false);
		}
		}
	)

	function addCollRows(){
		if(flag == 1){
			var tbody = $("tr","#processtable1");
	 		var showseq = tbody.size()+1;
	 		var lasttr = tbody.eq(tbody.size()-1);
	 		var tr_id = lasttr.attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 1;
			}else{
				tr_id = tr_id+1;
			}
			//动态新增表格
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' collseq='"+tr_id+"'>";
			
			innerhtml += "<td align='center'><input type='checkbox' name='selectrow' value='' id='"+tr_id+"'/></td>";
			innerhtml += "<td>&nbsp;&nbsp;"+showseq+"&nbsp;&nbsp;</td>";
			
			innerhtml += "<td><input name='input_jb_gy_one_"+tr_id+"' id='input_jb_gy_one_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_gy_two_"+tr_id+"' id='input_jb_gy_two_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_gy_three_"+tr_id+"' id='input_jb_gy_three_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_gy_four_"+tr_id+"' id='input_jb_gy_four_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";

			innerhtml += "<td><input name='input_jb_mountain_one_"+tr_id+"' id='input_jb_mountain_one_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_mountain_two_"+tr_id+"' id='input_jb_mountain_two_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";

			innerhtml += "<td><input name='input_jb_zz_one_"+tr_id+"' id='input_jb_zz_one_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_zz_two_"+tr_id+"' id='input_jb_zz_two_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_zz_three_"+tr_id+"' id='input_jb_zz_three_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_zz_four_"+tr_id+"' id='input_jb_zz_four_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";

			innerhtml += "<td><input name='input_jb_desert_one_"+tr_id+"' id='input_jb_desert_one_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_desert_two_"+tr_id+"' id='input_jb_desert_two_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_desert_three_"+tr_id+"' id='input_jb_desert_three_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			
			innerhtml += "<td><input name='input_jb_hty_one_"+tr_id+"' id='input_jb_hty_one_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_hty_two_"+tr_id+"' id='input_jb_hty_two_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";

			innerhtml += "<td><input name='input_jb_cy_one_"+tr_id+"' id='input_jb_cy_one_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_cy_two_"+tr_id+"' id='input_jb_cy_two_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";

			innerhtml += "<td><input name='input_jb_py_one_"+tr_id+"' id='input_jb_py_one_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_py_two_"+tr_id+"' id='input_jb_py_two_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			
			innerhtml += "</tr>";
			$("#processtable1").append(innerhtml);
		}else if(flag == 0){
			alert("无权限增加行");
			return;
		}
	};
	
	var arrayObj = new Array();
	function delCollRows(){
		if(flag == 1){
			var checknum = 0;
			$("input[type='checkbox'][name='selectrow']").each(function(i){
				var checkinfo = this.checked;
				if(checkinfo){
					if(this.value == "" || this.value == undefined){
						$('#tr'+this.id,"#processtable1").remove();
						checknum ++;
					}else{
						var terrain_measure_id = $("#"+this.id).val();
						arrayObj.push(terrain_measure_id);
						$('#tr'+this.id,"#processtable1").remove();
						//alert("已填写数据,不能删除");
						checknum ++;
					}
				}
			});
			
			if(checknum==0){
				alert("请选中记录!");
				return;
			}
			
			resetSeqinfo();
		}else if(flag == 0){
			alert("无权限删除行");
			return;
		}
	};
	
	function resetSeqinfo(){
		$("tr","#processtable1").each(function(i){
			var cells = this.cells;
			$(cells[1]).text((i+1));
			$(cells[1]).attr("align","center");
		});
	}
	
	function checkNum(obj){
		var reg = /^[0-9]+(\.[0-9])?$/;
		if(obj.value != "" && obj.value != undefined){
			if(!reg.test(obj.value)){
				alert("只能是整数!");
				obj.value = "";
				totalValue(obj);
			}else{
				var id = obj.id;
				var id_flag = id.substring(0,id.lastIndexOf("_")+1);
				var sum_id_flag = "#"+id.substring(6,id.lastIndexOf("_")+1)+"sum";
				totalValue(obj);
			}
		}else if(obj.value == ""){
				totalValue(obj);
		}
	}
	
	function totalValue(obj){
		var id = obj.id;
		var id_flag = id.substring(0,id.lastIndexOf("_")+1);
		var sum_id_flag = "#"+id.substring(6,id.lastIndexOf("_")+1)+"sum";
		
		var s = "input[id^="+id_flag+"]"
		var ids = $(s);
		var id_length = $(s).length;
		var total = 0;
		for(var i=0;i<id_length;i++){
			if(ids[i].value != "" && ids[i].value != undefined){
				total +=  Number(ids[i].value);
			}
		}
		$(sum_id_flag).val(total);
	}
	
	function changeData(){
		flag =1;
		var qTable = document.getElementById("processtable1"); 
		for (var i=0;i<qTable.all.length; i++) {
			var obj = qTable.all[i];
			if(obj.name==undefined || obj.name=='') continue;
			
			if (obj.tagName == "INPUT") {
				if(obj.type == "text"){
					obj.removeAttribute("readonly");		
				}
			}
		}
		alert("可以修改数据了");
	}

	
	function sumValue(id_flag,sum_id_flag){
		var s = "input[id^="+id_flag+"]"
		var ids = $(s);
		var id_length = $(s).length;
		var total = 0;
		for(var i=0;i<id_length;i++){
			if(ids[i].value != "" && ids[i].value != undefined){
				total +=  Number(ids[i].value);
			}
		}
		$(sum_id_flag).val(total.toFixed(2));
	}
	
	function measureExportData(){
		var flag = "<%=flag%>";	
		if(flag == "notempty"){
			window.location = '<%=contextPath%>/pm/project/wt/measureExportExcel.srq?projectInfoNo=<%=projectInfoNo%>&measureType=0&viewmeasurement=<%=view_measurement%>&lineUnit=<%=lineUnit%>';
		}else{
			alert("没有数据,无法导出!");
			return;
		}
		
	}
	
	function saveInfo(){
		if(flag == 1){
			var tr_size = $("tr","#processtable1").size();
			
			var rowParams = new Array();
			
			if(tr_size != 0 && tr_size != undefined){
				for(var i=0; i<tr_size; i++){
					
					var id = $("tr[id^=tr]")[i].collseq;
					var param = "input[type='checkbox'][id='"+id+"']";
					var measure_id = $(param)[0].value;

					var input_jb_gy_one = $("#input_jb_gy_one_"+id)[0].value;	
					var input_jb_gy_two = $("#input_jb_gy_two_"+id)[0].value;
					var input_jb_gy_three = $("#input_jb_gy_three_"+id)[0].value;
					var input_jb_gy_four = $("#input_jb_gy_four_"+id)[0].value;

					var input_jb_mountain_one = $("#input_jb_mountain_one_"+id)[0].value;	
					var input_jb_mountain_two = $("#input_jb_mountain_two_"+id)[0].value;

					var input_jb_zz_one = $("#input_jb_zz_one_"+id)[0].value;	
					var input_jb_zz_two = $("#input_jb_zz_two_"+id)[0].value;
					var input_jb_zz_three = $("#input_jb_zz_three_"+id)[0].value;
					var input_jb_zz_four = $("#input_jb_zz_four_"+id)[0].value;

					var input_jb_desert_one = $("#input_jb_desert_one_"+id)[0].value;	
					var input_jb_desert_two = $("#input_jb_desert_two_"+id)[0].value;
					var input_jb_desert_three = $("#input_jb_desert_three_"+id)[0].value;

					var input_jb_hty_one = $("#input_jb_hty_one_"+id)[0].value;	
					var input_jb_hty_two = $("#input_jb_hty_two_"+id)[0].value;

					var input_jb_cy_one = $("#input_jb_cy_one_"+id)[0].value;	
					var input_jb_cy_two = $("#input_jb_cy_two_"+id)[0].value;

					var input_jb_py_one = $("#input_jb_py_one_"+id)[0].value;	
					var input_jb_py_two = $("#input_jb_py_two_"+id)[0].value;

					var rowParam = {};
					//如果measure_id不是空,修改数据
					//if(input_line_number.length > 0){
						if(measure_id != ""){
							rowParam['TERRAIN_MEASURE_ID'] = measure_id;
							rowParam['PROJECT_INFO_NO'] = '<%=projectInfoNo%>';
							//rowParam['LINE_NO'] = encodeURI(encodeURI(input_line_number));
							rowParam['JB_GY_ONE'] = input_jb_gy_one;
							rowParam['JB_GY_TWO'] = input_jb_gy_two;
							rowParam['JB_GY_THREE'] = input_jb_gy_three;
							rowParam['JB_GY_FOUR'] = input_jb_gy_four;

							rowParam['JB_MOUNTAIN_ONE'] = input_jb_mountain_one;
							rowParam['JB_MOUNTAIN_TWO'] = input_jb_mountain_two;

							rowParam['JB_ZZ_ONE'] = input_jb_zz_one;
							rowParam['JB_ZZ_TWO'] = input_jb_zz_two;
							rowParam['JB_ZZ_THREE'] = input_jb_zz_three;
							rowParam['JB_ZZ_FOUR'] = input_jb_zz_four;

							rowParam['JB_DESERT_ONE'] = input_jb_desert_one;
							rowParam['JB_DESERT_TWO'] = input_jb_desert_two;
							rowParam['JB_DESERT_THREE'] = input_jb_desert_three;

							rowParam['JB_HTY_ONE'] = input_jb_hty_one;
							rowParam['JB_HTY_TWO'] = input_jb_hty_two;

							rowParam['JB_CY_ONE'] = input_jb_cy_one;
							rowParam['JB_CY_TWO'] = input_jb_cy_two;

							rowParam['JB_PY_ONE'] = input_jb_py_one;
							rowParam['JB_PY_TWO'] = input_jb_py_two;

							rowParam['MEASURE_CONFIRM'] = '0';
							rowParam['BSFLAG'] = '0';
							rowParam['UPDATOR'] = '<%=userId%>';
							rowParam['UPDATE_DATE'] = '<%=curDate%>';
						}
						//插入数据
						else{
							rowParam['PROJECT_INFO_NO'] = '<%=projectInfoNo%>';
							//rowParam['LINE_NO'] = encodeURI(encodeURI(input_line_number));
							rowParam['JB_GY_ONE'] = input_jb_gy_one;
							rowParam['JB_GY_TWO'] = input_jb_gy_two;
							rowParam['JB_GY_THREE'] = input_jb_gy_three;
							rowParam['JB_GY_FOUR'] = input_jb_gy_four;

							rowParam['JB_MOUNTAIN_ONE'] = input_jb_mountain_one;
							rowParam['JB_MOUNTAIN_TWO'] = input_jb_mountain_two;

							rowParam['JB_ZZ_ONE'] = input_jb_zz_one;
							rowParam['JB_ZZ_TWO'] = input_jb_zz_two;
							rowParam['JB_ZZ_THREE'] = input_jb_zz_three;
							rowParam['JB_ZZ_FOUR'] = input_jb_zz_four;

							rowParam['JB_DESERT_ONE'] = input_jb_desert_one;
							rowParam['JB_DESERT_TWO'] = input_jb_desert_two;
							rowParam['JB_DESERT_THREE'] = input_jb_desert_three;

							rowParam['JB_HTY_ONE'] = input_jb_hty_one;
							rowParam['JB_HTY_TWO'] = input_jb_hty_two;

							rowParam['JB_CY_ONE'] = input_jb_cy_one;
							rowParam['JB_CY_TWO'] = input_jb_cy_two;

							rowParam['JB_PY_ONE'] = input_jb_py_one;
							rowParam['JB_PY_TWO'] = input_jb_py_two;

							rowParam['MEASURE_CONFIRM'] = '0';
							rowParam['BSFLAG'] = '0';
							rowParam['CREATOR'] = '<%=userId%>';
							rowParam['CREATE_DATE'] = '<%=curDate%>';
							rowParam['UPDATOR'] = '<%=userId%>';
							rowParam['UPDATE_DATE'] = '<%=curDate%>';
						}
						rowParams[rowParams.length] = rowParam;
				}
			}
			//如果删除信息的数据不为空
			if(arrayObj.length > 0){
				for(var k=0;k<arrayObj.length;k++){
					var delrowParam = {};
					if(arrayObj[k] != ""){
						delrowParam['TERRAIN_MEASURE_ID'] = arrayObj[k];
						delrowParam['BSFLAG'] = '1';	
						delrowParam['UPDATOR'] = '<%=userId%>';
						delrowParam['UPDATE_DATE'] = '<%=curDate%>';
					}
					rowParams[rowParams.length] = delrowParam;
				}
				var rows=rowParams.toJSONString();
				saveFunc("BGP_PM_TERRAIN_MEASURE",rows);
			}else{
				var rows=rowParams.toJSONString();
				saveFunc("BGP_PM_TERRAIN_MEASURE",rows);
			}
			
		}else if(flag == 0){
			alert("无权限修改!");
			return;
		}
		
	}
</script>
</html>

