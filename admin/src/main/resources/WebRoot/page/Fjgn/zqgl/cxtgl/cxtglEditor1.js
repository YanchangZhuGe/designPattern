/**
 * 初始化条件面板
 */
function initEditor() {
    /**
     * 定义底部工具栏
     */
    var bbar = Ext.create('Ext.toolbar.Toolbar', {
        //var bbar = window.parent.Ext.toolbar.Toolbar({
        id: 'bbar',
        border: false,
        items: ['->',
            /*{
             xtype: 'button',
             text: '保存并送审',
             scale:'medium',
             name: 'NEXT',
             //icon:'../../../image/button/field_insertb24_h.png',
             handler: function (btn) {
             var form = btn.up('form');
             submitInfo(form);
             }
             },*/
            {
                xtype: 'button',
                text: '保存',
                scale: 'medium',
                name: 'INPUT',
                //icon:'../../../image/button/edit_table_structure24_h.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    submitInfo(form);
                }
            },
            {
                xtype: 'button',
                text: '关闭',
                scale: 'medium',
                name: 'CLOSE',
                //icon:'../../../image/button/field_drop24_h.png',
                handler: function () {
                    if (button_name == 'INPUT') {
                        Ext.ComponentQuery.query('window#addWin')[0].close();
                    } else {
                        Ext.ComponentQuery.query('window#updateWin')[0].close();
                    }
                }
            }
        ]
    });

    /**
     * 定义表单元素及信息
     */
    var content = [{
        xtype: 'fieldset',
        id: 'content',
        title: '债务信息',
        layout: 'vbox',
        width: "100%",
        margin: '1 2 1 2',
        defaults: {
            border: false,
            margin: '0 0 0 0'
        },
        items: [{//第一部分
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true,
                editable: true
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '债务区划',
                    name: "AD_NAME",
                    editable: false,
                    emptyText: '',
                    value: AD_NAME
                },
                {
                    xtype: "textfield",
                    fieldLabel: '债务单位',
                    name: "AG_NAME",
                    editable: false,
                    emptyText: '',
                    value: AG_NAME
                },
                {
                    xtype: "combobox",
                    name: "MB_ID",
                    store: MBEleStoreDB(),
                    displayField: "NAME",
                    valueField: "ID",
                    fieldLabel: '<font color="red">*</font>业务处室',
                    editable: false, //禁用编辑
                    allowBlank: false
                }]
        }, {//分割线
            xtype: 'menuseparator',
            width: '100%',
            margin: '5 0 5 0',
            border: true
        }, {//第二部分
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true
            },
            items: [{
                xtype: "textfield",
                fieldLabel: '<font color="red">*</font>债务名称',
                name: "ZW_NAME",
                allowBlank: false,
                emptyText: '请输入...'
            }, {
                xtype: 'treecombobox',
                fieldLabel: '<font color="red">*</font>债务类别',
                name: 'ZWLB_ID',
                displayField: 'name',
                valueField: 'id',
                rootVisible: false,
                lines: false,
                maxPicekerWidth: '100%',
                editable: false, //禁用编辑
                selectModel: 'leaf',
                store: DebtEleTreeStoreJSON(json_debt_zwlb)
            }, {
                xtype: "datefield",
                name: "SIGN_DATE",
                fieldLabel: '<font color="red">*</font>签订日期',
                allowBlank: false,
                format: 'Y-m-d',
                blankText: '请选择开始日期',
                emptyText: '请选择开始日期',
                value: today,
                listeners: {
                    'select': function () {
                    }
                }
            }]
        }, {
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true
            },
            items: [{
                xtype: "textfield",
                fieldLabel: '<font color="red">*</font>协议号',
                name: "ZW_XY_NO",
                allowBlank: false,
                emptyText: '请输入...'
            },
                {
                    xtype: "treecombobox",
                    name: "ZQFL_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZQLX'),
                    fieldLabel: '<font color="red">*</font>债权类型',
                    displayField: 'name',
                    valueField: 'id',
                    rootVisible: false,
                    lines: false,
                    editable: false, //禁用编辑
                    selectModel: 'leaf',
                    listeners: {
                        'select': function () {
                        }
                    }
                }, {
                    xtype: 'treecombobox',
                    fieldLabel: '<font color="red">*</font>债权人',
                    name: 'ZQR_ID',
                    displayField: 'name',
                    valueField: 'id',
                    rootVisible: false,
                    lines: false,
                    editable: false, //禁用编辑
                    selectModel: 'leaf',
                    store: DebtEleTreeStoreDB("DEBT_ZQR")
                }]
        }, {
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true
            },
            items: [{
                xtype: "textfield",
                fieldLabel: '<font color="red">*</font>债权人全称',
                allowBlank: false,
                name: "ZQR_FULLNAME",
                emptyText: '请输入...'
            },
                {
                    xtype: 'treecombobox',
                    fieldLabel: '<font color="red">*</font>资金用途',
                    name: 'ZJYT_ID',
                    displayField: 'name',
                    valueField: 'id',
                    rootVisible: false,
                    lines: false,
                    editable: false, //禁用编辑
                    selectModel: 'leaf',
                    store: DebtEleTreeStoreJSON(json_debt_zwzjyt)
                }, {
                    xtype: "combobox",
                    name: "XM_ID",
                    store: DebtEleStore(json_debt_zwlb),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<font color="red">*</font>建设项目',
                    allowBlank: false,
                    editable: false, //禁用编辑
                    listeners: {
                        'select': function () {
                        }
                    }
                }]
        }, {
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true
            },
            items: [{
                xtype: "numberfield",
                name: "ZWQX_ID",
                fieldLabel: '<font color="red">*</font>债务期限（月）',
                decimalPrecision: 0,
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            }]
        }, {
            xtype: 'menuseparator',
            width: '100%',
            margin: '5 0 5 0',
            border: true
        }, {//第三部分
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true
            },
            items: [{
                xtype: "combobox",
                name: "FM_ID",
                store: DebtEleStore(json_debt_wb),
                displayField: "name",
                valueField: "id",
                value: '001',
                fieldLabel: '<font color="red">*</font>币种',
                allowBlank: false,
                editable: false, //禁用编辑
                listeners: {
                    /**
                     * 币种select事件：
                     * 1.当币种为人民币时，汇率默认为1且不可编辑
                     * 2.当币种为非人民币时，汇率初始为0，可编辑
                     */
                    'select': function () {
                        var FM_ID = this.up('form').getForm().findField('FM_ID');
                        if (FM_ID.value == '001') {
                            this.up('form').getForm().findField('HL_RATE').setValue(parseFloat(1.000000).toFixed(6));
                            this.up('form').getForm().findField('HL_RATE').setReadOnly(true);
                        } else {
                            this.up('form').getForm().findField('HL_RATE').setValue(0.000000);
                            this.up('form').getForm().findField('HL_RATE').setReadOnly(false);
                        }
                    }
                }
            }, {
                xtype: "numberfield",
                name: "HL_RATE",
                fieldLabel: '<font color="red">*</font>汇率',
                value: 1.000000,
                readOnly: true,
                decimalPrecision: 6,
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                listeners: {
                    /**
                     * 汇率变动,自动计算协议金额（人民币）
                     */
                    'change': function () {
                        var form = this.up('form').getForm();
                        var HL_RATE = form.findField('HL_RATE').value;
                        var XY_AMT = form.findField('XY_AMT').getValue();
                        var XY_AMT_RMB = form.findField('XY_AMT_RMB');
                        XY_AMT_RMB.setValue(HL_RATE * XY_AMT);
                    }
                }
            },
                {
                    xtype: "numberfield",
                    name: "XY_AMT",
                    fieldLabel: '<font color="red">*</font>协议金额（原币）',
                    emptyText: '0.00',
                    decimalPrecision: 6,
                    hideTrigger: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    listeners: {
                        /**
                         * 协议金额（原币）变动,自动计算协议金额（人民币）
                         */
                        'change': function () {
                            var form = this.up('form').getForm();
                            var HL_RATE = form.findField('HL_RATE').value;
                            var XY_AMT = form.findField('XY_AMT').getValue();
                            var XY_AMT_RMB = form.findField('XY_AMT_RMB');
                            XY_AMT_RMB.setValue(HL_RATE * XY_AMT);
                        }
                    }
                }]
        }, {
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true
            },
            items: [{
                xtype: "combobox",
                name: "LXTYPE_ID",
                store: DebtEleStore(json_debt_jzlllx),
                displayField: "name",
                valueField: "id",
                fieldLabel: '<font color="red">*</font>利率类型',
                allowBlank: false,
                editable: false, //禁用编辑
                listeners: {
                    /**
                     * 利率类型select事件：
                     * 1.利率类型为固定利率时：固定利率（%）可编辑，利率调整方式、利率调整月份、日期、利率浮动方式、利率浮动率不可用（置灰）
                     * 2.利率类型为固定利率时：固定利率（%）、利率调整月份、日期、利率浮动方式不可用（置灰），利率调整方式、利率浮动率可编辑
                     */
                    'select': function () {
                        var LXTYPE_ID = this.up('form').getForm().findField('LXTYPE_ID');
                        if (LXTYPE_ID.value == '1') {
                            this.up('form').getForm().findField('LXTZ_ID').disable();
                            this.up('form').getForm().findField('LXTZ_MONTH').disable();
                            this.up('form').getForm().findField('LXTZ_DAY').disable();
                            this.up('form').getForm().findField('LX_FDFS').disable();
                            this.up('form').getForm().findField('LX_FDL').disable();
                            this.up('form').getForm().findField('LXTZ_ID').setValue('');
                            this.up('form').getForm().findField('LXTZ_MONTH').setValue('');
                            this.up('form').getForm().findField('LXTZ_DAY').setValue('');
                            this.up('form').getForm().findField('LX_FDFS').setValue('');
                            this.up('form').getForm().findField('LX_FDL').setValue('');
                            //启用固定利率
                            this.up('form').getForm().findField('LX_RATE').setValue('');
                            this.up('form').getForm().findField('LX_RATE').enable();
                        } else {
                            this.up('form').getForm().findField('LXTZ_ID').enable();
                            this.up('form').getForm().findField('LX_FDFS').enable();
                            this.up('form').getForm().findField('LX_FDL').enable();
                            //固定利率不可用
                            this.up('form').getForm().findField('LX_RATE').setValue('');
                            this.up('form').getForm().findField('LX_RATE').disable();
                        }
                    }
                }
            }, {
                xtype: "numberfield",
                name: "LX_RATE",
                fieldLabel: "固定利率（%）",
                emptyText: '0.0000',
                decimalPrecision: 6,
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
                {
                    xtype: "numberfield",
                    name: "XY_AMT_RMB",
                    fieldLabel: "协议金额（人民币）",
                    emptyText: '0.00',
                    decimalPrecision: 6,
                    hideTrigger: true,
                    readOnly: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }]
        }, {
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                editable: false, //禁用编辑
                allowBlank: true
            },
            items: [{
                xtype: "combobox",
                name: "LXTZ_ID",
                store: DebtEleStore(json_debt_lltzfs),
                displayField: "name",
                valueField: "id",
                fieldLabel: "利率调整方式",
                listeners: {
                    /**
                     * 利率调整方式select事件：根据利率调整方式不同动态切换利率调整月份的store并控制月份与日期控件是否可用
                     */
                    'select': function () {
                        var LXTZ_ID = this.up('form').getForm().findField('LXTZ_ID');
                        var LXTZ_MONTH = this.up('form').getForm().findField('LXTZ_MONTH');
                        var LXTZ_DAY = this.up('form').getForm().findField('LXTZ_DAY');
                        if (LXTZ_ID.value == '1') {
                            LXTZ_MONTH.enable();
                            LXTZ_DAY.enable();
                            LXTZ_MONTH.bindStore(DebtEleStore(json_debt_yf_nd));
                            LXTZ_MONTH.setValue('01');
                            LXTZ_DAY.setValue('01');
                        } else if (LXTZ_ID.value == '2') {
                            LXTZ_MONTH.enable();
                            LXTZ_DAY.enable();
                            LXTZ_MONTH.bindStore(DebtEleStore(json_debt_yf_bn));
                            LXTZ_MONTH.setValue('01');
                            LXTZ_DAY.setValue('01');
                        } else if (LXTZ_ID.value == '3') {
                            LXTZ_MONTH.enable();
                            LXTZ_DAY.enable();
                            LXTZ_MONTH.bindStore(DebtEleStore(json_debt_yf_jd));
                            LXTZ_MONTH.setValue('01');
                            LXTZ_DAY.setValue('01');
                        } else if (LXTZ_ID.value == '4') {
                            LXTZ_MONTH.disable();
                            LXTZ_DAY.enable();
                            LXTZ_MONTH.setValue('');
                            LXTZ_DAY.setValue('01');
                        } else {
                            LXTZ_MONTH.disable();
                            LXTZ_DAY.disable();
                            LXTZ_MONTH.setValue('');
                            LXTZ_DAY.setValue('');
                        }
                    }
                }
            }, {
                xtype: "combobox",
                name: "LXTZ_MONTH",
                store: DebtEleStore(json_debt_yf_nd),
                displayField: "name",
                valueField: "id",
                fieldLabel: "利息调整月份",
                width: 225, labelWidth: 150,
                listeners: {
                    'select': function () {
                    }
                }
            }, {
                xtype: "combobox",
                name: "LXTZ_DAY",
                store: DebtEleStore(json_debt_day),
                displayField: "name",
                valueField: "id",
                fieldLabel: "日期",
                width: 125, labelWidth: 50,
                listeners: {
                    'select': function () {
                    }
                }
            },
                {
                    xtype: "combobox",
                    name: "LX_FDFS",
                    store: DebtEleStore(json_debt_llfdfs),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: "利率浮动方式",
                    listeners: {
                        'select': function () {
                        }
                    }
                }]
        }, {
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true
            },
            items: [{
                xtype: "numberfield",
                fieldLabel: "利率浮动率（%）",
                name: "LX_FDL",
                emptyText: '0.0000',
                decimalPrecision: 4,
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
                {
                    xtype: "combobox",
                    name: "JSFS_ID",
                    store: DebtEleStore(json_debt_jxfs),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: "结息方式",
                    editable: false, //禁用编辑
                    listeners: {
                        /**
                         * 结息方式select事件：根据结息方式不同动态切换结息调整月份的store并控制月份与日期控件是否可用
                         */
                        'select': function () {
                            var JSFS_ID = this.up('form').getForm().findField('JSFS_ID');
                            var JSRQ_MONTH = this.up('form').getForm().findField('JSRQ_MONTH');
                            var JSRQ_DAY = this.up('form').getForm().findField('JSRQ_DAY');
                            if (JSFS_ID.value == '1') {
                                JSRQ_MONTH.enable();
                                JSRQ_DAY.enable();
                                JSRQ_MONTH.bindStore(DebtEleStore(json_debt_yf_nd));
                                JSRQ_MONTH.setValue('01');
                                JSRQ_DAY.setValue('01');
                            } else if (JSFS_ID.value == '2') {
                                JSRQ_MONTH.enable();
                                JSRQ_DAY.enable();
                                JSRQ_MONTH.bindStore(DebtEleStore(json_debt_yf_bn));
                                JSRQ_MONTH.setValue('01');
                                JSRQ_DAY.setValue('1');
                            } else if (JSFS_ID.value == '3') {
                                JSRQ_MONTH.enable();
                                JSRQ_DAY.enable();
                                JSRQ_MONTH.bindStore(DebtEleStore(json_debt_yf_jd));
                                JSRQ_MONTH.setValue('01');
                                JSRQ_DAY.setValue('1');
                            } else if (JSFS_ID.value == '4') {
                                JSRQ_MONTH.disable();
                                JSRQ_DAY.enable();
                                JSRQ_MONTH.setValue('');
                                JSRQ_DAY.setValue('1');
                            } else {
                                JSRQ_MONTH.disable();
                                JSRQ_DAY.disable();
                                JSRQ_MONTH.setValue('');
                                JSRQ_DAY.setValue('');
                            }
                        }
                    }
                }, {
                    xtype: "combobox",
                    name: "JSRQ_MONTH",
                    store: DebtEleStore(json_debt_yf_nd),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: "结息月份",
                    editable: false, //禁用编辑
                    width: 225, labelWidth: 150,
                    listeners: {
                        'select': function () {
                        }
                    }
                }, {
                    xtype: "combobox",
                    name: "JSRQ_DAY",
                    store: DebtEleStore(json_debt_day),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: "日期",
                    editable: false, //禁用编辑
                    width: 125, labelWidth: 50,
                    listeners: {
                        'select': function () {
                        }
                    }
                }]
        }, {
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true
            },
            items: [{
                xtype: "checkbox",
                width: 350,
                fieldLabel: "利随本清",
                name: "IS_LSBQ"
            },
                {
                    xtype: "combobox",
                    name: "RZFYFS_ID",
                    store: DebtEleStore(json_debt_fysqfs),
                    displayField: "name",
                    valueField: "id",
                    editable: false, //禁用编辑
                    fieldLabel: "融资费用收取方式",
                    listeners: {
                        'select': function () {
                        }
                    }
                }, {
                    xtype: "numberfield",
                    fieldLabel: "综合成本率（%）",
                    name: "ZHCB_RATE",
                    emptyText: '0.00',
                    decimalPrecision: 6,
                    hideTrigger: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }]
        }, {
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true
            },
            items: [{
                xtype: "numberfield",
                fieldLabel: "手续费率（%）",
                name: "FY_RATE",
                emptyText: '0.0000',
                decimalPrecision: 6,
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            }, {
                xtype: "numberfield",
                fieldLabel: "一次性费用",
                name: "FY_YCX",
                emptyText: '0.00',
                decimalPrecision: 6,
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            }, {
                xtype: "numberfield",
                fieldLabel: "保证金",
                name: "BZ_MONEY",
                emptyText: '0.00',
                decimalPrecision: 6,
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            }]
        }, {
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 2 0',
                labelAlign: 'right',
                allowBlank: true
            },
            items: [{
                xtype: "textfield",
                fieldLabel: "融资批复依据",
                name: "RZ_PFYJ",
                emptyText: '请输入...'
            }]
        }, {
            xtype: 'menuseparator',
            width: '100%',
            margin: '5 0 5 0',
            border: true
        }, {//第四部分
            xtype: 'container',
            layout: {
                type: 'hbox'
            },
            defaults: {
                anchor: '100%',
                flex: 1,
                width: 350, labelWidth: 150,
                margin: '2 0 5 0',
                labelAlign: 'right',
                editable: false, //禁用编辑
                allowBlank: true
            },
            items: [{
                xtype: "treecombobox",
                name: "DBFL_ID",
                store: DebtEleTreeStoreDB('DEBT_JJFS'),
                fieldLabel: "增信措施",
                displayField: 'name',
                valueField: 'id',
                rootVisible: false,
                lines: false,
                selectModel: 'leaf',
                listeners: {
                    'select': function () {
                    }
                }
            },
                {
                    xtype: "combobox",
                    name: "IS_QLZB",
                    store: DebtEleStore(json_debt_sf),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: "是否清理甄别认定债务",
                    listeners: {
                        'select': function () {
                        }
                    }
                }, {
                    xtype: "combobox",
                    name: "IS_FINISH",
                    store: DebtEleStore(json_debt_sf),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: "是否偿还完毕",
                    listeners: {
                        'select': function () {
                        }
                    }
                }]
        }

            //结束
        ]
    }
    ];

    var editorPanel = Ext.create('Ext.form.Panel', {
        title: '',
        layout: 'fit',
        border: false,
        split: true,
        height: '100%',
        bbar: bbar,
        items: content
    });

    /*alert(top.document.getElementById('treemenuframe'));
     var editorPanel = new window.parent.Ext.form.Panel({
     title: '',
     layout: 'fit',
     border:false,
     split: true ,
     height: '100%',
     bbar : bbar,
     items: content
     //bbar : top.document.getElementById('treemenuframe').contentWindow.document.getElementById('bbar'),
     //items: top.document.getElementById('treemenuframe').contentWindow.document.getElementById('content')
     });*/

    /**
     * 若为新增状态，则直接进行页面元素的初始化
     * 若为更新状态，则先进行数据的加载，加载完成后再进行页面元素的初始化
     */
    if (button_name == 'EDIT') {
        loadInfo(editorPanel);
    } else {
        initWidget(editorPanel);
    }
    return editorPanel;
};

