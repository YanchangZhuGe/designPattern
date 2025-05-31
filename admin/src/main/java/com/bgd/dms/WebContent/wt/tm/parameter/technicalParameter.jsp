<%@page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	//保存结果 1 保存成功
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String saveResult = null;
	if (respMsg != null && respMsg.getValue("saveResult") != null) {
		saveResult = respMsg.getValue("saveResult");
	}

	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	//String buildMethod = request.getParameter("buildmethod");

	String action = request.getParameter("action");
	if (action == null || "".equals(action)) {
		action = "";
	}

	if (projectInfoNo == null || "".equals(projectInfoNo)) {
		projectInfoNo = user.getProjectInfoNo();
	}
	String projectName = user.getProjectName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>施工方法</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript">

//alert("nnnnnnnnnnnnnnnnnnnnnnnn");

<%-- 
	/**
		重力方法
		5110000056000000007 陆地重力测量
		5110000056000000008 水底重力测量
		5110000056000000009 海洋重力测量
		5110000056000000010 航空重力测量
		5110000056000000011 微重力测量
		磁力
		5110000056000000012 陆地磁力测量
		5110000056000000013 海洋磁力测量
		5110000056000000014 航空磁力测量
		5110000056000000015 微磁测量
		天然场源电磁法
		5110000056000000016 大地电磁测深（MT）
		5110000056000000017 连续电磁剖面法（CEMP）
		5110000056000000018 自然电位法（SP）
		5110000056000000019 高频电磁法（HFEM）
		5110000056000000020 声频大地电磁法（AMT）
		人工场源电磁法
		5110000056000000021 固定源建场测深法（LOTEM）
		5110000056000000022 可控源声频大地电磁法（CSAMT）
		5110000056000000023 大功率井地电法 （BSEM）
		5110000056000000024 复电阻率法（CR）
		5110000056000000025 激发极化法（IP）
		5110000056000000026 时频电磁法（TFEM）
		5110000056000000027 垂向电测深法（VES）
		工程勘探
		5110000056000000028 大地电场法
		。。。。
		5110000056000000043 浅层地震勘探
		化探
		5110000056000000044 化探
		**/



--%>

//定义简单Map  
function getMap() {//初始化map_,给map_对象增加方法，使map_像Map    
       var map_ = new Object();    
       map_.put = function(key, value) {    
           map_[key+'_'] = value;    
       };    
       map_.get = function(key) {    
           return map_[key+'_'];    
       };    
       map_.remove = function(key) {    
           delete map_[key+'_'];    
       };    
       map_.keyset = function() {    
           var ret = "";    
           for(var p in map_) {    
               if(typeof p == 'string' && p.substring(p.length-1) == "_") {    
                   ret += ",";    
                   ret += p.substring(0,p.length-1);    
               }    
           }    
           if(ret == "") {    
               return ret.split(",");    
           } else {    
               return ret.substring(1).split(",");    
           }    
       };    
       return map_;    
}    

//初始化勘探方法对应的类型
var workloadMap = getMap();




//重力 5110000056000000001
workloadMap.put("5110000056000000001","zl");
<%--
workloadMap.put("5110000056000000007","zl");
workloadMap.put("5110000056000000008","zl");
workloadMap.put("5110000056000000009","zl");
workloadMap.put("5110000056000000010","zl");
workloadMap.put("5110000056000000011","zl");
--%>
//磁力 5110000056000000002
workloadMap.put("5110000056000000002","cl");
<%--
workloadMap.put("5110000056000000012","cl");
workloadMap.put("5110000056000000013","cl");
workloadMap.put("5110000056000000014","cl");
workloadMap.put("5110000056000000015","cl");
--%>

