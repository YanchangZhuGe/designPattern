/**
 * js：还本付息资金申请，还本付息录入
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
var selectId;
var btnText;
$.extend(hbfx_json_common[wf_id][node_type], {
    defautItems: WF_STATUS,//默认状态
    items_content: function () {
        return [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧2个表格
        ];
    },
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '还本录入',
                icon: '/image/sysbutton/input.png',
                handler: function (btn) {
//                    var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
//                    var tree_selected = tree_area.getSelection();
//                    if (!tree_selected || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
//                        Ext.MessageBox.alert('提示', '请选择一个底级单位再进行操作');
//                        return false;
//                    }
                    button_name = "新增";
                    TITLE = '还本付息录入';
                    btnText = btn.text;//记录按钮名称
                    isModify = '0';
                    IS_WF = "1";
                    isHuanBen = '0';
                    selectId = new Array();
                    HbfxlxStore = DebtEleStore(json_debt_hbfxlx);
                    ChbjTypeStore = DebtEleStore(json_debt_chbjtype);
                    store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: condition});
                    window_dqzw_yjh.show();
                    DSYGrid.getGrid('grid_dqzw_yjh').getStore().loadPage(1);
                }
            }, {
                xtype: 'button',
                text: '付息录入',
                icon: '/image/sysbutton/add.png',
                hidden: ZW_HBFX_MODE == 0 ? true : false,
                handler: function (btn) {
                    //校验是否选中区划叶子节点
//                    var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
//                    var tree_selected = tree_area.getSelection();
//                    if (!tree_selected || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
//                        Ext.MessageBox.alert('提示', '请选择一个底级单位再进行操作');
//                        return false;
//                    }
                    button_name = "新增";
                    TITLE = '付息录入';
                    btnText = btn.text;//记录按钮名称
                    // TITLE = '偿债资金申请单（付息）';
                    isModify = '0';
                    IS_WF = "1";
                    isHuanBen = '0';
                    selectId = new Array();
                    HbfxlxStore = DebtEleStore(json_debt_hbfxlx);
                    ChbjTypeStore = DebtEleStore(json_debt_chbjtype);
                    store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: condition});
                    window_dqzw_yjh.show();
                    DSYGrid.getGrid('grid_dqzw_yjh').getStore().loadPage(1);
                }
            },
            {
                xtype: 'button',
                text: ZW_HBFX_MODE == 0 ? '付息录入' : '其他录入',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    //校验是否选中区划叶子节点
//                    var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
//                    var tree_selected = tree_area.getSelection();
//                    if (!tree_selected || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
//                        Ext.MessageBox.alert('提示', '请选择一个底级单位再进行操作');
//                        return false;
//                    }

                    button_name = "新增";
                    if (ZW_HBFX_MODE == 0) {
                        TITLE = '偿债资金申请单（付息）';
                    } else {
                        TITLE = '偿债资金申请单（其他）';
                    }

                    isModify = '0';
                    IS_WF = "1";
                    isHuanBen = '1';
                    selectId = new Array();
                    store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: condition});
                    HbfxlxStore = DebtEleStore(json_debt_hbfxlx1);
                    ChbjTypeStore = DebtEleStore(json_debt_chbjtype);
                    window_dqzw_wjh.show();
                    DSYGrid.getGrid('grid_dqzw_wjh').getStore().loadPage(1);
                }
            },
            {
                xtype: 'button',
                text: '还本红冲',
                hidden:zwlb_id=='2',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    button_name = "新增";
                    TITLE = '还本红冲录入';
                    IS_WF = "1";
                    selectId = new Array();
                    store_DEBT_ZJLY = DebtEleTreeStoreDBTable('dsy_v_ele_zjly_hbfx');
                    HbfxlxStore = DebtEleStore(json_debt_hbfxlx1);
                    ChbjTypeStore = DebtEleStore(json_debt_chbjtype);
                    window_dqzw_hbhc.show();
                    DSYGrid.getGrid('grid_dqzw_hbhc').getStore().loadPage(1);
                }
            },
            {
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    button_name = btn.text;
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    AG_ID = records[0].get("AG_ID");
                    HbfxlxStore = DebtEleStore(json_debt_hbfxlx);
                    ChbjTypeStore = DebtEleStore(json_debt_chbjtype);
                    store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: condition});
                    //发送ajax请求，查询主表和明细表数据
                    $.post("/getChbjGridById.action", {
                        id: records[0].get('CHBJ_ID')
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        isModify = '1';
                        IS_WF = "1";
                        isHuanBen = '0';
                        if(records[0].data.HOLD2=="正常录入") {
                            TITLE = '偿债资金申请单修改';
                            window_debt_add_apply.show({
                                gridId: records[0].get('CHBJ_ID')
                            });
                            DSYGrid.getGrid('debt_add_apply_grid').insertData(null, data.data);
                            Ext.ComponentQuery.query('form[itemId="window_debt_add_apply_form"]')[0].getForm().setValues(data);
                        }else {
                            CHBJ_ID=records[0].data.CHBJ_ID;
                            TITLE='还本红冲修改';
                            chooseHbhcWindow.show();
                            //换算金额单位并插入表格
                            numberFormat(data.data[0]);
                        }
                    }, "json");
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    Ext.Msg.alert('提示', '您确定要删除么？');
                    button_name = btn.text;
                    delHbfxDataSelectedList(btn);
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'send',
                icon: '/image/sysbutton/submit.png',
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
                handler: function (btn) {
                    button_name = btn.text;
                    dooperation();
                }
            }
            ,
            /*{
                xtype:'form',
                //itemId:'form_upload_id',
                name:'form_upload_name',
                fileUpload: true,
                border: false,
                baseCls: 'my-panel-no-border',
                items:[
                    {
                        xtype: 'filefield',
                        buttonText: '<span style="color: black">导入还本付息</span>',
                        //itemId: "uploady",
                        name: 'upload',
                        buttonOnly: true,
                        padding: '0 0 0 0',
                        margin: '0 0 0 0',
                        hideLabel: true,
                        buttonConfig: {
                            icon: '/image/sysbutton/projectnew.png',
                            style:{
                                "border-color":'#D8D8D8',
                                background:'#f6f6f6'
                            }
                        },
                        listeners: {
                            change: function (fb, v) {
                                var form = this.up('form').getForm();
                                uploadHbfxFile(form);
                            }
                        }
                    }
                ] },*/
            fileuploadbutton(),
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '002': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '撤销送审',
                name: 'cancel',
                icon: '/image/sysbutton/back.png',
                handler: function (btn) {
                    button_name = btn.text;
                    cancleCheck(btn);
                   /* Ext.MessageBox.show({
||||||| .r5950
                    Ext.MessageBox.show({
=======
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        return false;
                    }
                    Ext.MessageBox.show({
>>>>>>> .r5977
                        title: '提示',
                        msg: "是否撤销选择的记录？",
                        width: 200,
                        buttons: Ext.MessageBox.OKCANCEL,
                        fn: function (btn) {
                            button_name = btn.text;
                            if (btn == "ok") {
                                cancleCheck(btn);
                            }
                        }
                    });*/
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    button_name = btn.text;
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
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    // 检验是否选中数据
                    button_name = btn.text;
                    // 获取选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                        return;
                    }
                    ChbjTypeStore = DebtEleStore(json_debt_chbjtype);
                    HbfxlxStore = DebtEleStore(json_debt_hbfxlx);
                    store_DEBT_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: condition});
                    /*AD_CODE = records[0].get("AD_CODE");
                     AD_NAME = records[0].get("AD_NAME");
                     AG_CODE = records[0].get("AG_CODE");
                     AG_NAME = records[0].get("AG_NAME");*/
                    AG_ID = records[0].get("AG_ID");
                    //发送ajax请求，查询主表和明细表数据
                    $.post("/getChbjGridById.action", {
                        id: records[0].get('CHBJ_ID')
                    }, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        isModify = '1';
                        IS_WF = "1";
                        isHuanBen = '0';
                        if(records[0].data.HOLD2=="正常录入") {
                            TITLE = '偿债资金申请单修改';
                            window_debt_add_apply.show({
                                gridId: records[0].get('CHBJ_ID')
                            });
                            DSYGrid.getGrid('debt_add_apply_grid').insertData(null, data.data);
                            Ext.ComponentQuery.query('form[itemId="window_debt_add_apply_form"]')[0].getForm().setValues(data);
                        }else {
                            CHBJ_ID=records[0].data.CHBJ_ID;
                            TITLE='还本红冲修改';
                            chooseHbhcWindow.show();
                            //换算金额单位并插入表格
                            numberFormat(data.data[0]);
                        }
                    }, "json");
                }
            },
            {
                xtype: 'button',
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    Ext.Msg.alert('提示', '您确定要删除么？');
                    button_name = btn.text;
                    delHbfxDataSelectedList(btn);
                }
            },
            {
                xtype: 'button',
                text: '送审',
                icon: '/image/sysbutton/submit.png',
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
                handler: function (btn) {
                    button_name = btn.text;
                    dooperation();
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
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        getHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'log',
                icon: '/image/sysbutton/log.png',
                handler: function (btn) {
                    button_name = btn.text;
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
});
//导入还本付息文件
function uploadHbfxFile(form) {
    var dataUrl = form.getForm().findField('upload').getValue();
    var arr = dataUrl.split('.');
    var fileType = arr[arr.length - 1].toLowerCase();
    if (fileType != 'rar' && fileType != 'zip') {
        Ext.MessageBox.alert('提示', '文件格式不正确！');
        form.remove("uploady",true);
        form.add(fileuploadbutton());
        return;
    }
    var parameters = {
        wf_id: wf_id,
        node_code: node_code,
        button_name: "导入还本付息",
        AD_CODE: AD_CODE,
        // PAY_DATE:PAY_DATE,
        CREATE_DATE: dsyDateFormat(today),
        IS_WF: "1"
    };
    form.submit({
        params: parameters,
        clientValidation:false,
        url: '/importCompressedFile.action',
        waitTitle: '请等待',
        waitMsg: '正在导入中...',
        success: function (form, action) {
            if (action.result.success) {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: "导入成功",
                    maxWidth: 400,
                    minWidth:200,
                    buttons: Ext.Msg.OK,
                    fn: function (btn) {
                    }
                });
                reloadGrid();
            } else {
                Ext.MessageBox.show({
                    title: '提示',
                    msg: action.result.message,
                    maxWidth: 400,
                    minWidth:200,
                    buttons: Ext.Msg.OK,
                    fn: function (btn) {
                    }
                });
            }
        },
        failure: function (form, action) {
            Ext.MessageBox.show({
                title: '提示',
                msg: "导入失败!  </br>" + action.result.message,
                maxWidth: 550,
                minWidth:200,
                buttons: Ext.Msg.OK,
                fn: function (btn) {
                }
            });
        }

    });
}
//创建导入还本付息按钮
function fileuploadbutton() {
    return {
        xtype:'form',
        itemId:'form_upload_id',
        name:'form_upload_name',
        hidden:IS_SHOW_SPEC_UPLOAD_BTN==0?true:false,
        //fileUpload: true,
        enctype:'multipart/form-data;charset=UTF-8',
        border: false,
        baseCls: 'my-panel-no-border',
        width: 106,
        items:[
            {
                xtype: 'filefield',
                buttonText: '<span style="color: black">导入还本付息</span>',
                itemId: "uploady",
                name: 'upload',
                buttonOnly: true,
                padding: '0 0 0 0',
                hidden: zwlb_id == '02'?false:true,
                margin: '0 0 0 0',
                hideLabel: true,
                buttonConfig: {
                    icon: '/image/sysbutton/import.png',
                    style:{
                        "border-color":'#D8D8D8',
                        background:'#f6f6f6'
                    }
                },
                listeners: {
                    change: function (fb, v) {
                        var form = this.up('form');
                        uploadHbfxFile(form);
                        reloadGrid();
                    }
                }
            }
        ] };
}
//创建选择到期债务(有计划)弹出窗口
var window_dqzw_yjh = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_dqzw_yjh();
        }
        this.window.show();
    }
};
//创建选择到期债务(无计划)弹出窗口
var window_dqzw_wjh = {
    window: null,
    show: function () {
        if (!this.window) {
            this.window = initWindow_dqzw_wjh();
        }
        this.window.show();
    }
};
//创建新增偿还资金申请单弹出窗口
var window_debt_add_apply = {
    window: null,
    show: function (config) {
        if (!this.window) {
            this.window = initWindow_debt_add_apply(config);
        }
        this.window.show();
    }
};
/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 40},
        {dataIndex: "HOLD2", width: 150, type: "string", text: "录入类型"},
        {dataIndex: "AG_CODE", width: 100, type: "string", text: "单位编码"},
        {dataIndex: "AG_NAME", width: 200, type: "string", text: "单位名称"},
        {dataIndex: "CHBJ_CODE", width: 230, type: "string", text: "申请单号"},
        {dataIndex: "PAY_AMT_RMB", width: 180, type: "float", text: zwlb_id == 'wb' ? "还款金额(原币)" : "还款金额(元)"},
        {dataIndex: "PAY_AMT_RMB_BJ", width: 180, type: "float", text: "其中本金"},
        {dataIndex: "PAY_AMT_RMB_LX", width: 180, type: "float", text: "其中利息费用"},
        {dataIndex: "CREATE_DATE", width: 100, type: "string", text: "录入日期", hidden: true},
        {dataIndex: "SIGN_NAME", width: 110, type: "string", text: "是否提前还款", align: 'center', hidden: true},
        {dataIndex: "REMARK", width: 250, type: "string", text: "备注"}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        height: '50%',
        flex: 1,
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'contentGrid_status',
                store: DebtEleStore(json_debt_zt1),
                width: 110,
                labelWidth: 30,
                labelAlign: 'right',
                displayField: "name",
                allowBlank: false,
                editable: false,
                valueField: "code",
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(hbfx_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        if (AD_CODE == null || AD_CODE == '') {
                            return;
                        }
                        reloadGrid();
                    }
                }
            },
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                name: 'contentGrid_search',
                width: 300,
                hidden: true,
                labelWidth: 60,
                labelAlign: 'left',
                emptyText: '请输入单位名称/单位编码...'
            },
            {
                xtype: 'combobox',
                fieldLabel: '是否提前还款',
                width: 170,
                labelWidth: 100,
                labelAlign: 'left',
                name: 'is_tqhk',
                displayField: 'name',
                valueField: 'id',
                rootVisible: true,
                allowBlank: false,
                lines: false,
                editable: false, //禁用编辑
                selectModchangel: 'leaf',
                store: DebtEleStore(json_debt_sf_all),
                value: '\%',
                listeners: {//加监听事件
                    change: function (self, newValue) {
                        reloadGrid();
                    }
                },
                hidden: true
            }
        ],
        params: {
            wf_status: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code
        },
        autoLoad: false,
        dataUrl: 'getHbfxDataList.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {

                ChbjTypeStore = DebtEleStore(json_debt_chbjtype);
                //发送ajax请求，查询主表和明细表数据
                $.post("/getChbjGridById.action", {
                    id: record.get('CHBJ_ID')
                }, function (data) {
                    if (!data.success) {
                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                        return;
                    }
                    if(record.data.HOLD2=='红冲录入'){
                        CHBJ_ID=record.data.CHBJ_ID;
                        TITLE='还本红冲查看';
                        chooseHbhcWindow.show();
                        //换算金额单位并插入表格
                        numberFormat(data.data[0]);
                        Ext.ComponentQuery.query('button[name="OK"]')[0].setHidden(true);
                        Ext.ComponentQuery.query('button[name="CLOSE"]')[0].setHidden(true);
                    }else {
                        TITLE = '偿债资金申请单信息查看';
                        window_debt_view_apply.show({
                            gridId: record.get('CHBJ_ID')
                        });
                        window_debt_view_apply.window.down('form#window_debt_view_apply_form').down('grid#debt_view_apply_grid').insertData(null, data.data);
                        window_debt_view_apply.window.down('form#window_debt_view_apply_form').getForm().setValues(data);
                    }
                }, "json");
            }
        }
    });
    return grid;
}
/**
 * 简单的换算单位方法
 * @param dataJ
 */
