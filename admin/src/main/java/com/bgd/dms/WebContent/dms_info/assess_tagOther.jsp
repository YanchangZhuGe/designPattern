<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="/WEB-INF/tld/runqianReport.tld" prefix="report"%>
<%	 
	String thisYear = new java.text.SimpleDateFormat("yyyy").format(new Date());	 
	String contextPath = request.getContextPath();
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgstrId = user.getOrgId();
	String orgSubId = user.getSubOrgIDofAffordOrg();
	
	String startDate = new SimpleDateFormat("yyyy").format(new Date()) + "-01-01"; 
	String endDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
	
	String bywx_date_begin = request.getParameter("bywx_date_begin");
	if(null!=bywx_date_begin&&!"".equals(bywx_date_begin)){
		 startDate=bywx_date_begin;
	}
	
	String bywx_date_end=request.getParameter("bywx_date_end");
	if(null!=bywx_date_end&&!"".equals(bywx_date_end)){
		endDate= bywx_date_end;
	} 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="<%=contextPath%>/css/table_fixed.css" rel="stylesheet" type="text/css" />
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/echartsresource.jsp"%>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>物探处仪表盘</title>
</head>
<body style="overflow-y:scroll" >
<div id="list_content" >
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="3">					 
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="ali_cdn_name">开始时间：</td>
					 	    <td class="ali_cdn_input">
					 	    	<input name="start_date" id="start_date" class="input_width easyui-datebox" type="text" style="width:128px" editable="false" required/>
					 	    </td> 
					 	    <td class="ali_cdn_name">结束时间：</td>
					 	    <td class="ali_cdn_input">
					 	    	<input name="end_date" id="end_date" class="input_width easyui-datebox" type="text" style="width:128px" editable="false" required/>
					 	    </td> 
							<td class="ali_query">
							   <span class="cx"><a href="####" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
						    </td>
						    <td>&nbsp;</td>
						</tr>
			 		</table>							 
				  </td>
			</tr>
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="49%">
								<div class="tongyong_box">
								<div class="tongyong_box_title">设备项目分布</div>
								<div class="tongyong_box_content_left" id="chartContainer2" style="height: 300px;"></div>
								</div>
							</td>
							<td width="1%"></td>			 
							<td>
								<div class="tongyong_box">
								<div class="tongyong_box_title">项目费用统计</div>
								<div class="tongyong_box_content_left" id="chartContainer3" style="height: 300px;"></div>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>				
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<!-- 利用率-->
							<td width="49%" >
								<div class="tongyong_box">
								<div class="tongyong_box_title">完好率  </div>
								<div class="tongyong_box_content_left" id="chartContainer5" style="height: 300px;"></div>
								</div>
							</td>
							<td width="1%"></td>
							<td >
							<div class="tongyong_box">
								<div class="tongyong_box_title">
									<span class="kb"><a href="####"></a></span>
									<a href="####">利用率</a>
									<span class="gd"><a href="####"></a></span>
									<span class="dc" style="float: right; margin-top: -4px;"> </span>
								</div>
								<div class="tongyong_box_content_left" id="chartContainer4" style="height: 300px;"></div>
							</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>				 
			<tr>
				<td colspan="3">
					<div class="tongyong_box">
						<div class="tongyong_box_title">
							<span class="kb"><a href="####"></a></span>
							<a href="####">设备利用率</a>
							<span class="gd"><a href="####"></a></span>
			  			</div>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>开始时间:&nbsp;
						 		<input type="text" name="startdate" id="startdate" value="<%=startDate %>" class="easyui-datebox" style="width:90px" editable="false"/>
						 	</td>
						 	<td>
						 		结束时间:&nbsp;
						 		<input type="text" name="enddate" id="enddate" value="<%=endDate %>" class="easyui-datebox" style="width:90px" editable="false"/>
						 	</td>
						 	<td>						
						 		<select id="ownsubid" name="ownsubid" class="easyui-combobox" data-options="required:true,editable:false,panelHeight:'auto'" style="width:110px;" >
								<option value="C105" selected="selected">全部</option>								
								<option value="C105002">国际勘探事业部</option>								
								<option value="C105005004">长庆物探处</option>								
								<option value="C105001005">塔里木物探处</option>								
								<option value="C105001002">新疆物探处</option>								
								<option value="C105001003">吐哈物探处</option>								
								<option value="C105001004">青海物探处</option>								
								<option value="C105007">大港物探处</option>								
								<option value="C105063">辽河物探处</option>								
								<option value="C105005000">华北物探处</option>								
								<option value="C105005001">新兴物探开发处</option>								
								<option value="C105086">深海物探处</option>								
								<option value="C105006">装备服务处</option>								
							</select>
							</td>
							<td>						
						 		<select id="ifcountry" name="ifcountry" class="easyui-combobox" data-options="required:true,editable:false,panelHeight:'auto'" style="width:50px;" >
								<option value="0" selected="selected">国内</option>
								<option value="1">国外</option>
								<option value="2">全部</option>
							</select>
							</td>
							<td>
								<span>设备类型：</span>
								<input id="devtypename" name="devtypename" type="text" style="width:80px" readonly/>
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevTypeTreePage()"  />
								<input id="devtype" name="devtype" type="hidden" />
							</td>
							<td><a href="####" class="easyui-linkbutton" onclick="loadChart()"><i class="fa fa-search fa-lg"></i> 查 询&nbsp;</a> </td>
							<td><a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除&nbsp;</a> </td>
						</tr>
						<tr>
							<td colspan="8">
								<div id="chartContainer1" style="padding:1px;height:400px; " ></div>	
							</td>
						</tr>
						</table>
					</div>
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
	
	function getFusionChart(){
		$('#start_date').datebox('setValue','<%=startDate%>');
		$('#end_date').datebox('setValue','<%=endDate%>');	 
		//加载主要设备基本情况统计表
		$("#device_content tr[class!='trHeader']").remove();
	 	getAmountWhlFusionChart();
	 	getAmountXZFusionChart();	  
	}
	
	function getAmountWhlFusionChart(){			
		//设备项目分布情况
		//var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf?ChartNoDataText=无数据", "chart1", "95%", "200", "0", "0" );  
		//chart1.setXMLUrl("<%=contextPath%>/rm/dm/getDevOnProjectInfo.srq?startDate=<%=thisYear%>");
		//chart1.render("chartContainer2");
		//项目费用统计
		var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf?ChartNoDataText=无数据", "chart1", "95%", "95%", "0", "0" );    
		//var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf?ChartNoDataText=无数据", "chart1", "95%", "300", "0", "0" );    
		//chart2.setXMLUrl("<%=contextPath%>/rm/dm/getDevReoaProjectsWUTAN.srq?startDate=<%=thisYear%>");
		//chart2.render("chartContainer3");
	}
	
	function getAmountXZFusionChart(){			 
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf?ChartNoDataText=无数据", "chart1", "95%", "95%", "0", "0" ); 
			chart1.setXMLUrl("<%=contextPath%>/dms/device/getAmountWhlChartData.srq?orgSubId=<%=orgSubId%>&country=1&startDate=<%=startDate%>&endDate=<%=endDate%>&ifproduction=5110000186000000001");
			chart1.render("chartContainer5");
			
		var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column2D.swf?ChartNoDataText=无数据", "chart1", "95%", "95%", "0", "0" ); 
			chart2.setXMLUrl("<%=contextPath%>/dms/device/getUseRate.srq?orgSubId=<%=orgSubId%>&country=1&startDate=<%=startDate%>&endDate=<%=endDate%>&ifproduction=5110000186000000001");
			chart2.render("chartContainer4");		 
	}
	//分布在项目上
	function getFBFusionChart(){
		var chart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "98%", "480", "0", "0" ); 
			chart1.setXMLUrl("<%=contextPath%>/rm/dm/getDevOrgChartData.srq?parentCode=D001&ifCountry=in&analType=use&wutanorg=C105006&account_stat=0110000013000000003");
			chart1.render("chartContainer6");
		
		var chart2 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/MSColumn3D.swf", "chart1", "98%", "480", "0", "0" ); 
			chart2.setXMLUrl("<%=contextPath%>/rm/dm/getDevOrgChartData.srq?parentCode=D002&ifCountry=in&analType=use&wutanorg=C105006&account_stat=0110000013000000003");
			chart2.render("chartContainer7");
	}	 
	//parentCode：父编码，wutanorg：单位，ifCountry：国内/国外，analType：统计类型，level：编码级别
	function fusionChart(parentCode,wutanorg,ifCountry,analType,level){
		var account_stat=$('#account_stat').val();//资产状态
		popWindow('<%=contextPath %>/rm/dm/panel/poptableOfGongsi.jsp?parentCode='+parentCode+'&wutanorg='+wutanorg+'&ifCountry='+ifCountry+'&analType='+analType+'&level='+level+"&account_stat="+account_stat,'1024:580','-钻取信息显示');
	}
	 
	function changeYear(){
	    var chartReference = FusionCharts("myChartId4");     
	    var yearinfo = document.getElementsByName("yearinfo")[0].value;
	    var orgstrId='<%=orgstrId%>';
	    chartReference.setXMLUrl("<%=contextPath%>/rm/dm/getCompDevRatioChartWTNew.srq?yearinfo="+yearinfo+"&orgstrId="+orgstrId+"&drilllevel=0");
	}
	
	function popComWanhaoForMonth(obj){
	    popWindow('<%=contextPath %>/rm/dm/panel/popComMonthWanhaoLiyongDrill.jsp?monthinfo='+obj , '800:520','-钻取信息显示');
	}
	
	function changeOrgForLost(){
		 $("#chartContainer22").empty();
	     var s_org_id = document.getElementsByName("s_org_id_lost")[0].value;
	     var retObj22  = jcdpCallService("DevCommInfoSrv", "getCompEqDestroy", "orgsubid="+s_org_id);
		 var dataXml22 = retObj22.dataXML;;
		 $("#chartContainer22").append(dataXml22);
	}
	
	function changeWuTanOrg(){
		$("#device_content tr[class!='trHeader']").remove();
	     var s_org_id = document.getElementsByName("s_org_id_wutan")[0].value;
	     //getFusionChart(s_org_id);
	    //加载主要设备基本情况统计表
		loadTable(s_org_id);
	}
	
	function getRootData(){
		var userid = '<%=orgSubId%>';
		var str = "<chart>";	   
	    var retObj = jcdpCallService("DevCommInfoSrv", "getCompDevStatData", "code=060101");
	    	str += retObj.xmldata;
	    	str +="</chart>";
    	return str;
	}
	
	function getLeafData(code){
	   var userid = '<%=orgSubId%>';
	   var str = "";
	   var retObj = jcdpCallService("DevCommInfoSrv", "getCompLeafData", "userid="+userid+"&code="+code);
	   	   str = retObj.xmldata;
	   return str;
	} 
	 
	function exportDataDoc(exportFlag){
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
		//主要设备基本情况统计表
		if("zysbjbqktjb"==exportFlag){
			var s_org_id_wutan = document.getElementsByName("s_org_id_wutan")[0].value;
			if(""==s_org_id_wutan){
				s_org_id_wutan="C105";//东方公司
			}
			submitStr="orgsubId="+s_org_id_wutan+"&exportFlag="+exportFlag;
		}
		//地震仪器损失情况
		if("dzyqssqk"==exportFlag){
			var _orgId=document.getElementsByName("s_org_id_lost")[0].value;
			submitStr="orgsubId="+_orgId+"&exportFlag="+exportFlag;
		}
		//地震仪器动态情况  
		if("dzyqdtqk"==exportFlag){
			submitStr="exportFlag="+exportFlag;
		}
		//主要设备新度系数 
		if("zysbxdxs"==exportFlag){
			submitStr="exportFlag="+exportFlag;
		}
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
<script type="text/javascript">
	var myChart;
	var thisyear = '<%=thisYear %>';
	var orgsubid = '<%=orgSubId %>';
	var lastyear = parseInt(thisyear)-1;
	
	function frameSize() {
		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
		$("#ownsubid").combobox("setValue", orgsubid);
		if(orgsubid != 'C105'){
			$('#ownsubid').combobox('disable');
		}	
		checkDate();
		//为模块加载器配置echarts的路径，从当前页面链接到echarts.js，定义所需图表路径  
		require.config({  paths: {echarts: '${pageContext.request.contextPath}/js/echarts/dist' } });
		//动态加载echarts然后在回调函数中开始使用，注意保持按需加载结构定义图表路径  
		  require(['echarts','echarts/chart/bar','echarts/chart/line' ],
				 //创建ECharts图表方法  
		        function (ec,theme) {
					//基于准备好的dom,初始化echart图表  
			        myChart = ec.init(document.getElementById('chartContainer1'),theme);
			      	//加载图表
			    	loadChart();
		  });
		getFusionChart();
	});
 
	function simpleSearch(){
		var bywx_date_begin = $("#start_date").datebox('getValue');
		var bywx_date_end = $("#end_date").datebox('getValue');
	 
		if(!bywx_date_begin){
			alert('请选择开始时间');
			return;
		}
		if(!bywx_date_end){
			alert('请选择结束时间');
			return;
		}
		if(bywx_date_begin>bywx_date_end){
			alert("开始时间不能大于结束时间!");
			return;
		}
		window.location="<%=contextPath%>/dms_info/assess_tagOther.jsp?bywx_date_begin="+bywx_date_begin+"&bywx_date_end="+bywx_date_end+"&country="+$("#country").val();
	}

	function popDevList(type,project_id){		 
		popWindow('<%=contextPath%>/rm/dm/panel/devInputChartDetail.jsp?project_id='+project_id+'&deviceType='+type,'980:520','-设备列表');
	}  
	//各个项目组震源数量导出
	function exportDataDoc4(exportFlag){
		//调用导出方法
		var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
		var submitStr="";
	    	submitStr = "exportFlag="+exportFlag;
		var retObj = syncRequest("post", path, submitStr);
		var filename = retObj.excelName;
			filename = encodeURI(filename);
			filename = encodeURI(filename);
		var showname = retObj.showName;
			showname = encodeURI(showname);
			showname = encodeURI(showname);
		window.location = cruConfig.contextPath
				+ "/rm/dm/common/download_temp.jsp?filename=" + filename
				+ "&showname=" + showname;
	}
	//加载图表
	function loadChart(){
		  var url =	"${pageContext.request.contextPath}/rm/dm/ajaxRetListBySrvAndMethod.srq?JCDP_SRV_NAME=EarthquakeTeamStatistics&JCDP_OP_NAME=getDevUtilizationRate";
		  $.ajax({
		      type: "POST",
		      url:url,
		      data:{'startdate':$('#startdate').datebox('getValue'),'enddate':$('#enddate').datebox('getValue'),'ownsubid':$("#ownsubid").combobox("getValue"),'ifcountry':$("#ifcountry").combobox("getValue"),'devtype':$("#devtype").val()},
		      dataType:"json",
		      success: function(data) {
		    	  initChart(data);
		      }
		  });
	}
	//加载图表option
	function initChart(datas){	
		var arrX = [];
	    var arrS1 = [];
	    var arrS2 = [];
	    for(var i= 0; i < datas.length; i++){
	  	     arrX[i] = dateConverStr(datas[i]["hisdate"]);
	 		 arrS1[i] = parseFloat(datas[i]["userate"]);
	 		 arrS2[i] = parseFloat(datas[i]["lastuserate"]);
	    }
	    var strtext = '设备利用率展示';
	    var strsubtext = '';
	    var option = {
           title: {  
               text: strtext,  
               link: '',  
               subtext: strsubtext,  
               sublink: '',  
               x: 'left',  
               y: 'top'  
           },
           toolbox: {  
               show: true,  
               feature: {  
                   mark: {show: true},
                   dataZoom: { show: true},  
                   dataView: {show: true},  
                   magicType: {show: true, type: ['line', 'bar']},  
                   restore: {show: true},  
                   saveAsImage: {show: true}
               }  
           },
           dataZoom : {
               show : true,
               realtime : true,
               x:80,
               y:330,
               start : 0,
               end : 100
           },
           tooltip: {  
               trigger: 'axis'
           },
           legend: {  
               show: true,
               x: 'center',
               y: 'top',
               data: [thisyear+'年-利用率',lastyear+'年-利用率']
           }, 
   	       calculable : true,
   	       grid :{y2:100},
	       xAxis : [
	     	   {
                  show : true,
                  type : 'category',
	     		  data : function (){
	                  var list = [];
	                  var arrXs = arrX.toString().split(",","-1");
	      			  if(arrXs.length == 1){
	      				  var arrXs1 = arrXs[0];
	      				  list.push(arrXs1);
	      			  }else{
	      				  for(var index=0;index<arrXs.length;index++){
	      					  var arrXs1 = arrXs[index];
	      					  list.push(arrXs1);
	      				  }
	      			  }
	                  return list;
	              }(),
	     		  boundaryGap : true,//数值轴两端的空白策略	     		  
	   	    	  axisLabel : {
			          interval: '10',
			          margin: 5,
			          rotate: '0',//倾斜度 -90 至 90 默认为0
			          textStyle: {
			                fontFamily: 'sans-serif',
			                fontSize: 10,
			                fontWeight: 'bold'
			          },
			          formatter:formatLabel
	       			}
	   	    	}
	     	],
            yAxis: [  
                {  
                    show: true,  
                    type: 'value',  
                    splitArea: {show: true},
                    axisLabel : { formatter: '{value}%'}
                }  
            ],
            series: [  
                {
                    name: thisyear+'年-利用率',
                    type: 'line',
                    data:arrS1,
                    markPoint : {
                        data : [
                            {type : 'max', name: '最大值'},
                            {type : 'min', name: '最小值'}
                        ]
                    },
                    markLine : {
                        data : [
                            {type : 'average', name: '平均值'}
                        ]
                    },
                    //顶部数字展示pzr  
                    itemStyle: {
                        normal: {  
                            label: {  
                                show: false,//是否展示  
                                textStyle: {  
                                    fontWeight:'bolder',  
                                    fontSize : '12',  
                                    fontFamily : 'sans-serif'                                    
                                } 
                            }
                            //color:'#8b75fd' //柱子颜色
                        }  
                    } 
                },
                {
                    name: lastyear+'年-利用率',
                    type: 'line',
                    data:arrS2,
                    markPoint : {
                        data : [
                            {type : 'max', name: '最大值'},
                            {type : 'min', name: '最小值'}
                        ]
                    },
                    markLine : {
                        data : [
                            {type : 'average', name: '平均值'}
                        ]
                    },
                    //顶部数字展示pzr  
                    itemStyle: {
                        normal: {  
                            label: {  
                                show: false,//是否展示  
                                textStyle: {  
                                    fontWeight:'bolder',  
                                    fontSize : '12',  
                                    fontFamily : 'sans-serif'                                    
                                } 
                            }
                            //color:'#8b75fd' //柱子颜色
                        }  
                    } 
                }
            ]
   	   };
	   myChart.clear();
	   //为echarts对象加载数据
	   myChart.setOption(option); 
	}
	//点击事件
	function eConsole(param) {
	    if (typeof param.seriesIndex == 'undefined') {    
	        return;    
	    }
	    if (param.type == 'click') {    
	        alert(param.data);    
	    }
	}
	
	function formatLabel(val){
		return val.split("(").join("\n(");		 
	}
	//选择设备类型树
	function showDevTypeTreePage(){
		var returnValue={
			fkValue:"",
			value:""
		};
		window.showModalDialog("<%=contextPath%>/dmsManager/use/devOrgUseRate/selectDevTypeSub.jsp",returnValue,"");
		$("#devtypename").val(returnValue.value);
		$("#devtype").val(returnValue.fkValue);
	}
	//清空查询条件
	function clearQueryText(){
		$('#startdate').datebox('setValue', '<%=startDate %>');
		$('#enddate').datebox('setValue', '<%=endDate %>');
		$("#ownsubid").combobox("setValue", orgsubid);
		$("#ifcountry").combobox("setValue","0");
		$("#devtypename").val("");
		$("#devtype").val("");
		loadChart();
	}
	//转换日期字符串
	function dateConverStr(val){
		if(val.substring(0,1) == '0' && val.substring(2,3) == '0'){
			val = val.substring(1,2)+'月'+val.substring(3,4)+'日';
		}else if(val.substring(0,1) == '0' && val.substring(2,3) != '0'){
			val = val.substring(1,2)+'月'+val.substring(2,4)+'日';
		}else if(val.substring(0,1) != '0' && val.substring(2,3) == '0'){
			val = val.substring(0,2)+'月'+val.substring(3,4)+'日';
		}else{
			val = val.substring(0,2)+'月'+val.substring(2,4)+'日';
		}
		return val;
	}
	//日期判断
	function checkDate(){
		//检查时间
		$(".easyui-datebox").datebox({
			onSelect: function(){
				var	startTime = $("#start_date").datebox('getValue');
				var	endTime = $("#end_date").datebox('getValue');
				if(startTime!=null&&startTime!=''&&endTime!=null&&endTime!=''){
					var days=(new Date(endTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
					if(days<0){
						$.messager.alert("提示","结束日期应大于开始日期!","warning");
						$("#end_date").datebox("setValue","");
					}			
				}
			}
		});
		//禁止日期框手动输入
		$(".datebox :text").attr("readonly","readonly");
	} 
</script>
</html>
