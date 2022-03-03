var cxt_id = '';
var do_flag_s= 'zzd';
var xfx_qxdate = '';
var cxtData = {}; // 承销团信息中债登托管账号为key
var zzdData = {}; // 承销团信息中证登托管账号为key
var zqqxStore = DebtEleStoreDB('DEBT_ZQQX', {condition: " and code <= 10 "});
var msg = '';
var SUM_SQ_AMT;//到期页签中申请总金额
var IS_ZXZQXT_FX = '${fns:getSysParam("IS_ZXZQXT_FX")}';// 1或者2 有专项流程
var nowDate = Ext.Date.format(new Date(), 'Y-m-d');// 获取系统当前时间
var nowYear=nowDate.substr(0,4);// 截取系统当前年度
var json_debt_zqqxfw = [ // 债券期限范围
    {"id": "10", "code": "10", "name": "1-10年"},
    {"id": "20", "code": "20", "name": "11-20年"},
    {"id": "30", "code": "30", "name": "21-30年"}
];
var json_debt_ssnd = [ // 所属年度
    {id: nowYear, code: nowYear + "年", name: "年"}
];
var json_debt_zqlx = [ // 20210108 guoyf 增加债权类型基础数据
    {id: "01", code: "新增债券", name: "新增债券"},
    {id: "02", code: "置换债券", name: "置换债券"},
    {id: "03", code: "再融资债券", name: "再融资债券"}
];
var fxfs = false;
var data = Ext.clone(json_debt_ssnd[0]);
data.id = parseInt(data.id) + 1;
data.code = parseInt(data.code.substr(0,4)) + 1 + "年";
json_debt_ssnd.push(data);
var ydjh_id;

/*所属年度基础数据，下拉框形式*/
function DebtEleStore(debtEle, params) {
    var namecode = '0';
    if (typeof params != 'undefined' && params != null) {
        namecode = params.namecode;
    }
    var debtStore = Ext.create('Ext.data.Store', {
        fields: ['id', 'code', 'name'],
        sorters: [{
            property: 'id',
            direction: 'asc'
        }],
        data: namecode == '1' ? DebtJSONNameWithCode(debtEle) : debtEle
    });
    return debtStore;
}

/**
 *
 * @param form       调用方法组件所在form
 * @param onlyShow   双击查看参数
 * @param isEdit     修改状态
 * @param setStyle	 是否更新金额录入框的样式
 * @param setAmt0	 是否更新金额为0
 */
function reserAmt (form,onlyShow,isEdit,setStyle,setAmt0) {
    var zqlx = form.findField('ZQLB_ID').getValue();
    var fxfs = form.findField('FXFS_ID').getValue();
    // if (zqlx == '020299' && !onlyShow) {
    //     form.findField('ZPHXHLX_ID').setReadOnly(false);
    //     form.findField('ZPHXHLX_ID').setFieldStyle('background:#FFFFFF');
    // }
    if(IS_BZB == '0'){
        if(button_name != 'VIEW'){
            if (zqlx == '020299') {
                form.findField('ZPHXHLX_ID').setReadOnly(false);
                form.findField('ZPHXHLX_ID').setFieldStyle('background:#FFFFFF');
            }else{
                form.findField('ZPHXHLX_ID').setReadOnly(true);
                form.findField('ZPHXHLX_ID').setFieldStyle('background:#E6E6E6');
                form.findField('ZPHXHLX_ID').setValue('');
            }
        }
    }else{
        if (zqlx == '020299' && !onlyShow && button_name != 'VIEW') {
            form.findField('ZPHXHLX_ID').setReadOnly(false);
            form.findField('ZPHXHLX_ID').setFieldStyle('background:#FFFFFF');
        }
    }
    if(zqlx == '01'&& !onlyShow && button_name != 'VIEW'){
        form.findField('ZX_FX_AMT').setReadOnly(true);
        form.findField('ZX_FX_AMT').setFieldStyle('background:#E6E6E6');
        form.findField('XZCZAP_AMT').setReadOnly(false);
        form.findField('XZCZAP_AMT').setFieldStyle('background:#FFFFFF');
        if(userAD=="23"){//只有黑龙江需要对债务收入科目进行默认赋值
        	form.findField('SRKM_ID').setValue("25DDB35DB5874C1CA8D3F062AA63A901");
        }
    }
    if(zqlx != '01' && !onlyShow && button_name != 'VIEW'){
        form.findField('XZCZAP_AMT').setReadOnly(true);
        form.findField('XZCZAP_AMT').setFieldStyle('background:#E6E6E6');
        form.findField('ZX_FX_AMT').setReadOnly(false);
        form.findField('ZX_FX_AMT').setFieldStyle('background:#FFFFFF');
        if(userAD=="23"){
            form.findField('SRKM_ID').setValue("FEDF5DE0CB66494DA0EE7617CD73FEFC");
        }
    }
    // if(button_name != 'VIEW'){
    //     if (zqlx == '01') {
    //         form.findField('ZPHXHLX_ID').setReadOnly(false);
    //         form.findField('ZPHXHLX_ID').setFieldStyle('background:#FFFFFF');
    //     }else{
    //         form.findField('ZPHXHLX_ID').setReadOnly(true);
    //         form.findField('ZPHXHLX_ID').setFieldStyle('background:#E6E6E6');
    //         form.findField('ZPHXHLX_ID').setValue('');
    //     }
    // }
    if(zqlx!=null && zqlx!='' && zqlx!='undefined'){
        zqlx=zqlx.substring(0,4);
    }
    /*if (!isEdit && !editFirstLoad) {
        if (zqlx == '0202' && fxfs == '01') {
            form.findField('ZH_AMT').setValue(0);
            form.findField('HB_AMT').setValue(0);
            form.findField('XZ_AMT').setValue(form.findField('FX_AMT').getValue())
        }else if (fxfs == '02' && zqlx != '0202') {
            form.findField('XZ_AMT').setValue(0);
            form.findField('HB_AMT').setValue(0);
            form.findField('ZH_AMT').setValue(form.findField('FX_AMT').getValue())
        }else if (setAmt0) {
            form.findField('XZ_AMT').setValue(0);
            form.findField('ZH_AMT').setValue(0);
            form.findField('HB_AMT').setValue(0);
        }
    }*/
    if(button_name != 'VIEW'){
        if (zqlx == '01') {
        /*    form.findField('ZX_FX_AMT').setReadOnly(true);
            form.findField('ZX_FX_AMT').setFieldStyle('background:#E6E6E6');
            form.findField('ZX_FX_AMT').setValue('0');*/
        }else{
            /*form.findField('ZX_FX_AMT').setReadOnly(false);
            form.findField('ZX_FX_AMT').setFieldStyle('background:#FFFFFF');*/
        }
    }
    if (setStyle) {
        if (zqlx == '0202' ||fxfs == '02' || onlyShow || node_code == '2') {
            form.findField('XZ_AMT').setReadOnly(true);
            form.findField('XZ_AMT').setFieldStyle('background:#E6E6E6');
            form.findField('ZH_AMT').setReadOnly(true);
            form.findField('ZH_AMT').setFieldStyle('background:#E6E6E6');
            form.findField('HB_AMT').setReadOnly(true);
            form.findField('HB_AMT').setFieldStyle('background:#E6E6E6');
        }else {
            form.findField('XZ_AMT').setReadOnly(false);
            form.findField('XZ_AMT').setEditable(true);
            form.findField('XZ_AMT').setFieldStyle('background:#FFFFFF');
            form.findField('ZH_AMT').setReadOnly(false);
            form.findField('ZH_AMT').setEditable(true);
            form.findField('ZH_AMT').setFieldStyle('background:#FFFFFF');
            form.findField('HB_AMT').setReadOnly(false);
            form.findField('HB_AMT').setEditable(true);
            form.findField('HB_AMT').setFieldStyle('background:#FFFFFF');
        }
    }
}

/**
 * 20210108 guoyf 根据债权类型进行赋值
 */
function setZqxxValue(form){
    var FX_AMT = form.findField('FX_AMT').value;
    // 获取债权类型
    var ZQLX_ID = form.findField('ZQLX_ID').value;
    if(ZQLX_ID == '01'){
        form.findField('XZ_AMT').setValue(FX_AMT);
        form.findField('ZH_AMT').setValue(0);
        form.findField('HB_AMT').setValue(0);
    }else if(ZQLX_ID == '02'){
        form.findField('ZH_AMT').setValue(FX_AMT);
        form.findField('XZ_AMT').setValue(0);
        form.findField('HB_AMT').setValue(0);
    }else if(ZQLX_ID == '03'){
        form.findField('HB_AMT').setValue(FX_AMT);
        form.findField('XZ_AMT').setValue(0);
        form.findField('ZH_AMT').setValue(0);
    }
}

/**
 * 初始化条件面板
 */
