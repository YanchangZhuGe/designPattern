var store_zc_type = DebtEleStoreDB("DEBT_WZZCLX");

/**
 * 保存事件
 */
function submitInfo(config, self) {
    var button_name = config["button_name"];
    var message = '';
    //校验项目基本信息表单
    var form = Ext.ComponentQuery.query('form#xmjbxx_form');
    if (!form || form.length <= 0) {
        Ext.MessageBox.alert('提示', '保存失败！无法获取表单数据');
        return false;
    }
    form = form[0];
    var xmjb_form = form.getForm().getFieldValues();
    xmjb_form = $.extend({}, xmjb_form, form.getValues());
    if (!form.isValid() || !xmjb_form) {
        message += '项目基本信息表单校验未通过！<br/>';
        return false;
    }

    //校验贷款分配表格
    var dkfp_store = DSYGrid.getGrid('dkfpxxGrid').getStore();
    var SUM_ZD_AMT_RMB = 0;
    var SUM_ZD_AMT = 0;
    for (var i = 0; i < dkfp_store.getCount(); i++) {
        var record = dkfp_store.getAt(i);
        SUM_ZD_AMT_RMB = Decimal.addBatch(parseFloat(record.get('ZD_AMT_RMB')), SUM_ZD_AMT_RMB);
        SUM_ZD_AMT = Decimal.addBatch(parseFloat(record.get('ZD_AMT')), SUM_ZD_AMT);
        if (record.get('ZFBL_RATE') > 100) {
            message += '贷款分配中，第' + (i + 1) + '行,支付比例单条不能超过100%！<br/>';
        }
    }
    if (SUM_ZD_AMT_RMB > xmjb_form.ZTZ_AMT) {
        message += '贷款分配中，总投资不能超过项目基本信息中总投资！<br/>';
    }
    if (SUM_ZD_AMT > xmjb_form.WZXY_AMT) {
        message += '贷款分配中，贷款分配不能超过项目基本信息中本位币！<br/>';
    }

    //校验还款计划表单
    var hkjhxx_form = Ext.ComponentQuery.query('form#hkjhxx_form')[0];
    var hkjhxx_formData = hkjhxx_form.getForm().getFieldValues();
    hkjhxx_formData = $.extend({}, hkjhxx_formData, hkjhxx_form.getValues());

    if (isNull(hkjhxx_formData.XYSX_DATE) || isNull(hkjhxx_formData.HKQX) || isNull(hkjhxx_formData.CHFS)) {
        Ext.MessageBox.alert('提示', '保存失败！请生成还款计划信息');
        return false;
    } else {
        if (!isNull(hkjhxx_formData.XYSX_DATE) && xmjb_form.XYSX_DATE !== hkjhxx_formData.XYSX_DATE) {
            message += '协议生效日期有变！请重新生成还款计划！<br/>';
        }
        if (!isNull(hkjhxx_formData.HKQX) && xmjb_form.HKQX !== parseInt(hkjhxx_formData.HKQX)) {
            message += '还款期限有变！请重新生成还款计划！<br/>';
        }
        if (!isNull(hkjhxx_formData.CHFS) && xmjb_form.CHFS !== hkjhxx_formData.CHFS) {
            message += '偿还方式有变！请重新生成还款计划！<br/>';
        }
        if (!isNull(hkjhxx_formData.LX_RATE) && xmjb_form.LX_RATE !== parseFloat(hkjhxx_formData.LX_RATE)) {
            message += '贷款利率有变！请重新生成还款计划！<br/>';
        }
        if (!isNull(hkjhxx_formData.ZD_RATE) && xmjb_form.ZD_RATE !== parseFloat(hkjhxx_formData.ZD_RATE)) {
            message += '转贷费率有变！请重新生成还款计划！<br/>';
        }
        if (!isNull(hkjhxx_formData.CN_RATE) && xmjb_form.CN_RATE !== parseFloat(hkjhxx_formData.CN_RATE)) {
            message += '承诺费率有变！请重新生成还款计划！<br/>';
        }
        if (!isNull(hkjhxx_formData.DB_RATE) && xmjb_form.DB_RATE !== parseFloat(hkjhxx_formData.DB_RATE)) {
            message += '担保费率有变！请重新生成还款计划！<br/>';
        }
        if (!isNull(hkjhxx_formData.WZXY_AMT) && xmjb_form.WZXY_AMT !== parseFloat(hkjhxx_formData.WZXY_AMT)) {
            message += '本位币有变！请重新生成还款计划！<br/>';
        }
        if (!isNull(hkjhxx_formData.ZHMY_AMT) && xmjb_form.ZHMY_AMT !== parseFloat(hkjhxx_formData.ZHMY_AMT)) {
            message += '折合美元有变！请重新生成还款计划！<br/>';
        }
        if (!isNull(hkjhxx_formData.WZXY_AMT_RMB) && xmjb_form.WZXY_AMT_RMB !== parseFloat(hkjhxx_formData.WZXY_AMT_RMB)) {
            message += '折合人民币有变！请重新生成还款计划！<br/>';
        }
    }
    if (!isNull(message)) {
        Ext.MessageBox.alert('提示', '保存失败！' + message);
        return false;
    }
    //校验还款计划信息
    var hkjh_store = DSYGrid.getGrid('hkjhxxGrid').getStore()
    var SUM_BJ_YB_AMT = 0;
    var SUM_BJ_MY_AMT = 0;
    var SUM_BJ_RMB_AMT = 0;
    for (var i = 0; i < hkjh_store.getCount(); i++) {
        var record = hkjh_store.getAt(i);
        SUM_BJ_YB_AMT = Decimal.addBatch(parseFloat(record.get('BJ_YB_AMT')), SUM_BJ_YB_AMT);
        SUM_BJ_MY_AMT = Decimal.addBatch(parseFloat(record.get('BJ_MY_AMT')), SUM_BJ_MY_AMT);
        SUM_BJ_RMB_AMT = Decimal.addBatch(parseFloat(record.get('BJ_RMB_AMT')), SUM_BJ_RMB_AMT);
    }
    if (SUM_BJ_YB_AMT !== parseFloat(xmjb_form.WZXY_AMT)) {
        Ext.Msg.confirm('提示', '还款计划中，合计本金本位币与项目基本信息中本位币不一致！合计本金本位币为' + SUM_BJ_YB_AMT + '万元 项目基本信息中本位币为' +
            xmjb_form.WZXY_AMT + '万元 ' + ' 是否继续保存？ ', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                send();
            }
        });
        return;
    }
    if (SUM_BJ_MY_AMT !== parseFloat(xmjb_form.ZHMY_AMT)) {
        Ext.Msg.confirm('提示', '还款计划中，合计本金美元与项目基本信息中折合美元不一致！合计本金美元为' + SUM_BJ_MY_AMT + '万元 项目基本信息中折合美元为' +
            xmjb_form.ZHMY_AMT + '万元 ' + ' 是否继续保存？ ', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                send();
            }
        });
        return;
    }
    if (SUM_BJ_RMB_AMT !== parseFloat(xmjb_form.WZXY_AMT_RMB)) {
        Ext.Msg.confirm('提示', '还款计划中，合计本金人民币与项目基本信息中折合人民币不一致！合计本金人民币为' + SUM_BJ_RMB_AMT + '万元 项目基本信息中折合人民币为' +
            xmjb_form.WZXY_AMT_RMB + '万元 ' + ' 是否继续保存？ ', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                send();
            }
        });
        return;
    }

    send();

    /**
     * 发送ajax请求
     */

    function send() {

        /**
         * 项目基本信息表单
         */
        var form = Ext.ComponentQuery.query('form#xmjbxx_form');
        form = form[0];
        var xmjb_form = form.getForm().getFieldValues();
        xmjb_form = $.extend({}, xmjb_form, form.getValues());

        /**
         * 贷款分配信息表格**/
        var dkfp_store = DSYGrid.getGrid('dkfpxxGrid').getStore();
        var data_dkfp = [];
        for (var i = 0; i < dkfp_store.getCount(); i++) {
            var record = dkfp_store.getAt(i);
            data_dkfp.push(record.getData());
        }

        /**
         * 还款计划信息表格
         */
        var hkjh_store = DSYGrid.getGrid('hkjhxxGrid').getStore();
        var data_hkjh = [];
        for (var i = 0; i < hkjh_store.getCount(); i++) {
            var record = hkjh_store.getAt(i);
            data_hkjh.push(record.getData());
        }
        //判断当前操作为录入还是修改
        var url = '';
        if (button_name == '录入') {
            var WZXY_ID = GUID.createGUID();//录入时生成WZXY_ID
            xmjb_form.WZXY_ID = WZXY_ID
            url = '/wzgl_nx/xygl/addXmInfo.action'
        } else if (button_name = '修改') {
            url = '/wzgl_nx/xygl/updateXmInfo.action'
        }
        self.setDisabled(true);
        $.ajax({
                type: "POST",
                url: url,
                data: {
                    // xmjb_form: Ext.util.JSON.encode([xmjb_form]),
                    xmjb_form: JSON.stringify([xmjb_form]),
                    data_dkfp: JSON.stringify(data_dkfp),
                    data_hkjh: JSON.stringify(data_hkjh),
                },
                dataType: 'json'
            }
        )
            .done(function (result) {
                self.setDisabled(false);
                if (!result.success) {
                    Ext.MessageBox.alert('提示', '保存失败！' + (!result.message ? '' : result.message));
                    return false;
                }
                //请求成功时处理
                Ext.toast({
                    html: '保存成功！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                self.up('window').close();
                // 刷新表格
                reloadGrid();
            })
            .fail(function (result) {
                Ext.MessageBox.alert('提示', '保存失败！' + (!result.message ? '' : result.message));
                self.setDisabled(false);
            });
    }

}

/**
 * 初始化主面板放置表格
 */
function initContentPanel() {
    return Ext.create('Ext.form.Panel', {
        height: '100%',
        flex: 5,
        region: 'center',
        layout: {
            type: 'vbox',
            align: 'stretch', //控件横向拉伸至容器大小
            flex: 1
        },
        border: false,
        items: [
            initUnitGrid()
        ]
    });
}

/**
 * 初始化主表格
 */
function initUnitGrid() {
    var headerJson = [
        {xtype: 'rownumberer', summaryType: 'count', width: 45},
        {dataIndex: "WZXY_ID", type: "string", text: "", hidden: true},
        {dataIndex: "XY_AG_NAME", type: "string", text: "项目地区", width: 150},
        {dataIndex: "WZXY_CODE", type: "string", text: "外债编码", width: 200},
        {
            dataIndex: "WZXY_NAME",
            type: "string",
            text: "项目名称",
            width: 400,
            renderer: function (data, cell, record) {
                if (record.get('WZXY_ID') != null && record.get('WZXY_ID') != '') {
                    var url = '/page/debt/wzgl_nx/xmgl/xmwh/xmyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "WZXY_ID";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('WZXY_ID'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    return data;
                }
            }
        },
        {dataIndex: "XMLB_NAME", type: "string", text: "项目类别", width: 180},
        {dataIndex: "ZQR_NAME", type: "string", text: "债权国", width: 180},
        {dataIndex: "ZXDW", type: "string", text: "执行单位", width: 200},
        {dataIndex: "ZWDW", type: "string", text: "债务单位", width: 200},
        {
            dataIndex: "LX_RATE",
            type: "float",
            text: "货款利率（%）",
            width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######') + '%';
            }
        },
        {dataIndex: "CHFS_NAME", type: "string", text: "偿还方式", width: 150},
        {dataIndex: "ZXQK_NAME", type: "string", text: "执行情况", width: 150},
    ];

    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,//多选
        rowNumber: true,
        border: false,
        autoLoad: true,
        dataUrl: '/wzgl_nx/xygl/getXmInfoGrid.action',
        height: '100%',
        flex: 1,
        tbar: [{
            xtype: "textfield",
            fieldLabel: '模糊查询',
            itemId: "XM_SEARCH",
            width: 350,
            labelWidth: 80,
            emptyText: '请输入外债编码 / 项目名称...',
            enableKeyEvents: true,
            //ENTER键刷新表格
            listeners: {
                'keydown': function (self, e, eOpts) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        reloadGrid();
                    }
                }
            }
        }],
        pageConfig: {
            pageNum: true//设置显示每页条数
        }
    });
}

