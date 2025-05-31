<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	

	//保存结果 1 保存成功
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String saveResult = null;
	if(respMsg!=null&&respMsg.getValue("saveResult") != null){
		saveResult = respMsg.getValue("saveResult");
	}

    String contextPath = request.getContextPath();
    UserToken user = OMSMVCUtil.getUserToken(request);
    String projectType = user.getProjectType();
    String projectInfoNo = request.getParameter("projectInfoNo");
    String buildMethod = request.getParameter("buildmethod");
   
    String action = request.getParameter("action");
   	if(action == null || "".equals(action)){
   		action = "";
   	}
    
	if(projectInfoNo == null || "".equals(projectInfoNo)){
		projectInfoNo = user.getProjectInfoNo();
	}
    String projectName = user.getProjectName();
    
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>施工方法</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript">



<%-- 
5000100003000000001井炮2
5000100003000000002 震源3
5000100003000000003气枪 4
5000100003000000010井下扫描源 5
5000100003000000011井下脉冲源6
--%>




//var buildMethods =  ['5000100003000000001','5000100003000000002','5000100003000000010','5000100003000000011'];


//alert("nnnnnnnnnjjjjjjjjjjjjjjjzzzzzzzzzzzzzz");

var action = "<%=action%>";
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
var projectType="<%=projectType%>"; 
var project_info_no = "<%=projectInfoNo%>";
var buildMethod = "<%=buildMethod%>";
var buildMethods = new Array();//取得施工方法
var querySql = "select t.build_method from gp_task_project t where t.project_info_no='"+project_info_no+"'";
var queryOrgRet = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+querySql);
if(queryOrgRet.datas[0]){
	var build_method = queryOrgRet.datas[0].build_method ; 
	if(build_method!=""){
		var bm = build_method.split(',');
		for(var i=0;i<bm.length;i++){
			buildMethods.push(bm[i]);
		}
	}
}




var layoutRows = 1;//观测系统
var spRows = 1;//井炮
var sourceRows = 1;//震源
var aigGunRows = 1;//气枪
var scanSourceRows = 1;//井下扫描源
var pulseSourceRows = 1;//井下脉冲源
var acceptParaRows = 1;//接收参数
var instrumentParaRows = 1;//仪器参数
var positionImageRows = 1;//测线平面位置图

var layoutIndex = 0;//观测系统
var wellArtilleryIndex = 0;//井炮
var sourceIndex = 0;//震源
var aigGunIndex = 0;//气枪
var scanSourceIndex = 0;//井下扫描源
var pulseSourceIndex = 0;//井下脉冲源
var acceptParaIndex = 0;//接收参数
var instrumentParaIndex = 0;//仪器参数
var positionImageIndex = 0;//测线平面位置图



function loadData(){
	//默认添加一行数据
	toAddLayout();
	toAddAcceptPara();//接收参数
	toAddInstrumentPara();//仪器参数
	toAddPositionImage();//测线平面位置图

	// 取所有数据
	var retObj = jcdpCallService("WsWorkMethodSrv", "getWsWorkMethod", "projectInfoNo="+project_info_no+"&reallyType=0");
	var layoutData = retObj.layoutData;
	var wellArtilleryData = retObj.wellArtilleryData;
	var quakeSourceData = retObj.quakeSourceData;
	var airGunData = retObj.airGunData;
	var scanSourceData = retObj.scanSourceData;
	var pulseSourceData = retObj.pulseSourceData;
	var acceptParaData = retObj.acceptParaData;
	var instrumentParaData = retObj.instrumentParaData;
	var positionImageData = retObj.positionImageData;
	
	
	
	
	// 加载观测系统段数据
	if(layoutData != null){
		for(var i=0;i<layoutData.length;i++){
			var record = layoutData[i];
			if(i==0){
				//初始第一行数据
				setLayoutData(record,1);
			}else{
				toAddLayout();
				var rowIndex = layoutRows - 1;
				setLayoutData(record, rowIndex);
			}
		}
	}

	document.getElementById("table2").style.display = "none";
	document.getElementById("table3").style.display = "none";
	document.getElementById("table4").style.display = "none";
	document.getElementById("table5").style.display = "none";
	document.getElementById("table6").style.display = "none";
	
	//施工方法
	for(var bi=0;bi<buildMethods.length;bi++){
		if(buildMethods[bi]=="5000100003000000001"){
			document.getElementById("table2").style.display = "block";
			toAddWellArtillery();//激发参数井炮2
			
			//加载井炮数据
			if(wellArtilleryData!=null){
				for(var i=0;i<wellArtilleryData.length;i++){
					var record = wellArtilleryData[i];
					if(i==0){
						//初始第一行数据
						setWellArtilleryData(record,1);
					}else{
						toAddWellArtillery();
						var rowIndex = spRows - 1;
						setWellArtilleryData(record, rowIndex);
					}
				}
			}
			
		}else if(buildMethods[bi]=="5000100003000000002"){
			document.getElementById("table3").style.display = "block";
			toAddQuakeSource(); //震源3
			
			//加载震源数据
			if(quakeSourceData!=null){
				for(var i=0;i<quakeSourceData.length;i++){
					var record = quakeSourceData[i];
					if(i==0){
						//初始第一行数据
						setQuakeSourceData(record,1);
					}else{
						toAddQuakeSource();
						var rowIndex = sourceRows - 1;
						setQuakeSourceData(record, rowIndex);
					}
				}
			}
		}else if(buildMethods[bi]=="5000100003000000003"){
			document.getElementById("table4").style.display = "block";
			toAddAirGun(); //气枪4
			//加载气枪数据
			if(airGunData!=null){
				for(var i=0;i<airGunData.length;i++){
					var record = airGunData[i];
					if(i==0){
						//初始第一行数据
						setAirGunData(record,1);
					}else{
						toAddAirGun();
						var rowIndex = aigGunRows - 1;
						setAirGunData(record, rowIndex);
					}
				}
			}
		}else if(buildMethods[bi]=="5000100003000000010"){
			document.getElementById("table5").style.display = "block";
			toAddScanSource(); //井下扫描源5
			
			//加载井下扫描源数据
			if(scanSourceData!=null){
				for(var i=0;i<scanSourceData.length;i++){
					var record = scanSourceData[i];
					if(i==0){
						//初始第一行数据
						setScanSourceData(record,1);
					}else{
						toAddScanSource();
						var rowIndex = scanSourceRows - 1;
						setScanSourceData(record, rowIndex);
					}
				}
			}
		}else if(buildMethods[bi]=="5000100003000000011"){
			document.getElementById("table6").style.display = "block";
			toAddPulseSource(); //井下脉冲源6
			//加载井下脉冲源数据
			if(pulseSourceData!=null){
				for(var i=0;i<pulseSourceData.length;i++){
					var record = pulseSourceData[i];
					if(i==0){
						//初始第一行数据
						setPulseSourceData(record,1);
					}else{
						toAddPulseSource();
						var rowIndex = pulseSourceRows - 1;
						setPulseSourceData(record, rowIndex);
					}
				}
			}
		}
	}
	
	//加载接收参数数据
	if(acceptParaData !=null){
		for(var i=0;i<acceptParaData.length;i++){
			var record = acceptParaData[i];
			if(i==0){
				//初始第一行数据
				setAcceptParaData(record,1);
			}else{
				toAddAcceptPara();
				var rowIndex = acceptParaRows - 1;
				setAcceptParaData(record, rowIndex);
			}
		}
	}

	//加载仪器参数数据
	if(instrumentParaData!=null){
		for(var i=0;i<instrumentParaData.length;i++){
			var record = instrumentParaData[i];
			if(i==0){
				//初始第一行数据
				setInstrumentParaData(record,1);
			}else{
				toAddInstrumentPara();
				var rowIndex = instrumentParaRows - 1;
				setInstrumentParaData(record, rowIndex);
			}
		}
	}
	//加载测线平面位置图数据
	if(positionImageData!=null){
		for(var i=0;i<positionImageData.length;i++){
			var record = positionImageData[i];
			if(i==0){
				//初始第一行数据
				setPositionImageData(record,1);
			}else{
				toAddPositionImage();
				var rowIndex = positionImageRows - 1;
				setPositionImageData(record, rowIndex);
			}
		}
	}
	if(action!=null&&action=="view"){
	    setReadOnly();
		parent.document.all("if5").style.height=document.body.scrollHeight; 
		parent.document.all("if5").style.width=document.body.scrollWidth; 
	}

	
	
	

}

function checkForm(){
	var form = document.forms[0];
}

function on_key_press_str(obj)
{
	var keycode = event.keyCode;
	
	if(keycode > 57 || keycode <= 46 || keycode==47)
	{
		return true;
	}
}
	
