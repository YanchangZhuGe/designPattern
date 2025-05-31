<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String assess_type = request.getParameter("assesstype");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>首页固定场所审核分数</title>
</head>
<body style="background: #cdddef; overflow-y: auto"  onload="loadTable()">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<td width="49%">
		<div class="tongyong_box">
			<div class="tongyong_box_content_left" id="table_box" style="overflow-x:hidden;height: 350px;">
			 	<table width="100%" border="0"  cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
					<tr class="trHeader">
						<td class="bt_info_odd_fix" width="20%">被审核单位</td> 
						<td class="bt_info_even_fix" width="9%">审核人员</td>
						<td class="bt_info_odd_fix"  width="15%">审核开始时间</td>
						<td class="bt_info_even_fix" width="15%">审核结束时间</td>
						<td class="bt_info_odd_fix" width="13%">要素综合得分</td>
						<td class="bt_info_even_fix" width="13%">检查得分</td>
						<td class="bt_info_odd_fix" width="15%">审核明细 / 问题项</td>
					</tr>
				</table>
			</div>
		</div>
	</td>
</table>
</div>
</body>
<script type="text/javascript">
	//createNewTitleTable();
	cruConfig.contextPath = '<%=contextPath%>';
	var assesstype = '<%=assess_type%>';

    function createNewTitleTable(){
		// 如果是dialog
		if(window.dialogArguments){
			return;
		}		
		// 如果声明了不出现固定表头
		if(window.showNewTitle==false){
			return;
		}
		
		var newTitleTable = document.getElementById("newTitleTable");
		if(newTitleTable!=null) return;
		var queryRetTable = document.getElementById("queryRetTable");
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
		var y = getAbsTop(queryRetTable);//
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
				tr.cells[i].className="bt_info_odd_fix";
			}else{
				tr.cells[i].className="bt_info_even_fix";
			}
			// 设置是否显示
			if(titleRow.cells[i].isShow=="Hide"){
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
	
	function loadTable(suborg){

		var retObj = jcdpCallService("AssessPlatInfoSrv", "getIndexAssessScore","assessType="+assesstype);
	
		if(typeof retObj.datas!="undefined" && retObj.returnCode=='0'){
			var queryRetTable = document.getElementById("queryRetTable");
			for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
				var map = retObj.datas[i];
				if(map!=null){
					with(map){
						var tr = queryRetTable.insertRow();
						var td = tr.insertCell(0);
						td.innerHTML = assessorgname;					
						td = tr.insertCell(1);
						td.innerHTML = assess_user_name ;
						td = tr.insertCell(2);
						td.innerHTML = assess_start_date ;
						td = tr.insertCell(3);
						td.innerHTML = assess_end_date;
						td = tr.insertCell(4);
						td.innerHTML = item_compre_score;
						td = tr.insertCell(5);
						td.innerHTML = check_sum_score;
						td = tr.insertCell(6);
						td.innerHTML = "<a onclick=assessDetInfo('"+assess_score_id+"','0')><font color='blue'>查看</font></a>"+
									   " / <a onclick=assessDetInfo('"+assess_score_id+"','1')><font color='blue'>查看</font></a>";
					}	
				}
			}
			changeTable('queryRetTable',2);
		}
		resizeNewTitleTable();
	}
	function changeTable(table_name,rowIndex){
		var table = document.getElementById(table_name);
		for(var i =rowIndex ;i<table.rows.length;i++){
			var tr = table.rows[i];
			for(var j =0 ;j< tr.cells.length;j++){
				tr.cells[j].align ='center';
				if(i%2==0){
					if(j%2==1) tr.cells[j].style.background = "#FFFFFF";
					else tr.cells[j].style.background = "#f6f6f6";
				}else{
					if(j%2==1) tr.cells[j].style.background = "#ebebeb";
					else tr.cells[j].style.background = "#e3e3e3";
				}
			}
		}
	}
	
	//查看审核明细/问题项页面
	function assessDetInfo(id,flag){
		if(flag == '0'){
			popWindow('<%=contextPath%>/assess/findScoreReportByID.srq?flag=view&scoreID='+id+'&indexFlag=0','1024:580');
		}else{
			popWindow('<%=contextPath%>/assess/createMarkScoreList.srq?scoreID='+id+'&indexFlag=0','1024:580');
		}
	}

</script>
</html>