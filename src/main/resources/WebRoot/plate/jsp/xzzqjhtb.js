/**
 * js：新增债券填报
 */
var json_debt_isorno = [
    {id: "0", code: "0", name: "否"},
    {id: "1", code: "1", name: "是"}
];

var json_debt_zt2_3 = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"}
];
if (is_swsscfj == '1' && jg_type == '2') {
    var json_jg = [
        {id: "010", code: "010", name: "未评审"},
        {id: "011", code: "011", name: "已评审"}
    ];
}
var GxdzUrlParam = getQueryParam("GxdzUrlParam");
// 定义所属主管部门数据源20201121liyue
var zgbm_store = DebtEleTreeStoreDBTable("DSY_V_ELE_AG_ZGBM");
var newValue = 1;
bond_type_id = null;
var is_xz = false;
var is_zb = false;
var km_condition = (is_fxjh == 0 || is_fxjh == 2 || is_fxjh == 3) ? SET_YEAR + 1 <= 2017 ? " <= '2017' " : " = '" + (1 + SET_YEAR) + "' " :
    SET_YEAR <= 2017 ? " <= '2017' " : " = '" + (SET_YEAR) + "' ";
var zwsrkm_store = DebtEleTreeStoreDB('DEBT_ZWSRKM', {condition: " and (code like '1050402%' or code like '1101102%') and year " + km_condition});
var zcgnfl_store = DebtEleTreeStoreDB('EXPFUNC', {condition: "and year " + km_condition});
var zcjjfl_store = DebtEleTreeStoreDB('EXPECO', {condition: "and year " + km_condition});
var z_condition = ' and 1=1 ';
var zjtxly_store = DebtEleTreeStoreDB("DEBT_ZJTXLY");//20201126李月资金投向领域
var zwxmlx_store = DebtEleTreeStoreDB("DEBT_ZWXMLX", {condition: z_condition});
// var xmxz_store=DebtEleTreeStoreDB("DEBT_ZJYT",{condition:is_zxzqxt=='1'&&is_zxzq=='1'?" and code !='010101' ":" "});
var xmxz_store = DebtEleTreeStoreDB("DEBT_ZJYT", {condition: " and 1=1 and code!='0102' "});
var zqlx_store = is_zxzq == '1' ? DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '02%' "})
    : is_zxzq == '2' ? DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '01%' "})
        : DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' "});

//全局变量  在专项债券系统下的限额库使用
var LSSWS_ID_VALUE;
var KJSWS_ID_VALUE;
//专项债券系统，当前年申请金额（修改前）
var APPLY_AMOUNT1_OLD = 0;
var KZSArray;//所有区划的控制数数组
var ruleIds_edit = [];

var first = 0;//第一次录数据还是已有项目数据用于修改校验，修改时已有项目部分置灰,新增不置灰，不置灰的情况下要考虑资金投向与项目性质联动
/*基准利率类型*/
var is_xfx_store = [
    {id: "0", name: "否"},
    {id: "1", name: "是"}
];
//专项债券，需求申报是否调整
var is_tz_json = [
    {id: '0', code: '0', name: '否'},
    {id: '1', code: '1', name: '是'}
];
var s_is_xmzbj = [
    {id: '0', code: '0', name: '否'},
    {id: '1', code: '1', name: '是'}
];
var s_is_sb = [
    {id: '0', code: '0', name: '未申报'},
    {id: '1', code: '1', name: '已申报'}
];
var is_xmzbj;
var monthStore = DebtEleStore(json_debt_yf);
//if(is_swsscfj=='1' && is_zxzqxt=='1' && (is_fxjh=='1'||is_fxjh=='3')){
if (is_swsscfj == '1' && jg_type != '2') {
    var bfUploadPanel = UploadPanel.uploadFile;
    UploadPanel.uploadFile = function (file) {
        Ext.Msg.confirm('提示', '确认已和最新实施方案进行对比！', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                bfUploadPanel(file);
            } else {
                var uploads = document.getElementsByName("upload");
                for (var p = 0; p < uploads.length; p++) {
                    uploads[p].value = "";
                }
            }
        });
    };
    $.post('getFjRuleIdsByDsfjg.action', {}, function (data) {
        //加载获取的数据
        if (data.success) {//加载成功
            ruleIds_edit = data.list;//传递一个array对象
        }
    }, "json");
}


/**
 * 默认数据：工具栏
 */
$.extend(zqxm_json_common, {
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '新增项目',
                name: 'addXm',
                //20210923 zhuangrx 兼容储备新增一般项目
                hidden: (is_fxjh == '0' && (is_zxzq == '2' || is_zxzq == '')) || (is_fxjh == '3') ? false : true,//20210527liyue新增债券需求申报不展示新增项目按钮，专项项目储备申报显示新增按钮
                // hidden: is_fxjh=='3' || is_zxzq==''|| (is_fxjh=='0'&& is_zxzq=='2')?false:true,
                icon: '/image/sysbutton/projectnew.png',
                handler: function (btn) {

                    is_zb = false;
                    button_status = btn.name;
                    button_name = btn.text;
                    //获取左侧选择树，初始化全局变量
                    var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                    var selected_ad = treeArray[0].getSelection()[0];
                    var selected_ag = treeArray[1].getSelection()[0];
                    if (!selected_ad && !selected_ag) {
                        Ext.Msg.alert('提示', "请选择区划和单位");
                        return;
                    } else if (!selected_ad || !selected_ad.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级区划再进行操作！");
                        return;
                    } else if (!selected_ag || !selected_ag.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级单位再进行操作！");
                        return;
                    }
                    if (is_fxjh == '3') {
                        BATCH_YEAR = parseInt(SET_YEAR + 1);
                    }
                    //20210425李月储备库后加新增按钮加载窗口时重新加载资金投向领域
                    zjtxly_store = DebtEleTreeStoreDB("DEBT_ZJTXLY");
                    zwxmlx_store.load();
                    AD_CODE = treeArray[0].getSelection()[0].get('code');
                    AD_NAME = treeArray[0].getSelection()[0].get('text');
                    AG_CODE = treeArray[1].getSelection()[0].get('code');
                    AG_ID = treeArray[1].getSelection()[0].get('id');
                    AG_NAME = treeArray[1].getSelection()[0].get('text');
                    if (SYS_JOINXQK == '1' && ELE_AD_CODE != '34' && IS_YBZQXT == '1') {
                        if (is_fxjh == '3') {
                            zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '02%' "});
                        } else if (is_fxjh == '0') {
                            zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '01%' "});
                        }
                    }

                    //发送ajax请求，获取新增主表id
                    $.post("/getId.action", function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //20210308_zhuangrx_因为data[0]导致传回去的key发生了改变储备库保存数据异常处理
                        window_zqxxtb.XM_ID = data.data[0];

                        $.post("/getAgtyshcode.action", {
                            AG_ID: AG_ID
                        }, function (data) {
                            if (!data.success) {
                                Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                return;
                            }
                            //统一社会信用代码
                            var USCCODE = data.data[0].TYSHXYDM;
                            //弹出弹出框，设置XM_ID
                            is_fxjh == '1' && sysAdcode == '13' ? window_zqxxtb.file_disabled = true : window_zqxxtb.file_disabled = false;
                            window_zqxxtb.show();//20210303liyue建设单位统一信用代码
                            var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
                            jbqkForm.getForm().findField('JSDW_TYSHXY').setValue(USCCODE);
                            jbqkForm.getForm().findField('YYDW_TYSHXY').setValue(USCCODE);
                            //初审表带出区划单位
                            var csqkForm = Ext.ComponentQuery.query('form[name="csqkForm"]')[0];
                            csqkForm.getForm().findField('AD_CODE').setValue(AD_CODE);
                            csqkForm.getForm().findField('AD_NAME').setValue(AD_NAME);
                            csqkForm.getForm().findField('AG_CODE').setValue(AG_CODE);
                            csqkForm.getForm().findField('AG_NAME').setValue(AG_NAME);
                            zqxxtbTab(0);
                        }, "json");

                    }, "json");
                }
            },
            {
                xtype: 'button',
                text: '遴选项目',
                name: 'add',
                hidden: is_fxjh != 1 && is_fxjh != 4,
                icon: '/image/sysbutton/projectexisting.png',
                handler: function (btn) {
                    is_zb = false;
                    button_status = btn.name;
                    button_name = btn.text;
                    //获取左侧选择树，初始化全局变量
                    var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                    var selected_ad = treeArray[0].getSelection()[0];
                    var selected_ag = treeArray[1].getSelection()[0];
                    if (!selected_ad && !selected_ag) {
                        Ext.Msg.alert('提示', "请选择区划和单位");
                        return;
                    } else if (!selected_ad || !selected_ad.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级区划再进行操作！");
                        return;
                    } else if (!selected_ag || !selected_ag.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级单位再进行操作！");
                        return;
                    }
                    zqlx_store = is_zxzq == '1' ? DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '02%' "})
                        : is_zxzq == '2' ? DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '01%' "})
                            : DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' "});
                    is_fxjh == '1' && sysAdcode == '13' ? window_zqxxtb.file_disabled = true : window_zqxxtb.file_disabled = false;
                    AD_CODE = treeArray[0].getSelection()[0].get('code');
                    AD_NAME = treeArray[0].getSelection()[0].get('text');
                    AG_CODE = treeArray[1].getSelection()[0].get('code');
                    AG_NAME = treeArray[1].getSelection()[0].get('text');
                    //getKmJcsj(SET_YEAR,true);
                    $.post("/getAgtyshcode.action", {
                        AG_ID: AG_ID
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //统一社会信用代码
                        USCCODE = data.data[0].TYSHXYDM;
                    }, "json");
                    initWindow_yyxmtb();

                }
            },
            {
                xtype: 'button',
                text: (is_fxjh == 1 || is_fxjh == 4) ? '增补项目' : '已有项目',
                name: 'add',
                hidden: (is_fxjh == 1 || is_fxjh == 4) && IS_SHOW_ZBXM == 0,
                icon: '/image/sysbutton/projectexisting.png',
                handler: function (btn) {
                    is_xz = false;
                    is_zb = (is_fxjh == 1 || is_fxjh == 4);
                    button_status = btn.name;
                    button_name = btn.text;
                    //获取左侧选择树，初始化全局变量
                    var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                    var selected_ad = treeArray[0].getSelection()[0];
                    var selected_ag = treeArray[1].getSelection()[0];
                    if (!selected_ad && !selected_ag) {
                        Ext.Msg.alert('提示', "请选择区划和单位");
                        return;
                    } else if (!selected_ad || !selected_ad.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级区划再进行操作！");
                        return;
                    } else if (!selected_ag || !selected_ag.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级单位再进行操作！");
                        return;
                    }
                    if (is_fxjh == '3') {
                        if (ELE_AD_CODE != '34') {
                            if (IS_YBZQXT != '1') {
                                zqlx_store = is_zxzq == '1' ? DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '02%' "})
                                    : is_zxzq == '2' ? DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '01%' "})
                                        : DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' "});
                                is_fxjh == '1' && sysAdcode == '13' ? window_zqxxtb.file_disabled = true : window_zqxxtb.file_disabled = false;
                            } else {
                                zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '02%' "});
                            }
                        }
                    } else {
                        zqlx_store = is_zxzq == '1' ? DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '02%' "})
                            : is_zxzq == '2' ? DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '01%' "})
                                : DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' "});
                        is_fxjh == '1' && sysAdcode == '13' ? window_zqxxtb.file_disabled = true : window_zqxxtb.file_disabled = false;
                    }


                    AD_CODE = treeArray[0].getSelection()[0].get('code');
                    AD_NAME = treeArray[0].getSelection()[0].get('text');
                    AG_CODE = treeArray[1].getSelection()[0].get('code');
                    AG_NAME = treeArray[1].getSelection()[0].get('text');
                    $.post("/getAgtyshcode.action", {
                        AG_ID: AG_ID
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        //统一社会信用代码
                        USCCODE = data.data[0].TYSHXYDM;
                    }, "json");
                    initWindow_yyxmtb();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    button_status = btn.name;
                    button_name = btn.text;
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
                        btn.setDisabled(false);
                        return;
                    }
                    // 获取AG_ID,指标库挑选时使用
                    AG_ID = records[0].get("AG_ID");
                    first = records[0].get("FIRST_BILL");
                    //20210705 zhuangrx 储备选项目时兼容债券类型为专项
                    //SYS_JOINXQK 1需求纳入流程 0需求不纳入流程
                    //is_fxjh 0需求库，1发行 3储备
                    //first 0已有项目里带出来得项目 1 新增项目录入的项目
                    //20210924 zhuangrx 兼容储备一般
                    if (SYS_JOINXQK == '1' && ELE_AD_CODE != '34' && IS_YBZQXT == '1') {
                        if (is_fxjh == '3' && first == '1') {
                            if (first == '1') {
                                zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '02%' "});
                            } else {
                                zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' "});
                            }
                        } else if (is_fxjh == '0') {
                            if (first == '1') {
                                zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '01%' "});
                            } else {
                                zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%'   "});
                            }
                        }
                    }
                    // 20201211 guoyf (需求库)未送审增加是否可修改较验
                    if (sysAdcode == AD_CODE || sysAdcode.concat("00") == AD_CODE) {

                    } else {
                        if (is_fxjh == '0') {
                            var zt = records[0].get('SBZT');
                            if ('1' == zt) {
                                Ext.toast({
                                    html: '所选中数据已审核通过禁止修改!',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                btn.setDisabled(false);
                                return;
                            }
                        }
                    }
                    //获取限额库申报批次所需的参数
                    if (is_fxjh == '1' || is_fxjh == '4') {//限额库
                        BATCH_BOND_TYPE_ID = (records[0].get('BOND_TYPE_ID'));
                        BATCH_YEAR = parseInt(records[0].get('BILL_YEAR'));
                    } else if (is_fxjh == '3') {
                        BATCH_BOND_TYPE_ID = (records[0].get('BOND_TYPE_ID'));
                        BATCH_YEAR = parseInt(SET_YEAR + 1);
                    }
                    //专项债券系统下，修改前保存原有当前年申请金额，做控制数校验用
                    if (is_zxzqxt == '1' && is_zxzq != '2' && is_fxjh == '3' && SYS_ZXZQXT_KZS_CHECK == '1') {
                        APPLY_AMOUNT1_OLD = records[0].get('APPLY_AMOUNT1')
                    }
                    //判断需求项目是否被使用，如果使用则不可以修改实施方案
                    /*if(is_zxzqxt=='1' && is_zxzq == '1' && is_fxjh == '0'){
                        window_zqxxtb.is_used = records[0].get("IS_USED");
                    }else{
                        window_zqxxtb.is_used = 0;
                    }*/
                    window_zqxxtb.XM_ID = records[0].get("XM_ID");
                    is_fxjh == '1' && sysAdcode == '13' ? window_zqxxtb.file_disabled = true : window_zqxxtb.file_disabled = false;
                    window_zqxxtb.JH_ID = records[0].get("ID");
                    getKmJcsj(records[0].get("BILL_YEAR"), true);
                    window_zqxxtb.show();
                    loadXzzq();
                    btn.setDisabled(false);
                    /*zwsrkm_store.load({
                    	callback : function() {
                    		zcgnfl_store.load({
                    			callback : function() {
                    				zcjjfl_store.load({
                    					callback : function() {
                                            window_zqxxtb.show();
                                            loadXzzq();
                                            btn.setDisabled(false);
                    					}
                    				});
                    			}
                    		});
                    	}
                    });*/
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.text;
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            deleteXzzq();
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    //送审
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            fileuploadbutton(),
            fileuploadbutton1(),
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '002': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销',
                itemId: 'cancel',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                //hidden:sysAdcode=='12'&&is_fxjh=='3'?true:false,
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '004': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    button_status = btn.name;
                    button_name = btn.text;
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
                        btn.setDisabled(false);
                        return;
                    }
                    first = records[0].get("FIRST_BILL");//20210429liyue区分新增项目修改还是已有项目
                    //20210705 zhuangrx 储备选项目时兼容债券类型为专项
                    //SYS_JOINXQK 1需求纳入流程 0需求不纳入流程
                    //is_fxjh 0需求库，1发行 3储备
                    //first 0已有项目里带出来得项目 1 新增项目录入的项目
                    //20210924 zhuangrx 兼容储备一般
                    if (SYS_JOINXQK == '1' && ELE_AD_CODE != '34' && IS_YBZQXT == '1') {
                        if (is_fxjh == '3' && first == '1') {
                            if (first == '1') {
                                zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '02%' "});
                            } else {
                                zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' "});
                            }
                        } else if (is_fxjh == '0') {
                            if (first == '1') {
                                zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '01%' "});
                            } else {
                                zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%'   "});
                            }
                        }
                    }
                    // 20201211 guoyf (需求库)未送审增加是否可修改较验
                    if (sysAdcode == AD_CODE || sysAdcode.concat("00") == AD_CODE) {

                    } else {
                        if (is_fxjh == '0') {
                            var zt = records[0].get('SBZT');
                            if ('1' == zt) {
                                Ext.toast({
                                    html: '所选中数据已审核通过禁止修改!',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                btn.setDisabled(false);
                                return;
                            }
                        }
                    }
                    //获取限额库申报批次所需的参数
                    if (is_fxjh == '1' || is_fxjh == '4') {//限额库
                        BATCH_BOND_TYPE_ID = (records[0].get('BOND_TYPE_ID'));
                        BATCH_YEAR = parseInt(records[0].get('BILL_YEAR'));
                        getKmJcsj(BATCH_YEAR, true);
                    } else if (is_fxjh == '3') {
                        //BATCH_YEAR = parseInt(SET_YEAR+1);
                        BATCH_BOND_TYPE_ID = (records[0].get('BOND_TYPE_ID'));
                        BATCH_YEAR = parseInt(records[0].get('BILL_YEAR'));
                        getKmJcsj(BATCH_YEAR, true);
                    }
                    //专项债券系统下，修改前保存原有当前年申请金额，做控制数校验用
                    if (is_zxzqxt == '1' && is_zxzq != '2' && is_fxjh == '3' && SYS_ZXZQXT_KZS_CHECK == '1') {
                        APPLY_AMOUNT1_OLD = records[0].get('APPLY_AMOUNT1')
                    }
                    /* //判断需求项目是否被使用，如果使用则不可以修改实施方案
                     if(is_zxzqxt=='1' && is_zxzq == '1' && is_fxjh == '0'){
                         window_zqxxtb.is_used = records[0].get("IS_USED");
                     }else{
                         window_zqxxtb.is_used = 0;
                     }*/
                    window_zqxxtb.XM_ID = records[0].get("XM_ID");
                    is_fxjh == '1' && sysAdcode == '13' ? window_zqxxtb.file_disabled = true : window_zqxxtb.file_disabled = false;
                    window_zqxxtb.JH_ID = records[0].get("ID");
                    getKmJcsj(records[0].get("BILL_YEAR"), true);
                    window_zqxxtb.show();
                    loadXzzq();
                    btn.setDisabled(false);
                    /*zwsrkm_store.load({
                    	callback : function() {
                    		zcgnfl_store.load({
                    			callback : function() {
                    				zcjjfl_store.load({
                    					callback : function() {
                    						window_zqxxtb.show();
                    	                    loadXzzq();
                                            btn.setDisabled(false);
                    					}
                    				});
                    			}
                    		});
                    	}
                    });*/
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                // hidden:is_fxjh=='5'?true:false,//湖北初审隐藏被退回
                handler: function () {
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
                        return;
                    }
                    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                        if (btn_confirm == 'yes') {
                            deleteXzzq();
                        }
                    });
                }
            },
            {
                xtype: 'button',
                text: '送审',
                itemId: 'down',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '008': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '010': [{
            xtype: 'button',
            text: '查询',
            icon: '/image/sysbutton/search.png',
            handler: function () {
                reloadGrid();
            }
        }, {
            xtype: 'button',
            text: '上传文件',
            itemId: 'scwj',
            name: 'scwj',
            icon: '/image/sysbutton/upload.png',
            handler: function (btn) {

                var records = DSYGrid.getGrid('contentGrid').getSelection();
                if (records.length != 1) {
                    Ext.MessageBox.alert('提示', '请选择一条数据进行操作');
                    return false;
                }
                var bill_id = records[0].get("ID");
                var zqlx_id = records[0].get("BOND_TYPE_ID");
                var xm_id = records[0].get("XM_ID");
                initWin_xmInfo_cp_scfj(xm_id, bill_id);
                var zqxxYHSTab = Ext.ComponentQuery.query('panel[itemId="xmxxTab"]')[0];

                $.post('getFjRuleIdsByZqlx.action', {ZQLX_ID: zqlx_id}, function (data) {
                    //加载获取的数据
                    var ruleIds;
                    if (data.success) {//加载成功
                        ruleIds = data.list;//传递一个array对象
                    } else {
                        Ext.Msg.alert('提示', '附件信息加载失败！' + data.message);
                        ruleIds = [];
                    }
                    var tab = zqxxYHSTab.add({
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        scrollable: true,
                        layout: 'fit',
                        items: [
                            {
                                xtype: 'panel',
                                itemId: 'zqDsfPanel',
                                layout: 'fit',
                                border: false,
                                items: initWindow_zqxxtb_contentForm_tab_xmfj({ruleIds: ruleIds, xm_id: xm_id})
                            }
                        ]
                    });
                    zqxxYHSTab.setActiveTab(tab);
                }, "json");
            }
        },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()],
        '011': [{
            xtype: 'button',
            text: '查询',
            icon: '/image/sysbutton/search.png',
            handler: function () {
                reloadGrid();
            }
        }, {
            xtype: 'button',
            text: '撤销评审',
            itemId: 'cancel',
            name: 'cancel',
            hidden: sysAdcode == '42' ? false : true,
            icon: '/image/sysbutton/cancel.png',
            handler: function (btn) {
                backpszt(btn);
            }
        }, {
            xtype: 'button',
            text: '操作记录',
            name: 'btn_log',
            icon: '/image/sysbutton/log.png',
            handler: function () {
                operationRecord();
            }
        },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()]

    },
    items_content_rightPanel_items: function () {
        if (SYS_XZZQJH_XE_CHECK && SYS_XZZQJH_XE_CHECK !== '0' && is_fxjh == '1') {
            return [
                {
                    xtype: 'panel',
                    layout: 'vbox',
                    width: '100%',
                    height: '100%',
                    flex: 1,
                    items: [
                        initContentXeGrid(),
                        initContentGrid()
                    ]
                }
            ]
        } else {
            return [
                {
                    xtype: 'panel',
                    layout: 'vbox',
                    width: '100%',
                    height: '100%',
                    flex: 1,
                    items: [
                        initContentGrid()
                    ]
                }
            ]
        }
    },
    item_content_grid_config: {
        border: true,
        // anchor: '100% -75',
        flex: 1,
        width: '100%',
        dataUrl: is_scfjgn ? '/getScjfGrid.action' : '/getXzzqContentGrid.action',
        autoLoad: is_scfjgn ? true : false,
        params: {
            is_fxjh: is_fxjh,
            // bond_type_id: bond_type_id,
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            WF_STATUS: is_scfjgn == false ? WF_STATUS : jg_type == '2' ? '010' : '001',
            IS_ZXZQXT: is_zxzqxt,
            IS_ZXZQ: is_zxzq,
            node_type: node_type,
            menucode: menucode,
            HAVE_SFJG: HAVE_SFJG,
            USER_ID: USER_ID
        },
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: jg_type == 2 ? DebtEleStore(json_jg) : DebtEleStore(json_zt),
                width: 110,
                labelWidth: 30,
                editable: false,
                labelAlign: 'right',
                displayField: "name",
                valueField: "id",
                value: WF_STATUS,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(zqxm_json_common.items[WF_STATUS]);
                        //刷新当前表格
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
                    }
                }
            },
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                id: 'mhcx_xm',
                name: 'contentGrid_search',
                width: 300,
                labelWidth: 60,
                labelAlign: 'right',
                emptyText: '请输入项目名称...',
                enableKeyEvents: true,
                hidden: jg_type == 2 ? false : true,
                listeners: {
                    'change': function (self, value) {
                        var mhcx_xm = Ext.ComponentQuery.query('textfield#mhcx_xm')[0].getValue();  //模糊查询
                        DSYGrid.getGrid('contentGrid').getStore().getProxy().extraParams["MHCX"] = mhcx_xm;

                    }
                }
            }
        ]
    },
    reloadGrid: function () {
        var grid = DSYGrid.getGrid('contentGrid');
        if (grid) {
            var store = grid.getStore();
            //增加查询参数
            store.getProxy().extraParams["AD_CODE"] = AD_CODE;
            store.getProxy().extraParams["AG_CODE"] = AG_CODE;
            store.getProxy().extraParams["bond_type_id"] = bond_type_id;
            if (SYS_XZZQJH_XE_CHECK && SYS_XZZQJH_XE_CHECK !== '0' && is_fxjh == '1') {
                //刷新限额表格,置为空
                var store_details = DSYGrid.getGrid('contentXEGrid').getStore();
                //如果传递参数不为空，就刷新明细表格
                store_details.getProxy().extraParams["AD_CODE"] = AD_CODE;
                store_details.getProxy().extraParams["SET_YEAR"] = SET_YEAR;
                store_details.load();
                store.getProxy().extraParams["SET_YEAR"] = SET_YEAR;
            } else {
                store.getProxy().extraParams["SET_YEAR"] = null;
            }
            if (typeof param != 'undefined' && param != null) {
                for (var i in param) {
                    store.getProxy().extraParams[i] = param[i];
                }
            }
            store.loadPage(1);
        }
    }
});

function fileuploadbutton1() {
    return {
        xtype: 'form',
        hidden: IS_SHOW_SPEC_UPLOAD_BTN == '0' ? true : false,
        itemId: 'form_upload_id1',
        name: 'form_upload_name1',
        //fileUpload: true,
        enctype: 'multipart/form-data;charset=UTF-8',
        border: false,
        width: 100,
        baseCls: 'my-panel-no-border',
        items: [
            {
                xtype: 'filefield',
                buttonText: '<span style="color: black">导入已有项目</span>',
                itemId: "uploady1",
                name: 'upload',
                buttonOnly: true,
                width: 100,
                padding: '0 0 0 0',
                margin: '0 0 0 0',
                hideLabel: true,
                buttonConfig: {
                    icon: '/image/sysbutton/projectnew.png',
                    style: {
                        "border-color": '#D8D8D8',
                        background: '#f6f6f6'
                    }
                },
                listeners: {
                    change: function (fb, v) {
                        var form = this.up('form');
                        upload_xzzm(form, 'yy', "uploady1");
                        reloadGrid();
                    }
                }
            }
        ]
    };
}


function fileuploadbutton() {
    return {
        xtype: 'form',
        hidden: IS_SHOW_SPEC_UPLOAD_BTN == '0' ? true : false,
        itemId: 'form_upload_id',
        name: 'form_upload_name',
        //fileUpload: true,
        enctype: 'multipart/form-data;charset=UTF-8',
        border: false,
        width: 100,
        baseCls: 'my-panel-no-border',
        margin: '0 15 0 0',
        items: [
            {
                xtype: 'filefield',
                buttonText: '<span style="color: black">导入新增项目</span>',
                itemId: "uploady",
                name: 'upload',
                buttonOnly: true,
                width: 100,
                padding: '0 0 0 0',
                margin: '0 0 0 0',
                hideLabel: true,
                buttonConfig: {
                    icon: '/image/sysbutton/projectnew.png',
                    style: {
                        "border-color": '#D8D8D8',
                        background: '#f6f6f6'
                    }
                },
                listeners: {
                    change: function (fb, v) {
                        var form = this.up('form');
                        upload_xzzm(form, 'xz', 'uploady');
                        reloadGrid();
                    }
                }
            }
        ]
    };
}

