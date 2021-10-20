/**
 * js：政府债务录入
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
var q_title = null;
var is_xz = false;
var tab_items = {/*'clzw':{},'xmzc':{},'ztb':{},'jsjd':{},'sjsy':{}*/};
var tab_items_load = {
    'jbqk': {},
    'tzjh': {},
    'szys': {},/*'clzw':{},'xmzc':{},*/
    'ztb': {},
    'jsjd': {},
    'sjsy': {},
    'sdgc': {}
};
var is_zxzqxt = getQueryParam("is_zxzqxt");// 20200818_zhuangrx_湖北个性参数，这里用来控制是否添加工程类别字段
//项目总览
if (is_view == "1") {
    $.extend(jsxm_json_common, {
        defautItems: WF_STATUS,//默认状态
        items_content: function () {
            return [
                initContentTree({
                    areaConfig: {
                        params: {
                            CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                        }
                    }
                }),//初始化左侧树
                initContentRightPanel()//初始化右侧2个表格
            ];
        },
        items: {
            '001': [
                {
                    xtype: 'button',
                    text: '查询',
                    icon: '/image/sysbutton/search.png',
                    handler: function (btn) {
                        loadOption[option + "#" + AD_CODE + "#" + AG_CODE] = 0;
                        if (AD_CODE == null || AD_CODE == '') {
                            Ext.Msg.alert('提示', '请选择区划！');
                            return;
                        } else {
                            getHbfxDataList();
                        }
                    }
                },
                {
                    xtype: 'button',
                    text: '导出',
                    name: 'up',
                    icon: '/image/sysbutton/export.png',
                    handler: function (btn) {
                        DSYGrid.exportExcelClick('contentGrid' + (option == '1' ? '' : option), {
                            exportExcel: true,
                            url: 'exportExcel_jsxm.action',
                            param: {
                                q_title: q_title
                            }
                        });
                    }
                },
                {
                    xtype: 'button',
                    text: '项目申报导出',
                    name: 'up',
                    icon: '/image/sysbutton/export.png',
                    hidden: IS_SHOW_SPEC_UPLOAD_BTN == '0' ? true : false,
                    handler: function (btn) {
                        var records = DSYGrid.getGrid('contentGrid' + (option == '1' ? '' : option)).getSelection();
                        if (records.length == 0) {
                            Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                            return;
                        } else if (records.length > 1) {
                            Ext.MessageBox.alert('提示', '不能同时导出多条记录！');
                            return;
                        } else {
                            XM_ID = records[0].get("XM_ID");
                            DSYGrid.exportExcelClick('contentGrid' + (option == '1' ? '' : option), {
                                exportExcel: true,
                                url: 'exportExcel_sbxm.action',
                                param: {
                                    XM_ID: XM_ID
                                }
                            });
                        }

                        /*
                        DSYGrid.exportExcelClick('contentGrid', {
                            exportExcel: true,
                            url: 'exportExcel_jsxm.action',
                            param: {
                                q_title:q_title
                            }
                        });
                   */
                    }
                },
                '->',
                initButton_OftenUsed(),
                initButton_Screen()
            ]
        }
    });
} else {
    if (is_cl == "1") {
        $.extend(jsxm_json_common, {
            defautItems: WF_STATUS,//默认状态
            items_content: function () {
                return [
                    initContentTree({
                        areaConfig: {
                            params: {
                                CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                            }
                        }
                    }),//初始化左侧树
                    initContentRightPanel()//初始化右侧2个表格
                ];
            },
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
                                getHbfxDataList();
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
                            // 获取选中数据
                            var records = DSYGrid.getGrid('contentGrid').getSelection();
                            if (records.length == 0) {
                                Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                return;
                            } else if (records.length > 1) {
                                Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                return;
                            } else {
                                if (records[0].get("ZTBG") != 0) {
                                    Ext.MessageBox.alert('提示', '该项目已录入项目变更，请完成变更流程后再尝试！');
                                    return;
                                }
                                XM_ID = records[0].get("XM_ID");
                                /*AG_ID = records[0].get("AG_ID");
                                AG_CODE = records[0].get("AG_CODE");*/
                                AG_NAME = records[0].get("AG_NAME");
                                button_name = btn.name;
                            }
                            title = "基础库项目修改";
                            button_name = btn.name
                            window_zqxxtb.show();
                            loadInfo();
                        }
                    },
                    {
                        xtype: 'button',
                        text: '删除',
                        hidden: true,
                        icon: '/image/sysbutton/delete.png',
                        handler: function (btn) {
                            //获取表格被选中行
                            var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                            if (records.length <= 0) {
                                Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                return;
                            }
                            Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                if (btn_confirm == 'yes') {
                                    deleteBasicInfo();
                                }
                            });
                        }
                    },
                    '->',
                    initButton_OftenUsed(),
                    initButton_Screen()
                ]
            }
        });
    } else {
        if (node_type == "tb") {
            $.extend(jsxm_json_common, {
                defautItems: WF_STATUS,//默认状态
                items_content: function () {
                    return [
                        initContentTree({
                            areaConfig: {
                                params: {
                                    CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                                }
                            }
                        }),//初始化左侧树
                        initContentRightPanel()//初始化右侧2个表格
                    ];
                },
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
                                    getHbfxDataList();
                                }
                            }
                        },
                        {
                            xtype: 'button',
                            text: '新增',
                            name: 'INPUT',
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                address_Can_Alert = 'canAlter';

                                if (!AG_ID || AG_ID == '') {
                                    Ext.Msg.alert('提示', "请选择单位");
                                    return;
                                }
                                //获取左侧树的单位信息
                                var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                                AG_CODE = treeArray[1].getSelection()[0].get('code');
                                AG_ID = treeArray[1].getSelection()[0].get('id');
                                AG_NAME = treeArray[1].getSelection()[0].get('text');
                                is_xz = false;
                                connNdjh = 0;
                                connZwxx = 0;
                                button_name = 'INPUT';
                                title = "基础库项目录入";
                                //发送ajax请求，获取新增主表id
                                $.post("/getId.action", function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }
                                    //弹出弹出框，设置XM_ID
                                    XM_ID = data.data[0];
                                }, "json");
                                //获取单位统一社会信用代码
                                $.post("/getAgtyshcode.action", {
                                    AG_ID: AG_ID
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }
                                    //统一社会信用代码
                                    USCCODE = data.data[0].TYSHXYDM;
                                    window_zqxxtb.show();
                                }, "json");
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'UPDATE',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                // 检验是否选中数据
                                // 获取选中数据
                                is_xz = false;
                                address_Can_Alert = 'canAlter';
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                } else if (records.length > 1) {
                                    Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                    return;
                                } else {
                                    if (records[0].get("ZTBG") != 0) {
                                        Ext.MessageBox.alert('提示', '该项目已录入项目变更，请完成变更流程后再尝试！');
                                        return;
                                    }
                                    XM_ID = records[0].get("XM_ID");
                                    /*AG_ID = records[0].get("AG_ID");
                                    AG_CODE = records[0].get("AG_CODE");
                                    AG_NAME = records[0].get("AG_NAME");*/
                                    button_name = btn.name;
                                }
                                title = "基础库项目修改";
                                window_zqxxtb.show();
                                loadInfo();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                //获取表格被选中行
                                var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                                if (records.length <= 0) {
                                    Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm == 'yes') {
                                        deleteBasicInfo();
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
                            handler: function (btn) {
                                dooperation();
                            }
                        },
                        /*  {
                              xtype: 'button',
                              itemId:'mbxz',
                              text: '模板下载',
                              handler: function (btn) {
                                  szysExcelDown();//收支平衡表格模板下载
                              }
                          },*/
                        {
                            xtype: 'button',
                            text: '专项债数据导入',
                            name: 'up',
                            icon: '/image/sysbutton/export.png',
                            hidden: IS_INPUT == '0' ? false : true,
                            handler: function (btn) {
                                initWindow_uploadData("S", "ZXZ", 0.7, 0.9);
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
                                    getHbfxDataList();
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
                        /*{
                            xtype: 'button',
                            itemId:'mbxz',
                            text: '模板下载',
                            handler: function (btn) {
                                szysExcelDown();//收支平衡表格模板下载
                            }
                        },*/
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
                                    getHbfxDataList();
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
                                // 获取选中数据
                                is_xz = false;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                } else if (records.length > 1) {
                                    Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                    return;
                                } else {
                                    if (records[0].get("ZTBG") != 0) {
                                        Ext.MessageBox.alert('提示', '该项目已录入项目变更，请完成变更流程后再尝试！');
                                        return;
                                    }
                                    XM_ID = records[0].get("XM_ID");
                                    /*AG_ID = records[0].get("AG_ID");
                                    AG_CODE = records[0].get("AG_CODE");
                                    AG_NAME = records[0].get("AG_NAME");*/
                                    button_name = btn.name;
                                }
                                title = "基础库项目修改";
                                window_zqxxtb.show();
                                loadInfo();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                //获取表格被选中行
                                var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                                if (records.length <= 0) {
                                    Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm == 'yes') {
                                        deleteBasicInfo();
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
                            handler: function (btn) {
                                dooperation();
                            }
                        },
                        /*  {
                              xtype: 'button',
                              itemId:'mbxz',
                              text: '模板下载',
                              handler: function (btn) {
                                  szysExcelDown();//收支平衡表格模板下载
                              }
                          },*/
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
                                    getHbfxDataList();
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
                        /*   {
                               xtype: 'button',
                               itemId:'mbxz',
                               text: '模板下载',
                               handler: function (btn) {
                                   szysExcelDown();//收支平衡表格模板下载
                               }
                           },*/
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                }
            });
        } else if (node_type == "sh") {
            $.extend(jsxm_json_common, {
                defautItems: WF_STATUS,//默认状态
                items_content: function () {
                    return [
                        initContentTree({
                            areaConfig: {
                                params: {
                                    CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                                }
                            }
                        }),//初始化左侧树
                        initContentRightPanel()//初始化右侧2个表格
                    ];
                },
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
                                    getHbfxDataList();
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
                        /* {
                             xtype: 'button',
                             itemId:'mbxz',
                             text: '模板下载',
                             handler: function (btn) {
                                 szysExcelDown();//收支平衡表格模板下载
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
                                if (AD_CODE == null || AD_CODE == '') {
                                    Ext.Msg.alert('提示', '请选择区划！');
                                    return;
                                } else {
                                    getHbfxDataList();
                                }
                            }
                        },
                        {
                            xtype: 'button',
                            text: '撤销审核',
                            name: 'cancel',
                            icon: '/image/sysbutton/audit.png',
                            handler: function (btn) {
                                // 获取选中数据
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                }/* else if (records.length > 1) {
                                    Ext.MessageBox.alert('提示', '不能同时选择多条记录！');
                                    return;
                                }*/
                                var ids = [];
                                for (var i in records) {
                                    ids.push(records[i].get("XM_ID"));
                                }
                                // 发送ajax请求，获取当前项目是否存在债券申请记录
                                $.post("/getXmIsexistZqsqjl.action", {
                                    //XM_ID : records[0].get('XM_ID')
                                    XM_IDS: ids
                                }, function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '撤销审核' + '失败！' + data.message);
                                        return;
                                    }
                                    doWorkFlow(btn);
                                }, "json");
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
            });
        } else { // 供外债系统使用
            $.extend(jsxm_json_common, {
                defautItems: WF_STATUS,//默认状态
                items_content: function () {
                    return [
                        initContentTree({
                            areaConfig: {
                                params: {
                                    CHILD: v_child//区划树参数，1只显示本级，其它显示全部，默认显示全部
                                }
                            }
                        }),//初始化左侧树
                        initContentRightPanel()//初始化右侧2个表格
                    ];
                },
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
                                    getHbfxDataList();
                                }
                            }
                        },
                        {
                            xtype: 'button',
                            text: '新增',
                            name: 'INPUT',
                            hidden: isHiddenXZ,
                            icon: '/image/sysbutton/add.png',
                            handler: function (btn) {
                                address_Can_Alert = 'canAlter';
                                is_xz = false;
                                connNdjh = 0;
                                connZwxx = 0;
                                if (!AG_ID || AG_ID == '') {
                                    Ext.Msg.alert('提示', "请选择单位");
                                    return;
                                }
                                //获取左侧树的单位信息
                                var treeArray = btn.up('panel').down('panel#treePanel_left').query('treepanel');
                                AG_CODE = treeArray[1].getSelection()[0].get('code');
                                AG_ID = treeArray[1].getSelection()[0].get('id');
                                AG_NAME = treeArray[1].getSelection()[0].get('text');
                                button_name = 'INPUT';
                                title = "基础库项目录入";
                                //发送ajax请求，获取新增主表id
                                $.post("/getId.action", function (data) {
                                    if (!data.success) {
                                        Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
                                        return;
                                    }
                                    //弹出弹出框，设置XM_ID
                                    XM_ID = data.data[0];
                                    window_zqxxtb.show();
                                }, "json");
                            }
                        },
                        {
                            xtype: 'button',
                            text: '修改',
                            name: 'UPDATE',
                            icon: '/image/sysbutton/edit.png',
                            handler: function (btn) {
                                address_Can_Alert = 'canAlter';
                                // 检验是否选中数据
                                // 获取选中数据
                                is_xz = false;
                                var records = DSYGrid.getGrid('contentGrid').getSelection();
                                if (records.length == 0) {
                                    Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                                    return;
                                } else if (records.length > 1) {
                                    Ext.MessageBox.alert('提示', '不能同时修改多条记录！');
                                    return;
                                } else {
                                    if (records[0].get("ZTBG") != 0) {
                                        Ext.MessageBox.alert('提示', '该项目已录入项目变更，请完成变更流程后再尝试！');
                                        return;
                                    }
                                    XM_ID = records[0].get("XM_ID");
                                    /*AG_ID = records[0].get("AG_ID");
                                    AG_CODE = records[0].get("AG_CODE");
                                    AG_NAME = records[0].get("AG_NAME");*/
                                    button_name = btn.name;
                                }
                                title = "基础库项目修改";
                                window_zqxxtb.show();
                                loadInfo();
                            }
                        },
                        {
                            xtype: 'button',
                            text: '删除',
                            icon: '/image/sysbutton/delete.png',
                            handler: function (btn) {
                                //获取表格被选中行
                                var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                                if (records.length <= 0) {
                                    Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                                    return;
                                }
                                Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
                                    if (btn_confirm == 'yes') {
                                        deleteBasicInfo();
                                    }
                                });
                            }
                        },
                        /* {
                             xtype: 'button',
                             itemId:'mbxz',
                             text: '模板下载',
                             handler: function (btn) {
                                 szysExcelDown();//收支平衡表格模板下载
                             }
                         },*/
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()
                    ]
                }
            });
        }
    }
}

/**
 * 查询按钮实现
 */
