<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>批次计划编制</title>
    <!-- 重要：引入用到的js文件 -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script src="../data/ele_data.js"></script>
</head>
<body>
<%
   /* String userCode = (String) request.getSession().getAttribute("USERCODE");//获取登录用户*/
%>
<script type="text/javascript">
    /**
     * 获取登录用户
     */
<%--var userCode = '<%=userCode%>';--%>
var userCode = '${sessionScope.USERCODE}';
/* var wf_id = getQueryParam("wf_id");//工作流ID
var node_code = getQueryParam("node_code");//当前结点*/
var wf_id ="${fns:getParamValue('wf_id')}";
var node_code ="${fns:getParamValue('node_code')}";
/**
 * 设置全局变量
 */
var button_name = '';//按钮名称
var next_text = '';//送审、审核按钮显示文字
var audit_info = '';//审核意见
var update_text = '';//修改、登记按钮显示文字
/*  var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
    WF_STATUS = '001';
}*/
var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
if (isNull(WF_STATUS)) {
    WF_STATUS = '001';;
}
var pcjh_id = '';
//加载左侧上方树数据
var regStore = Ext.create('Ext.data.TreeStore', {
    proxy: {
        type: 'ajax',
        method: 'POST',
        url: 'getRegTreeData.action',
        extraParams: leftTreeConfig.areaConfig.params,
        reader: {
            type: 'json'
        }
    },
    root: 'nodelist',
    model: 'treeModel',
    autoLoad: true
});
/**
 * 页面初始化
 */
$(document).ready(function () {
    if (typeof (Ext) == "undefined" || Ext == null) {
        //动态加载js
        $.ajaxSetup({
            cache: true
        });
        $.getScript('../../third/ext5.1/ext-all.js', function () {
            initMain();//初始化主页面
            initButton();//初始化按钮
        });
    } else {
        initMain();//初始化主页面
        initButton();//初始化按钮
    }
});
/**
 * 主界面初始化
 */
function initMain() {
    /**
     * 初始化顶部功能按钮
     */
    //通过当前所在节点，判断next按钮显示的名称
    if (node_code == '1') {
        next_text = '送审';
    } else if (node_code == '2') {
        next_text = '审核';
    }
    var tbar = Ext.create('Ext.toolbar.Toolbar', {
        border: false,
        items: [
            {
                xtype: 'button',
                text: '查询',
                name: 'btn_check',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    refresh_contentMainGrid();
                }
            },
            {
                xtype: 'button',
                text: '新增',
                name: 'btn_insert',
                icon: '/image/sysbutton/add.png',
                handler: function () {
                    button_name = 'INPUT';
                    createPcjhWin();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'btn_update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    button_name = 'UPDATE';
                    var records = DSYGrid.getGrid('contentMainGrid').getSelectionModel().getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择一条记录！');
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时对多条记录进行修改！');
                    } else {
                        createPcjhWin();
                        pcjh_id = records[0].get("PCJH_ID");
                        var form = Ext.ComponentQuery.query('form[name="pcjhForm"]')[0];
                        loadPcjh(form);
                    }
                }
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'btn_delete',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    deletePcjh(btn);
                }
            },
            {
                xtype: 'button',
                text: next_text,
                name: 'btn_next',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var records = DSYGrid.getGrid('contentMainGrid').getSelectionModel().getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return false;
                    }
                    if (button_name == '送审') {
                        Ext.Msg.confirm('提示', '请确认是否送审！', function (btn_confirm) {
                            if (btn_confirm == 'yes') {
                                audit_info = '';
                                func_node('/nextPcjh.action');
                            }
                        });
                    } else {
                        //弹出对话框填写意见
                        opinionWindow.open('NEXT', next_text + "意见");
                    }
                }
            },
            {
                xtype: 'button',
                text: '撤销' + next_text,
                name: 'btn_cancel',
                hidden: true,
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentMainGrid').getSelectionModel().getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return false;
                    }
                    button_name = btn.text;
                    Ext.Msg.confirm('提示', '请确认是否撤销?', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            audit_info = '';
                            func_node('/cancelPcjh.action');
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'btn_back',
                icon: '/image/sysbutton/back.png',
                handler: function () {
                    var records = DSYGrid.getGrid('contentMainGrid').getSelectionModel().getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                    } else {
                        //弹出对话框填写意见
                        opinionWindow.open('BACK', '退回' + "意见");
                    }
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    var records = DSYGrid.getGrid('contentMainGrid').getSelectionModel().getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择一条记录！');
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
                    } else {
                        pcjh_id = records[0].get("PCJH_ID");
                        fuc_getWorkFlowLog(pcjh_id);
                    }
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    });

    /**
     * 债券注册录入界面主面板初始化
     */
    var panel = Ext.create('Ext.panel.Panel', {
        name: 'mainPanel',
        renderTo: Ext.getBody(),
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        width: '100%',
        height: '100%',
        border: false,
        items: [
            initContentMainGrid(),
            {
                xtype: 'tabpanel',
                border: false,
                flex: 1,
                itemId: 'winPanel_MainPanel',
                items: [
                    {
                        title: '新增债券',
                        layout: 'fit',
                        name: 'xzzq',
                        items: [initContentXzzqGrid()]
                    },
                    {
                        title: '置换债券',
                        layout: 'fit',
                        name: 'zhzq',
                        items: [initContentZhzqGrid()]
                    }
                ]
            }
        ],
        tbar: tbar
    });
}
/**
 * 初始化主界面主表格
 */
