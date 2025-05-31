//字段类型 决定条件符号
var typeofdata = new Array();
typeofdata['TEXT']  = ['cts','is','isn','bwt','ewt'];	//文本
typeofdata['N']  = ['is','isn','lst','grt','lsteq','grteq']; //整数
typeofdata['NN']  = ['is','isn','lst','grt','lsteq','grteq']; //数字
typeofdata['D']  = ['is','lst','grt','lsteq','grteq']; //日期
typeofdata['EMAIL']  = ['is'];	//EMAIL
typeofdata['ET']  = ['cts','is','isn','bwt','ewt'];	//英文


typeofdata['SEL_OPs']  = ['is']; //Select，值来自定义的Options
typeofdata['SEL_Codes']  = ['is']; //Select，值来自编码表
typeofdata['FK']  = ['is'];  //FK 外键，值来自其他表的主键
typeofdata['SQL_OPs']  = ['is','isn','lst','grt','lsteq','grteq']; //Select，值来自定义的Options
//可用的条件符号
var fLabels = new Array();
var fMqSymbols = new Array();
fMqSymbols['is'] = '=';        
fMqSymbols['isn'] = '<>';
fMqSymbols['bwt'] = 'like ';	
	
fMqSymbols['lst'] = '<';
fMqSymbols['grt'] = '>';
fMqSymbols['lsteq'] = '<=';	
fMqSymbols['grteq'] = '>=';

function cdt_init(){
	initSelCodes();
	
	if(cruConfig.cdtType=='form'){
		initFormCdt();
		return;
	}
	//快捷搜索
	init_query_row(getObj('bas_field'),getObj('bas_cdt'),getObj('bas_sel'),getObj('bas_input'));
	//组合搜索
	var cmp_fields = document.getElementsByName("cmp_field");
	var cmp_cdts = document.getElementsByName("cmp_cdt");
	var cmp_inputs = document.getElementsByName("cmp_input");	
	var cmp_sels = document.getElementsByName("cmp_sel");
	for(var i=0;i<cmp_fields.length;i++){
		init_query_row(cmp_fields[i],cmp_cdts[i],cmp_sels[i],cmp_inputs[i]);
	}
}

function initFormCdt(){
	var cruTable = getObj("queryCdtTable");
	var fieldConfig = {
		nextPos:0,
		origRowLn:0
	}
		
	var field = getCdtField(fieldConfig);
	while(field!=null){
		var vTr = cruTable.insertRow(fieldConfig.origRowLn++);	

		generateCdtFieldInput(vTr,field,fieldConfig);
		field = getCdtField(fieldConfig);
		generateCdtFieldInput(vTr,field,fieldConfig);
		field = getCdtField(fieldConfig);
	}
}

function getCdtField(cfg){
	if(cfg.nextPos>=fields.length) return null;
	else return fields[cfg.nextPos++];
}

/**
  生成一个输入框和名字
*/
function generateCdtFieldInput(vTr,field,cfg){
		var vCell1 = vTr.insertCell();
		var vCell2 = vTr.insertCell();
		vCell1.className = 'rtCDTFdName';
		vCell2.className = 'rtCDTFdValue';
	
		if(field==null){
			vCell1.innerHTML = "&nbsp;";
			vCell1.colSpan = '2';
			//vCell2.innerHTML = "&nbsp;";
	  }
		else{
			vCell1.innerHTML = field[1];
			if(field[5]=="SEL_OPs" || field[5]=="SEL_Codes"){
				var sel = document.createElement("SELECT");
				sel.name = field[0];
				sel.className = "select_width";
				fillCdtSelectOptions(sel,field);
			  //影响其他下拉框
		  	for(var i=0;i<jcdp_codes.length;i++)
		  		if(jcdp_codes[i].length==4 && jcdp_codes[i][3]==field[0]){
		  			sel.onchange = function(){toChangeDependCdtSelect(this);}
		  		}				
				vCell2.appendChild(sel);
			}else if(field[2]=="D"){
				var inputHtml = "<input type='text' name='"+field[0]+"' dataFld='"+(cfg.nextPos-1)+"' class='input_width'>";			 
				inputHtml += " <img src=\""+cruConfig.contextPath+"/images/calendar.gif\" id=\"cal_button"+(cfg.nextPos-1)+"\"";
				inputHtml += " width=\"16\" height=\"16\"  style=\"cursor:hand;\"";
				inputHtml += " onmouseover=\"calDateSelector("+field[0]+",cal_button"+(cfg.nextPos-1)+");\"/>";						   
			  vCell2.innerHTML = inputHtml;	
			}			
			else{
				var inputHtml = "<input type='text' name='"+field[0]+"' dataFld='"+(cfg.nextPos-1)+"' class='input_width'>";			    
			  vCell2.innerHTML = inputHtml;	
			}	
		}	
}

