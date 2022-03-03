/*
 * 展示债券信息的echarts图表配置js
 */
//月份
var zq_month = [ '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12' ];

//构建两个option模板
//总览模板 title:xxx省【年份】年债券还本付息情况

var option_zl_template = {
		title : {text:'',x:30},//标题
		tooltip : { // 提示框触发方式
			trigger : 'axis',
			axisPointer:{
				type:'line'
			}
		},
		grid: {  	//设置grid位置
            top: 80,//表格距离容器上方距离
            left:80,
            right:80
        },
		legend : { // 图例
			data : [ '本金', '利息']
		},
		dataZoom: [
	        {
	            show: true,
	            type:'slider',
	            realtime: true,
	            xAxisIndex:1
	        },
	        {
	        	show:true,
	            type: 'inside',
	            realtime: true,
	            xAxisIndex:1
	        }
	    ],
		toolbox : { // 工具箱
			show : true,
			right : 50,
			feature : {
				restore : {
					show : true,
					title : '还原'
				},
				saveAsImage : {
					show : true,
					title : '保存为图片'
				},
				dataZoom: {
					show:true,
		            yAxisIndex: 'none'
		        },
		        dataView:{
		        	show:true,
		        	readOnly:true,
		        	lang:['','关闭'],
		        	optionToContent: function(opt) {
		        	    var axisDataYears = opt.xAxis[0].data;
		        	    var axisDataMonths = opt.xAxis[1].data;
		        	    var series = opt.series;
		        	    var table = '<table  rules="all" style="width:50%;border:solid #CCC 1px;margin-left:20px;font-size:20"><tbody><tr style="text-align:center">'
		        	                 + '<th>时间</td>';
		        	                 for(var i=0;i<series.length;i++){
		        	                	 table += '<th>' + series[i].name + '</th>';
		        	                 }
		        	    table += '</tr>';
		        	        for(var i=0,n = axisDataMonths.length;i<n;i++){
		        	        	 table += '<tr>'+ '<td style="text-align:center;">' +axisDataMonths[i]+ '</td>';
			        	             for(var t=0;t<series.length;t++){
		        	                	 table += '<td style="text-align:right;">' + formatNum(series[t].data[i],2) + '</td>';
		        	                 }
			        	         table += '</tr>';
		        	        }
		        	    table += '</tbody></table>';
		        	    return table;
		        	}
		        }
			}
		},
		xAxis : [ // 横坐标
				{ //显示年份
					type : 'category',
					position : 'bottom',
					show:false,
					offset:20,
					boundaryGap : true,
					axisLabel:{'interval':0},//标签全部显示
					splitLine : { // 分隔线
						show : true,
					},
					data : [] //年份数组，数据待定
				},
				{
					//显示月份
					type : 'category',
					position : 'bottom',
					boundaryGap : false,
					axisLabel:{'interval':'auto'},//标签全部显示
					splitLine:{
						show:false
					},
					axisLabel:{
						show:true,
						margin:10,
						formatter:function(value, index){
							//var date = new Date(value);  这样操作IE不兼容
							//var texts = [(date.getMonth() + 1)];
						    if (index % 12 == 0) {
						        return value;
						    }
						    return value.split('-')[1];
						}
					},
					data : []	//月份数组，数据待定
				} 
		],
		yAxis : [ // 纵坐标
		{
			type : 'value',
			boundaryGap : false,
			position : 'left',
			name : '本金（万元）',
			min :0,
		},
		{
			type : 'value',
			position : 'right',
			name : '利息（万元）',
			min	:0
		} ],
		series : [ // 数据内容数组
				{
					name : '本金',
					type : 'line',
					connectNulls: true,
					yAxisIndex : 0,
					xAxisIndex: 1,
					itemStyle:{	//设置虚线样式
						normal:{
							lineStyle:{
								type:'solid',
								width:2,
								color:'#FF0000'//红色
							}
						}
					},
					data : [] //本金数据，数据待定
				},
				{
					name : '利息',
					type : 'line',
					connectNulls: true,
					yAxisIndex : 1,
					xAxisIndex: 1,
					itemStyle:{	//设置虚线样式
						normal:{
							lineStyle:{
								type:'solid',
								width:2,
								color:'#87CEFF'//淡蓝色
							}
						}
					},
					data : []	//利息数据，数据待定
				}]
};

