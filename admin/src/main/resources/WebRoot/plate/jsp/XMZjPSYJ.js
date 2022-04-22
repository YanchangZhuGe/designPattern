var fontSize_xeksh = "'font-size:13px;'";//设置生成的评分配置表格字体
Ext.onReady(function () {
    new Ext.panel.Panel({
        renderTo: Ext.getBody(),
        layout: 'fit',
        height: '100%',
        width: '100%',
        border: false,
        header: {
            xtype: 'header',
            baseCls: 'x-panel-header-new',
            titleAlign: 'center',
            title: '专家评审意见明细单'
        },
        items: [findPsyj()]
    });
});

/**
 * 查看评审意见
 */
function findPsyj() {
    var headerJson = [
        {
            "dataIndex": "CREATE_DATE",
            "type": "string",
            "text": "评审时间",
            "fontSize": "15px",
            "width": 135
        },
        {
            "dataIndex": "PSZJ",
            "type": "string",
            "text": "评审专家",
            "fontSize": "15px",
            "width": 100
        },
        {
            "dataIndex": "PSZT",
            "type": "string",
            "text": "评审状态",
            "fontSize": "15px",
            "width": 90
        },
        {
            "dataIndex": "SCORE",
            "type": "string",
            "width": 180,
            "text": "评审得分"
        },
        {
            "dataIndex": "PSYJ",
            "type": "string",
            "width": 180,
            "text": "评审意见"
        },
        {
            "dataIndex": "PSMX",
            "type": "string",
            "width": 180,
            "text": "评分明细",
            renderer: function (data, cell, record) {
                data = "评分明细";
                var result = '<a href="javascript:void(0);" onclick="initWin_xm(\'' + record.data.PSZJ_ID + '\')">' + data + '</a>';
                return result;
            }
        },
        {
            "dataIndex": "PSZJ_ID",
            "type": "string",
            "width": 180,
            "hidden": true,
            "text": "评审专家id",

        }

    ];
    var zjGrid = DSYGrid.createGrid({
        itemId: 'zjyjGrid',
        headerConfig: {
            headerJson: headerJson
        },
        pageConfig: {
            enablePage: false
        },
        rowNumber: true,
        border: false,
        height: '100%',
        dataUrl: 'getZjyj.action',
        params: {
            ID: BILL_ID//项目申报id
        }
    });
    return zjGrid;
}

/**
 * 专家评审明细框
 * @param pszj_id
 */
function initWin_xm(pszj_id) {
    var zwqxWindow = Ext.create('Ext.window.Window', {
        title: '项目评分明细',
        itemId: 'mxxxWindow',
        width: document.body.clientWidth * 0.95,
        height: document.body.clientHeight * 0.95,
        maximizable: true,//最大化按钮
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: true,//大小不可改变
        closeAction: 'destroy',
        layout: 'fit',
        items: [initWin_xmpf(pszj_id)]
    });
    zwqxWindow.show();
}

/**
 * 专家评审明细框
 * @param pszj_id
 */
function initWin_xmpf(pszj_id) {
    var headerJson = [

        {
            dataIndex: "XMBZ_ID",
            type: "string",
            width: 130,
            hidden: true,
            text: "项目标准ID"

        },
        {
            dataIndex: "ROWNUM",
            type: "string",
            width: 60,
            text: "",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },

        {
            dataIndex: "REVIEW_DESC",
            type: "string",
            width: 150,
            align: "left",
            text: "评审内容",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },
        {
            dataIndex: "REVIEW_STANDARD",
            type: "string",
            width: 270,
            align: "left",
            text: "评审标准",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        }, {
            text: "评审得分",
            dataIndex: "SCORE",
            width: 90,
            align: "center",
            type: "string",
            editable: false,
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },
        {
            dataIndex: "PFJL",
            type: "string",
            width: 170,
            align: "center",
            text: "评分记录",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        }

    ];
    var pspzGrid = DSYGrid.createGrid({
        itemId: "pf_grid",
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false,
            columnCls: 'normal'
        },
        forceFit: true,
        border: false,
        autoLoad: true,
        height: '500',
        pageConfig: {
            enablePage: false
        },
        flex: 1,
        params: {
            IS_ZJZS: 1,
            button_name: "zjpfck",
            PSZJ_ID: pszj_id,
            BILL_ID: BILL_ID,
            IS_ZJ: IS_ZJ,
            AD_CODE: AD_CODE
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'cellEdit',
                clicksToMoveEditor: 1
            }
        ],
        dataUrl: '/getZjPspzDataGrid.action'
    });
    return pspzGrid;
}