function numberFormat(dataJ){
    var hbhcGrid = DSYGrid.getGrid('hbhcGrid');
    dataJ.APPLY_AMT = dataJ.APPLY_AMT/10000;
    dataJ.APPLY_AMT_RMB = dataJ.APPLY_AMT_RMB/10000;
    hbhcGrid.insertData(null,dataJ);
}
/**
 * 初始化到期债务(有计划)弹出窗口
 */
function initWindow_dqzw_yjh() {
    return Ext.create('Ext.window.Window', {
        title: ZW_HBFX_MODE == 0 ? '到期债务(还本)' : btnText=='还本录入'?'到期债务(还本)':'到期债务(付息)', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        itemId: 'window_dqzw_yjh', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        maximizable: true,//最大化按钮
        layout: 'fit',
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [initWindow_dqzw_yjh_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    var i = 0;
                    var agIdMap = new Map();
                    var message_error = null;
                    Ext.each(records, function (record) {
                        var AG_ID = record.get("AG_ID");
                        var CH_TYPE = record.get("CH_TYPE");
                        var IS_ZTZQ = record.get("IS_ZTZQ");
                        if (i == 0) {
                            agIdMap.put(AG_ID, '');
                        }
                        if (typeof(agIdMap.get(AG_ID)) == 'undefined') {
                            message_error = "一次只能录入同一个单位的还本付息，不允许确认";
                            return false;
                        }
                        if (CH_TYPE == '0' && IS_ZTZQ == '1') {
                            message_error = "该笔还款计划存在在途展期，不能录入还本!";
                            return false;
                        }
                        i = i + 1;
                    });
                    if (message_error != null && message_error != '') {
                        Ext.Msg.alert('提示', message_error);
                        return;
                    }
                    //关闭当前窗口，打开偿还资金录入窗口
                    window_debt_add_apply.show();
                    btn.up('window').close();
                    records[0].data.APPLY_AMT = records[0].data.DUE_AMT;
                    //将债务单位带入偿还资金录入窗口
                    window_debt_add_apply.window.down('form#window_debt_add_apply_form').getForm().setValues(records[0].data);
                    //偿还资金录入窗口表格增加行
                    $.post("/getId.action", {size: records.length + 1}, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询失败！' + data.message);
                            return;
                        }
                        for (var record_seq in records) {
                            //弹出弹出框，设置主表id
                            var mx_id = data.data[record_seq];
                            var record_data = records[record_seq].getData();
                            record_data.CHZJ_MX_ID = mx_id;
                            window_debt_add_apply.window.down('grid').insertData(null, record_data);
                        }
                        if (!window_debt_add_apply.window.down('form#window_debt_add_apply_form').down('textfield[name="CHBJ_ID"]').getValue()) {
                            window_debt_add_apply.window.down('form#window_debt_add_apply_form').down('textfield[name="CHBJ_ID"]').setValue(data.data[records.length]);
                        }
                    }, "json");
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                window_dqzw_yjh.window = null;
            }
        }
    });
}
/*
 * 初始化到期债务(有计划)弹出框表格
 */