function test() {
    var testPanel = new window.parent.Ext.form.Panel({
        title: '',
        layout: 'hbox',
        border: false,
        split: true,
        height: '100%',
        defaults: {
            flex: 1,
            width: 350,
            labelWidth: 150,
            margin: '2 0 5 0',
            labelAlign: 'right',
            allowBlank: true
        },
        items: [{
            xtype: "numberfield",
            fieldLabel: "综合成本率（%）",
            name: "ZHCB_RATE",
            emptyText: '0.00',
            decimalPrecision: 6,
            hideTrigger: true,
            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
        },
            {
                xtype: "combobox",
                name: "test2",
                store: DebtEleStore(json_debt_sf),
                displayField: "name",
                valueField: "id",
                fieldLabel: "是否清理甄别认定债务",
                listeners: {
                    'select': function () {
                    }
                }
            }]
    });
    return testPanel;
}

/**
 * 提交表单数据
 * @param form
 */
function submitInfo(form) {
    var url = '';
    if (button_name == 'INPUT') {
        url = 'saveBasicInfo.action?AD_CODE=' + AD_CODE + '&AG_ID=' + AG_ID + '&AG_CODE=' + AG_CODE
            + '&wf_id=' + wf_id + '&node_code=' + node_code + '&button_name=' + button_name + '&userCode=' + userCode;
    } else {
        url = 'updateBasicInfo.action?AD_CODE=' + AD_CODE + '&AG_ID=' + AG_ID + '&AG_CODE=' + AG_CODE + '&ZW_ID=' + ZW_ID
            + '&wf_id=' + wf_id + '&node_code=' + node_code + '&button_name=' + button_name + '&userCode=' + userCode;
    }
    if (form.isValid()) {
        form.submit({
            url: url,
            waitTitle: '请等待',
            waitMsg: '正在加载中...',
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '提交成功',
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        DSYGrid.getGrid("grid").getStore().loadPage(1);
                        if (button_name == 'INPUT') {
                            Ext.ComponentQuery.query('window#addWin')[0].close();
                        } else {
                            Ext.ComponentQuery.query('window#updateWin')[0].close();
                        }
                    }
                });
            },
            failure: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '提交失败',
                    width: 200,
                    fn: function (btn) {
                        if (button_name == 'INPUT') {
                            Ext.ComponentQuery.query('window#addWin')[0].close();
                        } else {
                            Ext.ComponentQuery.query('window#updateWin')[0].close();
                        }
                    }
                });
            }
        });
    } else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
    }
}

