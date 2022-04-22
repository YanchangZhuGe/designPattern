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
        {dataIndex: "AG_ID", width: 150, type: "string", text: "单位ID", hidden: true},
        {dataIndex: "ZQ_CODE", width: 150, type: "string", text: "债券编码"},
        {dataIndex: "ZQ_NAME", width: 250, type: "string", text: "债券名称"},
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
        {dataIndex: "PLAN_NAME", width: 150, type: "string", text: "还款类型"},
        {dataIndex: "SET_YEAR", width: 150, type: "string", text: "收益日期"},
        {dataIndex: "DQ_DATE", width: 150, type: "string", text: "应偿还日期"},
        {dataIndex: "JK_DATE", width: 150, type: "string", text: "缴款日期"},
        {dataIndex: "JK_AMT", width: 150, type: "float", text: "缴库金额(元)",summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }},
        {dataIndex: "JK_BJ_AMT", width: 150, type: "float", text: "缴库本金金额(元)",summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }},
        {dataIndex: "JK_LX_AMT", width: 150, type: "float", text: "缴库利息金额(元)",summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }},
        {dataIndex: "JK_FY_AMT", width: 180, type: "float", text: "缴库手续费金额(元)",summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }},
        {dataIndex: "NON_TAX_PAY_NO", width: 200, type: "string", text: "一般缴款书票号"},
        {dataIndex: "NON_TAX_CODE", width: 200, type: "string", text: "执收项目代码"},
        {dataIndex: "JK_NO", width: 150, type: "string", text: "缴款识别码"},
        {dataIndex: "LX_YEAR", type: "string", text: "立项年度"},
        {dataIndex: "JSXZ_NAME", type: "string", text: "建设性质"},
        {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质"},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型"},
        {dataIndex: "BUILD_STATUS_NAME", width: 120, type: "string", text: "建设状态"},
        {
            dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算（元）",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {dataIndex: "REMARK", width: 220, type: "string", text: "备注"}
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
     window_title: '专项债券收入缴库'
});