function initWindow_dqzw_yjh_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "AG_CODE", type: "string", text: "债务单位编码", hidden: true},
        {dataIndex: "AG_NAME", type: "string", text: "债务单位", width: 250},
        {dataIndex: "ZW_CODE", type: "string", text: "债务编码", hidden: true},
        {
            dataIndex: "ZW_NAME", type: "string", text: "债务名称", width: 250,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url=zwlb_id=='2'?'/page/debt/common/rzpt_zwyhs.jsp':'/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="ZW_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "CH_TYPE_NAME", type: "string", text: "类型", width: 100},
        {
            dataIndex: "HKJH_DATE", type: "string", text: "到期日", width: 100,
            renderer: function (value, metaData, record) {
                if (value < dsyDateFormat(new Date()))
                    metaData.css = 'x-grid-back-green';
                return value;
            }
        },
        {
            dataIndex: "DUE_AMT", type: "float", text: "到期金额(原币)", width: 150, summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "YE_AMT", type: "float", text: "债务余额(原币)", width: 150
        },
        {dataIndex: "CUR_NAME", type: "string", text: "原币币种", width: 100},
        {dataIndex: "ZWLB_NAME", type: "string", text: "债务类别", width: 100},
        {
            dataIndex: "XM_NAME", type: "string", text: "建设项目", width: 250,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=record.get('XM_ID');
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "ZQLX_NAME", type: "string", text: "债权类型", width: 150},
        {dataIndex: "ZQR_FULLNAME", type: "string", text: "债权人", width: 150},
        {dataIndex: "ZQR_FULLNAME", type: "string", text: "债权人全称", width: 250},
        {dataIndex: "SIGN_DATE", type: "string", text: "签订日期", format: 'Y-m-d', width: 100},
        {dataIndex: "ZW_XY_NO", type: "string", text: "协议号", width: 250},
        {
            dataIndex: "XY_AMT", type: "float", text: "协议金额(原币)", width: 150
        },
        {
            dataIndex: "XY_AMT_RMB", type: "float", text: "协议金额(人民币)(元)", width: 150, hidden: true, summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "HL_RATE", type: "float", text: "汇率", width: 100, hidden: true}

    ];
    var grid = DSYGrid.createGrid({
        itemId: 'grid_dqzw_yjh',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        tbar: [],
        tbarHeight: 50,
        autoScroll: true,
        autoLoad: false,
        //height: 420,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            AG_NAME: AG_NAME,
            zwlb_id: zwlb_id,
            selectId: selectId,
            //此处传逾期参数，到期债务（还本）页面自动加载逾期数据
            isYuqi: 'true',
            HKJH_YEAR: new Date().getFullYear(),
            HKJH_MO: lpad(1 + new Date().getMonth(), 2)
        },
        dataUrl: 'getDqzwYjh.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        features: [{
            ftype: 'summary'
        }]
    });
    //将form添加到表格中
    var searchTool = initWindow_dqzw_yjh_grid_searchTool();
    grid.addDocked(searchTool, 0);
    return grid;
}
/**
 * 初始化到期债务(有计划)弹出框搜索区域
 */
function initWindow_dqzw_yjh_grid_searchTool() {
    //初始化查询控件
    var items = [
        {
            fieldLabel: '截至年月',
            xtype: 'fieldcontainer',
            layout: 'column',
            width: 260,
            labelWidth: 60,
            defaults: {
                xtype: "combobox",
                width: 90,
                displayField: "name",
                valueField: "code",
                margin: '0 5 0 0'
            },
            items: [
                {name: "HKJH_YEAR", store: DebtEleStore(getYearListWithAll()), value: new Date().getFullYear()},
                {name: "HKJH_MO", store: DebtEleStore(json_debt_yf_qb), value: lpad(1 + new Date().getUTCMonth(), 2)}
            ]
        },
        {
            fieldLabel: '类型',
            xtype: 'combobox',
            name: 'lx_id',
            labelWidth: 30,
            width: 120,
            store: DebtEleStore(json_debt_bjlx),
            displayField: "name",
            valueField: "id",
            editable: false,
            listeners: {
                beforerender: function(self) {
                    if (ZW_HBFX_MODE!=0) {//还本付息分别偿还
                        var store = DSYGrid.getGrid('grid_dqzw_yjh').getStore();
                        if (btnText == '还本录入') {//是还本操作，查询条件类型只显示本金
                            var json_debt_bj = [
                                {id: "0", code: "0", name: "本金"}
                            ];
                            self.setStore(DebtEleStore(json_debt_bj));
                            self.setValue('0');
                            // 向grid中追加参数
                            var mapValue = {};
                            mapValue.lx_id = '0';
                            $.extend(true, store.getProxy().extraParams, mapValue);
                        }else if (btnText == '付息录入') {//是付息操作，查询条件类型只显示利息
                            var json_debt_lx = [
                                {id: "1", code: "1", name: "利息"}
                            ];
                            self.setStore(DebtEleStore(json_debt_lx));
                            self.setValue('1');
                            // 向grid中追加参数
                            var mapValue = {};
                            mapValue.lx_id = '1';
                            $.extend(true, store.getProxy().extraParams, mapValue);
                        }
                    }
                }
            }
        },
        {xtype: 'checkbox', boxLabel: '包含逾期', checked: true, itemId: 'isYuqi', name: 'flag_expire_date', labelWidth: 60, width: 100},
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            name: 'YJH_MHCH',
            itemId: 'yjh_contentGrid_search',
            width: 450,
            labelWidth: 60,
            emptyText: '请输入债务单位/债务名称',
            enableKeyEvents: true,
            listeners: {
                'keydown': function (self, e, eOpts) {
                    var key = e.getKey();
                    if (key == Ext.EventObject.ENTER) {
                        getYJHDataList(self);
                    }
                }
            }
        }
    ];
    //设置查询form
    var searchTool = new DSYSearchTool();
    searchTool.setSearchToolId('searchTool_grid_YJH');
    return searchTool.create({
        items: items,
        dock: 'top',
        defaults: {
            labelWidth: 0,
            labelAlign: 'right',
            columnWidth: null,
            margin: '5 5 5 5'
        },
        // 查询按钮回调函数
        callback: function (self) {
            getYJHDataList(self);
        }
    });
    /**
     * 有计划查询按钮实现
     */
    function getYJHDataList() {
        var store = DSYGrid.getGrid('grid_dqzw_yjh').getStore();
        var self = DSYGrid.getGrid('grid_dqzw_yjh').down('form');
        // 清空参数中已有的查询项
        for (var search_form_i in self.getValues()) {
            delete store.getProxy().extraParams[search_form_i];
        }
        var formValue = self.getValues();
        var aa = Ext.ComponentQuery.query('checkbox[itemId="isYuqi"]')[0].getValue();
        formValue.isYuqi = aa;
        if (self.down('combobox[name="HKJH_YEAR"]').isDisabled()) {
            formValue.HKJH_YEAR = '';
            formValue.HKJH_MO = '';
        }
        //截至年为空提示
        if ((formValue.HKJH_MO != null && formValue.HKJH_MO != '') && (formValue.HKJH_YEAR == null || formValue.HKJH_YEAR == '' || formValue.HKJH_YEAR == 'undefined')) {
            Ext.Msg.alert("提示", "截至年不能为空!");
            return false;
        }
        // 向grid中追加参数
        $.extend(true, store.getProxy().extraParams, formValue);
        // 刷新表格
        store.loadPage(1);
    }
}
//取当前月时 长度为1时左侧补0
function lpad(num, n) {
    return (Array(n).join(0) + num).slice(-n);
}
/**
 * 初始化到期债务(无计划)弹出窗口
 */
