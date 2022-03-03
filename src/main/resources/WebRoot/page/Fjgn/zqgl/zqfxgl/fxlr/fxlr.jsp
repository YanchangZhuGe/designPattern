<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>承销机构中标额分销录入</title>
  </head>
<body>
	<div id="contentPanel" style="width: 100%;height:100%;">
</div>
</body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script src="/page/debt/zqgl/zqfxgl/fxlr/fxlr.js"></script>
<script>

var fxjgStore = DebtEleStoreTable('debt_v_cxs_fxjg');
 /**
  * 页面初始化
  */
 $(document).ready(function () {
    initContent();

});

var main_button=[
				{
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        reloadGrid();
                    }
                 },
                 {
                    xtype: 'button',
                    text: '录入',
                    name:'save',
                    icon: '/image/sysbutton/save.png',
                    handler: function (btn) {
                        saveData(btn.name);
                    }
                 },
                 {
                    xtype: 'button',
                    text: '修改',
                    icon: '/image/sysbutton/edit.png',
                    handler: function (btn) {
                       	doUpdate();
                    }
                 },
                 {
                    xtype: 'button',
                    text: '删除',
                    icon: '/image/sysbutton/delete.png',
                    handler: function (btn) {
                    	Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                    		if (btn_confirm === 'yes') {
		                    	var record=DSYGrid.getGrid('contentGrid').getSelection();
		                    	var ID=[];
		                    	for(var i=0;i<record.length;i++){
		                    		ID.push(record[i].data.ZQFXID);
		                    	}
			                    $.post("/fxlr/deleteFxlrInfo.action",{"ID":Ext.JSON.encode(ID)},function(data){
			                    	if(Ext.util.JSON.decode(data).success==true){
											 Ext.toast({html: '<div style="text-align: center;">删除成功!</div>'});
											 reloadGrid();
										}else{
											Ext.Msg.alert('提示', "删除失败！" + Ext.util.JSON.decode(data).message);
										}
			                    });
                    		}
                    	});
                    }
                    }
                    
];
	
var HEADER_CXJG = [
  
	{text: "债券类型", dataIndex: "ZQLBNAME", width:200, type: "string"},
	{text: "债券名称", dataIndex: "ZQNAME", width:200, type: "string"},
	{text: "债券代码", dataIndex: "ZQCODE", width:200, type: "string"},
	{text: "债券简称", dataIndex: "ZQJC", width:200, type: "string"},
	{text: "发行批次", dataIndex: "FXPCNAME", width:200, type: "string"},
	{text: "承销商ID", dataIndex: "CXJGID", width:200, type: "string",hidden:true},
	{text: "承销商代码", dataIndex: "CXJGCODE", width:200, type: "string"},
	{text: "承销商名称", dataIndex: "CXJGNAME", width:200, type: "string"},
	{text: "中标金额（元）", dataIndex: "ZBAMT", width:200, type: "float"},
	{text: "剩余可分销金额（元）", dataIndex: "SYKFXAMT", width:200, type: "float"}];
		
var HEADER_FXLR = [
		{text: "分销主键ID", dataIndex: "ZQFXID", width:200, type: "string",hidden:true},
		{text: "债券代码", dataIndex: "ZQCODE", width:200, type: "string"},
		{text: "债券类型", dataIndex: "ZQLBNAME", width:200, type: "string"},
		{text: "债券名称", dataIndex: "ZQNAME", width:200, type: "string"},
		{text: "债券简称", dataIndex: "ZQJC", width:200, type: "string"},
		{text: "发行批次", dataIndex: "FXPCNAME", width:200, type: "string"},
		{text: "承销商代码", dataIndex: "CXJGCODE", width:200, type: "string"},
		{text: "承销商名称", dataIndex: "CXJGNAME", width:200, type: "string"},
		{text: "中标金额（元）", dataIndex: "ZBAMT", width:200, type: "string"}];

var FXLR_MX = [	{text: "分销商机构代码", dataIndex: "fxjgCode", width:200, type: "string"},
				{text: "分销商机构名称", dataIndex: "fxjgName", width:200, type: "string"},
				{text: "信用等级 ", dataIndex: "xydjName", width:200, type: "string"},
				{text: "分销金额（元）", dataIndex: "FXJE", width:200, type: "string"}];
/**
* 加载页面布局
*/
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        height: '100%',
        renderTo: 'contentPanel',
        border: false,
        dockedItems: [
            {
                xtype: 'toolbar',
                dock: 'top',
                itemId: 'contentPanel_toolbar',
                items: main_button
            }
        ],
        items: [
            initContentRightPanel()//初始化右侧表格
        ]
    });
}
    
/**
 * 初始化右侧panel，放置1个表格
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
        items: [
            initContentGrid(),
            initMxGrid()
        ]
    });
}
/**
 * 初始化主表格
 */
