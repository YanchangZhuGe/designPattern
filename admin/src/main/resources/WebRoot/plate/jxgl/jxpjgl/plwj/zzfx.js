//var is_fxjh=HAVE_SFJG=='1'?'3':HAVE_SFJG=='2'?'1':'0';
/**
 * 初始化
 */
$(document).ready(function () {
    initContent();
    initButton();

});
var store_tgzt= DebtEleStore([
    {id: '0', name: '未评审'},
    {id: '1', name: '已通过'},
    {id: '2', name: '未通过'}
]);
var IS_ZZ = 0;
var BILL_YEAR =  new Date().getFullYear();
var sbpc_store=DebtEleTreeStoreDB('DEBT_FXPC',{condition:" and year = '"+BILL_YEAR+"' "
+" AND (EXTEND1 like '01'||'%' OR EXTEND1 IS NULL )"
+" and (EXTEND2 IS NULL OR EXTEND2 = '"+((is_fxjh=='1')?"1":is_fxjh=='3'?"3":"0")+"')"});

/**
 * 初始化主界面
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
        tbar: [
            {
                text: '查询',
                name: 'search',
                xtype: 'button',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadGrid();
                }
            },
            {
                text: '通过',
                name: 'btn_pass',
                xtype: 'button',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    //updateIszz(btn);
                    doWorkFlow(btn);
                }
            },
            {
                text: '取消通过',
                name: 'btn_qxpass',
                xtype: 'button',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    //updateIszz(btn);
                    doWorkFlow(btn);
                }
            },
            {
                text: '不通过',
                name: 'btn_zz',
                xtype: 'button',
                hidden : true,
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                   // updateIszz(btn);
                    doWorkFlow(btn);
                }
            },{
                text: '取消终止',
                name: 'btn_qxzz',
                xtype: 'button',
                icon: '/image/sysbutton/audit.png',
                handler: function (btn) {
                    //updateIszz(btn);
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],

        items: [
            initContentTree(), //初始化左侧树
            initRightContentPanel()//初始化主表单
        ]
    });
}

var iszz_store =  DebtEleStore([
    {
        name: '未审核',
        value: 0
    },
    {
        name: '已通过',
        value: 1
    },
  /*  {
        name: '不通过',
        value: 2
    }*/
]);
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
 * 填写意见
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
        ids.push(records[i].get("XM_ID"));
    }
    //弹出意见填写对话框
    initWindow_opinion({
        title: btn.text,
        animateTarget: btn,
        value: btn.name == 'down' ? '同意' : null,
        fn: function (buttonId, text) {
            if (buttonId === 'ok') {
                btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
                updateIszz(btn,text);

            }
        }
    });
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
        fuc_getWorkFlowLog(records[0].get("ID"),sys_right_model=='1'&&((HAVE_SFJG=='1'&&is_fxjh=='3')
            ||(HAVE_SFJG=='2'&&is_fxjh=='1')||(HAVE_SFJG=='3'&&(is_fxjh=='1'||is_fxjh=='3'))||is_fxjh=='0')?'BRANCH':'');
    }
}
/**
 * 初始化页面主要内容区域
 */
