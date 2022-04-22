/**
 * 招标信息
 */
function fxxx_zhaobxxTab(){
    var content = [
        {
        xtype: 'container',
        layout: 'column',
        anchor:'100%',
        width: "100%",
        height: "100%",
        defaults: {
            columnWidth: .44,
            margin: '2 2 2 2',
            labelAlign: 'right',
            labelWidth: 170
            //labelStyle : fontSize,
            //editable: true
        },
        items: [
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '债券名称',
                name: "ZQ_NAME"
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '发行人名称',
                name: "FXR_NAME"
            },
            {
                xtype: 'datefield',
                name: 'ZB_DATE',
                format: 'Y-m-d',
                //allowBlank: false,
                fieldLabel: '招标日期'
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '招标方式',
                name: "ZBFS"
            },
            {
                xtype: 'datefield',
                name: 'DF_DATE',
                format: 'Y-m-d',
                //allowBlank: false,
                fieldLabel: '兑付日期'
            },
            {  xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '债券托管代码',
                name: "ZQ_CODE"
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '债券期限',
                name: "ZQ_QX"
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '招标书编号',
                name: "ZBS_CODE"
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "PLAN_FX_AMT",
                fieldLabel: '计划发行总量(亿元)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                maxValue : 999999.999999,
                value:"0.0000",
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "JK_AMT",
                fieldLabel: '缴款总金额(元)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                value:"0.0000",
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: 'datefield',
                name: 'JK_DATE',
                format: 'Y-m-d',
                //allowBlank: false,
                fieldLabel: '缴款日期'
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "FX_AMT",
                fieldLabel: '实际发行总量(亿元)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                maxValue : 999999.999999,
                keyNavEnabled: true,
                value:"0.0000",
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "GDCX_AMT",
                fieldLabel: '固定承销总额（亿元）',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                maxValue : 999999.999999,
                keyNavEnabled: true,
                value:"0.0000",
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "ZHAOB_AMT",
                fieldLabel: '招标总量(亿元)',
                emptyText: '0.0000',
                eallowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                maxValue : 999999.999999,
                value:"0.0000",
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '应投家数(家)',
                value:"0",
                name: "YT_NUM"
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "TB_AMT",
                fieldLabel: '投标总量(亿元)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                maxValue : 999999.999999,
                keyNavEnabled: true,
                value:"0.0000",
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "YX_TB_AMT",
                fieldLabel: '有效投标总量(亿元)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                maxValue : 999999.999999,
                keyNavEnabled: true,
                value:"0.0000",
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '实投家数(家)',
                value:"0",
                name: "ST_NUM"
                	
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '投标笔数(笔)',
                value:"0",
                name: "TBBS_NUM"
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '有效笔数(笔)',
                name: "YXBS"
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '无效笔数(笔)',
                name: "WXBS"
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "H_TBJW",
                fieldLabel: '最高投标价位',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                value:"0.0000",
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "L_TBJW",
                fieldLabel: '最低投标价位',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                value:"0.0000",
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "TBSYL_MAX",
                fieldLabel: '最高投标价位收益率(%)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                value:"0.0000",
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "TBSYL_MIN",
                fieldLabel: '最低投标价位收益率(%)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                value:"0.0000",
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "ZHONGB_AMT",
                fieldLabel: '中标总量(亿元)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                value:"0.0000",
                maxValue : 999999.999999,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '中标家数(家)',
                name: "ZHONGB_J_NUM"
            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '中标笔数(笔)',
                name: "ZHONGB_B_NUM"
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "JQPJ_ZBJW",
                fieldLabel: '全场中标价格',
                emptyText: '0.0000',
                value:"0.0000",
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "H_ZBJW",
                fieldLabel: '最高中标价位',
                emptyText: '0.0000',
                value:"0.0000",
                allowDecimals: true,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "BJZBJWTB_AMT",
                fieldLabel: '边际中标价位投标总量(亿元)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                maxValue : 999999.999999,
                value:"0.0000",
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "L_ZBJW",
                fieldLabel: '最低中标价位',
                emptyText: '0.0000',
                allowDecimals: true,
                value:"0.0000",
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "ZBSYL_MAX",
                fieldLabel: '最高中标价位收益率(%)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                value:"0.0000",
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "ZBSYL_MIN",
                fieldLabel: '最低中标价位收益率(%)',
                emptyText: '0.0000',
                allowDecimals: true,
                decimalPrecision: 6,
                value:"0.0000",
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "BJZBJWZB_AMT",
                fieldLabel: '边际中标价位中标总量(亿元)',
                emptyText: '0.0000',
                allowDecimals: true,
                value:"0.0000",
                maxValue : 999999.999999,
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "RGBS",
                fieldLabel: '认购倍数(倍)',
                emptyText: '0.00',
                allowDecimals: true,
                value:"0.0000",
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "BJBS",
                fieldLabel: '边际倍数(倍)',
                emptyText: '0.00',
                allowDecimals: true,
                decimalPrecision: 6,
                value:"0.0000",
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                fieldLabel: '发行价格(元)',
                allowDecimals: true,
                hideTrigger: true,
                decimalPrecision: 6,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                name: "FX_JG",
                value: 0
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                fieldLabel: '招投标倍数',
                name: "ZTB_BS",
                emptyText: '0.00',
                allowDecimals: true,
                decimalPrecision: 6,
                value:"0.0000",
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                fieldLabel: '票面利率(%)',
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                allowDecimals: true,
                decimalPrecision: 6,
                name: "PM_RATE"
                	
            },
            {
                xtype: "numberFieldFormat",
                //allowBlank:false,
                fieldLabel: '参考收益率(%)',
                value:"0.0000",
                name: "CKSYL",
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {}),
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                decimalPrecision: 6

            },
            {
                xtype: "textfield",
                //allowBlank:false,
                fieldLabel: '投标不足家数(家)',
                name: "TBBZ_NUM"
            },
            { 
                xtype: "numberFieldFormat",
                //allowBlank:false,
                name: "TBBZ_AMT",
                fieldLabel: '投标不足数量(亿元)',
                maxValue : 999999.999999,
                emptyText: '0.00',
                allowDecimals: true,
                value:"0.0000",
                decimalPrecision: 6,
                hideTrigger: true,
                keyNavEnabled: true,
                mouseWheelEnabled: false,
                plugins: Ext.create('Ext.ux.FieldStylePlugin', {})
            },
         /*   {
            	 //BQ_GZDM 本期工作代码
            	 xtype: "textfield",
                 name: "BQ_GZDM",
                 hidden:true
                	 
            },*/
            {
            	 //FX_OP_USER发行负责人
           	    xtype: "textfield",
                name: "FX_OP_USER",
                hidden:true
               	 
           },
           {
		       //FX_JD_USER 发行监督员
         	 xtype: "textfield",
              name: "FX_JD_USER",
              hidden:true
             	 
           }]
    	} 
    ];
    if(button_name == 'VIEW'){
        content[0].defaults.editable = false;
        content[0].defaults.readOnly = true;
        content[0].defaults.fieldStyle = {'background-color':'#e6e6e6'};
    }

    var editorPanel = Ext.create('Ext.form.Panel', {
        itemId: 'zbqkForm',
        layout: 'anchor',
        anchor: "100%",
        height: "100%",
        border: false,
        autoScroll: true,
        items: content,
        listeners : {
            afterrender : function (t) {

            }
        }
    });
    return editorPanel;
}