/**
 * 加载页面数据
 * @param form
 */
function loadInfo(form) {
    form.load({
        url: 'getBasicInfo.action?ZW_ID=' + ZW_ID,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            initWidget(form);
        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });
}

/**
 * 页面元素初始化
 * @param form
 */
function initWidget(form) {
    var LXTYPE_ID = form.getForm().findField('LXTYPE_ID');
    var LXTZ_ID = form.getForm().findField('LXTZ_ID');
    var LXTZ_MONTH = form.getForm().findField('LXTZ_MONTH');
    var LXTZ_DAY = form.getForm().findField('LXTZ_DAY');
    var LX_FDFS = form.getForm().findField('LX_FDFS');
    var LX_FDL = form.getForm().findField('LX_FDL');
    var JSFS_ID = form.getForm().findField('JSFS_ID');
    var JSRQ_MONTH = form.getForm().findField('JSRQ_MONTH');
    var JSRQ_DAY = form.getForm().findField('JSRQ_DAY');

    if (button_name == 'INPUT') {
        LXTYPE_ID.setValue('1');
        LXTZ_ID.disable();
        LXTZ_MONTH.disable();
        LXTZ_DAY.disable();
        LX_FDFS.disable();
        LX_FDL.disable();
        JSRQ_MONTH.disable();
        JSRQ_DAY.disable();
    } else {
        if (LXTYPE_ID.value == '1') {
            LXTZ_ID.disable();
            LXTZ_MONTH.disable();
            LXTZ_DAY.disable();
            LX_FDFS.disable();
            LX_FDL.disable();
        } else {
            if (LXTZ_ID.value == '1') {
                LXTZ_MONTH.bindStore(DebtEleStore(json_debt_yf_nd));
            } else if (LXTZ_ID.value == '2') {
                LXTZ_MONTH.bindStore(DebtEleStore(json_debt_yf_bn));
            } else if (LXTZ_ID.value == '3') {
                LXTZ_MONTH.bindStore(DebtEleStore(json_debt_yf_jd));
            } else if (LXTZ_ID.value == '4') {
                LXTZ_MONTH.disable();
            } else {
                LXTZ_MONTH.disable();
                LXTZ_DAY.disable();
            }
        }

        if (JSFS_ID.value == '1') {
            JSRQ_MONTH.bindStore(DebtEleStore(json_debt_yf_nd));
        } else if (JSFS_ID.value == '2') {
            JSRQ_MONTH.bindStore(DebtEleStore(json_debt_yf_bn));
        } else if (JSFS_ID.value == '3') {
            JSRQ_MONTH.bindStore(DebtEleStore(json_debt_yf_jd));
        } else if (JSFS_ID.value == '4') {
            JSRQ_MONTH.disable();
        } else {
            JSRQ_MONTH.disable();
            JSRQ_DAY.disable();
        }
    }
}

/**
 * 根据区划动态控制业务科室下拉框显示内容
 * @returns {Ext.data.ArrayStore}
 */
function MBEleStoreDB() {
    var MBStore = new Ext.data.ArrayStore({
        //autoLoad : true,
        fields: ['id', 'code', 'name'],
        sorters: [{
            property: 'code',
            direction: 'asc'
        }],
        proxy: {
            type: 'ajax',
            url: 'getMBEleValue.action?AD_CODE=' + AD_CODE,
            reader: {
                type: 'json',
                root: 'list'
            }
        }
    });
    return MBStore;
};
    
