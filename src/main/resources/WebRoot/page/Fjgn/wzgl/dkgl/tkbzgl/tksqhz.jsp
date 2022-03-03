<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2017/11/1
  Time: 10:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>提款报账汇总申报/审核</title>
    <style type="text/css">
        .x-grid-back-green {
            background: #00ff00;
        }
    </style>
</head>
<body>
    <div id="contentPanel" style="width: 100%;height:100%;"></div>
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript">
        var wf_id = "${fns:getParamValue('wf_id')}";//当前工作流id
        var menucode = "${fns:getParamValue('menucode')}";
        var button_name="";
        var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";
        if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
            WF_STATUS = '001';
        }
        var AD_CODE='${sessionScope.ADCODE}'.replace(/00$/, "");
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
         * 通用json配置
         */
        var hzsb_json_common = {
            items:{
                '001' :[
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
                        text: '汇总',
                        icon: '/image/sysbutton/sum.png',
                        handler: function (btn) {
                            button_name=btn.text;
                            var records = DSYGrid.getGrid('hzsbcontentGrid').getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                                return false;
                            }
                            var wzxy_id= null;
                            var sjxm_id= null;
                            var sqfm_id= null;
                            // 验证数据是否符合汇总要求，包括wzxy_id,sjxm_id和sqfm_id
                            for (var i in records) {
                                if (wzxy_id == null) {
                                    wzxy_id = (records[i].get('WZXY_ID'));
                                } else if (wzxy_id != (records[i].get('WZXY_ID'))) {
                                    Ext.MessageBox.alert('提示', '汇总数据必须是同一外债！');
                                    return false;
                                }
                                if (sjxm_id == null) {
                                    sjxm_id = (records[i].get('SJXM_ID'));
                                } else if (sjxm_id != (records[i].get('SJXM_ID'))) {
                                    Ext.MessageBox.alert('提示', '汇总数据必须是同一上级项目！');
                                    return false;
                                }
                                if (sqfm_id == null) {
                                    sqfm_id = (records[i].get('SQFM_ID'));
                                } else if (sqfm_id != (records[i].get('SQFM_ID'))) {
                                    Ext.MessageBox.alert('提示', '汇总数据必须是同一支付币种！');
                                    return false;
                                }
                            }
                            initAccountContent(sjxm_id);
                        },
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()],
                '002' :[
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
                        text: '撤销汇总',
                        icon: '/image/sysbutton/undosum.png',
                        handler: function (btn) {
                            button_name=btn.text;
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                                return;
                            }
                            Ext.Msg.confirm('提示', '请确认是否撤销！', function (btn_confirm) {

                                if (btn_confirm == 'yes') {
                                    var ids = [];
                                    for (var i in records) {
                                        ids.push(records[i].get("TKHZ_ID"));
                                    }
                                    $.post('delYhzInfo.action', {
                                        ids:ids,
                                        wf_status: WF_STATUS,
                                        wf_id: wf_id,
                                        menucode:menucode,
                                        button_name:button_name
                                    }, function (data) {
                                        if (data.success) {
                                            Ext.toast({
                                                html: "撤销成功！" + (data.message ? data.message : ''),
                                                closable: false, align: 't', slideInDuration: 400, minWidth: 400
                                            });
                                        } else {
                                            Ext.MessageBox.alert('提示', '撤销失败！' + (data.message ? data.message : ''));
                                        }
                                        reloadGrid();
                                    }, 'json');
                                }
                            });

                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ]
            }
        };
        /**
         * 未汇总表单
         */
        var HeaderJson_hzsb=[
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                dataIndex:"WF_ID",
                type:"string",
                text:"工作流id",
                hidden:true
            },
            {
                dataIndex:"NODE_CURRENT_ID",
                type:"string",
                text:"当前节点",
                hidden:true
            },
            {
                dataIndex:"TKBZ_ID",
                type:"string",
                text:"提款报账单ID",
                hidden:true
            },
            {
                dataIndex:"AG_ID",
                type:"string",
                text:"单位ID",
                hidden:true
            },
            {
                dataIndex:"AG_NAME",
                type:"string",
                width: 240,
                text:"单位名称"
            },
            {
                dataIndex:"WZXY_ID",
                type:"string",
                text:"外债协议ID",
                hidden:true
            },
            {
                dataIndex:"WZXY_NAME",
                type:"string",
                width: 240,
                text:"外债名称"
            },
            {
                dataIndex:"XM_ID",
                type:"string",
                text:"项目ID",
                hidden:true
            },
            {
                dataIndex:"XM_NAME",
                type:"string",
                width: 240,
                text:"项目名称",
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
                dataIndex:"SJXM_ID",
                type:"string",
                text:"上级项目ID",
                hidden:true
            },
            {
                dataIndex:"TKBZ_CODE",
                type:"string",
                text:"申请单号",
                width: 240,
            },
            {
                dataIndex:"SQTK_AMT",
                type:"float",
                width: 180,
                text:"申请提款金额（万元）",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000##');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000##');
                }
            },
            {
                dataIndex:"SQFM_ID",
                type:"string",
                width: 130,
                text:"申请支付币种",
            },
            {
                dataIndex:"SQDZ_DATE",
                type:"string",
                width: 180,
                text:"申请到账日期",

            },
            {
                dataIndex:"SQ_DATE",
                type:"string",
                width: 150,
                text:"申请日期",
            },
            {
                dataIndex:"ZH_NAME",
                type:"string",
                width: 180,
                text:"收款人",
            },
            {
                dataIndex:"ACCOUNT",
                type:"string",
                width: 240,
                text:"账号",
            },
            {
                dataIndex:"ZH_BANK",
                type:"string",
                width: 180,
                text:"开户行",
            },
            {
                dataIndex:"REMARK",
                type:"string",
                width: 240,
                text:"备注",
            }
        ];
        /**
        * 已汇总主表单
        * */
        var HeaderJson_hzsb1=[
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                dataIndex:"TKHZ_ID",
                type:"string",
                text:"外债协议ID",
                hidden:true
            },
            {
                dataIndex:"WZXY_ID",
                type:"string",
                text:"外债协议ID",
                hidden:true
            },
            {
                dataIndex:"WZXY_NAME",
                type:"string",
                width: 240,
                text:"外债名称"
            },
            {
                dataIndex:"SJXM_ID",
                type:"string",
                text:"上级项目ID",
                hidden:true
            },
            {
                dataIndex:"SJXM_NAME",
                type:"string",
                width: 240,
                text:"项目名称"
            },
            {
                text: '债务类型',
                dataIndex: 'XMFL',
                type: "string",
                renderer: function (value) {
                    var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
                    return result != null ? result.get('name') : value;
                }
            },
            {
                dataIndex:"SJXM_ID",
                type:"string",
                text:"上级项目ID",
                hidden:true
            },
            {
                dataIndex:"SQTK_HJ_AMT",
                type:"float",
                width: 180,
                text:"申请提款金额（万元）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000##');
                }/*,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000##');
                }*/
            },
            {
                dataIndex:"HZ_DATE",
                type:"string",
                width: 150,
                text:"汇总日期",
            },
            {
                dataIndex:"ZH_NAME",
                type:"string",
                width: 180,
                text:"收款人",
            },
            {
                dataIndex:"ACCOUNT",
                type:"string",
                width: 240,
                text:"账号",
            },
            {
                dataIndex:"ZH_BANK",
                type:"string",
                width: 180,
                text:"开户行",
            },

        ];
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
        function store_account(sjxm_id){
            var store = Ext.create('Ext.data.Store', {
                model: 'accountModel',
                proxy: {
                    type: 'ajax',
                    method: 'POST',
                    url: "/getAccountInfo.action",
                    reader: {
                        type: 'json'
                    },
                    extraParams:{
                        adcode : AD_CODE,
                        sjxm_id : sjxm_id,
                    }
                },
                autoLoad: true
            });
            return store;
        }



        /**
         * 初始化
         */
        $(document).ready(function () {
            //显示提示，并form表单提示位置为表单项下方
            Ext.QuickTips.init();
            Ext.form.Field.prototype.msgTarget = 'side';
            initContent();
            if (hzsb_json_common.callBack) {
                hzsb_json_common.callBack();
            }
        });
        /**
         * 初始化页面区域
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
                border:false,
                dockedItems: [
                    {
                        xtype: 'toolbar',
                        dock: 'top',
                        itemId: 'contentPanel_toolbar',
                        items: hzsb_json_common.items[WF_STATUS]
                    }
                ],
                items:initContentGridHZ()
            });
            reloadGrid();
        }
        /**
         * 初始化主表格
         */
        function initContentGridHZ() {
            return Ext.create('Ext.tab.Panel', {
                name: 'HzTabPanel',
                layout: 'fit',
                flex: 1,
                border: false,
                defaults: {
                    layout: 'fit',
                    border: false
                },
                items: [
                    {title: '未汇总', opstatus: 0, items:[initContentGrid() ]},
                    {title: '已汇总', opstatus: 1, layout: 'vbox', items: [initContentHZGrid(), initContentGrid_detail()]}
                ],
                listeners: {
                    tabchange: function (tabPanel, newCard) {
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        if (newCard.opstatus == '0') {
                            WF_STATUS = '001';
                        } else if (newCard.opstatus == '1') {
                            WF_STATUS = '002';
                        }
                        toolbar.add(hzsb_json_common.items[WF_STATUS]);
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams["wf_status"] = WF_STATUS;
                        reloadGrid();
                    }
                }
            });
        }
        /**
         * 未汇总主表格
         */
        function initContentGrid() {
            //表格标题
            return DSYGrid.createGrid({
                itemId: 'hzsbcontentGrid',
                headerConfig: {
                    headerJson: HeaderJson_hzsb,
                    columnAutoWidth: false
                },
                params: {
                    wf_status: WF_STATUS,
                    wf_id: wf_id
                },
                dataUrl: 'getWhzInfo.action',
                flex: 1,
                autoLoad: false,
                border:false,
                height: '100%',
                plugins: [
                    {
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        pluginId: 'cellEdit',
                        clicksToMoveEditor: 1,
                    }
                ],
                checkBox: true,
                features: [{
                    ftype: 'summary'
                }],
                pageConfig: {
                    pageNum: true,//设置显示每页条数}
                },
                tbar:[
                    {
                        xtype: 'displayfield',
                        editable: false,
                        fieldLabel: '汇总金额合计(万元):',
                        labelWidth: 155,
                        itemId:'hbje_sum',
                        hidden:true
                    }
                ],
                listeners: {
                    selectionchange: function (view, records) {
                        var sum1 = 0;
                        for (var i in records) {
                            sum1 += records[i].get("SQTK_AMT");
                        }
                        sum1 = Ext.util.Format.number(sum1, '0,000.0000');
                        Ext.ComponentQuery.query('displayfield#hbje_sum')[0].setValue(sum1);
                    }
                }
            })
        }

        /**
        选择收款账户弹出框
         */
        function initAccountContent(sjxm_id) {
            var store_accounts=store_account(sjxm_id);
            Ext.create('Ext.window.Window', {
                itemId: 'window_skzh', // 窗口标识
                title: '请选择收款账户', // 窗口标题
                width: 400, //自适应窗口宽度
                height: 200, //自适应窗口高度
                layout: {
                    type: 'column',
                    padding: '10',
                    align: 'middle'
                },
                buttonAlign: 'center', // 按钮显示的位置
                modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
                closeAction: 'destroy',
                items: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '收款账户',
                        name: 'ZH_NAME',
                        displayField: 'name',
                        valueField: 'id',
                        editable: false,
                        allowBlank: false,
                        flex: 1,
                        width: 300,
                        autoLoad: false,
                        margin:'10 0 0 10',
                        labelWidth: 60,//控件默认标签宽度
                        labelAlign: 'right',//控件默认标签对齐方式
                        store: store_accounts,
                        listeners:{
                            'select': function (combo, record, index) {
                               var ss=record.get('id');
                               var account_value=store_accounts.findRecord('ZJZH_ID', ss, false, true, true);
                               if(account_value!=null&&account_value!=undefined){
                                   Ext.ComponentQuery.query('textfield[name="ACCOUNT"]')[0].setValue(account_value.get('ACCOUNT'));
                                   Ext.ComponentQuery.query('textfield[name="ZH_BANK"]')[0].setValue(account_value.get('ZH_BANK'));
                               }
                            }
                        }

                    },
                    {
                        xtype: 'textfield',
                        fieldLabel: '账号',
                        name: 'ACCOUNT',
                        editable: false,
                        width: 300,
                        autoLoad: false,
                        margin:'10 0 0 10',
                        labelWidth: 60,//控件默认标签宽度
                        labelAlign: 'right',//控件默认标签对齐方式
                    },
                    {
                        xtype: 'textfield',
                        fieldLabel: '开户行',
                        name: 'ZH_BANK',
                        editable: false,
                        width: 300,
                        autoLoad: false,
                        margin:'10 0 0 10',
                        labelWidth: 60,//控件默认标签宽度
                        labelAlign: 'right',//控件默认标签对齐方式
                    }
                ],
                buttons: [
                    {
                        text: '确认',
                        handler: function (btn) {

                            var zh_id = btn.up('window').down('combobox[name=ZH_NAME]').getValue();
                            var zh_name = btn.up('window').down('combobox[name=ZH_NAME]').getRawValue();
                            if (zh_id == null || zh_id == '') {
                                Ext.Msg.alert('提示', "请选择收款账户信息");
                                return false;
                            }
                            btn.setDisabled(true);
                            var zh_account = btn.up('window').down('textfield[name=ACCOUNT]').getValue();
                            var zh_bank = btn.up('window').down('textfield[name=ZH_BANK]').getValue();
                            var records = DSYGrid.getGrid('hzsbcontentGrid').getSelectionModel().getSelection();
                            var wzxy_id=records[0].get("WZXY_ID");
                            var sjxm_id=records[0].get("SJXM_ID");
                            var sqfm_id=records[0].get("SQFM_ID");
                            var wf_mxid=records[0].get("WF_ID");
                            var node_current_id=records[0].get("NODE_CURRENT_ID");
                            var ids = [];
                            for (var i in records) {
                                ids.push(records[i].get("TKBZ_ID"));
                            }
                            var apply_amount = Ext.ComponentQuery.query('displayfield#hbje_sum')[0].getValue().replaceAll(',', '');
                            apply_amount = parseFloat(apply_amount) * 10000;
                            //发送请求新增汇总单信息，并修改明细表状态信息
                            $.post('saveWhzInfo.action', {
                                ids:Ext.util.JSON.encode(ids),
                                apply_amount:apply_amount,
                                zh_name:zh_name,
                                zh_account:zh_account,
                                zh_bank:zh_bank,
                                wzxy_id:wzxy_id,
                                sjxm_id:sjxm_id,
                                sqfm_id:sqfm_id,
                                button_name:button_name,
                                wf_id:wf_id,
                                wf_status:WF_STATUS,
                                menucode:menucode,
                                node_current_id:node_current_id,
                                wf_mxid:wf_mxid
                            }, function (data) {
                                if (data.success) {
                                    Ext.toast({
                                        html: "申报成功！" + (data.message ? data.message : ''),
                                        closable: false, align: 't', slideInDuration: 400, minWidth: 400
                                    });
                                } else {
                                    Ext.MessageBox.alert('提示', '申报失败！' + (data.message ? data.message : ''));
                                }
                                //刷新债券表和限额表
                                reloadGrid();
                                btn.up('window').close();
                            }, 'json');
                        }

                    },
                    {
                        text:'取消',
                        handler: function (btn) {
                            btn.up('window').close();
                        }
                    }
                ],
            }).show()
        }

            /**
         * 已汇总主表格
         */
        function initContentHZGrid() {
            //表格标题
            return DSYGrid.createGrid({
                itemId: 'contentGrid',
                headerConfig: {
                    headerJson: HeaderJson_hzsb1,
                    columnAutoWidth: false
                },
                flex: 1,
                autoLoad: false,
                border:false,
                width: '100%',
                checkBox: true,
                features: [{
                    ftype: 'summary'
                }],
                dataUrl: 'getYhzInfo.action',
                pageConfig: {
                    pageNum: true//设置显示每页条数}
                },
                listeners: {

                    itemclick: function (self, record) {
                        //刷新明细表
                        DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['TKHZ_ID'] = record.get('TKHZ_ID');
                        DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                    }
                }
            })
        }
        /**
         * 汇总单明细表
         */
        function initContentGrid_detail() {
            return DSYGrid.createGrid({
                itemId: 'contentGrid_detail',
                flex: 1,
                width: '100%',
                headerConfig: {
                    headerJson: HeaderJson_hzsb,
                    columnAutoWidth: false
                },
                features: [{
                    ftype: 'summary'
                }],
                checkBox: false,
                border: true,
                autoLoad: false,
                pageConfig: {
                    //pageNum: true//设置显示每页条数
                    enablePage: false
                },
                dataUrl: 'getYhzMx.action'
            })
        }

        /*刷新界面*/
        function reloadGrid() {
            var store = null;
            if (WF_STATUS == '001') {
                store = DSYGrid.getGrid('hzsbcontentGrid').getStore();
            } else if (WF_STATUS == '002') {
                store = DSYGrid.getGrid('contentGrid').getStore();
                DSYGrid.getGrid('contentGrid_detail').getStore().removeAll();
            }
            store.getProxy().extraParams["AD_CODE"] = AD_CODE;
            store.loadPage(1);
        };

    </script>
</body>
</html>
