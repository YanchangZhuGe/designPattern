<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>借新还旧主界面</title>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    <%	/*获取登录用户*/
        String AD_CODE = (String) request.getSession().getAttribute("ADCODE");
        String userCode = (String) request.getSession().getAttribute("USERCODE");//获取登录用户

    %>
  /*  var node_code = getQueryParam("node_code");//当前节点id
    var node_type = getQueryParam("node_type");//当前节点id*/
    var node_code ="${fns:getParamValue('node_code')}";
    var node_type ="${fns:getParamValue('node_type')}";
    var AD_CODE = '<%=AD_CODE%>';
    var USER_AD_CODE= '<%=userCode%>';
    var v_child = '1';
    var userName_jbr = top.userName ;
    var json_zt = json_debt_zt11;//当前状态下拉框json数据
    var button_name = '';//当前操作按钮名称
    var button_text = '';
    var button_status = '';//当前操作按钮状态，即为按钮name
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
/*    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    if (node_code == null || node_code == '' || node_code.toLowerCase() == 'null') {
        node_code = '1';
    }
    if (node_type == null || node_type == '' || node_type.toLowerCase() == 'null') {
        node_type = 'hkdrsq';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    if (isNull(node_code)) {
        node_code = '1';
    }
    if (isNull(node_type)) {
        node_type = 'hkdjsq';
    }
    /**
     * 通用配置json
     */
    var json_common = {
        hkdrsq: 'hkdrsq.js',//填报
        hkdrsh: 'hkdrsh.js'//审核
    };
    var HEADERJSON = [
        {
            xtype: 'rownumberer', summaryType: 'count', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text:"**HKDJ_ID", dataIndex:"HKDJ_ID",hidden:true,type:"string"},
        {text: "导入文件名", dataIndex: "FILE_NAME", width: 200, type: "string"},
        {text: "地区", dataIndex: "AD_NAME", width: 200, type: "string"},
        {text: "偿还金额",dataIndex:"CHBX_AMT",width:175,type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {text: "偿还兑付费金额", dataIndex: "CHDFF_AMT", width: 175, type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {text: "偿还剩余资金", dataIndex: "CHSY_AMT", width: 175, type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {text: "偿还剩余兑付费", dataIndex: "DFFSY_AMT", width: 175, type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {text: "导入用户", dataIndex: "USER_AD_NAME", width: 130, type: "string"},
        {text: "导入日期", dataIndex: "UPLOAD_DATE", width: 130, type: "string"}
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
        {text:"债券名称",dataIndex:"ZQ_NAME",width:150,type:"string",
            renderer: function (data, cell, record) {
                var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+AD_CODE;
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';
            }
        },
        {text:"债券编码", dataIndex:"ZQ_CODE",width:150,type:"string",hidden:false
        },
        {text:"还款类型", dataIndex:"HKLX",width:150,type:"string",hidden:false
        },
        {text:"到期日期", dataIndex:"DQ_DATE",width:150,type:"string",hidden:false
        },
        {
            text: "到期金额", dataIndex: "DQJE", width: 175, type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {
            text: "登记偿还本息金额", dataIndex: "HK_AMT", width: 175, type: "float",summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            }
        },
        {
            text: "登记偿还兑付费金额", dataIndex: "DFF_AMT", width: 175, type: "float",summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
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
            //根据节点名称初始化状态下拉框store
            if (node_type == 'zxtzsq'){
                json_zt = json_debt_zt11;
            };
            if(node_type=='zxtzsh'){
                json_zt = json_debt_zt11;
            };

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
                    initContentTree({
                        areaConfig: {
                            params: {
                                CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                            }
                        },
                        param: json_common.items_content_tree_config,
                        items_tree: json_common.items_content_tree
                    }),//初始化左侧树
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
            dataUrl: "/getMxData.action",
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'cellEdit',
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
            dataUrl: '/getMainData.action',
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            params: {
                AD_CODE:AD_CODE,
                WF_STATUS:WF_STATUS,
                USERCODE:USER_AD_CODE
            },
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_zt),
                    width: 110,
                    labelWidth: 30,
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
            ],
            features: [{
                ftype: 'summary'
            }],
            listeners: {
                itemclick: function (self, record) {
                    var mx_grid_2=DSYGrid.getGrid("contentGrid_detail");
                    mx_grid_2.getStore().getProxy().extraParams={
                        HKDJ_ID:record.get("HKDJ_ID")
                    };
                    mx_grid_2.getStore().loadPage(1);
                },
                itemdblclick: function (self, record) {
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
                initContentDetilGrid()
            ]
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
            var store = grid.getStore();
               store.getProxy().extraParams={
                   WF_STATUS:WF_STATUS,
                   AD_CODE:AD_CODE,

               };
            //刷新
            store.loadPage(1);
            //刷新下方表格,置为空
            grid = DSYGrid.getGrid('contentGrid_detail');
            store = grid.getStore();
            store.getProxy().extraParams={
            HKDJ_ID:""
           };
        //刷新
        store.loadPage(1);
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