function upload_xzzm(form2, io_type, button_id) {
    //AG_CODE=Ext.ComponentQuery.query('panel#treePanel_left')[0].query('treepanel')[1].getSelection()[0].get('code');
    var form = form2.getForm();
    var dataUrl = form.findField('upload').getValue();
    var arr = dataUrl.split('.');
    var fileType = arr[arr.length - 1].toLowerCase();
    if (fileType != 'rar' && fileType != 'zip') {
        Ext.MessageBox.alert('提示', '文件格式不正确！');
        form2.remove(button_id, true);
        if (io_type == 'xz') {
            form2.add(fileuploadbutton());
        } else if (io_type == 'yy') {
            form2.add(fileuploadbutton1());
        }

        return;
    }
    form.submit({
        clientValidation: false,
        url: '/import_file.action',
        waitTitle: '请等待',
        waitMsg: '正在导入中...',
        params: {
            wf_id: wf_id,
            node_code: node_code,
            button_status: button_status,
            button_name: button_name,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AD_NAME: userName_jbr,
            AG_ID: AG_ID,
            AG_NAME: AG_NAME,
            BOND_TYPE_ID: bond_type_id,
            IS_FXJH: is_fxjh,
            io_type: io_type
        },
        success: function (form, action) {
            Ext.MessageBox.show({
                title: '提示',
                msg: '导入成功',
                maxWidth: 400,
                minWidth: 200,
                buttons: Ext.Msg.OK,
                fn: function (btn) {
                }
            });
            reloadGrid();
        },
        failure: function (form, action) {
            Ext.MessageBox.show({
                title: '提示',
                msg: '导入失败！<br>' + (action.result.message ? action.result.message : ''),
                maxWidth: 550,
                minWidth: 200,
                buttons: Ext.Msg.OK,
                fn: function (btn) {
                }
            });
            reloadGrid();
        }

    });
    reloadGrid();

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
    compareActualDateText: '实际开工日期应该早于实际竣工日期'
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

/**
 * 比较实际竣工日期与当前时间
 * @param form
 * @return {boolean}
 */
function compareNowDateActualDate(form) {
    var END_DATE_ACTUAL = form.down('[name=END_DATE_ACTUAL]').getValue();
    END_DATE_ACTUAL = Ext.util.Format.date(END_DATE_ACTUAL, 'Y-m-d');
    if (END_DATE_ACTUAL && END_DATE_ACTUAL > nowDate) {
        return false;
    }
    return true;
}

/**
 * 当已完工或已竣工时，开工及竣工时间不能为空校验
 * @param form
 * @return {boolean}
 */
function compareBuildActualDate(form) {
    var START_DATE_ACTUAL = form.down('[name=START_DATE_ACTUAL]').getValue();
    var END_DATE_ACTUAL = form.down('[name=END_DATE_ACTUAL]').getValue();
    var BUILD_STATUS_ID = form.down('[name=BUILD_STATUS_ID]').getValue();
    if ((BUILD_STATUS_ID == '03' || BUILD_STATUS_ID == '04') &&
        (START_DATE_ACTUAL == null || START_DATE_ACTUAL == '' || END_DATE_ACTUAL == null || END_DATE_ACTUAL == '')) {
        return false;
    }
    return true;
}

//创建债券信息填报弹出窗口
var window_zqxxtb = {
    window: null,
    show: function () {
        this.window = initWindow_zqxxtb();
        this.window.show();
        is_fxjh == '5' ? zqxxtbTab(0) : zqxxtbTab(2);
    }
};

/**
 * 初始化债券信息填报弹出窗口
 */
function initWindow_zqxxtb() {
    return Ext.create('Ext.window.Window', {
        itemId: 'window_zqxxtb', // 窗口标识
        name: 'xzzqWin',
        title: '项目申报信息填报', // 窗口标题
        width: document.body.clientWidth * 1, //自适应窗口宽度20210819兼容绩效目标页签
        height: document.body.clientHeight * 1, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: initWindow_zqxxtb_contentForm(),
        buttons: [
            {
                xtype: 'button',
                itemId: 'mbxz',
                text: '模板下载',
                hidden: true,
                handler: function (btn) {
                    szysExcelDown();//收支平衡表格模板下载
                }
            }
            , {
                xtype: 'button',
                text: '导入',
                itemId: "import",
                name: 'upload',
                fileUpload: true,
                hidden: true,
                buttonOnly: true,
                hideLabel: true,
                buttonConfig: {
                    width: 140,
                    icon: '/image/sysbutton/report.png'
                },
                handler: function (btn) {
                    var xmsyForm = Ext.ComponentQuery.query(formName)[0];
                    //获取运行年限
                    var yyqx = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();
                    if (yyqx == "" || yyqx == undefined) {
                        Ext.MessageBox.alert('提示', "请先填写项目期限!");
                        return false;
                    }
                    window_xekjdr.show({TITLE: '请导入收支平衡表数据', DR_TYPE: '0'});//收支平衡表格模板下载
                }
            }, {
                xtype: 'button',
                itemId: 'tbsm',
                hidden: true,
                text: '填报说明',
                handler: function (btn) {
                    window.open('../../common/ystbsmText.jsp');
                }
            },
            {
                text: '保存',
                handler: function (btn) {
                    submitXzzq(btn);
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    getKmJcsj((is_fxjh == 1 || is_fxjh == 4 || is_fxjh == 3) ? SET_YEAR : SET_YEAR + 1, true);
                    btn.up('window').close();
                }
            }
        ]
    });
}

//收支平衡弹出窗口
var window_xekjdr = {
    window: null,
    config: {
        closeAction: 'destroy'
    },
    show: function (config) {
        if (!this.window || this.config.closeAction == 'destroy') {

            this.window = initWindow_xekjdr(config);
        }
        this.window.show();
    }
};

function initWindow_xekjdr(config) {
    return Ext.create('Ext.window.Window', {
        title: config.TITLE,
        width: document.body.clientWidth * 0.4,
        height: document.body.clientHeight * 0.4,
        layout: {
            type: 'fit'
        },
        //maximizable:true,//最大最小化
        modal: true,
        closeAction: 'destroy',
        buttonAlign: 'right',
        items: initxekjdatadrform(config),
    });
}

//初始化导入名录信息form
function initxekjdatadrform(config) {
    return Ext.create('Ext.form.Panel', {
        labelWidth: 70,
        fileUpload: true,
        defaultType: 'textfield',
        layout: 'anchor',
        items: [
            {
                xtype: 'container',
                layout: 'anchor',
                anchor: '100% 100%',
                defaultType: 'textfield',
                style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
                defaults: {
                    margin: '2 5 2 5',
                    //width: 315,
                    fontSize: 20,
                    labelWidth: 100//控件默认标签宽度
                },
                items: [
                    {
                        xtype: 'displayfield',
                        fieldLabel: '<span class="required">✶</span>注意事项',
                        margin: '2 5 2 5',
                        anchor: '100% 10%'
                    },
                    {
                        xtype: 'textarea',
                        multiline: true,
                        name: '',
                        editable: false,
                        readOnly: true,
                        anchor: '100% 60%',
                        border: true,
                        fieldStyle: 'background:#E6E6E6',
                        value: '1.导入的Excel文件最大不可超过20M。\n\n' +
                            '2.不可删除Excel中固定的数据列，否则会造成数据错乱。\n\n' +
                            '3.导入年数应与项目期限保持同步!'
                    },
                    {//分割线
                        xtype: 'menuseparator',
                        anchor: '100%',
                        border: true
                    },
                    {
                        xtype: 'filefield',
                        fieldLabel: '请选择文件',
                        name: 'upload',
                        anchor: '100% 30%',
                        msgTarget: 'side',
                        allowBlank: true,
                        margin: '5 5 2 5',
                        width: 70,
                        height: 30,
                        labelWidth: 80,
                        buttonConfig: {
                            width: 100,
                            height: 25,
                            text: '预览',
                            icon: '/image/sysbutton/report.png'
                        }
                    }
                ]
            }
        ],
        buttons: [
            {
                xtype: 'button',
                text: '上传',
                name: 'upload',
                handler: function (btn) {
                    var form = this.up('form').getForm();
                    var file = form.findField('upload').getValue();
                    if (file == null || file == '') {
                        Ext.Msg.alert('提示', '请选择文件！');
                        return;
                    } else if (!(file.endWith('.xls') || file.endWith('.xlsx') || file.endWith('.et'))) {//20210601 zhuangrx 文件导入兼容et类型
                        Ext.Msg.alert('提示', '请选择Excel类型文件！');
                        return;
                    }
                    if (form.isValid()) {
                        upLoadExcel(form, btn);
                    }
                }
            },
            {
                xtype: 'button',
                text: '取消',
                name: 'cancel',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

//收支平衡模板下载
function szysExcelDown() {
    window.location.href = 'downExcel.action?file_name=' + encodeURI(encodeURI("收支平衡表格模板.xls"));
}

function upLoadExcel(form, btn) {
    var xmsyForm = Ext.ComponentQuery.query(formName)[0];
    //获取运行年限
    var yyqx = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();
    var url = '/importExcel_szys.action';
    form.submit({
        url: url,
        params: {
            "yyqx": yyqx
        },
        waitTitle: '请等待',
        waitMsg: '正在导入中...',
        success: function (form, action) {
            var columnStore = action.result.list;
            var grid = DSYGrid.getGrid('xmsyGrid');
            grid.getStore().removeAll();
            grid.insertData(null, columnStore);
            btn.up('window').close();
            editLoad(grid, false);
        },
        failure: function (resp, action) {
            var msg = action.result.data.message;
            Ext.MessageBox.show({
                title: '提示',
                msg: '导入失败:' + msg,
                width: 200,
                fn: function (btn) {
                }
            });
        }
    });
}

/**
 * 初始化债券信息填报表单
 */
function initWindow_zqxxtb_contentForm() {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            anchor: '100%'/*,
             margin: '5 5 5 5',*/
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
            initWindow_zqxxtb_contentForm_tab()
        ]
    });
}

/**
 * 初始化债券信息填报弹出窗口中的tabpanel
 */
function initWindow_zqxxtb_contentForm_tab() {
    if (IS_XMBCXX == '1') {
        var zqxxtbTab = Ext.create('Ext.tab.Panel', {
            itemId: 'zqxxTab',
            anchor: '100% -17',
            border: false,
            items: [
                {
                    title: '基本情况',
                    //scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_jbqk()
                },
                {
                    title: '项目初审表',
                    //scrollable: true,
                    hidden: is_fxjh == '5' ? false : true,
                    items: initWindow_zqxxtb_contentForm_tab_csqkqk()
                },
                {
                    title: '本次申报',
                    layout: 'fit',
                    //scrollable: true,
                    hidden: is_fxjh == '5' ? true : false,
                    items: initWindow_zqxxtb_contentForm_tab_bnsb()
                },
                {
                    title: '项目承建企业',
                    layout: 'fit',//布局为fit后， scrollable不能用z
                    hidden: is_fxjh == 1 ? false : true,
                    //scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_xmcjqy_grid()
                },
                {

                    title: '补充信息',
                    layout: 'fit',
                    //scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_bcxx()
                },
                {
                    title: '投资计划',
                    layout: 'fit',//布局为fit后， scrollable不能用
                    //scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_tzjh()
                },
                {
                    //title: '收支平衡',
                    title: '收支平衡',
                    layout: 'fit',
                    btnsItemId: 'szys',
                    //scrollable: true,
                    items: isOld_szysGrid == '1' ? initWindow_zqxxtb_contentForm_tab_xmsy() : initWindow_zqxxtb_contentForm_tab_szys()
                },
                //20210924 zhuangrx 兼容辽宁项目特征
                {
                    title: is_show ? '十大工程' : '项目特征',//湖北专用填报十大工程页签内容
                    layout: 'fit',
                    btnsItemId: 'sdgc',
                    //scrollable: true,
                    hidden: sysAdcode == '42' || is_fxjh == '5' || is_show == false ? false : true,
                    items: initWindow_zqxxtb_contentForm_tab_sdgc(null, 'jhtb', window_zqxxtb.XM_ID)
                }
            ],
            listeners: {

                tabchange: function (tabPanel, newCard, oldCard) {
                    var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
                    if (isOld_szysGrid == '0' && newCard.btnsItemId == 'szys') {
                        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(false);
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(false);
                        Ext.ComponentQuery.query('button#import')[0].setHidden(false);
                        var self = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0];
                        change_tdcbysbz_grid(self, {IS_YHS: false});
                    } else {
                        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#import')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);

                    }
                    var XMLX_ID = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0].getValue();
                    if (XMLX_ID == '05') {//20210902LIYUE土储类隐藏收支平衡页签中导入和模板下载按钮
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#import')[0].setHidden(true);
                    }
                    if (is_fxjh != '5') {
                        if (newCard.title == '项目承建企业') {
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
                }
            }
        });
    } else {
        var zqxxtbTab = Ext.create('Ext.tab.Panel', {
            itemId: 'zqxxTab',
            anchor: '100% -17',
            border: false,
            items: [
                {
                    title: '基本情况',
                    //scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_jbqk()
                },
                {
                    title: '项目初审表',
                    //scrollable: true,
                    hidden: is_fxjh == '5' ? false : true,
                    items: initWindow_zqxxtb_contentForm_tab_csqkqk()
                },
                {
                    title: '本次申报',
                    layout: 'fit',
                    //scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_bnsb()
                },
                {
                    title: '项目承建企业',
                    layout: 'fit',//布局为fit后， scrollable不能用
                    hidden: is_fxjh == 1 ? false : true,
                    //scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_xmcjqy_grid()
                },
                {
                    title: '投资计划',
                    layout: 'fit',//布局为fit后， scrollable不能用
                    //scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_tzjh()
                },
                {
                    //title: '收支平衡',
                    title: '收支平衡',
                    layout: 'fit',
                    btnsItemId: 'szys',
                    //scrollable: true,
                    items: isOld_szysGrid == '1' ? initWindow_zqxxtb_contentForm_tab_xmsy() : initWindow_zqxxtb_contentForm_tab_szys()
                },
                //20210924 zhuangrx 兼容辽宁项目特征
                {
                    title: is_show ? '十大工程' : '项目特征',//湖北专用填报十大工程页签内容
                    layout: 'fit',
                    btnsItemId: 'sdgc',
                    //scrollable: true,
                    hidden: sysAdcode == '42' || is_fxjh == '5' || is_show == false ? false : true,
                    items: initWindow_zqxxtb_contentForm_tab_sdgc(null, 'jhtb', window_zqxxtb.XM_ID)
                }
            ],
            listeners: {
                tabchange: function (tabPanel, newCard, oldCard) {
                    if (isOld_szysGrid == '0' && newCard.btnsItemId == 'szys') {
                        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(false);
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(false);
                        Ext.ComponentQuery.query('button#import')[0].setHidden(false);
                        var self = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0];
                        change_tdcbysbz_grid(self, {IS_YHS: false});
                    } else {
                        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#import')[0].setHidden(true);
                    }
                    var XMLX_ID = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0].getValue();
                    if (XMLX_ID == '05') {//20210902LIYUE土储类隐藏收支平衡页签中导入和模板下载按钮
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#import')[0].setHidden(true);
                    }
                    if (is_fxjh != '5') {
                        if (newCard.title == '项目承建企业') {
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
                }
            }
        });
    }
    var items = getXmxxItems(tab_items, window_zqxxtb.XM_ID);
    for (var i = 0; i <= items.length + 1; i++) {
        if (i == items.length + 1) {
            if ((HAVE_SFJG == '2' && is_fxjh == '1') || (HAVE_SFJG == '1' && is_fxjh == '3')
                || (HAVE_SFJG == '3' && (is_fxjh == '1' || is_fxjh == '3'))) {//与是否为专项债券系统无关
                zqxxtbTab.add({
                    title: '项目评分',
                    scrollable: true,
                    layout: 'fit',
                    items: [
                        {
                            xtype: 'panel',
                            itemId: 'xmPfxxPanel',//项目评分信息面板
                            layout: 'fit',
                            border: false,
                            items: []
                        }
                    ]
                });
            }
        } else if (i == items.length) {
            zqxxtbTab.add({
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                //scrollable: true,
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
            });
        } else {
            zqxxtbTab.add(items[i]);
        }
    }
    // 判断是否添加绩效指标页签
    addOrRemoveJxglTab();
    return zqxxtbTab;
}

/**
 * 切换tab页签
 */
function zqxxtbTab(index) {
    var zqxxtbTab = Ext.ComponentQuery.query('panel[itemId="zqxxTab"]')[0];
    zqxxtbTab.items.get(index).show();
}

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
                                fieldLabel: '项目编码',
                                name: 'XM_CODE',
                                readOnly: true,
                                fieldStyle: 'background:#E6E6E6'
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>项目名称',
                                name: 'XM_NAME',
                                emptyText: '请输入...',
                                allowBlank: false,
                                listeners: {
                                    change: function (self, newValue) {
                                        initWindow_zqxxtb_contentForm_tab_jbqk_refreshForm();
                                    }
                                }
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>立项年度',
                                name: 'LX_YEAR',
                                xtype: 'combobox',
                                value: SET_YEAR,
                                displayField: 'name',
                                valueField: 'id',
                                store: DebtEleStore(getYearList()),
                                allowBlank: false,
                                editable: false
                            },
                            {
                                fieldLabel: sysAdcode == '12' ? '<span class="required">✶</span>所属主管部门' : '所属主管部门',
                                name: 'SS_ZGBM_ID',
                                xtype: 'combobox',
                                editable: false,
                                rootVisible: false,
                                hidden: true,
                                allowBlank: sysAdcode == '12' ? false : true,
                                displayField: 'name',
                                valueField: 'id',
                                store: DebtEleTreeStoreDBTable("DSY_V_ELE_AG_ZGBM", {condition: "and condition='" + AD_CODE + "'"})
                            },
                            //项目地址穿透百度地图改造 dengzq_20210430
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
                                maxLengthText: '输入编码过长，只能输入38位！'
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
                                fieldLabel: '<span class="required">✶</span>是否列入重大项目库',
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
                                        initWindow_zqxxtb_contentForm_tab_jbqk_refreshForm();
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
                                regex: /(\b^(\d{4}\-\d{6}\-\d{2}\-\d{2}\-\d{6}$)\b)/,
                                regexText: '发改委审批监管代码格式错误',
                                emptyText: 'XXXX-XXXXXX-XX-XX-XXXXXX'
                                //maxLengthText : '输入字符过长，只能输入50个字符'
                            },/*,
                             {
                             xtype: "numberFieldFormat",
                             name: "XMZGS_AMT_JBQK",
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
                                fieldLabel: ywcsbl || AD_CODE == '12' || AD_CODE == '1200' ? '<span class="required">✶</span>归口处室' : '归口处室',
                                name: 'MB_ID',
                                xtype: 'combobox',
                                editable: false,
                                displayField: 'name',
                                valueField: 'id',
                                allowBlank: ywcsbl || AD_CODE == '12' || AD_CODE == '1200' ? false : true,
                                store: ywcs_store
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>建设单位',
                                name: 'USE_UNIT_ID',
                                allowBlank: true,
                                hidden: true,
                                value: AG_NAME,

                            },
                            {
                                fieldLabel: '<span class="required">✶</span>建设单位统一社会信用代码',
                                name: 'JSDW_TYSHXY',
                                allowBlank: true,
                                hidden: true,
                                labelWidth: 180,
                                value: USCCODE
                                // ,20210625_dengzq_去除隐藏的统一社会信用代码正则校验
                                // regex:  /(^[A-Z0-9]{18}$)/,
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
                                hidden: true,
                                value: AG_NAME
                            }, {
                                fieldLabel: '<span class="required">✶</span>运营单位统一社会信用代码',
                                name: 'YYDW_TYSHXY',
                                allowBlank: true,
                                hidden: true,
                                labelWidth: 180,
                                value: USCCODE
                                // ,20210625_dengzq_去除隐藏的统一社会信用代码正则校验
                                // regex:  /(^[A-Z0-9]{18}$)/,
                                // regexText : '统一社会信用代码只能为18位（可包含大写字母、数字）'
                            },
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
                                store: DebtEleStoreDB("DEBT_XMJSXZ"),
                                allowBlank: false,
                                editable: false
                            },
                            {
                                xtype: 'treecombobox',
                                fieldLabel: '<span class="required">✶</span>项目性质',
                                name: 'XMXZ_ID',
                                displayField: 'name',
                                valueField: 'id',
                                rootVisible: false,
                                lines: false,
                                allowBlank: false,
                                editable: false, //禁用编辑
                                selectModel: 'leaf',
                                store: xmxz_store,//DebtEleTreeStoreDB("DEBT_ZJYT")
                                listeners: {
                                    change: function (self, newValue) {
                                        if (!self.getValue()) {
                                            return;
                                        }
                                        if (node_type != 'typing' && node_type != 'xmtz' && (node_type != 'jhtb' || (button_status == 'addXm' && node_type == 'jhtb') || first == '0')) {
                                            //20201126李月根据资金投向领域加载项目类型方法
                                            getstore();
                                        }
                                        if ((first == '1' && button_status == 'update')) {//20210429LIYUE 兼容新增按钮修改时资金投向与项目类性联动
                                            zjtxly_store = DebtEleTreeStoreDB("DEBT_ZJTXLY");
                                            zjtxly_store.load();
                                            getstore();
                                        }
                                        var XMXZ_ID = this.up('form').getForm().findField('XMXZ_ID');
                                        if (XMXZ_ID.value == '010102') {
                                            var xmsy_ycyj = self.up('form').down('textarea[name="XMSY_YCYJ"]');
                                            xmsy_ycyj.setFieldLabel('<span class="required">✶</span>' + '项目收益预测依据');
                                            xmsy_ycyj.allowBlank = false;
                                        } else {
                                            var xmsy_ycyj = self.up('form').down('textarea[name="XMSY_YCYJ"]');
                                            xmsy_ycyj.setFieldLabel('项目收益预测依据');
                                            xmsy_ycyj.allowBlank = true;
                                        }
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
                                readOnly: (is_fxjh == '1') ? true : false,
                                fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                                listeners: {
                                    change: function (self, newValue) {
                                        if (node_type != 'typing' && node_type != 'xmtz' && (node_type != 'jhtb' || (button_status == 'addXm' && node_type == 'jhtb') || first == '0')) {
                                            //20201126李月根据资金投向领域加载项目类型方法
                                            getstore();
                                        }
                                        if ((first == '1' && button_status == 'update')) {//20210429LIYUE 兼容新增按钮修改时资金投向与项目类性联动
                                            zjtxly_store = DebtEleTreeStoreDB("DEBT_ZJTXLY");
                                            zjtxly_store.load();
                                            getstore();
                                        }
                                        //20210618 zhuangrx 选择资金投向领域时加载专家评分框
                                        //HAVE_SFJG：0是项目库所有流程都没有三方机构与专家评审流程，1是储备库有上述流程，2是发行库有上述流程，3是储备与发行库都有上述流程
                                        //is_fxjh：0需求库，1发行库，3，储备库
                                        //zjpslx:txly 根据资金投向领域进行专家评审，zqlx 根据债券类型进行专家评审
                                        //因为目前只有河南有资金投向领域进行专家评审，并没有三方机构上传附件 ，所以zjpslx:txly 时不进行三方机构上传附件
                                        if (((HAVE_SFJG == '1' && is_fxjh == '3') || (HAVE_SFJG == '2' && is_fxjh == '1')
                                            || (HAVE_SFJG == '3' && (is_fxjh == '1' || is_fxjh == '3'))) && zjpslx == 'txly') {
                                            var id = '';
                                            $.post('getpfbzid.action', {ID: newValue}, function (data) {
                                                //加载获取的数据
                                                if (data.success) {//加载成功
                                                    id = data.list[0];//传递一个array对象
                                                    //项目评分页签相关内容
                                                    //获取panel，并移除grid
                                                    var panel2 = Ext.ComponentQuery.query('panel#xmPfxxPanel')[0];
                                                    panel2.removeAll(true);
                                                    //构建项目评分grid，未格式化
                                                    var grid = initXekXMPfxxGrid(id, window_zqxxtb.JH_ID);
                                                    //添加到panel中，触发panel的afterlayout事件
                                                    panel2.add(grid);
                                                }
                                            }, "json");

                                        }
                                        initWindow_zqxxtb_contentForm_tab_jbqk_refreshForm();
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
                                //store: DebtEleTreeStoreJSON(json_debt_zwxmlx),
                                store: zwxmlx_store,
                                allowBlank: false,
                                editable: false,
                                listeners: {
                                    select: function (self) {
                                        if (self.getValue() == '05') {
                                            field_names = '土地面积(公顷)';
                                            field_names_dk = '地块GIS';
                                            field_names_cb = '储备期限';
                                        } else if (self.getValue().substring(0, 2) == '02') {
                                            field_names = '通车里程(公里)';
                                            field_names_dk = '车辆购置税';
                                            field_names_cb = '车辆通行费征收标准';
                                        } else if (self.getValue().substring(0, 2) == '06') {
                                            field_name = '棚改范围';
                                            field_names_dk = '规模户数';
                                            field_names_cb = '标准';
                                        }
                                        var rink = Ext.ComponentQuery.query('fieldset[name="shrink"]')[0];
                                        var variable = Ext.ComponentQuery.query('textfield[name="LXDW"]')[0];
                                        if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02') {
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
                                        if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02' || self.getValue().substring(0, 2) == '06') {
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
                                        if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02' || self.getValue().substring(0, 2) == '06') {
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
                                        variable4.setValue("");
                                    },
                                    change: function (self) {
                                        if (!self.getValue()) {
                                            return;
                                        }
                                        // 调用公共方法：如果是项目类型是土地存储则重新初始化收支平衡grid
                                        if (isOld_szysGrid == '0') {
                                            change_tdcbysbz_grid(self, {XM_ID: window_zqxxtb.XM_ID});
                                        }
                                        if (self.getValue() == '05') {
                                            field_names = '土地面积(公顷)';
                                            field_names_dk = '地块GIS';
                                            field_names_cb = '储备期限';
                                        } else if (self.getValue().substring(0, 2) == '02') {
                                            field_names = '通车里程(公里)';
                                            field_names_dk = '车辆购置税';
                                            field_names_cb = '车辆通行费征收标准';
                                        } else if (self.getValue().substring(0, 2) == '06') {
                                            field_name = '棚改范围';
                                            field_names_dk = '规模户数';
                                            field_names_cb = '标准';
                                        }
                                        var rink = Ext.ComponentQuery.query('fieldset[name="shrink"]')[0];
                                        var variable = Ext.ComponentQuery.query('textfield[name="LXDW"]')[0];
                                        if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02') {
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
                                            variable4.setFieldLabel(field_name);
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
                                        if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02' || self.getValue().substring(0, 2) == '06') {
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
                                        if (self.getValue() == '05' || self.getValue().substring(0, 2) == '02' || self.getValue().substring(0, 2) == '06') {
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
                                    }
                                }
                            },
                            {
                                fieldLabel: "国土部门监管码",
                                name: 'DISC',
                                xtype: "textfield",
                                editable: true
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>立项审批依据',
                                name: 'LXSPYJ_ID',
                                xtype: 'combobox',
                                displayField: 'name',
                                valueField: 'id',
                                store: DebtEleStore(json_debt_lxspyj),
                                allowBlank: false,
                                editable: false
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>立项审批级次',
                                name: 'SP_LEVEL_ID',
                                xtype: 'combobox',
                                displayField: 'name',
                                valueField: 'id',
                                store: DebtEleStore(json_debt_lxspjc),
                                allowBlank: false,
                                editable: false,
                                listeners: {
                                    change: function (self, newValue) {
                                        initWindow_zqxxtb_contentForm_tab_jbqk_refreshForm();
                                    }
                                }
                            }, {
                                //xtype: "treecombobox",
                                xtype: "combobox",
                                name: "LXSPBM_ID",
                                //store: DebtEleTreeStoreDB("DEBT_ZGBM"),
                                /*
                                store: DebtEleTreeStoreDBTable("DSY_V_ELE_AG",{condition:"and levelno = '1' and condition="+AD_CODE}),
*/
                                store: DebtEleTreeStoreDBTable("DSY_V_ELE_AG_ZGBM", {condition: "and condition='" + AD_CODE + "'"}),//20210517liyue立项审批部门去取左侧单位树，非低级区划
                                fieldLabel: '<span class="required">✶</span>立项审批部门',
                                displayField: 'name',
                                valueField: 'id',
                                rootVisible: false,
                                lines: false,
                                allowBlank: false,
                                editable: false//20210909LIYUEy添加下拉框不可编辑事件
                                /*,
                                selectModel: 'leaf'*/
                            },
                            {
                                xtype: 'textfield',
                                fieldLabel: '项目建议书文号',
                                name: 'JYS_NO',
                                maxLength: 50,
                                maxLengthText: '输入文字过长，只能输入50个字！'
                            },
                            {
                                fieldLabel: '可研批复文号',
                                name: 'PF_NO',
                                maxLength: 50,
                                maxLengthText: '输入文字过长，只能输入50个字！'
                            },
                            {
                                xtype: "treecombobox",
                                name: 'GCLB_ID',
                                store: DebtEleTreeStoreDB("DEBT_GCLB", {condition: z_condition}),
                                fieldLabel: sysAdcode == '42' ? '<span class="required">✶</span>工程类别' : '工程类别',
                                displayField: 'name',
                                valueField: 'id',
                                allowBlank: sysAdcode == '42' ? false : true,
                                hidden: sysAdcode == '42' ? false : true,
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
                                hidden: true,
                                store: DebtEleTreeStoreDB("DEBT_BDBCYLX")
                            },
                            {
                                xtype: "textfield",//20201126李月资金投向与项目类型级联所需自字段
                                fieldLabel: 'EXTEND1',
                                hidden: true,
                                name: 'EXTEND1',
                                listeners: {
                                    'change': function (self, newValue) {
                                        var ZJTXLY_ID = Ext.ComponentQuery.query('treecombobox[name="ZJTXLY_ID"]')[0].getValue();
                                        var arr = [];
                                        //2020121815_zhuangrx_重写资金投向领域传值过程，兼容ie
                                        newValue = newValue.replaceAll("#", "").substring(0, newValue.length);//替换掉#
                                        var s = newValue.length / 2;//每两位截取一次
                                        for (var m = 0; m < s; m++) {
                                            arr.push(newValue.substring(0, 2));
                                            newValue = newValue.substring(2, newValue.length);
                                        }
                                        var condition = '';//2021041_LIYUE_完善校验
                                        if (!isNull(arr) && arr.length > 0) {
                                            condition = " AND";
                                        }
                                        for (var i = 0; i < arr.length; i++) {
                                            if (i < arr.length - 1) {
                                                condition = condition + " CODE LIKE '" + arr[i] + "%' or ";
                                            } else {
                                                condition = condition + " CODE LIKE '" + arr[i] + "%'";
                                            }
                                        }
                                        zjtxly_store.getProxy().extraParams.condition = encode64(condition);
                                        zjtxly_store.load();

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
                                fieldLabel: '<span class="required">✶</span>计划开工日期',
                                name: 'START_DATE_PLAN',
                                xtype: 'datefield',
                                format: 'Y-m-d',
                                allowBlank: false,
                                value: today,
                                vtype: 'comparePlanDate'
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>计划竣工日期', name: 'END_DATE_PLAN',
                                xtype: 'datefield', format: 'Y-m-d', allowBlank: false, vtype: 'comparePlanDate'
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>单位项目负责人',
                                name: 'BILL_PERSON',
                                allowBlank: false,
                                maxLength: 20,
                                maxLengthText: '输入字符过长，只能输入20个字！'
                            },
                            {
                                fieldLabel: '实际开工日期', name: 'START_DATE_ACTUAL',
                                xtype: 'datefield', format: 'Y-m-d', editable: true, vtype: 'compareActualDate'
                            },
                            {
                                fieldLabel: '实际竣工日期', name: 'END_DATE_ACTUAL', maxValue: nowDate,
                                xtype: 'datefield', format: 'Y-m-d', editable: true, vtype: 'compareActualDate'
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>负责人联系电话',
                                name: 'BILL_PHONE',
                                allowBlank: false,
                                regex: /^(?:0[0-9]{2,3}[-\\s]{1}|\\(0[0-9]{2,4}\\))[0-9]{6,8}$|^[1-9]{1}[0-9]{5,7}$|^[1-9]{1}[0-9]{10}$/,
                                regexText: '手机号码格式有误，请重填'
                            },
                            {
                                fieldLabel: '<span class="required">✶</span>建设状态',
                                name: 'BUILD_STATUS_ID',
                                xtype: 'combobox',
                                displayField: 'name',
                                valueField: 'id',
                                //store: DebtEleStore(json_debt_jszt),
                                store: DebtEleTreeStoreDB("DEBT_XMJSZT"),
                                allowBlank: false,
                                editable: false,
                                listeners: {
                                    change: function (self, newValue) {
                                        initWindow_zqxxtb_contentForm_tab_jbqk_refreshForm();
                                    }
                                }
                            },
                            {
                                fieldLabel: '上级项目',
                                name: 'UPPER_XM_ID',
                                xtype: 'treecombobox',
                                displayField: 'name',
                                valueField: 'name',
                                selectModel: 'leaf',
                                store: DebtEleTreeStoreDB('DEBT_SJXM'),
                                editable: false
                            },
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
                                listeners: {
                                    change: function (self, newValue) {
                                        initWindow_zqxxtb_contentForm_tab_jbqk_refreshForm();
                                    }
                                }
                            },
                            {
                                fieldLabel: '项目收益预测依据',
                                name: 'XMSY_YCYJ',
                                xtype: 'textarea',
                                allowBlank: true,
                                maxLength: 1000,//限制输入字数
                                maxLengthText: "输入内容过长，最多只能输入1000个汉字！",
                                listeners: {
                                    change: function (self, newValue) {
                                        initWindow_zqxxtb_contentForm_tab_jbqk_refreshForm();
                                    }
                                }
                            }
                        ]
                    }, /*{//分割线
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
                                             // store_xmxz.proxy.extraParams['condition'] = encode64(" and guid not in ('0102')");
                                             // store_xmxz.load();
                                             // var xmxz = this.up('form').getForm().findField('XMXZ_ID').getValue();
                                             // if(xmxz == '' || xmxz == null || xmxz == undefined){
                                             //     this.up('form').getForm().findField('XMXZ_ID').setValue("010102");
                                             // }
                                            XMJSQ_START.setDisabled(false);
                                            XMJSQ_END.setDisabled(false);
                                            XMYYQ_START.setDisabled(false);
                                            XMYYQ_END.setDisabled(false);
                                            IS_XCCBSSFA.setDisabled(false);
                                            IS_TGCZCSNLLZ.setDisabled(false);
                                            IS_TGWUSZPJ.setDisabled(false);
                                        } else {
                                            // this.up('form').getForm().findField('XMXZ_ID').setValue("");
                                            // store_xmxz.proxy.extraParams['condition'] = "";
                                            // store_xmxz.load();
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
                        ],
                    }*/
                ]
            }
        ]
    });
}

