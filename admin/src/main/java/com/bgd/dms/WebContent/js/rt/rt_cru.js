var defaultCRUCfg={
	inputSize:20
};

/**
  初始化新建实体的输入表格
*/
function initCreateTable(){

	var cruTable = getObj("rtCRUTable");
	var fieldConfig = {
		nextPos:0,
		origRowLn:0
	}
	
	var field = getField(fieldConfig);

	while(field!=null){
		var vTr = cruTable.insertRow(fieldConfig.origRowLn++);	
		if(field[3]=='MEMO'){//备注字段，占一行
			generateFieldMemo(vTr,field);	
			field = getField(fieldConfig);
			continue;	
		}
		else if(field[3]=='FILE'){//附件字段，占一行
		//alert("附件字段，占一行")
			generateFileField(vTr,field);	
			field = getField(fieldConfig);
			continue;		
		}	
		else if(field[3]=='FILES'){//附件字段，占一行
			//vTr = cruTable.insertRow(fieldConfig.origRowLn++);	
			if(cruConfig.cruAction=='add'){
				generateMultiFileField(vTr,field);	
			}else{
				generateViewMultiFileField(vTr,field);	
			}
  		
			field = getField(fieldConfig);
			
			continue;		
		}		
	
		generateFieldInput(vTr,field,fieldConfig);		
		field = getField(fieldConfig);	
		if(cruConfig.lineRange=='1') continue;
		
		if(field!=null && field[3]=='MEMO'){//备注字段，另起一行
		generateFieldInput(vTr,null,fieldConfig);
			vTr = cruTable.insertRow(fieldConfig.origRowLn++);	
			generateFieldMemo(vTr,field);	
			field = getField(fieldConfig);
			continue;	
		}
		else if(field!=null && field[3]=='FILE'){//附件字段，占一行
		    generateFieldInput(vTr,null,fieldConfig);
			vTr = cruTable.insertRow(fieldConfig.origRowLn++);
			generateFileField(vTr,field);
			//alert(vTr.outerHTML)	
			field = getField(fieldConfig);
			continue;		
		}
  	else if(field!=null && field[3]=='FILES'){//多附件字段，占一行
  	 generateFieldInput(vTr,null,fieldConfig);
  		vTr = cruTable.insertRow(fieldConfig.origRowLn++);	
  		if(cruConfig.cruAction=='add'){
				generateMultiFileField(vTr,field);	
			}else{
				generateViewMultiFileField(vTr,field);	
			}
			field = getField(fieldConfig);	
			continue;		
  		
  	/*	
  		vTr = cruTable.insertRow(fieldConfig.origRowLn++);	
  		generateMultiFileField(vTr,field);	
			field = getField(fieldConfig);
			continue;
			*/
  	}

  	
		else generateFieldInput(vTr,field,fieldConfig);
		field = getField(fieldConfig);	
	}
}

