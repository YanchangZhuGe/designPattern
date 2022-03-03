<%--
  Created by IntelliJ IDEA.
  User: wang
  Date: 2019/12/20
  Time: 16:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>债券资金兑付异常</title>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
</head>
<body>

</body>
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="zqzjDfycSqMain.js"></script>
<script type="text/javascript">
    var userAdCode = '${sessionScope.ADCODE}'.replace(/00$/, "");//获取登录用户
    var defaultHidden = false;
    if (userAdCode.length == 6 || userAdCode.lastIndexOf("00") == 2) {
        defaultHidden = true;
    }
    var ad_code = '${sessionScope.ADCODE}';  // 获取地区名称
    if ('00' == ad_code.substring(ad_code.length - 2)) {
        ad_code = ad_code.substr(0, ad_code.length - 2);
    }
    // 获取系统参数
    var sh_hidden = ad_code == '${fns:getSysParam("ELE_AD_CODE")}' ? false : true;

    // 获取URL参数
    /*var wf_id = getQueryParam("wf_id"); // 当前工作流流程id
    var node_code = getQueryParam("node_code"); // 当前工作流节点id
    var node_type = getQueryParam("node_type"); // 当前节点名称
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var node_type ="${fns:getParamValue('node_type')}";
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    // 自定义参数
    var button_name = ''; // 当前操作按钮名称id
    var button_text = ''; // 当前操作按钮名称text
    var HK_YC_ID = '';  // 当前日期
    var HkId = '';
    var TOTAL_HK_AMT = '';
    var IS_VIEW = false;
    var IS_CONFIRMHK_BY_AUDIT = '0';  // 转贷还款 自动确认 开关
    var SYS_IS_QEHBFX = '';     // 系统参数是否支持全额承担本息
    var IS_CONFIRM_BYGK = '0'; // 是否需要国库进行复审核
    var DFF_CH_MODE = '';       // 系统参数是否交付兑付费
    var records_delete = [];    // 录入表格删除记录
    var zxkxmtz_toolbar_json = {
        lr: { //录入
            items: {
                '001': [
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
                        text: '异常还款',
                        name: 'INPUT_YCHK',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
	                         if (AD_CODE==null||AD_CODE.length==4) {
	                                    Ext.Msg.alert('提示', "请选择一个底级区划再进行操作！");
	                                    return;
                             }
                             $.post("/checkAdCode.action",{AD_CODE:AD_CODE},function(data){
								if(Ext.util.JSON.decode(data).success==false){
									Ext.Msg.alert('提示', "当前区划禁止录入!");
									return;
							}
                              button_name = btn.name;
                              window_ycsjzs(btn);
						}); 
                        }
                    },
                    {
                        xtype: 'button',
                        text: '还款超额',
                        name: 'INPUT_HKCE',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
	                         if (AD_CODE==null||AD_CODE.length==4) {
	                                    Ext.Msg.alert('提示', "请选择一个底级区划再进行操作！");
	                                    return;
                             }
                             $.post("/checkAdCode.action",{AD_CODE:AD_CODE},function(data){
								if(Ext.util.JSON.decode(data).success==false){
									Ext.Msg.alert('提示', "当前区划禁止录入!");
									return;
							}
                            button_name = btn.name;
                            button_text = btn.text;
                            window_ycsjzs(btn);
						}); 
                        
                        }
                    },
                    {
                        xtype: 'button',
                        text: '修改',
                        name: 'UPDATE',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else {
                                var record = records[0].getData();
                                HK_YC_ID = record.HK_YC_ID;
                                TOTAL_HK_AMT = record.HK_AMT;
                                if (record.REVISE_TYPE == '1') { // 异常还款
                                    button_name = 'INPUT_YCHK';
                                    button_text = btn.text;
                                    initWin_input_yc(btn).show();
                                } else {
                                    button_name = 'INPUT_HKCE';
                                    button_text = btn.text;
                                    $.post("/getYchkdInfo.action", {
                                        HK_YC_ID: record.HK_YC_ID
                                    }, function (data) {
                                        if (!data.success) {
                                            Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                                            return;
                                        }
                                        HkId = data.list.HK_ID;
                                        //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                        var window_input = initWin_input_yc();
                                        window_input.show();
                                        window_input.down('form').getForm().setValues(data.list[0]);
                                        for (var i = 0; i < data.list.length; i++) {
                                            var obj = data.list[i];
                                            obj.FLAG_EDIT = 'UPDATE';
                                        }
                                        window_input.down('#win_input_tab_mxgrid').insertData(null, data.list);
                                    }, "json");
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            delDfycXzMainGrid(btn);
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
                        handler: function (btn) {
                            dooperation();
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ],
                '002': [
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
                            dooperation();
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ],
                '004': [
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
                        name: 'UPDATE',
                        icon: '/image/sysbutton/edit.png',
                        handler: function (btn) {
                            // 检验是否选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else {
                                var record = records[0].getData();
                                HK_YC_ID = record.HK_YC_ID;
                                TOTAL_HK_AMT = record.HK_AMT;
                                if (record.REVISE_TYPE == '1') { // 异常还款
                                    button_name = 'INPUT_YCHK';
                                    button_text = btn.text;
                                    initWin_input_yc(btn).show();
                                } else {
                                    button_name = 'INPUT_HKCE';
                                    button_text = btn.text;
                                    $.post("/getYchkdInfo.action", {
                                        HK_YC_ID: record.HK_YC_ID
                                    }, function (data) {
                                        if (!data.success) {
                                            Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                                            return;
                                        }
                                        HkId = data.list.HK_ID;
                                        //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                        var window_input = initWin_input_yc();
                                        window_input.show();
                                        window_input.down('form').getForm().setValues(data.list[0]);
                                        for (var i = 0; i < data.list.length; i++) {
                                            var obj = data.list[i];
                                            obj.FLAG_EDIT = 'UPDATE';
                                        }
                                        window_input.down('#win_input_tab_mxgrid').insertData(null, data.list);
                                    }, "json");
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            delDfycXzMainGrid(btn);
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
                         handler: function (btn) {
                             dooperation();
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
                            dooperation();
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ]
            }
        },
        sh: {//审核
            items: {
                '001': [
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
                        handler: function (btn) {
                            dooperation();
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ],
                '002': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function () {
                            reloadGrid();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '撤销审核',
                        name: 'cancel',
                        hidden: true,
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
                            dooperation();
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ]
            }
        }
    };

    // 基础数据
    var store_ZJLY = DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: " and (code in ('01','0101') or code like '0102%')"});

    // 自定义store
    var json_debt_hkyc = [
        {"id":"001","code":"001","name":"未送审"},
        {"id":"002","code":"002","name":"已送审"},
        {"id":"004","code":"004","name":"被退回"},
        {"id":"008","code":"008","name":"曾经办"}
    ];

    var hkTypeStore = [
        {id: "0", code: "0", name: "本金"},
        {id: "1", code: "1", name: "利息"},
        {id: "2", code: "2", name: "发行服务费"},
        {id: "3", code: "3", name: "托管服务费"},
        {id: "4", code: "4", name: "罚息"}
    ];

    /**
     * 删除主表格信息
     */
    function delDfycXzMainGrid(btn) {
        // 检验是否选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
            return;
        }
        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                var ids = new Array();
                var btn_text = btn.text;
                for (var k = 0; k < records.length; k++) {
                    var hk_yc_id = records[k].get("HK_YC_ID");
                    ids.push(hk_yc_id);
                }

                $.post("delZqzjDfYcInfo_WS.action", {
                    ids: Ext.util.JSON.encode(ids)
                }, function (data_response) {
                    data_response = $.parseJSON(data_response);
                    if (data_response.success) {
                        Ext.toast({
                            html: btn_text + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        reloadGrid();
                    } else {
                        Ext.toast({
                            html: btn_text + "失败！" + data_response.message,
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        return false;
                    }
                });
            }
        });
    }
</script>
</html>