function on_key_press_int(obj)
{
	var keycode = event.keyCode;
	if(keycode > 57 || keycode < 46 || keycode==47)
	{
		return false;
	}else{
		return true;
	}
}
//////////////////////////////////js check//////////////////////////////////////////////
//判断小数
function checkNumById(titleName,input_num_id){
	if(document.getElementById(input_num_id)){
		var str = document.getElementById(input_num_id).value;
		if(str!=""){
			return checkNum(titleName,str);
		}
	}
	//1未定义的元素不验证 2为空数据不验证
	return true;
	
	
}
function checkNum(titleName,str){
	if(str!=""){
		var pattern =/^[0-9]{1,9}([.]\d{1,3})?$/;
		if(!pattern.exec(str)){
			alert(titleName+" : 请输入数字(例:0.000),最高保留三位小数");
			return false;
		}else{
			return true;
		}
	}
}
//校验字符长度
function checkLengthById(titleName,input_num_id){
	
	if(document.getElementById(input_num_id)){
		var str = document.getElementById(input_num_id).value;
		if(str!=""){
			if(str.length<26)
				return true;
			alert(titleName+" : 字符长度不能超过25个");
			return false;
		}
	}
	//1未定义的元素不验证 2为空数据不验证
	return true;
	
}
//校验必输项
function checkNullById(titleName,input_num_id){
	
	if(document.getElementById(input_num_id)){
		var str = document.getElementById(input_num_id).value;
		if(str==""){
			alert(titleName+" : 此项为必填项");
			return false;
		}else{
			if(str.length<26)
				return true;
			alert(titleName+" : 字符长度不能超过25个");
			return false;
		}
	}
	//1未定义的元素不验证 2为空数据不验证
	return true;
	
}
///////////////////////////////////////////////////////////////////
function toSave(){
	//验证
	//观测系统
	for(var i=1; i<layoutRows; i++){
		var lineNum = i;
		if(!checkNumById("子波X坐标"+lineNum,"wave_x_"+lineNum))return;
		if(!checkNumById("子波坐标Y"+lineNum,"wave_y" + "_"+lineNum))return;
		if(!checkNumById("子波坐标Z"+lineNum,"wave_z" + "_"+lineNum))return;
		if(!checkNumById("总炮数"+lineNum,"artillery_total" + "_"+lineNum))return;
		if(!checkNumById("炮点面积"+lineNum,"artillery_area" + "_"+lineNum))return;
		if(!checkNumById("最大偏移距"+lineNum,"max_offset" + "_"+lineNum))return;
		if(!checkNumById("炮点距"+lineNum,"artillery_point" + "_"+lineNum))return;
		if(!checkNumById("观测点距"+lineNum,"observe_point" + "_"+lineNum))return;
		if(!checkNumById("观测起始深度"+lineNum,"observe_begin_depth" + "_"+lineNum))return;
		if(!checkNumById("观测结束深度"+lineNum,"observe_end_depth" + "_"+lineNum))return;
		if(!checkNumById("观测级数"+lineNum,"observe_level" + "_"+lineNum))return;
		if(!checkNumById("观测物理点数"+lineNum,"observe_physical_point" + "_"+lineNum))return;
	}
	//井炮
	for(var i=1; i<spRows; i++){
		var lineNum = i;
		if(!checkLengthById("井深"+lineNum,"well_total_depth" + "_"+lineNum))return;
		if(!checkLengthById("药量"+lineNum,"drug_quantity" + "_"+lineNum))return;
	}
	//震源
	for(var i=1; i<sourceRows; i++){
		var lineNum = i;
		if(!checkNullById("震源型号"+lineNum,'quake_type_'+lineNum))return;
		if(!checkLengthById("震源箱体"+lineNum,'quake_box_'+lineNum))return;
		if(!checkNumById("震源台数"+lineNum,'quake_machine_num_'+lineNum))return;
		if(!checkNumById("震动次数"+lineNum,'quake_num_'+lineNum))return;
		if(!checkLengthById("震源组合方向"+lineNum,'quake_direction_'+lineNum))return;
		if(!checkNumById("震源组合基距"+lineNum,'quake_cardinal_distance_'+lineNum))return;
		if(!checkLengthById("扫描类型"+lineNum,'scan_type_'+lineNum))return;
		if(!checkNumById("频率补偿"+lineNum,'frequency_compensation_'+lineNum))return;
		if(!checkNumById("扫描起始频率"+lineNum,'begin_frequency_'+lineNum))return;
		if(!checkNumById("扫描终了频率"+lineNum,'end_frequency_'+lineNum))return;
		if(!checkNumById("扫描长度"+lineNum,'scan_length_'+lineNum))return;
		if(!checkNumById("驱动幅度"+lineNum,'driving_scope_'+lineNum))return;
		if(!checkNumById("起止斜坡"+lineNum,'start_stop_slope_'+lineNum))return;
		if(!checkNumById("滑动扫描时间"+lineNum,'slide_scan_time_'+lineNum))return;
		
	}
	//气枪
	for(var i=1; i<aigGunRows; i++){
		var lineNum = i;
		if(!checkNullById("气枪震源型号"+lineNum,'air_gun_type_'+lineNum))return;
		if(!checkNumById("总容量"+lineNum,'volume_total_'+lineNum))return;
		if(!checkNumById("气枪压力"+lineNum,'air_gun_pressure_'+lineNum))return;
		if(!checkNumById("枪数"+lineNum,'gun_num_'+lineNum))return;
		if(!checkNumById("峰-峰值"+lineNum,'peak_value_'+lineNum))return;
		if(!checkNumById("气泡比"+lineNum,'bubble_ratio_'+lineNum))return;
		if(!checkNumById("频宽"+lineNum,'bandwidth_'+lineNum))return;
		if(!checkNumById("阵列长度"+lineNum,'array_length_'+lineNum))return;

	}
	//井下扫描源
	for(var i=1; i<scanSourceRows; i++){
		var lineNum = i;
		if(!checkNullById("震源类型"+lineNum,'scan_quake_type_'+lineNum))return;
		if(!checkNumById("震源能量"+lineNum,'scan_quake_power_'+lineNum))return;
		if(!checkNumById("震动次数"+lineNum,'scan_quake_num_'+lineNum))return;
		if(!checkLengthById("扫描类型"+lineNum,'source_scan_type_'+lineNum))return;
		if(!checkNumById("扫描起始频率"+lineNum,'scan_begin_frequency_'+lineNum))return;
		if(!checkNumById("扫描终止频率"+lineNum,'scan_end_frequency_'+lineNum))return;
		if(!checkNumById("扫描长度"+lineNum,'source_scan_length_'+lineNum))return;
				

				
	}
	//井下脉冲源
	for(var i=1; i<pulseSourceRows; i++){
		var lineNum = i;
		if(!checkNullById("震源类型"+lineNum,'pulse_quake_type_'+lineNum))return;
		if(!checkNumById("震源能量"+lineNum,'pulse_quake_power_'+lineNum))return;
				
				
	}
	//接收参数
	for(var i=1; i<acceptParaRows; i++){
		var lineNum = i;
		if(!checkNullById("井下仪器型号"+lineNum,'well_instrument_model_'+lineNum))return;
		if(!checkLengthById("井下仪器类型"+lineNum,'well_instrument_type_'+lineNum))return;
		if(!checkLengthById("检波器分量"+lineNum,'demodulator_component_product_'+lineNum))return;	
		if(!checkLengthById("推靠类型"+lineNum,'pushed_type_'+lineNum))return;
	}
	//仪器参数
	for(var i=1; i<instrumentParaRows; i++){
		var lineNum = i;
		if(!checkNullById("仪器型号"+lineNum,'instrument_type_'+lineNum))return;
		//if(!checkNumById(""+lineNum,'well_instrument_type_'+lineNum))return;
		if(!checkNumById("井下仪器级数"+lineNum,'well_instrument_level_'+lineNum))return;
		if(!checkLengthById("井下仪器间距"+lineNum,'well_instrument_distance_'+lineNum))return;
		if(!checkNumById("记录长度"+lineNum,'record_length_'+lineNum))return;
		if(!checkNumById("采样间隔"+lineNum,'sampling_interval_'+lineNum))return;
		if(!checkLengthById("滤波类型"+lineNum,'filtering_type_'+lineNum))return;
		if(!checkNumById("滤波参数"+lineNum,'filtering_para_'+lineNum))return;
		if(!checkNumById("高截频率"+lineNum,'high_frequency_'+lineNum))return;
		if(!checkNumById("低截频率"+lineNum,'low_frequency_'+lineNum))return;
		if(!checkNumById("前放增益"+lineNum,'preamp_gain_'+lineNum))return;
		
	}
	//测线平面位置图
	for(var i=1; i<positionImageRows; i++){
		var lineNum = i;
		if(!checkLengthById("观测系统"+lineNum,'observation_system_'+lineNum))return;
		//if(!checkLengthById(""+lineNum,'mapping_images_'+lineNum))return;
		
	}
	

	
	var form = document.getElementById('CheckForm');

	//拼已选择的施工方法类型记录条数 
	form.action="<%=contextPath%>/ws/pm/plan/singlePlan/projectSchedule/saveWsWorkMethod.srq?reallyType=0&layoutnum="+layoutIndex;
	for(var bi=0;bi<buildMethods.length;bi++){
		if(buildMethods[bi]=="5000100003000000001"){
			form.action+="&wellArtilleryIndex="+wellArtilleryIndex;
		}else if(buildMethods[bi]=="5000100003000000002"){
			form.action+="&sourceIndex="+sourceIndex;
		}else if(buildMethods[bi]=="5000100003000000003"){
			form.action+="&aigGunIndex="+aigGunIndex;
		}else if(buildMethods[bi]=="5000100003000000010"){
			form.action+="&scanSourceIndex="+scanSourceIndex;
		}else if(buildMethods[bi]=="5000100003000000011"){
			form.action+="&pulseSourceIndex="+pulseSourceIndex;
		}
	}

	form.action+="&acceptParaIndex="+acceptParaIndex+"&instrumentParaIndex="+instrumentParaIndex+"&positionImageIndex="+positionImageIndex;
	form.submit();

}

function frameSize(){
	setTabBoxHeight();
}
frameSize();
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})
//观测系统
function setLayoutData(record, lineNum){
	document.getElementById("layoutid" + "_"+lineNum).value = record.id;
	document.getElementById("wave_x" + "_"+lineNum).value = record.wave_x;
	document.getElementById("wave_y" + "_"+lineNum).value = record.wave_y;
	document.getElementById("wave_z" + "_"+lineNum).value = record.wave_z;
	document.getElementById("artillery_total" + "_"+lineNum).value = record.artillery_total;
	document.getElementById("artillery_area" + "_"+lineNum).value = record.artillery_area;
	document.getElementById("max_offset" + "_"+lineNum).value = record.max_offset;
	document.getElementById("artillery_point" + "_"+lineNum).value = record.artillery_point;
	document.getElementById("observe_point" + "_"+lineNum).value = record.observe_point;
	document.getElementById("observe_begin_depth" + "_"+lineNum).value = record.observe_begin_depth;
	document.getElementById("observe_end_depth" + "_"+lineNum).value = record.observe_end_depth;
	document.getElementById("observe_level" + "_"+lineNum).value = record.observe_level;
	document.getElementById("observe_physical_point" + "_"+lineNum).value = record.observe_physical_point;
	document.getElementById("artillery_file" + "_"+lineNum).value = record.artillery_file;
	if(record.artillery_file!=null)
	document.getElementById("td_artillery_file" + lineNum).innerHTML+= "&nbsp;<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+record.artillery_file+"&emflag=0>下载</a>";
	
	
}
//井炮
function setWellArtilleryData(record, lineNum){
	//document.getElementById("method2_no" + "_"+lineNum).value = record.wa2d_no;
	document.getElementById("well_total_depth" + "_"+lineNum).value = record.well_total_depth;
	document.getElementById("drug_quantity" + "_"+lineNum).value = record.drug_quantity;
	document.getElementById("drug_type" + "_"+lineNum).value = record.drug_type;
}
//震源
function setQuakeSourceData(record, lineNum){
	//document.getElementById("method3_no" + "_"+lineNum).value = record.wa2d_no;
	document.getElementById('quake_type_'+lineNum).value = record.quake_type;
	document.getElementById('quake_box_'+lineNum).value = record.quake_box;
	document.getElementById('quake_machine_num_'+lineNum).value = record.quake_machine_num;
	document.getElementById('quake_num_'+lineNum).value = record.quake_num;
	document.getElementById('quake_direction_'+lineNum).value = record.quake_direction;
	document.getElementById('quake_cardinal_distance_'+lineNum).value = record.quake_cardinal_distance;
	document.getElementById('scan_type_'+lineNum).value = record.scan_type;
	document.getElementById('frequency_compensation_'+lineNum).value = record.frequency_compensation;
	document.getElementById('begin_frequency_'+lineNum).value = record.begin_frequency;
	document.getElementById('end_frequency_'+lineNum).value = record.end_frequency;
	document.getElementById('scan_length_'+lineNum).value = record.scan_length;
	document.getElementById('driving_scope_'+lineNum).value = record.driving_scope;
	document.getElementById('start_stop_slope_'+lineNum).value = record.start_stop_slope;
	document.getElementById('slide_scan_time_'+lineNum).value = record.slide_scan_time;
}


//气枪
function setAirGunData(record, lineNum){

	document.getElementById('air_gun_type_'+lineNum).value = record.air_gun_type;
	document.getElementById('volume_total_'+lineNum).value = record.volume_total;
	document.getElementById('air_gun_pressure_'+lineNum).value = record.air_gun_pressure;
	document.getElementById('gun_num_'+lineNum).value = record.gun_num;
	document.getElementById('peak_value_'+lineNum).value = record.peak_value;
	document.getElementById('bubble_ratio_'+lineNum).value = record.bubble_ratio;
	document.getElementById('bandwidth_'+lineNum).value = record.bandwidth;
	document.getElementById('array_length_'+lineNum).value = record.array_length;
	
}

