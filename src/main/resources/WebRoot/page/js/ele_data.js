/*是否判断*/
var json_debt_sf = [
    {id: "0", code: "0", name: "否"},
    {id: "1", code: "1", name: "是"}
];
var json_debt_yw = [
    {id: "0", code: "0", name: "无"},
    {id: "1", code: "1", name: "有"}
];
var json_debt_zwqc = [
    {id: "0", code: "0", name: "未清偿"},
    {id: "1", code: "1", name: "已清偿"}
];
/*是否判断全部*/
var json_debt_sf_all = [
    {id: "%", code: "%", name: "全部"},
    {id: "0", code: "0", name: "否"},
    {id: "1", code: "1", name: "是"}
];
/*工作流状态1*/
var json_debt_zt1 = [
    {id: "001", code: "001", name: "未送审"},
    {id: "002", code: "002", name: "已送审"},
    {id: "004", code: "004", name: "被退回"},
    {id: "008", code: "008", name: "曾经办"}
];
/*工作流状态1_1*/
var json_debt_zt1_1 = [
    {id: "001", code: "001", name: "未送审"},
    {id: "002", code: "002", name: "已送审"},
    {id: "004", code: "004", name: "被退回"},
    {id: "008", code: "008", name: "曾经办"},
    {id: "000", code: "000", name: "全部"}
];
var json_debt_zt1_2 = [
    {id: "001", code: "001", name: "未提交"},
    {id: "002", code: "002", name: "已提交"}
];

/*工作流状态2*/
var json_debt_zt2 = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"},
    {id: "004", code: "004", name: "被退回"},
    {id: "008", code: "008", name: "曾经办"}
];

/*工作流状态2*/
var json_debt_zt2_2 = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"},
    {id: "004", code: "004", name: "被退回"}
];

/*工作流状态2*/
var json_debt_zt2_3 = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"}
];
/*工作流状态2*/
var json_debt_zt2_4 = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"},
    {id: "008", code: "008", name: "曾经办"}
];
/*工作流状态2*/
var json_debt_zt2_5 = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"},
    {id: "003", code: "003", name: "未上报"}
];
/*工作流状态3*/
var json_debt_zt3 = [
    {id: "001", code: "001", name: "未复核"},
    {id: "002", code: "002", name: "已复核"},
    {id: "004", code: "004", name: "被退回"}
];
/*工作流状态3_2*/
var json_debt_zt3_2 = [
    {id: "001", code: "001", name: "未复核"},
    {id: "002", code: "002", name: "已复核"}
];
/*工作流状态4*/
var json_debt_zt4 = [
    {id: "001", code: "001", name: "未汇总"},
    {id: "002", code: "002", name: "已汇总"}
];
/*工作流状态5*/
var json_debt_zt5 = [
    {id: "001", code: "001", name: "未上报"},
    {id: "002", code: "002", name: "已上报"}
];
var json_debt_zt5_2 = [
    {id: "001", code: "001", name: "未上报"},
    {id: "002", code: "002", name: "已上报"},
    {id: "004", code: "004", name: "被退回"}
];
/*工作流状态6*/
var json_debt_zt6 = [
    {id: "001", code: "001", name: "未分配"},
    {id: "002", code: "002", name: "已分配"}
];
/*工作流状态7*/
var json_debt_zt7 = [
    {id: "001", code: "001", name: "未下达"},
    {id: "002", code: "002", name: "已下达"}
];
/*工作流状态8*/
var json_debt_zt8 = [
    {id: "001", code: "001", name: "未生成"},
    {id: "002", code: "002", name: "已生成"}
];
/*工作流状态9*/
var json_debt_zt9 = [
    {id: "001", code: "001", name: "未缴付"},
    {id: "002", code: "002", name: "已缴付"}
];
/*工作流状态9*/
var json_debt_zt10 = [
    {id: "000", code: "000", name: "未接收"},
    {id: "001", code: "001", name: "未送审"},
    {id: "002", code: "002", name: "已送审"},
    {id: "004", code: "004", name: "被退回"},
    {id: "008", code: "008", name: "曾经办"}

];
var json_debt_zt11 = [
    {"id": "001", "code": "001", "name": "未确认"},
    {"id": "002", "code": "002", "name": "已确认"}
];
/*月份-全部*/
var json_debt_yf_qb = [
    {id: "99", code: "", name: "全部"},
    {id: "01", code: "01", name: "1月"},
    {id: "02", code: "02", name: "2月"},
    {id: "03", code: "03", name: "3月"},
    {id: "04", code: "04", name: "4月"},
    {id: "05", code: "05", name: "5月"},
    {id: "06", code: "06", name: "6月"},
    {id: "07", code: "07", name: "7月"},
    {id: "08", code: "08", name: "8月"},
    {id: "09", code: "09", name: "9月"},
    {id: "10", code: "10", name: "10月"},
    {id: "11", code: "11", name: "11月"},
    {id: "12", code: "12", name: "12月"}
];
/*月份-按年*/
var json_debt_yf_nd = [
    {id: "01", code: "01", name: "1月"},
    {id: "02", code: "02", name: "2月"},
    {id: "03", code: "03", name: "3月"},
    {id: "04", code: "04", name: "4月"},
    {id: "05", code: "05", name: "5月"},
    {id: "06", code: "06", name: "6月"},
    {id: "07", code: "07", name: "7月"},
    {id: "08", code: "08", name: "8月"},
    {id: "09", code: "09", name: "9月"},
    {id: "10", code: "10", name: "10月"},
    {id: "11", code: "11", name: "11月"},
    {id: "12", code: "12", name: "12月"}
];

/*月份-按半年*/
var json_debt_yf_bn = [
    {id: "01", code: "01", name: "第1月"},
    {id: "02", code: "02", name: "第2月"},
    {id: "03", code: "03", name: "第3月"},
    {id: "04", code: "04", name: "第4月"},
    {id: "05", code: "05", name: "第5月"},
    {id: "06", code: "06", name: "第6月"}
];

