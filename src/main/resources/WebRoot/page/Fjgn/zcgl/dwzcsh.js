/**
 * js：单位资产汇总审核
 */
//变现能力
var BXNL_ID_Store = DebtEleStore(json_debt_bxnl);
var reportUrl = '';
var hidden = false;

var json_zt = json_debt_zt2_5;//当前状态下拉框json数据
var button_name = '';//当前操作按钮名称
var button_status = '';//当前操作按钮状态，即为按钮name
if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
    WF_STATUS = '001';
}
//是否显示全部区划
var v_child = '0';
if (node_type == "dwzcsh") {
    //以上node隐藏区划树，默认选中底级区划
    v_child = '1';
}
//上报审核状态，0未审核，1已审核，2淘汰
var store_shyj = DebtEleStore([
    {code: '0', name: '不通过'},
    {code: '1', name: '通过'}
]);
/**
 * 通用配置json
 */
var json_common = {
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '审核',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'up',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '汇总表',
                name: 'hzb',
                icon: '/image/sysbutton/sum.png',
                handler: function () {
                	 // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                        return;
                    }
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                    }
                    ids = ids.join(",");
                    var url = '/WebReport/ReportServer?reportlet=tjfx%2F08_zcgl%2FDEBT_ZC_HZ.cpt&hzd_id='+ids+'&adcode='+USER_AD_CODE+'&HZD_TYPE=0';
                    if(FR_DEPLOYMENT_MODE=='1'){
                        url= url.replaceAll("/WebReport","");
                    }
                    window.open(url);
                }
            },
            {
                xtype: 'button',
                text: '未形成资产项目',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var AG_IDS = [];
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.each(records, function (record) {
                        AG_IDS.push(record.get("AG_ID"));
                    });
                    initProjectsNotFormingAssetsWindow(AG_IDS).show();
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },{
                xtype: 'button',
                text: '明细操作记录',
                name: 'log',
                hidden : true,
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation()
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '002': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销审核',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    doWorkFlow_cancel(btn);
                }
            },
            {
                xtype: 'button',
                text: '汇总表',
                name: 'hzb',
                icon: '/image/sysbutton/sum.png',
                handler: function () {
                	 // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                        return;
                    }
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                    }
                    ids = ids.join(",");
                    var url = '/WebReport/ReportServer?reportlet=tjfx%2F08_zcgl%2FDEBT_ZC_HZ.cpt&hzd_id='+ids+'&adcode='+USER_AD_CODE+'&HZD_TYPE=0';
                    if(FR_DEPLOYMENT_MODE=='1'){
                        url= url.replaceAll("/WebReport","");
                    }
                    window.open(url);
                }
            },
            {
                xtype: 'button',
                text: '未形成资产项目',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var AG_IDS = [];
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    Ext.each(records, function (record) {
                        AG_IDS.push(record.get("AG_ID"));
                    });
                    initProjectsNotFormingAssetsWindow(AG_IDS).show();
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                icon: '/image/sysbutton/detail.png',
                handler: function () {
                    operationRecord();
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'log',
                hidden : true,
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation()
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '003': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        /*'008': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
           {
                xtype: 'button',
                text: '汇总表',
                name: 'hzb',
                icon: '/image/sysbutton/sum.png',
                handler: function () {
                	 // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                        return;
                    }
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get('HZD_ID'));
                    }
                    ids = ids.join(",");
                    var url = '/WebReport/ReportServer?reportlet=tjfx%2F08_zcgl%2FDEBT_ZC_HZ.cpt&hzd_id='+ids+'&adcode='+USER_AD_CODE+'&HZD_TYPE=0';
                    window.open(url);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                icon: '/image/sysbutton/detail.png',
                handler: function () {
                    operationRecord();
                }
            },
            {
                xtype: 'button',
                text: '明细操作记录',
                name: 'log',
                hidden : true,
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation()
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]*/
    }
};
/**
 * 单位资产主表
 */
