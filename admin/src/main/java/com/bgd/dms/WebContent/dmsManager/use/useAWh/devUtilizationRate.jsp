<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String endDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	System.out.println("endDate == "+endDate);
	String thisYear = new java.text.SimpleDateFormat("yyyy").format(new Date());
	System.out.println("thisYear == "+thisYear);
	String startDate = thisYear + "-01-01";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@include file="/common/include/quotesresource.jsp"%>
	<%@include file="/common/include/echartsresource.jsp"%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.table2excel.min.js"></script>
    <style>
    #dataTable td{width:200px;border:1px solid #DDDDDD}
    #dataTable>tbody>tr:nth-child(odd) {background-color:#F9F9F9}
    </style>
<title>设备利用率展示图</title>
</head>
<body style="background:rgb(247,​ 246,​ 242)">
	<div class="easyui-layout" data-options="fit:true" >
		<div data-options="region:'north',split:true,border:false,split:false" style="height:45px;padding:5px;">
			 <div style="float:left;height:28px;">
			 &nbsp;&nbsp;
				开始时间:&nbsp;&nbsp;
			 	<input type="text" name="startdate" id="startdate" value="<%=startDate %>" class="input_width easyui-datebox" style="width:90px" editable="false"/>
			 </div>
			 <div style="float:left;height:28px;">
			 &nbsp;&nbsp;&nbsp;
				结束时间:&nbsp;&nbsp;
			 	<input type="text" name="enddate" id="enddate" value="<%=endDate %>" class="input_width easyui-datebox" style="width:90px" editable="false"/>
			 </div>
			 <div style="float:left;height:28px;">						
			 &nbsp;&nbsp;&nbsp;单位：
				<select id="ownsubid" name="ownsubid" class="select_width easyui-combobox" data-options="required:true,editable:false,panelHeight:'auto'" style="width:110px;" >
					<option value="C105" selected="selected">全部</option>								
					<option value="C105002">国际勘探事业部</option>
					<option value="C105005004">长庆物探处</option>
					<option value="C105001005">塔里木物探处</option>
					<option value="C105001002">新疆物探处</option>
					<option value="C105001003">吐哈物探处</option>
					<option value="C105001004">青海物探处</option>
					<option value="C105007">海洋物探处</option>	
					<option value="C105063">辽河物探处</option>	
					<option value="C105005000">华北物探处</option>
					<option value="C105005001">新兴物探开发处</option>
					<option value="C105087">西南物探分公司</option>
					<option value="C105092">大庆物探一公司</option>
					<option value="C105093">大庆物探二公司</option>
					<!-- <option value="C105086">深海物探处</option>	 -->
					<option value="C105006">装备服务处</option>								
				</select>
			</div>
			 <div style="float:left;height:28px;">						
			 &nbsp;&nbsp;&nbsp;国内/国外：
				<select id="ifcountry" name="ifcountry" class="select_width easyui-combobox" data-options="required:true,editable:false,panelHeight:'auto'" style="width:60px;" >
					<option value="0" selected="selected">国内</option>
					<option value="1">国外</option>
					<option value="2">全部</option>
				</select>
			</div>
			<div style="float:left;height:28px;">						
				<span>&nbsp;&nbsp;</span>
				<span>设备类型：</span>
				<input id="devtypename" name="devtypename" type="text" class="tongyong_box_title_input" style="width:80px" readonly/>
				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevTypeTreePage()"  />
				<input id="devtype" name="devtype" type="hidden" />
			</div>
			<div style="float:left;height:28px;">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="#" class="easyui-linkbutton" onclick="loadChart()"><i class="fa fa-search fa-lg"></i> 查 询&nbsp;&nbsp;</a> 
			</div>
			<div style="float:left;height:28px;">
				&nbsp;&nbsp;
				<a href="#" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除&nbsp;&nbsp;</a> 
			</div>
		</div>
	<hr style="border:10 dashed #ffffff" width="100%" />
	<div id="chartContainer1" data-options="region:'center',border:false,split:false" style="overflow:hidden;padding:1px;" > 
	</div>
</div>
</body>     
<script type="text/javascript"> 
var myChart;
var thisyear;
var orgsubid = '<%=orgSubId %>';
var lastyear ;

