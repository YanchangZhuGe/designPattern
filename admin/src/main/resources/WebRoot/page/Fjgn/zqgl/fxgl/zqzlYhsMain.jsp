<!-- 债券总览功能界面 -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script src="../data/ele_data.js"></script>
    <script src="fxglEditor.js"></script>
    <script src="fxglFxxx.js"></script>
    <script type="text/javascript" src="/js/plat/SetItemReadOnly.js"></script>
    <title>加载中..</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }
        .grid-cell {
            background-color: #ffe850;
        }
        .grid-cell-unedit {
            background-color: #E6E6E6;
        }
        .x-grid-row-summary .x-grid-cell-inner {
            font-weight: bold;
            font-size: 14px;
            background-color: #ffd800;
        }
        .x-grid-back-green {
            background: #00ff00;
        }
        span.required {
            color: red;
            font-size: 100%;
        }
        span.displayfield{
            font-weight:bolder;
            font-size:16;
        }
    </style>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    // 获取session数据
    var userCode = '${sessionScope.USERCODE}';
    var ag_code = '${sessionScope.AGCODE}';
    var ZQ_BILL_ID = '${fns:getParamValue("ZQ_BILL_ID")}';
    var AD_CODE = '${fns:getParamValue("AD_CODE")}'.replace(/00$/, "") ;
    var ZQ_ID = '${fns:getParamValue("ZQ_ID")}';
    if(ag_code != null && ag_code != '' && ag_code != 'null' ) {
        window.location.href = "/error.html";
    }
    // 获取系统参数
    var IS_BZB = '${fns:getSysParam("IS_BZB")}'; // 系统参数：0：债券兑付系统 1：地方政府债务系统
    var ELE_AD_CODE = '${fns:getSysParam("ELE_AD_CODE")}'; // 系统所属省级区划编码 省、直辖市 、计划单列市

    // 获取Url 参数

    // 自定义参数
    var button_name = '';//按钮名称
    var ZQ_NAME = '';
    var ZQ_CODE = '';
    var AD_NAME = '';
    var IS_VALUE = '1';

    var json_debt_zqqxfw = [ // 债券期限范围
        {"id": "10", "code": "10", "name": "1-10年"},
        {"id": "20", "code": "20", "name": "11-20年"},
        {"id": "30", "code": "30", "name": "21-30年"}
    ];

    /**
     *發送請求獲取債券名稱、債券編碼、地區名稱
     */
    $.post("/getZqCode_ZqName_AdName.action", {
        ZQ_ID: ZQ_ID,
        ad_code: AD_CODE
    }, function (data) {
        if (!data.success) {
            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
            return;
        }
        AD_NAME = data.list[0].AD_NAME;
        ZQ_CODE = data.list[0].ZQ_CODE;
        ZQ_NAME = data.list[0].ZQ_NAME;
        var tool = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar');
        if(tool && tool.length>0) {
            tool[0].down("displayfield[name='zq_name']").setValue('<span class="displayfield">'+ZQ_CODE+' '+ZQ_NAME+'</span>');
            tool[0].down("displayfield[name='ad_name']").setValue('<span class="displayfield">'+AD_CODE+' '+AD_NAME+'</span>');
            document.title = '债券总览-'+ZQ_NAME;
        }
    }, "json");
    /**
     * 获取系统参数：当前系统省级区划（单列市区划）
     * 获取系统参数：显示发行日期
     */
    var sysParamProvinceCode = '';
    var fxrqShowFlag = false;
    $.post("getParamValueAll.action", function (data) {
        sysParamProvinceCode = data[0].ELE_AD_CODE;
        isViewCXJG = data[0].IS_CZB_VERSION;//0表示是财政部版本,1地方版本
        if(isViewCXJG == 0){
            fxrqShowFlag = true;
        }
        initContent();
    },"json");
    //创建转贷信息选择弹出窗口

    /**
     * 获取url参数或者查询字符串中的参数
     */
    function getQueryParam(name, queryString) {
        var match = new RegExp(name + '=([^&]*)').exec(queryString || location.search);
        return match && decodeURIComponent(match[1]);
    }
    /**
     * 通用函数：判断字符串是否以指定字符串结尾
     *
     */
    String.prototype.endWith = function (endStr) {
        var d = this.length - endStr.length;
        return (d >= 0 && this.lastIndexOf(endStr) == d)
    };
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
    });
    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            height : '100%',
            width : '100%',
            layout: {
                type: 'hbox',
                align: 'middle',
                pack: 'center'
            },
            renderTo: Ext.getBody(),
            border : false,
            items : [
                {
                    layout : 'fit',
                    xtype:'panel',
                    height : '100%',
                    width : '90%',
                    renderTo: Ext.getBody(),
                    border : false,
                    dockedItems : [
                        {
                            xtype : 'toolbar',
                            dock : 'top',
                            itemId : 'contentPanel_toolbar',
                            items : [
                                {
                                    xtype: 'displayfield',
                                    name: 'zq_name',
                                    labelWidth:80,
                                    fieldLabel: '<span class="displayfield">债券名称</span>',
                                    value: '<span class="displayfield">'+ZQ_CODE+' '+ZQ_NAME+'</span>',
                                    width: 550
                                },
                                {
                                    xtype: 'displayfield',
                                    name: 'ad_name',
                                    labelWidth:80,
                                    fieldLabel: '<span class="displayfield">地区名称</span>',
                                    value: '<span class="displayfield">'+AD_CODE+' '+AD_NAME+'</span>',
                                    width: 350
                                }
                            ]
                        }
                    ],
                    items : [initInformation_tab_panle()]
                }
            ]
        });
    }
    /**
     *页签界面
     */
    function initInformation_tab_panle() {
        button_name = 'VIEW';
        var tab_hasShow = {};
        var information_tab_panel = Ext.create('Ext.tab.Panel', {
            height: '100%',
            width: '100%',
            border: false,
            items: [
                {
                    title: '基本情况',
                    scrollable: true,
                    items: initWindow_show_informationForm_tab_jbqk()
                },
                {
                    title: '建设项目',
                    layout: 'hbox',
                    hidden: IS_BZB == '1' || IS_BZB == '2'? false : true,
                    items: initWindow_zqxxtb_contentForm_tab_jsxm()
                },
                {
                    //title: '债券收入',
                    title: sysParamProvinceCode == AD_CODE?'发行情况':'转贷收入',
                    layout: 'hbox',
                    items: initWindow_zqxxtb_contentForm_tab_zqsr()
                },
                {
                    title: '中标情况',
                    layout: 'fit',
                    itemId: 'fxxxtab',
                    items: fxxxTab()
                },
                {
                    title: '本级支出',
                    layout: 'hbox',
                    items: initWindow_zqxxtb_contentForm_tab_bjzc()
                },
                {
                    title: '转贷支出',
                    layout: 'hbox',//布局为fit后， scrollable不能用
                    items: initWindow_zqxxtb_contentForm_tab_zdzc()
                },
                {
                    title: '下级还款信息',
                    layout: 'hbox',
                    items: initWindow_zqxxtb_contentForm_tab_zdshbx()
                },
                {
                    title: '应付本息',
                    layout: 'fit',
                    items: initWindow_zqxxtb_contentForm_tab_yfbx()
                },
                {
                    title: '实际还本',
                    layout: 'fit',
                    scrollable: true,
                    items: [
                        initWindow_zqxxtb_contentForm_tab_sjhb()
                    ]
                },
                {
                    title: '实际付息',
                    layout: 'fit',
                    scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_sjfx()
                }
            ],
            listeners: {
                tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                    switch (newCard.title) {
                        case '建设项目' :
                            if (typeof tab_hasShow['jsxm'] == 'undefined' || tab_hasShow['jsxm'] == null || !tab_hasShow['jsxm']) {
                                tab_hasShow['jsxm'] = true;
                                DSYGrid.getGrid('jsxmGrid').getStore().loadPage(1);
                            }
                        case '中标情况' :
                            if (typeof tab_hasShow['fxxxTab'] == 'undefined' || tab_hasShow['fxxxTab'] == null || !tab_hasShow['fxxxTab']) {
                                tab_hasShow['fxxxTab'] = true;
                                //发送ajax请求，校验数据
                                $.post("/getZbqk.action", {
                                    ZQ_ID:ZQ_ID,
                                    IS_VALUE:IS_VALUE
                                },function (data) {
                                    var ZQ_BILL_QX = Ext.util.JSON.decode(data).list[0].ZQ_BILL_QX;
                                    var qxfw_id = ZQ_BILL_QX <= 10 ? 10 : ZQ_BILL_QX > 10 && ZQ_BILL_QX <= 20 ? 20 : 30;
                                    Ext.util.JSON.decode(data).list[0].QXFW_ID = qxfw_id;
                                    var year = Ext.util.JSON.decode(data).list[0].PC_YEAR;
                                    var condition_str = year <= 2017 ? " <= '2017' " : " = '" + year + "' ";
                                    //设置招标信息
                                    var form1 = Ext.ComponentQuery.query('form#zbqkForm')[0];
                                    form1.getForm().setValues(Ext.util.JSON.decode(data).zbxxList[0]);
                                    //设置投标信息
                                    var tbmxStore = Ext.util.JSON.decode(data).tbmxList;
                                    var grid = DSYGrid.getGrid('tbmxGrid');
                                    grid.insertData(null, tbmxStore);
                                    //设置中标信息
                                    var zbxxpStore = Ext.util.JSON.decode(data).zbxxpList;
                                    var grid = DSYGrid.getGrid('zbxxGrid');
                                    grid.insertData(null, zbxxpStore);

                                    //设置承销商交款信息
                                    var cxsjkxxStore = Ext.util.JSON.decode(data).cxsjkxxList;
                                    var grid = DSYGrid.getGrid('cxsjkxxGrid');
                                    grid.insertData(null, cxsjkxxStore);
                                    //设置承销商投标不足信息
                                    var tbbzStore = Ext.util.JSON.decode(data).tbbzList;
                                    var grid = DSYGrid.getGrid('tbbzGrid');
                                    grid.insertData(null, tbbzStore);
                                    //承销商为投标信息
                                    var wtbxxStore = Ext.util.JSON.decode(data).wtbxxList;
                                    var grid = DSYGrid.getGrid('wtbxxGrid');
                                    grid.insertData(null, wtbxxStore);
                                    //最低成效额不足
                                    var zdcxeStore = Ext.util.JSON.decode(data).zdcxeList;
                                    var grid = DSYGrid.getGrid('zdcxeGrid');
                                    grid.insertData(null, zdcxeStore);
                                    //债券托管信息
                                    var tgxxStore = Ext.util.JSON.decode(data).tgxxList;
                                    var grid = DSYGrid.getGrid('tgxxGrid');
                                    grid.insertData(null, tgxxStore);
                                })
                            }
                                break;
                        case '本级支出' :
                            if (typeof tab_hasShow['bjzc'] == 'undefined' || tab_hasShow['bjzc'] == null || !tab_hasShow['bjzc']) {
                                tab_hasShow['bjzc'] = true;
                                DSYGrid.getGrid('bjzcGrid').getStore().loadPage(1);
                            }
                            break;
                        case '转贷支出' :
                            if (typeof tab_hasShow['zdzc'] == 'undefined' || tab_hasShow['zdzc'] == null || !tab_hasShow['zdzc']) {
                                tab_hasShow['zdzc'] = true;
                                //发送请求获取当前地区的转贷收入 及 向下转贷支出
                                $.post("/getZqzlZdxxGrid.action", {
                                    ZQ_ID: ZQ_ID,
                                    ad_code: AD_CODE
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }
                                    var grid = DSYGrid.getGrid('zdzcGrid');
                                    if (AD_CODE.length == 2) {
                                        grid.addDocked({
                                            xtype: 'toolbar',
                                            layout: 'column',
                                            items: [
                                                /* {xtype: 'label', text: '债券名称:', width: 70},
                                                {xtype: 'label', text: ZQ_NAME, width: 450, flex: 5}, */
                                                {xtype: 'label', text: '债券金额(元):', width: 100},
                                                {xtype: 'label', text: Ext.util.Format.number(data.dataList[0].PLAN_AMT, '0,000.00'), width: 200, flex: 5}

                                            ]
                                        }, 0);
                                    } else if (AD_CODE.length == 4) {
                                        grid.addDocked({
                                            xtype: 'toolbar',
                                            layout: 'column',
                                            items: [
                                                /* {xtype: 'label', text: '债券名称:', width: 70},
                                                {xtype: 'label', text: ZQ_NAME, width: 450, flex: 5}, */
                                                {xtype: 'label', text: '  转贷收入(元):', width: 100},
                                                {xtype: 'label', text: Ext.util.Format.number(data.dataList[0].ZD_AMT, '0,000.00'), width: 200, flex: 5}
                                            ]
                                        }, 0);
                                    }
                                    grid.insertData(null, data.list);
                                }, "json");
                            }
                            break;
                        case '下级还款信息' :
                            if (typeof tab_hasShow['zdshbx'] == 'undefined' || tab_hasShow['zdshbx'] == null || !tab_hasShow['zdshbx']) {
                                tab_hasShow['zdshbx'] = true;
                                //发送请求获取当前地区的转贷收入 及 向下转贷支出
                                $.post("/getZqzlZdshbxGrid.action", {
                                    ZQ_ID: ZQ_ID,
                                    ad_code: AD_CODE
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }
                                    var grid = DSYGrid.getGrid('zdshbxGrid');
                                    grid.addDocked({
                                        xtype: 'toolbar',
                                        layout: 'column',
                                        items: [
                                            /* {xtype: 'label', text: '债券名称:', width: 70},
                                            {xtype: 'label', text: ZQ_NAME, width: 450, flex: 5}, */
                                            {xtype: 'label', text: '  转贷总金额(元):', width: 120},
                                            {xtype: 'label', text: Ext.util.Format.number(data.dataList[0].ZD_AMT, '0,000.00'), width: 200, flex: 5}

                                        ]
                                    }, 0);
                                    grid.insertData(null, data.list);
                                }, "json");
                            }
                            break;
                        case '应付本息' :
                            if (typeof tab_hasShow['yfbx'] == 'undefined' || tab_hasShow['yfbx'] == null || !tab_hasShow['yfbx']) {
                                tab_hasShow['yfbx'] = true;
                                DSYGrid.getGrid('yfbxGrid').getStore().loadPage(1);
                            }
                            break;
                        case '实际还本' :
                            if (typeof tab_hasShow['sjhb'] == 'undefined' || tab_hasShow['sjhb'] == null || !tab_hasShow['sjhb']) {
                                tab_hasShow['sjhb'] = true;
                                DSYGrid.getGrid('sjhbGrid').getStore().loadPage(1);
                            }
                            break;
                        case '实际付息' :
                            if (typeof tab_hasShow['sjfx'] == 'undefined' || tab_hasShow['sjfx'] == null || !tab_hasShow['sjfx']) {
                                tab_hasShow['sjfx'] = true;
                                DSYGrid.getGrid('sjfxGrid').getStore().loadPage(1);
                            }
                            break;
                        case '发行情况' :
                            if (typeof tab_hasShow['zqsr'] == 'undefined' || tab_hasShow['zqsr'] == null || !tab_hasShow['zqsr']) {
                                tab_hasShow['zqsr'] = true;
                                DSYGrid.getGrid('zqsrGrid').getStore().loadPage(1);
                            }
                            break;
                        case '转贷收入' :
                            if (typeof tab_hasShow['zqsr'] == 'undefined' || tab_hasShow['zqsr'] == null || !tab_hasShow['zqsr']) {
                                tab_hasShow['zqsr'] = true;
                                DSYGrid.getGrid('zqsrGrid').getStore().loadPage(1);
                            }
                            break;
                    }
                }
            }
        });
        /*if (sysParamProvinceCode == AD_CODE) {
            information_tab_panel.tabBar.items.items[2].hide();
        }*/
        if ((AD_CODE.length != 2 && AD_CODE.length != 4 ) || AD_CODE.endWith('00')) { // 判断当前登录用户是否为区县和本级用户
            information_tab_panel.tabBar.items.items[5].hide(); // 转贷支出
            information_tab_panel.tabBar.items.items[6].hide(); // 下级还款信息
        }

        if (AD_CODE != ELE_AD_CODE) { // 如果当前登录用户非省级和省本级用户则隐藏中标信息页签
            information_tab_panel.tabBar.items.items[3].hide(); // 转贷支出
        }
        return information_tab_panel;
    }
    /**
     *基本情况页签
     */
    function initWindow_show_informationForm_tab_jbqk() {
        var jbqkForm = Ext.create('Ext.form.Panel', {
            name: 'jbqkForm',
            width: '100%',
            height: '100%',
            layout: 'anchor',
            border: false,
            defaults: {
                //margin: '0 0 0 0',
                padding: '2 0 2 0',
                anchor: '100%'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'fieldcontainer',
                    border: false,
                    layout: 'anchor',
                    defaults: {
                        anchor: '100%',
                        margin: '0 0 0 0',
                        //padding: '2 0 2 0',
                    },
                    items: [
                        {
                            xtype: 'fieldcontainer',
                            layout: 'column',
                            //padding: '2 0 2 0',
                            defaultType: 'textfield',
                            fieldDefaults: {
                                labelWidth:130,
                                columnWidth: .33,
                                margin: '1 1 0 0',
                                padding: '2 2 2 8',
                                fieldStyle: 'background:#E6E6E6',
                                readOnly: true
                            },
                            items: [
                                {
                                    fieldLabel: '债券编码',
                                    name: 'ZQ_BMCODE',
                                    hidden:true
                                },
                                {
                                    fieldLabel: '债券代码',
                                    name: 'ZQ_CODE'
                                },
                                {
                                    fieldLabel: '债券名称',
                                    name: 'ZQ_NAME'
                                },
                                {
                                    fieldLabel: '债券简称',
                                    name: 'ZQ_JC'
                                },
                                {
                                    fieldLabel: '所属年度',
                                    name: 'SS_YEAR'
                                }, {
                                    fieldLabel: '发文名称',
                                    name: 'ZQ_FWMC'
                                },
                                {
                                    fieldLabel: '债券类型',
                                    name: 'ZQLB_NAME'
                                },
                                {
                                    fieldLabel: '其他自平衡细化类型',
                                    name: 'ZPHXHLX_ID'
                                },
                                {
                                    fieldLabel: '文号',
                                    name: 'ZQ_WH'
                                },
                                {
                                    fieldLabel: '发行场所',
                                    name: 'ZQTGR_ID',
                                    hidden:true
                                },
                                {
                                    fieldLabel: '发行场所',
                                    name: 'ZQTGR_NAME'
                                },
                                {
                                    fieldLabel: '债券品种',
                                    name: 'ZQPZ_NAME',
                                    hidden:true
                                },
                                {
                                    fieldLabel: '债务收入科目',
                                    name: 'SRKM_ID',
                                    hidden:true
                                },
                                {
                                    fieldLabel: '债务收入科目',
                                    name: 'SRKM_NAME'
                                },
                                {
                                    fieldLabel: '发行方式',
                                    name: 'FXFS_NAME'
                                },
                                {
                                    fieldLabel: '发行批次',
                                    name: 'ZQ_PC_NAME'
                                },
                                {
                                    fieldLabel: '债券托管人',
                                    name: 'ZQTGR_NAME',
                                    hidden:true
                                },
                                {
                                    fieldLabel: '偿还资金来源',
                                    name: 'ZJLY_NAME',
                                    hidden: true
                                },
                                {
                                    fieldLabel: '债权类型',
                                    name: 'ZQLX_ID',
                                    hidden: true
                                },
                                {
                                    fieldLabel: '计划发行额(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'PLAN_FX_AMT'
                                },
                                {
                                    fieldLabel: '实际发行额(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'FX_AMT'
                                },
                                {
                                    fieldLabel: '其中柜台发行额(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'QZGT_AMT'
                                },
                                {
                                    fieldLabel: '其中新增债券(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'FX_XZ_AMT'
                                },
                                {
                                    fieldLabel: '置换债券(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'FX_ZH_AMT'
                                },
                                {
                                    fieldLabel: '再融资债券(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'FX_HB_AMT'
                                },
                                {
                                    fieldLabel: '专项债用作资本金(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'ZX_FX_AMT',
                                    value:0
                                },
                                {
                                    fieldLabel: '其中:新增赤字(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'XZCZAP_AMT',
                                    value:0
                                },
                                // 20210107 guoyf 债券一户式基本信息增加展示项
                                {
                                    fieldLabel: '偿还到期债券(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'CH_DQZQ_AMT',
                                    value:0
                                },
                                {
                                    fieldLabel: '偿还存量债务(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'CH_CLZW_AMT',
                                    value:0
                                },
                                {
                                    fieldLabel: '中标价格(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'ZBJG_AMT'
                                },
                                {
                                    fieldLabel: '公告日',
                                    name: 'ZQ_GGR'
                                },
                                {
                                    fieldLabel: '招标日',
                                    name: 'ZB_DATE'
                                },
                                {
                                    fieldLabel: '期限范围',
                                    store: DebtEleStore(json_debt_zqqxfw),
                                    name: 'QXFW_ID'
                                },
                                {
                                    fieldLabel: '债券期限',
                                    xtype: "combobox",
                                    name: 'ZQQX_NAME',
                                    hideTrigger: true,
                                },
                                {
                                    xtype: 'fieldcontainer',
                                    fieldLabel: '赎回方式',
                                    height:24,
                                    layout: 'hbox',
                                    items: [
                                        {
                                            xtype: 'numberfield',
                                            name: 'SHMS1',
                                            width: '25%',
                                            allowBlank: false,
                                            hideTrigger: true,
                                            value:0
                                        },
                                        {
                                            xtype: 'label',
                                            text: '+',
                                            margin: '2 2 2 2'
                                        },
                                        {
                                            xtype: 'numberfield',
                                            name: 'SHMS2',
                                            width: '25%',
                                            allowBlank: false,
                                            hideTrigger: true,
                                            value:0
                                        },
                                        {
                                            xtype: 'label',
                                            text: '+',
                                            margin: '2 2 2 2'
                                        },
                                        {
                                            xtype: 'numberfield',
                                            name: 'SHMS3',
                                            width: '25%',
                                            allowBlank: false,
                                            hideTrigger: true,
                                            value:0

                                        }
                                    ]
                                },
                                {
                                    fieldLabel: '票面利率(%)',
                                    xtype: 'numberfield',
                                    hideTrigger: true,
                                    decimalPrecision: 4,
                                    name: 'PM_RATE'
                                },
                                {
                                    fieldLabel: '起息日',
                                    name: 'QX_DATE'
                                },
                                {
                                    fieldLabel: '到期兑付日',
                                    name: 'DQDF_DATE'
                                },
                                {
                                    fieldLabel: '计息方式',
                                    hidden: true,
                                    name: 'JXFS_NAME'
                                },
                                {
                                    fieldLabel: '付息方式',
                                    name: 'FXZQ_NAME'
                                },
                                {
                                    fieldLabel: '提前还款天数',
                                    name: 'TQHK_DAYS'
                                },
                                {
                                    fieldLabel: '发行日期',
                                    hidden: false,
                                    name: 'FX_START_DATE'
                                },
                                {
                                    fieldLabel: '缴款日期',
                                    hidden: false,
                                    name: 'JK_DATE'
                                },
                                {
                                    fieldLabel: '承担利息(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'LX_SUM_AMT',
                                    hidden:true
                                },
                                {
                                    fieldLabel: '手续费支付方式',
                                    hidden: false,
                                    name: 'SXFYJ_NAME'
                                },
                                {
                                    fieldLabel: '发行手续费率(‰)',
                                    xtype: 'numberfield',
                                    hideTrigger: true,
                                    decimalPrecision: 6,
                                    name: 'FXSXF_RATE'
                                },
                                {
                                    fieldLabel: '登记托管费率(‰)',
                                    xtype: 'numberfield',
                                    hideTrigger: true,
                                    decimalPrecision: 6,
                                    name: 'TGSXF_RATE'
                                },
                                {
                                    fieldLabel: '兑付手续费率(‰)',
                                    xtype: 'numberfield',
                                    hideTrigger: true,
                                    decimalPrecision: 6,
                                    name: 'DFSXF_RATE'
                                },
                                {
                                    fieldLabel: '发行手续费(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'FXSXF_AMT'
                                },
                                {
                                    fieldLabel: '登记托管费(元)',
                                    xtype: 'numberFieldFormat',
                                    hideTrigger: true,
                                    name: 'TGSXF_AMT'
                                },
                                {
                                    fieldLabel: '备注',
                                    xtype: 'textarea',
                                    labelWidth: 128,
                                    columnWidth: .99,
                                    name: 'REMARK'
                                }
                            ]
                        }
                    ]
                }
            ]
        });
        jbqkForm.getForm().load({
            url: 'getZqzlZqxxByZqId.action',
            params: {
                ZQ_ID: ZQ_ID,
                ad_code: AD_CODE
            },
            waitTitle: '请等待...',
            success: function　(form, action) {
                jbqkForm.down('numberfield[name="FXSXF_RATE"]').setValue(action.result.data.FXSXF_RATE*10);
                jbqkForm.down('numberfield[name="TGSXF_RATE"]').setValue(action.result.data.TGSXF_RATE*10);
                jbqkForm.down('numberfield[name="DFSXF_RATE"]').setValue(action.result.data.DFSXF_RATE*10);
                },
            failure: function (form, action) {
                Ext.MessageBox.alert('提示', action.result.message);
            }
        });
        return jbqkForm;
    }
    /**
     *建设项目页签
     */
    function initWindow_zqxxtb_contentForm_tab_jsxm() {
        var headerJson = [
            {
                xtype: 'rownumberer',
                width: 40,
                summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                text: "兑付日期",
                dataIndex: "DF_END_DATE",
                type: "string",
                width: 150
            },
            // {
            //     dataIndex: "DF_END_DATE", type: "string", text: "兑付日期", width: 150,
            //     editor:{
            //         xtype: "datefield",  allowBlank: false,
            //         format: 'Y-m-d',
            //         blankText: '请选择兑付日期',
            //         emptyText: '请选择兑付日期',
            //         editable:true,
            //         listeners: {
            //             'change': function (self, newValue, oldValue) {
            //             }
            //         }
            //     },
            //     renderer: function (value, metaData, record) {
            //         var dateStr = Ext.util.Format.date(value, 'Y-m-d');
            //         return dateStr;
            //     }
            //
            // },
            {
                dataIndex: "AD_NAME", type: "string", text: "地区", width: 200
            },
            {
                dataIndex: "AG_NAME", type: "string", text: "项目单位", width: 200
            },
            {
                dataIndex: "XM_CODE", type: "string", text: "项目编码", width: 200
            },
            {
                dataIndex: "XM_NAME", type: "string", text: "项目名称", width: 200,
                renderer: function (data, cell, record) {
                    var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {
                dataIndex: "XMLX_NAME", type: "string", text: "项目类型", width: 150
            },
            {dataIndex: "FX_AMT", type: "float", text: "发行金额(万元)", width: 150,
                editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                renderer:function(value){
                    return Ext.util.Format.number(value, '0,000.00####');
                },
            },
            {dataIndex: "ZX_ZBJ_AMT", type: "float", text: "专项债用作资本金(万元)", width: 180,
                editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                renderer:function(value){
                    return Ext.util.Format.number(value, '0,000.00####');
                },
            },
            {dataIndex: "XZCZAP_AMT", type: "float", text: "其中:新增赤字(万元)", width: 180,
                editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                renderer:function(value){
                    return Ext.util.Format.number(value, '0,000.00####');
                },
            }
        ];
        /**
         * 设置表格属性
         */
        var config = {
            itemId: 'jsxmGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            dataUrl: 'getZqzlJsxmGrid.action',
            features: [{
                ftype: 'summary'
            }],
            checkBox: false,
            border: false,
            margin: '0 3 5 0',//djl
            autoLoad: false,
            params: {
                ZQ_ID: ZQ_ID,
                ad_code: AD_CODE
            },
            height: '100%',
            pageConfig: {
                enablePage: false
            }
        };
        //生成表格
        var grid = DSYGrid.createGrid(config);
        return grid;
    }
    /**
     *本级支出
     */
    function initWindow_zqxxtb_contentForm_tab_bjzc() {
        try {
            var headerJson = [
                {xtype: 'rownumberer',width: 35},
                {
                    dataIndex: "PAY_DATE", width: 100, type: "string", text: "支付日期",
                    summaryType: 'count',
                    summaryRenderer: function (value) {
                        return '合计';
                    }
                },
                {
                    dataIndex: "PAY_AMT", width: 125, type: "float", text: "支出金额(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0)
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {dataIndex: "ZC_TYPE_NAME", width: 100, type: "string", text: "支出类型"},
                {dataIndex: "XM_NAME", width: 200, type: "string", text: "项目",
                    renderer: function (data, cell, record) {
                        /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID='+record.get('XM_ID');
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
                {dataIndex: "ZJYT_NAME", width: 200, type: "string", hidden: true,text: "资金用途"},
                {dataIndex: "GNFL_NAME", width: 200, type: "string", text: "支出功能分类"},
                {dataIndex: "JJFL_NAME", width: 200, type: "string", text: "支出经济分类"},
                {dataIndex: "REMARK", width: 200, type: "string", text: "备注"}
            ];
            var grid = DSYGrid.createGrid({
                itemId: 'bjzcGrid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                flex: 1,
                dataUrl: 'getZqzlBjzcGrid.action',
                features: [{
                    ftype: 'summary'
                }],
                checkBox: false,
                border: false,
                margin: '0 3 5 0',//djl
                autoLoad: false,
                params: {
                    ZQ_ID: ZQ_ID,
                    ad_code: AD_CODE
                },
                height: '100%',
                pageConfig: {
                    enablePage: false
                }
            });
            return grid;
        }
        catch (err) {
        }
    }
    /**
     *转贷支出
     */
    function initWindow_zqxxtb_contentForm_tab_zdzc() {
        try {
            var headerJson = [
                {xtype: 'rownumberer',width: 35},
                {
                    dataIndex: "AD_NAME", width: 100, type: "string", text: "转贷地区",
                    summaryType: 'count',
                    summaryRenderer: function (value) {
                        return '合计';
                    }
                },
                {dataIndex: "ZD_DATE", width: 150, type: "string", text: "转贷日期"},
                {
                    dataIndex: "ZD_AMT", width: 150, type: "float", text: "合计金额(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0)
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "XZ_AMT", width: 180, type: "float", text: "其中新增债券金额(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0)
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }

                },
                {
                    dataIndex: "ZH_AMT", width: 180, type: "float", text: "其中置换债券金额(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0)
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "HB_AMT", width: 180, type: "float", text: "其中再融资债券金额(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0)
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {dataIndex: "REMARK", width: 180, type: "string", text: "备注"}
            ];
            var grid = DSYGrid.createGrid({
                itemId: 'zdzcGrid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                flex: 1,
                data: [],
                features: [{
                    ftype: 'summary'
                }],
                checkBox: false,
                border: false,
                margin: '0 3 5 0',//djl
                autoLoad: false,
                height: '100%',
                pageConfig: {
                    enablePage: false
                }
            });

            return grid;
        }
        catch (err) {
        }
    }

    /**
     * 初始化债权发行管理弹出窗口中的投标信息标签页
     */
    function fxxxTab() {
        var config={
            width: '100%',
            height: '100%',
            layout: 'fit',
            border: false,
            padding: '2 2 2 2',
            scrollable: true,
            items: [init_fxxx_panel()]
        };
        var panel = Ext.create('Ext.form.Panel', config);
        return panel;
    }
    /**
     *债券收入
     * 发行情况、转贷收入
     */
    function initWindow_zqxxtb_contentForm_tab_zqsr() {
        var headerJson = [

            {xtype: 'rownumberer',width: 35},
            {dataIndex: "SR_NAME", width: 150, type: "string", text: "来源区划",
                summaryType: 'count',
                summaryRenderer: function (value) {
                    return '合计';
                }
            },
            {dataIndex: "SR_DATE", width: 150, type: "string", text: "日期"},
            {dataIndex: "SR_FX_AMT", width: 150, type: "float", text: "金额合计(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                },
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "SR_XZ_AMT", width: 180, type: "float", text: "其中新增债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                },
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "SR_ZH_AMT", width: 180, type: "float", text: "其中置换债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                },
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "SR_HB_AMT", width: 180, type: "float", text: "其中再融资债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                },
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "REMARK", width: 180, type: "string", text: "备注"}
        ];
        var headerJson_province = [
            {
                xtype: 'rownumberer',width: 45, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 250},
            {
                text: "新增债券金额（元）", dataIndex: "XZ_AMT", type: "float", width: 180, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {
                text: "置换债券金额（元）", dataIndex: "ZH_AMT", type: "float", width: 180, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },{
                text: "再融资债券金额（元）", dataIndex: "HB_AMT", type: "float", width: 180, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {
                text: "实际发行金额（元）", dataIndex: "FX_AMT", width: 180, type: "float", summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {text: "发行开始日期", dataIndex: "FX_START_DATE", type: "string", width: 180},
            {text: "是否续发行", dataIndex: "IS_XFX", type: "string", width: 180},
            {text: "备注", dataIndex: "REMARK", type: "string", width: 180}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'zqsrGrid',
            headerConfig: {
                headerJson: (sysParamProvinceCode == AD_CODE)?headerJson_province:headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            dataUrl: 'getZqsrZdxxGrid.action',
            features: [{
                ftype: 'summary'
            }],
            checkBox: false,
            border: false,
            margin: '0 3 5 0',
            autoLoad: false,
            height: '100%',
            params: {
                ZQ_ID: ZQ_ID,
                ad_code: AD_CODE
            },
            pageConfig: {
                enablePage: false
            }
        });

        return grid;
    }

    /**
     *转贷收回本息
     */
    function initWindow_zqxxtb_contentForm_tab_zdshbx() {
        try {
            var headerJson = [
                {xtype: 'rownumberer',width: 35},
                {
                    dataIndex: "AD_NAME", width: 100, type: "string", text: "地区",
                    summaryType: 'count',
                    summaryRenderer: function (value) {
                        return '合计';
                    }
                },
                {
                    dataIndex: "BJ_AMT", width: 150, type: "float", text: "到期应还本金(元)",
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0 || record.data.REMARK.indexOf('【作废】') >= 0)
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "LX_AMT", width: 150, type: "float", text: "应付利息(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0 )
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                },
                {
                    dataIndex: "DFF_AMT", width: 150, type: "float", text: "应付手续费(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0 )
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }

                },
                {
                    dataIndex: "HK_BJ_AMT", width: 150, type: "float", text: "已还本金(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0 )
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "HK_LX_AMT", width: 150, type: "float", text: "已付利息(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0 )
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "HK_DFF_AMT", width: 150, type: "float", text: "已付手续费(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0 )
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "NO_BJ_AMT", width: 150, type: "float", text: "未还本金(元)",
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0 )
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "NO_LX_AMT", width: 150, type: "float", text: "未还利息(元)",
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0 )
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "NO_DFF_AMT", width: 150, type: "float", text: "未付手续费(元)",
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0 )
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {dataIndex: "REMARK", type: "string", text: "备注", width: 250}
            ];
            var grid = DSYGrid.createGrid({
                itemId: 'zdshbxGrid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                flex: 1,
                data: [],
                features: [{
                    ftype: 'summary'
                }],
                checkBox: false,
                border: false,
                autoLoad: false,
                margin: '0 3 5 0',//djl
                height: '100%',
                pageConfig: {
                    enablePage: false
                }
            });

            return grid;
        }
        catch (err) {
        }
    }
    /**
     *应付本息
     */
    function initWindow_zqxxtb_contentForm_tab_yfbx() {
        try {
            var headerJson = [
                {xtype: 'rownumberer',width: 35},
                {
                    dataIndex: "DF_END_DATE", width: 100, type: "string", text: "应付日期",
                    summaryType: 'count',
                    summaryRenderer: function (value) {
                        return '合计';
                    }
                },
                {
                    dataIndex: "YFBJ", type: "string", text: "应付本金(元)",
                    columns: [
                        {
                            dataIndex: "YFBJXJ", width: 150, type: "float", text: "小计",
                            summaryType: 'sum',
                            summaryRenderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00');
                            }
                        },
                        {
                            dataIndex: "BJ_PLANBJ_AMT", width: 150, type: "float", text: "本级",
                            summaryType: 'sum',
                            summaryRenderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00');
                            }
                        },
                        {
                            dataIndex: "XJ_PLANBJ_AMT", width: 150, type: "float", text: "下级",
                            summaryType: 'sum',
                            summaryRenderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00');
                            }
                        }
                    ]
                },
                {
                    dataIndex: "YFLX", type: "string", text: "应付利息(元)",
                    columns: [
                        {
                            dataIndex: "YFLXXJ", width: 150, type: "float", text: "小计",
                            summaryType: 'sum',
                            summaryRenderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00');
                            }
                        },
                        {
                            dataIndex: "BJ_PLANLX_AMT", width: 150, type: "float", text: "本级",
                            summaryType: 'sum',
                            summaryRenderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00');
                            }
                        },
                        {
                            dataIndex: "XJ_PLANLX_AMT", width: 150, type: "float", text: "下级",
                            summaryType: 'sum',
                            summaryRenderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00');
                            }
                        }
                    ]
                },
                {
                    dataIndex: "YFDFF", type: "string", text: "应付手续费(元)",
                    columns: [
                        {
                            dataIndex: "YFDFFXJ", width: 150, type: "float", text: "小计",
                            summaryType: 'sum',
                            summaryRenderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00');
                            }
                        },
                        {
                            dataIndex: "BJ_DFF_AMT", width: 150, type: "float", text: "本级",
                            summaryType: 'sum',
                            summaryRenderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00');
                            }
                        },
                        {
                            dataIndex: "XJ_DFF_AMT", width: 150, type: "float", text: "下级",
                            summaryType: 'sum',
                            summaryRenderer: function (value) {
                                return Ext.util.Format.number(value, '0,000.00');
                            }
                        }
                    ]
                }
            ];
            var grid = DSYGrid.createGrid({
                itemId: 'yfbxGrid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                flex: 1,
                dataUrl: 'getZqzlYfbxGrid.action',
                features: [{
                    ftype: 'summary'
                }],
                checkBox: false,
                border: false,
                margin: '0 3 5 0',//djl
                /*tbar: [
                      {xtype: 'label', text: '债券名称:', width: 70},
                      {xtype: 'label', text: ZQ_NAME, width: 200, flex: 5}
                  ], */
                autoLoad: false,
                params: {
                    ZQ_ID: ZQ_ID,
                    ad_code: AD_CODE
                },
                height: '100%',
                pageConfig: {
                    enablePage: false
                }
            });

            return grid;
        }
        catch (err) {
        }
    }
    /**
     *实际还本
     */
    function initWindow_zqxxtb_contentForm_tab_sjhb() {
        try {
            var headerJson = [
                {xtype: 'rownumberer',width: 35},
                {
                    dataIndex: "YHK_DATE", width: 100, type: "string", text: "应偿还日期",
                    summaryType: 'count',
                    summaryRenderer: function (value) {
                        return '合计';
                    }
                },
                {dataIndex: "HK_DATE", width: 100, type: "string", text: "偿还日期"},
                {dataIndex: "ZJLY_NAME", width: 150, type: "string", text: "偿还资金来源"},
                {
                    dataIndex: "HK_AMT", width: 150, type: "float", text: "偿还金额(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0)
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "DFF_AMT", width: 150, type: "float", text: "支付手续费(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0)
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {dataIndex: "ZQ_NAME", width: 150, type: "string", text: "债券名称"},
                {dataIndex: "ZQ_CODE", width: 150, type: "string", text: "债券代码"},
                {dataIndex: "FX_START_DATE", width: 150, type: "string", text: "发行日期"},
                {dataIndex: "ZQQX_NAME", width: 150, type: "string", text: "债券期限"},
                {dataIndex: "HB_AMT", width: 150, type: "float", text: "发行额(元)",
                    renderer: function (value, metaData, record) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {dataIndex: "REMARK", width: 180, type: "string", text: "备注"}
            ];
            var grid = DSYGrid.createGrid({
                itemId: 'sjhbGrid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: true
                },
                flex: 1,
                dataUrl: 'getZqzlSjhbfxGrid.action',
                features: [{
                    ftype: 'summary'
                }],
                autoScroll: true,
                checkBox: false,
                border: false,
                margin: '0 3 5 0',//djl
                /*tbar: [
                      {xtype: 'label', text: '债券名称:', width: 70},
                      {xtype: 'label', text: ZQ_NAME, width: 200, flex: 5}
                  ], */
                autoLoad: false,
                params: {
                    ZQ_ID: ZQ_ID,
                    HK_TYPE: 0,
                    ad_code: AD_CODE
                },
                height: '100%',
                pageConfig: {
                    enablePage: false
                }
            });

            return grid;

        }
        catch (err) {
        }
    }
    /**
     *实际付息
     */
    function initWindow_zqxxtb_contentForm_tab_sjfx() {
        try {
            var headerJson = [
                {xtype: 'rownumberer',width: 35},
                {
                    dataIndex: "YHK_DATE", width: 100, type: "string", text: "应偿还日期",
                    summaryType: 'count',
                    summaryRenderer: function (value) {
                        return '合计';
                    }
                },
                {dataIndex: "HK_DATE", width: 100, type: "string", text: "偿还日期"},
                {dataIndex: "ZJLY_NAME", width: 150, type: "string", text: "偿还资金来源"},
                {
                    dataIndex: "HK_AMT", width: 150, type: "float", text: "偿还金额(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0)
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "DFF_AMT", width: 150, type: "float", text: "支付手续费(元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value, metaData, record) {
                        if (record.data.REMARK.indexOf('【在途】') >= 0)
                            metaData.css = 'x-grid-back-green';
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {dataIndex: "REMARK", width: 180, type: "string", text: "备注"}
            ];
            var grid = DSYGrid.createGrid({
                itemId: 'sjfxGrid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                flex: 1,
                dataUrl: 'getZqzlSjhbfxGrid.action',
                features: [{
                    ftype: 'summary'
                }],
                checkBox: false,
                border: false,
                margin: '0 3 5 0',//djl
                /*tbar: [
                      {xtype: 'label', text: '债券名称:', width: 70},
                      {xtype: 'label', text: ZQ_NAME, width: 200, flex: 5}
                  ], */
                autoLoad: false,
                params: {
                    ZQ_ID: ZQ_ID,
                    HK_TYPE: 1,
                    ad_code: AD_CODE
                },
                height: '100%',
                pageConfig: {
                    enablePage: false
                }
            });

            return grid;
        }
        catch (err) {
        }
    }



</script>
</body>
</html>