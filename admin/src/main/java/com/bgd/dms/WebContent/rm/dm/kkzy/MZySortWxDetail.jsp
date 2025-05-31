<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="java.util.Random"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
	Random r = new Random();
	int change = r.nextInt();
	String userOrgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css"
	rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript"
	src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/popup/CJL.0.1.min.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/popup/AlertBox.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript">
  function chooseOne(cb){
	  var flag=true;
	  $("input[name='rdo_entity_id'][type='checkbox']").each(function(){
			if($(this).attr("checked") ){
				flag=false;
			}
		});
	  var coding_code_id = document.getElementById("s_coding_name").value;
	  if(coding_code_id==undefined ||coding_code_id==''){
			alert("请选择一种物资类别");
			 $("input[name='rdo_entity_id'][type='checkbox']").each(function(){
					$(this).removeAttr("checked");
					
				});
			return ;
        }
	  getFusionChart();
  }
</script>
<script type="text/javascript">
function toChoseSelfNum(){
	var obj = new Object();
	var innerHtml="";
	var vReturnValue = window.showModalDialog('<%=contextPath%>/rm/dm/kkzy/selectZySelfNum.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
	if(vReturnValue!=undefined){
		$("#returnSelfs").val(vReturnValue);
		$("#s_self_num").html("");
		var self_nums=vReturnValue.split(",");
		for(var i=0;i<self_nums.length-1;i++){
			innerHtml+="<option  value='"+self_nums[i]+"'>"+self_nums[i]+"</option>";
		}
		$("#s_self_num").append(innerHtml);
		
	}
}

</script>

<title>无标题文档</title>
</head>
<body style="background: #fff; overflow-y: auto" onload="initParts()">
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

												
												<td width="39%">
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<tr>
                                                           <td  width="8%"  align="right">保养日期:</td>
															<td align="left" width="30%" ><input id="s_work_hours" style="width: 80px"
																name="s_work_hours" type="text"  readonly="readonly"/>
															<img
																src='<%=contextPath%>/images/calendar.gif'
																id='tributton_start_date' width='14' height='16'
																style='cursor: hand;'
																onmouseover='calDateSelector(s_work_hours,tributton_start_date);' />
															至
															<input id="s_work_hours_max"   style="width: 80px"
																name="s_work_hours_max" type="text"  readonly="readonly"/>
															<img src='<%=contextPath%>/images/calendar.gif'
																id='tributton_end_date' width='14' height='16'
																style='cursor: hand;'
																onmouseover='calDateSelector(s_work_hours_max,tributton_end_date);' />
															</td>
														</tr>
													</table>
												</td>
												<td width="8%" align="right">震源编号:
												<input type="hidden"  id="returnSelfs"/>
												</td>
												<td width="13%">
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td align="left" width="125px">
																<select  id="s_self_num" name="s_self_num" style="width:120px;" >
																<option value=""></option>
																</select>
																</td>
															<td align="left"><img
																src="<%=contextPath%>/images/magnifier.gif" width="16"
																height="16" style="cursor: hand;"
																onclick="toChoseSelfNum()" /></td>
														</tr>
													</table>
												</td>
												<td class="ali_cdn_name">备件类别:</td>
												<td align="left"><select id="s_coding_name"
													name="s_coding_name">
														<option value=""></option>
												</select></td>

												<td class="ali_query"><span class="cx"><a
														href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
												</td>
												<td class="ali_query"><span class="qc"><a
														href="#" onclick="clearQueryText()"
														title="JCDP_btn_submit"></a></span></td>
												 <td width="15%"></td>
							    
							   

												<!--<td class="ali_btn">
													  <span class="dc"><a href="#" onclick="exportDataDoc()" title="导出excel"></a></span>
												</td>-->

											</tr>
										</table>
									</div>
									<!--  <div class="tongyong_box_content_left"  id="chartContainer4" style="height: 250px;">
						</div>-->
									<!--  <div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			      <tr id='dev_acc_id_{dev_acc_id}' name='dev_acc_id' idinfo='{dev_acc_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{self_num}' id='rdo_entity_id_{dev_acc_id}'  onclick='chooseOne(this)'{selectflag}/>" >选择</td>
					 <td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{account_stat_desc}">资产状况</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{dev_position}">所在位置</td>
					<td class="bt_info_even" exp="{using_stat_desc}">使用情况</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>-->
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>

										<td width="99%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">
													<span class="kb"><a href="#"></a></span><a href="#">多台震源维修、更换同一个部件消耗数量统计</a><span
														class="gd"><a href="#"></a></span> <span class="dc"
														style="float: right; margin-top: -4px;"> <a
														href="#" onclick="exportDataDoc('MDFX')" title="导出excel"></a>
													</span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer1"
													style="height: 250px;"></div>
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
			
		}
	  var today=new Date();
	  var year=today.getYear();
	  var month=today.getMonth()+1;
	  var date=today.getDate();
	  var end_date;
	  if(month<10){
		  month="0"+month; 
	  }
	  if(date<10){
		  end_date=year+"-"+month+"-"+"0"+date;
	  }else{
		  end_date=year+"-"+month+"-"+date;
	  }
	 
	  var begin_date=year+"-"+month+"-"+"01";
	  $("#s_work_hours_max").val(end_date);
	  $("#s_work_hours").val(begin_date);
	//	var gson={'ifshow':'1=1'};
	//	refreshData(gson);
	}

	
	function clearQueryText(){
		document.getElementById("s_coding_name").value = '';
		document.getElementById("s_work_hours").value = '';
		document.getElementById("s_self_num").value = '';
		document.getElementById("s_work_hours_max").value = '';
		//simpleSearch();
		initParts();
		
	}
	function simpleSearch(){
		var self_num = document.getElementById("s_self_num").value;
		var coding_code_id = document.getElementById("s_coding_name").value;
		var coding_name=$("#s_coding_name").find("option:selected").text();
		var  work_hours= document.getElementById("s_work_hours").value;
		var  s_work_hours_max= document.getElementById("s_work_hours_max").value;
		
		var gson={
				'ifshow':'1=1',
				'self_num':self_num,
				'coding_code_id':coding_code_id,
				'coding_name':coding_name,
				'work_hours':work_hours,
				's_work_hours_max':s_work_hours_max
				
		};
		  if(coding_code_id==undefined ||coding_code_id==''){
				alert("请选择一种部件");
				 $("input[name='rdo_entity_id'][type='checkbox']").each(function(){
						$(this).removeAttr("checked");
						
					});
				return ;
	        }
		//refreshData(gson);
		getFusionChart();
	}
	function getFusionChart(){
		var self_num = $("#returnSelfs").val();
		var coding_code_id = document.getElementById("s_coding_name").value;
		var coding_name=$("#s_coding_name").find("option:selected").text();
		var  work_hours= document.getElementById("s_work_hours").value;
		var  s_work_hours_max= document.getElementById("s_work_hours_max").value;
		var retObj1 = jcdpCallServiceCache("EarthquakeTeamStatistics","getMZySortDetailStatistics","&projectInfoNo=<%=projectInfoNo%>&self_num="+self_num+"&coding_code_id="+coding_code_id+"&work_hours="+work_hours+"&coding_name="+coding_name+"&s_work_hours_max="+s_work_hours_max+"&change=<%=change%>");
		var dataXml1 = retObj1.dataXML;
		var myChart1 = new FusionCharts("${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "myChartId1", "100%", "250", "0", "0" );    
		myChart1.setXMLData(dataXml1);
		myChart1.render("chartContainer1");		
	}
	
	
	function exportDataDoc(exportFlag){
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		var self_num = $("#returnSelfs").val();
		var coding_code_id = document.getElementById("s_coding_name").value;
		var coding_name=$("#s_coding_name").find("option:selected").text();
		var  work_hours= document.getElementById("s_work_hours").value;
		var  s_work_hours_max= document.getElementById("s_work_hours_max").value;
		var selectDevs="";
		$("input[name='rdo_entity_id'][type='checkbox']").each(function(i){
			   
			if($(this).attr("checked")){
				
				selectDevs+=$(this).val()+",";
				flag='multi';
			}
		});
			submitStr ="projectInfoNo=<%=projectInfoNo%>&exportFlag="+exportFlag+"&self_num="+self_num+"&coding_code_id="+coding_code_id+"&work_hours="+work_hours+"&s_work_hours_max="+s_work_hours_max;
		var retObj = syncRequest("post", path, submitStr);
		var filename=retObj.excelName;
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		var showname=retObj.showName;
		showname = encodeURI(showname);
		showname = encodeURI(showname);
		window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
	}
	//function  refreshData(arrObj){
	//	var userid = '<%=userOrgId%>';
	//	var projectInfoNo='<%=projectInfoNo%>';
	//	var orgLength = userid.length;
		//var str = "";
	//	str+="select (select coding_name  from comm_coding_sort_detail c where t.using_stat = c.coding_code_id) as using_stat_desc,";
	//	str+=" (select coding_name  from comm_coding_sort_detail c  where t.tech_stat =  c.coding_code_id) as tech_stat_desc, (select org_abbreviation from comm_org_information org where t.owning_org_id=org.org_id) as owning_org_name_desc ";
	//	str+=" , t.*  , (select coding_name   from comm_coding_sort_detail co   where co.coding_code_id =  t.account_stat) as account_stat_desc from gms_device_account_dui t";
	//	str+=" left join comm_org_information f on f.org_id=t.owning_org_id ";
	//	str+="  where  t.owning_sub_id like '"+userid+"%'  and t.dev_type like 'S062301%'   and t.account_stat='0110000013000000003'  ";
	//	 if(arrObj.ifshow!=undefined && arrObj.ifshow!=''){
	//			str += "and "+arrObj.ifshow+"  ";
	//    }
	//    if(arrObj.self_num!=undefined && arrObj.self_num!=''){
	//		str += "and t.self_num like '%"+arrObj.self_num+"%'  ";
   //  }
		//str += "order by dev_type ";  
	//	cruConfig.queryStr = str;
//	queryData(cruConfig.currentPage);;
		//getFusionChart();
	//	}
	function singleMatBywxDetail(cb){
		var str=cb.split("~");
		var self_num=str[0];
		var coding_code_id=str[1];
		var bywx_begin_date=str[2];
		var bywx_end_date=str[3];
		popWindow('<%=contextPath %>/rm/dm/kkzy/popSingleMatBywxDetail.jsp?self_num='+self_num+"&coding_code_id="+coding_code_id+"&bywx_begin_date="+bywx_begin_date+"&bywx_end_date="+bywx_end_date,'800:600');
	}

</script>

<!-- 右下角弹窗 -->
<style>
.lightbox {
	width: 300px;
	background: #FFFFFF;
	border: 5px solid #ccc;
	line-height: 20px;
	display: none;
	margin: 0;
}

.lightbox dt {
	background: #f4f4f4;
	padding: 5px;
}

.lightbox dd {
	padding: 20px;
	margin: 0;
}
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
<input type="button" value=" 右下角弹窗效果 " id="idBoxOpen2"
	style="display: none;" />
<dl id="idBox2" class="lightbox">
	<dt>
		<b>工作提醒消息</b><input align="right" type="button" value="关闭"
			id="idBoxClose2" />
	</dt>
	<dd>
		<a href="<%=contextPath%>/rm/dm/devback/backPlanMainInfoList.jsp" />
		<div id="showCount"></div>
		</a> <a
			href="<%=contextPath%>/rm/dm/collectDevBack/collect_devback_main.jsp" />
		<div id="showCount2"></div>
		</a>
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
			var devCount = ""; //单台项目未返还数
			var devCollCount = ""; //批量设备在数
			var showWindow = false;
			devCount = obj.deviceCount;
			devCollCount = obj.deviceCollCount;

			if (devCount != "0" && devCount != "") {
				document.getElementById("showCount").innerText = "还有"
						+ devCount + "单台设备未进行返还,请尽快进行返还!";
				showWindow = true;
			}
			if (devCollCount != "0" && devCollCount != "") {
				document.getElementById("showCount2").innerText = "还有"
						+ devCollCount + "批量设备未进行返还,请尽快进行返还!";
				showWindow = true;
			}
			if (showWindow == true) {
				ab.show();
			}
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

