/**
 * 获取url参数或者查询字符串中的参数
 */
/*function getQueryParam(name, queryString) {
    var match = new RegExp(name + '=([^&]*)').exec(queryString || location.search);
    return match && decodeURIComponent(match[1]);
}*/

//债务单位类型树
var treeData = [];
var editFj = false;
//是否显示股权结构
if (showGqjg == null || showGqjg == '' || showGqjg.toLowerCase() == 'null') {
    showGqjg = 0; // 默认不显示
}



//是否显示附件
if (showFj == null || showFj == '' || showFj.toLowerCase() == 'null') {
    showFj = 0; // 默认不显示
}
/*if (node_status == 'wtb') {
    //未填报
    document.title = '名录创建';
    $('#title').text('名录创建');
    $('#backButton').hide();
} else if (node_status == 'wtj') {
    //未提交
    document.title = '名录创建';
    $('#title').text('名录创建');
    $('#backButton').hide();
} else if (node_status == 'wsh') {
    //未审核
    document.title = '名录查看';
    $('#title').text('名录查看');
    $('form.content-form').find('fieldset').attr('disabled', true);//禁用form
    $('input').iCheck('disable'); //将输入框的状态设置为 disabled
    $('#buttons').hide();
} else if (node_status == 'ysh') {
    //已审核
    document.title = '名录查看';
    $('#title').text('名录查看');
    $('form.content-form').find('fieldset').attr('disabled', true);//禁用form
    $('input').iCheck('disable'); //将输入框的状态设置为 disabled
    $('#buttons').hide();
    $('#backButton').hide();
}*/

var wf_id = null;//当前流程id
var wf_status = null;
var node_code = null;
var ml_id = null;

//给输入框设置值
$('#AD_NAME').text(AD_NAME);
$('#AG_NAME').val(AG_NAME);
$('[name=AD_CODE]').val(AD_CODE);
$('[name=AG_ID]').val(AG_ID);
$('[name=AG_CODE]').val(AG_CODE);
var tyshxydmRegText = "统一代码由十八位的阿拉伯数字或大写英文字母（不使用I、O、Z、S、V）组成。" + "<br/>" + "第1位：登记管理部门代码（共一位字符）" + "<br/>" + "第2位：机构类别代码（共一位字符）" + "<br/>" + "第3位~第8位：登记管理机关行政区划码（共六位阿拉伯数字）" + "<br/>" + "第9位~第17位：主体标识码（组织机构代码）（共九位字符）" + "<br/>" + "第18位：校验码（共一位字符）";


//给单选/复选按钮加上样式
$('input').iCheck({
    labelHover: false,
    cursor: true,
    checkboxClass: 'icheckbox_square-green',
    radioClass: 'iradio_square-green'
});
var flag = {
    DEBT_RZPTLX: false,
    DEBT_PTZGLX: false,
    DEBT_GQLX: true,
    DEBT_HYLY: true,
    DEBT_ZWDWLX: false
};
//下拉选择框
//$('.selectpicker').selectpicker();
DebtEleStoreDB_bootstrap($("#RZPTLX_ID"), 'DEBT_RZPTLX');
DebtEleStoreDB_bootstrap($("#PTZGLX_ID"), 'DEBT_PTZGLX');
/*    DebtEleStoreDB_bootstrap($("#GQLX_ID"), 'DEBT_GQLX');
 DebtEleStoreDB_bootstrap($("#HYLY_ID"), 'DEBT_HYLY');*/