/**
  Select的值改变时，同时改变关联的Select
*/
function toChangeDependCdtSelect(selObj){
	if(cruConfig.loadFinished=='false') return;
	
	fieldName = selObj.name;
	fieldValue = selObj.options[selObj.selectedIndex].value;
	
	var json_codes = new Array();
	for(i=0;i<jcdp_codes.length;i++)
		if(jcdp_codes[i].length==4 && jcdp_codes[i][3]==fieldName){
			//重新从数据库中读取编码
			var dependCode1 = new Array();
			dependCode1[0] = jcdp_codes[i][0];
			dependCode1[1] = jcdp_codes[i][1];
			dependCode1[2] = jcdp_codes[i][2].replace("{fdValue}",fieldValue);
			json_codes[0] = dependCode1;
			submitStr = "arrayParam="+json_codes.toJSONString();
		  var path = cruConfig.contextPath+"/tcg/ajaxQueryCodesByArrayParam.srq";
			codes_items = syncRequest('Post',path,submitStr);
			jcdp_codes_items[dependCode1[0]] = codes_items[dependCode1[0]];
			
			//更新下拉框
			for(var j=0;j<fields.length;j++){
				var field = fields[j];
				if(field.length>=4 && field[5]=='SEL_Codes' && field[6]==dependCode1[0]){
					var dependSel = getElementByTypeAndName("SELECT",field[0]);
					fillCdtSelectOptions(dependSel,field);
				}
			}
		}	
}

/**
  用field指定的下拉列表或编码，构造Select的Options
*/
function fillCdtSelectOptions(sel,field){
	//清空Select原有的Options
	if(sel.options!=undefined)
		for(var i=sel.options.length-1;i>=0;i--) sel.options.remove(i);

	if(field[5]=="SEL_OPs") opList = field[6];
	else opList = getOpList(jcdp_codes_items[field[6]])
	
	if(opList==undefined || opList.length==0) return;	
	inputValue = getInputValue(field);
	for(var i=0;i<opList.length;i++){
  	sel.options[i] = document.createElement("OPTION"); 
  	sel.options[i].value = opList[i][0];
  	if(inputValue==opList[i][0]){
  		sel.selectedIndex = i;
  	}
  	sel.options[i].innerHTML = opList[i][1];
  }	
}

/*
 * function :  	一组查询条件初始化,即一行
 * @param	: 	fldNameSelect  : 查询字段名的select对象	
  *				fdValueInput   : input对象
 *		   		cdtSelect      : 查询操作符的select对象	
 */
function init_query_row(fldNameSelect, cdtSelect,fdValueSel,fdValueInput){
	//初始化最左边一列的条件
	for(var i=0;i<fields.length;i++){
		var option = new Option(fields[i][1],fields[i][0]);
		fldNameSelect.options[i] = option;
	}
	
  changeCondition(cdtSelect,fdValueSel,fdValueInput,0);
}

