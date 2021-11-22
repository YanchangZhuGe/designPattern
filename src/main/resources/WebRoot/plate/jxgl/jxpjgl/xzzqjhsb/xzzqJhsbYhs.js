// TODO 基本变量
var jbqkTitle = "基本情况";
var bcxxTitle = "前期准备";
var tzjhTitle = "投资计划";
var szysTitle = "收支预算";
var bcsbTitle = "本次申报";
var sdgcTitle =  is_show ? '十大工程' : '项目特征';
var xmcjqyTitle = "项目承建企业";
var first=0;//第一次录数据还是已有项目数据用于修改校验，修改时已有项目部分置灰,新增不置灰，不置灰的情况下要考虑资金投向与项目性质联动

var date = new Date;
var thisTear = date.getFullYear();
var sqjeYear = thisTear + 1;
var getYears = getYearList({start: 0, end: 1});
// 债券期限
var zqqx_store = [
    {id: '001', code: '001', name: '1年'},
    {id: '003', code: '003', name: '3年'},
    {id: '005', code: '005', name: '5年'},
    {id: '007', code: '007', name: '7年'},
    {id: '010', code: '010', name: '10年'},
    {id: '020', code: '020', name: '20年'},
    {id: '015', code: '015', name: '15年'},
    {id: '030', code: '030', name: '30年'}
];
const jssr_key = ["02", "0201", "0202", "0203", "0204", "0205"];
const jszc_key = ["03", "0301", "0302", "0303", "0304"];
const yysr_key = ["01", "0101", "0102", "0103"];
const yyzc_key = ["04", "0401", "0402", "0403", "0404"];

/**
 * 初始化债券信息填报表单
 */
function initWindow_zqxxtb_contentForm(tab_items) {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            anchor: '100%'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                anchor: '100%',
                layout: 'hbox',
                items: [
                    {xtype: 'label', text: '单位名称:', width: 70},
                    {xtype: 'label', text: AG_NAME, width: 200, flex: 5},
                    {xtype: 'label', text: '单位:万元', width: 80, cls: "label-color"}
                ]
            },
            initWindow_zqxxtb_contentForm_tab_new(tab_items)
        ]
    });
}

/**
 * 初始化债券信息填报弹出窗口中的tabpanel
 */
function initWindow_zqxxtb_contentForm_tab_new(tab_items) {
    var items = getZqxxItems(tab_items);
    var zqxxtbTab = Ext.create('Ext.tab.Panel', {
        anchor: '100% -17',
        border: false,
        itemId: 'zqxxTab',
        items: items,
        listeners: {
            tabchange: function (tabPanel, newCard, oldCard) {
                zqxxtbTab_listeners_tabchange(tabPanel, newCard, oldCard);
            }
        }
    });

    return zqxxtbTab;
}

/**
 * 根据封装好的页签Jason，加载所需页签
 * @param tab_items 需要显示的页签json
 * @param XM_ID 项目id
 */
function getZqxxItems(tab_items) {
    var items = [];
    var xmxx_items = initWindow_zqxx_items(tab_items);
    for (var name in tab_items) {//遍历json对象的每个key/value对,p为key
        //获取每个页签属性，动态重写属性。
        var tabJson = xmxx_items[name];
        var tab_property = tab_items[name];
        if (!jQuery.isEmptyObject(tab_property)) {
            for (var property in tab_property) {
                // 保留 初始化的对象属性
                tabJson[property] = tab_property[property];
            }
        }
        //将页签加入初始化panel中
        items.push(tabJson);
    }
    return items;
}

// 加载所有页签
function initWindow_zqxx_items(tab_items) {
    var tab_items = tab_items;
    var xmxx_items = {};
    for (var name in tab_items) {
        if ("jbqk" == name) {
            xmxx_items.jbqk = {
                title: jbqkTitle,
                scrollable: true,
                layout: 'fit',
                itemId: 'jbqk',
                items: initWindow_zqxxtb_contentForm_tab_jbqk()
            }
        } else if ("bcxx" == name) {
            xmxx_items.bcxx = {
                title: bcxxTitle, //补充信息
                scrollable: true,
                layout: 'fit',
                itemId: 'bcxx',
                items: initWindow_zqxxtb_contentForm_tab_bcxx()
            }
        } else if ("szph" == name) {
            xmxx_items.szph = {
                title: szysTitle, // 收支平衡
                scrollable: true,
                layout: 'fit',
                itemId: 'szph',
                items: isOld_szysGrid == '1' ? initWindow_zqxxtb_contentForm_tab_xmsy() : initWindow_zqxxtb_contentForm_tab_szys()
            }
        } else if ("bcsb" == name) {
            xmxx_items.bcsb = {
                title: bcsbTitle,
                scrollable: true,
                layout: 'fit',
                itemId: 'bcsb',
                items: initWindow_zqxxtb_contentForm_tab_bnsb()
            }
        } else if ("xmcjqy" == name) {
            xmxx_items.xmcjqy = {
                title: xmcjqyTitle,
                scrollable: true,
                layout: 'fit',
                itemId: 'xmcjqy',
                items: initWindow_zqxxtb_contentForm_tab_xmcjqy_grid()
            }
        } else if ("tzjh" == name) {
            xmxx_items.tzjh = {
                title: tzjhTitle,
                scrollable: true,
                layout: 'fit',
                itemId: 'tzjh',
                items: initWindow_zqxxtb_contentForm_tab_tzjh()
            }
        } else if ("sdgc" == name) {
            xmxx_items.sdgc = {
                title: sdgcTitle,//湖北专用填报十大工程页签内容
                scrollable: true,
                layout: 'fit',
                itemId: 'sdgc',
                btnsItemId: 'sdgc',
                hidden:sysAdcode=='42'||sysAdcode=='21'||is_fxjh=='5'||is_show==false?false:true,
                items: initWindow_zqxxtb_contentForm_tab_sdgc(null, 'jhtb', window_zqxxtb.XM_ID)
            }
        } else if ("zqfj" == name) {
            xmxx_items.zqfj =
                {
                    title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                    scrollable: true,
                    layout: 'fit',
                    items: [
                        {
                            xtype: 'panel',
                            itemId: 'zqfjpzPanel',
                            layout: 'fit',
                            border: false,
                            items: initWindow_zqxxtb_contentForm_tab_xmfj({ruleIds: []})
                        }
                    ]
                }
        }
    }

    return xmxx_items;
}

// tab页切换函数
function zqxxtbTab_listeners_tabchange(tabPanel, newCard, oldCard) {
    if (isOld_szysGrid == '0' && newCard.title == szysTitle && !is_tdcb) {
        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(false);
        Ext.ComponentQuery.query('button#lxcs')[0].setHidden(false);//20211020liyue添加利息测算按钮控制
        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(false);
        Ext.ComponentQuery.query('button#import')[0].setHidden(false);
        var self = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0];
        change_tdcbysbz_grid(self, {XM_ID: window_zqxxtb.XM_ID});
    } else {
        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(true);
        Ext.ComponentQuery.query('button#import')[0].setHidden(true);
        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);
        Ext.ComponentQuery.query('button#lxcs')[0].setHidden(true);//20211020liyue添加利息测算按钮控制
    }
    if (newCard.title == bcsbTitle) {
        // 重设金额
        updateZjeSqje();
    }
    if (is_tdcb == true) {//20201110_wangyl_土地储备隐藏导入按钮
        Ext.ComponentQuery.query('button#import')[0].setHidden(true);
        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);
        Ext.ComponentQuery.query('button#lxcs')[0].setHidden(true);//20211020liyue添加利息测算按钮控制
    }

    if (newCard.title == xmcjqyTitle) {
        //获取基本情况页签表单
        var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
        var SBPC_TYPE_ID = bnsbForm.getForm().findField("BOND_TYPE_ID").getValue();
        if (SBPC_TYPE_ID != '01') {
            DSYGrid.getGrid("xmcjqyGrid").down('#xmcjqyAddBtn').setDisabled(true);
            DSYGrid.getGrid("xmcjqyGrid").down('#xmcjqyDelBtn').setDisabled(true);
        } else {
            DSYGrid.getGrid("xmcjqyGrid").down('#xmcjqyAddBtn').setDisabled(false);
            DSYGrid.getGrid("xmcjqyGrid").down('#xmcjqyDelBtn').setDisabled(false);
        }
    }
}

/** 基础数据，下拉框形式*/
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
 * 切换tab页签
 */
function zqxxtbTab(index) {
    var zqxxtbTab = Ext.ComponentQuery.query('panel[itemId="zqxxTab"]')[0];
    if (zqxxtbTab.items.get(index) != undefined) {
        zqxxtbTab.items.get(index).show();
    }
}

// TODO 基本情况

/**
 * 初始化债券信息填报弹出窗口中各个页签内容
 */
