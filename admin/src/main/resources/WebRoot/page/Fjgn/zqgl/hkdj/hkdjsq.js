var start_year=new Date().getFullYear();
var start_month= new Date().getMonth()+1<10?"0"+(new Date().getMonth()+1):new Date().getMonth()+1;
var end_year=new Date().getFullYear();
var end_month= new Date().getMonth()+1<10?"0"+(new Date().getMonth()+1):new Date().getMonth()+1;
var year=new Date().getFullYear();
var lastyear=new Date().getFullYear()-1;
var nextyear=new Date().getFullYear()+1;
var yearJson = [
                 {id: lastyear, code: lastyear, name: lastyear+"年"},
                 {id: year, code: year, name: year+"年"},
                 {id: nextyear, code: nextyear, name: nextyear+"年"}
             ];
             //转换store
             var store_year=DebtEleStoreNoSort(yearJson);


$.extend(json_common, {
    items: {
        '001': [
            {
                xtype: 'button',
                text: '查询',
                icon: '/image/sysbutton/search.png',
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '导入',
                name: 'add',
                icon: '/image/sysbutton/regist.png',
                handler: function (btn) {
                	start_year=new Date().getFullYear();
                    start_month= new Date().getMonth()+1<10?"0"+(new Date().getMonth()+1):new Date().getMonth()+1;
                	end_year=new Date().getFullYear();
                	end_month= new Date().getMonth()+1<10?"0"+(new Date().getMonth()+1):new Date().getMonth()+1;
                	onItemUpload();
                }
            },
            {
                xtype:'button',
                text:'模板下载',
                icon:'/image/sysbutton/download.png',
                handler:function () {
                    downloadHKTemplate();
                }
            },
            {
                name: 'sure',
                xtype: 'button',
                text: '确认',
                icon: '/image/sysbutton/edit.png',
                handler: function (btn) {
                    button_name = btn.name;
                    button_text = btn.text;
                    delete_main_grid();
                }
            },
            {
                xtype: 'button',
                text: '删除',
                name: 'del',
                icon: '/image/sysbutton/delete.png',
                handler: function (btn) {
                    button_name = btn.name;
                    button_text = btn.text;
                    delete_main_grid();
                }
            },
            {
                xtype: 'button',
                text: '查看',
                name: 'view',
                icon: '/image/sysbutton/sum.png',
                handler: function () {
                    var url = '/WebReport/ReportServer?reportlet=gxdz%2Fzj%2FDEBT_T_KJJK_JFQK.cpt&adcode='+AD_CODE;
                    if(FR_DEPLOYMENT_MODE=='1'){
                        url= url.replaceAll("/WebReport","");
                    }
                    window.open(url);
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
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
                handler: function () {
                    reloadGrid();
                }
            },
            {
                xtype: 'button',
                text: '撤销确认',
                itemId: 'cancel',
                name: 'cancel_cx',
                icon: '/image/sysbutton/cancel.png',
                handler: function (btn) {
                    button_name = btn.name;
                    button_text = btn.text;
                    delete_main_grid();
                }
            },
            {
                xtype: 'button',
                text: '操作记录',
                name: 'btn_log',
                icon: '/image/sysbutton/log.png',
                handler: function () {
                    dooperation();
                }
            },
            '->',
            initButton_OftenUsed(),
            initButton_Screen()
        ]
    },
    items_content_tree: function () {
        return [
            initContentTree_area()//初始化左侧区划树
        ];
    }

});


function downloadHKTemplate () {
    window.location.href = 'downloadZdtemplate.action?file_name='+encodeURI(encodeURI("会计核算接口还款信息导入模板.xlsx"));
}

function delete_main_grid() {
    var grid = DSYGrid.getGrid('contentGrid');
    var sm = grid.getSelectionModel().getSelection();
    if (sm.length < 1) {     //是否选择了有效的债券
        Ext.toast({
            html: "请选择至少一条数据后再进行操作!",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    }else if(sm.length>=1){
        var bills=new Array();
        for(var i=0;i<sm.length;i++){
            var temp=new Object();
            temp['HKDJ_ID']=sm[i].get("HKDJ_ID");
            bills.push(temp);
        }

        Ext.MessageBox.show({
            title: "提示",
            msg: "是否"+button_text+"?",
            width: 200,
            buttons: Ext.MessageBox.OKCANCEL,
            fn: function (buttonId) {
                if (buttonId === "ok") {
                    Ext.Ajax.request({
                        method : 'POST',
                        url : "/doSaveHkdj.action",
                        params : {
                            BILLS:Ext.util.JSON.encode(bills),
                            OPERATE:button_name,
                            USER_AD_CODE:USER_AD_CODE,
                            IS_DXTX:IS_DXTX
                        },
                        async : false,
                        success : function(response, options) {
                            var respText = Ext.util.JSON.decode(response.responseText);
                            if(respText.success){
                                toast_util(button_text,true);
                                reloadGrid();
                            }else{
                                toast_util(button_text,false,respText);
                            }
                        },
                        failure : function(response, options) {
                        }
                    });
                }
            }
        });
    }

}

function initGridBjMain() {
    var headerJson = [
		{
		    xtype: 'rownumberer', summaryType: 'count', width: 45,
		    summaryRenderer: function () {
		        return '合计';
		    }
		},
        {"dataIndex": "HKDJ_ID", "type": "string", "text": "还款登记ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'
        },
        {"dataIndex": "HKJH_ID", "type": "string", "text": "还款计划ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_ID", "type": "string", "text": "债券ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_NAME", "type": "string", "text": "债券名称", "width": 200, tdCls: 'grid-cell-unedit'},
        {"dataIndex": "AD_CODE", "type": "string", "text": "AD_CODE", "width": 150,hidden:true,
            tdCls: 'grid-cell-unedit'},
        {'dataIndex':"AD_NAME",'type':"string",'text':"所属地区",width:150,tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_CODE", "type": "string", "text": "债券编码", "width": 175,
            tdCls: 'grid-cell-unedit' },
        {"dataIndex": "PM_RATE", "type": "string", "text": "票面利率(%)", "width": 150,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "PLAN_TYPE", "type": "string", "text": "还款类型", "width": 150,hidden:true,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "DQ_DATE", "type": "string", "text": "到期日期", "width": 150,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZJLY_ID", "type": "string", "text": "资金来源", "width": 175,
            tdCls: 'grid-cell-unedit',hidden:true},
        {"dataIndex": "ZJLY_NAME", "type":"string", "text":"资金来源", "width": 175,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "SJCH_DATE", "type": "string", "text": "实际偿还日期", "width": 150,
            tdCls: 'grid-cell-unedit'},
        {
            "dataIndex": "DQ_AMT", "type": "float", "text": "到期金额", "width": 200,
        tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SYYH_AMT", "type": "float", "text": "剩余应还金额", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_AMT", type: "float", text: '<span class="required">✶</span>登记金额', width: 200,summaryType: 'sum',
            editor: {
                xtype: 'numberfield',
                allowDecimals: true,
                minValue:0,
                decimalPrecision: 2,
                editable: true
                
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value, meta, record) {
                meta.tdCls = record.get('IS_SPLIT')==0 ? 'kjjk-grid-cell' : 'grid-cell';
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SY_CHBJ_AMT", "type": "float", "text": "剩余偿还本金金额", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {"dataIndex": "IS_SPLIT", "type": "string", "text": "是否自动分配", "width": 150,hidden:true}

    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'BJMainGrid_MX',
        border: false,
        flex: 1,
        data: [],
        checkBox: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'hkdj_grid_plugin_cell',
                clicksToMoveEditor: 1,
                    listeners: {
                        'beforeedit': function (editor, context) {
                        },
                        'validateedit': function (editor, context) {
                            if (context.field == 'PAY_AMT') {
                                if (context.value > context.record.get('SYYH_AMT')){
                                    Ext.MessageBox.alert('提示','登记金额不能大于剩余还款金额!');
                                    return false;
                                }
                            }
                        },
                        'edit':function (editor,context) {
                            if (context.field == 'PAY_AMT') {
                                var value$1=context.value;
                                context.record.set("SY_CHBJ_AMT",context.record.get("SYYH_AMT")-value$1);
                            }
                            //去掉编辑状态
                            DSYGrid.getGrid('BJMainGrid_MX').getStore().commitChanges();
                        }
                    }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;

}


function initGridLxMain() {
    var headerJson = [
		{
		    xtype: 'rownumberer', summaryType: 'count', width: 45,
		    summaryRenderer: function () {
		        return '合计';
		    }
		},
        {"dataIndex": "HKDJ_ID", "type": "string", "text": "还款登记ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'
        },
        {"dataIndex": "HKJH_ID", "type": "string", "text": "还款计划ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_ID", "type": "string", "text": "债券ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_NAME", "type": "string", "text": "债券名称", "width": 200, tdCls: 'grid-cell-unedit'},
        {"dataIndex": "AD_CODE", "type": "string", "text": "AD_CODE", "width": 150,hidden:true,
            tdCls: 'grid-cell-unedit'},
        {'dataIndex':"AD_NAME",'type':"string",'text':"所属地区",width:150,hidden:false,tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_CODE", "type": "string", "text": "债券编码", "width": 175,
            tdCls: 'grid-cell-unedit' },
        {"dataIndex": "PM_RATE", "type": "string", "text": "票面利率(%)", "width": 150,hidden:false,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "PLAN_TYPE", "type": "string", "text": "还款类型", "width": 150,hidden:true,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "DQ_DATE", "type": "string", "text": "到期日期", "width": 150,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZJLY_ID", "type": "string", "text": "资金来源", "width": 175,
            tdCls: 'grid-cell-unedit',hidden:true},
        {"dataIndex": "ZJLY_NAME", "type":"string", "text":"资金来源", "width": 175,
            tdCls: 'grid-cell-unedit',hidden:false},
        {"dataIndex": "SJCH_DATE", "type": "string", "text": "实际偿还日期", "width": 150,
            tdCls: 'grid-cell-unedit'},
        {
            "dataIndex": "DQ_AMT", "type": "float", "text": "到期金额", "width": 200,
        tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SYYH_AMT", "type": "float", "text": "剩余应还金额", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_AMT", type: "float", text: '<span class="required">✶</span>登记金额', width: 200,summaryType: 'sum',
            editor: {
                xtype: 'numberfield',
                allowDecimals: true,
                minValue:0,
                decimalPrecision: 2,
                editable: true
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value, meta, record) {
                meta.tdCls = record.get('IS_SPLIT')==0 ? 'kjjk-grid-cell' : 'grid-cell';
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SY_CHLX_AMT", "type": "float", "text": "剩余偿还利息金额", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {"dataIndex": "IS_SPLIT", "type": "string", "text": "是否自动分配", "width": 150,hidden:true
        }

    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'LXMainGrid_MX',
        border: false,
        flex: 1,
        data: [],
        checkBox: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'hkdj_grid_plugin_cell',
                clicksToMoveEditor: 1,
                    listeners: {
                        'beforeedit': function (editor, context) {

                        },
                        'validateedit': function (editor, context) {
                            if (context.field == 'PAY_AMT') {
                                if (context.value > context.record.get('SYYH_AMT')){
                                    Ext.MessageBox.alert('提示','登记金额不能大于剩余还款金额!');
                                    return false;
                                }
                            }
                        },
                        'edit':function (editor,context) {
                            if (context.field == 'PAY_AMT') {
                                var value$1=context.value;
                                    context.record.set("SY_CHLX_AMT",context.record.get("SYYH_AMT")-value$1);
                            }
                            //去掉编辑状态
                            DSYGrid.getGrid('LXMainGrid_MX').getStore().commitChanges();
                        }
                    }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}


function initGridDffMain() {
    var headerJson = [
		{
		    xtype: 'rownumberer', summaryType: 'count', width: 45,
		    summaryRenderer: function () {
		        return '合计';
		    }
		},
        {"dataIndex": "HKDJ_ID", "type": "string", "text": "还款登记ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'
        },
        {"dataIndex": "HKJH_ID", "type": "string", "text": "还款计划ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_ID", "type": "string", "text": "债券ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_NAME", "type": "string", "text": "债券名称", "width": 200, tdCls: 'grid-cell-unedit'},
        {"dataIndex": "AD_CODE", "type": "string", "text": "AD_CODE", "width": 150,hidden:true,
            tdCls: 'grid-cell-unedit'},
        {'dataIndex':"AD_NAME",'type':"string",'text':"所属地区",width:150,hidden:false,tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_CODE", "type": "string", "text": "债券编码", "width": 175,
            tdCls: 'grid-cell-unedit' },
        {"dataIndex": "PM_RATE", "type": "string", "text": "票面利率(%)", "width": 150,hidden:false,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "PLAN_TYPE", "type": "string", "text": "还款类型", "width": 150,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                var store = DebtEleStore(json_debt_hklx);
                var record = store.findRecord('code', value, 0, false, true, true);
                return record != null ? record.get('name') : value;
            }
        },
        {"dataIndex": "DQ_DATE", "type": "string", "text": "到期日期", "width": 150,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZJLY_ID", "type": "string", "text": "资金来源", "width": 175,
            tdCls: 'grid-cell-unedit',hidden:true},
        {"dataIndex": "ZJLY_NAME", "type":"string", "text":"资金来源", "width": 175,
            tdCls: 'grid-cell-unedit',hidden:false},
        {"dataIndex": "SJCH_DATE", "type": "string", "text": "实际偿还日期", "width": 150,
            tdCls: 'grid-cell-unedit'},
        {
            "dataIndex": "SY_FXF_AMT", "type": "float", "text": "剩余发行费金额", "width": 200,
        	tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "PAY_FXF_AMT", type: "float", text: '<span class="required">✶</span>登记发行费金额', width: 200,summaryType: 'sum',
            editor: {
            xtype: 'numberfield',
            allowDecimals: true,
                minValue:0,
                decimalPrecision: 2,
                editable: true
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value, meta, record) {
                meta.tdCls = record.get('IS_SPLIT')==0 ? 'kjjk-grid-cell' : 'grid-cell';
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SY_TGF_AMT", "type": "float", "text": "剩余托管费金额", "width": 200,
        tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }, 
        {
            dataIndex: "PAY_TGF_AMT", type: "float", text: '<span class="required">✶</span>登记托管费金额', width: 200,summaryType: 'sum',
            editor: {
            xtype: 'numberfield',
            allowDecimals: true,
                minValue:0,
                decimalPrecision: 2,
                editable: true
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value, meta, record) {
                meta.tdCls = record.get('IS_SPLIT')==0 ? 'kjjk-grid-cell' : 'grid-cell';
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SYYH_AMT", "type": "float", "text": "剩余发行兑付费用金额", "width": 200,
            tdCls: 'grid-cell-unedit',
                renderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.00');
                }
        },
        {
            dataIndex: "PAY_AMT", type: "float", text: '<span class="required">✶</span>登记发行兑付费用金额', width: 200,summaryType: 'sum',
            editor: {
            xtype: 'numberfield',
            allowDecimals: true,
                minValue:0,
                decimalPrecision: 2,
                editable: true
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value, meta, record) {
                meta.tdCls = record.get('IS_SPLIT')==0 ? 'kjjk-grid-cell' : 'grid-cell';
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SYCH_FXF_AMT", "type": "float", "text": "剩余偿还发行费金额", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SYCH_TGF_AMT", "type": "float", "text": "剩余偿还托管费金额", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SYCH_AMT", "type": "float", "text": "剩余偿还发行兑付费用金额", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {"dataIndex": "IS_SPLIT", "type": "string", "text": "是否自动分配", "width": 150,hidden:true}

    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'DFFMainGrid_MX',
        border: false,
        flex: 1,
        data: [],
        checkBox: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'hkdj_grid_plugin_cell',
                clicksToMoveEditor: 1,
                    listeners: {
                        'beforeedit': function (editor, context) {
                        },
                        'validateedit': function (editor, context) {
                            if (context.field == 'PAY_FXF_AMT') {
                                if (context.value > context.record.get('SY_FXF_AMT')){
                                    Ext.MessageBox.alert('提示','登记发行费金额不能大于剩余发行费金额!');
                                    return false;
                                }
                            }
                            if (context.field == 'PAY_TGF_AMT') {
                                if (context.value > context.record.get('SY_TGF_AMT')){
                                    Ext.MessageBox.alert('提示','登记托管费金额不能大于剩余托管费金额!');
                                    return false;
                                }
                            }
                            if (context.field == 'PAY_AMT') {
                                if (context.value > context.record.get('SYYH_AMT')){
                                    Ext.MessageBox.alert('提示','登记发行兑付费用金额不能大于剩余发行兑付费用金额!');
                                    return false;
                                }
                            }

                        },
                        'edit':function (editor,context) {
                            if (context.field == 'PAY_FXF_AMT') {
                                var value$1=context.value;
                                    context.record.set("SYCH_FXF_AMT",context.record.get("SY_FXF_AMT")-value$1);
                            }
                            if (context.field =='PAY_TGF_AMT'){
                                var value$2=context.value;
                                    context.record.set("SYCH_TGF_AMT",context.record.get("SY_TGF_AMT")-value$2);
                            }
                            if (context.field =='PAY_AMT'){
                                var value$2=context.value;
                                    context.record.set("SYCH_AMT",context.record.get("SYYH_AMT")-value$2);
                            }
                            //去掉编辑状态
                            DSYGrid.getGrid('DFFMainGrid_MX').getStore().commitChanges();
                        }
                    }
            }
        ]
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;

}
function initDjFileMain() {
    var headerJson = [
        {
		    xtype: 'rownumberer', summaryType: 'count', width: 45,
		    summaryRenderer: function () {
		        return '合计';
		    }
		},
        {"dataIndex": "HKDJ_ID", "type": "string", "text": "还款登记id","width":150, hidden: true},
        {"dataIndex": "AD_CODE", "type": "string", "text": "地区编码", "width": 150, hidden: true},
        {"dataIndex": "AD_NAME", "type": "string", "text": "地区名称", "width": 120},
        {"dataIndex": "ZJ_KEMU", "type": "string", "text": "资金科目", "width": 150},
        {"dataIndex": "SJCH_DATE", "type": "string", "text": "实际偿还日期", "width": 150},
        {
            "dataIndex": "PAY_AMT", "type": "float", "text": "偿还金额", "width": 180,summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {"dataIndex": "JZPZ_NO", "type": "string", "text": "记账凭证号", "width": 150}
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'DJMainGrid',
        border: false,
        flex: 1,
        data: [],
        checkBox: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        dataUrl: "/getDrxxData.action",
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        }
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}

function initCfDjFileMain() {
    var headerJson = [
        {
		    xtype: 'rownumberer', summaryType: 'count', width: 45,
		    summaryRenderer: function () {
		        return '合计';
		    }
		},
        {"dataIndex": "HKDJ_ID", "type": "string", "text": "还款登记id","width":150, hidden: true},
        {"dataIndex": "AD_CODE", "type": "string", "text": "地区编码", "width": 150, hidden: true},
        {"dataIndex": "AD_NAME", "type": "string", "text": "地区名称", "width": 120},
        {"dataIndex": "ZJ_KEMU_CODE", "type": "string", "text": "科目编码", "width": 150},
        {"dataIndex": "ZJ_KEMU", "type": "string", "text": "资金科目", "width": 150},
        {"dataIndex": "SJCH_DATE", "type": "string", "text": "实际偿还日期", "width": 150},
        {
            "dataIndex": "PAY_AMT", "type": "float", "text": "偿还金额", "width": 180,summaryType: 'sum',
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value , '0,000.00');
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {"dataIndex": "JZPZ_NO", "type": "string", "text": "记账凭证号", "width": 150}
    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'CfDJMainGrid',
        border: false,
        flex: 1,
        data: [],
        checkBox: false,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        //dataUrl: "/getDrxxData.action",
        features: [{
            ftype: 'summary'
        }],
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        }
    };
    //生成表格
    var grid = DSYGrid.createGrid(config);
    return grid;
}
var window_djsure={
	    window: null,
	    btn: null,
	    config: {
	        closeAction: 'destroy'
	    },
	    show: function (config, btn) {
	        $.extend(this.config, config);
	        if (!this.window || this.config.closeAction == 'destroy') {
	            this.window = initwindow_djsure();
	        }
	        this.window.show();
	    }
	};
function initwindow_djsure() {
    var djTab = Ext.create('Ext.tab.Panel', {
        itemId: 'djTab',
        anchor: '100% -17',
        border: false,
        items: [
            {
                title: '本金',
                layout: 'fit',
                itemId: 'bj_form_panel',
                items: initGridBjMain()
            },
            {
                title: '利息',
                layout: 'fit',
                itemId: 'lx_form_panel',
                items: initGridLxMain()
            },
            {
                title: '发行兑付费用',
                layout: 'fit',
                itemId: 'dff_form_panel',
                items: initGridDffMain()
            },
            {
                title: '导入信息',
                layout: 'fit',
                items: initDjFileMain()
            },
            {
                title: '导入重复信息',
                layout: 'fit',
                items: initCfDjFileMain()
            }

        ]
    });
    var djPanel=Ext.create('Ext.form.Panel', {
        itemId: 'dj_form_panel',
        width: '100%',
        height: '100%',
        layout: 'vbox',
        defaults: {
            width: '100%',
            margin: '2 0 2 5'
        },
        items: [
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 2 5',
                    columnWidth: .25,
                    labelWidth: 60//控件默认标签宽度
                },
                items: [
					{
					    xtype:'textfield',
					    fieldLabel: '文件名称',
					    name: 'Input_File',
					    readOnly: true,
					    labelAlign: 'right',
					    fieldStyle: 'background:#E6E6E6'
					},
					{
					    xtype:'textfield',
					    fieldLabel: '导入日期',
					    name: 'Input_Date',
					    readOnly: true,
					    labelAlign: 'right',
					    fieldStyle: 'background:#E6E6E6'
					
					},
					{
					    xtype:'textfield',
					    fieldLabel: '导入用户',
					    name: 'Input_User',
					    readOnly: true,
					    labelAlign: 'right',
					    fieldStyle: 'background:#E6E6E6'
					
					},
					{
					    xtype:"textfield",
					    fieldLabel:'导入批次',
					    itemId: 'PC_NO',
					    name:'PC_NO',
					    readOnly: true,
					    labelAlign: 'right',
					    fieldStyle: 'background:#E6E6E6'
					},
	                {
	                     xtype: 'treecombobox',
	                     fieldLabel: '地区',
	                     itemId: 'QH2',
	                     displayField: 'name',
	                     valueField: 'code',
	                     editable:false,
	                     rootVisible: true,
	                     lines: false,
	                     selectModel: 'all',
	                     labelAlign: 'right',
						 hidden:true,
	                     store: DebtEleTreeStoreDBTable("DSY_V_ELE_AD",{condition:" and code like '"+AD_CODE+"%' AND SUBSTR(CODE,LENgth(CODE)-1,LENgTH(CODE)) !='00'"})
	                    /* listeners: {
	                        change: function (self, newValue) {
	                        	if(undefined == newValue){
	                        		return false;
	                        	}else {
	                                var store = Ext.ComponentQuery.query('grid[itemId="DFFMainGrid_MX"]')[0].getStore();
	                                var pc_no = Ext.ComponentQuery.query('textfield#PC_NO')[0].getValue();
	                                Ext.Ajax.request({
	                                    url: 'getAllDataByPc.action',
	                                    params: {
	                                    	QH: newValue,
	                                    	PC_NO: pc_no
	                                    },
	                                    method: 'post',
	                                    success: function (data) {
	                                        var responseText = Ext.util.JSON.decode(data.responseText);
	                                        if (responseText.success) {
	                                            setDataHandleByQh(responseText.list);
	                                        } else {
	                                            Ext.MessageBox.alert('提示', responseText.message);
	                                        }
	                                    }
	                                });
	                        	}
	                        }
	                    }*/
	                 },
                    {
                        xtype:'textfield',
                        fieldLabel: '开始日期',
                        name: 'START_DATE',
                        readOnly: true,
                        labelAlign: 'right',
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype:'textfield',
                        fieldLabel: '截至日期',
                        name: 'END_DATE',
                        readOnly: true,
                        labelAlign: 'right',
                        fieldStyle: 'background:#E6E6E6'
                    },
                    
                    {
                        xtype:"textfield",
                        fieldLabel:'还款单号',
                        name:'HK_NO',
                        labelAlign: 'right',
                        allowBlank:false
                    },
                    {
                        fieldLabel: '资金科目',
                        xtype: 'combobox',
                        name: 'ZJKM',
                        editable: false,
                        displayField: 'name',
                        valueField: 'name',
                        store: DebtEleStore(json_debt_zjkm),
                        multiSelect : true,
                        labelAlign: 'right',
					    hidden:true,
                        listeners: {
                        	change: function (self, newValue) {
                               /* var store = Ext.ComponentQuery.query('grid[itemId="DJMainGrid"]')[0].getStore();
                                var pc_no = Ext.ComponentQuery.query('textfield#PC_NO')[0].getValue();
                                Ext.Ajax.request({
                                    url: 'getDrxxData.action',
                                    params: {
                                    	ZJKM:  Ext.util.JSON.encode(newValue),
                                    	PC_NO: pc_no
                                    },
                                    method: 'post',
                                    success: function (data) {
                                        var responseText = Ext.util.JSON.decode(data.responseText);
                                        if (responseText.success) {
                                            var DRGrid = DSYGrid.getGrid('DJMainGrid');
                                            DRGrid.getStore().removeAll();
                                            DRGrid.getStore().insertData(null, responseText.list);
                                        } else {
                                            Ext.MessageBox.alert('提示', responseText.message);
                                        }
                                    }
                                });*/
                            }
                        }
                    }
                ]
            },
            {
                xtype: 'fieldset',
                title: '还款计划匹配结果  （<span class="required">✶</span>黄色单元格为自动匹配金额,绿色单元格为未匹配金额;均允许编辑）',
                flex:1,
                collapsible: false,
                layout: 'fit',
                items: [ djTab]
            }
        ]
    });
 return Ext.create('Ext.window.Window', {
        title: '登记信息（单位：元）', // 窗口标题
        width: document.body.clientWidth * 0.95, // 窗口宽度
        height: document.body.clientHeight * 0.97, // 窗口高度
        layout: 'fit',
        maximizable: true,//最大最小化
        itemId: 'window_select2', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: djPanel,
        buttons: [
            {
                text: '保存',
                name: "save",
                handler: function (btn) {
                    button_name=btn.name;
                    doSubmit(btn);
                }
            },
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}

function doSubmit(btn) {
    //导入信息panel
    var DJMainGrid_store = Ext.ComponentQuery.query('grid[itemId="DJMainGrid"]')[0].getStore().getData();
    //本金gird
    var BJMainGrid_MX_store = Ext.ComponentQuery.query('grid[itemId="BJMainGrid_MX"]')[0].getStore().getData();
    //利息gird
    var LXMainGrid_MX_store = Ext.ComponentQuery.query('grid[itemId="LXMainGrid_MX"]')[0].getStore().getData();
    //发行兑付费用gird
    var DFFMainGrid_MX_store = Ext.ComponentQuery.query('grid[itemId="DFFMainGrid_MX"]')[0].getStore().getData();
    
    var form_var=Ext.ComponentQuery.query('form[itemId="dj_form_panel"]')[0];
    var MAIN_FILE=form_var.getForm().getFieldValues();
    var QH2=Ext.ComponentQuery.query('treecombobox[itemId="QH2"]')[0].getValue();
    var hk_no = Ext.ComponentQuery.query('textfield[name="HK_NO"]')[0].getValue();
    
    var mian_array=new Array();
    var bjObject=new Array();
    var lxObject=new Array();
    var dffObject=new Array();
    var bj_array=new Array();
    var lx_array=new Array();
    var dff_array=new Array();
    var data_main="";
    var bj_djamt=0;
    var lx_djamt=0;
    var dff_djamt=0;
    var ad_bj_djamt=0;
    var ad_lx_djamt=0;
    var ad_dff_djamt=0;
    var start="";
    var end="";
    var msg="";
    
    if(start_month.toString().charAt(0)=='0'){
        start=start_year.toString()+"年"+start_month.toString().charAt(1)+"月";
    }else{
    	start=start_year.toString()+"年"+start_month.toString()+"月";
    }
    if(end_month.toString().charAt(0)=='0'){
        end=end_year.toString()+"年"+end_month.toString().charAt(1)+"月";
    }else{
    	end=end_year.toString()+"年"+end_month.toString()+"月";
    }
      
    //导入信息按资金科目分组
    for (var i = 0; i < DJMainGrid_store.length; i++) {
        var record = DJMainGrid_store.items[i];
        data_main=record.data;
        mian_array.push(data_main);
        if("本金" == data_main.ZJ_KEMU){
    		bj_array.push(data_main);
        }
        if("利息" == data_main.ZJ_KEMU){
    		lx_array.push(data_main);
        }
        if("发行兑付费用" == data_main.ZJ_KEMU){
        	dff_array.push(data_main);
        }
    }
    

    

   var bj_obj ={};
   var lx_obj ={};
   var dff_obj ={};
   var bjmx_obj ={};
   var lxmx_obj ={};
   var dffmx_obj ={};
   var jhbj_amt=0;
   var jhlx_amt=0;
   var jhdff_amt=0;
    //校验资金科目为本金的同一个地区的实际偿还金额是否超出  bj_obj = {3301: 3000, 330122: 7000, 330127: 5000}
    for(var j = 0; j < bj_array.length; j++){
        if(bj_obj[bj_array[j].AD_NAME]){
        	if(bj_obj[bj_array[j].AD_NAME]){
        		bj_obj[bj_array[j].AD_NAME] += bj_array[j].PAY_AMT;
        	}else{
        		bj_obj[bj_array[j].AD_NAME] = bj_array[j].PAY_AMT;
        	}
        }else{
        	bj_obj[bj_array[j].AD_NAME] = bj_array[j].PAY_AMT;
        }
    }	
    
    for(var j = 0; j < lx_array.length; j++){
        if(lx_obj[lx_array[j].AD_NAME]){
        	if(lx_obj[lx_array[j].AD_NAME]){
        		lx_obj[lx_array[j].AD_NAME] += lx_array[j].PAY_AMT;
        	}else{
        		lx_obj[lx_array[j].AD_NAME] = lx_array[j].PAY_AMT;
        	}
        }else{
        	lx_obj[lx_array[j].AD_NAME] = lx_array[j].PAY_AMT;
        }
    }
    
    for(var j = 0; j < dff_array.length; j++){
        if(dff_obj[dff_array[j].AD_NAME]){
        	if(dff_obj[dff_array[j].AD_NAME]){
        		dff_obj[dff_array[j].AD_NAME] += dff_array[j].PAY_AMT;
        	}else{
        		dff_obj[dff_array[j].AD_NAME] = dff_array[j].PAY_AMT;
        	}
        }else{
        	dff_obj[dff_array[j].AD_NAME] = dff_array[j].PAY_AMT;
        }
    }
    
    //循环本金列表  {地区:{计划id：还款计划金额}}
    for (var i = 0; i < BJMainGrid_MX_store.length; i++) {
        var record = BJMainGrid_MX_store.items[i];
        if(bjmx_obj[record.data.AD_NAME]){
        	if(bjmx_obj[record.data.AD_NAME][record.data.PLAN_ID]){
        		if(bjmx_obj[record.data.AD_NAME][record.data.PLAN_ID].toFixed(2) - record.data.SYYH_AMT.toFixed(2) > 0){
        			bjmx_obj[record.data.AD_NAME][record.data.PLAN_ID]=bjmx_obj[record.data.AD_NAME][record.data.PLAN_ID];
        		}else{
        			bjmx_obj[record.data.AD_NAME][record.data.PLAN_ID] = record.data.SYYH_AMT;
        		}
        	}else{
        		bjmx_obj[record.data.AD_NAME][record.data.PLAN_ID] = record.data.SYYH_AMT;
        	}
        }else{
        	bjmx_obj[record.data.AD_NAME] = {};
        	bjmx_obj[record.data.AD_NAME][record.data.PLAN_ID] = record.data.SYYH_AMT;
        }
	 }
    
  //循环利息列表  {地区:{计划id：还款计划金额}}
    for (var i = 0; i < LXMainGrid_MX_store.length; i++) {
        var record = LXMainGrid_MX_store.items[i];
        if(lxmx_obj[record.data.AD_NAME]){
        	if(lxmx_obj[record.data.AD_NAME][record.data.PLAN_ID]){
        		if(lxmx_obj[record.data.AD_NAME][record.data.PLAN_ID].toFixed(2) - record.data.SYYH_AMT.toFixed(2) > 0){
        			lxmx_obj[record.data.AD_NAME][record.data.PLAN_ID]= lxmx_obj[record.data.AD_NAME][record.data.PLAN_ID];
        		}else{
        			lxmx_obj[record.data.AD_NAME][record.data.PLAN_ID] = record.data.SYYH_AMT;
        		}
        	}else{
        		lxmx_obj[record.data.AD_NAME][record.data.PLAN_ID] = record.data.SYYH_AMT;
        	}
        }else{
        	lxmx_obj[record.data.AD_NAME] = {};
        	lxmx_obj[record.data.AD_NAME][record.data.PLAN_ID] = record.data.SYYH_AMT;
        }
	 }  
    
  //循环发行兑付费用列表  {地区:{计划id：还款计划金额}}
    for (var i = 0; i < DFFMainGrid_MX_store.length; i++) {
        var record = DFFMainGrid_MX_store.items[i];
        if(dffmx_obj[record.data.AD_NAME]){
        	if(dffmx_obj[record.data.AD_NAME][record.data.PLAN_ID]){
        		if(dffmx_obj[record.data.AD_NAME][record.data.PLAN_ID].toFixed(2) - (record.data.SY_FXF_AMT+record.data.SY_TGF_AMT+record.data.SYYH_AMT).toFixed(2) > 0){
        			dffmx_obj[record.data.AD_NAME][record.data.PLAN_ID] = dffmx_obj[record.data.AD_NAME][record.data.PLAN_ID];
        		}else{
                	dffmx_obj[record.data.AD_NAME][record.data.PLAN_ID] = record.data.SY_FXF_AMT+record.data.SY_TGF_AMT+record.data.SYYH_AMT;
        		}
        	}else{
            	dffmx_obj[record.data.AD_NAME][record.data.PLAN_ID] = record.data.SY_FXF_AMT+record.data.SY_TGF_AMT+record.data.SYYH_AMT;
        	}
        }else{
        	dffmx_obj[record.data.AD_NAME] = {};
        	dffmx_obj[record.data.AD_NAME][record.data.PLAN_ID] = record.data.SY_FXF_AMT+record.data.SY_TGF_AMT+record.data.SYYH_AMT;
        }
	 }
    
    
    //bj_obj = {3301: 3000, 330122: 7000, 330127: 5000}
   /* for(i in bj_obj){
    	 var bjflag=true;
    	 if(JSON.stringify(bjmx_obj) == "{}"){
    		 msg+='地区：【'+i+'】【本金】列表，在'+start+'至'+end+'期间的无还款计划，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
    	 }else{
    		 for(j in bjmx_obj){//{3301: 2000, 330122: 7000}
        		 if(i == j){
        			 jhbj_amt =0;
        			 bjflag=false;
        			 for(k in bjmx_obj[j]){
        				 jhbj_amt += bjmx_obj[j][k];
        			 }
        			 if(bj_obj[i].toFixed(2) - jhbj_amt.toFixed(2) > 0){
        	    		 msg+='地区：【'+i+'】【本金】列表，在'+start+'至'+end+'期间的还款计划金额合计'+jhbj_amt.toFixed(2)+'元小于实际偿还金额合计'+bj_obj[i].toFixed(2)+'元，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
        			 }
        	     }
        	 }
        	 if(bjflag){
        		 msg+='地区：【'+i+'】【本金】列表，在'+start+'至'+end+'期间的无还款计划，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
        	 }
    	 }
    }
    	
    
    for(i in lx_obj){
    	 var lxflag=true;
    	 if(JSON.stringify(lxmx_obj) == "{}"){
    		 msg+='地区：【'+i+'】【利息】列表，在'+start+'至'+end+'期间的无还款计划，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
    	 }else{
    		 for(j in lxmx_obj){
    	   		 if(i == j){
    	   			 jhlx_amt =0;
    	   			 lxflag=false;
	    	   		 for(k in lxmx_obj[j]){
	    	   			jhlx_amt += lxmx_obj[j][k];
	       			 }
    	   			 if(lx_obj[i].toFixed(2) - jhlx_amt.toFixed(2) > 0){
    	   	    		 msg+='地区：【'+i+'】【利息】列表，在'+start+'至'+end+'期间的还款计划金额合计'+jhlx_amt.toFixed(2)+'元小于实际偿还金额合计'+lx_obj[i].toFixed(2)+'元，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
    	   			 }
    	   	    }
    	   	 }
    	   	 if(lxflag){
        		 msg+='地区：【'+i+'】【利息】列表，在'+start+'至'+end+'期间的无还款计划，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
        	 }
    	 }
   }  
    
    
    for(i in dff_obj){
    	 var dffflag=true;
    	 if(JSON.stringify(dffmx_obj) == "{}"){
    		 msg+='地区：【'+i+'】【发行兑付费用】列表，在'+start+'至'+end+'期间的无还款计划，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
    	 }else{
    		 for(j in dffmx_obj){
          		 if(i == j){
          			 jhdff_amt = 0;
          			 dffflag=false;
          			 for(k in dffmx_obj[j]){
          				jhdff_amt += dffmx_obj[j][k];
	       			 }
          			 if(dff_obj[i].toFixed(2) - jhdff_amt.toFixed(2) > 0){
          	    		 msg+='地区：【'+i+'】【发行兑付费用】列表，在'+start+'至'+end+'期间的还款计划金额合计'+jhdff_amt.toFixed(2)+'元小于实际偿还金额合计'+dff_obj[i].toFixed(2)+'元，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
          			 }
          	    }
          	 }
          	if(dffflag){
       		 msg+='地区：【'+i+'】【发行兑付费用】列表，在'+start+'至'+end+'期间的无还款计划，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
       	    }
    	 }
   }  
    
    if(hk_no==undefined || hk_no==null ||hk_no.trim()==""){
        Ext.MessageBox.alert('提示',"还款单号不允许为空！");
        return false;
    }
    if(msg!=null && msg!=""){
        Ext.MessageBox.alert('提示',msg);
        return false;
    }
    
    
    
    //校验资金科目为本金的同一个地区且实际偿还日期相同的实际偿还金额金额是否超出
    for(var j = 0; j < bj_array.length; j++){
    	bj_djamt=0;
    	 for (var i = 0; i < BJMainGrid_MX_store.length; i++) {
 	        var record = BJMainGrid_MX_store.items[i];
 	        if(bj_array[j].AD_CODE == record.data.AD_CODE && bj_array[j].SJCH_DATE == record.data.SJCH_DATE){
 	        	bj_djamt += record.data.PAY_AMT;
 	        }
    	 }
    	 if(bj_array[j].PAY_AMT.toFixed(2) - bj_djamt.toFixed(2) > 0){
    		 msg+='地区：【'+bj_array[j].AD_NAME+'】【'+bj_array[j].ZJ_KEMU+'】列表，在'+start+'至'+end+'期间实际偿还日期为'+bj_array[j].SJCH_DATE+'的登记金额合计'+bj_djamt.toFixed(2)+'元小于实际偿还日期为'+bj_array[j].SJCH_DATE+'的实际偿还金额合计'+bj_array[j].PAY_AMT.toFixed(2)+'元，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
      	}
    	 if(bj_djamt.toFixed(2) - bj_array[j].PAY_AMT.toFixed(2) > 0 ){
    		 msg+='地区：【'+bj_array[j].AD_NAME+'】【'+bj_array[j].ZJ_KEMU+'】列表，在'+start+'至'+end+'期间实际偿还日期为'+bj_array[j].SJCH_DATE+'的登记金额合计'+bj_djamt.toFixed(2)+'元大于实际偿还日期为'+bj_array[j].SJCH_DATE+'的实际偿还金额合计'+bj_array[j].PAY_AMT.toFixed(2)+'元，请重新填写登记金额！'+'<br>';
      	}
    }
    
    
    for(var k = 0; k < lx_array.length; k++){
    	lx_djamt=0;
    	 for (var i = 0; i < LXMainGrid_MX_store.length; i++) {
 	        var record = LXMainGrid_MX_store.items[i];
 	        if(lx_array[k].AD_CODE == record.data.AD_CODE && lx_array[k].SJCH_DATE == record.data.SJCH_DATE){
 	        	lx_djamt += record.data.PAY_AMT;
 	        }
    	 }
    	 if(lx_array[k].PAY_AMT.toFixed(2) - lx_djamt.toFixed(2) >0){
    		 msg+='地区：【'+lx_array[k].AD_NAME+'】【'+lx_array[k].ZJ_KEMU+'】列表，在'+start+'至'+end+'期间实际偿还日期为'+lx_array[k].SJCH_DATE+'的登记金额合计'+lx_djamt.toFixed(2)+'元小于实际偿还日期为'+lx_array[k].SJCH_DATE+'的实际偿还金额合计'+lx_array[k].PAY_AMT.toFixed(2)+'元，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
      	}
    	 if(lx_djamt.toFixed(2) - lx_array[k].PAY_AMT.toFixed(2) >0 ){
    		 msg+='地区：【'+lx_array[k].AD_NAME+'】【'+lx_array[k].ZJ_KEMU+'】列表，在'+start+'至'+end+'期间实际偿还日期为'+lx_array[k].SJCH_DATE+'的登记金额合计'+lx_djamt.toFixed(2)+'元大于实际偿还日期为'+lx_array[k].SJCH_DATE+'的实际偿还金额合计'+lx_array[k].PAY_AMT.toFixed(2)+'元，请重新填写登记金额！'+'<br>';
      	}
    }
    
    for(var m = 0; m < dff_array.length; m++){
    	dff_djamt=0;
    	 for (var i = 0; i < DFFMainGrid_MX_store.length; i++) {
 	        var record = DFFMainGrid_MX_store.items[i];
 	        if(dff_array[m].AD_CODE == record.data.AD_CODE && dff_array[m].SJCH_DATE == record.data.SJCH_DATE){
 	 	        dff_djamt += record.data.PAY_FXF_AMT+record.data.PAY_TGF_AMT+record.data.PAY_AMT;
 	        }
    	 }
    	 if(dff_array[m].PAY_AMT.toFixed(2) - dff_djamt.toFixed(2) > 0){
    		 msg+='地区：【'+dff_array[m].AD_NAME+'】【'+dff_array[m].ZJ_KEMU+'】列表，在'+start+'至'+end+'期间实际偿还日期为'+dff_array[m].SJCH_DATE+'的登记金额合计'+dff_djamt.toFixed(2)+'元小于实际偿还日期为'+dff_array[m].SJCH_DATE+'的实际偿还金额合计'+dff_array[m].PAY_AMT.toFixed(2)+'元，请重新选择开始日期或结束日期或修改导入信息！'+'<br>';
      	}
    	 if(dff_djamt.toFixed(2) - dff_array[m].PAY_AMT.toFixed(2) > 0 ){
    		 msg+='地区：【'+dff_array[m].AD_NAME+'】【'+dff_array[m].ZJ_KEMU+'】列表，在'+start+'至'+end+'期间实际偿还日期为'+dff_array[m].SJCH_DATE+'的登记金额合计'+dff_djamt.toFixed(2)+'元大于实际偿还日期为'+dff_array[m].SJCH_DATE+'的实际偿还金额合计'+dff_array[m].PAY_AMT.toFixed(2)+'元，请重新填写登记金额！'+'<br>';
      	}
    }*/
    
    var bj_array=new Array();
    for (var i = 0; i < BJMainGrid_MX_store.length; i++) {
        var record = BJMainGrid_MX_store.items[i];
        if(record.data.PAY_AMT !=0 ){
        	 bj_array.push(record.data);
        }
    }
    
    var lx_array=new Array();
    for (var i = 0; i < LXMainGrid_MX_store.length; i++) {
        var record = LXMainGrid_MX_store.items[i];
        if(record.data.PAY_AMT !=0 ){
        	lx_array.push(record.data);
       }
    }
    
    var dff_array=new Array();
    for (var i = 0; i < DFFMainGrid_MX_store.length; i++) {
        var record = DFFMainGrid_MX_store.items[i];
        if(record.data.PAY_AMT !=0 || record.data.PAY_FXF_AMT !=0 || record.data.PAY_TGF_AMT !=0){
        	dff_array.push(record.data);
       }
    }


   
    
    /*if(msg!=null && msg!=""){
        Ext.MessageBox.alert('提示',msg);
        return false;
    }*/
    /*if(QH2!=undefined || QH2!=null ||QH2.trim()!=""){
        Ext.MessageBox.alert('提示',"表单地区查询条件请置空再保存");
        return false;
    }*/
   /* Ext.MessageBox.show({
        title: '提示',
        msg: '是否保存？',
        width:320,
        defaultTextHeight :180,
        buttons: Ext.Msg.OKCANCEL,
        fn:function (btn_confirm,msgs) {
            if (btn_confirm == 'ok') {*/
                Ext.Ajax.request({
                    url : '/doSaveHkdj.action',
                    params : {
                        MAIN_DATA: Ext.util.JSON.encode(mian_array),
                        BJ_DATA  : Ext.util.JSON.encode(bj_array),
                        LX_DATA  : Ext.util.JSON.encode(lx_array),
                        DFF_DATA  : Ext.util.JSON.encode(dff_array),
                        MAIN_FILE: Ext.util.JSON.encode(MAIN_FILE),
                        OPERATE:button_name,
                        USER_AD_CODE:USER_AD_CODE,
                        AD_CODE:AD_CODE
                    },
                    method : 'post',
                    success : function(data) {
                        var respText =Ext.util.JSON.decode(data.responseText);
                        if(respText.success){
                            Ext.toast({
                                html: "保存成功！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            reloadGrid();
                        }else{
                            Ext.MessageBox.alert('提示',"保存失败！"+respText.message);
                        }
                        btn.up('window').close();
                    },
                    failure : function () {
                        Ext.Msg.alert('提示','保存失败!');
                    }
                });
           /* }else{
                return false;
            }
        } ,
        animateTarget: 'addAddressBtn',
        icon: Ext.window.MessageBox.WARNING
    });*/
}

function setDataHandle(data) {
    //导入信息
    var DJMainGrid = Ext.ComponentQuery.query('grid[itemId="DJMainGrid"]')[0];
    //重复导入信息
    var CFDJMainGrid = Ext.ComponentQuery.query('grid[itemId="CfDJMainGrid"]')[0];
    //本金gird
    var BJMainGrid_MX  = Ext.ComponentQuery.query('grid[itemId="BJMainGrid_MX"]')[0];
    //利息gird
    var LXMainGrid_MX  = Ext.ComponentQuery.query('grid[itemId="LXMainGrid_MX"]')[0];
    //发行兑付费用gird
    var DFFMainGrid_MX  = Ext.ComponentQuery.query('grid[itemId="DFFMainGrid_MX"]')[0];
   
    if(data!=null&&data!=undefined){
        if(data.length>=1){
            var drxx=data[0][0];
            drxx = drxx['基本信息'];
            if(drxx!=null&&drxx!=""&&drxx!=undefined){
            	var drxx6=data[5];
            	DJMainGrid.getStore().removeAll();
            	DJMainGrid.insertData(null, drxx6);
            }
            var drxx2=data[1];
            BJMainGrid_MX.getStore().removeAll();
            BJMainGrid_MX.insertData(null, drxx2);
            
            var drxx3=data[2];
            LXMainGrid_MX.getStore().removeAll();
            LXMainGrid_MX.insertData(null, drxx3);
           
            var drxx4=data[3];
            DFFMainGrid_MX.getStore().removeAll();
            DFFMainGrid_MX.insertData(null, drxx4);
           
            var drxx5=data[4];
            var DJform=Ext.ComponentQuery.query('form[itemId="dj_form_panel"]')[0].getForm();
            //form表单赋值
            var start="";
            var end="";
            if(start_month.toString().charAt(0)=='0'){
                start=start_year.toString()+"年"+start_month.toString().charAt(1)+"月";
            }else{
            	start=start_year.toString()+"年"+start_month.toString()+"月";
            }
            if(end_month.toString().charAt(0)=='0'){
                end=end_year.toString()+"年"+end_month.toString().charAt(1)+"月";
            }else{
            	end=end_year.toString()+"年"+end_month.toString()+"月";
            }
            DJform.findField("START_DATE").setValue(start);
            DJform.findField("END_DATE").setValue(end);
            DJform.findField("Input_File").setValue(drxx5[0].FILE_NAME);
            DJform.findField("Input_User").setValue(drxx5[0].UPLOAD_USER);
            DJform.findField("Input_Date").setValue(drxx5[0].UPLOAD_DATE);
            DJform.findField("PC_NO").setValue(drxx5[0].PC_NO);
            DJform.findField("HK_NO").setValue(drxx5[0].HK_NO);
            
            var drxx7=data[6];
           /* if(drxx7.length > 0){
        		Ext.Msg.alert('提示','Excel数据有重复导入信息,请查看导入重复信息页签!');
        	}*/
            CFDJMainGrid.getStore().removeAll();
            CFDJMainGrid.insertData(null, drxx7);
        }
    }
}

function setDataHandleByQh(data) {
    //right_panel
    var DJMainGrid = Ext.ComponentQuery.query('grid[itemId="DJMainGrid"]')[0];
    //本金gird
    var BJMainGrid_MX  = Ext.ComponentQuery.query('grid[itemId="BJMainGrid_MX"]')[0];
    //利息gird
    var LXMainGrid_MX  = Ext.ComponentQuery.query('grid[itemId="LXMainGrid_MX"]')[0];
    //发行兑付费用gird
    var DFFMainGrid_MX  = Ext.ComponentQuery.query('grid[itemId="DFFMainGrid_MX"]')[0];
    
    DJMainGrid.getStore().removeAll();
    BJMainGrid_MX.getStore().removeAll();
    LXMainGrid_MX.getStore().removeAll();
    DFFMainGrid_MX.getStore().removeAll();
    
    if(data!=null&&data!=undefined){
        if(data.length>=1){
            var drxx=data[4];
            for(var d in drxx){
                var mx=drxx[d];
                DJMainGrid.insertData(null,mx);
            }
            var drxx2=data[0];
            for(var j=0;j<drxx2.length;j++){
                var drxx_bjmx=drxx2[j];
                BJMainGrid_MX.insertData(null,drxx_bjmx);
            }
            
            var drxx3=data[1];
            for(var k=0;k<drxx3.length;k++){
                var drxx_lxmx=drxx3[k];
                LXMainGrid_MX.insertData(null,drxx_lxmx);
            }
            
            var drxx4=data[2];
            for(var m=0;m<drxx4.length;m++){
                var drxx_dffmx=drxx4[m];
                DFFMainGrid_MX.insertData(null,drxx_dffmx);
            }
        }
    }
}

//new 导入方法
function onItemUpload() {
        var FileRname = new Ext.form.TextField({
            name : 'FileRname',
            fieldLabel : '文件名',
            allowBlank : false,
            emptyText : '发布用于显示的文件名',
            anchor:'95%'
        });
        var AddfileForm=new Ext.FormPanel(
            {
                name : 'AddfileForm',
                frame : true,
                labelWidth : 50,
                url : '../../uploadFiel.jspa',
                fileUpload : true,
                width : 500,
                autoDestroy : true,
                bodyStyle : 'padding:0px 10px 0;',
                region: 'center',
                layout: {
                    type: 'vbox',
                    align: 'stretch',
                    flex: 1
                },
                defaults: {
                    margin: '10 5 2 2',
                    width: 10,
                    labelWidth: 50,//控件默认标签宽度
                    labelAlign: 'left'//控件默认标签对齐方式
                },
                border: false,
                dockedItems: [
                    {
                        xtype: 'toolbar',
                        fieldLabel : '偿还属期',
                        dock: 'top',
                        layout: {
                            type: 'hbox'
                        },
                        defaults: {
                            //margin: '2 2 2 2',
                            width: 18,
                            labelWidth: 5,//控件默认标签宽度
                            labelAlign: 'left'//控件默认标签对齐方式
                        },
                        items: [
                            //{xtype: 'label', text: '缴款 :', style: {'float': 'right'}},
                            {
                            xtype: 'combobox',
                            fieldLabel: '缴款信息实际偿还区间',
                            //margin: '9,4,30,4',
                            name: 'start_year',
                            itemId: 'start_year',
                            displayField: 'name',
                            valueField: 'code',
                            editable: false,
                            allowBlank: false,
                            width: 250,
                            autoLoad: false,
                            selectModel: "leaf",
                            labelWidth: 150,//控件默认标签宽度
                            store:store_year,
                            value: start_year,
                            listeners: {
    	                        change: function (self, newValue) {
    	                        	start_year=newValue;
    	                        }
                            }
                        }, {xtype: 'label', text: '年', margin: '9,4,30,4',labelWidth:60},
                            {
                                xtype: 'combobox',
                                margin: '9,4,30,4',
                                name: 'start_month',
                                itemId: 'start_month',
                                displayField: 'name',
                                valueField: 'id',
                                editable: false,
                                allowBlank: false,
                                width: 62,
                                autoLoad: false,
                                selectModel: "leaf",
                                labelWidth: 10,//控件默认标签宽度
                                store: DebtEleStore(json_debt_yf_nd),
                                value: start_month,
                        		listeners: {
        	                        change: function (self, newValue) {
        	                        	start_month=newValue;
        	                        }
                                } 		
                            }, {xtype: 'label', text: '月', margin: '9,4,30,4',labelWidth:10},
                            {xtype: 'label', text: '至', margin: '9,4,30,4',labelWidth:10},
                            {
                                xtype: 'combobox',
                                margin: '9,4,30,4',
                                name: 'end_year',
                                itemId: 'end_year',
                                displayField: 'name',
                                valueField: 'id',
                                editable: false,
                                allowBlank: false,
                                width: 102,
                                autoLoad: false,
                                selectModel: "leaf",
                                labelWidth: 60,//控件默认标签宽度
                                store:store_year,
                                value: end_year,
                                listeners: {
        	                        change: function (self, newValue) {
        	                        	end_year=newValue;
        	                        }
                                }
                            }, {xtype: 'label', text: '年', margin: '9,4,30,4'},
                            {
                                xtype: 'combobox',
                                margin: '9,4,30,4',
                                name: 'end_month',
                                itemId: 'end_month',
                                displayField: 'name',
                                valueField: 'id',
                                editable: false,
                                allowBlank: false,
                                width:62 ,
                                autoLoad: false,
                                selectModel: "leaf",
                                labelWidth: 10,//控件默认标签宽度
                                store: DebtEleStore(json_debt_yf_nd),
                                value: end_month,
                        		listeners: {
        	                        change: function (self, newValue) {
        	                        	end_month=newValue;
        	                        }
                                } 
                            }, {xtype: 'label', text: '月', margin: '9,4,30,4'}
                        ]
                    }
                ],
                items: [
                    {
                    xtype : 'filefield',
                    emptyText : '选择上传文件,支持文件类型xls或xlsx',
                    fieldLabel : '文件',
                    itemId: "uploady1",
                    name: 'upload',
                    buttonText : '',
                    buttonConfig: {
                        icon: '/image/sysbutton/projectnew.png',
                        style:{
                            "border-color":'#D8D8D8',
                            background:'#f6f6f6'
                        }
                    },
                    listeners : {
                    	change: function (fb, v) {
                    		var that = this;
                    	    file = that.fileInputEl.dom.files[0];
                        	var form = this.up('form');
                            var dataUrl = form.getForm().findField('upload').getValue();
                            var arr = dataUrl.split('.');
                            var fileType = arr[arr.length - 1].toLowerCase();
                            if (fileType != 'xls' && fileType != 'xlsx') {
                                Ext.MessageBox.alert('提示', '不允许选择该类型文件，请重新选择！');
                                return;
                            }
                        }
                    }
                }]
            });
        var AddfileWin=new Ext.Window(
            {
                name : 'AddfileWin',
                width: document.body.clientWidth * 0.66, // 窗口宽度
                height: document.body.clientHeight * 0.4, // 窗口高度
                layout : 'fit',
                closeAction : 'close',
                title : '上传文件',
                buttonAlign : 'center',
                resizable : true,
                modal : true,
                autoDestroy : true,
                items : AddfileForm,
                buttons :[{
                    text : '确认',
                    handler : function() {
                        if(!(start_year==null||start_year==undefined||start_year=="") && !(start_month==null||start_month==undefined||start_month=="")&&!(end_year==null||end_year==undefined||end_year=="")&&!(end_month==null||end_month==undefined||end_month=="")){
                        	if(start_year.toString()+start_month.toString() > end_year.toString()+end_month.toString()){
                        		Ext.Msg.alert('提示', '开始年月不能大于截至年月！');
                                return;
                        	} 
                        }
                    	
                        if (AddfileForm.getForm().isValid()) {
                            Ext.MessageBox.show({
                                title : '请稍等...',
                                msg : '文件上传中...',
                                progressText : '',
                                width : 300,
                                progress : true,
                                closable : false,
                                animEl : 'loding'
                            });
                            AddfileForm.getForm().submit({
                                clientValidation: false,
                                url: '/hkdjImportFile.action',
                                waitTitle: '请等待',
                                waitMsg: '正在导入中...',
                                params: {
                                    AD_CODE: AD_CODE,
                                    start_year:start_year,
                                    start_month:start_month,
                                    end_year:end_year,
                                    end_month:end_month,
                                    USER_AD_CODE:USER_AD_CODE
                                },
                                success: function (form, action) {
                                    if (!action.result.success ) {
                                        Ext.MessageBox.show({
                                            title: '提示',
                                            msg: '导入失败！<br>' + (action.result.MESSAGE ? action.result.MESSAGE : ''),
                                            maxWidth: 550,
                                            minWidth: 200,
                                            buttons: Ext.Msg.OK,
                                            fn: function (btn) {
                                            }
                                        });
                                    }else{
                                    	 var array=new Array();
                                    	 array=action.result.data; 
                                    	 var uploadFileName=action.result.uploadFileName;
                                    	 var msg= action.result.message;
                                    	if(action.result.message != ""){
                                            Ext.MessageBox.confirm('提示', formatStr(msg), function (button) { 
                                                if (button == 'yes') {
                                                    Ext.Ajax.request({
                                                        url: 'contineImportFile.action',
                                                        params: {
                                                            AD_CODE: AD_CODE,
                                                            start_year:start_year,
                                                            start_month:start_month,
                                                            end_year:end_year,
                                                            end_month:end_month,
                                                            USER_AD_CODE:USER_AD_CODE,
                                                            uploadFileName:uploadFileName,
                                                            data: Ext.util.JSON.encode(array)
                                                        },
                                                        method: 'post',
                                                        async: false,
                                                        success: function (data) {
                                                            var respText = Ext.util.JSON.decode(data.responseText);
                                                            if (respText.success) {
                                                                if (respText.success) {
                                                                	 Ext.toast({
                                                                         html: '导入成功',
                                                                         closable: false,
                                                                         align: 't',
                                                                         slideInDuration: 400,
                                                                         minWidth: 400
                                                                     });
                                                                     AddfileWin.close();
                                                                     reloadGrid();
                                                                } else {
                                                                    Ext.MessageBox.alert('提示', '导入失败！');
                                                                }
                                                            } else {
                                                                Ext.MessageBox.alert('提示', respText.message);
                                                            }
                                                        }
                                                    });
                                                }else{
                                                	AddfileWin.close();
                                                }
                                            });
                                    	}else{
                                    	    Ext.Ajax.request({
                                    	        url: 'contineImportFile.action',
                                    	        params: {
                                    	            AD_CODE: AD_CODE,
                                    	            start_year:start_year,
                                    	            start_month:start_month,
                                    	            end_year:end_year,
                                    	            end_month:end_month,
                                    	            USER_AD_CODE:USER_AD_CODE,
                                    	            uploadFileName:uploadFileName,
                                    	            data: Ext.util.JSON.encode(array)
                                    	        },
                                    	        method: 'post',
                                    	        async: false,
                                    	        success: function (data) {
                                    	            var respText = Ext.util.JSON.decode(data.responseText);
                                    	            if (respText.success) {
                                    	                if (respText.success) {
                                    	                	 Ext.toast({
                                    	                         html: '导入成功',
                                    	                         closable: false,
                                    	                         align: 't',
                                    	                         slideInDuration: 400,
                                    	                         minWidth: 400
                                    	                     });
                                    	                     AddfileWin.close();
                                    	                     reloadGrid();
                                    	                } else {
                                    	                    Ext.MessageBox.alert('提示', '导入失败！');
                                    	                }
                                    	            } else {
                                    	                Ext.MessageBox.alert('提示', respText.message);
                                    	            }
                                    	        }
                                    	    });
                                    	}

                                       
                                    }
                                },failure: function (form, action) {
                                    var result = Ext.util.JSON.decode(action.response.responseText);
                                    Ext.Msg.alert('提示', "导入失败！" + result && result.message ? result.message : '请检查Excel文件后重新导入');
                                }
                            });
                        }
                    }
                }, {
                    text : '重置',
                    handler : function() {
                        AddfileForm.getForm().reset();
                    }
                }, {
                    text : '关闭',
                    handler : function() {
                        AddfileWin.close();
                    }
                } ]
            });
        AddfileWin.show();
    }

function formatStr(str) 
{ 
str=str.replaceAll("\n","<br/>"); 
return str; 
} 
