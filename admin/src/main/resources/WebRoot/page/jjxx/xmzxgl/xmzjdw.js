var  PLAN_ID='';//计划ID
var ZJ_TYPE='';
//资金类型枚举
var json_debt_zjlx = [
    {id: "1", code: "1", name: "财政预算资金"},
    {id: "2", code: "2", name: "单位自筹资金"},
    {id: "3", code: "3", name: "其他资金"}

];
var km_year = nowDate.substr(0, 4);
var km_condition = km_year <= 2017 ? " <= '2017' " : " = '" + km_year + "' ";
var store_GNFL = DebtEleTreeStoreDB('EXPFUNC', {condition: "and year " + km_condition});
var store_JJFL = DebtEleTreeStoreDB('EXPECO', {condition: "and year " + km_condition});

var formName = 'form[name="zjdwqk_form"]';
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
        {dataIndex: "ZJ_TYPE", width: 150, type: "string", text: "资金类型",
        		renderer: function (value) {
                    //资金类型枚举-兼容历史数据：上级补助资金
                    var json_debt_zjlx2 = [
                        {id: "0", code: "0", name: "上级补助资金"},
                        {id: "1", code: "1", name: "财政预算资金"},
                        {id: "2", code: "2", name: "单位自筹资金"},
                        {id: "3", code: "3", name: "其他资金"}

                    ];
                var store = DebtEleStore(json_debt_zjlx2);
                var record = store.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
        }},
        {dataIndex: "PAY_NO", width: 150, type: "string", text: "拨款单号"},
        {dataIndex: "ZJDW_DATE", width: 150, type: "string", text: "拨款日期"},
        {dataIndex: "ZJDW_AMT", width: 160, type: "float", text: "拨款金额（万元）",summaryType: 'sum',
        	renderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00####');
        },
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00####');
        }},
        {dataIndex: "QZZBJ_AMT", width: 180, type: "float", text: "其中资本金金额（万元）",summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
        }},
        {dataIndex: "PAY_ACCT_NAME", width: 180, type: "string", text: "付款人账户"},
        {dataIndex: "PAY_ACCT_NO", width: 180, type: "string", text: "付款人账号"},
        {dataIndex: "PAY_ACCT_BANK_NAME", width: 180, type: "string", text: "付款人开户行"},
        {dataIndex: "PAYEE_ACCT_NAME", width: 180, type: "string", text: "收款人账户"},
        {dataIndex: "PAYEE_ACCT_NO", width: 180, type: "string", text: "收款人账号"},
        {dataIndex: "PAYEE_ACCT_BANK_NAME", width: 180, type: "string", text: "收款人开户行"},
        {dataIndex: "EXP_FUNC_NAME", width: 180, type: "string", text: "功能分类"},
        {dataIndex: "GOV_BGT_ECO_NAME", width: 180, type: "string", text: "经济分类"},
        {dataIndex: "JHYT", type: "string", text: "用途"},
        {dataIndex: "REMARK", type: "string", text: "备注"},
        {dataIndex: "LX_YEAR", type: "string", text: "立项年度"},
        {dataIndex: "JSXZ_NAME", type: "string", text: "建设性质"},
        {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质"},
        {dataIndex: "XMLX_NAME", width: 160,type: "string", text: "项目类型"},
        {dataIndex: "BUILD_STATUS_NAME", width: 120, type: "string", text: "建设状态"},
        {
            dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算（万元）",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        }
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
     window_title: '项目资金到位'
});


/**
 * 初始化项目资金到位主表单
 */
