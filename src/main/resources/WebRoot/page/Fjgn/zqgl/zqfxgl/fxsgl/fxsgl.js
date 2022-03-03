function saveFxsglInfo(btnName,btn){

	if(!btn.up('window').down('form').isValid()){
		Ext.MessageBox.alert('提示', "请先检查必填项校验!");
		return;
	}
	var fxsglForm=btn.up('window').down('form').getValues();
	var param={
			fxsglForm:Ext.util.JSON.encode(fxsglForm),
			btnName:btnName
	};
	$.post("/fxsgl/saveFxsjgInfo.action",param,function(data){
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