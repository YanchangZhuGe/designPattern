var wf_id = getQueryParam("wf_id");//当前流程id
var node_code = getQueryParam("node_code");//当前节点id
var node_type = getQueryParam("node_type");//当前节点标识
ZC_TYPE = '1' ;
var node_name = "";//当前节点名称
var button_name = '';//当前操作按钮名称
var button_status = '';//当前操作按钮的name，标识按钮状态
var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
var ZQLB_ID = ''; // 定义债券类型
//var v_child = '1';
// 定义支出单ID
var ZCD_ID = '';
if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
    WF_STATUS = '001';
}
var json_zt;//状态json
if (node_code == '1') {
    node_name = 'lr'
    btn_title = '送审';
    json_zt = json_debt_zt0;
} else if (node_code == '2') {
    node_name = 'sh'
    btn_title = '审核';
    json_zt = json_debt_zt2_2;
}
/*
 * 通用按钮配置
 */
var json_common = {
	zflr:{
		items:{
			'001':[
			    {
			    	xtype:'button',
			    	text:'查询',
			    	name:'search',
			    	icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
			    },
			    {
			    	xtype: 'button',
			    	text: '录入',
			    	name: 'btn_insert',
			    	icon: '/image/sysbutton/add.png',
			    	handler: function (btn) {
			    		button_name = btn.text;
                        button_status = btn.name;
                        var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                        AD_CODE = treeArray[0].getSelection()[0].get('code');
                        AD_NAME = treeArray[0].getSelection()[0].get('text');
                        if (treeArray[1].getSelection()[0] != undefined) {
                            AG_CODE = treeArray[1].getSelection()[0].get('code');
                            AG_ID = treeArray[1].getSelection()[0].get('id');
                            AG_NAME = treeArray[1].getSelection()[0].get('text');
                        }
                        //弹出债券选择框
                        initWindow_select_zfxm().show() ;
			    	}
			    },
			    {
                    xtype: 'button',
                    text: '修改',
                    name: 'btn_update',
                    icon: '/image/sysbutton/edit.png',
                    handler: function (btn) {
                    	var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            return;
                        }
                        //修改全局变量的值
                        button_name = btn.text;
                        button_status = btn.name;
                        ZCD_ID = records[0].get('ZC_ID');
                        initZfxxData_update({
                            editable: true,
                            ZCD_ID: records[0].get('ZC_ID')
                        })
                    }
			    },
			    {
			    	xtype: 'button',
                    text: '删除',
                    name: 'btn_delete',
                    icon: '/image/sysbutton/delete.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        button_status = btn.name;
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length < 1) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            return;
                        }
                        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                            if (btn_confirm == 'yes') {
                                button_name = btn.text;
                                var ids = [];
                                for (var i in records) {
                                    ids.push(records[i].get("ZC_ID"));
                                }
                                //发送ajax请求，删除数据
                                $.post("/deleteFxdfZfzqZqzcGrid.action", {
                                    ids: ids,
                                    wf_id: wf_id,
                                    WF_STATUS: WF_STATUS,
                                    AD_CODE:AD_CODE,
                                    button_name:button_name
                                }, function (data) {
                                    if (data.success) {
                                        Ext.toast({
                                            html: button_name + "成功！",
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
                        });
                    }
			    },
			    {
			    	xtype: 'button',
                    text: '送审',
                    name: 'down',
                    icon: '/image/sysbutton/audit.png',
                    handler: function (btn) {
                        button_name = btn.text;
                        button_status = btn.name;
                        doWorkFlow(btn);
                    }
			    },
			    {
			    	xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        oprationRecord();
                    }
			    },
			    '->',
			    initButton_OftenUsed(),
                initButton_Screen()
			],
			'002':[
				{
				    xtype: 'button',
				    text: '查询',
				    name: 'search',
				    icon: '/image/sysbutton/search.png',
				    handler: function () {
				    	reloadGrid();
				    }
				},
				{
				    xtype: 'button',
				    text: '操作记录',
				    name: 'log',
				    icon: '/image/sysbutton/log.png',
				    handler: function () {
				    	oprationRecord();
				    }
				},
				{
				    xtype: 'button',
				    text: '撤销送审',
				    name: 'cancel',
				    icon: '/image/sysbutton/cancel.png',
				    handler: function (btn) {
				        button_name = btn.text;
				        button_status = btn.name;
				        doWorkFlow(btn);
				    }
				},
				'->',
				initButton_OftenUsed(),
				initButton_Screen()   
			],
			'004': [
	                {
	                    xtype: 'button',
	                    text: '查询',
	                    name: 'search',
	                    icon: '/image/sysbutton/search.png',
	                    handler: function () {
	                        reloadGrid();
	                    }
	                },
	                {
	                    xtype: 'button',
	                    text: '修改',
	                    name: 'btn_update',
	                    icon: '/image/sysbutton/edit.png',
	                    handler: function (btn) {
	                    	var records = DSYGrid.getGrid('contentGrid').getSelection();
	                        if (records.length != 1) {
	                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
	                            return;
	                        }
	                        //修改全局变量的值
	                        button_name = btn.text;
	                        button_status = btn.name;
                            ZCD_ID = records[0].get('ZC_ID');
	                        initZfxxData_update({
	                            editable: true,
	                            ZCD_ID: records[0].get('ZC_ID')
	                        })
	                    }
				    },
				    {
				    	xtype: 'button',
	                    text: '删除',
	                    name: 'btn_delete',
	                    icon: '/image/sysbutton/delete.png',
	                    handler: function (btn) {
	                        button_name = btn.text;
	                        button_status = btn.name;
	                        var records = DSYGrid.getGrid('contentGrid').getSelection();
	                        if (records.length < 1) {
	                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
	                            return;
	                        }
	                        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
	                            if (btn_confirm == 'yes') {
	                                button_name = btn.text;
	                                var ids = [];
	                                for (var i in records) {
	                                    ids.push(records[i].get("ZC_ID"));
	                                }
	                                //发送ajax请求，删除数据
	                                $.post("/deleteFxdfZfzqZqzcGrid.action", {
	                                    ids: ids,
	                                    wf_id: wf_id,
	                                    WF_STATUS: WF_STATUS,
	                                    AD_CODE:AD_CODE
	                                }, function (data) {
	                                    if (data.success) {
	                                        Ext.toast({
	                                            html: button_name + "成功！",
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
	                        });
	                    }
				    },
				    {
				    	xtype: 'button',
	                    text: '送审',
	                    name: 'down',
	                    icon: '/image/sysbutton/audit.png',
	                    handler: function (btn) {
	                        button_name = btn.text;
	                        button_status = btn.name;
	                        doWorkFlow(btn);
	                    }
				    },
				    {
				    	xtype: 'button',
	                    text: '操作记录',
	                    name: 'log',
	                    icon: '/image/sysbutton/log.png',
	                    handler: function () {
	                        oprationRecord();
	                    }
				    },
	                '->',
	                initButton_OftenUsed(),
	                initButton_Screen()
	            ],
	            '008': [
					{
						xtype:'button',
						text:'查询',
						name:'search',
						icon: '/image/sysbutton/search.png',
					    handler: function () {
					        reloadGrid();
					    }
					},
	                {
				    	xtype: 'button',
	                    text: '操作记录',
	                    name: 'log',
	                    icon: '/image/sysbutton/log.png',
	                    handler: function () {
	                        oprationRecord();
	                    }
				    },
	                '->',
	                initButton_OftenUsed(),
	                initButton_Screen()
	            ]
		},
		store: {
            WF_STATUS: DebtEleStore(json_debt_zt0),
            ZC_TYPE: DebtEleStore(json_debt_zqzclx)
        }
	},
	zfsh:{
		items:{
			'001':[
				{
				    xtype: 'button',
				    text: '查询',
				    name: 'search',
				    icon: '/image/sysbutton/search.png',
				    handler: function () {
				        reloadGrid();
				    }
				},
				{
				    xtype: 'button',
				    text: '审核',
				    name: 'down',
				    icon: '/image/sysbutton/audit.png',
				    handler: function (btn) {
				        button_name = btn.text;
				        doWorkFlow(btn);
				    }
				},
				{
				    xtype: 'button',
				    text: '退回',
				    name: 'up',
				    icon: '/image/sysbutton/back.png',
				    handler: function (btn) {
				        button_name = btn.text;
				        doWorkFlow(btn);
				    }
				},
				{
				    xtype: 'button',
				    text: '操作记录',
				    name: 'log',
				    icon: '/image/sysbutton/log.png',
				    handler: function () {
				        oprationRecord();
				    }
				},
				'->',
				initButton_OftenUsed(),
				initButton_Screen()
			],
			'002':[
				{
				    xtype: 'button',
				    text: '查询',
				    name: 'search',
				    icon: '/image/sysbutton/search.png',
				    handler: function () {
				        reloadGrid();
				    }
				},
				{
				    xtype: 'button',
				    text: '操作记录',
				    name: 'log',
				    icon: '/image/sysbutton/log.png',
				    handler: function () {
				        oprationRecord();
				    }
				},
				{
				    xtype: 'button',
				    text: '撤销审核',
				    name: 'cancel',
				    icon: '/image/sysbutton/cancel.png',
				    handler: function (btn) {
				        button_name = btn.text;
				        doWorkFlow(btn);
				    }
				},
				'->',
				initButton_OftenUsed(),
				initButton_Screen()    
			]
		},
		store: {
            WF_STATUS: DebtEleStore(json_debt_sh),
            ZC_TYPE: DebtEleStore(json_debt_zqzclx)
        }
	}
} ;

//初始化页面
$(document).ready(function(){
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    initContent();
}) ;
/*
* 初始化页面内容区域
*/
function initContent(){
	Ext.create('Ext.panel.Panel',{
		layout: 'border',
		defaults: {
			split: true,
			collapsible: false
		},
		height: '100%',
        renderTo: Ext.getBody(),
        border: false,
        dockedItems: [
			{
				xtype: 'toolbar',
				dock: 'top',
				itemId: 'contentPanel_toolbar',
				//items: Ext.Array.union(json_common[node_type].items[WF_STATUS], json_common[node_type].items['common'])
				items:json_common[node_type].items[WF_STATUS]
			}
        ],
        items: [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                },
                items_tree: json_common[node_type].items_content_tree
            }),
            initContentRightPanel()
        ]
	}) ;
}
/*
* 初始化右侧panel
*/
function initContentRightPanel(){
	return Ext.create('Ext.form.Panel',{
		height: '100%',
        flex: 5,
        region: 'center',
        layout: {
            type: 'vbox',
            align: 'stretch',
            flex: 1
        },
        border: false,
        dockedItems: json_common[node_type].items_content_rightPanel_dockedItems ? json_common[node_type].items_content_rightPanel_dockedItems : null,
        items: [
            initContentGrid()
        ]
	}) ;
}
/*
 * 初始化主表格
 */
