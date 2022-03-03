/**
 * Created by Lenovo on 2017/3/24.
 */
Ext.define('ZQModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id',mapping:'ZQ_ID'},
        {name: 'name',mapping:'ZQ_NAME'}
    ]
});
var wf_id = getQueryParam("wf_id");//当前流程id

var initFixValue=0;
var check_dq_amt_i_ori=new Object();  //单笔债券支出金额之和
var check_dq_amt5=new Object();  //单笔债券的可支出金额

var node_code = getQueryParam("node_code");//当前节点id
var node_type = getQueryParam("node_type");//当前节点标识
var ZC_TYPE = getQueryParam("ZC_TYPE");//支出类型：0新增债券类型 1置换债券类型 2再融资债券类型
ZC_TYPE = 2;
var button_name = '';//当前操作按钮名称
var button_status = '';//当前操作按钮的name，标识按钮状态
var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
    WF_STATUS = '001';
}
var debuggers=true;
var is_check=false;
if(wf_id==""||wf_id==undefined){
    wf_id="100252"
}
if(node_code==""||node_code==undefined){
    node_code="1"
}
if(node_type==""||node_type==undefined){
    node_type="zclr"
}
var dqZqSy = {}; //保存时校验用

var is_fix=false;

//全局变量
var FXPC_ID = '';
var zqNameStore=getZqNameStore();
/**
 * 获取系统参数:
 * 选择债券后，根据系统参数判断是否需要按照发行计划控制，
 * 如果控制，则查询所选债券的发行批次对应是否有发行计划，如果有，则后面的选择债务对话框中的债务应该是该批次发行计划中包含的发行计划明细+库款垫付；
 * 如果不控制或没有发行计划，则可选非首轮项目申报中已经由省级审批通过的所有发行计划+库款垫付
 */
/*var DEBT_CONN_ZQXM = 1;//默认控制
$.post("getParamValueAll.action", function (data) {
    data = eval(data);
    DEBT_CONN_ZQXM = parseInt(data[0].DEBT_CONN_ZQXM_ZH);
});*/
/**
 * 获取债券名称
 */
function getZqNameStore(){
    var zqNameDataStore = Ext.create('Ext.data.Store', {
        model: 'ZQModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: "/getZqNameData.action",
            reader: {
                type: 'json'
            },
            extraParams:{
                ZC_TYPE:ZC_TYPE
            }
        },
        autoLoad: true
    });
    return zqNameDataStore;
}
/**
 * 通用配置json
 */
var json_common = {
    zclr: {//发行兑付-债券使用-置换债券支出录入
        items: {
            '001': [
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '录入',
                    name: 'btn_insert',
                    icon: '/image/sysbutton/add.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        button_status = btn.name;
                        is_fix=false;
                        //弹出债券选择框
                        is_check=false;
                        check_dq_amt=new Object();
                        initFixValue=0;
                         check_dq_amt_i_ori=new Object();  //单笔债券支出金额之和
                         check_dq_amt5=new Object();  //单笔债券的可支出金额
                        initWindow_select_hbzq().show();
                    }
                },
                {
                    xtype: 'button',
                    text: '修改',
                    name: 'btn_update',
                    icon: '/image/sysbutton/edit.png',
                    handler: function (btn) {
                        initFixValue=0;
                        check_dq_amt_i_ori=new Object();  //单笔债券支出金额之和
                        check_dq_amt5=new Object();  //单笔债券的可支出金额
                        is_fix=true;
                        is_check=false;
                        check_dq_amt=new Object();
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请选择一条数据再进行操作!');
                            btn.setDisabled(false);
                            return;
                        }
                        //修改全局变量的值
                        button_name = btn.text;
                        button_status = btn.name;
                        var param=new Object();
                        fixZcdParam(param,records[0]);

                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'btn_delete',
                    icon: '/image/sysbutton/delete.png',
                    handler: function (btn) {
                        is_check=false;

                        button_name = btn.text;
                        button_status = btn.name;
                        // 检验是否选中数据
                        // 获取选中数据
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                            return false;
                        }
                        for (var i in records) {
                            var record = records[i];
                            if (!record.data.ZCD_ID || record.data.ZCD_ID == '') {
                                Ext.MessageBox.alert('提示', '删除数据必须具有支出单ID');
                                return false;
                            }
                        }
                        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                            if (btn_confirm == 'yes') {
                                button_name = btn.text;
                                var ids = [];
                                for (var i in records) {
                                    ids.push(records[i].get("ZCD_ID"));
                                }
                                //发送ajax请求，删除数据
                                $.post("/deleteFxdfZqsyZqzcGrid.action", {
                                    ids: ids,
                                    wf_id: wf_id,
                                    WF_STATUS: WF_STATUS,
                                    AD_CODE:AD_CODE
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
                        button_name = btn.text;
                        button_status = btn.name;
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
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
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销送审',
                    name: 'cancel',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        button_status = btn.name;
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
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
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '修改',
                    name: 'btn_update',
                    icon: '/image/sysbutton/edit.png',
                    handler: function (btn) {
                        initFixValue=0;
                        check_dq_amt_i_ori=new Object();  //单笔债券支出金额之和
                        is_check=false;
                        is_fix=true;
                        check_dq_amt=new Object();
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请选择一条数据再进行操作!');
                            btn.setDisabled(false);
                            return;
                        }
                        //修改全局变量的值
                        button_name = btn.text;
                        button_status = btn.name;
                        var param=new Object();
                        fixZcdParam(param,records[0]);
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'btn_delete',
                    icon: '/image/sysbutton/delete.png',
                    handler: function (btn) {
                        is_check=false;
                        button_name = btn.text;
                        button_status = btn.name;
                        // 检验是否选中数据
                        // 获取选中数据
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                            return false;
                        }
                        for (var i in records) {
                            var record = records[i];
                            if (!record.data.ZCD_ID || record.data.ZCD_ID == '') {
                                Ext.MessageBox.alert('提示', '删除数据必须具有支出单ID');
                                return false;
                            }
                        }
                        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                            if (btn_confirm == 'yes') {
                                button_name = btn.text;
                                var ids = [];
                                for (var i in records) {
                                    ids.push(records[i].get("ZCD_ID"));
                                }
                                //发送ajax请求，删除数据
                                $.post("/deleteFxdfZqsyZqzcGrid.action", {
                                    ids: ids,
                                    wf_id: wf_id,
                                    node_code: node_code,
                                    WF_STATUS: WF_STATUS,
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
                        button_name = btn.text;
                        button_status = btn.name;
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ],
            '008': [
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'search'
                    ,
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        },
        store: {
            WF_STATUS: DebtEleStore(json_debt_zt0),
            ZC_TYPE: DebtEleStore(json_debt_zqzclx)
        }
    },
    zcsh: {//发行兑付-债券使用-置换债券支出审核
        items: {
            '001': [
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '审核',
                    name: 'down',
                    icon: '/image/sysbutton/audit.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '退回',
                    name: 'up',
                    icon: '/image/sysbutton/back.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
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
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销审核',
                    name: 'cancel',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        doWorkFlow(btn);
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        },
        store: {
            WF_STATUS: DebtEleStore(json_debt_sh),
            ZC_TYPE: DebtEleStore(json_debt_zqzclx)
        }
    }
};


//修改数据
function fixZcdParam(param,record) {
    Ext.MessageBox.wait('读取数据中，请等待...','加载数据');
    $.post('/getHbzcDetail.action', {
        ZCD_ID:record.get('ZCD_ID'),
        AD_CODE:record.get('AD_CODE'),
        ZQ_ID:record.get('ZQ_ID')
    }, function (data) {
        if(data.success){
            var form_data=data.formList[0];
            var grid_data=data.gridList;
            var zrzKzcdata=data.zrzKzcList[0];
            param.firstpage=new Object();
            param.firstpage.initvalue=form_data;
            param.havenChoose=grid_data;
            //param.editable=true;
            param.gridId=form_data.ZCD_ID;
            param.SY_DQ_AMT = zrzKzcdata['SY_HB_AMT'];
            param.PLAN_HB_AMT = zrzKzcdata['PLAN_HB_AMT'];
        }

        initWindow_select_final(param).show();
        SetFormData(param,true);
        SetGridData(param,true);
        resetform();
        closeAllWindows();
        closeAllAnNiu();
        Ext.MessageBox.hide();
        // ({
        //     editable: true,
        //     ZCD_ID: records[0].get('ZCD_ID')
        // });
    }, "json");
}

/**
 * 操作记录
 */
function oprationRecord() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var id = records[0].get("ZCD_ID");
        fuc_getWorkFlowLog(id);
    }
}
/**
 * 页面初始化
 */
$(document).ready(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    initContent();
});
/**
 * 初始化页面主要内容区域
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        height: '100%',
        renderTo: Ext.getBody(),
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: Ext.Array.union(json_common[node_type].items[WF_STATUS], json_common[node_type].items['common'])
            }
        ],
        items: [
            //右侧表格
            initContentRightPanel()
        ]
    });
}
/**
 * 初始化右侧panel，放置表格
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        height: '100%',
        flex: 5,
        region: 'center',
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        border: false,
        dockedItems: json_common[node_type].items_content_rightPanel_dockedItems ? json_common[node_type].items_content_rightPanel_dockedItems : null,
        items: [
            initContentGrid()
        ]
    });
}

function closeAllAnNiu() {
    if(is_check){
        var button1 = Ext.ComponentQuery.query('button[name="insertZC"]')[0];
        var button2 = Ext.ComponentQuery.query('button[name="deleteZC"]')[0];
        var button3 = Ext.ComponentQuery.query('button[name="saveZC"]')[0];
        if(button1!=null&&button1!=undefined){
            button1.setVisible(false);
        }
        if(button2!=null&&button2!=undefined){
            button2.setVisible(false);
        }
        if(button3!=null&&button3!=undefined){
            button3.setVisible(false);
        }
    }
}
/**
 * 初始化主表格
 */
function initContentGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {text: "支出单ID", dataIndex: "ZCD_ID", type: "string", hidden: debuggers},
        {text: "支出单编码", dataIndex: "ZCD_CODE", type: "string", width: 200},
        {text: "支出类型", dataIndex: "ZC_TYPE", type: "string", hidden: debuggers},
        {text: "关联债券ID", dataIndex: "ZQ_ID", type: "string", hidden: debuggers},
        {text: "债券名称", dataIndex: "ZQ_NAME", type: "string",width:200,
            renderer: function (data, cell, record) {
                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="ZQ_ID";
                paramNames[1]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=record.get('ZQ_ID');
                paramValues[1]=AD_CODE.replace(/00$/, "");
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }},
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string",width: 200},
        {text: "支出总额(人民币)(元)", dataIndex: "PAY_AMT", type: "float", width: 190},
        {text: "录入人", dataIndex: "ZCD_LR_USER", type: "string", width: 200,hidden:debuggers},
        {text:"录入人名称",dataIndex:"NAME",type:"string",width:200},
        {text: "支出年度", dataIndex: "ZCD_YEAR", type: "string",hidden: true,
            editor: {xtype: 'datefield', format: 'Y'}},
        {text: "备注", dataIndex: "ZCD_REMARK", type: "string"}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        params: {
            WF_STATUS:WF_STATUS,
            NODE_TYPE:node_type,
            NODE_CODE:node_code,
            WF_ID:wf_id,
            ZC_TYPE: ZC_TYPE,
            AD_CODE:AD_CODE
        },
        dataUrl: '/getHbzcOrder.action',
        checkBox: true,
        border: false,
        autoLoad: true,
        height: '100%',
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: json_common[node_type].store['WF_STATUS'],
                width: 110,
                labelWidth: 30,
                editable: false, //禁用编辑
                labelAlign: 'right',
                displayField: "name",
                valueField: "id",
                value: WF_STATUS,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(Ext.Array.union(json_common[node_type].items[WF_STATUS], json_common[node_type].items['common']));
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                        reloadGrid();
                    }
                }
            },
            {
                fieldLabel: '债券名称',
                name: 'ZQ_NAME',
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                store: zqNameStore,
                width: 250,
                labelWidth: 60,
                labelAlign: 'left'
            }
        ],
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                var param=new Object();
                is_check=true;
                param.editable = false;
                fixZcdParam(param,record);


            }
        }
    });
}

