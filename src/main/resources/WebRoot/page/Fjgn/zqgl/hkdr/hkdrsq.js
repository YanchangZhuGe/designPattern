var is_fix=0;   //
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
                    window_rqsq.show();

                }
            },
            {
                xtype:'button',
                text:'模板下载',
                icon:'/image/sysbutton/download.png',
                handler:function () {
                    downloadHKTemplate ();
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
    window.location.href = 'downloadZdtemplate.action?file_name='+encodeURI(encodeURI("还款信息导入模板.xlsx"));
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
            //animateTarget: btn,
            fn: function (buttonId) {
                if (buttonId === "ok") {
                    Ext.Ajax.request({
                        method : 'POST',
                        url : "/doSaveHkdr.action",
                        params : {
                            BILLS:Ext.util.JSON.encode(bills),
                            OPERATE:button_name
                        },
                        async : false,
                        success : function(response, options) {
                            var respText = Ext.util.JSON.decode(response.responseText);
                            if(respText.success){
                                //closewindow();
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


function FileUploadButton() {
    return {
        xtype:'form',
        itemId:'form_upload_id1',
        name:'form_upload_name1',
        //fileUpload: true,
        enctype:'multipart/form-data;charset=UTF-8',
        padding: '0 0 0 0',
        margin: '0 0 0 0',
        border: false,
        width:100,
        items:[
            {
                xtype: 'filefield',
                buttonText: '导入文件',
                itemId: "uploady1",
                name: 'upload',
                buttonOnly: true,
                width:100,
                padding: '0 0 0 0',
                margin: '0 0 0 0',
                hideLabel: true,
                listeners: {
                    change: function (fb, v) {
                        var form = this.up('form');
                        Upload_Xzzm(form,'yy',"uploady1");
                        reloadGrid();
                    }

                }
            }
        ] };
}
var CHSQ="";
function  Upload_Xzzm(form2,io_type,button_id) {
    var form=form2.getForm();
    var dataUrl = form.findField('upload').getValue();
    var arr = dataUrl.split('.');
    var fileType = arr[arr.length - 1].toLowerCase();
    if (fileType != 'xls' && fileType != 'xlsx') {
        Ext.MessageBox.alert('提示', '文件格式不正确！');
        form2.remove(button_id,true);
            form2.add(fileuploadbutton());
            form2.add(fileuploadbutton1());
        return;
    }
     CHSQ = Ext.ComponentQuery.query('combobox[itemId="chsq_id"]')[0].getValue();
    if(CHSQ==null||CHSQ==undefined||CHSQ==""){
        Ext.Msg.alert('提示', '偿还属期必须录入！');
        return;
    }
    var win2 = Ext.ComponentQuery.query('window[itemId="window_select"]')[0];
    var SQ_YEAR=new Date().getFullYear();
    form.submit({
        clientValidation: false,
        url: '/import_zdhk_file.action',
        waitTitle: '请等待',
        waitMsg: '正在导入中...',
        params: {
            AD_CODE: AD_CODE,
            SQ_YEAR: SQ_YEAR,
            SQ_MONTH: CHSQ
        },
        success: function (form, action) {
            if (!action.result.success) {
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
                Ext.toast({
                    html: '导入成功',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                var data=action.result.data;
                var base_data =action.result.base_data;
                win2.close();
                window_djsure.show();
                setDataHandle(data);
                //设置form
                var DJform=Ext.ComponentQuery.query('form[itemId="dj_form_panel"]')[0].getForm();
                //设置属期
                DJform.findField("CHSQ").setValue(SQ_YEAR+"-"+CHSQ);
                DJform.findField("Input_File").setValue(base_data.fileName);
                DJform.findField("Input_User").setValue(userName_jbr);
                DJform.findField("Input_Date").setValue(new Date());
            }
        },failure: function (form, action) {
            var result = Ext.util.JSON.decode(action.response.responseText);
            Ext.Msg.alert('提示', "导入失败！" + result && result.message ? result.message : '请检查Excel文件后重新导入');
        }
    });
}


/*  
 * @author shawn  
 * @date 2018/2/2 15:22  
 * @methodname 
 * @param  * @param null  
 * @return  
 * @discription 还款属期
  */
var window_rqsq = {
    window: null,
    btn: null,
    config: {
        closeAction: 'destroy'
    },
    show: function (config, btn) {
        $.extend(this.config, config);
        if (!this.window || this.config.closeAction == 'destroy') {
            this.window = initwindow_rqsq();
        }
        this.window.show();
    }
};
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

function initGridDjMain() {
    var headerJson = [
        {
            xtype: 'rownumberer',
            width: 55
        },
        {"dataIndex": "HKDJ_ID", "type": "string", "text": "还款登记ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'
        },
        {"dataIndex": "HKJH_ID", "type": "string", "text": "还款计划ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_ID", "type": "string", "text": "债券ID", "width": 150, hidden: true,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_NAME", "type": "string", "text": "债券名称", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (data, cell, record) {
                var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID='+record.get('ZQ_ID')+'&AD_CODE='+AD_CODE;
                return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';
            }},
        {"dataIndex": "AD_CODE", "type": "string", "text": "AD_CODE", "width": 150,hidden:true,
            tdCls: 'grid-cell-unedit'},
        {'dataIndex':"AD_NAME",'type':"string",'text':"所属地区",width:150,hidden:false,tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZQ_CODE", "type": "string", "text": "债券编码", "width": 175,
            tdCls: 'grid-cell-unedit' },
        {"dataIndex": "PM_RATE", "type": "string", "text": "票面利率(%)", "width": 150,hidden:false,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "PLAN_TYPE_NAME", "type": "string", "text": "还款类型", "width": 150,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "DF_END_DATE", "type": "string", "text": "到期日期", "width": 150,
            tdCls: 'grid-cell-unedit'},
        {"dataIndex": "ZJLY_ID", "type": "string", "text": "资金来源", "width": 175,
            tdCls: 'grid-cell-unedit',hidden:true},
        {"dataIndex": "ZJLY_NAME", "type":"string", "text":"资金来源", "width": 175,
            tdCls: 'grid-cell-unedit',hidden:false},
        {
            "dataIndex": "PLAN_AMT", "type": "float", "text": "到期金额", "width": 200,
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
            "dataIndex": "SYDFF_AMT", "type": "float", "text": "剩余兑付费金额", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },

        {
            dataIndex: "CHBX_AMT", type: "float", text: "登记金额", width: 200,
            tdCls: 'grid-cell',
            editor: {
                xtype: 'numberfield',
                allowDecimals: true,
                minValue:0,
                decimalPrecision: 2,
                editable: true
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            dataIndex: "CHDFF_AMT", type: "float", text: "登记兑付费金额", width: 200,
            tdCls: 'grid-cell',
            editor: {
            xtype: 'numberfield',
            allowDecimals: true,
                minValue:0,
                decimalPrecision: 2,
                editable: true
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SY_CHBX_AMT", "type": "float", "text": "剩余偿还本金金额", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SY_CHDFF_AMT", "type": "float", "text": "剩余偿还兑付费金额", "width": 200,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SY_DJF", "type": "float", "text": "剩余登记金额", "width": 200,hidden:false,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "SY_DJF_DF", "type": "float", "text": "剩余登记兑付金额", "width": 200,hidden:false,
            tdCls: 'grid-cell-unedit',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }

    ];
    /**
     * 设置表格属性
     */
    var config = {
        itemId: 'DJMainGrid_MX',
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
                            if (context.field == 'CHBX_AMT') {
                                if (context.value > context.record.get('SYYH_AMT')){
                                    Ext.MessageBox.alert('提示','登记金额不能大于剩余还款金额!');
                                    return false;
                                }
                            }
                            if (context.field == 'CHDFF_AMT') {
                                if (context.value > context.record.get('SYDFF_AMT')){
                                    Ext.MessageBox.alert('提示','登记兑付费金额不能大于剩余兑付费金额!');
                                    return false;
                                }
                            }

                        },
                        'edit':function (editor,context) {
                            if (context.field == 'CHBX_AMT') {
                                var value$1=context.value;
                                //if(value$1!=null&&value$1!=undefined&&value$1!=""){
                                    context.record.set("SY_CHBX_AMT",context.record.get("SYYH_AMT")-value$1);
                                //}
                            }
                            if (context.field =='CHDFF_AMT'){
                                var value$2=context.value;
                                //if(value$2!=null&&value$2!=undefined&&value$2!=""){
                                    context.record.set("SY_CHDFF_AMT",context.record.get("SYDFF_AMT")-value$2);
                               // }
                            }
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
            xtype: 'rownumberer',
            width: 55
        },
        {"dataIndex": "HKDJ_ID", "type": "string", "text": "还款登记id","width":150, hidden: true},
        {"dataIndex": "AD_CODE", "type": "string", "text": "地区编码", "width": 150, hidden: true},
        {"dataIndex": "AD_NAME", "type": "string", "text": "地区名称", "width": 120},
        {
            "dataIndex": "CHBX_AMT", "type": "float", "text": "本息金额", "width": 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "CHDFF_AMT", "type": "float", "text": "兑付费金额", "width": 180,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "CHSY_AMT", "type": "float", "text": "登记剩余金额", "width": 180,hidden:true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        },
        {
            "dataIndex": "DFFSY_AMT", "type": "float", "text": "登记剩余兑付费金额", "width": 180,hidden:true,
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00');
            }
        }

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
function initwindow_djsure() {
    var djTab = Ext.create('Ext.tab.Panel', {
        itemId: 'djTab',
        anchor: '100% -17',
        border: false,
        items: [
            {
                title: '还款信息',
                layout: 'fit',
                scrollable: true,
                items: initGridDjMain()
            },
            {
                title: '导入信息',
                layout: 'fit',
                scrollable: true,
                items: initDjFileMain()
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
                    columnWidth: .33,
                    labelWidth: 90//控件默认标签宽度
                },
                items: [
                    {
                        xtype:'datefield',
                        fieldLabel: '偿还属期',
                        name: 'CHSQ',
                        readOnly: true,
                        format:'Y-m',
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype:'textfield',
                        fieldLabel: '文件名称',
                        name: 'Input_File',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'
                    },
                    {
                        xtype:'textfield',
                        fieldLabel: '导入用户',
                        name: 'Input_User',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'

                    },
                    {
                        xtype:'datefield',
                        fieldLabel: '导入日期',
                        name: 'Input_Date',
                        format:'Y-m-d',
                        readOnly: true,
                        fieldStyle: 'background:#E6E6E6'

                    },
                    {
                        xtype:"textfield",
                        fieldLabel:'还款单号',
                        name:'HK_NO',
                        allowBlank:false
                    }
                ]
            },
            {
                xtype: 'container',
                flex:1,
                collapsible: false,
                layout: 'fit',
                items: [
                    djTab
                ]
            }
        ]
    });
 return Ext.create('Ext.window.Window', {
        title: '登记信息', // 窗口标题
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
                    if(doSave()=='ok'){
                        doSubmit(btn);
                    }else {
                        var message=doSave();
                        Ext.MessageBox.alert('提示',"保存失败:"+message);
                    }
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


function doSave() {
     var  Mx_Object=new Object();
    //right_panel
    var DJMainGrid_store = Ext.ComponentQuery.query('grid[itemId="DJMainGrid"]')[0].getStore();
    //left_grid
    var DJMainGrid_MX_store  = Ext.ComponentQuery.query('grid[itemId="DJMainGrid_MX"]')[0].getStore();
    DJMainGrid_MX_store.each(function(record){
        if(Mx_Object[record.get("HKDJ_ID")]!=null&&Mx_Object[record.get("HKDJ_ID")]!=""&&Mx_Object[record.get("HKDJ_ID")]!=undefined
        &&Mx_Object[record.get("HKDJ_ID")]!=0){
            Mx_Object[record.get("HKDJ_ID")]=parseFloat(Mx_Object[record.get("HKDJ_ID")])+parseFloat(record.get("CHBX_AMT"));
        }else{
            Mx_Object[record.get("HKDJ_ID")]=parseFloat(record.get("CHBX_AMT"));
        }
        if(Mx_Object[record.get("HKDJ_ID")+"DFF"]!=null&&Mx_Object[record.get("HKDJ_ID")+"DFF"]!=""&&Mx_Object[record.get("HKDJ_ID")+"DFF"]!=undefined
            &&Mx_Object[record.get("HKDJ_ID")+"DFF"]!=0){
            Mx_Object[record.get("HKDJ_ID")+"DFF"]=parseFloat(Mx_Object[record.get("HKDJ_ID")+"DFF"])+parseFloat(record.get("CHDFF_AMT"));
        }else{
            Mx_Object[record.get("HKDJ_ID")+"DFF"]=parseFloat(record.get("CHDFF_AMT"));
        }
    });
   var result="";
   DJMainGrid_store.each(function (record) {
        if(Mx_Object[record.get("HKDJ_ID")]!=null&&record.get("HKDJ_ID")!=undefined){
            var mx_data=Mx_Object[record.get("HKDJ_ID")];
            if(parseFloat(mx_data)>parseFloat(record.get("CHBX_AMT"))){
                result=record.get("AD_NAME")+"地区的偿还本金登记金额超限";
                return false;

            }else if(parseFloat(mx_data)<=parseFloat(record.get("CHBX_AMT"))){
                record.set('SYYH_AMT',parseFloat(record.get("CHBX_AMT"))-parseFloat(mx_data));
            }
            var mx_data2=Mx_Object[record.get("HKDJ_ID")+"DFF"];
            if(parseFloat(mx_data2)>parseFloat(record.get("CHDFF_AMT"))){
                result=record.get("AD_NAME")+"地区的偿还兑付费登记金额超限";
                return false;
            }else if(parseFloat(mx_data2)<=parseFloat(record.get("CHDFF_AMT"))){
                record.set('SYDFF_AMT',parseFloat(record.get("CHDFF_AMT"))-parseFloat(mx_data2));
            }

            Mx_Object['']=record.get("");

        }
    });
    if(result!=null&&result!=""&&result!=undefined){
        return result;
    }else{
        return "ok";
    }
};



function doSubmit(btn) {
    var mian_array=new Array();
    var DJMainGrid_store = Ext.ComponentQuery.query('grid[itemId="DJMainGrid"]')[0].getStore().getData();
    //left_grid
    var mx_array=new Array();
    var DJMainGrid_MX_store  = Ext.ComponentQuery.query('grid[itemId="DJMainGrid_MX"]')[0].getStore().getData();
    //var lsMainObject=new Object();
    var lsMxObject=new Array();
    var data_mx="";
    for (var i = 0; i < DJMainGrid_MX_store.length; i++) {
        var record = DJMainGrid_MX_store.items[i];
        data_mx=record.data;
        lsMxObject.push(data_mx.HKDJ_ID);
        mx_array.push(data_mx);
    }
    var is_add=false;
    var  baseCondition="";
    var  baseCondition2="";
    for (var j = 0; j < DJMainGrid_store.length; j++) {
        var record = DJMainGrid_store.items[j];
        var data_main=record.data;
        if($.inArray(data_main.HKDJ_ID,lsMxObject)==-1){
            is_add=false;
        }else{
            is_add=true;
        }
        // for(var k in lsMxObject){
        //     if(k==data_main.HKDJ_ID){
        //         is_add=true;
        //     }
        // }
        mian_array.push(data_main);
        if(is_add){
            baseCondition = '是否保存？';
        }else{
            var chsqa="";
            if(CHSQ.toString().charAt(0)=='0'){
                chsqa=CHSQ.toString().charAt(1)+"月";
            }else{
                chsqa=CHSQ.toString()+"月";
            }
            baseCondition2+='地区：'+data_main.AD_NAME+'在'+chsqa+'没有可用的还款计划，是否继续保存?'+'<br>';
        }
    }
    if(baseCondition2!=null&&baseCondition2!=""){
        baseCondition=baseCondition2;
    }
    Ext.MessageBox.show({
        title: '提示',
        msg: baseCondition,
        width:320,
        defaultTextHeight :180,
        buttons: Ext.Msg.OKCANCEL,
        fn:function (btn_confirm,msgs) {
            if (btn_confirm == 'ok') {
                var form_var=Ext.ComponentQuery.query('form[itemId="dj_form_panel"]')[0];
                var MAIN_FILE=form_var.getForm().getFieldValues();
                if(!form_var.isValid()){
                    Ext.MessageBox.alert('提示',"表单校验未通过！");
                    return false;
                }
                Ext.Ajax.request({
                    url : '/doSaveHkdr.action',
                    params : {
                        MAIN_DATA: Ext.util.JSON.encode(mian_array),
                        MX_DATA  : Ext.util.JSON.encode(mx_array),
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
            }else{
                return false;
            }
        } ,
        animateTarget: 'addAddressBtn',
        icon: Ext.window.MessageBox.WARNING
    });
}
/**
 * @author shawn
 * @date 2018/2/7 13:40
 * @methodname
 * @param  * @param null
 * @return
 * @discription*/
function setDataHandle(data) {
    //right_panel
    var DJMainGrid = Ext.ComponentQuery.query('grid[itemId="DJMainGrid"]')[0];
    //left_grid
    var DJMainGrid_MX  = Ext.ComponentQuery.query('grid[itemId="DJMainGrid_MX"]')[0];
    if(data!=null&&data!=undefined){
        if(data.length>=1){
            for(var i=0;i<data.length;i++){
                if(i==0){
                    var drxx=data[0][0];
                    drxx = drxx['基本信息'];
                    if(drxx!=null&&drxx!=""&&drxx!=undefined){
                        for(var d in drxx){
                            var mx=drxx[d];
                            DJMainGrid.insertData(null,mx);
                        }
                    }
                }else{
                    var drxx2=data[i];
                    for(var j=0;j<drxx2.length;j++){
                        var drxx_mx=drxx2[j];
                        DJMainGrid_MX.insertData(null,drxx_mx);
                    }
                }
            }
        }
    }
}
/*  
 * @author shawn  
 * @date 2018/2/2 15:23  
 * @methodname 
 * @param  * @param null  
 * @return  
 * @discription
  */
function initwindow_rqsq() {
    return Ext.create('Ext.window.Window', {
        title: '偿还属期选择', // 窗口标题
        width: 400, // 窗口宽度
        height: 150, // 窗口高度
        layout: 'anchor',
        maximizable: false,//最大最小化
        itemId: 'window_select', // 窗口标识
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        closeAction: 'destroy',//hide:单击关闭图标后隐藏，可以调用show()显示。如果是destroy，则会将window销毁。
        items: [{
            xtype: 'combobox',
            fieldLabel: '偿还属期',
            margin:'9,4,30,4',
            name:'chsq',
            itemId:'chsq_id',
            displayField: 'name',
            valueField: 'id',
            editable: false,
            allowBlank: false,
            width: 240,
            autoLoad: false,
            selectModel: "leaf",
            labelWidth: 60,//控件默认标签宽度
            labelAlign: 'center',
            store:DebtEleStore(json_debt_yf_nd)
        }],
        buttons: [
                FileUploadButton(),
            {
                text: '关闭',
                handler: function (btn) {
                    btn.up('window').close();
                }
            }
        ]
    });
}
















