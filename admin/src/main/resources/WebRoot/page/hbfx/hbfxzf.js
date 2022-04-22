//存量债务政府自有资金还本付息本金作废功能
//全局变量
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
                                // console.log(hbfxzf_json_common[node_type].items[WF_STATUS]);
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
                        name: "MHCX_ZW",
                        id: 'MHCX_ZW',
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
                                    var MHCX_ZW = Ext.ComponentQuery.query('textfield#MHCX_ZW')[0].getValue();
                                    var existingProjectStore = DSYGrid.getGrid('hbfxzfGrid').getStore();
                                    existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                                    existingProjectStore.getProxy().extraParams['AG_ID'] = AG_ID;
                                    existingProjectStore.getProxy().extraParams['MHCX_ZW'] = MHCX_ZW;
                                    existingProjectStore.loadPage(1);
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
                   reloadGrid();
                }
            },
            {
                xtype:"button",
                text:'录入',
                icon:'/image/sysbutton/add.png',
                handler:function (btn) {
                button_name=btn.text;
                //获取树组件
                 var treeArray= btn.up('panel').down('panel#treePanel_left').query('treepanel');
                    var selected_ad = treeArray[0].getSelection()[0];
                    var selected_ag = treeArray[1].getSelection()[0];
                   /* if (!selected_ad && !selected_ag) {
                        Ext.Msg.alert('提示', "请选择区划和单位");
                        return;
                    }else if (!selected_ad || !selected_ad.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级区划再进行操作！");
                        return;
                    } else if (!selected_ag || !selected_ag.isLeaf()) {
                        Ext.Msg.alert('提示', "请选择底级单位再进行操作！");
                        return;
                    }*/
                    AD_CODE = treeArray[0].getSelection()[0].get('code');
                  // console.log(treeArray[0].getSelection()[0].get('code'));
                  // console.log(selected_ag);
                   if(!selected_ag&&typeof(selected_ag)!='undefined'){
                       AD_NAME = treeArray[0].getSelection()[0].get('text');
                       AG_CODE = treeArray[1].getSelection()[0].get('code');
                       AG_ID = treeArray[1].getSelection()[0].get('id');
                       AG_NAME = treeArray[1].getSelection()[0].get('text');
                   }
                    //调用生成选择还本付息选择已偿还本金窗口
                    chooseHBFXZWWindow.show();
                    var CHBJGrid=DSYGrid.getGrid('existingZWGrid').getStore();
                    CHBJGrid.getProxy().extraParams['AD_CODE'] = AD_CODE;
                    CHBJGrid.getProxy().extraParams['AG_ID']=AG_ID;
                    CHBJGrid.getProxy().extraParams['AG_CODE']=AG_CODE;
                    CHBJGrid.loadPage(1);
                }
            },
            {
                xtype:"button",
                text:'修改',
                icon:'/image/sysbutton/edit.png',
                handler:function (btn) {
                        button_name=btn.text;
                        updatedata(btn);
                }
            },
            {
                xtype:"button",
                text:'删除',
                name:'dele_btn',
                icon:'/image/sysbutton/delete.png',
                handler:function (btn) {
                    button_name=btn.text;
                    button_status=btn.name;
                    deleteCHDateData(btn);
                }
            },
            {
                xtype:"button",
                text:'送审',
                name:'down',
                icon:'/image/sysbutton/report.png',
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
                   reloadGrid();
                }
            },
            {
                xtype:'button',
                text:'撤销送审',
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
        '004':[
            {
                xtype:"button",
                text:'查询',
                icon:'/image/sysbutton/search.png',
                handler:function () {
                    reloadGrid();
                }
            },
            {
                xtype:"button",
                text:'修改',
                icon:'/image/sysbutton/edit.png',
                handler:function (btn) {
                    button_name=btn.text;
                    updatedata(btn);
                }
            },
            {
                xtype:"button",
                text:'删除',
                name:'dele_btn',
                icon:'/image/sysbutton/delete.png',
                handler:function (btn) {
                    button_name=btn.text;
                    button_status=btn.name;
                    deleteCHDateData(btn);
                }
            },
            {
                xtype:"button",
                text:'送审',
                name:'down',
                icon:'/image/sysbutton/report.png',
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
        {dataIndex:'ZW_ID',type:'string',hidden:true},
        {dataIndex:'CHZJ_MX_ID',type:'string',hidden:true},
        {dataIndex:'AD_NAME',type:'string',hidden:true},
        {dataIndex:'AG_NAME',type:'string',text:'单位名称',width:220,hidden:false},
        {dataIndex:'ZW_NAME',type:'string',text:'债务名称',width:260,hidden:false,
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
        {dataIndex:'YUANCHBJ_DATA',type:'string',text:'原偿还日期',width:220,hidden:false,align:'center'},
        {dataIndex:'CHBJ_DATE',type:'string',text:'整改日期',width:220,hidden:false,align:'center'},
        {dataIndex:'CHBJ_AMT_RMB',type:'float',text:'偿还金额(元 人民币)',align:'right',width:250,hidden:false},
        {dataIndex:'CHBJ_AMT',type:'float',text:'原币金额',align:'right',width:250,hidden:false},
        {dataIndex:'RATE',type:'float',text:'汇率',width:150,hidden:false},
        {dataIndex:'ZJLY_NAME',type:'string',text:'偿还资金来源',width:220,hidden:false},
        {dataIndex:'ZWLB_NAME',type:'string',text:'债务类别',width:150,hidden:false},
        {dataIndex:'WZ',type:'string',text:'是否外债',width:120},
        {dataIndex:'REMARK',type:'string',text:'备注',width:250,hidden:false}
    ];
    return DSYGrid.createGrid({
        itemId:'hbfxzfGrid',
        headerConfig:{
            headerJson:headJson,
            columnAutoWidth: false
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
            WF_STATUS:WF_STATUS,
            WF_ID:wf_id,
            NODE_CODE:node_code,
            MHCX_ZW:''
        },
        dataUrl: 'queryhbzfdata.action',
        pageConfig: {
            pageNum: true, //设置显示每页条数
            enablePage: true
        },
    })
}
//创建选择自由还本付息已偿还本金window
var chooseHBFXZWWindow={
    window:null,
    show:function () {
        if(!this.widow){
              this.window=initChooseHBFXZWWindow()
        }
        this.window.show();
    }
};
function initChooseHBFXZWWindow() {
    return Ext.create('Ext.window.Window',{
        height: document.body.clientHeight * 0.9,
        width: document.body.clientWidth * 0.9,
        title:'选择已偿还的债务本金信息',
        maximizable: true,
        modal: true,
        closeAction: 'destroy',
        layout: 'fit',
        items:[initYCBJGrid()],
        buttons:['->',
            {
                xtype:'button',
                text: '确定',
                name: 'OK',
                hidden: IS_VIEW,
                handler:function (btn) {
             //获取当前用户选中的Grid
                    if(DSYGrid.getGrid("existingZWGrid")){
                        var HBFXGrid= DSYGrid.getGrid("existingZWGrid");
                        var record=  HBFXGrid.getSelectionModel().getSelection();
                        if (record.length < 1) {
                            Ext.MessageBox.alert('提示', '请至少选择一条数据进行操作');
                            return;
                        }
                        btn.up('window').close();
                        //加载显示本债务的卡片window
                        seeHBFXWindow.show();
                        seeHBFXWindow.window.down('form#hbfxForm').getForm().setValues(record[0].data);
                    }

                }
            },
            {
                xtype:'button',
                text: '取消',
                name: 'OK',
                hidden: IS_VIEW,
                handler:function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                IS_VIEW = false;
                chooseHBFXZWWindow.window = null;
            }
        }
    });
}
//显示已偿还的本金的Grid表格
function initYCBJGrid() {
    var headerJson=[
        {xtype: 'rownumberer', width: 45},
        {dataIndex:'AG_ID',type:'string',width:180,hidden:true},//单位id
        {dataIndex:'CHBJ_ID',type:'string',hidden:true},//偿还本金id
        {dataIndex:'ZW_ID',type:'string',width:100,hidden:true},//债务id
        {dataIndex:'CHZJ_MX_ID',type:'string',hidden:true},//偿还资金明细ID
        {dataIndex:'ZJLY_ID',type:'string',hidden:true},//资金来源ID
        {dataIndex:'AD_CDOE',type:'string',hidden:true},
        {dataIndex:'IS_VALID',type:'string',hidden:true},//有效标识
        {dataIndex:'AD_NAME',type:'string',hidden:true},//债务地区
        {dataIndex:'AG_CODE',type:'string',hidden:true},//单位code
        {dataIndex:'AG_ID',type:'string',hidden:true},//单位id
        {dataIndex:'YDCH_ID',type:'string',hidden:true},//还款计划id
        {dataIndex:'CHECK_STATUS',type:"string",hidden:true},//支出状态
        {dataIndex:'ZW_CODE',type:'string',hidden:true},//债务编码
        {dataIndex:'ZQ_ID',type:'string',hidden:true},//债券id
        {dataIndex:'ZQ_NAME',type:'string',hidden:true},//债券name
        {dataIndex:'AG_NAME',type:'string',text:'单位名称',width:180,hidden:false},//债务单位名字
        {dataIndex:'ZW_NAME',type:'string',text:'债务名称',width:250,hidden:false,//债务名称
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
        {dataIndex:'XM_ID',type:'string',hidden:true},
        {dataIndex:'XM_NAME',type:'string',text:'项目名称',width:250,hidden:false,
            renderer: function (data, cell, record) {
               /* var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
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
        {dataIndex:'CHBJ_DATE',type:'string',text:'偿还日期',width:180,hidden:false},//偿还日期
        {dataIndex:'CHBJ_AMT_RMB',type:'float',text:'偿还金额(元 人民币)',width:210,hidden:false},//人民币金额
        {dataIndex:'CHBJ_AMT',type:'float',width:210,text:'原币金额',hidden:false},//原币金额
        {dataIndex:'RATE',type:'float',width:150,text:'汇率',hidden:false},//汇率
        {dataIndex:'ZJLY_NAME',type:'string',text:'偿还资金来源',width:180,hidden:false},//资金来源name
        {dataIndex:'CHBJ_TYPE',type:'string',text:'还款类型',width:180},//偿还类型
        {dataIndex:'ZWLB_ID',type:'string',hidden:true},
        {dataIndex:'ZWLB_NAME',type:'string',text:"债务类别",width:180},
        {dataIndex:'IS_WZ',type:'string',hidden:true},
        {dataIndex:'WZ',type:'string',text:"是否外债",width:180}
    ];

    var grid=DSYGrid.createGrid({
        itemId: 'existingZWGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        rowNumber: true,
        border: false,
        tbar:[],
        tbarHeight: 50,
        checkBox: true,
        selModel: {
            mode: "SINGLE" //设置为单选
        },
        autoLoad: false,
        params: {
            AD_CODE: '',
            AG_ID: '',
            AG_CODE:'',
            MHCX_ZW:'',
            HKJH_YEAR: '',
            HKJH_MO: ''
        },
        //顶部工具条
        /*tbar:[
            {
                fieldLabel: '截至年月',
                xtype: 'fieldcontainer',
                layout: 'column',
                width: 260,
                name:'date',
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
                xtype: "textfield",
                name: "MHCX_ZW",
                id: 'MHCX_ZW',
                fieldLabel: '模糊查询',
                allowBlank: true,
                labelWidth: 70,
                width: 240,
                labelAlign: 'right',
                emptyText: '请输入债务名称...',
                enableKeyEvents: true,
                listeners:{
                    keypress: function (self, e){
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var MHCX_ZW = Ext.ComponentQuery.query('textfield#MHCX_ZW')[0].getValue();
                            var existingProjectStore = DSYGrid.getGrid('existingZWGrid').getStore();
                            existingProjectStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                            existingProjectStore.getProxy().extraParams['AG_ID'] = AG_ID;
                            existingProjectStore.getProxy().extraParams['MHCX_ZW'] = MHCX_ZW;
                            existingProjectStore.loadPage(1);
                            MHCX_ZW.down();
                            reloadGrid();
                        }
                    }
                }
            },
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var hbfxzfGrid = DSYGrid.getGrid("existingZWGrid");
                    var hbfxzfStore = hbfxzfGrid.getStore();
                    var MHCX_ZW = Ext.ComponentQuery.query('textfield#MHCX_ZW')[0].getValue();
                    //var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
                    hbfxzfStore.getProxy().extraParams['AD_CODE'] = AD_CODE;
                    hbfxzfStore.getProxy().extraParams['AG_CODE'] = AG_CODE;
                    hbfxzfStore.getProxy().extraParams['MHCX_ZW'] = MHCX_ZW;
                    hbfxzfStore.loadPage(1);
                    DSYGrid.getGrid("existingZWGrid").getStore().removeAll();
                }

            }
        ],*/
        dataUrl: 'queryCHBJYSGridAction.action',
        pageConfig: {
            enablePage: true,//设置分页为false
            //pageNum: true
        }
    });
    //将form添加到表格中
    var searchTool = initWindow_grid_searchTool();
    grid.addDocked(searchTool, 0);
return grid;
}


/**
 * 弹出框搜索区域
 */
function initWindow_grid_searchTool() {
    //初始化查询控件
    var items = [
        {
            fieldLabel: '偿还日期',
            xtype: 'fieldcontainer',
            layout: 'column',
            width: 260,
            labelWidth: 60,
            defaults: {
                xtype: "combobox",
                width: 90,
                displayField: "name",
                valueField: "code",
                editable:false,
                margin: '0 5 0 0'
            },
            items: [
                {name: "HKJH_YEAR", store: DebtEleStore(getYearListWithAll())/*, value: new Date().getFullYear()*/},
                {name: "HKJH_MO", store: DebtEleStore(json_debt_yf_qb)/*, value: lpad(1 + new Date().getUTCMonth(), 2)*/}
            ]
        },
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            name: 'MHCX_ZW',
            itemId: 'yjh_contentGrid_search',
            width: 450,
            labelWidth: 60,
            emptyText: '请输入债务名称/单位名称',
            enableKeyEvents: true,
            listeners: {
                'keydown': function (self, e, eOpts) {
                    var key = e.getKey();
                    if (key == Ext.EventObject.ENTER) {
                        getZWDataList(self);
                    }
                }
            }
        }
    ];
    //设置查询form
    var searchTool = new DSYSearchTool();
    searchTool.setSearchToolId('searchTool_grid_ZW');
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
            getZWDataList(self);
        }
    });
    /**
     * 查询按钮实现
     */
    function getZWDataList() {
        var store = DSYGrid.getGrid('existingZWGrid').getStore();//得到债务Store
        var self = DSYGrid.getGrid('existingZWGrid').down('form');//取到grid下的form
        // 清空参数中已有的查询项
        for (var search_form_i in self.getValues()) {//清空筛选组件中的值
            delete store.getProxy().extraParams[search_form_i];
        }
        var formValue = self.getValues();
        if (self.down('combobox[name="HKJH_YEAR"]').isDisabled()) {//给form中 的从combobox赋值
            formValue.HKJH_YEAR = '';
            formValue.HKJH_MO = '';
        }
        //截至年为空提示
       /* if ((formValue.HKJH_MO != null && formValue.HKJH_MO != '') && (formValue.HKJH_YEAR == null || formValue.HKJH_YEAR == '' || formValue.HKJH_YEAR == 'undefined')) {
            Ext.Msg.alert("提示", "截至年不能为空!");
            return false;
        }*/
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
//已偿还本金window查看
var seeHBFXWindow={
    window:null,
    show:function () {
        if(!this.window){
           this.window=initSeeHBFXWindow();
        }
        this.window.show();
    }
};
//查看已经偿还的本金的信息情况窗体(保存，修改)
function initSeeHBFXWindow() {
    return Ext.create('Ext.window.Window',{
        height:document.body.clientHeight*0.65,
        width:document.body.clientWidth*0.7,
        title:'整改债务信息',
        maximizable: true,
        modal: true,
        closeAction: 'destroy',
        layout: 'fit',
        items: [initSeeHBForm()],
        buttons:['->',
            {
                xtype:'button',
                text:'保存',
                name: 'OK',
                hidden: IS_VIEW,
                handler:function (btn) {
                    //获取form中内容 并做校验
                    var form = btn.up('window').down('form#hbfxForm').getForm();
                    if (!form.isValid()) {
                        btn.setDisabled(false);
                        return;
                    }
                    var formValues = form.getValues();
                    //发送ajax保存信息
                    Ext.Ajax.request({
                        url:'savezfhbamt.action',
                        params:{
                            CHBJ_ID:formValues.CHBJ_ID,//偿还本金id
                            AD_CODE:formValues.AD_CODE,//区划编码
                            AG_ID:formValues.AG_ID,//单位id
                            AG_CODE:formValues.AG_CODE,//单位编码
                            AG_NAME:formValues.AG_NAME,//单位名称
                            CHBJ_AMT:formValues.CHBJ_AMT,//原币金额
                            CHBJ_AMT_RMB:formValues.CHBJ_AMT_RMB,//人民币
                            YDCH_ID:formValues.YDCH_ID,
                            CHZJ_MX_ID:formValues.CHZJ_MX_ID,//偿还本金明细id
                            ZJLY_ID:formValues.ZJLY_ID,//资金来源id
                            RATE:formValues.RATE,//汇率
                            ZQ_ID:formValues.ZQ_ID,//债券id
                            ZQ_NAME:formValues.ZQ_NAME,//债券名称
                            CHECK_STATUS:formValues.CHECK_STATUS,//支出状态
                            CHBJ_TYPE:2,//偿还本金类型
                            ZW_CODE:formValues.ZW_CODE,//债务编码
                            ZW_NAME:formValues.ZW_NAME,//债务名称
                            ZFDATE:formValues.HXDATE,//作废日期
                            ZW_ID:formValues.ZW_ID,//债务ID
                            button_name:button_name,//当前操作节点
                            wf_id:wf_id,//当前工作流id
                            node_code:node_code,//当前工作流节点
                            IS_VALID:formValues.IS_VALID,//有效标识
                            WF_STATUS:WF_STATUS,//当前状态001  002
                            REMARK:formValues.REMARK//备注
                        },
                        success:function (data) {
                            var respText = Ext.util.JSON.decode(data.responseText);
                            if (respText.success) {
                                Ext.toast({
                                    html: respText.msg,
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                btn.up('window').close();
                                //刷新表格
                                reloadGrid();
                            } else {
                                btn.setDisabled(false);
                                Ext.MessageBox.alert('提示', respText.message);
                            }
                        }
                    });

                }
            },
            {
                xtype:'button',
                text:'取消',
                name:'close',
                handler:function (btn) {
                    btn.up('window').close();
                }
            }
        ],
        listeners: {
            close: function () {
                IS_VIEW = false;
                seeHBFXWindow.window = null;
            }
        }
    });
}
//创建已有偿还本金查看Form
function initSeeHBForm() {
    return Ext.create('Ext.form.Panel',{
        itemId:'hbfxForm',
        layout:'vbox',
        defaults:{
            width:'100%',
            margin:'2 0 2 5'
        },
        defaultType:'textfield',
        items:[
            {
                xtype: 'fieldcontainer',
                width: '100%',
                layout: 'column',
                border: false,
                defaultType: 'textfield',
                fieldDefaults: {
                    labelWidth: 140,
                    columnWidth: .33,
                    labelAlign: 'right',
                    padding: '5 5 5 5'
                },
                items:[
                    {
                        xtype:'textfield',
                        name:'CHBJ_ID',
                        hidden:true
                    },
                    {
                        xtype:'textfield',
                        name:'YDCH_ID',
                        hidden:true
                    },
                    {xtype:'textfield',
                    name:"IS_VALID",//有效标识
                        hidden:true
                    },
                    {
                        xtype: 'textfield',
                        name: 'AG_ID',
                        hidden: true
                    }, {
                        xtype: 'textfield',
                        name: 'AD_CODE',
                        hidden: true
                    }, {
                        xtype: 'textfield',
                        name: 'AG_CODE',
                        hidden: true
                    },
                    {
                        xtype:'textfield',
                        name:'CHZJ_MX_ID',
                        hidden:true
                    },
                    {
                        xtype:'textfield',
                        name:'AD_NAME',
                        fieldCls: 'form-unedit',
                        columnWidth: .45,
                        readOnly:true,
                        hidden:false,
                        fieldLabel: '债务地区'
                    },

                    {
                        xtype: 'textfield',
                        name: 'AG_NAME',
                        readOnly: true,
                        fieldCls: 'form-unedit',
                        columnWidth: .45,
                        width: '40%',
                        emptyText: '',
                        fieldLabel: '债务单位'
                    },
                    {
                        xtype:'textfield',
                        name:'ZW_ID',
                        hidden:true
                    },
                    {
                        xtype:'textfield',
                        name:'ZW_CODE',
                        hidden:true
                    },
                    {
                        xtype: 'textfield',
                        name: 'ZW_NAME',
                        width: '40%',
                        readOnly: true,
                        columnWidth: .45,
                        fieldCls: 'form-unedit',
                        emptyText: '',
                        fieldLabel: '债务名称'
                    },
                    {
                        xtype: 'textfield',
                        name: 'ZWLB_NAME',
                        width: '40%',
                        readOnly: true,
                        columnWidth: .45,
                        fieldCls: 'form-unedit',
                        emptyText: '',
                        fieldLabel: '债务类别'
                    },
                    {
                        xtype: 'textfield',
                        name: 'WZ',
                        width: '40%',
                        readOnly: true,
                        columnWidth: .45,
                        fieldCls: 'form-unedit',
                        emptyText: '',
                        fieldLabel: '是否外债'
                    },
                    {
                        xtype:'textfield',
                        name:'CHBJ_DATE',
                        width:'40%',
                        readOnly:true,
                        fieldCls: 'form-unedit',
                        columnWidth: .45,
                        align:'right',
                        emptyText: '',
                        fieldLabel: '偿还日期'
                    },
                    {
                        xtype:'textfield',
                        name:'ZJLY_ID',
                        hidden:true
                    },
                    /*{
                        xtype:'textfield',
                        name:'RATE',
                        hidden:true
                    },*/
                    {
                        xtype:'textfield',
                        name:'ZQ_ID',
                        hidden:true
                    },
                    {
                        xtype:'textfield',
                        name:'ZQ_NAME',
                        hidden:true
                    },
                    {
                        xtype:'textfield',
                        name:'CHECK_STATUS',
                        hidden:true
                    },
                    {
                        xtype:'textfield',
                        name:'ZJLY_NAME',
                        width:'40%',
                        readOnly:true,
                        fieldCls: 'form-unedit',
                        columnWidth: .45,
                        align:'right',
                        emptyText: '',
                        fieldLabel: '偿还资金来源'
                    },
                    {
                        xtype:'textfield',
                        name:'CHBJ_TYPE',
                        readOnly:true,
                        width:'40%',
                        fieldCls:'form-unedit',
                        columnWidth: .45,
                        align:'right',
                        emptyText:'',
                        fieldLabel:'还款类型'
                    },
                    {
                        xtype:'numberFieldFormat',
                        name:'CHBJ_AMT',
                        readOnly:true,
                        fieldCls:'form-unedit-number',
                        columnWidth: .45,
                        emptyText:'',
                        fieldLabel:'原币金额',
                        width:'40%',
                        hidden:false
                    },
                    {
                        xtype:'numberFieldFormat',
                        name:'CHBJ_AMT_RMB',
                        width:'40%',
                        readOnly:true,
                        fieldCls:'form-unedit-number',
                        columnWidth: .45,
                        emptyText:'',
                        fieldLabel:'偿还金额(元 人民币)'
                    },
                    {
                        xtype:'numberFieldFormat',
                        name:'RATE',
                        width:'40%',
                        readOnly:true,
                        fieldCls:'form-unedit-number',
                        columnWidth: .45,
                        emptyText:'',
                        fieldLabel:'汇率'
                    },
                    {
                        xtype:'datefield',
                        format: 'Y-m-d',
                        columnWidth: .45,
                        name:'HXDATE',
                        value:Ext.util.Format.date(Ext.Date.add(new Date()),"Y-m-d"),
                        width: '40%',
                        allowBlank: false,
                        fieldLabel: '<span class="required">✶</span>整改日期'
                    },
                    {
                        xtype:'textfield',
                        columnWidth: .90,
                        name:'REMARK',
                        width: '40%',
                        allowBlank: true,
                        fieldLabel: '备注'
                    }
                ]
            }
        ]
    });
}
//
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
    if (button_status == 'back' ) {
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
    else if(button_status=='down'||button_status=='cancel'){//送审
        Ext.Msg.confirm('提示','请确认是否'+button_name+'"?',function (status) {
            if(status=="yes"){
                doWorkFlow_ajax(ids,btn,"");
            }
        });
    }
    if (button_status == 'cancel_sh' || button_status == 'cancel_th') {
        doWorkFlow_ajax(ids, btn, '');
    }
}

/**
 * 工作流发送ajax修改请求
 */
function doWorkFlow_ajax(ids, btn, text) {
    ///发送ajax请求，修改节点信息
    $.post("/doWorkFlowChbjZf.action", {
        workflow_direction: btn.name,//status状态
        button_name: button_name,//按钮名称
        button_status: button_status,
        wf_id:wf_id,
        node_code:node_code,
        WF_STATUS:WF_STATUS,
        ids: ids,
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: button_name+"成功",
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
//删除
function deleteCHDateData(btn) {
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
    Ext.Msg.confirm('提示','请确认是否删除?',function (status) {
        if(status=="yes"){
            HBFXDele_ajax(ids,btn,"");
        }else if(status=='no'){
            return;
        }
    });
}
//修改数据
function updatedata(btn) {
    // 获取选中汇总数据
    var records = DSYGrid.getGrid('hbfxzfGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条后再进行操作');
        return;
    }else if(records.length>1){
        Ext.Msg.alert('提示','请最多选择一条进行操作!');
        return;
    }
    seeHBFXWindow.show();
   var form= seeHBFXWindow.window.down('form#hbfxForm').getForm();
   form.setValues(records[0].data);
   form.findField("HXDATE").setValue(records[0].get("CHBJ_DATE"));
   form.findField("CHBJ_DATE").setValue(records[0].get("YUANCHBJ_DATA"));

  /*$.post("/savezfhbamt.action",{
      workflow_direction: btn.name,//status状态
      button_name: button_name,//按钮名称
      button_status: button_status,
      wf_id:wf_id,
      node_code:node_code,
      WF_STATUS:WF_STATUS,
      ids: ids
  },function (data) {
      if (data.success) {
          Ext.toast({
              html: data.msg,
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
      },"json");*/
}
/**
 * 删除信息
 */
function HBFXDele_ajax(ids, btn, text) {
    ///发送ajax请求，修改节点信息
    $.post("/savezfhbamt.action", {
        workflow_direction: btn.name,//status状态
        button_name: button_name,//按钮名称
        button_status: button_status,
        wf_id:wf_id,
        AD_CODE: AD_CODE,
        node_code:node_code,
        WF_STATUS:WF_STATUS,
        ids: ids
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
            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
        }
        //刷新表格
        reloadGrid();
    }, "json");
}
/**
 * 操作记录
 */
function operationRecord() {
    if(DSYGrid.getGrid('hbfxzfGrid')){
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

}




