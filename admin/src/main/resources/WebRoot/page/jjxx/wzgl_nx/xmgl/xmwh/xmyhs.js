/**
 * 项目基本信息
 */
function initXmjbxxtForm() {
    var form = Ext.create('Ext.form.Panel', {
        itemId: 'xmjbxx_form',
        width: '100%',
        height: '100%',
        autoScroll: true,
        layout: 'column',
        border: false,
        defaultType: 'textfield',
        defaults: {
            margin: '2 5 2 5',
            columnWidth: .33,
            labelWidth: 125,
            editable: false,
            readOnly: true,
            fieldCls: 'form-unedit',//组件样式-禁用
            allowDecimals: true,//数字组件-允许小数点
            decimalPrecision: 6,//数字组件-小数精度6位数
            hideTrigger: true,//数字组件-隐藏调整指针
            keyNavEnabled: false,//数字组件-禁用键盘调整
            mouseWheelEnabled: false,//数字组件-禁用鼠标滚轮调整
        },
        items: [
            {xtype: 'label', text: '基本信息', width: 100, columnWidth: 1, style: 'color:#048DBF'},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {fieldLabel: '<span class="required">✶</span>外债ID', name: 'WZXY_ID', hidden: true},
            {fieldLabel: '<span class="required">✶</span>项目地区', name: 'XY_AG_NAME'},
            {fieldLabel: '<span class="required">✶</span>项目名称', name: 'WZXY_NAME', columnWidth: 0.5},
            {fieldLabel: '<span class="required">✶</span>外债编码', name: 'WZXY_CODE'},
            {fieldLabel: '<span class="required">✶</span>项目类别', name: 'XMLB_NAME'},
            {fieldLabel: '<span class="required">✶</span>债券国', name: 'ZQR_NAME'},
            {fieldLabel: '<span class="required">✶</span>执行单位', name: 'ZXDW'},
            {fieldLabel: '<span class="required">✶</span>债务单位', name: 'ZWDW'},
            {fieldLabel: '担保单位', name: 'DBDW'},
            {fieldLabel: '转贷机构', name: 'ZDJG_NAME'},
            {xtype: 'label', text: '利率及期限', width: 100, columnWidth: 1, style: 'color:#048DBF'},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {fieldLabel: '<span class="required">✶</span>协议生效日期', name: 'XYSX_DATE'},
            {fieldLabel: '首次提款日期', name: 'SCTK_DATE'},
            {fieldLabel: '提款截止日期', name: 'TQJZ_DATE'},
            {
                fieldLabel: '<span class="required">✶</span>贷款期限(年)',
                name: 'DKQX',
                xtype: 'numberFieldFormat',
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '<span class="required">✶</span>贷款利率(%)',
                name: 'LX_RATE',
                xtype: 'numberFieldFormat',
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '<span class="required">✶</span>还款期限(年)',
                name: 'HKQX',
                xtype: 'numberFieldFormat',
                fieldCls: 'form-unedit-number'
            },
            {fieldLabel: '浮动利率(%)', name: 'LX_FDL', xtype: 'numberFieldFormat', fieldCls: 'form-unedit-number'},
            {fieldLabel: '宽限期(年)', name: 'KXQ', xtype: 'numberFieldFormat', fieldCls: 'form-unedit-number'},
            {
                fieldLabel: '<span class="required">✶</span>转贷费率(%)',
                name: 'ZD_RATE',
                xtype: 'numberFieldFormat',
                fieldCls: 'form-unedit-number'
            },
            {fieldLabel: '项目执行期(年)', name: 'XMZXQ', xtype: 'numberFieldFormat', fieldCls: 'form-unedit-number'},
            {
                fieldLabel: '<span class="required">✶</span>承诺费率(%)',
                name: 'CN_RATE',
                xtype: 'numberFieldFormat',
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '<span class="required">✶</span>担保费率(%)',
                name: 'DB_RATE',
                xtype: 'numberFieldFormat',
                fieldCls: 'form-unedit-number'
            },
            {xtype: 'label', text: '账户及方式', width: 100, columnWidth: 1, style: 'color:#048DBF'},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {fieldLabel: '<span class="required">✶</span>项目分类', name: 'XMFL_NAME'},
            {fieldLabel: '还款来源', name: 'HKLY_NAME'},
            {fieldLabel: '专用开户行', name: 'ZYKHH'},
            {fieldLabel: '<span class="required">✶</span>偿还方式', name: 'CHFS_NAME'},
            {fieldLabel: '户名', name: 'HM'},
            {fieldLabel: '账号', name: 'ZH'},
            {xtype: 'label', text: '项目担保及反担保(万元)', width: 300, style: 'color:#048DBF', columnWidth: 1},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {fieldLabel: '省区财政担保', name: 'SQCZDB_AMT', xtype: 'numberFieldFormat', fieldCls: 'form-unedit-number'},
            {fieldLabel: '市县财政担保', name: 'SXCZDB_AMT', xtype: 'numberFieldFormat', fieldCls: 'form-unedit-number'},
            {fieldLabel: '计委反担保', name: 'JWFDB_AMT', xtype: 'numberFieldFormat', fieldCls: 'form-unedit-number'},
            {fieldLabel: '转贷银行担保', name: 'ZDYHDB_AMT', xtype: 'numberFieldFormat', fieldCls: 'form-unedit-number'},
            {xtype: 'label', text: '项目执行情况', width: 100, columnWidth: 1, style: 'color:#048DBF'},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {fieldLabel: '<span class="required">✶</span>执行情况', name: 'ZXQK_NAME'},
            {fieldLabel: '行业分类', name: 'HYFL_NAME'},
            {fieldLabel: '采购公司', name: 'CGGS'},
            {xtype: 'label', text: '项目投资(万元)', width: 100, style: 'color:#048DBF', columnWidth: 1},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {
                fieldLabel: '<span class="required">✶</span>本位币/SDR',
                name: 'WZXY_AMT',
                xtype: 'numberFieldFormat',
                fieldCls: 'form-unedit-number'
            },
            {fieldLabel: '<span class="required">✶</span>币种', name: 'FM_NAME'},
            {
                fieldLabel: '<span class="required">✶</span>折合美元',
                name: 'ZHMY_AMT',
                xtype: 'numberFieldFormat',
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '<span class="required">✶</span>折合人民币',
                name: 'WZXY_AMT_RMB',
                xtype: 'numberFieldFormat',
                fieldCls: 'form-unedit-number',
                listeners: {
                    'change': function (self, newValue, oldValue) {
                        var form = this.up('form').getForm();
                        var PTZJ_AMT = form.findField('PTZJ_AMT').getValue();//配套资金
                        var WZXY_AMT_RMB = form.findField('WZXY_AMT_RMB').getValue();//折合人民币
                        var ZTZ_AMT = form.findField("ZTZ_AMT");//总投资
                        ZTZ_AMT.setValue(PTZJ_AMT + WZXY_AMT_RMB);
                    }
                }
            },
            {fieldLabel: '赠款', name: 'ZK_AMT', xtype: 'numberFieldFormat', fieldCls: 'form-unedit-number'},
            {
                fieldLabel: '<span class="required">✶</span>总投资',
                name: 'ZTZ_AMT',
                xtype: 'numberFieldFormat',
                fieldCls: 'form-unedit-number'
            },
            {
                fieldLabel: '配套资金', name: 'PTZJ_AMT', xtype: 'numberFieldFormat', fieldCls: 'form-unedit-number',
                listeners: {
                    'change': function (self, newValue, oldValue) {
                        var form = this.up('form').getForm();
                        var PTZJ_AMT = form.findField('PTZJ_AMT').getValue();//配套资金
                        var WZXY_AMT_RMB = form.findField('WZXY_AMT_RMB').getValue();//折合人民币
                        var ZTZ_AMT = form.findField("ZTZ_AMT");//总投资
                        ZTZ_AMT.setValue(PTZJ_AMT + WZXY_AMT_RMB);
                    }
                }
            }
        ]
    });
    return form;
}

