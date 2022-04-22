//评分等级
var json_debt_pfdj = [
    {"id": "1", "code": "1", "name": "优"},
    {"id": "2", "code": "2", "name": "良"},
    {"id": "3", "code": "3", "name": "中"},
    {"id": "4", "code": "4", "name": "差"}
];

var jxzp_id;
var MOF_TYPE;
var button_text;
// 绘制绩效自评查看panel
if (!!document) {
    document.write("<script type='text/javascript' src='/page/debt/jxgl/jxpjgl/jxzp/jxzptbPanel.js'></script>");
    document.write("<script type='text/javascript' src='/page/debt/jxgl/jxpjgl/zdjxpj/zdjxpjtbPanel.js'></script>");
}

/**
 * 初始化债券信息填报弹出窗口中的绩效评价标签页
 * @param XM_ID
 * @return {Ext.form.Panel}
 */
function initWin_xmInfo_contentForm_tab_jxpj_common(XM_ID) {
    return Ext.create('Ext.form.Panel', {
        name: 'jxpjForm_common',
        itemId: 'jxpjForm_common',
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
                anchor: '100% -80',
                layout: 'anchor',
                defaults: {
                    anchor: '-10 -10'

                },
                style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
                items: [initWin_xmInfo_contentForm_tab_jxpj_grid(XM_ID)]
            }
        ]
    });
}

/**
 * 初始化绩效评价报告查看附件信息页签
 * @param ID
 * @param RW_TYPE
 */
function initWin_jxpjbg_fjxx(ID, RW_TYPE) {
    var jxpjbg_fj_Window = new Ext.Window({
        title: RW_TYPE == 0 ? '地市财政绩效评价报告上传' : '省级财政绩效评价报告上传',
        itemId: 'jxpjbg_fj_Window',
        width: document.body.clientWidth * 0.75,
        height: document.body.clientHeight * 0.75,
        maximizable: true,//最大化按钮
        buttonAlign: "right", // 按钮显示的位置
        modal: true,
        resizable: true,//大小不可改变
        closeAction: 'destroy',
        layout: 'fit',
        items: [
            Ext.create('Ext.form.Panel', {
                width: '100%',
                height: '100%',
                layout: 'anchor',
                border: false,
                itemId: 'xmInfo_top_pjbgscForm_fjxx',
                name: 'xmInfo_top_pjbgscForm_fjxx',
                defaults: {
                    width: '100%',
                    margin: '0 0 2 0'
                },
                items: [
                    {
                        xtype: 'container',
                        layout: 'column',
                        anchor: '100%',
                        defaults: {
                            margin: '3 5 3 5',
                            labelAlign: 'right',
                            labelWidth: 80
                        },
                        items: [
                            {
                                xtype: 'displayfield',
                                name: 'XM_CODE_FJXX',
                                fieldLabel: '<span class="displayfield">项目编码</span>',
                                value: '',
                                columnWidth: '0.3'
                            },
                            {
                                xtype: 'displayfield',
                                name: 'XM_NAME_FJXX',
                                fieldLabel: '<span class="displayfield">项目名称</span>',
                                value: '',
                                columnWidth: '0.4'
                            },
                            {
                                xtype: 'displayfield',
                                name: 'XMLX_NAME_FJXX',
                                fieldLabel: '<span class="displayfield">项目类型</span>',
                                value: '',
                                columnWidth: '0.2'
                            }
                        ]
                    }, {
                        xtype: 'tabpanel',
                        anchor: '100% 100%',
                        itemId: 'jxpjbg_tab_panel_fjxx',
                        border: false,
                        items: [
                            {
                                title: '绩效评价附件<span class="file_sum" style="color: #FF0000;">(0)</span>',
                                layout: 'fit',
                                name: 'jxpjbg_panel_fjxx',
                                itemId: 'jxpjbg_panel_fjxx',
                                items: [
                                    {
                                        xtype: 'panel',
                                        layout: 'fit',
                                        itemId: 'inner_panel_fjxx',
                                        items: [initWin_xmInfo_xmbgscfj_fjxx(ID, RW_TYPE)]
                                    }
                                ]
                            }
                        ],
                        listeners: {
                            render: function () {
                                var pjbgscForm = Ext.ComponentQuery.query('form[name="xmInfo_top_pjbgscForm_fjxx"]')[0];
                                setTimeout(function () {
                                    var fj_records = DSYGrid.getGrid('jxpjGrid_common').getCurrentRecord().data;
                                    if (fj_records) {
                                        pjbgscForm.getForm().findField('XM_NAME_FJXX').setValue(fj_records.XM_NAME);
                                        pjbgscForm.getForm().findField('XM_CODE_FJXX').setValue(fj_records.XM_CODE);
                                        pjbgscForm.getForm().findField('XMLX_NAME_FJXX').setValue(fj_records.XMLX_NAME);
                                    }
                                }, 500)
                            }
                        }
                    }
                ]
            })
        ],
    });
    jxpjbg_fj_Window.show();
}

