<%--
  Created by IntelliJ IDEA.
  User: zhangsa
  Date: 2018/6/28
  Time: 13:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>到期还款主界面</title>
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
//    var wf_id = getUrlParam("wf_id");//当前工作流id
//    var node_code = getUrlParam("node_code");//当前节点id，1：录入岗；2：审核岗
//    var button_name = '';//当前操作按钮名称
//    var button_text = '';
    var AD_CODE='${sessionScope.ADCODE}';
    if(AD_CODE!=null&&AD_CODE!=undefined&&AD_CODE!=''){
        if(AD_CODE.length==2 || (AD_CODE.length==4 && !AD_CODE.endWith('00'))){
            AD_CODE = AD_CODE + '00';
        }
    }
    var AG_CODE='${sessionScope.AGCODE}';
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态，指未送审...
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var userCode='${sessionScope.USERCODE}';
    var flag = true;
    /**
     * 通用函数：获取url中的参数
     */
  /*   function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    } */

    var dqhk_json_common = {
        '001' :[
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            }, {
                xtype: 'button',
                text: '确认',
                icon: '/image/sysbutton/sum.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return false;
                    }
                    commitBf(records,btn);
                }
            },
//            {
//                xtype: 'button',
//                text: '操作记录',
//                name: 'log',
//                icon: '/image/sysbutton/log.png',
//                handler: function () {
//                    dooperation();
//                }
//            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()],
        '002':[
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
                text: '撤销确认',
                icon: '/image/sysbutton/undosum.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                        return;
                    }
                    commitBf(records,btn);
                }
            },
//            {
//                xtype: 'button',
//                text: '操作记录',
//                name: 'log',
//                icon: '/image/sysbutton/log.png',
//                handler: function () {
//                    dooperation();
//                }
//            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    };

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
                    items: dqhk_json_common[WF_STATUS]
                }
            ],
            items: [
                initContentTree({
//                    areaConfig: {
//                        params: {
//                            CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
//                        }
//                    }
                }),//初始化左侧树
                initContentRightPanel()//初始化右侧2个表格
            ]
        });
    }
    /**
     * 初始化页面主要内容区域
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
                initContentGrid()
            ]
        });
//        reloadGrid();
    }
    function initContentGrid(params) {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                "dataIndex": "FKTZ_DTL_ID",
                "type": "string",
                "text": "付款通知明细id",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "WZXY_ID",
                "type": "string",
                "text": "外债协议id",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "XM_ID",
                "type": "string",
                "text": "项目id",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "AD_CODE",
                "type": "string",
                "text": "区划编码",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "AG_ID",
                "type": "string",
                "text": "单位id",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "AG_CODE",
                "type": "string",
                "text": "单位编码",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "WZXY_NAME",
                "type": "string",
                "text": "外债名称",
                "fontSize": "15px",
                "width": 300
            },
            {
                "dataIndex": "AD_NAME",
                "type": "string",
                "text": "区划名称",
                "fontSize": "15px",
                "width": 200
            },
            {
                "dataIndex": "AG_NAME",
                "type": "string",
                "text": "单位名称",
                "fontSize": "15px",
                "width": 200
            },
            {
                dataIndex: "XM_NAME",
                type: "string",
                width: 300,
                text: "子项目名称",
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
                dataIndex: "ZWDW",
                type: "string",
                width: 200,
                text: "债务单位"
            },
            {
                dataIndex: "JSDW",
                type: "string",
                text: "建设单位",
                width: 200,
                editable: true
            },
            {
                dataIndex: "HKDW",
                type: "string",
                text: "还款单位",
                editable: true,
                width: 200
            },
            {
                dataIndex: "START_DATE",
                type: "string",
                width: 100,
                text: "开始日期"
            },
            {
                dataIndex: "END_DATE",
                type: "string",
                width: 100,
                text: "结束日期"
            },
            {
                dataIndex: "WZXY_AMT",
                type: "float",
                text: "转贷金额（原币）",
                width: 150,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZWYE_AMT",
                type: "float",
                text: "债务余额",
                width: 150,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                header: '支付本金', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "PAY_BJ_AMT",
                    type: "float",
                    text: "支付金额(原币)",
                    width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "PAY_BJ_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }]
            },
            {
                header: '支付利息', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "PAY_LX_AMT",
                    type: "float",
                    text: "支付金额(原币)",
                    width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "PAY_LX_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }]
            },
            {
                header: '支付承诺费', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "PAY_CNF",
                    type: "float",
                    text: "支付金额(原币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "PAY_CNF_RMB",
                    type: "float",
                    text: "支付金额(人民币)",
                    width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }]
            },
            {
                dataIndex: "PAY_ORI_SUM",
                type: "float",
                text: "原币合计",
                width: 150,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HL_RATE",
                type: "float",
                text: "汇率",
                width: 80,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            },
            {
                dataIndex: "PAY_RMB_SUM",
                type: "float",
                text: "折合人民币",
                width: 150,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
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
                AD_CODE:AD_CODE,
                AG_CODE:AG_CODE
            },
            dataUrl: 'getHktzInfo.action',
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_debt_zt11),
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
                            toolbar.add(dqhk_json_common[WF_STATUS]);
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
            }
        });
    }


    function commitBf(records,btn) {
        var btn_text=btn.text;
        if(btn_text=='撤销确认'){
            //debugger;
            Ext.Msg.confirm('提示', '是否撤销确认！', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    doWorkForHzbf(records,btn_text);
                }
            });
        }else{
            Ext.Msg.confirm('提示', '是否到期还款确认！', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    doWorkForHzbf(records,btn_text);
                }
            });
        }
    }
    function doWorkForHzbf(records,btn_text) {
        var list=new Array();
        for (var k = 0; k < records.length; k++) {
            var array = {};
            array.id = records[k].get("FKTZ_DTL_ID");
            list.push(array);
        }
        var param = {};
        param.ids = Ext.util.JSON.encode(list);
        param.btn_text = btn_text;
        $.post("doWorkForDqhk.action",param, function (data_response) {
            data_response = $.parseJSON(data_response);
            if (data_response.success) {
                Ext.toast({
                    html:  btn_text+"成功！" ,
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                reloadGrid();
            } else {
                Ext.toast({
                    html:btn_text+ "失败！" + data_response.message,
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
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        store.getProxy().extraParams['AD_CODE'] = AD_CODE;
        store.getProxy().extraParams['AG_CODE'] = AG_CODE;
        //刷新
        store.loadPage(1);
    }
    /*查看操作记录*/
//    function dooperation() {
//        var records = DSYGrid.getGrid('contentGrid').getSelection();
//        if (records.length == 0) {
//            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
//            return;
//        } else if (records.length > 1) {
//            Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
//            return;
//        } else {
//            var XX_ID = records[0].get("FKTZ_DTL_ID");
//            fuc_getWorkFlowLog(XX_ID);
//        }
//    }
</script>

</body>
</html>