//井下扫描源5
function setScanSourceData(record, lineNum){
	
	document.getElementById('scan_quake_type_'+lineNum).value = record.scan_quake_type;
	document.getElementById('scan_quake_power_'+lineNum).value = record.scan_quake_power;
	document.getElementById('scan_quake_num_'+lineNum).value = record.scan_quake_num;
	document.getElementById('source_scan_type_'+lineNum).value = record.source_scan_type;
	document.getElementById('scan_begin_frequency_'+lineNum).value = record.scan_begin_frequency;
	document.getElementById('scan_end_frequency_'+lineNum).value = record.scan_end_frequency;
	document.getElementById('source_scan_length_'+lineNum).value = record.source_scan_length;
	
}
//井下脉冲源6
function setPulseSourceData(record, lineNum){
	document.getElementById('pulse_quake_type_'+lineNum).value = record.pulse_quake_type;
	document.getElementById('pulse_quake_power_'+lineNum).value = record.pulse_quake_power;
}
//接收参数
function setAcceptParaData(record, lineNum){
	document.getElementById('well_instrument_model_'+lineNum).value = record.well_instrument_model;
	document.getElementById('well_instrument_type_'+lineNum).value = record.well_instrument_type;
	document.getElementById('demodulator_component_product_'+lineNum).value = record.demodulator_component_product;	
	document.getElementById('pushed_type_'+lineNum).value = record.pushed_type;	
}
//仪器参数
function setInstrumentParaData(record, lineNum){

	document.getElementById('instrument_type_'+lineNum).value = record.instrument_type;
	//document.getElementById('well_instrument_type_'+lineNum).value = record.well_instrument_type;
	document.getElementById('well_instrument_level_'+lineNum).value = record.well_instrument_level;
	document.getElementById('well_instrument_distance_'+lineNum).value = record.well_instrument_distance;
	document.getElementById('record_length_'+lineNum).value = record.record_length;
	document.getElementById('sampling_interval_'+lineNum).value = record.sampling_interval;
	document.getElementById('filtering_type_'+lineNum).value = record.filtering_type;
	document.getElementById('filtering_para_'+lineNum).value = record.filtering_para;
	document.getElementById('high_frequency_'+lineNum).value = record.high_frequency;
	document.getElementById('low_frequency_'+lineNum).value = record.low_frequency;
	document.getElementById('preamp_gain_'+lineNum).value = record.preamp_gain;
	
}
//测线平面位置图
function setPositionImageData(record, lineNum){
	document.getElementById('observation_system_'+lineNum).value = record.observation_system;
	document.getElementById('mapping_images_'+lineNum).value = record.mapping_images;
	if(record.mapping_images!=null)
		document.getElementById("td_mapping_images" + lineNum).innerHTML+= "&nbsp;<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+record.mapping_images+"&emflag=0>下载</a>";
	
}

var   viewTr='';
if(projectType !="5000100004000000008" ){
	viewTr=' <tr class="odd" >'	;
	}else{
	 viewTr=' <tr class="odd" style="display:none" >'	
	}


