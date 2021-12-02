Ext.define('ZQModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id', mapping: 'ZQ_ID'},
        {name: 'name', mapping: 'ZQ_NAME'}
    ]
});
var ZC_TYPE = getQueryParam("ZC_TYPE");//支出类型：0新增债券类型 1置换债券类型
var button_name = '';//当前操作按钮名称
var button_status = '';//当前操作按钮的name，标识按钮状态
var zqNameStore = getZqNameStore();
var busiType = '';// 附件类型
var bl_type = getQueryParam("bl_type");// 补录类型
if(typeof bl_type == 'undefined' || null==bl_type){
    bl_type = '0';
}
if(bl_type == 'sjzc'){// 新增债券实际支出补录
    busiType = '';
}else{
    busiType = 'ET205';
}
var GxdzUrlParam=getQueryParam("GxdzUrlParam");//地方个性参数，这里用于湖北的附件补录隐藏删除按钮

/**
 * 获取系统参数:
 * 选择债券后，根据系统参数判断是否需要按照发行计划控制，
 * 如果控制，则查询所选债券的发行批次对应是否有发行计划，如果有，则后面的选择项目对话框中的项目应该是该批次发行计划中包含的项目明细；
 * 如果不控制或没有发行计划，则可选非首轮项目申报中已经由省级审批通过的所有项目
 */
var DEBT_CONN_ZQXM = 1;//默认控制
$.post("getParamValueAll.action", function (data) {
    DEBT_CONN_ZQXM = parseInt(data[0].DEBT_CONN_ZQXM_XZ);
},"json");

/**
 * 获取债券名称
 */
function getZqNameStore() {
    var zqNameDataStore = Ext.create('Ext.data.Store', {
        model: 'ZQModel',
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: "/getZqNameData.action",
            reader: {
                type: 'json'
            },
            extraParams: {
                ZC_TYPE: ZC_TYPE
            }
        },
        autoLoad: true
    });
    return zqNameDataStore;
}

/**
 * 通用配置json
 */
var json_common = {
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
            }
        ]
    }
};

/**
 * 操作记录
 */
function oprationRecord() {
    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
    if (records.length == 0) {
        Ext.MessageBox.alert('提示', '请选择一条记录！');
    } else if (records.length > 1) {
        Ext.MessageBox.alert('提示', '不能同时查看多条操作记录！');
    } else {
        var id = records[0].get("ZCD_ID");
        fuc_getWorkFlowLog(id);
    }
}

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
                items: Ext.Array.union(json_common.items['001'], json_common.items['common'])
            }
        ],
        items: [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: 0//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                },
                items_tree: json_common.items_content_tree
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
            align: 'stretch'
        },
        defaults:{
            flex: 1,
            width: '100%'
        },
        border: false,
        dockedItems: json_common.items_content_rightPanel_dockedItems ? json_common.items_content_rightPanel_dockedItems : null,
        items: [
            initContentGrid(),
            //  initContentUploadPanel()
            initfjPanel()//重写的附件panel
        ]
    });
}

/**
 * 初始化主表格
 */
