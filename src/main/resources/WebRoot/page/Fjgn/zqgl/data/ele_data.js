Ext.require([
    'Ext.tree.*',
    'Ext.data.*',
    'Ext.layout.container.HBox',
    'Ext.window.MessageBox'
]);

Ext.define('treeModel', {
    extend: 'Ext.data.Model',
    fields: [
             {name:'name'},
             {name:'code'},
             {name:'id'},
             {name:'url'},
			 {name:'leaf'}
			 ]});

var today = new Date();
/*变现能力*/
var json_debt_bxnl = [
    {id: "0", code: "0", name: "好"},
    {id: "1", code: "1", name: "较好"},
    {id: "2", code: "2", name: "中"},
    {id: "3", code: "3", name: "较差"},
    {id: "4", code: "4", name: "差"}
];
/*季度*/
var json_debt_jd = [
    {"id":"001","code":"001","name":"第一季度"},
	{"id":"002","code":"002","name":"第二季度"},
	{"id":"003","code":"003","name":"第三季度"},
	{"id":"004","code":"004","name":"第四季度"}
];
/*是否判断*/
var json_debt_sf = [
	    {"id":"0","code":"0","name":"否"},
		{"id":"1","code":"1","name":"是"}
	];

/*工作流状态0*/
var json_debt_zt0 = [
	    {"id":"001","code":"001","name":"未送审"},
		{"id":"002","code":"002","name":"已送审"},
		{"id":"004","code":"004","name":"被退回"},
	    {"id":"008","code":"008","name":"曾经办"}
	];
	
/*工作流状态1*/
var json_debt_zt1 = [
        {"id":"000","code":"000","name":"全部"},
	    {"id":"001","code":"001","name":"未送审"},
		{"id":"002","code":"002","name":"已送审"},
		{"id":"008","code":"008","name":"曾经办"}
	];
/*工作流状态3*/
var json_debt_zt3 = [
	    {"id":"001","code":"001","name":"未确认"},
		{"id":"002","code":"002","name":"已确认"}
	];
	
/*缴付状态*/
var json_debt_zt4 = [
	    {"id":"001","code":"001","name":"未缴付"},
		{"id":"002","code":"002","name":"已缴付"}
	];

/*生成状态*/
var json_debt_zt5 = [
	    {"id":"001","code":"001","name":"未生成"},
		{"id":"002","code":"002","name":"已生成"}
	];
var json_xmlx_1=[
	{"id":"0","code":"0","name":"项目"},
	{"id":"1","code":"1","name":"债务"}
];


/*工作流状态6*/
var json_debt_zt6 = [
        {"id":"000","code":"000","name":"全部"},
	    {"id":"001","code":"001","name":"未送审"},
		{"id":"002","code":"002","name":"已送审"},
		{"id":"004","code":"004","name":"被退回"},
	    {"id":"008","code":"008","name":"曾经办"}
	];
/*工作流审核状态*/
var json_debt_sh = [
	    {"id":"001","code":"001","name":"未审核"},
		{"id":"002","code":"002","name":"已审核"}
	];

/*工作流上报状态*/
var json_debt_sb = [
    {"id":"001","code":"001","name":"未上报"},
    {"id":"002","code":"002","name":"已上报"},
    {"id":"004","code":"004","name":"被退回"},
    {"id":"008","code":"008","name":"曾经办"}
];

/*工作流审核状态*/
var json_debt_fs = [
	    {"id":"001","code":"001","name":"未发送"},
		{"id":"002","code":"002","name":"已发送"}
	];
/*月份*/
var json_debt_yf = [
	    {"id":"01","code":"01","name":"1月"},
		{"id":"02","code":"02","name":"2月"},
		{"id":"03","code":"03","name":"3月"},
		{"id":"04","code":"04","name":"4月"},
		{"id":"05","code":"05","name":"5月"},
		{"id":"06","code":"06","name":"6月"},
		{"id":"07","code":"07","name":"7月"},
		{"id":"08","code":"08","name":"8月"},
		{"id":"09","code":"09","name":"9月"},
		{"id":"10","code":"10","name":"10月"},
		{"id":"11","code":"11","name":"11月"},
		{"id":"12","code":"12","name":"12月"}
	];


