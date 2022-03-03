<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>分销商管理</title>
  </head>
<body>
	<div id="contentPanel" style="width: 100%;height:100%;">
</div>
</body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script src="/page/debt/zqgl/zqfxgl/fxsgl/fxsgl.js"></script>
<script>
var store_xydj = DebtEleStoreDB('DEBT_XYDJ');//信用等级
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
                            saveData(btn);
                        }
                     },
                     {
                        xtype: 'button',
                        text: '修改',
                        name:'update',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                           	doUpdate(btn);
                        }
                     },
                     {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            doDelete();
                        }
                     },
	];
	
	    //风险化解债券信息
    var HEADER_FXSGL = [
    	{text: "主键id", dataIndex: "ID", width:200, type: "string",hidden:true},
    	{text: "排序号", dataIndex: "PXH", width:200, type: "string"},
		{text: "分销商机构代码", dataIndex: "FXSJGDM", width:200, type: "string"},
		{text: "分销商机构名称", dataIndex: "FXSJGMC", width:200, type: "string"},
		{text: "信用等级ID", dataIndex: "XYDJID", width:200, type: "string",hidden:true},
		{text: "信用等级", dataIndex: "XYDJ", width:200, type: "string"},
		{text: "收款账户", dataIndex: "SKZHU", width:200, type: "string"},
		{text: "收款账号", dataIndex: "SKZHAO", width:200, type: "string"},
		{text: "开户银行", dataIndex: "KHYH", width:200, type: "string"},
		{text: "联系人", dataIndex: "LXR", width:200, type: "string"},
		{text: "联系电话", dataIndex: "LXDH", width:200, type: "string"}];
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
                initContentGrid()
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = HEADER_FXSGL;
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 5,
            dataUrl:"/fxsgl/getFxsglAll.action",
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
                emptyText: '请输入分销商机构代码/机构名称',
                listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            reloadGrid();
                        }
                    }
            },
            ],
        });
    }

/**
*录入按钮
*/
function saveData(btn){
	initWindow_fxsgltb(btn.name).show();
}
/**
*修改方法
*/
function doUpdate(btn){
	ID=DSYGrid.getGrid('contentGrid').getSelection()[0].get('ID');
	$.post("/fxsgl/getFxsjgById.action",{"ID":ID},function(data){
		initWindow_fxsgltb(btn.name).show();
		//弹出填报页面，并写入债券信息以及明细信息
        var window_input = Ext.ComponentQuery.query('window#window_fxsgltb')[0];
		window_input.down('form').getForm().setValues(Ext.util.JSON.decode(data).list);
	});
}

/**
*删除方法
*/
function doDelete(){
	Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                    		if (btn_confirm === 'yes') {
								var record=DSYGrid.getGrid('contentGrid').getSelection();
							                    	var ID=[];
							                    	for(var i=0;i<record.length;i++){
							                    		ID.push(record[i].data.ID);
							                    	}
								$.post("/fxsgl/delFxsjgById.action",{"ID":Ext.JSON.encode(ID)},function(data){
									if(Ext.util.JSON.decode(data).success==true){
										 Ext.toast({html: '<div style="text-align: center;">删除成功!</div>'});
									}else{
										Ext.Msg.alert('提示', "删除失败！" + Ext.util.JSON.decode(data).message);
									}
									reloadGrid();
								});
	}
});
}
/**
*刷新页面方法
*/
function reloadGrid(){
	var grid = DSYGrid.getGrid('contentGrid');
	var store = grid.getStore();
    store.loadPage(1);
}
function initWindow_fxsgltb(btnName) {
    return Ext.create('Ext.window.Window', {
        itemId: 'window_fxsgltb', // 窗口标识
        name: 'fxsgllr',
        title: '分销商机构维护', // 窗口标题
        width: document.body.clientWidth * 0.5, //自适应窗口宽度
        height: document.body.clientHeight * 0.4, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: initWindow_fxsgltb_contentForm(),
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    saveFxsglInfo(btnName,btn);
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

/**
 * 初始化债券信息填报表单
 */
function initWindow_fxsgltb_contentForm() {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            anchor: '100%',
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                anchor: '100%',
                layout: 'hbox',
                items: [
                   
                ]
            },
            initWindow_input_fxsgl_from()
        ]
    });
}

    /**
     *生成债券需求
     */
    function initWindow_input_fxsgl_from(){
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
                    anchor:'100% 100%',
                    border: false,
                    defaultType: 'textfield',
                    fieldDefaults: {
                        labelWidth: 130,
                        columnWidth: .333,
                        labelAlign: 'left',
                        margin: '2 5 2 5'
                    },
                    items: [
                    	{
                            fieldLabel: '主键ID',
                            name: 'ID',
                            xtype: 'textfield',
                            columnWidth: .5,
                            hidden:true
                        },
                        {
                            fieldLabel: '<span class="required">✶</span> 分销商机构代码',
                            name: 'FXSJGDM',
                            xtype: 'textfield',
                            allowBlank: false,
                            columnWidth: .5
                        },
                        {
                            fieldLabel: '<span class="required">✶</span>分销商机构名称',
                            name: 'FXSJGMC',
                            xtype: 'textfield',
                            allowBlank: false,
                            columnWidth: .5
                        },
                        {
                            fieldLabel: '<span class="required">✶</span>信用等级',
                            name: 'XYDJ',
                            xtype: 'combobox',
                            allowBlank: false,
                            columnWidth: .5,
                            store: store_xydj,
				            displayField: "name",
                            valueField: "id",
                            selectModel: "leaf",
                        },
                        {
                            fieldLabel: '联系电话',
                            name: 'LXDH',
                            xtype: 'textfield',
                            columnWidth: .5
                        },
                        {
                            fieldLabel: '联系人',
                            name: 'LXR',
                            xtype: 'textfield',
                            columnWidth: .5
                        },
                        {
                            fieldLabel: '收款账户',
                            name: 'SKZHU',
                            xtype: 'textfield',
                            columnWidth: .5
                        },
                        {
                            fieldLabel: '收款账号',
                            name: 'SKZHAO',
                            xtype: 'textfield',
                            columnWidth: .5
                        },
                        {
                            fieldLabel: '开户银行',
                            name: 'KHYH',
                            xtype: 'textfield',
                            columnWidth: .5
                        },
                        {
                            fieldLabel: '排序号',
                            name: 'PXH',
                            xtype: 'textfield',
                            columnWidth: .5
                        },
                    ]
                }
            ]
        });
    }
</script>
</html>
