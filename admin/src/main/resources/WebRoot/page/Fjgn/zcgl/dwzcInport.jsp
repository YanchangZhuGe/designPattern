<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>单位资产填报Excel导入界面</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
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
<script type="text/javascript" src="dwzcInportEleData.js"></script>
<script type="text/javascript">
 	var userCode = '${sessionScope.USERCODE}';
	var AD_NAME = '${sessionScope.ADNAME}';
	var AD_CODE = '${sessionScope.ADCODE}';
    var wf_id = "${fns:getParamValue('wf_id')}";//当前流程id
    var node_code = '001';//当前节点id
    var node_type = 'tb';//当前节点id
    var WF_STATUS = "${fns:getParamValue('WF_STATUS')}";//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var button_name = '';
    /**
     * 通用配置json
     */
    var zcExcel_json_common = {
            tb: {
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
					        text: '资产导入',
					        icon: '/image/sysbutton/import.png',
					        handler: function () {
                                sbWindow.show();
					        }
					    },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                },
                store: {
                    WF_STATUS: DebtEleStore(json_debt_zt1)
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
        initContent();
    });
    /**
     * 初始化页面主要内容区域
     */
    function initContent() {
        Ext.create('Ext.panel.Panel', {
            layout: 'border',
            defaults: {
                split: true,            //是否有分割线
                collapsible: false      //是否可以折叠
            },
            height: '100%',
            renderTo: 'contentPanel',
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: zcExcel_json_common[node_type].items[WF_STATUS]
                }
            ],
            items: [
            	initContentRightPanel()
            ]
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
	        items: [
	            initContentGrid()
	        ]
	    });
	}
    /**
     * 刷新表格数据
     */
    function reloadGrid(param) {
        var grid = DSYGrid.getGrid("contentGrid");
        var store = grid.getStore();
        //增加查询参数
        /*var SET_YEAR = Ext.ComponentQuery.query('combobox[name="SET_YEAR"]')[0].getValue();
	 	store.getProxy().extraParams["SET_YEAR"] = SET_YEAR;
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }*/
        //刷新
        store.loadPage(1);
    }

	/**
	 * 初始化右侧主表格
	 */
	function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 40, summaryType: 'count'},
            {text: "地区编码", dataIndex: "AD_CODE", type: "string", width: 100},
            {text: "地区名称", dataIndex: "AD_NAME", type: "string", width: 100},
            {text: "项目单位编码", dataIndex: "AG_CODE", type: "string", width: 150},
            {text: "项目单位", dataIndex: "AG_NAME", type: "string", width: 150},
            {text: "项目单位性质", dataIndex: "XMDWXZ_ID", type: "string", width: 150, hidden: true},
            {text: "项目ID", dataIndex: "XM_ID", type: "string", width: 150, hidden: true},
            {text: "项目编码", dataIndex: "XM_CODE", type: "string", width: 150},
            {text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 330,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    var paramValues=new Array();
                    paramValues[0]=record.get('XM_ID');
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "项目类型", dataIndex: "XMLX_NAME", type: "string", width: 150},
            {text: "管理(使用)单位", dataIndex: "USE_UNIT", type: "string", width: 150},
            {text: "管理(使用)单位性质", dataIndex: "SYDWXZ_NAME", type: "string", width: 150},
            {text: "建设状态", dataIndex: "BUILD_STATUS_ID", type: "string", width: 150},
            {text: "竣工时间", dataIndex: "END_DATE_ACTUAL", type: "string", width: 150},
            {header: "项目总投资额(万元)", colspan: 2, align: 'center',columns:[
                {text: "合计", dataIndex: "XMTZ_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                },
                {text: "其中一般债务", dataIndex: "XMTZ_YB_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                },
                {text: "专项债务", dataIndex: "XMTZ_ZX_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                },
                {text: "其他财政性资金", dataIndex: "QT_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                },
                {text: "其他资金", dataIndex: "QITA_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                }
            ]},
            {text: "资产类别", dataIndex: "ZCLB_NAME", type: "string", width: 150},
            {text: "计量单位", dataIndex: "JLDW_NAME", type: "string", width: 150},
            {text: "数量", dataIndex: "ZC_NUM", type: "string", width: 150},
            {text: "转固/入账时间", dataIndex: "RZ_DATE", type: "string", width: 150},
            {header: "资产价值(万元)", colspan: 2, align: 'center',columns:[
                {text: "原值", dataIndex: "ZJYZ_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                },
                {text: "净值", dataIndex: "ZCJZ_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                }
            ]},
            {header: "资产运营收益(万元)", colspan: 2, align: 'center',columns:[
                {text: "累计收益", dataIndex: "LJSY_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                },
                {text: "本期收益", dataIndex: "SNLJSY_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                }
            ]},
            {header: "资产处置情况(万元)", colspan: 2, align: 'center',columns:[
                {text: "资产处置类型", dataIndex: "CZLX_NAME", type: "string", width: 180},
                {text: "本期资产处置收入(万元)", dataIndex: "CZSR_AMT", type: "float", width: 180,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                }
            ]},
            {text: "抵押质押及担保金额(万元)", dataIndex: "DYDB_AMT", type: "float", width: 200,
                renderer: function (value) {
                    return Ext.util.Format.number(value/10000, '0,000.00');
                }
            },
            {text: "备注", dataIndex: "REMARK", type: "string", width: 150}
        ];
		var url = '/getZcInportData.action';
	    return DSYGrid.createGrid({
	        itemId: 'contentGrid',
	        headerConfig: {
	            headerJson: headerJson,
	            columnAutoWidth: false
	        },
	        checkBox: true,
	        rowNumber: true,
	        border: false,
	        height: '50%',
	        flex: 1,
	        tbar: [
	        ],
	        params: {
                AD_CODE: AD_CODE
	        },
	        dataUrl: url,
	        pageConfig: {
	            pageNum: true//设置显示每页条数
	        }
	    });
	}
	/**
	 * 导入
	 */
	function uploadExcel(sbqj) {
	    var form = new Ext.form.FormPanel({
	        labelWidth: 70,
	        fileUpload: true,
            layout: 'fit',
	        defaultType: 'textfield',
	        items: [
		        initUploadGrid()
		    ]
	    });
	    var win = new Ext.Window({
	        title: '资产导入',
            width: document.body.clientWidth * 0.9, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
	        layout: 'fit',
            modal: true,
	        plain: true,
	        buttonAlign: 'center',
	        items: form,
	        buttons: ['->',{
	            text: '保存',
	            handler: function (btn) {
	            	button_name = btn.text;
	                var recordArray = [];
                    var myDate = new Date();
                    var curDate=Ext.Date.format(myDate, 'Y-m-d');
                    var flag = false;
                    var message = '';
	                btn.up('window').down('grid').getStore().each(function (record) {
                        if (record.get("USE_UNIT") == '') {
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的管理使用单位不能为空！';
                            return false;
                        }
                        if (record.get("SYDWXZ_NAME") == '') {
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的管理使用单位性质不能为空！';
                            return false;
                        }
                        if (record.get("SYDWXZ_ID") == '') {
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的管理使用单位性质基础数据集不匹配！';
                            return false;
                        }
                        if (record.get("BUILD_STATUS_NAME") == '') {
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的建设状态不能为空！';
                            return false;
                        }
                        if (record.get("BUILD_STATUS_ID") == '') {
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的建设状态基础数据集不匹配！';
                            return false;
                        }
                        if ( record.get("BUILD_STATUS_ID") == '04' || record.get("BUILD_STATUS_ID") == '03') {
                            if (record.get("END_DATE_ACTUAL") == '') {
                                flag = true;
                                message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目在当前建设状态下，竣工日期不可为空！';
                                return false;
                            }
                            if(!(record.get("END_DATE_ACTUAL") == '') && (record.get("END_DATE_ACTUAL") > curDate )){
                                flag = true;
                                message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目竣工日期不能大于当前日期！';
                                return false;
                            }
                        }
                        if(record.get("QITA_AMT")<0){
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的其他资金不能为负数！';
                            return false;
                        }
                        /*var xmtz_yb_zx=accAdd(record.get("XMTZ_YB_AMT"),record.get("XMTZ_ZX_AMT"));
                        var qt=accAdd(record.get("QT_AMT"),record.get("QITA_AMT"));
                        var result=accAdd(xmtz_yb_zx,qt);
                        if(Math.abs(accSub(record.get("XMTZ_AMT"),result)) > 0.000001){
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目一般债务、专项债务、其他财政性资金、其他资金之和必须等于项目总投资！';
                            return false;
                        }*/
                        if (record.get("ZCLB_ID") == '') {
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的资产类别基础数据集不匹配！';
                            return false;
                        }
                        if (!(record.get("ZC_NUM") > 0)) {
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的数量必须大于0！';
                            return false;
                        }
                        if (!(record.get("RZ_DATE") =='') && (record.get("RZ_DATE") > curDate) ) {
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的转固/入账时间不能大于当前日期！';
                            return false;
                        }
                        if (!(record.get("ZJYZ_AMT") >0)) {
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的资产原值必须大于0！';
                            return false;
                        }
                        if (record.get("LJSY_AMT") < record.get("SNLJSY_AMT") ) {
                            flag = true;
                            message = '项目名称为 " ' + record.get("XM_NAME") + ' " <br>的项目的累计收益应大于等于上年度收益！';
                            return false;
                        }
                        recordArray.push(record.getData());
	                });
                    if (flag) {
                        Ext.MessageBox.alert('提示', message);
                        btn.setDisabled(false);
                        return;
                    }
                    //校验是否有需要保存的数据
                    if(recordArray <= 0) {
                        Ext.Msg.alert('提示', '未发现需要导入的数据！');
                        return false ;
                    }
	                //资产导入保存
                    Ext.Msg.confirm("提示", '导入会覆盖单位的所有资产数据，是否导入？', function (botton) {
                        if (botton == 'yes') {
                            var radix = 10000;
                            for(var i=0; i<recordArray.length; i++) {
                                var record = recordArray[i];
                                record.XMTZ_AMT = accMul(record.XMTZ_AMT,radix);
                                record.XMTZ_YB_AMT = accMul(record.XMTZ_YB_AMT,radix);
                                record.XMTZ_ZX_AMT = accMul(record.XMTZ_ZX_AMT,radix);
                                record.QT_AMT = accMul(record.QT_AMT,radix);
                                record.QITA_AMT = accMul(record.QITA_AMT,radix);
                                record.ZJYZ_AMT = accMul(record.ZJYZ_AMT,radix);
                                record.ZCJZ_AMT = accMul(record.ZCJZ_AMT,radix);
                                record.LJSY_AMT = accMul(record.LJSY_AMT,radix);
                                record.SNLJSY_AMT = accMul(record.SNLJSY_AMT,radix);
                                record.CZSR_AMT = accMul(record.CZSR_AMT,radix);
                                record.DYDB_AMT = accMul(record.DYDB_AMT,radix);
                            }
                            $.post("/saveZcInportData.action", {
                                recordList: Ext.util.JSON.encode(recordArray),
                                button_name: button_name,
                                AD_CODE: AD_CODE,
                                userCode: userCode,
                                sbqj: sbqj
                            }, function (data) {
                                if (data.success) {
                                    Ext.toast({
                                        html: btn.text + "成功！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    win.close();
                                } else {
                                    if (data.showDetailList) {
                                        var grid = showDetailList(data.listHeader);
                                        var detailListGrid = DSYGrid.getGrid('detailListGrid');
                                        detailListGrid.getStore().removeAll();
                                        detailListGrid.insertData(null, eval(data.list));
                                        ConfirmWindow(
                                            {
                                                height:document.body.clientHeight*Number(data.windowHeight),
                                                width:document.body.clientWidth*Number(data.windowWidth),
                                                title:'提示',
                                                buttons: [
                                                    {
                                                        text: '确定',
                                                        handler: function (self) {
                                                            self.up('window').close();
                                                            btn.setDisabled(true);
                                                        }
                                                    }
                                                ]
                                            },
                                            data.listTitle,
                                            grid
                                        ).show();
                                    } else{
                                        Ext.MessageBox.alert('提示', btn.text + '失败！');
                                    }
                                }
                                //刷新表格
                                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                            }, "json");
                        } /*else {
                            btn.up('window').close();
                        }*/
                    });
	            }
	        }, {
	            text: '关闭',
	            handler: function () {
	                win.close();
	            }
	        }]
	    });
	    win.show();
	}

	/**
	 * 初始化
	 */
	function initUploadGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 40, summaryType: 'count',
                summaryRenderer: function () {
                    return '合计';
                }
            },
            {text: "地市名称", dataIndex: "U_AD_NAME", type: "string", width: 100},
            {text: "地区编码", dataIndex: "AD_CODE", type: "string", width: 100},
            {text: "地区名称", dataIndex: "AD_NAME", type: "string", width: 100},
            {text: "项目单位编码", dataIndex: "AG_CODE", type: "string", width: 150},
            {text: "项目单位", dataIndex: "AG_NAME", type: "string", width: 150},
            {text: "项目单位性质ID", dataIndex: "XMDWXZ_ID", type: "string", width: 150, hidden:true},
            {text: "项目单位性质", dataIndex: "XMDWXZ_NAME", type: "string", width: 150},
            {text: "项目编码", dataIndex: "XM_CODE", type: "string", width: 150},
            {text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 330,
                /*renderer: function (data, cell, record) {
                    var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';
                }*/
            },
            {text: "项目类型", dataIndex: "XMLX_NAME", type: "string", width: 150},
            {text: "管理使用单位", dataIndex: "USE_UNIT", type: "string", width: 150},
            {text: "管理使用单位性质ID", dataIndex: "SYDWXZ_ID", type: "string", width: 150, hidden:true},
            {text: "管理使用单位性质", dataIndex: "SYDWXZ_NAME", type: "string", width: 150},
            {text: "建设状态ID", dataIndex: "BUILD_STATUS_ID", type: "string", width: 150, hidden:true},
            {text: "建设状态", dataIndex: "BUILD_STATUS_NAME", type: "string", width: 150},
            {text: "竣工时间", dataIndex: "END_DATE_ACTUAL", type: "string", width: 150},
            {header: "项目总投资额(万元)", colspan: 2, align: 'center',columns:[
                {text: "合计", dataIndex: "XMTZ_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "其中一般债务", dataIndex: "XMTZ_YB_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "专项债务", dataIndex: "XMTZ_ZX_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "其他财政性资金", dataIndex: "QT_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "其他资金", dataIndex: "QITA_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]},
            {text: "资产类别ID", dataIndex: "ZCLB_ID", type: "string", width: 150, hidden:true},
            {text: "资产类别", dataIndex: "ZCLB_NAME", type: "string", width: 150},
            {text: "计量单位", dataIndex: "JLDW_NAME", type: "string", width: 150},
            {text: "数量", dataIndex: "ZC_NUM", type: "string", width: 150},
            {text: "转固/入账时间", dataIndex: "RZ_DATE", type: "string", width: 150},
            {header: "资产价值(万元)", colspan: 2, align: 'center',columns:[
                {text: "原值", dataIndex: "ZJYZ_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "净值", dataIndex: "ZCJZ_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]},
            {header: "资产运营收益(万元)", colspan: 2, align: 'center',columns:[
                {text: "累计收益", dataIndex: "LJSY_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {text: "本期收益", dataIndex: "SNLJSY_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]},
            {header: "资产处置情况(万元)", colspan: 2, align: 'center',columns:[
                {text: "资产处置类型ID", dataIndex: "CZLX_ID", type: "string", width: 180, hidden:true},
                {text: "资产处置类型", dataIndex: "CZLX_NAME", type: "string", width: 180},
                {text: "本期资产处置收入(万元)", dataIndex: "CZSR_AMT", type: "float", width: 180,
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]},
            {text: "抵押质押及担保金额(万元)", dataIndex: "DYDB_AMT", type: "float", width: 200,
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
            },
            {text: "备注", dataIndex: "REMARK", type: "string", width: 150}
        ];
	    var grid = DSYGrid.createGrid({
	        itemId: 'uploadGrid',
	        flex: 1,
	        headerConfig: {
	            headerJson: headerJson,
	            columnAutoWidth: false
	        },
	        checkBox: false,
	        rowNumber: true,
	        border: false,
	        //height: 420,
	        sortableColumns: false,
	        tbarHeight: 50,
	        pageConfig: {
	            enablePage: false
	        },
	        data: []
	    });
	    grid.addDocked({
	        xtype: 'toolbar',
	        layout: 'column',
	        items: [
	            {
	            	xtype: 'label',
	            	margin: '4 0 0 0',
	            	text:'请选择上传文件：'
	            },
		        {
		            xtype: 'filefield',
		            buttonText: '资产导入',
		            name: 'upload',
		            width: 100,
		            buttonOnly: true,
		            hideLabel: true,
		            buttonConfig: {
		                width: 100,
		                icon: '/image/sysbutton/report.png'
		            },
		            listeners: {
		                change: function (fb, v) {
		                    var form = this.up('form').getForm();
		                    var file = form.findField('upload').getValue();
		                    if(file==null||file==''){
		                       Ext.toast('请选择文件！');
                               return;
		                    } else if(!(file.endWith('.xls'))&&!(file.endWith('.xlsx'))){
                               Ext.toast('请选择xls、xlsx格式的Excel文件！');
                               return;
                            }
		                    DSYGrid.getGrid('uploadGrid').getStore().removeAll();
		                    uploadXeExcelFile(form);
		                }
		            }
		        },
		        {
	                xtype: 'button',
	                itemId: 'xedrDelBtn',
	                text: '删行',
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
	            }
	        ]
	    }, 0);
	    grid.on('selectionchange', function (view, records) {
	        grid.up('window').down('#xedrDelBtn').setDisabled(!records.length);
	    });
	    return grid;
	}


	/**
	 * excel导入
	 * @param form
	 */
	function uploadXeExcelFile(form) {
	    var url = 'importZcExcelData.action';
        var excelHeader = ["U_AD_NAME", "AD_CODE", "AD_NAME", "AG_CODE", "AG_NAME", "XMDWXZ_NAME", "XM_CODE", "XM_NAME", "XMLX_NAME", "USE_UNIT", "SYDWXZ_NAME", "BUILD_STATUS_NAME", "END_DATE_ACTUAL", "XMTZ_AMT", "XMTZ_YB_AMT", "XMTZ_ZX_AMT", "QT_AMT", "QITA_AMT", "ZCLB_NAME", "JLDW_NAME", "ZC_NUM", "RZ_DATE", "ZJYZ_AMT", "ZCJZ_AMT", "LJSY_AMT", "SNLJSY_AMT", "CZLX_NAME", "CZSR_AMT", "DYDB_AMT", "REMARK"];
	    if (form.isValid()) {
	        form.submit({
	            url: url,
	            params: {
	                excelHeader: excelHeader
	            },
	            waitTitle: '请等待',
	            waitMsg: '正在导入中...',
	            success: function (form, action) {
	                var columnStore = action.result.list;
	                var grid = DSYGrid.getGrid('uploadGrid');
	                for (var i = 0;i < columnStore.length;i++){
                        //项目单位性质
                        var xmdwxz_name = columnStore[i].XMDWXZ_NAME;
                        Ext.each(xmdwxz_list, function (temp) {
                            if(temp.name == xmdwxz_name) {
                                columnStore[i].XMDWXZ_ID = temp.id;
                            }
                        });
                        //使用单位性质
                        var sydwxz_name;
                        if (columnStore[i].SYDWXZ_NAME != undefined && columnStore[i].SYDWXZ_NAME != ''){
                            sydwxz_name = columnStore[i].SYDWXZ_NAME.replace(/\s+/g,"");
                        }
                        //var sydwxz_name = columnStore[i].SYDWXZ_NAME;
                        Ext.each(sydwxz_list, function (temp) {
                            if(temp.name == sydwxz_name) {
                                columnStore[i].SYDWXZ_ID = temp.id;
                            }
                        });
                        //建设状态
                        var build_status_name;
                        if (columnStore[i].BUILD_STATUS_NAME != undefined && columnStore[i].BUILD_STATUS_NAME != ''){
                            build_status_name = columnStore[i].BUILD_STATUS_NAME.replace(/\s+/g,"");
                        }
                        //var build_status_name = columnStore[i].BUILD_STATUS_NAME;
                        Ext.each(build_status_list, function (temp) {
                            if(temp.name == build_status_name) {
                                columnStore[i].BUILD_STATUS_ID = temp.id;
                            }
                        });
                        //资产类别
                        var zclb_name;
                        if (columnStore[i].ZCLB_NAME != undefined && columnStore[i].ZCLB_NAME != ''){
                            zclb_name = columnStore[i].ZCLB_NAME.replace(/\s+/g,"");
                        }
                        //var zclb_name = columnStore[i].ZCLB_NAME.replace(/\s+/g,"");
                        Ext.each(zclb_list, function (temp) {
                            if(temp.name == zclb_name) {
                                columnStore[i].ZCLB_ID = temp.id;
                            }
                        });
                        //处置类型
                        var czlx_name = columnStore[i].CZLX_NAME;
                        Ext.each(czlx_list, function (temp) {
                            if(temp.name == czlx_name) {
                                columnStore[i].CZLX_ID = temp.id;
                            }
                        });
                    }
	                grid.insertData(null, columnStore);
	                grid.getStore().sort([{
	                       property : 'AD_CODE',
	                       direction: 'ASC'
	                   	}
	                ]);
	            },
	            failure: function (form, action) {
	                Ext.MessageBox.show({
	                    title: '提示',
	                    msg: '导入失败',
	                    width: 200,
	                    fn: function (btn) {
	                    }
	                });
	            }
	        });
	    } else {
	        Ext.Msg.alert('提示', '请将必填项补充完整！');
	    }
	}

    var sbWindow = {
        window: null,
        show: function () {
            if (!this.window) {
                this.window = initSelectSbqjWindow();
            }
            this.window.show();
        }
    };
	/**
     * 初始化上报期间选择窗口
     */
    function initSelectSbqjWindow() {
        return Ext.create('Ext.window.Window', {
            title: '选择上报期间',
            width: 375,
            height: 200,
            itemId: 'sbWindow',
            closeAction: 'destroy',
            layout: 'column',
            modal: true,
            items: [initSbqjForm()],
            buttons: [
                {
                    text: '上报',
                    handler: function (btn) {
                        var form = btn.up('window').down('form').getForm();
                        var sbqj = form.getValues().SBQJ;
                        if (sbqj == '') {
                            Ext.Msg.alert('提示', '请选择上报期间！');
                            return;
                        }
                        uploadExcel(sbqj);
                        btn.up('window').close();
                    }
                },
                {
                    text: '取消',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }],
            listeners: {
                close: function () {
                    sbWindow.window = null;
                }
            }
        });
    }
    /**
     * 初始化上报期间选择form
     */
    function initSbqjForm() {
        return Ext.create('Ext.form.Panel', {
            width: '100%',
            height: '100%',
            border: false,
            items: [{
                fieldLabel: '上报期间',
                name: 'SBQJ',
                labelAlign: 'right',
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'code',
                margin: {
                    top: 45,
                    left: 0
                },
                store: DebtEleStoreDB('DEBT_SBQJ'),
                allowBlank: false//不允许为空
            }
            ]
        });
    }
    /**
     * 初始化导入失败详细信息表格
     */
    function showDetailList(listHeader) {
        var headerJson;
        if (listHeader == 'detailList') {
            headerJson = [
                {xtype: 'rownumberer', width: 40, summaryType: 'count'},
                {text: "地区编码", dataIndex: "AD_CODE", type: "string", width: 100},
                {text: "地区名称", dataIndex: "AD_NAME", type: "string", width: 100},
                {text: "项目单位编码", dataIndex: "AG_CODE", type: "string", width: 150},
                {text: "项目单位", dataIndex: "AG_NAME", type: "string", width: 150},
                {text: "项目单位性质ID", dataIndex: "XMDWXZ_ID", type: "string", width: 150, hidden:true},
                {text: "项目单位性质", dataIndex: "XMDWXZ_NAME", type: "string", width: 150},
                {text: "项目编码", dataIndex: "XM_CODE", type: "string", width: 150},
                {text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 330},
                {text: "项目类型", dataIndex: "XMLX_NAME", type: "string", width: 150},
                {text: "管理使用单位", dataIndex: "USE_UNIT", type: "string", width: 150},
                {text: "管理使用单位性质ID", dataIndex: "SYDWXZ_ID", type: "string", width: 150, hidden:true},
                {text: "管理使用单位性质", dataIndex: "SYDWXZ_NAME", type: "string", width: 150},
                {text: "建设状态ID", dataIndex: "BUILD_STATUS_ID", type: "string", width: 150, hidden:true},
                {text: "建设状态", dataIndex: "BUILD_STATUS_NAME", type: "string", width: 150},
                {text: "竣工时间", dataIndex: "END_DATE_ACTUAL", type: "string", width: 150},
                {header: "项目总投资额(万元)", colspan: 2, align: 'center',columns:[
                    {text: "合计", dataIndex: "XMTZ_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    },
                    {text: "其中一般债务", dataIndex: "XMTZ_YB_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    },
                    {text: "专项债务", dataIndex: "XMTZ_ZX_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    },
                    {text: "其他财政性资金", dataIndex: "QT_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    },
                    {text: "其他资金", dataIndex: "QITA_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    }
                ]},
                {text: "资产类别ID", dataIndex: "ZCLB_ID", type: "string", width: 150, hidden:true},
                {text: "资产类别", dataIndex: "ZCLB_NAME", type: "string", width: 150},
                {text: "计量单位", dataIndex: "JLDW_NAME", type: "string", width: 150},
                {text: "数量", dataIndex: "ZC_NUM", type: "string", width: 150},
                {text: "转固/入账时间", dataIndex: "RZ_DATE", type: "string", width: 150},
                {header: "资产价值(万元)", colspan: 2, align: 'center',columns:[
                    {text: "原值", dataIndex: "ZJYZ_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    },
                    {text: "净值", dataIndex: "ZCJZ_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    }
                ]},
                {header: "资产运营收益(万元)", colspan: 2, align: 'center',columns:[
                    {text: "累计收益", dataIndex: "LJSY_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    },
                    {text: "本期收益", dataIndex: "SNLJSY_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    }
                ]},
                {header: "资产处置情况(万元)", colspan: 2, align: 'center',columns:[
                    {text: "资产处置类型ID", dataIndex: "CZLX_ID", type: "string", width: 180, hidden:true},
                    {text: "资产处置类型", dataIndex: "CZLX_NAME", type: "string", width: 180},
                    {text: "本期资产处置收入(万元)", dataIndex: "CZSR_AMT", type: "float", width: 180,
                        renderer: function (value) {
                            return Ext.util.Format.number(value/10000, '0,000.00');
                        }
                    }
                ]},
                {text: "抵押质押及担保金额(万元)", dataIndex: "DYDB_AMT", type: "float", width: 200,
                    renderer: function (value) {
                        return Ext.util.Format.number(value/10000, '0,000.00');
                    }
                },
                {text: "备注", dataIndex: "REMARK", type: "string", width: 150}
            ];
        } else if (listHeader == 'xm_name') {
            headerJson = [
                {xtype: 'rownumberer', width: 40, summaryType: 'count'},
                {text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 500}
            ];
        }
        var config = {
            itemId: 'detailListGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            rowNumber: true,
            autoLoad: true,
            border: false,
            height: '50%',
            flex: 1,
            tbar: [
            ],
            params: {
            },
            data:[],
            pageConfig: {
                enablePage: false
            }
        };
        return DSYGrid.createGrid(config);
    }

</script>
</body>
</html>