function initWindow_dqzw_wjh() {
    return Ext.create('Ext.window.Window', {
        title: ZW_HBFX_MODE == 0 ? '到期债务(付息)' : '到期债务(无计划)', // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        itemId: 'window_dqzw_wjh', // 窗口标识
        maximizable: true,//最大化按钮
        layout: 'fit',
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_dqzw_wjh_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }

                    var i = 0;
                    var agIdMap = new Map();
                    var message_error = null;
                    Ext.each(records, function (record) {
                        var AG_ID = record.get("AG_ID");
                        if (i == 0) {
                            agIdMap.put(AG_ID, '');
                        }
                        if (typeof(agIdMap.get(AG_ID)) == 'undefined') {
                            message_error = "一次只能录入同一个单位的还本付息，不允许确认";
                            return false;
                        }
                        i = i + 1;
                    });
                    if (message_error != null && message_error != '') {
                        Ext.Msg.alert('提示', message_error);
                        return;
                    }

                    btn.up('window').close();
                    window_debt_add_apply.show();
                    //关闭当前窗口，打开偿还资金录入窗口
                    //将债务单位带入偿还资金录入窗口
                    window_debt_add_apply.window.down('form#window_debt_add_apply_form').getForm().setValues(records[0].data);
                    //偿还资金录入窗口表格增加行

                    $.post("/getId.action", {size: records.length + 1}, function (data) {
                        if (!data.success) {
                            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                            return;
                        }
                        for (var record_seq in records) {
                            //弹出弹出框，设置主表id
                            var mx_id = data.data[record_seq];
                            var record_data = records[record_seq].getData();
                            record_data.CHZJ_MX_ID = mx_id;
                            window_debt_add_apply.window.down('grid').insertData(null, record_data);
                        }
                        if (!window_debt_add_apply.window.down('form#window_debt_add_apply_form').down('textfield[name="CHBJ_ID"]').getValue()) {
                            window_debt_add_apply.window.down('form#window_debt_add_apply_form').down('textfield[name="CHBJ_ID"]').setValue(data.data[records.length]);
                        }
                    }, "json");
                }

            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                window_dqzw_wjh.window = null;
            }
        }
    });
}
/**
 * 初始化到期债务(无计划)弹出框表格
 */
function initWindow_dqzw_wjh_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 40, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "AG_NAME", type: "string", text: "债务单位", width: 150},
        {
            dataIndex: "ZW_NAME", type: "string", text: "债务名称", width: 150,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url=zwlb_id=='2'?'/page/debt/common/rzpt_zwyhs.jsp':'/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="ZW_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex: "ZW_ID", type: "string", text: "债务ID", width: 150, hidden: true},
        {dataIndex: "SIGN_DATE", type: "string", text: "签订日期", format: 'Y-m-d', width: 100},
        {dataIndex: "ZQR_NAME", type: "string", text: "债权人", width: 150},
        {dataIndex: "ZQR_FULLNAME", type: "string", text: "债权人全称", width: 250},
        {
            dataIndex: "XY_AMT", type: "float", text: "协议金额(原币)", type: "float", editor: 'numberFieldFormat', width: 150, summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "XY_AMT_RMB", type: "float", text: "协议金额(人民币)(元)", type: "float", editor: 'numberFieldFormat', width: 150, summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "YE_AMT", type: "float", text: "债务余额(原币)", editor: 'numberFieldFormat', width: 150, summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "ZQLX_NAME", type: "string", text: "债权类型", width: 150},
        {dataIndex: "ZWQX_ID", type: "string", text: "债务期限(月)", width: 100},
        {dataIndex: "ZJYT_NAME", type: "string", text: "资金用途", width: 150},
        {dataIndex: "ZW_XY_NO", type: "string", text: "协议号", width: 230},
        {dataIndex: "CUR_NAME", type: "string", text: "原币币种", width: 100},
        {dataIndex: "HL_RATE", type: "float", text: "汇率", width: 100}

    ];
    var grid = DSYGrid.createGrid({
        itemId: 'grid_dqzw_wjh',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        autoScroll: true,
        height: '100%',
        autoLoad: false,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            AG_NAME: AG_NAME,
            zwlb_id: zwlb_id,
            selectId: selectId
        },
        dataUrl: 'getDqzwWjh.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        features: [{
            ftype: 'summary'
        }]
    });
    //将form添加到表格中
    var searchTool = initWindow_dqzw_wjh_grid_searchTool();
    grid.addDocked(searchTool, 0);
    return grid;
}
/**
 * 初始化到期债务(无计划)弹出框搜索区域
 */
function initWindow_dqzw_wjh_grid_searchTool() {
    //初始化查询控件
    var items = [
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            name: 'WJH_MHCH',
            columnWidth: .5,
            labelWidth: 60,
            labelAlign: 'right',
            emptyText: '请输入债务单位/债务名称',
            enableKeyEvents: true,
            listeners: {
                'keydown': function (self, e, eOpts) {
                    var key = e.getKey();
                    if (key == Ext.EventObject.ENTER) {
                        getWJHDataList(self);
                    }
                }
            }
        }
    ];
    //设置查询form
    var searchTool = new DSYSearchTool();
    searchTool.setSearchToolId('searchTool_grid');
    return searchTool.create({
        items: items,
        dock: 'top',
        defaults: {
            labelWidth: 0,
            labelAlign: 'right',
            columnWidth: null,
            margin: '5 5 5 5'
        },
        // 查询按钮回调函数
        callback: function (search_form) {
            getWJHDataList(search_form);
        }
    });
    /**
     * 无计划查询按钮实现
     */
    function getWJHDataList() {
        var store = DSYGrid.getGrid('grid_dqzw_wjh').getStore();
        var search_form = DSYGrid.getGrid('grid_dqzw_wjh').down('form');
        // 清空参数中已有的查询项
        for (var search_form_i in search_form.getValues()) {
            delete store.getProxy().extraParams[search_form_i];
        }
        // 向grid中追加参数
        $.extend(true, store.getProxy().extraParams, search_form.getValues());
        // 给导出按钮追加查询参数
        //  $.extend(true, DSYGrid.getBtnExport('grid').param, search_form.getValues());
        // 刷新表格
        store.loadPage(1);
    }
}
/**
 * 初始化偿债资金申请单弹出窗口
 */
