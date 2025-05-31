<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getSubOrgIDofAffordOrg();
	//userId = "C105001";
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String codeId = "";
	codeId = request.getParameter("codeId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>无标题文档</title>
</head>

<body onload="refreshData()" style="background: #fff">
<div id="list_table">
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			</tr>
		</table>
		</td>
		<td width="4"><img src="<%=contextPath%>/images/list_17.png"
			width="4" height="36" /></td>
	</tr>
</table>
</div>
<div id="table_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	class="tab_info" id="queryRetTable">
	<tr>
		<td class="bt_info_even" exp="{ordernum}">序号</td>
		<td class="bt_info_odd"  exp="<a href='#'  onclick=open1('{mat_id}')>{code_name}</a> " >物资类别</td>
		<td class="bt_info_even" exp="{demand_num}">数量</td>
		<td class="bt_info_odd" exp="{demand_money}">金额</td>
		<td class="bt_info_even" exp="{rat}">占比</td>
	</tr>
</table>
</div>
<table id="fenye_box_table">
</table>
</div>
</body>
<script type="text/javascript">


function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript"><!--
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var projectInfoNo = getQueryString("projectInfoNo");
	function refreshData(){
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getRatioLeaf";
		cruConfig.submitStr ="value="+projectInfoNo;
		queryData(1);
	}
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  
       
       function open1(id){
   		popWindow('<%=contextPath%>/mat/common/matConRatioList.jsp?id='+id+'&projectInfoNo='+projectInfoNo,'1280:800');
   }
  
   function renderTable(tbObj,tbCfg){
		//更新导航栏
		renderNaviTable(tbObj,tbCfg);
		//删除上次的查询结果
		var headChxBox = getObj("headChxBox");
		if(headChxBox!=undefined) headChxBox.checked = false;
		for(var i=tbObj.rows.length-1;i>0;i--)
			tbObj.deleteRow(i);

		var titleRow = tbObj.rows(0);

		//设置选中的行号为0 
		tbObj.selectedRow = 0;
		tbObj.selectedValue = '';
		
		//给每一类添加exp属性，在ie9+iframe的情况下，td标签内的exp属性识别不出
		for(var j=0;j<titleRow.cells.length;j++){
			var tCell = titleRow.cells(j);
			tCell.exp = tCell.getAttribute("exp");
			tCell.func = tCell.getAttribute("func");
			tCell.tips = tCell.getAttribute("tips");
			
			tCell.cellClass = tCell.getAttribute("cellClass");
			tCell.isShow = tCell.getAttribute("isShow");
			tCell.isExport = tCell.getAttribute("isExport");
			if(tCell.getAttribute("isShow")=="Hide"){
				tCell.style.display = 'none';
			}
		}// end
		
		var datas = tbCfg.items;
		if(datas==undefined) datas=[];
		if(datas!=null){
			for(var i=0;i<datas.length;i++){
				var data = datas[i];
				var vTr = tbObj.insertRow();
				vTr.orderNum = i+1;
				// 选中行高亮
				vTr.onclick = function(){
					//alert(tbObj.selectedRow);
					// 取消之前高亮的行
					if(tbObj.selectedRow>0){
						var oldTr = tbObj.rows[tbObj.selectedRow];
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
					loadDataDetail(cells[0].childNodes[0].value);
				}
				vTr.ondblclick = function(){
					var cells = this.cells;
					dbclickRow(cells[0].childNodes[0].value);
				}
				
				if(cruConfig.cruAction=='list2Link'){//列表页面选择坐父页面某元素的外键
					vTr.onclick = function(){
						eval(rowSelFuncName+"(this)");
					}
					vTr.onmouseover = function(){this.className = "trSel";}
					vTr.onmouseout = function(){this.className = this.initClassName;}
				}
		
			for(var j=0;j<titleRow.cells.length;j++){
					var tCell = titleRow.cells(j);
					var vCell = vTr.insertCell();
					// 设置列样式
					if(i%2==1){
						if(j%2==1) vCell.className = "even_even";
						else vCell.className = "even_odd";
					}else{
						if(j%2==1) vCell.className = "odd_even";
						else vCell.className = "odd_odd";
						
					}
					
					if(j==0||j==1) vCell.style.textAlign="left";
					
					var outputValue = getOutputValue(tCell,data,false);
					var cellValue = outputValue;
					
					if(tCell.isShow=="Edit"){
						cellValue = "<input type=text onclick=tableInputEditable(this) onkeydown=tableInputkeydown(this) class=rtTableInputReadOnly";
						if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName
						else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2);
						if(tCell.size!=undefined) cellValue += " size="+tCell.size;
						else cellValue += " size=8";
						cellValue += " value='"+outputValue+"'>";
					}
					else if(tCell.isShow=="Hide"){
						cellValue = "<input type=text value="+outputValue;
						if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName+">"
						else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2)+">";
						vCell.style.display = 'none';
					}else if(tCell.isShow=="TextHide"){
						vCell.style.display = 'none';
					}
		//alert(typeof cellValue);alert(cellValue == undefined);
					if(cellValue == undefined || cellValue == 'undefined') cellValue = "";
					if(cellValue=='') {cellValue = "&nbsp;";}
					else if(cellValue.indexOf("undefined")!=-1){
					   cellValue = cellValue.replace("undefined","");
					}
		
					// 自动计算序号
					if(tCell.autoOrder=='1' || tCell.getAttribute('autoOrder')=='1'){
						if(cellValue==null || cellValue=="null") cellValue="";
						cellValue += ((tbCfg.currentPage-1) * tbCfg.pageSize + 1 + i);
					}
					
					vCell.innerHTML = cellValue;
					
					if(tCell.tips!=undefined && tCell.tips!=""){
						vCell.title = getOutputValue(tCell,data,true);
					}
				}
			}
			
			if(cruConfig.pageSize!=cruConfig.pageSizeMax){
				for(var i=datas.length;i<tbCfg.pageSize;i++){
					var vTr = tbObj.insertRow();
					for(var j=0;j<titleRow.cells.length;j++){
						var tCell = titleRow.cells(j);
						var vCell = vTr.insertCell();
						// 设置列样式
						if(i%2==1){
							if(j%2==1) vCell.className = "even_even";
							else vCell.className = "even_odd";
						}else{
							if(j%2==1) vCell.className = "odd_even";
							else vCell.className = "odd_odd";
						}
						vCell.innerHTML = "&nbsp;";
						// 设置是否显示
						if(tCell.isShow=="Hide"){
							vCell.style.display='none';
						}
					}
				}
			}
		}
		createNewTitleTable();
		resizeNewTitleTable();
	}
</script>

</html>

