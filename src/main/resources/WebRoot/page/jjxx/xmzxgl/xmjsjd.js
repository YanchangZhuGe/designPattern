$.extend(xmzx_json_common, {
    xmzx_headerjson: [
        {
            xtype: 'rownumberer', width: 45,
            summaryRenderer: function () {
                return '合计';
            }
        },
        {dataIndex: "ID", width: 150, type: "string", text: "唯一ID", hidden: true},
        {dataIndex: "AG_NAME", width: 150, type: "string", text: "单位名称"},
        {dataIndex: "XM_CODE", width: 150, type: "string", text: "项目编码"},
        {dataIndex: "XM_ID", type: "string", text: "项目ID", hidden: true},
        {
            dataIndex: "XM_NAME", width: 250, type: "string", text: "项目名称",
            renderer: function (data, cell, record) {
                var url='/page/debt/common/xmyhs.jsp';
                var paramNames=new Array();
                paramNames[0]="XM_ID";
                paramNames[1]="IS_RZXM";
                var paramValues=new Array();
                paramValues[0]=encodeURIComponent(record.get('XM_ID'));
                paramValues[1]=encodeURIComponent(record.get('IS_RZXM'));

                var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                return result;

            }
        },
        {dataIndex: "JDFB_DATE", width: 100, type: "string", text: "进度发布日期"},
        {dataIndex: "SCJD", width: 100, type: "string", text: "项目所处阶段", hidden: true},
        {dataIndex: "SCJD_NAME", width: 150, type: "string", text: "项目所处阶段"},
        {dataIndex: "JDBL", width: 100, type: "string", text: "进度比例%"},
        {dataIndex: "JDSM", width: 250, type: "string", text: "进度说明"},
        {dataIndex: "LX_YEAR", width: 100, type: "string", text: "立项年度"},
        {dataIndex: "JSXZ_NAME", width: 150, type: "string", text: "建设性质"},
        {dataIndex: "XMXZ_NAME", width: 150, type: "string", text: "项目性质"},
        {dataIndex: "XMLX_NAME", width: 150, type: "string", text: "项目类型"},
        {dataIndex: "BUILD_STATUS_NAME", width: 120, type: "string", text: "建设状态"},
        {
            dataIndex: "XMZGS_AMT", width: 160, type: "float", text: "项目总概算（万元）",
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.000000');
            }
        }
    ],
    dataUrl: '/findJsxmMainInfo.action',
    items_content: function () {
        return [
            initContentTree({
                areaConfig: {
                    params: {
                        CHILD: 1//区划树参数，1只显示本级，其它显示全部，默认显示全部
                    }
                }
            }),//初始化左侧树
            initContentRightPanel()//初始化右侧2个表格
        ];
    },
    window_title: '项目进度发布'
});


/**
 * 初始化项目进度发布发布主单
 */
