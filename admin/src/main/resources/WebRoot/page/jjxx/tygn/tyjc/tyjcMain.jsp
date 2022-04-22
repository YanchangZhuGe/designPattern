<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>通用基础数据管理</title>
    <script src="/js/commonUtil.js"></script>
    <%--<script src="/js/plat/dateFormat.js"></script>--%>
    <style type="text/css">
        html, body {
            width: 100%;
            height: 100%;
            margin: 0px auto;
        }
    </style>
</head>
<body>
<script>
    var flag_edit = false;//表格编辑状态
    //数据集:状态
    var store_status = DebtEleStore([
        {id: "0", code: "0", name: "停用"},
        {id: "1", code: "1", name: "启用"}
    ]);
    
   /*启用停用，参数及数据库url中#号的处理*/
    var table_name = "${fns:getParamValue('table_name')}";
    var is_pt = "";
    var ysjm = "";
    var singleEle = false;
    if(table_name != "" && table_name != null && table_name != "undefined"){
    	singleEle = true;
    }

    
    //数据集：限额批次
    /* var store_xepc = null; */
    /**
     * 页面加载完成后执行
     */
    Ext.onReady(function () {
        /*预加载控件*/
        Ext.require([
            'Ext.tree.*',
            'Ext.data.*',
            'Ext.layout.container.HBox',
            'Ext.dd.*',
            'Ext.window.MessageBox'
        ]);
        //加载主表格
        initContent();
        //刷新功能区按钮
        refreshButtonStatus();
    });
    /**
     * 初始化主面板
     */
    function initContent() {
        //功能区按钮
        var tbar = [
            {
                text: '编辑',
                name: 'edit',
                xtype: 'button',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    flag_edit = true;
                    refreshButtonStatus();
                    
                }
            },
            {
                text: '取消编辑',
                name: 'cancel',
                xtype: 'button',
                disabled: true,
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    flag_edit = false;
                    //刷新功能区按钮状态
                    refreshButtonStatus();
                    //取消修改数据
                    DSYGrid.getGrid('contentGrid').getStore().rejectChanges();
                }
            },
            {
                text: '保存',
                name: 'save',
                xtype: 'button',
                disabled: true,
                icon: '/image/sysbutton/save.png',
                handler: function (btn) {
                    var grid = DSYGrid.getGrid("contentGrid");
                    var store = grid.getStore();
                    var records_add = store.getNewRecords();//新增行
                    var records_update = store.getUpdatedRecords();//修改行
                    if (!validateGrid(grid)) {
                        return false;
                    }
                    for (var i = 0; i < records_add.length; i++) {
                        records_add[i] = records_add[i].data;
                    }
                    for (var i = 0; i < records_update.length; i++) {
                        records_update[i] = records_update[i].data;
                    }
                    $.post('/tygn/saveTygnTyjcGrid.action', {
                        listAdd: Ext.util.JSON.encode(records_add),
                        listUpdate: Ext.util.JSON.encode(records_update),                      
                        /*保存，参数及数据库url中#号的处理*/
                        table_name:table_name,
                        is_pt:is_pt,
                        ysjm:ysjm
                    }, function (data) {
                        if (data.success) {
                            flag_edit = false;
                            //修改按钮状态
                            refreshButtonStatus();
                            // 刷新表格
                            DSYGrid.getGrid("contentGrid").getStore().load();
                            Ext.toast({
                                html: "保存成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                        }
                    }, 'JSON');
                }
            },
            {
                text: '增行',
                name: 'add',
                xtype: 'button',
                disabled: true,
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    DSYGrid.getGrid('contentGrid').insertData(null, {
                        STATUS: 1,
                        YEAR: new Date().getFullYear(),
                        STARTTIME: Ext.util.Format.date(new Date(), 'Ymd')
                    });
                }
            },
            
            	{
                text: '删行',
                name: 'delete',
                xtype: 'button',
                disabled: true,
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    var grid = DSYGrid.getGrid('contentGrid');
                    var records = grid.getSelection();
                    //校验只能删除新增行
                    for (var i = 0; i < records.length; i++) {
                        var id = records[i].get('GUID');
                        if (typeof id != 'undefined' && id != null && id.length > 0) {
                            Ext.Msg.alert('提示', '只能删除新增行！');
                            return false;
                        }
                    }
                    grid.getStore().remove(grid.getSelection());
                }
            },
            {
                text: '启用',
                name: 'start',
                xtype: 'button',
                status: 1,
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    button_name = btn.text;
                    updateTyjcStatus(btn);
                }
            },
            {
                text: '停用',
                name: 'end',
                xtype: 'button',
                status: 0,
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    button_name = btn.text;
                    updateTyjcStatus(btn);
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ];
        //页面主panel
        Ext.create('Ext.panel.Panel', {
            renderTo: Ext.getBody(),
            width: '100%',
            height: '100%',
            itemId: 'contentPanel',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: tbar
                }
            ],
            items: [
                initContentGrid()//初始化主表格
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex: "CODE", type: "string", text: "编码", width: 150, editor: 'textfield',
                renderer: function (value, cell) {
                    //修改作为必选项的背景色
                    if (flag_edit && (value == null || value.length <= 0)) {
                        cell.tdCls = 'grid-cell';
                    }
                    return value;
                }
            },
            {
                dataIndex: "NAME", type: "string", text: "名称", width: 150, editor: 'textfield',
                renderer: function (value, cell) {
                    //修改作为必选项的背景色
                    if (flag_edit && (value == null || value.length <= 0)) {
                        cell.tdCls = 'grid-cell';
                    }
                    return value;
                }
            }, 
            {dataIndex: "YEAR", type: "int", text: "年度", editor: 'numberfield'},
            {
                dataIndex: "STATUS", type: "string", text: "状态",
                renderer: function (value, cell) {
                    //修改作为必选项的背景色
                    if (flag_edit && (value == null || value.length <= 0)) {
                        cell.tdCls = 'grid-cell';
                    }
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
           
        ];
        
		var eleStore = Ext.create('Ext.data.Store', {
	        fields: ["ID", "CODE", "NAME", "TABLECODE", "IS_PT"],
	        remoteSort: true,// 后端进行排序
	        proxy: {// ajax获取后端数据
	            type: "ajax",
	            method: "POST",
	            url: "/tygn/getSysElement.action",
	            reader: {
	                type: "json",
	                root: "list"
	            },
	            simpleSortMode: true
	        },
	        autoLoad: true
	    });
        
        var grid = DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            border: false,
            width: '100%',
            height: '100%',
            flex: 1,
            tbar: [
	            {
	                xtype: 'combobox',
	                fieldLabel: '基础数据',
	                itemId: 'sys_ele',
	                name: 'sys_ele',
	                store: eleStore,
	                width: 300,
	                editable: false,
	                labelWidth: 60,
	                labelAlign: 'right',
	                allowBlank: false,
	                displayField: "NAME",
	                valueField: "TABLECODE",
					readOnly:table_name == "" ? false : true,
	                listeners: {
	                    change: function (self, newValue) {
	                    	var record = eleStore.findRecord('TABLECODE', newValue, 0, false, true, true);
							table_name = newValue;
							is_pt = record.get("IS_PT");
							ysjm = record.get("CODE");
	                        //刷新当前表格
	                        self.up('grid').getStore().getProxy().extraParams["table_name"] = table_name;
	                        self.up('grid').getStore().getProxy().extraParams["is_pt"] = is_pt;
	                        self.up('grid').getStore().loadPage(1);
	                    }
	                }
	            }
	        ],
            dataUrl: '/tygn/getTygnTyjcGrid.action',
            autoLoad: table_name == "" ? false : true,
            /*初始化主表格，参数及数据库url中#号的处理*/            
            params: {
	        	table_name: table_name,
	        	is_pt:is_pt
	        },
            pageConfig: {
                enablePage: false
            },
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'contentGrid_cellediting',
                    clicksToMoveEditor: 1,
                    listeners: {
                        edit: function (editor, context) {
                            //设置格式化起始日期/终结日期
                            if (context.field == 'STARTTIME' || context.field == 'ENDTIME') {
                                context.record.set(context.field, Ext.util.Format.date(context.value, 'Ymd'));
                            }
                           
                            
                        },
                        beforeedit: function (editor, context) {
                            return flag_edit;//是否可编辑
                        }
                    }
                }
            ],
            listeners: {
                selectionchange: function (view, records) {
                    //切换工具栏按钮禁用状态
                    refreshButtonStatus();
                }
            }
        });
        if(singleEle){
        	var combobox = Ext.ComponentQuery.query('combobox#sys_ele')[0];
	        combobox.setValue(table_name);
        }
        
        return grid;
    }
    /**
     * 刷新功能按钮状态
     */
    function refreshButtonStatus() {
        //获取工具栏
        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
        
        //根据编辑状态修改工具栏按钮启用停用状态
        toolbar.down('button[name="edit"]').setDisabled(flag_edit);
        if(!singleEle){
	        var combobox = Ext.ComponentQuery.query('combobox#sys_ele')[0];
	        combobox.setReadOnly(flag_edit);
        }
        
        toolbar.down('button[name="save"]').setDisabled(!flag_edit);
        toolbar.down('button[name="cancel"]').setDisabled(!flag_edit);
        toolbar.down('button[name="add"]').setDisabled(!flag_edit);
        toolbar.down('button[name="delete"]').setDisabled(!flag_edit);
        toolbar.down('button[name="start"]').setDisabled(flag_edit);
        toolbar.down('button[name="end"]').setDisabled(flag_edit);
        //按钮启用停用状态
        var flag_selected = (typeof DSYGrid.getGrid('contentGrid').getSelection().length != 'undefined' && DSYGrid.getGrid('contentGrid').getSelection().length > 0);
        if (!flag_edit) {
            flag_selected = false;
        }
        toolbar.down('button[name="delete"]').setDisabled(!flag_selected);
       
    }
    /**
     * 启用/停用
     */
    function updateTyjcStatus(btn) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("GUID"));
            records[i].set('STATUS', btn.status);
        }
        //发送ajax请求，启用数据
        $.post("/tygn/updateTygnTyjcStatus.action", {
	         ids: ids,
	         /*保存，参数及 数据库url中#号的处理*/
	         table_name:table_name,
	         is_pt:is_pt,
	         ysjm : ysjm,
	         STATUS: btn.status
         }, function (data) {
	         if (data.success) {
		         Ext.toast({
			         html: button_name + "成功！",
			         closable: false,
			         align: 't',
			         slideInDuration: 400,
			         minWidth: 400
		         });
	         } else {
	         /* Ext.MessageBox.alert('提示', button_name + '失败！' + data.message); */
	        	Ext.MessageBox.alert('提示', button_name + '成功！');
	         }
         }, "json");
    }
    /**
     * 校验表格数据
     * @param grid 表格
     * @returns {boolean}
     */
    function validateGrid(grid) {
        var grid = DSYGrid.getGrid("contentGrid");
        var store = grid.getStore();
        var records_add = store.getNewRecords();//新增行
        var records_update = store.getUpdatedRecords();//修改行
        var records_all = records_add.concat(records_update);
        //循环数据校验生效时间/失效时间
        for (var i = 0; i < records_all.length; i++) {
            var starttime = records_all[i].data.STARTTIME;
            var endtime = records_all[i].data.ENDTIME;
            var code = records_all[i].data.CODE;
            var name = records_all[i].data.NAME;
            var year = records_all[i].data.YEAR;
             //去空格
            code = code.trim();
            name = name.trim();
            //校验非空
            if (typeof code == 'undefined' || code == null || code.length <= 0) {
                Ext.Msg.alert('提示', '编码不能为空');
                return false;
            }
            if (typeof name == 'undefined' || name == null || name.length <= 0) {
                Ext.Msg.alert('提示', '名称不能为空');
                return false;
            }
            if (typeof year == 'undefined' || year == null || year.length <= 0 || year == 0) {
                Ext.Msg.alert('提示', '年度不能为空');
                return false;
            }
            //校验编码是否重复
            var codeArr = store.queryRecords('CODE', code);
            if (codeArr != null && codeArr.length > 1) {
                Ext.Msg.alert('提示', name + '批次编码重复！');
                return false;
            }
            if (starttime != null && starttime.length > 0 && endtime != null && endtime.length > 0) {
                if (parseInt(starttime) > parseInt(endtime)) {
                    Ext.Msg.alert('提示', '失效时间不能早于生效时间');
                    return false;
                }
            }
        }
        return true;
    }
</script>
</body>
</html>