/**
 * 刷新表格
 */
function reloadGrid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    //模糊查询
    var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
    //传参
    store.getProxy().extraParams = {
        mhcx: mhcx,
    };
    store.loadPage(1);
}

/**
 * 初始化弹出窗口
 *
 */
function initContentWindow(config) {
    var buttons = [
        {
            xtype: 'button',
            text: '保存',
            handler: function (self) {
                submitInfo(config, self);
            }
        },
        {
            xtype: 'button',
            text: '取消',
            handler: function (self) {
                self.up('window').close();
            }
        }
    ];
    Ext.create('Ext.window.Window', {
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 窗口高度
        maximizable: true,
        border: false,
        layout: 'fit',
        buttons: buttons,
        title: config["button_name"],
        buttonAlign: 'right',
        itemId: 'window_tb', // 窗口标识
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是close，则会将window销毁。
        items: {
            xtype: 'tabpanel',
            items: [
                {
                    title: '项目基本信息',
                    scrollable: true,
                    layout: 'fit',
                    opstatus: 0,
                    items: [initXmjbxxtForm(config)]
                },
                {
                    title: '贷款分配信息',
                    scrollable: true,
                    layout: 'fit',
                    opstatus: 1,
                    items: [initDkfpxxGrid(config)]
                },
                {
                    title: '还款计划信息',
                    scrollable: true,
                    layout: 'vbox',
                    opstatus: 3,
                    items: [
                        initHkjhxxForm(config),
                        initHkjhxxGrid(config)
                    ]
                },
                {
                    title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                    layout: 'fit',
                    opstatus: 2,
                    items: [
                        {
                            xtype: 'panel',
                            layout: 'fit',
                            itemId: 'window_file_panel',
                            items: [initWin_Fj()]
                        }
                    ]
                }
            ],
            listeners: {
                tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                    if (newCard.opstatus == 1) {
                        //如果总投资金额为空，则不让贷款分配
                        var form = Ext.ComponentQuery.query('form#xmjbxx_form')[0].getForm();
                        var ZTZ_AMT = form.getValues().ZTZ_AMT;
                        if (ZTZ_AMT == null || '' == ZTZ_AMT) {
                            Ext.Msg.alert('提示', '请填写总投资金额！');
                            tabPanel.setActiveTab(oldCard);
                            return;
                        }
                    } else if (newCard.opstatus == 3) {
                        //如果协议生效日期 还款期限 偿还方式 为空，则不让还款计划
                        var form = Ext.ComponentQuery.query('form#xmjbxx_form')[0].getForm();
                        var XYSX_DATE = form.getValues().XYSX_DATE;
                        var HKQX = form.getValues().HKQX;
                        var CHFS = form.getValues().CHFS;
                        if (XYSX_DATE == null || '' == XYSX_DATE || HKQX == null || '' == HKQX || CHFS == null || '' == CHFS) {
                            Ext.Msg.alert('提示', '请填写协议生效日期、还款期限以及偿还方式！');
                            tabPanel.setActiveTab(oldCard);
                            return;
                        }
                    }
                }
            }

        },
    }).show();
}