$(function(){
	$("#ownsubid").combobox("setValue", orgsubid);
	if(orgsubid != 'C105'){
		$('#ownsubid').combobox('disable');
	}	
	checkDate();
	thisyear=myparser($("#startdate").datebox('getValue')).getFullYear();
	lastyear=parseInt(thisyear)-1;
	//为模块加载器配置echarts的路径，从当前页面链接到echarts.js，定义所需图表路径  
	require.config({  paths: {echarts: '${pageContext.request.contextPath}/js/echarts/dist' } });
	//动态加载echarts然后在回调函数中开始使用，注意保持按需加载结构定义图表路径  
	//require(['echarts', 'echarts/theme/infographic', 'echarts/chart/bar', 'echarts/chart/line' ],
	  require(['echarts','echarts/chart/bar','echarts/chart/line' ],
			 //创建ECharts图表方法  
	        function (ec,theme) {
				//基于准备好的dom,初始化echart图表  
		        myChart = ec.init(document.getElementById('chartContainer1'),theme);
		        // 添加点击事件  
		       // var ecConfig = require('echarts/config');  
		       // myChart.on(ecConfig.EVENT.CLICK, eConsole);
		       // $("#dis_year").val(setYear());
		      
		      	//加载图表
		    	loadChart();
		    	
	  });
});
//时间转换
function myparser(s){
			if (!s) return new Date();
			var ss = (s.split('-'));
			var y = parseInt(ss[0],10);
			var m = parseInt(ss[1],10);
			var d = parseInt(ss[2],10);
			if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
				return new Date(y,m-1,d);
			} else {
				return new Date();
			}
		}
