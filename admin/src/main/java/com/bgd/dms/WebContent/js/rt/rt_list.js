var cruConfig ={
	//参数区
	totalRows:24,
	currentPage:1,
	funcCode:'',
	items:'datas',
	//查询列表数据的action
	queryAction:'/rad/asyncQueryRelationedIds.srq',
	//查询SQL语句
	queryStr:'',
	cdtStr:'',
	//查询服务与操作
	queryService:'',
	queryOp:'',
	cdtType:'select',
	//变量区
	relationParams:'',
	relationedIds:'',
	currentPageRlIds:'',
	cruAction:'list',
	pageCount:1,
	contextPath:'',
	currentPageUrl:'',
	//for在线编辑
	editedColumnNames:'',
	editAction:'/rad/addOrUpdateEntities.srq',
	editTableParams:'',
	//常量区
	pageSize:10,
	dataRowHint_id:'dataRowHint',
	navTable_id:'navTableId',
	queryRetTable_id:'queryRetTable',
	changePage_id:'changePage'
}

function getColValue(chkboxValue,colPos){
	var chxBoxes = document.getElementsByName("chx_entity_id");
	if(chxBoxes==undefined) return;
	for(var i=0;i<chxBoxes.length;i++)
		if(chxBoxes[i].value==chkboxValue){
			var tr = chxBoxes[i].parentElement.parentElement;
			return tr.cells[colPos].innerText;
		}
}

function updateEntitiesBySql(sql,label){
	var ids = getSelIds("chx_entity_id");
	if(ids==""){
		alert("请先选中一条记录!");
		return;
	}
	if (!window.confirm("确认要"+label+"吗?")) {
			return;
	}
	var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
	var params = "sql="+sql;
	params += "&ids="+ids;
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0) alert(retObject.returnMsg);
	else queryData(cruConfig.currentPage);
}


function head_chx_box_changed(headChx){
	var chxBoxes = document.getElementsByName("chx_entity_id");
	if(chxBoxes==undefined) return;
	for(var i=0;i<chxBoxes.length;i++)
	  if(!chxBoxes[i].disabled)
			chxBoxes[i].checked = headChx.checked;
}

function queryRelationedIds(submitStr){
	var path = cruConfig.contextPath+cruConfig.queryAction;
	var retObject = syncRequest('Post',path,submitStr);
	if(retObject.returnCode!=0) alert(retObject.returnMsg);
	else cruConfig.relationedIds = retObject.relationedIds;
}

function addSelectEntities(){
	var ids = getSelIds("chx_entity_id");
	if(ids=="" && cruConfig.currentPageRlIds == ''){
		alert("请先选中一条记录!");
		return;
	}
	var path = cruConfig.contextPath+"/rad/asyncAddSelectedIds.srq";
	var submitStr = cruConfig.relationParams+"&selectedIds="+ids;
	submitStr += "&originIds="+cruConfig.currentPageRlIds;
	var retObject = syncRequest('Post',path,submitStr);
	cruConfig.relationedIds = retObject.relationedIds;
	return retObject;
}

function deleteEntities(deleteSql,funCode,hint){
	if(hint==undefined) hint = "确认要删除吗?";
	var ids = getSelIds("chx_entity_id");
	if(ids==""){
		alert("请先选中一条记录!");
		return;
	}
	if (!window.confirm(hint)) {
			return;
	}
	if(funCode!=undefined){
		if(!validateBusiCsst(funCode,ids,hint)) return;
	}

	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
	var params = "deleteSql="+deleteSql;
	params += "&ids="+ids;
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0) alert(retObject.returnMsg);
	else queryData(cruConfig.currentPage);
}

function refreshData(){
	queryData(cruConfig.currentPage);
}

