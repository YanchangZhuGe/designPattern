Ext.require([
    'Ext.tree.*',
    'Ext.data.*',
    'Ext.layout.container.HBox',
    'Ext.dd.*',
    'Ext.window.MessageBox'
]);
var titleName = "";
Ext.onReady(function () {
    getTitleName(ywsjid);
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
            title: titleName
            /*baseCls:'x-panel-header-new',
            title:'<font size=6>'+titleName+'</font>',
            itemId:'condition_header',
            height: 100,
            titleAlign:'center',
            margin:'0 0 0 0',
              padding:'0 0 0 0'*/
        },
        items: [fuc_getWorkFlowLog(ywsjid, flow_branch)]
    });
});

function getTitleName(ywsj_id) {
    Ext.Ajax.request({
        method: 'POST',
        url: "/getZqxmWorkFlowName.action",
        params: {
            ywsj_id: ywsj_id
        },
        async: false,
        success: function (response, options) {
//			// 获取返回的JSON，并根据gridid，获取表头配置信息
//			var respText = Ext.util.JSON.decode(response.responseText);
            titleName = response.responseText;
        },
        failure: function (response, options) {
            Ext.MessageBox.minWidth = 120;
            Ext.Msg.alert('提示', '获取工作流名称信息失败！');
        }
    });
};


/**
 * 查看工作流日志
 */
function fuc_getWorkFlowLog(ywsj_id, flow_branch) {
    var headerJson = [
        {
            "dataIndex": "WF_NAME",
            "type": "string",
            "text": "流程名称",
            "fontSize": "15px",
            "width": 170
        },
        {
            "dataIndex": "NODE_NAME",
            "type": "string",
            "text": "流程节点",
            "fontSize": "15px",
            "width": 100
        },
        {
            "dataIndex": "OPERATION",
            "type": "string",
            "text": "操作动作",
            "fontSize": "15px",
            "width": 100
        },
        {
            "dataIndex": "AUDIT_INFO",
            "type": "string",
            "width": 100,
            "text": "操作意见"
        },
        {
            "dataIndex": "NAME",
            "type": "string",
            "width": 150,
            "text": "操作人员"
        },
        {
            "dataIndex": "CREATE_DATE",
            "type": "string",
            "width": 170,
            "text": "操作时间"
        }
    ];
    var logGrid = DSYGrid.createGrid({
        itemId: 'workFlowLog',
        headerConfig: {
            headerJson: headerJson
        },
        pageConfig: {
            enablePage: false
        },
        rowNumber: true,
        border: false,
        height: '100%',
        dataUrl: 'getZqxmWorkFlowHis.action',
        params: {
            ywsj_id: ywsj_id,
            BILL_YEAR: BILL_YEAR
        }
    });
    return logGrid;
}

