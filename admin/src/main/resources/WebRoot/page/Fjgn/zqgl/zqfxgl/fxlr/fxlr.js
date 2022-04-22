function saveFxlrInfo(btn,btnName){

	if(!btn.up('window').down('form').isValid()){
		Ext.MessageBox.alert('提示', "请先检查必填项校验!");
		return;
	}
	var fxlrForm=btn.up('window').down('form').getValues();
	var fxlrTemp=DSYGrid.getGrid('fxsGrid').getStore().getData().items;
	var fxlrGrid=[];
	var fxAmt=0;
	for(var i=0;i<fxlrTemp.length;i++){
		fxlrGrid.push(fxlrTemp[i].data);
		fxAmt+=fxlrTemp[i].data.FXJE;
	}
	if(fxAmt>fxlrForm.SYKFXAMT){
		Ext.Msg.alert('提示', "分销金额总和不能大于剩余可分销金额!");
		return;
	}
	var param={
			fxlrForm:Ext.util.JSON.encode(fxlrForm),
			btnName:btnName,
			fxlrGrid:Ext.util.JSON.encode(fxlrGrid)
	};
	$.post("/fxlr/saveFxlrInfo.action",param,function(data){
		if(Ext.util.JSON.decode(data).success==true){
			//关闭弹出框
            btn.up("window").close();
            //提示保存成功
            Ext.toast({html: '<div style="text-align: center;">保存成功!</div>'});
            reloadGrid();
		}else{
            Ext.Msg.alert('提示', "保存失败！" + Ext.util.JSON.decode(data).message);
		}
	});


}