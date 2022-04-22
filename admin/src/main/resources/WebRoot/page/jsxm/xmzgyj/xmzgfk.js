/*工作流状态1*/
var json_debt_fkzt = [
    {id: "001", code: "001", name: "未反馈"},
    {id: "002", code: "002", name: "已反馈"},
    {id: "004", code: "004", name: "被退回"}
];
$.extend(xmzg_json_common[node_type], {
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
                        reloadGrid();
                    }
                }
            },
            {
                xtype: 'button',
                text: '整改结果反馈',
                icon: '/image/sysbutton/edit.png',
                name: 'UPDATE',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
                        return;
                    }
                    var record = records[0];
                    var XM_ID = record.get("XM_ID");
                    ZGXX_ID = record.get("ZGXX_ID");
                    initWin_xmzgWindow(XM_ID, AG_ID, btn, ZGXX_ID);
                    loadZgxx(XM_ID, btn.name, ZGXX_ID);
                }
            },
            {
                xtype: 'button',
                text: '发送',
                name: 'fk',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        btn.setDisabled(false);
                        return;
                    }
                    for(var i=0;i<records.length;i++){
                        if(isNull(records[i].get("OP_CONTENT"))){
                            Ext.MessageBox.alert('提示', '项目名称：'+records[i].get("XM_NAME")+' 还未录入反馈意见，请录入反馈意见后再次发送！');
                            btn.setDisabled(false);
                            return;
                        }
                    }
                    Ext.MessageBox.show({
                        title: "提示",
                        msg: "是否确认发送？",
                        width: 200,
                        buttons: Ext.MessageBox.OKCANCEL,
                        fn: function (btn_ok, text) {
                            audit_info = text;
                            if (btn_ok == "ok") {
                                next(btn);
                            }else{
                                btn.setDisabled(false);
                            }
                        }
                    });
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
                        reloadGrid();
                    }
                }
            },
            {
                xtype: 'button',
                text: '撤销反馈',
                name: 'back',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        btn.setDisabled(false);
                        return;
                    } else {
                        Ext.MessageBox.show({
                            title: "提示",
                            msg: "是否撤销选择的记录？",
                            width: 200,
                            buttons: Ext.MessageBox.OKCANCEL,
                            fn: function (b_btn, text) {
                                audit_info = text;
                                if (b_btn == "ok") {
                                    back(btn);
                                }else{
                                    btn.setDisabled(false);
                                }
                            }
                        });
                    }
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
                    if (AD_CODE == null || AD_CODE == '') {
                        Ext.Msg.alert('提示', '请选择区划！');
                        return;
                    } else {
                        reloadGrid();
                    }
                }
            },
            {
                xtype: 'button',
                text: '修改',
                icon: '/image/sysbutton/edit.png',
                name: 'UPDATE',
                handler: function (btn) {
                    //获取表格选中数据
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length != 1) {
                        Ext.MessageBox.alert('提示', '请选择一条后再进行操作!');
                        return;
                    }
                    var record = records[0];
                    var XM_ID = record.get("XM_ID");
                    ZGXX_ID = record.get("ZGXX_ID");
                    initWin_xmzgWindow(XM_ID, AG_ID, btn, ZGXX_ID);
                    loadZgxx(XM_ID, btn.name, ZGXX_ID);
                }
            },
            {
                xtype: 'button',
                text: '发送',
                name: 'fk',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    btn.setDisabled(true);
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length == 0) {
                        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
                        btn.setDisabled(false);
                        return;
                    }
                    for(var i=0;i<records.length;i++){
                        if(isNull(records[i].get("OP_CONTENT"))){
                            Ext.MessageBox.alert('提示', '项目名称：'+records[i].get("XM_NAME")+' 还未录入反馈意见，请录入反馈意见后再次发送！');
                            btn.setDisabled(false);
                            return;
                        }
                    }
                    Ext.MessageBox.show({
                        title: "提示",
                        msg: "是否确认发送？",
                        width: 200,
                        buttons: Ext.MessageBox.OKCANCEL,
                        fn: function (btn_ok, text) {
                            audit_info = text;
                            if (btn_ok == "ok") {
                                next(btn);
                            }else{
                                btn.setDisabled(false);
                            }
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

/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    /**
     * 主表格表头
     */
    var headerJson = [
        {"dataIndex": "AG_ID", "type": "string", "text": "单位ID", "hidden": true},
        {"dataIndex": "XM_ID", "type": "string", "text": "项目ID", "hidden": true},
        {"dataIndex": "ZGXX_ID", "type": "string", "text": "项目整改id", "hidden": true},
        {"dataIndex": "AD_CODE", "type": "string", "text": "区划编码", "hidden": true},
        {"dataIndex": "AD_NAME", "type": "string", "text": "区划名称", "width": 180},
        {"dataIndex": "AG_CODE", "type": "string", "text": "单位编码", "hidden": true},
        {"dataIndex": "AG_NAME", "type": "string", "text": "单位名称", "width": 180},
        {
            "dataIndex": "XM_CODE",
            "type": "string",
            "width": 250,
            "text": "项目编码",
            "hrefType": "combo",
            "hidden": true
        },
        {
            "dataIndex": "XM_NAME",
            "type": "string",
            "text": "项目名称",
            "fontSize": "15px",
            "width": 250,
            renderer: function (data, cell, record) {
                var url = '/page/debt/common/xmyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                paramNames[1]='IS_RZXM';

                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));
                var result = '<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {"dataIndex": "XF_CONTENT", "type": "string", "text": "整改意见", "width": 200},
        {"dataIndex": "OP_CONTENT", "type": "string", "width": 200, "hidden": true},
        {"dataIndex": "HOLD1", "type": "string", "text": "整改意见来源", "width": 200,
            renderer: function (value) {
                var store = DebtEleStore(json_debt_zgyjly);
                var record = store.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {"dataIndex": "LX_YEAR", "type": "string", "text": "立项年度", "width": 200},
        {"dataIndex": "XMLX_NAME", "type": "string", "text": "项目类型", "width": 200},
        {"dataIndex": "JSZT_NAME", "type": "string", "text": "建设状态", "width": 200},
        {"dataIndex": "XMZGS_AMT", "width": 200, "type": "float", "align": 'right', "text": "项目总概算金额(万元)",summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        }
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'contentGrid',
        border: false,
        flex: 1,
        layout: 'fit',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        checkBox: true,
        pageConfig: {
            pageNum: true,//设置显示每页条数
            pageSize: 20// 每页显示数据数
        },
        listeners:{
            itemclick: function (self, record) {
                //刷新明细表
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['id'] = record.get('ZGXX_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().getProxy().extraParams['ZGXX_ID'] = record.get('ZGXX_ID');
                DSYGrid.getGrid('contentGrid_detail').getStore().loadPage(1);
            }
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                name: 'WF_STATUS',
                store: DebtEleStore(json_debt_fkzt),
                width: 150,
                labelWidth: 30,
                labelAlign: 'right',
                displayField: "name",
                valueField: "code",
                editable:false,
                allowBlank:false,
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(xmzg_json_common[node_type].items[WF_STATUS]);
                        //刷新当前表格
                        if (AD_CODE == null || AD_CODE == '') {
                            return;
                        }
                        reloadGrid();
                    }
                }
            },
            {
                xtype: 'treecombobox',
                fieldLabel: '项目类型',
                name: 'XMLX_ID',
                displayField: 'name',
                valueField: 'id',
                width: 250,
                labelWidth: 60,
                lines: false,
                editable: false, // 禁用编辑
                allowBlank: true, //允许为空
                store: DebtEleTreeStoreDBTable("DSY_V_ELE_JXZBK_ZWXMLX"),
                listeners: {
                    change: function (self, newValue) {
                        //刷新当前表格
                        reloadGrid();
                    }
                }
            },
            {
                xtype: 'combobox',
                fieldLabel: '意见来源',
                name: 'HOLD1',
                displayField: 'name',
                valueField: 'id',
                width: 250,
                labelWidth: 60,
                lines: false,
                editable: false, // 禁用编辑
                store: DebtEleStore(json_debt_zgyjly),
                listeners: {
                    change: function (self, newValue) {
                        //刷新当前表格
                        reloadGrid();
                    }
                }
            },
            {
                xtype: "textfield",
                labelWidth: 60,
                fieldLabel: '模糊查询',
                name: 'mhcx',
                id: 'mhcx',
                emptyText: '请输入项目编码/项目名称',
                enableKeyEvents: true,
                listeners: {
                    'specialkey': function (self, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var content = self.getValue();
                            INDCODEORNAME = content;
                            reloadGrid();
                        }
                    }
                }
            }
        ],
        params: {
            WF_STATUS: WF_STATUS,
            AG_CODE: AG_CODE?AG_CODE:AGCODE,
            AD_CODE: AD_CODE
        },
        dataUrl: '/xmzg/getXmzgGrid.action'
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}

function initWin_xmzgWindow(XM_ID, AG_ID, b_btn, ZGXX_ID) {
    var buttons = [
        {
            text: '保存',
            handler: function (btn) {
                saveInfo(btn, b_btn, XM_ID, ZGXX_ID);
            }
        },
        {
            text: '关闭',
            handler: function (btn) {
                b_btn.setDisabled(false);
                btn.up('window').close();
            }
        }
    ];
    var xmzgWindow = new Ext.Window({
        title: "反馈意见",
        name: 'xmzgWin',
        itemId: 'xmzgWin',
        width: document.body.clientWidth * 0.85, // 窗口宽度
        height: document.body.clientHeight * 0.85, // 窗口高度
        maximizable: true,//最大化按钮
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        layout: 'fit',
        items: [initWin_xmzgTabPanel(XM_ID, ZGXX_ID)],
        buttons: buttons,
        closeAction: 'destroy',
        listeners: {
            'close': function () {
                reloadGrid();
            }
        }
    });
    xmzgWindow.show();
    var object = new Object();
    var array = new Array();
    array.push("xmzgForm");
    object['form'] = array;
    UI_Draw("ui_draw", object, null);
}

/**
 * 项目整改弹出窗口
 */
function initWin_xmzgTabPanel(XM_ID, ZGXX_ID) {
    return Ext.create('Ext.panel.Panel', {
        name: 'xmzgPanel',
        //scrollable:true,
        layout:'vbox',
        defaults: {
            margin: '10 10 10 10'
        },
        border:false,
        autoScroll: true,
        items: [
            initWin_xmzgTabPanel_form(),
            initWin_xmzgTabPanel_Fj()

        ]
    });
}

/**
 * 加载页面数据
 * @param form
 */
function loadZgxx(XM_ID, button_name, ZGXX_ID) {
    var form = Ext.ComponentQuery.query('form[name="xmzgForm"]')[0];
    //化债计划下列表赋值
    $.post("/xmzg/loadXmzg.action", {
        ZGXX_ID: ZGXX_ID
    }, function (data) {
        if (!data.success) {
            Ext.MessageBox.alert('提示', '查询' + '失败！' + data.message);
            return;
        }
        form.getForm().setValues(data.list);
        AG_ID = data.list.AG_ID;
    }, "json");
}

function initWin_xmzgTabPanel_form() {
    var editPanel = Ext.create('Ext.form.Panel', {
        width: '100%',
        layout: 'column',
        border: false,
        //flex : 1,
        defaultType: 'textfield',
        itemId: 'xmzgForm',
        name: 'xmzgForm',
        defaults: {
            margin: '10 10 10 10',
            columnWidth: .5,
            labelWidth: 125//控件默认标签宽度
        },
        items: [
            {
                fieldLabel: '区划名称',
                xtype: "textfield",
                name: "AD_NAME",
                editable: false,
                fieldCls: 'form-unedit'
            },
            {
                xtype: "textfield",
                name: "AD_CODE",
                hidden: true
            },
            {
                xtype: "textfield",
                name: "AG_CODE",
                hidden: true
            },
            {
                xtype: "textfield",
                name: "AG_ID",
                hidden: true
            },
            {
                fieldLabel: '单位名称',
                xtype: "textfield",
                name: "AG_NAME",
                editable: false,
                fieldCls: 'form-unedit'
            },
            {
                fieldLabel: '项目编码',
                xtype: "textfield",
                name: "XM_CODE",
                editable: false,
                fieldCls: 'form-unedit'
            },
            {
                fieldLabel: '项目名称',
                xtype: "textfield",
                name: "XM_NAME",
                editable: false,
                fieldCls: 'form-unedit'
            },
            {
                xtype:'combobox',
                fieldLabel: '整改意见来源',
                name:'HOLD1',
                displayField:'name',
                valueField:'code',
                readOnly: true, // 只读
                fieldStyle: 'background:#E6E6E6', // 置灰
                store:DebtEleStore(json_debt_zgyjly)
            },
            {
                xtype: "textarea",
                fieldLabel: '整改意见',
                name: "OP_ZGYJ",
                columnWidth: .99,
                multiline: true,
                readOnly: true, // 只读
                fieldStyle: 'background:#E6E6E6' // 置灰
            },
            {
                xtype: "textarea",
                fieldLabel: '<span class="required">✶</span>整改结果反馈',
                name: "OP_CONTENT",
                columnWidth: .99,
                multiline: true,
                allowBlank: false,
                emptyText: '请填写整改结果反馈意见',
                maxLength:500,//限制输入字数
                maxLengthText:"输入内容过长，最多只能输入500个字符！"
            }
        ],
        listeners: {
            'beforeRender': function () {
                //SetItemReadOnly(this.items);
                if (node_type == 'typing' && (WF_STATUS == "001" || WF_STATUS == "004")) {
                    /*var ZWQX_ID = Ext.ComponentQuery.query('textfield[name="ZWQX_ID"]')[0];
                    ZWQX_ID.setReadOnly(false);
                    ZWQX_ID.editable = true;
                    ZWQX_ID.fieldCls = '';*/
                }
            }
        }
    });
    return editPanel;
}

/**
 * 项目整改发送
 */
function next(btn) {
    //获取被选中行数据(获得的是一个数据对象)
    var records = DSYGrid.getGrid('contentGrid').getSelection();
    var msg_success = '发送成功！';
    var msg_failure = '发送失败！';
    var basicInfoArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.ID = record.get("ZGXX_ID");
        array.AD = record.get("AD_CODE");
        basicInfoArray.push(array);
    });
    //发送ajax请求，修改节点信息
    $.post("/xmzg/doWorkFlowActionFk.action", {
        userCode: userCode,
        userName: userName,
        workflow_direction: btn.name,
        basicInfoArray: Ext.util.JSON.encode(basicInfoArray),
        AD_CODE:AD_CODE,
        AG_CODE:AG_CODE?AG_CODE:AGCODE
    }, function (data) {
        if (data.success) {
            btn.setDisabled(false);
            Ext.toast({
                html: "发送成功！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            //操作日志
            saveLog('项目整改发送', 'BUTTON', '项目整改' + msg_success, '0');
        } else {
            btn.setDisabled(false);
            Ext.MessageBox.alert('提示', msg_failure + data.message);
        }
        //刷新表格
        reloadGrid();
    }, "json");
}

/**
 * 项目整改撤销发送
 */
function back(btn) {
    var msg_name = '撤销发送';
    audit_info = '';
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel()
        .getSelection();
    var basicInfoArray = [];
    Ext.each(records, function (record) {
        var array = {};
        array.ID = record.get("ZGXX_ID");
        array.AD = record.get("AD_CODE");
        basicInfoArray.push(array);
    });

    //发送ajax请求，修改节点信息
    $.post("/xmzg/doWorkFlowActionFk.action", {
        userCode: userCode,
        userName: userName,
        workflow_direction: btn.name,
        basicInfoArray: Ext.util.JSON.encode(basicInfoArray),
        AD_CODE:AD_CODE,
        AG_CODE:AG_CODE?AG_CODE:AGCODE
    }, function (data) {
        if (data.success) {
            btn.setDisabled(false);
            Ext.toast({
                html: msg_name + "成功！",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            //操作日志
            saveLog('项目整改' + msg_name, 'BUTTON', '项目整改' + msg_name + '成功', '0');
        } else {
            btn.setDisabled(false);
            Ext.MessageBox.alert('提示', msg_name + '失败！' + data.message);
        }
        //刷新表格
        reloadGrid();
    }, "json");
}

function saveInfo(btn, b_btn, XM_ID, ZGXX_ID) {
    var form = Ext.ComponentQuery.query('form[name="xmzgForm"]')[0];
    var OP_CONTENT = form.getForm().findField('OP_CONTENT').value;
    var result = CheckItemEmpty(form.items, null);
    if(getStringLength(OP_CONTENT)>500){
        result = result + '反馈意见过长，最多只能输入250个汉字！';
    }
    if (result == '') {
        url = '/xmzg/saveInfo.action';
        btn.setDisabled(true);
        form.submit({
            url: url,
            params: {
                WF_STATUS: WF_STATUS,
                button_name: b_btn.name,
                userCode: userCode,
                XM_ID: XM_ID,
                ZGXX_ID: ZGXX_ID
            },
            waitTitle: '请等待',
            waitMsg: '正在保存中...',
            success: function (form, action) {
                //提示保存成功
                Ext.toast({
                    html: "<center>保存成功!</center>",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                b_btn.setDisabled(false);
                btn.setDisabled(false);
                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                DSYGrid.getGrid("contentGrid_detail").getStore().removeAll();
                Ext.ComponentQuery.query('window[name="xmzgWin"]')[0].close();
            },
            failure: function (form, action) {
                b_btn.setDisabled(false);
                btn.setDisabled(false);
                var result = Ext.util.JSON.decode(action.response.responseText);
                Ext.Msg.alert('提示', "保存失败！" + result ? result.message : '无返回响应');
                DSYGrid.getGrid("contentGrid").getStore().loadPage(1);
                DSYGrid.getGrid("contentGrid_detail").getStore().removeAll();
                Ext.ComponentQuery.query('window[name="xmzgWin"]')[0].close();
            }
        });
    } else {
        b_btn.setDisabled(false);
        btn.setDisabled(false);
        Ext.Msg.alert('提示', result);
    }
}

/**
 * 初始化项目整改中页签panel的附件页签
 */
function initWin_xmzgTabPanel_Fj() {
    return UploadPanel.createGrid({
        busiType: 'ETHZGL',//业务类型
        busiId: ZGXX_ID,//业务ID
        busiProperty: '%',//业务规则，默认为‘%’
        editable: true,//是否可以修改附件内容，默认为ture
        //flex : 1,
        gridConfig: {
            width:'100%',
            minHeight:157,
            flex:1,
            itemId: 'window_zwdjtb_contentForm_tab_upload_grid_fj'//若无，会自动生成，建议填写，特别是出现多个附件上传时
        }
    });
}