/*日期*/
var json_debt_day = [
	    {"id":"01","code":"01","name":"1",'text':'1日'},
		{"id":"02","code":"02","name":"2",'text':'2日'},
		{"id":"03","code":"03","name":"3",'text':'3日'},
		{"id":"04","code":"04","name":"4",'text':'4日'},
		{"id":"05","code":"05","name":"5",'text':'5日'},
		{"id":"06","code":"06","name":"6",'text':'6日'},
		{"id":"07","code":"07","name":"7",'text':'7日'},
		{"id":"08","code":"08","name":"8",'text':'8日'},
		{"id":"09","code":"09","name":"9",'text':'9日'},
		{"id":"10","code":"10","name":"10",'text':'10日'},
		{"id":"11","code":"11","name":"11",'text':'11日'},
		{"id":"12","code":"12","name":"12",'text':'12日'},
		{"id":"13","code":"13","name":"13",'text':'13日'},
		{"id":"14","code":"14","name":"14",'text':'14日'},
		{"id":"15","code":"15","name":"15",'text':'15日'},
		{"id":"16","code":"16","name":"16",'text':'16日'},
		{"id":"17","code":"17","name":"17",'text':'17日'},
		{"id":"18","code":"18","name":"18",'text':'18日'},
		{"id":"19","code":"19","name":"19",'text':'19日'},
		{"id":"20","code":"20","name":"20",'text':'20日'},
		{"id":"21","code":"21","name":"21",'text':'21日'},
		{"id":"22","code":"22","name":"22",'text':'22日'},
		{"id":"23","code":"23","name":"23",'text':'23日'},
		{"id":"24","code":"24","name":"24",'text':'24日'},
		{"id":"25","code":"25","name":"25",'text':'25日'},
		{"id":"26","code":"26","name":"26",'text':'26日'},
		{"id":"27","code":"27","name":"27",'text':'27日'},
		{"id":"28","code":"28","name":"28",'text':'28日'},
		{"id":"29","code":"29","name":"29",'text':'29日'},
		{"id":"30","code":"30","name":"30",'text':'30日'},
		{"id":"31","code":"31","name":"31",'text':'31日'}
	];
	
	/*债券类别*/
	var json_debt_zqlb = [
	    {"id":"01","code":"01","name":"新增债券"},
		{"id":"02","code":"02","name":"置换债券"}
	];
	/*债券支出类型*/
	var json_debt_zqzclx = [
	    {"id":"0","code":"0","name":"新增债券支出"},
		{"id":"1","code":"1","name":"置换债券支出"}
	];

	
	/*债券类型*/
	var json_debt_zqlx = [
        {"id":"01","code":"01","name":"一般债券",leaf: true},
        {"id":"02","code":"02","name":"专项债券",leaf: true,
            children:[
                {"id":"0201","code":"0201","name":"普通专项债券",leaf: true},
                {"id":"0202","code":"0202","name":"自平衡专项债券",leaf: false,
                    children:[
                        {"id":"020201","code":"020201","name":"土地储备专项债券",leaf: true},
                        {"id":"020202","code":"020202","name":"收费公路专项债券",leaf: true},
                        {"id":"020299","code":"020299","name":"其他自平衡专项债券",leaf: true}
                    ]
				}
            ]
		}
	];

   /*债券类型2*/