function initWindow_zqxxtb_contentForm_tab_jbqk() {
    return Ext.create('Ext.form.Panel', {
        name: 'jbqkForm',
        itemId: 'jbqkForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            margin: '0 0 0 0',
            padding: '0 0 0 0',
            anchor: '100%'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldcontainer',
                layout: 'anchor',
                defaults: {
                    anchor: '100%',
                    margin: '0 0 0 0'
                },
                items: [
                    {
                        xtype: 'fieldcontainer',
                        layout: 'column',
                        defaultType: 'textfield',
                        fieldDefaults: {
                            labelWidth: 140,
                            columnWidth: .33,
                            margin: '3 1 3 20'
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
                                fieldLabel: '项目总概算',
                                name: 'XMZGS_AMT',
                                xtype: 'numberFieldFormat',
                                hideTrigger: true,
                                hidden: true,
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6'
                            },
                            {
                                fieldLabel: '项目编码',
                                name: 'XM_CODE',
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6'
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>项目名称',
                                name: 'XM_NAME',
                                emptyText: '请输入...',
                                allowBlank: false
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>立项年度',
                                name: 'LX_YEAR',
                                xtype: 'combobox',
                                value: SET_YEAR,
                                displayField: 'name',
                                valueField: 'id',
                                store: DebtEleStore(getYears),
                                allowBlank: false,
                                editable: false
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>资产登记管理单位',
                                name: 'USE_UNIT_ID',
                                allowBlank: false
                            },
                            {
                                xtype: "textfield",
                                allowBlank: false,
                                emptyText: '点击地图定位图标选择项目地址',
                                fieldLabel: '<span class="required">✶</span>项目地址<img src="/image/common/locate.png" style="height: 31px;position: absolute;top:26px" onclick="clickToMap()"/>',
                                name: 'XM_ADDRESS'
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '项目地址（经度）',
                                name: 'LNG',
                                hidden: true
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '项目地址（纬度）',
                                name: 'LAT',
                                hidden: true
                            },
                            {
                                fieldLabel: '预算管理一体化编码',
                                name: 'YSXM_NO',
                                maxLength: 38,
                                maxLengthText: '输入编码过长，只能输入38位！',
                                hidden:true
                            },
                            {
                                fieldLabel: '国库支付项目编码',
                                name: 'GK_PAY_XMNO',
                                maxLength: 38,
                                hidden: true,
                                maxLengthText: '输入编码过长，只能输入38位！'
                            },
                            {
                                xtype: "combobox",
                                name: "IS_FGW_XM",
                                fieldLabel: '<span class="required">✶</span>是否入为重大项目库',
                                value: newValue,
                                displayField: 'name',
                                valueField: 'id',
                                minValue: 0,
                                store: DebtEleStore(json_debt_isorno),
                                allowBlank: false,
                                editable: false,
                                listeners: {
                                    change: function (self, newValue) {
                                        if (!self.getValue()) {
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
                            /* {
                                 fieldLabel: '<span class="required">✶</span>发改委审批监管代码',
                                 name: 'FGW_XMK_CODE',
                                 allowBlank: false,
                                 maxLength: 50,
                                 maxLengthText: '输入字符过长，只能输入50个字符'
                             },*/
                            {
                                fieldLabel: '<span class="required">✶</span>发改委审批监管代码',
                                name: 'FGW_XMK_CODE',
                                allowBlank: false,
                                //maxLength : 50 ,
                                regex: /(\b^(\d{4}\-\d{6}\-\d{2}\-\d{2}\-\d{6}$)\b)/,
                                regexText: '发改委审批监管代码格式错误',
                                emptyText: 'XXXX-XXXXXX-XX-XX-XXXXXX',
                                readOnly: is_fxjh != '1' ? false : true,
                                fieldStyle: is_fxjh != '1' ? 'background:#FFFFFF' : 'background:#E6E6E6'
                                //maxLengthText : '输入字符过长，只能输入50个字符'
                            },
                            {
                                fieldLabel: ywcsbl ? '<span class="required">✶</span>归口处室' : '归口处室',
                                name: 'MB_ID',
                                xtype: 'combobox',
                                editable: false,
                                displayField: 'name',
                                valueField: 'id',
                                hidden: true,
                                allowBlank: true,// ywcsbl ? false : true,
                                store: ywcs_store
                            },
                            {
                                fieldLabel: '所属主管部门',
                                name: 'SS_ZGBM_ID',
                                xtype: 'combobox',
                                editable: false,
                                /*hidden: sysAdcode == '12' ? false : true,*/
                                displayField: 'text',
                                valueField: 'id',
                                allowBlank: true,
                                hidden: true,
                                store: DebtEleTreeStoreDBTable("DSY_V_ELE_AG_ZGBM", {condition: "and condition=" + AD_CODE}),
                            }
                        ]
                    },
                    {
                        xtype: 'menuseparator',
                        margin: '3 1 3 20'
                    },
                    {
                        xtype: 'fieldcontainer',
                        layout: 'column',
                        defaultType: 'textfield',
                        fieldDefaults: {
                            labelWidth: 140,
                            columnWidth: .33,
                            margin: '3 1 3 20'
                        },
                        items: [
                            {
                                fieldLabel: '<span class="required">✶</span>建设性质',
                                name: 'JSXZ_ID',
                                xtype: 'combobox',
                                displayField: 'name',
                                valueField: 'id',
                                store: DebtEleStoreDB("DEBT_XMJSXZ", {condition: "AND GUID !='03' "}),
                                allowBlank: true,
                                editable: false,
                                hidden: true
                            },
                            {
                                xtype: 'treecombobox',
                                fieldLabel: '<span class="required">✶</span>项目性质',
                                name: 'XMXZ_ID',
                                displayField: 'name',
                                valueField: 'id',
                                rootVisible: false,
                                lines: false,
                                hidden: true,
                                allowBlank: true,
                                editable: false, //禁用编辑
                                selectModel: 'leaf',
                                store: xmxz_store,
                                listeners: {
                                    change: function (self, newValue) {
                                        // if (!self.getValue()) {
                                        //     return;
                                        // }
                                        // /*  if(node_type!='typing'&&node_type!='xmtz'&&node_type!='jhtb'){
                                        //       //20201126李月根据资金投向领域加载项目类型方法
                                        //       getxmstore();
                                        //   }*/
                                        // var XMXZ_ID = this.up('form').getForm().findField('XMXZ_ID');
                                        // if (XMXZ_ID.value == '010102') {
                                        //     var xmsy_ycyj = self.up('form').down('textarea[name="XMSY_YCYJ"]');
                                        //     xmsy_ycyj.setFieldLabel('<span class="required">✶</span>' + '项目收益预测依据');
                                        //     xmsy_ycyj.allowBlank = false;
                                        // } else {
                                        //     var xmsy_ycyj = self.up('form').down('textarea[name="XMSY_YCYJ"]');
                                        //     xmsy_ycyj.setFieldLabel('项目收益预测依据');
                                        //     xmsy_ycyj.allowBlank = true;
                                        // }
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
                                hidden: false,
                                lines: false,
                                allowBlank: false,
                                selectModel: 'leaf',
                                listeners: {
                                    'change': function (self, newValue, oldValue) {
                                        if(node_type!='typing'&&node_type!='xmtz'&&(node_type!='jhtb'||(button_status=='addXm'&&node_type=='jhtb')||first=='0'||(button_status=='update'&&first=='1'))){
                                            //20201126李月根据资金投向领域加载项目类型方法
                                            getstore();
                                        }
                                        if((first=='1'&&button_status=='update')){//20210429LIYUE 兼容新增按钮修改时资金投向与项目类性联动
                                            zjtxly_store=DebtEleTreeStoreDB("DEBT_ZJTXLY");
                                            /*if(is_zxzq=='1'){
                                                DebtEleTreeStoreDB("DEBT_ZJTXLY",{condition: "AND CODE !='00'"});
                                            }else {
                                                DebtEleTreeStoreDB("DEBT_ZJTXLY");
                                            }*/
                                            zjtxly_store.load();
                                            getstore();
                                        }
                                    }
                                }
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>项目类型',
                                name: 'XMLX_ID',
                                xtype: 'treecombobox',
                                minPicekerWidth: 250,
                                displayField: 'name',
                                valueField: 'id',
                                selectModel: 'leaf',
                                rootVisible: false,
                                store: zwxmlx_store,
                                allowBlank: false,
                                editable: false,
                                listeners: {
                                    select: function (self) {
                                        // if (self.getValue() == '05') {
                                        //     field_names = '土地面积(公顷)';
                                        //     field_names_dk = '地块GIS';
                                        //     field_names_cb = '储备期限';
                                        // } else if (self.getValue().substring(0, 2) == '02') {
                                        //     field_names = '通车里程(公里)';
                                        //     field_names_dk = '车辆购置税';
                                        //     field_names_cb = '车辆通行费征收标准';
                                        // } else if (self.getValue().substring(0, 2) == '06') {
                                        //     field_name = '棚改范围';
                                        //     field_names_dk = '规模户数';
                                        //     field_names_cb = '标准';
                                        // }
                                        // var rink = Ext.ComponentQuery.query('fieldset[name="shrink"]')[0];
                                        // var variable = Ext.ComponentQuery.query('textfield[name="LXDW"]')[0];
                                        // if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02') {
                                        //     variable.setFieldLabel(field_names);
                                        //     rink.setExpanded(true);
                                        //     rink.setHidden(false);
                                        //     variable.setVisible(true);
                                        // } else {
                                        //     rink.setExpanded(false);
                                        //     variable.setValue(0);
                                        //     variable.setVisible(false);
                                        //     variable.allowBlank = true;
                                        // }
                                        // var variable4 = Ext.ComponentQuery.query('textfield[name="LXDW4"]')[0];
                                        // if (self.getValue().substring(0, 2) == '06') {
                                        //     variable4.setFieldLabel(field_name);
                                        //     rink.setExpanded(true);
                                        //     rink.setHidden(false);
                                        //     variable4.setVisible(true);
                                        // } else {
                                        //     rink.setExpanded(false);
                                        //     variable4.setValue("");
                                        //     variable4.setVisible(false);
                                        //     variable4.allowBlank = true;
                                        // }
                                        // var variable2 = Ext.ComponentQuery.query('textfield[name="LXDW2"]')[0];
                                        // if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02' || self.getValue().substring(0, 2) == '06') {
                                        //     variable2.setFieldLabel(field_names_dk);
                                        //     rink.setExpanded(true);
                                        //     rink.setHidden(false);
                                        //     variable2.setVisible(true);
                                        // } else {
                                        //     rink.setExpanded(false);
                                        //     variable2.setValue(0);
                                        //     variable2.setVisible(false);
                                        //     variable2.allowBlank = true;
                                        // }
                                        // var variable3 = Ext.ComponentQuery.query('textfield[name="LXDW3"]')[0];
                                        // if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02' || self.getValue().substring(0, 2) == '06') {
                                        //     variable3.setFieldLabel(field_names_cb);
                                        //     rink.setExpanded(true);
                                        //     rink.setHidden(false);
                                        //     variable3.setVisible(true);
                                        // } else {
                                        //     rink.setExpanded(false);
                                        //     variable3.setValue(0);
                                        //     variable3.setVisible(false);
                                        //     variable3.allowBlank = true;
                                        // }
                                        // variable.setValue("");
                                        // variable2.setValue("");
                                        // variable3.setValue("");
                                        // variable4.setValue("");
                                    },
                                    change: function (self) {
                                        /*  if(node_type=='typing'||node_type=='xmtz'||node_type=='jhtb'){
                                              var EXTEND= self.up('form').down('textfield[name="EXTEND1"]').getValue();
                                              extend=EXTEND.substring(1,3);
                                              var ZJTXLY= self.up('form').down('treecombobox[name="ZJTXLY_ID"]');
                                              var zjtxly_store = ZJTXLY.getStore();
                                              zjtxly_store.getProxy().extraParams.condition = encode64(" AND CODE LIKE '"+extend+"%'");
                                              zjtxly_store.load();
                                          }*/
                                        // 调用公共方法：如果是项目类型是土地存储则重新初始化收支平衡grid
                                        if (isOld_szysGrid == '0') {
                                            change_tdcbysbz_grid(self, {XM_ID: window_zqxxtb.XM_ID});
                                        }
                                        if (!!self && self.getValue() == '05') {
                                            is_tdcb = true
                                        } else {
                                            is_tdcb = false
                                        }
                                        // 土储改变 本次申报的申请金额和申请总金额
                                        var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
                                        if (!!bnsbForm) {
                                            var APPLY_AMOUNT1 = bnsbForm.getForm().findField("APPLY_AMOUNT1");
                                            var APPLY_AMOUNT_TOTAL = bnsbForm.getForm().findField("APPLY_AMOUNT_TOTAL");
                                            if (!!self && self.getValue() == '05' && !!APPLY_AMOUNT1 && !!APPLY_AMOUNT_TOTAL) {
                                                is_tdcb = true;
                                                APPLY_AMOUNT1.setFieldStyle("background:#ffffff");
                                                APPLY_AMOUNT1.setReadOnly(false);
                                                APPLY_AMOUNT_TOTAL.setHidden(true);
                                            } else if (!!APPLY_AMOUNT1 && !!APPLY_AMOUNT_TOTAL) {
                                                APPLY_AMOUNT1.setFieldStyle("background:#E6E6E6");
                                                APPLY_AMOUNT1.setReadOnly(true);
                                                APPLY_AMOUNT_TOTAL.setHidden(false);
                                            }
                                        }
                                        // if (self.getValue() == '05') {
                                        //     field_names = '土地面积(公顷)';
                                        //     field_names_dk = '地块GIS';
                                        //     field_names_cb = '储备期限';
                                        // } else if (self.getValue().substring(0, 2) == '02') {
                                        //     field_names = '通车里程(公里)';
                                        //     field_names_dk = '车辆购置税';
                                        //     field_names_cb = '车辆通行费征收标准';
                                        // } else if (self.getValue().substring(0, 2) == '06') {
                                        //     field_name = '棚改范围';
                                        //     field_names_dk = '规模户数';
                                        //     field_names_cb = '标准';
                                        // }
                                        // var rink = Ext.ComponentQuery.query('fieldset[name="shrink"]')[0];
                                        // var variable = Ext.ComponentQuery.query('textfield[name="LXDW"]')[0];
                                        // if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02') {
                                        //     variable.setFieldLabel(field_names);
                                        //     rink.setExpanded(true);
                                        //     rink.setHidden(false);
                                        //     variable.allowBlank = true;
                                        //     variable.setVisible(true);
                                        // } else {
                                        //     rink.setExpanded(false);
                                        //     variable.setValue(0);
                                        //     variable.setVisible(false);
                                        //     variable.allowBlank = true;
                                        // }
                                        // var variable4 = Ext.ComponentQuery.query('textfield[name="LXDW4"]')[0];
                                        // if (self.getValue().substring(0, 2) == '06') {
                                        //     variable4.setFieldLabel(field_name);
                                        //     rink.setExpanded(true);
                                        //     rink.setHidden(false);
                                        //     variable4.allowBlank = true;
                                        //     variable4.setVisible(true);
                                        // } else {
                                        //     rink.setExpanded(false);
                                        //     variable4.setValue("");
                                        //     variable4.setVisible(false);
                                        //     variable4.allowBlank = true;
                                        // }
                                        // var variable2 = Ext.ComponentQuery.query('textfield[name="LXDW2"]')[0];
                                        // if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02' || self.getValue().substring(0, 2) == '06') {
                                        //     variable2.setFieldLabel(field_names_dk);
                                        //     rink.setExpanded(true);
                                        //     rink.setHidden(false);
                                        //     variable2.setVisible(true);
                                        // } else {
                                        //     rink.setExpanded(false);
                                        //     variable2.setValue(0);
                                        //     variable2.setVisible(false);
                                        //     variable2.allowBlank = true;
                                        // }
                                        // var variable3 = Ext.ComponentQuery.query('textfield[name="LXDW3"]')[0];
                                        // if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02' || self.getValue().substring(0, 2) == '06') {
                                        //     variable3.setFieldLabel(field_names_cb);
                                        //     rink.setExpanded(true);
                                        //     rink.setHidden(false);
                                        //     variable3.setVisible(true);
                                        // } else {
                                        //     rink.setExpanded(false);
                                        //     variable3.setValue(0);
                                        //     variable3.setVisible(false);
                                        //     variable3.allowBlank = true;
                                        // }
                                    }
                                }
                            },
                            {
                                fieldLabel: "国土部门监管码",
                                name: 'DISC',
                                xtype: "textfield",
                                editable: true,
                                hidden: true
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>立项审批依据',
                                name: 'LXSPYJ_ID',
                                xtype: 'combobox',
                                displayField: 'name',
                                valueField: 'id',
                                store: DebtEleStore(json_debt_lxspyj),
                                allowBlank: true,
                                hidden: true,
                                editable: false
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>立项审批级次',
                                name: 'SP_LEVEL_ID',
                                xtype: 'combobox',
                                displayField: 'name',
                                valueField: 'id',
                                store: DebtEleStore(json_debt_lxspjc),
                                allowBlank: true,
                                hidden: true,
                                editable: false
                            }, {
                                xtype: "treecombobox",
                                name: "LXSPBM_ID",
                                store: DebtEleTreeStoreDB("DEBT_ZGBM"),
                                fieldLabel: '<span class="required">✶</span>立项审批部门',
                                displayField: 'name',
                                valueField: 'id',
                                rootVisible: false,
                                lines: false,
                                allowBlank: true,
                                hidden: true,
                                selectModel: 'leaf'
                            },
                            {
                                xtype: 'textfield',
                                fieldLabel: '项目建议书文号',
                                name: 'JYS_NO',
                                maxLength: 50,
                                hidden: true,
                                maxLengthText: '输入文字过长，只能输入50个字！'
                            },
                            {
                                fieldLabel: '可研批复文号',
                                name: 'PF_NO',
                                maxLength: 50,
                                hidden: true,
                                maxLengthText: '输入文字过长，只能输入50个字！'
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
                                hidden: true,
                                store: DebtEleTreeStoreDB("DEBT_BDBCYLX")
                            },
                            {
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
                                xtype: "textfield",
                                fieldLabel: 'EXTEND1',
                                hidden: true,
                                name: 'EXTEND1',
                                listeners: {
                                    'change':  function (self,newValue) {
                                     /*   var ZJTXLY_ID = Ext.ComponentQuery.query('treecombobox[name="ZJTXLY_ID"]')[0].getValue();
                                        var arr= [];
                                        //2020121815_zhuangrx_重写资金投向领域传值过程，兼容ie
                                        newValue= newValue.replaceAll("#","").substring(0,newValue.length);//替换掉#
                                        var s=newValue.length/2;//每两位截取一次
                                        for(var m=0;m<s;m++){
                                            arr.push(newValue.substring(0,2));
                                            newValue=newValue.substring(2,newValue.length);
                                        }
                                        var condition='';//2021041_LIYUE_完善校验
                                        if(!isNull(arr)&&arr.length>0){
                                            condition=" AND";
                                        }
                                        for(var i=0;i<arr.length;i++){
                                            if(i<arr.length-1){
                                                condition=condition+" CODE LIKE '"+arr[i]+"%' or ";
                                            }else{
                                                condition=condition+" CODE LIKE '"+arr[i]+"%'";
                                            }
                                        }
                                        if(is_zxzq == '1'){
                                            condition=condition + " AND CODE != '00' " ;
                                        }
                                        zjtxly_store.getProxy().extraParams.condition = encode64(condition);
                                        zjtxly_store.load();
*/
                                    }
                                }
                            }
                        ]
                    },
                    {
                        xtype: 'fieldset',
                        layout: 'column',
                        name: 'shrink',
                        defaultType: 'textfield',
                        hidden: true,
                        border: false,
                        padding: '5 5 0 5',
                        defaults: {
                            labelWidth: 138,
                            columnWidth: .33,
                            margin: '2 1 2 20'
                        },
                        items: [
                            {
                                name: 'LXDW',
                                fieldLabel: '变量',
                                xtype: 'numberFieldFormat',
                                value: 0,
                                hideTrigger: true,
                                autoLoad: true,
                                maxValue: 9999999,
                                minValue: 0,
                                hidden: true,
                                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                            },
                            {
                                name: 'LXDW4',
                                fieldLabel: '变量4',
                                xtype: 'textfield',
                                hideTrigger: true,
                                autoLoad: true,
                                maxLength: 20,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入20个汉字！",
                                hidden: true,
                                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                            },
                            {
                                name: 'LXDW2',
                                fieldLabel: '变量2',
                                xtype: 'numberFieldFormat',
                                value: 0,
                                hideTrigger: true,
                                autoLoad: true,
                                maxValue: 9999999,
                                minValue: 0,
                                hidden: true,
                                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                            },
                            {
                                name: 'LXDW3',
                                fieldLabel: '变量3',
                                xtype: 'numberFieldFormat',
                                value: 0,
                                hideTrigger: true,
                                autoLoad: true,
                                maxValue: 9999999,
                                minValue: 0,
                                hidden: true,
                                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                            }
                        ]
                    },
                    {
                        xtype: 'menuseparator',
                        margin: '3 1 3 20'
                    },
                    {
                        xtype: 'fieldcontainer',
                        layout: 'column',
                        defaultType: 'textfield',
                        fieldDefaults: {
                            labelWidth: 140,
                            columnWidth: .33,
                            margin: '3 1 3 20'
                        },
                        items: [
                            {
                                fieldLabel: '<span class="required">✶</span>建设状态',
                                name: 'BUILD_STATUS_ID',
                                xtype: 'combobox',
                                displayField: 'name',
                                valueField: 'id',
                                store: DebtEleTreeStoreDB("DEBT_XMJSZT", {condition: "AND GUID !='02' AND GUID !='03'AND GUID !='04'AND GUID !='05' "}),
                                allowBlank: false,
                                hidden: false,
                                editable: false
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>计划开工日期',
                                name: 'START_DATE_PLAN',
                                xtype: 'datefield',
                                format: 'Y-m-d',
                                allowBlank: true,
                                hidden: true,
                                value: today,
                                // vtype: 'comparePlanDate'
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>计划竣工日期',
                                name: 'END_DATE_PLAN',
                                xtype: 'datefield',
                                format: 'Y-m-d',
                                allowBlank: true,
                                hidden: true,
                                // vtype: 'comparePlanDate'
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>单位项目负责人',
                                name: 'BILL_PERSON',
                                allowBlank: true,
                                hidden: true,
                                maxLength: 20,
                                maxLengthText: '输入字符过长，只能输入20个字！'
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>开工日期',
                                name: 'START_DATE_ACTUAL',
                                xtype: 'datefield',
                                format: 'Y-m-d',
                                editable: true,
                                vtype: 'compareActualDate',
                                allowBlank: false,
                                listeners: {
                                    'change': function (self, newValue) {
                                        CommonListenersFunction(self, newValue,{XM_ID: window_zqxxtb.XM_ID}); // 公共的监听事件：兼容历史数据未填写收支预算的情况，只能使用change事件
                                    }
                                }
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>竣工日期',
                                name: 'END_DATE_ACTUAL',
                                // maxValue: nowDate,
                                xtype: 'datefield',
                                format: 'Y-m-d',
                                editable: true,
                                vtype: 'compareActualDate', allowBlank: false
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>负责人联系电话',
                                name: 'BILL_PHONE',
                                allowBlank: true,
                                hidden: true
                                // regex: /^(?:0[0-9]{2,3}[-\\s]{1}|\\(0[0-9]{2,4}\\))[0-9]{6,8}$|^[1-9]{1}[0-9]{5,7}$|^[1-9]{1}[0-9]{10}$/,
                                // regexText: '手机号码格式有误，请重填'
                            },

                            {
                                fieldLabel: '上级项目',
                                name: 'UPPER_XM_ID',
                                xtype: 'treecombobox',
                                displayField: 'name',
                                valueField: 'name',
                                selectModel: 'leaf',
                                store: DebtEleTreeStoreDB('DEBT_SJXM'),
                                editable: false,
                                hidden: true
                            }
                        ]
                    },
                    {
                        xtype: 'fieldcontainer',
                        layout: 'column',
                        defaultType: 'textfield',
                        fieldDefaults: {
                            labelWidth: 140,
                            columnWidth: .99,
                            margin: '3 1 3 20'
                        },
                        items: [
                            {
                                fieldLabel: '<span class="required">✶</span>项目主要建设内容和规模（<a class="divcss5-x5" href="#" onclick="downloadJsxmnrTbsm()" style="color:#3329ff;">填报说明</a>）',
                                name: 'BUILD_CONTENT',
                                xtype: 'textarea',
                                allowBlank: false,
                                maxLength: 1000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入1000个汉字！",
                                minLength: 100,
                                minLengthText: "输入内容过短，最少输入100个汉字！"
                            },
                            {
                                fieldLabel: '项目收益预测依据',
                                name: 'XMSY_YCYJ',
                                xtype: 'textarea',
                                allowBlank: true,
                                hidden:true,
                                maxLength: 1000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入1000个汉字！"
                            }
                        ]
                    }
                ]
            }
        ],

    });
}

// 回填数据
function setZqxmJbqkForm(action) {
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
    //加载基本情况页签表单
    jbqkForm.getForm().setValues(action.result.data.jbqkForm);
}

// 获取保存数据
function getSaveZqxmJbqkForm() {
    //获取基本情况页签表单
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];

    var FGW_XMK_CODE = jbqkForm.getForm().findField('FGW_XMK_CODE').getValue();
    if (FGW_XMK_CODE != '无' && !FGW_XMK_CODE.match("^[a-zA-Z0-9_-]*$")) {
        Ext.Msg.alert('提示', "发改委审批监管代码仅可录“无”或字母数字编码");
        return false;
    }
    if (!jbqkForm.isValid()) {
        Ext.toast({
            html: jbqkTitle + "：请检查必填项，以及未通过校验项！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400,
            listeners: {
                "show": function () {
                    var i = findTabName(jbqkTitle);
                    zqxxtbTab(i);
                }
            }
        });
        return false;
    }

    var message_error = null;
    // if (!comparePlanDate(jbqkForm)) {
    //     message_error = '计划开工日期应该早于计划竣工日期';
    //     if (message_error != null && message_error != '') {
    //         Ext.Msg.alert('提示', message_error);
    //         zqxxtbTab(0);
    //         return false;
    //     }
    // }
    if (!compareActualDate(jbqkForm)) {
        message_error = '开工日期应该早于竣工日期';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(jbqkTitle);
            zqxxtbTab(i);
            return false;
        }
    }
    // if (!compareNowDateActualDate(jbqkForm)) {
    //     message_error = '竣工日期不应晚于当前时间';
    //     if (message_error != null && message_error != '') {
    //         Ext.Msg.alert('提示', message_error);
    //         var i = findTabName(jbqkTitle);
    //         zqxxtbTab(i);
    //         return false;
    //     }
    // }
    // if (!compareBuildActualDate(jbqkForm)) {
    //     message_error = '建设状态为已完工或已竣工结算，实际开工日期和实际竣工日期不可为空！';
    //     if (message_error != null && message_error != '') {
    //         Ext.Msg.alert('提示', message_error);
    //         var i=  findTabName(jbqkTitle);
    //         zqxxtbTab(i);
    //         return false;
    //     }
    // }

    return jbqkForm;
}

/*
*20201126
* 李月 重新加载项目类项方法
* ***/
function getxmstore(form) {
    var condition = "";
    // var XMXZ_ID = Ext.ComponentQuery.query('treecombobox[name="XMXZ_ID"]')[0].getValue();
    //var XMLX_ID = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0].getValue();
    var ZJTXLY_ID = Ext.ComponentQuery.query('treecombobox[name="ZJTXLY_ID"]')[0].getValue();
    // if (XMXZ_ID == '0101' || XMXZ_ID == '010101' || XMXZ_ID == '010102') {
    //     condition = " and xmfllx = 0 ";
    // } else if (XMXZ_ID == '0102') {
    //     condition = " and xmfllx = 1 ";
    // } else {
    //     condition = "";
    // }
    if (!!ZJTXLY_ID) {
        ZJTXLY_ID = '#' + ZJTXLY_ID;
        condition = condition + "AND extend1 LIKE '%" + ZJTXLY_ID.substring(0, 3) + "%'";
    }
    zwxmlx_store.proxy.extraParams['condition'] = encode64(condition);
    zwxmlx_store.load();

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
 */
function comparePlanDate(form) {
    // var START_DATE_PLAN = form.down('[name=START_DATE_PLAN]').getValue();
    // var END_DATE_PLAN = form.down('[name=END_DATE_PLAN]').getValue();
    // if (START_DATE_PLAN && END_DATE_PLAN && START_DATE_PLAN > END_DATE_PLAN) {
    //     return false;
    // }
    // return true;
}

/**
 * 比较实际开工/竣工日期
 */
function compareActualDate(form) {
    var START_DATE_ACTUAL = form.down('[name=START_DATE_ACTUAL]').getValue();
    var END_DATE_ACTUAL = form.down('[name=END_DATE_ACTUAL]').getValue();
    if (START_DATE_ACTUAL && END_DATE_ACTUAL && START_DATE_ACTUAL > END_DATE_ACTUAL) {
        return false;
    }
    return true;
}

/**
 * @param name 页签名称
 * @return true
 * @author zhuangrx
 * @date 2021/8/12
 * @description 获取页签名称
 */
function findTabName(name) {
    //获取页签panel
    var tbTab = Ext.ComponentQuery.query('panel[itemId="zqxxTab"]')[0];
    if (!isNull(tbTab)) {
        //页签循环与传入页签做对比，匹配则返回页签index
        for (var i = 0; i <= tbTab.items.length; i++) {
            if (tbTab.items.items[i].title == name) {
                return i;
            }
        }
    } else {
        //否则返回首页
        return 0;
    }
}

// TODO 补充信息 前期准备

// 初始化补充信息页签
function initWindow_zqxxtb_contentForm_tab_bcxx() {
    return Ext.create('Ext.form.Panel', {
        name: 'bcxxForm',
        itemId: 'bcxxForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            margin: '0 0 0 0',
            padding: '0 0 0 0',
            anchor: '100%'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldcontainer',
                layout: 'anchor',
                defaults: {
                    anchor: '100%',
                    margin: '20 10 0 0'
                },
                items: [
                    {
                        xtype: 'fieldcontainer',
                        layout: 'column',
                        defaultType: 'textfield',
                        fieldDefaults: {
                            labelWidth: 225,
                            columnWidth: .33,
                            margin: '5 5 5 5'
                        },
                        items: [
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否已经主管部门立项审批',
                                name: "BCXX1",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false

                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否已完成环评工作',
                                name: "BCXX2",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否已完成安评工作',
                                name: "BCXX3",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否已完成招投标工作',
                                name: "BCXX4",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否已完成相关征地拆迁等相关工作',
                                name: "BCXX5",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            // 2021 新增项
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否取得《国有土地使用证》',
                                name: "BCXX11",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否取得《建设用地规划许可证》',
                                name: "BCXX12",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否取得《建设工程规划许可证》',
                                name: "BCXX13",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否取得《建设工程施工许可证》',
                                name: "BCXX14",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>能否形成实物工作量',
                                name: "BCXX6",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                hidden: true,
                                allowBlank: true
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>能否形成有效投资支出',
                                name: "BCXX7",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                hidden: true,
                                allowBlank: true
                            },
                            {
                                xtype: "combobox",
                                name: "BCXX8",
                                store: DebtEleStore(json_debt_bcxx_yxdj),
                                fieldLabel: '<span class="required">✶</span>项目优先等级（一级优先等级最高）',
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 5,
                                hidden: true,
                                allowBlank: true
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>实施方案中是否包含事前绩效评估内容',
                                name: "BCXX15",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            }
                        ]
                    }

                ]
            }
        ]
    });
}