function initContentGrid() {
    if(bl_type == 'sjzc'){
        var headerJson = [
            {xtype: 'rownumberer', width: 45, dataIndex: "rownumberer"},
            {
                dataIndex: "SJZC_ID",
                type: "string",
                text: "ID",
                width: 80,
                hidden: true
            },
            {
                dataIndex: "SJZC_NO",

                type: "string",
                text: "支出单号",
                width: 150
            },
            {
                dataIndex: "AG_NAME",
                type: "string",
                text: "项目单位",
                width: 250
            },
            {
                dataIndex: "ZQ_NAME",
                type: "string",
                text: "债券名称",
                width: 300,
                renderer: function (data, cell, record) {
                    var url = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "ZQ_ID";
                    paramNames[1] = "AD_CODE";
                    var paramValues = new Array();
                    paramValues[0] = record.get('FIRST_ZQ_ID');
                    paramValues[1] = record.get('AD_CODE');
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {
                dataIndex: "XM_NAME",
                type: "string",
                text: "项目名称",
                width: 300,
                renderer: function (data, cell, record) {
                    var url = '/page/debt/common/xmyhs.jsp';
                    var paramNames = new Array();
                    paramNames[0] = "XM_ID";
                    paramNames[1] = 'IS_RZXM';

                    var paramValues = new Array();
                    paramValues[0] = encodeURIComponent(record.get('XM_ID'));
                    paramValues[1] = encodeURIComponent(record.get('IS_RZXM'));
                    var result = '<a href="#" onclick="urlCt(\'' + url + '\',\'' + paramNames + '\',\'' + paramValues + '\');" style="color:#3329ff;">' + data + '</a>';
                    return result;
                }
            },
            {
                dataIndex: "XMLX_NAME",
                type: "string",
                text: "项目分类",
                width: 150
            },
            {
                dataIndex: "SJZC_AMT", width: 200, type: "float", text: "本次支出金额（元）",
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                },
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00####');
                }
            },
            {
                dataIndex: "ZCZY",
                type: "string",
                text: "支出摘要",
                hidden: false,
                width: 200
            },
            {
                dataIndex: "REMARK",
                type: "string",
                text: "备注",
                width: 200
            }
        ];
    }else{
        var headerJson = [
            {xtype: 'rownumberer', width: 45},
            {text: "支出单ID", dataIndex: "ZCD_ID", type: "string", hidden: true},
            {text: "支出单编码", dataIndex: "ZCD_CODE", type: "string", width: 200},
            {text: "支出类型", dataIndex: "ZC_TYPE", type: "string", hidden: true},
            {text: "关联债券ID", dataIndex: "ZQ_ID", type: "string", hidden: true},
            {text: "所属区划", dataIndex: "AD_CODE", type: "string", hidden: true},
            {text: "所属区划", dataIndex: "AD_NAME", type: "string"},
            {text: "所属单位", dataIndex: "AG_ID", type: "string", hidden: true},
            {text: "所属单位编码", dataIndex: "AG_CODE", type: "string", hidden: true},
            {text: "所属单位", dataIndex: "AG_NAME", type: "string", width: 200},
            {
                text: "债券名称", dataIndex: "ZQ_NAME", type: "string", width: 200,
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
                }
            },
            {text: "支出总额(元)", dataIndex: "TOTAL_PAY_AMT", type: "float", width: 160},
            {text:"专项债用作资本金总额(元)", dataIndex:"TOTAL_ZX_ZBJ_AMT",type:"float",width:200},
            {text: "录入人", dataIndex: "ZCD_LR_USER_NAME", type: "string", width: 200},
            {text: "支出年度", dataIndex: "ZCD_YEAR", type: "string", hidden: true},
            {text: "备注", dataIndex: "ZCD_REMARK", type: "string"}
        ];
    }
    return DSYGrid.createGrid({
        itemId: 'contentGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        flex: 1,
        params: {
            ZC_TYPE: ZC_TYPE,
            SJLY: 0,
            BL_TYPE: bl_type
        },
        dataUrl: '/getFxdfZqzcBlGrid.action',
        checkBox: true,
        selModel:{mode: "SINGLE"},//单选
        border: false,
        autoLoad: false,
        height: '100%',
        tbar: tba,
        pageConfig: {
            pageNum: true//设置显示每页条数
        },
        listeners: {
            select :function( self , record , index , eOpts ){
                //业务id
                if(bl_type == 'sjzc'){
                    var busiId = record.get("SJZC_ID");
                }else{
                    var busiId = record.get("ZCD_ID");
                }
                //创建附件上传的panel
                initWindow_xmfj(busiId);
                var mainPanel = Ext.ComponentQuery.query('panel#winPanel_tabPanel')[0];
                /*mainPanel.removeAll(true);
                mainPanel.add(initWindow_xmfj({
                    editable: true,//是否可编辑
                    busiId: busiId//业务id
                }));*/
                DSYGrid.getGrid('fjckGrid').getStore().getProxy().extraParams['busi_id'] = busiId;
                DSYGrid.getGrid('fjckGrid').getStore().removeAll();
                DSYGrid.getGrid('fjckGrid').getStore().load();
                //加载表格
                //DSYGrid.getGrid('fjckGrid').getStore().load();

            },
           /* itemdblclick: function (self, record) {
                if(bl_type == 'sjzc'){
                    initWindow_xmfj({
                        SJZC_ID: record.get("SJZC_ID"),
                        editable: false
                    });
                }else{
                    initWindow_xmfj({
                        ZCD_ID: record.get("ZCD_ID"),
                        editable: false
                    });
                }
            }*/
        }
    });
}