//观测系统
function toAddLayout(){
	layoutIndex++;
	var tr = document.getElementById("trLayout_"+layoutIndex);
	if(tr != null){
		document.getElementById("trLayout_hr_"+layoutIndex).style.display = "block";
		document.getElementById("trLayout_"+layoutIndex).style.display = "block";
		return;
	}
	var rowNum = layoutRows;
	
	if(rowNum > 1){
		//新增一行 复制上一行数据
		var preRowNum = parseInt(rowNum) - 1;
		            
		//var pre_method1_no = document.getElementById('method1_no_'+preRowNum).value;
		var wave_x = document.getElementById('wave_x_'+preRowNum).value;
		var wave_y = document.getElementById('wave_y_'+preRowNum).value;
		var wave_z = document.getElementById('wave_z_'+preRowNum).value;
		//var artillery_file = document.getElementById('artillery_file_'+preRowNum).value;//不复制炮点文件
		var artillery_total = document.getElementById('artillery_total_'+preRowNum).value;
		var artillery_area = document.getElementById('artillery_area_'+preRowNum).value;
		var max_offset = document.getElementById('max_offset_'+preRowNum).value;
		var artillery_point = document.getElementById('artillery_point_'+preRowNum).value;
		var observe_point = document.getElementById('observe_point_'+preRowNum).value;
		var observe_begin_depth = document.getElementById('observe_begin_depth_'+preRowNum).value;
		var observe_end_depth = document.getElementById('observe_end_depth_'+preRowNum).value;
		var observe_level = document.getElementById('observe_level_'+preRowNum).value;
		var observe_physical_point = document.getElementById('observe_physical_point_'+preRowNum).value;

		
		layoutRows++;
		var tr = document.getElementById("table1").insertRow();
		tr.id = "trLayout_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table1").insertRow();
		tr.id = "trLayout_" + rowNum;
	

		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="layout_table_'+layoutIndex+'">'
					+viewTr
		
					+'   <td class="inquire_item6">子波X坐标：</td>' 
					+'   <td class="inquire_form6">'
					+'     <input id="layoutid' + '_' + rowNum+'" name="layoutid' + '_' + rowNum+'" type="hidden" value=""/>'
					+'     <input id="bsflag1' + '_' + rowNum+'" type="hidden" value="0"/>'
					+'     <input id="wave_x'+'_' + rowNum+'" name="wave_x'+'_' + rowNum+'" type="text" value="'+wave_x+'"  class="input_width"/>'
					+'   </td>'
					+'   <td class="inquire_item6">子波Y坐标：</td>'
	    			+'   <td class="inquire_form6">'
	    			+'     <input id="wave_y' + '_' + rowNum+'" name="wave_y' + '_' + rowNum+'" type="text" value="'+wave_y+'" class="input_width" style="margin-top:4px;"/><div></div>'
	    			+'   </td>'
					+'   <td class="inquire_item6">子波Z坐标：</td>'
					+'   <td class="inquire_form6">'
					+'     <input id="wave_z' + '_' + rowNum+'" name="wave_z' + '_' + rowNum+'" type="text" value="'+wave_z+'" class="input_width" style="margin-top:4px;"/><div></div>'
					+'   </td>'
					+' </tr>' 
					
	
					+' <tr class="even">'
					+'   <td class="inquire_item6">炮点文件：</td>'
	    			+'   <td id="td_artillery_file'+rowNum+'" class="inquire_form6">'
	    			+'     <input id="artillery_file' + '_' + rowNum+'"  name="artillery_file' + '_' + rowNum+'" type="hidden" value="" />'
	    			+'     <input id="artillery_file_file' + '_' + rowNum+'"  name="artillery_file_file' + '_' + rowNum + '" type="file" onchange="getWsFileInfo(\'artillery_file_'+rowNum+'\')" class="input_width" style="margin-top:4px;"/>'
	    			+'   </td>'
					+'   <td class="inquire_item6">总炮数：</td>'
	    			+'   <td class="inquire_form6"><input id="artillery_total' + '_' + rowNum+'" name="artillery_total' + '_' + rowNum+'" type="text" value="'+artillery_total+'" class="input_width" style="margin-top:4px;" onkeypress="return on_key_press_int(this)"/><div></div></td>'
					+'   <td class="inquire_item6">炮点面积：</td>'
					+'   <td class="inquire_form6"><input id="artillery_area' + '_' + rowNum+'"  name="artillery_area' + '_' + rowNum+'" type="text" value="'+artillery_area+'" class="input_width" style="margin-top:4px;"/><div></div></td></tr>'
					+' </tr>'
					+' <tr class="odd">'
					+'   <td class="inquire_item6">最大偏移距：</td>'
	    			+'   <td class="inquire_form6"><input id="max_offset' + '_' + rowNum+'"  name="max_offset' + '_' + rowNum+'" type="text" value="'+max_offset+'" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+'   <td class="inquire_item6">炮点距离：</td>'
					+'   <td class="inquire_form6"><input id="artillery_point' + '_' + rowNum+'" name="artillery_point' + '_' + rowNum+'" type="text" value="'+artillery_point+'" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+'   <td class="inquire_item6">观测点距 ：</td>'
					+'   <td class="inquire_form6"><input id="observe_point' + '_' + rowNum+'" name="observe_point' + '_' + rowNum+'" type="text" value="'+observe_point+'" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+' </tr>'
					+' <tr class="even">'
					+'   <td class="inquire_item6">观测起始深度：</td>'
	    			+'   <td class="inquire_form6"><input id="observe_begin_depth' + '_' + rowNum+'" name="observe_begin_depth' + '_' + rowNum+'" type="text" value="'+observe_begin_depth+'" class="input_width" style="margin-top:4px;" /><div></div></td>'
					+'   <td class="inquire_item6">观测结束深度：</td>'
					+'   <td class="inquire_form6"><input id="observe_end_depth' + '_' + rowNum+'" name="observe_end_depth' + '_' + rowNum+'" type="text" value="'+observe_end_depth+'" class="input_width" style="margin-top:4px;" /><div></div></td>'
					+'   <td class="inquire_item6">观测级数：</td>'
					+'   <td class="inquire_form6"><input id="observe_level' + '_' + rowNum+'" name="observe_level' + '_' + rowNum+'" type="text" value="'+observe_level+'" class="input_width" style="margin-top:4px;" /><div></div></td>'
					+' </tr>'
					+' <tr class="odd">'
					+'   <td class="inquire_item6">观测物理点数：</td>'
	    			+'   <td class="inquire_form6"><input id="observe_physical_point' + '_' + rowNum+'" name="observe_physical_point' + '_' + rowNum+'" type="text" value="'+observe_physical_point+'" class="input_width" style="margin-top:4px;" /><div></div></td>'
					+'   <td class="inquire_item6"></td>'
					+'   <td class="inquire_form6"></td>'
					+'   <td class="inquire_item6"></td>'
					+'   <td class="inquire_form6"></td>'
					+' </tr>'
					+'</table>';
		
	}else{
		//第一行,直接插入空数据
		layoutRows++;
		var tr = document.getElementById("table1").insertRow();
		tr.id = "trLayout_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table1").insertRow();
		tr.id = "trLayout_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="layout_table_'+layoutIndex+'">'
					 + viewTr
					+'   <td class="inquire_item6">子波X坐标：</td>'
					+'   <td class="inquire_form6">'
					+'     <input id="layoutid' + '_' + rowNum+'" name="layoutid' + '_' + rowNum+'" type="hidden" value=""/>'
					+'     <input id="bsflag1' + '_' + rowNum+'" name="bsflag1' + '_' + rowNum+'" type="hidden" value="0"/>'
					+'     <input id="wave_x'+'_' + rowNum+'" name="wave_x'+'_' + rowNum+'" type="text" value=""  class="input_width"/>'
					+'   </td>'
					+'   <td class="inquire_item6">子波Y坐标：</td>'
	    			+'   <td class="inquire_form6">'
	    			+'     <input id="wave_y' + '_' + rowNum+'" name="wave_y' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div>'
	    			+'   </td>'
					+'   <td class="inquire_item6">子波Z坐标：</td>'
					+'   <td class="inquire_form6">'
					+'     <input id="wave_z' + '_' + rowNum+'" name="wave_z' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div>'
					+'   </td>'
					+' </tr>'
					+' <tr class="even">'

					+'   <td class="inquire_item6">炮点文件：</td>'
					+'   <td id="td_artillery_file'+rowNum+'" class="inquire_form6">'
	    			+'     <input id="artillery_file' + '_' + rowNum+'"  name="artillery_file' + '_' + rowNum+'" type="hidden" value="" />'
	    			+'     <input id="artillery_file_file' + '_' + rowNum+'"  name="artillery_file_file' + '_' + rowNum + '" type="file" onchange="getWsFileInfo(\'artillery_file_'+rowNum+'\')" class="input_width" style="margin-top:4px;"/>'
	    			+'   </td>'
					+'   <td class="inquire_item6">总炮数：</td>'
	    			+'   <td class="inquire_form6"><input id="artillery_total' + '_' + rowNum+'" name="artillery_total' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" onkeypress="return on_key_press_int(this)"/><div></div></td>'
					+'   <td class="inquire_item6">炮点面积：</td>'
					+'   <td class="inquire_form6"><input id="artillery_area' + '_' + rowNum+'" name="artillery_area' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div></td></tr>'
					+' </tr>'
					+' <tr class="odd">'
					+'   <td class="inquire_item6">最大偏移距：</td>'
	    			+'   <td class="inquire_form6"><input id="max_offset' + '_' + rowNum+'"  name="max_offset' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+'   <td class="inquire_item6">炮点距离：</td>'
					+'   <td class="inquire_form6"><input id="artillery_point' + '_' + rowNum+'" name="artillery_point' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+'   <td class="inquire_item6">观测点距 ：</td>'
					+'   <td class="inquire_form6"><input id="observe_point' + '_' + rowNum+'" name="observe_point' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+' </tr>'
					+' <tr class="even">'
					+'   <td class="inquire_item6">观测起始深度：</td>'
	    			+'   <td class="inquire_form6"><input id="observe_begin_depth' + '_' + rowNum+'" name="observe_begin_depth' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" /><div></div></td>'
					+'   <td class="inquire_item6">观测结束深度：</td>'
					+'   <td class="inquire_form6"><input id="observe_end_depth' + '_' + rowNum+'" name="observe_end_depth' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" /><div></div></td>'
					+'   <td class="inquire_item6">观测级数：</td>'
					+'   <td class="inquire_form6"><input id="observe_level' + '_' + rowNum+'" name="observe_level' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" /><div></div></td>'
					+' </tr>'
					+' <tr class="odd">'
					+'   <td class="inquire_item6">观测物理点数：</td>'
	    			+'   <td class="inquire_form6"><input id="observe_physical_point' + '_' + rowNum+'" name="observe_physical_point' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" /><div></div></td>'
					+'   <td class="inquire_item6"></td>'
					+'   <td class="inquire_form6"></td>'
					+'   <td class="inquire_item6"></td>'
					+'   <td class="inquire_form6"></td>'
					+' </tr>'
					+'</table>';
	
	}
}
//激发参数 井炮
function toAddWellArtillery(){
	wellArtilleryIndex++;
	var tr = document.getElementById("trWA_"+wellArtilleryIndex);
	if(tr != null){
		document.getElementById("trWA_hr_"+wellArtilleryIndex).style.display = "block";
		document.getElementById("trWA_"+wellArtilleryIndex).style.display = "block";
		return;
	}
	var rowNum = spRows;
	if(rowNum > 1){
		
		//读取上一行数据
		var preRowNum = parseInt(rowNum) - 1;
		var well_total_depth = document.getElementById('well_total_depth_'+preRowNum).value;
		var drug_quantity = document.getElementById('drug_quantity_'+preRowNum).value;
		var drug_type = document.getElementById('drug_type_'+preRowNum).value;
		
		
		spRows++;
		var tr = document.getElementById("table2").insertRow();
		tr.id = "trWA_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table2").insertRow();
		tr.id = "trWA_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="wellArtillery_table_'+wellArtilleryIndex+'">'
							+' <tr class="even">'
							+' <td class="inquire_item6">井深：</td>'
							+' <td class="inquire_form6">'
							+'   <input id="method2_no' + '_' + rowNum+'" type="hidden" value=""/><input id="bsflag2' + '_' + rowNum+'" type="hidden" value="0"/>'
							+'   <input id="well_total_depth' + '_' + rowNum+'"  name="well_total_depth' + '_' + rowNum+'" type="text" value="'+well_total_depth+'"  class="input_width"/><div>m</div>'
							+' </td>'
							+' <td class="inquire_item6">药量：</td>'
							+' <td class="inquire_form6"><input id="drug_quantity' + '_' + rowNum+'" name="drug_quantity' + '_' + rowNum+'" type="text" value="'+drug_quantity+'" style="margin-top:4px;" class="input_width"/><div>kg</div></td>'
							+' <td class="inquire_item6">药型：</td>'
								+' <td class="inquire_form6">'
								+' <select id="drug_type' + '_' + rowNum+'" name="drug_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="5110000055000000001">TNT炸药</option><option value="5110000055000000002">硝铵炸药</option><option value="5110000055000000003">乳化炸药</option><option value="5110000055000000004">其它</option></select>'
							+' </td></tr></table>';
							
		document.getElementById('drug_type_'+rowNum).value=drug_type;
	}else{
		//第一行,直接插入空数据
		spRows++;
		var tr = document.getElementById("table2").insertRow();
		tr.id = "trWA_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table2").insertRow();
		tr.id = "trWA_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="wellArtillery_table_'+wellArtilleryIndex+'">'
					+' <tr class="even">'
					+' <td class="inquire_item6">井深：</td>'
					+' <td class="inquire_form6">'
					+'   <input id="method2_no' + '_' + rowNum+'" type="hidden" value=""/><input id="bsflag2' + '_' + rowNum+'" type="hidden" value="0"/>'
					+'   <input id="well_total_depth' + '_' + rowNum+'"  name="well_total_depth' + '_' + rowNum+'" type="text" value=""  class="input_width"/><div>m</div>'
					+' </td>'
					+' <td class="inquire_item6">药量：</td>'
	    			+' <td class="inquire_form6"><input id="drug_quantity' + '_' + rowNum+'" name="drug_quantity' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div>kg</div></td>'
					+' <td class="inquire_item6">药型：</td>'
	   				+' <td class="inquire_form6">'
	   				+' <select id="drug_type' + '_' + rowNum+'" name="drug_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="5110000055000000001">TNT炸药</option><option value="5110000055000000002">硝铵炸药</option><option value="5110000055000000003">乳化炸药</option><option value="5110000055000000004">其它</option></select>'
					+' </td></tr></table>';
	}

}
//震源
function toAddQuakeSource(){
	sourceIndex++;
	var tr = document.getElementById("trSource_"+sourceIndex);
	if(tr != null){
		document.getElementById("trSource_hr_"+sourceIndex).style.display = "block";
		document.getElementById("trSource_"+sourceIndex).style.display = "block";
		return;
	}
	var rowNum = sourceRows;
	if(rowNum > 1){
		//读取上一行
		var preRowNum = parseInt(rowNum) - 1;
		//var pre_method3_no = document.getElementById('method3_no_'+preRowNum).value;
		var quake_type = document.getElementById('quake_type_'+preRowNum).value;
		var quake_box = document.getElementById('quake_box_'+preRowNum).value;
		var quake_machine_num = document.getElementById('quake_machine_num_'+preRowNum).value;
		var quake_num = document.getElementById('quake_num_'+preRowNum).value;
		var quake_direction = document.getElementById('quake_direction_'+preRowNum).value;
		var quake_cardinal_distance = document.getElementById('quake_cardinal_distance_'+preRowNum).value;
		var scan_type = document.getElementById('scan_type_'+preRowNum).value;
		var frequency_compensation = document.getElementById('frequency_compensation_'+preRowNum).value;
		var begin_frequency = document.getElementById('begin_frequency_'+preRowNum).value;
		var end_frequency = document.getElementById('end_frequency_'+preRowNum).value;
		var scan_length = document.getElementById('scan_length_'+preRowNum).value;
		var driving_scope = document.getElementById('driving_scope_'+preRowNum).value;
		var start_stop_slope = document.getElementById('start_stop_slope_'+preRowNum).value;
		var slide_scan_time = document.getElementById('slide_scan_time_'+preRowNum).value;
		
		
		sourceRows++;
		var tr = document.getElementById("table3").insertRow();
		tr.id = "trSource_hr_"+rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table3").insertRow();
		tr.id = "trSource_"+rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="source_table_'+sourceIndex+'">'
					+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>震源型号：</td>'
					+' <td class="inquire_form6"><input id="method3_no' + '_' + rowNum+'" type="hidden" value="" class="input_width" /><input id="bsflag3' + '_' + rowNum+'" type="hidden" value="0"/>'
					+' <input id="quake_type' + '_' + rowNum+'" name="quake_type' + '_' + rowNum+'" type="text" value="'+quake_type+'"  class="input_width"/></td>'
					+' <td class="inquire_item6">震源箱体：</td>'
					+' <td class="inquire_form6"><input id="quake_box' + '_' + rowNum+'" name="quake_box' + '_' + rowNum+'" type="text" value="'+quake_box+'" style="margin-top:4px;" class="input_width"/><div></div></td>'
					+' <td class="inquire_item6">震源台数：</td>'
						+' <td class="inquire_form6"><input id="quake_machine_num' + '_' + rowNum+'"  name="quake_machine_num' + '_' + rowNum+'" type="text" value="'+quake_machine_num+'" style="margin-top:4px;" class="input_width"/><div>台</div></td>'
					+' </tr>'
					+' <tr class="odd"><td class="inquire_item6">震动次数：</td>'
					+' <td class="inquire_form6"><input id="quake_num' + '_' + rowNum+'" name="quake_num' + '_' + rowNum+'" type="text" value="'+quake_num+'" class="input_width" style="margin-top:4px;"/><div>次</div></td>'
					+' <td class="inquire_item6">震源组合方向：</td>'
					+' <td class="inquire_form6"><input id="quake_direction' + '_' + rowNum+'" name="quake_direction' + '_' + rowNum+'" type="text" value="'+quake_direction+'" class="input_width" style="margin-top:4px;"/><div><div></div></div></td>'
					+' <td class="inquire_item6">震源组合基距：</td>'
					+'<td class="inquire_form6"><input id="quake_cardinal_distance' + '_' + rowNum+'" name="quake_cardinal_distance' + '_' + rowNum+'" type="text" value="'+quake_cardinal_distance+'" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
					+' </tr>'
					+' <tr class="even"><td class="inquire_item6">扫描类型：</td>'
					+' <td class="inquire_form6"><select id="scan_type' + '_' + rowNum+'" name="scan_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="1">线性</option><option value="0">非线性</option></select></td>'
					+' <td class="inquire_item6">频率补偿：</td>'
					+' <td class="inquire_form6"><input id="frequency_compensation' + '_' + rowNum+'" name="frequency_compensation' + '_' + rowNum+'" type="text" value="'+frequency_compensation+'" class="input_width" style="margin-top:4px;"/><div>dB/OCT</div></td>'
					+' <td class="inquire_item6">扫描起始频率：</td>'
					+'<td class="inquire_form6"><input id="begin_frequency' + '_' + rowNum+'" name="begin_frequency' + '_' + rowNum+'"  type="text" value="'+begin_frequency+'" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
					+' </tr>'
					+' <tr class="odd"><td class="inquire_item6">扫描终了频率：</td>'
					+' <td class="inquire_form6"><input id="end_frequency' + '_' + rowNum+'"  name="end_frequency' + '_' + rowNum+'" type="text" value="'+end_frequency+'" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
					+' <td class="inquire_item6">扫描长度：</td>'
					+' <td class="inquire_form6"><input id="scan_length' + '_' + rowNum+'"  name="scan_length' + '_' + rowNum+'" type="text" value="'+scan_length+'" class="input_width" style="margin-top:4px;"/><div>s</div></td>'
					+' <td class="inquire_item6">驱动幅度：</td>'
					+'<td class="inquire_form6"><input id="driving_scope' + '_' + rowNum+'"  name="driving_scope' + '_' + rowNum+'" type="text" value="'+driving_scope+'" class="input_width" style="margin-top:4px;"/><div>%</div></td>'
					+' </tr>'
					+' <tr class="even"><td class="inquire_item6">起止斜坡：</td>'
					+' <td class="inquire_form6"><input id="start_stop_slope' + '_' + rowNum+'"  name="start_stop_slope' + '_' + rowNum+'" type="text" value="'+start_stop_slope+'" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+' <td class="inquire_item6">滑动扫描时间：</td>'
					+' <td class="inquire_form6"><input id="slide_scan_time' + '_' + rowNum+'"  name="slide_scan_time' + '_' + rowNum+'" type="text" value="'+slide_scan_time+'" class="input_width" style="margin-top:4px;"/><div>s</div></td>'
					+' <td class="inquire_item6"></td>'
					+'<td class="inquire_form6"></td>'
					+' </tr>'
					+' </table>';

		document.getElementById('scan_type_'+rowNum).value=scan_type;
	}else{
		//第一行
		sourceRows++;
		var tr = document.getElementById("table3").insertRow();
		tr.id = "trSource_hr_"+rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table3").insertRow();
		tr.id = "trSource_"+rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="source_table_'+sourceIndex+'">'
					+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>震源型号：</td>'
					+' <td class="inquire_form6"><input id="method3_no' + '_' + rowNum+'" type="hidden" value="" class="input_width" /><input id="bsflag3' + '_' + rowNum+'" type="hidden" value="0"/>'
					+' <input id="quake_type' + '_' + rowNum+'" name="quake_type' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
					+' <td class="inquire_item6">震源箱体：</td>'
	    			+' <td class="inquire_form6"><input id="quake_box' + '_' + rowNum+'" name="quake_box' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div></div></td>'
					+' <td class="inquire_item6">震源台数：</td>'
	   				+' <td class="inquire_form6"><input id="quake_machine_num' + '_' + rowNum+'"  name="quake_machine_num' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div>台</div></td>'
					+' </tr>'
					+' <tr class="odd"><td class="inquire_item6">震动次数：</td>'
	    			+' <td class="inquire_form6"><input id="quake_num' + '_' + rowNum+'" name="quake_num' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>次</div></td>'
					+' <td class="inquire_item6">震源组合方向：</td>'
					+' <td class="inquire_form6"><input id="quake_direction' + '_' + rowNum+'" name="quake_direction' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+' <td class="inquire_item6">震源组合基距：</td>'
	    			+'<td class="inquire_form6"><input id="quake_cardinal_distance' + '_' + rowNum+'" name="quake_cardinal_distance' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
					+' </tr>'
					+' <tr class="even"><td class="inquire_item6">扫描类型：</td>'
	    			+' <td class="inquire_form6"><select id="scan_type' + '_' + rowNum+'" name="scan_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="1">线性</option><option value="0">非线性</option></select></td>'
					+' <td class="inquire_item6">频率补偿：</td>'
					+' <td class="inquire_form6"><input id="frequency_compensation' + '_' + rowNum+'" name="frequency_compensation' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>dB/OCT</div></td>'
					+' <td class="inquire_item6">扫描起始频率：</td>'
	    			+'<td class="inquire_form6"><input id="begin_frequency' + '_' + rowNum+'" name="begin_frequency' + '_' + rowNum+'"  type="text" value="" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
					+' </tr>'
					+' <tr class="odd"><td class="inquire_item6">扫描终了频率：</td>'
	    			+' <td class="inquire_form6"><input id="end_frequency' + '_' + rowNum+'"  name="end_frequency' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
					+' <td class="inquire_item6">扫描长度：</td>'
					+' <td class="inquire_form6"><input id="scan_length' + '_' + rowNum+'"  name="scan_length' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>s</div></td>'
					+' <td class="inquire_item6">驱动幅度：</td>'
	    			+'<td class="inquire_form6"><input id="driving_scope' + '_' + rowNum+'"  name="driving_scope' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>%</div></td>'
					+' </tr>'
					+' <tr class="even"><td class="inquire_item6">起止斜坡：</td>'
	    			+' <td class="inquire_form6"><input id="start_stop_slope' + '_' + rowNum+'"  name="start_stop_slope' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+' <td class="inquire_item6">滑动扫描时间：</td>'
					+' <td class="inquire_form6"><input id="slide_scan_time' + '_' + rowNum+'"  name="slide_scan_time' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>s</div></td>'
					+' <td class="inquire_item6"></td>'
	    			+'<td class="inquire_form6"></td>'
					+' </tr>'
					+' </table>';
	}
}
//气枪
function toAddAirGun(){
	aigGunIndex++;
	var tr = document.getElementById("trAirGun_"+aigGunIndex);
	if(tr != null){
		document.getElementById("trAirGun_hr_"+aigGunIndex).style.display = "block";
		document.getElementById("trAirGun_"+aigGunIndex).style.display = "block";
		return;
	}
	var rowNum = aigGunRows;
	if(rowNum > 1){
		//读取上一行
		var preRowNum = parseInt(rowNum) - 1;
		//var pre_method4_no = document.getElementById('method4_no_'+preRowNum).value;
		var air_gun_type = document.getElementById('air_gun_type_'+preRowNum).value;
		var volume_total = document.getElementById('volume_total_'+preRowNum).value;
		var air_gun_pressure = document.getElementById('air_gun_pressure_'+preRowNum).value;
		var gun_num = document.getElementById('gun_num_'+preRowNum).value;
		var peak_value = document.getElementById('peak_value_'+preRowNum).value;
		var bubble_ratio = document.getElementById('bubble_ratio_'+preRowNum).value;
		var bandwidth = document.getElementById('bandwidth_'+preRowNum).value;
		var array_length = document.getElementById('array_length_'+preRowNum).value;
		
		aigGunRows++;
		var tr = document.getElementById("table4").insertRow();
		tr.id = "trAirGun_hr_"+rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table4").insertRow();
		tr.id = "trAirGun_"+rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="aigGun_table_'+aigGunIndex+'">'
					+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>气枪震源型号：</td>'
					+' <td class="inquire_form6"><input id="method4_no' + '_' + rowNum+'" type="hidden" value="" class="input_width" /><input id="bsflag4' + '_' + rowNum+'" type="hidden" value="0"/>'
					+'   <select id="air_gun_type' + '_' + rowNum+'" name="air_gun_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="G枪">G枪</option><option value="2800LLX">2800LLX</option><option value="1900LL-XT-AT">1900LL-XT-AT</option><option value="BOLT">BOLT</option></select></td>'
					+' <td class="inquire_item6">总容量：</td>'
					+' <td class="inquire_form6"><input id="volume_total' + '_' + rowNum+'" name="volume_total' + '_' + rowNum+'" type="text" value="'+volume_total+'" style="margin-top:4px;" class="input_width"/><div>cu</div></td>'
					+' <td class="inquire_item6">气枪压力:</td>'
						+' <td class="inquire_form6"><input id="air_gun_pressure' + '_' + rowNum+'" name="air_gun_pressure' + '_' + rowNum+'" type="text" value="'+air_gun_pressure+'" style="margin-top:4px;" class="input_width"/><div>Pa</div></td>'
					+' </tr>'
					+' <tr class="odd"><td class="inquire_item6">枪数：</td>'
					+' <td class="inquire_form6"><input id="gun_num' + '_' + rowNum+'" name="gun_num' + '_' + rowNum+'" type="text" value="'+gun_num+'" class="input_width" style="margin-top:4px;"/><div>个</div></td>'
					+' <td class="inquire_item6">峰-峰值：</td>'
					+' <td class="inquire_form6"><input id="peak_value' + '_' + rowNum+'" name="peak_value' + '_' + rowNum+'"  type="text" value="'+peak_value+'" class="input_width" style="margin-top:4px;"/><div>Ba</div></td>'
					+' <td class="inquire_item6">气泡比：</td>'
					+'<td class="inquire_form6"><input id="bubble_ratio' + '_' + rowNum+'" name="bubble_ratio' + '_' + rowNum+'" type="text" value="'+bubble_ratio+'" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+' </tr>'
					+' <tr class="even"><td class="inquire_item6">频宽：</td>'
					+' <td class="inquire_form6"><input id="bandwidth' + '_' + rowNum+'" name="bandwidth' + '_' + rowNum+'" type="text" value="'+bandwidth+'" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
					+' <td class="inquire_item6">阵列长度：</td>'
					+' <td class="inquire_form6"><input id="array_length' + '_' + rowNum+'" name="array_length' + '_' + rowNum+'" type="text" value="'+array_length+'" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
					+' <td class="inquire_item6"></td>'
					+'<td class="inquire_form6"></td>'
					+' </tr></table>';
		document.getElementById('air_gun_type_'+rowNum).value=air_gun_type;
	}else{
		//第一行
		aigGunRows++;
		var tr = document.getElementById("table4").insertRow();
		tr.id = "trAirGun_hr_"+rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table4").insertRow();
		tr.id = "trAirGun_"+rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="aigGun_table_'+aigGunIndex+'">'
					+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>气枪震源型号：</td>'
					+' <td class="inquire_form6"><input id="method4_no' + '_' + rowNum+'" type="hidden" value="" class="input_width" /><input id="bsflag4' + '_' + rowNum+'" type="hidden" value="0"/>'
					+'   <select id="air_gun_type' + '_' + rowNum+'" name="air_gun_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="G枪">G枪</option><option value="2800LLX">2800LLX</option><option value="1900LL-XT-AT">1900LL-XT-AT</option><option value="BOLT">BOLT</option></select></td>'
					+' <td class="inquire_item6">总容量：</td>'
	    			+' <td class="inquire_form6"><input id="volume_total' + '_' + rowNum+'" name="volume_total' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div>cu</div></td>'
					+' <td class="inquire_item6">气枪压力:</td>'
	   				+' <td class="inquire_form6"><input id="air_gun_pressure' + '_' + rowNum+'" name="air_gun_pressure' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div>Pa</div></td>'
					+' </tr>'
					+' <tr class="odd"><td class="inquire_item6">枪数：</td>'
	    			+' <td class="inquire_form6"><input id="gun_num' + '_' + rowNum+'" name="gun_num' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>个</div></td>'
					+' <td class="inquire_item6">峰-峰值：</td>'
					+' <td class="inquire_form6"><input id="peak_value' + '_' + rowNum+'" name="peak_value' + '_' + rowNum+'"  type="text" value="" class="input_width" style="margin-top:4px;"/><div>Ba</div></td>'
					+' <td class="inquire_item6">气泡比：</td>'
	    			+'<td class="inquire_form6"><input id="bubble_ratio' + '_' + rowNum+'" name="bubble_ratio' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div></div></td>'
					+' </tr>'
					+' <tr class="even"><td class="inquire_item6">频宽：</td>'
	    			+' <td class="inquire_form6"><input id="bandwidth' + '_' + rowNum+'" name="bandwidth' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
					+' <td class="inquire_item6">阵列长度：</td>'
					+' <td class="inquire_form6"><input id="array_length' + '_' + rowNum+'" name="array_length' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>m</div></td>'
					+' <td class="inquire_item6"></td>'
	    			+'<td class="inquire_form6"></td>'
					+' </tr></table>';
	}
}
//井下扫描源
function toAddScanSource(){
	scanSourceIndex++;
	var tr = document.getElementById("trScanSource_"+scanSourceIndex);
	if(tr != null){
		document.getElementById("trScanSource_hr_"+scanSourceIndex).style.display = "block";
		document.getElementById("trScanSource_"+scanSourceIndex).style.display = "block";
		return;
	}
	var rowNum = scanSourceRows;
	if(rowNum > 1){
		//读取上一行
				
		var preRowNum = parseInt(rowNum) - 1;
		//var pre_method5_no = document.getElementById('method5_no_'+preRowNum).value;
		var scan_quake_type = document.getElementById('scan_quake_type_'+preRowNum).value;
		var scan_quake_power = document.getElementById('scan_quake_power_'+preRowNum).value;
		var scan_quake_num = document.getElementById('scan_quake_num_'+preRowNum).value;
		var source_scan_type = document.getElementById('source_scan_type_'+preRowNum).value;
		var scan_begin_frequency = document.getElementById('scan_begin_frequency_'+preRowNum).value;
		var scan_end_frequency = document.getElementById('scan_end_frequency_'+preRowNum).value;
		var source_scan_length = document.getElementById('source_scan_length_'+preRowNum).value;
		
		scanSourceRows++;
		var tr = document.getElementById("table5").insertRow();
		tr.id = "trScanSource_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table5").insertRow();
		tr.id = "trScanSource_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="scanSource_table_'+scanSourceIndex+'">'
									+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>震源类型：</td>'
									+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
									+' <input id="scan_quake_type' + '_' + rowNum+'" name="scan_quake_type' + '_' + rowNum+'" type="text" value="'+scan_quake_type+'"  class="input_width"/></td>'
									+' <td class="inquire_item6">震源能量：</td>'
									+' <td class="inquire_form6"><input id="scan_quake_power' + '_' + rowNum+'" name="scan_quake_power' + '_' + rowNum+'" type="text" value="'+scan_quake_power+'" style="margin-top:4px;" class="input_width"/><div></div></td>'
									+' <td class="inquire_item6">震动次数:</td>'
										+' <td class="inquire_form6"><input id="scan_quake_num' + '_' + rowNum+'"  name="scan_quake_num' + '_' + rowNum+'" type="text" value="'+scan_quake_num+'" style="margin-top:4px;" class="input_width" onkeypress="return on_key_press_int(this)"/><div>次</div></td>'
									+' </tr>'
									+' <tr class="odd"><td class="inquire_item6">扫描类型：</td>'
									+' <td class="inquire_form6">'
									+'   <select id="source_scan_type' + '_' + rowNum+'" name="source_scan_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="1">线性</option><option value="0">非线性</option></select></td>'
									+' <td class="inquire_item6">扫描起始频率：</td>'
									+' <td class="inquire_form6"><input id="scan_begin_frequency' + '_' + rowNum+'" name="scan_begin_frequency' + '_' + rowNum+'" type="text" value="'+scan_begin_frequency+'" class="input_width" style="margin-top:4px;" onkeypress="return on_key_press_int(this)"/><div>Hz</div></td>'
									+' <td class="inquire_item6">扫描终止频率：</td>'
									+'<td class="inquire_form6"><input id="scan_end_frequency' + '_' + rowNum+'"  name="scan_end_frequency' + '_' + rowNum+'" type="text" value="'+scan_end_frequency+'" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
									+' </tr>'
									+' <tr class="even"><td class="inquire_item6">扫描长度：</td>'
									+' <td class="inquire_form6"><input id="source_scan_length' + '_' + rowNum+'" name="source_scan_length' + '_' + rowNum+'"  type="text" value="'+source_scan_length+'" class="input_width" style="margin-top:4px;"/><div>s</div></td>'
									+' <td class="inquire_item6"></td>'
									+' <td class="inquire_form6"></td>'
									+' <td class="inquire_item6"></td>'
									+'<td class="inquire_form6"></td>'
									+' </tr></table>';
	}else{
		//第一行
		scanSourceRows++;
		var tr = document.getElementById("table5").insertRow();
		tr.id = "trScanSource_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table5").insertRow();
		tr.id = "trScanSource_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="scanSource_table_'+scanSourceIndex+'">'
					+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>震源类型：</td>'
					+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
					+' <input id="scan_quake_type' + '_' + rowNum+'" name="scan_quake_type' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
					+' <td class="inquire_item6">震源能量：</td>'
	    			+' <td class="inquire_form6"><input id="scan_quake_power' + '_' + rowNum+'" name="scan_quake_power' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div></div></td>'
					+' <td class="inquire_item6">震动次数:</td>'
	   				+' <td class="inquire_form6"><input id="scan_quake_num' + '_' + rowNum+'"  name="scan_quake_num' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width" onkeypress="return on_key_press_int(this)"/><div>次</div></td>'
					+' </tr>'
					+' <tr class="odd"><td class="inquire_item6">扫描类型：</td>'
	    			+' <td class="inquire_form6">'
	    			+'   <select id="source_scan_type' + '_' + rowNum+'" name="source_scan_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="1">线性</option><option value="0">非线性</option></select></td>'
					+' <td class="inquire_item6">扫描起始频率：</td>'
					+' <td class="inquire_form6"><input id="scan_begin_frequency' + '_' + rowNum+'" name="scan_begin_frequency' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;" onkeypress="return on_key_press_int(this)"/><div>Hz</div></td>'
					+' <td class="inquire_item6">扫描终止频率：</td>'
	    			+'<td class="inquire_form6"><input id="scan_end_frequency' + '_' + rowNum+'"  name="scan_end_frequency' + '_' + rowNum+'" type="text" value="" class="input_width" style="margin-top:4px;"/><div>Hz</div></td>'
					+' </tr>'
					+' <tr class="even"><td class="inquire_item6">扫描长度：</td>'
	    			+' <td class="inquire_form6"><input id="source_scan_length' + '_' + rowNum+'" name="source_scan_length' + '_' + rowNum+'"  type="text" value="" class="input_width" style="margin-top:4px;"/><div>s</div></td>'
					+' <td class="inquire_item6"></td>'
					+' <td class="inquire_form6"></td>'
					+' <td class="inquire_item6"></td>'
	    			+'<td class="inquire_form6"></td>'
					+' </tr></table>';
	}

}
//井下脉冲源
function toAddPulseSource(){
	pulseSourceIndex++;
	var tr = document.getElementById("trPulseSource_"+pulseSourceIndex);
	if(tr != null){
		document.getElementById("trPulseSource_hr_"+pulseSourceIndex).style.display = "block";
		document.getElementById("trPulseSource_"+pulseSourceIndex).style.display = "block";
		return;
	}
	var rowNum = pulseSourceRows;
	if(rowNum > 1){
		
		//读取上一行
				
		var preRowNum = parseInt(rowNum) - 1;
		//var pre_method5_no = document.getElementById('method5_no_'+preRowNum).value;
		var pulse_quake_type = document.getElementById('pulse_quake_type_'+preRowNum).value;
		var pulse_quake_power = document.getElementById('pulse_quake_power_'+preRowNum).value;
		pulseSourceRows++;
		var tr = document.getElementById("table6").insertRow();
		tr.id = "trPulseSource_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table6").insertRow();
		tr.id = "trPulseSource_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="pulseSource_table_'+pulseSourceIndex+'">'
									+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>震源类型：</td>'
									+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
									+' <input id="pulse_quake_type' + '_' + rowNum+'" name="pulse_quake_type' + '_' + rowNum+'" type="text" value="'+pulse_quake_type+'"  class="input_width"/></td>'
									+' <td class="inquire_item6">震源能量：</td>'
									+' <td class="inquire_form6"><input id="pulse_quake_power' + '_' + rowNum+'" name="pulse_quake_power' + '_' + rowNum+'" type="text" value="'+pulse_quake_power+'" style="margin-top:4px;" class="input_width"/><div></div></td>'
									+' <td class="inquire_item6"></td>'
									+' <td class="inquire_form6"></td>'
									+' </tr></table>';
	}else{
		//第一行
		pulseSourceRows++;
		var tr = document.getElementById("table6").insertRow();
		tr.id = "trPulseSource_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table6").insertRow();
		tr.id = "trPulseSource_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="pulseSource_table_'+pulseSourceIndex+'">'
									+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>震源类型：</td>'
									+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
									+' <input id="pulse_quake_type' + '_' + rowNum+'" name="pulse_quake_type' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
									+' <td class="inquire_item6">震源能量：</td>'
									+' <td class="inquire_form6"><input id="pulse_quake_power' + '_' + rowNum+'" name="pulse_quake_power' + '_' + rowNum+'" type="text" value="" style="margin-top:4px;" class="input_width"/><div></div></td>'
									+' <td class="inquire_item6"></td>'
									+' <td class="inquire_form6"></td>'
									+' </tr></table>';
	}

}
//接收参数
function toAddAcceptPara(){
	acceptParaIndex++;
	var tr = document.getElementById("trAcceptPara_"+acceptParaIndex);
	if(tr != null){
		document.getElementById("trAcceptPara_hr_"+acceptParaIndex).style.display = "block";
		document.getElementById("trAcceptPara_"+acceptParaIndex).style.display = "block";
		return;
	}
	var rowNum = acceptParaRows;
	if(rowNum > 1){
		
		//读取上一行
				
		var preRowNum = parseInt(rowNum) - 1;
		//var pre_method5_no = document.getElementById('method5_no_'+preRowNum).value;
		var well_instrument_model = document.getElementById('well_instrument_model_'+preRowNum).value;
		var well_instrument_type = document.getElementById('well_instrument_type_'+preRowNum).value;
		var demodulator_component_product = document.getElementById('demodulator_component_product_'+preRowNum).value;
		var pushed_type = document.getElementById('pushed_type_'+preRowNum).value;
		
		acceptParaRows++;
		var tr = document.getElementById("table7").insertRow();
		tr.id = "trAcceptPara_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table7").insertRow();
		tr.id = "trAcceptPara_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="acceptPara_table_'+acceptParaIndex+'">'
									+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>井下仪器型号：</td>'
									+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
									+' <input id="well_instrument_model' + '_' + rowNum+'" name="well_instrument_model' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
									+' <td class="inquire_item6">井下仪器类型：</td>'
									+' <td class="inquire_form6">'
									+'   <select id="well_instrument_type' + '_' + rowNum+'" name="well_instrument_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="1">数字</option><option value="0">模拟</option></select></td>'
									+' <td class="inquire_item6">检波器分量：</td>'
									+' <td class="inquire_form6">'
									+'   <select id="demodulator_component_product' + '_' + rowNum+'" name="demodulator_component_product' + '_' + rowNum+'"><option value="">--请选择--</option><option value="1">多分量</option><option value="0">单分量</option></select></td>'
									+' </tr> '
		+' <tr class="even"><td class="inquire_item6">推靠类型：</td>'
		+' <td class="inquire_form6"><select id="pushed_type' + '_' + rowNum+'" name="pushed_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="0">液压</option><option value="1">机械</option><option value="2">磁力</option><option value="3">气囊</option></select></td>'
	 	+' <td class="inquire_item6"></td>'
		+' <td class="inquire_form6"></td>'
	 	+' <td class="inquire_item6"></td>'
		+' <td class="inquire_form6"></td>'
  		+' </tr></table>';
		
	}else{
		//第一行
		acceptParaRows++;
		var tr = document.getElementById("table7").insertRow();
		tr.id = "trAcceptPara_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table7").insertRow();
		tr.id = "trAcceptPara_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="acceptPara_table_'+acceptParaIndex+'">'
									+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>井下仪器型号：</td>'
									+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
									+' <input id="well_instrument_model' + '_' + rowNum+'" name="well_instrument_model' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
									+' <td class="inquire_item6">井下仪器类型：</td>'
									+' <td class="inquire_form6">'
									+'   <select id="well_instrument_type' + '_' + rowNum+'" name="well_instrument_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="1">数字</option><option value="0">模拟</option></select></td>'
									+' <td class="inquire_item6">检波器分量：</td>'
									+' <td class="inquire_form6">'
									+'   <select id="demodulator_component_product' + '_' + rowNum+'" name="demodulator_component_product' + '_' + rowNum+'"><option value="">--请选择--</option><option value="1">多分量</option><option value="0">单分量</option></select></td>'
									+' </tr> '
									+' <tr class="even"><td class="inquire_item6">推靠类型：</td>'
									+' <td class="inquire_form6"><select id="pushed_type' + '_' + rowNum+'" name="pushed_type' + '_' + rowNum+'"><option value="">--请选择--</option><option value="0">液压</option><option value="1">机械</option><option value="2">磁力</option><option value="3">气囊</option></select></td>'
								 	+' <td class="inquire_item6"></td>'
									+' <td class="inquire_form6"></td>'
								 	+' <td class="inquire_item6"></td>'
									+' <td class="inquire_form6"></td>'
							  		+' </tr></table>';
	}

}