function initContentMainGrid() {

    /**
     * 主表格筛选条件
     */
//          var tbar = [];
//          if(node_code == '1'){
//            tbar = [
//             {
//                 xtype: "combobox",
//                 name: "WF_STATUS",
//                 store:  DebtEleStore(json_debt_zt1),
//                 displayField: "name",
//                 valueField: "id",
//                 value: WF_STATUS,
//                 fieldLabel: '状态',
//                 editable: false, //禁用编辑
//                 width: 150,
//                 labelWidth: 30,
//                 allowBlank: false,
//                 labelAlign: 'right',
//                 listeners: {
//                     'change': function (ZQLB) {
//                         //初始化按钮
//                         initButton();
//                         //刷新批次管理主表格
//                         refresh_contentMainGrid();
//                     }
//                 }
//             }];
//          }else{
//              tbar = [{
//                 xtype: "combobox",
//                 name: "WF_STATUS",
//                 store:  DebtEleStore(json_debt_zt2),
//                 displayField: "name",
//                 valueField: "id",
//                 value: WF_STATUS,
//                 fieldLabel: '状态',
//                 editable: false, //禁用编辑
//                 width: 150,
//                 labelWidth: 30,
//                 allowBlank: false,
//                 labelAlign: 'right',
//                 listeners: {
//                     'change': function (ZQLB) {
//                         //初始化按钮
//                         initButton();
//                         //刷新批次管理主表格
//                         refresh_contentMainGrid();
//                     }
//                 }
//             }];
//          }

    var tbar = [
        {
            xtype: "combobox",
            name: "WF_STATUS",
            store: node_code == '1' ? DebtEleStore(json_debt_zt0) : DebtEleStore(json_debt_sh),
            displayField: "name",
            valueField: "id",
            value: WF_STATUS,
            fieldLabel: '状态',
            editable: false, //禁用编辑
            width: 150,
            labelWidth: 30,
            allowBlank: false,
            labelAlign: 'right',
            listeners: {
                'change': function (ZQLB) {
                    //初始化按钮
                    initButton();
                    //刷新批次管理主表格
                    refresh_contentMainGrid();
                }
            }
        }];
    /* ,
     {
     xtype: "combobox",
     name: "SET_YEAR",
     store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"}),
     displayField: "name",
     valueField: "id",
     value: Ext.Date.format(new Date(), 'Y'),
     fieldLabel: '年度',
     editable: false, //禁用编辑
     labelWidth: 40,
     width: 150,
     labelAlign: 'right',
     listeners: {
     'change': function (ZQLB) {
     //刷新批次管理主表格
     refresh_contentMainGrid();
     }
     }
     },
     {
     xtype: 'combobox',
     fieldLabel: '债券类别',
     labelWidth: 80,
     name: 'MAIN_ZQLB_ID',
     displayField: 'name',
     valueField: 'code',
     value: '01',
     store: DebtEleStore(json_debt_zqlb),
     labelAlign: 'right',
     editable: false, //禁用编辑
     listeners: {
     'change': function (ZQLB) {
     //刷新批次管理主表格
     refresh_contentMainGrid();
     //切换明细表格
     var mainPanel = Ext.ComponentQuery.query('panel[name="mainPanel"]')[0];
     var detilPanel = null;
     if (ZQLB.value == '02') {
     detilPanel = DSYGrid.getGrid('contentXzzqGrid');
     mainPanel.items.remove(detilPanel);
     DSYGrid.destoryGrid('contentXzzqGrid');
     mainPanel.items.add(initContentZhzqGrid());
     } else {
     detilPanel = DSYGrid.getGrid('contentZhzqGrid');
     mainPanel.items.remove(detilPanel);
     DSYGrid.destoryGrid('contentZhzqGrid');
     mainPanel.items.add(initContentXzzqGrid());
     }
     mainPanel.doLayout();
     }
     }
     } */

    /**
     * 主表格表头
     */
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {"dataIndex": "PCJH_ID", "width": 150, "type": "string", "text": "批次计划ID", hidden: true},
        {"dataIndex": "FXPC_NAME", "width": 150, "type": "string", "text": "批次"},
        {"dataIndex": "PC_YEAR", "width": 100, "type": "string", "text": "年度"},
        {"dataIndex": "ZQPZ_NAME", "width": 200, "type": "string", "text": "债券品种"},
        {"dataIndex": "PC_MONTEH", "width": 150, "type": "int", "text": "计划月份",
        renderer:function (value) {
            var array=json_debt_yf;
            for(var i=0;i<array.length;i++){//遍历数组
               var a=array[i];
               if(a['id']==value){//通过数据库保存的基础数据id来获得对应的对象
                   var store=a['name'];
                   return store;//返回相对应id的name值
               }
            }
        }
        },
        {"dataIndex": "ZB_DATE", "width": 150, "type": "string", "text": "招标日期"},
        {"dataIndex": "FXQX_ID", "width": 150, "type": "string", "text": "发行期（月）", hidden: true},
        {
            "dataIndex": "PLAN_FX_AMT", "width": 200, "type": "float", "text": "计划发行额（元）", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }
    ];

    var simplyGrid = new DSYGridV2();
    var config = {
        itemId: 'contentMainGrid',
        border: false,
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: 'getPcjhMainGrid.action',
        autoLoad: true,
        checkBox: true,
        params: {
            wf_id: wf_id,
            node_code: node_code,
            userCode: userCode,
            WF_STATUS: WF_STATUS
        },
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            pageSize: 20// 每页显示数据数
        },
        tbar: tbar
    };
    var grid = simplyGrid.create(config);
    grid.on('itemclick', function (self, record) {
        pcjh_id = record.get("PCJH_ID");
        refresh_detailGrid(pcjh_id);
    });
    return grid;
}
/**
 * 初始化主界面一般债券明细表
 */
function initContentXzzqGrid() {
    /**
     * 新增债券明细表表头
     */
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "地区名称"},
        {dataIndex: "AG_NAME", width: 150, type: "string", text: "单位名称"},
        {
            dataIndex: "XM_NAME", width: 250, type: "string", text: "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "SORT_NO", width: 100, type: "string", text: "排序号", hidden: true},
        {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质"},
        {dataIndex: "APPLY_DATE", width: 100, type: "string", text: "申请日期"},
        {dataIndex: "XMLX_NAME", width: 180, type: "string", text: "项目类型"},
        {dataIndex: "BUILD_STATUS_NAME", width: 100, type: "string", text: "建设状态"},
        {
            dataIndex: "DISTRIBUTE_AMOUNT", width: 100, type: "string", text: "分配金额(元)", hidden: true, summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "APPLY_AMOUNT1", width: 120, type: "float", text: "当年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "RETURN_CAPITAL", width: 150, type: "float", text: "其中用于偿还本金", hidden: true},
        {
            dataIndex: "APPLY_AMOUNT2", width: 150, type: "float", text: "第二年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "APPLY_AMOUNT3", width: 150, type: "float", text: "第三年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "XMZGS_AMT", width: 150, type: "string", text: "项目总概算金额(元)"},
        {dataIndex: "", width: 100, type: "string", text: "资金缺口",hidden: true}
    ];

    var simplyGrid = new DSYGridV2();
    var config = {
        itemId: 'contentXzzqGrid',
        border: false,
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: 'getPcjhDetailXzzqGrid.action',
        autoLoad: false,
        params: {
            pjch_id: ''
        },
        features: [{
            ftype: 'summary'
        }],
        //data: contentGridXzzqData,
        height: '50%',
        pageConfig: {
            enablePage: false
        }
    };
    var grid = simplyGrid.create(config);
    return grid;
}
/**
 * 初始化主界面置换债券明细表
 */
function initContentZhzqGrid() {
    /**
     * 置换债券明细表表头
     */
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "地区名称"},
        {dataIndex: "AG_NAME", width: 150, type: "string", text: "单位名称"},
        {dataIndex: "YCHRQ", width: 150, type: "string", text: "到期日期"},
        {dataIndex: "YE", width: 150, type: "float", text: "到期金额(元)"},
        {dataIndex: "FXFS_NAME", width: 100, type: "string", text: "发行方式"},
        {dataIndex: "ZQQX_NAME", width: 150, type: "string", text: "发行期限(年)"},
        {dataIndex: "CX_AGENCY", width: 100, type: "string", text: "承销机构", hidden: true},
        {
            dataIndex: "APPLY_AMOUNT", width: 120, type: "float", text: "当年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "REPLY_AMOUNT", width: 120, type: "float", text: "批复金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "DEBT_NAME", width: 200, type: "string", text: "债务名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            dataIndex: "XM_NAME", width: 250, type: "string", text: "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "ZQR_NAME", width: 100, type: "string", text: "债权人"},
        {dataIndex: "ZQRQC", width: 200, type: "string", text: "债权人全称"},
        {dataIndex: "ZJYT_NAME", width: 100, type: "string", text: "债务用途"},
        {dataIndex: "QDRQ", width: 100, type: "string", text: "签订日期"},
        {dataIndex: "XYH", width: 150, type: "string", text: "协议号"},
        {dataIndex: "LX_RATE", width: 100, type: "float", text: "利率(%)"},
        {dataIndex: "ZWQX", width: 100, type: "int", text: "期限(月)"},
        {dataIndex: "BILL_YEAR", width: 100, type: "string", text: "申报年度"},
        {dataIndex: "ZQLX_NAME_STR", width: 100, type: "string", text: "申请类型"},
        {dataIndex: "ZWLB_NAME_STR", width: 100, type: "string", text: "债务类型"},
        {dataIndex: "DEBT_YE", width: 150, type: "float", text: "债务余额(元)"},
        {dataIndex: "DEBT_YQJE", width: 100, type: "float", text: "逾期金额(元)"},
        {dataIndex: "ZQLX_NAME", width: 100, type: "string", text: "债权类型"},
        {dataIndex: "CUR_NAME", width: 100, type: "string", text: "币种"},
        {dataIndex: "ROE", width: 100, type: "float", text: "汇率(%)"},
        {dataIndex: "XYJE", width: 100, type: "string", text: "协议金额(元)",
        renderer:function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        }},
        {dataIndex: "LX_TYPE", width: 100, type: "string", text: "利率类型"}
    ];
    var simplyGrid = new DSYGridV2();
    var config = {
        itemId: 'contentZhzqGrid',
        border: false,
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getPcjhDetailZhzqGrid.action',
        autoLoad: false,
        pageConfig: {
            enablePage: false
        }
    };
    var grid = simplyGrid.create(config);
    return grid;
}
/**
 * 创建批次计划编辑窗口
 */