var json_debt_zqlx2 = [
    {"id":"01","code":"01","name":"一般债券",leaf: true},
    {"id":"02","code":"02","name":"专项债券",leaf: true},
    {"id":"0201","code":"0201","name":"普通专项债券",leaf: true},
	{"id":"0202","code":"0202","name":"自平衡专项债券",leaf: false},
    {"id":"020201","code":"020201","name":"土地储备专项债券",leaf: true},
    {"id":"020202","code":"020202","name":"收费公路专项债券",leaf: true},
    {"id":"020299","code":"020299","name":"其他自平衡专项债券",leaf: true}
];


	/*债券品种*/
	var json_debt_zqpz = [	    
		{"id":"1","code":"1","name":"记账式",leaf: false,
			children:[				
				{"id":"11","code":"11","name":"附息",leaf: false,
					children:[
					  		{"id":"111","code":"111","name":"附息(固定利率)",leaf: true},
							{"id":"112","code":"112","name":"附息(浮动利率)",leaf: true}				          
					        ]
				}
			   ]
		}
	];
	
	/*债券期限*/
	var json_debt_zqqx = [
	    {"id":"001","code":"001","name":"1年"},
		{"id":"002","code":"002","name":"2年"},
		{"id":"003","code":"003","name":"3年"},
		{"id":"005","code":"005","name":"5年"},
		{"id":"007","code":"007","name":"7年"},
		{"id":"010","code":"010","name":"10年"}
	];

	/*发行方式*/
	var json_debt_fxfs = [
	    {"id":"01","code":"01","name":"公开发行"},
		{"id":"02","code":"02","name":"定向承销"}
	];
	
	/*付息周期*/
	var json_debt_fxzq = [
	    {"id":"00","code":"00","name":"到期一次还本还息/贴现"},
		{"id":"06","code":"06","name":"半年一次"},
		{"id":"12","code":"12","name":"1年一次"},
		{"id":"24","code":"24","name":"2年一次"},
		{"id":"36","code":"36","name":"3年一次"}
	];

	/*计息方式*/
	var json_debt_jxfs = [
	    {"id":"000","code":"000","name":"固定息"},
		{"id":"001","code":"001","name":"浮动息"}
	];

	/*债券托管人*/
	var json_debt_zqtgr = [
	    {"id":"01","code":"01","name":"中央国债登记结算有限责任公司"},
		{"id":"02","code":"02","name":"中国证券登记结算有限公司"}
	];	

	/*手续费支付依据*/
	var json_debt_sxfyj = [
	    {"id":"000","code":"000","name":"按照缴款额"},
		{"id":"001","code":"001","name":"按照承销额"},
		{"id":"002","code":"002","name":"按计划承销额"}
	];

	/*承销团*/
	var json_debt_cxt = [
	    {"id":"2016001","code":"2016001","name":"2016政府债券承销团"},
		{"id":"2016002","code":"2016002","name":"2016年政府债券（定向发行）承销团"},
		{"id":"2016003","code":"2016003","name":"2016年政府债券（公开发行）承销团"}
	];
	
	/*手续费类型*/
	var json_debt_sxflx = [
	    {"id":"001","code":"001","name":"发行手续费"},
		{"id":"002","code":"002","name":"登记托管费"}
	];
	
	/*债券披次*/
	var json_debt_zqpc = [
	    {"id":"201601","code":"201601","name":"2016年1月第一批"},
		{"id":"201602","code":"201602","name":"2016年2月第一批"},
		{"id":"201603","code":"201603","name":"2016年3月第一批"}
	];
	/*债券收入科目*/
	var json_debt_srkm = [	    
		{"id":"105","code":"105","name":"债务收入",leaf: false,
			children:[				
				{"id":"10501","code":"10501","name":"国内债务收入",leaf: false,
					children:[
					  		{"id":"1050101","code":"1050101","name":"国债发行收入",leaf: true},
							{"id":"1050104","code":"1050101","name":"地方政府债券收入",leaf: true}				          
					        ]
				}
			   ]
		}
	];
	
	/*还款类型*/
	var json_debt_hklx = [	    
		{"id":"0","code":"0","name":"本金"},
		{"id":"1","code":"1","name":"利息"}
	];	
	/*偿债资金来源*/
	var json_debt_czzjly = [
	    {"id":"0101","code":"0101","name":"一般公共预算收入"},
		{"id":"0102","code":"0102","name":"政府性基金预算收入"}
	];
/*债务基础数据，从js获取数据*/
/*function DebtEleStore(debtEle) {
    var debtStore = Ext.create('Ext.data.Store', {
		fields: ['id','code','name','text'],
	    sorters: [{
	        property: 'code',
	        direction: 'asc'
	    }],
		data: debtEle
   	});
    return debtStore;
}*/
/*债务基础数据，从数据库获取数据*/
/*function DebtEleStoreDB(debtEle){
	var debtStoreDB = new Ext.data.ArrayStore({
		autoLoad : true,
		fields: ['id','code','name'],
		sorters: [{
	        property: 'code',
	        direction: 'asc'
	    }],
		proxy: {
			type : 'ajax',
			url : 'getDebtEleValue.action?debtEle='+debtEle,
			reader : {
				type : 'json',
				root : 'list'
			}
		}
	});
	return debtStoreDB;
}*/
/*债务基础数据，下拉框形式，从后台数据库获取数据*/
/*function DebtEleStoreDB(debtEle, params) {
    var extraParams = {};
    if (typeof params == 'object') {
        extraParams = params;
    }
    var debtStoreDB = new Ext.data.ArrayStore({
        autoLoad: true,
        fields: ['id', 'code', 'name'],
        sorters: [{
            property: 'code',
            direction: 'asc'
        }],
        proxy: {
            type: 'ajax',
            url: 'getDebtEleValue.action?debtEle=' + debtEle,
            extraParams: extraParams,
            reader: {
                type: 'json',
                root: 'list'
            }
        }
    });
    return debtStoreDB;
}*/
/*债务基础数据，从数据库获取数据*/
/*function DebtEleTreeStoreJSON(debtEle){
	var debtTreeStoreDB = Ext.create('Ext.data.TreeStore',{
        model: 'treeModel',
        root: {
            id: -1, expanded: true, text: "根节点",
            children: debtEle
        },
        autoLoad: false
    });
	return debtTreeStoreDB;
}*/
/*债务基础数据，从数据库获取数据*/
/*债务基础数据，下拉树形式，从后台数据库获取数据*/
/*function DebtEleTreeStoreDB(debtEle, params) {
    var extraParams = {};
    if (typeof params == 'object') {
        extraParams = params;
    }
    extraParams.debtEle = debtEle;
    var debtTreeStoreDB = Ext.create('Ext.data.TreeStore', {
        model: 'treeModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getDebtEleTreeValue.action',
            extraParams: extraParams,
            reader: {
                type: 'json'
            }
        },
        root: {name: '全部'},
        autoLoad: true
    });
    return debtTreeStoreDB;
}*/