/**
 *中标信息 
 */
function fxxx_zhongbxxTab(){
	        var headerJson = [
	           // {xtype: 'rownumberer',width: 35},
				{
				    xtype: 'rownumberer',
				    summaryType: 'count',
				    width: 40,
				    summaryRenderer: function () {
				        return '合计';
				    }
				},
	            {"dataIndex": "CXJG_CODE", "type": "string", "text": "承销商代码", "width": 150, editor: 'textfield'},
	            {"dataIndex": "CXJG_NAME", "type": "string", "text": "承销商名称", "width": 150, editor: 'textfield'},
                {"dataIndex": "CXSTGZH", "type": "string", "text": "承销商托管账号", "width": 200, editor: 'textfield'},
                {"dataIndex": "TBXH", "type": "string", "text": "投标序号", "width": 100, editor: 'textfield'},
                {
	                "dataIndex": "ZB_JW", "type": "float", "text": "中标价位", "width": 150,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    }
	            },
	            {
	                "dataIndex": "ZB_AMT", "type": "float", "text": "中标数量", "width": 150,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    },
	                summaryType: 'sum',
	                summaryRenderer: function (value) {
	                    return Ext.util.Format.number(value, '0,000.0000####');
	                }
	            },
	            {
	                "dataIndex": "CX_ED", "type": "float", "text": "基本承销额", "width": 150,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    },
	                summaryType: 'sum',
	                summaryRenderer: function (value) {
	                    return Ext.util.Format.number(value, '0,000.0000####');
	                }
	            },
	            {
	                "dataIndex": "SUM_CX_AMT", "type": "float", "text": "总承销量", "width": 150,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    },
	                summaryType: 'sum',
	                summaryRenderer: function (value) {
	                    return Ext.util.Format.number(value, '0,000.0000####');
	                }
	            }
	        ];

	        var config = {
	            itemId: 'zbxxGrid',
	            headerConfig: {
	                headerJson: headerJson,
	                columnAutoWidth: false
	            },
	            data: [],
	            height: '100%',
	            checkBox: true,
	            pageConfig: {
	                enablePage: false
	            }, 
	            features: [{
	                ftype: 'summary'
	            }]
	        };
	        var grid = DSYGrid.createGrid(config);
	        return grid;
	    }

	   
	
	