/**
 * 贷款分配信息
 */
function initDkfpxxGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            width: 50,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "ZDMX_ID", type: "string", text: "贷款明细ID", hidden: true},
        {dataIndex: "AG_NAME", type: "string", text: "项目区", width: 150},
        {dataIndex: "ZC_TYPE_NAME", text: "支出类型", width: 200, type: "string"},
        {
            dataIndex: "ZD_AMT_RMB", type: "float", text: "总投资(人民币)", width: 200,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value, cellmeta, record) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            dataIndex: "ZD_AMT",
            type: "float",
            text: "贷款分配(原币)",
            width: 200,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value, cellmeta, record) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            dataIndex: "ZFBL_RATE",
            type: "float",
            text: "支付比例(%)",
            width: 200,
            renderer: function (value) {
                return isNull(value) ? '' : Ext.util.Format.number(value, '0,000.######') + '%';
            }
        }
    ];

    //生成贷款分配信息表格
    var dkfpxxGrid = DSYGrid.createGrid({
        itemId: 'dkfpxxGrid',
        border: false,
        flex: 1,
        data: [],
        checkBox: true,
        headerConfig: {headerJson: headerJson, columnAutoWidth: false},
        features: [{ftype: 'summary'}],
        pageConfig: {enablePage: false},
        rowNumber: {rowNumber: true},
    });
    return dkfpxxGrid;
}