function getHbfxDataList() {
    var grid = DSYGrid.getGrid("contentGrid");
    if (is_view == '1' && option != '1') {
        grid = DSYGrid.getGrid("contentGrid" + option);
    }
    //如果该页签已加载过，则不再次加载
    if (is_view == '1' && (typeof loadOption[option + "#" + AD_CODE + "#" + AG_CODE] != 'undefined'
        && loadOption[option + "#" + AD_CODE + "#" + AG_CODE] != null
        && loadOption[option + "#" + AD_CODE + "#" + AG_CODE] == 1)) {
        return;
    }
    loadOption[option + "#" + AD_CODE + "#" + AG_ID] = 1;
    var store = grid.getStore();
    var XMXZ_ID = Ext.ComponentQuery.query('treecombobox#XMXZ_SEARCH')[0].getValue();
    var XMLX_ID = Ext.ComponentQuery.query('treecombobox#XMLX_SEARCH')[0].getValue();
    var JSXZ_ID = Ext.ComponentQuery.query('combobox#JSXZ_SEARCH')[0].getValue();
    var mhcx = Ext.ComponentQuery.query('textfield#XM_SEARCH')[0].getValue();
    var lxnd = Ext.ComponentQuery.query('textfield#LXND_SEARCH')[0].getValue();
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
        is_wzxt: is_wzxt,
        userCode: userCode,
        wf_id: wf_id,
        node_code: node_code,
        WF_STATUS: WF_STATUS,
        node_type: node_type,
        option: option,
        is_view: is_view
    };
    store.loadPage(1);
}

/**
 * 删除债务合同信息
 */