function initRightContentPanel() {
    /**
     * 初始化右侧panel
     */return Ext.create('Ext.form.Panel', {
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    layout: {
                        type: 'column'
                    },
                    border: true,
                    bodyStyle: 'padding:0 0 0 0',//'border-width:0 0 0 0;',
                    defaults: {
                        margin: '8 1 15 5',
                        width: 250,
                        labelWidth: 60,//控件默认标签宽度
                        labelAlign: 'left'//控件默认标签对齐方式
                    },
                    items: [
                      /*  {
                            xtype: "combobox",
                            fieldLabel: '状态',
                            store: iszz_store,
                            displayField: "name",
                            valueField: "value",
                            value: IS_ZZ,
                            editable: false,
                            allowBlank: false,
                            listeners: {
                                select: function (self, newValue) {
                                    IS_ZZ = this.value;
                                    initButton();
                                    reloadGrid();
                                }
                            }
                        },*/
                        // {
                        //     xtype: 'treecombobox',
                        //     fieldLabel: '项目性质',
                        //     itemId: 'XMXZ_SEARCH',
                        //     displayField: 'name',
                        //     valueField: 'code',
                        //     rootVisible: true,
                        //     lines: false,
                        //     selectModel: 'all',
                        //     store: DebtEleTreeStoreDB("DEBT_ZJYT"),// {condition: xmxzCondition}
                        //     listeners: {
                        //         select: function (btn,newValue, oldValue) {
                        //             //刷新当前表格
                        //             loadOption={};
                        //             getHbfxDataList();
                        //         }
                        //     }
                        // },
                        // {
                        //     xtype: 'treecombobox',
                        //     fieldLabel: '项目类型',
                        //     itemId: 'XMLX_SEARCH',
                        //     displayField: 'name',
                        //     valueField: 'code',
                        //     rootVisible: true,
                        //     lines: false,
                        //     selectModel: 'all',
                        //     typeAhead:false,//不可编辑
                        //     editable:false,
                        //     store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                        //     listeners: {
                        //         select: function (btn) {
                        //             reloadGrid();
                        //         }
                        //     }
                        // },
                        // {
                        //     xtype: "treecombobox",
                        //     itemId:'SBBATCH_NO',
                        //     fieldLabel: '申报批次',
                        //     labelWidth: 60,
                        //     width: 280,
                        //     store: DebtEleTreeStoreDB('DEBT_FXPC',{condition:" and (code not like '98%') "}),//过滤需求库批次
                        //     displayField: 'name',
                        //     valueField: 'id',
                        //     lines: false,
                        //     editable: false, //禁用编辑
                        //     allowBlank: false,
                        //     listeners: {
                        //         select: function (btn) {
                        //             reloadGrid();
                        //         }
                        //     }
                        // },
                        // {
                        //     xtype: "combobox",
                        //     itemId: "JSXZ_SEARCH",
                        //     store: DebtEleStoreDB("DEBT_XMJSXZ"),
                        //     fieldLabel: '建设性质',
                        //     displayField: 'name',
                        //     valueField: 'id',
                        //     editable: false,
                        //     listeners: {
                        //         select: function (btn) {
                        //             //刷新当前表格
                        //             loadOption={};
                        //             getHbfxDataList();
                        //         }
                        //     }
                        // },
                        {
                            xtype: "combobox",
                            itemId: "LXND_SEARCH",   //项目立项年度
                            //20200915 fzd 不控制过滤年度上限
                            store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2000' "}),
                            fieldLabel: '申报年度',
                            displayField: 'name',
                            valueField: 'id',
                            value:  new Date().getFullYear(),
                            editable: false,
                            allowBlank: true,
                            listeners: {
                                select: function (btn) {
                                    BILL_YEAR = this.value;
                                    //更新批次
                                    sbpc_store.proxy.extraParams['condition'] = encode64(" and year = '"+BILL_YEAR+"' "
                                        +" AND (EXTEND1 like '01'||'%' OR EXTEND1 IS NULL )"
                                        +" and (EXTEND2 IS NULL OR EXTEND2 = '"+((is_fxjh=='1')?"1":is_fxjh=='3'?"3":"0")+"')");
                                    sbpc_store.load();
                                    reloadGrid();
                                }
                            }
                        }, {
                            xtype: 'combobox',
                            fieldLabel: '专家终审状态',
                            name: 'IS_ZJZSWTG',
                            displayField: 'name',
                            valueField: 'id',
                            editable: false,
                            allowBlank: true,
                            hidden: is_zj=='1'?false:true,
                            flex: 1,
                            autoLoad: false,
                            selectModel: "leaf",
                            store:store_tgzt,
                            hidden :true,//隐藏
                            listeners: {
                                'change': function (self, newValue) {
                                    is_zjzswtg=newValue;
                                    reloadGrid({
                                        IS_ZJZSWTG: is_zjzswtg
                                    });
                                }
                            }
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '模糊查询',
                            itemId: "xek_mh_sel",
                            // width: 507,    //762
                            // labelWidth: 80,
                            emptyText: '项目编码/名称...',
                            enableKeyEvents: true
                        },{
                            xtype: 'treecombobox',
                            fieldLabel: '申报批次',
                            displayField: 'name',
                            valueField: 'id',
                            itemId: 'SBBATCH_NO',
                            store: sbpc_store,
                            editable: false,
                            labelWidth: 70,
                            //20200915 fzd 只有13、42区划下显示过滤条件
                            // 只在区划为13或者42时申报批次不隐藏
                            hidden:((is_fxjh==1||is_fxjh==4)&&!(sys_right_model=='1'))
                                || (is_fxjh==3 && GxdzUrlParam == ELE_AD_CODE )?false:true,
                            labelAlign: 'right',
                            listeners: {
                                'change': function (self, newValue) {
                                    if(is_fxjh=='1'||is_fxjh=='3'||is_fxjh=='4'){
                                        reloadGrid({
                                            SBBATCH_NO: newValue
                                        });
                                    }else {
                                        reloadGrid({
                                            BATCH_NO: newValue
                                        });
                                    }

                                }
                            }
                        },{
                            xtype: 'treecombobox',
                            fieldLabel: '债券类型',
                            displayField: 'name',
                            valueField: 'id',
                            name: 'BOND_TYPE_ID',
                            store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                            editable: false,
                            labelWidth: 70,
                            labelAlign: 'right',
                            listeners: {
                                'change': function (self, newValue) {
                                    BATCH_BOND_TYPE_ID=newValue;
                                    reloadGrid({
                                        bond_type_id:newValue
                                    });
                                }
                            }
                        }
                    ]
                }
            ],
            items: initContentGrid()
        });

}
var item=   {
    xtype: "combobox",
    fieldLabel: '状态',
    store: iszz_store,
    displayField: "name",
    valueField: "value",
    value: IS_ZZ,
    editable: false,
    allowBlank: false,
    listeners: {
        select: function (self, newValue) {
            IS_ZZ = this.value;
            initButton();
            reloadGrid();
        }
    },

}