/**
 * 初始化债券：转贷明细选择弹出窗口
 */
function initWindow_select_hbzq() {
    return Ext.create('Ext.window.Window', {
        title: '再融资债券选择', // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_select_hbzq', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_select_hbzq_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                        return;
                    }
                        //记录选择的数据
                        var data_zdmx = records[0].getData();
                        //弹出新增债券填报页面
                        var a=new Object();
                        a.ZQ_ID=data_zdmx.ZQ_ID;
                        a.ZQ_NAME=data_zdmx.ZQ_NAME;
                        a.SY_HB_AMT=data_zdmx.SY_HB_AMT;
                        a.PLAN_AMT=data_zdmx.PLAN_AMT;
                        a.PLAN_HB_AMT=data_zdmx.PLAN_HB_AMT;
                        a.HB_AMT=data_zdmx.HB_AMT;
                        a.PAY_HB_AMT=data_zdmx.PAY_HB_AMT;
                        a.ZQLB_ID=data_zdmx.ZQLB_ID;
                        a.ZQLB_NAME=data_zdmx.ZQLB_NAME;
                        a.ZQ_CODE=data_zdmx.ZQ_CODE;
                        var param=new Object();
                        param.initvalue=a;
                        Ext.Ajax.request({ //发送请求查询 到期债券
                            url : '/getBjDfjhForHb.action',
                            params : {
                                AD_CODE: AD_CODE,
                                ZQ_ID : param.initvalue.ZQ_ID
                            },
                            method : 'post',
                            success : function (data) {
                                var respTest = Ext.JSON.decode(data.responseText);
                                if(respTest.success){
                                    var list = respTest.list;
                                    dqZqSy = {};
                                    if(list && list.length > 0){
                                        var params = new Object();
                                        var ids = [];
                                        for (var i=0;i<list.length;i++) {
                                            var data_crmx = list[i];
                                            ids.push(data_crmx.ZQ_ID);
                                            check_dq_amt[data_crmx.ZQ_ID]=data_crmx;
                                            dqZqSy[data_crmx.ZQ_ID] = {};
                                            dqZqSy[data_crmx.ZQ_ID]['SY_DQ_AMT'] = data_crmx.SY_DQ_AMT;
                                            dqZqSy[data_crmx.ZQ_ID]['ZQ_NAME'] = data_crmx.ZQ_NAME;
                                        }
                                        params.ids=ids;
                                        params.firstpage=param;
                                        params.check_dq_amt=check_dq_amt;
                                        params.SY_DQ_AMT = a.SY_HB_AMT;
                                        var window_zwxm = initWindow_select_zwxm(params);
                                        window_zwxm.show();
                                        btn.up('window').close();
                                    }else{
                                        var params = {
                                            ids : []
                                        };
                                        params.SY_DQ_AMT = a.SY_HB_AMT;
                                        initWindow_select_zwxm(params).show();
                                    }
                                }
                            }
                        });
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
function SetGridData(param,is_fix) {
    if(is_fix){
        initFixValue=0;  //统计pay_amt
        check_dq_amt_i_ori=new Object();
        var third_page_data=param.havenChoose;
        var zcxxgridstore=DSYGrid.getGrid('window_save_zcxx_grid').getStore();
        var zcMxData = [];
        dqZqSy = {};
        for(var i in third_page_data){
            var temp$a= third_page_data[i];
                if(temp$a.XM_ID==null||temp$a.XM_ID==undefined){
                    temp$a.XM_ID="";
                };
                if(temp$a.ZW_ID==null||temp$a.ZW_ID==undefined){
                    temp$a.ZW_ID="";
                };
                if(temp$a.CHJH_ID==null||temp$a.CHJH_ID==undefined){
                    temp$a.CHJH_ID="";
                }
                temp$a.BOOLEAN_IS_FIRST='0';
                temp$a.MXUUID=temp$a.ORI_ZQ_ID+temp$a.XM_ID+temp$a.ZW_ID+temp$a.CHJH_ID;
                // var iseaist=zcxxgridstore.findRecord('MXUUID', temp$a.MXUUID, false, true, true);
                // if(iseaist!=null&&iseaist!=undefined){
                // }else{
                //     DSYGrid.getGrid('window_save_zcxx_grid').insertData(null,temp$a);
                // }
            zcMxData.push(temp$a);
            //循环换取payamt
                initFixValue=initFixValue+temp$a.PAY_AMT;
            if(check_dq_amt_i_ori[temp$a.ORI_ZQ_ID]!=null&&check_dq_amt_i_ori[temp$a.ORI_ZQ_ID]!=undefined){
                check_dq_amt_i_ori[temp$a.ORI_ZQ_ID]+=temp$a.PAY_AMT;
            }else{
                check_dq_amt_i_ori[temp$a.ORI_ZQ_ID]=temp$a.PAY_AMT;
            }
            if(check_dq_amt5[temp$a.ORI_ZQ_ID]==null||check_dq_amt5[temp$a.ORI_ZQ_ID]==undefined){
                check_dq_amt5[temp$a.ORI_ZQ_ID]=temp$a.SY_DQ_AMT;
            }
            if(!dqZqSy[temp$a.ORI_ZQ_ID]) {
                dqZqSy[temp$a.ORI_ZQ_ID] = {};
                dqZqSy[temp$a.ORI_ZQ_ID]['SY_DQ_AMT'] = temp$a.SY_DQ_AMT2;
                dqZqSy[temp$a.ORI_ZQ_ID]['ZQ_NAME'] = temp$a.ORI_ZQ_NAME;
            }else{
                dqZqSy[temp$a.ORI_ZQ_ID]['SY_DQ_AMT'] = accAddPro(dqZqSy[temp$a.ORI_ZQ_ID]['SY_DQ_AMT'],temp$a.SY_DQ_AMT2)
            }
        }
        DSYGrid.getGrid('window_save_zcxx_grid').insertData(null,zcMxData);
    }else{
        var check_dq_amt=param.check_dq_amt;
        var third_page_data=param.havenChoose;
        var zcxxgridstore=DSYGrid.getGrid('window_save_zcxx_grid').getStore();
        var zcMxData = [];
        for(var i in third_page_data){
            var temp$a= third_page_data[i];
            for(var j in temp$a){
                if(temp$a[j].XM_ID==null||temp$a[j].XM_ID==undefined){
                    temp$a[j].XM_ID="";
                };
                if(temp$a[j].ZW_ID==null||temp$a[j].ZW_ID==undefined){
                    temp$a[j].ZW_ID="";
                };
                if(temp$a[j].CHJH_ID==null||temp$a[j].CHJH_ID==undefined){
                    temp$a[j].CHJH_ID="";
                }
                if(check_dq_amt!=null&&check_dq_amt!=undefined){
                    for(var i in check_dq_amt){
                        if(temp$a[j].ZQ_ID==i){
                            temp$a[j].SY_DQ_AMT=check_dq_amt[i].SY_DQ_AMT;
                            temp$a[j].DQ_AMT=check_dq_amt[i].DQ_AMT;
                            temp$a[j].ORI_ZQ_NAME=check_dq_amt[i].ZQ_NAME;
                        }
                    }
                }
                temp$a[j].BOOLEAN_IS_FIRST='1';
                temp$a[j].ORI_ZQ_ID=temp$a[j].ZQ_ID;

                var nowDate = new Date();
                var year = nowDate.getFullYear();
                var month = nowDate.getMonth() + 1 < 10 ? "0" + (nowDate.getMonth() + 1)
                    : nowDate.getMonth() + 1;
                var day = nowDate.getDate() < 10 ? "0" + nowDate.getDate() : nowDate
                    .getDate();
                var dateStr = year + "-" + month + "-" + day;
                  temp$a[j].PAY_DATE=dateStr;
                if(temp$a[j].XMSY_AMT==null||temp$a[j].XMSY_AMT==undefined){
                    temp$a[j].XMSY_AMT=0;
                }
                if(temp$a[j].ZWSY_AMT==null||temp$a[j].ZWSY_AMT==undefined){
                    temp$a[j].ZWSY_AMT=0;
                }
                if(temp$a[j].ZRZSY_AMT==null||temp$a[j].ZRZSY_AMT==undefined){
                    temp$a[j].ZRZSY_AMT=0;
                }
                temp$a[j].PAY_AMT=temp$a[j].XMSY_AMT+temp$a[j].ZWSY_AMT+temp$a[j].ZRZSY_AMT;
                temp$a[j].MXUUID=temp$a[j].ZQ_ID+temp$a[j].XM_ID+temp$a[j].ZW_ID+temp$a[j].CHJH_ID;
                var iseaist=zcxxgridstore.findRecord('MXUUID', temp$a[j].MXUUID, false, true, true);
                if(iseaist!=null&&iseaist!=undefined){
                }else{
                    // DSYGrid.getGrid('window_save_zcxx_grid').insertData(null,temp$a[j]);
                    zcMxData.push(temp$a[j]);
                    if(check_dq_amt5[temp$a[j].ORI_ZQ_ID]==null||check_dq_amt5[temp$a[j].ORI_ZQ_ID]==undefined){
                        check_dq_amt5[temp$a[j].ORI_ZQ_ID]=temp$a[j].SY_DQ_AMT;
                    }
                }
            }
        }
        DSYGrid.getGrid('window_save_zcxx_grid').insertData(null,zcMxData);
    }

}
/**
 * 初始化债券支出保存弹出窗口表格
 */
function initWindow_save_zcxx_grid(config) {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        /*{text:"项目剩余可支出",dataIndex:"XMSY_AMT",type:"float"},
        {text:"债务剩余可支出",dataIndex:"ZWSY_AMT",type:"float"},*/
        {text:"支出id",dataIndex:"ZC_ID",type:"string",hidden:debuggers},
        {text:"是否第一次加载",dataIndex:"BOOLEAN_IS_FIRST",type:"string",hidden:debuggers},
        {text: "债券id", dataIndex: "ORI_ZQ_ID", type: "string", hidden: debuggers},
        {text:"uuid",    dataIndex:"MXUUID", type:"string",hidden:debuggers},
        {
            text: "支出日期", dataIndex: "PAY_DATE", type: "string",width: 150, tdCls: config.editable?'':'grid-cell-unedit',hidden:false,
            editor: {xtype: 'datefield', format: 'y-m-d',editable:false}
        },

        {text: "支出金额(元)", dataIndex: "PAY_AMT", type: "float", hidden: false, tdCls: config.editable?'':'grid-cell-unedit',
            regex: /(([1-9][\d]*)(\.[\d]{1,8})?)|(0\.[\d]{1,8})/,editable:true, regexText:"申请金额必须大于0", width:150,
            editor:{
                    editable:is_check==true?false:true,
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    value:0,
                    allowDecimals: true,
                    decimalPrecision: 2,
                    allowBlank: false
            }

        },
        {text: "债券名称",dataIndex:"ORI_ZQ_NAME",type:"string",tdCls: 'grid-cell-unedit',width:200,hidden:false,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + record.get('AD_CODE');
                 return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="ZQ_ID";
                paramNames[1]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=record.get('ORI_ZQ_ID');
                paramValues[1]=AD_CODE
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {text: "到期金额(元)", dataIndex: "DQ_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150,hidden:true},
        {text: "可支出金额(元)", dataIndex: "SY_DQ_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150,hidden:debuggers
        },
        {text: "原支出类型", dataIndex: "ORI_ZC_TYPE", type: "string", hidden: true},
        {text: "可支出金额(元)_校验字段", dataIndex: "SY_DQ_AMT2", type: "float", tdCls: 'grid-cell-unedit', width: 150,hidden:debuggers},
        {text: "新增债券项目支出金额(元)", dataIndex: "XM_PAY_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 200},
        {text: "债务金额(元)", dataIndex: "ZW_PAY_AMT", type: "float", tdCls: 'grid-cell-unedit', width: 150},
        {text: "项目编码", dataIndex: "XM_CODE", type: "string", width: 150,hidden: debuggers,tdCls: 'grid-cell-unedit',},
        {text: "项目ID", dataIndex: "XM_ID", type: "string", hidden: debuggers,tdCls: 'grid-cell-unedit',},
        {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 200, tdCls: 'grid-cell-unedit',
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                 return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {text: "债务id", dataIndex: "ZW_ID", type: "string", tdCls: 'grid-cell-unedit', width: 150,hidden:debuggers},
        {text: "债务CODE", dataIndex: "ZW_CODE", type: "string", tdCls: 'grid-cell-unedit', width: 150,hidden:debuggers},
        {text: "债务名称", dataIndex: "ZW_NAME", type: "string", tdCls: 'grid-cell-unedit', width: 150,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                 return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }},
        {text:"单位ID",dataIndex:"AG_ID",type:"string",width:150,hidden:debuggers,tdCls: 'grid-cell-unedit',},
        {text:"单位名称",dataIndex:"AG_NAME",type:"string",width:150,hidden:false,tdCls: 'grid-cell-unedit',},
        {text:"单位CODE",dataIndex:"AG_CODE",type:"string",width:150,hidden:debuggers,tdCls: 'grid-cell-unedit',}
    ];
    var grid_config = {
        itemId: 'window_save_zcxx_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data: [],
        autoLoad: false,
        checkBox: true,
        border: false,
        width: '100%',
        flex: 1,
        pageConfig: {
            enablePage: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'window_save_zcxx_grid_plugin_cell',
                clicksToMoveEditor: 1
            }
        ],
        listeners: {
            'beforeedit': function (editor, context) {

            },
            'validateedit': function (editor, context) {
                if(context.field=='PAY_AMT'){
                    if(context.value<0){
                        window.flag_validateedit = Ext.MessageBox.alert('提示', '支出金额必须大于等于0！');
                        return false;
                    }
                    //20210316 wq  修改时 不校验
                    var XMSY_AMT = context.record.get('XMSY_AMT')==undefined?0:context.record.get('XMSY_AMT');
                    var ZWSY_AMT = context.record.get('ZWSY_AMT')==undefined?0:context.record.get('ZWSY_AMT');
                    var ZRZSY_AMT = context.record.get('ZRZSY_AMT')==undefined?0:context.record.get('ZRZSY_AMT');
                    var check_money=XMSY_AMT+ZWSY_AMT+ZRZSY_AMT;
                    if(context.value-check_money > 0.01){
                        window.flag_validateedit = Ext.MessageBox.alert('提示', '支出金额不能大于项目债务再融资支出金额之和！');
                        return false;
                    }
                }

            },
            'edit':function (editor,context) {
                if(context.field=='PAY_AMT'){
                    if(context.value>=0){
                        resetform();
                    }else{

                    }
                }
                if (context.field == 'PAY_DATE') {
                    context.record.set(context.field, Ext.util.Format.date(context.value, 'Y-m-d'));
                }
            }
        }
    };
    if (!config.editable) {
        delete grid_config.plugins;
        delete grid_config.listeners;
    }
    var grid = DSYGrid.createGrid(grid_config);
    return grid;
}

function resetform() {
    var form_goal =Ext.ComponentQuery.query('form[itemId="window_save_zcxx_form"]')[0];
    form_goal=form_goal.getForm();
    var zcxx_grid=DSYGrid.getGrid('window_save_zcxx_grid');
    var zcxx_grid_store=zcxx_grid.getStore();
    var temp$a=0;
    for(var k=0;k<zcxx_grid_store.getCount();k++){
        var record=zcxx_grid_store.getAt(k);
        temp$a+=record.get("PAY_AMT");
    }
    form_goal.findField("PAY_AMT_TOTAL").setValue(temp$a);
}

function SetFormData(param,is_fix) {
    var form_goal =Ext.ComponentQuery.query('form[itemId="window_save_zcxx_form"]')[0];
    form_goal=form_goal.getForm();

    var fisrt_data = param.firstpage;
    if(is_fix){
        form_goal.findField("AD_NAME").setValue(AD_NAME);
        form_goal.findField("AD_CODE").setValue(AD_CODE);
        form_goal.findField("ZQ_ID").setValue(fisrt_data.initvalue.ZQ_ID);
        var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
        var paramNames=new Array();
        paramNames[0]="ZQ_ID";
        paramNames[1]="AD_CODE";
        var paramValues=new Array();
        paramValues[0]=encodeURIComponent(fisrt_data.initvalue.ZQ_ID);
        paramValues[1]=encodeURIComponent(AD_CODE.replace(/00$/, ""));
        var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+fisrt_data.initvalue.ZQ_NAME+'</a>';
        form_goal.findField("ZQ_NAME").setValue(result);
        form_goal.findField("ZC_TYPE_NAME").setValue("再融资债券支出");
        form_goal.findField("ZQLB_NAME").setValue(fisrt_data.initvalue.ZQLB_NAME);
        form_goal.findField("ZQLB_ID").setValue(fisrt_data.initvalue.ZQLB_ID);
        form_goal.findField("PLAN_HB_AMT").setValue(param.PLAN_HB_AMT);
        //form_goal.findField("PAY_HB_AMT").setValue(fisrt_data.initvalue.PAY_HB_AMT);
        form_goal.findField("SY_HB_AMT").setValue(param.SY_DQ_AMT);
        form_goal.findField("ZCD_LR_USER_NAME").setValue(USERNAME);
        var  zcd_id=form_goal.findField("ZCD_ID").getValue();
        if(zcd_id!=null&&zcd_id!=undefined&&zcd_id!=""){
        }else{
            form_goal.findField("ZCD_ID").setValue(fisrt_data.initvalue.ZCD_ID);
        }
        // form_goal.findField("ZCD_YEAR").setValue(new Date().getFullYear());
        // form_goal.findField("APPLY_DATE").setValue(new Date());
        form_goal.findField("PAY_AMT_TOTAL").setValue(fisrt_data.initvalue.PAY_AMT);
        form_goal.findField("ZCD_REMARK").setValue(fisrt_data.initvalue.ZCD_REMARK);
    }else{
        var zcd_id=param.gridId;
        form_goal.findField("AD_NAME").setValue(AD_NAME);
        form_goal.findField("AD_CODE").setValue(AD_CODE);
        form_goal.findField("ZQ_ID").setValue(fisrt_data.initvalue.ZQ_ID);

        var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
        var paramNames=new Array();
        paramNames[0]="ZQ_ID";
        paramNames[1]="AD_CODE";
        var paramValues=new Array();
        paramValues[0]=encodeURIComponent(fisrt_data.initvalue.ZQ_ID);
        paramValues[1]=encodeURIComponent(AD_CODE.replace(/00$/, ""));
        var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+fisrt_data.initvalue.ZQ_NAME+'</a>';

        form_goal.findField("ZQ_NAME").setValue(result);
        form_goal.findField("ZC_TYPE_NAME").setValue("再融资债券支出");
        form_goal.findField("ZQLB_NAME").setValue(fisrt_data.initvalue.ZQLB_NAME);
        form_goal.findField("ZQLB_ID").setValue(fisrt_data.initvalue.ZQLB_ID);
        form_goal.findField("PLAN_HB_AMT").setValue(fisrt_data.initvalue.PLAN_HB_AMT);
        //form_goal.findField("PAY_HB_AMT").setValue(param.SY_DQ_AMT);
        form_goal.findField("SY_HB_AMT").setValue(param.SY_DQ_AMT);
        form_goal.findField("ZCD_LR_USER_NAME").setValue(USERNAME);
        var  zcd_id_temp=form_goal.findField("ZCD_ID").getValue();
        if(zcd_id_temp!=null&&zcd_id_temp!=undefined&&zcd_id_temp!=""){
        }else{
            form_goal.findField("ZCD_ID").setValue(zcd_id);
        }
        // form_goal.findField("ZCD_YEAR").setValue(new Date().getFullYear());
        // form_goal.findField("APPLY_DATE").setValue(new Date());
    }

}

/**
 * 初始化债券支出保存弹出窗口表单
 */
function initWindow_save_zcxx_form(config) {
    return Ext.create('Ext.form.Panel', {
        //title: '详情表单',
        width: '100%',
        itemId: 'window_save_zcxx_form',
        layout: 'column',
        border: false,
        defaults: {
            columnWidth: .33,
            margin: '2 5 2 5',
            labelWidth: 90
        },
        margin: '0 0 5 0',
        defaultType: 'textfield',
        items: [
            {fieldLabel: '地区', name: 'AD_CODE', hidden: debuggers,fieldCls: 'form-unedit'},
            {fieldLabel: '地区', name: 'AD_NAME', readOnly: true,fieldCls: 'form-unedit'},
            {fieldLabel: '债券', name: 'ZQ_ID', hidden: debuggers,fieldCls: 'form-unedit'},
            {fieldLabel: '债券名称', name: 'ZQ_NAME', columnWidth: .66, xtype: 'displayfield'
            },
            {fieldLabel: '支出类型', name: 'ZC_TYPE_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '原支出类型', name: 'ORI_ZC_TYPE', hidden: true, fieldCls: 'form-unedit'},
            {fieldLabel: '债券类型', name: 'ZQLB_NAME', readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: '债券类型code', name: 'ZQLB_ID', readOnly: true, fieldCls: 'form-unedit',hidden:true},
            {fieldLabel: "债券总金额(元)", name: "PLAN_HB_AMT", hidden: false, xtype: 'numberFieldFormat',fieldCls: 'form-unedit', editable : false ,readOnly:true,},
            {fieldLabel: "债券已支出金额(元)", name: "PAY_HB_AMT", hidden: true, xtype: 'numberFieldFormat',fieldCls: 'form-unedit', editable : false ,readOnly:true,},
            {fieldLabel: "债券可支出金额(元)", name: "SY_HB_AMT", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit', editable : false ,readOnly:true,},// 显示第二页签转贷值
            {xtype: 'menuseparator', columnWidth: 1, margin: '2 0 2 0', border: true},//分割线
            {fieldLabel: "单据ID", name: "ZCD_ID", hidden: debuggers,fieldCls: 'form-unedit'},
            /*{fieldLabel: '支出年度', name: 'ZCD_YEAR', hidden: false,xtype:'textfield',editable:false,readOnly:true,fieldCls: 'form-unedit'},
            {fieldLabel: "支出日期", name: "APPLY_DATE", hidden: false,xtype: 'datefield', format: 'Y-m-d',
                editable : false ,readOnly:true,fieldCls: 'form-unedit'
            },*/
            {fieldLabel: "支出总额(元)", name: "PAY_AMT_TOTAL", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit',
                emptyText: '0.00',
                regex: /(([1-9][\d]*)(\.[\d]{1,8})?)|(0\.[\d]{1,8})/,
                editable:true,
                regexText:"总申请金额必须是大于0的非负数",
                allowDecimals: true,
                decimalPrecision: 2,
                hideTrigger: true
            },
            {fieldLabel: "录入人", name: "ZCD_LR_USER_NAME", readOnly: true, fieldCls: 'form-unedit'},
            {fieldLabel: "备注", name:"ZCD_REMARK", editable:is_check==true?false:true,columnWidth: .99,fieldCls:is_check==true?'form-unedit':''}
        ]
    });
}

function closeAllWindows() {
    var windows1=Ext.ComponentQuery.query('window[itemId="window_select_xmzwxx"]')[0];

    if(windows1!=null&&windows1!=undefined){
        windows1.close();
    }

    var windows2=Ext.ComponentQuery.query('window[itemId="window_select_hbzq"]')[0];

    if(windows2!=null&&windows2!=undefined){
        windows2.close();
    }

    var windows3=Ext.ComponentQuery.query('window[itemId="window_select_dfjhmx"]')[0];

    if(windows3!=null&&windows3!=undefined){
        windows3.close();
    }
}


//
function initWindow_select_final(param) {
    if(param.editable==null||param.editable==undefined){
        param.editable=true;
    }
     var windows_config={
        title: '再融资债券支出录入', // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_select_hbzclr', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [
            {
                xtype: 'tabpanel',
                items: [
                    {
                        title: '单据',
                        name: 'ZCD',
                        layout: 'vbox',
                        items: [
                            initWindow_save_zcxx_form(param),
                            initWindow_save_zcxx_grid(param)
                        ]
                    },
                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        name: 'FILE',
                        layout: 'fit',
                        items: [
                            {
                                xtype: 'panel',
                                layout: 'fit',
                                itemId: 'window_save_zcxx_file_panel',
                                items: [initWindow_save_zcxx_tab_upload(param)]
                            }
                        ]
                    }
                ],
                listeners: {
                    beforetabchange: function (tabPanel, newCard, oldCard) {
                        tabPanel.up('window').down('button[name=deleteZC]').setHidden(newCard.name == 'FILE');
                    }
                }
            }
        ],
        buttons: [
            {
                text: '增加', name: 'insertZC', xtype: 'button', width: 80, disabled: false,
                handler: function (btn) {
                    var form_zcxx=Ext.ComponentQuery.query('form[itemId="window_save_zcxx_form"]')[0];
                    form_zcxx.getForm().findField("ZQ_ID").getValue();
                    var a=new Object();
                    a.ZQ_ID=form_zcxx.getForm().findField("ZQ_ID").getValue();
                    a.ZQ_NAME=form_zcxx.getForm().findField("ZQ_NAME").getValue();
                    a.SY_HB_AMT=form_zcxx.getForm().findField("SY_HB_AMT").getValue();
                    a.PLAN_HB_AMT=form_zcxx.getForm().findField("PLAN_HB_AMT").getValue();
                    a.PAY_HB_AMT=form_zcxx.getForm().findField("PAY_HB_AMT").getValue();
                    a.ZQLB_ID=form_zcxx.getForm().findField("ZQLB_ID").getValue();
                    a.ZQLB_NAME=form_zcxx.getForm().findField("ZQLB_NAME").getValue();
                    var param=new Object();
                    param.initvalue=a;
                    var data = DSYGrid.getGrid('window_save_zcxx_grid').getStore().getData().items;
                    var ids = [];
                    Ext.Array.forEach(data,function (t) {
                        if(!Ext.Array.contains(ids,t.get('MX_ZQ_ID'))){
                            ids.push(t.get('MX_ZQ_ID'));
                        }
                    });
                    Ext.Ajax.request({ //发送请求查询 到期债券
                        url : '/getBjDfjhForHb.action',
                        params : {
                            AD_CODE: AD_CODE,
                            ZQ_ID : param.initvalue.ZQ_ID
                        },
                        method : 'post',
                        success : function (data) {
                            var respTest = Ext.JSON.decode(data.responseText);
                            if(respTest.success){
                                var list = respTest.list;
                                if(list && list.length > 0){
                                    var params = new Object();
                                    for (var i=0;i<list.length;i++) {
                                        var data_crmx = list[i];
                                        ids.push(data_crmx.ZQ_ID);
                                        check_dq_amt[data_crmx.ZQ_ID]=data_crmx;
                                    }
                                    params.ids=ids;
                                    params.firstpage=param;
                                    params.check_dq_amt=check_dq_amt;
                                    params.SY_DQ_AMT = a.SY_HB_AMT;
                                    var window_zwxm = initWindow_select_zwxm(params);
                                    window_zwxm.show();
                                   // btn.up('window').close();
                                }else{
                                    var params = {
                                        ids : ids
                                    };
                                    params.SY_DQ_AMT = a.SY_HB_AMT;
                                    params.firstpage=param;
                                    initWindow_select_zwxm(params).show();
                                }
                            }
                        }
                    });
                }

            },
            {
                text: '删除', name: 'deleteZC', xtype: 'button', width: 80, disabled: false,
                handler: function (btn) {
                    var grid = btn.up('window').down('grid#window_save_zcxx_grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                    resetform();
                }
            },
            {
                text: '保存',
                name: 'saveZC',
                handler: function (btn) {

                    //form表单校验：
                    var form_zcxx=Ext.ComponentQuery.query('form[itemId="window_save_zcxx_form"]')[0];
                    if (!form_zcxx.isValid()) {
                        Ext.toast({
                            html: "请检查必填项，以及未通过校验项！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }
                    var form_value_bc=form_zcxx.getForm().getValues();
                    var grid_value_bc=new Array();
                    var zcxx_grid=DSYGrid.getGrid('window_save_zcxx_grid');
                    var zcxx_grid_store=zcxx_grid.getStore();
                    var messageError="";
                    btn.setDisabled(true);
                    for(var k=0;k<zcxx_grid_store.getCount();k++){
                        var record=zcxx_grid_store.getAt(k);
                        grid_value_bc.push(record.data);
                    }
                       /* var payAllAmt=0;
                        var check_dq_amt2=new Object();  //单笔债券支出金额之和
                        var check_dq_amt3=new Object();  //单笔债券的可支出金额
                        var check_dq_amt3_xinzeng=new Object(); //修改时录入的新增金额

                    if(messageError!=null&&messageError!=undefined&&messageError!=""){
                        Ext.MessageBox.alert('提示',messageError);
                        return false;
                    }

                    var syHbAmt=Ext.ComponentQuery.query('numberFieldFormat[name="SY_HB_AMT"]')[0];
                     var allPayAmtNow=0;
                    for(var p=0;p<zcxx_grid_store.getCount();p++){
                        var record2=zcxx_grid_store.getAt(p);
                        var zq_id_temp=record2.get("ORI_ZQ_ID");
                            allPayAmtNow+=record2.get("PAY_AMT");
                        if(is_fix){
                            if(record2.get("BOOLEAN_IS_FIRST")=='0'){//修改
                                if(check_dq_amt3[zq_id_temp]==null||check_dq_amt3[zq_id_temp]==undefined){
                                    check_dq_amt3[zq_id_temp]=record2.get("PAY_AMT");
                                }else{
                                        check_dq_amt3[zq_id_temp] += record2.get("PAY_AMT");
                                }
                            }else if(record2.get("BOOLEAN_IS_FIRST")=='1'){ //新增
                                if(check_dq_amt3_xinzeng[zq_id_temp]==null||check_dq_amt3_xinzeng[zq_id_temp]==undefined){
                                    check_dq_amt3_xinzeng[zq_id_temp]=record2.get("PAY_AMT");
                                }else{
                                    check_dq_amt3_xinzeng[zq_id_temp]+=record2.get("PAY_AMT");
                                }
                            }
                        }else{
                            if(check_dq_amt3_xinzeng[zq_id_temp]==null||check_dq_amt3_xinzeng[zq_id_temp]==undefined){
                                check_dq_amt3_xinzeng[zq_id_temp]=record2.get("PAY_AMT");
                            }else{
                                    check_dq_amt3_xinzeng[zq_id_temp] += record2.get("PAY_AMT");
                            }
                        }

                        if(check_dq_amt2[zq_id_temp]==null||zq_id_temp==undefined){
                            check_dq_amt2[zq_id_temp]=record2.get("SY_DQ_AMT");
                        }
                    }
                    //判断 录入的支出金额总和不能
                    syHbAmt=syHbAmt.getValue()
                    if(is_fix){
                        syHbAmt=initFixValue+syHbAmt;
                    }
                   if(allPayAmtNow-syHbAmt>0.01){
                       Ext.MessageBox.alert('提示',"录入的支出金额总和不能大于当前再融资债券的剩余可用金额");
                       return false;
                   }
                    //单笔债券支出金额之和
                    // 单笔债券的可支出金额
                    //判断 录入的支出不能大于当前兑付计划的剩余可用金额
                    //   check_dq_amt_i_ori  保存之前每个普通债券的value；check_dq_amt_i_ori
                    if(is_fix){
                        for(var h in check_dq_amt3){
                            //未修改时的校验
                            var check_dq_amt3_temp=check_dq_amt2[h];
                            if(check_dq_amt_i_ori[h]==null||check_dq_amt_i_ori[h]==undefined){
                                check_dq_amt_i_ori[h]=0;
                                check_dq_amt3_temp=check_dq_amt3_temp+0;
                            }else{
                                check_dq_amt3_temp=check_dq_amt3_temp+check_dq_amt_i_ori[h];
                            }
                            if (check_dq_amt3_temp != null && check_dq_amt3_temp != undefined) {
                                if ((check_dq_amt3[h] - check_dq_amt3_temp) > 0.01) {
                                    messageError = "录入的支出金额不能大于当前兑付计划的剩余可用金额" + "<br>";
                                    break;
                                }
                            }
                        }
                    }else{
                        // 未更新的新校验 heck_dq_amt3_xinzeng check_dq_amt2
                        for(var ie in check_dq_amt3_xinzeng){
                            if((check_dq_amt3_xinzeng[ie]-check_dq_amt2[ie])>0.01){
                                messageError = "录入的支出金额不能大于当前兑付计划的剩余可用金额" + "<br>";
                                break;
                            }
                        }
                    }*/
                    /**
                     * 校验剩余到期金额必须等于支出合计
                     * dqZqSy 表格中到期债券 剩余和支出金额对象 key为 到期债券id
                     * zwXmZc 表格中项目债务支出金额 根据到期债券id 合计 key为到期债券id
                     */

                    var zwXmZc = {};
                    for(var i = 0; i < zcxx_grid_store.getCount(); i++){
                        var record2=zcxx_grid_store.getAt(i);
                        var zq_id_temp=record2.get("ORI_ZQ_ID"); //到期债券id
                        /*if(!dqZqSy[zq_id_temp]){
                            if(is_fix){
                                dqZqSy[zq_id_temp] = record2.get('SY_DQ_AMT2');
                            }else{
                                dqZqSy[zq_id_temp] = record2.get('SY_DQ_AMT');
                            }
                        }else{
                            if(is_fix) {
                                dqZqSy[zq_id_temp] += record2.get('SY_DQ_AMT2');
                            }
                        }*/
                        if(!zwXmZc[zq_id_temp]){
                            zwXmZc[zq_id_temp] = Number(record2.get('PAY_AMT'));
                        }else{
                            zwXmZc[zq_id_temp] += Number(record2.get('PAY_AMT'));
                        }
                    }
                    for(var o in dqZqSy){
                        if(zwXmZc[o] - dqZqSy[o]['SY_DQ_AMT']  > 0.01){
                            // 定位到是哪一笔债券
                            if(messageError.indexOf('支出金额合计不能大于所选到期债券的可支出额度') == -1){
                                messageError += '支出金额合计不能大于所选到期债券的可支出额度' + '</br>'
                                messageError += '其中：';
                            }else{
                                messageError += '　　　';
                            }
                            messageError += '【' +  dqZqSy[o]['ZQ_NAME'] + '】' + '超额['
                                + Math.abs(accSub(dqZqSy[o]['SY_DQ_AMT'],zwXmZc[o]).toFixed(2)) + '元' + ']<br>';

                        }
                    }
                    if(form_value_bc.PAY_AMT_TOTAL - form_value_bc.SY_HB_AMT >  0.01){
                        messageError += '支出总额不能大于再融资债券可支出金额！';
                    }
                    if(messageError!=null&&messageError!=undefined&&messageError!=""){
                        Ext.MessageBox.alert('提示',messageError);
                        btn.setDisabled(false);
                        return false;
                    }
                    //发送ajax请求，保存表格数据
                    $.post('/insertHborZc.action', {
                        WF_STATUS:WF_STATUS,
                        NODE_TYPE:node_type,
                        NODE_CODE:node_code,
                        WF_ID:wf_id,
                        FORM_DATA:Ext.util.JSON.encode(form_value_bc),
                        GRID_DATA:Ext.util.JSON.encode(grid_value_bc),
                        USER_CODE:USERCODE,
                        AD_CODE:AD_CODE,
                        BUTTON_NAME:button_status
                }, function (data) {
                        if (data.success) {
                            closeFinalWindow();
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            reloadGrid();
                        } else {
                            btn.setDisabled(false);
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        }

                    }, "json");
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    var windows=Ext.ComponentQuery.query('window[itemId="window_select_hbzclr"]')[0];
                    windows.close();
                }
            }
        ]
    };
    if (!param.editable) {
        delete windows_config.buttons;
        delete windows_config.items[0].listeners;
    }
   return Ext.create('Ext.window.Window',windows_config);
}
function closeFinalWindow() {
    var windows=Ext.ComponentQuery.query('window[itemId="window_select_hbzclr"]')[0];
    windows.close();
}



/**
 * 初始化债券：转贷明细选择弹出框表格
 */
function initWindow_select_hbzq_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
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
                paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1]=encodeURIComponent(AD_CODE.replace(/00$/, ""));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {text: "债券ID", dataIndex: "ZQ_ID", width: 150, type: "string", hidden: debuggers},
        {text: "可支出金额(元)", dataIndex: "SY_HB_AMT", width: 150, type: "float" },
        {text: "合计", dataIndex: "PLAN_AMT", width: 150, type: "float", hidden: debuggers},
        {text: "债券总额(元)", dataIndex: "PLAN_HB_AMT", width: 150, type: "float" },
        // {text: "已转贷金额(元)", dataIndex: "HB_AMT", width: 150, type: "float" },
        {text: "已支出金额(元)", dataIndex: "PAY_HB_AMT", width: 150, type: "float" },
        {text: "债券类型编码", dataIndex: "ZQLB_ID", type: "string", width: 130,hidden: debuggers},
        {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 130},
        {text: "债券简称", dataIndex: "ZQ_JC", width: 150, type: "string"},
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 200}
        ];
    var grid = DSYGrid.createGrid({
        itemId: 'window_select_zdmx_grids',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        checkBox: true,
        border: false,
        height: '100%',
        flex: 1,
        params: {
            AD_CODE: AD_CODE
        },
        pageConfig: {
            enablePage: true
        },
        dataUrl: '/getDfjhYzcGrid.action',
        tbar: [
        {
            fieldLabel: '模糊查询',
            xtype: "textfield",
            name: 'contentGrid_search11',
            itemId: 'contentGrid_search11',
            width: 320,
            labelWidth: 60,
            labelAlign: 'right',
            enableKeyEvents: true,
            emptyText: '请输入债券名称...',
            listeners: {
                keypress: function (self, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        var store = self.up('grid').getStore();
                        store.getProxy().extraParams['ZQ_NAME'] = self.getValue();
                        // 刷新表格
                        store.loadPage(1);
                    }
                }
            }
        },
            {
                xtype: "treecombobox",
                name: "contentGrid_search12",
                itemId:"contentGrid_search12",
                store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                displayField: "name",
                valueField: "id",
                fieldLabel: '债券类型',
                editable: false, //禁用编辑
                labelWidth: 70,
                width: 180,
                labelAlign: 'right',
                listeners: {
                    select: function (self, newValue) {
                        var contentGrid_search12 = Ext.ComponentQuery.query('treecombobox[itemId="contentGrid_search12"]')[0];
                        var store = self.up('grid').getStore();
                        store.getProxy().extraParams['ZQ_TYPE'] = contentGrid_search12.getValue();
                        // 刷新表格
                        store.loadPage(1);
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'search',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var store = btn.up('grid').getStore();
                    var $a=Ext.ComponentQuery.query('textfield[itemId="contentGrid_search11"]')[0];
                    var $b=Ext.ComponentQuery.query('treecombobox[itemId="contentGrid_search12"]')[0];
                    if($a!=null&&$a!=undefined){
                        store.getProxy().extraParams['ZQ_NAME'] = $a.getValue();
                    }
                    if($b!=null&&$b!=undefined){
                        store.getProxy().extraParams['ZQ_TYPE'] = $b.getValue();
                    }
                    // 刷新表格
                    store.load();
                }
            }
        ]
    });
    return grid;
}

//项目债务信息
function initXmZwGridForHb(param) {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            text: "债券ID", dataIndex: "ZQ_ID", type: "string", width: 150,hidden:debuggers/*,
         renderer: function (value, metaData, record) {
         if (value < dsyDateFormat(new Date()))
         metaData.css = 'x-grid-back-green';
         return value;
         }*/
        },
        /*{text:"项目剩余可支出",dataIndex:"XMSY_AMT",type:"float"},
        {text:"债务剩余可支出",dataIndex:"ZWSY_AMT",type:"float"},*/
        {text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 200,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE.replace(/00$/, "");
                 return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="ZQ_ID";
                paramNames[1]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1]=encodeURIComponent(AD_CODE.replace(/00$/, ""));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }},
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 200},
        {text: "支出类型", dataIndex: "ZC_TYPE_NAME", type: "string", width: 200},
        {text: "原支出类型", dataIndex: "ORI_ZC_TYPE", type: "string", hidden: true},
        {text: "支出类型id", dataIndex: "ZC_TYPE", type: "string", width: 200,hidden:debuggers},
        {text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 200,
            renderer: function (data, cell, record) {
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
            },
        {text: "项目id",  dataIndex: "XM_ID", type: "string", width: 200,hidden:debuggers},
        {text: "债务名称", dataIndex: "ZW_NAME", type: "string", width: 200,
            renderer: function (data, cell, record) {
                /*var hrefUrl =  '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                 return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }},
        {text: "债务编码", dataIndex: "ZW_CODE", type: "string", width: 200,hidden:debuggers},
        {text: "债务id",  dataIndex:  "ZW_ID", type: "string", width: 200,hidden:debuggers},
        {text: '偿还计划id', dataIndex:"CHJH_ID",type:"string",width:200,hidden:debuggers},
        {text: "单位ID",  dataIndex:  "AG_ID", type: "string", width: 200,hidden:debuggers},
        {text: "单位名称",  dataIndex:  "AG_NAME", type: "string", width: 200,hidden:false},
        {text: "单位code",  dataIndex:  "AG_CODE", type: "string", width: 200,hidden:debuggers},
        {text: "置换金额",  dataIndex:  "ZW_PAY_AMT", type: "float", width: 200},
        {text: "新增债券项目支出金额",  dataIndex:  "XM_PAY_AMT", type: "float", width: 200},/*,
        {text: "支出日期",  dataIndex:  "PAY_DATE", type: "string", width: 200}*/
        {text: "再融资支出金额",  dataIndex:  "ZRZ_PAY_AMT", type: "float", width: 200},
    ];
    var search_form = initWindow_xzzq_grid_searchTool();
    return DSYGrid.createGrid({
        itemId: 'window_select_xmzw_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: true,
        height: '100%',
        flex: 1,
       // dockedItems: [search_form],
        params: {
            AD_CODE: AD_CODE,
            ZQ_IDS  : param.ids
        },
        dataUrl: '/getXmZwForHb.action',
        pageConfig : {
            enablePage : true,
            pageNum: true
        },
        tbar: [
            {
                fieldLabel: '模糊查询',
                xtype: "textfield",
                name: 'contentGrid_search3',
                itemId: 'contentGrid_search3',
                width: 320,
                labelWidth: 60,
                labelAlign: 'right',
                enableKeyEvents: true,
                emptyText: '请输入债务名称/项目名称...',
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var store = self.up('grid').getStore();
                            store.getProxy().extraParams['ZQ_NAME_CODE'] = self.getValue();
                            // 刷新表格
                            store.loadPage(1);
                        }
                    }
                }
            },
            {
                fieldLabel: '支出类型',
                xtype: "combobox",
                store:  DebtEleStore(json_xmlx_1),
                name: 'XM_LX',
                itemId: 'contentGrid_search32',
                width: 320,
                displayField: "name",
                valueField: "id",
                labelWidth: 60,
                enableKeyEvents: true,
                listeners: {
                    select: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var store = self.up('grid').getStore();
                            store.getProxy().extraParams['XM_ZW_LX'] = self.getValue();
                            // 刷新表格
                            store.loadPage(1);
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'search',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var store = btn.up('grid').getStore();
                    var $a=Ext.ComponentQuery.query('textfield[itemId="contentGrid_search3"]')[0];
                    var $b=Ext.ComponentQuery.query('textfield[itemId="contentGrid_search32"]')[0];
                    if($a!=null&&$a!=undefined){
                        store.getProxy().extraParams['ZQ_NAME_CODE'] = $a.getValue();
                    }
                    if($b!=null&&$b!=undefined){
                        store.getProxy().extraParams['XM_ZW_LX'] = $b.getValue();
                    }
                    // 刷新表格
                    store.load();
                }
            }
        ]
    });
}
function  initWindow_select_zwxm(param) {
    return Ext.create('Ext.window.Window',{
        title: '选择关联的项目债务信息', // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        itemId: 'window_select_xmzwxx', // 窗口标识
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [
            initXmZwGridForHb(param)
        ],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请至少选择一条数据后再进行操作');
                        return;
                    }
                    var glxmxx=new Object();
                    for (var i=0;i<records.length;i++) {
                        if(glxmxx[records[i].data.ZQ_ID]!=null&&glxmxx[records[i].data.ZQ_ID]!=undefined){
                           if(glxmxx[records[i].data.ZQ_ID] instanceof Array){
                               glxmxx[records[i].data.ZQ_ID].push(records[i].data);
                           }
                        }else {
                            var array_temp=new Array();
                            array_temp.push(records[i].data);
                            glxmxx[records[i].data.ZQ_ID]=array_temp;
                        }

                    }
                    param.havenChoose=glxmxx;

                    var zcd_id=GUID.createGUID(); // 生成guid
                    param.gridId=zcd_id;
                    var form_goal =Ext.ComponentQuery.query('window[itemId="window_select_hbzclr"]')[0];
                    if(form_goal!=null&&form_goal!=undefined){
                        form_goal.show();
                        closeAllWindows();
                    }else{
                        initWindow_select_final(param).show();
                        closeAllWindows();
                    }
                    SetFormData(param,false);
                    SetGridData(param,false);
                    resetform();
                   // select_zhmx();
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
 * 初始化置换债券债务约定还本(债务还款计划)选择弹出窗口
 */
function initWindow_select_dfjhmx(a) {
    return Ext.create('Ext.window.Window', {
        title: '本金的转贷还款计划', // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        itemId: 'window_select_dfjhmx', // 窗口标识
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [
            initWindow_select_dfjhmx_grid(a)
        ],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请至少选择一条数据后再进行操作');
                        return;
                    }
                    var param=new Object();
                    var ids=new Array();
                    var check_dq_amt=new Object();
                    for (var i=0;i<records.length;i++) {
                        var data_crmx = records[i].getData();
                        ids.push(data_crmx.ZQ_ID);
                        check_dq_amt[data_crmx.ZQ_ID]=data_crmx;
                    }
                    param.ids=ids;
                    param.firstpage=a;
                    param.check_dq_amt=check_dq_amt;
                    initWindow_select_zwxm(params).show();
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

//到期金额校验对象，key:本金的zq_id,Value:record
var check_dq_amt=new Object();



/**
 * 初始化本金的兑付计划
 */
function initWindow_select_dfjhmx_grid(param) {
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {
            text: "债券ID", dataIndex: "ZQ_ID", type: "string", width: 150, hidden:debuggers/*,
            renderer: function (value, metaData, record) {
                if (value < dsyDateFormat(new Date()))
                    metaData.css = 'x-grid-back-green';
                return value;
            }*/
        },
        {text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 200,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE.replace(/00$/, "");
                 return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="ZQ_ID";
                paramNames[1]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1]=encodeURIComponent(AD_CODE.replace(/00$/, ""));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 200},
        {text: "到期日期", dataIndex: "DF_END_DATE", type: "string", width: 120},
        {text: "再融资债券发行金额(元)",   dataIndex: "FX_HB_AMT", type: "float", width: 160,hidden:debuggers},
        {text: "再融资债券金额(元)",      dataIndex: "PLAN_HB_AMT", type: "float", width: 160,hidden:debuggers},
        {text: "本地区承担的总金额(元)", dataIndex: "CD_AMT", type: "float", width: 200,hidden:debuggers  },
        {text:"到期金额(元)",dataIndex:"DQ_AMT",type:"float",width:160},
        {text:"可支出金额(元)",dataIndex:"SY_DQ_AMT",type:"float",width:160}
    ];
    var search_form = initWindow_xzzq_grid_searchTool();
    return DSYGrid.createGrid({
        itemId: 'window_select_dfjhmx_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: true,
        height: '100%',
        flex: 1,
      //  dockedItems: [search_form],
        params: {
            AD_CODE: AD_CODE,
            ZQ_ID : param.initvalue.ZQ_ID
        },
        dataUrl: '/getBjDfjhForHb.action',
        tbar: [
            {
                fieldLabel: '模糊查询',
                xtype: "textfield",
                name: 'contentGrid_search21',
                itemId: 'contentGrid_search21',
                width: 320,
                labelWidth: 60,
                labelAlign: 'right',
                enableKeyEvents: true,
                emptyText: '请输入债券名称/债券编码...',
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var store = self.up('grid').getStore();
                            store.getProxy().extraParams['ZQ_NAME_CODE'] = self.getValue();
                            // 刷新表格
                            store.loadPage(1);
                        }
                    }
                }
            },
            {
                xtype: "treecombobox",
                store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                displayField: "name",
                valueField: "id",
                fieldLabel: '债券类型',
                editable: false, //禁用编辑
                name: 'contentGrid_search22',
                itemId: 'contentGrid_search22',
                labelWidth: 70,
                width: 180,
                labelAlign: 'right',
                listeners: {
                    select: function (self, newValue) {
                        var $b=Ext.ComponentQuery.query('treecombobox[itemId="contentGrid_search22"]')[0];
                        var store = self.up('grid').getStore();
                        store.getProxy().extraParams['ZQ_TYPE'] = $b.getValue();
                        // 刷新表格
                        store.loadPage(1);
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                name: 'search',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var store = btn.up('grid').getStore();
                    var $a=Ext.ComponentQuery.query('textfield[itemId="contentGrid_search21"]')[0];
                    var $b=Ext.ComponentQuery.query('treecombobox[itemId="contentGrid_search22"]')[0];
                    if($a!=null&&$a!=undefined){
                        store.getProxy().extraParams['ZQ_NAME_CODE'] = $a.getValue();
                    }
                    if($b!=null&&$b!=undefined){
                        store.getProxy().extraParams['ZQ_TYPE'] = $b.getValue();
                    }
                    // 刷新表格
                    store.load();
                }
            }
        ]

    });
}
/**
 * 初始化置换债券债务约定还本(债务还款计划)选择弹出框搜索区域
 */