function jbxxTab(node_code, isEdit, onlyShow) {
    var fontSize = '';
    var labelWidth = 0;
    var iWidth = window.screen.width;//获取当前屏幕的分辨率
    if (iWidth == 1366) {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    } else if (iWidth == 1400 || iWidth == 1440) {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    } else if (iWidth == 1600 || iWidth == 1680) {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    } else {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    }
    /**
     * 定义表单元素及信息
     */

    var content = [{
        xtype: 'container',
        title: '债务信息',
        layout: 'anchor',
        width: "100%",
        margin: '0 2 0 2',
        autoScroll : true,
        defaults: {
            border: false,
            anchor: '100%',
            padding: '0 10 0 0'
        },
        items: [
            {   // 第一部分：第一行
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .33,
                    //padding: '7 0 2 0',
                   // labelAlign: 'right',
                    labelAlign: 'left',
                    labelWidth: labelWidth,
                    margin: '7 1 3 20',
                    //labelStyle : fontSize,
                    allowBlank: true,
                    editable: true
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '月度计划ID',
                        name: "YDJH_ID",
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '债券编码code',
                        name: "ZQ_BMCODE",
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>所属区划',
                        name: "AD_CODE",
                        hidden: true
                    }, {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>债券代码',
                        name: "ZQ_CODE",
                        allowBlank: false,
                        maxLength: 49,
                        listeners: {
                            change: function (self, newValue) {
                                // 如果是兑付系统根据债券代码带出相关信息
                                if(IS_BZB == '0' && button_name == 'INPUT'){
                                    var form = Ext.ComponentQuery.query('form[itemId="jbxxForm"]')[0];
                                    form.load({
                                        url: '/loadDfxtZqxx.action',
                                        params: {
                                            ZQ_CODE: newValue
                                        },
                                        waitTitle: '请等待',
                                        waitMsg: '正在加载中...',
                                        success: function (form_success, action) {
                                            form.getForm().setValues(action.result.data.list);
                                        },
                                        failure: function (form_failure, action) {
                                            Ext.MessageBox.alert('提示', action.result.message);
                                            return;
                                        }
                                    });
                                }
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>债券名称',
                        name: "ZQ_NAME",
                        allowBlank: false,
                        maxLength: 199
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>债券简称',
                        name: "ZQ_JC",
                        allowBlank: false,
                        maxLength: 49

                    }]
            },
            {   // 第一部分：第二行
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .33, labelWidth: labelWidth,
                    //padding: '2 0 2 0',
                    margin: '7 1 3 20',
                    labelAlign: 'left',//labelStyle : fontSize,
                    allowBlank: true,
                    editable: true
                },
                items: [
                    {
                        xtype: "combobox",
                        name: 'SS_YEAR',
                        //labelAlign: 'right',
                        store: DebtEleStore(json_debt_ssnd),
                        fieldLabel: '<span class="required">✶</span>所属年度',
                        allowBlank: false,
                        displayField: 'code',
                        editable: false,
                        valueField: 'id',
                        value:nowYear,
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                zwsrkm_store.proxy.extraParams['condition'] = encode64((IS_BZB == '2' ?  "AND CODE NOT LIKE '1050401%'":" AND 1=1 ")+" AND (CODE LIKE '105%') AND YEAR = "+ newValue);
                                zwsrkm_store.loadPage(1);
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '发文名称',
                        name: "ZQ_FWMC",
                        maxLength: 50
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZQLB_ID",
                        store: DebtEleTreeStoreDB('DEBT_ZQLB',{condition:IS_BZB=='2'?" AND CODE LIKE '0202%'":" AND 1=1"}),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>债券类型',
                        selectModel: 'leaf',
                        editable: false, //禁用编辑
                        allowBlank: false,
                        fieldStyle: IS_BZB == '1' || IS_BZB == '2'? 'background:#E6E6E6' : 'background:#FFFFFF',
                        readOnly:IS_BZB == '1' || IS_BZB == '2'? true : false,
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                //一般债券
                                /*var fxfs = this.up('form').getForm().findField('FXFS_ID').getValue();
                                if (newValue == '01') {selectModel: 'leaf',
                                    this.up('form').getForm().findField('ZJLY_ID').setValue('0101');//0101 一般公共预算收入
                                    this.up('form').getForm().findField('ZJLY_ID').setReadOnly(true);
                                } else{
                                    this.up('form').getForm().findField('ZJLY_ID').setReadOnly(false);
                                }*/
                                reserAmt(this.up('form').getForm(), onlyShow,isEdit,true,true);//重置录入的资金及样式
                                /*if (newValue == '020201' || newValue == '020202' || newValue == '020299'||fxfs == '02') {//如果债券类型为以下几种，新增、置换金额不可编辑
                                    //this.up('form').getForm().findField('FX_AMT').setValue('0');
                                    this.up('form').getForm().findField('XZ_AMT').setReadOnly(true);
                                    this.up('form').getForm().findField('XZ_AMT').setEditable(false);
                                    this.up('form').getForm().findField('XZ_AMT').setFieldStyle('background:#E6E6E6');
                                    this.up('form').getForm().findField('ZH_AMT').setReadOnly(true);
                                    this.up('form').getForm().findField('ZH_AMT').setEditable(false);
                                    this.up('form').getForm().findField('ZH_AMT').setFieldStyle('background:#E6E6E6');
                                    this.up('form').getForm().findField('HB_AMT').setReadOnly(true);
                                    this.up('form').getForm().findField('HB_AMT').setEditable(false);
                                    this.up('form').getForm().findField('HB_AMT').setFieldStyle('background:#E6E6E6');
                                } else {
                                    this.up('form').getForm().findField('XZ_AMT').setReadOnly(false);
                                    this.up('form').getForm().findField('XZ_AMT').setEditable(true);
                                    this.up('form').getForm().findField('XZ_AMT').setFieldStyle('background:#FFFFFF');
                                    this.up('form').getForm().findField('ZH_AMT').setReadOnly(false);
                                    this.up('form').getForm().findField('ZH_AMT').setEditable(true);
                                    this.up('form').getForm().findField('ZH_AMT').setFieldStyle('background:#FFFFFF');
                                    this.up('form').getForm().findField('HB_AMT').setReadOnly(false);
                                    this.up('form').getForm().findField('HB_AMT').setEditable(true);
                                    this.up('form').getForm().findField('HB_AMT').setFieldStyle('background:#FFFFFF');
                                }*/
                            }

                        }
                    },
                    // {
                    //     xtype: "treecombobox",
                    //     name: "ZQPZ_ID",
                    //     value: '111',
                    //     store: DebtEleTreeStoreJSON(json_debt_zqpz),
                    //     displayField: "name",
                    //     valueField: "id",
                    //     fieldLabel: '债券品种',
                    //     editable: false, //禁用编辑
                    //     readOnly: true,
                    //     fieldStyle: 'background:#E6E6E6',
                    //     allowBlank: false,
                    //     selectModel: 'leaf'
                    // },
                    {
                        xtype: "combobox",
                        name: "ZPHXHLX_ID",
                        store: DebtEleStoreDB('DEBT_ZPHXHLX'),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '其他自平衡细化类型',
                        editable: false, //禁用编辑
                        readOnly: IS_BZB == '1' || IS_BZB == '2'? true : false,
                        fieldStyle: IS_BZB == '1' || IS_BZB == '2'? 'background:#E6E6E6' : 'background:#FFFFFF',
                        allowBlank: true,
                        selectModel: 'leaf'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '文号',
                        name: "ZQ_WH",
                        maxLength: 39
                    },
                    {
                        xtype: "combobox",
                        name: "ZQTGR_ID",
                        store: DebtEleStoreDB('DEBT_ZQTGR'),
                        displayField: "name",
                        valueField: "id",
                        value: '01',
                        fieldLabel: '发行场所',
                        editable: false //禁用编辑
                    }]
            },
            {   // 第一部分：第三行
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .33, labelWidth: labelWidth,
                    ///padding: '2 0 2 0',
                    margin: '7 1 3 20',
                   // labelAlign: 'right',//labelStyle : fontSize,
                    labelAlign: 'left',
                    allowBlank: true,
                    editable: true
                },
                items: [
                    {
                        xtype: "treecombobox",
                        name: "ZJLY_ID",
                        store: DebtEleTreeStoreDB('DEBT_CHZJLY',{condition:" and (code like '0101%' or code like '0102%') "}),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>偿还资金来源',
                        editable: false, //禁用编辑
                        selectModel:"leaf",
                        allowBlank: true,
                        hidden:true
                    }]
            },
            {   // 第一部分：第四行
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .33,
                    margin: '7 1 3 20',
                    //padding: '2 0 2 0',
                    //labelAlign: 'right',
                    labelAlign: 'left',
                    labelWidth: labelWidth,
                    //labelStyle : fontSize,
                    allowBlank: true,
                    editable: true
                },
                items: [
                    {
                        xtype: "treecombobox",
                        name: "SRKM_ID",
                        store: zwsrkm_store,
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>债务收入科目',
                        allowBlank:false,
                        selectModel:"leaf",
                        editable: false
                    }, {
                        xtype: "combobox",
                        name: "FXFS_ID",
                        store: DebtEleStore(json_debt_fxfs),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>发行方式',
                        allowBlank: false,
                        editable: false, //禁用编辑
                        value: '01',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                               if(newValue == '' || newValue == null){
                                  self.setValue('01');
                                   fxfs = true;
                               }else{
                                   if(fxfs){
                                       reserAmt(this.up('form').getForm(),onlyShow,isEdit,true,true);
                                   }else{
                                       fxfs = true;
                                   }
                               }
                                /*var zqlb_id = this.up('form').getForm().findField('ZQLB_ID').getValue();
                                var zqlb_flag = false;//债券类型是否为一下三种标识
                                if (zqlb_id == '020201' || zqlb_id == '020202' || zqlb_id == '020299') {//如果债券类型为以下几种，新增、置换金额不可编辑
                                    zqlb_flag = true;
                                }
                                if (newValue == '02' || onlyShow || zqlb_flag || node_code == '2') {//如果为定向承销；双击查看；债券类型为以上几种，则置灰且不可编辑
                                    this.up('form').getForm().findField('XZ_AMT').setReadOnly(true);
                                    this.up('form').getForm().findField('ZH_AMT').setReadOnly(true);
                                    this.up('form').getForm().findField('HB_AMT').setReadOnly(true);
                                    this.up('form').getForm().findField('XZ_AMT').setFieldStyle('background:#E6E6E6');
                                    this.up('form').getForm().findField('ZH_AMT').setFieldStyle('background:#E6E6E6');
                                    this.up('form').getForm().findField('HB_AMT').setFieldStyle('background:#E6E6E6') ;
                                } else {
                                    this.up('form').getForm().findField('XZ_AMT').setReadOnly(false);
                                    this.up('form').getForm().findField('ZH_AMT').setReadOnly(false);
                                    this.up('form').getForm().findField('HB_AMT').setReadOnly(false);
                                    this.up('form').getForm().findField('XZ_AMT').setFieldStyle('background:#FFFFFF');
                                    this.up('form').getForm().findField('ZH_AMT').setFieldStyle('background:#FFFFFF');
                                    this.up('form').getForm().findField('HB_AMT').setFieldStyle('background:#FFFFFF');
                                }*/
                                /*if (!isEdit && !editFirstLoad) {
                                    if (newValue == '02') {
                                        this.up('form').getForm().findField('XZ_AMT').setValue('0');
                                        this.up('form').getForm().findField('HB_AMT').setValue('0');
                                        this.up('form').getForm().findField('ZH_AMT').setValue(
                                        this.up('form').getForm().findField('FX_AMT').getValue());
                                    } else{
                                        this.up('form').getForm().findField('FX_AMT').setValue(0);
                                        this.up('form').getForm().findField('XZ_AMT').setValue(0);
                                        this.up('form').getForm().findField('ZH_AMT').setValue(0);
                                        this.up('form').getForm().findField('HB_AMT').setValue(0);
                                    }
                                }*/
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "ZQ_PC_ID",
                        store: DebtEleStoreDB('DEBT_ZQPC'),
                        fieldLabel: '<span class="required">✶</span>发行批次',
                        displayField: 'name',
                        valueField: 'id',
                        editable: false, //禁用编辑
                        allowBlank: false,
                        readOnly: IS_BZB == '1' || IS_BZB == '2'? true : false,
                        fieldStyle: IS_BZB == '1' || IS_BZB == '2'? 'background:#E6E6E6' : 'background:#FFFFFF'
                    }]
            },
            {   // 分割线
                xtype: 'container',
                layout: 'hbox',
                items: [{// 分割线
                    xtype: 'menuseparator',
                    width: '100%',
                    border: true
                }]
            },
            {   // 第二部分：第一行
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .33, labelWidth: labelWidth,
                   // padding: '2 0 2 0',
                    margin: '7 1 3 20',
                    //labelAlign: 'right',//labelStyle : fontSize,
                    labelAlign: 'left',
                    allowBlank: true
                },
                items: [
                    {// 20200106 guoyf 增加债权类型下拉框
                        xtype: "combobox",
                        name: 'ZQLX_ID',
                        //labelAlign: 'right',
                        store: DebtEleStore(json_debt_zqlx),
                        fieldLabel: '<span class="required">✶</span>债权类型',
                        allowBlank: false,
                        displayField: 'code',
                        editable: false,
                        valueField: 'id',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var form = this.up('form').getForm();
                                var ZQLX_ID = form.findField('ZQLX_ID').value;// 债权类型
                                var ZQLB_ID = form.findField('ZQLB_ID').value;// 债券类型
                                var ZXFX_AMT = Ext.ComponentQuery.query('numberfield[name="ZX_FX_AMT"]')[0];
                                var XZCZAP_AMT = Ext.ComponentQuery.query('numberfield[name="XZCZAP_AMT"]')[0];
                                var CH_DQZQ_AMT = Ext.ComponentQuery.query('numberfield[name="CH_DQZQ_AMT"]')[0];
                                var CH_CLZW_AMT = Ext.ComponentQuery.query('numberfield[name="CH_CLZW_AMT"]')[0];
                                // 根据债券类别与债权类型展示不同输入项
                                if(ZQLX_ID == '01'){
                                    CH_DQZQ_AMT.setFieldLabel('偿还到期债券');
                                    CH_CLZW_AMT.setFieldLabel('偿还存量债务');
                                    CH_DQZQ_AMT.allowBlank = true;
                                    CH_CLZW_AMT.allowBlank = true;
                                    CH_DQZQ_AMT.setHidden(true);
                                    CH_CLZW_AMT.setHidden(true);
                                    CH_DQZQ_AMT.setValue(0);
                                    CH_CLZW_AMT.setValue(0);
                                    if(ZQLB_ID == '01'){
                                        ZXFX_AMT.setHidden(true);
                                        ZXFX_AMT.setValue(0);
                                        XZCZAP_AMT.setHidden(false);
                                    }else {
                                        XZCZAP_AMT.setHidden(true);
                                        XZCZAP_AMT.setValue(0);
                                        ZXFX_AMT.setHidden(false);
                                    }
                                }else if(ZQLX_ID == '03'){
                                    CH_DQZQ_AMT.setFieldLabel('<span class="required">✶</span>偿还到期债券');
                                    CH_CLZW_AMT.setFieldLabel('<span class="required">✶</span>偿还存量债务');
                                    CH_DQZQ_AMT.allowBlank = false;
                                    CH_CLZW_AMT.allowBlank = false;
                                    ZXFX_AMT.setHidden(true);
                                    ZXFX_AMT.setValue(0);
                                    XZCZAP_AMT.setHidden(true);
                                    XZCZAP_AMT.setValue(0);
                                    CH_DQZQ_AMT.setHidden(false);
                                    CH_CLZW_AMT.setHidden(false);
                                }else{
                                    CH_DQZQ_AMT.setFieldLabel('偿还到期债券');
                                    CH_CLZW_AMT.setFieldLabel('偿还存量债务');
                                    CH_DQZQ_AMT.allowBlank = true;
                                    CH_CLZW_AMT.allowBlank = true;
                                    ZXFX_AMT.setHidden(true);
                                    ZXFX_AMT.setValue(0);
                                    XZCZAP_AMT.setHidden(true);
                                    XZCZAP_AMT.setValue(0);
                                    CH_DQZQ_AMT.setHidden(true);
                                    CH_DQZQ_AMT.setValue(0);
                                    CH_CLZW_AMT.setHidden(true);
                                    CH_CLZW_AMT.setValue(0);
                                }
                                setZqxxValue(form);
                            }
                        }
                    },
                    {
                    xtype: "numberfield",
                    name: "PLAN_FX_AMT",
                    fieldLabel: '<span class="required">✶</span>计划发行额（亿）',
                    emptyText: '0.000000',
                    value: 0,
                    maxValue: 999999.99,
                    minValue: 0,
                    decimalPrecision: 8,
                    hideTrigger: true,
                    allowBlank: false,
                   // readOnly: IS_BZB == '1' ? true : false,
                   // fieldStyle: IS_BZB == '1' ? 'background:#E6E6E6' : 'background:#FFFFFF',
                    readOnly:  true,
                    fieldStyle: 'background:#E6E6E6' ,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    listeners: {
                        'change': function () {
                            if (sysParamZqfxfs != '1') {
                                var form = this.up('form').getForm();
                                if (!isEdit && node_code == 1 && !editFirstLoad) {
                                    var PLAN_FX_AMT = form.findField('PLAN_FX_AMT').getValue();
                                    var FX_AMT = form.findField('FX_AMT');
                                    FX_AMT.setValue(PLAN_FX_AMT);
                                }
                            }
                        }
                    }
                }, {
                    xtype: "numberfield",
                    name: "FX_AMT",
                    fieldLabel: '<span class="required">✶</span>实际发行额（亿）',
                    emptyText: '0.000000',
                    value: 0,
                    maxValue: 999999.99,
                    minValue: 0,
                    decimalPrecision: 8,
                    hideTrigger: true,
                    allowBlank: false,
                    //readOnly: true,
                    //fieldStyle: 'background:#E6E6E6',
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    listeners: {
                        'blur': function (self, newValue, oldValue) {
                            var form = this.up('form').getForm();
                            var FX_AMT = form.findField('FX_AMT').value;
                            var ZQ_BILL_QX = form.findField('ZQ_BILL_QX').getValue();
                            var ZQ_BILL_QX = ZQ_BILL_QX == null ? "" : ZQ_BILL_QX.replace("年", "");
                            //var ZQ_BILL_QX = ZQ_BILL_QX.replace("年", "");
                            var PM_RATE = form.findField('PM_RATE').getValue();
                            var LX_SUM_AMT = form.findField('LX_SUM_AMT');
                            LX_SUM_AMT.setValue(FX_AMT * PM_RATE * ZQ_BILL_QX / 100);
                            var FXSXF_RATE = form.findField('FXSXF_RATE').getValue();
                            var FXSXF_AMT = form.findField('FXSXF_AMT');
                            FXSXF_AMT.setValue(FX_AMT * 100000000 * FXSXF_RATE / 1000);
                            var TGSXF_RATE = form.findField('TGSXF_RATE').getValue();
                            var TGSXF_AMT = form.findField('TGSXF_AMT');
                            TGSXF_AMT.setValue(FX_AMT * 100000000 * TGSXF_RATE / 1000);
                            //如果发行方式为定向承销，则其中置换金额等于实际发行额
                            var FXFS_ID = form.findField('FXFS_ID').value;
                            var ZQLB_ID = form.findField('ZQLB_ID').value;
                            form.findField('PLAN_FX_AMT').setValue(FX_AMT);
                            setZqxxValue(form);
                            // var qzgtamt = form.findField('QZGT_AMT').getValue();
                            // if(qzgtamt > newValue){
                            //     Ext.Msg.alert("提示","其中柜台发行额不能超过实际发行额！") ;
                            //     form.findField('QZGT_AMT').setValue(0);
                            // }
                            //如果债券类型为以下几种，新增金额默认为实际发行额
                            reserAmt (form,onlyShow,isEdit,false,false);
                            /*if (!isEdit && !editFirstLoad) {
                                if(FXFS_ID == '02'){
                                    form.findField('XZ_AMT').setValue(0);
                                    form.findField('HB_AMT').setValue(0);
                                    form.findField('ZH_AMT').setValue(FX_AMT);
                                } else if (FXFS_ID == '01' && (ZQLB_ID == '020201' || ZQLB_ID == '020202' || ZQLB_ID == '020299')) {
                                    form.findField('ZH_AMT').setValue(0);
                                    form.findField('HB_AMT').setValue(0);
                                    form.findField('XZ_AMT').setValue(FX_AMT);
                                } else {
                                    form.findField('XZ_AMT').setValue(0);
                                    form.findField('ZH_AMT').setValue(0);
                                    form.findField('HB_AMT').setValue(0);
                                }
                            }*/
                        },
                        'blur': function () {
                            var form = this.up('form').getForm();
                            //实际发行金额校验
                            cheSJJE(form);
                        }
                    }
                },

                    ]
            },
            {   // 第二部分：第二行
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .33, labelWidth: labelWidth,
                    margin: '7 1 3 20',
                   // padding: '2 0 2 0'
                    //labelAlign: 'right',//labelStyle : fontSize,
                    labelAlign: 'left',
                    allowBlank: true
                },
                items: [

                    {
                    xtype: "numberfield",
                    name: "XZ_AMT",
                    fieldLabel: '<span class="required">✶</span>其中新增债券（亿）',
                    emptyText: '0.000000',
                    value: 0,
                    maxValue: 999999.99,
                    minValue: 0,
                    decimalPrecision: 8,
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    hidden: true,
                    listeners: {
                        'change': function () {
                            if (sysParamZqfxfs == '1') {
                                var form = this.up('form').getForm();
                                if (!isEdit && node_code == 1 && !editFirstLoad) {
                                    var zhForm = form.findField('ZH_AMT') ;
                                    var ZH_AMT = zhForm.getValue();
                                    var XZ_AMT = form.findField('XZ_AMT').getValue();
                                    var HB_AMT = form.findField('HB_AMT').getValue();
                                    var FX_AMT = form.findField('FX_AMT').getValue();
                                    /*if((HB_AMT+XZ_AMT+ZH_AMT)-FX_AMT > 0.0000001){
                                        Ext.Msg.alert("提示","输入金额不能大于实际发行额！") ;
                                        form.findField('XZ_AMT').setValue(0)
                                        return;
                                    }*/
                                }
                            }
                        }
                    }
                }
                ,{
                    xtype: "numberfield",
                    name: "ZH_AMT",
                    fieldLabel: '<span class="required">✶</span>置换债券（亿）',
                    emptyText: '0.000000',
                    value: 0,
                    maxValue: 999999.99,
                    minValue: 0,
                    decimalPrecision: 8,
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    hidden: true,
                    listeners: {
                        'change': function () { //是否和新增 置换 计算
                            if (sysParamZqfxfs == '1') {
                                var form = this.up('form').getForm();
                                if (!isEdit && node_code == 1 && !editFirstLoad) {
                                    var xzForm = form.findField('XZ_AMT') ;
                                    var XZ_AMT = xzForm.getValue();
                                    var HB_AMT = form.findField('HB_AMT').getValue();
                                    var ZH_AMT = form.findField('ZH_AMT').getValue();
                                    var FX_AMT = form.findField('FX_AMT').getValue();
                                    /*if((HB_AMT+XZ_AMT+ZH_AMT)-FX_AMT > 0.0000001){
                                        Ext.Msg.alert("提示","输入金额不能大于实际发行额！") ;
                                        form.findField('ZH_AMT').setValue(0);
                                        return;
                                    }*/
                                }
                            }
                        }
                    }
                },{
                    xtype: "numberfield",
                    name: "HB_AMT",
                    fieldLabel: '<span class="required">✶</span>再融资债券（亿）',
                    emptyText: '0.000000',
                    value: 0,
                    maxValue: 999999.99,
                    minValue: 0,
                    decimalPrecision: 8,
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    hidden: true,
                    listeners: {
                        'change': function () {
                            if (sysParamZqfxfs == '1') {
                                var form = this.up('form').getForm();
                                if (!isEdit && node_code == 1 && !editFirstLoad) {
                                    var xzForm = form.findField('XZ_AMT') ;
                                    var XZ_AMT = xzForm.getValue();
                                    var HB_AMT = form.findField('HB_AMT').getValue();
                                    var ZH_AMT = form.findField('ZH_AMT').getValue();
                                    var FX_AMT = form.findField('FX_AMT').getValue();
                                   /* if((HB_AMT+XZ_AMT+ZH_AMT)-FX_AMT > 0.0000001){
                                        form.findField('HB_AMT').setValue(0);
                                        Ext.Msg.alert("提示","输入金额不能大于实际发行额！") ;
                                        return;
                                    }*/
                                    /* if(ZH_AMT > FX_AMT){
                                         form.findField('ZH_AMT').setValue(FX_AMT);
                                     }else if(XZ_AMT > FX_AMT){
                                         form.findField('XZ_AMT').setValue(FX_AMT);
                                     }else{
                                         xzForm.setValue(FX_AMT - ZH_AMT - HB_AMT);
                                     }*/

                                }
                            }
                        }
                    }
                }, {
                        xtype: "numberfield",
                        name: "CH_DQZQ_AMT",
                        fieldLabel: '偿还到期债券（亿）',
                        emptyText: '0.000000',
                        value: 0,
                        maxValue: 999999.99,
                        minValue: 0,
                        decimalPrecision: 8,
                        hideTrigger: true,
                        allowBlank: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        hidden: true,
                        listeners: {
                            'change': function () {
                            }}
                    },
                    {
                        xtype: "numberfield",
                        name: "CH_CLZW_AMT",
                        fieldLabel: '偿还存量债务（亿）',
                        emptyText: '0.000000',
                        value: 0,
                        maxValue: 999999.99,
                        minValue: 0,
                        decimalPrecision: 8,
                        hideTrigger: true,
                        allowBlank: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        hidden: true,
                        listeners: {
                            'change': function () {

                            }}
                    },{
                        xtype: "numberfield",
                        name: "ZX_FX_AMT",
                        fieldLabel: '专项债用作资本金（亿）',
                        emptyText: '0.000000',
                        value: 0,
                        maxValue: 999999.99,
                        minValue: 0,
                        decimalPrecision: 8,
                        hideTrigger: true,
                        allowBlank: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        hidden: true,
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var xz_amt = form.findField('XZ_AMT').getValue();
                                /*if(newValue > xz_amt){
                                    Ext.Msg.alert("提示","专项债用作资本金不能超过其中新增债券！") ;
                                    form.findField('ZX_FX_AMT').setValue(0);
                                    return;
                                }*/
                            }}
                    },{
                        xtype: "numberfield",
                        name: "XZCZAP_AMT",
                        fieldLabel: '其中:新增赤字（亿）',
                        emptyText: '0.000000',
                        value: 0,
                        maxValue: 999999.99,
                        minValue: 0,
                        decimalPrecision: 8,
                        hideTrigger: true,
                        allowBlank: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        hidden: true,
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var xz_amt = form.findField('XZ_AMT').getValue();
                                /*if(newValue > xz_amt){
                                    Ext.Msg.alert("提示","专项债用作资本金不能超过其中新增债券！") ;
                                    form.findField('ZX_FX_AMT').setValue(0);
                                    return;
                                }*/
                            }}
                    },
                    {
                        xtype: "numberfield",
                        name: "QZGT_AMT",
                        fieldLabel: '其中柜台发行额（亿）',
                        emptyText: '0.000000',
                        value: 0,
                        maxValue: 999999.99,
                        minValue: 0,
                        decimalPrecision: 8,
                        hideTrigger: true,
                        allowBlank: false,
                        fieldStyle:  'background:#FFFFFF',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var form = this.up('form').getForm();
                                var fx_amt = form.findField('FX_AMT').getValue();
                                if(newValue > fx_amt){
                                    Ext.Msg.alert("提示","其中柜台发行额不能超过实际发行额！") ;
                                    form.findField('QZGT_AMT').setValue(0)
                                    return;
                                }

                            }
                        }
                    },
                    {
                    xtype: "numberfield",
                    name: "ZBJG_AMT",
                    fieldLabel: '<span class="required">✶</span>中标价格（元）',
                    emptyText: '0.00',
                    value: 100.00,
                    decimalPrecision: 8,
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    listeners: {
                        'change':function(self,value,oldValue,e){
                            if(value != null){
                                if(value < 0){
                                    Ext.Msg.alert("提示","中标价格不能小于0！");
                                    self.setValue(oldValue) ;
                                }
                                if(value > 200){
                                    Ext.Msg.alert("提示","中标价格最大不能超过200！");
                                    self.setValue(oldValue) ;
                                }
                            }
                        }
                    }
                },{
                    xtype: "datefield",
                    name: "ZQ_GGR",
                    fieldLabel: '公告日',
                    allowBlank: true,
                    format: 'Y-m-d',
                    blankText: '请选择开始日期',
                    //emptyText: '请选择开始日期',
                    value : ''
                    //value: today
                },{
                    xtype: "datefield",
                    name: "ZB_DATE",
                    fieldLabel: '<span class="required">✶</span>招标日',
                    allowBlank: false,
                    format: 'Y-m-d',
                    blankText: '请选择开始日期',
                    emptyText: '请选择开始日期',
                    value : ''
                    //value: today
                }]
            },
            {   // 第二部分：第三行
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .33, labelWidth: labelWidth,
                    margin: '7 1 3 20',
                   // padding: '2 0 2 0',
                    //labelAlign: 'right',//labelStyle : fontSize,
                    labelAlign: 'left',
                    allowBlank: true
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '招标开始时间',
                        name: "ZB_START_DATE",
                        editable: true,
                        hidden:true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '招标结束时间',
                        name: "ZB_END_DATE",
                        editable: true,
                        hidden:true
                    }]
            },
            {   // 分割线
                xtype: 'container',
                layout: 'hbox',
                items: [{// 分割线
                    xtype: 'menuseparator',
                    width: '100%',
                    border: true
                }]
            },
            {  //第三部分：第一行
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .33, labelWidth: labelWidth,
                    //padding: '2 0 2 0',
                    margin: '7 1 3 20',
                    //labelAlign: 'right',//labelStyle : fontSize,
                    labelAlign: 'left',
                    allowBlank: true
                },
                items: [
                    {
                        xtype: "combobox",
                        name: "QXFW_ID",
                        store: DebtEleStore(json_debt_zqqxfw),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>期限范围',
                        allowBlank: false,
                        editable: false,
                        value: 10,
                        listeners: {
                            change: function (self, newValue) {
                                var  ZQ_BILL_QX = editorPanel.down('combobox[name="ZQ_BILL_QX"]').getValue();
                                var  qxfw_id = ZQ_BILL_QX <=10 ? 10 : ZQ_BILL_QX >10 && ZQ_BILL_QX <= 20 ? 20 :30;
                                if (qxfw_id != newValue) {
                                    editorPanel.down('combobox[name="ZQ_BILL_QX"]').setValue();
                                }
                                zqqxStore = DebtEleStoreDB('DEBT_ZQQX', {condition: " and code >= "+(newValue-9)+ "and code <= "+ newValue });
                                editorPanel.down('combobox[name="ZQ_BILL_QX"]').setStore(zqqxStore);
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "ZQ_BILL_QX",
                        store: zqqxStore,
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>期限(年)',
                        allowBlank: false,
                        editable: false,
                        listeners: {
                            'change': function (self,newValue) {
                                var form = this.up('form').getForm();
                                var FX_AMT = form.findField('FX_AMT').value;
                                var ZQQX = form.findField('ZQ_BILL_QX').getValue();
                                var ZQ_BILL_QX = ZQQX == null ? "" : ZQQX.replace("年", "");
                                var PM_RATE = form.findField('PM_RATE').getValue();
                                var LX_SUM_AMT = form.findField('LX_SUM_AMT');
                                LX_SUM_AMT.setValue(FX_AMT * PM_RATE * ZQ_BILL_QX / 100);
                                /*var qxDate = Ext.ComponentQuery.query('datefield[name="QX_DATE"]')[0].getValue();
                                var year = parseInt(qxDate.getFullYear()) + parseInt(ZQ_BILL_QX);
                                var month = qxDate.getUTCMonth() + 1;
                                */
                                var qxDate = Ext.util.Format.date(Ext.ComponentQuery.query('datefield[name="QX_DATE"]')[0].getValue(),'Y-m-d');
                                var year = accAdd(qxDate.split('-')[0],ZQ_BILL_QX);
                                var month = qxDate.split('-')[1];
                                var day = qxDate.split('-')[2];
                                /*if (month < 10)
                                    month = "0" + month;
                                //var day = qxDate.getDate();
                                if (day < 10)
                                    day = "0" + day;*/
                                var dfrq = year + '-' + month + '-' + day;//兑付日期
                                Ext.ComponentQuery.query('datefield[name="DQDF_DATE"]')[0].setValue(dfrq,'Y-m-d');
                                //只在录入的时候自动设置值
                                if(!isEdit&&!editFirstLoad){
                                    if(parseInt(ZQ_BILL_QX)<=1){
                                        form.findField('TGSXF_RATE').setValue(0.05);
                                    }else{
                                        form.findField('TGSXF_RATE').setValue(0.1);
                                    }
                                    if(parseInt(ZQ_BILL_QX)<=3){
                                        form.findField('FXSXF_RATE').setValue(0.5);
                                    }else{
                                        form.findField('FXSXF_RATE').setValue(1);
                                    }
                                }
                                //设置赎回模式
                                form.findField("SHMS1").setValue(ZQ_BILL_QX);
                                form.findField("SHMS2").setValue(0);
                                form.findField("SHMS3").setValue(0);
                                form.findField("SHMS2").maxValue=ZQ_BILL_QX-1;
                                form.findField("SHMS3").maxValue=ZQ_BILL_QX-1;
                            }
                        }
                    },
                    {
                        xtype: 'fieldcontainer',
                        fieldLabel: '赎回方式',
                        layout: 'hbox',
                        margin: '7 1 3 20',
                        items: [
                            {
                                xtype: 'numberfield',
                                name: 'SHMS1',
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6',
                                minValue: 1,
                                width: '25%',
                                allowBlank: false,
                                hideTrigger: true,
                                value:0,
                                listeners:{
                                    'change': function (self, newValue, oldValue) {

                                    }
                                }
                            },
                            {
                                xtype: 'label',
                                text: '+',
                                margin: '3 3 3 3'
                            },
                            {
                                xtype: 'numberfield',
                                name: 'SHMS2',
                                minValue: 0,
                                width: '25%',
                                allowBlank: false,
                                hideTrigger: true,
                                value:0,
                                listeners:{
                                    'change': function (self, newValue, oldValue) {
                                        var form = this.up('form').getForm();
                                        var ZQQX = form.findField('ZQ_BILL_QX').getValue();
                                        if(ZQQX == null || ZQQX=='' || ZQQX==undefined){
                                            Ext.Msg.alert('提示', '请先选择期限！');
                                            form.findField("SHMS2").setValue(0);
                                            return;
                                        }
                                        var ZQ_BILL_QX = parseInt(ZQQX.replace("年", ""));
                                        form.findField("SHMS1").setValue(ZQ_BILL_QX-newValue);
                                        form.findField("SHMS3").setValue(0);
                                        form.findField("SHMS3").maxValue=ZQ_BILL_QX-newValue-1;
                                    }
                                }
                            },
                            {
                                xtype: 'label',
                                text: '+',
                                margin: '3 3 3 3'
                            },
                            {
                                xtype: 'numberfield',
                                name: 'SHMS3',
                                minValue: 0,
                                hideTrigger: true,
                                value:0,
                                width: '25%',
                                height:'10%',
                                allowBlank: false,
                                listeners:{
                                    'change': function (self, newValue, oldValue) {
                                        var form = this.up('form').getForm();
                                        var ZQQX = form.findField('ZQ_BILL_QX').getValue();
                                        if(ZQQX == null || ZQQX=='' || ZQQX==undefined){
                                            Ext.Msg.alert('提示', '请先选择期限！');
                                            form.findField("SHMS3").setValue(0);
                                            return;
                                        }
                                        var ZQ_BILL_QX = parseInt(ZQQX.replace("年", ""));
                                        var SHMS2 = form.findField('SHMS2').getValue();
                                        form.findField("SHMS1").setValue(ZQ_BILL_QX-newValue-SHMS2);
                                    }
                                }
                            }
                        ]
                    },
                    {
                        xtype: "numberfield",
                        name: "PM_RATE",
                        fieldLabel: '<span class="required">✶</span>票面利率（%）',
                        emptyText: '0.000000',
                        decimalPrecision: 8,
                        maxValue: 9999.999999,
                        minValue: 0.000001,
                        hideTrigger: true,
                        allowBlank: false,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var FX_AMT = form.findField('FX_AMT').value;
                                var ZQ_BILL_QX = form.findField('ZQ_BILL_QX').getValue();
                                //var ZQ_BILL_QX = ZQQX == null ? "" : ZQQX.replace("年", "");
                                var PM_RATE = form.findField('PM_RATE').getValue();
                                var LX_SUM_AMT = form.findField('LX_SUM_AMT');
                                LX_SUM_AMT.setValue(FX_AMT * PM_RATE * ZQ_BILL_QX / 100);
                            }
                        }
                    },
                    {
                        xtype: "numberfield",
                        name: "LX_SUM_AMT",
                        fieldLabel: '利息总额（亿）',
                        emptyText: '0.00000000',
                        decimalPrecision: 10,
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        hidden:true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        xtype: "datefield",
                        //vtype: 'compareFxDateQxDate',
                        name: "QX_DATE",
                        fieldLabel: '<span class="required">✶</span>起息日',
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择开始日期',
                        allowBlank: false,
                        value: today,
                        listeners: {
                            'change': function (self,newValue,oldValue) {
                                if (isNaN(oldValue) || isNaN(newValue)) {
                                    return;
                                }
                                var ZQ_BILL_QX = Ext.ComponentQuery.query('combobox[name="ZQ_BILL_QX"]')[0].getValue();
                                //var ZQ_BILL_QX = ZQ_BILL_QX.replace("年", "");
                                var qxDate = Ext.util.Format.date(newValue,'Y-m-d');
                                var year = accAdd(qxDate.split('-')[0],ZQ_BILL_QX);
                                var month = qxDate.split('-')[1];
                                var day = qxDate.split('-')[2];
                                /*if (month < 10) {
                                    month = "0" + month;
                                }
                                if (day < 10) {
                                    day = "0" + day;
                                }*/
                                var dfrq = year + '-' + month + '-' + day;//兑付日期
                                Ext.ComponentQuery.query('datefield[name="DQDF_DATE"]')[0].setValue(dfrq);

                            }
                        }
                    },
                    {
                        xtype: "datefield",
                        name: "DQDF_DATE",
                        fieldLabel: '到期兑付日',
                        format: 'Y-m-d',
                        blankText: '请选择开始日期',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        value: today,
                        listeners: {
                            'select': function () {
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "FXZQ_ID",
                        store: DebtEleStore(json_debt_fxzq),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>付息方式',
                        allowBlank: false,
                        editable: false, //禁用编辑
                        listeners: {
                            'select': function () {
                            }
                        }
                    },
                    {
                        xtype: "numberfield",
                        name: "TQHK_DAYS",
                        fieldLabel: '提前还款天数',
                        emptyText: '0',
                        decimalPrecision: 0,
                        hideTrigger: true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        xtype: "datefield",
                        //vtype: 'compareFxDateQxDate',
                        name: "FX_START_DATE",
                        fieldLabel: '<span class="required">✶</span>发行日期',
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择日期',
                        //hidden:fxrqShowFlag,
                        value: today
                    },
                    {
                        xtype: "datefield",
                        name: "JK_DATE",
                        fieldLabel: '缴款日期',
                        format: 'Y-m-d',
                        hidden:fxrqShowFlag,
                        listeners: {
                            'select': function () {
                            }
                        }
                    },
                    {
                        xtype: "datefield",
                        name: "FX_END_DATE",
                        fieldLabel: '至',
                        //allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择开始日期',
                        hidden:true,
                        //value: today,
                        listeners: {
                            'select': function () {
                            }
                        }
                    }
                ]
            },
            {   // 分割线
                xtype: 'container',
                layout: 'hbox',
                items: [{// 分割线
                    xtype: 'menuseparator',
                    width: '100%',
                    border: true
                }]
            },
            {   // 第六部分：第一行
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .33, labelWidth: labelWidth,
                    //padding: '2 0 2 0',
                    margin: '7 1 3 20',
                    labelAlign: 'left',//labelStyle : fontSize,
                    allowBlank: true
                },
                items: [{
                    xtype: "combobox",
                    name: "SXFYJ_ID",
                    store: DebtEleStore(json_debt_sxfyj),
                    displayField: "name",
                    valueField: "id",
                    value: '001',
                    fieldLabel: '<span class="required">✶</span>手续费支付方式',
                    allowBlank: false,
                    editable: true, //禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6',
                    listeners: {
                        'select': function () {
                        }
                    }
                },
                    {
                        xtype: "numberfield",
                        name: "FXSXF_RATE",
                        maxValue: 10,
                        fieldLabel: '<span class="required">✶</span>发行手续费费率（‰）',
                        emptyText: '0.0000',
                        minValue: 0.000001,
                        maxLength: 12,
                        decimalPrecision: 4,
                        hideTrigger: true,
                        allowBlank: false,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {
                            'blur': function () {
                                var form = this.up('form').getForm();
                                var FX_AMT = form.findField('FX_AMT').getValue();
                                var FXSXF_RATE = form.findField('FXSXF_RATE').getValue();
                                var FXSXF_AMT = form.findField('FXSXF_AMT');
                                FXSXF_AMT.setValue(FX_AMT * 100000000 * FXSXF_RATE / 1000);
                            }
                        }
                    },
                    {
                        xtype: "numberfield",
                        name: "TGSXF_RATE",
                        fieldLabel: '<span class="required">✶</span>登记托管费率（‰）',
                        emptyText: '0.0000',
                        decimalPrecision: 4,
                        maxValue: 10,
                        minValue: 0,
                        maxLength: 12,
                        hideTrigger: true,
                        allowBlank: false,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var FX_AMT = form.findField('FX_AMT').getValue();
                                var TGSXF_RATE = form.findField('TGSXF_RATE').getValue();
                                var TGSXF_AMT = form.findField('TGSXF_AMT');
                                TGSXF_AMT.setValue(FX_AMT * 100000000 * TGSXF_RATE / 1000);
                            }
                        }
                    }]
            },
            {//第六部分：第二行
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .33, labelWidth: labelWidth,
                    //padding: '2 0 5 0',
                    margin: '7 1 3 20',
                    //labelAlign: 'right',//labelStyle : fontSize,
                    labelAlign: 'left',
                    allowBlank: true
                },
                items: [{
                    xtype: "numberfield",
                    name: "DFSXF_RATE",
                    fieldLabel: '<span class="required">✶</span>兑付手续费率（‰）',
                    emptyText: '0.0000',
                    minValue: 0.000001,
                    value: 0.05,
                    decimalPrecision: 4,
                    maxValue: 10,
                    maxLength: 12,
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                    {
                        xtype: "numberfield",
                        name: "FXSXF_AMT",
                        fieldLabel: '发行手续费（元）',
                        emptyText: '0.00',
                        hideTrigger: true,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        xtype: "numberfield",
                        name: "TGSXF_AMT",
                        fieldLabel: '登记托管费（元）',
                        emptyText: '0.00',
                        hideTrigger: true,
                        editable: false,
                        fieldStyle: 'background:#E6E6E6',
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '备注',
                        columnWidth: .99,
                        name: "REMARK" ,
                        maxLength : 200 ,
                        maxLengthText : '输入文字过长，只能输入200个字！'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '首次发行债券ID',
                        hidden: true,
                        name: "FIRST_ZQ_ID"
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '是否续发行',
                        hidden: true,
                        name: "IS_XFX"
                    }
                ]
            }
        ]
    }];

    var editorPanel = Ext.create('Ext.form.Panel', {
        itemId: 'jbxxForm',
        layout: 'fit',
        border: false,
        autoScroll: true,
        items: content
    });

    /**
     * 若为新增状态，则直接进行页面元素的初始化
     * 若为更新状态，则先进行数据的加载，加载完成后再进行页面元素的初始化
     */
    if (button_name == 'EDIT'||button_name == 'VIEW') {
        loadFxgl(editorPanel);
    }else {
    }

    return editorPanel;
};
/**
 * 自定义校验：比较计划/实际开工/竣工日期
 */