/**
 * 初始化项目基本信息面板
 */
function initXmjbxxtForm(config) {
    var form = Ext.create('Ext.form.Panel', {
        itemId: 'xmjbxx_form',
        width: '100%',
        height: '100%',
        autoScroll: true,
        //bodyStyle : 'overflow-x:visible; overflow-y:scroll',
        layout: 'column',
        border: false,
        defaultType: 'textfield',
        defaults: {
            margin: '2 5 2 5',
            columnWidth: .33,
            labelWidth: 125//控件默认标签宽度
        },
        items: [
            {xtype: 'label', text: '基本信息', width: 100, style: 'color:#048DBF', columnWidth: 1},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {fieldLabel: '外债ID', name: 'WZXY_ID', hidden: true},
            {fieldLabel: '<span class="required">✶</span>项目地区', name: 'XY_AG_NAME', allowBlank: false},
            {fieldLabel: '<span class="required">✶</span>项目名称', name: 'WZXY_NAME', columnWidth: 0.5, allowBlank: false},
            {fieldLabel: '<span class="required">✶</span>外债编码', name: 'WZXY_CODE', allowBlank: false,},
            {
                fieldLabel: '<span class="required">✶</span>项目类别',
                name: 'XMLB',
                editable: false,
                allowBlank: false,
                xtype: 'combobox',
                valueField: 'id',
                displayField: 'name',
                store: DebtEleStoreDB("DEPT_XMLB"),
            },
            {
                fieldLabel: '<span class="required">✶</span>债权国',
                name: 'ZQR_ID',
                xtype: 'treecombobox',
                editable: false,
                allowBlank: false,
                valueField: 'id',
                displayField: 'name',
                store: DebtEleTreeStoreDBTable('DSY_V_ELE_ZQR', {condition: " and (guid like '02%' or guid like '03%') "}),
            },
            {fieldLabel: '<span class="required">✶</span>执行单位', name: 'ZXDW', allowBlank: false,},
            {fieldLabel: '<span class="required">✶</span>债务单位', name: 'ZWDW', allowBlank: false,},
            {fieldLabel: '担保单位', name: 'DBDW', allowBlank: true,},
            {
                fieldLabel: '转贷机构',
                name: 'ZDJG',
                editable: false,
                allowBlank: true,
                xtype: 'combobox',
                valueField: 'id',
                displayField: 'name',
                store: DebtEleStoreDB("DEBT_ZDJG"),
                //columnWidth: 0.5
            },
            {xtype: 'label', text: '利率及期限', style: 'color:#048DBF', columnWidth: 1, width: 100,},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {
                fieldLabel: '<span class="required">✶</span>协议生效日期',
                name: 'XYSX_DATE',
                xtype: 'datefield',
                format: 'Y-m-d',
                value: new Date(),
                editable: false,
                allowBlank: false
            },
            {
                fieldLabel: '首次提款日期',
                name: 'SCTK_DATE',
                xtype: 'datefield',
                format: 'Y-m-d',
                editable: false,
                allowBlank: true,
                listeners: {
                    'change': function (self, newValue, oldValue) {
                        var form = self.up('form').getForm();
                        var TQJZ_DATE = form.findField('TQJZ_DATE').value;
                        if (TQJZ_DATE == null || TQJZ_DATE == "" || newValue == null || newValue == "") {
                            return;
                        }
                        newValue = format(newValue, 'yyyy-MM-dd');
                        TQJZ_DATE = format(TQJZ_DATE, 'yyyy-MM-dd');
                        if (newValue > TQJZ_DATE) {
                            Ext.MessageBox.alert('提示', '首次提款日期必须小于提款截止日期!');
                            form.findField("SCTK_DATE").setValue("");
                            return;
                        }
                    }
                }
            },
            {
                fieldLabel: '提款截止日期',
                name: 'TQJZ_DATE',
                xtype: 'datefield',
                format: 'Y-m-d',
                editable: false,
                allowBlank: true,
                listeners: {
                    'change': function (self, newValue, oldValue) {
                        var form = self.up('form').getForm();
                        var SCTK_DATE = form.findField('SCTK_DATE').value;
                        if (SCTK_DATE == null || SCTK_DATE == "" || newValue == null || newValue == "") {
                            return;
                        }
                        SCTK_DATE = format(SCTK_DATE, 'yyyy-MM-dd');
                        newValue = format(newValue, 'yyyy-MM-dd');
                        if (newValue < SCTK_DATE) {
                            Ext.MessageBox.alert('提示', '提款截止日期必须大于首次提款日期!');
                            form.findField("TQJZ_DATE").setValue("");
                            return;
                        }
                    }
                }
            },
            {
                fieldLabel: '<span class="required">✶</span>贷款期限（年）',
                name: 'DKQX',
                xtype: 'numberFieldFormat',
                allowBlank: false,
                hideTrigger: true,
                minValue: 0,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '<span class="required">✶</span>贷款利率（%）',
                name: 'LX_RATE',
                xtype: 'numberFieldFormat',
                allowBlank: false,
                allowDecimals: true,
                decimalPrecision: 6,
                minValue: 0,
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '<span class="required">✶</span>还款期限（年）',
                name: 'HKQX',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                allowBlank: false,
                minValue: 0,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '浮动利率（%）',
                name: 'LX_FDL',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                allowDecimals: true,
                decimalPrecision: 6,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '宽限期（年）',
                name: 'KXQ',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '<span class="required">✶</span>转贷费率（%）',
                name: 'ZD_RATE',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                allowBlank: false,
                allowDecimals: true,
                decimalPrecision: 6,
                minValue: 0,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '项目执行期（年）',
                name: 'XMZXQ',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '<span class="required">✶</span>承诺费率（%）',
                name: 'CN_RATE',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                allowBlank: false,
                allowDecimals: true,
                decimalPrecision: 6,
                minValue: 0,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '<span class="required">✶</span>担保费率（%）',
                name: 'DB_RATE',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                allowBlank: false,
                allowDecimals: true,
                decimalPrecision: 6,
                minValue: 0,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {xtype: 'label', text: '账户及方式', width: 100, style: 'color:#048DBF', columnWidth: 1,},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {
                fieldLabel: '<span class="required">✶</span>项目分类',
                name: 'XMFL',
                editable: false,
                allowBlank: false,
                xtype: 'combobox',
                valueField: 'id',
                displayField: 'name',
                store: DebtEleStoreDB("DEBT_XMFL"),
            },
            {
                fieldLabel: '还款来源',
                name: 'HKLY',
                editable: false,
                allowBlank: true,
                xtype: 'combobox',
                valueField: 'id',
                displayField: 'name',
                store: DebtEleStoreDB("DEBT_HKLY"),
            },
            {fieldLabel: '专用开户行', name: 'ZYKHH',},
            {
                fieldLabel: '<span class="required">✶</span>偿还方式',
                name: 'CHFS',
                editable: false,
                allowBlank: false,
                xtype: 'combobox',
                valueField: 'id',
                displayField: 'name',
                //store: DebtEleStoreDB("DEBT_HKLY"),
                store: DebtEleStoreDB("DEBT_FXZQ"),
            },
            {fieldLabel: '户名', name: 'HM',},
            {fieldLabel: '账号', name: 'ZH',},
            {xtype: 'label', text: '项目担保及反担保（万元）', width: 300, style: 'color:#048DBF', columnWidth: 1,},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {
                fieldLabel: '省区财政担保',
                name: 'SQCZDB_AMT',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                emptyText: '0.00',
                allowBlank: true,
                allowDecimals: true,
                decimalPrecision: 6,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '市县财政担保',
                name: 'SXCZDB_AMT',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                emptyText: '0.00',
                allowBlank: true,
                allowDecimals: true,
                decimalPrecision: 6,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '计委反担保',
                name: 'JWFDB_AMT',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                emptyText: '0.00',
                allowBlank: true,
                allowDecimals: true,
                decimalPrecision: 6,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '转贷银行担保',
                name: 'ZDYHDB_AMT',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                emptyText: '0.00',
                allowBlank: true,
                allowDecimals: true,
                decimalPrecision: 6,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {xtype: 'label', text: '项目执行情况', width: 100, columnWidth: 1, style: 'color:#048DBF',},
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {
                fieldLabel: '<span class="required">✶</span>执行情况',
                name: 'ZXQK',
                editable: false,
                allowBlank: false,
                xtype: 'combobox',
                valueField: 'id',
                displayField: 'name',
                store: DebtEleStoreDB("DEBT_ZXQK"),
            },
            {
                fieldLabel: '行业分类',
                name: 'HYFL',
                editable: false,
                allowBlank: true,
                xtype: 'combobox',
                valueField: 'id',
                displayField: 'name',
                store: DebtEleStoreDB("DEBT_HYFL"),
            },
            {fieldLabel: '采购公司', name: 'CGGS', allowBlank: true,},
            {
                xtype: 'label', text: '项目投资（万元）', width: 100, style: 'color:#048DBF', columnWidth: 1,
            },
            {xtype: 'menuseparator', columnWidth: 1, border: true},
            {
                fieldLabel: '<span class="required">✶</span>本位币/SDR',
                name: 'WZXY_AMT',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                allowBlank: false,
                allowDecimals: true,
                decimalPrecision: 6,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            },
            {
                fieldLabel: '<span class="required">✶</span>币种',
                name: 'FM_ID',
                xtype: 'combobox',
                editable: false,
                allowBlank: false,
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStoreDB("DEBT_WB"),
            },
            {
                fieldLabel: '<span class="required">✶</span>折合美元',
                name: 'ZHMY_AMT',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                allowBlank: false,
                allowDecimals: true,
                decimalPrecision: 6,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            },
            {
                fieldLabel: '<span class="required">✶</span>折合人民币',
                name: 'WZXY_AMT_RMB',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                allowBlank: false,
                allowDecimals: true,
                decimalPrecision: 6,
                minValue: 0,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                },
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
            {
                fieldLabel: '赠款',
                name: 'ZK_AMT',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                decimalPrecision: 6,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            },
            {
                fieldLabel: '<span class="required">✶</span>总投资',
                name: 'ZTZ_AMT',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                fieldCls: 'form-unedit-number',
                allowBlank: false,
                readOnly: true,
                decimalPrecision: 6,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
            },
            {
                fieldLabel: '配套资金',
                name: 'PTZJ_AMT',
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                decimalPrecision: 6,
                minValue: 0,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                },
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
    if (!!config.data) {
        var xmjbForm = config["data"]["xmjbForm"];
        form.getForm().setValues(xmjbForm);
    }
    return form;
}

/**
 * 初始化贷款分配信息表格
 */
function initDkfpxxGrid(config) {
    var headerJson = [
        {
            xtype: 'rownumberer',
            width: 45,
            // summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "ZDMX_ID", type: "string", text: "贷款明细ID", hidden: true},
        {dataIndex: "AG_NAME", type: "string", text: "项目区", width: 150, editor: 'textfield'},
        {
            dataIndex: "ZC_TYPE",
            text: "支出类型",
            width: 200,
            type: "string",
            editor: {
                xtype: 'combobox',
                displayField: 'name',//显示在下拉框中的值，就是下拉框时，看到下拉框中的文本
                valueField: 'id',//下拉框的值，即在后台得到的值
                editable: false,
                store: store_zc_type,
            },
            tdCls: 'grid-cell',
            renderer: function (value) {
                var store = store_zc_type;
                var record = store.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            },

        },
        {
            dataIndex: "ZD_AMT_RMB",
            type: "float",
            text: "总投资（人民币）（万元）",
            width: 200,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                allowDecimals: true,
                decimalPrecision: 6,
                minValue: 0,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            dataIndex: "ZD_AMT",
            type: "float",
            text: "贷款分配（原币）（万元）",
            width: 200,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                allowDecimals: true,
                decimalPrecision: 6,
                minValue: 0,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            dataIndex: "ZFBL_RATE",
            type: "float",
            text: "支付比例（%）",
            width: 200,
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                allowDecimals: true,
                decimalPrecision: 6,
                minValue: 0,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            renderer: function (value) {
                return isNull(value) ? '' : Ext.util.Format.number(value, '0,000.######') + '%';
            }
        }
    ];
    var tbar = [
        {
            xtype: 'button',
            text: '增行',
            name: 'INPUT',
            icon: '/image/sysbutton/add.png',
            width: 70,
            handler: function (btn) {
                var data = {};
                var grid = DSYGrid.getGrid('dkfpxxGrid');
                var record = grid.getCurrentRecord();
                var index = null;
                if (!!record) {
                    index = record.recordIndex;
                }
                grid.insertData(index, data);
            }
        },
        {
            xtype: 'button',
            text: '删行',
            name: 'DELETE',
            icon: '/image/sysbutton/delete.png',
            width: 70,
            handler: function () {
                var grid = DSYGrid.getGrid('dkfpxxGrid');
                var store = grid.getStore();
                var sm = grid.getSelectionModel();
                store.remove(sm.getSelection());
                if (store.getCount() > 0) {
                    sm.select(0);
                }
            }
        },
        '->',
    ];


    /**
     * 设置贷款分配信息表格属性
     */
    var dkconfig = {
        itemId: 'dkfpxxGrid',
        border: false,
        flex: 1,
        data: [],
        checkBox: true,
        autoScroll: true,
        tbar: tbar,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'cellEdit',
                clicksToMoveEditor: 1
            }
        ],
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: true// 显示行号
        },
    };
    //生成贷款分配信息表格
    var dkfpxxGrid = DSYGrid.createGrid(dkconfig);
    if (!!config.data) {
        var dkfpList = config.data.dkfpList;
        dkfpxxGrid.insertData(null, dkfpList);
    }
    return dkfpxxGrid;
}

/**
 * 初始化还款信息表单并隐藏
 */
function initHkjhxxForm(config) {
    //还款计划表单
    //协议生效初始化日期、还款期限、偿还方式、贷款利率、转贷费率、承诺费率、担保费率、本位币、折合美元、折合人民币
    var hkjhxxForm = Ext.create('Ext.form.Panel', {
        itemId: 'hkjhxx_form',
        layout: 'column',
        height: 0,
        width: '100%',
        defaultType: 'textfield',
        border: false,
        items: [
            {fieldLabel: '协议生效初始化日期', name: "XYSX_DATE", hidden: true},
            {fieldLabel: '还款期限', name: "HKQX", hidden: true},
            {fieldLabel: '偿还方式', name: "CHFS", hidden: true},
            {fieldLabel: '贷款利率', name: "LX_RATE", xtype: 'numberFieldFormat', hidden: true},
            {fieldLabel: '转贷费率', name: "ZD_RATE", xtype: 'numberFieldFormat', hidden: true},
            {fieldLabel: '承诺费率', name: "CN_RATE", xtype: 'numberFieldFormat', hidden: true},
            {fieldLabel: '担保费率', name: "DB_RATE", xtype: 'numberFieldFormat', hidden: true},
            {fieldLabel: '本位币', name: "WZXY_AMT", xtype: 'numberFieldFormat', hidden: true},
            {fieldLabel: '折合美元', name: "ZHMY_AMT", xtype: 'numberFieldFormat', hidden: true},
            {fieldLabel: '折合人民币', name: "WZXY_AMT_RMB", xtype: 'numberFieldFormat', hidden: true},
        ]
    });
    if (!!config.data) {
        var form = config["data"]["xmjbForm"];
        hkjhxxForm.getForm().setValues(form);
    }
    return hkjhxxForm;
}

/**
 * 初始化还款信息表格
 */
function initHkjhxxGrid(config) {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45, summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "HKJH_ID ", type: "string", text: "还款计划ID", hidden: true},
        {dataIndex: "HKJH_DATE", type: "string", text: "年份", width: 150},
        {
            dataIndex: "LX_RATE",
            type: "float",
            text: "利率（%）",
            width: 200,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######') + '%';
            }
        },
        {
            dataIndex: "BJ",
            type: "float",
            text: "本金",
            columns: [
                {
                    dataIndex: "BJ_YB_AMT",
                    type: "float",
                    text: "本位币",
                    width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BJ_MY_AMT",
                    type: "float",
                    text: "美元",
                    width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "BJ_RMB_AMT",
                    type: "float",
                    text: "人民币",
                    width: 200,
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
            dataIndex: "LX",
            type: "float",
            text: "利息",
            columns: [
                {
                    dataIndex: "LX_YB_AMT",
                    type: "float",
                    text: "本位币",
                    width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LX_MY_AMT",
                    type: "float",
                    text: "美元",
                    width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "LX_RMB_AMT",
                    type: "float",
                    text: "人民币",
                    width: 200,
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
            dataIndex: "CNF",
            type: "float",
            text: "承诺费",
            columns: [
                {
                    dataIndex: "CNF_YB_AMT",
                    type: "float",
                    text: "本位币",
                    width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CNF_MY_AMT",
                    type: "float",
                    text: "美元",
                    width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "CNF_RMB_AMT",
                    type: "float",
                    text: "人民币",
                    width: 200,
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
            dataIndex: "ZDF",
            type: "float",
            text: "转贷费",
            columns: [
                {
                    dataIndex: "ZDF_YB_AMT",
                    type: "float",
                    text: "本位币",
                    width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_MY_AMT",
                    type: "float",
                    text: "美元",
                    width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "ZDF_RMB_AMT",
                    type: "float",
                    text: "人民币",
                    width: 200,
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
            dataIndex: "DBF",
            type: "float",
            text: "担保费",
            columns: [
                {
                    dataIndex: "DBF_YB_AMT",
                    type: "float",
                    text: "本位币",
                    width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_MY_AMT",
                    type: "float",
                    text: "美元",
                    width: 200,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.######');
                    }
                },
                {
                    dataIndex: "DBF_RMB_AMT",
                    type: "float",
                    text: "人民币",
                    width: 200,
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
    var tbar = [{
        xtype: 'button',
        text: '生成',
        icon: '/image/sysbutton/search.png',
        handler: function (btn) {
            //得到项目基本信息表单
            var form = Ext.ComponentQuery.query('form#xmjbxx_form')[0];
            var formData = form.getForm().getFieldValues();
            formData = $.extend({}, formData, form.getValues());

            //得到还款计划表单
            var hkjhxx_form = Ext.ComponentQuery.query('form#hkjhxx_form')[0].getForm();
            hkjhxx_form.setValues(formData);

            //协议生效初始化日期
            var XYSX_DATE = formData.XYSX_DATE;
            //还款期限
            var HKQX = formData.HKQX;
            //偿还方式
            var CHFS = formData.CHFS;
            //贷款利率
            var LX_RATE = formData.LX_RATE;
            //转贷费率
            var ZD_RATE = formData.ZD_RATE;
            //承诺费率
            var CN_RATE = formData.CN_RATE;
            //担保费率
            var DB_RATE = formData.DB_RATE;
            //本位币
            var WZXY_AMT = formData.WZXY_AMT;
            //折合美元
            var ZHMY_AMT = formData.ZHMY_AMT;
            //折合人民币
            var WZXY_AMT_RMB = formData.WZXY_AMT_RMB;


            var detailStore = getHkjhDetail(XYSX_DATE, HKQX, CHFS, LX_RATE, ZD_RATE, CN_RATE, DB_RATE, WZXY_AMT, ZHMY_AMT, WZXY_AMT_RMB);
            var hkjh_store = DSYGrid.getGrid('hkjhxxGrid').getStore();

            hkjh_store.removeAll();
            hkjh_store.setRecords(detailStore);
        }
    },
        '->',
        {
            xtype: 'label',
            text: '单位:万元',
            width: 80,
            cls: "label-color"
        }
    ];

    /**
     * 计算还款计划信息
     * 协议生效初始化日期、还款期限、偿还方式、贷款利率、转贷费率、承诺费率、担保费率、本位币、折合美元、折合人民币
     */
    function getHkjhDetail(XYSX_DATE, HKQX, CHFS, LX_RATE, ZD_RATE, CN_RATE, DB_RATE, WZXY_AMT, ZHMY_AMT, WZXY_AMT_RMB) {

        var details = new Array();
        //总共还款期限的月数
        var totalmonth = Decimal.mulBatch(parseInt(HKQX), 12);
        //根据还款期限计算总条数
        var cycle;
        if (parseInt(CHFS) == 0) {
            cycle = 1;
        } else {
            cycle = parseInt(Decimal.divBatch(totalmonth, parseInt(CHFS)));
        }
        //利率
        var LX_RATE = LX_RATE;
        //本金本位币
        var BJ_YB_AMT = parseFloat(Decimal.divBatch(WZXY_AMT, cycle));
        //本金美元
        var BJ_MY_AMT = parseFloat(Decimal.divBatch(ZHMY_AMT, cycle));
        //本金人民币
        var BJ_RMB_AMT = parseFloat(Decimal.divBatch(WZXY_AMT_RMB, cycle));

        //利息本位币
        var LX_YB_AMT = parseFloat(Decimal.mulBatch(BJ_YB_AMT, (Decimal.divBatch(LX_RATE, 100))));
        //利息美元
        var LX_MY_AMT = parseFloat(Decimal.mulBatch(BJ_MY_AMT, (Decimal.divBatch(LX_RATE, 100))));
        //利息人民币
        var LX_RMB_AMT = parseFloat(Decimal.mulBatch(BJ_RMB_AMT, (Decimal.divBatch(LX_RATE, 100))));

        //承诺费本位币
        var CNF_YB_AMT = parseFloat(Decimal.mulBatch(BJ_YB_AMT, (Decimal.divBatch(CN_RATE, 100))));
        //承诺费美元
        var CNF_MY_AMT = parseFloat(Decimal.mulBatch(BJ_MY_AMT, (Decimal.divBatch(CN_RATE, 100))));
        //承诺费人民币
        var CNF_RMB_AMT = parseFloat(Decimal.mulBatch(BJ_RMB_AMT, (Decimal.divBatch(CN_RATE, 100))));

        //转贷费本位币
        var ZDF_YB_AMT = parseFloat(Decimal.mulBatch(BJ_YB_AMT, (Decimal.divBatch(ZD_RATE, 100))));
        //转贷费美元
        var ZDF_MY_AMT = parseFloat(Decimal.mulBatch(BJ_MY_AMT, (Decimal.divBatch(ZD_RATE, 100))));
        //转贷费人民币
        var ZDF_RMB_AMT = parseFloat(Decimal.mulBatch(BJ_RMB_AMT, (Decimal.divBatch(ZD_RATE, 100))));

        //担保费本位币
        var DBF_YB_AMT = parseFloat(Decimal.mulBatch(BJ_YB_AMT, (Decimal.divBatch(DB_RATE, 100))));
        //担保费美元
        var DBF_MY_AMT = parseFloat(Decimal.mulBatch(BJ_MY_AMT, (Decimal.divBatch(DB_RATE, 100))));
        //担保费人民币
        var DBF_RMB_AMT = parseFloat(Decimal.mulBatch(BJ_RMB_AMT, (Decimal.divBatch(DB_RATE, 100))));

        var HKJH_DATE = XYSX_DATE;

        for (var i = 1; i <= cycle; i++) {
            var array = {};
            //计算下一个年份时间
            if (cycle == 1) {
                HKJH_DATE = Ext.util.Format.date(Ext.Date.add(new Date(XYSX_DATE), Ext.Date.MONTH, totalmonth), 'Y-m-d');
            } else {
                HKJH_DATE = Ext.util.Format.date(Ext.Date.add(new Date(XYSX_DATE), Ext.Date.MONTH, i * parseInt(CHFS)), 'Y-m-d');
            }
            array.HKJH_DATE = HKJH_DATE;
            array.LX_RATE = LX_RATE;
            array.BJ_YB_AMT = BJ_YB_AMT;
            array.BJ_MY_AMT = BJ_MY_AMT;
            array.BJ_RMB_AMT = BJ_RMB_AMT;
            array.LX_YB_AMT = LX_YB_AMT;
            array.LX_MY_AMT = LX_MY_AMT;
            array.LX_RMB_AMT = LX_RMB_AMT;
            array.CNF_YB_AMT = CNF_YB_AMT;
            array.CNF_MY_AMT = CNF_MY_AMT;
            array.CNF_RMB_AMT = CNF_RMB_AMT;
            array.ZDF_YB_AMT = ZDF_YB_AMT;
            array.ZDF_MY_AMT = ZDF_MY_AMT;
            array.ZDF_RMB_AMT = ZDF_RMB_AMT;
            array.DBF_YB_AMT = DBF_YB_AMT;
            array.DBF_MY_AMT = DBF_MY_AMT;
            array.DBF_RMB_AMT = DBF_RMB_AMT;

            details.push(array);
        }
        return details;
    }

    /**
     * 设置还款计划信息表格属性
     */
    var hkconfig = {
        itemId: 'hkjhxxGrid',
        border: false,
        width: '100%',
        flex: 1,
        data: [],
        tbar: tbar,
        checkBox: true,
        autoScroll: true,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: true// 显示行号
        }
    };
    //生成还款计划信息表格
    var hkjhxxGrid = DSYGrid.createGrid(hkconfig);
    if (!!config.data) {
        var hkjhList = config.data.hkjhList;
        hkjhxxGrid.insertData(null, hkjhList);
    }
    return hkjhxxGrid;
}

/**
 * 初始化附件标签页
 */
function initWin_Fj() {
    //WZXY_ID
    var xmjb_form = Ext.ComponentQuery.query('form#xmjbxx_form')[0].getForm().getValues();
    var WZXY_ID = xmjb_form.WZXY_ID;
    var grid = UploadPanel.createGrid({
        busiType: ' ',//业务类型
        busiId: WZXY_ID,//业务ID
        busiProperty: '%',//业务规则，默认为‘%’
        editable: true,//是否可以修改附件内容，默认为ture
        gridConfig: {
            itemId: 'window_dkxxtb_contentForm_tab_xyfj_grid'
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
        if (grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}

$(document).ready(function () {
    var button_name = '';//当前操作按钮名称
    var items = [
        {
            xtype: 'button',
            text: '查询',
            name: 'find',
            icon: '/image/sysbutton/search.png',
            handler: function (btn) {
                reloadGrid();
            }
        },
        {
            xtype: 'button',
            text: '录入',
            name: 'add',
            icon: '/image/sysbutton/add.png',
            handler: function (btn) {
                initContentWindow({
                    button_name: btn.text
                });
            }
        },
        {
            xtype: 'button',
            text: '修改',
            name: 'edit',
            icon: '/image/sysbutton/edit.png',
            handler: function (btn) {
                // 检验是否选中数据 获取选中数据
                var currentRecord = DSYGrid.getGrid('contentGrid').getCurrentRecord();
                if (currentRecord == null) {
                    Ext.MessageBox.alert('提示', '请选择至少一条数据!');
                    return;
                }
                var wzxy_id = currentRecord.data.WZXY_ID;
                //根据参数id发送ajax请求
                $.post("/wzgl_nx/xygl/getXmInfoById.action", {
                    wzxy_id: wzxy_id,
                }, function (data) {
                    data["xmjbForm"]["WZXY_ID"] = wzxy_id;
                    initContentWindow({
                        button_name: btn.text,
                        data: data
                    });
                }, "json");
            }
        },
        {
            xtype: 'button',
            text: '删除',
            name: 'delete',
            icon: '/image/sysbutton/delete.png',
            handler: function (btn) {
                //获取表格中数据
                var records = DSYGrid.getGrid('contentGrid').getSelection();
                //检验是否远中
                if (records.length == 0) {
                    Ext.MessageBox.alert('提示', '请至少选择一条数据！');
                    return;
                }

                Ext.Msg.confirm('提示', '请确认是否删除', function (btn_confirm) {
                    if (btn_confirm == 'yes') {
                        var arr = [];
                        Ext.Array.forEach(records, function (record) {
                            arr.push(record.get("WZXY_ID"))
                        });
                        $.post("/wzgl_nx/xygl/deleteXmInfo.action", {
                            ids: arr
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: "删除成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            } else {
                                Ext.MessageBox.alert('提示', '删除失败！' + data.message);
                            }
                            //刷新表格
                            reloadGrid();
                        }, "json");
                    }
                });
            }
        },
        '->',
        initButton_OftenUsed(),
        initButton_Screen()
    ];
    /**
     * 初始化定义面板
     */
    var panel = Ext.create('Ext.panel.Panel', {
            renderTo: Ext.getBody(),
            height: '100%',
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            border: false,
            tbar: items,
            items: [
                initContentPanel()//初始化表格
            ]
        }
    );
});