//DebtEleStoreDB_bootstrap($("#ZGDWLX_ID"), 'DEBT_ZWDWLX');
var validFields = {
    ZGDW: {
        message: '主管单位验证失败！',
        validators: {
            notEmpty: {
                message: '主管单位不能为空！'
            }
        }
    },
    /*ZGDWLX_ID: {
        trigger:"change",
        message: '单位类型验证失败！',
        validators: {
            notEmpty: {
                message: '单位类型不能为空！'
            }
        }
    },*/
    ZGDWLX_NAME: {
        trigger: "change",
        message: '单位类型验证失败！',
        validators: {
            notEmpty: {
                message: '单位类型不能为空！'
            }
        }
    },
    ZZJG_CODE: {
        trigger: "change",
        message: '组织机构代码验证失败！',
        validators: {
            notEmpty: {
                message: '组织机构代码不能为空！'
            },
            stringLength: {
                min: 9,
                max: 9,
                message: '请输入9位字符'
            },
            regexp: {
                regexp: /[^_IOZSVa-z\W]{9}/,
                message: '全国组织机构代码由八位数字（或大写拉丁字母）本体代码和一位数字（或大写拉丁字母）校验码组成，请修正后再提交' + '<br/>' + '（大写拉丁字母不使用I、O、Z、S、V）！'
            }
        }
    },
    TYSHXY_CODE: {
        trigger: "change",
        message: '统一社会信用代码验证失败！',
        validators: {
            /*notEmpty: {
                message: '统一社会信用代码不能为空！'
            },//
            stringLength: {
                min: 18,
                max: 18,
                message: '请输入18位字符'
            },
            regexp: {
                regexp: /[^_IOZSVa-z\W]{2}\d{6}[^_IOZSVa-z\W]{10}/,
                message: tyshxydmRegText
            },
            callback: {
                message: '统一社会信用代码（18位）包含了组织机构代码（第9-17位），请修正后再提交！',
                callback: function (value, validator) {
                    if (value.length == 18) {
                        var v = value.substring(8, 17);
                        var ZZJG_CODE = $('form.content-form').find('[name=ZZJG_CODE]').val();
                        return v == ZZJG_CODE;
                    } else {
                        return true;
                    }
                }
            }*/
        }
    },
    IS_GYXZBXM: {
        message: '有无公益性资本项目验证失败！',
        validators: {
            notEmpty: {
                message: '有无公益性资本项目不能为空！'
            }
        }
    },
    RZPTLX_ID: {
        message: '融资平台分类验证失败！',
        validators: {
            notEmpty: {
                message: '融资平台分类不能为空！'
            }
        }
    },
    /* GQLX_ID: {
     message: '股权类型验证失败！',
     validators: {
     notEmpty: {
     message: '股权类型不能为空！'
     }
     }
     },
     HYLY_ID: {
     message: '行业领域验证失败！',
     validators: {
     notEmpty: {
     message: '行业领域不能为空！'
     }
     }
     },*/
    FRDB_NAME: {
        message: '法人代表姓名验证失败！',
        validators: {
            notEmpty: {
                message: '法人代表姓名不能为空！'
            }
        }
    },
    FRDB_TEL: {
        message: '法人代表联系电话验证失败！',
        validators: {
            notEmpty: {
                message: '法人代表联系电话不能为空！'
            },
            regexp: {
                regexp:/^(?:0[0-9]{2,3}[-\\s]{1}|\\(0[0-9]{2,4}\\))[0-9]{6,8}$|^[1-9]{1}[0-9]{5,7}$|^[1-9]{1}[0-9]{10}$/,
                message: '请输入合法的联系电话'
            }
            // digits: {
            //     message: '联系电话含有多余字符'
            // }
        }
    },
    CWFZR_TEL: {
        message: '财务负责人联系电话验证失败！',
        validators: {
            /*notEmpty: {
                message: '财务负责人联系电话不能为空！'
            },*/
            regexp: {
                regexp: /^(?:0[0-9]{2,3}[-\\s]{1}|\\(0[0-9]{2,4}\\))[0-9]{6,8}$|^[1-9]{1}[0-9]{5,7}$|^[1-9]{1}[0-9]{10}$/,
                message: '请输入合法的联系电话'
            }
            // digits: {
            //     message: '联系电话含有多余字符'
            // }
        }
    },
    ADDRESS: {
        message: '平台地址验证失败！',
        validators: {
            notEmpty: {
                message: '平台地址不能为空！'
            }
        }
    },
    YG_NUM: {
        message: '员工/在校学生数量验证失败！',
        validators: {
            notEmpty: {
                message: '员工/在校学生数量不能为空！'
            },
            numeric: {
                message: '员工/在校学生数量不是有效数字！'
            },
            digits: {
                message: ''
            }
        }
    }/*,
    IS_MLW: {
        message: '是否名录外验证失败！',
        validators: {
            notEmpty: {
                message: '是否名录外不能为空！'
            }
        }
    },
    IS_SJQR: {
        message: '是否为2013年6月底审计结果确定的融资平台验证失败！',
        validators: {
            notEmpty: {
                message: '是否为2013年6月底审计结果确定的融资平台不能为空！'
            }
        }
    }*/
};
/**
 * 页面初始化
 */
$(document).ready(function () {
    // createGqjg();
    //初始化form表单校验
    $('form.content-form').bootstrapValidator({
        message: '这不是有效的值！',
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        excluded: [":disabled"],
        fields: validFields
    });
    //标准版禁用校验
    //1.组织机构代码非必录，去掉所有校验
    $('#mlForm').data("bootstrapValidator").enableFieldValidators("ZZJG_CODE",false,"notEmpty");
    $('#mlForm').data("bootstrapValidator").enableFieldValidators("ZZJG_CODE",false,"stringLength");
    $('#mlForm').data("bootstrapValidator").enableFieldValidators("ZZJG_CODE",false,"regexp");
    //2.统一社会信用代码除必录之外的所有校验
    $('#mlForm').data("bootstrapValidator").enableFieldValidators("TYSHXY_CODE",false,"stringLength");
    $('#mlForm').data("bootstrapValidator").enableFieldValidators("TYSHXY_CODE",false,"regexp");
    $('#mlForm').data("bootstrapValidator").enableFieldValidators("TYSHXY_CODE",false,"callback");
    //3.平台地址、员工/在校学生数量、融资平台分类非必录
    $('#mlForm').data("bootstrapValidator").enableFieldValidators("ADDRESS",false,"notEmpty");
    $('#mlForm').data("bootstrapValidator").enableFieldValidators("YG_NUM",false,"notEmpty");
    $('#mlForm').data("bootstrapValidator").enableFieldValidators("RZPTLX_ID",false,"notEmpty");
    $('#mlForm').data("bootstrapValidator").resetForm();


    var obj = new Object();
    var array1 = new Array();
    var array2 = new Array();
    var array3 = new Array();
    var ad = AD_CODE.substr(0,2);
    array1.push("mlForm");
    array2.push("submitButton");
    array3.push({"id":"mlxxTab","first":1});
    obj["form"] = array1;
    obj["button"] = array2;
    obj["tab"] = array3;
    //("mlglCreate_"+ ad +".json",obj,null);
    UI_Draw_Bootsrap("ui_draw",obj,null);

    if (showGqjg == 1) {
        $('#gqjg').css({'display': 'block'});
        $('#gqjg-title').css({'display': 'block'});
    }
    if (showFj == 1) {
        $('#fj').css({'display': 'block'});
        $('#fj-title').css({'display': 'block'});
    }
    if (showGqjg == 1 && showFj == 1) {
        $('#right-panel').css({'display': 'block'});
        $('#center-panel').css({'width': '', 'margin-left': ''});
        $('#center-panel div div.panel-body').css({'padding-right': ''});
        $('#left-qr').css({'display': 'block'});
    } else {
       // $('#right-qr').css({'display': 'block'});
    }
});