var HEADERJSON_BILL = [
    {
        xtype: 'rownumberer', width: 45,
        summaryRenderer: function () {
            return '合计';
        }
    },
    {text: "汇总ID", dataIndex: "HZD_ID", width: 100, type: "string", hidden: true},
    {text: "地区汇总ID", dataIndex: "DQHZ_ID", width: 100, type: "string", hidden: true},
    {text: "地区", dataIndex: "AD_NAME", width: 150, type: "string"},
    {text: "项目单位编码", dataIndex: "AG_ID", width: 150, type: "string", hidden: true},
    {text: "项目单位", dataIndex: "AG_NAME", width: 150, type: "string"},
    {text: "上报期间", dataIndex: "SBQJ_NAME", width: 100, type: "string"},
    {text: "项目个数", dataIndex: "XM_NUMS", width: 100, type: "int"},
    {text: "单位个数", dataIndex: "DW_NUMS", width: 100, type: "int", hidden: true},
    {
        dataIndex: "ZTZ_AMT", text: "项目总投资额(万元)",
        columns: [
            {
                dataIndex: "XMTZ_AMT",
                width: 150,
                type: "float",
                text: "合计",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "XMTZ_YB_AMT",
                width: 150,
                type: "float",
                text: "其中一般债务",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "XMTZ_ZX_AMT",
                width: 150,
                type: "float",
                text: "专项债务",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "QT_AMT",
                width: 150,
                type: "float",
                text: "其他财政性资金",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "QITA_AMT",
                width: 150,
                type: "float",
                text: "其他资金",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            }
        ]
    },
    {
        dataIndex: "ZC_AMT", text: "资产价值(万元)",
        columns: [
            {
                dataIndex: "ZJYZ_AMT",
                width: 150,
                type: "float",
                text: "原值",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "ZCJZ_AMT",
                width: 150,
                type: "float",
                text: "净值",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "YGJZ_AMT",
                width: 150,
                type: "float",
                text: "预估价值",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            }
        ]
    },
    {
        dataIndex: "YYSY_AMT", text: "资产运营收益(万元)",
        columns: [
            {
                dataIndex: "LJSY_AMT",
                width: 150,
                type: "float",
                text: "累计收益",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "SNLJSY_AMT",
                width: 150,
                type: "float",
                text: "本期收益",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "PJSY_AMT",
                width: 200,
                type: "float",
                text: "每年平均经营性现金流收入",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "PJBT_AMT",
                width: 250,
                type: "float",
                text: "年度平均政府安排财政补贴资金",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            }
        ]
    },
    {
        dataIndex: "CZSR_AMT", width: 150, type: "float", text: "本期资产处置收入", summaryType: 'sum',
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {
        text: "抵押质押及担保金额", dataIndex: "DYDB_AMT", width: 200, type: "float", summaryType: 'sum',
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    }
];
var HEADERJSON_ZCMX = [
    {
        xtype: 'rownumberer', width: 45,
        summaryRenderer: function () {
            return '合计';
        }
    },
    {text: "明细ID", dataIndex: "ZCMX_ID", width: 150, type: "string", hidden: true},
    { dataIndex: "XMZC_DTL_ID", type: "string", hidden: true},
    {
        text: "项目名称", dataIndex: "XM_NAME", width: 330, type: "string",
        renderer: function (data, cell, record) {
            /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
            return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
            var url='/page/debt/jsxm/jsxmYhsMain.jsp';
            var paramNames=new Array();
            paramNames[0]="XM_ID";
            var paramValues=new Array();
            paramValues[0]=record.get('XM_ID');
            var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
            return result;
        }
    },
    {text: "管理使用单位", dataIndex: "USE_UNIT", width: 250, type: "string"},
    {text: "项目类型", dataIndex: "XMLX_NAME", width: 150, type: "string"},
    {text: "竣工时间", dataIndex: "END_DATE_ACTUAL", width: 150, type: "string"},
    {text: "资产名称", dataIndex: "XMZC_NAME", width: 150, type: "string"},
    {text: "资产类别", dataIndex: "ZCLB_NAME", width: 150, type: "string"},
    {text: "资产性质", dataIndex: "ZCXZ_NAME", width: 150, type: "string"},
    {text: "变现能力", dataIndex: "BXNL_ID", width: 150, type: "string",
        'renderer': function (value, metadata, record) {
        if (value == '') {
            return;
        }
        var rec = BXNL_ID_Store.findRecord('code', value, 0, false, true, true);
        if (rec == null) {
            return '';
        }
        return rec.get('name');
    }},
    {text: "建设状态", dataIndex: "BUILD_STATUS_NAME", width: 150, type: "string"},
    {text: "计量单位", dataIndex: "JLDW_NAME", width: 150, type: "string"},
    {text: "数量", dataIndex: "ZC_NUM", width: 150, type: "float"},
    {text: "转固/入账时间", dataIndex: "RZ_DATE", width: 150, type: "string"},
    {
        dataIndex: "JZ_AMT", text: "资产价值(万元)",
        columns: [
            {
                dataIndex: "ZJYZ_AMT",
                width: 150,
                type: "float",
                text: "原值",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');

                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "ZCJZ_AMT",
                width: 150,
                type: "float",
                text: "净值",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "YGJZ_AMT",
                width: 150,
                type: "float",
                text: "预估价值",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            }
        ]
    },
    {
        dataIndex: "YYSY_AMT", text: "资产运营收益(万元)",
        columns: [
            {
                dataIndex: "LJSY_AMT",
                width: 150,
                type: "float",
                text: "累计收益",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "SNLJSY_AMT",
                width: 150,
                type: "float",
                text: "本期收益",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "ZCYXNX",
                width: 150,
                type: "float",
                text: "资产运行年限",
                summaryType: 'sum'
            },
            {
                dataIndex: "PJSY_AMT",
                width: 200,
                type: "float",
                text: "每年平均经营性现金流收入",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            },
            {
                dataIndex: "PJBT_AMT",
                width: 250,
                type: "float",
                text: "年度平均政府安排财政补贴资金",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            }
        ]
    },
    {
        dataIndex: "ZCCZQK", text: "资产处置情况 ",
        columns: [
            {
                dataIndex: "CZLX_NAME",
                width: 150,
                type: "string",
                text: "处置类型"
            },
            {
                dataIndex: "CZSR_AMT",
                width: 200,
                type: "float",
                text: "本期处置收入",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.00');
                }
            }
        ]
    },
    {
        text: "抵押质押及担保金额", dataIndex: "DYDB_AMT", width: 200, type: "float", summaryType: 'sum',
        renderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value / 10000, '0,000.00');
        }
    },
    {text: "备注", dataIndex: "REMARK", type: "string", width: 300}
];
/**
 * 未上报表格
 */
