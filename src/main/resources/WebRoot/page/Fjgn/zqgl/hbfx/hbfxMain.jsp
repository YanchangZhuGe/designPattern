<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld"%>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>债券兑付还本付息主界面</title>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript" src="PopupGridForHbfx.js"></script>

<script type="text/javascript">
   /* var wf_id = getQueryParam("wf_id");//当前流程id
    var node_code = getQueryParam("node_code");//当前节点id*/
   var wf_id ="${fns:getParamValue('wf_id')}";
   var node_code ="${fns:getParamValue('node_code')}";
    var button_name = '';//当前操作按钮名称
 /*   var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
   var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
   if (isNull(WF_STATUS)) {
       WF_STATUS = '001';
   }
    var SELECT_YQ = ''; //是否逾期
    var IS_KKDF = ''; //是否库款垫付
    var store_DEBT_ZJLY = null;
/*
    var is_zxzq = getQueryParam("is_zxzq");
*/
   var is_zxzq ="${fns:getParamValue('is_zxzq')}";
    var IS_BZB = '${fns:getSysParam("IS_BZB")}';//是否标准版
    //2020/08/25 guodg url参数来区分标准版和专项债
    if(IS_BZB == '1' && is_zxzq == '1'){
        IS_BZB = '2';
    }
    var  condition_temp = "and code not in ('05','06','07','0301','0302','02','0399','04')";
    if(IS_BZB == '2'){
        condition_temp += " AND CODE NOT LIKE '0101%'";
    }
    var store_debt_zjly_temp= DebtEleTreeStoreDB('DEBT_CHZJLY',{condition:condition_temp});
    //全局变量
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
/*
       var df_plan_id = getQueryParam("df_plan_id");
   */
   var df_plan_id ="${fns:getParamValue('df_plan_id')}";

    var ALL_DF_MONEY=new Object();
    var ALL_DFF_MONEY=new Object();

    var is_fix=false;
    var debuggers=true;
    var YLU_TEMP=new Object();

    var FIX_DF_TEMP=new Object();

    //var df_plan_id = 'A05D5404B0F247E99B224FAE32F1DFAF';
    //全局变量
    //提前获取以下store，弹出框中使用，表格中使用
    /**
     * 通用配置json
     */
    var zdhk_json_common = {
        100116: {//兑付申请工作流
            1: {//录入
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                //fuc_getMainGridData();
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '录入',
                            name: 'btn_insert',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                is_fix=false;

                                ALL_DF_MONEY=new Object();
                                ALL_DFF_MONEY=new Object();
                                YLU_TEMP=new Object();
                                button_name = btn.text;
                                store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY',{condition:' and code not in (\'05\',\'06\',\'07\',\'0301\',\'0302\') '});
                                window_input.show();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                ALL_DF_MONEY=new Object();
                                ALL_DFF_MONEY=new Object();
                                YLU_TEMP=new Object();
                                FIX_DF_TEMP=new Object();
                                is_fix=true;
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据进行操作');
                                    return;
                                }
                                 store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY',{condition:' and code not in (\'05\',\'06\',\'07\',\'0301\',\'0302\') '});
                                //store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY');

                                //修改全局变量的值
                                button_name = btn.text;
                                //发送ajax请求，查询主表和明细表数据
                                $.post("/getDfsqById.action", {
                                    DFSQ_ID: records[0].get('DFSQ_ID')
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        return;
                                    }
                                    //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                    var payDate = data.list[0].PAY_DATE;
                                    for (var i = 0; i < data.list.length; i++) {
                                        if (new Date(payDate) - new Date(data.list[i].PAY_DATE) < 0) {
                                            payDate = data.list[i].PAY_DATE;
                                        }
                                        if(data.list[i].HB_AMT_SY!=null&&data.list[i].HB_AMT_SY!=undefined){
                                            var HB_AMT_CZ=data.list[i].HB_AMT-data.list[i].HB_AMT_SY;
                                            var HBZQ_ID=data.list[i].HBZQ_ID;
                                            if(YLU_TEMP[HBZQ_ID]!=null&&YLU_TEMP[HBZQ_ID]!=undefined&&YLU_TEMP[HBZQ_ID]>=0){
                                                YLU_TEMP[HBZQ_ID]+=data.list[i].DF_AMT;
                                            }else{
                                                YLU_TEMP[HBZQ_ID]=data.list[i].DF_AMT;

                                            }
                                            //data.list[i].HB_AMT_SY+=data.list[i].DF_AMT;
                                        }
                                        data.list[i].BOOLEAN_IS_FIRST='0';

                                    }
                                    data.data.PAY_DATE = payDate;
                                    window_input.show();
                                    window_input.window.down('form').getForm().setValues(data.data);
                                    window_input.window.down('form').down('grid#dfsq_grid').insertData(null, data.list);
                                }, "json");
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_delete',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length <= 0) {
                                    Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("DFSQ_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/deleteDfsq.action", {
                                            ids: ids,
                                            wf_id: wf_id,
                                            node_code: node_code,
                                            button_name: button_name
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
                                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                            }
                                            //刷新表格
                                            reloadGrid();
                                        }, "json");
                                    }
                                });
                            }
                        },
                        {
                            xtype: 'button',
                            text: '送审',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                //fuc_getMainGridData();
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销送审',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
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
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                //fuc_getMainGridData();
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                is_fix=true;

                                ALL_DF_MONEY=new Object();
                                ALL_DFF_MONEY=new Object();
                                FIX_DF_TEMP=new Object();
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据进行操作');
                                    return;
                                }
                                store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY',{condition:' and code not in (\'05\',\'06\',\'07\',\'0301\',\'0302\') '});
                                //修改全局变量的值
                                button_name = btn.text;
                                //发送ajax请求，查询主表和明细表数据
                                $.post("/getDfsqById.action", {
                                    DFSQ_ID: records[0].get('DFSQ_ID')
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        return;
                                    }
                                    var payDate = data.list[0].PAY_DATE;
                                    for (var i = 0; i < data.list.length; i++) {
                                        if(data.list[i].HB_AMT_SY!=null&&data.list[i].HB_AMT_SY!=undefined){
                                            var HB_AMT_CZ=data.list[i].HB_AMT-data.list[i].HB_AMT_SY;
                                            var HBZQ_ID=data.list[i].HBZQ_ID;
                                            if(FIX_DF_TEMP[HBZQ_ID]!=null&&FIX_DF_TEMP[HBZQ_ID]!=undefined&&FIX_DF_TEMP[HBZQ_ID]>=0){
                                                FIX_DF_TEMP[HBZQ_ID]=HB_AMT_CZ;
                                            }

                                            if(YLU_TEMP[HBZQ_ID]!=null&&YLU_TEMP[HBZQ_ID]!=undefined&&YLU_TEMP[HBZQ_ID]>=0){
                                                YLU_TEMP[HBZQ_ID]+=data.list[i].DF_AMT;
                                            }else{
                                                YLU_TEMP[HBZQ_ID]=data.list[i].DF_AMT;
                                            }
                                            //data.list[i].HB_AMT_SY+=data.list[i].DF_AMT;

                                        }

                                        data.list[i].BOOLEAN_IS_FIRST='0';
                                    }
                                    //=data.list[i].HB_AMT_SY;
                                    //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                    data.data.PAY_DATE = payDate;
                                    window_input.show();
                                    window_input.window.down('form').getForm().setValues(data.data);
                                    window_input.window.down('form').down('grid#dfsq_grid').insertData(null, data.list);
                                }, "json");
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_delete',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length <= 0) {
                                    Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("DFSQ_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/deleteDfsq.action", {
                                            ids: ids,
                                            wf_id: wf_id,
                                            node_code: node_code,
                                            button_name: button_name
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
                                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                            }
                                            //刷新表格
                                            reloadGrid();
                                        }, "json");
                                    }
                                });
                            }
                        },
                        {
                            xtype: 'button',
                            text: '送审',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    //start modify by Arno Lee 2016-08-19
                    '008': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                //fuc_getMainGridData();
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                    //end modify by Arno Lee 2016-08-19
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt0)
                }
            },
            2: {//审核
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                //fuc_getMainGridData();
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '审核',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'up',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '附件查看',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                // 检验是否选中数据
                                // 获取选中数据
                                var record = DSYGrid.getGrid('contentGrid_detail').getCurrentRecord();
                                if (!record) {
                                    Ext.toast({
                                        html: "未选择明细数据！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    return false;
                                }
                                initWin_fjck({DFSQ_DTL_ID: record.get('DFSQ_DTL_ID')});
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                //fuc_getMainGridData();
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销审核',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_sh)
                }
            },
            3: {//审核
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '确认',
                            name: 'down',
                            icon: '/image/sysbutton/confirm.png',
                            handler: function (btn) {
                                updateConfirm(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [
                        {
                            xtype: 'button',
                            text: '撤销确认',
                            name: 'up',
                            icon: '/image/sysbutton/cancel.png',
                            handler: function (btn) {
                                updateConfirm(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt3)
                }
            }
        }
    };
    //创建转贷信息填报弹出窗口
    var window_input = {
        window: null,
        show: function () {
            this.window = initWindow_input();
            this.window.show();
        }
    };
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
        if (zdhk_json_common[wf_id][node_code].callBack) {
            zdhk_json_common[wf_id][node_code].callBack();
        }
        //如果是从代办事项进来，自动弹出录入界面
        if (df_plan_id != null && df_plan_id != "") {
            //发送ajax请求，查询主表和明细表数据
            $.post("/getDfdataByDfPlanId.action", {
                df_plan_id: df_plan_id
            }, function (data) {
                if (!data.success) {
                    Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                    return;
                }
                button_name = '录入';
                store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition:' and code not in (\'05\',\'06\',\'07\',\'0301\',\'0302\') '}, {autoLoad: false});
                store_DEBT_ZJLY.load({
                    callback: function (records, operation, success) {
                        var dfplan_data = data.list;
                        var ddata = dfplan_data[0];
                        ddata.DF_AMT = ddata.SY_AMT;
                        ddata.DFF_AMT = ddata.SY_DFF_AMT;
                        ddata.DF_TYPE_NAME = ddata.PLAN_TYPE_NAME;
                        ddata.DF_TYPE = ddata.PLAN_TYPE;

                        window_input.show();
                        var grid = window_input.window.down('grid#dfsq_grid');
                        grid.insertData(0, dfplan_data);
                        var sqGridStore = grid.getStore();
                        inputDfsqForm(sqGridStore);//向兑付申请主单填写内容
                    }
                });
            }, "json");
        }
    });
    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: zdhk_json_common[wf_id][node_code].items[WF_STATUS]
                }
            ],
            items: [
                initContentGrid(),
                initContentDetilGrid()
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {text: "兑付申请单据id", dataIndex: "DFSQ_ID", type: "string", hidden: true},
            {text: "申请日期", dataIndex: "APPLY_DATE", type: "string",width: 150},
            {text: "申请金额(元)", dataIndex: "APPLY_AMT", type: "float", width: 150},
            {text: "本金金额(元)", dataIndex: "BJ_AMT", type: "float", width: 150},
            {text: "利息金额(元)", dataIndex: "LX_AMT", type: "float", width: 150},
            {text: "兑付费金额(元)", dataIndex: "DFF_AMT", type: "float", width: 150},
           /* {text: "再融资债券金额(元)", dataIndex: "HB_AMT", type: "float", width: 150/!*, hidden: true*!/},*/
            {text: "备注", dataIndex: "REMARK", type: "string", width: 150}
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code,
                APPLY_DATE: Ext.Date.format(new Date(), 'Y-m-d'),
            },
            dataUrl: 'getHbfxMainGridData.action',
            checkBox: true,
            border: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: zdhk_json_common[wf_id][node_code].store['WF_STATUS'],
                    width: 110,
                    labelWidth: 30,
                    editable: false,
                    labelAlign: 'right',
                    displayField: "name",
                    valueField: "code",
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(zdhk_json_common[wf_id][node_code].items[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                },
                /*  {
                 xtype : "datefield",
                 name : "APPLY_DATE",
                 labelAlign : 'right',
                 fieldLabel : '申请日期',
                 allowBlank : false,
                 format : 'Y-m-d',
                 blankText : '请选择申请日期',
                 emptyText : '请选择申请日期',
                 value : today,
                 editable:false,
                 listeners: {
                 change: function (self, newValue) {
                 APPLY_DATE = Ext.util.Format.date(newValue, 'Y-m-d');
                 //刷新当前表格
                 self.up('grid').getStore().getProxy().extraParams[self.getName()] = APPLY_DATE;
                 reloadGrid();
                 }
                 }
                 } */
                {
                    fieldLabel: '年度',
                    xtype: 'combobox',
                    name: 'debt_year',
                    editable: false,
                    value: '',
                    //new Date().getFullYear(),
                    width: 165,
                    labelWidth: 60,//控件默认标签宽度
                    labelAlign: 'right',//控件默认标签对齐方式
                    displayField: 'name',
                    valueField: 'id',
                    store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2009'"}),
                    listeners: {
                        change: function (self, newValue) {
                            var store = self.up('grid').getStore();
                            //增加查询参数
                            store.getProxy().extraParams["SET_YEAR"] = newValue;
                            store.loadPage(1);
                        }
                    }
                }
            ],
            tbarHeight: 50,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['DFSQ_ID'] = record.get('DFSQ_ID');
                    DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                }
            }
        });
    }
    /**
     * 初始化明细表格
     */
    function initContentDetilGrid(callback) {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {text: "ID", dataIndex: "DFSQ_DTL_ID", type: "string", hidden: true},
            {text: "兑付计划ID", dataIndex: "DF_PLAN_ID", type: "string", hidden: true},
            {text: "债券id", dataIndex: "ZQ_ID", type: "string", hidden: true},
            {text: "兑付申请编码", dataIndex: "DFSQ_DTL_NO", width: 150, type: "string", hidden: true},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 350,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE.replace(/00$/, "");
                     return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE.replace(/00$/, "");
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "计划兑付日", dataIndex: "DF_END_DATE", width: 150, type: "string"},//计划表
            {text: "兑付类型", dataIndex: "DF_TYPE_NAME", width: 150, type: "string"},
            {text: "再融资债券名称", dataIndex: "HBZQ_NAME", type: "string",width: 150,
                renderer: function (data, cell, record) {
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('HBZQ_ID');
                    paramValues[1]=AD_CODE.replace(/00$/, "");
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }

            },
            {text: "债券编码", dataIndex: "ZQ_CODE",width: 150, type: "string"},
            {text: "债券简称", dataIndex: "ZQ_JC", width: 150, type: "string"},
            {text: "债券期限", dataIndex: "ZQQX_NAME", width: 150, type: "string"},
            {text: "债券类型", dataIndex: "ZQLB_NAME", width: 150, type: "string"},
            {text: "支付总金额(元)", dataIndex: "TOTAL_PAY_AMT", width: 160, type: "float"},
            {text: "兑付金额(元)", dataIndex: "DF_AMT", width: 160, type: "float"},
            {text: "兑付费金额(元)", dataIndex: "DFF_AMT", width: 160, type: "float"},
            {text: "支付日期", dataIndex: "PAY_DATE", width: 160, type: "string"},
            {text: "再融资债券id", dataIndex: "HBZQ_ID", type: "string",width: 150, hidden: true},
            {text: "票面利率", dataIndex: "PM_RATE", width: 150, type: "float", hidden: true},
            {text: "兑付手续费率（‰）", dataIndex: "DFSXF_RATE", width: 150, type: "float", hidden: true},
            {text: "实际发行额(元)", dataIndex: "FX_AMT", width: 150, type: "float", hidden: true},
            {text: "发行日", dataIndex: "FX_START_DATE", width: 150, type: "string", hidden: true},
            {text: "招标日期", dataIndex: "ZB_DATE", width: 150, type: "string", hidden: true},
            {text: "到期兑付日", dataIndex: "DQDF_DATE", width: 150, type: "string", hidden: true}, //到期兑付日
            {text: "起息日", dataIndex: "QX_DATE", width: 150, type: "string", hidden: true},
            {text: "付息周期", dataIndex: "FXZQ_NAME", width: 150, type: "string", hidden: true},
            {text: "兑付类型编码", dataIndex: "DF_TYPE", width: 150, type: "string", hidden: true},
            {text: "备注", dataIndex: "REMARK", width: 150, type: "string"}
        ];
        var config = {
            itemId: 'contentGrid_detail',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            autoLoad: false,
            border: false,
            height: '50%',
            pageConfig: {
                enablePage: false
            },
            dataUrl: 'getHbfxDtlGridData.action'
        };
        if (zdhk_json_common[wf_id][node_code].item_content_detailgrid_config) {
            config = $.extend(false, config, zdhk_json_common[wf_id][node_code].item_content_detailgrid_config);
        }
        var grid = DSYGrid.createGrid(config);
        if (callback) {
            callback(grid);
        }
        return grid;
    }
    /**
     * 初始化兑付计划选择弹出窗口
     */
    function initWindow_select(params) {
        return Ext.create('Ext.window.Window', {
            title: '选择还本付息计划', //    窗口标题
            width: document.body.clientWidth * 0.95, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_select', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWindow_select_grid(params)],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        //获取表格选中数据
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length < 1) {
                            Ext.MessageBox.alert('提示', '请至少选择一条记录后进行操作');
                            return;
                        }
                        var record_data=new Array();
                        var record_lx=new Array();

                        for(var i=0;i<records.length;i++){
                            if(records[i].data.PLAN_TYPE=='1'){
                                record_lx.push(records[i].data);
                            }else{
                                record_data.push(records[i].data);
                            }
                        }
                        var sqGridStore = window_input.window.down('grid').getStore();


                        for(var hh=0;hh<record_lx.length;hh++){
                            Ext.Ajax.request({
                                method : 'POST',
                                url : "/getId.action",
                                async : false,
                                success : function(response, options) {
//    	    	                        			// 获取返回的JSON，并根据gridid，获取表头配置信息
//    	    	                        			var respText = Ext.util.JSON.decode(response.responseText);
//    	    	                        			console.log(respText);
                                    //var REPORT =  eval(respText.REPORT)[0];
                                    // 刷新表格
                                    var respText = Ext.util.JSON.decode(response.responseText);
                                    var df_sq_id = respText.data[0];
                                    var record_data = record_lx[hh];
                                    record_data.DFSQ_DTL_ID = df_sq_id;   //by gy
                                    record_data.DF_AMT = record_lx[hh].SY_AMT;   //by gy
                                    record_data.DFF_AMT = 0;
                                    //record_data.DFF_AMT = records[i].get('SY_DFF_AMT');
                                    record_data.DF_TYPE_NAME = record_lx[hh].PLAN_TYPE_NAME;
                                    record_data.DF_TYPE = record_lx[hh].PLAN_TYPE;
                                    record_data.BOOLEAN_IS_FIRST = '1';
                                    //record_data.TOTAL_PAY_AMT = records[i].get('SY_DFF_AMT') + records[i].get('SY_AMT');
                                    var df_plan_id = record_lx[hh].DF_PLAN_ID;
                                    ALL_DF_MONEY[df_plan_id] = record_data.DF_AMT;
                                    ALL_DFF_MONEY[df_plan_id] = record_data.DFF_AMT;
                                    //var record = sqGridStore.findRecord('DF_PLAN_ID', records[i].get('DF_PLAN_ID'), 0, false, true, true);
                                    //window_input.window.down('grid').insertData(null, record_data);
                                },
                                failure : function(response, options) {

                                }
                            });
                        }
                        var condition="";
                        if(is_fix){
                            condition="?FLAG=update";
                        }
                        //发送请求获取新增数据id  ALL_DF_MONEY
                        $.post('/getCapitalByZrzzq.action'+condition, {size: records.length,
                            detailList:Ext.util.JSON.encode(record_data)}, function (data) {
                            if (!data.success) {
                                Ext.MessageBox.alert('提示', '获取ID' + '失败！' + data.message);
                                return;
                            }
                            for (var i=0;i<records.length;i++) {
                                //利息
                                if(records[i].get('PLAN_TYPE')=='1') {
                                    var record_data = records[i].getData();
                                    //record_data.DFSQ_DTL_ID = data.data[i];   //by gy
                                    //record_data.DF_AMT = records[i].get('SY_AMT');   //by gy
                                    //record_data.DFF_AMT = 0;
                                    record_data.DFF_AMT = records[i].get('SY_DFF_AMT');
                                    record_data.DF_TYPE_NAME = records[i].get('PLAN_TYPE_NAME');
                                    record_data.DF_TYPE = records[i].get('PLAN_TYPE');
                                    record_data.BOOLEAN_IS_FIRST = '1';
                                    //record_data.TOTAL_PAY_AMT = records[i].get('SY_DFF_AMT') + records[i].get('SY_AMT');
                                    var df_plan_id = records[i].get('DF_PLAN_ID');
                                    ALL_DF_MONEY[df_plan_id] = record_data.DF_AMT;
                                    ALL_DFF_MONEY[df_plan_id] = record_data.DFF_AMT;
                                    //var record = sqGridStore.findRecord('DF_PLAN_ID', records[i].get('DF_PLAN_ID'), 0, false, true, true);
                                    window_input.window.down('grid').insertData(null, record_data);
                                }else if(records[i].get('PLAN_TYPE')=='0') {
                                    // 再融资债券名称   再融资债券ID HBZQ_TYPE

                                    //本金操作

                                    var Object2 = new Object();
                                    for (var k = 0; k < data.dataList.length; k++) {
                                        var newrecord = data.dataList[k];
                                        if (newrecord.ZQ_ID == records[i].getData().ZQ_ID) {
                                            if (records[i].get('PLAN_TYPE') == '1') {
                                                continue;
                                            } else {
                                                var record_data$1 = new Object();
                                                for (var h2 in records[i].getData()) {
                                                    if (h2 != 'id') {
                                                        record_data$1[h2] = records[i].getData()[h2];
                                                    }
                                                }
                                                if (newrecord.HBZQ_ID != null && newrecord.HBZQ_ID != undefined && newrecord.HBZQ_ID != "") {
                                                    //var record_data$1=records[i].getData();
                                                    record_data$1.DFF_AMT = records[i].get('SY_DFF_AMT');
                                                    record_data$1.DF_AMT = newrecord.DF_AMT;

                                                    record_data$1.DF_TYPE_NAME = records[i].get('PLAN_TYPE_NAME');
                                                    record_data$1.DF_TYPE = records[i].get('PLAN_TYPE');
                                                    record_data$1.BOOLEAN_IS_FIRST = '1';
                                                    record_data$1.HBZQ_ID = newrecord.HBZQ_ID;
                                                    record_data$1.HBZQ_TYPE = newrecord.ZQLB_CODE;
                                                    record_data$1.ZJLY_ID = newrecord.CHZJLY_ID;
                                                    record_data$1.DFSQ_DTL_ID = newrecord.DFSQ_DTL_ID;
                                                    record_data$1.HBZQ_NAME = newrecord.HBZQ_NAME;
                                                    record_data$1.HB_AMT_SY = newrecord.HB_AMT_SY;
                                                    //record_data$1.SY_AMT=newrecord.SY_AMT;

                                                    Object2[newrecord.ZQ_ID] = record_data$1;
                                                    var Store_Grid=window_input.window.down('grid').getStore();
                                                    if(Store_Grid.getCount()<=0){
                                                        window_input.window.down('grid').insertData(null, record_data$1);
                                                    }else{//处理表格中已有数据与新添加数据存在重复的问题
                                                        var is_insert=true;
                                                        for(var op=0;op<Store_Grid.getCount();op++){
                                                           var record = Store_Grid.getAt(op);
                                                            //DF_PLAN_ID||ZQ_ID||HBZQ_ID
                                                           var HBZQ_ID= record.get("HBZQ_ID");
                                                           if(HBZQ_ID==null||HBZQ_ID==undefined){
                                                               HBZQ_ID="";
                                                           }
                                                           var ZQ_ID  = record.get("ZQ_ID");
                                                           if(ZQ_ID==null||ZQ_ID==undefined){
                                                               ZQ_ID="";
                                                           }
                                                           var DF_PLAN_ID=record.get("DF_PLAN_ID");
                                                           if(DF_PLAN_ID==null||DF_PLAN_ID==undefined){
                                                               DF_PLAN_ID="";
                                                           }
                                                           var uuid=HBZQ_ID+ZQ_ID+DF_PLAN_ID;
                                                           var uuid_hbzq= record_data$1.HBZQ_ID+record_data$1.ZQ_ID+record_data$1.DF_PLAN_ID;
                                                           if(uuid==uuid_hbzq){
                                                               is_insert=false;
                                                           }
                                                        }
                                                        if(is_insert){
                                                            window_input.window.down('grid').insertData(null, record_data$1);

                                                        }
                                                    }

                                                } else {
                                                    record_data$1.DFF_AMT = records[i].get('SY_DFF_AMT');
                                                    record_data$1.DF_AMT=newrecord.DF_AMT;
                                                    for (var ck in Object2) {
                                                        if (newrecord.ZQ_ID == Object2[ck].ZQ_ID) {
                                                            if (Object2[ck].HBZQ_ID != null && Object2[ck].HBZQ_ID != undefined && Object2[ck].HBZQ_ID != "") {
                                                               // record_data$1.DF_AMT = record_data$1.PLAN_AMT - Object2[ck].DF_AMT;
                                                                //record_data$1.SY_AMT=  record_data$1.SY_AMT-Object2[ck].DF_AMT;
                                                            }
                                                        }
                                                    }
                                                    record_data$1.DF_TYPE_NAME = records[i].get('PLAN_TYPE_NAME');
                                                    record_data$1.DF_TYPE = records[i].get('PLAN_TYPE');
                                                    record_data$1.BOOLEAN_IS_FIRST = '1';
                                                    record_data$1.HBZQ_ID = newrecord.HBZQ_ID;
                                                    record_data$1.HBZQ_TYPE = newrecord.ZQLB_CODE;
                                                    record_data$1.ZJLY_ID = newrecord.CHZJLY_ID;
                                                    record_data$1.DFSQ_DTL_ID = newrecord.DFSQ_DTL_ID;
                                                    record_data$1.HBZQ_NAME = newrecord.HBZQ_NAME;
                                                    record_data$1.HB_AMT_SY = newrecord.HB_AMT_SY;
                                                   // record_data$1.SY_AMT=record_data$1.SY_AMT;
                                                        //-record_data$1.DF_AMT;
                                                    window_input.window.down('grid').insertData(null, record_data$1);
                                                }

                                            }
                                        }
                                    }
                                }
                                }
//                                    for(var kk in Object2){
//                                        if(Object2[kk].DF_AMT!=null&&Object2[kk].DF_AMT!=undefined&&Object2[kk].DF_AMT>0){
//                                            window_input.window.down('grid').insertData(null, Object2[kk]);
//                                        }
//                                    }




                            inputDfsqForm(sqGridStore);//向兑付申请主单填写内容
                            //弹出填报页面，并写入债券信息
                            btn.up('window').close();
                        }, "json");
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
    }
    /**
     * 初始化兑付计划选择
     */
    function initWindow_select_grid(params) {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},
            {text: "兑付计划id", dataIndex: "DF_PLAN_ID", type: "string", hidden: true},
            {text: "债券id", dataIndex: "ZQ_ID", type: "string", hidden: true},
            {text: "到期日期", dataIndex: "DF_END_DATE", type: "string", width: 150},
            {text: "应还款日期", dataIndex: "DQ_DATE", type: "string", width: 150},
            {text: "兑付类型", dataIndex: "PLAN_TYPE_NAME", type: "string", width: 100},
            {text: "剩余应还款", dataIndex: "SY_AMT", type: "float", width: 150},
            {text: "剩余应还兑付费", dataIndex: "SY_DFF_AMT", type: "float", width: 150},
            {text: "债券代码", dataIndex: "ZQ_CODE", type: "string", width: 150},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 350,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "债券简称", dataIndex: "ZQ_JC", type: "string", width: 150},
            {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 150},
            {text: "债券类型code", dataIndex:"ZQLB_CODE", width: 150, type:'string',hidden:true},
            {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string", width: 150},
            {text: "兑付计划金额", dataIndex: "PLAN_AMT", type: "float", width: 150},
            {text: "兑付费金额", dataIndex: "DFF_AMT", type: "float", width: 150},
            {text: "利率", dataIndex: "PM_RATE", type: "float", hidden: true},
            {text: "兑付手续费率（‰）", dataIndex: "DFSXF_RATE", type: "float", hidden: true},
            {text: "实际发行额", dataIndex: "FX_AMT", type: "float", hidden: true},
            {text: "发行日", dataIndex: "FX_START_DATE", type: "string", hidden: true},
            {text: "招标日期", dataIndex: "ZB_DATE", type: "string", hidden: true},
            {text: "起息日", dataIndex: "QX_DATE", type: "string", hidden: true},
            {text: "到期兑付日", dataIndex: "DQDF_DATE", type: "string", hidden: true},
            {text: "付息周期", dataIndex: "FXZQ_NAME", type: "string", hidden: true},
            {text: "兑付计划编码", dataIndex: "PLAN_TYPE", type: "string", hidden: true},
            {text: "偿还资金来源ID", dataIndex: "ZJLY_ID", type: "string", hidden: true}
        ];
        return DSYGrid.createGrid({
            itemId: 'grid_select',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            border: false,
            height: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            tbar: [
                {
                    xtype: "combobox",
                    name: "HKJH_YEAR",
                    store: DebtEleStore(json_debt_year),
                    displayField: "name",
                    valueField: "id",
                    value: new Date().getFullYear(),
                    fieldLabel: '到期年月',
                    editable: false, //禁用编辑
                    labelWidth: 70,
                    width: 175
                },
                {
                    xtype: "combobox",
                    name: "HKJH_MO",
                    store: DebtEleStore(json_debt_yf_nd),
                    displayField: "name",
                    valueField: "id",
                    value: lpad(1 + new Date().getUTCMonth(), 2),
                    editable: false, //禁用编辑
                    width: 85
                },
                /*新增债券类型，债券批次查询条件开始*/
                {
                    xtype: 'treecombobox',
                    name: 'ZQLB_ID',
                    labelAlign: 'right',
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券类型',
                    editable: false, //禁用编辑
                    labelWidth: 60,
                    width: 180
                },
                {
                    xtype: 'combobox',
                    name: 'ZQPC_ID',
                    labelAlign: 'right',
                    store: DebtEleStoreDB('DEBT_ZQPC'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券批次',
                    editable: false, //禁用编辑
                    labelWidth: 60,
                    width: 195
                },
                /*新增债券类型，债券批次查询条件结束*/
                {
                    xtype: "textfield",
                    name: "ZQMC",
                    labelAlign: 'right',
                    fieldLabel: '模糊查询',
                    labelWidth: 60,
                    width: 220,
                    emptyText: '债券名称/简称/债券编码',
                    editable: true,
                    enableKeyEvents: true,
                    listeners: {
                        keypress: function (self, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                var DQ_YEAR = Ext.ComponentQuery.query('combobox[name="HKJH_YEAR"]')[0].value;
                                var DQ_MO = Ext.ComponentQuery.query('combobox[name="HKJH_MO"]')[0].value;
                                var ZQMC = Ext.ComponentQuery.query('textfield[name="ZQMC"]')[0].value;
                                var SELECT_YQ = Ext.ComponentQuery.query('checkbox[name="select_yq"]')[0].value;
                                var IS_KKDF = Ext.ComponentQuery.query('checkbox[name="is_kkdf"]')[0].value;
                                var ZQLB_ID = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].value;
                                var ZQPC_ID = Ext.ComponentQuery.query('combobox[name="ZQPC_ID"]')[0].value;
                                if (SELECT_YQ) {
                                    SELECT_YQ = 'Y';
                                } else {
                                    SELECT_YQ = 'N';
                                }
		                        if (IS_KKDF) {
		                            IS_KKDF = 'Y';
		                        } else {
		                            IS_KKDF = 'N';
		                        }
                                //刷新表格数据
                                var store = self.up('window').down('grid').getStore();
                                store.getProxy().extraParams = {
                                    DQ_YEAR: DQ_YEAR,
                                    DQ_MO: DQ_MO,
                                    SELECT_YQ: SELECT_YQ,
                            		IS_KKDF:IS_KKDF,
                                    ZQMC: ZQMC,
                                    ZQLB_ID: ZQLB_ID,
                                    ZQPC_ID: ZQPC_ID
                                };
                                store.loadPage(1);
                            }
                        }
                    }
                },
                {
                    xtype: "checkbox",
                    name: "select_yq",
                    labelAlign: 'right',
                    labelSeparator: '',
                    fieldLabel: '仅显示逾期',
                    labelWidth: 65,
                    hidden: true
                },
                {
                    xtype: "checkbox",
                    name: "is_kkdf",
                    labelAlign: 'right',
                    labelSeparator: '',
                    fieldLabel: '仅库款垫付',
                    labelWidth: 65
                },
                {
                    xtype: 'button',
                    style: {marginRight: '20px'},
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        //var DQTS = Ext.ComponentQuery.query('textfield[name="dqts"]')[0].value;
                        var DQ_YEAR = Ext.ComponentQuery.query('combobox[name="HKJH_YEAR"]')[0].value;
                        var DQ_MO = Ext.ComponentQuery.query('combobox[name="HKJH_MO"]')[0].value;
                        var ZQMC = Ext.ComponentQuery.query('textfield[name="ZQMC"]')[0].value;
                        var ZQLB_ID = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].value;
                        var ZQPC_ID = Ext.ComponentQuery.query('combobox[name="ZQPC_ID"]')[0].value;
                        var SELECT_YQ = Ext.ComponentQuery.query('checkbox[name="select_yq"]')[0].value;
                        var IS_KKDF = Ext.ComponentQuery.query('checkbox[name="is_kkdf"]')[0].value;
                        if (SELECT_YQ) {
                            SELECT_YQ = 'Y';
                        } else {
                            SELECT_YQ = 'N';
                        }
                        if (IS_KKDF) {
                            IS_KKDF = 'Y';
                        } else {
                            IS_KKDF = 'N';
                        }
                        //刷新表格数据
                        var store = btn.up('window').down('grid').getStore();
                        store.getProxy().extraParams = {
                            DQ_YEAR: DQ_YEAR,
                            DQ_MO: DQ_MO,
                            SELECT_YQ: SELECT_YQ,
                            IS_KKDF:IS_KKDF,
                            ZQMC: ZQMC,
                            ZQLB_ID: ZQLB_ID,
                            ZQPC_ID: ZQPC_ID
                        };
                        store.loadPage(1);
                    }
                }
            ],
            params: {
                DQ_YEAR: new Date().getFullYear(),
                DQ_MO: lpad(1 + new Date().getUTCMonth(), 2),
                ZQLB_ID: "",
                ZQPC_ID: "",
                SELECT_YQ: 0,
                IS_KKDF: 0
            },
            dataUrl: 'getDfjhGridData.action'
        });
    }
    //取当前月时 长度为1时左侧补0
    function lpad(num, n) {
        return (Array(n).join(0) + num).slice(-n);
    }
    /**
     * 初始化兑付申请弹出窗口
     */
    function initWindow_input() {
        var config = {
            disabled: false,
            gridId: ''
        };
        return Ext.create('Ext.window.Window', {
            title: '兑付申请', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.9, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_input', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: {
                xtype: 'tabpanel',
                border: false,
                items: [
                    {
                        title: '还本付息明细',
                        layout: 'fit',
                        items: [initWindow_input_contentForm()]
                    },
                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        layout: 'fit',
                        items: [
                            {
                                xtype: 'panel',
                                layout: 'fit',
                                itemId: 'window_save_zcxx_file_panel',
                                items: [initWindow_input_tab_upload(config)]
                            }
                        ],
                        listeners: {
                            beforeactivate: function () {
                                // 检验是否主表是否有数据
                                var grid = DSYGrid.getGrid('dfsq_grid');
                                if (grid.getStore().getCount() <= 0) {
                                    Ext.MessageBox.alert('提示', '还本付息明细表格无数据！');
                                    return false;
                                }
                                // 获取选中数据
                                var record = grid.getCurrentRecord();
                                //如果当前无选中行，默认选中第一条数据
                                if (!record) {
                                    $(grid.getView().getRow(0)).parents('table[data-recordindex=0]').addClass('x-grid-item-click');
                                    record = grid.getStore().getAt(0);
                                    Ext.toast({
                                        html: "还本付息明细中明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                }
                                var panel = Ext.ComponentQuery.query('panel#window_save_zcxx_file_panel')[0];
                                panel.removeAll(true);
                                panel.add(initWindow_input_tab_upload({
                                    disabled: false,
                                    gridId: record.get('DFSQ_DTL_ID')
                                }));
                            }
                        }
                    }
                ]
            },
            buttons: [
                {
                    xtype: 'button',
                    text: '新增',
                    width: 80,
                    handler: function (btn) {
                        //弹出到期债务窗口
                        initWindow_select().show();
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'delete_editGrid',
                    width: 80,
                    disabled: true,
                    style: {marginRight: '20px'},
                    handler: function (btn) {
                        var grid = btn.up('window').down('grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        grid.getPlugin('dfsq_grid_plugin_cell').cancelEdit();
                        var is=sm.getSelection();
                        store.remove(sm.getSelection());
                        var is_continue=true;
                        for(var i=0;i<store.getCount();i++){
                            if(is_continue){
                                var record=store.getAt(i);
                                if(is[0]&&is[0].get("BOOLEAN_IS_FIRST")=='0') {
                                    if (is[0] && record.get("DF_PLAN_ID") == is[0].get("DF_PLAN_ID")) {
                                        if (record.get("BOOLEAN_IS_FIRST") && record.get("BOOLEAN_IS_FIRST") == '0') {
                                            record.set("DF_AMT_CHECK", record.get("DF_AMT_CHECK") + is[0].get("DF_AMT_CHECK"));
                                            record.set("DFF_AMT_CHECK", record.get("DFF_AMT_CHECK") + is[0].get("DFF_AMT_CHECK"));
                                            is_continue = false;
                                        }
                                    }
                                }
                            }
                        }
                        inputDfsqForm(store);//向兑付申请主单填写内容
                        if (store.getCount() > 0) {
                            sm.select(0);
                        }
                    }
                },
                {
                    text: '保存',
                    handler: function (btn) {
                        var form = btn.up('window').down('form');
                        var grid = form.down('grid');
                        var celledit = grid.getPlugin('dfsq_grid_plugin_cell');
                        //完成编辑
                        celledit.completeEdit();
                        if (window.flag_validateedit && !window.flag_validateedit.isHidden()) {
                            return false;//如果校验未通过
                        }
                        //获取单据明细数组
                        var recordArray = [];
                        if (grid.getStore().getCount() <= 0) {
                            Ext.Msg.alert('提示', '请填写兑付申请明细记录！');
                            return false;
                        }
                        var ALL_DF_MONEY=new Object();
                        var df_check=new Object();
                        var dff_check=new Object();
                        var hb_df=new Object();
                        var hbfx_all_money=new Object();
                        var hbfx_zq_name=new Object();
                        var message_error = null;
                        var hbfx_all2_money=new Object();
                        grid.getStore().each(function (record) {
                        	if(record.get("IS_KKDF") == '1' && record.get("ZJLY_ID").substring(0,2) != '03') {
                        		message_error = '利用库款垫付偿还的债券必须使用再融资债券兑付！';
                                return false;
                        	}
                            if(record.get("HBZQ_NAME")==null||record.get("HBZQ_NAME")==undefined||record.get("HBZQ_NAME")==""){
                                record.set("HBZQ_TYPE",null);
                                record.set("HBZQ_ID",null);

                            }
                            if (!record.get('ZJLY_ID') || record.get('ZJLY_ID') == null) {
                                message_error = '偿还资金来源不能为空！';
                                return false;
                            }
                            //校验还本来源为0303或者0304时，必须有一笔再融资债券
                            if(record.get("ZJLY_ID")!=null&&record.get("ZJLY_ID")!=undefined){
                                if(record.get("ZJLY_ID")=='0303'){

                                    if(record.get("HBZQ_TYPE")!=null&&record.get("HBZQ_TYPE")!=undefined){
                                        var HBZQ_TYPE=record.get("HBZQ_TYPE").substring(0,2);
                                        if(HBZQ_TYPE!='01'){
                                            message_error = '偿还资金来源为再融资一般债券时，必须选择债券类型为一般的再融资债券！';
                                            return false;
                                        }
                                    }
                                } else if(record.get("ZJLY_ID")=='0304'){
                                    if(record.get("HBZQ_TYPE")!=null&&record.get("HBZQ_TYPE")!=undefined){
                                        var HBZQ_TYPE=record.get("HBZQ_TYPE").substring(0,2);
                                        if(HBZQ_TYPE!='02'){
                                            message_error = '偿还资金来源为再融资专项债券时，必须选择债券类型为专项的再融资债券！';
                                            return false;
                                        }
                                    }
                                }
                            }
                            if(record.get("HBZQ_ID")!=null&&record.get("HBZQ_ID")!=undefined&&record.get("HBZQ_ID")!=""){
                                if(record.get("HBZQ_TYPE").substring(0,2)=='01'){
                                    if(record.get("ZJLY_ID")!='0303'){
                                        message_error = '当选择的再融资债券类型为一般时，该条录入信息偿还资金来源必须选择再融资一般债券！';
                                        return false;
                                    }
                                }else if(record.get("HBZQ_TYPE").substring(0,2)=='02'){
                                    if(record.get("ZJLY_ID")!='0304'){
                                        message_error = '当选择的再融资债券类型为专项时，该条录入信息偿还资金来源必须选择再融资专项债券！';
                                        return false;
                                    }
                                }

                            }
//                            if (record.get('DFF_AMT') > record.get('SY_DFF_AMT')) {
//                                message_error = '输入金额超过剩余应偿还兑付费金额！';
//                                return false;
//                            }
//                            if (record.get('DF_AMT') > record.get('SY_AMT')) {
//                                message_error = '输入金额超过剩余应偿还金额！';
//                                return false;
//                            }
                            if (record.get('DF_AMT') != null && record.get('DF_AMT') < 0) {
                                message_error = '输入兑付金额应大于0！';
                                return false;
                            }
//                            if (record.get('DFF_AMT') != null && record.get('DFF_AMT') < 0) {
//                                message_error = '输入兑付费金额应大于0！';
//                                return false;
//                            }

                            if (record.get('REMARK').length>100) {
                                message_error = '备注过长，不能多于100字！';
                                return false;
                            }
                            /*if (!record.get('PAY_DATE') || record.get('PAY_DATE') == null) {
                             message_error = '支付日期不能为空！';
                             return false;
                             }*/

                            if (record.get('TOTAL_PAY_AMT') == null || !record.get('TOTAL_PAY_AMT') || record.get('TOTAL_PAY_AMT') <= 0) {
                                message_error = '请填写有效的偿还金额！';
                                return false;
                            }
//                            if (record.get('DF_AMT') > record.get('SY_AMT') || record.get('DFF_AMT') > record.get('SY_DFF_AMT')) {
//                                message_error = '录入金额超过最大偿还金额！';
//                                return false;
//                            }

//                            if(df_check[record.get('DF_PLAN_ID')]!=undefined&&df_check[record.get('DF_PLAN_ID')]!=null&&df_check[record.get('DF_PLAN_ID')]>=0){
//                                df_check[record.get('DF_PLAN_ID')]+=record.get('DF_AMT');
//                            }else{
//                                df_check[record.get('DF_PLAN_ID')]=record.get('DF_AMT');
//                                hbfx_zq_name[record.get('DF_PLAN_ID')]=record.get('ZQ_JC');
//                            }
//                            if(ALL_DF_MONEY[record.get('DF_PLAN_ID')]==null||ALL_DF_MONEY[record.get('DF_PLAN_ID')]==undefined||ALL_DF_MONEY[record.get('DF_PLAN_ID')]==""){
//                                if(!is_fix){
//                                    ALL_DF_MONEY[record.get('DF_PLAN_ID')]=record.get("SY_AMT");
//                                }else{    //修改
//                                    if(record.get("BOOLEAN_IS_FIRST")=='0'){
//                                        ALL_DF_MONEY[record.get('DF_PLAN_ID')]=record.get("PAY_AMT_CHECK");
//                                    }else if(record.get("BOOLEAN_IS_FIRST")=='1'){
//                                        ALL_DF_MONEY[record.get('DF_PLAN_ID')]=record.get("SY_AMT");
//                                    }
//                                }
//                            }else{
//                                if(!is_fix){
//                                    ALL_DF_MONEY[record.get('DF_PLAN_ID')]=record.get("SY_AMT");
//                                }else{   //修改
//                                    if(record.get("BOOLEAN_IS_FIRST")=='1'){
//                                        ALL_DF_MONEY[record.get('DF_PLAN_ID')]=record.get("SY_AMT");
//                                    }else if(record.get("BOOLEAN_IS_FIRST")=='0'){
//                                        ALL_DF_MONEY[record.get('DF_PLAN_ID')]=record.get("PAY_AMT_CHECK");
//                                    }
//                                }
//                            }
//                            if(ALL_DFF_MONEY[record.get('DF_PLAN_ID')]==null||ALL_DFF_MONEY[record.get('DF_PLAN_ID')]==undefined||ALL_DFF_MONEY[record.get('DF_PLAN_ID')]==""){
//                                if(!is_fix){
//                                    ALL_DFF_MONEY[record.get('DF_PLAN_ID')]=record.get("SY_DFF_AMT");
//
//                                }else{                                //修改
//                                    ALL_DFF_MONEY[record.get('DF_PLAN_ID')]=record.get("SY_DFF_AMT");
//                                }
//                            }else{
//                                if(!is_fix){
//                                    ALL_DFF_MONEY[record.get('DF_PLAN_ID')]=record.get("SY_DFF_AMT");
//                                //修改
//                                }else{
//                                    ALL_DFF_MONEY[record.get('DF_PLAN_ID')]+=record.get("SY_DFF_AMT");
//
//                                }
//
//                            }


//                            if(hbfx_zq_name[record.get('DF_PLAN_ID')]!=undefined&&hbfx_zq_name[record.get('DF_PLAN_ID')]!=null&&hbfx_zq_name[record.get('DF_PLAN_ID')]!=""){
//                            }else{
//                                hbfx_zq_name[record.get('DF_PLAN_ID')]=record.get('ZQ_NAME');
//                            }
//
//                            if(dff_check[record.get('DF_PLAN_ID')]!=undefined&&dff_check[record.get('DF_PLAN_ID')]!=null&&dff_check[record.get('DF_PLAN_ID')]>=0){
//                                dff_check[record.get('DF_PLAN_ID')]+=record.get('DFF_AMT');
//                            }else{
//                                dff_check[record.get('DF_PLAN_ID')]=record.get('DFF_AMT');
//                            }
                            /* record.data.PAY_DATE = dsyDateFormat(record.get('PAY_DATE'));*/

//                            if(record.get('HBZQ_ID')!=null&&record.get('HBZQ_ID')!=""&&record.get('HBZQ_ID')!=undefined){
//                                hbfx_all_money[record.get('HBZQ_ID')]=record.get("HB_AMT_SY");
//                                hbfx_all2_money[record.get('HBZQ_ID')]=record.get("HB_AMT");
//                                if(hb_df[record.get('HBZQ_ID')]!=undefined&&hb_df[record.get('HBZQ_ID')]!=null&&hb_df[record.get('HBZQ_ID')]>=0){
//                                    hb_df[record.get('HBZQ_ID')]+=record.get('DF_AMT');
//                                }else{
//                                    hb_df[record.get('HBZQ_ID')]=record.get('DF_AMT');
//                                }
//
//                            }
//                            hbfx_zq_name[record.get('HBZQ_ID')+"HB"]=record.get('ZQ_NAME');

                            recordArray.push(record.getData());
                        });

                        if (message_error != null && message_error != '') {
                            Ext.Msg.alert('提示', message_error);
                            return false;
                        }
//                        for(var i in df_check){
//                            var alldf=ALL_DF_MONEY[i];
//
//                            if(alldf!=null&&alldf!=undefined&&alldf>=0){
//                                if(Math.abs(df_check[i]-alldf)<0.01){
//                                }else{
//                                    var zq_jc=hbfx_zq_name[i];
//                                    var csz=df_check[i]-alldf;
//                                    var tip="";
//                                    if(csz>0){
//                                        tip="超出金额:"+Math.abs(csz)+"元";
//                                    }else {
//                                        tip="还需金额:"+Math.abs(csz)+"元";
//                                    }
//                                    message_error ="债券名称为"+ zq_jc+'的债券的兑付金额必须全部兑换，不能超额或少额！'+"("+tip+")";
//                                }
//                            }
//                        }
//                       兑付费的校验
//                        for(var j in dff_check){
//                            var alldff=ALL_DFF_MONEY[j];
//                            if(alldff!=null&&alldff!=undefined&&alldff>=0){
//                                if(Math.abs(dff_check[j]-alldff)<0.01){
//
//                                }else{
//                                    var zq_jc=hbfx_zq_name[j];
//                                    message_error = "债券名称为"+zq_jc+'的债券的兑付费金额必须全部兑换，不能超额或少额！';
//                                }
//                            }
//
//                        }
//                        for(var k in hb_df){
//                            var sydf=hbfx_all_money[k];
//                            if(YLU_TEMP[k]!=null&&YLU_TEMP[k]!=undefined){
//                                 sydf+=YLU_TEMP[k];
//                            }
//                            if(sydf!=null&&sydf!=undefined&&sydf>=0){
//                                if(hb_df[k]>sydf){
//                                    var zq_jc=hbfx_zq_name[k+"HB"];
//                                    message_error = "债券名称为"+zq_jc+'的债券选择的再融资债券使用超额！';
//                                }
//                            }
//                        }
                        var parameters = {
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            ad_code: AD_CODE,
                            detailList: Ext.util.JSON.encode(recordArray)
                        };
                        if (button_name == '修改') {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            parameters.DFSQ_ID = records[0].get('DFSQ_ID');
                        }
                        if (form.isValid()) {
                            //保存表单数据及明细数据
                            form.submit({
                                //设置表单提交的url
                                url: '/saveDfsqGrid.action',
                                params: parameters,
                                success: function (form, action) {
                                    //关闭弹出框
                                    btn.up("window").close();
                                    //提示保存成功
                                    Ext.toast({
                                        html: '<div style="text-align: center;">保存成功!</div>',
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    reloadGrid();
                                },
                                failure: function (form, action) {
                                    var result = Ext.util.JSON.decode(action.response.responseText);
                                    Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                                }
                            });
                        }
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
    }
    /**
     * 初始化兑付申请弹出窗口中页签panel的附件页签
     */
    function initWindow_input_tab_upload(config) {
        //console.log(config.gridId);
        var grid = UploadPanel.createGrid({
            busiType: 'ET204',//业务类型
            busiId: config.gridId,//业务ID
            editable: !config.disabled,//是否可以修改附件内容
            gridConfig: {
                itemId: 'window_save_zcxx_tab_upload_grid'
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
     * 初始化债券转贷表单
     */
    function initWindow_input_contentForm() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'vbox',
            border: false,
            defaults: {
                width: '100%',
                margin: '5 5 5 5'
            },
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .33,
                        //width: 280,
//                            disabled:true,
                        readOnly: true,
                        labelWidth: 120//控件默认标签宽度
                    },
                    items: [
                        {
                            fieldLabel: '申请日期',
                            xtype: "datefield",
                            name: "APPLY_DATE",
                            value: today,
                            emptyText: '请填写申请日期',
                            format: 'Y-m-d',
                            editable: false,
                            readOnly: false
                        },
                        {
                            fieldLabel: '申请金额(元)',
                            xtype: "numberFieldFormat",
                            name: "APPLY_AMT",
                            emptyText: '0.00',
                            hideTrigger: true,
                            fieldCls: 'form-unedit-number'
                        },
                        {
                            fieldLabel: '本金金额(元)',
                            xtype: "numberFieldFormat",
                            name: "BJ_AMT",
                            emptyText: '0.00',
                            hideTrigger: true,
                            fieldCls: 'form-unedit-number'
                        },
                        {
                            fieldLabel: '利息金额(元)',
                            xtype: "numberFieldFormat",
                            name: "LX_AMT",
                            emptyText: '0.00',
                            hideTrigger: true,
                            fieldCls: 'form-unedit-number'
                        },
                        {
                            fieldLabel: '兑付费金额(元)',
                            xtype: "numberFieldFormat",
                            name: "DFF_AMT",
                            emptyText: '0.00',
                            hideTrigger: true,
                            fieldCls: 'form-unedit-number'
                        },
                        {
                            fieldLabel: '支付日期',
                            xtype: "datefield",
                            name: "PAY_DATE",
                            value: today,
                            emptyText: '请填写支付日期',
                            format: 'Y-m-d',
                            readOnly: false,
                            editable: false
                        },
                        {fieldLabel: '备注', xtype: "textfield", name: "REMARK", columnWidth: .99, readOnly: false,maxLength : 100}
                    ]
                },
                {
                    xtype: 'fieldset',
                    flex: 1,
                    title: '兑付申请',
                    collapsible: true,
                    layout: 'fit',
                    items: [initWindow_input_contentForm_grid()]
                }
            ]
        });
    }


    /**
     * 兑付申请明细表格
     */
    function initWindow_input_contentForm_grid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 40},

            
            {text: "是否是第一次插入", dataIndex: "BOOLEAN_IS_FIRST", type: "string", width: 150, hidden: debuggers}, //0,第一次，1，再一次
            {text: "兑付计划ID", dataIndex: "DF_PLAN_ID", type: "string", width: 150, hidden: debuggers},
            {text: "债券id", dataIndex: "ZQ_ID", type: "string", hidden: debuggers},
            {
                text: "兑付申请编码",
                dataIndex: "DFSQ_DTL_NO",
                width: 150,
                type: "string",
                tdCls: 'grid-cell',
                editor: 'textfield',
                hidden: debuggers
            },
            {
                text: "偿还资金来源", dataIndex: "ZJLY_ID", type: "string", width: 120, tdCls: 'grid-cell',
                editor: {
                    xtype: 'treecombobox',
                    store: store_debt_zjly_temp,
                    name: 'zjlyid',
                    selectModel: 'leaf',
                    displayField: 'name',
                    valueField: 'code'
                },
                renderer: function (value, metaData, record) {
                        var rec = store_debt_zjly_temp.findNode('code', value, true, true, true);
                        var ss = rec != null ? rec.get('name') : value;
                        return ss;
                }
            },
            {
                text: "支付总金额(元)", dataIndex: "TOTAL_PAY_AMT", width: 150, type: "float", tdCls: 'grid-cell-unedit',
                renderer: function (value, cellmeta, record) {
                    value = record.get('DF_AMT') + record.get('DFF_AMT');
                    record.data.TOTAL_PAY_AMT = value;
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                text: "兑付金额(元)", dataIndex: "DF_AMT", width: 150, type: "float", tdCls: 'grid-cell',
                editor: {xtype: 'numberFieldFormat', hideTrigger: true,minValue:0,}
            },
            {
                text: "兑付费金额(元)", dataIndex: "DFF_AMT", width: 150, type: "float", tdCls: 'grid-cell',
                editor: {xtype: 'numberFieldFormat', hideTrigger: true,minValue:0,}
            },

            {
                text: "还本金额(元)", dataIndex: "HB_AMT", width: 150, type: "float", tdCls: 'grid-cell-unedit',
                editor: {xtype: 'numberFieldFormat', hideTrigger: true, readOnly: true,	editable : false,minValue:0,

                },
                hidden:debuggers
            },
            {text: "剩余应还金额(元)", dataIndex: "SY_AMT", width: 150, type: "float", hidden: false},
            {text: "剩余应还兑付费金额(元)", dataIndex: "SY_DFF_AMT", width: 150, type: "float", hidden: false},
            {text: "剩余的还本金额(元)", dataIndex: "HB_AMT_SY", width: 150,type: "float",hidden: debuggers
            },
            {text: "再融资债券类型", dataIndex: "HBZQ_TYPE", width: 150, type: "string", hidden: debuggers},
            /* {
             text: "支付日期", dataIndex: "PAY_DATE", width: 150, type: "string", tdCls: 'grid-cell',
             editor: {xtype: 'datefield', format: 'Y-m-d'},
             renderer: function (value, metaData, record) {
             // alert("jzrq"+value);
             var newValue = dsyDateFormat(value);
             record.data.PAY_DATE = newValue;
             return newValue;
             }
             },*/
//            {
//            },
            {text:'再融资债券名称',dataIndex:'HBZQ_NAME',type:'string',width:150,tdCls: 'grid-cell',
                editor: {
                    xtype: "popupforhbfxgrid",
                    name: "HBZQ_POPUP",
                    valueField: 'ZQ_ID',
                    displayField: 'ZQ_NAME',
                    store:getZwStore(),
                    editable:false,
                }
            },
            {text: "再融资债券ID", dataIndex: "HBZQ_ID", width: 150, type: "string", tdCls: 'grid-cell',hidden:debuggers},//计划表
            {text: "备注", dataIndex: "REMARK", type: "string", width: 150, editor: 'textfield',
                editor: {hideTrigger: false, xtype: 'textfield',maxLength : 100,
                    maxLengthText : '输入文字过长，只能输入100个字！'}
            },
            {text: "计划兑付日", dataIndex: "DF_END_DATE", width: 150, type: "string", tdCls: 'grid-cell-unedit'},//计划表
            {text: "兑付类型", dataIndex: "DF_TYPE_NAME", width: 150, type: "string", tdCls: 'grid-cell-unedit'},
            {text: "债券代码", dataIndex: "ZQ_CODE", type: "string", tdCls: 'grid-cell-unedit', width: 150},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", width: 350, type: "string", tdCls: 'grid-cell-unedit',
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "债券简称", dataIndex: "ZQ_JC", width: 150, type: "string", tdCls: 'grid-cell-unedit'},
            {text: "债券期限", dataIndex: "ZQQX_NAME", width: 150, type: "string", tdCls: 'grid-cell-unedit'},
            {text: "债券类型", dataIndex: "ZQLB_NAME", width: 150, type: "string", tdCls: 'grid-cell-unedit'},
            {text: "债券类型code", dataIndex: "ZQLB_CODE", width: 150, type: "string", tdCls: 'grid-cell-unedit',hidden:debuggers},
            {dataIndex: "PM_RATE", width: 150, type: "float", text: "票面利率", hidden: debuggers},
            {dataIndex: "DFSXF_RATE", width: 150, type: "float", text: "兑付手续费率（‰）", hidden: debuggers},
            {dataIndex: "FX_AMT", width: 150, type: "float", text: "实际发行额", hidden: debuggers},
            {dataIndex: "PAY_AMT_CHECK", width: 150, type: "float", text: "实际发行额", hidden: debuggers},
            {dataIndex: "DF_AMT_CHECK", width: 150, type: "float", text: "df_check", hidden: debuggers},
            {dataIndex: "DFF_AMT_CHECK", width: 150, type: "float", text: "dff_check", hidden: debuggers},
            {dataIndex: "FX_START_DATE", width: 150, type: "string", text: "发行日", hidden: debuggers},
            {dataIndex: "ZB_DATE", width: 150, type: "string", text: "招标日期", hidden: debuggers},
            {dataIndex: "DQDF_DATE", width: 150, type: "string", text: "到期兑付日", hidden: debuggers}, //到期兑付日
            {dataIndex: "QX_DATE", width: 150, type: "string", text: "起息日", hidden: debuggers},
            {dataIndex: "FXZQ_NAME", width: 150, type: "string", text: "付息周期", hidden: debuggers},
            {dataIndex: "DF_TYPE", width: 150, type: "string", text: "兑付类型编码", hidden: debuggers}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'dfsq_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            data: [],
            border: true,
            height: '100%',
            width: '100%',
            pageConfig: {
                enablePage: false
            },
            proxy:{
             reader  : {
                 idProperty    : "idc2" //这里可以改成你数据中没有的字段，随便写
               }
    },

        plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'dfsq_grid_plugin_cell',
                    clicksToMoveEditor: 1,
                    listeners: {
                        validateedit: function (editor, e) {
                            if (e.field == 'DF_AMT') {

   //                               window.flag_validateedit = null;
//                                if (e.value > e.record.get('SY_AMT')) {
//                                    window.flag_validateedit = Ext.MessageBox.alert('提示', '输入金额超过剩余应偿还金额！');
//                                    return false;
//                                }
//                                if(e.record.get("HBZQ_ID")!=null&&e.record.get("HBZQ_ID")!=undefined&&e.record.get("HBZQ_ID")!="") {
//                                    if (e.value > e.record.get('HB_AMT_SY')) {
//                                        window.flag_validateedit = Ext.MessageBox.alert('提示', '输入金额超过未使用再融资债券金额！');
//                                        return false;
//                                    }
//                                }
                            }
                            if (e.field == 'DFF_AMT') {
//                                window.flag_validateedit = null;
//                                if (e.value > e.record.get('SY_DFF_AMT')) {
//                                    window.flag_validateedit = Ext.MessageBox.alert('提示', '输入金额超过剩余应偿还金额！');
//                                    return false;
//                                }
                            }
                            if (e.field == 'ZJLY_ID') {
                                window.flag_validateedit = null;
                                var dflbTemp = e.record.get("DF_TYPE");
                                if (dflbTemp != null && dflbTemp != undefined && dflbTemp != "") {
                                    var tempb = Ext.ComponentQuery.query('popupforhbfxgrid[name="HBZQ_POPUP"]')[0];
                                    var zqlb_code = e.record.get("ZQLB_CODE");
                                    if(e.value == '97' && dflbTemp == '1') {
                                        window.flag_validateedit = Ext.MessageBox.alert('提示', '利息无法使用库款垫付作为偿还资金来源！');
                                        return false;
                                    }
                                    if (e.value == '0303') {
                                        if (dflbTemp == '0') {
                                            if (zqlb_code.substring(0, 2) != '01') {
                                                window.flag_validateedit = Ext.MessageBox.alert('提示', '债券类型为一般债券时才可以选择该偿还来源！');
                                                return false;
                                            }
                                        } else {
                                            window.flag_validateedit = Ext.MessageBox.alert('提示', '兑付类型为本金时才可以选择该偿还来源！');
                                            return false;
                                        }

                                        if(e.record.get("DF_AMT")<=0){
                                            window.flag_validateedit = Ext.MessageBox.alert('提示', '录入的兑付费大于0时才可以选择该偿还来源！');
                                            return false;
                                        }

                                    } else if (e.value == '0304') {
                                        if (dflbTemp == '0') {
                                            if (zqlb_code.substring(0, 2) != '02') {
                                                window.flag_validateedit = Ext.MessageBox.alert('提示', '债券类型为专项债券时才可以选择该偿还来源！');
                                                return false;
                                            }
                                        } else {
                                            window.flag_validateedit = Ext.MessageBox.alert('提示', '兑付类型为本金时才可以选择该偿还来源！');
                                            return false;
                                        }
                                        if(e.record.get("DF_AMT")<=0){
                                            window.flag_validateedit = Ext.MessageBox.alert('提示', '录入的兑付费大于0时才可以选择该偿还来源！');
                                            return false;
                                        }

                                    } else{

                                    }
                                }


                                //var new_store= DebtEleTreeStoreDB('DEBT_CHZJLY');
                                //  store_DEBT_ZJLY =
                            }

//                            if (e.field == 'DF_AMT') {
//                                if (e.record.get("HBZQ_ID") != null && e.record.get("HBZQ_ID") != undefined && e.record.get("HBZQ_ID") != "") {
//                                    if (YLU_TEMP[e.record.get("HBZQ_ID")] >= e.value) {
//                                        YLU_TEMP[e.record.get("HBZQ_ID")] -= e.value;
//                                    } else {
//                                        YLU_TEMP[e.record.get("HBZQ_ID")] = 0;
//                                    }
//
//                                }
//                            }
                        },

                        edit: function (editor, e) {
                            inputDfsqForm(e.grid.getStore());
                        },
                        beforeedit: function (editor, context) {
                            if(context.field=='HBZQ_NAME'){
//                                var zjlytemp=context.record.get("ZJLY_ID");
//                                var df_type=context.record.get("DF_TYPE");
//                                if(zjlytemp!=null&&zjlytemp!=""&&zjlytemp!=undefined){
//                                    if((zjlytemp=='0303'||zjlytemp=='0304')&&(df_type=='0')){
//                                    }else{
//                                        return false;
//                                    }
//                                }else {
//                                    return false;
//                                }
                                return false;
                            }
                            if(context.field=='DF_AMT'){
                                if(context.record.get("HBZQ_ID")!=null&&context.record.get("HBZQ_ID")!=undefined&&context.record.get("HBZQ_ID")!=""){
                                    return false;
                                }
                            }
                        },


                    }
                }

            ],
            listeners: {
                selectionchange: function (self, records) {
                    DSYGrid.getGrid('dfsq_grid').up('window').down('[name=delete_editGrid]').setDisabled(!records.length);
                }

            }
        });
        return grid;
    }
    /**
     * 更新兑付申请主单表单值
     */
    function inputDfsqForm(store, type_name) {
        var input_bj_amt = 0; //本金金额
        var input_lx_amt = 0; //利息金额
        var input_dff_amt = 0; //兑付费金额
        store.each(function (record) {
            input_dff_amt += record.get('DFF_AMT');
            if (record.get('DF_TYPE') == "0") {
                input_bj_amt += record.get('DF_AMT');
            } else if (record.get('DF_TYPE') == "1") {
                input_lx_amt += record.get('DF_AMT');
            }
        });
        var input_apply_amt = input_bj_amt + input_lx_amt + input_dff_amt;//本金+利息+兑付费
        window_input.window.down('form').down('[name="APPLY_AMT"]').setValue(input_apply_amt);
        window_input.window.down('form').down('[name="BJ_AMT"]').setValue(input_bj_amt);
        window_input.window.down('form').down('[name="LX_AMT"]').setValue(input_lx_amt);
        window_input.window.down('form').down('[name="DFF_AMT"]').setValue(input_dff_amt);
    }
    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        var dfsqInfo = [];
        for (var i in records) {
            if (btn.name == 'cancel' && records[i].get("IS_CONFIRM") == '1') {
                Ext.MessageBox.alert('提示', '已确认数据不能撤销审核！');
                return;
            }
            ids.push(records[i].get("DFSQ_ID"));
            var array = {};
            array.ID = records[i].get("DFSQ_ID");
            array.APPLY_DATE = records[i].get("APPLY_DATE");
            array.AD_CODE = records[i].get("AD_CODE");
            dfsqInfo.push(array);
        }
        button_name = btn.text;
        //弹出提示确认是否删除
        if (button_name == '送审' || button_name == '撤销送审') {
            Ext.Msg.confirm('提示', '确定' + button_name + '选中记录?', function (buttonId) {
                if (buttonId == 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("/updateDfsqNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        ids: ids,
                        dfsqInfo: Ext.util.JSON.encode(dfsqInfo)
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //刷新表格
                            reloadGrid();
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }
                    }, "json");
                }
            });
        } else if (button_name == '审核' || button_name == '退回') {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text + '意见',
                animateTarget: btn,
                value: btn.name == 'up' ? null : '同意',
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("/updateDfsqNode.action", {
                            workflow_direction: btn.name,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            audit_info: text,
                            ids: ids,
                            dfsqInfo: Ext.util.JSON.encode(dfsqInfo)
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_name + "成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                //刷新表格
                                reloadGrid();
                            } else {
                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                            }
                        }, "json");
                    }
                }
            });
        } else {
            Ext.Msg.confirm('提示', '是否' + button_name + '?', function (buttonId) {
                if (buttonId == 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("/updateDfsqNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        ids: ids,
                        dfsqInfo: Ext.util.JSON.encode(dfsqInfo)
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //刷新表格
                            reloadGrid();
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }
                    }, "json");
                }
            });
        }
    }
    /**
     *更新确认标志
     */
    function updateConfirm(btn) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        var dfsqInfo = [];
        for (var i in records) {
            ids.push(records[i].get("DFSQ_ID"));
            var array = {};
            array.ID = records[i].get("DFSQ_ID");
            array.APPLY_DATE = records[i].get("APPLY_DATE");
            array.AD_CODE = records[i].get("AD_CODE");
            dfsqInfo.push(array);
        }
        button_name = btn.text;
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text,
            animateTarget: btn,
            value: btn.name == 'up' ? null : '确认',
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post("/updateDfsqConfirm.action", {
                        button_name: button_name,
                        ids: ids,
                        audit_info: text,
                        ad_code: AD_CODE,
                        dfsqInfo: Ext.util.JSON.encode(dfsqInfo)
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            //刷新表格
                            DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                            DSYGrid.getGrid("contentGrid_detail").getStore().removeAll();
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }

                    }, "json");
                }
            }
        });
    }
    /**
     * 创建填写意见对话框
     */
    function initWindow_opinion(config) {
        var default_config = {
            closeAction: 'destroy',
            title: null,
            buttons: Ext.MessageBox.OKCANCEL,
            width: 350,
            value: '同意',
            animateTarget: null,
            fn: null
        };
        $.extend(default_config, config);
        return Ext.create('Ext.window.MessageBox', {
            closeAction: default_config.closeAction
        }).show({
            multiline: true,
            value: default_config.value,
            width: default_config.width,
            title: default_config.title,
            animateTarget: default_config.animateTarget,
            buttons: default_config.buttons,
            fn: default_config.fn
        });
    }
    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        //增加查询参数
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        //刷新
        store.loadPage(1);
        //刷新下方表格,置为空
        if (DSYGrid.getGrid('contentGrid_detail')) {
            var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
            //如果传递参数不为空，就刷新明细表格
            if (typeof param_detail != 'undefined' && param_detail != null) {
                for (var name in param_detail) {
                    store_details.getProxy().extraParams[name] = param_detail[name];
                }
                store_details.loadPage(1);
            } else {
                store_details.removeAll();
            }
        }
    }
    /**
     操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            pcjh_id = records[0].get("DFSQ_ID");
            fuc_getWorkFlowLog(pcjh_id);
        }
    }
    /**
     * 附件查看弹出框
     * @param params
     */
    function initWin_fjck(params) {
        var grid;
        if (params.DFSQ_DTL_ID) {
            grid = UploadPanel.createGrid({
                busiType: 'ET204',//业务类型
                busiId: params.DFSQ_DTL_ID,//业务ID
                editable: false,//是否可以修改附件内容
                gridConfig: {
                    itemId: 'win_FJCKGrid'
                }
            });
        } else {
            //附件查看表格表头
            var headerJson = [
                {
                    text: "操作", menuDisabled: true, sortable: false,
                    renderer: function (value, cell, record, rowIndex, colIndex, store, view) {
                        var downloadbtn = '<div class="uploadpanel-btn uploadpanel-btn-download" onclick="UploadPanel.downloadFile(\'' + record.get("FILE_ID") + '\')"></div>';
                        return '<div class="uploadpanel-btsn">' + downloadbtn + '</div>';
                    }
                },
                {text: "地区", dataIndex: "AD_NAME", width: 150, type: "string"},
                {
                    text: "上传文件名称", dataIndex: "FILE_NAME", width: 330, type: "string", cellWrap: true,
                    renderer: function (data, cell, record) {
                        //给文件添加超链接
                        var path = record.get('FILE_PATH');
                        var file_id = record.get('FILE_ID');
                        //当为必选项，并且file_id为空的时候，行背景色为淡黄色
                        var star = '';
                        return star + '<a href="javascript:void(0);" style="color:#3329ff;" onclick="UploadPanel.downloadFile(\'' + file_id + '\')">' + data + '</a>';
                    }
                },
                {
                    text: "文件大小", dataIndex: "FILE_SIZE", width: 125, type: "string",
                    renderer: function (data, cell, record) {
                        if (isNaN(parseFloat(data))) {
                            return data;
                        } else if (parseFloat(data) < (1024 * 1024)) {
                            return (parseFloat(data) / 1024).toFixed(2) + 'KB';
                        }
                        return (parseFloat(data) / (1024 * 1024)).toFixed(2) + 'MB';
                    }
                }
            ];
            //附件查看表格
            grid = DSYGrid.createGrid({
                itemId: 'win_FJCKGrid',
                headerConfig: {
                    headerJson: headerJson,
                    columnAutoWidth: false
                },
                checkBox: false,
                border: false,
                autoLoad: true,
                height: '50%',
                flex: 1,
                params: {
                    BILL_ID: params.BILL_ID,
                    HZ_ID: params.HZ_ID
                },
                dataUrl: '/getZqxmZhzqZhmxFjckGrid.action',
                pageConfig: {
                    enablePage: false
                }
            });
        }
        //附件查看弹出框
        Ext.create('Ext.window.Window', {
            title: '附件查看', // 窗口标题
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.9, //自适应窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_file', // 窗口标识
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [grid]
        }).show();
    }
</script>
</body>
</html>