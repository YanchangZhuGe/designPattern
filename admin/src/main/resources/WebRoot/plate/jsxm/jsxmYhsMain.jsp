<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--<%@ page import="com.bgd.platform.util.common.DsyEscapeTool" %>--%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>加载中..</title>
    <style type="text/css">
        span.displayfield {
            font-weight: bolder;
            font-size: 16px;
        }
    </style>

</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/js/debt/xmsySzysGrid.js"></script>
<script type="text/javascript" src="/js/debt/xmInfo.js"></script>
<%-- 2021090710_dengzq_一户式穿透绩效隐藏--%>
<script type="text/javascript" src="/page/debt/jxgl/jxpjgl/jxpjxxck.js"></script>
<%--<script type="text/javascript" src="/page/debt/jxgl/sqjxpg/sqjxpg.js"></script>--%>

<script type="text/javascript">
    <%--<%--%>
    <%--String xm_id = DsyEscapeTool.escapeParamValue(request,"XM_ID",100,"String");--%>
    <%--String bill_id = DsyEscapeTool.escapeParamValue(request,"ID",100,"String");;--%>
    <%--%>--%>
    <%--var XM_ID = ${XM_ID};//项目--%>
    <%--var ID =  ${ID};--%>
    var AD_CODE = '${fns:getParamValue("AD_CODE")}'.replace(/00$/, "");
    var XM_ID = "${fns:getParamValue('XM_ID')}";
    var ID = "${fns:getParamValue('ID')}";
    // 项目一户式全局对象，添加项目主要属性
    WINDOW_XM_YHS.XM_ID = XM_ID;
    WINDOW_XM_YHS.BILL_ID = ID;
    // 设置显示页签的itemId
    var ACTIVE_TAB_ID = "${fns:getParamValue('ACTIVE_TAB_ID')}";
    showType = 'jsxmyhs';
    var IS_XMBCXX = '${fns:getSysParam("IS_XMBCXX")}';  //获取系统参数 项目补充信息是否显示
    var IS_FZJCK = '${fns:getSysParam("IS_FZJCK")}';  //获取系统参数 是否复杂基础库
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    var sysAdcode = '${fns:getSysParam("ELE_AD_CODE")}';
    var is_show = sysAdcode == '42' ? true : sysAdcode == '21' ? false : 1;

    //var userName = '';
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
        // 显示指定页签
        if (!!ACTIVE_TAB_ID) {
            setActiveTabPanelByItemId(ACTIVE_TAB_ID);
        }
    });

    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        if (IS_XMBCXX == '1') {
            if (IS_FZJCK == '1' || is_show == false) {
                var tab_items = {
                    'jbqk': {},
                    'csqk': {},
                    'bcxx': {},
                    'tzjh': {},
                    'szys': {},
                    'sdgc': {},
                    'clzw': {},/*'xmzc':{},*/
                    'ztb': {},/*'jsjd':{},*/
                    'szjs': {},
                    'sjsy': {},
                    'bgjl': {},
                    'xmfj': {}
                };
            } else {
                var tab_items = {
                    'jbqk': {},
                    'bcxx': {},
                    'tzjh': {},
                    'szys': {},
                    'sdgc': {},
                    'clzw': {},/*'xmzc':{},*/
                    'ztb': {},/*'jsjd':{},*/
                    'szjs': {},
                    'sjsy': {},
                    'bgjl': {},
                    'xmfj': {}
                };
            }
        } else {
            if (IS_FZJCK == '1' || is_show == false) {
                var tab_items = {
                    'jbqk': {},
                    'csqk': {},
                    'tzjh': {},
                    'szys': {},
                    'sdgc': {},
                    'clzw': {},/*'xmzc':{},*/
                    'ztb': {},/*'jsjd':{},*/
                    'szjs': {},
                    'sjsy': {},
                    'bgjl': {},
                    'xmfj': {}
                };
            } else {
                var tab_items = {
                    'jbqk': {},
                    'tzjh': {},
                    'szys': {},
                    'sdgc': {},
                    'clzw': {},/*'xmzc':{},*/
                    'ztb': {},/*'jsjd':{},*/
                    'szjs': {},
                    'sjsy': {},
                    'bgjl': {},
                    'xmfj': {}
                };
            }
        }
        //2021090710_dengzq_一户式穿透绩效隐藏
        // 添加事前绩效评估页签
//        tab_items['sqjxpg'] = {};
        // 绩效目标页签
        tab_items['jxmb'] = {};
        // 绩效评价页签
        tab_items['jxpj'] = {};
        Ext.create('Ext.panel.Panel', {
            layout: {
                type: 'hbox',
                align: 'middle',
                pack: 'center'
            },
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            items: [initWindow_zqxxtb_contentForm(tab_items)]
        });
        loadXmxxInfo(tab_items, XM_ID, ID);
    }

    function initWindow_zqxxtb_contentForm(tab_items) {
        return Ext.create('Ext.form.Panel', {
            width: '90%',
            height: '100%',
            layout: 'anchor',
            border: false,
            defaults: {
                anchor: '100%',
                margin: '0 0 2 0'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'toolbar',
                    anchor: '100%',
                    width: '90%',
                    layout: 'hbox',
                    border: false,
                    items: [
                        {
                            xtype: 'displayfield',
                            name: 'xm_name',
                            labelWidth: 80,
                            fieldLabel: '<span class="displayfield">项目名称</span>',
                            value: '',
                            flex: .33

                        },
                        {
                            xtype: 'displayfield',
                            name: 'ag_name',
                            labelWidth: 80,
                            fieldLabel: '<span class="displayfield">单位名称</span>',
                            value: '',
                            flex: .33
                        },
                        {
                            xtype: 'displayfield',
                            name: 'jedw',
                            labelWidth: 40,
                            fieldLabel: '<span class="displayfield">单位</span>',
                            value: '<span class="displayfield">万元</span>',
                            flex: .2
                        },
                        {
                            xtype: 'button',
                            text: '<span class="displayfield">总览</span>',
                            name: 'log',
                            hidden: true,
                            fieldStyle: 'background:#000000',
                            icon: '/image/sysbutton/log.png',
                            flex: .06,
                            listeners: {
                                click: function () {
                                    getHxInfo()
                                }
                            }
                        }
                    ]
                },
                initWindow_zqxxtb_contentForm_tab(tab_items)
            ]
        });
    }

    function initWindow_zqxxtb_contentForm_tab(tab_items) {
        var items = getXmxxItems(tab_items, XM_ID);
        var zqxxtbTab = Ext.create('Ext.tab.Panel', {
            anchor: '100% -17',
            border: false,
            itemId: 'jsxmYhsTab',
            items: items
        });
        return zqxxtbTab;
    }

</script>
</body>
</html>