// 回填数据
function setZqxmBcxxForm(action) {
    //获取补充信息页签表单
    var bcxxForm = Ext.ComponentQuery.query('form[name="bcxxForm"]')[0];
    //加载补充信息页签表单
    bcxxForm.getForm().setValues(action.result.data.bcxxForm);
}

// 获取保存数据
function getSaveZqxmBcxxForm(IS_XMBCXX) {
    // 获取补充信息页签表单
    var bcxxForm = Ext.ComponentQuery.query('form[name="bcxxForm"]')[0];

    if (IS_XMBCXX == '1') {
        if (!bcxxForm.isValid()) {
            Ext.toast({
                html: bcxxTitle + "：请检查必填项，以及未通过校验项！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400,
                listeners: {
                    "show": function () {
                        var i = findTabName(bcxxTitle);
                        zqxxtbTab(i);
                    }
                }
            });
            return false;
        }
    }

    return bcxxForm;
}

// TODO 投资计划

/**
 * 初始化债券信息填报弹出窗口中的投资计划标签页
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
                title: '投资计划总结',
                layout: 'column',
                defaultType: 'textfield',
                anchor: '100%',
                collapsible: false,
                fieldDefaults: {
                    labelWidth: 110,
                    columnWidth: .25,
                    margin: '2 5 5 5'
                },
                items: [
                    {
                        fieldLabel: '项目总概算',
                        name: 'XMZGS_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '项目资本金',
                        name: 'ZBJ_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        decimalPrecision: 2,
                        value: 0,
                        listeners: {
                            'change': function () {
                                // var form = this.up('form').getForm();
                                // var ZBJ_AMT = form.findField('ZBJ_AMT').getValue();
                                // var XMZGS_AMT = form.findField('XMZGS_AMT').getValue();
                                // if (ZBJ_AMT - XMZGS_AMT > 0.0000001) {
                                //     Ext.Msg.alert("提示", "项目资本金不能大于项目总概算！");
                                //     form.findField('ZBJ_AMT').setValue(0);
                                //     return;
                                // }
                            }
                        }
                    },
                    {
                        fieldLabel: '其中财政预算安排',
                        name: 'ZBJ_YS_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        decimalPrecision: 2,
                        value: 0,
                        listeners: {
                            'change': function () {
                                // var form = this.up('form').getForm();
                                // var ZBJ_AMT = form.findField('ZBJ_AMT').getValue();
                                // var ZBJ_YS_AMT = form.findField('ZBJ_YS_AMT').getValue();
                                // var ZBJ_ZQ_AMT = form.findField('ZBJ_ZQ_AMT').getValue();
                                // if ((ZBJ_ZQ_AMT + ZBJ_YS_AMT) - ZBJ_AMT > 0.0000001) {
                                //     Ext.Msg.alert("提示", "其中财政预算安排资金与专项债券安排资金之和不能大于项目资本金！");
                                //     form.findField('ZBJ_YS_AMT').setValue(0);
                                //     return;
                                // }
                            }
                        }

                    },
                    {
                        fieldLabel: '专项债券安排',
                        name: 'ZBJ_ZQ_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        decimalPrecision: 2,
                        value: 0,
                        listeners: {
                            'change': function () {
                                // var form = this.up('form').getForm();
                                // var ZBJ_AMT = form.findField('ZBJ_AMT').getValue();
                                // var ZBJ_YS_AMT = form.findField('ZBJ_YS_AMT').getValue();
                                // var ZBJ_ZQ_AMT = form.findField('ZBJ_ZQ_AMT').getValue();
                                // if ((ZBJ_ZQ_AMT + ZBJ_YS_AMT) - ZBJ_AMT > 0.0000001) {
                                //     Ext.Msg.alert("提示", "其中财政预算安排资金与专项债券安排资金之和不能大于项目资本金！");
                                //     form.findField('ZBJ_ZQ_AMT').setValue(0);
                                //     return;
                                // }
                            }
                        }

                    },
                    {
                        fieldLabel: '市场化融资合计',
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
                        fieldLabel: '债券融资资金',
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
        ]
    });
}

/**
 * 初始化债券信息填报弹出窗口中的投资计划标签页中的表格
 */
