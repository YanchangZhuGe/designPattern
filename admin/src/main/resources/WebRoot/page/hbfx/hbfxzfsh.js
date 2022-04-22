//偿还本金废除审核流程
var button_name='';
var button_status='';//当前按钮的状态
var IS_VIEW = false;
//加载页面主窗口

function initContentRightPanel() {
    return Ext.create('Ext.form.Panel',{
        height:'100%',
        flex:5,
        region:'center',
        layout:{
            type:'vbox',
            align:'stretch'
        },
        defaults:{
            flex:1,
            width:'100%'
        },
        border:false,
        dockedItems:[
            {
                xtype:'toolbar',
                dock:'top',
                layout:{
                    type:'column'
                },
                items:[
                    {
                        xtype: "combobox",
                        fieldLabel:'状态',
                        name:'WF_STATUS',
                        store:DebtEleStore(json_zt),
                        allowBlank: false,
                        labelAlign: 'left',//控件默认标签对齐方式
                        labelWidth: 40,
                        width: '170',
                        editable: false, //禁用编辑
                        displayField: "name",
                        valueField: "code",
                        value: WF_STATUS,
                        listeners:{
                            change: function (self, newValue){
                                WF_STATUS=newValue;
                                var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                                toolbar.removeAll();
                                toolbar.add(hbfxzf_json_common[node_type].items[WF_STATUS]);
                                //刷新当前表格
                                DSYGrid.getGrid('hbfxzfGrid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                                DSYGrid.getGrid('hbfxzfGrid').getStore().loadPage(1);
                                //刷新当前表格
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        name: "mhcx",
                        fieldLabel: '模糊查询',
                        allowBlank: true,  // requires a non-empty value
                        labelWidth: 70,
                        width: 260,
                        labelAlign: 'left',
                        emptyText: '请输入单位名称/债务名称...',
                        enableKeyEvents: true,
                        listeners:{
                            keypress:function (self, e){
                                if (e.getKey() == Ext.EventObject.ENTER) {
                                    reloadGrid();
                                }
                            }
                        }
                    }
                ]
            }
        ],
        items:hbfxzf_json_common[node_type].items_content_rightPanel_items?hbfxzf_json_common[node_type].items_content_rightPanel_items():[
            initHBFXGrid()
        ]
    });
}



$.extend(hbfxzf_json_common[node_type],{
    defautItems:'001',//默认状态
    items_content:function () {
        return [
            initContentTree({
                areaConfig:{
                    params:{
                        CHILD:1 //区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),
            initContentRightPanel()
        ];
    },
    items: {
        '001': [
            {
                xtype:"button",
                text:'查询',
                icon:'/image/sysbutton/search.png',
                handler:function () {
                    //重新加载页面
                    reloadGrid();
                }
            },
            {
                xtype:"button",
                text:'审核',
                name:'down',
                icon:'/image/sysbutton/submit.png',
                handler:function (btn) {
                    button_name=btn.text;
                    button_status=btn.name;
                    doWorkFlow(btn);
                }
            },
            {
                xtype:"button",
                text:'退回',
                name:'back',
                icon:'/image/sysbutton/back.png',
                handler:function (btn) {
                    button_name=btn.text;
                    button_status=btn.name;
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '002':[
            {
                xtype:"button",
                text:'查询',
                icon:'/image/sysbutton/search.png',
                handler:function () {
                    //重新加载页面
                    reloadGrid();
                }
            },
            {
                xtype:'button',
                text:'撤销审核',
                name:'cancel',
                icon:'/image/sysbutton/back.png',
                handler:function (btn) {
                   button_name=btn.text;
                   button_status=btn.name;
                   doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ],
        '008':[
            {
                xtype:"button",
                text:'查询',
                icon:'/image/sysbutton/search.png',
                handler:function () {
                    //重新加载页面
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    operationRecord();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    }
});



//右侧表格
function initHBFXGrid() {
    var headJson=[
        {xtype: 'rownumberer', width: 45},
        {dataIndex:'AG_ID',type:'string',hidden:true},
        {dataIndex:'AG_CODE',type:'string',hidden:true},
        {dataIndex:'CHZJ_MX_ID',type:'string',hidden:true},
        {dataIndex:'AG_NAME',type:'string',text:'单位名称',hidden:false},
        {
            dataIndex: 'ZW_ID', type: 'string',  hidden: true,
        },
        {dataIndex:'ZW_NAME',type:'string',text:'债务名称',hidden:false,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'))
                    + '&zwlb_id=' + encodeURIComponent(record.get('ZWLB_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                paramNames[1]="zwlb_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                paramValues[1]=encodeURIComponent(record.get('ZWLB_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {dataIndex:'CHBJ_DATE',type:'string',text:'偿还日期',hidden:false},
        {dataIndex:'CHBJ_AMT_RMB',type:'float',text:'偿还金额(元 注:人民币)',hidden:false},
        {dataIndex:'YUANCHBJ_DATA',type:'string',text:'原偿还日期',width:220,hidden:false,align:'center'},
        {dataIndex:'zjly_name',type:'string',text:'偿还资金来源',hidden:false},

    ];
    return DSYGrid.createGrid({
        itemId:'hbfxzfGrid',
        headerConfig:{
            headerJson:headJson,
            conlumnAutoWidth:false
        },
        rowNumber: {
            rowNumber: true
        },
        checkBox: true,
        border: false,
        flex: 1,
        autoLoad: false,
        params: {
            AD_CODE: '',
            WF_STATUS:WF_STATUS,//当前状态（未审核 已审核 ）
            WF_ID:wf_id,//当前工作流节点
            NODE_CODE:node_code,//当前节点
        },
        dataUrl: 'queryhbzfdata.action',
        pageConfig: {
            pageNum: true, //设置显示每页条数
            enablePage: true
        },
    })
}


/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    // 获取选中汇总数据
    var records = DSYGrid.getGrid('hbfxzfGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条后再进行操作');
        return;
    }
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("CHZJ_MX_ID"));
    }
    //撤销
    //button_name = btn.text;
    if (button_status=='down'||button_status=='back') {////审核 退回
        //弹出意见填写对话框
       initWindow_opinion({
            title: btn.text + '意见',
            value: button_status == 'up' ? '' : '同意',
            animateTarget: btn,
            fn: function (buttonId, text, opt) {
                if (buttonId === 'ok') {
                    doWorkFlow_ajax(ids, btn, text);
                }
            }
        });
    }
    else if(button_status == 'cancel' ){//撤销
        Ext.Msg.confirm('提示','请确认是否'+button_name+'"?',function (status) {
            if(status=="yes"){
                doWorkFlow_ajax(ids,btn,"");
            }else if(status=='no'){
                return;
            }
        });
    }
    if (button_status == 'cancel_sh' || button_status == 'cancel_th') {
        doWorkFlow_ajax(ids, btn, '');
    }
}
//发送ajax请求，修改工作流
function doWorkFlow_ajax(ids,btn,text) {
    $.post("/doWorkFlowChbjZf.action",{
        workflow_direction: btn.name,//status状态
        button_name: button_name,//按钮名称
        button_status: button_status,
        wf_id:wf_id,
        audit_info:text,
        node_code:node_code,
        WF_STATUS:WF_STATUS,
        ids: ids
    },function (data) {
         if(data.success){
             Ext.toast({
                 html: button_name+"成功",
                 closable: false,
                 align: 't',
                 slideInDuration: 400,
                 minWidth: 400
             });
         }else {
             Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
         }
        //刷新表格
        reloadGrid();
    },"json");
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
//重新加载项目资产填报表格
function reloadGrid() {
    var hbfxzfGrid = DSYGrid.getGrid("hbfxzfGrid");
    var hbfxzfStore = hbfxzfGrid.getStore();
    //var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
    hbfxzfStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
    hbfxzfStore.getProxy().extraParams['AG_CODE'] = AG_CODE;
    hbfxzfStore.loadPage(1);
    DSYGrid.getGrid("hbfxzfGrid").getStore().removeAll();
}

/**
 * 操作记录
 */
function operationRecord() {
    var records = DSYGrid.getGrid('hbfxzfGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var fhdw_id = records[0].get("CHZJ_MX_ID");
        fuc_getWorkFlowLog(fhdw_id);
    }
}