function createPcjhWin() {
    var pcjhWindow = new Ext.Window({
        title: '批次计划',
        name: 'pcjhWin',
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        frame: true,
        constrain: true,
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: true,//大小不可改变
        plain: true,
        layout: 'fit',
        maximizable: true,
        items: [initWin_PcjhPanel()],
        closeAction: 'destroy',
        buttons: [
            {
                xtype: 'button',
                text: '新增',
                name: 'add',
                handler: function (btn) {
                    var zqlx_id = Ext.ComponentQuery.query('treecombobox[name="ZQLX_ID"]')[0].getValue();
                    var fxfs_id = Ext.ComponentQuery.query('combobox[name="FXFS_ID"]')[0].getValue();
                    if (typeof zqlx_id == 'undefined' || zqlx_id == null || !zqlx_id) {
                        Ext.Msg.alert('提示', '请先选择债券类型后再进行操作！');
                        return;
                    }
                    var tabPanel = btn.up('window').down('#winPanel_tabPanel');
                    var currentTab = tabPanel.getActiveTab();
                    if (currentTab.name == 'xzzq') {
                        initWin_select_xzzq();//加载新增债券计划选择窗体
                        refresh_winXzzqGrid(btn);//刷新窗体内表格
                    }
                    if (currentTab.name == 'zhzq') {
                        if (typeof fxfs_id == 'undefined' || fxfs_id == null || !fxfs_id) {
                            Ext.Msg.alert('提示', '请先选择发行方式后再进行操作！');
                            return;
                        }
                        initWin_select_zhzq();
                        refresh_winZhzqGrid(btn);
                    }
                }
            },
            {
                xtype: 'button',
                text: '删除',
                itemId: 'pcjhDelBtn',
                disabled: true,
                handler: function (btn) {
                    var tabPanel = btn.up('window').down('#winPanel_tabPanel');
                    var currentTab = tabPanel.getActiveTab();
                    var grid = '';
                    if (currentTab.name == 'xzzq') {
                        grid = DSYGrid.getGrid('winXzzqGrid');
                    }
                    if (currentTab.name == 'zhzq') {
                        grid = DSYGrid.getGrid('winZhzqGrid');
                    }
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            },
            {
                xtype: 'button',
                text: '地区汇总',
                name: 'DQHZ',
                handler: function (btn) {
                    var params = {};
                    var xzzqXmArray = [];//新增债券项目
                    var zhzqXmArray = [];//置换债券计划
                    var xzzqStore = DSYGrid.getGrid('winXzzqGrid').getStore();
                    var zhzqStore = DSYGrid.getGrid('winZhzqGrid').getStore();
                    if (xzzqStore.getCount() == 0 && zhzqStore.getCount() == 0) {
                        Ext.MessageBox.alert('提示', '请添加批次计划数据！');
                        return;
                    }
                    DSYGrid.getGrid('winXzzqGrid').getStore().each(function (record) {
                        xzzqXmArray.push({'ID': record.get("ID")}); //新增债券项目
                    });
                    DSYGrid.getGrid('winZhzqGrid').getStore().each(function (record) {
                        zhzqXmArray.push({'ZHMX_ID': record.get("ZHMX_ID")}); //置换债券计划
                    });
                    initWindow_DQHZ({
                        xzzqXmArray: Ext.util.JSON.encode(xzzqXmArray),
                        zhzqXmArray: Ext.util.JSON.encode(zhzqXmArray)
                    });
                }
            },
            {
                xtype: 'button',
                text: '保存',
                name: 'SAVE',
                handler: function (btn) {
                    var form = Ext.ComponentQuery.query('form[name="pcjhForm"]')[0];
                    submitPcjh(form);
                }
            },
            {
                xtype: 'button',
                text: '取消',
                name: 'CLOSE',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    pcjhWindow.show();
}
/**
 * 初始化批次计划编辑窗口panel
 */
function initWin_PcjhPanel() {
    /**
     * 定义弹出窗口底部工具栏
     */
    /* var bbar = Ext.create('Ext.toolbar.Toolbar',{
     border:false,
     items: ['->',
     {
     xtype: 'button',
     text: '保存',
     name: 'SAVE',
     handler: function (btn) {
     var form = Ext.ComponentQuery.query('form[name="pcjhForm"]')[0];
     submitPcjh(form);
     }
     },
     {
     xtype: 'button',
     text: '取消',
     name: 'CLOSE',
     handler: function () {
     Ext.ComponentQuery.query('window[name="pcjhWin"]')[0].close();
     }
     }
     ]
     }); */
    /**
     * 初始化弹出窗口内容
     */
    var winPanel = Ext.create('Ext.panel.Panel', {
        name: 'winPanel',
        border: false,
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        items: [
            initWin_pcjhForm(),
            {
                xtype: 'tabpanel',
                border: false,
                flex: 1,
                itemId: 'winPanel_tabPanel',
                items: [
                    {
                        title: '新增债券',
                        layout: 'fit',
                        name: 'xzzq',
                        items: [initWin_XzzqGrid()]
                    },
                    {
                        title: '置换债券',
                        layout: 'fit',
                        name: 'zhzq',
                        items: [initWin_ZhzqGrid()]
                    }
                ]
            }
        ]
    });
    return winPanel;
}
/**
 * 生成批次计划管理form表单
 */
function initWin_pcjhForm() {
    var pcjhForm = Ext.create('Ext.form.Panel', {
        name: 'pcjhForm',
        border: false,
        layout: 'fit',
        padding: '0 0 2 0',
        items: [
            {
                xtype: 'fieldset',
                title: '批次信息',
                layout: 'column',
                width: "100%",
                height: "100%",
                margin: '0 2 0 2',
                defaults: {
                    border: false,
                    anchor: '100%',
                    padding: '2 0 2 0',
                    labelAlign: 'right',
                    labelWidth: 100,
                    columnWidth: 0.33,
                    allowBlank: false
                },
                items: [
                    {
                        xtype: 'textfield',
                        name: 'PCJH_NAME',
                        fieldLabel: '<span class="required">✶</span>批次计划名称'
                    },
                    {
                        xtype: "combobox",
                        name: "FXPC_ID",
                        fieldLabel: '<span class="required">✶</span>发行批次',
                        store: DebtEleStoreDB('DEBT_ZQPC'),
                        displayField: 'name',
                        valueField: 'id',
                        lines: false,
                        editable: false, //禁用编辑
                        listeners: {
                            /* 'select': function () {
                             refresh_winGrid();
                             } */
                        }
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZQLX_ID",
                        fieldLabel: '<span class="required">✶</span>债券类型',
                        store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                        displayField: 'name',
                        valueField: 'id',
                        lines: false,
                        selectModel: 'leaf',
                        editable: false, //禁用编辑
                        listeners: {
                            'expand': function (self) {
                                //校验表格中是否存在数据
                                var XzzqStore = DSYGrid.getGrid('winXzzqGrid').getStore();
                                var ZhzqStore = DSYGrid.getGrid('winZhzqGrid').getStore();
                                var flag = true;
                                if (XzzqStore.getCount() > 0 || ZhzqStore.getCount() > 0) {

                                    Ext.Msg.confirm('提示', '更改债券类型将会清空已选择数据，是否继续修改？', function (btn_confirm) {
                                        if (btn_confirm === 'yes') {
                                            XzzqStore.removeAll();
                                            ZhzqStore.removeAll();
                                        }
                                    });
                                }
                            }
                        }
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZQPZ_ID",
                        store: DebtEleTreeStoreJSON(json_debt_zqpz),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>债权品种',
                        hidden: true,
                        value: 111,
                        editable: false, //禁用编辑
                        selectModel: 'leaf'
                    },
                    {
                        xtype: "combobox",
                        name: "FXFS_ID",
                        fieldLabel: '<span class="required">✶</span>发行方式',
                        store: DebtEleStore(json_debt_fxfs),
                        displayField: 'name',
                        valueField: 'id',
                        lines: false,
                        editable: false, //禁用编辑
                        listeners: {
                            'expand': function (self) {
                                //校验表格中是否存在数据
                                var ZhzqStore = DSYGrid.getGrid('winZhzqGrid').getStore();
                                var flag = true;
                                if (ZhzqStore.getCount() > 0) {
                                    Ext.Msg.confirm('提示', '更改债券类型将会清空已选择数据，是否继续修改？', function (btn_confirm) {
                                        if (btn_confirm === 'yes') {
                                            ZhzqStore.removeAll();
                                        }
                                    });
                                }
                            }
                        }
                    },
                    /* {
                     xtype: "combobox",
                     name: "PC_QUARTER",
                     fieldLabel: '<span class="required">✶</span>季度',
                     store: DebtEleStore(json_debt_jd),
                     displayField: 'name',
                     valueField: 'id',
                     lines: false,
                     editable: false
                     }, */
                    {
                        xtype: "combobox",
                        name: "PC_MONTEH",
                        fieldLabel: '<span class="required">✶</span>计划月份',
                        store: DebtEleStore(json_debt_yf),
                        displayField: 'name',
                        valueField: 'id',
                        lines: false,
                        editable: false
                    },
                    {
                        xtype: "datefield",
                        name: "ZB_DATE",
                        fieldLabel: '<span class="required">✶</span>招标日期',
                        format: 'Y-m-d',
                        blankText: '请选择招标日期',
                        emptyText: '请选择招标日期',
                        value: today
                    },
                    /* {
                     xtype: "treecombobox",
                     name: "ZJLY_ID",
                     store: DebtEleTreeStoreDB('DEBT_CHZJLY'),
                     displayField: "name",
                     valueField: "id",
                     fieldLabel: '偿还资金来源',
                     editable: false,
                     selectModel: 'leaf',
                     allowBlank: true
                     }, */
                    {
                        xtype: "numberFieldFormat",
                        name: "PLAN_FX_AMT",
                        fieldLabel: '<span class="required">✶</span>计划发行额',
                        emptyText: '0.00',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {
                            'select': function () {
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "PLAN_XZ_AMT",
                        fieldLabel: '<span class="required">✶</span>新增债券金额',
                        value: '0.00',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {
                            change: function (me, newValue, oldValue, eOpts) {
                                if (isNaN(newValue)) {
                                    me.setValue(0.00);
                                    newValue = 0.00;
                                }
                                var plan_zh_amt = me.up('form').down('numberFieldFormat[name="PLAN_ZH_AMT"]').getValue();
                                me.up('form').down('numberFieldFormat[name="PLAN_FX_AMT"]').setValue(plan_zh_amt + newValue);
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "PLAN_ZH_AMT",
                        fieldLabel: '<span class="required">✶</span>置换债券金额',
                        value: '0.00',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {
                            change: function (me, newValue, oldValue, eOpts) {
                                if (isNaN(newValue)) {
                                    me.setValue(0.00);
                                    newValue = 0.00;
                                }
                                var plan_xz_amt = me.up('form').down('numberFieldFormat[name="PLAN_XZ_AMT"]').getValue();
                                me.up('form').down('numberFieldFormat[name="PLAN_FX_AMT"]').setValue(plan_xz_amt + newValue);
                            }
                        }
                    }
                ]
            }
        ]
    });
    return pcjhForm;
}
var pcjh_choice_bar = [
    {
        xtype: "treecombobox",
        name: "AD_CODE",
        store: regStore,
        displayField: 'text',
        valueField: 'code',
        fieldLabel: '区划',
        rootVisible: false,
        editable: false, //禁用编辑
        labelWidth: 40,
        width: 210,
        labelAlign: 'right',
        listeners: {
            change: function (self, newValue) {
                //刷新当前表格
                self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                self.up('grid').getStore().loadPage(1);
            }
        }
    },
    {
        xtype: "treecombobox",
        name: "SBPC_ID",
        store: DebtEleTreeStoreDB('DEBT_FXPC'),
        displayField: "name",
        valueField: "id",
        fieldLabel: '申报批次',
        editable: false, //禁用编辑
        width: 200,
        labelWidth: 60,
        labelAlign: 'right',
        listeners: {
            'change': function (self, newValue) {
            }
        }
    },
    {
        xtype: 'button',
        text: '查询',
        icon: '/image/sysbutton/search.png',
        handler: function (btn) {
            //判断打开的窗口是新增还是置换  并对其里面表格进行刷新
            if (Ext.ComponentQuery.query('window[name="window_select_xzzq"]').length == 0) {
                refresh_winZhzqGrid(btn);
            } else {
                refresh_winXzzqGrid(btn);
            }
        }
    }
];
/**
 * 初始化弹出窗口中的新增债券明细表
 */
function initWin_XzzqGrid() {
    /**
     * 新增债券明细表表头
     */
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "ID", width: 150, type: "string", text: "申请单ID", hidden: true},
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "地区名称"},
        {dataIndex: "AG_NAME", width: 150, type: "string", text: "单位名称"},
        {
            dataIndex: "XM_NAME", width: 250, type: "string", text: "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "SORT_NO", width: 100, type: "string", text: "排序号", hidden: true},
        {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质"},
        {dataIndex: "APPLY_DATE", width: 100, type: "string", text: "申请日期"},
        {dataIndex: "XMLX_NAME", width: 180, type: "string", text: "项目类型"},
        {dataIndex: "BUILD_STATUS_NAME", width: 100, type: "string", text: "建设状态"},
        {dataIndex: "DISTRIBUTE_AMOUNT", width: 100, type: "float", text: "分配金额(元)", hidden: true},
        {
            dataIndex: "APPLY_AMOUNT1", width: 120, type: "float", text: "当年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "RETURN_CAPITAL", width: 150, type: "float", text: "其中用于偿还本金", hidden: true},
        {
            dataIndex: "APPLY_AMOUNT2", width: 150, type: "float", text: "第二年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "APPLY_AMOUNT3", width: 150, type: "float", text: "第三年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "XMZGS_AMT", width: 150, type: "string", text: "项目总概算金额(元)"},
        {dataIndex: "", width: 100, type: "string", text: "资金缺口"}
    ];
    var config = {
        itemId: 'winXzzqGrid',
        border: false,
        flex: 1,
        height: '100%',
        width: '100%',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: [],
        autoLoad: false,
        params: {},
        checkBox: true,
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }]
    };
    var grid = DSYGrid.createGrid(config);
    grid.getStore().on('endupdate', function () {
        var self = grid.getStore();
        var form = grid.up('window').down('form');
        var input_xzzq_amt = 0;
        self.each(function (record) {
            input_xzzq_amt += record.get('APPLY_AMOUNT1');
        });
        form.down('numberFieldFormat[name="PLAN_XZ_AMT"]').setValue(input_xzzq_amt);
    });
    grid.on('selectionchange', function (view, records) {
        grid.up('window').down('#pcjhDelBtn').setDisabled(!records.length);
    });
    return grid;
}
/**
 * 初始化弹出窗口中的置换债券明细表
 */
function initWin_ZhzqGrid() {
    /**
     * 置换债券明细表表头
     */
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "FLAG", width: 150, type: "string", text: "FLAG", hidden: true},
        {dataIndex: "ZHMX_ID", width: 150, type: "string", text: "ZHMX_ID", hidden: true},
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "地区名称"},
        {dataIndex: "AG_NAME", width: 150, type: "string", text: "单位名称"},
        {dataIndex: "YCHRQ", width: 150, type: "string", text: "到期日期"},
        {dataIndex: "YE", width: 150, type: "float", text: "到期金额(元)"},
        {dataIndex: "FXFS_NAME", width: 100, type: "string", text: "发行方式"},
        {dataIndex: "ZQQX_NAME", width: 150, type: "string", text: "发行期限(年)"},
        {dataIndex: "CXJG_NAME", width: 100, type: "string", text: "承销机构", hidden: true},
        {
            dataIndex: "APPLY_AMOUNT", width: 120, type: "float", text: "当年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "REPLY_AMOUNT", width: 120, type: "float", text: "批复金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "DEBT_NAME", width: 200, type: "string", text: "债务名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            dataIndex: "XM_NAME", width: 250, type: "string", text: "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "ZQR_NAME", width: 100, type: "string", text: "债权人"},
        {dataIndex: "ZQRQC", width: 200, type: "string", text: "债权人全称"},
        {dataIndex: "ZJYT_NAME", width: 100, type: "string", text: "债务用途"},
        {dataIndex: "QDRQ", width: 100, type: "string", text: "签订日期"},
        {dataIndex: "REVISE_DEBT_XYH", width: 150, type: "string", text: "协议号"},
        {dataIndex: "LX_RATE", width: 100, type: "float", text: "利率(%)"},
        {dataIndex: "ZWQX", width: 100, type: "int", text: "期限(月)"},
        {dataIndex: "BILL_YEAR", width: 100, type: "string", text: "申报年度"},
        {dataIndex: "ZQLX_NAME_STR", width: 100, type: "string", text: "申请类型"},
        {dataIndex: "ZWLB_NAME_STR", width: 100, type: "string", text: "债务类型"},
        {dataIndex: "DEBT_YE", width: 150, type: "float", text: "债务余额(元)"},
        {dataIndex: "DEBT_YQJE", width: 100, type: "float", text: "逾期金额(元)"},
        {dataIndex: "ZQLX_NAME", width: 100, type: "string", text: "债权类型"},
        {dataIndex: "CUR_NAME", width: 100, type: "string", text: "币种"},
        {dataIndex: "ROE", width: 100, type: "float", text: "汇率(%)"},
        {dataIndex: "XYJE", width: 100, type: "string", text: "协议金额(元)",
        renderer:function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        }},
        {
            dataIndex: "LX_TYPE", width: 100, type: "string", text: "利率类型"
        }
    ];
    var config = {
        itemId: 'winZhzqGrid',
        border: false,
        flex: 1,
        height: '100%',
        width: '100%',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: [],
        autoLoad: false,
        checkBox: true,
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }]
    };
    var grid = DSYGrid.createGrid(config);
    grid.getStore().on('endupdate', function () {
        var self = grid.getStore();
        var form = grid.up('window').down('form');
        var input_zhzq_amt = 0;
        self.each(function (record) {
            input_zhzq_amt += record.get('REPLY_AMOUNT');
        });
        form.down('numberFieldFormat[name="PLAN_ZH_AMT"]').setValue(input_zhzq_amt);
    });
    grid.on('selectionchange', function (view, records) {
        grid.up('window').down('#pcjhDelBtn').setDisabled(!records.length);
    });
    return grid;
}
/**
 * 初始化弹出窗口中的新增债券明细表
 */
function initWin_select_XzzqGrid() {
    /**
     * 新增债券明细表表头
     */
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "ID", width: 150, type: "string", text: "申请单ID", hidden: true},
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "地区名称"},
        {dataIndex: "AG_NAME", width: 150, type: "string", text: "单位名称"},
        {
            dataIndex: "XM_NAME", width: 250, type: "string", text: "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "SORT_NO", width: 100, type: "string", text: "排序号", hidden: true},
        {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质"},
        {dataIndex: "APPLY_DATE", width: 100, type: "string", text: "申请日期"},
        {dataIndex: "XMLX_NAME", width: 180, type: "string", text: "项目类型"},
        {dataIndex: "BUILD_STATUS_NAME", width: 100, type: "string", text: "建设状态"},
        {dataIndex: "DISTRIBUTE_AMOUNT", width: 100, type: "float", text: "分配金额(元)", hidden: true},
        {
            dataIndex: "APPLY_AMOUNT1", width: 120, type: "float", text: "当年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "RETURN_CAPITAL", width: 150, type: "float", text: "其中用于偿还本金", hidden: true},
        {
            dataIndex: "APPLY_AMOUNT2", width: 150, type: "float", text: "第二年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "APPLY_AMOUNT3", width: 150, type: "float", text: "第三年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "XMZGS_AMT", width: 150, type: "string", text: "项目总概算金额(元)"},
        {dataIndex: "", width: 100, type: "string", text: "资金缺口"}
    ];
    var config = {
        itemId: 'winSelectXzzqGrid',
        border: false,
        flex: 1,
        height: '100%',
        width: '100%',
        tbar: pcjh_choice_bar,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: 'getPcjhWinXzzqGrid.action',
        autoLoad: false,
        params: {},
        checkBox: true,
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }]
    };
    var grid = DSYGrid.createGrid(config);
    return grid;
}
/**
 * 初始化弹出窗口中的置换债券明细表
 */
