/**
 *  页面初始化
 */
var SET_YEAR= url_xm_id != '' &&　url_xm_id != null? '' :  new Date().getFullYear();
var gclb_store= DebtEleTreeStoreDBTable('dsy_v_ele_gclb_zc');//20210331_zhuanrx_湖北十大工程工程类别专用
$(document).ready(function () {
    initContent();
    //zhanghl 20200104 延时等其他加载完成之后在进行弹窗弹开
    setTimeout(function(){
        //从单位新首页跳转过来
        if(url_xm_id != null && url_xm_id != ''){
            if(node_type == 'lr'){
                button_text = '录入';
                editValue = true;
                button = save_button;
                button_name = 'INPUT';
                //关闭当前窗口，打开合同变更录入窗口
                XM_ID = url_xm_id;
                var btn = '';
                if(node_type=='lr'){//20210526LIUYE 控制审核界面不添加弹出框
                    zqbfmxInfo_select_window(btn);
                }
            }

        }
    }, 1000);
});
Ext.define('treeModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'text'},
        {name: 'code'},
        {name: 'id'},
        {name: 'leaf'}
    ]
});
/**
 * 表格中树下拉store
 */
var store_dw = Ext.create('Ext.data.TreeStore', {
    proxy: {
        type: 'ajax',
        method: 'POST',
        url: '/getdwstore.action?method=getZddwTreeStore',
        extraParams: {
            AD_CODE:dw_AD_CODE
        },
        reader: {
            type: 'json'
        }
    },
//        root:'nodelist' ,
    root: {
        expanded: true,
        text: "全部",
        children: [
            {text: "单位", id:"", leaf: true}
        ]
    },
    model: 'treeModel',
    autoLoad: true
});
/**
 *  初始化主面板
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: zqSjzcXzMain_toolbar_json[node_type].items[WF_STATUS]
            }
        ],
        height: '100%',
        renderTo: Ext.getBody(),
        border: false,
        items: [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧2个表格
        ]
    });

}

/**
 * 初始化右侧panel
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'contentFormPanel',
        height: '100%',
        flex: 5,
        region: 'center',
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                layout: {
                    type: 'column'
                },
                border: true,
                bodyStyle: 'padding:0 0 0 0',
                defaults: {
                    margin: '1 1 2 5',
                    width: 200,
                    labelWidth: 80,//控件默认标签宽度
                    labelAlign: 'left'//控件默认标签对齐方式
                },
                items: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '状态',
                        name: 'WF_STATUS',
                        //store: node_type == 'lr' ? DebtEleStore(json_debt_zt1) : DebtEleStore(json_debt_zt2_3),
                        //20210607 fzd 资金划拨状态改为确认、未确认（需区分实物工作量功能）
                        store: node_type == 'lr' ? DebtEleStore(json_debt_zt1)
                            :zjsyqk_type == '1'?DebtEleStore(json_debt_zt11):DebtEleStore(json_debt_zt2_3),
                        width: 110,
                        labelWidth: 30,
                        editable: false,
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
                                toolbar.add(zqSjzcXzMain_toolbar_json[node_type].items[WF_STATUS]);
                                //刷新当前表格
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: "MHCX",
                        labelWidth: 80,
                        width: 300,
                        emptyText: '请输入项目名称/债券名称...',
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

                ]
            }
        ],
        border: false,
        items: [
            initContentGrid()
        ]
    });
}

/**
 * 初始化右侧Panel主表格
 */
