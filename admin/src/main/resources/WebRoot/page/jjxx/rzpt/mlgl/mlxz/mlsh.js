/**
 * js：名录审核
 * Created by djl on 2016/7/6.
 */
/**
 * 默认数据：工具栏
 */
$.extend(mlgl_json_common[wf_id][node_type], {
    defautItems: WF_STATUS,//默认状态
    items_content: function () {
        return [
            initContentTree(),//初始化左侧树
            initContentRightPanel()//初始化右侧表格
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
                        //保存日志
                        saveLog('查询名录信息','BUTTON','用户'+userCode+'查询成功');
                    }
                }
            },
            {
                xtype: 'button',
                text: '修改',
                name: 'UPDATE',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    var grid = DSYGrid.getGrid('contentGrid');
                    var records = grid.getSelectionModel().getSelected();
                    if (records.length < 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录后再进行操作！');
                    } else if (records.length > 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录！');
                    } else {
                        button_name = btn.name;
                        title = "修改名录信息";
                        editFj=true;
                        ml_id = records.items[0].data.ML_ID;
                        var mlAg_id = records.items[0].get('AG_ID');
                        $.ajax({
                            type : "post",
                            url : "/rzpt/mlgl/getMlxx.action",
                            data: {MLXX_ID : ml_id,
                            'AG_ID' : mlAg_id
                            },
                            async : false,
                            success : function(data){
                                var result = Ext.util.JSON.decode(data).data[0];
                                window_mlxz.show();
                                window_mlxz.window.down('form').getForm().setValues(result);
                                if (result.IS_SJQR && result.IS_SJQR == '1') {
                                    Ext.ComponentQuery.query('checkboxfield[name="IS_SJQR"]')[0].setValue('1');
                                }
                                if (result.IS_MLW && result.IS_MLW == '1') {
                                    Ext.ComponentQuery.query('checkboxfield[name="IS_MLW"]')[0].setValue('1');
                                }
                                var gqjgGrid = DSYGrid.getGrid('gqjgGrid');
                                gqjgGrid.getStore().getProxy().extraParams["ml_id"] = ml_id;
                                gqjgGrid.getStore().reload();
                            }
                        });
                    }
                }
            },
            {
                xtype: 'button',
                text: '审核',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '退回',
                name: 'back',
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
                        //保存日志
                        saveLog('查询名录信息','BUTTON','用户'+userCode+'查询成功');
                    }
                }
            },
            {
                xtype: 'button',
                text: '撤销审核',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelection();
                    if (records.length <= 0) {
                        Ext.MessageBox.alert('提示', '请选择至少一条后再进行操作');
                        return;
                    }
                    var ids = [];
                    for (var i in records) {
                        ids.push(records[i].get("ML_ID"));
                    }
                    Ext.Ajax.request({
                        url : '/rzpt/mlgl/isCanCxShMlxx.action',
                        method : 'post',
                        params : {
                            ids : ids
                        },
                        success : function (data) {
                            var respText = Ext.util.JSON.decode(data.responseText);
                            if(respText.success){
                                if(respText.canCxMl){
                                    doWorkFlow(btn);
                                }
                            }else{
                                Ext.MessageBox.alert('提示',respText.message);
                            }
                        }
                    });
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
                        reloadGrid();
                        //保存日志
                        saveLog('查询名录信息','BUTTON','用户'+userCode+'查询成功');
                    }
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
            '->',
            initButton_OftenUsed(),
            initButton_Screen()

        ]
    }
});

var canSelectDwlx = true;
/**
 * 初始化右侧主表格
 */