//天然场源电磁法 5110000056000000003
workloadMap.put("5110000056000000003","tr");
<%--
workloadMap.put("5110000056000000016","tr");
workloadMap.put("5110000056000000017","tr");
workloadMap.put("5110000056000000018","tr");
workloadMap.put("5110000056000000019","tr");
workloadMap.put("5110000056000000020","tr");
--%>
//人工场源电磁法 5110000056000000004  可变化
workloadMap.put("5110000056000000004","rg");
<%--
workloadMap.put("5110000056000000021","rg");
workloadMap.put("5110000056000000022","rg");
workloadMap.put("5110000056000000023","rg");
workloadMap.put("5110000056000000024","rg");
workloadMap.put("5110000056000000025","rg");
workloadMap.put("5110000056000000026","rg");
workloadMap.put("5110000056000000027","rg");
--%>

//工程勘探 5110000056000000006
workloadMap.put("5110000056000000006","gc");
<%--
workloadMap.put("5110000056000000028","gc");
workloadMap.put("5110000056000000022","gc");
workloadMap.put("5110000056000000023","gc");
workloadMap.put("5110000056000000024","gc");
workloadMap.put("5110000056000000025","gc");
workloadMap.put("5110000056000000026","gc");
workloadMap.put("5110000056000000027","gc");
workloadMap.put("5110000056000000028","gc");
workloadMap.put("5110000056000000029","gc");
workloadMap.put("5110000056000000030","gc");
workloadMap.put("5110000056000000031","gc");
workloadMap.put("5110000056000000032","gc");
workloadMap.put("5110000056000000033","gc");
workloadMap.put("5110000056000000034","gc");
workloadMap.put("5110000056000000035","gc");
workloadMap.put("5110000056000000036","gc");
workloadMap.put("5110000056000000037","gc");
workloadMap.put("5110000056000000038","gc");
workloadMap.put("5110000056000000039","gc");
workloadMap.put("5110000056000000040","gc");
workloadMap.put("5110000056000000041","gc");
workloadMap.put("5110000056000000042","gc");
workloadMap.put("5110000056000000043","gc");
--%>
//化探    5110000056000000005
<%----%>
workloadMap.put("5110000056000000005","ht");

//是否为展示页面
var action = "<%=action%>";

var pin = "<%=projectInfoNo%>";



//初始化勘探方法对应的类型
var tempMap = getMap();

//人工场源 用到的项name
var afStrs = new Array();