var HEADERJSON_WEI = [
                      {xtype: 'rownumberer', width: 40},
                      {dataIndex: 'AD_NAME', text: '地区名称', width: 200, align: 'center'},
                      {dataIndex: 'AG_NAME', text: '单位名称', width: 200, align: 'center'}
                  ];
/**
 * 页面初始化
 */
$(document).ready(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    initContent();
});
/**
 * 初始化页面主要内容区域
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        height: '100%',
        renderTo: Ext.getBody(),
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: json_common.items[WF_STATUS]
            }
        ],
        items: [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧表格
        ]
    });
}
/**
 * 初始化右侧panel，放置2个表格
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        height: '100%',
        flex: 5,
        region: 'center',
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        border: false,
        items: [
            initContentGrid(),
            initContentDetilGrid(),
            initContentWeiGrid()
        ]
    });
}
/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = HEADERJSON_BILL;
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },

        checkBox: true,
        border: false,
        autoLoad: false,
        hidden: hidden,
        height: '50%',
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_debt_zt2_5),
                width: 110,
                labelWidth: 30,
                labelAlign: 'right',
                editable: false,
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        if (newValue == '003') {
                             hidden = true;
                             var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                             toolbar.removeAll();
                             var grid = DSYGrid.getGrid('contentGrid');
                             var grid1 = DSYGrid.getGrid('contentWeiGrid');
                             var grid2 = DSYGrid.getGrid('contentGrid_detail');
                             grid1.down("combobox").setValue("003");
                             grid.hide();
                             grid2.hide();
                             grid1.show();
                        }else{
	                         var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
	                         toolbar.removeAll();
	                         toolbar.add(json_common.items[WF_STATUS]);
	                         //刷新当前表格
	                         self.up('grid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
	                         reloadGrid();
                        }
                    }
                }
            }
        ],

        params: {
            button_name: button_name,
            WF_STATUS: WF_STATUS
        },
        dataUrl: 'getXmzcSbGrid.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        features: [{
            ftype: 'summary'
        }],
        listeners: {
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['DWHZ_ID'] = record.get('HZD_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            },
            itemdblclick: function (self, record) {
                //initWin_view(record.get('HZD_ID'));
            }
        }
    });
}

/**
 * 未上报的Grid
 */
