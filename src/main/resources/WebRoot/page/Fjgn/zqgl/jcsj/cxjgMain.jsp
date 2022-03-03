<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>承销机构维护</title>
    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
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
<%--获取登录用户--%>
<script type="text/javascript">

    var store_status = DebtEleStore([
        {id: "0", code: "0", name: "停用"},
        {id: "1", code: "1", name: "启用"}
    ]);
    var store_is_ksc = DebtEleStore([//是否跨市场
        {id: "0", code: "0", name: "否"},
        {id: "1", code: "1", name: "是"}
    ]);
    /**
     * 获取登录用户
     */
    var button_name='';
    var userCode = '${sessionScope.USERCODE}';
    var condition=" and code like '01_%' ";
    var jgmlStore = DebtEleTreeStoreDB("DEBT_ZQR",{condition: condition});
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

            });
        } else {
            initMain();
        }
    });
    /**
     * 主界面初始化
     */
    function initMain() {
        /**
         * 初始化顶部功能按钮
         */

        var tbar = Ext.create('Ext.toolbar.Toolbar', {
            border: false,
            items: [
                {
                    xtype: 'button',
                    text: '录入',
                    name: 'btn_insert',
                    icon: '/image/sysbutton/regist.png',
                    handler: function () {
                    	button_name = 'INPUT';
                        fuc_addCxtgl();
                    }
                },
                {
                    xtype: 'button',
                    text: '修改',
                    name: 'btn_update',
                    icon: '/image/sysbutton/edit.png',
                    handler: function () {
                    	button_name = 'UPDATE';
                        fuc_updateFxgl();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        });

        /**
         * 承销机构信息列表表头
         */
        var headerJson = [
            {
                xtype: 'rownumberer',
                width: 35
            },
            {
                "dataIndex": "GUID",
                "type": "string",
                "text": "机构ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "CODE",
                "type": "string",
                "text": "机构编码",
                "fontSize": "15px",
                "width": 120
            },
            {
                "dataIndex": "NAME",
                "type": "string",
                "text": "机构名称",
                "fontSize": "15px",
                "width": 150
            },
            { "dataIndex": "CXS_TGZH",
                "type": "string",
                "text": "中债登托管账号",
                 hidden:false,
                "fontSize": "15px",
                "width": 150
            },
            { "dataIndex": "CXS_ZZDZH",
                "type": "string",
                "text": "中证登托管账号",
                 hidden:false,
                "fontSize": "15px",
                "width": 150
            },
            { "dataIndex": "JGML_NAME",
                "type": "string",
                "text": "机构名录",
                hidden:false,
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "CXJG_ACCOUNT_NO",
                "width": 150,
                "type": "string",
                 hidden:false,
                "text": "收款账号"
            },
            {
                "dataIndex": "CXJG_ACCOUNT_NAME",
                "width": 180,
                "type": "string",
                 hidden:false,
                "text": "收款账户名称"
            },
            {
                "dataIndex": "CXJG_ACCOUNT_BANK",
                "width": 180,
                "type": "string",
                 hidden:false,
                "text": "收款账户银行"
            },
            {dataIndex: "YEAR", type: "int", text: "年度",  hidden:true},
            {
                dataIndex: "STATUS", type: "string", text: "状态",
                renderer: function (value, cell) {
                    var record = store_status.findRecord('code', value, 0, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            },
            {
                dataIndex: "STARTTIME", type: "string", text: "生效时间",
                editor: {
                    xtype: 'datefield',
                    format: 'Ymd'
                }
            },
            {
                dataIndex: "ENDTIME", type: "string", text: "失效时间",
                editor: {
                    xtype: 'datefield',
                    format: 'Ymd'
                }
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
            autoLoad: true,
            dataUrl: '/getCxjgGrid.action',
            checkBox: false,
            border: false,
            height: '100%',
            tbar:[
                {
                    xtype: "textfield",
                    fieldLabel: '模糊查询',
                    itemId: 'contentGrid_search',
                    width: 300,
                    columnWidth: .66,
                    labelWidth: 60,
                    labelAlign: 'right',
                    emptyText: '请输入检索机构编码／机构名称',
                    enableKeyEvents: true,
                    listeners: {
                        'keydown': function (self, e) {
                            var key = e.getKey();
                            if (key == Ext.EventObject.ENTER) {
                                reloadGrid();
                            }
                        }
                    }
                },{
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                }
            ],
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
                grid
            ],
            tbar: tbar
        });
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
                width: 800,
                height: 330,
                layout: 'fit',
                maximizable: true,
                frame: true,
                constrain: true,
                buttonAlign: "right", // 按钮显示的位置
                modal: true,
                resizable: true,//大小不可改变
                plain: true,
                items: [cxjgxx()],
                closeAction: 'destroy',
                buttons: [
                    {
                        xtype: 'button',
                        id: 'SaveBtn',
                        text: '保存',
                        //scale : 'medium',
                        name: 'SAVE',
                        handler: function (btn) {
                            var form = btn.up('window').down('form');
                            var cxt_code = Ext.ComponentQuery.query('textfield[name="CXJG_CODE"]')[0].value;
                            var cxt_name = Ext.ComponentQuery.query('textfield[name="CXJG_NAME"]')[0].value;
                            var cxjg_account_no = Ext.ComponentQuery.query('textfield[name="CXJG_ACCOUNT_NO"]')[0].value;
                            var cxjg_account_name = Ext.ComponentQuery.query('textfield[name="CXJG_ACCOUNT_NAME"]')[0].value;
                            var cxjg_account_bank = Ext.ComponentQuery.query('textfield[name="CXJG_ACCOUNT_BANK"]')[0].value;
                            if (cxt_code == null || cxt_code == '') {
                                Ext.Msg.alert('提示', '机构编码不能为空！');
                                return false;
                            }
                            if (cxt_name == null || cxt_name == '') {
                                Ext.Msg.alert('提示', '机构名称不能为空！');
                                return false;
                            }
                            if (cxjg_account_no != undefined && cxjg_account_no != '' && getStringLength(cxjg_account_no) > 30) {
                                Ext.Msg.alert('提示', '收款账号不能大于30字符！');
                                return false;
                            }
                            if (cxjg_account_name != undefined && cxjg_account_name != '' && getStringLength(cxjg_account_name) > 100) {
                                Ext.Msg.alert('提示', '收款账户名称不能大于100字符！');
                                return false;
                            }
                            if (cxjg_account_bank != undefined && cxjg_account_bank != '' && getStringLength(cxjg_account_bank) > 100) {
                                Ext.Msg.alert('提示', '收款账户银行不能大于100字符！');
                                return false;
                            }
                            submitInfo(form);
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
        editWindow.show("承销机构注册");
    }
    /**
     * 修改
     */
    function fuc_updateFxgl() {
		var record = DSYGrid.getGrid('grid').getCurrentRecord();
		if(record == null || record == 'null' || record == 'undefined'){
	        Ext.MessageBox.alert('提示', '请选择一条记录！');
	        return;
		}
		editWindow.show("承销机构修改");
		record.data.CXJG_CODE = record.data.CODE;
		record.data.CXJG_NAME = record.data.NAME;
		var form = Ext.ComponentQuery.query('form#editForm')[0];
		form.getForm().setValues(record.getData());
    }

    
    function cxjgxx() {
    var edit = false;
    if(button_name == 'UPDATE'){
    	edit = true;
    }else{
    	edit = false;
    }
    
    var editPanel = Ext.create('Ext.form.Panel', {
    	itemId: 'editForm',
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
                    columnWidth: .5,
                    labelWidth: 125//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>机构编码',
                        name: "CXJG_CODE",
                        allowBlank: false,
                        vtype: 'vTszf',
                        emptyText: '请输入...',
                        readOnly: edit
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '<span class="required">✶</span>机构名称',
                        name: "CXJG_NAME",
                        allowBlank: false,
                        emptyText: '请输入...',
                        vtype: 'vTszf'
                    },
                    {
                        xtype: "treecombobox",
                        fieldLabel: '<span class="required">✶</span>机构名录',
                        name: "JGML_ID",
                        store: jgmlStore,
                        displayField: "name",
                        valueField: "id",
                        allowBlank: false,
                        editable: true, //启用编辑
                        selectModel: 'leaf'
                    },
                    {
                        xtype: "combobox",
                        name: "YEAR",
                        store: DebtEleStoreDB("DEBT_YEAR",{condition:" and code >= '2015'"}),
                        displayField: "name",
                        valueField: "id",
                        value: new Date().getFullYear(),
                        fieldLabel: '<span class="required">✶</span>年度',
                        hidden:true,
                        allowBlank: false,
                        editable: false //禁用编辑
                    },
                    {
                        xtype: "combobox",
                        name: "STATUS",
                        store: store_status,
                        displayField: "name",
                        valueField: "id",
                        value:1,
                        fieldLabel: '<span class="required">✶</span>状态',
                        allowBlank: false,
                        editable: false //禁用编辑
                    },
                    {
                        xtype: "datefield",
                        name: "STARTTIME",
                        fieldLabel: '<span class="required">✶</span>生效时间',
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择开始日期',
                        emptyText: '请选择开始日期',
                        value: today
                    },
                    {
                        xtype: "datefield",
                        name: "ENDTIME",
                        fieldLabel: '失效时间',
                        format: 'Y-m-d'
                    }
                ]
            },
            {//分割线
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
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .5,
                    labelWidth: 125//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '收款账号',
                        name: "CXJG_ACCOUNT_NO",
                        allowBlank: true,
                        hidden:false,
                        vtype: 'vTszf',
                        emptyText: '请输入...'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '收款账户名称',
                        name: "CXJG_ACCOUNT_NAME",
                        allowBlank: true,
                        hidden:false,
                        vtype: 'vTszf',
                        emptyText: '请输入...'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '收款账户银行',
                        name: "CXJG_ACCOUNT_BANK",
                        allowBlank: true,
                        hidden:false,
                        vtype: 'vTszf',
                        emptyText: '请输入...'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '中债登托管账号',
                        name: "CXS_TGZH",
                        allowBlank: true,
                        hidden:false,
                        vtype: 'vTszf',
                        emptyText: '请输入...'

                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '中证登托管账号',
                        name: "CXS_ZZDZH",
                        allowBlank: true,
                        hidden:false,
                        vtype: 'vTszf',
                        emptyText: '请输入...'
                    },
                    {
                        xtype: "combobox",
                        name: "IS_KSC",
                        store: store_is_ksc,
                        displayField: "name",
                        valueField: "id",
                        value: 0,
                        fieldLabel: '是否跨市场',
                        allowBlank: false,
                        editable: false //禁用编辑
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '业务联系人',
                        name: "CXS_YWLXR",
                        allowBlank: true,
                        hidden:false,
                        vtype: 'vTszf',
                        emptyText: '请输入...'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '投标联系人',
                        name: "CXS_TBLXR",
                        allowBlank: true,
                        hidden:false,
                        vtype: 'vTszf',
                        emptyText: '请输入...'
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '联系电话',
                        name: "CXS_TEL",
                        allowBlank: true,
                        hidden:false,
                        vtype: 'vTszf',
                        emptyText: '请输入...'
                    }
                ]
            }
        ]
    });
    return editPanel;
}

/**
 * 提交表单数据
 * @param form
 */
function submitInfo(form) {
    var url = '';
    url = 'saveCxjg.action?button_name=' + button_name;

    if (form.isValid()) {
        var a=form.getValues();
        var start_time = a['STARTTIME'];
        var end_time = a['ENDTIME'];
        if (end_time != undefined && end_time != '' && start_time > end_time) {
            Ext.Msg.alert('提示','失效时间早于生效时间！');
            return false;
        }
        var zz=a['CXS_ZZDZH']; //'中证登托管账号'
        var dd=a['CXS_TGZH']; //'中债登托管账号'
        if(zz!=''&&zz.length>0||dd!=''&&dd.length>0){
            form.submit({
                url: url,
                waitTitle: '请等待',
                waitMsg: '正在加载中...',
                submitEmptyText:false,
                success: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '保存成功',
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function (btn) {
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                            Ext.ComponentQuery.query('window#addWin')[0].close();
                        }
                    });
                },
                failure: function (form, action) {
                    var result = Ext.util.JSON.decode(action.response.responseText);
                    Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                }
            });
        }else{
            Ext.Msg.alert('提示','中证登托管账号或中债登托管账号至少选填一个');
        }

    } else {
        Ext.Msg.alert('提示', '请将必填项补充完整！');
    }
}
function reloadGrid(param, param_detail){
    var cxjgGrid = DSYGrid.getGrid('grid');
    var cxjgStore = cxjgGrid.getStore();
    var mhcx = Ext.ComponentQuery.query('textfield#contentGrid_search')[0].getValue();
    cxjgStore.getProxy().extraParams['mhcx'] = mhcx;
    cxjgStore.loadPage(1);
}
</script>
</body>
</html>