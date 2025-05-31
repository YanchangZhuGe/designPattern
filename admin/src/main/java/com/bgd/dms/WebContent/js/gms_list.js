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
	pageSizeMax:100000000,
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

var hideExportAreaTimer;
function exportData(dataType){
	if(dataType == 'arc'){//设备模块导出档案
		$tip = $("<div id='exportArea' style='position:absolute; left:" + (event.clientX-90) + "px; top:" + (event.clientY+10) + "px; width:75px; height:90px; padding: 5px; border:1px solid; text-align: center; background: white; '></div>");
	}else if(dataType == 'zyda'){//震源档案导出
		$tip = $("<div id='exportArea' style='position:absolute; left:" + (event.clientX-90) + "px; top:" + (event.clientY+10) + "px; width:75px; height:90px; padding: 5px; border:1px solid; text-align: center; background: white; '></div>");
	}else{
		$tip = $("<div id='exportArea' style='position:absolute; left:" + (event.clientX-90) + "px; top:" + (event.clientY+10) + "px; width:75px; height:60px; padding: 5px; border:1px solid; text-align: center; background: white; '></div>");
	}
	$tip.bind('mouseover', exportAreaMouseover);
	$tip.bind('mouseout', exportAreaMouseout);
	
	$curpage = $("<div style='position:relative; border: 1px solid; padding-top: 3px; margin-bottom: 5px; height: 22px; cursor: pointer;' onclick='exportData2()'>导出当前页</div>");
	$tip.append($curpage);
	
	$allpage = $("<div style='position:relative; border: 1px solid; padding-top: 3px; margin-bottom: 5px; height: 22px; cursor: pointer; ' onclick='exportData2(1,100000)'>导出全部页</div>");
	$tip.append($allpage);
	if(dataType == 'arc'){//设备模块导出档案
		$arcpage = $("<div style='position:relative; border: 1px solid; padding-top: 3px; margin-bottom: 5px; height: 22px; cursor: pointer; ' onclick='expDataExcel()'>导出设备档案</div>");
		$tip.append($arcpage);
	}
	if(dataType == 'zyda'){//震源档案导出
		$arcpage = $("<div style='position:relative; border: 1px solid; padding-top: 3px; margin-bottom: 5px; height: 22px; cursor: pointer; ' onclick='expDataExcel()'>导出震源档案</div>");
		$tip.append($arcpage);
	}
	$(document.body).append($tip);
	
	hideExportAreaTimer = setTimeout(hideExportArea,1000);
}
function hideExportArea(){
	$('#exportArea').remove();
}
function exportAreaMouseover(){
	clearTimeout(hideExportAreaTimer);
}
function exportAreaMouseout(){
	hideExportAreaTimer = setTimeout(hideExportArea,1000);
}
//导出数据
function exportData2(curPage, pageSize){
	
	hideExportArea();
	
	if(curPage==undefined) curPage=cruConfig.currentPage;
	if(pageSize==undefined) pageSize=cruConfig.pageSize;
	
	var titleRow = getObj('queryRetTable').rows[0];
	var columnExp="";
	var columnTitle="";
	for(var j=0;j<titleRow.cells.length;j++){
		var tCell = titleRow.cells[j];
		if(tCell.exp==null || tCell.exp=="null" || tCell.exp.indexOf("{")>0 || tCell.isExport=="Hide") continue;
		columnExp += tCell.exp.substring(1,tCell.exp.length-1) + ",";
		columnTitle += tCell.innerHTML + ",";
	}

	// file name
	var fmenuFrame = parent.frames["fourthMenuFrame"];
	//var fmenuFrame = parent.parent.frames["fourthMenuFrame"];//DMS中左侧有树形结构时使用
	if( fmenuFrame!=null){
     excel_name = fmenuFrame.selectedTag.childNodes[0].innerHTML;
	} else {
		excel_name= document.getElementById("export_name").value;
	}
	
	var querySql='';
	var submitStr = "currentPage="+curPage+"&pageSize="+pageSize;
	var path = '';
	if(cruConfig.funcCode!='') submitStr += "&EP_DATA_AUTH_funcCode="+cruConfig.funcCode;
	var retObject;

	if(cruConfig.queryService!=''){//调用服务查询
		if(cruConfig.cdtStr!=''){
			submitStr += "&querySql="+cruConfig.cdtStr;
		}

		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		if(cruConfig.submitStr!='')submitStr += "&"+cruConfig.submitStr;
		
		submitStr+="&JCDP_SRV_NAME="+cruConfig.queryService+"&JCDP_OP_NAME="+cruConfig.queryOp+"&JCDP_COLUMN_EXP="+columnExp+"&JCDP_COLUMN_TITLE="+columnTitle+"&JCDP_FILE_NAME="+excel_name;
		
		path = cruConfig.contextPath+"/common/excel/listToExcel.srq";

	}
	else if(cruConfig.queryListAction != null){
		if(cruConfig.cdtStr!=''){

			submitStr += "&querySql="+cruConfig.cdtStr;
		}

		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);

		path = cruConfig.contextPath+cruConfig.queryListAction;

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

		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);

		submitStr+="&JCDP_SRV_NAME=RADCommCRUD&JCDP_OP_NAME=queryRecords&JCDP_COLUMN_EXP="+columnExp+"&JCDP_COLUMN_TITLE="+columnTitle+"&JCDP_FILE_NAME="+excel_name;
		path = cruConfig.contextPath+"/common/excel/listToExcel.srq";

	}
	
	var retObj = syncRequest("post", path, submitStr);
	excel_name = encodeURI(excel_name);
    excel_name = encodeURI(excel_name);

	window.location=cruConfig.contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname="+excel_name+".xls";
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

	var titleRow = tbObj.rows[0];

	//设置选中的行号为0 
	tbObj.selectedRow = 0;
	tbObj.selectedValue = '';
	
	//给每一类添加exp属性，在ie9+iframe的情况下，td标签内的exp属性识别不出
	for(var j=0;j<titleRow.cells.length;j++){
		var tCell = titleRow.cells[j];
		tCell.exp = tCell.getAttribute("exp");
		tCell.func = tCell.getAttribute("func");
		
		tCell.cellClass = tCell.getAttribute("cellClass");
		tCell.isShow = tCell.getAttribute("isShow");
		tCell.isExport = tCell.getAttribute("isExport");
		if(tCell.getAttribute("isShow")=="Hide"){
			tCell.style.display = 'none';
		}
	}// end
	
	var datas = tbCfg.items;
	if(datas==undefined) datas=[];
	if(datas!=null){
		for(var i=0;i<datas.length;i++){
			var data = datas[i];
			var vTr = tbObj.insertRow();
			vTr.orderNum = i+1;
			// 选中行高亮
			vTr.onclick = function(){
				//alert(tbObj.selectedRow);
				// 取消之前高亮的行
				if(tbObj.selectedRow>0){
					var oldTr = tbObj.rows[tbObj.selectedRow];
					var cells = oldTr.cells;
					for(var j=0;j<cells.length;j++){
						cells[j].style.background="#96baf6";
						// 设置列样式
						if(tbObj.selectedRow%2==0){
							if(j%2==1) cells[j].style.background = "#FFFFFF";
							else cells[j].style.background = "#f6f6f6";
						}else{
							if(j%2==1) cells[j].style.background = "#ebebeb";
							else cells[j].style.background = "#e3e3e3";
						}
					}
				}
				tbObj.selectedRow=this.orderNum;
				// 设置新行高亮
				var cells = this.cells;
				for(var i=0;i<cells.length;i++){
					cells[i].style.background="#ffc580";
				}
				tbObj.selectedValue = cells[0].childNodes[0].value;
				// 加载Tab数据
				loadDataDetail(cells[0].childNodes[0].value);
			}
			vTr.ondblclick = function(){
				var cells = this.cells;
				dbclickRow(cells[0].childNodes[0].value);
			}
			
			if(cruConfig.cruAction=='list2Link'){//列表页面选择坐父页面某元素的外键
				vTr.onclick = function(){
					eval(rowSelFuncName+"(this)");
				}
				vTr.onmouseover = function(){this.className = "trSel";}
				vTr.onmouseout = function(){this.className = this.initClassName;}
			}
	
			for(var j=0;j<titleRow.cells.length;j++){
				var tCell = titleRow.cells[j];
				var vCell = vTr.insertCell();
				// 设置列样式
				if(i%2==1){
					if(j%2==1) vCell.className = "even_even";
					else vCell.className = "even_odd";
				}else{
					if(j%2==1) vCell.className = "odd_even";
					else vCell.className = "odd_odd";
				}
				
				var outputValue = getOutputValue(tCell,data,false);
				var cellValue = outputValue;
				
				if(tCell.getAttribute("isShow")=="Edit"){
					cellValue = "<input type=text onclick=tableInputEditable(this) onkeydown=tableInputkeydown(this) class=rtTableInputReadOnly";
					if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName
					else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2);
					if(tCell.size!=undefined) cellValue += " size="+tCell.size;
					else cellValue += " size=8";
					cellValue += " value='"+outputValue+"'>";
				}
				else if(tCell.getAttribute("isShow")=="Hide"){
					cellValue = "<input type=text value="+outputValue;
					if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName+">"
					else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2)+">";
					vCell.style.display = 'none';
				}else if(tCell.isShow=="TextHide"){
					vCell.style.display = 'none';
				}
	//alert(typeof cellValue);alert(cellValue == undefined);
				if(cellValue == undefined || cellValue == 'undefined') cellValue = "";
				if(cellValue=='') {cellValue = "&nbsp;";}
				else if(cellValue.indexOf("undefined")!=-1){
				   cellValue = cellValue.replace("undefined","");
				}
	
				// 自动计算序号
				if(tCell.autoOrder=='1' || tCell.getAttribute('autoOrder')=='1'){
					if(cellValue==null || cellValue=="null") cellValue="";
					cellValue += ((tbCfg.currentPage-1) * tbCfg.pageSize + 1 + i);
				}
				
				vCell.innerHTML = cellValue;
				
				if(tCell.tips!=undefined && tCell.tips!=""){
					vCell.title = getOutputValue(tCell,data,true);
				}
			}
		}
		
		if(cruConfig.pageSize!=cruConfig.pageSizeMax){
			for(var i=datas.length;i<tbCfg.pageSize;i++){
				var vTr = tbObj.insertRow();
				for(var j=0;j<titleRow.cells.length;j++){
					var tCell = titleRow.cells[j];
					var vCell = vTr.insertCell();
					// 设置列样式
					if(i%2==1){
						if(j%2==1) vCell.className = "even_even";
						else vCell.className = "even_odd";
					}else{
						if(j%2==1) vCell.className = "odd_even";
						else vCell.className = "odd_odd";
					}
					vCell.innerHTML = "&nbsp;";
					// 设置是否显示
					if(tCell.getAttribute("isShow")=="Hide"){
						vCell.style.display='none';
					}
				}
			}
		}
	}
	createNewTitleTable();
	resizeNewTitleTable();
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