/**
  生成附件field
*/
function generateFileField(vTr,field){
//alert("cruConfig.cruAction="+cruConfig.cruAction);
	var vCell1 = vTr.insertCell();
	var vCell2 = vTr.insertCell();
	vCell1.className = 'rtCRUFdName';
//	vCell1.innerHTML = field[1];

		
	//var field0 = getField(fieldConfig0);
	
	var tableName = fields[0][5];
	
	var labelHtml=field[1]; //如果上传附件不能为空
	if(field[8]=='non-empty')
	labelHtml= "<font color='red'>*</font>&nbsp;"+field[1];
	vCell1.innerHTML = labelHtml;
	
	vCell2.className = 'rtCRUFdValue';
	vCell2.colSpan = "3";
	
	var fileHtml = "<div ><table><tr id='fileLook'>";
	
	var ret='' ;
	var inputSize='' ;
    var entity_id ='' ;
	if(cruConfig.cruAction !='add')
	  { 
	    ret = getInputValue(field);
	    entity_id = getObj("entity_id");
	    //alert("ret[0]:"+ret[0]+" ret[1]:"+ret[1]+" entity_id:"+entity_id);
	    //alert("ret[0]:"+ret[0]);
	    
	  }
	  if(cruConfig.cruAction=='view' && ret[0]==''){
	     fileHtml ='无'
	  }
	if((cruConfig.cruAction=='edit'&&ret[0]=='')||(cruConfig.cruAction=='add' )){//page action是edit且没有附件，或者新加时
		fileHtml = "<input id='addFile' type='file' ";
		inputSize = appConfig.fileInputSize;
		if(field[6]!=undefined && field[6]!='') inputSize = field[6];
		fileHtml += "size='"+inputSize+"' name='"+field[0]+"'>";
		//alert("fileHtml="+fileHtml);
	}
	else if(cruConfig.cruAction=='edit') {// page action 是edit时
	    fileHtml += "<td style='font-size:13' >"+ret[1]+"</td>";
	    if(ret[0] != null && ret[0] != ''){
			fileHtml +=  "<td style='font-size:13'><a  href="+cruConfig.contextPath+"/icg/file/DownloadFileAction.srq?pkValue="+ret[0]+">"+"下载&nbsp;"+"</a></td>";
	    }
	    fileHtml +=  "<td style='font-size:13'><a  href='#' onclick=editFile() >"+"编辑&nbsp;"+"</a></td>";
	    if(ret[0] != null && ret[0] != ''){
	    	fileHtml +=  "<td style='font-size:13'><a  href='#' onclick=deleteFile('"+ret[0]+"','"+entity_id.value+"','"+tableName+"','"+tableName+"') >"+"删除&nbsp;"+"</a></td>";
	    }
	    fileHtml += "</tr>" ;
		fileHtml += "<tr id='editFile' style='display:none;'><td><input id='inPutFile' style='display:none;' type='file' size='20' name='"+field[0]+"'></td><td id='back' style='font-size:13' style='display:none;'><a href='#' onclick=editFileBack()  >"+"返回"+"</a></td></tr>";
	    fileHtml += "</table></div>" ;
	}else{//page action 是view时 
	    if(ret[0]==''){
	      //alert("111");
	      fileHtml ="无附件";
	     }else{
	       fileHtml +=  "<td style='font-size:13'><a href="+cruConfig.contextPath+"/icg/file/DownloadFileAction.srq?pkValue="+ret[0]+">"+ret[1]+"</a></td>";
	     }
	}
	  vCell2.innerHTML = fileHtml;
}

/**
删除附件
*/
function deleteFile(fileId,entityId,tableName){
	    var hint = "确认要删除吗?";
		if (!window.confirm(hint)) {
				return;
		}
		var submitStr = "file_id="+fileId +"&entity_id="+entityId +"&tableName="+tableName
		jcdpCallService("FILEDELETE","deleteFile",submitStr);
		
		document.getElementById("fileLook").style.display='none';
		document.getElementById("editFile").style.display='block';
		document.getElementById("inPutFile").style.display='block'
		document.getElementById("back").style.display='none'
	}
/**
编辑附件
*/
function  editFile(){
	document.getElementById("fileLook").style.display='none';
	document.getElementById("editFile").style.display='block';
	document.getElementById("inPutFile").style.display='block';
	document.getElementById("back").style.display='block';
}