/**
 * 还款计划信息
 */
function initHkjhxxGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            width: 50,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "HKJH_ID ", type: "string", text: "还款计划ID", hidden: true},
        {dataIndex: "HKJH_DATE", type: "string", text: "年份", width: 150},
        {
            dataIndex: "LX_RATE", type: "string", text: "利率(%)", width: 200,
            renderer: function (value) {
                return isNull(value) ? '' : Ext.util.Format.number(value, '0,000.######') + '%';
            }

        },
        {
            dataIndex: "BJ", text: "本金",
            columns: [
                {
                    dataIndex: "BJ_YB_AMT", type: "float", text: "本位币", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BJ_MY_AMT", type: "float", text: "美元", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BJ_RMB_AMT", type: "float", text: "人民币", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }
            ]
        },
        {
            dataIndex: "LX", text: "利息",
            columns: [
                {
                    dataIndex: "LX_YB_AMT", type: "float", text: "本位币", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LX_MY_AMT", type: "float", text: "美元", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LX_RMB_AMT", type: "float", text: "人民币", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }
            ]
        },
        {
            dataIndex: "CNF", text: "承诺费",
            columns: [
                {
                    dataIndex: "CNF_YB_AMT", type: "float", text: "本位币", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CNF_MY_AMT", type: "float", text: "美元", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CNF_RMB_AMT", type: "float", text: "人民币", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }
            ]
        },
        {
            dataIndex: "ZDF", text: "转贷费",
            columns: [
                {
                    dataIndex: "ZDF_YB_AMT", type: "float", text: "本位币", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_MY_AMT", type: "float", text: "美元", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_RMB_AMT", type: "float", text: "人民币", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }
            ]
        },
        {
            dataIndex: "DBF", text: "担保费",
            columns: [
                {
                    dataIndex: "DBF_YB_AMT", type: "float", text: "本位币", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_MY_AMT", type: "float", text: "美元", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_RMB_AMT", type: "float", text: "人民币", width: 150,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                }
            ]
        }
    ];
    //生成还款计划信息表格
    var hkjhxxGrid = DSYGrid.createGrid({
        itemId: 'hkjhxxGrid',
        border: false,
        flex: 1,
        data: [],
        checkBox: true,
        headerConfig: {headerJson: headerJson, columnAutoWidth: false},
        features: [{ftype: 'summary'}],
        pageConfig: {enablePage: false},
        rowNumber: {rowNumber: true},
    });
    return hkjhxxGrid;
}

/**
 * 附件标签页
 */