function initWindow_zqxxtb_contentForm_tab_tzjh_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            width: 45,
            summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "年度", dataIndex: "ND", type: "string", tdCls: 'grid-cell',
            editor: {
                xtype: 'combobox', displayField: 'name', valueField: 'id', editable: false,
                store: DebtEleStore(json_debt_year), value: SET_YEAR
            }
        },
        {
            text: "年度总投资", dataIndex: "ZTZ", type: "float",
            columns: [
                {
                    text: "计划投资", dataIndex: "ZTZ_PLAN_AMT", type: "float", width: 160, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "实际到位", dataIndex: "ZTZ_ACTUAL_AMT", type: "float", width: 160, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                }
            ]
        },
        {
            text: "上级补助资金", dataIndex: "SJBZ", type: "float",
            columns: [
                {
                    text: "计划投资", dataIndex: "SJBZ_PLAN_AMT", type: "float", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "实际到位", dataIndex: "SJBZ_ACTUAL_AMT", type: "float", width: 160, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                }
            ]
        },
        {
            text: "本级财政预算资金", dataIndex: "CZYS", type: "float",
            columns: [
                {
                    text: "计划投资", dataIndex: "CZYS_PLAN_AMT", type: "float", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "实际到位", dataIndex: "CZYS_ACTUAL_AMT", type: "float", width: 160, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                }
            ]
        },
        {
            text: "融资资金", dataIndex: "RZZJ", type: "float",
            columns: [
                {
                    text: "计划投资", dataIndex: "RZZJ_PLAN_AMT", type: "float", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "实际到位", dataIndex: "RZZJ_ACTUAL_AMT", type: "float", width: 160, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },

                {
                    text: "小计", dataIndex: "RZZJ_XJ", type: "float", tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "新增一般债券资金",
                    dataIndex: "RZZJ_YBZQ_AMT",
                    type: "float",
                    width: 160,
                    tdCls: is_xz ? '' : 'grid-cell-unedit',
                    editor: is_xz ? {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0} : '',
                    editable: false,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "新增专项债券资金",
                    dataIndex: "RZZJ_ZXZQ_AMT",
                    type: "float",
                    width: 160,
                    tdCls: is_xz ? '' : 'grid-cell-unedit',
                    editor: is_xz ? {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0} : '',
                    editable: false,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "置换债券资金",
                    dataIndex: "RZZJ_ZHZQ_AMT",
                    type: "float",
                    width: 160,
                    tdCls: is_xz ? '' : 'grid-cell-unedit',
                    editor: is_xz ? {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0} : '',
                    editable: false,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "再融资债券资金",
                    dataIndex: "RZZJ_ZRZ_AMT",
                    type: "float",
                    width: 160,
                    tdCls: is_xz ? '' : 'grid-cell-unedit',
                    editor: is_xz ? {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0} : '',
                    editable: false,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                }

            ]
        },
        {
            text: "市场化融资资金",
            dataIndex: "RZZJ_SCRZ_AMT",
            type: "float",
            width: 160,
            tdCls: is_xz ? '' : 'grid-cell-unedit',
            editor: is_xz ? {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0} : '',
            editable: false,
            columns: [
                {
                    dataIndex: "SCRZ_PLAN_AMT", type: "float", text: "计划投资", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    dataIndex: "XY_AMT_RMB", type: "float", text: "实际到位", width: 160, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                }
            ]
        },
        {
            text: "单位自筹资金", dataIndex: "DWZC", type: "float",
            columns: [
                {
                    text: "计划投资", dataIndex: "DWZC_PLAN_AMT", type: "float", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "实际到位", dataIndex: "DWZC_ACTUAL_AMT", type: "float", width: 160, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                }
            ]
        },
        {
            text: "其他资金", dataIndex: "QT", type: "float",
            columns: [
                {
                    text: "计划投资", dataIndex: "QT_PLAN_AMT", type: "float", width: 160,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    text: "实际到位", dataIndex: "QT_ACTUAL_AMT", type: "float", width: 160, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
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
                pluginId: 'tzjhCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    //validateedit --> afteredit
                    'afteredit': function (editor, context) {
                        if (context.field == 'SJBZ_PLAN_AMT' || context.field == 'SJBZ_ACTUAL_AMT' ||
                            context.field == 'CZYS_PLAN_AMT' || context.field == 'CZYS_ACTUAL_AMT' ||
                            context.field == 'RZZJ_PLAN_AMT' || context.field == 'RZZJ_ACTUAL_AMT' ||
                            context.field == 'RZZJ_YBZQ_AMT' || context.field == 'RZZJ_ZXZQ_AMT' || context.field == 'RZZJ_ZHZQ_AMT' ||
                            context.field == 'DWZC_PLAN_AMT' || context.field == 'DWZC_ACTUAL_AMT' ||
                            context.field == 'QT_PLAN_AMT' || context.field == 'QT_ACTUAL_AMT') {
                            if (isNaN(parseFloat(context.value)) || parseFloat(context.value) < 0) {
                                Ext.toast({
                                    html: "输入错误字符或者资金低于0！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                        }
                        //自动计算年度总计划投资
                        if (context.field == 'SJBZ_PLAN_AMT' || context.field == 'CZYS_PLAN_AMT' || context.field == 'RZZJ_PLAN_AMT' || context.field == 'DWZC_PLAN_AMT' || context.field == 'QT_PLAN_AMT' || context.field == 'SCRZ_PLAN_AMT') {
                            var SJBZ_PLAN_AMT = (context.field == 'SJBZ_PLAN_AMT') ? context.value : context.record.get("SJBZ_PLAN_AMT");
                            var CZYS_PLAN_AMT = (context.field == 'CZYS_PLAN_AMT') ? context.value : context.record.get("CZYS_PLAN_AMT");
                            var RZZJ_PLAN_AMT = (context.field == 'RZZJ_PLAN_AMT') ? context.value : context.record.get("RZZJ_PLAN_AMT");
                            var DWZC_PLAN_AMT = (context.field == 'DWZC_PLAN_AMT') ? context.value : context.record.get("DWZC_PLAN_AMT");
                            var SCRZ_PLAN_AMT = (context.field == 'SCRZ_PLAN_AMT') ? context.value : context.record.get("SCRZ_PLAN_AMT");
                            var QT_PLAN_AMT = (context.field == 'QT_PLAN_AMT') ? context.value : context.record.get("QT_PLAN_AMT");
                            var ZTZ_PLAN_AMT = new Object(SJBZ_PLAN_AMT + CZYS_PLAN_AMT + RZZJ_PLAN_AMT + DWZC_PLAN_AMT + QT_PLAN_AMT + SCRZ_PLAN_AMT);
                            context.record.set('ZTZ_PLAN_AMT', ZTZ_PLAN_AMT);
                        }
                        //自动计算年度总总投资实际到位
                        if (context.field == 'SJBZ_ACTUAL_AMT' || context.field == 'CZYS_ACTUAL_AMT' || context.field == 'RZZJ_ACTUAL_AMT' || context.field == 'DWZC_ACTUAL_AMT' || context.field == 'QT_ACTUAL_AMT' || context.field == 'XY_AMT_RMB') {
                            var SJBZ_ACTUAL_AMT = (context.field == 'SJBZ_ACTUAL_AMT') ? context.value : context.record.get("SJBZ_ACTUAL_AMT");
                            var CZYS_ACTUAL_AMT = (context.field == 'CZYS_ACTUAL_AMT') ? context.value : context.record.get("CZYS_ACTUAL_AMT");
                            var RZZJ_ACTUAL_AMT = (context.field == 'RZZJ_ACTUAL_AMT') ? context.value : context.record.get("RZZJ_ACTUAL_AMT");
                            var DWZC_ACTUAL_AMT = (context.field == 'DWZC_ACTUAL_AMT') ? context.value : context.record.get("DWZC_ACTUAL_AMT");
                            var QT_ACTUAL_AMT = (context.field == 'QT_ACTUAL_AMT') ? context.value : context.record.get("QT_ACTUAL_AMT");
                            var XY_AMT_RMB = (context.field == 'XY_AMT_RMB') ? context.value : context.record.get("XY_AMT_RMB");
                            var ZTZ_ACTUAL_AMT = new Object(SJBZ_ACTUAL_AMT + CZYS_ACTUAL_AMT + RZZJ_ACTUAL_AMT + DWZC_ACTUAL_AMT + QT_ACTUAL_AMT + XY_AMT_RMB);
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
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel().getSelection();
                    if (connNdjh == '1' || connNdjh == 1 || connZwxx == '1' || connZwxx == 1) {//被引用项目
                        for (var i = 0; i < sm.length; i++) {
                            var current_year = new Date().getFullYear();
                            var check_year = current_year - 1;
                            var plan_id = sm[i].get('PLAN_ID');
                            if (sm[i].get('ND') <= check_year && plan_id != null && plan_id && plan_id != '') {
                                Ext.MessageBox.alert('提示', '该项目已经申报，无法删除' + check_year + '年及之前的明细投资计划！');
                                return false;
                            }
                        }
                    }
                    store.remove(sm);
                    calculateRzzjAmount(grid);  //计算  投资计划总结
                    if (store.getCount() > 0) {
                        grid.getSelectionModel().select(0);
                    }
                }
            }
        ]
    }, 0);
    grid.on('selectionchange', function (view, records) {
        grid.down('#tzjhDelBtn').setDisabled(!records.length);
    });
    return grid;
}

// 回填数据
function setZqxmTzjhForm(action) {

    //获取投资计划页签表单
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    //加载投资计划表单
    // var XMZGS_AMT = action.result.data.jbqkForm.XMZGS_AMT;
    // var LJWCTZ_AMT = action.result.data.jbqkForm.LJWCTZ_AMT;
    // var ZBJ_AMT = action.result.data.jbqkForm.ZBJ_AMT;
    // var ZBJ_ZQ_AMT = action.result.data.jbqkForm.ZBJ_ZQ_AMT;
    // var ZBJ_YS_AMT = action.result.data.jbqkForm.ZBJ_YS_AMT;
    // Ext.ComponentQuery.query('numberFieldFormat[name="XMZGS_AMT"]')[0].setValue(XMZGS_AMT);
    // Ext.ComponentQuery.query('numberFieldFormat[name="LJWCTZ_AMT"]')[0].setValue(LJWCTZ_AMT);
    // tzjhForm.down('numberFieldFormat[name="ZBJ_AMT"]').setValue(ZBJ_AMT);
    // tzjhForm.down('numberFieldFormat[name="ZBJ_ZQ_AMT"]').setValue(ZBJ_ZQ_AMT);
    // tzjhForm.down('numberFieldFormat[name="ZBJ_YS_AMT"]').setValue(ZBJ_YS_AMT);
    //加载投资计划页签表格
    var tzjhStore = action.result.data.tzjhGrid;
    var tzjhGrid = DSYGrid.getGrid('tzjhGrid');
    tzjhGrid.getStore().removeAll();
    tzjhGrid.insertData(null, tzjhStore);
    //当实际金额为0的时候才去计算
    if (tzjhGrid.getStore().getCount() > 0) {
        DSYGrid.getGrid("tzjhGrid").getStore().each(function (record) {
            if (record.get("RZZJ_ACTUAL_AMT") <= 0) {
                var RZZJ_XJ = record.get("RZZJ_YBZQ_AMT") + record.get("RZZJ_ZXZQ_AMT") + record.get("RZZJ_ZHZQ_AMT");
                record.set("RZZJ_ACTUAL_AMT", RZZJ_XJ);
            }
        });
    }
    calculateRzzjAmount(tzjhGrid);  //计算  投资计划总结
    initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
}
function setZqxmSdgcForm(action){
    //把十大工程的值set到填报页面里
    var sdgcStore = action.result.data.sdgcGrid;
    var sdgcGrid = DSYGrid.getGrid('sdgcGrid');
    sdgcGrid.getStore().removeAll();
    sdgcGrid.insertData(null, sdgcStore);
}
// 获取保存数据
function getSaveZqxmTzjhForm() {

    //获取投资计划页签表单
    var message_error;
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    //获取投资计划页签表格
    var xmsyStore = DSYGrid.getGrid("tzjhGrid").getStore();

    if (xmsyStore.sum('RZZJ_ACTUAL_AMT') < xmsyStore.sum('RZZJ_XJ')) {
        Ext.toast({
            html: "债券到位资金不应大于实际到位融资资金！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    }

    // 投资资金下 融资资金 实际到位不能小于 小计金额
    var store = tzjhForm.down('grid').getStore();
    store.each(function (record) {
        if (record.data.RZZJ_ACTUAL_AMT < record.data.RZZJ_XJ) {
            message_error = "投资计划：" + record.data.ND + " 融资资金下实际到位金额不能小于小计金额！";
            Ext.Msg.alert('提示', message_error);
            return false;
        }
    });
    // var xmzgs_amt = tzjhForm.down('numberFieldFormat[name="XMZGS_AMT"]').getValue();
    // var zbj_amt = tzjhForm.down('numberFieldFormat[name="ZBJ_AMT"]').getValue();
    // var zbj_zq_amt = tzjhForm.down('numberFieldFormat[name="ZBJ_ZQ_AMT"]').getValue();
    // var zbj_ys_amt = tzjhForm.down('numberFieldFormat[name="ZBJ_YS_AMT"]').getValue();
    // if (zbj_amt - xmzgs_amt > 0.00001) {
    //     Ext.Msg.alert('提示', '投资计划：项目资本金不得大于项目总概算!');
    //     return false;
    // }
    // if ((zbj_zq_amt + zbj_ys_amt) - zbj_amt > 0.00001) {
    //     Ext.Msg.alert('提示', '投资计划：其中财政预算安排资金与专项债券安排资金之和不得大于项目资本金!');
    //     return false;
    // }

    return tzjhForm;
}

function getSaveZqxmTzjhGrid(is_fxjh, bnsbForm) {

    //获取投资计划页签表单
    var message_error;
    var tzjhGrid = [];
    var tzjhNd = new Map();
    if (DSYGrid.getGrid("tzjhGrid").getStore().getCount() <= 0) {
        message_error = tzjhTitle + "：必须录入投资计划！";
        Ext.Msg.alert('提示', message_error);
        var i = findTabName(tzjhTitle);
        zqxxtbTab(i);
        return false;
    } else {
        DSYGrid.getGrid("tzjhGrid").getStore().each(function (record) {
            if (record.get('ND') == null || record.get('ND') == '' || record.get('ND') == 'undefined') {
                message_error = tzjhTitle + "：请填写列表中“年度”列";
                Ext.Msg.alert('提示', message_error);
                return false;
            }
            if (typeof (tzjhNd.get(record.get('ND'))) != 'undefined') {
                message_error = tzjhTitle + "：列表中“年度”不能相同";
                Ext.Msg.alert('提示', message_error);
                return false;
            } else {
                tzjhNd.put(record.get('ND'), '');
            }
            if (record.get('ND') == bnsbForm.getForm().findField('BILL_YEAR').getValue()) {
                if (DSYGrid.getGrid("xmcjqyGrid").getStore().sum('PAY_XMCJSR_AMT') > record.get('ZTZ_PLAN_AMT')) {
                    message_error = xmcjqyTitle + "：最终支付给企业的项目承建收入总额不能超过该年度项目投资！";
                    Ext.Msg.alert('提示', message_error);
                    var i = findTabName(xmcjqyTitle);
                    zqxxtbTab(i);
                    return false;
                }
            }
            if (record.get('ZTZ_PLAN_AMT') <= 0 && record.get('ZTZ_ACTUAL_AMT') <= 0) {
                message_error = record.get('ND') + "年投资计划年度总投资不能为0！";
                Ext.Msg.alert('提示', message_error);
                return false;
            }
            tzjhGrid.push(record.getData());
        });
    }
    if (is_fxjh == 3) {
        var bcsqje = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("APPLY_AMOUNT1").getValue();//本次申请金额
        if (bcsqje - xmzgs_amt > 0.0000001) {//申请金额超过项目总概算，禁止录入
            message_error = bcsbTitle + "：本次发行金额已超过项目总概算！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(bcsbTitle);
            zqxxtbTab(i);
            return false;
        }
    }
    return tzjhGrid;
}

// TODO 收支平衡 收支预算
/* 回填数据 */
function setZqxmSzphForm(xmId) {
    var self = false;
    change_tdcbysbz_grid(self, {XM_ID: xmId});
}

// 引用新版公共的
// 获取保存数据
function getSaveZqxmSzphForm(isOld_szysGrid, IS_XMBCXX, is_tdcb, bnsbForm) {
    //获取收支平衡页签表单
    var message_error
    var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
    // 收支平衡校验
    if (!xmsyForm.isValid()) {
        Ext.toast({
            html: szysTitle + "：请检查是否填写正确！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400,
            listeners: {
                "show": function () {
                    var i = findTabName(szysTitle);
                    zqxxtbTab(i);
                }
            }
        });
        return false;
    }
    var szysGrid = xmsyForm.down('grid');


    var xmztr_amt = szysGrid.getStore().sum('SRAMT_Y'); // 项目预计总收入
    var zfxjjkm_id = xmsyForm.down('treecombobox[name="ZFXJJKM_ID"]').getValue();    // 项目对应的政府性基金科目
    var xm_used_date = xmsyForm.down('datefield[name="XM_USED_DATE"]').getValue();    // 项目投入使用日期
    var xm_used_limit = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();  // 项目期限(年)
    var JS_USED_LIMIT = xmsyForm.down('numberFieldFormat[name="JS_USED_LIMIT"]').getValue();  // 建设期限(年)

    if (isOld_szysGrid == '1') {
        var xmsyform_temp = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0].getForm();
        if (szysGrid.getStore().sum('TOTAL_AMT') <= 0 && (bnsbForm.down('treecombobox[name="BOND_TYPE_ID"]').getValue() !== '01')) {
            message_error = "项目在申请专项债券时，必须录入" + szysTitle + "页签内容！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }
        //收支平衡页签表单
        var xmsyform_temp = xmsyForm.getForm();
        if (szysGrid.getStore().sum('TOTAL_AMT') <= 0 && zfxjjkm_id != null && zfxjjkm_id != "" && zfxjjkm_id != undefined) {
            message_error = szysTitle + "：项目对应的政府性基金科目不为空时，必须有收入！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }
        if (szysGrid.getStore().sum('TOTAL_AMT') > 0 && ((zfxjjkm_id == null) || (zfxjjkm_id == "") || zfxjjkm_id == undefined)) {
            message_error = szysTitle + "：项目收入合计不为0时，项目对应的政府性基金科目不可为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }
        if (szysGrid.getStore().data.length > 0 && (((xm_used_date == null) || (xm_used_date == "") || xm_used_date == undefined) || ((xm_used_limit == null) || (xm_used_limit == "") || xm_used_limit == undefined))) {
            message_error = szysTitle + "：项目投入使用日期或项目运营期限不能为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }
        if (szysGrid.getStore().data.length <= 0 && (((xm_used_date != null) && (xm_used_date != "") && xm_used_date != undefined) || ((xm_used_limit != null) && (xm_used_limit != "") && xm_used_limit != undefined))) {
            message_error = szysTitle + "：项目投入使用日期或项目运营期限不为空时，必须有收入！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }
        //结束时的年度大小判断
        var XM_USED_DATE_int = parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4));
        var XM_USED_LIMIT_int = parseInt(xmsyform_temp.findField("XM_USED_LIMIT").getValue());
        var xm_xmsy_boolean = false;
        szysGrid.getStore().each(function (record) {
            if (!((parseInt(record.get('INCOME_YEAR')) >= XM_USED_DATE_int) && (parseInt(record.get('INCOME_YEAR')) <= (XM_USED_DATE_int + XM_USED_LIMIT_int)))) {
                message_error = szysTitle + ":表中年度不能大于项目投入使用日期与项目运营期限之和，不能小于项目投入使用日期所在年度";
                xm_xmsy_boolean = true;
            }
        });
        if (xm_xmsy_boolean) {
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }

        //获取收支平衡页签表格
        var xmsyGrid = [];
        var xmsyNd = new Map();
        szysGrid.getStore().each(function (record) {
            if (typeof record.get('INCOME_YEAR') == 'undefined' || record.get('INCOME_YEAR') == null || record.get('INCOME_YEAR').length <= 0) {
                message_error = szysTitle + '：分年度收支预算的年度不能为空！';
                Ext.Msg.alert('提示', message_error);
                return false;
            }
            if (typeof (xmsyNd.get(record.get('INCOME_YEAR'))) != 'undefined') {
                message_error = szysTitle + "：列表中“年度”不能相同";
                Ext.Msg.alert('提示', message_error);
                return false;
            } else {
                xmsyNd.put(record.get('INCOME_YEAR'), '');
            }
            if (typeof record.get('TOTAL_AMT') == 'undefined' || record.get('TOTAL_AMT') == null || record.get('TOTAL_AMT') <= 0) {
                message_error = record.get('INCOME_YEAR') + "年收入总计不能为 0";
                Ext.Msg.alert('提示', message_error);
                return false;
            }
            xmsyGrid.push(record.getData());
        });
    } else {
        if (xm_used_date != null && xm_used_date != "" && xm_used_date != undefined) {
            var lx_year = Ext.ComponentQuery.query('combobox[name="LX_YEAR"]')[0].getValue();
            var newValue = format(xm_used_date, 'yyyy');
            if (newValue < lx_year) {
              //  xmsyForm.down('datefield[name="XM_USED_DATE"]').setValue('');
                message_error = szysTitle + "：项目投入使用日期不可小于立项年度！";
                Ext.Msg.alert('提示', message_error);
                var i = findTabName(szysTitle);
                zqxxtbTab(i);
                return false;
            }
        }
        // if (xmztr_amt <= 0 && zfxjjkm_id != null && zfxjjkm_id != "" && zfxjjkm_id != undefined) {
        //     message_error = szysTitle + "：项目对应的政府性基金科目不为空时，必须录入项目预计总收入！";
        //     Ext.Msg.alert('提示', message_error);
        //     var i = findTabName(szysTitle);
        //     zqxxtbTab(i);
        //     return false;
        // }
        if (xm_used_limit <= 0) {
            message_error = szysTitle + "：项目期限(年) 不能为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }
        if (JS_USED_LIMIT <= 0) {
            message_error = szysTitle + "：建设期限(年) 不能为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }
        if (xmztr_amt > 0 && ((zfxjjkm_id == null) || (zfxjjkm_id == "") || zfxjjkm_id == undefined)) {
            message_error = szysTitle + "：项目对应的政府性基金科目不可为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);

            return false;
        }
        if (xmztr_amt <= 0 && ((xm_used_date != null && xm_used_date != "" && xm_used_date != undefined) || (xm_used_limit != null && xm_used_limit != "" && xm_used_limit != undefined))) {
            message_error = szysTitle + "：开始日期或预算年限不为空时，必须录入项目预计总收入！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }
        if (xmztr_amt > 0 && (((xm_used_date == null) || (xm_used_date == "") || xm_used_date == undefined) || ((xm_used_limit == null) || (xm_used_limit == "") || xm_used_limit == undefined))) {
            message_error = szysTitle + "：项目预计总收入不为0时，开始日期和预算期限不能为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }
        // 如果项目类型非"土地储备" 则校验通用编制计划
        if (xmztr_amt <= 0 && (bnsbForm.down('treecombobox[name="BOND_TYPE_ID"]').getValue() !== '01')) {
            message_error = "项目在申请专项债券时，必须录入" + szysTitle + "页签内容！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return false;
        }
        var xmsyGrid = [];
        var is_negative = false; // 明细中是否存在负数
        var yyqx_count = 4; // 默认显示5年编制计划列
        if (!!xm_used_limit) {
            yyqx_count = xm_used_limit;
        }
        if (xm_used_limit > 30) {
            yyqx_count = 30;
        }
        if (is_tdcb) {
            if ((!!xmztr_amt) && xmztr_amt <= 0) {
                Ext.Msg.alert('提示', '项目类型为土地储备时项目预计总收入不能为零');
                var i = findTabName(szysTitle);
                zqxxtbTab(i);
                return false;
            }
            if (!zfxjjkm_id) {
                Ext.Msg.alert('提示', '项目类型为土地储备时项目对应的政府性基金科目不能为空');
                var i = findTabName(szysTitle);
                zqxxtbTab(i);
                return false;
            }
            // “评估土地使用权出让收入”之和大于等于“土地储备项目资金支出”之和，否则提示：土储项目应当实现总体收支平衡 01 >= 03
            // 当年“土地储备项目资金”必须大于等于“土地储备项目资金支出”，否则提示：土储项目应当实现年度收支平衡 02 >= 03
            var record_01 = szysGrid.getStore().getAt(gs_relation_guid["01"]); // 评估土地使用权出让收入 01
            var record_02 = szysGrid.getStore().getAt(gs_relation_guid["02"]); // 土地储备项目资金 02
            var record_03 = szysGrid.getStore().getAt(gs_relation_guid["03"]); // 土地储备项目资金支出 03
            var pgsr_sum_amt = 0.00; // 评估土地使用权出让收入总年度金额
            var zjzc_sum_amt = 0.00; // 土地储备项目资金支出总年度金额
            for (var i = 0; i <= yyqx_count; i++) {
                var SR = "SRAMT_Y" + i;
                var ZC = "ZCAMT_Y" + i;
                if (record_02.get(SR) < record_03.get(ZC)) {
                    Ext.Msg.alert('提示', '土储项目应当实现年度' + szysTitle);
                    var i = findTabName(szysTitle);
                    zqxxtbTab(i);
                    return false;
                }
                pgsr_sum_amt += record_01.get(SR);
                zjzc_sum_amt += record_03.get(ZC);
            }
            if (pgsr_sum_amt < zjzc_sum_amt) {
                Ext.Msg.alert('提示', '土储项目应当实现总体' + szysTitle);
                var i = findTabName(szysTitle);
                zqxxtbTab(i);
                return false;
            }
        }

        if (is_tdcb == false) {

            // 对还本总金额进行校验
            var record_06 = szysGrid.getStore().getAt(gs_relation_guid["06"]);// 获取专项债券金额
            var record_0202 = szysGrid.getStore().getAt(gs_relation_guid["0202"]);// 获取地方政府专项债券金额
            var record_020201 = szysGrid.getStore().getAt(gs_relation_guid["020201"]);// 其中
            var record_07 = szysGrid.getStore().getAt(gs_relation_guid["07"]);// 获取市场化融资金额
            var record_0203 = szysGrid.getStore().getAt(gs_relation_guid["0203"]);// 获取项目单位市场化融资金额
            var record_02 = szysGrid.getStore().getAt(gs_relation_guid["02"]);// 资金来源
            var record_03 = szysGrid.getStore().getAt(gs_relation_guid["03"]);// 建设支出
            var record_0303 = szysGrid.getStore().getAt(gs_relation_guid["0303"]);// 建设支出
            var record_01 = szysGrid.getStore().getAt(gs_relation_guid["01"]);// 建设支出

            var a=checkSzysHj(yyqx_count);
            if(!a.container.is_success){
                Ext.Msg.alert('提示',a.container.msg);
                return false;
            }
            var zxzqhb_amt = 0.00; // 专项债券还本总金额
            var zxzq_amt = 0.00;   // 专项债券总金额
            var schrzhb_amt = 0.00;// 市场化融资还本总金额
            var schrz_amt = 0.00;  // 市场化融资总金额
            var zily_amt = 0.00;// 市场化融资还本总金额
            var jszc_amt = 0.00;  // 市场化融资总金额
            var jscb_amt = 0.00;  // 市场化融资总金额
            var yycb_amt = 0.00;  // 市场化融资总金额

            // 循环计算所有年度总收入总支出合计值
            for (var i = 0; i <= yyqx_count; i++) {
                var SR = "SRAMT_Y" + i;
                var ZC = "ZCAMT_Y" + i;
                zxzqhb_amt += parseFloat(record_06.get(ZC) == "" ? 0 : record_06.get(ZC));
                zxzq_amt += parseFloat(record_0202.get(SR) == "" ? 0 : record_0202.get(SR));
                schrzhb_amt += parseFloat(record_07.get(ZC) == "" ? 0 : record_07.get(ZC));
                schrz_amt += parseFloat(record_0203.get(SR) == "" ? 0 : record_0203.get(SR));
                zily_amt += parseFloat(record_02.get(SR) == "" ? 0 : record_02.get(SR));
                jszc_amt += parseFloat(record_03.get(ZC) == "" ? 0 : record_03.get(ZC));
                jscb_amt += parseFloat(record_0303.get(ZC) == "" ? 0 : record_0303.get(ZC));
                yycb_amt += parseFloat(record_01.get(SR) == "" ? 0 : record_01.get(SR));
                if (record_0202.get(SR) < record_020201.get(SR)) {
                    Ext.Msg.alert('提示', '其中：用于资本金金额不能大于地方政府专项债券金额！');
                    return false;
                }
            }
            var fx_amt_0301 = 0.00; // 专项债券还本总金额
            var fx_amt_0402 = 0.00;   // 专项债券总金额
            var amt_08 = 0.00;   // 资金平衡

            if (zxzq_amt == 0) {
                Ext.Msg.alert('提示', '（二）地方政府专项债券 不能为0！');
                return false;
            }

            //20211020liyue添加付息金额不能为负数校验，付息金额为负数证明还本金额大于当年专项收入金额及前几年专项收入金额的合计值！
            var record_0301 = szysGrid.getStore().getAt(gs_relation_guid["0301"]);//0301建设付息行
            var record_0402 = szysGrid.getStore().getAt(gs_relation_guid["0402"]);//0402收入付息行
            var record_0302 = szysGrid.getStore().getAt(gs_relation_guid["0302"]);// （三）财务费用-市场化融资付息
            var record_0403 = szysGrid.getStore().getAt(gs_relation_guid["0403"]);
            var record_04 = szysGrid.getStore().getAt(gs_relation_guid["04"]);// 四、项目运营支出
            var r=0;
            var js=0;
            var record_0302_sum = 0.00;  // （三）财务费用-市场化融资付息
            var record_0403_sum = 0.00;
            var jszjly_amt=0.00;//建设资金来源 总金额
            var xmyysr_amt=0.00//项目运营收入
            var xmyyzc_zmt=0.00;//项目运营支出总金额
            var xmjszc_amt=0.00;//项目建设支出总金额
            for (var i = 0; i <= yyqx_count; i++) {
                var ZC = "ZCAMT_Y" + i;
                var SR = "SRAMT_Y" + i;
                fx_amt_0301 = parseFloat(record_06.get(ZC) == "" ? 0 : record_0301.get(ZC));//0301建设付息金额
                fx_amt_0402 = parseFloat(record_0202.get(SR) == "" ? 0 : record_0402.get(SR));//0402收入付息金额
                record_0302_sum += parseFloat(record_0302.get(ZC) == "" ? 0 : record_0302.get(ZC));
                record_0403_sum+= parseFloat(record_0403.get(ZC) == "" ? 0 : record_0403.get(ZC));
                jszjly_amt += parseFloat(record_02.get(SR) == "" ? 0 : record_02.get(SR));//建设资金来源 总金额
                xmyyzc_zmt+=parseFloat(record_04.get(ZC) == "" ? 0 : record_04.get(ZC));//项目运营支出总金额
                xmjszc_amt+=parseFloat(record_03.get(ZC) == "" ? 0 : record_03.get(ZC));//项目运营支出总金额
                xmyysr_amt += parseFloat(record_01.get(SR) == "" ? 0 : record_01.get(SR));
                if (fx_amt_0301 < 0) {
                    Ext.Msg.alert('提示', '财务费用-专项债券付息金额不能为负！');
                    return false;
                }
                if (fx_amt_0402 < 0) {
                    Ext.Msg.alert('提示', '财务费用-专项债券付息支出金额不能为负数！');
                    return false;
                }
                 if (Math.abs((parseFloat(zxzqhb_amt).toFixed(6) - parseFloat(zxzq_amt).toFixed(6)).toFixed(6)) > 0.000001) {
                     Ext.Msg.alert('提示', '专项债券还本总金额应等于地方政府专项债券总金额！');
                     return false;
                 }
                if (Math.abs((parseFloat(jscb_amt).toFixed(6))) < 0.000001) {
                    Ext.Msg.alert('提示', '项目建设成本（不含财务费用）不能为0！');
                    return false;
                }
                if (Math.abs((parseFloat(yycb_amt).toFixed(6))) < 0.000001) {
                    Ext.Msg.alert('提示', '项目运营预期收入不能为0！');
                    return false;
                }
                var s= record_0202.get(srkey[i]);
                if(i>JS_USED_LIMIT){
                    if(s>0){
                        js+=1;
                    }
                }
                if(js>0){
                    Ext.Msg.alert('提示', '发行时间不能超过项目建设期！');
                    return false;
                }
               /* if ( parseFloat(jszc_amt).toFixed(6) -  parseFloat(zily_amt).toFixed(6)<0) {
                    Ext.Msg.alert('提示', '建设支出应该大于等于项目建设资金来源！');
                    return false;
                }*/
                /*    if (amt_08 < 0) {
                        Ext.Msg.alert('提示', '资金平衡情况金额不能为负数！');
                        return false;
                    }*/
            }
            if (schrzhb_amt > 0 && record_0302_sum + record_0403_sum<= 0) {
                Ext.Msg.alert('提示', '市场化融资还本不为空时,财务费用-市场化融资付息必须大于0！');
                return false;
            }
            //辽宁特性
            if (parseFloat(zxzqhb_amt).toFixed(6)-parseFloat((jszjly_amt+xmyysr_amt) -(xmyyzc_zmt+xmjszc_amt)).toFixed(6)> 0.000001&&sysAdcode=='21') {//20210420liyue添加建设项目支出与其中金额校验
                Ext.Msg.alert('提示', '（建设资金来源 + 项目运营预期收入） - 项目运营支出 - 项目建设支出小于专项债券还本！');                return false;
            }
            if (Math.abs(((schrzhb_amt).toFixed(6) - (schrz_amt).toFixed(6)).toFixed(6)) > 0.000001) {
                Ext.Msg.alert('提示', '市场化融资还本总金额应等于项目单位市场化融资总金额！');
                return false;
            }
            //
            if (Math.abs((parseFloat(jscb_amt).toFixed(6))) < 0.000001) {
                Ext.Msg.alert('提示', '项目建设成本（不含财务费用）不能为0！');
                return false;
            }





            var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
            var store = xmsyForm.down('grid').getStore();
            var bxfg = store.getAt(gs_relation_guid["09"]);
            /*if(XMXZ_ID == '010102') {
                // BXFGBS_XX不为0与不为null则较验
                if (BXFGBS_XX != '0' && BXFGBS_XX != 'null' && BXFGBS_XX != '') {
                    if (bxfg.data.SRAMT_Y0 < parseFloat(BXFGBS_XX)) {
                        Ext.Msg.alert('提示', '本息覆盖倍数必须大于或等于' + BXFGBS_XX + '倍！');
                        Ext.ComponentQuery.query('panel[itemId="zqxxTab"]')[0].items.get(5).show()
                        return false;
                    }
                }
            }
            if(BXFGBS_SX != '0' && BXFGBS_SX != 'null' && BXFGBS_SX != ''){
                if(bxfg.data.SRAMT_Y0 > parseFloat(BXFGBS_SX)){
                    Ext.Msg.alert('提示','本息覆盖倍数过大，请检查数据！');
                    Ext.ComponentQuery.query('panel[itemId="zqxxTab"]')[0].items.get(5).show()
                    return false;
                }
            }
            if(checkBxfgFromImport()){//本息覆盖倍数校验
                return false;
            }*/
        }
        szysGrid.getStore().each(function (record) {
            for (var j = 0; j < yyqx_count; j++) {
                var SR = "SRAMT_Y" + j;
                var ZC = "ZCAMT_Y" + j;
            }
            if (is_negative) {
                return false;
            }
            xmsyGrid.push(record.getData());
        });
    }
    var re = {
        "xmsyForm": xmsyForm,
        "xmsyGrid": xmsyGrid,
    }
    return re;
}

// TODO 本次申报

/**
 * 初始化债券信息填报弹出窗口中的本次申报标签页
 */
function initWindow_zqxxtb_contentForm_tab_bnsb() {
    return Ext.create('Ext.form.Panel', {
        name: 'bnsbForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        padding: '0 5 0 5',
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldcontainer',
                style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
                layout: 'column',
                border: false,
                defaultType: 'textfield',
                fieldDefaults: {
                    labelWidth: 160,
                    columnWidth: .333,
                    labelAlign: 'left',
                    margin: '2 5 2 5'
                },
                items: [
                    {
                        fieldLabel: '本次申报ID',
                        name: 'ID',
                        hidden: true
                    },
                    {
                        fieldLabel: '申报单号',
                        name: 'BILL_NO',
                        hidden: true
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>申报日期',
                        name: 'APPLY_DATE',
                        xtype: 'datefield',
                        format: 'Y-m-d',
                        allowBlank: false,
                        editable: false,
                        value: today
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>经办人',
                        name: 'APPLY_INPUTOR',
                        allowBlank: true,
                        readOnly: true,
                        hidden: true ,
                        fieldStyle: 'background:#E6E6E6',
                        value: userName
                    },
                    {
                        fieldLabel: '申请年度',
                        name: 'BILL_YEAR',
                        xtype: 'combobox',
                        value: (is_fxjh == 1) ? SET_YEAR : SET_YEAR + 1,
                        editable: false,
                        displayField: 'name',
                        valueField: 'id',
                        store: DebtEleStore(getYears),
                        allowBlank: false,
                        readOnly: (is_fxjh == '1') ? true : false,
                        fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        listeners: {
                            change: function (self, newValue, oldValue) {
                                if (newValue != oldValue && newValue != null) {
                                    // 回调 lr js中的函数 注意重构!!!
                                    //同步更新，供申报批次修改时加载批次使用
                                    BATCH_YEAR=newValue;
                                    BATCH_BOND_TYPE_ID=self.next("[name=BOND_TYPE_ID]")==null?BATCH_BOND_TYPE_ID:self.next("[name=BOND_TYPE_ID]").getValue();
                                    getKmJcsj(newValue, false);
                                    Ext.MessageBox.wait('正在获取新年度功能分类、经济分类数据..', '请等待..');
                                    zwsrkm_store.load({
                                        callback: function () {
                                            zcgnfl_store.load({
                                                callback: function () {
                                                    zcjjfl_store.load({
                                                        callback: function () {
                                                            sbpc_store.load({
                                                                callback : function() {
                                                                    Ext.MessageBox.hide();
                                                                }
                                                            });
                                                        }
                                                    });
                                                }
                                            });
                                        }
                                    });
                                }
                                // 动态修改标题
                                var yearNum = !!newValue ? newValue : oldValue;
                                var title = "<span class='required'>✶</span>" + yearNum + "年申请金额";
                                var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0]
                                if (!!bnsbForm) {
                                    var APPLY_AMOUNT1 = bnsbForm.down('numberfield[name="APPLY_AMOUNT1"]');
                                    !!APPLY_AMOUNT1 ? APPLY_AMOUNT1.setFieldLabel(title) : '';
                                }
                                updateZjeSqje()
                            },
                            select:function (self,record){
                                $.post("/findYfxAmt.action",{
                                    XM_ID:XM_ID,
                                    SET_YEAR:self.getValue()
                                },  function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }else{
                                        var form = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
                                        var YFX_AMT = form.getForm().findField('YFX_AMT');
                                        YFX_AMT.setValue(data.list[0].YFX_AMT);
                                    }

                                }, "json");
                            },
                        }
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>申请月份',
                        name: 'BILL_MONTH',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        allowBlank: (is_fxjh == 4) ? false : true,
                        editable: false,
                        hidden: is_fxjh == 4 ? false : true,
                        store: monthStore
                    },
                    {
                        xtype:'combobox',
                        fieldLabel:'<span class="required">✶</span>发行月份',
                        name: 'ZQXM_FX_MONTH',
                        displayField:'name',
                        valueField:'code',
                        hidden:is_fxjh=='0'||is_fxjh=='3'?false:true,
                        editable:false,
                        value:nowDate.substring(5,7),
                        allowBlank:is_fxjh=='0'||is_fxjh=='3'?false:true,
                        store:DebtEleStore(json_debt_yf_nd)
                    },

                    {
                        fieldLabel: '<span class="required">✶</span>债券类型',
                        name: 'BOND_TYPE_ID',
                        xtype: 'treecombobox',
                        // store: DebtEleStore(yb_zx_json),
                        store: DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " and code = '02' "}),
                        // store: is_zxzqxt == 1 ?
                        //     DebtEleTreeStoreDB('DEBT_ZQLB', {
                        //         condition: "AND CODE NOT LIKE '01%' and code!='0201' " + (
                        //             is_zxzq == '1' ? " AND CODE LIKE '02%' "
                        //                 : is_zxzq == '2' ? " AND CODE LIKE '01%'" : ""
                        //         )
                        //     })
                        //     : DebtEleTreeStoreDB('DEBT_ZQLB', {
                        //         condition: " and code!='0201' " + (
                        //             is_zxzq == '1' ? " AND CODE LIKE '02%' "
                        //                 : is_zxzq == '2' ? " AND CODE LIKE '01%'" : ""
                        //         )
                        //     }),
                        displayField: 'name',
                        valueField: 'id',
                        value: '02',//bond_type_id,
                        // selectModel: 'leaf',
                        editable: false,
                        allowBlank: false,
                        readOnly: false,
                        // fieldStyle: 'background:#E6E6E6',
                        listeners: {
                            change: function (self,newValue) {
                                //根据债券类型重新加载批次
                                BATCH_YEAR=self.next("[name=BILL_YEAR]")==null?BATCH_YEAR:self.next("[name=BILL_YEAR]").getValue();
                                BATCH_BOND_TYPE_ID=newValue;
                                sbpc_store.proxy.extraParams['BATCH_YEAR'] = BATCH_YEAR;
                                sbpc_store.proxy.extraParams['BOND_TYPE'] = isNull(BATCH_BOND_TYPE_ID)?"":BATCH_BOND_TYPE_ID.substr(0, 2);
                                sbpc_store.proxy.extraParams['AD_CODE'] = AD_CODE;
                                sbpc_store.proxy.extraParams['is_fxjh'] = is_fxjh;
                                sbpc_store.proxy.extraParams['TYPE'] = 'jhtb';
                                sbpc_store.load();
                            }
                            // 'change': function (self, newValue, oldValue, e) {
                            //     var form = this.up('form').getForm();
                            //     // var IS_XMZBJ = form.findField('IS_XMZBJ').value;
                            //     //2020121414_zhuangrx_中小银行时经济分类支出分类不是必录
                            //     if (newValue == '020204') {
                            //         form.findField('GNFL_ID').allowBlank = true;
                            //         form.findField('GNFL_ID').setFieldLabel('支出功能分类');
                            //         form.findField('JJFL_ID').allowBlank = true;
                            //         form.findField('JJFL_ID').setFieldLabel('支出经济分类');
                            //     } else {
                            //         form.findField('GNFL_ID').allowBlank = false;
                            //         form.findField('GNFL_ID').setFieldLabel('<span class="required">✶</span>支出功能分类');
                            //         form.findField('JJFL_ID').allowBlank = false;
                            //         form.findField('JJFL_ID').setFieldLabel('<span class="required">✶</span>支出经济分类');
                            //     }
                            //     // 2020年06月30日 财政部下达抗疫国债 增加
                            //     if (is_fxjh == 1 && newValue != '01') {
                            //         /* 发行项目遴选申报时：如果选择的类型是专项类型的债券则置灰新增赤字资金
                            //          */
                            //         var form = this.up('form').getForm();
                            //         form.findField('XZCZAP_AMT').setReadOnly(true);
                            //         form.findField('XZCZAP_AMT').allowBlank = false;
                            //         form.findField('XZCZAP_AMT').setFieldStyle('background:#E6E6E6');
                            //         var SBBATCH_NO = form.findField('SBBATCH_NO').value;
                            //         if (SBBATCH_NO == '98202002') {
                            //             Ext.Msg.alert("提示", "债券类型为专项债券类型时不能选择“98202002 新增财政赤字直达基层申报批次”！");
                            //             form.findField('SBBATCH_NO').setValue('');
                            //             return;
                            //         }
                            //     } else {
                            //         var form = this.up('form').getForm();
                            //         form.findField('XZCZAP_AMT').setReadOnly(false);
                            //         form.findField('XZCZAP_AMT').allowBlank = true;
                            //         form.findField('XZCZAP_AMT').setFieldStyle('background:#FFFFFF');
                            //     }
                            //     if (newValue != '01') {
                            //         //专项债券是否为项目资本金校验
                            //         // form.findField('IS_XMZBJ').setReadOnly(false);
                            //         // form.findField('IS_XMZBJ').setFieldStyle('background:#FFFFFF');
                            //         /*
                            //          *用于项目资本金校验
                            //          */
                            //         // if (form.findField('IS_XMZBJ').getValue() == 0) {//是否为项目资本金为否时 资本金金额为0 置灰
                            //         // form.findField('ZBJ_AMT').setReadOnly(true);
                            //         // form.findField('ZBJ_AMT').setFieldStyle('background:#FFFFFF');
                            //         // }
                            //         // form.findField('ZBJ_AMT').setReadOnly(false);
                            //         // if (IS_XMZBJ == '1') {//是项目资本金
                            //         //     form.findField('ZBJ_AMT').allowBlank = false;
                            //         //     form.findField('ZBJ_AMT').setFieldStyle('background:#FFFFFF');
                            //         //     form.findField('IS_XMZBJ').setReadOnly(false);
                            //         // } else if (IS_XMZBJ == '0') {//不是项目资本金
                            //         // form.findField('ZBJ_AMT').allowBlank = true;
                            //         // form.findField('ZBJ_AMT').setFieldStyle('background:#E6E6E6');
                            //         // }
                            //     } else {
                            //         //一般债券
                            //         // form.findField('IS_XMZBJ').setValue(0);
                            //         // form.findField('IS_XMZBJ').setReadOnly(true);
                            //         // form.findField('IS_XMZBJ').setFieldStyle('background:#E6E6E6');
                            //         // form.findField('ZBJ_AMT').setReadOnly(true);
                            //         // form.findField('ZBJ_AMT').setFieldStyle('background:#E6E6E6');
                            //         // form.findField('ZBJ_AMT').setValue(0);
                            //         // if (IS_XMZBJ == '1') {//是项目资本金
                            //         //     form.findField('ZBJ_AMT').allowBlank = false;
                            //         // } else if (IS_XMZBJ == '0') {//不是项目资本金
                            //         // form.findField('ZBJ_AMT').allowBlank = true;
                            //         // }
                            //
                            //     }
                            // }
                        }
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>项目状态',
                        name: 'FILTER_STATUS_ID',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        store: DebtEleStore(json_debt_xmzt),
                        value: '01',
                        fieldStyle: 'background:#E6E6E6',
                        hidden: true,
                        readOnly: true
                    },
                    {
                        fieldLabel: '申请金额',
                        name: 'FP_AMT',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 2,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        hidden: is_fdq == 0 && (is_fxjh != 3) ? false : true,//辅导期中隐藏
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true
                    },
                    {
                        fieldLabel: '申请总金额',
                        name: 'APPLY_AMOUNT_TOTAL',
                        xtype: 'numberfield',
                        decimalPrecision: 2,
                        hideTrigger: true,
                        allowBlank: false,
                        fieldStyle: 'background:#E6E6E6',
                        maxValue: 9999999999,
                        readOnly: true,
                        hidden: false
                    },
                    {
                        fieldLabel: '往年已发行金额',
                        name: 'YFX_AMT',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 2,
                        hideTrigger: true,
                        allowBlank: false,
                        fieldStyle: 'background:#E6E6E6',
                        maxValue: 9999999999,
                        value:0,
                        readOnly: true,
                        hidden: false
                    },
                    { /* 请勿改动 WebRoot/js/debt/xmsySzysGrid.js 里会调用此组件 */
                        fieldLabel: is_fdq == 0 ? '<span class="required">✶</span>本次发行金额' : "<span class='required'>✶</span>" + sqjeYear + "年申请金额",
                        name: 'APPLY_AMOUNT1',
                        id: 'APPLY_AMOUNT1',
                        xtype: 'numberfield',
                        decimalPrecision: 2,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        allowBlank: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        listeners: {
                            'change': function () {
                                // var form = this.up('form').getForm();
                                // var APPLY_AMOUNT1 = form.findField('APPLY_AMOUNT1').value;
                                // var APPLY_AMOUNT2 = form.findField('APPLY_AMOUNT2').value;
                                // var APPLY_AMOUNT3 = form.findField('APPLY_AMOUNT3').value;
                                //
                                // var APPLY_AMOUNT_TOTAL = form.findField('APPLY_AMOUNT_TOTAL');
                                // APPLY_AMOUNT_TOTAL.setValue(APPLY_AMOUNT1 + APPLY_AMOUNT2 + APPLY_AMOUNT3);
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "ZQQX_ID",
                        // store: DebtEleStoreDB("DEBT_ZQQX"),
                        store: DebtEleStore(zqqx_store),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>债券期限',
                        editable: false,
                        allowBlank: false,
                    },
                    {
                        fieldLabel: '其中用于偿还本金',
                        name: 'RETURN_CAPITAL',
                        hideTrigger: true,
                        xtype: 'numberFieldFormat',
                        value: 0,
                        hidden: true
                    },
                    {
                        xtype: "combobox",
                        name: "IS_XMZBJ",
                        fieldLabel: '<span class="required">✶</span>是否用于项目资本金',
                        value: newValue,
                        displayField: 'name',
                        valueField: 'id',
                        minValue: 0,
                        value: 0,
                        store: DebtEleStore(s_is_xmzbj),
                        allowBlank: true,
                        hidden: true,
                        editable: false,
                        listeners: {
                            change: function (self, newvalue) {
                                // if (!self.getValue()) {
                                //     IS_XMZBJ = self.up('form').down('combobox[name="IS_XMZBJ"]').getValue();
                                //     self.up('form').down('combobox[name="IS_XMZBJ"]').setValue(IS_XMZBJ);
                                //     return IS_XMZBJ;
                                // }
                                // var form = this.up('form').getForm();
                                // var ZBJ_AMT = this.up('form').getForm().findField('ZBJ_AMT');
                                // if (newvalue == '1') {
                                //     ZBJ_AMT.allowBlank = false;
                                //     ZBJ_AMT.setFieldLabel('<span class="required">✶</span>债券用于项目资本金金额');
                                //     form.findField('ZBJ_AMT').setFieldStyle('background:#FFFFFF');
                                //     form.findField('ZBJ_AMT').setReadOnly(false);
                                //
                                // } else {
                                //     form.findField('ZBJ_AMT').allowBlank = true;
                                //     form.findField('ZBJ_AMT').setReadOnly(true);
                                //     form.findField('ZBJ_AMT').setFieldStyle('background:#E6E6E6');
                                //     form.findField('ZBJ_AMT').setValue(0);
                                //     ZBJ_AMT.setFieldLabel('债券用于项目资本金金额');
                                // }
                            }
                        }
                    },
                    {
                        fieldLabel: '债券用于项目资本金金额',
                        name: 'ZBJ_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        value: 0,
                        decimalPrecision: 2,
                        hidden: true,
                        allowBlank: true,// (is_xmzbj == 1) ? false : true,
                        listeners: {
                            'change': function () {

                            }
                        }
                    },
                    {
                        fieldLabel: '其中：新增赤字安排资金',
                        name: 'XZCZAP_AMT',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        allowBlank: true,
                        hidden: is_fxjh == 1 ? false : true,
                        listeners: {
                            'change': function (self, newValue, oldValue, e) {
                                /*      if (is_fxjh == 1) {
                                          var form = this.up('form').getForm();
                                          var APPLY_AMOUNT1 = form.findField('APPLY_AMOUNT1').value;
                                          var APPLY_NAME = form.findField('APPLY_AMOUNT1').fieldLabel.replace("<span class=\"required\">✶</span>","");
                                          if (newValue > APPLY_AMOUNT1) {
                                              Ext.Msg.alert("提示","其中：新增赤字安排资金不能超过" + APPLY_NAME) ;
                                              self.setValue(0);
                                              return;
                                          }
                                      }*/
                            }
                        }
                    },
                    {
                        fieldLabel: '第二年申请金额',
                        name: 'APPLY_AMOUNT2',
                        minValue: 0,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        hidden: true,
                        listeners: {
                            'change': function () {
                                // var form = this.up('form').getForm();
                                // var APPLY_AMOUNT1 = form.findField('APPLY_AMOUNT1').value;
                                // var APPLY_AMOUNT2 = form.findField('APPLY_AMOUNT2').value;
                                // var APPLY_AMOUNT3 = form.findField('APPLY_AMOUNT3').value;
                                //
                                // var APPLY_AMOUNT_TOTAL = form.findField('APPLY_AMOUNT_TOTAL');
                                // APPLY_AMOUNT_TOTAL.setValue(APPLY_AMOUNT1 + APPLY_AMOUNT2 + APPLY_AMOUNT3);
                            }
                        }
                    },
                    {
                        fieldLabel: '第三年申请金额',
                        name: 'APPLY_AMOUNT3',
                        minValue: 0,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        hidden: true,
                        listeners: {
                            'change': function () {
                                // var form = this.up('form').getForm();
                                // var APPLY_AMOUNT1 = form.findField('APPLY_AMOUNT1').value;
                                // var APPLY_AMOUNT2 = form.findField('APPLY_AMOUNT2').value;
                                // var APPLY_AMOUNT3 = form.findField('APPLY_AMOUNT3').value;
                                //
                                // var APPLY_AMOUNT_TOTAL = form.findField('APPLY_AMOUNT_TOTAL');
                                // APPLY_AMOUNT_TOTAL.setValue(APPLY_AMOUNT1 + APPLY_AMOUNT2 + APPLY_AMOUNT3);
                            }
                        }
                    },
                    {
                        fieldLabel: '项目总申请金额',
                        name: 'ZJE',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        hidden: true,//辅导期中隐藏
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true
                    }, {
                        fieldLabel: '项目已使用金额',
                        name: 'YSY',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        hidden: true,//辅导期中隐藏
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true
                    }, {
                        fieldLabel: '项目剩余金额',
                        name: 'SYJE',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        hidden: true,//辅导期中隐藏
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true
                    },
                    {
                        fieldLabel: '项目自身收益偿还',
                        name: 'XMZSSYCH_AMT',
                        xtype: 'numberFieldFormat',
                        maxValue: 9999999999,
                        hidden: true,
                        hideTrigger: true,
                        allowBlank: true
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZFXJJKM",
                        store: zwsrkm_store,
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '政府性基金科目',
                        editable: false, //禁用编辑
                        selectModel: "leaf",
                        hidden: true,
                        allowBlank: true
                    },
                    {
                        fieldLabel: '政府性基金偿还',
                        name: 'ZFXJJCH_AMT',
                        xtype: 'numberFieldFormat',
                        maxValue: 9999999999,
                        minValue: 0,
                        hidden: true,
                        hideTrigger: true,
                        allowBlank: true
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>申报批次',
                        name: 'SBBATCH_NO',
                        xtype: 'treecombobox',
                        displayField: 'text',
                        valueField: 'id',
                        allowBlank: ((is_fxjh==1||is_fxjh==4)&&!(sys_right_model=='1' && is_zxzqxt == 1 )) || (is_fxjh==3 && GxdzUrlParam == sysAdcode)?false:true,// 只在区划为13或者42时申报批次为必录
                        editable: false,
                        hidden:((is_fxjh==1||is_fxjh==4)&&!(sys_right_model=='1' && is_zxzqxt == 1 )) || (is_fxjh==3 && GxdzUrlParam == sysAdcode)?false:true,// 只在区划为13或者42时申报批次不隐藏
                        /*store:is_fxjh==3?sbpc_store:DebtEleTreeStoreDB('DEBT_FXPC',{condition: " and year = '"+BATCH_YEAR+"' and (EXTEND1 = '" +"01"+
                        BATCH_BOND_TYPE_ID.substr(0, 2) +"' OR EXTEND1 IS NULL) " +
                        " and not exists (select * from DEBT_T_ZQGL_BILL_XZHZ where AD_CODE='"+AD_CODE+"'"+
                        " and IS_FXJH = '"+is_fxjh+"' and BATCH_NO = GUID) " +
                        " and (EXTEND2 IS NULL OR EXTEND2 = '"+is_fxjh+"') "})*/
                        store:sbpc_store,
                        listeners: {
                            'change': function (self,newValue,oldValue,e) {
                                // 2020年06月30日 财政部下达抗疫国债 增加
                                if (is_fxjh == 1 && ( newValue == '98202002')) {
                                    /* 发行项目遴选申报时：如果选择的批次为 限额批次（982020001	直达市县基层限额批次）和 申报批次（98202002	新增财政赤字直达基层申报批次）
                                       则必须录入 新增赤字安排资金 和项目承建单位信息
                                     */
                                    var form = this.up('form').getForm();
                                    form.findField('XZCZAP_AMT').setReadOnly(false);
                                    form.findField('XZCZAP_AMT').allowBlank = false;
                                    form.findField('XZCZAP_AMT').setFieldStyle('background:#FFFFFF');
                                    var sbpc_type_id =  form.findField('BOND_TYPE_ID').value;
                                    if (sbpc_type_id != '01') {
                                        Ext.Msg.alert("提示","债券类型为专项债券类型时不能选择“98202002 新增财政赤字直达基层申报批次”！") ;
                                        self.setValue('');
                                        return;
                                        form.findField('XZCZAP_AMT').setFieldLabel('<span class="required">✶</span>其中：新增赤字安排资金');
                                        form.findField('XZCZAP_AMT').allowBlank = false;
                                    }
                                } else {
                                    var form = this.up('form').getForm();
                                    form.findField('XZCZAP_AMT').setFieldLabel('其中：新增赤字安排资金');
                                    form.findField('XZCZAP_AMT').setReadOnly(true);
                                    form.findField('XZCZAP_AMT').allowBlank = true;
                                    form.findField('XZCZAP_AMT').setFieldStyle('background:#E6E6E6');
                                }
                            }
                        }
                    },
                    {
                        xtype: "treecombobox",
                        name: "GNFL_ID",
                        store: zcgnfl_store,
                        displayField: "name",
                        valueField: "id",
                        selectModel: "leaf",
                        fieldLabel: '<span class="required">✶</span>支出功能分类',
                        editable: true, //禁用编辑
                        allowBlank: false,
                        listeners: {}
                    },
                    {
                        xtype: "treecombobox",
                        name: "JJFL_ID",
                        store: zcjjfl_store,
                        displayField: "name",
                        valueField: "id",
                        selectModel: "leaf",
                        fieldLabel: '<span class="required">✶</span>支出经济分类',
                        editable: true, //禁用编辑
                        allowBlank: false,
                        listeners: {}
                    }, {
                        fieldLabel: '<span class="required">✶</span>是否续发行',
                        name: 'IS_XFX',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        allowBlank: true,//20201127liyue
                        editable: false,
                        hidden: true,//(is_fxjh==1||is_fxjh==0)?false:true,
                        store: DebtEleStore(is_xfx_store)
                        /*                        listeners: {
                                                    change: function (self, newValue) {
                                                        var form = self.up('form').getForm();
                                                        if (newValue==1) {
                                                            form.findField('XFX_ZQ_ID').setReadOnly(false);
                                                            form.findField('XFX_ZQ_ID').setFieldStyle('background:#ffffff');
                                                            form.findField('XFX_XM_ID').setReadOnly(false);
                                                            form.findField('XFX_XM_ID').setFieldStyle('background:#ffffff');
                                                        } else {
                                                            form.findField('XFX_ZQ_ID').setValue('');
                                                            form.findField('XFX_ZQ_ID').setReadOnly(true);
                                                            form.findField('XFX_ZQ_ID').setFieldStyle('background:#E6E6E6');
                                                            form.findField('XFX_XM_ID').setValue('');
                                                            form.findField('XFX_XM_ID').setReadOnly(true);
                                                            form.findField('XFX_XM_ID').setFieldStyle('background:#E6E6E6');
                                                        }
                                                    }
                                                } */
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>是否调整',
                        name: 'IS_TZ',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        allowBlank: true,
                        editable: false,
                        hidden: true,
                        store: DebtEleStore(is_tz_json)
                    }, {
                        fieldLabel: '备注',
                        name: 'REMARK',
                        xtype: 'textfield',
                        columnWidth: (is_fxjh == '1') ? (is_fdq == 0 && (is_fxjh == '1') ? .999 : 0.666) : .999
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '申报记录',
                anchor: '100% -110',
                layout: 'fit',
                collapsible: false,
                items: [
                    initWindow_zqxxtb_contentForm_tab_bnsb_grid()
                ]
            }
        ]
    });
}

/**
 * 初始化债券信息填报弹出窗口中的申报记录标签页中的表格
 */
function initWindow_zqxxtb_contentForm_tab_bnsb_grid() {
    var headerJson = HEADERJSON;
    var grid = DSYGrid.createGrid({
        itemId: 'bnsbGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        data: [],
        features: [{
            ftype: 'summary'
        }],
        checkBox: false,
        border: false,
        height: '100%',
        pageConfig: {
            enablePage: false
        }
    });
    return grid;
}

// 回填数据
function setZqxmBcsbForm(action) {
    //获取本次申报页签表单
    var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
    //获取本次申报页签表单
    //往年已发行金额赋值
    if(isNull(action.result.data.bnsbForm)){
        //获取本次申报页签表单
        $.post("/findYfxAmt.action",{
            XM_ID:XM_ID
        },  function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                return;
            }else{
                bnsbForm.getForm().findField('YFX_AMT').setValue(data.list[0].YFX_AMT);
            }
        }, "json");
    }else{
        //获取本次申报页签表单
        $.post("/findYfxAmt.action",{
            XM_ID:XM_ID
        },  function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                return;
            }else{
                if(action.result.data.bnsbForm.YFX_AMT=='0') {
                    bnsbForm.getForm().findField('YFX_AMT').setValue(data.list[0].YFX_AMT);
                }else{
                    bnsbForm.getForm().setValues(action.result.data.bnsbForm);
                }
            }
        }, "json");
    }
    //加载本次申报页签表单
    bnsbForm.getForm().setValues(action.result.data.bnsbForm);

    //加载本次申报页签表格
    var bnsbStore = action.result.data.bnsbGrid;
    var bnsbGrid = DSYGrid.getGrid('bnsbGrid');
    bnsbGrid.getStore().removeAll();
    bnsbGrid.insertData(null, bnsbStore);
}

// 获取保存数据
function getSaveZqxmBcsbForm(is_fxjh, jbqkForm) {
    var jbqkForm = jbqkForm;
    //获取本次申报页签表单
    var message_error;
    var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];

    // console.log(Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().getValues())
    if (!bnsbForm.isValid()) {
        Ext.toast({
            html: bcsbTitle + "：请检查必填项是否填写完整！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400,
            listeners: {
                "show": function () {
                    var i = findTabName(bcsbTitle);
                    zqxxtbTab(i);
                }
            }
        });
        return false;
    }

    if (is_fxjh == 1) {
        var APPLY_AMOUNT1 = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("APPLY_AMOUNT1").getValue();
        var APPLY_NAME = bnsbForm.down('numberFieldFormat[name="APPLY_AMOUNT1"]').fieldLabel.replace("<span class=\"required\">✶</span>", "");
        var XZCZAP_AMT = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("XZCZAP_AMT").getValue();
        if (XZCZAP_AMT > APPLY_AMOUNT1) {
            Ext.Msg.alert("提示", "其中：新增赤字安排资金不能超过" + APPLY_NAME);
            return false;
        }
    }
    // 本次申报页签校验
    // if (bnsbForm.down('numberFieldFormat[name="APPLY_AMOUNT1"]').getValue() <= 0) {
    //     Ext.toast({
    //         html: bcsbTitle + "：请填写正确的申请金额！",
    //         closable: false,
    //         align: 't',
    //         slideInDuration: 400,
    //         minWidth: 400,
    //         listeners: {
    //             "show": function () {
    //                 var i = findTabName(bcsbTitle);
    //                 zqxxtbTab(i);
    //             }
    //         }
    //     });
    //     return false;
    // }
    if ((bnsbForm.down('treecombobox[name="BOND_TYPE_ID"]').getValue()).indexOf('02') == 0) {
        // var XMXZ_ID = jbqkForm.down('treecombobox[name="XMXZ_ID"]').getValue(); //项目性质
        // if (XMXZ_ID == '010101') {
        //     message_error = bcsbTitle+"：债券类型为专项债券时，项目性质不能为无自身收益的公益性项目！";
        //     Ext.Msg.alert('提示', message_error);
        //     zqxxtbTab(1);
        //     return false;
        // }

        if (bnsbForm.down('numberFieldFormat[name="XMZSSYCH_AMT"]').getValue() == null) {

            bnsbForm.down('numberFieldFormat[name="XMZSSYCH_AMT"]').setValue(0);
        } else if (bnsbForm.down('numberFieldFormat[name="XMZSSYCH_AMT"]').getValue() < 0) {
            message_error = bcsbTitle + "：项目自身收益偿还金额不能为负数！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(bcsbTitle);
            zqxxtbTab(i);
            return false;
        }
        var check_jjkm = bnsbForm.down('treecombobox[name="ZFXJJKM"]').getValue(); //基金科目
        var check_jjch = bnsbForm.down('numberFieldFormat[name="ZFXJJCH_AMT"]').getValue(); //基金偿还
        if (check_jjkm != null && check_jjkm != "" && (check_jjch == null || check_jjch == "" || check_jjch <= 0 || typeof (check_jjch) == 'undefined')) {
            message_error = bcsbTitle + "：政府性基金科目不为空时，政府性基金偿还金额应大于0！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(bcsbTitle);
            zqxxtbTab(i);
            return false;
        }
        if (check_jjch != null && check_jjch > 0 && (check_jjkm == null || check_jjkm == "" || typeof (check_jjkm) == 'undefined')) {
            message_error = bcsbTitle + "：政府性基金偿还金额大于0时，政府性基金科目不能为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName(bcsbTitle);
            zqxxtbTab(i);
            return false;
        }
    }

    var bondtype = bnsbForm.getForm().findField("BOND_TYPE_ID");
    var XMLX_ID_temp = jbqkForm.getForm().findField("XMLX_ID");
    var SBBATCH_NO = bnsbForm.getForm().findField('SBBATCH_NO').getValue();
    var XZCZAP_AMT = bnsbForm.getForm().findField('XZCZAP_AMT').getValue();
    var APPLY_AMOUNT_TOTAL = bnsbForm.getForm().findField('APPLY_AMOUNT_TOTAL').getValue();
    var APPLY_AMOUNT1 = bnsbForm.getForm().findField('APPLY_AMOUNT1').getValue();
    if (APPLY_AMOUNT1 <= 0) {
        message_error = bcsbTitle + "：申请金额必须大于0！";
        Ext.Msg.alert('提示', message_error);
        var i = findTabName(bcsbTitle);
        zqxxtbTab(i);
        return false;
    }
    if (!is_tdcb && APPLY_AMOUNT_TOTAL <= 0) {
        message_error = bcsbTitle + "：申请总金额必须大于0！";
        Ext.Msg.alert('提示', message_error);
        var i = findTabName(bcsbTitle);
        zqxxtbTab(i);
        return false;
    }
    if (is_fxjh == 1 && (SBBATCH_NO == '98202002') && XZCZAP_AMT <= 0) {
        message_error = bcsbTitle + "：申报批次为“98202002 新增财政赤字直达基层申报批次”时，其中：新增赤字安排资金必须大于0！";
        Ext.Msg.alert('提示', message_error);
        var i = findTabName(bcsbTitle);
        zqxxtbTab(i);
        return false;
    }
    if ((bondtype.getValue() == '020202' && XMLX_ID_temp.getValue().substring(0, 2) != '02')) {
        message_error = bcsbTitle + "：债券类型为收费公路专项债券时项目类型必须为公路下属的类型！";
        Ext.Msg.alert('提示', message_error);
        var i = findTabName(bcsbTitle);
        zqxxtbTab(i);
        return false;
    }
    if ((bondtype.getValue() == '020201' && XMLX_ID_temp.getValue() != '05')) {
        message_error = bcsbTitle + "：债券类型为土地储备专项债券时项目类型必须为土地储备！";
        Ext.Msg.alert('提示', message_error);
        var i = findTabName(bcsbTitle);
        zqxxtbTab(i);
        return false;
    }
    if ((bondtype.getValue() == '020203' && (XMLX_ID_temp.getValue().length < 4 || XMLX_ID_temp.getValue().substring(0, 4) != '0604'))) {
        message_error = bcsbTitle + "：债券类型为棚改专项债券时项目类型必须为棚户区改造！";
        Ext.Msg.alert('提示', message_error);
        var i = findTabName(bcsbTitle);
        zqxxtbTab(i);
        return false;
    }
    //辽宁专用
    if(sysAdcode=='21') {
        if (is_fxjh == '3') {
            if (DSYGrid.getGrid("sdgcGrid").getStore().getCount() <= 0) {
                message_error = is_show ? "十大工程：必须录入十大工程！" : "项目特征:必须录入项目特征";
                Ext.Msg.alert('提示', message_error);
                return false;
            }
        }
    }

    // var zbj_amt = bnsbForm.getForm().findField('ZBJ_AMT').getValue();
    // var apply_amount1 = bnsbForm.getForm().findField('APPLY_AMOUNT1').getValue();
    // if (zbj_amt - apply_amount1 > 0.0000001) {
    //     if (is_fxjh == 1) {
    //         Ext.Msg.alert("提示", "项目资本金不能大于发行金额！");
    //     } else {
    //         Ext.Msg.alert("提示", "项目资本金不能大于申请金额！");
    //     }
    //     return false;
    // }


    // var is_xmzbj = Ext.ComponentQuery.query('combobox[name="IS_XMZBJ"]')[0].value;
    // var ZBJ_AMT = Ext.ComponentQuery.query('numberFieldFormat[name="ZBJ_AMT"]')[0].value;

    // if (is_xmzbj == "1" && (ZBJ_AMT == null || ZBJ_AMT == 0)) {
    //     Ext.Msg.alert('提示', bcsbTitle+"页签的用于项目资本金未填写或为0!");
    //     zqxxtbTab(1);
    //     return false;
    // }

    return bnsbForm;
}

// 重新复制
function updateZjeSqje() {
    if (!is_tdcb) {
        // 修改 对应申请金额
        var yyqx_count = 5; // 默认显示5年编制计划列
        var applyMoney = [];
        var applyMoneyZBJ = [];
        var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
        var szysGrid = xmsyForm.down('grid');
        if(!!szysGrid){
            var xm_used_limit = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();  // 项目运营期限
            if (!!xm_used_limit) {
                yyqx_count = xm_used_limit;
            }
            if (xm_used_limit > 30) {
                yyqx_count = 30;
            }
            var record_0202 = szysGrid.getStore().getAt(gs_relation_guid["0202"]);// 获取地方政府专项债券金额
            var record_020201 = szysGrid.getStore().getAt(gs_relation_guid["020201"]);// 获取项目资本金
            if (!!record_0202) {
                for (var i = 0; i <= yyqx_count; i++) {
                    var SR = "SRAMT_Y" + i;
                    var ZC = "ZCAMT_Y" + i;
                    applyMoney.push(parseFloat(record_0202.get(SR) == "" ? 0 : record_0202.get(SR)));
                    applyMoneyZBJ.push(parseFloat(record_020201.get(SR) == "" ? 0 : record_020201.get(SR)));
                }
                setAPPLY_AMOUNT1(applyMoney, applyMoneyZBJ);//申请金额
            }
        }
    }
}

// TODO 项目承建企业

/**
 * 初始化债券信息填报弹出窗口中的项目承建企业标签页中的表格
 */
function initWindow_zqxxtb_contentForm_tab_xmcjqy_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            text: "项目承建企业ID", dataIndex: "XMCJQY_ID", type: "string", hidden: true
        },
        {
            text: "统一社会信用代码", dataIndex: "TYSHXY_CODE", type: "string", width: 160,
            editor: {xtype: 'textfield', allowBlank: false}
        },
        {
            text: "企业全称", dataIndex: "ENTERPRISE_NAME", type: "string", width: 300,
            editor: {xtype: 'textfield', allowBlank: false}
        },
        {
            text: "最终支付给企业的项目承建收入", dataIndex: "PAY_XMCJSR_AMT", type: "float", width: 250,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}
        },
        {
            text: "其中：解决就业人数", dataIndex: "QZ_SOLVE_EMPLOYMENT", type: "string", width: 180,
            editor: {xtype: 'numberfield', hideTrigger: true, minValue: 0}
        },
        {
            text: "其中：最终支付给个人的劳务收入", dataIndex: "QZ_PAY_GRLW_AMT", type: "float", width: 250,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'xmcjqyGrid',
        border: false,
        flex: 1,
        data: [],
        checkBox: true,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'tzjhCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'edit': function (editor, context) {
                        if (context.field == 'PAY_XMCJSR_AMT' || context.field == 'QZ_SOLVE_EMPLOYMENT' || context.field == 'QZ_PAY_GRLW_AMT') {
                            // if (context.record.get('QZ_SOLVE_EMPLOYMENT')+ context.record.get('QZ_PAY_GRLW_AMT') > context.record.get('PAY_XMCJSR_AMT')) {
                            //     Ext.MessageBox.alert('提示', '“最终支付给个人的劳务收入”与“解决就业人数”的和不能超过“最终支付给企业的项目承建收入”');
                            //     return false;
                            // }
                        }
                    }
                }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    //将增加删除按钮添加到表格中
    grid.addDocked({
        xtype: 'toolbar',
        layout: 'column',
        items: [
            '->',
            {
                xtype: 'button',
                itemId: 'xmcjqyAddBtn',
                text: '添加',
                width: 60,
                handler: function (btn) {
                    btn.up('grid').insertData(null, {'XMCJQY_ID': GUID.createGUID()});
                }
            },
            {
                xtype: 'button',
                itemId: 'xmcjqyDelBtn',
                text: '删除',
                width: 60,
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel().getSelection();
                    store.remove(sm);
                    if (store.getCount() > 0) {
                        grid.getSelectionModel().select(0);
                    }
                }
            }
        ]
    }, 0);
    grid.on('selectionchange', function (view, records) {
        grid.down('#xmcjqyDelBtn').setDisabled(!records.length);
    });
    return grid;
}