function initContentGrid() {
    var contentHeaderJson = [
        {xtype: 'rownumberer', width: 45, dataIndex: "rownumberer"},
        {
            dataIndex: "SJZC_ID",
            type: "string",
            text: "ID",
            width: 80,
            hidden: true
        },
        {
            dataIndex: "XM_ID",
            type: "string",
            width: 80,
            hidden: true
        },
        {
            dataIndex: "SJZC_NO",

            type: "string",
            text: nameUpdate == '1' ? "使用单号":"支出单号",
            width: 150
        },
        {
            dataIndex: "AG_NAME",
            type: "string",
            text: "项目单位",
            width: 250
        },
        {
            dataIndex: "ZQ_NAME",
            type: "string",
            text: "债券名称",
            width: 300,
            renderer: function (data, cell, record) {
                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "ZQ_ID";
                paramNames[1] = "AD_CODE";
                var paramValues = new Array();
                paramValues[0] = record.get('FIRST_ZQ_ID');
                paramValues[1] = record.get('AD_CODE');
                var result = data;/*'<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';*/
                return result;
            }
        },
        {
            dataIndex: "XM_NAME",
            type: "string",
            text: "项目名称",
            width: 300,
            renderer: function (data, cell, record) {
                var url = '/page/debt/common/xmyhs.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                paramNames[1] = 'IS_RZXM';

                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            dataIndex: "SJZC_TYPE",
            type: "string",
            text: "支出类型",
            width: 300,
            hidden:true
        },
        {
            dataIndex: "ZCLX_TYPE",
            type: "string",
            text: "支出类型",
            width: 150,
            hidden:true
        },
        //20210519 fzd 增加资金来源类型
        {
            dataIndex: "LY_TYPE",
            type: "string",
            text: "资金来源类型",
            hidden: false,
            width: 100,
            renderer: function (value, metadata, record) {
                if(isNull(value) || value == '0'){
                    return '无';
                }
                var rec = store_debt_zjly.findRecord('code', value, 0, false, true, true);
                return rec.get('name');
            }
        },
        {
            dataIndex: "XMLX_NAME",
            type: "string",
            text: "项目分类",
            width: 150
        },
        {
            dataIndex: "SJZC_AMT", width: 200, type: "float", text: nameUpdate == '1' ? "本次使用金额(元)":"本次支出金额（元）",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "ZCZY",
            type: "string",
            text: "支出摘要",
            hidden: nameUpdate == '1' ? false : true,
            width: 200
        },
        {
            dataIndex: "ZJYT_GD",
            type: "string",
            text: "资金用途ID",
            hidden: true,
            width: 200
        },
        {
            dataIndex: "VOUCHER_ABS",
            type: "string",
            text: "摘要",
            width: 200
        },
        {
            dataIndex: "ZJYT_NAME_GD",
            type: "string",
            text: "资金用途",
            hidden: nameUpdate == '1' ? false : true,
            width: 200
        },
        {
            dataIndex: "SS_AG_NAME",
            type: "string",
            text: "收款单位",
            width: 200,
            hidden:zjsyqk_type == '2' ? !isHiddenDw || node_type == 'sh' : false
        },
        {
            dataIndex: "XMGYF",
            type: "string",
            text: nameUpdate == '1' ? "收款单位（个人）" :"项目供应商",
            width: 200,
            hidden: node_type== 'sh' && zjsyqk_type == '2' ? false : true
        },
        {
            dataIndex: "CREATE_DATE",
            type: "string",
            text: "录入时间",
            width: 150,
            hidden:nameUpdate == '1' ? false : true
        },
        {
            dataIndex: "",
            type: "string",
            text: "银行账户收支",
            hidden:true
        },
        {
            dataIndex: "REMARK",
            type: "string",
            text: "备注",
            width: 200
        },
        {
            dataIndex: "FJ",
            type: "string",
            text: "附件",
            width: 80,
            hidden:node_type=='sh'?false:true,
            renderer: function (data, cell, record) {
                var ywsjid=record.data.SJZC_ID;
                return '<button style="height: 20px;width: 50px;" onclick="getFJXX(\''+ywsjid+'\')">'+'附件'+'</button>';
            }
        },
        {
            dataIndex:'SJ_ZC_DATE',width:200,type:'string',text:'上级支出日期',hidden:true
        }

    ];
    var grid = DSYGrid.createGrid({
        itemId: 'contentGrid',
        flex: 1,
        autoLoad: false,
        border: false,
        checkBox: true,
        headerConfig: {
            headerJson: contentHeaderJson,
            columnAutoWidth: false
        },
        enableLocking:false,
        dataUrl: 'getZqxmSjzcInfo.action',
        params: {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: !!AG_CODE?AG_CODE:(!!USER_AG_CODE?USER_AG_CODE:""),
            wf_id: wf_id,
            node_code: node_code,
            node_type: node_type,
            button_name: button_name,
            ZJSYQK_TYPE:zjsyqk_type.toString(),//2021051814_dengzq_资金使用情况类型：项目资金转拨登记or项目实物工作量登记
            WF_STATUS: WF_STATUS,
            dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
        },
        pageConfig: {
            pageNum: true,//设置显示每页条数
            enablePage: true
        },
        listeners: {
            itemdblclick: function (self, record) {
                editValue = false;
                button = [];
                var xmzxFormRecords = record.getData();
                xzzqSjzcId = xmzxFormRecords.SJZC_ID;
                zqxmSjzc_insert_window();
                XM_ID = xmzxFormRecords.XM_ID;
                skdwStore.getProxy().extraParams['XM_ID'] = XM_ID;
                skdwStore.load();
                var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_zqxmSjzcTb_form"]')[0];
                xmtztbForm.getForm().setValues(xmzxFormRecords);
                // 项目资金划拨登记计算可支出金额
                if(zjsyqk_type == '1'){
                    var kzc_amt = xmzxFormRecords.BF_AMT - xmzxFormRecords.YZC_AMT;
                    xmtztbForm.getForm().findField("KZC_AMT").setValue(kzc_amt);
                }
                button_name = '';
                SetFormItemsReadOnly(xmtztbForm.items);
            }
        }
    });

    return grid;
}

/**
 *  获取债券拨付到项目资金明细
 */
function zqbfmxInfo_select_window(btn) {
    var window = Ext.create('Ext.window.Window', {
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.9, //自适应窗口高度
        title: zjsyqk_type == 1 ? '项目资金划拨登记': '项目实物工作量登记', // 窗口标题
        itemId: 'item_zqbfmxInfo_select_windows', // 窗口标识
        layout: 'fit',
        maximizable: true, //最大化按钮
        buttonAlign: 'right', // 按钮显示的位置
        closeAction: 'destroy', //hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        items: [init_zqbfmxInfo_Grid()],
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    var records = btn.up('window').down('grid').getSelection(); // 获取选中数据信息
                    XM_ID = records[0].get('XM_ID');
                    //getYhzhGrid(XM_ID);
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
                        btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
                        $.post('/getZqxmSjzcZcNo.action', {
                            AD_CODE: AD_CODE
                        }, function (data) {
                            if (!data.success) {
                                btn.setDisabled(true);
                                Ext.MessageBox.alert('提示', '获取项目相关信息失败！' + data.message);
                                return;
                            }
                            xzzqSjzcId = GUID.createGUID();
                            //根据具体项目来控制工程类别的下拉框
                            var ZQ_ID=records[0].getData().ZQ_ID;
                            var XM_ID=records[0].getData().XM_ID;
                            gclb_store=DebtEleTreeStoreDBTable('dsy_v_ele_gclb_zc',{condition: " and xm_id = '"+XM_ID+"' AND ZQ_ID = '"+ZQ_ID+"' "});
                            if(isNull(XM_ID)){
                                yhzhStore=DebtEleStoreTable('DEBT_V_YH_ZJSZLS',{condition: " and 1=0  "});
                            }else{
                                yhzhStore=DebtEleStoreTable('DEBT_V_YH_ZJSZLS',{condition: " and xm_id = '"+XM_ID+"'  "});
                            }
                            zqxmSjzc_insert_window(btn);
                            var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_zqxmSjzcTb_form"]')[0];
                            var xmtzFormRecords = records[0].getData();
                            xmtzFormRecords.SJZC_ID = xzzqSjzcId;
                            xmtzFormRecords.SJZC_NO = data.list[0].SJZC_NO;
                            xmtztbForm.getForm().setValues(xmtzFormRecords);
                            // 项目资金划拨登记计算可支出金额
                            if(zjsyqk_type == '1'){
                                var kzc_amt = records[0].getData().BF_AMT - records[0].getData().YZC_AMT;
                                xmtztbForm.getForm().findField("KZC_AMT").setValue(kzc_amt);
                            }
                   /*         xmtztbForm.getForm().findField("SS_AG_ID").setValue('');
                            xmtztbForm.getForm().findField("SS_AG_ID").setReadOnly(true);
                            xmtztbForm.getForm().findField("SS_AG_ID").setFieldStyle('background:#E6E6E6');
                            xmtztbForm.getForm().findField("XMGYF").setValue('');
                            xmtztbForm.getForm().findField("XMGYF").setReadOnly(true);
                            xmtztbForm.getForm().findField("XMGYF").setFieldStyle('background:#E6E6E6');*/
                            btn.up('window').close();
                        }, 'json');

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
}

/**
 *  初始化实际拨付gridpanel
 */
function init_zqbfmxInfo_Grid() {
    var zxkXmtz_Grid_headerjson = [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "XM_ID", width: 150, type: "string", text: "唯一ID", hidden: true},
        {dataIndex: "AG_NAME", width: 250, type: "string", text: "项目单位"},
        {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
        {
            dataIndex: "XM_NAME", width: 400, type: "string", text: "项目名称",
            renderer: function (data, cell, record) {
                var url = '/page/debt/common/xmyhs.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                paramNames[1] = 'IS_RZXM';
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));
                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {dataIndex: "XMLX_NAME", width: 300, type: "string", text: "项目类型"},
        //20210518 fzd 增加资金来源类型
        {dataIndex: "LY_TYPE", width: 200, type: "string", text: "资金来源类型",
            renderer: function (value, metadata, record) {
                if(isNull(value) || value == '0'){
                    return '无';
                }
                var rec = store_debt_zjly.findRecord('code', value, 0, false, true, true);
                return rec.get('name');
            }
        },
        {
            dataIndex: "BF_AMT", width: 150, type: "float", text: "已到位金额（元）",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "YZC_AMT", width: 180, type: "float", text: nameUpdate == '1' ? "已使用金额(元)":"已支出金额（元）",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "SJZC_AMT", width: 200, type: "float", text: nameUpdate == '1' ? "剩余可使用金额(元)" : "剩余可支出金额（元）",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "ZQ_CODE", width: 150, type: "string", text: "债券编码"},
        {
            dataIndex: "ZQ_NAME", width: 400, type: "string", text: "债券名称"
        },
        {
            dataIndex:'SJ_ZC_DATE',width:200,type:'string',text:'上级支出日期',hidden:true
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'item_zqbfmxInfo_grid',
        flex: 1,
        autoLoad: true,
        border: false,
        checkBox: true,
        headerConfig: {
            headerJson: zxkXmtz_Grid_headerjson,
            columnAutoWidth: false
        },
        dataUrl: 'getZqxmZcInfo.action',
        params: {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            SET_YEAR:SET_YEAR,
            XM_ID: url_xm_id, //单位新首页跳转过来
            dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
        },
        tbar: [
            {
                xtype: "textfield",
                fieldLabel: '模糊查询',
                itemId: "XM_SEARCH",
                labelWidth: 80,
                width: 300,
                emptyText: '请输入项目名称/债券名称...',
                enableKeyEvents: true,
                listeners: {
                    'keydown': function (self, e, eOpts) {
                        var key = e.getKey();
                        if (key == Ext.EventObject.ENTER) {
                            reloadTzxmGrid(self);
                        }
                    }
                }
            },
            {
                xtype: "combobox",
                name: "SET_YEAR",
                store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"}),
                displayField: "name",
                valueField: "id",
                value: url_xm_id != '' && url_xm_id != null?'' : new Date().getFullYear(),
                fieldLabel: '支出年度',
                editable: false, //禁用编辑
                labelWidth: 80,
                width: 200,
                labelAlign: 'right',
                listeners: {
                    change: function (self, newValue) {
                        //刷新当前表格
                       reloadTzxmGrid(self);
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    reloadTzxmGrid(btn);
                }
            }
        ],
        selModel: {
            mode: "SINGLE"
        },
        pageConfig: {
            pageNum: true,//设置显示每页条数
            enablePage: true
        }
    });
    return grid;
}

/**
 * 刷新债券项目拨付信息
 * @param btn
 */
function reloadTzxmGrid(btn) {
    var xmSelectGrid = btn.up('grid');
    var xmSelectGridStore = xmSelectGrid.getStore();
    xmSelectGridStore.removeAll();
    var xm_search = xmSelectGrid.down('textfield[itemId="XM_SEARCH"]').getValue();
    var SET_YEAR = xmSelectGrid.down('combobox[name="SET_YEAR"]').getValue();
/*    if(SET_YEAR==null||SET_YEAR==''||SET_YEAR=='undefined'){
        SET_YEAR= url_xm_id != '' && url_xm_id != null? '' : new Date().getFullYear();
    }*/
    xmSelectGridStore.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_CODE: AG_CODE,
        XM_SEARCH: xm_search,
        SET_YEAR:SET_YEAR,
        XM_ID: url_xm_id, //单位新首页跳转过来
        dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
    };
    xmSelectGridStore.loadPage(1);
}

/**
 * 债券项目实际支出信息填报窗口
 */
function zqxmSjzc_insert_window() {
    var title = zjsyqk_type == 1 ? '项目资金划拨登记': '项目实物工作量登记';
    var window = Ext.create('Ext.window.Window', {
        width: document.body.clientWidth*0.9, // 窗口宽度
        height: document.body.clientHeight*0.92,
        title: title,
        itemId: 'item_zqxmSjzcTb_window',
        layout: 'fit',
        frame: true,
        constrain: true, // 防止超出浏览器边界
        buttonAlign: "right", // 按钮显示的位置：右下侧
        maximizable: true,//最大化按钮
        modal: true,//模态窗口
        resizable: true,//可拖动改变窗口大小
        closeAction: 'destroy',
        items: [initWiondow_zqxmSjzcTbForm()],
        buttons: button
    });
    window.show();
    return window;
}

/**
 * 债券项目实际支出信息填报
 */
function initWiondow_zqxmSjzcTbForm() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'item_zqxmSjzcTb_form',
        name: 'item_zqxmSjzcTb_form',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        scrollable: 'true',
        fileUpload: true,
        border: false,
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                anchor: '100%',
                defaultType: 'textfield',
                scrollable: 'true',
                defaults: {
                    margin: '2 5 4 5',
                    //padding: '2 5 0 5',
                    columnWidth: .33,
                    labelWidth: 120//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        name: "SJZC_ID",
                        fieldLabel: '虚拟主单id',
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        name: "ZC_ID",
                        fieldLabel: '拨付支出单ID',
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        name: "SJZC_TYPE",
                        fieldLabel: '支出类型',
                        hidden: true,
                        editable: false//禁用编辑
                    },
                    {
                        xtype: "textfield",
                        name: "AD_CODE",
                        fieldLabel: '地区编码',
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        name: "AG_ID",
                        fieldLabel: '单位ID',
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        name: "AG_CODE",
                        fieldLabel: '单位编码',
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        name: "AG_NAME",
                        fieldLabel: '项目单位',
                        allowDecimals: true,
                        editable: false,//禁用编辑
                        decimalPrecision: 2,
                        hideTrigger: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        name: "SJZC_NO",
                        fieldLabel: nameUpdate == '1' ? '使用单号' : '支出单号',
                        allowBlank: false,
                        allowDecimals: true,
                        editable: false,//禁用编辑
                        decimalPrecision: 2,
                        hideTrigger: true,
                        fieldStyle: 'background:#E6E6E6'

                    },
                    {
                        xtype: "textfield",
                        name: "XM_ID",
                        fieldLabel: '项目ID',
                        hidden: true,
                        decimalPrecision: 2,
                        allowDecimals: true,
                        hideTrigger: true
                    },
                    {
                        xtype: "textfield",
                        name: "XM_CODE",
                        fieldLabel: '项目编码',
                        allowDecimals: true,
                        editable: false,//禁用编辑
                        decimalPrecision: 2,
                        hideTrigger: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        name: "XM_NAME",
                        fieldLabel: '项目名称',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        editable: false,//禁用编辑
                        hideTrigger: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        name: "XMLX_NAME",
                        fieldLabel: '项目分类',
                        allowDecimals: true,
                        editable: false,//禁用编辑
                        decimalPrecision: 2,
                        hideTrigger: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        name: "ZQ_ID",
                        fieldLabel: '债券ID',
                        hidden: true,
                        allowDecimals: true,
                        decimalPrecision: 2,
                        hideTrigger: true
                    },
                    {
                        xtype: "textfield",
                        name: "ZQ_CODE",
                        fieldLabel: '债券编码',
                        fieldStyle: 'background:#E6E6E6',
                        allowDecimals: true,
                        editable: false,//禁用编辑
                        decimalPrecision: 2,
                        hideTrigger: true
                    },
                    {
                        xtype: "textfield",
                        name: "ZQ_NAME",
                        fieldLabel: '债券名称',
                        allowDecimals: true,
                        editable: false,//禁用编辑
                        decimalPrecision: 2,
                        hideTrigger: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "textfield",
                        name: "ZQQX_NAME",
                        fieldLabel: '债券期限',
                        allowDecimals: true,
                        editable: false,//禁用编辑
                        decimalPrecision: 2,
                        hideTrigger: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "BF_AMT",
                        fieldLabel: nameUpdate == '1' ? '债券金额(元)' : '已到位金额(元)',//2021051711_dengzq_【已收到债券资金】改为【已到位金额】
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true,
                        decimalPrecision: 6,
                        emptyText: '0.000000',
                        allowDecimals: true,
                        hideTrigger: true
                    },
                    {
                        xtype: "numberFieldFormat",//20210512liyue增加债券发行金额
                        name: "ZQFX_AMT",
                        fieldLabel: '债券发行金额',
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true,
                        hidden:true,
                        decimalPrecision: 6,
                        emptyText: '0.000000',
                        allowDecimals: true,
                        hideTrigger: true
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "YZC_AMT",
                        fieldLabel: nameUpdate == '1' ? '已使用金额(元)' : '已支出金额(元)',
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true,
                        decimalPrecision: 6,
                        emptyText: '0.000000',
                        allowDecimals: true,
                        hideTrigger: true
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "KZC_AMT",
                        fieldLabel: '可支出金额（元）',
                        editable: false,//禁用编辑
                        fieldStyle: 'background:#E6E6E6',
                        readOnly: true,
                        hidden: zjsyqk_type == 1 ? false : true,
                        decimalPrecision: 6,
                        emptyText: '0.000000',
                        allowDecimals: true,
                        hideTrigger: true
                    }
                ]
            },
            {   // 分割线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                anchor:'100%',
                defaultType: 'textfield',
                scrollable:'y',
                defaults: {
                    margin: '2 5 4 5',
                    //padding: '2 5 0 5',
                    columnWidth: .33,
                    labelWidth: 120//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "combobox",
                        name: "ZCLX_TYPE",
                        store: DebtEleStore(json_debt_zclx),
                        displayField: "name",
                        valueField: "id",
                        value:ZCLX_TYPE,
                        allowDecimals: true,
                        enableKeyEvents: true,
                        fieldLabel: '<span class="required">✶</span>支出类型',
                        // hidden: true,
                        editable: false, //禁用编辑
                        allowBlank: true,
                         listeners: {
                            change:function(self,newValue,oldValue) {

                                // if( zjsyqk_type == 1 ){
                                //     var form = Ext.ComponentQuery.query('form#item_zqxmSjzcTb_form')[0];
                                //     // form.getForm().findField("SS_AG_ID").setValue('');
                                //     form.getForm().findField("SS_AG_ID").setReadOnly(false);
                                //     form.getForm().findField("SS_AG_ID").setFieldStyle('background:#ffffff');
                                //     // form.getForm().findField("XMGYF").setValue('');
                                //     form.getForm().findField("XMGYF").setReadOnly(false);
                                //     form.getForm().findField("XMGYF").setFieldStyle('background:#ffffff');
                                //     if( newValue =='2'||newValue=='实际支出'){
                                //         form.getForm().findField("SS_AG_ID").setValue('');
                                //         form.getForm().findField("SS_AG_ID").setReadOnly(true);
                                //         form.getForm().findField("SS_AG_ID").setFieldStyle('background:#E6E6E6');
                                //         /*   form.getForm().findField("XMGYF").setHidden(false);
                                //            ZCLX_TYPE=newValue*/
                                //         newValue=2;
                                //     }else if(newValue =='1'||newValue=='资金转拨'){
                                //         form.getForm().findField("XMGYF").setValue('');
                                //         form.getForm().findField("XMGYF").setReadOnly(true);
                                //         form.getForm().findField("XMGYF").setFieldStyle('background:#E6E6E6');
                                //         newValue=1;
                                //     }
                                //     ZCLX_TYPE=newValue;//20210512LIYUE通过支出类型控制项目供应商是否隐藏
                                //     return newValue;
                                // }
                            }
                        }
                    },
                    {
                        xtype: "treecombobox",
                        name: 'GCLB_ID',
                        fieldLabel: '<span class="required">✶</span>工程类别',
                        displayField: 'text',
                        valueField: 'id',
                        editable:false,
                        store: gclb_store,
                        rootVisible: false,
                        lines: false,
                        allowblank:sysAdcode=='42'?false:true,
                        selectModel: 'leaf',
                        hidden:sysAdcode=='42'?false:true  //根据具体项目来控制工程类别的下拉框
                    },
                    //2021051815_dengzq_增加“国库资金是否直接对应实物工作量”复选框
                    {
                        xtype: 'fieldcontainer',
                        fieldLabel: '国库资金是否直接对应实物工作量',
                        labelWidth: 230,
                        name:'GKZJ_FOR',
                        defaultType: 'checkboxfield',
                        columnWidth: .33,
                        hidden: true,
                        allowBlank: true,
                        margin: "0 0 0 5" ,
                        items: [
                            {
                                boxLabel  : '是',
                                id        : 'GKZJ_FOR_SWGZL',
                                name      : 'GKZJ_FOR_SWGZL',
                                inputValue: '1',
                                uncheckedValue: '0'
                            }
                        ]
                    },
                    {
                        xtype: "combobox",//202105412LIYUE添加是否国库集中支付
                        name: "IS_GKJZZF",
                        store: DebtEleStore(json_debt_sf),
                        displayField: "name",
                        valueField: "id",
                        allowDecimals: true,
                        columnWidth: .33,
                        enableKeyEvents: true,
                        fieldLabel: '是否国库集中支付',
                        editable: false, //禁用编辑
                        hidden: true,
                        allowBlank: true,
                        listeners: {
                            change:function(self,newValue,oldValue) {
                            /*    var form = Ext.ComponentQuery.query('form#item_zqxmSjzcTb_form')[0];
                                if(newValue=='1'){//是国库支付控制银行账户收支不必录
                                    var form = Ext.ComponentQuery.query('form#item_zqxmSjzcTb_form')[0];
                                    form.getForm().findField("GKZF_NO").setFieldLabel('<span class="required">✶</span>国库支付凭证号');
                                }else {
                                    form.getForm().findField("GKZF_NO").setFieldLabel('国库支付凭证号');
                                }*/
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        name: "GKZF_NO",
                        fieldLabel: '国库支付凭证号',
                        hidden: true
                    },
                  /*  {
                        xtype: "popupGridForSjzc",
                        name: "YHZHSZ",
                        //store: DebtEleStore(json_debt_yhzh),
                        displayField : 'name',
                        valueField : 'id',
                        store: SjzcyhStore,
                        fieldLabel: '<span class="required">✶</span>银行收支流水',
                        columnWidth: .33,
                        editable: true,
                        listeners: {
                            'focus': function (self,newValue,oldValue) {
                                var form = self.up('form').getForm();
                                var xm_id = form.findField('XM_ID').rawValue;
                                SjzcyhStore.getProxy().extraParams['XM_ID'] = xm_id;
                                SjzcyhStore.load();
                            }
                        },
                    },*/
             /*       {
                        xtype: 'container',
                        layout: 'column',
                        anchor: '100%',
                        defaultType: 'textfield',
                        defaults: {
                            //width: 315,
                            //labelWidth: 180,
                            //  columnWidth: 20,
                            // margin: ,

                        },
                        items: [*/
                            {
                                xtype: 'combobox',
                                name: "LY_TYPE",
                                fieldLabel: '资金来源类型',
                                displayField: 'name',
                                valueField: 'code',
                                allowDecimals: true,
                                readOnly: true,
                                editable: false,//禁用编辑
                                decimalPrecision: 2,
                                store: store_debt_zjly,
                                hideTrigger: true,
                                //hidden:true,
                                fieldStyle: 'background:#E6E6E6',

                            },
                            {
                                xtype: 'combobox',
                                fieldLabel: '<span class="required">✶</span>银行交易流水号/支付凭证号',
                                name: 'YHZHSZ',
                                displayField: 'GUID',
                                valueField: 'GUID',
                                rootVisible: false,
                                labelWidth: 180,
                                lines: false,
                                emptyText: '请输入...',
                              //  labelWidth: 125,
                               // columnWidth: 0.95,
                                preValue:'',
                                hideTrigger:true,//隐藏下拉按钮
                                isCanReq:true,
                                selectModel: 'leaf',
                                enableKeyEvents: true,
                                //20210708 zhuangrx 银行收支流水号格式修改
                                regex: /^[a-zA-Z0-9]{0,44}$/,
                                maxLength:44,
                                regexText : '格式错误，必须为数字或英文！',
                                allowBlank: false,
                                store: Ext.create('Ext.data.Store', {

                                    fields: ["GUID", "CODE", "NAME", "AD_NMAE", "ACC_NO", "ACC_NAME", "ACC_BANK_NAME", "REFNBR", "ETYTIM", "TSDAMT","RPYACC","RPYNAM","NUSAGE"],
                                    remoteSort: true,// 后端进行排序
                                    extraParams:{},
                                    proxy: {// ajax获取后端数据
                                        type: "ajax",
                                        method: "POST",
                                        url: "/getyhlsSjzcStroe.action",
                                        reader: {
                                            type: "json"
                                        },
                                        simpleSortMode: true

                                    },
                                    autoLoad: false
                                }),
                                listeners:{
                                    keyup:function(t){
                                        var XM_ID = t.up('form').getForm().findField('XM_ID').getValue();
                                        if(XM_ID ){
                                            var value = t.getValue();
                                            if(value == t.preValue){
                                                return false;
                                            }
                                            var regex = new RegExp('[0-9]');
                                            t.setValue(value);
                                            t.preValue = value;
                                            if(t.isCanReq){
                                                t.isCanReq = false;
                                                var store = t.getStore();
                                                store.getProxy().extraParams['MHCX'] = value;
                                                store.getProxy().extraParams['XM_ID'] = XM_ID;
                                                store.load();
                                                t.expand();
                                                setTimeout(function(){
                                                        t.isCanReq = true;
                                                    },
                                                    300);
                                            }

                                        }
                                    },
                                    focus:{
                                        fn:function (t) {
                                            //20210810 fzd 双击时，银行流水不再显示下拉框
                                            if(!editValue){
                                                return;
                                            }
                                            var XM_ID = t.up('form').getForm().findField('XM_ID').getValue();
                                            if(XM_ID) {
                                                var value = t.getValue();
                                                if (button_name != 'UPDATE' && value != t.preValue) {
                                                    t.preValue = value;
                                                    var store = t.getStore();
                                                    store.getProxy().extraParams['MHCX'] = value;
                                                    store.getProxy().extraParams['XM_ID'] = XM_ID;

                                                    if(!(value==null)){
                                                        store.load();
                                                    }
                                                }
                                                t.expand();
                                            }
                                        }
                                    },
                                    change:function(self, newValue) {
                                         var record = self.getStore().findRecord('GUID', newValue, 0, false, true, true);
                                        if(!isNull(record) && button_name != '') {
                                            Ext.ComponentQuery.query('numberFieldFormat[name="SJZC_AMT"]')[0].setValue(record.data.TSDAMT);
                                            Ext.ComponentQuery.query('textfield[name="ZCZY"]')[0].setValue(record.data.NUSAGE);
                                            // 资金划拨登记带出收款单位及社会信用代码
                                            if(zjsyqk_type == '1'){
                                                var XM_ID = self.up('form').getForm().findField('XM_ID').getValue();
                                                skdwStore.getProxy().extraParams['XM_ID'] = XM_ID;
                                                skdwStore.load();
                                                //20211214 项目资金转拨登记 填写银行交易流水号/支付凭证号时，收款单位、实际收款人全称、本次支出金额（元）不重置为空
                                                if(!isNull(record.data.SKDW_ID)) {
                                                    Ext.ComponentQuery.query('PopupGridForSkdw[name="SS_AG_ID"]')[0].setValue(record.data.SKDW_ID);
                                                }
                                                if(!isNull(record.data.USC_CODE)) {
                                                    Ext.ComponentQuery.query('textfield[name="XPAYEE_ACCT_UNI_CODE"]')[0].setValue(record.data.USC_CODE);
                                                }

                                            }else{
                                                //20211221 项目实物工作量登记 填写银行交易流水号/支付凭证号时，实际收款人账号等不重置为空
                                                if(!isNull(record.data.RPYACC)){
                                                    Ext.ComponentQuery.query('textfield[name="XPAYEE_ACCT_NO"]')[0].setValue(record.data.RPYACC); //实际收款人账号
                                                }
                                                if(!isNull(record.data.RPYNAM)) {
                                                    Ext.ComponentQuery.query('textfield[name="XPAYEE_ACCT_NAME"]')[0].setValue(record.data.RPYNAM); //实际收款人全称
                                                }
                                                if(!isNull(record.data.ACC_BANK_NAME)) {
                                                    Ext.ComponentQuery.query('textfield[name="BANK_DEPOSIT_NAME"]')[0].setValue(record.data.ACC_BANK_NAME); //开户银行名称
                                                }
                                            }
                                        //20210629 双击打开时点击银行流水不允许修改字段值
                                        }else if(editValue){
                                            // 资金划拨登记带出收款单位及社会信用代码
                                            if(zjsyqk_type == '1'){ //zjsyqk_type=1 项目资金转拨登记 和 zjsyqk_type=2 项目实物工作量登记
                                                //20211214 项目资金转拨登记 填写银行交易流水号/支付凭证号时，收款单位、实际收款人全称、本次支出金额（元）不重置为空
                                                // Ext.ComponentQuery.query('numberFieldFormat[name="SJZC_AMT"]')[0].setValue(0); //本次支出金额(元)
                                                // Ext.ComponentQuery.query('textfield[name="ZCZY"]')[0].setValue(''); //支出摘要
                                                // Ext.ComponentQuery.query('PopupGridForSkdw[name="SS_AG_ID"]')[0].setValue(''); //收款单位
                                                // Ext.ComponentQuery.query('textfield[name="XPAYEE_ACCT_UNI_CODE"]')[0].setValue(''); //统一社会信用代码
                                            }else{
                                                //20211221 项目实物工作量登记 填写银行交易流水号/支付凭证号时，实际收款人账号等不重置为空
                                                // Ext.ComponentQuery.query('numberFieldFormat[name="SJZC_AMT"]')[0].setValue(0); //本次支出金额(元)
                                                // Ext.ComponentQuery.query('textfield[name="ZCZY"]')[0].setValue(''); //支出摘要
                                                // Ext.ComponentQuery.query('textfield[name="XPAYEE_ACCT_NO"]')[0].setValue(''); //实际收款人账号
                                                // Ext.ComponentQuery.query('textfield[name="XPAYEE_ACCT_NAME"]')[0].setValue(''); //实际收款人全称
                                                // Ext.ComponentQuery.query('textfield[name="BANK_DEPOSIT_NAME"]')[0].setValue(''); //开户银行名称
                                            }
                                        }
                                    },
                                    beforequery : function () {
                                        return false;
                                    },
                                    render:function(self){
                                        Ext.QuickTips.init();
                                        Ext.QuickTips.register({
                                            target : self.el,
                                            text : '输入银行流水号/支付凭证号，默认检索'
                                        });
                                    }
                                }
                            },
                          /*  {
                                xtype: 'popupGridForSjzc',
                                name:'popupGridForSjzc',
                                emptyText: '...',
                                cloumuwidth:0.1,
                                width:20,
                                labelWidth: 20,
                                displayField : 'name',
                                valueField : 'id',
                                store: SjzcyhStore,
                                editable: false,
                                value:'...',
                                margin: '0 0 0 15' ,
                                listeners: {
                                    render:function (self) {
                                        // Ext.ComponentQuery.query('popupGridForSjzc[name="popupGridForSjzc"]')[0].setFieldLabel('<img src="/image/rzpt/bootstrap/more.png" style="width: 10px;height: 10px">\n');
                                    },
                                    'focus': function (self,newValue,oldValue) {
                                        var form = self.up('form').getForm();
                                        var xm_id = form.findField('XM_ID').rawValue;
                                        SjzcyhStore.getProxy().extraParams['XM_ID'] = xm_id;
                                        SjzcyhStore.load();
                                    }

                                },
                            }]},*/
                    // {//20210518_dengzq_记账凭证号从会计核算信息中选择,弹窗显示
                    //     xtype: "PopupGridForKjhsPzh",
                    //     name: "VOUCHER_NO",
                    //     displayField : 'name',
                    //     valueField : 'id',
                    //     store: jzpzhStore,
                    //     fieldLabel: '<span class="required">✶</span>记账凭证号',
                    //     columnWidth: .33,
                    //     editable: true,
                    //     allowBlank: true, // 是否允许为空
                    //     listeners: {
                    //         'focus': function (self,newValue,oldValue) {
                    //             var form = self.up('form').getForm();
                    //             var xm_id = form.findField('XM_ID').rawValue;
                    //             jzpzhStore.getProxy().extraParams['XM_ID'] = xm_id;
                    //             jzpzhStore.load();
                    //         }
                    //     },
                    // },

                    //暂时使用记账凭证号
                    {
                        xtype: "textfield",
                        name: "VOUCHER_NO",
                        //20210708 zhuangrx 记账凭证号格式修改
                        regex: /^[a-zA-Z0-9]{0,100}$/,
                        regexText : '格式错误，必须为数字或英文！',
                        fieldLabel: '<span class="required">✶</span>记账凭证号',
                        emptyText: '请输入记账凭证号...',
                        columnWidth: .33,
                        allowBlank: false,
                        hidden:false
                    },

                    //因未对接银行系统，下拉查询留存记账凭证号下拉模糊查询版本
                    // {
                    //     xtype: 'combobox',
                    //     fieldLabel: '<span class="required">✶</span>记账凭证号',
                    //     name: 'VOUCHER_NO',
                    //     displayField: 'VOUCHER_NO',
                    //     valueField: 'VOUCHER_NO',
                    //     rootVisible: false,
                    //     lines: false,
                    //     allowBlank: false,
                    //     emptyText: '请输入...',
                    //     preValue:'',
                    //     columnWidth: .33,
                    //     hideTrigger:true,//隐藏下拉按钮
                    //     isCanReq:true,
                    //     selectModel: 'leaf',
                        // validator: vd,
                        // enableKeyEvents: true,
                        // store: Ext.create('Ext.data.Store', {
                        //     fields:  ["VOU_ID", "agName", "FISCAL_YEAR", "ACCT_PERIOD", "ACCT_SET_CODE",
                        //         "AGENCY_ACCT_VOUCHER_TYPE", "VOUCHER_NO", "POSTER",
                        //         "POSTER_DATE", "INPUTER", "INPUTER_DATE", "FI_LEADER", "VOUCHER_ABS", "create_time"],
                        //     remoteSort: true,// 后端进行排序
                        //     extraParams:{},
                        //     proxy: {// ajax获取后端数据
                        //         type: "ajax",
                        //         method: "POST",
                        //         url: "/getZfpzhByKjhs.action",
                        //         reader: {
                        //             type: "json"
                        //         },
                        //         simpleSortMode: true
                        //
                        //     },
                        //     autoLoad: false
                        // })
                        // ,
                        // listeners:{
                        //     keyup:function(t){
                        //         // var XM_ID = t.up('form').getForm().findField('XM_ID').getValue();
                        //         var VOUCHER_NO = t.up('form').getForm().findField('VOUCHER_NO').getValue();
                        //         if(VOUCHER_NO){
                        //             var value = t.getValue();
                        //             if(value == t.preValue){
                        //                 return false;
                        //             }
                        //             var regex = new RegExp('[a-z]');
                        //             if(!regex.test(value)) {
                        //                 t.setValue(value);
                        //                 t.preValue = value;
                        //                 if (t.isCanReq) {
                        //                     t.isCanReq = false;
                        //                     var store = t.getStore();
                        //                     store.getProxy().extraParams['mhcx'] = value;
                        //                     // store.getProxy().extraParams['VOUCHER_NO'] = VOUCHER_NO;
                        //                     store.load();
                        //                     t.expand();
                        //                     setTimeout(function () {
                        //                             t.isCanReq = true;
                        //                         },
                        //                         300);
                        //                 }
                        //             }
                        //         }
                        //     },
                        //     focus:{
                        //         fn:function (t) {
                        //             var VOUCHER_NO = t.up('form').getForm().findField('VOUCHER_NO').getValue();
                        //             if(VOUCHER_NO) {
                        //                 var value = t.getValue();
                        //                 if (value != t.preValue) {
                        //                     t.preValue = value;
                        //                     var store = t.getStore();
                        //                     store.getProxy().extraParams['mhcx'] = value;
                        //                     // store.getProxy().extraParams['VOUCHER_NO'] = VOUCHER_NO;
                        //                     if(!(value==null)){
                        //                         store.load();
                        //                     }
                        //                 }
                        //                 t.expand();
                        //             }
                        //         }
                        //     },
                        //     change:function(self, newValue) {
                        //     },
                        //     beforequery : function () {
                        //         return false;
                        //     },
                        //     render:function(self){
                        //         Ext.QuickTips.init();
                        //         Ext.QuickTips.register({
                        //             target : self.el,
                        //             text : '输入记账凭证号，默认检索'
                        //         });
                        //     }
                        // }
                    // },
                    {
                        xtype: "datefield",
                        name: "CREATE_DATE",
                        fieldLabel: '录入时间',
                        format: 'Y-m-d H:i:s',
                        value: today,
                        hidden:nameUpdate=='1'?false:true,
                        fieldStyle:'background:#E6E6E6',
                        readOnly:true
                    },
                    {
                        xtype: "datefield",
                        name: "SJZC_DATE",
                        fieldLabel: '<span class="required">✶</span>'+(nameUpdate == '1' ? '使用日期':'支出日期'),
                        allowBlank: false,
                        format: 'Y-m-d',
                        value: today,
                        maxValue: nowDate //日期截止到今天
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "SJZC_AMT",
                        fieldLabel: '<span class="required">✶</span>'+(nameUpdate == '1'?'本次使用金额(元)':'本次支出金额(元)'),
                        emptyText: '0.00',
                        allowDecimals: true, // 是否允许小数
                        decimalPrecision: 2, // 小数精度
                        mouseWheelEnabled: false, // 上下调整箭头
                        allowBlank: false, // 是否允许为空
                        editable: true, // 禁用编辑
                        keyNavEnabled: false,
                        hideTrigger: true,
                        minValue: 0
                    },
                    {
                        xtype: "treecombobox",
                        name: "GNFL_ID",
                        store: zcgnfl_store,
                        displayField: "name",
                        valueField: "id",
                        selectModel: "leaf",
                        fieldLabel: '支出功能分类',
                        hidden:nameUpdate == '2' ? false : true,
                        editable: true, //禁用编辑
                        allowBlank: true
                    },
                    {
                        xtype: "treecombobox",
                        name: "JJFL_ID",
                        store: zcjjfl_store,
                        displayField: "name",
                        valueField: "id",
                        selectModel: "leaf",
                        fieldLabel: '支出经济分类',
                        hidden:nameUpdate == '2' ? false : true,
                        editable: true, //禁用编辑
                        allowBlank: true
                    },
                    // {
                    //     xtype: "treecombobox",
                    //     name: "SS_AG_ID",
                    //     store: store_dw,
                    //     displayField: "text",
                    //     valueField: "id",
                    //     selectModel: "leaf",
                    //     //typeAhead:false,//不可编辑
                    //     fieldLabel: '收款单位',
                    //     hidden:isHiddenDw || nameUpdate == '1' || nameUpdate == '2',
                    //     emptyText: '请选择下级收款单位名称',
                    //     editable: false, //禁用编辑
                    //     allowBlank: true,
                    //     listeners: {
                    //        select:function(combo, record,e){
                    //             var form = Ext.ComponentQuery.query('form#item_zqxmSjzcTb_form')[0];
                    //             // var zhbool=true;
                    //             // if(!!record.data&&record.data.text=='单位'){
                    //             //     form.getForm().findField("SS_AG_ID").setValue("");
                    //             //     zhbool=false;
                    //             // }
                    //             // 将项目供应方置灰
                    //             // zhbool=zhbool&&(!!record&&record.data.id!='root');
                    //             // form.getForm().findField("XMGYF").setValue('');
                    //             // form.getForm().findField("XMGYF").setReadOnly(zhbool?true:false);
                    //             // form.getForm().findField("XMGYF").setFieldStyle(zhbool?'background:#E6E6E6':'background:#ffffff');
                    //         },
                    //         change: function (self, newValue) {
                    //             /* if(newValue&&newValue!=''){
                    //                 var record=store_dw.findRecord('id', newValue, 0, false, true, true);
                    //                 var form = Ext.ComponentQuery.query('form#item_zqxmSjzcTb_form')[0];
                    //                 form.getForm().findField("SS_AG_CODE").setValue(record.get('code'));
                    //                 form.getForm().findField("SS_AG_NAME").setValue(record.get('text'));
                    //             }else{
                    //                 var record=store_dw.findRecord('id', newValue, 0, false, true, true);
                    //                 var form = Ext.ComponentQuery.query('form#item_zqxmSjzcTb_form')[0];
                    //                 form.getForm().findField("SS_AG_CODE").setValue('');
                    //                 form.getForm().findField("SS_AG_NAME").setValue('');
                    //             }*/
                    //         }
                    //     }
                    // },
                    {
                        xtype: "PopupGridForSkdw",
                        name: "SS_AG_ID",
                        valueField: 'ZBDW_AG_ID',
                        displayField: 'ZBDW',
                        // store: skdwStore,
                        store: skdwStore,
                        fieldLabel: '<span class="required">✶</span>收款单位',
                        columnWidth: .33,
                        editable: false,
                        //allowBlank: true, // 是否允许为空
                        //20210930 fzd 功能区分实物工作量、划拨
                        allowBlank: zjsyqk_type == "2" ? true : false, // 是否允许为空
                        hidden: zjsyqk_type == "2" ? true : false,
                        listeners: {
                            'focus': function (self,newValue,oldValue) {
                                skdwStore.getProxy().extraParams['XM_ID'] = XM_ID;
                                skdwStore.load();
                            },
                            'change': function (self, newValue,oldValue) {
                                    if(isNull(newValue)){
                                        var form = self.up('form').getForm();
                                        form.findField('XPAYEE_ACCT_NAME').setValue(null);
                                        form.findField('XPAYEE_ACCT_NO').setValue(null);
                                        form.findField('BANK_DEPOSIT_NAME').setValue(null);
                                    }else{
                                        if(!isNull(oldValue)){
                                            if( newValue != oldValue){
                                                var form = self.up('form').getForm();
                                                form.findField('XPAYEE_ACCT_NAME').setValue(null);
                                                form.findField('XPAYEE_ACCT_NO').setValue(null);
                                                form.findField('BANK_DEPOSIT_NAME').setValue(null);
                                            }
                                        }
                                    }
                            }
                        },
                    },
                    {
                        xtype: "textfield",
                        name: "SS_AG_CODE",
                        fieldLabel: '实施单位code',
                        allowBlank: true,
                        hidden:true
                    },
                    {
                        xtype: "textfield",
                        name: "SS_AG_NAME",
                        fieldLabel: '实施单位名称',
                        allowBlank: true,
                        hidden:true
                    },
                    {
                        xtype: "textfield",
                        name: "XMGYF",
                        readOnly:false,
                        fieldStyle:'background:#ffffff',
                        fieldLabel: nameUpdate == '1' ? '<span class="required">✶</span>收款单位(个人)': '<span class="required">✶</span>项目供应商',
                        emptyText: nameUpdate == '1' ? '请录入项目收款单位名称': '请录入项目供应商名称',
                        allowBlank: nameUpdate == '1'|| zjsyqk_type == '2' ? false : true,
                        enableKeyEvents:true,
                        hidden: nameUpdate == '2' || zjsyqk_type == '1' ? true : false,
                        /*listeners: {
                            //keypress:function(self, e){
                            keyup:function(self, e){
                                //将项目实施单位置灰
                                var form = Ext.ComponentQuery.query('form#item_zqxmSjzcTb_form')[0];
                                var zhbool=self.getValue()!='';
                                form.getForm().findField("SS_AG_ID").setValue('');
                                form.getForm().findField("SS_AG_ID").setReadOnly(zhbool?true:false);
                                form.getForm().findField("SS_AG_ID").setFieldStyle(zhbool?'background:#E6E6E6':'background:#ffffff');
                            }
                        }*/
                    },
                    {//20210517_dengzq_增加供应商类型
                        xtype: "combobox",
                        name: 'XMGYS_LX',
                        store: DebtEleStore(json_debt_gyslx),
                        displayField: "name",
                        valueField: "id",
                        allowDecimals: true,
                        enableKeyEvents: true,
                        fieldLabel: '<span class="required">✶</span>供应商类型',
                        editable: false, //禁用编辑
                        allowBlank: zjsyqk_type == '1' ? true : false,
                        hidden: zjsyqk_type == '1' ? true : false,
                        listeners: {
                            change:function(self,newValue,oldValue) {
                                var form = Ext.ComponentQuery.query('form#item_zqxmSjzcTb_form')[0];
                                var uniCode = form.getForm().findField("XPAYEE_ACCT_UNI_CODE");
                                if( newValue =='1'||newValue=='法人'){
                                    uniCode.setFieldLabel('<span class="required">✶</span>统一社会信用代码');
                                }else if(newValue =='2'||newValue=='自然人'){
                                    uniCode.setFieldLabel('<span class="required">✶</span>身份证号码');
                                }
                            },
                            afterRender: function(combo) {
                                //供应商默认显示法人：类型为1
                                var firstValue = combo.store.initialConfig.data[0].id;
                                combo.setValue(firstValue);//同时下拉框会将与name为firstValue值对应的 text显示
                            }
                        }
                    },
                    {
                        xtype: 'textfield',
                        name: 'XPAYEE_ACCT_UNI_CODE',
                        fieldLabel: '<span class="required">✶</span>统一社会信用代码',
                        columnWidth: .33,
                        editable:zjsyqk_type == '1' ? false : true,//划拨登记时不支持录入，实物工作量登记时需要录入
                        regex: /(^[A-Z0-9]{18}$)/,
                        regexText : '格式错误，必须为18位数字或字母组合！',
                        allowBlank: false, // 是否允许为空
                        fieldStyle:zjsyqk_type == '1' ? 'background:#E6E6E6' : ''
                    },
                    {
                        xtype: zjsyqk_type == '1' ? "PopupGridForSkr" : 'textfield',
                        name: "XPAYEE_ACCT_NAME",
                        displayField : 'name',
                        valueField : 'id',
                        store: zjsyqk_type == '1' ? skrStore : '',
                        fieldLabel: '<span class="required">✶</span>实际收款人全称',
                        columnWidth: .33,
                        maxLength:150,
                        editable: zjsyqk_type == '1' ? false : true,
                        allowBlank: false, // 是否允许为空
                        hidden: false,
                        listeners: {
                            'focus': function (self,newValue,oldValue) {
                                var form = self.up('form').getForm();
                                if(zjsyqk_type == '1'){
                                    var ss_ag_id = form.findField('SS_AG_ID').getValue();
                                    skrStore.getProxy().extraParams['YHDW_AG_ID'] = ss_ag_id;
                                    skrStore.getProxy().extraParams['XM_ID'] = XM_ID;
                                    skrStore.load();
                                }
                            }
                        },
                    },
                    {
                        xtype: 'textfield',
                        name: 'XPAYEE_ACCT_NO',
                        fieldLabel: '<span class="required">✶</span>实际收款人账号',
                        regex:  /^[0-9a-zA-Z]*$/,
                        regexText : '只能输入数字、字母',
                        columnWidth: .33,
                        maxLength:40,
                        readOnly: zjsyqk_type == '1' ? true : false,
                        allowBlank: false, // 是否允许为空
                        fieldStyle:zjsyqk_type == '1' ? 'background:#E6E6E6' : ''
                    },
                    {
                        xtype: 'textfield',
                        name: 'BANK_DEPOSIT_NAME',
                        fieldLabel: '<span class="required">✶</span>开户银行名称',
                        columnWidth: .33,
                        maxLength:100,
                        readOnly: zjsyqk_type == '1' ? true : false,
                        allowBlank: false, // 是否允许为空
                        fieldStyle:zjsyqk_type == '1' ? 'background:#E6E6E6' : ''
                    },
                    {
                        xtype: 'textfield',
                        name: 'ZCZY',
                        fieldLabel: nameUpdate == '2' ? '支出摘要' : '<span class="required">✶</span>资金用途',
                        allowBlank: nameUpdate == '1' ? false:true,
                        hidden:nameUpdate == '1' ? false:true,
                        columnWidth: .66,
                        maxLength: 500,//限制输入字数
                        maxLengthText: "输入内容过长，最多只能输入500个汉字！"
                    },
                    {
                        xtype: 'treecombobox',
                        name: 'ZJYT_GD',
                        fieldLabel: '<span class="required">✶</span>资金用途',
                        store: DebtEleTreeStoreDB('DEBT_XMZJYT'),
                        displayField: 'name', // 显示值 界面展示
                        valueField: 'id', // 实际值 入库
                        editable: false,
                        selectModel: 'leaf',//只可选择叶子节点
                        allowBlank: zjsyqk_type == 1 || nameUpdate == '1' ? true: false,
                        hidden: zjsyqk_type == 1 || nameUpdate == '1' ? true : false,
                        listeners: {
                            change: function (self, newValue) {
                                if(nameUpdate == '1'){
                                    var REMARK = this.up('form').getForm().findField('REMARK');
                                    if (newValue == '99') {
                                        REMARK.allowBlank = false;
                                        REMARK.setFieldLabel('<span class="required">✶</span>备注');
                                    } else {
                                        REMARK.allowBlank = true;
                                        REMARK.setFieldLabel('备注');
                                    }
                                }
                            }
                        }
                    },
                    //20210511 wq  实际支出添加 记账凭证号、记账日期、借方科目、贷方科目、摘要
                    {   // 分割线
                        xtype: 'menuseparator',
                        margin: '5 0 5 0',
                        columnWidth: 1,
                        border: true
                    },
                    {
                        xtype: "datefield",
                        name: "VOUCHER_DATE",
                        fieldLabel: '记账日期',
                        allowBlank: true,
                        editable: false,//禁用编辑
                        format: 'Y-m-d',
                        hidden: true,
                        maxValue: nowDate //日期截止到今天
                    },
                    {
                        xtype: 'textfield',
                        name: 'JFKM',
                        fieldLabel: '借方科目',
                        columnWidth: .33,
                        maxLength : 100 ,
                        hidden: true,
                        allowBlank: true // 是否允许为空
                    },
                    {
                        xtype: 'textfield',
                        name: 'DFKM',
                        fieldLabel: '贷方科目',
                        columnWidth: .33,
                        hidden: true,
                        maxLength : 100 ,
                        allowBlank: true // 是否允许为空
                    },
                    // {   // 分割线
                    //     xtype: 'menuseparator',
                    //     margin: '5 0 5 0',
                    //     columnWidth: 1,
                    //     border: true
                    // },
                    {
                        xtype: 'textfield',
                        name: 'VOUCHER_ABS',
                        fieldLabel: '摘要',
                        columnWidth: .999,
                        maxLength : 500 ,
                        allowBlank: true // 是否允许为空
                    },
                    {
                        xtype: 'textfield',
                        name: 'WQBZCYY',
                        fieldLabel: '未全部支出原因',
                        hidden: nameUpdate == '1' || nameUpdate == '2' ? true : false,
                        allowBlank: true,
                        columnWidth: .999,
                        maxLength: 500,//限制输入字数
                        maxLengthText: "输入内容过长，最多只能输入500个汉字！"
                    },
                    {
                        xtype: 'textfield',
                        name: 'REMARK',
                        fieldLabel: '备注',
                        allowBlank: true,
                        columnWidth: .999,
                        maxLength: 500,//限制输入字数
                        maxLengthText: "输入内容过长，最多只能输入500个汉字！"

                    },
                    {
                        xtype: 'datefield',
                        name: 'SJ_ZC_DATE',
                        hidden:true,
                        fieldLabel: '上级支出日期'
                    }
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                xtype:'tabpanel',
                anchor:'100% 38%',
                items:[
                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        layout: 'fit',
                        name: 'fileTab',
                        items: [
                            {
                                xtype: 'panel',
                                layout:'fit',
                                itemId:'sjzc_fjgrid',
                                items:[init_sjzc_fjGrid()]
                            }
                        ]
                    }
                ]
            }
        ]
    });
}