function initContentWeiGrid() {
    var headerJson = HEADERJSON_WEI;
    return DSYGrid.createGrid({
        itemId: 'contentWeiGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        hidden: !hidden,
        autoLoad: false,
        height: '50%',
        flex: 1,
        params: {
            WF_STATUS: WF_STATUS
        },
        dataUrl: 'getXmZcWSbGrid.action',
        pageConfig: {
            pageNum: true
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_debt_zt2_5),
                width: 130,
                labelWidth: 30,
                editable: false,
                labelAlign: 'right',
                displayField: "name",
                valueField: "id",
                allowBlank: false,
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        if (newValue != '003') {
                            var grid = DSYGrid.getGrid('contentGrid');
                            var grid1 = DSYGrid.getGrid('contentWeiGrid');
                            var grid2 = DSYGrid.getGrid('contentGrid_detail');
                            grid1.hide();
                            if (WF_STATUS == '001') {
                                grid.down("combobox").setValue("001");
                            } else if (WF_STATUS == '002') {
                                grid.down("combobox").setValue("002");
                            }
                            grid.show();
                            grid2.show();
                        }
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(json_common.items[WF_STATUS]);
                        //刷新当前表格
                        DSYGrid.getGrid('contentWeiGrid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        DSYGrid.getGrid('contentWeiGrid').getStore().loadPage(1);
                    }
                }
            }

        ],
    });
}
/**
 * 初始化右侧明细表格
 */
function initContentDetilGrid(config_ex) {
    var headerJson = HEADERJSON_ZCMX;
    var config = {
        itemId: 'contentGrid_detail',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        params: {
            node_type: node_type
        },
        autoLoad: false,
        border: false,
        height: '50%',
        width: '100%',
        pageConfig: {
            enablePage: false
        },
        dataUrl: '/getXmZcSbGridDetail.action'
    };
    if (config_ex) {
        config = $.extend(false, config, config_ex);
    }
    return DSYGrid.createGrid(config);
}
/**
 * 树点击节点时触发，刷新content主表格，明细表置为空
 */
function reloadGrid(param, param_detail) {
    var grid = DSYGrid.getGrid('contentGrid');
    var store1 = DSYGrid.getGrid('contentWeiGrid').getStore();
    var store = grid.getStore();

    //增加查询参数
    store.getProxy().extraParams["AD_CODE"] = AD_CODE;
    store.getProxy().extraParams["AG_CODE"] = AG_CODE;
    store1.getProxy().extraParams["AG_CODE"] = AG_CODE;
    if (typeof param != 'undefined' && param != null) {
        for (var i in param) {
            store.getProxy().extraParams[i] = param[i];
        }
    }
    //刷新
    store.loadPage(1);
    store1.loadPage(1);
    //刷新下方表格,置为空
    if (DSYGrid.getGrid('contentGrid_detail')) {
        var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
        
        //如果传递参数不为空，就刷新明细表格
        if (typeof param_detail != 'undefined' && param_detail != null) {
            for (var i in param_detail) {
                store_details.getProxy().extraParams[i] = param_detail[i];
                store1.getProxy().extraParams[i] = param_hz[i];
            }
            store_details.loadPage(1);
            store1.loadPage(1);
        } else {
            store_details.removeAll();
        }
    }
}