Ext.apply(Ext.form.VTypes, {
    compareFxDateQxDate: function (value, field) {
        return compareFxDateQxDate(field.up('form'));
    },
    compareFxDateQxDateText: '发行日期应早于起息日'
});
/**
 * 比较发行日期/起息日
 * @param form
 * @return {boolean}
 */
function compareFxDateQxDate(form) {
    var ZB_DATE = form.down('[name=ZB_DATE]').getValue();
    var QX_DATE = form.down('[name=QX_DATE]').getValue();
    if (ZB_DATE && QX_DATE && ZB_DATE > QX_DATE) {
        return false;
    }
    return true;
}

/**
 * 提交表单数据
 * @param form
 */
function submitFxgl(form,workflow) {
    var cxjgStr = '';//用于校验
    //var tbjgArr=[];//用于校验
    //var zbjgArr = [];//用于校验
    if (!compareFxDateQxDate(form)) {
        message_error = '招标日应早于起息日';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            return false;
        }
    }
    var jgxxArray = [];
    var jsxmGrid = DSYGrid.getGrid('jsxmGrid').getStore();
    if(isViewCXJG == 1){
        var jgxxStore = DSYGrid.getGrid('jgxxGrid').getStore();

        if(jgxxStore.getCount() <= 0){
            Ext.Msg.alert('提示', '请选择承销团信息！');
            return;
        }
        //获取机构信息
        for (var i = 0; i < jgxxStore.getCount(); i++) {
            var array = {};
            var record = jgxxStore.getAt(i);
            array.CXJG_CODE = record.get("CXJG_CODE");
            array.CXJG_NAME = record.get("CXJG_NAME");
            array.CXS_TGZH = record.get("CXS_TGZH");
            array.CXS_ZZDZH=record.get("CXS_ZZDZH");
            array.IS_LEADER = record.get("IS_LEADER");
            array.CX_SCALE = record.get("CX_SCALE");
            array.ORG_ACCOUNT = record.get("ORG_ACCOUNT");
            array.ORG_ACC_NAME = record.get("ORG_ACC_NAME");
            array.ORG_ACC_BANK = record.get("ORG_ACC_BANK");
            jgxxArray.push(array);

            cxjgStr = cxjgStr + array.CXS_TGZH + "#";
        }

        //获取投标信息
        /*var tbxxStroe = DSYGrid.getGrid('tbxxGrid').getStore();
        var tbxxArray = [];
        //获取机构信息
        for (var i = 0; i < tbxxStroe.getCount(); i++) {
            var array = {};
            var record = tbxxStroe.getAt(i);
            array.CXJG_CODE = record.get("CXJG_CODE");
            array.CXJG_NAME = record.get("CXJG_NAME");
            array.TB_JW = record.get("TB_JW");
            array.TB_AMT = record.get("TB_AMT");
            tbxxArray.push(array);
        }*/

        //获取承销及缴款信息
        /*var cxjkStroe = DSYGrid.getGrid('cxjkGrid').getStore();
        var cxjkArray = [];
        var sumRgAmt = 0;
        for (var i = 0; i < cxjkStroe.getCount(); i++) {
            var array = {};
            var record = cxjkStroe.getAt(i);
            sumRgAmt += record.get("RG_SUM_AMT");
            array.CXS_CODE = record.get("CXS_CODE");
            array.CXS_TGZH = record.get("CXS_TGZH");
            array.CXJG_NAME = record.get("CXJG_NAME");
            array.GDCX_AMT = record.get("GDCX_AMT") * 100000000;
            array.ZB_AMT = record.get("ZB_AMT") * 100000000;
            array.RG_SUM_AMT = record.get("RG_SUM_AMT") * 100000000;
            array.JK_AMT = record.get("JK_AMT");
            cxjkArray.push(array);
            zbjgArr.push(record.get("CXS_TGZH"));
        }*/

        //var form = Ext.ComponentQuery.query('form[itemId="zbqkForm"]')[0].getForm();
        //form.findField("ZQ_NAME").getValue();

//    	    var cxjkArray = [];
//	        var array = {};
//	        var record = cxjkStroe.getAt(i);
//	        array.CXS_CODE = form.findField("ZQ_NAME").getValue();
//	        array.CXS_TGZH = record.get("CXS_TGZH");
//	        array.CXJG_NAME = record.get("CXJG_NAME");
//	        array.GDCX_AMT = record.get("GDCX_AMT") * 100000000;
//	        array.ZB_AMT = record.get("ZB_AMT") * 100000000;
//	        array.RG_SUM_AMT = record.get("RG_SUM_AMT") * 100000000;
//	        array.JK_AMT = record.get("JK_AMT");
//	        cxjkArray.push(array);
//	        zbjgArr.push(record.get("CXS_TGZH"));







        /*var sub = [];
        for (var i = 0; i < zbjgArr.length; i++) {
            if (cxjgStr.indexOf(zbjgArr[i]) == -1) {
                sub = zbjgArr[i];
            }
        }
        if (sub.length > 0) {
            Ext.Msg.alert('提示', "承销及缴款信息中承销商托管账号为：" + sub + "的机构在债券承销机构中不存在，请检查！");
            return;
        }*/

        //校验当系统发行方式参数为1时 承销机构认购金额必须等于实际发行额
        /*if (sysParamZqfxfs == '1' && node_code == '2') {
               //alert(sumRgAmt+"----"+form.getForm().findField("FX_AMT").value);
            if (sumRgAmt != form.getForm().findField("FX_AMT").value) {
                Ext.Msg.alert('提示', '承销商认购金额合计与债券实际发行额不等，请检查');
                return;
            }
        }*/

    }
    //校验实际发行额=新增+置换
    var fxamt = form.getForm().findField("FX_AMT").value*10000;
    var xzamt = form.getForm().findField("XZ_AMT").value*10000;
    var zhamt = form.getForm().findField("ZH_AMT").value*10000;
    var hbamt = form.getForm().findField("HB_AMT").value*10000;
    var jhamt = form.getForm().findField("PLAN_FX_AMT").value*10000;
    var zxfxamt = form.getForm().findField("ZX_FX_AMT").value*10000;
    var xzczapamt = form.getForm().findField("XZCZAP_AMT").value*100000000/10000;
    var qzgtamt = form.getForm().findField("QZGT_AMT").value*10000;
    var chdqzqamt = form.getForm().findField("CH_DQZQ_AMT").value*10000;
    var chclzwamt = form.getForm().findField("CH_CLZW_AMT").value*10000;
    var ZQLB_ID = form.getForm().findField("ZQLB_ID").value;
    var ZQLX_ID = form.getForm().findField("ZQLX_ID").value;
    // 债权类型为再融资债券走以下较验
    if(ZQLX_ID == '03'){
        if(fxamt.toFixed(2) != (parseFloat(chdqzqamt)+parseFloat(chclzwamt)).toFixed(2)){
            Ext.Msg.alert('提示','基本信息页有误，实际发行额不等于偿还到期债券金额加偿还存量债务金额之和，请检查');
            return;
        }
    }
    if(fxamt>jhamt){
        Ext.Msg.alert('提示', '基本信息页有误，实际发行额不能大于计划发行额！');
        return;
    }
    if(xzczapamt>xzamt){
        Ext.Msg.alert('提示', '基本信息页有误，其中:新增赤字不能大于实际发行金额！');
        return;
    }
    if(zxfxamt>xzamt){
        Ext.Msg.alert('提示', '基本信息页有误，专项债用作资本金不能大于实际发行金额！');
        return;
    }
    if(ZQLB_ID=='' || ZQLB_ID==undefined){
        Ext.Msg.alert('提示', '债券类型不能为空！');
        return;
    }
    if(jhamt*10000<100000 || jhamt*10000>99999999999){
        Ext.Msg.alert('提示','基本信息页有误，计划发行债券金额应介于0.001-999.99999999亿元之间，请检查');
        return;
    }
    if (fxamt <= 0){
        Ext.Msg.alert('提示','基本信息页有误，实际发行额应该大于0，请检查');
        return;
    }
    /*if (fxamt.toFixed(2) != (parseFloat(xzamt)+parseFloat(zhamt)+parseFloat(hbamt)).toFixed(2)) {
        Ext.Msg.alert('提示','基本信息页有误，实际发行额不等于新增债券加置换债券加再融资债券之和，请检查');
        return;
    }*/
    /*if (zxfxamt> xzamt) {
        Ext.Msg.alert('提示','基本信息页签中"专项债用作资本金"不能超过"其中新增债券"金额！');
        return;
    }*/
    if(IS_BZB == '1' || IS_BZB == '2'){
        // 债权类型为新增，债券类别不为一般进行较验
        if(ZQLX_ID == '01' && ZQLB_ID != '01'){
            if ( parseFloat(Ext.util.Format.number(jsxmGrid.sum('ZX_ZBJ_AMT'), '00000000.00'))  >
                parseFloat(Ext.util.Format.number(zxfxamt, '00000000.00'))  ) {
                Ext.Msg.alert('提示', '建设项目页签中"专项债用作资本金"总金额不能超过基本信息中"专项债用作资本金"！');
                return;
            }
        }
    }
    // 债权类型为新增，债券类别为一般进行较验
    if(ZQLX_ID == '01' && ZQLB_ID == '01') {
        if (parseFloat(Ext.util.Format.number(jsxmGrid.sum('XZCZAP_AMT'), '00000000.00')) >
            parseFloat(Ext.util.Format.number(xzczapamt, '00000000.00'))) {
            Ext.Msg.alert('提示', '建设项目页签中"其中:新增赤字"总金额不能超过基本信息中"其中:新增赤字"！');
            return;
        }
    }
    if (qzgtamt > fxamt) {
        Ext.Msg.alert('提示','其中柜台发行额不能超过实际发行额！');
        return;
    }
    var url = '';
    if (button_name == 'INPUT' || button_name == 'EDIT') {
        url = 'saveFxgl.action?ZQ_BILL_ID=' + ZQ_BILL_ID + '&IS_BZB=' + IS_BZB;
    } /*else {
        url = 'updateFxgl.action?ZQ_BILL_ID=' + ZQ_BILL_ID;
    }*/

    cxt_id = Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].value;
    var zqlb_id = form.getForm().findField("ZQLB_ID").value;
    //var zjly_id = form.getForm().findField("ZJLY_ID").value;
    var srkm_value = form.getForm().findField("SRKM_ID").value;
    if(srkm_value=='' || srkm_value==undefined){
        Ext.Msg.alert('提示', '债务收入科目不能为空！');
        return;
    }
    var srkm_id = zwsrkm_store.findNode('id', srkm_value, 0, false, true, true).get('code');
    /*if( zqlb_id == '01' && "undefined" != typeof(zjly_id) && zjly_id.indexOf("0101") != 0){
        Ext.Msg.alert('提示', "债券类型为“一般债券”时，偿还资金来源只能选择“一般公共预算收入”");
        return;
    }
    if( zqlb_id.indexOf('02') ==0 && "undefined" != typeof(zjly_id) && zjly_id.indexOf("0102") != 0){
        Ext.Msg.alert('提示', "债券类型为“专项债券”时，偿还资金来源只能选择“政府性基金预算收入”");
        return;
    }*/
    if( zqlb_id == '01' && "undefined" != typeof(srkm_id) && srkm_id.indexOf("1050401") != 0){
        Ext.Msg.alert('提示', "债券类型为“一般债券”时，债务收入科目只能选择“一般债务收入”");
        return;
    }
    if( zqlb_id.indexOf('02') ==0 && "undefined" != typeof(srkm_id) && srkm_id.indexOf("1050402") != 0){
        Ext.Msg.alert('提示', "债券类型为“专项债券”时，债务收入科目只能选择“专项债务收入”");
        return;
    }

    var fxsxfl_id=form.getForm().findField('FXSXF_RATE').value;
    var djtgfl_id=form.getForm().findField('TGSXF_RATE').value;
    var dfsxfl_id=form.getForm().findField('DFSXF_RATE').value;
    var tqhk_id=form.getForm().findField('TQHK_DAYS').value;
    var qx_date=form.getForm().findField('QX_DATE').value;
    var SS_YEAR = form.getForm().findField('SS_YEAR').value;
    var QX_YEAR = format(qx_date,'yyyy');
    qx_date=format(qx_date,'yyyy-MM-dd');

    // 2020/12/09_wjc: 所属年度必须大于等于起息日年度
    if (!!SS_YEAR && !!QX_YEAR && SS_YEAR < QX_YEAR) {
        Ext.Msg.alert('提示', "所属年度必须大于等于起息日年度");
        zqxxTabShow(0);
        return;
    }

    if(tqhk_id>99){
        Ext.Msg.alert('提示', "提前还款天数最大值不能超过99");
        return;
    }

    if(djtgfl_id>10){
        Ext.Msg.alert('提示', "登记托管费率的最大值不能超过10");
        return;
    }

    if(fxsxfl_id>10){
        Ext.Msg.alert('提示', "发行手续费费率的最大值不能超过10");
        return;
    }

    if(dfsxfl_id>10){
        Ext.Msg.alert('提示', "兑付手续费率的最大值不能超过10");
        return;
    }

    /*兑付计划页签校验*/
    var dfjhGrid = DSYGrid.getGrid('dfjhGrid').getStore();
    if (dfjhGrid.getCount() <= 0) {
        Ext.Msg.alert('提示', '请添加兑付计划信息！');
        return;
    }
    /*建设项目页签校验*/
    if(IS_BZB == '1' || IS_BZB == '2'){
        var jsxmArray = [];
        var jsxmMap =new Map();
        var dfjhMap =new Map();
        var checkJS={};
        //基本信息页签新增债券金额大于0，建设项目信息不能为空
        if(ZQLX_ID == '01'){
            if (jsxmGrid.getCount() <= 0) {
                Ext.Msg.alert('提示', '基本信息页签债权类型为新增债券，必须添加建设项目信息！');
                return;
            }
            var fx_amt_total=0;
            var zx_zbj_amt_total=0;
            jsxmGrid.each(function (record) {
                //获取建设项目页签数据
                var fx_amt = record.get("FX_AMT");
                var zx_zbj_amt = record.get("ZX_ZBJ_AMT");
                fx_amt_total+=fx_amt;
                zx_zbj_amt_total=(zx_zbj_amt*10000000+zx_zbj_amt_total*10000000)/10000000;
                var date=record.get("DF_END_DATE");
                if(date==null|| date=='' || date=='undefined'){
                    Ext.Msg.alert('提示', "建设项目页签兑付日期不能为空");
                    return;
                }
                var DF_END_DATE = format(date,'yyyy-MM-dd');
                //处理建设项目页签数据,兑付日期相同的建设项目,将金额累加,jsxmMap数据格式 兑付日期:发行金额
                if(jsxmMap.has(DF_END_DATE)){
                    var fx_amt_value = jsxmMap.get(DF_END_DATE)+fx_amt;
                    jsxmMap.set(DF_END_DATE,fx_amt_value);
                }else{
                    jsxmMap.set(DF_END_DATE,fx_amt);
                }
            });
            var format_fx_amt_total =  Ext.util.Format.number(fx_amt_total, '00000000.00');
            var format_xzamt =  Ext.util.Format.number(fx_amt_total, '00000000.00');
            if(parseFloat(format_fx_amt_total) != parseFloat(format_xzamt)){
                Ext.Msg.alert('提示', "建设项目页签发行金额合计值应等于基本信息页签实际发行额");
                return;
            }
            /*if(zx_zbj_amt_total > zxfxamt){
                Ext.Msg.alert('提示', "建设项目页签专项债用作资本金合计值应小于基本信息页签专项债用作资本金");
                return;
            }*/
        }
        if(ZQLX_ID != '01')
        {
            if(jsxmGrid.data.length < 1){

            }else{
                jsxmGrid.removeAll();
                Ext.Msg.alert('提示', "基本信息页签债权类型非新增债券,建设项目页签不可以存在数据！");
                return false;
            }
        }



        var XM_ID=[];
        var DF_END_DATE=[];
        for(var i=0;i<jsxmGrid.count();i++){
            var record =jsxmGrid.getAt(i);
            var df_end_date = record.get("DF_END_DATE");
            var xm_id = record.get("XM_ID");
            XM_ID.push(xm_id);
            DF_END_DATE.push(df_end_date);
            if (record.get("DF_END_DATE") == null || record.get("DF_END_DATE") == '') {
                Ext.Msg.alert('提示', '建设项目页签兑付日期不能为空!');
                return false;
            }
            if (record.get("FX_AMT")<=0) {
                Ext.Msg.alert('提示', '建设项目页签发行金额必须大于0!');
                return false;
            }
        }
        for(var i=0;i<jsxmGrid.count()-1;i++){
            if(XM_ID[i] == XM_ID[i+1]){
                if(DF_END_DATE[i] == DF_END_DATE[i+1]){
                    Ext.Msg.alert('提示', '建设项目页签项目相同情况下，兑付日期不能相同！');
                    return false;
                }
            }
        }
    }
    var df_amt=0;
    var df_xz_amt=0;
    var df_zh_amt=0;
    var df_zrz_amt=0;
    var df_dqzq_amt=0;
    var df_clzw_amt=0;
    var dfjhArray = [];
    var checkDf={};
    for(var i=0;i<dfjhGrid.count();i++){
        var record =dfjhGrid.getAt(i);
        var DF_END_DATE = record.get("DF_END_DATE");
        DF_END_DATE = format(DF_END_DATE, 'yyyy-MM-dd');
        if(!checkDfdate(DF_END_DATE)){
            return false;
        }
        if (typeof checkDf[DF_END_DATE] != 'undefined' && checkDf[DF_END_DATE] != null && checkDf[DF_END_DATE]) {
            Ext.Msg.alert('提示', '兑付计划页签兑付日期不能重复!');
            return false;
        } else {
            checkDf[DF_END_DATE] = true;
        }
        if (record.get("PLAN_AMT")<=0) {
            Ext.Msg.alert('提示', '兑付计划页签兑付金额不能小于0!');
            return false;
        }
        var xz_amt= record.get("PLAN_XZ_AMT");
        df_xz_amt += xz_amt;
        df_zh_amt += record.get("PLAN_ZH_AMT");
        df_zrz_amt += record.get("PLAN_ZRZ_AMT");
        df_dqzq_amt += record.get("CH_DQZQ_AMT");
        df_clzw_amt += record.get("CH_CLZW_AMT");
        df_amt += record.get("PLAN_AMT");
        var zqqx_id=DF_END_DATE.substr(0,4)-qx_date.substr(0,4);
        // zqqx_id=("00"+zqqx_id.toString()).substr(0,3);
        zqqx_id = (Array(3).join(0) + zqqx_id).slice(-3);
        record.set("DF_END_DATE", DF_END_DATE);
        record.set("ZQQX_ID", zqqx_id);
        dfjhArray.push(record.getData());
        if(IS_BZB == '1' || IS_BZB == '2'){
            if(xz_amt>0){
                /*兑付计划页签与建设项目页签数据匹配校验*/
                var FX_AMT = record.get("PLAN_XZ_AMT");
                var ZQCHJH_ID = record.get("ZQCHJH_ID");
                var ZQ_ID = record.get("ZQ_ID");
                var valueMap = {};
                valueMap['ZQCHJH_ID']=ZQCHJH_ID;
                valueMap['ZQ_ID']=ZQ_ID;
                dfjhMap.set(DF_END_DATE,valueMap);
                    if (jsxmMap.get(DF_END_DATE)) {
                        var fx_amt_value = jsxmMap.get(DF_END_DATE);
                        if (parseFloat(Ext.util.Format.number(fx_amt_value, '00000000.00')) !=
                            parseFloat(Ext.util.Format.number(FX_AMT, '00000000.00'))
                        ) {
                            Ext.Msg.alert('提示', '每笔兑付计划的新增债券金额和对应的建设项目发行金额必须一致!');
                            return false;
                        }
                    } else {
                        if(xz_amt>0){
                            Ext.Msg.alert('提示', '有新增债券的兑付计划必须有对应的建设项目！');
                            return false;
                        }
                    }
            }
        }
    }

    if(df_amt-fxamt!=0 && Math.abs(fxamt-df_amt) >= 0.0001){
        Ext.Msg.alert('提示', "兑付计划页签兑付金额合计值应等于基本信息页签实际发行额!");
        return;
    }
    if((df_dqzq_amt + df_clzw_amt) - hbamt != 0 && Math.abs(hbamt - (df_dqzq_amt + df_clzw_amt)) >= 0.0001){
        Ext.Msg.alert('提示', "兑付计划页签偿还到期债券金额与偿还存量债务金额合计值应等于基本信息页签实际发行额!");
        return;
    }
    if(df_xz_amt-xzamt!=0 && Math.abs(xzamt-df_xz_amt) >= 0.0001){
        Ext.Msg.alert('提示', "兑付计划页签新增债券金额合计值应等于基本信息页签实际发行额!");
        return;
    }
    if(df_zh_amt-zhamt!=0 && Math.abs(zhamt-df_zh_amt) >= 0.0001){
        Ext.Msg.alert('提示', "兑付计划页签置换债券金额合计值应等于基本信息页签实际发行额!");
        return;
    }
    /*if(df_zrz_amt-hbamt!=0 && Math.abs(hbamt-df_zrz_amt) >= 0.0001){
        Ext.Msg.alert('提示', "兑付计划页签再融资债券金额合计值应等于基本信息页签再融资债券发行额!");
        return;
    }*/
    jsxmGrid.each(function (record) {
        var date= format(record.get("DF_END_DATE"),'yyyy-MM-dd');
        if(dfjhMap.get(date)) {
            var ZQCHJH_ID=dfjhMap.get(date).ZQCHJH_ID;
            var ZQ_ID=dfjhMap.get(date).ZQ_ID;
            record.set("ZQCHJH_ID", ZQCHJH_ID);
            record.set("ZQ_ID", ZQ_ID);
        }
        var jbxxForm = Ext.ComponentQuery.query('form#jbxxForm')[0];
        var YDJH_ID=jbxxForm.getForm().findField('YDJH_ID').value;
        record.set("YDJH_ID",YDJH_ID);
        record.set("DF_END_DATE", date);
        jsxmArray.push(record.getData());
    });
    /*20210407LIYUE添加到期债券*/
    var dqzqArray=[];
    var dqzqGrid = DSYGrid.getGrid('dqzq_grid').getStore();
    for(var i=0;i<dqzqGrid.count();i++){
        var record =dqzqGrid.getAt(i);
        if(Ext.util.Format.number(record.data.SYSQ_AMT, '0,000.00')<0){
            Ext.Msg.alert('提示', "剩余可申请金额不能为负！");
            return;
        }
        dqzqArray.push(record.getData());
    };
    if(IS_BZB == '1' || IS_BZB == '2'){
        var params = {
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            workflow:workflow,
            userCode: userCode,
            cxt_id: cxt_id,
            ad_code: userAD,
            jgxxArray: encode64(Ext.util.JSON.encode(jgxxArray)),
            jsxmArray: encode64(Ext.util.JSON.encode(jsxmArray)),
            dfjhArray: encode64(Ext.util.JSON.encode(dfjhArray)),
            dqzqArray:encode64(Ext.util.JSON.encode(dqzqArray)),
            //tbxxArray: Ext.util.JSON.encode(tbxxArray),
            //cxjkArray: Ext.util.JSON.encode(cxjkArray),
            isViewCXJG:isViewCXJG
        };
    }else{
        var params = {
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            workflow:workflow,
            userCode: userCode,
            cxt_id: cxt_id,
            ad_code: userAD,
            jgxxArray: encode64(Ext.util.JSON.encode(jgxxArray)),
            dfjhArray: encode64(Ext.util.JSON.encode(dfjhArray)),
            dqzqArray:encode64(Ext.util.JSON.encode(dqzqArray)),
            //tbxxArray: Ext.util.JSON.encode(tbxxArray),
            //cxjkArray: Ext.util.JSON.encode(cxjkArray),
            isViewCXJG:isViewCXJG
        };
    }
    if (form.isValid()) {
        form.submit({
            url: url,
            params: params,
            waitTitle: '请等待',
            waitMsg: '正在保存中...',
            success: function (form, action) {
                if(action.result!=undefined && action.result.success){
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '保存成功',
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function (btn) {
                            zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%') ");
                            zwsrkm_store.load();
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                            if (button_name == 'INPUT') {
                                Ext.ComponentQuery.query('window#addWin')[0].close();
                            } else {
                                Ext.ComponentQuery.query('window#updateWin')[0].close();
                            }
                        }
                    });
                }
            },
            //start modify by Arno Lee 2016-08-17
            failure: function (form, action) {
                Ext.Msg.alert('提示', "保存失败！" + action.result ? action.result.message : '无返回响应');
            }

            //start note by Arno Lee 2016-08-17
//            failure: function(form, action) {
//            	Ext.MessageBox.show({
//    				title: '提示',
//    				msg: '测试',
//    				width: 200,
//    				fn: function (btn) {
//    					if(button_name=='INPUT'){
//    						Ext.ComponentQuery.query('window#addWin')[0].close();
//    					} else {
//    						Ext.ComponentQuery.query('window#updateWin')[0].close();
//    					}
//    				}
//				});
//            }
            //end note by Arno Lee 2016-08-17
            //end modify by Arno Lee 2016-08-17
        });
    } else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
    }
}

