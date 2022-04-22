<%--
  Created by IntelliJ IDEA.
  User: guodg
  Date: 2019/8/19
  Time: 11:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"
         import="com.bgd.platform.util.service.SpringContextUtil" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>项目二维码申请页面</title>
    <style type="text/css">
        .label-color {
            color: red;
            font-size: 100%;
        }

        body {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
<%--引入js--%>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/js/debt/xmInfo.js"></script>
<script>
    /*获取用户信息*/
    var userName = '${sessionScope.USERNAME}';//用户名
    var userCode = '${sessionScope.USERCODE}';//用户编码
    var adCode = '${sessionScope.ADCODE}'.replace(/00$/, "");//用户区划
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    /*
        var WF_STATUS = getQueryParam("WF_STATUS");
    */
    var WF_STATUS = '${fns:getParamValue("WF_STATUS")}'
    /*
        var czb = getQueryParam("czb")==null?'0':getQueryParam("czb");
    */
    var czb = '${fns:getParamValue("czb")}' == null ? '0' : '${fns:getParamValue("czb")}';
    //从系统参数中获取省级区划
    var v_child = '0';//区划树参数，1只显示本级，其它显示全部，默认显示全部
    /*  if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
          WF_STATUS = '001';
      }*/
    if (is_Null(WF_STATUS)) {
        WF_STATUS = '001';
    }
    //系统参数，是否使用申请二维码功能
    var isCreateQRCode = '${fns:getSysParam("IS_CREATE_QRCODE")}';
    if (isCreateQRCode == null || isCreateQRCode == '') {
        isCreateQRCode = '0';
    }
    //全局变量 筛选条件
    var xmxz_id, xmlx_id, jsxz_id, lxnd, sbnd, mhcx;
    //动态js页面数组
    var xmQRCode_json_common = {};

    $.extend(xmQRCode_json_common, {
        defaultItems: WF_STATUS,
        items_content: function () {
            return [
                initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    }
                }),
                initContentRightPanel()
            ];
        },
        items: {
            '001': [
                {
                    xtype: 'button',
                    name: 'search',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    name: 'QRCodeApply',
                    text: '申请二维码',
                    icon: '/image/sysbutton/regist.png',
                    hidden: czb == '1' ? true : false,
                    disabled: '1' == isCreateQRCode ? false : true,
                    handler: function (btn) {
                        func_createQRCode();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ],
            '002': [
                {
                    xtype: 'button',
                    name: 'search',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        reloadGrid();
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        }
    });

    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        /*
            初始化主界面
         */
        initContent();
    });

    /**
     * 构建主面板
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            renderTo: Ext.getBody(),
            width: '100%',
            height: '100%',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            layout: 'border',
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'xmQRCode_toolbar',
                    items: xmQRCode_json_common.items[xmQRCode_json_common.defaultItems]
                }
            ],
            items: xmQRCode_json_common.items_content()
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
                        margin: '2 5 2 5',
                        width: 250,
                        labelWidth: 60,//控件默认标签宽度
                        labelAlign: 'left'//控件默认标签对齐方式
                    },
                    items: [
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '项目性质',
                            itemId: 'XMXZ_SEARCH',
                            displayField: 'name',
                            valueField: 'id',
                            rootVisible: true,
                            lines: false,
                            editble: false,
                            selectModel: 'all',//选择叶子节点才有效
                            store: DebtEleTreeStoreDB("DEBT_ZJYT"),
                            listeners: {
                                select: function (self, value) {
                                    //刷新当前表格
                                    xmxz_id = self.value;
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '项目类型',
                            itemId: 'XMLX_SEARCH',
                            displayField: 'name',
                            valueField: 'id',
                            rootVisible: true,
                            selectModel: 'all',//选择叶子节点才有效
                            editable: false,
                            store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                            listeners: {
                                select: function (self, value) {//value表示选择的项，在这里是一个treeNode
                                    //刷新当前表格
                                    xmlx_id = self.value;
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype: "combobox",
                            itemId: "JSXZ_SEARCH",
                            store: DebtEleStoreDB("DEBT_XMJSXZ"),
                            fieldLabel: '建设性质',
                            displayField: 'name',
                            valueField: 'id',
                            editable: false,
                            listeners: {
                                select: function (self, value) {
                                    //刷新当前表格
                                    jsxz_id = self.value;
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype: "combobox",
                            itemId: "LXND_SEARCH",   //项目立项年度
                            store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2000' and code <= '2020' "}),
                            fieldLabel: '立项年度',
                            displayField: 'name',
                            valueField: 'id',
                            value: new Date().getFullYear(),
                            editable: false,
                            allowBlank: true,
                            listeners: {
                                select: function (self, record) {
                                    //刷新当前表格
                                    lxnd = self.value;
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '模糊查询',
                            itemId: "XM_SEARCH",
                            width: 507,    //762
                            emptyText: '项目单位/编码/名称...',
                            enableKeyEvents: true,
                            listeners: {
                                'keydown': function (self, e, eOpts) {
                                    var key = e.getKey();
                                    if (key == Ext.EventObject.ENTER) {
                                        mhcx = self.getValue();
                                        reloadGrid();
                                    }
                                }
                            }
                        }
                    ]
                }
            ],
            items: initContentGrid()
        });
    }

    /**
     * 初始化右侧主表格
     */
    function initContentGrid(param) {
        var headerJson = [
            {
                xtype: 'rownumberer',
                summaryType: 'count',
                width: 40
            },
            {
                "dataIndex": "XM_ID",
                "type": "string",
                "text": "项目ID",
                "fontSize": "15px",
                "hidden": true
            },
            {
                "dataIndex": "QRCODE_STATUS",
                "type": "string",
                "text": "二维码",
                "fontSize": "20px",
                renderer: function (data, cell, record) {
                    var result = '<span style="background:yellow;text-align: center;">未生成</span>';
                    if (data == 'YSC') {//已生成
                        var xmID = record.get('XM_ID');
                        result = '<a href = "#" onclick ="showwindows(\'' + xmID + '\')" style="color:#3329ff;">已生成[查看]</a>';
                    }
                    return result;

                }
            }, {
                "dataIndex": "AG_NAME",
                "type": "string",
                "text": "单位名称",
                "fontSize": "15px",
                "width": 250
            }, {
                "dataIndex": "XM_CODE",
                "type": "string",
                "text": "项目编码",
                "fontSize": "15px",
                "width": 150
            }, {
                "dataIndex": "XM_NAME",
                "type": "string",
                "text": "项目名称",
                "fontSize": "15px",
                "width": 250,
                renderer: function (data, cell, record) {
                    var url = '/page/debt/common/xmyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "XM_ID";
                    paramNames[1] = "IS_RZXM";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                    paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));

                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;

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
                },
            }
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            border: false,
            height: '50%',
            flex: 1,
            tbarHeight: 50,
            autoLoad: true,
            enableLocking: false,
            dataUrl: 'getJSXMInfoGridV2.action',
            params: {
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE,
                XMXZ_ID: xmxz_id,
                XMLX_ID: xmlx_id,
                JSXZ_ID: jsxz_id,
                LX_YEAR: lxnd,
                MHCX: mhcx,
                WF_STATUS: WF_STATUS
            },
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            tbar: [
                {
                    xtype: "combobox",
                    fieldLabel: '状态',
                    itemId: "XM_STATUS",
                    name: "XM_STATUS", // 状态根据node_type显示不同的数据
                    store: DebtEleStore(json_debt_zt8),
                    margin: '0 5 5 5',
                    labelWidth: 40,
                    labelAlign: 'left',
                    editable: false,
                    width: 150,
                    allowBlank: false,
                    displayField: "name",
                    valueField: "code",
                    value: WF_STATUS,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            // 更新工具栏中的按钮
                            var toolbar = Ext.ComponentQuery.query('toolbar#xmQRCode_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(xmQRCode_json_common.items[WF_STATUS]);
                            // 刷新当前表格
                            reloadGrid();
                        }
                    }
                }
            ],
            listeners: {
                itemdblclick: function (self, record) {

                }
            }
        });
    }

    /**
     * 点击区划刷新表格
     */
    function reloadGrid() {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        store.getProxy().extraParams = {
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            XMXZ_ID: xmxz_id,
            XMLX_ID: xmlx_id,
            JSXZ_ID: jsxz_id,
            LX_YEAR: lxnd,
            MHCX: mhcx,
            WF_STATUS: WF_STATUS
        };
        store.loadPage(1);
    }

    /**
     * 生成二维码
     */
    function func_createQRCode() {
        //获取选择的项目
        var grid = DSYGrid.getGrid("contentGrid");
        var records = grid.getSelection();
        if (records.length <= 0) {
            Ext.Msg.alert('提示', '请至少选择一个项目！');
            return;
        }
        //构造传递的数据
        var array = [];//存储所有项目信息,js中的map使用set方法存储键值对
        records.forEach(function (record) {
            //收集信息XM_ID
            array.push(record.get("XM_ID"));
        });
        var num = array.length;
        Ext.Msg.confirm('提示', '确定要为这些项目生成二维码吗？', function (status) {
            if ('yes' == status) {
                Ext.Msg.wait('正在向财政部申请二维码……', '请等待');
                //发送请求，调用部端webService
                Ext.Ajax.request({
                    url: 'createQRCode.action',
                    async: true,//异步
                    method: 'POST',//方法名大写
                    timeout: 180000,//请求超时时间3分钟，默认是30秒
                    params: {
                        xmIDs: Ext.JSON.encode(array)
                    },
                    success: function (response, opts) {
                        var data = Ext.JSON.decode(response.responseText);
                        if (data.success) {
                            Ext.Msg.hide();
                            Ext.toast({
                                html: '操作成功，共为' + num + '个项目生成二维码！',
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            reloadGrid();
                        } else {
                            Ext.Msg.alert('提示', data.message);
                        }
                    },
                    failure: function (response, opts) {
                        Ext.Msg.alert('提示', '操作失败！' + response.status);
                    }
                });
            }
        });
    }

    /**
     * 弹出窗形式展示项目二维码图片
     * @param XM_ID
     */
    function showwindows(XM_ID) {
        var window = Ext.create('Ext.window.Window', {
            title: '二维码图片',
            width: 350,//document.body.clientWidth * 0.32, // 窗口宽度
            height: 350,//document.body.clientWidth * 0.32, // 窗口高度
            layout: 'fit',
            modal: true,
            maximizable: false,
            items: [{
                xtype: 'panel',
                layout: 'fit',
                items: [//以流的方式获取图片并展示
                    {html: '<img id = "qrCodeImg" width="100%" height="100%" src= "qrCode.action?XM_ID=' + XM_ID + '"/>'}
                ]
            }]
        }).show();
    }
</script>
</body>
</html>
