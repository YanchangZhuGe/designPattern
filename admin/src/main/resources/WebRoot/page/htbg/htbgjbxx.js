	/**
	 * 合同修改formPanel
	 */
	function initWin_ZwqxTabPanel_Jbxx_form() {
        var panel = Ext.create('Ext.form.Panel', {
        	name : 'jbxxForm',
            width: '100%',
            height: '100%',
            layout: 'anchor',
            defaults: {
                margin: '2 5 2 5'
            },
            defaultType: 'textfield',
            items: [
                { 
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        //width: 315,
                        labelWidth: 125//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '债务单位',
                            name: 'AG_ID',
                            displayField: 'text',
                            valueField: 'id',
                            rootVisible: false,
                            disabled:true,
                            lines: false,
                            maxPicekerWidth: '100%',
                            selectModel: 'leaf',
                            store: Ext.ComponentQuery.query('treepanel#tree_unit')[0].getStore()
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '<span class="required">✶</span>债务名称',
                            name: "ZW_NAME",
                            allowBlank: false,
                            disabled:true,
                            emptyText: '请输入...',
                            validator:vd
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '<span class="required">✶</span>债务类别',
                            name: 'ZWLB_ID',
                            displayField: 'name',
                            valueField: 'id',
                            rootVisible: false,
                            lines: false,
                            maxPicekerWidth: '100%',
                            selectModel: 'leaf',
                            disabled:true,
                            //store: DebtEleTreeStoreJSON(json_debt_zwlb)
                            store: DebtEleTreeStoreDB('DEBT_ZWLX', {condition: "AND CODE IN ('01','0101','02','0201')"})
                        }
                    ]
                },
                {//分割线
                    xtype: 'menuseparator',
                    width: '100%',
                    anchor: '100%',
                    margin: '2 0 2 0',
                    border: true
                },
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        disabled:true,
                        //width: 315,
                        labelWidth: 125//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "datefield",
                            name: "SIGN_DATE",
                            fieldLabel: '<span class="required">✶</span>签订日期',
                            allowBlank: false,
                            format: 'Y-m-d',
                            blankText: '请选择开始日期',
                            emptyText: '请选择开始日期',
                            value: today,
                            listeners: {
                                'change': function (self, newValue, oldValue) {
                                }
                            }
                        },
                        {
                            xtype: "numberfield",
                            name: "ZWQX_ID",
                            fieldLabel: '<span class="required">✶</span>债务期限（月）',
                            allowDecimals: true,
                            allowBlank : false,
                            decimalPrecision: 0,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})

                        },
                        {
                            xtype: "treecombobox",
                            name: "ZQFL_ID",
                            store: DebtEleTreeStoreDB('DEBT_ZQLX'),
                            fieldLabel: '<span class="required">✶</span>债权类型',
                            displayField: 'name',
                            valueField: 'id',
                            rootVisible: false,
                            lines: false,
                            selectModel: 'leaf',
                            listeners: {
                                'change': function (self, newValue, oldValue) {
                                }
                            }
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '<span class="required">✶</span>债权人',
                            name: 'ZQR_ID',
                            displayField: 'name',
                            valueField: 'id',
                            rootVisible: false,
                            lines: false,
                            selectModel: 'leaf',
                            store: DebtEleTreeStoreDB("DEBT_ZQR")
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '<span class="required">✶</span>债权人全称',
                            allowBlank: false,
                            name: "ZQR_FULLNAME",
                            emptyText: '请输入...',
                            validator:vd
                        },
                        {
                            xtype: "textfield",
                            fieldLabel: '<span class="required">✶</span>协议号',
                            name: "ZW_XY_NO",
                            allowBlank: false,
                            emptyText: '请输入...',
                            validator:vd
                        },
                        {
                            xtype: 'treecombobox',
                            fieldLabel: '<span class="required">✶</span>资金用途',
                            name: 'ZJYT_ID',
                            displayField: 'name',
                            valueField: 'id',
                            rootVisible: false,
                            lines: false,
                            selectModel: 'leaf',
                            store: DebtEleTreeStoreJSON(json_debt_zwzjyt1),
                            listeners: {
                                'select': function () {                     	
                                	
                                }
                            }
                        },
                        {
                            xtype: "popupgrid",
                            name: "XM_ID",
                            valueField: 'XM_ID',
                            displayField:'XM_NAME',
                            fieldLabel: '建设项目',
                            listConfig: {
                            	maxHeight: 1
                            },
                            store: getJSXMStore( 'getJSXM.action?AG_ID='+AG_ID),
                            gridConfig:{
                            }
                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "XY_AMT",
                            fieldLabel: '<span class="required">✶</span>协议金额（原币）',
                            emptyText: '0.00',

                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            disabled:true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                        },
                        {
                            xtype: "combobox",
                            name: "FM_ID",
                            store: DebtEleStore(json_debt_wb),
                            displayField: "name",
                            valueField: "id",
                            value: 'CNY',
                            fieldLabel: '<span class="required">✶</span>币种',
                            allowBlank: false,
                            editable: false
                        },
                        {
                            xtype: "numberfield",
                            name: "HL_RATE",
                            fieldLabel: '<span class="required">✶</span>汇率',
                            value: 1.000000,
                            readOnly: true,
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})

                        },
                        {
                            xtype: "numberFieldFormat",
                            name: "XY_AMT_RMB",
                            type:'float',
                            fieldLabel: "协议金额（人民币）",
                            emptyText: '0.00',
                            allowDecimals: true,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            disabled:true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                        }
                    ]
                },
                {//分割线
                    xtype: 'menuseparator',
                    width: '100%',
                    anchor: '100%',
                    margin: '2 0 2 0',
                    border: true
                },
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        disabled:true,
                        //width: 315,
                        labelWidth: 125//控件默认标签宽度
                    },
                    items: [
                        
                        
                        {
                            xtype: "combobox",
                            name: "LXTYPE_ID",
                            store: DebtEleStore(json_debt_jzlllx),
                            displayField: "name",
                            valueField: "id",
                            fieldLabel: '<span class="required">✶</span>利率类型',
                            allowBlank: false,
                            editable: false
                        },
                        {
                            xtype: "numberfield",
                            name: "LX_RATE",
                            fieldLabel: "固定利率（%）",
                            emptyText: '0.0000',
                            allowDecimals: true,
                            disabled:true,
                            allowBlank: false,
                            decimalPrecision: 6,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                        },
                        {
                            xtype: "combobox",
                            name: "LX_FDFS",
                            store: DebtEleStore(json_debt_llfdfs),
                            displayField: "name",
                            valueField: "id",
                            allowBlank: false,
                            fieldLabel: "利率浮动方式",
                            listeners: {
                                'change': function (self, newValue, oldValue) {
                                }
                            }
                        },
                        {
                            xtype: "numberfield",
                            fieldLabel: "利率浮动率（%）",
                            name: "LX_FDL",
                            allowBlank: false,
                            emptyText: '0.0000',
                            allowDecimals: true,
                            decimalPrecision: 4,
                            hideTrigger: true,
                            keyNavEnabled: true,
                            mouseWheelEnabled: true,
                            plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                        },
                        {
                            xtype: "combobox",
                            name: "LXTZ_ID",
                            store: DebtEleStore(json_debt_lltzfs),
                            displayField: "name",
                            valueField: "id",
                            allowBlank:false,
                            fieldLabel: "利率调整方式"
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: 'hbox',
                            fieldLabel: "利息调整月日",
                            defaultType: 'textfield',
                            defaults: {
                                flex: 1
                            },
                            items: [
                                {
                                    xtype: "combobox",
                                    name: "LXTZ_MONTH",
                                    margin: '0 5 0 0',
                                    store: DebtEleStore(json_debt_yf_nd),
                                    displayField: "name",
                                    allowBlank: false,
                                    valueField: "id",
                                    editable: false, //禁用编辑
                                    listeners: {
                                        'change': function (self, newValue, oldValue) {
                                        }
                                    }
                                },
                                {
                                    xtype: "combobox",
                                    name: "LXTZ_DAY",
                                    margin: '0 0 0 5',
                                    allowBlank: false,
                                    store: DebtEleStore(json_debt_day),
                                    displayField: "text",
                                    valueField: "id",
                                    editable: false, //禁用编辑
                                    listeners: {
                                        'change': function (self, newValue, oldValue) {
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            xtype: "combobox",
                            name: "JSFS_ID",
                            store: DebtEleStore(json_debt_jxfs),
                            displayField: "name",
                            valueField: "id",
                            fieldLabel: '<span class="required">✶</span>结息方式',
                            editable: false, //禁用编辑
                            allowBlank : false
                        },
                        {
                            xtype: 'fieldcontainer',
                            layout: 'hbox',
                            fieldLabel: '<span class="required">✶</span>结息月日',
                            defaultType: 'textfield',
                            defaults: {
                                flex: 1
                            },
                            items: [
                                {
                                    xtype: "combobox",
                                    name: "JSRQ_MONTH",
                                    margin: '0 5 0 0',
                                    allowBlank:false,
                                    store: DebtEleStore(json_debt_yf_nd),
                                    displayField: "name",
                                    valueField: "id",
                                    editable: false, //禁用编辑
                                    listeners: {
                                        'change': function (self, newValue, oldValue) {
                                        }
                                    }
                                },
                                {
                                    xtype: "combobox",
                                    name: "JSRQ_DAY",
                                    margin: '0 0 0 5',
                                    allowBlank:false,
                                    store: DebtEleStore(json_debt_day),
                                    displayField: "text",
                                    valueField: "id",
                                    editable: false, //禁用编辑
                                    listeners: {
                                        'change': function (self, newValue, oldValue) {
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            xtype: "combobox",
                            name: "IS_LSBQ",
                            store: DebtEleStore(json_debt_sf),
                            displayField: "name",
                            valueField: "id",
                            allowBlank:false,
                            fieldLabel: "利随本清",
                            value : '1'
                            
                        }
                    ]
                },
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .99,
                        disabled:true,
                        //width: 315,
                        labelWidth: 125//控件默认标签宽度
                    },
                    items: [
                        
			                {
			                    xtype: "textfield",
			                    fieldLabel: '备注',
			                    width: '100%',
			                    anchor: '100%',
			                    name: "REMARK"
			                }
			                ]
                },
                {//分割线
                    xtype: 'menuseparator',
                    width: '100%',
                    anchor: '100%',
                    margin: '2 0 2 0',
                    border: true
                },
                {
                    xtype: 'container',
                    layout: 'column',
                    anchor: '100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .33,
                        disabled:true,
                        //width: 315,
                        labelWidth: 125//控件默认标签宽度
                    },
                    items: [
                        {
                            xtype: "treecombobox",
                            name: "DBFL_ID",
                            store: DebtEleTreeStoreDB('DEBT_JJFS'),
                            fieldLabel: '<span class="required">✶</span>增信措施',
                            displayField: 'name',
                            valueField: 'id',
                            rootVisible: false,
                            lines: false,
                            selectModel: 'leaf',
                            listeners: {
                                'change': function (self, newValue, oldValue) {
                                }
                            }
                        },
                        {
                            xtype: "combobox",
                            name: "IS_QLZB",
                            store: DebtEleStore(json_debt_sf),
                            displayField: "name",
                            valueField: "id",
                            disabled:true,
                            labelWidth: 150,//控件默认标签宽度
                            fieldLabel: "是否清理甄别认定债务",
                            listeners: {
                                'change': function (self, newValue, oldValue) {
                                }
                            }
                        },
                        {
                       	 xtype: "textfield",
                         fieldLabel: '基准年利率',
                         name: "DQ_RATE",
                         emptyText: '0.0000',
                         fieldStyle: 'background:#B0F769',
                         readOnly:true,
                         plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
                        }
                    ]
                }
            ],
            listeners:{
            	'beforeRender': function(){
                    if(node_type == "reviewed"|| WF_STATUS == "008"){
                    	
                    	SetItemReadOnly(this.items);
                    	
                    }
            	}
            }
        });

        return panel;
    }

	/**
	 * 初始化置换债券填报表单中页签panel的附件页签
	 */
	function initWin_ZwqxTabPanel_Jbxx_Fj() {
        var grid = UploadPanel.createGrid({
            busiType: 'ET101',//业务类型
            busiId: ZW_ID,//业务ID
            height: 150,
            busiProperty: '%',//业务规则，默认为‘%’
            editable: false,//是否可以修改附件内容，默认为ture
            gridConfig: {
                itemId: 'window_ZwqxTabPanel_Jbxx_upload_grid'//若无，会自动生成，建议填写，特别是出现多个附件上传时
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
            if (grid.up('tabpanel').el.dom) {
                $(grid.up('tabpanel').el.dom).find('span.file_sum').html('(' + sum + ')');
            } else {
                $('span.file_sum').html('(' + sum + ')');
            }
        });
        return grid;
	}
	
function getJSXMStore(dataURL) {
    var store = Ext.create('Ext.data.Store', {
        fields: ["XM_ID", "XM_CODE","XM_NAME","LX_YEAR","JSXZ_NAME","XMXZ_NAME","XMLX_NAME","BUILD_STATUS_NAME","XMZGS_AMT"],
        remoteSort: true,// 后端进行排序
        proxy: {// ajax获取后端数据
            type: "ajax",
            method: "POST",
            url: dataURL,
            reader: {
                type: "json",
                root: "list",
                totalProperty: "totalcount"
            },
            simpleSortMode: true
        },
        autoLoad:true
    });
    return store;
};

	/**
	 * 根据区划动态控制业务科室下拉框显示内容
	 * @returns {Ext.data.ArrayStore}
	 */
	function MBEleStoreDB(){
		var MBStore = new Ext.data.ArrayStore({
			//autoLoad : true,
			fields: ['id','code','name'],
			sorters: [{
				property: 'code',
				direction: 'asc'
			}],
			proxy: {
				type : 'ajax',
				url : 'getMBEleValue.action?AD_CODE='+AD_CODE,
				reader : {
					type : 'json',
					root : 'list'
				}
			}
		});
		return MBStore;
	};
	function loadDqlx(sign_date){
	    $.post("getDqlx.action?SIGN_DATE="+sign_date, function (data) {
	        //弹出弹出框，设置主表id
	    	
	    	var dqlx = data.data[0].DQ_RATE;
	    	Ext.ComponentQuery.query('textfield[name="DQ_RATE"]')[0].setValue(dqlx);

	    }, "json");
	};
	