/**
 * 承销商投标信息不足
 */
function fxxx_tbbzTab(){
        var headerJson = [
           // {xtype: 'rownumberer',width: 35},
			{
			    xtype: 'rownumberer',
			    summaryType: 'count',
			    width: 40,
			    summaryRenderer: function () {
			        return '合计';
			    }
			},
            //{"dataIndex": "CXS_CODE", "type": "string", "text": "承销商代码", "width": 150, editor: 'textfield'},
            {"dataIndex": "OUT_CXS_CODE", "type": "string", "text": "承销商代码", "width": 200, editor: 'textfield'},
            {"dataIndex": "CXS_NAME", "type": "string", "text": "承销商名称", "width": 150, editor: 'textfield'},
            {
                "dataIndex": "TB_AMT", "type": "float", "text": "投标量", "width": 150,
                editor: {
                    xtype: 'numberfield',
                    hideTrigger: true
                },
                renderer:function(value){
                    return Ext.util.Format.number(value, '0,000.0000####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000####');
                }
            },
            {
                "dataIndex": "TBBZ_AMT", "type": "float", "text": "不足投标量", "width": 150,
                editor: {
                    xtype: 'numberfield',
                    hideTrigger: true
                },
                renderer:function(value){
                    return Ext.util.Format.number(value, '0,000.0000####');
                },
                summaryType: 'sum',
                summaryRenderer: function (value) {
                    return Ext.util.Format.number(value, '0,000.0000####');
                }
            },
            {"dataIndex": "BQ_GZDM", "type": "string", "text": "本期工作代码", "width": 150, editor: 'textfield',"hidden":true},
            {"dataIndex": "ZB_DATE", "type": "string", "text": "招标日期", "width": 150, editor: 'textfield',"hidden":true},
            {"dataIndex": "ZBS_NO", "type": "string", "text": "招标书编号", "width": 150, editor: 'textfield',"hidden":true},
            {"dataIndex": "ZQ_ZBFS", "type": "string", "text": "招标方式", "width": 150, editor: 'textfield',"hidden":true}
        ];

        var config = {
            itemId: 'tbbzGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            data: [],
            height: '100%',
            checkBox: true,
            pageConfig: {
                enablePage: false
            }, 
            features: [{
                ftype: 'summary'
            }]
        };
        var grid = DSYGrid.createGrid(config);
        return grid;
}

/**
 * 承销商未投标信息
 */
function fxxx_wtbTab(){
        var headerJson = [
            {
                xtype: 'rownumberer',
                summaryType: 'count',
                width: 40,
                summaryRenderer: function () {
                    return '合计';
                }
            },
           // {"dataIndex": "CXS_CODE", "type": "string", "text": "承销商代码", "width": 150, editor: 'textfield'},
            {"dataIndex": "OUT_CXS_CODE", "type": "string", "text": "承销商代码", "width": 200, editor: 'textfield'},
            {"dataIndex": "CXS_NAME", "type": "string", "text": "承销商名称", "width": 150, editor: 'textfield'},
            {"dataIndex": "BQ_GZDM", "type": "string", "text": "本期工作代码", "width": 200, editor: 'textfield',"hidden":true},
            {"dataIndex": "ZB_DATE", "type": "string", "text": "招标日期", "width": 200, editor: 'textfield',"hidden":true},
            {"dataIndex": "ZBS_NO", "type": "string", "text": "招标书编号", "width": 200, editor: 'textfield',"hidden":true},
            {"dataIndex": "ZQ_ZBFS", "type": "string", "text": "招标方式", "width": 200, editor: 'textfield',"hidden":true}
           
        ];
        var config = {
            itemId: 'wtbxxGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            data: [],
            height: '100%',
            pageConfig: {
                enablePage: false
            }, 
            plugins: [
                {
                    ptype: 'cellediting',
                    clicksToEdit: 1,
                    pluginId: 'rowedit_tbxx',
                    clicksToMoveEditor: 1,
                    listeners: {
                        'edit': function (editor, e) {
                        }
                    }
                }
            ]
        };
        if(button_name == 'VIEW'){
            delete config.plugins;
        }
        var grid = DSYGrid.createGrid(config);
        return grid;
    }
/**
 *最低承销不足 
 */
