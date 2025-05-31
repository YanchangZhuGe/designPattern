<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath=request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/common/include/quotesresource.jsp"%>
		<title>计划上报金额分析</title>
	</head>
	<body style="background: #cdddef; overflow-y: auto">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<div class="tongyong_box">
						<div class="tongyong_box_title" style="text-indent:0px;">
							<span>&nbsp;&nbsp;</span>
							<span>计划上报金额分析&nbsp;&nbsp;</span>
							<span>年度：</span>
							<input id="year" name="year" class="easyui-numberspinner tongyong_box_title_input" style="line-height:23px; height:23px;" data-options="editable:false"/>
							<input type="button" value="查询" class="tongyong_box_title_button" onclick="toQuery()"/>
				    		<input type="button" value="清除" class="tongyong_box_title_button" onclick="toClear()"/>
						</div>
						<div class="tongyong_box_content_left" id="chartContainer1" style="overflow-x:hidden;">
							<table width="100%" border="0"  cellspacing="0" cellpadding="0" class="tab_info" id="table_content">
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
	</body>
	<script type="text/javascript">
		cruConfig.contextPath='<%=contextPath%>';
		function frameSize(){
			$("#chartContainer1").css("height",$(window).height()-$(".tongyong_box_title").height()-10);
		}
		$(function(){
			frameSize();
			$(window).resize(function(){
		  		frameSize();
			});
			$('#year').numberspinner('setValue', new Date().getFullYear());
			loadTable(new Date().getFullYear());
		});
		//加载主要设备基本情况统计表
		function loadTable(year){
			var table_content = document.getElementById("table_content");
			//总量
			var ttr1 = table_content.insertRow(1);
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
								var tr = table_content.insertRow(i+2);
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
				changeTable('table_content',1);
			}	
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
		function popDPList(year,orgSubId,tableFlag){
			popWindow('<%=contextPath %>/dmsManager/plan/statAnal/demaPurcList.jsp?year='+year+'&orgSubId='+orgSubId+'&tableFlag='+tableFlag,'800:572');
		}
		function toQuery(){
			$("#table_content tr[class!='trHeader']").remove();
		    var year = $('#year').numberspinner('getValue');
		    //加载主要设备基本情况统计表
			loadTable(year);
		}
		function toClear(){
			$("#table_content tr[class!='trHeader']").remove();
			$('#year').numberspinner('setValue', new Date().getFullYear());
		    //加载主要设备基本情况统计表
			loadTable(new Date().getFullYear());
		}
	</script>
</html>