/*
 * function :  	用户选中fields的第j个字段，根据该字段类型构造条件select的option值 
 *  						for init_query_row() and updateFieldOption()
 * @param	: 	  basCondObj:   条件select对象	
 *							fdValueSel:   select值对象 
 *							fdValueInput: input值对象
 *		   				j           : 选中fields的字段序号	
 */
function changeCondition(cdtSelect,fdValueSel,fdValueInput,j){
	//如果与上次相同，返回	
	if(cdtSelect.dataFld!='' && cdtSelect.dataFld==j){
		 return;  
	}
	if(fields[j][5]=='SEL_OPs'||fields[j][5]=='SEL_Codes'){  
		fdValueInput.style.display = 'none';
		fdValueSel.style.display = 'block';
		for(var i = fdValueSel.options.length;i>=0;i--)
			fdValueSel.remove(i);
	 
	    var selOps =  fields[j][6];//fields[j][5]=='SEL_OPs'
		if(fields[j][5]=='SEL_Codes')
			selOps = getOpList(jcdp_codes_items[fields[j][6]]);
		//检查是否需要生成空选项
		var withNull = false;  //默认不显示空选项
		for(var i=0;i<jcdp_codes.length;i++){
			if(jcdp_codes[i][0] == fields[j][6]){
				if(jcdp_codes[i].length == 5 && jcdp_codes[i][4] == 'withNull'){
					withNull = true;
					break;
				}
			}
		}
		for (var i = 0; i < selOps.length; i++){
			if(withNull && i==0){
				var option = new Option (" ","");
			}
			else var option = new Option (selOps[i][1],selOps[i][0]);
			fdValueSel.options[i] = option;
		}
		fdValueSel.onchange = "";
		//新增影响其他select的event函数
	  	for(var i=0;i<jcdp_codes.length;i++)
	  		if(jcdp_codes[i].length==4 && jcdp_codes[i][3]==fields[j][0]){//alert(fields[j][0]);
	  			fdValueSel.onchange = function(){changeDependSelValue(fields[j][0],this);}
	  		}		
	}else if(fields[j][5]=='SQL_OPs'){
		//else if(fields[j][2]=='SQL_OPs'){
		var sqlstr=fields[j][6];
		fdValueInput.style.display = 'none';
		fdValueSel.style.display = 'block';
		for(var i = fdValueSel.options.length;i>=0;i--)
			fdValueSel.remove(i);
			
	    var returnObj = jcdpQueryRecords(sqlstr);
	//  alert(returnObj.datas[0].label);
	//  alert(returnObj.datas[0].value);
   //   alert(returnObj.datas.length)
			
		for (var i = 0; i < returnObj.datas.length; i++){
			var option = new Option (returnObj.datas[i].label,returnObj.datas[i].value);
			fdValueSel.options[i] = option;
		}
		
	
		fdValueSel.onchange = "";
		//新增影响其他select的event函数
  		for(var i=0;i<jcdp_codes.length;i++)
	  		if(jcdp_codes[i].length==4 && jcdp_codes[i][3]==fields[j][0]){
	  			//alert(fields[j][0]);
	  			fdValueSel.onchange = function(){changeDependSelValue(fields[j][0],this);
	  		}
  		}	
// return;
	}else if (fields[j][5]=='FK'){  //外键类型的查询条件
		fdValueInput.style.display = 'block';
		fdValueInput.fkValue='';
		fdValueInput.Value='';
		fdValueInput.readOnly = true;
		fdValueInput.attachEvent('onkeydown',function(){if(event.keyCode==8){return false;}});
		fdValueSel.style.display = 'none';
		var fdSelValue = fields[j][6];
		var buttonEm = document.createElement('input');
		buttonEm.type = 'button';
		buttonEm.value='...';
		buttonEm.attachEvent('onclick',function(){popFKWindow(fdSelValue,fdValueInput.name)});
		
		fdValueInput.parentNode.appendChild(buttonEm);
	}
	else {  //其他普通的text输入框
		fdValueInput.style.display = 'block';
		fdValueSel.style.display = 'none';
			
		var maxLength = fields[j][3];
		if(maxLength==undefined) maxLength = 20;		
		fdValueInput.maxLength = maxLength;
		var sch_value = fdValueInput.value;
		if(sch_value.length>maxLength) fdValueInput.value = sch_value.substring(0,maxLength);
		
		fdValueInput.fkValue='';
		fdValueInput.value = '';
		var lastChild = fdValueInput.parentNode.lastChild;
		if(lastChild.type == 'button'){   //若已经存在一个外键按钮，则需要去掉它
			fdValueInput.parentNode.removeChild(lastChild);
		}
	}

	//删除 条件select的options
	for(var i = cdtSelect.options.length;i>=0;i--)
		cdtSelect.remove(i);	
	
	//构造 条件select的options
	var fieldtype = fields[j][2];
	if(fields[j][5]=='SEL_OPs'||fields[j][5]=='SEL_Codes' || fields[j][5]=='FK') fieldtype = fields[j][5];
	var ops = typeofdata[fieldtype]; 	
	  for (var i = 0; i < ops.length; i++){
	  	var label = fLabels[ops[i]];
			if (label == null) continue;
			var option = new Option (fLabels[ops[i]], ops[i]);
			cdtSelect.options[i] = option;
	  }
	  if(ops.length==1) cdtSelect.disabled = true;
	  else cdtSelect.disabled = false;
	  
	  cdtSelect.dataFld = j;
}

