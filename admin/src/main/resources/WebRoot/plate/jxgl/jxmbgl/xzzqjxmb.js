var dldwDatas = [];
$.get("/jxmbtb/getAllDldw.action", function (data) {
    dldwDatas = data;
}, 'json');

/**
 * 历年绩效指标查看弹出框
 * @param XM_ID
 * @param BILL_ID
 */
function initWindow_contentForm_tab_jxmb_lnTbCk(XM_ID, BILL_ID) {
    Ext.create('Ext.window.Window', {
        itemId: 'window_jxmb_lnTbCk', // 窗口标识
        title: '绩效目标历年信息', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.95, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: initWindow_zqxxtb_contentForm_tab_jxmb("lnjxmbForm", 'lnTreeGrid_Table', XM_ID, BILL_ID, true, true, ''),
        buttons: [
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    }).show();
}

/**
 * 绩效指标填报页面调用方法
 * @param XM_ID
 * @param BILL_ID
 * @returns {Ext.form.Panel}
 */
function initWindow_contentForm_tab_jxmb(XM_ID, BILL_ID, mbYear) {
    return initWindow_zqxxtb_contentForm_tab_jxmb('jxmbForm', 'treeGrid_Table', XM_ID, BILL_ID, false, false, mbYear);
}

/**
 * 绩效指标一户式调用方法
 * @param XM_ID
 * @param BILL_ID
 * @returns {Ext.form.Panel}
 */
function initWindow_contentForm_tab_jxmb_yhs(XM_ID, BILL_ID) {
    if (typeof button_status == "undefined" || isNull(button_status)) {
        button_status = 'yhsupdate';
    }
    let itemId = 'jxmbForm-' + Math.floor(Math.random() * 10);
    let treeGrid_Table = 'yhs-' + GUID.createGUID().substring(0, 16);
    return initWindow_zqxxtb_contentForm_tab_jxmb(itemId, treeGrid_Table, XM_ID, BILL_ID, true, false, '');
}

/**
 * 创建绩效目标form panel，并根据项目id和需求申报id获取数据
 * @param itemId 表单标识
 * @param treeGrid_Table 树形表格id,区分填报、历年查看、一户式的树形表格
 * @param XM_ID
 * @param BILL_ID
 * @param isNoEditable 是否不可编辑，一户式穿透时不可编辑
 * @param isLnTbCk 是否历年指标填报查看，若是，则不显示历年填报表格
 * @returns {Ext.form.Panel}
 */
function initWindow_zqxxtb_contentForm_tab_jxmb(itemId, treeGrid_Table, XM_ID, BILL_ID, isNoEditable, isLnTbCk, mbYear) {
    var fieldSetItemId = 'fieldSet' + itemId;
    var jxtbForm = Ext.create('Ext.form.Panel', {
        name: 'name' + itemId,
        itemId: itemId,
        width: '100%',
        height: '100%',
        layout: 'vbox',
        border: false,
        scrollable: true,
        padding: '0 10 0 10',
        defaultType: 'textfieldsafe',
        items: [
            {
                xtype: 'fieldset',
                title: mbYear + '年总体目标',
                itemId: fieldSetItemId,
                layout: 'column',
                defaultType: 'textfieldsafe',
                anchor: '100%',
                width: '100%',
                collapsible: true,
                fieldDefaults: {
                    labelWidth: 100,
                    columnWidth: .99,
                    margin: '0 0 5 5'
                },
                items: [
                    {
                        xtype: 'textarea',
                        fieldLabel: '<span class="required">✶</span>预期目标',
                        name: 'NDZTMB',
                        allowBlank: false,
                        maxLength: 2000,  // 限制输入字数
                        maxLengthText: "输入内容过长！",
                        height: '50'
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '绩效目标',
                layout: 'fit',
                defaultType: 'textfieldsafe',
                anchor: '100%',
                religion: 'center',
                width: '100%',
                height: 500,
                collapsible: true,
                scrollable: true,
                fieldDefaults: {
                    margin: '0 0 20 0'
                },
                items: [
                    {
                        xtype: 'panel',
                        itemId: 'treeGrid_Panel',
                        scrollable: true,
                        html: '<div style="width: 100%;"><table class="layui-hidden" id="' + treeGrid_Table + '" lay-filter="treeGrid_Table"></table></div>',
                        listeners: {
                            afterrender: function () {
                                jxmb(XM_ID, BILL_ID, isNoEditable, treeGrid_Table, mbYear);
                            }
                        }
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '项目绩效目标历年填报信息',
                layout: 'fit',
                defaultType: 'textfieldsafe',
                anchor: '100%',
                width: '100%',
                height: !!isLnTbCk ? 0 : 150,// 若是历年指标查看穿透，则历年指标表格没有高度
                hidden: !!isLnTbCk,// 若是历年指标查看穿透，则不显示历年指标表格
                collapsible: true,
                items: lntbxx(XM_ID)
            }
        ],
        listeners: {
            beforerender: function (self) {
                if (!!isNoEditable) {
                    setItemsReadOnly(self.items);
                }
            }
        }
    });
    // 加载数据
    jxtbForm.load({
        url: '/jxmbtb/loadJxmb.action',
        method: 'GET',
        params: {
            XM_ID: XM_ID,
            BILL_ID: BILL_ID,
            IS_FXJH: is_fxjh,
            itemId: itemId
        },
        success: function (form, action) {
            form.setValues(action.result.data);
            if (isNull(mbYear) && !isNull(action.result.data.TB_YEAR)) {
                mbYear = action.result.data.TB_YEAR;
                var ndztmb = Ext.ComponentQuery.query('#' + fieldSetItemId);
                for (var i = 0; i < ndztmb.length; i++) {
                    ndztmb[i].setTitle(mbYear + '年总体目标');
                }
            }
        },
        failure: function (form, action) {
            form.setValues(action.result.data);
        }
    });
    return jxtbForm;
}

/**
 * 创建绩效指标tree Grid
 * @param XM_ID
 * @param BILL_ID
 * @param isNoEditable 是否不可编辑
 * @param treeGrid_Table 树形表格id,区分填报、历年查看、一户式的树形表格
 * @param mbYear 总体目标年度
 */
function jxmb(XM_ID, BILL_ID, isNoEditable, treeGrid_Table, mbYear) {
    // 获取项目类型
    let xmlxComponent = Ext.ComponentQuery.query('treecombobox[name="XMLX_ID"]')[0];
    let XMLX_ID = !!xmlxComponent ? xmlxComponent.getValue() : '';
    var HEADERJSON = [
        {
            width: 60, title: '操作', align: 'center', style: 'background-color: #F2F2F2;'
            , templet: function (row) {
                var addBtn = '';
                var delBtn = '';
                var selBtn = '';
                // 当前行转为json对象才可以传递
                let jsonRow = JSON.stringify(row).replace(/"/g, '&quot;');
                if (row.LEVEL_NO == "02") {
                    // 新增和指标挑选换图标式风格（暂时先保留文字式风格按钮）
                    addBtn = '<img src="/image/common/plusSign.png" style="margin-left:-6px;width: 18px;height: 18px" class="zb-select-btn" onclick="add(this)"/>';
                    selBtn = '<img src="/image/common/chooseSign.png" style="margin-left:6px;width: 16px;height: 16px" class="zb-select-btn" onclick="sel(this,\'' + mbYear + '\')"/>';
                }
                // 三级指标中新增和指标库挑选指标可删除
                if (row.LEVEL_NO == "03" && (row.IS_NEW == 1 || row.IS_NEW == 3)) {
                    // 删除挑选换图标式风格（暂时先保留文字式风格按钮）
                    delBtn = '<img src="/image/common/delete.png" style="margin-left:-5px;width: 16px;height: 16px" class="zb-select-btn" onclick="del(this)"/>';
                }
                return addBtn + selBtn + delBtn;
            }
        },
        {
            field: 'IND_SHOW_NAME',
            width: 200,
            title: '绩效目标类型',
            style: 'background-color: #F2F2F2;'
        },
        {
            field: 'IND_NAME',
            width: 200,
            title: '<span class="required">✶</span>绩效目标名称',
            style: 'background-color: #F2F2F2;'
        },
        // {field: 'ZBLX_NAME', width: 100, title: '指标类型', style: 'background-color: #F2F2F2;'},
        {field: 'WEIGHT_VALUE', width: 100, title: '权重'},
        {
            field: 'TARGET_VALUE',
            width: 120,
            title: '<span class="required">✶</span>绩效目标值',
            style: 'background-color: #F2F2F2;',
            templet: function (d) {
                if (d.TV_TYPE == 1 && d.TARGET_VALUE) {
                    return (Math.round(parseFloat(d.TARGET_VALUE) * 100) / 100).toFixed(2);
                }
                if (isNull(d.TARGET_VALUE)) {
                    return '';
                }
                return d.TARGET_VALUE;
            }
        },
        {field: 'DLDW_ID', width: 400, title: '度量单位ID', style: 'background-color: #F2F2F2;'},
        {
            field: 'DLDW_NAME',
            width: 100,
            title: '<span class="required">✶</span>度量单位',
            style: 'background-color: #F2F2F2;',
            templet: function (d) {
                if (d.DLDW_NAME) {
                    return d.DLDW_NAME;
                } else if (d.IS_COMMON_IND == 2 && !d.DLDW_NAME) {
                    return "请选择";
                } else {
                    return '';
                }
            }
        },

        {
            field: 'FULL_VALUE',
            width: 120,
            title: '<span class="required">✶</span>绩效满分值',
            style: 'background-color: #F2F2F2;'
            ,
            templet: function (d) {
                if (d.LEVEL_NO != '03') {
                    return '';
                } else {
                    var fullValue = (Math.round(parseFloat(d.FULL_VALUE) * 100) / 100).toFixed(2);
                    return isNaN(fullValue) ? '' : fullValue;
                }
            }
        },
        // 评分标准（指标解释）
        {field: 'PFBZ', width: 400, title: '<span class="required">✶</span>指标解释', style: 'background-color: #F2F2F2;'},
        {field: 'ZBSM', width: 400, title: '<span class="required">✶</span>指标说明', style: 'background-color: #F2F2F2;'}
    ];
    // 若不可编辑，则移除操作列
    if (!!isNoEditable) {
        HEADERJSON.shift();
    }
    var params = {
        XMLX_ID: XMLX_ID,
        MOF_DIV_CODE: AD_CODE,
        PRO_ID: XM_ID,
        BILL_ID: BILL_ID,
        IS_FXJH: is_fxjh,
        treeGrid_Table: treeGrid_Table,
        BUTTON_STATUS: button_status,
        MBYEAR: mbYear
    };
    if (!params.BILL_ID) {
        params.IS_CURRENT = 1;
    }
    var config = {
        id: treeGrid_Table,
        cols: [HEADERJSON],  //表头
        url: '/jxmbtb/getJXZBList.action',
        idField: 'IND_ID', // 数据主键
        treeId: 'IND_ID', // 构造树形表格code字段
        treeUpId: 'PARENT_ID',// 树形表格父级code字段
        treeShowName: 'IND_SHOW_NAME', // 以树形式显示的字段
        where: params,
        selectData: dldwDatas.data, // 下拉框数据源
        done: function (tableData) {
            //设置表格样式
            $('th').css({
                'font-size': '14px', 'font-weight': 'bold', 'padding': '0', 'background-color': '#EEF6FB',
                'text-align': 'center'
            });
            $('td').css({'font-size': '13px', 'padding': '0'});
            // 若获取不到数据则直接返回
            if (tableData.code == 500) {
                return;
            }
            // 隐藏字段
            $(".layui-table-box").find("[data-field='DLDW_ID']").hide();
            $(".layui-table-box").find("[data-field='WEIGHT_VALUE']").hide();
            // 不可编辑
            if (!isNoEditable) {
                let data = tableData.data;
                for (let i = 0; i < data.length; i++) {
                    // 满分值右对齐
                    $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=' + 'FULL_VALUE' + ']').css('text-align', 'right');
                    // 绩效目标类型加粗
                    $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=' + 'IND_SHOW_NAME' + ']').css('font-weight', 'bold');
                    let row = data[i];
                    // 修改时，新增指标和指标库挑选指标可修改  1:新增指标  3:指标库挑选指标
                    if (row['IS_NEW'] == 1 || row['IS_NEW'] == 3) {
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td').data('edit', true);
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=0]').data('edit', false);
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=' + 'IND_SHOW_NAME' + ']').data('edit', false);
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=' + 'DLDW_NAME' + ']').data('edit', 'select');
                        //加背景色
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td').addClass('x-grid-back-white');
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=0]').addClass('x-grid-back-gray');
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=' + 'IND_SHOW_NAME' + ']').addClass('x-grid-back-gray');
                        // 度量单位添加样式
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=' + 'DLDW_NAME' + ']').addClass('dldw-select-btn');
                    }
                    // 二级指标不可编辑
                    if (row['LEVEL_NO'] == '02') {
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td').data('edit', false);
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td').addClass('x-grid-back-gray');
                    }
                    // 三级指标只能编辑目标值
                    if (row['LEVEL_NO'] == '03') {
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=' + 'TARGET_VALUE' + ']').data('edit', true);
                        //加背景色
                        $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=' + 'TARGET_VALUE' + ']').addClass('x-grid-back-white');
                    }
                }
            }
        }
    };
    var edit = {
        'edit(treeGrid_Table)': function (obj) {
            //校验满分值为大于0的数字
            if ((obj.field == 'FULL_VALUE' && isNaN(obj.value)) || (obj.field == 'FULL_VALUE' && obj.value <= 0)) {
                Ext.toast({
                    html: "满分值必须为大于0的数字！",
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400,
                });
                $(this).val("");
            }
            //字符串转换成数字类型，去掉字符串前面的0,保留两位小数
            if (obj.field == 'FULL_VALUE' && !isNaN(obj.value) && obj.value > 0) {
                $(this).val((Math.round(parseFloat(obj.value) * 100) / 100).toFixed(2));
            }
            // 修改度量单位时，修改DLDW_ID
            if (obj.field == 'DLDW_NAME') {
                // 实际值
                obj.data.DLDW_ID = obj.value;
                // 显示值
                /*$(this).parent().parent().find("td[data-field = 'DLDW_ID']").find("p").text(obj.value);*/
            }
            if (obj.field == 'TARGET_VALUE') {
                if (obj.data.TV_TYPE == 1) {
                    if (isNaN(obj.value) || isNull(obj.value)) {
                        Ext.toast({
                            html: "指标名称为" + obj.data.IND_NAME + "的目标值必须为数值！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400,
                        });
                        $(this).val("");
                    } else if (Math.round(parseFloat(obj.value) * 100) / 100 <= 0) {
                        Ext.toast({
                            html: "指标名称为" + obj.data.IND_NAME + "的目标值必须大于0！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400,
                        });
                        $(this).val("");
                    } else {
                        $(this).val((Math.round(parseFloat(obj.value) * 100) / 100).toFixed(2));
                    }
                }
            }
        }
    }
    DSYLayUITreeGrid.create(treeGrid_Table, config, edit);
}