function queryData(targetPage){
    var querySql='';
	cruConfig.currentPage = eval(targetPage);
	var submitStr = "currentPage="+targetPage+"&pageSize="+cruConfig.pageSize;
	if(cruConfig.funcCode!='') submitStr += "&EP_DATA_AUTH_funcCode="+cruConfig.funcCode;
	var retObject;
//	alert(cruConfig.queryService);
	if(cruConfig.queryService!=''){//调用服务查询
		if(cruConfig.cdtStr!=''){
			submitStr += "&querySql="+cruConfig.cdtStr;
		}
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		if(cruConfig.submitStr!='')submitStr += "&"+cruConfig.submitStr;
//		alert(cruConfig.queryService+"---------------"+cruConfig.queryOp+"-------------"+submitStr)
		retObject = jcdpCallService(cruConfig.queryService,cruConfig.queryOp,submitStr);
	}
	else if(cruConfig.queryListAction != null){
		if(cruConfig.cdtStr!=''){

			submitStr += "&querySql="+cruConfig.cdtStr;
		}
		//alert(submitStr);
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);

		var path = cruConfig.contextPath+cruConfig.queryListAction;
		retObject = syncRequest('Post',path,submitStr);
	}
	else{//根据sql查询
		querySql = cruConfig.queryStr;
		if(cruConfig.cdtStr!=''){
			if(querySql!=''){
				querySql = "Select dataAuthView.* FROM ("+querySql+")dataAuthView WHERE "+cruConfig.cdtStr;}
			else{
				querySql = cruConfig.cdtStr;
			}
		}
		submitStr += "&querySql="+querySql;
		//alert(submitStr)
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);

		var path = cruConfig.contextPath+appConfig.queryListAction;
		retObject = syncRequest('Post',path,submitStr);
	}
	if (retObject.returnCode != "0") return;
	cruConfig.items = retObject.datas;
	cruConfig.totalRows = retObject.totalRows;
	renderTable(getObj(cruConfig.queryRetTable_id),cruConfig);

	cruConfig.currentPageRlIds = '';
	if(cruConfig.relationedIds!=''){
		var chxs = document.getElementsByName("chx_entity_id");
		for(var i=0;i<chxs.length;i++)
			if(cruConfig.relationedIds.indexOf(chxs[i].value)>=0){
				 chxs[i].checked = true;
				 if(cruConfig.currentPageRlIds=='') cruConfig.currentPageRlIds = chxs[i].value;
				 else cruConfig.currentPageRlIds += ','+chxs[i].value;
			}
	}
}

/*
*转到第几页
*/
function changePage(){
	var page = getObj(cruConfig.changePage_id).value;
	if(page<1 || page>cruConfig.pageCount){
		alert("请重新输入合法的页数!");
		getObj(cruConfig.changePage_id).focus();
		return;
	}
	queryData(page);
}

/*
*上一页，下一页
*/
function naviQuery(targetPage){
	var path = cruConfig.contextPath+appConfig.queryListAction;

	if(path.indexOf('?')<=0){
		path += "?currentPage="+targetPage+"&pageSize="+cruConfig.pageSize;
	}
	else path += "&currentPage="+targetPage+"&pageSize="+cruConfig.pageSize;
	cruConfig.currentPage = targetPage;

}

/**
  选择一行记录，将主键和名称写入parent window
*/
function onRowSelect(trObj){
	var obj = window.dialogArguments;
	obj.fkValue = trObj.cells[0].innerText;
	obj.value = trObj.cells[1].innerText;
	window.close();
}

/*
*查询结果的显示
*/
function renderTable(tbObj,tbCfg){
	//更新导航栏
	renderNaviTable(tbObj,tbCfg);
	//删除上次的查询结果
	var headChxBox = getObj("headChxBox");
	if(headChxBox!=undefined) headChxBox.checked = false;
	for(var i=tbObj.rows.length-1;i>0;i--)
		tbObj.deleteRow(i);

	var titleRow = tbObj.rows(0);
	var datas = tbCfg.items;
	if(datas!=null)
	for(var i=0;i<datas.length;i++){
		var data = datas[i];
		var vTr = tbObj.insertRow();
		if(i%2 == 1) vTr.className = "even";
		else vTr.className = "odd";
		vTr.initClassName = vTr.className;

		if(cruConfig.cruAction=='list2Link'){//列表页面选择坐父页面某元素的外键
			vTr.onclick = function(){
				eval(rowSelFuncName+"(this)");
			}
			vTr.onmouseover = function(){this.className = "trSel";}
			vTr.onmouseout = function(){this.className = this.initClassName;}
		}

		for(var j=0;j<titleRow.cells.length;j++){
			var tCell = titleRow.cells(j);
			var vCell = vTr.insertCell();
			var outputValue = getOutputValue(tCell,data);
			var cellValue = outputValue;
			if(i%2==1){
				if(j%2==1) vCell.className = "even_even";
				else vCell.className = "even_odd";
			}else{
				if(j%2==1) vCell.className = "odd_even";
				else vCell.className = "odd_odd";
			}
			if(tCell.isShow=="Edit"){
				cellValue = "<input type=text onclick=tableInputEditable(this) onkeydown=tableInputkeydown(this) class=rtTableInputReadOnly";
				if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName
				else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2);
				if(tCell.size!=undefined) cellValue += " size="+tCell.size;
				else cellValue += " size=8";
				cellValue += " value='"+outputValue+"'>";
			}
			else if(tCell.isShow=="Hide"){
				cellValue = "<input type=text value="+outputValue;
				if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName+">"
				else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2)+">";
				vCell.style.display = 'none';
			}else if(tCell.isShow=="TextHide"){
				vCell.style.display = 'none';
			}

			if(typeof cellValue == undefined || cellValue == 'undefined') cellValue = "";
			if(cellValue=='') {cellValue = "&nbsp;";}
			else if(cellValue.indexOf("undefined")!=-1){
			   cellValue = cellValue.replace("undefined","");
			}

			vCell.innerHTML = cellValue;
		}
	}
}