function initWindow_debt_add_apply(config) {
    config = $.extend({}, {
        disabled: false,
        gridId: ''
    }, config);
    return Ext.create('Ext.window.Window', {
        title: TITLE, // 窗口标题
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        maximizable: true,//最大化按钮
        layout: 'fit',
        itemId: 'window_debt_add_apply', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destory，则会将window销毁。
        items: [
            {
                xtype: 'tabpanel',
                items: [
                    {
                        title: '单据',
                        layout: 'fit',
                        items: [initWindow_debt_add_apply_contentForm()]
                    },
                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        layout: 'fit',
                        items: [
                            {
                                xtype: 'panel',
                                layout: 'fit',
                                itemId: 'window_save_zcxx_file_panel',
                                items: [initWindow_save_zcxx_tab_upload(config)]
                            }
                        ],
                        listeners: {
                            beforeactivate: function () {
                                // 检验是否主表是否有数据
                                /*var grid = DSYGrid.getGrid('debt_add_apply_grid');
                                 if (grid.getStore().getCount() <= 0) {
                                 Ext.MessageBox.alert('提示', '单据明细表格无数据！');
                                 return false;
                                 }
                                 // 获取选中数据
                                 var record = grid.getCurrentRecord();
                                 //如果当前无选中行，默认选中第一条数据
                                 if (!record) {
                                 $(grid.getView().getRow(0)).parents('table[data-recordindex=0]').addClass('x-grid-item-click');
                                 record = grid.getStore().getAt(0);
                                 Ext.toast({
                                 html: "单据明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                 closable: false,
                                 align: 't',
                                 slideInDuration: 400,
                                 minWidth: 400
                                 });
                                 }*/
                                var panel = Ext.ComponentQuery.query('panel#window_save_zcxx_file_panel')[0];
                                panel.removeAll(true);
                                panel.add(initWindow_save_zcxx_tab_upload({
                                    disabled: false,
                                    gridId: panel.up('window').down('form#window_debt_add_apply_form').down('textfield[name="CHBJ_ID"]').getValue()
                                }));
                            }
                        }
                    }
                ]
            }
        ],
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    //保存表单数据
                    var form = btn.up('window').down('form');
                    var grid = form.down('grid#debt_add_apply_grid');
                    grid.getPlugin('debt_add_apply_grid_plugin_cell').completeEdit();
                    submitInfo(btn, form);
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                window_debt_add_apply.window = null;
            }
        }
    });
}
/**
 * 初始化偿债资金申请单表单
 */
function initWindow_debt_add_apply_contentForm() {
    if (isModify == 0) {
        var itemmingxi = [
            {fieldLabel: '单据ID', hidden: true, name: 'CHBJ_ID', xtype: 'textfield'},
            {
                fieldLabel: '债务单位', name: 'AG_NAME', xtype: 'textfield',
                readOnly: true, width: 400, fieldStyle: 'background:#E6E6E6',
                labelAlign: 'right', labelWidth: 100
            },
            {fieldLabel: '申请单位代码', name: 'AG_CODE', xtype: 'hiddenfield'},
            {
                fieldLabel: '<span class="required">✶</span>录入日期',
                xtype: 'datefield',
                name: 'CREATE_DATE',
                format: 'Y-m-d H:i:s',
                width: 180,
                value: today,
                hidden: true,
                labelAlign: 'right',
                renderer: function (value) {
                    return dsyDateFormat(value);
                }
            },
            {
                fieldLabel: '还本付息总额', xtype: "numberFieldFormat", name: 'PAY_AMT_RMB',
                hideTrigger: true,
                labelAlign: 'right',
                readOnly: true, fieldStyle: 'background:#E6E6E6', width: 250, labelWidth: 100
            }, {
                fieldLabel: '其中本金', xtype: "numberFieldFormat", name: 'PAY_BJ_AMT_RMB',
                hideTrigger: true, labelAlign: 'right',
                readOnly: true, fieldStyle: 'background:#E6E6E6', width: 250, labelWidth: 100
            }, {
                fieldLabel: '其中利息', xtype: "numberFieldFormat", name: 'PAY_LX_AMT_RMB',
                hideTrigger: true, labelAlign: 'right',
                readOnly: true, fieldStyle: 'background:#E6E6E6', width: 400, labelWidth: 100
            },
            {fieldLabel: '备注', xtype: "textfield", name: 'REMARK', width: 250, labelWidth: 100, labelAlign: 'right', columnWidth: .99}
        ];
    } else {
        var itemmingxi = [
            {fieldLabel: '单据ID', hidden: true, name: 'CHBJ_ID', xtype: 'textfield'},
            {
                fieldLabel: '申请单号', name: 'CHBJ_CODE', readOnly: true,
                labelAlign: 'right', labelWidth: 100,
                xtype: 'textfield', width: 250, fieldStyle: 'background:#E6E6E6'
            },
            {
                fieldLabel: '债务单位', name: 'AG_NAME', readOnly: true,
                labelAlign: 'right', labelWidth: 100, width: 250,
                xtype: 'textfield', fieldStyle: 'background:#E6E6E6'
            },
            {fieldLabel: '申请单位代码', name: 'AG_CODE', labelAlign: 'right', width: 250, labelWidth: 100, xtype: 'hiddenfield'},
            {
                fieldLabel: '<span class="required">✶</span>录入日期',
                xtype: 'datefield',
                name: 'CREATE_DATE',
                format: 'Y-m-d H:i:s',
                width: 250,
                labelAlign: 'right',
                labelWidth: 100,
                hidden: true,
                renderer: function (value) {
                    return dsyDateFormat(value);
                }
            },
            {
                fieldLabel: '还本付息总额', xtype: "numberFieldFormat", name: 'PAY_AMT_RMB',
                hideTrigger: true,
                labelAlign: 'right',
                readOnly: true, fieldStyle: 'background:#E6E6E6', width: 250, labelWidth: 100
            }, {
                fieldLabel: '其中本金', xtype: "numberFieldFormat", name: 'PAY_BJ_AMT_RMB',
                hideTrigger: true, labelAlign: 'right',
                readOnly: true, fieldStyle: 'background:#E6E6E6', width: 250, labelWidth: 100
            }, {
                fieldLabel: '其中利息', xtype: "numberFieldFormat", name: 'PAY_LX_AMT_RMB',
                hideTrigger: true, labelAlign: 'right',
                readOnly: true, fieldStyle: 'background:#E6E6E6', width: 400, labelWidth: 100
            },
            {fieldLabel: '备注', xtype: "textfield", name: 'REMARK', width: 250, labelWidth: 100, labelAlign: 'right', columnWidth: .99}
        ];
    }
    return Ext.create('Ext.form.Panel', {
        //title: '详情表单',
        width: '100%',
        height: '100%',
        itemId: 'window_debt_add_apply_form',
        layout: 'anchor',
        defaults: {
            anchor: '100%',
            margin: '5 5 5 5'
        },
        defaultType: 'textfield',
        items: [
            //{ xtype: 'hiddenfield', name: 'userPageMenu.id' },
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '5 5 5 5',
                    columnWidth: .33,
                    labelWidth: 70//控件默认标签宽度
                },
                items: itemmingxi
            },
            {
                xtype: 'fieldset',
                anchor: '100% -120',
                title: '单据明细',
                layout: 'fit',
                padding: '10 5 3 10',
                height: '100%',
                collapsible: false,
                items: [
                    initWindow_debt_add_apply_contentForm_grid()
                ]
            }
        ]
    });
}
/**
 * 初始化偿债资金申请单表单中的表格
 */
