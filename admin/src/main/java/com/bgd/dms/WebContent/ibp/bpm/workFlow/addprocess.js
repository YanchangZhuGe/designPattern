
//
XiorkFlowWorkSpace.build();

//
function init() {
    Message.setOutter(Toolkit.getElementByID("message"));

    //
    var designerDiv = Toolkit.getElementByID("designer");
    var xiorkFlow = new XiorkFlow(designerDiv);
    xiorkFlow.setProcessList(window.dialogArguments);

	//
    document.body.onbeforeunload = function () {
        if (xiorkFlow.getWrapper().isChanged()) {
    	    //您对工作流程图的编辑尚未保存，离开该页面将退出系统!
            window.event.returnValue = "\u60a8\u5bf9\u5de5\u4f5c\u6d41\u7a0b\u56fe\u7684\u7f16\u8f91\u5c1a\u672a\u4fdd\u5b58\uff0c\u79bb\u5f00\u8be5\u9875\u9762\u5c06\u9000\u51fa\u7cfb\u7edf!";
        }
    };
}

