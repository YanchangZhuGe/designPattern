<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset=UTF-8">
    <title>预算编制调整主界面</title>
    <style type="text/css">
        .label-color {
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
<script type="text/javascript" src="xmjbxx.js"></script>
<script type="text/javascript" src="/js/debt/xmsySzysGrid.js"></script>
<script type="text/javascript" src="/js/debt/xmInfo.js"></script>
<script type="text/javascript">
    var nowDate = Ext.Date.format(new Date(), 'Y-m-d');
    var nowYear=nowDate.substr(0,4);
    var ywcsbl = false;
/*
    var wf_id = getQueryParam("wf_id");//当前流程id
*/
    var wf_id = '${fns:getParamValue("wf_id")}'
 /*   var node_code = getQueryParam("node_code");//当前节点id
    var node_type = getQueryParam("node_type");*/
    var node_code = '${fns:getParamValue("node_code")}';
    var node_type = '${fns:getParamValue("node_type")}';
    var is_view = 0;
    var is_cl = 0;
/*
    var is_zbx = getQueryParam("is_zbx");
*/
    var is_zbx = '${fns:getParamValue("is_zbx")}';
    var xmxzCondition = " and 1=1";
/*
    var is_wzxt = getQueryParam("is_wzxt");//是否是外债系统
*/   var is_wzxt = '${fns:getParamValue("is_wzxt")}';
    var BXFGBS_XX = '${fns:getSysParam("BXFGBS_XX")}';// 20200923 guoyf 较验本息覆盖倍数下限
    var BXFGBS_SX = '${fns:getSysParam("BXFGBS_SX")}';// 20201116 guoyf 较验本息覆盖倍数上限
   /* if (is_wzxt == null || is_wzxt == '' || is_wzxt.toUpperCase() == 'null') {
        is_wzxt = '0';
    }*/
   if(isNull(is_wzxt)){
       is_wzxt = '0';
   }
    if ("1" == is_zbx) {
        xmxzCondition = " and GUID LIKE '01%'";
    }
    var BILL_ID = "";
    var bg_type = 4;
    var is_status = "";
/*
    var IS_END = getQueryParam("is_end");
*/
    var IS_END = '${fns:getParamValue("is_end")}';
    var XM_ID = null;
    var button_name = null;
    var audit_info = '';
    var connNdjh = '';//项目是否已经申报年度计划
    var connZwxx = '';//项目是否被债务信息引用
   /* var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }*/
    var WF_STATUS = '${fns:getParamValue("WF_STATUS")}';
    if(isNull(WF_STATUS)){
        WF_STATUS = '001';
    }
    var v_child = '0';
    if (node_type == "typing" || node_type == "reviewed") {
        v_child = '1';
    }
    var tab_items_load = {'jbqk':{},'szys1':{}};
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    //统一社会信用代码
    var USCCODE;
    var button_status;//按钮状态

    /**
     * 通用配置json
     */
    var ysbztz_json_common = {
        100363: {
            "typing": {//预算编制调整录入
                jsFileUrl: 'ysbztzlr.js'
            },
            "reviewed": {//预算编制调整审核
                jsFileUrl: 'ysbztzsh.js'
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
            cache: true
        });
        $.getScript(ysbztz_json_common[wf_id][node_type].jsFileUrl, function () {
            initContent();
            if (ysbztz_json_common[wf_id][node_type].callBack) {
                ysbztz_json_common[wf_id][node_type].callBack();
            }
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
            height: '100%',
            renderTo: 'contentPanel',
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: ysbztz_json_common[wf_id][node_type].items[WF_STATUS]
                }
            ],
            items: ysbztz_json_common[wf_id][node_type].items_content()
        });
    }
    /**
     * 初始化右侧panel，放置1个表格
     */
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    layout: {
                        type: 'column'
                    },
                    defaults: {
                        margin: '5 5 5 5',
                        width: 250,
                        labelWidth: 60,
                        labelAlign: 'left'//控件默认标签对齐方式
                    },
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
                            store: DebtEleTreeStoreDB("DEBT_ZWXMLX")
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '模糊查询',
                            itemId: "XM_SEARCH",
                            width: 400,
                            emptyText: '请输入项目单位/项目编码/项目名称/项目建设内容',
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
            items: ysbztz_json_common[wf_id][node_type].items_content_rightPanel_items ? ysbztz_json_common[wf_id][node_type].items_content_rightPanel_items() : [
                initContentGrid()
            ]
        });
    }
    /**
     * 创建合同变更录入弹出窗口
     */
    function initWin_ysbztzlrWindow() {
        var buttons;
        if (WF_STATUS == '008' || button_name == 'VIEW') {
            buttons = [
                {
                    text: '关闭',
                    hidden: true,
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ];
        }
        else {
            buttons = [
	            {
	                xtype: 'button',
	                itemId:'mbxz',
                    hidden: true,
	                text: '模板下载',
	                handler: function (btn) {
	                    szysExcelDown();//收支平衡表格模板下载
	                }
	            }
	            ,{
	                xtype: 'button',
	                text: '导入',
	                itemId:"import",
                    hidden: true,
	                name: 'upload',
	                fileUpload: true,
	                buttonConfig: {
	                    width: 140,
	                    icon: '/image/sysbutton/report.png'
	                },
	                handler: function (btn) {
	                var xmsyForm = Ext.ComponentQuery.query(formName)[0];
			    	//获取运行年限
			    	var yyqx = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();
			    	if(yyqx==""||yyqx==undefined){
			    		Ext.MessageBox.alert('提示', "请先填写项目期限!");
			    		return false;
			    	}
	                    window_xekjdr.show({TITLE:'请导入收支平衡表数据',DR_TYPE:'0'});//收支平衡表格模板下载
	                }
	            },
                {
                    xtype: 'button',
                    itemId:'tbsm',
                    hidden: true,
                    text: '填报说明',
                    handler: function (btn) {
                        window.open('../common/ystbsmText.jsp');
                    }
                },
                {
                    text: '保存',
                    handler: function (btn) {
                        //保存表单数据
                        submitInfo(btn);
                    }
                },
                {
                    text: '关闭',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ];
        }
        var ysbztzlrWindow = Ext.create('Ext.window.Window', {
            title: "预算编制调整",
            name: 'ysbztzlrWin',
            width: document.body.clientWidth * 0.9, //自适应窗口宽度
            height: document.body.clientHeight * 0.95, //自适应窗口高度
            maximizable: true,
            itemId: 'window_clzw', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',
            layout: 'vbox',
            defaults: {
                width: '100%'
            },
            items: [
                {
                    xtype: 'container',
                    margin: '2 2 2 2',
                    layout: 'hbox',
                    hidden: button_name == 'VIEW',
                    items: [
                        {xtype: 'label', text: '单位名称:', width: 70},
                        {xtype: 'label', text: AG_NAME, width: 200, flex: 5},
                        {xtype: 'label', text: '单位:万元', width: 80, cls: "label-color"}
                    ]
                },
                initWin_ysbztzlrTabPanel()
            ],
            buttons: buttons
        });
        ysbztzlrWindow.show();
    }
    //去除空格方法
    function Trim(m){
        while((m.length>0)&&(m.charAt(0)==' '))
            m  =  m.substring(1, m.length);
        while((m.length>0)&&(m.charAt(m.length-1)==' '))
            m = m.substring(0, m.length-1);
        return m;
    }
    /**
     * 保存数据
     */
    function submitInfo(btn) {
        //获取基本情况页签表单
        var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
        //调整说明页签
        var form = Ext.ComponentQuery.query('form[name="bgxxForm"]')[0];
        //调整说明较验
        var bg_date = Ext.ComponentQuery.query('datefield[name="BG_DATE"]')[0].value;
        var bg_reason = Ext.ComponentQuery.query('textarea[name="BG_REASON"]')[0].value;
        if (bg_date == null || bg_date == '' || bg_date == 'undefined'||Trim(bg_date)==''||null == Trim(bg_date)) {
            Ext.Msg.alert('提示', "调整日期不能为空");
            return false;
        }
        if (bg_reason == null || bg_reason == '' || bg_reason == 'undefined'||Trim(bg_reason)==''||null == Trim(bg_reason)) {
            Ext.Msg.alert('提示', "调整原因不能为空");
            return false;
        }
        // 获取收支平衡页签表格
        var gridData = [];//所有明细数据
        var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
        var xmsyGrid = xmsyForm.down('grid');
        for (var i = 0; i < xmsyGrid.getStore().getCount(); i++) {
            var record = xmsyGrid.getStore().getAt(i);
            gridData.push(record.data);
        }

        //----------------------较验
        //获取收支平衡页签表单
        var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
        var xmsygrid = xmsyForm.down('grid');
        var xmsyform_temp = xmsyForm.getForm();

        // 收支平衡校验
        if (!xmsyForm.isValid()) {
            Ext.toast({
                html: "收支平衡：请检查是否填写正确！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400,
                listeners: {
                    "show": function () {
                        zqxxtbTab(3);
                    }
                }
            });
            return false;
        }

        var message_error = null;
        var xmztr_amt = szysGrid.getStore().sum('SRAMT_Y'); // 项目预计总收入
        var zfxjjkm_id = xmsyForm.down('treecombobox[name="ZFXJJKM_ID"]').getValue();    // 项目对应的政府性基金科目
        var xm_used_date = xmsyForm.down('datefield[name="XM_USED_DATE"]').getValue();    // 项目投入使用日期
        var xm_used_limit = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();  // 项目运营期限
        if(zfxjjkm_id == null || zfxjjkm_id == "" || zfxjjkm_id == undefined){
            message_error = "收支平衡：项目对应的政府性基金科目不可为空！";
        }
        // 如果项目类型非"土地储备" 则校验通用编制计划
        if (xm_used_date != null && xm_used_date != "" && xm_used_date != undefined) {
            var lx_year = Ext.ComponentQuery.query('combobox[name="LX_YEAR"]')[0].getValue();
            var newValue = format(xm_used_date, 'yyyy');
            if (newValue < lx_year) {
                xmsyForm.down('datefield[name="XM_USED_DATE"]').setValue('');
                message_error = "收支平衡：项目投入使用日期不可小于立项年度！";
                Ext.Msg.alert('提示', message_error);
                zqxxtbTab(3);
                return false;
            }
        }
        if (xmztr_amt <= 0 && zfxjjkm_id != null && zfxjjkm_id != "" && zfxjjkm_id != undefined) {
            message_error = "收支平衡：项目对应的政府性基金科目不为空时，必须有收入！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }

        if (xmztr_amt > 0 && ((zfxjjkm_id == null) || (zfxjjkm_id == "") || zfxjjkm_id == undefined)) {
            message_error = "收支平衡：项目收入合计不为0时，项目对应的政府性基金科目不可为空！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }
        if (xmztr_amt <= 0 && ((xm_used_date != null && xm_used_date != ""&& xm_used_date != undefined) || (xm_used_limit != null && xm_used_limit != "" && xm_used_limit != undefined))) {
            message_error = "收支平衡：开始日期或预算年限不为空时，必须有收入！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }
        if (xmztr_amt > 0 && ( ((xm_used_date == null) || (xm_used_date == "") || xm_used_date == undefined) || ((xm_used_limit == null) || (xm_used_limit == "") || xm_used_limit == undefined)  )) {
            message_error = "收支平衡：项目收入合计不为0时，开始日期和预算期限不能为空！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }
        //获取收支平衡页签表单
        var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
        var szysGrid = xmsyForm.down('grid');
        var xmsyGrid = [];
        var is_negative = false; // 明细中是否存在负数
        var yyqx_count = 4; // 默认显示5年编制计划列
        if (!!xm_used_limit) {
            yyqx_count = xm_used_limit;
        }
        if(xm_used_limit > 30){
            yyqx_count = 30;
        }
        if(is_tdcb){
            if ((!!xmztr_amt) && xmztr_amt <=0) {
                Ext.Msg.alert('提示', '项目类型为土地储备时项目预计总收入不能为零');
                zqxxtbTab(3);
                return false;
            }
            if (!zfxjjkm_id) {
                Ext.Msg.alert('提示', '项目类型为土地储备时项目对应的政府性基金科目不能为空');
                zqxxtbTab(3);
                return false;
            }
            // “评估土地使用权出让收入”之和大于等于“土地储备项目资金支出”之和，否则提示：土储项目应当实现总体收支平衡 01 >= 03
            // 当年“土地储备项目资金”必须大于等于“土地储备项目资金支出”，否则提示：土储项目应当实现年度收支平衡 02 >= 03
            var record_01 = szysGrid.getStore().getAt(gs_relation_guid["01"]); // 评估土地使用权出让收入 01
            var record_02 = szysGrid.getStore().getAt(gs_relation_guid["02"]); // 土地储备项目资金 02
            var record_03 = szysGrid.getStore().getAt(gs_relation_guid["03"]); // 土地储备项目资金支出 03

            var pgsr_sum_amt = 0.00; // 评估土地使用权出让收入总年度金额
            var zjzc_sum_amt = 0.00; // 土地储备项目资金支出总年度金额

            for (var i = 0; i <= yyqx_count; i++) {
                var SR = "SRAMT_Y" + i;
                var ZC = "ZCAMT_Y" + i;

                if (record_02.get(SR) < record_03.get(ZC)) {
                    Ext.Msg.alert('提示', '土储项目应当实现年度收支平衡');
                    zqxxtbTab(3);
                    return false;
                }
                pgsr_sum_amt += record_01.get(SR);
                zjzc_sum_amt += record_03.get(ZC);
            }
            if (pgsr_sum_amt < zjzc_sum_amt) {
                Ext.Msg.alert('提示', '土储项目应当实现总体收支平衡');
                zqxxtbTab(3);
                return false;
            }
        }else{
        // 对还本总金额进行校验
        var record_06 = szysGrid.getStore().getAt(gs_relation_guid["06"]);// 获取专项债券金额
        var record_0203 = szysGrid.getStore().getAt(gs_relation_guid["0202"]);// 获取地方政府专项债券金额
        var record_07 = szysGrid.getStore().getAt(gs_relation_guid["07"]);// 获取市场化融资金额
        var record_0204 = szysGrid.getStore().getAt(gs_relation_guid["0203"]);// 获取项目单位市场化融资金额
        var record_020201 = szysGrid.getStore().getAt(gs_relation_guid["020201"]);// 获取其中用于资本金
        var record_03=szysGrid.getStore().getAt(gs_relation_guid["03"]);
        var record_0301=szysGrid.getStore().getAt(gs_relation_guid["0301"]);
        var record_0302=szysGrid.getStore().getAt(gs_relation_guid["0302"]);
        var record_02 = szysGrid.getStore().getAt(gs_relation_guid["02"]);//项目建设资金来源\
        var record_04 = szysGrid.getStore().getAt(gs_relation_guid["04"]);// 四、项目运营支出
            /*var record_01 = szysGrid.getStore().getAt(gs_relation_guid["01"]);
            var record_0101 = szysGrid.getStore().getAt(gs_relation_guid["0101"]);
            var record_0102 = szysGrid.getStore().getAt(gs_relation_guid["0102"]);*/
        var zxzqhb_amt = 0.00; // 专项债券还本总金额
        var zxzq_amt = 0.00;   // 专项债券总金额
        var schrzhb_amt = 0.00;// 市场化融资还本总金额
        var schrz_amt = 0.00;  // 市场化融资总金额
        var jszjly_amt=0.00;//建设资金来源 总金额
        var xmyyzc_zmt=0.00;//项目运营支出总金额
        var xmjszc_amt=0.00;//项目建设支出总金额
        var  fx_amt_0301;
        var  fx_amt_0402;
        var xmyysr_amt=0.00
        //20211020liyue添加付息金额不能为负数校验，付息金额为负数证明还本金额大于当年专项收入金额及前几年专项收入金额的合计值！
        var record_0301 = szysGrid.getStore().getAt(gs_relation_guid["0301"]);//0301建设付息行
        var record_0402 = szysGrid.getStore().getAt(gs_relation_guid["0402"]);//0402收入付息行
         var record_08 = szysGrid.getStore().getAt(gs_relation_guid["08"]);//0301建设付息行
       var record_01 = szysGrid.getStore().getAt(gs_relation_guid["01"]);//01项目运营总收入

            // 循环计算所有年度总收入总支出合计值
        for (var i = 0; i <= yyqx_count; i++) {
            var SR = "SRAMT_Y" + i;
            var ZC = "ZCAMT_Y" + i;
            jszjly_amt += parseFloat(record_02.get(SR) == "" ? 0 : record_02.get(SR));//建设资金来源 总金额
            xmyyzc_zmt+=parseFloat(record_04.get(ZC) == "" ? 0 : record_04.get(ZC));//项目运营支出总金额
            xmjszc_amt+=parseFloat(record_03.get(ZC) == "" ? 0 : record_03.get(ZC));//项目运营支出总金额
            zxzqhb_amt += parseFloat(record_06.get(ZC)==""?0:record_06.get(ZC));
            zxzq_amt += parseFloat(record_0203.get(SR)==""?0:record_0203.get(SR));
            schrzhb_amt += parseFloat(record_07.get(ZC)==""?0:record_07.get(ZC));
            schrz_amt += parseFloat(record_0204.get(SR)==""?0:record_0204.get(SR));
            var dfzxzq_amt = parseFloat(record_0202.get(SR)==""?0:record_0202.get(SR));//2地方政府专项债券金额
            var qzsr = parseFloat(record_020201.get(SR)==""?0:record_020201.get(SR));//获取其中用于资本金
            var jsxmzc = parseFloat(record_03.get(ZC)==""?0:record_03.get(ZC));//建设项目支出03
            var cwzyzx = parseFloat(record_0301.get(ZC)==""?0:record_0301.get(ZC));//财务专用专项债券付息
            var cwzysc = parseFloat(record_0302.get(ZC)==""?0:record_0302.get(ZC));//市场化融资付息
            xmyysr_amt += parseFloat(record_01.get(SR) == "" ? 0 : record_01.get(SR));
            if(parseFloat(qzsr).toFixed(6)-parseFloat(dfzxzq_amt).toFixed(6)> 0.000001){//20210420liyue添加用于资本金与地方专项校验
                Ext.Msg.alert('提示', '其中：用于资本金不能大于地方政府专项债券金额！');
                return false;
            }
            var ZC = "ZCAMT_Y" + i;
            fx_amt_0301 = parseFloat(record_06.get(ZC)==""?0:record_0301.get(ZC));//0301建设付息金额
            fx_amt_0402 = parseFloat(record_0202.get(SR)==""?0:record_0402.get(SR));//0402收入付息金额
            if(fx_amt_0301<0){
                Ext.Msg.alert('提示','财务费用-专项债券付息金额不能为负！');
                return false;
            }
            if(fx_amt_0402<0) {
                Ext.Msg.alert('提示', '财务费用-专项债券付息支出金额不能为负数！');
                return false;
            }

            if(parseFloat(cwzyzx+cwzysc).toFixed(6)-parseFloat(jsxmzc).toFixed(6)> 0.000001){//20210420liyue添加建设项目支出与其中金额校验
                Ext.Msg.alert('提示', '其中：财务费用和不能大于项目建设支出！');
                return false;
            }
        }
            //辽宁特性
            //辽宁特性
            if (parseFloat(zxzqhb_amt).toFixed(6)-parseFloat((jszjly_amt+xmyysr_amt) -(xmyyzc_zmt+xmjszc_amt)).toFixed(6)> 0.000001&&sysAdcode=='21') {//20210420liyue添加建设项目支出与其中金额校验
                Ext.Msg.alert('提示', '（建设资金来源 + 项目运营预期收入） - 项目运营支出 - 项目建设支出小于专项债券还本！');
                return false;
            }
           /* if(Math.abs((parseFloat(zxzqhb_amt).toFixed(6)-parseFloat(zxzq_amt).toFixed(6)).toFixed(6)) > 0.000001){
                Ext.Msg.alert('提示', '专项债券还本总金额应等于地方政府专项债券总金额！');
                return false;
            }*/
            if(Math.abs((parseFloat(schrzhb_amt).toFixed(6)-parseFloat(schrz_amt).toFixed(6)).toFixed(6)) > 0.000001){
                Ext.Msg.alert('提示','市场化融资还本总金额应等于项目单位市场化融资总金额！');
                return false;
            }

            var xmsyForm = Ext.ComponentQuery.query(formName)[0];
            var store = xmsyForm.down('grid').getStore();
            var bxfg = store.getAt(gs_relation_guid["09"]);
            var XMXZ_ID = jbqkForm.getForm().findField('XMXZ_ID').getValue();
            /*if(XMXZ_ID == '010102') {
                // BXFGBS_XX不为0与不为null则较验
                if (BXFGBS_XX != '0' && BXFGBS_XX != 'null' && BXFGBS_XX != '') {
                    if (bxfg.data.SRAMT_Y0 < parseFloat(BXFGBS_XX)) {
                        Ext.Msg.alert('提示', '本息覆盖倍数必须大于或等于' + BXFGBS_XX + '倍！');
                        return false;
                    }
                }
            }
            if(BXFGBS_SX != '0' && BXFGBS_SX != 'null' && BXFGBS_SX != ''){
                if(bxfg.data.SRAMT_Y0 > parseFloat(BXFGBS_SX)){
                    Ext.Msg.alert('提示','本息覆盖倍数过大，请检查数据！');
                    return false;
                }
            }
            if(checkBxfgFromImport()){//本息覆盖倍数校验
                return false;
            }*/
            /*if (!(xm_used_date == null || (xm_used_date == "") || xm_used_date == undefined)){
                for (var n = 0; n <= yyqx_count; n++) {
                    var SR = "SRAMT_Y" + n;
                    var year = Number(xm_used_date.getFullYear()) + Number(n);
                    var sr_amt = (parseFloat(record_0101.get(SR).toFixed(6))) + (parseFloat(record_0102.get(SR).toFixed(6)));
                    if(parseFloat(sr_amt) > parseFloat(record_01.get(SR))){
                        Ext.Msg.alert('提示',''+year+'年，其中：财政运营补贴收入与其中：土地出让收入相加之和<br/>超出项目预期收入（预期资产评估价值）！');
                        return false;
                    }
                }
            }*/
        }
        szysGrid.getStore().each(function (record) {
            xmsyGrid.push(record.getData());
        });

        // 输出提示信息
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return;
        }
    //较验----------------------------
    // ----------新增  修改----------
        var url;
        var params;
        //      新增/修改
        if (button_name == 'INPUT') {
            url = 'saveXMBgxx.action';
            params = {
                BG_TYPE:"4",
                wf_id: wf_id,
                node_code: node_code,
                XM_ID: XM_ID,
                is_wzxt: is_wzxt,
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE,
                AG_ID: AG_ID,
                AG_NAME: AG_NAME,
                button_name: button_name,
                jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
                xmsyGrid: encode64(Ext.util.JSON.encode(gridData)),
                xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
                BILL_ID: GUID.createGUID()
            };
        } else if (button_name == 'UPDATES') {
            url = 'updateXMBgxx.action';        //updateJSXMInfo
            params = {
                BG_TYPE:"4",
                wf_id: wf_id,
                node_code: node_code,
                XM_ID: XM_ID,
                node_type: node_type,
                is_wzxt: is_wzxt,
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE,
                AG_ID: AG_ID,
                AG_NAME: AG_NAME,
                button_name: button_name,
                jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
                xmsyGrid: encode64(Ext.util.JSON.encode(gridData)),
                xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
                BILL_ID: BILL_ID
            };
        }
        //避免网络或操作导致数据错误，按钮置为不可点击
        if (form.isValid()) {
            // if(btn != null){
            //     btn.setDisabled(true);  //避免网络或操作导致数据错误，按钮置为不可点击
            // }
            form.submit({
                url: url,
                params: params,
                waitTitle: '请等待',
                waitMsg: '正在保存中...',
                success: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '保存成功',
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function (btn) {
                            Ext.ComponentQuery.query('window[name="ysbztzlrWin"]')[0].close();
                            reloadGrid();
                        }
                    });
                },
                failure: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '保存失败!' + action.result.message,
                        width: 200,
                        fn: function (btn) {
                            Ext.ComponentQuery.query('window[name="ysbztzlrWin"]')[0].close();
                            reloadGrid();
                        }
                    });
                }
            });
        } else {
            Ext.Msg.alert('提示', '请检查必录项是否填写,数据格式是否正确！');
        }
    }

    //----------------------------------切换页签-----------------------------
    function zqxxtbTab(index) {
        var zqxxtbTab = Ext.ComponentQuery.query('panel[itemId="EditorPanel"]')[0];
        zqxxtbTab.items.get(index-1).show();
    }

    /**
     * 初始化预算编制调整录入弹出窗口内容
     */
    function initWin_ysbztzlrTabPanel() {
        var ysbztzlrTabPanel = Ext.create('Ext.tab.Panel', {
            name: 'EditorPanel',
            flex: 1,
            border: false,
            defaults: {
                border: false
            },
            items: [
                {
                    title: '调整说明',
                    layout: 'fit',
                    items: initWindow_debt_ysbztzlr_contentForm()
                },
                {
                    title: '项目信息',
                    scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_jbqk()
                },
                {
                    title: '收支平衡',
                    btnsItemId: 'szys',
                    layout: 'fit',
                    items: initWindow_zqxxtb_contentForm_tab_szys(button_name)
                }
            ],
            listeners: {
                tabchange: function (tabPanel, newCard, oldCard) {
               		if(button_name=="VIEW"){//项目看板没有下方按钮，不做校验下面获取按钮报错
               			return false;
               		}
                    if (isOld_szysGrid == '0' && newCard.btnsItemId == 'szys') {
                        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(false);
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(false);
                        Ext.ComponentQuery.query('button#import')[0].setHidden(false);
                    }else{
                        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#import')[0].setHidden(true);
                    }
                    if(is_tdcb==true){//20201110_wangyl_土地储备隐藏导入按钮
                   	 Ext.ComponentQuery.query('button#import')[0].setHidden(true);
                   	 Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);
                   }
                }
            }
        });
        return ysbztzlrTabPanel;
    }
    /**
     * 根据封装好的页签Jason，加载所需页签
     * @param tab_items 需要显示的页签json
     * @param XM_ID 项目id
     */
    function getXmxxItems(tab_items,XM_ID,ruleIds) {
        var items = [];
        var xmxx_items = initWindow_xmxx_items(tab_items,XM_ID,ruleIds);
        for(var name in tab_items){//遍历json对象的每个key/value对,p为key
            //获取每个页签属性，动态重写属性。
            var tabJson = xmxx_items[name];
            var tab_property = tab_items[name];
            if(!jQuery.isEmptyObject(tab_property)){
                for(var property in tab_property){
                    tabJson[property]=tab_property[property];
                }
            }
            //将页签加入初始化panel中
            items.push(tabJson);
        }
        return items;
    }
    /**
     * 初始化合同变更信息表单
     */
    function initWindow_debt_ysbztzlr_contentForm() {
        return Ext.create('Ext.form.Panel', {
            //title: '详情表单',
            width: '100%',
            height: '100%',
            itemId: 'window_debt_ysbztzlr_contentForm',
            name: 'bgxxForm',
            layout: 'vbox',
            border: false,
            defaults: {
                width: '100%'
            },
            defaultType: 'textfield',
            items: [
                {
                    xtype: 'container',
                    layout: 'column',
                    margin: '0 0 0 0',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .99,
                        labelWidth: 70//控件默认标签宽度
                    },
                    items: [
                        {
                            fieldLabel: '<span class="required">✶</span>调整类型',
                            xtype: 'textfield',
                            columnWidth: .5,
                            value: '预算编制调整',
                            fieldStyle: 'background:#E6E6E6',
                            readOnly: true
                        },
                        {fieldLabel: '<span class="required">✶</span>调整日期',
                            xtype: 'datefield',
                            name: 'BG_DATE',
                            editable: false,
                            columnWidth: .5, format: 'Y-m-d'
                        },
                        {fieldLabel: '<span class="required">✶</span>调整原因',
                            xtype: "textarea",
                            columnWidth: 1,
                            name: 'BG_REASON',
                            maxLength:100,//限制输入字数
                            maxLengthText:"输入内容过长！最多输入100个汉字!"
                        },
                        {fieldLabel: '调整要点',
                            xtype: "textarea",
                            name: 'BG_IMPORT',
                            columnWidth: 1,
                            maxLength:100,//限制输入字数
                            maxLengthText:"输入内容过长,最多输入100个汉字!"
                        }
                    ]
                },
                {
                    xtype: 'fieldset',
                    flex: 1,
                    title: '调整历史',
                    layout: 'fit',
                    margin: '2 2 2 2',
                    collapsible: true,
                    items: [
                        initWindow_debt_ysbztzlr_contentForm_grid()
                    ]
                }
            ],
            listeners: {
                'beforeRender': function () {
                    if (button_name == 'VIEW') {
                        SetItemReadOnly(this.items);
                    }
                }
            }
        });
    }

    /**
     * 初始化调整历史录入弹出表格
     */
    function initWindow_debt_ysbztzlr_contentForm_grid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 45},
            {"dataIndex": "BG_TYPE", "width": 150, "type": "string", "text": "调整类型"},
            {"dataIndex": "BG_DATE", "width": 100, "type": "string", "text": "调整日期"},
            {"dataIndex": "CREATE_USER_NAME", "width": 150, "type": "string", "text": "调整人"},
            {"dataIndex": "BG_IMPORT", "width": 250, "type": "string", "text": "调整要点"},
            {"dataIndex": "BG_REASON", "width": 250, "type": "string", "text": "调整原因"},
            {"dataIndex": "BG_STATUS", "width": 150, "type": "string", "text": "状态"}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'grid_ysbztz_bgls',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: false,
            border: false,
            height: '100%',
            params: {
                AD_CODE: AD_CODE,
                AG_ID: AG_ID,
                AG_CODE: AG_CODE,
                XM_ID: XM_ID
            },
            dataUrl: 'getYsbzlsData.action',
            pageConfig: {
                enablePage: false
            }
        });
        return grid;
    }
    /**
     * 加载页面数据
     * @param form
     */
    function loadInfo() {
        $.post('getXmtzInfo.action', {
            XM_ID: XM_ID,
            BUTTON_NAME:button_name,
            tab_items:Ext.util.JSON.encode(tab_items_load)
        },function (data) {
            var dataJson = Ext.util.JSON.decode(data);
            if(dataJson.success){
                //获取基本情况页签表单
                var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
                jbqkForm.load({
                    url: 'getYsbzInfo.action',
                    params: {
                        BILL_ID:BILL_ID,
                        XM_ID: XM_ID,
                        BG_TYPE: bg_type,
                        BUTTON_NAME:button_name
                    },
                    waitTitle: '请等待',
                    waitMsg: '正在加载中...',
                    success: function (form_success, action) {
                        connNdjh = action.result.data.jbqkForm.CONNNDJH;
                        connZwxx = action.result.data.jbqkForm.CONNZWXX;
                        //加载基本情况页签表单
                        jbqkForm.getForm().setValues(action.result.data.jbqkForm);
                        var bgxxForm = Ext.ComponentQuery.query('form[name="bgxxForm"]')[0];
                        bgxxForm.getForm().setValues(action.result.data.bgxxForm);
                        //控制项目变更日期不能为项目开始日期之前
                        bgxxForm.getForm().findField('BG_DATE').minValue = new Date(Date.parse(action.result.data.jbqkForm.CREATE_DATE.replace(/-/g, "/")));
                    },
                    failure: function (form, action) {
                        alert('加载失败');
                        Ext.ComponentQuery.query('window[name="window_zqxxtb"]')[0].close();
                    }
                });
            }else{
                alert('加载失败');
                Ext.ComponentQuery.query('window[name="window_zqxxtb"]')[0].close();
            }
        });
    }
    /**
     * 查询按钮实现
     */
    function getHbfxDataList() {
        var store = DSYGrid.getGrid('contentGrid').getStore();
        var XMXZ_ID = Ext.ComponentQuery.query('treecombobox#XMXZ_SEARCH')[0].getValue();
        var XMLX_ID = Ext.ComponentQuery.query('treecombobox#XMLX_SEARCH')[0].getValue();
        var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
        //初始化表格Store参数
        store.getProxy().extraParams = {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            mhcx: mhcx,
            XMXZ_ID: XMXZ_ID,
            XMLX_ID: XMLX_ID,
            wf_status: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            is_zbx: is_zbx
        };
        //刷新表格内容
        store.loadPage(1);
    }
    /**
     * 合同变更信息送审/审核
     */
    function next() {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
            return false;
        }
        //判断操作按钮
        if (node_type == 'typing') {
            button_name = '送审';
        } else if (node_type == 'reviewed') {
            button_name = '审核';
        }
        var bgInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.ID = record.get("BILL_ID");
            array.XM_ID = record.get("XM_ID");
            array.AD_CODE = record.get("AD_CODE");
            array.BG_TYPE = record.get("BG_TYPE");
            array.BG_TYPE_ID = record.get("BG_TYPE_ID");
            bgInfoArray.push(array);
        });
        //向后台传递变更数据信息
        $.post('nextXmtzInfo.action', {
            wf_id: wf_id,
            node_code: node_code,
            button_name: button_name,
            audit_info: audit_info,
            IS_END: IS_END,
            bgInfoArray: Ext.util.JSON.encode(bgInfoArray)
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: button_name + "成功！" + (data.message ? data.message : ''),
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
            } else {
                Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
            }
        }, 'json');
    }
    /**
     * 债务合同信息退回/撤销
     */
    function back(btnName) {
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
            return false;
        }
        var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
        var bgInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.ID = record.get("BILL_ID");
            array.XM_ID = record.get("XM_ID");
            bgInfoArray.push(array);
        });
        //向后台传递变更数据信息
        $.post('/backXMBgInfo.action', {
            wf_id: wf_id,
            node_code: node_code,
            button_name: btnName,
            audit_info: audit_info,
            IS_END: IS_END,
            bgInfoArray: Ext.util.JSON.encode(bgInfoArray)
        }, function (data) {
            if (data.success) {
                Ext.toast({
                    html: button_name + "成功！" + (data.message ? data.message : ''),
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
            } else {
                Ext.MessageBox.alert('提示', button_name + "失败！" + (data.message ? data.message : ''));
                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
            }
        }, 'json');
    }
    //--------------------------------审核----------------------------------
    /**
     * 查询按钮实现
     */
    function getDataList() {
        var store = DSYGrid.getGrid('contentGrid').getStore();
        var XMXZ_ID = Ext.ComponentQuery.query('treecombobox#XMXZ_SEARCH')[0].getValue();
        var XMLX_ID = Ext.ComponentQuery.query('treecombobox#XMLX_SEARCH')[0].getValue();
        var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
        //初始化表格Store参数
        store.getProxy().extraParams = {
            AD_CODE: AD_CODE,
            AG_ID: AG_ID,
            AG_CODE: AG_CODE,
            mhcx: mhcx,
            XMXZ_ID: XMXZ_ID,
            XMLX_ID: XMLX_ID,
            wf_status: WF_STATUS,
            wf_id: wf_id,
            node_code: node_code,
            is_zbx: is_zbx
        };
        //刷新表格内容
        store.loadPage(1);
    }

    //设置基本信息只读
    function setJbxxReadOnly(flag){
        var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
        if(flag == true){
            SetFormItemsReadOnly(jbqkForm.items);
        }
    }
    //设置收支平衡只读
    function setSzysReadOnly(flag){
        var szysForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
        if(flag = true){
            SetFormItemsReadOnly(szysForm.items);
        }
    }

    /**
     * 操作记录
     */
    function dooperation() {
        var records = DSYGrid.getGrid('contentGrid').getSelection();
        if (records.length == 0) {
            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
            return;
        } else if (records.length > 1) {
            Ext.MessageBox.alert('提示', '不能同时查看多条记录！');
            return;
        } else {
            BILL_ID = records[0].get("BILL_ID");

            fuc_getWorkFlowLog(BILL_ID);
        }
    }
    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param) {
        if (AD_CODE == null || AD_CODE == '') {
            Ext.Msg.alert('提示', '请选择区划！');
            return;
        }
        if (ysbztz_json_common[wf_id][node_type].reloadGrid) {
            ysbztz_json_common[wf_id][node_type].reloadGrid(param);
        } else {
            var grid = DSYGrid.getGrid("contentGrid");
            var store = grid.getStore();
            var XMXZ_ID = Ext.ComponentQuery.query('treecombobox#XMXZ_SEARCH')[0].getValue();
            var XMLX_ID = Ext.ComponentQuery.query('treecombobox#XMLX_SEARCH')[0].getValue();
            var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
            //增加查询参数
            store.getProxy().extraParams["AD_CODE"] = AD_CODE;
            store.getProxy().extraParams["AG_CODE"] = AG_CODE;
            store.getProxy().extraParams["XMXZ_ID"] = XMXZ_ID;
            store.getProxy().extraParams["XMLX_ID"] = XMLX_ID;
            store.getProxy().extraParams["mhcx"] = mhcx;
            store.getProxy().extraParams["is_zbx"] = is_zbx;
            if (typeof param != 'undefined' && param != null) {
                for (var name in param) {
                    store.getProxy().extraParams[name] = param[name];
                }
            }
            //刷新
            store.loadPage(1);
        }
    }