function initWin_select_ZhzqGrid() {
    /**
     * 置换债券明细表表头
     */
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "FLAG", width: 150, type: "string", text: "FLAG", hidden: true},
        {dataIndex: "ZHMX_ID", width: 150, type: "string", text: "ZHMX_ID", hidden: true},
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "地区名称"},
        {dataIndex: "AG_NAME", width: 150, type: "string", text: "单位名称"},
        {dataIndex: "YCHRQ", width: 150, type: "string", text: "到期日期"},
        {
            dataIndex: "YE", width: 150, type: "float", text: "到期金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "FXFS_NAME", width: 100, type: "string", text: "发行方式"},
        {dataIndex: "ZQQX_NAME", width: 150, type: "string", text: "发行期限(年)"},
        {dataIndex: "CXJG_NAME", width: 100, type: "string", text: "承销机构", hidden: true},
        {
            dataIndex: "APPLY_AMOUNT", width: 260, type: "float", text: "当年申请金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "REPLY_AMOUNT", width: 220, type: "float", text: "批复金额(元)", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "DEBT_NAME", width: 200, type: "string", text: "债务名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            dataIndex: "XM_NAME", width: 250, type: "string", text: "项目名称",
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "ZQR_NAME", width: 100, type: "string", text: "债权人"},
        {dataIndex: "ZQRQC", width: 200, type: "string", text: "债权人全称"},
        {dataIndex: "ZJYT_NAME", width: 100, type: "string", text: "债务用途"},
        {dataIndex: "QDRQ", width: 100, type: "string", text: "签订日期"},
        {dataIndex: "REVISE_DEBT_XYH", width: 150, type: "string", text: "协议号"},
        {dataIndex: "LX_RATE", width: 100, type: "float", text: "利率(%)"},
        {dataIndex: "ZWQX", width: 100, type: "int", text: "期限(月)"},
        {dataIndex: "BILL_YEAR", width: 100, type: "string", text: "申报年度"},
        {dataIndex: "ZQLX_NAME_STR", width: 100, type: "string", text: "申请类型"},
        {dataIndex: "ZWLB_NAME_STR", width: 100, type: "string", text: "债务类型"},
        {dataIndex: "DEBT_YE", width: 150, type: "float", text: "债务余额(元)"},
        {dataIndex: "DEBT_YQJE", width: 100, type: "float", text: "逾期金额(元)"},
        {dataIndex: "ZQLX_NAME", width: 100, type: "string", text: "债权类型"},
        {dataIndex: "CUR_NAME", width: 100, type: "string", text: "币种"},
        {dataIndex: "ROE", width: 100, type: "float", text: "汇率(%)"},
        {dataIndex: "XYJE", width: 100, type: "string", text: "协议金额(元)",
        renderer:function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        }
        },
        {dataIndex: "LX_TYPE", width: 100, type: "string", text: "利率类型"}
    ];
    var config = {
        itemId: 'winSelectZhzqGrid',
        border: false,
        flex: 1,
        height: '100%',
        width: '100%',
        tbar: pcjh_choice_bar,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: 'getPcjhWinZhzqGrid.action',
        autoLoad: false,
        checkBox: true,
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }]
    };
    var grid = DSYGrid.createGrid(config);
    return grid;
}
/**
 * 初始化选择新增债券计划弹出窗口
 */
