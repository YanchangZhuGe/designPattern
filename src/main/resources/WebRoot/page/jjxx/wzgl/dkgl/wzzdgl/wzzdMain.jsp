<%--
  Created by IntelliJ IDEA.
  User: zhangsa
  Date: 2018/6/28
  Time: 13:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>外债转贷主界面</title>
    <style type="text/css">
        .x-grid-back-green {
            background: #00ff00;
        }
    </style>
</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    <%  /*获取登录用户*/
        String userCode = (String) request.getSession().getAttribute("USERCODE");
        String adCode = (String) request.getSession().getAttribute("ADCODE");
        String agCode = (String) request.getSession().getAttribute("AGCODE");
    %>
    var zd_type= "${fns:getParamValue('zd_type')}"; //当前转贷类型
    if(zd_type==null||zd_type==undefined||zd_type==""){
        zd_type="zf";
    }
    var wf_id = "${fns:getParamValue('wf_id')}";//当前工作流id
    var node_code = "${fns:getParamValue('node_code')}";//当前节点id，1：录入岗；2：审核岗
    var button_name = '';//当前操作按钮名称
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态，指未送审...
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var userCode='${sessionScope.USERCODE}';
    Ext.define('treeModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'text'},
            {name: 'code'},
            {name: 'id'},
            {name: 'leaf'}
        ]
    });


    var SJXM_ID="";
    var ZDXX_ID="";
    var ZDMX_ID="";
    Ext.define('sjxmModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'id',mapping:'DXM_ID'},
            {name: 'name',mapping:'DXM_NAME'}
        ]
    });
    var store_zddw = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: '/wzgl_reflct.action?method=getZddwTreeStore',
            extraParams: {
                AD_CODE:AD_CODE
            },
            reader: {
                type: 'json'
            }
        },
        root:'nodelist' ,
        model: 'treeModel',
        autoLoad: true
    });
    function getSjxmStore(filterParam){
        var sjxmDataStore = Ext.create('Ext.data.Store', {
            model: 'sjxmModel',
            proxy: {
                type: 'ajax',
                method: 'POST',
                url: "/getSjxmData.action",
                reader: {
                    type: 'json'
                },
                extraParams:filterParam
            },
            autoLoad: true
        });
        return sjxmDataStore;
    }


        /**
     * 通用函数：获取url中的参数
     */