//分年度模板
var option_fnd_template = {
		baseOption:{
			 timeline: {
		            axisType: 'category',
		            autoPlay: false, //默认不自动播放
		            playInterval: 2000,
		            symbol:'emptyCircle',
		            symbolSize:18,
		            controlStyle:{
		            	show:true,
		            	itemSize:25
		            },
		            data: [], //数据待定
		            label: {
		            	show:true
//		                formatter : function(s) {
//		                    return (new Date(s)).getFullYear();
//		                }
		            }
		        },
		        title:{
		        	text:'', //标题待定
		        	left:30   //距离x轴初始位置30px
		        },
		        tooltip : { // 提示框触发方式
					trigger : 'axis'
				},
				legend : { // 图例
					data : [ '本金', '利息' ]
				},
			    grid: {  	//设置grid位置
		            top: 80,//表格距离容器上方距离
		            bottom: 100, //表格距离容器下方距离
		            left:80,
		            right:80
		        },
		        dataZoom: [
			        {
			            show: false,
			            type:'slider',
			            realtime: true,
			            xAxisIndex:0
			        },
			        {
			        	show:true,
			            type: 'inside',
			            realtime: true,
			            xAxisIndex:0
			        }
			    ],
				toolbox : { // 工具箱
					show : true,
					right : 50,
					feature : {
						restore : {
							show : true,
							title : '还原'
						},
						saveAsImage : {
							show : true,
							title : '保存为图片'
						},
						dataZoom: {
							show:true,
				            yAxisIndex: 'none'
				        },
				        dataView:{
				        	show:true,
				        	readOnly:true,
				        	lang:['','关闭'],
				        	optionToContent: function(opt) {
				        	    var axisDataMonths = opt.xAxis[0].data;
				        	    var series = opt.series;
				        	    var table = '<table  rules="all" style="width:50%;border:solid #CCC 1px;margin-left:20px;font-size:20"><tbody><tr style="text-align:center">'
				        	                 + '<th>时间</td>';
				        	                 for(var i=0;i<series.length;i++){
				        	                	 table += '<th>' + series[i].name + '</th>';
				        	                 }
				        	    table += '</tr>';
				        	        for(var i=0,n = axisDataMonths.length;i<n;i++){
				        	        	 table += '<tr>'+ '<td style="text-align:center;">' +axisDataMonths[i]+ '</td>';
					        	             for(var t=0;t<series.length;t++){
				        	                	 table += '<td style="text-align:right;">' + formatNum(series[t].data[i],2) + '</td>';
				        	                 }
					        	         table += '</tr>';
				        	        }
				        	    table += '</tbody></table>';
				        	    return table;
				        	}
				        }
					}
				},
				xAxis: [ //横坐标
			            {
			                'type':'category',
			                'axisLabel':{'interval':0},
			                 position : 'bottom',
			                 splitLine: {show: false},
			                'data':[]
			            }
			        ],
		        yAxis : [ // 纵坐标
					{
						type : 'value',
						position : 'left',
						name : '本金（万元）',
						min :0
					}, {
						type : 'value',
						position : 'right',
						name : '利息（万元）',
						min	:0
					} ],
				series : [ // 数据内容数组
					{
						name : '本金',
						type : 'line',
						connectNulls: true,
						yAxisIndex : 0,
						smooth:true,//设置不支持虚线显示
						itemStyle:{	//设置虚线样式
							normal:{
								lineStyle:{
									type:'solid',
									width:2,
									color:'#FF0000'//红色
								}
							}
						},
						data : [] //分年度本金数组
					},
					{
						name : '利息',
						type : 'line',
						connectNulls: true,
						yAxisIndex : 1,
						smooth:true,//设置不支持虚线显示
						itemStyle:{	//设置虚线样式
							normal:{
								lineStyle:{
									type:'solid',
									width:2,
									color:'#87CEFF'//红色
								}
							}
						},
						data : [] //分年度利息数组
				} ]
		},
		options:[],
};





/**
 * 初始化函数
 * @returns
 */