function initWindow_zqxxtb_contentForm_tab_csqkqk() {
    return Ext.create('Ext.form.Panel', {
        name: 'csqkForm',
        itemId: 'csqkForm',
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
                xtype: 'fieldset',
                title: '一、项目基本情况',
                layout: 'column',
                defaultType: 'textfield',
                anchor: '100%',
                collapsible: false,
                fieldDefaults: {
                    labelWidth: 150,
                    columnWidth: .45,
                    margin: '2 5 5 5'
                },
                items: [
                    {
                        fieldLabel: '项目名称',
                        name: 'XM_NAME',
                        columnheight: 35,
                        columnWidth: .900,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',

                    },
                    {
                        fieldLabel: '项目所属区划',
                        name: 'AD_CODE',
                        hideTrigger: true,
                        minValue: 0,
                        decimalPrecision: 2,
                        columnWidth: .900,
                        hidden: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '项目所属区划',
                        name: 'AD_NAME',
                        hideTrigger: true,
                        minValue: 0,
                        decimalPrecision: 2,
                        columnWidth: .900,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: 'AG_CODE',
                        name: 'AG_CODE',
                        hideTrigger: true,
                        minValue: 0,
                        decimalPrecision: 2,
                        columnWidth: .900,
                        hidden: true
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>项目主管部门(管理单位)',
                        name: 'CS_XMZGDW',
                        columnWidth: .900,
                        hideTrigger: true,
                        allowBlank: false,
                        listeners: {
                            change: function (self, newValue) {
                                if (newValue.length > 50) {
                                    Ext.MessageBox.alert('提示', '项目立项依据超过文本长度！');
                                }
                            }
                        }
                    },
                    {
                        fieldLabel: '项目单位',
                        name: 'AG_NAME',
                        hideTrigger: true,
                        minValue: 0,
                        decimalPrecision: 2,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>项目单位性质',
                        name: 'XMDWXZ',
                        hideTrigger: true,
                        allowBlank: false

                    },
                    /*     {
                             fieldLabel: '项目实施内容',
                             name: 'BUILD_CONTENT',
                             hideTrigger: true,
                             readOnly: true,
                             columnWidth: .900,
                             fieldStyle: 'background:#E6E6E6'*/
                    {
                        fieldLabel: '项目实施内容',
                        name: 'BUILD_CONTENT',
                        xtype: 'textarea',
                        maxLength: 1000,//限制输入字数
                        columnWidth: .900,
                        height: '100%',
                        //width: '100%',
                        grow: true,//不需要滚动条，自适应长度
                        growMax: 300,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },

                    {
                        fieldLabel: '项目投资领域',
                        name: 'ZJTXLY_ID',
                        xtype: 'treecombobox',
                        displayField: 'name',
                        store: DebtEleTreeStoreDB("DEBT_ZJTXLY"),
                        valueField: 'id',
                        rootVisible: false,
                        hidden: false,
                        lines: false,
                        selectModel: 'leaf',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '项目级次(根据区划)',
                        name: 'SP_LEVEL_ID',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        store: DebtEleStore(json_debt_lxspjc),
                        editable: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '是否符合条件的重大项目',
                        name: 'IS_FGW_XM',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        minValue: 0,
                        store: DebtEleStore(json_debt_isorno),
                        editable: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '项目是否具有公益性',
                        name: 'XMXZ_ID',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>项目立项依据（已取得有权部门批复情况）',
                        name: 'CS_XMLXYJ',
                        hideTrigger: true,
                        allowBlank: false,
                        maxLength: 500,
                        maxLengthText: '文本长度最多为200个字符',
                        listeners: {
                            change: function (self, newValue) {
                                if (newValue.length > 250) {
                                    Ext.MessageBox.alert('提示', '项目立项依据超过文本长度！');
                                }
                            }
                        }
                    },
                    {
                        fieldLabel: '项目建设期',
                        name: 'JSNX',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '项目运营期',
                        name: 'XM_USED_LIMIT',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>项目是否具备开工条件',
                        name: 'BCXX9',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        minValue: 0,
                        store: DebtEleStore(json_debt_isorno),
                        allowBlank: false,
                        editable: false
                    },
                    {
                        fieldLabel: '项目进度情况',
                        name: 'BUILD_STATUS_ID',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        //store: DebtEleStore(json_debt_jszt),
                        store: DebtEleTreeStoreDB("DEBT_XMJSZT"),
                        editable: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '二、项目融资计划',
                layout: 'column',
                defaultType: 'textfield',
                anchor: '100%',
                collapsible: false,
                fieldDefaults: {
                    labelWidth: 150,
                    columnWidth: .45,
                    margin: '2 5 5 5'
                },
                items: [
                    {
                        fieldLabel: '<span class="required">✶</span>项目总投资',
                        name: 'XMZGS_AMT',
                        xtype: 'numberFieldFormat',
                        columnheight: 35,
                        columnWidth: .900,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'

                    },
                    {
                        fieldLabel: '其中：项目资本金',
                        name: 'ZBJ_AMT1',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        decimalPrecision: 2,
                        value: 0,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        listeners: {
                            change: function (self, newValue) {
                                if (!self.getValue()) {
                                    return;
                                }
                                var XMZGS_AMT = this.up('form').getForm().findField('XMZGS_AMT').getValue();
                                if (XMZGS_AMT == 0) {
                                    this.up('form').getForm().findField('ZBJ_ZB').setValue(0);
                                } else {
                                    var va = ((parseFloat(newValue / XMZGS_AMT).toFixed(2)) * 100).toString() + '%';
                                    this.up('form').getForm().findField('ZBJ_ZB').setValue(va);
                                }
                                initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
                                initWindow_zqxxtb_contentForm_tab_csqk_refreshForm();

                            }
                        }
                    },
                    {
                        fieldLabel: '占总投资比例',
                        name: 'ZBJ_ZB',
                        hideTrigger: true,
                        minValue: 0,
                        value: 0,
                        editable: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '其他债务融资',
                        name: 'ZWRZ_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 2,
                        value: 0,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        listeners: {
                            change: function (self, newValue) {
                                if (!self.getValue()) {
                                    return;
                                }
                                var XMZGS_AMT = this.up('form').getForm().findField('XMZGS_AMT').getValue();
                                if (XMZGS_AMT == 0) {
                                    this.up('form').getForm().findField('ZWRZ_ZB').setValue(0);
                                } else {
                                    var va = ((parseFloat(newValue / XMZGS_AMT).toFixed(2)) * 100).toString() + '%';
                                    this.up('form').getForm().findField('ZWRZ_ZB').setValue(va);
                                }
                                initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
                                initWindow_zqxxtb_contentForm_tab_csqk_refreshForm();

                            }
                        }

                    },
                    {
                        fieldLabel: '占总投资比例',
                        name: 'ZWRZ_ZB',
                        hideTrigger: true,
                        minValue: 0,
                        value: 0,
                        editable: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>专项债券融资',
                        name: 'APPLY_AMOUNT1',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        decimalPrecision: 2,
                        value: 0,
                        allowBlank: false,
                        listeners: {
                            change: function (self, newValue) {
                                if (!self.getValue()) {
                                    return;
                                }
                                var XMZGS_AMT = this.up('form').getForm().findField('XMZGS_AMT').getValue();
                                if (XMZGS_AMT == 0) {
                                    this.up('form').getForm().findField('ZXRZZB').setValue(0);
                                } else {
                                    var va = ((parseFloat(newValue / XMZGS_AMT).toFixed(2)) * 100).toString() + '%';
                                    this.up('form').getForm().findField('ZXRZZB').setValue(va);
                                }
                                initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
                                initWindow_zqxxtb_contentForm_tab_csqk_refreshForm();
                            }
                        }
                    },
                    {
                        fieldLabel: '占总投资比例',
                        name: 'ZXRZZB',
                        hideTrigger: true,
                        minValue: 0,
                        value: 0,
                        editable: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>其中，作为资本金的部分',
                        name: 'ZBJ_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        allowBlank: false,
                        listeners: {
                            change: function (self, newValue) {
                                initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
                                initWindow_zqxxtb_contentForm_tab_csqk_refreshForm();
                            }
                        }
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>项目资产或收益是否设置为抵押或担保',
                        name: 'BCXX10',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        minValue: 0,
                        store: DebtEleStore(json_debt_isorno),
                        allowBlank: false,
                        editable: false
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>项目分年融资情况',
                        name: 'CS_YEAR',
                        columnWidth: .250,
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        editable: false,
                        store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2020' "}),
                        value: SET_YEAR,
                        allowBlank: false,
                        listeners: {
                            change: function (self, newValue) {
                                if (!self.getValue()) {
                                    return;
                                }
                                //  var s1 = String(newValue);
                                VALUE = parseInt(newValue) + 1;
                                VALUE1 = parseInt(newValue) + 2;
                                VALUE2 = parseInt(newValue) + 3;
                                var CS_AMT2 = this.up('form').getForm().findField('CS_AMT2');
                                //XN_AMT.allowBlank = false;
                                CS_AMT2.setFieldLabel(VALUE.toString() + '年');
                                var CS_AMT3 = this.up('form').getForm().findField('CS_AMT3');
                                CS_AMT3.setFieldLabel(VALUE1.toString() + '年');
                                var CS_AMT4 = this.up('form').getForm().findField('CS_AMT4');
                                CS_AMT4.setFieldLabel(VALUE2.toString() + '年及以后');
                            }
                        }
                    },
                    {
                        name: 'CS_AMT1',
                        columnWidth: .10,
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        allowBlank: false
                    },
                    {
                        fieldLabel: (parseInt(SET_YEAR) + 1).toString() + '年',
                        name: 'CS_AMT2',
                        columnWidth: .15,
                        labelWidth: 50,
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        value: 0
                    },
                    {
                        fieldLabel: (parseInt(SET_YEAR) + 2).toString() + '年',
                        name: 'CS_AMT3',
                        columnWidth: .15,
                        labelWidth: 50,
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        value: 0
                    },
                    {
                        fieldLabel: (parseInt(SET_YEAR) + 3).toString() + '年及以后',
                        name: 'CS_AMT4',
                        columnWidth: .18,
                        labelWidth: 90,
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        value: 0
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '三、项目预期收益和成本',
                layout: 'column',
                defaultType: 'textfield',
                anchor: '100%',
                collapsible: false,
                fieldDefaults: {
                    labelWidth: 150,
                    columnWidth: .45,
                    margin: '2 5 5 5'
                },
                items: [
                    {
                        fieldLabel: '项目预期收益来源，依据及分年实现情况',
                        name: 'XMSY_YCYJ',
                        grow: true,//不需要滚动条，自适应长度
                        growMax: 300,
                        columnWidth: .900,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        xtype: 'textarea',
                        maxLength: 1000,//限制输入字数

                    },
                    {
                        fieldLabel: '<span class="required">✶</span>项目总收益/项目总债务融资本息',
                        name: 'CS_SYZB_RATE',
                        columnheight: 35,
                        allowBlank: false,
                        columnWidth: .900,
                        regex: /^[0-9]+\.?[0-9]*$/,
                        regexText: '只能输入数字或者小数'
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '四、拟发行专项债券情况',
                layout: 'column',
                defaultType: 'textfield',
                anchor: '100%',
                collapsible: false,
                fieldDefaults: {
                    labelWidth: 150,
                    columnWidth: .45,
                    margin: '2 5 5 5'
                },
                items: [
                    {
                        xtype: "combobox",
                        name: "ZQQX_ID",
                        store: DebtEleStoreDB("DEBT_ZQQX"),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>拟发行债券期限',
                        columnheight: 35,
                        allowBlank: false,
                        editable: false
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>债券还本方式',
                        name: 'HBFS_ID',
                        columnheight: 35,
                        allowBlank: false
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>债券类型',
                        name: 'BOND_TYPE_ID',
                        columnheight: 35,
                        hidden: true
                    }
                ]
            }
        ]
    });
}

var json_debt_bcxx = [
    {"id": "0", "code": "否", "name": "0"},
    {"id": "1", "code": "是", "name": "1"}

];
var json_debt_bcxx_yxdj = [
    {"id": "1", "code": "一级", "name": "1"},
    {"id": "2", "code": "二级", "name": "2"},
    {"id": "3", "code": "三级", "name": "3"},
    {"id": "4", "code": "四级", "name": "4"},
    {"id": "5", "code": "五级", "name": "5"}
];

/*基础数据，下拉框形式*/
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
                                allowBlank: false
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
                                allowBlank: false
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
                                allowBlank: false
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
                        value: today,
                        readOnly: (is_fxjh == '1') ? true : false,
                        fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        listeners: {
                            change: function (self, newValue, oldValue) {
                                if (newValue == null) {
                                    var form = this.up('form').getForm();
                                    form.findField('APPLY_DATE').setValue(nowDate);
                                }
                            }
                        },
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>经办人',
                        name: 'APPLY_INPUTOR',
                        allowBlank: false,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6',
                        value: userName,
                        listeners: {
                            change: function (self, newValue, oldValue) {
                                if (newValue == null || newValue == '') {
                                    var form = this.up('form').getForm();
                                    form.findField('APPLY_INPUTOR').setValue(userName);
                                }
                            }
                        },
                    },
                    {
                        fieldLabel: '申请年度',
                        name: 'BILL_YEAR',
                        xtype: 'combobox',
                        value: (is_fxjh == 1 || is_fxjh == 4) ? SET_YEAR : SET_YEAR + 1,
                        editable: false,
                        displayField: 'name',
                        valueField: 'id',
                        store: DebtEleStore(getYearList({start: 0, end: 1})),
                        allowBlank: false,
                        readOnly: (is_fxjh == '1' || is_fxjh == '4') ? true : false,
                        fieldStyle: (is_fxjh == '1' || is_fxjh == '4') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        listeners: {
                            change: function (self, newValue, oldValue) {
                                if (newValue != oldValue && newValue != null) {
                                    //专项债券系统根据申报年度切换控制数
                                    if (is_zxzqxt == '1' && is_zxzq != '2' && is_fxjh == '3' && SYS_ZXZQXT_KZS_CHECK == '1' && KZSArray != null && KZSArray != undefined) {
                                        var KZSField = self.next("[name=KZS_AMT]");
                                        var flag = false;
                                        KZSArray.forEach(function (record) {
                                            if (newValue == record.SET_YEAR) {
                                                KZSField.setValue(record.XQ_ZX_SY_AMT);
                                                flag = true;
                                            }
                                        });
                                        if (!flag) {
                                            KZSField.setValue(0);
                                        }
                                    }
                                    //同步更新，供申报批次修改时加载批次使用
                                    BATCH_YEAR = newValue;
                                    // 总体目标年度
                                    mbYear = newValue;
                                    BATCH_BOND_TYPE_ID = self.next("[name=BOND_TYPE_ID]") == null ? BATCH_BOND_TYPE_ID : self.next("[name=BOND_TYPE_ID]").getValue();

                                    getKmJcsj(newValue, false);
                                    Ext.MessageBox.wait('正在获取新年度功能分类、经济分类数据..', '请等待..');
                                    zwsrkm_store.load({
                                        callback: function () {
                                            zcgnfl_store.load({
                                                callback: function () {
                                                    zcjjfl_store.load({
                                                        callback: function () {
                                                            sbpc_store.load({
                                                                callback: function () {
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
                                var form = this.up('form').getForm();
                                var BOND_TYPE_ID = form.findField('BOND_TYPE_ID').getValue();
                                // 判断是否添加绩效指标页签
                                addOrRemoveJxglTab(BOND_TYPE_ID);
                            }
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
                    //20210922 zhuangrx 新增发行月份字段
                    {
                        xtype: 'combobox',
                        fieldLabel: '<span class="required">✶</span>发行月份',
                        name: 'ZQXM_FX_MONTH',
                        displayField: 'name',
                        valueField: 'code',
                        hidden: is_fxjh == '0' || is_fxjh == '3' ? false : true,
                        editable: false,
                        value: nowDate.substring(5, 7),
                        allowBlank: is_fxjh == '0' || is_fxjh == '3' ? false : true,
                        store: DebtEleStore(json_debt_yf_nd)
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>债券类型',
                        name: 'BOND_TYPE_ID',
                        xtype: 'treecombobox',
                        /*store: is_zxzqxt == '1'?(is_zxzq == '1' ? DebtEleTreeStoreDB('DEBT_ZQLB',{condition: "AND CODE LIKE '02%' AND CODE != '0201' "})
                            :((is_fxjh=='1'||is_fxjh == '3')?DebtEleTreeStoreDB('DEBT_ZQLB',{condition: "AND CODE NOT LIKE '02%' AND CODE != '0201' "}):
                                DebtEleTreeStoreDB('DEBT_ZQLB',{condition: " AND CODE != '0201' "}))):DebtEleTreeStoreDB('DEBT_ZQLB',{condition: " AND CODE != '0201' "}),
                        *///store: is_zxzqxt == '1'&& is_zxzq=='1'?DebtEleTreeStoreDB('DEBT_ZQLB',{condition: "AND CODE LIKE '02%'"}):DebtEleTreeStoreDB('DEBT_ZQLB'),
                        store: zqlx_store,//去除普通专项债券
                        displayField: 'name',
                        valueField: 'id',
                        value: bond_type_id,
                        selectModel: 'leaf',
                        editable: false,
                        allowBlank: false,
                        readOnly: (is_fxjh == '1') ? true : false,
                        fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        listeners: {
                            change: function (self, newValue) {
                                if (is_fxjh == '1' || is_fxjh == '4' || is_fxjh == '3') {//限额库使用
                                    if (newValue == null || newValue == 'undefined') {
                                        return;
                                    }
                                    //if(''!=newValue){
                                    //通过ZQLX_ID获取配置过的附件规则id
                                    Ext.MessageBox.wait('正在获取附件配置信息……', '请稍等');
                                    $.post('getFjRuleIdsByZqlx.action', {ZQLX_ID: newValue}, function (data) {
                                        var panel = Ext.ComponentQuery.query('panel#zqfjpzPanel')[0];
                                        panel.removeAll(true);
                                        var fjGrid = null;
                                        //加载获取的数据
                                        if (data.success) {//加载成功
                                            var ruleIds = data.list;//传递一个array对象
                                            fjGrid = initWindow_zqxxtb_contentForm_tab_xmfj({ruleIds: ruleIds});
                                        } else {
                                            Ext.Msg.alert('提示', '附件信息加载失败！' + data.message);
                                            fjGrid = initWindow_zqxxtb_contentForm_tab_xmfj({ruleIds: []});
                                        }
                                        //专项债券系统下添加 is_zxzqxt = 1 && is_zxzq = 1
                                        //if(is_zxzqxt=='1'&&is_zxzq=='1'){
                                        //新工作流下、专项菜单下、is_zxzqxt=1时会所、律所不显示、附件不校验
                                        //20210618 zhuangrx 选择资金投向领域时债券类型不加载专家评分框
                                        if (((HAVE_SFJG == 1 && is_fxjh == 3) || (HAVE_SFJG == 2 && is_fxjh == 1)
                                            || (HAVE_SFJG == 3 && (is_fxjh == 3 || is_fxjh == 1))) && zjpslx == 'zqlx') {
                                            //为附件grid添加会计事务所，律师事务所下拉选择框
                                            var KJSWSCombobox = {
                                                xtype: 'treecombobox',
                                                fieldLabel: '会计事务所',
                                                name: 'KJSWS_ID',
                                                editable: true,
                                                displayField: 'text',
                                                valueField: 'id',
                                                selectModel: "leaf",
                                                rootVisible: false,
                                                value: KJSWS_ID_VALUE,
                                                labelWidth: 100,//控件默认标签宽度
                                                labelAlign: 'right',//控件默认标签对齐方式
                                                //存在专家评审阶段或业务处室选择会所、律所业务时申报页面附件页签不显示会所、律所选择框
                                                hidden: (!(HAVE_SFJG == 1 && is_fxjh == 3) && !(HAVE_SFJG == 2 && is_fxjh == 1)
                                                        && !(HAVE_SFJG == 3 && (is_fxjh == 3 || is_fxjh == 1)))
                                                    || (is_zxzqxt == 1 && is_zxzq == 1 && is_fxjh == 3 && sys_right_model == 1) || sysAdcode == '13',
                                                //HAVE_SFJG：0是项目库所有流程都没有三方机构与专家评审流程，1是储备库有上述流程，2是发行库有上述流程，3是储备与发行库都有上述流程
                                                //is_fxjh：0需求库，1发行库，3，储备库
                                                //is_zxzqxt：湖北专项个性参数，is_zxzq==1 专项菜单
                                                //sys_right_model:1新工作流，2：老工作流
                                                //因为河北没有三方机构上传附件，故隐藏河北三方机构上传附件
                                                store: kjsws_store,
                                                allowBlank: true
                                            };
                                            var LSSWSCombobox = {
                                                xtype: 'treecombobox',
                                                fieldLabel: '律师事务所',
                                                name: 'LSSWS_ID',
                                                editable: true,
                                                displayField: 'text',
                                                valueField: 'id',
                                                selectModel: "leaf",
                                                rootVisible: false,
                                                value: LSSWS_ID_VALUE,
                                                labelWidth: 100,//控件默认标签宽度
                                                labelAlign: 'right',//控件默认标签对齐方式
                                                hidden: (!(HAVE_SFJG == 1 && is_fxjh == 3) && !(HAVE_SFJG == 2 && is_fxjh == 1)
                                                        && !(HAVE_SFJG == 3 && (is_fxjh == 3 || is_fxjh == 1)))
                                                    || (is_zxzqxt == 1 && is_zxzq == 1 && is_fxjh == 3 && sys_right_model == 1) || sysAdcode == '13',
                                                //HAVE_SFJG：0是项目库所有流程都没有三方机构与专家评审流程，1是储备库有上述流程，2是发行库有上述流程，3是储备与发行库都有上述流程
                                                //is_fxjh：0需求库，1发行库，3，储备库
                                                //is_zxzqxt：湖北专项个性参数，is_zxzq==1 专项菜单
                                                //sys_right_model:1新工作流，2：老工作流
                                                //因为河北没有三方机构上传附件，故隐藏河北三方机构上传附件
                                                store: lssws_store,
                                                allowBlank: true
                                            };
                                            fjGrid.dockedItems.items[1].insert(KJSWSCombobox, LSSWSCombobox);
                                        }
                                        //根据债券类型重新加载批次
                                        BATCH_YEAR = self.next("[name=BILL_YEAR]") == null ? BATCH_YEAR : self.next("[name=BILL_YEAR]").getValue();
                                        BATCH_BOND_TYPE_ID = newValue;

                                        sbpc_store.proxy.extraParams['BATCH_YEAR'] = BATCH_YEAR;
                                        sbpc_store.proxy.extraParams['BOND_TYPE'] = isNull(BATCH_BOND_TYPE_ID) ? "" : BATCH_BOND_TYPE_ID.substr(0, 2);
                                        sbpc_store.proxy.extraParams['AD_CODE'] = AD_CODE;
                                        sbpc_store.proxy.extraParams['is_fxjh'] = is_fxjh;
                                        sbpc_store.proxy.extraParams['TYPE'] = 'jhtb';
                                        sbpc_store.load();

                                        //进行后续操作
                                        panel.add(fjGrid);
                                        Ext.MessageBox.hide();
                                    }, "json");
                                    //}
                                    //若是专项债券系统才执行
                                    //if(is_zxzqxt=='1'&&is_zxzq=='1'){
                                    //20210618 zhuangrx 选择资金投向领域时债券类型不加载专家评分框
                                    //HAVE_SFJG：0是项目库所有流程都没有三方机构与专家评审流程，1是储备库有上述流程，2是发行库有上述流程，3是储备与发行库都有上述流程
                                    //is_fxjh：0需求库，1发行库，3，储备库
                                    //zjpslx:txly 根据资金投向领域进行专家评审，zqlx 根据债券类型进行专家评审
                                    //因为目前只有河南有资金投向领域进行专家评审，并没有三方机构上传附件 ，所以zjpslx:txly 时不进行三方机构上传附件
                                    if (((HAVE_SFJG == '1' && is_fxjh == '3') || (HAVE_SFJG == '2' && is_fxjh == '1')
                                        || (HAVE_SFJG == '3' && (is_fxjh == '1' || is_fxjh == '3'))) && zjpslx == 'zqlx') {
                                        //项目评分页签相关内容
                                        //获取panel，并移除grid
                                        var panel2 = Ext.ComponentQuery.query('panel#xmPfxxPanel')[0];
                                        panel2.removeAll(true);
                                        //构建项目评分grid，未格式化
                                        var grid = initXekXMPfxxGrid(newValue, window_zqxxtb.JH_ID);
                                        //添加到panel中，触发panel的afterlayout事件
                                        panel2.add(grid);
                                    }
                                }
                                // 2020年06月30日 财政部下达抗疫国债 增加
                                if (is_fxjh == 1 && newValue != '01') {
                                    /* 发行项目遴选申报时：如果选择的类型是专项类型的债券则置灰新增赤字资金
                                     */
                                    var form = this.up('form').getForm();
                                    form.findField('XZCZAP_AMT').setReadOnly(true);
                                    form.findField('XZCZAP_AMT').allowBlank = false;
                                    form.findField('XZCZAP_AMT').setFieldStyle('background:#E6E6E6');
                                    form.findField('XZCZAP_AMT').setValue(0);
                                    var SBBATCH_NO = form.findField('SBBATCH_NO').value;
                                    if (SBBATCH_NO == '98202002') {
                                        Ext.Msg.alert("提示", "债券类型为专项债券类型时不能选择“98202002 新增财政赤字直达基层申报批次”！");
                                        form.findField('SBBATCH_NO').setValue('');
                                        return;
                                    }
                                } else {
                                    var form = this.up('form').getForm();
                                    form.findField('XZCZAP_AMT').setReadOnly(false);
                                    form.findField('XZCZAP_AMT').allowBlank = true;
                                    form.findField('XZCZAP_AMT').setFieldStyle('background:#FFFFFF');
                                    form.findField('XZCZAP_AMT').setValue(0);
                                }
                                var form = this.up('form').getForm();
                                var IS_XMZBJ = form.findField('IS_XMZBJ').value;
                                if (newValue != '01') {
                                    //专项债券是否为项目资本金校验
                                    form.findField('IS_XMZBJ').setReadOnly(false);
                                    form.findField('IS_XMZBJ').setFieldStyle('background:#FFFFFF');

                                    /*
                                     *用于项目资本金校验
                                     */
                                    if (form.findField('IS_XMZBJ').getValue() == 0) {//是否为项目资本金为否时 资本金金额为0 置灰
                                        form.findField('ZBJ_AMT').setReadOnly(true);
                                        form.findField('ZBJ_AMT').setFieldStyle('background:#FFFFFF');
                                        form.findField('ZBJ_AMT').setValue(0);
                                    }
                                    form.findField('ZBJ_AMT').setReadOnly(false);
                                    if (IS_XMZBJ == '1') {//是项目资本金
                                        form.findField('ZBJ_AMT').allowBlank = false;
                                        form.findField('ZBJ_AMT').setFieldStyle('background:#FFFFFF');
                                        form.findField('IS_XMZBJ').setReadOnly(false);
                                    } else if (IS_XMZBJ == '0') {//不是项目资本金
                                        form.findField('ZBJ_AMT').allowBlank = true;
                                        form.findField('ZBJ_AMT').setFieldStyle('background:#E6E6E6');
                                    }
                                } else {
                                    //一般债券
                                    form.findField('IS_XMZBJ').setValue(0);
                                    form.findField('IS_XMZBJ').setReadOnly(true);
                                    form.findField('IS_XMZBJ').setFieldStyle('background:#E6E6E6');
                                    form.findField('ZBJ_AMT').setReadOnly(true);
                                    form.findField('ZBJ_AMT').setFieldStyle('background:#E6E6E6');
                                    form.findField('ZBJ_AMT').setValue(0);
                                    if (IS_XMZBJ == '1') {//是项目资本金
                                        form.findField('ZBJ_AMT').allowBlank = false;
                                    } else if (IS_XMZBJ == '0') {//不是项目资本金
                                        form.findField('ZBJ_AMT').allowBlank = true;
                                    }
                                }
                                //2020121414_zhuangrx_中小银行时经济分类支出分类不是必录
                                if (newValue == '020204') {
                                    form.findField('GNFL_ID').allowBlank = true;
                                    form.findField('GNFL_ID').setFieldLabel('支出功能分类');
                                    form.findField('JJFL_ID').allowBlank = true;
                                    form.findField('JJFL_ID').setFieldLabel('支出经济分类');
                                }
                                //20210113_zhuangrx_安徽流程调整，发行库放开债券期限和类型
                                if (is_fxjh == 1) {
                                    if (newValue == null || newValue == '' || newValue == 'undefined') {
                                        form.findField('BOND_TYPE_ID').setReadOnly(false);
                                        form.findField('BOND_TYPE_ID').setFieldStyle('background:#FFFFFF');
                                        form.findField('ZQQX_ID').setReadOnly(false);
                                        form.findField('ZQQX_ID').setFieldStyle('background:#FFFFFF');
                                        form.findField('BOND_TYPE_ID').store = DebtEleTreeStoreDB('DEBT_ZQLB', {condition: " AND CODE NOT LIKE '0201%' AND CODE LIKE '01%' "});
                                        form.findField('FP_AMT').setReadOnly(false);
                                        form.findField('FP_AMT').setFieldStyle('background:#FFFFFF');
                                    }
                                }
                                // 绩效管理页签
                                addOrRemoveJxglTab(newValue);
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "ZQQX_ID",
                        store: DebtEleStoreDB("DEBT_ZQQX"),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>债券期限',
                        editable: false,
                        allowBlank: false,
                        readOnly: (is_fxjh == '1' && sysAdcode != '34') ? true : false,
                        fieldStyle: (is_fxjh == '1' && sysAdcode != '34') ? 'background:#E6E6E6' : 'background:#FFFFFF'
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
                        readOnly: true,
                        allowBlank: false,
                        listeners: {
                            change: function (self, newValue, oldValue) {
                                if (newValue == null) {
                                    var form = this.up('form').getForm();
                                    form.findField('FILTER_STATUS_ID').setValue('备选');
                                }
                            }
                        },
                    },
                    {
                        fieldLabel: '申请金额',
                        name: 'FP_AMT',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 2,
                        maxValue: 9999999999,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        hideTrigger: true,
                        hidden: is_fdq == 0 && (is_fxjh != 3) ? false : true,//辅导期中隐藏
                        fieldStyle: (is_fxjh == '1' && sysAdcode != '34') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        readOnly: (is_fxjh == '1' && sysAdcode != '34') ? true : false
                    },
                    {
                        fieldLabel: '控制数',
                        name: 'KZS_AMT',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        hidden: is_zxzqxt == '1' && is_zxzq != '2' && is_fxjh == '3' && SYS_ZXZQXT_KZS_CHECK == '1' ? false : true,//湖北专项债券系统使用(在储备库显示)
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true,
                        listeners: {
                            afterrender: function (self, opt) {
                                reloadKzs(self);
                            }
                        }
                    },
                    {
                        fieldLabel: is_fdq == 0 ? (is_fxjh == '1' || is_fxjh == '4' ? '<span class="required">✶</span>本次发行金额' : '<span class="required">✶</span>申请金额')
                            : is_fxjh == '1' || is_fxjh == '4' ? '<span class="required">✶</span>本次发行金额' : '<span class="required">✶</span>申请金额',
                        name: 'APPLY_AMOUNT1',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 2,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        allowBlank: false,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();

                                var APPLY_AMOUNT1 = form.findField('APPLY_AMOUNT1').value;
                                var APPLY_AMOUNT2 = form.findField('APPLY_AMOUNT2').value;
                                var APPLY_AMOUNT3 = form.findField('APPLY_AMOUNT3').value;

                                var APPLY_AMOUNT_TOTAL = form.findField('APPLY_AMOUNT_TOTAL');
                                APPLY_AMOUNT_TOTAL.setValue(APPLY_AMOUNT1 + APPLY_AMOUNT2 + APPLY_AMOUNT3);
                            }
                        }
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
                        displayField: 'name',
                        valueField: 'id',
                        minValue: 0,
                        value: 0,
                        store: DebtEleStore(s_is_xmzbj),
                        allowBlank: false,
                        editable: false,
                        readOnly: (is_fxjh == '1') ? true : false,
                        fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        listeners: {
                            change: function (self, newvalue) {
                                if (!self.getValue()) {
                                    IS_XMZBJ = self.up('form').down('combobox[name="IS_XMZBJ"]').getValue();
                                    self.up('form').down('combobox[name="IS_XMZBJ"]').setValue(IS_XMZBJ);
                                    return IS_XMZBJ;
                                }
                                var form = this.up('form').getForm();
                                var ZBJ_AMT = this.up('form').getForm().findField('ZBJ_AMT');
                                var BOND_TYPE_ID = form.findField('BOND_TYPE_ID').value;
                                if (newvalue == '1') {
                                    ZBJ_AMT.allowBlank = false;
                                    ZBJ_AMT.setFieldLabel('<span class="required">✶</span>债券用于项目资本金金额');
                                    form.findField('ZBJ_AMT').setFieldStyle('background:#FFFFFF');
                                    form.findField('ZBJ_AMT').setReadOnly(false);

                                } else {
                                    form.findField('ZBJ_AMT').allowBlank = true;
                                    form.findField('ZBJ_AMT').setReadOnly(true);
                                    form.findField('ZBJ_AMT').setFieldStyle('background:#E6E6E6');
                                    form.findField('ZBJ_AMT').setValue(0);
                                    ZBJ_AMT.setFieldLabel('债券用于项目资本金金额');
                                }
                                if (newvalue == '0') {
                                    form.findField('ZBJ_AMT').allowBlank = true;
                                    form.findField('ZBJ_AMT').setReadOnly(true);
                                    form.findField('ZBJ_AMT').setFieldStyle('background:#E6E6E6');
                                    form.findField('ZBJ_AMT').setValue(0);
                                }

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
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        readOnly: (is_fxjh == '1') ? true : false,
                        fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        //  allowBlank: true,
                        listeners: {
                            'change': function () {

                            }
                        }
                    },
                    {
                        fieldLabel: '其中：新增赤字安排资金',
                        name: 'XZCZAP_AMT',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 2,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        allowBlank: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        hidden: is_fxjh == 1 ? false : true,
                        listeners: {
                            'change': function (self, newValue, oldValue, e) {
                                /*     if (is_fxjh == 1) {
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
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        hideTrigger: true,
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        hidden: is_zxzqxt == 1 ? false : true,
                        readOnly: (is_fxjh == '1') ? true : false,
                        fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var APPLY_AMOUNT1 = form.findField('APPLY_AMOUNT1').value;
                                var APPLY_AMOUNT2 = form.findField('APPLY_AMOUNT2').value;
                                var APPLY_AMOUNT3 = form.findField('APPLY_AMOUNT3').value;

                                var APPLY_AMOUNT_TOTAL = form.findField('APPLY_AMOUNT_TOTAL');
                                APPLY_AMOUNT_TOTAL.setValue(APPLY_AMOUNT1 + APPLY_AMOUNT2 + APPLY_AMOUNT3);
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
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        decimalPrecision: 4,
                        hidden: is_zxzqxt == 1 ? false : true,
                        readOnly: (is_fxjh == '1') ? true : false,
                        fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var APPLY_AMOUNT1 = form.findField('APPLY_AMOUNT1').value;
                                var APPLY_AMOUNT2 = form.findField('APPLY_AMOUNT2').value;
                                var APPLY_AMOUNT3 = form.findField('APPLY_AMOUNT3').value;

                                var APPLY_AMOUNT_TOTAL = form.findField('APPLY_AMOUNT_TOTAL');
                                APPLY_AMOUNT_TOTAL.setValue(APPLY_AMOUNT1 + APPLY_AMOUNT2 + APPLY_AMOUNT3);
                            }
                        }
                    },
                    {
                        fieldLabel: '项目总申请金额',
                        name: 'ZJE',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        maxValue: 9999999999,
                        hideTrigger: true,
                        hidden: true,
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true
                    }, {
                        fieldLabel: '项目已使用金额',
                        name: 'YSY',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
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
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
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
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
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
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        editable: false, //禁用编辑
                        selectModel: "leaf",
                        hidden: true,
                        allowBlank: true/*,
                        listeners: {
                            afterRender: function (self,opts) {
                                var form = self.up('form').getForm();
                                var year = form.findField('BILL_YEAR').value;
                                var condition_str = year <= 2017 ? " <= '2017' " : " = '"+year+"' ";
                                self.store.proxy.url = DebtEleTreeStoreDB('DEBT_ZWSRKM').proxy.url;
                                self.store.proxy.extraParams = {debtEle:'DEBT_ZWSRKM',condition: " and (code like '1050402%' or code like '1101102%') and year "+ condition_str};
                                self.store.loadPage(1);
                            }
                        }*/
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
                        fieldLabel: '申请总金额',
                        name: 'APPLY_AMOUNT_TOTAL',
                        xtype: 'numberFieldFormat',
                        decimalPrecision: 4,
                        hideTrigger: true,
                        allowBlank: false,
                        fieldStyle: 'background:#E6E6E6',
                        maxValue: 9999999999,
                        readOnly: true,
                        hidden: is_zxzqxt == 1 ? false : true
                    }, {
                        fieldLabel: '<span class="required">✶</span>申报批次',
                        name: 'SBBATCH_NO',
                        xtype: 'treecombobox',
                        displayField: 'text',
                        valueField: 'id',
                        allowBlank: ((is_fxjh == 1 || is_fxjh == 4) && !(sys_right_model == '1' && is_zxzqxt == 1)) || (is_fxjh == 3 && GxdzUrlParam == sysAdcode) ? false : true,// 只在区划为13或者42时申报批次为必录
                        editable: false,
                        hidden: ((is_fxjh == 1 || is_fxjh == 4) && !(sys_right_model == '1' && is_zxzqxt == 1)) || (is_fxjh == 3 && GxdzUrlParam == sysAdcode) ? false : true,// 只在区划为13或者42时申报批次不隐藏
                        /*store:is_fxjh==3?sbpc_store:DebtEleTreeStoreDB('DEBT_FXPC',{condition: " and year = '"+BATCH_YEAR+"' and (EXTEND1 = '" +"01"+
                        BATCH_BOND_TYPE_ID.substr(0, 2) +"' OR EXTEND1 IS NULL) " +
                        " and not exists (select * from DEBT_T_ZQGL_BILL_XZHZ where AD_CODE='"+AD_CODE+"'"+
                        " and IS_FXJH = '"+is_fxjh+"' and BATCH_NO = GUID) " +
                        " and (EXTEND2 IS NULL OR EXTEND2 = '"+is_fxjh+"') "})*/
                        store: sbpc_store,
                        listeners: {
                            'change': function (self, newValue, oldValue, e) {
                                // 2020年06月30日 财政部下达抗疫国债 增加
                                if (is_fxjh == 1 && (newValue == '98202002')) {
                                    /* 发行项目遴选申报时：如果选择的批次为 限额批次（982020001	直达市县基层限额批次）和 申报批次（98202002	新增财政赤字直达基层申报批次）
                                       则必须录入 新增赤字安排资金 和项目承建单位信息
                                     */
                                    var form = this.up('form').getForm();
                                    form.findField('XZCZAP_AMT').setFieldLabel('<span class="required">✶</span>其中：新增赤字安排资金');
                                    form.findField('XZCZAP_AMT').allowBlank = false;
                                    var sbpc_type_id = form.findField('BOND_TYPE_ID').value;
                                    if (sbpc_type_id != '01') {
                                        Ext.Msg.alert("提示", "债券类型为专项债券类型时不能选择“98202002 新增财政赤字直达基层申报批次”！");
                                        self.setValue('');
                                        return;
                                    }
                                } else {
                                    var form = this.up('form').getForm();
                                    form.findField('XZCZAP_AMT').setFieldLabel('其中：新增赤字安排资金');
                                    form.findField('XZCZAP_AMT').allowBlank = true;
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
                        //readOnly:  (is_fxjh == '1') ? true : false,
                        // fieldStyle:(is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        listeners: {
                            /*afterRender: function (self,opts) {
                                var form = self.up('form').getForm();
                                var year = form.findField('BILL_YEAR').value;
                                var condition_str = year <= 2017 ? " <= '2017' " : " = '"+year+"' ";
                                self.store.proxy.url = DebtEleTreeStoreDB('EXPFUNC').proxy.url;
                                self.store.proxy.extraParams = {debtEle:'EXPFUNC',condition: " and year "+ condition_str};
                                self.store.loadPage(1);
                            }*/
                        }
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
                        // readOnly:  (is_fxjh == '1') ? true : false,
                        // fieldStyle:(is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        listeners: {
                            /*afterRender: function (self,opts) {
                                var form = self.up('form').getForm();
                                var year = form.findField('BILL_YEAR').value;
                                var condition_str = year <= 2017 ? " <= '2017' " : " = '"+year+"' ";
                                self.store.proxy.url = DebtEleTreeStoreDB('EXPECO').proxy.url;
                                self.store.proxy.extraParams = {debtEle:'EXPECO',condition: " and year "+ condition_str};
                                self.store.loadPage(1);
                            }*/
                        }
                    }, {
                        fieldLabel: '<span class="required">✶</span>是否续发行',
                        name: 'IS_XFX',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        allowBlank: (is_zxzqxt == '1' && is_zxzq != '2' && is_fxjh == 3) ? false : true,
                        editable: false,
                        hidden: (is_zxzqxt == '1' && is_zxzq != '2' && is_fxjh == 3) ? false : true,
                        readOnly: (is_fxjh == '1') ? true : false,
                        fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        store: DebtEleStore(is_xfx_store)
                    }, {
                        fieldLabel: '<span class="required">✶</span>是否调整',
                        name: 'IS_TZ',
                        xtype: 'combobox',
                        displayField: 'name',
                        valueField: 'id',
                        allowBlank: (is_zxzqxt == '1' && is_zxzq != '2' && is_fxjh == 3) ? false : true,
                        editable: false,
                        readOnly: (is_fxjh == '1') ? true : false,
                        fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        hidden: (is_zxzqxt == '1' && is_zxzq != '2' && is_fxjh == 3) ? false : true,
                        store: DebtEleStore(is_tz_json)
                    },
                    {
                        fieldLabel: '项目编号',
                        name: 'CBXMSB_NO',
                        maxLength: 38,
                        hidden: GxdzUrlParam == '34' ? false : true,
                        maxLengthText: '输入编码过长，只能输入38位！'
                    }, {
                        fieldLabel: '备注',
                        name: 'REMARK',
                        xtype: 'textfield',
                        readOnly: (is_fxjh == '1') ? true : false,
                        fieldStyle: (is_fxjh == '1') ? 'background:#E6E6E6' : 'background:#FFFFFF',
                        columnWidth: (is_fxjh == '1' || is_fxjh == '4' || is_fxjh == '3') ? (is_fdq == 0 && (is_fxjh == '1') ? .999 : 0.666) : .999
                    }
                ]
            }, {
                xtype: 'fieldset',
                title: '申报记录',
                anchor: '100% -170',
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
 * 初始化右侧主表格
 */
function initContentXeGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "XE_ID", width: 100, type: "string", text: "ID", hidden: true},
        {dataIndex: "SET_YEAR", width: 80, type: "string", text: "年度"},
        {dataIndex: "AD_CODE", width: 100, type: "string", text: "区划编码", hidden: true},
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "区划名称"},
        {
            dataIndex: "XZYB",
            width: 150,
            type: "float",/*hidden:is_zxzqxt=='1'&&is_zxzq=='1'?true:false,*/
            text: "新增一般债券限额(万元)",
            columns: [
                {
                    dataIndex: "XZ_YBZQ_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_YB_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_YB_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX",
            width: 150,
            type: "float",
            text: "新增专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? true : false,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_TC",
            width: 150,
            type: "float",
            text: "新增土地储备专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_TC_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_TC_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_TC_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_GL",
            width: 150,
            type: "float",
            text: "新增收费公路专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_GL_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_GL_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_GL_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_PG",
            width: 150,
            type: "float",
            text: "新增棚改专项债券限额(万元)",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_PG_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_PG_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_PG_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "XZZX_QT",
            width: 150,
            type: "float",
            text: "新增其他专项债券限额（万元）",
            hidden: DEBT_ZXXEKZFS == '1' ? false : true,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_QT_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_QT_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_QT_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value / 10000, '0,000.00####');
                    }
                }
            ]
        },
        {
            dataIndex: "ZXYH_TC",
            width: 150,
            type: "float",
            text: "中小银行专项债券限额(万元)",
            hidden: have_fxhj == '0' ? true : false,
            columns: [
                {
                    dataIndex: "XZ_ZXZQ_ZXYH_AMT",
                    width: 150,
                    type: "float",
                    text: "合计",
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    dataIndex: "YSY_ZX_ZXYH_AMT",
                    width: 180,
                    type: "float",
                    text: "已使用限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                },
                {
                    dataIndex: "SY_ZX_ZXYH_AMT",
                    width: 180,
                    type: "float",
                    text: "剩余限额(万元)",
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    },
                    renderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00####');
                    }
                }
            ]
        }
    ];
    return DSYGrid.createGrid({
        itemId: 'contentXEGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        hidden: ((is_fxjh != '1' && is_fxjh != '3') || is_scfjgn) ? true : false,
        border: false,
        autoLoad: false,
        height: 150,
        width: '100%',
        dataUrl: '/getDqxeData.action',
        params: {
            SET_YEAR: '',
            BUSI_TYPE: '0',
            is_tb: '1'
        },
        pageConfig: {
            enablePage: false
        },
        tbar: [
            {
                fieldLabel: '年度',
                xtype: 'combobox',
                name: 'SET_YEAR',
                value: new Date().getUTCFullYear(),
                width: 145,
                editable: false,
                labelWidth: 30,//控件默认标签宽度
                labelAlign: 'right',//控件默认标签对齐方式
                displayField: 'name',
                valueField: 'code',
                allowBlank: false,
                // store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '" + (parseInt(SET_YEAR) - 1) + "'"}),
                //store: DebtEleStore(json_debt_year),
                store: DebtEleStore(getYearList({start: -5, end: 5})),
                listeners: {
                    change: function (self, newValue) {
                        SET_YEAR = newValue;
                        reloadGrid();
                    }
                }
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
                        // if (context.field == 'PAY_XMCJSR_AMT' || context.field == 'QZ_SOLVE_EMPLOYMENT' || context.field == 'QZ_PAY_GRLW_AMT') {
                        //     if (context.record.get('QZ_SOLVE_EMPLOYMENT')+ context.record.get('QZ_PAY_GRLW_AMT') > context.record.get('PAY_XMCJSR_AMT')) {
                        //         Ext.MessageBox.alert('提示', '“最终支付给个人的劳务收入”与“解决就业人数”的和不能超过“最终支付给企业的项目承建收入”');
                        //         return false;
                        //     }
                        // }
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
                        fieldLabel: '项目资本金总额',
                        name: 'ZBJ_AMT',
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        decimalPrecision: 2,
                        value: 0,
                        listeners: {
                            'change': function () {
                                if (is_fxjh != '5') {
                                    /*             //initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
                                             var form = this.up('form').getForm();
                                             var ZBJ_AMT = form.findField('ZBJ_AMT').getValue() ;
                                             var XMZGS_AMT =form.findField('XMZGS_AMT').value;
                                                 if(ZBJ_AMT - XMZGS_AMT > 0.0000001){
                                                 Ext.Msg.alert("提示","项目资本金总额不能大于项目总概算！") ;
                                                form.findField('ZBJ_AMT').setValue(0);
                                                 return;
                                             }*/
                                } else {
                                    initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
                                    initWindow_zqxxtb_contentForm_tab_csqk_refreshForm();
                                }
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
                                var form = this.up('form').getForm();
                                var ZBJ_AMT = form.findField('ZBJ_AMT').getValue();
                                var ZBJ_YS_AMT = form.findField('ZBJ_YS_AMT').getValue();
                                var ZBJ_ZQ_AMT = form.findField('ZBJ_ZQ_AMT').getValue();
                                if ((ZBJ_ZQ_AMT + ZBJ_YS_AMT) - ZBJ_AMT > 0.0000001) {
                                    Ext.Msg.alert("提示", "其中财政预算安排资金与专项债券安排资金之和不能大于项目资本金总额！");
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
                        minValue: 0,
                        decimalPrecision: 2,
                        value: 0,
                        listeners: {
                            'change': function () {
                                var form = this.up('form').getForm();
                                var ZBJ_AMT = form.findField('ZBJ_AMT').getValue();
                                var ZBJ_YS_AMT = form.findField('ZBJ_YS_AMT').getValue();
                                var ZBJ_ZQ_AMT = form.findField('ZBJ_ZQ_AMT').getValue();
                                if ((ZBJ_ZQ_AMT + ZBJ_YS_AMT) - ZBJ_AMT > 0.0000001) {
                                    Ext.Msg.alert("提示", "其中财政预算安排资金与专项债券安排资金之和不能大于项目资本金总额！");
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
                    editor: {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    },
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
                    editor: {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    },
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
            text: "债券融资资金", dataIndex: "RZZJ", type: "float",
            columns: [
                {
                    text: "计划投资", dataIndex: "RZZJ_PLAN_AMT", type: "float", width: 160,
                    editor: {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    },
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
                    text: "小计", dataIndex: "RZZJ_XJ", type: "float", tdCls: 'grid-cell-unedit', hidden: true,
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
                    editor: is_xz ? {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    } : '',
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
                    editor: is_xz ? {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    } : '',
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
                    editor: is_xz ? {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    } : '',
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
                    editor: is_xz ? {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    } : '',
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
            editor: is_xz ? {
                xtype: 'numberFieldFormat',
                hideTrigger: true,
                minValue: 0,
                keyNavEnabled: false,
                mouseWheelEnabled: false
            } : '',
            editable: false,
            columns: [
                {
                    dataIndex: "SCRZ_PLAN_AMT", type: "float", text: "计划投资", width: 160,
                    editor: {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    },
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
                    editor: {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    },
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
                    editor: {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        minValue: 0,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false
                    },
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
                    'beforeedit': function (editor, context) {
                        /*  if ((connNdjh == '1' || connNdjh == 1 || connZwxx == '1' || connZwxx == 1)) {//被引用项目
                              var current_year = new Date().getFullYear();
                              var check_year = current_year-1;
                              var plan_id = context.record.get('PLAN_ID');
                              var grid_year = context.record.get('ND');
                              if (grid_year <= check_year && plan_id != null && plan_id && plan_id != '') {
                                  // 如果 实际到位资金 为空或者为0 则允许用户编制
                                  if (!(context.field == 'SJBZ_ACTUAL_AMT' && context.record.get('SJBZ_ACTUAL_AMT') <= 0) && // 上级补助资金
                                      !(context.field == 'CZYS_ACTUAL_AMT' && context.record.get('CZYS_ACTUAL_AMT') <= 0) && // 本级财政预算资金
                                      !(context.field == 'RZZJ_ACTUAL_AMT' && context.record.get('RZZJ_ACTUAL_AMT') <= 0) && // 融资资金
                                      !(context.field == 'DWZC_ACTUAL_AMT' && context.record.get('DWZC_ACTUAL_AMT') <= 0) && // 单位自筹资金
                                      !(context.field == 'XY_AMT_RMB' && context.record.get('XY_AMT_RMB') <= 0) && // 本级财政预算资金
                                      !(context.field == 'QT_ACTUAL_AMT' && context.record.get('QT_ACTUAL_AMT') <= 0)) { // 其他资金
                                      Ext.MessageBox.alert('提示', '该项目已经申报，无法修改或删除'+check_year+'年及之前的明细投资计划！');
                                      return false;
                                  }
                              }
                          }*/
                    },
                    /*  validateedit : function(editor, context) {
                          if (context.field=='ND'&&(connNdjh == '1' || connNdjh == 1 || connZwxx == '1' || connZwxx == 1)) {//被引用项目
                              var current_year = new Date().getFullYear();
                              var check_year = current_year-1;
                              var plan_id = context.record.get('PLAN_ID');
                              if (context.value <= check_year && plan_id != null && plan_id && plan_id != '') {
                                  Ext.MessageBox.alert('提示', '该项目已经申报，无法修改或删除'+check_year+'年及之前的明细投资计划！');
                                  return false;
                              }
                          };
                      },*/
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
                        //自动计算融资资金中债券资金到位情况
                        /*if (context.field == 'RZZJ_YBZQ_AMT' || context.field == 'RZZJ_ZXZQ_AMT' || context.field == 'RZZJ_ZHZQ_AMT') {
                        	var RZZJ_ACTUAL_AMT = context.record.get("RZZJ_ACTUAL_AMT");
                            var RZZJ_YBZQ_AMT = (context.field == 'RZZJ_YBZQ_AMT') ? context.value : context.record.get("RZZJ_YBZQ_AMT");
                            var RZZJ_ZXZQ_AMT = (context.field == 'RZZJ_ZXZQ_AMT') ? context.value : context.record.get("RZZJ_ZXZQ_AMT");
                            var RZZJ_ZHZQ_AMT = (context.field == 'RZZJ_ZHZQ_AMT') ? context.value : context.record.get("RZZJ_ZHZQ_AMT");
                            var RZZJ_XJ = new Object(RZZJ_YBZQ_AMT + RZZJ_ZXZQ_AMT + RZZJ_ZHZQ_AMT);
                            if (RZZJ_ACTUAL_AMT < RZZJ_XJ) {
                                Ext.toast({
                                    html: "债券到位资金不应大于实际到位融资资金！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                            context.record.set('RZZJ_XJ', RZZJ_XJ);
                        }*/
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
                        initWindow_zqxxtb_contentForm_tab_jbqk_refreshForm();
                        initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
                        initWindow_zqxxtb_contentForm_tab_csqk_refreshForm();
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

//加载基础库情况表单到初审表中
function initWindow_zqxxtb_contentForm_tab_jbqk_refreshForm() {
    //获取基本情况
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
    //获取初审情况表
    var csqkForm = Ext.ComponentQuery.query('form[name="csqkForm"]')[0];
    //获取投资计划grid
    var xmsyStore = DSYGrid.getGrid("tzjhGrid").getStore();
    //获取收支平衡form
    var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
    var xm_name = jbqkForm.down('textfield[name="XM_NAME"]').getValue();//项目名称
    var BUILD_CONTENT = jbqkForm.down('textarea[name="BUILD_CONTENT"]').getValue();//项目实施内容
    var ZJTXLY_ID = jbqkForm.down('treecombobox[name="ZJTXLY_ID"]').getValue();//资金投向领域
    var SP_LEVEL_ID = jbqkForm.down('combobox[name="SP_LEVEL_ID"]').getValue();//项目级次
    var IS_FGW_XM = jbqkForm.down('combobox[name="IS_FGW_XM"]').getValue();//是否重大项目库
    var XMXZ_ID = jbqkForm.down('treecombobox[name="XMXZ_ID"]').getValue();//项目性质
    if (XMXZ_ID == '010101') {
        XMXZ_ID = '否';
    } else if (XMXZ_ID == '010102') {
        XMXZ_ID = '是';
    }
    var jsnx = xmsyStore;//项目建设期
    var arr = [];
    //循环投资计划年度，取最大值
    if (xmsyStore.data.items.length > 0) {
        for (var i = 0; i < xmsyStore.data.items.length; i++) {
            arr.push(xmsyStore.data.items[i].data.ND);
        }
        arr.sort(function (a, b) {
            return a - b;
        });
        var min = arr[0];
        var max = arr[arr.length - 1];
        jsnx = min + '年-' + max + '年';
        csqkForm.getForm().findField('JSNX').setValue(jsnx);
    }
    var XM_USED_LIMIT;
    var XM_USED_DATE = Ext.util.Format.date(xmsyForm.down('datefield[name="XM_USED_DATE"]', 'Y-m-d').getValue(), 'Y');
    var LIMIT = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();
    if (XM_USED_DATE != '' || LIMIT != null) {
        XM_USED_LIMIT = XM_USED_DATE + '年-' + (parseInt(XM_USED_DATE) + parseInt(LIMIT)).toString() + '年';
        csqkForm.getForm().findField('XM_USED_LIMIT').setValue(XM_USED_LIMIT);//项目运营期
    }
    var BUILD_STATUS_ID = jbqkForm.down('combobox[name="BUILD_STATUS_ID"]').getValue();//项目进度情况
    var XMSY_YCYJ = jbqkForm.down('textarea[name="XMSY_YCYJ"]').getValue();//项目预期收益来源
    //赋值
    csqkForm.getForm().findField('XM_NAME').setValue(xm_name);
    csqkForm.getForm().findField('BUILD_CONTENT').setValue(BUILD_CONTENT);
    csqkForm.getForm().findField('ZJTXLY_ID').setValue(ZJTXLY_ID);
    csqkForm.getForm().findField('SP_LEVEL_ID').setValue(SP_LEVEL_ID);
    csqkForm.getForm().findField('IS_FGW_XM').setValue(IS_FGW_XM);
    csqkForm.getForm().findField('XMXZ_ID').setValue(XMXZ_ID);
    csqkForm.getForm().findField('BUILD_STATUS_ID').setValue(BUILD_STATUS_ID);
    csqkForm.getForm().findField('XMSY_YCYJ').setValue(XMSY_YCYJ);

}

//加载初审情况表单
function initWindow_zqxxtb_contentForm_tab_csqk_refreshForm() {
    var tzjhStore = DSYGrid.getGrid("tzjhGrid").getStore();
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    var csqkForm = Ext.ComponentQuery.query('form[name="csqkForm"]')[0];
    var zbj_amt = csqkForm.down('numberFieldFormat[name="ZBJ_AMT1"]').getValue();
    var XMZGS_AMT = csqkForm.getForm().findField("XMZGS_AMT").getValue();//总投资
    var APPLY_AMOUNT1 = csqkForm.down('numberFieldFormat[name="APPLY_AMOUNT1"]').getValue();
    var csqkForm = Ext.ComponentQuery.query('form[name="csqkForm"]')[0];
    var cs_zbj = csqkForm.down('numberFieldFormat[name="ZBJ_AMT"]').getValue();
    var ZWRZ_AMT = XMZGS_AMT - zbj_amt - (APPLY_AMOUNT1 - cs_zbj);//初审表其他债务融资
    csqkForm.getForm().findField('ZWRZ_AMT').setValue(ZWRZ_AMT);

}

/**
 * 刷新投资计划Form信息
 */
function initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm() {
    var xmsyStore = DSYGrid.getGrid("tzjhGrid").getStore();
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    var csqkForm = Ext.ComponentQuery.query('form[name="csqkForm"]')[0];
    tzjhForm.getForm().findField('XMZGS_AMT').setValue(xmsyStore.sum('ZTZ_PLAN_AMT'));
    var zbj_amt = tzjhForm.down('numberFieldFormat[name="ZBJ_AMT"]').getValue();
    csqkForm.getForm().findField('ZBJ_AMT1').setValue(zbj_amt);
    csqkForm.getForm().findField('XMZGS_AMT').setValue(xmsyStore.sum('ZTZ_PLAN_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="LJWCTZ_AMT"]')[0].setValue(xmsyStore.sum('ZTZ_ACTUAL_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="YRZZJ"]')[0].setValue(xmsyStore.sum('RZZJ_ACTUAL_AMT') + xmsyStore.sum('XY_AMT_RMB'));
    Ext.ComponentQuery.query('numberFieldFormat[name="ZQRZ"]')[0].setValue(xmsyStore.sum('RZZJ_XJ'));
    Ext.ComponentQuery.query('numberFieldFormat[name="SCHRZ_AMT"]')[0].setValue(xmsyStore.sum('SCRZ_PLAN_AMT'));
}

/**
 * 初始化债券信息填报弹出窗口中的收支平衡标签页
 */
function initWindow_zqxxtb_contentForm_tab_xmsy() {
    return Ext.create('Ext.form.Panel', {
        name: 'xmsyForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        padding: '0 10 0 10',
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldset',
                title: '预计总体情况',
                layout: 'column',
                defaultType: 'textfield',
                anchor: '100%',
                collapsible: false,
                fieldDefaults: {
                    labelWidth: 160,
                    columnWidth: .33,
                    margin: '0 0 5 20'
                },
                items: [
                    {
                        xtype: 'numberFieldFormat',
                        fieldLabel: '项目预计总收入',
                        name: 'XMZTR_AMT',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: 'numberFieldFormat',
                        fieldLabel: '项目预算总成本',
                        name: 'XMZCB_AMT',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZFXJJKM_ID",
                        store: DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: " and code like '0102%' "}),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '项目对应的政府性基金科目',
                        editable: false, //禁用编辑
                        selectModel: "leaf"
                    },
                    {
                        xtype: "datefield",
                        fieldLabel: '项目投入使用日期',
                        name: 'XM_USED_DATE',
                        format: 'Y-m-d',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var lx_year = Ext.ComponentQuery.query('combobox[name="LX_YEAR"]')[0].getValue();
                                newValue = format(newValue, 'yyyy');
                                if (newValue < lx_year) {
                                    Ext.MessageBox.alert('提示', '项目投入使用日期不可小于立项年度');
                                    self.setValue('');
                                    return;
                                }
                            }
                        }
                    },
                    {
                        xtype: 'numberFieldFormat',
                        fieldLabel: '项目运营期限(年)',
                        name: 'XM_USED_LIMIT',
                        hideTrigger: true,
                        mouseWheelEnabled: false,
                        maxValue: 50,
                        minValue: 1
                    },
                    {
                        fieldLabel: '备注',
                        name: 'REMARK',
                        xtype: 'textfield',
                        columnWidth: .990
                    }

                ]
            },
            {
                xtype: 'fieldset',
                title: '分年度收支预算',
                itemId: 'winPanel_xmsyGrid',
                anchor: '100% -90',
                layout: 'fit',
                collapsible: false,
                items: [
                    initWindow_zqxxtb_contentForm_tab_xmsy_grid()
                ]
            }
        ]
    });
}

/**
 * 初始化债券信息填报弹出窗口中的收支平衡标签页中的表格
 */
function initWindow_zqxxtb_contentForm_tab_xmsy_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 60,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "INCOME_YEAR", type: "string", text: "年度", width: 80, tdCls: 'grid-cell',
            editor: {
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStore(json_debt_year)
            }
        },
        {
            header: '项目预算总收入', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "TOTAL_AMT",
                    type: "float",
                    text: "合计",
                    width: 150,
                    summaryType: 'sum',
                    tdCls: 'grid-cell-unedit',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "YYSR_AMT", type: "float", text: "营业收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "CZBZ_AMT", type: "float", text: "补贴收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "ZCBX_AMT", type: "float", text: "资产变现收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "QT_AMT", type: "float", text: "其他收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]
        },
        {
            header: '项目预算总支出', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "YSCB_HJ_AMT", type: "float", text: "合计", width: 150, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "XM_YY_AMT", type: "float", text: "经营成本", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "ZJFY_AMT", type: "float", text: "折旧费用", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "LXZC_AMT", type: "float", text: "利息支出", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "SFZC_AMT", type: "float", text: "税费支出", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "HBZC_AMT", type: "float", text: "还本支出", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]
        },
        {
            dataIndex: "DQYY_AMT", type: "float", text: "当期盈余", width: 150, tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "LJYY_AMT", type: "float", text: "累计盈余", width: 150, tdCls: 'grid-cell-unedit'}
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'xmsyGrid',
        border: false,
        flex: 1,
        data: [],
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
                pluginId: 'xmsyCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                    },
                    'validateedit': function (editor, context) {
                        if (context.field == 'ZFXJJ_AMT' || context.field == 'CZBZ_AMT' || context.field == 'WNRYS_AMT' || context.field == 'QT_AMT') {
                            if (isNaN(parseFloat(context.value)) || parseFloat(context.value) < 0) {
                                Ext.toast({
                                    html: "输入错误字符或者收入低于0！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                        }
                        if (context.field == 'INCOME_YEAR') {
                            var xmsyform_temp = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0].getForm();
                            var limit_date_max = parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4)) + parseInt(xmsyform_temp.findField("XM_USED_LIMIT").getValue());
                            if (context.value > limit_date_max) {
                                Ext.toast({
                                    html: "添加的年度不能超过项目投入使用日期与项目运营期限之和！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                            if (context.value < parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4))) {
                                Ext.toast({
                                    html: "输入的年度不能小于项目投入使用日期所在的年度",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                        }

                    },
                    'edit': function (editor, context) {
                        // 项目预算总收入
                        if (context.field == 'YYSR_AMT' || context.field == 'CZBZ_AMT' || context.field == 'ZCBX_AMT' || context.field == 'QT_AMT') {
                            var yysr_amt = context.record.get("YYSR_AMT");
                            var czbz_amt = context.record.get("CZBZ_AMT");
                            var zcbx_amt = context.record.get("ZCBX_AMT");
                            var qt_amt = context.record.get("QT_AMT");
                            var total_amt = new Object(yysr_amt + czbz_amt + zcbx_amt + qt_amt);
                            context.record.set('TOTAL_AMT', Math.floor((total_amt) * 100) / 100);

                            context.record.set('DQYY_AMT', Math.floor((context.record.get("TOTAL_AMT") - context.record.get("YSCB_HJ_AMT")) * 100) / 100);
                            var ljyy_sum_amt = 0.00;
                            grid.getStore().each(function (record) {
                                if (record.get('INCOME_YEAR') <= context.record.get("INCOME_YEAR")) {
                                    ljyy_sum_amt += record.get('DQYY_AMT');
                                }
                            });
                            context.record.set('LJYY_AMT', Math.floor((ljyy_sum_amt) * 100) / 100);
                            szysGrid(grid);
                            initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
                        }
                        // 项目预算总成本
                        if (context.field == 'XM_YY_AMT' || context.field == 'ZJFY_AMT' || context.field == 'LXZC_AMT' || context.field == 'SFZC_AMT' || context.field == 'HBZC_AMT') {
                            var xm_yy_amt = context.record.get("XM_YY_AMT");
                            var zjfy_amt = context.record.get("ZJFY_AMT");
                            var lxzc_amt = context.record.get("LXZC_AMT");
                            var sfzc_amt = context.record.get("SFZC_AMT");
                            var hbzc_amt = context.record.get("HBZC_AMT");
                            var yscb_hj_amt = new Object(xm_yy_amt + zjfy_amt + lxzc_amt + sfzc_amt + hbzc_amt);
                            context.record.set('YSCB_HJ_AMT', Math.floor((yscb_hj_amt) * 100) / 100);

                            context.record.set('DQYY_AMT', Math.floor((context.record.get("TOTAL_AMT") - context.record.get("YSCB_HJ_AMT")) * 100) / 100);
                            var ljyy_sum_amt = 0.00;
                            grid.getStore().each(function (record) {
                                if (record.get('INCOME_YEAR') <= context.record.get("INCOME_YEAR")) {
                                    ljyy_sum_amt += record.get('DQYY_AMT');
                                }
                            });
                            context.record.set('LJYY_AMT', Math.floor((ljyy_sum_amt) * 100) / 100);
                            szysGrid(grid);
                            initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
                        }
                    }
                }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    var xmsyform_temp;
    var xmsygrid_temp;
    var used_date_data;
    var used_date;
    var used_limit;
    var xmsy_store;
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
                    $(document).keydown(function (event) {
                        if (event.which == 13 || event.which == 32) {
                            return false;
                        }
                    });
                    xmsyform_temp = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0].getForm();
                    xmsygrid_temp = btn.up('grid');
                    used_date_data = xmsyform_temp.findField("XM_USED_DATE").rawValue;
                    used_date = xmsyform_temp.findField("XM_USED_DATE").getValue();
                    used_limit = xmsyform_temp.findField("XM_USED_LIMIT").getValue();
                    xmsy_store = xmsygrid_temp.getStore();
                    if (used_date == '' || used_date == undefined || used_limit == '' || used_limit == undefined) {
                        Ext.MessageBox.alert('提示', "项目投入使用日期或项目运营期限不能为空");
                        return false;
                    }
                    var lenght_temp = xmsy_store.data.length;
                    if (lenght_temp == 0) {
                        btn.up('grid').insertData(lenght_temp, {
                            INCOME_YEAR: used_date_data.substring(0, 4)
                        });
                    }
                    if (lenght_temp > 0) {
                        var record = xmsy_store.data.items[lenght_temp - 1];
                        var INCOME_YEAR_temp = (parseInt(record.data.INCOME_YEAR) + 1).toString();
                        var limit_date_max = parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4)) + parseInt(xmsyform_temp.findField("XM_USED_LIMIT").getValue());
                        if (parseInt(INCOME_YEAR_temp) > limit_date_max) {
                            Ext.MessageBox.alert('提示', "添加的年度不能超过项目投入使用日期与项目运营期限之和");
                            return false;
                        }
                        var ljyy_sum_amt = 0.00;
                        xmsy_store.each(function (record) {
                            if (record.get('INCOME_YEAR') <= INCOME_YEAR_temp) {
                                ljyy_sum_amt += record.get('DQYY_AMT');
                            }
                        });
                        btn.up('grid').insertData(lenght_temp, {
                            INCOME_YEAR: INCOME_YEAR_temp,
                            TOTAL_AMT: record.data.TOTAL_AMT,
                            YYSR_AMT: record.data.YYSR_AMT,
                            CZBZ_AMT: record.data.CZBZ_AMT,
                            ZCBX_AMT: record.data.ZCBX_AMT,
                            QT_AMT: record.data.QT_AMT,
                            YSCB_HJ_AMT: record.data.YSCB_HJ_AMT,
                            XM_YY_AMT: record.data.XM_YY_AMT,
                            ZJFY_AMT: record.data.ZJFY_AMT,
                            LXZC_AMT: record.data.LXZC_AMT,
                            SFZC_AMT: record.data.SFZC_AMT,
                            HBZC_AMT: record.data.HBZC_AMT,
                            DQYY_AMT: record.data.DQYY_AMT,
                            LJYY_AMT: ljyy_sum_amt + record.data.DQYY_AMT
                        });
                    }
                    szysGrid(grid);
                    var xmsyStore = DSYGrid.getGrid("xmsyGrid").getStore();
                    Ext.ComponentQuery.query('numberFieldFormat[name="XMZTR_AMT"]')[0].setValue(Math.floor((xmsyStore.sum('TOTAL_AMT')) * 100) / 100);
                    Ext.ComponentQuery.query('numberFieldFormat[name="XMZCB_AMT"]')[0].setValue(Math.floor((xmsyStore.sum('YSCB_HJ_AMT')) * 100) / 100);
                }
            },
            {
                xtype: 'button',
                itemId: 'xmsyDelBtn',
                text: '删除',
                width: 60,
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                    szysGrid(grid);
                    initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
                }
            }
        ]
    }, 0);
    grid.on('selectionchange', function (view, records) {
        grid.down('#xmsyDelBtn').setDisabled(!records.length);
    });
    return grid;
}

/**
 * 刷新收支平衡Form信息
 */
/**
 * 刷新收支平衡Form信息
 */
function initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm() {
    var xmsyStore = DSYGrid.getGrid("xmsyGrid").getStore();
    Ext.ComponentQuery.query('numberFieldFormat[name="XMZTR_AMT"]')[0].setValue(xmsyStore.sum('TOTAL_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="XMZCB_AMT"]')[0].setValue(xmsyStore.sum('YSCB_HJ_AMT'));
}

/**
 * 初始化债券信息填报弹出窗口中的存量债务标签页
 */
function initWindow_zqxxtb_contentForm_tab_clzw() {
    return Ext.create('Ext.form.Panel', {
        name: 'clzwForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        padding: '0 10 0 10',
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldset',
                title: '债务总概况',
                layout: 'column',
                defaultType: 'textfield',
                anchor: '100%',
                collapsible: false,
                fieldDefaults: {
                    labelWidth: 100,
                    columnWidth: .33,
                    margin: '0 0 5 20'
                },
                items: [
                    {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        fieldLabel: '债务总余额',
                        name: 'DEBT_TOTAL_AMT',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        fieldLabel: '一般债务余额',
                        name: 'YBZW_BALANCE',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        fieldLabel: '其中：一般债券',
                        name: 'GENERAL_BOND',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        fieldLabel: '逾期债务',
                        name: 'OVERDUE_DEBT',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        fieldLabel: '专项债务余额',
                        name: 'ZXZW_BALANCE',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: 'numberFieldFormat',
                        hideTrigger: true,
                        fieldLabel: '其中：专项债券',
                        name: 'SPECIAL_BOND',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '债务明细',
                anchor: '100% -90',
                collapsible: false,
                layout: 'fit',
                items: [
                    initWindow_zqxxtb_contentForm_tab_clzw_grid()
                ]
            }
        ]
    });
}

/**
 * 初始化债券信息填报弹出窗口中的存量债务标签页中的表格
 */
function initWindow_zqxxtb_contentForm_tab_clzw_grid() {

    var headerJson = [
        {
            dataIndex: "ZW_NAME", type: "string", text: "债务/债券名称", width: 400,
            renderer: function (data, cell, record) {
                var hrefUrl = null;
                if (record.get('ZWZQ_TYPE') == '0') {
                    /*hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));*/
                    var url = '/page/debt/common/zwyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "zw_id";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('ZW_ID'));
                } else {
                    /*hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZW_ID') + '&AD_CODE=' + record.get('AD_CODE');*/
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('ZW_ID');
                    paramValues[1] = record.get('AD_CODE');
                }
                // return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            dataIndex: "JJ_DATE", type: "string", text: "举借日期"
        },
        {
            dataIndex: "ZWLB_NAME", type: "string", text: "债务/债券类型", width: 150
        },
        {
            dataIndex: "ZWQX_NAME", type: "string", text: "债务期限", width: 150
        },
        {
            dataIndex: "LX_RATE", type: "float", text: "年利率(%)", width: 150
        },
        {dataIndex: "HT_NO", type: "string", text: "合同号/债券期号", width: 150, editor: 'textfield'},
        {
            dataIndex: "JJ_AMT", type: "float", text: "举借金额", width: 150
        },
        {
            dataIndex: "CHBJ_AMT", type: "float", text: "已偿还本金", width: 150
        },
        {dataIndex: "YE_AMT", type: "float", text: "债务余额", width: 150},
        {
            dataIndex: "YQ_AMT", type: "float", text: "逾期债务", width: 150
        }
    ];

    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'clzwGrid',
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
        rowNumber: {
            rowNumber: false// 显示行号
        }
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}

/**
 * 刷新存量债务Form信息
 */
function initWindow_zqxxtb_contentForm_tab_clzw_refreshForm() {
    var clzwStore = DSYGrid.getGrid("clzwGrid").getStore();
    Ext.ComponentQuery.query('numberFieldFormat[name="DEBT_TOTAL_AMT"]')[0].setValue(clzwStore.sum('YE_AMT'));
    var ybzwye = 0;
    clzwStore.each(function (record) {
        if ((record.get('ZWLB_ID') == '0101' && record.get('ZWZQ_TYPE') == '0') || (record.get('ZWLB_ID') == '01' && record.get('ZWZQ_TYPE') == '1')) {
            ybzwye = ybzwye + record.get('YE_AMT');
        }
    });
    Ext.ComponentQuery.query('numberFieldFormat[name="YBZW_BALANCE"]')[0].setValue(ybzwye);
    var ybzwye_ybzq = 0;
    clzwStore.each(function (record) {
        if (record.get('ZWLB_ID') == '01' && record.get('ZWZQ_TYPE') == '1') {
            ybzwye_ybzq = ybzwye_ybzq + record.get('YE_AMT');
        }
    });
    Ext.ComponentQuery.query('numberFieldFormat[name="GENERAL_BOND"]')[0].setValue(ybzwye_ybzq);
    var zxzwye = 0;
    clzwStore.each(function (record) {
        if ((record.get('ZWLX_ID') == '0102' && record.get('ZWZQ_TYPE') == '0') || record.get('ZWLB_ID') == '02' && record.get('ZWZQ_TYPE') == '1') {
            zxzwye = zxzwye + record.get('YE_AMT');
        }
    });
    Ext.ComponentQuery.query('numberFieldFormat[name="ZXZW_BALANCE"]')[0].setValue(zxzwye);
    var zxzwye_zxzq = 0;
    clzwStore.each(function (record) {
        if (record.get('ZWLB_ID') == '02' && record.get('ZWZQ_TYPE') == '1') {
            zxzwye_zxzq = zxzwye_zxzq + record.get('YE_AMT');
        }
    });
    Ext.ComponentQuery.query('numberFieldFormat[name="SPECIAL_BOND"]')[0].setValue(zxzwye_zxzq);
    Ext.ComponentQuery.query('numberFieldFormat[name="OVERDUE_DEBT"]')[0].setValue(clzwStore.sum('YQ_AMT'));
}

/**
 * 初始化债券信息填报弹出窗口中的项目资产标签页
 */
function initWindow_zqxxtb_contentForm_tab_xmzc() {
    return Ext.create('Ext.form.Panel', {
        name: 'xmzcForm',
        width: '100%',
        height: '100%',
        layout: 'fit',
        border: false,
        padding: '0 10 0 10',
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldset',
                title: '资产明细',
                //anchor: '100%',
                collapsible: false,
                layout: 'fit',
                items: [
                    initWindow_zqxxtb_contentForm_tab_xmzc_grid()
                ]
            }
        ]
    });
}

/**
 * 初始化债券信息填报弹出窗口中的项目资产明细表格
 */
function initWindow_zqxxtb_contentForm_tab_xmzc_grid() {
    var headerJson = [
        {
            dataIndex: "XMZC_DTL_ID",
            type: "string",
            hidden: true
        },
        {
            "dataIndex": "XMZC_NAME",
            "type": "string",
            "text": "资产名称",
            "width": 170
        },
        {
            "dataIndex": "ZCLB_NAME",
            "type": "string",
            "text": "资产类别",
            "width": 170
        },
        {
            "dataIndex": "ZCXZ_NAME",
            "type": "string",
            "text": "资产性质",
            "width": 170
        },
        {
            "dataIndex": "BXNL_ID",
            "type": "string",
            "text": "变现能力",
            "width": 170,
            'renderer': function (value, metadata, record) {
                if (value == '') {
                    return;
                }
                var rec = BXNL_ID_Store.findRecord('code', value, 0, false, true, true);
                if (rec == null) {
                    return '';
                }
                return rec.get('name');
            }
        },
        {
            "dataIndex": "JSZT_NAME",
            "type": "string",
            "text": "建设状态",
            "width": 170
        }, {
            dataIndex: "JLDW_NAME",
            type: "string",
            text: "计量单位",
            width: 100
        }, {
            dataIndex: "ZC_NUM",
            width: 100,
            type: "number",
            text: "数量"
        }, {
            dataIndex: "RZ_DATE",
            width: 150,
            type: "string",
            text: "转固/入账时间"
        }, {
            header: "资产价值(万元)",
            colspan: 2,
            align: 'center',
            columns: [{
                dataIndex: "ZJYZ_AMT",
                width: 150,
                type: "float",
                text: "原值"
            }, {
                dataIndex: "ZCJZ_AMT",
                width: 150,
                type: "float",
                text: "净值"
            }, {
                "dataIndex": "YGJZ_AMT",
                "width": 150,
                "type": "float",
                "text": "预估价值"
            }]
        }, {
            header: "资产运营收益(万元)",
            colspan: 2,
            align: 'center',
            columns: [{
                dataIndex: "LJSY_AMT",
                width: 150,
                type: "float",
                text: "累计收益"
            }, {
                dataIndex: "SNLJSY_AMT",
                width: 150,
                type: "float",
                text: "本期收益"
            }, {
                "dataIndex": "ZCYXNX",
                "width": 170,
                "type": "float",
                "text": "资产运营年限（年）"
            }, {
                "dataIndex": "PJSY_AMT",
                "width": 200,
                "type": "float",
                "text": "每年平均经营性现金流流入"
            }, {
                "dataIndex": "PJBT_AMT",
                "width": 250,
                "type": "float",
                "text": "年度平均政府安排补贴资金"
            }]
        }, {
            header: "资产处置情况",
            colspan: 2,
            align: 'center',
            columns: [
                {
                    dataIndex: "CZLX_NAME",
                    width: 150,
                    type: "string",
                    text: "处置类型"
                },
                {
                    dataIndex: "CZSR_AMT",
                    width: 200,
                    type: "float",
                    text: "本期处置收入(万元)"
                }
            ]
        }, {
            dataIndex: "DYDB_AMT",
            width: 220,
            type: "float",
            text: "抵押质押及担保金额(万元)"
        }, {
            dataIndex: "REMARK",
            width: 200,
            type: "string",
            text: "备注"
        }
    ];

    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'xmzcGrid',
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
        rowNumber: {
            rowNumber: false// 显示行号
        }
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}

/**
 * 页签：招投标
 */
function initWindow_zqxxtb_contentForm_tab_xmcg() {
    var headerJson = [
        {
            dataIndex: "ZB_DATE", type: "string", text: "招标日期", width: 150
        },
        {
            dataIndex: "YS_AMT", type: "float", text: "预算金额（万元）", width: 400
        },
        {
            dataIndex: "ZBDW", type: "string", text: "中标单位", width: 150
        },
        {
            dataIndex: "ZB_AMT", type: "float", text: "中标金额（万元）", width: 150
        },
        {
            dataIndex: "HTQD_DATE", type: "string", text: "合同签订日期", width: 150
        },
        {
            dataIndex: "HT_AMT", type: "float", text: "合同金额（万元）", width: 150
        },
        {dataIndex: "HTQX", type: "int", text: "合同期限（月）", width: 150},
        {text: "备注", dataIndex: "REMARK", width: 300, type: "string"}
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'xmcgGrid',
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
        rowNumber: {
            rowNumber: false// 显示行号
        }
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}

/**
 * 页签：建设进度
 */
function initWindow_zqxxtb_contentForm_tab_xmjd() {
    var config = {
        editable: false,
        busiId: ''
    };
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        name: 'xmjsjd_contentForm',
        itemId: 'xmjsjd_contentForm',
        layout: 'vbox',
        fileUpload: true,
        border: false,
        defaults: {
            width: '100%'
        },
        defaultType: 'textfield',
        items: [
            initWindow_zqxxtb_contentForm_tab_xmjd_grid(),
            {
                title: '附件<span class="file_sum_fj" style="color: #FF0000;">(0)</span>',
                scrollable: true,
                flex: 1,
                name: 'xmjsjdFJ',
                xtype: 'fieldset',
                items: [
                    {
                        xtype: 'panel',
                        layout: 'fit',
                        itemId: 'winPanel_tabPanel',
                        border: false,
                        items: initWindow_xmjd_tab_upload(config)
                    }
                ]
            }
        ]
    });
}

function initWindow_zqxxtb_contentForm_tab_xmjd_grid() {
    var headerJson = [
        {
            dataIndex: "JSJD_ID", type: "string", text: "建设进度ID", width: 200, hidden: true
        },
        {
            dataIndex: "JDFB_DATE", type: "string", text: "进度发布日期", width: 200
        },
        {
            dataIndex: "SCJD", type: "string", text: "项目所处阶段", width: 400
        },
        {
            dataIndex: "JDBL", type: "float", text: "进度比例（%）", width: 150
        },
        {
            dataIndex: "JDSM", type: "string", text: "进度说明", width: 400
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'xmjdGrid',
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
        rowNumber: {
            rowNumber: false// 显示行号
        },
        listeners: {
            'rowclick': function (self) {
                var records = DSYGrid.getGrid('xmjdGrid').getSelection();
                var filePanel = Ext.ComponentQuery.query('#xmjsjd_contentForm')[0].down('#winPanel_tabPanel');
                if (filePanel) {
                    filePanel.removeAll();
                    filePanel.add(initWindow_xmjd_tab_upload({
                        editable: false,
                        busiId: records[0].get('JSJD_ID')
                    }));
                }
            }
        }
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}

/**
 * 初始化建设进度页签panel的附件页签
 */
function initWindow_xmjd_tab_upload(config) {
    var busiId = '';
    var grid = UploadPanel.createGrid({
        busiType: '',//业务类型
        busiId: busiId,//业务ID
        //busiId: records[0].get('JSJD_ID')//业务ID
        editable: config.editable,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_xmjdfj'
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
 * 初始化债券信息填报弹出窗口中的实际收益标签页
 */
function initWindow_zqxxtb_contentForm_tab_sjsy() {
    return Ext.create('Ext.form.Panel', {
        name: 'sjsyForm',
        width: '100%',
        height: '100%',
        layout: 'fit',
        border: false,
        padding: '0 10 0 10',
        defaultType: 'textfield',
        items: [
            initWindow_zqxxtb_contentForm_tab_sjsy_grid()
        ]
    });
}

/**
 * 初始化债券信息填报弹出窗口中的实际收益明细表格
 */
function initWindow_zqxxtb_contentForm_tab_sjsy_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 60,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "SET_YEAR", type: "string", text: "年度", width: 80, tdCls: 'grid-cell',
            editor: {
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStore(json_debt_year)
            }
        },
        {
            header: '项目预算总收入', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "TOTAL_AMT",
                    type: "float",
                    text: "合计",
                    width: 150,
                    summaryType: 'sum',
                    tdCls: 'grid-cell-unedit',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "YYSR_AMT", type: "float", text: "营业收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "BTSR_AMT", type: "float", text: "补贴收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "ZCBX_AMT", type: "float", text: "资产变现收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "QTSR_AMT", type: "float", text: "其他收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]
        },
        {
            header: '项目预算总支出', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "YSCB_HJ_AMT", type: "float", text: "合计", width: 150, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "JYCB_AMT", type: "float", text: "经营成本", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "ZJFY_AMT", type: "float", text: "折旧费用", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "LXZC_AMT", type: "float", text: "利息支出", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "SFZC_AMT", type: "float", text: "税费支出", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "HBZC_AMT", type: "float", text: "还本支出", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]
        },
        {
            dataIndex: "DQYY_AMT", type: "float", text: "当期盈余", width: 150, tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "LJYY_AMT", type: "float", text: "累计盈余", width: 150, tdCls: 'grid-cell-unedit'}
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'sjsyGrid',
        border: false,
        data: [],
        checkBox: true,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'xmsyCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                    },
                    'validateedit': function (editor, context) {
                        if (context.field == 'YYSR_AMT' || context.field == 'BTSR_AMT' || context.field == 'ZCBX_AMT' || context.field == 'QTSR_AMT') {
                            if (isNaN(parseFloat(context.value)) || parseFloat(context.value) < 0) {
                                Ext.toast({
                                    html: "输入错误字符或者收入低于0！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                        }
                        if (context.field == 'SET_YEAR') {
                            var xmsyform_temp = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0].getForm();
                            var limit_date_max = parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4)) + parseInt(xmsyform_temp.findField("XM_USED_LIMIT").getValue());
                            if (context.value > limit_date_max) {
                                Ext.toast({
                                    html: "添加的年度不能超过项目投入使用日期与项目运营期限之和！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                            if (context.value < parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4))) {
                                Ext.toast({
                                    html: "输入的年度不能小于项目投入使用日期所在的年度",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                        }

                    },
                    'edit': function (editor, context) {
                        // 项目预算总收入
                        if (context.field == 'YYSR_AMT' || context.field == 'BTSR_AMT' || context.field == 'ZCBX_AMT' || context.field == 'QTSR_AMT') {
                            var yysr_amt = context.record.get("YYSR_AMT");
                            var czbz_amt = context.record.get("BTSR_AMT");
                            var zcbx_amt = context.record.get("ZCBX_AMT");
                            var qt_amt = context.record.get("QTSR_AMT");
                            var total_amt = new Object(yysr_amt + czbz_amt + zcbx_amt + qt_amt);
                            context.record.set('TOTAL_AMT', Math.floor((total_amt) * 100) / 100);

                            context.record.set('DQYY_AMT', Math.floor((context.record.get("TOTAL_AMT") - context.record.get("YSCB_HJ_AMT")) * 100) / 100);
                            var ljyy_sum_amt = 0.00;
                            grid.getStore().each(function (record) {
                                if (record.get('SET_YEAR') <= context.record.get("SET_YEAR")) {
                                    ljyy_sum_amt += record.get('DQYY_AMT');
                                }
                            });
                            context.record.set('LJYY_AMT', Math.floor((ljyy_sum_amt) * 100) / 100);
                            szysGrid(grid);
                            initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
                        }
                        // 项目预算总成本
                        if (context.field == 'XM_YY_AMT' || context.field == 'ZJFY_AMT' || context.field == 'LXZC_AMT' || context.field == 'SFZC_AMT' || context.field == 'HBZC_AMT') {
                            var xm_yy_amt = context.record.get("XM_YY_AMT");
                            var zjfy_amt = context.record.get("ZJFY_AMT");
                            var lxzc_amt = context.record.get("LXZC_AMT");
                            var sfzc_amt = context.record.get("SFZC_AMT");
                            var hbzc_amt = context.record.get("HBZC_AMT");
                            var yscb_hj_amt = new Object(xm_yy_amt + zjfy_amt + lxzc_amt + sfzc_amt + hbzc_amt);
                            context.record.set('YSCB_HJ_AMT', Math.floor((yscb_hj_amt) * 100) / 100);

                            context.record.set('DQYY_AMT', Math.floor((context.record.get("TOTAL_AMT") - context.record.get("YSCB_HJ_AMT")) * 100) / 100);
                            var ljyy_sum_amt = 0.00;
                            grid.getStore().each(function (record) {
                                if (record.get('SET_YEAR') <= context.record.get("SET_YEAR")) {
                                    ljyy_sum_amt += record.get('DQYY_AMT');
                                }
                            });
                            context.record.set('LJYY_AMT', Math.floor((ljyy_sum_amt) * 100) / 100);
                            szysGrid(grid);
                            initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
                        }
                    }
                }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}

/**
 * 初始化债券信息填报弹出窗口中的绩效情况标签页
 */
function initWindow_zqxxtb_contentForm_tab_jxqk() {
    return Ext.create('Ext.form.Panel', {
        name: 'jxqkForm',
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
                style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
                layout: 'column',
                defaultType: 'textfield',
                fieldDefaults: {
                    labelWidth: 80,
                    columnWidth: .33,
                    margin: '5 0 5 20'
                },
                items: [
                    {
                        fieldLabel: '项目类型',
                        name: 'JXQK_XMLX_ID',
                        xtype: 'treecombobox',
                        minPicekerWidth: 250,
                        displayField: 'name',
                        valueField: 'id',
                        store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                        // store: DebtEleTreeStoreJSON(json_debt_zwxmlx),
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'

                    },
                    {
                        fieldLabel: '绩效年度',
                        name: 'ZB_YEAR',
                        xtype: 'combobox',
                        value: SET_YEAR,
                        displayField: 'name',
                        valueField: 'id',
                        store: DebtEleStore(getYearList()),
                        editable: false,
                        listeners: {
                            'change': function () {
                                reloadJxqkGrid()
                            }
                        }
                    },
                    {
                        fieldLabel: '填报日期',
                        name: 'TB_DATE',
                        xtype: 'datefield',
                        format: 'Y-m-d',
                        editable: false,
                        value: today
                    },
                    {
                        fieldLabel: '填报人',
                        name: 'OPER_USER',
                        value: userName
                    }
                ]
            },
            {
                xtype: 'fieldcontainer',
                anchor: '100% -80',
                layout: 'anchor',
                defaults: {
                    anchor: '-10 -10'

                },
                style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
                items: [initWindow_zqxxtb_contentForm_tab_jxqk_grid()]
            }
        ]
    });
}

/**
 * 初始化债券信息填报弹出窗口中的绩效情况标签页中的表格
 */
function initWindow_zqxxtb_contentForm_tab_jxqk_grid() {
    var eleStore = DebtEleStore(json_debt_sf);//默认为是否
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "DTL_ID", type: "string", text: "考核信息ID", hidden: true},
        {dataIndex: "BILL_ID", type: "string", text: "绩效主单ID", hidden: true},
        {dataIndex: "ZB_YEAR", type: "string", text: "年度", hidden: true},
        {dataIndex: "ZB_CODE", type: "string", text: "指标编码", hidden: true},
        {dataIndex: "ZBSX_ID", type: "string", text: "指标属性", hidden: true},
        {dataIndex: "ZBLB_ID", type: "string", text: "指标类别", hidden: true},
        {dataIndex: "XMJD_ID", type: "string", text: "项目阶段", width: 150},
        {dataIndex: "ZBXZ_ID", type: "string", text: "指标性质", width: 150},
        {dataIndex: "ZB_NAME", type: "string", text: "指标名称", width: 250},
        {dataIndex: "ZB_DESC", type: "string", text: "指标说明", width: 250},
        {dataIndex: "PJ_UNIT", type: "string", text: "评价单位", hidden: true},
        {dataIndex: "PJ_UNIT_CH", type: "string", text: "评价单位"},
        {dataIndex: "PJ_ZY", type: "string", text: "值域"},
        {dataIndex: "ENUM_ZY", type: "string", text: "枚举值域", hidden: true},
        {dataIndex: "ENUM_FZ", type: "string", text: "枚举分值", hidden: true},
        {dataIndex: "MAX_VALUE", type: "string", text: "最大值", hidden: true},
        {dataIndex: "MIN_VALUE", type: "string", text: "最小值", hidden: true},
        {
            dataIndex: "KH_MB", id: 'KH_MB', type: "string", text: "绩效考核目标", editor: 'textfield',
            renderer: function (val, rd, model, row, col, store, gridview) {
                var record = store.data.items[row];
                record.set('ROWNUM', row);
                //重新渲染，显示name
                var returnRecord = eleStore.findRecord('id', val, 0, false, true, true);
                return returnRecord != null ? returnRecord.get('name') : val;
            }
        },
        {dataIndex: "ROWNUM", type: "int", text: "序号", hidden: true},
        {dataIndex: "REMARK", type: "string", text: "备注", editor: 'textfield'}
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'jxqkGrid',
        border: false,
        flex: 1,
        //data: [],
        dataUrl: '/getJxqkGrid.action',
        checkBox: true,
        autoLoad: false,
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
                pluginId: 'clzwCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                        var row = context.record.get("ROWNUM");
                        var record = DSYGrid.getGrid('jxqkGrid').getStore().data.items[row];
                        var column = Ext.getCmp('KH_MB');
                        //重新加载插件
                        if (record.data.PJ_UNIT == '0') {//是否
                            eleStore = DebtEleStore(json_debt_sf);
                            column.setEditor({
                                xtype: 'combobox',
                                displayField: 'name',
                                valueField: 'id',
                                store: eleStore
                            });
                        } else if (record.data.PJ_UNIT == '1') {//枚举
                            var ENUM_ZY_ARRAY = (record.data.ENUM_ZY).split("|");
                            var ENUM_FZ_ARRAY = (record.data.ENUM_FZ).split("|");
                            /*动态拼接storeJson串*/
                            var storeJson = '[';
                            for (i = 0; i < ENUM_ZY_ARRAY.length; i++) {
                                storeJson = storeJson + '{id: "' + ENUM_FZ_ARRAY[i] + '", code: "' + ENUM_FZ_ARRAY[i] + '", name: "' + ENUM_ZY_ARRAY[i] + '"},'
                            }
                            storeJson = storeJson.substring(0, storeJson.length - 1);
                            storeJson = storeJson + ']';
                            //生成eleStore
                            eleStore = DebtEleStore(eval(storeJson));
                            //eleStore.sort('name');
                            column.setEditor({
                                xtype: 'combobox',
                                displayField: 'name',
                                valueField: 'id',
                                store: eleStore
                            });
                        } else {
                            var MAX_VALUE = record.data.MAX_VALUE;
                            var MIN_VALUE = record.data.MIN_VALUE;
                            column.setEditor({
                                xtype: 'numberFieldFormat',
                                hideTrigger: true,
                                maxValue: MAX_VALUE,
                                minValue: MIN_VALUE
                            });
                        }
                    },
                    'validateedit': function (editor, context) {
                    },
                    'edit': function (editor, context) {
                    }
                }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}

/**
 * 初始化债券信息填报弹出窗口中的项目附件标签页
 */
function initWindow_zqxxtb_contentForm_tab_xmfj(config) {
    var ruleIds = config.ruleIds;
    var editSSFA = true;
    var grid = UploadPanel.createGrid({
        busiType: 'ET001',//业务类型
        ruleIds: !((HAVE_SFJG == '2' && is_fxjh == '1') || (HAVE_SFJG == '1' && is_fxjh == '3')
            || (HAVE_SFJG == '3' && (is_fxjh == '3' || is_fxjh == '1')) || is_scfjgn) ? "" : config.ruleIds,//规则id，若存在，则优先用rule_id获取附件
        addHeaders: [
            //20201217 fzd 附件增加“第三方单位名称”、“组织机构代码”、“备注”
            //20201223 zhuangrx 湖北项目附件增加操作人，上传时间
            {text: '操作人', dataIndex: 'UPLOAD_USER', type: 'string', index: 0},
            {text: '上传时间', dataIndex: 'UPLOAD_TIME', type: 'string', index: 0},
            {text: '第三方单位名称', dataIndex: 'DSF_AG_NAME', width: 260, type: 'string', editor: 'textfield'},
            {text: '组织机构代码', dataIndex: 'DSF_ZZJG_CODE', type: 'string', editor: 'textfield'},
            {text: '备注', dataIndex: 'REMARK', type: 'string', editor: 'textfield'}
        ],
        busiId: is_scfjgn ? config.xm_id : window_zqxxtb.XM_ID,//业务ID
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
        //if((is_zxzqxt=='1' && is_zxzq == '1')){
        if (is_fxjh == '1' && sysAdcode == '13') {
            is_scfjgn = true;
        }
        //需求库（储备库中）、储备库、发行库非上传附件功能（会所、律所专用）,法律意见书、财评报告禁止上传和删除
        //20201219 fzd 发行库增加一案两书必录显示
        if ((is_fxjh == '1' || is_fxjh == '3' || is_fxjh == '2') && !is_scfjgn) {
            if (/*(record.data.RULE_ID && record.data.BUSI_PROPERTY_DESC && (record.data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") != -1))
                ||*/ (!record.data.RULE_ID && record.data.UPLOAD_USER && userCode != record.data.UPLOAD_USER)) {
                uploadbtn = '';
                deletebtn = '';
            }
            //判断如果法律意见书和财评报告存在，则实施方案不能修改
            if ((is_fxjh == '1') || (HAVE_SFJG == '1' && is_fxjh == '3') || (HAVE_SFJG == '3' && (is_fxjh == '3' || is_fxjh == '1'))) {
                if (!editSSFA && record.data.BUSI_PROPERTY_DESC && record.data.BUSI_PROPERTY_DESC.indexOf("dwblfj") != -1) {
                    if (record.data.FILE_ID) {
                        uploadbtn = '';
                        deletebtn = '';
                    }
                }
            }
            if (is_fxjh == 5) {
                if (record.data.UPLOAD_USER == "" || record.data.UPLOAD_USER != userCode) {
                    if (record.data.BUSI_TYPE == 'ET001' || record.data.UPLOAD_USER != userCode && record.data.STATUS != "") {
                        uploadbtn = '';
                        deletebtn = '';
                    }

                }
            }
        } else if (is_scfjgn) {
            if ((record.data.RULE_ID && !(ruleIds_edit.indexOf(record.data.RULE_ID) != -1))
                || (!record.data.RULE_ID && record.data.UPLOAD_USER && userCode != record.data.UPLOAD_USER) || sysAdcode == '13') {
                uploadbtn = '';
                deletebtn = '';
            }
        } else {
            if (!store.editable) {
                uploadbtn = '';
                deletebtn = '';
            }
            if (is_fxjh == '0' && record.data.BUSI_PROPERTY_DESC == "项目可行性研究报告" && sysAdcode == '42') {
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
        //通过项目债券类型获取必录附件，在页面中显示
        var zqlx_id;
        if (is_scfjgn) {
            if (jg_type != '2' && is_swsscfj == 1) {
                zqlx_id = Ext.ComponentQuery.query('form[name="bnsbForm_common"]')[0].down('treecombobox[name="BOND_TYPE_ID"]').getValue();
            } else {
                if (is_fxjh != '' && is_fxjh != null) {
                    zqlx_id = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].down('treecombobox[name="BOND_TYPE_ID"]').getValue();
                } else {
                    zqlx_id = null;
                }
            }
        } else {
            if (jg_type != '2' && is_swsscfj == 1) {
                zqlx_id = Ext.ComponentQuery.query('form[name="bnsbForm_common"]')[0].down('treecombobox[name="BOND_TYPE_ID"]').getValue();
            } else {
                if (is_fxjh == '' || is_fxjh == null) {
                    zqlx_id = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].down('treecombobox[name="BOND_TYPE_ID"]').getValue();
                } else {
                    if (is_fxjh != '' && is_fxjh != null) {
                        zqlx_id = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].down('treecombobox[name="BOND_TYPE_ID"]').getValue();
                    } else {
                        zqlx_id = null;
                    }
                }
            }
        }
        //20201223 fzd 前台不做必录显示，无字段可用，后台校验并提示
        /*if (records != null) {
            for (var i = 0; i < records.length; i++) {
                if((is_fxjh=='1')){
                    //20201211_LIYUE 发行库添加 一案两书必录必录附件
                    if (records[i].data.BUSI_PROPERTY_DESC && (((records[i].data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") != -1 )
                            || records[i].data.BUSI_PROPERTY_DESC.indexOf("dwblfj") != -1 ))) {
                        records[i].set("NULLABLE", "N");
                    }
                }
            }
        }*/
        var entryFjList;
        if (jg_type != '2') {
            $.post('getFjRuleIdsByZqlx.action', {ZQLX_ID: zqlx_id, IS_ENTRY: "1"}, function (data) {
                if (data.success) {//加载成功
                    var entryFjList = data.list;//传递一个array对象
                    var sum = 0;
                    if (records != null) {
                        for (var i = 0; i < records.length; i++) {
                            if (records[i].data.STATUS == '已上传') {
                                sum++;
                            }
                            //专项债券需求库填报设置实施方案为必录
                            //if(is_zxzqxt=='1' && is_zxzq == '1'&& (is_fxjh!='1'&&is_fxjh!='3')){
                            if ((is_fxjh != '1' && is_fxjh != '3' && is_fxjh != '4' && is_fxjh != '5')) {
                                if (records[i].data.BUSI_PROPERTY_DESC && records[i].data.BUSI_PROPERTY_DESC.indexOf("dwblfj") != -1 && !is_scfjgn
                                    && EntryFj(records[i].data.RULE_ID, entryFjList)) {
                                    records[i].set("NULLABLE", "N");
                                }
                            }
                            //if(is_zxzqxt=='1' && is_zxzq == '1' && (is_fxjh=='1'||is_fxjh=='3')){
                            if ((is_fxjh == '1' || is_fxjh == '4' || is_fxjh == '3')) {
                                if (ruleIds.indexOf(records[i].data.RULE_ID) != -1) {
                                    if (records[i].data.BUSI_PROPERTY_DESC && ((records[i].data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") != -1 && !(is_zxzqxt == 1 && is_zxzq == 1 && is_fxjh == 3))
                                            || records[i].data.BUSI_PROPERTY_DESC.indexOf("dwblfj") != -1)
                                        && ((is_fxjh == '1') || (HAVE_SFJG == '1' && is_fxjh == '3')
                                            || (HAVE_SFJG == '3' && (is_fxjh == '1' || is_fxjh == '3'))) && EntryFj(records[i].data.RULE_ID, entryFjList)) {
                                        records[i].set("NULLABLE", "N");
                                    }
                                }
                                if (!!config.ruleIds) {
                                    if (records[i].data.BUSI_PROPERTY_DESC && records[i].data.BUSI_PROPERTY_DESC.indexOf("dsfjgfj") != -1) {
                                        if (records[i].data.FILE_ID) {
                                            editSSFA = false;
                                        }
                                    }
                                }
                            }
                            // guodg 2021092410 储备库，项目实施方案设置为必录
                            if (is_fxjh == '3' && records[i].data.FILE_DESC && records[i].data.FILE_DESC.indexOf("实施方案") != -1) {
                                records[i].set("NULLABLE", "N");
                            }
                        }
                    }
                    if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
                        $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
                    } else {
                        $('span.file_sum').html('(' + sum + ')');
                    }
                }
            }, "json");
        }

    });
    return grid;
}

/**
 * 初始化债券信息填报弹出窗口中的固定资产标签页中的表格
 */
function initWindow_zqxxtb_contentForm_tab_gdzc() {
    var zclbStore = DebtEleTreeStoreJSON(json_debt_zclb);
    var jldwStore = DebtEleStoreDB('DEBT_ZCJLDW');
    var syztStore = DebtEleStoreDB('DEBT_ZCSYZT');
    var yjztStore = DebtEleStore(json_debt_sf);
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            dataIndex: "ZC_CODE",
            type: "string",
            text: "资产编码",
            width: 150,
            editor: 'textfield'
        },
        {
            dataIndex: "ZC_NAME",
            type: "string",
            text: "资产名称",
            width: 200,
            editor: 'textfield'
        },
        {
            dataIndex: "ZCLB_ID",
            type: "string",
            text: "资产类别",
            width: 150,
            editor: {
                xtype: 'treecombobox',
                displayField: 'name',
                valueField: 'id',
                store: zclbStore,
                editable: false,
                selectModel: 'leaf'
            },
            renderer: function (value) {
                var record = zclbStore.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }

        },
        {
            dataIndex: "ZC_COUNT",
            type: "float",
            text: "资产数量",
            width: 150,
            editor: {
                xtype: 'numberFieldFormat',
                hideTrigger: true
            }
        },
        {
            dataIndex: "JLDW_ID",
            type: "string",
            text: "计量单位",
            width: 100,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                editable: false,
                valueField: 'id',
                store: jldwStore
            },
            renderer: function (value) {
                var record = jldwStore.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            dataIndex: "USING_STATE",
            type: "string",
            text: "使用状态",
            width: 150,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                editable: false,
                valueField: 'id',
                store: syztStore
            },
            renderer: function (value) {
                var record = syztStore.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            dataIndex: "RZ_DATE",
            type: "string",
            text: "实物入账日期",
            width: 150,
            editor: {
                xtype: 'datefield',
                format: 'Y-m-d'
            },
            renderer: function (value, metaData, record) {
                var dateStr = Ext.util.Format.date(value, 'Y-m-d');
                return dateStr;
            }
        },
        {
            dataIndex: 'LOCATION',
            type: 'string',
            text: '存放地点',
            width: 200,
            editor: 'textfield'
        },
        {
            dataIndex: "USE_YEARS",
            type: "float",
            text: "使用年限",
            width: 150,
            editor: {
                xtype: 'numberFieldFormat',
                hideTrigger: true
            }
        },
        {
            dataIndex: 'USE_DEPT',
            type: 'string',
            text: '使用部门',
            width: 150,
            editor: 'textfield'
        },
        {
            dataIndex: 'MGMT_DETP',
            type: 'string',
            text: '管理部门',
            width: 150,
            editor: 'textfield'
        },
        {
            dataIndex: "YJ_STATE",
            type: "string",
            text: "移交状态",
            width: 100,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                editable: false,
                valueField: 'id',
                store: yjztStore
            },
            renderer: function (value) {
                var record = yjztStore.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            dataIndex: 'YJ_DEBT',
            type: 'string',
            text: '移交部门',
            width: 150,
            editor: 'textfield'
        },
        {
            dataIndex: 'REMARK',
            type: 'string',
            text: '备注',
            width: 200,
            editor: 'textfield'
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'gdzcGrid',
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
                pluginId: 'gdzcCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                    },
                    'validateedit': function (editor, context) {
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
                itemId: 'gdzcDelBtn',
                text: '删除',
                width: 60,
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
            }
        ]
    }, 0);
    grid.on('selectionchange', function (view, records) {
        grid.down('#gdzcDelBtn').setDisabled(!records.length);
    });
    return grid;
}

/**
 * 初始化已有项目债券信息填报弹出窗口
 */
function initWindow_yyxmtb() {
    var title = '已有项目';
    if (is_fxjh == 1 || is_fxjh == 4) {
        if (is_zb) {
            title = '增补项目';

        } else {
            title = '遴选项目';
        }
    }
    var yyxmWin = Ext.create('Ext.window.Window', {
        itemId: 'window_yyxmtb', // 窗口标识
        name: 'xzzqWin',
        title: title, // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.95, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [initWindow_yyxmtb_contentGrid()],
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('yyxmGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
                        return;
                    }
                    //需求库入口校验防伪码
                    if (!checkSecuCode({'IDS': [records[0].get("XM_ID")]})) {
                        return;
                    }
                    window_zqxxtb.XM_ID = records[0].get("XM_ID");
                    //需求库中专项债校验已有项目一二级指标是否可用
                    if (is_fxjh == '0' && records[0].get("XMXZ_ID") == '010102') {
                        mbYear = records[0].get("BILL_YEAR");
                        var zbpass = yyxmcheckZB(records[0].get("XMLX_ID"), window_zqxxtb.XM_ID);
                        if (!zbpass) {
                            Ext.MessageBox.alert('提示', '指标体系校验不通过！请联系财政用户检查目标指标满分值是否满足条件！');
                            return;
                        }
                    }
                    is_fxjh == '1' && sysAdcode == '13' ? window_zqxxtb.file_disabled = true : window_zqxxtb.file_disabled = false;
                    window_zqxxtb.JH_ID = null;
                    //获取限额库申报批次所需的参数
                    if (is_fxjh == '1' || is_fxjh == '4' || (is_zxzqxt == '1' && is_fxjh == '3')) {//限额库
                        BATCH_BOND_TYPE_ID = (records[0].get('BOND_TYPE_ID'));
                        BATCH_YEAR = parseInt(records[0].get('BILL_YEAR'));
                        getKmJcsj(BATCH_YEAR, true);
                    } else if (is_fxjh == '3') {
                        BATCH_BOND_TYPE_ID = (records[0].get('BOND_TYPE_ID'));
                        BATCH_YEAR = parseInt(SET_YEAR + 1);
                        getKmJcsj(BATCH_YEAR, true);
                    }
                    window_zqxxtb.show();
                    var form = window_zqxxtb.window.down('form[name=bnsbForm]').getForm();
                    form.findField('IS_XMZBJ').setValue('0');
                    loadXzzq_Yyxm();
                    //加载本次申报页签内容为遴选的年度计划
                    var data = records[0].data;
                    if (is_fxjh == '1' || is_fxjh == '4') {
                        //该部分是限额库遴选申报时需要的
                        /*data.XMZSSYCH_AMT = parseFloat(data.XMZSSYCH_AMT) / 10000;
                        data.ZFXJJCH_AMT = parseFloat(data.ZFXJJCH_AMT) / 10000;
                        data.APPLY_AMOUNT_TOTAL = parseFloat(data.APPLY_AMOUNT_TOTAL) / 10000;
                        data.APPLY_AMOUNT1 = parseFloat(data.APPLY_AMOUNT1) / 10000;
                        data.RETURN_CAPITAL = parseFloat(data.RETURN_CAPITAL) / 10000;
                        data.APPLY_AMOUNT2 = parseFloat(data.APPLY_AMOUNT2) / 10000;
                        data.APPLY_AMOUNT3 = parseFloat(data.APPLY_AMOUNT3) / 10000;*/
                        data.FP_AMT = parseFloat(data.APPLY_AMOUNT1);
                        /*data.ZJE = parseFloat(data.ZJE) / 10000;
                        data.YSY = parseFloat(data.YSY) / 10000;
                        data.SYJE = parseFloat(data.SYJE) / 10000;
                        data.ZBJ_AMT = parseFloat(data.APPLY_ZBJ_AMT) / 10000;*/
                        var APPLY_ZBJ_AMT = parseFloat(data.APPLY_ZBJ_AMT);
                        var form = window_zqxxtb.window.down('form[name=bnsbForm]').getForm();
                        form.findField('ZBJ_AMT').setValue(APPLY_ZBJ_AMT);
                        //发行库的申请日期调整成今天
                        delete data.APPLY_DATE;
                        form.findField('APPLY_DATE').setValue(nowDate);

                    } else if (is_fxjh == '3') {
                        //需求纳入流程带出资本金
                        if (DEBT_SYS_FRONTJOINXQK == '1') {
                            var APPLY_ZBJ_AMT = parseFloat(data.APPLY_ZBJ_AMT);
                            var form = window_zqxxtb.window.down('form[name=bnsbForm]').getForm();
                            form.findField('ZBJ_AMT').setValue(APPLY_ZBJ_AMT);
                        } else {
                            var APPLY_ZBJ_AMT = parseFloat(data.ZBJ_AMT);
                            var form = window_zqxxtb.window.down('form[name=bnsbForm]').getForm();
                            form.findField('ZBJ_AMT').setValue(APPLY_ZBJ_AMT);
                        }
                    } else {
                        //需求库中，项目中的资本金和申报form中的资本金字冲突,删除该字段
                        delete data.ZBJ_AMT;
                    }
                    if (is_fxjh == '5') {
                        var form = window_zqxxtb.window.down('form[name=csqkForm]').getForm();
                        var BOND_TYPE_ID = data.BOND_TYPE_ID;
                        form.findField('BOND_TYPE_ID').setValue(BOND_TYPE_ID);
                    }
                    /*   //发行库资本金置灰
                    if(is_fxjh=='1'&&data.APPLY_ZBJ_AMT<=0){
                        var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
                        bnsbForm.down('numberFieldFormat[name="ZBJ_AMT"]').fieldStyle='background:#E6E6E6';
                        bnsbForm.down('numberFieldFormat[name="ZBJ_AMT"]').readOnly='true';
                        bnsbForm.reset();
                        bnsbForm.hide();
                        bnsbForm.show();
                    }*/
                    //20210702 zhuangrx 功能分类经济分类加载时重新赋值
                    var JJFL_ID = data.JJFL_ID;
                    var GNFL_ID = data.GNFL_ID;
                    setTimeout(function () {
                        var form = window_zqxxtb.window.down('form[name=bnsbForm]').getForm();
                        form.findField('JJFL_ID').setValue(JJFL_ID);
                        form.findField('GNFL_ID').setValue(GNFL_ID);
                    }, 1500);
                    window_zqxxtb.window.down('form[name=bnsbForm]').getForm().setValues(data);
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
    });
    yyxmWin.show();

}

/**
 * 初始化债券信息填报弹出窗口中的申报记录标签页中的表格
 */
function initWindow_yyxmtb_contentGrid() {
    //设置查询form
    var search_form = DSYSearchTool.createTool({
        itemId: 'window_select_jsxm_grid_searchTool',
        defaults: {
            labelAlign: 'right',
            labelWidth: 80,
            columnWidth: .333,
            margin: '3 5 3 5'
        },
        items: [
            {
                xtype: 'treecombobox',
                fieldLabel: '项目性质',
                name: 'YYXM_XMXZ_ID',
                displayField: 'name',
                valueField: 'id',
                rootVisible: false,
                lines: false,
                editable: false, //禁用编辑
                selectModel: 'leaf',
                store: DebtEleTreeStoreDB("DEBT_ZJYT", {condition: " and 1=1 and code!='0102' "})
            },
            {
                xtype: 'treecombobox',
                fieldLabel: '项目类型',
                name: 'YYXM_XMLX_ID',
                minPicekerWidth: 250,
                displayField: 'name',
                rootVisible: false,
                valueField: 'id',
                store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                // store: DebtEleTreeStoreJSON(json_debt_zwxmlx),
                editable: false
            },
            {
                xtype: 'combobox',
                fieldLabel: '建设状态',
                name: 'YYXM_BUILD_STATUS_ID',
                displayField: 'name',
                valueField: 'id',
                //store: DebtEleStore(json_debt_jszt),
                store: DebtEleTreeStoreDB("DEBT_XMJSZT"),
                editable: false
            },
            {
                fieldLabel: '模糊查询',
                xtype: 'textfield',
                name: 'YYXM_MHCX',
                columnWidth: .333,
                emptyText: '请输入项目编码/项目名称...',
                enableKeyEvents: true,
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            reloadYyxmGrid();
                        }
                    }
                }
            }, {
                xtype: 'combobox',
                fieldLabel: '申报年度',
                name: 'BILL_YEAR',
                // labelWidth: 70,
                width: 180,
                editable: false,
                value: nowDate.substr(0, 4),
                format: 'Y',
                hidden: (is_fxjh == 1 || is_fxjh == 4) ? false : true,
                labelAlign: 'right',
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"}),
                listeners: {
                    change: function (self, newValue) {
                        reloadYyxmGrid({
                            BILL_YEAR: newValue
                        });
                    }
                }
            }, {
                xtype: "combobox",
                name: "IS_SB",
                fieldLabel: '是否申报',
                displayField: 'name',
                valueField: 'id',
                value: 0,
                minValue: 0,
                store: DebtEleStore(s_is_sb),
                hidden: (is_fxjh == 3) ? false : true,
                allowBlank: false,
                editable: false,
                listeners: {
                    change: function (self, newvalue) {
                        if (!self.getValue()) {
                            IS_SB = self.up('form').down('combobox[name="IS_SB"]').getValue();
                            self.up('form').down('combobox[name="IS_SB"]').setValue(IS_SB);
                            return IS_SB;
                        }
                        reloadYyxmGrid({
                            IS_SB: newValue
                        });
                    }
                }
            },
            {
                fieldLabel: '重新申报',
                xtype: 'checkbox',
                name: 'IS_CXSB',
                hidden: is_fxjh == 0 ? false : true// 需求库下显示
            },
            {
                fieldLabel: '申报批次',
                name: 'SB_BATCH_NO',
                xtype: 'treecombobox',
                displayField: 'text',
                valueField: 'id',
                editable: false,
                hidden: is_fxjh == 0 ? false : true,// 需求库下显示
                store: sbpc_store
            }
        ],
        border: true,
        bodyStyle: 'border-width:0 0 0 0;',
        dock: 'top',
        // 查询按钮回调函数
        callback: function (self) {
            reloadYyxmGrid();
        }
    });
    search_form.remove(search_form.down('toolbar'));
    search_form.addDocked({
        xtype: 'toolbar',
        border: false,
        width: 100,
        dock: 'right',
        layout: {
            type: 'vbox',
            align: 'center'
        },
        items: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    //20210507 wq  需求库申报
                    if (is_fxjh == 0 && node_type == "jhtb") {
                        var form = btn.up('form').getForm();
                        var IS_CXSB = form.findField('IS_CXSB').getValue();
                        var SB_BATCH_NO = form.findField('SB_BATCH_NO').getValue();
                        if (IS_CXSB == true && isNull(SB_BATCH_NO)) {
                            Ext.Msg.alert('提示', "请先选择申报批次！");
                            return;
                        }
                    }
                    reloadYyxmGrid();
                }
            },
            {
                xtype: 'button',
                text: '重置',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    form.reset();
                }
            }
        ]
    });
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "XM_ID", type: "string", text: "项目id", hidden: true},
        {
            dataIndex: "XM_NAME", type: "string", text: "项目", width: 180,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                //return '<a href="javascript:void(0);" onclick="initWin_xmInfo(\'' + record.get('XM_ID') + '\,\'' + record.get('ID') + '\')">' + data + '</a>';
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                var paramValues = new Array();
                paramValues[0] = record.get('XM_ID');
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            dataIndex: "AUDIT_INFO",
            width: 250,
            type: "string",
            text: "初审通过意见",
            hidden: (is_zxzqxt == 1 && is_fxjh == 3) ? false : true,
            width: 130

        },
        {dataIndex: "LX_YEAR", type: "string", text: "立项年度"},
        {
            dataIndex: "CS_STATUS",
            width: 250,
            type: "string",
            text: "初审状态",
            hidden: is_fxjh == 5 || (is_zxzqxt == 1 && is_fxjh == 3) ? false : true,
            width: 130,
            renderer: function (value, metaData, record) {
                if (record.get('XMCS_END') == 1) {
                    if (is_fxjh == 5 || (is_zxzqxt == 1 && is_fxjh == 3)) {//初审流程
                        return '通过初审';
                    }
                } else {
                    if (is_fxjh == 5 || (is_zxzqxt == 1 && is_fxjh == 3)) {//初审流程
                        return '未通过初审';
                    }
                }
            }

        },
        {dataIndex: "AG_NAME", type: "string", width: 180, text: "建设单位"},
        {dataIndex: "JSXZ_NAME", type: "string", text: "建设性质"},
        {dataIndex: "XMXZ_NAME", type: "string", text: "项目性质"},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型"},
        {dataIndex: "BUILD_STATUS_NAME", type: "string", text: "建设状态 ", width: 150},
        {
            dataIndex: "XMZGS_AMT", type: "float", text: "项目总概算金额(万元) ", width: 150,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            /*summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00####');
            }*/
        },
        {dataIndex: "JYS_NO", type: "string", text: "项目建议书文号 ", width: 150},
        {dataIndex: "PF_NO", type: "string", text: "可研批复文号", width: 150}
    ];
    var url = 'getYyxmGrid.action';
    //发行，储备，以及需求纳入流程走一下方法还有初审在需求后
    if ((is_fxjh == 1 || is_fxjh == 4 || ((SYS_JOINXQK == '1') && is_fxjh == 0) || (DEBT_SYS_FRONTJOINXQK == '1' && (is_fxjh == '3' || is_fxjh == '5'))/*||(is_fxjh == 3 && is_zxzqxt == 1 && is_zxzq == 1)*/) && !is_zb) {
        //如果是发行计划，增加发行计划相关列
        url = 'getYyNdjhGrid.action';
        headerJson.shift();
        headerJson.unshift(
            {xtype: 'rownumberer', width: 45},
            /*     {
                     dataIndex: "APPLY_AMOUNT1", width: 160, type: "float", text: "本年申报数(万元)",
                     renderer: function (value) {
                         return Ext.util.Format.number(value / 10000, '0,000.00####');
                     },
                     summaryType: 'sum',
                     summaryRenderer: function (value) {
                         return Ext.util.Format.number(value / 10000, '0,000.00####');
                     }
                 },*/
            {
                dataIndex: "APPLY_AMOUNT_TOTAL", width: 160, type: "float", text: "申请总金额(万元)",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {dataIndex: "APPLY_DATE", type: "string", text: "申报日期"},
            {dataIndex: "BOND_TYPE_NAME", type: "string", text: "申请类型"}
        );
    }
    var grid = DSYGrid.createGrid({
        itemId: 'yyxmGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false,
            columnCls: 'normal'
        },
        flex: 1,
        dataUrl: url,
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        params: {
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_NAME: AG_NAME,
            BILL_YEAR: Ext.ComponentQuery.query('textfield[name="BILL_YEAR"]')[0].value,
            IS_ZXZQ: is_zxzq,
            IS_FXJH: is_fxjh,
            IS_ZXZQXT: is_zxzqxt,
            IS_YBZQXT: IS_YBZQXT,
            userCode: userCode,
            IS_SB: 0,//是否申报
            IS_ZXZQ: is_zxzq,
            GxdzUrlParam: GxdzUrlParam
        },
        autoLoad: true,
        checkBox: true,
        border: false,
        height: '100%',
        width: '100%',
        pageConfig: {
            enablePage: false
        },
        dockedItems: [search_form],
        features: [{
            ftype: 'summary'
        }]
        /*dockedItems: [
         {
         xtype: 'form',
         //style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
         layout: 'column',
         border: true,
         defaults: {
         labelWidth: 80,
         columnWidth: .333,
         labelAlign: 'left',
         margin: '3 5 3 5'
         },
         items: [
         {
         xtype: 'treecombobox',
         fieldLabel: '项目性质',
         name: 'YYXM_XMXZ_ID',
         displayField: 'name',
         valueField: 'id',
         rootVisible: false,
         lines: false,
         editable: false, //禁用编辑
         selectModel: 'leaf',
         store: DebtEleTreeStoreDB("DEBT_ZJYT")
         },
         {
         xtype: 'treecombobox',
         fieldLabel: '项目类型',
         name: 'YYXM_XMLX_ID',
         minPicekerWidth: 250,
         displayField: 'name',
         valueField: 'id',
         store: DebtEleTreeStoreJSON(json_debt_zwxmlx),
         editable: false
         },
         {
         xtype: 'combobox',
         fieldLabel: '建设状态',
         name: 'YYXM_BUILD_STATUS_ID',
         displayField: 'name',
         valueField: 'id',
         store: DebtEleStore(json_debt_jszt),
         editable: false
         },
         {
         fieldLabel: '模糊查询',
         xtype:'textfield',
         name: 'YYXM_MHCX',
         emptyText: '请输入项目编码/项目名称...',
         enableKeyEvents: true,
         listeners: {
         keypress: function (self, e) {
         if (e.getKey() == Ext.EventObject.ENTER) {
         reloadYyxmGrid();
         }
         }
         }
         }
         ],
         dockedItems: [
         {
         xtype: 'toolbar',
         border: false,
         dock: 'right',
         width: 80,
         layout: {
         type: 'vbox',
         align: 'center',
         pack: 'start'
         },
         items: [
         {
         xtype: 'button',
         text: '查询',
         icon: '/image/sysbutton/search.png',
         handler: function (btn) {
         reloadYyxmGrid();
         }
         },
         {
         xtype: 'button',
         text: '重置',
         icon: '/image/sysbutton/cancel.png',
         handler: function (btn) {
         var form = btn.up('form');
         form.reset();
         }
         }
         ]
         }
         ]
         }
         ]*/
    });
    return grid;
}

/**
 * 刷新已有项目表格
 */
function reloadYyxmGrid() {
    var YYXM_MHCX = Ext.ComponentQuery.query('textfield[name="YYXM_MHCX"]')[0].value;
    var YYXM_XMXZ_ID = Ext.ComponentQuery.query('treecombobox[name="YYXM_XMXZ_ID"]')[0].value;
    var YYXM_XMLX_ID = Ext.ComponentQuery.query('treecombobox[name="YYXM_XMLX_ID"]')[0].value;
    var YYXM_BUILD_STATUS_ID = Ext.ComponentQuery.query('combobox[name="YYXM_BUILD_STATUS_ID"]')[0].value;
    var IS_SB = Ext.ComponentQuery.query('combobox[name="IS_SB"]')[0].value;
    var SB_BATCH_NO = Ext.ComponentQuery.query('treecombobox[name="SB_BATCH_NO"]')[0].value;
    var IS_CXSB = Ext.ComponentQuery.query('checkbox[name="IS_CXSB"]')[0].value;

    var BILL_YEAR = Ext.ComponentQuery.query('textfield[name="BILL_YEAR"]')[0].value;
    var grid = DSYGrid.getGrid('yyxmGrid');
    var store = grid.getStore();
    //增加查询参数
    store.getProxy().extraParams["YYXM_MHCX"] = YYXM_MHCX;
    store.getProxy().extraParams["YYXM_XMXZ_ID"] = YYXM_XMXZ_ID;
    store.getProxy().extraParams["YYXM_XMLX_ID"] = YYXM_XMLX_ID;
    store.getProxy().extraParams["YYXM_BUILD_STATUS_ID"] = YYXM_BUILD_STATUS_ID;
    store.getProxy().extraParams["BILL_YEAR"] = BILL_YEAR;
    store.getProxy().extraParams["IS_SB"] = IS_SB;
    store.getProxy().extraParams["SB_BATCH_NO"] = SB_BATCH_NO;
    store.getProxy().extraParams["IS_CXSB"] = IS_CXSB;

    //刷新
    store.loadPage(1);
}

/**
 * 刷新绩效情况表格
 */
function reloadJxqkGrid() {
    var JXQK_XMLX_ID = Ext.ComponentQuery.query('treecombobox[name="JXQK_XMLX_ID"]')[0].value;
    var ZB_YEAR = Ext.ComponentQuery.query('combobox[name="ZB_YEAR"]')[0].value;
    var grid = DSYGrid.getGrid('jxqkGrid');
    var store = grid.getStore();
    //增加查询参数
    store.getProxy().extraParams["XM_ID"] = window_zqxxtb.XM_ID;
    store.getProxy().extraParams["JXQK_XMLX_ID"] = JXQK_XMLX_ID;
    store.getProxy().extraParams["ZB_YEAR"] = ZB_YEAR;
    //刷新
    store.loadPage(1);
}

/**
 * 比较实际开工日期与当前日期
 * @param form
 * @return {boolean}
 */
function compareActualStartDate(form) {
    var START_DATE_ACTUAL = form.down('[name=START_DATE_ACTUAL]').getValue();
    START_DATE_ACTUAL = Ext.util.Format.date(START_DATE_ACTUAL, 'Y-m-d');
    if (START_DATE_ACTUAL && START_DATE_ACTUAL > nowDate) {
        return false;
    }
    return true;
}

/**
 * 提交基本情况数据
 * @param form
 */

function submitXzzq(btn) {
    //获取基本情况页签表单
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
    var bcsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
    var XMLX_ID = jbqkForm.getForm().findField('XMLX_ID').getValue();
    var ZQLX_ID = bcsbForm.getForm().findField('BOND_TYPE_ID').getValue();
    //20210630 fzd 中小银行专项债券类型变更，修改提示语
    if (XMLX_ID == '30' && ZQLX_ID != '0203') {
        Ext.Msg.alert('提示', "项目类型为30的中小银行风险化解项目，只能选择债券类型为0203的补充银行资本金专项债券!");
        return false;
    }
    // 获取补充信息页签表单
    var bcxxForm = Ext.ComponentQuery.query('form[name="bcxxForm"]')[0];
    var csqkForm = Ext.ComponentQuery.query('form[name="csqkForm"]')[0];
    var FGW_XMK_CODE = jbqkForm.getForm().findField('FGW_XMK_CODE').getValue();
    if (FGW_XMK_CODE != '无' && !FGW_XMK_CODE.match("^[a-zA-Z0-9_-]*$")) {
        Ext.Msg.alert('提示', "发改委项目库编码仅可录“无”或字母数字编码");
        return false;
    }
    //投资计划页签
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    var TZJH_XMZGS_AMT = tzjhForm.getForm().findField("XMZGS_AMT").getValue();
    if (!jbqkForm.isValid()) {
        Ext.toast({
            html: "基本情况：请检查必填项，以及未通过校验项！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400,
            listeners: {
                "show": function () {
                    var i = findTabName('基本情况');
                    zqxxtbTab(i);
                }
            }
        });
        return false;
    }
    if (is_fxjh == 5) {
        if (!csqkForm.isValid()) {
            Ext.toast({
                html: "项目初审表：请检查必填项，以及未通过校验项！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400,
                listeners: {
                    "show": function () {
                        var i = findTabName('基本情况');
                        zqxxtbTab(i);
                    }
                }
            });
            return false;
        }
    }

    var message_error = null;
    var check_shouyi = jbqkForm.getForm().findField("XMXZ_ID").getValue();

    if (!comparePlanDate(jbqkForm)) {
        message_error = '计划开工日期应该早于计划竣工日期';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('基本情况');
            zqxxtbTab(i);
            return false;
        }
    }
    if (!compareActualDate(jbqkForm)) {
        message_error = '实际开工日期应该早于实际竣工日期';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('基本情况');
            zqxxtbTab(i);
            return false;
        }
    }
    if (!compareNowDateActualDate(jbqkForm)) {
        message_error = '实际竣工日期不应晚于当前时间';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('基本情况');
            zqxxtbTab(i);
            return false;
        }
    }
    if (!compareActualStartDate(jbqkForm)) {
        message_error = '实际开工日期不应晚于当前时间';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('基本情况');
            zqxxtbTab(i);
            return false;
        }
    }
    if (!compareBuildActualDate(jbqkForm)) {
        message_error = '建设状态为已完工或已竣工结算，实际开工日期和实际竣工日期不可为空！';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('基本情况');
            zqxxtbTab(i);
            return false;
        }
    }

    if (IS_XMBCXX == '1') {
        if (!bcxxForm.isValid()) {
            Ext.toast({
                html: "补充信息：请检查必填项，以及未通过校验项！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400,
                listeners: {
                    "show": function () {
                        var i = findTabName('补充信息');
                        zqxxtbTab(i);
                    }
                }
            });
            return false;
        }
        // guodg 2021091316 项目补充信息添加校验
        var bcxx15Field = bcxxForm.getForm().findField('BCXX15');
        if (bcxx15Field.getValue() != '1') {
            Ext.Msg.alert('提示', '项目实施方案中需要包含事前绩效评估内容，请确认!');
            setActiveTabPanelByTabTitle('补充信息');
            bcxx15Field.toggleInvalidCls(true);
            return false;
        }
    }
    if (is_fxjh != '5') {
        //获取本次申报页签表单
        var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
        if (!bnsbForm.isValid()) {
            Ext.toast({
                html: "本次申报：请检查必填项是否填写完整！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400,
                listeners: {
                    "show": function () {
                        var i = findTabName('本次申报');
                        zqxxtbTab(i);//跳转到本次申报页签
                    }
                }
            });
            return false;
        }
        // 本次申报页签校验
        if (bnsbForm.down('numberFieldFormat[name="APPLY_AMOUNT1"]').getValue() <= 0) {
            Ext.toast({
                html: "本次申报：请填写正确的申请金额！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400,
                listeners: {
                    "show": function () {
                        var i = findTabName('本次申报');
                        zqxxtbTab(i);//跳转到本次申报页签
                    }
                }
            });
            return false;
        }
        //校验当前申请金额是否符合控制数限制
        if (is_zxzqxt == '1' && is_zxzq != '2' && is_fxjh == '3' && SYS_ZXZQXT_KZS_CHECK == '1') {
            var res = checkKzs(bnsbForm);
            if (!res) {
                return false;
            }
        }
        //专项债券、is_fxjh=1时校验申请金额，发行库
        //if(is_zxzqxt=='1'&&is_zxzq=='1'&&is_fxjh=='1'){
        if (is_fxjh == '4') {
            var zsqje = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("ZJE").getValue();//年度项目申请总金额
            //var syje=DSYGrid.getGrid('bnsbGrid').getStore().sum('APPLY_AMOUNT1');//明细申请金额
            var syje = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("YSY").getValue();//已使用金额
            var bcsqje = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("APPLY_AMOUNT1").getValue();//本次申请金额
            var je = zsqje - syje - (button_status == 'add' ? bcsqje : 0);
            var je = zsqje - syje - bcsqje;
            if (je < 0) {//超过本年可使用限额，禁止再录入
                message_error = "本次申报：申请金额已超过项目总申请金额！";
                Ext.Msg.alert('提示', message_error);
                return false;
            }
        }
        if (is_fxjh == 1) {
            var sqje = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("FP_AMT").getValue();//年度项目申请金额
            var bcsqje = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("APPLY_AMOUNT1").getValue();//本次申请金额
            //2021031106_zhuangrx_因为只是校验单笔没有意义，所以先去掉
            /* if(bcsqje - sqje >0.0000001){//超过本年可使用限额，禁止再录入
                message_error = "本次申报：申请金额已超过申请金额！";
                Ext.Msg.alert('提示', message_error);
                return false;
            }*/
        }
        if (is_fxjh == 1) {
            var APPLY_AMOUNT1 = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("APPLY_AMOUNT1").getValue();
            var APPLY_NAME = bnsbForm.down('numberFieldFormat[name="APPLY_AMOUNT1"]').fieldLabel.replace("<span class=\"required\">✶</span>", "");
            var XZCZAP_AMT = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("XZCZAP_AMT").getValue();
            if (XZCZAP_AMT > APPLY_AMOUNT1) {
                Ext.Msg.alert("提示", "其中：新增赤字安排资金不能超过" + APPLY_NAME);
                return;
            }
        }

        if ((bnsbForm.down('treecombobox[name="BOND_TYPE_ID"]').getValue()).indexOf('02') == 0) {
            // if(is_zxzqxt=='1' && is_zxzq == '1' && is_fxjh!='1'){
            var XMXZ_ID = jbqkForm.down('treecombobox[name="XMXZ_ID"]').getValue(); //项目性质
            if (XMXZ_ID == '010101') {
                message_error = "本次申报：债券类型为专项债券时，项目性质不能为无自身收益的公益性项目！";
                Ext.Msg.alert('提示', message_error);
                var i = findTabName('本次申报');
                zqxxtbTab(i);//跳转到本次申报页签
                return false;
            }
            // }
            if (bnsbForm.down('numberFieldFormat[name="XMZSSYCH_AMT"]').getValue() == null) {
                /*message_error = "本次申报：债券类型为专项债券时，项目自身收益偿还金额不能为空！";
                Ext.Msg.alert('提示', message_error);
                zqxxtbTab(1);
                return false;*/
                bnsbForm.down('numberFieldFormat[name="XMZSSYCH_AMT"]').setValue(0);
            } else if (bnsbForm.down('numberFieldFormat[name="XMZSSYCH_AMT"]').getValue() < 0) {
                message_error = "本次申报：项目自身收益偿还金额不能为负数！";
                Ext.Msg.alert('提示', message_error);
                var i = findTabName('本次申报');
                zqxxtbTab(i);//跳转到本次申报页签
                return false;
            }
            /*if (bnsbForm.down('numberFieldFormat[name="ZFXJJCH_AMT"]').getValue() == null) {
                message_error = "本次申报：债券类型为专项债券时，政府性基金偿还金额不能为空！";
                Ext.Msg.alert('提示', message_error);
                zqxxtbTab(1);
                return false;
            } else if (bnsbForm.down('numberFieldFormat[name="ZFXJJCH_AMT"]').getValue() <= 0) {
                message_error = "本次申报：政府性基金偿还金额应大于0！";
                Ext.Msg.alert('提示', message_error);
                zqxxtbTab(1);
                return false;
            }
            if (bnsbForm.down('treecombobox[name="ZFXJJKM"]').getValue() == null||bnsbForm.down('treecombobox[name="ZFXJJKM"]').getValue() == "") {
                message_error = "本次申报：债券类型为专项债券时，政府性基金科目不能为空！";
                Ext.Msg.alert('提示', message_error);
                zqxxtbTab(1);
                return false;
            }*/
            var check_jjkm = bnsbForm.down('treecombobox[name="ZFXJJKM"]').getValue(); //基金科目
            var check_jjch = bnsbForm.down('numberFieldFormat[name="ZFXJJCH_AMT"]').getValue(); //基金偿还
            /*if (check_jjkm != null && check_jjkm != "" && (check_jjch == null || check_jjch == "" || check_jjch <= 0 || typeof(check_jjch) == 'undefined')) {
                message_error = "本次申报：政府性基金科目不为空时，政府性基金偿还金额应大于0！";
                Ext.Msg.alert('提示', message_error);
                zqxxtbTab(1);
                return false;
            }*/
            /*if (check_jjch != null && check_jjch > 0 && (check_jjkm == null || check_jjkm == "" || typeof(check_jjkm) == 'undefined')) {
                message_error = "本次申报：政府性基金偿还金额大于0时，政府性基金科目不能为空！";
                Ext.Msg.alert('提示', message_error);
                zqxxtbTab(1);
                return false;
            }*/
            var apply_amount1 = bnsbForm.down('numberFieldFormat[name="APPLY_AMOUNT1"]').getValue();
            var zfxjjch_amt = bnsbForm.down('numberFieldFormat[name="ZFXJJCH_AMT"]').getValue();
            var xmzssych_amt = bnsbForm.down('numberFieldFormat[name="XMZSSYCH_AMT"]').getValue();
            if (zfxjjch_amt == null || zfxjjch_amt == undefined) {
                zfxjjch_amt = 0;
            } else if (xmzssych_amt == null || xmzssych_amt == undefined) {
                xmzssych_amt = 0;
            }
            /*var check_amt = accAdd(zfxjjch_amt,xmzssych_amt);
            if (accSub(check_amt,apply_amount1) < 0 && Math.abs(accSub(check_amt,apply_amount1)) >= 0.01) {
                message_error = "本次申报：债券类型为专项债券时，项目自身收益偿还金额与政府性基金偿还金额之和应大于等于申请金额！";
                Ext.Msg.alert('提示', message_error);
                zqxxtbTab(1);
                return false;
            }*/
        }

        var bondtype = bnsbForm.getForm().findField("BOND_TYPE_ID");
        var XMLX_ID_temp = jbqkForm.getForm().findField("XMLX_ID");
        var SBBATCH_NO = bnsbForm.getForm().findField('SBBATCH_NO').getValue();
        var XZCZAP_AMT = bnsbForm.getForm().findField('XZCZAP_AMT').getValue();
        if (is_fxjh == 1 && (SBBATCH_NO == '98202002') && XZCZAP_AMT <= 0) {
            message_error = "本次申报：申报批次为“98202002 新增财政赤字直达基层申报批次”时，其中：新增赤字安排资金必须大于0！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('本次申报');
            zqxxtbTab(i);//跳转到本次申报页签
            return false;
        }
        if ((bondtype.getValue() == '020202' && XMLX_ID_temp.getValue().substring(0, 2) != '02')) {
            message_error = "本次申报：债券类型为收费公路专项债券时项目类型必须为公路下属的类型！";
            Ext.Msg.alert('提示', message_error);
            return false;
        }
        if ((bondtype.getValue() == '020201' && XMLX_ID_temp.getValue() != '05')) {
            message_error = "本次申报：债券类型为土地储备专项债券时项目类型必须为土地储备！";
            Ext.Msg.alert('提示', message_error);
            return false;
        }
        if ((bondtype.getValue() == '020203' && (XMLX_ID_temp.getValue().length < 4 || XMLX_ID_temp.getValue().substring(0, 4) != '0604'))) {
            message_error = "本次申报：债券类型为棚改专项债券时项目类型必须为棚户区改造！";

            Ext.Msg.alert('提示', message_error);
            return false;
        }

        var zbj_amt = bnsbForm.getForm().findField('ZBJ_AMT').getValue();
        var apply_amount1 = bnsbForm.getForm().findField('APPLY_AMOUNT1').getValue();
        if (zbj_amt - apply_amount1 > 0.0000001) {
            Ext.Msg.alert("提示", "项目资本金总额不能大于申请金额！");
            return;
        }
        if (is_fxjh == '0' || is_fxjh == '1' || is_fxjh == '3') {
            var zbj_amt = bnsbForm.getForm().findField('ZBJ_AMT').getValue();
            var is_xmzbj = bnsbForm.getForm().findField('IS_XMZBJ').getValue();
            if ((is_xmzbj == '0') && !(zbj_amt == '' || zbj_amt == 0)) {
                Ext.Msg.alert("提示", "项目资本金为否时资本金只能为0");
                return;
            }
        }
    }
    //获取投资计划页签表单
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
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    var ZBJ_AMT = tzjhForm.getForm().findField('ZBJ_AMT').getValue();
    var tzjhStore = DSYGrid.getGrid("tzjhGrid").getStore();
    var XMZGS_AMT = tzjhStore.sum('ZTZ_PLAN_AMT');
    var zbj_amt = tzjhForm.down('numberFieldFormat[name="ZBJ_AMT"]').getValue();
    var zbj_zq_amt = tzjhForm.down('numberFieldFormat[name="ZBJ_ZQ_AMT"]').getValue();
    var zbj_ys_amt = tzjhForm.down('numberFieldFormat[name="ZBJ_YS_AMT"]').getValue();
    if (zbj_amt - XMZGS_AMT > 0.00001) {
        Ext.Msg.alert('提示', '投资计划：项目资本金总额不得大于项目总概算!');
        return false;
    }
    if ((zbj_zq_amt + zbj_ys_amt) - zbj_amt > 0.00001) {
        Ext.Msg.alert('提示', '投资计划：其中财政预算安排资金与专项债券安排资金之和不得大于项目资本金总额!');
        return false;
    }

    var cjqyGridStore = DSYGrid.getGrid("xmcjqyGrid").getStore();
    if (is_fxjh == 1 && (SBBATCH_NO == '98202002') && cjqyGridStore.getCount() <= 0) {
        var i = findTabName('项目承建企业');
        zqxxtbTab(i);
        Ext.Msg.alert("提示", "申报批次为 98202002 新增财政赤字直达基层申报批次”时，必须录入项目承建企业信息！");
        return false;
    }
    var xmcjqyGrid = [];
    cjqyGridStore.each(function (record) {
        xmcjqyGrid.push(record.getData());
    });
    //湖北十大工程校验
    var sdgcGrid = [];
    DSYGrid.getGrid("sdgcGrid").getStore().each(function (record) {
        if (record.get('GCLB_ID') == null || record.get('GCLB_ID') == '' || record.get('GCLB_ID') == 'undefined') {
            message_error = "请选择十大工程页签“工程类别”列";
            return false;
        }
        sdgcGrid.push(record.getData());
    });
    //湖北专用
    if (sysAdcode == '42') {
        // 十大工程页签录入信息校验
        if (is_fxjh != '5') {
            if (DSYGrid.getGrid("sdgcGrid").getStore().getCount() <= 0) {
                message_error = "十大工程：必须录入十大工程！";
                Ext.Msg.alert('提示', message_error);
                return false;
            }
        }
        //校验项目总投资和投资计划总概算
        var sdgcStore = DSYGrid.getGrid("sdgcGrid").getStore();
        /*   if(parseFloat(sdgcStore.sum('XM_ZTZ')).toFixed(2)!=parseFloat(XMZGS_AMT).toFixed(2)){
            message_error = "十大工程页签“项目总投资”列必须等于项目总概算！";
            IS_XMBCXX == 1 ? zqxxtbTab(4) : zqxxtbTab(3);
            Ext.Msg.alert('提示', message_error);
            return false;
        }*/
        //校验需求总金额和需求库本次申报金额
        if (is_fxjh == '0') {
            if (sdgcStore.sum('XQ_AMT') != apply_amount1) {
                message_error = "十大工程页签“需求总金额”列必须等于本次申请金额！";
                Ext.Msg.alert('提示', message_error);
                return false;
            }
        }
        //校验储备总金额和储备库本次申报金额
        if (is_fxjh == '3') {
            if (sdgcStore.sum('CB_AMT') != apply_amount1) {
                message_error = "十大工程页签“储备总金额”列必须等于本次申请金额！";
                Ext.Msg.alert('提示', message_error);
                return false;
            }
        }
        //校验发行总金额和发行库本次申报金额
        if (is_fxjh == '1') {
            if (sdgcStore.sum('FX_AMT') != apply_amount1) {
                message_error = "十大工程页签“发行总金额”列必须等于本次申请金额！";
                Ext.Msg.alert('提示', message_error);
                return false;
            }
        }
    }
    var tzjhGrid = [];
    var tzjhNd = new Map();
    if (DSYGrid.getGrid("tzjhGrid").getStore().getCount() <= 0) {
        message_error = "投资计划：必须录入投资计划！";
        Ext.Msg.alert('提示', message_error);
        var i = findTabName('投资计划');
        zqxxtbTab(i);
        return false;
    } else {
        DSYGrid.getGrid("tzjhGrid").getStore().each(function (record) {
            if (record.get('ND') == null || record.get('ND') == '' || record.get('ND') == 'undefined') {
                message_error = "投资计划：请填写列表中“年度”列";
                var i = findTabName('投资计划');
                zqxxtbTab(i);
                return false;
            }
            if (typeof (tzjhNd.get(record.get('ND'))) != 'undefined') {
                message_error = "投资计划：列表中“年度”不能相同";
                var i = findTabName('投资计划');
                zqxxtbTab(i);
                return false;
            } else {
                tzjhNd.put(record.get('ND'), '');
            }
            if (is_fxjh != '5') {
                if (record.get('ND') == bnsbForm.getForm().findField('BILL_YEAR').getValue()) {
                    if (DSYGrid.getGrid("xmcjqyGrid").getStore().sum('PAY_XMCJSR_AMT') > record.get('ZTZ_PLAN_AMT')) {
                        message_error = "项目承建企业：最终支付给企业的项目承建收入总额不能超过该年度项目投资！";
                        var i = findTabName('项目承建企业');
                        zqxxtbTab(i);
                        return false;
                    }
                }
            }
            if (record.get('ZTZ_PLAN_AMT') <= 0 && record.get('ZTZ_ACTUAL_AMT') <= 0) {
                message_error = record.get('ND') + "年投资计划年度总投资不能为0！";
                return false;
            }
            /* if(record.get('ND') < nowDate.substr(0,4) && record.get('ZTZ_ACTUAL_AMT') <= 0 ){
                 message_error = "投资计划："+nowDate.substr(0,4)+"年度及其之前的投资计划年度总投资下的实际到位资金必须大于0！";
                 return false ;
             }*/
            tzjhGrid.push(record.getData());
        });
    }

    if (is_fxjh == 3) {
        var bcsqje = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0].getForm().findField("APPLY_AMOUNT1").getValue();//本次申请金额
        if (bcsqje - XMZGS_AMT > 0.0000001) {//申请金额超过项目总概算，禁止录入
            message_error = "本次申报：本次发行金额已超过项目总概算！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('本次申报');
            zqxxtbTab(i);//跳转到本次申报页签
            return false;
        }
    }

    if (message_error != null && message_error != '') {
        Ext.Msg.alert('提示', message_error);
        // zqxxtbTab(2);
        return false;
    }


    //获取收支平衡页签表单
    var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
    var szysGrid = xmsyForm.down('grid');
    // 收支平衡校验
    if (!xmsyForm.isValid()) {
        Ext.toast({
            html: "收支平衡：请检查是否填写正确！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400,
            listeners: {
                "show": function () {
                    var i = findTabName('收支平衡');
                    zqxxtbTab(i);
                }
            }
        });
        return false;
    }
    if (is_fxjh == '5') {
        var XMZGS_AMT = csqkForm.down('numberFieldFormat[name="XMZGS_AMT"]').getValue();
        var APPLY_AMOUNT1 = csqkForm.down('numberFieldFormat[name="APPLY_AMOUNT1"]').getValue();
        var CS_AMT1 = csqkForm.down('numberFieldFormat[name="CS_AMT1"]').getValue();
        var CS_AMT2 = csqkForm.down('numberFieldFormat[name="CS_AMT2"]').getValue();
        var CS_AMT3 = csqkForm.down('numberFieldFormat[name="CS_AMT3"]').getValue();
        var CS_AMT4 = csqkForm.down('numberFieldFormat[name="CS_AMT4"]').getValue();
        var ZWRZ_AMT = csqkForm.down('numberFieldFormat[name="ZWRZ_AMT"]').getValue();
        var ZBJ_AMT = csqkForm.down('numberFieldFormat[name="ZBJ_AMT"]').getValue();

        if (!(APPLY_AMOUNT1 == CS_AMT1 + CS_AMT2 + CS_AMT3 + CS_AMT4)) {
            message_error = "项目初审表：项目分年融资之和不等于专项债券融资";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('项目初审表');
            zqxxtbTab(i);
            return false;
        }
        if (ZWRZ_AMT > XMZGS_AMT) {
            message_error = "项目初审表：其他债务融资要小于项目总投资";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('项目初审表');
            zqxxtbTab(i);
            return false;
        }
        if (APPLY_AMOUNT1 > XMZGS_AMT) {
            message_error = "项目初审表：专项债券融资不能大于项目总投资";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('项目初审表');
            zqxxtbTab(i);
            return false;
        }
        if (ZBJ_AMT > APPLY_AMOUNT1) {
            message_error = "项目初审表：其中：作为资本金部分不能大于专项债券融资";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('项目初审表');
            zqxxtbTab(i);
            return false;
        }
    }
    var xmztr_amt = xmsyForm.down('numberFieldFormat[name="XMZTR_AMT"]').getValue(); // 项目预计总收入
    var xmzcb_amt = xmsyForm.down('numberFieldFormat[name="XMZCB_AMT"]').getValue(); // 项目预算总成本
    var zfxjjkm_id = xmsyForm.down('treecombobox[name="ZFXJJKM_ID"]').getValue();    // 项目对应的政府性基金科目
    var xm_used_date = xmsyForm.down('datefield[name="XM_USED_DATE"]').getValue();    // 项目投入使用日期
    var xm_used_limit = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();  // 项目运营期限

    if (isOld_szysGrid == '1' && is_fxjh != '5') {
        var xmsyform_temp = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0].getForm();
        if (szysGrid.getStore().sum('TOTAL_AMT') <= 0 && (bnsbForm.down('treecombobox[name="BOND_TYPE_ID"]').getValue() !== '01')) {
            message_error = "项目在申请专项债券时，必须录入收支平衡页签内容！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('收支平衡');
            zqxxtbTab(i);
            return false;
        }
        //收支平衡页签表单
        var xmsyform_temp = xmsyForm.getForm();
        if (szysGrid.getStore().sum('TOTAL_AMT') <= 0 && zfxjjkm_id != null && zfxjjkm_id != "" && zfxjjkm_id != undefined) {
            message_error = "收支平衡：项目对应的政府性基金科目不为空时，必须有收入！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('收支平衡');
            zqxxtbTab(i);
            return false;
        }
        if (szysGrid.getStore().sum('TOTAL_AMT') > 0 && ((zfxjjkm_id == null) || (zfxjjkm_id == "") || zfxjjkm_id == undefined)) {
            message_error = "收支平衡：项目收入合计不为0时，项目对应的政府性基金科目不可为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('收支平衡');
            zqxxtbTab(i);
            return false;
        }
        if (szysGrid.getStore().data.length > 0 && (((xm_used_date == null) || (xm_used_date == "") || xm_used_date == undefined) || ((xm_used_limit == null) || (xm_used_limit == "") || xm_used_limit == undefined))) {
            message_error = "收支平衡：项目投入使用日期或项目运营期限不能为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('收支平衡');
            zqxxtbTab(i);
            return false;
        }
        if (szysGrid.getStore().data.length <= 0 && (((xm_used_date != null) && (xm_used_date != "") && xm_used_date != undefined) || ((xm_used_limit != null) && (xm_used_limit != "") && xm_used_limit != undefined))) {
            message_error = "收支平衡：项目投入使用日期或项目运营期限不为空时，必须有收入！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('收支平衡');
            zqxxtbTab(i);
            return false;
        }
        //结束时的年度大小判断
        var XM_USED_DATE_int = parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4));
        var XM_USED_LIMIT_int = parseInt(xmsyform_temp.findField("XM_USED_LIMIT").getValue());
        var xm_xmsy_boolean = false;
        szysGrid.getStore().each(function (record) {
            if (!((parseInt(record.get('INCOME_YEAR')) >= XM_USED_DATE_int) && (parseInt(record.get('INCOME_YEAR')) <= (XM_USED_DATE_int + XM_USED_LIMIT_int)))) {
                message_error = "收支平衡:表中年度不能大于项目投入使用日期与项目运营期限之和，不能小于项目投入使用日期所在年度";
                xm_xmsy_boolean = true;
            }
        });
        if (xm_xmsy_boolean) {
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('收支平衡');
            zqxxtbTab(i);
            return false;
        }

        //获取收支平衡页签表格
        var xmsyGrid = [];
        var xmsyNd = new Map();
        szysGrid.getStore().each(function (record) {
            if (typeof record.get('INCOME_YEAR') == 'undefined' || record.get('INCOME_YEAR') == null || record.get('INCOME_YEAR').length <= 0) {
                message_error = '收支平衡：分年度收支预算的年度不能为空！';
                return false;
            }
            if (typeof (xmsyNd.get(record.get('INCOME_YEAR'))) != 'undefined') {
                message_error = "收支平衡：列表中“年度”不能相同";
                return false;
            } else {
                xmsyNd.put(record.get('INCOME_YEAR'), '');
            }
            if (typeof record.get('TOTAL_AMT') == 'undefined' || record.get('TOTAL_AMT') == null || record.get('TOTAL_AMT') <= 0) {
                message_error = record.get('INCOME_YEAR') + "年收入总计不能为 0";
                return false;
            }
            xmsyGrid.push(record.getData());
        });
    } else {
        if (xm_used_date != null && xm_used_date != "" && xm_used_date != undefined) {
            var lx_year = Ext.ComponentQuery.query('combobox[name="LX_YEAR"]')[0].getValue();
            var newValue = format(xm_used_date, 'yyyy');
            if (newValue < lx_year) {
                xmsyForm.down('datefield[name="XM_USED_DATE" ]').setValue('');
                message_error = "收支平衡：项目投入使用日期不可小于立项年度！";
                Ext.Msg.alert('提示', message_error);
                var i = findTabName('收支平衡');
                zqxxtbTab(i);
                return false;
            }
        }

        if (xmztr_amt <= 0 && zfxjjkm_id != null && zfxjjkm_id != "" && zfxjjkm_id != undefined) {
            message_error = "收支平衡：项目对应的政府性基金科目不为空时，必须录入项目预计总收入！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('收支平衡');
            zqxxtbTab(i);
            return false;
        }

        if (xmztr_amt > 0 && ((zfxjjkm_id == null) || (zfxjjkm_id == "") || zfxjjkm_id == undefined)) {
            message_error = "收支平衡：项目预计总收入不为0时，项目对应的政府性基金科目不可为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('收支平衡');
            zqxxtbTab(i);
            return false;
        }

        if (xmztr_amt <= 0 && ((xm_used_date != null && xm_used_date != "" && xm_used_date != undefined) || (xm_used_limit != null && xm_used_limit != "" && xm_used_limit != undefined))) {
            message_error = "收支平衡：开始日期或预算年限不为空时，必须录入项目预计总收入！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('收支平衡');
            zqxxtbTab(i);
            return false;
        }

        if (xmztr_amt > 0 && (((xm_used_date == null) || (xm_used_date == "") || xm_used_date == undefined) || ((xm_used_limit == null) || (xm_used_limit == "") || xm_used_limit == undefined))) {
            message_error = "收支平衡：项目预计总收入不为0时，开始日期和预算期限不能为空！";
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('收支平衡');
            zqxxtbTab(i);
            return false;
        }
        if (is_fxjh != '5') {
            // 如果项目类型非"土地储备" 则校验通用编制计划
            if (xmztr_amt <= 0 && (bnsbForm.down('treecombobox[name="BOND_TYPE_ID"]').getValue() !== '01')) {
                message_error = "项目在申请专项债券时，必须录入收支平衡页签内容！";
                Ext.Msg.alert('提示', message_error);
                var i = findTabName('收支平衡');
                zqxxtbTab(i);
                return false;
            }
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
                var i = findTabName('收支平衡');
                zqxxtbTab(i);
                return false;
            }
            if (!zfxjjkm_id) {
                Ext.Msg.alert('提示', '项目类型为土地储备时项目对应的政府性基金科目不能为空');
                var i = findTabName('收支平衡');
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
                    Ext.Msg.alert('提示', '土储项目应当实现年度收支平衡');
                    var i = findTabName('收支平衡');
                    zqxxtbTab(i);
                    return false;
                }

                pgsr_sum_amt += record_01.get(SR);
                zjzc_sum_amt += record_03.get(ZC);
            }
            if (pgsr_sum_amt < zjzc_sum_amt) {
                Ext.Msg.alert('提示', '土储项目应当实现总体收支平衡');
                var i = findTabName('收支平衡');
                zqxxtbTab(i);
                return false;
            }

        } else {
            // 对还本总金额进行校验
            var record_06 = szysGrid.getStore().getAt(gs_relation_guid["06"]);// 获取专项债券金额
            var record_0203 = szysGrid.getStore().getAt(gs_relation_guid["0202"]);// 获取地方政府专项债券金额
            var record_020201 = szysGrid.getStore().getAt(gs_relation_guid["020201"]);// 获取其中用于资本金
            var record_07 = szysGrid.getStore().getAt(gs_relation_guid["07"]);// 获取市场化融资金额
            var record_0204 = szysGrid.getStore().getAt(gs_relation_guid["0203"]);// 获取项目单位市场化融资金额
            var record_03 = szysGrid.getStore().getAt(gs_relation_guid["03"]);
            var record_0301 = szysGrid.getStore().getAt(gs_relation_guid["0301"]);
            var record_0302 = szysGrid.getStore().getAt(gs_relation_guid["0302"]);
            /* var record_01 = szysGrid.getStore().getAt(gs_relation_guid["01"]);
             var record_0101 = szysGrid.getStore().getAt(gs_relation_guid["0101"]);
             var record_0102 = szysGrid.getStore().getAt(gs_relation_guid["0102"]);*/
            var zxzqhb_amt = 0.00; // 专项债券还本总金额
            var zxzq_amt = 0.00;   // 专项债券总金额
            var schrzhb_amt = 0.00;// 市场化融资还本总金额
            var schrz_amt = 0.00;  // 市场化融资总金额
            // 循环计算所有年度总收入总支出合计值
            for (var i = 0; i <= yyqx_count; i++) {
                var SR = "SRAMT_Y" + i;
                var ZC = "ZCAMT_Y" + i;
                zxzqhb_amt += parseFloat(record_06.get(ZC) == "" ? 0 : record_06.get(ZC));
                zxzq_amt += parseFloat(record_0203.get(SR) == "" ? 0 : record_0203.get(SR));
                schrzhb_amt += parseFloat(record_07.get(ZC) == "" ? 0 : record_07.get(ZC));
                schrz_amt += parseFloat(record_0204.get(SR) == "" ? 0 : record_0204.get(SR));
                var dfzxzq_amt = parseFloat(record_0203.get(SR) == "" ? 0 : record_0203.get(SR));//2地方政府专项债券金额
                var qzsr = parseFloat(record_020201.get(SR) == "" ? 0 : record_020201.get(SR));//获取其中用于资本金
                var jsxmzc = parseFloat(record_03.get(ZC) == "" ? 0 : record_03.get(ZC));//建设项目支出03
                var cwzyzx = parseFloat(record_0301.get(ZC) == "" ? 0 : record_0301.get(ZC));//财务专用专项债券付息
                var cwzysc = parseFloat(record_0302.get(ZC) == "" ? 0 : record_0302.get(ZC));//市场化融资付息
                if (parseFloat(qzsr).toFixed(6) - parseFloat(dfzxzq_amt).toFixed(6) > 0.000001) {//20210420liyue添加用于资本金与地方专项校验
                    Ext.Msg.alert('提示', '其中：用于资本金不能大于地方政府专项债券金额！');
                    return false;
                }
                if (parseFloat(cwzyzx + cwzysc).toFixed(6) - parseFloat(jsxmzc).toFixed(6) > 0.000001) {//20210420liyue添加建设项目支出与其中金额校验
                    Ext.Msg.alert('提示', '其中：专项债券与市场化融资付息和不能大于项目建设支出！');
                    return false;
                }
            }
            if (Math.abs((parseFloat(zxzqhb_amt).toFixed(6) - parseFloat(zxzq_amt).toFixed(6)).toFixed(6)) > 0.000001) {
                Ext.Msg.alert('提示', '专项债券还本总金额应等于地方政府专项债券总金额！');
                return false;
            }
            if (Math.abs((parseFloat(schrzhb_amt).toFixed(6) - parseFloat(schrz_amt).toFixed(6)).toFixed(6)) > 0.000001) {
                Ext.Msg.alert('提示', '市场化融资还本总金额应等于项目单位市场化融资总金额！');
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
                        return false;
                    }
                }
            }*/
            /*if(BXFGBS_SX != '0' && BXFGBS_SX != 'null' && BXFGBS_SX != ''){
                if(bxfg.data.SRAMT_Y0 > parseFloat(BXFGBS_SX)){
                    Ext.Msg.alert('提示','本息覆盖倍数过大，请检查数据！');
                    return false;
                }
            }
            if(checkBxfgFromImport()){//本息覆盖倍数校验
                return false;
            }*/
            /*if (!(xm_used_date == null || (xm_used_date == "") || xm_used_date == undefined)){
                for (var n = 0; n <= yyqx_count; n++) {
                    var SR = "SRAMT_Y" + n;
                    var year = Number(xm_used_date.getFullYear()) + Number(n);
                    var sr_amt = (parseFloat(record_0101.get(SR).toFixed(6))) + (parseFloat(record_0102.get(SR).toFixed(6)));
                    if(parseFloat(sr_amt) > parseFloat(record_01.get(SR))){
                        Ext.Msg.alert('提示',''+year+'年，其中：财政运营补贴收入与其中：土地出让收入相加之和<br/>超出项目预期收入（预期资产评估价值）！');
                        return false;
                    }
                }
            }*/
        }

        szysGrid.getStore().each(function (record) {
            xmsyGrid.push(record.getData());
        });
    }

    if (message_error != null && message_error != '') {
        Ext.Msg.alert('提示', message_error);
        var i = findTabName('收支平衡');
        zqxxtbTab(i);
        return;
    }
    //校验项目评分表，评分项所属附件，以及在附件中位置必录不能为空
    var xmpfGridArray = [];
    //事务所数据数组
    var swsDataArray = [];
    //只在专项债券系统的限额库下获取
    //if(is_zxzqxt=='1' && is_zxzq == '1' && (is_fxjh=='1'||is_fxjh=='3')) {
    if ((HAVE_SFJG == '2' && is_fxjh == '1') || (HAVE_SFJG == '1' && is_fxjh == '3') || (HAVE_SFJG == '3' && (is_fxjh == '1' || is_fxjh == '3'))) {
        //项目评分表格
        var xmpfGrid = Ext.ComponentQuery.query('grid#xmpfGrid')[0];
        //20210723 zhuangrx 如果专家的评分项为空则不加载评分标准store
        if (!isNull(xmpfGrid)) {
            xmpfGrid.getStore().each(function (record) {
                //评分项序号
                var pfbz_order = record.get('PFBZ_ORDER');
                var file_name = record.get('FILE_NAME');
                var file_place = record.get('FILE_PLACE');
                if (file_name == '' || file_name == null || file_name == 'undefined') {
                    message_error = '第' + pfbz_order + '条评分项所在文件名称不能为空！';
                    return false;//跳出循环
                }
                if (file_place == '' || file_place == null || file_place == 'undefined') {
                    message_error = '第' + pfbz_order + '条评分项所在文件位置不能为空！';
                    return false;//跳出循环
                }
                xmpfGridArray.push(record.getData());
            });
        }

        //若没用通过校验，则显示错误信息，下面的代码不会执行
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            var i = findTabName('项目评分');
            zqxxtbTab(i);
            return;
        }
        //20210618 zhuangrx 河南专家评审不加三方机构内容
        if (is_fxjh != '5' && zjpslx == 'zqlx') {
            //获取附件表格里面的会计事务所，律师事务所字段值
            var lssws_id = Ext.ComponentQuery.query('treecombobox[name="LSSWS_ID"]')[0].getValue();
            var kjsws_id = Ext.ComponentQuery.query('treecombobox[name="KJSWS_ID"]')[0].getValue();
            if (((HAVE_SFJG == 2 && is_fxjh == '1') || (HAVE_SFJG == 1 && is_fxjh == '3') || (HAVE_SFJG == 3 && (is_fxjh == '3' || is_fxjh == '1')))
                && lssws_store.data.length > 0 && lssws_store.data.getAt(0).childNodes.length > 0 && !(!!lssws_id)
                && bnsbForm.down('treecombobox[name="BOND_TYPE_ID"]').getValue() !== '01'
                && !(is_zxzqxt == 1 && is_zxzq == 1 && sys_right_model == 1) && sysAdcode != '13') {
                Ext.Msg.alert('提示', "请选择律师事务所！");
                var i = findTabName('附件<span class="file_sum" style="color: #FF0000;">(0)</span>');
                zqxxtbTab(i);
                return false;
            } else if (((HAVE_SFJG == 2 && is_fxjh == '1') || (HAVE_SFJG == 1 && is_fxjh == '3') || (HAVE_SFJG == 3 && (is_fxjh == '3' || is_fxjh == '1')))
                && kjsws_store.data.length > 0 && kjsws_store.data.getAt(0).childNodes.length > 0 && !(!!kjsws_id)
                && bnsbForm.down('treecombobox[name="BOND_TYPE_ID"]').getValue() !== '01'
                && !(is_zxzqxt == 1 && is_zxzq == 1 && sys_right_model == 1) && sysAdcode != '13') {
                Ext.Msg.alert('提示', "请选择会计事务所！");
                var i = findTabName('附件<span class="file_sum" style="color: #FF0000;">(0)</span>');
                zqxxtbTab(i);
                return false;
            } else {
                swsDataArray.push({
                    'LSSWS_ID': !(!!lssws_id) ? undefined : lssws_id,
                    'KJSWS_ID': !(!!kjsws_id) ? undefined : kjsws_id
                });
            }
        }
    }
    //获取绩效情况页签表单
    var jxqkForm = {};
    //获取投资计划页签表格
    var jxqkGrid = [];
    // DSYGrid.getGrid("jxqkGrid").getStore().each(function (record) {
    //     jxqkGrid.push(record.getData());
    // });
    //获取固定资产页签表格
    var gdzcGrid = [];
    // DSYGrid.getGrid("gdzcGrid").getStore().each(function (record) {
    //     gdzcGrid.push(record.getData());
    // });
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    //var ID = window_zqxxtb.JH_ID;//'';
    /*    if (records != undefined && records != "" && records != "null") {
            ID = records[0].get("ID");
        }*/
    if (is_fxjh != '5') {
        var is_xmzbj = Ext.ComponentQuery.query('combobox[name="IS_XMZBJ"]')[0].value;
        var ZBJ_AMT = bnsbForm.down('numberFieldFormat[name="ZBJ_AMT"]').getValue()

        if (is_xmzbj == "1" && (ZBJ_AMT == null || ZBJ_AMT == 0)) {
            Ext.Msg.alert('提示', "本次申报页签的债券用于项目资本金金额未填写或为0!");
            var i = findTabName('本次申报');
            zqxxtbTab(i);//跳转到本次申报页签
            return false;
        }
    }
    var bnsbFormvalue = is_fxjh == 5 ? null : encode64('[' + Ext.util.JSON.encode(bnsbForm.getValues()) + ']');
    //发送ajax请求，提交数据
    btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    if (IS_XMBCXX == '1') {
        var params = {
            wf_id: wf_id,
            node_code: node_code,
            menucode: menucode,
            button_name: button_name,
            button_status: button_status,
            //audit_info: audit_info,
            ID: window_zqxxtb.JH_ID,
            XM_ID: window_zqxxtb.XM_ID,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_ID: AG_ID,
            AG_NAME: AG_NAME,
            BOND_TYPE_ID: bond_type_id,
            IS_FXJH: is_fxjh,
            HAVE_SFJG: HAVE_SFJG,
            node_type: node_type,
            is_fdq: is_fdq,
            isOld_szysGrid: isOld_szysGrid,
            IS_XMBCXX: IS_XMBCXX,
            jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
            bnsbForm: bnsbFormvalue,
            csqkForm: encode64('[' + Ext.util.JSON.encode(csqkForm.getValues()) + ']'),
            bcxxForm: encode64('[' + Ext.util.JSON.encode(bcxxForm.getValues()) + ']'),
            tzjhForm: encode64('[' + Ext.util.JSON.encode(tzjhForm.getValues()) + ']'),
            xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
            xmcjqyGrid: encode64(Ext.util.JSON.encode(xmcjqyGrid)),
            tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
            xmsyGrid: encode64(Ext.util.JSON.encode(xmsyGrid)),
            jxqkForm: encode64('[' + Ext.util.JSON.encode(jxqkForm) + ']'),
            jxqkGrid: encode64(Ext.util.JSON.encode(jxqkGrid)),
            gdzcGrid: encode64(Ext.util.JSON.encode(gdzcGrid)),
            xmpfGrid: encode64(Ext.util.JSON.encode(xmpfGridArray)),
            swsArray: encode64(Ext.util.JSON.encode(swsDataArray)),
            sdgcGrid: encode64(Ext.util.JSON.encode(sdgcGrid)),
            HAVE_ZSZJ: HAVE_ZSZJ
        };
    } else {
        var params = {
            wf_id: wf_id,
            node_code: node_code,
            menucode: menucode,
            button_name: button_name,
            button_status: button_status,
            //audit_info: audit_info,
            ID: window_zqxxtb.JH_ID,
            XM_ID: window_zqxxtb.XM_ID,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_ID: AG_ID,
            AG_NAME: AG_NAME,
            BOND_TYPE_ID: bond_type_id,
            IS_FXJH: is_fxjh,
            HAVE_SFJG: HAVE_SFJG,
            node_type: node_type,
            is_fdq: is_fdq,
            isOld_szysGrid: isOld_szysGrid,
            jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
            csqkForm: encode64('[' + Ext.util.JSON.encode(csqkForm.getValues()) + ']'),
            bnsbForm: bnsbFormvalue,
            tzjhForm: encode64('[' + Ext.util.JSON.encode(tzjhForm.getValues()) + ']'),
            xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
            xmcjqyGrid: encode64(Ext.util.JSON.encode(xmcjqyGrid)),
            tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
            xmsyGrid: encode64(Ext.util.JSON.encode(xmsyGrid)),
            jxqkForm: encode64('[' + Ext.util.JSON.encode(jxqkForm) + ']'),
            jxqkGrid: encode64(Ext.util.JSON.encode(jxqkGrid)),
            gdzcGrid: encode64(Ext.util.JSON.encode(gdzcGrid)),
            xmpfGrid: encode64(Ext.util.JSON.encode(xmpfGridArray)),
            swsArray: encode64(Ext.util.JSON.encode(swsDataArray)),
            sdgcGrid: encode64(Ext.util.JSON.encode(sdgcGrid)),
            HAVE_ZSZJ: HAVE_ZSZJ
        }
    }
    if (is_fxjh == '0' && ZQLX_ID.substr(0, 2) == '02') {
        let jxmbtbData = getJxmbtbAllDatas();
        if (!jxmbtbData) {
            btn.setDisabled(false);
            return false;
        }
        params.jxmbtbGrid = encode64(Ext.util.JSON.encode(jxmbtbData));
    }
    var bnsbFormvalue1 = is_fxjh == 5 ? null : Ext.util.JSON.encode([bnsbForm.getValues()]);
    $.post('/checkSaveXzzq.action', {
        AD_CODE: AD_CODE,
        IS_FXJH: is_fxjh,
        XM_ID: window_zqxxtb.XM_ID,
        button_status: button_status,
        bnsbForm: bnsbFormvalue1,
        IS_ZXZQXT: is_zxzqxt,
        IS_ZXZQ: is_zxzq,
        IS_XMZBJ: is_xmzbj,
        ZBJ_AMT: ZBJ_AMT,
        GxdzUrlParam: GxdzUrlParam,
        tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
        jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
        sdgcGrid: encode64(Ext.util.JSON.encode(sdgcGrid))
    }, function (data) {
        if (data.success || (is_fxjh == '5')) {
            //20201217 fzd 保存附件信息
            UploadPanel.saveExtraField('window_zqxxtb_contentForm_tab_xmfj_grid_xeksb', false);
            if (TZJH_XMZGS_AMT > 2000000) {
                Ext.onReady(function () {
                    Ext.MessageBox.show({
                        title: "提示",
                        msg: "投资计划页签中项目总概算金额超过200亿！",
                        fn: function (id, msg) {
                            if (id == "ok") {
                                $.post('/saveXzzq.action', params, function (data) {
                                    if (data.success) {
                                        Ext.toast({html: "保存成功！"});
                                        Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
                                        getKmJcsj((is_fxjh != 1 && is_fxjh != 4 && is_fxjh != 3) ? SET_YEAR : SET_YEAR + 1, true);
                                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                                    } else {
                                        Ext.MessageBox.alert('提示', data.message);
                                        btn.setDisabled(false);
                                    }
                                    //刷新表格
                                }, "json");
                            } else {
                                btn.setDisabled(false);
                            }
                        },
                        buttons: Ext.Msg.OKCANCEL,
                    });
                });
            } else {
                $.post('/saveXzzq.action', params, function (data) {
                    if (data.success) {
                        Ext.toast({html: "保存成功！"});
                        Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
                        getKmJcsj((is_fxjh != 1 && is_fxjh != 4 && is_fxjh != 3) ? SET_YEAR : SET_YEAR + 1, true);
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    } else {
                        Ext.MessageBox.alert('提示', data.message);
                        btn.setDisabled(false);
                    }
                    //刷新表格
                }, "json");
            }
        } else {
            Ext.MessageBox.alert('提示', data.message);
            btn.setDisabled(false);
        }
    }, "json");
}