/*月份-按季度*/
var json_debt_yf_jd = [
    {id: "01", code: "01", name: "第1月"},
    {id: "02", code: "02", name: "第2月"},
    {id: "03", code: "03", name: "第3月"}
];

/*日期*/
var json_debt_day = [
    {"id": "01", "code": "01", "name": "1", 'text': '1日'},
    {"id": "02", "code": "02", "name": "2", 'text': '2日'},
    {"id": "03", "code": "03", "name": "3", 'text': '3日'},
    {"id": "04", "code": "04", "name": "4", 'text': '4日'},
    {"id": "05", "code": "05", "name": "5", 'text': '5日'},
    {"id": "06", "code": "06", "name": "6", 'text': '6日'},
    {"id": "07", "code": "07", "name": "7", 'text': '7日'},
    {"id": "08", "code": "08", "name": "8", 'text': '8日'},
    {"id": "09", "code": "09", "name": "9", 'text': '9日'},
    {"id": "10", "code": "10", "name": "10", 'text': '10日'},
    {"id": "11", "code": "11", "name": "11", 'text': '11日'},
    {"id": "12", "code": "12", "name": "12", 'text': '12日'},
    {"id": "13", "code": "13", "name": "13", 'text': '13日'},
    {"id": "14", "code": "14", "name": "14", 'text': '14日'},
    {"id": "15", "code": "15", "name": "15", 'text': '15日'},
    {"id": "16", "code": "16", "name": "16", 'text': '16日'},
    {"id": "17", "code": "17", "name": "17", 'text': '17日'},
    {"id": "18", "code": "18", "name": "18", 'text': '18日'},
    {"id": "19", "code": "19", "name": "19", 'text': '19日'},
    {"id": "20", "code": "20", "name": "20", 'text': '20日'},
    {"id": "21", "code": "21", "name": "21", 'text': '21日'},
    {"id": "22", "code": "22", "name": "22", 'text': '22日'},
    {"id": "23", "code": "23", "name": "23", 'text': '23日'},
    {"id": "24", "code": "24", "name": "24", 'text': '24日'},
    {"id": "25", "code": "25", "name": "25", 'text': '25日'},
    {"id": "26", "code": "26", "name": "26", 'text': '26日'},
    {"id": "27", "code": "27", "name": "27", 'text': '27日'},
    {"id": "28", "code": "28", "name": "28", 'text': '28日'},
    {"id": "29", "code": "29", "name": "29", 'text': '29日'},
    {"id": "30", "code": "30", "name": "30", 'text': '30日'},
    {"id": "31", "code": "31", "name": "31", 'text': '31日'}
];

