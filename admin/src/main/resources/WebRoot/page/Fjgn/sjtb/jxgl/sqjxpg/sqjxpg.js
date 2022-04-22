/**
 * 创建可编辑的事件绩效评估表单
 * @param XM_ID
 * @param BILL_ID
 * @returns {Ext.form.Panel}
 */
function initFormPanel_sqjxpg(XM_ID, BILL_ID) {
    return initWindow_zqxxtb_contentForm_tab_sqjxpg(XM_ID, BILL_ID, false, 'sqjxpgForm');
}

/**
 * 创建不可编辑的事件绩效评估表单
 * @param XM_ID
 * @param BILL_ID
 * @returns {Ext.form.Panel}
 */
function initFormPanel_sqjxpg_noEditable(XM_ID, BILL_ID) {
    let itemId = 'sqjxpgForm-' + Math.floor(Math.random() * 10);
    return initWindow_zqxxtb_contentForm_tab_sqjxpg(XM_ID, BILL_ID, true, itemId);
}

/**
 * 创建事前绩效评估页签，并根据项目id和储备申报id加载数据
 * @param XM_ID
 * @param BILL_ID
 * @param isNoEditable 页面是否可编辑，挂载在项目一户式显示时不可编辑
 * @param itemId form表单唯一标识
 * @returns {Ext.form.Panel}
 */
function initWindow_zqxxtb_contentForm_tab_sqjxpg(XM_ID, BILL_ID, isNoEditable, itemId) {
    let formPanel = Ext.create('Ext.form.Panel', {
        itemId: itemId,
        width: '100%',
        height: '100%',
        scrollable: true,
        layout: 'fit',
        border: false,
        defaults: {
            anchor: '100%'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldcontainer',
                layout: 'anchor',
                defaults: {
                    anchor: '100%'
                    // margin: '20 10 0 0'
                },
                items: [
                    {
                        xtype: 'fieldcontainer',
                        layout: 'column',
                        defaultType: 'textfield',
                        fieldDefaults: {
                            labelWidth: 225,
                            columnWidth: .99,
                            margin: '5 5 5 5'
                        },
                        items: [
                            {
                                fieldLabel: 'BILL_ID',
                                name: 'BILL_ID',
                                allowBlank: true,
                                hidden: true
                            },
                            {
                                fieldLabel: 'XM_ID',
                                name: 'XM_ID',
                                allowBlank: true,
                                hidden: true
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>项目实施的必要性、公益性、收益性、资本性',
                                name: 'SQJX_T1',
                                xtype: 'textarea',
                                allowBlank: false,
                                maxLength: 2000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入2000个汉字！"
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>项目建设投资合规性与项目成熟度',
                                name: 'SQJX_T2',
                                xtype: 'textarea',
                                allowBlank: false,
                                maxLength: 2000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入2000个汉字！"
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>项目资金来源和到位可行性',
                                name: 'SQJX_T3',
                                xtype: 'textarea',
                                allowBlank: false,
                                maxLength: 2000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入2000个汉字！"
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>项目收入、成本、收益预测合理性',
                                name: 'SQJX_T4',
                                xtype: 'textarea',
                                allowBlank: false,
                                maxLength: 2000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入2000个汉字！"
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>债券资金需求合理性',
                                name: 'SQJX_T5',
                                xtype: 'textarea',
                                allowBlank: false,
                                maxLength: 2000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入2000个汉字！"
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>项目偿债计划可行性和偿债风险点',
                                name: 'SQJX_T6',
                                xtype: 'textarea',
                                allowBlank: false,
                                maxLength: 2000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入2000个汉字！"
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>绩效目标合理性',
                                name: 'SQJX_T7',
                                xtype: 'textarea',
                                allowBlank: false,
                                maxLength: 2000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入2000个汉字！"
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>其他需要纳入事前绩效评估的事项',
                                name: 'SQJX_T8',
                                xtype: 'textarea',
                                allowBlank: false,
                                maxLength: 2000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入2000个汉字！"
                            }
                        ]
                    }

                ]
            }
        ],
        listeners: {
            beforerender: function (self) {
                // 设置页面不可编辑
                if (!!isNoEditable) {
                    setItemsReadOnly(self.items);
                }
            }
        }
    });
    // 加载数据
    formPanel.load({
        url: '/sqjxpg/loadSqjx.action',
        method: 'GET',
        params: {
            BILL_ID: BILL_ID,
            XM_ID: XM_ID
        },
        success: function (form, action) {
            // 为事前绩效指标表单赋值
            form.setValues(action.result.data);
        },
        failure: function (form, action) {
            form.setValues(action.result.data);
        }
    });
    return formPanel;
}

/**
 * 获取事前绩效指标数据
 */
function getSqjxpgData() {
    let formPanel = Ext.ComponentQuery.query('form[itemId="sqjxpgForm"]')[0];
    if (!formPanel.isValid()) {
        Ext.toast({
            html: "事前绩效评估：请检查必填项！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400,
            listeners: {
                "show": function () {
                 setActiveTabPanelByTabTitle("事前绩效评估");
                }
            }
        });
        return false;
    }
    let values = formPanel.getValues();
    return values;
}