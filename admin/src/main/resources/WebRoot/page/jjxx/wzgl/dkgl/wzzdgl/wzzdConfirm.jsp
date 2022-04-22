<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2017/10/26
  Time: 13:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>外债转贷确认</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
    <div id="contentPanel" style="width: 100%;height:100%;">
    </div>
    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript">
        /**
         * 通用函数：获取url中的参数
         */
       /*  function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
            var r = window.location.search.substr(1).match(reg);  //匹配目标参数
            if (r != null) return unescape(r[2]);
            return null; //返回参数值
        } */
        var button_name = '';//当前操作按钮名称
        var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/,"");
        var is_dw= "${fns:getParamValue('is_dw')}";//是否转贷给单位；0：转贷下级；1：转贷单位
        var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
        if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
            WF_STATUS = '001';
        }
        var userCode='${sessionScope.USERCODE}';

        var zd_type= "${fns:getParamValue('ZD_TYPE')}"; //当前转贷类型
        var AG_CODE = '${sessionScope.AGCODE}'.replace(/00$/, "");
        if(zd_type==null||zd_type==undefined||zd_type==""){
            zd_type="zf";
        }
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
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                                return;
                            }
                            doupdateflow(records,btn);
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
                            //doWorkFlow(btn);
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                                return;
                            }
                            doupdateflow(records,btn);
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ]
            },
            store: {
                WF_STATUS: DebtEleStore(json_debt_zt11)
            }
        };
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
            reloadGrid();
        }


        /**
         * 初始化主表格
         */
        function initContentGrid() {
            var headerJson = [
                {xtype: 'rownumberer', width: 35},
                {
                    dataIndex:"ZDMX_ID",
                    type:"string",
                    width:130,
                    text:"转贷id",
                    hidden:true
                },
                {
                    dataIndex: "WZXY_CODE",
                    type: "string",
                    width: 130,
                    text: "外债编码"
                },
                {
                    dataIndex: "WZXY_NAME",
                    type: "string",
                    width: 200,
                    text: "外债名称"
                },
                {
                    dataIndex: "ZD_AMT",
                    width: 180,
                    type: "float",
                    text: "转贷协议金额（原币）",
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "ZDHL",
                    width: 100,
                    type: "float",
                    text: "转贷汇率",
                    hidden:true
                },
                {
                    dataIndex: "ZD_AMT_RMB",
                    width: 180,
                    type: "float",
                    text: "转贷协议金额（人民币）",
                    hidden:true,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "XM_NAME",
                    width: 240,
                    type: "string",
                    text: "项目名称"
                },
//                {
//                    text: '债务类型',
//                    dataIndex: 'XMFL',
//                    type: "string",
//                    renderer: function (value) {
//                        var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
//                        return result != null ? result.get('name') : value;
//                    }
//                },
                {
                    dataIndex: "ZDXM_NAME",
                    width: 200,
                    type: "string",
                    text: "转贷项目",
                    hidden:zd_type=='zf'?false:true,
                },
                {
                    text: '债务类型',
                    dataIndex: 'ZD_XMFL',
                    type: "string",
                    width: 200,
                    hidden:zd_type=='zf'?false:true,
                    renderer: function (value) {
                        var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
                        return result != null ? result.get('name') : value;
                    }
                },
                {
                    dataIndex: "ZDXM_NAME",
                    width: 200,
                    type: "string",
                    text: "转贷项目",
                    hidden:zd_type=='zf'?true:false,
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
                /*{
                    dataIndex: "ZWLX_NAME",
                    type: "string",
                    text: "债务类型",
                    width: 130
                },*/
                {
                    dataIndex: "ZQLX_NAME",
                    width: 130,
                    type: "string",
                    text: "债权类型"
                },

            ];
            return DSYGrid.createGrid({
                itemId: 'contentGrid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                flex: 1,
                params: {
                    ad_code:AD_CODE,
                    zd_type:zd_type,
                    ag_code:AG_CODE
                    //action_name:"down"
                },
                dataUrl: '/wzgl_reflct.action?method=getMakeSureInfo',
                checkBox: true,
                border: false,
                autoLoad: false,
                height: '100%',
                tbar: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '状态',
                        name: 'WF_STATUS',
                        store: zdhk_json_common.store['WF_STATUS'],
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
                                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];WF_STATUS
                                toolbar.removeAll();
                                toolbar.add(zdhk_json_common.items[WF_STATUS]);
                                //刷新当前表格
                                self.up('grid').getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
                                reloadGrid();
                            }
                        }
                    }
                ],
                tbarHeight: 50,
                pageConfig: {
                    pageNum: true//设置显示每页条数
                },
                /*features: [{
                    ftype: 'summary'
                }],*/
                listeners: {
                    itemclick: function (self, record) {
                        //刷新明细表
                        //DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['ZD_ID'] = record.get('ZD_ID');
                        //DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                    }
                }
            });
        }

        /**
         * 刷新content主表格
         */
        function doupdateflow(records,btn) {
            var ids=new Array();
            var btn_name=btn.name;
            var btn_text=btn.text;
            for(var k=0;k<records.length;k++){
                var zd_id=records[k].get("ZDMX_ID");
                ids.push(zd_id);
            }
            Ext.Msg.confirm('提示', '请确认是否' + btn_text + '!', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    btn.setDisabled(true);
                    $.post("/wzgl_reflct.action?method=makeSureMx", {
                        ids: Ext.util.JSON.encode(ids),
                        btn_name: btn_name,
                        btn_text: btn_text,
                        ad_code: AD_CODE,
                        ag_code: AG_CODE,
                        zd_type: zd_type,
                        audit_info: "",
                        userCode: userCode
                    }, function (data_response) {
                        data_response = $.parseJSON(data_response);
                        if (data_response.success) {
                            Ext.toast({html: btn_text + "成功！"});
                        } else {
                            Ext.MessageBox.alert('提示', btn_text + '失败！' + data_response.message);
                        }
                        btn.setDisabled(false);
                        reloadGrid();
                    })
                }
            });
        }

        function reloadGrid(param, param_detail) {
            var grid = DSYGrid.getGrid('contentGrid');
            var store = grid.getStore();
            var  WF_STATUS=Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0].getValue();
            store.getProxy().extraParams['WF_STATUS']=WF_STATUS;
            //增加查询参数
            if (typeof param != 'undefined' && param != null) {
                for (var name in param) {
                    store.getProxy().extraParams[name] = param[name];
                }
            }
            //刷新
            store.loadPage(1);

        }



    </script>
</body>
</html>