/*外币*/
var json_debt_wb = [
    {id: "CNY", code: "CNY", name: "人民币(CNY)"},
    {id: "GBP", code: "GBP", name: "英镑(GBP)"},
    {id: "HKD", code: "HKD", name: "港币(HKD)"},
    {id: "USD", code: "USD", name: "美元(USD)"},
    {id: "JPY", code: "JPY", name: "日元(JPY)"},
    {id: "EUR", code: "EUR", name: "欧元(EUR)"},
    {id: "CHF", code: "CHF", name: "瑞士法郎(CHF)"},
    {id: "DEM", code: "DEM", name: "德国马克(DEM)"},
    {id: "FRF", code: "FRF", name: "法国法郎(FRF)"},
    {id: "SGD", code: "SGD", name: "新加坡元(SGD)"},
    {id: "AUD", code: "AUD", name: "澳大利亚元(AUD)"},
    {id: "KRW", code: "KRW", name: "韩元(KRW)"},
    {id: "NLG", code: "NLG", name: "荷兰盾(NLG)"},
    {id: "SEK", code: "SEK", name: "瑞典克朗(SEK)"},
    {id: "DKK", code: "DKK", name: "丹麦克朗(DKK)"},
    {id: "NOK", code: "NOK", name: "挪威克朗(NOK)"},
    {id: "ATS", code: "ATS", name: "奥地利先令(ATS)"},
    {id: "BEF", code: "BEF", name: "比利时法郎(BEF)"},
    {id: "ITL", code: "ITL", name: "意大利里拉(ITL)"},
    {id: "CAD", code: "CAD", name: "加拿大元(CAD)"},
    {id: "FIM", code: "FIM", name: "芬兰马克(FIM)"},
    {id: "MOP", code: "MOP", name: "澳门元(MOP)"},
    {id: "PHP", code: "PHP", name: "菲律宾比索(PHP)"},
    {id: "THB", code: "THB", name: "泰国铢(THB)"},
    {id: "NZD", code: "NZD", name: "新西兰元(NZD)"},
    {id: "ASF", code: "ASF", name: "记帐瑞士法郎(ASF)"},
    {id: "SDR", code: "SDR", name: "特别提款权(SDR)"},
    {id: "IDR", code: "IDR", name: "印度尼西亚卢比(IDR)"},
    {id: "INR", code: "INR", name: "印度卢比(INR)"},
    {id: "IRR", code: "IRR", name: "伊朗里亚尔(IRR)"},
    {id: "JOD", code: "JOD", name: "约旦第纳尔(JOD)"},
    {id: "KWD", code: "KWD", name: "科威特第纳尔(KWD)"},
    {id: "MXN", code: "MXN", name: "墨西哥比索(MXN)"},
    {id: "MYR", code: "MYR", name: "马来西亚林吉特(MYR)"},
    {id: "NRP", code: "NRP", name: "尼泊尔卢比(NRP)"},
    {id: "PKR", code: "PKR", name: "巴基斯坦卢比(PKR)"},
    {id: "RUB", code: "RUB", name: "俄罗斯卢布(RUB)"},
    {id: "TWD", code: "TWD", name: "台湾元(TWD)"},
    {id: "TZS", code: "TZS", name: "坦桑尼亚先令(TZS)"},
    {id: "BRL", code: "BRL", name: "巴西雷亚尔(BRL)"},
    {id: "SAR", code: "SAR", name: "沙特里亚尔(SAR)"}
];
/*外币*/
var json_debt_wb1 = [
    {id: "CNY", code: "CNY", name: "人民币(CNY)"}
];
/*外币*/
var json_debt_wb2 = [
    {id: "GBP", code: "GBP", name: "英镑(GBP)"},
    {id: "HKD", code: "HKD", name: "港币(HKD)"},
    {id: "USD", code: "USD", name: "美元(USD)"},
    {id: "JPY", code: "JPY", name: "日元(JPY)"},
    {id: "EUR", code: "EUR", name: "欧元(EUR)"},
    {id: "CHF", code: "CHF", name: "瑞士法郎(CHF)"},
    {id: "DEM", code: "DEM", name: "德国马克(DEM)"},
    {id: "FRF", code: "FRF", name: "法国法郎(FRF)"},
    {id: "SGD", code: "SGD", name: "新加坡元(SGD)"},
    {id: "AUD", code: "AUD", name: "澳大利亚元(AUD)"},
    {id: "KRW", code: "KRW", name: "韩元(KRW)"},
    {id: "NLG", code: "NLG", name: "荷兰盾(NLG)"},
    {id: "SEK", code: "SEK", name: "瑞典克朗(SEK)"},
    {id: "DKK", code: "DKK", name: "丹麦克朗(DKK)"},
    {id: "NOK", code: "NOK", name: "挪威克朗(NOK)"},
    {id: "ATS", code: "ATS", name: "奥地利先令(ATS)"},
    {id: "BEF", code: "BEF", name: "比利时法郎(BEF)"},
    {id: "ITL", code: "ITL", name: "意大利里拉(ITL)"},
    {id: "CAD", code: "CAD", name: "加拿大元(CAD)"},
    {id: "FIM", code: "FIM", name: "芬兰马克(FIM)"},
    {id: "MOP", code: "MOP", name: "澳门元(MOP)"},
    {id: "PHP", code: "PHP", name: "菲律宾比索(PHP)"},
    {id: "THB", code: "THB", name: "泰国铢(THB)"},
    {id: "NZD", code: "NZD", name: "新西兰元(NZD)"},
    {id: "ASF", code: "ASF", name: "记帐瑞士法郎(ASF)"},
    {id: "SDR", code: "SDR", name: "特别提款权(SDR)"},
    {id: "IDR", code: "IDR", name: "印度尼西亚卢比(IDR)"},
    {id: "INR", code: "INR", name: "印度卢比(INR)"},
    {id: "IRR", code: "IRR", name: "伊朗里亚尔(IRR)"},
    {id: "JOD", code: "JOD", name: "约旦第纳尔(JOD)"},
    {id: "KWD", code: "KWD", name: "科威特第纳尔(KWD)"},
    {id: "MXN", code: "MXN", name: "墨西哥比索(MXN)"},
    {id: "MYR", code: "MYR", name: "马来西亚林吉特(MYR)"},
    {id: "NRP", code: "NRP", name: "尼泊尔卢比(NRP)"},
    {id: "PKR", code: "PKR", name: "巴基斯坦卢比(PKR)"},
    {id: "RUB", code: "RUB", name: "俄罗斯卢布(RUB)"},
    {id: "TWD", code: "TWD", name: "台湾元(TWD)"},
    {id: "TZS", code: "TZS", name: "坦桑尼亚先令(TZS)"},
    {id: "BRL", code: "BRL", name: "巴西雷亚尔(BRL)"},
    {id: "SAR", code: "SAR", name: "沙特里亚尔(SAR)"}
];
/*建设状态*/
var json_debt_jszt = [
    {id: "00", code: "00", name: "已立项审批"},
    {id: "01", code: "01", name: "在建阶段"},
    {id: "02", code: "02", name: "停缓建"},
    {id: "03", code: "03", name: "已完工"},
    {id: "04", code: "04", name: "已竣工决算"}
];

/*立项审批依据*/
var json_debt_lxspyj = [
    {id: "01", code: "01", name: "发改委审批"},
    {id: "02", code: "02", name: "发改委核准"},
    {id: "03", code: "03", name: "发改委备案"},
    {id: "04", code: "04", name: "政府相关文件"}
];

/*立项审批级次*/
var json_debt_lxspjc = [
    {id: "01", code: "01", name: "中央级"},
    {id: "02", code: "02", name: "省级"},
    {id: "03", code: "03", name: "地市级"},
    {id: "04", code: "04", name: "县区级"},
    {id: "05", code: "05", name: "乡镇级"}
];

/*建设性质*/
var json_debt_jsxz = [
    {id: "01", code: "01", name: "新建"},
    {id: "02", code: "02", name: "改扩建"},
    {id: "03", code: "03", name: "续建"},
    {id: "04", code: "04", name: "维修"}
];

/*举借类型*/
var json_debt_jjlx = [
    {id: "01", code: "01", name: "在建项目融资"},
    {id: "02", code: "02", name: "存量债务调整"},
    {id: "03", code: "03", name: "或有债务转化"}
];

/*债券期限*/
var json_debt_zqqx = [
    {"id": "001", "code": "001", "name": "1年"},
    {"id": "002", "code": "002", "name": "2年"},
    {"id": "003", "code": "003", "name": "3年"},
    {"id": "005", "code": "005", "name": "5年"},
    {"id": "007", "code": "007", "name": "7年"},
    {"id": "010", "code": "010", "name": "10年"}
];

/*债券期限*/
var json_debt_zqqx1 = [
    {"id": "003", "code": "003", "name": "3年"},
    {"id": "005", "code": "005", "name": "5年"},
    {"id": "007", "code": "007", "name": "7年"},
    {"id": "010", "code": "010", "name": "10年"}
];
/*债券类别*/
var json_debt_xzorzh = [
    {"id": "PLAN_ZH_AMT", "code": "PLAN_ZH_AMT", "name": "置换债券"},
    {"id": "PLAN_XZ_AMT", "code": "PLAN_XZ_AMT", "name": "新增债券"}
];