function initContentGrid() {
    /**
     * 主表格表头
     */
    var headerJson = [
        {xtype: 'rownumberer', width: 45},
        {dataIndex: "AG_NAME", type: "string", text: "单位名称", width: 200},
        {dataIndex: "AD_NAME", type: "string", text: "所属行政区划", width: 150},
        {dataIndex: "ZGDW", type: "string", text: "主管单位", width: 180},
        {dataIndex: "ZGDWLX_NAME", type: "string", text: "单位类型", width: 180},
        {dataIndex: "ML_ID", type: "string", hidden: true},
        {dataIndex: "ZZJG_CODE", type: "string", text: "组织机构代码", width: 150},
        {dataIndex: "TYSHXY_CODE", type: "string", text: "统一社会信用代码", width: 170},
        {
            dataIndex: "IS_GYXZBXM", type: "string", text: "有无公益性资本项目", width: 150,
            renderer: function (value) {
                if (value == 1 || value == '1') {
                    return "有"
                } else if (value == 0 || value == '0') {
                    return "无"
                } else {
                    return value;
                }
            }
        },
        {dataIndex: "RZPTLX_NAME", type: "string", text: "融资平台分类", width: 150,hidden:true},
        /*{"dataIndex": "GQLX_NAME", "type": "string", "text": "股权类型", "width": 150},
        {"dataIndex": "HYLY_NAME", "type": "string", "text": "行业领域", "width": 150},*/
        {dataIndex: "ADDRESS", type: "string", text: "平台地址", width: 200},
        {dataIndex: "FRDB_NAME", type: "string", text: "法人代表姓名", width: 120},
        {dataIndex: "FRDB_TEL", type: "string", text: "法人代表联系电话", width: 160},
        {dataIndex: "CWFZR_NAME", type: "string", text: "财务负责人姓名", width: 120},
        {dataIndex: "CWFZR_TEL", type: "string", text: "财务负责人联系电话", width: 160},
        {dataIndex: "YG_NUM", type: "number", text: "员工/在校学生数量", width: 120,align:'right',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000');
            }
        },
        /*{"dataIndex": "BG_STATE", "type": "string", "text": "变更状态", "width": 120,'align':'center'},
        {"dataIndex": "BG_DATE", "type": "string", "text": "变更时间", "width": 120,'align':'center'},*/
        {
            dataIndex: "IS_MLW", type: "string", text: "是否名录内", width: 100,hidden:true,
            renderer: function (value) {
                if (value == 1 || value == '1') {
                    return "是"
                } else if (value == 0 || value == '0') {
                    return "否"
                } else {
                    return value;
                }
            }
        },
        {
            dataIndex: "IS_SJQR", type: "string", text: "是否为2013年6月底审计结果确定的融资平台", width: 350,hidden:true,
            renderer: function (value) {
                if (value == 1 || value == '1') {
                    return "是"
                } else if (value == 0 || value == '0') {
                    return "否"
                } else {
                    return value;
                }
            }
        },
        {
            dataIndex: "IS_QLZBPT", type: "string", text: "是否为2014年底清理甄别确定的融资平台公司", width: 350,
            renderer: function (value) {
                if (value == 1 || value == '1') {
                    return "是"
                } else if (value == 0 || value == '0') {
                    return "否"
                } else {
                    return value;
                }
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
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: '/rzpt/mlgl/getContentGrid.action',
        autoLoad: false,
        checkBox: true,
        pageConfig: {
            pageNum: true,//设置显示每页条数
            pageSize: 20// 每页显示数据数
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                itemId: 'contentGrid_status',
                name: 'contentGrid_status',
                store: DebtEleStore(json_debt_zt2_4),// json_debt_zt2
                width: 110,
                editable: false,
                labelWidth: 30,
                labelAlign: 'right',
                allowBlank: false,
                displayField: "name",
                valueField: "code",
                value: WF_STATUS,
                listeners: {
                    change: function (self, newValue) {
                        WF_STATUS = newValue;
                        var toolbar = Ext.ComponentQuery.query('toolbar#contentPanel_toolbar')[0];
                        toolbar.removeAll();
                        toolbar.add(mlgl_json_common[wf_id][node_type].items[WF_STATUS]);
                        //刷新当前表格
                        self.up('grid').getStore().getProxy().extraParams["WF_STATUS"] = WF_STATUS;
                        if (AD_CODE == null || AD_CODE == '') {
                            Ext.Msg.alert('提示', '请选择区划！');
                            return;
                        }
                        self.up('grid').getStore().loadPage(1);
                    }
                }
            }
        ],
       /* listeners : {
            itemdblclick : function (self, record) {
                editFj=false;
                ml_id = record.data.ML_ID;
                window_mlxz_view.show();
                window_mlxz_view.window.down('form').getForm().setValues(record.data);
                var gqjgGrid = DSYGrid.getGrid('gqjgGrid');
                gqjgGrid.getStore().getProxy().extraParams["ml_id"] = ml_id;
                gqjgGrid.getStore().reload();
                if (!editFj) {
                    gqjgGrid.down('toolbar').removeAll();
                }
            }
        },*/
        listeners: {
            itemdblclick: function (self, record) {
                var paramNames=new Array();
                paramNames[0]="MLXX_ID";
                paramNames[1]="AG_ID";
                paramNames[2]="AG_CODE";
                paramNames[3]="AD_CODE";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.data.ML_ID);
                paramValues[1]=encodeURIComponent(record.data.AG_ID);
                paramValues[2]=encodeURIComponent(record.data.AG_CODE);
                paramValues[3]=encodeURIComponent(record.data.AD_CODE);
                urlCt("/page/debt/rzpt/mlgl/mlxz/mlYhsMain.jsp",paramNames,paramValues);
            }
        }
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}

