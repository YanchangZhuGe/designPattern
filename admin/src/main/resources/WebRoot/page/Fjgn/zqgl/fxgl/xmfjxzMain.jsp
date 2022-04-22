<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>项目附件下载</title>
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript" src="/js/debt/xmInfo.js"></script>
    <script type="text/javascript" src="/js/debt/xmsySzysGrid.js"></script>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
        }

        span.required {
            color: red;
            font-size: 100%;
        }
    </style>
</head>
<body>
<script type="text/javascript">
    /**
     * 获取登录用户
     */
    var userCode = '${sessionScope.USERCODE}';
    var userAD = '${sessionScope.ADCODE}'.replace(/00$/, "");
    //全局变量
    var TREE_NODE_ID = '';  //当前所选树节点id
    var TREE_LEAF = '';//当前所选树节点是否叶子节点
    var TREE_NODE_NAME = '';//当前所选树节点名称
    var mhcx = '';//模糊查询
    var BOND_TYPE_ID = '';//债券类型过滤
    var STATUS_ID = '';//单据状态
    var RULE_IDS = '';//必录附件
    var SBLX =GxdzUrlParam='34'?'13': '11';//上报类型，默认限额申报
    //债券类型数据源
    var zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB',{condition:" AND GUID = '01' OR GUID = '02'"});
    var AD_CODE_CHOSE;
    var GxdzUrlParam = "${fns:getParamValue('GxdzUrlParam')}";// url参数：省级区划编码安徽（34）
    Ext.define('treeModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'text'},
            {name: 'id'}
        ]
    });
    var IS_XMBCXX = '${fns:getSysParam("IS_XMBCXX")}';  //获取系统参数 项目补充信息是否显示
    var IS_FZJCK = '${fns:getSysParam("IS_FZJCK")}';
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    var qhStore = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getRegTreeDataNoCache.action',
            reader: {
                type: 'json'
            }
        },
        root: 'nodelist',
        model: 'treeModel',
        autoLoad: true
    });
    //表头
    var headerJson = [
        {xtype: 'rownumberer', width: 45,text:''},
        {dataIndex: "ID", width: 150, type: "string", text: "唯一ID", hidden: true},
        {dataIndex: "AD_CODE", width: 110, type: "string", text: "区划编码"},
        {dataIndex: "AD_NAME", width: 110, type: "string", text: "区划名称"},
        {dataIndex: "AG_NAME", width: 250, type: "string", text: "申报单位"},
        {dataIndex: "XM_ID", width: 150, type: "string", text: "项目ID", hidden: true},
        {
            dataIndex: "XM_NAME", width: 330, type: "string",text: "项目名称",
            renderer: function (data, cell, record) {
                var result = '<a href="javascript:void(0);" onclick="initWin_xmInfo(\'' + record.get('XM_ID') + '\',\'' + record.get('ID') + '\')">' +data + '</a>';
                return result;
            }
        },
        {dataIndex:'STATUS_ID',width:150,type:'string',text:'单据状态ID',hidden:true},
        {
            dataIndex:'STATUS_NAME',width:150,type:'string',text:'单据状态',
            renderer: function (data, cell, record) {
                var url='/page/plat/wf/workFlowHis.jsp?YWSJID='+record.get('YWSJID')+'&XM_ID='+record.get('XM_ID')+'&FLOW_BRANCH='+record.get('FLOW_BRANCH');
                return '<a href = "#" onclick ="showwindows(\''+url +'\')">' + data + '</a>';
            }
        },
        {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
        {dataIndex: "BILL_YEAR", type: "string", text: "年度"},
        {dataIndex: "IS_FXJH", type: "string", text: "计划类型",hidden: true},
        {
            header: '申请金额(万元)', colspan: 2, align: 'center', columns: [
                {
                    dataIndex:  "APPLY_AMOUNT1", width: 160, type: "float", text: "当年申请金额", summaryType: 'sum',
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000 , '0,000.00####');
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value/10000 , '0,000.00####');
                    }
                },
                {
                    dataIndex: "APPLY_AMOUNT_TOTAL", width: 160, type: "float", text: "申请总金额", summaryType: 'sum',
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000 , '0,000.00####');
                    },
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value/10000 , '0,000.00####');
                    }
                }]
        },
        {dataIndex: "BOND_TYPE_ID", type: "string", text: "申请类型ID",hidden:true},
        {dataIndex: "BOND_TYPE_NAME", type: "string", text: "申请类型"},
        {dataIndex: "BATCH_NAME", width: 150, type: "string", text: "申报批次"},
        {dataIndex: "BILL_NO", width: 150, type: "string", text: "申报单号", hidden: true},
        {dataIndex: "APPLY_DATE", type: "string", text: "申报日期"},
        {dataIndex: "APPLY_INPUTOR", type: "string", text: "经办人"},
        {dataIndex: "LX_YEAR", type: "string", text: "立项年度"},
        {dataIndex: "JSXZ_NAME", type: "string", text: "建设性质"},
        {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质"},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型"},
        {
            dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算(万元)",
            renderer: function (value) {
                return Ext.util.Format.number(value/10000 , '0,000.00####');
            },
        },
        {dataIndex: "START_DATE_PLAN", width: 120, type: "string", text: "计划开工日期"},
        {dataIndex: "END_DATE_PLAN", width: 120, type: "string", text: "计划竣工日期"},
        {dataIndex: "START_DATE_ACTUAL", width: 120, type: "string", text: "实际开工日期"},
        {dataIndex: "END_DATE_ACTUAL", width: 120, type: "string", text: "实际竣工日期"},
        {dataIndex: "BUILD_STATUS_NAME", type: "string", text: "建设状态"},
        {dataIndex: "REMARK", type: "string", width: 150, text: "备注"},
    ];
    /* 单据类型限额库数据源 */
    var djzt_xek_store = DebtEleStore([
        {id:'01',code:'01 已退出',name:'已退出'},
        {id:'10',code:'10 未送审',name:'未送审'},
        {id:'11',code:'11 未复核',name:'未复核'},
        {id:'12',code:'12 未审核',name:'未审核'},
        {id:'13',code:'13 被退回',name:'被退回'},
        {id:'20',code:'20 未汇总',name:'未汇总'},
        {id:'25',code:'25 上报中',name:'上报中'},
        {id:'30',code:'30 完成限额项目流程',name:'完成限额项目流程'}
    ]);
    /* 单据类型需求库数据源 */
    var djzt_xqk_store = DebtEleStore([
        {id:'01',code:'01 已退出',name:'已退出'},
        {id:'10',code:'10 未送审',name:'未送审'},
        {id:'11',code:'11 未复核',name:'未复核'},
        {id:'12',code:'12 未审核',name:'未审核'},
        {id:'20',code:'20 未汇总',name:'未汇总'},
        {id:'25',code:'25 上报中',name:'上报中'},
        {id:'30',code:'30 完成需求项目流程',name:'完成需求项目流程'}
    ]);
    /* 单据类型限额库数据源 */
    var djzt_cbk_store = DebtEleStore([
        {id:'01',code:'01 已退出',name:'已退出'},
        {id:'10',code:'10 未送审',name:'未送审'},
        {id:'11',code:'11 未复核',name:'未复核'},
        {id:'12',code:'12 未审核',name:'未审核'},
        {id:'13',code:'13 被退回',name:'被退回'},
        {id:'20',code:'20 未汇总',name:'未汇总'},
        {id:'25',code:'25 上报中',name:'上报中'},
        {id:'30',code:'30 完成储备项目流程',name:'完成储备项目流程'}
    ]);
    /*申报类型数据源*/
    var sblx_store = DebtEleStore([
        {id:'11',code:'11 限额申报',name:'限额申报'},
        {id:'12',code:'12 需求申报',name:'需求申报'},
        {id:'13',code:'13 储备申报',name:'储备申报'}
    ]);
    /* 定义必录附件查询条件 */
    Ext.define('blfjModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'id'},
            {name: 'code'},
            {name: 'text'},
            {name: 'leaf'}
        ]
    });
    var blfj_store=Ext.create('Ext.data.TreeStore',{
        model: 'blfjModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getblfjTreeData.action',
            extraParams: {},
            reader: {
                type: 'json'
            }
        },
        //root: {name: '必录附件'},
        root: 'nodelist',
        autoLoad: true,
    });
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        if (typeof (Ext) == "undefined" || Ext == null) {
            //动态加载js
            $.ajaxSetup({
                cache: true
            });
            $.getScript('../../third/ext5.1/ext-all.js', function () {
                initMain();
            });
        } else {
            initMain();
        }
    });
    //弹出窗方式显示操作记录
    function showwindows(url){
        Ext.create('Ext.window.Window', {
            width: 750, // 窗口宽度
            height: 400, // 窗口高度
            layout: 'fit',
            maximizable: true,
            items:[{
                html:'<iframe id = "iframe_data" frameborder="0" width=100% height=100% src="'+url+'" />'
            }]
        }).show();

    };
    /**
     * 主界面初始化
     */
    function initMain() {
        //panel上方的工具栏
        var toolBar = Ext.create('Ext.toolbar.Toolbar',{
            border:false,
            items:[
                {
                    xtype:'button',
                    name:'search',
                    text:'查询',
                    icon:'/image/sysbutton/search.png',
                    handler:function(btn){
                        reloadGrid();
                    }
                },
                {
                    xtype:'button',
                    name:'xz',
                    text:GxdzUrlParam=='34'?'导出':'批量下载',
                    icon:'/image/sysbutton/download.png',
                    handler:function(btn){
                        xmfjxz();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        });
        /*
            定义批次树tree
        */
        Ext.define('pcTree',{
            extend:'Ext.data.Model',
            fields:[
                {name:'id'},
                {name:'code'},
                {name:'text'},
                {name:'leaf'}
            ]
        });
        var pcStore = Ext.create('Ext.data.TreeStore',{
            model:'pcTree',
            proxy:{
                type: 'ajax',
                method: 'POST',
                url: 'getpcTreeData.action',
                extraParams:{
                    SBLX:SBLX
                },
                reader: {
                    type: 'json'
                }
            },
            root: 'nodelist',
            autoLoad: true,
            listeners: {
                load: function (self) {
                    initTree();
                }
            }
        });

        var config = {
            itemId: 'xmxxGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            enableLocking: false,
            flex: 5,
            region: 'center',
            autoLoad: false,
            dataUrl: 'getBillsByPc.action',
            params:{
                BATCH_NO:TREE_NODE_ID,
                IS_LEAF:TREE_LEAF?'true':'false',
                BOND_TYPE_ID:BOND_TYPE_ID,
                STATUS_ID:STATUS_ID,
                RULE_IDS:RULE_IDS,
                mhcx: mhcx,
                GxdzUrlParam:GxdzUrlParam
            },
            checkBox: true,
            border: false,
            height: '100%',
            tbar: [
                {
                    xtype: "textfield",
                    fieldLabel: '模糊查询',
                    name:'mhcx1',
                    width: 250,
                    labelWidth: 60,
                    labelAlign: 'right',
                    emptyText: '请输入项目名称',
                    enableKeyEvents: true,
                    listeners: {
                        'change':function(self,newValue){
                            mhcx = newValue;
                        },
                        'keydown': function (self, e) {
                            var key = e.getKey();
                            if (key == Ext.EventObject.ENTER) {
                                reloadGrid();
                            }
                        }
                    }
                }
            ],
            dockedItems:[
                {
                    xtype:'toolbar',
                    dock:'top',
                    layout:'hbox',
                    items:[
                        {
                            xtype:'combobox',
                            fieldLabel:'申报类型',
                            name:'SBLX',
                            labelWidth: 60,
                            width: 200,
                            labelAlign: 'right',
                            displayField:'name',
                            valueField:'id',
                            editable:false,
                            store:sblx_store,
                            hidden:GxdzUrlParam =='34'?true:false,
                            value:'11',//默认限额申报
                            allowBlank:false,
                            listeners: {
                                'change': function (self,newValue,oldValue) {
                                    if(newValue==oldValue){
                                        return;
                                    }
                                    /*
                                        1.刷新左侧批次树
                                        2.刷新单据状态
                                        3.更改数据取数视图
                                     */
                                    SBLX = newValue;
                                    //1
                                    var pcTree = Ext.ComponentQuery.query('treepanel#pcTree')[0];
                                    pcTree.getStore().getProxy().extraParams.SBLX = newValue;
                                    pcTree.getStore().reload();
                                    //2
                                    var djztWidget = self.next('combobox[name=STATUS_ID]');
                                    if('11'==newValue){
                                        djztWidget.setStore(djzt_xek_store);
                                    }else if('12'==newValue){
                                        djztWidget.setStore(djzt_xqk_store);
                                    }else if('13' == newValue){
                                        djztWidget.setStore(djzt_cbk_store);
                                    }
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype:'treecombobox',
                            fieldLabel:'债券类型',
                            name:'BOND_TYPE_ID_1',
                            labelWidth: 60,
                            width: 200,
                            labelAlign: 'right',
                            displayField:'name',
                            valueField:'id',
                            editable:false,
                            store:zqlx_store,
                            listeners: {
                                'change': function (self,newValue,oldValue) {
                                    BOND_TYPE_ID = newValue;
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype:'combobox',
                            fieldLabel:'单据状态',
                            name:'STATUS_ID',
                            labelWidth: 60,
                            width: 200,
                            hidden:GxdzUrlParam =='34'?true:false,
                            labelAlign: 'right',
                            displayField:'name',
                            valueField:'id',
                            editable:false,
                            store:djzt_xek_store,
                            listeners: {
                                'change': function (self,newValue,oldValue) {
                                    STATUS_ID = newValue;
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype:'treecombobox',
                            fieldLabel:'必录附件',
                            name:'RULE_ID',
                            labelWidth: 60,
                            width: 200,
                            labelAlign: 'right',
                            displayField:'text',
                            valueField:'id',
                            editable:false,
                            rootVisible:false,
                            checkModel:'multi',
                            store:blfj_store,
                            listeners: {
                                'select': function (self,newValue,oldValue) {
                                    RULE_IDS = self.getValue();
                                }
                            }
                        },
                        {
                            xtype: 'treecombobox',
                            itemId: 'AD_CODE_CHOSE',
                            fieldLabel: '区划选择',
                            labelWidth: 60,
                            width: 200,
                            name: 'AD_CODE',
                            enableKeyEvents: true,
                            displayField: 'text',
                            valueField: 'code',
                            rootVisible: false,
                            store: qhStore,
                            listeners: {
                                'change': function (self,newValue,oldValue) {
                                    AD_CODE_CHOSE = newValue;
                                    reloadGrid();
                                }
                            }
                        }
                    ]
                }],
            pageConfig: {
                enablePage:true,
                pageNum: true,//设置显示每页条数
                pageNumStyle:'combo',
                pageSize:100
            }
        };
        var grid = DSYGrid.createGrid(config);
        //总面板
        var Panel = Ext.create('Ext.panel.Panel', {
            width: '100%',
            height: '100%',
            renderTo: Ext.getBody(),
            //border:false,
            tbar:toolBar,
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            items: [
                {
                    xtype: 'treepanel',//左侧树
                    itemId: 'pcTree',
                    height: '100%',
                    region: 'west',
                    flex:1,
                    store: pcStore,//数据集
                    rootVisible: false,
                    listeners: {
                        itemclick: function (view, record, item, index, e, eOpts) {
                            setTreeNodeData(record);
                            reloadGrid();
                        },
                        afterrender: function (self) {
                            initTree();
                        }
                    }
                },
                grid
            ]
        });
    }
    /**
     * 初始化选中树节点第一条数据
     */
    function initTree() {
        var tree = Ext.ComponentQuery.query('treepanel#pcTree')[0];
        var rootNode = tree.getRootNode();
        if (rootNode.getChildAt(0)) {//获取“专项债券”节点
            var record = rootNode.getChildAt(0);
            tree.getSelectionModel().select(record);
            //设置全局变量
            setTreeNodeData(record);
            //刷新获取数据
            reloadGrid();
        }
    }
    /**
     * 点击左侧树节点时，重新设置树节点的全局变量信息
     */
    function setTreeNodeData(record) {
        TREE_NODE_ID = record.get('id');
        TREE_LEAF = record.get('leaf');
        TREE_NODE_NAME = record.get('text');
    }
    /**
     *刷新表格 ：申报信息grid
     */
    function reloadGrid(param){
        var store = DSYGrid.getGrid('xmxxGrid').getStore();
        //var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx1"]')[0].getValue();
        //var BOND_TYPE_ID = Ext.ComponentQuery.query('treecombobox[name="BOND_TYPE_ID_1"]')[0].getValue();
        var params = {
            BATCH_NO:TREE_NODE_ID,
            IS_LEAF:TREE_LEAF?'true':'false',
            BOND_TYPE_ID:BOND_TYPE_ID,
            STATUS_ID:STATUS_ID,
            RULE_IDS:RULE_IDS,
            mhcx: mhcx,
            AD_CODE_CHOSE:AD_CODE_CHOSE,
            SBLX:SBLX,
            GxdzUrlParam:GxdzUrlParam
        };
        store.getProxy().extraParams = params;
        //刷新表格内容
        store.reload();
    }
    /* 
    *项目附件下载功能核心代码，胆小勿看
    	·选择批次，若有选择，则下载所选项目上传的附件
    	·选择批次，若没有选择，则下载该批次下的所有项目上传的附件，并给出提示，确认是否下载
    */
    function xmfjxz(){
        if(TREE_NODE_ID==null||typeof TREE_NODE_ID == 'undefined'){
            Ext.Msg.alert('提示','请选择批次！');
            return;
        }
        var records = DSYGrid.getGrid('xmxxGrid').getSelection();
        //判断批次下是否有数据，没有则不执行
        var so = DSYGrid.getGrid('xmxxGrid').getStore();
        if(so.getData().length<=0){
            Ext.Msg.alert('提示','所选批次下没有项目可操作！');
            return;
        }
        if(!records||records.length<=0){
            Ext.Msg.confirm('提示','您未选择申报数据，默认将下载该批次下的所有项目上传附件，是否继续？',function(btn){
                if(btn=='yes'){
                    var store = DSYGrid.getGrid('xmxxGrid').getStore();
                    store.each(function(record){
                        records.push(record);
                    });
                    submit(records);
                }
            });
        }else{
            Ext.Msg.confirm('提示','确认下载该申报数据所关联项目下的附件吗？',function(btn){
                if(btn=='yes'){
                    submit(records);
                }
            });
        }
    }
    /* 提交 */
    function submit(records){
        var xmIds = [];
        records.forEach(function(record){
            xmIds.push(record.get('XM_ID'));
        });
        Ext.Msg.wait('正在下载文件到服务器，请稍等……','提示',{text:'加载中……'});
        Ext.Ajax.request({
            url:'getXmfj.action',
            method:'POST',
            timeout:1800000,//响应时间超过三十分钟报错
            params:{
                xmIds:xmIds,
                ruleIds:RULE_IDS,
                BATCH_NO:TREE_NODE_ID,
                BATCH_NAME:TREE_NODE_NAME
            },
            success:function(response){
                var text = Ext.decode(response.responseText);
                if(text.success){
                    var file_name = text.file_name;
                    var message = text.message;
                    Ext.Msg.close();
                    //文件太大，给出提示
                    if(!!message){
                        Ext.Msg.confirm('提示',message,function(btn){
                            if(btn=='yes'){
                                Ext.Msg.wait('正在压缩文件，请稍等……','提示',{text:'加载中……'});
                                $.post('/downloadXmFileZip.action',{
                                    file_name:file_name,
                                    xzfs:'2'
                                },function(data){
                                    Ext.Msg.close();
                                    Ext.Msg.alert('提示',data.message);
                                },"json");
                            }else{
                                window.location.href = 'downloadXmFileZip.action?file_name=' + encodeURI(encodeURI(file_name))+'&xzfs=1';
                            }
                        });
                    }else{
                        window.location.href = 'downloadXmFileZip.action?file_name=' + encodeURI(encodeURI(file_name))+'&xzfs=1';
                    }
                }else{
                    //先关闭滚动条
                    Ext.Msg.close();
                    Ext.Msg.alert('提示','文件下载失败！'+text.message);
                }
                //刷新grid
                DSYGrid.getGrid('xmxxGrid').getStore().loadPage(1);
            },
            failure:function(reponse){
                //var text = Ext.decode(response.responseText);
                //先关闭滚动条
                Ext.Msg.close();
                Ext.Msg.alert('提示','文件下载失败！');
            }
        });
    }
</script>
</div>
</body>
</html>