/**
 * 加载页面数据
 * @param form
 */
function loadXzzq() {
    // 检验是否选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
        return;
    }
    var ID = window_zqxxtb.JH_ID;//records[0].get("ID");
    var XM_ID = window_zqxxtb.XM_ID;//records[0].get("XM_ID");
    //获取基本情况页签表单
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
    //获取初审情况页签表单
    var csqkForm = Ext.ComponentQuery.query('form[name="csqkForm"]')[0];
    //获取本次申报页签表单
    var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
    //获取补充信息页签表单
    var bcxxForm = Ext.ComponentQuery.query('form[name="bcxxForm"]')[0];
    //获取投资计划页签表单
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    //获取收支平衡页签表单
    var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
    jbqkForm.load({
        url: '/loadXzzq.action',
        params: {
            ID: ID,
            XM_ID: XM_ID,
            isOld_szysGrid: isOld_szysGrid,
            is_fxjh: is_fxjh,
            IS_ZXZQ: is_zxzq,
            IS_XMBCXX: IS_XMBCXX
        },
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            connNdjh = action.result.data.jbqkForm.CONNNDJH;
            connZwxx = action.result.data.jbqkForm.CONNZWXX;
            var xmlx_id = action.result.data.jbqkForm.XMLX_ID;
            //加载基本情况页签表单
            jbqkForm.getForm().setValues(action.result.data.jbqkForm);
            var ZJTXLY_ID = action.result.data.jbqkForm.ZJTXLY_ID;
            Ext.ComponentQuery.query('treecombobox[name="ZJTXLY_ID"]')[0].setValue(ZJTXLY_ID);
            //加载本次申报页签表单
            if (is_fxjh != '5') {
                bnsbForm.getForm().setValues(action.result.data.bnsbForm);
            } else {
                csqkForm.getForm().setValues(action.result.data.csqkForm);
            }
            if (IS_XMBCXX == '1') {
                //加载补充信息页签表单
                bcxxForm.getForm().setValues(action.result.data.bcxxForm);
            }
            //加载本次申报页签表格
            if (is_fxjh != '5') {
                var bnsbStore = action.result.data.bnsbGrid;
                var bnsbGrid = DSYGrid.getGrid('bnsbGrid');
                bnsbGrid.getStore().removeAll();
                bnsbGrid.insertData(null, bnsbStore);
                //专项债券系统 限额库下，为附件表格的律师事务所和会计事务所下拉框赋值
                //if(is_zxzqxt=='1' && is_zxzq == '1' && (is_fxjh == '1'||is_fxjh=='3')){
                if ((HAVE_SFJG == '2' && is_fxjh == '1') || (HAVE_SFJG == '1' && is_fxjh == '3') || (HAVE_SFJG == '3' && (is_fxjh == '3' || is_fxjh == '1'))) {
                    LSSWS_ID_VALUE = action.result.data.bnsbForm.LSSWS_ID;
                    KJSWS_ID_VALUE = action.result.data.bnsbForm.KJSWS_ID;
                }
            }
            // 加载“项目承建企业”页签表格
            if (is_fxjh == '1') {
                var xmcjqyStore = action.result.data.xmcjqyGrid;
                var xmcjqyGrid = DSYGrid.getGrid('xmcjqyGrid');
                xmcjqyGrid.getStore().removeAll();
                xmcjqyGrid.insertData(null, xmcjqyStore);
            }
            //加载投资计划表单
            var XMZGS_AMT = action.result.data.jbqkForm.XMZGS_AMT;
            var LJWCTZ_AMT = action.result.data.jbqkForm.LJWCTZ_AMT;
            var ZBJ_AMT = action.result.data.jbqkForm.ZBJ_AMT;
            var ZBJ_ZQ_AMT = action.result.data.jbqkForm.ZBJ_ZQ_AMT;
            var ZBJ_YS_AMT = action.result.data.jbqkForm.ZBJ_YS_AMT;
            Ext.ComponentQuery.query('numberFieldFormat[name="XMZGS_AMT"]')[0].setValue(XMZGS_AMT);
            Ext.ComponentQuery.query('numberFieldFormat[name="LJWCTZ_AMT"]')[0].setValue(LJWCTZ_AMT);
            Ext.ComponentQuery.query('form[name="tzjhForm"]')[0].down('numberFieldFormat[name="ZBJ_AMT"]').setValue(ZBJ_AMT);
            Ext.ComponentQuery.query('form[name="tzjhForm"]')[0].down('numberFieldFormat[name="ZBJ_ZQ_AMT"]').setValue(ZBJ_ZQ_AMT);
            Ext.ComponentQuery.query('form[name="tzjhForm"]')[0].down('numberFieldFormat[name="ZBJ_YS_AMT"]').setValue(ZBJ_YS_AMT);
            //tzjhForm.getForm().findField('ZBJ_AMT').setValue(ZBJ_AMT);
            // tzjhForm.down('numberFieldFormat[name="ZBJ_ZQ_AMT"]').setValue(ZBJ_ZQ_AMT);
            //tzjhForm.down('numberFieldFormat[name="ZBJ_YS_AMT"]').setValue(ZBJ_YS_AMT);
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
            //把十大工程的值set到填报页面里
            var sdgcStore = action.result.data.sdgcGrid;
            var sdgcGrid = DSYGrid.getGrid('sdgcGrid');
            sdgcGrid.getStore().removeAll();
            sdgcGrid.insertData(null, sdgcStore);
            calculateRzzjAmount(tzjhGrid);  //计算  投资计划总结
            initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
            initWindow_zqxxtb_contentForm_tab_csqk_refreshForm();

            //加载收支平衡页签表格
            if (isOld_szysGrid == '1') {
                var xmsyStore = action.result.data.xmsyGrid;
                for (var i = 0; i < xmsyStore.length; i++) {
                    xmsyStore[i].TOTAL_AMT = xmsyStore[i].YYSR_AMT + xmsyStore[i].CZBZ_AMT + xmsyStore[i].ZCBX_AMT + xmsyStore[i].QT_AMT;
                    xmsyStore[i].YSCB_HJ_AMT = xmsyStore[i].XM_YY_AMT + xmsyStore[i].ZJFY_AMT + xmsyStore[i].LXZC_AMT + xmsyStore[i].SFZC_AMT + xmsyStore[i].HBZC_AMT;
                }
                var xmsyGrid = DSYGrid.getGrid('xmsyGrid');
                xmsyGrid.getStore().removeAll();
                xmsyGrid.insertData(null, xmsyStore);
                if (xmsyStore && xmsyStore.length > 0) {
                    xmsyForm.down('treecombobox[name="ZFXJJKM_ID"]').setValue(typeof xmsyStore[0].ZFXJJKM_ID == 'undefined' ? '' : xmsyStore[0].ZFXJJKM_ID);
                    xmsyForm.down('datefield[name="XM_USED_DATE"]').setValue(typeof xmsyStore[0].XM_USED_DATE == 'undefined' ? '' : xmsyStore[0].XM_USED_DATE);
                    xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').setValue(typeof xmsyStore[0].XM_USED_LIMIT == 'undefined' ? '' : xmsyStore[0].XM_USED_LIMIT);
                    xmsyForm.down('textfield[name="REMARK"]').setValue(typeof xmsyStore[0].REMARK == 'undefined' ? '' : xmsyStore[0].REMARK);
                }
                // 刷新收支平衡页签表单信息
                initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
            }
            //判断是否第一单，若是第一单则基本情况可以修改，若不是第一单则不能修改
            var first_bill = records[0].get("FIRST_BILL");
            var xmfj = DSYGrid.getGrid('window_zqxxtb_contentForm_tab_xmfj_grid');
            if (first_bill == '0' || is_fxjh == 5) {
                jbqkForm.items.each(function (item1) {
                    if (item1.items != undefined && item1.items != "" && item1.items != "null") {
                        item1.items.each(function (item2) {
                            if (item2.items != undefined && item2.items != "" && item2.items != "null") {
                                item2.items.each(function (item) {
                                        if (item.name == 'BUILD_STATUS_ID'
                                            || item.name == 'START_DATE_ACTUAL'
                                            || item.name == 'END_DATE_ACTUAL'
                                            || item.name == 'YSXM_NO'
                                            || item.name == 'JYS_NO'
                                            || item.name == 'PF_NO'
                                            || item.name == 'BILL_PERSON'
                                            || item.name == 'BILL_PHONE'
                                            || item.name == 'BUILD_CONTENT'
                                            || item.name == 'UPPER_XM_ID'
                                            || item.name == (is_fxjh == 0 || is_fxjh == 3 ? 'MB_ID' : 'null')
                                            || item.name == 'ZJTXLY_ID'
                                            || item.name == 'GJZDZLXM_ID'
                                            || item.name == 'SS_ZGBM_ID'
                                            || item.name == 'XMSY_YCYJ'
                                            || item.name == 'GK_PAY_XMNO'
                                            || item.name == 'MB_ID'
                                            || item.name == 'GCLB_ID'
                                            || item.name == 'FGW_XMK_CODE'// 发改委审批监管代码
                                            || item.name == 'SS_ZGBM_ID'// 发改委审批监管代码
                                            || item.name == (is_fxjh == 3 ? 'IS_FGW_XM' : 'null')// 是否列入发改委重大项目库
                                        ) {
                                            if (item.name == 'SS_ZGBM_ID' && sysAdcode == '12' && is_fxjh == '1') {
                                                item.readOnly = true;
                                                item.editable = false;
                                                item.fieldCls = 'form-unedit';
                                                item.setFieldStyle('background:#E6E6E6');
                                                item.setReadOnly(true);
                                            }
                                        } else {
                                            if (item.getXType() == 'container' || item.getXType() == 'fieldcontainer' || item.getXType() == 'fieldset') {
                                                SetItemReadOnly(item.items);
                                                SetFormItemsReadOnly(item.items);
                                            } else {
                                                if (item.name == 'IS_PPP' || item.name == 'PPP_YZFS' || item.name == 'PPP_YZFS'
                                                    || item.name == 'PPP_HBFS' || item.name == 'PPP_SCJD' || item.name == 'PPP_SCJD' || item.name == 'PPP_RKQK_ID'
                                                    || item.name == 'XMJSQ_START' || item.name == 'XMJSQ_END' || item.name == 'XMYYQ_START' || item.name == 'XMYYQ_END' || item.name == 'IS_TGWUSZPJ'
                                                    || item.name == 'IS_TGCZCSNLLZ' || item.name == 'IS_XCCBSSFA' || item.name == 'HZQX'
                                                ) {
                                                    return;
                                                }
                                                //天津储备库主管部门支持修改
                                                if (is_fxjh == '3' && sysAdcode == '12' && item.name == 'SS_ZGBM_ID') {
                                                    item.readOnly = false;
                                                    item.editable = true;
                                                } else {
                                                    item.readOnly = true;
                                                    item.editable = false;
                                                }
                                                if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                                                    item.fieldCls = 'form-unedit';
                                                    if (item.getXType() == 'numberfield' || item.getXType() == 'numberFieldFormat') {
                                                        item.fieldCls = 'form-unedit-number';
                                                    }
                                                }
                                                if (item.setReadOnly && item.setFieldStyle) {
                                                    //天津储备库主管部门支持修改
                                                    if (is_fxjh == '3' && sysAdcode == '12' && item.name == 'SS_ZGBM_ID') {
                                                        item.setReadOnly(false);
                                                    } else {
                                                        item.setReadOnly(true);
                                                    }
                                                    if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                                                        //天津储备库主管部门支持修改
                                                        if (is_fxjh == '3' && sysAdcode == '12' && item.name == 'SS_ZGBM_ID') {

                                                        } else {
                                                            item.setFieldStyle('background:#E6E6E6');
                                                        }

                                                    }
                                                }
                                            }
                                            !!xmfj ? xmfj.editable = false : '';
                                        }
                                    }
                                );
                            }
                        });
                    }
                });
                //LxdwRender(xmlx_id);
            }
            if (tab_items.length > 0) {
                //加载项目只读页签数据
                $.post('getJSXMInfo.action', {
                    XM_ID: XM_ID,
                    isOld_szysGrid: isOld_szysGrid,
                    tab_items: Ext.util.JSON.encode(tab_items)
                }, function (data) {
                    var dataJson = Ext.util.JSON.decode(data);
                    if (dataJson.success) {
                        //加载存量债务页签表格
                        setClzwxx(dataJson);
                        //加载项目资产页签
                        setXmzcxx(dataJson);
                        //加载招投标页签表格
                        setZtbxx(dataJson);
                        //加载建设进度页签表格
                        setJsjdxx(dataJson);
                        //加载实际收益页签表格
                        setSjsyxx(dataJson);
                    } else {
                        alert('加载失败');
                        Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
                    }
                });
            }
        },
        failure: function (form, action) {
            alert('加载失败');
            Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
        }
    });
}