function editFileBack(){
document.getElementById("fileLook").style.display='block';
	document.getElementById("editFile").style.display='none';
	document.getElementById("inPutFile").style.display='none';
	document.getElementById("back").style.display='none';
}
/**
  生成多附件field2
*/
function generateMultiFileField(vTr,field){
  var vCell1 = vTr.insertCell();
	var vCell2 =document.createElement("td");
	var file_name=field[0];
	vCell1.className = 'rtCRUFdName';
	vCell1.innerHTML = field[1];
	  vCell2.colSpan = 3;
	    var cell2='<div id=files_list style="background-color:#fff;margin-top:2px;margin-left:10px;margin-bottom:2px;padding:5px;border:1px;border-style:solid;border-color:#69CDF2;height:100px;width:75%;">'
	        	   +'</div>';
	      cell2 =cell2+'<div align=right style="margin-top:-35px;margin-right:25px;"><a href=#? class=addfile><input id=my_file_element class=addfile type=file name=file_1 size=3></a><font color=red>最多支持5个附件</font>';
	
	    jsinfo=' var multi_selector = new MultiSelector( document.getElementById(\'files_list\'), 5 );\r\n';
			jsinfo=jsinfo+'	multi_selector.addElement( document.getElementById(\'my_file_element\' ),\''+file_name+'\' );\r\n'; 
      vCell2.innerHTML =cell2;
      vTr.appendChild(vCell2);
      eval(jsinfo);
}
/**
  下载多附件
*/
function generateViewMultiFileField(vTr,field){
  var vCell1 = vTr.insertCell();
	var vCell2 =document.createElement("td");
	var file_name=field[0];
	vCell1.className = 'rtCRUFdName';
	vCell1.innerHTML = field[1];
	  //查询多附件的文件名称
	var returnObj = jcdpCallService('ICGFileManager','queryMultiFileNames','infoId='+getInputValue(field))	  
	    vCell2.colSpan = 3;
	    var cell2='<div id=files_list style="background-color:#fff;margin-top:2px;margin-left:10px;margin-bottom:2px;padding:5px;border:1px;border-style:solid;border-color:#69CDF2;height:100px;width:97%;">'
	     
		    if(typeof(returnObj.names)!='undefined'){
		    	
			    for(var j=0;j<returnObj.names.length;j++){
					  	//alert(returnObj.names[j].file_name);
					    cell2=cell2+ "<a href="+cruConfig.contextPath+"/icg/file/DownloadFileAction.srq?pkValue="+returnObj.names[j].file_id+">"+returnObj.names[j].file_name+"</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
					  }	
				  
	       }
	    	cell2=cell2+'</div>';
	
      vCell2.innerHTML =cell2;
      vTr.appendChild(vCell2);

}
/**
  生成多附件field2
*/
function generateMultiFileFieldBK(vTr,field){
  var vCell1 = vTr.insertCell();
	var vCell2 =document.createElement("td");
	var file_name=field[0];
	vCell1.className = 'rtCRUFdName';
	vCell1.innerHTML = '<a href=#? class=addfile><input id=my_file_element class=addfile type=file name=file_1 size=3></a><font color=red>最多上传5个附件</font>';
	  
	  
	  vCell2.colSpan = 3;
	    var cell2='<div id=files_list style="background-color:#fff;margin-top:2px;margin-bottom:2px;padding:5px;border:1px;border-style:solid;border-color:#69CDF2;height:100px;width:99%;">'
	        	   +'</div>\r\n';
	      
	    jsinfo=' var multi_selector = new MultiSelector( document.getElementById(\'files_list\'), 5 );\r\n';
			jsinfo=jsinfo+'	multi_selector.addElement( document.getElementById(\'my_file_element\' ),\''+file_name+'\' );\r\n'; 
      vCell2.innerHTML =cell2;
      vTr.appendChild(vCell2);
      eval(jsinfo);

}
/**
  生成一个备注框和名字
*/
function generateFieldMemo(vTr,field){
	var vCell1 = vTr.insertCell();
	var vCell2 = vTr.insertCell();
	vCell1.className = 'inquire_item4';//'rtCRUFdName';
	if(field[8]=='non-empty')
		vCell1.innerHTML = "<font color='red'>*</font>&nbsp;"+field[1];
	else vCell1.innerHTML = field[1];
	
	vCell2.className = 'inquire_form4';//'rtCRUFdValue';
	vCell2.colSpan = "3";
	
	memoHtml = "<textarea class='textarea' name='"+field[0]+"'";
	if(field[2]=='ReadOnly' || cruConfig.cruAction=='view') memoHtml += " ReadOnly";
	var memoValue = getInputValue(field);
	if(memoValue==null) memoValue = "";
	var cols = '40';
	var rows = '2';
	if(field[6]!=undefined && field[6]!=''){
		if(field[6].indexOf(':')>0){
			var sizeArray = field[6].split(':');
			cols = sizeArray[0];
			rows = sizeArray[1];
		}else cols = field[6];
	}
	memoHtml += " cols="+cols+" rows="+rows+">"+memoValue+"</textarea>";
	
	vCell2.innerHTML = memoHtml;
}

