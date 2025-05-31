var selectedTagIndex = 0;
function setOneDataInfo(dataInfo,data,primakey){
	for(var i in dataInfo){
		if(data!=null&&data!=undefined){
			document.getElementById(i).value=data[i];
		}else{
			document.getElementById(i).value='';
		}
	}
		if(isNotNull(primakey)){
			if(data!=null&&data!=undefined){
				document.getElementById(primakey).value=data[primakey];
			}else{
				document.getElementById(primakey).value='';
			}
		}
	
}

function deleteTableTr(tableID){
	var tb = document.getElementById(tableID);
     var rowNum=tb.rows.length;
     for (var i=1;i<rowNum;i++)
     {
         tb.deleteRow(i);
         rowNum=rowNum-1;
         i=i-1;
     }
}

function getSubmitStrByData(dataInfo){
	var returnStr="bsflag=0";
	for(var i in dataInfo){
		var tempValue=document.getElementById(i).value;
		tempValue=encodeURI(tempValue);
		tempValue=encodeURI(tempValue);
		returnStr+='&'+i+"="+tempValue;
	}
	return returnStr;
}

function saveSingleTableInfoByData(dataInfo,tableName,tableIdName,extraSubmit){
	
	var tableId='';
	var id=document.getElementById(tableIdName).value;
	if(isNotNull(id)){
			tableId='&JCDP_TABLE_ID='+tableIdName;
	}
	var submitStr='JCDP_TABLE_NAME='+tableName+tableId+'&'+tableIdName+'='+id+'&'+getSubmitStrByData(dataInfo);
	if(isNotNull(extraSubmit)){
		submitStr=submitStr+"&"+extraSubmit;
	}
	var path = cruConfig.contextPath+'/rad/addOrUpdateEntity.srq';
	if(submitStr == null) return;
	var retObject = syncRequest('Post',path,submitStr);
	return retObject;
}

function readyForSetHeight(){
	var oLine = $("#line")[0];
	oLine.onmousedown = function(e) {
		var disY = (e || event).clientY;
		oLine.top = oLine.offsetTop;
		document.onmousemove = function(e) {
			var iT = oLine.top + ((e || event).clientY - disY)-70;
			$("#table_box").css("height",iT);
			//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-27);
			setTabBoxHeight();
		};
		document.onmouseup = function() {
			document.onmousemove = null;
			document.onmouseup = null;
			oLine.releaseCapture && oLine.releaseCapture();
		};
		oLine.setCapture && oLine.setCapture();
		return false;
	};
}



function renderNaviTable(tbObj,queryRet){
	cruConfig.totalRows=queryRet.totalRows;
	cruConfig.pageCount = queryRet.pageCount;
	cruConfig.currentPage = parseInt(queryRet.currentPage);
	if(cruConfig.totalRows==0){
		cruConfig.pageCount = 0;
		cruConfig.currentPage = 0;
	}
	else{
		cruConfig.pageCount = Math.ceil(cruConfig.totalRows/cruConfig.pageSize);
		if(cruConfig.currentPage==0) cruConfig.currentPage = 1;
	}
	var navTableRow = getObj("fenye_box_table").rows(0);
	if(navTableRow==undefined) return;
	navTableRow.cells(0).innerHTML = "第"+cruConfig.currentPage+"/"+cruConfig.pageCount+"页，共"+cruConfig.totalRows+"条记录";
	if(cruConfig.currentPage<=1){//当前是第一页
		navTableRow.cells(2).innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_01.png'  style='border:0'  alt='First' />";
		navTableRow.cells(3).innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_02.png'  style='border:0'  alt='Prev' />";
	}else{
		navTableRow.cells(2).innerHTML = "<a href='javascript:refreshData(1)'><img src='"+cruConfig.contextPath+"/images/fenye_01.png'  style='border:0'  alt='First' /></a>";
		navTableRow.cells(3).innerHTML = "<a href='javascript:refreshData("+(cruConfig.currentPage-1)+")'><img src='"+cruConfig.contextPath+"/images/fenye_02.png'  style='border:0'  alt='Prev' /></a>";
	}
	if(cruConfig.currentPage>=cruConfig.pageCount){//当前是最后一页
		navTableRow.cells(4).innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_03.png'  style='border:0'  alt='Next' />";
		navTableRow.cells(5).innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_04.png'  style='border:0'  alt='Last' />";
	}else{
		navTableRow.cells(4).innerHTML = "<a href='javascript:refreshData("+(cruConfig.currentPage+1)+")'><img src='"+cruConfig.contextPath+"/images/fenye_03.png'  style='border:0'  alt='Next' /></a>";
		navTableRow.cells(5).innerHTML = "<a href='javascript:refreshData("+(cruConfig.pageCount)+")'><img src='"+cruConfig.contextPath+"/images/fenye_04.png'  style='border:0'  alt='Last' /></a>";
	}
	navTableRow.cells(6).innerHTML = "到 <label> <input type='text' name='textfield' id='textfield' value='" + cruConfig.currentPage +"' style='width:20px;' onmouseover='selectPageNum()' onclick='selectPageNum()'/> </label>";
	navTableRow.cells(7).innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_03.png' style='cursor: hand;border:0' onclick='gotopage()'/> ";
	//&nbsp;&nbsp;<img src='"+cruConfig.contextPath+"/images/vcxz.png' width='22' height='22' style='cursor: hand;' title='导出excel' onclick='exportData()'/>
}


