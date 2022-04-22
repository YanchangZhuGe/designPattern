<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>转贷回收确认</title>
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
    </style>
</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<script type="text/javascript">
    /**
     * 通用函数：获取url中的参数
     */
 /*   function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    }*/
    /*获取登录用户*/
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var USER_CODE = '${sessionScope.USERCODE}';
    /**
     * 设置全局变量
     */
    var button_name = '';//按钮名称
    var next_text = '';//送审、审核按钮显示文字
    var audit_info = '';//送審意見
  /*  var WF_STATUS = getUrlParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var SYS_IS_QEHBFX = '';
    //全局变量
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
                    name: 'btn_check',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '确认',
                    name: 'down',
                    icon: '/image/sysbutton/confirm.png',
                    handler: function (btn) {
                        doWorkFlow(btn);
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
                    name: 'btn_check',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
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
            {xtype: 'rownumberer',width: 35},
            {
                dataIndex: "ZQ_NAME",
                type: "string",
                width: 250,
                text: "债券名称",
                renderer: function (data, cell, record) {
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
                }
            },
            {
                dataIndex: "ZQLB_NAME",
                type: "string",
                text: "债券类型",
                width: 130
            },
            {
                dataIndex: "AD_NAME",
                type: "string",
                text: "区划名称",
                width: 130
            },
            {
                dataIndex: "HS_DATE",
                type: "string",
                text: "回收日期",
                width: 130
            },
            {
                dataIndex: "ZQJE",text: "债券金额（元）",
                columns: [
                    {
                        dataIndex: "ZD_AMT",
                        width: 150,
                        type: "float",
                        text: "合计"
                    },
                    {
                        dataIndex: "ZD_XZ_AMT",
                        width: 150,
                        type: "float",
                        text: "其中新增债券"
                    },
                    {
                        dataIndex: "ZD_ZH_AMT",
                        width: 150,
                        type: "float",
                        text: "其中置换债券"
                    }
                ]
            },
            {
                dataIndex: "BJZC",text: "本级支出金额（元）",
                columns: [
                    {
                        dataIndex: "BJZC_AMT",
                        width: 150,
                        type: "float",
                        text: "合计"
                    },
                    {
                        dataIndex: "BJZC_XZ_AMT",
                        width: 150,
                        type: "float",
                        text: "其中新增债券"
                    },
                    {
                        dataIndex: "BJZC_ZH_AMT",
                        width: 150,
                        type: "float",
                        text: "其中置换债券"
                    }
                ]
            },
            {
                dataIndex: "ZDZC",text: "转贷支出金额（元）",
                columns: [
                    {
                        dataIndex: "ZDZC_AMT",
                        width: 150,
                        type: "float",
                        text: "合计"
                    },
                    {
                        dataIndex: "ZDZC_XZ_AMT",
                        width: 150,
                        type: "float",
                        text: "其中新增债券"
                    },
                    {
                        dataIndex: "ZDZC_ZH_AMT",
                        width: 150,
                        type: "float",
                        text: "其中置换债券"
                    }
                ]
            },
            {
                dataIndex: "HSJE",text: "回收金额（元）",
                columns: [
                    {
                        dataIndex: "HS_AMT",
                        width: 150,
                        type: "float",
                        text: "合计"
                    },
                    {
                        dataIndex: "HS_XZ_AMT",
                        width: 150,
                        type: "float",
                        text: "其中新增债券"
                    },
                    {
                        dataIndex: "HS_ZH_AMT",
                        width: 150,
                        type: "float",
                        text: "其中置换债券"
                    }
                ]
            },
            {
                dataIndex: "HS_CDBJ_AMT",
                width: 150,
                hidden: SYS_IS_QEHBFX==0,
                type: "float",
                text: "回收承担本金（元）"
            },
            {
                dataIndex: "HS_CDLX_AMT",
                width: 150,
                hidden: SYS_IS_QEHBFX==0,
                type: "float",
                text: "回收承担利息 （元）"
            },
            {
                dataIndex: "REMARK",
                type: "string",
                text: "备注",
                width: 250
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
                WF_STATUS: WF_STATUS
            },
            dataUrl: 'getZdhsConfirmGridData.action',
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
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("ZDHS_ID"));
        }
        button_name = btn.text;
        Ext.Msg.confirm("提示","是否"+button_name+"?",function(op){
            if(op == 'yes'){
                $.post("/updateZdhsConfirm.action", {
                    button_name: button_name,
                    ids: ids
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: button_name + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    } else {
                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    }
                    //刷新表格
                    DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                }, "json");
            } else {
                return;
            }
        });
    }
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
    }
</script>
</body>
</html>