/*担保形式*/
var json_debt_dbxs = [
    {id: "1", code: "1", name: "签订担保协议"},
    {id: "2", code: "2", name: "担保函"},
    {id: "3", code: "3", name: "承诺函"},
    {id: "4", code: "4", name: "国有资产抵押质押"},
    {id: "5", code: "5", name: "其他"}
];

/*行政级次*/
var json_debt_xzjc = [
    {id: "1", code: "1", name: "国家级", leaf: true},
    {id: "2", code: "2", name: "省级", leaf: true},
    {
        id: "3", code: "3", name: "地市级", leaf: false, expanded: true,
        children: [
            {id: "31", code: "31", name: "地市级区", leaf: true},
            {id: "32", code: "32", name: "地级市", leaf: true}
        ]
    },
    {
        id: "4", code: "4", name: "县级", leaf: false, expanded: true,
        children: [
            {id: "41", code: "41", name: "市辖区", leaf: true},
            {id: "42", code: "42", name: "县级", leaf: true}
        ]
    },
    {
        id: "5", code: "5", name: "乡级", leaf: false, expanded: true,
        children: [
            {id: "51", code: "51", name: "街道", leaf: true},
            {id: "52", code: "52", name: "镇", leaf: true},
            {id: "53", code: "53", name: "乡", leaf: true}
        ]
    },
    {id: "6", code: "6", name: "村级", leaf: true}
];

/*利率调整方式*/
var json_debt_lltzfs = [
    {id: "1", code: "1", name: "按年"},
    {id: "2", code: "2", name: "按半年"},
    {id: "3", code: "3", name: "按季度"},
    {id: "4", code: "4", name: "按月"},
    {id: "5", code: "5", name: "即时生效"},
    {id: "6", code: "6", name: "按举借整年"},
    {id: "7", code: "7", name: "按举借整半年"},
    {id: "8", code: "8", name: "按举借整季度"},
    {id: "9", code: "9", name: "按举借整月"}
];

/*债务项目类型*/
var json_debt_zwxmlx = [
    {id: "01", code: "01", name: "铁路(不含城市轨道交通)", leaf: true},
    {
        id: "02", code: "02", name: "公路", leaf: false, expanded: true,
        children: [
            {id: "0201", code: "0201", name: "高速公路", leaf: true},
            {id: "0202", code: "0202", name: "一级公路", leaf: true},
            {id: "0203", code: "0203", name: "二级公路", leaf: true},
            {id: "0299", code: "0299", name: "其他公路", leaf: true}
        ]
    },
    {id: "03", code: "03", name: "机场", leaf: true},
    {
        id: "04", code: "04", name: "市政建设", leaf: false, expanded: true,
        children: [
            {id: "0401", code: "0401", name: "轨道交通", leaf: true},
            {id: "0402", code: "0402", name: "道路", leaf: true},
            {id: "0403", code: "0403", name: "桥梁", leaf: true},
            {
                id: "0404", code: "0404", name: "公用事业", leaf: false,
                children: [
                    {id: "040401", code: "040401", name: "供水", leaf: true},
                    {id: "040402", code: "040402", name: "供气", leaf: true},
                    {id: "040403", code: "040403", name: "供热", leaf: true},
                    {id: "040404", code: "040404", name: "供电", leaf: true},
                    {id: "040405", code: "040405", name: "公交", leaf: true},
                    {id: "040406", code: "040406", name: "污水处理", leaf: true},
                    {id: "040407", code: "040407", name: "垃圾处理", leaf: true}
                ]
            },
            {
                id: "0405", code: "0405", name: "地下管线", leaf: false,
                children: [
                    {id: "040501", code: "040501", name: "地下管廊", leaf: true},
                    {id: "040599", code: "040599", name: "其他地下管线", leaf: true}
                ]
            },
            {id: "0499", code: "0499", name: "其他", leaf: true}
        ]
    },
    {id: "05", code: "05", name: "土地储备", leaf: true},
    {
        id: "06", code: "06", name: "保障性住房", leaf: false, expanded: true,
        children: [
            {id: "0601", code: "0601", name: "廉租房", leaf: true},
            {id: "0602", code: "0602", name: "公共租赁住房", leaf: true},
            {id: "0603", code: "0603", name: "经济适用房", leaf: true},
            {id: "0604", code: "0604", name: "棚户区改造", leaf: true},
            {id: "0699", code: "0699", name: "其他", leaf: true}
        ]
    },
    {
        id: "07", code: "07", name: "生态建设和环境保护", leaf: false, expanded: true,
        children: [
            {id: "0701", code: "0701", name: "污染防治", leaf: true},
            {id: "0702", code: "0702", name: "自然生态保护", leaf: true},
            {id: "0703", code: "0703", name: "能源综合利用", leaf: true},
            {id: "0799", code: "0799", name: "其他", leaf: true}
        ]
    },
    {
        id: "08", code: "08", name: "政权建设", leaf: false, expanded: true,
        children: [
            {id: "0801", code: "0801", name: "党政办公场所建设", leaf: true},
            {id: "0802", code: "0802", name: "公共安全部门场所建设", leaf: true},
            {id: "0899", code: "0899", name: "其他", leaf: true}
        ]
    },
    {
        id: "09", code: "09", name: "教育", leaf: false, expanded: true,
        children: [
            {id: "0901", code: "0901", name: "义务教育", leaf: true},
            {id: "0902", code: "0902", name: "普通高中", leaf: true},
            {id: "0903", code: "0903", name: "普通高校", leaf: true},
            {id: "0999", code: "0999", name: "其他", leaf: true}
        ]
    },
    {id: "10", code: "10", name: "科学", leaf: true},
    {
        id: "11", code: "11", name: "文化", leaf: false, expanded: true,
        children: [
            {id: "1101", code: "1101", name: "文化", leaf: true},
            {id: "1102", code: "1102", name: "文物", leaf: true},
            {id: "1103", code: "1103", name: "体育", leaf: true},
            {id: "1199", code: "1199", name: "其他", leaf: true}
        ]
    },
    {
        id: "12", code: "12", name: "医疗卫生", leaf: false, expanded: true,
        children: [
            {id: "1201", code: "1201", name: "公立医院", leaf: true},
            {id: "1202", code: "1202", name: "城市社区卫生机构", leaf: true},
            {id: "1203", code: "1203", name: "公共卫生机构", leaf: true},
            {id: "1204", code: "1204", name: "乡镇卫生院", leaf: true},
            {id: "1299", code: "1299", name: "其他", leaf: true}
        ]
    },
    {
        id: "13", code: "13", name: "社会保障", leaf: false, expanded: true,
        children: [
            {id: "1301", code: "1301", name: "就业服务机构", leaf: true},
            {id: "1302", code: "1302", name: "社会福利机构", leaf: true},
            {id: "1303", code: "1303", name: "残疾人事业服务机构", leaf: true},
            {id: "1304", code: "1304", name: "社会救助机构", leaf: true},
            {id: "1399", code: "1399", name: "其他", leaf: true}
        ]
    },
    {id: "14", code: "14", name: "粮油物资储备", leaf: true},
    {
        id: "15", code: "15", name: "农林水利建设", leaf: false, expanded: true,
        children: [
            {id: "1501", code: "1501", name: "农业及农村建设", leaf: true},
            {id: "1502", code: "1502", name: "林业建设", leaf: true},
            {id: "1503", code: "1503", name: "水利建设", leaf: true},
            {id: "1599", code: "1599", name: "其他", leaf: true}
        ]
    },
    {id: "99", code: "99", name: "其他", leaf: true}
];

