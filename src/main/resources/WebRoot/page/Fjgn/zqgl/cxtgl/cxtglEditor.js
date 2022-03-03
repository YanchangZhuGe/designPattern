/**
 * 初始化条件面板
 */
/**
 * 初始化债券信息填报弹出窗口中的投资计划标签页
 */
function cxtxxTab() {
    /**
     * 定义弹出框底部工具栏
     */
    /*var bbar = Ext.create(
     'Ext.toolbar.Toolbar',
     {
     id : 'bbar',
     border : false,
     items : [
     '->',
     {
     xtype : 'button',
     id : 'SaveBtn',
     text : '确定',
     scale : 'medium',
     name : 'SAVE',
     disabled : true,
     handler : function(btn) {
     var form = btn.up('window').down('form');
     var cxt_code = Ext.ComponentQuery.query('textfield[name="CXT_CODE"]')[0].value;
     var cxt_name = Ext.ComponentQuery.query('textfield[name="CXT_NAME"]')[0].value;
     if(cxt_code == null || cxt_code == ''){
     Ext.Msg.alert('提示', '编码不能为空！');
     return false;
     }
     if(cxt_name == null || cxt_name == ''){
     Ext.Msg.alert('提示', '名称不能为空！');
     return false;
     }
     // 获取单据明细数组
     var recordArray = [];
     var message_error = null;
     if (form.down('grid').getStore().getCount() <= 0) {
     Ext.Msg.alert('提示', '请新增表格中的明细记录！');
     return false;
     }
     form.down('grid').getStore().each(
     function(record) {
     if (!record.get('CXJG_CODE')|| record.get('CXJG_CODE') == null) {
     message_error = '机构名称不能为空';
     return false;
     }
     recordArray.push(record.getData());
     });
     if (message_error != null && message_error != '') {
     Ext.Msg.alert('提示', message_error);
     return false;
     }
     var parameters = {
     button_name : button_name,
     detailList : Ext.util.JSON
     .encode(recordArray)
     };
     if (button_name == 'UPDATE') {
     // 获取承销团树上的承销团id 传回后台 对数据进行删除
     // 然后执行新增操作
     }
     if (form.isValid()) {
     // 保存表单数据及明细数据
     form.submit( {
     // 设置表单提交的url
     url : 'saveCxtGrid.action',
     params : parameters,
     success : function(form, action) {
     // 关闭弹出框
     btn.up("window").close();
     // 提示保存成功
     Ext.toast( {
     html : "<center>保存成功!</center>",
     closable : false,
     align : 't',
     slideInDuration : 400,
     minWidth : 400
     });
     //保存成功后，进行树和表格的刷新
     Ext.ComponentQuery.query('treepanel#jg_tree')[0].getStore().load();
     DSYGrid.getGrid('grid').getStore().loadPage(1);
     },
     failure : function(form, action) {
     Ext.Msg.alert('提示',"保存失败！" + action.result ? action.result.message: '无返回响应');
     DSYGrid.getGrid('grid').getStore().loadPage(1);
     }
     });
     }
     }
     }, {
     xtype : 'button',
     text : '取消',
     scale : 'medium',
     name : 'CLOSE',
     handler : function(btn) {

     * if(button_name=='INPUT'){
     * Ext.ComponentQuery.query('window#addWin')[0].close(); }
     * else {
     * Ext.ComponentQuery.query('window#updateWin')[0].close(); }

     btn.up('window').close();
     }
     } ]
     });*/
	
    if (button_name == 'INPUT') {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'vbox',
            border: false,
            padding: '5 5 5 5',
            defaults: {
                allowBlank: false,
                blankText: "必填项目",
            },
            items: [{
                xtype: "textfield",
                name:"UCXT_ID",
                value: UCXT_ID,
                width: 250,
                labelWidth: 60,
                fieldLabel: '上级ID',
                hidden:true,
                readOnly:true,
                editable: false, // 启用编辑
                fieldStyle: 'background:#E6E6E6'
            }, {
                xtype: "textfield",
                name: "CXT_CODE",
                store: DebtEleStore(json_debt_cxt),
                displayField: "name",
                valueField: "id",
                width: 250,
                labelWidth: 60,
                fieldLabel: '<span class="required">✶</span>编码',
                editable: true // 启用编辑
            }, {
                xtype: "textfield",
                name: "CXT_NAME",
                store: DebtEleStore(json_debt_cxt),
                displayField: "name",
                valueField: "id",
                width: 350,
                labelWidth: 60,
                fieldLabel: '<span class="required">✶</span>名称',
                editable: true  // 启用编辑
            }, init_jgxx_grid()]
            //bbar : bbar
        });
    } else {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'vbox',
            border: false,
            padding: '2 5 2 10',
            items: [
                {
                    xtype: 'container',
                    layout:'column',
                    margin:'5 5 5 5',
                    items: [
                        {
                            xtype: "textfield",
                            name: "CXT_ID",
                            width: 150,
                            labelWidth: 60,
                            fieldLabel: '<span class="required">✶</span>ID',
                            editable: false,
                            value: CXT_ID,
                            hidden: true
                        },
                        {
                            xtype: "textfield",
                            name: "CXT_CODE",
                            store: DebtEleStore(json_debt_cxt),
                            displayField: "name",
                            valueField: "id",
                            width: 250,
                            labelWidth: 60,
                            fieldLabel: '<span class="required">✶</span>编码',
                            listeners: {
                                change : function (self, newValue, oldValue) {
                                    if (oldValue != '' && oldValue != undefined) {
                                        Ext.getCmp('SaveBtn').setDisabled(false);
                                    }
                                }
                            },
                            editable: true // 启用编辑
                        },
                        {
                            xtype: "textfield",
                            name: "CXT_NAME",
                            store: DebtEleStore(json_debt_cxt),
                            displayField: "name",
                            valueField: "id",
                            width: 350,
                            labelWidth: 50,
                            fieldLabel: '<span class="required">✶</span>名称',
                            listeners: {
                                change : function (self, newValue, oldValue) {
                                    if (oldValue != '' && oldValue != undefined) {
                                        Ext.getCmp('SaveBtn').setDisabled(false);
                                    }
                                }
                            },
                            editable: true  // 启用编辑
                        }
                    ]
                },
                init_jgxx_grid()
            ]
            //bbar : bbar
        });
    }

}
/**
 * 初始化债券信息填报弹出窗口中的投资计划标签页中的表格
 */