// 回填数据
function setZqxmXmcjqyForm(action) {

    // 加载“项目承建企业”页签表格

    var xmcjqyStore = action.result.data.xmcjqyGrid;
    var xmcjqyGrid = DSYGrid.getGrid('xmcjqyGrid');
    xmcjqyGrid.getStore().removeAll();
    xmcjqyGrid.insertData(null, xmcjqyStore);

}

// 获取保存数据
function getSaveZqxmXmcjqyForm(is_fxjh) {
    // 项目承建企业
    var cjqyGridStore = DSYGrid.getGrid("xmcjqyGrid").getStore();

    if (is_fxjh == 1 && (SBBATCH_NO == '98202002') && cjqyGridStore.getCount() <= 0) {
        var i = findTabName(xmcjqyTitle);
        zqxxtbTab(i);
        Ext.Msg.alert("提示", "申报批次为“98202002 新增财政赤字直达基层申报批次”时，必须录入" + xmcjqyTitle + "页签信息！");
        return false;
    }
    var xmcjqyGrid = [];
    cjqyGridStore.each(function (record) {
        xmcjqyGrid.push(record.getData());
    });
    return xmcjqyGrid;
}

// TODO 附件

/**
 * 初始化债券信息填报弹出窗口中的项目附件标签页
 */