function initWindow_debt_add_apply_contentForm_grid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 40},
        {dataIndex: "ZW_NAME", type: "string", text: "债务名称", align: 'right', width: 250},
        {dataIndex: "ZW_CODE", type: "string", text: "债务编码", hidden: true},
        {
            dataIndex: "PAY_DATE",
            type: "string",
            text: "还款日期",
            editor: 'datefield',
            tdCls: 'grid-cell',
            renderer: function (value, metaData, record) {
                var newdate = dsyDateFormat(value);
                record.data.PAY_DATE = newdate;
                return newdate;
            }
        },
        {
            dataIndex: "CH_TYPE", type: "string", text: "类型", width: 80,
            tdCls: 'grid-cell',
            editor: {
                xtype: 'combobox',
                itemId: 'chtype',
                displayField: 'name',
                valueField: 'id',
                editable: false,
                store: HbfxlxStore
            },
            renderer: function (value, metaData, record) {
                var strore = HbfxlxStore;
                var isYjh = record.get("IS_YJH");
                var mx_code = record.get("CHBJ_CODE");
                if ('0' == isYjh) {
                    strore = DebtEleStore(json_debt_hbfxlx);
                } else {
                    strore = DebtEleStore(json_debt_hbfxlx1);
                }
                var record = strore.findRecord('code', value, 0, true, true, true);
                if ('1' == isModify) {
                    if (mx_code != "" && typeof mx_code != 'undefined') {
                        record.get('name').disabled
                        metaData.tdCls = 'grid-cell-unedit';
                    }
                }

                return record != null ? record.get('name') : value;
            }
        },
        {
            dataIndex: "ZJLY_ID", type: "string", text: "偿还资金来源", width: 120, align: 'left',
            tdCls: 'grid-cell',
            editor: {
                xtype: 'treecombobox',
               store: store_DEBT_ZJLY,
                itemId: 'zjlyid',
                //store: DebtEleTreeStoreDB('DEBT_CHZJLY',{condition:condition}),
                selectModel: 'leaf',
                displayField: 'name',
                valueField: 'code'
            },
            renderer: function (value, metaData, record) {

                if ('0' == record.get('CH_TYPE')) {
                    if (value == "05" && record.data.HKJH_ZJLY_ID != "05") {
                        Ext.Msg.alert('提示', '约定还本的偿还资金来源不是05转贷收回资金，那么实际还本的偿还资金来源也不能是05转贷收回资金');
                        record.data.ZJLY_ID = '';
                        return '';
                    }
                }
                var rec = store_DEBT_ZJLY.findNode('code', value, true, true, true);
                var ss = rec != null ? rec.get('name') : value;

                return ss;
            }
        },
        {
            dataIndex: "APPLY_AMT", type: "float", text: zwlb_id == 'wb' ? '本次还款金额(原币)' : '本次还款金额(元)', tdCls: 'grid-cell', width: 180,
            editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}
        },
        {
            dataIndex: "HL_RATE", type: "string", text: "汇率", hidden: zwlb_id == 'wb' ? false : true,
            editor: {
                xtype: 'numberfield',
                decimalPrecision: 6,
                hideTrigger: true
            }, width: 100
        },
        {dataIndex: "APPLY_AMT_RMB", type: "float", text: "本次还款金额(人民币)(元)", width: 190, hidden: zwlb_id == 'wb' ? false : true},
        {
            dataIndex: "JZ_DATE",
            type: "string",
            text: "记账日期",
            editor: 'datefield',
            tdCls: 'grid-cell',
            renderer: function (value, metaData, record) {
                // alert("jzrq"+value);
                var newValue = dsyDateFormat(value);
                record.data.JZ_DATE = newValue;
                return newValue;
            }
        },
        {dataIndex: "JZ_NO", type: "string", text: "会计凭证号", editor: 'textfield', width: 100, tdCls: 'grid-cell'},
        {
            dataIndex: "CHBJ_TYPE", type: "string", text: "还款类型", width: 80,
            tdCls: 'grid-cell',
            editor: {
                xtype: 'combobox',
                itemId: 'chbjtype',
                displayField: 'name',
                valueField: 'id',
                editable: false,
                store: ChbjTypeStore
            },
            renderer: function (value, metaData, record) {
                if (value == null || value == '' || value == 'undefined') {
                    value = '0';
                }
                record.data.CHBJ_TYPE = value;
                var rec = ChbjTypeStore.findRecord('code', value, 0, true, true, true);
                return rec != null ? rec.get('name') : value;
            }

        },
        {
            dataIndex: "HKJH_DATE",
            type: "string",
            text: "到期日期",
            width: 120,
            align: 'left',
            renderer: function (value) {
                return dsyDateFormat(value);
            }
        },
        {dataIndex: "DUE_AMT", type: "float", text: zwlb_id == 'wb' ? "到期金额(原币)" : "到期金额(元)", width: 150},
        {dataIndex: "YE_AMT", type: "float", text: zwlb_id == 'wb' ? "债务余额(原币)" : "债务余额(元)", width: 150},
        {dataIndex: "CHBJ_AMT", type: "float", text: "已申请金额(原币)", width: 180, hidden: true},
        {
            dataIndex: "FM_ID",
            type: "string",
            text: "币种ID",
            hidden: true
        },
        {dataIndex: "CUR_NAME", type: "string", text: "原币币种", hidden: zwlb_id == 'wb' ? false : true},
        {dataIndex: "CHBJ_AMT_RMB", type: "float", text: "已申请金额(人民币)", width: 180, hidden: true}

        // {dataIndex: "ZWLB_ID", type: "string", text: "债务类别",hidden:true},
        //{dataIndex: "REMARK", type: "string", text: "备注", editor: 'textfield'}
    ];
    if (isHuanBen == '0') {
        var tbar = [
            '->',
            {
                xtype: 'button',
                id: 'huanben',
                text: ZW_HBFX_MODE == 0 ? '还本录入' : btnText == '还本录入' ? '还本录入' : '付息录入',
                width: 90,
                handler: function (btn) {
                    getSelectId();
                    //弹出到期债务窗口
                    var record = DSYGrid.getGrid('debt_add_apply_grid').getStore().getAt(0);
                    if (record != null && record != '' && typeof record != 'undefined') {
                        window_dqzw_yjh.show();
                        DSYGrid.getGrid('grid_dqzw_yjh').getStore().getProxy().extraParams["AD_CODE"] = record.get("AD_CODE");
                        DSYGrid.getGrid('grid_dqzw_yjh').getStore().getProxy().extraParams["AG_ID"] = record.get("AG_ID");
                        DSYGrid.getGrid('grid_dqzw_yjh').getStore().getProxy().extraParams["AG_CODE"] = record.get("AG_CODE");
                        DSYGrid.getGrid('grid_dqzw_yjh').getStore().getProxy().extraParams["AG_NAME"] = record.get("AG_NAME");
                        DSYGrid.getGrid('grid_dqzw_yjh').getStore().loadPage(1);
                    } else {
                        window_dqzw_yjh.show();
                        DSYGrid.getGrid('grid_dqzw_yjh').getStore().loadPage(1);
                    }
                }
            },
            {
                xtype: 'button',
                text: '付息录入',
                hidden: !(ZW_HBFX_MODE == 0),
                width: 90,
                handler: function () {
                    getSelectId();
                    //弹出到期债务窗口
                    var record = DSYGrid.getGrid('debt_add_apply_grid').getStore().getAt(0);
                    if (record != null && record != '' && typeof record != 'undefined') {
                        window_dqzw_wjh.show();
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().getProxy().extraParams["AD_CODE"] = record.get("AD_CODE");
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().getProxy().extraParams["AG_ID"] = record.get("AG_ID");
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().getProxy().extraParams["AG_CODE"] = record.get("AG_CODE");
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().getProxy().extraParams["AG_NAME"] = record.get("AG_NAME");
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().loadPage(1);
                    } else {
                        window_dqzw_wjh.show();
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().loadPage(1);
                    }
                }
            },
            {
                xtype: 'button',
                text: '删除',
                itemId: 'delete_editGrid',
                width: 80,
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    grid.getPlugin('debt_add_apply_grid_plugin_cell').cancelEdit();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            }
        ];
    } else if (isHuanBen == '1') {
        var tbar = [
            '->',
            {
                xtype: 'button',
                text: ZW_HBFX_MODE == 0 ? '付息录入' : '无计划录入',
                width: 90,
                handler: function () {
                    getSelectId();
                    //弹出到期债务窗口
                    var record = DSYGrid.getGrid('debt_add_apply_grid').getStore().getAt(0);
                    if (record != null && record != '' && typeof record != 'undefined') {
                        window_dqzw_wjh.show();
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().getProxy().extraParams["AD_CODE"] = record.get("AD_CODE");
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().getProxy().extraParams["AG_ID"] = record.get("AG_ID");
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().getProxy().extraParams["AG_CODE"] = record.get("AG_CODE");
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().getProxy().extraParams["AG_NAME"] = record.get("AG_NAME");
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().loadPage(1);
                    } else {
                        window_dqzw_wjh.show();
                        DSYGrid.getGrid('grid_dqzw_wjh').getStore().loadPage(1);
                    }
                }
            },
            {
                xtype: 'button',
                text: '删除',
                itemId: 'delete_editGrid',
                width: 80,
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    grid.getPlugin('debt_add_apply_grid_plugin_cell').cancelEdit();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            }
        ];
    }
    var grid = DSYGrid.createGrid({
        itemId: 'debt_add_apply_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'debt_add_apply_grid_plugin_cell',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                        if (context.field == 'HL_RATE') {
                            //币种如果是人民币不允许修改
                            if (context.record.get('FM_ID') == 'CNY') {
                                return false;
                            }
                        }
                        //偿还资金来源关联关系设置
                        if (context.field == 'ZJLY_ID') {
                            getChzjByType(context);
                        }
                        //偿还本金类型关联关系设置，有计划的类型不可编辑，无计划的类型可选择利息，罚息,费用
                        if (context.field == 'CH_TYPE') {
                            var isYjh = context.record.get("IS_YJH");
                            if ('0' == isYjh) {
                                HbfxlxStore = DebtEleStore(json_debt_hbfxlx);
                                Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].setValue('');
                                Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].bindStore(HbfxlxStore);
                                Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].setFieldStyle('background:#E6E6E6');
                                Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].readOnly = true;
                            } else {
                                HbfxlxStore = DebtEleStore(json_debt_hbfxlx1);
                                Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].setValue('');
                                //Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].store = HbfxlxStore;
                                Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].bindStore(HbfxlxStore);
                                Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].readOnly = false;
                            }
                            if ('1' == isModify) {
                                var mx_code = context.record.get("CHBJ_CODE");
                                if (mx_code != "" && typeof mx_code != 'undefined') {
                                    Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].setFieldStyle('background:#E6E6E6');
                                    Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].readOnly = true;
                                } else {
                                    Ext.ComponentQuery.query('combobox[itemId="chtype"]')[0].readOnly = false;
                                }
                            }
                        }
                    }
                }
            }
        ],
        checkBox: true,
        border: true,
        bodyStyle: 'border-width:1px 1px 0 1px;',
        height: '100%',
        tbar: tbar,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code
        },
        data: [],
        pageConfig: {
            enablePage: false
        },
        listeners: {
            selectionchange: function (view, records) {
                grid.down('#delete_editGrid').setDisabled(!records.length);
            }
        }
    });
    grid.on('edit', function (editor, context) {
        //自动计算金额
        if (context.field == 'HL_RATE' || context.field == 'APPLY_AMT') {
            var apply_amt = context.record.get("APPLY_AMT");
            var rate = context.record.get("HL_RATE");
            context.record.set('APPLY_AMT_RMB', apply_amt * rate);
        }
        return checkEditorGrid(editor, context);
    });
    //加日期格式转换
    grid.getStore().on('endupdate', function () {
        var self = grid.getStore();
        //计算偿还资金录入窗口form申请金额
        var sum_PAY_AMT_RMB = 0;
        var sum_bj_amt_rmb = 0;
        var sum_lx_amt_rmb = 0;
        self.each(function (record) {
            sum_PAY_AMT_RMB += record.get('APPLY_AMT');
            if (0 == record.get('CH_TYPE')) {
                sum_bj_amt_rmb += record.get('APPLY_AMT');
            } else if (1 == record.get('CH_TYPE')) {
                sum_lx_amt_rmb += record.get('APPLY_AMT');
            }
        });
        Ext.ComponentQuery.query('textfield[name="PAY_AMT_RMB"]')[0].setValue(sum_PAY_AMT_RMB);
        Ext.ComponentQuery.query('textfield[name="PAY_BJ_AMT_RMB"]')[0].setValue(sum_bj_amt_rmb);
        Ext.ComponentQuery.query('textfield[name="PAY_LX_AMT_RMB"]')[0].setValue(sum_lx_amt_rmb);
    });
    return grid;
}
function getChzjByType(context) {
    //自动计算融资资金中债券资金到位情况
    var zwlb = context.record.get("ZWLB_ID");
    //如果是本金可以进行库款垫付，其他的不可以
    var ch_type = context.record.get("CH_TYPE");
    Ext.ComponentQuery.query('treecombobox[itemId="zjlyid"]')[0].setValue('');
    //20170505 caiyc 去掉查询条件 or  code like '05%' ， 政府债务、或有债务等都去了
    if (zwlb.substring(0, 2) == '01') {//01政府债务
        condition = "and (code like '01%' or code like '02%' )";
        if ('0' == ch_type) {
            condition = "and (code like '01%' or code like '02%' or code in ('97','98') )";
        }
    } else if (zwlb.substring(0, 2) == '02') {//02或有债务，偿还资金来源02下的
      /*  condition = "and ( code like '02%' or (code ='01' or  ( code = '0102' or code like '010228%') or (code ='0103' or code like '010301%')) )";
        if ('0' == ch_type) {
          /!*  condition = "and ( code like '02%' or (code ='01' or  ( code = '0102' or code like '010228%') or (code ='0103' or code like '010301%')) " +
                " or code in ('97','98')  )";*!/
        }*/
        condition = "and (code like '01%' or code like '02%' )";
        if ('0' == ch_type) {
            condition = "and (code like '01%' or code like '02%' or code in ('97','98') )";
        }
    }else if(zwlb.substring(0, 2) == '2'){
        condition = "and (code like '0102%' )";
    }
//    if ('0' == ch_type) {
//        condition = condition + "( or code in ('97','98') or code like '04%' )";
//
//    }
    store_DEBT_ZJLY.proxy.extraParams['condition'] = encode64(condition);
    store_DEBT_ZJLY.load();
}
function getSelectId() {
    var store = DSYGrid.getGrid('debt_add_apply_grid').getStore();
    selectId = new Array();
    store.each(function (record) {

        if (null != record.get('YDCH_ID') && '' != record.get('YDCH_ID') && typeof(record.get('YDCH_ID')) != 'undefined') {
            selectId.push(record.get('YDCH_ID'));
        }

    });
}
/**
 * validateedit 表格编辑插件校验
 */
