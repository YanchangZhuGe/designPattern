<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>

<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <title>手续费确认</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }

        .grid-cell {
            background-color: #ffe850;
        }
    </style>
</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>

<script type="text/javascript">
    /**
     * 顶部工具栏
     */
    var WF_STATUS = '001';
  /*  var IS_DW = getQueryParam("is_dw");//是否为单位角色
    if (IS_DW == null || IS_DW == '' || IS_DW.toLowerCase() == 'null') {
        IS_DW = '0';
    }*/
    var IS_DW ="${fns:getParamValue('is_dw')}";
    if (isNull(IS_DW)) {
        IS_DW = '0';
    }
    var btn_text = '';// 按钮名称
    var items_toolbar = {
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
                name: 'confirm',
                disabled: true,
                icon: '/image/sysbutton/confirm.png',
                handler: function (btn) {
                    button_name = btn.text;
                    btn_text = btn.name;
                    comfirmSxf();
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
                name: 'cancel',
                disabled: true,
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_name = btn.text;
                    btn_text = btn.name;
                    //撤销确认校验
                    var result = checkCxConfirm();
                    if (!result) {
                        return false;
                    }
                    comfirmSxf();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    };
    var title_name = IS_DW == '1' ? '单位': '市县';
    /**
     * 页面初始化
     **/
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
            renderTo: Ext.getBody(),
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: items_toolbar[WF_STATUS]
                }
            ],
            items: [
                initContentRightPanel()
            ]
        });
    }
    /**
     * 初始化右侧panel，放置表格
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
            tbar: [
                {
                    fieldLabel: '债券类型',
                    xtype: 'treecombobox',
                    name: 'ZQLB_ID',
                    labelAlign: 'right',
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    displayField: "name",
                    valueField: "id",
                    labelWidth: 60,
                    listeners: {
                        change: function (self, newValue, oldValue) {
                            reloadGrid({
                                ZQLB_ID: newValue
                            })
                        }
                    }
                },
                {
                    fieldLabel: '债券编码',
                    xtype: "textfield",
                    name: 'ZQ_CODE',
                    labelWidth: 60,
                    labelAlign: 'right',
                    enableKeyEvents: true,
                    listeners: {
                          'change': function (self, newValue) {
                              DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams['ZQ_CODE'] = newValue;
                           },
                          'keydown': function (self, e, eOpts) {
                              var key = e.getKey();
                               if (key == Ext.EventObject.ENTER) {
                                  reloadGrid({
                                      ZQ_CODE: self.getValue()
                                  })
                             }
                        }
                    }
                },
                {
                    fieldLabel: '债券名称',
                    xtype: "textfield",
                    name: 'ZQ_NAME',
                    labelWidth: 60,
                    labelAlign: 'right',
                    enableKeyEvents: true,
                    listeners: {
                          'change': function (self, newValue) {
                              DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams['ZQ_NAME'] = newValue;
                           },
                          'keydown': function (self, e, eOpts) {
                              var key = e.getKey();
                               if (key == Ext.EventObject.ENTER) {
                                  reloadGrid({
                                      ZQ_NAME: self.getValue()
                                 })
                             }
                         }
                     }
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
            {xtype: 'rownumberer', width: 40},
            {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 150},
            {text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 250,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+record.get('AD_CODE');
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=record.get('AD_CODE');
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "转贷地区", dataIndex: "AD_NAME", type: "string", width: 150},
            {text: "转贷单位", dataIndex: "AG_NAME", type: "string", width: 150,hidden:IS_DW =='0'},
            {text: "转贷日期", dataIndex: "ZD_DATE", type: "string"},
            {text: "转贷金额", dataIndex: "ZD_AMT", type: "float", width: 150},
            {text: "需承担利息费用金额", dataIndex: "CD_AMT", type: "float", width: 200},
            {text: "应缴付日期", dataIndex: "PLAN_PAY_DATE", type: "string"},
            {text: "发行手续费", dataIndex: "FXF_AMT", type: "float", width: 150},
            {text: "登记托管费", dataIndex: "TGF_AMT", type: "float", width: 150},
            {text: "收款账户", dataIndex: "PAY_ACCOUNT", type: "string", width: 150}
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
                IS_DW: IS_DW
            },
            dataUrl: 'getSxfglSxfConfirmGridData.action',
            checkBox: true,
            border: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_debt_zt3),
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
                            toolbar.add(items_toolbar[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                }
            ],
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            listeners: {
                itemdblclick: function (self, record) {
//                    window_detail_zcxx.show(record);
                },
                selectionchange: function (view, records) {
                    var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                    if (toolbar.down('button[name=confirm]')) {
                        toolbar.down('button[name=confirm]').setDisabled(records.length < 1);
                    }
                    if (toolbar.down('button[name=cancel]')) {
                        toolbar.down('button[name=cancel]').setDisabled(records.length < 1);
                    }
                    if (toolbar.down('button[name=view]')) {
                        toolbar.down('button[name=view]').setDisabled(records.length != 1);
                    }
                }
            }
        });
    }
    /**
     * 刷新content主表格
     */
    function reloadGrid(param) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        store.getProxy().extraParams["IS_DW"] = IS_DW;
        //刷新
        store.loadPage(1);
    }
    /**
     * 手续费确认/取消确认
     * @return {boolean}
     */
    function comfirmSxf() {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length < 1) {
            Ext.Msg.alert('提示', '请选择至少一条数据！');
            return false;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].data.ID);
        }
        //发送ajax请求，确认数据
        $.post("/confirmSxfgl.action", {
            button_name: button_name,
            btn_text: btn_text,
            IS_DW: IS_DW,
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
            reloadGrid();
        }, "json");
    }
    /**
     * 手续费撤销确认校验
     */
    function checkCxConfirm() {
        var FXF_SYKCX_AMT = {};
        var TGF_SYKCX_AMT = {};
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        for (var i in records) {
            var record = records[0].data;
            var ZQ_ID = record.ZQ_ID;
            if (typeof FXF_SYKCX_AMT[ZQ_ID] == 'undefined' || FXF_SYKCX_AMT[ZQ_ID] == null) {
                FXF_SYKCX_AMT[ZQ_ID] = parseFloat(record.FXF_SYKCX_AMT);
            }
            FXF_SYKCX_AMT[ZQ_ID] -= parseFloat(record.FXF_AMT);
            if (FXF_SYKCX_AMT[ZQ_ID] < 0) {
                Ext.Msg.alert('提示', '发行手续费总和超出剩余可撤销额度，无法撤销！');
                return false;
            }
            if (typeof TGF_SYKCX_AMT[ZQ_ID] == 'undefined' || TGF_SYKCX_AMT[ZQ_ID] == null) {
                TGF_SYKCX_AMT[ZQ_ID] = parseFloat(record.TGF_SYKCX_AMT);
            }
            TGF_SYKCX_AMT[ZQ_ID] -= parseFloat(record.TGF_AMT);
            if (TGF_SYKCX_AMT[ZQ_ID] < 0) {
                Ext.Msg.alert('提示', '托管手续费总和超出剩余可撤销额度，无法撤销！');
                return false;
            }
        }
        return true;
    }
</script>
</body>
</html>