/**
 * 实际支出必录附件
 */
function init_sjzc_fjGrid(){
    var grid = UploadPanel.createGrid({
        busiType: 'ET205',//业务类型
        busiId: xzzqSjzcId,//业务ID
        busiProperty: 'C02',//业务规则
        editable:editValue,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_xzzq_sjzctb_contentForm_xmfj_grid'
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
        if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}
/**
 * 提交数据
 */
function submitZqxmSjzcTb(btn) {
    //获取实际收益情况表单
    var zqxmSjzcTbForm = btn.up('window').down('form');
    if (!zqxmSjzcTbForm.isValid()) {
        Ext.toast({
            html: "请检查必填项，以及未通过校验项！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    }
    var is_gkjzzf=zqxmSjzcTbForm.down('combobox[name="IS_GKJZZF"]').getValue();//20210512值为1时代表国库支付为是，银行收支不允许录入值
    var gkzf_no=zqxmSjzcTbForm.down('textfield[name="GKZF_NO"]').getValue();//20210512值为1时代表国库支付为是，银行收支不允许录入值
    var yhzhsz=zqxmSjzcTbForm.down('combobox[name="YHZHSZ"]').getValue();//银行收支信息
    /*if(is_gkjzzf=='1'&&!isNull(yhzhsz)){
        Ext.Msg.alert('提示', "是否国库集中支付选择是时，银行收支应为空！");
        return false;
    }
    if(is_gkjzzf=='1'&&isNull(gkzf_no)){
        Ext.Msg.alert('提示', "是否国库集中支付选择是时，国库支付凭证号为必填项！");
        return false;
    }*/
    var bf_amt = zqxmSjzcTbForm.down('numberFieldFormat[name="BF_AMT"]').getValue();
    var yzc_amt = zqxmSjzcTbForm.down('numberFieldFormat[name="YZC_AMT"]').getValue();
    var sjzc_amt = zqxmSjzcTbForm.down('numberFieldFormat[name="SJZC_AMT"]').getValue();
    var zc_sum_amt = Number(yzc_amt.toFixed(2)) + Number(sjzc_amt.toFixed(2));
    //本次支出日期
    var bjZCDate = zqxmSjzcTbForm.down('datefield[name="SJZC_DATE"]').getValue();
    //上级支出日期
    var sjZCDate = zqxmSjzcTbForm.down('datefield[name="SJ_ZC_DATE"]').getValue();
    bjZCDate = Ext.Date.format(bjZCDate,"Y-m-d");
    sjZCDate = Ext.Date.format(sjZCDate,"Y-m-d");

    if (bf_amt < Number(zc_sum_amt.toFixed(2))) {
        Ext.Msg.alert('提示', "本次支出金额与已支出金额的和不能超过已到位金额！");
        return false;
    }
    // 20210622 guoyf 增加本次支出金额校验
    if(sjzc_amt <= '0'){
        if(nameUpdate == '1'){
            Ext.Msg.alert('提示', "本次使用金额必须大于0！");
            return false;
        }else{
            Ext.Msg.alert('提示', "本次支出金额必须大于0！");
            return false;
        }
    }
    //已到位金额大于已支出金额与本次支出金额得和时，必须录入未全部支出原因
    var WQBZCYY=zqxmSjzcTbForm.down('[name="WQBZCYY"]').getValue();
    if(nameUpdate != '2'){
        if ((bf_amt > zc_sum_amt)&&!(!!WQBZCYY) && nameUpdate != '1') {
            Ext.Msg.alert('提示', "未支出全部金额需填写未全部支出原因！");
            return false;
        }
    }
    var ss_ag_id=zqxmSjzcTbForm.down('[name="SS_AG_ID"]').getValue();
    var xmgyf=zqxmSjzcTbForm.down('[name="XMGYF"]').getValue();

    if(nameUpdate){
        if(nameUpdate != '2'){
            if(!(!!ss_ag_id||!!xmgyf)){
                Ext.Msg.alert('提示', nameUpdate == '1' ? "请录入项目收款单位（个人）" : "请录入项目实施单位或项目供应方！");
                return false;
            }
        }
    }


    var ag_id=zqxmSjzcTbForm.down('[name="AG_ID"]').getValue();
    //资金使用单位不允许选择自己
    if(!!ss_ag_id&&(ss_ag_id==USER_AG_ID||ss_ag_id==ag_id)){
        Ext.Msg.alert('提示', "收款单位与录入单位不允许相同！");
        return false;
    }
    //校验本次支出时间需大于等于上级支出时间
    if(bjZCDate<sjZCDate){
        Ext.Msg.alert('提示', "支出时间不能小于上级支出时间："+sjZCDate+"日！");
        return false;
    }
    //根据锁定期间校验支出时间,天津个性定制需求
    if(typeof GxdzUrlParam != 'undefined' && '12'==GxdzUrlParam){
        var params = {};
        params.ZC_DATE = zqxmSjzcTbForm.down('datefield[name="SJZC_DATE"]').getValue();
        params.AD_CODE = zqxmSjzcTbForm.down('textfield[name="AD_CODE"]').getValue();
        params.AG_CODE = zqxmSjzcTbForm.down('textfield[name="AG_CODE"]').getValue();
        if(!peCheck(params)){
            return false;
        }
    }
    var ZCLX_TYPE=zqxmSjzcTbForm.down('combobox[name="ZCLX_TYPE"]').getValue();
    if(ZCLX_TYPE=='资金转拨'){
        ZCLX_TYPE=1;
        zqxmSjzcTbForm.down('combobox[name="ZCLX_TYPE"]').setValue(ZCLX_TYPE)
    }else if(ZCLX_TYPE=='实际支出'){
        ZCLX_TYPE=2;
        zqxmSjzcTbForm.down('combobox[name="ZCLX_TYPE"]').setValue(ZCLX_TYPE)
    }
    btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    $.post('/saveZqxmSjzcTb.action', {
        wf_id: wf_id,
        node_code: node_code,
        button_name: button_name,
        button_text: button_text,
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_NAME: AG_NAME,
        AG_CODE: AG_CODE,
        ZJSYQK_TYPE:zjsyqk_type.toString(),//2021051814_dengzq_资金使用情况类型：项目资金转拨登记or项目实物工作量登记
        zqxmSjzcTbForm: Ext.util.JSON.encode([zqxmSjzcTbForm.getValues()])
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: '保存成功！',
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.up('window').close();
            // 刷新表格
            reloadGrid()
        } else {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            btn.setDisabled(false);
        }
        //刷新表格
    }, "json");
}

/**
 * 删除主表格信息
 */
function delZqxmSjzcInfo(btn) {
    // 检验是否选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
        return;
    }
    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            var ids = new Array();
            var btn_text = btn.text;
            for (var k = 0; k < records.length; k++) {
                var zqxm_sjzc_id = records[k].get("SJZC_ID");
                ids.push(zqxm_sjzc_id);
            }

            $.post("delZqxmSjzcInfo.action", {
                ids: Ext.util.JSON.encode(ids)
            }, function (data_response) {
                data_response = $.parseJSON(data_response);
                if (data_response.success) {
                    Ext.toast({
                        html: btn_text + "成功！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    reloadGrid();
                } else {
                    Ext.toast({
                        html: btn_text + "失败！" + data_response.message,
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    return false;
                }
            });
        }
    });
}

/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("SJZC_ID"));
    }
    //根据锁定期间校验支出时间,天津个性定制需求
    if(typeof GxdzUrlParam != 'undefined' && '12'==GxdzUrlParam){
        if(btn.name =='down' || (node_code > 1 && btn.name == 'cancel') ) {
            var dateArr = [];
            records.forEach(function (record) {
                var param = {};
                param.AD_CODE = record.data.AD_CODE;
                param.AG_CODE = record.data.AG_CODE;
                param.ZC_DATE = record.data.SJZC_DATE;
                dateArr.push(param);
            });
            for (var i = 0; i < dateArr.length; i++) {
                if (!peCheck(dateArr[i])) {
                    return false;
                }
            }
        }
    }
    button_name = btn.name;
    button_text = btn.text;
    if (btn.text == '送审' || btn.text == '撤销送审') {
        Ext.Msg.confirm('提示', '请确认是否' + button_text + '!', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                //发送ajax请求，修改节点信息
                $.post("doZqxmSjzcWorkFlow.action", {
                    button_text: button_text,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: '',
                    ids: ids
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: button_text + "成功！" + (data.message ? data.message : ''),
                            closable: false, align: 't', slideInDuration: 400, minWidth: 400
                        });
                    } else {
                        Ext.MessageBox.show({
                            title: '提示',
                            msg: button_text + '失败！' + (data.message ? data.message : ''),
                            minWidth: 300,
                            buttons: Ext.Msg.OK,
                            fn: function (btn) {
                            }
                        });
                    }
                    //刷新表格
                    reloadGrid();
                }, "json");
            }
        });
    } else {
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text + '意见',
            value: btn.text == '审核' ? '同意' : '',
            animateTarget: btn,
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post("doZqxmSjzcWorkFlow.action", {
                        button_text: button_text,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_text + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                        }
                        //刷新表格
                        reloadGrid();
                    }, "json");
                }
            }
        });
    }
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
 *  刷新主面板
 */