function initContentGrid(){
	var headerJson = [
		{xtype: 'rownumberer', width: 45},
		{text: "", dataIndex: "ZC_ID", type: "string", hidden: true, width: 200},
		{text: "", dataIndex: "ZQ_ID", type: "string", hidden: true, width: 200},
		{text: "", dataIndex: "ZW_ID", type: "string", hidden: true, width: 200},
		{text: "", dataIndex: "XM_ID", type: "string", hidden: true, width: 200},
        {text: "地区", dataIndex: "AD_NAME", type: "string", width: 150},
        {text: "单位名称", dataIndex: "AG_NAME", type: "string", hidden: false, width: 200},
        {
            text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 350,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE.replace(/00$/, "");
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="ZQ_ID";
                paramNames[1]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1]=encodeURIComponent(AD_CODE.replace(/00$/, ""));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", hidden: false, width: 200,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
        // 20210628 guoyf 支付日期改为整改日期
		{text: "整改日期", dataIndex: "PAY_DATE", type: "string", hidden: false, width: 200},
		{text: "支付金额", dataIndex: "PAY_AMT", type: "float", hidden: false, width: 200},
		{text: "支付原币金额", dataIndex: "PAY_ORI_AMT", type: "float", hidden: false, width: 200},
        {
            text: "债务名称", dataIndex: "ZW_NAME", type: "string", hidden: false, width: 200,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
        },
		{text: "币种", dataIndex: "FM_ID", type: "string", hidden: false, width: 200},
		{text: "汇率", dataIndex: "HL_RATE", type: "string", hidden: false, width: 200},
		{text: "备注", dataIndex: "ZCD_REMARK", type: "string", hidden: false, width: 200}
    ] ;
	return DSYGrid.createGrid({
		itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        params: {
            WF_STATUS: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            node_current_id:node_code,
            //ZC_TYPE: ZC_TYPE,
            SJLY: 0
        },
        dataUrl: '/getFxdfZqzfMainGrid.action',
        checkBox: true,
        border: false,
        autoLoad: false,
        height: '100%',
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: json_common[node_type].store['WF_STATUS'],
                width: 110,
                labelWidth: 30,
                editable: false, //禁用编辑
                labelAlign: 'right',
                displayField: "name",
                valueField: "id",
                value: WF_STATUS,
                allowBlank: false,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(Ext.Array.union(json_common[node_type].items[WF_STATUS], json_common[node_type].items['common']));
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                        reloadGrid();
                    }
                }
            }
        ],
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            itemdblclick: function (self, record) {
                /*initZcxxData_update({
                    editable: false,
                    ZCD_ID: record.get("ZCD_ID")
                })*/
            }
        }
	}) ;
}
/**
 * 树点击节点时触发，刷新content主表格
 */