function getOutputValue(tCell,data,nosub){
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
			data_value = processData(funcArray,data_value,data_id.substr(1,data_id.length-2),nosub);
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
function processData(funcArray,data_value,fdName,nosub){
	var ret = data_value;
	if("substr"==funcArray[0]){
		if(nosub) return ret;
		ret = ret.substr(funcArray[1],funcArray[2]);
		if(ret.length < data_value.length) ret += " ...";
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
		tbCfg.currentPage = 1;
	}
	else{
		tbCfg.pageCount = Math.ceil(tbCfg.totalRows/tbCfg.pageSize);
		if(tbCfg.currentPage==0) tbCfg.currentPage = 1;
	}
	
	// 如果要查询的页数大于总页数，重新查询第一页
	if(tbCfg.pageCount>0 ){
		if(tbCfg.pageCount<tbCfg.currentPage){
			queryData(1);
		}
	}else{
		tbCfg.currentPage=1;
	}
	
	var navTableRow = getObj("fenye_box_table").rows[0];
	
	if(navTableRow==undefined) return;
	
	// 条数选择下拉框的html
	var pageSizeSelect = "<select onchange='resetPageSize(this.value)'><option value='10'>10</option><option value='30'>30</option><option value='50'>50</option><option value='100'>100</option><option value='200'>200</option><option value='300'>300</option></select>";
	// 在当前每页条数的option上添加selected，使用字符串替换的方式，比如把value='10'替换成 value='10' selected
	var searchValue = "value='"+cruConfig.pageSize+"'";
	var replaceValue = searchValue + ' selected';
	pageSizeSelect = pageSizeSelect.replace(searchValue, replaceValue);
	
	navTableRow.cells[0].innerHTML = "第"+tbCfg.currentPage+"/"+tbCfg.pageCount+"页，共"+tbCfg.totalRows+"条记录，每页条数"+pageSizeSelect;
	/*var navTableRow = getObj(tbCfg.navTable_id).rows(0);*/
	if(tbCfg.currentPage<=1){//当前是第一页
		navTableRow.cells[2].innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_01.png'  style='border:0'  alt='First' />";
		navTableRow.cells[3].innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_02.png'  style='border:0'  alt='Prev' />";
	}else{
		navTableRow.cells[2].innerHTML = "<a href='javascript:queryData(1)'><img src='"+cruConfig.contextPath+"/images/fenye_01.png'  style='border:0'  alt='First' /></a>";
		navTableRow.cells[3].innerHTML = "<a href='javascript:queryData("+(tbCfg.currentPage-1)+")'><img src='"+cruConfig.contextPath+"/images/fenye_02.png'  style='border:0'  alt='Prev' /></a>";
	}
	if(tbCfg.currentPage>=tbCfg.pageCount){//当前是最后一页
		navTableRow.cells[4].innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_03.png'  style='border:0'  alt='Next' />";
		navTableRow.cells[5].innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_04.png'  style='border:0'  alt='Last' />";
	}else{
		navTableRow.cells[4].innerHTML = "<a href='javascript:queryData("+(tbCfg.currentPage+1)+")'><img src='"+cruConfig.contextPath+"/images/fenye_03.png'  style='border:0'  alt='Next' /></a>";
		navTableRow.cells[5].innerHTML = "<a href='javascript:queryData("+(tbCfg.pageCount)+")'><img src='"+cruConfig.contextPath+"/images/fenye_04.png'  style='border:0'  alt='Last' /></a>";
	}
	navTableRow.cells[6].innerHTML = "到 <label> <input type='text' name='textfield' id='textfield' value='" + tbCfg.currentPage +"' maxValue='"+tbCfg.pageCount+"' style='width:20px;' onmouseover='selectPageNum()' onclick='selectPageNum()'/> </label>";
	navTableRow.cells[7].innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_03.png' style='cursor: hand;border:0' onclick='gotopage()'/> ";
}
function resetPageSize(pageSize){
	cruConfig.pageSize = pageSize;
	queryData(cruConfig.currentPage);
}
function selectPageNum(){
	var field = getObj('textfield');
	field.focus();
	field.select();
}
function gotopage(){
	var field = getObj('textfield')
	var pageNum = field.value;
	var maxPageNum = field.maxValue;
	if(pageNum=='') return;
	var type = "^[0-9]*[1-9][0-9]*$"; 
    var re = new RegExp(type); 

	if(pageNum.match(re)==null){
		alert("页数只能输入大于0的数字！");
		getObj('textfield').value = '';
		return;
	}
	if(Number(pageNum)>Number(maxPageNum)){
		alert("页数不能大于总页数！");
		getObj('textfield').value = '';
		return;
	}
	
	queryData(pageNum);
}
function getTab3(index) {  
	var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
	var selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
	selectedTag.className ="";
	selectedTabBox.style.display="none";

	selectedTagIndex = index;
	
	selectedTag = document.getElementById("tag3_"+selectedTagIndex);
	selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
	selectedTag.className ="selectTag";
	selectedTabBox.style.display="block";
}

//弹出窗口
function popWindow(url,size,title,param){
	var height = 530;
	var width = 800;
	if(size != null){
		if(typeof size=='number'){
			height=size;
		}
		if(typeof size=='string'&&size.indexOf(':')>0){
			height = eval(size.split(':')[1]);
			width = eval(size.split(':')[0]);
	  }
	}
	if(typeof param == "undefined"){
		param = {};
	}
	if(title==undefined){
		return window.top.$.JDialog.open(url,{
	        height:height,
	        width:width,
	        param:param
	     } ); 
	}else{
		return window.top.$.JDialog.open(url,{
	        title:$(document).attr("title") + title,
	        height:height,
	        width:width,
	        param:param
	     } ); 
	}
}

//关闭弹出层
function newClose(){
	top.closeDialog(window);
}

function popWindowAuto(url,size,title){
	/*var path = cruConfig.currentPageUrl;
	if(path.indexOf("/epcomp") == 0){   //如果是组件包里的pmd文件
		path = path.substr("/epcomp".length);
	}	
	if(url.indexOf('/') == 0){
		if(url.indexOf(cruConfig.contextPath) != 0){
			url = cruConfig.contextPath + url; 
		}
	}
	else {
			path = path.substr(0,path.lastIndexOf("/")+1);
			if(path.lastIndexOf("/") == (path.length - 1)){
					url = cruConfig.contextPath + path + url;
			}
			else url = cruConfig.contextPath + path + '/' + url;
	}*/
	var height = 680;
	var width = 740;
	if(size != null){
		if(typeof size=='number'){
			height=size;
			}
		if(typeof size=='string'&&size.indexOf(':')>0){
			height = eval(size.split(':')[1]);
		  width = eval(size.split(':')[0]);
	  }
	}
	
	if(title==undefined) title="";
	
	dialogOpen(title,width,height,url,"0");
}

function refreshData(){
	var ctt = top.frames['list'];
	if(ctt!=null&&ctt!=undefined){
		if(ctt.frames.length == 0){
			ctt.refreshData();
		}else{
			if(ctt.frames[0].name == 'mainTopframe'||ctt.frames[0].name == 'menuTopframe'){
				ctt.frames[1].refreshData();
			}else if(ctt.frames[0].name == 'mainleftframe'){
				ctt.frames[1].location.reload();
			}else{
				ctt.refreshData();
			}
		}
	}
	
}

function refreshDataNumberFormat(){
	var ctt = top.frames['list'];
	if(ctt.frames.length == 0){
		ctt.location.reload();
	}else{
		ctt.frames[0].location.reload();
	}

}

function refreshDataAttachment(){
	var ctt = top.frames['list'];
	if(ctt.frames.length == 0){
		ctt.refreshData();
	}else{
		if(ctt.frames[1].frames.length == 0){
			ctt.frames["attachement"].location.reload();
		}else{
			ctt.frames[1].frames["attachement"].location.reload();
		}
	}
}

function getYearValue(){
	var nowYearValue = nowDate.getFullYear();
	return nowYearValue;
}

function getMonthValue(){
	var nowMonthValue = nowDate.getMonth()+1;
	if(nowMonthValue < 10){
		nowMonthValue = "0"+nowMonthValue
	}
	return nowMonthValue;
}

function getDateValue(){
	var nowDateValue = nowDate.getDate();
	return nowDateValue;
}

function getTimeValue(){
	var nowTimeValue = nowDate.getTime();
	return nowTimeValue;
}

function getFileInfo(){
	var docPath = document.getElementById("doc_content").value;
	var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
	var docTitle = docName.substring(0,docName.lastIndexOf("\."));
	document.getElementById("doc_name").value = docTitle;
	var docExt = docName.substring(docName.lastIndexOf("\.")+1);
	if(docExt!=""&&docExt!=undefined){
		if(docExt =="doc" || docExt == "docx"){
			document.getElementById("doc_type").value = "word";
		}else if(docExt =="xls" || docExt == "xlsx"){
			document.getElementById("doc_type").value = "excel";
		}else if(docExt =="ppt" || docExt == "pptx"){
			document.getElementById("doc_type").value = "ppt";
		}else if(docExt =="pdf"){
			document.getElementById("doc_type").value = "pdf";
		}else if(docExt =="txt"){
			document.getElementById("doc_type").value = "txt";
		}else if(docExt =="jpg" || docExt == "jpeg"|| docExt == "bmp"|| docExt == "png"|| docExt == "gif"){
			document.getElementById("doc_type").value = "picture";
		}else if(docExt =="rar" || docExt == "zip"||docExt == "7z"){
			document.getElementById("doc_type").value = "compress";
		}else{
			document.getElementById("doc_type").value = "other";
		}
	}
	
}

/*
 * 获取文档信息
 */
function getFileInfoNew(fileName){
	var docTitle = fileName.substring(0,fileName.lastIndexOf("\."));
	document.getElementById("doc_name").value = fileName;
	document.getElementById("upload_file_name").value = fileName;
	if(fileName!=""&&fileName!=undefined){
		if(fileName.indexOf("doc") != -1){
			document.getElementById("doc_type").value = "word";
		}else if(fileName.indexOf("xls") != -1){
			document.getElementById("doc_type").value = "excel";
		}else if(fileName.indexOf("ppt") != -1){
			document.getElementById("doc_type").value = "ppt";
		}else if(fileName.indexOf("pdf") != -1){
			document.getElementById("doc_type").value = "pdf";
		}else if(fileName.indexOf("txt") != -1){
			document.getElementById("doc_type").value = "txt";
		}else if(fileName.indexOf("jpg") != -1 || fileName.indexOf("jpeg") != -1 || fileName.indexOf("bmp") != -1 || fileName.indexOf("png") != -1 || fileName.indexOf("gif") != -1){
			document.getElementById("doc_type").value = "picture";
		}else if(fileName.indexOf("rar") != -1 || fileName.indexOf("zip") != -1 || fileName.indexOf("7z") != -1){
			document.getElementById("doc_type").value = "compress";
		}else{
			document.getElementById("doc_type").value = "other";
		}
	}
	
}

/*
 * 验证上传文档是否空
 */
function checkUploadFile(){
	var status_message = $('#status-message').html();
	
	if(status_message == "success"){
		var file_name = $(".fileName").html();
		if(file_name == null || file_name == undefined){
			alert("请选择文件");
			return false;
		}else{
			return true;
		}
	}else{
		alert("文件没有上传成功!");
		return false;
	}
}


var lashened = 0;
function lashen() {
	var oLine = $("#line")[0];
	if(oLine==null) return;
	oLine.onmousedown = function(e) {
		var disY = (e || event).clientY;
		oLine.top = oLine.offsetTop;
		document.onmousemove = function(e) {
			var iT = oLine.top + ((e || event).clientY - disY)-70;
			$("#table_box").css("height",iT);
			lashened = 1;
			$('newTitleTable').css("width", $('queryRetTable').width());
			//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-27);
			setTabBoxHeight();
		};
		document.onmouseup = function() {
			document.onmousemove = null;
			document.onmouseup = null;
			oLine.releaseCapture && oLine.releaseCapture()
		};
		oLine.setCapture && oLine.setCapture();
		return false;
	}
}


function setTabBoxHeight(){
	if(lashened==0){
		$("#table_box").css("height",$(window).height()*0.46);
	}
	$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-10);
	$("#tab_box .tab_box_content").each(function(){
		if($(this).children('iframe').length > 0){
			$(this).css('overflow-y','hidden');
		}
	});
}

