<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>会计核算登记</title>
  </head>
<body>
	<div id="contentPanel" style="width: 100%;height:100%;">
</div>
</body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script src="/page/debt/zqgl/kjhsdj/kjhsdj.js"></script>
<script src="/page/debt/zqgl/kjhsdj/PopupGridForKjhsXM.js"></script>
<script>

	var is_showxmbtn=1;
	var AG_ID;
	var AG_CODE;

	var json_debt_jdfx = [
	    {"id": "0", "code": "借", "name": "0"},
	    {"id": "1", "code": "贷", "name": "1"}
	];
	
	var json_debt_kjkm = DebtEleTreeStoreDBTable('debt_v_ele_kjkm');
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
                    	if(AG_CODE==""||AG_CODE==null||AG_CODE.length!=6){
                    		Ext.Msg.alert('提示',"请先选择相关单位再进行此操作!");
                    		return;
                    	}
                        saveData(btn.name);
                    }
                 },
                 {
                    xtype: 'button',
                    text: '修改',
                    icon: '/image/sysbutton/edit.png',
                    handler: function (btn) {
                       	doUpdate(btn.name);
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
		                    		ID.push(record[i].data.VOU_ID);
		                    	}
			                    $.post("/kjhs/deleteKjhsbyId.action",{"ID":Ext.JSON.encode(ID)},function(data){
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
                    },
                    {
                    xtype: 'button',
                    text: '模板下载',
                    icon: '/image/sysbutton/download.png',
                    handler: function (btn) {
                    }
                 },
                 {
                    xtype: 'button',
                    text: 'excel导入',
                    icon: '/image/sysbutton/import.png',
                    handler: function (btn) {
                    }
                 },
                 {
                    xtype: 'button',
                    text: '数据包导入',
                    icon: '/image/sysbutton/import.png',
                    handler: function (btn) {
                        //判断是否已选择单位 如果没选择 直接返回
                        if(AG_CODE==""||AG_CODE==null||AG_CODE.length!=6){
                            Ext.Msg.alert('提示',"请先选择相关单位再进行此操作!");
                            return;
                        }
                        var form;
                        var path;
                        var AddfileForm = new Ext.FormPanel({
                            name: 'AddfileForm',
                            frame: false,
                            url: '/kjhs/importDataPack.action',
                            baseParams: {
                                // ZQRCODE: selected_zqr.get('code')
                            },
                            fileUpload: true,
                            width: 400,
                            autoDestroy: true,
                            defaults: {
                                margin: '5 10 5 10',
                                labelAlign: "right",
                                anchor: '95%',
                                labelWidth: 94
                            },

                            items: [{
                                xtype: 'filefield',
                                emptyText: '选择上传文件',
                                fieldLabel: '文件',
                                name: 'upload',
                                buttonText: '选择文件',
                                buttonConfig: {
                                    width: 90,
                                    icon: '/image/sysbutton/report.png'
                                },
                                validator: function (value) {
                                    var temp = value.split('.');
                                    var tmep1 = temp[temp.length - 1];
                                    var temp2 = tmep1.toLowerCase();
                                    var allowType = 'xml';
                                    form=Ext.ComponentQuery.query('form[name="AddfileForm"]')[0];
                                    if (allowType.indexOf(temp2) == -1) {
                                        Ext.MessageBox.alert('提示', '不允许选择该类型文件，请选择xml文件！');
                                        form.getForm().findField('upload').setRawValue('');
                                    } else {
                                        path=form.getForm().findField('upload').getValue();
                                        return true;
                                    }
                                }
                            }]
                        });

                        var AddfileWin = new Ext.Window({
                            title: '数据包导入',
                            width: 500,
                            height: 180,
                            layout: 'fit',
                            plain: true,
                            border: false,
                            buttonAlign: 'center',
                            items: AddfileForm,
                            buttons: ['->', {
                                text: '导入',
                                handler: function (btn) {

                                    if (AddfileForm.getForm().isValid()) {
                                        Ext.MessageBox.show({
                                            title: '请稍等...',
                                            msg: '文件上传中...',
                                            progressText: '',
                                            width: 300,
                                            progress: true,
                                            closable: false,
                                            animEl: 'loding'
                                        });
                                        AddfileForm.getForm().submit({
                                            params: {
                                                path: path,
                                                agcode: AG_CODE
                                            },
                                            success: function (form, action) {
                                                Ext.MessageBox.close();
                                                AddfileWin.close();
                                                reloadGrid();
                                            },
                                            failure: function (form, action) {
                                                var msg = action.result.message;
                                                Ext.MessageBox.show({
                                                    title: '提示',
                                                    msg: '导入失败:' + msg,
                                                    fn: function (btn) {
                                                    }
                                                });
                                            }
                                        });
                                    }
                                }
                            },
                                {
                                    text: '关闭',
                                    handler: function () {
                                        AddfileWin.close();
                                    }
                                }]
                        }).show();

                    }
                 },
                 '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    
];
	
var HEADER_MAIN = [
  
	{text: "主表主键ID", dataIndex: "VOU_ID", width:200, type: "string",hidden:true},
	{text: "单位名称", dataIndex: "agName", width:200, type: "string"},
	{text: "会计年度", dataIndex: "FISCAL_YEAR", width:200, type: "string"},
	{text: "会计期间", dataIndex: "ACCT_PERIOD", width:200, type: "string"},
	{text: "帐套编号", dataIndex: "ACCT_SET_CODE", width:200, type: "string",hidden:true},
	{text: "凭证类型", dataIndex: "AGENCY_ACCT_VOUCHER_TYPE", width:200, type: "string"},
	{text: "记账凭证号", dataIndex: "VOUCHER_NO", width:200, type: "string"},
	{text: "记账人", dataIndex: "POSTER", width:200, type: "string"},
	{text: "记账日期", dataIndex: "POSTER_DATE", width:200, type: "string"},
	{text: "制单人", dataIndex: "INPUTER", width:200, type: "string"},
	{text: "制单日期", dataIndex: "INPUTER_DATE", width:200, type: "string"},
	{text: "财务负责人", dataIndex: "FI_LEADER", width:200, type: "string",hidden:true},
	{text: "凭证摘要	", dataIndex: "VOUCHER_ABS", width:200, type: "string"},
	{text: "创建时间", dataIndex: "create_time", width:200, type: "string",hidden:true}
	];
		
var HEADER_MX = [
		{text: "明细主键ID", dataIndex: "VOU_DET_ID", width:200, type: "string",hidden:true},
		{text: "借贷方向", dataIndex: "DR_CR", width:200, type: "string",store:DebtEleStore(json_debt_jdfx),
			 'renderer': function (value) {
	                var record = DebtEleStore(json_debt_jdfx).findRecord('id', value, 0, false, true, true);
	                return record != null ? record.get('code') : value;
                }
		},
		{text: "会计科目", dataIndex: "GOV_ACCT_CLS_NAME", width:200, type: "string",
			store:json_debt_kjkm,
				 'renderer': function (value) {
		                var record = json_debt_kjkm.findRecord('id', value, 0, false, true, true);
		                return record != null ? record.get('name') : value;
	                }},
		{text: "金额", dataIndex: "AMT", width:200, type: "float"},
		{text: "摘要", dataIndex: "VOU_DET_DESC", width:200, type: "string"},
		{text: "项目", dataIndex: "PU_NAME", width:200, type: "string"},
		{text: "建设状态", dataIndex: "VOU_STATUS", width:200, type: "string",hidden:true},
		{text: "资产代码", dataIndex: "ASSET_CODE", width:200, type: "string"},
		];

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
        	 initContentTree({
                    areaConfig: {
                        params: {
                            CHILD:1//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    }
                }),//初始化左侧树
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
    var headerJson = HEADER_MAIN;
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 5,
        dataUrl:"/kjhs/getKjhsMainByView.action",
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
        	/* {
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
        } */
        ],
        listeners: {
	        itemclick: function (self, record) {
					DSYGrid.getGrid('mxGrid').getStore().getProxy().extraParams['mainId'] = record.get('VOU_ID');
                    DSYGrid.getGrid('mxGrid').getStore().loadPage(1);
	                }
        }
    });
}

