<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>项目绩效附件管理</title>
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
    var XM_ID = ''; // 项目ID
    var grid_error_message = '';
    var grid;
    var wf_id = "${fns:getParamValue('wf_id')}";//当前工作流id
    var node_type = "${fns:getParamValue('node_type')}";//当前节点名称
    var node_code = "${fns:getParamValue('node_code')}";//当前结点
    var IS_END = "${fns:getParamValue('is_end')}";//当前结点
    var button_name;
    var button_text;
    var tbarItem = '';//下拉框json数据
    var YEAR = null;//绩效年度过滤
    //定义对象
    var hbfxzf_json_common = {
        'xmjxFjgllr': {
            jsFileUrl: 'xmjxFjgllr.js'
        },
        'xmjxFjglsh': {
            jsFileUrl: 'xmjxFjglsh.js'
        }
    };
    /*工作流状态2*/
    var json_debt_zt2_4 = [
        {id: "001", code: "001", name: "未审核"},
        {id: "002", code: "002", name: "已审核"},
        {id: "008", code: "008", name: "曾经办"}
    ];
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    // 绩效年度
    var json_debt_year = [
        {id: "2019", code: "2019", name: "2019年"},
        {id: "2020", code: "2020", name: "2020年"},
        {id: "2021", code: "2021", name: "2021年"},
        {id: "2022", code: "2022", name: "2022年"},
        {id: "2023", code: "2023", name: "2023年"},
        {id: "2024", code: "2024", name: "2024年"},
        {id: "2025", code: "2025", name: "2025年"},
        {id: "2026", code: "2026", name: "2026年"},
        {id: "2027", code: "2027", name: "2027年"},
        {id: "2028", code: "2028", name: "2028年"},
        {id: "2029", code: "2029", name: "2029年"},
        {id: "2030", code: "2030", name: "2030年"},
        {id: "2031", code: "2031", name: "2031年"},
        {id: "2032", code: "2032", name: "2032年"},
        {id: "2033", code: "2033", name: "2033年"},
        {id: "2034", code: "2034", name: "2034年"},
        {id: "2035", code: "2035", name: "2035年"},
        {id: "2036", code: "2036", name: "2036年"},
        {id: "2037", code: "2037", name: "2037年"},
        {id: "2038", code: "2038", name: "2038年"},
        {id: "2039", code: "2039", name: "2039年"},
        {id: "2040", code: "2040", name: "2040年"},
        {id: "2041", code: "2041", name: "2041年"},
        {id: "2042", code: "2042", name: "2042年"},
        {id: "2043", code: "2043", name: "2043年"},
        {id: "2044", code: "2044", name: "2044年"},
        {id: "2045", code: "2045", name: "2045年"},
        {id: "2046", code: "2046", name: "2046年"},
        {id: "2047", code: "2047", name: "2047年"},
        {id: "2048", code: "2048", name: "2048年"},
        {id: "2049", code: "2049", name: "2049年"},
        {id: "2050", code: "2050", name: "2050年"}
    ];
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
        var headerJson = [
            {
                xtype: 'rownumberer',
                summaryType: 'count',
                width: 40
            },
            {
                "dataIndex": "BUIS_ID",
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
                "width": 200
            }, {
                "dataIndex": "XM_CODE",
                "type": "string",
                "text": "项目编码",
                "fontSize": "15px",
                "width": 300
            }, {
                "dataIndex": "XM_NAME",
                "type": "string",
                "text": "项目名称",
                "fontSize": "15px",
                "width": 230,
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
                "dataIndex": "JX_YEAR",
                "type": "string",
                "text": "绩效年度",
                "fontSize": "15px",
                "width": 100
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
            itemId: 'contentGrid',
            flex: 1,
            region: 'center',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            enableLocking: false,
            autoLoad: false,
            dataUrl: '/bj/getXmjxFjglMain.action',
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
                    getUpPane(record.get("BUIS_ID"));
                }
            }
        };
        grid = DSYGrid.createGrid(config);
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
            items: [
                initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: 0//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    }
                }),
                initContentRightPanel()
            ],
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: getTbar()
                }
            ]
        });
    }

    // 加载附件展示框-无附件统计
    // function getUpPane(BUIS_ID) {
    //     var uploadpanel = UploadPanel.createGrid({
    //         busiType: 'ET909',
    //         busiId: BUIS_ID,
    //         editable: false
    //     });
    //     var item = [uploadpanel];
    //     var panel = Ext.getCmp('upPanel');
    //     panel.removeAll();
    //     panel.add(item);
    //     panel.doLayout();
    // }

    /**
     * 初始化右侧panel，放置表格
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
        if (AD_CODE == null || AD_CODE == '') {
            Ext.Msg.alert('提示', '请选择区划！');
            return;
        }
        var store = DSYGrid.getGrid('contentGrid').getStore();
        var mhcx = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].getValue();
        var jx_year = Ext.ComponentQuery.query('combobox[name="YEAR"]')[0].getValue();
        store.getProxy().extraParams = {
            MHCX: mhcx,
            JX_YEAR: jx_year,
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            wf_id: wf_id,
            node_code: node_code,
            wf_status: WF_STATUS
        };
        store.loadPage(1);
        getUpPane();
    }

    /**
     * 项目附件导出
     **/
    function xmfjxz() {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        Ext.Msg.confirm('提示', '即将导出所有附件，是否继续？', function (btn) {
            if (btn == 'yes') {
                var store = DSYGrid.getGrid('contentGrid').getStore();
                store.each(function (record) {
                    records.push(record);
                });
                submit(records);
            }
        });
    }

    /* 提交 */
    function submit(records) {
        var xmIds = [];
        records.forEach(function (record) {
            xmIds.push(record.get('BUIS_ID'));
        });
        Ext.Msg.wait('正在下载文件到服务器，请稍等……', '提示', {text: '加载中……'});
        Ext.Ajax.request({
            url: '/bj/getXmjxFj.action',
            method: 'POST',
            timeout: 1800000,//响应时间超过三十分钟报错
            params: {
                xmIds: xmIds,
            },
            success: function (response) {
                var text = Ext.decode(response.responseText);
                if (text.success) {
                    var file_name = text.file_name;
                    var message = text.message;
                    Ext.Msg.close();
                    //文件太大，给出提示
                    if (!!message) {
                        Ext.Msg.confirm('提示', message, function (btn) {
                            if (btn == 'yes') {
                                Ext.Msg.wait('正在压缩文件，请稍等……', '提示', {text: '加载中……'});
                                $.post('/bj/downloadXmFileZip.action', {
                                    file_name: file_name,
                                    xzfs: '2'
                                }, function (data) {
                                    Ext.Msg.close();
                                    Ext.Msg.alert('提示', data.message);
                                }, "json");
                            } else {
                                window.location.href = 'bj/downloadXmFileZip.action?file_name=' + encodeURI(encodeURI(file_name)) + '&xzfs=1';
                            }
                        });
                    } else {
                        window.location.href = 'bj/downloadXmFileZip.action?file_name=' + encodeURI(encodeURI(file_name)) + '&xzfs=1';
                    }
                } else {
                    //先关闭滚动条
                    Ext.Msg.close();
                    Ext.Msg.alert('提示', '文件下载失败！' + text.message);
                }
                //刷新grid
                DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
            },
            failure: function (reponse) {
                //先关闭滚动条
                Ext.Msg.close();
                Ext.Msg.alert('提示', '文件下载失败！');
            }
        });
    }
</script>
</body>
</html>