/**
 * 加载名录数据
 */
function getMLXX() {
    $.post('/rzpt/mlgl/getMlxx.action', function (data) {
        data = Ext.util.JSON.decode(data);
        if (data.success) {
            if (data.data.length > 1) {
                layer.alert('名录信息已存在多条，请联系管理员处理！');
                return false;
            }
            mlxx = data.data[0];
            editFj = false;
            //判断附件编辑状态
            if (mlxx) {
                //判断名录状态
                if (mlxx.IS_END == 1) {
                    //已审核
                    editFj = false;
                    $('#title').text('名录查看');
                    $('form.content-form').find('fieldset').attr('disabled', true);//禁用form
                    $('input').iCheck('disable'); //将输入框的状态设置为 disabled
                    $('#buttons').css({'display':'none'});
                    $('#backButton').css({'display':'none'});
                } else if (mlxx.NODE_CURRENT_ID == 1) {
                    $('#title').text('名录创建');
                    //未送审
                    $('#buttons').css({'display':'block'});
                    $('#backButton').css({'display':'none'});
                    editFj = true;
                } else if (mlxx.NODE_CURRENT_ID == 2) {
                    $('#title').text('名录查看');
                    $('form.content-form').find('fieldset').attr('disabled', true);//禁用form
                    $('input').iCheck('disable'); //将输入框的状态设置为 disabled
                    //未审核
                    $('#buttons').css({'display':'none'});
                    $('#backButton').css({'display':'block'});
                    editFj = false;
                }
            } else {
                $('#title').text('名录创建');
                //未填报
                $('#buttons').css({'display':'block'});
                $('#backButton').css({'display':'none'});
                editFj = true;
            }
            //判断单位类型是否可更改
            /*if(data.canSelectDwlx[0]!=undefined){
                var canSelectDwlx =  data.canSelectDwlx[0];
                if(canSelectDwlx.CWZB_ID){
                    $('#ZGDWLX_ID').attr({"disabled": "disabled"});
                    $('#ZGDWLX_NAME').attr({"disabled": "disabled"});
                }else{
                    $('#ZGDWLX_ID').removeAttr("disabled");
                    $('#ZGDWLX_NAME').removeAttr("disabled");
                }
            }*/

            //创建名录时，把已有的数据带过来
            if (!mlxx && data.data_ag != undefined) {
                var mlxx_ag = data.data_ag[0];
                callBackFormData(mlxx_ag);
                var dwlx_id = mlxx_ag.ZGDWLX_ID;
                for (var i = 0; i < treeData.length; i++) {
                    if (treeData[i].nodes != undefined) {
                        var child = treeData[i].nodes;
                        for (var j = 0; j < child.length; j++) {
                            if (child.href == dwlx_id) {
                                $('[name=ZGDWLX_NAME]').val(child.text)
                            }
                        }
                    }
                    if (treeData[i].href == dwlx_id) {
                        $('[name=ZGDWLX_NAME]').val(treeData[i].text)
                    }
                }
            }
            if (mlxx) {
                ml_id = mlxx.ML_ID;
                callBackFormData(mlxx);
                /*var gqjgGrid = DSYGrid.getGrid('gqjgGrid');
                gqjgGrid.getStore().getProxy().extraParams["ml_id"] = ml_id;
                gqjgGrid.getStore().reload();
                if (!editFj) {
                    gqjgGrid.remove(gqjgGrid.down('toolbar'));
                }*/
            } else {
                ml_id = mlxx_ag.ML_ID;
                $('[name=ML_ID]').val(ml_id);
            }
            if (showFj == 1) {
                mlxx_fj();
            }
        }
    });
}

/**
 * 回显form表单数据
 */
