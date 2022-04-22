<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <title>项目资产</title>
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <!--基础数据集-->
    <script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
</head>
<body>
<script>
    var userCode = '${sessionScope.USERCODE}';
    var wf_id = "${fns:getParamValue('wf_id')}";//当前流程id
    var node_code = "${fns:getParamValue('node_code')}";//当前节点id
    var node_type = "${fns:getParamValue('node_type')}";//当前节点类型
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    var is_end = "${fns:getParamValue('is_end')}";//流程是否结束
    //20210712 chenfei 从单位首页跳转过来 打开选择资产信息弹窗
    var url_xm_id = "${fns:getParamValue('url_xm_id')}";
    var button_name = '';
    //20210521 fzd 获取角色类型
    var dwRoleType = "${fns:getParamValue('dwRoleType')}";
    var audit_info = '';
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var SBQJ;//20210526LIYUE 上报期间过滤
    var zcgl_json_common = {
        100737: {
            "xmzclr": {//项目资产录入
                jsFileUrl: 'xmzclr.js'
            },
            "xmzcsh": {//项目资产审核
                jsFileUrl: 'xmzcsh.js'
            }
        }
    };
    var IS_INPUT_WXCZC_REASON;//是否录入未形成资产原因
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        $.post("/getParamValueAll.action", function (data) {
            var REASON = data[0].IS_INPUT_WXCZC_REASON;
            if (REASON == 0) {
                IS_INPUT_WXCZC_REASON = false;
            } else if(REASON == 1) {
                IS_INPUT_WXCZC_REASON = true;
            }
        },"json");
        Ext.form.Field.prototype.msgTarget = 'side';
        //动态加载js
        $.ajaxSetup({
            cache: true
        });
        //20210806 chenfei 增加单位首页跳转
        setTimeout(function(){
            //从单位新首页跳转过来
            if(!isNull(url_xm_id)){
                if(node_type == 'xmzclr'){
                    $.post("/getExistProjectGrid.action", {
                        XM_ID: url_xm_id
                    }, function (data) {
                        button_name = '增加';
                        zclrWindow.show();
                        zclrWindow.window.down('form#zclrForm').getForm().setValues(data.list[0]);
                        DSYGrid.getGrid('zclrGrid').getStore().insertData(null, {});
                    }, "json");
                }
            }
        }, 1000);
        $.getScript(zcgl_json_common[wf_id][node_type].jsFileUrl, function () {
            initContent();
            if (zcgl_json_common[wf_id][node_type].callBack) {
                zcgl_json_common[wf_id][node_type].callBack();
            }
        });
    });
    function initContent() {
        Ext.create('Ext.panel.Panel',{
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
                    items: zcgl_json_common[wf_id][node_type].items[WF_STATUS]
                }
            ],
            items: zcgl_json_common[wf_id][node_type].items_content()
        });
    }

    //加载页面主窗口
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            defaults: {
                flex: 1,
                width: '100%'
            },
            border: false,
            items: zcgl_json_common[wf_id][node_type].items_content_rightPanel_items ? zcgl_json_common[wf_id][node_type].items_content_rightPanel_items() : [
                initXMZCTBGrid(),
                initXMZCTBMXGrid()
            ]
        });
    }

    /**
     * 明细表
     */
    function initXMZCTBMXGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 45},
            {
                "dataIndex": "XMZC_DTL_ID",
                "type": "string",
                "hidden" : true
            },
            {
                "dataIndex": "XMZC_NAME",
                "type": "string",
                "text": "资产名称",
                "width": 170
            },
            {
                "dataIndex": "ZCLB_NAME",
                "type": "string",
                "text": "资产类别",
                "width": 170
            },
            {
                "dataIndex": "ZCXZ_NAME",
                "type": "string",
                "text": "资产性质",
                "width": 170
            },
            {
                "dataIndex": "BXNL_ID",
                "type": "string",
                "text": "变现能力",
                "width": 170,
                'renderer': function (value, metadata, record) {
                    if (value == '') {
                        return;
                    }
                    var rec = BXNL_ID_Store.findRecord('code', value, 0, false, true, true);
                    if (rec == null) {
                        return '';
                    }
                    return rec.get('name');
                }
            },
            {
                "dataIndex": "BUILD_STATUS_NAME",
                "type": "string",
                "text": "建设状态",
                "width": 170
            },
            {
                "dataIndex": "JLDW_NAME",
                "type": "string",
                "text": "计量单位",
                "width": 100
            }, {
                "dataIndex": "ZC_NUM",
                "width": 100,
                "type": "number",
                "align": 'right',
                "text": "数量"
            }, {
                "dataIndex": "RZ_DATE",
                "width": 150,
                "type": "string",
                "text": "转固/入账时间"
            }, {
                "header": "资产价值(万元)",
                'colspan': 2,
                'align': 'center',
                'columns': [{
                    "dataIndex": "ZJYZ_AMT",
                    "width": 150,
                    "type": "float",
                    "text": "原值"
                }, {
                    "dataIndex": "ZCJZ_AMT",
                    "width": 150,
                    "type": "float",
                    "text": "净值"
                }, {
                    "dataIndex": "YGJZ_AMT",
                    "width": 150,
                    "type": "float",
                    "text": "预估价值"
                }]
            },
            // {
            //     "header": "资产处置情况",
            //     'colspan': 2,
            //     'align': 'center',
            //     'columns': [
            //         {
            //             "dataIndex": "CZLX_NAME",
            //             "width": 150,
            //             "type": "string",
            //             "text": "处置类型"
            //         },
            //         {
            //             "dataIndex": "CZSR_AMT",
            //             "width": 200,
            //             "type": "float",
            //             "text": "本期处置收入(万元)"
            //         }
            //     ]
            // },
            {
                "dataIndex": "CZSR_AMT",
                "width": 200,
                "type": "float",
                "text": "本期资产处置收入(万元)"
            },
            {
                "dataIndex": "DYDB_AMT",
                "width": 220,
                "type": "float",
                "text": "抵押质押及担保金额(万元)"
            }, {
                "dataIndex": "REMARK",
                "width": 200,
                "type": "string",
                "text": "备注"
            }
        ];
        var defaultConfig = {
            itemId: 'zcmxGrid',
            title: '',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            rowNumber: true,
            border: false,
            flex: 1,
            autoLoad: false,
            params: {
                XMZC_ID: ''
            },
            dataUrl: 'getXmzcMxGrid.action',
            pageConfig: {
                enablePage: false//设置分页为false
            }
        };
        return DSYGrid.createGrid(defaultConfig);
    }

    /**
     * 创建填写意见对话框
     */
    var opinionWindow = {
        window: null,
        open: function (action, title) {
            Ext.MessageBox.buttonText.ok = '确认';
            Ext.MessageBox.buttonText.cancel = '取消';
            Ext.MessageBox.alert('提示', '审核后不予许撤销请确认！');
            this.window = Ext.MessageBox.show({
                title: title,
                width: 350,
                buttons: Ext.MessageBox.OKCANCEL,
                multiline: true,
                fn: function (btn, text) {
                    audit_info = text;
                    if (btn == "ok") {
                        if (action == 'NEXT') {
                            next();
                        } else if (action == 'BACK') {
                            back("BACK");
                        }
                    }
                }
                //animateTarget: btn_target
            });
        },
        close: function () {
            if (this.window) {
                this.window.close();
            }
        }
    };

    /**
     * 送审/审核
     */
    function next() {
        var records = DSYGrid.getGrid('zctbGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
            return false;
        }
        //判断操作按钮
        if (node_type == 'xmzclr') {
            button_name = '送审';
        } else if (node_type == 'xmzcsh') {
            button_name = '审核';
        }
        var bgInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.ID = record.get("XMZC_ID");
            array.AD_CODE = record.get("AD_CODE");
            bgInfoArray.push(array);
        });
        //向后台传递变更数据信息
        $.post('nextXmzcInfo.action', {
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            audit_info: audit_info,
            is_end: is_end,
            bgInfoArray: Ext.util.JSON.encode(bgInfoArray)
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: button_name + "成功！" + (data.message ? data.message : ''),
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                DSYGrid.getGrid("zctbGrid").getStore().loadPage(1);
                DSYGrid.getGrid("zcmxGrid").getStore().removeAll();
            } else {
                Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
                DSYGrid.getGrid("zctbGrid").getStore().loadPage(1);
                DSYGrid.getGrid("zcmxGrid").getStore().removeAll();
            }
        }, 'json');
    }
    /**
     * 退回/撤销
     */
    function back(btnName) {
        var records = DSYGrid.getGrid('zctbGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
            return false;
        }
        var records = DSYGrid.getGrid('zctbGrid').getSelectionModel().getSelection();
        DSYGrid.getGrid("zcmxGrid").getStore().loadPage(1);
        var bgInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.ID = record.get("XMZC_ID");
            array.XM_ID = record.get("XM_ID");
            bgInfoArray.push(array);
        });
        //向后台传递变更数据信息
        $.post('/backXmzcInfo.action', {
            wf_id: wf_id,
            node_code: node_code,
            button_name: btnName,
            audit_info: audit_info,
            is_end: is_end,
            bgInfoArray: Ext.util.JSON.encode(bgInfoArray)
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: button_name + "成功！" + (data.message ? data.message : ''),
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                DSYGrid.getGrid("zctbGrid").getStore().loadPage(1);
                DSYGrid.getGrid("zcmxGrid").getStore().removeAll();
            } else {
                Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
                DSYGrid.getGrid("zctbGrid").getStore().loadPage(1);
                DSYGrid.getGrid("zcmxGrid").getStore().removeAll();
            }
        }, 'json');
    }

    /**
     * 重新加载项目资产填报表格
     */
    function getHbfxDataList() {
        var store = DSYGrid.getGrid('zctbGrid').getStore();
        var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
/*
        var SBQJ = Ext.ComponentQuery.query('combobox[name="SBQJ"]')[0].value;
*/
        //初始化表格Store参数
        store.getProxy().extraParams = {
            mhcx: mhcx,
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            WF_STATUS: WF_STATUS,
            WF_ID: wf_id,
            NODE_CODE: node_code,
            NODE_TYPE: node_type,
            USERCODE:userCode,
            dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
        };
        //刷新表格内容
        store.loadPage(1);
        DSYGrid.getGrid("zcmxGrid").getStore().removeAll();
    }
    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {
        var grid = DSYGrid.getGrid('zctbGrid');
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
        if (DSYGrid.getGrid('zcmxGrid')) {
            var store_details = DSYGrid.getGrid('zcmxGrid').getStore();

            //如果传递参数不为空，就刷新明细表格
            if (typeof param_detail != 'undefined' && param_detail != null) {
                for (var i in param_detail) {
                    store_details.getProxy().extraParams[i] = param_detail[i];
                    store1.getProxy().extraParams[i] = param_hz[i];
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