function reloadGrid() {
    var gridStore = DSYGrid.getGrid('contentGrid').getStore();
    gridStore.removeAll();
    var xm_search = Ext.ComponentQuery.query('textfield[itemId="MHCX"]')[0].getValue();
  //  var SET_YEAR = Ext.ComponentQuery.query('combobox[name="SET_YEAR"]')[0].getValue();

    gridStore.getProxy().extraParams = {
        AG_ID: AG_ID,
        AD_CODE: AD_CODE,
        AG_CODE: !!AG_CODE?AG_CODE:(!!USER_AG_CODE?USER_AG_CODE:""),
        wf_id: wf_id,
        node_code: node_code,
        node_type: node_type,
        button_name: button_name,
        ZJSYQK_TYPE:zjsyqk_type.toString(),//2021051814_dengzq_资金使用情况类型：项目资金转拨登记or项目实物工作量登记
        WF_STATUS: WF_STATUS,
        xm_search: xm_search,
        dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
    };
    //刷新
    gridStore.loadPage(1);

}

/**
 *  获取url参数或者查询字符串中的参数
 */
function getQueryParam(name, queryString) {
    var match = new RegExp(name + '=([^&]*)').exec(queryString || location.search);
    return match && decodeURIComponent(match[1]);
}

/**
 * 操作记录的函数
 **/