/**
  生成一个输入框和名字
*/
function generateFieldInput(vTr,field,cfg){//alert('d');
		var vCell1 = vTr.insertCell();
		
		vCell1.className = 'inquire_item4';//'rtCRUFdName';
		

		if(field==null){
			vCell1.innerHTML = "&nbsp;";
			vCell1.colSpan = "2";
		}
		else{
			var vCell2 = vTr.insertCell();
			vCell2.className = 'inquire_form4';//'rtCRUFdValue';
			var labelHtml = field[1];
			if(field[8]=='non-empty')
					labelHtml = "<font color='red'>*</font>&nbsp;"+labelHtml;
			vCell1.innerHTML = labelHtml;
			
			if(field[3]=="SEL_OPs" || field[3]=="SEL_Codes"){
				vCell2.appendChild(createSelect(field));
			}else if(field[3]=="AUTO_CODE"){
				var inputHtml = "<input disabled type='text' name='"+field[0]+"' dataFld='"+(cfg.nextPos-1)+"'";
				inputHtml += " codeName='"+field[7]+"' class='input_width'";
				inputHtml += " value='"+getInputValue(field)+"'";				
				if(field[6]==undefined || field[6]==null) field[6] = defaultCRUCfg.inputSize;
				inputHtml += " size="+field[6];						
				inputHtml += ">";		
				vCell2.innerHTML = inputHtml;
			}else if(field[3]=="D"){   //如果是日期类型
				var calHtml = "";
				var inputHtml = "<input type='text' name='"+field[0]+"'  dataFld='"+(cfg.nextPos-1)+"' class='input_width'";
				if(field[6]==undefined || field[6]==null) field[6] = defaultCRUCfg.inputSize;
				inputHtml += " size="+field[6];							
				if(cruConfig.cruAction=='view'){
					inputHtml += " readonly";
				}
				else{
					if(field[2]=='ReadOnly'){
						 if(field[7]=='NONE') inputHtml += " disabled";
						 else inputHtml += " readonly";
					}
					if(field[7]!='NONE'){
						calHtml += " <img src=\""+cruConfig.contextPath+"/images/calendar.gif\" id=\"cal_button"+(cfg.nextPos-1)+"\"";
						calHtml += " width=\"16\" height=\"16\"  style=\"cursor:hand;\"";
						calHtml += " onmouseover=\"calDateSelector("+field[0]+",cal_button"+(cfg.nextPos-1)+");\"/>";						
					}
				}
				inputHtml += " value='"+getInputValue(field)+"' ";
				if(field[10]!=undefined) inputHtml += field[10];
				inputHtml += ">";
				vCell2.innerHTML = inputHtml+calHtml; 
			}			
			else{
				var inputHtml = "<input type='";
				if(field[3]=="pswd"){
					inputHtml += "password";
				}else{
					inputHtml += "text";
				}
				inputHtml += "' name='"+field[0]+"' dataFld='"+(cfg.nextPos-1)+"'  class='input_width'";
				if(field[10]!=undefined)  inputHtml += field[10];
				var dftInputValue = getInputValue(field);					
				if(field[3]=="FK"){
					if(dftInputValue!=''){
						inputHtml += " value='"+dftInputValue[1]+"' fkValue='"+dftInputValue[0]+"'";
					}
					if(field[7]!=undefined && field[7]!=null && cruConfig.cruAction!='view') field[6] = '18';	
					if(field[2]=='ReadOnly')inputHtml += " readonly";														
				}else{
					if(dftInputValue!=null)
						inputHtml += " value='"+dftInputValue+"'";					
				}
				if(field[2]=='ReadOnly' && cruConfig.cruAction!='view') inputHtml += " disabled";
				else if(cruConfig.cruAction=='view') inputHtml += " readonly";
				if(field[4]!=null) 
					inputHtml += " MAXLENGTH="+field[4];
				if(field[6]==undefined || field[6]==null) field[6] = defaultCRUCfg.inputSize;
				inputHtml += " size="+field[6];					
				if(cruConfig.cruAction!='view' && uniqueFields.indexOf(":"+field[0]+":")>=0)//需要判断重复
					inputHtml += " onblur=\"isUniqueField(this,'"+field[3]+"')\"";						
				inputHtml += ">";				
				if(field[3]=="FK" && cruConfig.cruAction!='view' && field[7]!=undefined && field[7]!=null){	
					var eventFunc = '';
					if(field[7].substr(field[7].length-2)=="()") eventFunc = field[7];
					else eventFunc = "popFKWindow('"+field[7]+"','"+field[0]+"')";
					inputHtml += "<input type='button' value='...' id='"+field[0]+"_button' onclick=\""+eventFunc+"\">";
				}									    
			  vCell2.innerHTML = inputHtml;	
			}	
		}	
}


