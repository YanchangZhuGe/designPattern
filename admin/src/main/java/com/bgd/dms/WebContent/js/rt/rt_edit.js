var cruConfig = {
	cruAction:'edit',	
	lineRange:'2',
	contextPath:'',
	loadFinished:'false',
	querySql:'',
	queryItemsSql:'',
	entity:null,
	updateAction:'/rad/addOrUpdateEntity.srq',
	addOrUpdateAction:'/rad/addOrUpdateEntity.srq',
	updateCmpxAction:'/rad/addOrUpdateCmpxEntity.srq',
	updateMulTableAction:'/rad/addOrUpdateMulTableData.srq',
	openerUrl:'',	
	CURRENT_DATE:'CURRENT_DATE',
	CURRENT_DATE_TIME:'CURRENT_DATE_TIME'
}



function cru_init(){
	var queryRet;
	if(cruConfig.queryListAction != null && cruConfig.queryListAction != '' ){
		path = cruConfig.contextPath+cruConfig.queryListAction;
		queryRet = syncRequest('Post',path,'');
		jcdp_record = queryRet.datas[0];
	}
	else {
		path = cruConfig.contextPath+appConfig.queryListAction;
		queryRet = syncRequest('Post',path,'querySql='+cruConfig.querySql);
		jcdp_record = queryRet.datas[0];
	}
	
	initSelCodes();
	initCreateTable();
	cruConfig.loadFinished = 'true';
}

/**
  主子表在同一个页面的初始化
*/
function cmpx_init(){
	var path = cruConfig.contextPath+"/rad/queryCmpxEntity.srq";
	var queryRet = syncRequest('Post',path,'querySql='+cruConfig.querySql+'&queryItemsSql='+cruConfig.queryItemsSql);
	jcdp_record = queryRet.entity;
	
	initSelCodes();
	initCreateTable();
	initItems(queryRet.items);
	cruConfig.loadFinished = 'true';
}




/**
  初始化编辑实体的输入表格

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