/**
 * 指标库挑选
 * @param obj
 * @param mbYear 总体目标年度
 */
function sel(obj, mbYear) {
    var row_id = $(obj).parent().parent().parent().parent().data('index');//根据当前元素，获取到id
    var pObj = DSYLayUITreeGrid.getDataList('treeGrid_Table')[row_id];
    initWindow_zbkSelecct(pObj, mbYear);
}

/**
 * 添加行
 * @param obj
 */
function add(obj) {
    var row_id = $(obj).parent().parent().parent().parent().data('index');//根据当前元素，获取到id
    var pObj = DSYLayUITreeGrid.getDataList('treeGrid_Table')[row_id];
    var param = {};
    param.IND_ID = GUID.createGUID();
    param.PARENT_ID = pObj.IND_ID;
    param.PARENT_IND_CODE = pObj.IND_CODE;
    param.PARENT_FULL_VALUE = pObj.FULL_VALUE;
    param.IS_COMMON_IND = 2;
    param.ZBLX_NAME = "个性指标";
    param.VALUE_TYPE = 1;
    param.LEVEL_NO = "03";
    param.FULL_VALUE = '';
    param.IS_NEW = 1;  // 新增指标
    param.IS_LEAF = 1;
    var index = pObj ? pObj.LAY_TABLE_INDEX + pObj.children.length + 1 : 0;
    //调用树形表格添加一行方法
    DSYLayUITreeGrid.addRowForEdit('treeGrid_Table', index, param);
    // 添加行表格样式
    tableStyle(index);
}