/**
 * 初始化债券信息填报弹出窗口中的绩效评价标签页中的表格
 */
function initWin_xmInfo_contentForm_tab_jxpj_grid(XM_ID) {
    var headerJson = [
        {dataIndex: "ID", type: "string", text: "唯一ID", hidden: true},
        {dataIndex: "SET_YEAR", type: "string", text: "年度", align: 'center'},
        {dataIndex: "PRO_ID", type: "string", text: "项目ID", align: 'center', hidden: true},
        {dataIndex: "MOF_TYPE", type: "string", text: "评价结果查看类型", align: 'center', hidden: true},
        {dataIndex: "XMPJ_TYPE", type: "string", text: "项目评价类型", align: 'center'},
        {
            dataIndex: "PJJG_CK", type: "string", text: "评价结果查看", align: 'center',
            renderer: function (data, cell, record) {
                var result;
                var linkParam = '';
                if (data == "查看") {
                    if (record.data.MOF_TYPE == 4) {
                        result = '<a href="javascript:void(0);" onclick="initWin_jxzpWindow(\'' + record.get('PRO_ID') + '\',\'' + linkParam + '\',\'' + record.get('ID') + '\')">' + data + '</a>';
                    } else {
                        var params = {
                            "MOF_DIV_CODE": record.data.MOF_DIV_CODE,
                            "XMLX_ID": record.data.XMLX_ID,
                            "YHS": ''
                        };
                        result = '<a href="javascript:void(0);" onclick="initWin_zdjxpjWindow(\'' + record.get('PRO_ID') + '\',\'' + linkParam + '\',\'' + record.get('ID') + '\',\'' + params + '\',\'' + record.get('MOF_TYPE') + '\')">' + data + '</a>';
                    }
                    return result;
                } else {
                    result = data;
                }
                return result;
            }

        }
        // ,
        // {
        //     dataIndex: "DZFJ",
        //     type: "string",
        //     text: "电子附件",
        //     align: 'center',
        //     renderer: function (data, cell, record) {
        //         var result;
        //         if (data == "查看") {
        //             var result = '<a href="javascript:void(0);" onclick="initWin_jxpjbg_fjxx(\'' + record.get('ID') + '\',\'' + record.get('RW_TYPE') + '\')">' + data + '</a>';
        //             return result;
        //         } else {
        //             result = data;
        //         }
        //         return result;
        //     }
        // }
    ];


    var jxpjGrid = new DSYGridV2();
    return jxpjGrid.create({
        itemId: 'jxpjGrid_common',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        forceFit: true,
        checkBox: false,
        border: false,
        flex: 1,
        params: {
            XM_ID: XM_ID
        },
        dataUrl: '/zdjxpj/getJxpjGrid.action',
        pageConfig: {
            enablePage: false
        }
    });
}

/**
 * 绩效评价附件tab
 * @param ywsjid
 * @param RW_TYPE
 */
function initWin_xmInfo_xmbgscfj_fjxx(ywsjid, RW_TYPE) {
    var grid = UploadPanel.createGrid({
        busiType: RW_TYPE == 0 ? 'JXPJ_DS' : 'JXPJ_SJ',//业务类型
        busiId: ywsjid,//业务ID
        busiProperty: '%',//业务规则
        // ruleIds:'',//附件规则id
        addHeaders: [
            {text: '备注', dataIndex: 'REMARK', type: 'string', editor: 'textfield', width: 280}
        ],
        // addfileable: true,//是否可对附件进行新增行操作
        editable: false,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_xmxx_contentForm_tab_jxfjbgsc_grid_fjxx'
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
        if (grid.up('tabpanel') && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
        } else {
            $('span.file_sum').html('(' + sum + ')');
        }
    });
    return grid;
}

/**
 * 设置绩效评价页签
 * @param dataJson
 * @param xm_id
 */
function setJxpjxx(dataJson, xm_id) {
    //加载绩效评价页签表单
    var jxpjForm = Ext.ComponentQuery.query('form[itemId="jxpjForm_common"]')[0];
    jxpjForm.getForm().setValues(dataJson.data.jxpjForm);
    reloadJxpjxxGrid(xm_id);
}

/**
 * 刷新绩效评价表格
 * @param xm_id
 */
function reloadJxpjxxGrid(xm_id) {
    var grid = DSYGrid.getGrid('jxpjGrid_common');
    var store = grid.getStore();
    //增加查询参数
    store.getProxy().extraParams["XM_ID"] = xm_id;
    //刷新
    store.loadPage(1);
}