function init(qxMax_f,currentYear_f,displayYears_f,option_type_f){
	//1.加载当前年+未来30年的还本付息数据集,并将数据保存到前台
	hbfxMap = loadHbfxMap(qxMax_f + 1, currentYear_f);
	//2.初始化，加载两个option【option_zl,option_fnd】
	getOptionByDisplayYears(hbfxMap,displayYears_f,currentYear_f,false);
	//加载echarts
	if('zl' == option_type_f){//数据总览
		initECharts(option_zl);
	}else{
		initECharts(option_fnd);//分年度预览
	}
}
/**
 * 以当前年为准，计算得到年份数组
 * @param currentYear_f 当前年份
 * @param displayYears_f 要展示的年份数
 * @returns 年份数组
 */
function getYearsArray(currentYear_f,displayYears_f){
	//年份数组,未来5年，当前年+5
	var yearsArray = [];
	for (var i = 0; i < displayYears_f; i++) {
		yearsArray.push(currentYear_f + i);
	}
	return yearsArray;
}
/**
 * 获取分年度图表的option数组
 * @param displayYears_f 展示年份数
 * @param hbfxMap_f 还本付息数据集
 * @param currentYear_f 当前年
 * @returns
 */
function getSeriesArray(displayYears_f,hbfxMap_f,currentYear_f){
	//（series）数据内容数组
	var displaySeriesArray = new Array();
	// 从第二年开始，第一年的series已经在standard_option中显示了
	 for(var i=0;i<displayYears_f;i++){
		var nextNd = currentYear_f+i;
		var ndMonth = [];
		for(var j = 0;j<zq_month.length;j++){
			ndMonth.push(nextNd+'-'+zq_month[j]);
		}
		var map={
				title : {
					text : hbfxMap_f['AD_NAME']+nextNd+'年债券还本付息情况',
				},
				xAxis:{
					data:ndMonth
				},
				series : [ {
					data : hbfxMap_f[nextNd].bj,
				}, {
					data : hbfxMap_f[nextNd].lx,
				} ]
			};
		displaySeriesArray.push(map);
	 }
	 return displaySeriesArray;
}
/**
 * 
 * @param displayYears_f 展示年数
 * @param hbfxMap_f 预测前的还本付息数据源
 * @param hbfxMap_yc_f 预测后的还本付息数据源
 * @param currentYear_f	当前年
 * @returns
 */
function getSeriesArray_yc(displayYears_f,hbfxMap_f,hbfxMap_yc_f,currentYear_f){
	//（series）数据内容数组
	 var displaySeriesArray_yc = new Array();
	 for(var i=0;i<displayYears_f;i++){
		var nextNd = currentYear_f+i;
		var ndMonth = [];
		for(var j = 0;j<zq_month.length;j++){
			ndMonth.push(nextNd+'-'+zq_month[j]);
		}
		var map={
				title : {
					text : hbfxMap_f['AD_NAME']+nextNd+'年债券还本付息情况预测',
				},
				xAxis:{
					data:ndMonth
				},
				series : [ {
					data : hbfxMap_f[nextNd].bj
				}, {
					data : hbfxMap_f[nextNd].lx
				},{
					data : hbfxMap_yc_f[nextNd].bj
				},{
					data : hbfxMap_yc_f[nextNd].lx
				}]
			};
		displaySeriesArray_yc.push(map);
	 }
	 return displaySeriesArray_yc;
}
/**
 * 获取qxMax期间内的全部还本付息数据集
 * @param qxMax_f 债券期限（预测期限）最大值 当前为最大预测30年，加上当前年，共31年
 * @param currentYear_f 当前年度
 * @returns
 */