//仪器参数
function toAddInstrumentPara(){
	
	instrumentParaIndex++;
	var tr = document.getElementById("trInstrumentPara_"+instrumentParaIndex);
	if(tr != null){
		document.getElementById("trInstrumentPara_hr_"+instrumentParaIndex).style.display = "block";
		document.getElementById("trInstrumentPara_"+instrumentParaIndex).style.display = "block";
		return;
	}
	var rowNum = instrumentParaRows;
	if(rowNum > 1){
		
		//读取上一行
				
		var preRowNum = parseInt(rowNum) - 1;
		//var pre_method5_no = document.getElementById('method5_no_'+preRowNum).value;
		var instrument_type = document.getElementById('instrument_type_'+preRowNum).value;
		//var well_instrument_type = document.getElementById('well_instrument_type_'+preRowNum).value;
		var well_instrument_level = document.getElementById('well_instrument_level_'+preRowNum).value;
		
		var well_instrument_distance = document.getElementById('well_instrument_distance_'+preRowNum).value;
		var record_length = document.getElementById('record_length_'+preRowNum).value;
		var sampling_interval = document.getElementById('sampling_interval_'+preRowNum).value;
		var filtering_type = document.getElementById('filtering_type_'+preRowNum).value;
		var filtering_para = document.getElementById('filtering_para_'+preRowNum).value;
		var high_frequency = document.getElementById('high_frequency_'+preRowNum).value;
		var low_frequency = document.getElementById('low_frequency_'+preRowNum).value;
		var preamp_gain = document.getElementById('preamp_gain_'+preRowNum).value;
		
		instrumentParaRows++;
		var tr = document.getElementById("table8").insertRow();
		tr.id = "trInstrumentPara_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table8").insertRow();
		tr.id = "trInstrumentPara_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="instrumentPara_table_'+instrumentParaIndex+'">'
									+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>仪器型号：</td>'
									+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
									+' <input id="instrument_type' + '_' + rowNum+'" name="instrument_type' + '_' + rowNum+'" type="text" value="'+instrument_type+'"  class="input_width"/></td>'
									+' <td class="inquire_item6">井下仪器级数：</td>'
									+' <td class="inquire_form6">'
									+' <input id="well_instrument_level' + '_' + rowNum+'" name="well_instrument_level' + '_' + rowNum+'" type="text" value="'+well_instrument_level+'"  class="input_width"/></td>'
									+' <td class="inquire_item6">井下仪器间距：</td>'
									+' <td class="inquire_form6">'
									+'   <input id="well_instrument_distance' + '_' + rowNum+'" name="well_instrument_distance' + '_' + rowNum+'" type="text" value="'+well_instrument_distance+'"  class="input_width"/><div>m</div></td>'
									+' </tr> '
									+' <tr class="even"><td class="inquire_item6">记录长度：</td>'
									+' <td class="inquire_form6">'
									+' <input id="record_length' + '_' + rowNum+'" name="record_length' + '_' + rowNum+'" type="text" value="'+record_length+'"  class="input_width"/><div>m</div></td>'
									+' <td class="inquire_item6">采样间隔：</td>'
									+' <td class="inquire_form6">'
									+' <input id="sampling_interval' + '_' + rowNum+'" name="sampling_interval' + '_' + rowNum+'" type="text" value="'+sampling_interval+'"  class="input_width"/><div>ms</div></td>'
									+' <td class="inquire_item6">滤波类型：</td>'
									+' <td class="inquire_form6">'
									+'   <input id="filtering_type' + '_' + rowNum+'" name="filtering_type' + '_' + rowNum+'" type="text" value="'+filtering_type+'"  class="input_width"/></td>'
									+' </tr> '
									+' <tr class="even"><td class="inquire_item6">滤波参数：</td>'
									+' <td class="inquire_form6">'
									+' <input id="filtering_para' + '_' + rowNum+'" name="filtering_para' + '_' + rowNum+'" type="text" value="'+filtering_para+'"  class="input_width"/><div>fn</div></td>'
									+' <td class="inquire_item6">高截频率：</td>'
									+' <td class="inquire_form6">'
									+' <input id="high_frequency' + '_' + rowNum+'" name="high_frequency' + '_' + rowNum+'" type="text" value="'+high_frequency+'"  class="input_width"/><div></div>Hz</td>'
									+' <td class="inquire_item6">低截频率：</td>'
									+' <td class="inquire_form6">'
									+'   <input id="low_frequency' + '_' + rowNum+'" name="low_frequency' + '_' + rowNum+'" type="text" value="'+low_frequency+'"  class="input_width"/><div></div>Hz</td>'
									+' </tr> '
									+' <tr class="even"><td class="inquire_item6">前放增益：</td>'
									+' <td class="inquire_form6">'
									+' <input id="preamp_gain' + '_' + rowNum+'" name="preamp_gain' + '_' + rowNum+'" type="text" value="'+preamp_gain+'"  class="input_width"/><div>dB</div></td>'
									+' <td class="inquire_item6"></td>'
									+' <td class="inquire_form6"></td>'
									+' <td class="inquire_item6"></td>'
									+' <td class="inquire_form6"></td>'
									+' </tr> '
									+'</table>';
	}else{
		//第一行
		
		instrumentParaRows++;
		var tr = document.getElementById("table8").insertRow();
		tr.id = "trInstrumentPara_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table8").insertRow();
		tr.id = "trInstrumentPara_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="instrumentPara_table_'+instrumentParaIndex+'">'
									+' <tr class="even"><td class="inquire_item6"><font color="red">*</font>仪器型号：</td>'
									+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
									+' <input id="instrument_type' + '_' + rowNum+'" name="instrument_type' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
									+' <td class="inquire_item6">井下仪器级数：</td>'
									+' <td class="inquire_form6">'
									+' <input id="well_instrument_level' + '_' + rowNum+'" name="well_instrument_level' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
									+' <td class="inquire_item6">井下仪器间距：</td>'
									+' <td class="inquire_form6">'
									+' <input id="well_instrument_distance' + '_' + rowNum+'" name="well_instrument_distance' + '_' + rowNum+'" type="text" value=""  class="input_width" /><div>m</div></td>'
									+' </tr> '
									+' <tr class="even"><td class="inquire_item6">记录长度：</td>'
									+' <td class="inquire_form6">'
									+' <input id="record_length' + '_' + rowNum+'" name="record_length' + '_' + rowNum+'" type="text" value=""  class="input_width"/><div>m</div></td>'
									+' <td class="inquire_item6">采样间隔：</td>'
									+' <td class="inquire_form6">'
									+' <input id="sampling_interval' + '_' + rowNum+'" name="sampling_interval' + '_' + rowNum+'" type="text" value=""  class="input_width"/><div>ms</div></td>'
									+' <td class="inquire_item6">滤波类型：</td>'
									+' <td class="inquire_form6">'
									+'   <input id="filtering_type' + '_' + rowNum+'" name="filtering_type' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
									+' </tr> '
									+' <tr class="even"><td class="inquire_item6">滤波参数：</td>'
									+' <td class="inquire_form6">'
									+' <input id="filtering_para' + '_' + rowNum+'" name="filtering_para' + '_' + rowNum+'" type="text" value=""  class="input_width"/><div>fn</div></td>'
									+' <td class="inquire_item6">高截频率：</td>'
									+' <td class="inquire_form6">'
									+' <input id="high_frequency' + '_' + rowNum+'" name="high_frequency' + '_' + rowNum+'" type="text" value=""  class="input_width"/><div>Hz</div></td>'
									+' <td class="inquire_item6">低截频率：</td>'
									+' <td class="inquire_form6">'
									+'   <input id="low_frequency' + '_' + rowNum+'" name="low_frequency' + '_' + rowNum+'" type="text" value=""  class="input_width"/><div>Hz</div></td>'
									+' </tr> '
									+' <tr class="even"><td class="inquire_item6">前放增益：</td>'
									+' <td class="inquire_form6">'
									+' <input id="preamp_gain' + '_' + rowNum+'" name="preamp_gain' + '_' + rowNum+'" type="text" value=""  class="input_width"/><div>dB</div></td>'
									+' <td class="inquire_item6"></td>'
									+' <td class="inquire_form6"></td>'
									+' <td class="inquire_item6"></td>'
									+' <td class="inquire_form6"></td>'
									+' </tr> '
									+'</table>';
	}

}