function checkEditorGrid(editor, context) {
    //校验当年申请金额
    if (context.field == 'APPLY_AMT') {
        //新插入的，当年申请金额最大值APPLY_AMOUNT_MAX为插入前到期金额-已申请金额（汇总）
        //已经存在的，当年申请金额最大值APPLY_AMOUNT_MAX为插入前数据库中计算得到的：到期金额-已申请金额（汇总）+当年申请金额
        //故：当年申请金额<=当年申请金额最大值APPLY_AMOUNT_MAX
        if (context.record.get('CH_TYPE') != null && context.record.get('CH_TYPE') != ''
            && typeof(context.record.get('CH_TYPE')) != 'undefind'
            && context.record.get('CH_TYPE') == 0) {
            if (parseFloat(context.value).toFixed(2) - parseFloat(context.record.get('DUE_AMT')).toFixed(2) > 0) {
                Ext.Msg.alert('提示', '当前申请金额不能超过到期金额' + parseFloat(context.record.get('DUE_AMT')).toFixed(2));
                return false;
            }
        }
    }
}
/**
 * validateedit 保存逻辑
 */
function submitInfo(btn, form) {
    var b = true;
    var date = form.getForm().findField("CREATE_DATE").getValue();
    var CREATE_DATE = dsyDateFormatByDay(date);
    //获取单据明细数组
    var recordArray = [];
    var zw_ids = [];
    var zw_names = {};//（分债务）债务名称
    var hk_amt_bc = {};//（分债务）本次还款总计
    var zw_ye_amt = {};//（分债务）债务余额
    form.down('grid').getStore().each(function (record) {

        if (record.get('CH_TYPE') == '0') {
            if (hk_amt_bc[record.get('ZW_ID')] == undefined) {
                zw_ids.push(record.get('ZW_ID'));
                zw_names[record.get('ZW_ID')] = record.get('ZW_NAME');
                hk_amt_bc[record.get('ZW_ID')] = record.get('APPLY_AMT');
            } else {
                hk_amt_bc[record.get('ZW_ID')] += record.get('APPLY_AMT');
            }
            if (zw_ye_amt[record.get('ZW_ID')] == undefined) {
                zw_ye_amt[record.get('ZW_ID')] = record.get('YE_AMT');
            }
        }
        var PAY_DATE = record.get('PAY_DATE');

        if (PAY_DATE == "" || PAY_DATE == null) {
            Ext.Msg.alert('提示', '还款日期不能为空');
            b = false;
            return;
        } else {
            PAY_DATE = dsyDateFormat(PAY_DATE);
            if (!compareDate(PAY_DATE, '还款日期')) {
                b = false;
            } else {
                record.set('PAY_DATE', PAY_DATE);
            }
        }

        if (record.get('CH_TYPE') == null || record.get('CH_TYPE') == "") {
            Ext.Msg.alert('提示', '请选择 类型 !');
            b = false;
            return;
        }
        if (record.get('ZJLY_ID') == null || record.get('ZJLY_ID') == "") {
            Ext.Msg.alert('提示', '请选择偿还资金来源!');
            b = false;
            return;
        }
        if (!record.get('APPLY_AMT') || record.get('APPLY_AMT') == null || record.get('APPLY_AMT') == 0) {//允许录入金额为负的还本
            message_error = '还款金额不能为空';
            Ext.Msg.alert('提示', '还款金额不能为空');
            b = false;
            return;
        }
        var type = record.get('CHBJ_TYPE');
        if (type == null || type == "") {
            Ext.Msg.alert('提示', '请选择 还款类型 !');
            b = false;
            return;
        }

        if (record.get('JZ_DATE') == "" || record.get('JZ_DATE') == null) {
            Ext.Msg.alert('提示', '记账日期不能为空');
            b = false;
            return;
        } else {
            var JZ_DATE = dsyDateFormat(record.get('JZ_DATE'));
            var sss = dsyDateFormat(JZ_DATE);
            if (!compareDate(sss, '记账日期')) {
                b = false;
            } else {
                record.set('JZ_DATE', sss);
            }
        }

        if (record.get('JZ_NO') == "" || record.get('JZ_NO') == null) {
            Ext.Msg.alert('提示', '会计凭证号不能为空');
            b = false;
            return;
        }
        recordArray.push(record.getData(record.get('JZ_DATE')));
    });
    if (zw_ids.length > 0) {
        for (var i = 0; i < zw_ids.length; i++) {
            if (accSub(zw_ye_amt[zw_ids[i]],hk_amt_bc[zw_ids[i]]) < 0 && Math.abs(accSub(zw_ye_amt[zw_ids[i]],hk_amt_bc[zw_ids[i]])) > 0.01) {
                Ext.Msg.alert('提示', '债务名称为： "' + zw_names[zw_ids[i]] + '" 的债务</br>本次还款金额总计超出债务余额！');
                b = false;
                return false;
            }
        }
    }
    var parameters = {
        wf_id: wf_id,
        node_code: node_code,
        button_name: button_name,
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_CODE: AG_CODE,
        AG_NAME: AG_NAME,
        // PAY_DATE:PAY_DATE,
        CREATE_DATE: CREATE_DATE,
        IS_WF: IS_WF,
        detailList: Ext.util.JSON.encode(recordArray)
    };

    if (button_name == '修改') {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        // var CHBJ_CODE = form.getForm().findField('CHBJ_CODE').getValue();
        parameters['CHBJ_CODE'] = records[0].get('CHBJ_CODE');
        parameters['CHBJ_ID'] = records[0].get('CHBJ_ID');

    }
    if (!b) {
        return;
    }

    if (form.isValid()) {
        btn.setDisabled(true);
        //保存表单数据及明细数据
        form.submit({
            //设置表单提交的url
            url: '/saveZwglHbfxGrid.action',
            params: parameters,
            success: function (form, action) {
                //关闭弹出框
                btn.up("window").close();
                //提示保存成功
                Ext.toast({
                    html: "<center>保存成功!</center>",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
            },
            failure: function (form, action) {
                btn.setDisabled(false);
                var result = Ext.util.JSON.decode(action.response.responseText);
                Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                //DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
            }
        });
    }
}
/**
 * 查询按钮实现
 */
function getHbfxDataList() {
    var store = DSYGrid.getGrid('contentGrid').getStore();
    var mhcx = Ext.ComponentQuery.query('textfield[name="contentGrid_search"]')[0].value;
    //var is_tqhk = Ext.ComponentQuery.query('combobox[name="is_tqhk"]')[0].value;
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_CODE: AG_CODE,
        wf_status: WF_STATUS,
        wf_id: wf_id,
        node_code: node_code,
        mhcx: mhcx,
        //  is_tqhk: is_tqhk,
        zwlb_id: zwlb_id
    };
    store.loadPage(1);
}
/**
 * 删除按钮实现
 */
function delHbfxDataSelectedList(btn) {
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            button_name = btn.text;
            var ids = new Array();
            for (var i in records) {
                ids.push(records[i].get("CHBJ_ID"));
            }
            //发送ajax请求，删除数据
            $.post("/deleteHbfxSbGrid.action", {
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
                } else {
                    Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                }
                //刷新表格
                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
            }, "json");
        }
    });
}
/**
 * 送审
 */