//创建名录信息填报弹出窗口
var window_mlxz = {
    window: null,
    config: {
        closeAction: 'destroy'
    },
    show: function () {
        if (!this.window || this.config.closeAction == 'destroy') {

            this.window = initWindow_mlxz();
        }
        var obj = new Object();
        var array1 = new Array();
        var array2 = new Array();
        array1.push("mlxxForm");
        array2.push({"id":"mlxxTab","first":1});
        obj["form"] = array1;
        obj["tab"] = array2;
        UI_Draw("ui_draw", obj, null);
        this.window.show();
    }
};
var mlxzFormCheck = function () {
    var mlxzForm = Ext.ComponentQuery.query('form[name="mlxxForm"]')[0];
    var mlxzFormValues = mlxzForm.getValues();
    //获取组织机构代码组件
    var field_ZZJG_CODE=mlxzForm.query('[name="ZZJG_CODE"]')[0];
    var result = '';
//    if(mlxzFormValues.ZZJG_CODE == null || mlxzFormValues.ZZJG_CODE=='' ||mlxzFormValues.ZZJG_CODE == undefined){
//        // result = result + "<span class=\"required\">✶</span>组织机构代码不能为空";
//    }else{
//        if(mlxzFormValues.ZZJG_CODE.length != 9 && mlxzFormValues.ZZJG_CODE.length != 0){
//            result = result + "<span class=\"required\">✶</span>全国组织机构代码由八位数字（或大写拉丁字母）本体代码和一位数字（或大写拉丁字母）校验码组成，请修正后再提交";
//        }
//    }
//    if(mlxzFormValues.TYSHXY_CODE == null || mlxzFormValues.TYSHXY_CODE=='' ||mlxzFormValues.TYSHXY_CODE == undefined){
//        // result = result + "<span class=\"required\">✶</span>统一社会信用代码不能为空";
//    }else{
//        if(mlxzFormValues.TYSHXY_CODE.length != 18){
//            result = result + "<span class=\"required\">✶</span>统一社会信用代码由18位数字或大写拉丁字母组成，包括登记管理部门代码（1位）、机构类别代码（1位）、登记管理机关行政区划码（6位）、主体标识码（9位全国组织机构代码）、验码（1位）五个部分组成，请修正后再提交！";
//        }else{
//            //当组织机构代码组件不允许为空，并且组织机构代码不等于统一社会信用码8-17位时
//            if(field_ZZJG_CODE&&!field_ZZJG_CODE.allowBlank&&mlxzFormValues.TYSHXY_CODE.substring(8,17)  != mlxzFormValues.ZZJG_CODE){
//                result = result + "<br/>"+"<span class=\"required\">✶</span>统一社会信用代码（18位）包含了组织机构代码（第9-17位），请修正后再提交！";
//            }
//        }
//    }
    return  result;

}

var gqjgGridCheck = function () {
    //var zcsxForm = Ext.ComponentQuery.query('form[name="zcsxFrom"]')[0];
    //var zcsxFormValues = zcsxForm.getValues();
    var result = '';
    var gqjgStore = DSYGrid.getGrid("gqjgGrid").getStore();
    if (gqjgStore.data.length > 0 && showGqjg == 1) {
        DSYGrid.getGrid("gqjgGrid").getStore().each(function (record) {
            if (record.get('TZF_NAME') == null || record.get('TZF_NAME') == '' || record.get('TZF_NAME') == 'undefined') {
                message_error = "股权结构：请填写列表中“投资方全称”列";
                if (result == '') {
                    result += message_error;
                } else {
                    result += "<br/>" + message_error;
                }
            }
            if (record.get('RJCZ_AMT') == null || record.get('RJCZ_AMT') == '' || record.get('RJCZ_AMT') == 'undefined' || record.get('RJCZ_AMT') == 0 || record.get('RJCZ_AMT') == 0.0) {
                message_error = "股权结构：请填写列表中“认缴出资额”列";
                if (result == '') {
                    result += message_error;
                } else {
                    result += "<br/>" + message_error;
                }
            }
            if (record.get('SJCZ_AMT') == null || record.get('SJCZ_AMT') == '' || record.get('SJCZ_AMT') == 'undefined' || record.get('SJCZ_AMT') == 0 || record.get('SJCZ_AMT') == 0.0) {
                message_error = "股权结构：请填写列表中“实缴出资额”列";
                if (result == '') {
                    result += message_error;
                } else {
                    result += "<br/>" + message_error;
                }
            }
            if (record.get('CG_RATE') == null || record.get('CG_RATE') == '' || record.get('CG_RATE') == 'undefined') {
                message_error = "股权结构：请填写列表中“持股比例（%）”列";
                if (result == '') {
                    result += message_error;
                } else {
                    result += "<br/>" + message_error;
                }
            }

        });
    }
    return result;
}