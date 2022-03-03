<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>承销机构分组</title>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
</head>
<body>

</body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var ad_code = '${sessionScope.ADCODE}';  // 获取地区名称
    // 自定义参数
    var button_name = ''; // 当前操作按钮名称id
    var button_text = ''; // 当前操作按钮名称text
    var flag_edit = false; // 表格编辑状态
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        Ext.create('Ext.panel.Panel', {
            height: '100%',
            layout: 'fit',
            renderTo: Ext.getBody(),
            border: false,
            items: [
                initContentGrid()// 初始化右侧表格
            ]
        });

        /**
         * 初始化右侧主表格
         */
        function initContentGrid() {
            var headerJson = [
                {
                    xtype: 'rownumberer', width: 45, summaryType: 'count',
                    summaryRenderer: function () {
                        return '合计';
                    }
                },
                {
                    type: "string",
                    text: "承销机构分组ID",
                    dataIndex: "CXJG_GROUP_ID",
                    width: 170,
                    hidden: true
                },
                {
                    type: "string",
                    text: "承销机构分组编码",
                    dataIndex: "CXJG_GROUP_CODE",
                    width: 150,
                    headerMark: 'star',
                    align: 'left',
                    'editor': {
                        xtype: 'textfield',
                        allowBlank: false,
                        maxLength: '180'
                    }
                },
                {
                    type: "string",
                    text: "承销机构分组名称",
                    dataIndex: "CXJG_GROUP_NAME",
                    width: 200,
                    headerMark: 'star',
                    align: 'left',
                    'editor': {
                        xtype: 'textfield',
                        allowBlank: false,
                        maxLength: '180'
                    }
                },
                {
                    type: "string",
                    text: "承销机构编码",
                    dataIndex: "CXJG_CODE",
                    width: 150,
                    headerMark: 'star',
                    align: 'left',
                    'editor': {
                        xtype: 'textfield',
                        allowBlank: false,
                        maxLength: '180'
                    }
                },
                {
                    type: "string",
                    text: "承销机构名称",
                    dataIndex: "CXJG_NAME",
                    width: 200,
                    headerMark: 'star',
                    align: 'left',
                    'editor': {
                        xtype: 'textfield',
                        allowBlank: false,
                        maxLength: '180'
                    }
                }
            ];
            var grid = DSYGrid.createGrid({
                flex: 1,
                itemId: 'contentGrid',
                autoLoad: true, // 是否加载数据
                rowNumber: true,  // 显示行号
                border: false,    // 不显示边框
                checkBox: true, // 显示复选框
                sortableColumns: false, // 禁止表格列排序
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                dockedItems: [
                    {
                        xtype: 'toolbar',
                        dock: 'top',
                        itemId: 'contentPanel_toolbar',
                        items: [
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
                                xtype: 'button',
                                name:'btn_tbsm',
                                text: '填报说明',
                                disabled: true,
                                handler: function (btn) {
                                    window.open('/page/debt/zqgl/cxtgl/cxjgGroupText.jsp');
                                }
                            },
                            {
                                xtype: 'button',
                                text: '增行',
                                name: 'btn_add',
                                disabled: true,
                                icon: '/image/sysbutton/add.png',
                                handler: function (btn) {
                                    button_name = btn.name;
                                    button_text = btn.text;
                                    create_cxjgSelectWindow(btn);
                                }
                            },
                            {
                                xtype: 'button',
                                text: '删行',
                                name: 'btn_del',
                                disabled: true,
                                icon: '/image/sysbutton/edit.png',
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
                                text: '保存',
                                name: 'btn_save',
                                disabled: true,
                                icon: '/image/sysbutton/delete.png',
                                handler: function (btn) {
                                    var cxjgfzStore = DSYGrid.getGrid('contentGrid').getStore();
                                    var cxjgfzStore_data = new Array();
                                    for (var i = 0; i < cxjgfzStore.getCount(); i++) {
                                        var record = cxjgfzStore.getAt(i).getData();
                                        if (record.CXJG_GROUP_CODE == null || record.CXJG_GROUP_CODE == '') {
                                            Ext.Msg.alert('提示', '第' + (i + 1) + '行，承销机构分组编码不能为空!');
                                            return false;
                                        }
                                        if (record.CXJG_GROUP_NAME == null || record.CXJG_GROUP_NAME == '') {
                                            Ext.Msg.alert('提示', '第' + (i + 1) + '行，承销机构分组名称不能为空!');
                                            return false;
                                        }
                                        if (record.CXJG_CODE == null || record.CXJG_CODE == '') {
                                            Ext.Msg.alert('提示', '第' + (i + 1) + '行，承销机构编码不能为空!');
                                            return false;
                                        }
                                        if (record.CXJG_NAME == null || record.CXJG_NAME == '') {
                                            Ext.Msg.alert('提示', '第' + (i + 1) + '行，承销机构名称不能为空!');
                                            return false;
                                        }
                                        cxjgfzStore_data.push(record);
                                    }
                                    $.post('saveCxjgGroupInfo.action', {
                                        button_name: button_name,//录入还是修改
                                        cxjgfzStore: encode64(Ext.util.JSON.encode(cxjgfzStore_data))
                                    }, function (data) {
                                        if (data.success) {
                                            Ext.toast({
                                                html: '保存成功！',
                                                closable: false,
                                                align: 't',
                                                slideInDuration: 400,
                                                minWidth: 400
                                            });
                                            // 刷新表格
                                            reloadGrid()
                                        } else {
                                            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                                            btn.setDisabled(false);
                                        }
                                    }, 'JSON');
                                }
                            },
                            {
                                xtype: "textfield",
                                fieldLabel: '模糊查询',
                                itemId: "btn_search",
                                labelWidth: 80,
                                width: 300,
                                emptyText: '请输入承销机构编码/承销机构名称...',
                                enableKeyEvents: true,
                                listeners: {
                                    'keydown': function (self, e, eOpts) {
                                        var key = e.getKey();
                                        if (key == Ext.EventObject.ENTER) {
                                            reloadGrid();
                                        }
                                    }
                                }
                            },
                            {
                                xtype: 'button',
                                text: '查询',
                                name: 'btn_search',
                                icon: '/image/sysbutton/search.png',
                                handler: function (btn) {
                                    reloadGrid();
                                }
                            },

                            '->',
                            initButton_OftenUsed(),
                            initButton_Screen()
                        ]
                    }
                ],
                dataUrl: 'getCxjgGroupInfo.action',
                params: {},
                pageConfig: {
                    pageNum: false,//设置显示每页条数
                    enablePage: false
                },
                plugins: [
                    {
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        pluginId: 'cellEdit_cxjgfzhz_ID',
                        clicksToMoveEditor: 1
                    }
                ],
                listeners: {
                    beforeedit: function (editor, context) {
                        return flag_edit; // 是否可编辑
                    }
                }
            });
            return grid;
        }

        /**
         * 刷新功能按钮状态
         */
        function refreshButtonStatus() {
            //获取工具栏
            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];

            // 根据编辑状态修改工具栏按钮启用停用状态
            toolbar.down('textfield[itemId="btn_search"]').setDisabled(flag_edit);  // 模糊查询
            toolbar.down('button[name="btn_search"]').setDisabled(flag_edit);  // 查询
            toolbar.down('button[name="edit"]').setDisabled(flag_edit);  // 编辑
            toolbar.down('button[name="cancel"]').setDisabled(!flag_edit); // 取消编辑
            toolbar.down('button[name="btn_tbsm"]').setDisabled(!flag_edit); // 填报说明
            toolbar.down('button[name="btn_save"]').setDisabled(!flag_edit); // 保存
            toolbar.down('button[name="btn_add"]').setDisabled(!flag_edit); // 新增
            toolbar.down('button[name="btn_del"]').setDisabled(!flag_edit); // 删除


        }
    });

    /**
     *  初始化承销机构选择窗口
     */
    function create_cxjgSelectWindow(btn) {
        var window = Ext.create('Ext.window.Window', {
            title: '承销机构选择', // 窗口标题
            itemId: 'item_cxjgSelect_windows', // 窗口标识
            layout: 'fit',
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.9, //自适应窗口高度
            maximizable: true,
            buttonAlign: 'right', // 按钮显示的位置
            closeAction: 'destroy',
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            items: [init_cxjgSelect_Grid(btn)],
            buttons: [
                {
                    text: '确定',
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('item_cxjgSelect_Grid').getSelection();
                        if (records.length < 1) {
                            Ext.toast({
                                html: "请选择至少一条数据后再进行操作!",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        } else {
                            btn.setDisabled(true);
                            // 赋值
                            for (var record_seq in records) {
                                if (!haveCxjg(record_seq)) {
                                    DSYGrid.getGrid('contentGrid').insertData(null, records[record_seq].getData());
                                } else {
                                    return Ext.toast({
                                        html: "当前选择的承销机构中包含已分组机构数据!",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                }
                            }
                            btn.up('window').close();
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
        window.show();
        return window;

        /**
         *  初始化承销机构选择grid
         */
        function init_cxjgSelect_Grid(btn) {
            var headerJson = [
                {
                    xtype: 'rownumberer',
                    width: 35
                },
                {
                    dataIndex: "CXJG_GROUP_ID",
                    type: "string",
                    text: "承销机构分组ID",
                    fontSize: "15px",
                    hidden: true,
                    width: 50
                },
                {
                    dataIndex: "CXJG_ID",
                    type: "string",
                    text: "承销机构ID",
                    fontSize: "15px",
                    hidden: true,
                    width: 80
                },
                {
                    dataIndex: "CXJG_CODE",
                    type: "string",
                    text: "承销机构编码",
                    fontSize: "15px",
                    width: 150
                },
                {
                    dataIndex: "CXJG_NAME",
                    type: "string",
                    text: "承销机构名称",
                    fontSize: "15px",
                    width: 250
                }
            ];
            var grid = DSYGrid.createGrid({
                flex: 1,
                itemId: 'item_cxjgSelect_Grid',
                autoLoad: true,//是否加载数据
                border: false,
                checkBox: true,
                sortableColumns: false,
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                tbar: [
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: "btn_search",
                        labelWidth: 80,
                        width: 300,
                        emptyText: '请输入承销机构编码/承销机构名称',
                        enableKeyEvents: true,
                        listeners: {
                            'keydown': function (self, e, eOpts) {
                                var key = e.getKey();
                                if (key == Ext.EventObject.ENTER) {
                                    reloadCxjgGrid();
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            reloadCxjgGrid();
                        }
                    }
                ],
                dataUrl: 'getCxjgZbjgInfo.action',
                params: {},
                pageConfig: {
                    pageNum: false,//设置显示每页条数
                    enablePage: false
                },
                listeners: {}
            });
            return grid;
        }

        /**
         * 校验当前选择承销机构信息是否已编制
         */
        function haveCxjg(i) {
            var have = false;
            var selgrid = DSYGrid.getGrid('item_cxjgSelect_Grid'); // 获取当前选择grid
            var havegrid = DSYGrid.getGrid('contentGrid'); // 编制数据
            if (selgrid == null || selgrid == undefined || havegrid == null || havegrid == undefined) {
                return true;
            }
            var sel = selgrid.getSelection();
            for (var j = 0; j < havegrid.getStore().getCount(); j++) {
                // 同一个承销机构编码不能编制多次
                if (sel[i].data["CXJG_CODE"] == havegrid.getStore().getAt(j).data["CXJG_CODE"]) {
                    return true;
                }
            }
            return have;
        }

        /**
         * 刷新承销机构选择grid
         */
        function reloadCxjgGrid() {
            var grid = DSYGrid.getGrid('item_cxjgSelect_Grid');
            var mhcx = grid.down('textfield[itemId="btn_search"]').getValue();
            var store = grid.getStore();
            store.removeAll();
            store.getProxy().extraParams = {MHCX: mhcx};
            store.loadPage(1);
        }
    }

    /**
     * 刷新主界面
     */
    function reloadGrid() {
        var grid = DSYGrid.getGrid('contentGrid');
        var mhcx = grid.down('textfield[itemId="btn_search"]').getValue();
        var store = grid.getStore();
        store.removeAll();
        store.getProxy().extraParams = {MHCX: mhcx};
        store.loadPage(1);
    }


</script>
</html>