/**
  生成一个下拉列表
*/
 function createSelect(field){
	var sel = document.createElement("SELECT");
	sel.name = field[0];
	sel.className = 'select_width';
	if(field[6]!=undefined){
	  sel.style.width=field[6];
	}
	if(field[2]=='ReadOnly' || cruConfig.cruAction=='view') sel.disabled = true;
	
	
  fillSelectOptions(sel,field);
  //影响其他下拉框
  if(field[3]=='SEL_Codes' || field[3]=='SEL_OPs')
  	for(i=0;i<jcdp_codes.length;i++)
  		if(jcdp_codes[i].length>=4 && jcdp_codes[i][3]==field[0]){
  			sel.onchange = function(){toChangeDependSelect(this);}
  		}
  	//添加下拉框事件
  	if(field[10] != null){
  		var eventName = field[10].split('=')[0];
  		var eventFunc = field[10].split('=')[1];
  		sel.attachEvent(eventName,function(){eval(eventFunc)});
  	}
	return sel;
}

/**
  用field指定的下拉列表或编码，构造Select的Options
*/
function fillSelectOptions(sel,field){
	//清空Select原有的Options
	if(sel.options!=undefined)
		for(var i=sel.options.length-1;i>=0;i--) sel.options.remove(i);
	if(field[3]=="SEL_OPs") opList = field[7];
	else opList = getOpList(jcdp_codes_items[field[7]])
	
	if(opList==undefined || opList.length==0) return;	
	inputValue = getInputValue(field);
	//检查是否需要生成空选项
	var withNull = false;  //默认不显示空选项
	for(var i=0;i<jcdp_codes.length;i++){
		if(jcdp_codes[i][0] == field[7]){
			if(jcdp_codes[i].length == 5 && jcdp_codes[i][4] == 'withNull'){
				withNull = true;
				break;
			}
		}
	}
	var listLength=opList.length;
	if(withNull){listLength++};
	var j=0;
	for(var i=0;i<listLength;i++){
		sel.options[i] = document.createElement("OPTION");
	  	if(i==0 && withNull){
	  		sel.options[i].value = "";
	  		sel.options[i].innerHTML = " ";
		}
		else{
			sel.options[i] = document.createElement("OPTION");
	  		sel.options[i].value = opList[j][0];
	  		sel.options[i].innerHTML = opList[j][1];
	  		j++;
	  	}
	  	if(inputValue==sel.options[i].value){
	  		sel.selectedIndex = i;
	  	}	
  }	
}

