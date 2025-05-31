/**
  根据id获取html element
*/
var appConfig = {
	queryCodesAction : "/tcg/ajaxQueryCodesByArrayParam.srq",
	updateEntitiesBySql : "/rad/asyncUpdateEntitiesBySql.srq",
	queryListAction : "/rad/asyncQueryList.srq",
	uploadFileAction : '/icg/file/ajaxFileUploadAction.srq',
	fileInputSize : '50',
	popSize : '650:500'
}

function jcdpQueryRecord(sql) {
	return jcdpCallService('RADCommCRUD', 'queryRecord', 'querySql=' + sql);
}

function jcdpQueryRecords(sql, currentPage, pageSize) {
	var submitStr = "currentPage=";
	if (currentPage == undefined)
		submitStr += "1";
	if (pageSize == undefined)
		submitStr += "&pageSize=" + 1000;
	submitStr += "&querySql=" + sql;
	return jcdpCallService('RADCommCRUD', 'queryRecords', submitStr);
}

function getObj(id) {
	var obj = document.getElementById(id);
	if (obj == null) {
		var objs = document.getElementsByName(id);
		if (objs != null)
			obj = objs[0];
	}
	return obj;
}
function setGl(obj) {
	$("#assign_body>tr:odd>td:odd").css("background-color", "#e3e3e3");
	$("#assign_body>tr:odd>td:even").css("background-color", "#ebebeb");
	$("#assign_body>tr:even>td:odd").css("background-color", "#f6f6f6");
	$("#assign_body>tr:even>td:even").css("background-color", "#FFFFFF");
	$("#assign_body :checked").removeAttr("checked")
	var columnsObj = obj.cells;
	columnsObj[0].childNodes[0].checked = true;
	for ( var i = 0; i < columnsObj.length; i++) {
		columnsObj[i].style.background = "#ffc580";
	}
}
function getCurrentDate() {
	var dt = new Date();
	var s = dt.getFullYear() + "-";
	var m = dt.getMonth() + 1;
	if (m < 10)
		s += "0" + m;
	else
		s += m;
	s += "-";
	var d = dt.getDate();
	if (d < 10)
		s += "0" + d;
	else
		s += d;
	return s;
}

function getCurrentDateTime() {
	var ret = getCurrentDate() + " ";
	var dt = new Date();
	ret += dt.getHours() < 10 ? "0" + dt.getHours() : dt.getHours() + ":";
	ret += dt.getMinutes() < 10 ? "0" + dt.getMinutes() : dt.getMinutes() + ":";
	ret += dt.getSeconds() < 10 ? "0" + dt.getSeconds() : dt.getSeconds();
	return ret;
}

function jcdpCallService(srvName, opName, submitStr) {
	var path = getContextPath()
			+ "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=" + srvName
			+ "&JCDP_OP_NAME=" + opName;

	var retObject = syncRequest('Post', path, submitStr);
	return retObject;
}

function jcdpCallServiceCache(srvName, opName, submitStr) {
	var path = getContextPath()
			+ "/cache/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=" + srvName
			+ "&JCDP_OP_NAME=" + opName;

	var retObject = syncRequest('get', path, submitStr);
	return retObject;
}

/**
	将名称为inputName的chechbox的值以,分割，组成一个字符串返回。
*/
function getSelIds(inputName) {
	var checkboxes = document.getElementsByName(inputName);

	var ids = "";
	for ( var i = 0; i < checkboxes.length; i++) {
		var chx = checkboxes[i];
		if (chx.checked) {
			if (ids != "")
				ids += ",";
			ids += chx.value;
		}
	}
	return ids;
}

function getRadionValue(inputName) {

}

/**
	获取类型为type，名称为name的html element
*/
function getElementByTypeAndName(eleType, eleName) {
	// var formObj = getObj('rtCRUTable');//document.forms[0];
	for ( var i = 0; i < document.all.length; i++) {
		var obj = document.all[i];
		if (obj.tagName == eleType && obj.name == eleName)
			return obj;
	}
	return null;
}

/**
	根据opList的内容重新刷新selObj的options
*/
function updateSelectOptions(selObj, opList, selValue) {
	for ( var i = selObj.options.length; i >= 0; i--)
		selObj.remove(i);

	if (opList == undefined)
		return;
	for ( var i = 0; i < opList.length; i++) {
		selObj.options[i] = document.createElement("OPTION");
		selObj.options[i].value = opList[i][0];
		if (selValue == opList[i][0]) {
			selObj.selectedIndex = i;
		}
		selObj.options[i].innerHTML = opList[i][1];
	}
}

function divHide(divId) {
	var id = document.getElementById(divId);
	id.style.display = 'none';
}

function hideObject(obj) {
	obj.style.display = 'none';
}