function callBackFormData(data) {
    node_code = data.NODE_CURRENT_ID;
    wf_status = data.WF_STATUS;
    wf_id = data.WF_ID;
    var form = $('form.content-form');
    if ($("#RDQK")) {//根据IS_MLW类型判断
        for (var name in data) {//标准版
            if (/*name == 'IS_SJQR' || name == 'IS_MLW' ||*/ name == 'IS_GYXZBXM' || name == 'IS_QLZBPT') {
                $("input:radio[name='" + name + "'][value='" + data[name] + "']").iCheck('check');
            } else if (name == 'IS_MLW' || name == 'IS_SJQR' || name == 'IS_YJRD') {
                if (data[name] == 1) {
                    $("input:checkbox[name='" + name + "']").iCheck('check');
                }
            }else if(name == 'TYSHXY_CODE'){
                form.find('[name=' + name + ']').text(data[name]);
            } else {
                form.find('[name=' + name + ']').val(data[name]);
            }
        }
    } else {
        for (var name in data) {//天津版
            if (name == 'IS_SJQR' || name == 'IS_MLW' || name == 'IS_GYXZBXM' || name == 'IS_QLZBPT') {
                $("input:radio[name='" + name + "'][value='" + data[name] + "']").iCheck('check');
            }else if(name == 'TYSHXY_CODE'){
                form.find('[name=' + name + ']').text(data[name]);
            }else {
                form.find('[name=' + name + ']').val(data[name]);
            }
        }
    }
    form.data("bootstrapValidator").resetForm();
}

/**
 * 撤销送审的名录信息
 */
function doWorkFlow(btn) {
    var ids = ml_id;
    layer.confirm( '确定撤销提交？', {
        btn: ['确定','取消'] ,
        title:'提示',
        skin:'layui-layer-molv',
    }, function(){
        doWorkFlow_ajax(ids, btn, '');
    }, function(){
        layer.close();
    });
}
/**
 * 工作流发送ajax修改请求
 */
function doWorkFlow_ajax(ids, btn, text) {
    ///发送ajax请求，修改节点信息
    $.ajax({
        type: "post",
        url: "/rzpt/mlgl/doWorkFlowActionMlxz.action",
        async: false,
        dataType: 'json',
        data: {
            workflow_direction: 'cancel',
            wf_id: wf_id,
            node_code: '1',
            button_name: '撤销送审',
            audit_info: text,
            ids: ids
        },
        success: function (data) {
            if (data.success) {
                layer.alert('撤销提交成功！' + (''), {
                    skin: 'layui-layer-molv', //样式类名
                    closeBtn: 0,
                    icon: 1
                }, function () {
                    if (parent && parent.window.initMlxx) {
                        parent.window.initMlxx();
                        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                        parent.layer.close(index);
                    } else {
                        window.history.go(0);
                    }
                })
            } else {
                layer.alert('提交失败！' + data.message, {icon: 0});
            }

        }
    });
}
/**
 * 保存/更新名录信息
 */