function initWin_select_xzzq() {
    var window = Ext.create('Ext.window.Window', {
        title: '新增债券计划',
        name: 'window_select_xzzq',
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        frame: true,
        constrain: true,
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: true,//大小不可改变
        plain: true,
        layout: 'fit',
        maximizable: true,
        items: [initWin_select_XzzqGrid()],
        closeAction: 'destroy',
        buttons: [
            {
                xtype: 'button',
                text: '确定',
                name: 'SAVE',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录后进行操作');
                        return;
                    }
                    var sqGridStore = DSYGrid.getGrid('winXzzqGrid').getStore();
                    for (var i in records) {
                        var record_data = records[i].getData();
                        var record = sqGridStore.findRecord('ID', records[i].get('ID'), 0, false, true, true);
                        if (record == null) {
                            DSYGrid.getGrid('winXzzqGrid').insertData(null, record_data);
                        }
                    }
                    btn.up('window').close();
                }
            },
            {
                xtype: 'button',
                text: '取消',
                name: 'CLOSE',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    window.show();
}
/**
 * 初始化选择置换债券计划弹出窗口
 */
function initWin_select_zhzq() {
    var window = Ext.create('Ext.window.Window', {
        title: '置换债券计划',
        name: 'window_select_zhzq',
        width: document.body.clientWidth * 0.9,
        height: document.body.clientHeight * 0.9,
        frame: true,
        constrain: true,
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: true,//大小不可改变
        plain: true,
        layout: 'fit',
        maximizable: true,
        items: [initWin_select_ZhzqGrid()],
        closeAction: 'destroy',
        buttons: [
            {
                xtype: 'button',
                text: '确定',
                name: 'SAVE',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录后进行操作');
                        return;
                    }
                    var sqGridStore = DSYGrid.getGrid('winZhzqGrid').getStore();
                    //重新定义一个数组，来保存筛选以后的数据，优化页面特点是：把插入操作放到最后一步执行，避免在for循环中每次都要调用insertDate方法,严重影响系统效率
                    var newarray=new Array();
                    for (var i in records) {
                        var record_data = records[i].getData();
                        var record = sqGridStore.findRecord('ZHMX_ID', records[i].get('ZHMX_ID'), 0, false, true, true);
                        if (record == null) {
                         newarray.push(record_data);
                        }
                    }
                    DSYGrid.getGrid('winZhzqGrid').insertData(null, newarray);
                    btn.up('window').close();
                }
            },
            {
                xtype: 'button',
                text: '取消',
                name: 'CLOSE',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    window.show();
}
/**
 * 刷新主页面的主表格
 */
function refresh_contentMainGrid() {
    //var zqlb_id = Ext.ComponentQuery.query('combobox[name="MAIN_ZQLB_ID"]')[0].value;
    //var set_year = Ext.ComponentQuery.query('combobox[name="SET_YEuoAR"]')[0].value;
    WF_STATUS = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0].value;
    var store = DSYGrid.getGrid('contentMainGrid').getStore();
    var dtlXzxmStore = DSYGrid.getGrid('contentXzzqGrid').getStore();
    var dtlZhxmStore = DSYGrid.getGrid('contentZhzqGrid').getStore();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        wf_id: wf_id,
        node_code: node_code,
        userCode: userCode,
        WF_STATUS: WF_STATUS/* ,
         SET_YEAR: set_year,
         ZQLB_ID: zqlb_id */
    };
    //刷新表格内容
    store.loadPage(1);
    dtlXzxmStore.removeAll();
    dtlZhxmStore.removeAll();
}
/**
 * 刷新计划批次弹出窗口中的表格
 */
function refresh_detailGrid(pcjh_id) {
    refresh_xzzqDetailGrid(pcjh_id);
    refresh_zhzqDetailGrid(pcjh_id);
}
/**
 * 刷新计划批次弹出窗口中的置换债券表格
 */
function refresh_zhzqDetailGrid(pcjh_id) {
    var store = DSYGrid.getGrid('contentZhzqGrid').getStore();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        pcjh_id: pcjh_id
    };
    //刷新表格内容
    store.loadPage(1);
}
/**
 * 刷新计划批次弹出窗口中的置换债券表格
 */
function refresh_xzzqDetailGrid(pcjh_id) {
    var store = DSYGrid.getGrid('contentXzzqGrid').getStore();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        pcjh_id: pcjh_id
    };
    //刷新表格内容
    store.loadPage(1);
}
/**
 * 刷新计划批次弹出窗口中的表格
 */