function divShow(divId) {
	var id = document.getElementById(divId);
	id.style.display = "block";
}

function popFKWindow(pUrl, inputName) {
	var callBackFunc = '';
	if (pUrl.indexOf(',') > 0) {
		callBackFunc = pUrl.substr(pUrl.indexOf(',') + 1);
		pUrl = pUrl.substr(0, pUrl.indexOf(','));
	}
	var inputObj = document.getElementsByName(inputName)[0];
	var sFeature = 'width=550,status=yes,toolbar=no,menubar=no,location=no';
	window.showModalDialog(pUrl, inputObj, 'dialogWidth=550px;');
	if (callBackFunc != '')
		eval(callBackFunc + "()");
}

function link2Page(pageUrl) {
	if (pageUrl.charAt(0) == '/')
		pageUrl = cruConfig.contextPath + pageUrl;
	window.location = pageUrl;
}
/*
 * function popWindow(url,size){ var sFeature =
 * 'status=yes,toolbar=no,menubar=no,location=no'; if(size==undefined) size =
 * appConfig.popSize; if(size!=undefined){ var strs = size.split(":"); sFeature +=
 * ",width="+strs[0]; if(strs.length==2) sFeature += ",height="+strs[1]; }
 * if(url.indexOf('?')<=0) url += '?'; else url += '&'; url += 'popSize='+size;
 * window.open(url,null,sFeature);
 * 
 * 
 * //window.showModalDialog(url,null,'status=yes;toolbar=no;menubar=no;location=no;dialogWidth:700px;');
 * //window.showModelessDialog(url,null,'status=yes;toolbar=no;menubar=no;location=no;dialogWidth:700px;'); }
 */
// ������ �°�ePlanetƽ̨�ķ���
/*
 * function popWindow(url,size){alert(top); if(top.GB_CURRENT != null) return;
 * var path = cruConfig.currentPageUrl; if(url.indexOf('/') == 0){
 * if(url.indexOf(cruConfig.contextPath) != 0){ url = cruConfig.contextPath +
 * url; } } else { path = path.substr(0,path.lastIndexOf("/")+1); url =
 * cruConfig.contextPath + path + '/' + url; } // alert('url = ' + url); var
 * height = 520; var width = 640; if(size != null){ height =
 * eval(size.split(':')[1]); width = eval(size.split(':')[0]); }
 * top.GB_show("",url,height,width); }
 */
function link2self(url, size) {
	location.href = url;
}

