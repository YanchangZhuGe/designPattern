<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="java.util.Random"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	String userOrgId = user.getSubOrgIDofAffordOrg();
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/popup/AlertBox.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript">
function toChoseSelfNum(){
	var obj = new Object();
	var vReturnValue = window.showModalDialog('<%=contextPath%>/rm/dm/kkzy/selectZyOneSelfNum.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
	if(vReturnValue!=undefined){
		document.getElementById("s_self_num").value = vReturnValue.split("-")[0];
		document.getElementById("dai").value = vReturnValue.split("-")[1];
		
		}
}
function checkIsNumber(cb){ 
	var content=$.trim($(cb).val());
	if(content!=undefined&&(null!=content)&&(""!=content)){
		if (!(/(^[1-9]\d*$)/.test(content))){
			alert("请输入正整数");
		}
	}
	
}

</script>

<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto"  onload="initParts()" >
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
						<td width="100%" colspan="3">
						<div class="tongyong_box">
						<div class="tongyong_box_title">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
								
								<td width="8%">累计工作小时:</td>
							    <td width="17%">
							    <table width="100%" border="0" cellspacing="0" cellpadding="0">
							    <tr>
							    <td width="45%"> <input id="s_work_hours"  onblur="checkIsNumber(this)" name="s_work_hours" class="input_width" type="text"/></td>
							    <td align="left">至</td>
							    <td  width="45%"> <input id="s_work_hours_max"  onblur="checkIsNumber(this)" name="s_work_hours_max" class="input_width" type="text"/></td>
							    </tr>
							    </table>
							   </td>
							    <td class="ali_cdn_name">震源编号:</td>
							    <td  width="18%">
							    <table width="100%" border="0" cellspacing="0" cellpadding="0">
							    <tr>
							    <td width="70%" > <input id="s_self_num" name="s_self_num"  type="text" readonly="readonly"/>
							        <input  type="hidden"  id="dai" />
							    </td>
							    <td align="left"><img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="toChoseSelfNum()"/></td>
							    
							    </tr>
							    </table>
							    
							    
							    </td>

							     <td class="ali_cdn_name">备件类别:</td>
							    <td class="ali_cdn_input">
							    <select  id="s_coding_name" name="s_coding_name">
							    <option value=""></option>
							    </select>
							    </td>
							    
							    <td class="ali_query">
								    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
							    </td>
							    <td class="ali_query">
								    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_submit"></a></span>
							    </td>
							    <td width="20%"></td>
							    
							    <td class="ali_btn">
								   <!--  <span class="dc"><a href="#" onclick="exportDataDoc()" title="导出excel"></a></span>--> 
							    </td>
							  
								</tr>
							</table>
							</div>
						<!--  <div class="tongyong_box_content_left"  id="chartContainer4" style="height: 250px;">
						</div>-->
									<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			      <tr id='dev_acc_id_{dev_acc_id}' name='dev_acc_id' idinfo='{dev_acc_id}'>

					 <td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{account_stat_desc}">资产状况</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<!-- <td class="bt_info_odd" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{dev_position}">所在位置</td> -->
					<td class="bt_info_even" exp="{using_stat_desc}">使用情况</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td>
			     </tr>
			  </table>
			</div>
		<div id="fenye_box"  style="display:block">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  
			</table>
			</div>
						</div>
						</td>
					</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="99%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">单台震源某段累计工作小时的每次单个部件维修、更换情况统计</a><span class="gd"><a
							href="#"></a></span>
							<span class="dc" style="float:right;margin-top:-4px;">
								<a href="#" onclick="exportDataDoc('SDFX')" title="导出excel"></a>
							</span>
						</div>
						 <div class="tongyong_box_content_left"  id="chartContainer1" style="height: 250px;">
			 
						</div>
			
						</div>
						</td>
						
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	<td width="1%"></td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	function initParts(){
		var innerHtml;
		var partRet = jcdpCallServiceCache("EarthquakeTeamStatistics","getZyAllParts","");
		var parts=partRet.datas;
		if(null!=parts){
			$("#s_coding_name").html("");
			$("#s_coding_name").append("<option value=''></option>");
			for(var i=0;i<parts.length;i++){
				innerHtml+=" <option value ='"+parts[i].coding_code_id+"'>"+parts[i].coding_name+"</option>";
			}
			$("#s_coding_name").append(innerHtml);
			var gson={'ifshow':'1!=1'};
			refreshData(gson);
			
		}
	}
	function refreshData(arrObj){
		var userid = '<%=userOrgId%>';
		var projectInfoNo='<%=projectInfoNo%>';
		var orgLength = userid.length;
		var str = "";
		str+="select (select coding_name  from comm_coding_sort_detail c where t.using_stat = c.coding_code_id) as using_stat_desc,";
		str+=" (select coding_name  from comm_coding_sort_detail c  where t.tech_stat =  c.coding_code_id) as tech_stat_desc, (select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc ";
		str+=" , t.*  , (select coding_name   from comm_coding_sort_detail co   where co.coding_code_id =  t.account_stat) as account_stat_desc from gms_device_account t";
		str+=" left join comm_org_information f on f.org_id=t.owning_org_id ";
		str+="  where  t.owning_sub_id like '"+userid+"%'  and t.dev_type like 'S062301%'   and t.account_stat='0110000013000000003'  ";
	    if(arrObj.ifshow!=undefined && arrObj.ifshow!=''){
				str += "and "+arrObj.ifshow+"  ";
	    }
	    if(arrObj.self_num!=undefined && arrObj.self_num!=''){
			str += "  and t.self_num='"+arrObj.self_num+"'  ";
        }
	    if(arrObj.real_dev_acc_id!=undefined && arrObj.real_dev_acc_id!=''){
			str += "  and t.dev_acc_id='"+arrObj.real_dev_acc_id+"'  ";
        }
		str += "order by dev_type ";  
		cruConfig.pageSize=1;
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	function getFusionChart(){
		var self_num = document.getElementById("s_self_num").value;
		var coding_code_id = document.getElementById("s_coding_name").value;
		var coding_name=$("#s_coding_name").find("option:selected").text();
		var  work_hours= document.getElementById("s_work_hours").value;
		var  s_work_hours_max= document.getElementById("s_work_hours_max").value;
		var  real_dev_acc_id= document.getElementById("dai").value;
		
		var retObj1 = jcdpCallServiceCache("EarthquakeTeamStatistics","getZySortDetailStatistics","projectInfoNo=<%=projectInfoNo%>&self_num="+self_num+"&coding_code_id="+coding_code_id+"&work_hours="+work_hours+"&coding_name="+coding_name+"&s_work_hours_max="+s_work_hours_max+"&real_dev_acc_id="+real_dev_acc_id);
		var dataXml1 = retObj1.dataXML;
		var myChart1 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId1", "100%", "250", "0", "0" );    
		myChart1.setXMLData(dataXml1);
		myChart1.render("chartContainer1");		
	}
	
	function clearQueryText(){
		document.getElementById("s_coding_name").value = '';
		document.getElementById("s_work_hours").value = '';
		document.getElementById("s_self_num").value = '';
		document.getElementById("s_work_hours_max").value = '';
		var gson={'ifshow':'1!=1'};
		refreshData(gson);
		
	}
	
	function popSureSelfNumDetail(cb){
		var str=cb.split("~");
		var self_num=str[0];
		var work_hours=str[1];
		var work_hours_begin=str[2];
		var work_hours_end=str[3];
		var coding_code_id=str[4];
		var real_dev_acc_id=str[5];
		
		popWindow('<%=contextPath %>/rm/dm/kkzy/popWorkHourMatBywxDetail.jsp?self_num='+self_num+"&work_hours="+work_hours+"&work_hours_begin="+work_hours_begin+"&work_hours_end="+work_hours_end+"&coding_code_id="+coding_code_id+"&real_dev_acc_id="+real_dev_acc_id,'800:600');
	}
	function popCollEqStaticinfo(obj){
		//改成pop出来的形式
		popWindow('<%=contextPath %>/rm/dm/panel/popDZDCollEqStaticinfo.jsp?code='+obj,'800:600');
	}
	function simpleSearch(){
		
		var self_num = document.getElementById("s_self_num").value;
		var coding_code_id = document.getElementById("s_coding_name").value;
		var coding_name=$("#s_coding_name").find("option:selected").text();
		var  work_hours= document.getElementById("s_work_hours").value;
		var  s_work_hours_max= document.getElementById("s_work_hours_max").value;
		var  real_dev_acc_id= document.getElementById("dai").value;
	
			if(self_num==undefined ||self_num==''){
				alert("请选择震源编号");
				return ;
	          }
			if(coding_code_id==undefined ||coding_code_id==''){
				alert("请选择一种物资类别");
				return ;
	          }
         
		
		var gson={
				'ifshow':'1=1',
				'self_num':self_num,
				'coding_code_id':coding_code_id,
				'coding_name':coding_name,
				'work_hours':work_hours,
				's_work_hours_max':s_work_hours_max,
				'real_dev_acc_id':real_dev_acc_id
				
				
				
		};
		refreshData(gson);
		getFusionChart();
		}
	
	function exportDataDoc(exportFlag){
		
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		var self_num = document.getElementById("s_self_num").value;
		var coding_code_id = document.getElementById("s_coding_name").value;
		var coding_name=$("#s_coding_name").find("option:selected").text();
		var  work_hours= document.getElementById("s_work_hours").value;
		var  real_dev_acc_id= document.getElementById("dai").value;
		var  s_work_hours_max= document.getElementById("s_work_hours_max").value;
			submitStr = "projectInfoNo=<%=projectInfoNo%>&exportFlag="+exportFlag+"&self_num="+self_num+"&coding_code_id="+coding_code_id+"&work_hours="+work_hours+"&s_work_hours_max="+s_work_hours_max+"&real_dev_acc_id="+real_dev_acc_id;
		var retObj = syncRequest("post", path, submitStr);
		var filename=retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname=retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
	}
</script>

<!-- 右下角弹窗 -->
<style>
.lightbox{width:300px;background:#FFFFFF;border:5px solid #ccc;line-height:20px;display:none; margin:0;}
.lightbox dt{background:#f4f4f4;padding:5px;}
.lightbox dd{ padding:20px; margin:0;}
</style>
<!-- 右下角弹窗 -->

<script type="text/javascript">
	function showWindowSize(){
		var img = document.getElementsByName('imgId');
		for(var i=0;i<5;i++){
		img[i].width=document.body.clientWidth;
		alert(document.body.clientWidth+"+"+document.body.clientHeight);
		img[i].height=document.body.clientHeight;
		}
	}

	function setEarthFrame(){
		$("earthFrame").height=document.body.clientHeight-60;
	}
	
	
</script>
<input type="button" value=" 右下角弹窗效果 " id="idBoxOpen2" style="display:none;"/>
	<dl id="idBox2" class="lightbox">
	<dt><b>工作提醒消息</b><input align="right" type="button" value="关闭" id="idBoxClose2" /></dt>
	<dd>
		<a href="<%=contextPath %>/rm/dm/devback/backPlanMainInfoList.jsp" /><div id = "showCount"></div></a>
		<a href="<%=contextPath %>/rm/dm/collectDevBack/collect_devback_main.jsp" /><div id = "showCount2"></div></a>
	</dd>
</dl>
<script>
(function(){
//右下角消息框
var timer, target, current,
	ab = new AlertBox( "idBox2", { fixed: true,
		onShow: function(){
			clearTimeout(timer); this.box.style.bottom = this.box.style.right = 0;
		},
		onClose: function(){ clearTimeout(timer); }
	});

function hide(){
	ab.box.style.bottom = --current + "px";
	if( current <= target ){
		ab.close();
	} else {
		timer = setTimeout( hide, 10 );
	}
}

$$("idBoxClose2").onclick = function(){
	target = -ab.box.offsetHeight; current = 0; hide();
}
$$("idBoxOpen2").onclick = function(){ 
	var obj  = jcdpCallServiceCache("DevInsSrv", "getDeviceHireDeviceCount", "projectInfoNo=<%=projectInfoNo%>");
    var devCount = "";      //单台项目未返还数
    var devCollCount = "";  //批量设备在数
    var showWindow = false;
    devCount=obj.deviceCount;   
    devCollCount=obj.deviceCollCount;
    
    if(devCount !="0" && devCount !=""){
   	    document.getElementById("showCount").innerText="还有"+devCount+"单台设备未进行返还,请尽快进行返还!";
   	    showWindow = true;
    }
    if(devCollCount !="0" && devCollCount !=""){
   	    document.getElementById("showCount2").innerText="还有"+devCollCount+"批量设备未进行返还,请尽快进行返还!";
   	    showWindow = true;
    }
    if(showWindow == true){ab.show();}
	 }
})()
</script>
<script type="text/javascript">
	function frameSize() {
		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

