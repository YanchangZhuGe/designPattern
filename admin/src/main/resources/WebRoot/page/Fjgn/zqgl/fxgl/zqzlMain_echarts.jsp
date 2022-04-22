<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=11;IE=9;IE=8;">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>债券总览-ECharts图表</title>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script src="../data/ele_data.js"></script>
<!-- 放置债券信息填报面板 -->
<div id="contentPanel" style="width: 100%;height:200px"></div>
<!-- 放置echarts图表的dom -->
<div id='mainEchart' style="width: 100%;height:500px"></div>

<!-- 单文件引入echarts.js -->
<script type="text/javascript" src="/third/js/echarts.js"></script>
<script type="text/javascript" src="zqxx_echarts.js"></script>
<script type="text/javascript">
    /**
     *	全局参数
     *	债券期限最大值：30，该值代表债券的最大发行期限，也代表债券预测所能取的最大值，即最大展示未来30年的债券还本付息情况
     */
    var qxMax = 30;
    //用户区划
    var AD_CODE = '${sessionScope.ADCODE}'.replace(/00$/, "");  // 获取用户名称
    var AD_NAME = '${sessionScope.ADNAME}';
    //默认展示未来5年的还本付息情况，再加上当前年
    //图表默认显示类型：zl:总览图表，fnd:分年度显示图表,有时间轴
  /*  var display_type = getQueryParam('display_type');
    if(display_type==null||display_type==''||display_type=='undefined'){
        display_type = 'zl';
    }*/
    var display_type ="${fns:getParamValue('display_type')}";
    if (isNull(display_type)) {
        display_type = 'zl';
    }
    //默认展示未来5年的还本付息情况,未来五年加上当前年，所以为6