/*资产类别*/
var json_debt_zclb = [
    {
        id: "01", code: "01", name: "经营性资产", leaf: false, expanded: true,
        children: [
            {id: "0101", code: "0101", name: "非房地产资产", leaf: true},
            {id: "0102", code: "0102", name: "房地产资产", leaf: true}
        ]
    },
    {id: "02", code: "02", name: "储备土地资产", leaf: true},
    {id: "03", code: "03", name: "公益性及其他资产", leaf: true}
];

/*往来款账户*/
var json_debt_wlkzh = [
    {id: "01", code: "01", name: "预算内"},
    {id: "02", code: "02", name: "融资专户"},
    {id: "03", code: "03", name: "财政专户"}
];

/*债务类别*/
var json_debt_zwlb = [
    {
        id: "0", code: "0", name: "政府性债务", leaf: false, expanded: true,
        children: [
            {
                id: "01", code: "01", name: "政府债务", leaf: false, expanded: true,
                children: [
                    {id: "0101", code: "0101", name: "一般债务", leaf: true}
                ]
            },
            {
                id: "02", code: "02", name: "或有债务", leaf: false, expanded: true,
                children: [
                    {id: "0201", code: "0201", name: "政府负有担保责任的债务", leaf: true}
                ]
            }
        ]
    }
];

/*债务类别*/
var json_debt_zwlb1 = [
    {
        id: "0", code: "0", name: "政府性债务", leaf: false, expanded: true,
        children: [
            {
                id: "01", code: "01", name: "政府债务", leaf: false, expanded: true,
                children: [
                    {id: "0101", code: "0101", name: "一般债务", leaf: true},
                    {id: "0102", code: "0102", name: "专项债务", leaf: true}
                ]
            }
        ]
    }
];
/*债务类别*/
var json_debt_zwlb2 = [
    {
        id: "0", code: "0", name: "政府性债务", leaf: false, expanded: true,
        children: [
            {
                id: "02", code: "02", name: "或有债务", leaf: false, expanded: true,
                children: [
                    {id: "0201", code: "0201", name: "政府负有担保责任的债务", leaf: true},
                    {id: "0202", code: "0202", name: "政府可能承担一定救助责任的债务", leaf: true}
                ]
            }
        ]
    }
];
/*债务类别*/
var json_debt_zwlb_all = [
    {
        id: "0", code: "0", name: "政府性债务", leaf: false, expanded: true,
        children: [
            {
                id: "01", code: "01", name: "政府债务", leaf: false, expanded: true,
                children: [
                    {id: "0101", code: "0101", name: "一般债务", leaf: true},
                    {id: "0102", code: "0102", name: "专项债务", leaf: true}
                ]
            },
            {
                id: "02", code: "02", name: "或有债务", leaf: false, expanded: true,
                children: [
                    {id: "0201", code: "0201", name: "政府负有担保责任的债务", leaf: true},
                    {id: "0202", code: "0202", name: "政府可能承担一定救助责任的债务", leaf: true}
                ]
            }
        ]
    }
];


/*往来款性质*/
var json_debt_wlkxz = [
    {id: "01", code: "01", name: "暂存"},
    {id: "02", code: "02", name: "暂付"},
    {id: "03", code: "03", name: "划款"}
];

/*结息方式*/
var json_debt_jxfs = [
    {id: "1", code: "1", name: "按年"},
    {id: "2", code: "2", name: "按半年"},
    {id: "3", code: "3", name: "按季度"},
    {id: "4", code: "4", name: "按月"},
    {id: "5", code: "5", name: "到期还本付息"}
];

