<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>项目自定义分组</title>
    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script src="/js/debt/Map.js"></script>
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
    var XMZ_ID = ''; // 项目组ID
    var select_tree_id;
    var current_record;
    var grid_error_message = '';
    /*项目是否已发行债券过滤条件*/
    json_debt_fxzq = [
        {id: "001", code: "001", name: "已发行"},
        {id: "002", code: "002", name: "未发行"}
    ];
    /*发行年度过滤条件*/
    var json_debt_fxyear = [
        {id: "2015", code: "2015", name: "2015年"},
        {id: "2016", code: "2016", name: "2016年"},
        {id: "2017", code: "2017", name: "2017年"},
        {id: "2018", code: "2018", name: "2018年"},
        {id: "2019", code: "2019", name: "2019年"},
        {id: "2020", code: "2020", name: "2020年"},
        {id: "2021", code: "2021", name: "2021年"},
        {id: "2022", code: "2022", name: "2022年"},
        {id: "2023", code: "2023", name: "2023年"},
        {id: "2024", code: "2024", name: "2024年"},
        {id: "2025", code: "2025", name: "2025年"}
    ];
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        initMain();
    });
    /**
     * 主界面初始化
     */
    var a = '';
    function initMain() {
        var tbar = Ext.create('Ext.toolbar.Toolbar', {
            border: false,
            items: [
                {
                    xtype: 'button',
                    text: '增加分组',
                    name: 'btn_add',
                    icon: '/image/sysbutton/edit.png',
                    handler: function () {
                        fuc_addXmzgl(this.name);
                    }
                },{
                    xtype: 'button',
                    text: '编辑分组',
                    name: 'btn_edit',
                    icon: '/image/sysbutton/edit.png',
                    handler: function () {
                        if (XMZ_ID == null || XMZ_ID == '' || XMZ_ID == undefined) {
                            Ext.MessageBox.alert('提示',
                                '请选择树的一个节点！');
                            return;
                        } else {
                            fuc_updateFxgl(this.name);
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '删除分组',
                    name: 'btn_add',
                    icon: '/image/sysbutton/delete.png',
                    handler: function () {
                        if (XMZ_ID == null || XMZ_ID == '' || XMZ_ID == undefined) {
                            Ext.MessageBox.alert('提示',
                                '请选择一个项目组！');
                            return;
                        }
                        $.post("delXmfzInfo.action",{
                                XMZ_ID: XMZ_ID
                            },
                            function (data) {
                                if(data.success == true){
                                    Ext.toast({
                                        html: '保存成功！',
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    // 刷新表格
                                    Ext.ComponentQuery.query('treepanel#xmz_tree')[0].getStore().load();
                                    DSYGrid.getGrid('xmxx_grid').getStore().loadPage(1);
                                }else{
                                    Ext.toast({
                                        html: '保存失败！',
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                }
                            },'JSON');
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        });
        /**
         * 项目树
         */
        Ext.define('xmzTreeModel', {
            extend: 'Ext.data.Model',
            fields: [
                {name: 'text'},
                {name: 'code'},
                {name: 'id'},
                {name: 'leaf'}
            ]

        });
        var unitStore = Ext.create('Ext.data.TreeStore', {
            model: 'xmzTreeModel',
            proxy: {
                type: 'ajax',
                method: 'POST',
                url: 'getXmzTreeData.action',
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
        /**
         * 工具栏
         */
        var screenBar = [
            {
                xtype: "textfield",
                name: "mhcx",
                id: "mhcx",
                fieldLabel: '模糊查询',
                allowBlank: true,
                labelWidth: 70,
                width: 260,
                labelAlign: 'right',
                emptyText: '请输入项目名称...',
                enableKeyEvents: true,
                listeners: {
                    specialkey:function(field,e){//监听回车事件
                        var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].getValue();
                        DSYGrid.getGrid('xmxx_grid').getStore().getProxy().extraParams = {
                            XMZ_ID:select_tree_id,
                            MHCX: mhcx
                        };
                        DSYGrid.getGrid("xmxx_grid").getStore().loadPage(1);//刷新数据
                    }
                }
            }
        ];
        /**
         * 项目信息列表表头
         */
        var headerJson = [
            {
                xtype: 'rownumberer',
                summaryType: 'count',
                width: 40
            },
            {
                "dataIndex": "ID",
                "type": "string",
                "text": "唯一ID",
                "fontSize": "15px",
                "hidden": true
            },
            {
                "dataIndex": "XM_ID",
                "type": "string",
                "text": "项目ID",
                "fontSize": "15px",
                "hidden": true
            }, {
                "dataIndex": "AG_NAME",
                "type": "string",
                "text": "单位名称",
                "fontSize": "15px"
            }, {
                "dataIndex": "XM_CODE",
                "type": "string",
                "text": "项目编码",
                "fontSize": "15px",
                "width": 320
            }, {
                "dataIndex": "XM_NAME",
                "type": "string",
                "text": "项目名称",
                "fontSize": "15px",
                "width": 250,
                renderer: function (data, cell, record) {
                    var url='/page/debt/common/xmyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    paramNames[1]="IS_RZXM";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));

                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;

                }
            }, {
                "dataIndex": "ZQ_ID",
                "type": "string",
                "hidden": true
            }, {
                "dataIndex": "ZQ_NAME",
                "type": "string",
                "width": 250,
                "text": "债券名称",
                renderer: function (data, cell, record) {
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=userAD;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            }, {
                "dataIndex": "ZQLB_NAME",
                "type": "string",
                "text": "债券类型",
                "fontSize": "15px",
                "width": 150
            }, {
                "text": "发行日期",
                "dataIndex": "FX_START_DATE",
                "width": 150,
                "type": "string",
                "fontSize": "15px"
            }, {
                "dataIndex": "FX_AMT",
                "type": "float",
                "text": "发行金额(万元)",
                "fontSize": "15px",
                "width": 180,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            },{
                "dataIndex": "LX_YEAR",
                "type": "string",
                "text": "立项年度",
                "fontSize": "15px",
                "width": 100
            }, {
                "dataIndex": "JSXZ_NAME",
                "type": "string",
                "text": "建设性质",
                "fontSize": "15px",
                "width": 100
            }, {
                "dataIndex": "XMXZ_NAME",
                "type": "string",
                "text": "项目性质",
                "fontSize": "15px",
                "width": 200
            }, {
                "dataIndex": "XMLX_NAME",
                "type": "string",
                "text": "项目类型",
                "fontSize": "15px",
                "width": 130
            }, {
                "dataIndex": "BUILD_STATUS_NAME",
                "type": "string",
                "text": "建设状态",
                "fontSize": "15px",
                "width": 130
            }, {
                "dataIndex": "XMZGS_AMT",
                "type": "float",
                "text": "项目总概算金额(万元)",
                "fontSize": "15px",
                "width": 180,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            }
        ];
        var config = {
            itemId: 'xmxx_grid',
            flex: 5,
            region: 'center',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            enableLocking: false,
            autoLoad: false,
            dataUrl: 'getXmzInfoData.action',
            checkBox: false,
            border: false,
            height: '100%',
            tbar: screenBar,
            pageConfig: {
                enablePage: false,
            }
        };
        var grid = DSYGrid.createGrid(config);
        /**
         * 项目组信息录入界面主面板初始化
         */
        var panel = Ext.create('Ext.panel.Panel', {
            renderTo: Ext.getBody(),
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            width: '100%',
            height: '100%',
            border: false,
            items: [
                {
                    xtype: 'treepanel',
                    height: '100%',
                    itemId: 'xmz_tree',
                    region: 'west',
                    flex: 1,
                    store: unitStore,
                    rootVisible: false,
                    listeners: {
                        itemclick: function (view, record, item, index, e, eOpts) {
                            fuc_getPfpzGrid(record, record.get('leaf'));
                            if(record.get('id')!='root'){
                                select_tree_id = record.get('id');
                            }else{
                                select_tree_id="";
                            }
                            current_record=unitStore.indexOf(record);
                        }
                    }
                },
                grid
            ],
            tbar: tbar
        });
    }
    /**
     * 编辑
     */
    function fuc_updateFxgl(name) {
        var selected = Ext.ComponentQuery.query('treepanel#xmz_tree')[0].getSelectionModel().getSelection();
        var selected_id = selected[0].data.id;
        button_name = name;
        //发送ajax请求
        $.post("getXmzxxByXmzId.action", {
            XMZ_ID: selected_id
        }, function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示','编辑失败！' + data.message);
                return;
            }
            //弹出弹出框，并将表数据插入到弹出框form中
            editWindow.show("项目信息编辑");
            editWindow.window.down('form').getForm().setValues(data.data);
            var store = editWindow.window.down('form').down('grid#xm_edit_Grid').getStore();
            store.loadData(data.list);
        }, "json");
    }
    /**
     * 初始化选中树节点第一条数据
     */
    function initTree() {
        var tree = Ext.ComponentQuery.query('treepanel#xmz_tree')[0];
        var rootNode = tree.getRootNode();
        if (rootNode.getChildAt(0) && rootNode.getChildAt(0).getChildAt(0)) {
            var record = rootNode.getChildAt(0).getChildAt(0);
            tree.getSelectionModel().select(record);
            fuc_getPfpzGrid(record, "1");
            select_tree_id=record.get('id');
        }
    }
    /**
     * 项目组增加/编辑页面
     */
    function fuc_addXmzgl(name) {
        button_name = name;
        if(name=='btn_add'){//增加按钮
            editWindow.show("项目组信息增加");
        }
    }
    /**
     * 更新列表数据
     */
    function fuc_getPfpzGrid(record, is_leaf) {
        if (is_leaf) {
            XMZ_ID = record.get('id');//获取树节点参数值
        } else {
            XMZ_ID = '';//获取树节点参数值
        }
        DSYGrid.getGrid('xmxx_grid').getStore().getProxy().extraParams = {
            XMZ_ID: XMZ_ID
        };
        DSYGrid.getGrid("xmxx_grid").getStore().loadPage(1);//刷新数据
    }

    /**
     * 编辑弹出框
     */
    var editWindow = {
        window: null,
        show: function (title) {
            this.window = Ext.create('Ext.window.Window', {
                title: title,
                itemId: 'editWin',
                width: document.body.clientWidth * 0.9,
                height: document.body.clientHeight * 0.9,
                layout: 'fit',
                maximizable: true,
                frame: true,
                constrain: true,
                buttonAlign: "right", // 按钮显示的位置
                modal: true,
                resizable: true,//大小不可改变
                plain: true,
                items: [xmpzTab()],
                closeAction: 'destroy',
                buttons: [
                    {
                        xtype: 'button',
                        text: '保存',
                        name: 'btn_update',
                        id: 'save',
                        handler: function (btn) {
                            saveXMXX(btn);
                        }
                    }, {
                        xtype: 'button',
                        text: '取消',
                        name: 'CLOSE',
                        handler: function (btn) {
                            btn.up('window').close();
                        }
                    }
                ]
            });
            this.window.show();
        }
    };
    /**
     * 保存项目内容
     */
    function saveXMXX(btn){
        btn.setDisabled(true);
        var XMZ_ID = Ext.ComponentQuery.query('textfield[name="XMZ_ID"]')[0].value;
        //var XMZ_CODE = Ext.ComponentQuery.query('textfield[name="XMZ_CODE"]')[0].value;
        var XMZ_NAME = Ext.ComponentQuery.query('textfield[name="XMZ_NAME"]')[0].value;
        //校验必录项
        /*if(XMZ_CODE == null || XMZ_CODE  == undefined || XMZ_CODE  == "" ){
            Ext.Msg.alert('提示', "请填入项目组编码！");
            btn.setDisabled(false);
            return;
        }*/
        if(XMZ_NAME == null || XMZ_NAME  == undefined || XMZ_NAME  == "" ){
            Ext.Msg.alert('提示', "请填入项目组名称！");
            btn.setDisabled(false);
            return;
        }
        var xmgrid=DSYGrid.getGrid('xm_edit_Grid').getStore();
        var xm_store_data = new Array();
        if(button_name=='btn_add'&&xmgrid.getCount()==0){
            Ext.Msg.alert('提示', "请增加项目信息！");
            btn.setDisabled(false);
            return;
        }
        for(var i=0;i<xmgrid.getCount();i++){
            var xm = xmgrid.getAt(i);
            xm_store_data.push(xm.data);
        }
        var checkAg = {};
        /*if (!checkGrid()) {
            Ext.Msg.alert('提示', grid_error_message);
            btn.setDisabled(false);
            return false;
        }*/
        $.post('saveXmzInfo.action', {
            button_name: button_name,//增加还是编辑
            XMZ_ID:XMZ_ID,
            XMZ_NAME:XMZ_NAME,
            XM_STORE:Ext.util.JSON.encode(xm_store_data)
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: '保存成功！',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                btn.up('window').close();
                // 刷新表格
                Ext.ComponentQuery.query('treepanel#xmz_tree')[0].getStore().load();
                DSYGrid.getGrid('xmxx_grid').getStore().loadPage(1);
            } else {
                Ext.MessageBox.alert('提示', '保存失败!' + data.message);
                btn.setDisabled(false);
            }
        }, 'JSON');
    }
    /**
     *保存时校验表格数据
     */
    function checkGrid(grid) {
        var flag = true;
        var checkAg = {};
        DSYGrid.getGrid('xm_edit_Grid').getStore().each(function (record) {
            if (typeof checkAg[record.get('XM_ID')] != 'undefined' && checkAg[record.get('XM_ID')] != null
                && checkAg[record.get('XM_ID')]&&record.get('XM_ID')!="") {
                grid_error_message = '存在重复的项目！';
                flag = false;
                return flag;
            }else {
                checkAg[record.get('XM_ID')] = true;
            }
        });
        return flag;
    }
    /**
     * 初始化项目信息编辑框
     */
    function xmpzTab() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            layout: 'vbox',
            border: false,
            padding: '2 5 2 10',
            items: [
                {
                    xtype: 'container',
                    layout:'column',
                    margin:'5 5 5 5',
                    items: [

                        {
                            xtype: "textfield",
                            name: "XMZ_ID",
                            displayField: "name",
                            valueField: "id",
                            width: 250,
                            labelWidth: 100,
                            hidden:true,
                            fieldLabel: '项目组ID'
                        },
                        /*{
                            xtype: "textfield",
                            name: "XMZ_CODE",
                            displayField: "name",
                            valueField: "id",
                            width: 250,
                            labelWidth: 100,
                            fieldLabel: '<span class="required">✶</span>项目组编码',
                        },*/
                        {
                            xtype: "textfield",
                            name: "XMZ_NAME",
                            displayField: "name",
                            valueField: "id",
                            width: 250,
                            labelWidth: 100,
                            fieldLabel: '<span class="required">✶</span>项目组名称',
                        }
                    ]
                },
                init_xmxx_grid()
            ]
        });
    }
    function init_xmxx_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer',
                summaryType: 'count',
                width: 40
            },
            {
                "dataIndex": "ID",
                "type": "string",
                "text": "唯一ID",
                "fontSize": "15px",
                "hidden": true
            },
            {
                "dataIndex": "XM_ID",
                "type": "string",
                "text": "项目ID",
                "fontSize": "15px",
                "hidden": true
            }, {
                "dataIndex": "AG_NAME",
                "type": "string",
                "text": "单位名称",
                "fontSize": "15px",
                "width": 250,
            }, {
                "dataIndex": "XM_CODE",
                "type": "string",
                "text": "项目编码",
                "fontSize": "15px",
                "width": 320
            }, {
                "dataIndex": "XM_NAME",
                "type": "string",
                "text": "项目名称",
                "fontSize": "15px",
                "width": 250,
                renderer: function (data, cell, record) {
                    var url='/page/debt/common/xmyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    paramNames[1]="IS_RZXM";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));

                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;

                }
            },{
                "dataIndex": "ZQ_ID",
                "type": "string",
                "hidden": true
            }, {
                "dataIndex": "ZQ_NAME",
                "type": "string",
                "width": 250,
                "text": "债券名称",
                renderer: function (data, cell, record) {
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=userAD;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            }, {
                "dataIndex": "ZQLB_NAME",
                "type": "string",
                "text": "债券类型",
                "fontSize": "15px",
                "width": 150
            }, {
                "text": "发行日期",
                "dataIndex": "FX_START_DATE",
                "width": 150,
                "type": "string",
                "fontSize": "15px"
            }, {
                "dataIndex": "FX_AMT",
                "type": "float",
                "text": "发行金额(万元)",
                "fontSize": "15px",
                "width": 180,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            }, {
                "dataIndex": "LX_YEAR",
                "type": "string",
                "text": "立项年度",
                "fontSize": "15px",
                "width": 100
            }, {
                "dataIndex": "JSXZ_NAME",
                "type": "string",
                "text": "建设性质",
                "fontSize": "15px",
                "width": 100
            }, {
                "dataIndex": "XMXZ_NAME",
                "type": "string",
                "text": "项目性质",
                "fontSize": "15px",
                "width": 200
            }, {
                "dataIndex": "XMLX_NAME",
                "type": "string",
                "text": "项目类型",
                "fontSize": "15px",
                "width": 130
            }, {
                "dataIndex": "BUILD_STATUS_NAME",
                "type": "string",
                "text": "建设状态",
                "fontSize": "15px",
                "width": 130
            }, {
                "dataIndex": "XMZGS_AMT",
                "type": "float",
                "text": "项目总概算金额(万元)",
                "fontSize": "15px",
                "width": 180,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'xm_edit_Grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'zqzd_grid_plugin_cell',
                    clicksToMoveEditor: 1
                }
            ],
            listeners: {
                beforeedit:function (editor, context) {

                }
            },
            width: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            autoLoad: false,
            data: []
        });
        // 将增加删除按钮添加到表格中
        grid.addDocked({
            xtype: 'toolbar',
            layout: 'hbox',
            items: ['', {
                xtype: 'button',
                text: '删除项目',
                itemId: 'delete_editGrid',
                width: 80,
                //disabled: true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var records = grid.getSelectionModel().getSelection();
                    Ext.each(records, function (record) {
                        store.remove(record);
                    })
                }
            }, {
                xtype: 'button',
                text: '增加项目',
                itemId: 'yyxm',
                width: 80,
                handler: function (btn) {
                    initZjSelectWin().show();
                }
            }]
        }, 0);
        return grid;
    }
    /**
     * 初始化项目选择弹出框window
     * @param self
     * @param store
     * @returns {Ext.window.Window}
     */
    function initZjSelectWin () {
        var XMZ_ID="";
        if(button_name=='btn_edit'){//编辑
            //获取树中选择的项目组id
            XMZ_ID=select_tree_id;
        }
        var gridConfig = {
            itemId: 'xmtgGrid',
            name : 'PopupGrid',
            headerConfig: {
                rowNumber: true,
                headerJson:[
                    {
                        xtype: 'rownumberer',
                        summaryType: 'count',
                        width: 40
                    },
                    {
                        "dataIndex": "ID",
                        "type": "string",
                        "text": "唯一ID",
                        "fontSize": "15px",
                        "hidden": true
                    },
                    {
                        "dataIndex": "XM_ID",
                        "type": "string",
                        "text": "项目ID",
                        "fontSize": "15px",
                        "hidden": true
                    }, {
                        "dataIndex": "AG_NAME",
                        "type": "string",
                        "text": "单位名称",
                        "fontSize": "15px",
                        "width": 250,
                    }, {
                        "dataIndex": "XM_CODE",
                        "type": "string",
                        "text": "项目编码",
                        "fontSize": "15px",
                        "width": 320
                    }, {
                        "dataIndex": "XM_NAME",
                        "type": "string",
                        "text": "项目名称",
                        "fontSize": "15px",
                        "width": 250,
                        renderer: function (data, cell, record) {
                            var url='/page/debt/common/xmyhs.jsp';
                            var paramNames=new Array();
                            paramNames[0]="XM_ID";
                            paramNames[1]="IS_RZXM";
                            var paramValues=new Array();
                            paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                            paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));

                            var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                            return result;

                        }
                    }, {
                        "dataIndex": "ZQ_ID",
                        "type": "string",
                        "hidden": true
                        }, {
                        "dataIndex": "ZQ_NAME",
                        "type": "string",
                        "width": 250,
                        "text": "债券名称",
                        renderer: function (data, cell, record) {
                            var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                            var paramNames=new Array();
                            paramNames[0]="ZQ_ID";
                            paramNames[1]="AD_CODE";
                            var paramValues=new Array();
                            paramValues[0]=record.get('ZQ_ID');
                            paramValues[1]=userAD;
                            var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                            return result;
                        }
                    }, {
                        "dataIndex": "ZQLB_NAME",
                        "type": "string",
                        "text": "债券类型",
                        "fontSize": "15px",
                        "width": 150
                    }, {
                        "text": "发行日期",
                        "dataIndex": "FX_START_DATE",
                        "width": 150,
                        "type": "string",
                        "fontSize": "15px"
                    }, {
                        "dataIndex": "FX_AMT",
                        "type": "float",
                        "text": "发行金额(万元)",
                        "fontSize": "15px",
                        "width": 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.######');
                        }
                    }, {
                        "dataIndex": "LX_YEAR",
                        "type": "string",
                        "text": "立项年度",
                        "fontSize": "15px",
                        "width": 100
                    }, {
                        "dataIndex": "JSXZ_NAME",
                        "type": "string",
                        "text": "建设性质",
                        "fontSize": "15px",
                        "width": 100
                    }, {
                        "dataIndex": "XMXZ_NAME",
                        "type": "string",
                        "text": "项目性质",
                        "fontSize": "15px",
                        "width": 200
                    }, {
                        "dataIndex": "XMLX_NAME",
                        "type": "string",
                        "text": "项目类型",
                        "fontSize": "15px",
                        "width": 130
                    }, {
                        "dataIndex": "BUILD_STATUS_NAME",
                        "type": "string",
                        "text": "建设状态",
                        "fontSize": "15px",
                        "width": 130
                    }, {
                        "dataIndex": "XMZGS_AMT",
                        "type": "float",
                        "text": "项目总概算金额(万元)",
                        "fontSize": "15px",
                        "width": 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value, '0,000.######');
                        }
                    }
                ],
                columnAutoWidth: false
            },
            rowNumber: true,
            border: false,
            height: '100%',
            pageConfig: {
                enablePage : true,
                pageSize: 20// 每页显示数据数
            },
            dataUrl: 'getXmSelect.action',
            checkBox: true,
            params: {
                XMZ_ID:XMZ_ID
            },
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    layout: {
                        type: 'column'
                    },
                    border: true,
                    bodyStyle: 'padding:0 0 0 0',//'border-width:0 0 0 0;',
                    defaults: {
                        margin: '1 1 2 5',
                        width: 240,
                        labelWidth: 80,//控件默认标签宽度
                        labelAlign: 'left'//控件默认标签对齐方式
                    },
                    items: [{
                        fieldLabel: '模糊查询',
                        name: 'xmmhcx',
                        xtype: "textfield",
                        width: 240,
                        labelWidth: 60,
                        labelAlign: 'right',
                        emptyText: '请输入项目名称',
                        enableKeyEvents: true,
                        listeners: {
                            specialkey:function(field,e){//监听回车事件
                                if(e.getKey()==Ext.EventObject.ENTER) {
                                    loadYyxmInfo();
                                }
                            }
                        }
                    },
                        {
                            xtype: "combobox",
                            name: "LX_YEAR",
                            store: DebtEleStore(json_debt_year),
                            displayField: "name",
                            valueField: "id",
                            width: 240,
                            labelWidth: 60,
                            labelAlign: 'right',
                            fieldLabel: '立项年度',
                            editable: false, //禁用编辑
                            enableKeyEvents: true,
                            listeners: {
                                specialkey:function(field,e){//监听回车事件
                                    if(e.getKey()==Ext.EventObject.ENTER) {
                                        loadYyxmInfo();
                                    }
                                }
                            }
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '项目类型',
                            width: 240,
                            labelWidth: 60,
                            labelAlign: 'right',
                            editable: false, //禁用编辑
                            name: 'XMLX',
                            displayField: 'name',
                            valueField: 'code',
                            store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                            enableKeyEvents: true,
                            listeners: {
                                specialkey:function(field,e){//监听回车事件
                                    if(e.getKey()==Ext.EventObject.ENTER) {
                                        loadYyxmInfo();
                                    }
                                }
                            }
                        },
                        {
                            xtype: "treecombobox",
                            name: "ZJTXLY_ID",
                            store: DebtEleTreeStoreDB("DEBT_ZJTXLY"),
                            fieldLabel: '资金投向领域',
                            editable: false, //禁用编辑
                            width: 240,
                            labelWidth: 90,
                            displayField: 'name',
                            valueField: 'id',
                            rootVisible: false,
                            lines: false,
                            allowBlank: false,
                            selectModel: 'leaf',
                            enableKeyEvents: true,
                            listeners: {
                                specialkey:function(field,e){//监听回车事件
                                    if(e.getKey()==Ext.EventObject.ENTER) {
                                        loadYyxmInfo();
                                    }
                                }
                            }
                        },
                        {
                            xtype: 'combobox',
                            fieldLabel: '是否已发行债券',
                            width: 240,
                            labelWidth: 110,
                            labelAlign: 'right',
                            editable: false, //禁用编辑
                            name: 'IS_FXZQ',
                            displayField: 'name',
                            valueField: 'id',
                            store: DebtEleStore(json_debt_fxzq),
                            enableKeyEvents: true,
                            listeners: {
                                specialkey:function(field,e){//监听回车事件
                                    if(e.getKey()==Ext.EventObject.ENTER) {
                                        loadYyxmInfo();
                                    }
                                }
                            }
                        },
                        {
                            xtype: 'combobox',
                            fieldLabel: '发行年度',
                            width: 240,
                            labelWidth: 60,
                            labelAlign: 'right',
                            editable: false, //禁用编辑
                            name: 'FX_YEAR',
                            displayField: 'name',
                            valueField: 'id',
                            store: DebtEleStore(json_debt_fxyear),
                            enableKeyEvents: true,
                            listeners: {
                                specialkey:function(field,e){//监听回车事件
                                    if(e.getKey()==Ext.EventObject.ENTER) {
                                        loadYyxmInfo();
                                    }
                                }
                            }
                        },
                    ]
                }
             ],
            tbar: [{
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    loadYyxmInfo();
                }
            }]
        };
        var grid = new DSYGrid.createGrid(gridConfig);
        var window = Ext.create('Ext.window.Window', {
            closeAction: 'destroy',
            title: '选择项目',
            width: document.body.clientWidth * 0.9,
            height: document.body.clientHeight * 0.8,
            layout: 'fit',
            modal: true,
            buttonAlign: 'center',
            buttons: [
                {
                    text: '确认',
                    listeners: {
                        'click': function (btn) {
                            var yyxmGridStore = DSYGrid.getGrid('xm_edit_Grid').getStore();
                            var yyxmGridItems = yyxmGridStore.data.items;
                            var currentIndex;
                            if (yyxmGridItems.length == 0) {
                                currentIndex = 0;

                            } else {
                                currentIndex = yyxmGridItems.length;
                            }

                            var records = DSYGrid.getGrid('xmtgGrid').getSelection();
                            for (var i = 0; i < records.length; i++) {
                                records[i].set('DATA_ID','');
                                DSYGrid.getGrid('xm_edit_Grid').insertData(currentIndex,records[i]);
                            }
                            // 关闭弹出窗口
                            btn.up("window").close();
                        }
                    }
                },
                {
                    text: '取消',
                    listeners: {
                        'click': function (btn) {
                            btn.up("window").close();
                        }
                    }
                }
            ],
            items: [grid]
        });
        return window;
    }

    // 刷新已有项目信息
    function loadYyxmInfo(){
        var store = DSYGrid.getGrid('xmtgGrid').getStore();
        var mhcx = Ext.ComponentQuery.query('textfield[name="xmmhcx"]')[0].getValue();
        var lxyear = Ext.ComponentQuery.query('textfield[name="LX_YEAR"]')[0].getValue();
        var xmlx = Ext.ComponentQuery.query('treecombobox[name="XMLX"]')[0].getValue();
        var is_fxzq = Ext.ComponentQuery.query('combobox[name="IS_FXZQ"]')[0].getValue();
        var fx_year = Ext.ComponentQuery.query('combobox[name="FX_YEAR"]')[0].getValue();
        var zjtxly_id = Ext.ComponentQuery.query('treecombobox[name="ZJTXLY_ID"]')[0].getValue();
        store.getProxy().extraParams = {
            XMZ_ID:XMZ_ID,
            MHCX: mhcx,
            LX_YEAR: lxyear,
            ZJTXLY_ID: zjtxly_id,
            XMLX: xmlx,
            IS_FXZQ: is_fxzq,
            FX_YEAR: fx_year
        };
        //刷新表格内容
        store.loadPage(1);
    }
</script>
</body>
</html>