// 20210726 guoyf 前台过滤条件迁移至后台
var store_debt_cxjg = getCXJGStore('DEBT_CXJG', {condition: ""}, 'getCXTEleGridValue.action');
var store_debt_cxjg_render = getCXJGStore('DEBT_CXJG', {condition: " and '" + dsyDateFormat(new Date()) + "' >= STARTTIME and  ('" + dsyDateFormat(new Date()) + "' <= ENDTIME or ENDTIME is null)"}, 'getCXTEleGridValue.action');
//承销团管理，机构名称，下拉选项校验生效时间和失效时间
var store_xydj = DebtEleStoreDB('DEBT_XYDJ');
/*债务基础数据，下拉树形式，从后台数据库获取数据*/
/*function DebtCXJGEleTreeStoreDB(debtEle, params) {
    var extraParams = {};
    if (typeof params == 'object') {
        extraParams = params;
    }
    extraParams.debtEle = debtEle;
    var debtTreeStoreDB = Ext.create('Ext.data.TreeStore', {
        model: 'treeModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getCXTEleTreeValue.action',
            extraParams: extraParams,
            reader: {
                type: 'json'
            }
        },
        root: {name: '全部'},
        autoLoad: true
    });
    return debtTreeStoreDB;
}*/
/**
 * 初始化承销机构选择弹出框window
 * @param self
 * @param store
 * @returns {Ext.window.Window}
 */
