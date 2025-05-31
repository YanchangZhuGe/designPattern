var rowSelFuncName = 'onRowSelect';	
var jcdp_codes_items = null;
var j=1;
var h=1;

//获取contextPath
function getContextPath() {
	var pathName = document.location.href;
	pathName = pathName.substr(9);
    var index = pathName.indexOf("/");
    pathName = pathName.substr(index+1);
    index = pathName.indexOf("/");
    var result = pathName.substr(0,index);
    if(result.toLowerCase()!="gms4"){
    	result="";
    }else{
    	result = "/"+result;
    }
    return result;
}

//初始化编码
function initCodes(){
	cruConfig.contextPath = getContextPath();
	if(jcdp_codes==undefined || jcdp_codes.length==0)return;	
	var json_codes = new Array();
	var dependCodes = new Array();
	//读取编码
	for(var i=0;i<jcdp_codes.length;i++){
		jcdp_codes[i][1] = '';
		if(jcdp_codes[i].length==4) dependCodes[dependCodes.length] = jcdp_codes[i];
		else json_codes[json_codes.length] = jcdp_codes[i];
	}
	submitStr = "arrayParam="+JSON.stringify(json_codes);

  	var path = cruConfig.contextPath+appConfig.queryCodesAction;
	jcdp_codes_items = syncRequest('Post',path,submitStr);
	//alert(jcdp_codes_items['subSyses'][0].value)
	//alert(jcdp_codes_items['subSyses'][0].label)
	if(dependCodes.length==0) return;		
}

//动态添加table
function addTable(){
	cruConfig.contextPath = getContextPath();
	var datas = initData();
	
	var table = document.getElementById("mytable");
	var newRow = table.insertRow();
	var cell1 = newRow.insertCell();
	cell1.innerHTML = '<input type="checkbox" name="check" >';
	for(var i=0;i<datas.length;i++){
		var data = datas[i];
		var key = data.split(':')[0];
		var value = data.split(':')[1];
		if(value=='T'){
			var cell = newRow.insertCell();
			cell.innerHTML = '<input type="text" name="'+key+'" value="">';
			continue;
		}
		else if(value=='N'){
			var cell = newRow.insertCell();
			cell.innerHTML = '<input type="text" name="'+key+'" value="">';
			continue;
		}
		else if(value=='NN'){
			var cell = newRow.insertCell();
			cell.innerHTML = '<input type="text" name="'+key+'" value="">';
			continue;
		}
		else if(value=='D'){				
			//alert(j);
			var cell = newRow.insertCell();
			cell.innerHTML = '<input type="text" name="'+key+'" id="'+key+j+'" readonly>&nbsp;<img src="'+cruConfig.contextPath+'/images/calendar.gif" id="tributton'+j+'" width="16" height="16" style="cursor:hand;" onmouseover="dateSelector('+key+j+',tributton'+j+');"/>';
			j++;
			continue;
		}
		else if(value.substring(0,2)=='S1'){
			var code = value.split('@')[1];
			//alert(jcdp_codes_items[code][0].value);
			var cell = newRow.insertCell();
			var newHtml = '<select id="'+key+'" name="'+key+'">';
			for(var k=0;k<jcdp_codes_items[code].length;k++){
				var newValue = jcdp_codes_items[code][k].value;
				var label = jcdp_codes_items[code][k].label;
				newHtml+='<option value="'+newValue+'">'+label+'</option>';
			}
			newHtml+='</select>';
			cell.innerHTML = newHtml;
			continue;
		}
		else if(value.substring(0,2)=='S2'){
			var selectValue = value.split('@');
			var cell = newRow.insertCell();
			var newHtml = '<select id="'+key+'" name="'+key+'">';
			for(var k=1;k<selectValue.length;k++){
				var newValue = selectValue[k].split(',')[0];
				var label = selectValue[k].split(',')[1];
				newHtml+='<option value="'+newValue+'">'+label+'</option>';
			}
			newHtml+='</select>';
			//alert(newHtml)
			cell.innerHTML = newHtml;
			continue;
		}
		else if(value.substring(0,1)=='P'){
			var k = key.split('-')[0];
			var v = key.split('-')[1];
			var urlValue = value.split("@")[1];
			var cell = newRow.insertCell();
			cell.innerHTML = '<input type="text" name="'+k+'" id="'+k+h+'" readonly>&nbsp;<img src="'+cruConfig.contextPath+'/images/select.gif" width="16" height="16" style="cursor:hand;" border="0" onClick=openMyWindow('+v+h+','+k+h+',\"'+urlValue+'\")><input type="hidden" id="'+v+h+'" name="'+v+'">';
			//alert(cell.innerHTML);
			h++;
		    continue;
		}
	}	
}