function initWiondow_form(btn) {
    var config = {
        editable: btn.editable,
        busiId: btn.busiId
    };
    return Ext.create('Ext.form.Panel', {
        itemId: 'xmzx_form',
        width: '100%',
        height: '100%',
        layout: 'vbox',
        fileUpload: true,
        padding: '2 5 0 5',
        defaults: {
            columnWidth: .33,//输入框的长度（百分比）
            labelAlign: "right",
            width: '100%'
        },
        border: false,
        defaultType: 'textfield',
        items: [
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    labelWidth: 100//控件默认标签宽度
                },
                items: [
                    {
                        xtype: "textfield",
                        fieldLabel: '建设进度ID',
                        name: "ID",
                        value: btn.busiId,
                        hidden: true
                    },
                    {
                        xtype: "textfield",
                        fieldLabel: '项目ID',
                        name: "XM_ID",
                        editable: false,
                        hidden: true
                    },
                    {
                        xtype: "displayfield",
                        fieldLabel: '项目名称',
                        name: "XM_NAME",
                        columnWidth: .999,
                        editable: false
                    }
                ]
            },
            {   // 分割线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                defaultType: 'textfield',
                defaults: {
                    margin: '2 5 4 5',
                    columnWidth: .33,
                    labelWidth: 100
                },
                items: [
                    {
                        xtype: "datefield",
                        name: "JDFB_DATE",
                        fieldLabel: '<span class="required">✶</span>进度发布日期',
                        allowBlank: false,
                        format: 'Y-m-d',
                        value: today,
                        readOnly: btn.editable ? false : true,
                        editable: btn.editable,
                        fieldStyle: btn.editable ? 'background:#FFFFFF' : 'background:#E6E6E6'

                    },
                    {
                        fieldLabel: '<span class="required">✶</span>建设状态',
                        xtype: "treecombobox",
                        name: "SCJD",
                        rootVisible: false,
                        lines: false,
                        store: DebtEleTreeStoreDB("DEBT_XMJSZT"),
                        displayField: 'name',
                        valueField: 'id',
                        selectModel: 'leaf',
                        allowBlank: false,
                        readOnly: btn.editable ? false : true,
                        editable: btn.editable,
                        fieldStyle: btn.editable ? 'background:#FFFFFF' : 'background:#E6E6E6',
                        listeners: {
                            'change': function (self,newValue) {
                            	var START_DATE = self.up('form').getForm().findField('START_DATE_ACTUAL');
                            	var END_DATE = self.up('form').getForm().findField('END_DATE_ACTUAL');
                                var JDBL = self.up('form').getForm().findField('JDBL');
                                var JDSM = self.up('form').getForm().findField('JDSM');

                                if (newValue==00||isNull(newValue)) {
                            		START_DATE.allowBlank=true;
                            		START_DATE.setFieldLabel('实际开工日期');
                            	} else {
                            		START_DATE.allowBlank=false;
                            		START_DATE.setFieldLabel('<span class="required">✶</span>实际开工日期');
                            	}
                            	//【建设状态】选择已完工、已竣工后【进度比例】自动为100%；
                                if( newValue == 03 || newValue == 04){
                                    END_DATE.allowBlank=false;
                                    END_DATE.setFieldLabel('<span class="required">✶</span>实际完工日期');
                                    JDBL.setValue(100);
                                }else {
                                    END_DATE.allowBlank=true;
                                    END_DATE.setFieldLabel('实际完工日期');
                                    JDBL.setValue(50);
                                }
                                //选择停建、缓建后【进度说明】改为必录。
                                if( newValue == 02 || newValue == 05 ){
                                    JDSM.allowBlank=false;
                                    JDSM.setFieldLabel('<span class="required">✶</span>进度说明');
                                }else {
                                    JDSM.allowBlank=true;
                                    JDSM.setFieldLabel('进度说明');
                                }
                            }
                        }   
                    },
                    {
                        xtype: "numberFieldFormat",
                        name: "JDBL",
                        id: "JDBL",
                        fieldLabel: '<span class="required">✶</span>进度比例%',
                        allowDecimals: true,
                        decimalPrecision: 2,
                        minValue:0,
                        maxValue:100,
                        hideTrigger: true,
                        keyNavEnabled: false,
                        mouseWheelEnabled: false,
                        allowBlank: false,
                        editable: btn.editable,
                        plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                        fieldStyle: btn.editable ? 'background:#FFFFFF' : 'background:#E6E6E6'
                    },
                    {
                        xtype:'datefield',
                        name:'START_DATE_ACTUAL',
                        fieldLabel:'实际开工日期',
                        format:'Y-m-d',
                        allowBlank:true,
                        editable: btn.editable,
                        readOnly: btn.editable ? false : true,
                        fieldStyle: btn.editable ? 'background:#FFFFFF' : 'background:#E6E6E6'
                        //value: today,
                    },
                    {
                        xtype:'datefield',
                        name:'END_DATE_ACTUAL',
                        fieldLabel:'实际完工日期',
                        allowBlank:true,
                        format:'Y-m-d',
                        editable: btn.editable,
                        readOnly: btn.editable ? false : true,
                        fieldStyle: btn.editable ? 'background:#FFFFFF' : 'background:#E6E6E6'
                        //value: today,
                    },
                    {
                        xtype: "textareafield",
                        fieldLabel: '进度说明',
                        name: "JDSM",
                        columnWidth: .99,
                        allowBlank: true,
                        editable: btn.editable,
                        multiline: true,
                        maxLength:1000,//限制输入字数
                        maxLengthText:"输入内容过长，最多只能输入1000个汉字！",
                        fieldStyle: btn.editable ? 'background:#FFFFFF' : 'background:#E6E6E6'
                    }
                ]
            },
            {//确认线
                xtype: 'menuseparator',
                margin: '5 0 5 0',
                border: true
            },
            {
                title: '附件<span class="file_sum_fj" style="color: #FF0000;">(0)</span>',
                scrollable: false,
                flex: 1,
                hidden: xmzx_type == 'jsjd' ? false : true,
                name: 'xmjsjdFJ',
                xtype: 'fieldset',
                layout:'fit',
                items: [
                    {
                        xtype: 'panel',
                        layout: 'fit',
                        itemId: 'winPanel_tabPanel',
                        border: false,
                        items: initWindow_xmjd_tab_upload(config)
                    }
                ]
            }
        ]
    });
}