/*     function refresh_winGrid() {
 zqlb_id = Ext.ComponentQuery.query('combobox[name="ZQLB_ID"]')[0].value;
 if (zqlb_id == '01') {
 refresh_winXzzqGrid();
 } else {
 refresh_winZhzqGrid();
 }
 } */
/**
 * 刷新计划批次弹出窗口中的新增债券表格
 */
function refresh_winXzzqGrid(btn) {
    //fxpc_id = Ext.ComponentQuery.query('combobox[name="FXPC_ID"]')[0].value;
    var ad_code = Ext.ComponentQuery.query('treecombobox[name="AD_CODE"]')[0].getValue();
    var sbpc_id = Ext.ComponentQuery.query('treecombobox[name="SBPC_ID"]')[0].getValue();
    var zqlx_id = Ext.ComponentQuery.query('treecombobox[name="ZQLX_ID"]')[0].getValue();
    var store = DSYGrid.getGrid('winSelectXzzqGrid').getStore();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        ad_code: ad_code,
        sbpc_id: sbpc_id,
        zqlx_id: zqlx_id
    };
    //刷新表格内容
    store.loadPage(1);
}
/**
 * 刷新计划批次弹出窗口中的置换债券表格
 */
function refresh_winZhzqGrid(btn) {
    //fxpc_id = Ext.ComponentQuery.query('combobox[name="FXPC_ID"]')[0].value;
    var ad_code = Ext.ComponentQuery.query('treecombobox[name="AD_CODE"]')[0].getValue();
    var sbpc_id = Ext.ComponentQuery.query('treecombobox[name="SBPC_ID"]')[0].getValue();
    var zqlx_id = Ext.ComponentQuery.query('treecombobox[name="ZQLX_ID"]')[0].getValue();
    var fxfs_id = Ext.ComponentQuery.query('combobox[name="FXFS_ID"]')[0].getValue();
    var store = DSYGrid.getGrid('winSelectZhzqGrid').getStore();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        ad_code: ad_code,
        sbpc_id: sbpc_id,
        zqlx_id: zqlx_id,
        fxfs_id: fxfs_id
    };
    //刷新表格内容
    store.loadPage(1);
}
/**
 * 提交表单数据
 * @param form
 */
