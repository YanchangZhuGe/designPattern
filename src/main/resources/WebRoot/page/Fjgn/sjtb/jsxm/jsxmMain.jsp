<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="com.bgd.platform.util.service.*"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>建设项目主界面</title>
    <style type="text/css">
        .label-color {
            color: red;
            font-size: 100%;
        }
        .x-grid-item-jyfwm {
            background-color: #ff0000;
        }

        html, body {
            overflow-y: hidden;
        }
    </style>
</head>
<body>
<%--<%
    /*获取登录用户*/
	String userCode = (String) request.getSession().getAttribute("USERCODE");
    String userName = (String) request.getSession().getAttribute("USERNAME");
    String ADCODE = (String) request.getSession().getAttribute("ADCODE");
    String nowDate = SpringContextUtil.getDbDateDay();
%> --%>

<div id="contentPanel" style="width: 100%;height:100%;">
</div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/js/debt/Map.js"></script>
<script type="text/javascript" src="/js/debt/xmInfo.js"></script>
<script type="text/javascript" src="xmjbxx.js"></script>
<script type="text/javascript">
    var ywcsbl = false;//控制业务处室必录开关
    var userName = '${sessionScope.USERNAME}';  //获取用户名称
    var userCode = '${sessionScope.USERCODE}';  //获取用户编码
    var AD_CODE='${sessionScope.ADCODE}'.replace(/00$/, "");
    var nowDate = '${sessionScope.nowDate}';
    var userName = '${sessionScope.USERNAME}';
    var userCode = '${sessionScope.USERCODE}';
    var nowDate = '${fns:getDbDateDay()}';  //当前日期
    var AD_CODE='${sessionScope.ADCODE}'.replace(/00$/, "");
    var button_name = '';//当前操作按钮名称
   /* var wf_id = getQueryParam("wf_id");// 当前流程id
    var node_code = getQueryParam("node_code");// 当前节点id
    var is_jy = getQueryParam("is_jy");// 是否校验防伪码，如果是1就校验，其他则不校验
    var node_type = getQueryParam("node_type");// 当前节点类型
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    var is_view = getQueryParam("is_view");//当前状态
    var is_cl = getQueryParam("is_cl");//是否存量项目；1存量项目  0新增项目
    var is_zbx = getQueryParam("is_zbx");//当前状态
    var is_wzxt = getQueryParam("is_wzxt");//是否是外债系统*/
    var wf_id  = "${fns:getParamValue('wf_id')}";//当前节点名称
    var node_code  = "${fns:getParamValue('node_code')}";// 当前节点id
    var is_jy  = "${fns:getParamValue('is_jy')}";// 是否校验防伪码，如果是1就校验，其他则不校验
    var node_type  = "${fns:getParamValue('node_type')}";// 当前节点类型
    var WF_STATUS  = "${fns:getParamValue(WF_STATUS)}";
    var is_view  = "${fns:getParamValue('is_view')}";//当前状态
    var is_cl  = "${fns:getParamValue('is_cl')}";//是否存量项目；1存量项目  0新增项目
    var is_zbx  = "${fns:getParamValue('is_zbx')}";//当前状态
    var is_wzxt  = "${fns:getParamValue('is_wzxt')}";//是否是外债系统
    var IS_XMBCXX = '${fns:getSysParam("IS_XMBCXX")}';  //获取系统参数 项目补充信息是否显示
    var sysAdcode = '${fns:getSysParam("ELE_AD_CODE")}';// 20200818_zhuangrx_系统获取区划参数，这里用来控制一户式是否显示工程类别
    /*
     var is_zxzq = getQueryParam("is_zxzq");
 */
    var is_zxzq  = "${fns:getParamValue('is_zxzq')}";//当前状态
/*
    var isHiddenXZ = getQueryParam("isHiddenXZ");//是否隐藏新增项目按钮
*/
    var isHiddenXZ  = "${fns:getParamValue('isHiddenXZ')}";//是否隐藏新增项目按钮
    var is_bzb = '${fns:getSysParam("IS_BZB")}';//是否标准版
  /*  var IS_INPUT = getQueryParam("is_input");// 是否隐藏导入按钮*/
    var IS_INPUT  = "${fns:getParamValue('is_input')}";//是否隐藏新增项目按钮
    var BXFGBS_XX = '${fns:getSysParam("BXFGBS_XX")}';// 20200923 guoyf 较验本息覆盖倍数下限
    var BXFGBS_SX = '${fns:getSysParam("BXFGBS_SX")}';// 20201116 guoyf 较验本息覆盖倍数上限