function loadData(){
	debugger;
	///////////////////////////1 先取项目已选的勘探方法        动态生成勘探方法表格/////////////////////////////////////
	var pstr = "projectInfoNo="+pin;
	//var retObj = jcdpCallService("WtWorkMethodSrv", "getProjectMethod","projectInfoNo="+projectInfoNo);//   项目以用的探方法 包含父级别勘探方法
	var retObj = jcdpCallService("WtWorkMethodSrv", "getProjectMethod",pstr);//   项目以用的探方法 包含父级别勘探方法
	for(var i=0;i<retObj.methodMapList.length;i++){
		//一种勘探方法
		var row = retObj.methodMapList[i];
		var methodname = row.coding_name;
		var methodcode = row.coding_code_id;
		
		var methodparentcode = row.superior_code_id;

		
		if(methodparentcode=="0"){
			methodparentcode=methodcode;//化探没有子项 5110000056000000005
		}
		tempMap.put(methodcode,methodparentcode);
		//alert(methodparentcode);
		//alert(workloadMap.get(methodparentcode));
		if(workloadMap.get(methodparentcode)=="zl"){
			//重力类型  新增重力类数据	
			//alert('重力@@@@@@@@'+methodparentcode);
			$("#tablezl").append('<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height"><tr style="background-color: #97cbfd">'
			+'<td align="left" width="90%" id="td_well_artillery"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">(重力)'+methodname+'</font></span><input type="hidden" name="id-'+methodcode+'" id="id-'+methodcode+'" /></td>'
			+'</tr></table></td></tr>'
			+'<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="">'
			+'<tr class="even"><td class="inquire_item6">采集方式  ：</td><td class="inquire_form6"><input class="input_width" type="text" name="acquisition_mode-'+methodcode+'" id="acquisition_mode-'+methodcode+'" /></td><td class="inquire_item6">工作单元最大闭合时间（小时）：</td><td class="inquire_form6"><input  class="input_width" type="text" name="max_closing_time-'+methodcode+'" id="max_closing_time-'+methodcode+'"  maxlength="50" /></td><td class="inquire_item6">工作单元最大闭合差（10<sup>-5</sup>m/s<sup>2</sup>）：&#0177;</td><td class="inquire_form6"><input  class="input_width" type="text" name="max_closing_difference-'+methodcode+'"  id="max_closing_difference-'+methodcode+'"  maxlength="12" style="IME-MODE: disabled;" onkeyup="if(value.match(/^\\d{8}$/))value=value.replace(value,parseInt(value/10)) ;value=value.replace(/\\.\\d*\\./g,\'\.\')" onKeyPress="if((event.keyCode<48 || event.keyCode>57) && event.keyCode!=46 && event.keyCode!=45 || value.match(/^\\d{8}$/) || /\\.\\d{3}$/.test(value)) {event.returnValue=false}" /></td></tr>'
			+'<tr class="odd"><td class="inquire_item6">精度指标：</td><td class="inquire_form6"><input  class="input_width" type="text" name="gravity_precision_target-'+methodcode+'" id="gravity_precision_target-'+methodcode+'"/></td><td class="inquire_item6"></td><td class="inquire_form6"></td><td class="inquire_item6"></td><td class="inquire_form6"></td></tr>'
			+'</table></td></tr>');
	
		}
		
		else if(workloadMap.get(methodparentcode)=="cl"){
			
			//alert('磁力@@@@@@@@'+methodparentcode);


			$("#tablecl").append('<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height"><tr style="background-color: #97cbfd">'
				+'	<td align="left" width="90%" id="td_well_artillery"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">(磁力)'+methodname+'</font></span><input type="hidden" name="id-'+methodcode+'" id="id-'+methodcode+'" /></td>'
				+'  </tr></table></td></tr>'
			    +'  <tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="">'
		        +'<tr class="even">'
				+'	<td class="inquire_item6">台站控制半径（km）：</td><td class="inquire_form6"><input class="input_width" type="text" name="station_control_radius-'+methodcode+'" id="station_control_radius-'+methodcode+'" onpaste="return false" onfocus="this.style.imeMode=\'disabled\'" onkeypress="return IsNum(event)" maxlength="10" /></td>'
				+'	<td class="inquire_item6">探杆高度（m）：</td><td class="inquire_form6"><input class="input_width" type="text" name="gauging_rod_height-'+methodcode+'" id="gauging_rod_height-'+methodcode+'"  maxlength="12" style="IME-MODE: disabled;" onkeyup="if(value.match(/^\\d{8}$/))value=value.replace(value,parseInt(value/10)) ;value=value.replace(/\\.\\d*\\./g,\'\.\')" onKeyPress="if((event.keyCode<48 || event.keyCode>57) && event.keyCode!=46 && event.keyCode!=45 || value.match(/^\\d{8}$/) || /\\.\\d{3}$/.test(value)) {event.returnValue=false}" /></td>'
				+'	<td class="inquire_item6">精度指标：</td><td class="inquire_form6"><input class="input_width" type="text" name="magnetic_precision_target-'+methodcode+'" id="magnetic_precision_target-'+methodcode+'" /></td>'
				+'</tr>'
				+'</td></table></tr>');
			//<input class="input_width" type="text" name="gauging_rod_height-'+methodcode+'" id="gauging_rod_height-'+methodcode+'"  maxlength="12" style="IME-MODE: disabled;" onkeyup="if(value.match(/^\\d{8}$/))value=value.replace(value,parseInt(value/10)) ;value=value.replace(/\\.\\d*\\./g,\'\.\')" onKeyPress="if((event.keyCode<48 || event.keyCode>57) && event.keyCode!=46 && event.keyCode!=45 || value.match(/^\\d{8}$/) || /\\.\\d{3}$/.test(value)) {event.returnValue=false}" />
			//               <input class='input_width' type="text" name="measuring_line"  id="measuring_line" maxlength="12" style="IME-MODE: disabled;" onkeyup="if(value.match(/^\\d{8}$/))value=value.replace(value,parseInt(value/10)) ;value=value.replace(/\\.\\d*\\./g,\'\.\')" onKeyPress="if((event.keyCode<48 || event.keyCode>57) && event.keyCode!=46 && event.keyCode!=45 || value.match(/^\\d{8}$/) || /\\.\\d{3}$/.test(value)) {event.returnValue=false}" />
		}else if(workloadMap.get(methodparentcode)=="tr"){
			//alert('天然@@@@@@@@'+methodparentcode);
			//<input class="input_width" type="text" name="pole_method-'+methodcode+'" id="pole_method-'+methodcode+'" />
			//<input class="input_width" type="text" name="far_reference_track-'+methodcode+'" id="far_reference_track-'+methodcode+'" />


			$("#tabletr").append('<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height"><tr style="background-color: #97cbfd">'
			+'	<td align="left" width="90%" id="td_well_artillery"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">(天然场源电法)'+methodname+'</font></span><input type="hidden" name="id-'+methodcode+'" id="id-'+methodcode+'" /></td>'
			+'	</tr></table></td></tr>'
			+'<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="">'
			+'	<tr class="even">'
			+'		<td class="inquire_item6">频率范围（Hz）：</td><td class="inquire_form6"><input class="input_width" type="text" name="frequency_range-'+methodcode+'" id="frequency_range-'+methodcode+'" /></td>'
			+'		<td class="inquire_item6">主要布极方式：</td>'
			+'		<td class="inquire_form6">'
			+'   		<select id="pole_method-'+methodcode+'" name="pole_method-'+methodcode+'" ><option value="">--请选择--</option><option value="1">“+”</option><option value="2">“T”</option><option value="3">“L”</option></select>'
			+'		</td>'
			+'		<td class="inquire_item6">观测分量（Ex/Ey/Hx/Hy/Hz）：</td><td class="inquire_form6"><input class="input_width" type="text" name="observational-'+methodcode+'" id="observational-'+methodcode+'" /></td>'
			+'	</tr>'
			+'	<tr class="odd">'
			+'		<td class="inquire_item6">是否采用远参考道：</td>'
			+'		<td class="inquire_form6">'
			+'   		<select name="far_reference_track-'+methodcode+'" id="far_reference_track-'+methodcode+'"  ><option value="">--请选择--</option><option value="1">是</option><option value="2">否</option></select>'
			+'		</td>'
			+'		<td class="inquire_item6">远参考道距离（km）：</td><td class="inquire_form6"><input class="input_width" type="text" name="reference_track_distance-'+methodcode+'" id="reference_track_distance-'+methodcode+'"  maxlength="50" /></td>'
			+'		<td class="inquire_item6">电极距长度范围（m）：</td><td class="inquire_form6"><input class="input_width" type="text" name="electrode_length_range-'+methodcode+'"  id="electrode_length_range-'+methodcode+'" /></td>'
			+'	</tr>'
			+'	<tr class="even">'
			+'		<td class="inquire_item6">磁棒控制范围（km）：</td><td class="inquire_form6"><input class="input_width" type="text" name="magnetic_control_range-'+methodcode+'" id="magnetic_control_range-'+methodcode+'" /></td>'
			+'		<td class="inquire_item6">采集时间范围（h）：</td><td class="inquire_form6"><input class="input_width" type="text" name="acquisition_time_range-'+methodcode+'"  id="acquisition_time_range-'+methodcode+'" /></td>'
			+'		<td class="inquire_item6"></td><td class="inquire_form6"></td>'
			+'	</tr>'
			+'</td></table></tr>');

			//是否用参数
			var ii = "#far_reference_track-"+methodcode;
			var iii = "#reference_track_distance-"+methodcode;
			$(iii).attr("disabled","disabled").css("background", "#ccc");
			$(ii).bind("change",function(){
				if(this.value==2){
					$(iii).attr("disabled","disabled").css("background", "#ccc");
				}else if(this.value==1){
					$(iii).removeAttr("disabled").css("background","#fff");
				}else{
					$(iii).attr("disabled","disabled").css("background", "#ccc");
				}
			});
			

			
	
		}else if(workloadMap.get(methodparentcode)=="ht"){
			//alert('化探@@@@@@@@'+methodparentcode);

			
			$("#tableht").append('<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height"><tr style="background-color: #97cbfd">'
			+'<td align="left" width="90%" id="td_well_artillery"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">(化探)'+methodname+'</font></span><input type="hidden" name="id-'+methodcode+'" id="id-'+methodcode+'" /></td></tr></table></td></tr>'
			+'<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id=""><tr class="even">'
			+'			<td class="inquire_item6">地理化学景观：</td><td class="inquire_form6"><input class="input_width" type="text" name="geochemical_landscape-'+methodcode+'" id="geochemical_landscape-'+methodcode+'" /></td>'
			+'			<td class="inquire_item6">采样深度（m）：</td><td class="inquire_form6"><input class="input_width" type="text" name="sampling_depth-'+methodcode+'" id="sampling_depth-'+methodcode+'" maxlength="12" style="IME-MODE: disabled;" onkeyup="if(value.match(/^\\d{8}$/))value=value.replace(value,parseInt(value/10)) ;value=value.replace(/\\.\\d*\\./g,\'\.\')" onKeyPress="if((event.keyCode<48 || event.keyCode>57) && event.keyCode!=46 && event.keyCode!=45 || value.match(/^\\d{8}$/) || /\\.\\d{3}$/.test(value)) {event.returnValue=false}" /></td>'
			+'			<td class="inquire_item6">土样质量（g）：</td><td class="inquire_form6"><input class="input_width" type="text" name="soil_sample_quality-'+methodcode+'" id="soil_sample_quality-'+methodcode+'" maxlength="12" style="IME-MODE: disabled;" onkeyup="if(value.match(/^\\d{8}$/))value=value.replace(value,parseInt(value/10)) ;value=value.replace(/\\.\\d*\\./g,\'\.\')" onKeyPress="if((event.keyCode<48 || event.keyCode>57) && event.keyCode!=46 && event.keyCode!=45 || value.match(/^\\d{8}$/) || /\\.\\d{3}$/.test(value)) {event.returnValue=false}" /></td>'
			+'</tr><tr class="odd">'
			+'			<td class="inquire_item6">气样量（ml×管）：</td><td class="inquire_form6"><input class="input_width" type="text" name="gas_volume-'+methodcode+'" id="gas_volume-'+methodcode+'" /></td><td class="inquire_item6"></td>'
			+'			<td class="inquire_form6"></td><td class="inquire_item6"></td><td class="inquire_form6"></td>'
			+'</tr></table></td></tr>');
	
		}else if(workloadMap.get(methodparentcode)=="rg"){

			//人工场源动态 项

			//拼表格
			var afobj = jcdpCallService("WtWorkMethodSrv", "getAllWtAfPara","");//   项目以用的探方法 包含父级别勘探方法
			var tdhtml ='<tr class="even">';
			for(var x=0;x<afobj.allwtaf.length;x++){
				var ftype = afobj.allwtaf[x].field_type;//type
				if(x!=0&&x%3==0){
					//另起一行
					if(x%2==0){
						tdhtml+='</tr><tr class="even">';
					}else{
						tdhtml+='</tr><tr class="odd">';
					}
					
				}
				if(ftype==1){
					tdhtml+='<td class="inquire_item6">'+afobj.allwtaf[x].field_name+'</td><td class="inquire_form6"><input class="input_width" type="text" name="para_value-'+methodcode+'-'+afobj.allwtaf[x].id+'" id="para_value-'+methodcode+'-'+afobj.allwtaf[x].id+'" onpaste="return false" onfocus="this.style.imeMode=\'disabled\'" onkeypress="return IsNum(event)" maxlength="10" /></td>';
				}else{
					tdhtml+='<td class="inquire_item6">'+afobj.allwtaf[x].field_name+'</td><td class="inquire_form6"><input class="input_width" type="text" name="para_value-'+methodcode+'-'+afobj.allwtaf[x].id+'" id="para_value-'+methodcode+'-'+afobj.allwtaf[x].id+'" maxlength="50" /></td>';
				}
				
				afStrs.push("para_value-"+methodcode+"-"+afobj.allwtaf[x].id);//人工场源 付值时使用
				
				if(x==(afobj.allwtaf.length-1)){
					if((x+1)%3!=0){
						for(var c=3;c>(x+1)%3;c--){
							tdhtml+='<td class="inquire_item6"></td><td class="inquire_form6"></td>';
						}
					}
				}
				
			}
			tdhtml +='</tr>';

			
			
			$("#tablerg").append('<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height"><tr style="background-color: #97cbfd">'
			+'<td align="left" width="90%" id="td_well_artillery"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">(人工场源电磁法)'+methodname+'</font></span></td></tr></table><td></tr>'
			+'<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" >'+tdhtml+'</table></td></tr>');
		}else if(workloadMap.get(methodparentcode)=="gc"){

			//工程

			
			$("#tableht").append('<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height"><tr style="background-color: #97cbfd">'
			+'<td align="left" width="90%" id="td_well_artillery"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">(工程)'+methodname+'</font></span><input type="hidden" name="id-'+methodcode+'" id="id-'+methodcode+'" /></td></tr></table></td></tr>'
			+'<tr><td><table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id=""><tr class="even">'
			+'			<td  style="text-align:right;width:5%;padding:0 5px;">勘探方法内容：</td><td class="inquire_form6"><textarea name="project_content-'+methodcode+'" id="project_content-'+methodcode+'" rows="4" cols="100" onkeyup=\'value=value.substr(0,1000);this.nextSibling.innerHTML=value.length+"/1000";\'></textarea><div>0/1000</div></td>'
			+'</tr></table></td></tr>');
			
		}


		

		
	}
	////////////////////////////////////2 取所有参数数据        显示勘探方法数据////////////////////////////////////////////////////////
	var retData = jcdpCallService("WtWorkMethodSrv", "getWtWorkMethod",pstr);//勘探方法数据

	if(retData.methodDataList!=null){
	
		for(var i=0;i<retData.methodDataList.length;i++){
			var record = retData.methodDataList[i];
			
			var parentMethodCode = tempMap.get(record.method_code);//取勘探方法类型
			//alert(parentMethodCode);
			//alert(record.method_code);
			
			if(record.method_code==null||record.method_code==""){
				//测量 无勘探方法
				//alert("ddddddddddddddddddddddddddddddd");
				$("#idcl").val(record.id);
				$("#coordinate").val(record.coordinate);
				$("#high_work").val(record.high_work);
				$("#shadow_method").val(record.shadow_method);
				$("#observe_method").val(record.observe_method);
				$("#static_observe_method").val(record.static_observe_method);
				$("#rtk").val(record.rtk);
				$("#center_control_radius").val(record.center_control_radius);
				$("#measuring_line").val(record.measuring_line);
				$("#measure_precision_target").val(record.measure_precision_target);
				$("#quality_target").val(record.quality_target);
				
			}else if(workloadMap.get(parentMethodCode)=="zl"){
				//给指定的勘探方法初始化数据
				//alert(record.acquisition_mode);
				$("#id-"+record.method_code).val(record.id);
				$("#acquisition_mode-"+record.method_code).val(record.acquisition_mode);
				$("#max_closing_time-"+record.method_code).val(record.max_closing_time);
				$("#max_closing_difference-"+record.method_code).val(record.max_closing_difference);
				$("#gravity_precision_target-"+record.method_code).val(record.gravity_precision_target);
				
			}else if(workloadMap.get(parentMethodCode)=="cl"){
				
				$("#id-"+record.method_code).val(record.id);
				$("#station_control_radius-"+record.method_code).val(record.station_control_radius);
				$("#gauging_rod_height-"+record.method_code).val(record.gauging_rod_height);
				$("#magnetic_precision_target-"+record.method_code).val(record.magnetic_precision_target);
				
			}else if(workloadMap.get(parentMethodCode)=="tr"){
				//alert('天然@@@@@@@@'+methodparentcode);
	
				$("#id-"+record.method_code).val(record.id);
				$("#frequency_range-"+record.method_code).val(record.frequency_range);
				$("#pole_method-"+record.method_code).val(record.pole_method);
				$("#observational-"+record.method_code).val(record.observational);
				$("#far_reference_track-"+record.method_code).val(record.far_reference_track);
				$("#reference_track_distance-"+record.method_code).val(record.reference_track_distance);
				$("#electrode_length_range-"+record.method_code).val(record.electrode_length_range);
				$("#magnetic_control_range-"+record.method_code).val(record.magnetic_control_range);
				$("#frequency_range-"+record.method_code).val(record.frequency_range);
				$("#acquisition_time_range-"+record.method_code).val(record.acquisition_time_range);
	
				//是否用参数
				var ii = "#far_reference_track-"+record.method_code;
				var iii = "#reference_track_distance-"+record.method_code;
				var iiv = $(ii).val();
				if(iiv==2){
					$(iii).attr("disabled","disabled").css("background", "#ccc");
				}else if(iiv==1){
					$(iii).removeAttr("disabled").css("background","#fff");
				}else{
					$(iii).attr("disabled","disabled").css("background", "#ccc");
				}
	
				
	
			}else if(workloadMap.get(parentMethodCode)=="ht"){
	
				$("#id-"+record.method_code).val(record.id);
				$("#geochemical_landscape-"+record.method_code).val(record.geochemical_landscape);
				$("#sampling_depth-"+record.method_code).val(record.sampling_depth);
				$("#soil_sample_quality-"+record.method_code).val(record.soil_sample_quality);
				$("#gas_volume-"+record.method_code).val(record.gas_volume);
		
			}else if(workloadMap.get(parentMethodCode)=="gc"){
	
				$("#id-"+record.method_code).val(record.id);
				$("#project_content-"+record.method_code).val(record.project_content);
				
		
			}
		}
	}

	//人工场源数据
	if(retData.afRsMap!=null){
		
		for(var d=0;d<afStrs.length;d++){
			if (typeof($("#"+afStrs[d])) != "undefined")
			{
				
			    $("#"+afStrs[d]).val(retData.afRsMap[afStrs[d]]);
			}
		}
	}

	if(action!=null&&action=="view"){
	    setReadOnly();
		//parent.document.all("if5").style.height=document.body.scrollHeight; 
		//parent.document.all("if5").style.width=document.body.scrollWidth; 
	}

	

	
}