function loadDataDetail(){}

function dbclickRow(){}

// 获得高亮行的checkbox value
function getSelectedValue(){
	return getObj('queryRetTable').selectedValue;
}

function createNewTitleTable(){
	if(window.gudingbiaotou=='true')
		{
		
		}
	else
		{
	
	// 如果不是直接的列表页面，不支持 固定表头
	if(self.frameElement!=null && self.frameElement.name!="list" && self.frameElement.name!="mainFrame" && self.frameElement.name!="menuFrame"){
		return;
	}

	// 如果是dialog
	if(window.dialogArguments){
		return;
	}
	
	// 如果声明了不出现固定表头
	if(window.showNewTitle==false){
		return;
	}
		}
	var newTitleTable = document.getElementById("newTitleTable");
	if(newTitleTable!=null) return;
	var queryRetTable = document.getElementById("queryRetTable");
	if(queryRetTable==null) return;
	var titleRow = queryRetTable.rows[0];
	
	var newTitleTable = document.createElement("table");
	newTitleTable.id = "newTitleTable";
	newTitleTable.className="tab_info";
	newTitleTable.border="0";
	newTitleTable.cellSpacing="0";
	newTitleTable.cellPadding="0";
	newTitleTable.style.width = queryRetTable.clientWidth+"px";
	newTitleTable.style.position="absolute";
	var x = getAbsLeft(queryRetTable);
	newTitleTable.style.left=x+"px";
	//var y = getAbsTop(queryRetTable)-4;
	var y = getAbsTop(queryRetTable);
	newTitleTable.style.top=y+"px";
	
	
	var tbody = document.createElement("tbody");
	var tr = titleRow.cloneNode(true);
	
	tbody.appendChild(tr);
	newTitleTable.appendChild(tbody);
	document.body.appendChild(newTitleTable);
	// 设置每一列的宽度
	for(var i=0;i<tr.cells.length;i++){
		tr.cells[i].style.width=titleRow.cells[i].clientWidth+"px";
		if(i%2==0){
			tr.cells[i].className="bt_info_odd";
		}else{
			tr.cells[i].className="bt_info_even";
		}
		// 设置是否显示getAttribute
		if(titleRow.cells[i].getAttribute("isShow")=="Hide"){
			tr.cells[i].style.display='none';
		}
	}
	
	document.getElementById("table_box").onscroll = resetNewTitleTablePos;
	
}
function resizeNewTitleTable(){
	var queryRetTable = document.getElementById("queryRetTable");
	var newTitleTable = document.getElementById("newTitleTable");
	if(queryRetTable==null || newTitleTable==null) return;
	newTitleTable.style.width = queryRetTable.clientWidth+"px";

	var titleRow = queryRetTable.rows[0];
	var newTitleRow = newTitleTable.rows[0];
	for(var i=0;i<newTitleRow.cells.length;i++){
		newTitleRow.cells[i].style.width=titleRow.cells[i].clientWidth+"px";
	}
}
function resetNewTitleTablePos(){
	var queryRetTable = document.getElementById("queryRetTable");
	var newTitleTable = document.getElementById("newTitleTable");
	if(queryRetTable==null || newTitleTable==null) return;
	var x = getAbsLeft(queryRetTable);
	newTitleTable.style.left=x+"px";
	//newTitleTable.style.zIndex=-100;
	//document.getElementById("table_box").style.zIndex = 200;
	//newTitleTable.style.zIndex=1;
	//queryRetTable.style.zIndex=0;
}
function getAbsTop(obj)   
{   
   var y;   
   oRect = obj.getBoundingClientRect();
   y=oRect.top;
   return document.documentElement.scrollTop + y;  
}
function getAbsLeft(obj)   
{   
   var y;   
   oRect = obj.getBoundingClientRect();
   y=oRect.left;
   return document.documentElement.scrollLeft + y;  
}
// 页面加载时创建新的标题表格
$(document).ready(
	createNewTitleTable
);

