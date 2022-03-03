/**
 * 初始化
 */
$(document).ready(function () {
    //显示提示，并form表单提示位置为表单项下方
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    initContent();
});

/**
 * 初始化页面区域
 */
function initContent() {
    Ext.create('Ext.panel.Panel', {
        layout: 'border',
        height: '100%',
        renderTo: 'contentPanel',
        border: false,
        tbar: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    var mhcx = Ext.ComponentQuery.query('textfield#contentGrid_search')[0].getValue();
                    DSYGrid.getGrid('grid').getStore().getProxy().extraParams['mhcx'] = mhcx;
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '录入',
                name: 'btn_insert',
                icon: '/image/sysbutton/regist.png',
                handler: function (btn) {
                    is_fix=false;
                    can_save=true;
                    var FXR_ID_temp="";
                    button_name = btn.text;
                    fxrWindow.show("发行人信息录入");
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'btn_update',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    is_fix=true;
                    can_save=true;
                    var FXR_ID_temp="";
                    button_name = btn.text;
                    fxr_update()
                }
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'btn_delete',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    fxr_delete()
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()],
        items: initContentTCGrid(),
        listeners: {
            load: function () {
                DSYGrid.getGrid("grid").getStore().loadPage(1);
            }
        }

    });
}

function initContentTCGrid() {
    var HeaderJson_hzbf = [
        {
            xtype: 'rownumberer',
            width: 35
        },
        {
            dataIndex: "FXR_ID",
            type: "string",
            hidden: true
        },
        {
            dataIndex: "FXR_CODE",
            type: "string",
            text: '编码',
            width: 170

        },
        {
            dataIndex: "FXR_NAME",
            type: "string",
            text: "联系人",
            width: 130

        },
        {
            dataIndex: "TEL_NUMBER",
            type: "string",
            text: "联系电话",
            width: 130

        },
        {
            dataIndex: "FAX_NUMBER",
            type: "string",
            text: "联系传真",
            width: 170
        },
        {
            dataIndex: "PZ_AMT",
            type: "string",
            text: "批准额度",
            width: 130,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.######');
            }
        }
    ]
    return DSYGrid.createGrid({
        itemId: 'grid',
        flex: 5,
        region: 'center',
        headerConfig: {
            headerJson: HeaderJson_hzbf,
            columnAutoWidth: false
        },
        tbar: [{
            xtype: "textfield",
            fieldLabel: '模糊查询',
            itemId: 'contentGrid_search',
            width: 300,
            columnWidth: .66,
            labelWidth: 60,
            labelAlign: 'right',
            emptyText: '请输入联系人／联系电话',
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
        ],
        checkBox: true,
        autoLoad: true,
        border: false,
        height: '100%',
        dataUrl: 'getFxrGrid.action',
        pageConfig: {
            pageNum: true,//设置显示每页条数
            pageSize: 20
        }
    })
}

function initContent1() {
    return Ext.create('Ext.form.Panel', {
        itemId: 'init-fxr-form',
        items: [
            {
                xtype: "displayfield",
                fieldLabel: '发行申请机构名称',
                name: "",
                labelWidth: 130,

            },
            {
                xtype: "textfield",
                name: 'FXR_CODE',
                fieldLabel: '编码',
                vtype: 'vTszf',
                labelWidth: 100,
            },
            {
                xtype: "textfield",
                fieldLabel: '联系人',
                name: "FXR_NAME",
                labelWidth: 100,
                vtype: 'vTszf'
            },
            {
                xtype: "textfield",
                fieldLabel: '联系人电话',
                name: "TEL_NUMBER",
                labelWidth: 100,
                vtype: 'vTszf'
            },
            {
                xtype: "textfield",
                fieldLabel: '联系传真',
                name: "FAX_NUMBER",
                labelWidth: 100,
            },
            {
                xtype: "textfield",
                name: "PZ_AMT",
                fieldLabel: '批准额度',
                labelWidth: 100,
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.######');
                },
            }
        ]
    })
}
var is_fix=false;
var fxrWindow = {
    window: null,
    show:
        function (title) {
            this.window = Ext.create('Ext.window.Window', {
                title: title,
                itemId: 'window_fxr', // 窗口标识
                width: document.body.clientWidth * 0.32, // 窗口宽度
                height: document.body.clientHeight * 0.45, // 窗口高度
                buttonAlign: 'right', // 按钮显示的位置
                closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是close，则会将window销毁。
                modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
                // maximizable: true,//最大化按钮
                autoLoad: false,
                border: false,
                items: init_fxr_form(),
                buttons: [
                    {
                        text: '保存',
                        handler: function (btn) {
                            var form = btn.up('window').down('form');
                            submitInfo(form)
                        }
                    },
                    {
                        text: '取消',
                        handler: function (btn) {
                            btn.up('window').close();
                        }
                    }
                ],
            });
            this.window.show();
            if(!is_fix){
                doVerfy();
            }
        }
}
//动态获取columnWidth
function init_fxr_form () {
    var form = initPanel_UI(null, 'DEBTZQGLPA001', 'init-fxr-form', null);
    var container = form.down('container#container_ui_draw').items.items;
    container[0].setMargin("25 0 0 0 ");
    for (var i = 0;i < container.length;i++) {
        if(i != 3){
            container[i].maxLength = 50;
        }
        container[i].columnWidth = .9;
    }
    return form;
}

