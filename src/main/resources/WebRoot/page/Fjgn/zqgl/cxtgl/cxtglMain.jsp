<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>承销团管理</title>
    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script src="../data/ele_data.js"></script>
    <script src="cxtglEditor.js"></script>
    <script src="/js/debt/Map.js"></script>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
        }

        span.required {
            color: red;
            font-size: 100%;
        }
    </style>
</head>
<body>
<script type="text/javascript">
    //系统参数省级地区编码
    var ELE_AD_CODE = '';
    $.ajax({
        type: "POST",
        url: 'getParamValueAll.action',
        dataType: "json",
        async: false, //设为false就是同步请求
        cache: false,
        success: function (data) {
            ELE_AD_CODE = data[0].ELE_AD_CODE;
        }
    });
    /**
     * 获取登录用户
     */
    var userCode = '${sessionScope.USERCODE}';
    /**
     * 通用函数：获取url中的参数：wf_id,node_code
     */
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg); //匹配目标参数
        if (r != null)
            return unescape(r[2]);
        return null; //返回参数值
    }
    var wf_id = getUrlParam("wf_id");//工作流ID
    var node_code = getUrlParam("node_code");//当前结点
    /**
     * 设置全局变量
     */
    var button_name = '';//按钮名称
    var next_text = '';//送审、审核按钮显示文字
    var audit_info = '';//送審意見
    var ZQ_ID = '';
    var CXT_ID = '';
    var UCXT_ID = '';
    var SET_YEAR = '';
    var ZQPZ_ID = '';
    var TREE_LOAD = '';
    var TREE_RENDER = '';
    var select_tree_id = ''; 
    var px_no = 0;
    var store_is_ksc = DebtEleStore([//是否跨市场
        {id: "0", code: "0", name: "否"},
        {id: "1", code: "1", name: "是"}
    ]);
    var select_tree_text;//20210303LIYUE初始化点击节点
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        if (typeof (Ext) == "undefined" || Ext == null) {
            //动态加载js
            $.ajaxSetup({
                cache: true
            });
            $.getScript('../../third/ext5.1/ext-all.js', function () {
                initMain();
                initButton();

            });
        } else {
            initMain();
            initButton();
        }

    });
    /**
     * 主界面初始化
     */
    function initMain() {
        /**
         * 初始化顶部功能按钮
         */
        //通过当前所在节点，判断next按钮显示的名称
        if (node_code == '1') {//节点1
            next_text = '送审';
        } else if (node_code == '2') {//
            next_text = '登记';
        } else if (node_code == '3') {
            next_text = '债务确认';
        }
        var tbar = Ext.create('Ext.toolbar.Toolbar', {
            border: false,
            items: [
                {
                    xtype: 'button',
                    text: '录入',
                    name: 'btn_insert',
                    icon: '/image/sysbutton/regist.png',
                    handler: function () {
                        var tree = Ext.ComponentQuery.query('treepanel#jg_tree')[0];
                        var records=tree.getSelectionModel().getSelection();
                        UCXT_ID = records[0].get('id');
                        fuc_addCxtgl();
                    }
                },
                {
                    xtype: 'button',
                    itemId: 'btnUpdate',
                    text: '修改',
                    name: 'btn_update',
                    disabled:true,
                    icon: '/image/sysbutton/edit.png',
                    handler: function () {
                        var records = DSYGrid.getGrid('grid')
                            .getSelectionModel()
                            .getSelection();
                        if (!!CXT_ID) {
                            fuc_updateFxgl();
                        } else {
                            Ext.MessageBox.alert('提示',
                                '请选择左侧树节点后再进行操作');
                            return;
                        }
                    }
                },
                {
                    xtype: 'button',
                    itemId: 'btnDelete',
                    text: '删除',
                    name: 'btn_delete',
                    icon: '/image/sysbutton/delete.png',
                    disabled:true,
                    handler: function () {
                         var records = DSYGrid.getGrid('grid')
                         .getSelectionModel()
                         .getSelection();
                        if (CXT_ID == null || CXT_ID == '' || CXT_ID == undefined||records.length >0) {
                            Ext.MessageBox.alert('提示',
                                '请选择左侧树节点后再进行操作');
                            return;
                        } else {
                            fuc_deleteFxgl();
                        }
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        });
        /**
         * 承销团树
         */
        Ext.define('cxtTreeModel', {
            extend: 'Ext.data.Model',
            fields: [
                {name: 'text'},
                {name: 'code'},
                {name: 'id'},
                {name: 'leaf'}
            ]

        });
        var unitStore = Ext.create('Ext.data.TreeStore', {
            model: 'cxtTreeModel',
            proxy: {
                type: 'ajax',
                method: 'POST',
                url: 'getCxtTreeData.action',
                reader: {
                    type: 'json'
                }
            },
            root: 'nodelist',
            autoLoad: true,
            listeners: {
                load: function (self) {
                    TREE_LOAD = 1;
                    if (TREE_RENDER == 1) {
                        initTree();
                    }
                }
            }
        });
        /**
         * 债券注册信息列表工具栏
         */
        var screenBar = [
            {
                xtype: "textfield",
                fieldLabel: '编码',
                margin: '0 0 0 -15',
                id: "bm",
                width: 140,
                labelWidth: 60,
                editable: false, //禁用编辑
                labelAlign: 'right'
            },
            {
                xtype: "textfield",
                fieldLabel: '名称',
                id: "mc",
                width: 320,
                labelWidth: 60,
                editable: false, //禁用编辑
                labelAlign: 'right'
            }
        ];
        /**
         * 承销机构信息列表表头
         */
        var headerJson = [
            {
                xtype: 'rownumberer',
                width: 35
            },
            {
                "dataIndex": "CXJG_ID",
                "type": "string",
                "text": "机构ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "CXJG_CODE",
                "type": "string",
                "text": "机构编码",
                "fontSize": "15px",
                "width": 120
            },
            {
                "dataIndex": "CXJG_NAME",
                "type": "string",
                "text": "机构名称",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "CXS_TGZH",
                "type": "string",
                "text": "中债登托管账号",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "CXS_ZZDZH",
                "type": "string",
                "text": "中证登托管账号",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "IS_LEADER",
                "type": "string",
                "text": "承销机构类型",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "XYDJ_LEVEL",
                "type": "string",
                "text": "信用等级",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "CX_SCALE",
                "type": "float",
                "width": 100,
                "text": "承销比例%"
            },
            {
                "dataIndex": "TOUBIAO_SX",
                "type": "float",
                "width": 100,
                "text": "投标上限%"
            },
            {
                "dataIndex": "TOUBIAO_XX",
                "type": "float",
                "width": 100,
                "text": "投标下限%"
            },
            {
                "dataIndex": "ZBSX",
                "type": "float",
                "width": 100,
                "text": "中标上限%"
            },
            {
                "dataIndex": "ZBXX",
                "type": "float",
                "width": 100,
                "text": "中标下限%"
            },
            {
                "dataIndex": "ORG_ACCOUNT",
                "width": 150,
                "type": "string",
                "text": "收款账号"
            },
            {
                "dataIndex": "ORG_ACC_NAME",
                "width": 180,
                "type": "string",
                "text": "收款账户名称"
            },
            {
                "dataIndex": "ORG_ACC_BANK",
                "width": 180,
                "type": "string",
                "text": "收款账户银行"
            },
            {
                dataIndex: "IS_KSC", type: "string", text: "是否跨市场",
                renderer: function (value, cell) {
                    var record = store_is_ksc.findRecord('code', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {
                "dataIndex": "CXS_YWLXR",
                "width": 180,
                "type": "string",
                hidden:false,
                "text": "业务联系人"
            },
            {
                "dataIndex": "CXS_TBLXR",
                "width": 180,
                "type": "string",
                hidden:false,
                "text": "投标联系人"
            },
            {
                "dataIndex": "CXS_TEL",
                "width": 180,
                "type": "string",
                hidden:false,
                "text": "联系电话"
            }
        ];
        var config = {
            itemId: 'grid',
            flex: 5,
            region: 'center',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            enableLocking: false,
            autoLoad: false,
            dataUrl: 'getCxtGrid.action',
            checkBox: false,
            border: false,
            height: '100%',
            tbar: screenBar,
            pageConfig: {
                pageNum: true,//设置显示每页条数
                pageSize: 20
            }
        };
        var grid = DSYGrid.createGrid(config);
        /**
         * 债券注册录入界面主面板初始化
         */
        var panel = Ext.create('Ext.panel.Panel', {
            renderTo: Ext.getBody(),
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            width: '100%',
            height: '100%',
            border: false,
            items: [
                {
                    xtype: 'treepanel',
                    height: '100%',
                    itemId: 'jg_tree',
                    region: 'west',
                    flex: 1,
                    store: unitStore,
                    rootVisible: false,
                    listeners: {
                        itemclick: function (view, record, item, index, e, eOpts) {
                            fuc_getCxtGrid(record, "1");
                            select_tree_id = record.get('id');
                            select_tree_text=record.data.text
                            current_record=unitStore.indexOf(record);
                            if(select_tree_text=="承销团信息"){
                                Ext.ComponentQuery.query('button#btnUpdate')[0].setDisabled(true);
                                Ext.ComponentQuery.query('button#btnDelete')[0].setDisabled(true);//20210225李月承销团信息维护不允许删除修改根节点
                            }else{
                                Ext.ComponentQuery.query('button#btnUpdate')[0].setDisabled(false);
                                Ext.ComponentQuery.query('button#btnDelete')[0].setDisabled(false);//20210225李月承销团信息维护不允许删除修改根节点
                            }

                        },
                        afterrender: function (self) {
                            TREE_RENDER = 1;
                            if (TREE_LOAD == 1) {
                                initTree();
                            }
                        }
                    }
                },
                grid
            ],
            tbar: tbar
        });
    }
    /**
     * 初始化弹出窗口内容
     */
    function initEditor() {
        button_name = 'INPUT';//按钮名称为INPUT
        return cxtxxTab();
    }
    /**
     * 初始化按钮
     */
    function initButton() {

    }
    /**
     * 初始化选中树节点第一条数据
     */
    function initTree() {
        var tree = Ext.ComponentQuery.query('treepanel#jg_tree')[0];
        var rootNode = tree.getRootNode();
        if (rootNode.getChildAt(0) && rootNode.getChildAt(0).getChildAt(0)) {
            var record = rootNode.getChildAt(0).getChildAt(0);
            tree.getSelectionModel().select(record);
            //Ext.getCmp("bm").setValue(record.get('code'));//设置页面文本框为树上节点内容
            //Ext.getCmp("mc").setValue(record.get('text'));
            fuc_getCxtGrid(record, "1");
        }
    }
    /**
     * 发行管理信息列表：更新列表数据
     */
    function fuc_getCxtGrid(record, is_leaf) {
        if (is_leaf) {
            CXT_ID = record.get('id');//获取树节点参数值
        } else {
            CXT_ID = '';//获取树节点参数值
        }
        DSYGrid.getGrid('grid').getStore().getProxy().extraParams = {
            CXT_ID: CXT_ID
        };
        DSYGrid.getGrid("grid").getStore().loadPage(1);//刷新数据
        var selected = Ext.ComponentQuery.query('treepanel#jg_tree')[0].getSelectionModel().getSelection();
        var ctx_text =selected[0].data.text;
        if(select_tree_text=='承销团信息'){
            Ext.ComponentQuery.query('button#btnUpdate')[0].setDisabled(true);
            Ext.ComponentQuery.query('button#btnDelete')[0].setDisabled(true);
        }
        Ext.getCmp("bm").setValue(record.get('code'));//设置页面文本框为树上节点内容
        Ext.getCmp("mc").setValue(record.get('text'));
    }
    var current_record;
    function reload_bm() {
        Ext.ComponentQuery.query('treepanel#jg_tree')[0].getStore().load(
            {
                callback : function() {
                    var tree = Ext.ComponentQuery.query('treepanel#jg_tree')[0];
                    tree.getSelectionModel().select(current_record);
                    var records=tree.getSelectionModel().getSelection();
                    DSYGrid.getGrid("grid").getStore().load(
                        {
                            callback: function () {
                                if (records.length == 1) {
                                    Ext.getCmp("bm").setValue(records[0].get('code'));//设置页面文本框为树上节点内容
                                    Ext.getCmp("mc").setValue(records[0].get('text'));

                                    CXT_ID = records[0].get('id');
                                    DSYGrid.getGrid('grid').getStore().getProxy().extraParams = {
                                        CXT_ID: CXT_ID
                                    };
                              /*      var selected = Ext.ComponentQuery.query('treepanel#jg_tree')[0].getSelectionModel().getSelection();
                                    var ctx_text =selected[0].data.text;
                                    if(select_tree_text=='承销团信息'){
                                        Ext.ComponentQuery.query('button#btnUpdate')[0].setDisabled(true);
                                    }else{
                                        Ext.ComponentQuery.query('button#btnUpdate')[0].setDisabled(false);
                                    }*/
                                    DSYGrid.getGrid("grid").getStore().loadPage(1);
                                    Ext.ComponentQuery.query('button#btnUpdate')[0].setDisabled(true);//20210303因为树节点会有默认状态，所以保存成功后将按钮变灰 保证获取的节点为所选中的
                                    Ext.ComponentQuery.query('button#btnDelete')[0].setDisabled(true);
                                }
                            }
                        }
                    );//刷新数据
                }
            }
        );
    }
    /**
     * 发行管理信息列表：更新列表数据
     */
    var editWindow = {
        window: null,
        show: function (title) {
            this.window = Ext.create('Ext.window.Window', {
                title: title,
                itemId: 'addWin',
                width: document.body.clientWidth * 0.9,
                height: document.body.clientHeight * 0.9,
                layout: 'fit',
                maximizable: true,
                frame: true,
                constrain: true,
                buttonAlign: "right", // 按钮显示的位置
                modal: true,
                resizable: true,//大小不可改变
                plain: true,
                items: [cxtxxTab()],
                closeAction: 'destroy',
                buttons: [
                    {
                        xtype: 'button',
                        id: 'SaveBtn',
                        text: '确定',
                        //scale : 'medium',
                        name: 'SAVE',
                        disabled: true,
                        handler: function (btn) {
                            var form = btn.up('window').down('form');
                            var cxt_code = Ext.ComponentQuery.query('textfield[name="CXT_CODE"]')[0].value;
                            var cxt_name = Ext.ComponentQuery.query('textfield[name="CXT_NAME"]')[0].value;
                            if (cxt_code == null || cxt_code == '') {
                                Ext.Msg.alert('提示', '编码不能为空！');
                                return false;
                            }
                            if (cxt_name == null || cxt_name == '') {
                                Ext.Msg.alert('提示', '名称不能为空！');
                                return false;
                            }
                            // 20210726 guoyf 提示信息更改
                            if (!checkLength(cxt_code,'cxt_code')) {
                                Ext.Msg.alert('提示', '编码长度最大为10！');
                                return false;
                            }
                            if (!checkLength(cxt_name,'cxt_name')) {
                                Ext.Msg.alert('提示', '名称长度最大为15！');
                                return false;
                            }
                            // 获取单据明细数组
                            var recordArray = [];
                            var message_error = null;
                            if (form.down('grid').getStore().getCount() <= 0) {
                                Ext.Msg.alert('提示', '请新增表格中的明细记录！');
                                return false;
                            }
                            var cxjgMap = new Map();
                            DSYGrid.getGrid('jgxxGrid').getStore().each(
                                function (record) {
                                    if (!record.get('CXJG_CODE') || record.get('CXJG_CODE') == null) {
                                        message_error = '机构名称不能为空';
                                        return false;
                                    }
                                    var CXJG_CODE = record.get('CXJG_CODE');
                                    if (cxjgMap.containsKey(CXJG_CODE)) {
                                        message_error = '承销机构已选择，请重新操作';
                                        return false;
                                    } else {
                                        cxjgMap.put(CXJG_CODE, CXJG_CODE);
                                    }
                                    recordArray.push(record.getData());
                                });
                            if (message_error != null && message_error != '') {
                                Ext.Msg.alert('提示', message_error);
                                return false;
                            }
                            var parameters = {
                                ELE_AD_CODE: ELE_AD_CODE,
                                button_name: button_name,
                                detailList: Ext.util.JSON.encode(recordArray)
                            };
                            if (button_name == 'UPDATE') {
                                // 获取承销团树上的承销团id 传回后台 对数据进行删除
                                // 然后执行新增操作
                            }
                            if (form.isValid()) {
                                // 保存表单数据及明细数据
                                form.submit({
                                    // 设置表单提交的url
                                    url: 'saveCxtGrid.action',
                                    params: parameters,
                                    success: function (form, action) {
                                        // 关闭弹出框
                                        btn.up("window").close();
                                        // 提示保存成功
                                        Ext.toast({
                                            html: "<center>保存成功!</center>",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                        //保存成功后，进行树和表格的刷新
                                        if(button_name == 'INPUT'){
                                            Ext.ComponentQuery.query('treepanel#jg_tree')[0].getStore().load();
                                            DSYGrid.getGrid('grid').getStore().loadPage(1);
                                        }else{
                                            reload_bm();
                                        }
                                        Ext.ComponentQuery.query('button#btnUpdate')[0].setDisabled(true);//20210303因为树节点会有默认状态，所以保存成功后将按钮变灰 保证获取的节点为所选中的
                                        Ext.ComponentQuery.query('button#btnDelete')[0].setDisabled(true);
                                    },
                                    failure: function (form, action) {
                                        Ext.Msg.alert('提示', "保存失败！" + action.result ? action.result.message : '无返回响应');
                                        DSYGrid.getGrid('grid').getStore().loadPage(1);
                                    }

                                });
                            }
                        }
                    }, {
                        xtype: 'button',
                        text: '取消',
                        //scale : 'medium',
                        name: 'CLOSE',
                        handler: function (btn) {
                            /*
                             * if(button_name=='INPUT'){
                             * Ext.ComponentQuery.query('window#addWin')[0].close(); }
                             * else {
                             * Ext.ComponentQuery.query('window#updateWin')[0].close(); }
                             */
                            btn.up('window').close();
                            Ext.ComponentQuery.query('button#btnUpdate')[0].setDisabled(true);//20210303因为树节点会有默认状态，所以保存成功后将按钮变灰 保证获取的节点为所选中的
                            Ext.ComponentQuery.query('button#btnDelete')[0].setDisabled(true);
                        }
                    }
                ]
            });
            this.window.show();
        }
    };
    /**
     * 承销团注册页面
     */
    function fuc_addCxtgl() {
        button_name = 'INPUT';//按钮名称为INPUT
        editWindow.show("承销团注册");
    }
    /**
     * 修改
     */
    function fuc_updateFxgl() {
        var selected = Ext.ComponentQuery.query('treepanel#jg_tree')[0].getSelectionModel().getSelection();
        var ctx_text =selected[0].data.text;
        if(select_tree_text=='承销团信息'){
            Ext.MessageBox.alert('提示','根节点不允许修改');
            return;
        }
        var selected_id = selected[0].data.id;
        button_name = 'UPDATE';//按钮名称为INPUT
        if (select_tree_id == null || select_tree_id == '') {//如果为默认选择树的节点
            //发送ajax请求，查询承销团主表和明细表数据
            $.post("/getCxtxxByCxtId.action", {
                CXT_ID: selected_id
            }, function (data) {
                if (!data.success) {
                    Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    return;
                }
                //弹出弹出框，并将表数据插入到弹出框form中
                editWindow.show("承销团修改");
                editWindow.window.down('form').getForm().setValues(data.data);
                var store = editWindow.window.down('form').down('grid#jgxxGrid').getStore();
                store.loadData(data.list);
            }, "json");
        } else {
            //发送ajax请求，查询承销团主表和明细表数据
            $.post("/getCxtxxByCxtId.action", {
                CXT_ID: select_tree_id
            }, function (data) {
                if (!data.success) {
                    Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    return;
                }
                //弹出弹出框，并将表数据插入到弹出框form中
                editWindow.show("承销团修改");
                editWindow.window.down('form').getForm().setValues(data.data);
                var store = editWindow.window.down('form').down('grid#jgxxGrid').getStore();
                store.loadData(data.list);
            }, "json");
        }

    }
    /**
     * 删除
     */
    function fuc_deleteFxgl() {
        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                button_name = "删除";
                var ids = [];
                ids.push(select_tree_id);
                //发送ajax请求，删除数据
                $.post("/deleteCxtxxByCxtId.action", {
                    ids: ids
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: button_name + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        //刷新当前页面
                        Ext.ComponentQuery.query('treepanel#jg_tree')[0].getStore().load();
                        DSYGrid.getGrid('grid').getStore().loadPage(1);
                    } else {
                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    }
                    Ext.ComponentQuery.query('button#btnUpdate')[0].setDisabled(true);//20210303因为树节点会有默认状态，所以保存成功后将按钮变灰 保证获取的节点为所选中的
                    Ext.ComponentQuery.query('button#btnDelete')[0].setDisabled(true);
                }, "json");
            }else {
                Ext.ComponentQuery.query('button#btnUpdate')[0].setDisabled(true);//20210303因为树节点会有默认状态，所以保存成功后将按钮变灰 保证获取的节点为所选中的
                Ext.ComponentQuery.query('button#btnDelete')[0].setDisabled(true);
            }
        });
    }
</script>
</body>
</html>