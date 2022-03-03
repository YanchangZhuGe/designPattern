Ext.onReady(function () {

        //风险测算
        function riskMeasure() {
            Ext.MessageBox.wait('测算中，请等待...','测算');
            Ext.Ajax.request({
                url : 'dataCalculate.action',
                params : {
                    status : 'true'
                },
                method : 'post',
                success : function (data) {
                    Ext.MessageBox.hide();
                    var respText =Ext.util.JSON.decode(data.responseText);
                    //返回false 说明查询到风险测算的相关数据 提示用户是否进行覆盖
                    if(respText.status == false ||respText.status=='false' ){
                        Ext.Msg.confirm('提示','已存在风险测算记录，是否要覆盖该记录继续执行风险测算操作？',function(button){
                            //如果用户确认覆盖 再次发起请求，则不会对数据库记录进行校验，直接调用存储过程进行测算
                            if(button == 'yes'){
                                Ext.MessageBox.wait('测算中，请等待...','测算');
                                Ext.Ajax.request({
                                    url : 'dataCalculate.action',
                                    params : {
                                        status :  respText.status
                                    },
                                    method : 'post',
                                    success : function (data) {
                                        Ext.MessageBox.hide();
                                        var respText =Ext.util.JSON.decode(data.responseText);
                                        if(respText.result != '' && respText.result != null){
                                            Ext.Msg.alert('提示','风险测算失败!失败原因：<br/>'+respText.result);
                                        }else{
                                            Ext.Msg.alert('提示','风险测算成功!');
                                        }
                                    },
                                    failure : function () {
                                        Ext.MessageBox.hide();
                                        Ext.Msg.alert('提示','风险测算失败!');
                                    }
                                });
                            }
                        });
                    }else{
                        if(respText.result!= '' && respText.result != null){
                            Ext.Msg.alert('提示','风险测算失败!失败原因：<br/>'+respText.result);
                        }else{
                            Ext.Msg.alert('提示','风险测算成功!');
                        }
                    }
                },
                failure : function () {
                    Ext.MessageBox.hide();
                    Ext.Msg.alert('提示','风险测算失败!');
                },
            });
        }
        var headerjson = [
        {xtype: 'rownumberer', width: 40},
        {
            dataIndex: "YEAR",
            type: "string",
            text: "年度",
            width: 200,
            align : 'center',
            renderer : function (value) {
                if(value != '' && value != null && value.toLowerCase() != 'null'){
                    return value + '年';
                }
                return '';
            }
        },
        {
            dataIndex: "STORED_PROCEDURE",
            type: "string",
            text: "对应存储过程名称",
            width: 200,
            hidden : true
        },
        {
            dataIndex: "TABLE_NAME_LS",
            type: "string",
            width: 200,
            text: "数据",
            align : 'center',
            renderer : function (value) {
                //表面即临时表名
                if(value == 'bd_t_src_bmjs_gg'){
                    return '公共预算部门决算明细数据';
                }else if(value == 'bd_t_src_js_jj'){
                    return '政府性基金收支及平衡情况表';
                }else if(value == 'bd_t_src_bmjs_jj'){
                    return '政府性基金部门决算明细数据';
                }else if(value == 'bd_t_src_bmjs_jjfjb'){
                    return '基金分级表数据';
                }else if(value == 'bd_t_src_js_gg'){
                    return '公共财政收支及平衡情况表';
                }else if(value == 'bd_t_src_fxcs_qh'){
                    return '标准区划表';
                }
                return '';
            }
        },
        {
            dataIndex: "NOT_SYNC",
            type: "string",
            text: "未确认条数",
            width: 200,
            align : 'center',
            renderer : function (value) {
                if(value != '' && value != null && value.toLowerCase() != 'null'){
                    return value + '条';
                }
                return '';
            }
        }
    ];
    var simplegrid = new DSYGridV2();
    var grid = simplegrid.create({
        itemId : 'sjtbgrid',
        headerConfig : {
            headerJson : headerjson,
            columnAutoWidth : false
        },
        flex : 1,
        autoLoad : true,
        border : false,
        dataUrl : '/bgd/sjtb_initPage.action',
        pageConfig : {
            enablePage : false
        },
        tbar : [{
                    text: '确认',
                    xtype: 'button',
                    icon : '/image/sysbutton/projectadjust.png',
                    handler : function (btn) {
                        var grid = btn.up('grid');
                        var selections = grid.getSelectionModel().getSelection();
                        var param = [];
                        if(selections.length < 1){
                            Ext.Msg.alert('提示','请选择一条记录！');
                            return ;
                        }
                        var zong = 0;
                        Ext.Array.forEach(selections,function (data) {
                            var pa = {};
                            pa.STORED_PROCEDURE = data.data.STORED_PROCEDURE;
                            pa.YEAR = data.data.YEAR;
                            pa.NOT_SYNC = data.data.NOT_SYNC;
                            zong += Number(data.data.NOT_SYNC);
                            param.push(pa)
                        });
                        Ext.MessageBox.wait('确认中，请等待...','确认');
                        Ext.Ajax.request({
                            url : 'dataSync.action',
                            params : {
                                param :  Ext.util.JSON.encode(param)
                            },
                            method : 'post',
                            success : function (data) {
                                Ext.MessageBox.hide();
                                var respText =Ext.util.JSON.decode(data.responseText) ;
                                if(respText.status == true ||respText.status=='true' ){
                                    Ext.Msg.alert('提示','数据确认成功！<br/>成功'+respText.count+'条，失败'+(zong-Number(respText.count))+'条');
                                    grid.getStore().loadPage(1);
                                }else{
                                    Ext.Msg.alert('提示','数据确认失败！');
                                }
                            },
                            failure : function () {
                                     Ext.MessageBox.hide();
                                     Ext.Msg.alert('提示','数据确认失败！');
                            }
                        });
                    }
                }, {
                    text: '测算',
                    xtype: 'button',
                    hidden : true,
                    icon : '/image/sysbutton/regist.png',
                    handler : function (btn) {
                        var grid = btn.up('grid');
                        var selections = grid.getStore();
                        var flag = false;
                        selections.each(function (data) {
                            if(Number(data.data.NOT_SYNC) > 0){
                                flag = true;
                            }
                        });
                        if(flag){
                            Ext.Msg.confirm('提示','存在尚未同步的数据，是否仍然进行测算?',function (button) {
                                if(button == 'yes'){
                                    riskMeasure();
                            }
                            });
                        }else{
                            riskMeasure();
                        }
                    }
                },
                {
                    xtype:'button',
                    text:'模板下载',
                    icon:'/image/sysbutton/download.png',
                    handler:function () {
                        downLoadMb();
                    }
                },
                '->',
            initButton_OftenUsed(),
            initButton_Screen()],
        checkBox : true
    });
    var panel = Ext.create('Ext.panel.Panel',{
        width : '100%',
        height : '100%',
        renderTo : Ext.getBody(),
        items : [grid]
    })
});
function downLoadMb() {
   window.location.href="downLoadMb.action?file_name="+encodeURI(encodeURI("风险测算数据采集模板.zip"));
}