function initWindow_xzzq_grid_searchTool() {
    //初始化查询控件
    var items = [
        {
            xtype: "combobox",
            name: "HKJH_YEAR",
            store: DebtEleStore(json_debt_year),
            displayField: "name",
            valueField: "id",
            fieldLabel: '到期年月',
            editable: false, //禁用编辑
            labelWidth: 60,
            width: 180
        },
        {
            xtype: "combobox",
            name: "HKJH_MO",
            store: DebtEleStore(json_debt_yf),
            displayField: "name",
            valueField: "id",
            //value: lpad(1 + new Date().getUTCMonth(), 2),
            editable: false, //禁用编辑
            width: 85
        },
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            name: 'contentGrid_search',
            itemId: 'contentGrid_search',
            //width: 220,
            columnWidth:.64,
            labelWidth: 60,
            labelAlign: 'right',
            enableKeyEvents: true,
            emptyText: '请输入债务名称/项目名称/债权人全称/债务编码/协议号...',
            listeners: {
                keypress: function (self, e) {
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        var form = self.up('form');
                        if (form.isValid()) {
                            callBackReload(form);
                        } else {
                            Ext.Msg.alert("提示", "查询区域未通过验证！");
                        }
                    }
                }
            }
        }];
    //设置查询form
    var searchTool = new DSYSearchTool();
    searchTool.setSearchToolId('window_select_zhmx_grid_searchTool');
    var search_form = searchTool.create({
        items: items,
        border: true,
        xtype: 'toolbar',
        bodyStyle: 'border-width:0 0 0 0;',
        dock: 'top',
        defaults: {
            labelWidth: 0,
            labelAlign: 'right',
            margin: '5 5 5 5',
            width: 250
        },
        // 查询按钮回调函数
        callback: function (self) {
            callBackReload(self);
        }
    });
    //重新加载按钮
    search_form.remove(search_form.down('toolbar'));
    search_form.addDocked({
        xtype: 'toolbar',
        border: false,
        width: 140,
        dock: 'right',
        layout: {
            type: 'hbox',
            align: 'middle',
            pack: 'end'
        },
        padding: '0 10 0 0',
        items: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    if (form.isValid()) {
                        callBackReload(form);
                    } else {
                        Ext.Msg.alert("提示", "查询区域未通过验证！");
                    }
                }
            },
            '->', {
                xtype: 'button',
                text: '重置',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var form = btn.up('form');
                    form.reset();
                }
            }
        ]
    });
    function callBackReload(self) {
        var formValue = self.getValues();
        if (self.down('combobox[name="HKJH_YEAR"]').isDisabled()) {
            formValue.HKJH_YEAR = '';
            formValue.HKJH_MO = '';
        }
        var store = self.up('grid').getStore();
        // 清空参数中已有的查询项
        for (var search_form_i in formValue) {
            delete store.getProxy().extraParams[search_form_i];
        }
        // 向grid中追加参数
        $.extend(true, store.getProxy().extraParams, formValue);
        // 刷新表格
        store.loadPage(1);
    }

    return search_form;
}


