var json_dfz = [];// 得分值储存
/**
 * 创建录入弹出窗口
 * @param xm_id 项目ID
 * @param button_text 控制是否可编辑
 * @param view_id 绩效自评ID
 */
function initWin_zdjxpjWindow(xm_id, button_text, view_id, params, yhsCtType) {
    var zdjxpjWinTitle;
    if (yhsCtType) {
        zdjxpjWinTitle = yhsCtType == 1 ? "省级重点项目绩效评价" : yhsCtType == 2 ? "地市重点项目绩效评价" : "区县重点项目绩效评价";
    } else {
        zdjxpjWinTitle = MOF_TYPE == 1 ? "省级重点项目绩效评价" : MOF_TYPE == 2 ? "地市重点项目绩效评价" : "区县重点项目绩效评价";
    }
    var buttons;
    if (button_text == '') {
        buttons = [
            {
                text: '关闭',
                hidden: true,
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ];
    } else {
        buttons = [
            {
                text: '保存',
                handler: function (btn) {
                    //保存表单数据
                    submitInfo('', btn);
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ];
    }

    var zdjxpjWindow = Ext.create('Ext.window.Window', {
        title: zdjxpjWinTitle,
        name: 'zdjxpjWin',
        width: document.body.clientWidth, //自适应窗口宽度
        height: document.body.clientHeight, //自适应窗口高度
        maximizable: true,
        itemId: 'window_zdjxpj', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        layout: 'vbox',
        autoScroll: true,
        defaults: {
            width: '100%'
        },
        items: initWindow_zdjxpj_panel(xm_id, button_text, view_id, params, yhsCtType),
        buttons: buttons
    });
    if (button_text == '') {
        loadZdjxpjInfo(view_id);
    }
    zdjxpjWindow.show();
}

/**
 * 初始化填报信息项
 * @param xm_id 项目ID
 * @param button_text 控制是否可编辑
 * @param view_id 绩效评价ID
 */
function initWindow_zdjxpj_panel(xm_id, button_text, view_id, params, yhsCtType) {
    return [Ext.create('Ext.form.Panel', {
        name: 'zdjxpj_xmgy_Form',
        layout: 'fit',
        border: false,
        items: [{
            xtype: 'fieldset',
            title: '项目概要',
            itemId: 'xmgyFieldset',
            anchor: '100%',
            layout: 'column',
            margin: '0 0 0 0',
            defaultType: 'textfieldsafe',
            defaults: {
                margin: '5 5 5 5',
                columnWidth: .33,
                labelWidth: 100//控件默认标签宽度
            },
            collapsible: true,
            items: [
                {
                    xtype: "field",
                    name: "PJ_ID",
                    readOnly: true,
                    hidden: true
                },
                {
                    xtype: "field",
                    fieldLabel: '项目ID',
                    name: "PRO_ID",
                    readOnly: true,
                    tdCls: 'grid-cell-unedit',
                    hidden: true
                },
                {
                    xtype: "textfield",
                    fieldLabel: '<span class="required">✶</span>项目编码',
                    name: "PRO_CODE",
                    readOnly: true,
                    tdCls: 'grid-cell-unedit',
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    name: "PRO_NAME",
                    fieldLabel: '<span class="required">✶</span>项目名称',
                    readOnly: true,
                    tdCls: 'grid-cell-unedit',
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "field",
                    fieldLabel: '区划编码',
                    name: "MOF_DIV_CODE",
                    itemId: "MOF_DIV_CODE",
                    readOnly: true,
                    hidden: true,
                    tdCls: 'grid-cell-unedit'
                },
                {
                    xtype: "field",
                    fieldLabel: '区划名称',
                    name: "MOF_DIV_NAME",
                    readOnly: true,
                    hidden: true,
                    tdCls: 'grid-cell-unedit'
                },
                {
                    xtype: "field",
                    fieldLabel: '单位ID',
                    name: "AGENCY_ID",
                    readOnly: true,
                    tdCls: 'grid-cell-unedit',
                    hidden: true
                },
                {
                    xtype: "field",
                    fieldLabel: '单位编码',
                    name: "AGENCY_CODE",
                    readOnly: true,
                    tdCls: 'grid-cell-unedit',
                    hidden: true
                },
                {
                    xtype: "field",
                    fieldLabel: '单位名称',
                    name: "AGENCY_NAME",
                    readOnly: true,
                    tdCls: 'grid-cell-unedit',
                    hidden: true
                },
                {
                    xtype: 'field',
                    fieldLabel: '项目类型ID',
                    name: 'XMLX_ID',
                    itemId: "XMLX_ID",
                    tdCls: 'grid-cell-unedit',
                    readOnly: true,
                    hidden: true
                },
                {
                    xtype: 'textfield',
                    fieldLabel: '<span class="required">✶</span>项目类型',
                    name: 'XMLX_NAME',
                    readOnly: true,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: 'combobox',
                    fieldLabel: '<span class="required">✶</span>评价年度',
                    name: 'PJ_YEAR',
                    itemId: 'PJ_YEAR',
                    displayField: 'name',
                    valueField: 'id',
                    store: DebtEleStore(getYearList({start: -5, end: 5})),
                    //margin: '0 70 0 0',
                    //value: nowYear,
                    readOnly: true,
                    editable: false,
                    allowBlank: false,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    fieldLabel: '<span class="required">✶</span>总分',
                    name: "PJ_VALUE",
                    readOnly: true,
                    tdCls: 'grid-cell-unedit',
                    cls: 'x-form-textfield-noborder',
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: 'combobox',
                    fieldLabel: '<span class="required">✶</span>综合评分等级',
                    name: 'LEVEL_NO',
                    displayField: 'name',
                    valueField: 'id',
                    store: DebtEleStore(json_debt_pfdj),
                    editable: false,
                    allowBlank: true,
                    //columnWidth: .20,
                    readOnly: true,
                    cls: 'x-form-textfield-noborder',
                    fieldStyle: 'background:#E6E6E6',
                    listeners: {
                        'change': function (self, newValue, oldValue) {
                            if (newValue == '1') {
                                self.setFieldStyle('background:#24ff66');
                                //self.setValue('优');
                            } else if (newValue == '2') {
                                self.setFieldStyle('background:#2dc7ff');
                                //self.setValue('良');
                            } else if (newValue == '3') {
                                self.setFieldStyle('background:#fff96b');
                                //self.setValue('中');
                            } else if (newValue == '4') {
                                self.setFieldStyle('background:#FF4330');
                                //self.setValue('差');
                            }
                        },
                        renderer: function (value) {
                            var store = DebtEleStore(json_debt_pfdj);
                            var record = store.findRecord('id', value, 0, false, true, true);
                            return record != null ? record.get('name') : value;
                        }
                    }
                }
            ]
        },]
    }),
        {
            xtype: 'fieldset',
            title: '项目绩效单位自评',
            itemId: 'zdjxpj_xmjxzp_Form',
            anchor: '100%',
            height: document.body.clientHeight * 0.4,
            layout: 'fit',
            religion: 'center',
            margin: '0 0 0 0',
            collapsible: true,
            collapsed: params.YHS == 'YHS' ? false : true,
            // listeners:{
            //     render: function(t){
            //         t.collapse();
            //     }
            // },
            scrollable: true,
            items: [
                {
                    xtype: 'panel',
                    itemId: 'treeGrid_jxzpck_Panel',
                    width: document.body.clientWidth,
                    scrollable: true,
                    html: '<div style="width: 100%;"><table class="layui-hidden-jxzp" id="jxzp_table" lay-filter="jxzp_table"></table></div>',
                    listeners: {
                        afterrender: function () {
                            var FISCAL_YEAR;
                            setTimeout(function () {
                                var jxzpYear = Ext.ComponentQuery.query('combobox#PJ_YEAR')[0];
                                if (jxzpYear) {
                                    FISCAL_YEAR = jxzpYear.getValue();
                                    initXmzpTreeGrid(xm_id, button_text, view_id, FISCAL_YEAR);
                                }
                            }, 100);
                        }
                    }
                }
            ]
        },
        {
            xtype: 'fieldset',
            title: '项目绩效财政评价',
            itemId: 'zdjxpjForm',
            anchor: '100%',
            height: document.body.clientHeight * 0.4,
            layout: 'fit',
            religion: 'center',
            margin: '6 0 0 0',
            collapsible: true,
            scrollable: true,
            items: [
                {
                    xtype: 'panel',
                    itemId: 'treeGrid_Panel',
                    width: document.body.clientWidth,
                    scrollable: true,
                    html: '<div style="width: 100%;"><table class="layui-hidden" id="zdjxpj_table" lay-filter="zdjxpj_table"></table></div>',
                    listeners: {
                        afterrender: function () {
                            var FISCAL_YEAR;
                            setTimeout(function () {
                                var jxzpYear = Ext.ComponentQuery.query('combobox#PJ_YEAR')[0];
                                if (jxzpYear) {
                                    FISCAL_YEAR = jxzpYear.getValue();
                                    initZdjxpjTreeGrid(xm_id, button_text, view_id, params, FISCAL_YEAR);
                                }
                            }, 100);

                        }
                    }
                }
            ]
        },
        {
            xtype: 'fieldset',
            title: '项目绩效评价报告附件<span class="file_sum_fj" style="color: #FF0000;">(0)</span>',
            itemId: 'winPanel_zdjxpj_fj_Panel',
            anchor: '100%',
            height: document.body.clientHeight * 0.3,
            layout: 'fit',
            collapsible: true,
            items: initWindow_zdjxpj_upload(button_text, view_id, yhsCtType)
        }
    ]
}

/**
 * 初始化页签panel的附件页签
 * @param button_text 控制是否可编辑
 * @param view_id 主键zp_id
 * @returns {*}
 */
function initWindow_zdjxpj_upload(button_text, view_id, yhsCtType) {
    var busiType;
    var busiId;
    if (button_text != '') {
        busiId = zdjxpj_id;
    } else {
        busiId = view_id;
    }
    //一户式穿透时，绩效评价查看附件规则
    if (MOF_TYPE) {
        busiType = MOF_TYPE == 1 ? 'PJBG_SJ' : 'PJBG_DS';
    } else {
        if (yhsCtType) {
            busiType = yhsCtType == 1 ? 'PJBG_SJ' : 'PJBG_DS';
        } else {
            busiType = MOF_TYPE == 1 ? 'PJBG_SJ' : 'PJBG_DS';
        }
    }

    var grid = UploadPanel.createGrid({
        busiType: busiType,// 业务类型
        busiId: busiId, // 业务ID
        editable: button_text != '' ? true : false,
        gridConfig: {
            itemId: 'window_zdjxpjfj',
            headerConfig: {
                columnAutoWidth: true// 表头自适应
            }
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
        if (grid.up('winPanel_zdjxpj_fj_Panel') && grid.up('winPanel_zdjxpj_fj_Panel').el && grid.up('winPanel_zdjxpj_fj_Panel').el.dom) {
            $(grid.up('winPanel_zdjxpj_fj_Panel').activeTab.el.dom).find('span.file_sum_fj').html('(' + sum + ')');
        } else if ($('span.file_sum_fj')) {
            $('span.file_sum_fj').html('(' + sum + ')');
        }
    });
    return grid;
}

/**
 * 绩效自评填报树形表格
 * @param xm_id 项目id
 * @param button_text 控制是否可编辑
 * @param view_id 主键自评id
 */
function initXmzpTreeGrid(xm_id, button_text, view_id, FISCAL_YEAR) {
    var HEADERJSON = [
        {
            field: 'ZP_IND_SHOW_NAME', width: '240', title: '绩效目标类型', style: 'background-color: #F2F2F2;',
            templet: function (d) {
                if (d.LEVEL_NO != '02') {
                    return '';
                } else {
                    return '<b>' + d.ZP_IND_SHOW_NAME + '</b>';
                }
            }
        },// 展示
        {
            field: 'ZP_IND_NAME', width: '240', title: '绩效目标名称', style: 'background-color: #F2F2F2;',
            templet: function (d) {
                if (d.LEVEL_NO != '03') {
                    return '';
                } else {
                    return d.ZP_IND_NAME;
                }
            }
        },// 展示
        {field: 'ZP_TARGET_VALUE', width: '100', title: '绩效目标值', style: 'background-color: #F2F2F2;'},// 展示
        {
            field: 'ZP_SJ_TARGET_VALUE', width: '100', title: '实际完成值', style: 'background-color: #F2F2F2;'
        },// 展示
        {field: 'DLDW_NAME', width: '105', title: '度量单位', style: 'background-color: #F2F2F2;'},// 展示
        {
            field: 'ZP_FULL_VALUE', width: '100', title: '指标满分值', style: 'background-color: #F2F2F2;',// 展示
            templet: function (d) {
                if (d.LEVEL_NO != '03') {
                    return '';
                } else {
                    var fullValue = parseFloat(d.ZP_FULL_VALUE).toFixed(2);
                    return isNaN(fullValue) ? '' : fullValue;
                }
            }

        },
        {
            field: 'ZP_SCORE_VALUE', width: '100', title: '得分', style: 'background-color: #F2F2F2;',
            templet: function (d) {
                if (d.LEVEL_NO != '03') {
                    return '';
                } else {
                    var scoreValue = parseFloat(d.ZP_SCORE_VALUE).toFixed(2);
                    return isNaN(scoreValue) ? '' : scoreValue;
                }
            }
        },// 展示
        {field: 'ZP_ZGCS', width: '270', title: '偏差原因分析及整改措施', style: 'background-color: #F2F2F2;'}
    ];// 展示
    var config = {
        id: 'xmjxzpGrid',
        async: false,
        cols: [HEADERJSON],  //表头
        url: '/zdjxpj/getZpckGrid.action',
        idField: 'DTL_ID', // 数据主键
        treeId: 'IND_ID', // 构造树形表格code字段
        treeUpId: 'PARENT_ID',// 树形表格父级code字段
        treeShowName: 'IND_SHOW_NAME', // 以树形式显示的字段
        where: {
            button_text: button_text,
            PRO_ID: xm_id,
            FISCAL_YEAR: FISCAL_YEAR
        },
        done: function (tableData, count) {
            $('th').css({
                'font-size': '14px',
                'font-weight': 'bold',
                'padding': '0',
                'background-color': '#EEF6FB',
                'text-align': 'center'
            });
            $('td').css({'font-size': '13px', 'padding': '0'});
            let data = tableData.data;
            for (let i = 0; i < data.length; i++) {
                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='ZP_SCORE_VALUE']").css('text-align', 'right');
                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='ZP_FULL_VALUE']").css('text-align', 'right');
            }

        },
    };

    DSYLayUITreeGrid.create('jxzp_table', config, {});
}


/**
 * 绩效自评填报树形表格
 * @param xm_id 项目id
 * @param button_text 控制是否可编辑
 * @param view_id 主键自评id
 */
function initZdjxpjTreeGrid(xm_id, button_text, view_id, params, FISCAL_YEAR) {
    var HEADERJSON = [
        {field: 'DTL_ID', width: 150, title: '绩效评价明细主键ID', style: 'background-color: #F2F2F2;'}, // 改了的
        {field: 'PJ_ID', width: 150, title: '绩效评价主单id', style: 'background-color: #F2F2F2;'}, // 改了的
        {field: 'IND_ID', width: 150, title: '指标ID', style: 'background-color: #F2F2F2;'},
        {field: 'IND_CODE', width: 150, title: '指标CODE', style: 'background-color: #F2F2F2;'},
        {field: 'LEVEL_NO', width: 150, title: '指标级别', style: 'background-color: #F2F2F2;'},
        {field: 'IND_NAME', width: 230, title: '指标(隐藏值)', style: 'background-color: #F2F2F2;'},
        {field: 'IND_SHOW_NAME', width: '25%', title: '指标名称', style: 'background-color: #F2F2F2;'}, // 展示
        {field: 'WEIGHT_VALUE', width: 150, title: '权重', style: 'background-color: #F2F2F2;'},
        {field: 'VALUE_TYPE', width: 150, title: '计算分类', style: 'background-color: #F2F2F2;'},
        {field: 'IS_LEAF', width: 150, title: '是否叶子', style: 'background-color: #F2F2F2;'},
        {field: 'IS_COMMON_IND', width: 150, title: '指标类型ID', style: 'background-color: #F2F2F2;'},
        {field: 'TARGET_VALUE', width: '6%', title: '目标值', style: 'background-color: #F2F2F2;'},
        {field: 'SJ_TARGET_VALUE', width: '16%', title: '实际完成情况', style: 'background-color: #F2F2F2;'},
        {
            field: 'FULL_VALUE', width: '8%', title: '指标满分值', style: 'background-color: #F2F2F2;',
            templet: function (d) {
                if (d.LEVEL_NO != '03') {
                    return '';
                } else {
                    var fullValue = parseFloat(d.FULL_VALUE).toFixed(2);
                    return isNaN(fullValue) ? '' : fullValue;
                }
            }
        },// 展示
        {
            field: 'SCORE_VALUE',
            width: '7%',
            title: '<span class="required">✶</span>得分',
            style: 'background-color: #F2F2F2;',
            templet: function (d) {
                if (d.LEVEL_NO != '03') {
                    return '';
                } else {
                    var scoreValue = parseFloat(d.SCORE_VALUE).toFixed(2);
                    return isNaN(scoreValue) ? '' : scoreValue;
                }
            }
        },// 展示
        // {field: 'SCORE_VALUE', width: '7%', title: '得分', style: 'background-color: #F2F2F2;'},// 展示
        {
            field: 'SJ_SCORE_VALUE', width: '6%', title: '得分值', style: 'background-color: #F2F2F2;',
            templet: function (d) {
                if (d.LEVEL_NO != '03') {
                    return '';
                } else {
                    var sjScoreValue = parseFloat(d.SJ_SCORE_VALUE).toFixed(2);
                    return isNaN(sjScoreValue) ? '' : sjScoreValue;
                }
            }
        },// 隐藏
        {field: 'ZGYJ', width: '20%', title: '整改意见', style: 'background-color: #F2F2F2;'},// 展示  // 改了的
        {field: 'PFBZ', width: '20%', title: '指标解释', style: 'background-color: #F2F2F2;'},// 展示
        {field: 'ZBSM', width: '20%', title: '指标说明', style: 'background-color: #F2F2F2;'},// 展示
        {field: 'ZGCS', width: '20%', title: '偏差原因分析及整改措施', style: 'background-color: #F2F2F2;'}
    ];
    var config = {
        id: 'zdjxpjGrid',
        async: false,
        cols: [HEADERJSON],  //表头
        url: '/zdjxpj/getZdjxpjGrid.action',
        idField: 'DTL_ID', // 数据主键
        treeId: 'IND_ID', // 构造树形表格code字段
        treeUpId: 'PARENT_ID',// 树形表格父级code字段
        treeShowName: 'IND_SHOW_NAME', // 以树形式显示的字段
        where: {
            button_text: button_text,
            PRO_ID: xm_id,
            ZP_ID: button_text != '' ? zdjxpj_id : view_id,
            MOF_DIV_CODE: params.MOF_DIV_CODE,
            XMLX_ID: params.XMLX_ID,
            FISCAL_YEAR: FISCAL_YEAR

        },
        done: function (tableData, count) {
            $('th').css({
                'font-size': '14px',
                'font-weight': 'bold',
                'padding': '0',
                'background-color': '#EEF6FB',
                'text-align': 'center'
            });
            $('td').css({'font-size': '13px', 'padding': '0'});
            let data = tableData.data;
            for (let i = 0; i < data.length; i++) {
                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SCORE_VALUE']").css('text-align', 'right');
                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SJ_SCORE_VALUE']").css('text-align', 'right');
                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='FULL_VALUE']").css('text-align', 'right');
            }
            if (data.length > 0) {
                if (button_text == 'UPDATE' || button_text == '') {
                    json_dfz = [];
                    for (var i = 0; i < data.length; i++) {
                        var row = data[i];
                        json_dfz[row.DTL_ID] = row.SJ_SCORE_VALUE;
                    }
                }
            }
            if (button_text != '') {
                for (let i = 0; i < data.length; i++) {
                    let row = data[i];
                    // 三级指标可以编辑打分值
                    if (row['LEVEL_NO'] == '03') {
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SJ_TARGET_VALUE']").data('edit', 'text');
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SCORE_VALUE']").data('edit', 'text');
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='ZGYJ']").data('edit', 'text');
                        // 背景色设置
                        // $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SJ_TARGET_VALUE']").addClass('x-grid-back-gray');
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SCORE_VALUE']").addClass('x-grid-back-gray');
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='ZGYJ']").addClass('x-grid-back-gray');
                    }
                }
            }

            // 隐藏字段
            $(".layui-table-box").find("[data-field='DTL_ID']").hide();
            $(".layui-table-box").find("[data-field='PJ_ID']").hide();
            $(".layui-table-box").find("[data-field='IND_ID']").hide();
            $(".layui-table-box").find("[data-field='IND_CODE']").hide();
            $(".layui-table-box").find("[data-field='LEVEL_NO']").hide();
            $(".layui-table-box").find("[data-field='IND_NAME']").hide();
            $(".layui-table-box").find("[data-field='WEIGHT_VALUE']").hide();
            $(".layui-table-box").find("[data-field='VALUE_TYPE']").hide();
            $(".layui-table-box").find("[data-field='IS_LEAF']").hide();
            $(".layui-table-box").find("[data-field='IS_COMMON_IND']").hide();
            $(".layui-table-box").find("[data-field='TARGET_VALUE']").hide();
            $(".layui-table-box").find("[data-field='SJ_TARGET_VALUE']").hide();
            $(".layui-table-box").find("[data-field='SJ_SCORE_VALUE']").hide();
            $(".layui-table-box").find("[data-field='ZGCS']").hide();

        },
    };

    var edit = {
        'edit(zdjxpj_table)': function (obj) {
            // 当前为打分值时走一下逻辑
            if (obj.field == 'SCORE_VALUE') {
                // 分值下必须为分值
                var data = DSYLayUITreeGrid.getDataList('zdjxpjGrid');
                // 打分值类型校验
                var check_msg = /^\d+(\.\d+)?$/;
                if (isNaN(obj.value) || !check_msg.test(obj.value)) {
                    Ext.toast({
                        html: "指标名称为:"+obj.data.IND_NAME+",得分必须为正数！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    $(this).val("");
                    return;
                }

                // 打分值与满分值校验
                if (obj.value > obj.data.FULL_VALUE || obj.value == 0.00) {
                    Ext.toast({
                        html: "指标名称为:"+obj.data.IND_NAME+",得分必须小于或等于指标满分值！且不能为零！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    $(this).val("");
                    return;
                }
                //字符串转换成数字类型，去掉字符串前面的0,保留两位小数
                if (obj.field == 'SCORE_VALUE' && !isNaN(obj.value) && obj.value > 0) {
                    $(this).val(parseFloat(obj.value).toFixed(2));
                }

                // 打分计算
                var zf = 0;// 总分
                // 赋值三级指标
                $(this).parent().next().find('p').text(obj.value);
                json_dfz[obj.data.DTL_ID] = obj.value;
                var PJ_VALUE = Ext.ComponentQuery.query('field[name="PJ_VALUE"]')[0];
                var LEVEL_NO = Ext.ComponentQuery.query('field[name="LEVEL_NO"]')[0];
                for (var key in json_dfz) {
                    zf += parseFloat(isNull(json_dfz[key]) ? 0 : json_dfz[key]);
                }
                PJ_VALUE.setValue(zf.toFixed(2));
                if (zf <= 100 && zf >= 90) {
                    LEVEL_NO.setValue('1');
                    LEVEL_NO.setFieldStyle('background:#24ff66');
                }
                if (zf < 90 && zf >= 80) {
                    LEVEL_NO.setValue('2');
                    LEVEL_NO.setFieldStyle('background:#2dc7ff');
                }
                if (zf < 80 && zf >= 60) {
                    LEVEL_NO.setValue('3');
                    LEVEL_NO.setFieldStyle('background:#fff96b');
                }
                if (zf < 60) {
                    LEVEL_NO.setValue('4');
                    LEVEL_NO.setFieldStyle('background:#FF4330');
                }
            }
        }
    };
    if (button_text == '') {
        DSYLayUITreeGrid.create('zdjxpj_table', config, {});
    } else {
        DSYLayUITreeGrid.create('zdjxpj_table', config, edit);
    }
}


/**
 * 加载页面数据
 * @param zdjxpj_id 绩效评价id
 */
function loadZdjxpjInfo(zdjxpj_id) {
    var zdjxpj_xmgy_Form = Ext.ComponentQuery.query('form[name="zdjxpj_xmgy_Form"]')[0];
    $.post("/zdjxpj/getZdjxpjEcho.action", {
        ZP_ID: zdjxpj_id
    }, function (data) {
        if (data.success) {
            zdjxpj_xmgy_Form.getForm().setValues(data.xmgyForm[0]);
        }
    }, 'json');
}