function saveForm() {

    var gqjgData = [];
    // DSYGrid.getGrid("gqjgGrid").getStore().each(function (record) {
    //     gqjgData.push(record.getData());
    // });
    var data = getFormData();
    data['FRDB_NAME'] = data['FRDB_NAME'].replace(/\s+/g, "");
    data['CWFZR_NAME'] = data['CWFZR_NAME'].replace(/\s+/g, "");
    data['ADDRESS'] = data['ADDRESS'].replace(/\s+/g, "");
    var xydm = data['TYSHXY_CODE'];
    if(!xydm || xydm.trim() == '' || xydm.toLocaleString() == 'null'){
        layer.alert('统一社会信用代码不能为空！');
        return false;
    }
    if(xydm && xydm.length > 18){
        layer.alert('统一社会信用代码不能超过18位！');
        return false;
    }
    var button_name = 'INPUT';
    if (data.ML_ID) {
        button_name = 'UPDATE';
    }
    var ZGDWLX_ID = $('#ZGDWLX_ID').val();
    // var mlgrid = DSYGrid.getGrid("gqjgGrid");
    // var result = CheckItemEmpty(mlgrid.items, 'shftzGridCheck');
    var result='';
    if (result != '') {
        Ext.MessageBox.alert('提示', result);
    } else if (ZGDWLX_ID == 3 || ZGDWLX_ID == 5) {
        if (gqjgData == '' && showGqjg == 1) {
            Ext.MessageBox.alert('提示', "请录入股权结构！");
        } else {
            $('#saveButton').attr({"disabled": "disabled"});
            $('#submitButton').attr({"disabled": "disabled"});
            $('#mlForm').data('bootstrapValidator').validate();
            if (!$('#mlForm').data('bootstrapValidator').isValid()) {
                $('#submitButton').removeAttr("disabled");
                $('#saveButton').removeAttr("disabled");
                return;
            }

            $.ajax({
                url: '/rzpt/mlgl/addOrUpdateMlxx.action',
                dataType: "json",
                data: {
                    button_name: button_name,
                    formData: JSON.stringify(data),
                    // formData: Ext.util.JSON.encode(data),
                    // gqjgData: Ext.util.JSON.encode(gqjgData),
                    wf_id: '100901',
                    node_code: '1',
                    wf_status: wf_status == null ? '001' : wf_status
                },
                type: 'POST',
                success: function (data) {
                    if (data.success) {
                        layer.alert('保存成功！' + (data.message ? data.message : ''), {
                            skin: 'layui-layer-molv', //样式类名
                            closeBtn: 0,
                            icon: 1
                        }, function () {
                            if (parent && parent.window.initMlxx) {
                                parent.window.initMlxx();
                                var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                                parent.layer.close(index);
                            } else {
                                // layer.closeAll('dialog'); //关闭信息框
                                window.history.go(0);
                            }
                        });
                    } else {
                        $('#submitButton').removeAttr("disabled");
                        $('#saveButton').removeAttr("disabled");
                        layer.alert('保存失败！' + (data.message ? data.message : ''), {icon: 0});
                    }

                }
            });
        }
    } else {
        $('#saveButton').attr({"disabled": "disabled"});
        $('#submitButton').attr({"disabled": "disabled"});
        $('#mlForm').data('bootstrapValidator').validate();
        if (!$('#mlForm').data('bootstrapValidator').isValid()) {
            $('#submitButton').removeAttr("disabled");
            $('#saveButton').removeAttr("disabled");
            return;
        }
        $.ajax({
            url: '/rzpt/mlgl/addOrUpdateMlxx.action',
            dataType: "json",
            data: {
                button_name: button_name,
                formData: JSON.stringify(data),
                // formData: Ext.util.JSON.encode(data),
                // gqjgData: Ext.util.JSON.encode(gqjgData),
                wf_id: wf_id,
                node_code: '1',
                wf_status: wf_status == null ? '001' : wf_status
            },
            type: 'POST',
            success: function (data) {
                if (data.success) {
                    layer.alert('保存成功！' + (data.message ? data.message : ''), {
                        skin: 'layui-layer-molv', //样式类名
                        closeBtn: 0,
                        icon: 1
                    }, function () {
                        if (parent && parent.window.initMlxx) {
                            parent.window.initMlxx();
                            var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                            parent.layer.close(index);
                        } else {
                            window.history.go(0);
                        }
                    });
                } else {
                    $('#submitButton').removeAttr("disabled");
                    $('#saveButton').removeAttr("disabled");
                    layer.alert('保存失败！' + (data.message ? data.message : ''), {icon: 0});
                }

            }
        });
    }
    return false;
}

/**
 * 提交名录信息
 */
function submitForm() {

    var data = getFormData();
    data['FRDB_NAME'] = data['FRDB_NAME'].replace(/\s+/g, "");
    data['CWFZR_NAME'] = data['CWFZR_NAME'].replace(/\s+/g, "");
    data['ADDRESS'] = data['ADDRESS'].replace(/\s+/g, "");
    var xydm = data['TYSHXY_CODE'];
    if(!xydm || xydm.trim() == '' || xydm.toLocaleString() == 'null'){
        layer.alert('统一社会信用代码不能为空！');
        return false;
    }
    if(xydm && xydm.length > 18){
        layer.alert('统一社会信用代码不能超过18位！');
        return false;
    }
    var button_name = 'INPUT';
    var gqjgData = [];
    /*DSYGrid.getGrid("gqjgGrid").getStore().each(function (record) {
        gqjgData.push(record.getData());
    });*/
    if (data.ML_ID) {
        button_name = 'UPDATE';
    }
    var ids = [];
    ids.push($('[name=ML_ID]').val());

    var ZGDWLX_ID = $('#ZGDWLX_ID').val();
    // var mlgrid = DSYGrid.getGrid("gqjgGrid");
    // var result = CheckItemEmpty(mlgrid.items, 'shftzGridCheck');
    var result='';
    if (result != '') {
        Ext.MessageBox.alert('提示', result);
    } else if (ZGDWLX_ID == 3 || ZGDWLX_ID == 5) {
        if (gqjgData == '' && showGqjg == 1) {
            Ext.MessageBox.alert('提示', "请录入股权结构！");
        } else {
            $('#saveButton').attr({"disabled": "disabled"});
            $('#submitButton').attr({"disabled": "disabled"});
            $('#mlForm').data('bootstrapValidator').validate();
            if (!$('#mlForm').data('bootstrapValidator').isValid()) {
                $('#submitButton').removeAttr("disabled");
                $('#saveButton').removeAttr("disabled");
                return;
            }
            $.ajax({
                url: '/rzpt/mlgl/submitMlxx.action',
                dataType: "json",
                data: {
                    button_name: button_name,
                    formData: JSON.stringify(data),
                    // formData: Ext.util.JSON.encode(data),
                    // gqjgData: Ext.util.JSON.encode(gqjgData),
                    wf_id: '100901',
                    node_code: '1',
                    wf_status: wf_status == null ? '001' : wf_status,
                    ids: ids
                },
                type: 'POST',
                success: function (data) {
                    if (data.success) {
                        layer.alert('提交成功！' + (data.message ? data.message : ''), {
                            skin: 'layui-layer-molv', //样式类名
                            closeBtn: 0,
                            icon: 1
                        }, function () {
                            if (parent && parent.window.initMlxx) {
                                parent.window.initMlxx();
                                var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                                parent.layer.close(index);
                            } else {
                                // layer.closeAll('dialog'); //关闭信息框
                                window.history.go(0);
                            }
                        });
                    } else {
                        $('#submitButton').removeAttr("disabled");
                        $('#saveButton').removeAttr("disabled");
                        layer.alert('提交失败！' + (data.message ? data.message : ''), {icon: 0});
                    }

                }
            });
        }
    } else {
        $('#saveButton').attr({"disabled": "disabled"});
        $('#submitButton').attr({"disabled": "disabled"});
        $('#mlForm').data('bootstrapValidator').validate();
        if (!$('#mlForm').data('bootstrapValidator').isValid()) {
            $('#submitButton').removeAttr("disabled");
            $('#saveButton').removeAttr("disabled");
            return;
        }
        $.ajax({
            url: '/rzpt/mlgl/submitMlxx.action',
            dataType: "json",
            data: {
                button_name: button_name,
                formData: JSON.stringify(data),
                // formData: Ext.util.JSON.encode(data),
                // gqjgData: Ext.util.JSON.encode(gqjgData),
                wf_id: '100901',
                node_code: '1',
                wf_status: wf_status == null ? '001' : wf_status,
                ids: ids
            },
            type: 'POST',
            success: function (data) {
                if (data.success) {
                    layer.alert('提交成功！' + (data.message ? data.message : ''), {
                        skin: 'layui-layer-molv', //样式类名
                        closeBtn: 0,
                        icon: 1
                    }, function () {
                        if (parent && parent.window.initMlxx) {
                            parent.window.initMlxx();
                            var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                            parent.layer.close(index);
                        } else {
                            window.history.go(0);
                        }
                    });
                } else {
                    $('#submitButton').removeAttr("disabled");
                    $('#saveButton').removeAttr("disabled");
                    layer.alert('提交失败！' + (data.message ? data.message : ''), {icon: 0});
                }

            }
        });
    }
    return false;
}