/*外币*/
var json_debt_wb = [
		{"id":"CNY","code":"CNY","name":"人民币(CNY)"},
		{"id":"GBP","code":"GBP","name":"英镑(GBP)"},
		{"id":"HKD","code":"HKD","name":"港币(HKD)"},
		{"id":"USD","code":"USD","name":"美元(USD)"},
		{"id":"JPY","code":"JPY","name":"日元(JPY)"},
		{"id":"EUR","code":"EUR","name":"欧元(EUR)"},
		{"id":"CHF","code":"CHF","name":"瑞士法郎(CHF)"},
		{"id":"DEM","code":"DEM","name":"德国马克(DEM)"},
		{"id":"FRF","code":"FRF","name":"法国法郎(FRF)"},
		{"id":"SGD","code":"SGD","name":"新加坡元(SGD)"},
		{"id":"AUD","code":"AUD","name":"澳大利亚元(AUD)"},
		{"id":"KRW","code":"KRW","name":"韩元(KRW)"},
		{"id":"NLG","code":"NLG","name":"荷兰盾(NLG)"},
		{"id":"SEK","code":"SEK","name":"瑞典克朗(SEK)"},
		{"id":"DKK","code":"DKK","name":"丹麦克朗(DKK)"},
		{"id":"NOK","code":"NOK","name":"挪威克朗(NOK)"},
		{"id":"ATS","code":"ATS","name":"奥地利先令(ATS)"},
		{"id":"BEF","code":"BEF","name":"比利时法郎(BEF)"},
		{"id":"ITL","code":"ITL","name":"意大利里拉(ITL)"},
		{"id":"CAD","code":"CAD","name":"加拿大元(CAD)"},
		{"id":"FIM","code":"FIM","name":"芬兰马克(FIM)"},
		{"id":"MOP","code":"MOP","name":"澳门元(MOP)"},
		{"id":"PHP","code":"PHP","name":"菲律宾比索(PHP)"},
		{"id":"THB","code":"THB","name":"泰国铢(THB)"},
		{"id":"NZD","code":"NZD","name":"新西兰元(NZD)"},
		{"id":"ASF","code":"ASF","name":"记帐瑞士法郎(ASF)"},
		{"id":"SDR","code":"SDR","name":"特别提款权(SDR)"},
		{"id":"IDR","code":"IDR","name":"印度尼西亚卢比(IDR)"},
		{"id":"INR","code":"INR","name":"印度卢比(INR)"},
		{"id":"IRR","code":"IRR","name":"伊朗里亚尔(IRR)"},
		{"id":"JOD","code":"JOD","name":"约旦第纳尔(JOD)"},
		{"id":"KWD","code":"KWD","name":"科威特第纳尔(KWD)"},
		{"id":"MXN","code":"MXN","name":"墨西哥比索(MXN)"},
		{"id":"MYR","code":"MYR","name":"马来西亚林吉特(MYR)"},
		{"id":"NRP","code":"NRP","name":"尼泊尔卢比(NRP)"},
		{"id":"PKR","code":"PKR","name":"巴基斯坦卢比(PKR)"},
		{"id":"RUB","code":"RUB","name":"俄罗斯卢布(RUB)"},
		{"id":"TWD","code":"TWD","name":"台湾元(TWD)"},
		{"id":"TZS","code":"TZS","name":"坦桑尼亚先令(TZS)"},
		{"id":"BRL","code":"BRL","name":"巴西雷亚尔(BRL)"},
		{"id":"SAR","code":"SAR","name":"沙特里亚尔(SAR)"}
	];