function initCXJGSelectWin () {
    var param;
    var store = DSYGrid.getGrid('jgxxGrid').getStore();
    var cxjg_codes = [];
    if (store.getCount() > 0) {
        for (var i = 0; i < store.getCount(); i++) {
            if (store.getAt(i).get('CXJG_CODE') != undefined && store.getAt(i).get('CXJG_CODE')!='') {
                cxjg_codes.push(store.getAt(i).get('CXJG_CODE'));
            }
        }
    }
    if (cxjg_codes.length > 0) {
        //拼写查询条件
        var string = '(';
        Ext.Array.forEach(cxjg_codes, function (cxjg_code, index) {
            string += "'";
            string += cxjg_code;
            string += "'";
            if (index != (cxjg_codes.length - 1)) {
                string += ',';
            }
        });
        string += ')';
        // 20210726 guoyf 前台过滤条件迁移至后台
        param = encode64(string);
    } else {
        param = store_debt_cxjg.getProxy().extraParams['condition'];
    }
    var gridConfig = {
        itemId: 'cxjgGrid',
        name : 'PopupGrid',
        headerConfig: {
            rowNumber: true,
            headerJson:[
                {
                    xtype: 'rownumberer',
                    summaryType: 'count',
                    width: 40
                },
                {
                    "dataIndex": "ID",
                    "type": "string",
                    "text": "机构ID",
                    "width": 200,
                    "hidden": true
                },
                {
                    "dataIndex": "CODE",
                    "type": "string",
                    "text": "机构编码",
                    "width": 200
                },
                {
                    "dataIndex": "NAME",
                    "type": "string",
                    "text": "机构名称",
                    "width": 200
                },
                {
                    "dataIndex": "NAMECODE",
                    "type": "string",
                    "text": "NAMECODE",
                    "width": 200,
                    "hidden": true
                },
                {
                    "dataIndex": "PARENT_ID",
                    "type": "string",
                    "text": "PARENT_ID",
                    "width": 200,
                    "hidden": true
                },
                {
                    "dataIndex": "ISLEAF",
                    "type": "string",
                    "text": "ISLEAF",
                    "width": 200,
                    "hidden": true
                },
                {
                    "dataIndex": "LEVELNO",
                    "type": "string",
                    "text": "LEVELNO",
                    "width": 200,
                    "hidden": true
                },
                {
                    "dataIndex": "CXS_TGZH",
                    "type": "string",
                    "text": "承销商托管账号",
                    "width": 200
                },
                {
                    "dataIndex": "CXS_ZZDZH",
                    "type": "string",
                    "text": "中证登托管账号",
                    "width": 200
                },
                {
                    "dataIndex": "IS_LEADER",
                    "type": "string",
                    "text": "是否为主承销机构",
                    "width": 200,
                    "hidden": true,
                    renderer: function (value) {
                        var store = DebtEleStore(json_debt_sf);
                        var record = store.findRecord('code', value, 0, false, true, true);
                        return record != null ? record.get('name') : value;
                    }
                },
                {
                    "dataIndex": "ORG_ACCOUNT",
                    "type": "string",
                    "text": "收款账号",
                    "width": 200
                },
                {
                    "dataIndex": "ORG_ACC_NAME",
                    "type": "string",
                    "text": "收款账户名称",
                    "width": 200
                },
                {
                    "dataIndex": "ORG_ACC_BANK",
                    "type": "string",
                    "text": "收款账户银行",
                    "width": 200
                },
                {
                    "dataIndex": "SET_YEAR",
                    "type": "string",
                    "text": "SET_YEAR",
                    "width": 200,
                    "hidden": true
                },
                {
                    "dataIndex": "IS_KSC",
                    "type": "string",
                    "text": "是否跨市场",
                    "width": 200,
                    renderer: function (value) {
                        var record = store_is_ksc.findRecord('code', value, 0, false, true, true);
                        return record != null ? record.get('name') : value;
                    }
                },
                {
                    "dataIndex": "CXS_YWLXR",
                    "type": "string",
                    "text": "业务联系人",
                    "width": 200
                },
                {
                    "dataIndex": "CXS_TBLXR",
                    "type": "string",
                    "text": "投标联系人",
                    "width": 200
                },
                {
                    "dataIndex": "CXS_TEL",
                    "type": "string",
                    "text": "联系电话",
                    "width": 200
                },
                {
                    "dataIndex": "STARTTIME",
                    "type": "string",
                    "text": "开始时间",
                    "width": 200,
                    "hidden": true
                },
                {
                    "dataIndex": "ENDTIME",
                    "type": "string",
                    "text": "结束时间",
                    "width": 200,
                    "hidden": true
                }

            ],
            columnAutoWidth: false
        },
        rowNumber: true,
        border: false,
        height: '100%',
        pageConfig: {
            enablePage : true,
            pageSize: 20// 每页显示数据数
        },
        dataUrl: store_debt_cxjg.getProxy().url,
        checkBox: true,
        params: {
            condition: param
        },
        tbar: [
                {
                    fieldLabel: '模糊查询',
                    name: 'mhcx',
                    xtype: "textfield",
                    width: 300,
                    labelWidth: 60,
                    labelAlign: 'right',
                    emptyText: '请输入承销机构名称',
                    enableKeyEvents: true,
                    listeners: {
                        specialkey:function(field,e){
                            if(e.getKey()==Ext.EventObject.ENTER){
                                var store = DSYGrid.getGrid('cxjgGrid').getStore();
                                var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].getValue();
                                store.getProxy().extraParams = {
                                    mhcx: mhcx
                                };
                                //刷新表格内容
                                store.loadPage(1);
                            }
                        }
                    }
                }
            ]
    };
    var grid = new DSYGridV2().create(gridConfig);
    var window = Ext.create('Ext.window.Window', {
        closeAction: 'destroy',
        title: '选择承销机构',
        width: 800,
        height: 350,
        layout: 'fit',
        modal: true,
        //animateTarget: self,
        buttonAlign: 'center',
        buttons: [
            {
                text: '确认',
                listeners: {
                    'click': function (btn) {
                        //点击确认按钮将选中的承销数据插入到承销机构表格中
                        var jgxxGridStore = DSYGrid.getGrid('jgxxGrid').getStore();
                        var jgxxGridItems = jgxxGridStore.data.items;
                        var currentIndex;
                        if (jgxxGridItems.length == 0) {
                            currentIndex = 0;
                        } else {
                            currentIndex = jgxxGridItems.length;
                        }

                        var records = DSYGrid.getGrid('cxjgGrid').getSelection();
                        for (var i = 0; i < records.length; i++) {
                            records[i].set('CXJG_CODE',records[i].get('CODE'));
                            records[i].set('CXJG_NAME',records[i].get('NAME'));
                            if (records[i].get('ENDTIME') == null || records[i].get('ENDTIME') == undefined) {
                                records[i].set('ENDTIME','');
                            }
                            if (records[i].get('IS_LEADER') == null || records[i].get('IS_LEADER') == undefined) {
                                records[i].set('IS_LEADER','');
                            }
                            if (records[i].get('CXS_TGZH') == null || records[i].get('CXS_TGZH') == undefined) {
                                records[i].set('CXS_TGZH','');
                            }
                            if (records[i].get('CXS_ZZDZH') == null || records[i].get('CXS_ZZDZH') == undefined) {
                                records[i].set('CXS_ZZDZH','');
                            }
                            if (records[i].get('CX_SCALE') == null || records[i].get('CX_SCALE') == undefined) {
                                records[i].set('CX_SCALE','');
                            }
                            if (records[i].get('ORG_ACCOUNT') == null || records[i].get('ORG_ACCOUNT') == undefined) {
                                records[i].set('ORG_ACCOUNT','');
                            }
                            if (records[i].get('ORG_ACC_NAME') == null || records[i].get('ORG_ACC_NAME') == undefined) {
                                records[i].set('ORG_ACC_NAME','');
                            }
                            if (records[i].get('ORG_ACC_BANK') == null || records[i].get('ORG_ACC_BANK') == undefined) {
                                records[i].set('ORG_ACC_BANK','');
                            }
                            if (records[i].get('XYDJ_LEVEL') == null || records[i].get('XYDJ_LEVEL') == undefined) {
                                records[i].set('XYDJ_LEVEL','');
                            }
                            if (records[i].get('TOUBIAO_SX') == null || records[i].get('TOUBIAO_SX') == undefined) {
                                records[i].set('TOUBIAO_SX','');
                            }
                            if (records[i].get('TOUBIAO_XX') == null || records[i].get('TOUBIAO_XX') == undefined) {
                                records[i].set('TOUBIAO_XX','');
                            }
                            if (records[i].get('ZBSX') == null || records[i].get('ZBSX') == undefined) {
                                records[i].set('ZBSX','');
                            }
                            if (records[i].get('ZBXX') == null || records[i].get('ZBXX') == undefined) {
                                records[i].set('ZBXX','');
                            }
                            if (records[i].get('PX_NO') == null || records[i].get('PX_NO') == undefined) {
                                records[i].set('PX_NO','');
                            }
                            if (records[i].get('IS_KSC') == null || records[i].get('IS_KSC') == undefined) {
                                records[i].set('IS_KSC','');
                            }
                            if (records[i].get('CXS_YWLXR') == null || records[i].get('CXS_YWLXR') == undefined) {
                                records[i].set('CXS_YWLXR','');
                            }
                            if (records[i].get('CXS_TBLXR') == null || records[i].get('CXS_TBLXR') == undefined) {
                                records[i].set('CXS_TBLXR','');
                            }
                            if (records[i].get('CXS_TEL') == null || records[i].get('CXS_TEL') == undefined) {
                                records[i].set('CXS_TEL','');
                            }
                            DSYGrid.getGrid('jgxxGrid').insertData(currentIndex,records);
                            if (Ext.getCmp('SaveBtn').disabled) {
                                Ext.getCmp('SaveBtn').setDisabled(false);
                            }
                        }
                        var store = DSYGrid.getGrid('jgxxGrid').getStore();
                        var cxjg_codes = [];
                        if (store.getCount() > 0) {
                            for (var i = 0; i < store.getCount(); i++) {
                                if (store.getAt(i).get('CXJG_CODE') != undefined && store.getAt(i).get('CXJG_CODE')!='') {
                                    cxjg_codes.push(store.getAt(i).get('CXJG_CODE'));
                                }
                            }
                        }
                        var cxjgStore = DSYGrid.getGrid('cxjgGrid').getStore();
                        //if (cxjg_codes.length > 0) {
                        //如果已选择承销机构，需要过滤已选择的承销机构
                        //拼写查询条件
                        var string = '(';
                        Ext.Array.forEach(cxjg_codes, function (cxjg_code, index) {
                            string += "'";
                            string += cxjg_code;
                            string += "'";
                            if (index != (cxjg_codes.length - 1)) {
                                string += ',';
                            }
                        });
                        string += ')';
                        cxjgStore.getProxy().extraParams["condition"] = " and '" + dsyDateFormat(new Date()) + "' >= STARTTIME and  ('" + dsyDateFormat(new Date()) + "' <= ENDTIME or ENDTIME is null) AND CODE NOT IN " + string;
                        cxjgStore.loadPage(1);
                        //}
                        // 关闭弹出窗口
                        btn.up("window").close();
                    }
                }
            },
            {
                text: '取消',
                listeners: {
                    'click': function (btn) {
                        btn.up("window").close();
                    }
                }
            }
        ],
        items: [grid]
    });
    return window;
}
function getCXJGStore(debtEle, params, dataURL) {
    var extraParams = {};
    if (typeof params == 'object') {
        extraParams = params;
    }
    extraParams.debtEle = debtEle;
    var store = Ext.create('Ext.data.Store', {
        fields: ["ID", "CODE", "NAME", "NAMECODE", "PARENT_ID", "ISLEAF", "LEVELNO", "CXS_TGZH", "CXS_ZZDZH","IS_LEADER","ORG_ACCOUNT","ORG_ACC_NAME","ORG_ACC_BANK","SET_YEAR","IS_KSC","CXS_YWLXR","CXS_TBLXR","CXS_TEL","STARTTIME","ENDTIME"],
        remoteSort: true,// 后端进行排序
        pageSize: 0,
        proxy: {// ajax获取后端数据
            type: "ajax",
            method: "POST",
            url: dataURL,
            extraParams: extraParams,
            reader: {
                type: "json",
                root: "list",
                totalProperty: "totalcount"
            },
            simpleSortMode: true
        },
        autoLoad: true
    });
    return store;
}
function init_jgxx_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40
        },
        {
            "dataIndex": "CXJG_NAME",
            "type": "string",
            "text": "机构编码",
            "width": 150,
            hidden: true
        },
        {
            "dataIndex": "CXJG_CODE",
            "type": "string",
            "text": "机构名称",
            "width": 200,
            /*editor: {
                xtype: 'treecombobox',
                displayField: 'name',
                valueField: 'code',
                store: store_debt_cxjg,
                rootVisible: false,
                selectModel: 'leaf',
                allowBlank: false,
                editable: false,
                listeners: {
                    select: function (context) {
                        var record = store_debt_cxjg.findRecord('code', context.getValue(), 0, false, true, true);
                        var grid_record = DSYGrid.getGrid('jgxxGrid').getSelection()[0];
                        grid_record.set('CXS_TGZH', record.get('cxs_tgzh'));
                        grid_record.set('CXS_ZZDZH',record.get('cxs_zzdzh'));
                        grid_record.set('IS_LEADER', record.get('is_leader'));
                        grid_record.set('ORG_ACCOUNT', record.get('org_account'));
                        grid_record.set('ORG_ACC_NAME', record.get('org_acc_name'));
                        grid_record.set('ORG_ACC_BANK', record.get('org_acc_bank'));
                        grid_record.set('IS_KSC', record.get('is_ksc'));
                        grid_record.set('CXS_YWLXR', record.get('cxs_ywlxr'));
                        grid_record.set('CXS_TBLXR', record.get('cxs_tblxr'));
                        grid_record.set('CXS_TEL', record.get('cxs_tel'));
                    }
                }

            },*/
            renderer: function (value) {
                var record = store_debt_cxjg_render.findRecord('CODE', value, 0, false, true, true);
                return record != null ? record.get('NAME') : value;
            }

        },
        /*{
            "dataIndex": "CXJG_CODE",
            "type": "string",
            "text": "机构名称",
            "width": 200,
            editor: {
                xtype: "popupgrid",
                name: "CXJG_CODE_GRID",
                valueField: 'code',
                displayField: 'name',
                //fieldLabel: '机构名称',
                listConfig: {
                    maxHeight: 1
                },
                store: store_debt_cxjg,
                window: initCXJGSelectWin(this,store_debt_cxjg),
                closeAction: 'hide'
            }
        },*/
        {
            "dataIndex": "CXS_TGZH",
            "name": "CXSTGZH",
            "type": "string",
            "text": "承销商托管账号",
            hidden:true,
            "width": 200
        },
        {
            "dataIndex": "CXS_TGZH",
            "type": "string",
            "text": "中债登托管账号",
            editable:false,
            hidden:false,
            "width": 150
        },
        {
            "dataIndex": "CXS_ZZDZH",
            "type": "string",
            "text": "中证登托管账号",
            editable:false,
            hidden:false,
            "width": 150
        },
        {
            "dataIndex": "IS_LEADER",
            "type": "string",
            "text": "承销机构类型",
            "width": 150,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'code',
                store: DebtEleStore(json_zqgl_cxjglx),
                editable: false,
                allowBlank: false,
            },
            renderer: function (value) {
                var store = DebtEleStore(json_zqgl_cxjglx);
                var record = store.findRecord('code', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            "dataIndex": "PX_NO",
            "name": "PX_NO",
            "type": "string",
            "text": "排序号",
            "width": 100 ,
            editor: {
            	xtype:'numberFieldFormat',
            	hideTrigger: true,
            	editable: true
            },
            renderer: function (value) {
            	return Ext.util.Format.number(value, '0000');
            }
        },
        {
            "dataIndex": "XYDJ_LEVEL",
            "type": "string",
            "text": "信用等级",
            "fontSize": "15px",
            "width": 150,
            align: 'left',
            editor: {
                xtype: 'combobox',
                //store: store_DEBT_ZJLY,
                itemId: 'xydjid',
                store: store_xydj,
                selectModel: 'leaf',
                displayField: 'name',
                valueField: 'id',
                editable:false

            },
            renderer: function (value) {
                var record = store_xydj.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            "dataIndex": "CX_SCALE",
            type: "float",
            "text": "承销比例（%）",
            "width": 150,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue:100}
        },
        {
            "dataIndex": "TOUBIAO_SX",
            "type": "float",
            "width": 100,
            editor: 'numberfield',
            "text": "投标上限%",
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue:100}
        },
        {
            "dataIndex": "TOUBIAO_XX",
            "type": "float",
            "width": 100,
            editor: 'numberfield',
            "text": "投标下限%",
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue:100}
        },
        {
            "dataIndex": "ZBSX",
            "type": "float",
            "width": 100,
            editor: 'numberfield',
            "text": "中标上限%",
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue:100}
        },
        {
            "dataIndex": "ZBXX",
            "type": "float",
            "width": 100,
            editor: 'numberfield',
            "text": "中标下限%",
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0,maxValue:100}
        },
        {
            "dataIndex": "ORG_ACCOUNT",
            "type": "string",
            "text": "收款账号",
            hidden:true,
            "width": 150,
            editor: 'textfield'
        },
        {
            "dataIndex": "ORG_ACC_NAME",
            "type": "string",
            "text": "收款账户名称",
             hidden:true,
            "width": 150,
            editor: 'textfield'
        },
        {
            "dataIndex": "ORG_ACC_BANK",
            "type": "string",
            "text": "收款账户银行",
             hidden:true,
            "width": 150,
             editor: 'textfield'
        },
        {
            "dataIndex": "SET_YEAR",
            "type": "string",
            "text": "年度",
            "width": 150,
            "hidden": true,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                valueField: 'code',
                store: DebtEleStore(json_debt_year),
                editable: false
            }
        },
        {
            "dataIndex": "IS_KSC",
            "type": "string",
            "text": "是否跨市场",
            "width": 150,
            renderer: function (value) {
                var record = store_is_ksc.findRecord('code', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            "dataIndex": "CXS_YWLXR",
            "type": "string",
            "text": "业务联系人",
            "width": 150
        },
        {
            "dataIndex": "CXS_TBLXR",
            "type": "string",
            "text": "投标联系人",
            "width": 150
        },
        {
            "dataIndex": "CXS_TEL",
            "type": "string",
            "text": "联系电话",
            "width": 150
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'jgxxGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
            pluginId: 'grid_plugin_cell',
            clicksToMoveEditor: 1,
            listeners: {
                'beforeedit': function (editor, context) {
                },
                'edit': function (editor, context) {
                    if (context.field == 'PX_NO') {
                    }

                }
            }
        }],
        width: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        },
        autoLoad: false,
        data: [],
        listeners: {
            selectionchange: function (view, records) {
                grid.down('#delete_editGrid').setDisabled(!records.length);
                Ext.getCmp('SaveBtn').setDisabled(false);
            },
            validateedit: function (editor, context) {
                if (context.field == 'CXJG_CODE') {
                    var record = store_debt_cxjg.findRecord('code', context.value, false, true, true);
                    context.record.set('CXJG_NAME', record.get('name'));
                }
            }
        }
    });
    // 将增加删除按钮添加到表格中
    grid.addDocked({
        xtype: 'toolbar',
        layout: 'hbox',
        items: ['承销机构：', {
            xtype: 'button',
            text: '增加',
            width: 80,
            handler: function (btn) {
            	px_no = parseInt(px_no)+1;
                initCXJGSelectWin().show();
                /*btn.up('grid').insertData(null, {
                	//PX_NO:px_no
                });*/
            }
        }, {
            xtype: 'button',
            text: '删除',
            itemId: 'delete_editGrid',
            width: 80,
            disabled: true,
            handler: function (btn) {
                var grid = btn.up('grid');
                var store = grid.getStore();
                var records = grid.getSelectionModel().getSelection();
                Ext.each(records, function (record) {
                    store.remove(record);
                })
            }
        }]
    }, 0);
    return grid;
}
/**
 * 验证字数是否超出上限
 */
function checkLength(field,flag){
    if(flag!=null&&flag=='cxt_code'){
        if(field.length > 10){
            return false;
        } else {
            return true;
        }
    }else{
        if(field.length > 15){
            return false;
        } else {
            return true;
        }
    }

}
