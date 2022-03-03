<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2017/10/28
  Time: 11:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>提款报账审核</title>
    <style type="text/css">
        .x-grid-back-green {
            background: #00ff00;
        }
    </style>
</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript">
        var wf_id = "${fns:getParamValue('wf_id')}";//当前工作流id
        var node_code = "${fns:getParamValue('node_code')}";//当前节点id，1：录入岗；2：审核岗
        var userCode= '${sessionScope.USERCODE}';
        var AD_CODE= '${sessionScope.ADCODE}';
        if(AD_CODE.length==2){
            AD_CODE = AD_CODE+'00';
        }
        var AG_CODE= '${sessionScope.AGCODE}';
        var button_name = '';//当前操作按钮名称
        var button_text = '';
        var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态，指未送审...
        if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
            WF_STATUS = '001';
        }
        /**
         * 通用函数：获取url中的参数
         */
       /*  function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
            var r = window.location.search.substr(1).match(reg);  //匹配目标参数
            if (r != null) return unescape(r[2]);
            return null; //返回参数值
        } */

        /**
         * 通用配置json
         */
        var tkbz_json_common = {
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
                                name: 'down',
                                icon: '/image/sysbutton/audit.png',
                                handler: function (btn) {
                                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                                    if (records.length == 0) {
                                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                        return;
                                    }else{
                                        //弹出意见填写对话框
                                        initWindow_opinion({
                                            title: btn.text,
                                            animateTarget: btn,
                                            value: '同意',
                                            fn: function (buttonId, text) {
                                                if (buttonId === 'ok') {
                                                    doworkupdate(records,btn, text);
                                                }
                                            }
                                        });
                                    }
                                }
                            },
                            {
                                xtype: 'button',
                                text: '退回',
                                name: 'up',
                                icon: '/image/sysbutton/back.png',
                                handler: function (btn) {
                                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                                    if (records.length == 0) {
                                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                        return;
                                    }else{
                                        //弹出意见填写对话框
                                        initWindow_opinion({
                                            title: btn.text,
                                            animateTarget: btn,
                                            value: null,
                                            fn: function (buttonId, text) {
                                                if (buttonId === 'ok') {
                                                    doworkupdate(records,btn, text);
                                                }
                                            }
                                        });
                                    }
                                }
                            },
                            {
                                xtype: 'button',
                                text: '操作记录',
                                name: 'log',
                                icon: '/image/sysbutton/log.png',
                                handler: function () {
                                    operationRecord();
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
                                name: 'cancel',
                                icon: '/image/sysbutton/audit.png',
                                handler: function (btn) {
                                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                                    if (records.length == 0) {
                                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                        return;
                                    }else{
                                        Ext.Msg.confirm('提示', '请确认是否撤销审核！', function (btn_confirm) {
                                            if (btn_confirm == 'yes') {
                                                doworkupdate(records,btn);
                                            }
                                        });
                                    }
                                }
                            },
                            {
                                xtype: 'button',
                                text: '操作记录',
                                name: 'log',
                                icon: '/image/sysbutton/log.png',
                                handler: function () {
                                    operationRecord();
                                }
                            },
                            '->',
                            initButton_OftenUsed(),
                            initButton_Screen()
                        ]
                    },
                    store: {
                        WF_STATUS: DebtEleStore(json_debt_sh)
                    }

        };
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
        function doworkupdate(records,btn, text) {
            var sh = "" ;
            if(text != null){
                 sh = text ;
            }
            var ids=new Array();
            var btn_name=btn.name;
            var btn_text=btn.text;
            for(var k=0;k<records.length;k++){
                if('撤销审核'==btn_text){
                    var var$TKHZ_ID=records[k].get("TKHZ_ID");
                    if(var$TKHZ_ID!=null && var$TKHZ_ID != '' && var$TKHZ_ID != undefined){
                        Ext.Msg.alert('提示', '提款报账已汇总，无法撤销！');
                        return false;
                    }
                    var var$IS_BF=records[k].get("IS_BF");
                    if(var$IS_BF==1){
                        Ext.Msg.alert('提示', '提款报账已拨付，无法撤销！');
                        return false;
                    }
                }
                var zd_id=records[k].get("TKBZ_ID");
                ids.push(zd_id);
            }
            $.post('/tksq_reflct.action',{
                ids: Ext.util.JSON.encode(ids),
                btn_name:btn_name,
                btn_text:btn_text,
                node_code:node_code,
                wf_id:wf_id,
                audit_info: sh,
                userCode:userCode,
                call:"doupdate"
            }, function (data_response) {
                data_response = $.parseJSON(data_response);
                if (data_response.success) {
                    Ext.toast({
                        html: btn_text+"成功！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    reloadGrid();
                } else {
                    Ext.toast({
                        html: btn_text+"失败！" + data_response.message,
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    return false;
                }
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
                fuc_getWorkFlowLog(records[0].get("TKBZ_ID"));
            }
        }
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
                renderTo: 'contentPanel',
                border: false,
                dockedItems: [
                    {
                        xtype: 'toolbar',
                        dock: 'top',
                        itemId: 'contentPanel_toolbar',
                        items:tkbz_json_common.items[WF_STATUS],
                    }
                ],
                items: [
                    initContentTree({
                        areaConfig: {
                            params: {
                                CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
                            }
                        }
                    }),//初始化左侧树
                    initContentRightPanel()//初始化右侧2个表格
                ]
            });
        }
        /**
         * 初始化右侧panel，放置1个表格
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
                    initContentDetilGrid()
                ]
            });
        }
        /**
         * 初始化主表格
         */
        function initContentGrid() {
            var headerJson = [
                {
                    xtype: 'rownumberer', width: 40, summaryType: 'count',
                    summaryRenderer: function () {
                        return '合计';
                    }
                },
                {
                    dataIndex: "AG_NAME",
                    type: "string",
                    width: 130,
                    text: "单位名称"
                },
                {
                    dataIndex:"TKBZ_ID",
                    type:"string",
                    width:130,
                    text:"主单id",
                    hidden:true
                },
                {
                    dataIndex:"TKHZ_ID",
                    type:"string",
                    width:130,
                    text:"关联汇总id",
                    hidden:true
                },
                {
                    dataIndex:"IS_BF",
                    type:"string",
                    width:130,
                    text:"是否拨付",
                    hidden:true
                },
                {
                    dataIndex:"TKBZ_CODE",
                    type:"string",
                    width:130,
                    text:"主单code",
                    hidden:true
                },
                {
                    dataIndex: "SJXM_ID",
                    type: "string",
                    width: 130,
                    text: "上级项目ID",
                    hidden:true
                },
                {
                    dataIndex: "WZ_ID",
                    type: "string",
                    width: 130,
                    text: "外债ID",
                    hidden:true
                },
                {
                    dataIndex: "WZ_NAME",
                    type: "string",
                    width: 130,
                    text: "外债名称"
                },
                {
                    dataIndex: "WZXY_AMT",
                    type: "float",
                    width: 200,
                    text: "协议金额(原币万元)",
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.######');
                    }
                },
//                {
//                    dataIndex: "WT_AMT",
//                    type: "float",
//                    width: 130,
//                    text: "未提原币"
//                },
                {
                    dataIndex: "FM_NAME",
                    type: "string",
                    width: 130,
                    text: "币种"
                },
                {
                    dataIndex: "XM_NAME",
                    width: 240,
                    type: "string",
                    text: "项目名称",
                    renderer: function (data, cell, record) {
                        var url='/page/debt/common/xmyhs.jsp';
                        var paramNames=new Array();
                        paramNames[0]="XM_ID";
                        paramNames[1]="IS_RZXM";
                        var paramValues=new Array();
                        paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                        paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));

                        var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                        return result;
                    }
                },
                {
                    dataIndex: "TKBZ_CODE",
                    width: 150,
                    type: "string",
                    text: "申请单号"
                },
                {
                    dataIndex: "SQTK_AMT",
                    width: 200,
                    type: "float",
                    text: "申请提款金额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.######');
                    }
                },
                {
                    dataIndex: "WB_ID",
                    type: "string",
                    text: "申请支付币种",
                    width: 130
                },
                {
                    dataIndex: "WB_NAME",
                    type: "string",
                    text: "申请支付币种code",
                    width: 250,
                    hidden:true
                },
                {
                    text: "申请到账日期",
                    dataIndex: "SQDZ_DATE",
                    type: "string",
                    width: 110
                },
                {
                    text: "申请日期",
                    dataIndex: "SQ_DATE",
                    type: "string",
                    width: 110
                },
                {
                    dataIndex: "ZH_NAME",
                    type: "string",
                    text: "收款人",
                    width: 150
                },
                {
                    dataIndex: "ZH_BANK",
                    type: "string",
                    text: "开户银行",
                    width: 150
                },
                {
                    dataIndex: "ACCOUNT",
                    type: "string",
                    text: "账号",
                    width: 150
                },

                {
                    dataIndex: "REMARK",
                    type: "string",
                    text: "备注",
                    width: 130
                }
            ];
            return DSYGrid.createGrid({
                itemId: 'contentGrid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                flex: 1,
                params: {
                    WF_STATUS: WF_STATUS,
                    wf_id: wf_id,
                    node_code: node_code,
                    userCode:userCode,
                    AD_CODE:AD_CODE,
                    AG_CODE:AG_CODE
                },
                dataUrl: '/tksq_reflct.action?call=getAllinfoMainGrid',
                checkBox: true,
                border: false,
                autoLoad: false,
                height: '100%',
                tbar: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '状态',
                        name: 'WF_STATUS',
                        store: tkbz_json_common.store['WF_STATUS'],
                        width: 110,
                        labelWidth: 30,
                        labelAlign: 'right',
                        editable: false, //禁用编辑
                        displayField: "name",
                        valueField: "id",
                        value: WF_STATUS,
                        allowBlank: false,
                        listeners: {
                            change: function (self, newValue) {
                                WF_STATUS = newValue;
                                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                                toolbar.removeAll();
                                toolbar.add(tkbz_json_common.items[WF_STATUS]);
                                //刷新当前表格
                                reloadGrid();
                            }
                        }
                    },
                ],
                tbarHeight: 50,
                pageConfig: {
                    pageNum: true//设置显示每页条数
                },
