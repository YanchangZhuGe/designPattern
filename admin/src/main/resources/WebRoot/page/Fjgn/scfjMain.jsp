<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.bgd.platform.util.service.SpringContextUtil" %>
<%
    SpringContextUtil.checkUserUrlCode(request, response);
%>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>上传附件管理主界面</title>

    <style type="text/css">
        html, body {
            width: 100%;
            height: 100%;
            margin: 0 auto;
        }
    </style>
    <script src="/js/bootstrap.js"></script>
    <!-- <script src="/js/plat/UploadPanel.js"></script> -->
    <script src="scfjEditor.js"></script>

    <script type="text/javascript">
        //全局变量
        var button_name = null;
        Ext.require(['Ext.data.*', 'Ext.layout.container.HBox', 'Ext.window.MessageBox']);
        /**
         * 页面初始化
         */
        Ext.onReady(function () {
            initContent();
        });
        /**
         * 初始化主panel
         */
        function initContent() {
            Ext.create('Ext.panel.Panel', {
                layout: 'border',
                width: '100%',
                height: '100%',
                renderTo: Ext.getBody(),
                border: false,
                dockedItems: [
                    {
                        xtype: 'toolbar',
                        dock: 'top',
                        itemId: 'contentTopToolbar',
                        items: initContentTopToolbar()//初始化顶部功能按钮
                    }
                ],
                items: [
                    {
                        region: 'center',
                        layout: 'fit',
                        border: false,
                        xtype: 'panel',
                        height: '100%',
                        width: '100%',
                        items: [initTableGrid()]
                    }
                ]
            });
        }
        /**
         * 初始化工具栏
         * @returns {*[]}
         */
        function initContentTopToolbar() {
            return [
                {
                    xtype: 'button',
                    text: '新增',
                    name: 'btn_create',
                    icon: '/image/sysbutton/add.png',
                    handler: function () {
                        doCreate();
                    }
                },
                {
                    xtype: 'button',
                    text: '修改',
                    name: 'btn_edit',
                    icon: '/image/sysbutton/edit.png',
                    disabled: true,
                    handler: function (btn) {
                        doEdit(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'btn_delete',
                    icon: '/image/sysbutton/delete.png',
                    disabled: true,
                    handler: function () {
                        doDelete();
                    }
                },
                {
                    xtype: 'button',
                    text: '刷新',
                    name: 'btn_refresh',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ];
        }
        /**
         * 初始化页面主表格
         */
        function initTableGrid() {
            //主表格列
            var wfTableJson = [
                { xtype: 'rownumberer', text:'',width:50},
                {
                    "dataIndex": "SCMX_ID",
                    "type": "string",
                    "width": 30,
                    "text": "ID",
                    hidden: true
                }, {
                    "dataIndex": "TITLE",
                    "type": "string",
                    "width": 90,
                    "text": "标题"
                }, {
                    "dataIndex": "CREATE_USER",
                    "type": "string",
                    "width": 30,
                    "text": "操作人"
                }, {
                    "dataIndex": "CREATE_DATE",
                    "type": "string",
                    "width": 20,
                    "text": "上传时间"
                }
            ];
            return DSYGrid.createGrid({
                itemId: 'contentGrid',
                headerConfig: {
                    headerJson: wfTableJson,
                    columnAutoWidth: true
                },
                width: '100%',
                height: '100%',
                dataUrl: 'getFjxxList.action?op=MANAGE',
                checkBox: false,
                border: false,
                selModel: {
                    mode: 'SINGLE',     //"SINGLE"/"SIMPLE"/"MULTI"
                    checkOnly: false     //只能通过checkbox选择
                },
                pageConfig: {
                    pageSize: 20,
                    enablePage: true
                    //是否显示每页条数
                },
                rowNumber: {
                    rowNumber: true// 显示行号
                },

                listeners: {
                    selectionchange: function (view, records) {
                        //切换修改、删除按钮禁用状态
                        Ext.ComponentQuery.query('button[name="btn_edit"]')[0].setDisabled(!records.length || records.length != 1);
                        Ext.ComponentQuery.query('button[name="btn_delete"]')[0].setDisabled(!records.length);
                    }
                }
            });
        }
        /**
         * 刷新主表格
         */
        function reloadGrid(param) {
            var store = DSYGrid.getGrid('contentGrid').getStore();
            if (typeof param != 'undefined' && param != null) {
                for (var name_param in param) {
                    store.getProxy().extraParams[name_param] = param[name_param];
                }
            }
            //刷新
            store.loadPage(1);
        }
        /**
         * 点击新增按钮操作
         */
        function doCreate() {
            $.post("/getId.action", function (data) {
                if (!data.success) {
                    Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                    return;
                }
                //弹出弹出框，设置主表id
                editWindow.FJ_ID = data.data[0];
                editWindow.show();
            }, "json");
        }
        /**
         * 点击修改按钮操作
         */
        function doEdit(btn) {
            // 检验是否选中数据
            // 获取选中数据
            var records = DSYGrid.getGrid('contentGrid').getSelection();
            if (records.length != 1) {
                Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                return;
            }
            button_name = btn.text;
            //发送ajax请求，查询主表和明细表数据
            $.post("/getFjxxDetail.action", {
                scmxId: records[0].get('SCMX_ID')
            }, function (data) {
                if (!data[0]) {
                    Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                    return;
                }
                var form_data = data[0];
                form_data['IS_PUB'] = form_data['IS_PUB'] == null ? 0 : form_data['IS_PUB'];//是否公开默认公开
                //弹出弹出框，并将数据插入到弹出框form中
                editWindow.FJ_ID = records[0].get('SCMX_ID');
                editWindow.show();
                editWindow.window.down('tabpanel').down('form').getForm().setValues(form_data);

            }, "json");
        }
        /**
         * 点击删除按钮操作
         */
        function doDelete() {
            var records = DSYGrid.getGrid('contentGrid').getSelection();
            if (records.length <= 0) {
                Ext.toast({
                    html: "请选择一条文章信息后再删除",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                return;
            }
            var select = [];
            Ext.each(records, function (record) {
                select.push(record.getData());
            });
            var params = {
                select: Ext.util.JSON.encode(select)
            };
            $.post("deleteFjxxDetail.action", params, function (data) {
                var resultJson = data;
                var remark = "";
                if (resultJson.success) {
                    remark = "删除成功！";
                } else {
                    remark = "删除失败！";
                }
                Ext.toast({
                    html: remark,
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                reloadGrid();
            }, "json");
        }
    </script>
</head>
<body>
</body>
</html>