function initWin_Fj() {
    var grid = UploadPanel.createGrid({
        busiType: ' ',//业务类型
        busiId: wzxy_id,//业务ID
        busiProperty: '%',//业务规则，默认为‘%’
        editable: false,//是否可以修改附件内容，默认为ture
        gridConfig: {itemId: 'window_dkxxtb_contentForm_tab_xyfj_grid'}
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

$(document).ready(function () {
    Ext.create('Ext.panel.Panel', {
        renderTo: Ext.getBody(),
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            width: '100%',
            margin: '0 0 2 0'
        },
        items: [
            {
                xtype: 'container',
                layout: 'column',
                anchor: '100%',
                defaults: {
                    margin: '3 5 3 100',
                    labelAlign: 'right',
                    labelWidth: 80
                },
                defaultType: 'displayfield',
                items: [
                    {
                        fieldLabel: '<span class="displayfield">项目名称</span>',
                        name: 'WZXY_NAME',
                        value: '',
                        columnWidth: '0.3'
                    },
                    {
                        fieldLabel: '<span class="displayfield">外债编码</span>',
                        name: 'WZXY_CODE',
                        value: '',
                        columnWidth: '0.3'
                    },
                    {
                        fieldLabel: '<span class="displayfield">单位</span>',
                        name: 'jedw',
                        value: '<span class="displayfield">万元</span>',
                        columnWidth: '0.2'
                    }
                ]
            },
            {
                xtype: 'panel',
                width: document.body.clientWidth * 0.9, // 窗口宽度
                height: document.body.clientHeight * 0.9, // 窗口高度
                maximizable: true,
                border: false,
                layout: 'fit',
                itemId: 'window_tb', // 窗口标识
                modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
                closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是close，则会将window销毁。
                defaults: {
                    width: '100%',
                    margin: '0 0 2 100'
                },
                items: [
                    {
                        xtype: 'tabpanel',
                        items: [
                            {
                                title: '项目基本信息',
                                scrollable: true,
                                layout: 'fit',
                                opstatus: 0,
                                items: [initXmjbxxtForm()]
                            },
                            {
                                title: '贷款分配信息',
                                scrollable: true,
                                layout: 'fit',
                                opstatus: 1,
                                items: [initDkfpxxGrid()]
                            },
                            {
                                title: '还款计划信息',
                                scrollable: true,
                                layout: 'fit',
                                opstatus: 3,
                                items: [initHkjhxxGrid()]
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
                                        items: [initWin_Fj()]
                                    }
                                ]
                            }
                        ],
                    }
                ],
            }
        ]
    });
    /**
     * 获取外债协议wzxy_id发送Ajax请求
     */
    $.ajax({
            type: "POST",
            url: "/wzgl_nx/xygl/getXmInfoById.action",
            data: {wzxy_id: wzxy_id},
            // async: false,
            dataType: 'json'
        }
    )
        .done(function (result) {
            if (!result.success || !result) {
                Ext.MessageBox.alert('提示', '查询失败！' + (!result.message ? '' : result.message));
                return false;
            }
            if (!!result.xmjbForm) {
                var WZXY_NAME = Ext.ComponentQuery.query('displayfield[name="WZXY_NAME"]')[0];
                var wzxy_name = result.xmjbForm["WZXY_NAME"];
                WZXY_NAME.setValue('<span class="displayfield">' + wzxy_name + '</span>');

                var WZXY_CODE = Ext.ComponentQuery.query('displayfield[name="WZXY_CODE"]')[0];
                var wzxy_code = result.xmjbForm["WZXY_CODE"];
                WZXY_CODE.setValue('<span class="displayfield">' + wzxy_code + '</span>')
            }
            if (!!result.xmjbForm) {
                var form = Ext.ComponentQuery.query('form#xmjbxx_form')[0];
                var xmjbForm = result.xmjbForm;
                form.getForm().setValues(xmjbForm);
            }
            if (!!result.dkfpList) {
                var dkfpList = result.dkfpList;
                var grid = DSYGrid.getGrid('dkfpxxGrid');
                grid.insertData(null, dkfpList);
            }
            if (!!result.hkjhList) {
                var hkjhList = result.hkjhList;
                var grid = DSYGrid.getGrid('hkjhxxGrid');
                grid.insertData(null, hkjhList);
            }
        })
        .fail(function (result) {
            Ext.MessageBox.alert('提示', '查询失败！' + (!result.message ? '' : result.message));
        });
})


