var cruConfig = {
	cruAction:'view',		
	contextPath:'',
	loadFinished:'false',	
	querySql:'',
	entity:null,
	openerUrl:'',	
	CURRENT_DATE:'CURRENT_DATE',
	CURRENT_DATE_TIME:'CURRENT_DATE_TIME'
}


function cru_init(){
	path = cruConfig.contextPath+appConfig.queryListAction;
	var queryRet = syncRequest('Post',path,'querySql='+cruConfig.querySql);
	jcdp_record = queryRet.datas[0];
	
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