/**
 * 初始化债券填报表单中页签panel的附件页签
 */
function initWindow_save_zcxx_tab_upload(config) {
    var grid = UploadPanel.createGrid({
        busiType: 'ET207',//业务类型
        busiId: config.gridId,//业务ID
        editable: config.editable,//是否可以修改附件内容
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
 * 树点击节点时触发，刷新content主表格
 */
function reloadGrid(param) {
    var grid = DSYGrid.getGrid('contentGrid');
    var ZQ_ID = Ext.ComponentQuery.query('combobox[name="ZQ_NAME"]')[0].getValue();
    var store = grid.getStore();
    store.getProxy().extraParams['ZQ_ID'] = ZQ_ID;
    //增加查询参数
    if(AD_CODE==''||AD_CODE==null){
        AD_CODE=USER_AD_CODE;
    }
    if(AG_CODE==''||AG_CODE==null){
        AG_CODE=USER_AG_CODE;
    }
    store.getProxy().extraParams["AD_CODE"] = AD_CODE;
    store.getProxy().extraParams["AG_CODE"] = AG_CODE;
    if (typeof param != 'undefined' && param != null) {
        for (var name in param) {
            store.getProxy().extraParams[name] = param[name];
        }
    }
    //刷新
    store.loadPage(1);
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
        btn.setDisabled(false);
        return;
    }
    var ids = new Array();
    var pay_dates = new Array();
    for (var i in records) {
        ids.push(records[i].get("ZCD_ID"));
        pay_dates.push(records[i].get("PAY_DATE"));
    }
    button_name = btn.text;
    var opValue = '';
    if (button_name == '送审') {
        opValue = '确定送审';
    } else if (btn.name == 'up') {
        opValue = '';
    } else {
        opValue = '同意';
    }
    if (button_name == '送审') {
    	Ext.Msg.confirm('提示', '请确认是否'+button_name+'!', function (btn_confirm) {
    		if (btn_confirm === 'yes') {
    			//发送ajax请求，修改节点信息
                $.post("/updateHbzqNode.action", {
                    workflow_direction: btn.name,
                    WF_STATUS:WF_STATUS,
                    NODE_TYPE:node_type,
                    NODE_CODE:node_code,
                    WF_ID:wf_id,
                    ZC_TYPE: ZC_TYPE,
                    AD_CODE:AD_CODE,
                    BUTTON_NAME: button_name,
                    audit_info: '',
                    ids: Ext.util.JSON.encode(ids)
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
    }else {
	    //弹出意见填写对话框
	    initWindow_opinion({
	        title: btn.text,
	        animateTarget: btn,
	        value: opValue,
	        fn: function (buttonId, text) {
	            if (buttonId === 'ok') {
	                //发送ajax请求，修改节点信息
	                $.post("/updateHbzqNode.action", {
                        workflow_direction: btn.name,
                        WF_STATUS:WF_STATUS,
                        NODE_TYPE:node_type,
                        NODE_CODE:node_code,
                        WF_ID:wf_id,
                        ZC_TYPE: ZC_TYPE,
                        AD_CODE:AD_CODE,
                        BUTTON_NAME: button_name,
                        audit_info: '',
                        ids: Ext.util.JSON.encode(ids),
                        pay_dates: Ext.util.JSON.encode(pay_dates)
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
	        }
	    });
    }
    btn.setDisabled(false);
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
