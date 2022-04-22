<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>地市债券转贷主界面</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }
        .grid-cell {
            background-color: #ffe850;
        }
        .x-grid-back-green {
            background: #00ff00;
        }
        .grid-cell-unedit {
            background-color:#E6E6E6;
        }
        span.required {
            color: red;
            font-size: 100%;
        }
    </style>

</head>
<body>
<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/js/debt/Map.js"></script>
<!--基础数据集-->
<script type="text/javascript" src="/page/debt/zqgl/data/ele_data.js"></script>
<script type="text/javascript">
    // 获取系统参数值
    var IS_CREATE_FKMDFJH = '${fns:getSysParam("IS_CREATE_FKMDFJH")}'; // 是否生成分科目兑付计划： 0 不生成、1 生成
    //附件是否可以编辑  0 可以编辑  1 不可编辑
    var IS_EDIT=1;
  /*  var wf_id = getUrlParam("wf_id");//当前流程id
    var node_code = getUrlParam("node_code");//当前节点id*/
    var wf_id ="${fns:getParamValue('wf_id')}";
    var node_code ="${fns:getParamValue('node_code')}";
    var button_name = '';//当前操作按钮名称
  /*  var WF_STATUS = getUrlParam("WF_STATUS");//当前状态
    var IS_REDUCE = getUrlParam("is_reduce");*/
    var WF_STATUS ="${fns:getParamValue('WF_STATUS')}";
    var IS_REDUCE ="${fns:getParamValue('is_reduce')}";
    var minValue = IS_REDUCE == '1'? null : 0;
    var maxValue = IS_REDUCE == '1'? 0 : null;
  /*  if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    if (isNull(WF_STATUS)) {
        WF_STATUS = '001';
    }
    var userCode='${sessionScope.USERCODE}';
    var is_fix=false;
    var is_zrz=false;
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/,"");
    var IS_BZB = '${fns:getSysParam("IS_BZB")}';// 系统参数：是否标准版
    var SYS_IS_QEHBFX = '';
    var IS_FTDFF_CHECKED = 1;
    var IS_CREATEJH_BY_AUDIT = 0 ;
    var DF_START_DATE_TEMP = null ;
    var DF_END_DATE_TEMP = null ;
    var ZQ_ID = '';
    var ADID = '';
    var zdMap = new Map();
    var zd_level = '1'
    /*$.post("getParamValueAll.action", function (data) {
        data = eval(data);
        IS_FTDFF_CHECKED = data[0].IS_FTDFF_CHECKED;  
        IS_CREATEJH_BY_AUDIT = data[0].IS_CREATEJH_BY_AUDIT ;
    });*/
    //区分录入新增债券、置换和再融资债券转贷信息
    //0：不区分；1：录入新增债券；2：录入置换和再融资数据
