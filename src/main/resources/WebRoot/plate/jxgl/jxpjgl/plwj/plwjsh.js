/*
    披露文件审核
 */
/*
    披露文件接收
 */
var GxdzUrlParam=getQueryParam("GxdzUrlParam");

/*工作流状态*/
var json_debt_plwj = [
    {id: "001", code: "001", name: "未审核"},
    {id: "002", code: "002", name: "已审核"}
];
//月度计划主表表头
var ydjh_headerJson = [
    {
        xtype: 'rownumberer',
        summaryType: 'count',
        width: 40
    },
    {text: "月度计划ID",dataIndex: "YDJH_ID ",width: 150,type: "string",fontSize: "15px",hidden: true},
    {text: "计划年度",dataIndex: "YDJH_YEAR",width: 150,type: "string",fontSize: "15px",hidden: false},
    {text: "计划月份",dataIndex: "YDJH_MONTH",width: 150,type: "string",fontSize: "15px",hidden: false,
        renderer:function(value){
            return Ext.util.Format.number(value,'00')+"月";
        }
    },
    {text: "计划发行时间",class:"ty",dataIndex: "JHFX_DATE",width: 200,type: "string",fontSize: "15px"},
    {text: "发行批次id",dataIndex: "PCJH_ID",width: 200,type: "string",fontSize: "15px",hidden: true},
    {text: "发行批次",dataIndex: "PCJH_NAME",width: 200,type: "string",fontSize: "15px"},
    {text: "债券名称",class:"ty",dataIndex: "ZQ_NAME",width: 200,type: "string",fontSize: "15px"},
    {text: "债券编码",class:"ty",dataIndex: "ZQ_CODE",width: 200,type: "string",fontSize: "15px"},
    {text: "债券类型id",class:"ty",dataIndex: "ZQLB_ID",width: 200,type: "string",fontSize: "15px",hidden: true},
    {text: "债券类型",class:"ty",dataIndex: "ZQLB_NAME",width: 200,type: "string",fontSize: "15px",hidden: false},
    {text: "债券用途",class:"ty",dataIndex: "ZQYT",width: 200,type: "string",fontSize: "15px"},
    {text: "发行规模（亿元）",dataIndex: "PLAN_AMT",width:200,type: "float",fontSize: "15px",
        renderer: function (value) {return Ext.util.Format.number(value, '0,000.000000');},
        summaryType: 'sum',
        summaryRenderer: function (value) {return Ext.util.Format.number(value, '0,000.000000');}

    },
    {text: "其中新增债券金额（亿元）",dataIndex: "PLAN_XZ_AMT",width:200,type: "float",fontSize: "15px",hidden: false,
        renderer: function (value) {return Ext.util.Format.number(value, '0,000.000000');},
        summaryType: 'sum',
        summaryRenderer: function (value) {return Ext.util.Format.number(value, '0,000.000000');}

    },
    {text: "其中再融资债券金额（亿元）",dataIndex: "PLAN_ZRZ_AMT",width: 200,type: "float",fontSize: "15px",hidden: false,
        renderer: function (value) {return Ext.util.Format.number(value, '0,000.000000');},
        summaryType: 'sum',
        summaryRenderer: function (value) {return Ext.util.Format.number(value, '0,000.000000');}

    },
    {text: "备注",dataIndex: "REMARK",width: 200,type: "string",fontSize: "15px",hidden: false},
    {text: "筛选条件",dataIndex: "CONDITION",width: 200,type: "string",fontSize: "15px",hidden: true}
];
//所关联项目明细表表头
var zqxm_headerJson = [
    {
        xtype: 'rownumberer',
        summaryType: 'count',
        width: 40
    },
    {text: "明细单ID",class:"ty",dataIndex: "DATA_ID",width: 150,type: "string",fontSize: "15px",hidden:true},
    {text: "地区code",class:"ty",dataIndex: "AD_CODE",width: 150,type: "string",fontSize: "15px",hidden:true},
    {text: "地区",class:"ty",dataIndex: "AD_NAME",width: 150,type: "string",fontSize: "15px",hidden:false},
    {text: "单位名称",class:"ty",dataIndex: "AG_NAME",width: 150,type: "string",fontSize: "15px",hidden: false},
    {text: "项目ID",class:"ty",dataIndex: "XM_ID",width: 150,type: "string",fontSize: "15px",hidden:true},
    {text: "项目名称",class:"ty",dataIndex: "XM_NAME",width: 350,type: "string",fontSize: "15px",hidden: false,
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
    {text: "备案编码",class:"ty",dataIndex: "BA_CODE",width: 150,type: "string",fontSize: "15px",hidden: false},
    {text: "申请金额（万元）",class:"xmxz",dataIndex: "SQ_AMT",width: 200,type: "float",fontSize: "15px",hidden:false,editable: false,fieldStyle: 'background:#E6E6E6',
        summaryType: 'sum',
        summaryRenderer: function (value) {
            return Ext.util.Format.number(value, '0,000.00');
        }
    },
    {text: "申报日期",class:"xmxz",dataIndex: "SB_DATE",width: 150,type: "string",fontSize: "15px",hidden: false},
    {text: "项目编码",class:"ty",dataIndex: "XM_CODE",width: 350,type: "string",fontSize: "15px",hidden: false},
    {text: "项目类型",class:"ty",dataIndex: "XMLX_NAME",width: 150,type: "string",fontSize: "15px",hidden: false},
    {text: "项目性质",class:"xmxz",dataIndex: "XMXZ_NAME",width: 150,type: "string",fontSize: "15px",hidden: false},
    {text: "立项年度",class:"xmxz",dataIndex: "LX_YEAR",width: 150,type: "string",fontSize: "15px",hidden: false},
    {text: "建设性质",class:"xmxz",dataIndex: "JSXZ_NAME",width: 150,type: "string",fontSize: "15px",hidden: false},
    {text: "建设状态",class:"xmxz",dataIndex: "BUILD_STATUS_NAME",width: 150,type: "string",fontSize: "15px",hidden: false},
    {text: "主管部门",class:"ty",dataIndex: "LXSPBM_NAME",width: 150,type: "string",fontSize: "15px",hidden: false}
];
var MHCH3;//全局变量
$.extend(plwjjs_json_common,{
    defaultItems:WF_STATUS,
    items_content:function(){
        return [
            initPanel() //只有一个主界面，没有区划树
        ];
    },
    items:{
        '001':[//未审核
            {
                xtype:'button',
                text:'查询',
                name:'SEARCH',
                icon:'/image/sysbutton/search.png',
                handler:function(btn){
                    reloadYdjhGrid();
                }
            },
            {
                xtype:'button',
                text:'审核',
                name:'DOWN',
                icon:'/image/sysbutton/audit.png',
                handler:function(btn){
                    doworkFlow(btn);
                }
            },
            {
                xtype:'button',
                text:'退回',
                name:'UP',
                icon:'/image/sysbutton/back.png',
                handler:function(btn){
                    doworkFlow(btn);
                }
            },
            {
                xtype:'button',
                text:'操作记录',
                name:'LOG',
                icon:'/image/sysbutton/log.png',
                handler:function(btn){
                    doperation(btn);
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '002':[//已审核
            {
                xtype:'button',
                text:'查询',
                name:'SEARCH',
                icon:'/image/sysbutton/search.png',
                handler:function(btn){
                    reloadYdjhGrid();
                }
            },
            {
                xtype:'button',
                text:'撤销审核',
                name:'CANCEL',
                icon:'/image/sysbutton/audit.png',
                handler:function(btn){
                    doworkFlow(btn);
                }
            },
            {
                xtype:'button',
                text:'操作记录',
                name:'LOG',
                icon:'/image/sysbutton/log.png',
                handler:function(btn){
                    doperation(btn);
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()

        ]
    }
});
/*
    初始化主界面panel
 */
function initPanel(){
    //panel，
    return Ext.create('Ext.panel.Panel',{
        layout:'anchor',
        width:'100%',
        height:'100%',
        items:[
            initContentGrid(),//主表
            initMxTabPanel()//明细表
        ]
    });
}
/*
    主表月度计划数据
 */
function initContentGrid(){
    return DSYGrid.createGrid({
        itemId:'YdjhGrid_SH',
        //flex:1,
        anchor:'100% 50%',
        headerConfig:{
            headerJson:ydjh_headerJson,
            columnAutoWidth:false,
            columnCls:'normal'
        },
        checkBox:true,
        dataUrl:'getYdjhData.action',
        params:{
            IS_FB:'2',
            WF_STATUS:WF_STATUS,
            WF_ID:wf_id,
            USERCODE:userCode,
            NODE_CODE:node_code,
            USERID:userid,
            NODE_TYPE:node_type,
            GxdzUrlParam:GxdzUrlParam
        },
        tbar:[{
            xtype: 'combobox',
            fieldLabel: '状态',
            itemId: 'plwjStatus_toolbar_SH',
            value: WF_STATUS,
            store: DebtEleStore(json_debt_plwj),
            editable: false,
            allowBlank: false,
            displayField: 'name',
            valueField: 'id',
            labelWidth:40,
            labelAlign:'left',
            width:120,
            listeners: {
                change: function (slef, newValue) {
                    WF_STATUS = newValue;
                    //获取按钮所在工具栏
                    var tbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                    tbar.removeAll();
                    tbar.add(plwjjs_json_common.items[WF_STATUS]);
                    //刷新表格
                    reloadYdjhGrid();
                }
            }
        },
            {
                xtype:'textfield',
                fieldLabel:'模糊查询',
                itemId:'mhcx3',
                emptyText:'债券名称',
                labelWidth:60,
                width:400,
                enableKeyEvents:true,
                listeners:{
                    'keydown':function(self,e){
                        if(e.getKey()==Ext.EventObject.ENTER){
                            MHCH3 = self.value;
                            reloadYdjhGrid();
                        }
                    }
                }
            }
        ],
        listeners:{
            itemclick:function(self,record){
                var ydjh_id = record.get('YDJH_ID');
                var condition = record.get('CONDITION');
                reloadXzzqGrid(ydjh_id);
                //替换附件表
                reloadZqxmFjGrid(ydjh_id,condition);
            }
        }
    });
}
/*
    明细数据面板
 */
function initMxTabPanel(){
    return Ext.create('Ext.tab.Panel',{//下面是个tabpanel
        layout:'fit',
        itemId:'ydjh_mxtab_SH',
        anchor:'100% 50%',
        items:[
            {
                title:'附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout:'fit',
                itemId:'ydjh_plwj_tab_SH',
                items:initZqxmFjGrid()
            },
            {
                title: '债券汇总',
                layout: 'fit',
                name: 'xzzq',
                hidden:true,
                items: [insert_sy_xzzq()]
            },
            {
                title:'新增债券',
                layout:'fit',
                items:initXzzqGrid()
            }
        ]
    });
}
/*
    附件
 */
function initZqxmFjGrid(ydjh_id){
    var grid = UploadPanel.createGrid({
        editable:false,
        addHeaders:[{text:'区划',dataIndex:'AD_NAME',type:'string',index:1}],
        gridConfig:{
            itemId:'zqxm_plwj_fj'
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
/*
    项目信息
 */
function initXzzqGrid(){
    return DSYGrid.createGrid({
        itemId:'zqxmGrid_SH',
        flex:1,
        headerConfig:{
            headerJson:zqxm_headerJson,
            columnAutoWidth:false,
            columnCls:'normal'
        },
        pageConfig:{
            enablePage:false//不分页
        },
        dataUrl:'getZqxmGrid.action',
        autoLoad:false
    });
}
/*
    刷新月度计划gird
 */
function reloadYdjhGrid(){
    var store = DSYGrid.getGrid('YdjhGrid_SH').getStore();
    store.getProxy().extraParams.MHCH = MHCH3;
    store.getProxy().extraParams.WF_STATUS = WF_STATUS;
    store.reload();
}
/*
    刷新债券项目grid
 */
function reloadXzzqGrid(ydjh_id){
    // 刷新债券汇总页签
    DSYGrid.getGrid('itemId_sy_zqhz').getStore().getProxy().extraParams['YDJH_ID'] = ydjh_id;
    DSYGrid.getGrid('itemId_sy_zqhz').getStore().load();
    var store = DSYGrid.getGrid('zqxmGrid_SH').getStore();
    store.getProxy().extraParams.YDJH_ID = ydjh_id;
    store.reload();
}
/*
    刷新附件表
 */
function reloadZqxmFjGrid(ydjh_id,condition){
    var store = DSYGrid.getGrid('zqxm_plwj_fj').getStore();
    store.getProxy().extraParams.busi_id = ydjh_id;
    store.getProxy().extraParams.filterParam = condition;
    store.reload();
}
/*
    操作记录
 */
function doperation(){
    var records = DSYGrid.getGrid('YdjhGrid_SH').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条记录的操作记录！');
        return;
    } else {
        var ydjhId = records[0].get("YDJH_ID");
        fuc_getWorkFlowLog(ydjhId);
    }
}
/*
    工作流
 */
function doworkFlow(btn){
    button_name = btn.text;
    button_status = btn.name;
    var records = DSYGrid.getGrid('YdjhGrid_SH').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    }
    var ydjhIds = [];
    records.forEach(function(record){
        ydjhIds.push(record.get("YDJH_ID"));
    })
    //弹出意见填写对话框
    initWindow_opinion({
        title: btn.text,
        animateTarget: btn,
        value: btn.name == 'DOWN' ? '同意' : null,
        fn: function (buttonId, text) {
            if (buttonId === 'ok') {
                btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
                Ext.Msg.wait(button_name+'中……','提示');
                //发送ajax请求，修改节点信息
                Ext.Ajax.request({
                    method:'POST',
                    timeout:60000,
                    url:'doWorkFlow.action',
                    params:{
                        WF_ID:wf_id,
                        NODE_CODE:node_code,
                        USERCODE:userCode,
                        AUDIT_INFO:text,
                        BUTTON_NAME:button_name,
                        BUTTON_STATUS:button_status,
                        YDJH_IDS:Ext.JSON.encode(ydjhIds)
                    },
                    success:function(response){
                        var data = Ext.JSON.decode(response.responseText);
                        if(data.success){
                            Ext.Msg.hide();
                            Ext.toast(button_name+'成功！','提示','t');
                            btn.setDisabled(false);
                            reloadYdjhGrid();
                            reloadXzzqGrid();
                            reloadZqxmFjGrid();
                        }else{
                            Ext.Msg.alert('提示',button_name+'失败！'+data.msg);
                            btn.setDisabled(false);
                        }
                    },
                    failure:function(response){
                        Ext.Msg.alert('提示',button_name+'失败！'+response.status);
                        btn.setDisabled(false);
                    }
                });
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