function initzjdwWiondow_form(config) {
    return Ext.create('Ext.form.Panel', {
        itemId: 'zjdwqk_form',
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
                    columnWidth: .100,
                    labelWidth: 100//控件默认标签宽度
                },

            },
            initWindow_contentForm_tab_xmzjdwqk(config)//资金到位情况grid
        ],
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    var win_xm_sel = Ext.ComponentQuery.query('window[itemId="xm_sel"]');//项目选择窗口
                    if (win_xm_sel != null && win_xm_sel != undefined) {  //项目选择窗口存在
                        if(url_xm_id != config){
                            var xm_grid = DSYGrid.getGrid('xm_grid');
                            var zjdwqkGrid = DSYGrid.getGrid('zjdwqkGrid');
                            var zjdwqk_record = zjdwqkGrid.getSelectionModel().getSelection();
                            var xm_record = xm_grid.getSelectionModel().getSelection();
                        }else{
                            var zjdwqkGrid = DSYGrid.getGrid('zjdwqkGrid');
                            var zjdwqk_record = zjdwqkGrid.getSelectionModel().getSelection();
                        }
                        if (zjdwqk_record.length < 1) {   //类型
                            Ext.toast({
                                html: "请选择至少一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else {
                            if (zjdwqk_record[0].data.ZJ_TYPE=='4'||zjdwqk_record[0].data.ZJ_TYPE=='5'){//20210514LIYUE 资金到位添加选择类型，并且不允许填报
                                Ext.Msg.alert('提示', "债券资金与市场化融资无需在本功能填报，请选取其他类型进行填报！");
                                return false;
                            }
                            //资金附件到位id
                            btn.busiId = GUID.createGUID(); //生成主表单ID
                            /*if(url_xm_id != config){
                            	btn.busiId = GUID.createGUID(); //生成主表单ID
                            } else {
                            	btn.busiId = zjdzXmId;
                            }*/
                            btn.editable = true;
                            JH_ND=zjdwqk_record[0].data.ND;
                            PLAN_ID=zjdwqk_record[0].data.PLAN_ID;
                            ZJ_TYPE=zjdwqk_record[0].data.ZJ_TYPE;
                            var ZJ_TYPE_NAME=zjdwqk_record[0].data.ZJ_TYPE_NAME;
                            var JH_AMT=zjdwqk_record[0].data.JH_AMT;
                            var ZJYDW_AMT=zjdwqk_record[0].data.ZJDW_AMT;
                            window_xmzxtb.show(btn);
                           var dwqkForm = Ext.ComponentQuery.query('form[itemId="xmzjdwqk_form"]')[0];
                         // var dwqkForm = Ext.ComponentQuery.query('form[itemId="xmzx_form"]')[0];
                            dwqkForm.getForm().findField('ZJ_TYPE').setValue(zjdwqk_record[0].data.ZJ_TYPE);//资金类型
                            dwqkForm.getForm().findField('ZJ_TYPE').setRawValue(ZJ_TYPE_NAME);//资金类型
                            dwqkForm.getForm().findField('ZJ_NAME').setValue(ZJ_TYPE_NAME);//资金类型
                            dwqkForm.getForm().findField('JH_AMT').setValue(JH_AMT);//计划金额
                            dwqkForm.getForm().findField('ZJYDW_AMT').setValue(ZJYDW_AMT);//已到位金额
                            if(url_xm_id != config){
                                var xmzxFormRecords = xm_record[0].getData();
                            }else{
                                url_xm_data.ID = btn.busiId;
                                var xmzxFormRecords = url_xm_data;
                            }
                            var url='/page/debt/common/xmyhs.jsp';
                            var paramNames=new Array();
                            paramNames[0]="XM_ID";
                            paramNames[1]="IS_RZXM";
                            var paramValues=new Array();
                            paramValues[0]=encodeURIComponent(xmzxFormRecords.XM_ID);
                            paramValues[1]=encodeURIComponent(xmzxFormRecords.IS_RZXM);
                            var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+xmzxFormRecords.XM_NAME+'</a>';
                            xmzxFormRecords.XM_NAME = result;
                            xmzxFormRecords.SCJD = xmzxFormRecords.BUILD_STATUS_ID;
                            //var xmjdfbForm = Ext.ComponentQuery.query('form#xmzx_form')[0];
                            var xmjdfbForm = Ext.ComponentQuery.query('form#xmzjdwqk_form')[0];
                            xmjdfbForm.getForm().setValues(xmzxFormRecords);
                            /*dwqkForm.getForm().findField('ZJDW_DATE').setValue(today)*/
                            dwqkForm.getForm().findField('ZJDW_AMT').setValue(0);
                            btn.up('window').close();
                        }
                    }
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}
/**
 * 初始化资金到位情况
 */
function initWindow_contentForm_tab_xmzjdwqk(config) {
    var config = { //grid 属性设置
        itemId:'zjdwqkGrid',
        flex: 1,
        border: false,
        dataUrl: 'getzjdwqkSotre.action',
        params: {
            XM_ID:config
        },
        headerConfig: {
            headerJson: [
                {dataIndex: "ZJ_TYPE_NAME", type: "string", text: "资金类别", width: 350},
                {dataIndex: "ND", type: "string", text: "计划年度", width: 320},
                {dataIndex: "JH_AMT", type: "string", text: "投资计划（万元）", width: 390,
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {dataIndex: "ZJDW_AMT", type: "string", text: "已到位资金（万元）", width: 390,
                    renderer: function (value) {
                        return Ext.util.Format.number(value , '0,000.00');
                    }
                },
            ]
        },
        pageConfig: {
            enablePage: false,   //设置是否分页
            pageNum: false       //设置显示每页条数
        },
        checkBox: true,
        selModel: {
            mode: "SINGLE"
        },
        autoLoad: true,
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    grid.getStore().on('load', function () {
    });
    return grid;
}
/**
 * 初始化项目资金到位情况表单
 */
function initWiondow_form(btn) {
    var config = {
        editable: btn.editable,
        busiId: btn.busiId
    };
    return Ext.create('Ext.form.Panel', {
        itemId: 'xmzjdwqk_form',                  //'xmzx_form',
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
                    labelWidth: 130
                },
                items: [
                    {
                        xtype: "numberFieldFormat",
                        name: "JH_AMT",
                        fieldLabel: '投资计划(万元)',
                        allowBlank: true,
                        readOnly: true,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6',
                        hidden: true

                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "ZJYDW_AMT",
                        fieldLabel: '已到位资金(万元)',
                        allowBlank: true,
                        readOnly: true,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6',
                        hidden: true

                    },
                    {
                        fieldLabel: '<span class="required">✶</span>资金类型',
                        id:'ZJ_TYPE',
                        name: 'ZJ_TYPE',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        store: DebtEleStore(json_debt_zjlx),
                        allowBlank: false,
                        readOnly: false,
                        editable: false,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '拨款单号',
                        name: "PAY_NO",
                        columnWidth: .33,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        maxLength:1000,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入1000个汉字！"
                    },
                    {
                        xtype: "textfield",
                        name: "ZJ_NAME",
                        fieldLabel: '资金到位类型名称',
                        allowBlank: true,
                        readOnly: true,
                        hidden:true
                    },
                    {
                        xtype: "datefield",
                        name: "ZJDW_DATE",
                        fieldLabel: '<span class="required">✶</span>拨款日期',
                        allowBlank: false,
                        value:today,
                        displayField: 'name',
                        format: 'Y-m-d',
                        readOnly: btn.editable ? false : true,
                        editable: btn.editable,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        listeners: {
                            change: function (self, newValue, oldValue) {
                                var newYear = dsyDateFormat(newValue).substr(0, 4);
                                var oldYear = dsyDateFormat(oldValue).substr(0, 4);
                                if (newYear != oldYear && newYear != km_year) {
                                    Ext.MessageBox.wait('正在获取新年度功能分类、经济分类数据..', '请等待..');
                                    km_year = newYear;
                                    var condition_str = km_year <= 2017 ? " <= '2017' " : " = '" + km_year + "' ";
                                    store_GNFL.proxy.extraParams['condition'] = encode64(" AND YEAR " + condition_str);
                                    store_JJFL.proxy.extraParams['condition'] = encode64(" AND YEAR " + condition_str);
                                    store_GNFL.load({
                                        callback: function () {
                                            store_JJFL.load({
                                                callback: function () {
                                                    Ext.MessageBox.hide();
                                                }
                                            });
                                        }
                                    });
                                }
                            }
                        }

                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "ZJDW_AMT",
                        fieldLabel: '<span class="required">✶</span>拨款金额(万元)',
                        value: 0,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        columnWidth: .33,
                        hideTrigger: true,
                        minValue: 0.1,
                        maxValue: 9999999999.999999,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        allowBlank: false,
                        editable: btn.editable,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                if(newValue==null||newValue=='') {
                                    self.setValue(0);
                                    return;
                                }
                                var QZZBJ_AMT = Ext.ComponentQuery.query('numberFieldFormat[name="QZZBJ_AMT"]')[0].getValue();
                                if (self.getValue() < QZZBJ_AMT) {
                                    Ext.MessageBox.alert("提示","其中资本金金额(万元)大于拨款金额(万元)！");
                                    Ext.ComponentQuery.query('button#btnSave')[0].setDisabled(true);
                                    return false;
                                }else {
                                    Ext.ComponentQuery.query('button#btnSave')[0].setDisabled(false);
                                }
                                if (!self.getValue()) {
                                    return;
                                }
                                if(newValue==null || newValue=='') {
                                    self.setValue(0);
                                }
                            }
                        }
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "QZZBJ_AMT",
                        fieldLabel: '其中资本金金额(万元)',
                        value: 0,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        columnWidth: .33,
                        hideTrigger: true,
                        minValue: 0.0,
                        maxValue: 9999999999.999999,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        allowBlank: true,
                        editable: btn.editable,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var ZJDW_AMT = Ext.ComponentQuery.query('numberFieldFormat[name="ZJDW_AMT"]')[0].getValue();
                                if (self.getValue() > ZJDW_AMT) {
                                    Ext.MessageBox.alert("提示","其中资本金金额(万元)大于拨款金额(万元)！");
                                    Ext.ComponentQuery.query('button#btnSave')[0].setDisabled(true);
                                    return false;
                                }else {
                                    Ext.ComponentQuery.query('button#btnSave')[0].setDisabled(false);
                                }
                                if(newValue==null || newValue=='') {
                                    self.setValue(0);
                                }
                            }
                        }
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
                    labelWidth: 130
                },
                items: [

                    {
                        xtype: "textfield",
                        fieldLabel: '付款人账户',
                        name: "PAY_ACCT_NAME",
                        multiline: true,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        maxLength:100,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入100个汉字！"
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '付款人账号',
                        name: "PAY_ACCT_NO",
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        maxLength:100,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入100个汉字！"
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '付款人开户行',
                        name: "PAY_ACCT_BANK_NAME",
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        maxLength:100,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入100个汉字！"
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '收款人账户',
                        name: "PAYEE_ACCT_NAME",
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        maxLength:100,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入100个汉字！"
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '收款人账号',
                        name: "PAYEE_ACCT_NO",
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        maxLength:100,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入100个汉字！"
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '收款人开户行',
                        name: "PAYEE_ACCT_BANK_NAME",
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        maxLength:100,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入100个汉字！"
                    },
                    {
                        xtype: "treecombobox",
                        name: "GOV_BGT_ECO_CODE",
                        store: store_JJFL,
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        displayField: "name",
                        valueField: "id",
                        selectModel: "leaf",
                        fieldLabel: '<span class="required">✶</span>经济分类',
                        editable: true, //禁用编辑
                        allowBlank: false
                    },
                    {
                        xtype: "treecombobox",
                        name: "EXP_FUNC_CODE",
                        store: store_GNFL,
                        displayField: "name",
                        valueField: "id",
                        fieldStyle: btn.editable ? 'background:#FFFFFF':'background:#E6E6E6',
                        selectModel: "leaf",
                        fieldLabel: '<span class="required">✶</span>功能分类',
                        editable: true, //禁用编辑
                        allowBlank: false
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '用途',
                        name: "JHYT",
                        columnWidth: .99,
                        allowBlank: true,
                        editable: btn.editable,
                        maxLength: 1000,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入1000个汉字！",
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
                hidden: xmzx_type == 'zjzt' ? false : true,
                name: 'xmzjdwdFJ',
                xtype: 'fieldset',
                layout:'fit',
                items: [
                    {
                        xtype: 'panel',
                layout: 'fit',
                itemId: 'xmzjdw_fjgrid',
                border: false,
                items: init_xmzjdw_fjGrid(config)
            }
        ]
            }
        ]
    });
}
/*资金到位附件*/
function init_xmzjdw_fjGrid(btn){
    var grid = UploadPanel.createGrid({
        busiType: 'ETZJDW',//业务类型
        busiId:  btn.busiId,//业务ID
       /* busiProperty: 'C02',//业务规则*/
        editable:editValue,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_xmzjdw_contentForm_xmfj_grid'
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
        } else {
            //20210630 fzd 资金到位填报附件个数显示问题修改
            $('span.file_sum_fj').html('(' + sum + ')');
        }
    });
    return grid;
}
/**
 * 提交数据
 * @param form
 */
