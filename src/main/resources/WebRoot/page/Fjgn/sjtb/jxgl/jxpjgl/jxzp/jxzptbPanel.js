var json_dfz = [];// 得分值储存
/**
 * 创建录入弹出窗口
 * @param xm_id 项目ID
 * @param button_text 控制是否可编辑
 * @param view_id 绩效自评ID
 */
function initWin_jxzpWindow(xm_id, button_text, view_id) {
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

    var jxzpWindow = Ext.create('Ext.window.Window', {
        title: "项目绩效自评",
        name: 'jxzpWin',
        width: document.body.clientWidth, //自适应窗口宽度
        height: document.body.clientHeight, //自适应窗口高度
        maximizable: true,
        itemId: 'window_jxzp', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',
        layout: 'vbox',
        autoScroll: true,
        defaults: {
            width: '100%'
        },
        items: initWindow_jxzp_panel(xm_id, button_text, view_id),
        buttons: buttons
    });
    if (button_text == '') {
        loadInfo(view_id);
    }
    jxzpWindow.show();
}

/**
 * 初始化填报信息项
 * @param xm_id 项目ID
 * @param button_text 控制是否可编辑
 * @param view_id 绩效自评ID
 */
function initWindow_jxzp_panel(xm_id, button_text, view_id){
    return [Ext.create('Ext.form.Panel', {
        name: 'xmgyForm',
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
                    name: "ZP_ID",
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
                    allowBlank: false,
                    tdCls: 'grid-cell-unedit',
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "textfield",
                    name: "PRO_NAME",
                    fieldLabel: '<span class="required">✶</span>项目名称',
                    readOnly: true,
                    allowBlank: false,
                    tdCls: 'grid-cell-unedit',
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: "field",
                    fieldLabel: '区划编码',
                    name: "MOF_DIV_CODE",
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
                    tdCls: 'grid-cell-unedit',
                    readOnly: true,
                    hidden: true
                },
                {
                    xtype: 'textfield',
                    fieldLabel: '<span class="required">✶</span>项目类型',
                    name: 'XMLX_NAME',
                    readOnly: true,
                    allowBlank: false,
                    fieldStyle: 'background:#E6E6E6'
                },
                {
                    xtype: 'combobox',
                    fieldLabel: '<span class="required">✶</span>评价年度',
                    name: 'ZP_YEAR',
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
                    name: "ZP_VALUE",
                    readOnly: true,
                    allowBlank: false,
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
                    allowBlank: false,
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
        Ext.create('Ext.form.Panel', {
            name: 'ztmbForm',
            layout: 'fit',
            border: false,
            items: [
                {
                    xtype: 'fieldset',
                    title: '年度总体目标',
                    itemId:'ztmbFieldset',
                    anchor: '50%',
                    layout: 'column',
                    margin: '0 0 0 0',
                    defaultType: 'textfieldsafe',
                    defaults: {
                        margin: '5 5 5 5',
                        columnWidth: .99,
                        labelWidth: 100//控件默认标签宽度
                    },
                    collapsible: true,
                    items: [
                        {
                            fieldLabel: '<span class="required">✶</span>预期目标',
                            xtype: "textarea",
                            columnWidth: 1,
                            name: 'NDZTMB',
                            grow:true,
                            growMin: 40,
                            readOnly: true,
                            allowBlank: false,
                            fieldStyle:'background:#E6E6E6'
                        },
                        {
                            fieldLabel: '<span class="required">✶</span>实际完成情况',
                            xtype: "textarea",
                            name: 'SJ_NDZTMB',
                            grow:true,
                            growMin: 40,
                            columnWidth: 1,
                            maxLength:2000,//限制输入字数
                            maxLengthText:"输入内容过长！",
                            readOnly: button_text == '' ? true : false,
                            allowBlank: false,
                            fieldStyle: button_text == '' ? 'background:#E6E6E6' : ''
                        }
                    ]
                }
            ]
        }),
        {
            xtype: 'fieldset',
            title: '项目绩效自评',
            itemId:'xmjxForm',
            anchor: '100%',
            height: document.body.clientHeight * 0.4,
            layout: 'fit',
            religion: 'center',
            margin: '0 0 0 0',
            collapsible: true,
            scrollable: true,
            items: [
                {
                    xtype: 'panel',
                    itemId: 'treeGrid_Panel',
                    width: document.body.clientWidth,
                    scrollable: true,
                    html: '<div style="width: 100%;"><table class="layui-hidden" id="jxzp_table" lay-filter="jxzp_table"></table></div>',
                    listeners: {
                        afterrender: function () {
                            jxzp(xm_id,button_text,view_id);
                        }
                    }
                }
            ]
        },
        {
            xtype: 'fieldset',
            title: '项目绩效评价报告附件<span class="file_sum_fj" style="color: #FF0000;">(0)</span>',
            itemId:'winPanel_jxzpPanel',
            anchor: '100%',
            height: document.body.clientHeight * 0.3,
            layout: 'fit',
            collapsible: true,
            items: initWindow_jxzp_upload(button_text, view_id)
        }
    ]
}

/**
 * 初始化页签panel的附件页签
 * @param button_text 控制是否可编辑
 * @param view_id 主键zp_id
 * @returns {*}
 */
function initWindow_jxzp_upload(button_text,view_id) {
    var busiId;
    if (button_text != '') {
        busiId = jxzp_id;
    } else {
        busiId = view_id;
    }
    var grid = UploadPanel.createGrid({
        busiType: '',//业务类型
        busiId: busiId,//业务ID
        editable: button_text != '' ? true : false,
        gridConfig: {
            itemId: 'window_jxzpfj',
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
        if (grid.up('winPanel_jxzpPanel') && grid.up('winPanel_jxzpPanel').el && grid.up('winPanel_jxzpPanel').el.dom) {
            $(grid.up('winPanel_jxzpPanel').activeTab.el.dom).find('span.file_sum_fj').html('(' + sum + ')');
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
function jxzp(xm_id,button_text,view_id) {
    var HEADERJSON = [
        {field: 'DTL_ID', width: 150, title: '自评明细ID', style: 'background-color: #F2F2F2;'},
        {field: 'MB_ID', width: 150, title: '目标填报ID', style: 'background-color: #F2F2F2;'},
        {field: 'NDZTMB', width: 150, title: '年度总体目标', style: 'background-color: #F2F2F2;'},
        {field: 'IND_ID', width: 150, title: '指标ID', style: 'background-color: #F2F2F2;'},
        {field: 'IND_CODE', width: 150, title: '指标CODE', style: 'background-color: #F2F2F2;'},
        {field: 'LEVEL_NO', width: 150, title: '指标级别', style: 'background-color: #F2F2F2;'},
        {field: 'WEIGHT_VALUE', width: 150, title: '权重', style: 'background-color: #F2F2F2;'},
        {field: 'VALUE_TYPE', width: 150, title: '计算分类', style: 'background-color: #F2F2F2;'},
        {field: 'IS_LEAF', width: 150, title: '是否叶子', style: 'background-color: #F2F2F2;'},
        {field: 'IS_COMMON_IND', width: 150, title: '指标类型ID', style: 'background-color: #F2F2F2;'},
        {field: 'ZBSM', width: 150, title: '指标说明', style: 'background-color: #F2F2F2;'},
        {field: 'IND_SHOW_NAME', width: '17%', title: '绩效目标类型', style: 'background-color: #F2F2F2;',
            templet:function(d){
                if(d.LEVEL_NO != '02'){
                    return '';
                }else{
                    return '<b>'+d.IND_SHOW_NAME+'</b>';
                }
            }
        },
        {field: 'IND_NAME', width: '17%', title: '绩效目标名称', style: 'background-color: #F2F2F2;',
            templet:function(d){
                if(d.LEVEL_NO != '03'){
                    return '';
                }else{
                    return d.IND_NAME;
                }
            }
        },
        {field: 'TARGET_VALUE',width: '8%', title: '绩效目标值', style: 'background-color: #F2F2F2;'},
        {field: 'TV_TYPE',width: 100, title: '指标目标值类型', style: 'background-color: #F2F2F2;'},
        {field: 'SJ_TARGET_VALUE',width: '16%', title: '<span class="required">✶</span>实际完成值', style: 'background-color: #F2F2F2;',
            templet:function(d){
                if(d.LEVEL_NO == '03' && d.TV_TYPE == 1){
                    var sjTargetValue = new BigNumber(d.SJ_TARGET_VALUE).toFixed(2);
                    return isNaN(sjTargetValue) ? '' : sjTargetValue;
                }else if (d.LEVEL_NO == '03' && d.TV_TYPE == 2){
                    return isNull(d.SJ_TARGET_VALUE) ? '' : d.SJ_TARGET_VALUE;
                }else{
                    return isNull(d.SJ_TARGET_VALUE) ? '' : d.SJ_TARGET_VALUE;
                }
            }
        },
        {field: 'DLDW_ID',width: 100, title: '度量单位ID', style: 'background-color: #F2F2F2;'},
        {field: 'DLDW_NAME',width: '7%', title: '度量单位', style: 'background-color: #F2F2F2;'},
        {field: 'FULL_VALUE', width: '8%', title: '指标满分值', style: 'background-color: #F2F2F2;',
            templet:function(d){
                if(d.LEVEL_NO != '03'){
                    return '';
                }else{
                    var fullValue = new BigNumber(d.FULL_VALUE).toFixed(2);
                    return isNaN(fullValue) ? '' : fullValue;
                }
            }
        },
        {field: 'SCORE_VALUE', width: '6%', title: '<span class="required">✶</span>得分', style: 'background-color: #F2F2F2;',
            templet:function(d){
                if(d.LEVEL_NO != '03'){
                    return '';
                }else{
                    var scoreValue = new BigNumber(d.SCORE_VALUE).toFixed(2);
                    return isNaN(scoreValue) ? '' : scoreValue;
                }
            }
        },
        {field: 'SJ_SCORE_VALUE', width: 100, title: '得分值', style: 'background-color: #F2F2F2;',
            templet:function(d){
                if(d.LEVEL_NO != '03'){
                    return '';
                }else{
                    var sjScoreValue = new BigNumber(d.SJ_SCORE_VALUE).toFixed(2);
                    return isNaN(sjScoreValue) ? '' : sjScoreValue;
                }
            }
        },
        {field: 'PFBZ', width: 100, title: '评分标准', style: 'background-color: #F2F2F2;'},
        {field: 'ZGCS', width: '21%', title: '偏差原因分析及整改措施', style: 'background-color: #F2F2F2;'}
    ];
    var config = {
        id: 'xmjxzpGrid',
        async: false,
        cols: [HEADERJSON],  //表头
        url: '/jxzp/getJxzpGrid.action',
        idField: 'DTL_ID', // 数据主键
        treeId: 'IND_ID', // 构造树形表格code字段
        treeUpId: 'PARENT_ID',// 树形表格父级code字段
        treeShowName: 'IND_SHOW_NAME', // 以树形式显示的字段
        where: {
            button_text: button_text,
            PRO_ID: xm_id,
            ZP_ID: button_text != '' ? jxzp_id : view_id,
            NEW_YEAR: button_text != '' ? newYear : ''
        },
        done: function (tableData,count) {
            $('th').css({'font-size': '14px','font-weight': 'bold','padding':'0','background-color':'#EEF6FB','text-align' : 'center'});
            $('td').css({'font-size': '13px','padding':'0'});
            var NDZTMB = Ext.ComponentQuery.query('textarea[name="NDZTMB"]')[0];
            let data = tableData.data;
            for (let i = 0; i < data.length; i++) {
                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SCORE_VALUE']").css('text-align', 'right');
                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SJ_SCORE_VALUE']").css('text-align', 'right');
                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='FULL_VALUE']").css('text-align', 'right');
            }
            if(data.length > 0){
                NDZTMB.setValue(data[0].NDZTMB);
                if(button_text == 'UPDATE' || button_text == ''){
                    json_dfz = [];
                    for(var i = 0; i < data.length; i++){
                        var row = data[i];
                        json_dfz[row.DTL_ID] = row.SJ_SCORE_VALUE;
                    }
                }
            }
            if(button_text != ''){
                for (let i = 0; i < data.length; i++) {
                    let row = data[i];
                    // 三级指标可以编辑打分值
                    if (row['LEVEL_NO'] == '03') {
                        if (row['TV_TYPE'] == '1') {
                            // 数字
                            $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=' + 'SJ_TARGET_VALUE' + ']').prepend("<div class='tdpd'>请输入数字</div>")
                        } else {
                            // 字符串
                            $(".layui-table").find('tr[data-index=' + i + ']').find('td[data-field=' + 'SJ_TARGET_VALUE' + ']').prepend("<div class='tdpd'>请输入字符</div>")
                        }
                        if (isNull(row['SJ_TARGET_VALUE'])) {
                            $(".layui-table").find('.tdpd').show();
                        } else {
                            $(".layui-table").find('.tdpd').hide();
                        }
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SJ_TARGET_VALUE']").data('edit', 'text');
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SCORE_VALUE']").data('edit', 'text');
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='ZGCS']").data('edit', 'text');
                        // 背景色设置
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SJ_TARGET_VALUE']").addClass('x-grid-back-gray');
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SCORE_VALUE']").addClass('x-grid-back-gray');
                        $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='ZGCS']").addClass('x-grid-back-gray');
                    }
                }
            }
            // 隐藏字段
            $(".layui-table-box").find("[data-field='MB_ID']").hide();
            $(".layui-table-box").find("[data-field='NDZTMB']").hide();
            $(".layui-table-box").find("[data-field='IND_ID']").hide();
            $(".layui-table-box").find("[data-field='IND_CODE']").hide();
            $(".layui-table-box").find("[data-field='LEVEL_NO']").hide();
            $(".layui-table-box").find("[data-field='IS_LEAF']").hide();
            $(".layui-table-box").find("[data-field='IS_COMMON_IND']").hide();
            $(".layui-table-box").find("[data-field='ZBSM']").hide();
            $(".layui-table-box").find("[data-field='WEIGHT_VALUE']").hide();
            $(".layui-table-box").find("[data-field='VALUE_TYPE']").hide();
            $(".layui-table-box").find("[data-field='DTL_ID']").hide();
            //$(".layui-table-box").find("[data-field='IND_NAME']").hide();
            $(".layui-table-box").find("[data-field='PFBZ']").hide();
            $(".layui-table-box").find("[data-field='SJ_SCORE_VALUE']").hide();
            $(".layui-table-box").find("[data-field='DLDW_ID']").hide();
            $(".layui-table-box").find("[data-field='TV_TYPE']").hide();
            // 添加合计行
            /*$(".layui-table-total").remove();
            var totalDiv='<div class="layui-table-total">' +
                '<table cellspacing="0" cellpadding="0" border="0" class="layui-a" width="100%">' +
                '<tbody><tr style="background-color: #ffdd47;">' +
                '<td style="width: 19.5%;font-size: 13px;height: 23.3px !important;"><div class="layui-table-cell">合计</div></td>' +
                '<td style="width: 6%;"></td>' +
                '<td style="width: 16%;"></td>' +
                '<td style="width: 6%;"></td>' +
                '<td style="width: 7%;text-align:right;font-size: 13px"><div class="layui-table-cell sumPrice" ></div></td>' +
                '<td style="width: 6%;text-align:right;font-size: 13px"><div class="layui-table-cell sumQuantity" ></div></td>' +
                '<td style="width: 20%;"></td>' +
                '<td style="width: 20%;"></td></tr></tbody></table></div>'
            if (count>0){
                $("#jxzp_table").next().find(".layui-table-header").append(totalDiv);
                countSum();
            }*/
        },
    };
    //合计行计算
    function countSum() {
        var detailDatas = [];
        var sumPrice = 0;
        var sumQuantity = 0;
        detailDatas = DSYLayUITreeGrid.getDataList("xmjxzpGrid");
        for (var i = 0; i < detailDatas.length; i++) {
            var row = detailDatas[i];
            row.SJ_SCORE_VALUE = json_dfz[row.DTL_ID] ? json_dfz[row.DTL_ID] : 0;
        }
        for(var i = 0; i < detailDatas.length; i++){
            //此处的判断是由于Layui的删除del()方法之后只是清空了内容，并不是删掉了元素
            if (JSON.stringify(detailDatas[i]).length<=2){
                continue;
            }
            sumPrice += parseFloat(detailDatas[i].SCORE_VALUE)>0?parseFloat(detailDatas[i].SCORE_VALUE):0;
            sumQuantity += parseFloat(detailDatas[i].SJ_SCORE_VALUE)>0?parseFloat(detailDatas[i].SJ_SCORE_VALUE):0;
        }
        $(".layui-table-total .layui-a .sumQuantity").text(sumQuantity.toFixed(2));
        $(".layui-table-total .layui-a .sumPrice").text(sumPrice.toFixed(2));
    }
    var edit = {
        'edit(jxzp_table)':function (obj) {
            // 当前为打分值时走一下逻辑
            if(obj.field == 'SCORE_VALUE'){
                // 分值下必须为分值
                var data = DSYLayUITreeGrid.getDataList('xmjxzpGrid');
                // 打分值类型校验
                var check_msg = /^\d+(\.\d+)?$/;
                if(isNaN(obj.value) || !check_msg.test(obj.value)){
                    Ext.toast({
                        html: "得分必须为正数！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    $(this).val("");
                    return;
                }
                if(obj.value <= 0){
                    Ext.toast({
                        html: "得分必须大于0！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    $(this).val("");
                    return;
                }
                // 打分值与满分值校验
                if(obj.value > obj.data.FULL_VALUE){
                    Ext.toast({
                        html: "得分必须小于或等于指标满分值！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                    $(this).val("");
                    return;
                }
                // 打分计算
                var type2 = 0;// 一级指标类型
                var type1 = 0;// 二级指标类型
                var indId = '';// 二级指标ID
                var weight_value1 = 0;// 一级权重值
                var weight_value2 = 0;// 二级权重值
                var zf = 0;// 总分
                /* 20210914 guoyf 打分逻辑暂时注释
                // 寻找二级指标
                for (let i = 0; i < data.length; i++) {
                    var row = data[i];
                    if (row['LEVEL_NO'] == '02') {
                        if (row['IND_ID'] == obj.data.PARENT_ID) {
                            type2 = row['VALUE_TYPE'];
                            indId = row['PARENT_ID'];
                            weight_value2 = row['WEIGHT_VALUE'];
                        }
                    }
                }
                // 寻找一级指标
                for (let i = 0; i < data.length; i++) {
                    var row = data[i];
                    if (row['LEVEL_NO'] == '01') {
                        if (row['IND_ID'] == indId) {
                            type1 = row['VALUE_TYPE'];
                            weight_value1 = row['WEIGHT_VALUE'];
                        }
                    }
                }
                // 一二级都为分值
                if (type1 == '1' && type2 == '1') {
                    // 赋值三级指标
                    /!*for (let i = 0; i < data.length; i++) {
                        var row = data[i];
                        if (row['LEVEL_NO'] == '03') {
                            if (row['IND_CODE'] == obj.data.IND_CODE) {
                                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SJ_SCORE_VALUE']").find("p").text(obj.value);
                                json_dfz[obj.data.DTL_ID] = obj.value;
                            }
                        }
                    }*!/
                    $(this).parent().next().find('p').text(obj.value);
                    json_dfz[obj.data.DTL_ID] = obj.value;
                    // 一级权重、二级分值
                } else if (type1 == '2' && type2 == '1') {
                    // 赋值三级指标
                    /!*for (let i = 0; i < data.length; i++) {
                        var row = data[i];
                        if (row['LEVEL_NO'] == '03') {
                            if (row['IND_CODE'] == obj.data.IND_CODE) {
                                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SJ_SCORE_VALUE']").find("p").text(obj.value * (weight_value1 / 100));
                                json_dfz[obj.data.DTL_ID] = obj.value * (weight_value1 / 100);
                            }
                        }
                    }*!/
                    $(this).parent().next().find('p').text(parseFloat(obj.value * (weight_value1 / 100)).toFixed(2));
                    json_dfz[obj.data.DTL_ID] = parseFloat(obj.value * (weight_value1 / 100)).toFixed(2);
                    // 一二级都权重
                } else if (type1 == '2' && type2 == '2') {
                    // 赋值三级指标
                    /!*for (let i = 0; i < data.length; i++) {
                        var row = data[i];
                        if (row['LEVEL_NO'] == '03') {
                            if (row['IND_CODE'] == obj.data.IND_CODE) {
                                $(".layui-table").find('tr[data-index=' + i + ']').find("[data-field='SJ_SCORE_VALUE']").find("p").text(obj.value * (weight_value1 / 100) * (weight_value2 / 100));
                                json_dfz[obj.data.DTL_ID] = obj.value * (weight_value1 / 100) * (weight_value2 / 100);
                            }
                        }
                    }*!/
                    $(this).parent().next().find('p').text(parseFloat(obj.value * (weight_value1 / 100) * (weight_value2 / 100)).toFixed(2));
                    json_dfz[obj.data.DTL_ID] = parseFloat(obj.value * (weight_value1 / 100) * (weight_value2 / 100)).toFixed(2);
                }*/
                //字符串转换成数字类型，去掉字符串前面的0,保留两位小数
                if (obj.field == 'SCORE_VALUE' && !isNaN(obj.value) && obj.value > 0) {
                    $(this).val(new BigNumber(obj.value).toFixed(2));
                }
                // 当前只有分值，没有权重逻辑
                $(this).parent().next().find('p').text(new BigNumber(obj.value).toFixed(2));
                json_dfz[obj.data.DTL_ID] = new BigNumber(obj.value).toFixed(2);
                var ZP_VALUE = Ext.ComponentQuery.query('field[name="ZP_VALUE"]')[0];
                var LEVEL_NO = Ext.ComponentQuery.query('field[name="LEVEL_NO"]')[0];
                for (var key in json_dfz) {
                    zf += parseFloat(isNull(json_dfz[key]) ? 0 : json_dfz[key]);
                }
                ZP_VALUE.setValue(zf.toFixed(2));
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
            if (obj.field == 'SJ_TARGET_VALUE') {
                if (obj.data.TV_TYPE == 1) {
                    if (isNaN(obj.value)) {
                        Ext.toast({
                            html: "该目标值必须为数值！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400,
                        });
                        $(this).val("");
                    }else if(isNull(obj.value)){
                        $(this).val('');
                    }else{
                        $(this).val(new BigNumber(obj.value).toFixed(2));
                    }
                    if(obj.value <= 0){
                        Ext.toast({
                            html: "该目标值必须大于0！",
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        $(this).val("");
                        return;
                    }
                }
            }
            //countSum();
        }
    };
    if(button_text == ''){
        DSYLayUITreeGrid.create('jxzp_table', config, {});
    }else{
        DSYLayUITreeGrid.create('jxzp_table', config, edit);
    }
}

/**
 * 加载页面数据
 * @param jxzp_id 绩效自评id
 */
function loadInfo(jxzp_id) {
    var xmgyForm = Ext.ComponentQuery.query('form[name="xmgyForm"]')[0];
    var ztmbForm = Ext.ComponentQuery.query('form[name="ztmbForm"]')[0];
    $.post("/jxzp/getJxzpEcho.action", {
        ZP_ID:jxzp_id
    }, function (data) {
        xmgyForm.getForm().setValues(data.xmgyForm[0]);
        ztmbForm.getForm().setValues(data.ztmbForm[0]);
    },'json');
}