function getsh(){
	
	//alert(document.body.scrollHeight);
	parent.document.all("technicalparameteriframe").height=document.body.scrollHeight; 
	parent.document.all("technicalparameteriframe").width=document.body.scrollWidth; 
	 

}

function IsNum(e) {
    var k = window.event ? e.keyCode : e.which;
    if (((k >= 48) && (k <= 57)) || k == 8 || k == 0) {
    } else {
        if (window.event) {
            window.event.returnValue = false;
        }
        else {
            e.preventDefault(); //for firefox 
        }
    }
} 
function checkvalue(){
	
	$("#tablecel :input[type='text']").each(function(i){
	   if(this.name=="coordinate"){
	   }
	});
	
       
    
}
function toSave(){
    //if(checkvalue()==false){
      //  return;
    //}
	var form = document.form1;
	form.action="<%=contextPath%>/wt/tm/parameter/saveWtWorkMethod.srq";
	form.submit();
	

}

function setReadOnly(){
	$(":input").each(function(){
		$(this).attr("readonly",true); 
	})
}

//保存结果提示
var saveResult = "<%=saveResult%>";
if(saveResult!=null&&saveResult=="1"){
	alert("保存成功");
}

</script>
</head>
<body onresize="getsh();" onload="loadData()" style="overflow-y: auto; background: #fff;">
<form id="form1" name="form1" action="" method="post">	