/**
  Select的值改变时，同时改变关联的Select
*/
function toChangeDependSelect(selObj){
	if(cruConfig.loadFinished=='false') return;
	
	fieldName = selObj.name;
	fieldValue = selObj.options[selObj.selectedIndex].value;
	
	var json_codes = new Array();
	for(i=0;i<jcdp_codes.length;i++)
		if(jcdp_codes[i].length>=4 && jcdp_codes[i][3]==fieldName){
			//重新从数据库中读取编码
			var dependCode1 = new Array();
			dependCode1[0] = jcdp_codes[i][0];
			dependCode1[1] = jcdp_codes[i][1];
			dependCode1[2] = jcdp_codes[i][2].replace("{fdValue}",fieldValue);
			json_codes[0] = dependCode1;
			submitStr = "arrayParam="+JSON.stringify(json_codes);
		  var path = cruConfig.contextPath+"/tcg/ajaxQueryCodesByArrayParam.srq";
			codes_items = syncRequest('Post',path,submitStr);
			jcdp_codes_items[dependCode1[0]] = codes_items[dependCode1[0]];
			
			//更新下拉框
			for(j=0;j<fields.length;j++){
				var field = fields[j];
				if(field.length>=4 && field[3]=='SEL_Codes' && field[7]==dependCode1[0]){
					var dependSel = getElementByTypeAndName("SELECT",field[0]);
					fillSelectOptions(dependSel,field);
				}
			}
		}	
}

function extractFdName(inputName,fdNamePrefix){
	if(fdNamePrefix=='') return inputName;
	else return inputName.substr(fdNamePrefix.length);
}

/**
	新增或修改时获取提交参数
*/
function getSubmitStr(tableName){
	var submitStr = '';
	var formObj = getObj('fileForm');
	var arrayStr = $(formObj).find("*");//获取form的所有元素
	
	for (i=0; i<arrayStr.length; i++) {
		var obj = arrayStr[i];
		if(obj.name==undefined || obj.name=='') continue;
		var objField = getFieldByNameAndTable(obj.name);
	  
	  if(objField!=undefined){
			if(tableName!=undefined){			
				if(objField[11]==undefined) continue;
				if(objField[11]!=tableName) continue;
			}else{
				if(objField[11]!=undefined) continue;
			}
		}
		
		var fdName=(objField!=null && objField.length>=9 && objField[9]!=undefined)?objField[9]:obj.name;//if columnName exists
		if (obj.tagName == "SELECT") {
			if(obj.disabled) continue;
			submitStr += fdName+"="+obj.options[obj.selectedIndex].value+"&";
		}else if (obj.tagName == "TEXTAREA") {
			if(obj.readOnly == true) continue;
			if(objField[8]=='non-empty'){
				if(obj.value==''||obj.value.length==0){
					if(objField[2]=='Edit') obj.focus();
					alert("请输入"+objField[1]+"!");
					return null;			
				}
			}
			//检查长度
			if(objField[4] != ''){
				if(obj.value.length > objField[4]){
					obj.focus();
					alert('对不起，'+objField[1]+'字段最大长度不能超过'+objField[4]+'个字符！');
					return null;
				}
			}
			submitStr += fdName+"="+jcdpEncodeValue(obj.value)+"&";
		}else if (obj.tagName == "INPUT") {
			if(obj.type == "hidden") {
				submitStr += fdName+"="+ jcdpEncodeValue(obj.value)+"&";
			}			else if(obj.type == "text" || obj.type == "password") {
			var pos = $(obj).attr("dataFld");		
			if(fields[pos][3]=='AUTO_CODE'){//平台自动编码
				if(obj.value=='') submitStr += fdName+"=[SAIS_AUTOCODE]"+ obj.codeName+"&";
				continue;
			}
			if(cruConfig.cruAction=='edit' && fields[pos][3]!='FK'){				
				if((obj.readOnly == true)|| obj.disabled==true) continue;
			}		
			if(cuValidate(obj,fields[pos])==false) return null;
			if(fields[pos][3]=='FK')
				submitStr += fdName+"="+ $(obj).attr("fkValue")+"&";				
			else submitStr += fdName+"="+ jcdpEncodeValue(obj.value)+"&";
			}else if(obj.type == "checkbox") {
				if(obj.checked)
					submitStr += fdName+"="+obj.value+"&";
				else 
					submitStr += fdName+"=&";
			}else if(obj.type == "radio") {
				submitStr += fdName+"="+ obj.value+"&";
			}else if(obj.type == "file") {   //检查附件是否为空
			    if(objField[8]=='non-empty'&&objField[3]=='FILE'){
			       if(cruConfig.cruAction=='add'){
			    	 if(obj.value==''||obj.value.length==0){
			            if(objField[2]=='Edit') obj.focus();
			            alert("请添加"+objField[1]+"!");
			            return null;			
		             }
		            }
		           if(cruConfig.cruAction=='edit'){
		           var flag=false;
		           if(document.getElementById("fileLook").style.display!='none'){
		             if(document.getElementById("fileLook").cells.length>2)
		             flag=true;
		            
		           }else {
			           if(document.getElementById("inPutFile").value!='')
			           flag=true
		           }
		           if(!flag){
		            alert("请添加"+objField[1]+"!");
			            return null;	}
		           }
		      }
			}										
		}
	}
	submitStr = submitStr.substr(0,submitStr.length-1);
	return submitStr;
}

