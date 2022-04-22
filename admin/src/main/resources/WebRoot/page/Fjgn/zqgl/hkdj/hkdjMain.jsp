<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>还款登记主界面</title>
    <style type="text/css">
		.kjjk-grid-cell {
		background: #70DB93;
	}
	</style>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    /*获取登录用户*/
  /*  var node_code = getQueryParam("node_code");//当前节点id
    var node_type = getQueryParam("node_type");//当前节点id*/
    var node_code ="${fns:getParamValue('node_code')}";
    var node_type ="${fns:getParamValue('node_type')}";
    var AD_CODE = '${sessionScope.ADCODE}';
    var USER_AD_CODE= '${sessionScope.USERCODE}';
    //var v_child = '0';
    var json_zt = json_debt_zt11;//当前状态下拉框json数据
    var button_name = '';//当前操作按钮名称
    var button_text = '';
    var IS_DXTX = '0';//系统参数是否启用短信提醒
  /*  var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
  /*  if (node_code == null || node_code == '' || node_code.toLowerCase() == 'null') {
        node_code = '1';
    }
    if (node_type == null || node_type == '' || node_type.toLowerCase() == 'null') {
        node_type = 'hkdjsq';
    }*/
    if (isNull(node_code)) {
        node_code = '1';
    }
    if (isNull(node_type)) {
        node_type = 'hkdjsq';
    }
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    /**
     * 通用配置json
     */
    var json_common = {
        hkdjsq: 'hkdjsq.js'//填报
    };
    var HEADERJSON = [
        {
            xtype: 'rownumberer', summaryType: 'count', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "还款登记ID", dataIndex:"HKDJ_ID",type:"string",hidden:true},
        {text: "导入文件名", dataIndex: "FILE_NAME", width: 250, type: "string"},
        {text: "地区", dataIndex: "AD_NAME", width: 200, type: "string"},
        {text: "资金科目", dataIndex: "ZJ_KEMU", width: 100, type: "string"},
        {text: "实际偿还日期", dataIndex: "SJCH_DATE", width: 150, type: "string"},
        {text: "偿还金额(元)",dataIndex:"PAY_AMT",width:175,type: "float",summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {text: "滚存金额(元)",dataIndex:"GC_AMT",width:175,type: "float",summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {text: "记账凭证号", dataIndex: "JZPZ_NO", width: 130, type: "string",hidden:true},
        {text: "导入用户", dataIndex: "USER_AD_NAME", width: 130, type: "string"},
        {text: "导入日期", dataIndex: "UPLOAD_DATE", width: 180, type: "string"},
        {text: "导入批次", dataIndex: "PC_NO", width: 100, type: "string"},
    ];
    var HEADERJSON_mx=[
        {
            xtype: 'rownumberer', summaryType: 'count', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text:"债券ID", dataIndex:"ZQ_ID",width:150,type:"string",hidden:true
        },
        {text:"债券名称",dataIndex:"ZQ_NAME",width:300,type:"string"},
        {text:"债券编码", dataIndex:"ZQ_CODE",width:230,type:"string",hidden:false
        },
        {text:"到期日期", dataIndex:"DQ_DATE",width:150,type:"string",hidden:false
        },
        {
            text: "到期金额(元)", dataIndex: "DQ_AMT", width: 200, type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {
            text: "登记偿还金额(元)", dataIndex: "PAY_AMT", width: 200, type: "float",summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        }
    ];
    
        var HEADERJSON_DFF=[
        {
            xtype: 'rownumberer', summaryType: 'count', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text:"债券ID", dataIndex:"ZQ_ID",width:150,type:"string",hidden:true
        },
        {text:"债券名称",dataIndex:"ZQ_NAME",width:200,type:"string"},
        {text:"债券编码", dataIndex:"ZQ_CODE",width:150,type:"string",hidden:false
        },
        {text:"还款类型",dataIndex:"HK_TYPE",type: "string",width: 130,
            renderer: function (value) {
                var store = DebtEleStore(json_debt_hklx);
                var record = store.findRecord('code', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {text:"到期日期", dataIndex:"DQ_DATE",width:150,type:"string",
        },
        {
            text: "登记发行费金额(元)", dataIndex: "PAY_FXF_AMT", width: 200, type: "float",summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {
            text: "登记托管费金额(元)", dataIndex: "PAY_TGF_AMT", width: 200, type: "float",summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },{
            text: "登记发行兑付费用金额(元)", dataIndex: "PAY_AMT", width: 200, type: "float",summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        }
    ]
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        $.post("getParamValueAll.action", function (data) {
            IS_DXTX = data[0].IS_DXTX;
        },"json");
        //动态加载js
        $.ajaxSetup({
            cache: false
        });
        //ajax加载js文件
        $.getScript(json_common[node_type], function () {
            //如果工作流不存在或者工作流节点是填报节点，就初始化
            if (node_code == 1) {
                initContent();
                return false;
            }
            initContent();
            //根据节点名称修改状态下拉框store
            var combobox_status = Ext.ComponentQuery.query('combobox[name="WF_STATUS"]');
            if (typeof combobox_status != 'undefined' && combobox_status != null && combobox_status.length > 0 && json_zt != null) {
                combobox_status[0].setStore(DebtEleStore(json_zt));
            }
        });
    });
    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: json_common.items[WF_STATUS]
                }
            ],
            items: json_common.items_content ? json_common.items_content() :
                [
                   /* initContentTree({
                        areaConfig: {
                            params: {
                                CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                            }
                        },
                        param: json_common.items_content_tree_config,
                        items_tree: json_common.items_content_tree
                    }),//初始化左侧树*/
                    initContentRightPanel()//初始化右侧表格
                ]
        });
    }

    function initContentDetilGrid() {
        var headerJson = HEADERJSON_mx;
        var config = {
            itemId: 'contentGrid_detail',
            flex: 1,
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            features: [{
                ftype: 'summary'
            }],
            autoLoad: false,
            border: false,
            height: '50%',
            width: '100%',
            pageConfig: {
                enablePage: false
            },
            dataUrl: "/gethkMxData.action",
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'cellEdit',
                    clicksToMoveEditor: 1
                }
            ]
        };
        return DSYGrid.createGrid(config);
    }
     //发行兑付费用明细列表
     function initContentDetilGrid_DFF() {
        var headerJson = HEADERJSON_DFF;
        var config = {
            itemId: 'contentGrid_detail_dff',
            flex: 1,
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            features: [{
                ftype: 'summary'
            }],
            autoLoad: false,
            border: false,
            height: '50%',
            width: '100%',
            pageConfig: {
                enablePage: false
            },
            dataUrl: "/gethkMxData.action",
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'cellEdit',
                    clicksToMoveEditor: 1
                }
            ]
        };
        return DSYGrid.createGrid(config);
    }
    
    function initContentGrid() {
        var headerJson = HEADERJSON;
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: true
            },
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '50%',
            flex: 1,
            dataUrl: '/gethkMainData.action',
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            params: {
                AD_CODE:AD_CODE,
                WF_STATUS:WF_STATUS,
                USERCODE:USER_AD_CODE
            },
           dockedItems: [
                {
                    xtype: 'form',
                    dock: 'top',
                    layout: {
                        type: 'column'
                    },
                    border: true,
                    bodyStyle: 'border-width:0 0 0 0',
                    defaults: {
                        margin: '3 5 3 5',
                        width: 250,
                        //columnWidth: .20,
                        labelWidth: 100,//控件默认标签宽度
                        labelAlign: 'right'//控件默认标签对齐方式
                    },
                    items: [
                   {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_zt),
                    width: 110,
                    labelWidth:30,
                    editable: false,
                    labelAlign: 'right',
                    displayField: "name",
                    valueField: "id",
                    allowBlank: false,
                    value: WF_STATUS,
                    listeners: {
                        change: function (self, newValue) {
                             WF_STATUS = newValue;
                             var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                             toolbar.removeAll();
                             toolbar.add(json_common.items[WF_STATUS]);
                             reloadGrid();
                        }
                    },
                },
                {
                     xtype: 'treecombobox',
                     fieldLabel: '地区',
                     itemId: 'QH',
                     displayField: 'name',
                     valueField: 'code',
                     editable:false,
                     rootVisible: true,
                     lines: false,
                     width: 230,
                     selectModel: 'all',
                     labelAlign: 'right',
                     store: DebtEleTreeStoreDBTable("DSY_V_ELE_AD",{condition:" and code like '"+AD_CODE+"%' AND CODE NOT LIKE '%00'"}),
                     listeners: {
                        change: function (self, newValue) {
                            var store = DSYGrid.getGrid('contentGrid').getStore();
                            //增加查询参数
                            store.getProxy().extraParams["QH"] = newValue;
                            store.loadPage(1);
                            //刷新下方本金利息表格,置为空
				            var bxgrid = DSYGrid.getGrid('contentGrid_detail');
				            bxstore = bxgrid.getStore();
				            bxstore.removeAll();
				            //刷新下方发行兑付费用表格,置为空
				            var dffgrid = DSYGrid.getGrid('contentGrid_detail_dff');
				            dffstore = dffgrid.getStore();
				            dffstore.removeAll();
                        }
                    }
                 },
                {
                     fieldLabel: '资金科目',
                     xtype: 'combobox',
                     name: 'ZJ_KEMU',
                     displayField: 'name',
                     valueField: 'name',
                     store: DebtEleStore(json_debt_zjkm),
                     multiSelect : true,
                     editable: false,
                     labelAlign: 'right',
                     listeners: {
                        change: function (self, newValue) {
                            var store = DSYGrid.getGrid('contentGrid').getStore();
                            //增加查询参数
                            store.getProxy().extraParams["ZJKM"] = Ext.util.JSON.encode(newValue);
                            store.loadPage(1);
                            //刷新下方本金利息表格,置为空
				            var bxgrid = DSYGrid.getGrid('contentGrid_detail');
				            bxstore = bxgrid.getStore();
				            bxstore.removeAll();
				            //刷新下方发行兑付费用表格,置为空
				            var dffgrid = DSYGrid.getGrid('contentGrid_detail_dff');
				            dffstore = dffgrid.getStore();
				            dffstore.removeAll();
                        }
                    }
                 },
                {
                      xtype: "datefield",
                      fieldLabel: '开始时间',
                      format: 'Y-m-d',
                      name: 'sdate',
                      width: 210,
                      labelAlign: 'right',
                      listeners: {
                        change: function (self, newValue) {
                            var store = DSYGrid.getGrid('contentGrid').getStore();
                            //增加查询参数
                            store.getProxy().extraParams["sdate"] = Ext.util.Format.date(newValue, 'Y-m-d');
                            store.loadPage(1);
                            //刷新下方本金利息表格,置为空
				            var bxgrid = DSYGrid.getGrid('contentGrid_detail');
				            bxstore = bxgrid.getStore();
				            bxstore.removeAll();
				            //刷新下方发行兑付费用表格,置为空
				            var dffgrid = DSYGrid.getGrid('contentGrid_detail_dff');
				            dffstore = dffgrid.getStore();
				            dffstore.removeAll();
                        }
                    }
                  },
                  {
                      xtype: "datefield",
                      fieldLabel: '结束时间',
                      format: 'Y-m-d',
                      name: 'edate',
                      width: 210,
                      labelAlign: 'right',
                      listeners: {
                        change: function (self, newValue) {
                            var store = DSYGrid.getGrid('contentGrid').getStore();
                            //增加查询参数
                            store.getProxy().extraParams["edate"] = Ext.util.Format.date(newValue, 'Y-m-d');
                            store.loadPage(1);
                            //刷新下方本金利息表格,置为空
				            var bxgrid = DSYGrid.getGrid('contentGrid_detail');
				            bxstore = bxgrid.getStore();
				            bxstore.removeAll();
				            //刷新下方发行兑付费用表格,置为空
				            var dffgrid = DSYGrid.getGrid('contentGrid_detail_dff');
				            dffstore = dffgrid.getStore();
				            dffstore.removeAll();
                        }
                    }
                  }
                ]
              }
          ],
           /* tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_zt),
                    width: 110,
                    labelWidth:30,
                    editable: false,
                    labelAlign: 'right',
                    displayField: "name",
                    valueField: "id",
                    allowBlank: false,
                    value: WF_STATUS,
                    listeners: {
                        change: function (self, newValue) {
                             WF_STATUS = newValue;
                             var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                             toolbar.removeAll();
                             toolbar.add(json_common.items[WF_STATUS]);
                             reloadGrid();
                        }
                    },
                },
                {
                     xtype: 'treecombobox',
                     fieldLabel: '地区',
                     itemId: 'QH',
                     displayField: 'name',
                     valueField: 'code',
                     editable:false,
                     rootVisible: true,
                     lines: false,
                     width: 230,
                     selectModel: 'all',
                     labelAlign: 'right',
                     store: DebtEleTreeStoreDBTable("DSY_V_ELE_AD",{condition:" and code like '"+AD_CODE+"%' AND SUBSTR(CODE,LENgth(CODE)-1,LENgTH(CODE)) !='00'"}),
                     listeners: {
                        change: function (self, newValue) {
                            var store = DSYGrid.getGrid('contentGrid').getStore();
                            //增加查询参数
                            store.getProxy().extraParams["QH"] = newValue;
                            store.loadPage(1);
                            //刷新下方本金利息表格,置为空
				            var bxgrid = DSYGrid.getGrid('contentGrid_detail');
				            bxstore = bxgrid.getStore();
				            bxstore.removeAll();
				            //刷新下方发行兑付费用表格,置为空
				            var dffgrid = DSYGrid.getGrid('contentGrid_detail_dff');
				            dffstore = dffgrid.getStore();
				            dffstore.removeAll();
                        }
                    }
                 },
                {
                     fieldLabel: '资金科目',
                     xtype: 'combobox',
                     name: 'ZJ_KEMU',
                     displayField: 'name',
                     valueField: 'name',
                     store: DebtEleStore(json_debt_zjkm),
                     multiSelect : true,
                     editable: false,
                     labelAlign: 'right',
                     listeners: {
                        change: function (self, newValue) {
                            var store = DSYGrid.getGrid('contentGrid').getStore();
                            //增加查询参数
                            store.getProxy().extraParams["ZJKM"] = Ext.util.JSON.encode(newValue);
                            store.loadPage(1);
                            //刷新下方本金利息表格,置为空
				            var bxgrid = DSYGrid.getGrid('contentGrid_detail');
				            bxstore = bxgrid.getStore();
				            bxstore.removeAll();
				            //刷新下方发行兑付费用表格,置为空
				            var dffgrid = DSYGrid.getGrid('contentGrid_detail_dff');
				            dffstore = dffgrid.getStore();
				            dffstore.removeAll();
                        }
                    }
                 },
                {
                      xtype: "datefield",
                      fieldLabel: '开始时间',
                      format: 'Y-m-d',
                      name: 'sdate',
                      width: 180,
                      labelWidth: 60,
                      labelAlign: 'right'
                  },
                  {
                      xtype: "datefield",
                      fieldLabel: '结束时间',
                      format: 'Y-m-d',
                      name: 'edate',
                      width: 180,
                      labelWidth: 60,
                      labelAlign: 'right'
                  }
            ],*/
            features: [{
                ftype: 'summary'
            }],
            listeners: {
                itemclick: function (self, record) {
                	var bxgrid = DSYGrid.getGrid("contentGrid_detail");
                    var mx_grid_dff=DSYGrid.getGrid("contentGrid_detail_dff");
                    var grid;
                    if("兑付费" == record.get("ZJ_KEMU")){
                    	mx_grid_dff.show();
		                bxgrid.hide();
		                grid=mx_grid_dff;
                    }else{
                    	bxgrid.show();
		                mx_grid_dff.hide();
		                grid=bxgrid;
                    }
                    grid.getStore().getProxy().extraParams={
                        HKDJ_ID:record.get("HKDJ_ID")
                    };
                    grid.getStore().loadPage(1);
                }
            }
        });
    }
    /**
     * 初始化右侧panel，放置2个表格
     */
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',

            },
            border: false,
            dockedItems: json_common.items_content_rightPanel_dockedItems ? json_common.items_content_rightPanel_dockedItems : null,
            items: json_common.items_content_rightPanel_items ? json_common.items_content_rightPanel_items() : [
                initContentGrid(),
                initContentDetilGrid(),
                initContentDetilGrid_DFF()
            ],
            listeners: {
	        	afterrender: function(t){
	                var bxgrid = DSYGrid.getGrid('contentGrid_detail');
	                var dffgrid = DSYGrid.getGrid('contentGrid_detail_dff');
	                bxgrid.show();
	                dffgrid.hide();
	        	}
	        }
        });
    }
    function toast_util(button_name,is_success,respText) {
        if(is_success==null||is_success==undefined){
            is_success=true;
        }
        if(is_success){
            Ext.toast({
                html: button_name+"成功！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
        }else{
            if(respText.message!=null&&respText!=undefined&&respText!=""){
                Ext.MessageBox.alert(button_name+"失败", respText.message);
            }else{
                Ext.MessageBox.alert(button_name+"失败", button_name+"失败");
            }
        }

    }
     function reloadGrid() {
           var grid = DSYGrid.getGrid('contentGrid');
           var ZJ_KEMU = Ext.ComponentQuery.query('combobox[name="ZJ_KEMU"]')[0].getValue();
           var QH = Ext.ComponentQuery.query('treecombobox[itemId="QH"]')[0].getValue();
           var sdate = Ext.ComponentQuery.query('datefield[name="sdate"]')[0].getValue();
           var edate = Ext.ComponentQuery.query('datefield[name="edate"]')[0].getValue();
           
           var store = grid.getStore();
              store.getProxy().extraParams={
                  WF_STATUS:WF_STATUS,
                  AD_CODE:AD_CODE,
                  QH:QH,
                  ZJKM: Ext.util.JSON.encode(ZJ_KEMU),
                  sdate:Ext.util.Format.date(sdate, 'Y-m-d'),
                  edate:Ext.util.Format.date(edate, 'Y-m-d')
              };
           store.loadPage(1);
           
           //刷新本金利息下方表格,置为空
           var bxgrid = DSYGrid.getGrid('contentGrid_detail');
           store = bxgrid.getStore();
           store.getProxy().extraParams={
           HKDJ_ID:""
           };
        store.loadPage(1);
       
           //刷新发行兑付费用下方表格,置为空
           var griddff = DSYGrid.getGrid('contentGrid_detail_dff');
           storedff = griddff.getStore();
           storedff.getProxy().extraParams={
           HKDJ_ID:""
           };
        storedff.loadPage(1);
       }

    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (!records || records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            var HKDJ_ID = records[0].get("HKDJ_ID");
            fuc_getWorkFlowLog(HKDJ_ID);
        }
    }



</script>
</body>
</html>