function submitFxxxDj(form,btn,oper) {
    //投标信息
    var tbmxArray = [];
    var tbmxStore = DSYGrid.getGrid('tbmxGrid').getStore();
    tbmxStore.each(function (record) {
        tbmxArray.push(record.getData());
    });
    //中标信息
    var zbxxArray = [];
    var zbxxStore = DSYGrid.getGrid('zbxxGrid').getStore();
    zbxxStore.each(function (record) {
        zbxxArray.push(record.getData());
    });
    //承銷商缴款信息
    var cxsjkxxArray = [];
    var cxsjkxxStore = DSYGrid.getGrid('cxsjkxxGrid').getStore();
    cxsjkxxStore.each(function (record) {
        cxsjkxxArray.push(record.getData());
    });
    //承销商投标不足信息
    var tbbzArray = [];
    var tbbzStore = DSYGrid.getGrid('tbbzGrid').getStore();
    tbbzStore.each(function (record) {
        tbbzArray.push(record.getData());
    });
    //承销商未投标信息
    var wtbxxArray = [];
    var wtbxxStore = DSYGrid.getGrid('wtbxxGrid').getStore();
    wtbxxStore.each(function (record) {
        wtbxxArray.push(record.getData());
    });
    //最低承销不足
    var zdcxeArray = [];
    var zdcxeStore = DSYGrid.getGrid('zdcxeGrid').getStore();
    zdcxeStore.each(function (record) {
        zdcxeArray.push(record.getData());
    });
    //债券托管信息
    var tgxxArray = [];
    var tgxxStore = DSYGrid.getGrid('tgxxGrid').getStore();
    tgxxStore.each(function (record) {
        tgxxArray.push(record.getData());
    });
    var msg="";
    if("SAVE"==oper){
        msg="保存";
    }else{
        msg="登记确认";
    }
    if(form.isValid()){
        if(zbxxArray.length == 0 ){
            Ext.Msg.alert('提示','请导入中标信息！');
            return;
        }
        var result = null;
        if(msg == "登记确认"){
            var flag = false;
            if('zzhd' == do_flag_s){
                flag = true;
            }
            result = checkImportDate(tbmxArray,zbxxArray,cxsjkxxArray,tbbzArray,wtbxxArray,zdcxeArray,tgxxArray,flag);
        }
        if(result){
            Ext.MessageBox.alert('提示',result);
            return false;
        }
        form.submit({
            url: 'saveFxDjxx.action',
            params: {
                wf_id: wf_id,
                node_code: node_code,
                userCode: userCode,
                oper:oper,
                button_name: btn.text,
                ZQ_BILL_ID : DSYGrid.getGrid('grid').getSelection()[0].get('ZQ_BILL_ID'),
                tbmxArray: Ext.util.JSON.encode(tbmxArray),
                zbxxArray: Ext.util.JSON.encode(zbxxArray),
                cxsjkxxArray: Ext.util.JSON.encode(cxsjkxxArray),
                tbbzArray: Ext.util.JSON.encode(tbbzArray),
                wtbxxArray: Ext.util.JSON.encode(wtbxxArray),
                zdcxeArray: Ext.util.JSON.encode(zdcxeArray),
                tgxxArray: Ext.util.JSON.encode(tgxxArray),
                do_flag:do_flag_s,
                status : status
            },
            waitTitle: '请等待',
            waitMsg: '正在保存中...',
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: msg+'成功！',
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        DSYGrid.getGrid("grid").getStore().loadPage(1);
                        if("SAVE"!=oper){
                            if (button_name == 'INPUT') {
                                Ext.ComponentQuery.query('window#addWin')[0].close();
                            } else {
                                Ext.ComponentQuery.query('window#updateWin')[0].close();
                            }
                        }

                    }
                });
            },
            //start modify by Arno Lee 2016-08-17
            failure: function (form, action) {
                var result = Ext.util.JSON.decode(action.response.responseText);
                Ext.Msg.alert('提示', "保存失败！" + result ? result.msg : '无返回响应');
            }
        });
    }else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
    }

}

/**
 * createDate：2020/12/09
 * createUser：wangjc
 * （封装）创建保存校验信息提示后，窗口页签展示方法
 */
function zqxxTabShow(index) {
   Ext.ComponentQuery.query('panel[itemId="main_tab"]')[0].items.get(index).show();
}

/**
 * 加载页面数据
 * @param form
 */
function loadFxgl(form) {
    form.load({
        url: 'getFxgl.action?ZQ_BILL_ID=' + ZQ_BILL_ID+'&YDJH_ID='+ydjh_id,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            var  ZQ_BILL_QX = action.result.data.list.ZQ_BILL_QX;
            var  qxfw_id = ZQ_BILL_QX <=10 ? 10 : ZQ_BILL_QX >10 && ZQ_BILL_QX <= 20 ? 20 :30;
            action.result.data.list.QXFW_ID = qxfw_id;
            var year = action.result.data.list.PC_YEAR;
            var condition_str = year <= 2017 ? " <= '2017' " :" = '"+ year +"' ";
            zwsrkm_store.proxy.extraParams['condition'] = encode64(IS_BZB=='2'?"AND CODE NOT LIKE '1050401%' and (code like '105%')  and year" + condition_str:" and (code like '105%')  and year " + condition_str);
            zwsrkm_store.load({
                callback:function(){
                    var jbxxForm = form.getForm();
                    jbxxForm.setValues(action.result.data.list);
                    // 修改时债权类型不可改
                    if(IS_BZB == '1' || IS_BZB == '2'){
                        jbxxForm.findField("ZQLX_ID").setReadOnly(true);
                        jbxxForm.findField("ZQLX_ID").setFieldStyle('background:#E6E6E6');
                    }
                    if (button_name == 'EDIT') {
                        editFirstLoad = false;
                    }
                }
            });
            cxt_id = action.result.data.list.CXT_ID;
            Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].setValue(cxt_id);//设置承销团下拉框信息
            //设置承销团表格
            var jgxxStore = action.result.data.cxtList;
            var grid = DSYGrid.getGrid('jgxxGrid');
            grid.insertData(null, jgxxStore);
            //设置招标信息
            var form1 = Ext.ComponentQuery.query('form#zbqkForm')[0];
            form1.getForm().setValues(action.result.data.zbxxList[0]);

            //设置投标信息
            var tbmxStore = action.result.data.tbmxList;
            var grid = DSYGrid.getGrid('tbmxGrid');
            grid.insertData(null, tbmxStore);
            //设置中标信息
            var zbxxpStore = action.result.data.zbxxpList;
            var grid = DSYGrid.getGrid('zbxxGrid');
            grid.insertData(null, zbxxpStore);

            //设置承销商交款信息
            var cxsjkxxStore = action.result.data.cxsjkxxList;
            var grid = DSYGrid.getGrid('cxsjkxxGrid');
            grid.insertData(null, cxsjkxxStore);
            //设置承销商投标不足信息
            var tbbzStore = action.result.data.tbbzList;
            var grid = DSYGrid.getGrid('tbbzGrid');
            grid.insertData(null, tbbzStore);
            //承销商为投标信息
            var wtbxxStore = action.result.data.wtbxxList;
            var grid = DSYGrid.getGrid('wtbxxGrid');
            grid.insertData(null, wtbxxStore);
            //最低成效额不足
            var zdcxeStore = action.result.data.zdcxeList;
            var grid = DSYGrid.getGrid('zdcxeGrid');
            grid.insertData(null, zdcxeStore);
            //债券托管信息
            var tgxxStore = action.result.data.tgxxList;
            var grid = DSYGrid.getGrid('tgxxGrid');
            grid.insertData(null, tgxxStore);
            //兑付计划页签
            var dfjhStore = action.result.data.dfjhList;
            var grid = DSYGrid.getGrid('dfjhGrid');
            grid.insertData(null, dfjhStore);
            //建设项目页签
            if(IS_BZB == '1' || IS_BZB == '2'){
                var jsxmStore = action.result.data.jsxmList;
                var grid = DSYGrid.getGrid('jsxmGrid');
                grid.insertData(null, jsxmStore);
            }
            //兑付计划页签
            var dqzqGrid = action.result.data.dqzqList;
            var grid = DSYGrid.getGrid('dqzq_grid');
            grid.getStore().removeAll();
            grid.insertData(null, dqzqGrid);
            //设置承销团表格
//            var tbxxStore = action.result.data.tbxxList;
//            var grid = DSYGrid.getGrid('tbxxGrid');
//            grid.insertData(null, tbxxStore);
            //设置承销团表格
//            var cxjkStore = action.result.data.cxjkList;
//            var grid = DSYGrid.getGrid('cxjkGrid');
//            grid.insertData(null, cxjkStore);
        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });
}

/**
 * 加载页面数据
 * @param form
 */
function loadTbxx(form) {
    form.load({
        url: 'getTbxxByCXT.action?ZQ_BILL_ID=' + ZQ_BILL_ID,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            //设置承销团表格
            var tbxxStore = action.result.data.tbxxList;
            var grid = DSYGrid.getGrid('tbxxGrid');
            grid.getStore().removeAll();
            grid.insertData(null, tbxxStore);

        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });
}
/**
 * 加载页面数据
 * @param form
 */
function loadCxjk(form) {
    form.load({
        url: 'getTbxxByCXT.action?ZQ_BILL_ID=' + ZQ_BILL_ID,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            //设置承销团表格
            var cxjkStore = action.result.data.tbxxList;
            var grid = DSYGrid.getGrid('cxjkGrid');
            grid.getStore().removeAll();
            grid.insertData(null, cxjkStore);

        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });
}

/**
 * 初始化债权发行管理填报弹出窗口中的承销团信息标签页
 */
function cxtxxTab(node_code) {

    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: 388,
        itemId: 'cxtForm',
        //autoScroll: true,
        layout: 'fit',
        scrollable: true,
        border: false,
        padding: '2 2 2 2',
        items: [init_jgxx_grid(node_code)],
        tbar: [
            {
                xtype: "combobox",
                name: "CXT_ID",
                store: DebtEleStoreTable('DEBT_V_ZQGL_CXT'),
                displayField: "name",
                valueField: "id",
                width: 350,
                labelWidth: 50,
                fieldLabel: '承销团',
                editable: false, //禁用编辑
                listConfig: {
                    minWidth: 400,
                    resizable: true
                },
                listeners: {
                    'afterrender': function () {
                        var form = this.up('form').getForm();
                        if (node_code == 2) {
                            var CXT_ID = form.findField('CXT_ID');
                            CXT_ID.setReadOnly(true);
                            CXT_ID.setFieldStyle('background:#E6E6E6');
                        }
                    },
                    'select': function () {
                        refresh_jgxxGrid();
                    }
                }
            }
        ]
    });
}

