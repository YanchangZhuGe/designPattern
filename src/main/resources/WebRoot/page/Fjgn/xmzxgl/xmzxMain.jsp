<%--
  Created by IntelliJ IDEA.
  User: wangjingcheng
  Date: 2019/4/1
  Time: 14:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <title>项目执行管理</title>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">

    <style type="text/css">
    .grid-cell-font {
        color: blue;
    }
    .label-color {
        color: red;
        font-size: 100%;
    }
</style>
</head>
<body>

<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/js/debt/xmInfo.js"></script>
<script type="text/javascript">
    // 获取session 数据
    var userName = '${sessionScope.USERNAME}';  // 获取用户名称
    var userCode = '${sessionScope.USERCODE}';  // 获取用户编码
    var AD_NAME = '${sessionScope.ADNAME}';  // 获取地区名称
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    // 获取系统参数
    var is_zxzqxt = '${fns:getSysParam("IS_ZXZQXT")}';  //获取系统参数 是否是专项债券系统
    var nowDate = '${fns:getDbDateDay()}';  // 当前日期

    // 获取URL参数
    var wf_id = "${fns:getParamValue('wf_id')}"; // 当前工作流流程id
    var node_code = "${fns:getParamValue('node_code')}"; // 当前工作流节点id
    var node_type = "${fns:getParamValue('node_type')}"; // 当前节点名称
    var xmzx_type = "${fns:getParamValue('xmzx_type')}"; // 项目执行管理类型
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    var url_xm_id = "${fns:getParamValue('url_xm_id')}";  //从新首页跳转过来 打开变更弹窗
    //20210522 fzd 获取角色类型
    var dwRoleType = "${fns:getParamValue('dwRoleType')}";
    var url_xm_data ;
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    // 自定义参数
    var button_name = '';//当前操作按钮名称text
    var v_child = '0';  //是否加载全部区划
    var xmxzCondition = " and 1=1";
    var FJ_ID = '';
    var JH_ND='';//计划年度
    var  PLAN_ID='';
    /**
     * 通用配置json，用于存储全局配置，
     */
    var xmzx_json_common = {
        jsjd: 'xmjsjd.js', // 项目建设进度
        zjzt: 'xmzjdw.js', // 项目资金到位
        ztb: 'xmztb.js', // 项目招投标
        sjsy: 'xmsjsy.js' // 项目实际收益
    };

    //资金附件编辑
    var editValue = true;
    //资金附件到位id
    var zjdzXmId;
    var items_toolbar_json = {
        lr: { //录入
            items: {
                '001': [
                    {
                        xtype: 'button',
                        text: '查询',
                        icon: '/image/sysbutton/search.png',
                        handler: function (btn) {
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '一体化接入',
                        name: 'YTHJR',
                        icon: '/image/sysbutton/add.png',
                        hidden: xmzx_type == 'zjzt' ? false : true,
                        handler: function (btn) {
                            window_Xmzx_ythjr(btn);
                        }
                    },
                    {
                        xtype: 'button',
                        text: '录入',
                        name: 'INPUT',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            if (!AG_ID || AG_ID == '') {
                                Ext.Msg.alert('提示', "请选择单位");
                                return;
                            }
                            button_name = btn.name;
                            editValue = true;
                            if(xmzx_type=='sjsy'){
                                //专项收益缴库选取修改为选择项目的还本付息计划
                                window_Xmzx_XmDfjhSelect(btn);
                            }else {
                                window_Xmzx_XmSelect(btn);
                            }
                            //loadHbzc(new Date().getFullYear());
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
                                Ext.MessageBox.alert('提示', '请选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else {
                                button_name = btn.name;
                                AG_ID=records[0].data.AG_ID;
                                var xmzxFormRecords = records[0].getData();
                                btn.busiId = xmzxFormRecords.ID;
                                JH_ND=xmzxFormRecords.ND;
                                PLAN_ID=xmzxFormRecords.PLAN_ID;
                                btn.editable = true;
                                //20210629 fzd 修改时附件设置为可修改
                                editValue = true;
                                window_xmzxtb.show(btn);
                                if (xmzx_type == "zjzt") {//20210511李月去掉资金到位类型弹窗在展示
                                    $.post("/findJsxmZjdwqk.action", {
                                        ZJDW_ID: records[0].getData().ZJDW_ID,
                                        XM_ID: records[0].getData().XM_ID,
                                        ND: records[0].getData().ND,
                                        ZJ_TYPE: records[0].getData().ZJ_TYPE,
                                        button_name: button_name
                                    }, function (data) {
                                        if (data.list != null) {
                                            var xmjdfbForm = Ext.ComponentQuery.query('form#xmzjdwqk_form')[0];
                                            var url = '/page/debt/common/xmyhs.jsp';
                                            var paramNames = new Array();
                                            paramNames[0] = "XM_ID";
                                            paramNames[1] = "IS_RZXM";
                                            var paramValues = new Array();
                                            paramValues[0] = encodeURIComponent(xmzxFormRecords.XM_ID);
                                            paramValues[1] = encodeURIComponent(xmzxFormRecords.IS_RZXM);
                                            var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + xmzxFormRecords.XM_NAME + '</a>';
                                            xmzxFormRecords.XM_NAME = result;
                                            xmjdfbForm.getForm().setValues(xmzxFormRecords);
                                            xmjdfbForm.getForm().findField("ZJYDW_AMT").setValue(data.list[0].ZJDW_AMT);
                                            xmjdfbForm.getForm().findField("PAY_NO").setValue(data.list[0].PAY_NO);
                                            xmjdfbForm.getForm().findField("PAY_ACCT_NAME").setValue(data.list[0].PAY_ACCT_NAME);
                                            xmjdfbForm.getForm().findField("PAY_ACCT_NO").setValue(data.list[0].PAY_ACCT_NO);
                                            xmjdfbForm.getForm().findField("PAY_ACCT_BANK_NAME").setValue(data.list[0].PAY_ACCT_BANK_NAME);
                                            xmjdfbForm.getForm().findField("PAYEE_ACCT_NAME").setValue(data.list[0].PAYEE_ACCT_NAME);
                                            xmjdfbForm.getForm().findField("PAYEE_ACCT_NO").setValue(data.list[0].PAYEE_ACCT_NO);
                                            xmjdfbForm.getForm().findField("PAYEE_ACCT_BANK_NAME").setValue(data.list[0].PAYEE_ACCT_BANK_NAME);
                                            xmjdfbForm.getForm().findField("EXP_FUNC_CODE").setValue(data.list[0].EXP_FUNC_CODE);
                                            xmjdfbForm.getForm().findField("GOV_BGT_ECO_CODE").setValue(data.list[0].GOV_BGT_ECO_CODE);
                                        }
                                    }, "json")
                                } else {
                                    var xmzxFormRecords = records[0].getData();
                                    var url='/page/debt/common/xmyhs.jsp';
                                    var paramNames=new Array();
                                    paramNames[0]="XM_ID";
                                    paramNames[1]="IS_RZXM";
                                    var paramValues=new Array();
                                    paramValues[0]=encodeURIComponent(xmzxFormRecords.XM_ID);
                                    paramValues[1]=encodeURIComponent(xmzxFormRecords.IS_RZXM);
                                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+xmzxFormRecords.XM_NAME+'</a>';
                                    xmzxFormRecords.XM_NAME = result;
                                    var xmjdfbForm = Ext.ComponentQuery.query('form#xmzx_form')[0];
                                    xmjdfbForm.getForm().setValues(xmzxFormRecords);
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            delXmzxMainGrid(btn);

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
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                                reloadGrid();
                            }
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
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                                reloadGrid();
                            }
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
                                Ext.MessageBox.alert('提示', '请选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else {
                                AG_ID=records[0].data.AG_ID;
                                button_name = btn.name;
                                var xmzxFormRecords = records[0].getData();
                                btn.busiId = xmzxFormRecords.ID;
                                btn.editable = true;
                                window_xmzxtb.show(btn);
                                if (xmzx_type == "zjzt") {//20210511liyue去掉资金到位类型展示
                                    $.post("/findJsxmZjdwqk.action", {
                                        XM_ID: records[0].getData().XM_ID,
                                        ND: records[0].getData().ND,
                                        ZJ_TYPE: records[0].getData().ZJ_TYPE,
                                        button_name: button_name
                                    }, function (data) {
                                        if (data.list != null) {
                                            var xmjdfbForm = Ext.ComponentQuery.query('form#xmzjdwqk_form')[0];
                                            var url = '/page/debt/common/xmyhs.jsp';
                                            var paramNames = new Array();
                                            paramNames[0] = "XM_ID";
                                            paramNames[1] = "IS_RZXM";
                                            var paramValues = new Array();
                                            paramValues[0] = encodeURIComponent(xmzxFormRecords.XM_ID);
                                            paramValues[1] = encodeURIComponent(xmzxFormRecords.IS_RZXM);
                                            var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + xmzxFormRecords.XM_NAME + '</a>';
                                            xmzxFormRecords.XM_NAME = result;
                                            xmjdfbForm.getForm().setValues(xmzxFormRecords);
                                            xmjdfbForm.getForm().findField("ZJYDW_AMT").setValue(data.list[0].ZJDW_AMT);
                                        }
                                    }, "json")
                                } else {
                                    var xmjdfbForm = Ext.ComponentQuery.query('form#xmzx_form')[0];
                                    var url = '/page/debt/common/xmyhs.jsp';
                                    var paramNames = new Array();
                                    paramNames[0] = "XM_ID";
                                    paramNames[1] = "IS_RZXM";
                                    var paramValues = new Array();
                                    paramValues[0] = encodeURIComponent(xmzxFormRecords.XM_ID);
                                    paramValues[1] = encodeURIComponent(xmzxFormRecords.IS_RZXM);
                                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + xmzxFormRecords.XM_NAME + '</a>';
                                    xmzxFormRecords.XM_NAME = result;
                                    xmjdfbForm.getForm().setValues(xmzxFormRecords);
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            delXmzxMainGrid(btn);
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
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                                reloadGrid();
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
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                                reloadGrid();
                            }
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
                            if (AD_CODE == null || AD_CODE == '') {
                                Ext.Msg.alert('提示', '请选择区划！');
                                return;
                            } else {
                                reloadGrid();
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '撤销审核',
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
                ]
            }
        }
    };

    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        //动态加载js
        $.ajaxSetup({
            cache: false
        });
        //zhanghl 20201231 延时等其他加载完成之后在进行弹窗弹开
        setTimeout(function(){
            var btn = {};
            //从单位新首页跳转过来
            if(!isNull(url_xm_id)){
                var btn = {};
                if(node_type == 'lr'){
                    if(xmzx_type=='sjsy'){//2021071210liyue专项收入缴库 改为选择还本付息计划
                        $.post("/getDwZqxmHbfx.action", {//根据项目id生成项目的还本付息计划
                            xm_id: url_xm_id,
                            dwRoleType:dwRoleType
                        }, function (data) {
                            button_name = 'INPUT';
                            window_Xmzx_XmDfjhSelect();
                            var dfjhGrid = DSYGrid.getGrid('grid_select');
                            dfjhGrid.getStore().removeAll();
                            dfjhGrid.insertData(null,  data.list);
                        }, "json");
                        //20210908 zhuangrx 过滤掉单位首页没用的项目
                    }
                    else if(xmzx_type=='ztb') {
                        $.post("/findJsxmInfo.action", {
                            AD_CODE: AD_CODE,
                            AG_ID: AG_ID,
                            xmzx_type: xmzx_type,//功能类型
                            dwRoleType:dwRoleType ,//20210521 fzd 增加单位角色类型
                            xm_id: url_xm_id,
                            start:0,
                            limit:100000
                        }, function (data) {
                            button_name = 'INPUT';
                            var xmzxFormRecords = data.list[0];
                            if(!isNull(xmzxFormRecords)){
                                xmzxFormRecords.ID = GUID.createGUID();
                                btn.busiId = xmzxFormRecords.ID;
                                var url='/page/debt/common/xmyhs.jsp';
                                var paramNames=new Array();
                                btn.editable = true;
                                paramNames[0]="XM_ID";
                                paramNames[1]="IS_RZXM";
                                var paramValues=new Array();
                                paramValues[0]=encodeURIComponent(xmzxFormRecords.XM_ID);
                                paramValues[1]=encodeURIComponent(xmzxFormRecords.IS_RZXM);
                                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+xmzxFormRecords.XM_NAME+'</a>';
                                url_xm_data = data.list[0];
                                if(xmzx_type == 'zjzt'){//20210511liyue去掉单位首页资金到位类型弹窗
                                    zjdzXmId = xmzxFormRecords.ID;
                                    window_xmzjdwqk.show(url_xm_id);//资金到位情况框
                                }else{
                                    window_xmzxtb.show(btn);
                                    var form = Ext.ComponentQuery.query('form[itemId="xmzx_form"]')[0];
                                    xmzxFormRecords.XM_NAME=result;
                                    form.getForm().setValues(xmzxFormRecords);
                                }
                            }
                        }, "json");
                    }
                    else{
                        $.post("/getXmInfoById.action", {
                            xm_id: url_xm_id
                        }, function (data) {
                            button_name = 'INPUT';
                            var xmzxFormRecords = data.list[0];
                            if(!isNull(xmzxFormRecords)){
                                xmzxFormRecords.ID = GUID.createGUID();
                                btn.busiId = xmzxFormRecords.ID;
                                var url='/page/debt/common/xmyhs.jsp';
                                var paramNames=new Array();
                                btn.editable = true;
                                paramNames[0]="XM_ID";
                                paramNames[1]="IS_RZXM";
                                var paramValues=new Array();
                                paramValues[0]=encodeURIComponent(xmzxFormRecords.XM_ID);
                                paramValues[1]=encodeURIComponent(xmzxFormRecords.IS_RZXM);
                                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+xmzxFormRecords.XM_NAME+'</a>';
                                url_xm_data = data.list[0];
                                window_xmzxtb.show(btn);
                                var formId = xmzx_type == 'zjzt' ? 'form[itemId="xmzjdwqk_form"]': 'form[itemId="xmzx_form"]';
                                var form = Ext.ComponentQuery.query(formId)[0];
                                xmzxFormRecords.XM_NAME=result;
                                form.getForm().setValues(xmzxFormRecords);
                            }
                        }, "json");
                    }
                }
            }
        }, 1000);
        //ajax加载js文件
        $.getScript(xmzx_json_common[xmzx_type], function () {
            initContent();
        });
    });
    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: 'border',
            defaults: {
                split: true,                  //是否有分割线
                collapsible: false           //是否可以折叠
            },
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: items_toolbar_json[node_type].items[WF_STATUS]
                }
            ],
            height: '100%',
            renderTo: Ext.getBody(),
            border: false,
            items: xmzx_json_common.items_content ? xmzx_json_common.items_content() : []
        });
    }

    /**
     * 初始化右侧panel，放置1个表格
     */
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            itemId: 'contentFormPanel',
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    layout: {
                        type: 'column'
                    },
                    border: true,
                    bodyStyle: 'padding:0 0 0 0',
                    defaults: {
                        margin: '1 1 2 5',
                        width: 200,
                        labelWidth: 80,//控件默认标签宽度
                        labelAlign: 'left'//控件默认标签对齐方式
                    },
                    items: [
                        {
                            xtype: 'combobox',
                            fieldLabel: '状态',
                            name: 'WF_STATUS',
                            store: node_type == 'lr' ? DebtEleStore(json_debt_zt1) : DebtEleStore(json_debt_zt2_3),
                            width: 110,
                            labelWidth: 30,
                            editable: false,
                            labelAlign: 'right',
                            displayField: "name",
                            valueField: "id",
                            value: WF_STATUS,
                            allowBlank: false,
                            listeners: {
                                change: function (self, newValue) {
                                    WF_STATUS = newValue;
                                    var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                                    toolbar.removeAll();
                                    toolbar.add(items_toolbar_json[node_type].items[WF_STATUS]);
                                    //刷新当前表格
                                    reloadGrid();
                                }
                            }
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '项目性质',
                            itemId: 'XMXZ_ID',
                            displayField: 'name',
                            valueField: 'code',
                            rootVisible: true,
                            lines: false,
                            selectModel: 'all',
                            store: DebtEleTreeStoreDB("DEBT_ZJYT", {condition: xmxzCondition})
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '项目类型',
                            itemId: 'XMLX_ID',
                            displayField: 'name',
                            valueField: 'code',
                            rootVisible: true,
                            lines: false,
                            selectModel: 'all',
                            typeAhead: false,//不可编辑
                            editable: false,
                            store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                            listeners: {}
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '模糊查询',
                            itemId: "MHCX",
                            labelWidth: 80,
                            width: 300,
                            emptyText: '请输入项目编码或名称',
                            enableKeyEvents: true,
                            listeners: {
                                'keydown': function (self, e, eOpts) {
                                    var key = e.getKey();
                                    if (key == Ext.EventObject.ENTER) {
                                        reloadGrid();
                                    }
                                }
                            }
                        }
                    ]
                }
            ],
            border: false,
            items: [
                initContentGrid()
            ]
        });
    }

    /**
     * 初始化右侧主表格
     */
    function initContentGrid() {
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: xmzx_json_common.xmzx_headerjson ? xmzx_json_common.xmzx_headerjson : [],
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                wf_id: wf_id,
                node_code: node_code,
                xmzx_type: xmzx_type,
                button_name: button_name,
                WF_STATUS: WF_STATUS,
                node_type:node_type,
                dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
            },
            dataUrl: '/findJsxmMainInfo.action',
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbarHeight: 50,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            features: xmzx_type == 'jsjd' ? [] :[{
                ftype: 'summary'
            }],
            listeners: {
                itemdblclick: function (self, record) {
                     /* var btn = {};
                    var xmzxFormRecords = record.getData();
                    btn.busiId = xmzxFormRecords.ID;
                    btn.editable = false;
                    window_xmzxtb.show(btn);
                    var url = '<a href="javascript:void(0);" onclick="initWin_xmInfo(\'' + xmzxFormRecords.XM_ID + '\',\'' + xmzxFormRecords.BILL_ID + '\')">' + xmzxFormRecords.XM_NAME + '</a>';
                    xmzxFormRecords.XM_NAME = url;
                    var xmjdfbForm = Ext.ComponentQuery.query('form#xmzx_form')[0];
                    xmjdfbForm.getForm().setValues(xmzxFormRecords);  */
                var btn = {};
                var xmzxFormRecords = record.getData();
                btn.busiId = xmzxFormRecords.ID;
                var url='/page/debt/common/xmyhs.jsp';
                var paramNames=new Array();
                btn.editable = false;
                //20210629 fzd 双击显示时附件设置为不可修改
                editValue = false ;
                window_xmzxtb.show(btn);
                paramNames[0]="XM_ID";
                paramNames[1]="IS_RZXM";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+xmzxFormRecords.XM_NAME+'</a>';
                var form_name = '';
                    if (xmzx_type=="zjzt") {
                        form_name = 'form#xmzjdwqk_form';
                    } else if (xmzx_type=="ztb"||xmzx_type=="sjsy"||xmzx_type=="jsjd"){
                        form_name = 'form#xmzx_form';
                    }  else {
                        form_name = 'form#xmxz_form';
                    }
            /*   if (xmzx_type=="ztb"||xmzx_type=="sjsy"||xmzx_type=="jsjd"|| xmzx_type=="zjzt"){
                   form_name = 'form#xmzx_form'; 
                }  else {
                   form_name = 'form#xmxz_form';
                }*/
                var xmjdfbForm = Ext.ComponentQuery.query(form_name)[0];
                xmzxFormRecords.XM_NAME=result;
                //20210913 chenfei 双击查看设置所有信息只读
                xmjdfbForm.getForm().getFields().each(function(field) {
                        field.setReadOnly(true);
                });
                xmjdfbForm.getForm().setValues(xmzxFormRecords);
                //return result;
                }
            }
        });
    }
    /**
     *  一体化接入
     */
    function window_Xmzx_ythjr(btn) {
        var window = Ext.create('Ext.window.Window', {
            title: '资金流水信息', // 窗口标题
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.8, //自适应窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'zjls', // 窗口标识
            name:'zjls_window',
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',
            /* closeAction: 'hide', //close 关闭  hide  隐藏*/
            items: [init_zjlsGrid(btn)],
            buttons: [
                {
                    text: '确定',
                    handler: function (btn) {
                        var win_xm_sel = Ext.ComponentQuery.query('window[itemId="xmzjls_grid"]');//项目选择窗口
                        if (win_xm_sel != null && win_xm_sel != undefined) {  //项目选择窗口存在
                            var grid = DSYGrid.getGrid('xmzjls_grid');
                            var record = grid.getSelectionModel().getSelection();
                            if (record.length < 1) {     //未选择项目
                                Ext.toast({
                                    html: "请选择至少一条数据后再进行操作!",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            } else {
                                btn.editable = true;
                                btn.up('window').close();
                            }
                        }
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

        window.show();
        return window;
    }
    /**
     * 加载项目选择表格
     */
    function init_zjlsGrid() {
        var xm_headerjson = [
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {dataIndex: "ZJ_TYPE", width: 150, type: "string", text: "资金类型"},
            {dataIndex: "PAY_NO", width: 250, type: "string", text: "拨款单号"},
            {dataIndex: "ZJDW_DATE", width: 150, type: "string", text: "拨款日期"},
            {
                dataIndex: "ZJDW_AMT", width: 160, type: "float", text: "拨款金额（万元）",summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {
                dataIndex: "QZZBJ_AMT", width: 180, type: "float", text: "其中资本金金额（万元）",summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {dataIndex: "PAY_ACCT_NAME", width: 200, type: "string", text: "付款人账户"},
            {dataIndex: "PAY_ACCT_NO", width: 300, type: "string", text: "付款人账号"},
            {dataIndex: "PAY_ACCT_BANK_NAME", width: 200, type: "string", text: "付款人开户行"},
            {dataIndex: "PAYEE_ACCT_NAME", width: 200, type: "string", text: "收款人账户"},
            {dataIndex: "PAYEE_ACCT_NO", width: 150, type: "string", text: "收款人账号"},
            {dataIndex: "PAYEE_ACCT_BANK_NAME", width: 200, type: "string", text: "收款人开户行"},
            {dataIndex: "GOV_BGT_ECO_CODE", width: 300, type: "string", text: "经济分类"},
            {dataIndex: "EXP_FUNC_CODE", width: 200, type: "string", text: "功能分类"},
            {dataIndex: "REMARK", width: 200, type: "string", text: "备注"}
        ];

        var grid = DSYGrid.createGrid({
            itemId: 'xmzjls_grid',
            flex: 1,
            headerConfig: {
                headerJson: xm_headerjson,
                columnAutoWidth: false
            },
            checkBox: true,
            selModel: {
                mode: "SINGLE"
            },
            tbar:[
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {

                    }
                }
            ],
            autoLoad: true,
            border: false,
            data: [
                {
                    ZJ_TYPE : '上级补助资金',PAY_NO : 'PAY20021252583', ZJDW_DATE : '2022-01-22', ZJDW_AMT : '56420.23', QZZBJ_AMT : '1000.00',
                    PAY_ACCT_NAME: 'XXX财政', PAY_ACCT_NO: '123546897852456258',
                    PAY_ACCT_BANK_NAME:'中国银行', PAYEE_ACCT_NAME:'XXX单位', PAYEE_ACCT_NO: '8896589654785568952',
                    PAYEE_ACCT_BANK_NAME: '中国邮政储蓄银行', GOV_BGT_ECO_CODE: '其他支出', EXP_FUNC_CODE:'其他支出'
                },
                {
                    ZJ_TYPE : '财政预算资金',PAY_NO : 'PAY20021252587', ZJDW_DATE : '2022-01-22', ZJDW_AMT : '876420.23', QZZBJ_AMT : '6058.2',
                    PAY_ACCT_NAME: 'XXX财政', PAY_ACCT_NO: '123546897852456258',
                    PAY_ACCT_BANK_NAME:'中国银行', PAYEE_ACCT_NAME:'XXX单位', PAYEE_ACCT_NO: '8896589654785568952',
                    PAYEE_ACCT_BANK_NAME: '中国邮政储蓄银行', GOV_BGT_ECO_CODE: '其他支出', EXP_FUNC_CODE:'其他支出'
                },
                {
                    ZJ_TYPE : '单位自筹资金',PAY_NO : 'PAY20021252584', ZJDW_DATE : '2022-01-22', ZJDW_AMT : '89420.23', QZZBJ_AMT : '7853.56',
                    PAY_ACCT_NAME: 'XXX财政', PAY_ACCT_NO: '123546897852456258',
                    PAY_ACCT_BANK_NAME:'中国银行', PAYEE_ACCT_NAME:'XXX单位', PAYEE_ACCT_NO: '8896589654785568952',
                    PAYEE_ACCT_BANK_NAME: '中国邮政储蓄银行', GOV_BGT_ECO_CODE: '其他支出', EXP_FUNC_CODE:'其他支出'
                },
                {
                    ZJ_TYPE : '其他资金',PAY_NO : 'PAY20021252586', ZJDW_DATE : '2022-01-22', ZJDW_AMT : '54420.23', QZZBJ_AMT : '698.56',
                    PAY_ACCT_NAME: 'XXX财政', PAY_ACCT_NO: '123546897852456258',
                    PAY_ACCT_BANK_NAME:'中国银行', PAYEE_ACCT_NAME:'XXX单位', PAYEE_ACCT_NO: '8896589654785568952',
                    PAYEE_ACCT_BANK_NAME: '中国邮政储蓄银行', GOV_BGT_ECO_CODE: '其他支出', EXP_FUNC_CODE:'其他支出'
                }
            ],
            params: {

            },
            pageConfig: {
                pageNum: true,//设置显示每页条数
                enablePage: true
            },
            features: [{
                ftype: 'summary'
            }]
        });
        return grid;

    }

    /**
     * 创建项目选择弹出框
     */
    function window_Xmzx_XmSelect(btn) {
        var window = Ext.create('Ext.window.Window', {
            title: '项目选择', // 窗口标题
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.9, //自适应窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'xm_sel', // 窗口标识
            name:'xm_window',
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',
           /* closeAction: 'hide', //close 关闭  hide  隐藏*/
            items: [init_XmGrid(btn)],
            buttons: [
                {
                    text: '确定',
                    handler: function (btn) {
                        var win_xm_sel = Ext.ComponentQuery.query('window[itemId="xm_sel"]');//项目选择窗口
                        if (win_xm_sel != null && win_xm_sel != undefined) {  //项目选择窗口存在
                            var grid = DSYGrid.getGrid('xm_grid');
                            var record = grid.getSelectionModel().getSelection();
                            if (record.length < 1) {     //未选择项目
                                Ext.toast({
                                    html: "请选择至少一条数据后再进行操作!",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            } else {
                                /**2022012311_wangjc: 应财政部需求去掉投资计划，直接进行填报选择**/
//                                if(xmzx_type=="zjzt"){
//                                    btn.busiId = GUID.createGUID(); //生成主表单ID
//                                    btn.editable = true;
//                                    window_xmzjdwqk.show(record[0].data.XM_ID);//资金到位情况框
//                                }else {
//
//                                }
                                btn.busiId = GUID.createGUID(); //生成主表单ID
                                btn.editable = true;
                                window_xmzxtb.show(btn);
                                var xmzxFormRecords = record[0].getData();
                                var url='/page/debt/common/xmyhs.jsp';
                                var paramNames=new Array();
                                paramNames[0]="XM_ID";
                                paramNames[1]="IS_RZXM";
                                var paramValues=new Array();
                                paramValues[0]=encodeURIComponent(xmzxFormRecords.XM_ID);
                                paramValues[1]=encodeURIComponent(xmzxFormRecords.IS_RZXM);
                                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+xmzxFormRecords.XM_NAME+'</a>';
                                xmzxFormRecords.XM_NAME = result;
                                xmzxFormRecords.SCJD = xmzxFormRecords.BUILD_STATUS_ID;
                                // var xmjdfbForm = Ext.ComponentQuery.query('form#xmzx_form')[0];
                                //20220524 fzd 专项债收入缴库新增不带出项目信息问题
                                var form_name = '';
                                if (xmzx_type=="zjzt") {
                                    form_name = 'form#xmzjdwqk_form';
                                } else if (xmzx_type=="ztb"||xmzx_type=="sjsy"||xmzx_type=="jsjd"){
                                    form_name = 'form#xmzx_form';
                                }  else {
                                    form_name = 'form#xmxz_form';
                                }
                                var xmjdfbForm = Ext.ComponentQuery.query(form_name)[0];
                                xmjdfbForm.getForm().setValues(xmzxFormRecords);
                                btn.up('window').close();
                            }
                        }
                    }
                },
                {
                    text: '关闭',
                 /*   hidden:xmzx_type=="zjzt"?true:false,*/
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });

        window.show();
        return window;
    }
    /**
     * 加载项目选择表格
     */
    function init_XmGrid() {
        var xm_headerjson = [
            {
                xtype: 'rownumberer', width: 45,
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {dataIndex: "BILL_ID", width: 150, type: "string", text: "唯一ID", hidden: true},
            {dataIndex: "AG_NAME", width: 300, type: "string", text: "单位名称"},
            {dataIndex: "ZQ_CODE", width: 200, type: "string", text: "债券编码", hidden : xmzx_type=='sjsy'?false:true},
            {dataIndex: "ZQ_NAME", width: 300, type: "string", text: "债券名称", hidden : xmzx_type=='sjsy'?false:true},
            {dataIndex: "ZQLB_NAME", width: 120, type: "string", text: "债券类型", hidden : xmzx_type=='sjsy'?false:true},
            {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
            {
                dataIndex: "XM_NAME", width: 300, type: "string", text: "项目名称",
                renderer: function (data, cell, record) {
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
            },
            {dataIndex: "LX_YEAR", type: "string", text: "立项年度"},
            {dataIndex: "XMLX_NAME", width: 200, type: "string", text: "项目类型"},
            {dataIndex: "BUILD_STATUS_NAME", width: 120, type: "string", text: "建设状态"},
            {
                dataIndex: "ZJDW_AMT", width: 200, type: "float", text: "项目已到位金额（万元）",summaryType: 'sum',hidden: xmzx_type == 'zjzt'?false:true,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {
                dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算（万元）",summaryType: 'sum',
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            }
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'xm_grid',
            flex: 1,
            headerConfig: {
                headerJson: xm_headerjson,
                columnAutoWidth: false
            },
            checkBox: true,
        	selModel: {
            mode: "SINGLE"
        	},
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'xmSel_toolbar',
                    margin:'5 0 5 0',
                    items: [
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '项目性质',
                            itemId: 'XMXZ_SEARCH',
                            displayField: 'name',
                            valueField: 'code',
                            rootVisible: true,
                            lines: false,
                            selectModel: 'all',
                            store: DebtEleTreeStoreDB("DEBT_ZJYT", {condition: xmxzCondition})
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '项目类型',
                            itemId: 'XMLX_SEARCH',
                            displayField: 'name',
                            valueField: 'code',
                            rootVisible: true,
                            lines: false,
                            selectModel: 'all',
                            typeAhead: false,//不可编辑
                            editable: false,
                            store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                            listeners: {}
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '模糊查询',
                            itemId: 'XM_SEARCH',
                            labelWidth: 60,
                            width: 280,
                            enableKeyEvents: true,
                            emptyText: '请输入项目编码或项目名称',
                            displayField: 'code',
                            valueField: 'id'
                        },
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function () {
                                //刷新当前表格
                                xmload();
                            }
                        }
                    ]
                }
            ],
            autoLoad: true,
            border: false,
            height: '100%',
            dataUrl: '/findJsxmInfo.action',
            params: {
                AD_CODE: AD_CODE,
                AG_ID: AG_ID,
                xmzx_type: xmzx_type,//功能类型
                dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
            },
            pageConfig: {
                pageNum: true,//设置显示每页条数
                enablePage: true
            },
            features: [{
                ftype: 'summary'
            }],
        });
        return grid;

    }


    /**
     * 刷新项目列表
     */
    function xmload() {
        var xMgrid = DSYGrid.getGrid('xm_grid');
        var xmGridStore = xMgrid.getStore();
        //20201207 解决资金到位模糊查询 bug
       /* xmGridStore.removeAll();*/
        var xmxz_search = xMgrid.down('textfield[itemId="XMXZ_SEARCH"]').getValue();
        var xmlx_search = xMgrid.down('textfield[itemId="XMLX_SEARCH"]').getValue();
        var xm_search = xMgrid.down('textfield[itemId="XM_SEARCH"]').getValue();
        xmGridStore.getProxy().extraParams = {
            button_name: button_name,
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            XMXZ_SEARCH: xmxz_search,
            XMLX_SEARCH: xmlx_search,
            XM_SEARCH: xm_search,
            xmzx_type: xmzx_type,
            dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
        };
        xmGridStore.loadPage(1);
    }

    /**
     * 初始化项目执行填报弹出窗口
     */
    var window_xmzxtb = {
        window: null,
        btn: null,
        config: {
            closeAction: 'destroy'
        },
        show: function (config, btn) {
            $.extend(this.config, config);
            if (!this.window || this.config.closeAction == 'destroy') {
                this.window = initWindow_xmzxtb(this.config, btn);
            }
            this.window.show();
        }
    };
    /**
     * 初始化项目资金到位情况窗口liyue20210511去掉资金到位类型弹窗展示
     */
    var window_xmzjdwqk = {
        window: null,
        btn: null,
        config: {
            closeAction: 'destroy'
        },
        show: function (config) {
            $.extend(this.config, config);
            if (!this.window || this.config.closeAction == 'destroy') {
                this.window = initWindow_xmzjdwqk(config);
            }
            this.window.show();
        }
    };
    /**
     * 初始化建设项目资金情况表单liyue20210511去掉资金到位类型弹窗展示
     */
    function initWindow_xmzjdwqk(config) {
        return Ext.create('Ext.window.Window', {
            title: "资金到位情况表",
            itemId: 'xmzx_window',
            width: document.body.clientWidth * 0.5, // 窗口宽度
            height: document.body.clientHeight * 0.6,
            frame: true,
            constrain: true,//防止超出浏览器边界
            buttonAlign: "right",// 按钮显示的位置：右下侧
            maximizable: true,//最大化按钮
            modal: true,//模态窗口
            resizable: true,//可拖动改变窗口大小
            layout: 'fit',
            defaults: {
                split: true,                 //是否有确认线
                collapsible: false           //是否可以折叠
            },
            closeAction: 'destroy',
            items: [initzjdwWiondow_form(config)],
        });
    }

    /**
     * 初始化建设项目进度发布弹出窗口
     */
    function initWindow_xmzxtb(btn) {
        return Ext.create('Ext.window.Window', {
            title: xmzx_json_common.window_title ? xmzx_json_common.window_title : '',
            itemId: 'xmzx_window',
            width: document.body.clientWidth * 0.83, // 窗口宽度
            height: xmzx_type == 'ztb' ? document.body.clientHeight * 0.6:  document.body.clientHeight * 0.8, // 添加
            frame: true,
            constrain: true,//防止超出浏览器边界
            buttonAlign: "right",// 按钮显示的位置：右下侧
            maximizable: true,//最大化按钮
            modal: true,//模态窗口
            resizable: true,//可拖动改变窗口大小
            layout: 'fit',
            defaults: {
                split: true,                 //是否有确认线
                collapsible: false           //是否可以折叠
            },
            closeAction: 'destroy',
            items: [initWiondow_form(btn)],
            buttons: [
                {
                    text: '保存',
                    name: 'btn_update',
                    itemId: 'btnSave',
                    id: 'save',
                    hidden: btn.editable ? false : true,
                    handler: function (btn) {
                        submitXmjdfb(btn);
                    }
                },
                {
                    text: '取消',
                    name: 'btn_delete',
                    hidden: btn.editable ? false : true,
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
    }

    /**
     * 删除主表格信息
     */
    function delXmzxMainGrid(btn) {
        // 检验是否选中数据
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条后记录!');
            return;
        }
        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
            if (btn_confirm == 'yes') {
                var ids = new Array();
                var btn_name = btn.name;
                var btn_text = btn.text;
                for (var k = 0; k < records.length; k++) {
                    var jsjd_id = records[k].get("ID");
                    ids.push(jsjd_id);
                }

                $.post("delXmjdfbInfo.action", {
                    ids: Ext.util.JSON.encode(ids),
                    xmzx_type: xmzx_type,
                    btn_name: btn_name,
                    btn_text: btn_text
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

    /**
     * 工作流变更
     */
    function doWorkFlow(btn) {
        var  records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length <= 0) {
            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
            return;
        }
        var ids = [];
        var grids=[];
        for (var i in records) {
            ids.push(records[i].get("ID"));
        }
        Ext.each(records, function (record) {
            var array = {};
            array.AD_CODE = record.get("AD_CODE");
            array.AG_ID = record.get("AG_ID");
            array.AG_NAME = record.get("AG_NAME");
            array.BUILD_STATUS_ID=record.get("BUILD_STATUS_ID");
            array.BUILD_STATUS_NAME=record.get("BUILD_STATUS_NAME");
            array.ID=record.get("ID");
            array.IS_RZXM=record.get("IS_RZXM");
            array.JHYT=record.get("JHYT");
            array.JSXZ_ID=record.get("JSXZ_ID");
            array.JSXZ_NAME=record.get("JSXZ_NAME");
            array.LX_YEAR=record.get("LX_YEAR");
            array.REMARK=record.get("REMARK");
            array.RO=record.get("RO");
            array.XMLX_ID=record.get("XMLX_ID");
            array.XMLX_NAME=record.get("XMLX_NAME");
            array.XMXZ_ID=record.get("XMXZ_ID");
            array.XMXZ_NAME=record.get("XMXZ_NAME");
            array.XMZGS_AMT=record.get("XMZGS_AMT");
            array.XM_CODE=record.get("XM_CODE");
            array.XM_ID=record.get("XM_ID");
            array.XM_NAME=record.get("XM_NAME");
            array.ZJDW_AMT=record.get("ZJDW_AMT");
            array.ZJDW_DATE=record.get("ZJDW_DATE");
            array.ZJ_TYPE=record.get("ZJ_TYPE");
            grids.push(array);
        });
        button_name = btn.text;
        if (btn.text == '送审' || btn.text == '撤销送审') {
            Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("doXmzxWorkFlow.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        xmzx_type: xmzx_type,
                        audit_info: '',
                        ids: ids,
                        grids:Ext.util.JSON.encode(grids)
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！" + (data.message ? data.message : ''),
                                closable: false, align: 't', slideInDuration: 400, minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.show({
                                title: '提示',
                                msg: button_name + '失败！' + (data.message ? data.message : ''),
                                minWidth: 300,
                                buttons: Ext.Msg.OK,
                                fn: function (btn) {
                                }
                            });
                        }
                        //刷新表格
                        reloadGrid();
                    }, "json");
                }
            });
        } else {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text + '意见',
                value: btn.text == '审核' ? '同意' : '',
                animateTarget: btn,
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("doXmzxWorkFlow.action", {
                            workflow_direction: btn.name,
                            wf_id: wf_id,
                            node_code: node_code,
                            button_name: button_name,
                            xmzx_type: xmzx_type,
                            audit_info: text,
                            ids: ids,
                            grids:Ext.util.JSON.encode(grids)
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_name + "成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
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

    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid() {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        store.removeAll();
        var xmxz_search = Ext.ComponentQuery.query('treecombobox[itemId="XMXZ_ID"]')[0].getValue();
        var xmlx_search = Ext.ComponentQuery.query('treecombobox[itemId="XMLX_ID"]')[0].getValue();
        var xm_search = Ext.ComponentQuery.query('textfield[itemId="MHCX"]')[0].getValue();
        store.getProxy().extraParams = {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            wf_id: wf_id,
            node_code: node_code,
            xmzx_type: xmzx_type,
            button_name: button_name,
            WF_STATUS: WF_STATUS,
            XMXZ_SEARCH: xmxz_search,
            XMLX_SEARCH: xmlx_search,
            XM_SEARCH: xm_search,
            node_type:node_type,
            dwRoleType:dwRoleType //20210521 fzd 增加单位角色类型
        };
        //刷新
        store.loadPage(1);
    }

    /**
     * 操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            var contentGrid_ID = records[0].get("ID");
            fuc_getWorkFlowLog(contentGrid_ID);
    }
    }

    /**
     * 20210629liyue
     * 创建专项债券收入缴库弹出框选择项目的还本付息计划
     */
    function window_Xmzx_XmDfjhSelect(btn) {
        var window = Ext.create('Ext.window.Window', {
            title: '专项债券还本付息计划', // 窗口标题
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.9, //自适应窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'xmDfjh_sel', // 窗口标识
            name:'xmDfjh_window',
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',
            /* closeAction: 'hide', //close 关闭  hide  隐藏*/
            items: [init_xmDfjhGrid(btn)],
            buttons: [
                {
                    text: '确定',
                    handler: function (btn) {
                        var win_xm_sel = Ext.ComponentQuery.query('window[itemId="xmDfjh_sel"]');//项目选择窗口
                        if (win_xm_sel != null && win_xm_sel != undefined) {  //项目选择窗口存在
                            var grid = DSYGrid.getGrid('grid_select');
                            var record = grid.getSelectionModel().getSelection();
                            if (record.length !=1) {     //未选择项目20210713LIYUE 工单bug解决，只能选择一条数据
                                Ext.toast({
                                    html: "请选择一条数据后再进行操作!",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            } else {
                                    btn.busiId = GUID.createGUID(); //生成主表单ID
                                    btn.editable = true;
                                    window_xmzxtb.show(btn);
                                    var xmzxFormRecords = record[0].getData();
                                    var url='/page/debt/common/xmyhs.jsp';
                                    var paramNames=new Array();
                                    paramNames[0]="XM_ID";
                                    paramNames[1]="IS_RZXM";
                                    var paramValues=new Array();
                                    paramValues[0]=encodeURIComponent(xmzxFormRecords.XM_ID);
                                    paramValues[1]=encodeURIComponent(xmzxFormRecords.IS_RZXM);
                                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+xmzxFormRecords.XM_NAME+'</a>';
                                    xmzxFormRecords.XM_NAME = result;
                                    var xmjdfbForm = Ext.ComponentQuery.query('form#xmzx_form')[0];
                                    xmjdfbForm.getForm().setValues(xmzxFormRecords);
                                    btn.up('window').close();
                            }
                        }
                    }
                },
                {
                    text: '关闭',
                    /*   hidden:xmzx_type=="zjzt"?true:false,*/
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });

        window.show();
        return window;
    }
    /**
     * 初始化兑付计划选择
     */
    function init_xmDfjhGrid(params) {
        var headerJson = [
            //{xtype: 'rownumberer', width: 40},20210804liyue去除宅男项债券收入缴库，录取项目前序列号
            {text: "区划名称", dataIndex: "AD_NAME", type: "string" ,width: 100},
            {text: "单位名称", dataIndex: "AG_NAME", type: "string" ,width: 300},
            {text: "项目编码", dataIndex: "XM_CODE", type: "string" ,width: 150},
            {
                dataIndex: "XM_NAME", width: 300, type: "string", text: "项目名称",
                renderer: function (data, cell, record) {
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
            },
            {text: "兑付计划id", dataIndex: "DF_PLAN_ID", type: "string", hidden: true},
            {text: "债券id", dataIndex: "ZQ_ID", type: "string", hidden: true},
            {text: "到期日期", dataIndex: "DF_END_DATE", type: "string", width: 150},
            {text: "应还款日期", dataIndex: "DQ_DATE", type: "string", width: 150},
            {text: "还款类型", dataIndex: "PLAN_TYPE_NAME", type: "string", width: 100},
            {text: "还款计划总额（元）", dataIndex: "PLAN_AMT", type: "float", width: 150},
            {text: "剩余应还金额（元）", dataIndex: "SY_AMT", type: "float", width: 150},
            {text: "剩余兑付费金额（元）", dataIndex: "SY_DFF_AMT", type: "float", width: 180},
            {text: "债券编码", dataIndex: "ZQ_CODE", type: "string", width: 150},
            {text: "债券类型code", dataIndex:"ZQLB_CODE", width: 150, type:'string',hidden:true},
            {text: "债券类型", dataIndex: "ZQLB_NAME", type: "string", width: 200},
            {text: "债券批次", dataIndex: "ZQ_PC_ID", type: "string", width: 150},
            {text: "债券期限", dataIndex: "ZQQX_NAME", type: "string", width: 150},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 350,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('ZQ_ID');
                    paramValues[1]=AD_CODE;
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "利率", dataIndex: "PM_RATE", type: "float", hidden: true},
            {text: "兑付手续费率（‰）", dataIndex: "DFSXF_RATE", type: "float", hidden: true},
            {text: "实际发行额", dataIndex: "FX_AMT", type: "float", hidden: true},
            {text: "发行日", dataIndex: "FX_START_DATE", type: "string", hidden: true},
            {text: "招标日期", dataIndex: "ZB_DATE", type: "string", hidden: true},
            {text: "起息日", dataIndex: "QX_DATE", type: "string", hidden: true},
            {text: "到期兑付日", dataIndex: "DQDF_DATE", type: "string", hidden: true},
            {text: "付息周期", dataIndex: "FXZQ_NAME", type: "string", hidden: true},
            {text: "兑付计划编码", dataIndex: "PLAN_TYPE", type: "string", hidden: true},
            {text: "偿还资金来源ID", dataIndex: "ZJLY_ID", type: "string", hidden: true}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'grid_select',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            border: false,
            height: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            tbar: [
                {
                    xtype: "combobox",
                    name: "HKJH_YEAR",
                    store: DebtEleStore(json_debt_year),
                    displayField: "name",
                    value: new Date().getFullYear(),
                    valueField: "id",
                    fieldLabel: '到期年月',
                    editable: false, //禁用编辑
                    labelWidth: 70,
                    width: 175
                },
                {
                    xtype: "combobox",
                    name: "HKJH_MO",
                    store: DebtEleStore(json_debt_yf_nd),
                    displayField: "name",
                    valueField: "id",
                    value: lpad(1 + new Date().getUTCMonth(), 2),
                    editable: false, //禁用编辑
                    width: 85
                },
                /*新增债券类型，债券批次查询条件开始*/
                {
                    xtype: 'treecombobox',
                    name: 'ZQLB_ID',
                    labelAlign: 'right',
                    store: DebtEleTreeStoreDB('DEBT_ZQLB',{condition: " AND CODE LIKE  '02%'"}),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券类型',
                    editable: false, //禁用编辑
                    labelWidth: 60,
                    width: 180
                },
                {
                    xtype: 'combobox',
                    name: 'ZQPC_ID',
                    labelAlign: 'right',
                    store: DebtEleStoreDB('DEBT_ZQPC'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券批次',
                    editable: false, //禁用编辑
                    labelWidth: 60,
                    width: 195
                },
                /*新增债券类型，债券批次查询条件结束*/
                {
                    xtype: "textfield",
                    name: "ZQMC",
                    labelAlign: 'right',
                    fieldLabel: '模糊查询',
                    labelWidth: 60,
                    width: 220,
                    emptyText: '债券名称/债券编码',
                    editable: true,
                    enableKeyEvents: true,
                    listeners: {
                        keypress: function (self, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                var DQ_YEAR = Ext.ComponentQuery.query('combobox[name="HKJH_YEAR"]')[0].value;
                                var DQ_MO = Ext.ComponentQuery.query('combobox[name="HKJH_MO"]')[0].value;
                                var ZQMC = Ext.ComponentQuery.query('textfield[name="ZQMC"]')[0].value;
                                var ZQLB_ID = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].value;
                                var ZQPC_ID = Ext.ComponentQuery.query('combobox[name="ZQPC_ID"]')[0].value;
                                //刷新表格数据
                                var store = self.up('window').down('grid').getStore();
                                store.getProxy().extraParams = {
                                    DQ_YEAR: DQ_YEAR,
                                    DQ_MO: DQ_MO,
                                    SELECT_YQ: SELECT_YQ,
                                    IS_KKDF:IS_KKDF,
                                    ZQMC: ZQMC,
                                    ZQLB_ID: ZQLB_ID,
                                    ZQPC_ID: ZQPC_ID
                                };
                                store.loadPage(1);
                            }
                        }
                    }
                },
                {
                    xtype: 'button',
                    style: {marginRight: '20px'},
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        //var DQTS = Ext.ComponentQuery.query('textfield[name="dqts"]')[0].value;
                        var DQ_YEAR = Ext.ComponentQuery.query('combobox[name="HKJH_YEAR"]')[0].value;
                        var DQ_MO = Ext.ComponentQuery.query('combobox[name="HKJH_MO"]')[0].value;
                        var ZQMC = Ext.ComponentQuery.query('textfield[name="ZQMC"]')[0].value;
                        var ZQLB_ID = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].value;
                        var ZQPC_ID = Ext.ComponentQuery.query('combobox[name="ZQPC_ID"]')[0].value;
                        //刷新表格数据
                        var store = btn.up('window').down('grid').getStore();
                        store.getProxy().extraParams = {
                            DQ_YEAR: DQ_YEAR,
                            DQ_MO: DQ_MO,
                            ZQMC: ZQMC,
                            ZQLB_ID: ZQLB_ID,
                            ZQPC_ID: ZQPC_ID,
                            dwRoleType:dwRoleType
                        };
                        store.loadPage(1);
                    }
                }
            ],
            params: {
                DQ_YEAR: new Date().getFullYear(),
                DQ_MO: lpad(1 + new Date().getUTCMonth(), 2),
                ZQLB_ID: "",
                ZQPC_ID: "",
                SELECT_YQ: 0,
                IS_KKDF: 0,
                dwRoleType:dwRoleType,
                AG_CODE:AG_CODE,
                url_xm_id:url_xm_id
            },
            dataUrl: 'getDwZqxmHbfx.action'
        });
        //20210805 fzd 查询时提示数据异常信息
        grid.getStore().on('load', function (data) {
            if(data.proxy.reader.rawData.success==false){
                Ext.MessageBox.alert('提示', data.proxy.reader.rawData.message);
            }
        });
        return grid;
    }
    //取当前月时 长度为1时左侧补0
    function lpad(num, n) {
        return (Array(n).join(0) + num).slice(-n);
    }

</script>
</body>
</html>
