/**
 * js：还本付息excel导出
 */
/**
 * 默认数据：工具栏
 */
var selectId;
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
            initContentRightPanel(true)//初始化右侧2个表格
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
                        getHyzwHbfxDataList();
                    }
                }
            },
            {
                xtype: 'button',
                text: '导出还本付息',
                name: 'up',
                icon: '/image/sysbutton/export.png',
                hidden:(IS_SHOW_SPEC_UPLOAD_BTN == 0 || zwlb_id != '02')?true:false,
                handler: function (btn) {
                    var tree_area = Ext.ComponentQuery.query('treepanel#tree_unit')[0];
                    var tree_selected = tree_area.getSelection();
                    if (!tree_selected || tree_selected.length != 1 || !tree_selected[0].get('leaf')) {
                        Ext.MessageBox.alert('提示', '请选择一个底级单位再进行操作');
                        return false;
                    }
                    DSYGrid.exportExcelClick('contentGrid', {
                        exportExcel: true,
                        url: 'exportExcelHbfx.action',
                        param: {
                        }
                    });
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    },
    reloadGrid: function (param) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        var zqfl_id = Ext.ComponentQuery.query('treecombobox[name="zqfl_id"]')[0].value;
        //增加查询参数
        store.getProxy().extraParams["AD_CODE"] = AD_CODE;
        store.getProxy().extraParams["AG_CODE"] = AG_CODE;
        var dqYear = Ext.ComponentQuery.query("combobox[name='DQ_YEAR']")[0].getValue();
        var dqMonth = Ext.ComponentQuery.query("combobox[name='DQ_MO']")[0].getValue();
        if (dqMonth != null && dqMonth != '' && (dqYear == null || dqYear == '')) {
            Ext.MessageBox.alert('提示', '不能单独选择月份进行查询，请选择年度！');
            return;
        }
        if (Ext.ComponentQuery.query("combobox[name='DQ_YEAR']")[0].isDisabled()) {
            dqYear = '';
            dqMonth  = '';
        }
        store.getProxy().extraParams["dqYear"] = dqYear;
        store.getProxy().extraParams["dqMonth"] = dqMonth;
        store.getProxy().extraParams["zqfl_id"] = zqfl_id;
        if (typeof param != undefined && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        //刷新
        store.loadPage(1);
        //刷新下方表格,置为空
        if (DSYGrid.getGrid('contentGrid_detail')) {
            var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
            store_details.removeAll();
        }
    }
});
/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    var headerJson = [
        {xtype: 'rownumberer', width: 40},
        {dataIndex: "AD_NAME", width: 180, type: "string", text: "地区名称"},
        {dataIndex: "AG_NAME", width: 180, type: "string", text: "单位名称"},
        {dataIndex: "ZW_CODE", width: 180, type: "string", text: "债务编码"},
        {dataIndex: "ZW_NAME", width: 180, type: "string", text: "债务名称"},
        {dataIndex: "HKJH_DATE", width: 180, type: "string", text: "到期日期"},
        {dataIndex: "TYPE", width: 180, type: "string", text: "还款类型"},
        {dataIndex: "DQJE_YB", width: 180, type: "float", text: "到期金额(原币)(元)"},
        {dataIndex: "DQJE", width: 180, type: "float", text: "到期金额(人民币)(元)"},
        {dataIndex: "ZQLX_NAME", width: 180, type: "string", text: "债券类型"},
        {dataIndex: "ZQLX_NAME", width: 180, type: "string", text: "债务类别"}
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: false,
        border: false,
        height: '100%',
        flex: 1,
        tbar: [
            /*{
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
            },*/
            /*{
                xtype: "textfield",
                fieldLabel: '模糊查询',
                name: 'contentGrid_search',
                width: 300,
                hidden: false,
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
                hidden: false
            }*/
        ],
        params: {
        },
        autoLoad: false,
        dataUrl: 'selectHyzwHbfx.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {

        }
    });
    return grid;
}
/**
 * 查询按钮实现
 */
function getHyzwHbfxDataList() {
    var store = DSYGrid.getGrid('contentGrid').getStore();
    var dqYear=Ext.ComponentQuery.query("combobox[name='DQ_YEAR']")[0].getValue();
    var dqMonth=Ext.ComponentQuery.query("combobox[name='DQ_MO']")[0].getValue();
    //var cBox = Ext.ComponentQuery.query("checkboxgroup#checkboxgroup")[0];
    //var yqShow=cBox.items.getAt(0).checked;
    var zqfl_id = Ext.ComponentQuery.query('treecombobox[name="zqfl_id"]')[0].value;
    if (dqMonth != null && dqMonth != '' && (dqYear == null || dqYear == '')) {
        Ext.MessageBox.alert('提示', '不能单独选择月份进行查询，请选择年度！');
        return;
    }
    if (Ext.ComponentQuery.query("combobox[name='DQ_YEAR']")[0].isDisabled()) {
        dqYear = '';
        dqMonth  = '';
    }
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_CODE:AG_CODE,
        dqYear:dqYear,
        dqMonth:dqMonth,
        //yqShow:yqShow,
        zqfl_id:zqfl_id
    };
    store.loadPage(1);
}


