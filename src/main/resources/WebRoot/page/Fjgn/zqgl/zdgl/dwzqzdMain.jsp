<%--
  Created by IntelliJ IDEA.
  User: fzd
  Date: 2018/12/24
  Time: 11:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>单位债券转贷</title>
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
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script src="dwzqzdzzlr.js"></script>
<script type="text/javascript">
    var IS_EDIT=1;
    var userCode = "${sessionScope.USERCODE}";
    var AD_CODE = "${sessionScope.ADCODE}".replace(/00$/, "");
   /* var wf_id = getUrlParam("wf_id");//当前流程id
    var node_code = getUrlParam("node_code");//当前节点id*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var button_name = '';//当前操作按钮名称
    var button_text = '';
  /*  var menucode = getQueryParam("menucode");
    var WF_STATUS = getUrlParam("WF_STATUS");//当前状态
    var IS_REDUCE = getUrlParam("is_reduce");*/
    var menucode ="${fns:getParamValue('menucode')}";
    var IS_REDUCE ="${fns:getParamValue('is_reduce')}";
    var minValue = IS_REDUCE == '1' ? null : 0;
    var maxValue = IS_REDUCE == '1' ? 0 : null;
/*
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var debuggers=true;
/*
    var df_plan_id = getUrlParam("df_plan_id");
*/
    var df_plan_id ="${fns:getParamValue('df_plan_id')}";
    var is_fix=false;
    //全局变量
    var set_year = '';
    var zqlx_code = '';
    var grid_error_message = '';
    var SYS_IS_QEHBFX = '';
    var IS_FTDFF_CHECKED = 1;
    var IS_CREATEJH_BY_AUDIT = 0;
    var DF_START_DATE_TEMP = null ;
    var DF_END_DATE_TEMP = null ;
