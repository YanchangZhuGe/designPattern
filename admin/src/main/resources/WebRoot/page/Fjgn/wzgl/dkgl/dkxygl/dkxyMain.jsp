<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
  <meta charset="UTF-8">
  <title>贷款协议录入</title>
  <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/debt/Map.js"></script>
  <script type="text/javascript" src="/js/commonUtil.js"></script>
</head>
<body>
<script type="text/javascript">
	var userCode = '${sessionScope.USERCODE}';
    var ADCODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var AD_LEVEL = ADCODE;
    if (ADCODE.endWith('00')) {
        AD_LEVEL = ADCODE.substring(0, ADCODE.length - 1 - 2);
    }
    var wf_id = "${fns:getParamValue('wf_id')}";//当前流程id
    var node_code = "${fns:getParamValue('node_code')}";//当前节点id
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var title =  '贷款协议录入' ;
    var button_name = '' ;
    var zqfl_condition = " AND code in ('03','0302')";
    var sjxm_condition = " AND EXTEND1 ='"+ADCODE+"' ";
    var DATA_ID;

    var SJXM_ID="";

    //建设项目基础数据
    Ext.define('sjxmModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'id',mapping:'DXM_ID'},
            {name: 'name',mapping:'DXM_NAME'}
        ]
    });
    Ext.define('rateModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'code',mapping:'WB_CODE'},
            {name: 'roe',mapping:'ROE'}
        ]
    });
    Ext.define('treeModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'text'},
            {name: 'code'},
            {name: 'id'},
            {name: 'leaf'}
        ]
    });
    /**
     * 获取当前日期，用于结息月日默认日期的设置
     * */
    var date = new Date;
    var month = date.getMonth() + 1;
    month = (month < 10 ? "0" + month : month);
    var zqr_store=DebtEleTreeStoreDB("DEBT_ZQR",{condition: "AND CODE LIKE '02%' OR CODE LIKE '03%'"});
    var rateStore = getRateStore();
    $(document).ready(function(){
		Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
        if (dkxy_json_common[wf_id][node_code].callBack) {
            dkxy_json_common[wf_id][node_code].callBack();
        }
    }) ;
    var store_zddw = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: '/wzgl_reflct.action?method=getZddwTreeStore',
            extraParams: {
                AD_CODE:ADCODE
            },
            reader: {
                type: 'json'
            }
        },
        root:'nodelist' ,
        model: 'treeModel',
        autoLoad: true
    });
    //转贷地区下拉框
    var grid_tree_store = Ext.create('Ext.data.Store', {//下拉框store
        fields: ['CODE', 'TEXT'],
        proxy: {
            type: 'ajax',
            url: '/wzgl_reflct.action?method=getAdDataByCode_cq',
            extraParams: {
                AD_CODE: ADCODE
            },
            reader: {
                type: 'json',
                root: 'data'
            }
        },
        autoLoad: true
    });
    //转贷项目下拉框
    var xm_tree_store = Ext.create('Ext.data.Store', {//下拉框store
        fields: ['ID','CODE', 'NAME'],
        proxy: {
            type: 'ajax',
            url: '/wzgl_reflct.action?method=getZdxm_cq',
            extraParams: {
            },
            reader: {
                type: 'json',
                root: 'data'
            }
        },
        autoLoad: false
    });
    /**
     * 获取大项目信息
     */
    function getRateStore(){
        var rateStore = Ext.create('Ext.data.Store', {
            model: 'rateModel',
            proxy: {
                type: 'ajax',
                method: 'POST',
                url: "/getRateData.action",
                reader: {
                    type: 'json'
                }
            },
            autoLoad: true
        });
        return rateStore;
    }
    function initContent(){
        Ext.create('Ext.panel.Panel',{
            layout:'border',
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
                    items: dkxy_json_common[wf_id][node_code].items[WF_STATUS]
                }
            ],
            items:[
                initContentRightPanel()//初始化右侧2个表格
            ]
        }) ;
    }
    var dkxy_json_common = {
        100401: {
            1: {//贷款协议录入
                items:{
                    '001': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '录入',
                        name: 'INPUT',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            button_name = btn.text;
                            $.post("/getId.action", function (data) {
                                if (!data.success) {
                                    Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                    return;
                                }
                                //弹出弹出框，设置ID
                                DATA_ID = data.data[0];
                                window_dkxxtb.show() ;
                                loadDqlx('');
                            }, "json");
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'UPDATE',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length != 1) {
                                Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                return;
                            }
                            //修改全局变量的值
                            button_name = btn.text;
                            title = "贷款协议修改";
                            DATA_ID = records[0].get("DATA_ID");
                            window_dkxxtb.show();
                            var START_DATE = records[0].get("HB_START_DATE");
                            var END_DATE = records[0].get("HB_END_DATE");
                            var HKZQ = records[0].get("FXZQ_ID");
                            if(HKZQ.toString().length<2){
                                HKZQ='0'+HKZQ
                            }
                            var CH_PERCENT = records[0].get("CH_PERCENT");
                            Ext.ComponentQuery.query('datefield[name="START_DATE"]')[0].setValue(START_DATE);
                            Ext.ComponentQuery.query('datefield[name="END_DATE"]')[0].setValue(END_DATE);
                            Ext.ComponentQuery.query('textfield[name="HKZQ"]')[0].setValue(HKZQ);
                            Ext.ComponentQuery.query('textfield[name="CH_PERCENT"]')[0].setValue(CH_PERCENT);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            //获取表格被选中行
                            var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                return;
                            }
                            Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                if (btn_confirm === 'yes') {
                                    button_name = btn.text;
                                    var ids = [];
                                    for (var i in records) {
                                        ids.push(records[i].get("DATA_ID"));
                                    }
                                    //发送ajax请求，删除数据
                                    $.post("/delDkxyInfo.action", {
                                        ids: ids
                                    }, function (data) {
                                        if (data.success) {
                                            Ext.toast({html: button_name + "成功！"});
                                        } else {
                                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        }
                                        //刷新表格
                                        reloadGrid();
                                    }, "json");
                                }
                            });
                        }
                    },
                    {
                        xtype: 'button',
                        text: '送审',
                        name: 'down',
                        icon: '/image/sysbutton/submit.png',
                        handler: function (btn) {
                            doWorkFlow(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '操作记录',
                        name: 'log',
                        icon: '/image/sysbutton/log.png',
                        handler: function (btn) {
                            dooperation();
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
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '撤销送审',
                        name: 'cancel',
                        icon: '/image/sysbutton/cancel.png',
                        handler: function (btn) {
                            doWorkFlow(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '操作记录',
                        name: 'log',
                        icon: '/image/sysbutton/log.png',
                        handler: function (btn) {
                            dooperation();
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
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'UPDATE',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length != 1) {
                                Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                return;
                            }
                            //修改全局变量的值
                            button_name = btn.text;
                            title = "贷款协议修改";
                            DATA_ID = records[0].get("DATA_ID");
                            window_dkxxtb.show();
                            var START_DATE = records[0].get("HB_START_DATE");
                            var END_DATE = records[0].get("HB_END_DATE");
                            var HKZQ = records[0].get("FXZQ_ID");
                            if(HKZQ.toString().length<2){
                                HKZQ='0'+HKZQ
                            }
                            var CH_PERCENT = records[0].get("CH_PERCENT");
                            Ext.ComponentQuery.query('datefield[name="START_DATE"]')[0].setValue(START_DATE);
                            Ext.ComponentQuery.query('datefield[name="END_DATE"]')[0].setValue(END_DATE);
                            Ext.ComponentQuery.query('textfield[name="HKZQ"]')[0].setValue(HKZQ);
                            Ext.ComponentQuery.query('textfield[name="CH_PERCENT"]')[0].setValue(CH_PERCENT);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            //获取表格被选中行
                            var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                return;
                            }
                            Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                if (btn_confirm === 'yes') {
                                    button_name = btn.text;
                                    var ids = [];
                                    for (var i in records) {
                                        ids.push(records[i].get("DATA_ID"));
                                    }
                                    //发送ajax请求，删除数据
                                    $.post("/delDkxyInfo.action", {
                                        ids: ids
                                    }, function (data) {
                                        if (data.success) {
                                            Ext.toast({html: button_name + "成功！"});
                                        } else {
                                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        }
                                        //刷新表格
                                        reloadGrid();
                                    }, "json");
                                }
                            });
                        }
                    },
                    {
                        xtype: 'button',
                        text: '送审',
                        icon: '/image/sysbutton/submit.png',
                        handler: function (btn) {
                            doWorkFlow(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '操作记录',
                        name: 'log',
                        icon: '/image/sysbutton/log.png',
                        handler: function (btn) {
                            dooperation();
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
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '操作记录',
                        name: 'log',
                        icon: '/image/sysbutton/log.png',
                        handler: function (btn) {
                            dooperation();
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt1)
                }
            },
            2: {//贷款协议审核
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
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
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
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
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
            }
        }
    };

    /**
     * 初始化右侧面板
     */
    function initContentRightPanel(){
        return Ext.create('Ext.form.Panel',{
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            border: false,
            items:[
                initContentGrid()
            ]
        }) ;
    }

    /**
     * 初始化右侧主表格
     */
    function initContentGrid() {
        var headerJson = [
            {
                xtype: 'rownumberer',
                summaryType: 'count',
                width: 40
            },
            {
                "dataIndex": "HB_START_DATE",
                "type": "string",
                "text": "还款开始日期",
                "fontSize": "15px",
                "hidden": true
            },
            {
                "dataIndex": "HB_END_DATE",
                "type": "string",
                "text": "还款终止日期",
                "fontSize": "15px",
                "hidden": true
            },
            {
                "dataIndex": "FXZQ_ID",
                "type": "int",
                "text": "付息周期",
                "fontSize": "15px",
                "hidden": true
            },
            {
                "dataIndex": "CH_PERCENT",
                "type": "float",
                "text": "偿还份额%",
                "fontSize": "15px",
                "hidden": true
            },
            {
                "dataIndex": "DATA_ID",
                "type": "string",
                "text": "主键ID",
                "fontSize": "15px",
                "hidden": true
            },
            {
                "dataIndex": "WZXY_ID",
                "type": "string",
                "text": "外债协议ID",
                "fontSize": "15px",
                "hidden": true
            }, /*{
                "dataIndex": "WZXY_CODE",
                "type": "string",
                "width": 250,
                "text": "外债编码"
            }, */{
                "dataIndex": "WZXY_NAME",
                "width": 250,
                "type": "string",
                "text": "外债名称"
            },
            {
                "dataIndex": "ZWLB_ID",
                "width": 100,
                "type": "string",
                "text": "债务类别"
            }, {
                "dataIndex": "SIGN_DATE",
                "width": 100,
                "type": "string",
                "text": "签订日期"
            }, {
                "dataIndex": "WZQX_ID",
                "width": 100,
                "type": "string",
                "text": "外债期限(月)"
            }, {
                "dataIndex": "ZQFL_ID",
                "width": 150,
                "type": "string",
                "text": "债权类型"
            }, {
                "dataIndex": "ZQR_ID",
                "width": 150,
                "type": "string",
                "text": "债权人"
            }, {
                "dataIndex": "ZQR_FULLNAME",
                "width": 300,
                "type": "string",
                "text": "债权人全称"
            },
            {
                "dataIndex": "WZXY_NO",
                "width": 150,
                "type": "string",
                "text": "协议号"
            }, {
                "dataIndex": "ZJYT_ID",
                "width": 150,
                "type": "string",
                "text": "资金用途"
            }, {
                "dataIndex": "SJXM_ID",
                "width": 200,
                "type": "string",
                "text": "建设项目"
            }, {
                text: '债务类型',
                dataIndex: 'XMFL',
                type: "string",
                renderer: function (value) {
                    var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
                    return result != null ? result.get('name') : value;
                }
            },{
                "dataIndex": "WZXY_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "协议金额（原币）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            }, {
                "dataIndex": "FM_ID",
                "width": 100,
                "type": "string",
                "text": true ? "原币币种" : "币种"
            }, {
                "dataIndex": "HL_RATE",
                "width": 80,
                "type": "float",
                "align": 'right',
                "text": "汇率",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            }, {
                "dataIndex": "WZXY_AMT_RMB",
                "width": 180,
                "type": "float",
                "align": 'right',
                "text": "协议金额（人民币）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            },
            {
                "dataIndex": "ZXCS_ID",
                "width": 150,
                "type": "string",
                "text": "增信措施"
            }
        ];
        var simplyGrid = new DSYGridV2();
        return simplyGrid.create({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            params: {
                wf_status: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code
            },
            dataUrl: 'getDkxyInfo.action',
            checkBox: true,
            rowNumber: true,
            border: false,
            height: '50%',
            flex: 1,
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    itemId: 'contentGrid_status',
                    name: 'contentGrid_status',
                    store: dkxy_json_common[wf_id][node_code].store['WF_STATUS'],
                    width: 110,
                    editable: false,
                    labelWidth: 30,
                    labelAlign: 'right',
                    allowBlank: false,
                    displayField: "name",
                    valueField: "code",
                    value: WF_STATUS,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            WF_STATUS = newValue ;
                            toolbar.add(dkxy_json_common[wf_id][node_code].items[WF_STATUS]) ;
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams["wf_status"] = WF_STATUS;
                            self.up('grid').getStore().getProxy().extraParams["wf_id"] = wf_id;
                            self.up('grid').getStore().getProxy().extraParams["node_code"] = node_code;
                            /*self.up('grid').getStore().loadPage(1);*/
                            reloadGrid();
                        }
                    }
                }
            ],
            tbarHeight: 50,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            /*listeners: {
                //曾经办状态，双击可查看协议信息
                itemdblclick: function (self, record) {
                    if (WF_STATUS == '008') {
                        DATA_ID = record.get("DATA_ID");
                        button_name = '修改';
                        title = "贷款协议信息";
                        window_dkxxtb.show();
                    }

                }
            }*/
        });
    }

    var window_dkxxtb = {
        window: null,
        config: {
            closeAction: 'destroy'
        },
        show:function(){
            if(!this.window || this.config.closeAction == 'destory'){
                this.window = initWindow_dkxxtb() ;
            }
            this.window.show() ;
        }
    } ;
    /**
     * 获取需要保存的转贷信息
     */
    function getZdxxList(){
        var zdxxStore = DSYGrid.getGrid('wzzd_grid2').getStore();
        var zdgridvalues=new Array();
        for(var j=0;j<zdxxStore.getCount();j++){
            var zdrecord=zdxxStore.getAt(j);
            var var$ad_code=zdrecord.get("AD_CODE");
            var var$ag_code=zdrecord.get("AG_CODE");
            var var$sjxm_id=zdrecord.get("ZDXM_NAME");
            var var$zdxy_no=zdrecord.get("ZDXY_NO");
            var var$zdxy_amt=zdrecord.get("ZDXY_AMT");
            if(!(var$ad_code!=null&&var$ad_code!=undefined&&var$ad_code!="")){
                Ext.Msg.alert('提示', "明细中转贷地区不能为空！");
                return false;
            }
            if(!(var$ag_code!=null&&var$ag_code!=undefined&&var$ag_code!="")){
                Ext.Msg.alert('提示', "明细中转贷单位不能为空！");
                return false;
            }

            if(!(var$sjxm_id!=null&&var$sjxm_id!=undefined&&var$sjxm_id!="")){
                Ext.Msg.alert('提示', "明细中转贷项目不能为空！");
                return false;
            }

            if(!(var$zdxy_no!=null&&var$zdxy_no!=undefined&&var$zdxy_no!="")){
                Ext.Msg.alert('提示', "明细中转贷协议号不能为空！");
                return false;
            }

            if(!(var$zdxy_amt!=null&&var$zdxy_amt!=undefined&&var$zdxy_amt!=""&&var$zdxy_amt!=0)){
                Ext.Msg.alert('提示', "明细中转贷协议金额（原币）不能为0！");
                return false;
            }
            zdgridvalues.push(zdrecord.data);
        }
        return zdgridvalues;
    }
    /**
     * 初始化贷款协议录入窗口
     */
    function initWindow_dkxxtb(){
        var buttons = [
            {
                text: '添加',
                hidden:true,
                id: 'zdmxAddBtn',
                handler: function (btn) {
                    var HL_RATE=Ext.ComponentQuery.query('numberfield[name="HL_RATE"]')[0].getValue();
                    $.post("/getId.action", function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //弹出弹出框，设置ID
                        var ZDMX_ID = data.data[0];
                        DSYGrid.getGrid('wzzd_grid2').insertData(null,{
                            ZDMX_ID:ZDMX_ID
                        });
                    }, "json");
                }
            },
            {
                id: 'zdmxDelBtn',
                text: '删除',
                hidden:true,
                handler: function (btn) {
                    var grid = DSYGrid.getGrid('wzzd_grid2');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }

                }
            },
            {
                text: '生成',
                id:'create',
                hidden:true,
                handler: function(btn){
                    var hkjhForm = Ext.ComponentQuery.query('form#hkjhForm')[0].getForm();
                    if (!hkjhForm.isValid()) {
                        return;
                    }
                    var START_DATE = Ext.ComponentQuery.query('datefield[name="START_DATE"]')[0].getValue();
                    var END_DATE= Ext.ComponentQuery.query('datefield[name="END_DATE"]')[0].getValue();
                    var HKZQ= parseInt(Ext.ComponentQuery.query('textfield[name="HKZQ"]')[0].getValue());
                    var CH_PERCENT= Ext.ComponentQuery.query('textfield[name="CH_PERCENT"]')[0].getValue();
                    var form = Ext.ComponentQuery.query('form#wzxy_form')[0].getForm();//找到该form
                    var WZXY_AMT = form.getValues().WZXY_AMT;
                    var detailStore = getHkjhDetail(START_DATE,END_DATE,HKZQ,CH_PERCENT,WZXY_AMT);
                    var hkjh_store = DSYGrid.getGrid('hkjhcontentGrid').getStore();
                    hkjh_store.removeAll();
                    hkjh_store.setRecords(detailStore);
                }
            },
            {
                text: '保存',
                handler: function (self) {
                    var form = self.up('window').down('form');

                    var LX_RATE = form.getForm().findField('LX_RATE').value;
                    var LXTYPE_ID = form.getForm().findField('LXTYPE_ID').value;
                    if (LXTYPE_ID == 1) {
                        if (LX_RATE == null || LX_RATE == 0) {
                            Ext.Msg.alert('提示', '请填写固定利率！');
                            return;
                        }
                        if (LX_RATE < 0) {
                            Ext.Msg.alert('提示', '固定利率必须大于0！');
                            return;
                        }
                    }
                    if (LX_RATE > 50) {
                        Ext.Msg.alert('提示', '固定利率不能大于50！');
                        return;
                    }
                    if (LXTYPE_ID == 2) {
                        var LX_FDFS = form.getForm().findField('LX_FDFS').value;
                        if (LX_FDFS == null || LX_FDFS == "") {
                            Ext.Msg.alert('提示', '请选择利率浮动方式！');
                            return;
                        }
                        var LX_FDL = form.getForm().findField('LX_FDL').value;
                        if (LX_FDL == null || LX_FDL == 0) {
                            Ext.Msg.alert('提示', '请填写利率浮动率！');
                            return;
                        }
                        if (LX_FDL < 0) {
                            Ext.Msg.alert('提示', '利率浮动率必须大于0');
                            return;
                        }
                        var LXTZ_ID = form.getForm().findField('LXTZ_ID').value;
                        if (LXTZ_ID == null || LXTZ_ID == "") {
                            Ext.Msg.alert('提示', '请选择利率调整方式！');
                            return;
                        }
                    }
                    //验证债务期限（月） 不能大于600月
                    var WZQX_ID = form.getForm().findField('WZQX_ID').value;
                    if (WZQX_ID > 600) {
                        Ext.Msg.alert('提示', '债务期限（月）不能大于600！');
                        return;
                    }

                    var WZXY_AMT = form.getForm().findField('WZXY_AMT').value;
                    if (!(WZXY_AMT > 0)) {
                        Ext.Msg.alert('提示', '协议金额（原币）必须大于0！');
                        return;
                    }

                    var WZXY_AMT_RMB = form.getForm().findField('WZXY_AMT_RMB').value;
                    if (!(WZXY_AMT_RMB > 0)) {
                        Ext.Msg.alert('提示', '协议金额（人民币）必须大于0！');
                        return;
                    }

                    var formData = form.getValues();

                    //获取还款计划数据
                    var hkjhGridStore=Ext.ComponentQuery.query('grid[itemId="hkjhcontentGrid"]')[0];
                    var store_data=new Array();
                    var grid_store=hkjhGridStore.getStore();
                    for(var i=0;i<grid_store.getCount();i++){
                        var record=grid_store.getAt(i);
                        var HKJH_DATE=record.get("HKJH_DATE");
                        var HKJH_AMT=record.get("HKJH_AMT");
                        var CH_PERCENT=record.get("CH_PERCENT");
                        if(!(CH_PERCENT!=null&&CH_PERCENT!=undefined&&CH_PERCENT!="")){
                            Ext.toast({
                                html:  "还款计划中偿还份额不能为空！" ,
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
                        Ext.MessageBox.alert('提示', '请生成还款计划！');
                        return;
                    }
                    var hkjhStore = DSYGrid.getGrid('hkjhcontentGrid').getStore();
                    var CH_PERCENT_SUM = hkjhStore.sum("CH_PERCENT");
                    var HKJH_AMT = hkjhStore.sum("HKJH_AMT");
                    CH_PERCENT_SUM=Ext.util.Format.number(CH_PERCENT_SUM,'0,000.######');
                    if(CH_PERCENT_SUM != 100){
                        Ext.MessageBox.alert('提示', '偿还份额总数为100%，请调整份额！');
                        return;
                    }
                    if(Math.abs(HKJH_AMT -(WZXY_AMT*10000))>0.01){
                        Ext.MessageBox.alert('提示', '还款金额不等于协议金额！');
                        return;
                    }
                    var START_DATE = Ext.ComponentQuery.query('datefield[name="START_DATE"]')[0].getValue();
                    var END_DATE= Ext.ComponentQuery.query('datefield[name="END_DATE"]')[0].getValue();
                    var HKZQ= Ext.ComponentQuery.query('textfield[name="HKZQ"]')[0].getValue();
                    var CH_PERCENT= Ext.ComponentQuery.query('textfield[name="CH_PERCENT"]')[0].getValue();

                    //获取转贷信息
                    var zdgridvalues = getZdxxList();
                    if(!zdgridvalues){
                        return;
                    }

                    if (form.isValid()) {
                        self.setDisabled(true);
                        $.post('saveDkxyInfo.action', {
                            detailForm: Ext.util.JSON.encode([formData]),
                            userCode: userCode,
                            nodecode: node_code,
                            wf_id: wf_id,
                            button_name:button_name,
                            DATA_ID:DATA_ID,
                            hkjhDetailList:Ext.util.JSON.encode(store_data),
                            zdxxList: Ext.util.JSON.encode(zdgridvalues),
                            START_DATE:format(START_DATE, 'yyyy-MM-dd'),
                            END_DATE:format(END_DATE, 'yyyy-MM-dd'),
                            HKZQ:HKZQ,
                            CH_PERCENT:CH_PERCENT
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: "保存成功！",
                                    closable: false,
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                self.up('window').close();
                                // 刷新表格
                                reloadGrid();
                                //self.setDisabled(false);
                            } else {
                                Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                                self.setDisabled(false);
                            }

                        }, 'JSON');
                    }
                    else{
                        Ext.MessageBox.alert('提示', '请检查必录项！' );
                    }
                }
            },
            {
                text: '取消',
                handler: function(btn){
                    btn.up('window').close() ;
                }
            }
        ] ;
        return Ext.create('Ext.window.Window',{
            title: title ,
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            maximizable: true,//最大化按钮
            border: false,
            layout: 'fit',
            itemId: 'window_dkxxtb', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是close，则会将window销毁。
            items: {
                xtype: 'tabpanel',
                items: [
                    {
                        title: '贷款明细',
                        scrollable: true,
                        layout: 'fit',
                        opstatus: 0,
                        items: [initWindow_dkxxtb_contentForm()]
                    },
                    {
                        title: '还款计划',
                        scrollable: true,
                        layout: 'fit',
                        opstatus: 1,
                        items: [initWindow_input_contentForm()]
                    },
                    {
                        title: '转贷信息',
                        scrollable: true,
                        layout: 'fit',
                        opstatus: 3,
                        hidden: true,
                        items: [initWindow_zdxx_contentForms()]
                    },
                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        layout: 'fit',
                        opstatus: 2,
                        items: [
                            {
                                xtype: 'panel',
                                layout: 'fit',
                                itemId: 'window_save_zcxx_file_panel',
                                items: [initWin_dkxyPanel_Fj()]
                            }
                        ]
                    }
                ],
                listeners: {
                    tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                        if (newCard.opstatus == 1) {
                            //如果协议金额为空，则不让生成明细
                            var form = Ext.ComponentQuery.query('form#wzxy_form')[0].getForm();//找到该form
                            var WZXY_AMT = form.getValues().WZXY_AMT;
                            if(WZXY_AMT==null || ''==WZXY_AMT){
                                Ext.Msg.alert('提示', '请填写协议金额！');
                                tabPanel.setActiveTab(oldCard);
                                return;
                            }
                            Ext.getCmp('create').setHidden(false);
                            Ext.getCmp('zdmxAddBtn').setHidden(true);
                            Ext.getCmp('zdmxDelBtn').setHidden(true);
                        }else if (newCard.opstatus == 3) {
//                            //如果协议金额为空，则不让转贷
//                            var form = Ext.ComponentQuery.query('form#wzxy_form')[0].getForm();//找到该form
//                            var WZXY_AMT = form.getValues().WZXY_AMT;
//                            if(WZXY_AMT==null || ''==WZXY_AMT){
//                                Ext.Msg.alert('提示', '请填写协议金额！');
//                                tabPanel.setActiveTab(oldCard);
//                                return;
//                            }
//                            Ext.getCmp('zdmxAddBtn').setHidden(false);
//                            Ext.getCmp('zdmxDelBtn').setHidden(false);
//                            Ext.getCmp('create').setHidden(true);
//
//                            var grid = newCard.down('grid#wzzd_grid2');
//                            if (grid.getStore().getCount() > 0) {
//                                var record = grid.getStore().getAt(0);
//                                var panel =  Ext.ComponentQuery.query('#dkxy_form')[0].down('#winPanel_tabPanel');
//                                panel.removeAll(true);
//                                panel.add(initWindow_wzzdlr_contentForm_tab_upload({
//                                    editable: true,
//                                    busiId: record.get('ZDMX_ID')
//                                }));
//                            }
                        }else{
                            Ext.getCmp('create').setHidden(true);
                            Ext.getCmp('zdmxAddBtn').setHidden(true);
                            Ext.getCmp('zdmxDelBtn').setHidden(true);
                        }
                    }
                }
            },
            buttons:buttons,
            listeners: {
                close: function () {
                    window_dkxxtb.window = null;
                }
            }
        })
    }
    /**
     * 初始化转贷信息
     */
    function initWindow_zdxx_contentForms() {
        var config = {
            editable: false,
            busiId: ''
        };
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            itemId:'dkxy_form',
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            scrollable: true,
            border: false,
            defaults: {
                width: '100%'
            },
            defaultType: 'textfield',
            items: [
                initWindow_input_contentForm_grid(),
                {
                    title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                    scrollable: true,
                    flex: 1,
                    name: 'attachment',
                    xtype: 'fieldset',
                    items: [
                        {
                            xtype: 'panel',
                            layout: 'fit',
                            itemId: 'winPanel_tabPanel',
                            border:false,
                            items: initWindow_wzzdlr_contentForm_tab_upload(config)
                        }
                    ]
                }
            ]
        });
    }
    /**
     * 初始化外债转贷表单中转贷明细信息表格
     */
    function initWindow_input_contentForm_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                dataIndex: "ZDMX_ID",
                type: "string",
                text: "转贷明细ID",
                width: 150,
                editor: {
                    xtype: "textfield",
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                hidden:true
            },
            {
                dataIndex: "AD_CODE", type: "string", text: "转贷地区", width: 200,
                renderer: function (value) {
                    var store = grid_tree_store;
                    var record = store.findRecord('CODE', value, 0, true, true, true);
                    re_value= (record != null ? record.get('TEXT') : value);
                    return re_value;
                },
                editor: {//   行政区划动态获取(下拉框)
                    xtype: 'combobox',
                    displayField: 'TEXT',
                    valueField: 'CODE',
                    editable:false,
                    store: grid_tree_store
                },
                tdCls: 'grid-cell'
            },
            {
                dataIndex: "AG_CODE", type: "string", text: "转贷单位", width: 300,
                displayField : 'text',
                editor: {//   行政区划动态获取(下拉框)
                    xtype: 'treecombobox',
                    displayField : 'text',
                    valueField : 'text',
                    selectModel: 'leaf',
                    editable:false,
                    rootVisible : false,
                    store: store_zddw
                },
                tdCls: 'grid-cell',
//                renderer: function (value) {
//                    var store = store_zddw;
//                    var record = store.findRecord('text', value, 0, true, true, true);
//                    re_value= (record != null ? record.get('text') : value);
//                    return re_value;
//                },
            },
            {
                dataIndex: "AG_ID", type: "string", text: "单位id",
                editor: {
                    xtype: "textfield",
                    editable: false
                },
                hidden:true
            },
            {
                dataIndex: "ZDXM_NAME",
                type: "string",
                text: "转贷项目",
                width: 200,
                editable:false,
                editor: {
                    xtype: 'combobox',
                    displayField: 'NAME',
                    valueField: 'NAME',
                    editable:false,
                    store:xm_tree_store
                },
                tdCls: 'grid-cell'
            },
            {
                dataIndex: "ZDXM_ID", type: "string", text: "转贷项目ID",
                editor: {
                    xtype: "textfield",
                    editable: false
                },
                hidden:true
            },
            {
                dataIndex: "ZDXY_AMT", type: "float", text: "转贷协议金额(原币)(元)", width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    allowDecimals: true,
                    decimalPrecision: 2,
                    minValue: 0,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                renderer: function (value, cellmeta, record) {
                    return Ext.util.Format.number(value, '0,000.00');
                }

            },
            {dataIndex: "ZDXY_NO", type: "string", text: "转贷协议号", width: 150,allowBlank: false,
                editor: {
                    xtype:'textfield',
                    allowBlank: false,
                },
                tdCls: 'grid-cell'
            },
            {dataIndex: "REMARK", type: "string", text: "备注", width: 150, editor: 'textfield'}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'wzzd_grid2',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            dataUrl: '/wzgl_reflct.action?method=getModfiye_cq',
            selModel: {
                mode: "SINGLE"
            },
            checkBox: true,
            border: false,
            flex: 1,
            viewConfig: {
                stripeRows: false
            },
            features: [{
                ftype: 'summary'
            }],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'wzzd_grid_plugin_cell2',
                    clicksToMoveEditor: 1
                }
            ],
            pageConfig: {
                enablePage: false
            },
            listeners: {
                'rowclick':function(self){
                    var records = DSYGrid.getGrid('wzzd_grid2').getSelection();
                    var ZDMX_ID=records[0].get('ZDMX_ID');
                    var filePanel = Ext.ComponentQuery.query('#dkxy_form')[0].down('#winPanel_tabPanel');
                    if(filePanel){
                        filePanel.removeAll();
                        filePanel.add(initWindow_wzzdlr_contentForm_tab_upload({
                            editable: true,
                            busiId: ZDMX_ID
                        }));
                    }
                },
                validateedit: function (editor, context) {
                    if(context.field == 'ZDXM_NAME') {
                            var record = xm_tree_store.findRecord('NAME', context.value, 0, false, true, true);
                            if(record!=null && record!="" ){
                                var zdxm_id=record.get("ID");
                                context.record.set('ZDXM_ID',zdxm_id);
                            }
                    }
                    if(context.field == 'AG_CODE') {
                        var record = store_zddw.findRecord('text', context.value, 0, false, true, true);
                        if(record!=null && record!="" ){
                            var AG_ID=record.get("id");
                            context.record.set('AG_ID',AG_ID);
                        }
                    }
                },
                beforeedit: function (editor,context) {
                    if(context.field=='ZDXM_NAME'){
                        var var$temp1=context.record.get('AD_CODE');
                        var var$temp2=context.record.get('AG_CODE');
                        if(var$temp1==null||var$temp1==""||var$temp1==undefined){
                            Ext.MessageBox.alert('提示', '请先选择转贷地区！');
                            return false;
                        }else if(var$temp2==null||var$temp2==""||var$temp2==undefined){
                            Ext.MessageBox.alert('提示', '请先选择转贷单位！');
                            return false;
                        }else{
                            xm_tree_store.proxy.extraParams['AG_ID']=context.record.get('AG_ID');
                            xm_tree_store.load({
                                callback: function () {
                                }
                            });
                        }
                    }
                    if(context.field=='AG_CODE'){
                        var var$temp1=context.record.get('AD_CODE');
                        if(var$temp1==null||var$temp1==""||var$temp1==undefined){
                            Ext.MessageBox.alert('提示', '请先选择转贷地区！');
                            return false;
                        }else{
                            store_zddw.proxy.extraParams['AD_CODE']=var$temp1 ;
                            store_zddw.load({
                                callback: function () {
                                }
                            });
                        }
                    }
                },
                edit:function (editor,context) {
                    //转贷地区改变时，移除转贷项目
                    if(context.field=='AD_CODE' && context.originalValue != context.value){
                        context.record.set('ZDXM_NAME',null);
                        context.record.set('AG_CODE',null);
                    }
                    if(context.field=='AG_CODE' && context.originalValue != context.value){
                        context.record.set('ZDXM_NAME',null);
                    }
                    if(context.field=='ZDXY_AMT' && context.originalValue != context.value){
                        var form = Ext.ComponentQuery.query('form#wzxy_form')[0].getForm();//找到该form
                        var WZXY_AMT = form.getValues().WZXY_AMT;
                        var store = DSYGrid.getGrid('wzzd_grid2').getStore();
                        var zd_sum = 0;
                        for(var i=0,len=store.data.length;i<len;i++){
                            var data = store.getAt(i).data;
                            zd_sum = zd_sum+data.ZDXY_AMT;
                        }
                        if(zd_sum>WZXY_AMT*10000){
                            Ext.MessageBox.alert('提示', '转贷总金额不能超过协议金额！');
                            context.record.set('ZDXY_AMT',null);
                        }
                    }
                }
            }
        });
        if (button_name == "修改") {
            grid.getStore().getProxy().extraParams['DATA_ID'] = DATA_ID;
            grid.getStore().loadPage(1);
        }
        return grid;
    }
    /**
     * 初始化协议信息填报弹出窗口中的附件标签页
     */
    function initWin_dkxyPanel_Fj() {

        var grid = UploadPanel.createGrid({
            busiType: 'WZDKXY',//业务类型
            busiId: DATA_ID,//业务ID
            busiProperty: '%',//业务规则，默认为‘%’
            editable: true,//是否可以修改附件内容，默认为ture
            gridConfig: {
                itemId: 'window_dkxxtb_contentForm_tab_xyfj_grid'
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
                $(grid.up('tabpanel').activeTab.el.dom).find('span.file_sum').html('(' + sum + ')');
            } else {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
    }
    /**
     * 初始化外债转贷录入表单中页签panel的附件页签
     */
    function initWindow_wzzdlr_contentForm_tab_upload(config) {
        var busiId=config.busiId;
        var grid = UploadPanel.createGrid({
            busiType: 'WZZDXY',//业务类型
            busiId: busiId,//业务ID
            editable: config.editable,//是否可以修改附件内容
            gridConfig: {
                itemId:'window_wzxy_wzzd'
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
            if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').activeTab.el.dom).find('span.file_sum').html('(' + sum + ')');
            } else if ($('span.file_sum')) {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;

    }

    /**
     * 初始化还款计划明细页面
     */
    function initWindow_input_contentForm() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'vbox',
            itemId:"hkjhForm",
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
                    },
                    items: [
                        {
                            xtype: 'fieldcontainer',
                            fieldLabel: '还本日期',
                            layout: 'hbox',
                            columnWidth: .39,
                            labelWidth: 90,//控件默认标签宽度
                            items: [
                                {
                                    xtype: 'datefield',
                                    name: 'START_DATE',
                                    width: document.body.clientWidth * 0.1,
                                    editable: false,
                                    allowBlank: false,
                                    format: 'Y-m-d',
                                    listeners:{
                                        'change': function (self, newValue, oldValue) {
                                            var form = self.up('form').getForm();
                                            var END_DATE = form.findField('END_DATE').value;
                                            if(END_DATE==null || END_DATE == ""||newValue==null || newValue == ""){
                                                return;
                                            }
                                            newValue = format(newValue, 'yyyy-MM-dd');
                                            END_DATE = format(END_DATE, 'yyyy-MM-dd');
                                            if(newValue>END_DATE){
                                                Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                                form.findField("START_DATE").setValue("");
                                                return;
                                            }
                                        }
                                    }
                                },
                                {
                                    xtype: 'label',
                                    text: '至',
                                    margin: '3 6 3 6'
                                },
                                {
                                    xtype: 'datefield',
                                    name: 'END_DATE',
                                    width: document.body.clientWidth * 0.1,
                                    editable: false,
                                    allowBlank: false,
                                    format: 'Y-m-d',
                                    listeners:{
                                        'change': function (self, newValue, oldValue) {
                                            var form = self.up('form').getForm();
                                            var START_DATE = form.findField('START_DATE').value;
                                            if(START_DATE==null || START_DATE == ""||newValue==null || newValue == ""){
                                                return;
                                            }
                                            START_DATE = format(START_DATE, 'yyyy-MM-dd');
                                            newValue = format(newValue, 'yyyy-MM-dd');
                                            if(newValue<START_DATE){
                                                Ext.MessageBox.alert('提示', '结束日期必须大于开始日期');
                                                form.findField("END_DATE").setValue("");
                                                return;
                                            }
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            fieldLabel: '还款周期',
                            name: 'HKZQ',
                            xtype: 'combobox',
                            editable: false,
                            displayField: 'name',
                            valueField: 'id',
                            columnWidth: .30,
                            labelWidth: 90,//控件默认标签宽度
                            store: DebtEleStoreDB("DEBT_FXZQ"),
                            allowBlank: false//不允许为空
                        },
                        {
                            fieldLabel: '偿还份额%',
                            name: 'CH_PERCENT',
                            xtype: 'numberfield',
                            editable: true,
                            mouseWheelEnabled: false,
                            minValue: 0,
                            decimalPrecision:7,
                            hideTrigger: true,
                            regex: /^\d+(\.[0-9]{1,6})?$/,
                            columnWidth: .30,
                            labelWidth: 90,//控件默认标签宽度
                            allowBlank: false//不允许为空
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    title: '还款计划明细',
                    flex: 1,
                    layout: 'fit',
                    width: document.body.clientWidth * 0.87,
                    height : document.body.clientHeight * 0.65,
                    items: [initContentTCGrid()]
                }
            ]
        });
    }

    function initContentTCGrid() {
        //表格标题
        var HeaderJson_hkjh=[
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                text: "还款日期",
                dataIndex: "HKJH_DATE",
                type: "string",
                width: 110
            },
            {
                dataIndex: "HKJH_AMT",
                type: "float",
                text: "还款计划金额",
                width: 180,
                editable: false,//禁用编辑
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            },
            {
                dataIndex: "CH_PERCENT",
                type: "float",
                text: "偿还份额%",
                width: 150,
                editor: {
                    xtype: "numberfield",
                    decimalPrecision:7,
                    regex: /^\d+(\.[0-9]{1,6})?$/,
                    hideTrigger: true,
                    mouseWheelEnabled: false,
                    minValue: 0,
                    allowBlank: false
                },
                summaryType: 'sum',
                summaryRenderer: function (value, cell) {
                    value = Ext.util.Format.number(value,'0,000.######');
                    return value;
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            }
        ];
        var hkjhcontentGrid = DSYGrid.createGrid({
            itemId: 'hkjhcontentGrid',
            headerConfig: {
                headerJson: HeaderJson_hkjh,
                columnAutoWidth: false
            },
            flex: 1,
            autoLoad: false,
            border:false,
            dataUrl: 'getHkjhInfo.action',
            height :document.body.clientHeight,
            // checkBox: true,
            pageConfig: {
                enablePage: false
            },
            features: [{
                ftype: 'summary'
            }],
            plugins: {
                ptype: 'cellediting',
                clicksToEdit: 1,
                clicksToMoveEditor: 1
            },
            listeners: {
                edit:function (editor,context) {
                    if (context.field == 'CH_PERCENT') {
                        var form = Ext.ComponentQuery.query('form#wzxy_form')[0].getForm();//找到该form
                        var WZXY_AMT = form.getValues().WZXY_AMT;
                        context.record.set("HKJH_AMT", Math.floor(WZXY_AMT*100*context.value*100)/100);
                    }
                }
            }
        });
        if (button_name == "修改") {
            hkjhcontentGrid.getStore().getProxy().extraParams['DATA_ID'] = DATA_ID;
            hkjhcontentGrid.getStore().loadPage(1);
        }
        return hkjhcontentGrid;
    }


    function getHkjhDetail(START_DATE,END_DATE,HKZQ,CH_PERCENT,WZXY_AMT) {
        var details=new Array();
        WZXY_AMT=WZXY_AMT*10000;
        if(HKZQ==0){
            var array = {};
            array.HKJH_DATE=format(END_DATE, 'yyyy-MM-dd');
            array.HKJH_AMT=WZXY_AMT;
            array.CH_PERCENT=100;
            details.push(array);
            return details;
        }
        //获取日期之间总月数
        var monthCounts = getMonths(format(START_DATE, 'yyyy-MM-dd'),format(END_DATE, 'yyyy-MM-dd'));
        //根据还款周期计算出还本计划总条数
        var  cycle = parseInt(monthCounts / parseInt(HKZQ));// 付息次数
        cycle = (monthCounts % parseInt(HKZQ) > 0) ? cycle + 1 : cycle;
        if(cycle*CH_PERCENT>100){
            Ext.MessageBox.alert('提示', '偿还份额总数大于100%！');
            return;
        }
        var fx_date = START_DATE;

        for(var i =0;i<cycle;i++){
            var array = {};
            if (i == cycle - 1) {
                fx_date = END_DATE;// 最后一个周期,利息区间截止日为到期兑付日
                array.HKJH_DATE=format(fx_date, 'yyyy-MM-dd');
                CH_PERCENT = 100-(CH_PERCENT*(cycle-1));
                array.HKJH_AMT=WZXY_AMT*(CH_PERCENT/100);
                array.CH_PERCENT=CH_PERCENT;
            } else {
                array.HKJH_DATE=format(fx_date, 'yyyy-MM-dd');
                array.HKJH_AMT=WZXY_AMT*(CH_PERCENT/100);
                array.CH_PERCENT=CH_PERCENT;
                fx_date = START_DATE.setMonth(START_DATE.getMonth() + parseInt(HKZQ));// 计算下一个周期的起始时间
            }
            details.push(array);
        }
        return details;
    }
    /**
     * 获取总月份数
     */
    function getMonths(date1 , date2){
        //用-分成数组
        date1 = date1.split("-");
        date2 = date2.split("-");
        //获取年,月数
        var year1 = parseInt(date1[0]) ,
            month1 = parseInt(date1[1]) ,
            year2 = parseInt(date2[0]) ,
            month2 = parseInt(date2[1]) ,
            //通过年,月差计算月份差
            months = (year2 - year1) * 12 + (month2-month1) + 1;
        return months;
    }

    /**
     * 初始化Form表单
     */
    function initWindow_dkxxtb_contentForm(){
        var editPanel = Ext.create('Ext.form.Panel',{
            itemId: 'wzxy_form',
            width: '100%',
            height: '100%',
            layout: 'column',
            border: false,
            defaultType: 'textfield',
            defaults: {
                margin: '2 5 2 5',
                columnWidth: .33,
                labelWidth: 125//控件默认标签宽度
            },
            items: [
                {
                    xtype: 'container',
                    columnWidth: 1,
                    layout: {
                        type: 'hbox',
                        pack: 'end'
                    },
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        readOnly: true,
                        labelWidth: 140//控件默认标签宽度
                    },
                    items: [
                        {xtype: 'label', text: '单位 : 万元', width: 80}
                    ]
                },
                {xtype: 'menuseparator', columnWidth: 1, border: true},//分割线
                {fieldLabel:'区划名称',xtype: 'displayfield',name: 'AD_NAME',value: AD_NAME,hidden:true},
                {
                    fieldLabel: '<span class="required">✶</span>主键Id',
                    xtype: "displayfield",
                    name: "DATA_ID",
                    hidden:true
                },
                {
                    fieldLabel: '<span class="required">✶</span>外债Id',
                    xtype: "displayfield",
                    name: "WZXY_ID",
                    hidden:true
                },
                /*{
                    fieldLabel: '<span class="required">✶</span>外债编码',
                    xtype: "textfield",
                    name: "WZXY_CODE",
                    allowBlank: false,
                    emptyText: '请输入...'
                },*/
                {
                    fieldLabel: '<span class="required">✶</span>外债名称',
                    xtype: "textfield",
                    name: "WZXY_NAME",
                    allowBlank: false,
                    emptyText: '请输入...',
                    vtype: 'vTszf' //自定义校验
                },
                {
                    fieldLabel: '<span class="required">✶</span>债务类别',
                    xtype: 'treecombobox',
                    name: 'ZWLB_ID',
                    displayField: 'name',
                    allowBlank: false,
                    valueField: 'id',
                    rootVisible: false,
                    lines: false,
                    editable: false, //禁用编辑
                    maxPicekerWidth: '100%',
                    selectModel: 'leaf',
                    store: DebtEleTreeStoreDB('DEBT_ZWLX',{condition: "AND CODE IN ('01','0101','02','0201')"})
                },
                {
                    fieldLabel: '<span class="required">✶</span>签订日期',
                    xtype: "datefield", name: "SIGN_DATE", allowBlank: false,
                    format: 'Y-m-d', blankText: '请选择开始日期', emptyText: '请选择开始日期', value: new Date(),
                    listeners: {
                        'change': function (self, newValue, oldValue) {

                        }
                    }
                },
                {
                    xtype: "numberfield",
                    name: "WZQX_ID",
                    fieldLabel: '<span class="required">✶</span>外债期限（月）',
                    minValue: 0,
                    allowDecimals: true,
                    decimalPrecision: 0,
                    hideTrigger: true,
                    keyNavEnabled: true,
                    allowBlank: false,
                    mouseWheelEnabled: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                {
                    xtype: "treecombobox",
                    name: "ZQFL_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZQLX', {condition: zqfl_condition}),
                    fieldLabel: '<span class="required">✶</span>债权类型',
                    displayField: 'name',
                    valueField: 'id',
                    rootVisible: false,
                    allowBlank: false,
                    lines: false,
                    editable: false, //禁用编辑
                    selectModel: 'leaf',
                    listeners: {
                        'change': function (self, newValue, oldValue) {

                        }
                    }
                },
                {
                    xtype: 'treecombobox',
                    fieldLabel: '<span class="required">✶</span>债权人',
                    name: 'ZQR_ID',
                    displayField: 'name',
                    valueField: 'id',
                    rootVisible: false,
                    lines: false,
                    allowBlank: false,
                    editable: false, //禁用编辑
                    selectModel: 'leaf',
                    store: zqr_store
                },
                {
                    xtype: "textfield",
                    fieldLabel: '<span class="required">✶</span>债权人全称',
                    allowBlank: false,
                    name: "ZQR_FULLNAME",
                    emptyText: '请输入...',
                    validator: vd
                },
                {
                    xtype: "textfield",
                    fieldLabel: '<span class="required">✶</span>协议号',
                    name: "WZXY_NO",
                    allowBlank: false,
                    emptyText: '请输入...',
                    //validator: vd
                },
                {
                    xtype: 'treecombobox',
                    fieldLabel: '<span class="required">✶</span>资金用途',
                    name: 'ZJYT_ID',
                    displayField: 'name',
                    valueField: 'id',
                    rootVisible: false,
                    lines: false,
                    allowBlank: false,
                    editable: false, //禁用编辑
                    selectModel: 'leaf',
                    store:DebtEleTreeStoreJSON(json_debt_zwzjyt1),
                    listeners: {
                        'select': function () {

                        }
                    }
                },
                {
                    fieldLabel: '<span class="required">✶</span>建设项目',
                    xtype: 'combobox',
                    name: 'SJXM_ID',
                    displayField: 'name',
                    valueField: 'id',
                    disabled: false,
                    editable: false,
                    allowBlank: false,//不允许为空
                    //store: DebtEleStoreDB("DEBT_SJXM", {condition: sjxm_condition})
                    store: getSjxmStore({AD_CODE:ADCODE})
                },
                {
                    xtype: "numberFieldFormat",
                    name: "WZXY_AMT",
                    fieldLabel: '<span class="required">✶</span>协议金额（原币）',
                    emptyText: '0.00',
                    allowBlank:false,
                    allowDecimals: true,
                    decimalPrecision: 2,
                    hideTrigger: true,
                    keyNavEnabled: true,
                    mouseWheelEnabled: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    listeners: {
                        /**
                         * 协议金额（原币）变动,自动计算协议金额（人民币）
                         */
                        'change': function (self, newValue, oldValue) {
                            var form = this.up('form').getForm();
                            var HL_RATE = form.findField('HL_RATE').value;
                            var WZXY_AMT = form.findField('WZXY_AMT').getValue();
                            var WZXY_AMT_RMB = form.findField('WZXY_AMT_RMB');
                            WZXY_AMT_RMB.setValue(HL_RATE * WZXY_AMT);
                        }
                    }
                },
                {
                    xtype: "combobox",
                    name: "FM_ID",
                    store: DebtEleStore(json_debt_wb),
                    displayField: "name",
                    valueField: "id",
                    value: 'CNY',
                    fieldLabel: true ? '<span class="required">✶</span>原币币种' : '<span class="required">✶</span>币种',
                    allowBlank: false,
                    editable: false, //禁用编辑
                    listeners: {
                        /**
                         * 币种select事件：
                         * 1.当币种为人民币时，汇率默认为1且不可编辑
                         * 2.当币种为非人民币时，汇率初始为0，可编辑
                         */
                        'change': function (self, newValue, oldValue) {
                            var FM_ID = this.up('form').getForm().findField('FM_ID');
                            var result = rateStore.findRecord('code', FM_ID.value, 0, false, true, true);
                            if (result != null) {
                                this.up('form').getForm().findField('HL_RATE').setValue(result.get('roe'));
                            } else {
                                this.up('form').getForm().findField('HL_RATE').setValue(0.000000);
                            }
                            if(FM_ID.value=='CNY'){
                                this.up('form').getForm().findField('HL_RATE').setReadOnly(true);
                            }else{
                                this.up('form').getForm().findField('HL_RATE').setReadOnly(false);
                            }
                        }
                    }
                },
                {
                    xtype: "numberfield",
                    name: "HL_RATE",
                    fieldLabel: '<span class="required">✶</span>汇率',
                    value: 1.000000,
                    readOnly: true,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    hideTrigger: true,
                    minValue:0,
                    keyNavEnabled: true,
                    mouseWheelEnabled: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    listeners: {
                        /**
                         * 汇率变动,自动计算协议金额（人民币）
                         */
                        'change': function (self, newValue, oldValue) {
                            var form = this.up('form').getForm();
                            var HL_RATE = form.findField('HL_RATE').value;
                            var WZXY_AMT = form.findField('WZXY_AMT').getValue();
                            var WZXY_AMT_RMB = form.findField('WZXY_AMT_RMB');
                            WZXY_AMT_RMB.setValue(HL_RATE * WZXY_AMT);
                        }
                    }
                },
                {
                    xtype: "numberFieldFormat",
                    name: "WZXY_AMT_RMB",
                    fieldLabel: "协议金额（人民币）",
                    emptyText: '0.00',
                    allowDecimals: true,
                    decimalPrecision: 2,
                    hideTrigger: true,
                    readOnly: true,
                    keyNavEnabled: true,
                    mouseWheelEnabled: true,
                    fieldStyle: 'background:#E6E6E6',
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                {xtype: 'menuseparator', columnWidth: 1, border: true},//分割线
                {
                    xtype: "combobox",
                    name: "LXTYPE_ID",
                    store: DebtEleStore(json_debt_jzlllx),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<span class="required">✶</span>利率类型',
                    allowBlank: false,
                    editable: false, //禁用编辑
                    listeners: {
                        /**
                         * 利率类型select事件：
                         * 1.利率类型为固定利率时：固定利率（%）可编辑，利率调整方式、利率调整月份、日期、利率浮动方式、利率浮动率不可用（置灰）
                         * 2.利率类型为固定利率时：固定利率（%）、利率调整月份、日期、利率浮动方式不可用（置灰），利率调整方式、利率浮动率可编辑
                         */
                        'change': function (self, newValue, oldValue) {
                            var LXTYPE_ID = this.up('form').getForm().findField('LXTYPE_ID');
                            if (LXTYPE_ID.value == '1') {
                                this.up('form').getForm().findField('LXTZ_ID').disable();
                                this.up('form').getForm().findField('LXTZ_MO').disable();
                                this.up('form').getForm().findField('LXTZ_DATE').disable();
                                this.up('form').getForm().findField('LX_FDFS').disable();
                                this.up('form').getForm().findField('LX_FDL').disable();
                                this.up('form').getForm().findField('LXTZ_ID').setValue('');
                                this.up('form').getForm().findField('LXTZ_MO').setValue('');
                                this.up('form').getForm().findField('LXTZ_DATE').setValue('');
                                this.up('form').getForm().findField('LX_FDFS').setValue('');
                                this.up('form').getForm().findField('LX_FDL').setValue('');
                                //启用固定利率
                                this.up('form').getForm().findField('LX_RATE').setValue('');
                                this.up('form').getForm().findField('LX_RATE').enable();
                            } else if (LXTYPE_ID.value == '2') {
                                this.up('form').getForm().findField('LXTZ_ID').enable();
                                this.up('form').getForm().findField('LXTZ_MO').enable();
                                this.up('form').getForm().findField('LXTZ_DATE').enable();
                                this.up('form').getForm().findField('LX_FDFS').enable();
                                this.up('form').getForm().findField('LX_FDL').enable();
                                //固定利率不可用
                                this.up('form').getForm().findField('LX_RATE').setValue('');
                                this.up('form').getForm().findField('LX_RATE').disable();
                            } else if (LXTYPE_ID.value == '99') {
                                this.up('form').getForm().findField('LXTZ_ID').disable();
                                this.up('form').getForm().findField('LXTZ_MO').disable();
                                this.up('form').getForm().findField('LXTZ_DATE').disable();
                                this.up('form').getForm().findField('LX_FDFS').disable();
                                this.up('form').getForm().findField('LX_FDL').disable();
                                this.up('form').getForm().findField('LXTZ_ID').setValue('');
                                this.up('form').getForm().findField('LXTZ_MO').setValue('');
                                this.up('form').getForm().findField('LXTZ_DATE').setValue('');
                                this.up('form').getForm().findField('LX_FDFS').setValue('');
                                this.up('form').getForm().findField('LX_FDL').setValue('');
                                //启用固定利率
                                this.up('form').getForm().findField('LX_RATE').setValue('');
                                this.up('form').getForm().findField('LX_RATE').disable();
                            }
                        }
                    }
                },
                {
                    xtype: "numberFieldFormat",
                    name: "LX_RATE",
                    fieldLabel: "固定利率（%）",
                    emptyText: '0.0000',
                    allowDecimals: true,
                    decimalPrecision: 6,
                    hideTrigger: true,
                    keyNavEnabled: true,
                    mouseWheelEnabled: true,
                    minValue: 0
                },
                {
                    fieldLabel: "利率浮动方式",
                    xtype: "combobox",
                    name: "LX_FDFS",
                    editable: false, //禁用编辑
                    store: DebtEleStore(json_debt_llfdfs),
                    displayField: "name",
                    valueField: "id"
                },
                {
                    xtype: "numberFieldFormat",
                    fieldLabel: "利率浮动率（%）",
                    name: "LX_FDL",
                    emptyText: '0.0000',
                    allowDecimals: true,
                    //editable: false, //禁用编辑
                    decimalPrecision: 6,
                    hideTrigger: true,
                    keyNavEnabled: true,
                    mouseWheelEnabled: true
                },
                {
                    xtype: "combobox",
                    name: "LXTZ_ID",
                    store: DebtEleStore(json_debt_lltzfs),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: "利率调整方式",
                    editable: false, //禁用编辑
                    listeners: {
                        /**
                         * 利率调整方式select事件：根据利率调整方式不同动态切换利率调整月份的store并控制月份与日期控件是否可用
                         */
                        'change': function (self, newValue, oldValue) {
                            var LXTZ_ID = this.up('form').getForm().findField('LXTZ_ID');
                            var LXTZ_MO = this.up('form').getForm().findField('LXTZ_MO');
                            var LXTZ_DATE = this.up('form').getForm().findField('LXTZ_DATE');
                            if (LXTZ_ID.value == '1') {
                                LXTZ_MO.enable();
                                LXTZ_DATE.enable();
                                LXTZ_MO.bindStore(DebtEleStore(json_debt_yf_nd));
                                LXTZ_MO.setValue('01');
                                LXTZ_DATE.setValue('01');
                            } else if (LXTZ_ID.value == '2') {
                                LXTZ_MO.enable();
                                LXTZ_DATE.enable();
                                LXTZ_MO.bindStore(DebtEleStore(json_debt_yf_bn));
                                LXTZ_MO.setValue('01');
                                LXTZ_DATE.setValue('01');
                            } else if (LXTZ_ID.value == '3') {
                                LXTZ_MO.enable();
                                LXTZ_DATE.enable();
                                LXTZ_MO.bindStore(DebtEleStore(json_debt_yf_jd));
                                LXTZ_MO.setValue('01');
                                LXTZ_DATE.setValue('01');
                            } else if (LXTZ_ID.value == '4') {
                                LXTZ_MO.disable();
                                LXTZ_DATE.enable();
                                LXTZ_MO.setValue('');
                                LXTZ_DATE.setValue('01');
                            } else {
                                LXTZ_MO.disable();
                                LXTZ_DATE.disable();
                                LXTZ_MO.setValue('');
                                LXTZ_DATE.setValue('');
                            }
                        }
                    }
                },
                {
                    xtype: 'fieldcontainer',
                    layout: 'hbox',
                    defaultType: 'textfield',
                    items: [
                        {
                            xtype: "combobox",
                            name: "LXTZ_MO",
                            margin: '0 5 0 0',
                            fieldLabel: "利息调整月日",
                            labelWidth: 125,
                            flex:3,
                            store: DebtEleStore(json_debt_yf_nd),
                            displayField: "name",
                            valueField: "id",
                            editable: false, //禁用编辑
                            listeners: {
                                'change': function (self, newValue, oldValue) {
                                }
                            }
                        },
                        {
                            xtype: "combobox",
                            name: "LXTZ_DATE",
                            margin: '0 0 0 5',
                            store: DebtEleStore(json_debt_day),
                            displayField: "name",
                            flex:1,
                            valueField: "id",
                            editable: false, //禁用编辑
                            listeners: {
                                'change': function (self, newValue, oldValue) {
                                }
                            }
                        }
                    ]
                },
                {
                    xtype: "combobox",
                    name: "JSFS_ID",
                    store: DebtEleStore(json_debt_jxfs),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: "结息方式",
                    allowBlank: false,
                    editable: false, //禁用编辑
                    value: '1',
                    listeners: {
                        /**
                         * 结息方式select事件：根据结息方式不同动态切换结息调整月份的store并控制月份与日期控件是否可用
                         */
                        'change': function (self, newValue, oldValue) {
                            var JSFS_ID = this.up('form').getForm().findField('JSFS_ID');
                            var JXRQ_MO = this.up('form').getForm().findField('JXRQ_MO');
                            var JXRQ_DATE = this.up('form').getForm().findField('JXRQ_DATE');
                            if (JSFS_ID.value == '1') {
                                JXRQ_MO.enable();
                                JXRQ_DATE.enable();
                                JXRQ_MO.bindStore(DebtEleStore(json_debt_yf_nd));
                                JXRQ_MO.setValue('01');
                                JXRQ_DATE.setValue('20');
                            } else if (JSFS_ID.value == '2') {
                                JXRQ_MO.enable();
                                JXRQ_DATE.enable();
                                JXRQ_MO.bindStore(DebtEleStore(json_debt_yf_bn));
                                JXRQ_MO.setValue('01');
                                JXRQ_DATE.setValue('1');
                            } else if (JSFS_ID.value == '3') {
                                JXRQ_MO.enable();
                                JXRQ_DATE.enable();
                                JXRQ_MO.bindStore(DebtEleStore(json_debt_yf_jd));
                                JXRQ_MO.setValue('01');
                                JXRQ_DATE.setValue('1');
                            } else if (JSFS_ID.value == '4') {
                                JXRQ_MO.disable();
                                JXRQ_DATE.enable();
                                JXRQ_MO.setValue('');
                                JXRQ_DATE.setValue('1');
                            } else {
                                JXRQ_MO.disable();
                                JXRQ_DATE.disable();
                                JXRQ_MO.setValue('');
                                JXRQ_DATE.setValue('');
                            }
                        }
                    }
                },
                {
                    xtype: 'fieldcontainer',
                    layout: 'hbox',
                    fieldLabel: "结息月日",
                    defaultType: 'textfield',
                    defaults: {
                        flex: 1
                    },
                    items: [
                        {
                            xtype: "combobox",
                            name: "JXRQ_MO",
                            margin: '0 5 0 0',
                            store: DebtEleStore(json_debt_yf_nd),
                            displayField: "name",
                            allowBlank: false,
                            valueField: "id",
                            editable: false, //禁用编辑
                            value: month,
                            listeners: {
                                'change': function (self, newValue, oldValue) {
                                }
                            }
                        },
                        {
                            xtype: "combobox",
                            name: "JXRQ_DATE",
                            margin: '0 0 0 5',
                            store: DebtEleStore(json_debt_day),
                            displayField: "name",
                            allowBlank: false,
                            valueField: "id",
                            editable: false, //禁用编辑
                            value: '20',
                            listeners: {
                                'change': function (self, newValue, oldValue) {
                                }
                            }
                        }
                    ]
                },
                {

                    xtype: "combobox",
                    name: "IS_LSBQ",
                    store: DebtEleStore(json_debt_sf),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<span class="required">✶</span>利随本清',
                    allowBlank: false,
                    editable: false,
                    value: '1'
                },
                {fieldLabel: '备注', xtype: "textfield", columnWidth: .99, name: "REMARK"},
                {xtype: 'menuseparator', columnWidth: 1, border: true},//分割线
                {
                    xtype: "treecombobox",
                    name: "ZXCS_ID",
                    store: DebtEleTreeStoreDB('DEBT_JJFS'),
                    fieldLabel: '<span class="required">✶</span>增信措施',
                    displayField: 'name',
                    allowBlank: false,
                    valueField: 'id',
                    rootVisible: false,
                    lines: false,
                    editable: false, //禁用编辑
                    selectModel: 'leaf',
                    listeners: {
                        'change': function (self, newValue, oldValue) {
                        }
                    }
                },
                /*{
                    fieldLabel: "是否清理甄别认定债务",
                    xtype: "combobox",
                    name: "IS_QLZB",
                    store: DebtEleStore(json_debt_sf),
                    displayField: "name",
                    valueField: "id",
                    disabled: true,
                    labelWidth: 150,//控件默认标签宽度
                    value: "0"
                },*/
                {fieldLabel: '基准年利率', xtype: "textfield", name: "DQ_RATE", emptyText: '0.0000', fieldStyle: 'background:#B0F769', readOnly: true}
            ]
        }) ;
        if (button_name == "修改") {
            loadInfo(editPanel);
        }
        return editPanel ;
    }
    /**
     * 初始化协议信息填报弹出窗口中的附件标签页
     */
    function initWin_dkxyPanel_Fj() {

        var grid = UploadPanel.createGrid({
            busiType: 'WZDKXY',//业务类型
            busiId: DATA_ID,//业务ID
            busiProperty: '%',//业务规则，默认为‘%’
            editable: true,//是否可以修改附件内容，默认为ture
            gridConfig: {
                itemId: 'window_dkxxtb_contentForm_tab_xyfj_grid'
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

   /*加载协议信息*/
    function loadInfo(form) {
        form.load({
            url: 'getDkxyDetail.action?DATA_ID=' + DATA_ID,
            waitTitle: '请等待',
            waitMsg: '正在加载中...',
            success: function (form_success, action) {
                loadDqlx("");
                //initWidget(form);
            },
            failure: function (form, action) {
                alert('加载失败');
            }
        });
    };
    /*刷新界面*/
    function reloadGrid() {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        store.removeAll();
        //刷新
        store.loadPage(1);
    };
    //获取基准年利率
    function loadDqlx(sign_date) {
        $.post("getDqlx.action?SIGN_DATE=" + sign_date, function (data) {
            //弹出弹出框，设置主表id
            var dqlx = data.data[0].DQ_RATE;
            Ext.ComponentQuery.query('textfield[name="DQ_RATE"]')[0].setValue(dqlx);
        }, "json");
    }

    /*查看操作记录*/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
            return;
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
            return;
        } else {
            DATA_ID = records[0].get("DATA_ID");
            fuc_getWorkFlowLog(DATA_ID);
        }
    }

    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("DATA_ID"));
        }
        button_name = btn.text;
        if (button_name == '送审') {
            Ext.Msg.confirm('提示', '请确认是否送审！' , function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("/updateDkxyNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: '',
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({html: button_name + "成功！"});
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }
                        //刷新表格
                        reloadGrid();
                    }, "json");
                }
            });
        } else {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text + "意见",
                animateTarget: btn,
                value: btn.name == 'up' ? null : '同意',
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("/updateDkxyNode.action", {
                            workflow_direction: btn.name,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            audit_info: text,
                            ids: ids
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({html: button_name + "成功！"});
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

    function getSjxmStore(filterParam){
        var sjxmDataStore = Ext.create('Ext.data.Store', {
            model: 'sjxmModel',
            proxy: {
                type: 'ajax',
                method: 'POST',
                url: "/getSjxmData.action",
                reader: {
                    type: 'json'
                },
                extraParams:filterParam
            },
            autoLoad: true
        });
        return sjxmDataStore;
    }
</script>
</body>
</html>