function dfjhTab(node_code,onlyShow) {
    var headerJson = [
        {xtype: 'rownumberer', width: 60,
            summaryRenderer: function () {
                return '合计';
            }},
        {dataIndex: "ZQCHJH_ID", type: "string", text: "偿还计划Id", width: 150,hidden:true},
        {dataIndex: "ZQ_ID", type: "string", text: "债券Id", width: 150,hidden:true},
        {dataIndex: "ZQQX_ID", type: "string", text: "期限", width: 150,hidden:true},
        {
            dataIndex: "DF_END_DATE", type: "string", text: "兑付日期", width: 150,
            editor:{
                xtype: "datefield",
                format: 'Y-m-d',
                allowBlank: false,
                readOnly:false,
                blankText: '请选择兑付日期',
                emptyText: '请选择兑付日期',
                editable:false,
                listeners: {
                    'change': function (self, newValue, oldValue) {
                    }
                },

            },
            renderer: function (value, metaData, record) {
                var dateStr = Ext.util.Format.date(value, 'Y-m-d');
                return dateStr;
            }
        },
        {dataIndex: "PLAN_AMT", type: "float", text: "兑付金额(万元)", width: 150,
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
        },
        {dataIndex: "PLAN_XZ_AMT", type: "float", text: "新增债券(万元)", width: 150,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0, decimalPrecision : 4},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
        },
        {dataIndex: "PLAN_ZH_AMT", type: "float", text: "置换债券(万元)", width: 150,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0, decimalPrecision : 4},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
        },

        {dataIndex: "PLAN_ZRZ_AMT", type: "float", text: "再融资债券(万元)", width: 150,hidden: true,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0, decimalPrecision : 4},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
        },
        {dataIndex: "CH_DQZQ_AMT", type: "float", text: "偿还到期债券(万元)", width: 150,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0, decimalPrecision : 4},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
        },
        {dataIndex: "CH_CLZW_AMT", type: "float", text: "偿还存量债务(万元)", width: 150,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0, decimalPrecision : 4},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'dfjhGrid',
        border: false,
        flex: 1,
        data: [],
        tbar:[
            {
                xtype: 'button',
                text: '自动生成',
                id: 'autoCreate',
                width: 80,
                hidden: node_code == 1 && !onlyShow ? false : true, // 当前功能必须是 债券注册且不是预览模式
                handler: function (btn) {
                    // 根据 发行日期 债券期限 付息方式(一次还本)  发行金额 自动生成兑付计划
                    var jbxxForm = Ext.ComponentQuery.query('form#jbxxForm')[0]; // 获取债券基本信息form属性
                    var fx_xz_amt = jbxxForm.getForm().findField('XZ_AMT').getValue(); // 新增发行额
                    var fx_zh_amt = jbxxForm.getForm().findField('ZH_AMT').getValue(); // 置换发行额
                    var fx_hb_amt = jbxxForm.getForm().findField('HB_AMT').getValue(); // 再融资发行额
                    var fx_ch_dqzq_amt = jbxxForm.getForm().findField('CH_DQZQ_AMT').getValue();
                    var fx_ch_clzw_amt = jbxxForm.getForm().findField('CH_CLZW_AMT').getValue();

                    /*// 债券新增发行额、置换发行额、再融资发行额至少填写一项
                    if (fx_xz_amt <= 0 && fx_zh_amt <= 0 && fx_hb_amt <= 0) {
                        Ext.MessageBox.alert('提示', '请至少填写新增/置换/再融资发行金额!');
                        Ext.ComponentQuery.query('panel[itemId="main_tab"]')[0].items.get(0).show();
                        return false;
                    }*/

                    var grid = btn.up('grid');// 获取兑付计划页签的属性
                    var store = grid.getStore(); // 获取兑付计划页签中store数据
                    var chjhData = [];
                    if (HBFS_ID != null && HBFS_ID !=  "" && HBFS_ID != undefined && HBFS_ID == '02') { // 偿还方式为“02 分期兑付”则根据债券期限每一年生成一笔兑付计划
                        var qx_date = format(jbxxForm.getForm().findField('QX_DATE', 'y-m-d').value, 'yyyy-MM-dd'); // 起息日期
                        var zqqx = jbxxForm.getForm().findField('ZQ_BILL_QX').getValue(); // 债券期限
                        if (!zqqx) { // 判断主债券期限是否填写
                            Ext.MessageBox.alert('提示', '请填写“期限”后，再进行此操作!');
                            Ext.ComponentQuery.query('panel[itemId="main_tab"]')[0].items.get(0).show();
                            return false;
                        }
                        if (!qx_date) { // 判断是否填写了起息日期
                            Ext.MessageBox.alert('提示', '请填写“起息日”后，再进行此操作!');
                            Ext.ComponentQuery.query('panel[itemId="main_tab"]')[0].items.get(0).show();
                            return false;
                        }
                        var total_plan_amt = 0;
                        var total_plan_xz_amt = 0;
                        var total_plan_zh_amt = 0;
                        var total_plan_zrz_amt = 0;
                        var total_ch_dqzq_amt = 0;
                        var total_ch_clzw_amt = 0;
                        for (var i = 1; i <= parseInt(zqqx); i ++) {
                            var chjhMap = {};
                            var qx_year = (parseInt(qx_date.substr(0, 4))+ i).toString();
                            var df_date = qx_year + "-" + qx_date.substr(5, 2) + "-" + qx_date.substr(8, 2);
                            var zqchjh_id = GUID.createGUID(); // 初始化偿还计划ID
                            chjhMap.ZQCHJH_ID =  zqchjh_id;
                            chjhMap.ZQ_ID = zqchjh_id;
                            chjhMap.DF_END_DATE = df_date;
                            if(i == parseInt(zqqx) ){
                                chjhMap.PLAN_AMT = (fx_xz_amt+ fx_zh_amt+fx_hb_amt) * 10000 - total_plan_amt;
                                chjhMap.PLAN_XZ_AMT = fx_xz_amt * 10000 - total_plan_xz_amt ;
                                chjhMap.PLAN_ZH_AMT = fx_zh_amt * 10000 - total_plan_zh_amt;
                                chjhMap.PLAN_ZRZ_AMT = fx_hb_amt * 10000 - total_plan_zrz_amt;
                                chjhMap.CH_DQZQ_AMT = fx_ch_dqzq_amt * 10000 - total_ch_dqzq_amt;
                                chjhMap.CH_CLZW_AMT = fx_ch_clzw_amt * 10000 - total_ch_clzw_amt;
                            }else{
                                // chjhMap.PLAN_AMT = (fx_xz_amt+ fx_zh_amt+fx_hb_amt) * 10000 / parseInt(zqqx);
                                // chjhMap.PLAN_XZ_AMT = fx_xz_amt * 10000 / parseInt(zqqx) ;
                                // chjhMap.PLAN_ZH_AMT = fx_zh_amt * 10000 / parseInt(zqqx);
                                // chjhMap.PLAN_ZRZ_AMT = fx_hb_amt * 10000 / parseInt(zqqx);
                                chjhMap.PLAN_AMT = Math.round((fx_xz_amt+ fx_zh_amt+fx_hb_amt) * 10000 / parseInt(zqqx)*100)/100;
                                chjhMap.PLAN_XZ_AMT = Math.round(fx_xz_amt * 10000 / parseInt(zqqx)*100)/100 ;
                                chjhMap.PLAN_ZH_AMT = Math.round(fx_zh_amt * 10000 / parseInt(zqqx)*100)/100;
                                chjhMap.PLAN_ZRZ_AMT = Math.round(fx_hb_amt * 10000 / parseInt(zqqx)*100)/100;
                                chjhMap.CH_DQZQ_AMT = Math.round(fx_ch_dqzq_amt * 10000 / parseInt(zqqx)*100)/100;
                                chjhMap.CH_CLZW_AMT = Math.round(fx_ch_clzw_amt * 10000 / parseInt(zqqx)*100)/100;
                                total_plan_amt+=Math.round((fx_xz_amt+ fx_zh_amt+fx_hb_amt) * 10000 / parseInt(zqqx)*100)/100;
                                total_plan_xz_amt+=Math.round(fx_xz_amt * 10000 / parseInt(zqqx)*100)/100;
                                total_plan_zh_amt+=Math.round(fx_zh_amt * 10000 / parseInt(zqqx)*100)/100 ;
                                total_plan_zrz_amt+=Math.round(fx_hb_amt * 10000 / parseInt(zqqx)*100)/100;
                                total_ch_dqzq_amt+=Math.round(fx_ch_dqzq_amt * 10000 / parseInt(zqqx)*100)/100;
                                total_ch_clzw_amt+=Math.round(fx_ch_clzw_amt * 10000 / parseInt(zqqx)*100)/100;
                            }
                            chjhData.push(chjhMap);
                        }
                    } else { // 偿还方式为“分期兑付”则一年生成一条兑付计划
                        var dqdf_date = format(jbxxForm.getForm().findField('DQDF_DATE', 'y-m-d').value, 'yyyy-MM-dd'); // 到期兑付日期
                        if (!dqdf_date) { // 判断是否填写了起息日期
                            Ext.MessageBox.alert('提示', '请填写“到期兑付日”后，再进行此操作!');
                            Ext.ComponentQuery.query('panel[itemId="main_tab"]')[0].items.get(0).show();
                            return false;
                        }
                        var chjhMap = {};
                        var zqchjh_id = GUID.createGUID(); // 初始化偿还计划ID
                        chjhMap.ZQCHJH_ID =  zqchjh_id;
                        chjhMap.ZQ_ID = zqchjh_id;
                        chjhMap.DF_END_DATE = dqdf_date;
                        chjhMap.PLAN_AMT = (fx_xz_amt+ fx_zh_amt+fx_hb_amt) * 10000;
                        chjhMap.PLAN_XZ_AMT = fx_xz_amt * 10000 ;
                        chjhMap.PLAN_ZH_AMT = fx_zh_amt * 10000 ;
                        chjhMap.PLAN_ZRZ_AMT = fx_hb_amt * 10000 ;
                        chjhMap.CH_DQZQ_AMT = fx_ch_dqzq_amt * 10000;
                        chjhMap.CH_CLZW_AMT = fx_ch_clzw_amt * 10000;
                        chjhData.push(chjhMap);
                    }
                    store.removeAll();
                    grid.insertData(null, chjhData);
                }
            },
            {
                xtype: 'button',
                text: '增加',
                id: 'dfjhAdd',
                width: 80,
                disabled:node_code ==1 && !onlyShow ?false:true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var lenght_temp=store.data.length;
                    //偿还计划表按照兑付计划信息将债券分为多笔，每笔兑付计划对应一笔债券，兑付计划id可与zq_id取同值
                    var data_id="";
                    $.post("/getId.action", function (data) {
                        data=$.parseJSON(data);
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        data_id = data.data[0];
                        //设置ZQCHJH_ID，ZQ_ID，兑付日期默认值，设置ZQCHJH_ID值同ZQ_ID
                        // 兑付计划栏为空时，兑付日期默认值为基本信息页签兑付日期；
                        //兑付计划栏不为空，兑付日期默认值为上一栏兑付日期-1年
                        var dqdf_date='';
                        var qx_year='';
                        if(lenght_temp<=0){
                            var jbxxForm = Ext.ComponentQuery.query('form#jbxxForm')[0];
                            dqdf_date=jbxxForm.getForm().findField('DQDF_DATE','y-m-d').value;
                            dqdf_date=format(dqdf_date, 'yyyy-MM-dd');
                            qx_year=(parseInt(dqdf_date.substr(0,4))).toString();
                        }else{
                            var record = store.data.items[lenght_temp-1];
                            dqdf_date=record.data.DF_END_DATE;
                            dqdf_date=format(dqdf_date, 'yyyy-MM-dd');
                            qx_year=(parseInt(dqdf_date.substr(0,4))-1).toString();
                        }
                        var qx_date=qx_year+"-"+dqdf_date.substr(5,2)+"-"+dqdf_date.substr(8,2);
                        grid.insertData(null, {
                            ZQCHJH_ID:data_id,
                            ZQ_ID:data_id,
                            DF_END_DATE:qx_date
                        });
                    });

                }
            },
            {
                xtype: 'button',
                text: '删除',
                itemId: 'dfjhDel',
                width: 80,
                margin: '0 20 0 0',
                disabled:true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            }

        ],
        autoScroll: true,
        checkBox: true,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'dfjhCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                        //双击查看或者中标登记/债务确认节点，兑付计划页签不可更改
                        if(onlyShow || node_code!=1)
                        {
                            return false;
                        }
                    },
                    'validateedit': function (editor, context) {
                        if(context.field == 'DF_END_DATE') {
                            checkDfdate(format(context.value,'yyyy-MM-dd'));
                        }

                    },
                    'edit': function (editor, context) {
                        if (context.field == 'PLAN_XZ_AMT' || context.field == 'PLAN_ZH_AMT' || context.field == 'PLAN_ZRZ_AMT'
                            || context.field == 'CH_DQZQ_AMT' || context.field == 'CH_CLZW_AMT' ) {
                            var plan_xz_amt = context.record.get("PLAN_XZ_AMT");
                            var plan_zh_amt = context.record.get("PLAN_ZH_AMT");
                            var ch_dqzq_amt = context.record.get("CH_DQZQ_AMT");
                            var ch_clzw_amt = context.record.get("CH_CLZW_AMT");
                            var total_amt = new Object(plan_xz_amt + plan_zh_amt + ch_dqzq_amt + ch_clzw_amt);
                            var total_zrz_amt = new Object(ch_dqzq_amt + ch_clzw_amt);
                            context.record.set('PLAN_AMT', total_amt);
                            context.record.set('PLAN_ZRZ_AMT', total_zrz_amt);
                        }
                    }
                }
            }
        ]

    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    grid.on('selectionchange', function (view, records) {
        if(node_code ==1 && !onlyShow){
            grid.down('#dfjhDel').setDisabled(!records.length);
        }
    });
    return grid;
}
function jsxmTab(node_code,onlyShow,ydjh_id) {
    var headerJson = [
        {
            xtype: 'rownumberer',
            width: 40,
            summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "ZQXM_ID", type: "string", text: "债券项目ID", width: 200,hidden:true
        },
        {dataIndex: 'YDJH_ID', text: "月度计划ID", type: "string", hidden: true},
        {dataIndex: 'ZQCHJH_ID', text: "偿还计划ID", type: "string", hidden: true},
        {dataIndex: 'ZQ_ID', text: "债券ID", type: "string", hidden: true},
        {
            text: "兑付日期",
            dataIndex: "DF_END_DATE",
            type: "string",
            width: 150,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                allowBlank: false,
                editable:false,
                store: dfjh_ids_store
            },
            renderer: function (value) {
                if (dfjh_ids != []) {
                    var record = dfjh_ids_store.findRecord('id', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            }
        },
        {
            dataIndex: 'SRKM_ID',
            text: "政府性基金收入科目",
            type: "string",
            width: 150,
            hidden: IS_CREATE_FKMDFJH == '1' ? false : true,
            editor: {
                xtype: 'treecombobox',
                store: zfxsrkm_store,
                displayField: 'name',
                valueField: 'code',
                selectModel:"leaf", // 选择叶子节点才有效
                allowBlank: false,
                editable: false
            },
            renderer: function (value, cell, record) {
                // 根据code获取name渲染到grid上
                var resultMap = zfxsrkm_store.findNode('code', value, true, true, true);
                return resultMap != null ? resultMap.get('name') : value;
            }
        },
        {dataIndex: "FX_AMT", type: "float", text: "发行金额(万元)", width: 150,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
        },
        {dataIndex: "ZX_ZBJ_AMT", type: "float", text: "专项债用作资本金(万元)", width: 180,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0, decimalPrecision : 4},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
        },
        {dataIndex: "XZCZAP_AMT", type: "float", text: "其中:新增赤字(万元)", width: 180,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0, decimalPrecision : 4},
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000##');
            },
        },
        // {
        //     dataIndex: "DF_END_DATE", type: "string", text: "兑付日期", width: 150,
        //     editor:{
        //         xtype: "datefield",  allowBlank: false,
        //         format: 'Y-m-d',
        //         blankText: '请选择兑付日期',
        //         emptyText: '请选择兑付日期',
        //         editable:true,
        //         listeners: {
        //             'change': function (self, newValue, oldValue) {
        //             }
        //         }
        //     },
        //     renderer: function (value, metaData, record) {
        //         var dateStr = Ext.util.Format.date(value, 'Y-m-d');
        //         return dateStr;
        //     }
        //
        // },
        {
            dataIndex: "AD_NAME", type: "string", text: "地区", width: 200,readOnly:true,
        },
        {
            dataIndex: "AG_NAME", type: "string", text: "项目单位", width: 200,readOnly:true
        },
        {
            dataIndex: "XM_ID", type: "string", text: "项目ID", width: 200,readOnly:true,hidden:true
        },
        {
            dataIndex: "XM_CODE", type: "string", text: "项目编码", width: 200,readOnly:true
        },
        {
            dataIndex: "XM_NAME", type: "string", text: "项目名称", width: 200,readOnly:true
        },
        {
            dataIndex: "XMLX_NAME", type: "string", text: "项目类型", width: 150,readOnly:true
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'jsxmGrid',
        border: false,
        flex: 1,
        data: [],
        tbar:[
            {
                xtype: 'button',
                text: '拆分',
                id: 'jsxmCreate',
                disabled: true,
                width: 80,
                handler: function (btn){
                    var dfjhStore = DSYGrid.getGrid('dfjhGrid').getStore().getData();
                    if (dfjhStore.getCount() <= 0) {
                        Ext.MessageBox.alert('提示', '请生成至少一笔兑付计划后，再进行此操作！');
                        return;
                    }
                    var jsxmGrid = btn.up('grid');
                    var jsxmRecord = jsxmGrid.getSelectionModel().getSelection();
                    if (jsxmRecord.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一笔建设项目后，再进行此操作！');
                        return;
                    }
                    //windows弹出框：展示兑付计划数据和生成比例  发行金额*比例 = 初始化每一条的生成金额
                    Ext.create('Ext.window.Window', {
                        title: '项目资金发行比例', // 窗口标题
                        width: document.body.clientWidth * 0.4, //自适应窗口宽度
                        height: document.body.clientHeight * 0.6, //自适应窗口高度
                        itemId: 'window_itemId_xmzjfxbl', // 窗口标识
                        layout: 'fit',
                        maximizable: true, //最大化按钮
                        buttonAlign: 'right', // 按钮显示的位置
                        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
                        closeAction: 'destroy', //hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
                        items: [initWindow_xmzjfp_grid()],
                        buttons: [
                            {
                                text: '确认',
                                handler: function (btn) {
                                    var zjfpStore = btn.up('window').down('grid').getStore(); // 发行比例
                                    var records = [];
                                    if (zjfpStore.sum('FXBL') != 100) {
                                        Ext.MessageBox.alert('提示', '发行比例合计总值不等于100%！');
                                        return;
                                    }
                                    var success = false;
                                    jsxmRecord.forEach(function(record){ // 选择建设项目
                                        var data = record.data;
                                        var fx_amt = data.FX_AMT;
                                        var zx_zbj_amt = data.ZX_ZBJ_AMT;
                                        for (var i = 0; i < zjfpStore.getCount(); i++) { // 生成兑付计划
                                            var zjfpRecord = zjfpStore.getAt(i);
                                            var fxbl = zjfpRecord.get('FXBL');
                                            if(fxbl==0.00){
                                                Ext.MessageBox.alert('提示', '发行比例不能为0');
                                                success = true;
                                                return
                                            }
                                            data = Ext.clone(data);
                                            data.FX_AMT = fx_amt * fxbl / 100;//根据比例拆分金额
                                            data.ZX_ZBJ_AMT = zx_zbj_amt * fxbl / 100;//根据比例拆分金额
                                            data.DF_END_DATE = zjfpRecord.get('DF_END_DATE');
                                            data.id  = GUID.createGUID();
                                            records.push(data);
                                        }
                                    });
                                    if (success) {
                                        return;
                                    }
                                    jsxmGrid.getStore().remove(jsxmRecord);
                                    jsxmGrid.insertData(null,records);
                                    btn.up('window').close();
                                }
                            },
                            {
                                text: '取消',
                                handler: function (btn) {
                                    btn.up('window').close();
                                }
                            }
                        ]
                    }).show();
                    function initWindow_xmzjfp_grid() {
                        var headerJson = [
                            {xtype: 'rownumberer', width: 60,
                                summaryRenderer: function () {
                                    return '合计';
                                }},
                            {dataIndex: "ZQCHJH_ID", type: "string", text: "偿还计划Id", width: 150,hidden:true},
                            {dataIndex: "ZQ_ID", type: "string", text: "债券Id", width: 150,hidden:true},
                            {dataIndex: "DF_END_DATE", type: "string", text: "兑付日期", width: 100,
                                renderer: function (value) {
                                    var dateStr = Ext.util.Format.date(value, 'Y-m-d');
                                    return dateStr;
                                }},
                            {dataIndex: "FXBL", type: "float", text: "发行比例%", width: 100,
                                editor: {
                                    xtype: "numberFieldFormat",
                                    minValue: 0,
                                    maxValue:100,
                                    emptyText: '0.00',
                                    allowDecimals: true,
                                    decimalPrecision: 2,
                                    hideTrigger: true,
                                    keyNavEnabled: true,
                                    mouseWheelEnabled: false,
                                    allowBlank: false
                                },
                                summaryType: 'sum',
                                summaryRenderer: function (value) {
                                    return Ext.util.Format.number(value, '0,000.00');
                                }
                            }
                        ];
                        var grid =  DSYGrid.createGrid({
                            itemId: 'grid_itemId_xmzjfp',
                            flex: 1,
                            data: [],
                            border: false,
                            autoScroll: true,
                            checkBox: false,
                            headerConfig: {
                                headerJson: headerJson,
                                columnAutoWidth: false
                            },
                            pageConfig: {
                                enablePage: false
                            },
                            features: [{
                                ftype: 'summary'
                            }],
                            plugins: [
                                {
                                    ptype: 'cellediting',
                                    clicksToEdit: 1,
                                    pluginId: 'zjfpCellEdit',
                                    clicksToMoveEditor: 1,
                                    listeners: {
                                        'edit': function (editor, context) {

                                        }
                                    }
                                }
                            ]
                        });
                        var dfjhData = [];
                        for(var i=0;i<dfjhStore.getCount();i++){
                            var record=dfjhStore.getAt(i);
                            dfjhData.push(record.data);
                        }
                        grid.insertData(null, dfjhData);
                        return grid;
                    }
                }
            },
            {
                xtype: 'button',
                text: '删除',
                itemId: 'jsxmDel',
                width: 80,
                margin: '0 20 0 0',
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            },
            {
                xtype: 'button',
                text: '增补',
                id: 'jsxmAdd',
                disabled: node_code ==1 && !onlyShow ?false:true,
                width: 80,
                handler: function (btn) {
                    //根据月度发行计划选择项目
                    initWindow_jsxm(ydjh_id);
                }
            }
        ],
        autoScroll: true,
        checkBox: true,
        enableLocking:false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'jsxmCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                        if(context.field == 'XZCZAP_AMT' && Ext.ComponentQuery.query('form#jbxxForm')[0].getForm().findField('ZQLB_ID').value != '01'){
                            return false;
                        }
                        if(context.field == 'ZX_ZBJ_AMT' && Ext.ComponentQuery.query('form#jbxxForm')[0].getForm().findField('ZQLB_ID').value == '01'){
                            return false;
                        }
                        if(context.field == 'DF_END_DATE'){
                            // 获取 兑付计划中的兑付日期 创建一个下拉列表 提供给建设项目中的兑付日期使用
                            var dfjhStore = DSYGrid.getGrid('dfjhGrid').getStore();
                            var arr = new Array();
                            for(var i = 0; i< dfjhStore.getCount();i++){
                                var map = {};
                                var df_end_date = Ext.util.Format.date(dfjhStore.getAt(i).get('DF_END_DATE'), 'Y-m-d');
                                map.id = df_end_date;
                                map.name = df_end_date;
                                arr.push(map);
                            }
                            dfjh_ids = arr;
                            dfjh_ids_store = DebtEleStore(dfjh_ids,'Y-m-d');
                            DSYGrid.getGrid('jsxmGrid').columns[5].getEditor().setStore(dfjh_ids_store);
                        }
                        //双击查看或者中标登记/债务确认节点，建设项目页签不可更改
                        if(onlyShow || node_code!=1)
                        {
                            return false;
                        }
                    },
                    'validateedit': function (editor, context) {

                    },
                    'edit': function (editor, context) {
                        if(context.field == 'FX_AMT'&& (
                            parseFloat(Ext.util.Format.number(context.record.get("ZX_ZBJ_AMT"), '00000000.00'))
                            ) > Ext.util.Format.number(context.value, '00000000.00')){
                            Ext.MessageBox.alert('提示', '专项债用作资本金不能超过发行金额');
                            context.record.set('FX_AMT',context.originalValue);
                            return;
                        }
                        if(context.field == 'ZX_ZBJ_AMT'&& (
                                parseFloat(Ext.util.Format.number(context.value, '00000000.00'))) >
                            parseFloat(Ext.util.Format.number(context.record.get("FX_AMT"), '00000000.00'))
                             ){
                            Ext.MessageBox.alert('提示', '专项债用作资本金不能超过发行金额');
                            context.record.set('ZX_ZBJ_AMT',0);
                        }
                        if(context.field == 'FX_AMT'&& (parseFloat(Ext.util.Format.number(context.record.get("XZCZAP_AMT"), '00000000.00'))) >
                            parseFloat(Ext.util.Format.number(context.value, '00000000.00'))){
                            Ext.MessageBox.alert('提示', '其中:新增赤字不能超过发行金额');
                            context.record.set('FX_AMT',context.originalValue);
                            return;
                        }
                        if(context.field == 'XZCZAP_AMT'&& (parseFloat(Ext.util.Format.number(context.value, '00000000.00'))
                             >  parseFloat(Ext.util.Format.number(context.record.get("FX_AMT"), '00000000.00')) )){
                            Ext.MessageBox.alert('提示', '其中:新增赤字不能超过发行金额');
                            context.record.set('XZCZAP_AMT',0);
                        }
                    }
                }
            }
        ],
        listeners: {
            select:function(rowModel,record){

            }
        }
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    grid.on('selectionchange', function (view, records) {
        if(node_code ==1 && !onlyShow){
            grid.down('#jsxmDel').setDisabled(!records.length);
            grid.down('#jsxmCreate').setDisabled(!records.length);
        }
    });
    return grid;
}

function initWindow_jsxm(ydjh_id) {
    var ydjh_window= Ext.create('Ext.window.Window', {
        title: '建设项目选择', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.9, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_ydjh', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [initWindow_jsxm_grid(ydjh_id)],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    var grid = DSYGrid.getGrid('jsxmChooseGrid');
                    var count = grid.getSelectionModel().getCount();
                    var records = grid.getSelection();
                    /*if(count == 1){
                        var ydjh_dtl_id = records[0].get("YDJH_DTL_ID");
                        loadJsxmxz(ydjh_id,ydjh_dtl_id);
                    }else{*/
                    for(var i=0;i<count;i++){
                        ydjh_dtl_id = records[i].get("YDJH_DTL_ID");
                        xm_id = records[i].get("XM_ID");
                        loadJsxmxz(ydjh_id,ydjh_dtl_id,xm_id);
                    }
                    /*}*/
                    ydjh_window.close();

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
    ydjh_window.show();
}
/**
 * 20210330liyue
 * 加载到期债券页签
 */
function dqzqTab(node_code,onlyShow,ydjh_id) {
    var Json = [
        {
            text: "再融资债券明细ID",
            class: "ty",
            dataIndex: "YDJH_HZ_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "再融资债券明细ID",
            class: "ty",
            dataIndex: "DATA_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "债券ID",
            class: "ty",
            dataIndex: "ZQ_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "区划CODE",
            class: "ty",
            dataIndex: "AD_CODE",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "债券/债务名称",
            class: "ty",
            dataIndex: "ZQ_NAME",
            width: 250,
            type: "string",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit',
            renderer: function (data, cell, record) {
                if (record.get('DATA_TYPE') == 'ZW') {
                    var url = '/page/debt/common/zwyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "zw_id";
                    paramNames[1] = "zwlb_id";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('ZQ_ID'));
                    paramValues[1] = encodeURIComponent(record.get('ZWLB_ID'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('ZQ_ID');
                    paramValues[1] = AD_CODE;
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            }
        },
        {
            text: "再融资申请总金额（万元）",
            class: "xmxz",
            dataIndex: "SQ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            fieldStyle: 'background:#E6E6E6',
            editor: {
                xtype: "numberFieldFormat",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                minValue: 0,
                allowBlank: false
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                SUM_SQ_AMT=value
                return Ext.util.Format.number(value, '0,000.00');
            },

        },
        {
            text: "剩余可申请金额（万元）",
            class: "xmxz",
            dataIndex: "SYSQ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "剩余可申请金额（万元）",
            class: "xmxz",
            dataIndex: "SY_AMT",
            hidden:true
        },
        {
            text: "到期日期",
            class: "ty",
            dataIndex: "DQDF_DATE",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "到期金额",
            class: "ty",
            dataIndex: "DQ_AMT",
            width: 200,
            type: "float",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit',
            // summaryType: 'sum',summaryR
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            text: "期限ID",
            class: "ty",
            dataIndex: "ZQQX_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "期限",
            class: "xmxz",
            dataIndex: "ZQQX_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "债券/债务类型ID",
            class: "ty",
            dataIndex: "ZQLB_ID",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: true,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "债券/债务类型",
            class: "ty",
            dataIndex: "ZQLB_NAME",
            width: 150,
            type: "string",
            fontSize: "15px",
            hidden: false,
            editable: false,
            tdCls: 'grid-cell-unedit'
        },
        {
            text: "申报批次",
            class: "ty",
            dataIndex: "BATCH_NO",
            width: 150,
            type: "string",
            fontSize: "15px",
            tdCls: 'grid-cell-unedit',
            hidden: true
        },
        {
            text: "申报批次",
            class: "ty",
            dataIndex: "BATCH_NAME",
            width: 200,
            type: "string",
            fontSize: "15px",
            tdCls: 'grid-cell-unedit',
            hidden: false
        },
        {
            text: "备注", dataIndex: "REMARK", width: 300, type: "string", fontSize: "15px", hidden: false,
            editor: {
                xtype: 'textfield',
                allowBlank: false
            }
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'dqzq_grid',
        flex: 1,
        headerConfig: {
            headerJson: Json,
            columnAutoWidth: false
        },
        autoLoad: true,
        checkBox: (IS_ZXZQXT_FX == 1 || IS_ZXZQXT_FX == 2 ) && is_zxzqfb == 1 ? false : true,
        border: false,
        scrollable: true,
        height: '100%',
        pageConfig: {
            enablePage: false,
            pageNum: false
        },
        params: {
            YDJH_ID:ydjh_id,
            button_name:button_name
        },
        features: [{
            ftype: 'summary'
        }],
        dataUrl: 'getDqzqByYdjh.action',
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'jxhj_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {}
            }
        ],
        listeners: {
            'edit': function (editor, context) {
               /* var xzzqStore = grid.getStore();
                if (context.field == 'SQ_AMT') {
                    var zrzStore = grid.getStore();
                    var sy_amt=zrzStore.data.items[0].data.SY_AMT;//原有剩余的金额
                     SYSQ_AMT=sy_amt-zrzStore.data.items[0].data.SQ_AMT;
                     context.record.set('SYSQ_AMT', SYSQ_AMT);
                }*/
            }
        }
    });
 /*   //加载时将剩余可申请金额与申请金额做计算
    grid.getStore().on('load', function (self, records, successful) {
        if (records != null) {
            for (var i = 0; i < records.length; i++) {
                var sy_amt= records[i].data.SY_AMT;//原有剩余的金额
                var SYSQ_AMT=sy_amt- records[i].data.SQ_AMT;
                records[i].set('SYSQ_AMT', SYSQ_AMT);

            }
        }
    });*/
    return grid;
}

function loadJsxmxz(ydjh_id,ydjh_dtl_id,xm_id) {
    var form = Ext.ComponentQuery.query('form[itemId="jbxxForm"]')[0];
    form.load({
        url: 'loadZqxx.action?ydjh_id=' + ydjh_id + '&ydjh_dtl_id='+ydjh_dtl_id+ '&xm_id='+xm_id,
        //waitTitle: '请等待',
        //waitMsg: '正在加载中...',
        success: function (form_success, action) {
            //form.getForm().setValues(action.result.data.list);
            var jsxmGrid = DSYGrid.getGrid('jsxmGrid');
            var list = action.result.data.jsxmList;
            //zhanghl 20200916 选择增补项目时 将申请金额带出到建设项目页签的发行金额
            // for(var i in list){
            //     list[i].FX_AMT = 0.00;
            // }
            jsxmGrid.insertData(null, action.result.data.jsxmList);
            //Ext.ComponentQuery.query('combobox[name="ZQ_PC_ID"]')[0].setValue(action.result.data.list.PCJH_ID);
        },
        failure: function (form_failure, action) {
            Ext.MessageBox.alert('提示', '查询' + '失败！' + action.result.message);
            return;
        }
    });
}

function initWindow_jsxm_grid(ydjh_id) {
    //申请填报的主单
    var headerjson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count'
        },
        {
            dataIndex: "YDJH_DTL_ID", type: "string", text: "月度计划id", width: 200,hidden:true
        },
        {
            dataIndex: 'YDJH_ID', type: "string", text: "月度计划id", hidden:true
        },
        {dataIndex: 'ZQCHJH_ID', text: "偿还计划ID", type: "string", hidden: true},
        {dataIndex: 'ZQ_ID', text: "债券ID", type: "string", hidden: true},
        {dataIndex: 'AD_NAME', text: "地区", type: "string", width: 100},
        {dataIndex: 'AG_NAME', text: "项目单位", type: "string", width: 230},
        {dataIndex: 'XM_CODE', text: "项目编码", type: "string", width: 150},
        {dataIndex: 'XM_NAME', text: "项目名称", type: "string", width: 200},
        {dataIndex: 'XMLX_NAME', text: "项目类型", type: "string", width: 100},
        {dataIndex: 'FX_AMT', text: "申请金额（万元）", type: "float", width: 180,align:'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'jsxmChooseGrid',
        headerConfig: {
            headerJson: headerjson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        checkBox: true,
        border: false,
        height: '80%',
        flex: 1,
        tbar: [
        ],
        params: {
            ydjh_id:ydjh_id
        },
        dataUrl: 'loadJsxm.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
            },
            'beforeedit': function (editor, context) {
                if (context.field == 'DF_END_DATE') {
                    // 获取 兑付计划中的兑付日期 创建一个下拉列表 提供给建设项目中的兑付日期使用
                    var dfjhStore = DSYGrid.getGrid('dfjhGrid').getStore();
                    var arr = new Array();
                    for (var i = 0; i < dfjhStore.getCount(); i++) {
                        var map = {};
                        var df_end_date = Ext.util.Format.date(dfjhStore.getAt(i).get('DF_END_DATE'), 'Y-m-d');
                        map.id = df_end_date;
                        map.name = df_end_date;
                        arr.push(map);
                    }
                    dfjh_ids = arr;
                    dfjh_ids_store = DebtEleStore(dfjh_ids);
                    DSYGrid.getGrid('jsxmGrid').columns[5].getEditor().setStore(dfjh_ids_store);
                }
            }
        }
    });
}