/*债务单位类型*/
var json_debt_zwdwlx = [
    {id: "1", code: "1", name: "机关", leaf: true},
    {
        id: "2", code: "2", name: "事业单位", leaf: false, expanded: true,
        children: [
            {id: "21", code: "21", name: "全额拨款事业单位", leaf: true},
            {id: "22", code: "22", name: "差额拨款事业单位", leaf: true},
            {id: "23", code: "23", name: "自收自支事业单位", leaf: true}
        ]
    },
    {id: "3", code: "3", name: "融资平台公司", leaf: true},
    {
        id: "4", code: "4", name: "公用事业单位", leaf: false, expanded: true,
        children: [
            {id: "41", code: "41", name: "公用事业单位(事业)", leaf: true},
            {id: "42", code: "42", name: "公用事业单位(企业)", leaf: true}
        ]
    },
    {id: "5", code: "5", name: "国有企业(不含融资平台公司)", leaf: true},
    {id: "9", code: "9", name: "其他", leaf: true}
];

/*融资公司性质*/
var json_debt_rzgsxz = [
    {id: "1", code: "1", name: "国有独资"},
    {id: "2", code: "2", name: "国有控股"},
    {id: "3", code: "3", name: "国有参股"},
    {id: "9", code: "9", name: "其他"}
];

/*债务资金用途*/
var json_debt_zwzjyt = [
    {
        id: "01", code: "01", name: "资本性支出", leaf: false, expanded: true,
        children: [
            {
                id: "0101", code: "0101", name: "公益性项目", leaf: false, expanded: true,
                children: [
                    {id: "010101", code: "010101", name: "无自身收益的公益性项目", leaf: true},
                    {id: "010102", code: "010102", name: "有自身收益的公益性项目", leaf: true}
                ]
            },
            {id: "0102", code: "0102", name: "非公益性项目", leaf: true}
        ]
    },
    {
        id: "02", code: "02", name: "非资本性支出", leaf: false, expanded: true,
        children: [
            {
                id: "0201", code: "0201", name: "化解地方金融风险", leaf: false, expanded: true,
                children: [
                    {id: "020101", code: "020101", name: "清理农村合作基金会借款", leaf: true},
                    {id: "020102", code: "020102", name: "清理供销社股金借款", leaf: true},
                    {id: "020103", code: "020103", name: "清理城市商业银行借款", leaf: true},
                    {id: "020104", code: "020104", name: "清理城市信用社借款", leaf: true},
                    {id: "020105", code: "020105", name: "清理信托投资公司借款", leaf: true},
                    {id: "020109", code: "020109", name: "其他", leaf: true}
                ]
            },
            {id: "0202", code: "0202", name: "债务还本", leaf: true},
            {id: "0204", code: "0204", name: "短期周转金", leaf: true},
            {id: "0299", code: "0299", name: "其他", leaf: true}
        ]
    }
];


/*费用收取方式*/
var json_debt_fysqfs = [
    {id: "1", code: "1", name: "不收取"},
    {id: "2", code: "2", name: "一次性收取"},
    {id: "3", code: "3", name: "按比例"},
    {id: "4", code: "4", name: "按定额"}
];

/*基准利率类型*/
var json_debt_jzlllx = [
    {id: "1", code: "1", name: "固定利率"},
    {id: "2", code: "2", name: "浮动利率"},
    {id: "99", code: "99", name: "其它"}
];

/*利率浮动方式*/
var json_debt_llfdfs = [
    {id: "1", code: "1", name: "上浮"},
    {id: "2", code: "2", name: "下浮"}
];

/*项目性质*/
var json_debt_xmxz = [
    {id: "01", code: "01", name: "无收益的公益性资本项目"},
    {id: "02", code: "02", name: "有一定收益的公益性资本项目"}
];

/*债券类型*/
var json_debt_zqlx = [
    {id: "01", code: "01", name: "一般债券"},
    {id: "02", code: "02", name: "专项债券"}
];

/*项目状态*/
var json_debt_xmzt = [
    {id: "01", code: "01", name: "备选"},
    {id: "02", code: "02", name: "淘汰"},
    {id: "03", code: "03", name: "纳入发行计划"}
];