function submitPcjh(form) {
    var records = null;
    var xzzqXmArray = [];//新增债券项目
    var zhzqXmArray = [];//置换债券计划
    var xzzqStore = DSYGrid.getGrid('winXzzqGrid').getStore();
    var zhzqStore = DSYGrid.getGrid('winZhzqGrid').getStore();
    if (xzzqStore.getCount() == 0 && zhzqStore.getCount() == 0) {
        Ext.MessageBox.alert('提示', '请添加批次计划数据！');
        return;
    }
    DSYGrid.getGrid('winXzzqGrid').getStore().each(function (record) {
        xzzqXmArray.push(record.getData()); //新增债券项目
    });
    DSYGrid.getGrid('winZhzqGrid').getStore().each(function (record) {
        zhzqXmArray.push(record.getData()); //置换债券计划
    });
    /*
     if (zqlb_id == '01') {
     records = DSYGrid.getGrid('winXzzqGrid').getSelectionModel().getSelection();
     if (records.length == 0) {
     Ext.MessageBox.alert('提示', '请至少选择一条记录！');
     return;
     }
     Ext.each(records, function (record) {
     var array = {};
     array.ZQXM_ID = record.get("ID");
     zqxmArray.push(array);
     });
     } else {
     records = DSYGrid.getGrid('winZhzqGrid').getSelectionModel().getSelection();
     if (records.length == 0) {
     Ext.MessageBox.alert('提示', '请至少选择一条记录！');
     return;
     }
     Ext.each(records, function (record) {
     var array = {};
     array.ZQXM_ID = record.get("ZHMX_ID");
     zqxmArray.push(array);
     });
     }
     */
    var url = '';
    if (button_name == 'INPUT') {
        url = 'savePcjh.action';
    } else {
        url = 'updatePcjh.action?PCJH_ID=' + pcjh_id;
    }

    if (form.isValid()) {
        form.submit({
            url: url,
            params: {
                wf_id: wf_id,
                node_code: node_code,
                button_name: button_name,
                userCode: userCode,
                xzzqXmArray: Ext.util.JSON.encode(xzzqXmArray),
                zhzqXmArray: Ext.util.JSON.encode(zhzqXmArray)
            },
            waitTitle: '请等待',
            waitMsg: '正在保存中...',
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '保存成功',
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        Ext.ComponentQuery.query('window[name="pcjhWin"]')[0].close();
                        DSYGrid.getGrid("contentMainGrid").getStore().loadPage(1);
                    }
                });
            },
            failure: function (form, action) {
                Ext.Msg.alert('提示', "保存失败！" + action.result ? action.result.message : '无返回响应');
            }
        });
    } else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
    }
}
/**
 * 加载页面数据
 * @param form
 */
function loadPcjh(form) {
    form.load({
        url: 'loadPcjh.action?PCJH_ID=' + pcjh_id,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            form.getForm().setValues(action.result.data.list);
            zqlb_id = action.result.data.list.ZQLB_ID;
            var xzzqXmStore = action.result.data.xzzqXmList;
            var zhzqXmStore = action.result.data.zhzqXmList;
            //设置新增债券表格
            var grid = DSYGrid.getGrid('winXzzqGrid');
            grid.insertData(null, xzzqXmStore);
            //设置置换债券表格
            var grid = DSYGrid.getGrid('winZhzqGrid');
            grid.insertData(null, zhzqXmStore);
        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });
}
/**
 * 删除批次计划
 */
