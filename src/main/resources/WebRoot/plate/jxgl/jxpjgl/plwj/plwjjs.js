/*
    披露文件接收
 */
/*工作流状态*/
var json_debt_plwj = [
    {id: "001", code: "001", name: "已接收"},
    {id: "002", code: "002", name: "已送审"},
    {id: "004", code: "004", name: "被退回"},
    {id: "008", code: "008", name: "曾经办"}
];
var GxdzUrlParam=getQueryParam("GxdzUrlParam");
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
var MHCH1;//全局变量
var MHCH2;
var store_zjSelect = DebtEleStoreTable('DEBT_V_ZQGL_PSZJ',{condition:" and status ='1' "})
$.extend(plwjjs_json_common,{
    defaultItems:WF_STATUS,
    items_content:function(){
        return [
            initPanel() //只有一个主界面，没有区划树
        ];
    },
    items:{
        '001':[//未送审
            {
                xtype:'button',
                text:'查询',
                name:'SEARCH',
                icon:'/image/sysbutton/search.png',
                handler:function(btn){
                    reloadYdjhGrid();
                    //reloadZqxmFjGrid();
                    //reloadXzzqGrid();
                }
            },
            {
                xtype:'button',
                text:'接收',
                name:'ACCEPT',
                icon:'/image/sysbutton/download.png',
                handler:function(btn){
                    initPlwjWjsWindow(btn);
                }
            },
            {
                xtype:'button',
                text:'撤销接收',
                name:'cel_js',
                icon:'/image/sysbutton/audit.png',
                handler:function(btn){
                    delPlwjjs(btn);
                }
            },
            {
                xtype:'button',
                text:'送审',
                name:'DOWN',
                icon:'/image/sysbutton/audit.png',
                handler:function(btn){
                    if(GxdzUrlParam!=null&&GxdzUrlParam!=undefined&GxdzUrlParam!=""){
                    if(GxdzUrlParam.substring(0,2)=='43'){//湖南省直接省级审，不许要选择专家进行审核
                        doworkFlow(btn);
                    }else{
                    Window_zjSelect(btn);
                    }
                    }else{
                    Window_zjSelect(btn);
                }}
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
        '002':[//已送审
            {
                xtype:'button',
                text:'查询',
                name:'SEARCH',
                icon:'/image/sysbutton/search.png',
                handler:function(btn){
                    reloadYdjhGrid();
                    //reloadZqxmFjGrid();
                    //reloadXzzqGrid();
                }
            },
            {
                xtype:'button',
                text:'撤销送审',
                name:'CANCEL',
                icon:'/image/sysbutton/audit.png',
                handler:function(btn){
                    doworkFlow(btn,'');
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
        '004':[//被退回
            {
                xtype:'button',
                text:'查询',
                name:'SEARCH',
                icon:'/image/sysbutton/search.png',
                handler:function(btn){
                    reloadYdjhGrid();
                    //reloadZqxmFjGrid();
                    //reloadXzzqGrid();
                }
            },
            {
                xtype:'button',
                text:'撤销接收',
                name:'cel_js',
                icon:'/image/sysbutton/audit.png',
                handler:function(btn){
                    delPlwjjs(btn);
                }
            },
            {
                xtype:'button',
                text:'送审',
                name:'DOWN',
                icon:'/image/sysbutton/audit.png',
                handler:function(btn){
                    Window_zjSelect(btn);
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
        '008':[//曾经办
            {
                xtype:'button',
                text:'查询',
                name:'SEARCH',
                icon:'/image/sysbutton/search.png',
                handler:function(btn){
                    reloadYdjhGrid();
                    //reloadZqxmFjGrid();
                    //reloadXzzqGrid();
                }
            },
            {
                xtype:'button',
                text:'操作记录',
                name:'LOG',
                icon:'/image/sysbutton/log.png',
                handler:function(btn){
                    doperation();
                }
            },
            {
                xtype:'button',
                text:'导出',
                name:'EXPORT',
                icon:'/image/sysbutton/export.png',
                handler:function(btn){
                    downloadPlwjFile(btn);
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
            initMxTabPanel('')//明细表
        ]
    });
}
/*
    主表月度计划数据
 */
function initContentGrid(){
    return DSYGrid.createGrid({
        itemId:'YdjhGrid',
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
            GxdzUrlParam:GxdzUrlParam
        },
        tbar:[{
                xtype: 'combobox',
                fieldLabel: '状态',
                itemId: 'plwjStatus_toolbar',
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
                        //reloadZqxmFjGrid();
                        //reloadXzzqGrid();
                    }
                }
            },
            {
                xtype:'textfield',
                fieldLabel:'模糊查询',
                itemId:'mhcx1',
                emptyText:'债券名称',
                labelWidth:60,
                width:400,
                enableKeyEvents:true,
                listeners:{
                    'keydown':function(self,e){
                        if(e.getKey()==Ext.EventObject.ENTER){
                            MHCH1 = self.value;
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
                reloadXzzqGrid(ydjh_id,'');
                //替换附件表
                reloadZqxmFjGrid(ydjh_id,condition,'');
            }
        }
    });
}
/*
    明细数据面板
 */
function initMxTabPanel(name){
    return Ext.create('Ext.tab.Panel',{//下面是个tabpanel
        layout:'fit',
        itemId:'ydjh_mxtab'+name,
        anchor:'100% 50%',
        items:[
            {
                title:'附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout:'fit',
                itemId:'ydjh_plwj_tab',
                items:initZqxmFjGrid(name)
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
                items:initXzzqGrid(name)
            }
        ]
    });
}
/*
    附件
 */
function initZqxmFjGrid(name){
    var grid = UploadPanel.createGrid({
        editable:false,
        addHeaders:[{text:'区划',dataIndex:'AD_NAME',type:'string',index:1}],
        gridConfig:{
            itemId:'zqxm_plwj_fj'+name
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
function initXzzqGrid(name){
    return DSYGrid.createGrid({
        itemId:'zqxmGrid'+name,
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
    var store = DSYGrid.getGrid('YdjhGrid').getStore();
    store.getProxy().extraParams.MHCH = MHCH1;
    store.getProxy().extraParams.WF_STATUS = WF_STATUS;
    store.reload();
    //清空明细表
    DSYGrid.getGrid('zqxmGrid').getStore().removeAll();
    DSYGrid.getGrid('zqxm_plwj_fj').getStore().removeAll();
}
/*
    刷新债券项目grid
 */
function reloadXzzqGrid(ydjh_id,name){
    var store = DSYGrid.getGrid('zqxmGrid'+name).getStore();
    //刷新附件
    /*DSYGrid.getGrid('itemId_sy_zqhz').getStore().getProxy().extraParams['YDJH_ID'] = ydjh_id;
    DSYGrid.getGrid('itemId_sy_zqhz').getStore().load();*/
    store.getProxy().extraParams.YDJH_ID = ydjh_id;
    store.reload();
}
/*
    刷新附件表
 */
function reloadZqxmFjGrid(ydjh_id,condition,name){
    var store = DSYGrid.getGrid('zqxm_plwj_fj'+name).getStore();
    store.getProxy().extraParams.busi_id = ydjh_id;
    store.getProxy().extraParams.filterParam = condition;
    store.reload();
}
/*
    未接收文件弹出框
 */
function initPlwjWjsWindow(btn){
    return Ext.create('Ext.window.Window',{
        title:'披露文件接收',
        itemId:'plwjjs_window',
        width:document.body.clientWidth*0.7,
        height:document.body.clientHeight*0.7,
        layout:'fit',
        maximizable:true,
        closeAction:'destroy',
        modal:true,
        buttonAlign:'right',
        items:[
            initplwjPanel()
            //initplwjjsGrid()
            //initMxTabPanel()
        ],
        buttons:[
            {
                xtype:'button',
                text:'确定',
                handler:function(btn){
                    receivePlwj(btn);
                }
            },
            {
                xtype:"button",
                text:'取消',
                handler:function(btn){
                    btn.up('window').close();
                }
            }
        ]
    }).show();
}
function initplwjPanel(){
    return Ext.create('Ext.panel.Panel',{
        layout:'anchor',
        width:'100%',
        height:'100%',
        items:[
            initplwjjsGrid('chose'),//主表
            initMxTabPanel('chose')//明细表
        ]
    });
}


/*
    披露文件接收选择表格
 */
function initplwjjsGrid(name){
    return DSYGrid.createGrid({
        itemId:'ydjhGridWjs',
        anchor:'100% 50%',
        flex:1,
        headerConfig:{
            headerJson:ydjh_headerJson,
            columnAutoWidth:false,
            columnCls:'normal'
        },
        dataUrl:'getYdjhData.action',
        params:{
            IS_FB:'1'
        },
        checkBox:true,
        //autoLoad:false,
        tbar:[
            {
                xtype:'textfield',
                fieldLabel:'模糊查询',
                labelWidth:60,
                width:300,
                emptyText:'债券名称',
                enableKeyEvents:true,
                listeners:{
                    'keydown':function(self,e){
                        if(e.getKey()==Ext.EventObject.ENTER){
                            MHCH2 = self.value;
                            reloadPlwjGrid();
                        }
                    }
                }
            }
        ],
        listeners:{
            itemclick:function(self,record){
                var ydjh_id = record.get('YDJH_ID');
                var condition = record.get('CONDITION');
                reloadXzzqGrid(ydjh_id,name);
                //替换附件表
                reloadZqxmFjGrid(ydjh_id,condition,name);
            }
        }
    });
}
/*
    披露文件接收数据查询
 */
function reloadPlwjGrid(){
    var store = DSYGrid.getGrid('ydjhGridWjs').getStore();
    store.getProxy().extraParams.MHCH = MHCH2;
    store.reload();
}
/*
    接收披露文件
 */
function receivePlwj(btn){
    button_name = btn.text;
    var grid = DSYGrid.getGrid('ydjhGridWjs');
    var records = grid.getSelection();
    if(records.length<=0){
       Ext.Msg.alert('提示','请至少选择一笔月度发行计划！');
       return;
    }
    var ydjhIds = [];
    records.forEach(function(record){
        ydjhIds.push(record.get("YDJH_ID"));
    })
    btn.setDisabled(true);
    Ext.Msg.wait('接收中……','提示');
    Ext.Ajax.request({
        method:'POST',
        timeout:60000,
        url:'receiveYdjhData.action',
        params:{
            WF_ID:wf_id,
            NODE_CODE:node_code,
            USERCODE:userCode,
            BUTTON_NAME:button_name,
            YDJH_IDS:Ext.JSON.encode(ydjhIds)
        },
        success:function(response){
            var data = Ext.JSON.decode(response.responseText);
            if(data.success){
                Ext.Msg.hide();
                Ext.toast('接收成功！','提示','t');
                btn.up('window').close();
                reloadYdjhGrid();
            }else{
                Ext.Msg.alert('提示','接收失败！'+data.msg);
                btn.setDisabled(false);
            }
        },
        failure:function(response){
            Ext.Msg.alert('提示','接收失败！'+response.status);
            btn.setDisabled(false);
        }
    });
}
/*
    操作记录
 */
function doperation(){
    var records = DSYGrid.getGrid('YdjhGrid').getSelection();
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
function doworkFlow(btn,pszj_id){
    button_name = btn.text;
    button_status = btn.name;
    var records = DSYGrid.getGrid('YdjhGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    }
    var ydjhIds = [];
    records.forEach(function(record){
        ydjhIds.push(record.get("YDJH_ID"));
    });
    btn.setDisabled(true);
    Ext.Msg.wait(button_name+'中……','提示');
    Ext.Ajax.request({
        method:'POST',
        timeout:60000,
        url:'doWorkFlow.action',
        params:{
            WF_ID:wf_id,
            NODE_CODE:node_code,
            USERCODE:userCode,
            BUTTON_NAME:button_name,
            BUTTON_STATUS:button_status,
            YDJH_IDS:Ext.JSON.encode(ydjhIds),
            PSZJ_ID:pszj_id
        },
        success:function(response){
            var data = Ext.JSON.decode(response.responseText);
            if(data.success){
                Ext.Msg.hide();
                Ext.toast(button_name+'成功！','提示','t');
                btn.setDisabled(false);
                reloadYdjhGrid();
                //reloadXzzqGrid();
                //reloadZqxmFjGrid();
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
function delPlwjjs(btn) {
    button_name = btn.text;
    button_status = btn.name;
    var records = DSYGrid.getGrid('YdjhGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    }
    var ydjhIds = [];
    records.forEach(function(record){
        ydjhIds.push(record.get("YDJH_ID"));
    });
    btn.setDisabled(true);
    Ext.Msg.wait(button_name+'中……','提示');
    Ext.Ajax.request({
        method:'POST',
        timeout:60000,
        url:'delPlwjjs.action',
        params:{
            WF_ID:wf_id,
            NODE_CODE:node_code,
            USERCODE:userCode,
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
                //reloadXzzqGrid();
                //reloadZqxmFjGrid();
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
/**
 * 披露文件导出
 */
function downloadPlwjFile(btn) {
    var grid = DSYGrid.getGrid('YdjhGrid');
    var records = grid.getSelection();
    if (records.length <= 0) {
        Ext.Msg.confirm('提示', '您未选择数据，默认将导出页面全部数据的披露文件，是否继续？', function (status) {
            if ('yes' == status) {
                var store = grid.getStore();
                store.each(function (record) {
                    records.push(record);
                });
                submit(records);
            }
        });
    } else {
        Ext.Msg.confirm('提示', '确认下载吗？', function (btn) {
            if (btn == 'yes') {
                submit(records);
            }
        });
    }
}
/**
 * 提交
 * @param records
 */
function submit(records){
    var ydjhIds = [];
    records.forEach(function(record){
        ydjhIds.push(record.get('YDJH_ID'));
    });
    Ext.Msg.wait('正在下载文件，请稍等……','提示',{text:'加载中……'});
    Ext.Ajax.request({
        url:'buildPlwjStructure.action',
        method:'POST',
        timeout:1800000,//响应时间超过三十分钟报错
        params:{
            YDJH_IDS:Ext.JSON.encode(ydjhIds)
        },
        success:function(response){
            var text = Ext.decode(response.responseText);
            if(text.success){
                var file_name = text.file_name;
                var message = text.message;
                Ext.Msg.close();
                //文件太大，给出提示
                if(!!message){
                    Ext.Msg.confirm('提示',message,function(btn){
                        if(btn=='yes'){
                            Ext.Msg.wait('正在压缩文件，请稍等……','提示',{text:'加载中……'});
                            $.post('/downloadPlwj.action',{
                                file_name:file_name,
                                xzfs:'2'
                            },function(data){
                                Ext.Msg.close();
                                Ext.Msg.alert('提示',data.message);
                            },"json");
                        }else{
                            window.location.href = 'downloadPlwj.action?file_name=' + encodeURI(encodeURI(file_name))+'&xzfs=1';
                        }
                    });
                }else{
                    window.location.href = 'downloadPlwj.action?file_name=' + encodeURI(encodeURI(file_name))+'&xzfs=1';
                }
            }else{
                //先关闭滚动条
                Ext.Msg.close();
                Ext.Msg.alert('提示','文件下载失败！'+text.message);
            }
            //刷新grid
            reloadYdjhGrid();
        },
        failure:function(reponse){
            //var text = Ext.decode(response.responseText);
            //先关闭滚动条
            Ext.Msg.close();
            Ext.Msg.alert('提示','文件下载失败！');
        }
    });
}
function Window_zjSelect(btn) {
    var zjSelect= Ext.create('Ext.window.Window', {
        itemId: 'window_zjxz', // 窗口标识
        name: 'zjxzWin',
        title: '评审专家选择', // 窗口标题
        width:  document.body.clientWidth * 0.25, //自适应窗口宽度
        height: document.body.clientHeight * 0.2, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [
            {
                xtype: 'form',
                layout: 'anchor',
                defaults: {
                    anchor: '100%',
                    margin: '10 20 0 10'
                },
                items: [
                    {
                        xtype: 'combobox',
                        fieldLabel: '评审专家',
                        name: 'PSZJ_ID',
                        displayField: 'name',
                        valueField: 'id',
                        editable: false,
                        allowBlank: false,
                        flex: 1,
                        autoLoad: false,
                        selectModel: "leaf",
                        labelAlign: 'right',//控件默认标签对齐方式
                        store:store_zjSelect
                    }
                ]
            }
        ],
        buttons: [
            {
                text: '确定',
                handler: function (btns) {
                    var form= btns.up('window').down('form');
                    if (form&&!form.isValid()) {
                        return false;
                    }
                    var pszj_id=form.getForm().findField("PSZJ_ID").value;
                    btns.up('window').close();
                    doworkFlow(btn,pszj_id);
                }
            },
            {
                text: '取消',
                handler: function (btns) {
                    btns.up('window').close();
                }
            }
        ]
    });
    zjSelect.show();
}