/*     function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    } */

    var wzzd_json_common = {
        100402:{
            1: {//转贷录入岗
                items: {
                    '001': [
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
                            text: '录入',
                            name: 'input',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                button_name = btn.text;
                                $.post("/getId.action", function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }
                                    //弹出弹出框，设置ID
                                    ZDXX_ID = data.data[0];
                                    window_select.show();
                                }, "json");
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                modify(records,btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("ZDXX_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/wzgl_reflct.action?method=delZdInfo", {
                                            ids: Ext.util.JSON.encode(ids),
                                            userCode: userCode
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
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                doworkupdate(records,btn);
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
                            text: '撤销送审',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                doworkupdate(records,btn);
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
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                modify(records,btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_delete',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("ZDXX_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/wzgl_reflct.action?method=delZdInfo", {
                                            ids: Ext.util.JSON.encode(ids),
                                            userCode: userCode
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
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                doworkupdate(records,btn);

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
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '000': [
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
                                dooperation();
                            }
                        }
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt1_1)
                }
            },
            2: {
                items: {
                    '001': [
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
                            text: '审核',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                doworkupdate(records,btn);

                            }
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'up',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                doworkupdate(records,btn);
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
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }else{
                                    doworkupdate(records,btn);
                                }
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
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_sh)
                }
            }
        },
        100403:{
            1: {//转贷录入岗
                items: {
                    '001': [
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
                            text: '录入',
                            name: 'input',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                button_name = btn.text;
                                $.post("/getId.action", function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }
                                    //弹出弹出框，设置ID
                                    ZDXX_ID = data.data[0];
                                    window_select.show();
                                }, "json");
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                modify(records,btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("ZDXX_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/wzgl_reflct.action?method=delZdInfo", {
                                            ids: Ext.util.JSON.encode(ids),
                                            userCode: userCode
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
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                doworkupdate(records,btn);
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
                            text: '撤销送审',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                doworkupdate(records,btn);
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
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                modify(records,btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_delete',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm === 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("ZDXX_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/wzgl_reflct.action?method=delZdInfo", {
                                            ids: Ext.util.JSON.encode(ids),
                                            userCode: userCode
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
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                doworkupdate(records,btn);

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
                                dooperation();
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ],
                    '000': [
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
                                dooperation();
                            }
                        }
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt1_1)
                }
            },
            2: {
                items: {
                    '001': [
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
                            text: '审核',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                doworkupdate(records,btn);

                            }
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'up',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }
                                doworkupdate(records,btn);
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
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }else{
                                    doworkupdate(records,btn);
                                }
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
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_sh)
                }
            }
        }
    };

    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
        if (wzzd_json_common[wf_id][node_code].callBack) {
            wzzd_json_common[wf_id][node_code].callBack();
        }
    });

    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        var config = {
            editable: false,
            busiId: ''
        };
        Ext.create('Ext.form.Panel', {
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            height: '100%',
            renderTo: 'contentPanel',
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: wzzd_json_common[wf_id][node_code].items[WF_STATUS],
                }
            ],
            items: [
                initContentGrid(),
                //initContentDetilGrid()
                {
                    xtype: 'tabpanel',
                    border: false,
                    flex: 1,
                    itemId: 'winPanel_tabPanel',
                    items: [
                        {
                            title: '明细信息',
                            layout: 'fit',
                            scrollable: true,
                            name: 'detail',
                            items: initContentDetilGrid()
                        },
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            scrollable: true,
                            name: 'attachment',
                            items: [
                                {
                                    xtype: 'panel',
                                    layout: 'fit',
                                    //height: document.body.clientHeight * 0.45,
                                    border:false,
                                    items: initWindow_wzzdlr_contentForm_tab_upload(config)
                                }
                            ],
                            listeners: {
                                beforeactivate: function (self) {
                                    // 检验明细是否有数据
                                    var grid = self.up('tabpanel').down('grid#contentGrid_detail');
                                    if (grid.getStore().getCount() <= 0) {
                                        Ext.MessageBox.alert('提示', '单据明细表格无数据！');
                                        return false;
                                    }
                                    // 获取选中数据
                                    var record = grid.getCurrentRecord();
                                    //如果当前无选中行，默认选中第一条数据
                                    if (!record) {
                                        $(grid.getView().getRow(0)).parents('table[data-recordindex=0]').addClass('x-grid-item-click');
                                        record = grid.getStore().getAt(0);
                                        Ext.toast({
                                            html: "单据明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                    }
                                    var panel = self.down('panel');
                                    panel.removeAll(true);
                                    panel.add(initWindow_wzzdlr_contentForm_tab_upload({
                                        editable: false,
                                        busiId: record.get('ZDMX_ID')
                                    }));
                                }
                            }
                        }
                    ]
                }
            ]
        });
        reloadGrid();
    }

    /**
     * 初始化主界面主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                dataIndex:"ZDXX_ID",
                type:"string",
                width:130,
                text:"主单id",
                hidden:true
            },
            {
                dataIndex: "WZXY_CODE",
                type: "string",
                width: 130,
                text: "外债编码",
            },
            {
                dataIndex: "WZXY_NAME",
                type: "string",
                width: 240,
                text: "外债名称"
                /*renderer: function (data, cell, record) {
                    var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';
                }*/
            },
            {
                dataIndex: "WZXY_AMT",
                width: 150,
                type: "float",
                text: "协议金额（原币）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZD_AMT",
                width: 150,
                type: "float",
                text: "转贷金额(原币)",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZD_AMT_RMB",
                width: 150,
                type: "float",
                text: "转贷金额(人民币)",
                hidden:true,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "XM_NAME",
                width: 240,
                type: "string",
                text: "项目名称"
            },
            {
                dataIndex: "SIGN_DATE",
                width: 130,
                type: "string",
                text: "签订日期"
            },
            {
                text: '债务类型',
                dataIndex: 'XMFL',
                type: "string",
                renderer: function (value) {
                    var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
                    return result != null ? result.get('name') : value;
                }
            },
            {
                dataIndex: "ZWLX_NAME",
                type: "string",
                text: "债务类别",
                width: 130
            },

            {
                dataIndex: "ZQLX_NAME",
                width: 130,
                type: "string",
                text: "债权类型"
            },

        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                WF_STATUS: WF_STATUS,
                wf_id: wf_id,
                node_code: node_code,
                ad_code:AD_CODE,
                zd_type:zd_type,
                userCode:userCode
            },
            dataUrl: '/wzgl_reflct.action?method=getAllWzInfo',
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: wzzd_json_common[wf_id][node_code].store['WF_STATUS'],
                    width: 110,
                    labelWidth: 30,
                    labelAlign: 'right',
                    editable: false, //禁用编辑
                    displayField: "name",
                    valueField: "id",
                    value: WF_STATUS,
                    allowBlank: false,
                    listeners: {
                        change: function (self, newValue) {
                            WF_STATUS = newValue;
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                            toolbar.removeAll();
                            toolbar.add(wzzd_json_common[wf_id][node_code].items[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams['WF_STATUS'] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                }
            ],
            tbarHeight: 50,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            /*features: [{
                ftype: 'summary'
            }],*/
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['ZDXX_ID'] = record.get('ZDXX_ID');
                    DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                }
            }
        });
    }
    /**
     * 初始化主界面明细表格
     */
    function initContentDetilGrid(callback) {
        var headerJson = [
            {xtype: 'rownumberer', width: 60,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                dataIndex:"ZDXX_ID",
                type:"string",
                width:200,
                hidden:true
            },
            {
                dataIndex: "ZD_AD_NAME",
                type: "string",
                width: 200,
                text: "转贷地区",
                hidden:zd_type=='zf'?false:true
            },
            {
                dataIndex: "ZD_AD_NAME",
                type: "string",
                width: 200,
                text: "转贷单位",
                hidden:zd_type=='zf'?true:false
            },
            {
                dataIndex: "SJXM_ID_NAME",
                type: "string",
                text: "转贷项目",
                width: 250,
                hidden:zd_type=='zf'?false:true
            },
            {
                dataIndex: "SJXM_ID_NAME",
                type: "string",
                text: "转贷项目",
                width: 250,
                hidden:zd_type=='zf'?true:false,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/common/xmyhs.jsp?XM_ID=' + record.get('XM_ID') + '&IS_RZXM=' + record.get("IS_RZXM");
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/common/xmyhs.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    paramNames[1]="IS_RZXM";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));

                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;

                }
            },{
                text: '债务类型',
                dataIndex: 'XMFL',
                type: "string",
                hidden:zd_type=='zf'?false:true,
                renderer: function (value) {
                    var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
                    return result != null ? result.get('name') : value;
                }
            },
            {
                dataIndex: "ZD_AMT",
                type: "float",
                text: "转贷协议金额（原币）",
                width: 180,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZDHL",
                width: 150,
                type: "float",
                text: "转贷汇率",
                format: '0.000000',
                hidden:true
            },
            {
                dataIndex: "ZD_AMT_RMB",
                type: "float",
                text: "转贷协议金额（人民币）",
                width: 180,
                hidden:true,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZDXY_NO",
                width: 150,
                type: "string",
                text: "转贷协议号"
            },
            {
                dataIndex: "REMARK",
                width: 150,
                type: "string",
                text: "备注"
            }
        ];
        var simplyGrid = new DSYGridV2();
        var config = {
            itemId: 'contentGrid_detail',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            autoLoad: false,
            border: false,
            height: '50%',
            pageConfig: {
                enablePage: false
            },
            features: [{
                ftype: 'summary'
            }],
            dataUrl: '/wzgl_reflct.action?method=getMxForZd'
        };
        var grid = simplyGrid.create(config);
        if (callback) {
            callback(grid);
        }
        return grid;
    }

    /**
     * 创建外债转贷信息选择弹出窗口
     */
    var window_select = {
        window: null,
        show: function (params) {
            this.window = initWindow_select(params);
            this.window.show();
        }
    };

    /**
     * 初始化外债选择弹出窗口
     */
    function initWindow_select(params) {
        return Ext.create('Ext.window.Window', {
            title: '外债选择', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'vbox',
            maximizable: true,
            itemId: 'window_select', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWindow_select_grid(params)],
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        btn.setDisabled(true);
                        //获取表格选中数据
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length != 1) {
                            btn.setDisabled(false);
                            Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                            return;
                        }

                        var record = records[0].getData();
                        record.ZDXX_ID=ZDXX_ID;
                        window_input.show();
                        window_input.window.down('form').getForm().setValues(record);
                        SJXM_ID=record.SJXM_ID;
                        sjxm_tree_store.getProxy().extraParams['SJXM_ID']=SJXM_ID;

                        STORE_TREE_ZDXM.proxy.extraParams['U_DXM_ID'] = SJXM_ID;
                        //var store = window_input.window.down('form').down('grid#wzzd_grid2').getStore();
                        btn.up('window').close();
                    }
                },
                {
                    text: '关闭',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
    }

    /**
     * 初始化外债选择弹出框表格
     */
    function initWindow_select_grid(params) {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                "dataIndex": "WZXY_NO",
                "type": "string",
                "text": "外债协议号",
                "fontSize": "15px",
                "width": 150,
            },
            {
                "dataIndex": "WZXY_ID",
                "type": "string",
                "text": "外债协议id",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "AD_CODE",
                "type": "string",
                "text": "地区",
                "fontSize": "15px",
                "width": 120,
                hidden:true
            },
            {
                "dataIndex": "AD_NAME",
                "type": "string",
                "text": "地区名称",
                "fontSize": "15px",
                "width": 120,
            },
            {
                "dataIndex": "WZXY_CODE",
                "type": "string",
                "text": "外债协议编码",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "WZXY_NAME",
                "type": "string",
                "text": "外债名称",
                "fontSize": "15px",
                "width": 150,
            },

            {
                "dataIndex": "DXM_NAME",
                "type": "string",
                "text": "项目名称",
                "fontSize": "15px",
                "width": 120
            },{
                text: '债务类型',
                dataIndex: 'XMFL',
                type: "string",
                renderer: function (value) {
                    var result = DebtEleStore(json_debt_xmfl).findRecord('id', value, 0, false, true, true);
                    return result != null ? result.get('name') : value;
                }
            },
            {
                "dataIndex": "SJXM_ID",
                "type": "string",
                "text": "上级项目id",
                "fontSize": "15px",
                "width": 120,
                hidden: true
            },
            {
                "dataIndex": "WZXY_AMT",
                "type": "float",
                "text": "协议金额（原币）",
                "fontSize": "15px",
                "width": 150,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "WZXY_AMT_RMB",
                "type": "float",
                "text": "协议金额（人民币）",
                "fontSize": "15px",
                "width": 180,
                hidden:true,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "SY_WZXY_AMT",
                "type": "float",
                "text": "未转贷金额（原币）",
                "fontSize": "15px",
                "width": 180,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "SY_WZXY_AMT_RMB",
                "type": "float",
                "text": "未转贷金额（人民币）",
                "fontSize": "15px",
                "width": 200,
                hidden:true,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "ZD_AMT",
                "type": "float",
                "text": "已转贷金额（原币）",
                "fontSize": "15px",
                "width": 180,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "ZD_AMT_RMB",
                "type": "float",
                "text": "已转贷金额（人民币）",
                "fontSize": "15px",
                "width": 180,
                hidden:true,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "FM_ID",
                "type": "string",
                "text": "币种",
                "fontSize": "15px",
                "width": 130,
                "hidden":true
            },
            {
                "dataIndex":"WB_NAME",
                "type":"string",
                "text":"币种",
                "fontSize": "15px",
                "width": 130
            },
            {
                "dataIndex": "ZJYT_ID",
                "type": "string",
                "width": 150,
                "text": "资金用途",
                "hidden":true

            },
            {
                "dataIndex":"ZJYT_NAME",
                "type":"string",
                "width":150,
                "text":"资金用途"
            },
            {
                "dataIndex": "WZQX_ID",
                "width": 130,
                "type": "string",
                "text": "期限（月）"
            },
            {
                "dataIndex": "HL_RATE",
                "width": 130,
                "type": "string",
                "text": "汇率",
                hidden:true,
            },
            {
                "dataIndex": "ZQFL_ID",
                "width": 130,
                "type": "string",
                "text": "债权分类",
                "hidden":true
            },
            {
                "dataIndex":"ZQFL_NAME",
                "width":130,
                "type":"string",
                "text":"债权类型"
            },
            {
                "dataIndex": "ZWLX_NAME",
                "width": 130,
                "type": "string",
                "text": "债务类别"
            },
            {
                "dataIndex": "ZQR_ID",
                "width": 130,
                "type": "string",
                "text": "债权人",
                "hidden":true
            },
            {
                "dataIndex": "ZQR_NAME",
                "width": 130,
                "type": "string",
                "text": "债权人"
            },
            {
                "dataIndex": "ZQR_FULLNAME",
                "width": 130,
                "type": "string",
                "text": "债权人全称"
            }
        ];
        var simplyGrid = new DSYGridV2();
        return simplyGrid.create({
            itemId: 'grid_select2',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            selModel: {
                mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            checkBox: true,
            border: false,
            width: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            params:{
                AD_CODE:AD_CODE,
                zd_type:zd_type,
                mhcx:null
            },
            tbar: [
                {
                    xtype: "textfield",
                    name: "mhcx",
                    id: "mhcx",
                    fieldLabel: '模糊查询',
                    allowBlank: true,  // requires a non-empty value
                    labelWidth: 70,
                    width: 260,
                    labelAlign: 'right',
                    emptyText: '请输入外债名称...',
                    enableKeyEvents: true,
                    listeners: {
                        keypress: function (self, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                var store = self.up('grid').getStore();
                                store.getProxy().extraParams['mhcx'] = self.getValue();
                                // 刷新表格
                                self.up('grid').getStore().loadPage(1);
                            }
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'btn_check',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        var keyValue = Ext.ComponentQuery.query('textfield[name="mhcx"]')[0].value;
                        btn.up('grid').getStore().getProxy().extraParams["mhcx"] = keyValue;
                        btn.up('grid').getStore().loadPage(1);
                    }
                }
            ],
            tbarHeight: 50,
            dataUrl: '/wzgl_reflct.action?method=getWzInfo'
        });
    }


    //创建转贷信息填报弹出窗口
    var window_input = {
        window: null,
        show: function () {
            this.window = initWindow_input();
            this.window.show();
        }
        /*show: function () {
            if (!this.window) {
                this.window = initWindow_input();
            }
            this.window.show();
        }*/
    };
    /**
     * 初始化外债转贷弹出窗口
     */
    function initWindow_input() {
        var config = {
            editable: true,
            busiId: ''
        };
        return Ext.create('Ext.window.Window', {
            title: '外债转贷', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            maximizable: true,
            itemId: 'window_input2', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [
                initWindow_input_contentForm(),
                {
                    xtype: 'tabpanel',
                    border: false,
                    flex: 1,
                    itemId: 'winPanel_tabPanel',
                    items: [
                        {
                            title: '明细信息',
                            layout: 'fit',
                            scrollable: true,
                            name: 'detail',
                            items: initWindow_input_contentForm_grid()
                        },
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            scrollable: true,
                            name: 'attachment',
                            items: [
                                {
                                    xtype: 'panel',
                                    layout: 'fit',
                                    border:false,
                                    items: initWindow_wzzdlr_contentForm_tab_upload(config)
                                }
                            ],
                            listeners: {
                                beforeactivate: function (self) {
                                    // 检验明细是否有数据
                                    var grid = self.up('tabpanel').down('grid#wzzd_grid2');
                                    if (grid.getStore().getCount() <= 0) {
                                        Ext.MessageBox.alert('提示', '单据明细表格无数据！');
                                        return false;
                                    }
                                    // 获取选中数据
                                    var record = grid.getCurrentRecord();
                                    //如果当前无选中行，默认选中第一条数据
                                    if (!record) {
                                        $(grid.getView().getRow(0)).parents('table[data-recordindex=0]').addClass('x-grid-item-click');
                                        record = grid.getStore().getAt(0);
                                        Ext.toast({
                                            html: "单据明细表格无当前选中行，默认选中第一条，展示第一条的附件！",
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                    }
                                    var panel = self.down('panel');
                                    panel.removeAll(true);
                                    panel.add(initWindow_wzzdlr_contentForm_tab_upload({
                                        editable: true,
                                        busiId: record.get('ZDMX_ID')
                                    }));
                                }
                            }
                        }
                    ]
                }

            ],
            buttons: [
                {
                    xtype: 'button',
                    text: '添加',
                    itemId: 'zdmxAddBtn',
                    width: 60,
                    handler: function (btn) {
                        var HL_RATE=Ext.ComponentQuery.query('numberFieldFormat[name="HL_RATE"]')[0].getValue();
                        $.post("/getId.action", function (data) {
                            if (!data.success) {
                                Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                return;
                            }
                            //弹出弹出框，设置ID
                            ZDMX_ID = data.data[0];
                            btn.up('window').down('grid').insertData(null,{
                                ZDMX_ID:ZDMX_ID,
                                ZDLX_RATE:HL_RATE
                            });
                        }, "json");
                    }
                },
                {
                    xtype: 'button',
                    itemId: 'zdmxDelBtn',
                    text: '删除',
                    disabled: true,
                    width: 60,
                    handler: function (btn) {
                        var grid = btn.up('window').down('grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        store.remove(sm.getSelection());
                        if (store.getCount() > 0) {
                            sm.select(0);
                        }

                    }
                },
                {
                    text: '保存',
                    handler: function (btn){
                        var grid = btn.up('window').down('#wzzd_grid2');
                        var celledit = grid.getPlugin('wzzd_grid_plugin_cell2');
                        //完成编辑
                        celledit.completeEdit();
                        //先校验后保存
                        var form = btn.up('window').down('form');
                        var SY_WZXY_AMT=form.getForm().findField("SY_WZXY_AMT").getValue();
                        var SY_WZXY_AMT_RMB=form.getForm().findField("SY_WZXY_AMT_RMB").getValue();

                        var INPUT_ZD_AMT=form.getForm().findField("INPUT_ZD_AMT");
                        if(SY_WZXY_AMT<0){
                            Ext.toast({
                                html:  "协议转贷原币金额超额！" ,
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return false;
                        }

                        var formvalues=form.getValues();//主表数据
                        var gridvalues=new Array();//明细数据
                        var grid_store=grid.getStore();

                        for(var j=0;j<grid_store.getCount();j++){
                            var record=grid_store.getAt(j);
                            var var$ad_code=record.get("AD_CODE");
                            var var$sjxm_id=record.get("ZDXM_NAME");
                            var var$zdxy_no=record.get("ZDXY_NO");
                            var var$zdxy_amt=record.get("ZDXY_AMT");
                            var var$zdlx_rate=record.get("ZDLX_RATE");
                            if(!(var$ad_code!=null&&var$ad_code!=undefined&&var$ad_code!="")){
                                Ext.Msg.alert('提示', "明细中转贷地区不能为空！");
                                return false;
                            }

                            if(!(var$sjxm_id!=null&&var$sjxm_id!=undefined&&var$sjxm_id!="")){
                                Ext.Msg.alert('提示', "明细中转贷项目不能为空！");
                                return false;
                            }

                            if(!(var$zdxy_no!=null&&var$zdxy_no!=undefined&&var$zdxy_no!="")){
                                Ext.Msg.alert('提示', "明细中转贷协议号不能为空！");
                                return false;
                            }

                            if(!(var$zdxy_amt!=null&&var$zdxy_amt!=undefined&&var$zdxy_amt!=""&&var$zdxy_amt!=0)){
                                Ext.Msg.alert('提示', "明细中转贷协议金额（原币）不能为0！");
                                return false;
                            }

                            if(!(var$zdlx_rate!=null&&var$zdlx_rate!=undefined&&var$zdlx_rate!=""&&var$zdlx_rate!=0)){
                                Ext.Msg.alert('提示', "明细中转贷汇率不能为0！");
                                return false;
                            }
                            gridvalues.push(record.data);
                        }

                        var parameters = {
                            ad_code:AD_CODE,
                            wf_id: wf_id,
                            zd_type:zd_type,
                            //zq_code: window_input.zq_code,
                            node_code: node_code,
                            button_name: button_name,
                            usercode:userCode,
                            formList:Ext.util.JSON.encode(formvalues),
                            detailList: Ext.util.JSON.encode(gridvalues),
                        };

                        if (form.isValid()) {
                            if(record !=null && record!= undefined && record != ""  ){
                                btn.setDisabled(true);
                                //保存表单数据及明细数据
                                form.submit({
                                    //设置表单提交的url
                                    url: '/wzgl_reflct.action?method=saveZDXY',
                                    params: parameters,
                                    success: function (form, action) {
                                        btn.setDisabled(false);
                                        //关闭弹出框
                                        btn.up("window").close();
                                        //提示保存成功
                                        Ext.toast({
                                            html: '<div style="text-align: center;">保存成功!</div>',
                                            closable: false,
                                            align: 't',
                                            slideInDuration: 400,
                                            minWidth: 400
                                        });
                                        reloadGrid();
                                    },
                                    failure: function (form, action) {
                                        btn.setDisabled(false);
                                        var result = Ext.util.JSON.decode(action.response.responseText);
                                        Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                                    }
                                });
                            }else {
                                Ext.Msg.alert('提示', '请填写明细信息！');
                            }
                        } else {
                            Ext.Msg.alert('提示', '请检查必填项！');
                        }

                    }
                },
                {
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').destroy();
                    }
                }
            ]
        });
    }



    /**
     * 初始化债券转贷主表单
     */
    function initWindow_input_contentForm() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            itemId:'wzzd_form',
            layout: 'column',
            border: false,
            defaults: {
                columnWidth: .33,
                margin: '2 5 2 5',
                labelWidth: 150
            },
            margin: '0 0 5 0',
            defaultType: 'textfield',
            items: [
                {

                    xtype: "textfield",
                    fieldLabel: '主单ID',
                    disabled: false,
                    name: "ZDXX_ID",
                    hidden: true,
                    editable: false//禁用编辑
                },
                {
                    xtype: "textfield",
                    fieldLabel: '外债协议ID',
                    disabled: false,
                    name: "WZXY_ID",
                    hidden: true,
                    editable: false//禁用编辑
                },
                {
                    xtype: "textfield",
                    fieldLabel: '地区CODE',
                    name: "AD_CODE",
                    editable: false,//禁用编辑
                    readOnly: true,
                    hidden:true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    fieldLabel: '地区',
                    name: "AD_NAME",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype:"textfield",
                    fieldLabel:"项目名称ID",
                    name:"SJXM_ID",
                    editable:false,
                    readOnly:true,
                    fieldStyle: 'background:#E6E6E6',
                    hidden: true
                },
                {
                    name: "DXM_NAME",
                    fieldLabel: '项目名称',
                    xtype: "textfield",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "displayfield",
                    fieldLabel: '外债名称',
                    name: "WZXY_NAME",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    fieldLabel: '协议号',
                    name: "WZXY_NO",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    fieldLabel: '签订日期',
                    name: "SIGN_DATE",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },

                {
                    xtype: "textfield",
                    fieldLabel: '债权类型',
                    name: "ZQFL_ID",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6',
                    hidden:true
                },
                {
                    xtype: "textfield",
                    fieldLabel: '债权类型',
                    name: "ZQFL_NAME",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    fieldLabel: '债务类别',
                    name: "ZWLB_ID",
                    editable: false,//禁用编辑
                    readOnly: true,
                    hidden:true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    fieldLabel: '债务类别',
                    name: "ZWLX_NAME",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    fieldLabel: '期限（月）',
                    name: "WZQX_ID",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },

                {
                    xtype: "textfield",
                    fieldLabel: '债权人',
                    name: "ZQR_ID",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6',
                    hidden:true
                },
                {
                    xtype: "textfield",
                    fieldLabel: '债权人',
                    name: "ZQR_NAME",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    fieldLabel: '债权人全称',
                    name: "ZQR_FULLNAME",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    fieldLabel: '币种',
                    name: "FM_ID",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6',
                    hidden:true
                },
                {
                    xtype: "textfield",
                    fieldLabel: '币种',
                    name: "WB_NAME",
                    editable: false,//禁用编辑
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: 'numberFieldFormat',
                    allowDecimals: true,
                    decimalPrecision: 2,
                    hideTrigger: true,
                    fieldLabel: '协议金额(原币)',
                    name: "WZXY_AMT",
                    editable: false,//禁用编辑
                    readOnly: true,
                    value:0,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: 'numberFieldFormat',
                    allowDecimals: true,
                    decimalPrecision: 6,
                    hideTrigger: true,
                    fieldLabel: '汇率',
                    name: "HL_RATE",
                    editable: false,//禁用编辑
                    readOnly: true,
                    value:0,
                    fieldStyle: 'background:#E6E6E6',
                    hidden:true
                },
                {
                    xtype: 'numberFieldFormat',
                    allowDecimals: true,
                    decimalPrecision: 2,
                    hideTrigger: true,
                    fieldLabel: '协议金额(人民币 )',
                    name: "WZXY_AMT_RMB",
                    editable: false,//禁用编辑
                    readOnly: true,
                    value:0,
                    fieldStyle: 'background:#E6E6E6',
                    hidden:true
                },
                {
                    xtype: 'numberFieldFormat',
                    allowDecimals: true,
                    decimalPrecision: 2,
                    hideTrigger: true,
                    fieldLabel: '剩余可转贷(原币)',
                    name: "SY_WZXY_AMT",
                    editable: false,//禁用编辑
                    readOnly: true,
                    value:0,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: 'numberFieldFormat',
                    allowDecimals: true,
                    decimalPrecision: 2,
                    hideTrigger: true,
                    fieldLabel: '剩余可转贷(人民币)',
                    name: "SY_WZXY_AMT_RMB",
                    editable: false,//禁用编辑
                    readOnly: true,
                    value:0,
                    fieldStyle: 'background:#E6E6E6',
                    hidden:true
                },
                {
                    xtype: 'numberFieldFormat',
                    allowDecimals: true,
                    decimalPrecision: 2,
                    hideTrigger: true,
                    fieldLabel: '此次转贷金额（原币）',
                    name: "INPUT_ZD_AMT",
                    editable: false,//禁用编辑
                    readOnly: true,
                    value:0,
                    fieldStyle: 'background:#E6E6E6',
                    listeners: {
                        change: function (me, newValue, oldValue, eOpts) {
                            if (isNaN(oldValue) || isNaN(newValue)) {
                                return;
                            }
                            var cha = newValue - oldValue;
                            var sy_wzxy_amt = me.up('form').down('numberFieldFormat[name="SY_WZXY_AMT"]').getValue();
                            me.up('form').down('numberFieldFormat[name="SY_WZXY_AMT"]').setValue(sy_wzxy_amt - cha);
                        }
                    }
                },
                {
                    xtype: 'numberFieldFormat',
                    allowDecimals: true,
                    decimalPrecision: 2,
                    hideTrigger: true,
                    fieldLabel: '此次转贷金额（人民币）',
                    name: "INPUT_ZD_AMT_RMB",
                    editable: false,//禁用编辑
                    readOnly: true,
                    value:0,
                    fieldStyle: 'background:#E6E6E6',
                    hidden:true,
                    listeners: {
                        change: function (me, newValue, oldValue, eOpts) {
                            if (isNaN(oldValue) || isNaN(newValue)) {
                                return;
                            }
                            var cha = newValue - oldValue;
                            var sy_wzxy_amt_rmb = me.up('form').down('numberFieldFormat[name="SY_WZXY_AMT_RMB"]').getValue();
                            me.up('form').down('numberFieldFormat[name="SY_WZXY_AMT_RMB"]').setValue(sy_wzxy_amt_rmb - cha);
                        }
                    }
                }

            ]
        });
    }


    /**
     * 初始化外债转贷表单中转贷明细信息表格
     */
    function initWindow_input_contentForm_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                dataIndex: "ZDMX_ID",
                type: "string",
                text: "转贷明细ID",
                width: 150,
                editor: {
                    xtype: "textfield",
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                hidden:true
            },
            {
                dataIndex: "AD_CODE", type: "string", text: "转贷地区", width: 200,
                renderer: function (value) {
                    var store = grid_tree_store;
                    var record = store.findRecord('CODE', value, 0, true, true, true);
                    re_value= (record != null ? record.get('TEXT') : value);
                    return re_value;
                },
                editor: {//   行政区划动态获取(下拉框)
                    xtype: 'combobox',
                    displayField: 'TEXT',
                    valueField: 'CODE',
                    editable:false,
                    store: grid_tree_store
                },
                tdCls: 'grid-cell',
                hidden:zd_type=='zf'?false:true
            },
            {
                dataIndex: "AD_CODE", type: "string", text: "转贷单位", width: 300,editable:false,
                displayField : 'text',
                editor: {//   行政区划动态获取(下拉框)
                    xtype: 'treecombobox',
                    displayField : 'text',
                    valueField : 'id',
                    selectModel: 'leaf',
                    value : '',
                    rootVisible : false,
                    store: store_zddw
                },
                tdCls: 'grid-cell',
                hidden:zd_type=='zf'?true:false,
                renderer: function (value) {
                    var store = store_zddw;
                    var record = store.findRecord('id', value, 0, false, true, true);
                    return record != null ? record.get('text') : value;
                },
                listeners: {
                    'rowclick':function(self){

                    }
                }
            },
            {
                dataIndex: "ZDXM_NAME",
                type: "string",
                text: "转贷项目",
                width: 200,
                disabled:zd_type=='zf'?false:true,
                hidden:  zd_type=='zf'?false:true,
                editable:false,
                editor: {
                    xtype: 'combobox',
                    displayField: 'name',
                    valueField: 'name',
                    editable:false,
                    store:STORE_TREE_ZDXM
                },
                tdCls: 'grid-cell'
            },
            {
                dataIndex: "ZDXM_NAME",
                type: "string",
                text: "转贷项目",
                width: 200,
                disabled:zd_type=='dw'?false:true,
                hidden:zd_type=='dw'?false:true,
                editable:false,
                editor: {
                    xtype: 'combobox',
                    displayField: 'NAME',
                    valueField: 'NAME',
                    store:sjxm_tree_store
                },
                tdCls: 'grid-cell'
            },
            {
                dataIndex: "ZDXM_ID", type: "string", text: "转贷项目ID",
                editor: {
                    xtype: "textfield",
                    editable: false
                },
                hidden:true
            },
            {
                dataIndex: "ZDXY_AMT", type: "float", text: "转贷协议金额（原币）", width: 180,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    allowDecimals: true,
                    decimalPrecision: 2,
                    minValue: 0,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                renderer: function (value, cellmeta, record) {
                    return Ext.util.Format.number(value, '0,000.00');
                },

            },
            {
                dataIndex: "ZDLX_RATE", type: "float", text: "转贷汇率", width: 160,format: '0.000000',hidden:true,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.000000',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    allowDecimals: true,
                    decimalPrecision: 6,
                    minValue: 0,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                }
            },
            {
                dataIndex: "ZDXY_AMT_RMB", type: "float", text: "转贷协议金额（人民币）", width: 180,hidden:true,
                /*renderer: function (value,cellmeta,record) {
                    cellmeta.tdCls = 'grid-cell-unedit';
                    return Ext.util.Format.number(value, '0,000.00####');
                },*/
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    allowDecimals: true,
                    decimalPrecision: 2,
                    minValue: 0,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "ZDXY_NO", type: "string", text: "转贷协议号", width: 150,allowBlank: false,
                editor: {
                    xtype:'textfield',
                    allowBlank: false,
                },
                tdCls: 'grid-cell'
            },
            {dataIndex: "REMARK", type: "string", text: "备注", width: 150, editor: 'textfield'}
        ];

        var grid = DSYGrid.createGrid({
            itemId: 'wzzd_grid2',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            dataUrl: [],
            selModel: {
                mode: "SINGLE"
            },
            checkBox: true,
            border: false,
            flex: 1,
            height: '100%',
            width: '100%',
            viewConfig: {
                stripeRows: false
            },
            features: [{
                ftype: 'summary'
            }],
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'wzzd_grid_plugin_cell2',
                    clicksToMoveEditor: 1
                }
            ],
            pageConfig: {
                enablePage: false
            },
            listeners: {
                beforeedit: function (editor,context) {
                    if(context.field=='ZDXM_NAME'){
                        if(zd_type!=null&&zd_type=="dw"){
                            var var$temp1=context.record.get('AD_CODE');
                            if(var$temp1==null||var$temp1==""||var$temp1==undefined){
                                Ext.MessageBox.alert('提示', '请先选择转贷单位！');
                                return false;
                            }else{
                                sjxm_tree_store.proxy.extraParams['AD_CODE']=var$temp1;
                                sjxm_tree_store.load({
                                    callback: function () {
                                    }
                                });
                            }
                        }
                        if(zd_type!=null&&zd_type=="zf"){
                            var var$temp1=context.record.get('AD_CODE');
                            if(var$temp1==null||var$temp1==""||var$temp1==undefined){
                                Ext.MessageBox.alert('提示', '请先选择转贷地区！');
                                return false;
                            }else{
                                STORE_TREE_ZDXM.proxy.extraParams['AD_CODE']=var$temp1 ;
                                STORE_TREE_ZDXM.proxy.extraParams['U_DXM_ID']=SJXM_ID ;
                                STORE_TREE_ZDXM.load({
                                    callback: function () {
                                    }
                                });
                            }
                        }
                    }
                    /*if(context.field=='ZDLX_RATE'){
                        var var$temp1=context.record.get('ZDXY_AMT');
                        if(var$temp1==null||var$temp1==""||var$temp1==undefined){
                            Ext.MessageBox.alert('提示', '请先选择转贷协议金额（原币）！');
                            return false;
                        }else{

                        }
                    }*/
                },
                validateedit: function (editor, context) {
                    if(context.field == 'ZDXM_NAME') {
                        if(zd_type!=null&&zd_type=="zf"){
                            var record = STORE_TREE_ZDXM.findRecord('name', context.value, 0, false, true, true);
                            if(record!=null && record!="" ) {
                                var zdxm_id = record.get("id");
                                context.record.set('ZDXM_ID', zdxm_id);
                            }
                        }
                        if(zd_type!=null&&zd_type=="dw"){
                            var record = sjxm_tree_store.findRecord('NAME', context.value, 0, false, true, true);
                            if(record!=null && record!="" ){
                                var zdxm_id=record.get("ID");
                                context.record.set('ZDXM_ID',zdxm_id);
                            }

                        }
                    }
                },
                edit:function (editor,context) {
                    //转贷地区改变时，移除转贷项目
                    if(context.field=='AD_CODE' && context.originalValue != context.value){
                        context.record.set('ZDXM_NAME',null);
                    }
                    if(context.field=='ZDLX_RATE'){
                        var ZDXY_AMT=context.record.get('ZDXY_AMT');
                        if(ZDXY_AMT!=null&&ZDXY_AMT!=undefined&&context.value!=null&&context.value!=undefined){
                            context.record.set('ZDXY_AMT_RMB',parseFloat(ZDXY_AMT*context.value).toFixed(2));
                        }
                    }
                    if(context.field=='ZDXY_AMT'){
                        var ZDLX_RATE=context.record.get("ZDLX_RATE");
                        if(ZDLX_RATE!=null&&ZDLX_RATE!=undefined&&ZDLX_RATE>=0){
                            context.record.set("ZDXY_AMT_RMB",parseFloat(ZDLX_RATE*context.value).toFixed(2));
                        }
                    }
                    /*if(context.field=="ZDLX_RATE"){
                        var ZDXY_AMT=context.record.get("ZDXY_AMT");
                        if(ZDXY_AMT!=null&&ZDXY_AMT!=undefined&&ZDXY_AMT>=0){
                            context.record.set("ZDXY_AMT_RMB",parseFloat(ZDXY_AMT*context.value).toFixed(2));
                        }
                    }*/
                    if(context.field=='ZDXY_AMT'||context.field=='ZDXY_AMT_RMB'||context.field=='ZDLX_RATE'){
                        refresh();
                    }
                },
                selectionChange: function (view, records) {
                    grid.up('window').down('#zdmxDelBtn').setDisabled(!records.length);
                }
            }
        });
        grid.getStore().on('endupdate', function () {
            var self = grid.getStore();
            var form = grid.up('window').down('form');
            var input_zd_amt=0;
            var input_zd_amt_rmb=0;
            self.each(function (record) {
                input_zd_amt += record.get('ZDXY_AMT');
                input_zd_amt_rmb += record.get('ZDXY_AMT_RMB');
            });
            form.down('numberFieldFormat[name="INPUT_ZD_AMT"]').setValue(input_zd_amt);
            form.down('numberFieldFormat[name="INPUT_ZD_AMT_RMB"]').setValue(input_zd_amt_rmb);
        });
        return grid;
    }

    /**
     * 初始化外债转贷录入表单中页签panel的附件页签
     */
    function initWindow_wzzdlr_contentForm_tab_upload(config) {
        var busiId=config.busiId;
        var grid = UploadPanel.createGrid({
            busiType: 'WZZDXY',//业务类型
            busiId: busiId,//业务ID
            editable: config.editable,//是否可以修改附件内容
            gridConfig: {
                itemId: config.editable?'window_wzzdlr_contentForm_tab_upload_grid_edit':'window_wzzdlr_contentForm_tab_upload_grid_view'
            }
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
            if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else if ($('span.file_sum')) {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;

    }

    function refresh() {
        var grid_wzzd = Ext.ComponentQuery.query('grid[itemId="wzzd_grid2"]')[0];

        var form_wzzd = Ext.ComponentQuery.query('form[itemId="wzzd_form"]')[0];

        var INPUT_ZD_AMT=form_wzzd.getForm().findField("INPUT_ZD_AMT");
        var INPUT_ZD_AMT_RMB=form_wzzd.getForm().findField("INPUT_ZD_AMT_RMB");

        var VAR$INPUT_ZD_AMT=0;
        var VAR$INPUT_ZD_AMT_RMB=0;

        if(grid_wzzd!=null&&grid_wzzd!=undefined&&grid_wzzd!=""){
            var grid_store=grid_wzzd.getStore();
            grid_store.commitChanges();
            for(var i=0;i<grid_store.getCount();i++){
                var record=grid_store.getAt(i);
                var zd_amt=record.get("ZDXY_AMT");
                if(zd_amt!=null&&zd_amt!=undefined&&zd_amt>=0){
                    VAR$INPUT_ZD_AMT+=zd_amt;
                }
                var zd_amt_rmb=record.get("ZDXY_AMT_RMB");
                if(zd_amt_rmb!=null&&zd_amt_rmb!=undefined&&zd_amt_rmb>=0){
                    VAR$INPUT_ZD_AMT_RMB+=zd_amt_rmb;
                }
            }
        }
        INPUT_ZD_AMT.setValue(parseFloat(VAR$INPUT_ZD_AMT).toFixed(2));
        INPUT_ZD_AMT_RMB.setValue(parseFloat(VAR$INPUT_ZD_AMT_RMB).toFixed(2));
    }

    function modify(records,btn){
        var record= records[0];
        //修改全局变量的值
        button_name = btn.text;
        ZDXX_ID = record.get("ZDXX_ID");
        //发送ajax请求，获取修改数据
        $.post('/wzgl_reflct.action?method=getModfiye', {
            ZDXX_ID: ZDXX_ID,
            button_name:button_name,
            zd_type:zd_type,
            AD_CODE:AD_CODE
        }, function (data) {
            if(data.success){
                var dataf=data.data;
                if(dataf!=null&&dataf.length>0){
                    var recordf=dataf[0];
                    window_input.show();
                    SJXM_ID=recordf.SJXM_ID;
                    sjxm_tree_store.getProxy().extraParams['SJXM_ID']=SJXM_ID;
                    sjxm_tree_store.load();
                    //刷新填报弹出中转贷明细表获取转贷计划
                    STORE_TREE_ZDXM.proxy.extraParams['U_DXM_ID'] = SJXM_ID;
                    STORE_TREE_ZDXM.load();
                    var wzzd_form=Ext.ComponentQuery.query('form[itemId="wzzd_form"]')[0];
                    wzzd_form.getForm().setValues(recordf);

                    //set grid
                    var wzzd_grid=Ext.ComponentQuery.query('grid[itemId="wzzd_grid2"]')[0];

                    for(var j=0;j<dataf.length;j++){
                        var tempvar1=dataf[j];
                        wzzd_grid.insertData(null,{
                            ZDMX_ID:tempvar1.ZDMX_ID,
                            AD_CODE:tempvar1.ZD_AD_CODE,
                            ZDXM_NAME:tempvar1.ZDXM_NAME,
                            ZDXM_ID:tempvar1.ZDXM_ID,
                            ZDXY_AMT:tempvar1.NOW_ZD_AMT,
                            ZDLX_RATE:tempvar1.ZDHL_MX,
                            ZDXY_AMT_RMB:tempvar1.NOW_ZD_AMT_RMB,
                            ZDXY_NO:tempvar1.ZDXY_NO,
                            REMARK:tempvar1.ZD_REMARK
                        });
                        //sjxm_tree_store.getProxy().extraParams['AD_CODE']=tempvar1.ZD_AD_CODE;
                    }
                }
            }else{
                Ext.Msg.alert('提示', data.message);
                return false;
            }
        }, 'json');
    }

    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param, param_detail) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();

        //增加查询参数
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        //刷新
        store.loadPage(1);
        //刷新下方表格,置为空
        if (DSYGrid.getGrid('contentGrid_detail')) {
            var store_details = DSYGrid.getGrid('contentGrid_detail').getStore();
            //如果传递参数不为空，就刷新明细表格
            if (typeof param_detail != 'undefined' && param_detail != null) {
                for (var name in param_detail) {
                    store_details.getProxy().extraParams[name] = param_detail[name];
                }
                store_details.loadPage(1);
            } else {
                store_details.removeAll();
            }
        }
        var attachStore = DSYGrid.getGrid("window_wzzdlr_contentForm_tab_upload_grid_view").getStore();
        attachStore.removeAll();

    }

    /**
     * 工作流变更
     */
    function doworkupdate(records,btn) {
        var ids=new Array();
        button_name=btn.text;
        var btn_code=btn.name;
        for(var k=0;k<records.length;k++){
            var zd_id=records[k].get("ZDXX_ID");
            ids.push(zd_id);
        }
        button_name = btn.text;
        if (button_name == '送审') {
            Ext.Msg.confirm('提示', '请确认是否送审！' , function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("/wzgl_reflct.action?method=doworkstudio",{
                        ids: Ext.util.JSON.encode(ids),
                        ad_code:AD_CODE,
                        button_name:button_name,
                        zd_type:zd_type,
                        btn_code:btn_code,
                        node_code:node_code,
                        wf_id:wf_id,
                        audit_info:"",
                        userCode:userCode
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
        } else {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text + "意见",
                animateTarget: btn,
                value: btn.name == 'up' ? null : '同意',
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("/wzgl_reflct.action?method=doworkstudio",{
                            ids: Ext.util.JSON.encode(ids),
                            ad_code:AD_CODE,
                            button_name:button_name,
                            zd_type:zd_type,
                            btn_code:btn_code,
                            node_code:node_code,
                            wf_id:wf_id,
                            audit_info:"",
                            userCode:userCode,
                            audit_info: text
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
                }
            });
        }
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
    //转贷地区下拉框
    var grid_tree_store = Ext.create('Ext.data.Store', {//下拉框store
        fields: ['CODE', 'TEXT'],
        proxy: {
            type: 'ajax',
            url: '/wzgl_reflct.action?method=getAdDataByCode',
            extraParams: {
                AD_CODE: AD_CODE
            },
            reader: {
                type: 'json',
                root: 'data'
            }
        },
        autoLoad: true
    });
    //转贷单位下拉框
    var grid_tree_store_dw = Ext.create('Ext.data.Store', {//下拉框store
        fields: ['ID','CODE', 'NAME'],
        proxy: {
            type: 'ajax',
            url: '/wzgl_reflct.action?method=getAgDataByCode',
            extraParams: {
                AD_CODE: AD_CODE
            },
            reader: {
                type: 'json',
                root: 'data'
            }
        },
        autoLoad: true
    });

    //转贷项目下拉框

    var sjxm_tree_store = Ext.create('Ext.data.Store', {//下拉框store
        fields: ['id','code', 'name'],
        proxy: {
            type: 'ajax',
            url: '/wzgl_reflct.action?method=getZdxm',
            extraParams: {
                AD_CODE: AD_CODE,
                SJXM_ID: SJXM_ID,
                ZD_TYPE: zd_type
            },
            reader: {
                type: 'json',
                root: 'data'
            }
        },
        autoLoad: true
    });


    //var STORE_TREE_ZDXM= DebtEleStoreDB('DEBT_SJXM',{condition:' and (SUPERGUID = \''+SJXM_ID+'\' ) '});
    var STORE_TREE_ZDXM= getSjxmStore({/*AD_CODE:AD_CODE,*/U_DXM_ID:SJXM_ID});


    /*查看操作记录*/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
            return;
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
            return;
        } else {
            var XX_ID = records[0].get("ZDXX_ID");
            fuc_getWorkFlowLog(XX_ID);
        }
    }
</script>

</body>
</html>
