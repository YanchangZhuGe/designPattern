<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ page import="com.bgd.platform.util.service.SpringContextUtil" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>新增专项债券需求主界面</title>
    <style type="text/css">
        .grid-cell-font {
            color: blue;
        }

        .label-color {
            color: red;
            font-size: 100%;
        }

        #text_zre{
            color: red;
            text-align: center;
            font-size: 15px;
            font-weight:bold
        }

        html, body {
            overflow-y: hidden;
        }
    </style>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript" src="/js/debt/Map.js"></script>
<script type="text/javascript" src="/js/debt/xmInfo.js"></script>
<script type="text/javascript" src="/js/debt/xmsySzysGrid.js"></script>
<script type="text/javascript" src="/js/debt/xzzqsdgc.js"></script>

<script type="text/javascript" src="xzzqJhsbMain.js"></script>
<script type="text/javascript" src="xzzqJhsbYhs.js"></script>

<script type="text/javascript">
    // 获取 session 参数值
    var userName_jbr = top.userName;
    var userName = '${sessionScope.USERNAME}';  //获取用户名称
    var userCode = '${sessionScope.USERCODE}';  //获取用户编码
    var USER_AD_CODE = '${sessionScope.ADCODE}';  //获取地区code
    var userAdCode = (USER_AD_CODE.length == 2 || USER_AD_CODE.length == 4) && !USER_AD_CODE.endWith("00")
        ? USER_AD_CODE.concat("00") : USER_AD_CODE; //获取登录用户区划，省级，市级权限转化为本级区划
    var AD_NAME = '${sessionScope.ADNAME}';  //获取地区名称
    var BXFGBS_XX = '${fns:getSysParam("BXFGBS_XX")}';// 20200923 guoyf 较验本息覆盖倍数下限
    var BXFGBS_SX = '${fns:getSysParam("BXFGBS_SX")}';// 20201116 guoyf 较验本息覆盖倍数上限
    //20201126liye资金投向与项目类型store
    var zwxmlx_store = DebtEleTreeStoreDB("DEBT_ZWXMLX");
    // 获取 url 参数值
    var is_fxjh = getQueryParam("is_fxjh");//是否是发行计划
    var is_zxzq = getQueryParam("is_zxzq");//是否是发行计划
    var zjtxly_store=is_zxzq=='1'?DebtEleTreeStoreDB("DEBT_ZJTXLY",{condition: "AND CODE !='00'"}):DebtEleTreeStoreDB("DEBT_ZJTXLY");
    var wf_id = getQueryParam("wf_id");//当前工作流流程id
    var wfd_id = getQueryParam("wfd_id");//当前工作流流程id
    var node_code = getQueryParam("node_code");//当前工作流节点id
    var menucode = getQueryParam("menucode");
    var node_type = getQueryParam("node_type");//当前节点名称
    var WF_STATUS = getQueryParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var is_zjfp = getQueryParam("is_zjfp");
    if (typeof is_zjfp == 'undefined' || null == is_zjfp) {
        is_zjfp = 0;
    }

    // 获取系统参数值
    var sysAdcode = '${fns:getSysParam("ELE_AD_CODE")}'; // 省级区划
    var nowDate = '${fns:getDbDateDay()}';  //当前日期
    var DEBT_ZXXEKZFS = '${fns:getSysParam("DEBT_ZXXEKZFS")}'; // 专项限额控制方式：0：不分类控制；1：分类控制
    var sys_right_model = '${fns:getSysParam("SYS_RIGHT_MODEL")}'; //是否启用新工作流（添加业务处室审核）
    var HAVE_SFJG = '${fns:getSysParam("HAVE_SFJG")}';//是否含有第三方机构评价
    var IS_XMBCXX = '${fns:getSysParam("IS_XMBCXX")}';  //获取系统参数 项目补充信息是否显示
    var SYS_ZXZQXT_KZS_CHECK = '${fns:getSysParam("SYS_ZXZQXT_KZS_CHECK")}'; //系统参数，专项债券系统是否校验控制数
    var SYS_XZZQJH_XE_CHECK = '${fns:getSysParam("SYS_XZZQJH_XE_CHECK")}'; //系统参数：是否必须校验限额,如SYS_XZZQJH_XE_CHECK=0，在限额资金分配初审添加限额校验
    var is_zxzqxt = '${fns:getSysParam("IS_ZXZQXT")}';  //获取系统参数 是否是专项债券系统
    var GxdzUrlParam =  "${fns:getParamValue('GxdzUrlParam')}";
    //url参数 是否是专项债券  0:不是；1：专项；2：一般。
    if (wfd_id != null && wfd_id != '' && wfd_id.toLowerCase() != 'null') {
        wf_id=(sys_right_model==1&&((HAVE_SFJG=='1' && is_fxjh=='3')
            ||(HAVE_SFJG=='2' && is_fxjh=='1')||(HAVE_SFJG=='3' &&(is_fxjh=='3' || is_fxjh=='1')) ||is_fxjh=='0'||is_fxjh=='5'||HAVE_SFJG=='0') ? wfd_id:wf_id);
    }
    var is_zxzq = getQueryParam("is_zxzq");
    if (typeof is_zxzq == 'undefined' || null == is_zxzq) {
        is_zxzq = '0';
    }
    // 自定义参数值
    var s_is_xmzbj = [
        {id: '0', code: '0', name: '否'},
        {id: '1', code: '1', name: '是'}
    ];
    // 是否已发债
    var SF_STORE = DebtEleStore([
        {id: "0",code: "0",name: "是"},
        {id: "1",code: "1",name: "否"}
        ]);
    var newValue = 1;
    var is_xmzbj;
    var reportUrl = '';
    var ywcsbl = false;//控制业务处室必录开关
    var bond_type_id = null;//申请类型1:一般债券 2:专项债券
    var json_zt = json_debt_zt1;//当前状态下拉框json数据
    var button_name = '';//当前操作按钮名称text
    var button_status = '';//当前操作按钮的name，标识按钮状态
    var SET_YEAR = new Date().getFullYear();//当前默认年度
    var connNdjh = '';//项目是否已经申报年度计划
    var connZwxx = '';//项目是否被债务信息引用
    var maxyear;//最新年度
    var maxyear_last;//第二新年度
    var select_year;//第二新年度
    var pczqlx;//批次对应的债券类型
    var BATCH_YEAR = '';//限额库选择批次时的年度过滤
    var BATCH_BOND_TYPE_ID = '';//限额库选择批次时的类型过滤
    var is_tdcb = false; // 项目类型是否为土地储备
    var q_title = null; //导出使用
    var XM_ID;
    var is_fdq; // 判断是否为辅导期还是其他
    if (SYS_XZZQJH_XE_CHECK == '0' && (is_fxjh == 1 || is_fxjh == 3)) {
        is_fdq = 1;
    } else if (is_fxjh == 1 || is_fxjh == 3) {
        is_fdq = 0;
    }
    //动态加载填报、修改、显示页签
    var tab_items = {};
    //动态加载审核时专项债券系统打分页签
    var tab_items_sh = {'jbqk': {}, 'bcsb': {}, 'tzjh': {}, 'szys': {}, 'xmfj': {}};
    //第三方机构上传附件使用
    var tab_items_scfj = {'jbqk': {}, 'bcsb': {}, 'tzjh': {}, 'szys': {}};

    var IS_SHOW_SPEC_UPLOAD_BTN = ''; //系统参数：是否必须校验限额
    var IS_EDITABLE_LLEVEL = ''; //系统参数，是否可以修改申请金额
    var IS_SHOW_ZBXM = '';//发行计划申报时是否允许增补项目按钮
    $.ajax({
        type: "POST", url: 'getParamValueAll.action',
        async: false, //设为false就是同步请求
        cache: false,
        success: function (data) {
            data = eval(data);
            IS_SHOW_SPEC_UPLOAD_BTN = data[0].IS_SHOW_SPEC_UPLOAD_BTN;
            IS_EDITABLE_LLEVEL = data[0].IS_EDITABLE_LLEVEL;
            IS_SHOW_ZBXM = data[0].IS_SHOW_ZBXM;
        }
    });

    //是否加载全部区划
    var v_child = '0';
    if (node_type == "jhtb" || node_type == "jhsh" || node_type == "jhfh"
        || node_type == "jhhz" || node_type == "xmpx" || node_type == "xmtz") {
        v_child = '1'; // 以上node隐藏区划树，默认选中底级区划
    }
    if (node_type == "jhfh" && is_zjfp == 2) {
        v_child = '0';
    }
    //20210924 zhuangrx  十大工程个性显示判断
    var is_show=sysAdcode=='42'?true:(sysAdcode=='21' || sysAdcode =='41' ? false:1);
    // 数据字典：基础数据
    var BXNL_ID_Store = DebtEleStore(json_debt_bxnl); // 基础数据：变现能力
    var ywcs_store = DebtEleStoreTable('DSY_V_ELE_FINDEP', {
        condition: " AND (extend1 = '" + // 基础数据：业务处室
            (USER_AD_CODE.length < 6 && USER_AD_CODE.substr(-2, 2) != '00' ? USER_AD_CODE + "00" : USER_AD_CODE) + "' OR EXTEND1 IS NULL ) "
    });

    //上报审核状态，0未审核，1已审核
    var store_shyj = DebtEleStore([
        {code: '0', name: '不通过'},
        {code: '1', name: '通过'}
    ]);
    var store_tgzt = DebtEleStore([
        {id: '0', name: '未评审'},
        {id: '1', name: '已通过'},
        {id: '2', name: '未通过'}
    ]);
    // 月份
    var json_debt_yf = [
        {"id": "01", "code": "01", "name": "1月"},
        {"id": "02", "code": "02", "name": "2月"},
        {"id": "03", "code": "03", "name": "3月"},
        {"id": "04", "code": "04", "name": "4月"},
        {"id": "05", "code": "05", "name": "5月"},
        {"id": "06", "code": "06", "name": "6月"},
        {"id": "07", "code": "07", "name": "7月"},
        {"id": "08", "code": "08", "name": "8月"},
        {"id": "09", "code": "09", "name": "9月"},
        {"id": "10", "code": "10", "name": "10月"},
        {"id": "11", "code": "11", "name": "11月"},
        {"id": "12", "code": "12", "name": "12月"}
    ];

    var json_debt_zjfp1 = [
        {id: "001", code: "001", name: "未分配"},
        {id: "002", code: "002", name: "已分配"},
        {id: "004", code: "004", name: "被退回"}
    ];
    var json_debt_zjfp2 = [
        {id: "001", code: "001", name: "未审核"},
        {id: "002", code: "002", name: "已审核"}
    ];
    var yb_zx_json = [
        {id: "01", code: "01", name: "01 一般债券"},
        {id: "02", code: "02", name: "02 专项债券"}
    ];
    var sbpc_store = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'xzzq_sbpcReflct.action?method=getSbpcTreeStore',
            extraParams: {
                BATCH_YEAR : BATCH_YEAR,
                BOND_TYPE : BATCH_BOND_TYPE_ID.substr(0, 2),
                AD_CODE : AD_CODE,
                is_fxjh : is_fxjh,
                TYPE : 'xzzq'
            },
            reader: {
                type: 'json'
            }
        },
        root: {
            expanded: true,
            text: "全部",
            children: [
                {text: "需求批次", id:"需求批次", leaf: true}
            ]
        },
        model: 'treeModel',
        autoLoad: true
    });

    /**
     * 通用配置json，用于存储全局配置，
     */
    var zqxm_json_common = {
        jhtb: 'xzzqJhsblr.js',//新增债券计划填报
        jhsh: 'xzzqJhsbsh.js',//新增债券计划审核
        // jhfh: 'xzzqjhfh.js',//新增债券计划复核
        // jhpx: 'xzzqjhpx.js',//新增债券计划排序
        // jhhz: 'xzzqjhhz.js',//新增债券计划汇总
        // jhsb: 'xzzqjhsb.js',//新增债券计划上报
        // jhxjsh: 'xzzqjhxjsh.js',//新增债券计划下级审核
        // jhxjshNew: 'xzzqjhxjshNew.js',//新增债券计划下级审核（新加了审核功能：审核成功够进行评审打分，新加了评审打分弹出框，根据后台数据库数据动态加载评审打分配置）
        // xmtz: 'xzzqxmtz.js',//项目调整录入
        // xmtzsh: 'xzzqxmtzsh.js'//项目调整审核
    };
    /**
     * 新增债券表头信息
     */
    var HEADERJSON = [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "ID", width: 150, type: "string", text: "唯一ID", hidden: true},
        {dataIndex: "AG_NAME", width: 250, type: "string", text: "申报单位"},
        {
            dataIndex: "XM_NAME", width: 330, type: "string",text: "项目名称",
            locked: (is_zxzqxt=='1'&&(node_type=='jhhz'||node_type=='jhsb'))?true:false,
            renderer: function (data, cell, record) {
                var result = '<a href="javascript:void(0);" onclick="initWin_xmInfo(\'' + record.get('XM_ID') + '\',\'' + record.get('ID') + '\')">' +data + '</a>';
                return result;
            }
        },
        {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
        {dataIndex: "BILL_YEAR", type: "string", text: "年度"},
        {dataIndex: "BILL_MONTH", type: "string", text: "月份",hidden:is_fxjh==4?false:true,
            renderer:function(value){
                return Ext.util.Format.number(value,'00')+"月";
            }
        },
        {dataIndex: "ZQQX_NAME", width: 100, type: "string", text: "债券期限"},
        {
            dataIndex: "IS_FXJH", type: "string", text: "计划类型",hidden: true,
            renderer: function (value) {
                return value == 0 ? '年度计划' : '发行计划';
            }
        },
        //资金分配初审和终审功能，fp_amt实为申请金额，APPLY_AMOUNT1实为分配金额
        {
            dataIndex: is_zjfp==0 ? "APPLY_AMOUNT1":"FP_AMT", width: 160, type: "float", text: "申请金额（万元）", summaryType: 'sum',
            /*editor: IS_EDITABLE_LLEVEL == '0'?null:{
                xtype: "numberfield",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                allowBlank: false,
                maxValue:9999999999,
                decimalPrecision:6,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },*/
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {dataIndex: "IS_SAVE",  type: "string", text: "是否保存",hidden:true},
        {
            dataIndex: "APPLY_AMOUNT1", width: 160, type: "float", text: "分配金额(万元)", summaryType: 'sum',
            hidden:is_zjfp==0,
            disabled:is_zjfp==0,
            editor: is_zjfp!=1 ? null:{
                xtype: "numberfield",
                emptyText: '0.00',
                hideTrigger: true,
                mouseWheelEnabled: true,
                allowBlank: false,
                decimalPrecision:2,
                editable:true,
                maxValue: 9999999999,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "APPLY_ZBJ_AMT",
            width: 160,
            type: "float",
            text: "项目资本金(万元)",
            hidden: false,
            summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {dataIndex: "BOND_TYPE_NAME", type: "string", text: "申请类型"},
        {
            dataIndex: "RETURN_CAPITAL",
            width: 160,
            type: "float",
            text: "其中用于偿还本金(万元)",
            hidden: true,
            summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {dataIndex: "SBBATCH_NO_NAME", width: 150, type: "string", text: "申报批次"},
        {dataIndex: "BILL_NO", width: 150, type: "string", text: "申报单号", hidden: true},
        {dataIndex: "APPLY_DATE", type: "string", text: "申报日期"},
        {dataIndex: "APPLY_INPUTOR", type: "string", text: "经办人", hidden: true},
        {dataIndex: "LX_YEAR", type: "string", text: "立项年度"},
        {dataIndex: "JSXZ_NAME", type: "string", text: "建设性质", hidden:true},
        {dataIndex: "XMXZ_NAME", width: 200, type: "string", text: "项目性质",hidden: true},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型"},
        {
            dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算(万元)",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {dataIndex: "START_DATE_PLAN", width: 120, type: "string", text: "计划开工日期",hidden:true},
        {dataIndex: "END_DATE_PLAN", width: 120, type: "string", text: "计划竣工日期",hidden:true},
        {dataIndex: "BUILD_STATUS_NAME", type: "string", text: "建设状态"},
        {dataIndex: "START_DATE_ACTUAL", width: 120, type: "string", text: "开工日期"},
        {dataIndex: "END_DATE_ACTUAL", width: 120, type: "string", text: "竣工日期"},
        {dataIndex: "FILTER_STATUS_NAME", type: "string", text: "项目状态",hidden: true},
        {dataIndex: "FIRST_BILL", type: "string", text: "是否第一单标志", hidden: true},
        {
            text: "上报审核状态", dataIndex: "SBZT", type: "string", width: 120, hidden: true
        },
        {text: "上报审核级别", dataIndex: "SB_AD_NAME", type: "string", hidden: true},
        {text: "上报审核意见", dataIndex: "SBYJ", width: 300, type: "string"},
        {
            dataIndex: "STATUS", width: 200, type: "string", text: "状态",
            renderer: function (value, metaData, record) {
                /*填报：未送审：bill表：IS_END=0 NODE_CURRENT_ID=1 IS_FXJH=0/1
                 审核：未审核：bill表：IS_END=0 NODE_CURRENT_ID=2 IS_FXJH=0/1
                 复核：未复核：bill表：IS_END=0 NODE_CURRENT_ID=3 IS_FXJH=0/1
                 汇总：未汇总：bill表：IS_END=1 STATUS =20 IS_FXJH=0/1
                 上报：上报中：bill表：JHGL_END=0 STATUS =25 IS_FXJH=0/1
                 BILL表：SB_AD_CODE不为空，则SB_AD_CODE下级审核不通过
                 区划（关联汇总表AD_LEVEL）未上报/已审核：001（关联汇总表WF_STATUS ）
                 区划（关联汇总表AD_LEVEL）未审核：002（关联汇总表WF_STATUS ）
                 区划（关联汇总表AD_LEVEL）被退回：004（关联汇总表WF_STATUS ）
                 结束：bill表：JHGL_END=1 IS_FXJH=0/1
                 */
                if (record.get('IS_VALID') == 0) {
                    return '已退出';
                }
                if (record.get('JHGL_END') == 1) {
                    if (record.get('IS_USED') == 1) {
                        if(is_fxjh==0){//需求库
                            return '完成新增债券项目管理年度计划流程并已被使用';
                        }else if (is_fxjh==1){
                            return '完成新增债券项目管理发行计划流程并已被使用';
                        }else if (is_fxjh==3){
                            return '完成储备项目管理流程并已被使用';
                        }else if (is_fxjh==4){
                            return '完成发行项目管理流程并已被使用';
                        }else{
                            return '完成发行项目管理流程并已被使用';
                        }
                    }
                    if (value >= 25 && record.get('SB_AD_CODE')) {
                        return record.get('SB_AD_NAME') + '下级审核不通过';
                    }
                    if(is_fxjh==0){//需求库
                        return '完成新增债券项目管理年度计划流程';
                    }else if (is_fxjh==3){
                        return '完成储备项目管理流程';
                    }else if (is_fxjh==1){
                        return '完成新增债券项目管理发行计划流程';
                    }else if (is_fxjh==4){
                        return '完成发行项目管理流程';
                    }else{//限额库
                        return '完成发行项目管理流程';
                    }
                }
                if (record.get('IS_END') == 0) {
                    if (record.get('NODE_CURRENT_ID') == 1) {
                        return '未送审';
                    }
                    if (record.get('NODE_CURRENT_ID') == 2) {
                        return '未复核';
                    }
                    if (record.get('NODE_CURRENT_ID') == 3) {
                        return '未审核';
                    }
                    if (record.get('NODE_CURRENT_ID') == null || record.get('NODE_CURRENT_ID') == '')  {
                        if(record.get('IS_FXJH') == 0){//需求库
                            return '增补年度项目未审核';
                        }else if (record.get('IS_FXJH')==3){
                            return '完成储备项目管理流程并已被使用';
                        }else if (record.get('IS_FXJH')==1){
                            return '完成新增债券项目管理发行计划流程并已被使用';
                        }else if (record.get('IS_FXJH')==4){
                            return '完成发行项目管理流程并已被使用';
                        }else{//限额库
                            return '增补限额项目未审核';
                        }
                    }
                } else {
                    if (value == 20) {
                        return '未汇总';
                    }
                    if (value == 25) {
                        if (record.get('SB_AD_CODE')) {
                            return record.get('SB_AD_NAME') + '下级审核不通过';
                        }
                        if (record.get('HZ_WF_STATUS') == '001') {
                            return record.get('AD_LEVEL_NAME') + '未上报';
                        }
                        if (record.get('HZ_WF_STATUS') == '002') {
                            return record.get('AD_LEVEL_NAME') + '未审核';
                        }
                        if (record.get('HZ_WF_STATUS') == '004') {
                            return '退回至' + record.get('AD_LEVEL_NAME');
                        }
                        return '找不到汇总上报信息';
                    }
                    if (value == 30) {
                        return '已上报';
                    }
                }
            }
        },
        {dataIndex: "REMARK", type: "string", width: 150, text: "备注"},
        {dataIndex: "IS_TZ", type: "string", width: 150, text: "是否调整",hidden:true}
        /*{dataIndex: "IS_END", type: "string", width: 150, text: "IS_END"},
        {dataIndex: "MB_ID", type: "string", width: 150, text: "MB_ID"}*/
    ];

    /**
     * 新增债券汇总表头信息
     */
    var HEADERJSON_HZ = [//年度、地区、批次号、汇总日期、明细条数、申请类型、申请日期、经办人、上报级次
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "FXPC_NAME", width: 120, type: "string", text: "批次号"},
        {dataIndex: "FXPC_YEAR", width: 120, type: "string", text: "年度", hidden: true},
        {dataIndex: "BATCH_NO", width: 120, type: "string", text: "批次batch_no", hidden: true},
        {dataIndex: "AD_LEVEL", width: 120, type: "string", text: "上报级别", hidden: true},
        {dataIndex: "AD_NAME", width: 100, type: "string", text: "地区"},
        {dataIndex: "CREATE_DATE", width: 150, type: "string", text: "汇总日期"},
        {
            dataIndex: "DETAIL_NUM", width: 100, type: "int", text: "明细条数",
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000');
            }
        },
        {
            dataIndex: "APPLY_AMOUNT_TOTAL", width: 150, type: "float", text: "申请金额（万元）",
            summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {dataIndex: "CREATE_USER_NAME", width: 150, type: "string", text: "经办人", hidden: true},
        {
            dataIndex: "AD_LEVEL_NAME", width: 150, type: "string", text: "上报级别",
            renderer: function (value, cell, record) {
                var ad_level = record.get('AD_LEVEL');
                if (ad_level && ad_level == '87') {
                    return '中央级';
                }
                return value;
            },
            hidden: true
        },
        {
            dataIndex: "SHYJ", width: 150, type: "string", text: "审核意见",
            renderer: function (value, cell, record) {
                var wf_status = record.get('WF_STATUS');
                if (wf_status && wf_status == '002') {
                    return '';
                }
                return value;
            },
            hidden: true
        }
    ];

    // TODO 录入页面全局参数

    var newValue = 1;
    bond_type_id = null;
    var is_xz = false;
    var is_zb = false;

    var json_debt_isorno = [
        {id: "0", code: "0", name: "否"},
        {id: "1", code: "1", name: "是"}
    ];

    /*基准利率类型*/
    var is_xfx_store = [
        {id: "0", name: "否"},
        {id: "1", name: "是"}
    ];
    //专项债券，需求申报是否调整
    var is_tz_json = [
        {id: '0', code: '0', name: '否'},
        {id: '1', code: '1', name: '是'}
    ];
    var s_is_xmzbj = [
        {id: '0', code: '0', name: '否'},
        {id: '1', code: '1', name: '是'}
    ];
    var is_xmzbj;
    var monthStore = DebtEleStore(json_debt_yf);
    var condition = ' and 1=1 ';
//    var zjtxly_store = DebtEleTreeStoreDB("DEBT_ZJTXLY");//20201126李月资金投向领域
    var zwxmlx_store = DebtEleTreeStoreDB("DEBT_ZWXMLX", {condition: condition});
    var xmxz_store = DebtEleTreeStoreDB("DEBT_ZJYT", {condition: is_zxzqxt == '1' ? " and code !='010101'  and code!='0102' " : "  and code!='0102'  "});
    var km_condition = (is_fxjh == 0 || is_fxjh == 2 || is_fxjh == 3) ? SET_YEAR + 1 <= 2017 ? " <= '2017' " : " = '" + (1 + SET_YEAR) + "' " :
        SET_YEAR <= 2017 ? " <= '2017' " : " = '" + (SET_YEAR) + "' ";
    var zwsrkm_store = DebtEleTreeStoreDB('DEBT_ZWSRKM', {condition: " and (code like '1050402%' or code like '1101102%') and year " + km_condition});
    var zcgnfl_store = DebtEleTreeStoreDB('EXPFUNC', {condition: "and year " + km_condition});
    var zcjjfl_store = DebtEleTreeStoreDB('EXPECO', {condition: "and year " + km_condition});

    var json_debt_bcxx = [
        {"id": "0", "code": "否", "name": "0"},
        {"id": "1", "code": "是", "name": "1"}

    ];
    var json_debt_bcxx_yxdj = [
        {"id": "1", "code": "一级", "name": "1"},
        {"id": "2", "code": "二级", "name": "2"},
        {"id": "3", "code": "三级", "name": "3"},
        {"id": "4", "code": "四级", "name": "4"},
        {"id": "5", "code": "五级", "name": "5"}
    ];
    /**
     * 获取第三方机构数据
     * @param table DEBT_T_ZQGL_DSFJG
     * @param params {JG_TYPE:'0'}
     * @returns {}
     */
    function getDsfjgStore(params) {
        Ext.define('fjgzStoreModel', {
            extend: 'Ext.data.Model',
            fields: [
                {name: 'id'},
                {name: 'code'},
                {name: 'text'}
            ]

        });
        var store_fjgz = Ext.create('Ext.data.TreeStore', {
            model: 'fjgzStoreModel',
            autoLoad: true,
            proxy: {
                type: 'ajax',
                method: 'POST',
                extraParams:params,
                url: 'getDsfjgStore.action',
                reader: {
                    type: "json"
                }
            },
            root: 'nodelist'
        });
        return store_fjgz;
    }
</script>
</body>
</html>
