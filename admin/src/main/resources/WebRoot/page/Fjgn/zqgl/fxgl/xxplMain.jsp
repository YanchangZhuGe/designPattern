<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>债券注册</title>
    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script src="../data/ele_data.js"></script>
    <script src="xxplEditor.js"></script>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
<%
    /*获取登录用户*/
  /*  String userCode = (String) request.getSession().getAttribute("USERCODE");*/
%>
<script type="text/javascript">
    /**
     * 获取登录用户
     */
    <%--var userCode = '<%=userCode%>';--%>
    var userCode = '${sessionScope.USERCODE}';
    /**
     * 通用函数：获取url中的参数：wf_id,node_code
     */
/*    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg); //匹配目标参数
        if (r != null)
            return unescape(r[2]);
        return null; //返回参数值
    }*/
  /*  var wf_id = getUrlParam("wf_id");//工作流ID
    var node_code = getUrlParam("node_code");//当前结点*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    /**
     * 设置全局变量
     */
    var button_name = '';//按钮名称
    var next_text = '';//送审、审核按钮显示文字
    var audit_info = '';//送審意見
    var ZQ_ID = '';
 /*   var WF_STATUS = getUrlParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var SET_YEAR = '';
    var ZQPZ_ID = '';
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
                    text: '查询',
                    name: 'btn_check',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        fuc_getFxglGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '录入',
                    name: 'btn_insert',
                    icon: '/image/sysbutton/add.png',
                    handler: function () {
                        fuc_addFxgl();
                    }
                },
                {
                    xtype: 'button',
                    text: '明细信息',
                    name: 'btn_update',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        fuc_updateFxgl();
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'btn_delete',
                    icon: '/image/sysbutton/field_drop24_h.png',
                    handler: function () {
                        //获取表格被选中行
                        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                            return;
                        } else {
                            fuc_deleteFxgl();
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: next_text,
                    name: 'btn_next',
                    icon: '/image/sysbutton/arrowright_green_24.png',
                    handler: function () {
                        //弹出对话框填写意见
                        opinionWindow.open('NEXT', next_text + "意见");
                    }
                },
                {
                    xtype: 'button',
                    text: '退回',
                    name: 'btn_back',
                    icon: '/image/sysbutton/arrowleft_green_24_h.png',
                    handler: function () {
                        //弹出对话框填写意见
                        opinionWindow.open('BACK', "退回意见");
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'btn_log',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        fuc_checkLog();
                    }
                },
                {
                    xtype: 'button',
                    text: '生成word文档',
                    name: 'export',
                    icon: '/image/sysbutton/export.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        uploadWordFile();
                    }
                },
                {
                    xtype: 'button',
                    text: '下载word文档',
                    name: 'btn_download',
                    icon: '/image/sysbutton/release.png',
                    handler: function () {
                        downloadFile();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()]
        });

        /**
         * 提交上传信息
         * @param form
         */
        function uploadWordFile() {
            var rule_id = null;
            var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
            var recordArray = [];
            if (records == false || records.length != 1) {
                Ext.Msg.alert('提示', '请仅选择一行进行操作！');
                return false;
            } else if (records.length == 1) {
                recordArray.push(records[0].getData());
            }
            //Ext.util.JSON.encode(recordArray);
            //向后台传递变更数据信息
            Ext.Ajax.request({
                method: 'POST',
                url: "uploadWordFile.action",
                params: {
                    detailList: Ext.util.JSON.encode(recordArray)
                },
                async: false,
                success: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '生成word文档成功',
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function () {
                            fuc_getFxglGrid();
                        }
                    });
                },
                failure: function (resp, opt) {

                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '生成word文档失败',
                        width: 200,
                        fn: function () {
                            fuc_getFxglGrid();
                        }
                    });
                }
            });
        }

        /**
         * 下载附件
         */
        function downloadFile() {
            var file_id = null;
            var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
            if (records == false || records.length != 1) {
                Ext.Msg.alert('提示', '请仅选择一行进行操作！');
                return false;
            } else {
                file_id = records[0].get("ZQ_ID");
            }

            if (file_id != '' && typeof(file_id) != "undefined" && file_id != 0) {
                window.location.href = 'downloadWordFile.action?file_id=' + file_id;
            } else {
                Ext.Msg.alert('提示', '该文档还未生成！');
            }
        }

        /**
         * 创建填写意见对话框
         */
        var opinionWindow = {
            window: null,
            open: function (action, title) {
                Ext.MessageBox.buttonText.ok = '确认';
                Ext.MessageBox.buttonText.cancel = '取消';
                this.window = Ext.MessageBox.show({
                    title: title,
                    width: 350,
                    buttons: Ext.MessageBox.OKCANCEL,
                    multiline: true,
                    fn: function (btn, text) {
                        audit_info = text;
                        if (btn == "ok") {
                            if (action == 'NEXT') {
                                fuc_next();
                            } else if (action == 'BACK') {
                                fuc_back();
                            }
                        }
                    },
                    //animateTarget: btn_target
                });
            },
            close: function () {
                if (this.window) {
                    this.window.close();
                }
            }
        };

        /**
         * 债券注册信息列表工具栏
         */
        var screenBar = [{
            xtype: "combobox",
            name: "WF_STATUS",
            store: DebtEleStore(json_debt_zt1),
            displayField: "name",
            valueField: "id",
            hidden: true,
            value: '',
            fieldLabel: '状态',
            editable: false, //禁用编辑
            width: 150,
            allowBlank: false,
            labelWidth: 30,
            labelAlign: 'right',
            listeners: {
                'select': function () {
                    initButton();
                }
            }
        }, {
            xtype: "combobox",
            name: "SET_YEAR",
            store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"}),
            displayField: "name",
            valueField: "id",
            value: Ext.Date.format(new Date(), 'Y'),
            fieldLabel: '年度',
            editable: false, //禁用编辑
            labelWidth: 40,
            width: 150,
            labelAlign: 'right',
            listeners: {
                change: function (self, newValue) {
                    //刷新当前表格
                    fuc_getFxglGrid();
                }
            }
        }, {
            xtype: "treecombobox",
            name: "ZQPZ_ID",
            store: DebtEleTreeStoreJSON(json_debt_zqpz),
            displayField: "name",
            valueField: "id",
            fieldLabel: '债权品种',
            hidden: true,
            width: 300,
            labelWidth: 70,
            labelAlign: 'right',
            editable: false, //禁用编辑
            selectModel: 'leaf'
        }];

        /**
         * 债券注册信息列表表头
         */
        var headerJson = [
            {xtype: 'rownumberer',width: 35},
            {
                "dataIndex": "ZQ_ID",
                "type": "string",
                "text": "债券ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            }, {
                "dataIndex": "ZQ_CODE",
                "type": "string",
                "text": "债券编码",
                "fontSize": "15px",
                "width": 150
            }, {
                "dataIndex": "ZQLB_ID",
                "type": "string",
                "text": "债券类型",
                "fontSize": "15px",
                "width": 150
            }, {
                "dataIndex": "ZQ_NAME",
                "type": "string",
                "width": 250,
                "text": "债券名称",
                "hrefType": "combo"
            }, {
                "dataIndex": "ZQ_JC",
                "width": 250,
                "type": "string",
                "text": "债券简称"
            }, {
                "dataIndex": "ZQPZ_ID",
                "width": 150,
                "type": "string",
                "text": "债券品种"
            }, {
                "dataIndex": "PLAN_FX_AMT",
                "width": 150,
                "type": "number",
                "align": 'right',
                "text": "计划发行量（亿）"
            }, {
                "dataIndex": "FX_AMT",
                "width": 150,
                "type": "number",
                "align": 'right',
                "text": "实际发行额（亿）"
            }, {
                "dataIndex": "ZQQX_ID",
                "width": 150,
                "type": "string",
                "text": "期限"
            }, {
                "dataIndex": "QX_DATE",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "起息日"
            }, {
                "dataIndex": "DQDF_DATE",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "到期兑付日"
            }, {
                "dataIndex": "FX_START_DATE",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "发行时间"
            }];

        /**
         * 债券注册信息列表表格
         */
        var config = {
            itemId: 'grid',
            border: false,
            flex: 4,
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            dataUrl: 'getFxglGrid.action',
            //autoLoad: true,
            params: {
                wf_id: wf_id,
                node_code: node_code,
                userCode: userCode,
                WF_STATUS: WF_STATUS,
                SET_YEAR: '2016',
                ZQPZ_ID: '001'
            },
            height: '100%',
            checkBox: true,
            pageConfig: {
                pageNum: true// 每页显示数据数
            },
            tbar: screenBar,
            tbarHeight: 50,
            listeners: {
                itemdblclick: function (self, record) {
                    //if(node_code == '1') {
                    fuc_showZqxx(true);
                    //}
                }
            }
        };
        var grid = DSYGrid.createGrid(config);

        /**
         * 债券注册录入界面主面板初始化
         */
        var panel = Ext.create('Ext.panel.Panel', {
            renderTo: 'mainDiv',
            layout: 'hbox',
            width: '100%',
            height: '100%',
            border: false,
            items: grid,
            tbar: tbar
        });
        //initButton();
    }

    /**
     * 初始化弹出窗口内容
     */
    function initEditor() {
        /**
         * 定义弹出框底部工具栏
         */
        var bbar = Ext.create('Ext.toolbar.Toolbar', {
            id: 'bbar',
            border: false,
            items: ['->',
                {
                    xtype: 'button',
                    text: '上一步',
                    scale: 'medium',
                    name: 'LAST',
                    disabled: true,
                    handler: function (btn) {
                        editorTab.setActiveTab(0);
                        Ext.ComponentQuery.query('button[name="LAST"]')[0].disable();
                        Ext.ComponentQuery.query('button[name="SAVE"]')[0].disable();
                        Ext.ComponentQuery.query('button[name="NEXT"]')[0].enable();
                    }
                },
                {
                    xtype: 'button',
                    text: '下一步',
                    scale: 'medium',
                    name: 'NEXT',
                    handler: function (btn) {
                        editorTab.setActiveTab(1);
                        Ext.ComponentQuery.query('button[name="NEXT"]')[0].disable();
                        Ext.ComponentQuery.query('button[name="SAVE"]')[0].enable();
                        Ext.ComponentQuery.query('button[name="LAST"]')[0].enable();
                        Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].setValue(cxt_id);
                    }
                },
                {
                    xtype: 'button',
                    text: '确定',
                    scale: 'medium',
                    name: 'SAVE',
                    disabled: true,
                    handler: function (btn) {
                        var form = Ext.ComponentQuery.query('form#jbxxForm')[0];
                        submitFxgl(form);
                    }
                },
                {
                    xtype: 'button',
                    text: '取消',
                    scale: 'medium',
                    name: 'CLOSE',
                    handler: function () {
                        if (button_name == 'INPUT') {
                            Ext.ComponentQuery.query('window#addWin')[0].close();
                        } else {
                            Ext.ComponentQuery.query('window#updateWin')[0].close();
                        }
                    }
                }
            ]
        });
        /**
         * 定义弹出框TabPanel窗口
         */
        var editorTab = Ext.create('Ext.tab.Panel', {
            layout: 'fit',
            //anchor: '100%',
            border: false,
            padding: '2 2 2 2',
            items: [
                {
                    title: '基本信息',
                    items: jbxxTab(),
                    listeners: {
                        activate: function (tab) {
                            editorTab.setActiveTab(0);
                            Ext.ComponentQuery.query('button[name="LAST"]')[0].disable();
                            Ext.ComponentQuery.query('button[name="SAVE"]')[0].disable();
                            Ext.ComponentQuery.query('button[name="NEXT"]')[0].enable();
                        }
                    }
                },
                {
                    title: '承销团信息',
                    items: cxtxxTab(),
                    listeners: {
                        activate: function (tab) {
                            editorTab.setActiveTab(1);
                            Ext.ComponentQuery.query('button[name="NEXT"]')[0].disable();
                            Ext.ComponentQuery.query('button[name="SAVE"]')[0].enable();
                            Ext.ComponentQuery.query('button[name="LAST"]')[0].enable();
                            //Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].setValue(cxt_id);
                        }
                    }
                }
            ]
            //bbar : bbar
        });
        return editorTab;
    }

    /**
     * 初始化按钮
     */
    function initButton() {
        var WF_STATUS = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0];
        var btn_insert = Ext.ComponentQuery.query('button[name="btn_insert"]')[0];
        var btn_update = Ext.ComponentQuery.query('button[name="btn_update"]')[0];
        var btn_delete = Ext.ComponentQuery.query('button[name="btn_delete"]')[0];
        var btn_next = Ext.ComponentQuery.query('button[name="btn_next"]')[0];
        var btn_back = Ext.ComponentQuery.query('button[name="btn_back"]')[0];
        var btn_log = Ext.ComponentQuery.query('button[name="btn_log"]')[0];
        //根据当前结点状态，控制状态下拉框绑定的json以及按钮的显示与隐藏
        btn_insert.hide();
        btn_update.show();
        btn_delete.hide();
        btn_next.hide();
        btn_back.hide();
        btn_log.hide();
        fuc_getFxglGrid();
    }

    /**
     * 发行管理信息列表
     */
    function fuc_getFxglGrid() {
        var store = DSYGrid.getGrid('grid').getStore();
        WF_STATUS = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0].value;
        SET_YEAR = Ext.ComponentQuery.query('combobox[name="SET_YEAR"]')[0].value;
        ZQPZ_ID = Ext.ComponentQuery.query('treecombobox[name="ZQPZ_ID"]')[0].value;
        //初始化表格Store参数
        store.getProxy().extraParams = {
            wf_id: wf_id,
            node_code: node_code,
            userCode: userCode,
            WF_STATUS: WF_STATUS,
            SET_YEAR: SET_YEAR,
            ZQPZ_ID: ZQPZ_ID
        };
        //刷新表格内容
        DSYGrid.getGrid("grid").getStore().loadPage(1);
    }

    /**
     * 债券注册录入页面
     */
    function fuc_addFxgl() {
        cxt_id = '';
        button_name = 'INPUT';//按钮名称为INPUT
        var iTitle = "债券注册";
        //var iWidth = 1120;//窗口宽度
        var iWidth = window.screen.availWidth * 2 / 3;
        var iHeight = 560;//窗口高度
        //var iHeight = window.screen.availHeight*3/4;
        var addWindow = new Ext.Window({
            title: iTitle,
            itemId: 'addWin',
            width: iWidth,
            height: iHeight,
            frame: true,
            constrain: true,
            //autoScroll: true,
            buttonAlign: "left", // 按钮显示的位置
            modal: true,
            resizable: false,//大小不可改变
            plain: true,
            items: [initEditor()],
            closeAction: 'destroy'
        });
        addWindow.show();
    }

    /**
     * 修改
     */
    function fuc_updateFxgl() {
        //
        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
        } else {
            button_name = 'EDIT';
            ZQ_ID = records[0].get("ZQ_ID");
            var iTitle = "信息披露";
            //var iWidth = 1120;//窗口宽度
            var iWidth = window.screen.availWidth * 2 / 3;
            var iHeight = 520;//窗口高度
            var updateWindow = new Ext.Window({
                title: iTitle,
                itemId: 'updateWin',
                width: iWidth,
                height: iHeight,
                frame: true,
                constrain: true,
                maximizable: true,//最大化按钮
                layout: 'fit',
                buttonAlign: "right", // 按钮显示的位置
                modal: true,
                resizable: true,//大小不可改变
                plain: true,
                items: [initEditor()],
                closeAction: 'destroy'
            });
            updateWindow.show();

        }
    }

    /**
     * 删除
     */
    function fuc_deleteFxgl() {
        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        } else {
            var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
            var fxglArray = [];
            Ext.each(records, function (record) {
                var array = {};
                array.ZQ_ID = record.get("ZQ_ID");
                fxglArray.push(array);
            });
            //向后台传递变更数据信息
            Ext.Ajax.request({
                method: 'POST',
                url: "deleteFxgl.action",
                params: {
                    fxglArray: Ext.util.JSON.encode(fxglArray)
                },
                async: false,
                success: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '删除成功',
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function () {
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                        }
                    });
                },
                failure: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '删除失败',
                        width: 200,
                        fn: function () {
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                        }
                    });
                }
            });
        }
    }

    /**
     * 债务合同信息送审
     */
    function fuc_next() {
        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        } else {
            //判断操作按钮
            if (node_code == '1') {
                button_name = 'SEND';
                msg_success = '送审成功！';
                msg_failure = '送审失败！';
            } else if (node_code == '2') {
                button_name = 'AUDIT';
                msg_success = '登记成功！';
                msg_failure = '登记失败！';
            } else if (node_code == '3') {
                button_name = 'REAUDIT';
                msg_success = '确认成功！';
                msg_failure = '确认失败！';
            }

            var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
            var fxglArray = [];
            Ext.each(records, function (record) {
                var array = {};
                array.ID = record.get("ZQ_ID");
                fxglArray.push(array);
            });
            //向后台传递变更数据信息
            Ext.Ajax.request({
                method: 'POST',
                url: 'nextFxgl.action',
                params: {
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: audit_info,
                    userCode: userCode,
                    fxglArray: Ext.util.JSON.encode(fxglArray)
                },
                async: false,
                success: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: msg_success,
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function (btn) {
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                        }
                    });
                },
                failure: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: msg_failure,
                        width: 200,
                        fn: function (btn) {
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                        }
                    });
                }
            });
        }
    }

    /**
     * 债务合同信息退回
     */
    function fuc_back() {
        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        } else {
            button_name = 'BACK';
            var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
            var fxglArray = [];
            Ext.each(records, function (record) {
                var array = {};
                array.ID = record.get("ZQ_ID");
                fxglArray.push(array);
            });
            //向后台传递变更数据信息
            Ext.Ajax.request({
                method: 'POST',
                url: 'backFxgl.action',
                params: {
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: audit_info,
                    userCode: userCode,
                    fxglArray: Ext.util.JSON.encode(fxglArray)
                },
                async: false,
                success: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '退回成功',
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function (btn) {
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                        }
                    });
                },
                failure: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '退回失败',
                        width: 200,
                        fn: function (btn) {
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                        }
                    });
                }
            });
        }
    }


    /**
     * 查看操作日志
     */
    function fuc_checkLog() {
        var start_time = '';
        var end_time = '';

        var logBar = [
            {
                xtype: "datefield",
                name: "RQ_Q",
                fieldLabel: '日期起',
                width: 200,
                labelAlign: 'right',
                labelWidth: 50,
                allowBlank: false,
                format: 'Y-m-d',
                blankText: '请选择开始日期',
                value: today
            },
            {
                xtype: "datefield",
                name: "RQ_Z",
                fieldLabel: '日期止',
                width: 200,
                labelAlign: 'right',
                labelWidth: 50,
                allowBlank: false,
                format: 'Y-m-d',
                blankText: '请选择开始日期',
                value: today
            },
            {
                xtype: 'button',
                text: '查询',
                scale: 'medium',
                name: 'CHECK',
                handler: function (btn) {
                    fuc_refreshLog()
                }
            }
        ];

        var headerJson = [
            {xtype: 'rownumberer',width: 35},
            {
                "dataIndex": "CREATE_USER",
                "type": "string",
                "text": "操作人",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "CREATE_DATE",
                "type": "string",
                "text": "操作时间",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "OPERATION",
                "type": "string",
                "text": "操作动作",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "AUDIT_INFO",
                "type": "string",
                "width": 250,
                "text": "操作意见"
            }
        ];

        /**
         * 债券注册信息列表表格
         */
        var logGrid = DSYGrid.createGrid({
            headerConfig: {
                headerJson: headerJson
            },
            itemId: 'logGrid',
            height: '100%',
            checkBox: true,
            border: false,
            tbar: logBar,
            dataUrl: 'getLogGrid.action'
        });

        var iTitle = "操作日志";
        var iWidth = window.screen.availWidth * 2 / 3;
        var iHeight = 560;//窗口高度
        var logWindow = new Ext.Window({
            title: iTitle,
            itemId: 'addWin',
            width: iWidth,
            height: iHeight,
            frame: true,
            constrain: true,
            //autoScroll: true,
            buttonAlign: "left", // 按钮显示的位置
            modal: true,
            resizable: false,//大小不可改变
            plain: true,
            items: [logGrid],
            closeAction: 'destroy'
        });
        logWindow.show();
        fuc_refreshLog();
    }

    function fuc_refreshLog() {
        //刷新数据
        var store = DSYGrid.getGrid('logGrid').getStore();
        start_time = Ext.ComponentQuery.query('datefield[name="RQ_Q"]')[0].value;
        end_time = Ext.ComponentQuery.query('datefield[name="RQ_Z"]')[0].value;
        //初始化表格Store参数
        store.getProxy().extraParams = {
            wf_id: wf_id,
            node_code: node_code,
            userCode: userCode,
            start_time: start_time,
            end_time: end_time
        };
        //刷新表格内容
        DSYGrid.getGrid("logGrid").getStore().loadPage(1);
    }
</script>

<div id="mainDiv" style="width: 100%;height:100%;"></div>
</body>
</html>