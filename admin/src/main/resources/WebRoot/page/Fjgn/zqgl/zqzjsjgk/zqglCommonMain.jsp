<%--
  Created by IntelliJ IDEA.
  User: wang
  Date: 2019/12/25
  Time: 17:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>地方实施工具</title>
    <!-- 重要：兼容浏览器IE8\9\11 -->
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
</head>
<body>

</body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var AD_NAME= '${sessionScope.ADNAME}';  // 获取地区名称
    var userName = '${sessionScope.USERNAME}';
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        initContent();
    });

    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            items: [
                initContentGrid()
            ]
        });
    }

    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerjson_hkd = [
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {text: "当前用户", dataIndex: "USER_CODE", width: 150, type: "string"},
            {text: "当前地区", dataIndex: "ADNAME", width: 100, type: "string"},
            {text: "备注", dataIndex: "REMARK", width: 300, type: "string"}
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerjson_hkd,
                columnAutoWidth: false
            },
            flex: 1,
            features: [{
                ftype: 'summary'
            }],
            data:[{USER_CODE:userName,ADNAME:AD_NAME,REMARK:'湖北实施辅助工具:初始化还款计划'},{USER_CODE:userName,ADNAME:AD_NAME,REMARK:'湖北实施辅助工具：初始化债券基本信息'}],
            checkBox: true,
            border: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'button',
                    text: '债券信息',
                    name: 'btn_init_zqxx',
                    itemId: 'btn_init_zqxx',
                    width: 80,
                    margin: '0 20 0 0',
                    handler: function (btn) {
                        Ext.Msg.confirm('提示', '请确认是否初始化债券信息，并推送至交行！', function (btn_confirm) {
                            if (btn_confirm === 'yes') {
                                button_name = btn.text;

                                //发送ajax请求，删除数据
                                $.post("/initZqglZqxx_WS.action", {

                                }, function (data) {
                                    if (data.success) {
                                        Ext.toast({html: button_name + "成功！"});
                                    } else {
                                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                    }
                                }, "json");
                            }
                        });
                    }
                },
                {
                    xtype: 'button',
                    text: '还款计划',
                    name: 'btn_init_hkjh',
                    itemId: 'btn_init_hkjh',
                    width: 80,
                    margin: '0 20 0 0',
                    handler: function (btn) {
                        Ext.Msg.confirm('提示', '请确认是否初始化债券信息，并推送至交行！', function (btn_confirm) {
                            if (btn_confirm === 'yes') {
                                button_name = btn.text;

                                //发送ajax请求，删除数据
                                $.post("/initZqglHkjh_WS.action",
                                    function (data) {
                                    if (data.success) {
                                        Ext.toast({html: button_name + "成功！"});
                                    } else {
                                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                    }
                                }, "json");
                            }
                        });
                    }
                }
            ]
        });
    }


</script>
</html>