/**
 * 初始化建设进度页签panel的附件页签
 */
function initWindow_xmjd_tab_upload(config) {
    var busiId = config.busiId;
    var grid = UploadPanel.createGrid({
        busiType: 'JSJD',//业务类型
        busiId: busiId,//业务ID
        editable: config.editable,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_xmjdfj'
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
        if (grid.up('tabpanel') && grid.up('tabpanel').el && grid.up('tabpanel').el.dom) {
            $(grid.up('tabpanel').activeTab.el.dom).find('span.file_sum_fj').html('(' + sum + ')');
        } else if ($('span.file_sum_fj')) {
            $('span.file_sum_fj').html('(' + sum + ')');
        }
    });
    return grid;

}

/**
 * 提交基本情况数据
 * @param form
 */
function submitXmjdfb(btn) {
    //获取项目进度发布情况表单
    var xmzxForm = Ext.ComponentQuery.query('form[itemId="xmzx_form"]')[0];
    if (!xmzxForm.isValid()) {
        Ext.toast({
            html: "请检查必填项，以及未通过校验项！",
            closable: false,
            align: 't',
            slideInDuration: 400,
            minWidth: 400
        });
        return false;
    }
    //校验日期
    var build_status_id = xmzxForm.getForm().findField('SCJD').value;
    var start_date_actual = xmzxForm.getForm().findField('START_DATE_ACTUAL').value;
    var end_date_actual = xmzxForm.getForm().findField('END_DATE_ACTUAL').value;
    var errorMsg = '';
    if(build_status_id!=null&&build_status_id!=''){
        build_status_id = parseInt(build_status_id,10);//转化为十进制数字
        if(build_status_id>=1){//1 表示在建阶段
            //建设状态大于在建状态，则实际开工日期必录
            if(start_date_actual==null||start_date_actual==''){
                errorMsg = '建设状态为【在建阶段】及之后的必录实际开工日期';
                Ext.Msg.alert('提示',errorMsg);
                return false;
            }
            if(build_status_id==4){//已竣工结算，则必录实际完工日期
                if(end_date_actual==null||end_date_actual==''){
                    errorMsg = '建设状态为【已竣工结算】的必录实际完工日期';
                    Ext.Msg.alert('提示',errorMsg);
                    return false;
                }else{
                    //校验竣工日期 必须大于 开工日期
                    if(end_date_actual<=start_date_actual){
                        errorMsg = '实际完工日期必须大于实际开工日期';
                        Ext.Msg.alert('提示',errorMsg);
                        return false;
                    }
                }
            }
        }
        //增加校验 2020.11.23  zhanghl  实际完工日期不能大于当前日期
        if(end_date_actual > new Date()){
            errorMsg = '实际完工日期不能大于当前日期';
            Ext.Msg.alert('提示',errorMsg);
            return false;
        }
        if(typeof end_date_actual != 'undefined' && end_date_actual != null && end_date_actual != ''){
            //校验竣工日期 必须大于 开工日期
            if(end_date_actual<=start_date_actual){
                errorMsg = '实际完工日期必须大于实际开工日期';
                Ext.Msg.alert('提示',errorMsg);
                return false;
            }
        }
    }
    //增加校验 2020.11.23  zhanghl  实际完工日期不能大于当前日期
    if(end_date_actual > new Date()){
        errorMsg = '实际完工日期不能大于当前日期';
        Ext.Msg.alert('提示',errorMsg);
        return false;
    }
    btn.setDisabled(true); //避免网络延迟或者点击两次导致数据保存两次，按钮置为不可点击
    $.post('/saveXmzxInfo.action', {
        wf_id: wf_id,
        node_code: node_code,
        xmzx_type: xmzx_type,
        button_name: button_name,
        AD_CODE: AD_CODE,
        AG_ID: AG_ID,
        AG_NAME: AG_NAME,
        AG_CODE: AG_CODE,
        xmzxForm: Ext.util.JSON.encode([xmzxForm.getValues()])
    }, function (data) {
        if (data.success) {
            Ext.toast({
                html: '保存成功！',
                closable: false,
                align: 't',
                slideInDuration: 400,
                minWidth: 400
            });
            btn.up('window').close();
            // 刷新表格
            reloadGrid()
        } else {
            Ext.MessageBox.alert('提示', '保存失败!' + data.message);
            btn.setDisabled(false);
        }
        //刷新表格
    }, "json");
}