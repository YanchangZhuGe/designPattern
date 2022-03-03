<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ page import="com.bgd.platform.util.service.SpringContextUtil" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>债券还本主界面</title>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var USER_AG_ID = '${sessionScope.AGID}';
    var USER_AG_CODE = '${sessionScope.AGCODE}';
    var USER_AG_NAME = '${sessionScope.AGNAME}';
    var USER_AD_CODE = '${sessionScope.ADCODE}';
    var USER_AD_NAME = '${sessionScope.ADNAME}';
    var is_zxzqxt = '${fns:getSysParam("IS_ZXZQXT")}';
    var USER_CODE = '${sessionScope.USERCODE}';
    if (!USER_AG_ID || USER_AG_ID == 'null') {
        USER_AG_ID = null;
    }
    if (!USER_AG_CODE || USER_AG_CODE == 'null') {
        USER_AG_CODE = null;
    }
    if (!USER_AG_NAME || USER_AG_NAME == 'null') {
        USER_AG_NAME = null;
    }
    var userName_jbr = '${sessionScope.USERNAME}';
    var reportUrl = '';
    var nowDate = '${fns:getDbDateDay()}';
    var button_name = '';//当前操作按钮名称
    var button_status = '';//当前操作按钮状态，即为按钮name
    var v_child = '1'; // 是否显示全部区划
    var json_zt = json_debt_zt1;//当前状态下拉框json数据
    var IS_PERCENT_JXHJ;
    var wf_id = getQueryParam("wf_id");//当前流程id
    if (wf_id == null || wf_id == '' || wf_id.toLowerCase() == 'null') {
        wf_id = '100251';
    }
    var node_type = getQueryParam("node_type");//当前节点id
    if (node_type == null || node_type == '' || node_type == undefined) {
        node_type = 'jxhjsq';
    }
    if (node_type == "jxhjsb" || node_type == 'jxhjxjsh') {
        //以上node隐藏区划树，默认选中底级区划
        v_child = '0';
    }
    var node_code = getQueryParam("node_code");//当前节点id
    if (node_code == null || node_code == '' || node_code.toLowerCase() == 'null') {
        node_code = '1';
    }
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var debt_is_pp = [
        {id: "0", code: "0", name: "否"},
        {id: "1", code: "1", name: "是"}
    ];
    var is_pp_store = DebtEleStore(debt_is_pp);
    $.ajax({
        type: "POST",
        url: 'getParamValueAll.action',
        async: false, //设为false就是同步请求
        cache: false,
        success: function (data) {
            data = eval(data);
            IS_PERCENT_JXHJ = data[0].IS_PERCENT_JXHJ;
            if (IS_PERCENT_JXHJ == null || IS_PERCENT_JXHJ == 0 || IS_PERCENT_JXHJ == "" || IS_PERCENT_JXHJ == undefined) {
                IS_PERCENT_JXHJ = 70;
            }
        }
    });
    //上报审核状态，0未审核，1已审核，2淘汰
    var store_shyj = DebtEleStore([
        {code: '0', name: '不通过'},
        {code: '1', name: '通过'}
    ]);
    /**
     * 通用配置json
     */
    var json_common = {
        jxhjsq: 'jxhjsq.js',//填报
        jxhjsh: 'jxhjsh.js',//审核
        jxhjsb: 'jxhjsb.js',//上报
        jxhjxjsh: 'jxhjxjsh.js'//下级审核
    };
    var HEADERJSON = [
        {
            xtype: 'rownumberer', summaryType: 'count', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {text: "再融资债券主单id", dataIndex: "BILL_ID", width: 200, type: "string", hidden: true},
        {text: "申报批次_id", dataIndex: "BATCH_NO", width: 200, type: "string", hidden: true},
        {text: "申报批次", dataIndex: "BATCH_NO_NAME", width: 300, type: "string"},
        {text: "申报地区", dataIndex: "AD_NAME", width: 150, type: "string"},
        {text: "申请类型_id", dataIndex: "BOND_TYPE_ID", width: 200, type: "string", hidden: true},
        {text: "申请类型", dataIndex: "BOND_TYPE_ID_NAME", width: 150, type: "string"},
        {
            text: "申请总金额(万元)", dataIndex: "APPLY_AMT", width: 150, type: "float", summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            }
        },
        {
            text: "新增债券申请金额(万元)",
            dataIndex: "APPLY_XZ_AMT",
            width: 200,
            type: "float",
            summaryType: 'sum',
            hidden: true,
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            }
        },
        {
            text: "置换债券申请金额(万元)",
            dataIndex: "APPLY_ZH_AMT",
            width: 200,
            type: "float",
            summaryType: 'sum',
            hidden: true,
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            }
        },
        {text: "申报日期", dataIndex: "APPLY_DATE", width: 100, type: "string"},
        {text: "经办人", dataIndex: "APPLY_INPUTOR", width: 150, type: "string"},
        {text: "备注", dataIndex: "REMARK", width: 300, type: "string"}];
    var HEADERJSON_mx = [
        {
            xtype: 'rownumberer', summaryType: 'count', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            text: "债券/债务名称", dataIndex: "ZQ_NAME", type: "string", width: 400, hidden: false,
            renderer: function (data, cell, record) {
                if (record.get('DATA_TYPE') == 'ZW') {
                    var url = '/page/debt/common/zwyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "zw_id";
                    paramNames[1] = "zwlb_id";
                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('ZW_ID'));
                    paramValues[1] = encodeURIComponent(record.get('ZWLB_ID'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                } else {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('ZQ_ID');
                    paramValues[1] = AD_CODE;
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            }
        },
        {text: "再融资债券单编码", dataIndex: "BILL_NO", width: 120, type: "string", hidden: true},
        {
            text: "申请金额(万元)", dataIndex: "APPLY_AMT", width: 150, type: "float", summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            }
        },
        {
            text: "新增债券申请金额(万元)",
            dataIndex: "APPLY_XZ_AMT",
            width: 200,
            type: "float",
            summaryType: 'sum',
            hidden: true,
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            }
        },
        {
            text: "置换债券申请金额(万元)",
            dataIndex: "APPLY_ZH_AMT",
            width: 200,
            type: "float",
            summaryType: 'sum',
            hidden: true,
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            }
        },
        {text: "到期日期", dataIndex: "DF_END_DATE", width: 100, type: "string"},
        {
            text: "到期金额(万元)", dataIndex: "PLAN_AMT", width: 150, type: "float",
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            }
        },
        {
            text: "新增债券到期金额(万元)", dataIndex: "PLAN_XZ_AMT", width: 200, type: "float", summaryType: 'sum', hidden: true,
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            }
        },
        {
            text: "置换债券到期金额(万元)", dataIndex: "PLAN_ZH_AMT", width: 200, type: "float", summaryType: 'sum', hidden: true,
            renderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value / 10000, '0,000.00');
            }
        },
        {text: "上级审核意见", dataIndex: "SBYJ", width: 300, type: "string"},
        {text: "备注", dataIndex: "REMARK", width: 300, type: "string"},
        {text: "明细id", dataIndex: "BILL_DTL_ID", width: 200, type: "string", hidden: true},
        {text: "ZW_ID", dataIndex: "ZW_ID", width: 100, type: "string", hidden: true},
        {text: "ZWLB_ID", dataIndex: "ZWLB_ID", width: 100, type: "string", hidden: true},
        {text: "DATA_TYPE", dataIndex: "DATA_TYPE", width: 100, type: "string", hidden: true}
    ];
    /**
     * 页面初始化
     */
    $(function () {
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
            if (!wf_id || node_code == 1) {
                initContent();
                return false;
            }
            //根据节点名称初始化状态下拉框store
            if (node_type == 'jxhjsh') {
                json_zt = json_debt_zt2_4;
            };
            if (node_type == 'jxhjsb') {
                json_zt = json_debt_zt5_2;
            };
            if (node_type == 'jxhjxjsh') {
                json_zt = json_debt_zt2_3;
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
                align: 'stretch'
            },
            border: false,
            dockedItems: json_common.items_content_rightPanel_dockedItems ? json_common.items_content_rightPanel_dockedItems : null,
            items: json_common.items_content_rightPanel_items ? json_common.items_content_rightPanel_items() : [
                initContentGrid(),
                initContentDetilGrid()
            ]
        });
    }

    function initContentGrid() {
        var headerJson = HEADERJSON;
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '50%',
            flex: 1,
            dataUrl: '/JxhjMainGrid.action',
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            params: {
                NODE_CODE: node_code,
                AD_CODE: USER_AD_CODE,
                WF_STATUS: WF_STATUS,
                USERCODE: USER_AD_CODE,
                WF_ID: wf_id
            },
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: DebtEleStore(json_debt_zt2),
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
                            reloadMain();
                        }
                    }
                },
                {
                    xtype: 'treecombobox',
                    fieldLabel: '申报批次',
                    displayField: 'name',
                    valueField: 'id',
                    name: 'BATCH_NO',
                    store: DebtEleTreeStoreDB('DEBT_FXPC', {condition: " and (EXTEND1 like '03%' OR EXTEND1 IS NULL) "}),
                    editable: false,
                    width: 400,
                    labelWidth: 70,
                    labelAlign: 'right',
                    listeners: {
                        select: function (combo, record, index) {
                            reloadMain();
                        }
                    }
                }
            ],
            features: [{
                ftype: 'summary'
            }],
            listeners: {
                itemclick: function (self, record) {
                    var mx_grid = DSYGrid.getGrid("contentGrid_detail");
                    mx_grid.getStore().getProxy().extraParams['BILL_ID'] = record.get("BILL_ID");
                    mx_grid.getStore().loadPage(1);
                }
            }
        });
    }

    /**
     * 初始化右侧明细表格
     */
    function initContentDetilGrid(config_ex) {
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
            params: {
                node_type: node_type

            },
            autoLoad: false,
            border: false,
            height: '50%',
            width: '100%',
            pageConfig: {
                enablePage: false
            },
            dataUrl: '/JxhjMainMx.action',
            tbar: [
                {
                    text: '保存',
                    xtype: 'button',
                    itemId: 'save_button',
                    name: 'save',
                    icon: '/image/sysbutton/save.png',
                    handler: function (btn) {
                        var store = btn.up('grid').getStore();
                        var jh_datas = store.getModifiedRecords();
                        var data = store.getData();
                        for (var i = 0; i < data.length; i++) {
                            if (data.items[i].data.SBZT == 0 && (!data.items[i].data.SBYJ || data.items[i].data.SBYJ == '')) {
                                Ext.Msg.alert('提示', '不通过数据必须填写审核意见！');
                                return false;
                            }
                        }
                        for (var i = 0; i < jh_datas.length; i++) {
                            jh_datas[i] = jh_datas[i].data;
                        }
                        ///发送ajax请求，修改计划信息
                        $.post("/updateZqxmZhzqJhXjsh.action", {
                            updateData: Ext.util.JSON.encode(jh_datas)
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: "保存成功！" + (data.message ? data.message : ''),
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                //刷新表格
                                store.loadPage(1);
                            } else {
                                Ext.MessageBox.alert('提示', data.message);
                            }
                        }, "json");
                    }
                },
                {
                    text: '取消',
                    xtype: 'button',
                    name: 'cancel',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        var store = btn.up('grid').getStore();
                        var data = store.getData();
                        if (data.length <= 0) {
                            Ext.Msg.alert('提示', '请选择一条数据！');
                            return false;
                        }
                        store.rejectChanges();
                    }
                }
            ],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'cellEdit',
                    clicksToMoveEditor: 1,
                    listeners: {
                        'beforeedit': function (editor, context) {
                            if (WF_STATUS != '001') {
                                return false;
                            }
                            //如果审核状态是不通过，并且下级审核不通过区划不是当前用户区划，不能修改
                            if (context.field == 'SBZT' || context.field == 'SBYJ') {
                                if (context.record.get('SB_AD_CODE') && context.record.get('SB_AD_CODE') != USER_AD_CODE)
                                    return false;
                            }
                        }
                    }
                }
            ]
        };
        if (config_ex) {
            config = $.extend(false, config, config_ex);
        }
        if (json_common.item_content_detailgrid_config) {
            config = $.extend(false, config, json_common.item_content_detailgrid_config);
        }
        return DSYGrid.createGrid(config);
    }

    function reloadGrid(param, param_detail) {
        if (json_common.reloadGrid) {
            json_common.reloadGrid(param);
        } else {
            var grid = DSYGrid.getGrid('contentGrid');
            var store = grid.getStore();

            //增加查询参数
            store.getProxy().extraParams["AD_CODE"] = AD_CODE;
            store.getProxy().extraParams["AG_CODE"] = AG_CODE;
            if (typeof param != 'undefined' && param != null) {
                for (var i in param) {
                    store.getProxy().extraParams[i] = param[i];
                }
            }
            //刷新
            store.loadPage(1);
            //刷新下方表格,置为空
            if (DSYGrid.getGrid('contentGrid_detail')) {
                var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
                //如果传递参数不为空，就刷新明细表格
                if (typeof param_detail != 'undefined' && param_detail != null) {
                    for (var i in param_detail) {
                        store_details.getProxy().extraParams[i] = param_detail[i];
                    }
                    store_details.loadPage(1);
                } else {
                    store_details.removeAll();
                }
            }
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

    function toast_util(button_name, is_success, respText) {
        if (is_success == null || is_success == undefined) {
            is_success = true;
        }
        if (is_success) {
            Ext.toast({
                html: button_name + "成功！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
        } else {
            if (respText.message != null && respText != undefined && respText != "") {
                Ext.MessageBox.alert(button_name + "失败", respText.message);
            } else {
                Ext.MessageBox.alert(button_name + "失败", button_name + "失败");
            }
        }

    }
</script>
</body>
</html>