//测绘平面图
function toAddPositionImage(){
	
	positionImageIndex++;
	var tr = document.getElementById("trPositionImage_"+positionImageIndex);
	if(tr != null){
		document.getElementById("trPositionImage_hr_"+positionImageIndex).style.display = "block";
		document.getElementById("trPositionImage_"+positionImageIndex).style.display = "block";
		return;
	}
	var rowNum = positionImageRows;
	if(rowNum > 1){
		
		//读取上一行
				
		var preRowNum = parseInt(rowNum) - 1;
		//var pre_method5_no = document.getElementById('method5_no_'+preRowNum).value;
		var observation_system = document.getElementById('observation_system_'+preRowNum).value;
		var mapping_images = document.getElementById('mapping_images_'+preRowNum).value;
		
		
		positionImageRows++;
		var tr = document.getElementById("table9").insertRow();
		tr.id = "trPositionImage_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table9").insertRow();
		tr.id = "trPositionImage_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="positionImage_table_'+positionImageIndex+'">'
									+' <tr class="even"><td class="inquire_item6">观测系统：</td>'
									+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
									+' <input id="observation_system' + '_' + rowNum+'" name="observation_system' + '_' + rowNum+'" type="text" value="'+observation_system+'"  class="input_width"/></td>'
									+' <td class="inquire_item6">测线平面位置图：</td>'
									+'   <td id="td_mapping_images'+rowNum+'" class="inquire_form6">'
									+'     <input id="mapping_images' + '_' + rowNum+'"  name="mapping_images' + '_' + rowNum+'" type="hidden" value="" />'
									+'     <input id="mapping_images_file' + '_' + rowNum+'"  name="mapping_images_file' + '_' + rowNum+'" type="file" onchange="getWsFileInfo(\'mapping_images_'+rowNum+'\')" class="input_width" style="margin-top:4px;"/>'
									+'   </td>'
									+' <td class="inquire_form6"></td>'
									+' <td class="inquire_form6"></td>'
									+' </tr> '
									+'</table>';
	}else{
		//第一行
		
		positionImageRows++;
		var tr = document.getElementById("table9").insertRow();
		tr.id = "trPositionImage_hr_" + rowNum;
		tr.insertCell().innerHTML = '<table width="100%"><tr><td width="2%" align="right"></td><td width="98%"><hr width="95%"></td></tr></table>';
		var tr = document.getElementById("table9").insertRow();
		tr.id = "trPositionImage_" + rowNum;
		tr.insertCell().innerHTML = '<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height" id="positionImage_table_'+positionImageIndex+'">'
									+' <tr class="even"><td class="inquire_item6">观测系统：</td>'
									+' <td class="inquire_form6"><input id="method5_no' + '_' + rowNum+'" name="wa3d_id" type="hidden" value="" class="input_width" /><input id="bsflag5' + '_' + rowNum+'" type="hidden" value="0"/>'
									+' <input id="observation_system' + '_' + rowNum+'" name="observation_system' + '_' + rowNum+'" type="text" value=""  class="input_width"/></td>'
									+' <td class="inquire_item6">测线平面位置图：</td>'
									+'   <td id="td_mapping_images'+rowNum+'" class="inquire_form6">'
									+'     <input id="mapping_images' + '_' + rowNum+'"  name="mapping_images' + '_' + rowNum+'" type="hidden" value="" />'
					    			+'     <input id="mapping_images_file' + '_' + rowNum+'"  name="mapping_images_file' + '_' + rowNum+'" type="file" onchange="getWsFileInfo(\'mapping_images_'+rowNum+'\')" class="input_width" style="margin-top:4px;"/>'
					    			+'   </td>'
									+' <td class="inquire_form6"></td>'
									+' <td class="inquire_form6"></td>'
									+' </tr> '
									+'</table>';
	}

}



