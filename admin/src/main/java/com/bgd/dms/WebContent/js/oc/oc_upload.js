//js for upload files

var ocUpload = {
	init : ocUploadInit,
	add : ocAddFile,
	remove : ocRemoveFile,
	check : ocFileCheck
}

function ocUploadInit(maxUpfiles){
	//maxUpfiles = 5;	//set max upload files

	var html = "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n<tr>\n<td><table id=\"oc_uploadTable\" class=\"uploadTable\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\n"
		+ "  <tbody>\n"
		+ "    <tr><td><INPUT TYPE=\"FILE\" id=\"file1\" NAME=\"file1\">\n"
		+ "	<a href=\"javascript:void(0);\" onClick=\"javascript:ocUpload.remove('oc_uploadTable',this.parentNode.parentNode.parentNode);\">移除</a>\n"
		+ "    </td></tr>\n"
		+ "  </tbody>\n"
		+ "</table></td>\n<td>"
		+ "<INPUT TYPE=\"button\" id=\"oc_addbtn\" NAME=\"oc_addbtn\" value=\"添加\" \n"
		+ "	onclick=\"javascript:ocUpload.add('oc_uploadTable','oc_fileCounter'," + maxUpfiles + ");\">\n"
		+ "<input type=\"hidden\" id=\"oc_fileCounter\" value=\"1\">\n</td>\n</tr>\n</table>";

	document.write(html);
}

function ocAddFile(tableId, counterId, maxNum){
	var counter = $(counterId).value;

	var tableObj = $(tableId);
	var td = document.createElement("td");
	var tr = document.createElement("tr");
	var tbody = document.createElement("tbody");

	counter ++;
	var html = "<INPUT TYPE=\"FILE\" id=\"file"
		 + counter + "\" NAME=\"file"
		 + counter + "\">"
		 + "&nbsp;<a href='javascript:void(0);' onClick=\""
		 + "javascript:ocUpload.remove('" + tableId 
		 + "',this.parentNode.parentNode.parentNode);\">移除</a>";
	td.innerHTML = html;

	tr.appendChild(td);
	tbody.appendChild(tr);

	var tchild = tableObj.getElementsByTagName("tbody");
	var childNum = tchild.length;

	if(ocFileCheck(counterId)){
		if(childNum < maxNum){
			//tableObj.insertBefore(tbody,tableObj.firstChild);
			tableObj.appendChild(tbody);	//add file
			setValue(counterId, counter);	//set counter++
		}else{
			alert("已达到文件上传上限数："+maxNum+"个!");
			return false;
		}
	}
}

function ocRemoveFile(tableId, node){
	var tableObj = $(tableId);
	tableObj.removeChild(node);
}

function ocFileCheck(counterId){
	var counter = $(counterId).value;

	var i;
	var fileOk = 0;
	var nullId;
	for(i=1; i<=counter; i++){
		try{
			if($("file"+i).value == ""){
				fileOk = 1;
				nullId = i;
			}
		}catch(Exception){}
	}

	if(fileOk == 1){
		alert("已有未用的上传按钮！");
		$("file"+nullId).focus();
		return false;
	}

	return true;
}