if(bl_type == 'sjzc'){
    var tba = [
        {
            xtype: "textfield",
            fieldLabel: '模糊查询',
            name: 'MHCX',
            itemId: "MHCX",
            labelWidth: 80,
            width: 300,
            emptyText: '请输入项目名称/债券名称...',
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
    ];
}else{
    var tba = [
        {
            fieldLabel: '债券名称',
            name: 'ZQ_NAME',
            xtype: 'combobox',
            editable: false,
            displayField: 'name',
            valueField: 'id',
            store: zqNameStore,
            width: 250,
            labelWidth: 60,
            labelAlign: 'left'
        },
        {
            xtype: "treecombobox",
            name: "ZQLB_ID",
            store: DebtEleTreeStoreDB('DEBT_ZQLB'),
            displayField: "name",
            valueField: "id",
            fieldLabel: '债券类型',
            editable: false, //禁用编辑
            labelWidth: 60,
            width: 175,
            labelAlign: 'left',
            listeners: {
                change: function (self, newValue) {
                    if (!!self.up('window')) {
                        self.up('grid').getStore().getProxy().extraParams[self.getName()]=newValue;
                        reloadGrid();
                    }
                }
            }
        }
    ];
}

/*function initContentUploadPanel(){
    return Ext.create('Ext.form.Panel', {
        id:'upPanel',
        layout: 'fit',
        border:false,
        items: []
    });
}*/

/**
 * 树点击节点时触发，刷新content主表格
 */
function reloadGrid(param) {
    var grid = DSYGrid.getGrid('contentGrid');
    if(bl_type == 'sjzc'){
        var MHCX = Ext.ComponentQuery.query('textfield[name="MHCX"]')[0].getValue();
        var store = grid.getStore();
        //增加查询参数
        if (AD_CODE == '' || AD_CODE == null) {
            AD_CODE = USER_AD_CODE;
        }
        if (AG_CODE == '' || AG_CODE == null) {
            AG_CODE = USER_AG_CODE;
        }
        store.getProxy().extraParams["AD_CODE"] = AD_CODE;
        store.getProxy().extraParams["AG_CODE"] = AG_CODE;
        store.getProxy().extraParams["MHCX"] = MHCX;
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
    }else{
        var ZQ_ID = Ext.ComponentQuery.query('combobox[name="ZQ_NAME"]')[0].getValue();
        var ZQLB_ID = Ext.ComponentQuery.query('treecombobox[name="ZQLB_ID"]')[0].getValue();
        var store = grid.getStore();
        store.getProxy().extraParams['ZQ_ID'] = ZQ_ID;
        //增加查询参数
        if (AD_CODE == '' || AD_CODE == null) {
            AD_CODE = USER_AD_CODE;
        }
        if (AG_CODE == '' || AG_CODE == null) {
            AG_CODE = USER_AG_CODE;
        }
        store.getProxy().extraParams["AD_CODE"] = AD_CODE;
        store.getProxy().extraParams["AG_CODE"] = AG_CODE;
        store.getProxy().extraParams["ZQLB_ID"] = ZQLB_ID;
        if (typeof param != 'undefined' && param != null) {
            for (var name in param) {
                store.getProxy().extraParams[name] = param[name];
            }
        }
    }
    //刷新
    store.loadPage(1);
}
/**
 * 初始化附件PANEL 重写附件上传panel
 * @returns {Ext.form.Panel}
 */
function initfjPanel(){
    return Ext.create('Ext.panel.Panel', {
        name: 'winPanel',
        itemId: "winPanel",
        border: false,
        layout: {
            type: 'vbox',
            align: 'stretch'
        },
        flex: 1,
        autoLoad: true,
        height: '50%',
        items: [
            {
                xtype: 'tabpanel',
                border: false,
                flex: 1,
                items: [

                    {
                        title: '附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                        layout: 'fit',
                        items: [
                            {
                                xtype: 'panel',
                                layout: 'fit',
                                itemId: 'winPanel_tabPanel',
                                items: [initWindow_xmfj('')]
                            }
                        ]
                    }
                ]
            }
        ]
    });
}
/**
 * 项目附件显示
 * @param busiId
 * @param fjlist
 */
function initWindow_xmfj(busiId) {
    var grid = UploadPanel.createGrid({
        busiType:busiType ,//业务类型
        busiId: busiId,//业务ID
        editable: true,//是否可以修改附件内容
        gridConfig: {
            itemId: 'fjckGrid'
        }
    });
    grid.columns[0].renderer = function (value, cell, record, rowIndex, colIndex, store, view) {
        //上传提示信息
        var tipText = '小于' + record.data.MAXLIMIT / 1024 + 'MB';
        var tip = record.data.FILE_SUFFIX + tipText;
        //上传按钮，上层覆盖透明上传表单
        var uploadbtn = '<div title="' + tip + '" class="uploadpanel-btn uploadpanel-btn-upload">' +
            '<form id="uploadpanel-' + view.grid.itemId + '-uploadform-' + rowIndex + '" class="uploadForm" enctype="multipart/form-data">' +
            '<input type="submit" />' +
            '<input type="text" name="rule_id" value=""/>' +
            '<input type="text" name="busi_id" value=""/>' +
            '<input type="text" name="maxlimit" value=""/>' +
            '<input type="file" name="upload" itemId="' + view.grid.itemId + '" rowIndex="' + rowIndex + '" onchange="UploadPanel.uploadFile(this)"/>' +
            '</form></div>';
        var downloadbtn = '<div class="uploadpanel-btn uploadpanel-btn-download" onclick="UploadPanel.downloadFile(\'' + record.get("FILE_ID") + '\')"></div>';
        var deletebtn = '<div class="uploadpanel-btn uploadpanel-btn-delete" onclick="UploadPanel.deleteFile(\'' + record.get("FILE_ID") + '\',\'' + record.get("RULE_ID") + '\',\'' + record.get("FILE_NAME") + '\',\'' + view.grid.itemId + '\',\'' + rowIndex + '\')"></div>';
        //控制文件权限(如果是湖北则隐藏删除按钮)
       if(GxdzUrlParam=='42'){
           deletebtn = '';
       }
        var preview = ''; // 预览按钮
        //如果文件存在，隐藏上传按钮
        var fileId = record.data.FILE_ID;
        if (typeof fileId != 'undefined' && fileId != null && fileId != '') {
            uploadbtn = ''; // 存在隐藏上传按钮
            var form = record.data.FILE_NAME.split(".")[record.data.FILE_NAME.split(".").length - 1];
            if(form == 'pdf' || form == 'docx' || form == "doc"){
                preview = '<div title="预览" class="uploadpanel-btn uploadpanel-btn-preview" onclick="pdfPreviewFile(\'' + fileId + '\',\'' + form + '\')"></div>';
            }
        }else{ //根据文件id是否存在，隐藏下载按钮
            downloadbtn = ''; // 不存在，隐藏下载按钮
        }
        return '<div class="uploadpanel-btsn">' + uploadbtn + downloadbtn + deletebtn + preview + '</div>';
    };
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
        if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}