function tableInputEditable(obj){
	obj.className = 'rtTableInputEdit';
}

function tableInputkeydown(obj){
	var evt =window.event;
	if(evt.keyCode!=13 && evt.keyCode!=27) return;

	if(cruConfig.editedColumnNames=='') return;
	var colNameArray = cruConfig.editedColumnNames.split(",");

	var inputMatrix = {};
	for(var i=0;i<colNameArray.length;i++)
		inputMatrix[i] = document.getElementsByName(colNameArray[i]);

	if(evt.keyCode==27){
		for(var i=0;i<inputMatrix[0].length;i++)
			for(var j=0;j<colNameArray.length;j++){
				if(inputMatrix[j][i].className=='rtTableInputEdit')
					inputMatrix[j][i].className='rtTableInputReadOnly';
			}
		obj.blur();
		return;
	}

	var rowParams = new Array();
	for(var i=0;i<inputMatrix[0].length;i++){//编辑的行数
		var rowParam = {};
		var rowEdited = false;
		for(var j=0;j<colNameArray.length;j++){
			rowParam[colNameArray[j]] = encodeURI(inputMatrix[j][i].value);
			rowParam[colNameArray[j]] = encodeURI(rowParam[colNameArray[j]]);
			if(!rowEdited && inputMatrix[j][i].className=='rtTableInputEdit') rowEdited = true;
		}
		if(rowEdited) rowParams[rowParams.length] = rowParam;
	}

	if(!onlineEdit(rowParams)) return;

	for(var i=0;i<inputMatrix[0].length;i++)
		for(var j=0;j<colNameArray.length;j++){
			if(inputMatrix[j][i].className=='rtTableInputEdit')
				inputMatrix[j][i].className='rtTableInputReadOnly';
		}
	obj.blur();
}

function getOutputValue(tCell,data){
	var ret = "";
	var funcArray = [''];
	if(tCell.func!=undefined)
		 funcArray = tCell.func.split(",");
	//alert(tCell.func);
	if(funcArray[0]=="none"){
		ret = tCell.exp;
	}
	else{//替换
		ret = tCell.exp;
		if(ret==undefined)
		  return ret;

		var data_id = ret.match(/\{[\w_][\w_\d]*\}/);

		while(data_id!=null){
			data_id = data_id+"";
			var data_value = data[data_id.substr(1,data_id.length-2)];
			data_value = processData(funcArray,data_value,data_id.substr(1,data_id.length-2));
		  pattern = new RegExp(data_id);
		  ret = ret.replace(pattern,data_value);

		  data_id = ret.match(/\{[\w_][\w_\d]*\}/);
		}
	}
	return ret;
}

/*
*值处理函数
*/
function processData(funcArray,data_value,fdName){
	var ret = data_value;
	if("substr"==funcArray[0]){
		ret = ret.substr(funcArray[1],funcArray[2]);
	}
	else if("getOpValue"==funcArray[0]){
		var ops = eval(funcArray[1]);
		for(var i=0;i<ops.length;i++)
			if(ops[i][0]==data_value){
				 ret = ops[i][1];
				 break;
			}
		if(i==ops.length) ret = ops[0][1];
	}
	else if("cdtConvert"==funcArray[0]){
		if(funcArray[4]==undefined || funcArray[4]==fdName){
			var reg = eval(funcArray[1]);
			if(reg.test(data_value)) ret = funcArray[2];
			else ret = funcArray[3];
		}
	}
	return ret;
}