function initButton(){
    var btn_zz = Ext.ComponentQuery.query('button[name="btn_zz"]')[0];
    var btn_qxzz = Ext.ComponentQuery.query('button[name="btn_qxzz"]')[0];
    var btn_pass = Ext.ComponentQuery.query('button[name="btn_pass"]')[0];
    var btn_qxpass = Ext.ComponentQuery.query('button[name="btn_qxpass"]')[0];
    if(IS_ZZ == 0){
        // btn_zz.show();
        btn_pass.show();
        btn_qxzz.hide();
        btn_qxpass.hide();
    }else if(IS_ZZ == 1){
        btn_zz.hide(true);
        btn_pass.hide();
        btn_qxzz.hide();
        btn_qxpass.show();
    }else{
        btn_zz.hide(true);
        btn_pass.hide();
        btn_qxzz.show();
        btn_qxpass.hide();
    }
}



/**
 * 新增债券表头信息
 */
var HEADERJSON = [
    {
        xtype: 'rownumberer', width: 45,
        summaryRenderer: function () {
            return '合计';
        }
    },
    {dataIndex: "ID", width: 150, type: "string", text: "唯一ID", hidden: true},
    {dataIndex: "XM_ID", width: 150, type: "string", text: "项目ID", hidden: true},
    {dataIndex: "SCORE_SUM", width: 120, type: "string", text: "专家评审得分",hidden: is_zj=='1'&& sysAdcode!='21' ? false:true},
    {dataIndex: "PSZT", width: 120, type: "string", text: "是否满足发债要求",hidden: sysAdcode =='21'? false:true},//20211111liyue辽宁要求将专家评审得分修改为是否满足发债要求，此列只有辽宁显示
    {dataIndex: "AD_CODE", width: 90, type: "string", text: "区划编码"},
    {dataIndex: "AD_NAME", width: 90, type: "string", text: "区划名称"},
    {dataIndex: "AG_NAME", width: 250, type: "string", text: "申报单位"},
//        {dataIndex: "XM_ID", width: 150, type: "string", text: "项目ID", hidden: true},
    {
        dataIndex: "XM_NAME", width: 330, type: "string",text: "项目名称",
        renderer: function (data, cell, record) {
            /* var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
             return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>'; */
            var result = '<a href="javascript:void(0);" onclick="initWin_xmInfo(\'' + record.get('XM_ID') + '\',\'' + record.get('ID') + '\')">' +data + '</a>';
            return result;
        }

    },
    {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
    {dataIndex: "BA_CODE", width: 150, type: "string", text: "备案编码"},
    {dataIndex: "BILL_YEAR", type: "string", text: "年度"},
    {dataIndex: "ZQQX_NAME", width: 100, type: "string", text: "债券期限"},
    {
        dataIndex: "IS_FXJH", type: "string", text: "计划类型",hidden: true,
        renderer: function (value) {
            return value == 0 ? '年度计划' : '发行计划';
        }
    },
    //资金分配初审和终审功能，fp_amt实为申请金额，APPLY_AMOUNT1实为分配金额
    // {
    //     header: '申请金额(万元)', colspan: 2, align: 'center', columns: [
    //         {
    //             dataIndex: is_zjfp==0 ? "APPLY_AMOUNT1":"FP_AMT", width: 160, type: "float", text: "当年申请金额", summaryType: 'sum',
    //             // editor: IS_EDITABLE_LLEVEL == '0'?null:{
    //             //     xtype: "numberfield",
    //             //     emptyText: '0.00',
    //             //     hideTrigger: true,
    //             //     mouseWheelEnabled: true,
    //             //     allowBlank: false,
    //             //     maxValue:9999999999,
    //             //     decimalPrecision:6,
    //             //     plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
    //             // },
    //             renderer: function (value) {
    //                 return Ext.util.Format.number(value , '0,000.00####');
    //             },
    //             summaryRenderer: function (value) {
    //                 return Ext.util.Format.number(value , '0,000.00####');
    //             }
    //         },
    //         {
    //             dataIndex: "APPLY_AMOUNT_TOTAL", width: 160, type: "float", text: "申请总金额", summaryType: 'sum',
    //             renderer: function (value) {
    //                 return Ext.util.Format.number(value , '0,000.00####');
    //             },
    //             summaryRenderer: function (value) {
    //                 return Ext.util.Format.number(value , '0,000.00####');
    //             }
    //         }]
    // },
    {
        dataIndex: "APPLY_AMOUNT_TOTAL", width: 160, type: "float", text: "申请总金额(万元)", summaryType: 'sum',
        hidden: GxdzUrlParam == ELE_AD_CODE ? false : true,
        renderer: function (value) {
            return Ext.util.Format.number(value , '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value , '0,000.00####');
        }
    },
    {
        dataIndex: "APPLY_AMOUNT2", width: 160, type: "float", text: "第二年申请金额", summaryType: 'sum',
        hidden: GxdzUrlParam == ELE_AD_CODE ? false : true,
        renderer: function (value) {
            return Ext.util.Format.number(value , '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value , '0,000.00####');
        }
    },
    {
        dataIndex: "APPLY_AMOUNT3", width: 160, type: "float", text: "第三年申请金额", summaryType: 'sum',
        hidden: GxdzUrlParam == ELE_AD_CODE ? false : true,
        renderer: function (value) {
            return Ext.util.Format.number(value , '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value , '0,000.00####');
        }
    },
    {dataIndex: "IS_SAVE",  type: "string", text: "是否保存",hidden:true},
    {
        dataIndex: "APPLY_AMOUNT1", width: 160, type: "float", text: "分配金额(万元)", summaryType: 'sum',
        // hidden:is_zjfp==0,
        // disabled:is_zjfp==0,
        // editor: is_zjfp!=1 ? null:{
        //     xtype: "numberfield",
        //     emptyText: '0.00',
        //     hideTrigger: true,
        //     mouseWheelEnabled: true,
        //     allowBlank: false,
        //     decimalPrecision:2,
        //     editable:true,
        //     maxValue: 9999999999,
        //     plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
        // },
        renderer: function (value) {
            return Ext.util.Format.number(value , '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value , '0,000.00####');
        }
    },
    {dataIndex: "BOND_TYPE_NAME", type: "string", text: "申请类型"},
    {
        dataIndex: "RETURN_CAPITAL",
        width: 160,
        type: "float",
        text: "其中用于偿还本金(万元)",
        hidden: true,
        summaryType: 'sum',
        renderer: function (value) {
            return Ext.util.Format.number(value  , '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value  , '0,000.00####');
        }
    },
    /*{dataIndex: "SBBATCH_NO", width: 150, type: "string",hidden:true, text: "申报批次"},*/
    {dataIndex: "SBBATCH_NO_NAME", width: 150, type: "string",hidden:is_fxjh == 3 && is_zxzqxt=='1' ? false : true, text: "申报批次"},
    {dataIndex: "BILL_NO", width: 150, type: "string", text: "申报单号", hidden: true},
    {dataIndex: "APPLY_DATE", type: "string", text: "申报日期"},
    {dataIndex: "APPLY_INPUTOR", type: "string", text: "经办人"},
    {dataIndex: "LX_YEAR", type: "string", text: "立项年度"},
    {dataIndex: "JSXZ_NAME", type: "string", text: "建设性质"},
    {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质"},
    {dataIndex: "XMLX_NAME", type: "string", text: "项目类型"},
    {
        dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算(万元)", /*summaryType: 'sum',*/
        renderer: function (value) {
            return Ext.util.Format.number(value   , '0,000.00####');
        },
        /*summaryRenderer: function (value) {
            return Ext.util.Format.number(value   , '0,000.00####');
        }*/
    },
    //{dataIndex: "ZWYE", width: 160, type: "float", text: "债务余额"},
    {dataIndex: "START_DATE_PLAN", width: 120, type: "string", text: "计划开工日期"},
    {dataIndex: "END_DATE_PLAN", width: 120, type: "string", text: "计划竣工日期"},
    {dataIndex: "START_DATE_ACTUAL", width: 120, type: "string", text: "实际开工日期"},
    {dataIndex: "END_DATE_ACTUAL", width: 120, type: "string", text: "实际竣工日期"},
    {dataIndex: "BUILD_STATUS_NAME", type: "string", text: "建设状态"},
    {dataIndex: "FILTER_STATUS_NAME", type: "string", text: "项目状态"},
    {dataIndex: "FIRST_BILL", type: "string", text: "是否第一单标志", hidden: true},
    {
        text: "上报审核状态", dataIndex: "SBZT", type: "string", width: 120, hidden: true/*,
         renderer: function (value, metadata, record) {
         if (value == null || value == '') {
         record.data.SBZT = 1;
         value = 1;
         }
         var rec = store_shyj.findRecord('code', value, 0, false, true, true);
         return rec.get('name');
         }*/
    },
    {text: "上报审核级别", dataIndex: "SB_AD_NAME", type: "string", hidden: true},
    {text: "上报审核意见", dataIndex: "SBYJ", width: 300, type: "string"},
    {
        dataIndex: "STATUS", width: 200, type: "string", text: "状态",hidden: true,
        renderer: function (value, metaData, record) {

            if (record.get('IS_VALID') == 0) {
                return '已退出';
            }
            if (record.get('JHGL_END') == 1) {
                if (record.get('IS_USED') == 1) {
                    if(is_fxjh==0){//需求库
                        return '完成需求项目管理流程并已被使用';
                    }else{//限额库
                        return '完成限额项目管理流程并已被使用';
                    }
                }
                if (value >= 25 && record.get('SB_AD_CODE')) {
                    return record.get('SB_AD_NAME') + '下级审核不通过';
                }
                if(is_fxjh==0){//需求库
                    return '完成需求项目管理流程';
                }else{//限额库
                    return '完成限额项目管理流程';
                }
            }
            if (record.get('IS_END') == 0) {
                if (record.get('NODE_CURRENT_ID') == 1) {
                    return '未送审';
                }
                if (record.get('NODE_CURRENT_ID') == 2) {
                    return '未复核';
                }
                if (record.get('NODE_CURRENT_ID') == 3) {
                    return '未审核';
                }
                if (record.get('NODE_CURRENT_ID') == null || record.get('NODE_CURRENT_ID') == '')  {
                    if(record.get('IS_FXJH') == 0){//需求库
                        return '增补需求项目未审核';
                    }else{//限额库
                        return '增补限额项目未审核';
                    }
                }
            } else {
                if (value == 20) {
                    return '未汇总';
                }
                if (value == 25) {
                    if (record.get('SB_AD_CODE')) {
                        return record.get('SB_AD_NAME') + '下级审核不通过';
                    }
                    if (record.get('HZ_WF_STATUS') == '001') {
                        return record.get('AD_LEVEL_NAME') + '未上报';
                    }
                    if (record.get('HZ_WF_STATUS') == '002') {
                        return record.get('AD_LEVEL_NAME') + '未审核';
                    }
                    if (record.get('HZ_WF_STATUS') == '004') {
                        return '退回至' + record.get('AD_LEVEL_NAME');
                    }
                    return '找不到汇总上报信息';
                }
                if (value == 30) {
                    return '已上报';
                }
            }
        }
    },
    {dataIndex: "REMARK", type: "string", width: 150, text: "备注"},
    /*{dataIndex: "IS_END", type: "string", width: 150, text: "IS_END"},
    {dataIndex: "MB_ID", type: "string", width: 150, text: "MB_ID"}*/
];
function initContentGrid(){
    var headerJson = HEADERJSON;
    var config = {
        itemId: 'contentGrid',
        flex: 1,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        // features: [{
        //     ftype: 'summary'
        // }],
        checkBox: true,
        // selModel: {
        //     selType: is_fxjh=='1'||node_type=='jhhz'||node_type=='jhtb'||node_type=='jhsh'||node_type=='xmtzsh'?'checkboxmodel':'cellmodel',
        //     mode: is_fxjh=='1'||node_type=='jhhz'||node_type=='jhtb'||node_type=='jhsh'||node_type=='xmtzsh'?"SIMPLE":"SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        // },
        border: false,
        autoLoad: false,
        height: '100%',
        pageConfig: {
            pageNum: true,//设置显示每页条数
            enablePage: true
        },
        dataUrl: '/getZzfxGridInfo.action',
        params: {
        },
        listeners: {
            itemdblclick: function (self, record) {

            },
            validateedit:function (editor, e) {
                /*var value = e.record.get('APPLY_AMOUNT_TOTAL') ;
                if(e.field == 'APPLY_AMOUNT1' && is_zjfp==0 ){
                    var ov = e.value - e.originalValue ;
                    e.record.set('APPLY_AMOUNT_TOTAL',ov + value) ;
                }*/
            }
        },
        tbar: [item]
    };
    // if (zqxm_json_common.item_content_grid_config) {
    //     config = $.extend(false, config, zqxm_json_common.item_content_grid_config);
    // }
    // if(node_type=="jhxjshNew"){
    //     delete config.tbar;
    // }
    // //如果上传附件功能，则删除状态栏
    // if(is_scfjgn){
    //     delete config.tbar;
    // }
    var contentGrid=DSYGrid.createGrid(config);
    // contentGrid.getStore().on('load', function () {
    //     var self = contentGrid.getStore();
    //     for(var i=0;i<self.getCount();i++) {
    //         var record = self.getAt(i);
    //         var apply_amount1 = record.get("APPLY_AMOUNT1");
    //         record.set("APPLY_AMOUNT1", apply_amount1 / 10000);
    //         var apply_amount_total = record.get("APPLY_AMOUNT_TOTAL");
    //         record.set("APPLY_AMOUNT_TOTAL", apply_amount_total / 10000);
    //         var return_capital = record.get("RETURN_CAPITAL");
    //         record.set("RETURN_CAPITAL", return_capital / 10000);
    //         var xmzgs_amt = record.get("XMZGS_AMT");
    //         record.set("XMZGS_AMT", xmzgs_amt / 10000);
    //         if(is_zjfp!= 0 ){
    //             var fp_amt = record.get("FP_AMT");
    //             record.set("FP_AMT", fp_amt / 10000);
    //             record.set("IS_SAVE", '1');
    //         }
    //     }
    // });
    return contentGrid;
}

function reloadGrid(){
    if (AD_CODE == null || AD_CODE == '') {
        Ext.Msg.alert('提示', '请选择区划！');
        return;
    }
    var xekmh=Ext.ComponentQuery.query('textfield[itemId="xek_mh_sel"]');
    var xekmhsel=xekmh.length>0?xekmh[0].value:null;
    var SBBATCH_NO=Ext.ComponentQuery.query('textfield[itemId="SBBATCH_NO"]');
    var SBBATCH=SBBATCH_NO.length>0?SBBATCH_NO[0].value:null;
    var IS_ZJZSWTG=Ext.ComponentQuery.query('combobox[name="IS_ZJZSWTG"]')[0].value;
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    var BOND_TYPE_ID = Ext.ComponentQuery.query('treecombobox[name="BOND_TYPE_ID"]')[0].getValue();
    store.removeAll();
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_CODE: AG_CODE,
        AG_ID: AG_ID,
        BILL_YEAR: BILL_YEAR,
        IS_ZZ: IS_ZZ,
        xekmhsel: xekmhsel,
        IS_FXJH:is_fxjh,
        IS_ZXZQ:is_zxzq,
        SBBATCH_NO: SBBATCH,
        BOND_TYPE_ID:BOND_TYPE_ID,
        IS_ZJZSWTG:IS_ZJZSWTG
    };
    store.loadPage(1);
}
function updateIszz(btn,text){
    var updbtn_name = btn.name;
    var recordData = DSYGrid.getGrid('contentGrid').getSelection();
    if(recordData.length == 0){
        Ext.MessageBox.alert('提示', '请选择一笔项目！');
        return false;
    }
    var fxglArray = [];
    var xmArray = [];
        Ext.each(recordData, function (record) {
            var array = {};
            var xmidArray = {};
            array.ID = record.get("ID");
            array.XM_ID=record.get("XM_ID");
            array.BILL_YEAR=record.get("BILL_YEAR");
            xmidArray.XM_ID=record.get("XM_ID");
            fxglArray.push(array);
            xmArray.push(xmidArray);
        });
    $.ajax({
        type: "POST",
        url: 'updBillZzfx.action',
        async: false, //设为false就是同步请求
        cache: false,
        dataType: 'json',
        data: {
            updbtn_name: updbtn_name,
            IS_FXJH:is_fxjh,
            recordsData: Ext.util.JSON.encode(fxglArray),
            xmidDatas:Ext.util.JSON.encode(xmArray),
            audit_info: text
        },
        success: function (data) {
            Ext.toast({
                html: data.msg,
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.setDisabled(false);
            reloadGrid();
        },fail: function () {
            Ext.toast({
                html: updbtn_text + "失败！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.setDisabled(false);
        }
    });
}