function jcdpEncodeValue(value){
	value = encodeURIComponent(value);
	//value = encodeURI(value);
	return value;
}

/**
  新增或修改主子表时，该函数将主表的提交参数串转为数组
*/
function convertSubmitStr2JSONObj(submitStr){
	var ret = {};
	var strs = submitStr.split("&");
	for(var i=0;i<strs.length;i++){
		var fdStr = strs[i];
		var fdStrs = fdStr.split("=");
		if(fdStrs.length==2) ret[fdStrs[0]] = fdStrs[1];
	}
	return ret;
}

/**
  获取子表的提交参数
*/
function getItemsParam(){
	var itemsTable = getObj("itemsTable");
	var rowParams = new Array();
	for(var j=2;j<itemsTable.rows.length;j++){
		var vTr = itemsTable.rows[j];
		var rowParam = {};
		for (var i=0; i<vTr.all.length; i++) {
			var obj = vTr.all(i);
			if (obj.tagName == "INPUT") {
				if(itemFields.indexOf(","+obj.name+",")>=0){
					var inputValue = encodeURI(obj.value);//if(obj.name=='item_id')alert(obj.name+obj.value);
					inputValue = encodeURI(inputValue);
					rowParam[obj.name] = inputValue;
				}
			}
		}
		rowParams[rowParams.length] = rowParam;
	}
	return rowParams;
}

/**
  新增或修改主子表时，增加子表的一行数据
*/
function addItem(){
	var itemsTable = getObj("itemsTable");
	var newRow = itemsTable.insertRow();
	var firstRow = itemsTable.rows[1];
	for(var i=0;i<firstRow.cells.length;i++){
		var vCell = newRow.insertCell();
		vCell.innerHTML = firstRow.cells(i).innerHTML;	
	}
}

/**
  新增或修改主子表时，删除子表的一行或多行数据
*/
function deleteItem(){
	var itemsTable = getObj("itemsTable");
	for(var i=itemsTable.rows.length-1;i>=2;i--){
		var vTr = itemsTable.rows[i];
		var vTd = vTr.cells[0];
		if(vTd.children(0).checked) itemsTable.deleteRow(i);
	}		
}

/**
	获取附件字段索引 
*/
function getFileFieldsIndex(){
	var ffs = fileFields.split(":");
	var ffIndexArray = new Array();
	for(var i=0;i<ffs.length;i++){
		if(ffs[i]=='') continue;		
		var ffIndex = {};
		var field = getFieldByName(ffs[i]);
		ffIndex['name'] = field[0];
		ffIndex['type'] = field[3];
		if(field[11]==undefined) ffIndex['table'] = '';
		else ffIndex['table'] = field[11];
		ffIndexArray[ffIndexArray.length] = ffIndex;
	}
	return JSON.stringify(ffIndexArray);
}