function loadHbfxMap(qxMax_f,currentYear_f){
	//年份数组
	var years = getYearsArray(currentYear_f, qxMax_f);
	//还本付息标准初始数据集map
	var hbfxMap_f = createHbfxArray(qxMax_f,currentYear_f);
	
	var form = Ext.ComponentQuery.query('#zqxxTbYcForm')[0].getForm();
	//获取发行情况
	var fxfs_id = form.findField('FXFS_ID').value;
	//获取债券类型
	var zqlx_id = form.findField('BOND_TYPE_ID').value;
	//获取债券类别
	var zqlb_id = form.findField('ZQLB_ID').value;
	//设置post请求为同步
	$.ajaxSettings.async = false;
	//发送Ajax请求，获取数据
	$.post('/getZqHbfxQK.action', {
		zq_year : years,
		'fxfs_id':fxfs_id,
		'zqlx_id':zqlx_id,
		'zqlb_id':zqlb_id
	}, function(data) {
		var result = Ext.util.JSON.decode(data);
		//循环获取每一年的还本付息情况
		for(var i=0;i<result.list.length;i++){
			var hbfxList = result.list[i];
			var data_bj = [];
			var data_lx = [];
			//年度
			var nd = hbfxList.PAY_YEAR;
			//本金数组
			data_bj.push(hbfxList.BJ_N1);
			data_bj.push(hbfxList.BJ_N2);
			data_bj.push(hbfxList.BJ_N3);
			data_bj.push(hbfxList.BJ_N4);
			data_bj.push(hbfxList.BJ_N5);
			data_bj.push(hbfxList.BJ_N6);
			data_bj.push(hbfxList.BJ_N7);
			data_bj.push(hbfxList.BJ_N8);
			data_bj.push(hbfxList.BJ_N9);
			data_bj.push(hbfxList.BJ_N10);
			data_bj.push(hbfxList.BJ_N11);
			data_bj.push(hbfxList.BJ_N12);
			//利息数组
			data_lx.push(hbfxList.LX_N1);
			data_lx.push(hbfxList.LX_N2);
			data_lx.push(hbfxList.LX_N3);
			data_lx.push(hbfxList.LX_N4);
			data_lx.push(hbfxList.LX_N5);
			data_lx.push(hbfxList.LX_N6);
			data_lx.push(hbfxList.LX_N7);
			data_lx.push(hbfxList.LX_N8);
			data_lx.push(hbfxList.LX_N9);
			data_lx.push(hbfxList.LX_N10);
			data_lx.push(hbfxList.LX_N11);
			data_lx.push(hbfxList.LX_N12);
			//添加数据
			hbfxMap_f[nd]['bj']=data_bj;
			hbfxMap_f[nd]['lx']=data_lx;
		}
		//添加区划信息
		hbfxMap_f['AD_CODE'] = AD_CODE;
		hbfxMap_f['AD_NAME'] = AD_NAME;
	});
	return hbfxMap_f;
}
/**
 * 初始化echarts
 * @param option 图表图表option
 */
function initECharts(option_f){
		// 基于准备好的dom,初始化echarts图表
		var myChart = echarts.init(document.getElementById('mainEchart'));
		// 将数据转载到echart中,true:表示清除上一次显示的数据
		myChart.setOption(option_f,true);
}
/**
 * 生成未来qxMax年债券换还本付息情况标准map，并初始化
 * @param qxMax_f 债券期限最大值
 * @param currentYear_f 当前年
 * @returns 还本付息数据集标准map
 */
function createHbfxArray(qxMax_f,currentYear_f) {
		var array = new Array(12);//生成12月份的数组,初始值为0
		for (var i = 0; i < 12; i++)
			array[i]=0;
		var map = {};//总json
		for (var i = 0; i < qxMax_f; i++) {//年
			map[currentYear_f + i] = {
				'bj' : array,
				'lx' : array
			};
		}
		return map;
}
/**
 * 预测未来几年还本付息情况
 * @param hbfxMap_yc_f 增加预测信息后的还本付息数据源
 * @returns
 */
function ycwl(hbfxMap_f, displayYears_f, currentYear_f, is_yc_f, hbfxMap_yc_f,display_type_f){
	//加载option
	getOptionByDisplayYears(hbfxMap_f, displayYears_f, currentYear_f, is_yc_f, hbfxMap_yc_f);
	//加载图表
	reloadECharts(display_type_f);
}

/**
 * 深拷贝对象的方法
 * @param obj 待拷贝对象
 * @returns
 */
function cloneObj(obj){
    if(obj === null) return null 
    if(typeof obj !== 'object') return obj;
    if(obj.constructor===Date) return new Date(obj); 
    if(obj.constructor === RegExp) return new RegExp(obj);
    var newObj = new obj.constructor ();  //保持继承链
    for (var key in obj) {
        if (obj.hasOwnProperty(key)) {   //不遍历其原型链上的属性
            var val = obj[key];
            newObj[key] = typeof val === 'object' ? arguments.callee(val) : val; // 使用arguments.callee解除与函数名的耦合
        }
    }  
    return newObj;  
}
/**
 * 刷新图表
 * @returns
 */