/**
	代表值的下拉框发生了改变
*/
function changeDependSelValue(fieldName,valueSel){
	fieldValue = valueSel.options[valueSel.selectedIndex].value;
	
	var json_codes = new Array();
	for(var i=0;i<jcdp_codes.length;i++){
		if(jcdp_codes[i].length==4 && jcdp_codes[i][3]==fieldName){
			//重新从数据库中读取编码
			var dependCode1 = new Array();
			dependCode1[0] = jcdp_codes[i][0];
			dependCode1[1] = '';
			dependCode1[2] = jcdp_codes[i][2].replace("{fdValue}",fieldValue);
			json_codes[0] = dependCode1;
			submitStr = "arrayParam="+json_codes.toJSONString();
		  var path = cruConfig.contextPath+appConfig.queryCodesAction;
			codes_items = syncRequest('Post',path,submitStr);
			jcdp_codes_items[dependCode1[0]] = codes_items[dependCode1[0]];
			//更新下拉框
			var cmp_fields = document.getElementsByName("cmp_field");
			var cmp_sels = document.getElementsByName("cmp_sel");
			for(var j=0;j<cmp_fields.length;j++){
				var selFieldName = cmp_fields[j].options[cmp_fields[j].selectedIndex].value;
				selField = getFieldByName(selFieldName);
				if(selField[6]==dependCode1[0]) 
					updateSelectOptions(cmp_sels[j],getOpList(jcdp_codes_items[dependCode1[0]]),null);							
			}		
						
			selFieldName = getObj('bas_field').options[getObj('bas_field').selectedIndex].value;
			selField = getFieldByName(selFieldName);
			if(selField[6]==dependCode1[0]) 
				updateSelectOptions(getObj('bas_sel'),getOpList(jcdp_codes_items[dependCode1[0]]),null);				
		}		
	}
}

/*
 * function :  	快捷查询字段名称选择改变
 * @param	: 	fdSelect  	   : 字段名称sel对象		
 *		   		cdtSelect_name : 对应的条件操作sel对象名	
 *		   		fdValue_name   : 对应的条件操作sel对象名
 */
function updateFieldOption(fdSelect,cdtSelect_name,fdSel_name,fdInput_name) {	
	changeCondition(getObj(cdtSelect_name),getObj(fdSel_name),getObj(fdInput_name),fdSelect.selectedIndex);
}

