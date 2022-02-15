/**
 * 债券支出期间校验
 * 支出方式：0:财政支出，1：部门支出，2：单位支出
 * @param params
 */
function peCheck(params){
    var res = false;
    var localParams = {};
    $.extend(localParams,params);
    //日期格式化
    if(localParams.ZC_DATE!=null){
        var zcDate = new Date(localParams.ZC_DATE);
        localParams.ZC_DATE = Ext.Date.format(zcDate,'Y-m-d');
    }
    $.ajaxSetup({
        async:false
    });
    $.post('/tj/peCheck.action',localParams,function(data){
        data = Ext.JSON.decode(data);
        if(data.success){
            res = true;
        }else {
            Ext.Msg.alert('警告',!!data.msg?data.msg:'期间校验失败！');
        }
    });
    return res;
}