//                features: [{
//                    ftype: 'summary'
//                }],
                listeners: {
                    itemclick: function (self, record) {
                        //刷新明细表
                        DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['TKBZ_ID'] = record.get('TKBZ_ID');
                        DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                    }
                }
            });
        }

        /**
         * 初始化明细表格
         */
        function initContentDetilGrid(callback) {
            var headerJson = [
                {
                    xtype: 'rownumberer', width: 40, summaryType: 'count',
                    summaryRenderer: function () {
                        return '合计';
                    }
                },
                {
                    dataIndex: "FK_DATE",
                    width: 130,
                    type: "string",
                    text: "付款日期"
                },
                {
                    dataIndex: "ZDXY_NAME",
                    width: 130,
                    type: "string",
                    text: "支付类别"
                },
                {
                    dataIndex: "ZDXY_NO",
                    width: 130,
                    type: "string",
                    text: "支付类别id",
                    hidden:true
                },
                {
                    dataIndex: "ZF_AMT",
                    width: 150,
                    type: "float",
                    text: "支付金额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.######');
                    },
                    editor:
                        {
                            xtype: 'numberFieldFormat',
                            hideTrigger: true,
                            minValue: 0
                        }
                },
                {
                    dataIndex: "SQS_NO",
                    width: 200,
                    type: "string",
                    text: "申请书编号"
                },
                {
                    dataIndex: "REMARK",
                    width: 150,
                    type: "string",
                    text: "备注"
                }
            ];
            var simplyGrid = new DSYGridV2();
            var config = {
                itemId: 'contentGrid_detail',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                flex: 1,
                autoLoad: false,
                border: false,
                height: '50%',
                pageConfig: {
                    enablePage: false
                },
                features: [{
                    ftype: 'summary'
                }],
                dataUrl: '/tksq_reflct.action?call=getAllinfoMxGrid'
            };
            if (tkbz_json_common.item_content_detailgrid_config) {
                config = $.extend(false, config, tkbz_json_common.item_content_detailgrid_config);
            }
            var grid = simplyGrid.create(config);
            if (callback) {
                callback(grid);
            }
            return grid;
        }
        /**
         * 树点击节点时触发，刷新content主表格，明细表置为空
         */
        function reloadGrid(param, param_detail) {
            var grid = DSYGrid.getGrid('contentGrid');
            var store = grid.getStore();
            store.getProxy().extraParams['WF_STATUS'] = WF_STATUS;
            store.getProxy().extraParams['wf_id'] = wf_id;
            store.getProxy().extraParams['node_code'] = node_code;
            store.getProxy().extraParams['userCode'] = userCode;
            store.getProxy().extraParams['AG_CODE'] = AG_CODE;
            store.getProxy().extraParams['AD_CODE'] = AD_CODE;
            //刷新
            store.loadPage(1);
            //刷新下方表格,置为空
            if (DSYGrid.getGrid('contentGrid_detail')) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();
//                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['TKBZ_ID'] = "";
//                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            }
        }
    </script>
</body>
</html>
