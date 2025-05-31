<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<div class="tongyong_box">
				<div class="tongyong_box_title">
					<span>计划上报金额分析&nbsp;&nbsp;</span>
					<span>年度：</span>
					<input id="ppra_year" name="year" type="text" class="input" style="line-height:18px;" readonly="readonly"/>
			   		<img width="18" height="16" id="ppra_cal_button" style="cursor: hand;" onmouseover="yearSelector(ppra_year,ppra_cal_button);" src="<%=contextPath%>/images/calendar.gif" />
		    		<span>&nbsp;</span>
		    		<input type="button" value="查询" class="input" style="width:45px;height:20px;" onclick="pPRAAToQuery()"/>
		    		<span>&nbsp;</span>
		    		<input type="button" value="清除" class="input" style="width:45px;height:20px;" onclick="pPRAAToClear()"/>
				</div>
				<div class="tongyong_box_content_left" style="height: 230px;overflow-x:hidden;">
					<table width="100%" border="0"  cellspacing="0" cellpadding="0" class="tab_info" id="pPRAATable_content">
						<tr class="trHeader">
						  	<td class="bt_info_odd" >单位</td> 
						  	<td class="bt_info_even">计划金额（元）</td>
						  	<td class="bt_info_odd" >采购金额（元）</td>
						  	<td class="bt_info_odd" >转资金额（元）</td>
						</tr>
					</table>
				</div>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	cruConfig.contextPath='<%=contextPath%>';
	$("#ppra_year").val(new Date().getFullYear());
	pPRAALoadTable(new Date().getFullYear());
	//加载主要设备基本情况统计表
	function pPRAALoadTable(year){
		var pPRAATable_content = document.getElementById("pPRAATable_content");
		//总量
		var ttr1 = pPRAATable_content.insertRow(1);
		var ttd0=ttr1.insertCell(0);
		ttd0.innerHTML = "总量：";
		var ttd1=ttr1.insertCell(1);
		ttd1.innerHTML = "0";
		var ttd2=ttr1.insertCell(2);
		ttd2.innerHTML = "0";	
		var ttd3=ttr1.insertCell(3);
		ttd3.innerHTML = "0";	
		var total1=0;
		var total2=0;
		var retObj = jcdpCallService("DemaAndPurcAnalSrv", "getTableData","year="+year);
		if(retObj!=null && retObj.returnCode=='0'){
			if(typeof retObj.datas!='undefined'){
				for(var i=0;i<retObj.datas.length && retObj.datas[i]!=null;i++){
					var map = retObj.datas[i];
					if(map!=null){
						with(map){
							var tr = pPRAATable_content.insertRow(i+2);
							var td = tr.insertCell(0);
							td.innerHTML = org_abbreviation;		
							td = tr.insertCell(1);
							if(null!=mtotal && ''!=mtotal){
								total1+=parseFloat(mtotal);
								td.innerHTML = "<a href='#' onclick=popDPList('"+year+"','"+org_subjection_id+"','demand')><font color='blue'>"+mtotal+"</font></a>";
							}else{
								td.innerHTML = "0";
							}
							td = tr.insertCell(2);
							if(null!=ptotal && ''!=ptotal){
								total2+=parseFloat(ptotal);
								td.innerHTML = "<a href='#' onclick=popDPList('"+year+"','"+org_subjection_id+"','purchase')><font color='blue'>"+ptotal+"</font></a>";
							}else{
								td.innerHTML = "0";
							}
							td = tr.insertCell(3);
							td.innerHTML = "0";
						}	
					}
				}
			}
			//给总量赋值
			if(total1>0){
				ttd1.innerHTML = "<a href='#' onclick=popDPList('"+year+"','','demand')><font color='blue'>"+total1.toFixed(2)+"</font></a>";
			}
			if(total2>0){
				ttd2.innerHTML = "<a href='#' onclick=popDPList('"+year+"','','purchase')><font color='blue'>"+total2.toFixed(2)+"</font></a>";	
			}
			pPRAAChangeTable('pPRAATable_content',1);
		}	
	}
	function pPRAAChangeTable(table_name,rowIndex){
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
	function popDPList(year,orgSubId,tableFlag){
		popWindow('<%=contextPath %>/dmsManager/plan/statAnal/demaPurcList.jsp?year='+year+'&orgSubId='+orgSubId+'&tableFlag='+tableFlag,'800:572');
	}
	function pPRAAToQuery(){
		$("#pPRAATable_content tr[class!='trHeader']").remove();
	    var year = $("#ppra_year").val();
	    //加载主要设备基本情况统计表
		pPRAALoadTable(year);
	}
	function pPRAAToClear(){
		$("#pPRAATable_content tr[class!='trHeader']").remove();
	    $("#ppra_year").val('');
	    //加载主要设备基本情况统计表
		pPRAALoadTable('');
	}
</script>
</html>