function deleteBasicInfo() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
    } else {
        var basicInfoArray = [];
        Ext.each(records, function (record) {
            var array = {};
            array.XM_ID = record.get("XM_ID");
            basicInfoArray.push(array);
        });
        //向后台传递变更数据信息
        Ext.Ajax.request({
            method: 'POST',
            url: "delJSXMInfo.action",
            params: {
                isOld_szysGrid: isOld_szysGrid,
                basicInfoArray: Ext.util.JSON.encode(basicInfoArray)
            },
            async: false,
            success: function (response) {
                var respText = Ext.util.JSON.decode(response.responseText);
                Ext.MessageBox.show({
                    title: '提示',
                    msg: respText.message,
                    width: 200,
                    buttons: Ext.MessageBox.OK,
                    fn: function () {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            },
            failure: function (resp, opt) {
                var result = Ext.util.JSON.decode(resp.responseText);
                //if(result.success){
                Ext.MessageBox.show({
                    title: '提示',
                    msg: '删除失败!' + result.message,
                    width: 200,
                    fn: function () {
                        DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                    }
                });
            }
        });
    }
}

//创建债券信息填报弹出窗口
var window_zqxxtb = {
    window: null,
    config: {
        closeAction: 'destroy'
    },
    show: function () {
        if (!this.window || this.config.closeAction == 'destroy') {

            this.window = initWindow_zqxxtb();
        }
        this.window.show();
    }
};

/**
 * 项目总览主表格
 */
function initContentTabGrid() {
    return Ext.create('Ext.tab.Panel', {
        name: 'XmTabPanel',
        layout: 'fit',
        flex: 1,
        border: false,
        defaults: {
            layout: 'fit',
            border: false
        },
        items: [
            //{title: '全部', opstatus: 0, items:[initContentGrid("contentGrid") ]},
            /*{title: '储备库', opstatus: 1, items:[initContentGrid("contentGrid") ]},
            {title: '需求库', opstatus: 2, items:[initContentGrid("contentGrid2") ],hidden:true},
            {title: '执行库', opstatus: 3, items:[initContentGrid("contentGrid3") ]},
            {title: '执行库', opstatus: 4, items:[initContentGrid("contentGrid4") ],hidden:true}*/
            //湖南调整改库的名称基础改为储备、储备改为需求
            // GxdzUrlParam!='43'?{title: '基础库', opstatus: 1, items:[initContentGrid("contentGrid") ]}:{title: '储备库', opstatus: 1, items:[initContentGrid("contentGrid") ]},
            // GxdzUrlParam!='43'?{title: '储备库', opstatus: 2, items:[initContentGrid("contentGrid2") ]}:{title: '需求库', opstatus: 2, items:[initContentGrid("contentGrid2") ]},
            {title: '储备项目', opstatus: 1, items: [initContentGrid("contentGrid")]},
            {title: '需求项目', opstatus: 2, items: [initContentGrid("contentGrid2")]},
            {title: '发行项目', opstatus: 3, items: [initContentGrid("contentGrid3")]},
            {title: '存续项目', opstatus: 4, items: [initContentGrid("contentGrid4")]}
        ],
        listeners: {
            tabchange: function (tabPanel, newCard) {
                option = newCard.opstatus;
                //如果该页签已加载过，则不再次加载
                if (typeof loadOption[option + "#" + AD_CODE + "#" + AG_CODE] != 'undefined'
                    && loadOption[option + "#" + AD_CODE + "#" + AG_CODE] != null
                    && loadOption[option + "#" + AD_CODE + "#" + AG_CODE] == 1) {
                    return;
                } else {
                    reloadGrid('contentGrid' + option);
                }
            }
        }
    });
}

/**
 * 初始化右侧主表格
 */
function initContentGrid(param) {
    var headerJson = [
        {
            xtype: 'rownumberer',
            summaryType: 'count',
            width: 40
        },
        {
            "dataIndex": "XM_ID",
            "type": "string",
            "text": "项目ID",
            "fontSize": "15px",
            "hidden": true
        }, {
            "dataIndex": "AG_NAME",
            "type": "string",
            "text": "单位名称",
            "fontSize": "15px",
            "width": 250
        }, {
            "dataIndex": "XM_CODE",
            "type": "string",
            "text": "项目编码",
            "fontSize": "15px",
            "width": 150
        }, {
            "dataIndex": "XM_NAME",
            "type": "string",
            "text": "项目名称",
            "fontSize": "15px",
            "width": 250,
            renderer: function (data, cell, record) {

                /*var hrefUrl = '/page/debt/common/xmyhs.jsp?XM_ID=' + record.get('XM_ID') + '&IS_RZXM=' + record.get("IS_RZXM");
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                var url = '/page/debt/common/xmyhs.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";
                paramNames[1] = "IS_RZXM";
                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));

                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;

            }
        }, {
            "dataIndex": "LX_YEAR",
            "type": "string",
            "text": "立项年度",
            "fontSize": "15px",
            "width": 100
        }, {
            "dataIndex": "JSXZ_NAME",
            "type": "string",
            "text": "建设性质",
            "fontSize": "15px",
            "width": 100
        }, {
            "dataIndex": "XMXZ_NAME",
            "type": "string",
            "text": "项目性质",
            "fontSize": "15px",
            "width": 200
        }, {
            "dataIndex": "XMLX_NAME",
            "type": "string",
            "text": "项目类型",
            "fontSize": "15px",
            "width": 130
        }, {
            "dataIndex": "BUILD_STATUS_NAME",
            "type": "string",
            "text": "建设状态",
            "fontSize": "15px",
            "width": 130
        }, {
            "dataIndex": "XMZGS_AMT",
            "type": "float",
            "text": "项目总概算金额(万元)",
            "fontSize": "15px",
            "width": 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        },
        {
            "dataIndex": "WF_NAME",
            "type": "string",
            "text": "审核状态",
            "fontSize": "15px",
            "width": 330,
            hidden: true,
            // hidden: is_view == '1' && param != 'contentGrid4' ? false : true
        }
    ];
    return DSYGrid.createGrid({
        itemId: param == undefined || param == null || param == "" ? 'contentGrid' : param,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        border: false,
        height: '50%',
        flex: 1,
        tbarHeight: 50,
        autoLoad: false,
        dataUrl: 'getJSXMInfoGrid.action',
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        viewConfig: {
            forceFit: true,
            stripeRows: true,
            getRowClass: function (record, rowIndex, rowParams, store) {
                if (is_jy == '1') {
                    var m = checkSecuCode(record.data);
                    if (m == false) {
                        return 'x-grid-item-jyfwm';
                    }
                }
            }
        },
        listeners: {
            itemdblclick: function (self, record) {
                XM_ID = record.get("XM_ID");
                AG_NAME = record.get("AG_NAME");
                button_name = 'UPDATE';
                title = "基础库项目修改";
                window.open('/page/debt/common/xmyhs.jsp?XM_ID=' + XM_ID + '&IS_RZXM=' + record.get("IS_RZXM"));
                /*window_zqxxtb.show();
                 loadInfo();*/
            }
        }
    });
}

/**
 * 初始化债券信息填报弹出窗口
 */
function initWindow_zqxxtb() {
    var buttons = [
        {
            xtype: 'button',
            itemId: 'mbxz',
            text: '模板下载',
            hidden: true,
            handler: function (btn) {
                szysExcelDown();//收支平衡表格模板下载
            }
        }
        , {
            xtype: 'button',
            text: '导入',
            itemId: "import",
            name: 'upload',
            fileUpload: true,
            hidden: true,
            buttonOnly: true,
            hideLabel: true,
            buttonConfig: {
                width: 140,
                icon: '/image/sysbutton/report.png'
            },
            handler: function (btn) {
                var xmsyForm = Ext.ComponentQuery.query(formName)[0];
                //获取运行年限
                var yyqx = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();
                if (yyqx == "" || yyqx == undefined) {
                    Ext.MessageBox.alert('提示', "请先填写项目期限!");
                    return false;
                }
                window_xekjdr.show({TITLE: '请导入收支平衡表数据', DR_TYPE: '0'});//收支平衡表格模板下载
            }
        },
        {
            xtype: 'button',
            itemId: 'tbsm',
            hidden: true,
            text: '填报说明',
            handler: function (btn) {
                window.open('../common/ystbsmText.jsp');
            }
        },
        {
            text: '保存',
            name: 'save',
            handler: function (btn) {
                //保存表单数据
                var form = btn.up('window').down('form');
                submitInfo();
            }
        },
        {
            text: '关闭',
            handler: function (btn) {
                btn.up('window').close();
            }
        }

    ];
    if (is_view == "1") {
        buttons = null;
    }
    return Ext.create('Ext.window.Window', {
        title: title, // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.95, // 窗口高度
        layout: 'fit',
        maximizable: true,
        name: 'window_zqxxtb', // 窗口标识	
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是close，则会将window销毁。
        items: initWindow_zqxxtb_contentForm(),
        buttons: buttons
    });
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

function initWindow_xekjdr(config) {
    return Ext.create('Ext.window.Window', {
        title: config.TITLE,
        width: document.body.clientWidth * 0.4,
        height: document.body.clientHeight * 0.4,
        layout: {
            type: 'fit'
        },
        //maximizable:true,//最大最小化
        modal: true,
        closeAction: 'destroy',
        buttonAlign: 'right',
        items: initxekjdatadrform(config),
    });
}

//初始化导入名录信息form
function initxekjdatadrform(config) {
    return Ext.create('Ext.form.Panel', {
        labelWidth: 70,
        fileUpload: true,
        defaultType: 'textfield',
        layout: 'anchor',
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
                    fontSize: 20,
                    labelWidth: 140//控件默认标签宽度
                },
                items: [
                    {
                        xtype: 'displayfield',
                        fieldLabel: '<span class="required">✶</span>注意事项',
                        margin: '2 5 2 5',
                        anchor: '100% 10%'
                    },
                    {
                        xtype: 'textarea',
                        multiline: true,
                        name: '',
                        editable: false,
                        readOnly: true,
                        anchor: '100% 60%',
                        border: true,
                        fieldStyle: 'background:#E6E6E6',
                        value: '1.导入的Excel文件最大不可超过20M。\n\n' +
                            '2.不可删除Excel中固定的数据列，否则会造成数据错乱。\n\n' +
                            '3.导入年数应与项目期限保持同步!'
                    },
                    {//分割线
                        xtype: 'menuseparator',
                        anchor: '100%',
                        border: true
                    },
                    {
                        xtype: 'filefield',
                        fieldLabel: '请选择文件',
                        name: 'upload',
                        anchor: '100% 30%',
                        msgTarget: 'side',
                        allowBlank: true,
                        margin: '5 5 2 5',
                        width: 400,
                        labelWidth: 80,
                        buttonConfig: {
                            width: 100,
                            text: '预览',
                            icon: '/image/sysbutton/report.png'
                        }
                    }
                ]
            }
        ],
        buttons: [
            {
                xtype: 'button',
                text: '上传',
                name: 'upload',
                handler: function (btn) {
                    var form = this.up('form').getForm();
                    var file = form.findField('upload').getValue();
                    if (file == null || file == '') {
                        Ext.Msg.alert('提示', '请选择文件！');
                        return;
                    } else if (!(file.endWith('.xls') || file.endWith('.xlsx') || file.endWith('.et'))) {//20210601 zhuangrx 文件导入兼容et类型
                        Ext.Msg.alert('提示', '请选择Excel类型文件！');
                        return;
                    }
                    if (form.isValid()) {
                        upLoadExcel(form, btn);
                    }
                }
            },
            {
                xtype: 'button',
                text: '取消',
                name: 'cancel',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

//收支平衡模板下载
function szysExcelDown() {
    window.location.href = 'downExcel.action?file_name=' + encodeURI(encodeURI("收支平衡表格模板.xls"));
}

function upLoadExcel(form, btn) {
    var xmsyForm = Ext.ComponentQuery.query(formName)[0];
    //获取运行年限
    var yyqx = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();
    var url = '/importExcel_szys.action';
    form.submit({
        url: url,
        params: {
            "yyqx": yyqx
        },
        waitTitle: '请等待',
        waitMsg: '正在导入中...',
        success: function (form, action) {
            var columnStore = action.result.list;
            var grid = DSYGrid.getGrid('xmsyGrid');
            grid.getStore().removeAll();
            grid.insertData(null, columnStore);
            btn.up('window').close();
            editLoad(grid, false);
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

function zqxxtbTab(index) {
    var zqxxtbTab = Ext.ComponentQuery.query('panel[itemId="xmxxTabPanel"]')[0];
    zqxxtbTab.items.get(IS_XMBCXX == '1' && index > 1 ? index : index - 1).show();
}

//去除空格方法
function Trim(m) {
    while ((m.length > 0) && (m.charAt(0) == ' '))
        m = m.substring(1, m.length);
    while ((m.length > 0) && (m.charAt(m.length - 1) == ' '))
        m = m.substring(0, m.length - 1);
    return m;
}

/**
 * 提交基本情况数据
 * @param form
 */
function submitInfo() {
    //20201217 fzd 保存附件信息
    UploadPanel.saveExtraField('window_zqxxtb_contentForm_tab_xmfj_grid', false);
    // 获取基本情况页签表单
    var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
    // 获取补充信息页签表单
    var bcxxForm = Ext.ComponentQuery.query('form[name="bcxxForm"]')[0];
    //投资计划页签
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];

    var TZJH_XMZGS_AMT = tzjhForm.getForm().findField("TZJH_XMZGS_AMT").getValue();
    // 基本情况页签信息校验
    if (!jbqkForm.isValid()) {
        Ext.toast({
            html: "基本情况：请检查必填项，以及未通过校验项！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400,
            listeners: {
                "show": function () {
                    zqxxtbTab(1);
                }
            }
        });
        return false;
    }
    if (IS_XMBCXX == '1') {
        if (!bcxxForm.isValid()) {
            Ext.toast({
                html: "补充信息：请检查必填项，以及未通过校验项！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            return false;
        }
        // guodg 2021091316 项目补充信息添加校验
        var bcxx15Field = bcxxForm.getForm().findField('BCXX15');
        if (isNull(bcxx15Field.getValue())) {
            Ext.Msg.alert('提示', '项目实施方案中需要包含事前绩效评估内容，请确认!');
            setActiveTabPanelByTabTitle('补充信息');
            bcxx15Field.toggleInvalidCls(true);
            return false;
        }
    }
    var message_error = null; // 自定义变量：错误提示信息
    var BILL_PERSON = jbqkForm.getForm().findField('BILL_PERSON').getValue();
    if (null == Trim(BILL_PERSON) || '' == Trim(BILL_PERSON)) {
        Ext.Msg.alert('提示', '单位项目负责人不能为空!');
        return;
    }
    var BUILD_CONTENT = jbqkForm.getForm().findField('BUILD_CONTENT').getValue();
    if (null == Trim(BUILD_CONTENT) || '' == Trim(BUILD_CONTENT)) {
        Ext.Msg.alert('提示', '项目主要建设内容和规模不能为空!');
        return;
    }
    var XMSY_YCYJ = jbqkForm.getForm().findField('XMSY_YCYJ').getValue();
    if ((null == Trim(XMSY_YCYJ) || '' == Trim(XMSY_YCYJ)) && XMXZ_ID == '010102') {
        Ext.Msg.alert('提示', '项目收益预测依据不能为空!');
        return;
    }

    var FGW_XMK_CODE = jbqkForm.getForm().findField('FGW_XMK_CODE').getValue();
    if (FGW_XMK_CODE != '无' && !FGW_XMK_CODE.match("^[a-zA-Z0-9_-]*$")) {
        Ext.Msg.alert('提示', "发改委审批监管代码仅可录“无”或字母数字编码");
        zqxxtbTab(1);
        return false;
    }
    var START_DATE_PLAN = jbqkForm.getForm().findField('START_DATE_PLAN').getValue();
    var END_DATE_PLAN = jbqkForm.getForm().findField('END_DATE_PLAN').getValue();
    if (START_DATE_PLAN > END_DATE_PLAN) {
        Ext.Msg.alert("提示", "计划竣工日期不能早于计划开工日期！");
        zqxxtbTab(1);
        return;
    }

    if (!comparePlanDate(jbqkForm)) {
        message_error = '计划开工日期应该早于计划竣工日期';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(1);
            return false;
        }
    }

    if (!compareActualDate(jbqkForm)) {
        message_error = '实际开工日期应该早于实际竣工日期';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(1);
            return false;
        }
    }

    if (!compareActualStartDate(jbqkForm)) {
        message_error = '实际开工日期不应晚于当前时间';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(1);
            return false;
        }
    }
    if (!compareNowDateActualDate(jbqkForm)) {
        message_error = '实际竣工日期不应晚于当前时间';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(1);
            return false;
        }
    }
    if (!compareBuildActualDate(jbqkForm)) {
        message_error = '建设状态为已完工或已竣工结算，实际开工日期和实际竣工日期不可为空！';
        if (message_error != null && message_error != '') {
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(1);
            return false;
        }
    }

    // 获取投资计划页签表单
    var tzjhForm = Ext.ComponentQuery.query('form[name="tzjhForm"]')[0];
    var tzjhGrid = [];
    var tzjhNd = new Map();

    // 投资计划页签录入信息校验
    if (DSYGrid.getGrid("tzjhGrid").getStore().getCount() <= 0) {
        message_error = "投资计划：必须录入投资计划！";
        Ext.Msg.alert('提示', message_error);
        zqxxtbTab(2);
        return false;
    }
    var xmzgs_amt = tzjhForm.down('numberFieldFormat[name="TZJH_XMZGS_AMT"]').getValue(); // 项目总概算
    var zbj_amt = tzjhForm.down('numberFieldFormat[name="ZBJ_AMT"]').getValue();  // 项目资本金
    var zbj_zq_amt = tzjhForm.down('numberFieldFormat[name="ZBJ_ZQ_AMT"]').getValue(); //其中债券用做项目资本金
    var zbj_ys_amt = tzjhForm.down('numberFieldFormat[name="ZBJ_YS_AMT"]').getValue(); //其中债券用做项目资本金
    if (zbj_amt - xmzgs_amt > 0.00001) {
        Ext.Msg.alert('提示', '投资计划：项目资本金不得大于项目总概算!');
        zqxxtbTab(2);
        return false;
    }

    if ((zbj_zq_amt + zbj_ys_amt) - zbj_amt > 0.00001) {
        Ext.Msg.alert('提示', '投资计划：其中财政预算安排资金与专项债券安排资金之和不得大于项目资本金!');
        zqxxtbTab(2);
        return false;
    }

    DSYGrid.getGrid("tzjhGrid").getStore().each(function (record) {
        if (record.get('ND') == null || record.get('ND') == '' || record.get('ND') == 'undefined') {
            message_error = "请填写投资计划列表中“年度”列";
            return false;
        }
        if (typeof (tzjhNd.get(record.get('ND'))) != 'undefined') {
            message_error = "投资计划列表中“年度”不能相同";
            return false;
        } else {
            tzjhNd.put(record.get('ND'), '');
        }
        if (record.get('RZZJ_ACTUAL_AMT') < record.get('RZZJ_XJ')) {
            message_error = "投资计划：" + record.get('ND') + " 融资资金下实际到位金额不能小于小计金额！";
            return false;
        }
        if (record.get('ZTZ_PLAN_AMT') <= 0 && record.get('ZTZ_ACTUAL_AMT') <= 0) {
            message_error = record.get('ND') + "年投资计划年度总投资不能为0！";
            return false;
        }
        /*if (record.get('ND') < nowDate.substr(0, 4) && record.get('ZTZ_ACTUAL_AMT') <= 0) {
            message_error = "投资计划：" + nowDate.substr(0, 4) + "年度之前的投资计划年度总投资下的实际到位资金必须大于0！";
            return false;
        }*/
        tzjhGrid.push(record.getData());
    });

    if (message_error != null && message_error != '') {
        Ext.Msg.alert('提示', message_error);
        zqxxtbTab(2);
        return;
    }
    var sdgcGrid = [];
    DSYGrid.getGrid("sdgcGrid").getStore().each(function (record) {
        if (record.get('GCLB_ID') == null || record.get('GCLB_ID') == '' || record.get('GCLB_ID') == 'undefined') {
            message_error = "请选择十大工程页签“工程类别”列";
            IS_XMBCXX == 1 ? zqxxtbTab(4) : zqxxtbTab(3);
            return false;
        }
        sdgcGrid.push(record.getData());
    });
    if (sysAdcode == '42') {
        // 十大工程页签录入信息校验
        if (DSYGrid.getGrid("sdgcGrid").getStore().getCount() <= 0) {
            message_error = "十大工程：必须录入十大工程！";
            Ext.Msg.alert('提示', message_error);
            return false;
        }
        var sdgcStore = DSYGrid.getGrid("sdgcGrid").getStore();
        if (parseFloat(sdgcStore.sum('XM_ZTZ')).toFixed(2) != parseFloat(xmzgs_amt).toFixed(2)) {
            message_error = "十大工程页签“项目总投资”列必须等于项目总概算！";
            IS_XMBCXX == 1 ? zqxxtbTab(4) : zqxxtbTab(3);
            Ext.Msg.alert('提示', message_error);
            return false;
        }
    }

    //获取收支平衡页签表单
    var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
    var szysGrid = xmsyForm.down('grid');

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

    var xmztr_amt = xmsyForm.down('numberFieldFormat[name="XMZTR_AMT"]').getValue(); // 项目预计总收入
    var xmzcb_amt = xmsyForm.down('numberFieldFormat[name="XMZCB_AMT"]').getValue(); // 项目预算总成本
    var zfxjjkm_id = xmsyForm.down('treecombobox[name="ZFXJJKM_ID"]').getValue();    // 项目对应的政府性基金科目
    var xm_used_date = xmsyForm.down('datefield[name="XM_USED_DATE"]').getValue();    // 项目投入使用日期
    var xm_used_limit = xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').getValue();  // 项目期限

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

    if (isOld_szysGrid == '1') {
        //收支平衡页签表单
        var xmsyform_temp = xmsyForm.getForm();
        if (szysGrid.getStore().sum('TOTAL_AMT') <= 0 && zfxjjkm_id != null && zfxjjkm_id != "" && zfxjjkm_id != undefined) {
            message_error = "收支平衡：项目对应的政府性基金科目不为空时，必须有收入！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }
        if (szysGrid.getStore().sum('TOTAL_AMT') > 0 && ((zfxjjkm_id == null) || (zfxjjkm_id == "") || zfxjjkm_id == undefined)) {
            message_error = "收支平衡：项目收入合计不为0时，项目对应的政府性基金科目不可为空！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }
        if (szysGrid.getStore().data.length > 0 && (((xm_used_date == null) || (xm_used_date == "") || xm_used_date == undefined) || ((xm_used_limit == null) || (xm_used_limit == "") || xm_used_limit == undefined))) {
            message_error = "收支平衡：项目投入使用日期或项目期限不能为空！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }
        if (szysGrid.getStore().data.length <= 0 && (((xm_used_date != null) && (xm_used_date != "") && xm_used_date != undefined) || ((xm_used_limit != null) && (xm_used_limit != "") && xm_used_limit != undefined))) {
            message_error = "收支平衡：项目投入使用日期或项目期限不为空时，必须有收入！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }
        //结束时的年度大小判断
        var XM_USED_DATE_int = parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4));
        var XM_USED_LIMIT_int = parseInt(xmsyform_temp.findField("XM_USED_LIMIT").getValue());
        var xm_xmsy_boolean = false;
        szysGrid.getStore().each(function (record) {
            if (!((parseInt(record.get('INCOME_YEAR')) >= XM_USED_DATE_int) && (parseInt(record.get('INCOME_YEAR')) <= (XM_USED_DATE_int + XM_USED_LIMIT_int)))) {
                message_error = "收支平衡:表中年度不能大于项目投入使用日期与项目期限之和，不能小于项目投入使用日期所在年度";
                xm_xmsy_boolean = true;
            }
        });
        if (xm_xmsy_boolean) {
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }

        //获取收支平衡页签表格
        var xmsyGrid = [];
        var xmsyNd = new Map();
        szysGrid.getStore().each(function (record) {
            if (typeof (xmsyNd.get(record.get('INCOME_YEAR'))) != 'undefined') {
                message_error = "收支平衡列表中“年度”不能相同";
                return false;
            }
            if (typeof record.get('INCOME_YEAR') == 'undefined' || record.get('INCOME_YEAR') == null || record.get('INCOME_YEAR').length <= 0) {
                message_error = '收支平衡中分年度收支预算的年度不能为空！';
            } else {
                xmsyNd.put(record.get('INCOME_YEAR'), '');
            }
            if (typeof record.get('TOTAL_AMT') == 'undefined' || record.get('TOTAL_AMT') == null || record.get('TOTAL_AMT') <= 0) {
                message_error = record.get('INCOME_YEAR') + "年收入总计不能为 0";
                return false;
            }
            xmsyGrid.push(record.getData());
        });

    } else {
        // 如果项目类型非"土地储备" 则校验通用编制计划


        if (xmztr_amt <= 0 && zfxjjkm_id != null && zfxjjkm_id != "" && zfxjjkm_id != undefined) {
            message_error = "收支平衡：项目对应的政府性基金科目不为空时，必须录入项目预计总收入！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }

        if (xmztr_amt > 0 && ((zfxjjkm_id == null) || (zfxjjkm_id == "") || zfxjjkm_id == undefined)) {
            message_error = "收支平衡：项目预计总收入不为0时，项目对应的政府性基金科目不可为空！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }

        if (xmztr_amt <= 0 && ((xm_used_date != null && xm_used_date != "" && xm_used_date != undefined) || (xm_used_limit != null && xm_used_limit != "" && xm_used_limit != undefined))) {
            message_error = "收支平衡：开始日期或预算年限不为空时，必须录入项目预计总收入！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }

        if (xmztr_amt > 0 && (((xm_used_date == null) || (xm_used_date == "") || xm_used_date == undefined) || ((xm_used_limit == null) || (xm_used_limit == "") || xm_used_limit == undefined))) {
            message_error = "收支平衡：项目预计总收入不为0时，开始日期和项目期限不能为空！";
            Ext.Msg.alert('提示', message_error);
            zqxxtbTab(3);
            return false;
        }


        var xmsyGrid = [];
        var is_negative = false; // 明细中是否存在负数
        var yyqx_count = 4; // 默认显示5年编制计划列
        if (!!xm_used_limit) {
            yyqx_count = xm_used_limit;
        }
        if (xm_used_limit > 30) {
            yyqx_count = 30;
        }
        if (is_tdcb) {
            if ((!!xmztr_amt) && xmztr_amt <= 0) {
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

        } else {
            // 对还本总金额进行校验
            var record_06 = szysGrid.getStore().getAt(gs_relation_guid["06"]);// 获取专项债券金额
            var record_0203 = szysGrid.getStore().getAt(gs_relation_guid["0202"]);// 获取地方政府专项债券金额
            var record_07 = szysGrid.getStore().getAt(gs_relation_guid["07"]);// 获取市场化融资金额
            var record_0204 = szysGrid.getStore().getAt(gs_relation_guid["0203"]);// 获取项目单位市场化融资金额
            var record_020201 = szysGrid.getStore().getAt(gs_relation_guid["020201"]);// 获取其中用于资本金
            var record_03 = szysGrid.getStore().getAt(gs_relation_guid["03"]);
            var record_0301 = szysGrid.getStore().getAt(gs_relation_guid["0301"]);
            var record_0302 = szysGrid.getStore().getAt(gs_relation_guid["0302"]);
            /*var record_01 = szysGrid.getStore().getAt(gs_relation_guid["01"]);
            var record_0101 = szysGrid.getStore().getAt(gs_relation_guid["0101"]);
            var record_0102 = szysGrid.getStore().getAt(gs_relation_guid["0102"]);*/
            var zxzqhb_amt = 0.00; // 专项债券还本总金额
            var zxzq_amt = 0.00;   // 专项债券总金额
            var schrzhb_amt = 0.00;// 市场化融资还本总金额
            var schrz_amt = 0.00;  // 市场化融资总金额
            // 循环计算所有年度总收入总支出合计值
            for (var i = 0; i <= yyqx_count; i++) {
                var SR = "SRAMT_Y" + i;
                var ZC = "ZCAMT_Y" + i;
                zxzqhb_amt += parseFloat(record_06.get(ZC) == "" ? 0 : record_06.get(ZC));
                zxzq_amt += parseFloat(record_0203.get(SR) == "" ? 0 : record_0203.get(SR));
                schrzhb_amt += parseFloat(record_07.get(ZC) == "" ? 0 : record_07.get(ZC));
                schrz_amt += parseFloat(record_0204.get(SR) == "" ? 0 : record_0204.get(SR));
                var dfzxzq_amt = parseFloat(record_0203.get(SR) == "" ? 0 : record_0203.get(SR));//2地方政府专项债券金额
                var qzsr = parseFloat(record_020201.get(SR) == "" ? 0 : record_020201.get(SR));//获取其中用于资本金
                var jsxmzc = parseFloat(record_03.get(ZC) == "" ? 0 : record_03.get(ZC));//建设项目支出03
                var cwzyzx = parseFloat(record_0301.get(ZC) == "" ? 0 : record_0301.get(ZC));//财务专用专项债券付息
                var cwzysc = parseFloat(record_0302.get(ZC) == "" ? 0 : record_0302.get(ZC));//市场化融资付息
                if (parseFloat(qzsr).toFixed(6) - parseFloat(dfzxzq_amt).toFixed(6) > 0.000001) {//20210420liyue添加用于资本金与地方专项校验
                    Ext.Msg.alert('提示', '其中：用于资本金不能大于地方政府专项债券金额！');
                    return false;
                }
                if (parseFloat(cwzyzx + cwzysc).toFixed(6) - parseFloat(jsxmzc).toFixed(6) > 0.000001) {//20210420liyue添加建设项目支出与其中金额校验
                    Ext.Msg.alert('提示', '其中：专项债券与市场化融资付息和不能大于项目建设支出！');
                    return false;
                }
            }
            if (Math.abs((parseFloat(zxzqhb_amt).toFixed(6) - parseFloat(zxzq_amt).toFixed(6)).toFixed(6)) > 0.000001) {
                Ext.Msg.alert('提示', '专项债券还本总金额应等于地方政府专项债券总金额！');
                return false;
            }
            if (Math.abs((parseFloat(schrzhb_amt).toFixed(6) - parseFloat(schrz_amt).toFixed(6)).toFixed(6)) > 0.000001) {
                Ext.Msg.alert('提示', '市场化融资还本总金额应等于项目单位市场化融资总金额！');
                return false;
            }
            var xmsyForm = Ext.ComponentQuery.query(formName)[0];
            var store = xmsyForm.down('grid').getStore();
            var bxfg = store.getAt(gs_relation_guid["09"]);
            var XMXZ_ID = jbqkForm.getForm().findField('XMXZ_ID').getValue();
            /*     if(XMXZ_ID == '010102'){
                     // BXFGBS_XX不为0与不为null则较验
                     if(BXFGBS_XX != '0' && BXFGBS_XX != 'null' && BXFGBS_XX != ''){
                         if(bxfg.data.SRAMT_Y0 < parseFloat(BXFGBS_XX)){
                             Ext.Msg.alert('提示','本息覆盖倍数必须大于或等于'+BXFGBS_XX+'倍！');
                             zqxxtbTab(3);
                             return false;
                         }
                     }
                 }*/
            /*  if(BXFGBS_SX != '0' && BXFGBS_SX != 'null' && BXFGBS_SX != ''){
                  if(bxfg.data.SRAMT_Y0 > parseFloat(BXFGBS_SX)){
                      Ext.Msg.alert('提示','本息覆盖倍数过大，请检查数据！');
                      zqxxtbTab(3);
                      return false;
                  }
              }*/
            /*if (!(xm_used_date == null || (xm_used_date == "") || xm_used_date == undefined)){
                for (var n = 0; n <= yyqx_count; n++) {
                    var SR = "SRAMT_Y" + n;
                    var year = Number(xm_used_date.getFullYear()) + Number(n);
                    var sr_amt = (parseFloat((record_0101.get(SR)==""?0:record_0101.get(SR)).toFixed(6))) + (parseFloat((record_0102.get(SR)==""?0:record_0102.get(SR)).toFixed(6)));
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
    }


    // 输出提示信息
    if (message_error != null && message_error != '') {
        Ext.Msg.alert('提示', message_error);
        zqxxtbTab(3);
        return;
    }

    //获取存量债务页签表格
    //获取绩效情况页签表单
    var jxqkForm = {};

    //获取投资计划页签表格
    var jxqkGrid = [];
    // DSYGrid.getGrid("jxqkGrid").getStore().each(function (record) {
    //     jxqkGrid.push(record.getData());
    // });

    //获取固定资产页签表格
    var gdzcGrid = [];
    // DSYGrid.getGrid("gdzcGrid").getStore().each(function (record) {
    //     gdzcGrid.push(record.getData());
    // });


    //设置ajax请求参数
    if (IS_XMBCXX == '1') {
        var params = {
            wf_id: wf_id,
            node_code: node_code,
            node_type: node_type,
            XM_ID: XM_ID,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_ID: AG_ID,
            AG_NAME: AG_NAME,
            button_name: button_name,
            xm_used_limit: xm_used_limit,
            is_wzxt: is_wzxt,
            isOld_szysGrid: isOld_szysGrid,
            IS_XMBCXX: IS_XMBCXX,
            jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
            bcxxForm: encode64('[' + Ext.util.JSON.encode(bcxxForm.getValues()) + ']'),
            tzjhForm: encode64('[' + Ext.util.JSON.encode(tzjhForm.getValues()) + ']'),
            tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
            sdgcGrid: encode64(Ext.util.JSON.encode(sdgcGrid)),
            xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
            xmsyGrid: encode64(Ext.util.JSON.encode(xmsyGrid)),
            jxqkForm: encode64('[' + Ext.util.JSON.encode(jxqkForm) + ']'),
            jxqkGrid: encode64(Ext.util.JSON.encode(jxqkGrid)),
            gdzcGrid: encode64(Ext.util.JSON.encode(gdzcGrid))
        };
    } else {
        var params = {
            wf_id: wf_id,
            node_code: node_code,
            XM_ID: XM_ID,
            AD_CODE: AD_CODE,
            AG_CODE: AG_CODE,
            AG_ID: AG_ID,
            AG_NAME: AG_NAME,
            node_type: node_type,
            button_name: button_name,
            xm_used_limit: xm_used_limit,
            is_wzxt: is_wzxt,
            isOld_szysGrid: isOld_szysGrid,
            jbqkForm: encode64('[' + Ext.util.JSON.encode(jbqkForm.getValues()) + ']'),
            tzjhForm: encode64('[' + Ext.util.JSON.encode(tzjhForm.getValues()) + ']'),
            tzjhGrid: encode64(Ext.util.JSON.encode(tzjhGrid)),
            xmsyForm: encode64('[' + Ext.util.JSON.encode(xmsyForm.getValues()) + ']'),
            xmsyGrid: encode64(Ext.util.JSON.encode(xmsyGrid)),
            jxqkForm: encode64('[' + Ext.util.JSON.encode(jxqkForm) + ']'),
            jxqkGrid: encode64(Ext.util.JSON.encode(jxqkGrid)),
            gdzcGrid: encode64(Ext.util.JSON.encode(gdzcGrid)),
            sdgcGrid: encode64(Ext.util.JSON.encode(sdgcGrid))

        };
    }

    //禁用保存按钮
    Ext.ComponentQuery.query('window[name="window_zqxxtb"]')[0].down('button[name=save]').setDisabled(true);

    //保存方法
    function saveForm() {
        $.post('saveJSXMInfo.action', params, function (data) {
            if (data.success) {
                Ext.toast({
                    html: "保存成功！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                //刷新表格
                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                zwxmlx_store = DebtEleTreeStoreDB("DEBT_ZWXMLX");
                Ext.ComponentQuery.query('window[name="window_zqxxtb"]')[0].close();
            } else {
                Ext.MessageBox.alert('提示', data.message);
                //解禁保存按钮
                Ext.ComponentQuery.query('window[name="window_zqxxtb"]')[0].down('button[name=save]').setDisabled(false);
            }
        }, "json");
    }

    //发送ajax请求，提交数据
    if (TZJH_XMZGS_AMT > 2000000) {
        Ext.onReady(function () {
            Ext.MessageBox.show({
                title: "提示",
                msg: "投资计划页签中项目总概算金额超过200亿！",
                fn: function (id, msg) {
                    if (id == "ok") {
                        saveForm();
                    } else {
                        Ext.ComponentQuery.query('window[name="window_zqxxtb"]')[0].down('button[name=save]').setDisabled(false);
                    }
                },
                buttons: Ext.Msg.OKCANCEL,
            });
        });
    } else {
        saveForm();
    }
}

function compareNowDateActualDate(form) {
    var END_DATE_ACTUAL = form.down('[name=END_DATE_ACTUAL]').getValue();
    END_DATE_ACTUAL = Ext.util.Format.date(END_DATE_ACTUAL, 'Y-m-d');
    if (END_DATE_ACTUAL && END_DATE_ACTUAL > nowDate) {
        return false;
    }
    return true;
}

/**
 * 比较实际开工日期与当前日期
 * @param form
 * @return {boolean}
 */
function compareActualStartDate(form) {
    var START_DATE_ACTUAL = form.down('[name=START_DATE_ACTUAL]').getValue();
    START_DATE_ACTUAL = Ext.util.Format.date(START_DATE_ACTUAL, 'Y-m-d');
    if (START_DATE_ACTUAL && START_DATE_ACTUAL > nowDate) {
        return false;
    }
    return true;
}

function compareBuildActualDate(form) {
    var START_DATE_ACTUAL = form.down('[name=START_DATE_ACTUAL]').getValue();
    var END_DATE_ACTUAL = form.down('[name=END_DATE_ACTUAL]').getValue();
    var BUILD_STATUS_ID = form.down('[name=BUILD_STATUS_ID]').getValue();
    if ((BUILD_STATUS_ID == '03' || BUILD_STATUS_ID == '04') &&
        (START_DATE_ACTUAL == null || START_DATE_ACTUAL == '' || END_DATE_ACTUAL == null || END_DATE_ACTUAL == '')) {
        return false;
    }
    return true;
}

function initWindow_zqxxtb_contentForm() {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            anchor: '100%'/*,
             margin: '5 5 5 5',*/
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                anchor: '100%',
                layout: 'hbox',
                items: [
                    {xtype: 'label', text: '单位名称:', width: 70},
                    {xtype: 'label', text: AG_NAME, width: 200, flex: 5},
                    {xtype: 'label', text: '单位:万元', width: 80, cls: "label-color"}
                ]
            },
            initWindow_zqxxtb_contentForm_tab()
        ]
    });
}

function initWindow_zqxxtb_contentForm_tab() {
    if (IS_XMBCXX == '1') {
        var zqxxtbTab = Ext.create('Ext.tab.Panel', {
            anchor: '100% -17',
            itemId: 'xmxxTabPanel',
            border: false,
            xtype: 'tabpanel',
            items: [
                {
                    title: '基本情况',
                    scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_jbqk({IS_SZYS: ''})
                },
                {
                    title: '补充信息',
                    layout: 'fit',
                    scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_bcxx()
                },
                {
                    title: '投资计划',
                    layout: 'fit',//布局为fit后， scrollable不能用
                    scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_tzjh()
                },
                {
                    title: '收支平衡',
                    layout: 'fit',
                    btnsItemId: 'szys',
                    scrollable: true,
                    items: isOld_szysGrid == '1' ? initWindow_zqxxtb_contentForm_tab_xmsy() : initWindow_zqxxtb_contentForm_tab_szys()
                },
                {
                    title: '十大工程',
                    layout: 'fit',
                    btnsItemId: 'sdgc',
                    scrollable: true,
                    hidden: sysAdcode == '42' ? false : true,
                    items: initWindow_zqxxtb_contentForm_tab_sdgc(XM_ID, 'jslr')
                },
            ],
            listeners: {
                tabchange: function (tabPanel, newCard, oldCard) {
                    if (isOld_szysGrid == '0' && newCard.btnsItemId == 'szys') {
                        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(false);
                        Ext.ComponentQuery.query('button#import')[0].setHidden(false);
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(false);
                        var self = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0];
                        change_tdcbysbz_grid(self, {IS_YHS: false, XM_ID: XM_ID});
                    } else {
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#import')[0].setHidden(true);
                    }
                    if (is_tdcb == true) {//20201110_wangyl_土地储备隐藏导入按钮
                        Ext.ComponentQuery.query('button#import')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);
                    }
                }
            }
        });
    } else {
        var zqxxtbTab = Ext.create('Ext.tab.Panel', {
            anchor: '100% -17',
            itemId: 'xmxxTabPanel',
            border: false,
            xtype: 'tabpanel',
            items: [
                {
                    title: '基本情况',
                    scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_jbqk({IS_SZYS: ''})
                },
                {
                    title: '投资计划',
                    layout: 'fit',//布局为fit后， scrollable不能用
                    scrollable: true,
                    items: initWindow_zqxxtb_contentForm_tab_tzjh()
                },
                {
                    title: '收支平衡',
                    layout: 'fit',
                    btnsItemId: 'szys',
                    scrollable: true,
                    items: isOld_szysGrid == '1' ? initWindow_zqxxtb_contentForm_tab_xmsy() : initWindow_zqxxtb_contentForm_tab_szys()
                }
            ],
            listeners: {
                tabchange: function (tabPanel, newCard, oldCard) {
                    if (isOld_szysGrid == '0' && newCard.btnsItemId == 'szys') {
                        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(false);
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(false);
                        var self = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0];
                        change_tdcbysbz_grid(self, {IS_YHS: false, XM_ID: XM_ID});
                    } else {
                        Ext.ComponentQuery.query('button#tbsm')[0].setHidden(true);
                        Ext.ComponentQuery.query('button#mbxz')[0].setHidden(true);
                    }
                }
            }
        });
    }

    var items = getXmxxItems(tab_items, XM_ID);
    for (var i = 0; i <= items.length; i++) {
        if (i == items.length) {
            zqxxtbTab.add({
                title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                layout: 'fit',
                name: 'fileTab',
                items: [
                    {
                        xtype: 'panel',
                        layout: 'fit',
                        itemId: 'fileTab_panel',
                        items: [initWindow_zqxxtb_contentForm_tab_xmfj()]
                    }
                ]
            });
        } else {
            zqxxtbTab.add(items[i]);
        }
    }
    return zqxxtbTab;
}

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

/*基础数据，下拉框形式*/
function DebtEleStore(debtEle, params) {
    var namecode = '0';
    if (typeof params != 'undefined' && params != null) {
        namecode = params.namecode;
    }
    var debtStore = Ext.create('Ext.data.Store', {
        fields: ['id', 'code', 'name'],
        sorters: [{
            property: 'id',
            direction: 'asc'
        }],
        data: namecode == '1' ? DebtJSONNameWithCode(debtEle) : debtEle
    });
    return debtStore;
}

// 初始化补充信息页签
function initWindow_zqxxtb_contentForm_tab_bcxx() {
    return Ext.create('Ext.form.Panel', {
        name: 'bcxxForm',
        itemId: 'bcxxForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        defaults: {
            margin: '0 0 0 0',
            padding: '0 0 0 0',
            anchor: '100%'
        },
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldcontainer',
                layout: 'anchor',
                defaults: {
                    anchor: '100%',
                    margin: '20 10 0 0'
                },
                items: [
                    {
                        xtype: 'fieldcontainer',
                        layout: 'column',
                        defaultType: 'textfield',
                        fieldDefaults: {
                            labelWidth: 225,
                            columnWidth: .33,
                            margin: '5 5 5 5'
                        },
                        items: [
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否已经主管部门立项审批',
                                name: "BCXX1",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false

                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否已完成环评工作',
                                name: "BCXX2",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否已完成安评工作',
                                name: "BCXX3",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否已完成招投标工作',
                                name: "BCXX4",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否已完成相关征地拆迁等相关工作',
                                name: "BCXX5",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            // 2021 新增项
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否取得《国有土地使用证》',
                                name: "BCXX11",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否取得《建设用地规划许可证》',
                                name: "BCXX12",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否取得《建设工程规划许可证》',
                                name: "BCXX13",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>是否取得《建设工程施工许可证》',
                                name: "BCXX14",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>能否形成实物工作量',
                                name: "BCXX6",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>能否形成有效投资支出',
                                name: "BCXX7",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 0,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                name: "BCXX8",
                                store: DebtEleStore(json_debt_bcxx_yxdj),
                                fieldLabel: '<span class="required">✶</span>项目优先等级（一级优先等级最高）',
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: 5,
                                allowBlank: false
                            },
                            {
                                xtype: "combobox",
                                fieldLabel: '<span class="required">✶</span>实施方案中是否包含事前绩效评估内容',
                                name: "BCXX15",
                                store: DebtEleStore(json_debt_bcxx),
                                displayField: 'code',
                                valueField: 'id',
                                editable: false,
                                value: '',
                                allowBlank: true
                            }
                        ]
                    }

                ]
            }
        ]
    });
}


/**
 * 初始化债券信息填报弹出窗口中的收支平衡标签页
 */
function initWindow_zqxxtb_contentForm_tab_xmsy() {
    return Ext.create('Ext.form.Panel', {
        name: 'xmsyForm',
        width: '100%',
        height: '100%',
        layout: 'anchor',
        border: false,
        padding: '0 10 0 10',
        defaultType: 'textfield',
        items: [
            {
                xtype: 'fieldset',
                title: '预计总体情况',
                layout: 'column',
                defaultType: 'textfield',
                anchor: '100%',
                collapsible: false,
                fieldDefaults: {
                    labelWidth: 160,
                    columnWidth: .33,
                    margin: '0 0 5 20'
                },
                items: [
                    {
                        xtype: 'numberFieldFormat',
                        fieldLabel: '项目预计总收入',
                        name: 'XMZTR_AMT',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: 'numberFieldFormat',
                        fieldLabel: '项目预算总成本',
                        name: 'XMZCB_AMT',
                        hideTrigger: true,
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype: "treecombobox",
                        name: "ZFXJJKM_ID",
                        store: DebtEleTreeStoreDB('DEBT_CHZJLY', {condition: " and code like '0102%' "}),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '项目对应的政府性基金科目',
                        editable: false, //禁用编辑
                        selectModel: "leaf"
                    },
                    {
                        xtype: "datefield",
                        fieldLabel: '项目投入使用日期',
                        name: 'XM_USED_DATE',
                        format: 'Y-m-d',
                        listeners: {
                            'change': function (self, newValue, oldValue) {
                                var lx_year = Ext.ComponentQuery.query('combobox[name="LX_YEAR"]')[0].getValue();
                                newValue = format(newValue, 'yyyy');
                                if (newValue < lx_year) {
                                    Ext.MessageBox.alert('提示', '项目投入使用日期不可小于立项年度');
                                    self.setValue('');
                                    return;
                                }
                            }
                        }
                    },
                    {
                        xtype: 'numberFieldFormat',
                        fieldLabel: '项目期限(年)',
                        name: 'XM_USED_LIMIT',
                        allowDecimals: false,//是否允许小数
                        hideTrigger: true,
                        mouseWheelEnabled: false,
                        maxValue: 100,
                        minValue: 1
                    },
                    {
                        fieldLabel: '备注',
                        name: 'REMARK',
                        xtype: 'textfield',
                        columnWidth: .990
                    }

                ]
            },
            {
                xtype: 'fieldset',
                title: '分年度收支预算',
                itemId: 'winPanel_xmsyGrid',
                anchor: '100% -90',
                layout: 'fit',
                collapsible: false,
                items: [
                    initWindow_zqxxtb_contentForm_tab_xmsy_grid()
                ]
            }
        ]
    });
}

/**
 * 初始化债券信息填报弹出窗口中的收支平衡标签页中的表格
 */
function initWindow_zqxxtb_contentForm_tab_xmsy_grid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 60,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "INCOME_YEAR", type: "string", text: "年度", width: 80, tdCls: 'grid-cell',
            editor: {
                xtype: 'combobox',
                editable: false,
                displayField: 'name',
                valueField: 'id',
                store: DebtEleStore(json_debt_year)
            }
        },
        {
            header: '项目预算总收入', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "TOTAL_AMT",
                    type: "float",
                    text: "合计",
                    width: 150,
                    summaryType: 'sum',
                    tdCls: 'grid-cell-unedit',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "YYSR_AMT", type: "float", text: "营业收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "CZBZ_AMT", type: "float", text: "补贴收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "ZCBX_AMT", type: "float", text: "资产变现收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "QT_AMT", type: "float", text: "其他收入", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]
        },
        {
            header: '项目预算总支出', colspan: 2, align: 'center', columns: [
                {
                    dataIndex: "YSCB_HJ_AMT", type: "float", text: "合计", width: 150, tdCls: 'grid-cell-unedit',
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "XM_YY_AMT", type: "float", text: "经营成本", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "ZJFY_AMT", type: "float", text: "折旧费用", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "LXZC_AMT", type: "float", text: "利息支出", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "SFZC_AMT", type: "float", text: "税费支出", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                },
                {
                    dataIndex: "HBZC_AMT", type: "float", text: "还本支出", width: 150,
                    editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.00');
                    }
                }
            ]
        },
        {
            dataIndex: "DQYY_AMT", type: "float", text: "当期盈余", width: 150, tdCls: 'grid-cell-unedit',
            summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {dataIndex: "LJYY_AMT", type: "float", text: "累计盈余", width: 150, tdCls: 'grid-cell-unedit'}
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'xmsyGrid',
        border: false,
        flex: 1,
        data: [],
        checkBox: true,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'xmsyCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                    },
                    'validateedit': function (editor, context) {
                        if (context.field == 'INCOME_YEAR') {
                            var xmsyform_temp = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0].getForm();
                            var limit_date_max = parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4)) + parseInt(xmsyform_temp.findField("XM_USED_LIMIT").getValue());
                            if (context.value > limit_date_max) {
                                Ext.toast({
                                    html: "添加的年度不能超过项目投入使用日期与项目期限之和！",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                            if (context.value < parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4))) {
                                Ext.toast({
                                    html: "输入的年度不能小于项目投入使用日期所在的年度",
                                    closable: false,
                                    align: 't',
                                    slideInDuration: 400,
                                    minWidth: 400
                                });
                                return false;
                            }
                        }
                    },
                    'edit': function (editor, context) {
                        // 项目预算总收入
                        if (context.field == 'YYSR_AMT' || context.field == 'CZBZ_AMT' || context.field == 'ZCBX_AMT' || context.field == 'QT_AMT') {
                            var yysr_amt = context.record.get("YYSR_AMT");
                            var czbz_amt = context.record.get("CZBZ_AMT");
                            var zcbx_amt = context.record.get("ZCBX_AMT");
                            var qt_amt = context.record.get("QT_AMT");
                            var total_amt = new Object(yysr_amt + czbz_amt + zcbx_amt + qt_amt);
                            context.record.set('TOTAL_AMT', Math.floor((total_amt) * 100) / 100);
                            // 计算当期盈余和累计盈余
                            context.record.set('DQYY_AMT', Math.floor((context.record.get("TOTAL_AMT") - context.record.get("YSCB_HJ_AMT")) * 100) / 100);
                            var ljyy_sum_amt = 0.00;
                            grid.getStore().each(function (record) {
                                if (record.get('INCOME_YEAR') <= context.record.get("INCOME_YEAR")) {
                                    ljyy_sum_amt += record.get('DQYY_AMT');
                                }
                            });
                            context.record.set('LJYY_AMT', Math.floor((ljyy_sum_amt) * 100) / 100);
                            szysGrid(grid);
                            initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
                        }
                        // 项目预算总成本
                        if (context.field == 'XM_YY_AMT' || context.field == 'ZJFY_AMT' || context.field == 'LXZC_AMT' || context.field == 'SFZC_AMT' || context.field == 'HBZC_AMT') {
                            var xm_yy_amt = context.record.get("XM_YY_AMT");
                            var zjfy_amt = context.record.get("ZJFY_AMT");
                            var lxzc_amt = context.record.get("LXZC_AMT");
                            var sfzc_amt = context.record.get("SFZC_AMT");
                            var hbzc_amt = context.record.get("HBZC_AMT");
                            var yscb_hj_amt = new Object(xm_yy_amt + zjfy_amt + lxzc_amt + sfzc_amt + hbzc_amt);
                            context.record.set('YSCB_HJ_AMT', Math.floor((yscb_hj_amt) * 100) / 100);
                            // 计算当期盈余和累计盈余
                            context.record.set('DQYY_AMT', Math.floor((context.record.get("TOTAL_AMT") - context.record.get("YSCB_HJ_AMT")) * 100) / 100);
                            var ljyy_sum_amt = 0.00;
                            grid.getStore().each(function (record) {
                                if (record.get('INCOME_YEAR') <= context.record.get("INCOME_YEAR")) {
                                    ljyy_sum_amt += record.get('DQYY_AMT');
                                }
                            });
                            context.record.set('LJYY_AMT', Math.floor((ljyy_sum_amt) * 100) / 100);
                            szysGrid(grid);
                            initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
                        }
                    }
                }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    if (!(is_view == "1")) {
        //将增加删除按钮添加到表格中
        grid.addDocked({
            xtype: 'toolbar',
            layout: 'column',
            items: [
                '->',
                {
                    xtype: 'button',
                    text: '添加',
                    width: 60,
                    handler: function (btn) {
                        $(document).keydown(function (event) {
                            if (event.which == 13 || event.which == 32) {
                                return false;
                            }
                        });
                        var xmsyform_temp = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0].getForm();
                        var xmsygrid_temp = btn.up('grid');
                        var used_date_data = xmsyform_temp.findField("XM_USED_DATE").rawValue;
                        var used_date = xmsyform_temp.findField("XM_USED_DATE").getValue();
                        var used_limit = xmsyform_temp.findField("XM_USED_LIMIT").getValue();
                        var xmsy_store = xmsygrid_temp.getStore();
                        if (used_date == '' || used_date == undefined || used_limit == '' || used_limit == undefined) {
                            Ext.MessageBox.alert('提示', "项目投入使用日期或项目期限不能为空");
                            return false;
                        }
                        var lenght_temp = xmsy_store.data.length;
                        if (lenght_temp == 0) {
                            btn.up('grid').insertData(lenght_temp, {
                                INCOME_YEAR: used_date_data.substring(0, 4)
                            });
                        }
                        if (lenght_temp > 0) {
                            var record = xmsy_store.data.items[lenght_temp - 1];
                            var INCOME_YEAR_temp = (parseInt(record.data.INCOME_YEAR) + 1).toString();
                            var limit_date_max = parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0, 4)) + parseInt(xmsyform_temp.findField("XM_USED_LIMIT").getValue());
                            if (parseInt(INCOME_YEAR_temp) > limit_date_max) {
                                Ext.MessageBox.alert('提示', "添加的年度不能超过项目投入使用日期与项目期限之和");
                                return false;
                            }
                            var ljyy_sum_amt = 0.00;
                            xmsy_store.each(function (record) {
                                if (record.get('INCOME_YEAR') <= INCOME_YEAR_temp) {
                                    ljyy_sum_amt += record.get('DQYY_AMT');
                                }
                            });
                            btn.up('grid').insertData(lenght_temp, {
                                INCOME_YEAR: INCOME_YEAR_temp,
                                TOTAL_AMT: record.data.TOTAL_AMT,
                                YYSR_AMT: record.data.YYSR_AMT,
                                CZBZ_AMT: record.data.CZBZ_AMT,
                                ZCBX_AMT: record.data.ZCBX_AMT,
                                QT_AMT: record.data.QT_AMT,
                                YSCB_HJ_AMT: record.data.YSCB_HJ_AMT,
                                XM_YY_AMT: record.data.XM_YY_AMT,
                                ZJFY_AMT: record.data.ZJFY_AMT,
                                LXZC_AMT: record.data.LXZC_AMT,
                                SFZC_AMT: record.data.SFZC_AMT,
                                HBZC_AMT: record.data.HBZC_AMT,
                                DQYY_AMT: record.data.DQYY_AMT,
                                LJYY_AMT: ljyy_sum_amt + record.data.DQYY_AMT
                            });
                        }
                        szysGrid(grid);
                        var xmsyStore = DSYGrid.getGrid("xmsyGrid").getStore();
                        Ext.ComponentQuery.query('numberFieldFormat[name="XMZTR_AMT"]')[0].setValue(Math.floor((xmsyStore.sum('TOTAL_AMT')) * 100) / 100);
                        Ext.ComponentQuery.query('numberFieldFormat[name="XMZCB_AMT"]')[0].setValue(Math.floor((xmsyStore.sum('YSCB_HJ_AMT')) * 100) / 100);

                    }
                },
                {
                    xtype: 'button',
                    itemId: 'xmsyDelBtn',
                    text: '删除',
                    width: 60,
                    disabled: true,
                    handler: function (btn) {
                        var grid = btn.up('grid');
                        var store = grid.getStore();
                        var sm = grid.getSelectionModel();
                        store.remove(sm.getSelection());
                        if (store.getCount() > 0) {
                            sm.select(0);
                        }
                        szysGrid(grid);
                        initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
                    }
                }
            ]
        }, 0);
        grid.on('selectionchange', function (view, records) {
            grid.down('#xmsyDelBtn').setDisabled(!records.length);
        });
    }
    return grid;
}