/**
 * 初始化项目实际收益主表单
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
                    //columnWidth: .50,
                    //labelWidth: 100//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '资金到位ID',
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
/*                    {
                        xtype: "textfield",
                        fieldLabel: '项目ID',
                        name: "XM_NAME",
                        editable: false
                     //   hidden: true
                    },*/
                    {xtype: 'label', text: '单位:元',style:{'float':'right'}, cls: "label-color"}
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
                    labelWidth: 100
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '单位ID',
                        name: "AG_ID",
                        columnWidth: .33,
                        editable: false,
                        hidden: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目单位',
                        name: "AG_NAME",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目编码',
                        name: "XM_CODE",
                        editable:false,
                        columnWidth: .33,
                       // editable: false,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "displayfield",
                        fieldLabel: '项目名称',
                        name: "XM_NAME",
                        columnWidth: .33,
                        editable: false,
                        //fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目性质',
                        name: "XMXZ_NAME",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目类型',
                        name: "XMLX_NAME",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目建设状态',
                        name: "BUILD_STATUS_NAME",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债券编码',
                        name: "ZQ_CODE",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债券名称',
                        name: "ZQ_NAME",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债券类型',
                        name: "ZQLB_NAME",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6'
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
                    labelWidth: 100
                },
                items: [
                    {
                        xtype: "combobox",
                        name: "SET_YEAR",
                        fieldLabel: '<span class="required">✶</span>收益年度',
                        allowBlank: false,
                        format: 'Y',
                        editable: false, //禁用编辑
                        value: new Date().getFullYear(),
                        displayField: "code",
                        valueField: "id",
                        value: new Date().getFullYear(),
                        //store: DebtEleStore(json_debt_year,{condition: " and code >= '2015' AND CODE <= '2019' "}),
                        store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015' AND CODE <= '"+new Date().getFullYear()+"' "}),
                        readOnly: btn.editable ? false : true,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        	listeners: {
    		                    change: function (self, newValue) {
    		                    	loadHbzc(newValue);
    		                    }
    		                }
                    },
                    {
                        xtype : 'datefield',
                        name : 'JK_DATE',
                        fieldLabel :'<span class="required">✶</span>缴库日期',
                        format: 'Y-m-d',
                        editable : true,
                        allowBlank: false,
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '兑付类型',
                        name: "PLAN_TYPE",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6',
                        hidden:true,
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '兑付计划ID',
                        name: "DWDF_PLAN_ID",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6',
                        hidden:true,
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '兑付费',
                        name: "DFF_AMT",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6',
                        hidden:true,
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '剩余应还金额',
                        name: "SY_AMT",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6',
                        hidden:true,
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '剩余兑付费金额',
                        name: "SY_DFF_AMT",
                        columnWidth: .33,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6',
                        hidden:true,
                    },
                     {
                        xtype: "numberFieldFormat",
                        fieldLabel: '<span class="required">✶</span>缴库金额',
                        value: 0,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        minValue:0,
                        maxValue:9999999999.99,
                        name: "JK_AMT",
                        columnWidth: .33,
                        allowBlank: false,
                        editable: btn.editable,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '<span class="required">✶</span>其中本金金额',
                        value: 0,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        minValue:0,
                        maxValue:9999999999.99,
                        name: "JK_BJ_AMT",
                        columnWidth: .33,
                        allowBlank: false,
                        editable: btn.editable,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {
                            change: function (self, newValue) {
                                var plan_type=self.up('form').getForm().findField('PLAN_TYPE').getValue();
                                var jk_lx_amt=self.up('form').getForm().findField('JK_LX_AMT').getValue();
                                //20210620李月修改专项收入缴库从选取项目，改为选取对应项目的还本付息计划
                                // 当选择本金为缴库金额时，应限制所缴库利息不能大于0，本金不能小于0
                                //20210805 chenfei 除缴库金额外，其他金额不校验是否大于零
                                /*if(plan_type=='0' && newValue<=0){
                                    Ext.MessageBox.alert('提示', '其中本金金额不能小于等于0！');
                                }*/
                                if(plan_type=='1' && newValue>0){
                                    self.up('form').getForm().findField('JK_BJ_AMT').setValue(0);
                                    Ext.MessageBox.alert('提示', '兑付类型为利息时，其中本金金额应等于0！');
                                    newValue='0';
                                }
                            }
                        },
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '<span class="required">✶</span>其中付息金额',
                        value: 0,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        minValue:0,
                        maxValue:9999999999.99,
                        name: "JK_LX_AMT",
                        columnWidth: .33,
                        allowBlank: false,
                        editable: btn.editable,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {
                            change: function (self, newValue) {
                                var plan_type=self.up('form').getForm().findField('PLAN_TYPE').getValue();
                                var jk_bj_amt=self.up('form').getForm().findField('JK_BJ_AMT').getValue();
                                //当选择利息为缴库金额时，应限制所缴库利息不能小于0，本金不能大于0
                                /*if(plan_type=='1' && newValue<=0){
                                    Ext.MessageBox.alert('提示', '其中付息金额不能小于等于0！');
                                }*/
                                if(plan_type=='0' && newValue>0){
                                    self.up('form').getForm().findField('JK_LX_AMT').setValue(0);
                                    Ext.MessageBox.alert('提示', '兑付类型为本金时，其中付息金额应等于0！');


                                }
                            }
                        },
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '<span class="required">✶</span>其中手续费金额',
                        value: 0,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true,
                        minValue:0,
                        maxValue:9999999999.99,
                        name: "JK_FY_AMT",
                        labelWidth: 120,
                        columnWidth: .33,
                        allowBlank: false,
                        editable: btn.editable,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {
                            change: function (self, newValue) {
                                var dff_amt=self.up('form').getForm().findField('DFF_AMT').getValue();
                                //防止缴库的手续费
                                if(dff_amt>newValue){
                                    Ext.MessageBox.alert('提示', '其中手续费金额大于应缴库金额！');
                                }
                            }
                        },
                    }
                ]
            },
            {//分割线
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
                    labelWidth: 100
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>一般缴款书票号',
                        name: "NON_TAX_PAY_NO",
                        columnWidth: .33,
                        labelWidth: 110,
                        allowBlank: false
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>缴款识别码',
                        name: "JK_NO",
                        columnWidth: .33,
                        allowBlank: false
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>执收项目代码',
                        name: "NON_TAX_CODE",
                        columnWidth: .33,
                        //labelWidth: 180,
                        allowBlank: false
                    },
                    {//分割线
                        xtype: 'menuseparator',
                        margin: '5 0 5 0',
                        border: true
                    },
                    {
                        xtype: 'textfield',
                        name: 'REMARK',
                        fieldLabel: '备注',
                        allowBlank: true,
                        columnWidth: .999,
                        maxLength: 500,//限制输入字数
                        maxLengthText: "输入内容过长，最多只能输入500个汉字！"
                    }
                ]
            },
            {//确认线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                title: '附件<span class="file_sum_fj" style="color: #FF0000;">(0)</span>',
                scrollable: false,
                flex: 1,
                hidden: xmzx_type == 'sjsy' ? false : true,
                name: 'xmsjsyFJ',
                xtype: 'fieldset',
                layout:'fit',
                items: [
                    {
                        xtype: 'panel',
                        layout: 'fit',
                        itemId: 'winPanel_tabPanel',
                        border: false,
                        items: initWindow_sjsy_tab_upload(config)
                    }
                ]
            }
        ]
    });
}

/**
 * 初始化实际收益页签panel的附件页签
 */
function initWindow_sjsy_tab_upload(config) {
    var busiId = config.busiId;
    var grid = UploadPanel.createGrid({
    	busiType: 'FSSRYBJKS',//业务类型
        busiId: busiId,//业务ID
        editable: config.editable,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_sjsyfj'
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
            $(grid.up('tabpanel').activeTab.el.dom).find('span.file_sum_fj').html('(' + sum + ')');
        } else if ($('span.file_sum_fj')) {
            $('span.file_sum_fj').html('(' + sum + ')');
        }
    });
    return grid;

}

/**
 * 新增带入还本支出数据
 * @param xy
 */
function loadHbzc(set_year){
	var XM_ID = Ext.ComponentQuery.query('textfield[name="XM_ID"]')[0].getValue();
	$.post("getSjsyHbzc.action",
    		{AD_CODE: AD_CODE,
    		 SET_YEAR: set_year,
    		 //BILL_TYPE: '01'
    		 XM_ID:XM_ID,
    		},
    		function (data) {
            //弹出弹出框，设置主表id
    		if(data.list == null || data.list == '' || data.list == 'undefined'){
    			HBZC_AMT = 0;
    		}else{
    			HBZC_AMT = data.list[0].HBZC_AMT;
    		}
    }, "json");

}
/**
 * 提交数据
 * @param form
 */
function submitXmjdfb(btn) {
    //获取实际收益情况表单
    var sjsyForm = Ext.ComponentQuery.query('form[itemId="xmzx_form"]')[0];
    var set_year = Ext.ComponentQuery.query('textfield[name="SET_YEAR"]')[0].getValue();
    var XM_ID = Ext.ComponentQuery.query('textfield[name="XM_ID"]')[0].getValue();
    if (!sjsyForm.isValid()) {
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
        set_year:set_year,
        XM_ID:XM_ID,
        sjsyForm: Ext.util.JSON.encode([sjsyForm.getValues()]),
        dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
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