/*建设状态*/
var json_debt_jszt = [
	    {"id":"00","code":"00","name":"已立项审批"},
		{"id":"01","code":"01","name":"在建阶段"},
		{"id":"02","code":"02","name":"停缓建"},
		{"id":"03","code":"03","name":"已完工"},
		{"id":"04","code":"04","name":"已竣工决算"}
	];

/*立项审批依据*/
var json_debt_lxspyj = [
	    {"id":"01","code":"01","name":"发改委审批"},
		{"id":"02","code":"02","name":"发改委核准"},
		{"id":"03","code":"03","name":"发改委备案"},
		{"id":"04","code":"04","name":"政府相关文件"}
	];

/*立项审批级次*/
var json_debt_lxspjc = [
	    {"id":"01","code":"01","name":"中央级"},
		{"id":"02","code":"02","name":"省级"},
		{"id":"03","code":"03","name":"地市级"},
		{"id":"04","code":"04","name":"县区级"},
		{"id":"05","code":"05","name":"乡镇级"}
	];

/*建设性质*/
var json_debt_jsxz = [
	    {"id":"01","code":"01","name":"新建"},
		{"id":"02","code":"02","name":"改扩建"},
		{"id":"03","code":"03","name":"续建"},
		{"id":"04","code":"04","name":"维修"}
	];

/*举借类型*/
var json_debt_jjlx = [
	    {"id":"01","code":"01","name":"在建项目融资"},
		{"id":"02","code":"02","name":"存量债务调整"},
		{"id":"03","code":"03","name":"或有债务转化"}
	];

/*担保形式*/
var json_debt_dbxs = [
	    {"id":"1","code":"1","name":"签订担保协议"},
		{"id":"2","code":"2","name":"担保函"},
		{"id":"3","code":"3","name":"承诺函"},
		{"id":"4","code":"4","name":"国有资产抵押质押"},
		{"id":"5","code":"5","name":"其他"}
	];

/*行政级次*/
var json_debt_xzjc = [
	    {"id":"1","code":"1","name":"国家级",leaf: true},
		{"id":"2","code":"2","name":"省级",leaf: true},
		{"id":"3","code":"3","name":"地市级",leaf: false,
			children:[
				{"id":"31","code":"31","name":"地市级区",leaf: true},
				{"id":"32","code":"32","name":"地级市",leaf: true}
		           ]
		},
		{"id":"4","code":"4","name":"县级",leaf: false,
			children:[
				{"id":"41","code":"41","name":"市辖区",leaf: true},
				{"id":"42","code":"42","name":"县级",leaf: true}       
		             ]         
		},		
		{"id":"5","code":"5","name":"乡级",leaf: false,
			children:[
			  	{"id":"51","code":"51","name":"街道",leaf: true},
				{"id":"52","code":"52","name":"镇",leaf: true},
				{"id":"53","code":"53","name":"乡",leaf: true}		       
			          ]
		},
		{"id":"6","code":"6","name":"村级",leaf: true}
	];

/*利率调整方式*/
var json_debt_lltzfs = [
	    {"id":"1","code":"1","name":"按年"},
		{"id":"2","code":"2","name":"按半年"},
		{"id":"3","code":"3","name":"按季度"},
		{"id":"4","code":"4","name":"按月"},
		{"id":"5","code":"5","name":"即时生效"},
		{"id":"6","code":"6","name":"按举借整年"},
		{"id":"7","code":"7","name":"按举借整半年"},
		{"id":"8","code":"8","name":"按举借整季度"},
		{"id":"9","code":"9","name":"按举借整月"}
	];