function deletePcjh(btn) {
    var records = DSYGrid.getGrid('contentMainGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    }
    button_name = btn.text;
    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            var pcjhArray = [];
            Ext.each(records, function (record) {
                var array = {};
                array.PCJH_ID = record.get("PCJH_ID");
                pcjhArray.push(array);
            });
            //向后台传递变更数据信息
            $.post('/deletePcjh.action', {
                wf_id: wf_id,
                node_code: node_code,
                button_name: button_name,
                pcjhArray: Ext.util.JSON.encode(pcjhArray)
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html: button_name + "成功！" + (data.message ? data.message : ''),
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    refresh_contentMainGrid();
                } else {
                    Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
                    refresh_contentMainGrid();
                }
            }, 'json');
        }
    });
}
/**
 * 创建填写意见对话框
 */
var opinionWindow = {
    window: null,
    open: function (action, title) {
        Ext.MessageBox.buttonText.ok = '确认';
        Ext.MessageBox.buttonText.cancel = '取消';
        this.window = top.Ext.MessageBox.show({
            title: title,
            width: 350,
            buttons: Ext.MessageBox.OKCANCEL,
            multiline: true,
            value: action == 'NEXT' ? '同意' : '',
            fn: function (btn, text) {
                audit_info = text;
                if (btn == "ok") {
                    if (action == 'NEXT') {
                        button_name = next_text;
                        func_node('/nextPcjh.action');
                    } else if (action == 'BACK') {
                        button_name = '退回';
                        func_node('/backPcjh.action');
                    }
                }
            }
            //animateTarget: btn_target
        });
    },
    close: function () {
        if (this.window) {
            this.window.close();
        }
    }
};
/**
 * 工作流
 */
function func_node(url) {
    var records = DSYGrid.getGrid('contentMainGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return false;
    }
    var pcjhArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.ID = record.get("PCJH_ID");
        pcjhArray.push(array);
    });
    //向后台传递变更数据信息
    $.post(url, {
        wf_id: wf_id,
        node_code: node_code,
        button_name: button_name,
        audit_info: audit_info,
        userCode: userCode,
        pcjhArray: Ext.util.JSON.encode(pcjhArray)
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: button_name + "成功！" + (data.message ? data.message : ''),
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            refresh_contentMainGrid();
        } else {
            Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
            refresh_contentMainGrid();
        }
    }, 'json');
}
/**
 * 初始化按钮
 */
function initButton() {
    var combo_WF_STATUS = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0];
    var btn_insert = Ext.ComponentQuery.query('button[name="btn_insert"]')[0];
    var btn_update = Ext.ComponentQuery.query('button[name="btn_update"]')[0];
    var btn_delete = Ext.ComponentQuery.query('button[name="btn_delete"]')[0];
    var btn_next = Ext.ComponentQuery.query('button[name="btn_next"]')[0];
    var btn_cancel = Ext.ComponentQuery.query('button[name="btn_cancel"]')[0];
    var btn_back = Ext.ComponentQuery.query('button[name="btn_back"]')[0];
    //根据当前结点状态，控制状态下拉框绑定的json以及按钮的显示与隐藏
    if (node_code == '1') {
        combo_WF_STATUS.bindStore(DebtEleStore(json_debt_zt0));
        if (combo_WF_STATUS.value == '001') {
            btn_insert.show();
            btn_update.show();
            btn_delete.show();
            btn_cancel.hide();
            btn_next.show();
            btn_back.hide();
        } else if (combo_WF_STATUS.value == '002') {
            btn_insert.hide();
            btn_update.hide();
            btn_delete.hide();
            btn_cancel.show();
            btn_next.hide();
            btn_back.hide();
        } else if (combo_WF_STATUS.value == '004') {
            btn_insert.hide();
            btn_update.show();
            btn_delete.show();
            btn_cancel.hide();
            btn_next.show();
            btn_back.hide();
        } else {
            btn_insert.hide();
            btn_update.hide();
            btn_delete.hide();
            btn_next.hide();
            btn_back.hide();
            btn_cancel.hide();
        }
    } else if (node_code == '2') {
        combo_WF_STATUS.bindStore(DebtEleStore(json_debt_sh));
        btn_insert.hide();
        btn_update.hide();
        btn_delete.hide();
        if (combo_WF_STATUS.value == '001') {
            btn_next.show();
            btn_back.show();
            btn_cancel.hide();
        } else if (combo_WF_STATUS.value == '002') {
            btn_next.hide();
            btn_back.hide();
            btn_cancel.show();
        } else if (combo_WF_STATUS.value == '004') {
            btn_next.show();
            btn_back.show();
            btn_cancel.hide();
        } else {
            btn_next.hide();
            btn_back.hide();
            btn_cancel.hide();
        }
    }
}
/**
 * 初始化地区汇总弹出框
 */
function initWindow_DQHZ(params) {
    Ext.create('Ext.window.Window', {
        title: '批次计划地区汇总',
        width: document.body.clientWidth * 0.70,
        height: document.body.clientHeight * 0.70,
        items: [initDqhzGrid(params)],
        modal: true,
        buttons: [
            {
                xtype: 'button',
                text: '关闭',
                name: 'CLOSE_BTN',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    }).show();
}
/**
 * 初始化主界面一般债券明细表
 */
function initDqhzGrid(params) {
    /**
     * 新增债券明细表表头
     */
    var headerJson = [
        {xtype: 'rownumberer', width: 35},
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "地区名称"},
        {dataIndex: "TOTAL_AMT", width: 160, type: "float", text: "债券总金额(元)"},
        {dataIndex: "XZZQ_AMT", width: 160, type: "float", text: "新增债券金额(元)"},
        {dataIndex: "ZHZQ_AMT", width: 160, type: "float", text: "置换债券金额(元)"}
    ];
    var config = {
        itemId: 'dqhzGrid',
        border: false,
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/getPcjhDqhzGrid.action',
        autoLoad: true,
        params: params,
        height: '50%',
        tbar: [
            {
                xtype: 'button',
                text: '导出',
                name: 'up',
                icon: '/image/sysbutton/export.png',
                handler: function (btn) {
                    var xzzqXmArray = [];//新增债券项目
                    var zhzqXmArray = [];//置换债券计划
                    var xzzqStore = DSYGrid.getGrid('winXzzqGrid').getStore();
                    var zhzqStore = DSYGrid.getGrid('winZhzqGrid').getStore();
                    DSYGrid.getGrid('winXzzqGrid').getStore().each(function (record) {
                        xzzqXmArray.push(record.getData()); //新增债券项目
                    });
                    DSYGrid.getGrid('winZhzqGrid').getStore().each(function (record) {
                        zhzqXmArray.push(record.getData()); //置换债券计划
                    });
                    DSYGrid.exportExcelClick('dqhzGrid', {
                        exportExcel: true,
                        url: 'exportExcel_pcjh_dqhz.action',
                        param: {
                            xzzqXmArray: Ext.util.JSON.encode(xzzqXmArray),
                            zhzqXmArray: Ext.util.JSON.encode(zhzqXmArray)
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '打印',
                name: 'btn_print',
                icon: '/image/sysbutton/print.png',
                handler: function (btn) {
                }
            }
        ],
        pageConfig: {
            enablePage: false
        }
    };
    var grid = DSYGrid.createGrid(config);
    return grid;
}
</script>
</body>
</html>