function initMxGrid(){
    var headerJson = HEADER_MX;
    return DSYGrid.createGrid({
        itemId: 'mxGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 5,
        dataUrl:"/kjhs/getKjhsMxById.action",
        pageConfig:{
        	enablePage: false
        },
        features: [{
            ftype: 'summary'
        }],

        checkBox: false,
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
	store.getProxy().extraParams['adCode'] = AD_CODE;
    store.getProxy().extraParams['agCode'] = AG_CODE;
    store.removeAll();
    mxStore.removeAll();
    store.loadPage(1);
}
/**
*录入按钮
*/
function saveData(btnName){
	initWindow_kjhstb(btnName).show();
	var window_input = Ext.ComponentQuery.query('window#window_kjhsdjltb')[0];
	window_input.down('form').getForm().setValues({"agName":AG_NAME});
}

/**
*修改按钮
*/
function doUpdate(btnName){
	var record=DSYGrid.getGrid('contentGrid').getSelection();
	if(record.length!=1){
		Ext.Msg.alert('提示',"请选择一条数据!");
		return;
	}
	$.post("/kjhs/getKjhsMxById.action",{mainId:record[0].data.VOU_ID},function(data){
		AG_ID=Ext.util.JSON.decode(data).list[0].agId;
		AG_CODE=Ext.util.JSON.decode(data).list[0].PU_UNI_CODE;
		initWindow_kjhstb(btnName).show();
		var window_input = Ext.ComponentQuery.query('window#window_kjhsdjltb')[0];
		window_input.down('form').getForm().setValues(record[0].data);
		DSYGrid.getGrid('kjhsmxGrid').insertData(null,Ext.util.JSON.decode(data).list[0]);
	});
}

function initWindow_kjhstb(btnName) {
    return Ext.create('Ext.window.Window', {
        itemId: 'window_kjhsdjltb', // 窗口标识
        name: 'kjhsdj',
        title: '会计核算信息登记', // 窗口标题
        width: document.body.clientWidth * 0.75, //自适应窗口宽度
        height: document.body.clientHeight * 0.8, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: initWindow_input_kjhsdj_from(),
        buttons: [
        	{
                text: '增行',
                handler: function (btn) {
                    var grid = DSYGrid.getGrid('kjhsmxGrid');
                    grid.insertData(null,{IS_QEHBFX: 1});
                }
            },
            {
                text: '删行',
                handler: function (btn) {
                	var grid = DSYGrid.getGrid('kjhsmxGrid');
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
                    saveKjhsInfo(btn,btnName);
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

function initWindow_input_kjhsdj_from(){
    return Ext.create('Ext.form.Panel', {
        name: 'fxsglForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        scrollable:true,
        padding: '0 5 0 5',
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldcontainer',
                style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
                layout: 'column',
                anchor:'100% 33%',
                border: false,
                flex:2,
                defaultType: 'textfield',
                fieldDefaults: {
                    labelWidth: 110,
                    columnWidth: .333,
                    labelAlign: 'left',
                    margin: '2 0 2 5'
                },
                items: [
                	{
                        fieldLabel: '主单主键ID',
                        name: 'VOU_ID',
                        xtype: 'textfield',
                        hidden:true,
                        editable: false, //禁用编辑
                        columnWidth: .33
                    },
                    {
                        fieldLabel: ' 单位名称',
                        name: 'agName',
                        xtype: 'textfield',
                        editable: false, //禁用编辑
                        readOnly: true,
                     	fieldStyle: 'background:#E6E6E6',
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>会计年度（年）',
                        name: 'FISCAL_YEAR',
                        xtype: 'combobox',
                        editable: false, //禁用编辑
                        store:DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2010' and code <= '2030'"}),
                        displayField: "code",
				        valueField: "id",
				        value: new Date().getFullYear(),
                        allowBlank: false,
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>会计期间',
                        name: 'ACCT_PERIOD',
                        xtype: 'textfield',
                        allowBlank: false,
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>帐套编号',
                        name: 'ACCT_SET_CODE',
                        xtype: 'textfield',
                        allowBlank: true,
                        hidden:true,
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>凭证类型',
                        name: 'AGENCY_ACCT_VOUCHER_TYPE',
                        xtype: 'textfield',
                        allowBlank: false,
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>记账凭证号',
                        name: 'VOUCHER_NO',
                        xtype: 'textfield',
                        allowBlank: false,
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>记账人',
                        name: 'POSTER',
                        xtype: 'textfield',
                        allowBlank: false,
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>记账日期',
                        name: 'POSTER_DATE',
                        xtype: 'datefield',
                        allowBlank: false,
                        format: 'Y-m-d',
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>制单人',
                        name: 'INPUTER',
                        xtype: 'textfield',
                        allowBlank: false,
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>制单日期',
                        name: 'INPUTER_DATE',
                        xtype: 'datefield',
                        format: 'Y-m-d',
                        allowBlank: false,
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>财务负责人',
                        name: 'FI_LEADER',
                        xtype: 'textfield',
                        allowBlank: true,
                        hidden:true,
                        columnWidth: .33
                    },
                    {
                        fieldLabel: '<span class="required">✶</span>凭证摘要',
                        name: 'VOUCHER_ABS',
                        xtype: 'textarea',
                        allowBlank: false,
                        columnWidth:1,
                        columnheight:3
                    },
                    {
                        fieldLabel: '创建时间',
                        name: 'CREATE_TIME',
                        xtype: 'textfield',
                        hidden:true,
                        columnWidth: .5
                    }
                ],
            },{
              xtype: 'fieldset',
              title: '项目信息填报明细',
              anchor: '100% 67%',
              layout: 'fit',
              collapsible: false,
              items: [
                  initWindow_input_kjhsmx_grid()
              ]
       			}
        ]
    });
};
     
 function initWindow_input_kjhsmx_grid(){
 	var headerJson = [
 					{text: "明细主键ID", dataIndex: "VOU_DET_ID", width:200,editor: 'textfield',type: 'string',hidden:true},
 					{text: "借贷方向", dataIndex: "DR_CR", width:200,editor: 'string',
                          type: 'string',
                                editor: {
					                xtype: 'combobox',
					                name: "jd_id",
					                valueField: 'id',
					                displayField: 'code',
					                editable: false,
					                store:DebtEleStore(json_debt_jdfx),
					            },
					            'renderer': function (value) {
				                var record = DebtEleStore(json_debt_jdfx).findRecord('id', value, 0, false, true, true);
				                return record != null ? record.get('code') : value;
			                }},
 					{text: "会计科目", dataIndex: "GOV_ACCT_CLS_NAME", width:200,editor: 'treecombobox',
 					type: 'string',
 						editor: {
					                xtype: 'treecombobox',
					                name: "kjkm_id",
					                valueField: 'id',
					                displayField: 'name',
					                editable: false,
                                    selectModel: 'leaf',
					                store:json_debt_kjkm,
					            },
					            'renderer': function (value) {
				                var record = json_debt_kjkm.findRecord('id', value, 0, false, true, true);
				                return record != null ? record.get('name') : value;
			                }},
 					{text: "金额", dataIndex: "AMT", width:200,editor: 'textfield',type: 'float'},
 					{text: "摘要", dataIndex: "VOU_DET_DESC", width:200,editor: 'textfield',type: 'string'},
 					{text: "项目", dataIndex: "PU_NAME", width:200,type: 'string',
 						editor: {
					                xtype: 'PopupGridForKjhsXM',
					                name: "XM_ID",
					                valueField: 'XM_ID',
					                displayField: 'XM_NAME',
					                editable: false,
					                store:getJSXMStore('qyz_zwdj_getRZXM.action?AG_ID=' + AG_ID),
					            }
					            
                	},
                	{text: "建设状态", dataIndex: "VOU_STATUS", width:200,editor: 'textfield',type: 'string',hidden:true},
                	{text: "资产代码", dataIndex: "ASSET_CODE", width:200,editor: 'textfield',type: 'string'},
                	];
 	return DSYGrid.createGrid({
     itemId: 'kjhsmxGrid',
     headerConfig: {
         headerJson: headerJson,
         columnAutoWidth: false
     },
     flex:6,
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
                    },
                }
            }
        ],
     checkBox: true,
     border: false,
     height: '100%',
 });
};
</script>
</html>
