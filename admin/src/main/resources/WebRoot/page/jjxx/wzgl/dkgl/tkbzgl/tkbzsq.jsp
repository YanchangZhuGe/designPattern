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
    <title>提款报账申请/审核</title>
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
        Ext.define('accountModel', {
            extend: 'Ext.data.Model',
            fields: [
                {name: 'id',mapping:'ZJZH_ID'},
                {name: 'name',mapping:'ZH_NAME'},
                {name: 'ZH_TYPE'},
                {name: 'ZH_BANK'},
                {name: 'ACCOUNT'}
            ]
        });
        var wf_id = "${fns:getParamValue('wf_id')}";//当前工作流id
        var node_code = "${fns:getParamValue('node_code')}";//当前节点id，1：录入岗；2：审核岗
        var userCode= '${sessionScope.USERCODE}';
        var AD_CODE= '${sessionScope.ADCODE}';
        if(AD_CODE!=null&&AD_CODE!=undefined&&AD_CODE!=''){
            if(AD_CODE.length==2 || (AD_CODE.length==4 && !AD_CODE.endWith('00'))){
                AD_CODE = AD_CODE + '00';
            }
        }
        var AG_CODE= '${sessionScope.AGCODE}';
        var button_name = '';//当前操作按钮名称
        var button_text = '';
        var TKBZ_ID_FJ;
        var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态，指未送审...
        if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
            WF_STATUS = '001';
        }
        var wzzclxStore = DebtEleStoreDB("DEBT_WZZCLX");
        /**
         * 获取该单位银行账户信息
         */
        function getBankStore(){
            var bankDataStore = Ext.create('Ext.data.Store', {
                model: 'accountModel',
                proxy: {
                    type: 'ajax',
                    method: 'POST',
                    url: "/getBankData.action",
                    reader: {
                        type: 'json'
                    },
                    extraParams:{
                        AD_CODE : AD_CODE,
                        AG_CODE : AG_CODE
                    }
                },
                autoLoad: true
            });
            return bankDataStore;
        }
        /**
         * 通用函数：获取url中的参数
         */
        /* function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
            var r = window.location.search.substr(1).match(reg);  //匹配目标参数
            if (r != null) return unescape(r[2]);
            return null; //返回参数值
        } */
        /**
         * 页面初始化
         */
        $(document).ready(function () {
            //显示提示，并form表单提示位置为表单项下方
            Ext.QuickTips.init();
            Ext.form.Field.prototype.msgTarget = 'side';
            initContent();
            if (tkbz_json_common[wf_id][node_code].callBack) {
                tkbz_json_common[wf_id][node_code].callBack();
            }
        });
        /**
         * 通用配置json
         */
        var tkbz_json_common = {
            100404:{
                1: {
                    items: {
                        '001': [
                            {
                                xtype: 'button',
                                text: '查询',
                                icon: '/image/sysbutton/search.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    reloadGrid();
                                }
                            },
                            {
                                xtype: 'button',
                                text: '报账申请',
                                name: 'btn_insert',
                                icon: '/image/sysbutton/add.png',
                                handler: function (btn) {
                                    var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
                                    var tree_selected = tree_area.getSelection();
                                    if (!tree_selected || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
                                        Ext.MessageBox.alert('提示', '请选择一个底级单位再进行操作');
                                        return false;
                                    }
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    $.post("/getId.action", function (data) {
                                        if (!data.success) {
                                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                            return;
                                        }
                                        //弹出弹出框，设置ID
                                        TKBZ_ID_FJ = data.data[0];
                                        window_select.show();
                                    }, "json");
                                }
                            },
                            {
                                xtype: 'button',
                                text: '修改',
                                name: 'btn_update',
                                icon: '/image/sysbutton/edit.png',
                                handler: function (btn) {
                                    // 获取选中数据
                                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                                    if (records.length != 1) {
                                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                        return;
                                    }
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    var record = records[0].getData();
                                    //弹出弹出框，设置ID
                                    TKBZ_ID_FJ = record.TKBZ_ID;
                                    record.WT_AMT = record.WT_AMT + record.SQTK_AMT;
                                    window_input.show();
                                    window_input.window.down('form').getForm().setValues(record);
                                    //获取明细grid
                                    DSYGrid.getGrid('tkbz_grid').getStore().removeAll();
                                    DSYGrid.getGrid('tkbz_grid').getStore().getProxy().extraParams['TKBZ_ID'] = record.TKBZ_ID;
                                    DSYGrid.getGrid('tkbz_grid').getStore().loadPage(1);
                                }
                            },
                            {
                                xtype: 'button',
                                text: '删除',
                                name: 'btn_delete',
                                icon: '/image/sysbutton/delete.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    // 获取选中数据
                                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                                    if (records.length == 0) {
                                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                        return;
                                    }
                                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                        if (btn_confirm == 'yes') {
                                            deleteInfo(records);
                                        }
                                    });
                                }
                            },
                            {
                                xtype: 'button',
                                text: '送审',
                                name: 'down',
                                icon: '/image/sysbutton/audit.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                                    if (records.length == 0) {
                                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                        return;
                                    }else{
                                        Ext.Msg.confirm('提示', '请确认是否送审！', function (btn_confirm) {
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
                        ],
                        '002': [
                            {
                                xtype: 'button',
                                text: '查询',
                                icon: '/image/sysbutton/search.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    reloadGrid();
                                }
                            },
                            {
                                xtype: 'button',
                                text: '撤销送审',
                                name: 'cancel',
                                icon: '/image/sysbutton/audit.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                                    if (records.length == 0) {
                                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                        return;
                                    }else{
                                        Ext.Msg.confirm('提示', '请确认是否撤销送审！', function (btn_confirm) {
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
                        ],
                        '004': [
                            {
                                xtype: 'button',
                                text: '查询',
                                icon: '/image/sysbutton/search.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    reloadGrid();
                                }
                            },
                            {
                                xtype: 'button',
                                text: '修改',
                                name: 'btn_update',
                                icon: '/image/sysbutton/edit.png',
                                handler: function (btn) {
                                    // 获取选中数据
                                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                                    if (records.length != 1) {
                                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                        return;
                                    }
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    var record = records[0].getData();
                                    //弹出弹出框，设置ID
                                    TKBZ_ID_FJ = record.TKBZ_ID;
                                    record.WT_AMT = record.WT_AMT + record.SQTK_AMT;
                                    window_input.show();
                                    window_input.window.down('form').getForm().setValues(record);
                                    //获取明细grid
                                    DSYGrid.getGrid('tkbz_grid').getStore().removeAll();
                                    DSYGrid.getGrid('tkbz_grid').getStore().getProxy().extraParams['TKBZ_ID'] = record.TKBZ_ID;
                                    DSYGrid.getGrid('tkbz_grid').getStore().loadPage(1);
                                }
                            },
                            {
                                xtype: 'button',
                                text: '删除',
                                name: 'btn_delete',
                                icon: '/image/sysbutton/delete.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    // 获取选中数据
                                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                                    if (records.length == 0) {
                                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                        return;
                                    }
                                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                        if (btn_confirm == 'yes') {
                                            deleteInfo(records);
                                        }
                                    });
                                }
                            },
                            {
                                xtype: 'button',
                                text: '送审',
                                name: 'down',
                                icon: '/image/sysbutton/audit.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                                    if (records.length == 0) {
                                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                        return;
                                    }else{
                                        Ext.Msg.confirm('提示', '请确认是否送审！', function (btn_confirm) {
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
                        ],
                        '008': [
                            {
                                xtype: 'button',
                                text: '查询',
                                name: 'btn_check',
                                icon: '/image/sysbutton/search.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    reloadGrid();
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
                        '000': [
                            {
                                xtype: 'button',
                                text: '查询',
                                name: 'btn_check',
                                icon: '/image/sysbutton/search.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    reloadGrid();
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
                            }
                        ]
                    },
                    store: {
                        WF_STATUS: DebtEleStore(json_debt_zt1_1)
                    }
                }
            }
        };
        function deleteInfo(records) {
            var tkbz_ids = [];
            Ext.each(records, function (record) {
                tkbz_ids.push(record.get("TKBZ_ID"));
            });
            //发送ajax请求，删除数据
            $.post("/tksq_reflct.action?call=delWztksqInfo", {
                tkbz_ids: Ext.util.JSON.encode(tkbz_ids),
                userCode:userCode
            }, function (data) {
                if (data.success) {
                    Ext.toast({
                        html:  "删除成功！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    //刷新表格
                    reloadGrid();
                } else {
                    Ext.MessageBox.alert('提示', '删除失败！' + data.message);
                }
            }, "json");
        }
        function doworkupdate(records,btn) {
            var ids=new Array();
            var btn_name=btn.name;
            var btn_text=btn.text;
            for(var k=0;k<records.length;k++){
                var zd_id=records[k].get("TKBZ_ID");
                ids.push(zd_id);
            }
            $.post('/tksq_reflct.action',{
                ids: Ext.util.JSON.encode(ids),
                btn_name:btn_name,
                btn_text:btn_text,
                node_code:node_code,
                wf_id:wf_id,
                audit_info:"",
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
                        items: tkbz_json_common[wf_id][node_code].items[WF_STATUS]
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
                    dataIndex:"TKBZ_ID",
                    type:"string",
                    width:130,
                    hidden:true,
                    text:"主单id"

                },
                {
                    dataIndex:"TKBZ_CODE",
                    type:"string",
                    width:130,
                    hidden:true,
                    text:"主单code"

                },
                {
                    dataIndex: "WZXY_CODE",
                    type: "string",
                    width: 130,
                    hidden:true,
                    text: "外债编码"
                },

                {
                    dataIndex: "SJXM_ID",
                    type: "string",
                    width: 130,
                    hidden:true,
                    text: "上级项目ID"
                },
                {
                    dataIndex: "WZ_ID",
                    type: "string",
                    width: 130,
                    hidden:true,
                    text: "外债ID"
                },
                {
                    dataIndex: "FM_NAME",
                    type: "string",
                    width: 130,
                    hidden:true,
                    text: "币种"
                },

                {
                    dataIndex: "AG_NAME",
                    type: "string",
                    width: 130,
                    text: "单位名称"
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
                    hidden:false,
                    text: "协议金额(原币万元)",
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.######');
                    },
                },
                {
                    dataIndex: "FM_NAME",
                    type: "string",
                    width: 130,
                    text: "币种"
                },
                {
                    dataIndex: "XM_NAME",
                    width: 200,
                    type: "string",
                    text: "项目名称",
                    renderer: function (data, cell, record) {
                        /*var hrefUrl = '/page/debt/common/xmyhs.jsp?XM_ID=' + record.get('XM_ID') + '&IS_RZXM=' + record.get("IS_RZXM");
                        return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
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
                    width: 130,
                    type: "string",
                    text: "申请单号"
                },

                {
                    dataIndex: "SQTK_AMT",
                    width: 200,
                    type: "float",
                    text: "申请提款金额(万元)",
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.######');
                    },
//                    summaryType: 'sum',
//                    summaryRenderer: function (value) {
//                        return Ext.util.Format.number(value, '0,000.00');
//                    }
                },
                {
                    dataIndex: "WB_ID",
                    type: "string",
                    text: "申请支付币种",
                    width: 110
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
                    dataIndex: "ZH_TYPE",
                    type: "string",
                    text: "账户类型",
                    width: 150,
                    hidden:true
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
                        store: tkbz_json_common[wf_id][node_code].store['WF_STATUS'],
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
                                toolbar.add(tkbz_json_common[wf_id][node_code].items[WF_STATUS]);
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
            if (tkbz_json_common[wf_id][node_code].item_content_detailgrid_config) {
                config = $.extend(false, config, tkbz_json_common[wf_id][node_code].item_content_detailgrid_config);
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
            store.removeAll();
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
            }
        }

        /**
         * 创建外债信息选择弹出窗口
         */
        var window_select = {
            window: null,
            show: function (params) {
                this.window = initWindow_select(params);
                this.window.show();
            }
        };
        /**
         * 初始化外债选择弹出窗口
         */
        function initWindow_select(params) {
            return Ext.create('Ext.window.Window', {
                title: '转贷外债选择', // 窗口标题
                width: document.body.clientWidth * 0.9, // 窗口宽度
                height: document.body.clientHeight * 0.95, // 窗口高度
                layout: 'vbox',
                maximizable: true,
                itemId: 'window_select', // 窗口标识
                buttonAlign: 'right', // 按钮显示的位置
                modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
                closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
                items: [initWindow_select_grid(params)],
                buttons: [
                    {
                        text: '确认',
                        handler: function (btn) {
                            //获取表格选中数据
                            var records = btn.up('window').down('grid').getSelection();
                            if (records.length != 1) {
                                Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                                return;
                            }
                            var record = records[0].getData();
                            window_input.wz_code = record.WZ_CODE;
                            window_input.show();
                            window_input.window.down('form').getForm().setValues(record);
                            //刷新填报弹出中外债明细表获取报账计划
                            var store = window_input.window.down('form').down('grid[itemId="tkbz_grid"]').getStore();
                            btn.up('window').close();

                        }
                    },
                    {
                        text: '关闭',
                        handler: function (btn) {
                            btn.up('window').close();
                        }
                    }
                ]
            });
        }

        /**
         * 初始化外债选择弹出框表格
         */
        function initWindow_select_grid(params) {
            var headerJson = [
                {xtype: 'rownumberer', width: 35},
                {
                    "dataIndex": "WZ_ID",
                    "type": "string",
                    "text": "外债ID",
                    "fontSize": "15px",
                    "width": 150,
                    hidden: true
                },
                {
                    "dataIndex":"WZXY_ID",
                    "type":"string",
                    "text":"外债协议id",
                    "fontSize":150,
                    "width":150,
                    hidden:true
                },
                {
                    "dataIndex": "AREA",
                    "type": "string",
                    "text": "地区",
                    "fontSize": "15px",
                    "width": 120
                },
                {
                    "dataIndex": "AG_NAME",
                    "type": "string",
                    "text": "单位",
                    "fontSize": "15px",
                    "width": 120
                },
                {
                    "dataIndex": "WZ_CODE",
                    "type": "string",
                    "text": "外债编码",
                    "fontSize": "15px",
                    "width": 120
                },
                {
                    "dataIndex": "WZ_NAME",
                    "type": "string",
                    "width": 130,
                    "text": "外债名称",
                    "hrefType": "combo"
                },
                {
                    "dataIndex": "SJXM_ID",
                    "type": "string",
                    "width": 250,
                    "text": "上级项目ID",
                    hidden:true
                },
                {
                    "dataIndex": "XM_ID",
                    "type": "string",
                    "width": 250,
                    "text": "项目ID",
                    hidden:true
                },
                {
                    "dataIndex": "XM_NAME",
                    "type": "string",
                    "width": 200,
                    "text": "项目名称",
                    "hrefType": "combo",
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
                    "dataIndex": "WZ_XY_DATE",
                    "width": 130,
                    "type": "string",
                    "text": "签订日期"
                },
                {
                    "dataIndex":"ZWLB_ID",
                    "width":130,
                    "type":"string",
                    "text":"债务类别",
                    "hidden":true
                },
                {
                    "dataIndex": "ZWLX_NAME",
                    "width": 130,
                    "type": "string",
                    "text": "债务类别"
                },
                {
                    "dataIndex": "WZXY_AMT",
                    "type": "float",
                    "text": "协议金额(原币万元)",
                    "fontSize": "15px",
                    "width": 200,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.######');
                    }
                },
                {
                    "dataIndex": "WZXY_AMT_RMB",
                    "type": "float",
                    "text": "协议金额(人民币万元)",
                    "fontSize": "15px",
                    "width": 200,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.######');
                    }
                },
                {
                    "dataIndex": "FM_ID",
                    "type": "string",
                    "text": "币种",
                    "fontSize": "15px",
                    "width": 130,
                    hidden: true
                },
                {
                    "dataIndex":"FM_NAME",
                    "type":"string",
                    "text":"币种",
                    "width":150
                },
                {
                    "dataIndex": "HL_RATE",
                    "type": "float",
                    "text": "汇率",
                    "fontSize": "15px",
                    "width": 150
                }
            ];
            var simplyGrid = new DSYGridV2();
            return simplyGrid.create({
                itemId: 'grid_select',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                selModel: {
                    mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
                },
                checkBox: true,
                border: false,
                width: '100%',
                flex: 1,
                pageConfig: {
                    enablePage: false
                },
                params: {
                    AD_CODE: AD_CODE,
                    AG_CODE:AG_CODE
                },
                tbar: [
                    {
                        xtype: "textfield",
                        name: "mhcx",
                        id: "mhcx",
                        fieldLabel: '模糊查询',
                        allowBlank: true,  // requires a non-empty value
                        labelWidth: 70,
                        width: 260,
                        labelAlign: 'right',
                        emptyText: '请输入外债名称/外债编码...',
                        enableKeyEvents: true,
                        listeners: {
                            keypress: function (self, e) {
                                if (e.getKey() == Ext.EventObject.ENTER) {
                                    var store = self.up('grid').getStore();
                                    store.getProxy().extraParams['mhcx'] = self.getValue();
                                    // 刷新表格
                                    self.up('grid').getStore().loadPage(1);
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '查询',
                        name: 'btn_check',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            var keyValue = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
                            btn.up('grid').getStore().getProxy().extraParams["mhcx"] = keyValue;
                            btn.up('grid').getStore().loadPage(1);

                        }
                    }
                ],
                tbarHeight: 50,
                listeners: {
                    itemclick: function (self, record) {
                        //刷新明细表
                    }
                },
                dataUrl: '/tksq_reflct.action?call=getZqxxGridData'
            });
        }
        //创建申报信息填报弹出窗口
        var window_input = {
            window: null,
            wz_code: null,
            show: function () {
                this.window = initWindow_input();
                this.window.show();
            }
        };
        /**
         * 初始化提款报账弹出窗口
         */
        function initWindow_input() {
            return Ext.create('Ext.window.Window', {
                    title: '报账申请', // 窗口标题
                    width: document.body.clientWidth * 0.9, // 窗口宽度
                    height: document.body.clientHeight * 0.95, // 窗口高度
                    layout: 'fit',
                    border: false,
                    maximizable: true,
                    itemId: 'window_input', // 窗口标识
                    buttonAlign: 'right', // 按钮显示的位置
                    modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
                    closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
                    items: {
                        xtype: 'tabpanel',
                        items: [{
                            title: '提款报账明细',
                            scrollable: true,
                            items: [initWindow_input_contentForm()]
                        },
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            layout: 'fit',
                            items: [
                                {
                                    xtype: 'panel',
                                    layout: 'fit',
                                    itemId: 'window_save_zcxx_file_panel',
                                    items: [initWin_dkxyPanel_Fj()]
                                }
                            ]
                        }]

                },
                buttons: [
                    {
                        //xtype: 'button',
                        text: '添加',
                        width: 60,
                        handler: function (btn) {
                            btn.up('window').down('grid').insertData(null,{});
                        }
                    },
                    {
                        //xtype: 'button',
                        itemId: 'tzjhDelBtn',
                        text: '删除',
                        width: 60,
                        disabled: true,
                        handler: function (btn) {
                            var grid = btn.up('window').down('grid');
                            var store = grid.getStore();
                            var sm = grid.getSelectionModel();
                            store.remove(sm.getSelection());
                            if (store.getCount() > 0) {
                                sm.select(0);
                            }
                            //自动计算申请金额
                            var wzzdStore = DSYGrid.getGrid("tkbz_grid").getStore();
                            Ext.ComponentQuery.query('numberFieldFormat[name="SQTK_AMT"]')[0].setValue(wzzdStore.sum('ZF_AMT'));
                        }
                    },
                    {
                        text: '保存',
                        handler: function (btn) {
                            //获取form
                            var form = Ext.ComponentQuery.query('form[itemId="tksqForm"]')[0].getForm();
                            if (!form.isValid()) {
                                return;
                            }
                            var form_data=form.getValues();
                            var zhName = form.findField("ZH_NAME").getRawValue();
                            form_data.ZH_NAME=zhName;
                            //获取grid
                            var gridStore=Ext.ComponentQuery.query('grid[itemId="tkbz_grid"]')[0];
                            var store_data=new Array();
                            var grid_store=gridStore.getStore();
                            for(var i=0;i<grid_store.getCount();i++){
                                var record=grid_store.getAt(i);
                                var var$FK_DATE=record.get("FK_DATE");
                                var var$ZDXY_NO=record.get("ZDXY_NO");
                                var var$ZF_AMT=record.get("ZF_AMT");
                                var var$SQS_NO=record.get("SQS_NO");
                                if(!(var$FK_DATE!=null&&var$FK_DATE!=undefined&&var$FK_DATE!="")){
                                    Ext.toast({
                                        html:  "明细中付款日期不能为空！" ,
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    return false;
                                }
                                if(!(var$ZDXY_NO!=null&&var$ZDXY_NO!=undefined&&var$ZDXY_NO!="")){
                                    Ext.toast({
                                        html:  "明细支付类别不能为空！" ,
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    return false;
                                }
                                if(!(var$ZF_AMT!=null&&var$ZF_AMT!=undefined&&var$ZF_AMT!="")){
                                    Ext.toast({
                                        html:  "明细中支付金额不能为空！" ,
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    return false;
                                }
                                if(!(var$SQS_NO!=null&&var$SQS_NO!=undefined&&var$SQS_NO!="")){
                                    Ext.toast({
                                        html:  "明细中申请书编号不能为空！" ,
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    return false;
                                }
                                var data  =record.data;
                                store_data.push(data);
                            }
                            if(store_data.length<1){
                                Ext.MessageBox.alert('提示', '请录入支付明细！');
                                return;
                            }
                            btn.setDisabled(true);
                            Ext.Ajax.request({
                                method: 'POST',
                                url: "/tksq_reflct.action",
                                params: {
                                    call:"saveTKSQ",
                                    ID:TKBZ_ID_FJ,
                                    AG_NAME : AG_NAME,
                                    AG_CODE:AG_CODE,
                                    AG_ID:AG_ID,
                                    AD_CODE:AD_CODE,
                                    USERCODE:userCode,
                                    wf_id:wf_id,
                                    node_code:node_code,
                                    botton_name:button_name,
                                    button_text:button_text,
                                    formList:Ext.util.JSON.encode(form_data),
                                    detailList:Ext.util.JSON.encode(store_data)
                                },
                                async: false,
                                success: function (response) {
                                    var result=Ext.util.JSON.decode(response.responseText);
                                    if(result.success){
                                        Ext.toast({
                                            html: "保存成功！",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                        btn.up('window').close();
                                        reloadGrid();
                                    }else{
                                        Ext.toast({
                                            html: "保存失败！"+result.message,
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                        btn.setDisabled(false);
                                        return false;
                                    }
                                },
                                failure: function (resp, opt) {
                                }
                            });
                        }
                    },
                    {
                        text: '取消',
                        handler: function (btn) {
                            btn.up('window').close();
                        }
                    }
                ]
            });
        }

        /**
         * 初始化协议信息填报弹出窗口中的附件标签页
         */
        function initWin_dkxyPanel_Fj() {
            var grid = UploadPanel.createGrid({
                busiType: 'WZ_TKBZ',//业务类型
                busiId: TKBZ_ID_FJ,//业务ID
                busiProperty: '%',//业务规则，默认为‘%’
                editable: true,//是否可以修改附件内容，默认为ture
                gridConfig: {
                    itemId: 'window_tkbztb_contentForm_tab_xyfj_grid'
                }
            });
            //附件加载完成后计算总文件数，并写到页签上
            grid.getStore().on('load', function (self, records, successful) {
                var sum = 0;
                if (records != null) {
                    for (var i = 0; i < records.length; i++) {
                        if (records[i].data.STATUS == '已上传') {
                            sum++;
                        }
                    }
                }
                if (grid.up('tabpanel').el.dom) {
                    $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
                } else {
                    $('span.file_sum').html('(' + sum + ')');
                }
            });
            return grid;
        }
        /**
         * 初始化外债提款报账表单
         */
        function initWindow_input_contentForm() {
            var bankStore=getBankStore();
            return Ext.create('Ext.form.Panel', {
                width: '100%',
                height: '100%',
                layout: 'vbox',
                itemId:"tksqForm",
                fileUpload: true,
                padding: '2 5 0 5',
                border: false,
                defaults: {
                    width: '100%'
                },
                defaultType: 'textfield',
                items: [
                    {
                        xtype: 'container',
                        layout: 'column',
                        defaultType: 'textfield',
                        defaults: {
                            margin: '2 5 2 5',
                            columnWidth: .33,
                            //width: 280,
                            labelWidth: 130//控件默认标签宽度
                        },
                        items: [
                            {
                                xtype:"textfield",
                                fieldLabel:"提款报账id",
                                name:"TKBZ_ID",
                                readOnly:true,
                                hidden:true,
                                editable:false
                            },
                            {
                                xtype:"textfield",
                                fieldLabel:"外债协议id",
                                name:"WZXY_ID",
                                hidden:true,
                                readOnly:true,
                                editable:false
                            },
                            {
                                xtype:"textfield",
                                fieldLabel:"项目id",
                                name:"XM_ID",
                                hidden:true,
                                readOnly:true,
                                editable:false
                            },
                            {
                                xtype:"textfield",
                                fieldLabel:"上级项目id",
                                name:"SJXM_ID",
                                hidden:true,
                                readOnly:true,
                                editable:false

                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '外债ID',
                                name: "WZ_ID",
                                hidden:true,
                                editable: false//禁用编辑
                            },

                            {
                                xtype: "textfield",
                                fieldLabel: '单位',
                                name: "AG_NAME",
                                editable: false,//禁用编辑
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6'
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '外债名称',
                                name: "WZ_NAME",
                                editable: false,//禁用编辑
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6'
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '项目名称',
                                name: "XM_NAME",
                                editable: false,//禁用编辑
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6'
                            },
                            {
                                xtype: "numberFieldFormat",
                                fieldLabel: '协议金额（原币）',
                                name: "WZXY_AMT",
                                editable: false,//禁用编辑
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6',
                                allowBlank: false,
                                allowDecimals: true,
                                decimalPrecision: 2,
                                keyNavEnabled: true,
                                emptyText: '0.00',
                                hideTrigger: true,
                                mouseWheelEnabled: true
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '币种',
                                name: "FM_NAME",
                                editable: false,//禁用编辑
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6'
                            },
//                            {
//                                xtype: "numberFieldFormat",
//                                fieldLabel: '未提金额',
//                                name: "WT_AMT",
//                                editable: false,//禁用编辑
//                                readOnly: true,
//                                fieldStyle: 'background:#E6E6E6',
//                                allowBlank: false,
//                                allowDecimals: true,
//                                decimalPrecision: 2,
//                                keyNavEnabled: true,
//                                emptyText: '0.00',
//                                hideTrigger: true,
//                                mouseWheelEnabled: true
//                            },
                            {
                                xtype: "datefield",
                                fieldLabel: '申请日期',
                                name: "SQ_DATE",
                                allowBlank: false,
                                editable: false,//禁用编辑
                                format: 'Y-m-d',
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6',
                                value: new Date()
                            }
                        ]
                    },
                    {//分割线
                        xtype: 'menuseparator',
                        margin: '5 0 5 0',
                        border: true
                    },
                    {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        //width: 280,
                        labelWidth: 130//控件默认标签宽度
                    },
                    items: [
                            {
                                xtype: "textfield",
                                fieldLabel: '申请单号',
                                name: "TKBZ_CODE",
                                editable: true,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '申请支付币种',
                                name: "WB_NAME",
                                editable: false,//禁用编辑
                                store: DebtEleStoreDB('DEBT_WB'),
                                displayField: "name",
                                valueField: "code",
                                allowBlank: false,//不允许为空
                                value: 'CNY'
                            },
                            {
                                xtype: "numberFieldFormat",
                                fieldLabel: '申请提款金额',
                                name: "SQTK_AMT",
                                editable: false,
                                allowBlank: false,
                                allowDecimals: true,
                                decimalPrecision: 2,
                                keyNavEnabled: true,
                                emptyText: '0.00',
                                hideTrigger: true,
                                mouseWheelEnabled: true,
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6',
                                minValue: 0,
                                listeners:{
                                    'change': function (self, newValue, oldValue) {
//                                        var form = this.up('form').getForm();
//                                        var WT_AMT = form.findField('WT_AMT').value;
//                                        if(WT_AMT==null || WT_AMT == ""){
//                                            return;
//                                        }
//                                        if(newValue>WT_AMT){
//                                            Ext.MessageBox.alert('提示', '申请提款金额不能大于未提金额！');
//                                            form.findField("SQTK_AMT").setValue("");
//                                        }
                                    }
                                }
                            },
                            {
                                xtype: "datefield",
                                name: "SQDZ_DATE",
                                fieldLabel: '申请到账日期',
                                format: 'Y-m-d',
                                columnWidth:0.33,
                                editable: false,
                                allowBlank: false,
                                value: new Date()
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '账户类型',
                                name: "ZH_TYPE",
                                editable: true,
                                hidden:true
                            },
                            {

                                xtype: 'combobox',
                                fieldLabel: '收款账户',
                                name: 'ZH_NAME',
                                displayField: 'name',
                                valueField: 'id',
                                editable: false,
                                allowBlank: false,
                                flex: 1,
                                autoLoad: false,
                                store: bankStore,
                                listeners:{
                                    'select': function (combo, record, index) {
                                        var ss=record.get('id');
                                        var account_value=bankStore.findRecord('ZJZH_ID', ss, false, true, true);
                                        if(account_value!=null&&account_value!=undefined){
                                            Ext.ComponentQuery.query('textfield[name="ACCOUNT"]')[0].setValue(account_value.get('ACCOUNT'));
                                            Ext.ComponentQuery.query('textfield[name="ZH_BANK"]')[0].setValue(account_value.get('ZH_BANK'));
                                            Ext.ComponentQuery.query('textfield[name="ZH_TYPE"]')[0].setValue(account_value.get('ZH_TYPE'));
                                        }
                                    }
                                }
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '开户行',
                                name: "ZH_BANK",
                                editable: false,
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6'
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '账号',
                                name: "ACCOUNT",
                                editable: false,
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6'
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '备注',
                                name: "REMARK",
                                editable: true,
                                columnWidth: 0.99
                            }
                        ]
                    },
                    {
                        xtype: 'fieldset',
                        title: '支付明细',
                        flex: 1,
                        layout: 'fit',
                        width: document.body.clientWidth * 0.87,
                        height : document.body.clientHeight * 0.5,
                        items: [initWindow_input_contentForm_grid()]
                    }
                ]
            });
        }
        /**
         * 初始化外债提款报账表单中明细信息表格
         */
        function initWindow_input_contentForm_grid() {
            var headerJson = [
                {
                    xtype: 'rownumberer',
                    width: 33
                },
                {
                    text: "付款日期",
                    type: "string",
                    dataIndex: "FK_DATE",
                    width: 110,
                    renderer: function (value, metaData, record) {
                        var newValue = dsyDateFormat(value);
                        record.data.S_DATE = newValue;
                        return newValue;
                    },
                    editor: {
                        xtype: 'datefield',
                        allowBlank: false,
                        editable: false,
                        format: 'Y-m-d'
                    }
                },
                {
                    dataIndex: "ZDXY_NO",
                    type: "string",
                    text: "支付类别",
                    width: 150,
                    editor: {
                        xtype: 'combobox',
                        allowBlank: false,
                        displayField: 'name',
                        valueField: 'id',
                        editable:false,
                        store: wzzclxStore
                    },
		            renderer: function (value) {
		                var record = wzzclxStore.findRecord('id', value, 0, true, true, true);
		                return record != null ? record.get('name') : value;
		            },
                    tdCls: 'grid-cell'
                },

                {
                    dataIndex: "ZF_AMT", type: "float", text: "支付金额(元)", width: 180,
                    editor: {
                        xtype: "numberFieldFormat",
                        allowBlank: false,
                        emptyText: '0.00',
                        hideTrigger: true,
                        mouseWheelEnabled: true,
                        minValue: 0,
                        allowBlank: false
                    }
                },
                {
                    dataIndex: "SQS_NO",
                    allowBlank: false,
                    type: "string",
                    text: "申请书编号",
                    width: 150,
                    editor: 'textfield',
                    tdCls: 'grid-cell'
                },
                {
                    dataIndex: "REMARK",
                    type: "string",
                    text: "备注",
                    width: 150,
                    editor: 'textfield'
                }
            ];
            var grid = DSYGrid.createGrid({
                itemId: 'tkbz_grid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                param:{},
                autoLoad: false,
                dataUrl: '/tksq_reflct.action?call=getAllinfoMxGrid',
                border: true,
                flex: 1,
                height: '100%',
                width: '100%',
                pageConfig: {
                    enablePage: false
                },
                plugins: [
                    {
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        pluginId: 'tzjhCellEdit',
                        clicksToMoveEditor: 1,
                        listeners: {
                            'afteredit': function (editor, context) {
                                //自动计算申请金额
                                if (context.field == 'ZF_AMT') {
                                    var ZF_AMT = (context.field == 'ZF_AMT') ? context.value : context.record.get("ZF_AMT");
                                    context.record.set('ZF_AMT', ZF_AMT);
                                }
                                var wzzdStore = DSYGrid.getGrid("tkbz_grid").getStore();
                                Ext.ComponentQuery.query('numberFieldFormat[name="SQTK_AMT"]')[0].setValue(wzzdStore.sum('ZF_AMT'));
                            }
                        }
                    }
                ]
            });
            grid.on('selectionchange', function (view, records) {
                grid.up('window').down('#tzjhDelBtn').setDisabled(!records.length);
            });
            return grid;
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
    </script>
</body>
</html>
