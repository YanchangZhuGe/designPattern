<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>年度计划主界面</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }

        .grid-cell {
            background-color: #ffe850;
        }
    </style>

</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/js/debt/Map.js"></script>
<%--初始化全屏按钮--%>
<script type="text/javascript">

 /*   var wf_id = getQueryParam('wf_id');//当前流程id
    var node_code = getQueryParam('node_code');//当前节点id
    var is_end = getQueryParam("is_end");*/
 var wf_id ="${fns:getParamValue('wf_id')}";
 var node_code ="${fns:getParamValue('node_code')}";
 var is_end ="${fns:getParamValue('is_end')}";
 var fxyear = new Date().getFullYear() + 1;//默认值为下一年度
    var chzjlyStore = null;
    var status_zt = null;
    if (node_code == "1") {
        status_zt = DebtEleStore(json_debt_zt1);
    } else {
        if (is_end == "1") {
            status_zt = DebtEleStore(json_debt_zt2_3);
        } else {
            if (node_code == "2") {
                status_zt = DebtEleStore(json_debt_zt2);
            }
        }
    }

  /*  var zqlb = getQueryParam('zqlb');//类型：一般/专项
    if (zqlb == null || zqlb == '' || zqlb.toLowerCase() == 'null') {
        zqlb = '01';
    }
    var fxfs = getQueryParam('fxfs');//方式：公开/定向
    if (fxfs == null || fxfs == '' || fxfs.toLowerCase() == 'null') {
        fxfs = '01';
    }
    var type = getQueryParam('type');//类别：新增/置换
    if (type == null || type == '' || type.toLowerCase() == 'null') {
        type = '01';
    }*/
 var zqlb ="${fns:getParamValue('zqlb')}";
 if (isNull(zqlb)) {
     zqlb = '01';;
 }
 var fxfs ="${fns:getParamValue('fxfs')}";
 if (isNull(fxfs)) {
     fxfs = '01';;
 }
 var type ="${fns:getParamValue('type')}";
 if (isNull(type)) {
     type = '01';;
 }
    var button_name = '';//当前操作按钮名称
  /*  var WF_STATUS = getQueryParam('WF_STATUS');//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
 var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
 if (isNull(WF_STATUS)) {
     WF_STATUS = '01';;
 }
    /**
     * 通用配置json
     */
    var json_common = {};
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
    	var items = null;
    	if(type == '01'){
    		items =  [
                initContentTree(),//初始化左侧树
                initContentRightPanel()//初始化右侧2个表格
            ];
    	}else{
    		items =  [
                initContentTree({
                    items_tree: function () {
                        return [
                            initContentTree_area()
                        ]
                    }
                }),//初始化左侧树
                initContentRightPanel()//初始化右侧2个表格
            ];
    	}
    	
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
                    items: Ext.Array.union(json_common[wf_id][node_code].items[WF_STATUS], json_common[wf_id][node_code].items['common'])
                }
            ],
            items: items
        });
    }
    /**
     * 初始化右侧panel，放置2个表格
     */
    function initContentRightPanel() {
        chzjlyStore = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: " and code like  '01%' and code like '0102%' "});
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
            dockedItems: json_common[wf_id][node_code].items_content_rightPanel_dockedItems ? json_common[wf_id][node_code].items_content_rightPanel_dockedItems : null,
            items: [
                initContentGrid(),
                initContentDetilGrid()
            ]
        });
    }
    /**
     * 初始化右侧主表格
     */
    function initContentGrid() {
    	var headerJson = null;
    	if(type == '01'){//新增
	    	headerJson = [
	            {xtype: 'rownumberer', width: 40},
	            {dataIndex: 'ID', type: 'string', text: '年度计划ID', "hidden": true},
	            {dataIndex: 'AG_CODE', type: 'string', text: '单位编码', width: 100},
	            {dataIndex: 'AG_NAME', type: 'string', text: '单位名称', width: 300},
	
	            {dataIndex: 'FXFS', type: 'string', text: '发行方式', width: 100},
	            {dataIndex: 'ZQLB', type: 'string', text: '债券类型', width: 100},
	            {dataIndex: 'BATCH', type: 'string', text: '债券批次', width: 100},
	            {dataIndex: 'SQRQ', type: 'string', text: '申请日期', width: 100}
	        ];
    	}else{//置换
    		headerJson = [
	            {xtype: 'rownumberer', width: 40},
	            {dataIndex: 'ID', type: 'string', text: '年度计划ID', "hidden": true},
	            {dataIndex: 'AD_CODE', type: 'string', text: '区划编码', width: 100},
	            {dataIndex: 'AD_NAME', type: 'string', text: '区划名称', width: 300},
	
	            {dataIndex: 'FXFS', type: 'string', text: '发行方式', width: 100},
	            {dataIndex: 'ZQLB', type: 'string', text: '债券类型', width: 100},
	            {dataIndex: 'BATCH', type: 'string', text: '债券批次', width: 100},
	            {dataIndex: 'SQRQ', type: 'string', text: '申请日期', width: 100}
	        ];
    	}

        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            rowNumber: true,
            border: false,
            autoLoad: false,
            height: '50%',
            flex: 1,
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: status_zt,
                    width: 110,
                    labelWidth: 30,
                    editable: false,
                    labelAlign: 'right',
                    displayField: 'name',
                    valueField: 'id',
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(json_common[wf_id][node_code].items[WF_STATUS]);
                            //刷新当前表格
                            reloadGrid({
                                WF_STATUS: WF_STATUS
                            });
                        }
                    }
                }
            ],
            tbarHeight: 50,
            params: {
                WF_STATUS: WF_STATUS,
                WF_ID: wf_id,
                NODE_CODE: node_code,
                ZQLB_ID: zqlb,
                FXFS_ID: fxfs,
                TYPE_ID: type,
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE
            },
            dataUrl: 'getJhglMainGrid.action',
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            listeners: {
                itemclick: function (self, record) {
					
                    AG_NAME = record.get('AG_NAME');
                    //AG_CODE = record.get('AG_CODE');
                    //AD_CODE = record.get('AD_CODE');
                    AD_NAME = record.get('AD_NAME');
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['bill_id'] = record.get('ID');
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['type'] = type;
                    DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                }
            }
        });
    }
    /**
     * 初始化右侧明细表格
     * 修改：添加列：发行方式、发行期限、批次号、汇总日期、上报日期、上报级次、分配日期、分配人、下达日期、下达人
     */
    function initContentDetilGrid() {
        var cxjgStore = DebtEleStoreDB('DEBT_CXJG');
        var sfdmStore = DebtEleStore(json_debt_sf);
        var fxyfStore = DebtEleStore(json_debt_yf_nd);
        var headerJson = [];
        if (type == "01") {//一般
            headerJson = [
                {dataIndex: 'DTL_ID', type: 'string', text: '年度计划明细ID', "hidden": true},
                {dataIndex: 'AG_NAME', type: 'string', text: '项目单位', width: 300},
                {dataIndex: 'XM_CODE', type: 'string', text: '项目编码', width: 200},
                {dataIndex: 'XM_NAME', type: 'string', text: '项目名称', width: 200},
                {dataIndex: 'USE_UNIT_ID', type: 'string', text: '项目管理（使用）单位', width: 250},
                {dataIndex: 'XMLX', type: 'string', text: '项目类型', width: 100},
                {dataIndex: 'JSXZ', type: 'string', text: '建设性质', width: 100},
                {
                    dataIndex: 'CXJG', type: 'string', text: '承销银行',
                    "hidden": true,
                    editor: {
                        xtype: 'combobox',
                        store: cxjgStore,
                        displayField: "name",
                        valueField: "code"
                    },
                    renderer: function (value) {
                        var record = cxjgStore.findRecord('code', value, 0, true, true, true);
                        return record != null ? record.get('name') : value;
                    }
                },
                {
                    dataIndex: 'IS_AGENCY', type: 'string', text: '是否代买',
                    "hidden": true,
                    editor: {
                        xtype: 'combobox',
                        store: sfdmStore,
                        displayField: "name",
                        valueField: "code"
                    },
                    renderer: function (value) {
                        var record = sfdmStore.findRecord('code', value, 0, true, true, true);
                        return record != null ? record.get('name') : value;
                    }
                },
                {
                    dataIndex: 'AGEN_BANK', type: 'string', text: '被代买银行',
                    "hidden": true,
                    editor: {
                        xtype: 'combobox',
                        store: cxjgStore,
                        displayField: "name",
                        valueField: "code"
                    },
                    renderer: function (value) {
                        var record = cxjgStore.findRecord('code', value, 0, true, true, true);
                        return record != null ? record.get('name') : value;
                    }
                },
                {
                    dataIndex: 'FX_MONTH', type: 'string', text: '发行月份',
                    editor: {
                        xtype: 'combobox',
                        store: fxyfStore,
                        displayField: 'name',
                        valueField: 'code'
                    },
                    renderer: function (value) {
                        var record = fxyfStore.findRecord('code', value, 0, true, true, true);
                        return record != null ? record.get('name') : value;
                    }
                },
                {
                    dataIndex: 'FX_AMT', type: 'float', text: '金额(万元)',
                    editor: {
                        xtype: 'numberfield',
                        mouseWheelEnabled: false,
                        hideTrigger: true,
                        allowBlank: false
                    }, width: 150
                }
                //{dataIndex: 'REMARK', type: 'string', text: '备注'}
            ];
        } else {//置换
            headerJson = [
                {dataIndex: 'DTL_ID', type: 'string', text: '年度计划明细ID', "hidden": true},
                {dataIndex: 'ZW_CODE', type: 'string', text: '债务编码', width: 300, "hidden": true},
                {dataIndex: 'ZW_NAME', type: 'string', text: '债务名称', width: 200,
	            renderer: function (data, cell, record) {
	                /*var hrefUrl =  '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
	                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/common/zwyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="zw_id";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
	            }},
                {dataIndex: 'XM_NAME', type: 'string', text: '项目名称', width: 200,
	            renderer: function (data, cell, record) {
	                /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID='+record.get('XM_ID');
	                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
	            }},
                {dataIndex: 'SIGN_DATE', type: 'string', text: '签订日期', width: 100, "hidden": true},
                {dataIndex: 'ZW_XY_NO', type: 'string', text: '协议号', width: 100, "hidden": true},
                {dataIndex: 'LX_RATE', type: 'string', text: '利率(%)', width: 100},
                {dataIndex: 'ZWQX_ID', type: 'string', text: '期限(月)', width: 100},
                {dataIndex: 'ZWYE', type: 'float', text: '债务余额(原币)(万元)', width: 200},
                {dataIndex: 'ZWYE_RMB', type: 'float', text: '债务余额(人民币)(万元)', width: 200},
                {dataIndex: 'YQJE', type: 'float', text: '逾期金额(原币)', width: 150, hidden: true},
                {dataIndex: 'YQJE_RMB', type: 'float', text: '逾期金额(人民币)(万元)', width: 200, hidden: true},
                {dataIndex: 'DQJE', type: 'float', text: '当期金额(原币)', width: 150, hidden: true},
                {dataIndex: 'DQJE_RMB', type: 'float', text: '当期金额(人民币)(万元)', width: 200, hidden: true},
                {dataIndex: 'WLJE', type: 'float', text: '未来应偿还金额(原币)', width: 250, hidden: true},
                {dataIndex: 'WLJE_RMB', type: 'float', text: '未来应偿还金额(人民币)(万元)', width: 230, hidden: true},
                {dataIndex: 'FX_MONTH', type: 'string', text: '发行月份'},
              //  {dataIndex: 'FX_AMT', type: 'float', text: '计划金额(万元)', width: 150},
                {dataIndex: 'ZQFL_ID', type: 'string', text: '债权类型', width: 200, hidden: true},
                {dataIndex: 'ZQR_ID', type: 'string', text: '债权人', width: 200, hidden: true},
                {dataIndex: 'ZQR_FULLNAME', type: 'string', text: '债权人全称', width: 200, hidden: true},
                {dataIndex: 'ZJYT_ID', type: 'string', text: '债务用途', width: 200, hidden: true},
                {dataIndex: 'FM_ID', type: 'string', text: '币种', width: 100},
                {dataIndex: 'HL_RATE', type: 'string', text: '汇率(%)', width: 100},
                //{dataIndex: 'CHZJLY_ID', type: 'string', text: '偿还资金来源'},
                {dataIndex: 'CXJG', type: 'string', text: '承销银行', "hidden": true},
                {dataIndex: 'IS_AGENCY', type: 'string', text: '是否代买', "hidden": true},
                {dataIndex: 'AGEN_BANK', type: 'string', text: '被代买银行', "hidden": true}
                //{dataIndex: 'REMARK', type: 'string', text: '备注'}
            ];
        }

        //如果债券类型为专项债券，在置换表头数组下标16位置删除0个元素，插入1个xxx元素
        if (zqlb == '02') {
            //headerJson.splice(9, 0, {
            headerJson.push({
                dataIndex: 'CHZJLY_ID', type: 'string', text: '偿还资金来源', width: 200,
                editor: {
                    xtype: 'treecombobox',
                    store: chzjlyStore,
                    displayField: "name",
                    valueField: "code",
                    editable: false,
                    rootVisible: false,
                    lines: false,
                    maxPicekerWidth: '100%',
                    selectModel: 'leaf'
                },
                renderer: function (value) {
                    var record = chzjlyStore.findNode('code', value, true, true, true);
                    return record != null ? record.get('name') : value;
                }
            });
        }

        //如果为定向发行增加上浮百分比列
        if (fxfs == '02') {
            headerJson.push({
                dataIndex: 'CXJG', type: 'string', text: '承销银行', readOlny: true
            });

            headerJson.push({dataIndex: 'BFB', type: 'float', text: '上浮百分比'});
        }
//         headerJson.push(
//                 {dataIndex: 'REMARK', type: 'string', text: '备注'}
//         );
	 if(type == "02" && fxfs == "01" && zqlb == "02"){  //公开置换专项
	    	 headerJson.push( 
		    	              { dataIndex: 'XMLB_ID', type: 'string', text: '项目类别', width: 200, 
		    		        	 editor: {
		    		        		 xtype: 'combobox',
		    		        		 displayField: "name",
		    		        		 valueField: "id",
		    		        		 editable: false,
		    		        		 store:DebtEleStore(json_zqgl_fxdf_xmlb)
		    		    	     } ,
		    		            renderer: function (value) { 
		    		            	var store = DebtEleStore(json_zqgl_fxdf_xmlb);
		    		                var record = store.findRecord('id', value,0, true, true, true);
		    		                return record != null ? record.get('name') : value;
		    		            } 
	                      });
	    }
     if(type == "02" && zqlb == "02"){ //公开置换专项 
    	 headerJson.push(  
		            {
		                dataIndex: 'FX_YQ_AMT', type: 'float', text: '逾期金额(万元)',  width: 150,
		                editor: {
		                    xtype: 'numberfield',
		                    mouseWheelEnabled: false,
		                    hideTrigger: true,
		                    editable: false,
		                    allowBlank: false
		                },
		                summaryType: 'sum',
		                summaryRenderer: function (value) {
		                    return Ext.util.Format.number(value, '0,000.00');
		                }
		            },
		            {
		                dataIndex: 'FX_DQ_AMT', type: 'float', text: '当期金额(万元)', width: 150,
		                editor: {
		                    xtype: 'numberfield',
		                    mouseWheelEnabled: false,
		                    hideTrigger: true,
		                    editable: false 
		                },
		                summaryType: 'sum',
		                summaryRenderer: function (value) {
		                    return Ext.util.Format.number(value, '0,000.00');
		                }
		            },
		            {
		                dataIndex: 'FX_TQ_AMT', type: 'float', text: '未来应偿还金额(万元)',  width: 200,
		                editor: {
		                    xtype: 'numberfield',
		                    mouseWheelEnabled: false,
		                    hideTrigger: true,
		                    editable: false, 
		                },
		                summaryType: 'sum',
		                summaryRenderer: function (value) {
		                    return Ext.util.Format.number(value, '0,000.00');
		                }
		            }, 
		            {
			            dataIndex: 'FX_AMT', type: 'float', text: '总金额(万元)',  width: 150, 
			            editor: {
			                xtype: 'numberfield',
			                mouseWheelEnabled: false,
			                hideTrigger: true, 
			                editable: false,
			                allowBlank: false 
			            },
			            renderer: function (value, cellmeta, record) {
			                value = record.get('FX_YQ_AMT') + record.get('FX_DQ_AMT') + record.get('FX_TQ_AMT');
			                record.data.FX_AMT=value;
			                return Ext.util.Format.number(value, '0,000.00');
			            } 
			        },
			        {
			            dataIndex: 'REMARK', type: 'string', text: '备注' 
			        });
    	
    }else{
    	   headerJson.push(
    		    	 
    		        {
    		            dataIndex: 'FX_AMT', type: 'float', text: '总金额(万元)',  width: 150, 
    		            editor: {
    		                xtype: 'numberfield',
    		                mouseWheelEnabled: false,
    		                hideTrigger: true,
    		                allowBlank: false 
    		            },
    		            renderer: function (value, cellmeta, record) { 
    		                return Ext.util.Format.number(value, '0,000.00');
    		            } 
    		        },
    		        {
    		            dataIndex: 'REMARK', type: 'string', text: '备注' 
    		        }
    		    ); 
    } 
        return DSYGrid.createGrid({
            itemId: 'contentGrid_detail',
            flex: 1,
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            border: false,
            height: '50%',
            pageConfig: {
                enablePage: false
            },
            dataUrl: 'getJhglGridDetail.action'
        });
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
            ids.push(records[i].get('ID'));
        }
        button_name = btn.text;
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text,
            animateTarget: btn,
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post('/updateFxdfJhglNdjhNode.action', {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + '成功！',
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
                    }, 'json');
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
    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {
        if (json_common[wf_id][node_code].reloadGrid) {
            json_common[wf_id][node_code].reloadGrid(param);
        } else {
            var grid = DSYGrid.getGrid('contentGrid');
            var store = grid.getStore();

            //增加查询参数
            store.getProxy().extraParams['AD_CODE'] = AD_CODE;
            store.getProxy().extraParams['AG_CODE'] = AG_CODE;

            store.getProxy().extraParams['WF_STATUS'] = WF_STATUS;
            store.getProxy().extraParams['WF_ID'] = wf_id;
            store.getProxy().extraParams['NODE_CODE'] = node_code;
            store.getProxy().extraParams['ZQLB_ID'] = zqlb;
            store.getProxy().extraParams['FXFS_ID'] = fxfs;
            store.getProxy().extraParams['TYPE_ID'] = type;

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
    }
    /**
     * 操作记录
     */
    function operationRecord() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            var zhdw_id = records[0].get('ID');
            fuc_getWorkFlowLog(zhdw_id);
        }
    }
</script>
<script type="text/javascript" src="ndjhXZ.js"></script>
</body>
</html>