function initWindow_zqxxtb_contentForm_tab_xmfj(config) {
    var ruleIds = config.ruleIds;
    var editSSFA = true;
    var grid = UploadPanel.createGrid({
        busiType: 'ET001',//业务类型
        ruleIds: "",//规则id，若存在，则优先用rule_id获取附件
        addHeaders: [{text: '上传时间', dataIndex: 'UPLOAD_TIME', type: 'string', index: 0},
            //20201217 fzd 附件增加“第三方单位名称”、“组织机构代码”、“备注”
            {text: '第三方单位名称', dataIndex: 'DSF_AG_NAME', width: 260, type: 'string', editor: 'textfield'},
            {text: '组织机构代码', dataIndex: 'DSF_ZZJG_CODE', type: 'string', editor: 'textfield'},
            {text: '备注', dataIndex: 'REMARK', type: 'string', editor: 'textfield'}
        ],
        busiId: window_zqxxtb.XM_ID,//业务ID
        editable: !window_zqxxtb.file_disabled,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_zqxxtb_contentForm_tab_xmfj_grid_xeksb'
        }
    });
    grid.columns[0].renderer = function (value, cell, record, rowIndex, colIndex, store, view) {
        //上传提示信息
        var tipText = '小于' + record.data.MAXLIMIT / 1024 + 'MB';
        var tip = record.data.FILE_SUFFIX + tipText;
        //上传按钮，上层覆盖透明上传表单
        var uploadbtn = '<div title="' + tip + '" class="uploadpanel-btn uploadpanel-btn-upload">' +
            '<form id="uploadpanel-' + view.grid.itemId + '-uploadform-' + rowIndex + '" class="uploadForm" enctype="multipart/form-data">' +
            '<input type="submit" />' +
            '<input type="text" name="rule_id" value=""/>' +
            '<input type="text" name="busi_id" value=""/>' +
            '<input type="text" name="maxlimit" value=""/>' +
            '<input type="file" name="upload" itemId="' + view.grid.itemId + '" rowIndex="' + rowIndex + '" onchange="UploadPanel.uploadFile(this)"/>' +
            '</form></div>';
        var downloadbtn = '<div class="uploadpanel-btn uploadpanel-btn-download" onclick="UploadPanel.downloadFile(\'' + record.get("FILE_ID") + '\')"></div>';
        var deletebtn = '<div class="uploadpanel-btn uploadpanel-btn-delete" onclick="UploadPanel.deleteFile(\'' + record.get("FILE_ID") + '\',\'' + record.get("RULE_ID") + '\',\'' + record.get("FILE_NAME") + '\',\'' + view.grid.itemId + '\',\'' + rowIndex + '\')"></div>';
        //根据是否可编辑，隐藏上传/删除按钮
        if (is_fxjh == '1') {
            //20201215 fzd 发行库放开‘dsfjgfj’录入
            if (/*(record.data.RULE_ID && record.data.BUSI_PROPERTY_DESC && (record.data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") != -1))
                ||*/ (!record.data.RULE_ID && record.data.UPLOAD_USER && userCode != record.data.UPLOAD_USER)) {
                uploadbtn = '';
                deletebtn = '';
            }
        } else {
            if (!store.editable) {
                uploadbtn = '';
                deletebtn = '';
            }
        }
        var preview = ''; // 预览按钮
        //如果文件存在，隐藏上传按钮
        var fileId = record.data.FILE_ID;
        if (typeof fileId != 'undefined' && fileId != null && fileId != '') {
            uploadbtn = ''; // 存在隐藏上传按钮
            var form = record.data.FILE_NAME.split(".")[record.data.FILE_NAME.split(".").length - 1];
            if (form == 'pdf' || form == 'docx' || form == "doc") {
                preview = '<div title="预览" class="uploadpanel-btn uploadpanel-btn-preview" onclick="pdfPreviewFile(\'' + fileId + '\',\'' + form + '\')"></div>';
            }
        } else { //根据文件id是否存在，隐藏下载按钮
            downloadbtn = ''; // 不存在，隐藏下载按钮
        }
        return '<div class="uploadpanel-btsn">' + uploadbtn + downloadbtn + deletebtn + preview + '</div>';
    };
    //附件加载完成后计算总文件数，并写到页签上
    grid.getStore().on('load', function (self, records, successful) {
        var sum = 0;
        if (records != null) {
            for (var i = 0; i < records.length; i++) {
                if (records[i].data.STATUS == '已上传') {
                    sum++;
                }
                if ((is_fxjh == '1')) {
                    /*//20201211_LIYUE 发行库添加 一案两书必录必录附件
                    //20201223 fzd 前台不做必录显示，无字段可用，后台校验并提示
                       if (records[i].data.BUSI_PROPERTY_DESC && (((records[i].data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") != -1 )
                               || records[i].data.BUSI_PROPERTY_DESC.indexOf("dwblfj") != -1 ))) {
                           records[i].set("NULLABLE", "N");
                       }*/
                    if (!!config.ruleIds) {
                        if (records[i].data.BUSI_PROPERTY_DESC && records[i].data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") != -1) {
                            if (records[i].data.FILE_ID) {
                                editSSFA = false;
                            }
                        }
                    }
                }
            }
        }
        if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}

// 申请总金额赋值
function setAPPLY_AMOUNT_TOTAL(value) {
    var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0]
    if (!!bnsbForm && !!bnsbForm.getForm().findField('APPLY_AMOUNT_TOTAL')) {
        var APPLY_AMOUNT_TOTAL = bnsbForm.getForm().findField('APPLY_AMOUNT_TOTAL');
        APPLY_AMOUNT_TOTAL.setValue(value);
    }
}