/**
 * 收支平衡 累计盈余计算
 */
function szysGrid(grid) {
    var szysStore = grid.getStore();
    for (var i = 0; i < szysStore.getCount(); i++) {
        var ljyy_sum_amt = 0.00;
        var income_year = szysStore.getAt(i).data.INCOME_YEAR;
        for (var j = 0; j < szysStore.getCount(); j++) {
            var year = szysStore.getAt(j).data.INCOME_YEAR;
            if (year <= income_year) {
                ljyy_sum_amt += szysStore.getAt(j).data.DQYY_AMT;
            }
        }
        szysStore.getAt(i).set("LJYY_AMT", ljyy_sum_amt);
    }
}

/**
 * 刷新收支平衡Form信息
 */
function initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm() {
    var xmsyStore = DSYGrid.getGrid("xmsyGrid").getStore();
    Ext.ComponentQuery.query('numberFieldFormat[name="XMZTR_AMT"]')[0].setValue(xmsyStore.sum('TOTAL_AMT'));
    Ext.ComponentQuery.query('numberFieldFormat[name="XMZCB_AMT"]')[0].setValue(xmsyStore.sum('YSCB_HJ_AMT'));
}

// /**
//  * 初始化债券信息填报弹出窗口中的存量债务标签页
//  */
// function initWindow_zqxxtb_contentForm_tab_clzw() {
//     return Ext.create('Ext.form.Panel', {
//         name: 'clzwForm',
//         width: '100%',
//         height: '100%',
//         layout: 'anchor',
//         border: false,
//         padding: '0 10 0 10',
//         defaultType: 'textfield',
//         items: [
//             {
//                 xtype: 'fieldset',
//                 title: '债务总概况',
//                 layout: 'column',
//                 defaultType: 'textfield',
//                 anchor: '100%',
//                 collapsible: false,
//                 fieldDefaults: {
//                     labelWidth: 100,
//                     columnWidth: .33,
//                     margin: '0 0 5 20'
//                 },
//                 items: [
//                     {
//                         xtype: 'numberfield',
//                         hideTrigger: true,
//                         fieldLabel: '债务总余额',
//                         name: 'DEBT_TOTAL_AMT',
//                         readOnly: true,
//                         fieldStyle: 'background:#E6E6E6'
//                     },
//                     {
//                         xtype: 'numberfield',
//                         hideTrigger: true,
//                         fieldLabel: '一般债务余额',
//                         name: 'YBZW_BALANCE',
//                         readOnly: true,
//                         fieldStyle: 'background:#E6E6E6'
//                     },
//                     {
//                         xtype: 'numberfield',
//                         hideTrigger: true,
//                         fieldLabel: '其中：一般债券',
//                         name: 'GENERAL_BOND',
//                         readOnly: true,
//                         fieldStyle: 'background:#E6E6E6'
//                     },
//                     {
//                         xtype: 'numberfield',
//                         hideTrigger: true,
//                         fieldLabel: '逾期债务',
//                         name: 'OVERDUE_DEBT',
//                         readOnly: true,
//                         fieldStyle: 'background:#E6E6E6'
//                     },
//                     {
//                         xtype: 'numberfield',
//                         hideTrigger: true,
//                         fieldLabel: '专项债务余额',
//                         name: 'ZXZW_BALANCE',
//                         readOnly: true,
//                         fieldStyle: 'background:#E6E6E6'
//                     },
//                     {
//                         xtype: 'numberfield',
//                         hideTrigger: true,
//                         fieldLabel: '其中：专项债券',
//                         name: 'SPECIAL_BOND',
//                         readOnly: true,
//                         fieldStyle: 'background:#E6E6E6'
//                     }
//                 ]
//             },
//             {
//                 xtype: 'fieldset',
//                 title: '债务明细',
//                 anchor: '100% -90',
//                 collapsible: false,
//                 layout: 'fit',
//                 items: [
//                     initWindow_zqxxtb_contentForm_tab_clzw_grid()
//                 ]
//             }
//         ]
//     });
// }
// /**
//  * 初始化债券信息填报弹出窗口中的存量债务标签页中的表格
//  */
// function initWindow_zqxxtb_contentForm_tab_clzw_grid() {
//
//     var headerJson = [
//         {
//             dataIndex: "ZW_NAME", type: "string", text: "债务/债券名称", width: 400,
//             renderer: function (data, cell, record) {
//                 var hrefUrl = null;
//                 if (record.get('ZWZQ_TYPE') == '0') {
//                     //hrefUrl = '/page/debt/common/zwyhs.jsp?zw_id=' + encodeURIComponent(record.get('ZW_ID'));
//                     var url='/page/debt/common/zwyhs.jsp';
//                     var paramNames=new Array();
//                     paramNames[0]="zw_id";
//                     var paramValues=new Array();
//                     paramValues[0]=encodeURIComponent(record.get('ZW_ID'));
//                     hrefUrl='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
//                 } else {
//                     //hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('ZW_ID') + '&AD_CODE=' + record.get('AD_CODE');
//                     var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
//                     var paramNames=new Array();
//                     paramNames[0]="ZQ_ID";
//                     paramNames[1]="AD_CODE";
//                     var paramValues=new Array();
//                     paramValues[0]=record.get('ZW_ID');
//                     paramValues[1]=record.get('AD_CODE');
//                     hrefUrl='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
//
//                 }
//                 //return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';
//                 return hrefUrl;
//             }
//         },
//         {
//             dataIndex: "JJ_DATE", type: "string", text: "举借日期"
//         },
//         {
//             dataIndex: "ZWLB_NAME", type: "string", text: "债务/债券类型", width: 150
//         },
//         {
//             dataIndex: "ZWQX_NAME", type: "string", text: "债务期限", width: 150
//         },
//         {
//             dataIndex: "LX_RATE", type: "float", text: "年利率（%）", width: 150
//         },
//         {dataIndex: "HT_NO", type: "string", text: "合同号/债券期号", width: 150, editor: 'textfield'},
//         {
//             dataIndex: "JJ_AMT", type: "float", text: "举借金额", width: 150
//         },
//         {
//             dataIndex: "CHBJ_AMT", type: "float", text: "已偿还本金", width: 150
//         },
//         {dataIndex: "YE_AMT", type: "float", text: "债务余额", width: 150},
//         {
//             dataIndex: "YQ_AMT", type: "float", text: "逾期债务", width: 150
//         }
//     ];
//
//     /**
//      * 设置表格属性
//      */
//     var config = {
//         itemId: 'clzwGrid',
//         border: false,
//         flex: 1,
//         data: [],
//         checkBox: true,
//         headerConfig: {
//             headerJson: headerJson,
//             columnAutoWidth: false
//         },
//         pageConfig: {
//             enablePage: false
//         },
//         rowNumber: {
//             rowNumber: false// 显示行号
//         }
//     };
//     //生成表格
//     var grid = DSYGrid.createGrid(config);
//     return grid;
// }
//
// /**
//  * 页签：招投标
//  */
// function initWindow_zqxxtb_contentForm_tab_xmcg() {
// 	var headerJson = [
// 	      {
// 	          dataIndex: "ZB_DATE", type: "string", text: "招标日期", width: 150
// 	      },
// 	      {
// 	          dataIndex: "YS_AMT", type: "float", text: "预算金额（万元）", width: 400
// 	      },
// 	      {
// 	          dataIndex: "ZBDW", type: "string", text: "中标单位", width: 150
// 	      },
// 	      {
// 	          dataIndex: "ZB_AMT", type: "float", text: "中标金额（万元）", width: 150
// 	      },
// 	      {
// 	          dataIndex: "HTQD_DATE", type: "string", text: "合同签订日期", width: 150
// 	      },
// 	      {
// 	          dataIndex: "HT_AMT", type: "float", text: "合同金额（万元）", width: 150
// 	      },
// 	      {dataIndex: "HTQX", type: "int", text: "合同期限", width: 150},
// 	      {text: "备注",dataIndex: "REMARK",width: 300,type: "string"}
// 	  ];
//     /**
//      * 设置表格属性
//      */
//     var config = {
//         itemId: 'xmcgGrid',
//         border: false,
//         flex: 1,
//         data: [],
//         checkBox: true,
//         headerConfig: {
//             headerJson: headerJson,
//             columnAutoWidth: false
//         },
//         pageConfig: {
//             enablePage: false
//         },
//         rowNumber: {
//             rowNumber: false// 显示行号
//         }
//     };
//     //生成表格
//     var grid = DSYGrid.createGrid(config);
//     return grid;
// }
//
// /**
//  * 页签：建设进度
//  */
// function initWindow_zqxxtb_contentForm_tab_xmjd() {
//     var config = {
//         editable: false,
//         busiId: ''
//     };
//     return Ext.create('Ext.form.Panel', {
//         width: '100%',
//         height: '100%',
//         name:'xmjsjd_contentForm',
//         itemId:'xmjsjd_contentForm',
//         layout: 'vbox',
//         fileUpload: true,
//         border: false,
//         defaults: {
//             width: '100%'
//         },
//         defaultType: 'textfield',
//         items: [
//             initWindow_zqxxtb_contentForm_tab_xmjd_grid(),
//             {
//                 title: '附件<span class="file_sum_fj" style="color: #FF0000;">(0)</span>',
//                 scrollable: true,
//                 flex: 1,
//                 name: 'xmjsjdFJ',
//                 xtype: 'fieldset',
//                 items: [
//                     {
//                         xtype: 'panel',
//                         layout: 'fit',
//                         itemId: 'winPanel_tabPanel',
//                         border:false,
//                         items: initWindow_xmjd_tab_upload(config)
//                     }
//                 ]
//             }
//         ]
//     });
// }
//
// function initWindow_zqxxtb_contentForm_tab_xmjd_grid() {
// 	var headerJson = [
//           {
//               dataIndex: "JSJD_ID", type: "string", text: "建设进度ID", width: 200, hidden: true
//           },
//           {
//               dataIndex: "JDFB_DATE", type: "string", text: "进度发布日期", width: 200
//           },
//           {
//               dataIndex: "SCJD", type: "string", text: "项目所处阶段", width: 400
//           },
//           {
//               dataIndex: "JDBL", type: "float", text: "进度比例（%）", width: 150
//           },
//           {
//               dataIndex: "JDSM", type: "string", text: "进度说明", width: 400
//           }
//       ];
//     /**
//      * 设置表格属性
//      */
//     var config = {
//         itemId: 'xmjdGrid',
//         border: false,
//         flex: 1,
//         data: [],
//         checkBox: true,
//         headerConfig: {
//             headerJson: headerJson,
//             columnAutoWidth: false
//         },
//         pageConfig: {
//             enablePage: false
//         },
//         rowNumber: {
//             rowNumber: false// 显示行号
//         },
//         listeners: {
//             'rowclick':function(self){
//                 var records = DSYGrid.getGrid('xmjdGrid').getSelection();
//                 var filePanel = Ext.ComponentQuery.query('#xmjsjd_contentForm')[0].down('#winPanel_tabPanel');
//                 if(filePanel){
//                     filePanel.removeAll();
//                     filePanel.add(initWindow_xmjd_tab_upload({
//                         editable: false,
//                         busiId: records[0].get('XMJD_ID')
//                     }));
//                 }
//             }
//         }
//
//     };
//     //生成表格
//     var grid = DSYGrid.createGrid(config);
//     return grid;
// }
// /**
//  * 初始化建设进度页签panel的附件页签
//  */
// function initWindow_xmjd_tab_upload(config) {
//     var busiId=config.busiId;
//     var grid = UploadPanel.createGrid({
//         busiType: '',//业务类型
//         busiId: window_zqxxtb.XM_ID,//业务ID
//         editable: config.editable,//是否可以修改附件内容
//         gridConfig: {
//             itemId:'window_xmjdfj'
//         }
//     });
//     //附件加载完成后计算总文件数，并写到页签上
//     grid.getStore().on('load', function (self, records, successful) {
//         var sum = 0;
//         if (records != null) {
//             for (var i = 0; i < records.length; i++) {
//                 if (records[i].data.STATUS == '已上传') {
//                     sum++;
//                 }
//             }
//         }
//         if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
//             $(grid.up('tabpanel').activeTab.el.dom).find('span.file_sum_fj').html('(' + sum + ')');
//         } else if ($('span.file_sum_fj')) {
//             $('span.file_sum_fj').html('(' + sum + ')');
//         }
//     });
//     return grid;
//
// }
// /**
//  * 初始化债券信息填报弹出窗口中的实际收益标签页
//  */
// function initWindow_zqxxtb_contentForm_tab_sjsy() {
//     return Ext.create('Ext.form.Panel', {
//         name: 'sjsyForm',
//         width: '100%',
//         height: '100%',
//         layout: 'fit',
//         border: false,
//         padding: '0 10 0 10',
//         defaultType: 'textfield',
//         items: [
//             initWindow_zqxxtb_contentForm_tab_sjsy_grid()
//         ]
//     });
// }
// /**
//  * 初始化债券信息填报弹出窗口中的实际收益明细表格
//  */
// function initWindow_zqxxtb_contentForm_tab_sjsy_grid() {
//     var headerJson = [
//           {xtype: 'rownumberer', width: 60,
//               summaryRenderer: function () {
//                   return '合计';
//               }},
//           {
//               dataIndex: "SET_YEAR", type: "string", text: "年度", width: 80, tdCls: 'grid-cell',
//               editor: {
//                   xtype: 'combobox',
//                   editable:false,
//                   displayField: 'name',
//                   valueField: 'id',
//                   store: DebtEleStore(json_debt_year)
//               }
//           },
//           {
//               header: '项目预算总收入', colspan: 2, align: 'center', columns: [
//               {dataIndex: "TOTAL_AMT", type: "float", text: "合计", width: 150, summaryType: 'sum', tdCls: 'grid-cell-unedit',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               },
//               {dataIndex: "YYSR_AMT", type: "float", text: "营业收入", width: 150,
//                   editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
//                   summaryType: 'sum',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               },
//               {dataIndex: "BTSR_AMT", type: "float", text: "补贴收入", width: 150,
//                   editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
//                   summaryType: 'sum',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               },
//               {dataIndex: "ZCBX_AMT", type: "float", text: "资产变现收入", width: 150,
//                   editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
//                   summaryType: 'sum',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               },
//               {dataIndex: "QTSR_AMT", type: "float", text: "其他收入", width: 150,
//                   editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
//                   summaryType: 'sum',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               }
//           ]
//           },
//           {
//               header: '项目预算总支出', colspan: 2, align: 'center', columns: [
//               {dataIndex: "YSCB_HJ_AMT", type: "float", text: "合计", width: 150, tdCls: 'grid-cell-unedit',
//                   summaryType: 'sum',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               },
//               {dataIndex: "JYCB_AMT", type: "float", text: "经营成本", width: 150,
//                   editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
//                   summaryType: 'sum',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               },
//               {dataIndex: "ZJFY_AMT", type: "float", text: "折旧费用", width: 150,
//                   editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
//                   summaryType: 'sum',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               },
//               {dataIndex: "LXZC_AMT", type: "float", text: "利息支出", width: 150,
//                   editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
//                   summaryType: 'sum',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               },
//               {dataIndex: "SFZC_AMT", type: "float", text: "税费支出", width: 150,
//                   editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
//                   summaryType: 'sum',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               },
//               {dataIndex: "HBZC_AMT", type: "float", text: "还本支出", width: 150,
//                   editor: {xtype: 'numberFieldFormat', hideTrigger: true, minValue: 0},
//                   summaryType: 'sum',
//                   summaryRenderer: function (value) {
//                       return Ext.util.Format.number(value, '0,000.00');
//                   }
//               }
//           ]
//           },
//           {dataIndex: "DQYY_AMT", type: "float", text: "当期盈余", width: 150, tdCls: 'grid-cell-unedit',
//               summaryType: 'sum',
//               summaryRenderer: function (value) {
//                   return Ext.util.Format.number(value, '0,000.00');
//               }
//           },
//           {dataIndex: "LJYY_AMT", type: "float", text: "累计盈余", width: 150, tdCls: 'grid-cell-unedit'}
//       ];
//     /**
//      * 设置表格属性
//      */
//     var config = {
//         itemId: 'sjsyGrid',
//         border: false,
//         data: [],
//         checkBox: true,
//         headerConfig: {
//             headerJson: headerJson,
//             columnAutoWidth: false
//         },
//         pageConfig: {
//             enablePage: false
//         },
//         rowNumber: {
//             rowNumber: false// 显示行号
//         },
//         features: [{
//             ftype: 'summary'
//         }],
//         plugins: [
//                   {
//                       ptype: 'cellediting',
//                       clicksToEdit: 1,
//                       pluginId: 'xmsyCellEdit',
//                       clicksToMoveEditor: 1,
//                       listeners: {
//                           'beforeedit': function (editor, context) {
//                           },
//                           'validateedit': function (editor, context) {
//                               if (context.field == 'YYSR_AMT' || context.field == 'BTSR_AMT' || context.field == 'ZCBX_AMT' || context.field == 'QTSR_AMT') {
//                                   if (isNaN(parseFloat(context.value)) || parseFloat(context.value) < 0) {
//                                       Ext.toast({
//                                           html: "输入错误字符或者收入低于0！",
//                                           closable: false,
//                                           align: 't',
//                                           slideInDuration: 400,
//                                           minWidth: 400
//                                       });
//                                       return false;
//                                   }
//                               }
//                               if (context.field == 'SET_YEAR' ) {
//                                   var xmsyform_temp=Ext.ComponentQuery.query('form[name="xmsyForm"]')[0].getForm();
//                                   var limit_date_max=parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0,4))+parseInt(xmsyform_temp.findField("XM_USED_LIMIT").getValue());
//                                   if(context.value>limit_date_max){
//                                       Ext.toast({
//                                           html: "添加的年度不能超过项目投入使用日期与项目期限之和！",
//                                           closable: false,
//                                           align: 't',
//                                           slideInDuration: 400,
//                                           minWidth: 400
//                                       });
//                                       return false;
//                                   }
//                                   if(context.value<parseInt(xmsyform_temp.findField("XM_USED_DATE").rawValue.substring(0,4))){
//                                       Ext.toast({
//                                           html: "输入的年度不能小于项目投入使用日期所在的年度",
//                                           closable: false,
//                                           align: 't',
//                                           slideInDuration: 400,
//                                           minWidth: 400
//                                       });
//                                       return false;
//                                   }
//                               }
//
//                           },
//                           'edit': function (editor, context) {
//                               // 项目预算总收入
//                               if (context.field == 'YYSR_AMT' || context.field == 'BTSR_AMT' || context.field == 'ZCBX_AMT' || context.field == 'QTSR_AMT' ) {
//                                   var yysr_amt = context.record.get("YYSR_AMT");
//                                   var czbz_amt = context.record.get("BTSR_AMT");
//                                   var zcbx_amt = context.record.get("ZCBX_AMT");
//                                   var qt_amt = context.record.get("QTSR_AMT");
//                                   var total_amt = new Object(yysr_amt + czbz_amt + zcbx_amt + qt_amt);
//                                   context.record.set('TOTAL_AMT', Math.floor((total_amt) * 100) / 100);
//
//                                   context.record.set('DQYY_AMT', Math.floor((context.record.get("TOTAL_AMT") - context.record.get("YSCB_HJ_AMT")) * 100) / 100);
//                                   var ljyy_sum_amt = 0.00;
//                                   grid.getStore().each(function (record) {
//                                       if (record.get('SET_YEAR') <= context.record.get("SET_YEAR")) {
//                                           ljyy_sum_amt += record.get('DQYY_AMT');
//                                       }
//                                   });
//                                   context.record.set('LJYY_AMT', Math.floor((ljyy_sum_amt) * 100) / 100);
//                                   szysGrid(grid);
//                                   initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
//                               }
//                               // 项目预算总成本
//                               if (context.field == 'XM_YY_AMT'||context.field == 'ZJFY_AMT' || context.field == 'LXZC_AMT' || context.field == 'SFZC_AMT' || context.field == 'HBZC_AMT') {
//                                   var xm_yy_amt = context.record.get("XM_YY_AMT");
//                                   var zjfy_amt = context.record.get("ZJFY_AMT");
//                                   var lxzc_amt = context.record.get("LXZC_AMT");
//                                   var sfzc_amt = context.record.get("SFZC_AMT");
//                                   var hbzc_amt = context.record.get("HBZC_AMT");
//                                   var yscb_hj_amt = new Object(xm_yy_amt + zjfy_amt + lxzc_amt + sfzc_amt+hbzc_amt);
//                                   context.record.set('YSCB_HJ_AMT', Math.floor((yscb_hj_amt) * 100) / 100);
//
//                                   context.record.set('DQYY_AMT', Math.floor((context.record.get("TOTAL_AMT") - context.record.get("YSCB_HJ_AMT")) * 100) / 100);
//                                   var ljyy_sum_amt = 0.00;
//                                   grid.getStore().each(function (record) {
//                                       if (record.get('SET_YEAR') <= context.record.get("SET_YEAR")) {
//                                           ljyy_sum_amt += record.get('DQYY_AMT');
//                                       }
//                                   });
//                                   context.record.set('LJYY_AMT', Math.floor((ljyy_sum_amt) * 100) / 100);
//                                   szysGrid(grid);
//                                   initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
//                               }
//                           }
//                       }
//                   }
//               ]
//     };
//     //生成表格
//     var grid = DSYGrid.createGrid(config);
//     return grid;
// }