/*债务项目类型*/
var json_debt_zwxmlx = [
	    {"id":"01","code":"01","name":"铁路(不含城市轨道交通)",leaf: true},
		{"id":"02","code":"02","name":"公路",leaf: false,
	    	children:[
				{"id":"0201","code":"0201","name":"高速公路",leaf: true},
				{"id":"0202","code":"0202","name":"一级公路",leaf: true},
				{"id":"0203","code":"0203","name":"二级公路",leaf: true},
				{"id":"0299","code":"0299","name":"其他公路",leaf: true}	    	          
	    	          ]
		},
		{"id":"03","code":"03","name":"机场",leaf: true},
		{"id":"04","code":"04","name":"市政建设",leaf: false,
			children:[
				{"id":"0401","code":"0401","name":"轨道交通",leaf: true},
				{"id":"0402","code":"0402","name":"道路",leaf: true},
				{"id":"0403","code":"0403","name":"桥梁",leaf: true},
				{"id":"0404","code":"0404","name":"公用事业",leaf: false,
					children:[
					  		{"id":"040401","code":"040401","name":"供水",leaf: true},
							{"id":"040402","code":"040402","name":"供气",leaf: true},
							{"id":"040403","code":"040403","name":"供热",leaf: true},
							{"id":"040404","code":"040404","name":"供电",leaf: true},
							{"id":"040405","code":"040405","name":"公交",leaf: true},
							{"id":"040406","code":"040406","name":"污水处理",leaf: true},
							{"id":"040407","code":"040407","name":"垃圾处理",leaf: true}					          
					          ]
				},
				{"id":"0405","code":"0405","name":"地下管线",leaf: false,
					children:[
							{"id":"040501","code":"040501","name":"地下管廊",leaf: true},
							{"id":"040599","code":"040599","name":"其他地下管线",leaf: true}
					          ]
				},
				{"id":"0499","code":"0499","name":"其他",leaf: true}
			          ]
		},
		{"id":"05","code":"05","name":"土地储备",leaf: true},
		{"id":"06","code":"06","name":"保障性住房",leaf: false,
			children:[
				{"id":"0601","code":"0601","name":"廉租房",leaf: true},
				{"id":"0602","code":"0602","name":"公共租赁住房",leaf: true},
				{"id":"0603","code":"0603","name":"经济适用房",leaf: true},
				{"id":"0604","code":"0604","name":"棚户区改造",leaf: true},
				{"id":"0699","code":"0699","name":"其他",leaf: true}       
			          ]
		},
		{"id":"07","code":"07","name":"生态建设和环境保护",leaf: false,
			children:[
				{"id":"0701","code":"0701","name":"污染防治",leaf: true},
				{"id":"0702","code":"0702","name":"自然生态保护",leaf: true},
				{"id":"0703","code":"0703","name":"能源综合利用",leaf: true},
				{"id":"0799","code":"0799","name":"其他",leaf: true}     
					  ]
		},
		{"id":"08","code":"08","name":"政权建设",leaf: false,
			children:[
				{"id":"0801","code":"0801","name":"党政办公场所建设",leaf: true},
				{"id":"0802","code":"0802","name":"公共安全部门场所建设",leaf: true},
				{"id":"0899","code":"0899","name":"其他",leaf: true}   
					  ]			
		},
		{"id":"09","code":"09","name":"教育",leaf: false,
			children:[
			  	{"id":"0901","code":"0901","name":"义务教育",leaf: true},
				{"id":"0902","code":"0902","name":"普通高中",leaf: true},
				{"id":"0903","code":"0903","name":"普通高校",leaf: true},
				{"id":"0999","code":"0999","name":"其他",leaf: true}       
			          ]
		},
		{"id":"10","code":"10","name":"科学",leaf: true},
		{"id":"11","code":"11","name":"文化",leaf: false,
			children:[
				{"id":"1101","code":"1101","name":"文化",leaf: true},
				{"id":"1102","code":"1102","name":"文物",leaf: true},
				{"id":"1103","code":"1103","name":"体育",leaf: true},
				{"id":"1199","code":"1199","name":"其他",leaf: true}   
			          ]
		},
		{"id":"12","code":"12","name":"医疗卫生",leaf: false,
			children:[
				{"id":"1201","code":"1201","name":"公立医院",leaf: true},
				{"id":"1202","code":"1202","name":"城市社区卫生机构",leaf: true},
				{"id":"1203","code":"1203","name":"公共卫生机构",leaf: true},
				{"id":"1204","code":"1204","name":"乡镇卫生院",leaf: true},
				{"id":"1299","code":"1299","name":"其他",leaf: true}			          
			          ]
		},
		{"id":"13","code":"13","name":"社会保障",leaf: false,
			children:[
				{"id":"1301","code":"1301","name":"就业服务机构",leaf: true},
				{"id":"1302","code":"1302","name":"社会福利机构",leaf: true},
				{"id":"1303","code":"1303","name":"残疾人事业服务机构",leaf: true},
				{"id":"1304","code":"1304","name":"社会救助机构",leaf: true},
				{"id":"1399","code":"1399","name":"其他",leaf: true}      
			          ]
		},
		{"id":"14","code":"14","name":"粮油物资储备",leaf: true},
		{"id":"15","code":"15","name":"农林水利建设",leaf: false,
			children:[
				{"id":"1501","code":"1501","name":"农业及农村建设",leaf: true},
				{"id":"1502","code":"1502","name":"林业建设",leaf: true},
				{"id":"1503","code":"1503","name":"水利建设",leaf: true},
				{"id":"1599","code":"1599","name":"其他",leaf: true}  
			          ]
		},
		{"id":"99","code":"99","name":"其他",leaf: true}
	];