// 申请总金额赋值
function setAPPLY_AMOUNT1(applyMoney, applyMoneyZBJ) {
    var point = 0;
    var dif;//申请年度与开始日期的差值
    var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
    var sqnd = bnsbForm.getForm().findField('BILL_YEAR').getValue();//20211029liyue 控制收支预算页签中开始日期不能大于本次申报页签中申请年度
    var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
    var ksnd = xmsyForm.getForm().findField('XM_USED_DATE').getValue();//20211029liyue 收支预算开始日期
    ksnd = format(ksnd, 'yyyy');
    if (!!bnsbForm && !!bnsbForm.getForm().findField('BILL_YEAR') && !!bnsbForm.getForm().findField('APPLY_AMOUNT1')) {
        var APPLY_AMOUNT1 = bnsbForm.getForm().findField('APPLY_AMOUNT1');
        var ZBJ_AMT = bnsbForm.getForm().findField('ZBJ_AMT');
        if (ksnd > sqnd) {
            Ext.MessageBox.alert('提示', '开始日期不可大于本次申报页签中的申请年度！');
            if(!isNull(xmsyForm.getForm().findField('XM_USED_DATE'))){
                xmsyForm.getForm().findField('XM_USED_DATE').setValue('');
            }
            var i = findTabName(szysTitle);
            zqxxtbTab(i);
            return;
        }
        // for (var i = 0; i < getYears.length; i++) {
        //     if (sqnd == getYears[i].id) {
        //         point = i;
        //     }
        // }
        if (applyMoney.length > 0 && applyMoneyZBJ.length > 0) {
            if (ksnd == sqnd) {
                APPLY_AMOUNT1.setValue(applyMoney[0]); //申请金额赋值
                if (!!ZBJ_AMT && !!applyMoneyZBJ) {
                    ZBJ_AMT.setValue(applyMoneyZBJ[0]); //资本金赋值
                }
            }
            if (ksnd < sqnd) {
                dif = sqnd - ksnd;//比如开始日期2020 年申请年度为2022年
                point = point + dif;
                APPLY_AMOUNT1.setValue(applyMoney[point]); //申请金额赋值
                if (!!ZBJ_AMT && !!applyMoneyZBJ) {
                    ZBJ_AMT.setValue(applyMoneyZBJ[point]); //资本金赋值
                }
            }
        }

    }
}