/**
 * 删除新增债券
 * @param form
 */
function deleteXzzq() {
    // 检验是否选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
        return;
    }
    //获取新增债券表格
    var xzzqArray = [];
    /*DSYGrid.getGrid("contentGrid").getStore().each(function (record) {
     xzzqArray.push(record.getData());
     });*/
    for (var i in records) {
        xzzqArray.push(records[i].getData());
    }
    /* var ID = '';
     if (records != undefined && records != "" && records != "null") {
     ID = records[0].get("ID");
     }*/

    //设置ajax请求参数
    var url = 'deleteXzzq.action';
    var params = {
        wf_id: wf_id,
        node_code: node_code,
        button_name: button_name,
        isOld_szysGrid: isOld_szysGrid,
        IS_FXJH: is_fxjh,
        //ID: ID,
        xzzqArray: encodeURIComponent(Ext.util.JSON.encode(xzzqArray))
    };
    //发送ajax请求，提交数据
    $.post(
        url,
        params,
        function (data) {
            if (data.success) {
                Ext.toast({
                    html: "删除成功！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
            } else {
                Ext.MessageBox.alert('提示', data.message);
            }
            //刷新表格
            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
            //Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
        },
        "json"
    );
}

/**
 * 加载已有项目新增页面数据
 * @param form
 */
function loadXzzq_Yyxm() {
    // 检验是否选中数据
    var records = DSYGrid.getGrid('yyxmGrid').getSelection();
    if (records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
        return;
    }
    var ID = records[0].get("ID");
    var XM_ID = records[0].get("XM_ID");
    //获取基本情况页签表单
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
    //获取本次申报情况页签表单
    var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
    //获取初审情况页签表单
    var csqkForm = Ext.ComponentQuery.query('form[name="csqkForm"]')[0];
    //获取补充信息页签表单
    var bcxxForm = Ext.ComponentQuery.query('form[name="bcxxForm"]')[0];
    //获取投资计划页签表单
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    //获取收支平衡页签表单
    var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
    //专项债券系统下的限额库使用
    //if(is_zxzqxt=='1' && is_zxzq=='1'&&(is_fxjh=='1'||is_fxjh=='3')){
    if ((HAVE_SFJG == '2' && is_fxjh == '1') || (HAVE_SFJG == '1' && is_fxjh == '3') || (HAVE_SFJG == '3' && (is_fxjh == '3' || is_fxjh == '1'))) {
        //初始化律师事务所，会计事务所全局变量
        LSSWS_ID_VALUE = null;
        KJSWS_ID_VALUE = null;
    }
    jbqkForm.load({
        url: 'loadXzzq.action',
        params: {
            ID: DEBT_SYS_FRONTJOINXQK == '1' || SYS_JOINXQK == '1' ? ID : '',
            XM_ID: XM_ID,
            isOld_szysGrid: isOld_szysGrid,
            is_fxjh: is_fxjh,
            IS_ZXZQ: is_zxzq,
            IS_XMBCXX: IS_XMBCXX
        },
        waitTitle: '请等待',
        waitMsg: '正在加载中...',
        success: function (form_success, action) {
            //加载基本情况页签表单
            connNdjh = action.result.data.jbqkForm.CONNNDJH;
            connZwxx = action.result.data.jbqkForm.CONNZWXX;
            jbqkForm.getForm().setValues(action.result.data.jbqkForm);
            if (IS_XMBCXX == '1') {
                bcxxForm.getForm().setValues(action.result.data.bcxxForm);
            }
            //加载本次申报页签表格
            if (is_fxjh != '5') {
                var bnsbStore = action.result.data.bnsbGrid;
                var bnsbGrid = DSYGrid.getGrid('bnsbGrid');
                bnsbGrid.getStore().removeAll();
                bnsbGrid.insertData(null, bnsbStore);
                // 加载“项目承建企业”页签表格
                if (is_fxjh == '1') {
                    var xmcjqyStore = action.result.data.xmcjqyGrid;
                    var xmcjqyGrid = DSYGrid.getGrid('xmcjqyGrid');
                    xmcjqyGrid.getStore().removeAll();
                    xmcjqyGrid.insertData(null, xmcjqyStore);
                }
            } else {
                csqkForm.getForm().setValues(action.result.data.csqkForm);
            }
            //需求库带出项目状态
            if (is_fxjh == '0') {
                bnsbForm.down('combobox[name="FILTER_STATUS_ID"]').setValue('01');
            } else if (is_fxjh == '1') {
                bnsbForm.down('combobox[name="FILTER_STATUS_ID"]').setValue('03');
            }
            //20210924 zhuangrx 需求库纳入流程时带出储备数据
            if (DEBT_SYS_FRONTJOINXQK == '1' || SYS_JOINXQK == '1' && is_fxjh == '0') {
                bnsbForm.getForm().setValues(action.result.data.bnsbForm);
            }
            //加载投资计划页签表格
            var tzjhStore = action.result.data.tzjhGrid;
            var tzjhGrid = DSYGrid.getGrid('tzjhGrid');
            tzjhGrid.getStore().removeAll();
            tzjhGrid.insertData(null, tzjhStore);
            initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
            initWindow_zqxxtb_contentForm_tab_csqk_refreshForm();
            if (tzjhGrid.getStore().getCount() > 0) {
                DSYGrid.getGrid("tzjhGrid").getStore().each(function (record) {
                    if (record.get("RZZJ_ACTUAL_AMT") <= 0) {
                        var RZZJ_XJ = record.get("RZZJ_YBZQ_AMT") + record.get("RZZJ_ZXZQ_AMT") + record.get("RZZJ_ZHZQ_AMT");
                        record.set("RZZJ_ACTUAL_AMT", RZZJ_XJ);
                    }
                });
            }
            var ZBJ_AMT = action.result.data.jbqkForm.ZBJ_AMT;
            var ZBJ_ZQ_AMT = action.result.data.jbqkForm.ZBJ_ZQ_AMT;
            var ZBJ_YS_AMT = action.result.data.jbqkForm.ZBJ_YS_AMT;
            tzjhForm.down('numberFieldFormat[name="ZBJ_AMT"]').setValue(ZBJ_AMT);
            tzjhForm.down('numberFieldFormat[name="ZBJ_ZQ_AMT"]').setValue(ZBJ_ZQ_AMT);
            tzjhForm.down('numberFieldFormat[name="ZBJ_YS_AMT"]').setValue(ZBJ_YS_AMT);
            //加载收支平衡页签表格
            if (isOld_szysGrid == '1') {
                var xmsyStore = action.result.data.xmsyGrid;

                for (var i = 0; i < xmsyStore.length; i++) {
                    xmsyStore[i].TOTAL_AMT = xmsyStore[i].YYSR_AMT + xmsyStore[i].CZBZ_AMT + xmsyStore[i].ZCBX_AMT + xmsyStore[i].QT_AMT;
                    xmsyStore[i].YSCB_HJ_AMT = xmsyStore[i].XM_YY_AMT + xmsyStore[i].ZJFY_AMT + xmsyStore[i].LXZC_AMT + xmsyStore[i].SFZC_AMT + xmsyStore[i].HBZC_AMT;
                }
                var xmsyGrid = DSYGrid.getGrid('xmsyGrid');
                xmsyGrid.getStore().removeAll();
                xmsyGrid.insertData(null, xmsyStore);
                if (xmsyStore && xmsyStore.length > 0) {
                    xmsyForm.down('treecombobox[name="ZFXJJKM_ID"]').setValue(typeof xmsyStore[0].ZFXJJKM_ID == 'undefined' ? '' : xmsyStore[0].ZFXJJKM_ID);
                    xmsyForm.down('datefield[name="XM_USED_DATE"]').setValue(typeof xmsyStore[0].XM_USED_DATE == 'undefined' ? '' : xmsyStore[0].XM_USED_DATE);
                    xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').setValue(typeof xmsyStore[0].XM_USED_LIMIT == 'undefined' ? '' : xmsyStore[0].XM_USED_LIMIT);
                }
                initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
            }
            //把十大工程的值set到填报页面里
            var sdgcStore = action.result.data.sdgcGrid;
            var sdgcGrid = DSYGrid.getGrid('sdgcGrid');
            sdgcGrid.getStore().removeAll();
            sdgcGrid.insertData(null, sdgcStore);
            //设置基本情况页签不可编辑
            //var xmfj = DSYGrid.getGrid('window_zqxxtb_contentForm_tab_xmfj_grid_xeksb');
            jbqkForm.items.each(function (item1) {
                if (item1.items != undefined && item1.items != "" && item1.items != "null") {
                    item1.items.each(function (item2) {
                        if (item2.items != undefined && item2.items != "" && item2.items != "null") {
                            item2.items.each(function (item) {
                                if (item.name == 'BUILD_STATUS_ID'
                                    || item.name == 'START_DATE_ACTUAL'
                                    || item.name == 'END_DATE_ACTUAL'
                                    || item.name == 'YSXM_NO'
                                    || item.name == 'JYS_NO'
                                    || item.name == 'PF_NO'
                                    || item.name == 'BILL_PERSON'
                                    || item.name == 'XM_ADDRESS'//2021060316_dengzq_项目地址可修改
                                    || item.name == 'BILL_PHONE'
                                    || item.name == 'BUILD_CONTENT'
                                    || item.name == 'UPPER_XM_ID'
                                    || item.name == (is_fxjh == 0 || is_fxjh == 3 ? 'MB_ID' : 'null')
                                    || item.name == 'ZJTXLY_ID'
                                    || item.name == 'GJZDZLXM_ID'
                                    || item.name == 'SS_ZGBM_ID'
                                    || item.name == 'XMSY_YCYJ'
                                    || item.name == 'GK_PAY_XMNO'
                                    || item.name == 'MB_ID'
                                    || item.name == 'GCLB_ID'
                                    || item.name == 'FGW_XMK_CODE'// 发改委审批监管代码
                                    || item.name == 'SS_ZGBM_ID'// 发改委审批监管代码
                                    || item.name == (is_fxjh == 3 ? 'IS_FGW_XM' : 'null')// 是否列入发改委重大项目库
                                ) {
                                    if (item.name == 'SS_ZGBM_ID' && sysAdcode == '12' && is_fxjh == '1') {
                                        item.readOnly = true;
                                        item.editable = false;
                                        item.fieldCls = 'form-unedit';
                                        item.setFieldStyle('background:#E6E6E6');
                                        item.setReadOnly(true);
                                    }
                                } else {
                                    if (item.getXType() == 'container' || item.getXType() == 'fieldcontainer' || item.getXType() == 'fieldset') {
                                        SetItemReadOnly(item.items);
                                        SetFormItemsReadOnly(item.items);
                                    } else {
                                        if (item.name == 'IS_PPP' || item.name == 'PPP_YZFS' || item.name == 'PPP_YZFS'
                                            || item.name == 'PPP_HBFS' || item.name == 'PPP_SCJD' || item.name == 'PPP_SCJD' || item.name == 'PPP_RKQK_ID'
                                            || item.name == 'XMJSQ_START' || item.name == 'XMJSQ_END' || item.name == 'XMYYQ_START' || item.name == 'XMYYQ_END' || item.name == 'IS_TGWUSZPJ'
                                            || item.name == 'IS_TGCZCSNLLZ' || item.name == 'IS_XCCBSSFA' || item.name == 'HZQX'
                                        ) {
                                            return;
                                        }
                                        //天津储备库主管部门支持修改
                                        if (is_fxjh == '3' && sysAdcode == '12' && item.name == 'SS_ZGBM_ID') {
                                            item.readOnly = false;
                                            item.editable = true;
                                        } else {
                                            item.readOnly = true;
                                            item.editable = false;
                                        }
                                        if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                                            item.fieldCls = 'form-unedit';
                                            if (item.getXType() == 'numberfield' || item.getXType() == 'numberFieldFormat') {
                                                item.fieldCls = 'form-unedit-number';
                                            }
                                        }
                                        if (item.setReadOnly && item.setFieldStyle) {
                                            //天津储备库主管部门支持修改
                                            if (is_fxjh == '3' && sysAdcode == '12' && item.name == 'SS_ZGBM_ID') {
                                                item.setReadOnly(false);
                                            } else {
                                                item.setReadOnly(true);
                                            }
                                            if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                                                //天津储备库主管部门支持修改
                                                if (is_fxjh == '3' && sysAdcode == '12' && item.name == 'SS_ZGBM_ID') {

                                                } else {
                                                    item.setFieldStyle('background:#E6E6E6');
                                                }

                                            }
                                        }
                                    }
                                    //20201218 fzd 发行库遴选项目时附件可补录信息（第三方单位名称等）
                                    //!!xmfj?xmfj.editable=false:'';
                                }
                            });
                        }
                    });
                }
            });//LxdwRender();已有项目时不显示单位选项
            calculateRzzjAmount(tzjhGrid);  //计算  投资计划总结
            if (tab_items.length > 0) {
                //加载项目只读页签数据
                $.post('getJSXMInfo.action', {
                    XM_ID: XM_ID,
                    isOld_szysGrid: isOld_szysGrid,
                    tab_items: Ext.util.JSON.encode(tab_items)
                }, function (data) {
                    var dataJson = Ext.util.JSON.decode(data);
                    if (dataJson.success) {
                        //加载存量债务页签表格
                        setClzwxx(dataJson);
                        //加载项目资产页签
                        setXmzcxx(dataJson);
                        //加载招投标页签表格
                        setZtbxx(dataJson);
                        //加载建设进度页签表格
                        setJsjdxx(dataJson);
                        //加载实际收益页签表格
                        setSjsyxx(dataJson);
                    } else {
                        alert('加载失败');
                        Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
                    }
                });
            }
        },
        failure: function (form, action) {
            alert('加载失败');
            Ext.ComponentQuery.query('window[name="xzzqWin"]')[0].close();
        }
    });
}

