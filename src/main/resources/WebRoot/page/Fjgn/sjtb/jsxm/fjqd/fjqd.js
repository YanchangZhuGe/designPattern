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
 * 初始化主页面panel
 */
function initContent() {
    return Ext.create('Ext.panel.Panel', {
        layout: 'border',
        defaults: {
            split: true, //是否有分割线
            collapsible: false //是否可以折叠
        },
        height: '100%',
        renderTo: Ext.getBody(),
        border: false,
        items: [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: v_child //区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }), //左侧树
            initContentRightPanel()
        ]
    });
}

/**
 * 初始化主页面表格panel
 */
function initContentRightPanel() {
    return Ext.create('Ext.form.Panel', {
        region: 'center',
        height: '100%',
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        flex: 5,
        border: false,
        dockedItems: [
            {
                xtype: 'form',
                dock: 'top',
                layout: 'column',
                anchor: '100%',
                defaults: {
                    margin: '5 5 5 5',
                    labelWidth: 70, //控件默认标签宽度
                    labelAlign: 'left' //控件默认标签对齐方式
                },
                border: true,
                bodyStyle: 'border-width:0 0 0 0;',
                items: [
                    {
                        xtype: "combobox",
                        name: "YEAR",
                        store: DebtEleStoreDB('DEBT_YEAR', {condition: " and code >= '2009'"}),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '年度',
                        editable: false,
                        labelWidth: 40,
                        width: 180,
                        labelAlign: 'right',
                        listeners: {
                            'afterrender': function (t) {
                                t.getStore().filterBy(function (record) {
                                    return record.set('name', record.get('name').replace(record.get('code'), '').trim());
                                });
                                this.setValue(now_date.substring(0, 4));
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "MONTH",
                        store: DebtEleStore(json_debt_yf_nd),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '月份',
                        editable: false,
                        labelWidth: 40,
                        width: 180,
                        labelAlign: 'right',
                        listeners: {
                            'afterrender': function (t) {
                                this.setValue(now_date.substring(5, 7));
                            }
                        }
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '模糊查询',
                        itemId: "MHCX",
                        name: "MHCX",
                        labelWidth: 70,
                        width: 400,
                        labelAlign: 'right',
                        emptyText: '输入项目名称/项目编码',
                        enableKeyEvents: true,
                        listeners: {
                            'keydown': function (self, e, eOpts) {
                                var key = e.getKey();
                                if (key == Ext.EventObject.ENTER) {
                                    reloadGrid();
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '查询',
                        width: 80,
                        handler: function () {
                            reloadGrid();
                        }
                    }
                ]
            }
        ],
        items: [
            initContentGrid(),
            initFileGrid()
        ]
    });
}

/**
 * 初始化主页面项目表格
 */
function initContentGrid() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45
        },
        {dataIndex: "AD_CODE", type: "string", text: "区划编码", width: 90},
        {dataIndex: "AD_NAME", type: "string", text: "区划名称", width: 150},
        {dataIndex: "AG_NAME", type: "string", text: "项目单位名称", width: 250},
        {
            dataIndex: "XM_NAME", type: "string", text: "项目名称", width: 250,
            renderer: function (data, cell, record) {
                var url = '/page/debt/jsxm/jsxmYhsMain.jsp';
                var paramNames = new Array();
                paramNames[0] = "XM_ID";

                var paramValues = new Array();
                paramValues[0] = encodeURIComponent(record.get('XM_ID'));

                var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {dataIndex: "XM_CODE", type: "string", text: "项目编码", width: 250},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型", width: 150},
        {dataIndex: "JSZT_NAME", type: "string", text: "建设状态", width: 100}
    ];
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        border: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/xmgl/fjqd/getXmxxList.action',
        autoLoad: false,
        checkBox: false,
        flex: 1,
        pageConfig: {
            enablePage: true, //能否换页
            pageNum: true, //显示设置显示每页条数
            pageSize: 20 // 每页显示数据数
        },
        listeners: {
            itemclick: function (self, record, index, eOpts) {
                loadFileGrid(record.get('XM_ID'));
            }
        }
    });
}

/**
 * 初始化主页面附件清单表格
 */
function initFileGrid() {
    var headerJson = [
        {dataIndex: "RULE_DESCRIBE", type: "string", text: "附件描述", width: 250},
        {
            dataIndex: "FILE_NAME", type: "string", text: "文件名称", width: 330,
            renderer: function (data, cell, record) {
                var file_id = record.get('FILE_ID');
                var fileType = data.split(".")[data.split(".").length - 1];
                if (fileType == "dps" || fileType == "dpt" || fileType == "odp" || fileType == "otp" || fileType == "ofd") {
                    fileType = "pdf";
                } else if (fileType == "wps" || fileType == "wpt" || fileType == "odt" || fileType == "ott") {
                    fileType = "docx";
                } else if (fileType == "et" || fileType == "ett" || fileType == "ods" || fileType == "ots") {
                    fileType = "xlsx";
                }
                var image = '';
                if (fileType) {
                    image = '<image src="/image/file/' + fileType + '.png">&nbsp';
                }
                if (fileType == "png" || fileType == "jpg" || fileType == "jpeg") {
                    if (browserInfo["browser"] === "IE" && browserInfo["version"] === "8.0") {
                        image = "<image style='width:64px;height:64px;cursor:pointer;' onclick='imageClick(\"" + file_id + "\")' src='previewImage.action?file_id=" + file_id + "'/>";
                    } else {
                        image = "<image style='width:64px;height:64px;cursor:pointer;' data-original='previewReadyImage.action?file_id=" + file_id +
                            "' src='previewImage.action?file_id=" + file_id + "' onload='imageAfterLoad(this, \"" + file_id + "\")' alt='" + data + "' title='" + data + "'/>";
                    }
                }
                return image + '<a href="javascript:void(0);" style="color:#3329ff;" onclick="UploadPanel.downloadFile(\'' + file_id + '\')">' + data + '</a>';
            }
        },
        {
            dataIndex: "FILE_TYPE", type: "string", text: "附件类型", width: 150,
            renderer: function (data, cell, record) {
                var fileName = record.get('FILE_NAME');
                return fileName.split(".")[fileName.split(".").length - 1];
            }
        },
        {
            dataIndex: "FILE_SIZE", type: "float", text: "附件大小（KB）", width: 200, summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.##');
            }
        },
        {dataIndex: "UPLOAD_USER", type: "string", text: "上传人", width: 200},
        {dataIndex: "UPLOAD_TIME", type: "string", text: "上传时间", width: 150}
    ];
    return DSYGrid.createGrid({
        itemId: 'fileGrid',
        title: '附件清单（<span id="download-file-button" onclick="downloadAllFiles()">下载全部</span>）',
        border: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        autoLoad: false,
        checkBox: false,
        data: [],
        flex: 1,
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: false
        }
    });
}