function submitXmjdfb(btn) {
    //获取项目进度发布情况表单
    var zjdwForm = Ext.ComponentQuery.query('form[itemId="xmzjdwqk_form"]')[0];//liyue20210511去掉资金到位类型弹窗展示
    var ZJDW_DATE = Ext.ComponentQuery.query('datefield[name="ZJDW_DATE"]')[0].getValue();
    ZJDW_DATE=Ext.util.Format.date(ZJDW_DATE, 'Y-m-d').substring(0,4);//20210818liyue将日期校验调整到保存时
    if (ZJDW_DATE<JH_ND){
        Ext.MessageBox.alert('提示', '资金到位时间不能小于计划投资时间！');
        Ext.ComponentQuery.query('datefield[name="ZJDW_DATE"]')[0].setValue(null);
    }
    if (!zjdwForm.isValid()) {
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
        PLAN_ID:PLAN_ID,
        ZJ_TYPE:ZJ_TYPE,
        zjdwForm: Ext.util.JSON.encode([zjdwForm.getValues()])
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
            if(button_name!='UPDATE'){
            	var xm_window =Ext.ComponentQuery.query('window[name="xm_window"]')[0];
            	if(!isNull(xm_window)){
            		xm_window.close();
            	}
            }

            // 刷新表格
            reloadGrid()
        } else {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            btn.setDisabled(false);
        }
        //刷新表格
    }, "json");
}

