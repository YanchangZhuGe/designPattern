/**
 * 创建编辑弹出窗口
 */
var editWindow = {
    window: null,
    show: function () {
        this.window = initEditWindow();
        this.window.show();
    }
};

/**
 * 初始化编辑模板弹出窗口
 */
function initEditWindow() {
    return Ext.create('Ext.window.Window', {
        itemId: 'editWindow',
        autoScroll:true,//测试属性
        name: 'editWindow',
        title: '上传附件', // 窗口标题
        maximizable: true,
        width: document.body.clientWidth * 0.8,
        height: document.body.clientHeight * 0.9,
        scrollable: true,
        border: false,
        closeAction: 'destroy',
        layout: 'fit',
        maximizable: true,//最大化按钮
        buttonAlign: 'right', // 按钮显示的位置
        modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
        items: initEditWindow_contentForm(),
        buttons: [
            {
                text: '保存',
                handler: function (btn) {
                    doSave(btn);
                }
            },
            {
                text: '取消',
                handler: function (self) {
                    //关闭编辑窗口
                    self.up('window').close();
                }
            }
        ]
    });
}

/**
 * 初始化编辑模板弹出窗口内容
 */
function initEditWindow_contentForm() {
    /**
     * 图片上传功能
     */
    document.uploadImage = function(self){
        var file_type = $(self).val().split('.')[$(self).val().split('.').length-1];
        if (file_type == "png" || file_type == "jpg" || file_type == "jpeg") {
            $('form#title_image_from').ajaxSubmit({
                url: '/layeditUpload.action',
                type: 'POST',
                dataType: 'json',
                data: {},
                resetForm: true,
                clearForm: true,
                success: function (result) {
                    if(result.code == '0'){
                        //提示上传成功
                        Ext.toast({
                            html: '<div style="text-align: center;">上传成功!</div>',
                            closable: false,
                            align: 't',
                            slideInDuration: 400,
                            minWidth: 400
                        });
                        document.getElementById("titleimage").src = result.data.src;
                        Ext.ComponentQuery.query("#TITLE_IMAGE")[0].setValue(result.data.src);
                    }else{
                        Ext.Msg.alert('提示', "上传失败！");
                    }
                }
            });
        }else{
            Ext.MessageBox.alert("提示", "请选择png、jpg、jpeg文件格式图片！");
            return;
        }
    }

    /**
     * 图片预览功能
     */
    document.proviewImage = function(self){
        var browserInfo = getBrowserInfo();
        if (browserInfo["browser"] == "IE" && browserInfo["version"] == "8.0"){
            proviewImageWindow(800, 800, self);
        } else {
            proviewImageWindow(self.naturalWidth, self.naturalHeight, self);
        }
    }

    proviewImageWindow = function(naturalWidth, naturalHeight, self){
        var innerWidth = 300;
        var innerHeight = 300;
        if (naturalWidth > 300 && naturalWidth < 1000 ) {
            innerWidth = naturalWidth;
        } else if (self.naturalWidth >= 1000) {
            innerWidth = document.body.clientWidth * 0.95;
        }
        if (naturalHeight > 300 && naturalHeight < 800 ) {
            innerHeight = self.naturalHeight;
        } else if (naturalHeight >= 800) {
            innerHeight = document.body.clientHeight * 0.95;
        }
        Ext.create('Ext.window.Window', {
            title: '图片预览',
            maximizable: true,
            modal: true, // 模式窗口，弹出窗口后屏蔽掉其他组件
            width: innerWidth,
            height: innerHeight,
            scrollable: true,
            items: [{
                xtype: 'box', //或者xtype: 'component',
                id: 'imagebox',
                layout: 'hbox',
                autoEl: {
                    tag: 'img',    //指定为img标签
                    src: self.src  //指定url路径
                }
            }],
            listeners: {
                afterlayout: function(self, eOpts){
                    var header = $(self.el.dom).find("div.x-window-header")[0];
                    var body = $(self.el.dom).find("div.x-window-body")[0];
                    header.style.display = 'none';
                    body.style.top = '0px';
                    body.style.left = '0px';
                    body.style.right = '0px';
                    body.style.botton = '0px';
                    body.style.border = '3px solid white';
                    body.style.width = innerWidth + 'px';
                    body.style.height = innerHeight + 'px';
                    self.el.dom.style.border = '0px solid #FFFFFF';
                    $(body).bind('click', function(){
                        self.close();
                    });
                }
            }
        }).show();
    }

    document.titleImageDelete = function(){
        $.post('deleteFileByFilePath.action', {
            imagePath: Ext.ComponentQuery.query("#TITLE_IMAGE")[0].getValue()
        }, function(data){
            if(data.success){
                Ext.toast({
                    html: '<div style="text-align: center;">删除成功!</div>',
                    closable: false,
                    align: 't',
                    slideInDuration: 400,
                    minWidth: 400
                });
                document.getElementById("titleimage").src = '/page/plat/article/images/uploadImage.png';
                Ext.ComponentQuery.query("#TITLE_IMAGE")[0].setValue('');
                document.getElementById("imageupload").value = '';
            }else{
                Ext.Msg.alert('提示', "删除失败！");
            }
        },'json');
    }
    //初始化form表单
    return Ext.create('Ext.tab.Panel', {
        name: 'detailForm',
        width: '100%',
        scrollable:true,
        height: '100%',
        border: false,
        items: [{
            xtype: 'form',
            title: '上传文件内容',
            layout: 'column',
            scrollable: true,
            items: [
                {
                    xtype: 'panel',
                    columnWidth: .88,
                    defaultType: 'textfield',
                    layout: 'column',
                    border: false,
                    style: {borderColor: '#e1e1e1', borderStyle: 'solid', borderWidth: '1px'},
                    defaults: {
                        labelWidth: 60,
                        padding: '2 5 2 5',
                        labelAlign: 'right'
                    },
                    items: [
                        {
                            xtype: 'textfield',
                            name: 'TITLE',
                            fieldLabel: '标题',
                            columnWidth: .5,
                            columnWidth: .999,
                            allowBlank: false
                        },
                        {
                            fieldLabel: '附件内容',
                            name: 'FJMS',
                            columnheight: 35,
                            height:300,
                            columnWidth: .999,
                            xtype: 'textarea',
                            maxLength:1000,//限制输入字数
                        }
                    ]
                }
            ]
        },{
            title: '附件',
            collapsible: true,
            layout:'fit',
            name: 'FILE',
            items: initWindow_article_fj()
        }
        ]
    });
}
/**
 * 初始化附件
 */