function initContentGrid() {
    var headerJson = HEADER_FXLR;
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 5,
        dataUrl:"/fxlr/getZqfxMain.action",
        pageConfig:{
        	enablePage: true
        },
        features: [{
            ftype: 'summary'
        }],

        checkBox: true,
        border: false,
        height: '100%',
        tbar:[
        	{
            xtype: "textfield",
            fieldLabel: '模糊查询',
            name: 'contentGrid_search',
            width: 300,
            hidden: false,
            labelWidth: 60,
            labelAlign: 'left',
            emptyText: '请输入承销商机构代码/机构名称',
            listeners: {
		        		change: function (self, newValue) {
						//刷新当前表格
	                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
	                            reloadGrid();
		                }
     				}
        }
        ],
        listeners: {
	        itemclick: function (self, record) {
					DSYGrid.getGrid('mxGrid').getStore().getProxy().extraParams['ZQFXID'] = record.get('ZQFXID');
                    DSYGrid.getGrid('mxGrid').getStore().loadPage(1);
	                }
        }
    });
}

function initMxGrid(){

    var headerJson = FXLR_MX;
    return DSYGrid.createGrid({
        itemId: 'mxGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 5,
        dataUrl:"/fxlr/getZqfxMxData.action",
        pageConfig:{
        	enablePage: false
        },
        features: [{
            ftype: 'summary'
        }],

        checkBox: true,
        border: false,
        height: '100%',
    });
}

/**
*刷新表格按钮
*/
function reloadGrid(){
	var grid = DSYGrid.getGrid('contentGrid');
	var mxgrid = DSYGrid.getGrid('mxGrid');
	var store = grid.getStore();
	var mxStore = mxgrid.getStore();
    store.loadPage(1);
    mxStore.loadPage(1);
}
/**
*录入按钮
*/
function saveData(btnName){
	initWindow_fxlrtb(btnName).show();
}

/**
*修改按钮
*/
function doUpdate(){
	var record=DSYGrid.getGrid('contentGrid').getSelection();
	if(record.length!=1){
		Ext.Msg.alert('提示',"请选择一条数据!");
		return;
	}
	var param = {
					"ZQFXID":record[0].data.ZQFXID
				};
	$.post("/fxlr/getFxData.action",param,function(data){
		initWindow_fxsgltb("update").show();
        var window_input = Ext.ComponentQuery.query('window#window_fxsgltb')[0];
		window_input.down('form').getForm().setValues(Ext.util.JSON.decode(data).list.main[0]);
		DSYGrid.getGrid('fxsGrid').insertData(null,Ext.util.JSON.decode(data).list.dtl);
		reloadGrid();
	});
}

function initWindow_fxlrtb(btnName) {
    return Ext.create('Ext.window.Window', {
        itemId: 'window_fxlrtb', // 窗口标识
        name: 'fxlr',
        title: '承销机构选择', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.6, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: initWindow_input_fxlr_grid(),
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                	var record=DSYGrid.getGrid('cxjgGrid').getSelection()[0];
                	if(record==undefined){
                		Ext.Msg.alert('提示', "请选择1条数据!");
                	}
                	initWindow_fxsgltb(btnName).show();
                	var window_input = Ext.ComponentQuery.query('window#window_fxsgltb')[0];
					window_input.down('form').getForm().setValues(record.data);
					btn.up('window').close();
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

function initWindow_input_fxlr_grid(){
    var headerJson = HEADER_CXJG;
    return DSYGrid.createGrid({
        itemId: 'cxjgGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 5,
        dataUrl:"/fxlr/getCxjgAll.action?SET_YEAR="+new Date().getFullYear(),
        pageConfig:{
        	enablePage: false
        },
        features: [{
            ftype: 'summary'
        }],

        checkBox: false,
        border: false,
        height: '100%',
        tbar:[
        {
         xtype: "combobox",
         name: "SET_YEAR",
         store: DebtEleStore(json_debt_year),
         displayField: "name",
         valueField: "id",
         value: new Date().getFullYear(),
         fieldLabel: '发行年度',
         editable: false, //禁用编辑
         labelWidth: 100,
         width: 220,
         labelAlign: 'right',
         emptyText: '请输入发行年度',
            listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            var grid = DSYGrid.getGrid('cxjgGrid');
							var store = grid.getStore();
						    store.loadPage(1);
                        }
                        
                    }
        },
        {
            xtype: "combobox",
            fieldLabel: '债券类型',
           	store: DebtEleTreeStoreDB('DEBT_ZQLB'),
            name: 'zqlb',
            displayField: "name",
            valueField: "id",
            width: 300,
            hidden: false,
            labelWidth: 60,
            labelAlign: 'left',
            emptyText: '请输入债券类型',
            listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            var grid = DSYGrid.getGrid('cxjgGrid');
							var store = grid.getStore();
						    store.loadPage(1);
                        }
                    }
        },
        {
            xtype: "textfield",
            fieldLabel: '承销商名称',
            name: 'cxsName',
            width: 300,
            hidden: false,
            labelWidth: 60,
            labelAlign: 'left',
            emptyText: '请输入承销商',
            listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            var grid = DSYGrid.getGrid('cxjgGrid');
							var store = grid.getStore();
						    store.loadPage(1);
                        }
                    }
        },
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            name: 'mhcx',
            width: 300,
            hidden: false,
            labelWidth: 60,
            labelAlign: 'left',
            emptyText: '请输入债券名称/债券代码',
            listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            var grid = DSYGrid.getGrid('cxjgGrid');
							var store = grid.getStore();
						    store.loadPage(1);
                        }
                    }
        },
        ],
        listeners: {
        }
    });
};