/**
 * 添加建设项目内容填报模板
 */
function downloadJsxmnrTbsm() {
    window.location.href = 'downloadTemplate.action?file_name=' + encodeURI(encodeURI("建设项目内容填报模板.docx"));
}

/**
 * 项目调整穿透项目页面
 * 储备库和遴选项目申报和增部项目等
 */
function clickToMap() {
    var reachUrl = '/page/bda/cxyy/mapGisManager/mapGisManager.jsp';
    var paramNames = new Array();
    paramNames[0] = "DWBM";
    paramNames[1] = "MC";
    paramNames[2] = "RE";
    paramNames[3] = "canSaveData";
    paramNames[4] = "showTitle";
    var paramValues = new Array();
    paramValues[0] = window_zqxxtb.XM_ID;
    paramValues[1] = Ext.ComponentQuery.query('textfield[name="XM_NAME"]')[0].getValue().trim();//项目名称
    paramValues[2] = 'callInterFace';
    //20210818 fzd 初始化“标识”显示，0不显示 1 显示
    //参数不全导致申报时一户式未带出图标信息
    paramValues[3] = 0;
    paramValues[4] = 'GIS地图';
    //新增项目可修改地址，点击已有项目不可修改地址
    if (button_status == 'addXm' || button_status == 'update') {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        var firstBill;
        if (records.length != 0) {
            firstBill = records[0].get("FIRST_BILL");
        }

        if (firstBill == "1") {
            paramValues[3] = 1;//paramValues[3] 为是否显示标记，0 不显示 1 显示
        } else {
            //is_fxjh==1的时候不能修改项目地址：在遴选项目申报时，界面选中项目时不可修改项目地址，储备库可修改地址
            if (is_fxjh == 1) {
                paramValues[3] = 0;
            } else {
                paramValues[3] = 1;
            }
        }
    }
    post(reachUrl, paramNames, paramValues, '_blank');
}
function getstore(form) {
    var condition="";
    var XMXZ_ID= Ext.ComponentQuery.query('treecombobox[name="XMXZ_ID"]')[0].getValue();
    //var XMLX_ID = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0].getValue();
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
/**
 * @param
 * @author zhuangrx
 * @date 2021/11/13
 * @description 收支预算历史合计计算
 */
function  checkSzysHj(yyqx_count) {
    var a = new Map();
    var msg="";
    var is_success=true;
    var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
    var szysGrid = xmsyForm.down('grid');
    // 循环计算所有年度总收入总支出合计值
    for (var i = 0; i <= yyqx_count; i++) {
        var SR = "SRAMT_Y" + i;
        var ZC = "ZCAMT_Y" + i;
        //建设收入
        var sum_jssr=szysGrid.getStore().getAt(gs_relation_guid[jssr_key[0]]).get(SR);
        var jsssr_amt=0.0;
        for(var s=1;s<jssr_key.length;s++){
            jsssr_amt+=parseFloat(szysGrid.getStore().getAt(gs_relation_guid[jssr_key[s]]).get(SR));
        }
        if (Math.abs(((parseFloat(sum_jssr)).toFixed(6) - (parseFloat(jsssr_amt)).toFixed(6)))> 0.000001) {
            msg= '请检查建设资金来源的合计值！';
            is_success=false;
        }
        //建设支出
        var sum_jszc=szysGrid.getStore().getAt(gs_relation_guid[jszc_key[0]]).get(ZC);
        var jszc_amt=0.0;
        for(var m=1;m<jszc_key.length;m++){
            jszc_amt+=parseFloat(szysGrid.getStore().getAt(gs_relation_guid[jszc_key[m]]).get(ZC));
        }
        if (Math.abs((parseFloat(jszc_amt)).toFixed(6) - (parseFloat(sum_jszc)).toFixed(6)) > 0.000001) {
            msg= '请检查项目建设支出的合计值！';
            is_success=false;
        }
        //运营收入
        var sum_yysr=szysGrid.getStore().getAt(gs_relation_guid[yysr_key[0]]).get(SR);
        var yysr_amt=0.0;
        for(var n=1;n<yysr_key.length;n++){
            yysr_amt+=parseFloat(szysGrid.getStore().getAt(gs_relation_guid[yysr_key[n]]).get(SR));
        }
        if (Math.abs((parseFloat(yysr_amt)).toFixed(6) - (parseFloat(sum_yysr)).toFixed(6)) > 0.000001) {
            msg= '请检查项目运营收入的合计值！';
            is_success=false;
        }
        //运营支出
        var sum_yyzc=szysGrid.getStore().getAt(gs_relation_guid[yyzc_key[0]]).get(ZC);
        var yyzc_amt=0.0;
        for(var l=1;l<yyzc_key.length;l++){
            yyzc_amt+=parseFloat(szysGrid.getStore().getAt(gs_relation_guid[yyzc_key[l]]).get(ZC));
        }
        if (Math.abs( (parseFloat(yyzc_amt)).toFixed(6) - (parseFloat(sum_yyzc)).toFixed(6)) > 0.000001) {
            msg= '请检查项目运营支出的合计值！';
            is_success=false;
        }
    }
    a.put("is_success",is_success);
    a.put("msg",msg);
    return a;
}