//观测系统
function toDeleteLayout(){
	var rowNum = layoutIndex;
	if(rowNum <= 1){
		return;	
	}
	var line = document.getElementById("trLayout_hr_"+rowNum);
	var dataLine = document.getElementById("trLayout_"+rowNum);
	var record_id = document.getElementById("layoutid_"+rowNum).value;

		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		layoutRows--;
		layoutIndex--;

}
//激发参数 井炮
function toDelWellArtillery(){
	var rowNum = wellArtilleryIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trWA_hr_"+rowNum);
	var dataLine = document.getElementById("trWA_"+rowNum);
	var record_id = document.getElementById("method2_no_"+rowNum).value;

		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		spRows--;
		wellArtilleryIndex--;
}
//激发参数 震源
function toDelQuakeSource(){
	var rowNum = sourceIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trSource_hr_"+rowNum);
	var dataLine = document.getElementById("trSource_"+rowNum);
	var record_id = document.getElementById("method3_no_"+rowNum).value;

		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		sourceRows--;
		sourceIndex--;
	
}
//气枪
function toDelAirGun(){
	var rowNum = aigGunIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trAirGun_hr_"+rowNum);
	var dataLine = document.getElementById("trAirGun_"+rowNum);
	var record_id = document.getElementById("method4_no_"+rowNum).value;
	
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		aigGunRows--;
		aigGunIndex--;
	
}
//井下扫描源
function toDelScanSource(){
	var rowNum = scanSourceIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trScanSource_hr_"+rowNum);
	var dataLine = document.getElementById("trScanSource_"+rowNum);
	var record_id = document.getElementById("method5_no_"+rowNum).value;
	
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		scanSourceRows--;
		scanSourceIndex--;
	
}
//井下脉冲源
function toDelPulseSource(){
	var rowNum = pulseSourceIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trPulseSource_hr_"+rowNum);
	var dataLine = document.getElementById("trPulseSource_"+rowNum);
	//var record_id = document.getElementById("method5_no_"+rowNum).value;
	
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		pulseSourceRows--;
		pulseSourceIndex--;
	
}

