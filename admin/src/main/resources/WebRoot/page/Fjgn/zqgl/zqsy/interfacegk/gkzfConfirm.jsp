<%--
  Created by IntelliJ IDEA.
  User: zhangsa
  Date: 2018/08/09
  Time: 13:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="com.bgd.platform.util.service.*" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>新增债券支出确认</title>
</head>
<body>
</div>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    /**
     * 通用函数：获取url中的参数
     */
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]);
        return null; //返回参数值
    }
    /*获取登录用户*/
    var button_name = '';//当前操作按钮名称
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/,"");
    var WF_STATUS = getUrlParam("WF_STATUS");//当前状态
    if (WF_STATUS == null || WF_STATUS == '' || WF_STATUS.toLowerCase() == 'null') {
        WF_STATUS = '001';
    }
    var userCode='${sessionScope.USERCODE}';
    var nowDate = '${fns:getDbDateDay()}';
    var km_year = nowDate.substr(0,4);
    var km_condition = km_year <= 2017 ? " <= '2017' " :" = '"+ km_year +"' ";
    var store_GNFL = DebtEleTreeStoreDB('EXPFUNC',{condition: "and year " + km_condition});
    var store_JJFL = DebtEleTreeStoreDB('EXPECO', {condition: "and year " + km_condition});

    /**
     * 通用配置json
     */
    var zqzc_json_common = {
        items: {
            '001': [
                {
                    xtype: 'button',
                    text: '查询',
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '修改',
                    name: 'update',
                    icon: '/image/sysbutton/confirm.png',
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            return;
                        }
                        button_text = btn.text;
                        button_name = btn.name;
                        initZcxxData_update({
                            ZCD_ID: records[0].get("ZCD_ID")
                        });
                        btn.setDisabled(false);
                    }
                },
                {
                    xtype: 'button',
                    text: '删除',
                    name: 'delete',
                    icon: '/image/sysbutton/confirm.png',
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            return;
                        }
                        Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                            if (btn_confirm === 'yes') {
                                var ids = [];
                                for (var i in records) {
                                    ids.push(records[i].get("ZCD_ID"));
                                }
                                //发送ajax请求，删除数据
                                $.post("delGkZcxx.action", {
                                    ids: ids
                                }, function (data) {
                                    if (data.success) {
                                        Ext.toast({html: "删除成功！"});
                                    } else {
                                        Ext.MessageBox.alert('提示', '删除失败！' + data.message);
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
                    text: '确认',
                    name: 'down',
                    icon: '/image/sysbutton/confirm.png',
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            return;
                        }
                        doupdateflow(records,btn);
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
                    name: 'search',
                    icon: '/image/sysbutton/search.png',
                    handler: function () {
                        reloadGrid();
                    }
                },
                {
                    xtype: 'button',
                    text: '撤销确认',
                    name: 'up',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('contentGrid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据再进行操作');
                            return;
                        }
                        doupdateflow(records,btn);
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        },
        store: {
            WF_STATUS: DebtEleStore(json_debt_zt11)
        }
    };
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //显示提示，并form表单提示位置为表单项下方
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        initContent();
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
            renderTo: Ext.getBody(),
            border: false,
            dockedItems: [
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    itemId: 'contentPanel_toolbar',
                    items: zqzc_json_common.items[WF_STATUS]
                }
            ],
            items: [
                initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    },
                }),
                initContentRightPanel()
            ]
        });
    }

    /**
     * 初始化右侧panel，放置表格
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
     * 初始化主表格
     */
    function initContentGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 45},
            {text: "支出ID", dataIndex: "ZCD_ID", type: "string", hidden: true},
            {text: "支出类型", dataIndex: "ZC_TYPE", type: "string", hidden: true},
            {text: "所属区划", dataIndex: "AD_CODE", type: "string", hidden: true},
            {text: "所属区划", dataIndex: "AD_NAME", type: "string"},
            {text: "所属单位", dataIndex: "AG_ID", type: "string", hidden: true},
            {text: "所属单位编码", dataIndex: "AG_CODE", type: "string", hidden: true},
            {text: "所属单位", dataIndex: "AG_NAME", type: "string", width: 200},
            {text: "关联债券ID", dataIndex: "ZQ_ID", type: "string", hidden: true},
            {text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 200,
                renderer: function (data, cell, record) {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('ZQ_ID');
                    paramValues[1] = AD_CODE.replace(/00$/, "");
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }},
            {text: "支出金额(元)", dataIndex: "PAY_AMT", type: "float", width: 160},
            {text: "支出年度", dataIndex: "ZCD_YEAR", type: "string",hidden: true}
        ];
        return DSYGrid.createGrid({
            itemId: 'contentGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            flex: 1,
            params: {
                WF_STATUS: WF_STATUS
            },
            dataUrl: 'getGkZcxxGrid.action',
            checkBox: true,
            border: false,
            autoLoad: false,
            height: '100%',
            tbar: [
                {
                    xtype: 'combobox',
                    fieldLabel: '状态',
                    name: 'WF_STATUS',
                    store: zqzc_json_common.store['WF_STATUS'],
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
                            var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];WF_STATUS
                            toolbar.removeAll();
                            toolbar.add(zqzc_json_common.items[WF_STATUS]);
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
            listeners: {
                itemclick: function (self, record) {
                    //刷新明细表
                }
            }
        });
    }

    /**
     * 刷新content主表格
     */
    function doupdateflow(records,btn) {
        var ids=new Array();
        var btn_name=btn.name;
        var btn_text=btn.text;
        for(var k=0;k<records.length;k++){
            var zcd_id=records[k].get("ZCD_ID");
            ids.push(zcd_id);
        }
        Ext.Msg.confirm('提示', '请确认是否' + btn_text + '!', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                btn.setDisabled(true);
                $.post("confirmGkZcxx.action", {
                    ids: ids,
                    btn_name:btn_name
                }, function (data_response) {
                    data_response = $.parseJSON(data_response);
                    if (data_response.success) {
                        Ext.toast({html: btn_text + "成功！"});
                    } else {
                        Ext.MessageBox.alert('提示', btn_text + '失败！' + data_response.message);
                    }
                    btn.setDisabled(false);
                    reloadGrid();
                })
            }
        });
    }
    /**
     * 初始化支出数据
     */
    function initZcxxData_update(config) {
        //发送ajax请求，获取修改数据
        $.post("getGkZcxxByZcdId.action", {
            ZCD_ID: config.ZCD_ID
        }, function (data) {
            if (data.success) {
                var window_zc = initWindow_save_zcxx({
                    gridId: config.ZCD_ID
                });
                window_zc.show();
                var data_zcd = data.data_zcd;
                var data_zcmx = data.data_zcmx;
                var data_zq = data.data_zq;
                var data_zdmx = $.extend({}, data_zq, data_zcd);
                data_zdmx = initZcxx_data_zdmx(data_zdmx, data_zcd, {
                    PAY_XZ_AMT_YZC_BDCS: data_zcd.PAY_AMT_TOTAL
                });
                window_zc.down('form').getForm().setValues(data_zdmx);
                window_zc.XM_LIST = {};
                //循环明细记录，计算对应项目的本单初始支出金额、本单支出金额、未拨付金额
                initZcxx_data_zcmx_UPDATE(data_zcmx, window_zc);
            } else {
                Ext.MessageBox.alert('提示', '查询修改数据失败！' + data.message);
            }
        }, "json");
    }

    /**
     * 初始化债券支出修改弹出窗口
     */
    function initWindow_save_zcxx(config) {
        var window_config = {
            title: '债券支出', // 窗口标题
            width: document.body.clientWidth * 0.95, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            layout: 'fit',
            itemId: 'window_save_zcxx', // 窗口标识
            buttonAlign: 'right', // 按钮显示的位置
            maximizable: true,
            frame: true,
            constrain: true,
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [
                {
                    xtype: 'tabpanel',
                    flex: 1,
                    items: [
                        {
                            title: '单据',
                            name: 'ZCD',
                            layout: 'vbox',
                            items: [
                                initWindow_save_zcxx_form(config),
                                initWindow_save_zcxx_grid(config)
                            ]
                        },
                        {
                            title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                            name: 'FILE',
                            layout: 'fit',
                            items: [
                                {
                                    xtype: 'panel',
                                    layout: 'fit',
                                    itemId: 'window_save_zcxx_file_panel',
                                    items: [initWindow_save_zcxx_tab_upload(config)]
                                }
                            ]
                        }
                    ]
                }
            ],
            buttons: [
                {
                    text: '增加', name: 'updXm', xtype: 'button', width: 80,
                    handler: function (btn) {
                        var ag_id = btn.up('window').down('form').down('[name=AG_ID]').getValue();
                        var ZCD_YEAR = btn.up('window').down('form').down('[name=ZCD_YEAR]').getValue();
                        initWindow_select_xzzq({ag_id: ag_id, ZCD_YEAR: ZCD_YEAR}).show();
                    }
                },
                {
                    text: '删除', name: 'deleteZC', xtype: 'button', width: 80, disabled: true,
                    handler: function (btn) {
                        var grid = btn.up('window').down('grid#window_save_zcxx_grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        grid.getPlugin('window_save_zcxx_grid_plugin_cell').cancelEdit();
                        store.remove(sm.getSelection());
                        if (store.getCount() > 0) {
                            sm.select(0);
                        } else {
                            //当表格无数据时，清空单位信息
                            btn.up('window').down('form').down('[name=AG_ID]').setValue('');
                            btn.up('window').down('form').down('[name=AG_CODE]').setValue('');
                            btn.up('window').down('form').down('[name=AG_NAME]').setValue('');
                        }
                    }
                },
                {
                    text: '保存',
                    handler: function (btn) {
                        // 检验是否有数据
                        // 获取数据
                        var grid = btn.up('window').down('#window_save_zcxx_grid');
                        var celledit = grid.getPlugin('window_save_zcxx_grid_plugin_cell');
                        //完成编辑
                        celledit.completeEdit();
                        if (window.flag_validateedit && !window.flag_validateedit.isHidden()) {
                            return false;//如果校验未通过
                        }
                        var store = grid.getStore();
                        if (store.getCount() < 1) {
                            Ext.MessageBox.alert('提示', '明细数据不能为空！');
                            return;
                        }
                        var grid_error_message = checkEditorGrid(grid);
                        if (grid_error_message) {
                            Ext.MessageBox.alert('提示', grid_error_message);
                            return false;
                        }
                        var recordArray = [];
                        store.each(function (record) {
                            var record_data = record.getData();
                            recordArray.push(record_data);
                        });
                        var data_ZCD = btn.up('window').down('form').getForm().getFieldValues();
                        btn.setDisabled(true) ;  //避免网络或操作导致数据错误，按钮置为不可点击
                        //发送ajax请求，保存表格数据
                        $.post('updateGkZcxx.action', {
                            data_ZCD:Ext.util.JSON.encode(data_ZCD),
                            dataList: Ext.util.JSON.encode(recordArray)
                        }, function (data) {
                            if (!data.success) {
                                Ext.MessageBox.alert('提示',  '保存失败！' + data.message);
                                btn.setDisabled(false);
                            } else {
                                //提示保存成功
                                Ext.toast({
                                    html: '<div style="text-align: center;">保存成功!</div>',
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                //重新加载表格数据
                                DSYGrid.getGrid('contentGrid').getStore().loadPage(1);
                                btn.up('window').close();
                            }
                        }, "json");
                    }
                },
                {
                    text: '关闭',
                    handler: function (btn) {
                        btn.up('window').close();
                    }
                }
            ]
        };
        return Ext.create('Ext.window.Window', window_config);
    }

    /**
     * 初始化支出保存弹出框表单
     */
    function initWindow_save_zcxx_form(config) {
        var form = Ext.create('Ext.form.Panel', {
            itemId: 'window_save_zcxx_form',
            width: '100%',
            layout: 'column',
            border: false,
            defaults: {
                columnWidth: .33,
                margin: '2 5 2 5',
                labelWidth: 85
            },
            margin: '0 0 5 0',
            defaultType: 'textfield',
            items: [
                //可支出总额PAY_XZ_AMT_TOTAL(已支出总额度+剩余可用额度)
                //初始已支出金额PAY_XZ_AMT_YZC_CS(已支出总额度)
                //本单初始支出PAY_XZ_AMT_YZC_BDCS(若是新增：0，若是修改：本单支出总额)
                //本单已支出金额PAY_XZ_AMT_YZC_BD(=本单初始支出，修改支出金额后改变)
                //未支出金额PAY_XZ_AMT_WZC(可支出总额-已支出总额度-本单已支出金额+本单初始支出)
                {fieldLabel: '地区', name: 'AD_CODE', hidden: true},
                {fieldLabel: '地区', name: 'AD_NAME', readOnly: true, fieldCls: 'form-unedit'},
                {fieldLabel: '债券', name: 'ZQ_ID', hidden: true},
                {fieldLabel: '债券名称', name: 'ZQ_NAME', xtype: 'displayfield', columnWidth: .66, readOnly: true},
                {fieldLabel: '支出类型', name: 'ZC_TYPE_NAME', readOnly: true, fieldCls: 'form-unedit'},
                {fieldLabel: '债券类型', name: 'ZQLB_NAME', readOnly: true, fieldCls: 'form-unedit'},
                {fieldLabel: '期限', name: 'ZQQX_NAME', readOnly: true, fieldCls: 'form-unedit'},
                {fieldLabel: "新增债券金额", name: "PAY_XZ_AMT_TOTAL", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "初始已支出金额", name: "PAY_XZ_AMT_YZC_CS", hidden: true, xtype: 'numberFieldFormat'},
                {fieldLabel: "本单初始支出金额", name: "PAY_XZ_AMT_YZC_BDCS", hidden: true, xtype: 'numberFieldFormat'},
                {fieldLabel: "本单已支出金额", name: "PAY_XZ_AMT_YZC_BD", hidden: true, xtype: 'numberFieldFormat'},
                {fieldLabel: "未支出金额", name: "PAY_XZ_AMT_WZC", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "支出进度(%)", name: "ZC_PROGRESS", readOnly: true, fieldCls: 'form-unedit'},
                {xtype: 'menuseparator', columnWidth: 1, margin: '2 0 2 0', border: true},//分割线
                {fieldLabel: "单据ID", name: "ZCD_ID", hidden: true},
                {fieldLabel: "国库支付ID", name: "GKZF_ID", hidden: true},
                {fieldLabel: '支出年度', name: 'ZCD_YEAR', hidden: true},
                {fieldLabel: "使用单位", name: "AG_ID", hidden: true},
                {fieldLabel: "使用单位", name: "AG_CODE", hidden: true},
                {fieldLabel: "使用单位", name: "AG_NAME", readOnly: true, fieldCls: 'form-unedit'},
                {fieldLabel: "支出总额(元)", name: "PAY_AMT_TOTAL", xtype: 'numberFieldFormat', readOnly: true, fieldCls: 'form-unedit-number'},
                {fieldLabel: "备注", name: "ZCD_REMARK", columnWidth: .66}
            ]
        });
        return form;
    }
    /**
     * 初始化债券支出修改弹出窗口表格
     */
    function initWindow_save_zcxx_grid(config) {
        var headerJson = [
            {xtype: 'rownumberer', width: 45},
            {
                text: "支出ID", dataIndex: "ZC_ID", type: "string", width: 150,hidden:true
            },
            {
                text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 250, tdCls: 'grid-cell-unedit',
                renderer: function (data, cell, record) {
                    var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {
                text: "支出日期", dataIndex: "PAY_DATE", type: "string", tdCls: 'grid-cell',
                editor: {
                    xtype: 'datefield',
                    format: 'Y-m-d',
                    listeners: {
                        change: function (self, newValue, oldValue) {
                            var newYear = dsyDateFormat(newValue).substr(0,4);
                            var oldYear = dsyDateFormat(oldValue).substr(0,4);
                            if (newYear != oldYear && newYear != km_year) {
                                Ext.MessageBox.wait('正在获取新年度功能分类、经济分类数据..', '请等待..');
                                DSYGrid.getGrid('window_save_zcxx_grid').getStore().each(function (record) {
                                    record.set('GNFL_ID', '');
                                    record.set('JJFL_ID', '');
                                    return;
                                });
                                km_year = newYear;
                                var condition_str = km_year <= 2017 ? " <= '2017' " : " = '"+km_year+"' ";
                                store_GNFL.proxy.extraParams['condition'] = encode64(" and year "+ condition_str);
                                store_JJFL.proxy.extraParams['condition'] = encode64(" and year "+ condition_str);
                                store_GNFL.load({
                                    callback : function() {
                                        store_JJFL.load({
                                            callback : function() {
                                                Ext.MessageBox.hide();
                                            }
                                        });
                                    }
                                });
                            }
                        }
                    }
                }
            },
            {
                text: "本次支出金额(元)", dataIndex: "PAY_AMT", type: "float", width: 160, tdCls: 'grid-cell',
                editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0}
            },
            {
                text: "功能分类", dataIndex: "GNFL_ID", type: "string", tdCls: 'grid-cell', width: 200,
                editor: {
                    xtype: 'treecombobox',
                    valueField: 'id',
                    displayField: 'name',
                    editable: false, //禁用编辑
                    selectModel: 'leaf',
                    rootVisible: false,
                    lines: false,
                    store: store_GNFL,
                    minPicekerWidth: 300
                },
                renderer: function (value) {
                    var record = store_GNFL.findNode('id', value, true, true, true);
                    return record != null ? record.get('name') : "";
                }
            },
            {
                text: "经济分类", dataIndex: "JJFL_ID", type: "string", tdCls: 'grid-cell', width: 200,
                editor: {
                    xtype: 'treecombobox',
                    valueField: 'id',
                    displayField: 'name',
                    editable: false, //禁用编辑
                    selectModel: 'leaf',
                    rootVisible: false,
                    lines: false,
                    store: store_JJFL,
                    minPicekerWidth: 300
                },
                renderer: function (value) {
                    var record = store_JJFL.findNode('id', value, true, true, true);
                    return record != null ? record.get('name') : "";
                }
            },
            {text: "项目类型", dataIndex: "XMLX_NAME", type: 'string', tdCls: 'grid-cell-unedit', width: 180},
            {
                text: '项目总概算(万元)', dataIndex: 'XMZGS_AMT', type: 'float', tdCls: 'grid-cell-unedit', width: 160,
                renderer: function (value) {
                    return Ext.util.Format.number(value / 10000, '0,000.######');
                }
            }
        ];
        var grid_config = DSYGrid.createGrid({
            itemId: 'window_save_zcxx_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            data: [],
            autoLoad: false,
            checkBox: true,
            border: false,
            height: '100%',
            width: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'window_save_zcxx_grid_plugin_cell',
                    clicksToMoveEditor: 1,
                    listeners: {
                        validateedit: function (editor, context) {
                            //债券金额验证
                            if (context.field == 'PAY_AMT') {
                                window.flag_validateedit = null;
                                var pay_amt = context.value;
                                if (context.value <= 0) {
                                    window.flag_validateedit = Ext.MessageBox.alert('提示', '支出金额必须大于0！');
                                    return false;
                                }
                                var grid = DSYGrid.getGrid("window_save_zcxx_grid");
                                var records = grid.getStore().getData();
                                var form = grid.up('tabpanel').down('form');
                                var xm_id = context.record.data.XM_ID;
                                /*修改表格中支出金额：
                                 循环表格
                                 校验：获取支出单总额，未支出金额(可支出总额-初始已支出总额度-本单已支出总额+本单初始支出)>=0
                                 支出单：支出单总额修改
                                 新增债券：未支出额度修改
                                 XMLSIT：修改对应项目的本单已支出金额*/
                                var PAY_AMT_TOTAL = 0;//支出单总额
                                var YZC_AMT_BD = 0;//对应项目的本单支出总额
                                for (var i = 0; i < records.length; i++) {
                                    if (records.items[i].internalId == context.record.internalId) {
                                        PAY_AMT_TOTAL += context.value;
                                    } else {
                                        PAY_AMT_TOTAL += records.items[i].data.PAY_AMT;
                                    }
                                    if (records.items[i].data.XM_ID == xm_id) {
                                        if (records.items[i].internalId == context.record.internalId) {
                                            YZC_AMT_BD += context.value;
                                        } else {
                                            YZC_AMT_BD += records.items[i].data.PAY_AMT;
                                        }
                                    }
                                }
                                //值*100/100解决小数精度问题
                                var PAY_XZ_AMT_WZC = form.down('[name=PAY_XZ_AMT_TOTAL]').getValue() * 100 - form.down('[name=PAY_XZ_AMT_YZC_CS]').getValue() * 100 - PAY_AMT_TOTAL * 100 + form.down('[name=PAY_XZ_AMT_YZC_BDCS]').getValue() * 100;
                                PAY_XZ_AMT_WZC = PAY_XZ_AMT_WZC / 100;
                                if (PAY_XZ_AMT_WZC < 0) {
                                    window.flag_validateedit = Ext.MessageBox.alert('提示', '支出金额超出债券最大可支出金额！');
                                    return false;
                                }

                                //校验通过，修改对应数据
                                form.down('[name=PAY_AMT_TOTAL]').setValue(PAY_AMT_TOTAL);
                                form.down('[name=PAY_XZ_AMT_YZC_BD]').setValue(PAY_AMT_TOTAL);
                                form.down('[name=PAY_XZ_AMT_WZC]').setValue(PAY_XZ_AMT_WZC);
                                var ZC_PROGRESS = (form.down('[name=PAY_XZ_AMT_TOTAL]').getValue() - PAY_XZ_AMT_WZC ) / form.down('[name=PAY_XZ_AMT_TOTAL]').getValue() * 100;
                                ZC_PROGRESS = Ext.util.Format.number(ZC_PROGRESS, '0.00');
                                form.down('[name=ZC_PROGRESS]').setValue(ZC_PROGRESS);
                                return true;
                            }
                        },
                        edit: function (editor, context) {
                            if (context.field == 'PAY_DATE') {
                                context.record.set(context.field, Ext.util.Format.date(context.value, 'Y-m-d'));
                            }
                        },

                    }
                }
            ],
            listeners: {
                selectionchange: function (self, records) {
                    Ext.ComponentQuery.query('window#window_save_zcxx')[0].down('button[name=deleteZC]').setDisabled(records.length==0);
                }
            }
        });
        grid_config.getStore().on('endupdate', function () {
            var grid = DSYGrid.getGrid("window_save_zcxx_grid");
            var records = grid.getStore();
            var form = grid.up('tabpanel').down('form');
            var PAY_AMT_TOTAL = 0;//支出单总额
            records.each(function (record) {
                PAY_AMT_TOTAL += record.get('PAY_AMT');
            });
            var PAY_XZ_AMT_WZC = form.down('[name=PAY_XZ_AMT_TOTAL]').getValue() * 100 - form.down('[name=PAY_XZ_AMT_YZC_CS]').getValue() * 100 - PAY_AMT_TOTAL * 100 + form.down('[name=PAY_XZ_AMT_YZC_BDCS]').getValue() * 100;
            PAY_XZ_AMT_WZC = PAY_XZ_AMT_WZC / 100;
            form.down('[name=PAY_AMT_TOTAL]').setValue(PAY_AMT_TOTAL);
            form.down('[name=PAY_XZ_AMT_YZC_BD]').setValue(PAY_AMT_TOTAL);
            form.down('[name=PAY_XZ_AMT_WZC]').setValue(PAY_XZ_AMT_WZC);
            var ZC_PROGRESS = (form.down('[name=PAY_XZ_AMT_TOTAL]').getValue() - PAY_XZ_AMT_WZC ) / form.down('[name=PAY_XZ_AMT_TOTAL]').getValue() * 100;
            ZC_PROGRESS = Ext.util.Format.number(ZC_PROGRESS, '0.00');
            form.down('[name=ZC_PROGRESS]').setValue(ZC_PROGRESS);
        });
        return grid_config;
    }
    /*计算主单的数据*/
    function initZcxx_data_zdmx(data_zdmx, data_zcd, config) {
        //可支出总额PAY_XZ_AMT_TOTAL(已支出总额度+剩余可用额度)
        //初始已支出金额PAY_XZ_AMT_YZC_CS(已支出总额度)
        //本单初始支出PAY_XZ_AMT_YZC_BDCS(若是新增：0，若是修改：本单支出总额)
        //本单已支出金额PAY_XZ_AMT_YZC_BD(=本单初始支出，修改支出金额后改变)
        //未支出金额PAY_XZ_AMT_WZC(可支出总额-已支出总额度-本单已支出金额+本单初始支出)
        data_zdmx.PAY_XZ_AMT_TOTAL = data_zdmx.PAY_XZ_AMT + data_zdmx.SY_XZ_AMT;
        data_zdmx.PAY_XZ_AMT_YZC_CS = data_zdmx.PAY_XZ_AMT;
        data_zdmx.PAY_XZ_AMT_YZC_BDCS = config.PAY_XZ_AMT_YZC_BDCS;//新增：0，修改：支出单支出总额
        data_zdmx.PAY_XZ_AMT_YZC_BD = data_zdmx.PAY_XZ_AMT_YZC_BDCS;
        data_zdmx.PAY_XZ_AMT_WZC = data_zdmx.PAY_XZ_AMT_TOTAL - data_zdmx.PAY_XZ_AMT_YZC_CS - data_zdmx.PAY_XZ_AMT_YZC_BD + data_zdmx.PAY_XZ_AMT_YZC_BDCS;
        data_zdmx.ZC_PROGRESS = (data_zdmx.PAY_XZ_AMT_TOTAL - data_zdmx.PAY_XZ_AMT_WZC) / data_zdmx.PAY_XZ_AMT_TOTAL * 100;
        data_zdmx.ZC_PROGRESS = Ext.util.Format.number(data_zdmx.ZC_PROGRESS, '0.00');
        data_zdmx.ZC_TYPE_NAME = '新增债券支出';
        //data_zdmx.ZQ_NAME = '<a href="/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + data_zdmx.ZQ_ID + '&AD_CODE=' + data_zdmx.AD_CODE.replace(/00$/, "") + '" target="_blank" style="color:#3329ff;">' + data_zdmx.ZQ_NAME + '</a>';
        var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
        var paramNames=new Array();
        paramNames[0]="ZQ_ID";
        paramNames[1]="AD_CODE";
        var paramValues=new Array();
        paramValues[0]=encodeURIComponent(data_zdmx.ZQ_ID);
        paramValues[1]=encodeURIComponent(data_zdmx.AD_CODE.replace(/00$/, ""));
        data_zdmx.ZQ_NAME='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+ data_zdmx.ZQ_NAME+'</a>';
        //支出单相关信息
        data_zdmx.ZCD_ID = data_zcd.ZCD_ID;
        data_zdmx.AG_ID = data_zcd.AG_ID;
        data_zdmx.AG_CODE = data_zcd.AG_CODE;
        data_zdmx.AG_NAME = data_zcd.AG_NAME;
        data_zdmx.PAY_AMT_TOTAL = data_zcd.PAY_AMT_TOTAL;
        return data_zdmx;
    }

    function initZcxx_data_zcmx_UPDATE(data_zcmx, window_zc) {
        //将数据插入到填报表格中
        Ext.MessageBox.wait('正在获取明细支出数据...', '请等待..');
        var year = data_zcmx[0].PAY_DATE.substr(0,4);
        km_year = year;
        var condition_str = year <= 2017 ? " <= '2017' " : " = '"+year+"' ";
        store_GNFL.proxy.extraParams['condition'] = encode64(" and year "+ condition_str);
        store_JJFL.proxy.extraParams['condition'] = encode64(" and year "+ condition_str);
        store_GNFL.load({
            callback : function() {
                store_JJFL.load({
                    callback : function() {
                        //将数据插入到填报表格中
                        window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx);
                        Ext.MessageBox.hide();
                    }
                });
            }
        });
        return false;
    }
    /**
     * 初始化新增债券发行计划选择弹出窗口
     */
    function initWindow_select_xzzq(param) {
        return Ext.create('Ext.window.Window', {
            title: '新增债券项目选择', // 窗口标题
            width: document.body.clientWidth * 0.95, // 窗口宽度
            height: document.body.clientHeight * 0.95, // 窗口高度
            itemId: 'window_select_xzzq', // 窗口标识
            layout: 'fit',
            maximizable: true,
            buttonAlign: 'right', // 按钮显示的位置
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
            items: [initWindow_select_xzzq_grid(param)],
            buttons: [
                {
                    text: '确认',
                    ZCD_YEAR: param.ZCD_YEAR,
                    handler: function (btn) {
                        //获取表格选中数据
                        var records = btn.up('window').down('grid').getSelection();
                        if (records.length <= 0) {
                            Ext.MessageBox.alert('提示', '请选择至少一条数据后再进行操作');
                            return;
                        }
                        //校验所有插入的发行计划都是同一单位
                        var ag_id = null;
                        var ids = [];
                        for (var i in records) {
                            ids[i] = records[i].data.XM_ID ;
                            if (!records[i].get('AG_ID') || records[i].get('AG_ID') == '') {
                                Ext.MessageBox.alert('提示', '所选数据必须都具有单位！');
                                return false;
                            }
                            if (!ag_id) {
                                ag_id = records[i].get('AG_ID');
                            } else if (ag_id != records[i].get('AG_ID')) {
                                Ext.MessageBox.alert('提示', '所选数据必须是同一单位！');
                                return false;
                            }
                        }
                        initZcxxData_confirm(btn, ids);
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
     * 初始化新增债券发行计划选择弹出框表格
     */
    function initWindow_select_xzzq_grid(param) {
        var headerJson = [
            {xtype: 'rownumberer', width: 45},
            {text: "单位名称", dataIndex: "AG_NAME", type: "string", width: 220},
            {
                text: "项目名称", dataIndex: "XM_NAME", type: "string", width: 300,
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/jsxm/jsxmYhsMain.jsp?XM_ID=' + record.get('XM_ID');
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/jsxm/jsxmYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="XM_ID";
                    var paramValues=new Array();
                    paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            },
            {text: "立项年度", dataIndex: "LX_YEAR", type: "string"},
            {text: "建设性质", dataIndex: "JSXZ_NAME", type: "string"},
            {text: "项目类型", dataIndex: "XMLX_NAME", type: "string", width: 180},
            {text: "项目性质", dataIndex: "XMXZ_NAME", type: "string", width: 180},
            {text: "立项审批级次", dataIndex: "SPJC_NAME", type: "string"},
            {text: "计划开工日期", dataIndex: "START_DATE_PLAN", type: "string"},
            {text: "计划竣工日期", dataIndex: "END_DATE_PLAN", type: "string"},
            {text: "实际开工日期", dataIndex: "START_DATE_ACTUAL", type: "string"},
            {text: "实际竣工日期", dataIndex: "END_DATE_ACTUAL", type: "string"},
            {text: "建设状态", dataIndex: "JSZT_NAME", type: "string"},
            {text: "项目单位", dataIndex: "AG_NAME", type: "string", width: 220},
            {text: "管理(使用)单位", dataIndex: "USE_UNIT_ID", type: "string", width: 220},
            {text: "计划申报年度", dataIndex: "BILL_YEAR", type: "string"},
            {text: "备注", dataIndex: "REMARK", type: "string", width: 220}
        ];
        var grid = DSYGrid.createGrid({
            itemId: 'window_select_xzzq_grid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            border: true,
            width: '100%',
            flex: 1,
            pageConfig: {
                enablePage: false
            },
            params: {
                AD_CODE: AD_CODE,
                AG_CODE: AG_CODE,
                AG_ID: (param && param.ag_id) ? param.ag_id : AG_ID,
                ZCD_YEAR: (param && param.ZCD_YEAR) ? param.ZCD_YEAR : nowDate.substring(0, 4),
            },
            dataUrl: '/getFxdfZqsyXzzqGrid.action'
        });
        //将form添加到表格中
        var searchTool = initWindow_xzzq_grid_searchTool();
        grid.addDocked(searchTool, 0);
        return grid;
    }


    /**
     * 初始化新增债券计划选择弹出框搜索区域
     */
    function initWindow_xzzq_grid_searchTool() {
        //初始化查询控件
        var items = [];
        items.push(
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
                itemId: 'contentGrid_search',
                //width: 380,
                columnWidth : .45,
                labelWidth: 60,
                labelAlign: 'right',
                enableKeyEvents: true,
                emptyText: '请输入项目编码/项目名称/项目管理(使用)单位...',
                listeners: {
                    keypress: function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var form = self.up('form');
                            if (form.isValid()) {
                                callBackReload();
                            } else {
                                Ext.Msg.alert("提示", "查询区域未通过验证！");
                            }
                        }
                    }
                }
            }
        );
        //设置查询form
        var searchTool = new DSYSearchTool();
        searchTool.setSearchToolId('searchTool_grid');
        var search_form = searchTool.create({
            items: items,
            border: true,
            bodyStyle: 'border-width:0 0 0 0;',
            dock: 'top',
            defaults: {
                labelWidth: 60,
                width: 200,
                margin: '5 5 5 5',
                labelAlign: 'right'
            }
        });
        //重新加载按钮
        search_form.remove(search_form.down('toolbar'));
        search_form.addDocked({
            xtype: 'toolbar',
            border: false,
            width: 140,
            dock: 'right',
            layout: {
                type: 'hbox',
                align: 'center',
                pack: 'start'
            },
            padding: '0 10 0 0',
            items: [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        var form = btn.up('form');
                        if (form.isValid()) {
                            callBackReload();
                        } else {
                            Ext.Msg.alert("提示", "查询区域未通过验证！");
                        }
                    }
                },
                '->', {
                    xtype: 'button',
                    text: '重置',
                    icon: '/image/sysbutton/cancel.png',
                    handler: function (btn) {
                        var form = btn.up('form');
                        form.reset();
                    }
                }
            ]
        });
        function callBackReload() {
            var xmlx = Ext.ComponentQuery.query('treecombobox#XMLX_SEARCH')[0].getValue();
            var mhcx = Ext.ComponentQuery.query('textfield#contentGrid_search')[0].getValue();
            var grid = DSYGrid.getGrid('window_select_xzzq_grid');
            grid.getStore().getProxy().extraParams['XMLX_SEARCH'] = xmlx;
            grid.getStore().getProxy().extraParams['mhcx'] = mhcx;
            grid.getStore().load();
        }
        return search_form;
    }
    /**
     * 初始化支出数据
     */
    function initZcxxData_confirm(btn, ids) {
        //选择完发行计划，计算发行计划关联的项目的预算金额、已拨付金额
        //预算金额=关联的项目关联的发行计划申请金额合计，已拨付金额：关联的项目的所有支出的金额合计
        $.post('/getFxdfZqsyXzzqGrid_select.action', {ids: ids, ZCD_YEAR: btn.ZCD_YEAR}, function (data) {
            if (!data.success) {
                Ext.MessageBox.alert('提示', '获取项目相关信息失败！' + data.message);
                return;
            }
            var window_zc = Ext.ComponentQuery.query('window#window_save_zcxx')[0];
            var data_zcmx = data.data;
            window_zc.XM_LIST = window_zc.XM_LIST ? window_zc.XM_LIST : {};//存储项目的相关金额：预算金额(项目总金额)、已支出金额、未拨付金额(未支出金额)、
            //循环初始化支出明细数据
            initZcxx_data_zcmx_ADD(data_zcmx, window_zc);
            btn.up('window').close();
        }, 'json');
    }

    /**
     * 循环初始化支出明细数据：新增
     * @param data_zcmx
     * @param window_zc
     */
    function initZcxx_data_zcmx_ADD(data_zcmx, window_zc) {
        for (var i = 0; i < data_zcmx.length; i++) {
            data_zcmx[i].PAY_DATE = nowDate;
            var xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
            if (!xm) {
                //新增项目
                window_zc.XM_LIST[data_zcmx[i].XM_ID] = {};
                xm = window_zc.XM_LIST[data_zcmx[i].XM_ID];
                xm.YZC_AMT_BDCS = 0;
                xm.YZC_AMT_BD = xm.YZC_AMT_BDCS;
            }
        }
        var fields = window_zc.down('grid#window_save_zcxx_grid').fields;
        //将数据插入到填报表格中
        window_zc.down('grid#window_save_zcxx_grid').insertData(null, data_zcmx);
    }

    /**
     * 支出信息保存校验
     */
    function checkEditorGrid(grid) {
        for (var i = 0; i < grid.getStore().getCount(); i++) {
            var record = grid.getStore().getAt(i);
            if (!record.get('PAY_DATE') || record.get('PAY_DATE') == null || record.get('PAY_DATE') == '') {
                return '支出日期不能为空！';
            }
            if (!record.get('PAY_AMT') || record.get('PAY_AMT') == null || record.get('PAY_AMT') <= 0) {
                return '支出金额必须大于0！';
            }
            if (!record.get('GNFL_ID') || record.get('GNFL_ID') == null || record.get('GNFL_ID') == '') {
                return '功能分类不能为空！';
            }
            if (!record.get('JJFL_ID') || record.get('JJFL_ID') == null || record.get('JJFL_ID') == '') {
                return '经济分类不能为空！';
            }
        }
    }

    /**
     * 初始化债券填报表单中页签panel的附件页签
     */
    function initWindow_save_zcxx_tab_upload(config) {
        var grid = UploadPanel.createGrid({
            busiType: 'ET205',//业务类型
            busiId: config.gridId,//业务ID
            busiProperty: '%',//业务规则
            editable: true,//是否可以修改附件内容
            gridConfig: {
                itemId: 'window_save_zcxx_tab_upload_grid'
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
            if (grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
    }

    function reloadGrid(param, param_detail) {
        var grid = DSYGrid.getGrid('contentGrid');
        var store = grid.getStore();
        var  WF_STATUS=Ext.ComponentQuery.query('combobox[name="WF_STATUS"]')[0].getValue();
        store.getProxy().extraParams['WF_STATUS']=WF_STATUS;
        store.getProxy().extraParams['ad_code']=AD_CODE;
        store.getProxy().extraParams['ag_id']=AG_ID;
        store.getProxy().extraParams['ag_code']=AG_CODE;
        //增加查询参数
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
        //刷新
        store.loadPage(1);

    }



</script>
</body>
</html>