function dooperation() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var contentGrid_ID = records[0].get("SJZC_ID");
        fuc_getWorkFlowLog(contentGrid_ID);
    }
}
function getFJXX(ywsjid){
    //创建附件框
    var zwqxWindow =Ext.create('Ext.window.Window', {
        title: '项目附件情况',
        itemId: 'xmxxWindow',
        width: document.body.clientWidth * 0.95,
        height: document.body.clientHeight * 0.95,
        maximizable: true,//最大化按钮
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: true,//大小不可改变
        closeAction: 'destroy',
        layout: 'fit',
        items: [initWin_xmfj(ywsjid)],
        buttons: [
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    zwqxWindow.show();
}
function initWin_xmfj(ywsjid){
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            width: '100%',
            margin: '0 0 2 0'
        },
        items: [
            Ext.create('Ext.tab.Panel', {
                anchor: '100% -17',
                border: false,
                itemId: 'xmxxTab',
                items: [
                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        scrollable: true,
                        layout: 'fit',
                        itemId: 'xmfj',
                        items: initWin_xmInfo_xmfj(ywsjid)
                    }
                ]
            })
        ]
    });
}
/**
 * 初始化债券信息填报弹出窗口中的项目附件标签页
 */
function initWin_xmInfo_xmfj(ywsjid) {
    var tag = false;
    var grid = UploadPanel.createGrid({
        busiType: 'ET205',//业务类型
        busiId: ywsjid,//业务ID
        busiProperty: 'C02',//业务规则
        //ruleIds:'',//附件规则id
        editable: tag,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_xmxx_contentForm_tab_xmfj_grid_common'
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
        if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}

/**
 * 查询银行账户收支
 * @param XM_ID
 */
/*
function getYhzhGrid(XM_ID) {
    $.post('/selYhzhBox.action', {
        XM_ID:XM_ID
    }, function (data) {
        for(var i=0;i<data.list.length;i++){
            var arr = {id:data.list[i].ID,code:data.list[i].CODE,name:data.list[i].NAME};
            json_debt_yhzh.push(arr);
        }
        //刷新表格
    }, "json");
}*/
