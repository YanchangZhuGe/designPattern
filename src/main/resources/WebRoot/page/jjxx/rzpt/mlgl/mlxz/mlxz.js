/**
 * js：融资平台名录新增
 * Created by djl on 2016/7/6.
 */
//本页面使用的基础数据
var tyshxydmRegText = "统一代码由十八位的阿拉伯数字或大写英文字母（不使用I、O、Z、S、V）组成。"+"<br/>"
    +"第1位：登记管理部门代码（共一位字符）"+"<br/>"
    +"第2位：机构类别代码（共一位字符）"+"<br/>"
    +"第3位~第8位：登记管理机关行政区划码（共六位阿拉伯数字）"+"<br/>"
    +"第9位~第17位：主体标识码（组织机构代码）（共九位字符）"+"<br/>"
    +"第18位：校验码（共一位字符）";

var canSelectDwlx = true;
//var rzpt_mlxx_rdqk_store = DebtEleStore(json_rzpt_mlxx_rdqk);
/**
 * 默认数据：工具栏
 */
$.extend(mlgl_json_common[wf_id][node_type], {
    defautItems: WF_STATUS,//默认状态
    items_content: function () {
        return [
            initContentTree(),
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
                        //保存日志
                        saveLog('查询名录信息','BUTTON','用户'+userCode+'查询成功');
                    }
                }
            },
            {
                xtype: 'button',
                text: '新增',
                name: 'INPUT',
                icon: '/image/sysbutton/add.png',
                handler: function (btn) {
                    if (!AG_ID || AG_ID == '') {
                        Ext.Msg.alert('提示', "请选择一个底级单位");
                        return;
                    }
                    Ext.Ajax.request({
                        url: '/rzpt/mlgl/isCanAddMlxx.action',
                        params: {
                            AG_ID: AG_ID,
                            AG_CODE:AG_CODE,
                            AD_CODE:AD_CODE
                        },
                        success: function (data) {
                            var respText = Ext.util.JSON.decode(data.responseText);
                            if (respText.success) {
                                if (respText.canAdd) {
                                    button_name = 'INPUT';
                                    title = "名录新增";
                                    editFj=true;
                                    //ml_id = GUID.createGUID();
                                    ml_id = respText.data_ag[0].ML_ID;
                                    window_mlxz.show();
                                    //已有的名录信息带出来
                                    window_mlxz.window.down('form').getForm().setValues(respText.data_ag[0]);
                                    //给名录信息中的
                                    Ext.ComponentQuery.query('form[name="mlxxForm"]')[0].getForm().findField('ML_ID').setValue(ml_id);
                                } else {
                                    Ext.MessageBox.alert('提示', '该单位名录信息已存在，不能新增名录信息！');
                                }
                            } else {
                                btn.setDisabled(false);
                                Ext.MessageBox.alert('提示', respText.message);
                            }

                        }
                    });
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
                        $.ajax({
                            type : "post",
                            url : "/rzpt/mlgl/getMlxx.action",
                            data: {
                                    MLXX_ID : ml_id,
                                    AG_ID: records.items[0].data.AG_ID,
                                    AG_CODE:records.items[0].data.AG_CODE,
                                    AD_CODE:records.items[0].data.AD_CODE
                                  },
                            async : false,
                            success : function(data){
                                var result = Ext.util.JSON.decode(data).data[0];
                                window_mlxz.show();
                                window_mlxz.window.down('form').getForm().setValues(result);
                                if (result.IS_SJQR == '1') {
                                    Ext.ComponentQuery.query('checkboxfield[name="IS_SJQR"]')[0].setValue('1');
                                }
                                if (result.IS_MLW == '1') {
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
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records < 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录后再进行操作！');
                    } else {
                        Ext.Msg.confirm('提示', '请确认是否删除！', function (button) {
                            if (button == 'yes') {
                                var ids = [];
                                Ext.Array.forEach(records, function (r) {
                                    ids.push(r.get("ML_ID"));
                                });
                                Ext.Ajax.request({
                                    url: '/rzpt/mlgl/deleteMlxx.action',
                                    params: {
                                        ids: ids,
                                        WF_STATUS: WF_STATUS,
                                        wf_id: wf_id,
                                        node_code: node_code
                                    },
                                    method: 'post',
                                    success: function (data) {
                                        var respText = Ext.util.JSON.decode(data.responseText);
                                        if (respText.success) {
                                            //保存日志
                                            saveLog( btn.text+'名录信息','BUTTON','用户'+userCode+ btn.text+'成功');
                                            Ext.toast({
                                                html: "删除成功！",
                                                closable: false,
                                                align: 't',
                                                slideInDuration: 400,
                                                minWidth: 400
                                            });
                                            reloadGrid();
                                        } else {
                                            Ext.MessageBox.alert('提示', respText.message);
                                        }
                                    }
                                });
                            }
                        })
                    }
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
                handler: function (btn) {
                    doWorkFlow(btn);
                }
            },
            {
                xtype: 'button',
                text: '导入',
                hidden : false,
                name: 'import',
                icon: '/image/sysbutton/import.png',
                handler: function () {
                    window_mlxzdr.show();
                }
            },
            {
              xtype:'button',
              text:'模板下载',
              icon:'/image/sysbutton/download.png',
              handler:function(){
                  downloadTemplete();
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
                text: '撤销送审',
                name: 'cancel',
                icon: '/image/sysbutton/cancel.png',
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
                        $.ajax({
                            type : "post",
                            url : "/rzpt/mlgl/getMlxx.action",
                            data: {
                                    MLXX_ID : ml_id,
                                    AG_ID: records.items[0].data.AG_ID,
                                    AG_CODE:records.items[0].data.AG_CODE,
                                    AD_CODE:records.items[0].data.AD_CODE
                                  },
                            async : false,
                            success : function(data){
                                var result = Ext.util.JSON.decode(data).data[0];
                                window_mlxz.show();
                                window_mlxz.window.down('form').getForm().setValues(result);
                                if (result.IS_SJQR == '1') {
                                    Ext.ComponentQuery.query('checkboxfield[name="IS_SJQR"]')[0].setValue('1');
                                }
                                if (result.IS_MLW == '1') {
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
                text: '删除',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    var records = DSYGrid.getGrid('contentGrid').getSelectionModel().getSelection();
                    if (records < 1) {
                        Ext.MessageBox.alert('提示', '请选择一条记录后再进行操作！');
                    } else {
                        Ext.Msg.confirm('提示', '请确认是否删除！', function (button) {
                            if (button == 'yes') {
                                var ids = [];
                                Ext.Array.forEach(records, function (r) {
                                    ids.push(r.get("ML_ID"));
                                });
                                Ext.Ajax.request({
                                    url: '/rzpt/mlgl/deleteMlxx.action',
                                    params: {
                                        ids: ids,
                                        WF_STATUS: WF_STATUS,
                                        wf_id: wf_id,
                                        node_code: node_code
                                    },
                                    method: 'post',
                                    success: function (data) {
                                        var respText = Ext.util.JSON.decode(data.responseText);
                                        if (respText.success) {
                                            //保存日志
                                            saveLog( btn.text+'名录信息','BUTTON','用户'+userCode+ btn.text+'成功');
                                            Ext.toast({
                                                html: "删除成功！",
                                                closable: false,
                                                align: 't',
                                                slideInDuration: 400,
                                                minWidth: 400
                                            });
                                            reloadGrid();
                                        } else {
                                            Ext.MessageBox.alert('提示', respText.message);
                                        }
                                    }
                                });
                            }
                        })
                    }
                }
            },
            {
                xtype: 'button',
                text: '送审',
                name: 'down',
                icon: '/image/sysbutton/submit.png',
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
   // var ZGDW = mlxzFormValues.getForm().findField("ZGDW").value;
    //Ext.Msg.alert('提示', ZGDW);
    //获取组织机构代码组件
    var result = '';
    // var field_ZZJG_CODE=mlxzForm.query('[name="ZZJG_CODE"]')[0];
    var xydm = mlxzFormValues['TYSHXY_CODE'];
    if(xydm && xydm.toLocaleString() == 'null'){
        result += "统一社会信用代码不能为空";
    }
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
        }/*,
        {
            dataIndex: "RDQK_ID", type: "string", text: "认定情况", width: 350,
            renderer: function (value, metaData, rd) {
                var record = rzpt_mlxx_rdqk_store.findRecord('id', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        }*/
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
            pageNum: true,//不显示设置显示每页条数
            pageSize: 20// 每页显示数据数
        },
        tbar: [
            {
                xtype: 'combobox',
                fieldLabel: '状态',
                itemId: 'contentGrid_status',
                name: 'contentGrid_status',
                store: DebtEleStore(json_debt_zt1),
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
                        reloadGrid();
                    }
                }
            }
        ],
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
//创建名录信息导入弹出窗口
var window_mlxzdr = {
    window: null,
    config: {
        closeAction: 'destroy'
    },
    show: function () {
        if (!this.window || this.config.closeAction == 'destroy') {

            this.window = initWindow_mlxzdr();
        }
        this.window.show();
    }
};
//初始化导入窗口
function initWindow_mlxzdr() {
    var buttons = [{
        xtype : 'button',
        name : 'save',
        text : '上传',
        handler : function (btn) {
            button_name = btn.text;
            mlxxUpload(btn);
        }
    },{
        xtype : 'button',
        name : 'cancel',
        text : '取消',
        handler : function (btn) {
            btn.up('window').close();
        }
    }];
    return Ext.create('Ext.window.Window',{
        name : 'window_mlxxdr',
        title : '名录信息导入',
        width: document.body.clientWidth * 0.9, // 窗口宽度
        height: document.body.clientHeight * 0.9, // 窗口高度
        layout: 'fit',
        maximizable: true,
        buttonAlign: 'right',
        buttons : buttons,
        items : [initmlxxdrform()],
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy'//hide:单击关闭图标后隐藏，可以调用show()显示。如果是close，则会将window销毁。
    });
}
//初始化导入名录信息form
function initmlxxdrform() {
    return Ext.create('Ext.form.Panel',{
        labelWidth: 70,
        fileUpload: true,
        defaultType: 'textfield',
        layout :'fit',
        items: [
            initUploadGrid()
        ]
    });
}
//初始化导入名录信息表格
function initUploadGrid(){
    var headerJson = [
        {"dataIndex": "AG_CODE", "type": "string", "text":"单位编码"},
        {"dataIndex": "AG_NAME", "type": "string", "text":"单位名称"},
        {"dataIndex": "AD_CODE", "type": "string", "text":"所属行政区划编码","width": 180},
        {"dataIndex": "AD_NAME", "type": "string", "text":"所属行政区划名称","width": 180},
        {"dataIndex": "ZGDW", "type": "string", "text": "主管单位", "width": 180},
        {"dataIndex": "ZGDWLX_ID", "type": "string", "text": "单位类型", "width": 180},
        {"dataIndex": "TYSHXY_CODE", "type": "string", "text": "统一社会信用代码", "width": 170},
        {"dataIndex": "FRDB_NAME", "type": "string", "text": "法人代表姓名", "width": 120},
        {"dataIndex": "FRDB_TEL", "type": "string", "text": "法人代表联系电话", "width": 160}
    ];
    var grid = DSYGrid.createGrid({
        itemId : 'mlxxdr_grid',
        border: false,
        flex: 1,
        headerConfig: {
            columnCls:'normal',
            headerJson: headerJson,
            columnAutoWidth: false
        },
        data : [],
        autoLoad : false,
        pageConfig:{
            enablePage : false //禁用翻页
        }

    });
    grid.addDocked({
        xtype: 'toolbar',
        layout: 'column',
        items: [
            {
                xtype: 'label',
                margin: '4 0 0 0',
                text:'请选择上传文件：'

            },
            {
                xtype: 'filefield',
                buttonText: '名录信息导入',
                name: 'upload',
                width: 125,
                buttonOnly: true,
                hideLabel: true,
                buttonConfig: {
                    width: 125,
                    icon: '/image/sysbutton/report.png'
                },
                listeners: {
                    change: function (fb, v) {
                        var form = this.up('form').getForm();
                        uploadXeExcelFile(form);
                    }
                }
            },
            {
                xtype: 'button',
                itemId: 'xedrDelBtn',
                text: '删行',
                width: 60,
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('window').down('grid');
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
        grid.up('window').down('#xedrDelBtn').setDisabled(!records.length);
    });
    return grid;
}
//上传文件
var excelHeader = {'AG_CODE':'*单位编码','AG_NAME':'*单位名称','AD_CODE':'*所属行政区划编码', 'AD_NAME':'*所属行政区划名称', 'ZGDW':'*主管单位','ZGDWLX_ID':'*单位类型', 'TYSHXY_CODE':'*统一社会信用代码','FRDB_NAME':'*法人代表姓名','FRDB_TEL':'*法人代表联系电话'};
function uploadXeExcelFile(form){
    if(form.isValid()){
        form.submit({
            url: '/importExcel.action',
            params: {
                excelHeader: Ext.JSON.encode(excelHeader)
            },
            timeout:600000,//请求超时10分钟
            waitTitle: '请等待',
            waitMsg: '正在导入中...',
            success: function (form, action) {
                var columnStore = action.result.data.list;
                var grid = DSYGrid.getGrid('mlxxdr_grid');
                columnStore = Ext.Array.filter(columnStore,function(item){
                    if(item.AG_CODE!=null&&item.AG_CODE!=''){
                        //处理解析后的编码出现小数形式
                        item.AG_CODE = Ext.util.Format.number(item.AG_CODE, '##00');
                        item.AD_CODE = Ext.util.Format.number(item.AD_CODE, '##00');
                        return true;
                    }else{
                        return false;
                    }
                });
                grid.getStore().removeAll();
                grid.insertData(null, columnStore);
            },
            failure: function (form, action) {
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
}
//名录模板下载
function downloadTemplete(){
    window.location.href = 'downloadTemplate.action?file_name='+encodeURI(encodeURI("单位名录模板.xlsx"));
}
/**
 * 数据上传
 * @param btn
 */
function mlxxUpload(btn){
    var grid = btn.up('window').down('grid');
    var store = grid.getStore();
    var mlxxArray = [];
    store.getData().each(function(record){
        mlxxArray.push(record.data);
    });
    if(mlxxArray.length<=0){
        Ext.Msg.alert('提示','没有有效的数据进行上传！');
        return;
    }
    //对数据进行必录校验
    var res = checkUploadedMlxx(mlxxArray);
    if(res.failure){
        Ext.Msg.alert('提示',res.msg);
        return;
    }
    //上传信息
    sendMlxx(mlxxArray,btn);
}
/**
 * 对上传的名录信息进行第一次校验
 * 1.必录项不能为空
 * 2.单位编码必须是三位数字多重组合
 * 3.行政区划必须是两位数字多重组合
 * 4.统一社会信用码必须是18位
 * 5.电话号码格式校验
 * @param mlxxArray
 */
function checkUploadedMlxx(mlxxArray){
    var errorMsg = '';
    var res = {'failure':false,'msg':''};
    var tyCodeArray = [];
    var agCodeArray = [];
    for(var i = 0;i<mlxxArray.length;i++){
        var record = mlxxArray[i];
        for(var key in record){
            var value = record[key];
            value = (typeof value === 'string')?value.trim():value;
            //1.必录项校验
            if(value==''||value==null){
                errorMsg = '单位['+record['AG_NAME']+']的"'+excelHeader[key].substring(1)+'"不能为空！';
                break;
            }
            //2.单位编码必须是三位数字多重组合
            if("AG_CODE"==key){
                if(NaN==parseInt(value) || !/^([123456789]\d{2})(\d{3})*$/.test(value)){
                    errorMsg = '单位编码"'+value+'"不符合规范！';
                    break;
                }else if($.inArray(value,agCodeArray)!=-1){ //通过校验后判断code是否重复
                    errorMsg = '单位['+record['AG_NAME']+']重复导入名录信息！';
                    break;
                }else{
                    agCodeArray.push(value);
                }
            }
            //行政区划必须是两位数字多重组合
            if("AD_CODE"==key){
                if(NaN==parseInt(value) || !/^([123456]\d)(\d{2})*$/.test(value)){
                    errorMsg = '所属区划编码"'+value+'"不符合规范！';
                    break;
                }
            }
            //统一社会信用码校验
            if("TYSHXY_CODE"==key){
                if(!/(^[A-Z0-9-]{8}$)|(^[A-Z0-9-]{9}$)|(^[A-Z0-9-]{10}$)|(^[A-Z0-9]{18}$)/.test(value)){
                    errorMsg = '统一社会信用代码"'+value+'"不符合规范！';
                    break;
                }else
               if($.inArray(value,tyCodeArray)!=-1){ //通过校验后判断code是否重复
                    errorMsg = '单位'+record['AG_NAME']+'的统一社会信用代码"'+value+'"重复！';
                    break;
                }
                else{
                    tyCodeArray.push(value);
                }
            }
            //电话号码格式校验
            if("FRDB_TEL"==key){
                if(!/^(?:0[0-9]{2,3}[-\\s]{1}|\\(0[0-9]{2,4}\\))[0-9]{6,8}$|^[1-9]{1}[0-9]{5,7}$|^[1-9]{1}[0-9]{10}$/.test(value)){
                    errorMsg = '电话号码"'+value+'"不符合规范！';
                    break;
                }
            }
            record[key] = value;
        }
        //单位编码必须是三位数字多重组合
        if(errorMsg!=''){
            res.failure = true;
            res.msg = errorMsg;
            return res;
        }
    }
    return res;
}
function sendMlxx(mlxxArray,btn){
    //将数组转为json串
    var mlxxJson = Ext.JSON.encode(mlxxArray);
    mlxxJson = mlxxJson.replaceAll(":null,",":\"\",");
    Ext.Msg.wait('上传中，请稍后……','提示');
    btn.setDisabled(true);
    Ext.Ajax.request({
        method:'POST',
        url:'/rzpt/mlgl/checkAndInsert.action',
        params:{
            mlxx:mlxxJson,
            button_name:button_name,
            wf_id:wf_id,
            node_code:node_code,
            wf_status:'001'
        },
        timeout:600000,
        success:function(response){
            var data = Ext.JSON.decode(response.responseText);
            if(data.success){
                Ext.Msg.hide();
                Ext.toast({
                    html:'上传'+data.num+'条数据！成功：'+data.numYX+'条，无效数据：'+data.numWX+'条！'+(!!data.wxReason?('</br>'+data.wxReason):''),
                    title:'提示',
                    minWidth:300,
                    closable:false,
                    align:'t',
                    slideInDuration: 400,
                });
                btn.up('window').close();
            }else{
                Ext.Msg.alert('提示',data.msg);
                btn.setDisabled(false);
            }
            reloadGrid();
        },
        failure:function(response){
            Ext.Msg.alert('提示','上传失败！'+response.status);
            btn.setDisabled(false);
        }
    });
}