function doWorkFlow(btn) {
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var ids = new Array();
    var idsFj = new Array();
    for (var i in records) {
        ids.push(records[i].get("CHBJ_ID"));
        if(records[i].get("HOLD2")=='正常录入'){
            idsFj.push(records[i].get("CHBJ_ID"));
        }
    }
    button_name = btn.text;
    btn.name = 'send';
    button_id = btn.name;
    //是否确认送审
    Ext.MessageBox.show({
        title: "提示",
        msg: "确认送审选中记录？",
        width: 200,
        buttons: Ext.MessageBox.OKCANCEL,
        fn: function (buttonId,text) {
        	if (buttonId === 'ok') {
                //发送ajax请求，修改节点信息
                $.post("/doWorkFlowAction.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: '',
                    ids: ids,
                    idsFj:idsFj,
                    is_end: is_end
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: data.msg,
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                    } else {
                        Ext.MessageBox.alert('提示', data.msg);
                    }
                    //刷新表格
                    DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                }, "json");
            }
        }
    });
}
function compareDate(date, typeString) {

    var sysDate = new Date();
    var today = '';
    today = sysDate.getFullYear() + '-'
        + (sysDate.getMonth() < 9 ? ('0' + (sysDate.getMonth() + 1)) : (sysDate.getMonth() + 1)) + '-'
        + (sysDate.getDate() < 10 ? ('0' + (sysDate.getDate())) : (sysDate.getDate()));

    if (date > today) {
        Ext.MessageBox.alert('提示', typeString + "晚于当前日期！");
        return false;
    }
    return true;

}
/**
 * 还本付息资金审核撤销送审
 */
function cancleCheck(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
    	 Ext.MessageBox.show({
             title: '提示',
             msg: "是否撤销选择的记录？",
             width: 200,
             buttons: Ext.MessageBox.OKCANCEL,
             fn: function (btn) {
                 //button_name = btn.text;
                 if (btn == "ok") {
                	  var hbfxInfoArray = [];
                      Ext.each(records, function (record) {
                          var array = {};
                          array.ID = record.get("CHBJ_ID");
                          hbfxInfoArray.push(array);
                      });
                      var btn_name = 'cancel';

                      //向后台传递变更数据信息
                      Ext.Ajax.request({
                          method: 'POST',
                          url: 'doWorkFlowAction.action',
                          params: {
                              workflow_direction: btn_name,
                              wf_id: wf_id,
                              node_code: node_code,
                              button_name: button_name,
                              is_end: is_end,
                              hbfxInfoArray: Ext.util.JSON.encode(hbfxInfoArray)

                          },
                          async: false,
                          success: function (form, action) {
                              Ext.toast({
                                  html: '撤销送审成功',
                                  closable: false,
                                  align: 't',
                                  slideInDuration: 400,
                                  minWidth: 400
                              });
                              DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                          },
                          failure: function (form, action) {
                              Ext.MessageBox.show({
                                  title: '提示',
                                  msg: '撤销送审失败',
                                  width: 200,
                                  fn: function (btn) {
                                      DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                                  }
                              });
                          }
                      });
                 }
             }
         });

    }
}