/**
 * 初始化债权发行管理填报弹出窗口中的承销团信息标签页中的表格
 */
function init_jgxx_grid(node_code) {
    var iHeight = document.body.clientHeight * 0.75;
    var jgxxStore = DebtEleTreeStoreDB('DEBT_CXJG');
    var headerJson = [
        {xtype: 'rownumberer',width: 35},
        {"dataIndex": "CXJG_NAME", "type": "string", "text": "机构名称", "width": 150, hidden: false},
        {
            "dataIndex": "CXJG_CODE", "type": "string", "text": "机构编码", "width": 200/*,
                editor: {
                    xtype: 'treecombobox',
                    displayField: 'name',
                    valueField: 'code',
                    rootVisible: false,
                    selectModel: 'leaf',
                    store: jgxxStore
                },
                renderer: function (value) {
                    var record = jgxxStore.findRecord('code', value, 0, false, true, true);
                    return record != null ? record.get('name') : value;
                }*/
        },
        {"dataIndex": "CXS_TGZH", "type": "string", "text": "中债登托管账号", "width": 150/*, editor: 'textfield'*/},
        {"dataIndex": "CXS_ZZDZH", "type": "string", "text": "中证登托管账号", "width": 150/*, editor: 'textfield'*/},
        {
            "dataIndex": "IS_LEADER", "type": "string", "text": "承销机构类型", "width": 150,/*
                editor: {
                    xtype: 'combobox',
                    displayField: 'name',
                    valueField: 'code',
                    store: DebtEleStore(json_zqgl_cxjglx),
                    editable: false
                },*/
            renderer: function (value) {
                var store = DebtEleStore(json_zqgl_cxjglx);
                var record = store.findRecord('code', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            "dataIndex": "CX_SCALE", "type": "float", "text": "承销比例（%）", "width": 150/*,
                editor: {
                    xtype: 'numberfield',
                    hideTrigger: true
                }*/,
            hidden: true
        },
        {"dataIndex": "ORG_ACCOUNT", "type": "string", "text": "收款账号", "width": 150/*, editor: 'textfield'*/},
        {"dataIndex": "ORG_ACC_NAME", "type": "string", "text": "收款账户名称", "width": 150/*, editor: 'textfield'*/},
        {"dataIndex": "ORG_ACC_BANK", "type": "string", "text": "收款账户银行", "width": 150/*, editor: 'textfield'*/}
    ];

    var simplyGrid = new DSYGridV2();
    var config = {
        itemId: 'jgxxGrid',
        border: true,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: 'getJgxxGrid.action',
        autoLoad: true,
        params: {
            CXT_ID: 'test'
        },
        height: iHeight,
        checkBox: true,
        pageConfig: {
            enablePage: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    'edit': function (editor, e) {
                        //e.record.commit();
                    },
                    'beforeedit': function () {
                        return true;   //用于判断是否有修改权限
                    }
                }
            }
        ]
    };
    var grid = simplyGrid.create(config);

    //将增加删除按钮添加到表格中
    grid.addDocked({
        xtype: 'toolbar',
        layout: 'column',
        items: [
            '->',
            {
                xtype: 'button',
                text: '添加',
                width: 60,
                itemId: 'add_editGrid',
                handler: function (btn) {
                    btn.up('grid').insertData(null, {});
                }
            },
            {
                xtype: 'button',
                text: '删除',
                itemId: 'delete_editGrid',
                width: 60,
                disabled: true,
                handler: function (btn) {
                    var rowEditing = btn.up('grid').getPlugin('rowedit');
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            }
        ]
    }, 0);
    grid.down('#add_editGrid').hide();
    grid.down('#delete_editGrid').hide();
    if (node_code == 2) {
        grid.on('beforeedit', function (editor, context) {
            return false;
        });
        grid.down('#add_editGrid').setVisible(false);
        grid.down('#delete_editGrid').setVisible(false);
    }
    grid.on('selectionchange', function (view, records) {
        grid.down('#delete_editGrid').setDisabled(!records.length);
    });
    grid.on('validateedit', function (editor, context) {
        if (context.field == 'CXJG_CODE') {
            var record = jgxxStore.findRecord('code', context.value, false, true, true);
            context.record.set('CXJG_NAME', record.get('name'));
        }
    });
    return grid;
}

function refresh_jgxxGrid() {
    cxt_id = Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].value;
    var store = DSYGrid.getGrid('jgxxGrid').getStore();
    //初始化表格Store参数
    store.getProxy().extraParams = {
        CXT_ID: cxt_id
    };
    //刷新表格内容
    store.loadPage(1);
}

/**
 * 初始化债权发行管理弹出窗口中的投标信息标签页
 */
function fxxxTab(edit_flag) {
    var config={
        width: '100%',
        height: '100%',
        layout: 'fit',
        border: false,
        padding: '2 2 2 2',
        items: [init_fxxx_panel()]
    };
    if(!edit_flag){
        config.tbar=[
            {
                xtype: 'filefield',
                buttonText: '导入',
                itemId:"uploady1",
                name: 'upload',
                width: 60,
                buttonOnly: true,
                hideLabel: true,
                hidden:true,
                buttonConfig: {
                    width: 60,
                    icon: '/image/sysbutton/report.png'
                },
                listeners: {
                    change: function (fb, v) {
                        var form = this.up('form').getForm();
                        uploadTbxxFile(form);
                    }
                }
            }
        ]
    }


    var panel = Ext.create('Ext.form.Panel', config);
    return panel;

}


function init_fxxx_panel() {
    var editorTab = Ext.create('Ext.tab.Panel', {
        width:'100%',
        height:'100%',
        border: false,
        itemId: 'zbxx_tab',
        padding: '2 2 2 2',
        items: [
            {
                title: '招标信息',
                autoScroll: true,
                //hidden:is_cxdj,
                items: fxxx_zhaobxxTab()
            },
            {
                title: '投标信息',
                layout:'fit',
                //hidden:is_cxdj,
                items: tbxxTab()
            },
            {
                title: '中标信息',
                layout:'fit',
                items: fxxx_zhongbxxTab()
            },
            {
                title: '承销商缴款信息',
                layout:'fit',
                //hidden:is_cxdj,
                items: cxjkTab()
            },
            {
                title: '承销商投标不足信息',
                layout:'fit',
                //hidden:is_cxdj,
                items: fxxx_tbbzTab()
            },
            {
                title: '承销商未投标信息',
                layout:'fit',
                //hidden:is_cxdj,
                items: fxxx_wtbTab()
            },
            {
                title: '最低承销额不足信息',
                layout:'fit',
                //hidden:is_cxdj,
                items: fxxx_cxebzTab()
            },
            {
                title: '债券托管信息',
                layout:'fit',
                //hidden:is_cxdj,
                items: fxxx_tgxxbzTab()
            }]
    });
    /*if(is_cxdj){
        editorTab.setActiveItem(editorTab.items.items[2])
    }*/
    return editorTab;
}

/**
 * 初始化债权发行管理弹出窗口中的投标信息标签页中的表格
 */
function tbxxTab() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {"dataIndex": "CXJG_CODE", "type": "string", "text": "承销商代码", "width": 150, editor: 'textfield'},
        {"dataIndex": "CXJG_NAME", "type": "string", "text": "承销商名称", "width": 150, editor: 'textfield'},
        {"dataIndex": "CXSTGZH", "type": "string", "text": "承销商托管账号", "width": 200, editor: 'textfield'},
        {"dataIndex": "TBXH", "type": "string", "text": "投标序号", "width": 100, editor: 'textfield'},
        {
            "dataIndex": "TB_JW", "type": "float", "text": "投标价位", "width": 150,
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.0000####');
            }

        },
        {
            "dataIndex": "TB_AMT", "type": "float", "text": "投标数量", "width": 150,
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.0000####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000####');
            }
        },
        {
            "dataIndex": "ZBSL_NUM", "type": "float", "text": "中标数量", "width": 150,
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.0000####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000####');
            }
        },
        {
            "dataIndex":"TB_DATE",
            "type": 'string',
            "width":150,
            "text": "投标时间"
        }
    ];

    var config = {
        itemId: 'tbmxGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: [],
        height: '100%',
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }]
    };
    var grid = DSYGrid.createGrid(config);
    return grid;
}
/**
 * excel导入
 * @param form
 */
function uploadTbxxFile(form,grid,excelHeader) {
    //var url = '/importZbdj.action';
    //var excelHeader = '{"CXJG_CODE":"承销商代码", "CXJG_NAME":"承销商名称", "TB_JW":"投标价位", "TB_AMT":"投标数量" }';
    form.submit({
        clientValidation:false,
        url: '/importZbdj.action',
        waitTitle: '请等待',
        waitMsg: '正在导入中...',
        success: function (form, action) {

            //设置解析了类型
            if(action.result.data.do_flag=="zzhd"){
                do_flag_s="zzhd";
            }
            if(action.result.data.do_flag=="zzd"){
                do_flag_s="zzd";
            }
            if(action.result.data.do_flag=="sjs"){
                do_flag_s="sjs";
            }
            //导入时 从后台加载承销团信息 用以校验
            Ext.Ajax.request({
                url :'getCxtxx.action',
                async : false,
                success : function (response) {
                    var respText = Ext.JSON.decode(response.responseText);
                    if(respText.list){
                        var cxtList =  respText.list;
                        for(var i = 0; i < cxtList.length; i++){
                            var cxt = cxtList[i];
                            cxtData[cxt['CXS_TGZH']] = cxt;
                            zzdData[cxt['CXS_ZZDZH']] = cxt;
                        }
                    }
                }
            });
            if(action.result.data.ZBQK.length==1){
             var zbqkData = action.result.data.ZBQK;
             if(zbqkData[0]!=null){
            var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
            var zq_code=Trim(records[0].data.ZQ_CODE);
           if(Trim(zbqkData[0].ZQ_CODE)!=zq_code) {
               Ext.Msg.alert('提示','债券代码不对应，请确定后再导入！');
               return;
           }}
            }
            ////投标不足承销商统计表
            var TBBZTJData = action.result.data.TBBZTJ;
            if(TBBZTJData[0] != null){
                if("zzhd" == do_flag_s){
                    matchCxtInfo(TBBZTJData,true);
                }
                var grid = DSYGrid.getGrid('tbbzGrid');
                grid.getStore().removeAll();
                grid.insertData(null, TBBZTJData);
            }

            ////未投标承销商统计表
            var WTBTJData = action.result.data.WTBTJ;
            if(WTBTJData[0] != null){
                //中证登 匹配其承销机构信息
                if("zzhd" == do_flag_s){
                    matchCxtInfo(WTBTJData,true);
                }
                var grid = DSYGrid.getGrid('wtbxxGrid');
                grid.getStore().removeAll();
                grid.insertData(null, WTBTJData);
            }

            //发行招标情况
            var ZBQKData = action.result.data.ZBQK;
            if(ZBQKData[0] != null){
                var form = Ext.ComponentQuery.query('form[itemId="zbqkForm"]')[0];
                form.getForm().setValues(ZBQKData[0]);
            }

            //最低承销额不足统计表	
            var ZBBZTJData = action.result.data.ZBBZTJ;
            if(ZBBZTJData[0] != null){
                //中证登 匹配其承销机构信息
                if("zzhd" == do_flag_s){
                    matchCxtInfo(ZBBZTJData,true);
                }
                var grid = DSYGrid.getGrid('zdcxeGrid');
                grid.getStore().removeAll();
                grid.insertData(null, ZBBZTJData);
            }



            //投标明细
            var TBMXData = action.result.data.TBMX;
            if(TBMXData[0] != null){
                //中证登，深交所 匹配其承销机构信息
                if("zzd" != do_flag_s){
                    matchCxtInfo(TBMXData);
                }
                var grid = DSYGrid.getGrid('tbmxGrid');
                grid.getStore().removeAll();
                grid.insertData(null, TBMXData);
            }
            //中标信息
            var ZHBMXData = action.result.data.ZHBMX;
            if(ZHBMXData[0] != null){
                //中证登，深交所 匹配其承销机构信息
                if("zzd" != do_flag_s){
                    matchCxtInfo(ZHBMXData);
                }
                var grid = DSYGrid.getGrid('zbxxGrid');
                grid.getStore().removeAll();
                grid.insertData(null, ZHBMXData);
            }
            //承销商缴款信息
            var JKHZData = action.result.data.JKHZ;
            if(JKHZData[0] != null){
                //中证登，深交所 匹配其承销机构信息
                if("zzd" != do_flag_s){
                    matchCxtInfo(JKHZData);
                }
                var grid = DSYGrid.getGrid('cxsjkxxGrid');
                grid.getStore().removeAll();
                grid.insertData(null, JKHZData);
            }
            //债券托管消息
            var ZQZCData = action.result.data.ZQZC;
            if(ZQZCData[0] != null){
                //中证登，深交所 匹配其承销机构信息
                if("zzd" != do_flag_s){
                    matchCxtInfo(ZQZCData);
                }
                var grid = DSYGrid.getGrid('tgxxGrid');
                grid.getStore().removeAll();
                grid.insertData(null, ZQZCData);
            }


        },
        failure: function (form, action) {
            //var msg = action.result.data.message;
            Ext.Msg.alert('提示','导入失败:格式或文件错误');
        }

    });


}

/**
 * 初始化债权发行管理弹出窗口中的承销及缴款标签页
 /* *!/
 function cxjkTab() {

        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: 400,
            //autoScroll: true,
            layout: 'anchor',
            border: false,
            padding: '2 2 2 2',
            items: [init_cxjk_grid()]
        });

}*/
//去除空格方法
function Trim(m){
    while((m.length>0)&&(m.charAt(0)==' '))
        m  =  m.substring(1, m.length);
    while((m.length>0)&&(m.charAt(m.length-1)==' '))
        m = m.substring(0, m.length-1);
    return m;
}
/**
 * 初始化债权发行管理弹出窗口中的承销及缴款标签页中的表格
 */
function cxjkTab() {
    var headerJson = [
        //{xtype: 'rownumberer',width: 35},
        {
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {"dataIndex": "CXJG_CODE", "type": "string", "text": "承销商代码", "width": 150},
        {"dataIndex": "CXSTGZH", "type": "string", "text": "承销商托管账号", "width": 200},
        {"dataIndex": "ZXW", "type": "string", "text": "主席位", "width": 100},
        {"dataIndex": "CXJG_NAME", "type": "string", "text": "承销商名称", "width": 150},
        {
            "dataIndex": "GDCX_AMT", "type": "float", "text": "固定承销额（亿元面值）", "width": 220,
            editor: {
                xtype: 'numberfield',
                hideTrigger: true,
                decimalPrecision: 8
            },
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.0000####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000####');
            }
        },
        {
            "dataIndex": "ZB_AMT", "type": "float", "text": "中标额（亿元面值）", "width": 180,
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.0000####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000####');
            }
        },
        {
            "dataIndex": "RG_SUM_AMT", "type": "float", "text": "认购额合计（亿元面值）", "width": 220,
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.0000####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000####');
            }
        },
        {
            "dataIndex": "JK_AMT", "type": "float", "text": "缴款金额（元）", "width": 150,
            editor: {
                xtype: 'numberfield',
                hideTrigger: true,
                decimalPrecision: 8
            },
            renderer:function(value){
                return Ext.util.Format.number(value, '0,000.0000######');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.0000######');
            }
        },{"dataIndex": "REMARK", "type": "string", "text": "备注", "width": 150}
    ];

    var config = {
        itemId: 'cxsjkxxGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: [],
        height: '100%',
        width: "100%",
        pageConfig: {
            enablePage: false
        },
        features: [{
            ftype: 'summary'
        }]
    };
    var grid = DSYGrid.createGrid(config);

    //将增加删除按钮添加到表格中
    /* grid.addDocked({
         xtype: 'toolbar',
         layout: 'column',
         items: [
             {
                 xtype: 'filefield',
                 buttonText: '导入',
                 name: 'upload',
                 width: 60,
                 buttonOnly: true,
                 hideLabel: true,
                 buttonConfig: {
                     width: 60,
                     icon: '/image/sysbutton/report.png'
                 },
                 listeners: {
                     change: function (fb, v) {
                         var form = this.up('form').getForm();
                         uploadCxjkFile(form);
                     }
                 }
             },
             {
                 xtype: 'button',
                 text: '录入',
                 width: 60,
                 handler: function (btn) {
//                        var rowEditing = btn.up('grid').getPlugin('rowedit_cxjk');
//                        rowEditing.cancelEdit();
//                        var r = Ext.create('row_edit_cxjk_grid', {});
//                        btn.up('grid').insertData(0, r);
//                        rowEditing.startEdit(0, 0);
                     var form = this.up('form').getForm();
                     loadCxjk(form);
                 }
             },              {
                 xtype: 'button',
                 text: '增行',
                 width: 60,
                 handler: function (btn) {
                    var rowEditing = btn.up('grid').getPlugin('rowedit_cxjk');
                    rowEditing.cancelEdit();
                    var r = Ext.create('row_edit_cxjk_grid', {});
                    btn.up('grid').insertData(null, r);
                     rowEditing.startEdit(0, 0);

                 }
             },
             {
                 xtype: 'button',
                 text: '删行',
                 itemId: 'delete_editGrid_cxjk',
                 width: 60,
                 disabled: true,
                 handler: function (btn) {
                     var rowEditing = btn.up('grid').getPlugin('rowedit_cxjk');
                     var grid = btn.up('grid');
                     var store = grid.getStore();
                     var sm = grid.getSelectionModel();
                     rowEditing.cancelEdit();
                     store.remove(sm.getSelection());
                     if (store.getCount() > 0) {
                         sm.select(0);
                     }
                 }
             }
         ]
     }, 0);*/
    return grid;
}

/**
 * 承销及缴款excel导入
 * @param form
 */
function uploadCxjkFile(form) {
    var url = 'importExcel.action';

    var excelHeader = '{"CXS_CODE":"承销商代码","CXS_TGZH":"承销商托管账号", "CXJG_NAME":"承销商名称", "GDCX_AMT":"固定承销额（亿元面值）","ZB_AMT":"中标额（亿元面值）", "RG_SUM_AMT":"认购额合计（亿元面值）", "JK_AMT":"缴款金额（元）" }';
    if (form.isValid()) {
        form.submit({
            url: url,
            params: {
                excelHeader: excelHeader
            },
            waitTitle: '请等待',
            waitMsg: '正在导入中...',
            success: function (form, action) {
                var columnStore = action.result.data.list;
                var grid = DSYGrid.getGrid('cxjkGrid');
                grid.insertData(null, columnStore);
            },
            failure: function (form, action) {
                var msg = action.result.data.msg;
                //alert(msg);
                Ext.Msg.alert('提示','导入失败:' + msg);
            }
        });
    } else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
    }
}
/**
 * 初始化续发行债券基本信息面板
 */