/**
 * 获取form表单数据
 */
function getFormData() {
    var data = {};
    var form = $('form.content-form');
    var fields = form.find('[name]');
    for (var i = 0; i < fields.length; i++) {
        var obj = fields[i];
        //如果是P类型元素
        if ($(obj).is('p')) {
            data[$(obj).attr('name')] = $(obj).text();
        }
        //如果是input元素
        if ($(obj).is('input')) {
            //如果是raodio元素
            if ($(obj).is('input:radio')) {
                //获取选中的radio的值
                if ($(obj).is(':checked')) {
                    data[$(obj).attr('name')] = $(obj).attr('value');
                }
            } else if ($(obj).is('input:checkbox')) {
                //如果是checkbox元素
                data[$(obj).attr('name')] = $(obj).is(':checked') == false ? '0' : '1';
            } else {
                //获取input元素的值
                data[$(obj).attr('name')] = $(obj).val()==null?'':$(obj).val();
            }
        }
        if ($(obj).is('select')) {
            data[$(obj).attr('name')] = $(obj).val()==null?'':$(obj).val();
        }
    }
    return data;
}

/**
 * 下拉选择框加载数据
 * @param el
 * @param debtEle
 * @param params
 * @constructor
 */
function DebtEleStoreDB_bootstrap(el, debtEle, params) {
    debtEle = debtEle.substring(5);
    $.ajax({
        url: '/rzpt/mlgl/getMlxxJcsj_' + debtEle + '.action',
        dataType: "json",
        data: params,
        success: function (data) {
            data = data.data;
            $(el).empty();
            $.each(data, function (index, item) {
                $(el).append("<option value=" + item.GUID + ">" + item.NAME + "</option>");
            });
            $(el).unbind("click");
            flag['DEBT_' + debtEle] = true;
            //非未填报,加载名录数据
            if (flag.DEBT_RZPTLX & flag.DEBT_GQLX & flag.DEBT_HYLY & flag.DEBT_PTZGLX) {
                DebtEleTreeStoreDB_ml('DEBT_ZWDWLX');
            }
            if ($('#mlForm').data("bootstrapValidator")) {
                $('#mlForm').data("bootstrapValidator").resetForm();
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
        }
    });
}

/**
 * 基础数据，下拉树形式
 * @param debtEle
 * @param params
 * @param config
 * @constructor
 */
function DebtEleTreeStoreDB_ml(debtEle, params, config) {
    $.ajax({
        url: 'getDebtEleTreeValue.action',
        dataType: "json",
        data: {
            debtEle: debtEle
        },
        success: function (data) {
            var data1 = data;
            for (var i = 0; i < data1.length; i++) {
                var nodes = [];
                if (data1[i].children.length > 0) {
                    var child = data1[i].children;
                    for (var j = 0; j < child.length; j++) {
                        nodes.push({
                            text: child[j].name,
                            href: child[j].code
                        });
                    }
                    treeData.push({
                        text: data1[i].name,
                        href: data1[i].code,
                        nodes: nodes
                    });
                } else {
                    treeData.push({
                        text: data1[i].name,
                        href: data1[i].code
                    });
                }
            }

            $('#treeview1').treeview({
                data: treeData,         // 数据源
                //showCheckbox: true,   //是否显示复选框
                highlightSelected: true,    //是否高亮选中
                //nodeIcon: 'glyphicon glyphicon-user',    //节点上的图标
                //nodeIcon: 'glyphicon glyphicon-globe',
                emptyIcon: '',    //没有子节点的节点图标
                multiSelect: false,    //多选
                ShowLines: true,
                height: '10px',
                showBorder: true,
                onNodeChecked: function (event, data) {
                },
                onNodeSelected: function (event, data) {
                    if (data.nodes == undefined) {
                        $('[name=ZGDWLX_ID]').val(data.href).change();
                        $('[name=ZGDWLX_NAME]').val(data.text).change();
                        $("#treeview1").hide();
                    }
                }/*,
                onNodeUnselected: function (event, data) {

                    $('[name=ZGDWLX_NAME]').val(data.text);
                }*/
            });
            getMLXX();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
        }
    });
}

/**
 * 侧股权结构结构表单
 */
function createGqjg() {
    var headerJson = [
        {
            xtype: 'rownumberer', width: 45, summaryType: 'count',
            summaryRenderer: function () {
                return '合计';
            }
        },
        {
            dataIndex: "TZF_NAME",
            type: "string",
            text: "投资方全称",
            headerMark: 'star',
            width: 120,
            editor: {xtype: 'textfield', allowBlank: false}
        },
        {
            dataIndex: "RJCZ_AMT",
            type: "float",
            text: "认缴出资额（万元）",
            headerMark: 'star',
            width: 180,
            editor: {
                xtype: 'numberFieldFormat', minValue: 0,
                hideTrigger: true, decimalPrecision: 6
            },
            summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "SJCZ_AMT",
            type: "float",
            text: "实缴出资额（万元）",
            headerMark: 'star',
            width: 180,
            editor: {
                xtype: 'numberFieldFormat', minValue: 0,
                hideTrigger: true, decimalPrecision: 6
            },
            summaryType: 'sum',
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            },
            summaryRenderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "CG_RATE",
            type: "float",
            text: "持股比例（%）",
            headerMark: 'star',
            allowBlank: false,
            align: 'center',
            width: 150,
            editor: {
                xtype: 'numberFieldFormat', minValue: 0,
                hideTrigger: true, decimalPrecision: 6
            },
            renderer: function (value) {
                return Ext.util.Format.number(value, '0,000.00####');
            }
        },
        {
            dataIndex: "REMARK",
            type: "string",
            text: "备注",
            width: 250,
            editor: 'textfield'
        }
    ];
    //设置表格属性
    var config = {
        itemId: 'gqjgGrid',   //股权结构
        renderTo: 'gqjg',
        height: '100%',
        dataUrl: '/rzpt/mlgl/getGqjg.action',
        autoLoad: false,
        checkBox: true,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: false
        },
        pageConfig: {
            enablePage: false
        },
        rowNumber: {
            rowNumber: false// 显示行号
        },
        features: [{
            ftype: 'summary'
        }],
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'gdzcCellEdit',
                clicksToMoveEditor: 1,
                listeners: {
                    'beforeedit': function (editor, context) {
                        if (!editFj) {
                            return false;
                        }
                    },
                    'validateedit': function (editor, context) {
                    },
                    'edit': function (editor, context) {
                        /*if (context.field == 'RJCZ_AMT') {
                            shftz_hj_amt = DSYGrid.getGrid('gqjgGrid').getStore().sum('RJCZ_AMT');
                            var zcsxForm = Ext.ComponentQuery.query('form[name="zcsxFrom"]')[0].getForm().getValues();
                            var XYTZ_AMT = zcsxForm['XYTZ_AMT'];
                            Ext.ComponentQuery.query('form[name="zcsxFrom"]')[0].getForm().findField('ZFZC_AMT').setValue(XYTZ_AMT - shftz_hj_amt);
                        }*/
                    }
                }
            }
        ],
        tbar: [
            {
                xtype: 'button',
                text: '添加',
                frame: false,
                width: 60,
                handler: function (btn) {
                    btn.up('grid').insertData(null, {});

                }
            },
            {
                xtype: 'button',
                itemId: 'shtzqkDelBtn',
                text: '删除',
                frame: false,
                width: 60,
                disabled: true,
                handler: function (btn) {
                    var grid = btn.up('grid');
                    var store = grid.getStore();
                    var sm = grid.getSelectionModel();
                    store.remove(sm.getSelection());
                    if (store.getCount() > 0) {
                        sm.select(0);
                    }
                }
            }
        ]
    };

    //生成表格
    var grid = DSYGrid.createGrid(config);

    //将增加删除按钮添加到表格中
    /*grid.addDocked({
        xtype: 'toolbar',
        layout: 'column',
        items:
    }, 0);*/
    grid.on('selectionchange', function (view, records) {
        grid.down('#shtzqkDelBtn').setDisabled(!records.length);
    });
    return grid;
}

