/**
 * 页签：项目基本信息
 */

var z_condition=' and 1=1 ';
var address_Can_Alert='';
var zjtxly_store=DebtEleTreeStoreDB("DEBT_ZJTXLY");//20201126 liyue资金投向领域store
var zwxmlx_store = DebtEleTreeStoreDB("DEBT_ZWXMLX", {condition: z_condition});
var is_zxzqxt = getQueryParam("is_zxzqxt");// 20200818_zhuangrx_湖北个性参数，这里用来控制是否添加工程类别字段
Ext.define('sjxmModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id',mapping:'DXM_ID'},
        {name: 'name',mapping:'DXM_NAME'}
    ]
});
function initWindow_zqxxtb_contentForm_tab_jbqk(IS_SZYS) {
    var json_debt_isorno = [
        {id: "0", code: "0", name: "否"},
        {id: "1", code: "1", name: "是"}
    ];
    var editPanel = Ext.create('Ext.form.Panel', {
        name: 'jbqkForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        defaults: {
            margin: '2 5 2 5'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                anchor: '100%',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    //width: 315,
                    labelWidth: 140//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '项目单位',
                        name: "AG_NAME",
                        allowBlank: false,
                        editable: false,
                        hidden: true,
                        value: AG_NAME,
                        validator: vd
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目编码',
                        name: "XM_CODE",
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        id:"XM_NAME",
                        fieldLabel: is_cl == '1' ? '项目名称' : '<span class="required">✶</span>项目名称',
                        name: "XM_NAME",
                        readOnly: is_cl == '1',
                        allowBlank: false,
                        emptyText: '请输入...',
                        validator: vd,
                        fieldStyle: is_cl == '1' ? 'background:#E6E6E6' : null
                    },
                    {
                        xtype: "combobox",
                        name: "LX_YEAR",
                        store: DebtEleStore(json_debt_year),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>立项年度',
                        allowBlank: false,
                        editable: false, //禁用编辑
                        value: new Date().getFullYear()
                    },
                    {
                        fieldLabel: sysAdcode == '12'?'<span class="required">✶</span>所属主管部门':'所属主管部门',
                        name: 'SS_ZGBM_ID',
                        xtype: 'combobox',
                        editable: false,
                        rootVisible: false,
                        hidden: AD_CODE.substring(0,2) == '21' ? false:true,
                        //allowBlank: sysAdcode == '21' ? false:true,
                        displayField: 'name',
                        valueField: 'id',
                        store: DebtEleTreeStoreDBTable("DSY_V_ELE_AG_ZGBM",{condition:"and condition='"+AD_CODE+"'"})
                    },
                    {
                        xtype: "textfield",
                        allowBlank: false,
                        validator: vd,
                        emptyText: '点击地图定位图标选择项目地址',
                        fieldLabel: '<span class="required">✶</span>项目地址<img src="/image/common/locate.png" style="height: 31px;position: absolute;top:26px" onclick="clickToMapInfo()"/>',
                        name: 'XM_ADDRESS'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目地址（经度）',
                        name: 'LNG',
                        hidden:true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目地址（纬度）',
                        name: 'LAT',
                        hidden:true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '预算管理一体化编码',
                        name: 'YSXM_NO',
                        hidden:true
                    },

                    {
                        fieldLabel: '国库支付项目编码',
                        name: 'GK_PAY_XMNO',
                        maxLength : 38 ,
                        hidden:true,
                        maxLengthText : '输入编码过长，只能输入38位！'
                    },
                    {
                        xtype: "combobox",
                        name: "IS_FGW_XM",
                        store: DebtEleStore(json_debt_isorno),
                        fieldLabel: '<span class="required">✶</span>是否列入重大项目库',
                        displayField: 'name',
                        valueField: 'id',
                        value: 1,
                        allowBlank: false,
                        editable: false,
                        listeners: {
                            change: function (self, newValue) {
                                if(!self.getValue()){
                                    return;
                                }
                                var fgw_xmk_code = this.up('form').getForm().findField('FGW_XMK_CODE');
                                if (newValue == '1') {
                                    fgw_xmk_code.allowBlank = false;
                                    fgw_xmk_code.setFieldLabel('<span class="required">✶</span>发改委审批监管代码');
                                } else {
                                    fgw_xmk_code.allowBlank = true;
                                    fgw_xmk_code.setFieldLabel('发改委审批监管代码');
                                }
                            }
                        }
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>发改委审批监管代码',
                        name: 'FGW_XMK_CODE',
                        allowBlank: false,
                        //maxLength : 50 ,
                        regex:/(\b^([a-zA-Z0-9]{4}\-[a-zA-Z0-9]{6}\-[a-zA-Z0-9]{2}\-[a-zA-Z0-9]{2}\-[a-zA-Z0-9]{6}$)\b)/,
                        regexText:'发改委审批监管代码格式错误',
                        emptyText: 'XXXX-XXXXXX-XX-XX-XXXXXX'
                        //maxLengthText : '输入字符过长，只能输入50个字符'
                    },/*,
                     {
                     xtype: "numberFieldFormat",
                     name: "XMZGS_AMT",
                     fieldLabel: '<span class="required">✶</span>项目总概算（万元）',
                     emptyText: '0.00',
                     allowDecimals: true,
                     decimalPrecision: 6,
                     hideTrigger: true,
                     keyNavEnabled: true,
                     mouseWheelEnabled: true,
                     plugins: Ext.create('Ext.ux.FieldStylePlugin', {})

                     }*/

                    {
                        fieldLabel:sysAdcode=='42' || AD_CODE=='12' || AD_CODE=='1200' ? '<span class="required">✶</span>归口处室':'归口处室',
                        name: 'MB_ID',
                        xtype: 'combobox',
                        editable: false,
                        displayField: 'name',
                        valueField: 'id',
                        allowBlank: true,
                        store:DebtEleStoreTable('DSY_V_ELE_FINDEP',{condition:" AND (extend1 = '"+
                        (AD_CODE.length<6&&AD_CODE.substr(-2,2)!='00'?AD_CODE+"00":AD_CODE)+"' OR EXTEND1 IS NULL ) "}),
                        hidden:true
                    },

                    {
                        fieldLabel: '<span class="required">✶</span>建设单位',
                        name: 'USE_UNIT_ID',
                        allowBlank: true,
                        hidden:true,
                        value:AG_NAME
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>建设单位统一社会信用代码',
                        name: 'JSDW_TYSHXY',
                        allowBlank: true,
                        hidden:true,
                        labelWidth: 180,
                        value:USCCODE,
                        //regex:  /(^[A-Z0-9]{18}$)/,
                        // regexText : '统一社会信用代码只能为18位（可包含大写字母、数字）'
                    },
                    // {
                    //     xtype: "textfield",
                    //     fieldLabel: '占位',
                    //     name: "ZHANWEI",
                    //     fieldStyle: 'background:#E6E6E6',//置灰
                    //     editable: false,
                    //     style: "visibility:hidden"
                    // },
                    {
                        fieldLabel: '<span class="required">✶</span>运营单位',
                        name: 'YY_UNIT_ID',
                        allowBlank: true,
                        hidden:true,
                        value:AG_NAME
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>运营单位统一社会信用代码',
                        name: 'YYDW_TYSHXY',
                        allowBlank: true,
                        hidden:true,
                        labelWidth: 180,
                        value:USCCODE,
                        //regex:  /(^[A-Z0-9]{18}$)/,
                        // regexText : '统一社会信用代码只能为18位（可包含大写字母、数字）'
                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                width: '100%',
                anchor: '100%',
                margin: '2 5 2 5',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                anchor: '100%',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    //width: 315,
                    labelWidth: 140//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "combobox",
                        name: "JSXZ_ID",
                        store: DebtEleStoreDB("DEBT_XMJSXZ", {condition: "AND GUID !='03' "}),
                        fieldLabel: '<span class="required">✶</span>建设性质',
                        displayField: 'name',
                        valueField: 'id',
                        allowBlank: true,
                        editable: false,
                        hidden:true
                    },
                    {
                        xtype: 'treecombobox',
                        fieldLabel: is_cl == '1' ? '项目性质' : '<span class="required">✶</span>项目性质',
                        name: 'XMXZ_ID',
                        displayField: 'name',
                        valueField: 'id',
                        rootVisible: false,
                        editable: false, //禁用编辑
                        lines: false,
                        //  allowBlank: false,
                        hidden:true,
                        readOnly: is_cl == '1',
                        selectModel: 'leaf',
                        store: DebtEleTreeStoreDB("DEBT_ZJYT", {condition: xmxzCondition}),
                        fieldStyle: is_cl == '1' ? 'background:#E6E6E6' : null,
                        listeners: {
                            change: function (self, newValue) {
                                if(!self.getValue()){
                                    return;
                                }
                                /*  if(node_type!='typing'&&node_type!='xmtz'){
                                      //根据资金投向领域加载项目类型方法
                                      getstore();
                                  }*/
                                var XMXZ_ID = this.up('form').getForm().findField('XMXZ_ID');
                               /* if (XMXZ_ID.value == '010102') {
                                    var xmsy_ycyj = self.up('form').down('textarea[name="XMSY_YCYJ"]');
                                    xmsy_ycyj.setFieldLabel('<span class="required">✶</span>' + '项目收益预测依据');
                                    xmsy_ycyj.allowBlank = false;
                                } else {
                                    var xmsy_ycyj = self.up('form').down('textarea[name="XMSY_YCYJ"]');
                                    xmsy_ycyj.setFieldLabel('项目收益预测依据');
                                    xmsy_ycyj.allowBlank = true;
                                }*/
                            }
                        }
                    },
                    {
                        xtype: "treecombobox",
                        name: "GJZDZLXM_ID",
                        store: DebtEleTreeStoreDB("DEBT_GJZDZLXM"),
                        fieldLabel: '<span class="required">✶</span>重大战略项目',
                        displayField: 'name',
                        valueField: 'id',
                        rootVisible: false,
                        lines: false,
                        allowBlank: false,
                        selectModel: 'leaf'
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZJTXLY_ID",
                        store: zjtxly_store,
                        fieldLabel: '<span class="required">✶</span>资金投向领域',
                        displayField: 'name',
                        valueField: 'id',
                        rootVisible: false,
                        lines: false,
                        allowBlank: false,
                        selectModel: 'leaf',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                if(node_type!='typing'&&node_type!='xmtz'||button_name=='UPDATE'){
                                    getstore();
                                }
                            }
                        }
                    },
                    {
                        xtype: 'treecombobox',
                        fieldLabel: is_cl == '1' ? '项目类型' : '<span class="required">✶</span>项目类型',
                        name: 'XMLX_ID',
                        displayField: 'name',
                        valueField: 'id',
                        rootVisible: false,
                        editable: false, //禁用编辑
                        lines: false,
                        allowBlank: is_cl == '1' ? true : false,
                        readOnly: is_cl == '1',
                        selectModel: 'leaf',
                        store: zwxmlx_store,
                        fieldStyle: is_cl == '1' ? 'background:#E6E6E6' : null,
                        listeners: {
                            select:function (self){
                            /*    if (self.getValue() == '05') {
                                    field_names = '土地面积(公顷)';
                                    field_names_dk = '地块GIS';
                                    field_names_cb = '储备期限';
                                }else if(self.getValue().substring(0, 2) == '02') {
                                    field_names = '通车里程(公里)';
                                    field_names_dk = '车辆购置税';
                                    field_names_cb = '车辆通行费征收标准';
                                }else if (self.getValue().substring(0, 2) == '06') {
                                    field_name = '棚改范围';
                                    field_names_dk = '规模户数';
                                    field_names_cb = '标准';
                                }
                                var rink = Ext.ComponentQuery.query('fieldset[name="shrink"]')[0];
                                var variable = Ext.ComponentQuery.query('textfield[name="LXDW"]')[0];
                                if (self.getValue() == '05'||self.getValue().substring(0, 2) == '02') {
                                    variable.setFieldLabel(field_names);
                                    rink.setExpanded(true);
                                    rink.setHidden(false);
                                    variable.setVisible(true);
                                } else {
                                    rink.setExpanded(false);
                                    variable.setValue(0);
                                    variable.setVisible(false);
                                    variable.allowBlank = true;
                                }
                                var variable4 = Ext.ComponentQuery.query('textfield[name="LXDW4"]')[0];
                                if (self.getValue().substring(0, 2) == '06') {
                                    variable4.setFieldLabel(field_name);
                                    rink.setExpanded(true);
                                    rink.setHidden(false);
                                    variable4.setVisible(true);
                                } else {
                                    rink.setExpanded(false);
                                    variable4.setValue("");
                                    variable4.setVisible(false);
                                    variable4.allowBlank = true;
                                }
                                var variable2 = Ext.ComponentQuery.query('textfield[name="LXDW2"]')[0];
                                if (self.getValue() == '05'||self.getValue().substring(0, 2) == '02'||self.getValue().substring(0, 2) == '06') {
                                    variable2.setFieldLabel(field_names_dk);
                                    rink.setExpanded(true);
                                    rink.setHidden(false);
                                    variable2.setVisible(true);
                                } else {
                                    rink.setExpanded(false);
                                    variable2.setValue(0);
                                    variable2.setVisible(false);
                                    variable2.allowBlank = true;
                                }
                                var variable3 = Ext.ComponentQuery.query('textfield[name="LXDW3"]')[0];
                                if (self.getValue() == '05'||self.getValue().substring(0, 2) == '02'||self.getValue().substring(0, 2) == '06') {
                                    variable3.setFieldLabel(field_names_cb);
                                    rink.setExpanded(true);
                                    rink.setHidden(false);
                                    variable3.setVisible(true);
                                } else {
                                    rink.setExpanded(false);
                                    variable3.setValue(0);
                                    variable3.setVisible(false);
                                    variable3.allowBlank = true;
                                }
                                variable.setValue("");
                                variable2.setValue("");
                                variable3.setValue("");
                                variable4.setValue("");*/
                            },
                            change:  function (self) {
                                if(!self.getValue()){
                                    return;
                                }
                                if(isOld_szysGrid == '0' && IS_SZYS != '3'){
                                    // 调用公共方法：如果是项目类型是土地存储则重新初始化收支预算grid
                                    change_tdcbysbz_grid(self,{XM_ID:XM_ID,IS_SZYS:IS_SZYS});
                                }
                                /*if (self.getValue() == '05') {
                                    field_names = '土地面积(公顷)';
                                    field_names_dk = '地块GIS';
                                    field_names_cb = '储备期限';
                                }else if(self.getValue().substring(0, 2) == '02') {
                                    field_names = '通车里程(公里)';
                                    field_names_dk = '车辆购置税';
                                    field_names_cb = '车辆通行费征收标准';
                                }else if (self.getValue().substring(0, 2) == '06') {
                                    field_names = '棚改范围';
                                    field_names_dk = '规模户数';
                                    field_names_cb = '标准';
                                }
                                var rink = Ext.ComponentQuery.query('fieldset[name="shrink"]')[0];
                                var variable = Ext.ComponentQuery.query('textfield[name="LXDW"]')[0];
                                if (self.getValue() == '05'||self.getValue().substring(0, 2) == '02') {
                                    variable.setFieldLabel(field_names);
                                    rink.setExpanded(true);
                                    rink.setHidden(false);
                                    variable.allowBlank = true;
                                    variable.setVisible(true);
                                } else {
                                    rink.setExpanded(false);
                                    variable.setValue(0);
                                    variable.setVisible(false);
                                    variable.allowBlank = true;
                                }
                                var variable4 = Ext.ComponentQuery.query('textfield[name="LXDW4"]')[0];
                                if (self.getValue().substring(0, 2) == '06') {
                                    variable4.setFieldLabel(field_names);
                                    rink.setExpanded(true);
                                    rink.setHidden(false);
                                    variable4.allowBlank = true;
                                    variable4.setVisible(true);
                                } else {
                                    rink.setExpanded(false);
                                    variable4.setValue("");
                                    variable4.setVisible(false);
                                    variable4.allowBlank = true;
                                }
                                var variable2 = Ext.ComponentQuery.query('textfield[name="LXDW2"]')[0];
                                if (self.getValue() == '05'||self.getValue().substring(0, 2) == '02'||self.getValue().substring(0, 2) == '06') {
                                    variable2.setFieldLabel(field_names_dk);
                                    rink.setExpanded(true);
                                    rink.setHidden(false);
                                    variable2.allowBlank = true;
                                    variable2.setVisible(true);
                                } else {
                                    rink.setExpanded(false);
                                    variable2.setValue(0);
                                    variable2.setVisible(false);
                                    variable2.allowBlank = true;
                                }
                                var variable3 = Ext.ComponentQuery.query('textfield[name="LXDW3"]')[0];
                                if (self.getValue() == '05'||self.getValue().substring(0, 2) == '02'||self.getValue().substring(0, 2) == '06') {
                                    variable3.setFieldLabel(field_names_cb);
                                    rink.setExpanded(true);
                                    rink.setHidden(false);
                                    variable3.allowBlank = true;
                                    variable3.setVisible(true);
                                } else {
                                    rink.setExpanded(false);
                                    variable3.setValue(0);
                                    variable3.setVisible(false);
                                    variable3.allowBlank = true;
                                }*/
                            }
                        }
                    },
                    {
                        fieldLabel:"国土部门监管码",
                        name:'DISC',
                        xtype:"textfield",
                        editable:true,
                        hidden:true
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>立项审批依据',
                        name: 'LXSPYJ_ID',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        //hidden: is_cl == '1',
                        store: DebtEleStore(json_debt_lxspyj),
                        //allowBlank: false,
                        editable: false,
                        hidden:true
                    },
                    {
                        xtype: "combobox",
                        name: "SP_LEVEL_ID",
                        store: DebtEleStore(json_debt_lxspjc),
                        fieldLabel: '<span class="required">✶</span>立项审批级次',
                        displayField: 'name',
                        valueField: 'id',
                        //allowBlank: false,
                        editable: false,
                        hidden:true
                    }, {
                        //xtype: "treecombobox",
                        xtype: "combobox",
                        name: "LXSPBM_ID",
                        //store: DebtEleTreeStoreDB("DEBT_ZGBM"),
                        //store: DebtEleTreeStoreDBTable("DSY_V_ELE_AG",{condition:"and levelno = '1' and condition="+AD_CODE}),
                        store: DebtEleTreeStoreDBTable("DSY_V_ELE_AG_ZGBM",{condition:"and condition='"+AD_CODE+"'"}),//20210517liyue立项审批部门去取左侧单位树，非低级区划
                        fieldLabel: '<span class="required">✶</span>立项审批部门',
                        displayField: 'name',
                        valueField: 'id',
                        rootVisible: false,
                        lines: false,
                        // allowBlank: false,
                        hidden:true
                        // editable: false//20210909LIYUEy添加下拉框不可编辑事件
                        /*,
                        selectModel: 'leaf'*/
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目建议书文号',
                        //hidden: is_cl == '1',
                        name: 'JYS_NO',
                        hidden:true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '可研批复文号',
                        //hidden: is_cl == '1',
                        name: 'PF_NO',
                        hidden:true
                    },
                    {
                        xtype: "treecombobox",
                        name: 'GCLB_ID',
                        store: DebtEleTreeStoreDB("DEBT_GCLB", {condition: z_condition}),
                        fieldLabel: '<span class="required">✶</span>工程类别',
                        displayField: 'name',
                        valueField: 'id',
                        allowBlank: sysAdcode=='42' ? false:true,
                        hidden:sysAdcode=='42'?false:true,
                        editable: false, //禁用编辑
                        selectModel: 'leaf'
                    },
                    {
                        xtype: 'treecombobox',
                        fieldLabel: '<span class="required">✶</span>补短板产业类型',
                        name: 'CYLX_ID',
                        displayField: 'name',
                        valueField: 'id',
                        rootVisible: false,
                        lines: false,
                        allowBlank: true,
                        editable: false, //禁用编辑
                        selectModel: 'leaf',
                        hidden:true,
                        store: DebtEleTreeStoreDB("DEBT_BDBCYLX")
                    },
                    {    //20211016 zhuangrx 新增项目资产权属字段
                        xtype: 'combobox',
                        fieldLabel: '<span class="required">✶</span>项目资产权属',
                        name: 'XMZCQS_ID',
                        displayField: 'name',
                        valueField: 'id',
                        editable: false, //禁用编辑
                        store: DebtEleTreeStoreDBTable("DSY_V_ELE_XMZCQS"),
                        allowBlank: false
                    },
                    {
                        xtype: "textfield",//20201126liyue项目类型与资金投向级联对应关系所需查询字段
                        fieldLabel: 'EXTEND1',
                        hidden:true,
                        name: 'EXTEND1',
                        listeners: {
                            /*  'change': function (self,newValue) {
                                  debugger;
                                  var extend=newValue.substring(1,3);
                                  zjtxly_store.getProxy().extraParams.condition = encode64(" AND CODE LIKE '"+extend+"%'");
                                  zjtxly_store.load();
                              }*/
                        }
                    }
                ]
            },
            {
                xtype: 'fieldset',
                layout: 'column',
                name: 'shrink',
                defaultType: 'textfield',
                hidden:true,
                border:false,
                padding: '5 5 0 5',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    labelWidth: 136//控件默认标签宽度
                },
                items: [
                    {
                        name:'LXDW',
                        fieldLabel: '变量',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        autoLoad : true,
                        maxValue:9999999,
                        // minValue:0,
                        hidden:true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        name:'LXDW4',
                        fieldLabel: '变量4',
                        xtype: 'textfield',
                        hideTrigger: true,
                        autoLoad : true,
                        maxLength:20,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入20个汉字！",
                        hidden:true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        name:'LXDW2',
                        fieldLabel: '变量2',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        autoLoad : true,
                        maxValue:9999999,
                        // minValue:0,
                        hidden:true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    },
                    {
                        name:'LXDW3',
                        fieldLabel: '变量3',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        autoLoad : true,
                        maxValue:9999999,
                        // minValue:0,
                        hidden:true,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                width: '100%',
                anchor: '100%',
                margin: '2 5 2 5',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                anchor: '100%',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .33,
                    //width: 315,
                    labelWidth: 140//控件默认标签宽度
                },
                items: [
                    {
                        fieldLabel: '<span class="required">✶</span>建设状态',
                        name: "BUILD_STATUS_ID",
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        store: node_type=='tb'?DebtEleTreeStoreDB("DEBT_XMJSZT", {condition: "AND GUID !='02' AND GUID !='03'AND GUID !='04'AND GUID !='05' "}):
                            DebtEleTreeStoreDB("DEBT_XMJSZT"),
                        allowBlank: false,
                        editable:false,
                        /*              listeners: {
                                          'change': function (self, newValue, oldValue) {
                                              // 项目变更下建设状态为03/04执行
                                              if(IS_SZYS.IS_SZYS == '3'){
                                                  if(self.getValue() == '03' || self.getValue() == '04'){
                                                      setSjDateReadOnly(false);
                                                  }else{
                                                      setSjDateReadOnly(true);
                                                  }
                                              }
                                          }
                                      }*/
                        listeners: {
                            change: function (self, newValue) {

                                //initWindow_zqxxtb_contentForm_tab_jbqk_refreshForm();
                            }
                        }
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>计划开工日期', name: "START_DATE_PLAN", xtype: "datefield",hidden:'true',
                        format: 'Y-m-d', blankText: '请选择开始日期', emptyText: '请选择开始日期', value: today, vtype: 'comparePlanDate'
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>计划竣工日期', name: "END_DATE_PLAN", xtype: "datefield",hidden:'true',
                        allowBlank: true, format: 'Y-m-d',  vtype: 'comparePlanDate'
                    },
                    {fieldLabel: '<span class="required">✶</span>单位项目负责人', /*hidden: is_cl == '1',*/name: 'BILL_PERSON',  hidden:true,
                        maxLength : 20,
                        maxLengthText : '输入字符过长，只能输入20个字！'
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>开工日期',
                        name: 'START_DATE_ACTUAL',
                        allowBlank: false,
                        xtype: 'datefield',
                        format: 'Y-m-d',
                        editable: true,
                        //    vtype: 'compareActualDate',
                        listeners: {
                            'change': function (self, newValue) {
                                if(typeof (CommonListenersFunction) == 'function' && isOld_szysGrid == '0' && IS_SZYS != '3' ){
                                    CommonListenersFunction(self, newValue,{XM_ID: XM_ID}); // 公共的监听事件：兼容历史数据未填写收支预算的情况，只能使用change事件
                                }
                            }
                        }
                    },
                    {fieldLabel: '<span class="required">✶</span>竣工日期', name: "END_DATE_ACTUAL", allowBlank: false,
                        xtype: "datefield", format: 'Y-m-d',  editable: true, vtype: 'compareActualDate'},
                    {fieldLabel: '<span class="required">✶</span>负责人联系电话',/*hidden: is_cl == '1',*/ name: 'BILL_PHONE',/* allowBlank: false,*/hidden:true,
                        /*regex:/^(?:0[0-9]{2,3}[-\\s]{1}|\\(0[0-9]{2,4}\\))[0-9]{6,8}$|^[1-9]{1}[0-9]{5,7}$|^[1-9]{1}[0-9]{10}$/,
                        regexText:'手机号码格式有误，请重填'*/},
                    {
                        // fieldLabel: '上级项目',
                        fieldLabel: is_wzxt=='1' ?'<span class="required">✶</span>上级项目':'上级项目',
                        name: 'UPPER_XM_ID',
                        xtype:  is_wzxt=='1'?'combobox':'treecombobox',
                        displayField: 'name',
                        valueField: is_wzxt=='1'?'id':'name',
                        selectModel: 'leaf',
                        allowBlank: is_wzxt=='1' ? false:true,
                        // allowBlank: true,
                        //hidden: is_cl == '1',
                        store: is_wzxt=='1' ? getSjxmStore({AD_CODE:AD_CODE}) : DebtEleTreeStoreDB('DEBT_SJXM'),
                        editable: false,
                        hidden:true
                    },

                ]
            },
            {//分割线
                xtype: 'menuseparator',
                width: '100%',
                anchor: '100%',
                margin: '2 5 2 5',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                anchor: '100%',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: 0.99,
                    //width: 315,
                    labelWidth: 140//控件默认标签宽度
                },
                items: [
                    {
                        fieldLabel: '<span class="required">✶</span>项目主要建设内容和规模（<a class="divcss5-x5" href="#" onclick="downloadJsxmnrTbsm()" style="color:#3329ff;">填报说明</a>）',
                        name: 'BUILD_CONTENT',
                        xtype: 'textarea',
                        allowBlank: false,
                        maxLength:1000,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入1000个汉字！",
                        minLength:100,
                        minLengthText:"输入内容过短，最少输入100个汉字！"
                    },
                    {
                        fieldLabel: '项目收益预测依据',
                        name: 'XMSY_YCYJ',
                        xtype: 'textarea',
                        hidden:true,
                        allowBlank: true,
                        maxLength:1000,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入1000个汉字！"
                    }
                ]
            },
            /*{//分割线
                xtype: 'menuseparator',
                width: '100%',
                anchor: '100%',
                margin: '2 0 2 0',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                anchor: '100%',
                //hidden: is_rzpt == 1 ? false : true,
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    //width: 315,
                    labelWidth: 140//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "combobox",
                        name: "IS_PPP",
                        store: DebtEleStore(json_debt_sf),
                        fieldLabel: '<span class="required">✶</span>是否PPP项目',
                        displayField: 'name',
                        valueField: 'id',
                        value: 0,
                        allowBlank: false,
                        editable: false,
                        columnWidth: .33,
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var pppyzfs = self.up('form').down('[name=PPP_YZFS]');
                                pppyzfs.setDisabled(newValue == '0');
                                var hbfsppp = self.up('form').down('[name=PPP_HBFS]');
                                hbfsppp.setDisabled(newValue == '0');
                                var scjdppp = self.up('form').down('[name=PPP_SCJD]');
                                scjdppp.setDisabled(newValue == '0');
                                var hzyezr = self.up('form').down('[name=HZQX]');
                                hzyezr.setDisabled(newValue == '0');
                                var PPPRKQK = self.up('form').down('[name=PPP_RKQK_ID]');
                                PPPRKQK.setDisabled(newValue == '0');
                                var form = self.up('form').getForm();
                                var XMJSQ_START = form.findField('XMJSQ_START');
                                var XMJSQ_END = form.findField('XMJSQ_END');
                                var XMYYQ_START = form.findField('XMYYQ_START');
                                var XMYYQ_END = form.findField('XMYYQ_END');
                                var IS_XCCBSSFA = form.findField('IS_XCCBSSFA');
                                var IS_TGCZCSNLLZ = form.findField('IS_TGCZCSNLLZ');
                                var IS_TGWUSZPJ = form.findField('IS_TGWUSZPJ');
                                //var store_xmxz = this.up('form').getForm().findField('XMXZ_ID').store;
                                if(newValue == "1"){
                                   /!* store_xmxz.proxy.extraParams['condition'] = encode64(" and guid not in ('0102')");
                                    store_xmxz.load();
                                    var xmxz = this.up('form').getForm().findField('XMXZ_ID').getValue();
                                    if(xmxz == '' || xmxz == null || xmxz == undefined){
                                        this.up('form').getForm().findField('XMXZ_ID').setValue("010102");
                                    }*!/
                                    XMJSQ_START.setDisabled(false);
                                    XMJSQ_END.setDisabled(false);
                                    XMYYQ_START.setDisabled(false);
                                    XMYYQ_END.setDisabled(false);
                                    IS_XCCBSSFA.setDisabled(false);
                                    IS_TGCZCSNLLZ.setDisabled(false);
                                    IS_TGWUSZPJ.setDisabled(false);
                                } else {
                                    /!*this.up('form').getForm().findField('XMXZ_ID').setValue("");
                                    store_xmxz.proxy.extraParams['condition'] = "";
                                    store_xmxz.load();*!/
                                    XMJSQ_START.setDisabled(true);
                                    XMJSQ_END.setDisabled(true);
                                    XMYYQ_START.setDisabled(true);
                                    XMYYQ_END.setDisabled(true);
                                    IS_XCCBSSFA.setDisabled(true);
                                    IS_TGCZCSNLLZ.setDisabled(true);
                                    IS_TGWUSZPJ.setDisabled(true);
                                    pppyzfs.setValue('');
                                    hbfsppp.setValue('');
                                    scjdppp.setValue('');
                                    hzyezr.setValue('');
                                    PPPRKQK.setValue('');
                                    XMJSQ_START.setValue('');
                                    XMJSQ_END.setValue('');
                                    XMYYQ_START.setValue('');
                                    XMYYQ_END.setValue('');
                                    IS_XCCBSSFA.setValue(0);
                                    IS_TGCZCSNLLZ.setValue(0);
                                    IS_TGWUSZPJ.setValue(0);
                                }
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: 'PPP_YZFS',
                        store: DebtEleStoreDB("DEBT_PPPXMYZFS"),
                        fieldLabel: 'PPP项目运作方式',
                        displayField: 'name',
                        valueField: 'id',
                        columnWidth: .33,
                        disabled: true,
                        editable: false
                    },
                    {
                        xtype: "combobox",
                        name: 'PPP_HBFS',
                        store: DebtEleStoreDB("DEBT_PPPXMHBJZ"),
                        fieldLabel: 'PPP项目回报机制',
                        displayField: 'name',
                        valueField: 'id',
                        columnWidth: .33,
                        disabled: true,
                        editable: false
                    },
                    {
                        xtype: "combobox",
                        name: 'PPP_SCJD',
                        store: DebtEleStoreDB("DEBT_PPPXMSCJD"),
                        fieldLabel: 'PPP项目所处阶段',
                        displayField: 'name',
                        valueField: 'id',
                        columnWidth: .33,
                        disabled: true,
                        editable: false
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '合作期限（年）',
                        disabled: true,
                        minValue:'0',
                        hideTrigger: true,
                        keyNavEnabled: true,
                        mouseWheelEnabled: true,
                        columnWidth: .33,
                        name: 'HZQX'
                    },
                    {
                        xtype: "combobox",
                        name: 'PPP_RKQK_ID',
                        store: DebtEleStoreDB("DEBT_PPPXMRKQK"),
                        fieldLabel: 'PPP项目入库情况',
                        displayField: 'name',
                        valueField: 'id',
                        columnWidth: .33,
                        disabled: true,
                        editable: false
                    },
                    {
                        xtype: 'container',
                        layout: 'column',
                        defaultType: 'textfield',
                        columnWidth: 1,
                        defaults: {
                            margin: '4 0 2 0',
                            //width: 315,
                            labelWidth: 140//控件默认标签宽度
                        },
                        items: [
                            {
                                xtype: "label",
                                text: '项目建设期:',
                                width: 140
                            },
                            {
                                xtype: "label",
                                text: '自',
                            },
                            {
                                xtype: "numberfield",
                                name: 'XMJSQ_START',
                                hideTrigger: true,
                                keyNavEnabled: true,
                                mouseWheelEnabled: true,
                                allowDecimals: false,
                                disabled:true,
                                fieldStyle: 'text-align: right',
                                minValue:0,
                                margin:'0 2 0 2',
                                width: 60
                            },
                            {
                                xtype: "label",
                                text: '年',
                                width: 70
                            },
                            {
                                xtype: "label",
                                text: '到',
                            },
                            {
                                xtype: "numberfield",
                                name: 'XMJSQ_END',
                                hideTrigger: true,
                                keyNavEnabled: true,
                                mouseWheelEnabled: true,
                                allowDecimals: false,
                                disabled:true,
                                fieldStyle: 'text-align: right',
                                minValue:0,
                                margin:'0 2 0 2',
                                width: 60
                            },
                            {
                                xtype: "label",
                                text: '年',
                            },
                            {
                                xtype: "label",
                                text: '项目运营期:',
                                margin: '2 0 2 40',
                                width: 140
                            },
                            {
                                xtype: "label",
                                text: '自',
                            },
                            {
                                xtype: "numberfield",
                                name: 'XMYYQ_START',
                                hideTrigger: true,
                                keyNavEnabled: true,
                                mouseWheelEnabled: true,
                                allowDecimals: false,
                                disabled:true,
                                fieldStyle: 'text-align: right',
                                minValue:0,
                                margin:'0 2 0 2',
                                width: 60
                            },
                            {
                                xtype: "label",
                                text: '年',
                                width: 70
                            },
                            {
                                xtype: "label",
                                text: '到',
                            },
                            {
                                xtype: "numberfield",
                                name: 'XMYYQ_END',
                                hideTrigger: true,
                                keyNavEnabled: true,
                                mouseWheelEnabled: true,
                                allowDecimals: false,
                                disabled:true,
                                fieldStyle: 'text-align: right',
                                minValue:0,
                                margin:'0 2 0 2',
                                width: 60
                            },
                            {
                                xtype: "label",
                                text: '年',
                            }
                        ]
                    },
                    {
                        name: 'IS_TGWUSZPJ',
                        boxLabel: '通过物有所值评价',
                        xtype: "checkboxfield",
                        inputValue: '1',
                        uncheckedValue: '0',
                        disabled:true,
                        columnWidth: .33,
                        margin: '2 5 2 5',
                        labelWidth: 250//控件默认标签宽度
                    },
                    {
                        name: 'IS_TGCZCSNLLZ',
                        boxLabel: '通过财政承受能力论证',
                        xtype: "checkboxfield",
                        inputValue: '1',
                        disabled:true,
                        columnWidth: .33,
                        uncheckedValue: '0',
                        margin: '2 5 2 5',
                        labelWidth: 250//控件默认标签宽度
                    },
                    {
                        name: 'IS_XCCBSSFA',
                        boxLabel: '形成初步实施方案',
                        xtype: "checkboxfield",
                        disabled:true,
                        inputValue: '1',
                        uncheckedValue: '0',
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        labelWidth: 250//控件默认标签宽度
                    }
                ]
            }*/
        ],
        listeners: {
            'beforeRender': function (editor, context) {
                if (is_view == "1" || button_name == 'VIEW') {
                    SetItemReadOnly(this.items);
                }
                if(node_type=='typing'||node_type=='jhtb'||node_type=='xmtz'){
                    getzjtxstore();
                }
            }
        }

    });
    return editPanel;
}