//调用lpmd
function openMyWindow(id,name,urlValue){
	window.showModalDialog(urlValue,this,"height=500,width=300");
	id.value = fkValue;
	name.value = value;
}

//删除选中的行
function delSelect(){
	var table = document.getElementById("mytable");
	var checkValue = document.getElementsByName("check");
	var count = 0;
	for(var i=0;i<checkValue.length;i++)
	{
		if(checkValue[i].checked == true)
		{
		   count++;
		}
	}
	if(count == 0){
		alert("必须选中一条要删除的记录！");
		return false;
	}
	if(confirm("您确认删除此记录吗？"))
	{
		for(var i=0;i<checkValue.length;i++)
		{
			if(checkValue[i].checked == true)
			{
				table.deleteRow(i+1);
				i--;
			}
		}
	}
}

//批量添加
function save(){
	//表名
	var datas = initData();
	var data = datas[0];
	var tableName = data.split(':')[1];
	//alert(tableName);
	
	
	var tableObj = getObj('mytable');
	var mytr = tableObj.childNodes[0];
	
	var rowParams = new Array();
	//alert(mytr.innerHTML)
	for(var i=1;i<mytr.childNodes.length;i++){
		var oneTr = mytr.childNodes[i];		
		//alert(oneTr.innerHTML);
		var rowParam="";
		for(var j=1;j<oneTr.childNodes.length;j++){
			var oneTd = oneTr.childNodes[j];
			//alert(oneTd.innerHTML);
			//alert(oneTd.childNodes[0].nodeName);			
			//alert("第"+j+"列");
			for(var k=0;k<oneTd.childNodes.length;k++){
				//alert("第"+k+"个子节点");
				if(oneTd.childNodes[k].nodeName=='INPUT'||oneTd.childNodes[k].nodeName=='SELECT'){				
					rowParam+=("\""+oneTd.childNodes[k].name+"\":\""+oneTd.childNodes[k].value+"\",")
					//alert(ttt);	
				}
			}
		}
		rowParam = rowParam.substring(0,rowParam.length-1);
		rowParam = '{'+rowParam+'}';
		//alert(rowParam)
		var obj = rowParam.parseJSON();
    	//alert(JSON.stringify(obj));    
   	 	
		//alert(eval('('+rowParam+')'));
		rowParams.push(obj);		
	}	
	var rows=JSON.stringify(json_codes);
	saveFunc(tableName,rows);
}

//保存
function saveFunc(tableName,rowParams){
	var path = getContextPath()+"/rad/addOrUpdateEntities.srq";
	submitStr = "tableName="+tableName+"&"+"rowParams="+rowParams;
	//alert(submitStr);
	if(submitStr == null) return;
	var retObject = syncRequest('Post',path,submitStr);
	afterSave(retObject);
}

//提示提交结果
function afterSave(retObject,successHint,failHint){
	if(successHint==undefined) successHint = '提交成功';
	if(failHint==undefined) failHint = '提交失败';
	if (retObject.returnCode != "0") alert(failHint);
	else{
		alert(successHint);
		//window.opener.refreshData();
		//window.close();
	}
}