function reloadECharts(display_type_f){
	if(!is_yc){//总览页面
		if(display_type_f == 'zl'){
			initECharts(option_zl); //加载总览option
		}else{
			initECharts(option_fnd); //加载分年度option
		}
	}else{//债券预测页面
		if(display_type_f =='zl'){
			initECharts(option_zl_yc); //加载预测的总览option
		}else{
			initECharts(option_fnd_yc); //加载预测的分年度option
		}
	}
}

/**
 * 根据展示年数，从前台数据集中截取相应数据，并加载到option中
 * @param hbfxMap_f  未来30年的还本付息数据集
 * @param displayYears 展示年数 默认5年
 * @param is_yc 是否是预测环境，点击预测按钮后，进入预测环境
 * @param hbfxMap_yc_f 添加新增债券的还本付息数据后的预测数据集
 */
var zl_fnd_years = [];
function getOptionByDisplayYears(hbfxMap_f,displayYears_f,currentYear_f,is_yc_f,hbfxMap_yc_f){
		//构建option
		zl_fnd_years = [];
		var zl_months = [];
		//总览图表数据集，本金，利息
		var zl_bj_data = [];
		var zl_lx_data = [];
		//预测后的图表数据集，本金、利息
		var zl_bj_data_yc = [];
		var zl_lx_data_yc = [];
		var endYear = currentYear_f + displayYears_f -1;
		//总览图表标题
		var title_zl = hbfxMap_f['AD_NAME']+currentYear_f+'--'+endYear+'年债券还本付息情况';
		//分年度第一个option图表标题
		var title_fnd = hbfxMap_f['AD_NAME']+currentYear_f+'年债券还本付息情况';
		for(var i = 0;i<displayYears_f;i++){
			var displayYear = currentYear_f+i;
			zl_fnd_years.push(displayYear);
			for(var j=0;j<zq_month.length;j++){
				zl_months.push(displayYear+'-'+zq_month[j]);
				zl_bj_data.push(hbfxMap_f[displayYear]['bj'][j]);
				zl_lx_data.push(hbfxMap_f[displayYear]['lx'][j]);
				if(is_yc_f){//若是预测环境，截取相对应的数据
					zl_bj_data_yc.push(hbfxMap_yc_f[displayYear]['bj'][j]);
					zl_lx_data_yc.push(hbfxMap_yc_f[displayYear]['lx'][j]);
				}
			}
		}
		//1.配置总览option
		option_zl = cloneObj(option_zl_template);
		//配置标题
		option_zl['title']['text'] = title_zl;
		//配置x轴
			//x轴年份
		option_zl['xAxis'][0]['data'] = zl_fnd_years;
			//x轴月份
		option_zl['xAxis'][1]['data'] = zl_months;
		//配置series
			//总览本金
		option_zl['series'][0]['data'] = zl_bj_data;
			//总览利息
		option_zl['series'][1]['data'] = zl_lx_data;
		//2.配置分年度option
		option_fnd = cloneObj(option_fnd_template);
		//配置第一个option的标题
		option_fnd['baseOption']['title']['text'] = title_fnd;
		//配置时间轴
		option_fnd['baseOption']['timeline']['data'] = zl_fnd_years;
		//配置剩余分年度option
		var fnd_seriesArray = getSeriesArray(displayYears_f, hbfxMap_f, currentYear_f);
		option_fnd['options'] = fnd_seriesArray;
		//若是预测环境,则配置预测option
		if(is_yc_f){
			//配置预测本金、利息图例
			var bj_yc_serie = {
					name : '预测本金',
					type : 'line',
					connectNulls: true,
					yAxisIndex : 0,
					xAxisIndex : 1,
					smooth:false,//设置支持虚线显示
					itemStyle:{	//设置虚线样式
						normal:{
							lineStyle:{
								type:'dotted',
								width:2
							}
						}
					},
					data : zl_bj_data_yc
				};
			var lx_yc_serie = {
					name : '预测利息',
					type : 'line',
					connectNulls: true,
					yAxisIndex : 1,
					xAxisIndex : 1,
					smooth:false,//设置支持虚线显示
					itemStyle:{	//设置虚线样式
						normal:{
							lineStyle:{
								type:'dotted',
								width:2
							}
						}
					},
					data : zl_lx_data_yc
				};
			//配置预测 -总览option
			option_zl_yc = cloneObj(option_zl);
			//配置标题
			option_zl_yc['title']['text'] = title_zl+'预测';
			//配置图例显示
			option_zl_yc['legend']['data'] = [ '本金', '利息','预测本金','预测利息' ];
			//设置本金、利息的图例状态为不选中
			option_zl_yc['legend']['selected'] = {'本金':false,'利息':false};
			//设置预测本金数据
			option_zl_yc['series'].push(bj_yc_serie);
			//设置预测利息数据
			option_zl_yc['series'].push(lx_yc_serie);
			
			//配置预测 -分年度option
			option_fnd_yc = cloneObj(option_fnd);
			//配置第一个option标题
			option_fnd_yc['baseOption']['title']['text'] = title_fnd+'预测';
			//配置图例
			option_fnd_yc['baseOption']['legend']['data'] = [ '本金', '利息','预测本金','预测利息' ];
			option_fnd_yc['baseOption']['legend']['selected'] = {'本金':false,'利息':false};
			//配置预测分年度本金利息数据
			var bj_yc_serieTmp = cloneObj(bj_yc_serie);
			var lx_yc_serieTmp = cloneObj(lx_yc_serie);
			//分年度option只有一条x轴
			bj_yc_serieTmp['xAxisIndex'] = 0;
			lx_yc_serieTmp['xAxisIndex'] = 0;
			option_fnd_yc['baseOption']['series'].push(bj_yc_serieTmp);
			option_fnd_yc['baseOption']['series'].push(lx_yc_serieTmp);
			//配置剩余年度option
			var fnd_yc_seriesArray = getSeriesArray_yc(displayYears_f, hbfxMap_f, hbfxMap_yc_f, currentYear_f);
			option_fnd_yc['options'] = fnd_yc_seriesArray;
		}
}
/**
 * 刷新功能按钮状态
 */