//创建未形成资产项目窗口
function initProjectsNotFormingAssetsWindow(AG_IDS) {
    return Ext.create('Ext.window.Window', {
        height: document.body.clientHeight * 0.9,
        width: document.body.clientWidth * 0.9,
        title: '未形成资产项目',
        maximizable: true,
        modal: true,
        closeAction: 'destroy',
        layout: 'fit',
        items: [projectsNotFormingAssetsGrid(AG_IDS)],
        buttons: [
        ]
    });
}

//创建未形成资产项目表格
function projectsNotFormingAssetsGrid(AG_IDS) {
    var headerJson = [
        {"dataIndex": "AD_NAME", "type": "string", "text": "地区", "width": 100},
        {"dataIndex": "AG_NAME", "type": "string", "text": "项目单位", "width": 200},
        {
            "dataIndex": "XM_NAME", "width": 330, "type": "string", "text": "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {"text": "管理(使用)单位", "dataIndex": "USE_UNIT", "type": "string", "width": 200},
        {"text": "项目类型", "dataIndex": "XMLX_NAME", "type": "string", "width": 150},
        {"text": "项目性质ID", "dataIndex": "XMXZ_ID", "type": "string", hidden: true},
        {"text": "项目性质", "dataIndex": "XMXZ_NAME", "type": "string", width: 170},
        {
            "dataIndex": "BUILD_STATUS_ID", "type": "string", hidden: true
        }, {
            "dataIndex": "BUILD_STATUS_NAME", "width": 150, "type": "string", "text": "建设状态"
        },
        {"dataIndex": "END_DATE_ACTUAL", "width": 150, "type": "string", "text": "竣工时间"},
        {
            "header": "项目总投资金额(万元)", 'colspan': 2, 'align': 'center',
            'columns': [
                {"type": "float", "text": "合计", "dataIndex": "XMTZ_AMT", width: 150},
                {"dataIndex": "XMTZ_YB_AMT", "width": 150, "type": "float", "text": "其中一般债务"},
                {"dataIndex": "XMTZ_ZX_AMT", "width": 150, "type": "float", "text": "专项债务"}]
        },
        {"text": "未形成资产原因", "dataIndex": "WXCZC_REASON", "type": "string", "width": 150}
    ];
    return DSYGrid.createGrid({
        itemId: 'projectsNotFormingAssetsGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        rowNumber: true,
        border: false,
        selModel: {
            mode: "SINGLE" //设置为单选
        },
        autoLoad: true,
        params: {
            AD_CODE: AD_CODE,
            AG_ID: AG_IDS,
            mhcx_xm: '',
            xmlx_id: ''
        },
        //顶部工具条
        tbar: [
            {
                xtype: "treecombobox",
                name: "xmlx_id",
                id: 'xmlx_id',
                fieldLabel: '项目类型',
                displayField: 'name',
                valueField: 'code',
                selectModel: 'all',
                store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                labelWidth: 70,
                width: 220,
                labelAlign: 'right',
                editable: false,
                allowBlank: true,
                triggers:{
                    clear: {
                        cls: Ext.baseCSSPrefix + 'form-clear-trigger',
                        handler: function(self) {
                            self.setValue('');
                        }
                    }
                }
            },
            {
                xtype: "textfield",
                name: "mhcx_xm",
                id: 'mhcx_xm',
                fieldLabel: '模糊查询',
                allowBlank: true,
                labelWidth: 70,
                width: 240,
                labelAlign: 'right',
                emptyText: '请输入单位名称/项目名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var xmlx_id = Ext.ComponentQuery.query('treecombobox#xmlx_id')[0].getValue();
                            var mhcx_xm = Ext.ComponentQuery.query('textfield#mhcx_xm')[0].getValue();
                            var projectsNotFormingAssetsStore = DSYGrid.getGrid('projectsNotFormingAssetsGrid').getStore();
                            projectsNotFormingAssetsStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                            projectsNotFormingAssetsStore.getProxy().extraParams['AG_ID'] = AG_IDS;
                            projectsNotFormingAssetsStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                            projectsNotFormingAssetsStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                            projectsNotFormingAssetsStore.loadPage(1);
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var xmlx_id = Ext.ComponentQuery.query('treecombobox#xmlx_id')[0].getValue();
                    var mhcx_xm = Ext.ComponentQuery.query('textfield#mhcx_xm')[0].getValue();
                    var projectsNotFormingAssetsStore = DSYGrid.getGrid('projectsNotFormingAssetsGrid').getStore();
                    projectsNotFormingAssetsStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                    projectsNotFormingAssetsStore.getProxy().extraParams['AG_ID'] = AG_IDS;
                    projectsNotFormingAssetsStore.getProxy().extraParams['XMLX_ID'] = xmlx_id;
                    projectsNotFormingAssetsStore.getProxy().extraParams['MHCX_XM'] = mhcx_xm;
                    projectsNotFormingAssetsStore.loadPage(1);
                }
            }
        ],
        dataUrl: 'getExistingProjectGrid.action',
        pageConfig: {
            enablePage: true//设置分页为false
        }
    });
}