/**
 * 页签：项目投资计划
 * @returns {Ext.form.Panel}
 */
function initWindow_zqxxtb_contentForm_tab_tzjh() {
    return Ext.create('Ext.form.Panel', {
        name: 'tzjhForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        padding: '0 10 0 10',
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldset',
                title: '投资计划总计',
                layout: 'column',
                defaultType: 'textfield',
                anchor: '100%',
                collapsible: false,
                fieldDefaults: {
                    labelWidth: 110,
                    columnWidth: .25,
                    labelAlign:'left',
                    //labelStyle:'text-align:center;',
                    margin: '2 5 5 5',
                },
                items: [
                    {
                        fieldLabel: '项目总概算',
                        name: 'TZJH_XMZGS_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '项目总概算备份',
                        name: 'TZJH_XMZGS_AMT_BAK',
                        xtype: 'numberFieldFormat',
                        hidden: true
                    },
                    {
                        fieldLabel: '项目资本金总额',
                        name: 'ZBJ_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue:0,
                        decimalPrecision:2,
                        value: 0,
                        readOnly:false,
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var ZBJ_AMT = form.findField('ZBJ_AMT').getValue() ;
                                var XMZGS_AMT = form.findField('TZJH_XMZGS_AMT').getValue() ;
                                if(ZBJ_AMT - XMZGS_AMT > 0.0000001){
                                    Ext.Msg.alert("提示","项目资本金总额不能大于项目总概算！") ;
                                    form.findField('ZBJ_AMT').setValue(0);
                                    return;
                                }
                            }
                        }
                    },
                    {
                        fieldLabel: '其中财政预算安排',
                        name: 'ZBJ_YS_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue:0,
                        decimalPrecision:2,
                        value: 0,
                        readOnly:false,
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var ZBJ_AMT = form.findField('ZBJ_AMT').getValue() ;
                                var ZBJ_ZQ_AMT = form.findField('ZBJ_ZQ_AMT').getValue() ;
                                var ZBJ_YS_AMT = form.findField('ZBJ_YS_AMT').getValue() ;
                                if((ZBJ_ZQ_AMT+ZBJ_YS_AMT) - ZBJ_AMT > 0.0000001){
                                    Ext.Msg.alert("提示","其中财政预算安排资金与专项债券安排资金之和不能大于项目资本金总额！") ;
                                    form.findField('ZBJ_YS_AMT').setValue(0);
                                    return;
                                }
                            }
                        }
                    },
                    {
                        fieldLabel: '其中专项债券安排',
                        name: 'ZBJ_ZQ_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue:0,
                        decimalPrecision:2,
                        value: 0,
                        readOnly:false,
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var ZBJ_AMT = form.findField('ZBJ_AMT').getValue() ;
                                var ZBJ_YS_AMT = form.findField('ZBJ_YS_AMT').getValue() ;
                                var ZBJ_ZQ_AMT = form.findField('ZBJ_ZQ_AMT').getValue() ;
                                if((ZBJ_ZQ_AMT+ZBJ_YS_AMT) - ZBJ_AMT > 0.0000001){
                                    Ext.Msg.alert("提示","其中财政预算安排资金与专项债券安排资金之和不能大于项目资本金总额！") ;
                                    form.findField('ZBJ_ZQ_AMT').setValue(0);
                                    return;
                                }
                            }
                        }
                    },
                    {
                        fieldLabel: '市场化融资资金',
                        name: 'SCHRZ_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '累计完成投资',
                        name: 'LJWCTZ_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '已融资资金',
                        name: 'YRZZJ',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '其中债券融资资金',
                        name: 'ZQRZ',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '分年度项目投资计划及资金落实情况',
                anchor: '100% -90',
                layout: 'fit',
                collapsible: false,
                items: [
                    initWindow_zqxxtb_contentForm_tab_tzjh_grid()
                ]
            }
        ],
        listeners: {
            'beforeRender': function () {
                if (is_view == "1") {
                    SetItemReadOnly(this.items);
                }
            }
        }
    });
}
/**
 * 页签：项目投资计划中的表格
 */
