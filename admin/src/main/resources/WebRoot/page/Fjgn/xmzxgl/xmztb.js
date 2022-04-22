$.extend(xmzx_json_common, {
    defautItems: WF_STATUS,//默认状态
    xmzx_headerjson: [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "ID", width: 150, type: "string", text: "唯一ID", hidden: true},
        {dataIndex: "AG_NAME", width: 250, type: "string", text: "单位名称"},
        {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
 		{
            dataIndex: "XM_NAME", width: 250, type: "string", text: "项目名称",
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
        {dataIndex: "ZB_DATE", width: 150, type: "string", text: "招标日期"},
        {dataIndex: "ZB_TYPE", width: 150, type: "string", text: "招标类型",
            renderer: function (value) {
                var store = DebtEleStore(json_debt_zblx);
                var record = store.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
            },
        {dataIndex: "YS_AMT", width: 150, type: "float", text: "预算金额（万元）",summaryType: 'sum',
        	renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {dataIndex: "ZBDW", width: 150, type: "string", text: "中标单位名称"},
        {dataIndex: "TYSHXY_CODE", width: 200, type: "string", text: "中标单位统一社会信用代码"},
        {dataIndex: "ZB_AMT", width: 150, type: "float", text: "中标金额（万元）",summaryType: 'sum',
        	renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {dataIndex: "HTQD_DATE", width: 150, type: "string", text: "合同签订日期"},
        {dataIndex: "HT_AMT", width: 150, type: "float", text: "合同金额（万元）",summaryType: 'sum',
        	renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }	
        },
        {dataIndex: "HTQX", width: 150, type: "string", text: "合同期限（月）"},
        {dataIndex: "LX_YEAR", type: "string", text: "立项年度"},
        {dataIndex: "JSXZ_NAME", type: "string", text: "建设性质"},
        {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质"},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型"},
        {dataIndex: "BUILD_STATUS_NAME", width: 120, type: "string", text: "建设状态"},
        {
            dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算（万元）",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {dataIndex: "REMARK", width: 150, type: "string", text: "备注"}
    ],
    dataUrl: '/findJsxmMainInfo.action',
    items_content: function () {
        return [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧2个表格
        ];
    },
     window_title: '项目招投标'
});


//招标类型
var json_debt_zblx = [
    {id: "1", code: "1", name: "项目建设单位"},
    {id: "2", code: "2", name: "项目运营单位"}
];

/**
 * 初始化招投标主表单
 */
function initWiondow_form(btn) {
    var config = {
        editable: btn.editable,
        busiId: btn.busiId
    };
    return Ext.create('Ext.form.Panel', {
        itemId: 'xmzx_form',
        width: '100%',
        height: '100%',
        layout: 'vbox',
        fileUpload: true,
        padding: '2 5 0 5',
        defaults: {
            columnWidth: .33,//输入框的长度（百分比）
            labelAlign: "right",
            width: '100%'
        },
        border: false,
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    labelWidth: 100//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '招投标',
                        name: "ID",
                        value: btn.busiId,
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目ID',
                        name: "XM_ID",
                        editable: false,
                        hidden: true
                    },
                    {
                        xtype: "displayfield",
                        fieldLabel: '项目名称',
                        name: "XM_NAME",
                        columnWidth: .999,
                        editable: false
                    }
                ]
            },
            {   // 分割线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    labelWidth: 110
                },
                items: [
                    {
                        xtype: "datefield",
                        name: "ZB_DATE",
                        fieldLabel: '<span class="required">✶</span>招标日期',
                        allowBlank: false,
                        format: 'Y-m-d',
                        value: today,
                        readOnly: btn.editable ? false : true,
                        editable: btn.editable,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6'
                    },
                    {
                        xtype: 'combobox',//20210513_dengzq_招投标情况表增加招标类型
                        name: 'ZB_TYPE',
                        store: DebtEleStore(json_debt_zblx),
                        displayField: 'name',
                        valueField: 'id',
                        fieldLabel: '<span class="required">✶</span>招标类型',
                        readOnly: btn.editable ? false : true,
                        allowBlank: false,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        editable: false //禁用编辑
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '<span class="required">✶</span>预算金额(万元)',
                        name: "YS_AMT",
                        value: 0,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        minValue:0,
                        maxValue:9999999999.999999,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        columnWidth: .33,
                        allowBlank: false,
                        editable: btn.editable,
                        regex:/^(([1-9]{1}\d*)|([]{1}))(\.(\d){0,2})?$/,
                        regexText:'预算金额(万元)格式有误，请重填',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '<span class="required">✶</span>中标金额(万元)',
                        name: "ZB_AMT",
                        value: 0,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        minValue:0,
                        maxValue:9999999999.999999,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        columnWidth: .33,
                        allowBlank: false,
                        editable: btn.editable,
                        regex:/^(([1-9]{1}\d*)|([]{1}))(\.(\d){0,2})?$/,
                        regexText:'中标金额(万元)格式有误，请重填',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6'
                    },
                    {
                        xtype: "datefield",
                        name: "HTQD_DATE",
                        fieldLabel: '<span class="required">✶</span>合同签订日期',
                        allowBlank: false,
                        format: 'Y-m-d',
                        value: today,
                        readOnly: btn.editable ? false : true,
                        editable: btn.editable,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '合同金额(万元)',
                        name: "HT_AMT",
                        value: 0,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        minValue:0,
                        maxValue:9999999999.999999,
                        columnWidth: .33,
                        allowBlank: true,
                        editable: btn.editable,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                if (newValue == null || newValue == '') {
                                    self.setValue(0);
                                    return;
                                }
                            }
                    }
                    },
                     {
                        xtype: "numberFieldFormat",
                        fieldLabel: '合同期限(月)',
                        name: "HTQX",
                        columnWidth: .33,
                        allowBlank: true,
                        minValue:0,
                        maxValue:1000,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        editable: btn.editable,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        regex:/^1000$|^([1-9]|[1-9]\d|[1-9]\d\d)$/,
                        regexText:'合同期限(月)格式有误，请重填'
                    },
                     {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>中标单位名称',
                        name: "ZBDW",
                        columnWidth: .33,
                        allowBlank: false,
                        editable: btn.editable,
                        maxLength:100,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入100个汉字！",
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>中标单位统一社会信用代码',
                        name: "TYSHXY_CODE",
                        columnWidth: .33,
                        regex: /(^[A-Z0-9]{18}$)/,
                        regexText:'请输入正确的统一社会信用代码',
                        labelWidth: 180,
                        allowBlank: false,
                        editable: btn.editable,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6'
                    },
                     {
                        xtype: "textarea",
                        fieldLabel: '备注',
                        name: "REMARK",
                        columnWidth: .99,
                        allowBlank: true,
                        editable: btn.editable,
                        multiline: true,
                        maxLength:1000,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入1000个汉字！",
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6'
                    }
                ]
            }
        ]
    });
}

