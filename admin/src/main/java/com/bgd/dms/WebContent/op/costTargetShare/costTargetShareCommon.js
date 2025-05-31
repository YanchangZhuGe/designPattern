/**
 * 
 */

 var data=new  Object();
 var dataInfo=new Object();
 var dataInfoIfNull=new Object();
 var dataInfoForSum=new Object();
 var dataInfoForSumId=new Object();
 
 function toQueryString(head,ob){
		var str="";
		for(var i in ob){
			str=str+(head+i+"="+ob[i]+"&");
		}
		return str;
}
function autoCheckValue(i){
		if(!document.getElementById('fy'+i+"checkbox").checked){
			document.getElementById('fy'+i+"checkbox").checked=true;
		}
} 
function checkAllNodes(){
		for(var i=0;i<rowsCount;i++){
			if(document.getElementById('fy'+i+'checkbox')!=null){
				document.getElementById('fy'+i+'checkbox').checked=document.getElementById("checkbox").checked;
			}
		}
}
function getDataInfo(){
	 var dataInfoStr="";
	 for(j in dataInfo){
		 dataInfoStr+=j+",";
	 }
	 return dataInfoStr;	 
}
function getCheckTrInfo(){
		var submitStr="";
		var checkNums="";
		for(var i=0;i<rowsCount;i++){
			var fyCheck=document.getElementById('fy'+i+'checkbox');
			if(fyCheck!=null&&fyCheck.checked==true){
				checkNums+=i+",";
				for(j in dataInfo){
					dataInfo[j]=document.getElementById('fy'+i+j).value;
				}
				submitStr+=toQueryString("fy"+i,dataInfo);
			}
		}
		if(submitStr!=""){
			submitStr+="&checkNums="+checkNums;
		}
		submitStr+="&dataInfoStrs="+getDataInfo();
		return submitStr;
}

function getCheckDataForSum(){
	 var submitStr="";
	 for(i in dataInfoForSum){
		 var tempValue=0;;
		 for(var j=0;j<rowsCount;j++){
			 var fyCheck=document.getElementById('fy'+j+'checkbox');
				if(fyCheck!=null&&fyCheck.checked==true){
					 var curentValue=document.getElementById('fy'+j+i).value;
					 tempValue+=parseFloat(curentValue);
				}
		 }
		 if(submitStr==""){
			 submitStr+=dataInfoForSum[i]+":"+tempValue;
		 }else{
			 submitStr+=";"+dataInfoForSum[i]+":"+tempValue;
		 }
	 }
	 return submitStr;
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

function changeTrBackground(tbObj){
	var rows=tbObj.rows;
	for(var i =1;i<rows.length;i++){
		var tr=rows[i];
		tr.orderNum=i;
		tr.onclick=function(){
			// 取消之前高亮的行
			if(tbObj.selectedRow>0){
				var oldTr = rows[tbObj.selectedRow];
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
			loadDataDetail(cells[0].childNodes[0].value,cells[0].childNodes[1].value);
		}
	}
}