/**
 * 删除行
 * @param obj
 */
function del(obj) {
    var $ = layui.jquery;
    var row_id = $(obj).parent().parent().parent().parent().data('index');//根据当前元素，获取到id
    var nowRow = DSYLayUITreeGrid.getDataList('treeGrid_Table')[row_id];
    Ext.Msg.confirm('提示', '请确认是否删除！', function (btn_confirm) {
        if (btn_confirm == 'yes') {
            DSYLayUITreeGrid.removeRow('treeGrid_Table', nowRow);
        }
    });
}

/**
 * 历年填报信息表格
 * @param XM_ID 根据项目id获取数据
 * @returns {*}
 */
function lntbxx(XM_ID) {
    var headerJson = [
        {
            text: "目标id", dataIndex: "MB_ID", type: "string", hidden: true
        },
        {
            text: "项目id", dataIndex: "XM_ID", type: "string", hidden: true
        },
        {
            text: "需求申报id", dataIndex: "BILL_ID", type: "string", hidden: true
        },
        {
            text: "审核状态", dataIndex: "STATUS", type: "string", width: "10%"
        },
        {
            text: "年度", dataIndex: "TB_YEAR", type: "string", width: "45%"
        },
        {
            text: "项目绩效目标信息", dataIndex: "TARGETINFO", type: "string", width: "45%",
            renderer: function (data, cell, record) {
                let xmId = record.data.XM_ID;
                let billId = record.data.BILL_ID;
                var result = '<a href="#" onclick="initWindow_contentForm_tab_jxmb_lnTbCk(\'' + xmId + '\',\'' + billId + '\');" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        }
    ];
    var grid = DSYGrid.createGrid({
        itemId: 'targetInfoGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/jxmbtb/getLNTBInfo.action',
        params: {
            PRO_ID: XM_ID
        },
        autoLoad: true,
        checkBox: false,
        border: false,
        scrollable: 'y',
        height: '100%',
        weight: '100%',
        pageConfig: {
            enablePage: false
        }
    });
    return grid;
}

/**
 * 指标库挑选窗口
 * @param pObj
 * @param mbYear 总体目标年度
 */
function initWindow_zbkSelecct(pObj, mbYear) {
    var zbkSelectWin = Ext.create('Ext.window.Window', {
        itemId: 'window_zbkSelect', // 窗口标识
        name: 'zbkSelectWin',
        title: '指标库挑选', // 窗口标题
        width: document.body.clientWidth * 0.9, //自适应窗口宽度
        height: document.body.clientHeight * 0.95, //自适应窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        items: [initWindow_zbkSelect_contentGrid(mbYear)],
        buttons: [
            {
                text: '确定',
                handler: function (btn) {
                    // 检验是否选中数据
                    var records = DSYGrid.getGrid('zbkSelectGrid').getSelection();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作!');
                        return;
                    }
                    for (let i = 0; i < records.length; i++) {
                        addzbk(pObj, records[i]);
                    }
                    btn.up('window').close();
                }
            },
            {
                text: '取消',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
    zbkSelectWin.show();
}

/**
 * 从指标库中添加一条三级指标
 * @param Obj 父节点对象
 * @param record 添加的数据
 */
function addzbk(Obj, record) {
    var allDates = DSYLayUITreeGrid.getDataList('treeGrid_Table');
    var pObj = null;
    for (let i = 0; i < allDates.length; i++) {
        if (Obj.IND_ID == allDates[i].IND_ID) {
            pObj = allDates[i];
        }
    }
    record.data.PARENT_ID = Obj.IND_ID;
    record.data.PARENT_IND_CODE = Obj.IND_CODE;
    // record.data.IND_SHOW_NAME = record.data.IND_NAME;
    record.data.PARENT_FULL_VALUE = Obj.FULL_VALUE;
    record.data.IS_COMMON_IND = 2;
    record.data.ZBLX_NAME = "个性指标";
    record.data.LEVEL_NO = "03";
    record.data.IS_LEAF = 1;
    record.data.VALUE_TYPE = 1;
    var index = pObj ? pObj.LAY_TABLE_INDEX + pObj.children.length + 1 : 0;
    //调用树形表格添加一行方法
    DSYLayUITreeGrid.addRowForEdit('treeGrid_Table', index, record.data);
    // 添加行表格样式
    tableStyle(index);
}

/**
 * 添加行时添加表格样式
 * @param index
 */
function tableStyle(index) {
    // 满分值右对齐
    $(".layui-table").find('tr[data-index=' + index + ']').find('td[data-field=' + 'FULL_VALUE' + ']').css('text-align', 'right')
    // 设置添加行样式
    $('td').css({'font-size': '13px', 'padding': '0'});
    // 指标类型不可编辑
    // $(".layui-table").find('tr[data-index=' + index + ']').find('td[data-field=' + 'ZBLX_NAME' + ']').data('edit', false);
    // 绩效目标类型不可编辑
    $(".layui-table").find('tr[data-index=' + index + ']').find('td[data-field=' + 'IND_SHOW_NAME' + ']').data('edit', false);
    // 加背景色
    $(".layui-table").find('tr[data-index=' + index + ']').find('td').addClass('x-grid-back-white');
    $(".layui-table").find('tr[data-index=' + index + ']').find('td[data-field=' + 'IND_SHOW_NAME' + ']').addClass('x-grid-back-gray');
    $(".layui-table").find('tr[data-index=' + index + ']').find('td[data-field=0]').addClass('x-grid-back-gray');
    // 度量单位添加样式
    $(".layui-table").find('tr[data-index=' + index + ']').find('td[data-field=' + 'DLDW_NAME' + ']').addClass('dldw-select-btn');
    // 隐藏列
    $(".layui-table-box").find("[data-field='DLDW_ID']").hide();
    $(".layui-table-box").find("[data-field='WEIGHT_VALUE']").hide();
    $(".layui-table").find('tr[data-index=' + index + ']').find('td[data-field=' + 'DLDW_NAME' + ']').data('edit', 'select');

}

/**
 * 指标库挑选弹出框
 * @returns {*}
 * @param mbYear 总体目标年度
 */
function initWindow_zbkSelect_contentGrid(mbYear) {
//设置查询form
    var search_form = DSYSearchTool.createTool({
        itemId: 'window_select_jsxm_grid_zbksearchTool',
        defaults: {
            labelAlign: 'right',
            labelWidth: 80,
            columnWidth: .333,
            margin: '3 5 3 5'
        },
        items: [
            {
                xtype: 'treecombobox',
                fieldLabel: '项目类型',
                name: 'JXMBTB_XMLX_ID',
                minPicekerWidth: 250,
                displayField: 'name',
                rootVisible: false,
                valueField: 'id',
                allowBlank: true,
                store: DebtEleTreeStoreDB("DEBT_ZWXMLX", {condition: "and xmfllx = 0"}),
                editable: false,
                listeners: {
                    change: function () {
                        getZBKSelectList(mbYear);
                    }
                }
            },
            {
                fieldLabel: '模糊查询',
                xtype: 'textfield',
                name: 'JXMBTB_MHCX',
                columnWidth: .333,
                emptyText: '请输入指标编码/指标名称',
                enableKeyEvents: true,
                listeners: {
                    'specialkey': function (self, e) {
                        //回车键
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            getZBKSelectList(mbYear);
                        }
                    }
                }
            }
        ],
        border: true,
        bodyStyle: 'border-width:0 0 0 0;',
        dock: 'top'
    });
    search_form.remove(search_form.down('toolbar'));
    search_form.addDocked({
        xtype: 'toolbar',
        border: false,
        width: 100,
        dock: 'right',
        padding: '0 0 0 0',
        layout: {
            type: 'hbox',
            align: 'center'
        },
        items: [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function (btn) {
                    getZBKSelectList(mbYear);
                }
            }
        ]
    });
    var headerJson = [
        {dataIndex: "IND_ID", type: "string", text: "指标id", hidden: true},
        {dataIndex: "MOF_DIV_NAME", type: "string", text: "地区"},
        {dataIndex: "IND_CODE", type: "string", text: "指标编码"},
        {dataIndex: "IND_NAME", type: "string", text: "指标名称"},
        {dataIndex: "LEVEL_NO", type: "string", text: "指标级别"},
        {dataIndex: "PARENT_IND_NAME", type: "string", text: "上级指标"},
        {dataIndex: "ZBLX_NAME", type: "string", text: "指标类型"},
        {dataIndex: "XMLX_NAME", type: "string", text: "项目类型 "},
        {
            dataIndex: "FULL_VALUE", type: "float", text: "指标满分值 ",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        /* {
             dataIndex: "WEIGHT_VALUE", type: "float", text: "权重",
             renderer: function (value) {
                 return Ext.util.Format.number(value, '0,000.00');
             }
         },*/
        {dataIndex: "DLDW_NAME", type: "string", text: "度量单位"},
        {dataIndex: "PFBZ", type: "string", text: "指标解释"},
        {dataIndex: "ZBSM", type: "string", text: "指标说明"}

    ];
    let indCodeList = getSJGXIndCodeList();
    var grid = DSYGrid.createGrid({
        itemId: 'zbkSelectGrid',
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: true,
            columnCls: 'normal'
        },
        flex: 1,
        dataUrl: '/jxmbtb/getZBKSelectList.action',
        params: {
            AG_ID: AG_ID,
            AD_CODE: USER_AD_CODE,
            IND_CODE_LIST: JSON.stringify(indCodeList),
            MBYEAR: mbYear
        },
        autoLoad: true,
        checkBox: true,
        border: false,
        height: '100%',
        width: '100%',
        pageConfig: {
            enablePage: false
        },
        dockedItems: search_form
    });
    return grid;
}

/**
 * 获取三级个性指标编码
 * @returns {[]}
 */
function getSJGXIndCodeList() {
    var datas = DSYLayUITreeGrid.getDataList('treeGrid_Table');
    var indCodeList = [];
    if (!!datas && datas.length > 0) {
        datas.forEach(function (record) {
            let indLevel = record['LEVEL_NO'];
            let indZblx = record['IS_COMMON_IND'];
            // 只需要三级个性指标
            if ("03" == indLevel && "2" == indZblx) {
                indCodeList.push(record['IND_CODE']);
            }
        })
    }
    return indCodeList;
}

/**
 * 查询按钮实现
 */
function getZBKSelectList(mbYear) {
    var JXMBTB_MHCX = Ext.ComponentQuery.query('textfield[name="JXMBTB_MHCX"]')[0].getValue();
    var JXMBTB_XMLX_ID = Ext.ComponentQuery.query('treecombobox[name="JXMBTB_XMLX_ID"]')[0].getValue();
    let indCodeList = getSJGXIndCodeList();
    var store = DSYGrid.getGrid('zbkSelectGrid').getStore();
    store.getProxy().extraParams = {
        AG_ID: AG_ID,
        AD_CODE: USER_AD_CODE,
        JXMBTB_XMLX_ID: JXMBTB_XMLX_ID,
        JXMBTB_MHCX: JXMBTB_MHCX,
        IND_CODE_LIST: JSON.stringify(indCodeList),
        MBYEAR: mbYear
    };
    store.loadPage(1);
}

/**
 * 送审时校验绩效填报全部数据
 * @returns {boolean|[]}
 */
function getJxmbtbAllDatas() {
    var jxmbForm = Ext.ComponentQuery.query('form[itemId="jxmbForm"]')[0]; //获取目标填报表单
    if (!jxmbForm.isValid()) {
        Ext.toast({
            html: "年度绩效目标：请检查必填项，以及未通过校验项！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400,
            listeners: {
                "show": function () {
                    setActiveTabPanelByTabTitle("年度绩效目标");
                }
            }
        });
        return false;
    }
    var jxmbtb_treetable = DSYLayUITreeGrid.getDataList('treeGrid_Table');//绩效目标填报树形表格
    for (var i = 0; i < jxmbtb_treetable.length; i++) {
        // 校验新增三级指标的目标值、指标说明、指标解释长度不能大于2000字符
        var zb_name = jxmbtb_treetable[i].IND_NAME;
        var zb_targetValue = jxmbtb_treetable[i].TARGET_VALUE;
        var zb_fullValue = jxmbtb_treetable[i].FULL_VALUE;
        var zb_pfbz = jxmbtb_treetable[i].PFBZ;
        var zb_zbsm = jxmbtb_treetable[i].ZBSM;
        var zb_tvType = jxmbtb_treetable[i].TV_TYPE;
        if ((!isNull(zb_fullValue) && isNaN(zb_fullValue)) || (!isNull(zb_fullValue) && zb_fullValue <= 0)) {
            return false;
        }
        if (!isNull(zb_targetValue) && zb_tvType == 1) {
            if (isNaN(zb_targetValue)) {
                return false;
            } else if (Math.round(parseFloat(zb_targetValue) * 100) / 100 <= 0 || Math.round(parseFloat(zb_targetValue) * 100) / 100 > parseFloat(zb_fullValue)) {
                return false;
            }
        }
        if (!isNull(zb_targetValue) && zb_targetValue.length > 2000) {
            Ext.toast({
                html: "年度绩效目标中绩效目标名称为" + zb_name + "的绩效目标值输入内容过长!",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400,
                listeners: {
                    "show": function () {
                        setActiveTabPanelByTabTitle("年度绩效目标");
                    }
                }
            });
            return false;
        }
        if (!isNull(zb_pfbz) && zb_pfbz.length > 2000) {
            Ext.toast({
                html: "年度绩效目标中绩效目标名称为" + zb_name + "的指标解释输入内容过长!",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400,
                listeners: {
                    "show": function () {
                        setActiveTabPanelByTabTitle("年度绩效目标");
                    }
                }
            });
            return false;
        }
        if (!isNull(zb_zbsm) && zb_zbsm.length > 2000) {
            Ext.toast({
                html: "年度绩效目标中绩效目标名称为" + zb_name + "的指标说明输入内容过长!",
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400,
                listeners: {
                    "show": function () {
                        setActiveTabPanelByTabTitle("年度绩效目标");
                    }
                }
            });
            return false;
        }
    }
    // 返回数据，做保存用
    var NDZTMB = jxmbForm.getForm().findField('NDZTMB').getValue();//预期目标
    var allDatas = [];
    allDatas.push(NDZTMB);
    allDatas.push(jxmbtb_treetable);
    return allDatas;
}

/**
 * 已有项目选择时校验一二级指标
 * @param xmlx_id 项目类型id
 * @param XM_ID 项目id
 * @param BIll_YEAR 申报年度
 * @returns {boolean}
 */
function yyxmcheckZB(xmlx_id, XM_ID, mbYear) {
    //设置ajax请求参数
    var params = {
        XMLX_ID: xmlx_id,
        MOF_DIV_CODE: AD_CODE,
        PRO_ID: XM_ID,
        BUTTON_STATUS: 'add',
        treeGrid_Table: 'treeGrid_Table',
        MBYEAR: mbYear
    };
    $.ajaxSetup({
        async: false
    });
    var isSuccess = false;
    //发送ajax请求，提交数据
    $.post('/jxmbtb/getJXZBList.action', params, function (data) {
        isSuccess = data.is;
    }, "json");
    return isSuccess;
}