function initWindow_zqxxtb_contentForm_tab_tzjh_grid() {
    var headerJson = [
		{
			xtype : 'rownumberer',
			width : 37,
			summaryType : 'count',
			summaryRenderer : function() {
				return '合计';
			}
		},
        {dataIndex: "PLAN_ID", type: "string", text: "计划ID", hidden: true},
        {
            dataIndex: "ND", type: "string", text: "年度", width:140, tdCls: 'grid-cell',
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'id',
                editable:false,
                allowBlank:false ,
                store: DebtEleStore(json_debt_year),
                value: new Date().getFullYear()
            }
        },
        {
            dataIndex: "ZTZ", type: "float", text: "年度总投资",
            columns: [
                {dataIndex: "ZTZ_PLAN_AMT", type: "float", text: "计划投资", width: 160, tdCls: 'grid-cell-unedit',
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },
                {dataIndex: "ZTZ_ACTUAL_AMT", type: "float", text: "实际到位", width: 160, tdCls: 'grid-cell-unedit',
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                }
            ]
        },
        {
            dataIndex: "SJBZ", type: "float", text: "上级补助资金",
            columns: [
                {
                    dataIndex: "SJBZ_PLAN_AMT", type: "float", text: "计划投资", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue: 9999999999.999999, keyNavEnabled: false,mouseWheelEnabled: false},
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },
                {
                    dataIndex: "SJBZ_ACTUAL_AMT", type: "float", text: "实际到位", width: 160,tdCls: 'grid-cell-unedit',
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                }
            ]
        },
        {
            dataIndex: "CZYS", type: "float", text: "本级财政预算资金",
            columns: [
                {
                    dataIndex: "CZYS_PLAN_AMT", type: "float", text: "计划投资", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue: 9999999999.999999, keyNavEnabled: false,mouseWheelEnabled: false},
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },
                {
                    dataIndex: "CZYS_ACTUAL_AMT", type: "float", text: "实际到位", width: 160,tdCls: 'grid-cell-unedit',
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                }
            ]
        },
        {
            dataIndex: "RZZJ", type: "float", text: "债券融资资金",
            columns: [
                {
                    dataIndex: "RZZJ_PLAN_AMT", type: "float", text: "计划投资", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue: 9999999999.999999, keyNavEnabled: false,mouseWheelEnabled: false},
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },
                {
                    dataIndex: "RZZJ_ACTUAL_AMT", type: "float", text: "实际到位", width: 160,tdCls: 'grid-cell-unedit',
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },

                {text: "小计", dataIndex: "RZZJ_XJ", type: "float", width: 160,tdCls: 'grid-cell-unedit',hidden:true},
                {
                    text: "新增一般债券资金", dataIndex: "RZZJ_YBZQ_AMT", type: "float", width: 160,tdCls: is_xz ? '' : 'grid-cell-unedit',
                    editor: is_xz ? {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue: 9999999999.999999, keyNavEnabled: false,mouseWheelEnabled: false} : '',
                    editable: false,
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },
                {
                    text: "新增专项债券资金", dataIndex: "RZZJ_ZXZQ_AMT", type: "float", width: 160,tdCls: is_xz? '' : 'grid-cell-unedit',
                    editor: is_xz ? {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue: 9999999999.999999, keyNavEnabled: false,mouseWheelEnabled: false} : '',
                    editable: false,
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },
                {
                    text: "置换债券资金", dataIndex: "RZZJ_ZHZQ_AMT", type: "float", width: 160,tdCls: is_xz? '' : 'grid-cell-unedit',
                    editor: is_xz ? {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue: 9999999999.999999, keyNavEnabled: false,mouseWheelEnabled: false} : '',
                    editable: false,
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },
                {
                    text: "再融资债券资金", dataIndex: "RZZJ_ZRZ_AMT", type: "float", width: 160,tdCls: is_xz? '' : 'grid-cell-unedit',
                    editor: is_xz ? {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue: 9999999999.999999, keyNavEnabled: false,mouseWheelEnabled: false} : '',
                    editable: false,
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                }


            ]
        },
        {
            text: "市场化融资资金", dataIndex: "RZZJ_SCRZ_AMT", type: "float",
            columns: [
                {
                    dataIndex: "SCRZ_PLAN_AMT", type: "float", text: "计划投资", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue: 9999999999.999999, keyNavEnabled: false,mouseWheelEnabled: false},
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },
                {
                    dataIndex: "XY_AMT_RMB", type: "float", text: "实际到位", width: 160,tdCls: 'grid-cell-unedit',
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                }
            ]
        },
        {
            dataIndex: "DWZC", type: "float", text: "单位自筹资金",
            columns: [
                {
                    dataIndex: "DWZC_PLAN_AMT", type: "float", text: "计划投资", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue: 9999999999.999999, keyNavEnabled: false,mouseWheelEnabled: false},
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },
                {
                    dataIndex: "DWZC_ACTUAL_AMT", type: "float", text: "实际到位", width: 160,tdCls: 'grid-cell-unedit',
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                }
            ]
        },
        {
            dataIndex: "QT", type: "float", text: "其他资金",
            columns: [
                {
                    dataIndex: "QT_PLAN_AMT", type: "float", text: "计划投资", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue: 9999999999.999999, keyNavEnabled: false,mouseWheelEnabled: false},
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                },
                {
                    dataIndex: "QT_ACTUAL_AMT", type: "float", text: "实际到位", width: 160,tdCls: 'grid-cell-unedit',
                	summaryType : 'sum',
                	summaryRenderer: function(value){
                		return Ext.util.Format.number(value,'0,000.00####');
                	}
                }
            ]
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'tzjhGrid',
        border: false,
        flex: 1,
        data: [],
        stateful:false,
        checkBox: true,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: true// 显示行号
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'tzjhCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                        //项目变更控制能不能修改
                        if((typeof(is_status)!="undefined" && is_status==1)){
                            return false;
                        }

                        if ((connNdjh == '1' || connNdjh == 1 || connZwxx == '1' || connZwxx == 1)) {//被引用项目
                            var current_year = new Date().getFullYear();
                            var check_year = current_year-1;
                            var grid_year = context.record.get('ND');
                            var plan_id = context.record.get('PLAN_ID');

                            if (grid_year <= check_year && plan_id != null && plan_id && plan_id != '') {
                                // 如果 实际到位资金 为空或者为0 则允许用户编制
                                /*if (!(context.field == 'SJBZ_ACTUAL_AMT' && context.record.get('SJBZ_ACTUAL_AMT') <= 0) && // 上级补助资金
                                    !(context.field == 'CZYS_ACTUAL_AMT' && context.record.get('CZYS_ACTUAL_AMT') <= 0) && // 本级财政预算资金
                                    !(context.field == 'RZZJ_ACTUAL_AMT' && context.record.get('RZZJ_ACTUAL_AMT') <= 0) && // 融资资金
                                    !(context.field == 'DWZC_ACTUAL_AMT' && context.record.get('DWZC_ACTUAL_AMT') <= 0) && // 单位自筹资金
                                    !(context.field == 'QT_ACTUAL_AMT' && context.record.get('QT_ACTUAL_AMT') <= 0)) { // 其他资金
                                    Ext.MessageBox.alert('提示', '该项目已经申报，无法修改或删除'+check_year+'年及之前的明细投资计划！');
                                    return false;
                                }*/
                            }
                        }
                    },
                    validateedit : function(editor, context) {
                        if (context.field=='ND'&&(connNdjh == '1' || connNdjh == 1 || connZwxx == '1' || connZwxx == 1)) {//被引用项目
                            var current_year = new Date().getFullYear();
                            var plan_id = context.record.get('PLAN_ID');
                            /*if (context.value < current_year && plan_id != null && plan_id && plan_id != '') {
                                Ext.MessageBox.alert('提示', '无法修改为历史年度！');
                                return false;
                            }*/
                        }
                    },
                    //validateedit --> afteredit
                    'afteredit': function (editor, context) {
                        //自动计算融资资金中债券资金到位情况
                       if (context.field == 'RZZJ_YBZQ_AMT' || context.field == 'RZZJ_ZXZQ_AMT' || context.field == 'RZZJ_ZHZQ_AMT'|| context.field == 'RZZJ_ZRZ_AMT') {
                     /*       var RZZJ_ACTUAL_AMT = context.record.get("RZZJ_ACTUAL_AMT");
                            var RZZJ_YBZQ_AMT = (context.field == 'RZZJ_YBZQ_AMT') ? context.value : context.record.get("RZZJ_YBZQ_AMT");
                            var RZZJ_ZXZQ_AMT = (context.field == 'RZZJ_ZXZQ_AMT') ? context.value : context.record.get("RZZJ_ZXZQ_AMT");
                            var RZZJ_ZHZQ_AMT = (context.field == 'RZZJ_ZHZQ_AMT') ? context.value : context.record.get("RZZJ_ZHZQ_AMT");
                           var RZZJ_ZRZ_AMT = (context.field == 'RZZJ_ZRZ_AMT') ? context.value : context.record.get("RZZJ_ZRZ_AMT");
                            var RZZJ_XJ = new Object(RZZJ_YBZQ_AMT + RZZJ_ZXZQ_AMT + RZZJ_ZHZQ_AMT+RZZJ_ZRZ_AMT);

                            context.record.set('RZZJ_XJ', RZZJ_XJ);*/
                        }
                        //自动计算年度总计划投资
                        if (context.field == 'SJBZ_PLAN_AMT' || context.field == 'CZYS_PLAN_AMT' || context.field == 'RZZJ_PLAN_AMT' || context.field == 'DWZC_PLAN_AMT' || context.field == 'QT_PLAN_AMT'||context.field == 'SCRZ_PLAN_AMT') {
                            var SJBZ_PLAN_AMT = (context.field == 'SJBZ_PLAN_AMT') ? context.value : context.record.get("SJBZ_PLAN_AMT");
                            var CZYS_PLAN_AMT = (context.field == 'CZYS_PLAN_AMT') ? context.value : context.record.get("CZYS_PLAN_AMT");
                            var RZZJ_PLAN_AMT = (context.field == 'RZZJ_PLAN_AMT') ? context.value : context.record.get("RZZJ_PLAN_AMT");
                            var DWZC_PLAN_AMT = (context.field == 'DWZC_PLAN_AMT') ? context.value : context.record.get("DWZC_PLAN_AMT");
                            var QT_PLAN_AMT = (context.field == 'QT_PLAN_AMT') ? context.value : context.record.get("QT_PLAN_AMT");
                            var SCRZ_PLAN_AMT = (context.field == 'SCRZ_PLAN_AMT') ? context.value : context.record.get("SCRZ_PLAN_AMT");
                            var RZZJ_SCRZ_AMT=(context.field == 'RZZJ_SCRZ_AMT') ? context.value : context.record.get("RZZJ_SCRZ_AMT");
                            var ZTZ_PLAN_AMT = new Object(SJBZ_PLAN_AMT + CZYS_PLAN_AMT + RZZJ_PLAN_AMT + DWZC_PLAN_AMT + QT_PLAN_AMT+RZZJ_SCRZ_AMT+SCRZ_PLAN_AMT);
                            context.record.set('ZTZ_PLAN_AMT', ZTZ_PLAN_AMT);
                        }
                        //自动计算年度总总投资实际到位
                        if (context.field == 'SJBZ_ACTUAL_AMT' || context.field == 'CZYS_ACTUAL_AMT' || context.field == 'RZZJ_ACTUAL_AMT' || context.field == 'DWZC_ACTUAL_AMT' || context.field == 'QT_ACTUAL_AMT'|| context.field == 'XY_AMT_RMB') {
                            var SJBZ_ACTUAL_AMT = (context.field == 'SJBZ_ACTUAL_AMT') ? context.value : context.record.get("SJBZ_ACTUAL_AMT");
                            var CZYS_ACTUAL_AMT = (context.field == 'CZYS_ACTUAL_AMT') ? context.value : context.record.get("CZYS_ACTUAL_AMT");
                            var RZZJ_ACTUAL_AMT = (context.field == 'RZZJ_ACTUAL_AMT') ? context.value : context.record.get("RZZJ_ACTUAL_AMT");
                            var DWZC_ACTUAL_AMT = (context.field == 'DWZC_ACTUAL_AMT') ? context.value : context.record.get("DWZC_ACTUAL_AMT");
                            var QT_ACTUAL_AMT = (context.field == 'QT_ACTUAL_AMT') ? context.value : context.record.get("QT_ACTUAL_AMT");
                            var XY_AMT_RMB=(context.field == 'XY_AMT_RMB') ? context.value : context.record.get("XY_AMT_RMB");
                            var ZTZ_ACTUAL_AMT = new Object(SJBZ_ACTUAL_AMT + CZYS_ACTUAL_AMT + RZZJ_ACTUAL_AMT + DWZC_ACTUAL_AMT + QT_ACTUAL_AMT+XY_AMT_RMB);

                            context.record.set('ZTZ_ACTUAL_AMT', ZTZ_ACTUAL_AMT);
                        }
                        initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
                    },
                    'edit': function (editor, context) {

                    }
                }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    if (!(is_view == "1")) {
        //将增加删除按钮添加到表格中
        grid.addDocked({
            xtype: 'toolbar',
            layout: 'column',
            items: [
                '->',
                {
                    xtype: 'button',
                    itemId:'tzjhInsertBtn',
                    text: '添加',
                    width: 60,
                    handler: function (btn) {
                        btn.up('grid').insertData(null, {});
                    }
                },
                {
                    xtype: 'button',
                    itemId: 'tzjhDelBtn',
                    text: '删除',
                    width: 60,
                    disabled: true,
                    handler: function (btn) {
                        if((typeof(is_status)!="undefined" && is_status==0)){
                            var grid = btn.up('grid');
                            var store = grid.getStore();
                            var sm = grid.getSelectionModel().getSelection();
                            if (connNdjh == '1' || connNdjh == 1 || connZwxx == '1' || connZwxx == 1) {//被引用项目
                                for(var i=0;i<sm.length;i++){
                                    var current_year = new Date().getFullYear();
                                    var check_year = current_year-1;
                                    var plan_id = sm[i].get('PLAN_ID');
                                    if (sm[i].get('ND') <= check_year && plan_id != null && plan_id && plan_id != '') {
                                        Ext.MessageBox.alert('提示', '该项目已经申报，无法删除'+check_year+'年及之前的明细投资计划！');
                                        return false;
                                    }
                                }
                            }
                            store.remove(sm);
                            calculateRzzjAmount(grid) ;  //计算  投资计划总结
                            if (store.getCount() > 0) {
                                grid.getSelectionModel().select(0);
                            }
                        }else{
                            var grid = btn.up('grid');
                            var store = grid.getStore();
                            var sm = grid.getSelectionModel();
                            store.remove(sm.getSelection());
                            calculateRzzjAmount(grid) ;  //计算  投资计划总结
                            if (store.getCount() > 0) {
                                sm.select(0);
                            }
                        }
                    }
                }
            ]
        }, 0);
        grid.on('selectionchange', function (view, records) {
            //项目变更控制能不能修改jhG
            if(!(typeof(is_status)!="undefined" && is_status==1)){
                grid.down('#tzjhDelBtn').setDisabled(!records.length);
            }
        });

    }
    return grid;
}
//数据加载完，计算 计划总结
function calculateRzzjAmount(grid){

    var store = grid.getStore() ;
    //自动计算年度总计划投资
    store.each(function(context){
        //自动计算年度总总投资计划到位
        var SJBZ_PLAN_AMT = context.data.SJBZ_PLAN_AMT ;
        var CZYS_PLAN_AMT = context.data.CZYS_PLAN_AMT;
        var RZZJ_PLAN_AMT = context.data.RZZJ_PLAN_AMT;
        var DWZC_PLAN_AMT = context.data.DWZC_PLAN_AMT;
        var QT_PLAN_AMT = context.data.QT_PLAN_AMT;
        var SCRZ_PLAN_AMT=context.data.SCRZ_PLAN_AMT;
        var ZTZ_PLAN_AMT = new Object(SJBZ_PLAN_AMT + CZYS_PLAN_AMT + RZZJ_PLAN_AMT + DWZC_PLAN_AMT + QT_PLAN_AMT+SCRZ_PLAN_AMT);
        context.set('ZTZ_PLAN_AMT', ZTZ_PLAN_AMT);
        //自动计算年度总总投资实际到位
        var SJBZ_ACTUAL_AMT = context.data.SJBZ_ACTUAL_AMT;
        var CZYS_ACTUAL_AMT = context.data.CZYS_ACTUAL_AMT;
        var RZZJ_ACTUAL_AMT = context.data.RZZJ_ACTUAL_AMT;
        var DWZC_ACTUAL_AMT = context.data.DWZC_ACTUAL_AMT;
        var QT_ACTUAL_AMT = context.data.QT_ACTUAL_AMT;
        var XY_AMT_RMB = context.data.XY_AMT_RMB;
        var ZTZ_ACTUAL_AMT = new Object(SJBZ_ACTUAL_AMT + CZYS_ACTUAL_AMT + RZZJ_ACTUAL_AMT + DWZC_ACTUAL_AMT + QT_ACTUAL_AMT+XY_AMT_RMB);
        context.set('ZTZ_ACTUAL_AMT', ZTZ_ACTUAL_AMT);
    }) ;
    initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();  //计算一遍  投资计划总结
}
/**
 * 刷新投资计划Form信息
 */
function initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm() {
    var xmsyStore = DSYGrid.getGrid("tzjhGrid").getStore();
    if(xmsyStore.getCount()>0){

    }
    Ext.ComponentQuery.query('numberFieldFormat[name="TZJH_XMZGS_AMT"]')[0].setValue(xmsyStore.sum('ZTZ_PLAN_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="TZJH_XMZGS_AMT"]')[0].setValue(xmsyStore.sum('ZTZ_PLAN_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="LJWCTZ_AMT"]')[0].setValue(xmsyStore.sum('ZTZ_ACTUAL_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="YRZZJ"]')[0].setValue(xmsyStore.sum('RZZJ_ACTUAL_AMT')+xmsyStore.sum('XY_AMT_RMB'));
    Ext.ComponentQuery.query('numberFieldFormat[name="ZQRZ"]')[0].setValue(xmsyStore.sum('RZZJ_XJ'));
    Ext.ComponentQuery.query('numberFieldFormat[name="SCHRZ_AMT"]')[0].setValue(xmsyStore.sum('SCRZ_PLAN_AMT'));
}

/**
 * 自定义校验：比较计划/实际开工/竣工日期
 */
Ext.apply(Ext.form.VTypes, {
    comparePlanDate: function (value, field) {
        return comparePlanDate(field.up('form'));
    },
    comparePlanDateText: '计划开工日期应该早于计划竣工日期',
    compareActualDate: function (value, field) {
        return compareActualDate(field.up('form'));
    },
    compareActualDateText: '开工日期应该早于竣工日期'
});
/**
 * 比较计划开工/竣工日期
 * @param form
 * @return {boolean}
 */
function comparePlanDate(form) {
    var START_DATE_PLAN = form.down('[name=START_DATE_PLAN]').getValue();
    var END_DATE_PLAN = form.down('[name=END_DATE_PLAN]').getValue();
    if (START_DATE_PLAN && END_DATE_PLAN && START_DATE_PLAN > END_DATE_PLAN) {
        return false;
    }
    return true;
}
/**
 * 比较实际开工/竣工日期
 * @param form
 * @return {boolean}
 */
function compareActualDate(form) {
    var START_DATE_ACTUAL = form.down('[name=START_DATE_ACTUAL]').getValue();
    var END_DATE_ACTUAL = form.down('[name=END_DATE_ACTUAL]').getValue();
    if (START_DATE_ACTUAL && END_DATE_ACTUAL && START_DATE_ACTUAL > END_DATE_ACTUAL) {
        return false;
    }
    return true;
}
function getSjxmStore(filterParam){
    var sjxmDataStore = Ext.create('Ext.data.Store', {
        model: 'sjxmModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: "/getSjxmData.action",
            reader: {
                type: 'json'
            },
            extraParams:filterParam
        },
        autoLoad: true
    });
    return sjxmDataStore;
}
/*
20201126liyue
获取项目类型store
*/
function getstore(form) {
    var condition="";
    var XMXZ_ID= Ext.ComponentQuery.query('treecombobox[name="XMXZ_ID"]')[0].getValue();
    var ZJTXLY_ID = Ext.ComponentQuery.query('treecombobox[name="ZJTXLY_ID"]')[0].getValue();
    if (XMXZ_ID == '0101'||XMXZ_ID == '010101'||XMXZ_ID == '010102') {
        condition = " and xmfllx = 0 ";
    } else if (XMXZ_ID== '0102') {
        condition = " and xmfllx = 1 ";
    }else{
        condition="";
    }
    if(!!ZJTXLY_ID){
        ZJTXLY_ID='#'+ZJTXLY_ID;
        condition=condition+"AND extend1 LIKE '%"+ZJTXLY_ID.substring(0,3)+"%'";
    }
    zwxmlx_store.proxy.extraParams['condition'] =  encode64(condition);
    zwxmlx_store.load();
}
/*
20201126liyue
变更时初始化
资金投向领域界面*/
function getzjtxstore(form) {
    var EXTEND1= Ext.ComponentQuery.query('textfield[name="EXTEND1"]')[0].getValue();
    var arr= [];
    //2020121815_zhuangrx_重写资金投向领域传值过程，兼容ie
    EXTEND1= EXTEND1.replaceAll("#","").substring(0,EXTEND1.length);//替换掉#
    var s=EXTEND1.length/2;//每两位截取一次
    for(var m=0;m<s;m++){
        arr.push(EXTEND1.substring(0,2));
        EXTEND1=EXTEND1.substring(2,EXTEND1.length);
    }
    var condition='';//2021041_LIYUE_完善校验
    if(!isNull(arr)&&arr.length>0){
        condition=" AND";
    }
    for(var i=0;i<arr.length;i++){
        if(i<arr.length-1){
            condition= condition +" CODE LIKE '"+arr[i]+"%' or ";
        }else{
            condition=condition +"  CODE LIKE '"+arr[i]+"%'";
        }
    }
    zjtxly_store.getProxy().extraParams.condition = encode64(condition);
    zjtxly_store.load();
}



/**
 * 项目基本信息穿透Gis地图页面
 */
function clickToMapInfo() {
    var reachUrl = '/page/bda/cxyy/mapGisManager/mapGisManager.jsp';
    var paramNames=new Array();
    paramNames[0]="DWBM";
    paramNames[1]="MC";
    paramNames[2]="RE";
    paramNames[3]="canSaveData";
    paramNames[4]="showTitle";
    var paramValues=new Array();
    paramValues[0]=XM_ID;
    paramValues[1]=Ext.ComponentQuery.query('textfield[name="XM_NAME"]')[0].getValue().trim();//项目名称
    paramValues[2]='callInterFace';
    paramValues[3]=0;

    if(address_Can_Alert == 'canAlter'){
        paramValues[3]=1;
    }

    paramValues[4]='GIS地图';
    post(reachUrl,paramNames,paramValues,'_blank');
}


/**
 * 项目地图回调方法
 * @param callObject
 */
function callMethod(callObject) {
    var xmAddress = callObject.addr;
    var xmLocationLng = callObject.lng;
    var xmLocationLat = callObject.lat;
    var XM_ADDRESS_FILL = Ext.ComponentQuery.query('textfield[name="XM_ADDRESS"]')[0];
    var LNG_FILL = Ext.ComponentQuery.query('textfield[name="LNG"]')[0];
    var LAT_FILL = Ext.ComponentQuery.query('textfield[name="LAT"]')[0];
    XM_ADDRESS_FILL.setValue(xmAddress);
    LNG_FILL.setValue(xmLocationLng);
    LAT_FILL.setValue(xmLocationLat);
}
//辽宁新添加建设项目内容填报模板
function downloadJsxmnrTbsm(){
    window.location.href = 'downloadTemplate.action?file_name='+encodeURI(encodeURI("建设项目内容填报模板.docx"));
}