// 页面大小改变时，改变标题表格的宽度
$(window).resize(
	resizeNewTitleTable
);

/* jquery.loadmask*/
(function(a){a.fn.mask=function(c,b){a(this).each(function(){if(b!==undefined&&b>0){var d=a(this);d.data("_mask_timeout",setTimeout(function(){a.maskElement(d,c)},b))}else{a.maskElement(a(this),c)}})};a.fn.unmask=function(){a(this).each(function(){a.unmaskElement(a(this))})};a.fn.isMasked=function(){return this.hasClass("masked")};a.maskElement=function(d,c){if(d.data("_mask_timeout")!==undefined){clearTimeout(d.data("_mask_timeout"));d.removeData("_mask_timeout")}if(d.isMasked()){a.unmaskElement(d)}if(d.css("position")=="static"){d.addClass("masked-relative")}d.addClass("masked");var e=a('<div class="loadmask"></div>');if(navigator.userAgent.toLowerCase().indexOf("msie")>-1){e.height(d.height()+parseInt(d.css("padding-top"))+parseInt(d.css("padding-bottom")));e.width(d.width()+parseInt(d.css("padding-left"))+parseInt(d.css("padding-right")))}if(navigator.userAgent.toLowerCase().indexOf("msie 6")>-1){d.find("select").addClass("masked-hidden")}d.append(e);if(c!==undefined){var b=a('<div class="loadmask-msg" style="display:none;"></div>');b.append("<div>"+c+"</div>");d.append(b);b.css("top",Math.round(d.height()/2-(b.height()-parseInt(b.css("padding-top"))-parseInt(b.css("padding-bottom")))/2)+"px");b.css("left",Math.round(d.width()/2-(b.width()-parseInt(b.css("padding-left"))-parseInt(b.css("padding-right")))/2)+"px");b.show()}};a.unmaskElement=function(b){if(b.data("_mask_timeout")!==undefined){clearTimeout(b.data("_mask_timeout"));b.removeData("_mask_timeout")}b.find(".loadmask-msg,.loadmask").remove();b.removeClass("masked");b.removeClass("masked-relative");b.find("select").removeClass("masked-hidden")}})(jQuery);