function fxxx_cxebzTab(){
	        var headerJson = [
				{
				    xtype: 'rownumberer',
				    summaryType: 'count',
				    width: 40,
				    summaryRenderer: function () {
				        return '合计';
				    }
				},
	            //{"dataIndex": "CXS_CODE", "type": "string", "text": "承销商代码", "width": 150, editor: 'textfield'},
                {"dataIndex": "OUT_CXS_CODE", "type": "string", "text": "承销商代码", "width": 150, editor: 'textfield'},
	            {"dataIndex": "CXS_NAME", "type": "string", "text": "承销商名称", "width": 150, editor: 'textfield'},
	            {
	                "dataIndex": "ZDCX_AMT", "type": "float", "text": "最低承销量", "width": 150,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    },
	                summaryType: 'sum',
	                summaryRenderer: function (value) {
	                    return Ext.util.Format.number(value, '0,000.0000####');
	                }
	            },
	            {
	                "dataIndex": "ZB_AMT", "type": "float", "text": "中标额", "width": 150,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    },
	                summaryType: 'sum',
	                summaryRenderer: function (value) {
	                    return Ext.util.Format.number(value, '0,000.0000####');
	                }
	            },
                {"dataIndex": "BQ_GZDM", "type": "string", "text": "本期工作代码", "width": 150, editor: 'textfield',"hidden":true},
                {"dataIndex": "ZB_DATE", "type": "string", "text": "招标日期", "width": 150, editor: 'textfield',"hidden":true},
                {"dataIndex": "ZBS_NO", "type": "string", "text": "招标书代码", "width": 150, editor: 'textfield',"hidden":true},
                {"dataIndex": "ZQ_ZBFS", "type": "string", "text": "招标方式", "width": 150, editor: 'textfield',"hidden":true}
	        ];
	        var config = {
	            itemId: 'zdcxeGrid',
	            headerConfig: {
	                headerJson: headerJson,
	                columnAutoWidth: false
	            },
	            data: [],
	            height: '100%', 
	            pageConfig: {
	                enablePage: false
	            }, 
	            features: [{
	                ftype: 'summary'
	            }]
	        };
	        var grid = DSYGrid.createGrid(config);
	        return grid;
	   
	}
	
	/**
	 * 托管信息
	 */
	function fxxx_tgxxbzTab(){
	        var headerJson = [
	           // {xtype: 'rownumberer',width: 35},
				{
				    xtype: 'rownumberer',
				    summaryType: 'count',
				    width: 40,
				    summaryRenderer: function () {
				        return '合计';
				    }
				},
	            {"dataIndex": "CXJG_CODE", "type": "string", "text": "承销商代码", "width": 100, editor: 'textfield'},
	            {"dataIndex": "CXJG_NAME", "type": "string", "text": "承销商名称", "width": 150, editor: 'textfield'},
                {"dataIndex": "CXSTGZH", "type": "string", "text": "承销商托管账号", "width": 200, editor: 'textfield'},
                {"dataIndex": "ZB_JW", "type": "string", "text": "中标价位", "width": 100, editor: 'textfield'},
                {
                    "dataIndex": "ZBSL_NUM", "type": "float", "text": "中标数量（亿元面值）", "width": 150,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000####');
                    }
                },
                {
	                "dataIndex": "SUM_TG_AMT", "type": "float", "text": "托管量合计（亿元面值）", "width": 150,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    },
	                summaryType: 'sum',
	                summaryRenderer: function (value) {
	                    return Ext.util.Format.number(value, '0,000.0000####');
	                }
	            },
	            {
	                "dataIndex": "ZZD_AMT", "type": "float", "text": "中央国债登记结算有限责任公司（亿元面值）", "width": 150,
	                summaryType: 'sum',
	                summaryRenderer: function (value) {
	                    return Ext.util.Format.number(value, '0,000.0000####');
	                }
	            },
                {
                    "dataIndex": "JK_AMT", "type": "float", "text": "缴款金额", "width": 250,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    },
                    summaryType: 'sum',
                    summaryRenderer: function (value) {
                        return Ext.util.Format.number(value, '0,000.0000####');
                    }
                },
	            {
	                "dataIndex": "SHANGHAI_AMT", "type": "float", "text": "上海分公司（亿元面值）", "width": 175,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    },
	                summaryType: 'sum',
	                summaryRenderer: function (value) {
	                    return Ext.util.Format.number(value, '0,000.0000####');
	                }
	            },
	            {
	                "dataIndex": "SHENZHEN_AMT", "type": "float", "text": "深圳分公司（亿元面值）", "width": 175,
                    renderer:function(value){
                        return Ext.util.Format.number(value, '0,000.0000####');
                    },
	                summaryType: 'sum',
	                summaryRenderer: function (value) {
	                    return Ext.util.Format.number(value, '0,000.0000####');
	                }
	            }
	            
	        ];
	        var config = {
	            itemId: 'tgxxGrid',
	            headerConfig: {
	                headerJson: headerJson,
	                columnAutoWidth: false
	            },
	            data: [],
	            width: '100%',
	            height: '100%',
	            pageConfig: {
	                enablePage: false
	            }, 
	            features: [{
	                ftype: 'summary'
	            }]
	        };
	        var grid = DSYGrid.createGrid(config);
	        return grid;
	}