/*
*查询导航栏的显示
*/
function renderNaviTable(tbObj,tbCfg){
	if(tbCfg.totalRows==0){
		tbCfg.pageCount = 0;
		tbCfg.currentPage = 0;
	}
	else{
		tbCfg.pageCount = Math.ceil(tbCfg.totalRows/tbCfg.pageSize);
		if(tbCfg.currentPage==0) tbCfg.currentPage = 1;
	}
	/*var hintSpan = getObj(tbCfg.dataRowHint_id);
	hintSpan.innerHTML = "第"+tbCfg.currentPage+"/"+tbCfg.pageCount+"页，共"+tbCfg.totalRows+"条记录";
	var navTableRow = getObj(tbCfg.navTable_id).rows(0);
	if(tbCfg.currentPage<=1){//当前是第一页
		navTableRow.cells(0).innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_01.png'  style='border:0'  alt='First' />";
		navTableRow.cells(1).innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_02.png'  style='border:0'  alt='Prev' />";
	}else{
		navTableRow.cells(0).innerHTML = "<a href='javascript:queryData(1)'><img src='"+cruConfig.contextPath+"/images/fenye_01.png'  style='border:0'  alt='First' /></a>";
		navTableRow.cells(1).innerHTML = "<a href='javascript:queryData("+(tbCfg.currentPage-1)+")'><img src='"+cruConfig.contextPath+"/images/fenye_02.png'  style='border:0'  alt='Prev' /></a>";
	}
	if(tbCfg.currentPage>=tbCfg.pageCount){//当前是最后一页
		navTableRow.cells(2).innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_03.png'  style='border:0'  alt='Next' />";
		navTableRow.cells(3).innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_04.png'  style='border:0'  alt='Last' />";
	}else{
		navTableRow.cells(2).innerHTML = "<a href='javascript:queryData("+(tbCfg.currentPage+1)+")'><img src='"+cruConfig.contextPath+"/images/fenye_03.png'  style='border:0'  alt='Next' /></a>";
		navTableRow.cells(3).innerHTML = "<a href='javascript:queryData("+(tbCfg.pageCount)+")'><img src='"+cruConfig.contextPath+"/images/fenye_04.png'  style='border:0'  alt='Last' /></a>";
	}
	*/
	var table = getObj("rtToolbarDiv").childNodes[0];
	
	var tr = table.rows[0];

	var tds = tr.childNodes;
	for(var i=tds.length-1;i>=0;i--){
		tr.removeChild(tds[i]);
	}
	
	var td1 = document.createElement("td");
	td1.align = "right";
	td1.innerHTML = "第"+tbCfg.currentPage+"/"+tbCfg.pageCount+"页，共"+tbCfg.totalRows+"条记录";
	tr.appendChild(td1);
	
	var td2 = document.createElement("td");
	td2.width = "10px";
	td2.innerHTML = "&nbsp;";
	tr.appendChild(td2);
	
	var td3 = document.createElement("td");
	td3.width = "30px";
	if(tbCfg.currentPage<=1){//当前是第一页
		td3.innerHTML = "<img src='" + cruConfig.contextPath + "/images/fenye_01.png' width='20' height='20' />";
	}else{
		td3.innerHTML = "<a href='javascript:queryData(1)'><img src='" + cruConfig.contextPath + "/images/fenye_01.png' width='20' height='20' /></a>";
	}
	tr.appendChild(td3);
	
	var td4 = document.createElement("td");
	td4.width = "30px";
	if(tbCfg.currentPage<=1){//当前是第一页
		td4.innerHTML = "<img src='" + cruConfig.contextPath + "/images/fenye_02.png' width='20' height='20' />";
	}else{
		td4.innerHTML = "<a href='javascript:queryData("+(tbCfg.currentPage-1)+")'><img src='" + cruConfig.contextPath + "/images/fenye_02.png' width='20' height='20' /></a>";
	}
	tr.appendChild(td4);

	var td5 = document.createElement("td");
	td5.width = "30px";
	if(tbCfg.currentPage>=tbCfg.pageCount){//当前是最后一页
		td5.innerHTML = "<img src='" + cruConfig.contextPath + "/images/fenye_03.png' width='20' height='20' />";
	}else{
		td5.innerHTML = "<a href='javascript:queryData("+(tbCfg.currentPage+1)+")'><img src='" + cruConfig.contextPath + "/images/fenye_03.png' width='20' height='20' /></a>";
	}
	tr.appendChild(td5);

	var td6 = document.createElement("td");
	td6.width = "30px";
	if(tbCfg.currentPage>=tbCfg.pageCount){//当前是最后一页
		td6.innerHTML = "<img src='" + cruConfig.contextPath + "/images/fenye_04.png' width='20' height='20' />";
	}else{
		td6.innerHTML = "<a href='javascript:queryData("+(tbCfg.pageCount)+")'><img src='" + cruConfig.contextPath + "/images/fenye_04.png' width='20' height='20' /></a>";
	}
	tr.appendChild(td6);

	var td7 = document.createElement("td");
	td7.width = "50px";
	td7.innerHTML = "<label><input type='text' name='textfield' id='textfield' style='width:20px;'/></label>";
	tr.appendChild(td7);

	var td8 = document.createElement("td");
	td8.align = "left";
	td8.innerHTML = "<img src='" + cruConfig.contextPath + "/images/fenye_go.png' width='20' height='20' />";
	tr.appendChild(td8);
}