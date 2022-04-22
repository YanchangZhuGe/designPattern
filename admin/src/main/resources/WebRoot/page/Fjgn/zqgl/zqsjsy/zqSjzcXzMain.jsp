<%--
  Created by IntelliJ IDEA.
  User: LENVO
  Date: 2019/7/10
  Time: 14:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>

    <title>新增债券项目实际支出</title>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">

</head>
<body>

</body>

<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/page/debt/gxdz/12_tj/peLockCheck.js"></script>
<script type="text/javascript" src="/page/debt/zqgl/zqsjsy/popgridsjzc.js"></script>
<%--引入会计核算取凭证号--%>
<script type="text/javascript" src="PopupGridForKjhsPzh.js"></script>
<%--收款单位取招投标的建设单位--%>
<script type="text/javascript" src="PopupGridForSkdw.js"></script>
<%--收款人相关信息--%>
<script type="text/javascript" src="PopupGridForSkr.js"></script>
<script type="text/javascript" >
    //var json_debt_yhzh = [];
    //天津个性化url参数：12
    /*var GxdzUrlParam=getQueryParam("GxdzUrlParam");
    var url_xm_id = getQueryParam("url_xm_id");  //从单位新首页跳转过来 打开变更弹窗*/
    var GxdzUrlParam ="${fns:getParamValue('GxdzUrlParam')}";
    var url_xm_id ="${fns:getParamValue('url_xm_id')}";
    var zjsyqk_type ="${fns:getParamValue('zjsyqk_type')}";//资金使用情况登记拆分为2个功能：zjsyqk_type=1 项目资金转拨登记 和 zjsyqk_type=2 项目实物工作量登记
    // 自定义参数
    var button_name = ''; // 当前操作按钮名称id
    var button_text = ''; // 当前操作按钮名称text
    var editValue = true; // 附件是否可编辑
    var is_showxmbtn=1;
    var sysAdcode = '${fns:getSysParam("ELE_AD_CODE")}';//省级区划
    //支出类型
    var json_debt_zclx = [
        {id: "1", code: "1", name: "资金转拨"},
        {id: "2", code: "2", name: "实际支出"}
    ];
    //供应商类型
    var json_debt_gyslx = [
        {id: "1", code: "1", name: "法人"},
        {id: "2", code: "2", name: "自然人"}
    ];
    //20210420_zhuangrx_获取银行流水store方法
    var SjzcyhStore = getYhlsStore('/getyhlsSjzcTb.action' );
    //会记核算信息取记账凭证号
//    var jzpzhStore = getJzpzhStore('/getZfpzhByKjhs.action' );
    //20210521 fzd 获取角色类型
    var dwRoleType = "${fns:getParamValue('dwRoleType')}";
    //20210525 guoyf 根据收款账户查找收款人信息及开户行
    var skrStore = getSkrStore('/getSkrxx.action' );
    // 迁移收款单位
    var skdwStore = getSkdwStore('/findZtbJsdwxx.action?ZB_TYPE=1');
    var save_button = [
        {
            text: '保存.0',
            name: 'save',
            handler: function (btn) {
                submitZqxmSjzcTb(btn);
            }
        },
        {
            text: '取消',
            name: 'CLOSE',
            handler: function (btn) {
                btn.up('window').close();
            }
        }
    ];

    // 按钮是否展示
    var button = save_button;
    var yhzhStore=  DebtEleStoreTable('DEBT_V_YH_ZJSZLS');

    // 获取session 数据
    var ad_code = '${sessionScope.ADCODE}';  // 获取地区名称
    var nowDate = '${fns:getDbDateDay()}';
    var USER_AG_CODE='${sessionScope.AGCODE}';
    var USER_AG_ID = '${sessionScope.AGID}';

    var dw_AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");

    // 获取URL参数
  /*  var wf_id = getQueryParam("wf_id"); // 当前工作流流程id
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
    //是否隐藏资金使用单位 url参数（用户自定义显示与否）
  /*  var isHiddenDw = getQueryParam("isHiddenDw");
    if(isHiddenDw==null || isHiddenDw == '' || typeof isHiddenDw =='undefined'){
        isHiddenDw = false;
    }else{
        isHiddenDw = true;
    }*/
    var isHiddenDw ="${fns:getParamValue('isHiddenDw')}";
    if(isNull(isHiddenDw)){
        isHiddenDw = false;
    }else{
        isHiddenDw = true;
    }
    //部分字段名称修改 0:不修改;1:修改(1：广东；2：北京)
