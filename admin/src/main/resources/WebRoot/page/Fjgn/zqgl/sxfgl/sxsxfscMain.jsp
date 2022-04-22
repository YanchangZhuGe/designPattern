<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>

<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <title>市县手续费生成</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }
        .grid-cell {
            background-color: #ffe850;
        }

        .grid-row-disabled {
            background-color: #D3D3D3;
        }
    </style>
</head>
<body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    /*获取登录用户*/
    var AD_CODE = '${sessionScope.ADCODE}';
/*    var IS_DW = getQueryParam("is_dw");//是否为单位角色
    if (IS_DW == null || IS_DW == '' || IS_DW.toLowerCase() == 'null') {
        IS_DW = '0';
    }*/
    var IS_DW ="${fns:getParamValue('is_dw')}";
    if (isNull(IS_DW)) {
        IS_DW = '0';    }
    /**
     * 顶部工具栏
     */
    var WF_STATUS = '001';
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
                text: '生成',
                name: 'generate',
                disabled: true,
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.Msg.alert('提示', '请选择一条数据！');
                        return false;
                    }
                    initWindow_select_ssfsc(records[0].data).show();

                }
            },
            {
                xtype: 'button',
                text: '查看',
                name: 'view',
                disabled: true,
                hidden:true,
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                    initWindow_select_ssfck(record.data).show();
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
                text: '撤销生成',
                name: 'cancel',
                disabled: true,
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.Msg.alert('提示', '请选择一条数据！');
                        return false;
                    }
                    initWindow_select_ssfcx(records[0].data).show();
                }
            },
            {
                xtype: 'button',
                text: '查看',
                name: 'view',
                disabled: true,
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                    initWindow_select_ssfck(record.data).show();
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

    //适用于Extjs4.xExt.override(Ext.grid.GridPanel, {



    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
    });


    //设置显示的变量
    var tips='';

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
                    fieldLabel: '债券代码',
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
            {text: "起息日", dataIndex: "QX_DATE", type: "string"},
            {text: "债券代码", dataIndex: "ZQ_CODE", type: "string"},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 250,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "转贷日期", dataIndex: "ZD_DATE", type: "string", width: 150},
            {text: "需承担本金金额", dataIndex: "ZD_AMT", type: "float", width: 150},
            {text: "债券期限(年)", dataIndex: "ZQQX_NAME", type: "string"},
            {text: "转贷编码", dataIndex: "ZD_NO", type: "string", width: 250},
            {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string"},
            {text: "发行结束日", dataIndex: "FX_END_DATE", type: "string", width: 150,hidden:true},
            {text: "发行手续费率(‰)", dataIndex: "FXSXF_RATE", type: "float", width: 150},
            {text: "托管手续费率(‰)", dataIndex: "TGSXF_RATE", type: "float", width: 150},
            {text: "是否已全部确认", dataIndex: "IS_CONFIRM", type: "string", width: 150,hidden:true},
            {text: "已生成发行手续费", dataIndex: "FXF_YSC", type: "float", width: 150,hidden:true},
            {text: "已生成托管手续费", dataIndex: "TGF_YSC", type: "float", width: 150,hidden:true}
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
            selModel: {
                mode: "SINGLE"
            },
            dataUrl: 'getSxfglZdjbxxGridData.action',
            checkBox: true,
            border: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_debt_zt5),
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
                    if (toolbar.down('button[name=generate]')) {
                        toolbar.down('button[name=generate]').setDisabled(records.length != 1);
                    }
                    if (toolbar.down('button[name=cancel]')) {
                        toolbar.down('button[name=cancel]').setDisabled(records.length != 1);
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
     * 初始化手续费生成弹出窗口
     */
    function initWindow_select_ssfsc(record) {
        return Ext.create('Ext.window.Window', {
            title: title_name + '手续费生成', // 窗口标题
            width: document.body.clientWidth * 0.8, // 窗口宽度
            height: document.body.clientHeight * 0.8, // 窗口高度
            layout: 'anchor',
            maximizable: true,
            itemId: 'window_select_sxfsc', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [
                initWindow_select_ssfsc_form(record),
                initWindow_select_ssfsc_grid(record)
            ],
            buttons: [
                {
                    text: '保存',
                    handler: function (btn) {
                        var form = btn.up('window#window_select_sxfsc').down('form#window_select_sxfsc_form');
                        var grid = btn.up('window#window_select_sxfsc').down('grid#window_select_sxfsc_grid');
                        if (form.isValid()) {
                            var gridData = [];
                            var sxf_type = form.down('checkboxgroup[name=SXF_TYPE]').getValue();
                            var flag_sxf_type_FXSXF = form.down('checkboxgroup[name=SXF_TYPE]').down('checkbox[inputValue=FXSXF]').checked;
                            var flag_sxf_type_TGSXF = form.down('checkboxgroup[name=SXF_TYPE]').down('checkbox[inputValue=TGSXF]').checked;
                            grid.getStore().each(function (record) {
                                if (!flag_sxf_type_FXSXF) {
                                    record.data.FX_SXF_AMT = 0;
                                }
                                if (!flag_sxf_type_TGSXF) {
                                    record.data.TG_SXF_AMT = 0;
                                }
                                gridData.push(record.data);
                            });
                           /* var checkResult = checkIsConfirm(record.ZD_ID);
                            if (!checkResult) {
                                return false;
                            }*/
                            form.submit({
                                //设置表单提交的url
                                url: 'saveSxfglXjsxf.action',
                                params: {
                                    detailList: Ext.util.JSON.encode(gridData),
                                    IS_DW:IS_DW
                                },
                                success: function (form, action) {
                                    //关闭弹出框
                                    btn.up("window").close();
                                    //提示保存成功
                                    Ext.toast({
                                        html: '<div style="text-align: center;">保存成功!</div>',
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    reloadGrid();
                                },
                                failure: function (form, action) {
                                    var result = Ext.util.JSON.decode(action.response.responseText);
                                    Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                                }
                            });
                        }
                    }
                },
                {
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ],
            listeners: {

            }
        });
    }
    /**
     * 初始化手续费生成弹出窗口:form表单
     */
    function initWindow_select_ssfsc_form(record) {
        var form = Ext.create('Ext.form.Panel', {
            itemId: 'window_select_sxfsc_form',
            border: false,
            anchor: '100%',
            height:150,
            layout: 'column',
            defaults: {
                margin: '5 5 5 5',
                columnWidth: .33,
                labelAlign: 'right',
                labelWidth: 120//控件默认标签宽度
            },
            items: [
                {fieldLabel: '转贷ID', name: 'ZD_ID', xtype: 'displayfield', hidden: true},
                {fieldLabel: '债券ID', name: 'ZQ_ID', xtype: 'displayfield', hidden: true},
                {fieldLabel: '债券名称', name: 'ZQ_NAME', xtype: 'displayfield', readOnly: true},
                {fieldLabel: '债券代码', name: 'ZQ_CODE', xtype: 'textfield', readOnly: true},
                {fieldLabel: '债券期限', name: 'ZQQX_NAME', xtype: 'textfield', readOnly: true},
                {fieldLabel: '债券类型', name: 'ZQLB_NAME', xtype: 'textfield', readOnly: true},
                {
                    fieldLabel: '发行手续费率(‰)',
                    name: 'FXSXF_RATE',
                    xtype: 'numberfield',
                    readOnly: true,
                    fieldStyle: 'text-align:right;'
                },
                {
                    fieldLabel: '登记托管费率(‰)',
                    name: 'TGSXF_RATE',
                    xtype: 'numberfield',
                    readOnly: true,
                    fieldStyle: 'text-align:right;'
                },
                {
                    fieldLabel: '发行手续费总额(元)',
                    name: 'FXSXF_AMT',
                    xtype: 'numberFieldFormat',
                    readOnly: true,
                    fieldStyle: 'text-align:right;'
                },
                {
                    fieldLabel: '登记托管费总额(元)',
                    name: 'TGSXF_AMT',
                    xtype: 'numberFieldFormat',
                    readOnly: true,
                    fieldStyle: 'text-align:right;'
                },
                {fieldLabel: '<span class="required">✶</span>应上缴日期', name: 'PLAN_PAY_DATE', xtype: 'datefield',
                           allowBlank: false,
                           format: 'Y-m-d',
                           editable: false,
                           value: today,
                           listeners:{
                               'change': function (self, newValue) {
                                   self.up('window').down('grid').getStore().each(function (record) {
                                       record.set('PLAN_PAY_DATE', format_date(newValue,"yyyy-MM-dd"));
                                   })
                               }
                           }
                },
                {fieldLabel: '手续费收缴账户', name: 'PAY_ACCOUNT', xtype: 'textfield'},
                {
                    fieldLabel: '手续费类型', name: 'SXF_TYPE', xtype: 'checkboxgroup',
                    items: [
                        {
                            boxLabel: '发行手续费', name: 'SXF_LX', inputValue: 'FXSXF', checked: true,
                            listeners: {
                                change: function (self, newValue, oldValue) {
                                    if (newValue) {
                                        //还原表格中发行手续费               changeColor(grid3,index,5);
                                        self.up('window').down('grid').getStore().each(function (record) {
                                            record.set('FX_SXF_AMT', record.data.FX_SXF_AMT_bak);
                                            record.set('FX_SXF_AMT_SW', record.data.FX_SXF_AMT_SW_bak);
                                            record.set('FX_SXF_AMT_YZ', record.data.FX_SXF_AMT_YZ_bak);
                                            if(record.data.FX_SXF_AMT_SW_bak!=null&&record.data.FX_SXF_AMT_SW_bak!=0&&record.data.FX_SXF_AMT_SW_bak!=undefined){
                                                changeColor(self.up('window').down('grid'),self.up('window').down('grid').getStore().indexOf(record),5,"#00ff00");
                                            }
                                            record.data.FX_SXF_AMT_bak = 0;
                                            record.data.FX_SXF_AMT_SW_bak=0;
                                            record.data.FX_SXF_AMT_YZ_bak=0;
                                        })
                                    } else {
                                        //备份当前表格中
                                        self.up('window').down('grid').getStore().each(function (record) {
                                            record.data.FX_SXF_AMT_bak = record.data.FX_SXF_AMT;
                                            record.data.FX_SXF_AMT_SW_bak=record.data.FX_SXF_AMT_SW;
                                            record.data.FX_SXF_AMT_YZ_bak=record.data.FX_SXF_AMT_YZ;
                                            if(record.data.FX_SXF_AMT_SW!=null&&record.data.FX_SXF_AMT_SW!=0&&record.data.FX_SXF_AMT_SW!=undefined){
                                                changeColor(self.up('window').down('grid'),self.up('window').down('grid').getStore().indexOf(record),5,"#ffffff");
                                            }
                                            record.set('FX_SXF_AMT', 0);
                                            record.set('FX_SXF_AMT_SW', 0);
                                            record.set('FX_SXF_AMT_YZ', 0);
                                        })
                                    }
                                }
                            }
                        },
                        {
                            boxLabel: '登记托管费', name: 'SXF_LX', inputValue: 'TGSXF', checked: true,
                            listeners: {
                                change: function (self, newValue, oldValue) {
                                    if (newValue) {
                                        //还原表格中登记托管费
                                        self.up('window').down('grid').getStore().each(function (record) {
                                            record.set('TG_SXF_AMT', record.data.TG_SXF_AMT_bak);
                                            record.set('TG_SXF_AMT_SW', record.data.TG_SXF_AMT_SW_bak);
                                            record.set('TG_SXF_AMT_YZ', record.data.TG_SXF_AMT_YZ_bak);
                                            if(record.data.TG_SXF_AMT_SW_bak!=null&&record.data.TG_SXF_AMT_SW_bak!=0&&record.data.TG_SXF_AMT_SW_bak!=undefined){
                                                changeColor(self.up('window').down('grid'),self.up('window').down('grid').getStore().indexOf(record),6,"#00ff00");
                                            }
                                            record.data.TG_SXF_AMT_bak = 0;
                                            record.data.TG_SXF_AMT_SW_bak=0;
                                            record.data.TG_SXF_AMT_YZ_bak=0;
                                        })
                                    } else {
                                        //备份当前表格中登记托管费
                                        self.up('window').down('grid').getStore().each(function (record) {
                                            record.data.TG_SXF_AMT_bak = record.data.TG_SXF_AMT;
                                            record.data.TG_SXF_AMT_SW_bak=record.data.TG_SXF_AMT_SW;
                                            record.data.TG_SXF_AMT_YZ_bak=record.data.TG_SXF_AMT_YZ;
                                            if(record.data.TG_SXF_AMT_SW!=null&&record.data.TG_SXF_AMT_SW!=0&&record.data.TG_SXF_AMT_SW!=undefined){
                                                changeColor(self.up('window').down('grid'),self.up('window').down('grid').getStore().indexOf(record),6,"#fffff6");
                                            }
                                            record.set('TG_SXF_AMT', 0);
                                            record.set('TG_SXF_AMT_SW', 0);
                                            record.set('TG_SXF_AMT_YZ', 0);

                                        })
                                    }
                                }
                            }
                        }
                    ]
                },
                {fieldLabel: '是否已全部确认', name: 'IS_CONFIRM', xtype: 'textfield', readonly:true,hidden:true},
                {
                    fieldLabel: '已生成发行手续费',
                    name: 'FXF_YSC',
                    xtype: 'numberfield',
                    readonly:true,
                    hidden:true
                },
                {
                    fieldLabel: '已生成登记托管费',
                    name: 'TGF_YSC',
                    xtype: 'numberfield',
                    readonly:true,
                    editabel:false,
                    hidden:true
                },
                {
                    fieldLabel: '剩余发行手续费',
                    name: 'FXSXF_AMT_SY',
                    xtype: 'numberFieldFormat',
                    readonly:true,
                    hidden:true
                },
                {
                    fieldLabel: '剩余登记托管费',
                    name: 'TGSXF_AMT_SY',
                    xtype: 'numberFieldFormat',
                    readonly:true,
                    hidden:true
                }
            ]
        });
        if (record) {
            //record.ZQ_NAME = '<a href="/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.ZQ_ID + '&AD_CODE=' + AD_CODE + '" target="_blank" style="color:#3329ff;">' + record.ZQ_NAME + '</a>';

            form.getForm().setValues(record);
        }
        return form;
    }
    /**
     * 初始化手续费生成弹出窗口:grid表格
     */
    function initWindow_select_ssfsc_grid(record) {
        is_fist_load=true;
        var headerJson = [
            {xtype: 'rownumberer', width: 40,summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }},
            {text: "地区编码", dataIndex: "AD_CODE", hiden: true, type: "string"},
            {text: "地区名称", dataIndex: "AD_NAME", type: "string"},
            {text: "转贷日期", dataIndex: "ZD_DATE", type: "string"},
            {text: "应上缴日期", dataIndex: "PLAN_PAY_DATE", type: "string",editor: {
                xtype: 'datefield',
                editable: true,
                format: 'Y-m-d'
            }},
            {text: "需承担本金金额（元）", dataIndex: "CDFY", type: "float", width: 200},
            {text: "转贷金额（元）", dataIndex: "ZD_AMT", type: "float", width: 200, hidden: true},
            {
                text: "发行手续费（元）", dataIndex: "FX_SXF_AMT", type: "float", width: 200,
                //tdCls: 'grid-cell',
                editor: {
                    xtype: 'numberfield', fieldStyle: 'text-align:right;'
                },
                tipable:false,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "登记托管手续费（元）", dataIndex: "TG_SXF_AMT", type: "float", width: 200,
                //tdCls: 'grid-cell',
                editor: {
                    xtype: 'numberfield', fieldStyle: 'text-align:right;'
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "发行手续费_舍位数据", dataIndex: "FX_SXF_AMT_SW", type: "float", width: 200,
                hidden:true
            },
            {
                text: "发行手续费_原值数据", dataIndex: "FX_SXF_AMT_YZ", type: "float", width: 200,
                hidden:true,
                editor: {
                    xtype: 'numberfield', fieldStyle: 'text-align:right;'
                }

            },

            {
                text: "登记托管手续费_舍位数据", dataIndex: "TG_SXF_AMT_SW", type: "float", width: 200,
                hidden:true,
                editor: {
                    xtype: 'numberfield', fieldStyle: 'text-align:right;'
                }

            },
            {
                text: "登记托管手续费_原值数据", dataIndex: "TG_SXF_AMT_YZ", type: "float", width: 200,
                hidden:true,
                editor: {
                    xtype: 'numberfield', fieldStyle: 'text-align:right;'
                }

            }
        ];
        var gridConfig = {
            itemId: 'window_select_sxfsc_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            dataUrl: 'getSxfglZdmxGridData.action',
            params: {
                ZD_ID: record.ZD_ID,
                IS_DW:IS_DW
            },
            features: [{
                ftype: 'summary'
            }],
            autoLoad: false,
            border: false,
            checkBox: false,
            //cellTip:true,
            anchor: '100% -150',
            pageConfig: {
                enablePage: false
            },
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'window_select_sxfsc_grid_plugin_cell',
                    clicksToMoveEditor: 1,
                    listeners: {
                        beforeedit: function (editor, context) {
                            //根据form中手续费类型多选框，判断表格手续费列是否可写
                            if(context.field == 'PLAN_PAY_DATE'){
                            }else{
                                return false;
                            }
//                            if (context.field == 'FX_SXF_AMT' || context.field == 'TG_SXF_AMT') {
//                                var sxf_type = DSYGrid.getGrid('window_select_sxfsc_grid').up('window').down('form').down('checkboxgroup[name=SXF_TYPE]');
//                                var flag_sxf_type_FXSXF = sxf_type.down('checkbox[inputValue=FXSXF]').checked;
//                                var flag_sxf_type_TGSXF = sxf_type.down('checkbox[inputValue=TGSXF]').checked;
//                                if (context.field == 'FX_SXF_AMT' && !flag_sxf_type_FXSXF) {
//                                    return false;
//                                }
//                                if (context.field == 'TG_SXF_AMT' && !flag_sxf_type_TGSXF) {
//                                    return false;
//                                }
//                            }
                        },
                        validateedit: function (editor, context) {
                        },
                        edit: function (editor, context) {
                            if (context.field == 'PLAN_PAY_DATE') {
                                context.record.set('PLAN_PAY_DATE', format_date(context.value,"yyyy-MM-dd"));
                            }
//                            if (context.field == 'FX_SXF_AMT' || context.field == 'TG_SXF_AMT') {
//                                var fxsxf_amt = 0;
//                                var tgsxf_amt = 0;
//                                var records = DSYGrid.getGrid('window_select_sxfsc_grid').getStore().getData();
//                                for (var i in records.items) {
//                                    var record = records.items[i].data;
//                                    fxsxf_amt += parseFloat(record.FX_SXF_AMT);
//                                    tgsxf_amt += parseFloat(record.TG_SXF_AMT);
//                                }
//                                grid.up('window').down('form').down('numberFieldFormat[name=FXSXF_AMT]').setValue(fxsxf_amt);
//                                grid.up('window').down('form').down('numberFieldFormat[name=TGSXF_AMT]').setValue(tgsxf_amt);
//                            }
                        }

                    }
                }
            ]
            ,listeners: {
                afterRender: function () {
                    if (!this.cellTip) {
                        return;
                    }
                    var view = this.getView();
                    var reportSearchWindows = Ext.ComponentQuery.query("tooltip");
                        reportSearchWindows=reportSearchWindows[reportSearchWindows.length-1];
                        reportSearchWindows.on({
                            beforeshow: {fn: function updateTipBody(tip) {
                                var record=view.getRecord(tip.triggerElement);
                                var data=record.data;
                                var tipText = (tip.triggerElement.innerText || tip.triggerElement.textContent);
                                if (Ext.isEmpty(tip.triggerElement.innerText)) {
                                    return false;
                                }
                                var ss1='';
                                var ss2='';
                                if(data.FX_SXF_AMT_SW!=null&&data.FX_SXF_AMT_SW!=undefined&&data.FX_SXF_AMT_SW!=0){
                                    var flag;
                                    if(data.FX_SXF_AMT_SW>0){
                                        flag='减去金额：';
                                    }else{
                                        flag='增加金额：';
                                    }
                                    var ss1="发行手续费:"+"<br>"+" 舍位平衡: "+flag+(Math.abs(data.FX_SXF_AMT_SW)).toFixed(2)+"<br>";
                                }
                                if(data.TG_SXF_AMT_SW!=null&&data.TG_SXF_AMT_SW!=undefined&&data.TG_SXF_AMT_SW!=0){
                                    var flag2;
                                    if(data.TG_SXF_AMT_SW>0){
                                        flag2='减去金额：';
                                    }else{
                                        flag2='增加金额：';
                                    }
                                    var ss2="登记托管手续费:"+"<br>"+"舍位平衡:"+flag2+(Math.abs(data.TG_SXF_AMT_SW)).toFixed(2)+"<br>";
                                }
                                var ss=ss1+ss2;
                                if(ss!=null&&ss!=undefined&&ss!=''){
                                    tip.update(ss);
                                }else{
                                    tip.update(tipText);
                                }
                            }, scope: this, single: false}
                        });
                }
            }
        };
        var grid = DSYGrid.createGrid(gridConfig);
        var form_record=record;
        //计算发行和托管手续费总金额
        grid.getStore().load({
            callback: function (records, operation, success) {
                var fxsxf_amt = 0;
                var tgsxf_amt = 0;
                var fxsxf_amt_sy = 0;
                var tgsxf_amt_sy = 0;
                var form = Ext.ComponentQuery.query('form#window_select_sxfsc_form')[0];
//                for (var i in records) {
//                    var record = records[i].data;
//                    fxsxf_amt += parseFloat(record.FX_SXF_AMT);
//                    tgsxf_amt += parseFloat(record.TG_SXF_AMT);
//                }
//
//                fieldLabel: '发行手续费率(‰)',
//                    name: 'FXSXF_RATE',
//                    xtype: 'numberfield',
//                    readOnly: true,
//                    fieldStyle: 'text-align:right;'
//            },
//        {
//            fieldLabel: '登记托管费率(‰)',
//                name: 'TGSXF_RATE',
//            xtype: 'numberfield',
                fxsxf_amt=form_record.ZD_AMT*(form.down('numberfield[name=FXSXF_RATE]').getValue()/1000);
                tgsxf_amt=form_record.ZD_AMT*(form.down('numberfield[name=TGSXF_RATE]').getValue()/1000);
                grid.up('window').down('form').down('numberFieldFormat[name=FXSXF_AMT]').setValue(fxsxf_amt);
                grid.up('window').down('form').down('numberFieldFormat[name=TGSXF_AMT]').setValue(tgsxf_amt);

                fxsxf_amt_sy=fxsxf_amt-form_record.FXF_YSC;
                tgsxf_amt_sy=tgsxf_amt-form_record.TGF_YSC;
                grid.up('window').down('form').down('numberFieldFormat[name=FXSXF_AMT_SY]').setValue(fxsxf_amt_sy);
                grid.up('window').down('form').down('numberFieldFormat[name=TGSXF_AMT_SY]').setValue(tgsxf_amt_sy);
                if(is_fist_load){
                    dosomechange(fxsxf_amt_sy,tgsxf_amt_sy);
                }
            }
        });
        return grid;
    }
    function dosomechange(fxsxf_amt,tgsxf_amt){
        var form = Ext.ComponentQuery.query('form#window_select_sxfsc_form')[0];
        var grid2 = Ext.ComponentQuery.query('grid#window_select_sxfsc_grid')[0];
        var PLAN_PAY_DATE=form.down('datefield[name=PLAN_PAY_DATE]').getValue();
        if(PLAN_PAY_DATE!=null&&PLAN_PAY_DATE!=''&&PLAN_PAY_DATE!=undefined){
            var is_fist_load_2=true;
            grid2.getStore().each(function (record) {
                    //dobanlence(fxsxf_amt,tgsxf_amt);
                record.set('PLAN_PAY_DATE',format_date(PLAN_PAY_DATE,"yyyy-MM-dd"));
            });
            var is_confirm=form.down('textfield[name=IS_CONFIRM]').getValue();
            if( is_confirm ==1 ){
                dobanlence(fxsxf_amt,tgsxf_amt);
            }
        }
        is_fist_load=false;
    };
   function dobanlence(fxsxf_amt,tgsxf_amt){
       var temp_min_fx=0;
       var temp_max_fx=0;
       var temp_min_tg=0;
       var temp_max_tg=0;
       var fx_queue=new Object();
       var tg_queue=new Object();
       var is_first=true;
       var grid3 = Ext.ComponentQuery.query('grid#window_select_sxfsc_grid')[0];
       var store = grid3.getStore();
       var fxsxf_amt_count=0;
       var tgsxf_amt_count=0;
       for(var i =0;i<store.getCount();i++){
           var data=store.getAt(i).data //遍历每一行
           fx_queue[data.FX_SXF_AMT]=i;
           tg_queue[data.TG_SXF_AMT]=i;
           fxsxf_amt_count+=data.FX_SXF_AMT;
           tgsxf_amt_count+=data.TG_SXF_AMT;
           if(is_first){
               temp_min_fx=data.FX_SXF_AMT;
               temp_max_fx=data.FX_SXF_AMT;
               temp_min_tg=data.TG_SXF_AMT;
               temp_max_tg=data.TG_SXF_AMT;
               is_first=false;
           }else{
               if(data.FX_SXF_AMT<temp_min_fx){
                   temp_min_fx=data.FX_SXF_AMT;
               }else if(data.FX_SXF_AMT>temp_max_fx){
                   temp_max_fx=data.FX_SXF_AMT;
               }
               if(data.TG_SXF_AMT<temp_min_tg){
                   temp_min_tg=data.TG_SXF_AMT;
               }else if(data.TG_SXF_AMT>temp_max_tg){
                   temp_max_tg=data.TG_SXF_AMT;
               }
           }
       }
       fxsxf_amt=fxsxf_amt.toFixed(2);
       tgsxf_amt=tgsxf_amt.toFixed(2);
       fxsxf_amt_count=fxsxf_amt_count.toFixed(2);
       tgsxf_amt_count=tgsxf_amt_count.toFixed(2);
       if(fxsxf_amt_count!=fxsxf_amt){
           var index
           var cha= parseFloat(fxsxf_amt_count-fxsxf_amt);
          // store.getAt(index).data.FX_SXF_AMT_SW=cha;
         if(cha<0){
              index=fx_queue[temp_min_fx];
             store.getAt(index).set("FX_SXF_AMT_SW",cha)//data.FX_SXF_AMT_SW=;
              var var1=store.getAt(index).get("FX_SXF_AMT")//data.FX_SXF_AMT
              //store.getAt(index).data.FX_SXF_AMT_YZ=var1
             store.getAt(index).set("FX_SXF_AMT_YZ",var1);
             var var4=store.getAt(index).get("FX_SXF_AMT")
              store.getAt(index).set("FX_SXF_AMT",var4+Math.abs(cha))
         }else{
             index=fx_queue[temp_max_fx];
             store.getAt(index).set("FX_SXF_AMT_SW",cha)//.data.FX_SXF_AMT_SW=cha;
             var var2=store.getAt(index).get("FX_SXF_AMT")//data.FX_SXF_AMT;
             store.getAt(index).set("FX_SXF_AMT_YZ",var2);
             var var4=store.getAt(index).get("FX_SXF_AMT")
             store.getAt(index).set("FX_SXF_AMT",var4-Math.abs(cha));
         }
          // grid3.getView().getCell(index, 7).style.backgroundColor="#B0FFC5";
//           var tr = grid3.getView().getNode(index);
//           if(tr!=null&&tr!=''&&tr!=undefined){
//               var childNodes = tr.childNodes;
//               for(var i=0;i<childNodes.length;i++)
//               {
//                   var tdDiv = childNodes[i].childNodes[0].cells[5];
//                   tdDiv.style.backgroundColor = "#00ff00";
//               }
//           }
           changeColor(grid3,index,5,"#00ff00");
       }
       if(tgsxf_amt_count!=tgsxf_amt){
           var index;
           var cha= parseFloat(tgsxf_amt_count-tgsxf_amt);
           if(cha<0){
               index=tg_queue[temp_min_tg];
               store.getAt(index).set("TG_SXF_AMT_SW",cha)//data.TG_SXF_AMT_SW=cha;
               var hh=store.getAt(index).get("TG_SXF_AMT")//data.TG_SXF_AMT
              // store.getAt(index).data.TG_SXF_AMT_YZ=var1
               store.getAt(index).set("TG_SXF_AMT_YZ",hh);
               store.getAt(index).set("TG_SXF_AMT",hh+Math.abs(cha));
           }else{
               index=tg_queue[temp_max_tg];
               store.getAt(index).set("TG_SXF_AMT_SW",cha)//data.TG_SXF_AMT_SW=cha;
               var hh=store.getAt(index).get("TG_SXF_AMT")//data.TG_SXF_AMT;
              // store.getAt(index).data.TG_SXF_AMT_YZ=var2
               store.getAt(index).set("TG_SXF_AMT_YZ",hh);
               store.getAt(index).set("TG_SXF_AMT",hh-Math.abs(cha));
           }
          // grid3.getView().getCell(index, 8).style.backgroundColor="#B0FFC5";
           changeColor(grid3,index,6,"#00ff00");
//           var tr = grid3.getView().getNode(index);
//           if(tr!=null&&tr!=''&&tr!=undefined){
//               var childNodes = tr.childNodes;
//               for(var i=0;i<childNodes.length;i++)
//               {
//                   var tdDiv = childNodes[i].childNodes[0].cells[6];
//                   tdDiv.style.backgroundColor = "#00ff00";
//               }
//           }
       }
       is_fist_load_2=false;
       }

       function changeColor(grid3,index,cell,color) {
           var tr = grid3.getView().getNode(index);
           if(tr!=null&&tr!=''&&tr!=undefined){
               var childNodes = tr.childNodes;
               for(var i=0;i<childNodes.length;i++)
               {
                   var tdDiv = childNodes[i].childNodes[0].cells[cell];
                   tdDiv.style.backgroundColor = "#00ff00";
               }
           }
       }

  var is_fist_load=true;
    /**
     * 初始化手续费撤销生成弹出窗口
     */
    function initWindow_select_ssfcx(record) {
        return Ext.create('Ext.window.Window', {
            title: title_name + '手续费撤销', // 窗口标题
            width: document.body.clientWidth * 0.8, // 窗口宽度
            height: document.body.clientHeight * 0.8, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_select_ssfcx', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [
                initWindow_select_ssfcx_grid(record)
            ],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        var grid = btn.up('window').down('grid');
                        var records = grid.getSelection();
                        if (records == null || records.length <= 0) {
                            Ext.Msg.alert('提示', '无选中撤销数据！');
                            return false;
                        }
                        var gridData = [];
                        for (var i in records) {
                            gridData.push(records[i].data);

                        }
                        //发送ajax请求，撤销生成数据
                        $.post("/revokeSxfglSxfscxx.action", {
                            detailList: Ext.util.JSON.encode(gridData),
                            IS_DW: IS_DW
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_name + "成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                btn.up('window').close();
                            } else {
                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                            }
                            //刷新表格
                            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                        }, "json");
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
     * 初始化手续费撤销生成弹出窗口:grid表格
     */
    function initWindow_select_ssfcx_grid(record) {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {text: "地区编码", dataIndex: "AD_CODE", type: "string"},
            {text: "地区名称", dataIndex: "AD_NAME", type: "string", width: 150},
            {text: "转贷日期", dataIndex: "ZD_DATE", type: "string"},
            {text: "需承担利息费用金额", dataIndex: "CD_AMT", type: "float", width: 200},
            {text: "转贷金额", dataIndex: "ZD_AMT", type: "float", width: 200},
            {text: "发行手续费", dataIndex: "FXF_AMT", type: "float", width: 200},
            {text: "登记托管手续费", dataIndex: "TGF_AMT", type: "float", width: 200},
            {text: "明细ID", dataIndex: "ZD_DETAIL_ID", type: "string", width: 200},
            {
                text: "是否确认", dataIndex: "IS_CONFIRM", type: "string",
                renderer: function (value) {
                    return (value == '0') ? '否' : '是';
                }
            }
        ];
        var gridConfig = {
            itemId: 'window_select_sxfcx_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            dataUrl: 'getSxfglSxfscxxGridData.action',
            params: {
                ZD_ID: record.ZD_ID,
                IS_DW: IS_DW
            },
            selModel: {
                listeners: {
                    beforeselect: function (self, record, index) {
                        //禁止选中已确认行
                        if (record.data.IS_CONFIRM != '0') {
                            return false;
                        }
                    }
                }
            },
            border: false,
            checkBox: true,
            pageConfig: {
                enablePage: false
            },
            viewConfig: {
                getRowClass: function (record, rowIndex, rowParams) {
                    //已确认行背景色为灰色
                    if (record.data.IS_CONFIRM != '0') {
                        return "grid-row-disabled";
                    }
                }
            }
        };
        return DSYGrid.createGrid(gridConfig);
    }
    /**
     * 初始化查看详情弹出窗口
     */
    function initWindow_select_ssfck(record) {
        return Ext.create('Ext.window.Window', {
            title: '查看详情', // 窗口标题
            width: document.body.clientWidth * 0.8, // 窗口宽度
            height: document.body.clientHeight * 0.8, // 窗口高度
            layout: 'anchor',
            maximizable: true,
            itemId: 'window_select_sxfck', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [
                initWindow_select_ssfck_form(record),
                initWindow_select_ssfck_grid(record)
            ]
        });
    }
    /**
     * 初始化查看详情弹出窗口:form表单
     */
    function initWindow_select_ssfck_form(record) {
        var form = Ext.create('Ext.form.Panel', {
            itemId: 'window_select_sxfck_form',
            border: false,
            anchor: '100%',
            height: 150,
            layout: 'column',
            defaults: {
                margin: '5 5 5 5',
                columnWidth: .33,
                labelAlign: 'right',
                labelWidth: 105//控件默认标签宽度
            },
            items: [
                {fieldLabel: '债券代码', name: 'ZQ_CODE', xtype: 'textfield', readOnly: true},
                {fieldLabel: '债券名称', name: 'ZQ_NAME', xtype: 'textfield', readOnly: true},
                {fieldLabel: '债券期限', name: 'ZQQX_NAME', xtype: 'textfield', readOnly: true},
                {fieldLabel: '债券类型', name: 'ZQLB_NAME', xtype: 'textfield', readOnly: true},
                {fieldLabel: '转贷日期', name: 'ZD_DATE', xtype: 'textfield', readOnly: true},
                {
                    fieldLabel: '转贷金额', name: 'ZD_AMT', xtype: 'numberFieldFormat', readOnly: true,
                    fieldStyle: 'text-align:right;'
                },
                {
                    fieldLabel: '发行手续费率(‰)', name: 'FXSXF_RATE', xtype: 'numberfield', readOnly: true,
                    fieldStyle: 'text-align:right;'
                },
                {
                    fieldLabel: '登记托管费率(‰)', name: 'TGSXF_RATE', xtype: 'numberfield', readOnly: true,
                    fieldStyle: 'text-align:right;'
                },
                {
                    fieldLabel: '发行手续费总额', name: 'FXSXF_AMT', xtype: 'numberFieldFormat', readOnly: true,
                    fieldStyle: 'text-align:right;'
                },
                {
                    fieldLabel: '登记托管费总额', name: 'TGSXF_AMT', xtype: 'numberFieldFormat', readOnly: true,
                    fieldStyle: 'text-align:right;'
                },
                {
                	fieldLabel: '应上缴日期', name: 'PLAN_PAY_DATE_HX', xtype: 'textfield', readOnly: true
                }
            ]
        });
        if (record) {
            form.getForm().setValues(record);
        }
        return form;
    }
    /**
     * 初始化查看详情弹出窗口:grid表格
     */
    function initWindow_select_ssfck_grid(record) {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {text: "地区编码", dataIndex: "AD_CODE",hidden:true, type: "string",hidden:true},
            {text: "地区名称", dataIndex: "AD_NAME", type: "string", width: 150},
            {text: "转贷日期", dataIndex: "ZD_DATE", type: "string"},
            {text: "需承担本金金额", dataIndex: "CD_AMT", type: "float", width: 200},
            {text: "转贷金额", dataIndex: "ZD_AMT", type: "float", width: 200,hidden:true},
            {text: "发行手续费", dataIndex: "FXF_AMT", type: "float", width: 200},
            {text: "登记托管服务费", dataIndex: "TGF_AMT", type: "float", width: 200},
            {
                text: "是否确认", dataIndex: "IS_CONFIRM", type: "string",
                renderer: function (value) {
                    return (value == '0') ? '否' : '是';
                }
            }
        ];
        var gridConfig = {
            itemId: 'window_select_sxfck_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            dataUrl: 'getSxfglSxfscxxGridData.action',
            params: {
                ZD_ID: record.ZD_ID,
                IS_DW: IS_DW
            },
            border: false,
            checkBox: false,
            autoLoad: false,
            anchor: '100% -150',
            pageConfig: {
                enablePage: false
            }
        };
        var grid = DSYGrid.createGrid(gridConfig);
        //计算发行和托管手续费总金额
        grid.getStore().load({
            callback: function (records, operation, success) {
                var fxsxf_amt = 0;
                var tgsxf_amt = 0;
                for (var i in records) {
                    var record = records[i].data;
                    fxsxf_amt += parseFloat(record.FXF_AMT);
                    tgsxf_amt += parseFloat(record.TGF_AMT);
                }
                grid.up('window').down('form').down('numberFieldFormat[name=FXSXF_AMT]').setValue(fxsxf_amt);
                grid.up('window').down('form').down('numberFieldFormat[name=TGSXF_AMT]').setValue(tgsxf_amt);
            }
        });
        return grid;
    }


    //工具类,将new date获取的字符串转换为指定格式的字符串
    function format_date(date_value,fmt) { //author: meizz
        var o = {
            "M+": date_value.getMonth() + 1, //月份
            "d+": date_value.getDate(), //日
            "h+": date_value.getHours(), //小时
            "m+": date_value.getMinutes(), //分
            "s+": date_value.getSeconds(), //秒
            "q+": Math.floor((date_value.getMonth() + 3) / 3), //季度
            "S": date_value.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (date_value.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }

    /**
     * 校验当前转贷是否存在未确认的市县手续费
     */
    function checkIsConfirm(ZD_ID){
        var FLAG;
        $.ajax({
            type: "post",
            url: "/checkIsConfirmByZdId.action",
            async: false,
            dataType: 'json',
            data: {ZD_ID: ZD_ID},
            success: function(data){
                if (data.success) {
                    for(var res in data.list){
                        alert(res.ad_name);
                    }
                    Ext.MessageBox.alert('提示', '该笔转贷下级地区尚未确认，无法生成手续费！');
                    FLAG = false;
                } else if (data.exception){
                    Ext.MessageBox.alert('提示', '保存失败！' + data.message);
                    FLAG = false;
                } else {
                    FLAG = true;
                }
            }
        });
        return FLAG;
    }

</script>
</body>
</html>
