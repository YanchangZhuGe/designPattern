<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgSubjectionId();
	String user_id = user.getUserId();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
<style type="text/css">
.ali_cdn_input{
	width: 180px;
	text-align: left; 
}

.ali_cdn_input input{
	width: 80%;
}

</style>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			<input type="hidden" id="hse_model_id" name="hse_model_id" value=""></input>
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">模板名称</td>
			    <td class="ali_cdn_input">
			    <input id="modelName" name="modelName" type="text"/>
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_model_id}' id='rdo_entity_id_{hse_model_id}'  onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{model_name}">模板名称</td>
			      <td class="bt_info_even" exp="{user_name}">创建人</td>
			      <td class="bt_info_odd" exp="{create_date}">创建时间</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
		  </div>
</body>

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	// 复杂查询
	function refreshData(){
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select m.hse_model_id,m.model_name,m.creator_id,u.user_name,m.create_date from bgp_hse_assess_model m join p_auth_user u on m.creator_id=u.user_id and u.bsflag='0' where m.bsflag='0' and m.creator_id='<%=user_id %>' order by m.modifi_date desc"
		cruConfig.currentPageUrl = "/hse/objAndTarget/hseAssess/model_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/objAndTarget/hseAssess/model_list.jsp";
		queryData(1);
	}
	
	
	// 简单查询
	function simpleSearch(){
			var modelName = document.getElementById("modelName").value;
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = "select m.hse_model_id,m.model_name,m.creator_id,u.user_name,m.create_date from bgp_hse_assess_model m join p_auth_user u on m.creator_id=u.user_id and u.bsflag='0' where m.bsflag='0'  and m.creator_id='<%=user_id %>'  and m.model_name like '%"+modelName+"%' order by m.modifi_date desc"
			cruConfig.currentPageUrl = "/hse/objAndTarget/hseAssess/model_list.jsp";
			queryData(1);
	}
	
	function clearQueryText(){
		document.getElementById("modelName").value = "";
	}
	
	
	function loadDataDetail(shuaId){
		
		var retObj;
		if(shuaId!=null){
			 document.getElementById("hse_model_id").value= shuaId;
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    document.getElementById("hse_model_id").value= ids;
		}
	}
	
	function dbclickRow(shuaId){
		var retObj;
		var modelInfo = "";
		if(shuaId!=null){
			retObj = jcdpCallService("HseSrv", "queryModel", "hse_model_id="+shuaId);
			modelInfo = shuaId+","+retObj.map.modelName;
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "queryModel", "hse_model_id="+ids);
		    modelInfo = ids+","+retObj.map.modelName;
		}
		    window.returnValue = modelInfo;
			window.close();
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
			tCell.cellClass = tCell.getAttribute("cellClass");
		}// end
		
		var datas = tbCfg.items;
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
					// 自动计算序号
					if(tCell.autoOrder=='1' || tCell.getAttribute('autoOrder')=='1'){
						vCell.innerHTML=((tbCfg.currentPage-1) * tbCfg.pageSize + 1 + i);
						continue;
					}
					
					var outputValue = getOutputValue(tCell,data);
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
		
					vCell.innerHTML = cellValue;
				}
			}
		}
		createNewTitleTable();
		resizeNewTitleTable();
	}
	
</script>

</html>