/**
同步请求方法
method:Post/Get
action:要请求的url
return:JSON字符串
*/
function syncRequest(method, action, content) {
	var objXMLHttp;
	if (window.XMLHttpRequest) {
		objXMLHttp = new XMLHttpRequest();
	} else {
		var MSXML = [ 'MSXML2.XMLHTTP.5.0', 'MSXML2.XMLHTTP.4.0',
				'MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'Microsoft.XMLHTTP' ];
		for ( var n = 0; n < MSXML.length; n++) {
			try {
				objXMLHttp = new ActiveXObject(MSXML[n]);
				break;
			} catch (e) {
			}
		}
	}

	content = content.replace(/\+/g, "%2B");
	if ("GET" == method.toUpperCase() && content != "") {
		if (action.indexOf("?") > 0) {
			action += "&";
		} else {
			action += "?";
		}
		action += content;
		;
		content = "";
	}
	
	if (action.substring(0, 4) != '/DMS') {
		action = '/DMS' + action;
	}

	objXMLHttp.open(method, action, false);//指定要请求的方式和页面
	objXMLHttp.setRequestHeader("Content-Type",
			"application/x-www-form-urlencoded;charset=utf-8");
	objXMLHttp.setRequestHeader("rtCallTyper", "rtAsync");
	objXMLHttp.send(content);
	// alert(objXMLHttp.responseText);
	var returnObj = eval('(' + objXMLHttp.responseText + ')');
	if (returnObj.returnCode == -9) {
		alert(returnObj.returnMsg);
		if (window.opener != null) {
			window.close();
		}
		if (top.GB_CURRENT != null) {
			top.GB_hide();
		}
		top.location = cruConfig.contextPath + '/login.jsp';
		returnObj = null;
		return;
	}
	return returnObj;
}

/**
同步请求方法
method:Post/Get
action:要请求的url
return:JSON字符串
*/
function encodeAndsyncRequest(method, action, content) {
	content = encodeURI(content);
	content = encodeURI(content);
	return syncRequest(method, action, content);
}

/**
初始化方法
根据jcdp_codes的定义读取编码表，用于Select框
*/
function initSelCodes() {
	if (jcdp_codes == undefined || jcdp_codes.length == 0)
		return;
	var json_codes = new Array();
	var dependCodes = new Array();
	//读取编码
	for ( var i = 0; i < jcdp_codes.length; i++) {
		jcdp_codes[i][1] = '';
		if (jcdp_codes[i].length >= 4) {
			if (jcdp_codes[i][3] != '') {  //即带有fkName属性
				// dependCodes[dependCodes.length] = jcdp_codes[i]; //被依赖的下拉编码
				dependCodes[dependCodes.length] = new Array();
				for (jindex = 0; jindex <= 3; jindex++) {
					dependCodes[dependCodes.length - 1][jindex] = jcdp_codes[i][jindex];
					// alert(dependCodes[dependCodes.length-1][jindex]);
				}
				if (jcdp_codes[i][4] != '')
					dependCodes[dependCodes.length - 1][4] = jcdp_codes[i][4];
			} else { //不带fkName属性
				json_codes[json_codes.length] = new Array(); //此时数组的长度+1了
				for (jindex = 0; jindex < 3; jindex++) {
					json_codes[json_codes.length - 1][jindex] = jcdp_codes[i][jindex];
				}
				// json_codes[json_codes.length] = jcdp_codes[i]; //普通下拉编码
			}
		} else
			json_codes[json_codes.length] = jcdp_codes[i];
	}
	submitStr = "arrayParam=" + JSON.stringify(json_codes);
	var path = cruConfig.contextPath + appConfig.queryCodesAction;
	jcdp_codes_items = syncRequest('Post', path, submitStr);
	if (dependCodes.length == 0)
		return;
	//读取依赖于其他字段值的编码
	// json_codes = new Array();
	for (i = 0; i < dependCodes.length; i++) {
		var dependCode = dependCodes[i];
		var field = getFieldByName(dependCode[3]);

		if (cruConfig.cruAction == 'list') {
			codeItems = jcdp_codes_items[field[6]];
		} else
			codeItems = jcdp_codes_items[field[7]];
		if (codeItems == undefined || codeItems.length == 0)
			continue;
		//编辑或查看，关联select
		if (cruConfig.cruAction == 'edit' || cruConfig.cruAction == 'view') {
			fieldValue = jcdp_record[dependCode[3]];
			if (fieldValue == '')
				fieldValue = codeItems[0].value;
		} else
			fieldValue = codeItems[0].value;
		var dependCode1 = new Array();
		dependCode1[0] = dependCode[0];
		dependCode1[1] = dependCode[1];
		dependCode1[2] = dependCode[2].replace("{fdValue}", fieldValue);
		json_codes[json_codes.length] = dependCode1;
	}
	if (json_codes.length > 0) {
		submitStr = "arrayParam=" + JSON.stringify(json_codes);
		var path = cruConfig.contextPath
				+ "/tcg/ajaxQueryCodesByArrayParam.srq";
		codes_items = syncRequest('Post', path, submitStr);
		for (i = 0; i < dependCodes.length; i++) {
			var code = dependCodes[i][0];
			jcdp_codes_items[code] = codes_items[code];
		}
	}
}

function repalceValueByEntity(value) {
	var ret = '';
	if (value.indexOf('$ENTITY.') == 0) {
		if (jcdp_record != undefined)
			ret = jcdp_record[value.substr(8)];
	} else
		ret = value;

	return ret;
}

/**
field[5] $ENTITY.creatorName
	获取值，如果没有return null;
*/
function getInputValue(field) {
	var ret = '';
	// alert(field)
	// if(jcdp_record==null) return ret;
	var fdName = field[0].substr(field[0].indexOf('.') + 1);
	if (field[3] == 'FK') {
		if (field[5] != undefined && field[5] != null) {
			values = field[5].split("\:");
			if (values.length == 2) {
				ret = new Array();
				ret[0] = repalceValueByEntity(values[0]);
				ret[1] = repalceValueByEntity(values[1]);
			}
		}
	} else if (field[3] == 'FILE') {
		ret = new Array();
		ret[0] = jcdp_record[field[0]];
		ret[1] = jcdp_record[field[7]];
	} else if (field[3] == 'D' || field[3] == 'DT') {
		if (field[5] == 'CURRENT_DATE')
			ret = getCurrentDate();
		else if (field[5] == 'CURRENT_DATE_TIME')
			ret = getCurrentDateTime();
		else if (jcdp_record != undefined) {
			ret = jcdp_record[fdName];
			if (field[3] == 'D')
				ret = ret.substr(0, 10);
			else if (field[3] == 'DT')
				ret = ret.substr(0, 16);
		}
	} else {
		if (field[5] == undefined || field[5] == null) {//取entity对应的值
			if (jcdp_record != undefined) {
				ret = jcdp_record[fdName];
			}
		} else if (field[5].indexOf('$ENTITY.') == 0) {
			if (jcdp_record != undefined) {
				ret = jcdp_record[field[5].substr(8)];
			}
		} else
			ret = field[5];
	}

	return ret;
}

/**
将编码明细构造成下拉列表
codeItems:编码明细
return: value/label数组
*/
function getOpList(codeItems) {
	var opList = new Array();
	if (codeItems == undefined || codeItems.length == 0) {
		opList[0] = [ "", "     " ];
	} else
		for ( var i = 0; i < codeItems.length; i++) {
			var item = codeItems[i];
			opList[i] = [ item.value, item.label ];
		}
	return opList;
}

/**
从fields中读取field[0]等于name的field
*/
function getFieldByName(name) {
	for ( var i = 0; i < fields.length; i++)
		if (fields[i][0] == name)
			return fields[i];
	return null;
}

/**
从fields中读取field[0]等于name并且field[11]等于tableName的field
*/
function getFieldByNameAndTable(name, tableName) {
	for ( var i = 0; i < fields.length; i++)
		if (fields[i][0] == name && tableName != undefined
				&& fields[i][11] == tableName)
			return fields[i];
		else if (fields[i][0] == name)
			return fields[i];
	return null;
}

/**
从fields中读取field，如果为hidden类型的field则加入span
*/
function getField(cfg) {
	while (cfg.nextPos < fields.length) {
		var field = fields[cfg.nextPos++];
		if (field[2] == 'Hide') {
			var spanObj = getObj('hiddenFields');
			var str = "<input type='hidden' name='" + field[0] + "' value='"
					+ getInputValue(field) + "'>";
			spanObj.innerHTML = spanObj.innerHTML + str;
		} else
			return field;
	}
	return null;
}

/**
将表单提交数据转换为数组
*/
function submitStr2Array(submitStr) {
	var ret = {};
	var fdArray = submitStr.split("&");
	for ( var i = 0; i < fdArray.length; i++) {
		var nameValue = fdArray[i].split("=");
		ret[nameValue[0]] = nameValue[1];
	}
	return ret;
}

function updateFormInputValue(data, dataFds, inputNames) {
	for ( var i = 0; i < dataFds.length; i++) {
		var ipName = inputNames[i];
		getObj(ipName).value = eval("data." + dataFds[i]);
	}
}

/**
更改select元素的值
*/
function updateSelectValue(selObjName, selObjValue) {
	var selObj = getElementByTypeAndName('SELECT', selObjName);
	selObj.value = selObjValue;
}
function checkUploadFile() {
	var tdType = document.getElementById("editFile");
	var addFileObj = document.getElementById("addFile");
	var inPutFile = document.getElementById("inPutFile");
	var upload = 'true';
	/*编辑时提交的附件为空*/
	if (addFileObj != null
			|| (inPutFile != null && inPutFile.style.display == 'block')) {
		var inPutFileValue = (addFileObj != null ? document
				.getElementById("addFile").value : document
				.getElementById("inPutFile").value);
		if (inPutFileValue == '') {
			upload = 'false';
		}
		/*编辑时没有编辑附件*/
	} else if (tdType != null && tdType.style.display == 'none'
			&& cruConfig.cruAction != 'add') {
		upload = 'false';
	}
	return upload;
}

function getContextPath() {
	var pathName = document.location.href;
	pathName = pathName.substr(9);
	var index = pathName.indexOf("/");
	pathName = pathName.substr(index + 1);
	index = pathName.indexOf("/");
	var result = pathName.substr(0, index);
	if (result.toLowerCase() == "gms3") {
		result = "/" + result;
	} else if (result.toLowerCase() == "gms4") {
		result = "/" + result;
	} else if (result.toLowerCase() == "dms") {
		result = "/" + result;
	} else {
		result = "";
	}
	return result;
}

//20140402  刘广 根据字典表查询  参数1.编码2.idname 名称
function getCodeList(code, name) {
	var codeObj;
	var unitSql = "select sd.coding_code_id,coding_name ";
	unitSql += "from comm_coding_sort_detail sd ";
	unitSql += "where coding_sort_id ='" + code + "' order by coding_code ";
	var unitRet = syncRequest('Post', getContextPath()
			+ appConfig.queryListAction, 'querySql=' + unitSql
			+ '&pageSize=1000');
	codeObj = unitRet.datas;
	var optionhtml = "";// "<option name='code"+name+"'
	// id='code"+name+codeindex+"'
	// value='"+codeObj[codeindex].coding_code_id+"'>"+codeObj[codeindex].coding_name+"</option>";
	for ( var codeindex = 0; codeindex < codeObj.length; codeindex++) {
		optionhtml += "<option name='code" + name + "' id='code" + name
				+ codeindex + "' value='" + codeObj[codeindex].coding_code_id
				+ "'>" + codeObj[codeindex].coding_name + "</option>";
	}
	return optionhtml;
}