/*资产类别*/
var json_debt_zclb = [
	    {"id":"01","code":"01","name":"经营性资产",leaf: false,
	    	children:[
				{"id":"0101","code":"0101","name":"非房地产资产",leaf: true},
				{"id":"0102","code":"0102","name":"房地产资产",leaf: true}	    	          
	    	          ]
	    },
		{"id":"02","code":"02","name":"储备土地资产",leaf: true},
		{"id":"03","code":"03","name":"公益性及其他资产",leaf: true}
	];

/*往来款账户*/
var json_debt_wlkzh = [
	    {"id":"01","code":"01","name":"预算内"},
		{"id":"02","code":"02","name":"融资专户"},
		{"id":"03","code":"03","name":"财政专户"}
	];

/*债务类别*/
var json_debt_zwlb = [
	    {"id":"0","code":"0","name":"政府性债务",leaf: false,
	    	children:[
               {"id":"01","code":"01","name":"政府债务",leaf: false,
            	   children:[
				     {"id":"0101","code":"0101","name":"一般债务",leaf: true},
				     {"id":"0102","code":"0102","name":"专项债务",leaf: true}                                                       
                            ]
               },
               {"id":"02","code":"02","name":"或有债务",leaf: false,
            	    children:[
            	      {"id":"0201","code":"0201","name":"政府负有担保责任的债务",leaf: true},
				      {"id":"0202","code":"0202","name":"政府可能承担一定救助责任的债务",leaf: true}                                                       
            	      	     ]
               },                                                    
               {"id":"03","code":"03","name":"已采用PPP模式的企业债务",leaf: true}
                     ]
	    },
		{"id":"1","code":"1","name":"经营性债务",leaf: true}
	];

/*往来款性质*/
var json_debt_wlkxz = [
	    {"id":"01","code":"01","name":"暂存"},
		{"id":"02","code":"02","name":"暂付"},
		{"id":"03","code":"03","name":"划款"}
	];

/*债务单位类型*/
var json_debt_zwdwlx = [
	    {"id":"1","code":"1","name":"机关",leaf: true},
		{"id":"2","code":"2","name":"事业单位",leaf: false,
	    	children:[
	    	  	{"id":"21","code":"21","name":"全额拨款事业单位",leaf: true},
	    		{"id":"22","code":"22","name":"差额拨款事业单位",leaf: true},
	    		{"id":"23","code":"23","name":"自收自支事业单位",leaf: true}	    	          
	    	          ]
		},
		{"id":"3","code":"3","name":"融资平台公司",leaf: true},
		{"id":"4","code":"4","name":"公用事业单位",leaf: false,
			children:[
			  	{"id":"41","code":"41","name":"公用事业单位(事业)",leaf: true},
				{"id":"42","code":"42","name":"公用事业单位(企业)",leaf: true}			          
			          ]
		},
		{"id":"5","code":"5","name":"国有企业(不含融资平台公司)",leaf: true},
		{"id":"9","code":"9","name":"其他",leaf: true}
	];

/*融资公司性质*/
var json_debt_rzgsxz = [
	    {"id":"1","code":"1","name":"国有独资"},
		{"id":"2","code":"2","name":"国有控股"},
		{"id":"3","code":"3","name":"国有参股"},
		{"id":"9","code":"9","name":"其他"}
	];