/*
    var displayYears = getQueryParam('displayYears');
*/
    var displayYears ="${fns:getParamValue('displayYears')}";
    if(isNull(displayYears)){
        displayYears = 6;
    }else{
        displayYears = parseInt(displayYears)+1;
    }
    //以上参数配置到url上，供管理员修改

    //全局option,两种类型的option：在页面初始化,更改展示年份数，债券预测三种情况下改变
    var option_zl = {};
    var option_fnd = {};
    // 根据现有option，添加预测数据后，展示预测信息的option
    var option_zl_yc = {};
    var option_fnd_yc = {};
    //图表数据统一精度，保留4位小数
    var number_precision = 4;
    //判断显示预测前数据还是预测后数据，默认false，即显示还本付息基础数据集
    var is_yc = false;
    //存储还本付息总数据的map对象
    var hbfxMap = {};
    //存储添加预测信息后的还本付息数据map对象
    var hbfxMap_yc = {};
    //当前年度
    var currentYear = parseInt(new Date().getFullYear());//当前年度
    // 展示年限范围json
    var json_displayYears = [
        {id: 2, code: 2, name: "未来1年"},
        {id: 3, code: 3, name: "未来2年"},
        {id: 4, code: 4, name: "未来3年"},
        {id: 5, code: 5, name: "未来4年"},
        {id: 6, code: 6, name: "未来5年"},
        {id: 7, code: 7, name: "未来6年"},
        {id: 8, code: 8, name: "未来7年"},
        {id: 9, code: 9, name: "未来8年"},
        {id: 10, code: 10, name: "未来9年"},
        {id: 11, code: 11, name: "未来10年"},
        {id: 12, code: 12, name: "未来11年"},
        {id: 13, code: 13, name: "未来12年"},
        {id: 14, code: 14, name: "未来13年"},
        {id: 15, code: 15, name: "未来14年"},
        {id: 16, code: 16, name: "未来15年"},
        {id: 17, code: 17, name: "未来16年"},
        {id: 18, code: 18, name: "未来17年"},
        {id: 19, code: 19, name: "未来18年"},
        {id: 20, code: 20, name: "未来19"},
        {id: 21, code: 21, name: "未来20年"},
        {id: 22, code: 22, name: "未来21年"},
        {id: 23, code: 23, name: "未来22年"},
        {id: 24, code: 24, name: "未来23年"},
        {id: 25, code: 25, name: "未来24年"},
        {id: 26, code: 26, name: "未来25年"},
        {id: 27, code: 27, name: "未来26年"},
        {id: 28, code: 28, name: "未来27年"},
        {id: 29, code: 29, name: "未来28年"},
        {id: 30, code: 30, name: "未来29年"},
        {id: 31, code: 31, name: "未来30年"},
    ];
    //预览样式
    var displayType_json = [{id:'fnd',code:'fnd',name:'分年度预览'},{id:'zl',code:'zl',name:'总览'}];
    //发行方式基础数据集
    var fxfs_store = DebtEleStore(json_debt_fxfs);
    //债券类型基础数据集
    var zqlx_store = DebtEleTreeStoreDB('DEBT_ZQLB');
    //债券类别基础数据集 （新增、置换、再融资）
    var zqlb_store = DebtEleStore(json_debt_xzorzh);
    /**
     * 页面初始化
     */
    $(document).ready(function () {
        //初始化form面板
        initZqxxTbFormPanel();
        //初始化echart及相关数据,并赋值全局变量
        init(qxMax,currentYear,displayYears,display_type);
    });
    /**
     * 定义表单元素及信息
     */
    var content=[{
        xtype: 'container',
        layout: 'fit',
        width: "100%",
        margin: '2 20 10 20',
        autoScroll : false,
        layout: 'anchor',
        defaults: {
            border: false,
            anchor: '100%',
            padding: '0 0 0 0'
        },
        items:[
            {
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .25,
                    padding: '3 0 2 0',
                    labelAlign: 'left',
                    labelWidth: 100,
                    width:180,
                    allowBlank: true,
                    editable: true
                },
                items:[
                    {
                        //债券发行方式
                        xtype: "combobox",
                        name: "FXFS_ID",
                        store:fxfs_store,
                        fieldLabel: '发行方式',
                        displayField:'name',
                        valueField:'id',
                        value:'01',//默认为公开发行
                        //allowBlank: false,
                        //editable: false,
                        editable: true,
                        listeners:{
                            change:function(self,newValue){
                                init(qxMax,currentYear,displayYears,display_type);
                            }
                        }
                    },
                    {
                        xtype: "treecombobox",
                        name: "BOND_TYPE_ID",
                        store:zqlx_store,
                        fieldLabel: '债券类型',
                        displayField:'name',
                        valueField:'id',
                        value:'01',//默认为一般债券
                        //allowBlank: false,
                        editable: false,
                        listeners:{
                            change:function(self,newValue){
                                init(qxMax,currentYear,displayYears,display_type);
                            }
                        }
                    },
                    {
                        xtype: "combobox",
                        name: "ZQLB_ID",
                        store:zqlb_store,
                        fieldLabel: '债券类别',
                        displayField:'name',
                        valueField:'id',
                        value:'PLAN_XZ_AMT',
                        //allowBlank: false,
                        editable: true,
                        listeners:{
                            change:function(self,newValue){
                                init(qxMax,currentYear,displayYears,display_type);
                            }
                        }
                    },
                    {
                        xtype: 'container',
                        layout: 'column',
                        defaults: {
                            columnWidth: .3,
                            padding: '3 0 0 0',
                            labelAlign: 'right',
                            margin: '2 5 2 5',
                            labelWidth: 100,
                            width:180,
                            allowBlank: true,
                            editable: true
                        },
                        items:[
                            {
                                xtype:'button',
                                text:'重置',
                                name:'reset',
                                icon:'/image/sysbutton/edit.png',
                                handler:function(btn){
                                    /*var form = btn.up('form');
                                    form.reset();*/
                                    //置空发行方式、债券类型、债券类别
                                    Ext.ComponentQuery.query('combobox[name="FXFS_ID"]')[0].setValue("");
                                    Ext.ComponentQuery.query('treecombobox[name="BOND_TYPE_ID"]')[0].setValue("");
                                    Ext.ComponentQuery.query('combobox[name="ZQLB_ID"]')[0].setValue("");
                                }

                            }
                        ]
                    },
                ]
            },
            {//分割线
                xtype: 'menuseparator',
                width: '100%',
                anchor: '100%',
                margin: '2 5 2 5',
                border: true
            },
            {
                xtype: 'container',
                layout: 'column',
                defaults: {
                    columnWidth: .25,
                    padding: '7 0 2 0',
                    labelAlign: 'left',
                    labelWidth: 100,
                    width:180,
                    allowBlank: true,
                    editable: true
                },
                items:[
                    {
                        xtype: "numberfield",//发行额
                        name: "FX_AMT",
                        fieldLabel: '<span class="required">✶</span>发行额（亿）',
                        emptyText: '0.000000',
                        minValue:1,
                        maxValue:10000,//发行额最大值 亿元
                        decimalPrecision: 6,
                        hideTrigger: true,
                        allowBlank: false,
                        keyNavEnabled:false,
                        mouseWheelEnabled:false,
                        listeners:{
                            blur:function(self,newValue){
                                realTimeSubmit();
                            }
                        }
                    },
                    {
                        //债券期限 范围1-30年
                        xtype: "combobox",
                        name: "ZQQX_ID",
                        store:DebtEleStoreDB('DEBT_ZQQX'),
                        fieldLabel: '<span class="required">✶</span>期限',
                        displayField:'name',
                        valueField:'id',
                        allowBlank: false,
                        editable: false,
                        listeners:{
                            change:function(self,newValue){
                                realTimeSubmit();
                            }
                        }
                    },
                    {
                        //利率
                        xtype: "numberfield",
                        name: "RATE",
                        fieldLabel: '<span class="required">✶</span>利率（%）',
                        emptyText: '0.000000',
                        decimalPrecision: 6,
                        hideTrigger: true,
                        allowBlank: false,
                        keyNavEnabled:false,
                        mouseWheelEnabled:false,
                        minValue:0,
                        listeners:{
                            blur:function(data){
                                realTimeSubmit();
                            }
                        }
                    },
                    {
                        //付息方式
                        xtype: "combobox",
                        name: "FXZQ_ID",
                        store: DebtEleStore(json_debt_fxzq),
                        displayField: "name",
                        valueField: "id",
                        fieldLabel: '<span class="required">✶</span>付息方式',
                        allowBlank: false,
                        editable: false, //禁用编辑
                        listeners:{
                            change:function(self,newValue){
                                realTimeSubmit();
                            }
                        }
                    },
                    {//起息日
                        xtype: "datefield",
                        name: "QX_DATE",
                        fieldLabel: '<span class="required">✶</span>起息日',
                        allowBlank: false,
                        format: 'Y-m-d',
                        blankText: '请选择开始日期',
                        allowBlank: false,
                        value: today,
                        minValue:today,
                        listeners:{
                            change:function(self,newValue){
                                realTimeSubmit();
                            }
                        }
                    },
                    {
                        xtype: 'tbseparator',
                        width:180,
                    },
                    {
                        xtype: 'tbseparator',
                        width:180,
                    },
                    {
                        xtype: 'container',
                        layout: 'column',
                        defaults: {
                            columnWidth: .3,
                            padding: '3 0 0 0',
                            labelAlign: 'left',
                            margin: '2 5 2 5',
                            labelWidth: 100,
                            width:180,
                            allowBlank: true,
                            editable: true
                        },
                        items:[
                            {
                                xtype:'button',
                                text:'预测',
                                name:'yc',
                                icon: '/image/sysbutton/search.png',
                                handler:function(btn){
                                    //校验并改变按钮状态
                                    checkZqxx();
                                }
                            },
                            {
                                xtype:'button',
                                text:'重置',
                                name:'reset',
                                icon:'/image/sysbutton/edit.png',
                                handler:function(btn){
                                    /*var form = btn.up('form');
                                    form.reset();*/
                                    Ext.ComponentQuery.query('numberfield[name="FX_AMT"]')[0].setValue("");
                                    Ext.ComponentQuery.query('combobox[name="ZQQX_ID"]')[0].setValue("");
                                    Ext.ComponentQuery.query('numberfield[name="RATE"]')[0].setValue("");
                                    Ext.ComponentQuery.query('combobox[name="FXZQ_ID"]')[0].setValue("");
                                    Ext.ComponentQuery.query('datefield[name="QX_DATE"]')[0].setValue(today);
                                }

                            }
                        ]
                    }
                ]
            }
        ]
    }];
    /*
    	债券信息填报form
    */
    function initZqxxTbFormPanel(){
        Ext.create('Ext.form.Panel',{
            itemId: 'zqxxTbYcForm',
            layout: 'fit',
            renderTo: 'contentPanel',
            border: true,
            autoScroll: false,
            dockedItems:[
                {
                    xtype: 'toolbar',
                    dock: 'top',
                    items: [
                        {
                            xtype:'button',
                            text:'预测',
                            name:'yc',
                            hidden:true,
                            icon: '/image/sysbutton/search.png',
                            handler:function(btn){
                                //校验并改变按钮状态
                                checkZqxx();
                            }
                        },
                        {
                            xtype:'button',
                            text:'取消预测',
                            name:'qxyc',
                            hidden:true,
                            disabled:true,
                            icon: '/image/sysbutton/cancel.png',
                            handler:function(btn){
                                is_yc = false;
                                //刷新按钮状态
                                refreshButtonStatus();
                                //刷新echarts
                                reloadECharts();
                            }
                        },
                        {
                            xtype:'button',
                            text:'重置',
                            name:'reset',
                            hidden:true,
                            icon:'/image/sysbutton/edit.png',
                            handler:function(btn){
                                var form = btn.up('form');
                                form.reset();
                            }

                        },
                        {
                            xtype:'combobox',
                            name:'DISPLAY_YEARS',
                            store:DebtEleStore(json_displayYears),
                            displayField:'name',
                            valueField:'id',
                            value:displayYears,//默认展示5年
                            fieldLabel:'展示年数',
                            labelWidth:80,
                            labelAlign:'right',
                            editable:false,
                            allowBlank:false,
                            listeners:{
                                'change':function(self,newValue){
                                    displayYears = newValue;
                                    //根据展示年数，截取数据，构建option
                                    getOptionByDisplayYears(hbfxMap,newValue,currentYear,is_yc,hbfxMap_yc);
                                    reloadECharts(display_type);
                                }
                            }
                        },
                        {	//显示方式
                            xtype:'combobox',
                            name:'DISPLAY_TYPE',
                            store:DebtEleStore(displayType_json),
                            displayField:'name',
                            valueField:'id',
                            value:'zl',//默认总览
                            fieldLabel:'预览方式',
                            labelWidth:80,
                            labelAlign:'right',
                            editable:false,
                            allowBlank:false,
                            listeners:{
                                'change':function(self,newValue){
                                    //切换预览类型
                                    display_type = newValue;
                                    reloadECharts(newValue);
                                }
                            }
                        },
                        '->',
                        initButton_OftenUsed(),
                        initButton_Screen()]
                }
            ],
            items: content
        });
    }
    /*
    	校验新增债券信息
    */
    function checkZqxx(){
        //获取form数据
        var form = Ext.ComponentQuery.query('form#zqxxTbYcForm')[0];
        //var set_year=form.getForm().findField("SET_YEAR").value;
        var fxamt = form.getForm().findField("FX_AMT").value*10000;//转换单位，亿--万
        var zqqx_id= form.getForm().findField("ZQQX_ID").value;//001,002
        var rate= form.getForm().findField("RATE").value; //年利率%
        var fxzq_id =  form.getForm().findField("FXZQ_ID").value;//付息方式
        var qxDate = form.getForm().findField("QX_DATE").value;
        //格式化起息日
        var qxDateFormat = format(qxDate, 'yyyy-MM-dd');
        //获取当前日期并格式化
        var currentDate = format(new Date(), 'yyyy-MM-dd');
        //---先校验
        //校验发行额应大于0
        if(fxamt==0 || fxamt>100000000){
            Ext.Msg.alert('提示','债券发行额必须大于0！');
            return;
        }
        //校验债券期限不能为空
        if(zqqx_id==null||zqqx_id=='undefined'){
            Ext.Msg.alert('提示','债券发行期限不能为空！');
            return;
        }
        //利率应大于0
        if(rate<0){
            Ext.Msg.alert('提示','债券利率不能小于0！');
            form.getForm().findField("RATE").setValue('0');
            return;
        }
        //校验付息方式不能为空
        if(fxzq_id==null||fxzq_id=='undefined'){
            Ext.Msg.alert('提示','付息方式不能为空！');
            return;
        }
        //校验债券起息日,所选起息日期应大于等于当前日期
        if(qxDateFormat<currentDate){
            Ext.Msg.alert('提示','债券起息日不能小于当前日期！');
            form.getForm().findField("QX_DATE").reset();
            return;
        }
        //校验无错,调用方法进行计算还本付息情况
        if(form.isValid()){
            submitZqxx(form,{
                'fxamt':fxamt,
                'zqqx_id':zqqx_id,
                'rate':rate,
                'fxzq_id':fxzq_id,
                'qxDate':qxDateFormat,
                'number_precision':number_precision
            });
        }
    }
    //提交新增债券信息，计算还本付息情况
    function submitZqxx(form,params){
        //复制还本付息基础数据集，添加预测数据，构建预测数据集
        hbfxMap_yc = cloneObj(hbfxMap);
        //切换为预测数据状态
        is_yc = true;
        //发送post请求，只传递需要的数据
        $.post('/calcYcHbfxQK.action',params,function(data){
            var result = Ext.util.JSON.decode(data);
            //添加数据
            for(var i = 0; i<result.list.length;i++){
                //添加本金
                var bjList = result.list[i].data_bj;
                for(var m = 0;m<bjList.length;m++){
                    hbfxMap_yc[bjList[m].year]['bj'][bjList[m].month-1]+=bjList[m].bj;
                }
                //添加利息
                var lxList = result.list[i].data_lx;
                for(var n = 0;n<lxList.length;n++){
                    hbfxMap_yc[lxList[n].year]['lx'][lxList[n].month-1]+=lxList[n].lx;
                }
            }
            //加载option，加载echarts
            ycwl(hbfxMap, displayYears, currentYear, is_yc, hbfxMap_yc,display_type);
        });
    }
</script>
</body>
</html>