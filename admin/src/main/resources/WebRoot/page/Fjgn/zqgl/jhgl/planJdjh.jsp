<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>计划管理</title>
    <!-- 重要：引入统一extjs -->
    <script src="/js/bootstrap.js"></script>
    <script src="../data/ele_data.js"></script>
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
   // String userCode = (String) request.getSession().getAttribute("USERCODE");
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
   /* function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg); //匹配目标参数
        if (r != null)
            return unescape(r[2]);
        return null; //返回参数值
    }
    var wf_id = getUrlParam("wf_id");//工作流ID
    var node_code = getUrlParam("node_code");//当前结点
    var WF_STATUS = getUrlParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';;
    }
    /**
     * 设置全局变量
     */
    var button_name = '';//按钮名称
    var next_text = '';//送审、审核按钮显示文字
    var audit_info = '';//送審意見
    var ZQ_ID = '';
    var ZD_ID = '';
    var DQTS = '';
    var SELECT_YQ = '';
    var SELECT_ID = '';
    var TOTAL_AMT = 0;
    var BJ_AMT = 0;
    var LX_AMT = 0;
    var DFF_AMT = 0;
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
            next_text = '审核';
        } else if (node_code == '3') {//
            next_text = '确认';
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
                        fuc_selectDfjh();
                    }
                },
                {
                    xtype: 'button',
                    text: '修改',
                    name: 'btn_update',
                    icon: '/image/sysbutton/edit.png',
                    handler: function () {
                        fuc_updateZdxx();
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'btn_delete',
                    icon: '/image/sysbutton/delete.png',
                    handler: function () {
                        //获取表格被选中行
                        var records = DSYGrid.getGrid(
                                'mGrid')
                                .getSelectionModel()
                                .getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示',
                                    '请选择至少一条后再进行操作');
                            return;
                        } else {
                            //fuc_deleteFxgl();
                        }
                    }
                }, {
                    xtype: 'button',
                    text: '导入',
                    name: 'btn_upload',
                    icon: '/image/sysbutton/import.png',
                    handler: function () {
                        uploadExcel();
                    }
                }, {
                    xtype: 'button',
                    text: next_text,
                    name: 'btn_next',
                    icon: '/image/sysbutton/submit.png',
                    handler: function () {
                        //弹出对话框填写意见
                        opinionWindow.open('NEXT',
                                next_text + "意见");
                    }
                },
                {
                    xtype: 'button',
                    text: '退回',
                    name: 'btn_back',
                    icon: '/image/sysbutton/back.png',
                    handler: function () {
                        //弹出对话框填写意见
                        opinionWindow.open('BACK',
                                "退回意见");
                    }
                },
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'btn_check',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        fuc_getMainGridData();
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'btn_log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        //fuc_checkLog()
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()]
        });


        /**
         * 导入
         */
        function uploadExcel() {
            var form = new Ext.form.FormPanel({
                labelWidth: 70,
                fileUpload: true,
                defaultType: 'textfield',
                items: [{
                    xtype: 'textfield',
                    name: 'excelField',
                    fieldLabel: '选择上传文件',
                    padding: '20 10 20 10',
                    inputType: 'file',
                    blankText: '请选择需要上传的Excel文件！',
                    anchor: '100%'
                }]
            });

            var win = new Ext.Window(
                    {
                        title: '导入表样',
                        width: 400,
                        height: 150,
                        layout: 'fit',
                        plain: true,
                        buttonAlign: 'center',
                        items: form,
                        buttons: [
                            {
                                text: '上传',
                                handler: function () {
                                }
                            }, {
                                text: '关闭',
                                handler: function () {
                                    win.close();
                                }
                            }]
                    });
            win.show();
        }

        /* var choiceBar = {
         xtype : 'container',
         layout : 'hbox',
         width : "100%",
         margin : '15 2 8 13',
         defaults : {
         border : false,
         anchor : '100%',
         padding : '0 15 0 0'
         },
         items : [ {
         xtype : "combobox",
         name : "SET_YEAR",
         displayField : "name",
         valueField : "id",
         value : '1季度',
         fieldLabel : '季度',
         editable : false, //禁用编辑
         width : 140,
         labelWidth : 30,
         labelAlign : 'right',
         listeners : {
         'select' : function() {
         initButton();
         }
         }
         }, {
         xtype : "combobox",
         name : "PZ",
         displayField : "name",
         valueField : "id",
         fieldLabel : '品种',
         editable : false, //禁用编辑
         width : 140,
         labelWidth : 30,
         labelAlign : 'right'
         }]
         } */
        /**
         * 还本付息主单信息列表表头
         */
        var mainGridheaderJson = [{
            "dataIndex": "JD",
            "type": "string",
            "text": "季度",
            "fontSize": "15px"
        }, {
            "dataIndex": "GZPZ",
            "type": "string",
            "text": "债券品种",
            "fontSize": "15px",
            "width": 130
        }, {
            "dataIndex": "QX",
            "type": "string",
            "text": "期限",
            "fontSize": "15px"
        }, {
            "dataIndex": "JH_MO",
            "type": "string",
            "text": "计划月份",
            "fontSize": "15px",
            "width": 130
        }, {
            "dataIndex": "ZB_DATE",
            "type": "string",
            "text": "招标日期",
            "fontSize": "15px",
            "width": 130
        }, {
            "dataIndex": "JHFX_AMT",
            "type": "float",
            "text": "计划发行额",
            "fontSize": "15px",
            "width": 130
        }, {
            "dataIndex": "FX_TYPE",
            "type": "string",
            "text": "付息方式",
            "fontSize": "15px",
            "width": 130
        }];
        var screenBar = [{
            xtype: "combobox",
            name: "WF_STATUS",
            store: DebtEleStore(json_debt_zt1),
            value: WF_STATUS,
            displayField: "name",
            margin: '0 25 0 5',
            valueField: "id",
            fieldLabel: '状态',
            editable: false, //禁用编辑
            width: 140,
            labelWidth: 30,
            allowBlank: false,
            labelAlign: 'right',
            listeners: {
                'select': function () {
                    initButton();
                }
            }
        }, {
            xtype: "combobox",
            name: "SET_YEAR",
            margin: '0 25 0 5',
            store: DebtEleStore(json_debt_jd),
            displayField: "name",
            valueField: "id",
            value: '002',
            fieldLabel: '季度',
            editable: false, //禁用编辑
            width: 170,
            labelWidth: 30,
            labelAlign: 'right'
        }, {
            xtype: "treecombobox",
            name: "ZQPZ_ID",
            store: DebtEleTreeStoreJSON(json_debt_zqpz),
            displayField: "name",
            valueField: "id",
            fieldLabel: '债权品种',
            width: 250,
            labelWidth: 70,
            labelAlign: 'right',
            editable: false, //禁用编辑
            selectModel: 'leaf'
        }];

        var contentGridData = '';
        if (node_code == '1') {
            contentGridData = [
                ['2', '付息（固定利率）', '7年', '4', '2016-04-12', '36440', '一年一次'],
                ['2', '储蓄债券电子式', '1年', '4', '2016-04-18', '300', '一年一次'],
                ['2', '储蓄债券电子式', '5年', '5', '2016-05-10', '45000', '半年一次'],
                ['2', '储蓄债券电子式', '5年', '5', '2016-05-10', '3600', '一年一次'],
                ['2', '付息（固定利率）', '273天', '6', '2016-06-08', '28200', '半年一次'],
                ['2', '付息（固定利率）', '5年', '6', '2016-06-10', '602000', '一年一次']
            ];
        } else if (node_code == '2') {
            contentGridData = [
                ['2', '付息（固定利率）', '7年', '4', '2016-04-12', '36440', '一年一次'],
                ['2', '储蓄债券电子式', '1年', '5', '2016-05-18', '300', '一年一次']
            ];
        }
        /**
         * 还本付息主单信息列表表格
         */
        var mGrid = DSYGrid.createGrid({
            headerConfig: {
                headerJson: mainGridheaderJson,
                columnAutoWidth: false
            },
            itemId: 'mGrid',
            height: '100%',
            width: '100%',
            flex: 5,
            checkBox: true,
            rowNumber: true,
            border: false,
            tbar: screenBar,
            data: contentGridData,
            listeners: {
                cellclick: function (grid, rowIndex, columnIndex, event) {
                    var records = grid.getSelectionModel().getSelection();
                    if (records != null) {
                        var DFSQ_ID = records[0].get("DFSQ_ID");
                        fuc_getDtlGridData(DFSQ_ID);
                    }
                }
            }
        });

        /**
         * 还本付息录入界面主面板初始化
         */
        var panel = Ext.create('Ext.panel.Panel', {
            renderTo: 'mainDiv',
            layout: 'vbox',
            width: '100%',
            height: '100%',
            border: false,
            //items : ['转贷主单信息',mGrid,'转贷明细信息',dGrid],
            items: [mGrid],
            tbar: tbar
        });
        //initButton();
    }
    /**
     * 初始化按钮
     */
    function initButton() {
        var combo_WF_STATUS = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0];
        var btn_insert = Ext.ComponentQuery.query('button[name="btn_insert"]')[0];
        var btn_update = Ext.ComponentQuery.query('button[name="btn_update"]')[0];
        var btn_delete = Ext.ComponentQuery.query('button[name="btn_delete"]')[0];
        var btn_next = Ext.ComponentQuery.query('button[name="btn_next"]')[0];
        var btn_back = Ext.ComponentQuery.query('button[name="btn_back"]')[0];
        var btn_upload = Ext.ComponentQuery.query('button[name="btn_upload"]')[0];
        //根据当前结点状态，控制状态下拉框绑定的json以及按钮的显示与隐藏
        if (node_code == '1') {
            combo_WF_STATUS.bindStore(DebtEleStore(json_debt_zt1));
            btn_back.hide();
            if (combo_WF_STATUS.value == '001') {
                btn_insert.show();
                btn_update.show();
                btn_delete.show();
                btn_next.show();
            } else if (combo_WF_STATUS.value == '002') {
                btn_insert.hide();
                btn_update.hide();
                btn_delete.hide();
                btn_next.hide();
            }
        } else if (node_code == '2') {
            combo_WF_STATUS.bindStore(DebtEleStore(json_debt_sh));
            btn_insert.hide();
            btn_update.hide();
            btn_delete.hide();
            btn_upload.hide();
            if (combo_WF_STATUS.value == '001') {
                btn_next.show();
            } else if (combo_WF_STATUS.value == '002') {
                btn_next.hide();
                btn_back.hide();
            }
        } else if (node_code == '3') {
            combo_WF_STATUS.bindStore(DebtEleStore(json_debt_zt3));
            btn_insert.hide();
            btn_update.hide();
            btn_delete.hide();
            if (combo_WF_STATUS.value == '001') {
                btn_next.show();
            } else if (combo_WF_STATUS.value == '002') {
                btn_next.hide();
                btn_back.hide();
            }
        }
        //fuc_getFxglGrid();
    }
    /**
     *选择兑付计划页面
     */

    function fuc_selectDfjh() {
        button_name = 'INPUT';//按钮名称为INPUT
        var selectWindow = new Ext.Window({
            title: "选择兑付计划",
            itemId: 'selectWin',
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            frame: true,
            constrain: true,
            buttonAlign: "left", // 按钮显示的位置
            modal: true,
            resizable: false,//大小不可改变
            plain: true,
            items: [initSelectEditor()],
            closeAction: 'destroy'
        });
        selectWindow.show();
    }
    /**
     * 定义弹出框底部工具栏
     */
    function initSelectEditor() {
        var bbar = Ext.create('Ext.toolbar.Toolbar', {
            id: 'bbar',
            border: false,
            items: ['->',
                {
                    xtype: 'button',
                    text: '确定',
                    scale: 'medium',
                    name: 'OK',
                    handler: function (btn) {
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                            return;
                        }
                        btn.up('window').close();
                        //将选择的记录增加到填报窗口表格中
                        for (var record_seq in records) {
                            var record_id = records[record_seq].get('DF_PLAN_ID');
                            var record_lx_amt = Number(records[record_seq].get('PLAN_AMT'));
                            var record_dff_amt = Number(records[record_seq].get('DFF_AMT'));

                            LX_AMT = LX_AMT + record_lx_amt;
                            DFF_AMT = DFF_AMT + record_dff_amt;
                            SELECT_ID = record_id + '\',\'' + SELECT_ID;
                        }
                        TOTAL_AMT = BJ_AMT + LX_AMT + DFF_AMT;
                        SELECT_ID = '(\'' + SELECT_ID.substring(0, SELECT_ID.length - 2) + ')';
                        fuc_addHbfx();
                        var store = DSYGrid.getGrid("hbfxGrid").getStore();
                        store.getProxy().extraParams = {
                            SELECT_ID: SELECT_ID
                        };
                        //刷新表格内容
                        store.loadPage(1);
                    }
                },
                {
                    xtype: 'button',
                    text: '取消',
                    scale: 'medium',
                    name: 'CLOSE',
                    handler: function () {
                        Ext.ComponentQuery.query('window#selectWin')[0].close();
                    }
                }
            ]
        });
        /**
         * 定义弹出框editorPanel窗口
         */
        var editorPanel = Ext.create('Ext.panel.Panel', {
            anchor: '100% -60',
            border: false,
            padding: '2 2 2 2',
            items: createSelectPanel(),
            bbar: bbar
        });
        return editorPanel;
    }


    /**
     *还本付息录入页面
     */
    function fuc_addHbfx() {
        button_name = 'INPUT';//按钮名称为INPUT
        var addWindow = new Ext.Window({
            title: "还本付息录入",
            itemId: 'addWin',
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            frame: true,
            constrain: true,
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
    function fuc_updateZdxx() {
        //
        var records = DSYGrid.getGrid('mGrid').getSelectionModel()
                .getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
        } else {
            button_name = 'EDIT';
            ZD_ID = records[0].get("ZD_ID");
            var iTitle = "还本付息";
            //var iWidth = 1120;//窗口宽度
            var iWidth = 800;//窗口宽度
            var iHeight = 530;//窗口高度
            var updateWindow = new Ext.Window({
                title: iTitle,
                itemId: 'updateWin',
                width: iWidth,
                height: iHeight,
                frame: true,
                constrain: true,
                buttonAlign: "left", // 按钮显示的位置
                modal: true,
                resizable: false,//大小不可改变
                plain: true,
                items: [initEditor()],
                closeAction: 'destroy'
            });
            updateWindow.show();

        }
    }
    /**
     * 初始化录入窗口内容
     */
    function initEditor() {
        /**
         * 定义弹出框底部工具栏
         */
        var bbar = Ext
                .create(
                        'Ext.toolbar.Toolbar',
                        {
                            id: 'bbar',
                            border: false,
                            items: [
                                '->',
                                {
                                    xtype: 'button',
                                    text: '保存',
                                    scale: 'medium',
                                    name: 'CLOSE',
                                    handler: function () {
                                        Ext.MessageBox.wait("保存中...", "等待");
                                        Ext.defer(function () {
                                            Ext.MessageBox.close();
                                            Ext.ComponentQuery.query('window#addWin')[0].close();
                                            Ext.MessageBox.alert("成功", "保存成功");
                                        }, 500);
                                    }
                                },
                                {
                                    xtype: 'button',
                                    text: '取消',
                                    scale: 'medium',
                                    name: 'CLOSE',
                                    handler: function () {
                                        if (button_name == 'INPUT') {
                                            Ext.ComponentQuery
                                                    .query('window#addWin')[0]
                                                    .close();
                                        } else {
                                            Ext.ComponentQuery
                                                    .query('window#updateWin')[0]
                                                    .close();
                                        }
                                        SELECT_ID = '';
                                    }
                                }]
                        });
        /**
         * 定义弹出框editorPanel窗口
         */
        var editorPanel = Ext.create('Ext.panel.Panel', {
            anchor: '100%',
            border: false,
            padding: '2 2 2 2',
            items: createInputPanel(),
            bbar: bbar
        });
        return editorPanel;
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
     * 还本付息送审
     */
    function fuc_next() {
        var records = DSYGrid.getGrid('grid').getSelectionModel()
                .getSelection();
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
                msg_success = '审核成功！';
                msg_failure = '审核失败！';
            }
        }
    }

    /**
     * 债务合同信息退回
     */
    function fuc_back() {
        var records = DSYGrid.getGrid('grid').getSelectionModel()
                .getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        } else {
            button_name = 'BACK';
        }
    }
    /**
     * 查询
     */
    function fuc_getMainGridData() {
        var store = DSYGrid.getGrid('mGrid').getStore();
        WF_STATUS = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0].value;
        DFSQ_NO = Ext.ComponentQuery.query('textfield[name="DFSQ_NO"]')[0].value;
        APPLY_DATE = Ext.ComponentQuery.query('datefield[name="APPLY_DATE"]')[0].value;

        var sqrq = Ext.Date.format(new Date(APPLY_DATE), 'Y-m-d');

        //alert(sqrq);
        //初始化表格Store参数
        store.getProxy().extraParams = {
            wf_id: wf_id,
            node_code: node_code,
            userCode: userCode,
            WF_STATUS: WF_STATUS,
            DFSQ_NO: DFSQ_NO,
            APPLY_DATE: sqrq
        };
        //刷新表格内容
        DSYGrid.getGrid("mGrid").getStore().loadPage(1);
    }

    function fuc_getDtlGridData(DFSQ_ID) {
        var store = DSYGrid.getGrid('dGrid').getStore();
        //初始化表格Store参数
        store.getProxy().extraParams = {
            DFSQ_ID: DFSQ_ID
        };
        //刷新表格内容
        store.loadPage(1);
    }
</script>

<div id="mainDiv" style="width: 100%;height:100%;"></div>
</body>
</html>