/*
    var nameUpdate = getQueryParam("nameUpdate");
*/
    var nameUpdate ="${fns:getParamValue('nameUpdate')}";
    if(typeof nameUpdate == 'undefined' || null==nameUpdate ){
        nameUpdate = '0';
    }
    //新增债券实际支出id，新录一笔数据的时候生成
    var xzzqSjzcId;
    // 自定义json 数据
    var km_year = nowDate.substr(0,4);
    var km_condition = km_year <= 2017 ? " <= '2017' " :" = '"+ km_year +"' ";
    var zcgnfl_store = DebtEleTreeStoreDB('EXPFUNC',{condition: "and year " + km_condition});
    var zcjjfl_store = DebtEleTreeStoreDB('EXPECO', {condition: "and year " + km_condition});
    var ZCLX_TYPE=1;//20210512李月支出类型默认为资金拨付，同时控制项目供应商为空
    //20210519 fzd 增加资金来源类型
    var store_debt_zjly = DebtEleStore([
        {id: "1", code: "1", name: "专项债券资金"},
        {id: "2", code: "2", name: "财政安排资金"},
        {id: "3", code: "3", name: "配套融资资金"},
        {id: "4", code: "4", name: "其他资金"},
        {id: "5", code: "5", name: "专项债券（库款垫付资金）"}
    ]);
    var zqSjzcXzMain_toolbar_json = {
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
                        text: '录入',
                        name: 'INPUT',
                        icon: '/image/sysbutton/add.png',
                        handler: function (btn) {
                            button_name = btn.name;
                            button_text = btn.text;
                            editValue = true;
                            button = save_button;
                            //20210527 fzd 点击录入时清除来自首页的url_xm_id
                            url_xm_id='';
                            zqbfmxInfo_select_window(btn);
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
                                button_name = btn.name;
                                button_text = btn.text;
                                editValue = true;
                                button = save_button;
                                xzzqSjzcId = records[0].get('SJZC_ID');
                                //根据具体项目来控制工程类别的下拉框
                                var ZQ_ID=records[0].getData().FIRST_ZQ_ID;
                                XM_ID=records[0].getData().XM_ID;
                                gclb_store=DebtEleTreeStoreDBTable('dsy_v_ele_gclb_zc',{condition: " and xm_id = '"+XM_ID+"' AND ZQ_ID = '"+ZQ_ID+"' "});
                                if(isNull(XM_ID)){
                                    yhzhStore=DebtEleStoreTable('DEBT_V_YH_ZJSZLS',{condition: " and 1=0  "});
                                }else{
                                    yhzhStore=DebtEleStoreTable('DEBT_V_YH_ZJSZLS',{condition: " and xm_id = '"+XM_ID+"'  "});
                                }
                                zqxmSjzc_insert_window(btn);
                                skdwStore.getProxy().extraParams['XM_ID'] = XM_ID;
                                skdwStore.load();
                                var gclb_id=records[0].getData().GCLB_ID;
                                //获取银行账号并赋值
                                var yhzhsz=records[0].getData().YHZHSZ;
                                Ext.ComponentQuery.query('treecombobox[name="GCLB_ID"]')[0].setValue(gclb_id);
                                Ext.ComponentQuery.query('combobox[name="YHZHSZ"]')[0].setValue(yhzhsz);
                                var xmzxFormRecords = records[0].getData();
                                var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_zqxmSjzcTb_form"]')[0];
                                xmtztbForm.getForm().setValues(xmzxFormRecords);
                               //修改时重新赋值zq_id
                                xmtztbForm.getForm().findField("ZQ_ID").setValue(ZQ_ID);
                                // 项目资金划拨登记计算可支出金额
                                if(zjsyqk_type == '1'){
                                    var kzc_amt = records[0].getData().BF_AMT - records[0].getData().YZC_AMT;
                                    xmtztbForm.getForm().findField("KZC_AMT").setValue(kzc_amt);
                                }
                                var SS_AG_ID = xmtztbForm.getForm().findField('SS_AG_ID').getValue();
                        /*        if(SS_AG_ID != null && SS_AG_ID != "" && SS_AG_ID != 'undefined'){
                                    xmtztbForm.getForm().findField("XMGYF").setValue('');
                                    xmtztbForm.getForm().findField("XMGYF").setReadOnly(true);
                                    xmtztbForm.getForm().findField("XMGYF").setFieldStyle('background:#E6E6E6');
                                }
                                var XMGYF = xmtztbForm.getForm().findField('XMGYF').getValue();
                                if(XMGYF != null && XMGYF != "" && XMGYF != 'undefined'){
                                    xmtztbForm.getForm().findField("SS_AG_ID").setValue('');
                                    xmtztbForm.getForm().findField("SS_AG_ID").setReadOnly(true);
                                    xmtztbForm.getForm().findField("SS_AG_ID").setFieldStyle('background:#E6E6E6');
                                }*/
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            delZqxmSjzcInfo(btn);
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
                    {
                        xtype: 'button',
                        text: '接受流水数据',
                        icon: '/image/sysbutton/down.png',
                        // hidden: '44' == sysAdcode ? false : true, // 广东个性
                        handler: function (btn) {
                            if(typeof window_GD_zfls != 'undefined'){
                                window_GD_zfls.show("接受流水数据");
                            }
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
                                button_name = btn.name;
                                button_text = btn.text;
                                editValue = true;
                                button = save_button;
                                xzzqSjzcId = records[0].get('SJZC_ID');
                                //根据具体项目来控制工程类别的下拉框
                                var ZQ_ID=records[0].getData().FIRST_ZQ_ID;
                                XM_ID=records[0].getData().XM_ID;
                                gclb_store=DebtEleTreeStoreDBTable('dsy_v_ele_gclb_zc',{condition: " and xm_id = '"+XM_ID+"' AND ZQ_ID = '"+ZQ_ID+"' "});
                                if(isNull(XM_ID)){
                                    yhzhStore=DebtEleStoreTable('DEBT_V_YH_ZJSZLS',{condition: " and 1=0  "});
                                }else{
                                    yhzhStore=DebtEleStoreTable('DEBT_V_YH_ZJSZLS',{condition: " and xm_id = '"+XM_ID+"'  "});
                                }
                                zqxmSjzc_insert_window(btn);
                                skdwStore.getProxy().extraParams['XM_ID'] = XM_ID;
                                skdwStore.load();
                                var gclb_id=records[0].getData().GCLB_ID;
                                //获取银行账号并赋值
                                var yhzhsz=records[0].getData().YHZHSZ;
                                Ext.ComponentQuery.query('treecombobox[name="GCLB_ID"]')[0].setValue(gclb_id);
                                Ext.ComponentQuery.query('combobox[name="YHZHSZ"]')[0].setValue(yhzhsz);
                                //修改时重新赋值zq_id
                                var xmzxFormRecords = records[0].getData();
                                var xmtztbForm = Ext.ComponentQuery.query('form[itemId="item_zqxmSjzcTb_form"]')[0];
                                xmtztbForm.getForm().findField("ZQ_ID").setValue(ZQ_ID);
                                xmtztbForm.getForm().setValues(xmzxFormRecords);
                                // 项目资金划拨登记计算可支出金额
                                if(zjsyqk_type == '1'){
                                    var kzc_amt = records[0].getData().BF_AMT - records[0].getData().YZC_AMT;
                                    xmtztbForm.getForm().findField("KZC_AMT").setValue(kzc_amt);
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            delZqxmSjzcInfo(btn);
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
                        text: zjsyqk_type == '1' ? '确认':'审核',
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
                        text: zjsyqk_type == '1' ? '撤销确认':'撤销审核',
                        hidden: false,
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

    //获取银行流水信息
    function getYhlsStore(dataURL) {
        var store = Ext.create('Ext.data.Store', {
            fields: ["GUID", "CODE", "NAME", "AD_NMAE", "ACC_NO", "ACC_NAME", "ACC_BANK_NAME", "REFNBR", "ETYTIM", "TSDAMT","RPYACC","RPYNAM","NUSAGE"],
            remoteSort: true,// 后端进行排序
            proxy: {// ajax获取后端数据
                type: "ajax",
                method: "POST",
                url: dataURL,
                extraParams:{

                },
                reader: {
                    type: "json",
                    root: "list",
                    totalProperty: "totalcount"
                },
                simpleSortMode: true
            },
            autoLoad: true
        });
        return store;
    }


    /**
     *
     * @param dataURL
     * @returns获得支出凭证号数据
     */
    function getJzpzhStore(dataURL) {
        var store = Ext.create('Ext.data.Store', {
            fields: ["VOU_ID", "agName", "FISCAL_YEAR", "ACCT_PERIOD", "ACCT_SET_CODE",
                "AGENCY_ACCT_VOUCHER_TYPE", "VOUCHER_NO", "POSTER",
                "POSTER_DATE", "INPUTER", "INPUTER_DATE", "FI_LEADER", "VOUCHER_ABS", "create_time"],
            remoteSort: true,// 后端进行排序
            proxy: {// ajax获取后端数据
                type: "ajax",
                method: "POST",
                url: dataURL,
                reader: {
                    type: "json",
                    root: "list",
                    totalProperty: "totalcount"
                },
                simpleSortMode: true
            },
            autoLoad: true
        });
        return store;
    }

    /**
     *
     * @param dataURL
     * @returns获得收款单位数据
     */
    function getSkdwStore(dataURL) {
        var store = Ext.create('Ext.data.Store', {
            fields:  ["ID", "ZBDW_AG_ID", "AG_NAME", "XM_CODE","ZB_DATE", "ZB_TYPE",
                "ZBDW", "TYSHXY_CODE", "ZB_AMT" ],
            remoteSort: true,// 后端进行排序
            proxy: {// ajax获取后端数据
                type: "ajax",
                method: "POST",
                url: dataURL,
                reader: {
                    type: "json",
                    root: "list",
                    totalProperty: "totalcount"
                },
                simpleSortMode: true
            },
            autoLoad: true
        });
        return store;
    }

    /**
     *
     * @param dataURL
     * @returns获得收款人数据
     */
    function getSkrStore(dataURL) {
        var store = Ext.create('Ext.data.Store', {
            fields:  ["ID", "ACC_NAME", "ACC_NO", "ACC_BANK_NAME" ],
            remoteSort: true,// 后端进行排序
            proxy: {// ajax获取后端数据
                type: "ajax",
                method: "POST",
                url: dataURL,
                reader: {
                    type: "json",
                    root: "list",
                    totalProperty: "totalcount"
                },
                simpleSortMode: true
            },
            autoLoad: true
        });
        return store;
    }

</script>
<script type="text/javascript" src="zqSjzcXzMain.js"></script>
</html>