<table border="0" cellpadding="0" cellspacing="0" width="100%" id="table1">
	<tr>
		<td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%"
			class="tab_line_height">
			<tr style="background-color: #97cbfd">
				<td id="clzlpara" align="left" width="90%"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">测量设计参数<input type="hidden" id="idcl" name="idcl" /></font></span><td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="tablecel">
			<tr class="even">
				<td class="inquire_item6">坐标系：</td>
				<td class="inquire_form6">
					<input class='input_width' type="text" name="coordinate" id="coordinate" maxlength="50" />
				</td>
				<td class="inquire_item6">高程系：</td>
				<td class="inquire_form6">
					<input class='input_width'  type="text" name="high_work" id="high_work" />
				</td>
				<td class="inquire_item6">投影方式：</td>
				<td class="inquire_form6">
					<input class='input_width' type="text" name="shadow_method" id="shadow_method" />
				</td>
			</tr>
			<tr class="odd">
				<td class="inquire_item6">观测方式：</td>
				<td class="inquire_form6">
					<input class='input_width' type="text" name="observe_method" id="observe_method" />
				</td>
				<td class="inquire_item6">快速静态观测时间（min）：</td>
				<td class="inquire_form6">
					<input class='input_width' type="text" name="static_observe_method" id="static_observe_method" onpaste="return false" onfocus="this.style.imeMode='disabled'" onkeypress="return IsNum(event)" maxlength="10"/>
				</td>
				<td class="inquire_item6">RTK采集历元（个）：</td>
				<td class="inquire_form6">
					<input class='input_width' type="text" name="rtk" id="rtk" onpaste="return false" onfocus="this.style.imeMode='disabled'" onkeypress="return IsNum(event)" maxlength="10" />
				</td>
			</tr>
			<tr class="even">
				<td class="inquire_item6">中心站控制半径（km）：</td>
				<td class="inquire_form6">
					<input class='input_width' type="text" name="center_control_radius"  id="center_control_radius" onpaste="return false" onfocus="this.style.imeMode='disabled'" onkeypress="return IsNum(event)" maxlength="10" />
				</td>
				<td class="inquire_item6">测线方位（°）：</td>
				<td class="inquire_form6">
				
					 <input class='input_width' type="text" name="measuring_line"  id="measuring_line" maxlength="12" style="IME-MODE: disabled;" onkeyup="if(value.match(/^\d{8}$/))value=value.replace(value,parseInt(value/10)) ;value=value.replace(/\.\d*\./g,'.')" onKeyPress="if((event.keyCode<48 || event.keyCode>57) && event.keyCode!=46 && event.keyCode!=45 || value.match(/^\d{8}$/) || /\.\d{3}$/.test(value)) {event.returnValue=false}" />
				</td>
				<td class="inquire_item6">精度指标：</td>
				<td class="inquire_form6">
					<input class='input_width' type="text" name="measure_precision_target"  id="measure_precision_target"  />
				</td>
			</tr>
			<tr class="odd">
				<td class="inquire_item6">测量质量指标：</td>
				<td class="inquire_form6">
					<input class='input_width' type="text" name="quality_target"  id="quality_target" />
				</td>
				<td class="inquire_item6"></td>
				<td class="inquire_form6">
				</td>
				<td class="inquire_item6"></td>
				<td class="inquire_form6">
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>



<table border="0" cellpadding="0" cellspacing="0" width="100%"
	id="tablezl">

</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%"
	id="tablecl">

</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%"
	id="tabletr">

</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%"
	id="tableht">

</table>


<table border="0" cellpadding="0" cellspacing="0" width="100%"
	id="tablerg">
	
</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%"
	id="tablegc">
	
</table>


<div id="oper_div">
<%
	if (action != "view" && !"view".equals(action)) {
%> 
<span class="tj_btn"><a href="#" onclick="toSave()"></a></span> 
<%
 	}
%>
</div>
</form>
</body>
</html>