function reloadGrid(param) {
    var grid = DSYGrid.getGrid('contentGrid');
    var store = grid.getStore();
    //增加查询参数
    store.getProxy().extraParams["AD_CODE"] = AD_CODE;
    store.getProxy().extraParams["AG_CODE"] = AG_CODE;
    if (typeof param != 'undefined' && param != null) {
        for (var name in param) {
            store.getProxy().extraParams[name] = param[name];
        }
    }
    //刷新
    store.loadPage(1);
}
/*
*初始化已完成的债券
*/
function initWindow_select_zfxm(){
	return Ext.create('Ext.window.Window',{
        title: '债券支出选择', // 窗口标题
        width: document.body.clientWidth * 0.96, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_select_zdmx', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [initWindow_select_zfzq_grid()],
        buttons: [
            {
                text: '确认',
                handler: function (btn) {
                     //获取表格选中数据
                    var records = btn.up('window').down('grid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                        return;
                    }
                    var record = records[0].getData();
                    var zcType=record.ZC_TYPE;
                    ZCD_ID = GUID.createGUID();
                    ZQLB_ID = record.ZQLB_ID;
                    var window_zfmx = initWindow_select_zfmx(zcType);
                    window_zfmx.show();
                    //向下一window传递选择的转贷债券数据
                    record.PAY_AMT_BC=record.PAY_AMT;//本次红冲金额赋值
                    record.XZCZAP_AMT_BC=record.XZCZAP_AMT;// 本次新增赤字金额赋值
                    record.ZX_ZBJ_AMT_BC=record.ZX_ZBJ_AMT;// 本次专项资本金赋值
                    window_zfmx.down('form').getForm().setValues(record);
                    btn.up('window').close();
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
	}) ;
}
/*
 *置换完成的债券 Grid 
 */
function initWindow_select_zfzq_grid(){
	var headerJson = [
	      {xtype: 'rownumberer', width: 45},
	      {text: "地区编码", dataIndex: "AD_CODE", type: "string", hidden: true, width: 200},
          {text: "地区", dataIndex: "AD_NAME", type: "string", width: 150},
          {text: "", dataIndex: "ZC_ID", type: "string", hidden: true, width: 200},
          {text: "", dataIndex: "ZQ_ID", type: "string", hidden: true, width: 200},
          {text: "", dataIndex: "ZC_TYPE", type: "string", hidden: true, width: 200},
          {text: "", dataIndex: "ZW_ID", type: "string", hidden: true, width: 200},
	      {text: "", dataIndex: "XM_ID", type: "string", hidden: true, width: 200},
	      {text: "单位名称", dataIndex: "AG_NAME", type: "string", hidden: false, width: 200},
          {
            text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 350,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE.replace(/00$/, "");
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="ZQ_ID";
                paramNames[1]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                paramValues[1]=encodeURIComponent(AD_CODE.replace(/00$/, ""));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
          },
          {
            text: "项目名称", dataIndex: "XM_NAME", type: "string", hidden: false, width: 200,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
          },
          {
                text: "债券类别", dataIndex: "ZQLB_ID", type: "string", hidden: true, width: 200
          },
	      {text: "支付日期", dataIndex: "PAY_DATE", type: "string", hidden: false, width: 100},
	      {text: "支付金额", dataIndex: "PAY_AMT", type: "float", hidden: false, width: 200},
	      {text: "支付原币金额", dataIndex: "PAY_ORI_AMT", type: "float", hidden: false, width: 200},
          {text: "其中：新增赤字", dataIndex: "XZCZAP_AMT", type: "float", hidden: false, width: 200},
          {text: "专项债用作资本金", dataIndex: "ZX_ZBJ_AMT", type: "float", hidden: false, width: 200},
          {
            text: "债务名称", dataIndex: "ZW_NAME", type: "string", hidden: false, width: 200,
            renderer: function (data, cell, record) {
                /*var hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url='/page/debt/common/zwyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="zw_id";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;
            }
          },
		  {text: "币种", dataIndex: "FM_ID", type: "string", hidden: false, width: 200},
	      {text: "汇率", dataIndex: "HL_RATE", type: "string", hidden: false, width: 200},
	      {text: "备注", dataIndex: "ZCD_REMARK", type: "string", hidden: false, width: 200}
	  ];
	var grid = DSYGrid.createGrid({
		itemId: 'window_select_zfzq_grid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        selModel: {
            mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
        },
        checkBox: true,
        border: false,
        height: '100%',
        flex: 1,
        params: {
        	AG_ID: AG_ID,
        	AG_CODE: AG_CODE,
            //ZC_TYPE: ZC_TYPE
        },
        pageConfig: {
            enablePage: false
        },
        dataUrl: '/getFxdfZqsyZfzqGrid.action',
        dockedItems:[{
        	xtype: 'toolbar',  
            dock: 'top',  
            items: [{
                fieldLabel: '支付年份',
                xtype: "combobox",
                name: "ZF_YEAR",
                store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2015'"}),
                displayField: "name",
                valueField: "id",
                editable: false, //禁用编辑
                labelWidth: 60,
                width: 170,
                labelAlign: 'right',
                listeners: {
                    change: function (self, newValue) {
                        queryData();
                    }
                }
            },
            {
               // fieldLabel: '月份',
                xtype: "combobox",
                name: "ZF_MONTH",
                store: DebtEleStore(json_debt_yf_qb),
                displayField: "name",
                valueField: "id",
                editable: false, //禁用编辑
                labelWidth: 30,
                width: 120,
                labelAlign: 'right',
                listeners: {
                    change: function (self, newValue) {
                        queryData();
                    }
                }
            },
            {
                fieldLabel: '模糊查询',
                xtype: "textfield",
                name: 'contentGrid_search',
                itemId: 'contentGrid_search',
                width: 350,
                labelWidth: 60,
                labelAlign: 'right',
                enableKeyEvents: true,
                emptyText: '请输入债券名称/单位名称/债务名称/项目名称',
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            queryData();
                        }
                    }
                }
            },
            '->',
            {
                xtype: 'button',
                text: '查询',
                name: 'search',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    queryData();
                }
            }]  
        }],
        tbar: [],
	    pageConfig: {
	        pageNum: true//设置显示每页条数
	    }
	}) ;
	return grid ;
}

function queryData(){
    var store = DSYGrid.getGrid('window_select_zfzq_grid').getStore();
    var ZF_YEAR = Ext.ComponentQuery.query('combobox[name="ZF_YEAR"]')[0].getValue();
    var ZF_MONTH = Ext.ComponentQuery.query('combobox[name="ZF_MONTH"]')[0].getValue();
    var contentGrid_search = Ext.ComponentQuery.query('textfield[name="contentGrid_search"]')[0].getValue();
    store.getProxy().extraParams = {
        ZF_YEAR: ZF_YEAR,
        ZF_MONTH: ZF_MONTH,
        contentGrid_search: contentGrid_search,
		AG_CODE: AG_CODE
    };
    store.loadPage(1);
}

/*
 * 初始化作废明细单，选择弹出窗口 
*/
function initWindow_select_zfmx(zcType){
	return Ext.create('Ext.window.Window',{
        title: '债券支出整改', // 窗口标题
        width: document.body.clientWidth * 0.7, // 窗口宽度
        height: document.body.clientHeight * 0.75, // 窗口高度
        layout: 'fit',
        maximizable: true,
        itemId: 'window_input', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: initWindow_input_contentForm(zcType),
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                	var form = btn.up('window.window').down('form');
                	var bczcAmt = form.getForm().getValues().PAY_AMT_BC;//本次支出金额
                	var bczcYbAmt = form.getForm().getValues().PAY_ORI_AMT;//本次支出原币金额
                    var bczcXzczAmt = form.getForm().getValues().XZCZAP_AMT_BC;// 本次支出新增赤字安排金额
                    var bczcZxzbjAmt = form.getForm().getValues().ZX_ZBJ_AMT_BC;// 本次支出专项债用作资本金
                	if(bczcAmt>form.getForm().getValues().PAY_AMT){//本次支出不能大于该支出单可支出金额
                		Ext.Msg.alert('提示', '本次支出金额不能大于剩余支出金额');
                		return;
                	}
                	if(bczcXzczAmt > form.getForm().getValues().XZCZAP_AMT){
                        Ext.Msg.alert('提示', '本次支出其中：新增赤字(元)不能大于剩余其中：新增赤字(元)');
                        return;
                    }
                    if(bczcZxzbjAmt > form.getForm().getValues().ZX_ZBJ_AMT){
                        Ext.Msg.alert('提示', '本次支出专项债用作资本金(元)不能大于剩余专项债用作资本金(元)');
                        return;
                    }
                	button_name = btn.text;
                	var parameters = {
                            wf_id: wf_id,
                            wf_status:WF_STATUS,
                            node_code: node_code,
                            button_name : button_name,
                            button_status:button_status,
                            zc_bill_id : ZCD_ID,
                            bczcAmt:bczcAmt,
                            bczcYbAmt:bczcYbAmt,
                            bczcXzczAmt:bczcXzczAmt,
                            bczcZxzbjAmt:bczcZxzbjAmt
                        };
                    if (form.isValid()) {
                        //保存表单数据及明细数据
                        form.submit({
                            //设置表单提交的url
                            url: 'saveZfxxGrid.action',
                            params: parameters,
                            success: function (form, action) {
                                //关闭弹出框
                                btn.up("window").close();
                                //提示保存成功
                                Ext.toast({
                                    html: '<div style="text-align: center;">保存成功!</div>',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                reloadGrid();
                            },
                            failure: function (form, action) {
                                var result = Ext.util.JSON.decode(action.response.responseText);
                                Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                            }
                        });
                    } else {
                        Ext.Msg.alert('提示', '请检查必填项！');
                    }
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
	}) ;
}
function initWindow_input_contentForm(zcType){
	return Ext.create('Ext.form.Panel',{
		width: '100%' ,
		height: '100%' ,
        layout: 'anchor' ,
        fileUpload: true,
		border: false ,
		padding: '2 5 0 5',
        itemId:'zchcForm',
		defaults: {
            width: '100%'
        },
        defaultType: 'textfield',
        items: [
			{
			    xtype: 'container',
			    layout: 'column',
			    defaultType: 'textfield',
			    defaults: {
			        margin: '5 5 2 5',
			        columnWidth: .33,
			        //width: 280,
			        //disabled:true,
			        submitValue : false,  //设置表单不提交此项
			        readOnly: false,
			        labelWidth: 190//控件默认标签宽度
			    },
			    items:[
					{
					    xtype: "textfield",
					    fieldLabel: '支出ID',
					    disabled: false,
					    name: "ZC_ID",
					    hidden: true,
					    submitValue : true,
					    columnWidth: .5,
					    editable: false//禁用编辑
					},
                    {
                        xtype: "textfield",
                        fieldLabel: '支出类型',
                        disabled: false,
                        name: "ZC_TYPE",
                        hidden: true,
                        submitValue : true,
                        columnWidth: .5,
                        editable: false//禁用编辑
                    },
					{
					    xtype: "textfield",
					    fieldLabel: '债券名称',
					    name: "ZQ_NAME",
					    editable: false,//禁用编辑
					    readOnly: true,
					    columnWidth: .5,
					    fieldStyle: 'background:#E6E6E6'
					},
					{
					    xtype: "textfield",
					    fieldLabel: '地区',
					    name: "AD_NAME",
					    editable: false,//禁用编辑
					    readOnly: true,
					    columnWidth: .5,
					    fieldStyle: 'background:#E6E6E6'
					},
					{
						xtype: "textfield",
						fieldLabel: '地区',
						name: "AD_CODE",
						hidden: false,
                        submitValue : true,
						columnWidth: .5,
						fieldStyle: 'background:#E6E6E6'
					},
					{
						xtype: "textfield",
						fieldLabel: '单位名称',
						name: "AG_NAME",
						editable: false,//禁用编辑
						readOnly: true,
						columnWidth: .5,
						fieldStyle: 'background:#E6E6E6'
					},
					{
					    xtype: "numberFieldFormat",
					    fieldLabel: '剩余支出金额 (元)',
					    name: "PAY_AMT",
					    emptyText: '0.00',
					    hideTrigger: true,
					    plugins: {ptype: 'fieldStylePlugin'},
					    submitValue : true,
					    readOnly: true,
					    columnWidth: .5,
					    fieldStyle: 'background:#E6E6E6'
					},
					{
                        xtype: "datefield",
                        fieldLabel: '<span class="required">✶</span>整改日期',
                        name: "NEW_DATE",
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择转贷日期',
                        submitValue : true,
                        columnWidth: .5,
                        value: new Date(),
                        maxValue: new Date()// 20210628 guoyf 增加日期控制
                    },
					{
					    xtype: "numberFieldFormat",
					    fieldLabel: zcType=="0"?'<span class="required">✶</span>本次支出金额(元)':'本次支出金额(元)',
					    name: "PAY_AMT_BC",
					    emptyText: '0.00',
					    hideTrigger: true,
					    plugins: {ptype: 'fieldStylePlugin'},
					    allowBlank: false,
					    submitValue : true,
					    readOnly: zcType=="0"?false:true,
					    fieldStyle: zcType=="0"?'background:white':'background:#E6E6E6',
					    columnWidth: .5,
						minValue:0,
					    listeners:{
					    	'change':function(self, newValue, oldValue){
					    		Ext.ComponentQuery.query('numberFieldFormat[name="PAY_ORI_AMT"]')[0].setValue(newValue);
					    	}
					    }
					},
					{
						xtype: "numberFieldFormat",
						fieldLabel: '本次支出原币金额(元)',
						name: "PAY_ORI_AMT",
						emptyText: '0.00',
						hideTrigger: true,
						plugins: {ptype: 'fieldStylePlugin'},
						submitValue : true,
						readOnly: true,
						columnWidth: .5,
						fieldStyle: 'background:#E6E6E6'
					},
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '本次支出其中：新增赤字(元)',
                        name: "XZCZAP_AMT_BC",
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        submitValue : true,
                        readOnly: (zcType=="0" && ZQLB_ID == '01') ? false : true,
                        columnWidth: .5,
                        fieldStyle: (zcType=="0" && ZQLB_ID == '01') ?'background:white':'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '剩余其中：新增赤字(元)',
                        name: "XZCZAP_AMT",
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        submitValue : true,
                        readOnly: true,
                        columnWidth: .5,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '本次支出专项债用作资本金(元)',
                        name: "ZX_ZBJ_AMT_BC",
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        submitValue : true,
                        minValue:0,
                        readOnly: (zcType=="0" && ZQLB_ID.substr(0,2) == '02') ? false : true,
                        columnWidth: .5,
                        fieldStyle: (zcType=="0" && ZQLB_ID.substr(0,2) == '02') ? 'background:white' : 'background:#E6E6E6'
                    },
                    {
                        xtype: "numberFieldFormat",
                        fieldLabel: '剩余专项债用作资本金(元)',
                        name: "ZX_ZBJ_AMT",
                        emptyText: '0.00',
                        hideTrigger: true,
                        plugins: {ptype: 'fieldStylePlugin'},
                        submitValue : true,
                        readOnly: true,
                        columnWidth: .5,
                        fieldStyle: 'background:#E6E6E6'
                    },
					{
						xtype: "textfield",
						fieldLabel: '项目名称',
						name: "XM_NAME",
						editable: false,//禁用编辑
						readOnly: true,
						columnWidth: .5,
						fieldStyle: 'background:#E6E6E6'
					},
					{
						xtype: "textfield",
						fieldLabel: '债务名称',
						name: "ZW_NAME",
						editable: false,//禁用编辑
						readOnly: true,
						columnWidth: .5,
						fieldStyle: 'background:#E6E6E6'
					},
					{
						xtype: "textfield",
						fieldLabel: '备注',
						name: "ZCD_REMARK",
						editable: true,//禁用编辑
						readOnly: false,
						submitValue : true,
						columnWidth: 1,
						fieldStyle: 'background:#FFFFFF'
					},
                    {//分割线
                        xtype: 'menuseparator',
                        margin: '5 0 5 0',
                        border: true
                    }
			    ]
			},
            {
                xtype:'tabpanel',
                anchor:'100% 50%',
                items:[
                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        layout: 'fit',
                        name: 'fileTab',
                        items: [
                            {
                                xtype: 'panel',
                                layout:'fit',
                                itemId:'zqzg_fjgrid',
                                items:[init_zqzg_fjGrid()]
                            }
                        ]
                    }
                ]
            }
        ]
	}) ;
}

/**
 * 债券整改必录附件
 */
function init_zqzg_fjGrid(){
    var grid = UploadPanel.createGrid({
        busiId: ZCD_ID,//业务ID
        editable:true,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_xzzq_sjzctb_contentForm_xmfj_grid'
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
 * 作废修改
 */
function initZfxxData_update(config){
	//发送ajax请求，获取修改数据
    $.post("/getFxdfZqsyZfzqGridById.action", {
        ZCD_ID: config.ZCD_ID
    }, function (data) {
        if (data.success) {
         	var record = data.list ;
        	var zcType=record[0].ZC_TYPE;
        	ZQLB_ID=record[0].ZQLB_ID;
        	var new_date=record[0].PAY_DATE;
        	var PAY_AMT=record[0].PAY_AMT;
            var  PAY_AMT_BC=record[0].PAY_AMT_BC;
            var window_zfmx = initWindow_select_zfmx(zcType);
            window_zfmx.show();
            //向下一window传递选择的转贷债券数据
            button_status = 'update' ;
            window_zfmx.down('form').getForm().setValues(record[0]);
            //20210630 zhuangrx 支出红冲整改日期数据库表名不一致，重新赋值
            var zchcForm = Ext.ComponentQuery.query('form#zchcForm')[0];
            zchcForm.getForm().findField('NEW_DATE').setValue(new_date);
        }else{
        	Ext.MessageBox.alert('提示','获取数据失败！') ;
        }
    },"json") ;
}
/**
 * 工作流变更
 */
function doWorkFlow(btn) {
    // 检验是否选中数据
    // 获取选中数据
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length <= 0) {
        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
        return;
    }
    var ids = [];
    for (var i in records) {
        ids.push(records[i].get("ZC_ID"));
    }
    button_name = btn.text;
    var opValue = '';
    if (button_name == '送审') {
        opValue = '确定送审';
    } else if (btn.name == 'up') {
        opValue = '';
    } else {
        opValue = '同意';
    }
    ZC_TYPE = records[0].get("ZC_TYPE");//20210809 chenfei 获取支出类型
    if (button_name == '送审') {
    	Ext.Msg.confirm('提示', '请确认是否'+button_name+'!', function (btn_confirm) {
    		if (btn_confirm === 'yes') {
    			//发送ajax请求，修改节点信息
                $.post("/updateFxdfZfzqZqzcNode.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: '',
                    ids: ids,
                    ZC_TYPE: ZC_TYPE,
                    is_end_cancel: button_name == '撤销审核'
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: button_name + "成功！",
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
    	});
    }else {
	    //弹出意见填写对话框
	    initWindow_opinion({
	        title: btn.text,
	        animateTarget: btn,
	        value: opValue,
	        fn: function (buttonId, text) {
	            if (buttonId === 'ok') {
	                //发送ajax请求，修改节点信息
	                $.post("/updateFxdfZfzqZqzcNode.action", {
	                    workflow_direction: btn.name,
	                    wf_id: wf_id,
	                    node_code: node_code,
	                    button_name: button_name,
	                    audit_info: text,
	                    ids: ids,
	                    ZC_TYPE: ZC_TYPE,
	                    is_end_cancel: button_name == '撤销审核'
	                }, function (data) {
	                    if (data.success) {
	                        Ext.toast({
	                            html: button_name + "成功！",
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
	        }
	    });
    }
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
/**
 * 操作记录
 */
function oprationRecord() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var id = records[0].get("ZC_ID");
        fuc_getWorkFlowLog(id);
    }
}