function jbxxTab_xfx(node_code, isEdit, FIRST_ZQ_ID, onlyShow,ydjh_id) {
    var fontSize = '';
    var labelWidth = 0;
    var iWidth = window.screen.width;//获取当前屏幕的分辨率
    if (iWidth == 1366) {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    } else if (iWidth == 1400 || iWidth == 1440) {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    } else if (iWidth == 1600 || iWidth == 1680) {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    } else {
        fontSize = 'font-size:13px;';
        labelWidth = 150;
    }
    /**
     * 定义表单元素及信息
     */

    var content = [{
        xtype: 'container',
        title: '债务信息',
        layout: 'anchor',
        width: "100%",
        margin: '0 2 0 2',
        autoScroll : true,
        defaults: {
            border: false,
            anchor: '100%',
            padding: '0 10 0 0'
        },
        items: [{//第一部分：第一行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33,
                padding: '7 0 2 0',
                labelAlign: 'right',
                labelWidth: labelWidth,
                //labelStyle : fontSize,
                allowBlank: true,
                editable: true
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '<span class="required">✶</span>所属区划',
                    name: "AD_CODE",
                    hidden: true
                }, {
                    xtype: "textfield",
                    fieldLabel: '<span class="required">✶</span>债券代码',
                    name: "ZQ_CODE",
                    ////labelStyle : fontSize,
                    allowBlank: false
                },
                {
                    xtype: "textfield",
                    fieldLabel: '<span class="required">✶</span>债券名称',
                    name: "ZQ_NAME",
                    allowBlank: false
                },
                {
                    xtype: "textfield",
                    fieldLabel: '<span class="required">✶</span>债券简称',
                    name: "ZQ_JC",
                    allowBlank: false

                }]
        }, {//第一部分：第二行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right',//labelStyle : fontSize,
                allowBlank: true,
                editable: true
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '发文名称',
                    name: "ZQ_FWMC"
                },
                {
                    xtype: "treecombobox",
                    name: "ZQLB_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<span class="required">✶</span>债券类型',
                    editable: false, //禁用编辑
                    readOnly: IS_BZB == '1' || IS_BZB == '2' ? true : false,
                    fieldStyle: IS_BZB == '1' || IS_BZB == '2' ? 'background:#E6E6E6' : 'background:#FFFFFF',
                    selectModel: 'leaf',
                    allowBlank: false,
                    listeners: {
                        'change': function (self, newValue, oldValue) {
                        }

                    }
                },
                // {
                //     xtype: "treecombobox",
                //     name: "ZQPZ_ID",
                //     value: '111',
                //     store: DebtEleTreeStoreJSON(json_debt_zqpz),
                //     displayField: "name",
                //     valueField: "id",
                //     fieldLabel: '债券品种',
                //     editable: false, //禁用编辑
                //     readOnly: true,
                //     fieldStyle: 'background:#E6E6E6',
                //     allowBlank: false,
                //     selectModel: 'leaf',
                //     hidden: true
                // },
                {
                    xtype: "treecombobox",
                    name: "ZPHXHLX_ID",
                    store: DebtEleTreeStoreDB('DEBR_ZPHXHLX'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '其他自平衡细化类型',
                    editable: false, //禁用编辑
                    readOnly: IS_BZB == '1' || IS_BZB == '2' ? true : false,
                    fieldStyle: IS_BZB == '1' || IS_BZB == '2' ? 'background:#E6E6E6' : 'background:#FFFFFF',
                    allowBlank: false,
                    selectModel: 'leaf'
                }
            ]
        }, {//第一部分：第三行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right',//labelStyle : fontSize,
                allowBlank: true,
                editable: true
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '文号',
                    name: "ZQ_WH"
                },
                {
                    xtype: "combobox",
                    name: "ZQTGR_ID",
                    store: DebtEleStoreDB('DEBT_ZQTGR'),
                    displayField: "name",
                    valueField: "id",
                    value: '01',
                    fieldLabel: '债券托管人',
                    editable: false //禁用编辑
                },
                {
                    xtype: "treecombobox",
                    name: "ZJLY_ID",
                    store: DebtEleTreeStoreDB('DEBT_CHZJLY',{condition:" and (code like '0101%' or code like '0102%') "}),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<span class="required">✶</span>偿还资金来源',
                    editable: false, //禁用编辑
                    fieldStyle: 'background:#E6E6E6',
                    selectModel:"leaf",
                    allowBlank: false
                }]
        }, {//第一部分：第四行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33,
                padding: '2 0 2 0',
                labelAlign: 'right',
                labelWidth: labelWidth,
                //labelStyle : fontSize,
                allowBlank: true,
                editable: true
            },
            items: [
                {
                    xtype: "treecombobox",
                    name: "SRKM_ID",
                    store: zwsrkm_store,
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '<span class="required">✶</span>债务收入科目',
                    allowBlank:false,
                    readOnly: true,
                    selectModel:"leaf"
                }, {
                    xtype: "combobox",
                    name: "FXFS_ID",
                    store: DebtEleStore(json_debt_fxfs),
                    displayField: "name",
                    valueField: "id",
                    // value:'01',
                    fieldLabel: '<span class="required">✶</span>发行方式',
                    allowBlank: false,
                    editable: false, //禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6',
                    listeners: {
                        'change': function (self, newValue, oldValue) {
                        }
                    }
                },
                {
                    xtype: "combobox",
                    name: "ZQ_PC_ID",
                    store: DebtEleStoreDB('DEBT_ZQPC'),
                    fieldLabel: '<span class="required">✶</span>发行批次',
                    displayField: 'name',
                    valueField: 'id',
                    readOnly: IS_BZB == '1' || IS_BZB == '2' ? true : false,
                    editable: false, //禁用编辑
                    fieldStyle: IS_BZB == '1' || IS_BZB == '2'? 'background:#E6E6E6' : 'background:#FFFFFF',
                    allowBlank: false
                }]
        }, {// 分割线
            xtype: 'container',
            layout: 'hbox',
            items: [{// 分割线
                xtype: 'menuseparator',
                width: '100%',
                border: true
            }]
        }, {//第二部分：第一行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right',//labelStyle : fontSize,
                allowBlank: true
            },
            items: [{
                xtype: "numberfield",
                name: "PLAN_FX_AMT",
                fieldLabel: '<span class="required">✶</span>计划发行额（亿）',
                emptyText: '0.000000',
                value: 0,
                maxValue: 999999.99,
                minValue: 0,
                decimalPrecision: 8,
                hideTrigger: true,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                listeners: {
                    'change': function () {
                        if (sysParamZqfxfs != '1') {
                            var form = this.up('form').getForm();
                            if (!isEdit && node_code == 1 && !editFirstLoad) {
                                var PLAN_FX_AMT = form.findField('PLAN_FX_AMT').getValue();
                                var FX_AMT = form.findField('FX_AMT');
                                FX_AMT.setValue(PLAN_FX_AMT);
                            }
                        }
                    }
                }
            }, {
                xtype: "numberfield",
                name: "FX_AMT",
                fieldLabel: '<span class="required">✶</span>实际发行额（亿）',
                emptyText: '0.000000',
                value: 0,
                maxValue: 999999.99,
                minValue: 0,
                decimalPrecision: 8,
                hideTrigger: true,
                allowBlank: false,
                //readOnly: true,
                //fieldStyle: 'background:#E6E6E6',
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                listeners: {
                    'blur': function () {
                        var form = this.up('form').getForm();
                        var FX_AMT = form.findField('FX_AMT').value;
                        var ZQ_BILL_QX = form.findField('ZQ_BILL_QX').getValue();
                        var ZQ_BILL_QX = ZQ_BILL_QX == null ? "" : ZQ_BILL_QX.replace("年", "");
                        var PM_RATE = form.findField('PM_RATE').getValue();
                        var LX_SUM_AMT = form.findField('LX_SUM_AMT');
                        LX_SUM_AMT.setValue(FX_AMT * PM_RATE * ZQ_BILL_QX / 100);
                        var FXSXF_RATE = form.findField('FXSXF_RATE').getValue();
                        var FXSXF_AMT = form.findField('FXSXF_AMT');
                        FXSXF_AMT.setValue(FX_AMT * 100000000 * FXSXF_RATE / 1000);
                        var TGSXF_RATE = form.findField('TGSXF_RATE').getValue();
                        var TGSXF_AMT = form.findField('TGSXF_AMT');
                        TGSXF_AMT.setValue(FX_AMT * 100000000 * TGSXF_RATE / 1000);
                        //如果发行方式为定向承销，则其中置换金额等于实际发行额
                        var FXFS_ID = form.findField('FXFS_ID').value;
                        var ZQLB_ID = form.findField('ZQLB_ID').value;
                        //如果债券类型为以下几种，新增金额默认为实际发行额
                        reserAmt (form,onlyShow,isEdit,true,false);
                    }
                }
            }, {
                xtype: "numberfield",
                name: "ZBJG_AMT",
                fieldLabel: '<span class="required">✶</span>中标价格（元）',
                emptyText: '0.00',
                value: 100.00,
                decimalPrecision: 8,
                hideTrigger: true,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                listeners: {
                    'change':function(self,value,oldvalue,e){
                        if(value != null){
                            if(value < 0){
                                Ext.Msg.alert("提示","中标价格不能小于0！");
                                self.setValue(oldvalue) ;
                            }
                            if(value > 200){
                                Ext.Msg.alert("提示","中标价格最大不能超过200！");
                                self.setValue(oldvalue) ;
                            }
                        }
                    }
                }
            }]
        }, {//第二部分：第二行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right',//labelStyle : fontSize,
                allowBlank: true
            },
            items: [{
                xtype: "numberfield",
                name: "XZ_AMT",
                fieldLabel: '<span class="required">✶</span>其中新增债券（亿）',
                emptyText: '0.000000',
                value: 0,
                maxValue: 999999.99,
                minValue: 0,
                decimalPrecision: 8,
                hideTrigger: true,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                listeners: {
                    'change': function () {
                        if (sysParamZqfxfs == '1') {
                            var form = this.up('form').getForm();
                            if (!isEdit && node_code == 1 && !editFirstLoad) {
                                var zhForm = form.findField('ZH_AMT') ;
                                var ZH_AMT = zhForm.getValue();
                                var XZ_AMT = form.findField('XZ_AMT').getValue();
                                var HB_AMT = form.findField('HB_AMT').getValue();
                                var FX_AMT = form.findField('FX_AMT').getValue();
                                /*if((HB_AMT+XZ_AMT+ZH_AMT)-FX_AMT > 0.0000001){
                                    Ext.Msg.alert("提示","输入金额不能大于实际发行额！") ;
                                    form.findField('XZ_AMT').setValue(0)
                                    return;
                                }*/
                            }
                        }
                    }
                }
            },{
                xtype: "numberfield",
                name: "ZH_AMT",
                fieldLabel: '<span class="required">✶</span>置换债券（亿）',
                emptyText: '0.000000',
                value: 0,
                maxValue: 999999.99,
                minValue: 0,
                decimalPrecision: 8,
                hideTrigger: true,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                listeners: {
                    'change': function () { //是否和新增 置换 计算
                        if (sysParamZqfxfs == '1') {
                            var form = this.up('form').getForm();
                            if (!isEdit && node_code == 1 && !editFirstLoad) {
                                var xzForm = form.findField('XZ_AMT') ;
                                var XZ_AMT = xzForm.getValue();
                                var HB_AMT = form.findField('HB_AMT').getValue();
                                var ZH_AMT = form.findField('ZH_AMT').getValue();
                                var FX_AMT = form.findField('FX_AMT').getValue();
                                /*if((HB_AMT+XZ_AMT+ZH_AMT)-FX_AMT > 0.0000001){
                                    Ext.Msg.alert("提示","输入金额不能大于实际发行额！") ;
                                    form.findField('ZH_AMT').setValue(0);
                                    return;
                                }*/
                            }
                        }
                    }
                }
            },{
                xtype: "numberfield",
                name: "HB_AMT",
                fieldLabel: '<span class="required">✶</span>再融资债券（亿）',
                emptyText: '0.000000',
                value: 0,
                maxValue: 999999.99,
                minValue: 0,
                decimalPrecision: 8,
                hideTrigger: true,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                listeners: {
                    'change': function () {
                        if (sysParamZqfxfs == '1') {
                            var form = this.up('form').getForm();
                            if (!isEdit && node_code == 1 && !editFirstLoad) {
                                var xzForm = form.findField('XZ_AMT') ;
                                var XZ_AMT = xzForm.getValue();
                                var HB_AMT = form.findField('HB_AMT').getValue();
                                var ZH_AMT = form.findField('ZH_AMT').getValue();
                                var FX_AMT = form.findField('FX_AMT').getValue();
                                /*if((HB_AMT+XZ_AMT+ZH_AMT)-FX_AMT > 0.0000001){
                                    form.findField('HB_AMT').setValue(0);
                                    Ext.Msg.alert("提示","输入金额不能大于实际发行额！") ;
                                    return;
                                }*/
                            }
                        }
                    }
                }
            }, {
                xtype: "datefield",
                name: "ZQ_GGR",
                fieldLabel: '公告日',
                allowBlank: true,
                format: 'Y-m-d',
                blankText: '请选择开始日期',
                //emptyText: '请选择开始日期',
                value : ''
                //value: today
            },{
                xtype: "datefield",
                name: "ZB_DATE",
                fieldLabel: '<span class="required">✶</span>招标日',
                allowBlank: false,
                format: 'Y-m-d',
                blankText: '请选择开始日期',
                emptyText: '请选择开始日期',
                value : ''
                //value: today
            }]
        }, {//第二部分：第三行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right',//labelStyle : fontSize,
                allowBlank: true
            },
            items: [
                {
                    xtype: "textfield",
                    fieldLabel: '招标开始时间',
                    name: "ZB_START_DATE",
                    editable: true,
                    hidden:true
                },
                {
                    xtype: "textfield",
                    fieldLabel: '招标结束时间',
                    name: "ZB_END_DATE",
                    editable: true,
                    hidden:true
                }]
        }, {// 分割线
            xtype: 'container',
            layout: 'hbox',
            items: [{// 分割线
                xtype: 'menuseparator',
                width: '100%',
                border: true
            }]
        }, {//第三部分：第一行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right',//labelStyle : fontSize,
                allowBlank: true
            },
            items: [{
                xtype: "combobox",
                name: "ZQ_BILL_QX",
                store: DebtEleStoreDB("DEBT_ZQQX"),
                displayField: "name",
                valueField: "id",
                fieldLabel: '<span class="required">✶</span>期限',
                allowBlank: false,
                editable: false,
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
                listeners: {
                    'change': function (self,newValue) {
                        var form = this.up('form').getForm();
                        var FX_AMT = form.findField('FX_AMT').value;
                        //var ZQ_BILL_QX = form.findField('ZQ_BILL_QX').getRawValue();
                        var ZQ_BILL_QX = newValue;
                        var PM_RATE = form.findField('PM_RATE').getValue();
                        var LX_SUM_AMT = form.findField('LX_SUM_AMT');
                        LX_SUM_AMT.setValue(FX_AMT * PM_RATE * ZQ_BILL_QX / 100);
                        /*var qxDate = Ext.ComponentQuery.query('datefield[name="QX_DATE"]')[0].getValue();
                        var year = parseInt(qxDate.getFullYear()) + parseInt(ZQ_BILL_QX);
                        var month = qxDate.getUTCMonth() + 1;
                        */
                        var qxDate = Ext.util.Format.date(Ext.ComponentQuery.query('datefield[name="QX_DATE"]')[0].getValue(),'Y-m-d');
                        var year = accAdd(qxDate.split('-')[0],ZQ_BILL_QX);
                        var month = qxDate.split('-')[1];
                        var day = qxDate.split('-')[2];
                        /*if (month < 10)
                            month = "0" + month;
                        //var day = qxDate.getDate();
                        if (day < 10)
                            day = "0" + day;*/
                        var dfrq = year + '-' + month + '-' + day;//兑付日期
                        Ext.ComponentQuery.query('datefield[name="DQDF_DATE"]')[0].setValue(dfrq)
                    }
                }
            }, {
                xtype: "numberfield",
                name: "PM_RATE",
                fieldLabel: '<span class="required">✶</span>票面利率（%）',
                emptyText: '0.000000',
                maxValue: 9999.999999,
                minValue: 0.000001,
                decimalPrecision: 8,
                hideTrigger: true,
                allowBlank: false,
                editable: false,
                readOnly:true,
                fieldStyle: 'background:#E6E6E6',
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                listeners: {
                    'change': function () {
                        var form = this.up('form').getForm();
                        var FX_AMT = form.findField('FX_AMT').value;
                        var ZQ_BILL_QX = form.findField('ZQ_BILL_QX').getRawValue();
                        var ZQ_BILL_QX = ZQ_BILL_QX.replace("年", "");
                        var PM_RATE = form.findField('PM_RATE').getValue();
                        var LX_SUM_AMT = form.findField('LX_SUM_AMT');
                        LX_SUM_AMT.setValue(FX_AMT * PM_RATE * ZQ_BILL_QX / 100);
                    }
                }
            },
                {
                    xtype: "numberfield",
                    name: "LX_SUM_AMT",
                    fieldLabel: '利息总额（亿）',
                    emptyText: '0.000000',
                    decimalPrecision: 8,
                    hideTrigger: true,
                    readOnly: true,
                    hidden:true,
                    fieldStyle: 'background:#E6E6E6',
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }
            ]
        }, {//第四部分：第一行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right',//labelStyle : fontSize,
                allowBlank: true
            },
            items: [{//第四部分：
                xtype: "datefield",
                //vtype: 'compareFxDateQxDate',
                name: "QX_DATE",
                fieldLabel: '<span class="required">✶</span>起息日',
                allowBlank: false,
                format: 'Y-m-d',
                blankText: '请选择开始日期',
                allowBlank: false,
                value: today
            }, {
                xtype: "datefield",
                name: "DQDF_DATE",
                fieldLabel: '到期兑付日',
                format: 'Y-m-d',
                blankText: '请选择开始日期',
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
                value: today,
                listeners: {
                    'select': function () {
                    }
                }
            }, {
                xtype: "combobox",
                name: "FXZQ_ID",
                store: DebtEleStore(json_debt_fxzq),
                displayField: "name",
                valueField: "id",
                fieldLabel: '<span class="required">✶</span>付息方式',
                allowBlank: false,
                editable: false, //禁用编辑
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
                listeners: {
                    'select': function () {
                    }
                }
            }]
        }, {//第四部分：第二行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right',//labelStyle : fontSize,
                allowBlank: true
            },
            items: [

                {
                    xtype: "numberfield",
                    name: "TQHK_DAYS",
                    fieldLabel: '提前还款天数',
                    emptyText: '0',
                    decimalPrecision: 0,
                    hideTrigger: true,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }, {
                    xtype: "datefield",
                    //vtype: 'compareFxDateQxDate',
                    name: "FX_START_DATE",
                    fieldLabel: '<span class="required">✶</span>发行日期',
                    allowBlank: false,
                    format: 'Y-m-d',
                    blankText: '请选择日期',
                    //hidden:fxrqShowFlag,
                    value: today
                }, {
                    xtype: "datefield",
                    name: "JK_DATE",
                    fieldLabel: '缴款日期',
                    format: 'Y-m-d',
                    hidden:true,
                    listeners: {
                        'select': function () {
                        }
                    }
                }, {
                    xtype: "datefield",
                    name: "FX_END_DATE",
                    fieldLabel: '至',
                    //allowBlank: false,
                    format: 'Y-m-d',
                    blankText: '请选择开始日期',
                    hidden:true,
                    //value: today,
                    listeners: {
                        'select': function () {
                        }
                    }
                }]
        }, {// 分割线
            xtype: 'container',
            layout: 'hbox',
            items: [{// 分割线
                xtype: 'menuseparator',
                width: '100%',
                border: true
            }]
        }, {//第六部分：第一行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33, labelWidth: labelWidth,
                padding: '2 0 2 0',
                labelAlign: 'right',//labelStyle : fontSize,
                allowBlank: true
            },
            items: [{
                xtype: "combobox",
                name: "SXFYJ_ID",
                store: DebtEleStore(json_debt_sxfyj),
                displayField: "name",
                valueField: "id",
                value: '001',
                fieldLabel: '<span class="required">✶</span>手续费支付方式',
                allowBlank: false,
                editable: true, //禁用编辑
                readOnly: true,
                fieldStyle: 'background:#E6E6E6',
                listeners: {
                    'select': function () {
                    }
                }
            },
                {
                    xtype: "numberfield",
                    name: "FXSXF_RATE",
                    maxValue: 10,
                    minValue: 0.000001,
                    fieldLabel: '<span class="required">✶</span>发行手续费费率（‰）',
                    emptyText: '0.0000',
                    decimalPrecision: 4,
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    listeners: {
                        'blur': function () {
                            var form = this.up('form').getForm();
                            var FX_AMT = form.findField('FX_AMT').getValue();
                            var FXSXF_RATE = form.findField('FXSXF_RATE').getValue();
                            var FXSXF_AMT = form.findField('FXSXF_AMT');
                            FXSXF_AMT.setValue(FX_AMT * 100000000 * FXSXF_RATE / 1000);
                        }
                    }
                },
                {
                    xtype: "numberfield",
                    name: "TGSXF_RATE",
                    fieldLabel: '<span class="required">✶</span>登记托管费率（‰）',
                    emptyText: '0.0000',
                    decimalPrecision: 4,
                    maxValue: 10,
                    minValue: 0.000001,
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                    listeners: {
                        'change': function () {
                            var form = this.up('form').getForm();
                            var FX_AMT = form.findField('FX_AMT').getValue();
                            var TGSXF_RATE = form.findField('TGSXF_RATE').getValue();
                            var TGSXF_AMT = form.findField('TGSXF_AMT');
                            TGSXF_AMT.setValue(FX_AMT * 100000000 * TGSXF_RATE / 1000);
                        }
                    }
                }]
        }, {//第六部分：第二行
            xtype: 'container',
            layout: 'column',
            defaults: {
                columnWidth: .33, labelWidth: labelWidth,
                padding: '2 0 5 0',
                labelAlign: 'right',//labelStyle : fontSize,
                allowBlank: true
            },
            items: [{
                xtype: "numberfield",
                name: "DFSXF_RATE",
                fieldLabel: '<span class="required">✶</span>兑付手续费率（‰）',
                emptyText: '0.0000',
                decimalPrecision: 4,
                maxValue: 10,
                minValue: 0.000001,
                hideTrigger: true,
                allowBlank: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
                {
                    xtype: "numberfield",
                    name: "FXSXF_AMT",
                    fieldLabel: '发行手续费（元）',
                    emptyText: '0.00',
                    hideTrigger: true,
                    editable: false,
                    fieldStyle: 'background:#E6E6E6',
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                {
                    xtype: "numberfield",
                    name: "TGSXF_AMT",
                    fieldLabel: '登记托管费（元）',
                    emptyText: '0.00',
                    hideTrigger: true,
                    editable: false,
                    fieldStyle: 'background:#E6E6E6',
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                {
                    xtype: "textfield",
                    fieldLabel: '备注',
                    columnWidth: .99,
                    name: "REMARK" ,
                    maxLength : 200 ,
                    maxLengthText : '输入文字过长，只能输入200个字！'
                },
                {
                    xtype: "textfield",
                    fieldLabel: '首次发行债券ID',
                    hidden: true,
                    name: "FIRST_ZQ_ID"
                },
                {
                    xtype: "textfield",
                    fieldLabel: '是否续发行',
                    hidden: true,
                    name: "IS_XFX"
                }
            ]
        }
            //结束
        ]
    }];

    var editorPanel = Ext.create('Ext.form.Panel', {
        itemId: 'jbxxForm',
        layout: 'fit',
        border: false,
        autoScroll: true,
        items: content
    });

    /**
     * 若为新增状态，则直接进行页面元素的初始化
     * 若为更新状态，则先进行数据的加载，加载完成后再进行页面元素的初始化
     */

        //loadFxgl(editorPanel, isXfx);
    var form = editorPanel;
    form.load({
        url: 'getFxgl.action?ZQ_BILL_ID=' + ZQ_BILL_ID+'&YDJH_ID='+ydjh_id,
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            form.getForm().setValues(action.result.data.list);
            if (button_name == 'INPUT') {
                var zqNameXfx = form.getForm().findField('ZQ_NAME').getValue();
                form.getForm().findField('ZQ_NAME').setValue(zqNameXfx + '（续发行）');
                //记录默认续发行起息日(即首次发行起息日)
                xfx_qxdate = form.getForm().getValues().QX_DATE;
            }else if (button_name == 'EDIT') {
                //发送ajax请求，校验数据
                $.post("/getFxgl.action", {
                    ZQ_BILL_ID: FIRST_ZQ_ID
                }, function (data) {
                    var result = Ext.util.JSON.decode(data);
                    xfx_qxdate = result.data.list.QX_DATE;
                });
                editFirstLoad = false;
            }
            cxt_id = action.result.data.list.CXT_ID;
            Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].setValue(cxt_id);//设置承销团下拉框信息
            //设置承销团表格
            var jgxxStore = action.result.data.cxtList;
            var grid = DSYGrid.getGrid('jgxxGrid');
            grid.insertData(null, jgxxStore);
            //设置招标信息
            var form1 = Ext.ComponentQuery.query('form#zbqkForm')[0];
            form1.getForm().setValues(action.result.data.zbxxList[0]);

            //设置投标信息
            var tbmxStore = action.result.data.tbmxList;
            var grid = DSYGrid.getGrid('tbmxGrid');
            grid.insertData(null, tbmxStore);
            //设置中标信息
            var zbxxpStore = action.result.data.zbxxpList;
            var grid = DSYGrid.getGrid('zbxxGrid');
            grid.insertData(null, zbxxpStore);

            //设置承销商交款信息
            var cxsjkxxStore = action.result.data.cxsjkxxList;
            var grid = DSYGrid.getGrid('cxsjkxxGrid');
            grid.insertData(null, cxsjkxxStore);
            //设置承销商投标不足信息
            var tbbzStore = action.result.data.tbbzList;
            var grid = DSYGrid.getGrid('tbbzGrid');
            grid.insertData(null, tbbzStore);
            //承销商为投标信息
            var wtbxxStore = action.result.data.wtbxxList;
            var grid = DSYGrid.getGrid('wtbxxGrid');
            grid.insertData(null, wtbxxStore);
            //最低成效额不足
            var zdcxeStore = action.result.data.zdcxeList;
            var grid = DSYGrid.getGrid('zdcxeGrid');
            grid.insertData(null, zdcxeStore);
            //债券托管信息
            var tgxxStore = action.result.data.tgxxList;
            var grid = DSYGrid.getGrid('tgxxGrid');
            grid.insertData(null, tgxxStore);
            //设置承销团表格
//            var tbxxStore = action.result.data.tbxxList;
//            var grid = DSYGrid.getGrid('tbxxGrid');
//            grid.insertData(null, tbxxStore);
            //设置承销团表格
//            var cxjkStore = action.result.data.cxjkList;
//            var grid = DSYGrid.getGrid('cxjkGrid');
//            grid.insertData(null, cxjkStore);
        },
        failure: function (form, action) {
            alert('加载失败');
        }
    });

    return editorPanel;
};
/**
 * 提交表单数据
 * @param form
*/
function submitFxgl_xfx(form,workflow) {
    var cxjgStr = '';//用于校验
    //var tbjgArr=[];//用于校验
    //var zbjgArr = [];//用于校验
    if (!compareFxDateQxDate(form)) {
        message_error = '招标日应早于起息日';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            return false;
        }
    }
    var jgxxArray = [];
    if(isViewCXJG == 1) {
        var jgxxStore = DSYGrid.getGrid('jgxxGrid').getStore();

        if (jgxxStore.getCount() <= 0) {
            Ext.Msg.alert('提示', '请选择承销团信息！');
            return;
        }
        //获取机构信息
        for (var i = 0; i < jgxxStore.getCount(); i++) {
            var array = {};
            var record = jgxxStore.getAt(i);
            array.CXJG_CODE = record.get("CXJG_CODE");
            array.CXJG_NAME = record.get("CXJG_NAME");
            array.CXS_TGZH = record.get("CXS_TGZH");
            array.CXS_ZZDZH = record.get("CXS_ZZDZH");
            array.IS_LEADER = record.get("IS_LEADER");
            array.CX_SCALE = record.get("CX_SCALE");
            array.ORG_ACCOUNT = record.get("ORG_ACCOUNT");
            array.ORG_ACC_NAME = record.get("ORG_ACC_NAME");
            array.ORG_ACC_BANK = record.get("ORG_ACC_BANK");
            jgxxArray.push(array);

            cxjgStr = cxjgStr + array.CXS_TGZH + "#";
        }
    }
    //校验实际发行额=新增+置换
    var fxamt = form.getForm().findField("FX_AMT").value;
    var xzamt = form.getForm().findField("XZ_AMT").value;
    var zhamt = form.getForm().findField("ZH_AMT").value;
    var hbamt = form.getForm().findField("HB_AMT").value;
    var jhamt = form.getForm().findField("PLAN_FX_AMT").value;
    if(jhamt*100000000<100000 || jhamt*100000000>99999999999){
        Ext.Msg.alert('提示','基本信息页有误，计划发行债券金额应介于0.001-999.99999999亿元之间，请检查');
        return;
    }
    if (fxamt <= 0){
        Ext.Msg.alert('提示','基本信息页有误，实际发行额应该大于0，请检查');
        return;
    }
    if (fxamt != (parseFloat(xzamt)+parseFloat(zhamt)+parseFloat(hbamt)).toFixed(2)) {
        Ext.Msg.alert('提示','基本信息页有误，实际发行额不等于新增债券与置换债券与再融资债券之和，请检查');
        return;
    }

    var url = '';
    if (button_name == 'INPUT') {
        url = 'saveFxgl.action?isXfx='+true+'&ZQ_BILL_ID=' + ZQ_BILL_ID + '&IS_BZB=' + IS_BZB;
    } else if (button_name == 'EDIT') {
        url = 'updateFxgl.action?ZQ_BILL_ID=' + ZQ_BILL_ID + '&IS_BZB=' + IS_BZB;
    }

    cxt_id = Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].value;

    var zqlb_id = form.getForm().findField("ZQLB_ID").value;
    //var zjly_id = form.getForm().findField("ZJLY_ID").value;
    var srkm_id = zwsrkm_store.findNode('id', form.getForm().findField("SRKM_ID").value, 0, false, true, true).get('code');
    /*if( zqlb_id == '01' && "undefined" != typeof(zjly_id) && zjly_id.indexOf("0101") != 0){
        Ext.Msg.alert('提示', "债券类型为“一般债券”时，偿还资金来源只能选择“一般公共预算收入”");
        return;
    }
    if( zqlb_id.indexOf('02') == 0 && "undefined" != typeof(zjly_id) && zjly_id.indexOf("0102") != 0){
        Ext.Msg.alert('提示', "债券类型为“专项债券”时，偿还资金来源只能选择“政府性基金预算收入”");
        return;
    }*/
    if( zqlb_id == '01' && "undefined" != typeof(srkm_id) && srkm_id.indexOf("1050401") != 0){
        Ext.Msg.alert('提示', "债券类型为“一般债券”时，债务收入科目只能选择“一般债务收入”");
        return;
    }
    if( zqlb_id.indexOf('02') == 0 && "undefined" != typeof(srkm_id) && srkm_id.indexOf("1050402") != 0){
        Ext.Msg.alert('提示', "债券类型为“专项债券”时，债务收入科目只能选择“专项债务收入”");
        return;
    }

    var fxsxfl_id=form.getForm().findField('FXSXF_RATE').value;
    var djtgfl_id=form.getForm().findField('TGSXF_RATE').value;
    var dfsxfl_id=form.getForm().findField('DFSXF_RATE').value;
    var tqhk_id=form.getForm().findField('TQHK_DAYS').value;
    if(tqhk_id>99){
        Ext.Msg.alert('提示', "提前还款天数最大值不能超过99");
        return;
    }

    if(djtgfl_id>10){
        Ext.Msg.alert('提示', "登记托管费率的最大值不能超过10");
        return;
    }

    if(fxsxfl_id>10){
        Ext.Msg.alert('提示', "发行手续费费率的最大值不能超过10");
        return;
    }

    if(dfsxfl_id>10){
        Ext.Msg.alert('提示', "兑付手续费率的最大值不能超过10");
        return;
    }


    //续发行保存时校验起息日不得小于首次发行起息日且不能大于兑付日
    var qxDate = form.getForm().getValues().QX_DATE;
    var dqdfDate = form.getForm().findField('DQDF_DATE').value;
    if (qxDate < xfx_qxdate){
        Ext.Msg.alert('提示', "续发行起息日不能小于首次发行起息日");
        return;
    }
    if (qxDate > dqdfDate){
        Ext.Msg.alert('提示', "续发行起息日不能大于到期兑付日");
        return;
    }
    if(dqdfDate='null'){
        Ext.Msg.alert('提示', "兑付日期不能为空");
        return;
    }
    if (form.isValid()) {
        form.submit({
            url: url,
            params: {
                wf_id: wf_id,
                node_code: node_code,
                button_name: button_name,
                workflow:workflow,
                userCode: userCode,
                cxt_id: cxt_id,
                ad_code: userAD,
                jgxxArray: Ext.util.JSON.encode(jgxxArray),
                //tbxxArray: Ext.util.JSON.encode(tbxxArray),
                //cxjkArray: Ext.util.JSON.encode(cxjkArray),
                isViewCXJG:isViewCXJG
            },
            waitTitle: '请等待',
            waitMsg: '正在保存中...',
            success: function (form, action) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '保存成功',
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function (btn) {
                        zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%') ");
                        zwsrkm_store.load();
                        DSYGrid.getGrid("grid").getStore().loadPage(1);
                        if (button_name == 'INPUT') {
                            Ext.ComponentQuery.query('window#XfxWin')[0].close();
                        } else {
                            Ext.ComponentQuery.query('window#updateWin')[0].close();
                        }
                    }
                });
            },
            // start modify by Arno Lee 2016-08-17
            failure: function (form, action) {
                Ext.Msg.alert('提示', "保存失败！" + action.result ? action.result.message : '无返回响应');
            }
        });
    } else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
    }
}