/**
 * 创建填写意见对话框
 */
function initWindow_opinion(config) {
    var default_config = {
        closeAction: 'destroy',
        title: null,
        buttons: Ext.MessageBox.OKCANCEL,
        width: 350,
        value: '同意',
        animateTarget: null,
        fn: null
    };
    $.extend(default_config, config);
    return Ext.create('Ext.window.MessageBox', {
        closeAction: default_config.closeAction
    }).show({
        multiline: true,
        value: default_config.value,
        width: default_config.width,
        title: default_config.title,
        animateTarget: default_config.animateTarget,
        buttons: default_config.buttons,
        fn: default_config.fn
    });
}
/**
 * 操作记录
 */
function operationRecord() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (!records || records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        fuc_getWorkFlowLog(records[0].get("HZD_ID"));
    }
}
/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("HZD_ID"));
    }
    button_name = btn.text;
    var op_value = '';
    if (button_name == "审核") {   //判断按钮名称 获取对应意见内容
        op_value = '同意';
    } else if (button_name == '退回') {
        op_value = '';
    }

    //弹出意见填写对话框
    initWindow_opinion({
        value: op_value,
        title: btn.text + "意见",
        animateTarget: btn,
        fn: function (buttonId, text) {
            if (buttonId === 'ok') {
                //发送ajax请求，修改节点信息
                $.post("/updateDwzcNode.action", {
                    workflow_direction: btn.name,
                    button_name: button_name,
                    audit_info: text,
                    ids: ids,
                    AD_CODE: AD_CODE
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: button_name + "成功！" + (data.message ? data.message : ''),
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    } else {
                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    }
                    //刷新表格
                    reloadGrid();
                }, "json");
            }
        }
    });
}
/**
 * 工作流变更
 */
function doWorkFlow_cancel(btn) {
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var ids = [];
    var recordArray = [];
    for (var i in records) {
        ids.push(records[i].get("HZD_ID"));
    }
    var datas = [];
    for (var i = 0; i < records.length; i++) {
        datas[i] = records[i].data;
    }
    button_name = btn.text;
    button_status = btn.name;
    Ext.Msg.confirm('确认', '是否确认撤销？', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            $.post("/cancelDwzcNode.action", {
                workflow_direction: btn.name,
                button_name: button_name,
                ids: ids,
                AD_CODE: AD_CODE
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: button_name + "成功！" + (data.message ? data.message : ''),
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                } else {
                    Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                }
                //刷新表格
                reloadGrid();
            }, "json");
        }
    });
}
function dooperation() {
    var records = DSYGrid.getGrid('contentGrid_detail').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条明细记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var xmzc_dtl_id = records[0].get("XMZC_DTL_ID");
        fuc_getWorkFlowLog(xmzc_dtl_id);
    }
}