/*function  checkbcsb(){
    var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm"]')[0];
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
    var XMLX_ID_temp=jbqkForm.getForm().findField("XMLX_ID");
    var bondtype=bnsbForm.getForm().findField("BOND_TYPE_ID");
    if(XMLX_ID_temp.getValue()=='05'){
        bondtype.setValue('020201');
        bondtype.fieldStyle = 'background:#E6E6E6';
        bnsbForm.getForm().findField("BOND_TYPE_ID").readOnly = true;
    }
    if(XMLX_ID_temp.getValue().substring(0,2)=='02'){
        bondtype.setValue('020202');
        bondtype.fieldStyle = 'background:#E6E6E6';
        bondtype.readOnly = true;
    }
}*/
function LxdwRender(xmlx_id) {
    var field_names;
    var max_values;
    if (xmlx_id == '05') {
        field_names = '<span class="required">✶</span>土地面积(公顷)';
        max_values = 1000000;
        var DISC = Ext.ComponentQuery.query('textfield[name="DISC"]')[0];
        DISC.allowBlank = false;
        var $a1 = '<span class="required">✶</span>国土部门监管码';
        DISC.setFieldLabel($a1);
    } else {
        var DISC = Ext.ComponentQuery.query('textfield[name="DISC"]')[0];
        DISC.allowBlank = true;
        var $a1 = '国土部门监管码';
        DISC.setFieldLabel($a1);
    }
    if (xmlx_id.substring(0, 2) == '02') {
        field_names = '<span class="required">✶</span>通车里程(公里)';
        max_values = 10000;
    }
    var rink = Ext.ComponentQuery.query('numberFieldFormat[name="LXDW"]')[0];
    if (xmlx_id == '05' || xmlx_id.substring(0, 2) == '02') {
        var rink = Ext.ComponentQuery.query('numberFieldFormat[name="LXDW"]')[0]//.setVisible(true);
        rink.setFieldLabel(field_names);
        rink.maxValue = max_values;
        rink.allowBlank = false;
        rink.setVisible(true);
    }
}