function initWindow_article_fj() {
    return UploadPanel.createGrid({
        busiType: '',//业务类型
        busiId: editWindow.FJ_ID,//业务ID
        editable: true,//是否可以修改附件内容
        gridConfig: {
            itemId: 'window_zqxxtb_contentForm_tab_xmfj_grid'
        }
    });
}
/**
 * 点击保存按钮
 */
function doSave(btn) {
    var detailForm = btn.up('window').down('tabpanel').down('form');
    var formData = detailForm.getForm().getFieldValues();
    formData = $.extend({}, formData, detailForm.getValues());
    if (detailForm.isValid()) {
        var params = {
            detailForm: '[' + Ext.util.JSON.encode(formData) + ']',
            fjID: editWindow.FJ_ID
        };
        if (button_name == '修改') {
            params.savetype = 'MODIFY';
        }
        //发送请求保存/修改数据
        detailForm.submit({
            url: 'saveFjxxDetail.action',
            params: params,
            waitTitle: '请等待',
            waitMsg: '正在保存中...',
            success: function (form, action) {
                if (action.result.success) {
                    Ext.toast({
                        html: "保存成功！",
                        closable: false,
                        align: 't',
                        slideInDuration: 400,
                        minWidth: 400
                    });
                } else {
                    Ext.MessageBox.alert('提示', '保存失败：' + action.result.message);
                }
                //关闭编辑模板窗口
                btn.up('window').close();
                //刷新表格
                reloadGrid();
            },
            failure: function (form, action) {
                Ext.MessageBox.alert('提示', '保存失败！');
            }
        });
    } else{
        btn.up('window').down('tabpanel').setActiveTab(0);
    }
}
