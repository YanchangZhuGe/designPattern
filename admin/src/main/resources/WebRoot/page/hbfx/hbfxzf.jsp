<%--
存量债务政府债务还本付息重录主界面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>还本付息重录主界面</title>
    <meta http-equiv="x-ua-compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <!--重要，引入js-->
    <script type="text/javascript" src="/js/commonUtil.js"></script>
    <script type="text/javascript">
        //获取url中的工作流信息
   /*     var wf_id=getQueryParam('wf_id');//当前工作流id
        var node_type = getQueryParam("node_type");//当前节点名称
        var node_code = getQueryParam("node_code");//当前结点*/
        var wf_id="${fns:getParamValue('wf_id')}";//当前工作流id
        var node_type = "${fns:getParamValue('node_type')}";//当前节点名称
        var node_code = "${fns:getParamValue('node_code')}";//当前结点
        var json_zt='';//当前状态下拉框json数据
        //定义对象
        var hbfxzf_json_common={
            'hbfxzf':{
                jsFileUrl:'hbfxzf.js'
            },
            'hbfxzfsh':{
                jsFileUrl:'hbfxzfsh.js'
            }
        };
        /*工作流状态0*/
        var json_debt_zt0 = [
            {"id":"001","code":"001","name":"未送审"},
            {"id":"002","code":"002","name":"已送审"},
            {"id":"004","code":"004","name":"被退回"},
            {"id":"008","code":"008","name":"曾经办"}
        ];
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
        $(document).ready(function () {
            //显示提示，并form表单提示位置为表单项下方
            Ext.QuickTips.init();
            Ext.form.Field.prototype.msgTarget = 'side';
            //动态加载js
            $.ajaxSetup({
                cache: true
            });
            $.getScript(hbfxzf_json_common[node_type].jsFileUrl,function () {
                //根据节点名称初始化状态下拉框store
                if (node_type =='hbfxzf') {
                    json_zt =json_debt_zt0;
                }else if(node_type=='hbfxzfsh'){
                    json_zt = json_debt_zt2_4;

                }
                initContent();
                if (hbfxzf_json_common[node_type].callBack) {
                    hbfxzf_json_common[node_type].callBack();
                }
            })
        });

        //创建主界面
        function initContent() {
            Ext.create("Ext.panel.Panel",{
                layout:'border',
                defaults:{
                    split:true,//是否有分割线
                    collapsible:false//是否可以折叠
                },
                height:'100%',
                renderTo:Ext.getBody(),
                border:false,
                dockedItems:[
                    {
                        xtype:'toolbar',
                        dock:'top',
                        itemId:'contentPanel_toolbar',
                        items:hbfxzf_json_common[node_type].items[hbfxzf_json_common[node_type].defautItems]
                    }
                ],
                items:hbfxzf_json_common[node_type].items_content()
            });
        }

    </script>
</head>
<body>

</body>
</html>
