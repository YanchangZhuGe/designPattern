<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>单位还本付息确认</title>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    //获取登录用户
    var userAdCode = '${sessionScope.ADCODE}'.replace(/00$/, "");
 /*   var wf_id = getQueryParam("wf_id");
    var node_code = getQueryParam("node_code");*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var button_name = '';
  /*  var WF_STATUS = getQueryParam("WF_STATUS");
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var SYS_IS_QEHBFX = ''; //系统参数是否支持全额承担付息
    var hkId = '';
    // 偿还资金来源
    var store_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: " and (code in ('01','0101') or code like '0102%')"});
    //还款单和还款单明细表头
    var HEADERJSON_HKD = [
        {
            xtype: 'rownumberer', width: 40,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "单位", dataIndex: "AG_NAME", width: 150, type: "string"},
        {text: "还款日期", dataIndex: "HK_DATE", width: 150, type: "string"},
        {
            text: "还款总金额(元)", dataIndex: "HK_AMT", width: 150, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "本金还款总金额(元)", dataIndex: "BJ_HK_AMT", width: 220, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "利息还款总金额(元)", dataIndex: "LX_HK_AMT", width: 260, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "兑付费金额(元)", dataIndex: "HK_DFF_AMT", width: 150, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "备注", dataIndex: "REMARK", width: 250, type: "string"},
        {text: "是否确认", dataIndex: "IS_CONFIRM", type: "int", hidden: true}
    ];
    var HEADERJSON_HKDMX = [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: '操作标识', dataIndex: "FLAG_EDIT", type: "string", hidden: true},
        {text: '还款单id', dataIndex: "HKD_ID", type: "string", hidden: true},
        {text: '还款计划id', dataIndex: "HK_ID", type: "string", hidden: true},
        {text: '债券id', dataIndex: "ZQ_ID", type: "string", hidden: true},
        {text: '兑付计划id', dataIndex: "DF_PLAN_ID", type: "string", hidden: true},
        {text: '还款类型', dataIndex: "PLAN_TYPE", type: "string", hidden: true},
        {text: '还款类型', dataIndex: "HK_TYPE", type: "string", hidden: true},
        {text: '地区编码', dataIndex: "AD_CODE", type: "string", hidden: true},
        {text: '债券id', dataIndex: "ZQ_ID", type: "string", hidden: true},
        {text: "还款日期", dataIndex: "HK_DATE", type: "string", hidden: true},
        {text: '备注', dataIndex: "REMARK", type: "string", hidden: true},
        {text: "还款总金额(元)", dataIndex: "TOTAL_PAY_AMT", type: "float", hidden: true},
        /*{
            text: "还款单号", dataIndex: "HK_NO", width: 150, type: "string", headerMark: 'star',
            editor: {name: "HK_NO", xtype: 'textfield', allowBlank: false}
        },*/
        {
            text: "还款金额(元)", dataIndex: "HK_HK_AMT", width: 180, type: "float", summaryType: 'sum', headerMark: 'star',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            editor: {name: "HK_HK_AMT", xtype: "numberFieldFormat", decimalPrecision: 2}
        },
        {
            text: "兑付费金额(元)", dataIndex: "HK_DFF_AMT", width: 180, type: "float", summaryType: 'sum', headerMark: 'star',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            editor: {name: "HK_DFF_AMT", xtype: "numberFieldFormat", decimalPrecision: 2}
        },
        {
            text: "偿还资金来源", dataIndex: "ZJLY_ID", width: 250, type: "string", headerMark: 'star',
            renderer: function (value, cell, record) {
                var rec = store_ZJLY.findNode('code', value, true, true, true);
                return rec != null ? rec.get('name') : value;
            },
            editor: {
                xtype: 'treecombobox',
                store: store_ZJLY,
                selectModel: 'leaf',
                displayField: 'name',
                valueField: 'code',
                editable: false,
                allowBlank: false
            }
        },
        {text: '还款类型', dataIndex: "PLAN_TYPE_NAME", type: "string", tdCls: 'grid-cell-unedit'},
        {text: '剩余应还金额(元)', dataIndex: "SYYH_AMT",summaryType:'sum', width: 180, type: "float", tdCls: 'grid-cell-unedit',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: '剩余兑付费金额(元)', dataIndex: "SYDFF_AMT", summaryType:'sum',width: 180, type: "float", tdCls: 'grid-cell-unedit',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: '应还款日期', dataIndex: "DF_END_DATE", width: 120, type: "string", tdCls: 'grid-cell-unedit'},
        {
            text: '兑付手续费率(‰)', dataIndex: "DFSXF_RATE", width: 150, type: "float", tdCls: 'grid-cell-unedit',
            renderer: function (value, cell, reocrd) {
                return Ext.util.Format.number(value * 10, '0,000.######');
            }
        },
        {text: '债券编码', dataIndex: "ZQ_CODE", type: "string", tdCls: 'grid-cell-unedit'},
        {text: '债券名称', dataIndex: "ZQ_NAME", width:250, type: "string", tdCls: 'grid-cell-unedit'},
        {text: '债券期限', dataIndex: "ZQQX_NAME", type: "string", tdCls: 'grid-cell-unedit'},
        {text: '债券类型', dataIndex: "ZQLB_NAME", type: "string", tdCls: 'grid-cell-unedit'},
        {text: '转贷金额(元)', dataIndex: "ZD_AMT", type: "float", width: 180, tdCls: 'grid-cell-unedit'},
        {text: '承担金额(元)', dataIndex: "CDBJ_AMT", type: "float", summaryType:'sum',width: 180, tdCls: 'grid-cell-unedit', hidden: SYS_IS_QEHBFX == 0,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: '债券到期日', dataIndex: "DQDF_DATE", type: "string", tdCls: 'grid-cell-unedit', hidden: SYS_IS_QEHBFX == 1}
    ];
    var HEADERJSON_ZBMXB=[
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: '操作标识', dataIndex: "FLAG_EDIT", type: "string", hidden: true},
        {text: '还款单id', dataIndex: "HKD_ID", type: "string", hidden: true},
        {text: '还款计划id', dataIndex: "HK_ID", type: "string", hidden: true},
        {text: '债券id', dataIndex: "ZQ_ID", type: "string", hidden: true},
        {text: '兑付计划id', dataIndex: "DF_PLAN_ID", type: "string", hidden: true},
        {text: '还款类型', dataIndex: "PLAN_TYPE", type: "string", hidden: true},
        {text: '还款类型', dataIndex: "HK_TYPE", type: "string", hidden: true},
        {text: '单位编码', dataIndex: "AG_CODE", type: "string", hidden: true},
        {text: '债券id', dataIndex: "ZQ_ID", type: "string", hidden: true},
        {text: "还款日期", dataIndex: "HK_DATE", type: "string", hidden: true},
        {text: '备注', dataIndex: "REMARK", type: "string", hidden: true},
        {text: "还款总金额(元)", dataIndex: "TOTAL_PAY_AMT", type: "float", summaryType: 'sum',hidden: true},
        {text: "还款单号", dataIndex: "HK_NO", width: 150, type: "string"},
        {text: "还款金额(元)", dataIndex: "HK_HK_AMT", width: 180, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "兑付费金额(元)", dataIndex: "HK_DFF_AMT", width: 180, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "偿还资金来源", dataIndex: "ZJLY_NAME", width: 250, type: "string"},
        {text: '还款类型', dataIndex: "PLAN_TYPE_NAME", type: "string"},
        {text: '剩余应还金额(元)', dataIndex: "SYYH_AMT", width: 180, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: '剩余兑付费金额(元)', dataIndex: "SYDFF_AMT", width: 180, type: "float", summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: '应还款日期', dataIndex: "DF_END_DATE", width: 120, type: "string"},
        {text: '兑付手续费率(‰)', dataIndex: "DFSXF_RATE", width: 150, type: "float",
            renderer: function (value, cell, reocrd) {
                return Ext.util.Format.number(value * 10, '0,000.######');
            }
        },
        {text: '债券编码', dataIndex: "ZQ_CODE", type: "string"},
        {text: '债券名称', dataIndex: "ZQ_NAME", type: "string",width:250,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + userAdCode;
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="ZQ_ID";
                paramNames[1]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1]=encodeURIComponent(userAdCode);
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {text: '债券期限', dataIndex: "ZQQX_NAME", type: "string"},
        {text: '债券类型', dataIndex: "ZQLB_NAME", type: "string"},
        {text: '转贷金额(元)', dataIndex: "ZD_AMT", type: "float", width: 180},
        {text: '承担金额(元)', dataIndex: "CDBJ_AMT", type: "float", summaryType: 'sum', width: 180, hidden: SYS_IS_QEHBFX == 0,
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: '债券到期日', dataIndex: "DQDF_DATE", type: "string", hidden: SYS_IS_QEHBFX == 1}
    ];
    //全局变量
    //提前获取以下store，弹出框中使用，表格中使用
    /**
     * 通用配置json
     */
    var zdhk_json_common = {
        items: {
            '001': [{
                xtype: 'button',
                text: '查询',
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
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length > 1) {
                            Ext.MessageBox.alert('提示', '只能选择一条数据');
                            return;
                        }else if(records.length ==1){
                            Sure_ZDHK_windows(records);
                        }else{
                            Ext.MessageBox.alert('提示', '请选择一条数据');
                            return;
                        }

                    }
                },
                {
                    xtype: 'button',
                    text: '退回',
                    name: 'back',
                    icon: '/image/sysbutton/back.png',
                    handler: function (btn) {
                        doWorkFlow(btn);
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ],
            '002': [{
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
     * 获取url参数或者查询字符串中的参数
     * @param name 查询字段
     * @param queryString 被查询字符串
     * @returns {Array|{index: number, input: string}|string}
     */
    function getQueryParam(name, queryString) {
        var match = new RegExp(name + '=([^&]*)').exec(queryString || location.search);
        return match && decodeURIComponent(match[1]);
    }

    function Sure_ZDHK_windows(record) {
        IS_VIEW = true;
        //发送ajax请求，查询主表和明细表数据
        $.post("/getDwHbfxMxGridData.action", {
            HKD_ID: record[0].get('HKD_ID')
        }, function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示', '加载失败！' + data.message);
                return;
            }
            //弹出填报页面，并写入债券信息以及明细信息
            var window_input = initWin_Sure_Date();
            window_input.show();
            window_input.down('form').getForm().setValues(data.list[0]);
            window_input.down('#win_input_tab_mxgrid').insertData(null, data.list);
        }, "json");
    }

    function initWin_Sure_Date() {
        var config = {
            title: '转贷还款', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'vbox',
            maximizable: true,
            itemId: 'window_input', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWin_Sure_Date_form(), initWin_input_tab()],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        var form = btn.up('window').down('form');
                        if(!form.isValid()){
                            Ext.toast({
                                html: "录入数据未通过校验，请检查!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }
                        if (!form.down('[name=HK_DZ_DATE]').getValue()) {
                            Ext.Msg.alert('提示', '实际到账日期不能为空！');
                            return false;
                        }else{
                            if(form.down('[name=HK_DZ_DATE]').getValue()>new Date()){
                                Ext.Msg.alert('提示', '实际到账日期不能大于现在日期！');
                                return false;
                            }
                        }

                        var HK_DZ_DATE=form.down('[name=HK_DZ_DATE]').getValue();
                        doWorkFlow_DZDATE(btn,HK_DZ_DATE);
                    }
                },
                {
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        };
        return Ext.create('Ext.window.Window', config);
    }
    /**
     * 初始化债券转贷表单
     */
    function initWin_Sure_Date_form() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            layout: 'column',
            defaults: {
                columnWidth: .33,
                margin: '5 5 5 5',
                readOnly: true,
                fieldCls: 'form-unedit',
                labelWidth: 135//控件默认标签宽度
            },
            defaultType: 'textfield',
            items: [
                {fieldLabel: '支付总金额(元)', xtype: "numberFieldFormat", name: "TOTAL_PAY_AMT", hideTrigger: true,  readOnly: true,
                    editable: false,
                    fieldCls: 'form-unedit-number'},
                {fieldLabel: '支付本金总金额(元)', xtype: "numberFieldFormat", name: "TOTAL_BJ_PAY_AMT", hideTrigger: true,  readOnly: true,
                    editable: false,
                    fieldCls: 'form-unedit-number'},
                {fieldLabel: '支付利息总金额(元)', xtype: "numberFieldFormat", name: "TOTAL_LX_PAY_AMT", hideTrigger: true, readOnly: true,
                    editable: false,
                    fieldCls: 'form-unedit-number'},
                {fieldLabel: '兑付费总金额(元)', xtype: "numberFieldFormat", name: "HK_DFF_AMT", hideTrigger: true, fieldCls: 'form-unedit-number'},
                {
                    fieldLabel: '<span class="required">✶</span>实际到账日期',
                    name: "HK_DZ_DATE",
                    xtype: "datefield",
                    allowBlank: false,
                    readOnly: false,
                    format: 'Y-m-d',
                    fieldCls: null,
                    blankText: '请选择还款日期',
                    value: new Date(),
                    listeners: {
                    }
                },
                {
                    fieldLabel: "<span class=\"required\">✶</span>还款单号",
                    name: "HK_NO", width: 150,
                    maxLength:20,//限制输入字数
                    maxLengthText:"输入内容过长！",
                    editable: false,
                    fieldCls: 'form-unedit'
                },
                {
                    fieldLabel: '备注',
                    name: "REMARK",
                    columnWidth: .66,
                    readOnly: true,
                    editable: false,
                    fieldCls: 'form-unedit',
                    listeners: {
                        change: function (self, newValue, oldValue) {
                            //下方表格中所有还款日期设置为该日期
                            var store = self.up('window').down('grid#win_input_tab_mxgrid').getStore();
                            store.each(function (record) {
                                record.set('REMARK', newValue);
                            });
                        }
                    }
                }
            ]
        });
    }
    /**
     * 初始化转贷还款弹出框：下部页签panel
     */
    function initWin_input_tab() {
        return Ext.create('Ext.tab.Panel', {
            width: '100%',
            flex: 1,
            items: [
                {
                    title: '明细情况',
                    layout: 'fit',
                    scrollable: true,
                    items: initWin_input_tab_mxgrid()
                },
                {
                    title: '明细附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                    layout: 'fit',
                    items: [
                        {
                            xtype: 'panel',
                            layout: 'fit',
                            items: initWin_input_tab_upload(hkId)
                        }
                    ],
                    listeners: {
                        beforeactivate: function (self) {
                            // 检验明细是否有数据
                            var grid = self.up('tabpanel').down('grid#win_input_tab_mxgrid');
                            if (grid.getStore().getCount() <= 0) {
                                Ext.MessageBox.alert('提示', '单据明细表格无数据！');
                                return false;
                            }
                            // 获取选中数据
                            var record = grid.getCurrentRecord();
                            //如果当前无选中行，默认选中第一条数据
                            if (!record) {
                                $(grid.getView().getRow(0)).parents('table[data-recordindex=0]').addClass('x-grid-item-click');
                                record = grid.getStore().getAt(0);
                                Ext.toast({
                                    html: "单据明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            }
                            var panel = self.down('panel');
                            panel.removeAll(true);
                            panel.add(initWin_input_tab_upload(record.get('HK_ID')));
                        }
                    }
                }
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initWin_input_tab_mxgrid() {
        var headerJson = HEADERJSON_HKDMX;
        var config = {
            itemId: 'win_input_tab_mxgrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code,
                DQ_YEAR: '',
                DQ_MO: ''
            },
            data: [],
            checkBox: true,
            border: false,
            height: '100%',
            pageConfig: {
                enablePage: false,
                pageNum: true//设置显示每页条数
            },
            features: [{
                ftype: 'summary'
            }],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'cellEdit',
                    clicksToMoveEditor: 1,
                    listeners: {

                        'beforeedit': function (editor, context) {
                        },
                        'validateedit': function (editor, context) {

                        },
                        'edit': function (editor, context) {
                            if (context.field == 'HK_HK_AMT') {
                                //计算兑付费金额
                                var dfsxf_rate = context.record.get('DFSXF_RATE');
                                var dff_amt = context.value * dfsxf_rate / 100;
                                if (context.record.get('SYDFF_AMT') > 0) {
                                    context.record.set('HK_DFF_AMT', dff_amt);
                                }
                                context.record.set('TOTAL_PAY_AMT', context.record.get('HK_HK_AMT') + context.record.get('HK_DFF_AMT'));
                            }
                            if (context.field == 'HK_DFF_AMT') {
                                context.record.set('TOTAL_PAY_AMT', context.record.get('HK_HK_AMT') + context.record.get('HK_DFF_AMT'));
                            }
                        }

                    }
                }
            ],
            listeners: {
                selectionchange: function (self, records) {
                    if (grid.up('window').down('[name=delete_editGrid]')) {
                        grid.up('window').down('[name=delete_editGrid]').setDisabled(!records.length);
                    }
                }
            }
        };
        if (IS_VIEW) {
            delete config.plugins;
        }
        var grid = DSYGrid.createGrid(config);
        grid.getStore().on('endupdate', function () {
            //计算录入窗口form当年申请金额
            var self = grid.getStore();
            var sum_RMB = 0;
            var sum_RMB_BJ = 0;
            var sum_RMB_LX = 0;
            self.each(function (record) {
                sum_RMB += record.get('HK_HK_AMT') + record.get('HK_DFF_AMT');
                if (record.get('PLAN_TYPE') == '0') {
                    sum_RMB_BJ += record.get('HK_HK_AMT')
                }
                if (record.get('PLAN_TYPE') == '1') {
                    sum_RMB_LX += record.get('HK_HK_AMT') + record.get('HK_DFF_AMT');
                }
            });
            grid.up('window').down('form').down('[name=TOTAL_PAY_AMT]').setValue(sum_RMB);
            grid.up('window').down('form').down('[name=TOTAL_BJ_PAY_AMT]').setValue(sum_RMB_BJ);
            grid.up('window').down('form').down('[name=TOTAL_LX_PAY_AMT]').setValue(sum_RMB_LX);
        });

        return grid;
    }
    /**
     * 初始化填报表单中的附件
     */
    function initWin_input_tab_upload(hkId) {
        var grid = UploadPanel.createGrid({
            busiType: 'ET204',//业务类型
            busiId: hkId,//业务ID
            editable: !IS_VIEW,
            gridConfig: {
                itemId: 'win_input_tab_upload_grid'
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
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else if ($('span.file_sum')) {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
    }
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        $.post("getParamValueAll.action", function (data) {
            SYS_IS_QEHBFX = data[0].SYS_IS_QEHBFX;
            IS_CONFIRMHK_BY_AUDIT = data[0].IS_CONFIRMHK_BY_AUDIT;
            initContent();
        },"json");
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
                    items: zdhk_json_common.items[WF_STATUS]//根据当前状态切换显示按钮
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
        var headerJson = HEADERJSON_HKD;
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
                SET_YEAR: ''
            },
            features: [{
                ftype: 'summary'
            }],
            dataUrl: 'getDwHbFxConfirmMainGridData.action',
            checkBox: true,
            border: false,
            autoLoad: true,
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: zdhk_json_common.store['WF_STATUS'],
                    //store: DebtEleStore(json_debt_zt3),
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
                            toolbar.add(zdhk_json_common.items[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                },
                {
                    xtype: "datefield",
                    fieldLabel: '还款日期',
                    format: 'Y-m-d',
                    name: 'sdate',
                    width: 163,
                    labelWidth: 58,
                    labelAlign: 'right',
                    editable: false,
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = Ext.util.Format.date(newValue,'Y-m-d');
                            //self.up('grid').getStore().loadPage(1);
                        }
                    }
                },
                {
                    xtype: "datefield",
                    fieldLabel: '至',
                    format: 'Y-m-d',
                    name: 'edate',
                    width: 125,
                    labelWidth: 20,
                    labelAlign: 'right',
                    editable: false,
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = Ext.util.Format.date(newValue,'Y-m-d');
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                },
                {
                    xtype: 'combobox',
                    fieldLabel: '还款类型',
                    name: 'lxgi',
                    store: DebtEleStore(json_debt_hklx),
                    width: 200,
                    labelWidth: 60,
                    labelAlign: 'right',
                    editable: false, //禁用编辑
                    displayField: "name",
                    valueField: "id",
                    allowBlank: true,
                    hidden: true,
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                }
            ],
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            listeners: {
                itemdblclick: function (self, record) {
                    IS_VIEW = true;
                    //发送ajax请求，查询主表和明细表数据
                    $.post("/getDwHbfxMxGridData.action", {
                        HKD_ID: record.get('HKD_ID')
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '加载失败！' + data.message);
                            return;
                        }
                        //弹出填报页面，并写入债券信息以及明细信息
                        var window_input = initWin_input();
                        window_input.show();
                        window_input.down('form').getForm().setValues(data.list[0]);
                        window_input.down('#win_input_tab_mxgrid').insertData(null, data.list);
                    }, "json");
                },
                itemclick: function (self, record) {
                    DSYGrid.getGrid('contentDetilGrid').getStore().getProxy().extraParams['HKD_ID'] = record.get('HKD_ID');
                    DSYGrid.getGrid('contentDetilGrid').getStore().loadPage(1);
                }
            }
        });
    }
    /**
     * 初始化主表明细表
     */
    function initContentDetilGrid(callback) {
        var config = {
            itemId: 'contentDetilGrid',
            headerConfig: {
                headerJson: HEADERJSON_ZBMXB,
                columnAutoWidth: false
            },
            flex: 1,
            dataUrl: '/getDwHbfxMxGridData.action',
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '100%',
            pageConfig: {
                enablePage: false,
                pageNum: true//设置显示每页条数
            },
            features: [{
                ftype: 'summary'
            }]
        };
        var grid = DSYGrid.createGrid(config);
        return grid;
    }
    //清空明细表
    function clearmxgrid(){
        var mxgrid =DSYGrid.getGrid('contentDetilGrid').getStore();
        mxgrid.removeAll();
    }
    function doWorkFlow_DZDATE(btn,dz_date) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        var hbfxInfoArray = [];
        for (var i in records) {
            ids.push(records[i].get("HKD_ID"));
            var array = {};
            array.HK_DATE = records[i].get("HK_DATE");
            array.AD_CODE = records[i].get("AD_CODE");
            array.ID = records[i].get("HKD_ID");
            hbfxInfoArray.push(array);
        }
        button_name = btn.text;
        //弹出对话框
        Ext.Msg.confirm("提示", "是否" + button_name + "?", function (op) {
            if (op == 'yes') {
                $.post("/confirmDwHbfxNode.action", {
                    workflow_direction: btn.name,
                    button_name: button_name,
                    ids: ids,
                    wf_id: wf_id,
                    node_code: node_code,
                    hbfxInfoArray: Ext.util.JSON.encode(hbfxInfoArray),
                    HK_DZ_DATE:dz_date.getFullYear() + '-' + (dz_date.getMonth() + 1) + '-' + dz_date.getDate()
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
                        reloadGrid();    //刷新表格
                    } else {
                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    }
                }, "json");
            } else {
                return;
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
        var hbfxInfoArray = [];
        for (var i in records) {
            ids.push(records[i].get("HKD_ID"));
            var array = {};
            array.HK_DATE = records[i].get("HK_DATE");
            array.AD_CODE = records[i].get("AD_CODE");
            array.ID = records[i].get("HKD_ID");
            hbfxInfoArray.push(array);
        }
        button_name = btn.text;
        if (button_name == '退回') {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text + "意见",
                animateTarget: btn,
                value: '',
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("/confirmDwHbfxNode.action", {
                            workflow_direction: btn.name,
                            button_name: button_name,
                            ids: ids,
                            audit_info: text,
                            wf_id: wf_id,
                            node_code: node_code,
                            hbfxInfoArray: Ext.util.JSON.encode(hbfxInfoArray)
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_name + "成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                //刷新表格
                                reloadGrid();
                            } else {
                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                            }
                        }, "json");
                    } else {
                        return;
                    }
                }
            });
        }else {
            //弹出对话框
            Ext.Msg.confirm("提示", "是否" + button_name + "?", function (op) {
                if (op == 'yes') {
                    $.post("/confirmDwHbfxNode.action", {
                        workflow_direction: btn.name,
                        button_name: button_name,
                        ids: ids,
                        wf_id: wf_id,
                        node_code: node_code,
                        hbfxInfoArray: Ext.util.JSON.encode(hbfxInfoArray)
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //刷新表格
                            reloadGrid();
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }
                    }, "json");
                } else {
                    return;
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

    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid() {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        //AG_CODE 由单位树获取
        store.getProxy().extraParams['AG_CODE'] = AG_CODE;
        store.removeAll();
        //刷新
        store.loadPage(1);
        //明细表刷新
        clearmxgrid();
    }
</script>
</body>
</html>