/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var isTzXms = [];
    var ids = [];
    var xm_ids = [];
    var is_ends = [];
    var mb_ids = [];
    for (var i in records) {
        ids.push(records[i].get("ID"));
        xm_ids.push(records[i].get("XM_ID"));
        is_ends.push(records[i].get("IS_END"));
        mb_ids.push(records[i].get("MB_ID"));
        if (records[i].get("IS_TZ") == '1') {//需要校验实施方案的项目
            isTzXms.push(records[i].get("XM_ID"));
        }
    }
    var zqlxIds = [];//BOND_TYPE_ID
    //限额库 送审时执行
    if ((is_fxjh == '1' || is_fxjh == '4' || is_fxjh == '3') && btn.name === 'down') {
        //获取债券类型
        for (var i in records) {
            zqlxIds.push(records[i].get("BOND_TYPE_ID"));
        }
        //对获取的ZQLX_ID去重 借助indexOf()方法判断此元素在该数组中首次出现的位置下标与循环的下标是否相等
        if (zqlxIds.length > 1) {
            for (var i = 0; i < zqlxIds.length; i++) {
                if (zqlxIds.indexOf(zqlxIds[i]) != i) {
                    zqlxIds.splice(i, 1);//删除数组元素后数组长度减1后面的元素前移
                    i--;//数组下标回退
                }
            }
        }
    }
    button_name = btn.text;
    button_status = btn.name;
    //增加送审时项目金额校验
    if ((is_fxjh == '1') && btn.name === 'down' && SYS_XZZQJH_XE_CHECK && SYS_XZZQJH_XE_CHECK !== '0') {
        var xeRec = DSYGrid.getGrid('contentXEGrid').getStore();
        if (xeRec.getCount() <= 0) {
            return xeqkz('限额为空！');
        }
        var ybxe = xeRec.getAt(0).get('SY_YB_AMT') / 10000;
        var yb = null;

        if (DEBT_ZXXEKZFS == '1') {//专项限额控制方式
            var zx_tcxe = xeRec.getAt(0).get('SY_ZX_TC_AMT') / 10000;//土储剩余限额
            var zx_glxe = xeRec.getAt(0).get('SY_ZX_GL_AMT') / 10000;//公路剩余限额
            var zx_pgxe = xeRec.getAt(0).get('SY_ZX_PG_AMT') / 10000;//棚改剩余限额
            var zx_qtxe = xeRec.getAt(0).get('SY_ZX_QT_AMT') / 10000;//其他自平衡、普通专项剩余限额
            var zx_tc = null;
            var zx_gl = null;
            var zx_pg = null;
            var zx_qt = null;
            for (var i in records) {
                if (records[i].get("BOND_TYPE_ID") == '01') {
                    yb = yb ? yb : 0;
                    yb += records[i].get("APPLY_AMOUNT1");
                } else {
                    if (records[i].get("BOND_TYPE_ID") == '020201') {//土地储备
                        zx_tc = zx_tc ? zx_tc : 0;
                        zx_tc += records[i].get("APPLY_AMOUNT1");
                    } else if (records[i].get("BOND_TYPE_ID") == '020202') {//收费公路
                        zx_gl = zx_gl ? zx_gl : 0;
                        zx_gl += records[i].get("APPLY_AMOUNT1");
                    } else if (records[i].get("BOND_TYPE_ID") == '020203') {//棚改
                        zx_pg = zx_pg ? zx_pg : 0;
                        zx_pg += records[i].get("APPLY_AMOUNT1");
                    } else if (records[i].get("BOND_TYPE_ID") == '0201' || records[i].get("BOND_TYPE_ID") == '020299') {//其他自平衡
                        zx_qt = zx_qt ? zx_qt : 0;
                        zx_qt += records[i].get("APPLY_AMOUNT1");
                    }
                }
            }
            if (zx_tc && zx_tc > zx_tcxe) {//土地储备
                return xeqkz('超出新增土地储备专项债券剩余限额!');
            } else if (zx_gl && zx_gl > zx_glxe) {//收费公路
                return xeqkz('超出新增收费公路专项债券剩余限额!');
            } else if (zx_pg && zx_pg > zx_pgxe) {//棚改
                return xeqkz('超出新增棚改专项债券剩余限额!');
            } else if (zx_qt && zx_qt > zx_qtxe) {//其他自平衡
                return xeqkz('超出其他专项债券剩余限额!');
            }
        } else {
            var zxxe = xeRec.getAt(0).get('SY_ZX_AMT') / 10000;
            var zx = null;
            for (var i in records) {
                if (records[i].get("BOND_TYPE_ID") == '01') {
                    yb = yb ? yb : 0;
                    yb += records[i].get("APPLY_AMOUNT1");
                } else {
                    zx = zx ? zx : 0;
                    zx += records[i].get("APPLY_AMOUNT1");
                }
            }
            if (zx && zx > zxxe) {
                return xeqkz('超出专项债券剩余限额!');
            }
        }
        if (yb && yb > ybxe) {
            return xeqkz('超出一般债券剩余限额!');
        }
    }
    Ext.Msg.confirm('提示', '确认' + button_name + '选中记录?', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            if (button_status == "down" && button_name == "送审") {//只有送审才校验，其他操作不校验
                //发送ajax请求，修改节点信息
                $.post("checkSzsj.action", {//20210727liyue校验收支平衡不符合规格数据，如果成功则可以继续送审，如不成功则展示不成功数据
                    workflow_direction: button_status,
                    node_code: node_code,
                    ids: ids,
                    IS_XMSZPHJY: IS_XMSZPHJY
                }, function (data) {
                    //校验中数据都通过情况下，默认级别为0，直接走工作流
                    if (data.list[0].CHECK_LEVEL == 0 && button_status == "down") {
                        doXzzq(ids, xm_ids, is_ends, mb_ids, isTzXms, zqlxIds);
                    }
                    if (data.list[0].CHECK_LEVEL == 2 && button_status == "down") {
                        Ext.onReady(function () {
                            Ext.MessageBox.buttonText.yes = "查看";
                            Ext.MessageBox.buttonText.no = "取消";
                            Ext.MessageBox.show({
                                title: '提示：',
                                msg: '送审数据中，项目信息存在不合规格项，请检查数据并在修改后，继续送审！',
                                modal: true,
                                buttons: Ext.Msg.YESNO, fn: function (btn_confirm, msgs) {
                                    if (btn_confirm == "yes") {//查看
                                        showwindows(ids);
                                    }
                                    Ext.MessageBox.buttonText.yes = "是";
                                    Ext.MessageBox.buttonText.no = "否";
                                }
                            });
                        });
                    }
                    //级别为1的情况下，提示性信息，点击查看可查看提示项，也可直接送审
                    if (data.list[0].CHECK_LEVEL == 1 && button_status == "down") {
                        Ext.onReady(function () {
                            Ext.MessageBox.buttonText.yes = "送审";
                            Ext.MessageBox.buttonText.no = "查看";
                            Ext.MessageBox.buttonText.cancel = "取消";
                            Ext.MessageBox.show({
                                title: '提示：',
                                msg: '送审数据中，存在建议性数据问题，可查看提示信息，若无需修改数据，可直接进行送审操作',
                                modal: true,
                                buttons: Ext.Msg.YESNOCANCEL, fn: function (btn_confirm, msgs) {
                                    if (btn_confirm == "yes") {//送审
                                        doXzzq(ids, xm_ids, is_ends, mb_ids, isTzXms, zqlxIds);
                                    }
                                    if (btn_confirm == "no") {//查看
                                        showwindows(ids);
                                    }
                                    Ext.MessageBox.buttonText.yes = "是";//已经改成这样了
                                    Ext.MessageBox.buttonText.no = "否";//已经改成这样了
                                }
                            });
                        });
                    }
                }, "json");
            } else {
                doXzzq(ids, xm_ids, is_ends, mb_ids, isTzXms, zqlxIds);
            }

        }
    });
}

