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
    <script src="/page/debt/zqgl/data/ele_data.js"></script>
    <script type="text/javascript">
        var wf_id = "${fns:getParamValue('wf_id')}";//当前工作流id
        //var node_code = getUrlParam("node_code");//当前节点id，1：申报岗；2：审核岗
        var menucode = "${fns:getParamValue('menucode')}";
        var node_type = 'sb';
        var button_name="";
        //var wf_status="";

        var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";
        if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
            WF_STATUS = '001';
        }
        var AD_CODE='${sessionScope.ADCODE}'.replace(/00$/, "");

        var hzsb_json_common = {
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
                        text: '上报',
                        name: 'down',
                        icon: '/image/sysbutton/report.png',
                        handler: function (btn) {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                                return;
                            }
                            doworkupdate(records,btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '明细操作记录',
                        name: 'btn_log',
                        icon: '/image/sysbutton/log.png',
                        handler: function () {
                            var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                            if (!record) {
                                Ext.toast({html: '请选择明细数据!'});
                                return false;
                            }
                            fuc_getWorkFlowLog(record.get("TKBZ_ID"));
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
                        text: '撤销上报',
                        name: 'cancel',
                        icon: '/image/sysbutton/cancel.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                                return;
                            }
                            doworkupdate(records,btn);

                        }
                    },

                    {
                        xtype: 'button',
                        text: '明细操作记录',
                        name: 'btn_log',
                        icon: '/image/sysbutton/log.png',
                        handler: function () {
                            var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                            if (!record) {
                                Ext.toast({html: '请选择明细数据!'});
                                return false;
                            }
                            fuc_getWorkFlowLog(record.get("TKBZ_ID"));
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
                        handler: function () {
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '上报',
                        name: 'down',
                        icon: '/image/sysbutton/report.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                                return;
                            }
                            doworkupdate(records,btn);

                        }
                    },
                    {
                        xtype: 'button',
                        text: '明细操作记录',
                        name: 'btn_log',
                        icon: '/image/sysbutton/log.png',
                        handler: function () {
                            var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                            if (!record) {
                                Ext.toast({html: '请选择明细数据!'});
                                return false;
                            }
                            fuc_getWorkFlowLog(record.get("TKBZ_ID"));
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
                        name: 'search',
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '明细操作记录',
                        name: 'btn_log',
                        icon: '/image/sysbutton/log.png',
                        handler: function () {
                            var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                            if (!record) {
                                Ext.toast({html: '请选择明细数据!'});
                                return false;
                            }
                            fuc_getWorkFlowLog(record.get("TKBZ_ID"));
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ]
            },
            store: {
                WF_STATUS: DebtEleStore(json_debt_sb)
            }
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
        * 主表单headerjson
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
                text:"申请提款金额",
               // summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000##');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000##');
                },
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
        /**
         *明细单headerjson
         * */
        var HeaderJson_hzsb=[
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
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
                text:"单位名称",
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
                text:"外债名称",
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
                text:"申请提款金额",
                summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
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
                hidden:true
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
                items:[
                    initcontentGrid(),
                    initContentGrid_detail()
                ]
            });
            reloadGrid();
        }

            /**
         * 上报主表格
         */
        function initcontentGrid() {
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
                params: {
                    WF_STATUS: WF_STATUS,
                    wf_id: wf_id,
                    menucode:menucode,
                    node_type:node_type
                },
                dataUrl: 'getSbInfo.action',
                pageConfig: {
                    pageNum: true//设置显示每页条数}
                },
                tbar: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '状态',
                        name: 'WF_STATUS',
                        store: hzsb_json_common.store['WF_STATUS'],
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
                                toolbar.add(hzsb_json_common.items[WF_STATUS]);
                                //刷新当前表格
                                self.up('grid').getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
                                reloadGrid();
                            }
                        }
                    }
                ],
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
        function reloadGrid(param, param_detail) {
            var grid = DSYGrid.getGrid('contentGrid');
            var store = grid.getStore();

            //增加查询参数
            if (typeof param != 'undefined' && param != null) {
                for (var name in param) {
                    store.getProxy().extraParams[name] = param[name];
                }
            }
            //刷新
            store.loadPage(1);
            //刷新下方表格,置为空
            if (DSYGrid.getGrid('contentGrid_detail')) {
                var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
                //如果传递参数不为空，就刷新明细表格
                if (typeof param_detail != 'undefined' && param_detail != null) {
                    for (var name in param_detail) {
                        store_details.getProxy().extraParams[name] = param_detail[name];
                    }
                    store_details.loadPage(1);
                } else {
                    store_details.removeAll();
                }
            }
        }
        function doworkupdate(records,btn) {
            var inputList = new Array();
            button_name=btn.text;
            var btn_code=btn.name;
            for(var k in records){
                inputList.push({"ID":records[k].get("TKHZ_ID"),"IS_END":records[k].get("IS_END").toString()});
            }
            Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    $.post("updateHzsbNode.action",{
                        inputList: Ext.util.JSON.encode(inputList),
                        button_name:button_name,
                        btn_code:btn_code,
                        wf_id:wf_id,
                        audit_info:"",
                        menucode:menucode
                    }, function (data_response) {
                        data_response = $.parseJSON(data_response);
                        if (data_response.success) {
                            Ext.toast({
                                html: button_name+"成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            reloadGrid();
                        } else {
                            Ext.toast({
                                html: button_name+"失败！" + data_response.message,
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                    });
                }
            });

        }

    </script>
</body>
</html>