//加载图表
function loadChart(){
	var	startTime = $("#startdate").datebox('getValue');
	var	endTime = $("#enddate").datebox('getValue');
	thisyear=myparser($("#startdate").datebox('getValue')).getFullYear();
	lastyear=parseInt(thisyear)-1;
	if(startTime.substring(0,4) != endTime.substring(0,4)){
		$.messager.alert("提示","由于存在对比不能跨年查询!","warning");
		$("#startdate").datebox("setValue",'<%=startDate %>');
		$("#enddate").datebox("setValue",'<%=endDate %>');
	}else{
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
}
//加载图表option

function initChart(datas) {

    var arrX = [];
    var arrS1 = [];
    var arrS2 = [];
    for (var i = 0; i < datas.length; i++) {
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
                mark: { show: true },
                dataZoom: { show: true },
                dataView: {
                    show: true,
                    title: '导出为Excel',
                    lang: ['数据视图', '关闭', '导出'],
                    optionToContent: function (opt) {
                    	var axisData = opt.xAxis[0].data;
            			var series = opt.series;
            			var orgName = $("#ownsubid").combobox('getText');
            			var deviceType = $("#devtypename").val();

            			var tdHeaders = '<tr><td colspan=5 align="center">设备利用率展示</td></tr><tr>'; //表头
            			['物探处名称', '设备类型', '日期'].forEach(function (item) {
            				tdHeaders += '<td>' + item + '</td>';
            			});
            			series.forEach(function (item) {
            				tdHeaders += '<td>' + item.name + '</td>'; //组装表头
            			});

            			var table = '<div><table id="dataTable" class="table table-bordered table-striped table-hover" style="text-align:center"><tbody>' + tdHeaders + '</tr>';
            			var tdBodys = ''; //数据
            			for (var i = 0, l = axisData.length; i < l; i++) {
            				for (var j = 0; j < series.length; j++) {
            					tdBodys += '<td>' + series[j].data[i] + '</td>'; //组装表数据
            				}
            				if (i != 0) {
            					table += '<tr><td style="padding: 0 10px">' + axisData[i] + '</td>' + tdBodys + '</tr>';
            				} else {
            					var rowCount = axisData.length;
            					table += '<tr><td rowspan="' + rowCount + '">' + orgName + '</td><td rowspan="' + rowCount + '">' + deviceType + '</td><td style="padding: 0 10px">' + axisData[i] + '</td>' + tdBodys + '</tr>';
            				}
            				tdBodys = '';
            			}
            			table += '</tbody></table></div>';
            			return table;
                    },
                    contentToOption: function (container, option) {
                    	$("#dataTable").table2excel({
    						filename: "设备利用率.xls", 
    						preserveColors: true 
    					});
    					return option;
                    }
                },
                magicType: { show: true, type: ['line', 'bar'] },
                restore: { show: true },
                saveAsImage: { show: true }
            }
        },
        dataZoom: {
            show: true,
            realtime: true,
            x: 80,
            y: 470,
            start: 0,
            end: 100
        },
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            show: true,
            x: 'center',
            y: 'top',
            data: [thisyear + '年-利用率', lastyear + '年-利用率']
        },
        calculable: true,
        grid: { y2: 100 },
        xAxis: [
            {
                show: true,
                type: 'category',
                data: function () {
                    var list = [];
                    var arrXs = arrX.toString().split(",", "-1");
                    if (arrXs.length == 1) {
                        var arrXs1 = arrXs[0];
                        list.push(arrXs1);
                    } else {
                        for (var index = 0; index < arrXs.length; index++) {
                            var arrXs1 = arrXs[index];
                            list.push(arrXs1);
                        }
                    }
                    return list;
                }(),
                boundaryGap: true,//数值轴两端的空白策略	     		  
                axisLabel: {
                    interval: '10',
                    margin: 5,
                    rotate: '0',//倾斜度 -90 至 90 默认为0
                    textStyle: {
                        fontFamily: 'sans-serif',
                        fontSize: 10,
                        fontWeight: 'bold'
                    },
                    formatter: formatLabel
                }
            }
        ],
        yAxis: [
            {
                show: true,
                type: 'value',
                splitArea: { show: true },
                axisLabel: { formatter: '{value}%' }
            }
        ],
        series: [
            {
                name: thisyear + '年-利用率',
                type: 'line',
                data: arrS1,
                markPoint: {
                    data: [
                        { type: 'max', name: '最大值' },
                        { type: 'min', name: '最小值' }
                    ]
                },
                markLine: {
                    data: [
                        { type: 'average', name: '平均值' }
                    ]
                },
                //顶部数字展示pzr  
                itemStyle: {
                    normal: {
                        label: {
                            show: false,//是否展示  
                            textStyle: {
                                fontWeight: 'bolder',
                                fontSize: '12',
                                fontFamily: 'sans-serif'
                            }
                        }
                        //color:'#8b75fd' //柱子颜色
                    }
                }
            },
            {
                name: lastyear + '年-利用率',
                type: 'line',
                data: arrS2,
                markPoint: {
                    data: [
                        { type: 'max', name: '最大值' },
                        { type: 'min', name: '最小值' }
                    ]
                },
                markLine: {
                    data: [
                        { type: 'average', name: '平均值' }
                    ]
                },
                //顶部数字展示pzr  
                itemStyle: {
                    normal: {
                        label: {
                            show: false,//是否展示  
                            textStyle: {
                                fontWeight: 'bolder',
                                fontSize: '12',
                                fontFamily: 'sans-serif'
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
				var	startTime = $("#startdate").datebox('getValue');
				var	endTime = $("#enddate").datebox('getValue');
				//if(startTime.substring(0,4) != thisyear){
				//	$.messager.alert("提示","只能选择当年日期!","warning");
				//	$("#startdate").datebox("setValue",'<%=startDate %>');
				//}else if(endTime.substring(0,4) != thisyear){
				//	$.messager.alert("提示","只能选择当年日期!","warning");
				//	$("#enddate").datebox("setValue",'<%=endDate %>');
				//}
				//if(startTime.substring(0,4) != endTime.substring(0,4)){
				//	$.messager.alert("提示","由于存在对比不能跨年查询!","warning");
				//	$("#startdate").datebox("setValue",'<%=startDate %>');
				//	$("#enddate").datebox("setValue",'<%=endDate %>');
			//	}else{
					if(startTime!=null&&startTime!=''&&endTime!=null&&endTime!=''){
						var days=(new Date(endTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
						if(days<0){
							$.messager.alert("提示","结束日期应大于开始日期!","warning");
							$("#enddate").datebox("setValue","");
						}			
					}
				//}
			}
		});
		//禁止日期框手动输入
		$(".datebox :text").attr("readonly","readonly");
	}
    </script>  
</html>  