/*/!*重平台报表panle方法*!/
function initReportQueryPanel(q_code, q_condition, closeHidden, paramShow) {

    code = q_code;
    condition = q_condition;
    loadReport(code, condition, paramShow);
/!*
    var panel = initPanel();
*!/
    if (conditionItems.length == 0) {
        Ext.ComponentQuery.query('button#report_query_search')[0].setHidden(true);
    }
    if (closeHidden == 'hidden') {
        Ext.ComponentQuery.query('button#report_query_close')[0].setHidden(true);
    }

        Ext.ComponentQuery.query('button[name="oftenUsed"]')[0].setHidden(true);
        Ext.ComponentQuery.query('button[name="screen"]')[0].setHidden(true);
        Ext.ComponentQuery.query('button#report_query_return')[0].setHidden(true);

    if (exportLevel == 0) {
        Ext.ComponentQuery.query('button[name="export"]')[0].setHidden(true);
        Ext.ComponentQuery.query('button[name="print"]')[0].setHidden(true);
        Ext.ComponentQuery.query('button[name="export"]')[0].setDisabled(false);
    } else {
        Ext.ComponentQuery.query('button[name="export"]')[0].setDisabled(false);
        Ext.ComponentQuery.query('button[name="export"]')[0].setHidden(false);
        Ext.ComponentQuery.query('button[name="print"]')[0].setHidden(false);
    }

    if (!!!qRemark) {
        Ext.ComponentQuery.query('button#report_query_remark')[0].setHidden(true);
    }
    if (iflfptmof == 1 && !isNull(gnsqUrl)) {
        Ext.ComponentQuery.query('button#report_query_gnsq')[0].setHidden(false);
        Ext.ComponentQuery.query('button#report_query_gnsq')[0].setText(gnsqName);
    }

    // fieldConf(fieldList);
    // var reportGrid = DSYGrid.getGrid('reportQueryGrid'+q_code);
    // reportGrid.reconfigure(null,columns);
    // Ext.resumeLayouts(true);
    if (is_openrun == 1) {
        // setTimeout(function () {
        reloadStore(true);
        // }, 100);
    }
    ;
    //return panel;
};*/
function getKmJcsj(year, autoLoad) {
    var condition_str = year <= 2017 ? " <= '2017' " : " = '" + year + "' ";
    zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '1050402%' or code like '1101102%') and year " + condition_str);
    zcgnfl_store.proxy.extraParams['condition'] = encode64(" and year " + condition_str);
    zcjjfl_store.proxy.extraParams['condition'] = encode64(" and year " + condition_str);

    sbpc_store.proxy.extraParams['BATCH_YEAR'] = year;
    sbpc_store.proxy.extraParams['BOND_TYPE'] = isNull(BATCH_BOND_TYPE_ID) ? "" : BATCH_BOND_TYPE_ID.substr(0, 2);
    sbpc_store.proxy.extraParams['AD_CODE'] = AD_CODE;
    sbpc_store.proxy.extraParams['is_fxjh'] = is_fxjh;
    //20210803 chenfei
    //sbpc_store.proxy.extraParams['TYPE'] = 'jhtb';
    if (autoLoad) {
        getKmStoreLoad();
    }
}

function getKmStoreLoad() {
    zwsrkm_store.load();
    zcgnfl_store.load();
    zcjjfl_store.load();
    sbpc_store.load();
}

/*
*撤销初审机构评审状态
*/
function backpszt(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("ID"));
    }
    button_name = btn.name;
    $.post('saveSfjg_fj.action', {
        bill_id: ids,
        HAVE_SFJG: HAVE_SFJG,
        IS_FXJH: is_fxjh,
        JG_TYPE: jg_type,
        USER_ID: USER_ID,
        BUTTON_NAME: button_name
    }, function (data) {
        if (data.success) {
            Ext.toast({html: "撤销成功！"});
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
        reloadGrid();//刷新表格
    }, "json");
}

//初始化会计所、事务所上传附件框
function initWin_xmInfo_cp_scfj(xm_id, bill_id) {
    var zwqxWindow = new Ext.Window({
        title: '项目总体情况',
        //itemId: 'xmxxWin',
        width: document.body.clientWidth * 0.95,
        height: document.body.clientHeight * 0.95,
        maximizable: true,//最大化按钮
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: true,//大小不可改变
        closeAction: 'destroy',
        layout: 'fit',
        items: [initWin_xmInfo_contentForm(tab_items_scfj, xm_id)],
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    if (jg_type == '2') {
                        var csqkForm = Ext.ComponentQuery.query('form[name="csqkForm_common"]')[0];
                        var bill_id = csqkForm.getValues().ID;
                    } else {
                        var bnsbForm = Ext.ComponentQuery.query('form[name="bnsbForm_common"]')[0];
                        var bill_id = bnsbForm.getValues().ID;
                    }
                    $.post('saveSfjg_fj.action', {
                        bill_id: bill_id,
                        HAVE_SFJG: HAVE_SFJG,
                        IS_FXJH: is_fxjh,
                        JG_TYPE: jg_type,
                        USER_ID: USER_ID
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({html: "保存成功！"});
                        } else {
                            Ext.MessageBox.alert('提示', data.message);
                            btn.setDisabled(false);
                        }
                        reloadGrid();//刷新表格
                    }, "json");
                    btn.up('window').close();
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
    zwqxWindow.show();
    loadXmxxInfo(tab_items_sh, xm_id, bill_id);
}

/**
 * 地区控制数限制
 * @param form
 */
function checkKzs(form) {
    if (form == null || typeof form != 'object') {
        Ext.Msg.alert('提示', '控制数校验失败，代码错误！');
        return false;
    }
    var bill_year = form.getForm().findField('BILL_YEAR').getValue();
    //2020年之前不校验控制数
    if ('2019' < bill_year) {
        var applyAmount1 = form.getForm().findField("APPLY_AMOUNT1").getValue();
        var kzsAmt = form.getForm().findField("KZS_AMT").getValue();
        if (applyAmount1 > kzsAmt) {
            Ext.Msg.alert('提示', '申请金额大于申请年度控制数允许范围！');
            return false;
        }
    }
    return true;
}

/**
 * 获取控制数，并赋值
 * @param self
 */
function reloadKzs(self) {
    if (is_zxzqxt == '1' && is_zxzq != '2' && is_fxjh == '3' && SYS_ZXZQXT_KZS_CHECK == '1') {
        $.ajax({
            type: "POST",
            url: 'getDqKzs.action',//获取地区控制数
            data: {
                userAdCode: userAdCode
            },
            async: false, //设为false就是同步请求
            dataType: "json",
            cache: false,
            timeout: 180000,//三分钟
            success: function (data) {
                if (data.list == null || typeof data.list == 'undefined') {
                    Ext.Msg.alert('提示', '专项债券控制数获取错误！' + data.message);
                } else {
                    KZSArray = data.list;
                }
            }
        });
    }
    if (KZSArray != null && KZSArray != undefined) {
        var set_year$ = self.prev('[name=BILL_YEAR]').getValue();
        var flag = false;
        KZSArray.forEach(function (record) {
            if (set_year$ == record.SET_YEAR) {
                if (button_status == 'update') {
                    record.XQ_ZX_SY_AMT += APPLY_AMOUNT1_OLD;
                }
                self.setValue(record.XQ_ZX_SY_AMT);//需求库专项债券剩余金额
                flag = true;
            }
        });
        if (!flag) {//如果找不到当前区划，申报年度下的控制数，则设置为0
            self.setValue(0);
        }
    }
}

/**
 * 遍历form表单项，修改子级为只读项
 * @param Items
 * @constructor
 */
function SetItemReadOnly(Items) {

    Items.each(function (item, index, length) {
        if (item.getXType() == 'container' || item.getXType() == 'fieldcontainer' || item.getXType() == 'fieldset') {
            SetItemReadOnly(item.items);
        } else {
            if (item.name == 'IS_PPP' || item.name == 'PPP_YZFS' || item.name == 'PPP_YZFS'
                || item.name == 'PPP_HBFS' || item.name == 'PPP_SCJD' || item.name == 'PPP_SCJD' || item.name == 'PPP_RKQK_ID'
                || item.name == 'XMJSQ_START' || item.name == 'XMJSQ_END' || item.name == 'XMYYQ_START' || item.name == 'XMYYQ_END' || item.name == 'IS_TGWUSZPJ'
                || item.name == 'IS_TGCZCSNLLZ' || item.name == 'IS_XCCBSSFA' || item.name == 'HZQX'
            ) {
                return;
            }
            item.readOnly = true;
            item.editable = false;
            if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                item.fieldCls = 'form-unedit';
                if (item.getXType() == 'numberfield' || item.getXType() == 'numberFieldFormat') {
                    item.fieldCls = 'form-unedit-number';
                }
            }
        }
    });
}

function SetFormItemsReadOnly(Items) {
    Items.each(function (item) {
        if (item.getXType() == 'container' || item.getXType() == 'fieldcontainer' || item.getXType() == 'fieldset') {
            SetFormItemsReadOnly(item.items);
        } else {
            if (item.name == 'IS_PPP' || item.name == 'PPP_YZFS' || item.name == 'PPP_YZFS'
                || item.name == 'PPP_HBFS' || item.name == 'PPP_SCJD' || item.name == 'PPP_SCJD' || item.name == 'PPP_RKQK_ID'
                || item.name == 'XMJSQ_START' || item.name == 'XMJSQ_END' || item.name == 'XMYYQ_START' || item.name == 'XMYYQ_END' || item.name == 'IS_TGWUSZPJ'
                || item.name == 'IS_TGCZCSNLLZ' || item.name == 'IS_XCCBSSFA' || item.name == 'HZQX'
            ) {
                return;
            }
            //防止某些控件不支持setReadOnly
            if (item.setReadOnly && item.setFieldStyle) {
                item.setReadOnly(true);
                if (item.getXType() != 'checkbox' && item.getXType() != 'radio') {
                    item.setFieldStyle('background:#E6E6E6');
                }
            }
        }
    });
}

/*
*20201126
* 李月 重新加载项目类项方法
* ***/
function getstore(form) {
    var condition = "";
    var XMXZ_ID = Ext.ComponentQuery.query('treecombobox[name="XMXZ_ID"]')[0].getValue();
    //var XMLX_ID = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0].getValue();
    var ZJTXLY_ID = Ext.ComponentQuery.query('treecombobox[name="ZJTXLY_ID"]')[0].getValue();
    if (XMXZ_ID == '0101' || XMXZ_ID == '010101' || XMXZ_ID == '010102') {
        condition = " and xmfllx = 0 ";
    } else if (XMXZ_ID == '0102') {
        condition = " and xmfllx = 1 ";
    } else {
        condition = "";
    }
    if (!!ZJTXLY_ID) {
        ZJTXLY_ID = '#' + ZJTXLY_ID;
        condition = condition + "AND extend1 LIKE '%" + ZJTXLY_ID.substring(0, 3) + "%'";
    }
    zwxmlx_store.proxy.extraParams['condition'] = encode64(condition);
    zwxmlx_store.load();
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

function doXzzq(ids, xm_ids, is_ends, mb_ids, isTzXms, zqlxIds) {
    $.post("doXzzqWorkFlow.action", {
        workflow_direction: button_status,
        wf_id: wf_id,
        AD_CODE: AD_CODE,
        node_code: node_code,
        button_name: button_name,
        audit_info: '',
        ids: ids,
        xm_ids: xm_ids,
        is_ends: is_ends,
        mb_ids: mb_ids,
        isTzXms: isTzXms,
        is_fxjh: is_fxjh,
        node_type: node_type,
        is_zxzqxt: is_zxzqxt,
        is_zxzq: is_zxzq,
        zqlxIds: zqlxIds,
        is_ss: "1",//是否为送审
        menucode: menucode,
        HAVE_SFJG: HAVE_SFJG
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: button_name + "成功！" + (data.message ? data.message : ''),
                closable: false, align: 't', slideInDuration: 400, minWidth: 400
            });
        } else {
            Ext.MessageBox.show({
                title: '提示',
                msg: button_name + '失败！' + (data.message ? data.message : ''),
                minWidth: 300,
                buttons: Ext.Msg.OK,
                fn: function (btn) {
                }
            });
            //Ext.MessageBox.alert('提示', button_name + '失败！' + (data.message ? data.message : ''));
        }
        //刷新表格
        reloadGrid();
    }, "json");
}

//辽宁新添加建设项目内容填报模板
function downloadJsxmnrTbsm() {
    window.location.href = 'downloadTemplate.action?file_name=' + encodeURI(encodeURI("建设项目内容填报模板.docx"));
}