<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>债券注册</title>
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script src="../data/ele_data.js"></script>
    <script src="fxglEditor.js"></script>
    <script src="fxglFxxx.js"></script>
    <script type="text/javascript" src="/js/plat/SetItemReadOnly.js"></script>
</head>
<body>
<script type="text/javascript">
    // 获取系统参数值
    var nowDate = '${fns:getDbDateDay()}'; // 获取当前系统时间
    var IS_CREATE_FKMDFJH = '${fns:getSysParam("IS_CREATE_FKMDFJH")}'; // 是否生成分科目兑付计划： 0 不生成、1 生成
    var IS_BZB = '${fns:getSysParam("IS_BZB")}';// 系统参数：是否标准版
    var sysAdcode = '${fns:getSysParam("ELE_AD_CODE")}';// 系统参数：省级区划

    // 获取session登录用户参数值
    var userCode = '${sessionScope.USERCODE}';
    var userAD = '${sessionScope.ADCODE}'.replace(/00$/, "");
    // AD_CODE = AD_CODE.replace(/00$/, "");

    // 获取URL 参数值
 /*   var wf_id = getQueryParam("wf_id");//工作流ID
    var node_code = getQueryParam("node_code");//当前结点
    var status = getQueryParam("status");//获取登记状态
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var status ="${fns:getParamValue('status')}";
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    // 自定义全局变量
    var IS_ZD='';
    var ZQXM_ID = '';
    var SET_YEAR = '';
    var isEdit = '';
    var HBFS_ID = ''; // 月度发行计划编制：还本方式
    var isViewCXJG = '';
    var sysParamZqfxfs = '';
    var button_name = ''; // 按钮名称
    var audit_info = ''; // 送审意见
    var next_text = ''; // 送审、审核按钮显示文字
    var update_text = '';// 修改、登记按钮显示文字
    var cancel_text = '';
    var title_text = '';
    var ZQ_BILL_ID = '';
    var editFirstLoad = ''; // 修改时首次加载数据
    var fxrqShowFlag = false;
    var hidden_flag = false;
    var is_cxdj = false;// 是否为重新登记，显示隐藏tab
    var dfjh_ids = [];
    var nowYear = nowDate.substr(0,4);
    var ydjhXzAmt = 0; // 较验使用（月度计划新增金额）
    var ydjhZrzAmt = 0;// 较验使用（月度计划再融资金额）

    // 获取系统参数
    $.post("getParamValueAll.action", function (data) {
        sysParamZqfxfs = data[0].DEBT_ZQFXFS;
        isViewCXJG = data[0].IS_CZB_VERSION;//0表示是财政部版本,1地方版本
        if (isViewCXJG == 0) {
            fxrqShowFlag = true;
        }
    },"json");

    // 初始化基础数据
    var zqpc_store = DebtEleStoreDB('DEBT_ZQPC');
    var dfjh_ids_store = DebtEleStore(dfjh_ids);
    var monthStore = DebtEleStore(json_debt_yf);
    var zwsrkm_store = DebtEleTreeStoreDB('DEBT_ZWSRKM',{condition: (IS_BZB == '2' ?  "AND CODE NOT LIKE '1050401%'":" AND 1=1 ")+" AND (CODE LIKE '105%') AND YEAR = "+ nowYear });
    var zfxsrkm_store = DebtEleTreeStoreDB('DEBT_ZFXSRKM',{condition:" and year = "+ nowYear });


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
                // initConn();
            });
        } else {
            initMain();
            initButton();
            // initConn();
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
            cancel_text = '撤销送审';
            update_text = '修改';
            title_text = '债券注册';
        } else if (node_code == '2') {//
            next_text = '审核';
            cancel_text = '撤销登记';
            update_text = '登记';
            title_text = '中标登记';
        } else if (node_code == '3') {
            next_text = '债务确认';
            cancel_text = '撤销确认';
            title_text = '债券信息';
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
                    handler: function (btn) {
                        button_name = btn.text;
                        isEdit = false;
                        if(IS_BZB == '1'||IS_BZB == '2'){//20200814 guodg 若是标准版或者专项债券系统都取月度发行计划数据
                            $.post('/checkDate.action', {
                                CURRENT_DATE: nowDate
                            }, function (data) {
                                if (data.success == "next") {
                                    insertMethod(data);
                                }else if(data.success == "hint"){
                                    insertMethod(data);
                                }else{
                                    Ext.MessageBox.alert('提示',data.message);
                                    return false;
                                }
                                //刷新表格
                            }, "json");
                        } else {
                            insertMethod(null);
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '续发行',
                    name: 'btn_xfx',
                    icon: '/image/sysbutton/add.png',
                    hidden: true,
                    handler: function (btn) {
                        button_name = btn.text;
                        isEdit = false;
                        //弹出债券选择窗口
                        selectXfxZqxxWindow.show();
                    }
                },
                {
                    xtype: 'button',
                    text: update_text,
                    name: 'btn_update',
                    icon: '/image/sysbutton/edit.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        if(btn.text=='重新登记'){
                            is_cxdj=true;
                        }else{
                            is_cxdj=false;
                        }
                        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
                        if (records.length == 0) {
                            Ext.MessageBox.alert('提示', '请选择一笔债券！');
                        } else if (records.length > 1) {
                            Ext.MessageBox.alert('提示', '不能同时对多笔债券进行' + update_text + '！');
                        } else {
                            isEdit = false;
                            editFirstLoad = true;
                            var IS_XFX = records[0].get("IS_XFX");
                            if (IS_XFX == '1') {
                                fuc_updateFxgl_xfx(isEdit);
                            }else {
                                fuc_updateFxgl(isEdit);
                            }
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'btn_delete',
                    icon: '/image/sysbutton/delete.png',
                    handler: function (btn) {
                        button_name = btn.text;
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
                    icon: '/image/sysbutton/audit.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
                        if (records.length == 0) {
                            Ext.MessageBox.alert('提示', '请至少选择一笔债券！');
                        } else {
                            if (next_text == '送审') {
                                Ext.Msg.confirm('提示', '请确认是否' + next_text + '!', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        audit_info = '';
                                        fuc_next();
                                    }
                                });
                            } else {
                                //弹出对话框填写意见
                                opinionWindow.open('NEXT', next_text + "意见");
                            }
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: cancel_text,
                    name: 'btn_cancel',
                    icon: '/image/sysbutton/audit.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
                        if (records.length == 0) {
                            Ext.MessageBox.alert('提示', '请至少选择一笔债券！');
                        } else {
                            if (btn.text == '撤销确认') {
                                for (record_seq in records) {
                                    if (records[record_seq].get('IS_BACK') == '1') {
                                        Ext.Msg.alert('提示', '选择撤销的债券已续发行，无法撤销！');
                                        return false;
                                    }
                                }
                            } else if (btn.text == '撤销送审') {
                                for (record_seq in records) {
                                    if (records[record_seq].get('IS_DJ') == '1') {
                                        Ext.Msg.alert('提示', '选择撤销的债券已被登记，无法撤销！');
                                        return false;
                                    }
                                }
                            }
                            Ext.MessageBox.show({
                                title: '提示',
                                msg: "是否撤销选择的记录？",
                                width: 200,
                                buttons: Ext.MessageBox.OKCANCEL,
                                fn: function (btn) {
                                    if (btn == "ok") {
                                        fuc_back();
                                    }
                                }
                            });

                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'btn_log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
                        if (records.length == 0) {
                            Ext.MessageBox.alert('提示', '请选择一条记录！');
                        } else if (records.length > 1) {
                            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
                        } else {
                            var ywsj_id = records[0].get("ZQ_BILL_ID");
                            fuc_getWorkFlowLog(ywsj_id);
                        }
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()]
        });

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
                    value: '同意',
                    fn: function (btn, text) {
                        audit_info = text;
                        if (btn == "ok") {
                            if (action == 'NEXT') {
                                fuc_next();
                            } else if (action == 'BACK' || action == 'CANCEL') {
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
        var screenBar = [
            {
                xtype: "combobox",
                name: "WF_STATUS",
                store: DebtEleStore(json_debt_zt1),
                displayField: "name",
                valueField: "id",
                value: WF_STATUS,
                fieldLabel: '状态',
                editable: false, //禁用编辑
                width: 150,
                labelWidth: 30,
                allowBlank: false,
                labelAlign: 'right',
                listeners: {
                    'select': function () {
                        initButton();
                    }
                }
            },
            {
                xtype: "combobox",
                name: "SET_YEAR",
                store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2009'"}),
                displayField: "name",
                valueField: "id",
                //value: Ext.Date.format(new Date(), 'Y'),
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
            }
        ];

        function insertMethod(obj){
            //发送ajax请求，获取新增主表id
            $.post("/getId.action", function (data) {
                if (!data.success) {
                    Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                    return;
                }
                //弹出弹出框，设置XM_ID
                ZQ_BILL_ID = data.data[0];
                editFirstLoad = false;
                if(IS_BZB == '1' || IS_BZB == '2'){
                    initWindow_ydjh();
                    if(obj.success == 'hint'){
                        Ext.toast({
                            html: obj.message,
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    }
                }else{
                    fuc_addFxgl();
                }
            }, "json");
        }

        /**
         * 债券注册信息列表表头
         */
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                "dataIndex": "ZQ_BILL_ID",
                "type": "string",
                "text": "债券ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "YDJH_ID",
                "type": "string",
                "text": "月度计划ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "ZQ_CODE",
                "type": "string",
                "text": "债券代码",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "ZQLB_ID",
                "type": "string",
                "text": "债券类型",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "ZQ_NAME",
                "type": "string",
                "width": 250,
                "text": "债券名称"/* ,
             renderer: function (data, cell, record) {
             var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+userAD;
             return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';
             } */
            },
            {text: "债券简称", dataIndex: "ZQ_JC", width: 250, type: "string"},
            {text: "发行批次ID", dataIndex: "ZQ_PC_ID", type: "string", hidden: true},
            {text: "发行批次", dataIndex: "ZQ_PC_NAME", type: "string"},
            // {
            //     "dataIndex": "ZQPZ_ID",
            //     "width": 150,
            //     "type": "string",
            //     "text": "债券品种"
            // },
            {
                "dataIndex": "PLAN_FX_AMT",
                "width": 150,
                "type": "number",
                "align": 'right',
                "text": "计划发行量（亿）",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "FX_AMT",
                "width": 150,
                "type": "number",
                "align": 'right',
                "text": "实际发行额（亿）",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "ZBJG_AMT",
                "width": 150,
                "type": "number",
                "align": 'right',
                "text": "中标价格（元）",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "ZQ_BILL_QX",
                "width": 150,
                "type": "string",
                "text": "期限"
            },
            {
                "dataIndex": "QX_DATE",
                "width": 150,
                "type": "string",
                "text": "起息日",
                "align": 'left'
            },
            {
                "dataIndex": "DQDF_DATE",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "到期兑付日"
            },
            {
                "dataIndex": "FX_START_DATE",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "发行时间"
            },
            /*{
                "dataIndex": "IS_ZD",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "已转贷",
                hidden: true

            },
            {
                "dataIndex": "IS_DJ",
                "width": 100,
                "type": "string",
                "align": 'left',
                "text": "是否已登记"
            },
            {
                "dataIndex": "IS_ZC",
                "width": 100,
                "type": "string",
                "align": 'left',
                "text": "是否已支出",
                hidden: true
            },*/
            {
                "dataIndex": "FIRST_ZQ_ID",
                "width": 100,
                "type": "string",
                "align": 'left',
                "text": "首次发行债券ID",
                hidden: true
            },
            {
                "dataIndex": "IS_XFX",
                "width": 100,
                "type": "string",
                "align": 'left',
                "text": "是否续发行",
                hidden: true
            },
            {
                "dataIndex": "YEAR",
                "width": 100,
                "type": "string",
                "align": 'left',
                "text": "年度",
                hidden: true
            }
            /*{
                "dataIndex": "IS_BACK",
                "width": 100,
                "type": "string",
                "align": 'left',
                "text": "是否续发行",
                hidden: true
            }*/
        ];

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
            autoLoad: true,
            params: {
                wf_id: wf_id,
                node_code: node_code,
                userCode: userCode,
                WF_STATUS: WF_STATUS,
                status: status,
                SET_YEAR: Ext.Date.format(new Date(), 'Y')
            },
            height: '100%',
            checkBox: true,
            pageConfig: {
                pageNum: true// 每页显示数据数
            },
            tbar: screenBar,
            listeners: {
                itemdblclick: function (self, record) {
                    //if(node_code == '1') {
                    fuc_showZqxx(true, record);
                    //}
                }
            },
            features: [{
                ftype: 'summary'
            }]
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
    }

    /**
     * 初始化弹出窗口内容
     */
    var filebutton=[
        {
            xtype: 'filefield',
            buttonText: '导入',
            itemId:"uploady1",
            name: 'upload',
            width: 60,
            buttonOnly: true,
            hideLabel: true,
            buttonConfig: {
                width: 60,
                icon: '/image/sysbutton/report.png'
            },
            listeners: {
                change: function (fb, v) {
                    var form = this.up('form').getForm();
                    uploadTbxxFile(form);
                }
            }

        }
    ];
    function initEditor(isEdit, onlyShow,ydjh_id) {
        /**
         * 定义弹出框TabPanel窗口2
         */
        var editorTab = Ext.create('Ext.tab.Panel', {
            itemId: 'main_tab',
            border: false,
            padding: '2 2 2 2',
            items: [
                {
                    title: '基本信息',
                    itemId: 'jbxxtab',
                    layout: 'fit',
                    scrollable: true,
                    items: jbxxTab(node_code, isEdit, onlyShow)
                },
                {
                    title: '承销团信息',
                    itemId: 'cxtxxtab',
                    layout: 'fit',
                    scrollable: true,
                    items: cxtxxTab(node_code)
                },
                {
                    title: '发行信息',
                    layout: 'fit',
                    itemId: 'fxxxtab',
                    items: fxxxTab(onlyShow),
                    listeners: {
                        afterrender: function () {
                            if(!onlyShow){
                                var tab=Ext.ComponentQuery.query('#main_tab')[0];
                                tab.on({
                                    tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                                        if(IS_BZB == '1' || IS_BZB == '2'){
                                            if(newCard.itemId=='jbxxtab'||newCard.itemId=='cxtxxtab'||newCard.itemId=='fujian'||newCard.itemId=='dfjhTab'||newCard.itemId=='jsxmTab'){
                                                var filebuttons=Ext.ComponentQuery.query('#uploady1')[0];
                                                form.remove(filebuttons);
                                            }else{
                                                form.add(filebutton);
                                            }
                                        }else{
                                            if(newCard.itemId=='jbxxtab'||newCard.itemId=='cxtxxtab'||newCard.itemId=='fujian'||newCard.itemId=='dfjhTab'){
                                                var filebuttons=Ext.ComponentQuery.query('#uploady1')[0];
                                                form.remove(filebuttons);
                                            }else{
                                                form.add(filebutton);
                                            }
                                        }
                                    }
                                });
                                var form = Ext.ComponentQuery.query('form#formupload1')[0];
                                form.add(filebutton);
                            }else{

                            }
                        }
                    }
                },
                {
                    title: '兑付计划',
                    itemId: 'dfjhTab',
                    layout: 'fit',
                    scrollable: true,
                    items: dfjhTab(node_code,onlyShow)
                },
                {
                    title: '建设项目',
                    itemId: 'jsxmTab',
                    layout: 'fit',
                    hidden: IS_BZB == '1' || IS_BZB == '2'? false : true,
                    scrollable: true,
                    items: jsxmTab(node_code,onlyShow,ydjh_id)
                },
                {
                    title: '到期债券',
                    itemId: 'dqzqTab',
                    layout: 'fit',
                    scrollable: true,
                    items: dqzqTab(node_code,onlyShow,ydjh_id)
                },
                {
                    title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                    layout: 'fit',
                    itemId: 'fujian',
                    scrollable: true,
                    items: initWindow_zqfx_contentForm_tab_xmfj(onlyShow)
                }],
            listeners: {
                tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                    if(IS_BZB == '1' || IS_BZB == '2'){
                        if (newCard.itemId == "jsxmTab") {
                            //兑付计划只有一条数据,将建设项目页签兑付日期设为兑付计划中唯一的兑付日期
                            var dfjhGrid = DSYGrid.getGrid('dfjhGrid').getStore();
                            var jsxmGrid = DSYGrid.getGrid('jsxmGrid').getStore();
                            if (dfjhGrid.getCount() == 1) {
                                var df_end_date= Ext.util.Format.date(dfjhGrid.getAt(0).get("DF_END_DATE"), 'Y-m-d');
                                jsxmGrid.each(function (record) {
                                    record.set("DF_END_DATE", df_end_date,'YYYY-mm-dd');

                                });
                            }
                        }
                    }
                }
            }
        });
        if (node_code == '1') {
            editorTab.tabBar.items.items[2].hide();
        }
        if (node_code == '2') {
            editorTab.setActiveTab(2);
            //设置基本信息表为不可编辑
            var jbxxForm = Ext.ComponentQuery.query('form#jbxxForm')[0];
            jbxxForm.items.each(function (item2) {
                item2.items.each(function (item3) {
                    item3.items.each(function (item4) {
                        item4.readOnly = true;
                        item4.fieldStyle = 'background:#E6E6E6';
                    });
                });
            });
            var SHMS2 = jbxxForm.getForm().findField('SHMS2');
            SHMS2.setReadOnly(true);
            SHMS2.setFieldStyle('background:#E6E6E6');
            var SHMS3 = jbxxForm.getForm().findField('SHMS3');
            SHMS3.setReadOnly(true);
            SHMS3.setFieldStyle('background:#E6E6E6');
        }
        if (onlyShow) {
            var jbxxForm = Ext.ComponentQuery.query('form#jbxxForm')[0];
            jbxxForm.items.each(function (item2) {
                item2.items.each(function (item3) {
                    item3.items.each(function (item4) {
                        item4.readOnly = true;
                        item4.fieldStyle = 'background:#E6E6E6';
                    });
                });
            });
            var SHMS2 = jbxxForm.getForm().findField('SHMS2');
            SHMS2.setReadOnly(true);
            SHMS2.setFieldStyle('background:#E6E6E6');
            var SHMS3 = jbxxForm.getForm().findField('SHMS3');
            SHMS3.setReadOnly(true);
            SHMS3.setFieldStyle('background:#E6E6E6');
            var cxtForm = Ext.ComponentQuery.query('form#cxtForm')[0];
            var CXT_ID = cxtForm.getForm().findField('CXT_ID');
            CXT_ID.setReadOnly(true);
            CXT_ID.setFieldStyle('background:#E6E6E6');
            cxtForm.down('grid').down('#add_editGrid').setVisible(false);
            cxtForm.down('grid').down('#delete_editGrid').setVisible(false);

        }
        if (isViewCXJG == 0) {//如果启用系统参数，不显示承销机构则其他三个页签隐藏
            editorTab.tabBar.items.items[1].hide();
            editorTab.tabBar.items.items[2].hide();
            //editorTab.tabBar.items.items[3].hide();
        }
        return editorTab;
    }

    /**
     * 初始化债券发行弹出窗口中的项目附件标签页
     */
    function initWindow_zqfx_contentForm_tab_xmfj(onlyShow) {

        var grid = UploadPanel.createGrid({
            busiType: 'ET201',//业务类型
            busiId: ZQ_BILL_ID,//业务ID
            editable: !onlyShow,//是否可以修改附件内容
            gridConfig: {
                itemId: 'window_zqfx_contentForm_tab_xmfj_grid'
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
            if (grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
    }

    /**
     * 初始化按钮
     */
    function initButton() {
        var combobox_WF_STATUS = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0];
        var btn_insert = Ext.ComponentQuery.query('button[name="btn_insert"]')[0];
        var btn_xfx = Ext.ComponentQuery.query('button[name="btn_xfx"]')[0];
        var btn_update = Ext.ComponentQuery.query('button[name="btn_update"]')[0];
        var btn_delete = Ext.ComponentQuery.query('button[name="btn_delete"]')[0];
        var btn_next = Ext.ComponentQuery.query('button[name="btn_next"]')[0];
        var btn_cancel = Ext.ComponentQuery.query('button[name="btn_cancel"]')[0];

        //根据当前结点状态，控制状态下拉框绑定的json以及按钮的显示与隐藏
        if (node_code == '1') {  // 送审
            combobox_WF_STATUS.bindStore(DebtEleStore(json_debt_zt1));
            if (combobox_WF_STATUS.value == '000') {
                btn_insert.hide();
                btn_xfx.hide();
                btn_update.hide();
                btn_delete.hide();
                btn_next.hide();
                btn_cancel.hide();
            } else if (combobox_WF_STATUS.value == '001') {
                btn_insert.show();
                //btn_xfx.show();
                btn_update.show();
                btn_delete.show();
                btn_next.show();
                btn_cancel.hide();
            } else if (combobox_WF_STATUS.value == '002') {
                btn_insert.hide();
                btn_xfx.hide();
                btn_update.hide();
                btn_delete.hide();
                btn_next.hide();
                btn_cancel.show();
            } else if (combobox_WF_STATUS.value == '008') {
                btn_insert.hide();
                btn_xfx.hide();
                btn_update.hide();
                btn_delete.hide();
                btn_next.hide();
                btn_cancel.hide();
            } else {
                btn_insert.hide();
                btn_xfx.hide();
                btn_update.show();
                btn_delete.show();
                btn_next.show();
                btn_cancel.hide();
            }
        } else if (node_code == '2') { // 登记
            if( status == '1'){
                combobox_WF_STATUS.bindStore(DebtEleStore(json_debt_djzt));
            }else{
                combobox_WF_STATUS.bindStore(DebtEleStore(json_debt_zt2_6));
            }
            btn_insert.hide();
            btn_delete.hide();
            btn_cancel.hide();
            btn_next.hide();
            if (combobox_WF_STATUS.value == '000') {
                btn_insert.hide();
                btn_update.hide();
                btn_delete.hide();
                btn_next.hide();
                btn_cancel.hide();
            } else if (combobox_WF_STATUS.value == '001') {
                btn_update.show();
                if(1 == status){
                    btn_update.setText('登记');
                }
            } else if (combobox_WF_STATUS.value == '002') {
                btn_update.hide();
                btn_cancel.show();
                if(1 == status){
                    btn_update.show();
                    btn_cancel.hide();
                    btn_update.setText('重新登记');
                }
            } else if (combobox_WF_STATUS.value == '003') {
                btn_update.hide();
                btn_cancel.show();
                if(1 == status){
                    btn_update.show();
                    btn_cancel.hide();
                    btn_update.setText('重新登记');
                }
            } else if (combobox_WF_STATUS.value == '008') {
                btn_insert.hide();
                btn_update.hide();
                btn_delete.hide();
            }
        } else if (node_code == '3') {
            combobox_WF_STATUS.bindStore(DebtEleStore(json_debt_zt3));
            btn_insert.hide();
            btn_update.hide();
            btn_delete.hide();
            btn_cancel.hide();

            if (combobox_WF_STATUS.value == '001') {
                btn_next.show();
            } else if (combobox_WF_STATUS.value == '002') {
                btn_next.hide();
                btn_cancel.show();
            } else {
                btn_next.show();
            }
        }
        // if(conn == '1'){
        //     btn_insert.hide();
        //     btn_xfx.hide();
        //     btn_update.hide();
        //     btn_delete.hide();
        //     btn_next.hide();
        //     btn_cancel.hide();
        // }
        fuc_getFxglGrid();
    }
    /**
     * 发行管理信息列表
     */
    function fuc_getFxglGrid() {
        var store = DSYGrid.getGrid('grid').getStore();
        WF_STATUS = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0].value;
        SET_YEAR = Ext.ComponentQuery.query('combobox[name="SET_YEAR"]')[0].value;
        //ZQPZ_ID = Ext.ComponentQuery.query('treecombobox[name="ZQPZ_ID"]')[0].value;
        //初始化表格Store参数
        store.getProxy().extraParams = {
            wf_id: wf_id,
            node_code: node_code,
            userCode: userCode,
            WF_STATUS: WF_STATUS,
            SET_YEAR: SET_YEAR,
            status:status
            //ZQPZ_ID : ZQPZ_ID
        };
        //刷新表格内容
        DSYGrid.getGrid("grid").getStore().loadPage(1);
    }
    function initWindow_ydjh() {
        var ydjh_window= Ext.create('Ext.window.Window', {
            title: '月度发行计划选择', // 窗口标题
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.9, //自适应窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_ydjh', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',
            items: [initWindow_ydjh_grid()],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        var grid = btn.up('window').down('grid');
                        var ydjh_record = grid.getSelectionModel().getSelection();
                        if (ydjh_record.length != 1) {     //是否选择了有效的债券
                            Ext.MessageBox.alert('提示', '请选择一条数据后再进行操作');
                            return;
                        }
                        ydjh_id = ydjh_record[0].data.YDJH_ID;
                        HBFS_ID = ydjh_record[0].data.HBFS_ID; // 还本方式
                        ydjhXzAmt = ydjh_record[0].data.PLAN_XZ_AMT; // 赋值月度计划新增金额
                        ydjhZrzAmt = ydjh_record[0].data.PLAN_ZRZ_AMT;// 赋值月度计划再融资金额
                        //校验项目防伪码
                        if(!checkSecuCode({'IDS':[ydjh_id],'CHECK_NODE':'ZQZC'})){
                            return;
                        }
                        //收入科目的年度应为该债券的计划年度，而不是当前年度
                        var srkmyear=ydjh_record[0].data.YEAR;
                        var condition_str = srkmyear <= 2017 ? " <= '2017' " :" = '"+ srkmyear +"' ";
                        zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%')  and year "+ condition_str);
                        zwsrkm_store.load({
                            callback : function() {
                                fuc_addFxgl(isEdit,ydjh_id);
                                loadZqxx(ydjh_id);
                                btn.up('window').close();
                            }
                        });
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
        ydjh_window.show();
        ReloadYdjhChoose();
    }
    function initWindow_ydjh_grid() {
        //申请填报的主单
        var toolbar_choose_ydjh = [
            {
                xtype: 'combobox',
                fieldLabel: '计划年度',
                labelWidth: 60,
                width: 200,
                name: 'debt_year',
                value: nowYear,
                //editable: false,
                //readOnly: true,
                enableKeyEvents: true,
                displayField: 'name',
                valueField: 'code',
                store: DebtEleStore(json_debt_year),
                listeners: {
                    'select': function (self, record) {
                    }
                }
            },
            {
                xtype: 'combobox',
                fieldLabel: '计划月份',
                labelWidth: 60,
                width: 200,
                name: 'debt_month',
                displayField: 'name',
                valueField: 'id',
                store: monthStore

            },
            {
                xtype: 'treecombobox',
                fieldLabel: '债券类型',
                name: 'zqlb_id',
                displayField: 'name',
                valueField: 'code',
                editable: false,
                store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                readOnly: false
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    ReloadYdjhChoose()
                }
            }
        ];
        var headerjson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count'
            },
            {dataIndex: 'YDJH_ID', text: "月度计划ID", type: "string", hidden: true},
            {dataIndex: 'YEAR', text: "计划年度", type: "string", hidden: true},
            {dataIndex: 'YDJH_YEAR', text: "计划年度", type: "string", width: 100},
            {dataIndex: 'YDJH_MONTH', text: "计划月份", type: "string", width: 100},
            {dataIndex: 'JHFX_DATE', text: "计划发行时间", type: "string", width: 180},
            {dataIndex: 'ZQPC_NAME', text: "发行批次", type: "string", width: 180},
            {dataIndex: 'ZQ_NAME', text: "债券名称", type: "string", width: 200},
            {dataIndex: 'ZQLB_NAME', text: "债券类型", type: "string", width: 100},
            {dataIndex: 'PLAN_XZ_AMT', text: "新增债券金额（亿元）", type: "float", width: 180,align:'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            },
            {
                dataIndex: 'PLAN_ZRZ_AMT', text: "再融资债券金额（亿元）", type: "float", width: 180, align: 'right',
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.000000');
                }
            }
        ];

        return DSYGrid.createGrid({
            itemId: 'ydjhChooseGrid',
            headerConfig: {
                headerJson: headerjson,
                columnAutoWidth: false
            },
            selModel: {
                mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            checkBox: false,
            border: false,
            autoLoad: false,
            height: '50%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            params: {
                AD_CODE: AD_CODE
            },
            dataUrl: 'chooseYdjh.action',
            tbar:toolbar_choose_ydjh ,
            listeners: {
                itemclick: function (self, record) {
                }
            }
        });
    }
    function ReloadYdjhChoose(param) {
        var grid = DSYGrid.getGrid('ydjhChooseGrid');
        var store = grid.getStore();
        var jh_year = Ext.ComponentQuery.query('combobox[name="debt_year"]')[0].value;
        var jh_month = Ext.ComponentQuery.query('combobox[name="debt_month"]')[0].value;
        var zqlb_id = Ext.ComponentQuery.query('treecombobox[name="zqlb_id"]')[0].value;

        //增加查询参数
        store.getProxy().extraParams['jh_year'] = jh_year;
        store.getProxy().extraParams['jh_month'] = jh_month;
        store.getProxy().extraParams['zqlb_id'] = zqlb_id;

        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        //刷新
        store.loadPage(1);
    }

    /**
     * 债券注册录入页面
     */
    function fuc_addFxgl(isEditm,ydjh_id) {
        cxt_id = '';
        button_name = 'INPUT';//按钮名称为INPUT
        var iTitle = "债券注册";
        //var iWidth = 1120;//窗口宽度
        var iWidth = document.body.clientWidth * 0.90;
        var iHeight = document.body.clientHeight * 0.95;//窗口高度
        if(iHeight < 520){  //当分辨率在1366*768时扩大窗口高度
            iHeight = 520 ;
        }
        //var iHeight = window.screen.availHeight*3/4;
        var addWindow = new Ext.Window({
            title: iTitle,
            itemId: 'addWin',
            width: iWidth,
            height: iHeight,
            frame: true,
            constrain: true,
            maximizable: true,//最大化按钮
            //autoScroll: true,
            buttonAlign: 'right', // 按钮显示的位置
            modal: true,
            resizable: true,//大小不可改变
            plain: true,
            layout: 'fit',
            items: [initEditor(isEdit,false,ydjh_id)],
            closeAction: 'destroy',
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    itemId: 'save_editGrid',
                    name: 'SAVE',
                    handler: function (btn) {
                        var form = Ext.ComponentQuery.query('form#jbxxForm')[0];
                        //实际发行额与计划额校验
                        cheSJJE_SAVE(form);
                        if (isViewCXJG == 1) {
                            //判断机构信息是否存在重复
                            var jgxxStore = DSYGrid.getGrid('jgxxGrid').getStore();
                            if (jgxxStore.getCount() <= 0) {
                                Ext.Msg.alert('提示', "请添加承销团信息！");
                                return;
                            }
                            var jgxxArray = new Array();
                            for (var i = 0; i < jgxxStore.getCount(); i++) {
                                var record = jgxxStore.getAt(i);
                                if (!record.get('CXJG_CODE') || record.get('CXJG_CODE') == null) {
                                    Ext.Msg.alert('提示','机构名称不能为空，请输入机构名称');
                                    return;
                                }
                                if ((!record.get('CXS_TGZH') || record.get('CXS_TGZH') == null)&&(!record.get("CXS_ZZDZH")||record.get("CXS_ZZDZH")==null)) {
                                    Ext.Msg.alert('提示','承销商托管账号不能为空，请输入承销商托管账号');
                                    return;
                                }
                                jgxxArray.push(record.get("CXJG_NAME"));
                            }
                            var nary = jgxxArray.sort();
                            for (var i = 0; i < nary.length; i++) {
                                if (nary[i] == nary[i + 1]) {
                                    Ext.Msg.alert('提示','机构信息存在重复，重复机构为：' + nary[i]);
                                    return;
                                }
                            }
                        }
                        submitFxgl(form, "");
                    }
                },
                {
                    xtype: 'button',
                    text: '取消',
                    name: 'CLOSE',
                    handler: function () {
                        zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%') ");
                        zwsrkm_store.load();
                        if (button_name == 'INPUT') {
                            Ext.ComponentQuery.query('window#addWin')[0].close();
                        } else {
                            Ext.ComponentQuery.query('window#updateWin')[0].close();
                        }
                    }
                }
            ]
        });
        addWindow.on("close",function () {
            fxfs = false;
        });
        addWindow.show();
    }

    /**
     * 修改
     */
    function fuc_updateFxgl(isEdit) {
        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
        } else {
            //判断是中标登记还是修改 如果是登记 设置button_name 为VIEW 禁用form 和表格编辑
            if(button_name && button_name.indexOf('登记') != -1 ){
                button_name = 'VIEW';
            }else{
                button_name = 'EDIT';
            }
            var buttons = null;
            ydjh_id=records[0].data.YDJH_ID;
            if (node_code == '2') {
                buttons = [
                    {
                        xtype: 'button',
                        text: '保存',
                        itemId: 'save_editGrid',
                        name: 'SAVE',
                        hidden: true,
                        handler: function (btn) {
                            var form = Ext.ComponentQuery.query('form#zbqkForm')[0];
                            submitFxxxDj(form, btn, "SAVE");
                        }
                    },
                    //外部导入功能
                    {   xtype: 'form',
                        layout:'fit',
                        itemId:'formupload1',
                        border: false,
                        frame: false,
                        hidden:hidden_flag,
                        items:[]
                    },
                    {
                        xtype: 'button',
                        text: '登记确认',
                        itemId: 'save_next',
                        name: 'SAVE_NEXT',
                        handler: function (btn) {
                            var form = Ext.ComponentQuery.query('form#zbqkForm')[0];
                            submitFxxxDj(form, btn, "NEXT");

                        }
                    },
                    {
                        xtype: 'button',
                        text: '取消',
                        name: 'CLOSE',
                        handler: function () {
                            zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%') ");
                            zwsrkm_store.load();
                            if (button_name == 'INPUT') {
                                Ext.ComponentQuery.query('window#addWin')[0].close();
                            } else {
                                Ext.ComponentQuery.query('window#updateWin')[0].close();
                            }
                        }
                    }

                ];
            } else {
                buttons = [
                    {
                        xtype: 'button',
                        text: '保存',
                        itemId: 'save_editGrid',
                        name: 'SAVE',
                        handler: function (btn) {
                            var form = Ext.ComponentQuery.query('form#jbxxForm')[0];
                            //判断机构信息是否存在重复
                            if (isViewCXJG == 1) {
                                var jgxxStore = DSYGrid.getGrid('jgxxGrid').getStore();
                                var jgxxArray = new Array();
                                for (var i = 0; i < jgxxStore.getCount(); i++) {
                                    var record = jgxxStore.getAt(i);
                                    if (!record.get('CXJG_CODE') || record.get('CXJG_CODE') == null) {
                                        Ext.Msg.alert('提示','机构名称不能为空，请输入机构名称');
                                        return;
                                    }
                                    if ((!record.get('CXS_TGZH') || record.get('CXS_TGZH') == null)&&(!record.get("CXS_ZZDZH")||record.get("CXS_ZZDZH")==null)) {
                                        Ext.Msg.alert('提示','承销商托管账号不能为空，请输入承销商托管账号');
                                        return;
                                    }
                                    jgxxArray.push(record.get("CXJG_NAME"));
                                }
                                var nary = jgxxArray.sort();
                                var flag = true;
                                for (var i = 0; i < nary.length; i++) {
                                    if (nary[i] == nary[i + 1]) {
                                        Ext.Msg.alert('提示','机构信息存在重复，重复机构为：' + nary[i]);
                                        flag = false;
                                        return;
                                    }
                                }


                                if (flag) {
                                    submitFxgl(form, "");
                                }
                            } else {
                                submitFxgl(form, "");
                            }

                        }
                    },
                    {
                        xtype: 'button',
                        text: '取消',
                        name: 'CLOSE',
                        handler: function () {
                            zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%') ");
                            zwsrkm_store.load();
                            if (button_name == 'INPUT') {
                                Ext.ComponentQuery.query('window#addWin')[0].close();
                            } else {
                                Ext.ComponentQuery.query('window#updateWin')[0].close();
                            }
                        }
                    }

                ]
            }
            var grid = DSYGrid.getGrid('grid');
            var ydjh_record = grid.getSelectionModel().getSelection();
            ydjh_id = ydjh_record[0].data.YDJH_ID;
            ZQ_BILL_ID = records[0].get("ZQ_BILL_ID");
            HBFS_ID = records[0].get("HBFS_ID");
            var iTitle = title_text;
            //var iWidth = 1120;//窗口宽度
            var iWidth = document.body.clientWidth * 0.95;
            var iHeight = document.body.clientHeight * 0.99;//窗口高度
            if(iHeight < 520){//当分辨率在1366*768时扩大窗口高度
                iHeight = 520 ;
            }
            var updateWindow = new Ext.Window({
                title: iTitle,
                itemId: 'updateWin',
                width: iWidth,
                height: iHeight,
                maximizable: true,//最大化按钮
                frame: true,
                constrain: true,
                buttonAlign: 'right', // 按钮显示的位置
                modal: true,
                resizable: true,//大小不可改变
                layout: 'fit',
                plain: true,
                items: [initEditor(isEdit,false,ydjh_id)],
                closeAction: 'destroy',
                buttons: buttons
            });
            updateWindow.show();

        }
    }

    /**
     * 删除
     */
    function fuc_deleteFxgl() {
        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
                var fxglArray = [];
                Ext.each(records, function (record) {
                    var array = {};
                    array.ZQ_BILL_ID = record.get("ZQ_BILL_ID");
                    fxglArray.push(array);
                });
                //向后台传递变更数据信息
                Ext.Ajax.request({
                    method: 'POST',
                    url: "deleteFxgl.action",
                    params: {
                        //增加传入后台参数
                        //start modify by Arno Lee 2016-08-19
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: "删除",
                        audit_info: audit_info,
                        userCode: userCode,
                        isViewCXJG: isViewCXJG,
                        //end modify by Arno Lee 2016-08-19
                        fxglArray: Ext.util.JSON.encode(fxglArray)
                    },
                    async: false,
                    //start modify by Arno Lee 2016-08-17
                    success: function (form, action) {
                        var response = Ext.util.JSON.decode(form.responseText);
                        var message = response.message;
                        if (response.success) {
                            message = "删除成功";
                        }
                        Ext.MessageBox.show({
                            title: '提示',
                            msg: message,
                            width: 200,
                            buttons: Ext.MessageBox.OK,
                            fn: function () {
                                DSYGrid.getGrid("grid").getStore().loadPage(1);
                            }
                        });
                    },

                    //直接获取后台返回信息，后台不会抛出异常，此方法没有用,如果需要判断是否出错，可以获取JSON.parse(form.responseText).success
                    //start note by Arno Lee 2016-08-17
// 					success : function(form, action) {
//      				Ext.MessageBox.show({
//       				    title : '提示',
//       				    msg : '删除成功',
//       					width : 200,
//       					buttons : Ext.MessageBox.OK,
//      				  	fn : function() {
//       				  		DSYGrid.getGrid("grid").getStore().loadPage(1);
//      			     	}
//     				  	});
//    				}
// 					failure : function(form, action) {
// 						Ext.MessageBox.show({
// 							title : '提示',
// 							msg : '删除失败',
// 							width : 200,
// 							fn : function() {
// 								DSYGrid.getGrid("grid").getStore().loadPage(1);
// 							}
// 						});
// 					}
                    //end modify by Arno Lee 2016-08-17
                });
            }
        });
    }

    /**
     * 文件上传
     */
    function fuc_uploadFile() {
        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
        } else {
            /*busi_id = records[0].get("ZQ_BILL_ID");
             var uploadPanel = new UploadPanel();
             uploadPanel.setBusiType('ET001');//业务类型
             uploadPanel.setBusiId(busi_id);//业务ID
             uploadPanel.setBusiProperty('C01|L02|T01');//业务规则
             uploadPanel.setEditable(true);//是否可以修改附件内容*/
            var uploadPanel = UploadPanel.createGrid({
                busiType: 'ET201',
                busiId: records[0].get("ZQ_BILL_ID")
            });
            var iTitle = "中标登记文件上传";
            var iWidth = document.body.clientWidth * 0.95;
            var iHeight = document.body.clientHeight * 0.9;//窗口高度
            var uploadWindow = new Ext.Window({
                title: iTitle,
                itemId: 'updateWin',
                width: iWidth,
                height: iHeight,
                maximizable: true,//最大化按钮
                frame: true,
                constrain: true,
                buttonAlign: "left", // 按钮显示的位置
                modal: true,
                resizable: false,//大小不可改变
                plain: true,
                items: [uploadPanel],
                closeAction: 'destroy'
            });
            uploadWindow.show();
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
            if (node_code == '1' || node_code == '2' || node_code == '3') {
                msg_success = button_name + '成功！';
                msg_failure = button_name + '失败！';
            }
            var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
            var fxglArray = [];
            Ext.each(records, function (record) {
                var array = {};
                array.ID = record.get("ZQ_BILL_ID");
                array.SET_YEAR = record.get("YEAR");
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
                //start modify by Arno Lee 2016-08-18
                success: function (form, action) {
                    var response = Ext.util.JSON.decode(form.responseText);
                    var message = response.message;
                    if (response.success) {
                        message = msg_success;
                    }
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: message,
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function () {
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                        }
                    });
                }
                //直接获取后台返回信息，后台不会抛出异常，此方法没有用,如果需要判断是否出错，可以获取JSON.parse(form.responseText).success
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
            var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
            var fxglArray = [];
            Ext.each(records, function (record) {
                var array = {};
                array.ID = record.get("ZQ_BILL_ID");
                array.FX_START_DATE = record.get("FX_START_DATE");
                array.AD_CODE = record.get("AD_CODE");
                fxglArray.push(array);
            });
            //向后台传递变更数据信息
            Ext.Ajax.request({
                method: 'POST',
                url: 'backFxgl.action',
                params: {
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: cancel_text,
                    audit_info: audit_info,
                    userCode: userCode,
                    fxglArray: Ext.util.JSON.encode(fxglArray)
                },
                async: false,

                //start modify by Arno Lee 2016-08-18
                success: function (form, action) {
                    var response = Ext.util.JSON.decode(form.responseText);
                    var message = response.message;
                    if (response.success) {
                        message = button_name + "成功";
                    }
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: message,
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function () {
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                        }
                    });
                }
                //直接获取后台返回信息，后台不会抛出异常，此方法没有用,如果需要判断是否出错，可以获取JSON.parse(form.responseText).success
                //start note by Arno Lee 2016-08-17

// 					success : function(form, action) {
// 						Ext.MessageBox.show({
// 							title : '提示',
// 							msg : '退回成功',
// 							width : 200,
// 							buttons : Ext.MessageBox.OK,
// 							fn : function(btn) {
// 								DSYGrid.getGrid("grid").getStore().loadPage(1);
// 							}
// 						});
// 					},
// 					failure : function(form, action) {
// 						Ext.MessageBox.show({
// 							title : '提示',
// 							msg : '退回失败',
// 							width : 200,
// 							fn : function(btn) {
// 								DSYGrid.getGrid("grid").getStore().loadPage(1);
// 							}
// 						});
// 					}
                //end modify by Arno Lee 2016-08-18
            });
        }
    }

    /**
     * 双击显示债券信息
     */
    function fuc_showZqxx(isEdit, record) {
        if (record != null) {
            button_name = 'VIEW';//按钮名称为INPUT
            ZQ_BILL_ID = record.get("ZQ_BILL_ID");
            var iTitle = "债券信息";
            var iWidth = document.body.clientWidth * 0.95;
            var iHeight = document.body.clientHeight * 0.9;//窗口高度
            if(iHeight < 520){  //调整1366*768分辨率下完全显示
                iHeight = 520 ;
            }
            var updateWindow = new Ext.Window({
                title: iTitle,
                itemId: 'updateWin',
                width: iWidth,
                height: iHeight,
                maximizable: true,//最大化按钮
                frame: true,
                constrain: true,
                buttonAlign: 'right', // 按钮显示的位置
                modal: true,
                resizable: true,//大小不可改变
                plain: true,
                layout: 'fit',
                items: [initEditor(isEdit, true)],
                closeAction: 'destroy'
            });
            updateWindow.show();

        }
    }

    /**
     * 加载页面数据
     * @param form
     */
    function loadZqxx(ydjh_id) {
        var form = Ext.ComponentQuery.query('form[itemId="jbxxForm"]')[0];
        form.load({
            url: 'loadZqxx.action?ydjh_id=' + ydjh_id,
            waitTitle: '请等待',
            waitMsg: '正在加载中...',
            success: function (form_success, action) {
                form.getForm().setValues(action.result.data.list);
                var jsxmGrid = DSYGrid.getGrid('jsxmGrid');
                //jsxmGrid.getStore().removeAll();
                jsxmGrid.insertData(null, action.result.data.jsxmList);
                Ext.ComponentQuery.query('combobox[name="ZQ_PC_ID"]')[0].setValue(action.result.data.list.PCJH_ID);
                Ext.ComponentQuery.query('treecombobox[name="SRKM_ID"]')[0].setValue(action.result.data.list.SRKM_ID);
                //Ext.ComponentQuery.query('combobox[name="CXT_ID"]')[0].setValue(action.result.data.list.CXT_ID);
                //refresh_jgxxGrid();
                //refresh_dfjhGrid();
                // 月度计划新增金额、月度计划再融资金额、都大于0不校验
                if(ydjhXzAmt > 0 && ydjhZrzAmt > 0){

                }else if(ydjhXzAmt > 0){// 月度计划新增金额大于0，债权类型默认为新增债券
                    Ext.ComponentQuery.query('combobox[name="ZQLX_ID"]')[0].setValue('01');
                    Ext.ComponentQuery.query('combobox[name="ZQLX_ID"]')[0].setReadOnly(true);
                    Ext.ComponentQuery.query('combobox[name="ZQLX_ID"]')[0].setFieldStyle('background:#E6E6E6');
                }else if(ydjhZrzAmt > 0){// 月度计划再融资金额大于0，债权类型默认为再融资债券
                    Ext.ComponentQuery.query('combobox[name="ZQLX_ID"]')[0].setValue('03');
                    Ext.ComponentQuery.query('combobox[name="ZQLX_ID"]')[0].setReadOnly(true);
                    Ext.ComponentQuery.query('combobox[name="ZQLX_ID"]')[0].setFieldStyle('background:#E6E6E6');
                }
            },
            failure: function (form_failure, action) {
                Ext.MessageBox.alert('提示', '查询' + '失败！' + action.result.message);
                return;
            }
        });
    }

    /**
     * 续发行：债券选择窗口
     */
    var selectXfxZqxxWindow = {
        window: null,
        show: function () {
            if (!this.window) {
                this.window = init_xfx_zq_select_window();
            }
            this.window.show();
        }
    };
    function init_xfx_zq_select_window() {
        return Ext.create('Ext.window.Window', {
            itemId: 'xfx_zq_select_window',
            title: '债券选择窗口',
            width:  document.body.clientWidth*0.9,
            height: document.body.clientHeight*0.9,
            layout: 'fit',
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction : 'destroy',
            border: false,
            items: [
                init_xfx_zq_select_grid()
            ],
            buttons: [
                {
                    text: '确定',
                    handler: function (btn) {
                        initXfxWin();
                        btn.up('window').close();
                    }
                },
                {
                    text: '取消',
                    handler: function (btn) {
                        //关闭编辑模板窗口
                        btn.up('window').close();
                    }
                }
            ],
            listeners: {
                close: function() {
                    selectXfxZqxxWindow.window = null;
                }
            }
        });
    }
    /**
     * 续发行：债券选择表格
     */
    function init_xfx_zq_select_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                "dataIndex": "YDJH_ID",
                "type": "string",
                "text": "月度计划ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "ZQ_BILL_ID",
                "type": "string",
                "text": "债券ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "ZQ_CODE",
                "type": "string",
                "text": "债券代码",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "ZQLB_ID",
                "type": "string",
                "text": "债券类型",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "ZQ_NAME",
                "type": "string",
                "width": 250,
                "text": "债券名称",
                renderer: function (data, cell, record) {
                    /* var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+userAD;
                     return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_BILL_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_BILL_ID');
                    paramValues[1]=userAD;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "债券简称", dataIndex: "ZQ_JC", width: 250, type: "string"},
            {text: "发行批次ID", dataIndex: "ZQ_PC_ID", type: "string", hidden: true},
            {text: "发行批次", dataIndex: "ZQ_PC_NAME", type: "string"},
            {
                "dataIndex": "ZQPZ_ID",
                "width": 150,
                "type": "string",
                "text": "债券品种"
            },
            {
                "dataIndex": "PLAN_FX_AMT",
                "width": 150,
                "type": "number",
                "align": 'right',
                "text": "计划发行量（亿）",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "FX_AMT",
                "width": 150,
                "type": "number",
                "align": 'right',
                "text": "实际发行额（亿）",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },{
                "dataIndex": "ZBJG_AMT",
                "width": 150,
                "type": "number",
                "align": 'right',
                "text": "中标价格（元）",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },{
                "dataIndex": "ZQ_BILL_QX",
                "width": 150,
                "type": "string",
                "text": "期限"
            },
            {
                "dataIndex": "QX_DATE",
                "width": 150,
                "type": "string",
                "text": "起息日",
                "align": 'left'
            },
            {
                "dataIndex": "DQDF_DATE",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "到期兑付日"
            },
            {
                "dataIndex": "FX_START_DATE",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "发行时间"
            },
            {
                "dataIndex": "IS_ZD",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "已转贷",
                hidden: true

            },
            {
                "dataIndex": "IS_DJ",
                "width": 100,
                "type": "string",
                "align": 'left',
                "text": "是否已登记"
            },
            {
                "dataIndex": "IS_ZC",
                "width": 100,
                "type": "string",
                "align": 'left',
                "text": "是否已支出",
                hidden: true
            },
            {
                "dataIndex": "FIRST_ZQ_ID",
                "width": 100,
                "type": "string",
                "align": 'left',
                "text": "首次发行债券ID",
                hidden: true
            },
            {
                "dataIndex": "IS_XFX",
                "width": 100,
                "type": "string",
                "align": 'left',
                "text": "是否续发行",
                hidden: true
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'xfx_zq_select_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            border: false,
            autoLoad: true,
            flex: 1,
            checkBox: true,
            selModel: {
                mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            dataUrl: '/getXfxZqxx.action',
            params: {
                SET_YEAR: Ext.Date.format(new Date(), 'Y')
            },
            pageConfig: {
                enablePage: true,
                pageNum: true
            },
            dockedItems: [{
                xtype: 'toolbar',
                dock: 'top',
                items:[
                    {
                        xtype: "combobox",
                        name: "SET_YEAR",
                        store: DebtEleStore(json_debt_year),
                        displayField: "name",
                        valueField: "id",
                        value: new Date().getFullYear(),
                        fieldLabel: '债券发行年度',
                        editable: false, //禁用编辑
                        width: 200,
                        labelWidth: 90,
                        labelAlign: 'right',
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                                self.up('grid').getStore().loadPage(1);
                            }
                        }
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZQLB_ID",
                        store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '债券类型',
                        editable: false, //禁用编辑
                        width: 180,
                        labelWidth: 60,
                        labelAlign: 'right',
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                                self.up('grid').getStore().loadPage(1);
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "ZQ_FXPC_MB",
                        store: DebtEleStoreDB('DEBT_ZQPC'),
                        fieldLabel: '发行批次',
                        displayField: 'name',
                        valueField: 'id',
                        editable: false,
                        width: 200,
                        labelWidth: 60,
                        labelAlign: 'right',
                        listeners: {
                            change: function (self, newValue) {
                                //刷新当前表格
                                self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                                self.up('grid').getStore().loadPage(1);
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        name: "mhcx",
                        id: 'mhcx',
                        fieldLabel: '模糊查询',
                        allowBlank: true,
                        width: 250,
                        labelWidth: 60,
                        labelAlign: 'right',
                        emptyText: '请输入债券名称/债券代码...',
                        enableKeyEvents: true,
                        listeners: {
                            keypress: function (self, e) {
                                if (e.getKey() == Ext.EventObject.ENTER) {
                                    var mhcx = Ext.ComponentQuery.query('textfield#mhcx')[0].getValue();
                                    var xfx_zq_select_grid = DSYGrid.getGrid('xfx_zq_select_grid').getStore();
                                    xfx_zq_select_grid.getProxy().extraParams['MHCX'] = mhcx;
                                    xfx_zq_select_grid.loadPage(1);
                                }
                            }
                        }
                    },
                    '->',
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            var mhcx = Ext.ComponentQuery.query('textfield#mhcx')[0].getValue();
                            var xfx_zq_select_grid = DSYGrid.getGrid('xfx_zq_select_grid').getStore();
                            xfx_zq_select_grid.getProxy().extraParams['MHCX'] = mhcx;
                            xfx_zq_select_grid.loadPage(1);
                        }
                    }
                ]
            }]
        });
        return grid;
    }
    /**
     * 续发行债券注册初始化window
     */
    function initXfxWin() {
        var records = DSYGrid.getGrid('xfx_zq_select_grid').getSelection();
        isEdit = false;
        button_name = 'INPUT';
        ZQ_BILL_ID = records[0].get("ZQ_BILL_ID");
        var iTitle = "续发行债券注册";
        var iWidth = document.body.clientWidth;
        var iHeight = document.body.clientHeight;//窗口高度
        var XfxWindow = new Ext.Window({
            title: iTitle,
            itemId: 'XfxWin',
            width: iWidth,
            height: iHeight,
            maximizable: true,//最大化按钮
            frame: true,
            constrain: true,
            buttonAlign: 'right', // 按钮显示的位置
            modal: true,
            resizable: true,//大小不可改变
            plain: true,
            layout: 'fit',
            items: [initXfxEditor(isEdit,false)],
            closeAction: 'destroy',
            buttons: [
                {
                    xtype: 'button',
                    text: '保存',
                    itemId: 'save_editGrid',
                    name: 'SAVE',
                    handler: function (btn) {
                        var form = Ext.ComponentQuery.query('form#jbxxForm')[0];
                        //判断机构信息是否存在重复
                        if (isViewCXJG == 1) {
                            var jgxxStore = DSYGrid.getGrid('jgxxGrid').getStore();
                            var jgxxArray = new Array();
                            for (var i = 0; i < jgxxStore.getCount(); i++) {
                                var record = jgxxStore.getAt(i);
                                if (!record.get('CXJG_CODE') || record.get('CXJG_CODE') == null) {
                                    Ext.Msg.alert('提示','机构名称不能为空，请输入机构名称');
                                    return;
                                }
                                if ((!record.get('CXS_TGZH') || record.get('CXS_TGZH') == null)&&(!record.get("CXS_ZZDZH")||record.get("CXS_ZZDZH")==null)) {
                                    Ext.Msg.alert('提示','承销商托管账号不能为空，请输入承销商托管账号');
                                    return;
                                }
                                jgxxArray.push(record.get("CXJG_NAME"));
                            }
                            var nary = jgxxArray.sort();
                            var flag = true;
                            for (var i = 0; i < nary.length; i++) {
                                if (nary[i] == nary[i + 1]) {
                                    Ext.Msg.alert('提示','机构信息存在重复，重复机构为：' + nary[i]);
                                    flag = false;
                                    return;
                                }
                            }
                            if (flag) {
                                submitFxgl_xfx(form, "");
                            }
                        } else {
                            submitFxgl_xfx(form, "");
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '取消',
                    name: 'CLOSE',
                    handler: function (btn) {
                        zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%') ");
                        zwsrkm_store.load();
                        btn.up('window').close();
                    }
                }
            ]
        });
        XfxWindow.show();
    }
    /**
     * 续发行弹出界面
     */
    function initXfxEditor(isEdit, onlyShow, FIRST_ZQ_ID){
        var editorTab_xfx = Ext.create('Ext.tab.Panel', {
            itemId: 'main_tab',
            border: false,
            padding: '2 2 2 2',
            items: [
                {
                    title: '基本信息',
                    itemId: 'jbxxtab',
                    items: jbxxTab_xfx(node_code, isEdit, FIRST_ZQ_ID, onlyShow)
                },
                {
                    title: '承销团信息',
                    itemId: 'cxtxxtab',
                    items: cxtxxTab(node_code)
                },
                {
                    title: '发行信息',
                    layout: 'fit',
                    itemId: 'fxxxtab',
                    items: fxxxTab(onlyShow),
                    listeners: {
                        afterrender: function () {
                            if(!onlyShow){
                                var tab=Ext.ComponentQuery.query('#main_tab')[0];
                                tab.on({
                                    tabchange: function (tabPanel, newCard, oldCard, eOpts) {
                                        if(IS_BZB == '1' || IS_BZB == '2'){
                                            if(newCard.itemId=='jbxxtab'||newCard.itemId=='cxtxxtab'||newCard.itemId=='fujian'||newCard.itemId=='dfjhTab'||newCard.itemId=='jsxmTab'){
                                                var filebuttons=Ext.ComponentQuery.query('#uploady1')[0];
                                                form.remove(filebuttons);
                                            }else{
                                                form.add(filebutton);
                                            }
                                        }else{
                                            if(newCard.itemId=='jbxxtab'||newCard.itemId=='cxtxxtab'||newCard.itemId=='fujian'||newCard.itemId=='dfjhTab'){
                                                var filebuttons=Ext.ComponentQuery.query('#uploady1')[0];
                                                form.remove(filebuttons);
                                            }else{
                                                form.add(filebutton);
                                            }
                                        }
                                    }
                                });
                                var form = Ext.ComponentQuery.query('form#formupload1')[0];
                                form.add(filebutton);
                            }else{

                            } }
                    }
                },
                {
                    title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                    layout: 'fit',
                    itemId: 'fujian',
                    scrollable: true,
                    items: initWindow_zqfx_contentForm_tab_xmfj(onlyShow)
                }]
            //bbar : bbar
        });
        if (node_code == '1') {
            editorTab_xfx.tabBar.items.items[2].hide();
            //editorTab.tabBar.items.items[3].hide();
        }
        if (node_code == '2') {
            editorTab_xfx.setActiveTab(2);
            //设置基本信息表为不可编辑
            if(wf_id!='100110'){
            var jbxxForm = Ext.ComponentQuery.query('form#jbxxForm')[0];
            jbxxForm.items.each(function (item2) {
                item2.items.each(function (item3) {
                    item3.items.each(function (item4) {
                        item4.readOnly = true;
                        item4.fieldStyle = 'background:#E6E6E6';
                    });
                });
            });
            var SHMS2 = jbxxForm.getForm().findField('SHMS2');
            SHMS2.setReadOnly(true);
            SHMS2.setFieldStyle('background:#E6E6E6');
            var SHMS3 = jbxxForm.getForm().findField('SHMS3');
            SHMS3.setReadOnly(true);
            SHMS3.setFieldStyle('background:#E6E6E6');
            }
        }
        if (onlyShow) {
            var jbxxForm = Ext.ComponentQuery.query('form#jbxxForm')[0];
            jbxxForm.items.each(function (item2) {
                item2.items.each(function (item3) {
                    item3.items.each(function (item4) {
                        item4.readOnly = true;
                        item4.fieldStyle = 'background:#E6E6E6';
                    });
                });
            });
            var SHMS2 = jbxxForm.getForm().findField('SHMS2');
            SHMS2.setReadOnly(true);
            SHMS2.setFieldStyle('background:#E6E6E6');
            var SHMS3 = jbxxForm.getForm().findField('SHMS3');
            SHMS3.setReadOnly(true);
            SHMS3.setFieldStyle('background:#E6E6E6');
            var cxtForm = Ext.ComponentQuery.query('form#cxtForm')[0];
            var CXT_ID = cxtForm.getForm().findField('CXT_ID');
            CXT_ID.setReadOnly(true);
            CXT_ID.setFieldStyle('background:#E6E6E6');
            cxtForm.down('grid').down('#add_editGrid').setVisible(false);
            cxtForm.down('grid').down('#delete_editGrid').setVisible(false);
        }

        if (isViewCXJG == 0) {//如果启用系统参数，不显示承销机构则其他三个页签隐藏
            editorTab_xfx.tabBar.items.items[1].hide();
            editorTab_xfx.tabBar.items.items[2].hide();
            //editorTab.tabBar.items.items[3].hide();
        }
        return editorTab_xfx;
    }
    /**
     * 续发行：修改
     */
    function fuc_updateFxgl_xfx(isEdit) {
        //
        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
        } else {
            button_name = 'EDIT';
            var buttons = null;

            if (node_code == '2') {
                buttons = [
                    {
                        xtype: 'button',
                        text: '保存',
                        itemId: 'save_editGrid',
                        name: 'SAVE',
                        hidden: true,
                        handler: function (btn) {
                            var form = Ext.ComponentQuery.query('form#zbqkForm')[0];
                            submitFxxxDj(form, btn, "SAVE");
                        }
                    },
                    //外部导入功能
                    {   xtype: 'form',
                        layout:'fit',
                        itemId:'formupload1',
                        border: false,
                        frame: false,
                        hidden:hidden_flag,
                        items:[]
                    },
                    {
                        xtype: 'button',
                        text: '登记确认',
                        itemId: 'save_next',
                        name: 'SAVE_NEXT',
                        handler: function (btn) {
                            var form = Ext.ComponentQuery.query('form#zbqkForm')[0];
                            submitFxxxDj(form, btn, "NEXT");

                        }
                    },
                    {
                        xtype: 'button',
                        text: '取消',
                        name: 'CLOSE',
                        handler: function () {
                            zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%') ");
                            zwsrkm_store.load();
                            if (button_name == 'INPUT') {
                                Ext.ComponentQuery.query('window#addWin')[0].close();
                            } else {
                                Ext.ComponentQuery.query('window#updateWin')[0].close();
                            }
                        }
                    }

                ];
            } else {
                buttons = [
                    {
                        xtype: 'button',
                        text: '保存',
                        itemId: 'save_editGrid',
                        name: 'SAVE',
                        handler: function (btn) {
                            var form = Ext.ComponentQuery.query('form#jbxxForm')[0];
                            //判断机构信息是否存在重复
                            if (isViewCXJG == 1) {
                                var jgxxStore = DSYGrid.getGrid('jgxxGrid').getStore();
                                var jgxxArray = new Array();
                                for (var i = 0; i < jgxxStore.getCount(); i++) {
                                    var record = jgxxStore.getAt(i);
                                    if (!record.get('CXJG_CODE') || record.get('CXJG_CODE') == null) {
                                        Ext.Msg.alert('提示','机构名称不能为空，请输入机构名称');
                                        return;
                                    }
                                    if ((!record.get('CXS_TGZH') || record.get('CXS_TGZH') == null)&&(!record.get("CXS_ZZDZH")||record.get("CXS_ZZDZH")==null)) {
                                        Ext.Msg.alert('提示','承销商托管账号不能为空，请输入承销商托管账号');
                                        return;
                                    }
                                    jgxxArray.push(record.get("CXJG_NAME"));
                                }
                                var nary = jgxxArray.sort();
                                var flag = true;
                                for (var i = 0; i < nary.length; i++) {
                                    if (nary[i] == nary[i + 1]) {
                                        Ext.Msg.alert('提示','机构信息存在重复，重复机构为：' + nary[i]);
                                        flag = false;
                                        return;
                                    }
                                }
                                if (flag) {
                                    submitFxgl_xfx(form, "");
                                }
                            } else {
                                submitFxgl_xfx(form, "");
                            }

                        }
                    },
                    {
                        xtype: 'button',
                        text: '取消',
                        name: 'CLOSE',
                        handler: function () {
                            zwsrkm_store.proxy.extraParams['condition'] = encode64(" and (code like '105%') ");
                            zwsrkm_store.load();
                            if (button_name == 'INPUT') {
                                Ext.ComponentQuery.query('window#addWin')[0].close();
                            } else {
                                Ext.ComponentQuery.query('window#updateWin')[0].close();
                            }
                        }
                    }

                ]
            }
            ZQ_BILL_ID = records[0].get("ZQ_BILL_ID");
            var FIRST_ZQ_ID = records[0].get("FIRST_ZQ_ID");
            var iTitle = '续发行债券注册';
            //var iWidth = 1120;//窗口宽度
            var iWidth = document.body.clientWidth * 0.95;
            var iHeight = document.body.clientHeight * 0.9;//窗口高度
            var updateWindow = new Ext.Window({
                title: iTitle,
                itemId: 'updateWin',
                width: iWidth,
                height: iHeight,
                maximizable: true,//最大化按钮
                frame: true,
                constrain: true,
                buttonAlign: 'right', // 按钮显示的位置
                modal: true,
                resizable: true,//大小不可改变
                layout: 'fit',
                plain: true,
                items: [initXfxEditor(isEdit,false,FIRST_ZQ_ID)],
                closeAction: 'destroy',
                buttons: buttons
            });
            updateWindow.show();

        }
    }
    function initConn() {
        $.ajax({
            type: "POST",
            url: 'dsrwCzbConn.action',
            async: false, //设为false就是同步请求
            cache: false,
            dataType: 'json',
            data: {

            },
            success: function (data) {
                conn = data.conn;
                initButton();
            },fail:function () {
            }
        });
    }

</script>
<div id="mainDiv" style="width: 100%; height: 100%;">
</div>
</body>
</html>