//接收参数
function toDelAcceptPara(){
	var rowNum = acceptParaIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trAcceptPara_hr_"+rowNum);
	var dataLine = document.getElementById("trAcceptPara_"+rowNum);
	//var record_id = document.getElementById("method5_no_"+rowNum).value;
	
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		acceptParaRows--;
		acceptParaIndex--;
	
}

//仪器参数
function toDelInstrumentPara(){
	var rowNum = instrumentParaIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trInstrumentPara_hr_"+rowNum);
	var dataLine = document.getElementById("trInstrumentPara_"+rowNum);
	//var record_id = document.getElementById("method5_no_"+rowNum).value;
	
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		instrumentParaRows--;
		instrumentParaIndex--;
	
}
//测绘平面图
function toDelPositionImage(){
	var rowNum = positionImageIndex;
	if(rowNum <= 1){
		return;	
	}	
	var line = document.getElementById("trPositionImage_hr_"+rowNum);
	var dataLine = document.getElementById("trPositionImage_"+rowNum);
	//var record_id = document.getElementById("method5_no_"+rowNum).value;
	
		line.parentNode.removeChild(line);
		dataLine.parentNode.removeChild(dataLine);
		positionImageRows--;
		positionImageIndex--;
	
}


function setReadOnly(){
	$(":input").each(function(){
		$(this).attr("disabled",true); 
	})
	<%--
	//观测系统
	for(var i=1;i<=layoutIndex;i++){
		var id="#layout_table_"+i;
		$("input[type='text']",id).each(function(i){
			this.disabled="disabled";
		})
	}
	//井炮
	for(var i=1;i<=wellArtilleryIndex;i++){
		var id="#wellArtillery_table_"+i;
		$(":input").each(function(){
			$(this).attr("disabled",true); 
		})
		//$("input[type='text']",id).each(function(){
			//$(this).attr("disabled",true); 
		//})
	
	}
	// $(".left select").attr("disabled","disabled").
	//震源
	for(var i=1;i<=sourceIndex;i++){
		var id="#source_table_"+i;
		$(id).each(function(i){
			this.disabled="disabled";
		})
	}
	//气枪
	for(var i=1;i<=aigGunIndex;i++){
		var id="#aigGun_table_"+i;
		$(id).each(function(i){
			this.disabled="disabled";
		})
	}
	//井下扫描源
	for(var i=1;i<=scanSourceIndex;i++){
		var id="#scanSource_table_"+i;
		$("input[type='text']",id).each(function(i){
			this.disabled="disabled";
		})
	}
	//井下脉冲源
	for(var i=1;i<=pulseSourceIndex;i++){
		var id="#pulseSource_table_"+i;
		$("input[type='text']",id).each(function(i){
			this.disabled="disabled";
		})
	}
	//接收参数
	for(var i=1;i<=acceptParaIndex;i++){
		var id="#acceptPara_table_"+i;
		$("input[type='text']",id).each(function(i){
			this.disabled="disabled";
		})
	}
	//仪器参数
	for(var i=1;i<=instrumentParaIndex;i++){
		var id="#instrumentPara_table_"+i;
		$("input[type='text']",id).each(function(i){
			this.disabled="disabled";
		})
	}
	//测线平面位置图
	for(var i=1;i<=positionImageIndex;i++){
		var id="#positionImage_table_"+i;
		$("input[type='text']",id).each(function(i){
			this.disabled="disabled";
		})
	}
	--%>

	

	
}

//重新选择文件 清空原来的文件隐藏域
function getWsFileInfo(id){
	document.getElementById(id).value='';
}
//保存结果提示
var saveResult = "<%=saveResult%>";
if(saveResult!=null&&saveResult=="1"){
	alert("保存成功");
}

</script>
</head>
<body onload="loadData()" style="overflow-y: auto;background: #fff;">
<form id="CheckForm"  name="CheckForm" action="" enctype="multipart/form-data" method="post">



<table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table1">
<tr><td>


<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  <tr style="background-color: #97cbfd">
	<td align="left" width="90%">
		<span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">观测系统</font></span>
	<td>
	<td width="10%" align="right">
		<%if(action != "view" && !"view".equals(action)){ %>
		<table>
			<tr>
				<td><auth:ListButton functionId="" css="zj"
						event="onclick='toAddLayout()'" title="JCDP_btn_add"></auth:ListButton>
				</td>
				<td><auth:ListButton functionId="" css="sc"
						event="onclick='toDeleteLayout()'" title="JCDP_btn_edit"></auth:ListButton>
				</td>
			</tr>
		</table>
		<%} %>
	</td>
  </tr>
 </table>
 <td></tr>
 </table>
 

 
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table2">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_well_artillery"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">激发参数: 井炮激发</font></span></td>
			<td width="10%" align="right">
			<%if(action != "view" && !"view".equals(action)){ %>
			<table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddWellArtillery()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDelWellArtillery()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table>
			<%} %>	
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table3">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_quake_source"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">激发参数: 震源激发</font></span></td>
			<td width="10%" align="right">
			<%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddQuakeSource()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDelQuakeSource()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table>
			<%} %>
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table4">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_air_gun"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">激发参数: 气枪激发</font></span></td>
			<td width="10%" align="right">
			<%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddAirGun()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDelAirGun()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table>
			<%} %>
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table5">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_scan_source"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">激发参数: 井下扫描源</font></span></td>
			<td width="10%" align="right">
			<%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddScanSource()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDelScanSource()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table>
			<%} %>
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
 <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table6">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_pulse_source"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">激发参数: 井下脉冲源</font></span></td>
			<td width="10%" align="right">
			<%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddPulseSource()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDelPulseSource()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table>
			<%} %>
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
  <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table7">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_accept_para"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">接收参数</font></span></td>
			<td width="10%" align="right">
			<%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddAcceptPara()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDelAcceptPara()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table>
			<%} %>
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
   <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table8">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_instrument_para"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">仪器参数</font></td>
			<td width="10%" align="right">
			<%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddInstrumentPara()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDelInstrumentPara()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table>
			<%} %>
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
  <table  border="0" cellpadding="0" cellspacing="0" width="100%" id="table9">
	<tr><td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%" class="tab_line_height">
  			<tr style="background-color: #97cbfd">
			<td align="left" width="90%" id="td_position_image"><span>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">测线平面位置图</font></td>
			<td width="10%" align="right">
			<%if(action != "view" && !"view".equals(action)){ %><table><tr><td><auth:ListButton functionId="" css="zj" event="onclick='toAddPositionImage()'" title="JCDP_btn_add"></auth:ListButton></td>
				<td><auth:ListButton functionId="" css="sc" event="onclick='toDelPositionImage()'" title="JCDP_btn_edit"></auth:ListButton></td></tr></table>
			<%} %>
			</td>
  			</tr>
 		</table>
 	<td></tr>
 </table>
<div id="oper_div">
<%if(action != "view" && !"view".equals(action)){ %>
   	<span class="tj_btn"><a href="#" onclick="toSave()"></a></span>
<%} %>
</div>
</form>
</body>
</html>