/*
    var is_xzzd = getUrlParam("is_xzzd");
*/    var is_xzzd ="${fns:getParamValue('is_xzzd')}";
    if(typeof is_xzzd == 'undefined' || null==is_xzzd){
        is_xzzd = '0';
    }
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
            IS_CREATEJH_BY_AUDIT = data[0].IS_CREATEJH_BY_AUDIT ;
            initContent();
        },"json");
        if (zdhk_json_common[wf_id][node_code].callBack) {
            zdhk_json_common[wf_id][node_code].callBack();
        }
    });

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
    Ext.define('treeModel3', {
        extend: 'Ext.data.Model',
        fields: [
            {name: 'id',mapping:'DQZQ_ID'},
            {name: 'name',mapping:'ZQ_NAME'},
            {name: 'leaf'},
            {name: 'expanded'}

        ]
    });
    var store_DQZQ;
    var debuggers=true;
    var store_DQZQ_TEMP;
    //    $.post("/getDqzqGridData.action?AD_CODE="+AD_CODE+"&FLAG=BJ", function (data_response) {
    //        data_response = $.parseJSON(data_response);
    //        for(var i=0;i<data_response.length;i++){
    //            var $temp=data_response[i];
    //            for(var j in $temp){
    //                if(j=='LEAF'){
    //                    $temp['leaf']=true;
    //                    $temp['zq_name']=$temp['ZQ_NAME']
    //                }
    //                if(j=="EXPANDED"){
    //                    $temp['expanded']=false;
    //                }
    //            }
    //        }
    //        store_DQZQ_TEMP = Ext.create('Ext.data.TreeStore', {
    //            model: 'treeModel2',
    //            proxy: {
    //                type: 'ajax',
    //                method: 'POST',
    //                url: "/getDqzqGridData.action?AD_CODE="+AD_CODE+"&FLAG=BJ",
    //                reader: {
    //                    type: 'json'
    //                }
    //            },
    //            root: {
    //                expanded: true,
    //                text: "全部债券",
    //                children: data_response
    //            },
    //            autoLoad: false
    //        });
    //    });
    //全局变量
    //提前获取以下store，弹出框中使用，表格中使用
    /**
     * 通用配置json
     */
    var zdhk_json_common = {
        100235: {//债券转贷及还款管理
            1: {//地市债券转贷录入
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function() {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '主债录入',
                            name: 'btn_insert',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                is_fix=false;
                                button_name = btn.text;
                                window_select1.show();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '录入',
                            name: 'btn_insert',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                button_name = btn.text;
                                is_fix=false;
                                window_select.show();
                                zd_zq_id="";
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                zd_zq_id="";
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                    return;
                                }
                                is_fix=true;
                                //修改全局变量的值
                                button_name = btn.text;
                                window_input.zq_code = records[0].get('ZQ_CODE');
                                zd_zq_id=records[0].get("ZQ_ID");
                                var zd_id = records[0].get('ZD_ID');
                                //发送ajax请求，查询主表和明细表数据
                                $.post("/getZdxxByZdId.action", {
                                    ZD_ID: records[0].get('ZD_ID'),
                                    ZQ_ID: records[0].get('ZQ_ID'),
                                    AD_CODE: AD_CODE
                                }, function (data) {
                                    if (data.success) {
                                        IS_NEW = data.data.is_new;
                                        // 插入值
                                        zdMap.clear();
                                        for (var index in data.list) {
                                            if(data.list[index].XZ_AMT > 0){
                                                zdMap.put(data.list[index].AD_CODE,data.list[index]);
                                            }
                                        }
                                    }else{
                                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        return;
                                    }
                                    $.post("/getDqzqGridData.action?SJ_AD_CODE="+AD_CODE+"&FLAG=SJBJ&XZ_ZQ_ID="+data.data.ZQ_ID, function (data_response) {
                                        data_response = $.parseJSON(data_response);
                                        for(var i=0;i<data_response.length;i++){
                                            var $temp=data_response[i];
                                            for(var j in $temp){
                                                if(j=='LEAF'){
                                                    $temp['leaf']=true;
                                                }
                                                if(j=="EXPANDED"){
                                                    $temp['expanded']=false;
                                                }
                                            }
                                        }
                                        store_DQZQ = Ext.create('Ext.data.TreeStore', {
                                            model: 'treeModel3',
                                            proxy: {
                                                type: 'ajax',
                                                method: 'POST',
                                                url: "/getDqzqGridData.action?SJ_AD_CODE="+AD_CODE+"&FLAG=SJBJ",
                                                reader: {
                                                    type: 'json'
                                                }
                                            },
                                            root: {
                                                expanded: true,
                                                text: "全部债券",
                                                children: data_response
                                            },
                                            autoLoad: false
                                        });

                                        //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                        DF_START_DATE_TEMP = data.data.QX_DATE ;
                                        DF_END_DATE_TEMP = data.data.DQDF_DATE ;

                                        // data.data.SY_HB_AMT2=data.data.SY_HB_AMT;
                                        data.data.SY_AMT=data.data.SY_AMT+data.data.BJ_HKZQ_AMT;
                                        data.data.SY_HB_AMT=data.data.SY_HB_AMT+data.data.BJ_HKZQ_AMT;
                                        is_zrz=false;
                                        if(data.data.PLAN_HB_AMT!=null&&data.data.PLAN_HB_AMT!=undefined&&data.data.PLAN_HB_AMT>0){
                                            is_zrz=true;
                                        }
                                        window_input.show(zd_id);
                                        var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                                        var paramNames=new Array();
                                        paramNames[0]="ZQ_ID";
                                        paramNames[1]="AD_CODE";
                                        zd_zq_id=data.data.ZQ_ID;
                                        var paramValues=new Array();
                                        paramValues[0]=encodeURIComponent(data.data.ZQ_ID);
                                        paramValues[1]=encodeURIComponent(AD_CODE);
                                        var zq_name='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+ data.data.ZQ_NAME+'</a>';
                                        data.data.ZQ_NAME = zq_name ;
                                        window_input.window.down('form').down('checkbox[name="is_ftdff"]').setValue(data.data.IS_FTDFF != 0);
                                        //window_input.window.down('form').down('checkbox[name="is_ftdff"]').setReadOnly(data.data.IS_FTDFF==0);
                                        if (data.data.IS_FTDFF_P == 0) {
                                            window_input.window.down('form').down('checkbox[name="is_ftdff"]').setReadOnly(true);
                                        } else {
                                            window_input.window.down('form').down('checkbox[name="is_ftdff"]').setReadOnly(data.data.ONLYTHIS > 1);
                                        }
                                        window_input.window.down('form').getForm().setValues(data.data);
                                        window_input.window.down('form').down('grid#zqzd_grid').insertData(null, data.list);
                                        if(!is_zrz){
                                            var CHDQZQ2=window_input.window.down('form').getForm().findField("CHDQZQ2");
                                            if(CHDQZQ2!=null&&CHDQZQ2!=undefined&&CHDQZQ2!=""){
                                                CHDQZQ2.setEditable(false);
                                                CHDQZQ2.setReadOnly(true);
                                            }
                                            var BJ_HKZQ_AMT=window_input.window.down('form').getForm().findField("BJ_HKZQ_AMT");
                                            if(BJ_HKZQ_AMT!=null&&BJ_HKZQ_AMT!=undefined&&BJ_HKZQ_AMT!=""){
                                                BJ_HKZQ_AMT.setEditable(false);
                                                BJ_HKZQ_AMT.setReadOnly(true);
                                            }
                                        }
                                    });
                                }, "json");
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_delete',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                button_name = btn.text;
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length <= 0) {
                                    Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm == 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("ZD_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/deleteFxdfZdhk.action", {
                                            ids: ids,
                                            //start modify by Arno Lee 2016-08-22
                                            wf_id: wf_id,
                                            node_code: node_code,
                                            button_name: button_name,
                                            wf_status: WF_STATUS
                                            //end modify by Arno Lee 2016-08-22
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
                                });
                            }
                        },
                        {
                            xtype: 'button',
                            text: '送审',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.text;
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
                            xtype:'button',
                            text:'模板下载',
                            icon:'/image/sysbutton/download.png',
                            handler:function () {
                                downloadZDTemplate();
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
                            handler: function() {
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
                            handler: function() {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'btn_update',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                zd_zq_id="";
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length != 1) {
                                    Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
                                    return;
                                }
                                is_fix=true;
                                //修改全局变量的值
                                button_name = btn.text;
                                window_input.zq_code = records[0].get('ZQ_CODE');
                                zd_zq_id=records[0].get("ZQ_ID");
                                var zd_id = records[0].get('ZD_ID');
                                //发送ajax请求，查询主表和明细表数据
                                $.post("/getZdxxByZdId.action", {
                                    ZD_ID: records[0].get('ZD_ID'),
                                    ZQ_ID: records[0].get('ZQ_ID'),
                                    AD_CODE: AD_CODE
                                }, function (data) {
                                    if (data.success) {
                                        IS_NEW = data.data.is_new;
                                        // 插入值
                                        zdMap.clear();
                                        for (var index in data.list) {
                                            if(data.list[index].XZ_AMT > 0){
                                                zdMap.put(data.list[index].AD_CODE,data.list[index]);
                                            }
                                        }
                                    }else{
                                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                                        return;
                                    }
                                    $.post("/getDqzqGridData.action?SJ_AD_CODE="+AD_CODE+"&FLAG=SJBJ&XZ_ZQ_ID="+data.data.ZQ_ID, function (data_response) {
                                        data_response = $.parseJSON(data_response);
                                        for(var i=0;i<data_response.length;i++){
                                            var $temp=data_response[i];
                                            for(var j in $temp){
                                                if(j=='LEAF'){
                                                    $temp['leaf']=true;
                                                }
                                                if(j=="EXPANDED"){
                                                    $temp['expanded']=false;
                                                }
                                            }
                                        }
                                        store_DQZQ = Ext.create('Ext.data.TreeStore', {
                                            model: 'treeModel3',
                                            proxy: {
                                                type: 'ajax',
                                                method: 'POST',
                                                url: "/getDqzqGridData.action?SJ_AD_CODE="+AD_CODE+"&FLAG=SJBJ",
                                                reader: {
                                                    type: 'json'
                                                }
                                            },
                                            root: {
                                                expanded: true,
                                                text: "全部债券",
                                                children: data_response
                                            },
                                            autoLoad: false
                                        });

                                        //弹出弹出框，并将主表和明细表数据插入到弹出框form中
                                        DF_START_DATE_TEMP = data.data.QX_DATE ;
                                        DF_END_DATE_TEMP = data.data.DQDF_DATE ;
                                        data.data.SY_AMT=data.data.SY_AMT+data.data.BJ_HKZQ_AMT;
                                        data.data.SY_HB_AMT=data.data.SY_HB_AMT+data.data.BJ_HKZQ_AMT;
                                        is_zrz=false;
                                        if(data.data.PLAN_HB_AMT!=null&&data.data.PLAN_HB_AMT!=undefined&&data.data.PLAN_HB_AMT>0){
                                            is_zrz=true;
                                        }
                                        window_input.show(zd_id);
                                        var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                                        var paramNames=new Array();
                                        paramNames[0]="ZQ_ID";
                                        paramNames[1]="AD_CODE";
                                        zd_zq_id=data.data.ZQ_ID;
                                        var paramValues=new Array();
                                        paramValues[0]=encodeURIComponent(data.data.ZQ_ID);
                                        paramValues[1]=encodeURIComponent(AD_CODE);
                                        var zq_name='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+ data.data.ZQ_NAME+'</a>';
                                        data.data.ZQ_NAME = zq_name ;
                                        window_input.window.down('form').down('checkbox[name="is_ftdff"]').setValue(data.data.IS_FTDFF != 0);
                                        //window_input.window.down('form').down('checkbox[name="is_ftdff"]').setReadOnly(data.data.IS_FTDFF==0);
                                        if (data.data.IS_FTDFF_P == 0) {
                                            window_input.window.down('form').down('checkbox[name="is_ftdff"]').setReadOnly(true);
                                        } else {
                                            window_input.window.down('form').down('checkbox[name="is_ftdff"]').setReadOnly(data.data.ONLYTHIS > 1);
                                        }
                                        window_input.window.down('form').getForm().setValues(data.data);
                                        window_input.window.down('form').down('grid#zqzd_grid').insertData(null, data.list);

                                        if(!is_zrz){
                                            var CHDQZQ2=window_input.window.down('form').getForm().findField("CHDQZQ2");
                                            if(CHDQZQ2!=null&&CHDQZQ2!=undefined&&CHDQZQ2!=""){
                                                CHDQZQ2.setEditable(false);
                                                CHDQZQ2.setReadOnly(true);
                                            }
                                            var BJ_HKZQ_AMT=window_input.window.down('form').getForm().findField("BJ_HKZQ_AMT");
                                            if(BJ_HKZQ_AMT!=null&&BJ_HKZQ_AMT!=undefined&&BJ_HKZQ_AMT!=""){
                                                BJ_HKZQ_AMT.setEditable(false);
                                                BJ_HKZQ_AMT.setReadOnly(true);
                                            }
                                        }
                                    });
                                }, "json");
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            name: 'btn_delete',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                button_name = btn.text;
                                // 检验是否选中数据
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length <= 0) {
                                    Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm == 'yes') {
                                        button_name = btn.text;
                                        var ids = [];
                                        for (var i in records) {
                                            ids.push(records[i].get("ZD_ID"));
                                        }
                                        //发送ajax请求，删除数据
                                        $.post("/deleteFxdfZdhk.action", {
                                            ids: ids,
                                            //start modify by Arno Lee 2016-08-22
                                            wf_id: wf_id,
                                            node_code: node_code,
                                            button_name: button_name,
                                            wf_status: WF_STATUS
                                            //end modify by Arno Lee 2016-08-22
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
                                });
                            }
                        },
                        {
                            xtype: 'button',
                            text: '送审',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.text;
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
                    //start modify by Arno Lee 2016-08-19
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
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt6)
                }
            },
            2: {//地市债券转贷审核
                items: {
                    '001': [
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function() {
                                reloadGrid();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '审核',
                            name: 'down',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                button_name = btn.text;
                                doWorkFlow(btn);
                            }
                        },
                        {
                            xtype: 'button',
                            text: '退回',
                            name: 'up',
                            icon: '/image/sysbutton/back.png',
                            handler: function (btn) {
                                button_name = btn.text;
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
                        }
                    ],
                    '002': [
                        {
                            xtype: 'button',
                            text: '查询',
                            icon: '/image/sysbutton/search.png',
                            handler: function() {
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
                        }
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
        zq_code:null,
        show: function (zd_id) {
            this.window = initWindow_input(zd_id);
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
            {xtype: 'rownumberer',width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }},
            {
                dataIndex: "ZQ_ID",
                type: "string",
                hidden: true,
                text: "债券ID",
                width: 130
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
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+AD_CODE;
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
                dataIndex: "ZD_DATE",
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
                dataIndex: "ZD_ZD_AMT",
                width: 150,
                type: "float",
                text: "转贷金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDBJ_AMT",
                width: 150,
                type: "float",
                hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                text: "承担本金(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDLX_AMT",
                width: 170,
                type: "float",
                hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                text: "承担利息本金金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZD_XZ_AMT",
                width: 170,
                type: "float",
                text: "其中新增债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZD_ZH_AMT",
                width: 150,
                type: "float",
                text: "置换债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZD_HB_AMT",
                width: 150,
                type: "float",
                text: "再融资债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "TQHK_DAYS",
                width: 150,
                type: "int",
                text: "提前还款付息天数"
            },
            {
                dataIndex: "DQZQ_ID",
                type: "string",
                hidden: true,
                text: "到期债券ID",
                width: 130
            },
            {
                dataIndex: "DQZQ_CODE",
                type: "string",
                text: "到期债券编码",
                width: 130
            },
            {
                dataIndex: "DQZQ_NAME",
                type: "string",
                width: 250,
                text: "偿还到期债券名称",
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+AD_CODE;
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('DQZQ_ID'));
                    paramValues[1]=encodeURIComponent(AD_CODE);
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {
                dataIndex: "ZD_HBBJ_AMT",
                width: 150,
                type: "float",
                text: "偿还到期债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "IS_QR",
                width: 150,
                type: "string",
                text: "是否被确认",
                hidden: true
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
                SET_YEAR: '',
                is_xzzd:is_xzzd
            },
            dataUrl: 'getZdglMainGridData.action',
            checkBox: true,
            border: false,
            autoLoad:false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: zdhk_json_common[wf_id][node_code].store['WF_STATUS'],
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
                    store: DebtEleStoreDB('DEBT_YEAR',{condition:" and code >= '2015'"}),
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
                    width: 180,
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
                            busiId: record.get('ZD_ID')
                        }));
                    }
                    //刷新附件
                    DSYGrid.getGrid('winPanel_tabPanel').getStore().getProxy().extraParams['ZD_ID'] = record.get('ZD_ID');
                    DSYGrid.getGrid('winPanel_tabPanel').getStore().getProxy().extraParams['ZD_ID'] = record.get('ZD_ID');
                    DSYGrid.getGrid('winPanel_tabPanel').getStore().load();
                    //刷新明细表
                    DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['ZD_ID'] = record.get('ZD_ID');
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
    /**
     * 初始化明细表格
     */
    function initzdxxGrid(callback) {
        var headerJson = [
            {xtype: 'rownumberer',width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }},
            {
                dataIndex: "ZD_DETAIL_NO",
                type: "string",
                text: "转贷明细编码",
                width: 150,
                hidden: true
            },
            {
                dataIndex: "AD_NAME",
                type: "string",
                width: 250,
                text: "转贷区域"
            },
            {
                dataIndex: "AD_CODE",
                type: "string",
                hidden: true,
                width: 250,
                text: "转贷区域"
            },
            {
                dataIndex: "ZD_AMT",
                width: 150,
                type: "float",
                text: "转贷金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDBJ_AMT",
                width: 150,
                type: "float",
                hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                text: "承担本金(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDLX_AMT",
                width: 170,
                type: "float",
                hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                text: "承担利息本金金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "XZ_AMT",
                width: 170,
                type: "float",
                text: "其中新增债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "ZH_AMT",
                width: 150,
                type: "float",
                text: "置换债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "HB_AMT",
                width: 150,
                type: "float",
                text: "再融资债券金额(元)",
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "DQZQ_ID",
                type: "string",
                text: "债券id",
                width: 130,
                hidden:debuggers
            },
            {
                dataIndex:"DQZQ_NAME",
                width:150,
                type:"string",
                text:"偿还到期债券",
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('FIRST_ZQ_ID') + '&AD_CODE=' + record.get('AD_CODE');
                     return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('DQZQ_ID');
                    paramValues[1]=record.get('AD_CODE');
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
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
            dataUrl: 'getZdglDtlGridData.action'
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
    var zd_zq_id="";
    /**
     * 初始化转贷明细选择弹出窗口
     */
    function initWindow_select(params) {
        return Ext.create('Ext.window.Window', {
            title: '转贷明细选择', // 窗口标题
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'vbox',
            maximizable: true,
            itemId: 'window_select', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWindow_select_grid(params),initWindow_select_grid_dtl()],
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
                        IS_NEW = record.IS_NEW;
                        ZQ_ID = record.ZQ_ID;
                        ADID = record.AD_CODE;
                        $.post("/getDqzqGridData.action?SJ_AD_CODE="+AD_CODE+"&FLAG=SJBJ&XZ_ZQ_ID="+record.ZQ_ID, function (data_response) {
                            data_response = $.parseJSON(data_response);
                            for(var i=0;i<data_response.length;i++){
                                var $temp=data_response[i];
                                for(var j in $temp){
                                    if(j=='LEAF'){
                                        $temp['leaf']=true;
                                    }
                                    if(j=="EXPANDED"){
                                        $temp['expanded']=false;
                                    }
                                }
                            }
                            store_DQZQ = Ext.create('Ext.data.TreeStore', {
                                model: 'treeModel3',
                                proxy: {
                                    type: 'ajax',
                                    method: 'POST',
                                    url: "/getDqzqGridData.action?SJ_AD_CODE="+AD_CODE+"&FLAG=SJBJ",
                                    reader: {
                                        type: 'json'
                                    }
                                },
                                root: {
                                    expanded: true,
                                    text: "全部债券",
                                    children: data_response
                                },
                                autoLoad: false
                            });
                            //弹出填报页面，并写入债券信息
                            record.TQHK_DAYS_P = record.TQHK_DAYS;
                            record.SY_HB_AMT2=record.SY_HB_AMT;
                            window_input.zq_code = record.ZQ_CODE;
                            DF_START_DATE_TEMP = record.DF_START_DATE ;
                            DF_END_DATE_TEMP = record.DF_END_DATE ;

                            is_zrz=false;

                            if(record.PLAN_HB_AMT!=null&&record.PLAN_HB_AMT!=undefined&&record.PLAN_HB_AMT>0){
                                is_zrz=true;
                            }
                            var zd_id = GUID.createGUID();
                            window_input.show(zd_id);
                            //var zq_name = '<a href="/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.ZQ_ID + '&AD_CODE=' + record.AD_CODE.replace(/00$/, "") + '" target="_blank" style="color:#3329ff;">' + record.ZQ_NAME + '</a>';
                            var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                            var paramNames=new Array();
                            paramNames[0]="ZQ_ID";
                            paramNames[1]="AD_CODE";
                            zd_zq_id=record.ZQ_ID;
                            var paramValues=new Array();
                            paramValues[0]=encodeURIComponent(record.ZQ_ID);
                            paramValues[1]=encodeURIComponent(record.AD_CODE.replace(/00$/, ""));
                            var zq_name='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+ record.ZQ_NAME+'</a>';
                            record.ZQ_NAME = zq_name ;
                            window_input.window.down('form').getForm().setValues(record);
                            if(records[0].get('IS_FTDFF') != -1){ //-1为初始值，由系统参数控制状态。否则根据实际转贷情况判断
                                window_input.window.down('form').down('checkbox[name="is_ftdff"]').setValue(records[0].get('IS_FTDFF') != 0);
                                window_input.window.down('form').down('checkbox[name="is_ftdff"]').setReadOnly(true);
                            } else {
                                window_input.window.down('form').down('checkbox[name="is_ftdff"]').setValue(records[0].get('IS_FTDFF_P') != 0);
                                window_input.window.down('form').down('checkbox[name="is_ftdff"]').setReadOnly(records[0].get('IS_FTDFF_P')==0);
                            }
                            //刷新填报弹出中转贷明细表获取转贷计划
                            var store = window_input.window.down('form').down('grid#zqzd_grid').getStore();
                            store.getProxy().extraParams["ZQLB_CODE"] = records[0].get('ZQLB_CODE');
                            store.getProxy().extraParams["ZQ_PC_ID"] = records[0].get('ZQ_PC_ID');
                            store.getProxy().extraParams["FXFS_CODE"] = records[0].get('FXFS_CODE');
                            //store.load();
                            // window_input.window.down('grid#zqzd_grid').insertData(null, {IS_QEHBFX: 1});
                            // 判断是否包含有新增债券，如果包含有新增债券，则自动根据债券发行时对应的各项目及发行金额汇总各地区的债券转贷金额，金额不允许修改。
                            // 如果不包含新增债券，则初始化一个空行
                            if (records[0].get('PLAN_XZ_AMT') > 0) {
                                $.post("getXzzqZdje.action", {
                                        ZQ_ID : encodeURIComponent(record.ZQ_ID),
                                        ADID : encodeURIComponent(record.AD_CODE)
                                    }, function(result) {
                                        result = $.parseJSON(result);
                                        if (result.success) {
                                            // 插入值
                                            zdMap.clear();
                                            for (var index in result.dataList) {
                                                window_input.window.down('grid#zqzd_grid').insertData(null, result.dataList[index]);
                                                zdMap.put(result.dataList[index].AD_CODE,result.dataList[index]);
                                            }
                                        } else {
                                            window_input.window.down('grid#zqzd_grid').insertData(null, {IS_QEHBFX: 1});
                                        }
                                    }
                                );
                            } else {
                                //初始化一个空行
                                window_input.window.down('grid#zqzd_grid').insertData(null, {IS_QEHBFX: 1});
                            }
                            if(!is_zrz){
                                var CHDQZQ2=window_input.window.down('form').getForm().findField("CHDQZQ2");
                                if(CHDQZQ2!=null&&CHDQZQ2!=undefined&&CHDQZQ2!=''){
                                    CHDQZQ2.setEditable(false);
                                    CHDQZQ2.setReadOnly(true);
                                }
                                var BJ_HKZQ_AMT=window_input.window.down('form').getForm().findField("BJ_HKZQ_AMT");
                                if(BJ_HKZQ_AMT!=null&&BJ_HKZQ_AMT!=undefined&&BJ_HKZQ_AMT!=''){
                                    BJ_HKZQ_AMT.setEditable(false);
                                    BJ_HKZQ_AMT.setReadOnly(true);
                                }
                            }
                            btn.up('window').close();

                        });
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
     * 初始化转贷明细选择弹出框表格
     */
    function initWindow_select_grid(params) {
        var headerJson = [
            {xtype: 'rownumberer',width: 35},
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
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+AD_CODE;
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
                "dataIndex": "ZQ_JC",
                "width": 100,
                "type": "string",
                "text": "债券简称"
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
                "dataIndex": "ZQJE","text": "债券金额",
                columns:
                    [
                        {
                            "dataIndex": "PLAN_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "合计"
                        },
                        {
                            "dataIndex": "PLAN_XZ_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中新增债券(元)"
                        },
                        {
                            "dataIndex": "PLAN_ZH_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中置换债券(元)"
                        },
                        {
                            "dataIndex": "PLAN_HB_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中再融资债券(元)"
                        }
                    ]
            },
            {
                "dataIndex": "YZD","text": "已转贷金额",
                columns:
                    [
                        {
                            "dataIndex": "ZD_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "合计"
                        },
                        {
                            "dataIndex": "XZ_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中新增债券(元)"
                        },
                        {
                            "dataIndex": "ZH_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中置换债券(元)"
                        },
                        {
                            "dataIndex": "HB_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中再融资债券(元)"
                        }
                    ]
            },
            {
                "dataIndex": "ZQJE","text": "本级支出金额",
                columns:
                    [
                        {
                            "dataIndex": "PAY_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "合计"
                        },
                        {
                            "dataIndex": "PAY_XZ_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中新增债券(元)"
                        },
                        {
                            "dataIndex": "PAY_ZH_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中置换债券(元)"
                        },
                        {
                            "dataIndex": "PAY_HB_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中再融资债券(元)"
                        }
                    ]
            },
            {
                "dataIndex": "SYKZD","text": "剩余可转贷金额(元)",
                columns:
                    [
                        {
                            "dataIndex": "SY_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "合计"
                        },
                        {
                            "dataIndex": "SY_XZ_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中新增债券(元)"
                        },
                        {
                            "dataIndex": "SY_ZH_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中置换债券(元)"
                        },
                        {
                            "dataIndex": "SY_HB_AMT",
                            "width": 150,
                            "type": "float",
                            "align": 'right',
                            "text": "其中再融资债券(元)"
                        }
                    ]
            },
            {
                "dataIndex": "ZQQX_NAME",
                "width": 100,
                "type": "string",
                "align": 'right',
                "text": "债券期限"
            },
            {
                "dataIndex": "FXZQ_NAME",
                "width": 100,
                "type": "string",
                "text": "付息周期"
            }
        ];
        return DSYGrid.createGrid({
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
                    width: 250,
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
                    editable: false, //禁用编辑
                    labelWidth: 70,
                    width: 180,
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
                        'keydown': function (self, e) {
                            var key = e.getKey();
                            if (key == Ext.EventObject.ENTER) {
                                var win = self.up('window');
                                var mhcx = win.down('textfield[name="mhcx"]').getValue();
                                //刷新表格数据lur
                                var store = self.up('window').down('grid').getStore();
                                store.getProxy().extraParams.mhcx = mhcx;
                                store.loadPage(1);
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
            pageConfig: {
                enablePage: false
            },
            tbarHeight: 50,
            params: {
                SET_YEAR:new Date().getFullYear(),
                is_xzzd:is_xzzd
            },
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                    var store = DSYGrid.getGrid('grid_select_dtl').getStore();
                    store.getProxy().extraParams['ZQ_ID'] = record.get('ZQ_ID');
                    store.load();
                }
            },
            dataUrl: 'getZdxxGridData.action'
        });
    }
    /**
     * 已转贷地区、金额
     */
    function initWindow_select_grid_dtl() {
        var headerJson = [
            {xtype: 'rownumberer',width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }},
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
                "width": 170,
                "type": "float",
                "align": 'right',
                "text": "其中新增债券金额(元)",
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
                "text": "置换债券金额(元)",
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
                "dataIndex": "ZD_HB_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "再融资债券金额(元)",
                renderer: function (value, metaData, record) {
                    if (record.data.REMARK.indexOf('在途') >= 0)
                        metaData.css = 'x-grid-back-green';
                    return Ext.util.Format.number(value, '0,000.00');
                }, summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
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
    function initWindow_input(zd_id) {
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
            items: initWindow_input_contentForm(zd_id),
            buttons: [
                {
                    xtype: 'hidden',//button
                    text: '按计划生成',
                    width: 80,
                    handler: function (btn) {
                        var store = btn.up('window').down('grid').getStore();
                        if(store.getCount() > 0) {
                            Ext.Msg.confirm('提示', '此操作将会清空已录入数据，确认按计划生成？', function (btn_confirm) {
                                if (btn_confirm === 'yes') {
                                    store.load({callback: function() {
                                            if (store.getCount() <= 0) {
                                                Ext.Msg.alert('提示', '未找到批次转贷计划，请手动添加！');
                                            }
                                        }});
                                }
                            });
                        }else {
                            store.load({callback: function() {
                                    if (store.getCount() <= 0) {
                                        Ext.Msg.alert('提示', '未找到批次转贷计划，请手动添加！');
                                    }
                                }});
                        }
                    }
                },
                new Ext.form.FormPanel({
                    labelWidth: 70,
                    fileUpload: true,
                    items: [
                        {
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
                        }
                    ]
                }),
                {
                    xtype: 'button',
                    text: '添加',
                    width: 60,
                    handler: function (btn) {
                        btn.up('window').down('grid').insertData(null, {IS_QEHBFX:1});
                    }
                },
                {
                    xtype: 'button',
                    itemId: 'tzjhDelBtn',
                    text: '删除',
                    width: 60,
                    disabled: true,
                    handler: function (btn) {
                        var form = btn.up('window').down('form');
                        var is_new = form.getForm().findField("IS_NEW").getValue();
                        var grid = btn.up('window').down('grid');
                        var records = grid.getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                            return;
                        }
                        /*if(records[0].get("XZ_AMT") > 0  && is_new == 1){
                            Ext.MessageBox.alert('提示', '该笔转贷信息不允许删除！');
                            return;
                        }*/
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
                        //btn.setDisabled(true) ;  //防止点击两次按钮保存两天数据，按钮不可点击
                        Ext.MessageBox.wait('保存数据中，请等待...','加载数据');
                        var form = btn.up('window').down('form');
                        //获取单据明细数组
                        var recordArray = [];
                        var zd_date = Ext.Date.format(form.getForm().findField("ZD_DATE").getValue(),'Y-m-d');//转贷日期
                        var qx_date = Ext.Date.format(form.getForm().findField("START_DATE").getValue(),'Y-m-d');//起息日
                        var BJ_HKZQ_AMT$temp =form.getForm().findField("BJ_HKZQ_AMT").getValue();
                        var CHDQZQ2$temp =form.getForm().findField("CHDQZQ2").getValue();
                        var CHDQZQ2$temp_rawValue=form.getForm().findField("CHDQZQ2").getRawValue();
                        if(CHDQZQ2$temp_rawValue==null||CHDQZQ2$temp_rawValue==undefined||CHDQZQ2$temp_rawValue==""){
                            CHDQZQ2$temp="";
                            form.getForm().findField("CHDQZQ2").setValue("");
                        }
                        if(zd_date<qx_date){
                            Ext.Msg.alert('提示',"债券转贷日期不能小于债券起息日！");
                            return false;
                        }
                        /*if(BJ_HKZQ_AMT$temp!=null&&BJ_HKZQ_AMT$temp!=undefined&&BJ_HKZQ_AMT$temp>0){
                            if(CHDQZQ2$temp==null||CHDQZQ2$temp==undefined||CHDQZQ2$temp==""){
                                Ext.Msg.alert('提示', "转贷给本级地区的还本金额不能为空或者偿还到期债券不能为空！");
                                //btn.setDisabled(false);
                                return false;
                            }
                        }*/
                        if(is_zrz){
                            if((CHDQZQ2$temp==null||CHDQZQ2$temp==undefined||CHDQZQ2$temp=="")&&(BJ_HKZQ_AMT$temp==null||BJ_HKZQ_AMT$temp==undefined||BJ_HKZQ_AMT$temp<=0)){
                                if (form.down('grid').getStore().getCount() <= 0) {
                                    Ext.Msg.alert('提示', '请填写转贷明细记录！');
                                    return false;
                                }
                            }else if(CHDQZQ2$temp==null||CHDQZQ2$temp==undefined||CHDQZQ2$temp==""){
                                Ext.Msg.alert('提示', '请选择偿还到期债券！');
                                return false;
                            }/*else if(BJ_HKZQ_AMT$temp==null||BJ_HKZQ_AMT$temp==undefined||BJ_HKZQ_AMT$temp<=0){
                                Ext.Msg.alert('提示', '请分配偿还到期债券金额！');
                                return false;
                            }*/
                        }else{
                            if (form.down('grid').getStore().getCount() <= 0) {
                                Ext.Msg.alert('提示', '请填写转贷明细记录！');
                                return false;
                            }
                        }
                        if (!checkGrid(form.down('grid'))) {
                            Ext.Msg.alert('提示', grid_error_message);
                            // btn.setDisabled(false) ;
                            return false;
                        }

                        for(var m=0;m<form.down('grid').getStore().getCount();m++){
                            var record = form.down('grid').getStore().getAt(m);
                            var HB_AMT  = record.get("HB_AMT");
                            var CHDQZQID= record.get("CHDQZQ");
                            var XZ_AMT = record.get("XZ_AMT");
                            var AD_CODE = record.get("AD_CODE");
                            var XZ_SYZD_AMT = record.get("XZ_SYZD_AMT");
                            if((HB_AMT!=null&&HB_AMT!=undefined&&HB_AMT>0)&&
                                (CHDQZQID==null||CHDQZQID==undefined||CHDQZQID=="")) {
                                Ext.Msg.alert('提示', "明细再融资金额和偿还到期债券必须同时有值！");
                                return false;
                            }else{

                            }
                            recordArray.push(record.getData());

                        }
//                        form.down('grid').getStore().each(function (record) {
//                            recordArray.push(record.getData());
//                        });
                        var parameters = {
                            wf_id: wf_id,
                            zd_id: zd_id,
                            node_code: node_code,
                            flag: 'xjbc',
                            zd_level : '1',
                            zq_code :window_input.zq_code,
                            button_name: button_name,
                            detailList: Ext.util.JSON.encode(recordArray),
                            is_fix:is_fix,
                            is_xzzd:is_xzzd
                        };
                        if (button_name == '修改') {
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            parameters.ZD_ID = records[0].get('ZD_ID');
                        }
                        if (form.isValid()) {
                            //保存表单数据及明细数据
                            form.submit({
                                //设置表单提交的url
                                url: 'saveZdxxGrid.action',
                                params: parameters,
                                success: function (form, action) {
                                    Ext.MessageBox.hide();
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
                                    Ext.MessageBox.hide();
                                    var result = Ext.util.JSON.decode(action.response.responseText);
                                    Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                                    //btn.setDisabled(false) ;
                                }
                            });
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
                for (var i=0;i < columnStore.length;i++){
                    columnStore[i].IS_READY = 0;
                    columnStore[i].IS_QEHBFX = 1;
                    columnStore[i].IS_IMPORT = 1;
                    columnStore[i].CDBJ_AMT = parseFloat(columnStore[i].XZ_AMT)+parseFloat(columnStore[i].ZH_AMT);
                    columnStore[i].CDLX_AMT = parseFloat(columnStore[i].XZ_AMT)+parseFloat(columnStore[i].ZH_AMT);
                };
                var grid = DSYGrid.getGrid('zqzd_grid');
                grid.insertData(null, columnStore);
                grid.getStore().sort([{
                    property : 'AD_CODE',
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
    function initWindow_input_contentForm(zd_id) {
        return Ext.create('Ext.form.Panel', {
            name:"form_main_sj",
            width: '100%',
            height: '100%',
            layout: 'vbox',
            fileUpload: true,
            padding: '2 5 0 5',
            border: false,
            defaults: {
                //anchor: '100% -100',
                // margin: '2 5 2 5'
                width: '100%'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        //width: 280,
                        readOnly: true,
                        labelWidth: 160//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "textfield",
                            fieldLabel: '债券ID',
                            disabled: false,
                            name: "ZQ_ID",
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '是否关联兑付计划',
                            disabled: false,
                            name: "IS_NEW",
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '转贷ID',
                            disabled: false,
                            name: "ZD_ID",
                            hidden: true,
                            editable: false//禁用编辑
                        },
                        {
                            xtype: "displayfield",
                            fieldLabel: '债券名称',
                            name: "ZQ_NAME",
                            tdCls: 'grid-cell-unedit',
                        },
                        /* {
                            xtype: "textfield",
                            fieldLabel: '债券名称',
                            name: "ZQ_NAME",
                            readOnly: true,
                           fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "combobox",
                            name: "ZQQX_ID",
                            store: DebtEleStoreDB("DEBT_ZQQX"),
                            displayField: "name",
                            valueField: "id",
                            fieldLabel: '债券期限',
                             readOnly: true,
                           // disabled: true,
                           fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "combobox",
                            name: "FXZQ_ID",
                            store: DebtEleStore(json_debt_fxzq),
                            displayField: "name",
                            valueField: "id",
                            fieldLabel: '付息方式',
                            readOnly: true,
                            fieldStyle:'background:#E6E6E6'
                        },{
                            xtype: "numberfield",
                            name: "PM_RATE",
                            fieldLabel: '发行利率(%)',
                            emptyText: '0.000000',
                            decimalPrecision: 6,
                            hideTrigger: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}) ,
                            readOnly: true,
                            //disabled: true,
                           fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "combobox",
                            name: "ZQLB_ID",
                            store: DebtEleStore(json_debt_zqlx),
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
                            readOnly: true,
                           //disabled: true,
                           fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "combobox",
                            name: "ZQ_PC_ID",
                            store: DebtEleStoreDB('DEBT_ZQPC'),
                            fieldLabel: '发行批次',
                            displayField: 'name',
                            valueField: 'id',
                            editable: false, //禁用编辑
                            readOnly: true,
                           //disabled: true,
                           fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "PLAN_AMT",
                            fieldLabel: '债券金额',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                           fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "PLAN_XZ_AMT",
                            fieldLabel: '其中新增债券金额',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                           fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "PLAN_ZH_AMT",
                            fieldLabel: '其中置换债券金额',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                           fieldStyle:'background:#E6E6E6'
                        }, */
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_AMT",
                            fieldLabel: '剩余可转贷金额(元)',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            //disabled: true,
                            fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_XZ_AMT",
                            fieldLabel: '其中新增债券金额(元)',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            //disabled: true,
                            fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_ZH_AMT",
                            fieldLabel: '其中置换债券金额(元)',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            //disabled: true,
                            fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_HB_AMT",
                            fieldLabel: '其中再融资债券金额(元)',
                            emptyText: '0.00',
                            hideTrigger: true,
                            plugins: {ptype: 'fieldStylePlugin'},
                            readOnly: true,
                            //disabled: true,
                            fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_CDBJ_AMT",
                            fieldLabel: '剩余承担本金金额',
                            plugins: {ptype: 'fieldStylePlugin'},
                            decimalPrecision: 6,
                            hideTrigger: true/* ,
                                hidden: true */,
                            hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                            fieldStyle:'background:#E6E6E6'
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "SY_CDLX_AMT",
                            fieldLabel: '剩余承担利息本金金额',
                            plugins: {ptype: 'fieldStylePlugin'},
                            decimalPrecision: 6,
                            hideTrigger: true/* ,
                                hidden: true */,
                            hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                            fieldStyle:'background:#E6E6E6'
                        }
                    ]
                },
                {//分割线
                    xtype: 'menuseparator',
                    width: '100%',
                    anchor: '100%',
                    margin: '5 0 5 0',
                    border: true
                },
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        //width: 280,
                        labelWidth: 140,//控件默认标签宽度
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
                            value: DF_START_DATE_TEMP,
                            maxValue: DF_END_DATE_TEMP ,
                            minValue: DF_START_DATE_TEMP
                        },
                        {
                            xtype: "numberfield",
                            name: "TQHK_DAYS_P",
                            fieldLabel: '提前还款天数(校验)',
                            hidden: true
                        },
                        {
                            xtype: "numberfield",
                            name: "TQHK_DAYS",
                            fieldLabel: '提前还款天数',
                            minValue: 0,
                            allowDecimals: false,
                            hideTrigger: true,
                            allowBlank: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            listeners: {
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZNJ_RATE",
                            fieldLabel: '滞纳金率(万分之)',
                            emptyText: '0.000000',
                            minValue: 0,
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                        },
                        {
                            xtype:"textfield",
                            name:"CHDQZQ_check",
                            fieldLabel:"校验字段",
                            hidden:debuggers
                        },
                        {
                            xtype:"textfield",
                            name:"CHDQZQ_ID_CHECK",
                            fieldLabel:"校验字段2",
                            hidden:debuggers
                        },
                        {
                            xtype: 'treecombobox',
                            width:200,
                            fieldLabel: "偿还到期债券",
                            name: 'CHDQZQ2',
                            displayField: 'name',
                            valueField: 'id',
                            editable: true, //禁用编辑
                            readOnly:false,
                            hidden:is_xzzd == 1 ? true:false,//新增债券隐藏
                            allowBlank: true,
                            store: store_DQZQ,
                            listeners: {
                                itemmouseenter: function ( self, record, item) {
                                    var remark="简称:"+record.get("ZQ_JC")+"; 类型:"+record.get("ZQLB_NAME")+"; 发行方式:"+record.get("FXFS_NAME")+"; 期限:"+record.get("ZQQX_NAME");
                                    if(!remark){
                                        return
                                    }
                                    self.tip = Ext.create('Ext.tip.ToolTip', {
                                        target: item,
                                        delegate: self.itemSelector,
                                        trackMouse: true,
                                        renderTo: Ext.getBody(),
                                        listeners: {
                                            beforeshow: function updateTipBody(tip) {
                                                tip.update(remark);
                                            }
                                        }
                                    });
                                },
                                'change': function (self,newValue) {  //self newValue
//                                        var BJ_HKZQ_AMT=Ext.ComponentQuery.query('numberFieldFormat[itemId="BJ_HKZQ_AMT"]')[0];
//
//                                        if(BJ_HKZQ_AMT!=null&&BJ_HKZQ_AMT){
//                                            var temp$2=BJ_HKZQ_AMT.getValue();
//                                            if(temp$2!=null||temp$2!=undefined!=temp$2>0){
//                                                return false;
//                                            }else{

                                    var amt_kongjian = Ext.ComponentQuery.query('numberFieldFormat[name="SY_HB_AMT"]')[0];
                                    var syxz_amt = Ext.ComponentQuery.query('numberFieldFormat[name="SY_XZ_AMT"]')[0].getValue();
                                    var syzh_amt = Ext.ComponentQuery.query('numberFieldFormat[name="SY_ZH_AMT"]')[0].getValue();
                                    var sy_amt = Ext.ComponentQuery.query('numberFieldFormat[name="SY_AMT"]')[0].getValue();
                                    var store_temp = self.getStore();
                                    var b = store_temp.findNode('id', newValue, true, true, true);
                                    if (b != null && b != undefined){
                                        var recordsingle = b.data;
                                        var grid = Ext.ComponentQuery.query('grid[itemId="zqzd_grid"]')[0];
                                        var CHDQZQ_check = Ext.ComponentQuery.query('textfield[name="CHDQZQ_check"]')[0];
                                        var CHDQZQ_ID_CHECK = Ext.ComponentQuery.query('textfield[name="CHDQZQ_ID_CHECK"]')[0];
                                        CHDQZQ_check.setValue(recordsingle.ZQ_NAME);
                                        CHDQZQ_ID_CHECK.setValue(recordsingle.DQZQ_ID);
                                        grid.getStore().each(function (record) {
                                            var check_flag = record.get("HB_AMT");
                                            if (check_flag != null && check_flag != undefined && check_flag > 0) {
                                                record.set('CHDQZQ', recordsingle.ZQ_NAME);
                                                record.set('CHDQZQID', recordsingle.DQZQ_ID);
                                                record.set('CHDQZQID_check', recordsingle.DQZQ_ID);
                                                record.set('CHDQZQNAME_CHECK', recordsingle.ZQ_NAME);
                                            }
                                        });
                                        var zd_id = Ext.ComponentQuery.query('textfield[name="ZD_ID"]')[0].getValue();
                                        $.post("/getSxzdBySelectId.action", {
                                            AD_CODE: AD_CODE,
                                            DQZQ_ID: recordsingle.DQZQ_ID,
                                            ZQ_ID: zd_zq_id,
                                            ZD_ID: zd_id
                                        }, function (data) {
                                            if (data != null && data != undefined && data.dataList) {
                                                var result = data.dataList;
                                                var HB_AMT = result.HB_AMT;
                                                var DQZQ_ID = result.DQZQ_ID;
                                                //获取grid
                                                var grid = Ext.ComponentQuery.query('grid[itemId="zqzd_grid"]')[0];
                                                if (grid.getStore().getCount() > 0) {
                                                    for (var p = 0; p < grid.getStore().getCount(); p++) {
                                                        var record = grid.getStore().getAt(p);
                                                        var hb_grid = record.get('HB_AMT');
                                                        if (hb_grid != null && hb_grid != undefined && hb_grid > 0) {
                                                            HB_AMT = HB_AMT - hb_grid;
                                                        }
                                                    }
                                                }
                                                //获取本级
                                                var bj_amt = Ext.ComponentQuery.query('numberFieldFormat[name="BJ_HKZQ_AMT"]')[0];
                                                var bj_amt2 = bj_amt.getValue();
                                                HB_AMT = HB_AMT - bj_amt2;


                                                if (amt_kongjian != null && amt_kongjian != undefined) {
                                                    amt_kongjian.setValue(HB_AMT);
                                                }
                                            }else {
                                                amt_kongjian.setValue();
                                            }
                                        }, "json");
//                                            }
//                                        }else{
//                                            return false;
//                                        }
                                    }
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "BJ_HKZQ_AMT",
                            fieldLabel: "偿还到期债券金额(元)",
                            emptyText: '0.00',
                            minValue:0,
                            hidden:is_xzzd == 1 ? true:false,//新增债券隐藏
                            hideTrigger: true,
                            readOnly: false,
                            listeners: {
                                change: function (me, newValue, oldValue, eOpts) {
                                    var grid = DSYGrid.getGrid('zqzd_grid');
                                    var self = grid.getStore();
                                    var form = grid.up('window').down('form');
                                    //如果偿还到期债券为空，则当前不可选了
                                    var temp$a1 = form.getForm().findField('CHDQZQ2').getValue();
                                    var input_zd_amt = 0;
                                    var input_xz_amt = 0;
                                    var input_zh_amt = 0;
                                    var input_hb_amt = 0;
                                    var input_cdbj_amt = 0;
                                    var input_cdlx_amt = 0;
                                    self.each(function (record) {
                                        if (record.get('IS_QEHBFX') == 1) {
                                            record.set('CDBJ_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                                            //var qecdlx_amt = (record.get('XZ_AMT') + record.get('ZH_AMT')) * form.down('numberfield[name="PM_RATE"]').getValue() * form.down('combobox[name="ZQQX_ID"]').getValue() / 100;
                                            record.set('CDLX_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                                        }
                                        record.set('ZD_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                                        input_zd_amt += record.get('ZD_AMT');
                                        input_xz_amt += record.get('XZ_AMT');
                                        input_zh_amt += record.get('ZH_AMT');
                                        input_hb_amt += record.get('HB_AMT');
                                        input_cdbj_amt += record.get('CDBJ_AMT');
                                        input_cdlx_amt += record.get('CDLX_AMT');
                                    });
                                    var bj_hkzq_amt = form.down('numberFieldFormat[name="BJ_HKZQ_AMT"]').getValue();
                                    if (bj_hkzq_amt != null && bj_hkzq_amt != "" && bj_hkzq_amt > 0) {
                                        input_hb_amt = input_hb_amt + bj_hkzq_amt;
                                        input_zd_amt = input_zd_amt + bj_hkzq_amt;
                                    }
                                    //form.down('numberFieldFormat[name="ZD_ZD_AMT"]').setValue(input_zd_amt);
                                    form.down('numberFieldFormat[name="ZD_XZ_AMT"]').setValue(input_xz_amt);
                                    form.down('numberFieldFormat[name="ZD_ZH_AMT"]').setValue(input_zh_amt);
                                    //form.down('numberFieldFormat[name="ZD_HB_AMT"]').setValue(input_hb_amt);
                                    form.down('numberFieldFormat[name="CDBJ_AMT"]').setValue(input_cdbj_amt);
                                    form.down('numberFieldFormat[name="CDLX_AMT"]').setValue(input_cdlx_amt);
//                                            if (newValue <= 0) {
//                                                var BJ_HKZQ_AMT = form.getForm().findField('CHDQZQ2');
//                                                BJ_HKZQ_AMT.setEditable(false);
//                                                BJ_HKZQ_AMT.setReadOnly(true);
//                                                BJ_HKZQ_AMT.setValue("");
//                                            } else {
//                                                var BJ_HKZQ_AMT = form.getForm().findField('CHDQZQ2');
//                                                BJ_HKZQ_AMT.setEditable(true);
//                                                BJ_HKZQ_AMT.setReadOnly(false);
//                                            }
                                    if (isNaN(oldValue) || isNaN(newValue)) {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_hb_amt = me.up('form').down('numberFieldFormat[name="SY_HB_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_HB_AMT"]').setValue(sy_hb_amt - cha);
                                    var sy_amt = me.up('form').down('numberFieldFormat[name="SY_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_AMT"]').setValue(sy_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "BJ_HKZQ_AMT_ORI",
                            fieldLabel: "偿还到期债券金额(校验)",
                            emptyText: '0.00',
                            hideTrigger: true,
                            hidden:debuggers,
                            readOnly: true
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_ZD_AMT",
                            fieldLabel: '<span class="required">✶</span>转贷总金额(元)',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 2,
                            hideTrigger: true,
                            allowBlank: false,
                            hidden:true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            readOnly: true,
                            fieldStyle:'background:#E6E6E6',
                            listeners:{
                                change:function(me, newValue, oldValue,eOpts){
                                    if(isNaN(oldValue) || isNaN(newValue))
                                    {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_amt = me.up('form').down('numberFieldFormat[name="SY_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_AMT"]').setValue(sy_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_XZ_AMT",
                            fieldLabel: '其中新增债券金额(元)',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            hidden:true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            readOnly: true,
                            fieldStyle:'background:#E6E6E6',
                            listeners:{
                                change:function(me, newValue, oldValue,eOpts){
                                    if(isNaN(oldValue) || isNaN(newValue)) {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_xz_amt = me.up('form').down('numberFieldFormat[name="SY_XZ_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_XZ_AMT"]').setValue(sy_xz_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_ZH_AMT",
                            fieldLabel: '置换债券金额(元)',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            hidden:true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            readOnly: true,
                            fieldStyle:'background:#E6E6E6',
                            listeners:{
                                change:function(me, newValue, oldValue,eOpts){
                                    if(isNaN(oldValue) || isNaN(newValue))
                                    {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_zh_amt = me.up('form').down('numberFieldFormat[name="SY_ZH_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_ZH_AMT"]').setValue(sy_zh_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "ZD_HB_AMT",
                            fieldLabel: '再融资债券金额(元)',
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            hidden:true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            readOnly: true,
                            fieldStyle:'background:#E6E6E6',
                            listeners:{
                                change:function(me, newValue, oldValue,eOpts){
                                    if(isNaN(oldValue) || isNaN(newValue))
                                    {
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_hb_amt = me.up('form').down('numberFieldFormat[name="SY_HB_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_HB_AMT"]').setValue(sy_hb_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "CDBJ_AMT",
                            fieldLabel: '承担本金额金额',
                            decimalPrecision: 6,
                            hideTrigger: true/* ,
                                hidden: true */,
                            hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            fieldStyle:'background:#E6E6E6',
                            listeners:{
                                change:function(me, newValue, oldValue,eOpts){
                                    if(isNaN(oldValue) || isNaN(newValue)){
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_cdbj_amt = me.up('form').down('numberFieldFormat[name="SY_CDBJ_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_CDBJ_AMT"]').setValue(sy_cdbj_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "CDLX_AMT",
                            fieldLabel: '承担利息本金金额',
                            decimalPrecision: 6,
                            hideTrigger: true/* ,
                                hidden: true */,
                            hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                            fieldStyle:'background:#E6E6E6',
                            listeners:{
                                change:function(me, newValue, oldValue,eOpts){
                                    if(isNaN(oldValue) || isNaN(newValue)){
                                        return;
                                    }
                                    var cha = newValue - oldValue;
                                    var sy_cdlx_amt = me.up('form').down('numberFieldFormat[name="SY_CDLX_AMT"]').getValue();
                                    me.up('form').down('numberFieldFormat[name="SY_CDLX_AMT"]').setValue(sy_cdlx_amt - cha);
                                }
                            }
                        },
                        {
                            xtype: "checkbox",
                            name: "is_ftdff",
                            fieldLabel: "是否分摊兑付费:",
                            inputValue: true,
                            checked:  IS_FTDFF_CHECKED == 1 ? true : false,
                            width: 138,
                            margin: '2 5 2 5',
                            labelWidth: 140,
                            boxLabelAlign: 'before'
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    //columnWidth: 1,
                    title: '转贷明细',
                    flex: 1,
                    //anchor: SYS_IS_QEHBFX==0 ?'100% -210':'100% -240',
                    //collapsible: true, //设置为 true 则允许 fieldset 可以收缩
                    layout: 'fit',
                    items: [initContentAddGrid(zd_id)]
                }
            ]
        });
    }
    function initContentAddGrid(zd_id) {
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
                            items: [initWin_ckfjGrid_mx({editable: true , busiId: zd_id})]
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
            {xtype: 'rownumberer',width: 35},
            {dataIndex: "IS_READY", type: "string", text: "IS_READY", width: 150, hidden: true},
            {dataIndex: "IS_IMPORT", type: "string", text: "IS_IMPORT", width: 150, hidden: true},//, hidden: true
            {dataIndex: "AD_NAME", type: "string", text: "转贷区域", width: 150, hidden: true},
            {
                dataIndex: "AD_CODE", type: "string", text: "转贷区域", width: 200,
                renderer: function (value) {
                    var store = grid_tree_store;
                    var record = store.findRecord('CODE', value,0, false, true, true);
                    return record != null ? record.get('TEXT') : value;
                },
                editor: {//   行政区划动态获取(下拉框)
                    xtype: 'combobox',
                    displayField: 'TEXT',
                    valueField: 'CODE',
                    store: grid_tree_store
                },
                /* editor: {           //   行政区划动态获取（下拉树）
                    xtype: 'treecombobox',
                    displayField: 'text',
                    valueField: 'code',
                    store: grid_tree_store,
                    rootVisible: false//隐藏根节点
                }, */
                tdCls: 'grid-cell'
            },
            {
                dataIndex: "IS_QEHBFX", type: "string", text: "是否全额还本付息", width: 150,
                hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                tdCls: 'grid-cell',
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
                    value:1,
                    store: DebtEleStore(json_debt_sf)
                }
            },
            {
                dataIndex: "ZD_AMT", type: "float", text: "转贷金额(元)", width: 160,tdCls: 'grid-cell-unedit',
                summaryType: 'sum',
                renderer: function (value, cellmeta, record) {
                    value = record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT');
                    return Ext.util.Format.number(value, '0,000.00');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDBJ_AMT", type: "float", text: "需承担本金金额", width: 160,
                hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "CDLX_AMT", type: "float", text: "需承担利息本金金额", width: 160,
                hidden: SYS_IS_QEHBFX==0,//根据系统参数控制是否支持分摊本息
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: 0,
                    allowBlank: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "XZ_SYZD_AMT", type: "float", text: "新增债券剩余可转贷金额(元)", width: 230,
                hidden:((IS_BZB == '1' || IS_BZB == '2')&& IS_NEW == '1') ? (is_xzzd == 2 ? true:false) : true,
                editor: {
                    xtype: "numberFieldFormat",
                    emptyText: '0.00',
                    hideTrigger: true,
                    mouseWheelEnabled: true,
                    minValue: minValue,
                    maxValue: maxValue,
                    allowBlank: false,
                    editable: false,
                    plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                },
                //summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {
                dataIndex: "XZ_AMT", type: "float", text: "新增债券金额(元)", width: 160,
                hidden:is_xzzd == 2 ? true:false,//置换再融资债券隐藏
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
                dataIndex: "ZH_AMT", type: "float", text: "置换债券金额(元)", width: 160,
                hidden:is_xzzd == 1 ? true:false,//新增债券隐藏
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
                dataIndex: "HB_AMT_ORI", type: "float", text: "还本债券金额(元)(校验用)", width: 160,hidden:debuggers
            },
            {
                dataIndex: "HB_AMT", type: "float", text: "再融资债券金额(元)", width: 160,
                hidden:is_xzzd == 1 ? true:false,//新增债券隐藏
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
            {dataIndex: "CHDQZQ", type: "string", text: "偿还到期债券", width: 150,
                hidden:is_xzzd == 1 ? true:false,//新增债券隐藏
                /*editor:{
                xtype: 'treecombobox',
                name: 'CHDQZQ3',
                displayField: 'name',
                valueField: 'id',
                editable: true, //禁用编辑
                readOnly:false,
                store: store_DQZQ_TEMP
                listeners: {
                    itemmouseenter: function ( self, record, item) {
                        var remark="简称:"+record.get("ZQ_JC")+"; 类型:"+record.get("ZQLB_NAME")+"; 发行方式:"+record.get("FXFS_NAME")+"; 期限:"+record.get("ZQQX_NAME");
                        if(!remark){
                            return
                        }
                        self.tip = Ext.create('Ext.tip.ToolTip', {
                            target: item,
                            delegate: self.itemSelector,
                            trackMouse: true,
                            renderTo: Ext.getBody(),
                            listeners: {
                                beforeshow: function updateTipBody(tip) {
                                    tip.update(remark);
                                }
                            }
                        });
                    },
                    'select': function (a,b,c,d) {
                        var record=b.data;

                    }
                }
            }*/
            },
            {dataIndex: "CHDQZQID", type: "string", text: "偿还到期债券id", width: 150, editor: 'textfield',hidden:debuggers},
            {dataIndex: "CHDQZQID_check", type: "string", text: "偿还到期债券id(前端校验用)", width: 150, editor: 'textfield',hidden:debuggers},
            {dataIndex:"CHDQZQNAME_CHECK",type:"string",text:"偿还到期债券name(前端校验用)",width:150,editor:'textfield',hidden:debuggers},
            {dataIndex: "ZDXY_NO", type: "string", text: "转贷协议号", width: 150, editor: 'textfield'},
            {dataIndex: "REMARK", type: "string", text: "备注", width: 150, editor: 'textfield'}
        ];
        var simplyGrid = new DSYGridV2();
        var grid = simplyGrid.create({
            itemId: 'zqzd_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            autoLoad: false,
            dataUrl: 'getPcjhGridData.action',
            border: true,
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
                    listeners: {
                        'edit': function (editor, e) {
                            var forms = Ext.ComponentQuery.query('form[name="form_main_sj"]')[0].getForm();
                            var default_temp$1=forms.findField("CHDQZQ2").getValue();
                            var default_temp$2=forms.findField("CHDQZQ_check").getValue();
                            //e.record.commit();
                            //  HB_AMT   CHDQZQ  CHDQZQID
                            if(e.field=='HB_AMT'){
                                if(e.value<=0){
                                    e.record.set("CHDQZQ","");
                                    e.record.set("CHDQZQID","");
                                }else{
                                    if(default_temp$2!=null&&default_temp$2!=undefined&&default_temp$2!=""){
                                        e.record.set("CHDQZQ",default_temp$2);
                                    }
                                    if(default_temp$1!=null&&default_temp$1!=undefined&&default_temp$1!=""){
                                        e.record.set("CHDQZQID",default_temp$1);
                                    }
                                }
                            }
                            if(e.field == 'AD_CODE' && e.record.get('AD_CODE') != '') {
                                if(button_name == '主债录入' && zdMap.containsKey(e.record.get('AD_CODE'))){
                                    del();
                                    zdMap.get(e.record.get('AD_CODE')).AD_CODE = e.record.get('AD_CODE');
                                    var grid = window_input.window.down('grid#zqzd_grid').getStore();
                                    var records = [];
                                    var data = Ext.clone(zdMap.get(e.record.get('AD_CODE')));
                                    data.id = null;
                                    data.ZH_AMT = 0;
                                    data.HB_AMT = 0;
                                    data.CHDQZQID = null;
                                    data.CHDQZQ = null;
                                    records.push(data);
                                    grid.insertData(null,records);
                                }else{
                                    if(button_name != '修改'){//20210902市转贷防止修改数据时，数据项被清空
                                        del();
                                        window_input.window.down('grid#zqzd_grid').insertData(null, {AD_CODE: e.record.get('AD_CODE'),IS_QEHBFX: 1});
                                    }

                                }
                            }
                            },
                        'beforeedit': function (editor, e) {
                            // 20200923_wangjc: 如果当前系统参数IS_CREATE_FKMDFJH：维系（1生成、 0不生成）必须全额转贷
                            if(!!IS_CREATE_FKMDFJH && IS_CREATE_FKMDFJH =='1' && e.field == 'XZ_AMT' ) {
                                return false;
                            }
                            /*if (e.field == 'AD_CODE' && e.record.get('IS_READY')) {
                                return false;
                            }
                            //关联月度计划的新增债券，转贷信息不可更改（地区和新增债券金额）
                            if (e.field == 'AD_CODE' ) {
                                var forms = Ext.ComponentQuery.query('form[name="form_main_sj"]')[0].getForm();
                                var is_new=forms.findField("IS_NEW").getValue();
                                if (is_new == '1' && e.record.get('XZ_AMT') >0) {
                                    return false;
                                }else{
                                    return true;
                                }
                            }*/
                            //如果全额偿还本金利息  那么不允许修改 承担本金利息值
                            if (e.field == 'CDBJ_AMT' || e.field == 'CDLX_AMT') {
                                if(e.record.get('IS_QEHBFX')== '') {
                                    Ext.Msg.alert('提示', '请先选择是否全额还本付息！');
                                    return false;
                                }
                                if (e.record.get('IS_QEHBFX') == '1') {
                                    return false;
                                }
                            }
                            if(e.field == 'CHDQZQ' || e.field == 'CHDQZQID'){
//                                    var CHDQZQ2=Ext.ComponentQuery.query('treecombobox[name="CHDQZQ2"]')[0];
//                                    if(CHDQZQ2.getValue()!=null&&CHDQZQ2.getValue()!=""){
                                return false;
                                //     }
                            }
                            if(e.field=='HB_AMT'){
                                if(!is_zrz){
                                    return false;
                                }
                            }
//                                if(!is_zrz){
//                                    return false;
//                                }
                            /*// 如果新增债券是查询出来的，不允许修改
                            if (e.field == 'XZ_AMT' ) {
                                var forms = Ext.ComponentQuery.query('form[name="form_main_sj"]')[0].getForm();
                                var is_new=forms.findField("IS_NEW").getValue();
                                if (is_new == '1') {
                                    return false;
                                }else{
                                    return true;
                                }
                            };*/
                            if(e.field == 'XZ_SYZD_AMT' ) {
                                return false;
                            };
                            var form = window_input.window.down('grid#zqzd_grid').up('form');
                            // 是否关联兑付计划
                            var  is_new = form.down('textfield[name="IS_NEW"]').getValue();
                            if(IS_BZB == '1' || IS_BZB == '2'){
                                if(e.record.get('XZ_SYZD_AMT') <= 0 && is_new == '1'){
                                    if(e.field == 'XZ_AMT' ) {
                                        return false;
                                    };
                                }
                            }
                        }
                        }
                }
            ],
            pageConfig: {
                enablePage: false
            },
            listeners: {
                validateedit: function (editor, context) {
                    if (context.field == 'AD_CODE') {
                        var store = grid_tree_store;
                        var record = store.findRecord('CODE', context.value, 0, false, true, true);
                        if(record!=null&&record!=undefined&&record!=''){
                            context.record.set('AD_NAME', record.get('TEXT'));
                        }
                    }
                    return checkEditorGrid(editor, context);
                }
            }
        });
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
            var input_cdbj_amt = 0;
            var input_cdlx_amt = 0;
            self.each(function (record) {
                if (record.get('IS_QEHBFX') == 1) {
                    record.set('CDBJ_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                    //var qecdlx_amt = (record.get('XZ_AMT') + record.get('ZH_AMT')) * form.down('numberfield[name="PM_RATE"]').getValue() * form.down('combobox[name="ZQQX_ID"]').getValue() / 100;
                    record.set('CDLX_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                }
                record.set('ZD_AMT', record.get('XZ_AMT') + record.get('ZH_AMT') + record.get('HB_AMT'));
                input_zd_amt += record.get('ZD_AMT');
                input_xz_amt += record.get('XZ_AMT');
                input_zh_amt += record.get('ZH_AMT');
                input_hb_amt += record.get('HB_AMT');
                input_cdbj_amt += record.get('CDBJ_AMT');
                input_cdlx_amt += record.get('CDLX_AMT');
            });
            var bj_hkzq_amt=form.down('numberFieldFormat[name="BJ_HKZQ_AMT"]').getValue();
            if(bj_hkzq_amt!=null&&bj_hkzq_amt!=""&&bj_hkzq_amt>0){
                input_hb_amt=input_hb_amt+0;
                input_zd_amt=input_zd_amt+0;
            }
            form.down('numberFieldFormat[name="ZD_ZD_AMT"]').setValue(input_zd_amt);
            form.down('numberFieldFormat[name="ZD_XZ_AMT"]').setValue(input_xz_amt);
            form.down('numberFieldFormat[name="ZD_ZH_AMT"]').setValue(input_zh_amt);
            form.down('numberFieldFormat[name="ZD_HB_AMT"]').setValue(input_hb_amt);
            form.down('numberFieldFormat[name="CDBJ_AMT"]').setValue(input_cdbj_amt);
            form.down('numberFieldFormat[name="CDLX_AMT"]').setValue(input_cdlx_amt);
        });
        return grid;
    }
    // 删除行方法
    function del(){
        var grid = DSYGrid.getGrid("zqzd_grid");
        var store = grid.getStore();
        var sm = grid.getSelectionModel();
        store.remove(sm.getSelection());
        if (store.getCount() > 0) {
            sm.select(0);
        }
    }
    /**
     * validateedit 表格编辑插件校验
     */
    function checkEditorGrid(editor, context) {
//        if (context.field == 'AD_CODE') {
//            var newValue = context.value;
//            var flag = true;
//            context.grid.getStore().each(function (record) {
//                if (newValue == record.get('AD_CODE')) {
//                    flag = false;
//                    Ext.Msg.alert('提示', '编辑项区划重复！');
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
        var ids = [];
        for (var i in records) {
            ids.push(records[i].get("ZD_ID"));
        }
        button_name = btn.text;
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text,
            animateTarget: btn,
            value: btn.name == 'up' ? null : '同意',
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    //发送ajax请求，修改节点信息
                    $.post("/updateFxdfZdhkNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        ids: ids,
                        IS_CREATEJH_BY_AUDIT:IS_CREATEJH_BY_AUDIT
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
        //刷新附件
        var filePanel = Ext.ComponentQuery.query('#zqzd_mx_edit')[0].down('#winPanel_tabPanel');
        if (filePanel) {
            filePanel.removeAll();
            filePanel.add(initWin_ckfjGrid({
                editable: IS_EDIT == 0 ? true : false,
                busiId: window_input.zd_id
            }));
        }
        //刷新附件
        DSYGrid.getGrid('winPanel_tabPanel').getStore().getProxy().extraParams['ZD_ID'] = window_input.zd_id;
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
     操作记录的函数
     **/
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请选择一条记录！');
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
        } else {
            pcjh_id = records[0].get("ZD_ID");
            fuc_getWorkFlowLog(pcjh_id);
        }
    }
    /**
     *保存时校验表格数据
     */
    function checkGrid(grid) {
        var flag = true;
        var checkAd = {};
        var form = grid.up('form');
        if (form.down('numberfield[name="TQHK_DAYS"]').getValue() <
            form.down('numberfield[name="TQHK_DAYS_P"]').getValue()
        ) {
            grid_error_message = '提前还款天数不应小于本地区还款天数'+form.down('numberfield[name="TQHK_DAYS_P"]').getValue()+'天!';
            flag = false;
            return flag;
        }
        if (form.down('numberFieldFormat[name="SY_XZ_AMT"]').getValue()<0 ||
            form.down('numberFieldFormat[name="SY_ZH_AMT"]').getValue()<0 ||
            form.down('numberFieldFormat[name="SY_HB_AMT"]').getValue()<0
        ) {
            grid_error_message = '转贷金额超过债券可转贷额度！';
            flag = false;
            return flag;
        }
        if (form.down('numberFieldFormat[name="SY_CDBJ_AMT"]').getValue()<0) {
            grid_error_message = '承担本金金额超限！';
            flag = false;
            return flag;
        }
        if (form.down('numberFieldFormat[name="SY_CDLX_AMT"]').getValue()<0) {
            grid_error_message = '承担利息本金金额超限！';
            flag = false;
            return flag;
        }
        var objs = grid_tree_store.data.items ;
        var items = [] ;
        for(var i=0; i<objs.length; i++){
            var item = objs[i] ;
            items[i] = item.data.CODE ;
        }
        grid.getStore().each(function (record) {
            if (record.get('ZD_AMT') == 0) {
                grid_error_message = '地区' + record.get('AD_NAME') + '分配金额非法！';
                flag = false;
                return flag;
            }
            if (record.get('AD_CODE') == '' || record.get('AD_CODE') == null) {
                grid_error_message = '转贷地区为空！';
                flag = false;
                return flag;
            }
            var zdmxGrid = DSYGrid.getGrid('zqzd_grid').getStore();
            var CODE = [];
            var ZDXX = [];
            for(var i=0;i<zdmxGrid.count();i++){
                var record = zdmxGrid.getAt(i);
                var adcode = record.get("AD_CODE");
                CODE.push(adcode);
                ZDXX.push(record);
            }
            var ADCODE = CODE.sort();
            var ZDMX = ZDXX.sort();
            for(var i=0;i<zdmxGrid.count();i++){
                if(ADCODE[i] == ADCODE[i+1]){
                    var fvalue = [];
                    for(var e = 0;e < ZDMX.length;e++){
                        if(ZDMX[e].data.AD_CODE == ADCODE[i] ) {
                            if (ZDMX[e].data.XZ_AMT > 0) {
                                fvalue.push(true);
                            }
                        }
                    }
                    if(fvalue.length >= 2){
                        grid_error_message = '新增债券金额（元），不为0时不可存在重复地区！';
                        flag = false;
                        return flag;
                    }
                }
            }
            // 是否关联兑付计划
            var  is_new = form.down('textfield[name="IS_NEW"]').getValue();
            if(IS_BZB == '1' || IS_BZB == '2'){
                if(record.get('XZ_SYZD_AMT') > 0 && is_new == '1'){
                    for(var i=0;i<zdmxGrid.count();i++){
                        var record =zdmxGrid.getAt(i);
                        if(record.get('XZ_SYZD_AMT') > 0){
                            if(zdMap.get(record.get('AD_CODE')).XZ_AMT > zdMap.get(record.get('AD_CODE')).XZ_SYZD_AMT){
                                grid_error_message = record.get('AD_CODE') + ' 地区新增债券金额（元），超出新增债券剩余可转贷金额（元）！';
                                flag = false;
                                return flag;
                            }
                        }
                    }
                }
            }
            /*if (record.get('ZDXY_NO') == '' || record.get('ZDXY_NO') == null) {
                grid_error_message = '转贷协议号为空！';
                flag = false;
                return flag;
            }*/
            if(record.get('IS_IMPORT') != null && record.get('IS_IMPORT') != '' && record.get('IS_IMPORT') == '1'){
                var ad_code = record.get('AD_CODE') ;
                var ad_name = record.get('AD_NAME') ;
                if(items.indexOf(ad_code) < 0){
                    grid_error_message = '地区  '+ad_code + " " + ad_name +' 不属于转贷区域中！';
                    flag = false ;
                    return flag ;
                }
            }
            if (typeof checkAd[record.get('AD_CODE')] != 'undefined' && checkAd[record.get('AD_CODE')] != null && checkAd[record.get('AD_CODE')]) {
//                grid_error_message = '重复的转贷区域！';
//                flag = false;
//                return flag;
            } else {
                checkAd[record.get('AD_CODE')] = true;
            }
        });
        return flag;
    }
    /**
     * 表格中树下拉store
     */
    var grid_tree_store = Ext.create('Ext.data.Store', {//下拉框store
        fields: ['CODE', 'TEXT'],
        proxy: {
            type: 'ajax',
            //method: 'POST',
            url: 'getAdDataByCode.action',
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
    /* var grid_tree_store = Ext.create('Ext.data.TreeStore', { //下拉树store
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
        var grid = UploadPanel.createGrid({
            busiType: '',//业务类型
            busiId: config.busiId,//业务ID
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

</script>
<script type="text/javascript" src="zzqZdMain.js"></script>
</body>
</html>