//收支平衡弹出窗口
var window_xekjdr = {
    window: null,
    config: {
        closeAction: 'destroy'
    },
    show: function (config) {
        if (!this.window || this.config.closeAction == 'destroy') {

            this.window = initWindow_xekjdr(config);
        }
        this.window.show();
    }
};

function initWindow_xekjdr(config){
    return Ext.create('Ext.window.Window',{
        title:config.TITLE,
        width:document.body.clientWidth*0.4,
        height:document.body.clientHeight*0.4,
        layout:{
            type:'fit'
        },
        //maximizable:true,//最大最小化
        modal:true,
        closeAction:'destroy',
        buttonAlign:'right',
        items:initxekjdatadrform(config),
    });
}

//初始化导入名录信息form
function initxekjdatadrform(config) {
    return Ext.create('Ext.form.Panel',{
        labelWidth: 70,
        fileUpload: true,
        defaultType: 'textfield',
        layout :'anchor',
        items: [
            {
                xtype: 'container',
                layout: 'anchor',
                anchor: '100% 100%',
                defaultType: 'textfield',
                style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
                defaults: {
                    margin: '2 5 2 5',
                    //width: 315,
                    fontSize:20,
                    labelWidth: 100//控件默认标签宽度
                },
                items:[
                    {
                        xtype:'displayfield',
                        fieldLabel:'<span class="required">✶</span>注意事项',
                        margin: '2 5 2 5',
                        anchor:'100% 10%'
                    },
                    {
                        xtype:'textarea',
                        multiline: true,
                        name:'',
                        editable:false,
                        readOnly:true,
                        anchor:'100% 60%',
                        border: true,
                        fieldStyle:'background:#E6E6E6',
                        value:'1.导入的Excel文件最大不可超过20M。\n\n' +
                        '2.不可删除Excel中固定的数据列，否则会造成数据错乱。\n\n'+
                        '3.导入年数应与项目期限保持同步!'
                    },
                    {//分割线
                        xtype: 'menuseparator',
                        anchor: '100%',
                        border: true
                    },
                    {
                        xtype:'filefield',
                        fieldLabel:'请选择文件',
                        name:'upload',
                        anchor:'100% 30%',
                        msgTarget: 'side',
                        allowBlank: true,
                        margin: '5 5 2 5',
                        width:70,
                        height:30,
                        labelWidth: 80,
                        buttonConfig:{
                            width:100,
                            height:25,
                            text:'预览',
                            icon: '/image/sysbutton/report.png'
                        }
                    }
                ]
            }
        ],
        buttons:[
            {
                xtype:'button',
                text:'上传',
                name:'upload',
                handler:function(btn){
                    var form = this.up('form').getForm();
                    var file = form.findField('upload').getValue();
                    if(file==null||file==''){
                        Ext.Msg.alert('提示','请选择文件！');
                        return;
                    }else if(!(file.endWith('.xls')||file.endWith('.xlsx')||file.endWith('.et'))){//20210601 zhuangrx 文件导入兼容et类型
                        Ext.Msg.alert('提示','请选择Excel类型文件！');
                        return;
                    }
                    if(form.isValid()){
                        upLoadExcel(form,btn);
                    }
                }
            },
            {
                xtype:'button',
                text:'取消',
                name:'cancel',
                handler:function(btn){
                    btn.up('window').close();
                }
            }
        ]
    });
}

//收支平衡模板下载
function szysExcelDown(){
    window.location.href = 'downExcel.action?file_name='+encodeURI(encodeURI("收支预算表格模板.xls"));
}
function upLoadExcel(form,btn){
	var xmsyForm = Ext.ComponentQuery.query(formName)[0];
	//获取运行年限
    var yyqx = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();
	var url = '/importExcel_szys.action';
    form.submit({
        url: url,
        params:{
        	"yyqx":yyqx
        },
        waitTitle: '请等待',
        waitMsg: '正在导入中...',
        success: function (form, action) {
            var columnStore = action.result.list;
            var grid = DSYGrid.getGrid('xmsyGrid');
            grid.getStore().removeAll();
            grid.insertData(null, columnStore);
            btn.up('window').close();
            editLoad(grid,false);
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

</script>
</body>
</html>