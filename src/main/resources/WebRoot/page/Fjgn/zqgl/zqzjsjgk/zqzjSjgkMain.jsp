<%--
  Created by IntelliJ IDEA.
  User: wang
  Date: 2019/12/12
  Time: 16:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>债券资金兑付申请</title>
    <!-- 重要：兼容浏览器IE8\9\11 -->
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    // 获取session 数据
    var userAdCode = '${sessionScope.ADCODE}'.replace(/00$/, "");//获取登录用户
    var defaultHidden = false;
    if (userAdCode.length == 6 || userAdCode.lastIndexOf("00") == 2) {
        defaultHidden = true;
    }

    // 自定义变量
    var button_name = '';// 当前操作按钮名称
    var button_text = '';// 当前操作按钮名称
    var HkId = '';
    var IS_VIEW = false;
    var IS_CONFIRMHK_BY_AUDIT = '0';  // 转贷还款 自动确认 开关
    var SYS_IS_QEHBFX = '';     // 系统参数是否支持全额承担本息
    var IS_CONFIRM_BYGK = '0'; // 是否需要国库进行复审核
    var DFF_CH_MODE = '';       // 系统参数是否交付兑付费
    var records_delete = [];    // 录入表格删除记录

    // 获取URL中变量
  /*  var wf_id = getQueryParam("wf_id");          // 当前流程id
    var node_code = getQueryParam("node_code"); // 当前节点id
    var df_plan_id = getQueryParam("df_plan_id");
    var WF_STATUS = getQueryParam("WF_STATUS"); // 当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var df_plan_id ="${fns:getParamValue('df_plan_id')}";
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }

    // 基础数据
    var store_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: " and (code in ('01','0101') or code like '0102%')"});

    // 设置状态栏store
    var statusStore = [
        {id: "001", code: "001", name: "未审核"},
        {id: "002", code: "002", name: "已审核"}
    ];

    // 设置状态栏store
    var hkTypeStore = [
        {id: "0", code: "0", name: "本金"},
        {id: "1", code: "1", name: "利息"},
        {id: "2", code: "2", name: "发行服务费"},
        {id: "3", code: "3", name: "托管服务费"},
        {id: "4", code: "4", name: "罚息"}
    ];

    //通用配置json
    var zqzjdf_json_common = {
        100114: { // 债券资金兑付管理
            1: { // 资金兑付录入
                items: {
                    '001': [//未送审
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '录入',
                            name: 'btn_insert',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                IS_VIEW = false;
                                button_name = btn.text;
                                initWindow_select().show();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                IS_VIEW = false;
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                    return;
                                }
                                //修改全局变量的值
                                button_name = btn.text;
                                //发送ajax请求，查询主表和明细表数据
                                $.post("/getDqYsjGkZqzjDtl_WS.action", {
                                    GKSJ_ID: records[0].get('GKSJ_ID')
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        return;
                                    }
                                    HkId = data.list.HK_ID;
                                    //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                    var window_input = initWin_input();
                                    window_input.show();
                                    window_input.down('form').getForm().setValues(data.list[0]);
                                    for (var i = 0; i < data.list.length; i++) {
                                        var obj = data.list[i];
                                        obj.FLAG_EDIT = 'UPDATE';
                                    }
                                    window_input.down('#win_input_tab_mxgrid').insertData(null, data.list);
                                }, "json");
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_delete',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length <= 0) {
                                    Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("GKSJ_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/delDqYsjGkZqzjInfo_WS.action", {
                                            ids: ids,
                                            wf_id: wf_id,
                                            node_code: node_code,
                                            button_name: button_name,
                                            wf_status: WF_STATUS
                                        }, function (data) {
                                            if (data.success) {
                                                Ext.toast({html: button_name + "成功！"});
                                            } else {
                                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                            }
                                            //刷新表格
                                            reloadGrid();
                                        }, "json");
                                    }
                                });
                            }
                        },
                        {
                            xtype: 'button',
                            text: '送审',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [//已送审
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销送审',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '004': [//被退回
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                IS_VIEW = false;
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                    return;
                                }
                                //修改全局变量的值
                                button_name = btn.text;
                                //发送ajax请求，查询主表和明细表数据
                                $.post("/getDqYsjGkZqzjDtl_WS.action", {
                                    GKSJ_ID: records[0].get('GKSJ_ID')
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        return;
                                    }
                                    HkId = data.list.GKSJDTL_ID;
                                    //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                    var window_input = initWin_input();
                                    window_input.show();
                                    window_input.down('form').getForm().setValues(data.list[0]);
                                    for (var i = 0; i < data.list.length; i++) {
                                        var obj = data.list[i];
                                        obj.FLAG_EDIT = 'UPDATE';
                                    }
                                    window_input.down('#win_input_tab_mxgrid').insertData(null, data.list);
                                }, "json");
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_delete',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length <= 0) {
                                    Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("GKSJ_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/delDqYsjGkZqzjInfo_WS.action", {
                                            ids: ids,
                                            wf_id: wf_id,
                                            node_code: node_code,
                                            button_name: button_name,
                                            wf_status: WF_STATUS
                                        }, function (data) {
                                            if (data.success) {
                                                Ext.toast({html: button_name + "成功！"});
                                            } else {
                                                Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                            }
                                            //刷新表格
                                            reloadGrid();
                                        }, "json");
                                    }
                                });
                            }
                        },
                        {
                            xtype: 'button',
                            text: '送审',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '008': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt0)
                }
            },
            2: { // 资金兑付审核
                items: {
                    '001': [//未审核
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '审核',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'up',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '002': [//已审核
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销审核',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                for (record_seq in records) {
                                    if (records[record_seq].get('IS_CONFIRM') == '1' && IS_CONFIRMHK_BY_AUDIT != '1') {//撤销审核时判断该主单对应明细是否被确认
                                        Ext.Msg.alert('提示', '选择撤销的转贷还款已被确认，无法撤销！');
                                        return false;
                                    }
                                }
                                doWorkFlow(btn);

                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '004': [//被退回
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '审核',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'up',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '008': [
                        {
                            xtype: 'button',
                            text: '查询',
                            name: 'btn_check',
                            icon: '/image/sysbutton/search.png',
                            handler: function (btn) {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '操作记录',
                            name: 'log',
                            icon: '/image/sysbutton/log.png',
                            handler: function () {
                                oprationRecord();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(statusStore)
                }
            }
        }
    };


</script>
<script type="text/javascript" src="zqzjSjgkMain.js"></script>
</body>
</html>

