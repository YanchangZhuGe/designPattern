<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>债券转贷确认</title>
    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <!--基础数据集-->
    <script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
        }
        .x-grid-row-summary .x-grid-cell-inner {
            font-weight      : bold;
            font-size        : 14px;
            background-color : #ffd800;
        }
    </style>
</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<script type="text/javascript">
    /**
     * 通用函数：获取url中的参数
     */
    /*function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    }*/
    /**
     * 设置全局变量
     */
    /*获取登录用户*/
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/,"");
    var USER_CODE = '${sessionScope.USERCODE}';
    var button_name = '';//按钮名称
    var next_text = '';//送审、审核按钮显示文字
    var audit_info = '';//送審意見
 /*   var WF_STATUS = getUrlParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var SYS_IS_QEHBFX = '';//系统参数：是否支持分摊承担本金利息
    //全局变量
    //区分录入新增债券、置换和再融资债券转贷信息
    //0：不区分；1：录入新增债券；2：录入置换和再融资数据
/*
    var is_xzzd = getUrlParam("is_xzzd");
*/    var is_xzzd ="${fns:getParamValue('is_xzzd')}";
    if(typeof is_xzzd == 'undefined' || null==is_xzzd){
        is_xzzd = '0';
    }
    //提前获取以下store，弹出框中使用，表格中使用
    /**
     * 通用配置json
     */
    var zdhk_json_common = {
        items: {
            '001': [
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '确认',
                    name: 'down',
                    icon: '/image/sysbutton/confirm.png',
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if(records.length >=1){
                            zdConfirmWindow.show(records);
                        }else{
                            Ext.MessageBox.alert('提示', '请选择一条数据');
                            return;
                        }
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
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销确认',
                    name: 'up',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        },
        store: {
            WF_STATUS: DebtEleStore(json_debt_zt3)
        }
    };
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        $.post("getParamValueAll.action", function (data) {
            SYS_IS_QEHBFX = data[0].SYS_IS_QEHBFX;
            initContent();
        },"json");
    });
    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            height: '100%',
            renderTo: 'contentPanel',
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: zdhk_json_common.items[WF_STATUS]
                }
            ],
            items: [
                initContentGrid()
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer',width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                dataIndex: "ZQ_CODE",
                type: "string",
                text: "债券编码",
                width: 130
            },
            {
                dataIndex: "ZQ_NAME",
                type: "string",
                width: 250,
                text: "债券名称",
                renderer: function (data, cell, record) {
                    if(WF_STATUS == '002') {
                        /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+AD_CODE;
                        return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                        var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                        var paramNames=new Array();
                        paramNames[0]="ZQ_ID";
                        paramNames[1]="AD_CODE";
                        var paramValues=new Array();
                        paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                        paramValues[1]=encodeURIComponent(AD_CODE);
                        var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                        return result;
                    }else {
                        return data;
                    }
                }
            },
            {
                dataIndex: "ZQ_JC",
                type: "string",
                width: 150,
                text: "债券简称"
            },
            {
                dataIndex: "ZQQX_NAME",
                width: 100,
                type: "string",
                text: "债券期限"
            },
            {
                dataIndex: "ZQLB_NAME",
                type: "string",
                text: "债券类型",
                width: 130
            },
            {
                dataIndex: "FX_AMT",
                width: 150,
                hidden: true,
                type: "float",
                text: "债券金额（元）",summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "PM_RATE",
                width: 150,
                type: "float",
                text: "票面利率（%）"
            },
            {
                dataIndex: "AD_CODE",
                width: 100,
                type: "string",
                text: "转贷地区",
                hidden: true
            },
            {
                dataIndex: "AD_NAME",
                width: 100,
                type: "string",
                text: "转贷地区"
            },
            {
                dataIndex: "ZD_AMT",
                width: 150,
                type: "float",
                text: "转贷金额（元）",summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDBJ_AMT",
                width: 150,
                type: "float",
                hidden: SYS_IS_QEHBFX==0,
                text: "承担本金（元）",summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDLX_AMT",
                width: 150,
                type: "float",
                hidden: SYS_IS_QEHBFX==0,
                text: "承担利息（元）",summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "XZ_AMT",
                width: 180,
                type: "float",
                text: "其中新增金额（元）",summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZH_AMT",
                width: 150,
                type: "float",
                text: "置换金额（元）",summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HB_AMT",
                width: 150,
                type: "float",
                text: "再融资金额（元）",summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "QX_DATE",
                width: 150,
                type: "string",
                text: "起息日"
            },
            {
                dataIndex: "TQHK_DAYS",
                width: 150,
                type: "string",
                text: "提前还款天数"
            },
            {
                dataIndex: "ZNJ_RATE",
                width: 150,
                type: "float",
                text: "滞纳金率（%）",
                renderer: function (value) {
                    return Ext.util.Format.number(value , '0,000.00####');
                }
            },
            {
                dataIndex: "IS_ZD",
                width: 100,
                type: "string",
                text: "是否已转贷",
                hidden:true
            },
            {
                dataIndex: "IS_ZDHK",
                width: 100,
                type: "string",
                text: "是否已转贷还款",
                hidden:true
            },
            {
                dataIndex: "IS_ZC",
                width: 100,
                type: "string",
                text: "是否已支出",
                hidden:true
            }
        ];
        var simplyGrid = new DSYGridV2();
        return simplyGrid.create({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                WF_STATUS: WF_STATUS,
                SET_YEAR: '',
                is_xzzd:is_xzzd
            },
            features: [{
                ftype: 'summary'
            }],
            dataUrl: 'getZdConfirmMainGridData.action',
            checkBox: true,
            border: false,
            height: '100%',
            width: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: zdhk_json_common.store['WF_STATUS'],
                    width: 110,
                    labelWidth: 30,
                    editable: false, //禁用编辑
                    labelAlign: 'right',
                    displayField: "name",
                    valueField: "id",
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(zdhk_json_common.items[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                },
                {
                    xtype: "combobox",
                    name: "SET_YEAR",
                    store: DebtEleStore(getYearList()),
                    displayField: "name",
                    valueField: "id",
                    value:'',
                    fieldLabel: '年度',
                    editable: false, //禁用编辑
                    labelWidth: 40,
                    width: 150,
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
                    name: "ZQLB_CODE",
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券类型',
                    editable: false, //禁用编辑
                    labelWidth: 70,
                    width: 180,
                    labelAlign: 'right',
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                }
            ],
            tbarHeight: 50,
            pageConfig: {
                pageNum: true,//设置显示每页条数
                pageSize: 20
            }
        });
    }
    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        // 检验是否选中数据
        // 获取选中数据
        btn.setDisabled(true) ;  //防止点击两次确认按钮导致数据错误，所以设置为不可点击
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            btn.setDisabled(false) ;
            return;
        }
        var ids = [];
        var zdInfoArray = [];
        for (var i in records) {
            ids.push(records[i].get("ZD_DETAIL_ID"));
            if (btn.name == 'up') {
                /*if (records[i].get('IS_ZD') == '1') {
                    Ext.Msg.alert('提示', '选择撤销的债券已被转贷，无法撤销！');
                    btn.setDisabled(false) ;
                    return false;
                }
                if (records[i].get('IS_ZC') == '1') {
                    Ext.Msg.alert('提示', '选择撤销的债券已被使用，无法撤销！');
                    btn.setDisabled(false) ;
                    return false;
                }
                if (records[i].get('IS_ZDHK') == '1') {
                    Ext.Msg.alert('提示', '选择撤销的债券已被转贷还款，无法撤销！');
                    btn.setDisabled(false) ;
                    return false;
                }*/

            }
            var array = {};
            array.ZD_DATE = records[i].get("ZD_DATE");
            array.AD_CODE = records[i].get("AD_CODE");
            array.ZQ_ID = records[i].get("ZQ_ID");
            array.ZQ_ID = records[i].get("ZD_AMT")*10000;
            zdInfoArray.push(array);
        }
        button_name = btn.text;
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text,
            animateTarget: btn,
            value: btn.name == 'up' ? null : '确认',
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    Ext.ComponentQuery.query('#msgBox')[0].msgButtons[0].setDisabled(true);
                    //发送ajax请求，修改节点信息
                    $.post("/updateZdhkConfirm.action", {
                        button_name: button_name,
                        ids: ids,
                        zdInfoArray: Ext.util.JSON.encode(zdInfoArray)
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            btn.setDisabled(false) ;
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                            btn.setDisabled(false) ;
                        }
                        //刷新表格
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }, "json");
                } else {
                    Ext.ComponentQuery.query('#msgBox')[0].msgButtons[0].setDisabled(false);
                    btn.setDisabled(false) ;
                }
            }
        });
    }
    var zdConfirmWindow = {
        window: null,
        show: function (records) {
            if (!this.window) {
                this.window = initWindow_zd_confirm(records);
            }
            this.window.show();
        }
    };
    /**
     * 初始化债券转贷选择实际到账日期窗口
     */
    function initWindow_zd_confirm(records) {//isHaveProject是否有未形成资产的项目
        return Ext.create('Ext.window.Window', {
            title: '选择实际到账日期',
            width: 330,
            height: 180,
            itemId: 'sbWindow',
            closeAction: 'destroy',
            layout: 'column',
            modal: true,
            items: [initWindow_zd_confirm_form()],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        var form = btn.up('window').down('form');
                        if(!form.isValid()){
                            Ext.toast({
                                html: "录入数据未通过校验，请检查!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        if (!form.down('[name=ZD_DZ_DATE]').getValue()) {
                            Ext.Msg.alert('提示', '实际到账日期不能为空！');
                            return false;
                        }else{
                            if(form.down('[name=ZD_DZ_DATE]').getValue()>new Date()){
                                Ext.Msg.alert('提示', '实际到账日期不能大于现在日期！');
                                return false;
                            }
                        }

                        var zd_dz_date = dsyDateFormat(form.down('[name=ZD_DZ_DATE]').getValue());
                        doWorkFlow_dzDate(btn,zd_dz_date,records);
                    }
                },
                {
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ],
            listeners: {
                close: function () {
                    zdConfirmWindow.window = null;
                }
            }
        });
    }
    /**
     * 初始化债券转贷选择实际到账日期窗口表单
     */
    function initWindow_zd_confirm_form() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            border: false,
            items: [
                {
                    fieldLabel: '实际到账日期',
                    name: "ZD_DZ_DATE",
                    xtype: "datefield",
                    margin: {
                        top: 40,
                        left: 5
                    },
                    allowBlank: false,
                    editable: false,
                    labelAlign: 'right',
                    format: 'Y-m-d',
                    listeners: {
                    }
                }
            ]
        });
    }
    /**
     * 带有实际到账日期的工作流变更
     */
    function doWorkFlow_dzDate(btn,zd_dz_date,records) {
        // 检验是否选中数据
        // 获取选中数据
        btn.setDisabled(true) ;  //防止点击两次确认按钮导致数据错误，所以设置为不可点击
        /*var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            btn.setDisabled(false) ;
            return;
        }*/
        var ids = [];
        var zdInfoArray = [];
        for (var i in records) {
            ids.push(records[i].get("ZD_DETAIL_ID"));
            if (btn.name == 'up') {
            }
            var array = {};
            array.ZD_DATE = records[i].get("ZD_DATE");
            array.AD_CODE = records[i].get("AD_CODE");
            array.ZQ_ID = records[i].get("ZQ_ID");
            array.ZQ_ID = records[i].get("ZD_AMT")*10000;
            zdInfoArray.push(array);
        }
        button_name = btn.text;
        var btn_close=Ext.ComponentQuery.query('MessageBox[itemId="msgBox"]')[0];
        if(btn_close!=null&&btn_close!=undefined){
            btn_close.msgButtons[0].setDisabled(true);
        }
        //发送ajax请求，修改节点信息
        $.post("/updateZdhkConfirm.action", {
            button_name: button_name,
            ids: ids,
            zd_dz_date: zd_dz_date,//实际到账日期
            zdInfoArray: Ext.util.JSON.encode(zdInfoArray)
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: button_name + "成功！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                btn.setDisabled(false) ;
            } else {
                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                btn.setDisabled(false) ;
            }
            btn.up('window').close();
            //刷新表格
            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
        }, "json");
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
            closeAction: default_config.closeAction,
            itemId: 'msgBox'
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
     * 刷新content主表格
     */
    function reloadGrid() {
        var store = DSYGrid.getGrid('contentGrid').getStore();
        //增加查询参数
        store.loadPage(1);
    }

</script>
</body>
</html>