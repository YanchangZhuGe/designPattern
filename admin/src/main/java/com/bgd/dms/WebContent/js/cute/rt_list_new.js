var kdy_list_cfg={
		nav_first_id:'nav_first',
		nav_prev_id:'nav_prev',
		nav_next_id:'nav_next',
		nav_last_id:'nav_last',
		pageNumDiv : 'pageNumDiv'
	}


/*
*转到第几页
*/
function changePage(){
	var page = getObj(cruConfig.changePage_id).value;
	if(window.event.keyCode==13){   //如果用户敲了回车
		if(/^[-]?\d+$/.test(page)){
			if(page<1 || page>cruConfig.pageCount){
				alert("请重新输入合法的页数!");
				getObj(cruConfig.changePage_id).focus();
				return;
			}
			queryData(page);
		}
		else{
			alert('请输入正整数');
		}
	}
}

/**
  选择一行记录，将主键和名称写入parent window
*/
function onRowSelect(trObj){
	//delete(Object.prototype.toJSONString);
	var obj = window.dialogArguments;
	obj.fkValue = trObj.cells[0].innerHTML;
	obj.value = trObj.cells[1].innerText;
	window.close();
	
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
	var hintSpan = getObj(tbCfg.dataRowHint_id);
	hintSpan.innerHTML = "第<input type='text' id='changePage' value='"+tbCfg.currentPage+"' size='2' onkeydown='javascript:changePage()'/>页，共"+tbCfg.pageCount+"页，"+tbCfg.totalRows+"条记录";
	var pageNumObj = getObj(kdy_list_cfg.pageNumDiv);
	if(tbCfg.currentPage<=1){//当前是第一页
		pageNumObj.childNodes[0].className = "first_disabled fl";
		pageNumObj.childNodes[0].href = "#";
		pageNumObj.childNodes[1].className = "prev_disabled fl";
		pageNumObj.childNodes[1].href = "#";
		pageNumObj.childNodes[0].onmouseover = function(){};
		pageNumObj.childNodes[1].onmouseover = function(){};
		
	}else{
		pageNumObj.childNodes[0].className = "first fl";
		pageNumObj.childNodes[0].href = 'javascript:queryData(1)';
		pageNumObj.childNodes[1].className = "prev fl";
		pageNumObj.childNodes[1].href = 'javascript:queryData('+(tbCfg.currentPage-1)+')';
		
		pageNumObj.childNodes[0].onmouseover = function(){};
		pageNumObj.childNodes[1].onmouseover = function(){};
	}
	if(tbCfg.currentPage>=tbCfg.pageCount){//当前是最后一页
		pageNumObj.childNodes[3].className = "next_disabled fl";
		pageNumObj.childNodes[3].href = "#";
		pageNumObj.childNodes[4].className = "last_disabled fl";
		pageNumObj.childNodes[4].href = "#";
		pageNumObj.childNodes[3].onmouseover = function(){};
		pageNumObj.childNodes[4].onmouseover = function(){};
		
	}else{
		pageNumObj.childNodes[3].className = "next fl";
		pageNumObj.childNodes[3].href = 'javascript:queryData('+(tbCfg.currentPage+1)+')';
		pageNumObj.childNodes[4].className = "last fl";
		pageNumObj.childNodes[4].href = 'javascript:queryData('+tbCfg.pageCount+')';
		pageNumObj.childNodes[3].onmouseover = function(){};
		pageNumObj.childNodes[4].onmouseover = function(){};
	}	
}

/*
*查询结果的显示
*/
function renderTable(tbObj,tbCfg){
	$("#queryRetTable tr:not(:first)").remove();  
	//更新导航栏
	renderNaviTable(tbObj,tbCfg);
	
	//删除上次的查询结果
	var headChxBox = getObj("headChxBox");
	if(headChxBox!=undefined) headChxBox.checked = false;
	
	for(var i=tbObj.rows.length-1;i>0;i--)
		tbObj.deleteRow(i);
			
	var titleRow = tbObj.rows[0];
	//给每一类添加exp属性，在ie9的情况下，td标签内的exp属性识别不出
	for(var j=0;j<titleRow.cells.length;j++){
		var tCell = titleRow.cells[j];
		tCell.exp = tCell.getAttribute("exp");
		tCell.func = tCell.getAttribute("func");
		tCell.cellClass = tCell.getAttribute("cellClass");
	}// end
	var datas = tbCfg.items;  //需要显示在页面上的数据
	if(datas!=null)
	for(var i=0;i<10;i++){
		var vTr = tbObj.insertRow();	
		if(i>=datas.length){
			for(var j=0;j<titleRow.cells.length;j++){
				//填写空白，补全10条
				var vCell = vTr.insertCell();
				vCell.innerHTML = '&nbsp;';
				if(titleRow.cells[j].getAttribute("isShow")=="Hide" || titleRow.cells[j].getAttribute("isshow")=="TextHide"){
					vCell.style.display = 'none';
				}
			}
			continue;
		}
		var data = datas[i];
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
			var outputValue = getOutputValue(tCell,data);
			var cellValue = outputValue;
			if(tCell.getAttribute("isshow")=="Edit"){
				cellValue = "<input type=text onclick=tableInputEditable(this) onkeydown=tableInputkeydown(this) class=rtTableInputReadOnly";
				if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName
				else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2);
				if(tCell.size!=undefined) cellValue += " size="+tCell.size;
				else cellValue += " size=8";
				cellValue += " value='"+outputValue+"'>";	
			//	alert(cellValue);
					
			}
			else if(tCell.getAttribute("isshow")=="Hide"){
				cellValue = "<input type=text value="+outputValue;		
				if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName+">"
				else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2)+">";				
				vCell.style.display = 'none';
			}else if(tCell.getAttribute("isshow")=="TextHide"){
				vCell.style.display = 'none';
			}
			
			if(typeof cellValue == undefined || cellValue == 'undefined') cellValue = "";
			if(cellValue==null || cellValue=='') {cellValue = "&nbsp;";}
			else if(cellValue.indexOf("undefined")!=-1){
			   cellValue = cellValue.replace("undefined","");
			}
			vCell.style.textAlign="center";
			vCell.innerHTML = cellValue;
			//alert(cellValue);
		}			
	}
	//delete(Object.prototype.toJSONString);
	ctt_autoHeight();
}
/**获取每个单元格的innerHTML
*/
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

