<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>债券到期赎回</title>
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
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var wf_id = "${fns:getParamValue('wf_id')}";//当前工作流id
    var node_type = "${fns:getParamValue('node_type')}";//当前节点名称
    var node_code = "${fns:getParamValue('node_code')}";//当前结点
    var IS_END = "${fns:getParamValue('is_end')}";//当前结点
    if (isNull(IS_END)) {
        IS_END = 0;
    }
    var button_name;
    var button_text;
    // 全局参数 控制字段隐藏
    var shOpen = false;
    //定义对象
    var hbfxzf_json_common = {
        'lr': {
            jsFileUrl: 'zqdqshlr.js'
        },
        'sh': {
            jsFileUrl: 'zqdqshsh.js'
        }
    };
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }

    var store_sh = DebtEleStore([
        {code: '0', name: '不赎回'},
        {code: '1', name: '赎回'}
    ]);

    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        //动态加载js
        $.ajaxSetup({
            cache: true
        });
        $.getScript(hbfxzf_json_common[node_type].jsFileUrl, function () {
            if (node_type == 'xmjxFjglsh') {
            }
            initMain();
        })
    });

    // 返回实时更新的报表头
    function getHeaderJson() {
        // 统一json头
        var comHeaderJson = [
            {
                xtype: 'rownumberer',
                summaryType: 'count',
                width: 40
            },
            {
                "dataIndex": "ZQSH_PLAN_ID",
                "type": "string",
                "text": "业务ID",
                "fontSize": "15px",
                "hidden": true
            },
            {
                text: "是否提前赎回",
                dataIndex: "IS_SH",
                type: "string",
                width: 120,
                hidden: shOpen,
                renderer: function (value, metadata, record) {
                    if (value == null || value == '') {
                        record.data.IS_SH = 1;
                        value = 1;
                    }
                    var rec = store_sh.findRecord('code', value, 0, false, true, true);
                    return rec.get('name');
                },
                editor: {
                    xtype: 'combobox',
                    displayField: 'name',
                    valueField: 'code',
                    store: store_sh,
                    editable: false
                }
            },
            {
                text: "备注",
                dataIndex: "REMARK",
                width: 250,
                type: "string",
                editor: 'textfield',
                hidden: shOpen
            },
            {
                "dataIndex": "AD_CODE",
                "type": "string",
                "text": "区划编码",
                "fontSize": "15px",
                "width": 100,
                hidden: true
            },
            {
                "dataIndex": "AD_NAME",
                "type": "string",
                "text": "区划名称",
                "fontSize": "15px",
                "width": 100
            },
            {
                "dataIndex": "ZQ_CODE",
                "type": "string",
                "text": "债券编码",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "ZQ_NAME",
                "type": "string",
                "text": "债券名称",
                "fontSize": "15px",
                "width": 250
            },
            {
                "dataIndex": "ZQQX_ID",
                "type": "string",
                "text": "债券期限",
                "fontSize": "15px",
                "width": 100
            },
            {
                "dataIndex": "FX_START_DATE",
                "type": "string",
                "text": "发行日期",
                "fontSize": "15px",
                "width": 150
            },
            {
                "dataIndex": "SHMS",
                "type": "string",
                "text": "赎回方式",
                "fontSize": "15px",
                "width": 100
            },
            {
                "dataIndex": "SH_AMT",
                "type": "float",
                "text": "赎回金额",
                "fontSize": "15px",
                "width": 200,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                }
            }
        ];
        return comHeaderJson;
    }

    /**
     * 主界面初始化
     */
    function initMain() {
        /**
         * 工具栏
         */
        var screenBar = getScreenBar();
        /**
         * 项目信息列表表头
         */
        var config = {
            itemId: 'contentGrid',
            flex: 1,
            region: 'center',
            headerConfig: {
                headerJson: getHeaderJson(),
                columnAutoWidth: false
            },
            enableLocking: false,
            autoLoad: false,
            dataUrl: '/bjsh/getDqZqMain.action',
            selModel: {
                mode: "SIMPLE"
            },
            checkBox: true,
            border: false,
            height: '50%',
            tbar: screenBar,
            pageConfig: {
                enablePage: true,
                pageNum: true//设置显示每页条数
            },
            listeners: {
                select: function (self, record, index, eOpts) {
                },
                itemclick: function (self, record) {
                    // 以项目id和绩效年度为业务id
                    getUpPane(record.get("ZQSH_PLAN_ID"));
                }
            }
        };
        var grid = DSYGrid.createGrid(config);
        /**
         * 项目信息录入界面主面板初始化
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
            items: getAdTree(grid),
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: getTbar()
                }
            ]
        });
        reloadGrid();
        getUpPane();
    }

    // 动态加载区划
    function getAdTree(grid) {
        var re = [];
        if (node_type == 'sh') {
            re = [
                initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: 0//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    },
                    items_tree: function () {
                        return [
                            initContentTree_area(),//初始化左侧区划树
                        ];
                    },
                }),
                initContentRightPanel(grid)
            ];
        } else {
            re = [
                initContentRightPanel(grid)
            ];
        }
        return re;
    }

    // 加载附件展示框
    // function getUpPane(id) {
    //     var uploadpanel = UploadPanel.createGrid({
    //         busiType: 'ET909',
    //         busiId: id,
    //         editable: false
    //     });
    //     var item = [uploadpanel];
    //     var panel = Ext.getCmp('upPanel');
    //     panel.removeAll();
    //     panel.add(item);
    //     panel.doLayout();
    // }

    // 初始化右侧panel，放置表格
    function initContentRightPanel(grid) {
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
            items: [
                grid,
                initContentUploadPanelNew()
            ]
        });
    }
    // 添加附件个数
    function initContentUploadPanelNew() {
        return Ext.create('Ext.tab.Panel', {
            name: 'EditorPanelNew',
            flex: 1,
            border: false,
            defaults: {
                border: false
            },
            items: [
                {
                    title: '附件<span class="file_sum_fj" style="color: #FF0000;">(0)</span>',
                    name: 'xmjxFjNew',
                    layout: 'fit',
                    items: initContentFJ()
                }
            ]
        });
    }

    function initContentFJ() {
        return Ext.create('Ext.form.Panel', {
            id: 'upPanelFJ',
            name: 'upPanelFJ',
            layout: 'fit',
            border: false,
            items: []
        });
    }

    function getUpPane(BUIS_ID) {

        var grid = UploadPanel.createGrid({
            busiType: '',//业务类型
            busiId: BUIS_ID,//业务ID
            editable: false
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
            if (grid.up('winPanel_xmjxPanel') && grid.up('winPanel_xmjxPanel').el && grid.up('winPanel_xmjxPanel').el.dom) {
                $(grid.up('winPanel_xmjxPanel').activeTab.el.dom).find('span.file_sum_fj').html('(' + sum + ')');
            } else if ($('span.file_sum_fj')) {
                $('span.file_sum_fj').html('(' + sum + ')');
            }
        });

        var item = [grid];
        var panel = Ext.getCmp('upPanelFJ');
        panel.removeAll();
        panel.add(item);
        panel.doLayout();
    }

    // 无附件个数
    function initContentUploadPanel() {
        return Ext.create('Ext.form.Panel', {
            id: 'upPanel',
            name: 'upPanelName',
            layout: 'fit',
            border: false,
            items: []
        });
    }

    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid() {
        var store = DSYGrid.getGrid('contentGrid').getStore();
        var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].getValue();
        store.getProxy().extraParams = {
            MHCX: mhcx,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            wf_id: wf_id,
            node_code: node_code,
            wf_status: WF_STATUS
        };
        store.loadPage(1);
        // getUpPane();
    }

</script>
</body>
</html>
