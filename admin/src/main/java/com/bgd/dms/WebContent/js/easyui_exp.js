//��������
//datagrid_name : ID��
//filename������execl��
//curPage:��ǰҳ
//pageSize :�ܹ�������
//Ĭ�ϲ����dc���Ի���dc=true ���� ��dc=false �򲻵������ֶ�
function exportDatForEasyUI(datagrid_name,filename,curPage, pageSize,contextPath){
	if(curPage==undefined) curPage=1;
	if(pageSize==undefined) pageSize=10;
	var submitStr = "page="+curPage+"&rows="+pageSize;
	var url = $("#"+datagrid_name).datagrid("options").url;
		url = url.substring(url.indexOf('?')+1);  
	var params = $("#"+datagrid_name).datagrid("options").queryParams;    // ����
	for(var p in params){ 
    	submitStr=submitStr+"&"+p+"="+params[p];
    }
    var columns = $("#"+datagrid_name).datagrid("options").columns;    // �õ�columns����    
    var frozenColumns=$("#"+datagrid_name).datagrid("options").frozenColumns; //获得冻结列
	var columnExp="";
	var columnTitle="";
	if(frozenColumns){
		$(frozenColumns).each(function (index) { 
			for (var i = 0; i < frozenColumns[index].length; ++i) { 
				var dc=frozenColumns[index][i].dc;//�Ƿ񵼳�
				if("undefined" == typeof dc||dc!=false){
			 	columnExp += frozenColumns[index][i].field + ",";
				columnTitle += frozenColumns[index][i].title+ ",";
				}
			}
		});
	}
	$(columns).each(function (index) { 
		for (var i = 0; i < columns[index].length; ++i) { 
			debugger;
			var dc=columns[index][i].dc;//�Ƿ񵼳�
			if("undefined" == typeof dc||dc!=false){
		 	columnExp += columns[index][i].field + ",";
			columnTitle += columns[index][i].title+ ",";
			}
		}
	});
 
	var querySql='';	
	var path = '';
		submitStr = encodeURI(submitStr);
		submitStr = encodeURI(submitStr);
		//if(cruConfig.submitStr!='')submitStr += "&"+cruConfig.submitStr;
		submitStr+="&"+url+"&JCDP_COLUMN_EXP="+columnExp+"&JCDP_COLUMN_TITLE="+columnTitle+"&JCDP_FILE_NAME="+filename;
		path = contextPath+"/common/excel/listToExcel.srq";
	var retObj = syncRequest("post", path, submitStr);
		filename = encodeURI(filename);
	    filename = encodeURI(filename);

	window.location=contextPath+"/common/download_temp.jsp?filename="+retObj.excelName+"&showname="+filename+".xls";
}