/**
 * 根据项目ID加载附件表格
 */
function loadFileGrid(xmId) {
    if (!xmId) {
        return;
    }
    $.post("/xmgl/fjqd/getFileListByXmId.action", {
        XM_ID: xmId
    }, function (data) {
        if (data.success) {
            var fileGrid = DSYGrid.getGrid('fileGrid');
            fileGrid.getStore().removeAll();
            fileGrid.insertData(null, data.list);
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
    }, "json");
}

/**
 * 下载附件清单中的所有附件
 */
function downloadAllFiles() {
    var record = DSYGrid.getGrid('contentGrid').getCurrentRecord();
    if (!record) {
        Ext.MessageBox.alert('提示', '请选择项目信息');
        return false;
    }
    if (!record.get('XM_ID')) {
        Ext.MessageBox.alert('提示', '请选择项目信息');
        return false;
    }
    var fileGrid = DSYGrid.getGrid('fileGrid');
    if (fileGrid.getStore().getCount() == 0) {
        Ext.MessageBox.alert('提示', '无可下载的附件清单');
        return false;
    }
    var fileIds = [];
    var fileNames = [];
    fileGrid.getStore().each(function (record) {
        fileIds.push(record.get('FILE_ID'));
        fileNames.push(record.get('FILE_NAME'));
    });
    $.post("/xmgl/fjqd/existXmxxFile.action", {
        FILE_IDS: fileIds,
        FILE_NAMES: fileNames
    }, function (data) {
        if (data.success) {
            var paramNames = new Array();
            var paramValues = new Array();
            for (var i in fileIds) {
                paramNames[i] = "FILE_IDS";
                paramValues[i] = encodeURIComponent(fileIds[i]);
            }
            paramNames[paramNames.length] = "XM_NAME";
            paramValues[paramValues.length] = encodeURIComponent(record.get('XM_NAME'));
            post('/xmgl/fjqd/downloadAllFiles.action', paramNames, paramValues, '_self');
        } else {
            Ext.MessageBox.alert('提示', data.message);
        }
    }, "json");
}

/**
 * 刷新主表格
 */
function reloadGrid() {
    var year = Ext.ComponentQuery.query("combobox[name='YEAR']")[0].getValue();
    var month = Ext.ComponentQuery.query("combobox[name='MONTH']")[0].getValue();
    var mhcx = Ext.ComponentQuery.query("textfield[name='MHCX']")[0].getValue().trim();
    var store = DSYGrid.getGrid('contentGrid').getStore();
    store.getProxy().extraParams = {
        AD_CODE: AD_CODE,
        AG_CODE: AG_CODE,
        YEAR: year,
        MONTH: month,
        MHCX: mhcx
    };
    store.loadPage(1);
    DSYGrid.getGrid('fileGrid').getStore().removeAll();
}