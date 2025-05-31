var cruConfig = {
	cruAction:'add',
	lineRange: '2',
	contextPath:'',
	loadFinished:'false',
	addAction:'/rad/addOrUpdateEntity.srq',
	addOrUpdateAction:'/rad/addOrUpdateEntity.srq',
	addCmpxAction:'/rad/addOrUpdateCmpxEntity.srq',
	updateMulTableAction:'/rad/addOrUpdateMulTableData.srq',	
	addMulTableAction:'/rad/addOrUpdateMulTableData.srq',	
	openerUrl:'',
	CURRENT_DATE:'CURRENT_DATE',
	CURRENT_DATE_TIME:'CURRENT_DATE_TIME'
}



function cru_init(){
	initSelCodes();
	initCreateTable();
	cruConfig.loadFinished = 'true';
}


/**
  初始化新建实体的输入表格

function initCreateTable(){
	var cruTable = getObj("rtCRUTable");
	var fieldConfig = {
		memoField:null,
		nextPos:0,
		origRowLn:0
	}
	
	//fieldConfig.origRowLn = cruTable.rows.length-1;
	field = getField(fieldConfig);
	while(field!=null){
		vTr = cruTable.insertRow(fieldConfig.origRowLn++);					
		generateFieldInput(vTr,field,fieldConfig);
		field = getField(fieldConfig);	
		if(cruConfig.lineRange=='1') continue;
		generateFieldInput(vTr,field,fieldConfig);
		field = getField(fieldConfig);	
	}
	
	//备注字段
	if(fieldConfig.memoField!=null){
		vTr = cruTable.insertRow(-1);	
		generateFieldMemo(vTr,fieldConfig.memoField);
	}
}*/