/*
    var menucode = getQueryParam("menucode");
*/
    var menucode ="${fns:getParamValue('menucode')}";
    var IS_BZB = '${fns:getSysParam("IS_BZB")}';// 系统参数：是否标准版
    // 获取系统参数值
    var IS_CREATE_FKMDFJH = '${fns:getSysParam("IS_CREATE_FKMDFJH")}'; // 是否生成分科目兑付计划： 0 不生成、1 生成

    /*$.post("getParamValueAll.action", function (data) {
        data = eval(data);
        IS_FTDFF_CHECKED = data[0].IS_FTDFF_CHECKED;
        IS_CREATEJH_BY_AUDIT = data[0].IS_CREATEJH_BY_AUDIT;
    });*/

    is_zrz=false;
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        $.post("getParamValueAll.action", function (data) {
            SYS_IS_QEHBFX = data[0].SYS_IS_QEHBFX;
            IS_FTDFF_CHECKED = data[0].IS_FTDFF_CHECKED;
            IS_CREATEJH_BY_AUDIT = data[0].IS_CREATEJH_BY_AUDIT;
            initContent();
        },"json");
        if (zdhk_json_common[wf_id][node_code].callBack) {
            zdhk_json_common[wf_id][node_code].callBack();
        }

    });
    //提前获取以下store，弹出框中使用，表格中使用
    /**
     * 通用配置json
     */
    var zdhk_json_common = {
        100231: {//债券转贷及还款管理
            1: {//自治区债券转贷录入
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
                            name: 'btn_insert',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                is_fix=false;
                                button_name = btn.name;
                                button_text=btn.text;
                                //alert(button_name);
                                window_select.show();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                    return;
                                }
                                is_fix=true;

                                //修改全局变量的值
                                button_name = btn.name;
                                button_text=btn.text;
                                var dwzdgrid = records[0].getData();
                                DF_START_DATE_TEMP=dwzdgrid.DF_START_DATE;
                                DF_END_DATE_TEMP=dwzdgrid.DF_END_DATE;
                                window_input.HZ_ID = records[0].get('HZ_ID');
                                window_input.show();
                                var form = Ext.ComponentQuery.query('form#form_zqzd_form')[0].getForm();//找到该form
                                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                                var paramNames = new Array();
                                paramNames[0] = "ZQ_ID";
                                paramNames[1] = "AD_CODE";
                                var paramValues = new Array();
                                paramValues[0] = encodeURIComponent(dwzdgrid.ZQ_ID);
                                paramValues[1] = encodeURIComponent(dwzdgrid.AD_CODE.replace(/00$/, ""));
                                var zq_name = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + dwzdgrid.ZQ_NAME + '</a>';
                                dwzdgrid.ZQ_NAME = zq_name;
                                form.setValues(dwzdgrid);//将记录中的数据写进form表中
                                //补充数据
                                DSYGrid.getGrid('zqzd_grid').getStore().getProxy().extraParams['HZ_ID'] = records[0].data["HZ_ID"];
                                DSYGrid.getGrid('zqzd_grid').getStore().loadPage(1);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_del',
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
                                        button_name = btn.name;
                                        button_text=btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("HZ_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/delDwZdglMain.action", {
                                            ids: ids,
                                            wf_id: wf_id,
                                            node_code: node_code,
                                            button_name: button_name,
                                            wf_status: WF_STATUS
                                        }, function (data) {
                                            if (data.success) {
                                                Ext.toast({
                                                    html: button_text + "成功！",
                                                    closable: false,
                                                    align: 't',
                                                    slideInDuration: 400,
                                                    minWidth: 400
                                                });
                                            } else {
                                                Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                                            }
                                            //刷新表格
                                            window_input.HZ_ID='';
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
                                dooperation();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '主债录入',
                            name: 'btn_insert',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                button_name = btn.name;
                                button_text=btn.text;
                                window_zzlrselect.show();
                            }
                        },
                        /*{
                            xtype:'button',
                            text:'模板下载',
                            icon:'/image/sysbutton/download.png',
                            handler:function () {
                                downloadZDTemplate ();
                            }
                        },*/
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
                            handler: function () {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                    return;
                                }
                                is_fix=true;

                                //修改全局变量的值
                                button_name = btn.name;
                                button_text=btn.text;
                                window_input.HZ_ID = records[0].get('HZ_ID');
                                window_input.show();
                                var dwzdgrid = records[0].getData();
                                var form = Ext.ComponentQuery.query('form#form_zqzd_form')[0].getForm();//找到该form
                                var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                                var paramNames = new Array();
                                paramNames[0] = "ZQ_ID";
                                paramNames[1] = "AD_CODE";
                                var paramValues = new Array();
                                paramValues[0] = encodeURIComponent(dwzdgrid.ZQ_ID);
                                paramValues[1] = encodeURIComponent(dwzdgrid.AD_CODE.replace(/00$/, ""));
                                var zq_name = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + dwzdgrid.ZQ_NAME + '</a>';
                                dwzdgrid.ZQ_NAME = zq_name;
                                form.setValues(dwzdgrid);//将记录中的数据写进form表中
                                //补充数据
                                DSYGrid.getGrid('zqzd_grid').getStore().getProxy().extraParams['HZ_ID'] = records[0].data["HZ_ID"];
                                DSYGrid.getGrid('zqzd_grid').getStore().loadPage(1);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_del',
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
                                        button_name = btn.name;
                                        button_text=btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("HZ_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/delDwZdglMain.action", {
                                            ids: ids,
                                            wf_id: wf_id,
                                            node_code: node_code,
                                            button_name: button_name,
                                            wf_status: WF_STATUS
                                        }, function (data) {
                                            if (data.success) {
                                                Ext.toast({
                                                    html: button_text + "成功！",
                                                    closable: false,
                                                    align: 't',
                                                    slideInDuration: 400,
                                                    minWidth: 400
                                                });
                                            } else {
                                                Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
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
                    WF_STATUS: DebtEleStore(json_debt_zt6)
                }
            },
            2: {//自治区债券转贷审核
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
                                for (record_seq in records) {
                                    if (records[record_seq].get('IS_QR') == '1' && IS_CREATEJH_BY_AUDIT != '1') {//撤销审核时判断该主单对应明细是否被确认
                                        Ext.Msg.alert('提示', '选择撤销的转贷已被确认，无法撤销！');
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
    //创建转贷信息选择弹出窗口
    var window_select = {
        window: null,
        show: function (params) {
            this.window = initWindow_select(params);
            this.window.show();
        }
    };
    //创建转贷信息填报弹出窗口
    var window_input = {
        window: null,
        zq_code: null,
        HZ_ID:'',
        show: function () {
            this.window = initWindow_input();
            this.window.show();
        }
    };
    /**
     * 通用函数：获取url中的参数
     */
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    }
    /**
     操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            pcjh_id = records[0].get("HZ_ID");
            fuc_getWorkFlowLog(pcjh_id);
        }
    }
    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
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
                    items: zdhk_json_common[wf_id][node_code].items[WF_STATUS],
                    listeners: {
                        beforerender: function (self,eOpts){
                            if (!(SYS_IS_QEHBFX==0)) {
                                var items = self.items.items;
                                Ext.each(items, function (item) {
                                    if (item.text == '模板下载') {
                                        item.hide();
                                    }
                                });
                            }
                        }
                    }
                }
            ],
            items: [
                initContentGrid(),
                initContentDetilGrid()
            ]
        });
    }
    /**
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                dataIndex: "HZ_ID",
                type: "string",
                text: "虚拟主单id",
                width: 130,
                hidden:true
            },
            {
                dataIndex: "ZQ_ID",
                type: "string",
                text: "债券ID",
                hidden:true
            },
            {
                dataIndex: "AD_CODE",
                type: "string",
                text: "区划",
                hidden:true
            },
            {
                dataIndex: "ZQ_CODE",
                type: "string",
                text: "债券编码",
                width: 130
            },
            {
                dataIndex: "ZQ_NAME",
                type: "string",
                width: 250,
                text: "债券名称",
                renderer: function (data, cell, record) {
                    /* var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZQ_ID') + '&AD_CODE=' + AD_CODE;
                     return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                    paramValues[1]=encodeURIComponent(AD_CODE);
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {
                dataIndex: "ZQQX_NAME",
                width: 100,
                type: "string",
                text: "债券期限"
            },
            {
                dataIndex: "ZQLB_NAME",
                type: "string",
                text: "债券类型",
                width: 130
            },
            {
                dataIndex: "FX_AMT",
                width: 150,
                type: "float",
                text: "债券金额(元)"
            },
            {
                dataIndex: "HZ_DATE",
                width: 100,
                type: "string",
                text: "转贷日期"
            },
            {
                dataIndex: "START_DATE",
                width: 100,
                type: "string",
                text: "起息日期"
            },
            {
                dataIndex: "DF_START_DATE",
                width: 100,
                type: "string",
                text: "兑付起始日期",
                hidden:true
            },
            {
                dataIndex: "DF_END_DATE",
                width: 100,
                type: "string",
                text: "兑付截止日期",
                hidden:true
            },
            {
                dataIndex: "HZ_AMT",
                width: 150,
                type: "float",
                text: "转贷金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HZ_XZZQ_AMT",
                width: 150,
                type: "float",
                text: "其中新增债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HZ_ZHZQ_AMT",
                width: 150,
                type: "float",
                text: "置换债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HZ_ZRZZQ_AMT",
                width: 150,
                type: "float",
                text: "再融资债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "TQHK_DAYS",
                width: 150,
                type: "int",
                text: "提前还款天数"
            },
            {
                dataIndex: "KZDJE",
                width: 150,
                type: "int",
                text: "可转贷金额",
                hidden:true
            },
            {
                dataIndex: "KZD_XZ",
                width: 150,
                type: "int",
                text: "可转贷新增",
                hidden:true
            },
            {
                dataIndex: "KZD_ZH",
                width: 150,
                type: "int",
                text: "可转贷置换",
                hidden:true
            },
            {
                dataIndex: "KZD_ZRZ",
                width: 150,
                type: "int",
                text: "可转贷再融资",
                hidden:true
            }
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
                SET_YEAR: ''
            },
            dataUrl: 'getDwZdglMainGridData.action',
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: zdhk_json_common[wf_id][node_code].store['WF_STATUS'],
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
                            toolbar.add(zdhk_json_common[wf_id][node_code].items[WF_STATUS]);
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = WF_STATUS;
                            reloadGrid();
                        }
                    }
                },
                {
                    xtype: "combobox",
                    name: "SET_YEAR",
                    store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2009'"}),
                    displayField: "name",
                    valueField: "id",
                    value: '',
                    fieldLabel: '年度',
                    editable: false, //禁用编辑
                    labelWidth: 40,
                    width: 150,
                    labelAlign: 'right',
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格


                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            reloadGrid();
                        }
                    }
                },
                {
                    xtype: "treecombobox",
                    name: "ZQLB_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券类型',
                    editable: false, //禁用编辑
                    labelWidth: 70,
                    width: 200,
                    labelAlign: 'right',
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            reloadGrid();
                        }
                    }
                }
            ],
            tbarHeight: 50,
            pageConfig: {
                pageNum: true//设置显示每页条数
            },
            features: [{
                ftype: 'summary'
            }],
            listeners: {
                itemclick: function (self, record) {
                    var filePanel = Ext.ComponentQuery.query('#zqzd_mx_edit')[0].down('#winPanel_tabPanel');
                    if (filePanel) {
                        filePanel.removeAll();
                        filePanel.add(initWin_ckfjGrid({
                            editable: IS_EDIT == 0 ? true : false,
                            busiId: record.get('HZ_ID')
                        }));
                    }
                    //刷新附件
                    DSYGrid.getGrid('winPanel_tabPanel').getStore().getProxy().extraParams['HZ_ID'] = record.get('HZ_ID');
                    DSYGrid.getGrid('winPanel_tabPanel').getStore().getProxy().extraParams['HZ_ID'] = record.get('HZ_ID');
                    DSYGrid.getGrid('winPanel_tabPanel').getStore().load();
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['HZ_ID'] = record.get('HZ_ID');
                    DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
                }
            }
        });
    }
    /**
     * 初始化明细表格
     */
    function initContentDetilGrid(callback) {
        return Ext.create('Ext.tab.Panel',{//下面是个tabpanel
            layout:'fit',
            itemId:'zqzd_mx_edit',
            flex: 1,
            autoLoad: true,
            height: '50%',
            items:[

                {
                    title:'转贷信息',
                    layout:'fit',
                    items:initzdxxGrid(callback)
                },
                {
                    title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                    layout: 'fit',
                    items: [
                        {
                            xtype: 'panel',
                            layout: 'fit',
                            itemId: 'winPanel_tabPanel',
                            items: [initWin_ckfjGrid({editable: IS_EDIT == 0 ? true : false , busiId: ''})]
                        }
                    ]
                }

            ]
        });


    }
    function initzdxxGrid(callback) {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                dataIndex: "ZQHZ_ID",
                type: "string",
                width: 250,
                text: "明细id",
                hidden:true
            },
            {
                dataIndex: "QYJT_ID",
                type: "string",
                width: 250,
                text: "转贷单位id",
                hidden:true
            },
            {
                dataIndex: "QYJT_NAME",
                type: "string",
                width: 250,
                text: "转贷单位"
            },
            {
                dataIndex: "HZ_AMT",
                width: 150,
                type: "float",
                text: "转贷金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HZ_XZZQ_AMT",
                width: 150,
                type: "float",
                text: "其中新增债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HZ_ZHZQ_AMT",
                width: 150,
                type: "float",
                text: "置换债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HZ_ZRZZQ_AMT",
                width: 150,
                type: "float",
                text: "再融资债券金额",
                summaryType: 'sum',
                summaryRenderer: function (value) {
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
            dataUrl: 'getDwZdglDtlGridData.action'
        };
        if (zdhk_json_common[wf_id][node_code].item_content_detailgrid_config) {
            config = $.extend(false, config, zdhk_json_common[wf_id][node_code].item_content_detailgrid_config);
        }
        var grid = simplyGrid.create(config);
        if (callback) {
            callback(grid);
        }
        return grid;
    }

    //查看附件
    function initWin_ckfjGrid(config) {
        var grid = UploadPanel.createGrid({
            busiType: '',//业务类型
            busiId: config.busiId,//业务ID
            editable: config.editable,//是否可以修改附件内容
            filterParam: 'AD_CODE:' + AD_CODE,
            addHeaders: [{text: "区划", dataIndex: "AD_NAME", type: "string", index: 1}],
            gridConfig: {
                itemId: 'winPanel_tabPanel'
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
            if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
    }
    function initWin_ckfjGrid_mx(config) {
        var a =window_input.HZ_ID;
        var grid = UploadPanel.createGrid({
            busiType: '',//业务类型
            busiId: window_input.HZ_ID,//业务ID
            editable: config.editable,//是否可以修改附件内容
            filterParam: 'AD_CODE:' + AD_CODE,
            addHeaders: [{text: "区划", dataIndex: "AD_NAME", type: "string", index: 1}],
            gridConfig: {
                itemId: 'winPanel_tabPanel_mx'
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
            if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
    }



    var store_BJ_DQZQ;
    var store_DQZQ;
    var store_DQZQ_TEMP;

    Ext.define('treeModel2', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'id',mapping:'ZQ_ID'},
            {name: 'name',mapping:'NAME'},
            {name: 'cd_amt'},
            {name: 'leaf'},
            {name: 'df_end_date'},
            {name: 'dq_amt_sy'},
            {name: 'expanded'}

        ]
    });
    Ext.define('treeModel', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'text'},
            {name: 'code'},
            {name: 'id'},
            {name: 'leaf'}
        ]
    });

    /**
     * 初始化债券选择弹出窗口
     */
    function initWindow_select(params) {
        return Ext.create('Ext.window.Window', {
            title: '债券选择', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'vbox',
            maximizable: true,
            itemId: 'window_select', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWindow_select_grid(params)],//, initWindow_select_grid_dtl()
            buttons: [
                {
                    text: '确认',
                    handler: function (btn) {
                        //获取表格选中数据
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length != 1) {
                            Ext.MessageBox.alert('提示', '请只选择一条数据后再进行操作');
                            return;
                        }
                        var record = records[0].getData();
                        var is_on=1;
                        if(record.PLAN_HB_AMT!=null&&record.PLAN_HB_AMT!=undefined&&record.PLAN_HB_AMT>0) {
                            is_on=1;
                        }else{
                            is_on=0;
                        }
                        DF_START_DATE_TEMP = record.DF_START_DATE;
                        DF_END_DATE_TEMP = record.DF_END_DATE;
                        //弹出填报页面，并写入债券信息
                        var xzGUID =  GUID.createGUID();
                        window_input.zq_code = record.ZQ_CODE;
                        window_input.HZ_ID=xzGUID;
                        window_input.show();
                        //var zq_name = '<a href="/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.ZQ_ID + '&AD_CODE=' + record.AD_CODE.replace(/00$/, "") + '" target="_blank" style="color:#3329ff;">' + record.ZQ_NAME + '</a>';
                        var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                        var paramNames = new Array();
                        paramNames[0] = "ZQ_ID";
                        paramNames[1] = "AD_CODE";
                        var paramValues = new Array();
                        paramValues[0] = encodeURIComponent(record.ZQ_ID);
                        paramValues[1] = encodeURIComponent(record.AD_CODE.replace(/00$/, ""));
                        var zq_name = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + record.ZQ_NAME + '</a>';
                        record.ZQ_NAME = zq_name;
                        // 对form赋值
                        window_input.window.down('form').getForm().setValues(record);
                        // 根据单位申报建设项目信息初始化单位转贷信息
                        $.ajax({
                            type: "POST",
                            url: "/getAutoCreatDwzdInfo.action",
                            data: {
                                ZQ_ID: record.ZQ_ID,
                                HZ_ID: xzGUID
                            },
                            dataType: 'json',
                            success: function (data) {
                                if (data.success) {
                                    //初始化一个空行
                                    window_input.window.down('grid#zqzd_grid').insertData(null, data.list);
                                } else {
                                    Ext.MessageBox.alert('提示', '单位转贷信息无法获取，请检查是否存在建设项目！' + data.message);
                                }
                            }
                        });

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
     * 初始化债券选择弹出框表格
     */
    function initWindow_select_grid(params) {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                "dataIndex": "ZQ_ID",
                "type": "string",
                "text": "债券ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            },
            {
                "dataIndex": "ZQ_CODE",
                "type": "string",
                "text": "债券编码",
                "fontSize": "15px",
                "width": 120
            },
            {
                "dataIndex": "ZQ_NAME",
                "type": "string",
                "width": 300,
                "text": "债券名称",
                "hrefType": "combo",
                renderer: function (data, cell, record) {
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('ZQ_ID'));
                    paramValues[1]=encodeURIComponent(AD_CODE);
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {
                "dataIndex": "ZQQX_NAME",
                "width": 100,
                "type": "string",
                "text": "债券期限"
            },
            {
                "dataIndex": "ZQLB_NAME",
                "type": "string",
                "text": "债券类型",
                "fontSize": "15px",
                "width": 100
            },
            {
                "dataIndex": "DF_START_DATE",
                "width": 100,
                "type": "string",
                "text": "兑付起息日",
                //hidden: true
            },
            {
                "dataIndex": "DF_END_DATE",
                "width": 100,
                "type": "string",
                "text": "兑付截止日",
                //hidden: true
            },
            {
                "dataIndex": "ZQJE", "text": "可转贷金额（元）",
                columns: [
                    {
                        "dataIndex": "KZD_XZ",
                        "width": 150,
                        "type": "float",
                        "align": 'right',
                        "text": "新增债券金额"
                    },
                    {
                        "dataIndex": "KZD_ZH",
                        "width": 150,
                        "type": "float",
                        "align": 'right',
                        "text": "置换债券金额"
                    },
                    {
                        "dataIndex": "KZD_ZRZ",
                        "width": 150,
                        "type": "float",
                        "align": 'right',
                        "text": "再融资债券金额"
                    }
                ]
            },
            {
                "dataIndex": "YZD", "text": "债券金额（元）",
                columns: [
                    {
                        "dataIndex": "ZXZ_AMT",
                        "width": 150,
                        "type": "float",
                        "align": 'right',
                        "text": "新增债券金额"
                    },
                    {
                        "dataIndex": "ZZH_AMT",
                        "width": 150,
                        "type": "float",
                        "align": 'right',
                        "text": "置换债券金额"
                    },
                    {
                        "dataIndex": "ZZRZ_AMT",
                        "width": 150,
                        "type": "float",
                        "align": 'right',
                        "text": "再融资债券金额"
                    }
                ]
            }
        ];
        var simplyGrid = new DSYGridV2();
        return simplyGrid.create({
            itemId: 'grid_select',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            selModel: {
                mode: "SINGLE"     //s是否多选，默认多选,"SINGLE"/"SIMPLE"/"MULTI"
            },
            //checkBox: true,
            border: false,
            width: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            tbar: [
                {
                    xtype: "combobox",
                    name: "SET_YEAR",
                    store: DebtEleStore(json_debt_year),
                    displayField: "name",
                    valueField: "id",
                    value: new Date().getFullYear(),
                    fieldLabel: '债券发行年度',
                    editable: false, //禁用编辑
                    labelWidth: 100,
                    width: 220,
                    labelAlign: 'right',
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                },
                {
                    xtype: "treecombobox",
                    name: "ZQLB_ID",
                    store: DebtEleTreeStoreDB('DEBT_ZQLB'),
                    displayField: "name",
                    valueField: "id",
                    fieldLabel: '债券类型',
                    editable: false , //禁用编辑
                    labelWidth: 70,
                    width: 210,
                    labelAlign: 'right',
                    listeners: {
                        change: function (self, newValue) {
                            //刷新当前表格
                            self.up('grid').getStore().getProxy().extraParams[self.getName()] = newValue;
                            self.up('grid').getStore().loadPage(1);
                        }
                    }
                },
                {
                    xtype: "textfield",
                    name: "mhcx",
                    id: "mhcx",
                    fieldLabel: '模糊查询',
                    allowBlank: true,  // requires a non-empty value
                    labelWidth: 70,
                    width: 260,
                    labelAlign: 'right',
                    emptyText: '请输入债券名称/债券编码...',
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
            params: {
                SET_YEAR: new Date().getFullYear()
            },
            /*listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    var store = DSYGrid.getGrid('grid_select_dtl').getStore();
                    store.getProxy().extraParams['ZQ_ID'] = record.get('ZQ_ID');
                    store.load();
                }
            },*/
            dataUrl: 'getdwZqxxGridData.action'
        });
    }

    /**
     * 已转贷地区、金额
     */


    function initWindow_select_grid_dtl() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {
                "dataIndex": "AD_NAME",
                "type": "string",
                "text": "已转贷地区",
                "fontSize": "15px",
                "width": 110
            },
            {
                "dataIndex": "ZD_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "已转贷金额(元)",
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00');
                }, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "ZD_XZ_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "其中新增债券金额",
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00');
                }, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "ZD_ZH_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "置换债券金额",
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00');
                }, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex":"ZD_HB_AMT",
                "width":150,
                "type":"float",
                "align":"right",
                "text":"再融资债券金额",
                renderer : function(value, metaData, record){
                    if(record.data.REMARK.indexOf('在途') >= 0){
                        metaData.css = 'x-grid-back-green';
                    }
                    return Ext.util.Format.number(value, '0,000.00');
                },
                summaryType:'sum',
                summaryRenderer: function (value){
                    return Ext.util.Format.number(value, '0,000.00') ;
                }
            },
            {
                "dataIndex": "CDBJ_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "承担本金金额",
                hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00');
                }, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                "dataIndex": "CDLX_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "承担利息本金金额",
                hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('【在途】') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00');
                }, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "REMARK", width: 90, type: "string", text: "备注"}
        ];
        var simplyGrid = new DSYGridV2();
        return simplyGrid.create({
            itemId: 'grid_select_dtl',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            border: false,
            autoLoad: false,
            width: '100%',
            flex: 0.7,
            pageConfig: {
                enablePage: false
            },
            tbarHeight: 50,
            params: {
                AD_CODE: AD_CODE
            },
            features: [{
                ftype: 'summary'
            }],
            dataUrl: 'getYzdGridData.action'
        });
    }
    /**
     * 初始化债券转贷弹出窗口
     */
    function   initWindow_input() {
        return Ext.create('Ext.window.Window', {
            title: '债券转贷', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            maximizable: true,
            itemId: 'window_input', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: initWindow_input_contentForm(),
            buttons: [
                {
                    xtype: 'hidden',//button
                    text: '按计划生成',
                    width: 80,
                    handler: function (btn) {
                        var store = btn.up('window').down('grid').getStore();
                        if (store.getCount() > 0) {
                            Ext.Msg.confirm('提示', '此操作将会清空已录入数据，确认按计划生成？', function (btn_confirm) {
                                if (btn_confirm === 'yes') {
                                    store.load({
                                        callback: function () {
                                            if (store.getCount() <= 0) {
                                                Ext.Msg.alert('提示', '未找到批次转贷计划，请手动添加！');
                                            }
                                        }
                                    });
                                }
                            });
                        } else {
                            store.load({
                                callback: function () {
                                    if (store.getCount() <= 0) {
                                        Ext.Msg.alert('提示', '未找到批次转贷计划，请手动添加！');
                                    }
                                }
                            });
                        }
                    }
                },
                new Ext.form.FormPanel({
                    labelWidth: 70,
                    fileUpload: true,
                    items: [
                        /*{
                            xtype: 'filefield',
                            buttonText: '导入',
                            name: 'upload',
                            width: 140,
                            hidden: !(SYS_IS_QEHBFX == 0),
                            padding: '0 0 0 0',
                            margin: '0 0 0 0',
                            buttonOnly: true,
                            hideLabel: true,
                            buttonConfig: {
                                width: 140,
                                icon: '/image/sysbutton/report.png'
                            },
                            listeners: {
                                change: function (fb, v) {
                                    var store = Ext.ComponentQuery.query('grid#zqzd_grid')[0].getStore();
                                    store.removeAll();
                                    var form = this.up('form').getForm();
                                    uploadZdmxExcelFile(form);
                                }
                            }
                        }*/
                    ]
                }),
                {
                    xtype: 'button',
                    text: '自动生成',
                    hidden : IS_BZB == 0,
                    width: 60,
                    handler: function (btn) {
                        $.ajax({
                            type: "POST",
                            url: "/getAutoCreatDwzdInfo.action",
                            data: {
                                ZQ_ID: btn.up('window').down('form').down('[name=ZQ_ID]').getValue(),
                                HZ_ID: btn.up('window').down('form').down('[name=HZ_ID]').getValue()
                            },
                            dataType: 'json',
                            success: function (data) {
                                if (data.success) {
                                    btn.up('window').down('grid').getStore().removeAll();
                                    btn.up('window').down('grid').insertData(null, data.list);
                                } else {
                                    Ext.MessageBox.alert('提示', '生成失败：' + data.message);
                                }
                            }
                        });

                    }
                },
                {
                    xtype: 'button',
                    text: '添加',
                    width: 60,
                    handler: function (btn) {
                        btn.up('window').down('grid').insertData(null, {IS_QEHBFX: 1});
                    }
                },
                {
                    xtype: 'button',
                    itemId: 'tzjhDelBtn',
                    text: '删除',
                    width: 60,
                    disabled: true,
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
                    handler: function (btn) {
                        // btn.setDisabled(true) ;  //防止点击两次按钮保存两天数据，按钮不可点击
                        //获取grid
                        var grid = btn.up('window').down('#zqzd_grid');
                        var celledit = grid.getPlugin('zqzd_grid_plugin_cell');
                        //完成编辑
                        celledit.completeEdit();
                        //先校验后保存
                        if (window.flag_zzqZd_validateedit && !window.flag_zzqZd_validateedit.isHidden()) {
                            return false;//如果校验未通过
                        }
                        var form = btn.up('window').down('form');
                        if (!checkGrid(form.down('grid'))) {
                            Ext.Msg.alert('提示', grid_error_message);
                            //btn.setDisabled(false);
                            return false;
                        }
                        //获取单据明细数组
                        var recordArray = [];
                        var HZ_ID=form.getForm().findField("HZ_ID").getValue();//
                        HZ_ID=HZ_ID==""?GUID.createGUID():HZ_ID;
                        var ZQ_ID=form.getForm().findField("ZQ_ID").getValue();//债券id
                        var ZD_DATE=form.getForm().findField("ZD_DATE").getValue();//转贷日期
                        var QX_DATE =form.getForm().findField('START_DATE').getValue();//起息日
                        var TQHK_DAYS=form.getForm().findField("TQHK_DAYS").getValue();//提前还款天数
                        var ZQ_CODE=form.getForm().findField("ZQ_CODE").getValue();//债券编码
                        var START_DATE=form.getForm().findField("START_DATE").getValue();//起息日期
                        //var df_plan_id=form.getForm().findField("DF_PLAN_ID").getValue();//兑付计划id
                        var zdDateFormat = Ext.Date.format(ZD_DATE,"Y-m-d");
                        var qxDateFormat = Ext.Date.format(QX_DATE,'Y-m-d');
                        var FHZ_ID=window_input.HZ_ID;//20210425LIYUE 解决单位转贷录入被退回这状态下修改主键id为空问题
                        if(zdDateFormat<qxDateFormat){
                            Ext.Msg.alert('提示',"债券转贷日期不能小于债券起息日！");
                            return false;
                        }
                        for(var m=0;m<form.down('grid').getStore().getCount();m++){
                            var record = form.down('grid').getStore().getAt(m);
                            recordArray.push(record.data);
                        }
                        var parameters = {
                            wf_id: wf_id,
                            zd_level: '0',
                            ZQ_ID:ZQ_ID,
                            ZD_DATE:ZD_DATE,
                            TQHK_DAYS:TQHK_DAYS,
                            zq_code: ZQ_CODE,
                            FHZ_ID:FHZ_ID,
                            //DF_PLAN_ID:df_plan_id,
                            node_code: node_code,
                            button_name: button_name,
                            button_text: button_text,
                            menucode:menucode,
                            detailList: Ext.util.JSON.encode(recordArray),
                        };
                        if (button_text == '修改') {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            parameters.ZD_ID = records[0].get('ZD_ID');
                        }
                        if (form.isValid()) {
                            //保存表单数据及明细数据
                            form.submit({
                                //设置表单提交的url
                                url: 'savedwZdxxGrid.action',
                                params: parameters,
                                success: function (form, action) {
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
                                    window_input.HZ_ID='';
                                    reloadGrid();
                                },
                                failure: function (form, action) {
                                    var result = Ext.util.JSON.decode(action.response.responseText);
                                    Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                                    // btn.setDisabled(false);
                                }
                            });
                        } else {
                            Ext.Msg.alert('提示', '请检查必填项！');
                        }
                    }
                },
                {
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        });
    }
    /**
     * 导入excel
     */
    function uploadZdmxExcelFile(form) {
        var url = 'importExcel.action';//"IS_READY":"IS_READY", "AD_NAME":"转贷区域名",
        var excelHeader = '{"AD_CODE":"转贷区域编码", "AD_NAME":"转贷区域名称", "XZ_AMT":"新增债券金额(元)", "ZH_AMT":"置换债券金额(元)", "HB_AMT":"再融资债券金额(元)", "ZDXY_NO":"转贷协议号","REMARK":"备注"}';
        form.submit({
            url: url,
            params: {
                excelHeader: excelHeader
            },
            waitTitle: '请等待',
            waitMsg: '正在导入中...',
            success: function (form, action) {
                var columnStore = action.result.data.list;
                for (var i = 0; i < columnStore.length; i++) {
                    columnStore[i].IS_READY = 0;
                    columnStore[i].IS_QEHBFX = 1;
                    columnStore[i].IS_IMPORT = 1;
                    columnStore[i].CDBJ_AMT = parseFloat(columnStore[i].XZ_AMT) + parseFloat(columnStore[i].ZH_AMT);
                    columnStore[i].CDLX_AMT = parseFloat(columnStore[i].XZ_AMT) + parseFloat(columnStore[i].ZH_AMT);
                }
                ;
                var grid = DSYGrid.getGrid('zqzd_grid');
                grid.insertData(null, columnStore);
                grid.getStore().sort([{
                    property: 'AD_CODE',
                    direction: 'ASC'
                }
                ]);
            },
            failure: function (resp, action) {
                var msg = action.result.data.message;
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '导入失败:' + msg,
                    width: 200,
                    fn: function (btn) {
                    }
                });
            }
        });

    }
    /**
     * 初始化债券转贷表单
     */
    function initWindow_input_contentForm() {
        return Ext.create('Ext.form.Panel', {
            itemId: 'form_zqzd_form',
            name:"form_zqzd_form",
            width: '100%',
            height: '100%',
            layout: 'vbox',
            fileUpload: true,
            padding: '2 5 0 5',
            border: false,
            defaults: {
                width: '100%'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        //width: 280,
//                            disabled:true,
                        readOnly: true,
                        labelWidth: 160//控件默认标签宽度
                    },
                    items: [
                        {
                            fieldLabel: "虚拟主单",
                            name: "HZ_ID",
                            xtype: "textfield",
                            readOnly: true,
                            editable: false,
                            hidden: true
                        },
                        /*{
                            fieldLabel: "兑付id",
                            name: "DF_PLAN_ID",
                            xtype: "textfield",
                            readOnly: true,
                            editable: false,
                            hidden: true
                        },*/
                        {
                            dataIndex: "ZQ_CODE",
                            type: "string",
                            text: "债券编码",
                            hidden: true,
                            width: 130
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '债券ID',
                            disabled: false,
                            name: "ZQ_ID",
                            hidden: debuggers,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "displayfield",
                            fieldLabel: '债券名称',
                            name: "ZQ_NAME",
                            tdCls: 'grid-cell-unedit'
                            //columnWidth: 0.66
                        },
                        {
                            xtype: "combobox",
                            name: "ZQLB_ID",
                            store: DebtEleStore(json_debt_zqlx2),
                            displayField: "name",
                            valueField: "id",
                            fieldLabel: '债券类型',
                            editable: false, //禁用编辑
                            listeners: {
                                change: function (self, newValue) {
                                    // bond_type_id = newValue;
                                    //reloadGrid();
                                }
                            },
                            hidden:false,
                            readOnly: true,
                            //disabled: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KZDJE",
                            fieldLabel: '剩余可转贷金额（元）',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            //disabled: true,
                            fieldStyle: 'background:#E6E6E6'

                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KZDJEadd",
                            fieldLabel: '剩余可转贷金额增加',
                            emptyText: '0.00',
                            hidden:true,
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            listeners:{
                                'change':function(me, newValue, oldValue, eOpts){
                                    /*if(button_text=="修改"){
                                        return;
                                    }*/
                                    var form = me.up('window').down('form');
                                    var amt=newValue-oldValue;
                                    var kzdje_amt=form.down('numberFieldFormat[name="KZDJE"]').getValue();
                                    if(kzdje_amt!=null&&kzdje_amt!=""){
                                        kzdje_amt-=amt;
                                    }
                                    form.down('numberFieldFormat[name="KZDJE"]').setValue(kzdje_amt);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KZD_XZ",
                            fieldLabel: '其中新增债券金额（元）',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            //disabled: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KZD_XZadd",
                            fieldLabel: '剩余新增金额增加',
                            emptyText: '0.00',
                            hidden:true,
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            listeners:{
                                'change':function(me, newValue, oldValue, eOpts){
                                    /*if(button_text=="修改"){
                                        return;
                                    }*/
                                    var form = me.up('window').down('form');
                                    var amt=newValue-oldValue;
                                    var kzdje_amt=form.down('numberFieldFormat[name="KZD_XZ"]').getValue();
                                    // 20210313 guoyf 可转贷金额不为0，再计算金额
                                    if(kzdje_amt != 0){
                                        kzdje_amt=kzdje_amt-amt;
                                        form.down('numberFieldFormat[name="KZD_XZ"]').setValue(kzdje_amt);
                                        var sykzdje_zh_amt=form.down('numberFieldFormat[name="KZD_ZH"]').getValue();
                                        var sykzdje_zrz_amt=form.down('numberFieldFormat[name="KZD_ZRZ"]').getValue();
                                        var sykzdje_xz_amt=form.down('numberFieldFormat[name="KZD_XZ"]').getValue();
                                        form.down('numberFieldFormat[name="KZDJE"]').setValue(sykzdje_xz_amt+sykzdje_zrz_amt+sykzdje_zh_amt);
                                    }
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KZD_ZH",
                            fieldLabel: '其中置换债券金额（元）',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            //disabled: true,
                            fieldStyle: 'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KZD_ZHadd",
                            fieldLabel: '剩余置换金额增加',
                            emptyText: '0.00',
                            hidden:true,
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            listeners:{
                                'change':function(me, newValue, oldValue, eOpts){
                                    /*if(button_text=="修改"){
                                        return;
                                    }*/
                                    var form = me.up('window').down('form');
                                    var amt=newValue-oldValue;
                                    var kzdje_amt=form.down('numberFieldFormat[name="KZD_ZH"]').getValue();
                                    kzdje_amt=kzdje_amt-amt;
                                    form.down('numberFieldFormat[name="KZD_ZH"]').setValue(kzdje_amt);
                                    var sykzdje_zh_amt=form.down('numberFieldFormat[name="KZD_ZH"]').getValue();
                                    var sykzdje_zrz_amt=form.down('numberFieldFormat[name="KZD_ZRZ"]').getValue();
                                    var sykzdje_xz_amt=form.down('numberFieldFormat[name="KZD_XZ"]').getValue();
                                    form.down('numberFieldFormat[name="KZDJE"]').setValue(sykzdje_xz_amt+sykzdje_zrz_amt+sykzdje_zh_amt);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "KZD_ZRZ",
                            fieldLabel: "其中再融资债券金额（元）",
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            fieldStyle: 'background:#E6E6E6'
                        },{
                            xtype: "numberFieldFormat",
                            name: "KZD_ZRZadd",
                            fieldLabel: '剩余再融资金额增加',
                            emptyText: '0.00',
                            hidden:true,
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            listeners:{
                                'change':function(me, newValue, oldValue, eOpts){
                                    if(button_text=="修改"){
                                        return;
                                    }
                                    var form = me.up('window').down('form');
                                    var amt=newValue-oldValue;
                                    var kzdje_amt=form.down('numberFieldFormat[name="KZD_ZRZ"]').getValue();
                                    kzdje_amt=kzdje_amt-amt;
                                    form.down('numberFieldFormat[name="KZD_ZRZ"]').setValue(kzdje_amt);
                                    var sykzdje_zh_amt=form.down('numberFieldFormat[name="KZD_ZH"]').getValue();
                                    var sykzdje_zrz_amt=form.down('numberFieldFormat[name="KZD_ZRZ"]').getValue();
                                    var sykzdje_xz_amt=form.down('numberFieldFormat[name="KZD_XZ"]').getValue();
                                    form.down('numberFieldFormat[name="KZDJE"]').setValue(sykzdje_xz_amt+sykzdje_zrz_amt+sykzdje_zh_amt);
                                }
                            }
                        }
                    ]
                },
                {//分割线
                    xtype: 'menuseparator',
                    margin: '2 0 2 0',
                    border: true
                },
                {
                    xtype: 'container',
                    layout: 'column',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        //width: 280,
                        labelWidth: 160,//控件默认标签宽度
                        allowBlank: true
                    },
                    items: [
                        {
                            xtype: "datefield",
                            name: "ZD_DATE",
                            fieldLabel: '<span class="required">✶</span>转贷日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            blankText: '请选择转贷日期',
                            value: new Date()
                        },
                        {
                            xtype: "datefield",
                            name: "START_DATE",
                            fieldLabel: '<span class="required">✶</span>起息日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            blankText: '请选择起息日期',
                            editable:false,
                            value: DF_START_DATE_TEMP,
                            maxValue: DF_END_DATE_TEMP ,
                            minValue: DF_START_DATE_TEMP
                        },
                        {
                            xtype: "numberfield",
                            name: "TQHK_DAYS",
                            fieldLabel: '提前还款天数',
                            minValue: 0,
                            maxValue: 99
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZNJ_RATE",
                            fieldLabel: '滞纳金率(万分之)',
                            emptyText: '0.000000',
                            minValue: 0,
                            allowDecimals: true,
                            allowBlank: false,
                            decimalPrecision: 6,
                            hideTrigger: true/*,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})*/
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    title: '转贷明细',
                    flex: 1,
                    layout: 'fit',
                    items: [initContentAddGrid()]
                }
            ]
        });
    }
    /**
     * 初始化债券转贷表单中转贷明细信息表格
     */


    function initContentAddGrid(callback) {
        return Ext.create('Ext.tab.Panel',{//下面是个tabpanel
            layout:'fit',
            itemId:'zqzd_mx_edit',
            flex: 1,
            autoLoad: true,
            height: '50%',
            items:[

                {
                    title:'转贷信息',
                    layout:'fit',
                    items:initWindow_input_contentForm_grid()
                },
                {
                    title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                    layout: 'fit',
                    items: [
                        {
                            xtype: 'panel',
                            layout: 'fit',
                            itemId: 'winPanel_tabPanel',
                            items: [initWin_ckfjGrid_mx({editable: true , busiId: window_input.HZ_ID})]
                        }
                    ]
                }

            ]
        });

    }
    /**
     * 初始化债券转贷表单中转贷明细信息表格
     */

    function initWindow_input_contentForm_grid() {
        var headerJson = [
            {
                xtype: 'rownumberer', width: 45, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {dataIndex: "IS_READY", type: "string", text: "IS_READY", width: 150, hidden: debuggers},//, hidden: true
            {dataIndex: "IS_IMPORT", type: "string", text: "IS_IMPORT", width: 150, hidden: debuggers},//, hidden: true
            {dataIndex: "ZQHZ_ID", type: "string", text: "明细id", width: 250, hidden: true},
            {dataIndex: "QYJT_NAME", type: "string", text: "转贷单位", width: 250, hidden: debuggers},//, hidden: true
            {
                dataIndex: "QYJT_ID", type: "string", text: "转贷单位", width: 300,editable:false,
                displayField : 'text',
                editor: {//   行政区划动态获取(下拉框)
                    xtype: 'treecombobox',
                    displayField : 'text',
                    valueField : 'id',
                    selectModel: 'leaf',
                    editable:false,
                    value : '',
                    rootVisible : false,
                    store: store_zddw
                },
                tdCls: 'grid-cell',
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
                dataIndex: "IS_QEHBFX", type: "string", text: "是否全额还本付息", width: 150,
                tdCls: 'grid-cell',
                hidden: SYS_IS_QEHBFX == 0,//根据系统参数控制是否支持分摊本息
                renderer: function (value) {
                    var record = DebtEleStore(json_debt_sf).findRecord('id', value, 0, false, true, true);
                    return record != null ? record.get('name') : value;
                },
                editor: {
                    xtype: 'combobox',
                    displayField: 'name',
                    valueField: 'id',
                    editable: false,
                    allowBlank: false,
                    value: 1,
                    store: DebtEleStore(json_debt_sf)
                }
            },
            {
                dataIndex: "HZ_AMT", type: "float", text: "转贷金额(元)", width: 160, tdCls: 'grid-cell-unedit',
                summaryType: 'sum',
                renderer: function (value, cellmeta, record) {
                    value = record.get('HZ_XZZQ_AMT') + record.get('HZ_ZHZQ_AMT') + record.get('HZ_ZRZZQ_AMT');
                    return Ext.util.Format.number(value, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
//                summaryRenderer: function (value) {
//                    return Ext.util.Format.number(value, '0,000.00');
//                }
            },
            {
                dataIndex: "HZ_XZZQ_AMT", type: "float", text: "新增债券金额(元)", width: 160,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: minValue,
                    maxValue: maxValue,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HZ_ZHZQ_AMT", type: "float", text: "置换债券金额(元)", width: 160,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: minValue,
                    maxValue: maxValue,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HZ_ZRZZQ_AMT", type: "float", text: "再融资债券金额(元)", width: 160,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: minValue,
                    maxValue: maxValue,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {dataIndex: "ZDXY_NO", type: "string", text: "转贷协议号", width: 150, editor: 'textfield'},
            {dataIndex: "REMARK", type: "string", text: "备注", width: 150, editor: 'textfield'}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'zqzd_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            dataUrl: 'getDwZdglDtlGridData.action',
            border: true,
            flex: 1,
            height: '100%',
            features: [{
                ftype: 'summary'
            }],
            width: '100%',
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'zqzd_grid_plugin_cell',
                    clicksToMoveEditor: 1,
                }
            ],
            listeners: {
                'beforeedit': function (editor, e) {
//                     20200923_wangjc: 如果当前系统参数IS_CREATE_FKMDFJH：维系（1生成、 0不生成）必须全额转贷
                    if(!!IS_CREATE_FKMDFJH && IS_CREATE_FKMDFJH == '1' && e.field == 'HZ_XZZQ_AMT' ) {
                        return false;
                    }
                }
            },
            pageConfig: {
                enablePage: false
            }
        });
        //用于添加页面中的删除功能
        grid.on('selectionchange', function (view, records) {
            grid.up('window').down('#tzjhDelBtn').setDisabled(!records.length);
        });
        grid.getStore().on('endupdate', function () {
            //计算录入窗口转贷总金额
            var self = grid.getStore();
            var form = grid.up('window').down('form');
            var input_zd_amt = 0;
            var input_xz_amt = 0;
            var input_zh_amt = 0;
            var input_hb_amt = 0;
            self.each(function (record) {
                record.set('HZ_AMT', record.get('HZ_XZZQ_AMT') + record.get('HZ_ZHZQ_AMT') + record.get('HZ_ZRZZQ_AMT'));//总转贷赋值
                input_zd_amt += record.get('HZ_AMT');
                input_xz_amt += record.get('HZ_XZZQ_AMT');
                input_zh_amt += record.get('HZ_ZHZQ_AMT');
                input_hb_amt += record.get('HZ_ZRZZQ_AMT');
            });
            //对form重新赋值
            form.down('numberFieldFormat[name="KZDJEadd"]').setValue(input_zd_amt);
            form.down('numberFieldFormat[name="KZD_XZadd"]').setValue(input_xz_amt);
            form.down('numberFieldFormat[name="KZD_ZHadd"]').setValue(input_zh_amt);
            form.down('numberFieldFormat[name="KZD_ZRZadd"]').setValue(input_hb_amt);
        });
        return grid;
    }

    function loadGridData(editor,e,AD_CODE,DQZQ_ID){
        if(AD_CODE!=null&&AD_CODE!=undefined&&AD_CODE!=""&&DQZQ_ID!=null&&DQZQ_ID!=undefined&&DQZQ_ID!=""){
            $.post("/getDqsyAmtBySelectId.action", {
                AD_CODE:AD_CODE,
                DQZQ_ID:DQZQ_ID
            }, function (data) {
                if(data!=null&&data!=undefined){
                    e.record.set("CHDQZQSYJE",data.dataList.DQ_AMT_SY);
                }
            }, "json");
        }
    }



    /**
     * validateedit 表格编辑插件校验
     */
    function checkEditorGrid(editor, context) {
//        if (context.field == 'AD_CODE') {
//            var newValue = context.value;
//            var flag = true;
//            var curRecord = DSYGrid.getGrid('zqzd_grid').getSelection();
//            if (curRecord[0].getData().AD_CODE == newValue) {//如果操作的仍是当前单元格，数据相同不触发校验
//                return flag;
//            }
//            context.grid.getStore().each(function (record) {
//                if (newValue == record.get('AD_CODE')) {
//                    flag = false;
//                    window.flag_zzqZd_validateedit = Ext.Msg.alert('提示', '编辑项区划重复！');
//                    return false;
//                }
//            });
//            return flag;
//        }
    }
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
        var inputList = new Array();
        for(var k in records){
            inputList.push({"ID":records[k].get("HZ_ID")});
        }
        button_name = btn.name;
        button_text=btn.text;
        if (button_text == '送审') {
            Ext.Msg.confirm('提示', '请确认是否' + button_text + '!', function (btn_confirm) {
                if (btn_confirm === 'yes') {
                    //发送ajax请求，修改节点信息
                    $.post("/doWorkFlowfordwhz.action", {
                        wf_id: wf_id,
                        node_code: node_code,
                        btn_name: button_name,
                        btn_text:button_text,
                        menucode:menucode,
                        AD_CODE:AD_CODE,
                        audit_info: '',
                        TEXT:"",
                        inputList: Ext.util.JSON.encode(inputList)
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_text + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        } else {
                            Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
                        }
                        //刷新表格
                        reloadGrid();
                    }, "json");
                }
            });
        } else {
            //弹出意见填写对话框
            initWindow_opinion({
                title: btn.text,
                animateTarget: btn,
                value: btn.name == 'up' ? null : '同意',
                fn: function (buttonId, text) {
                    if (buttonId === 'ok') {
                        //发送ajax请求，修改节点信息
                        $.post("/doWorkFlowfordwhz.action", {
                            wf_id: wf_id,
                            node_code: node_code,
                            btn_name: button_name,
                            btn_text:button_text,
                            menucode:menucode,
                            AD_CODE:AD_CODE,
                            audit_info: '',
                            TEXT:text,
                            inputList: Ext.util.JSON.encode(inputList)
                        }, function (data) {
                            if (data.success) {
                                Ext.toast({
                                    html: button_text + "成功！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                            } else {
                                Ext.MessageBox.alert('提示', button_text + '失败！' + data.message);
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
    /*刷新主界面*/
    function reloadGrid(param, param_detail) {
        if (!(SYS_IS_QEHBFX==0)) {
            var items = Ext.ComponentQuery.query('#contentPanel_toolbar')[0].items.items;
            Ext.each(items, function (item) {
                if (item.text == '模板下载') {
                    item.hide();
                }
            });
        }
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();

        var filePanel = Ext.ComponentQuery.query('#zqzd_mx_edit')[0].down('#winPanel_tabPanel');
        if (filePanel) {
            filePanel.removeAll();
            filePanel.add(initWin_ckfjGrid({
                editable: IS_EDIT == 0 ? true : false,
                busiId: window_input.HZ_ID
            }));
        }
        //刷新附件
        DSYGrid.getGrid('winPanel_tabPanel').getStore().getProxy().extraParams['HZ_ID'] = window_input.HZ_ID;
        DSYGrid.getGrid('winPanel_tabPanel').getStore().getProxy().extraParams['HZ_ID'] =window_input.HZ_ID;
        DSYGrid.getGrid('winPanel_tabPanel').getStore().load();
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
            var HZ_ID=DSYGrid.getGrid('contentGrid');
            store_details.getProxy().extraParams = {
                HZ_ID: HZ_ID
            };
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
    }
    /**
     *保存时校验表格数据
     */
    function checkGrid(grid) {
        var flag = true;
        var checkAg = {};
        var form = grid.up('form');
        if (form.down('numberFieldFormat[name="KZDJE"]').getValue() < 0 ||
            form.down('numberFieldFormat[name="KZD_XZ"]').getValue() < 0 ||
            form.down('numberFieldFormat[name="KZD_ZH"]').getValue() < 0 ||
            form.down('numberFieldFormat[name="KZD_ZRZ"]').getValue() < 0
        ) {
            grid_error_message = '转贷金额超过债券可转贷额度！';
            flag = false;
            return flag;
        }
        if(grid.getStore().getCount()==0){
            grid_error_message = '请添加转贷信息！';
            flag = false;
            return flag;
        }
        grid.getStore().each(function (record) {
            if (record.get('HZ_AMT') == 0 ) {
                grid_error_message = '转贷金额合计不能为零！';
                flag = false;
                return flag;
            }
            if (record.get('QYJT_ID') == '' || record.get('QYJT_ID') == null) {
                grid_error_message = '转贷单位为空！';
                flag = false;
                return flag;
            }
            if (record.get('ZDXY_NO') == '' || record.get('ZDXY_NO') == null) {
                grid_error_message = '转贷协议号为空！';
                flag = false;
                return flag;
            }
            if (typeof checkAg[record.get('QYJT_ID')] != 'undefined' && checkAg[record.get('QYJT_ID')] != null && checkAg[record.get('QYJT_ID')]) {
                grid_error_message = '重复的转贷单位！';
                flag = false;
                return flag;
            } else {
                checkAg[record.get('QYJT_ID')] = true;
            }
        });
        return flag;
    }
    /**
     * 表格中树下拉store
     */
    var store_zddw = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: '/dwzd_reflct.action?method=getZddwTreeStore',
            extraParams: {
                AD_CODE:AD_CODE
            },
            reader: {
                type: 'json'
            }
        },
//        root:'nodelist' ,
        root: {
            expanded: true,
            text: "全部",
            children: [
                {text: "单位", id:"单位", leaf: true}
            ]
        },
        model: 'treeModel',
        autoLoad: true
    });


    /*     var grid_tree_store = Ext.create('Ext.data.TreeStore', {//下拉树store
     proxy: {
     type: 'ajax',
     method: 'POST',
     url: 'getRegTreeDataByCode.action',
     extraParams: {
     AD_CODE: AD_CODE
     },
     reader: {
     type: 'json'
     }
     },
     root: 'nodelist',
     autoLoad: true
     }); */

    /**
     * 模板下载
     */
    function downloadZDTemplate () {
        window.location.href = 'downloadZdtemplate.action?file_name='+encodeURI(encodeURI("债券转贷导入模板.xlsx"));
    }
</script>
</body>
</html>