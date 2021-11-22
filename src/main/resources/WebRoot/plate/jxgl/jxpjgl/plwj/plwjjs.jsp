<%--
  Created by IntelliJ IDEA.
  User: guodg
  Date: 2019/11/4
  Time: 10:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld"%>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>披露文件接收功能</title>
    <!-- 重要：引入统一extjs -->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript" src="/js/debt/ele_data.js"></script>
</head>
<body>
<script>
    var userCode = '${sessionScope.USERCODE}';//用户编码
    var userAdCode = '${sessionScope.ADCODE}';//登录用户所属区划
    //将省、市级区划转化为本级
    //userAdCode = (userAdCode.length==2||userAdCode.length==4)&&!userAdCode.endWith("00")?userAdCode.concat("00"):userAdCode;
    //获取工作流
    // var wf_id = getQueryParam('wf_id');
    // var node_code = getQueryParam('node_code');
    // var node_type = getQueryParam('node_type');
    // var WF_STATUS = getQueryParam('WF_STATUS');

    //20210429 fzd 安全性修改
    var wf_id =  "${fns:getParamValue('wf_id')}";
    var node_code =  "${fns:getParamValue('node_code')}";
    var node_type =  "${fns:getParamValue('node_type')}";
    var WF_STATUS =  "${fns:getParamValue('WF_STATUS')}";

    var userid = '${sessionScope.USERID}';

    if(WF_STATUS==null||WF_STATUS==''||typeof WF_STATUS == 'undefined'){
        WF_STATUS = '001';
    }
    var button_name;//操作按钮名称
    var button_status;
    var plwjjs_json_common = {
        plwjjs:'plwjjs.js',//披露文件接收
        plwjsh:'plwjsh.js'//披露文件审核
    };
    $(document).ready(function(){
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        //动态加载js
        $.ajaxSetup({
            cache: true
         });
        $.getScript(plwjjs_json_common[node_type], function () {
             initContentPanel();
        });
    });
    /**
     * 初始化页面主要内容区域
     */
    function initContentPanel(){
        Ext.create('Ext.panel.Panel',{
            layout:'fit',
            renderTo:Ext.getBody(),
            defaults:{
                split:true, //分割线
                collapsible:false //是否可折叠
            },
            height:'100%',
            tbar:{//菜单栏
                itemId:'contentPanel_toolbar',
                items:plwjjs_json_common.items[plwjjs_json_common.defaultItems]
            },
            items:plwjjs_json_common.items_content()
        });
    }

    function insert_sy_xzzq() {
        var headerjson2 = [
            {
                dataIndex: "YDJH_HZ_ID",
                type: "string",
                text: "明细单ID",
                class: "ty",
                width: 150,
                fontSize: "15px",
                hidden: true
            },
            {dataIndex: "AD_NAME", type: "string", text: "地区", class: "ty", width: 150, fontSize: "15px", hidden: false},
            {
                dataIndex: "PLAN_XZ_AMT", type: "float", text: "申请金额（万元）", class: "xmxz", width: 200, fontSize: "15px",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "REMARK", width: 300, type: "string", text: "备注"}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'itemId_sy_zqhz',
            flex: 1,
            headerConfig: {
                headerJson: headerjson2,
                columnAutoWidth: false
            },
            autoLoad: true,
            checkBox: true,
            border: false,
            scrollable: true,
            height: '100%',
            pageConfig: {
                enablePage: false,
                pageNum: false
            },
            params: {},
            features: [{
                ftype: 'summary'
            }],
            dataUrl: 'getZqhzDtlInfo.action',
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'zqhz_grid_plugin_cell',
                    clicksToMoveEditor: 1
                }
            ],
            listeners: {
                'edit': function (editor, context) {

                }
            }
        });
        return grid;

    }
</script>

</body>
</html>