/*年度*/
var json_debt_year = [
    {id: "1990", code: "1990", name: "1990年"},
    {id: "1991", code: "1991", name: "1991年"},
    {id: "1992", code: "1992", name: "1992年"},
    {id: "1993", code: "1993", name: "1993年"},
    {id: "1994", code: "1994", name: "1994年"},
    {id: "1995", code: "1995", name: "1995年"},
    {id: "1996", code: "1996", name: "1996年"},
    {id: "1997", code: "1997", name: "1997年"},
    {id: "1998", code: "1998", name: "1998年"},
    {id: "1999", code: "1999", name: "1999年"},
    {id: "2000", code: "2000", name: "2000年"},
    {id: "2001", code: "2001", name: "2001年"},
    {id: "2002", code: "2002", name: "2002年"},
    {id: "2003", code: "2003", name: "2003年"},
    {id: "2004", code: "2004", name: "2004年"},
    {id: "2005", code: "2005", name: "2005年"},
    {id: "2006", code: "2006", name: "2006年"},
    {id: "2007", code: "2007", name: "2007年"},
    {id: "2008", code: "2008", name: "2008年"},
    {id: "2009", code: "2009", name: "2009年"},
    {id: "2010", code: "2010", name: "2010年"},
    {id: "2011", code: "2011", name: "2011年"},
    {id: "2012", code: "2012", name: "2012年"},
    {id: "2013", code: "2013", name: "2013年"},
    {id: "2014", code: "2014", name: "2014年"},
    {id: "2015", code: "2015", name: "2015年"},
    {id: "2016", code: "2016", name: "2016年"},
    {id: "2017", code: "2017", name: "2017年"},
    {id: "2018", code: "2018", name: "2018年"},
    {id: "2019", code: "2019", name: "2019年"},
    {id: "2020", code: "2020", name: "2020年"},
    {id: "2021", code: "2021", name: "2021年"},
    {id: "2022", code: "2022", name: "2022年"},
    {id: "2023", code: "2023", name: "2023年"},
    {id: "2024", code: "2024", name: "2024年"},
    {id: "2025", code: "2025", name: "2025年"},
    {id: "2026", code: "2026", name: "2026年"},
    {id: "2027", code: "2027", name: "2027年"},
    {id: "2028", code: "2028", name: "2028年"},
    {id: "2029", code: "2029", name: "2029年"},
    {id: "2030", code: "2030", name: "2030年"},
    {id: "2031", code: "2031", name: "2031年"},
    {id: "2032", code: "2032", name: "2032年"},
    {id: "2033", code: "2033", name: "2033年"},
    {id: "2034", code: "2034", name: "2034年"},
    {id: "2035", code: "2035", name: "2035年"},
    {id: "2036", code: "2036", name: "2036年"},
    {id: "2037", code: "2037", name: "2037年"},
    {id: "2038", code: "2038", name: "2038年"},
    {id: "2039", code: "2039", name: "2039年"},
    {id: "2040", code: "2040", name: "2040年"},
    {id: "2041", code: "2041", name: "2041年"},
    {id: "2042", code: "2042", name: "2042年"},
    {id: "2043", code: "2043", name: "2043年"},
    {id: "2044", code: "2044", name: "2044年"},
    {id: "2045", code: "2045", name: "2045年"},
    {id: "2046", code: "2046", name: "2046年"},
    {id: "2047", code: "2047", name: "2047年"},
    {id: "2048", code: "2048", name: "2048年"},
    {id: "2049", code: "2049", name: "2049年"},
    {id: "2050", code: "2050", name: "2050年"}
];
/*批次*/
var json_debt_pc = [
    {id: "0", code: "", name: "全部"},
    {id: "1", code: "1", name: "第一批"},
    {id: "2", code: "2", name: "第二批"},
    {id: "3", code: "3", name: "第三批"},
    {id: "4", code: "4", name: "第四批"},
    {id: "5", code: "5", name: "第五批"}
];
/*工作流审核状态*/
var json_debt_sh = [
    {"id": "001", "code": "001", "name": "未审核"},
    {"id": "002", "code": "002", "name": "已审核"}
];
/*动态获取年度列表*/
/*function getYearList(config) {
    config=$({},{start:-8,end:1},config);
    var nowYear = new Date().getUTCFullYear();//当前年份
    var startYear = nowYear +config.start;//起始年份
    var endYear = nowYear + config.end;//结束年份，默认为当前年份

    var jsonstr = "[]";
    var jsonarray = eval('(' + jsonstr + ')');
    for (var i = startYear; i <= endYear; i++) {
        var arr = {"id": i, "code": i, "name": i};
        jsonarray.push(arr);
    }
    return jsonarray;
}*/

/*动态获取年度带全部*/
function getYearListWithAll() {
    var nowYear = new Date().getUTCFullYear();//当前年份
    var startYear = nowYear - 0;//起始年份 
    var endYear = nowYear + 5;//结束年份，默认为当前年份 

    var jsonstr = "[]";
    var jsonarray = eval('(' + jsonstr + ')');
    for (var i = startYear; i <= endYear; i++) {
        var arr = {id: i, code: i, name: i};
        jsonarray.push(arr);
    }
    jsonarray.push({id: '9999', code: '', name: '全部'});
    return jsonarray;
}

/*大项目*/
var json_debt_dxm = [
    {id: "00", code: "00", name: "中央"},
    {id: "12", code: "12", name: "天津市"},
    {id: "13", code: "13", name: "河北省"},
    {id: "14", code: "14", name: "山西省"},
    {id: "15", code: "15", name: "内蒙古自治区"},
    {id: "21", code: "21", name: "辽宁省"},
    {id: "2102", code: "2102", name: "大连市"},
    {id: "22", code: "22", name: "吉林省"},
    {id: "23", code: "23", name: "黑龙江省"},
    {id: "31", code: "31", name: "上海市"},
    {id: "32", code: "32", name: "江苏省"},
    {id: "33", code: "33", name: "浙江省"},
    {id: "3302", code: "3302", name: "宁波市"},
    {id: "34", code: "34", name: "安徽省"},
    {id: "35", code: "35", name: "福建省"},
    {id: "3502", code: "3502", name: "厦门市"},
    {id: "36", code: "36", name: "江西省"},
    {id: "37", code: "37", name: "山东省"},
    {id: "3702", code: "3702", name: "青岛市"},
    {id: "41", code: "41", name: "河南省"},
    {id: "42", code: "42", name: "湖北省"},
    {id: "43", code: "43", name: "湖南省"},
    {id: "44", code: "44", name: "广东省"},
    {id: "4403", code: "4403", name: "深圳市"},
    {id: "45", code: "45", name: "广西壮族自治区"},
    {id: "46", code: "46", name: "海南省"},
    {id: "50", code: "50", name: "重庆市"},
    {id: "51", code: "51", name: "四川省"},
    {id: "52", code: "52", name: "贵州省"},
    {id: "53", code: "53", name: "云南省"},
    {id: "54", code: "54", name: "西藏自治区"},
    {id: "61", code: "61", name: "陕西省"},
    {id: "62", code: "62", name: "甘肃省"},
    {id: "629", code: "629", name: "太原"},
    {id: "63", code: "63", name: "青海省"},
    {id: "64", code: "64", name: "宁夏回族自治区"},
    {id: "65", code: "65", name: "新疆自治区"}
];

/*利息罚息*/
var json_debt_lxfx = [
    {id: "1", code: "1", name: "利息"},
    {id: "2", code: "2", name: "罚息"}
];

/*项目重要性*/
var json_debt_xm_importance = [

    {id: "0", code: "0", name: "一般项目"},
    {id: "1", code: "1", name: "重大项目"}
];

/*发行方式*/
var json_debt_fxfs = [
    {"id": "01", "code": "01", "name": "公开发行"},
    {"id": "02", "code": "02", "name": "定向承销"}
];