function createNewTitleTable(){
	// 如果不是直接的列表页面，不支持 固定表头
	if(self.frameElement!=null && self.frameElement.name!="list" && self.frameElement.name!="mainFrame" && self.frameElement.name!="menuFrame"){
		return;
	}

	var newTitleTable = document.getElementById("newTitleTable");
	if(newTitleTable!=null) return;
	var queryRetTable = document.getElementById("editionList");
	if(queryRetTable==null) return;
	var titleRow = queryRetTable.rows(0);
	
	var newTitleTable = document.createElement("table");
	newTitleTable.id = "newTitleTable";
	newTitleTable.className="tab_info";
	newTitleTable.border="0";
	newTitleTable.cellSpacing="0";
	newTitleTable.cellPadding="0";
	newTitleTable.style.width = queryRetTable.clientWidth;
	newTitleTable.style.position="absolute";
	var x = getAbsLeft(queryRetTable);
	newTitleTable.style.left=x+"px";
	var y = getAbsTop(queryRetTable)-4;
	newTitleTable.style.top=y+"px";
	
	
	var tbody = document.createElement("tbody");
	var tr = titleRow.cloneNode(true);
	
	tbody.appendChild(tr);
	newTitleTable.appendChild(tbody);
	document.body.appendChild(newTitleTable);
	// 设置每一列的宽度
	for(var i=0;i<tr.cells.length;i++){
		tr.cells[i].style.width=titleRow.cells[i].clientWidth;
		if(i%2==0){
			tr.cells[i].className="bt_info_odd";
		}else{
			tr.cells[i].className="bt_info_even";
		}
	}
	
	document.getElementById("table_box").onscroll = resetNewTitleTablePos;
	
}
function gotopage(){
	var pageNum = getObj('textfield').value;
	if(pageNum=='') return;
	var type = "^[0-9]*[1-9][0-9]*$"; 
    var re = new RegExp(type); 

	if(pageNum.match(re)==null){
		alert("页数只能输入大于0的数字！");
		getObj('textfield').value = '';
		return;
	}
	refreshData(pageNum);
}


function convertCalcuFromDesc(desc){
	var m = /^[\u4e00-\u9faf]+$/;
	var endChar="";
	var lastChar="";
	if(desc!=null&&desc!=undefined){
		var length=desc.length;
		for(var i=0;i<length;i++){
			var tempChar=desc.charAt(i);	
			var flag = m.test(tempChar);
			if(!flag){
				endChar+=tempChar;	
			}else{
				if(lastChar=='/'){
					endChar=endChar.substr(0, endChar.length-1)
					lastChar="";
				}
			}
			lastChar=tempChar;
		}
	}
	endChar=endChar.replace(/\"/g,"");
	endChar=endChar.replace(/\'/g,"");
	endChar=endChar.replace(/\%/g,"/100.0");
	endChar=endChar.replace(/\％/g,"/100.0");
	endChar=endChar.replace(/\×/g,"*");
	endChar=endChar.replace(/（/g,"(");
	endChar=endChar.replace(/）/g,")");
	endChar=endChar.replace(/、/g,"");
	endChar=endChar.replace(/：/g,"");
	endChar=endChar.replace(/:/g,"");
	endChar=endChar.replace(/\{/g,"(");
	endChar=endChar.replace(/\}/g,")");
	endChar=endChar.replace(/[a-z]|[A-Z]/g,"");
	var value = 0;
	if(endChar!=null && endChar!=''){
		value = Math.round(eval(endChar)*100)/100.0;
	}
	return value;
}

function isNotNull(data){
	if(data!=null&&data!=undefined&&data!=''){
		return true;
	}else{
		return false;
	}
}
function frameSize(){
	setTabBoxHeight();
}

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
});

function popSearch(str){
		$("#popstr").val(str);
		refreshData(1);
}
function toSerach(){
		popWindow(cruConfig.contextPath+'/op/common/searchDevice.jsp');
	}
	
function getCookie(name)//取cookies函数        
	{
 		var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
 		if(arr != null) return unescape(arr[2]); return null;
	}
function SetCookie(name,value)//两个参数，一个是cookie的名子，一个是值
{
    var Days = 30; //此 cookie 将被保存 30 天
    var exp = new Date();    //new Date("December 31, 9998");
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}
