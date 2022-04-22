<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>罚息录入审核</title>
</head>
<body>

</body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript" src="dwfxjnlr.js"></script>
<script type="text/javascript">
    var userCode = '${sessionScope.USERCODE}';
    var AD_CODE = '${sessionScope.ADCODE}';
 /*   var wf_id = getQueryParam("wf_id");//当前流程id
    var node_code = getQueryParam("node_code");//当前节点id*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var node_name = "";//当前节点名称
    var button_name = '';//当前操作按钮名称
  /*  var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    //var v_child = '1';
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var json_zt;//状态json
    if (node_code == '1') {
        node_name = 'lr'
        btn_title = '送审';
        json_zt = json_debt_zt0;
    } else if (node_code == '2') {
        node_name = 'sh'
        btn_title = '审核';
        json_zt = json_debt_zt2_2;
    }
    var records_delete = [];//记录明细删除行数据
    var IS_EDIT;//弹出编辑框是否可编辑

    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        // 检验是否选中数据
        // 获取选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        for (var i in records) {
            if (btn.text == '撤销审核' && records[i].get("IS_CONFIRM") == '1') {
                Ext.MessageBox.alert('提示', '已确认数据不能撤销审核！');
                return;
            }
            ids.push(records[i].get("FXJN_ID"));
        }
        button_name = btn.text;
        if (button_name == '审核' || button_name == '退回') {
            var op_value = '';
            if (button_name == "审核") {   //判断按钮名称 获取对应意见内容
                op_value = '同意';
            } else if (button_name == '退回') {
                op_value = '';
            }
            //弹出意见填写对话框
            initWindow_opinion({
                value: op_value,
                title: btn.text + "意见",
                animateTarget: btn,
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("/doWorkFlowDWFxjn.action", {
                            workflow_direction: btn.name,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            audit_info: text,
                            ids: ids
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_name + "成功！" + (data.message ? data.message : ''),
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            } else {
                                Ext.MessageBox.alert('提示', button_name + '失败！' + (data.message ? data.message : ''));
                            }
                            //刷新表格
                            reloadGrid();
                        }, "json");
                    }
                }
            });
        } else {
            Ext.Msg.confirm('提示', '请确认是否' + button_name + '?', function (btn_confirm) {
                if (btn_confirm == 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("/doWorkFlowDWFxjn.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: '',
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！" + (data.message ? data.message : ''),
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + (data.message ? data.message : ''));
                        }
                        //刷新表格
                        reloadGrid();
                    }, "json");
                }
            });
        }
    }

    /**
     * 操作记录
     */
    function operationRecord() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (!records || records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            fuc_getWorkFlowLog(records[0].get("FXJN_ID"));
        }
    }

    /**
     * 刷新页面
     */
    function reloadGrid() {
        var store = DSYGrid.getGrid("contentGrid").getStore();
        var dtlStore = DSYGrid.getGrid("contentDetailGrid").getStore();
        var attachStore = DSYGrid.getGrid("window_fxjn_attachment_grid_view").getStore();
        //初始化表格Store参数
        store.getProxy().extraParams = {
            wf_id: wf_id,
            node_code: node_code,
            userCode: userCode,
            WF_STATUS: WF_STATUS,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE
        };
        //刷新表格内容
        store.loadPage(1);
        dtlStore.removeAll();
        attachStore.removeAll();
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
</script>
</html>