// /**
//  * 刷新存量债务Form信息
//  */
// function initWindow_zqxxtb_contentForm_tab_clzw_refreshForm() {
//     var clzwStore = DSYGrid.getGrid("clzwGrid").getStore();
//     Ext.ComponentQuery.query('numberfield[name="DEBT_TOTAL_AMT"]')[0].setValue(clzwStore.sum('YE_AMT'));
//     var ybzwye = 0;
//     clzwStore.each(function (record) {
//         if ((record.get('ZWLB_ID') == '0101' && record.get('ZWZQ_TYPE') == '0') || (record.get('ZWLB_ID') == '01' && record.get('ZWZQ_TYPE') == '1')) {
//             ybzwye = ybzwye + record.get('YE_AMT');
//         }
//     });
//     Ext.ComponentQuery.query('numberfield[name="YBZW_BALANCE"]')[0].setValue(ybzwye);
//     var ybzwye_ybzq = 0;
//     clzwStore.each(function (record) {
//         if (record.get('ZWLB_ID') == '01' && record.get('ZWZQ_TYPE') == '1') {
//             ybzwye_ybzq = ybzwye_ybzq + record.get('YE_AMT');
//         }
//     });
//     Ext.ComponentQuery.query('numberfield[name="GENERAL_BOND"]')[0].setValue(ybzwye_ybzq);
//     var zxzwye = 0;
//     clzwStore.each(function (record) {
//         if ((record.get('ZWLX_ID') == '0102' && record.get('ZWZQ_TYPE') == '0') || record.get('ZWLB_ID') == '02' && record.get('ZWZQ_TYPE') == '1') {
//             zxzwye = zxzwye + record.get('YE_AMT');
//         }
//     });
//     Ext.ComponentQuery.query('numberfield[name="ZXZW_BALANCE"]')[0].setValue(zxzwye);
//     var zxzwye_zxzq = 0;
//     clzwStore.each(function (record) {
//         if (record.get('ZWLB_ID') == '02' && record.get('ZWZQ_TYPE') == '1') {
//             zxzwye_zxzq = zxzwye_zxzq + record.get('YE_AMT');
//         }
//     });
//     Ext.ComponentQuery.query('numberfield[name="SPECIAL_BOND"]')[0].setValue(zxzwye_zxzq);
//     Ext.ComponentQuery.query('numberfield[name="OVERDUE_DEBT"]')[0].setValue(clzwStore.sum('YQ_AMT'));
// }