function addSearchRow(){
	if($("#ComplexTable tr").length >= 10){
		alert('对不起，查询条件最多不能超过10个');
	}else{
	//	$("#ComplexTable tbody").html($("#ComplexTable tbody").html()+$("#ComplexTable tbody tr:last").html());
		var tbObj = getObj("ComplexTable");
		var vTr = tbObj.insertRow();
		var vCell = vTr.insertCell();
		vCell.innerHTML = "<select onChange=\"updateCmpOption(this)\" name='cmp_field' class=\"cuteSel\"/>";
		vCell = vTr.insertCell();
		vCell.innerHTML = "<select name='cmp_cdt' class=\"cuteSel\"/>";
		vCell = vTr.insertCell();
		vCell.innerHTML = "<input name='cmp_input' class='cuteTxt'><select name='cmp_sel' class=\"cuteSel\"/> ";
		var cmp_fields = document.getElementsByName("cmp_field");
		var cmp_cdts = document.getElementsByName("cmp_cdt");
		var cmp_inputs = document.getElementsByName("cmp_input");	
		var cmp_sels = document.getElementsByName("cmp_sel");
		i = cmp_fields.length-1;
		init_query_row(cmp_fields[i],cmp_cdts[i],cmp_sels[i],cmp_inputs[i]);	
		ctt_autoHeight();
	}
}

function deleteSearchRow(){
	if($("#ComplexTable tbody tr").length <= 1){
		alert('请至少保留1个查询条件！');
	}else{
		var tbObj = getObj("ComplexTable");	
		if(tbObj.rows.length==1){
			return;
		}
		tbObj.deleteRow(tbObj.rows.length-1);
		ctt_autoHeight();
	}
	
}

function cdt_init(){
	initSelCodes();
	
	if(cruConfig.cdtType=='form'){
		initFormCdt();
		return;
	}

	//快捷搜索
//	init_query_row(getObj('bas_field'),getObj('bas_cdt'),getObj('bas_sel'),getObj('bas_input'));
	
	//组合搜索
	var cmp_fields = document.getElementsByName("cmp_field");
	var cmp_cdts = document.getElementsByName("cmp_cdt");
	var cmp_inputs = document.getElementsByName("cmp_input");	
	var cmp_sels = document.getElementsByName("cmp_sel");
	for(var i=0;i<cmp_fields.length;i++){
		init_query_row(cmp_fields[i],cmp_cdts[i],cmp_sels[i],cmp_inputs[i]);
	}
}

//弹出层
function popWindow(url,size){
	if(top.GB_CURRENT != null)
		return;
	var path = cruConfig.currentPageUrl;
	if(url.indexOf('/') == 0){
		if(url.indexOf(cruConfig.contextPath) != 0){
			url = cruConfig.contextPath + url; 
		}
	}
	else {
			path = path.substr(0,path.lastIndexOf("/")+1);
			url = cruConfig.contextPath + path + '/' + url;
	}
//	alert('url = ' + url);
	var height = 520;
	var width = 640;
	if(size != null){
		height = eval(size.split(':')[1]);
		width = eval(size.split(':')[0]);
	}
	top.GB_show("",url,height,width);
}

function forbidEnter(){
	if (event.keyCode == 8)    {  //屏蔽回退键
		if(top.GB_CURRENT != null){
			
			top.GB_hide();
			event.keyCode=0;
        	return false;
		}
    }
    return true;
}

function renderTable2(){
	$(".listTable table tr:odd").css("background","#e2e7f0");
	$(".listTable table tr:even").css("background","#cbd4e4");
	$(".listTable table tr:eq(0)").css("background","#bcd1e5");

	$(".listTable table tr").mouseover(function(){
		$(".listTable table tr:odd").hover(function(){
			$(this).css("background","#f4f7fb");
		},function(){
			$(this).css("background","#e2e7f0");
		})
		$(".listTable table tr:even:gt(0)").hover(function(){
			$(this).css("background","#f4f7fb");
		},function(){
			$(this).css("background","#cbd4e4");
		})
	})
	
}

function ctt_autoHeight(){
	//delete(Object.prototype.toJSONString);
	var cttHeight = $(window).height()-$(".searchBar").height()-24;
	$(".dataList .ctt").css("height",cttHeight);
	var tableWrapHeight = cttHeight-$(".ctrlBtn").height()-$(".pageNumber").height()-10;
	$(".tableWrap").css("height",tableWrapHeight);
};


$(function(){
	$(window).resize(function (){
  		ctt_autoHeight();
	});
})


