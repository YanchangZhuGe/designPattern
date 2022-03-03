
/**
 * 保存会计核算信息数据
 */
function saveKjhsInfo(btn,btnName){

	if(!btn.up('window').down('form').isValid()){
		Ext.MessageBox.alert('提示', "请先检查必填项校验!");
		return;
	}
	var kjhsForm=btn.up('window').down('form').getValues();
	var kjhsGridTemp=DSYGrid.getGrid('kjhsmxGrid').getStore().getData().items;
	var kjhsGrid=[];
	for(var i=0;i<kjhsGridTemp.length;i++){
		kjhsGrid.push(kjhsGridTemp[i].data);
	}
	$.post("/kjhs/saveKjhsData.action",{
		kjhsForm:Ext.util.JSON.encode(kjhsForm),
		btnName:btnName,
		agCode:AG_CODE,
		kjhsGrid:Ext.util.JSON.encode(kjhsGrid)
	},function(data){
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

/**
 * 
 * @param dataURL
 * @returns获得项目信息数据
 */
function getJSXMStore(dataURL) {
    var store = Ext.create('Ext.data.Store', {
        fields: ["XM_ID", "XM_CODE", "XM_NAME", "LX_YEAR", "JSXZ_NAME", "XMXZ_NAME", "XMLX_NAME", "BUILD_STATUS_NAME", "XMZGS_AMT"],
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
        autoLoad: true
    });
    return store;
}