/*调整标识*/
var json_debt_tzbs = [
    {id: "01", code: "01", name: "在建项目新增融资"},
    {id: "02", code: "02", name: "存量债务调整"},
    {id: "03", code: "03", name: "或有债务转化"}
];
/*本金、利息*/
var json_debt_bjlx = [
    {id: "0", code: "0", name: "本金"},
    {id: "1", code: "1", name: "利息"}
];
/*债务资金用途,特殊，01作为底级处理*/
var json_debt_zwzjyt1 = [
    {
        id: "01", code: "01", name: "资本性支出", leaf: true
    },
    {
        id: "02", code: "02", name: "非资本性支出", leaf: false, expanded: true,
        children: [
            {
                id: "0201", code: "0201", name: "化解地方金融风险", leaf: false, expanded: true,
                children: [
                    {id: "020101", code: "020101", name: "清理农村合作基金会借款", leaf: true},
                    {id: "020102", code: "020102", name: "清理供销社股金借款", leaf: true},
                    {id: "020103", code: "020103", name: "清理城市商业银行借款", leaf: true},
                    {id: "020104", code: "020104", name: "清理城市信用社借款", leaf: true},
                    {id: "020105", code: "020105", name: "清理信托投资公司借款", leaf: true},
                    {id: "020109", code: "020109", name: "其他", leaf: true}
                ]
            },
            {id: "0202", code: "0202", name: "债务还本", leaf: true},
            {id: "0204", code: "0204", name: "短期周转金", leaf: true},
            {id: "0299", code: "0299", name: "其他", leaf: true}
        ]
    }
];
/*债务资金用途,特殊，01作为底级处理*/
var json_debt_zwzjyt2 = [
    {
        id: "01", code: "01", name: "资本性支出", leaf: true
    },
    {
        id: "02", code: "02", name: "非资本性支出", leaf: false, expanded: true,
        children: [
            {id: "0202", code: "0202", name: "债务还本", leaf: true},
            {id: "0204", code: "0204", name: "短期周转金", leaf: true},
            {id: "0299", code: "0299", name: "其他", leaf: true}
        ]
    }
];
/**债务变更类型**/
var json_debt_bglx = [
    {id: "1", code: "1", name: "债权人变更"},
    //{id: "2", code: "2", name: "债务人变更"},
    {id: "3", code: "3", name: "债务用途变更"},
    {id: "4", code: "4", name: "协议金额变更"}
];
/**项目变更类型**/
var json_debt_bglx_xm = [
    {id: "1", code: "1", name: "投资计划变更"},
    {id: "2", code: "2", name: "项目收益变更"},
    {id: "3", code: "3", name: "存量债务变更"},
    {id: "4", code: "4", name: "绩效情况变更"},
    {id: "5", code: "5", name: "固定资产变更"}
];

/**还本付息利息类型**/
var json_debt_hbfxlx = [
    {id: "0", code: "0", name: "本金"},
    {id: "1", code: "1", name: "利息"},
    {id: "2", code: "2", name: "罚息"},
    {id: "3", code: "3", name: "费用"}
];
var json_debt_hbfxlx1 = [
    {id: "1", code: "1", name: "利息"},
    {id: "2", code: "2", name: "罚息"},
    {id: "3", code: "3", name: "费用"}
];
var json_debt_chbjtype = [
    {id: "0", code: "0", name: "正常还款"},
    {id: "1", code: "1", name: "提前还款"},
    {id: "2", code: "2", name: "逾期还款"}
];
var json_debt_zt2_4 = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"},
    {id: "008", code: "008", name: "曾经办"}
];
/*项目类别*/
var json_zqgl_fxdf_xmlb = [
    {id: "001", code: "001", name: "保障性安居工程类"},
    {id: "002", code: "002", name: "交通运输类"},
    {id: "003", code: "003", name: "农林水利类"},
    {id: "004", code: "004", name: "生态环境类"},
    {id: "005", code: "005", name: "市政建设类"},
    {id: "006", code: "006", name: "土地储备整理类"},
    {id: "007", code: "007", name: "其他"}
];
/*数据上报同步方式*/
var json_sjsb_tbfs = [
    {id: "001", code: "001", name: "全量同步"},
    {id: "000", code: "000", name: "增量同步"}
];
/*数据上报调用方式方式*/
var json_sjsb_calltype = [
    {id: "0", code: "CZB", name: "财政部收数"},
    {id: "1", code: "XCH", name: "平台(2.0)收数"}
];
var json_sjsb_calltype_xmzc = [
    {id: "0", code: "XMZC", name: "财政部收数"},
    {id: "1", code: "XCH", name: "平台(2.0)收数"}
];
var json_sjsb_calltype_xmndjh = [
    {id: "0", code: "XMNDJH", name: "财政部收数"},
    {id: "1", code: "XCH", name: "平台(2.0)收数"}
];
/*数据上报同步方式*/
var json_sjsb_wcqk = [
    {id: "001", code: "001", name: "未完成"},
    {id: "002", code: "002", name: "已完成"}
];

/*数据上报同步方式*/
var json_zwzc_type = [
    {id: "%", code: "%", name: "全部"},
    {id: "0", code: "0", name: "正常"},
    {id: "1", code: "1", name: "转移支出"}
];
/*提款用途*/
var json_debt_tkyt = [
    {id: "0", code: "0", name: "项目资本金"},
    {id: "1", code: "1", name: "单位自筹资金"}
];
/*拟偿还方式*/
var json_debt_qrdgl = [
    {id: "0", code: "0", name: "财政性资金"},
    {id: "1", code: "1", name: "自有资金"},
    {id: "2", code: "2", name: "借新还旧"}
];
/*认定情况*/
var json_rzpt_mlxx_rdqk = [{id: "01", code: "01", name: "审计认定"},
    {id: "02", code: "02", name: "银监认定"},
    {id: "03", code: "03", name: "政府认定"}];

/*一单三账管理*/
var json_rzpt_1d3zgl = [
    {id: "0", code: "0", name: "全部"},
    {id: "1", code: "1", name: "未确认"},
    {id: "2", code: "2", name: "已确认"}
];