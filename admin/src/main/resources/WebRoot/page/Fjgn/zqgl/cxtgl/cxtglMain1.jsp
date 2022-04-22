<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>合同录入主界面</title>
    <script type="text/javascript" src="/js/commonUtil.js"></script> 
    <script src="../data/ele_data.js"></script>
    <script src="cxtglEditor.js"></script>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
    <%--获取登录用户--%>
<script type="text/javascript">
    /**
     * 获取登录用户
     */
    var userCode = '${sessionScope.USERCODE}';

    /**
     * 通用函数：获取url中的参数
     */
/*    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg); //匹配目标参数
        if (r != null)
            return unescape(r[2]);
        return null; //返回参数值
    }*/

  /*  var wf_id = getUrlParam("wf_id");//工作流ID*/
    var wf_id ="${fns:getParamValue('wf_id')}";
  /*  var node_code = getUrlParam("node_code");//当前结点*/
    var node_code ="${fns:getParamValue('node_code')}";

    /**
     * 设置全局变量
     */
    var AD_ID = '';//区划ID
    var AD_CODE = '';//区划Code
    var AD_NAME = '';//区划名称
    var AG_ID = '';//单位ID
    var AG_CODE = '';//单位Code
    var AG_NAME = '';//单位名称
    var ZW_ID = '';//债务ID
    var button_name = '';//按钮名称
    var next_text = '';//送审、审核按钮显示文字
    var is_leaf = false;//是否叶子节点，用于判断是否选择了末级单位
    var audit_info = '';//送審意見

    /**
     * 页面初始化
     */
    $(document).ready(function () {
        if (typeof (Ext) == "undefined" || Ext == null) {
            //动态加载js
            $.ajaxSetup({
                cache: true
            });
            $.getScript('../../third/ext5.1/ext-all.js', function () {
                initMain();
            });
        } else {
            initMain();
        }
    });

    /**
     * 主界面初始化
     */
    function initMain() {
        /**
         * 初始化顶部功能按钮
         */
        var tbar = Ext
                .create(
                        'Ext.toolbar.Toolbar',
                        {
                            defaults: {
                                padding: '0 5 0 0'//解决IE10可能布局中的情况
                            },
                            border: false,
                            items: [
                                {
                                    xtype: 'button',
                                    text: '新增',
                                    scale: 'medium',
                                    name: 'btn_insert',
                                    icon: '/image/button/field_insertb24_h.png',
                                    handler: function () {
                                        add();
                                    }
                                },
                                {
                                    xtype: 'button',
                                    text: '修改',
                                    scale: 'medium',
                                    name: 'btn_update',
                                    icon: '/image/button/edit_table_structure24_h.png',
                                    handler: function () {
                                        update();
                                    }
                                },
                                {
                                    xtype: 'button',
                                    text: '删除',
                                    scale: 'medium',
                                    name: 'btn_delete',
                                    icon: '/image/button/field_drop24_h.png',
                                    handler: function () {
                                        //获取表格被选中行
                                        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
                                        if (records.length <= 0) {
                                            Ext.MessageBox.alert('提示',
                                                    '请选择至少一条后再进行操作');
                                            return;
                                        } else {
                                            deleteBasicInfo();
                                        }
                                    }
                                },
                                '->',
                                initButton_OftenUsed(),
                                initButton_Screen()]
                        });

        /**
         * 承销团树
         */
        /* 			Ext.define('cxtTreeModel', {
         extend : 'Ext.data.Model',
         fields : [ {
         name : 'name'
         }, {
         name : 'code'
         }, {
         name : 'id'
         }]
         });
         var unitStore = Ext.create('Ext.data.TreeStore', {
         model : 'cxtTreeModel',
         proxy : {
         type : 'ajax',
         method : 'POST',
         url : 'getCxtTreeData.action',
         reader : {
         type : 'json'
         }
         },
         root : 'nodelist',
         autoLoad : true
         }); */

        /**
         * 承销团信息条件工具栏
         */
        var screenBar = [
            {
                xtype: "textfield",
                fieldLabel: '编码',
                id: "bm",
                width: 250,
                labelWidth: 60,
                editable: false, //禁用编辑
                labelAlign: 'right'
            },

            {
                xtype: "treecombobox",
                id: "mc",
                store: DebtEleTreeStoreDB('DEBT_ZQLX'),
                displayField: "name",
                valueField: "id",
                fieldLabel: '名称',
                editable: false, //禁用编辑
                labelWidth: 60,
                labelAlign: 'right'
            }];

        /**
         * 债务合同信息列表表头
         */
        var headerJson = {
            "header": [{
                "dataIndex": "ZW_ID",
                "type": "string",
                "text": "债务ID",
                "fontSize": "15px",
                "hidden": true
            }, {
                "dataIndex": "AG_NAME",
                "type": "string",
                "text": "债务单位",
                "fontSize": "15px",
                "width": 250,
            }, {
                "dataIndex": "ZW_CODE",
                "type": "string",
                "width": 250,
                "text": "债务编码",
                "hrefType": "combo",
                "hidden": true
            }, {
                "dataIndex": "ZW_NAME",
                "width": 250,
                "type": "string",
                "text": "债务名称"
            }, {
                "dataIndex": "SIGN_DATE",
                "width": 150,
                "type": "string",
                "text": "签订日期"
            }, {
                "dataIndex": "ZW_XY_NO",
                "width": 150,
                "type": "string",
                "text": "协议号"
            }, {
                "dataIndex": "ZQFL_ID",
                "width": 150,
                "type": "string",
                "text": "债权类型"
            }, {
                "dataIndex": "ZQR_ID",
                "width": 150,
                "type": "string",
                "text": "债权人"
            }, {
                "dataIndex": "ZQR_FULLNAME",
                "width": 300,
                "type": "string",
                "text": "债权人全称"
            }, {
                "dataIndex": "FM_ID",
                "width": 100,
                "type": "string",
                "text": "币种"
            }, {
                "dataIndex": "HL_RATE",
                "width": 100,
                "type": "number",
                "align": 'right',
                "text": "汇率"
            }, {
                "dataIndex": "XY_AMT",
                "width": 150,
                "type": "number",
                "align": 'right',
                "text": "协议金额（原币）"
            }, {
                "dataIndex": "LXTYPE_ID",
                "width": 150,
                "type": "string",
                "text": "利率类型"
            }]
        };
    }

</script>

<div id="mainDiv" style="width: 100%;height:100%;"></div>
</body>
</html>