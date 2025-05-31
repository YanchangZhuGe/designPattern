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
	String projectInfoNo = request.getParameter("projectInfoNo");
	String projectName = "";
	if(respMsg.getValue("projectName") != null){
		projectName = respMsg.getValue("projectName");
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    
    List<MsgElement> showMeasureList = null;
    String flag = "empty";
    if(respMsg.getMsgElements("showMeasureList") != null){
    	  showMeasureList = respMsg.getMsgElements("showMeasureList");
    	  flag = "notempty";
    }else{
    	System.out.println("empty");
    }
    
	String total_jb_mountain_one = "";
	String total_jb_mountain_two = "";
	String total_jb_mountain_three = "";
	String total_jb_desert_small = "";
	String total_jb_desert_big = "";
	String total_jb_sw_zz = "";
	String total_jb_yzw_nt = "";
	String total_jb_wzw_nt = "";
	
	String total_px_mountain_one = "";
	String total_px_mountain_two = "";
	String total_px_mountain_three = "";
	String total_px_desert_small = "";
	String total_px_desert_big = "";
	String total_px_sw_zz = "";
	String total_px_yzw_nt = "";
	String total_px_wzw_nt = "";
	String view_measurement = "";
    
	
    if(respMsg.getValue("total_jb_mountain_one") != null && !"0.0".equals(respMsg.getValue("total_jb_mountain_one").toString())){
    	total_jb_mountain_one = respMsg.getValue("total_jb_mountain_one");
    }
    if(respMsg.getValue("total_jb_mountain_two") != null && !"0.0".equals(respMsg.getValue("total_jb_mountain_two").toString())){
    	total_jb_mountain_two = respMsg.getValue("total_jb_mountain_two");
    }
    if(respMsg.getValue("total_jb_mountain_three") != null && !"0.0".equals(respMsg.getValue("total_jb_mountain_three").toString())){
    	total_jb_mountain_three = respMsg.getValue("total_jb_mountain_three");
    }
    if(respMsg.getValue("total_jb_desert_small") != null && !"0.0".equals(respMsg.getValue("total_jb_desert_small").toString())){
    	total_jb_desert_small = respMsg.getValue("total_jb_desert_small");
    }
    if(respMsg.getValue("total_jb_desert_big") != null && !"0.0".equals(respMsg.getValue("total_jb_desert_big").toString())){
    	total_jb_desert_big = respMsg.getValue("total_jb_desert_big");
    }
    if(respMsg.getValue("total_jb_sw_zz") != null && !"0.0".equals(respMsg.getValue("total_jb_sw_zz").toString())){
    	total_jb_sw_zz = respMsg.getValue("total_jb_sw_zz");
    }
    if(respMsg.getValue("total_jb_yzw_nt") != null && !"0.0".equals(respMsg.getValue("total_jb_yzw_nt").toString())){
    	total_jb_yzw_nt = respMsg.getValue("total_jb_yzw_nt");
    }
    if(respMsg.getValue("total_jb_wzw_nt") != null && !"0.0".equals(respMsg.getValue("total_jb_wzw_nt").toString())){
    	total_jb_wzw_nt = respMsg.getValue("total_jb_wzw_nt");
    }
    
    
    if(respMsg.getValue("total_px_mountain_one") != null && !"0.0".equals(respMsg.getValue("total_px_mountain_one").toString())){
    	total_px_mountain_one = respMsg.getValue("total_px_mountain_one");
    }
    if(respMsg.getValue("total_px_mountain_two") != null && !"0.0".equals(respMsg.getValue("total_px_mountain_two").toString())){
    	total_px_mountain_two = respMsg.getValue("total_px_mountain_two");
    }
    if(respMsg.getValue("total_px_mountain_three") != null && !"0.0".equals(respMsg.getValue("total_px_mountain_three").toString())){
    	total_px_mountain_three = respMsg.getValue("total_px_mountain_three");
    }
    if(respMsg.getValue("total_px_desert_small") != null && !"0.0".equals(respMsg.getValue("total_px_desert_small").toString())){
    	total_px_desert_small = respMsg.getValue("total_px_desert_small");
    }
    if(respMsg.getValue("total_px_desert_big") != null && !"0.0".equals(respMsg.getValue("total_px_desert_big").toString())){
    	total_px_desert_big = respMsg.getValue("total_px_desert_big");
    }
    if(respMsg.getValue("total_px_sw_zz") != null && !"0.0".equals(respMsg.getValue("total_px_sw_zz").toString())){
    	total_px_sw_zz = respMsg.getValue("total_px_sw_zz");
    }
    if(respMsg.getValue("total_px_yzw_nt") != null && !"0.0".equals(respMsg.getValue("total_px_yzw_nt").toString())){
    	total_px_yzw_nt = respMsg.getValue("total_px_yzw_nt");
    }
    if(respMsg.getValue("total_px_wzw_nt") != null && !"0.0".equals(respMsg.getValue("total_px_wzw_nt").toString())){
    	total_px_wzw_nt = respMsg.getValue("total_px_wzw_nt");
    }
    //viewmeasurement
    if(respMsg.getValue("viewmeasurement") != null && respMsg.getValue("viewmeasurement") != ""){
    	view_measurement = respMsg.getValue("viewmeasurement");
    }
    
   // List<MsgElement> showMeasureList = respMsg.getMsgElements("showMeasureList");
   // System.out.println("showMeasureList is:"+showMeasureList);
   // String total_jb_mountain_one = respMsg.getValue("total_jb_mountain_one");
   // System.out.println("total_jb_mountain_one is:"+total_jb_mountain_one);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/pm/measurement/myjson.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<title>地形分类测算表</title>
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
			    		<%-- <auth:ListButton functionId="" css="xg" event="onclick='changeData()'" title="修改数据"></auth:ListButton> --%>
			    		<auth:ListButton functionId="" css="sc" id="delRow" event="onclick='delCollRows()'" title="删除一条数据"></auth:ListButton>
			  		<%} %>
			    	<auth:ListButton functionId="" css="dc" event="onclick='measureExportData()'" title="导出excel"></auth:ListButton>
			    	</td>
				</tr>
			  </table>
			  <table width="99%" id="queryRetTable" name="queryRetTable" border="1" cellspacing="0" cellpadding="0" style="word-break :keep-all;" >
			   <tr class = "bt_info_even">
					<td colspan="19" align="center">
						<font size="3"><%=projectName %>地形分类测算表</font>
					</td>
			   </tr>
		       <tr class = "bt_info_odd">
					<td colspan = "11">检波点(个数)</td>
					<td colspan = "8">炮点(个数)</td>
			   </tr>
		       <tr>
		       		<td class = "bt_info_even" rowspan="2" width="4%"><input type="checkbox" name="selectall" id="selectall"/></td>
		       		<td class = "bt_info_even" rowspan = "2">序号</td>
					<td class = "bt_info_even" rowspan = "2" width="15%">测线号</td>
					<td class = "bt_info_even" colspan="3" width="15%">山地</td>
					<td class = "bt_info_even" colspan="2" width="10%">沙漠</td>
					<td class = "bt_info_even" rowspan = "2" width="6%">水网、沼泽</td>
					<td class = "bt_info_even" rowspan = "2" width="7%">有作物农田、浮土地</td>
					<td class = "bt_info_even" rowspan = "2" width="7%">无作物农田、戈壁平原</td>
					<td class = "bt_info_even" colspan="3" width="15%">山地</td>
					<td class = "bt_info_even" colspan="2" width="10%">沙漠</td>
					<td class = "bt_info_even" rowspan = "2" width="6%">水网、沼泽</td>
					<td class = "bt_info_even" rowspan = "2" width="7%">有作物农田、浮土地</td>
					<td class = "bt_info_even" rowspan = "2" width="7%">无作物农田、戈壁平原</td>
				</tr>
				<tr>
					<td class = "bt_info_even" width="5%">I类</td>
					<td class = "bt_info_even" width="5%">II类</td>
					<td class = "bt_info_even" width="5%">III类</td>
					<td class = "bt_info_even" width="5%">小沙</td>
					<td class = "bt_info_even" width="5%">大沙</td>
					<td class = "bt_info_even" width="5%">I类</td>
					<td class = "bt_info_even" width="5%">II类</td>
					<td class = "bt_info_even" width="5%">III类</td>
					<td class = "bt_info_even" width="5%">小沙</td>
					<td class = "bt_info_even" width="5%">大沙</td>	
				</tr>
			    <tbody id="processtable1" name="processtable1" >
			    <%if(showMeasureList != null){ 
					Map<String,String> measureMap = new HashMap<String,String>();
					for(int i=0;i<showMeasureList.size();i++){
						measureMap = ((MsgElement)showMeasureList.get(i)).toMap();
				%>
					<tr id='tr<%=i+1 %>' name='tr<%=i+1 %>' collseq='<%=i+1%>'>
					<td align="center"><input type='checkbox' name='selectrow' value='<%=measureMap.get("terrain_measure_id") %>' id='<%=i+1 %>'/></td>
					<td>&nbsp;&nbsp;<%=i+1 %>&nbsp;&nbsp;
					<input type='hidden' value='<%=measureMap.get("terrain_measure_id") %>' name='measure_id<%=i+1 %>' id='measure_id<%=i+1 %>'/>
					</td>
					<td><input name='input_line_number_<%=i+1 %>' readonly="readonly" id='input_line_number_<%=i+1 %>' value='<%=measureMap.get("line_no") %>' type='text' size='12'/></td>
					<td><input name='input_jb_sd_one_<%=i+1 %>' readonly="readonly" id='input_jb_sd_one_<%=i+1 %>' value='<%=measureMap.get("jb_mountain_one") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_sd_two_<%=i+1 %>' readonly="readonly" id='input_jb_sd_two_<%=i+1 %>' value='<%=measureMap.get("jb_mountain_two") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_sd_three_<%=i+1 %>' readonly="readonly" id='input_jb_sd_three_<%=i+1 %>' value='<%=measureMap.get("jb_mountain_three") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_sm_small_<%=i+1 %>' readonly="readonly" id='input_jb_sm_small_<%=i+1 %>' value='<%=measureMap.get("jb_desert_small") %>' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_sm_big_<%=i+1 %>' readonly="readonly" id='input_jb_sm_big_<%=i+1 %>' value='<%=measureMap.get("jb_desert_big") %>' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_swzz_<%=i+1 %>' readonly="readonly" id='input_jb_swzz_<%=i+1 %>' value='<%=measureMap.get("jb_sw_zz") %>' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_yzw_<%=i+1 %>' readonly="readonly" id='input_jb_yzw_<%=i+1 %>' value='<%=measureMap.get("jb_yzw_nt") %>' type='text' size='10' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_jb_wzw_<%=i+1 %>' readonly="readonly" id='input_jb_wzw_<%=i+1 %>' value='<%=measureMap.get("jb_wzw_nt") %>' type='text' size='10' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_px_sd_one_<%=i+1 %>' readonly="readonly" id='input_px_sd_one_<%=i+1 %>' value='<%=measureMap.get("px_mountain_one")%>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_px_sd_two_<%=i+1 %>' readonly="readonly" id='input_px_sd_two_<%=i+1 %>' value='<%=measureMap.get("px_mountain_two") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_px_sd_three_<%=i+1 %>' readonly="readonly" id='input_px_sd_three_<%=i+1 %>' value='<%=measureMap.get("px_mountain_three") %>' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_px_sm_small_<%=i+1 %>' readonly="readonly" id='input_px_sm_small_<%=i+1 %>' value='<%=measureMap.get("px_desert_small") %>' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_px_sm_big_<%=i+1 %>' readonly="readonly" id='input_px_sm_big_<%=i+1 %>' value='<%=measureMap.get("px_desert_big") %>' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_px_swzz_<%=i+1 %>' readonly="readonly" id='input_px_swzz_<%=i+1 %>' value='<%=measureMap.get("px_sw_zz") %>' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_px_yzw_<%=i+1 %>' readonly="readonly" id='input_px_yzw_<%=i+1 %>' value='<%=measureMap.get("px_yzw_nt") %>' type='text' size='10' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					<td><input name='input_px_wzw_<%=i+1 %>' readonly="readonly" id='input_px_wzw_<%=i+1 %>' value='<%=measureMap.get("px_wzw_nt") %>' type='text' size='10' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>
					</tr>
				<% 
					}	
				}
			    %>
			    </tbody>
			    <tr>
					<td class="">合计</td>
					<td class="">&nbsp;&nbsp;</td>
					<td class=""><input type="text" readonly="readonly" name="line_number_sum" id="line_number_sum" size="12"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_mountain_one %>" name="jb_sd_one_sum" id="jb_sd_one_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_mountain_two %>" name="jb_sd_two_sum" id="jb_sd_two_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_mountain_three%>" name="jb_sd_three_sum" id="jb_sd_three_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_desert_small %>" name="jb_sm_small_sum" id="jb_sm_small_sum" size="8"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_desert_big %>" name="jb_sm_big_sum" id="jb_sm_big_sum" size="8"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_sw_zz %>" name="jb_swzz_sum" id="jb_swzz_sum" size="8"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_yzw_nt %>" name="jb_yzw_sum" id="jb_yzw_sum" size="10"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_jb_wzw_nt %>" name="jb_wzw_sum" id="jb_wzw_sum" size="10"/></td>	
					<td class=""><input type="text" readonly="readonly" value="<%=total_px_mountain_one %>" name="px_sd_one_sum" id="px_sd_one_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_px_mountain_two %>" name="px_sd_two_sum" id="px_sd_two_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_px_mountain_three %>" name="px_sd_three_sum" id="px_sd_three_sum" size="7"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_px_desert_small %>" name="px_sm_small_sum" id="px_sm_small_sum" size="8"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_px_desert_big %>" name="px_sm_big_sum" id="px_sm_big_sum" size="8"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_px_sw_zz %>" name="px_swzz_sum" id="px_swzz_sum" size="8"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_px_yzw_nt %>" name="px_yzw_sum" id="px_yzw_sum" size="10"/></td>
					<td class=""><input type="text" readonly="readonly" value="<%=total_px_wzw_nt %>" name="px_wzw_sum" id="px_wzw_sum" size="10"/></td>	
				</tr>
		      </table>

    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	
	cruConfig.contextPath =  "<%=contextPath%>";		
	var project_info_no = "<%=projectInfoNo%>";
	
	//$("input[type=text][name^=input_]").removeAttr("readonly");
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
			
			innerhtml += "<td><input name='input_line_number_"+tr_id+"' id='input_line_number_"+tr_id+"' type='text' size='12'/></td>";
			
			innerhtml += "<td><input name='input_jb_sd_one_"+tr_id+"' id='input_jb_sd_one_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_sd_two_"+tr_id+"' id='input_jb_sd_two_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_sd_three_"+tr_id+"' id='input_jb_sd_three_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			
			innerhtml += "<td><input name='input_jb_sm_small_"+tr_id+"' id='input_jb_sm_small_"+tr_id+"' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_sm_big_"+tr_id+"' id='input_jb_sm_big_"+tr_id+"' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			
			innerhtml += "<td><input name='input_jb_swzz_"+tr_id+"' id='input_jb_swzz_"+tr_id+"' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_yzw_"+tr_id+"' id='input_jb_yzw_"+tr_id+"' type='text' size='10' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_jb_wzw_"+tr_id+"' id='input_jb_wzw_"+tr_id+"' type='text' size='10' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			
			innerhtml += "<td><input name='input_px_sd_one_"+tr_id+"' id='input_px_sd_one_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_px_sd_two_"+tr_id+"' id='input_px_sd_two_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_px_sd_three_"+tr_id+"' id='input_px_sd_three_"+tr_id+"' type='text' size='7' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			
			innerhtml += "<td><input name='input_px_sm_small_"+tr_id+"' id='input_px_sm_small_"+tr_id+"' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_px_sm_big_"+tr_id+"' id='input_px_sm_big_"+tr_id+"' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			
			innerhtml += "<td><input name='input_px_swzz_"+tr_id+"' id='input_px_swzz_"+tr_id+"' type='text' size='8' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_px_yzw_"+tr_id+"' id='input_px_yzw_"+tr_id+"' type='text' size='10' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			innerhtml += "<td><input name='input_px_wzw_"+tr_id+"' id='input_px_wzw_"+tr_id+"' type='text' size='10' onkeyup='checkNum(this)' onblur='totalValue(this)'/></td>";
			
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
	function refreshData(){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "";
		cruConfig.queryService = "MeasureSrv";
		cruConfig.queryOp = "queryMeasureList";
		cruConfig.submitStr = "projectInfoNo="+project_info_no+"&measureType=0";	
		queryData(1);	
	}
	
	function checkNum(obj){
		var reg = /^[0-9]+(\.[0-9]{0,2})?$/;
		//最多两位小数
		if(obj.value != "" && obj.value != undefined){
			if(!reg.test(obj.value)){
				alert("只能是最多两位小数的数字!");
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
		$(sum_id_flag).val(total.toFixed(2));
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
			window.location = '<%=contextPath%>/pm/project/measureExportExcel.srq?projectInfoNo=<%=projectInfoNo%>&measureType=0';
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
					var input_line_number = $("#input_line_number_"+id)[0].value;	
					var input_jb_sd_one = $("#input_jb_sd_one_"+id)[0].value;	
					var input_jb_sd_two = $("#input_jb_sd_two_"+id)[0].value;
					var input_jb_sd_three = $("#input_jb_sd_three_"+id)[0].value;
					var input_jb_sm_small = $("#input_jb_sm_small_"+id)[0].value;
					var input_jb_sm_big = $("#input_jb_sm_big_"+id)[0].value;
					var input_jb_swzz =$("#input_jb_swzz_"+id)[0].value;
					var input_jb_yzw = $("#input_jb_yzw_"+id)[0].value;
					var input_jb_wzw = $("#input_jb_wzw_"+id)[0].value;
					
					var input_px_sd_one = $("#input_px_sd_one_"+id)[0].value;	
					var input_px_sd_two = $("#input_px_sd_two_"+id)[0].value;
					var input_px_sd_three = $("#input_px_sd_three_"+id)[0].value;
					var input_px_sm_small = $("#input_px_sm_small_"+id)[0].value;
					var input_px_sm_big = $("#input_px_sm_big_"+id)[0].value;
					var input_px_swzz =$("#input_px_swzz_"+id)[0].value;
					var input_px_yzw = $("#input_px_yzw_"+id)[0].value;
					var input_px_wzw = $("#input_px_wzw_"+id)[0].value;
					var rowParam = {};
					//如果measure_id不是空,修改数据
					//if(input_line_number.length > 0){
						if(measure_id != ""){
							rowParam['TERRAIN_MEASURE_ID'] = measure_id;
							rowParam['PROJECT_INFO_NO'] = '<%=projectInfoNo%>';
							rowParam['LINE_NO'] = encodeURI(encodeURI(input_line_number));
							rowParam['JB_MOUNTAIN_ONE'] = input_jb_sd_one;
							rowParam['JB_MOUNTAIN_TWO'] = input_jb_sd_two;
							rowParam['JB_MOUNTAIN_THREE'] = input_jb_sd_three;
							rowParam['JB_DESERT_SMALL'] = input_jb_sm_small;
							rowParam['JB_DESERT_BIG'] = input_jb_sm_big;
							rowParam['JB_SW_ZZ'] = input_jb_swzz;
							rowParam['JB_YZW_NT'] = input_jb_yzw;
							rowParam['JB_WZW_NT'] = input_jb_wzw;				
							rowParam['PX_MOUNTAIN_ONE'] = input_px_sd_one;
							rowParam['PX_MOUNTAIN_TWO'] = input_px_sd_two;
							rowParam['PX_MOUNTAIN_THREE'] = input_px_sd_three;
							rowParam['PX_DESERT_SMALL'] = input_px_sm_small;
							rowParam['PX_DESERT_BIG'] = input_px_sm_big;
							rowParam['PX_SW_ZZ'] = input_px_swzz;
							rowParam['PX_YZW_NT'] = input_px_yzw;
							rowParam['PX_WZW_NT'] = input_px_wzw;				
							rowParam['MEASURE_CONFIRM'] = '0';
							rowParam['BSFLAG'] = '0';
							rowParam['UPDATOR'] = '<%=userId%>';
							rowParam['UPDATE_DATE'] = '<%=curDate%>';
						}
						//插入数据
						else{
							rowParam['PROJECT_INFO_NO'] = '<%=projectInfoNo%>';
							rowParam['LINE_NO'] = encodeURI(encodeURI(input_line_number));
							rowParam['JB_MOUNTAIN_ONE'] = input_jb_sd_one;
							rowParam['JB_MOUNTAIN_TWO'] = input_jb_sd_two;
							rowParam['JB_MOUNTAIN_THREE'] = input_jb_sd_three;
							rowParam['JB_DESERT_SMALL'] = input_jb_sm_small;
							rowParam['JB_DESERT_BIG'] = input_jb_sm_big;
							rowParam['JB_SW_ZZ'] = input_jb_swzz;
							rowParam['JB_YZW_NT'] = input_jb_yzw;
							rowParam['JB_WZW_NT'] = input_jb_wzw;				
							rowParam['PX_MOUNTAIN_ONE'] = input_px_sd_one;
							rowParam['PX_MOUNTAIN_TWO'] = input_px_sd_two;
							rowParam['PX_MOUNTAIN_THREE'] = input_px_sd_three;
							rowParam['PX_DESERT_SMALL'] = input_px_sm_small;
							rowParam['PX_DESERT_BIG'] = input_px_sm_big;
							rowParam['PX_SW_ZZ'] = input_px_swzz;
							rowParam['PX_YZW_NT'] = input_px_yzw;
							rowParam['PX_WZW_NT'] = input_px_wzw;				
							rowParam['MEASURE_CONFIRM'] = '0';
							rowParam['BSFLAG'] = '0';
							rowParam['CREATOR'] = '<%=userId%>';
							rowParam['CREATE_DATE'] = '<%=curDate%>';
							rowParam['UPDATOR'] = '<%=userId%>';
							rowParam['UPDATE_DATE'] = '<%=curDate%>';
						}
						rowParams[rowParams.length] = rowParam;
					//}
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