/*债务资金用途*/
var json_debt_zwzjyt = [
	    {"id":"01","code":"01","name":"资本性支出",leaf: false,
	    	children:[
				{"id":"0101","code":"0101","name":"公益性项目",leaf: false,
					children:[
					  		{"id":"010101","code":"010101","name":"无自身收益的公益性项目",leaf: true},
							{"id":"010102","code":"010102","name":"有自身收益的公益性项目",leaf: true}  
					          ]
				}, 
				{"id":"0102","code":"0102","name":"非公益性项目",leaf: true}
	    	          ]
	    },
		{"id":"02","code":"02","name":"非资本性支出",leaf: false,
	    	children:[
				{"id":"0201","code":"0201","name":"化解地方金融风险",leaf: false,
					children:[
							{"id":"020101","code":"020101","name":"清理农村合作基金会借款",leaf: true},
							{"id":"020102","code":"020102","name":"清理供销社股金借款",leaf: true},
							{"id":"020103","code":"020103","name":"清理城市商业银行借款",leaf: true},
							{"id":"020104","code":"020104","name":"清理城市信用社借款",leaf: true},
							{"id":"020105","code":"020105","name":"清理信托投资公司借款",leaf: true},
							{"id":"020109","code":"020109","name":"其他",leaf: true}       
					          ]
				},
				{"id":"0202","code":"0202","name":"债务还本",leaf: true},
				{"id":"0204","code":"0204","name":"短期周转金",leaf: true},
				{"id":"0299","code":"0299","name":"其他",leaf: true}
	    	          ]
		}
	];


/*费用收取方式*/
var json_debt_fysqfs = [
		{"id":"1","code":"1","name":"不收取"},
		{"id":"2","code":"2","name":"一次性收取"},
		{"id":"3","code":"3","name":"按比例"},
		{"id":"4","code":"4","name":"按定额"}
	];

/*基准利率类型*/
var json_debt_jzlllx = [
		{"id":"1","code":"1","name":"固定利率"},
		{"id":"2","code":"2","name":"浮动利率"}
	];

/*利率浮动方式*/
var json_debt_llfdfs = [
		{"id":"1","code":"1","name":"上浮"},
		{"id":"2","code":"2","name":"下浮"}
	];
/*工作流状态4*/
var json_zqgl_zt1 = [
    {id: "001", code: "001", name: "未汇总"},
    {id: "002", code: "002", name: "已汇总"}
];

var json_zqgl_jxfs=[
	{id:'001',code:'001',name:'附息式固定利率'},
	{id:'002',code:'002',name:'附息式浮动利率'},
    {id:'003',code:'003',name:'贴现式 '},
    {id:'004',code:'004',name:'利随本清'},
    {id:'005',code:'005',name:'零息式'}
];
var json_zqgl_jsfa_yflx=[
    {id:'001',code:'001',name:'平均值'},
    {id:'002',code:'002',name:'实际天数'}
];
var json_zqgl_dbfs=[
    {id:'1',code:'1',name:'有'},
    {id:'0',code:'0',name:'无'}
];

var json_zqgl_cxfs=[
    {id:'001',code:'001',name:'数量承销'},
    {id:'002',code:'002',name:'利率承销'},
    {id:'003',code:'003',name:'价格承销'},
    {id:'004',code:'004',name:'利差承销'}
];
var json_zqgl_psfx=[
    {id:'001',code:'001',name:'等比数量配售'},
    {id:'002',code:'002',name:'统一价位配售'},
    {id:'003',code:'003',name:'多重价位配售'}

];
var json_zqgl_sgjwlxx=[
    {id:'1',code:'1',name:'有'},
    {id:'0',code:'0',name:'无'}
];
var json_zqgl_ksc=[
    {id:'1',code:'1',name:'有'},
    {id:'0',code:'0',name:'无'}
];
var json_zqgl_zqfxfs=[
	{id:'0',code:'0',name:'承销发行'},
	{id:'1',code:'1',name:'公开发行'}
];
var json_zqgl_zhaobfs=[
    {id:'001',code:'001',name:'数量招标'},
    {id:'002',code:'002',name:'利率招标'},
    {id:'003',code:'003',name:'价格招标'},
    {id:'004',code:'004',name:'利差招标'}
];
var json_zqgl_zhongbfs=[
    {id:'001',code:'001',name:'等比数量中标'},
    {id:'002',code:'002',name:'统一价位中标'},
    {id:'003',code:'003',name:'多重价位中标'}
];
/*承销机构类型*/
var json_zqgl_cxjglx=[
    {id:'0',code:'0',name:'主承销商'},
    {id:'1',code:'1',name:'副主承销商'},
    {id:'2',code:'2',name:'一般承销商'},
	{id:'3',code:'3',name:'一般承销商券商'}
];
/*资金科目*/
var json_debt_zjkm = [
    {id: "0", code: "0", name: "本金"},
    {id: "1", code: "1", name: "利息"},
    {id: "2", code: "2", name: "兑付费"}
];
/*还款导入兑付费类型*/
var json_debt_hklx = [
    {id: "200", code: "200", name: "本金"},
    {id: "201", code: "201", name: "利息"},
    {id: "202", code: "202", name: "手续费"}
];