function submitInfo(form) {
    if (button_name == "录入") {
        var parameters = {
            button_name: button_name
        }
    } else {
        var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
        var parameters = {
            button_name: button_name,
            FXR_ID: records[0].get('FXR_ID')
        }
    }
    if (form.isValid()) {
        if(can_save){
            form.submit({
                // 设置表单提交的url
                url: 'saveFxrGrid.action',
                params: parameters,
                waitTitle: '请等待',
                waitMsg: '正在加载中...',
                success: function (form, action) {
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '保存成功',
                        width: 200,
                        buttons: Ext.MessageBox.OK,
                        fn: function FXR_ID(btn) {
                            DSYGrid.getGrid("grid").getStore().loadPage(1);
                            Ext.ComponentQuery.query('window#window_fxr')[0].close();
                        }
                    });
                },
                failure: function (form, action) {
                    var msg = action.result.message;
                    Ext.Msg.alert('提示', "保存失败！" + msg);
                    //btn.setDisabled(false) ;
                }
            });
        }else{
            Ext.toast({
                html: "编码已存在，请重新输入",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });

        }

    }
}

var FXR_ID_temp="";
function fxr_update() {
    var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
    if (records.length != 1) {
        Ext.MessageBox.alert('提示', '请选择一条数据再进行操作');
        return;
    }
    FXR_ID_temp=records[0].get('FXR_ID');
    $.post("/getFxrById.action", {
        FXR_ID: records[0].get('FXR_ID')
    }, function (data) {
        if (!data.success) {
            Ext.MessageBox.alert('提示', button_name + '失败！' + data.message);
            return;
        }
        fxrWindow.show(data.data);
        var form = fxrWindow.window.down('form');
        form.getForm().setValues(data.data);
        doVerfy();
    }, "json");
}

function fxr_delete() {
    var records = DSYGrid.getGrid('grid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请至少选择一条记录！');
        return;
    }
    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            var basicInfoArray = [];
            Ext.each(records, function (record) {
                var array = {};
                array.FXR_CODE = record.get("FXR_CODE");
                basicInfoArray.push(array);
            });
            //向后台传递变更数据信息
            Ext.Ajax.request({
                method: 'POST',
                url: "deleteFxr.action",
                params: {
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
                            DSYGrid.getGrid('grid').getStore().loadPage(1);
                        }
                    });
                },
                failure: function (resp, opt) {
                    var result = Ext.util.JSON.decode(resp.responseText);
                    Ext.MessageBox.show({
                        title: '提示',
                        msg: '删除失败!' + result.message,
                        width: 200,
                        fn: function () {
                            DSYGrid.getGrid('grid').getStore().loadPage(1);
                        }
                    });
                }
            });
        }
    });
}

function reloadGrid(param, param_detail) {
    var fxrGrid = DSYGrid.getGrid('grid');
    var fxrStore = fxrGrid.getStore();
    if (typeof param != 'undefined' && param != null) {
        for (var name in param) {
            store.getProxy().extraParams[name] = param[name];
        }
    }
    var mhcx = Ext.ComponentQuery.query('textfield#contentGrid_search')[0].getValue();
    fxrStore.getProxy().extraParams['mhcx'] = mhcx;
    DSYGrid.getGrid('grid').getStore().loadPage(1);
}

var can_save=true;

function doVerfy() {
    var form_input = Ext.ComponentQuery.query('form[itemId="init-fxr-form"]')[0];
    var form_dtl = form_input.getForm();
    form_dtl.findField("FXR_CODE").on({
        change: {
            fn: function () {
                var code = Ext.ComponentQuery.query('textfield[name="FXR_CODE"]')[0].value;
                var id = FXR_ID_temp;
                $.ajax({
                    url: "/doVerify.action",//后台查询验证的方法
                    data: {"fxr_code": code,"fxr_id":id},//携带的参数
                    type: "post",
                    async: false,
                    success: function (data) {
                        var jsonData = Ext.util.JSON.decode(data);
                        can_save=!jsonData.success;
                        if (jsonData.success) {
                            Ext.toast({
                                html: "编码已存在，请重新输入",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                        }
                    }
                });
            }
        }, scope: this, single: false
    });
}