/*
 * function :  	组合查询字段名称选择改变
 * @param	: 	sel 	  : 字段sel对象		
 *		   		opSelName : 对应的条件操作sel对象名	
 */
function updateCmpOption(sel) {	
	var cmp_fields = document.getElementsByName("cmp_field");
	var cmp_cdts = document.getElementsByName("cmp_cdt");
	var cmp_inputs = document.getElementsByName("cmp_input");	
	var cmp_sels = document.getElementsByName("cmp_sel");
	
	for(var i=0;i<cmp_fields.length;i++){
		if(cmp_fields[i]==sel){
			changeCondition(cmp_cdts[i],cmp_sels[i],cmp_inputs[i],sel.selectedIndex);
			return;
		}
	}	
}

function generateBasicQueryStr(){
	var bas_field = getObj('bas_field');
	var bas_cdt = getObj('bas_cdt');

	return generateQueryStr(bas_field,bas_cdt,getObj('bas_sel'),getObj('bas_input'));
}



/*
 * function :   根据所有条件拼SQL查询语句
 * @param	: 	field 	  : 字段名
 *		   		cnd       : 条件	
 *		   		value     : 值	
 */
function generateQueryStr(fieldObj,cdtObj,selValueObj,inputValueObj){
  var sqlStr = '';
  var valueType = fields[fieldObj.selectedIndex][5];
	
  if(valueType=='SEL_OPs'||valueType=='SEL_Codes'){
  	sqlStr = selValueObj.options[selValueObj.selectedIndex].value;
  //}else if(fields[fieldObj.selectedIndex][2]=='SQL_OPs'){
  }else if(valueType=='SQL_OPs'){
  	 	sqlStr = selValueObj.options[selValueObj.selectedIndex].value;
  }
  else if(valueType == 'FK'){
  	sqlStr = inputValueObj.fkValue;
  }
  else{
  	sqlStr = inputValueObj.value;
  }
  
  //alert(inputValueObj.value);
  //查询条件为空，返回
  if(sqlStr == '') return sqlStr;
  //验证
  //if(!searchValidate(basefldObj,getObj("search_text"))) return urlstring;

	var cdt_value = cdtObj.options[cdtObj.selectedIndex].value;
	sqlStr = composeSql(fieldObj,cdt_value,sqlStr);   
	
	
	return sqlStr;
}



/*
 * function :   根据所有条件拼SQL查询语句
 * @param	: 	field 	  : 字段名
 *		   		cnd       : 条件	
 *		   		value     : 值	
 */
 function generateCmpQueryStr(){
  var urlstring = '';

	var cmp_fields = document.getElementsByName("cmp_field");
	var cmp_cdts = document.getElementsByName("cmp_cdt");
	var cmp_sels = document.getElementsByName("cmp_sel");	
	var cmp_inputs = document.getElementsByName("cmp_input");	


	for(var i=0;i<cmp_fields.length;i++){
		var sqlStr = generateQueryStr(cmp_fields[i],cmp_cdts[i],cmp_sels[i],cmp_inputs[i]);
		if(sqlStr==null) return null;
		else if(sqlStr!=''){
			if(urlstring!='') urlstring += " AND ";
			urlstring += sqlStr;
		}
  }
 
	return urlstring;
}

function generateClassicQueryStr(){
	var qStr = "";
	var qTable = getObj('queryCdtTable');
	for (var i=0;i<qTable.all.length; i++) {
		var obj = qTable.all[i];
		if(obj.name==undefined || obj.name=='') continue;
		
		if (obj.tagName == "SELECT") {
			var objValue = obj.options[obj.selectedIndex].value;
			if(objValue=="") continue;
			qStr += obj.name+"='"+objValue+"' AND ";
		}		
		else if (obj.tagName == "INPUT") {
			if(obj.type == "text") {
				var objValue = obj.value;
				objValue = objValue.replace(/(^\s*)|(\s*$)/g,   ""); 
				if(objValue=="") continue;		
				qStr += obj.name+" LIKE '%"+objValue+"%' AND ";				
			}
		}
	}
	if(qStr!='') qStr = qStr.substr(0,qStr.length-4);
	return qStr;
}