function initWindow_fxsgltb(btnName) {
    return Ext.create('Ext.window.Window', {
        itemId: 'window_fxsgltb', // 窗口标识
        name: 'fxsgllr',
        title: '分销商金额录入', // 窗口标题
        width: document.body.clientWidth * 0.6, //自适应窗口宽度
        height: document.body.clientHeight * 0.75, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: initWindow_input_fxslr_from(),
        buttons: [
        	{
                text: '增行',
                handler: function (btn) {
                    var grid = DSYGrid.getGrid('fxsGrid');
                    grid.insertData(null,{IS_QEHBFX: 1});
                }
            },
            {
                text: '删行',
                handler: function (btn) {
                	var grid = DSYGrid.getGrid('fxsGrid');
                	var store=grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            },
            {
                text: '保存',
                handler: function (btn) {
                    saveFxlrInfo(btn,btnName);
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
};

function initWindow_input_fxslr_from(){
    return Ext.create('Ext.form.Panel', {
        name: 'fxsglForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        padding: '0 5 0 5',
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldcontainer',
                style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
                layout: 'column',
                anchor:'100% 24%',
                border: false,
                flex:2,
                defaultType: 'textfield',
                fieldDefaults: {
                    labelWidth: 160,
                    columnWidth: .333,
                    labelAlign: 'left',
                    margin: '2 5 2 5'
                },
                items: [
                	{
                        fieldLabel: '债券分销主键ID',
                        name: 'ZQFXID',
                        xtype: 'textfield',
                        hidden:true,
                        editable: false, //禁用编辑
                        columnWidth: .5
                    },
                    {
                        fieldLabel: '债券名称',
                        name: 'ZQNAME',
                        xtype: 'textfield',
                        editable: false, //禁用编辑
                        fieldCls: 'form-unedit',
                        columnWidth: .5
                    },
                    {
                        fieldLabel: '承销机构名称',
                        name: 'CXJGNAME',
                        xtype: 'textfield',
                        editable: false, //禁用编辑
                        fieldCls: 'form-unedit',
                        columnWidth: .5
                    },
                    {
                        fieldLabel: '中标金额(元)',
                        name: 'ZBAMT',
                        xtype: 'textfield',
                        editable: false, //禁用编辑
                        fieldCls: 'form-unedit',
                        columnWidth: .5
                    },
                    {
                        fieldLabel: '剩余可分销金额',
                        name: 'SYKFXAMT',
                        xtype: 'textfield',
                        editable: false, //禁用编辑
                        fieldCls: 'form-unedit',
                        columnWidth: .5
                    },
                    {
                        fieldLabel: '债券ID',
                        name: 'ZQID',
                        xtype: 'textfield',
                        hidden:true,
                        columnWidth: .5
                    },
                    {
                        fieldLabel: '承销商机构代码',
                        name: 'CXJGCODE',
                        xtype: 'textfield',
                        hidden:true,
                        columnWidth: .5
                    },
                    {
                        fieldLabel: '承销商机构ID',
                        name: 'CXJGID',
                        xtype: 'textfield',
                        hidden:true,
                        columnWidth: .5
                    }
                ],
            },{
              xtype: 'fieldset',
              title: '分销商机构信息',
              anchor: '100% 76%',
              layout: 'fit',
              collapsible: false,
              items: [
                  initWindow_input_cxsjg_grid()
              ]
       			}
        ]
    });
};
     
 function initWindow_input_cxsjg_grid(){
 	var headerJson = [{text: "分销商机构名称", dataIndex: "FXSJGID", width:300, type: 'string',value:'code',
					 	editor: {
					                xtype: 'combobox',
					                displayField: 'name',
					                editable: false,
					                valueField: 'id',
					                store:fxjgStore,
					            },
 						'renderer': function (value) {
					                var record = fxjgStore.findRecord('id', value, 0, false, true, true);
					                return record != null ? record.get('name') : value;}
					 },
 						 
		{text: "分销金额（元）", dataIndex: "FXJE", width:200,editor: 'textfield',type: "float"}];
 	return DSYGrid.createGrid({
     itemId: 'fxsGrid',
     headerConfig: {
         headerJson: headerJson,
         columnAutoWidth: false
     },
     flex:8,
     data: [],
     pageConfig:{
     	enablePage: false
     },
     features: [{
         ftype: 'summary'
     }],
	plugins:[
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'cxjgCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                    },
                    'validateedit': function (editor, context) {
                    },
                    'edit': function (editor, context) {
                    }
                }
            }
        ],
     checkBox: true,
     border: false,
     height: '100%',
     listeners: {
     
     }
 });
};
</script>
</html>