function refreshButtonStatus(){
	//改变预测按钮状态
	Ext.ComponentQuery.query('button[name="yc"]')[0].setDisabled(is_yc);
	//改变取消预测按钮状态
	Ext.ComponentQuery.query('button[name="qxyc"]')[0].setDisabled(!is_yc);
}
/**
 * 更改form数据，实时提交数据进行预测
 * @returns
 */
function realTimeSubmit(){
	var form = Ext.ComponentQuery.query('form#zqxxTbYcForm')[0];
		if(form.isValid()){
			var fxamt = form.getForm().findField("FX_AMT").value*10000;//转换单位，亿--万
	    	var zqqx_id= form.getForm().findField("ZQQX_ID").value;//001,002
	    	var rate= form.getForm().findField("RATE").value; //年利率%
	    	var fxzq_id =  form.getForm().findField("FXZQ_ID").value;//付息方式
	    	var qxDate = format(form.getForm().findField("QX_DATE").value,'yyyy-MM-dd');
			submitZqxx(form,{
				'fxamt':fxamt,
				'zqqx_id':zqqx_id,
				'rate':rate,
				'fxzq_id':fxzq_id,
				'qxDate':qxDate,
				'number_precision':number_precision
		});
	}
}
//数据格式化 保留两位小数，数据显示千分位
function formatNum(strNum,num) {
	strNum = strNum.toFixed(num).replace(/\d(?=(\d{3})+\.)/g, '$&,');
    if(strNum.length <= 3) {
        return strNum;
    }
    if(!/^(\+|-)?(\d+)(\.\d+)?$/.test(strNum)) {
        return strNum;
    }
    var a = RegExp.$1,
        b = RegExp.$2,
        c = RegExp.$3;
    var re = new RegExp();
    re.compile("(\\d)(\\d{3})(,|$)");
    while(re.test(b)) {
        b = b.replace(re, "$1,$2$3");
    }
    return a + "" + b + "" + c;
}