/*
     var GxdzUrlParam=getQueryParam("GxdzUrlParam");//这里用来给湖南加项目总览修改名称
*/
    var GxdzUrlParam  = "${fns:getParamValue('GxdzUrlParam')}";//这里用来给湖南加项目总览修改名称
    var FR_DEPLOYMENT_MODE = '${fns:getSysParam("FR_DEPLOYMENT_MODE")}';//帆软报表是否集成部署
    //统一社会信用代码
    var USCCODE;
    //2020/08/25 guodg url参数来区分标准版和专项债
    if(is_bzb == '1' && is_zxzq == '1'){
        is_bzb = '2';
    }
    isHiddenXZ = (isHiddenXZ==null||isHiddenXZ=='')?false:true;
    if (is_wzxt == null || is_wzxt == '' || is_wzxt.toUpperCase() == 'null') {
        is_wzxt = '0';
    }
    var xmxzCondition = " and 1=1 and code!='0102' ";
    if ("1" == is_zbx) {
        xmxzCondition = " and GUID LIKE '01%'";
    }
    //2：专项债券系统，不能显示无收益项目性质
    if(is_bzb == '2'){
        xmxzCondition += " AND CODE NOT LIKE '010101%'"
    }
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var v_child = '0';
    if (is_view == "0") {
        v_child = '1';
    }
    if(is_wzxt=='1'){
        v_child = '0';
    }
    var XM_ID = '';//债务ID
    //全局变量
    var OPERATE = '';
    var json_zwlb = '';
    var title = '';
    var connNdjh = '';//项目是否已经申报年度计划
    var connZwxx = '';//项目是否被债务信息引用
    var option ='1';//表示tab页签
    if('1' == is_view){
        option ='5';
    }
    var loadOption={};
    var is_tdcb = false; // 项目类型是否为土地储备
    var year=new Date().getFullYear()+1;//获取当年年度的下一年
    var IS_SHOW_SPEC_UPLOAD_BTN = ''; //系统参数：导出按钮显示
    var address_Can_Alert;//按钮状态:穿透项目地图时根据按钮判断是否能够保存项目地址
    var ZQXM_TYPE;
    if (node_type == 'tb' && is_zxzq == '1') {//基础库区分一般专项
        // is_zxzq == '01' 专项债券项目 ZQXM_TYPE为02
        ZQXM_TYPE = '02'
    } else if (node_type == 'tb' && is_zxzq == '2') {
        // 一般
        ZQXM_TYPE = '01'
    } else if(node_type == 'tb'){
        alert("菜单链接缺失is_zxzq参数,请校验!")
    }else {
        // 审核
        ZQXM_TYPE = ''
    }
    $.ajax({
        type: 'post',
        url:'getParamValueAll.action',
        async: false,
        dataType: 'json',
        success: function (data) {
            IS_SHOW_SPEC_UPLOAD_BTN=data[0].IS_SHOW_SPEC_UPLOAD_BTN;
        }
    });
    //
    var XmDataJson;
    /**
     * 通用配置json
     */
    var jsxm_json_common = {
        jsFileUrl: 'jsxmlr.js'
    };
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
        //动态加载js
        /*$.ajaxSetup({
         cache: true
         });
         $.getScript(jsxm_json_common.jsFileUrl, function () {
         initContent();
         });*/
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
                    items: jsxm_json_common.items[jsxm_json_common.defautItems]
                }
            ],
            items: jsxm_json_common.items_content()
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
                    border: true,
                    bodyStyle: 'padding:0 0 0 0',//'border-width:0 0 0 0;',
                    defaults: {
                        margin: '1 1 2 5',
                        width: 250,
                        labelWidth: 80,//控件默认标签宽度
                        labelAlign: 'left'//控件默认标签对齐方式
                    },
                    items: [
						{
							xtype: "combobox",
							fieldLabel: '状态',
							itemId: "XM_STATUS",
							name: "XM_STATUS", // 状态根据node_type显示不同的数据
							store: node_type == 'tb' ? DebtEleStore(json_debt_zt1) : DebtEleStore(json_debt_zt2_3),
							hidden: node_type == 'tb' ? false : (node_type == 'sh' ? false : true),
							editable: false,
							allowBlank: false,
							displayField: "name",
							valueField: "code",
							value: WF_STATUS,
							listeners: {
								change: function (self, newValue) {
									WF_STATUS = newValue;
									// 更新工具栏中的按钮
									var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
									toolbar.removeAll();
									toolbar.add(jsxm_json_common.items[WF_STATUS]);
									// 刷新当前表格
									self.up('panel').down('grid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
									self.up('panel').down('grid').getStore().loadPage(1);
								}
							}
						},
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '项目性质',
                            itemId: 'XMXZ_SEARCH',
                            displayField: 'name',
                            valueField: 'code',
                            rootVisible: true,
                            hidden:true,
                            lines: false,
                            selectModel: 'all',
                            store: DebtEleTreeStoreDB("DEBT_ZJYT", {condition: xmxzCondition}),
                            listeners: {
                                select: function (btn,newValue, oldValue) {
                                    //刷新当前表格
                                    loadOption={};
                                    getHbfxDataList();
                                }
                            }
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
                            typeAhead:false,//不可编辑
                            editable:false,
                            store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
                            listeners: {
                                select: function (btn) {
                                    //刷新当前表格
                                    loadOption={};
                                    getHbfxDataList();
                                }
                            }
                        },
                        {
                            xtype: "combobox",
                            itemId: "JSXZ_SEARCH",
                            store: DebtEleStoreDB("DEBT_XMJSXZ", {condition: "AND GUID !='03' "}),
                            fieldLabel: '建设性质',
                            displayField: 'name',
                            valueField: 'id',
                            hidden:true,
                            editable: false,
                            listeners: {
                                select: function (btn) {
                                    //刷新当前表格
                                    loadOption={};
                                    getHbfxDataList();
                                }
                            }
                        },
                        {
                            xtype: "combobox",
                            itemId: "LXND_SEARCH",   //项目立项年度
                            store:DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2000' and code <= " + year}),
                            fieldLabel: is_view=='1'?'申报年度':'立项年度',
                            displayField: 'name',
                            valueField: 'id',
         					value:  new Date().getFullYear(),
                            editable: false,
                            allowBlank: true,
                            listeners: {
                                select: function (btn) {
			                        //刷新当前表格
                                    loadOption={};
                                    getHbfxDataList();
			                    }
			                }
                        },
                        {
                            xtype: "combobox",
                            itemId: "XMCJSJ_SEARCH",   //项目创建时间
                            store:DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2000' and code <= " + year}),
                            fieldLabel: '项目创建时间',
                            displayField: 'name',
                            valueField: 'id',
                            labelWidth: 100,
                            hidden: is_view=='1' ? false : true,
                            value:  new Date().getFullYear(),
                            editable: false,
                            allowBlank: true,
                            listeners: {
                                select: function (btn) {
                                    //刷新当前表格
                                    loadOption={};
                                    getHbfxDataList();
                                }
                            }
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '模糊查询',
                            itemId: "XM_SEARCH",
                             width: 300,    //762
                            labelWidth: 75,
                            emptyText: '项目单位/编码/名称...',
                            enableKeyEvents: true,
                            listeners: {
                                'keydown': function (self, e, eOpts) {
                                    var key = e.getKey();
                                    if (key == Ext.EventObject.ENTER) {
                                        loadOption={};

                                    }
                                }
                            }
                        }
                    ]
                }
            ],
            items: jsxm_json_common.items_content_rightPanel_items ? jsxm_json_common.items_content_rightPanel_items() :
                [is_view == "1" ? initContentTabGrid() : initContentGrid()]
        });
    }

    /**
     * 树点击节点时触发，刷新content主表格，明细表置为空
     */
    function reloadGrid(param) {
        if (AD_CODE == null || AD_CODE == '') {
            Ext.Msg.alert('提示', '请选择区划！');
            return;
        }
        if (jsxm_json_common.reloadGrid) {
            jsxm_json_common.reloadGrid(param);
        } else {
            loadOption[option+"#"+AD_CODE+"#"+AG_CODE] = 1;
            var grid = DSYGrid.getGrid("contentGrid"+ (option=='1'?'':option));
            if(is_view=='1'&& option!='1'){
                grid = DSYGrid.getGrid("contentGrid"+option);
            }
            var store = grid.getStore();
            var XMXZ_ID = Ext.ComponentQuery.query('treecombobox#XMXZ_SEARCH')[0].getValue();
            var XMLX_ID = Ext.ComponentQuery.query('treecombobox#XMLX_SEARCH')[0].getValue();
            var JSXZ_ID = Ext.ComponentQuery.query('combobox#JSXZ_SEARCH')[0].getValue();
           var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
            var lxnd = Ext.ComponentQuery.query('textfield#LXND_SEARCH')[0].getValue();
            var XMCJSJ = Ext.ComponentQuery.query('textfield#XMCJSJ_SEARCH')[0].getValue();
            //初始化表格Store参数
            store.getProxy().extraParams = {
                AD_CODE: AD_CODE,
                AG_ID: AG_ID,
                AG_CODE: AG_CODE,
                XMXZ_ID: XMXZ_ID,
                XMLX_ID: XMLX_ID,
                JSXZ_ID: JSXZ_ID,
                mhcx: mhcx,
                lxnd: lxnd,
                is_zbx: is_zbx,
                is_cl: is_cl,
                is_wzxt:is_wzxt,
                userCode: userCode,
                wf_id: wf_id,
                node_code: node_code,
                WF_STATUS: WF_STATUS,
                node_type: node_type,
                option:option,
                is_view:is_view,
                ZQXM_TYPE: ZQXM_TYPE,
                XMCJSJ:XMCJSJ
            };
            //刷新
            store.loadPage(1);
        }
    }
    /**
     * @param name 页签名称
     * @return true
     * @author zhuangrx
     * @date 2021/8/12
     * @description 获取页签名称
     */
    function findTabName(name){
        //获取页签panel
        var tbTab = Ext.ComponentQuery.query('panel[itemId="zqxxTab"]')[0];
        if(!isNull(tbTab)){
            //页签循环与传入页签做对比，匹配则返回页签index
            for (var i=0;i<=tbTab.items.length;i++){
                if(tbTab.items.items[i].title ==name){
                    return i;
                }
            }
        }else{
            //否则返回首页
            return 0;
        }
    }
</script>
<script type="text/javascript" src="jsxmlr.js"></script>
<script type="text/javascript" src="/js/debt/xmsySzysGrid.js"></script>
<script type="text/javascript" src="/js/debt/xzzqsdgc.js"></script>
</body>
</html>
