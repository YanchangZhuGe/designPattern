<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>年度计划汇总确认</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }

        span.required {
            color: red;
            font-size: 100%;
        }
        .grid-cell {
            background-color: #ffe850;
        }
    </style>

</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    <%	/*获取登录用户*/
    /*    String userCode = (String) request.getSession().getAttribute("USERCODE");
        String adCode = (String) request.getSession().getAttribute("ADCODE");*/
    %>
    var button_name = '';//当前操作按钮名称
 /*   var WF_STATUS = getUrlParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    /**
     * 通用函数：获取url中的参数：wf_id,node_code
     */
  /*  function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg); //匹配目标参数
        if (r != null)
            return unescape(r[2]);
        return null; //返回参数值
    }*/
    //全局变量 
    <%--var AD_CODE = '<%=adCode%>';
    var userCode = '<%=userCode%>'--%>
    var userCode = '${sessionScope.USERCODE}';
    var AD_CODE = '${sessionScope.ADCODE}';
    var grid_error_message = '';


  /*   var zqlb = getUrlParam('zqlb');//类型：一般/专项
    if (zqlb == null || zqlb == '' || zqlb.toLowerCase() == 'null') {
        zqlb = '01';
    }*/
    var zqlb ="${fns:getParamValue('zqlb')}";
    if (isNull(zqlb)) {
        zqlb = '01';;
    }
 /*   var fxfs = getUrlParam('fxfs');//方式：公开/定向
    if (fxfs == null || fxfs == '' || fxfs.toLowerCase() == 'null') {
        fxfs = '01';
    }*/
    var fxfs ="${fns:getParamValue('fxfs')}";
    if (isNull(fxfs)) {
        fxfs = '01';
    }
  /*  var type = getUrlParam('type');//类别：新增/置换
    if (type == null || type == '' || type.toLowerCase() == 'null') {
        if(fxfs == '02'){
             type = '02';
        }else{
             type = '01';
        }
        
    }*/
    var type ="${fns:getParamValue('type')}";
    if (isNull(type)) {
        if (fxfs == '02') {
            type = '02';
        } else {
            type = '01';
        }
    }
    /**
     * 通用配置json
     */
    
    var ndjhhzqr_json_common = {
        items: { 
             '001': [
                 {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                            	reloadGrid();
                            }
                        }
                    },
                {
                    xtype: 'button',
                    text: '确认',
                    name: 'btn_insert',
                    icon: '/image/sysbutton/add.png',
                    handler: function (btn) { 
	                     Ext.Msg.confirm('提示', '是否确认？', function (btn_confirm) {
	                          if (btn_confirm == 'yes') {
	                          		updateHZDataSelectedList(btn);
	                          }
	                     });
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        dooperation();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ],
            '002': [
                 {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                            	reloadGrid();
                            }
                        }
                    },
                  { 
                    xtype: 'button',
                    text: '撤销确认',
                    name: 'btn_update',
                    icon: '/image/sysbutton/edit.png',
                    handler: function (btn) {
                        // 检验是否选中数据
                        Ext.Msg.confirm('提示', '是否确认？', function (btn_confirm) {
	                          if (btn_confirm == 'yes') {
	                          		updateHZDataSelectedList(btn); 
	                          }
	                     });
                    }
                },
                {
                    xtype: 'button',
                    text: '操作记录',
                    name: 'log',
                    icon: '/image/sysbutton/log.png',
                    handler: function () {
                        dooperation();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ] 
        },
        store: {
            WF_STATUS: DebtEleStore(json_debt_zt3)
        }
    };
      
    /**
	 *撤销确认按钮实现
	 */
	function updateHZDataSelectedList(btn){ 
        // 获取选中数据 
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        
                button_name = btn.text;
                var ids = new Array();
                for (var i in records) { 
                    ids.push(records[i].get("HZ_ID"));
                }
                //发送ajax请求，删除数据
                $.post("/updateNdjhHzQrByHzId.action", {
                    ids: ids,
                    WF_STATUS:WF_STATUS,
                    USER_CODE:userCode
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
   
    /**
     * 通用函数：获取url中的参数
     */
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    }
    /**
     操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            pcjh_id = records[0].get("ZD_ID");
            fuc_getWorkFlowLog(pcjh_id);
        }
    }
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
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
                    items: ndjhhzqr_json_common.items[WF_STATUS]
                }
            ],
            items: [
                initContentTree({
                    items_tree: function () {
                        return [
                            initContentTree_area()
                        ]
                    }
                }),//初始化左侧树
                initContentRightPanel()//初始化右侧2个表格
            ]
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
                flex: 1
            },
            border: false,
            dockedItems: tbar,
            items: [
                initContentGrid(),
                initContentDetilGrid()
            ]
        });
    }
    var tbar = [];
    if(fxfs == '01'){
       var tbar =  [
                {
                    xtype: 'toolbar',
                    layout: 'column',
                    defaults: {
                        margin: '5 5 5 5',
                        //columnWidth: .3,
                        width: 210,
                        labelWidth: 80//控件默认标签宽度
                    },
                    items: [
                         {
                        fieldLabel: '发行方式',
                        name: 'FXFS',
                        xtype: 'combobox',
                        store: DebtEleStore(json_debt_fxfs),
                        editable: false, 
                        readOnly: true,
                        displayField: 'name',
                        valueField: 'code',
                        value: fxfs
                    },
                {
                    xtype: 'combobox',
                    fieldLabel: '债券类别',
                    name: 'TYPE_NAME',
                    displayField: 'name',
                    editable: false,
                    valueField: 'id', 
                    value:type,
                    store: DebtEleStore(json_debt_zqlb),
                    listeners: {
                        change: function (self, newValue) {
                           type = self.getValue();
                            //刷新当前表格
                            reloadGrid({
	                            type:type 
	                        });
                        }
                    }
                },
                {
                    xtype: 'treecombobox',
                    fieldLabel: '债券类型',
                    name: 'ZQLB_NAME',
                    displayField: 'name',
                    editable: false,
                    valueField: 'id', 
                    value:zqlb,
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    listeners: {
                        change: function (self, newValue) { 
                            zqlb = self.getValue();
                            //刷新当前表格
                            reloadGrid({
	                            zqlb: zqlb
	                        });
                        }
                    }
                 },
                    {
                        fieldLabel: '申报年度',
                        name: 'APPLY_YEAR',
                        xtype: 'combobox',
                        value: new Date().getFullYear()+1,
                        store: DebtEleStore(json_debt_year),
                        editable: false,
                        displayField: 'name',
                        valueField: 'code',
                        listeners: { 
				 				change: function (self, newValue) { 
				                            //刷新当前表格
				                            reloadGrid();
				                 }
                        }
                        
                    }
                    ]
                }
            ];
    }else{
        var tbar =  [
                {
                    xtype: 'toolbar',
                    layout: 'column',
                    defaults: {
                        margin: '5 5 5 5',
                        //columnWidth: .3,
                        width: 210,
                        labelWidth: 80//控件默认标签宽度
                    },
                    items: [
                         {
                        fieldLabel: '发行方式',
                        name: 'FXFS',
                        xtype: 'combobox',
                        store: DebtEleStore(json_debt_fxfs),
                        editable: false, 
                        readOnly: true,
                        displayField: 'name',
                        valueField: 'code',
                        value: fxfs
                    },
                {
                    xtype: 'combobox',
                    fieldLabel: '债券类别',
                    name: 'ZQLB_NAME',
                    displayField: 'name',
                    readOnly: true,
                    fieldStyle:'background:#E6E6E6',
                    valueField: 'id', 
                    value:'02',
                    store: DebtEleStore(json_debt_zqlb) 
                },
                {
                    xtype: 'treecombobox',
                    fieldLabel: '债券类型',
                    name: 'TYPE_NAME',
                    displayField: 'name',
                    editable: false,
                    valueField: 'id', 
                    value:type,
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    listeners: {
                        change: function (self, newValue) {
                           type = self.getValue()
                            //刷新当前表格
                            reloadGrid({
	                            type:type 
	                        });
                        }
                    }
                 },
                    {
                        fieldLabel: '申报年度',
                        name: 'APPLY_YEAR',
                        xtype: 'combobox',
                        value: new Date().getFullYear()+1,
                        store: DebtEleStore(json_debt_year),
                        editable: false,
                        displayField: 'name',
                        valueField: 'code',
                        listeners: { 
				 				change: function (self, newValue) { 
				                            //刷新当前表格
				                            reloadGrid();
				                 }
                        }
                        
                    }
                    ]
                }
            ];
    }
    
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [ 
         {xtype: 'rownumberer', width: 40},
        {dataIndex: "AD_NAME", width: 150, type: "string", text: "地区"},
        {dataIndex: "CREATE_DATE", width: 150, type: "string", text: "汇总日期"},
         {dataIndex: "ZQLB_NAME",width: 100,type: "string",text: "债券类别"},
         {dataIndex: "TYPE_NAME",width: 100,type: "string",text: "债券类型"}, 
         {dataIndex: "FX_MONTH",width: 100,type: "string",text: "发行月份"},
          {dataIndex: "APPLY_YEAR",width: 100,type: "string",text: "申报年度"},
        {dataIndex: "APPLY_AMOUNT", width: 150, type: "float", text: "申请金额(万元)"},
        {dataIndex: "CREATE_USER_NAME", width: 150, type: "string", text: "经办人"}  
        ];
        var simplyGrid = new DSYGridV2();
        return simplyGrid.create({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                WF_STATUS: WF_STATUS,
                type:type,
                zqlb:zqlb,
                fxfs:fxfs
            },
            dataUrl: 'getNdjhHzBillQr.action',
            checkBox: true,
           // rowNumber: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: ndjhhzqr_json_common.store['WF_STATUS'],
                    width: 110,
                    labelWidth: 30,
                    labelAlign: 'right',
                    editable: false, //禁用编辑
                    displayField: "name",
                    valueField: "id",
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(ndjhhzqr_json_common.items[WF_STATUS]);
                             //刷新当前表格
                            reloadGrid({
	                            WF_STATUS: newValue
	                        });
                        }
                    }
                } 
            ],
            tbarHeight: 50, 
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            rowNumber: {
               rowNumber: false// 显示行号
            },
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    
                        DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['HZ_ID'] = record.get('HZ_ID');
                        DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                    
                   
                }
            }
        });
    }
    /**
     * 初始化明细表格
     */
    function initContentDetilGrid(callback) {
        var headerJson = [
           {xtype: 'rownumberer', width: 40},
           {
                dataIndex: "CXJG_CODE",
                width: 150,
                type: "string",
                text: "承销机构编码"
            },
            {
                dataIndex: "CXJG_NAME",
                width: 150,
                type: "string",
                text: "承销机构名称"
            },
            {dataIndex: "CX_AMT", type: "float", text: "承销金额(万元)", width: 150,
                editor: {
                    xtype: "numberfield",
                    emptyText: '0.00',
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }
          	},
          	{
                dataIndex: "BFB", type: "float", text: "上浮BP/利率", width: 120,
                editor: {
                    xtype: "numberfield",
                    emptyText: '0.00',
                    hideTrigger: true,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }
            }, 
             {
                dataIndex: "REMARK1",
                width: 200,
                type: "string",
                text: "备注"
            }
			];    
         
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'contentGrid_detail',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            rowNumber: true,
            autoLoad: false,
            border: false,
            height: '50%',
            pageConfig: {
                enablePage: false
            },
            dataUrl: 'getNdjhHzDetail.action'
        };
        var grid = simplyGrid.create(config);
        return grid;
    }
    
    
   /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
    */
    function reloadGrid(param, param_detail) {
     
            var grid = DSYGrid.getGrid('contentGrid');
            var store = grid.getStore();
             var apply_year = Ext.ComponentQuery.query('combobox[name="APPLY_YEAR"]')[0].value; 

            //增加查询参数
            store.getProxy().extraParams['WF_STATUS'] = WF_STATUS;  
            store.getProxy().extraParams['AD_CODE'] = AD_CODE; 
            store.getProxy().extraParams['APPLY_YEAR'] = apply_year;   
            store.getProxy().extraParams['zqlb'] = zqlb; 
            store.getProxy().extraParams['type'] = type;

            if (typeof param != 'undefined' && param != null) {
                for (var name in param) {
                    store.getProxy().extraParams[name] = param[name];
                }
            }
            //刷新
            store.loadPage(1);
            //刷新下方表格,置为空
            if (DSYGrid.getGrid('contentGrid_detail')) {
                var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
                //如果传递参数不为空，就刷新明细表格
                if (typeof param_detail != 'undefined' && param_detail != null) {
                    for (var name in param_detail) {
                        store_details.getProxy().extraParams[name] = param_detail[name];
                    }
                    store_details.loadPage(1);
                } else {
                    store_details.removeAll();
                }
       }
    }
    
  
</script>
</body>
</html>