// /**
//  * 初始化债券信息填报弹出窗口中的绩效情况标签页
//  */
// function initWindow_zqxxtb_contentForm_tab_jxqk() {
//     return Ext.create('Ext.form.Panel', {
//         name: 'jxqkForm',
//         width: '100%',
//         height: '100%',
//         layout: 'anchor',
//         border: false,
//         defaults: {
//             margin: '0 0 0 0',
//             padding: '0 0 0 0',
//             anchor: '100%'
//         },
//         defaultType: 'textfield',
//         items: [
//             {
//                 xtype: 'fieldcontainer',
//                 style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
//                 layout: 'column',
//                 defaultType: 'textfield',
//                 fieldDefaults: {
//                     labelWidth: 80,
//                     columnWidth: .33,
//                     margin: '5 0 5 20'
//                 },
//                 items: [
//                     {
//                         fieldLabel: '项目类型',
//                         name: 'JXQK_XMLX_ID',
//                         xtype: 'treecombobox',
//                         minPicekerWidth: 250,
//                         displayField: 'name',
//                         valueField: 'id',
//                         store: DebtEleTreeStoreDB("DEBT_ZWXMLX"),
//                         //store: DebtEleTreeStoreJSON(json_debt_zwxmlx),
//                         readOnly: true
//                     },
//                     {
//                         fieldLabel: '绩效年度',
//                         name: 'ZB_YEAR',
//                         xtype: 'combobox',
//                         value: new Date().getFullYear(),
//                         displayField: 'name',
//                         valueField: 'id',
//                         store: DebtEleStore(getYearList()),
//                         editable: false,
//                         listeners: {
//                             'change': function () {
//                                 reloadJxqkGrid()
//                             }
//                         }
//                     },
//                     {
//                         fieldLabel: '填报日期',
//                         name: 'TB_DATE',
//                         xtype: 'datefield',
//                         format: 'Y-m-d',
//                         editable: false,
//                         value: today
//                     },
//                     {
//                         fieldLabel: '填报人',
//                         name: 'OPER_USER',
//                         value: userName
//                     }
//                 ]
//             },
//             {
//                 xtype: 'fieldcontainer',
//                 anchor: '100% -80',
//                 layout: 'anchor',
//                 defaults: {
//                     anchor: '-10 -10'
//
//                 },
//                 style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
//                 items: [initWindow_zqxxtb_contentForm_tab_jxqk_grid()]
//             }
//         ]
//     });
// }
// /**
//  * 初始化债券信息填报弹出窗口中的绩效情况标签页中的表格
//  */
// function initWindow_zqxxtb_contentForm_tab_jxqk_grid() {
//     var eleStore = DebtEleStore(json_debt_sf);//默认为是否
//     var headerJson = [
//         {dataIndex: "DTL_ID", type: "string", text: "考核信息ID", hidden: true},
//         {dataIndex: "BILL_ID", type: "string", text: "绩效主单ID", hidden: true},
//         {dataIndex: "ZB_YEAR", type: "string", text: "年度"},
//         {dataIndex: "ZB_CODE", type: "string", text: "指标编码", width: 150},
//         {dataIndex: "ZBSX_ID", type: "string", text: "指标属性", width: 200},
//         {dataIndex: "ZBLB_ID", type: "string", text: "指标类别"},
//         {dataIndex: "XMJD_ID", type: "string", text: "项目阶段"},
//         {dataIndex: "ZBXZ_ID", type: "string", text: "指标性质", width: 150},
//         {dataIndex: "ZB_NAME", type: "string", text: "指标名称", width: 300},
//         {dataIndex: "ZB_DESC", type: "string", text: "指标说明"},
//         {dataIndex: "PJ_UNIT", type: "string", text: "评价单位", hidden: true},
//         {dataIndex: "ENUM_ZY", type: "string", text: "枚举值域", hidden: true},
//         {dataIndex: "ENUM_FZ", type: "string", text: "枚举分值", hidden: true},
//         {dataIndex: "MAX_VALUE", type: "string", text: "最大值", hidden: true},
//         {dataIndex: "MIN_VALUE", type: "string", text: "最小值", hidden: true},
//         {
//             dataIndex: "KH_MB", id: 'KH_MB', type: "string", text: "绩效考核目标", editor: 'textfield', width: 150,
//             renderer: function (val, rd, model, row, col, store, gridview) {
//                 var record = store.data.items[row];
//                 record.set('ROWNUM', row);
//                 //重新渲染，显示name
//                 var returnRecord = eleStore.findRecord('id', val, 0, false, true, true);
//                 return returnRecord != null ? returnRecord.get('name') : val;
//             }
//         },
//         {dataIndex: "ROWNUM", type: "int", text: "序号", hidden: true},
//         {dataIndex: "REMARK", type: "string", text: "备注", editor: 'textfield'}
//     ];
//     /**
//      * 设置表格属性
//      */
//     var config = {
//         itemId: 'jxqkGrid',
//         border: false,
//         flex: 1,
//         //data: [],
//         dataUrl: 'getJxqkGrid.action',
//         autoLoad: false,
//         checkBox: true,
//         headerConfig: {
//             headerJson: headerJson,
//             columnAutoWidth: false
//         },
//         pageConfig: {
//             enablePage: false
//         },
//         rowNumber: {
//             rowNumber: false// 显示行号
//         },
//         plugins: [
//             {
//                 ptype: 'cellediting',
//                 clicksToEdit: 1,
//                 pluginId: 'clzwCellEdit',
//                 clicksToMoveEditor: 1,
//                 listeners: {
//                     'beforeedit': function (editor, context) {
//                         var row = context.record.get("ROWNUM");
//                         var record = DSYGrid.getGrid('jxqkGrid').getStore().data.items[row];
//                         var column = Ext.getCmp('KH_MB');
//                         //重新加载插件
//                         if (record.data.PJ_UNIT == '0') {//是否
//                             eleStore = DebtEleStore(json_debt_sf);
//                             column.setEditor({
//                                 xtype: 'combobox',
//                                 displayField: 'name',
//                                 valueField: 'id',
//                                 store: eleStore
//                             });
//                         } else if (record.data.PJ_UNIT == '1') {//枚举
//                             var ENUM_ZY_ARRAY = (record.data.ENUM_ZY).split("|");
//                             var ENUM_FZ_ARRAY = (record.data.ENUM_FZ).split("|");
//                             /*动态拼接storeJson串*/
//                             var storeJson = '[';
//                             for (i = 0; i < ENUM_ZY_ARRAY.length; i++) {
//                                 storeJson = storeJson + '{id: "' + ENUM_FZ_ARRAY[i] + '", code: "' + ENUM_FZ_ARRAY[i] + '", name: "' + ENUM_ZY_ARRAY[i] + '"},'
//                             }
//                             storeJson = storeJson.substring(0, storeJson.length - 1);
//                             storeJson = storeJson + ']';
//                             //生成eleStore
//                             eleStore = DebtEleStore(eval(storeJson));
//                             //eleStore.sort('name');
//                             column.setEditor({
//                                 xtype: 'combobox',
//                                 displayField: 'name',
//                                 valueField: 'id',
//                                 store: eleStore
//                             });
//                         } else {
//                             var MAX_VALUE = record.data.MAX_VALUE;
//                             var MIN_VALUE = record.data.MIN_VALUE;
//                             column.setEditor({
//                                 xtype: 'numberfield',
//                                 hideTrigger: true,
//                                 maxValue: MAX_VALUE,
//                                 minValue: MIN_VALUE
//                             });
//                         }
//                     },
//                     'validateedit': function (editor, context) {
//                     },
//                     'edit': function (editor, context) {
//                     }
//                 }
//             }
//         ]
//     };
//     //生成表格
//     var grid = DSYGrid.createGrid(config);
//     return grid;
// }
// /**
//  * 初始化债券信息填报弹出窗口中的项目附件标签页
//  */
function initWindow_zqxxtb_contentForm_tab_xmfj() {
    var tag = true;
    if (is_view == "1" || (connNdjh == '1' || connNdjh == 1 || connZwxx == '1' || connZwxx == 1)) {
        tag = false;
    }
    var grid = UploadPanel.createGrid({
        busiType: 'ET001',//业务类型
        busiId: XM_ID,//业务ID
        editable: tag,//是否可以修改附件内容
        //20201217 fzd 附件增加“第三方单位名称”、“组织机构代码”、“备注”
        addHeaders: [
            {text: '第三方单位名称', dataIndex: 'DSF_AG_NAME', width: 260, type: 'string', editor: 'textfield'},
            {text: '组织机构代码', dataIndex: 'DSF_ZZJG_CODE', type: 'string', editor: 'textfield'},
            {text: '备注', dataIndex: 'REMARK', type: 'string', editor: 'textfield'}
        ],
        gridConfig: {
            itemId: 'window_zqxxtb_contentForm_tab_xmfj_grid'
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
        if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}

/**
 * 初始化债券信息填报弹出窗口中的收支平衡标签页中的表格
 */
function initWindow_zqxxtb_contentForm_tab_gdzc() {
    var zclbStore = DebtEleTreeStoreJSON(json_debt_zclb);
    var jldwStore = DebtEleStoreDB('DEBT_ZCJLDW');
    var syztStore = DebtEleStoreDB('DEBT_ZCSYZT');
    var yjztStore = DebtEleStore(json_debt_sf);
    var headerJson = [
        {
            dataIndex: "ZC_CODE",
            type: "string",
            text: "资产编码",
            width: 150,
            editor: 'textfield'
        },
        {
            dataIndex: "ZC_NAME",
            type: "string",
            text: "资产名称",
            width: 200,
            editor: 'textfield'
        },
        {
            dataIndex: "ZCLB_ID",
            type: "string",
            text: "资产类别",
            width: 150,
            editor: {
                xtype: 'treecombobox',
                displayField: 'name',
                valueField: 'id',
                store: zclbStore,
                editable: false,
                selectModel: 'leaf'
            },
            renderer: function (value) {
                var record = zclbStore.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }

        },
        {
            dataIndex: "ZC_COUNT",
            type: "float",
            text: "资产数量",
            width: 150,
            editor: {
                xtype: 'numberfield',
                hideTrigger: true
            }
        },
        {
            dataIndex: "JLDW_ID",
            type: "string",
            text: "计量单位",
            width: 100,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                editable: false,
                valueField: 'id',
                store: jldwStore
            },
            renderer: function (value) {
                var record = jldwStore.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            dataIndex: "USING_STATE",
            type: "string",
            text: "使用状态",
            width: 150,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                editable: false,
                valueField: 'id',
                store: syztStore
            },
            renderer: function (value) {
                var record = syztStore.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            dataIndex: "RZ_DATE",
            type: "string",
            text: "实物入账日期",
            width: 150,
            editor: {
                xtype: 'datefield',
                format: 'Y-m-d'
            },
            renderer: function (value, metaData, record) {
                var dateStr = Ext.util.Format.date(value, 'Y-m-d');
                return dateStr;
            }
        },
        {
            dataIndex: 'LOCATION',
            type: 'string',
            text: '存放地点',
            width: 200,
            editor: 'textfield'
        },
        {
            dataIndex: "USE_YEARS",
            type: "float",
            text: "使用年限",
            width: 150,
            editor: {
                xtype: 'numberfield',
                hideTrigger: true
            }
        },
        {
            dataIndex: 'USE_DEPT',
            type: 'string',
            text: '使用部门',
            width: 150,
            editor: 'textfield'
        },
        {
            dataIndex: 'MGMT_DETP',
            type: 'string',
            text: '管理部门',
            width: 150,
            editor: 'textfield'
        },
        {
            dataIndex: "YJ_STATE",
            type: "string",
            text: "移交状态",
            width: 100,
            editor: {
                xtype: 'combobox',
                displayField: 'name',
                editable: false,
                valueField: 'id',
                store: yjztStore
            },
            renderer: function (value) {
                var record = yjztStore.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {
            dataIndex: 'YJ_DEBT',
            type: 'string',
            text: '移交部门',
            width: 150,
            editor: 'textfield'
        },
        {
            dataIndex: 'REMARK',
            type: 'string',
            text: '备注',
            width: 200,
            editor: 'textfield'
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'gdzcGrid',
        border: false,
        flex: 1,
        data: [],
        checkBox: true,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'gdzcCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                    },
                    'validateedit': function (editor, context) {
                    },
                    'edit': function (editor, context) {
                    }
                }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    if (!(is_view == "1")) {
        //将增加删除按钮添加到表格中
        grid.addDocked({
            xtype: 'toolbar',
            layout: 'column',
            items: [
                '->',
                {
                    xtype: 'button',
                    text: '添加',
                    width: 60,
                    handler: function (btn) {
                        btn.up('grid').insertData(null, {});
                    }
                },
                {
                    xtype: 'button',
                    itemId: 'gdzcDelBtn',
                    text: '删除',
                    width: 60,
                    disabled: true,
                    handler: function (btn) {
                        var grid = btn.up('grid');
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
            grid.down('#gdzcDelBtn').setDisabled(!records.length);
        });
    }
    return grid;
}

/**
 * 加载页面数据
 * @param form
 */
function loadInfo() {
    $.post('getJSXMInfo.action', {
        XM_ID: XM_ID,
        isOld_szysGrid: isOld_szysGrid,
        tab_items: Ext.util.JSON.encode(tab_items_load),
        IS_XMBCXX: IS_XMBCXX
    }, function (data) {
        var dataJson = Ext.util.JSON.decode(data);
        if (dataJson.success) {
            //获取基本情况页签表单
            var jbqkForm = Ext.ComponentQuery.query('form[name="jbqkForm"]')[0];
            //获取补充信息页签表单
            var bcxxForm = Ext.ComponentQuery.query('form[name="bcxxForm"]')[0];
            //获取收支平衡页签表单
            var xmsyForm = Ext.ComponentQuery.query('form[name="xmsyForm"]')[0];
            connNdjh = dataJson.data.jbqkForm.CONNNDJH;
            connZwxx = dataJson.data.jbqkForm.CONNZWXX;
            var xmlx_id = dataJson.data.jbqkForm.XMLX_ID;
            var filePanel = Ext.ComponentQuery.query('#xmxxTabPanel')[0].down('#fileTab_panel');
            filePanel.removeAll();
            filePanel.add(initWindow_zqxxtb_contentForm_tab_xmfj());
            //加载基本情况页签表单
            jbqkForm.getForm().setValues(dataJson.data.jbqkForm);
            jbqkForm.getForm().findField('XMLX_ID').setValue(xmlx_id);
            if (IS_XMBCXX == '1') {
                //加载补充信息页签表单
                bcxxForm.getForm().setValues(dataJson.data.bcxxForm);
            }
            //加载投资计划表单
            var XMZGS_AMT = dataJson.data.jbqkForm.XMZGS_AMT;
            var LJWCTZ_AMT = dataJson.data.jbqkForm.LJWCTZ_AMT;
            var ZBJ_AMT = dataJson.data.jbqkForm.ZBJ_AMT;
            var ZBJ_ZQ_AMT = dataJson.data.jbqkForm.ZBJ_ZQ_AMT;
            var ZBJ_YS_AMT = dataJson.data.jbqkForm.ZBJ_YS_AMT;
            Ext.ComponentQuery.query('[name="TZJH_XMZGS_AMT"]')[0].setValue(XMZGS_AMT);
            Ext.ComponentQuery.query('[name="TZJH_XMZGS_AMT_BAK"]')[0].setValue(XMZGS_AMT);
            Ext.ComponentQuery.query('[name="LJWCTZ_AMT"]')[0].setValue(LJWCTZ_AMT);
            Ext.ComponentQuery.query('[name="ZBJ_AMT"]')[0].setValue(ZBJ_AMT);
            Ext.ComponentQuery.query('[name="ZBJ_ZQ_AMT"]')[0].setValue(ZBJ_ZQ_AMT);
            Ext.ComponentQuery.query('[name="ZBJ_YS_AMT"]')[0].setValue(ZBJ_YS_AMT);
            //加载投资计划页签表格
            var tzjhStore = dataJson.data.tzjhGrid;
            var tzjhGrid = DSYGrid.getGrid('tzjhGrid');
            tzjhGrid.getStore().removeAll();
            tzjhGrid.insertData(null, tzjhStore);
            var sdgcStore = dataJson.data.sdgcGrid;
            var sdgcGrid = DSYGrid.getGrid('sdgcGrid');
            sdgcGrid.getStore().removeAll();
            sdgcGrid.insertData(null, sdgcStore);
            if (tzjhGrid.getStore().getCount() > 0) {
                DSYGrid.getGrid("tzjhGrid").getStore().each(function (record) {
                    if (record.get("RZZJ_ACTUAL_AMT") <= 0) {
                        var RZZJ_XJ = record.get("RZZJ_YBZQ_AMT") + record.get("RZZJ_ZXZQ_AMT") + record.get("RZZJ_ZHZQ_AMT");
                        record.set("RZZJ_ACTUAL_AMT", RZZJ_XJ);
                    }
                });
            }
            calculateRzzjAmount(tzjhGrid);
            //如果是存量项目录入/修改,不计算项目总概算等
            if (!is_cl || (is_cl != '1' && is_cl != 1)) {
                initWindow_zqxxtb_contentForm_tab_tzjh_refreshForm();
            }
            if (isOld_szysGrid == '1') {
                //加载收支平衡页签表格
                var xmsyStore = dataJson.data.xmsyGrid;
                for (var i = 0; i < xmsyStore.length; i++) {
                    xmsyStore[i].TOTAL_AMT = xmsyStore[i].YYSR_AMT + xmsyStore[i].CZBZ_AMT + xmsyStore[i].ZCBX_AMT + xmsyStore[i].QT_AMT;
                    xmsyStore[i].YSCB_HJ_AMT = xmsyStore[i].XM_YY_AMT + xmsyStore[i].ZJFY_AMT + xmsyStore[i].LXZC_AMT + xmsyStore[i].SFZC_AMT + xmsyStore[i].HBZC_AMT;
                }
                var xmsyGrid = DSYGrid.getGrid('xmsyGrid');
                xmsyGrid.getStore().removeAll();
                xmsyGrid.insertData(null, xmsyStore);
                if (xmsyStore && xmsyStore.length > 0) {
                    xmsyForm.down('treecombobox[name="ZFXJJKM_ID"]').setValue(xmsyStore[0].ZFXJJKM_ID);
                    xmsyForm.down('datefield[name="XM_USED_DATE"]').setValue(typeof xmsyStore[0].XM_USED_DATE == 'undefined' ? '' : xmsyStore[0].XM_USED_DATE);
                    xmsyForm.down('numberFieldFormat[name="XM_USED_LIMIT"]').setValue(typeof xmsyStore[0].XM_USED_LIMIT == 'undefined' ? '' : xmsyStore[0].XM_USED_LIMIT);
                    xmsyForm.down('textfield[name="REMARK"]').setValue(typeof xmsyStore[0].REMARK == 'undefined' ? '' : xmsyStore[0].REMARK);
                }
                initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
            }


            //加载存量债务页签表格
            /*setClzwxx(dataJson);
            // var clzwStore = dataJson.data.clzwGrid;
            // var clzwGrid = DSYGrid.getGrid('clzwGrid');
            // clzwGrid.getStore().removeAll();
            // clzwGrid.insertData(null, clzwStore);
            // initWindow_zqxxtb_contentForm_tab_clzw_refreshForm();

            //加载招投标页签表格
            setZtbxx(dataJson);

            //加载建设进度页签表格
            setJsjdxx(dataJson);

            //加载实际收益页签表格
            setSjsyxx(dataJson);
*/
            //加载绩效情况页签表单
            //setJxqkxx(dataJson,XM_ID);
            //刷新收支平衡页签表单信息
            //initWindow_zqxxtb_contentForm_tab_xmsy_refreshForm();
            //增加校验
            if (is_cl == '0' && (connNdjh == '1' || connNdjh == 1 || connZwxx == '1' || connZwxx == 1)) {
                SetFormItemsReadOnly(jbqkForm.items);
                jbqkForm.items.each(function (item1) {
                        if (item1.items != undefined && item1.items != "" && item1.items != "null") {
                            item1.items.each(function (item) {
                                if (item.name == 'BUILD_STATUS_ID'
                                    || item.name == 'START_DATE_ACTUAL'
                                    || item.name == 'END_DATE_ACTUAL'
                                    || item.name == 'YSXM_NO'
                                    || item.name == 'JYS_NO'
                                    || item.name == 'PF_NO'
                                    || item.name == 'BILL_PERSON'
                                    || item.name == 'BILL_PHONE'
                                    || item.name == 'BUILD_CONTENT'
                                    || item.name == 'FGW_XMK_CODE'
                                    || item.name == 'CYLX_ID'
                                    || item.name == 'LXSPYJ_ID'
                                ) {
                                    item.setReadOnly(false);
                                    item.setFieldStyle('background:white');
                                    item.readOnly = false;
                                    item.fieldStyle = 'background:white';
                                } else {

                                }
                            });
                        }
                    }
                );
            }
            //LxdwRender(xmlx_id);
        } else {
            alert('加载失败');
            Ext.ComponentQuery.query('window[name="window_zqxxtb"]')[0].close();
        }
        // 20210719 guoyf 默认加载收支预算表格
        if (isOld_szysGrid == '0') {
            change_tdcbysbz_grid('', {IS_YHS: false, XM_ID: XM_ID});
        }
    });
}

function LxdwRender(xmlx_id) {
    var field_names;
    var max_values;
    if (xmlx_id == '05') {
        field_names = '<span class="required">✶</span>土地面积(公顷)';
        max_values = 1000000;
        var DISC = Ext.ComponentQuery.query('textfield[name="DISC"]')[0];
        DISC.allowBlank = false;
        var $a1 = '<span class="required">✶</span>国土部门监管码';
        DISC.setFieldLabel($a1);
    } else {
        var DISC = Ext.ComponentQuery.query('textfield[name="DISC"]')[0];
        DISC.allowBlank = true;
        var $a1 = '国土部门监管码';
        DISC.setFieldLabel($a1);
    }
    if (xmlx_id.substring(0, 2) == '02') {
        field_names = '<span class="required">✶</span>通车里程(公里)';
        max_values = 10000;
    }
    var cc = Ext.ComponentQuery.query('numberFieldFormat[name="LXDW"]')[0];
    if (xmlx_id == '05' || xmlx_id.substring(0, 2) == '02') {
        var cc = Ext.ComponentQuery.query('numberFieldFormat[name="LXDW"]')[0]//.setVisible(true);
        cc.setFieldLabel(field_names);
        cc.allowBlank = false;
        cc.setVisible(true);
        cc.maxValue = max_values;
    }
}

// /**
//  * 刷新绩效情况表格
//  */
// function reloadJxqkGrid() {
//     var JXQK_XMLX_ID = Ext.ComponentQuery.query('treecombobox[name="JXQK_XMLX_ID"]')[0].value;
//     var ZB_YEAR = Ext.ComponentQuery.query('combobox[name="ZB_YEAR"]')[0].value;
//     var grid = DSYGrid.getGrid('jxqkGrid');
//     var store = grid.getStore();
//     //增加查询参数
//     store.getProxy().extraParams["XM_ID"] = XM_ID;
//     store.getProxy().extraParams["JXQK_XMLX_ID"] = JXQK_XMLX_ID;
//     store.getProxy().extraParams["ZB_YEAR"] = ZB_YEAR;
//     //刷新
//     store.loadPage(1);
// }

function dooperation() {
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条记录的操作记录！');
        return;
    } else {
        XM_ID = records[0].get("XM_ID");
        fuc_getWorkFlowLog(XM_ID);
    }
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
        ids.push(records[i].get("XM_ID"));
    }

    button_name = btn.text;
    if (button_name == '送审') {
        Ext.Msg.confirm('提示', '请确认是否' + button_name + '!', function (btn_confirm) {
            if (btn_confirm === 'yes') {
                //发送ajax请求，修改节点信息
                btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
                $.post("/updateCbxmtbNode.action", {
                    workflow_direction: btn.name,
                    wf_id: wf_id,
                    node_code: node_code,
                    button_name: button_name,
                    audit_info: '',
                    ids: ids
                }, function (data) {
                    if (data.success) {
                        Ext.toast({
                            html: button_name + "成功！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        btn.setDisabled(false);
                    } else {
                        Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                        btn.setDisabled(false);
                    }
                    //刷新表格
                    getHbfxDataList();
                }, "json");
            }
        });
    } else {
        //弹出意见填写对话框
        initWindow_opinion({
            title: btn.text,
            animateTarget: btn,
            value: btn.name == 'down' ? '同意' : null,
            fn: function (buttonId, text) {
                if (buttonId === 'ok') {
                    btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
                    //发送ajax请求，修改节点信息
                    $.post("/updateCbxmtbNode.action", {
                        workflow_direction: btn.name,
                        wf_id: wf_id,
                        node_code: node_code,
                        button_name: button_name,
                        audit_info: text,
                        ids: ids
                    }, function (data) {
                        if (data.success) {
                            Ext.toast({
                                html: button_name + "成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            btn.setDisabled(false);
                        } else {
                            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
                            btn.setDisabled(false);
                        }
                        //刷新表格
                        getHbfxDataList();
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

Ext.Loader.setConfig({
    enabled: true,
    disableCaching: false,//加载js不添加dc=xxxxxx后缀
    paths: {'Ext.ux': '/js'}//加载js路径
});