/**
 * 提交数据
 * @param form
 */
function submitXmjdfb(btn) {
    //获取实际收益情况表单
    var ztbForm = Ext.ComponentQuery.query('form[itemId="xmzx_form"]')[0];
    let zbFormValue = ztbForm.getValues();
    //20201124 zhanghl 增加校验
    var zb_date = ztbForm.getForm().findField('ZB_DATE').value;
    var htqd_date = ztbForm.getForm().findField('HTQD_DATE').value;
    // 统一社会信用代码
    var usc_code = ztbForm.getForm().findField('TYSHXY_CODE').value;
    var errorMsg = '';
    if(htqd_date != null && htqd_date != '' && typeof htqd_date != 'undefined'){
        if(zb_date > htqd_date){
            errorMsg = '招标日期不能大于合同签订日期';
            Ext.Msg.alert('提示',errorMsg);
            return false;
        }
    }
    $.post("checkAgUsccode.action", {
        USC_CODE:usc_code
    }, function (data) {
        if(data.message == true){
            Ext.Msg.show({
                title:'提示',
                msg:'请核对统一社会信用码是否正确!',
                buttons:Ext.Msg.OK,
                fn:function (btnId) {
                    if (btnId == "ok") {
                        saveztb(ztbForm,btn,zbFormValue);
                    }
                },
                closable:false
            });
        }else{
            Ext.Msg.show({
                title:'提示',
                msg:'请通过单位维护功能在系统中维护单位信息!',
                buttons:Ext.Msg.OK,
                fn:function (btnId) {
                    if (btnId == "ok") {
                        saveztb(ztbForm,btn,zbFormValue);
                    }
                },
                closable:false
            });
        }
    },'json');
}

function saveztb(ztbForm,btn,zbFormValue){
    if (!ztbForm.isValid()) {
        Ext.toast({
            html: "请检查必填项，以及未通过校验项！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    }
    btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    $.post('/saveXmzxInfo.action', {
        wf_id: wf_id,
        node_code: node_code,
        xmzx_type:xmzx_type,
        button_name: button_name,
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_NAME: AG_NAME,
        AG_CODE: AG_CODE,
        ztbForm: Ext.util.JSON.encode([zbFormValue])
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: '保存成功！',
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.up('window').close();
            // 刷新表格
            reloadGrid()
        } else {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            btn.setDisabled(false);
        }
        //刷新表格
    }, "json");
}