/**
 * 附件上传
 */
function mlxx_fj() {
    return UploadPanel.createGrid({
        busiType: 'ET402',
        busiId: ml_id,
        editable: editFj,
        busiProperty: '%',//业务规则，默认为‘%’
        gridConfig: {
            anchor: '100% -170',
            //height:'100%',
            renderTo: 'fj'
        }
    });
}

var shftzGridCheck = function () {
    //var zcsxForm = Ext.ComponentQuery.query('form[name="zcsxFrom"]')[0];
    //var zcsxFormValues = zcsxForm.getValues();
    var result = '';
    var gqjgStore = DSYGrid.getGrid("gqjgGrid").getStore();
    if (gqjgStore.data.length > 0) {
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
};

function yzMlxx() {
    var temp = $('[name=TYSHXY_CODE]').val();
    //调用change方法来触发bootstrapValidator验证
    $('[name=TYSHXY_CODE]').val(temp).change();
}

function noPermitInput(e) {
    var evt = window.event || e;
    if (isIE()) {
        evt.returnValue = false; //ie 禁止键盘输入
    } else {
        evt.preventDefault(); //fire fox 禁止键盘输入
    }
}

function isIE() {
    if (window.navigator.userAgent.toLowerCase().indexOf("msie") >= 1)
        return true;
    else
        return false;
}
/*
 * 功能：生成一个GUID码，其中GUID以14个以下的日期时间及18个以上的16进制随机数组成，GUID存在一定的重复概率，但重复概率极低，理论上重复概率为每10ms有1/(16^18)，即16的18次方分之1，重复概率低至可忽略不计
 */
function GUID() {
    this.date = new Date();
    /* 判断是否初始化过，如果初始化过以下代码，则以下代码将不再执行，实际中只执行一次 */
    if (typeof this.newGUID != 'function') {
        /* 生成GUID码 */
        GUID.prototype.newGUID = function () {
            this.date = new Date();
            var guidStr = '';
            sexadecimalDate = this.hexadecimal(this.getGUIDDate(), 16);
            sexadecimalTime = this.hexadecimal(this.getGUIDTime(), 16);
            for (var i = 0; i < 9; i++) {
                guidStr += Math.floor(Math.random() * 16).toString(16);
            }
            guidStr += sexadecimalDate;
            guidStr += sexadecimalTime;
            while (guidStr.length < 32) {
                guidStr += Math.floor(Math.random() * 16).toString(16);
            }
            return this.formatGUID(guidStr);
        };
        /*
         * 功能：获取当前日期的GUID格式，即8位数的日期：19700101
         * 返回值：返回GUID日期格式的字条串
         */
        GUID.prototype.getGUIDDate = function () {
            return this.date.getFullYear() + this.addZero(this.date.getMonth() + 1) + this.addZero(this.date.getDay());
        };
        /*
         * 功能：获取当前时间的GUID格式，即8位数的时间，包括毫秒，毫秒为2位数：12300933
         * 返回值：返回GUID日期格式的字条串
         */
        GUID.prototype.getGUIDTime = function () {
            return this.addZero(this.date.getHours()) + this.addZero(this.date.getMinutes()) + this.addZero(this.date.getSeconds()) + this.addZero(parseInt(this.date.getMilliseconds() / 10));
        };

        /*
         * 功能: 为一位数的正整数前面添加0，如果是可以转成非NaN数字的字符串也可以实现
         * 参数: 参数表示准备再前面添加0的数字或可以转换成数字的字符串
         * 返回值: 如果符合条件，返回添加0后的字条串类型，否则返回自身的字符串
         */
        GUID.prototype.addZero = function (num) {
            if (Number(num).toString() != 'NaN' && num >= 0 && num < 10) {
                return '0' + Math.floor(num);
            } else {
                return num.toString();
            }
        };
        /*
         * 功能：将y进制的数值，转换为x进制的数值
         * 参数：第1个参数表示欲转换的数值；第2个参数表示欲转换的进制；第3个参数可选，表示当前的进制数，如不写则为10
         * 返回值：返回转换后的字符串
         */
        GUID.prototype.hexadecimal = function (num, x, y) {
            if (y != undefined) {
                return parseInt(num.toString(), y).toString(x);
            } else {
                return parseInt(num.toString()).toString(x);
            }
        };
        /*
         * 功能：格式化32位的字符串为GUID模式的字符串
         * 参数：第1个参数表示32位的字符串
         * 返回值：标准GUID格式的字符串
         */
        GUID.prototype.formatGUID = function (guidStr) {
            var str1 = guidStr.slice(0, 8) + '-',
                str2 = guidStr.slice(8, 12) + '-',
                str3 = guidStr.slice(12, 16) + '-',
                str4 = guidStr.slice(16, 20) + '-',
                str5 = guidStr.slice(20);
            return str1 + str2 + str3 + str4 + str5;
        }
    }
}
GUID.createGUID = function () {
    return new GUID().newGUID().replaceAll('-', '');
};
String.prototype.replaceAll = function (s1, s2) {
    return this.replace(new RegExp(s1, "gm"), s2);
};