/**
清除查询条件
*/
function clearQueryCdt(){
	var qTable = getObj('queryCdtTable');
	for (var i=0;i<qTable.all.length; i++) {
		var obj = qTable.all[i];
		if(obj.name==undefined || obj.name=='') continue;
		
		if (obj.tagName == "INPUT") {
			if(obj.type == "text") 	obj.value = "";		
		}
	}
}
/*
 * function :  	拼某个字段的SQL查询语句,for generateQueryStr()
 * @param	: 	fdSelect  : 字段select对象
 *		   		cnd       : 条件值	
 *		   		value     : 值	
 */
function composeSql(fdSelect,cnd,value){	
	var fieldType = fields[fdSelect.selectedIndex][2];
	var value1 = "";
	if(fieldType=='TEXT'){//文本
		value1 = "'" + value + "'";
	}
	else if(fieldType=='D'){//日期
		value1 = "time_format('"+value+"','%Y-%m-%d')";
	}
	else if(fieldType=='N'||fieldType=='NN'){//数字
	    value1=value;
	} 

	var ret = '';
	var fieldName = fdSelect.options[fdSelect.selectedIndex].value;
	if(cnd=='bwt') ret = fieldName + " like '"+value+"%'";
	else if(cnd=='ewt') ret = fieldName + " like '%"+value+"'";
	else if(cnd=='cts') ret = fieldName + " like '%"+value+"%'";
	else ret = fieldName + fMqSymbols[cnd] + value1;	
	
	if(fMqSymbols[cnd] == '<>'){
		ret = fieldName + ' is null or '+ret;
	}
	return ret;
}

/*
 * function :  	字段检查
 * @param	: 	fdSelect  : field select对象
 *		   		input     : 值对象	
 */
function searchValidate(fdSelect,input){
	var fieldType = fields[fdSelect.selectedIndex][2];
	
	var ret = true;
	switch(fieldType){
		case "ET"  :
			ret = enTextValidate(input);
			break;
		case "N"  :
			ret = intValidate(input);
			break;			
		case "NN" :
		case "M" :			
			ret = doubleValidate(input);
			break;		
			
	}
	return ret;
}

function addSearchRow(){
	var tbObj = getObj("ComplexTable");
	if(tbObj.rows.length >= 10){
		alert('对不起，查询条件不能超过10个！');
		return;
	}
	var vTr = tbObj.insertRow();
	var vCell = vTr.insertCell();
	vCell.innerHTML = "<select style=\"WIDTH: 150px\" onChange=\"updateCmpOption(this)\" name='cmp_field'/>";
	vCell = vTr.insertCell();
	vCell.innerHTML = "<select style='WIDTH: 100px' name='cmp_cdt'/>";
	vCell = vTr.insertCell();
	vCell.innerHTML = "<input name='cmp_input' style='WIDTH:120px'><select name='cmp_sel' style='WIDTH: 120px'/> ";
	var cmp_fields = document.getElementsByName("cmp_field");
	var cmp_cdts = document.getElementsByName("cmp_cdt");
	var cmp_inputs = document.getElementsByName("cmp_input");	
	var cmp_sels = document.getElementsByName("cmp_sel");
	i = cmp_fields.length-1;
	init_query_row(cmp_fields[i],cmp_cdts[i],cmp_sels[i],cmp_inputs[i]);	
}

function deleteSearchRow(){
	var tbObj = getObj("ComplexTable");	
	if(tbObj.rows.length==1){
		alert("对不起，条件不能少于1个！");
		return;
	}
	tbObj.deleteRow(tbObj.rows.length-1);
}