/**
 * 校验 托管账号是否在数据库中存在   中债登校验 托管账号 中证登校验托管账号和zzdzh 深交所 投标信息、中标信息、承销商缴款信息校验托管账号、托管信息校验zzdzh
 * @param tbmxArray 投标信息
 * @param zbxxArray 中标信息
 * @param cxsjkxxArray 承销商缴款信息
 * @param tbbzArray 投标不足
 * @param wtbxxArray 未投标情况
 * @param zdcxeArray 最低承销额不足
 * @param tgxxArray 承销商托管信息
 * @param flag 承销商托管信息
 * @returns {string}
 */
function checkImportDate(tbmxArray,zbxxArray,cxsjkxxArray,tbbzArray,wtbxxArray,zdcxeArray,tgxxArray,flag) {
    var result = '';
    //投标信息
    if(tbmxArray){
        for (var i = 0; i < tbmxArray.length; i++) {
            var tbmx = tbmxArray[i];
            var cxjgCode = tbmx['CXJG_CODE'];
            if(!cxjgCode){
                var tgzh = tbmx['CXSTGZH'];
                var tgzh0 = '';
                var tgzh1 = '';
                if(tgzh){
                    var tgzhs = tgzh.split(',');
                    tgzh0 = tgzhs[0];
                    tgzh1 = tgzhs[1] == undefined?'':tgzhs[1];
                }else{
                    tgzh0 = '';
                    tgzh1 = '';
                }
                if(tgzh0 || tgzh1) {
                    result += '【投标信息】页签中【承销商托管账号】[' + tgzh0 + ']' + (tgzh1 == '' ? '' : ',[' + tgzh1 + ']') + '在系统中不存在' + '</br>';
                }else{
                    if(result.indexOf('【投标信息】页签存在【承销商托管账号】为空的列！') == -1){
                        result += '【投标信息】页签存在【承销商托管账号】为空的列！' + '</br>';
                    }
                }
            }
        }
    }
    //中标信息
    if(zbxxArray){
        for (var i = 0; i < zbxxArray.length; i++) {
            var zbmx = zbxxArray[i];
            var cxjgCode = zbmx['CXJG_CODE'];
            if(!cxjgCode){
                var tgzh = zbmx['CXSTGZH'];
                var tgzh0 = '';
                var tgzh1 = '';
                if(tgzh){
                    var tgzhs = tgzh.split(',');
                    tgzh0 = tgzhs[0];
                    tgzh1 = tgzhs[1] == undefined?'':tgzhs[1];
                }else{
                    tgzh0 = '';
                    tgzh1 = '';
                }
                if(tgzh0 || tgzh1) {
                    result += '【中标信息】页签中【承销商托管账号】[' + tgzh0 + ']' + (tgzh1 == '' ? '' : ',[' + tgzh1 + ']') + '在系统中不存在' + '</br>';
                }else{
                    if(result.indexOf('【中标信息】页签存在【承销商托管账号】为空的列！') == -1){
                        result += '【中标信息】页签存在【承销商托管账号】为空的列！' + '</br>';
                    }
                }
            }
        }
    }
    //承销商缴款信息
    if(cxsjkxxArray){
        for (var i = 0; i < cxsjkxxArray.length; i++) {
            var cxsjkxx = cxsjkxxArray[i];
            var cxjgCode = cxsjkxx['CXJG_CODE'];
            if(!cxjgCode){
                var tgzh = cxsjkxx['CXSTGZH'];
                if(tgzh){
                    var tgzhs = tgzh.split(',');
                    tgzh0 = tgzhs[0];
                    tgzh1 = tgzhs[1] == undefined?'':tgzhs[1];
                }else{
                    tgzh0 = '';
                    tgzh1 = '';
                }
                if(tgzh0 || tgzh1) {
                    result += '【承销商缴款信息】页签中【承销商托管账号】[' + tgzh0 + ']' + (tgzh1 == '' ? '' : ',[' + tgzh1 + ']') + '在系统中不存在' + '</br>';
                }else{
                    if(result.indexOf('【承销商缴款信息】页签存在【承销商托管账号】为空的列！') == -1){
                        result += '【承销商缴款信息】页签存在【承销商托管账号】为空的列！' + '</br>';
                    }
                }
            }
        }
    }
    //承销商投标不足信息
    if(tbbzArray && flag){
        for (var i = 0; i < tbbzArray.length; i++) {
            var tbbz = tbbzArray[i];
            var cxjgCode = tbbz['CXJG_CODE'];
            if(!cxjgCode){
                var tgzh = tbbz['OUT_CXS_CODE'];
                if(tgzh){
                    var tgzhs = tgzh.split(',');
                    tgzh0 = tgzhs[0];
                    tgzh1 = tgzhs[1] == undefined?'':tgzhs[1];
                }else{
                    tgzh0 = '';
                    tgzh1 = '';
                }
                if(tgzh0 || tgzh1) {
                    result += '【承销商投标不足信息】页签中【承销商代码】[' + tgzh0 + ']' + (tgzh1 == '' ? '' : ',[' + tgzh1 + ']') + '在系统中不存在' + '</br>';
                }else{
                    if(result.indexOf('【承销商投标不足信息】页签存在【承销商代码】为空的列！') == -1){
                        result += '【承销商投标不足信息】页签存在【承销商代码】为空的列！' + '</br>';
                    }
                }
            }
        }
    }
    //承销商未投标信息
    if(wtbxxArray && flag){
        for (var i = 0; i < wtbxxArray.length; i++) {
            var wtbxx = wtbxxArray[i];
            var cxjgCode = wtbxx['CXJG_CODE'];
            if(!cxjgCode){
                var tgzh = wtbxx['OUT_CXS_CODE'];
                if(tgzh){
                    var tgzhs = tgzh.split(',');
                    tgzh0 = tgzhs[0];
                    tgzh1 = tgzhs[1] == undefined?'':tgzhs[1];
                }else{
                    tgzh0 = '';
                    tgzh1 = '';
                }
                if(tgzh0 || tgzh1) {
                    result += '【承销商未投标信息】页签中【承销商代码】[' + tgzh0 + ']' + (tgzh1 == '' ? '' : ',[' + tgzh1 + ']') + '在系统中不存在' + '</br>';
                }else{
                    if(result.indexOf('【承销商未投标信息】页签存在【承销商代码】为空的列！') == -1){
                        result += '【承销商未投标信息】页签存在【承销商代码】为空的列！' + '</br>';
                    }
                }
            }
        }
    }
    //最低承销额不足
    if(zdcxeArray && flag){
        for (var i = 0; i < zdcxeArray.length; i++) {
            var zdcxe = zdcxeArray[i];
            var cxjgCode = zdcxe['CXJG_CODE'];
            if(!cxjgCode){
                var tgzh = zdcxe['OUT_CXS_CODE'];
                if(tgzh){
                    var tgzhs = tgzh.split(',');
                    tgzh0 = tgzhs[0];
                    tgzh1 = tgzhs[1] == undefined?'':tgzhs[1];
                }else{
                    tgzh0 = '';
                    tgzh1 = '';
                }
                if(tgzh0 || tgzh1) {
                    result += '【最低承销额不足】页签中【承销商代码】[' + tgzh0 + ']' + (tgzh1 == '' ? '' : ',[' + tgzh1 + ']') + '在系统中不存在' + '</br>';
                }else{
                    if(result.indexOf('【最低承销额不足】页签存在【承销商代码】为空的列！') == -1){
                        result += '【最低承销额不足】页签存在【承销商代码】为空的列！' + '</br>';
                    }
                }
            }
        }
    }
    //债券托管信息
    if(tgxxArray){
        for (var i = 0; i < tgxxArray.length; i++) {
            var tgxx = tgxxArray[i];
            var cxjgCode = tgxx['CXJG_CODE'];
            if(!cxjgCode){
                var tgzh = tgxx['CXSTGZH'];
                if(tgzh){
                    var tgzhs = tgzh.split(',');
                    tgzh0 = tgzhs[0];
                    tgzh1 = tgzhs[1] == undefined?'':tgzhs[1];
                }else{
                    tgzh0 = '';
                    tgzh1 = '';
                }
                if(tgzh0 || tgzh1) {
                    result += '【债券托管信息】页签中【承销商托管账号】[' + tgzh0 + ']' + (tgzh1 == '' ? '' : ',[' + tgzh1 + ']') + '在系统中不存在' + '</br>';
                }else{
                    if(result.indexOf('【债券托管信息】页签存在【承销商托管账号】为空的列！') == -1){
                        result += '【债券托管信息】页签存在【承销商托管账号】为空的列！' + '</br>';
                    }
                }
            }
        }
    }
    return result;
}
function checkDfdate(df_end_date){
    var jbxxForm = Ext.ComponentQuery.query('form#jbxxForm')[0];
    var qx_date=jbxxForm.getForm().findField('QX_DATE').value;
    qx_date=format(qx_date,'yyyy-MM-dd');
    // 获取到期兑付日
    var DQDF_DATE=jbxxForm.getForm().findField('DQDF_DATE').value;
    DQDF_DATE=format(DQDF_DATE,'yyyy-MM-dd');
    /*var dfjhStore=DSYGrid.getGrid('dfjhGrid').getStore();
    var record = dfjhStore.findRecord('DF_END_DATE', df_end_date, 0, false, true, true);
    if (record != null) {
        Ext.Msg.alert("提示", "兑付日期不可重复！");
        return false;
    }*/

    var lv= (df_end_date.substr(0,4) - qx_date.substr(0,4)) % 4;
    if(df_end_date.substr(5,5) != qx_date.substr(5,5)){
        //处理特殊日期0229的校验
        if(!(qx_date.substr(5,5) =='02-29' && df_end_date.substr(5,5) =='03-01'&& lv !=0))
        {
            Ext.Msg.alert('提示', '兑付计划页签兑付日期为'+df_end_date+'不是自起息日'+qx_date+'起的整年数！');
            return false;
        }
    }
    if(df_end_date < qx_date){
        Ext.Msg.alert('提示', '兑付计划页签兑付日期不能小于基本信息页签起息日！');
        return false;
    }
    if(df_end_date > DQDF_DATE){
        Ext.Msg.alert('提示', '兑付计划页签兑付日期不能大于基本信息页签到期兑付日！');
        return false;
    }
    if(df_end_date.substr(0,4) - qx_date.substr(0,4)>30){
        Ext.Msg.alert('提示', '兑付计划页签兑付日期不得大于基本信息起息日30年！');
        return false;
    }
    return true;
}
/**
 * 匹配系统中的承销商信息
 * @param array
 * @param flag 是否是中证登且解析出的托管账号存放在OUT_CXS_CODE字段中
 */
function matchCxtInfo(array,flag) {
    if(array){
        for (var i = 0; i < array.length; i++) {
            var obj = array[i];
            var tgzhs = '';
            if(flag && obj['OUT_CXS_CODE']){
                tgzhs = obj['OUT_CXS_CODE'].split(',');
            }
            if(obj['CXSTGZH'] && !flag){
                tgzhs = obj['CXSTGZH'].split(',');
            }
            if(tgzhs){
                var tgzh0 = tgzhs[0];
                var tgzh1 = tgzhs[1] == undefined?'':tgzhs[1];
                if(cxtData && cxtData[tgzh0]){
                    var cxtInfo = cxtData[tgzh0];
                    obj['CXJG_ID'] = cxtInfo['GUID'];
                    obj['CXJG_CODE'] = cxtInfo['CODE'];
                    obj['CXJG_NAME'] = cxtInfo['NAME'];
                    obj['tgzh_0'] = tgzh0;
                    obj['tgzh_1'] = tgzh1;
                }else if(cxtData && cxtData[tgzh1]){
                    var cxtInfo = cxtData[tgzh1];
                    obj['CXJG_ID'] = cxtInfo['GUID'];
                    obj['CXJG_CODE'] = cxtInfo['CODE'];
                    obj['CXJG_NAME'] = cxtInfo['NAME'];
                    obj['tgzh_0'] = tgzh0;
                    obj['tgzh_1'] = tgzh1;
                }else if(zzdData && zzdData[tgzh0]){
                    var cxtInfo = zzdData[tgzh0];
                    obj['CXJG_ID'] = cxtInfo['GUID'];
                    obj['CXJG_CODE'] = cxtInfo['CODE'];
                    obj['CXJG_NAME'] = cxtInfo['NAME'];
                    obj['tgzh_0'] = tgzh0;
                    obj['tgzh_1'] = tgzh1;
                }else if(zzdData && zzdData[tgzh1]){
                    var cxtInfo = zzdData[tgzh1];
                    obj['CXJG_ID'] = cxtInfo['GUID'];
                    obj['CXJG_CODE'] = cxtInfo['CODE'];
                    obj['CXJG_NAME'] = cxtInfo['NAME'];
                    obj['tgzh_0'] = tgzh0;
                    obj['tgzh_1'] = tgzh1;
                }else{
                    obj['CXJG_ID'] = '';
                    obj['CXJG_CODE'] = '';
                    obj['CXJG_NAME'] = '';
                    obj['tgzh_0'] = tgzh0;
                    obj['tgzh_1'] = tgzh1;
                }
            }
        }
    }
}

// 校验发行金额不能大于计划金额
function cheSJJE(form) {
    var FX_AMT = form.findField('FX_AMT').value;
    var ZQLX_ID = form.findField('ZQLX_ID').value;
    var ZQLX_NAME = form.findField('ZQLX_ID').rawValue;
    //发送ajax请求，校验数据
    $.post("/getJHFXSum.action", {
        YDJH_ID: ydjh_id,
        ZQLX_ID: ZQLX_ID
    }, function (data) {
        // 单位转换 万->亿
        var jhSum = data.sum / 10000;
        if (FX_AMT > jhSum) {
            Ext.Msg.alert("提示", ZQLX_NAME + "的实际发行额不能大于计划发行额(" + jhSum + ")！");
            //实际发行额的值设为计划发行额
            form.findField('FX_AMT').setValue(jhSum);
        }
    }, "json");
}
// 校验发行金额不能大于计划金额
function cheSJJE_SAVE(form) {
    var FX_AMT = form.getForm().findField('FX_AMT').value;
    var ZQLX_ID = form.getForm().findField('ZQLX_ID').value;
    var ZQLX_NAME = form.getForm().findField('ZQLX_ID').rawValue;
    //发送ajax请求，校验数据
    $.post("/getJHFXSum.action", {
        YDJH_ID: ydjh_id,
        ZQLX_ID: ZQLX_ID
    }, function (data) {
        // 单位转换 万->亿
        var jhSum = data.sum / 10000;
        if (FX_AMT > jhSum) {
            Ext.Msg.alert("提示", ZQLX_NAME + "的实际发行额不能大于计划发行额(" + jhSum + ")！");
            //实际发行额的值设为计划发行额
            form.getForm().findField('FX_AMT').setValue(jhSum);
        }
    }, "json");
}