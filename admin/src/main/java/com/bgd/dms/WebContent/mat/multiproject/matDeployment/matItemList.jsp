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
	//  userId = "C105001";
ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String codeId = "";
	codeId = request.getParameter("codeId");
	
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff" onload='refreshData()'>
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			   <td class="ali_cdn_name">项目名称：</td>
		 	   <td class="ali_cdn_input"><input class="input_width" id="s_project_name" name="s_project_name" type="text" /></td>
		 	    <td class="ali_cdn_name">经办人：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_apply_name" name="s_apply_name" type="text" /></td>
		 	    <td class="ali_cdn_name">调剂日期：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_mix_date" name="s_mix_date" type="text" />
		 	    </td>
		 	    <td class="ali_cdn_input">
		 	     <img src='<%=contextPath%>/images/calendar.gif'id='tributton_create_date' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(s_mix_date,tributton_create_date);'/>
		 	    </td>
		 	    
				<auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{plan_invoice_id}' onclick='loadDataDetail();chooseOne(this)'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{submite_number}">申请单号</td>
			      <td class="bt_info_even" exp="{project_name}">项目名称</td>
			      <td class="bt_info_odd" exp="{org_abbreviation}">申请单位</td>
			       <td class="bt_info_even" exp="{apply_name}">申请人</td>
			      <td class="bt_info_odd" exp="{compile_date}">申请时间</td>
			      <td class="bt_info_even" exp="{if_input}">调剂状态</td>
			      <td class="bt_info_odd" exp="{invoices_no}">调剂单号</td>
			      <td class="bt_info_even" exp="{user_name}">经办人</td>
			      <td class="bt_info_odd" exp="{create_date}">调剂时间</td>
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
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">调剂信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id='taskTable' border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
			    	    <td  class="bt_info_odd">序号</td>
			            <td  class="bt_info_even">物资编码</td>
			            <td class="bt_info_odd">物资名称</td>
			            <td  class="bt_info_even">计量单位</td>
			            <td class="bt_info_odd">单价</td>
			            <td  class="bt_info_even">调剂数量</td>
			            <td class="bt_info_odd">金额</td>
			        </tr>
				  </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
			</div>
		  </div>
</body>
<script type="text/javascript">
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }

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

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	function refreshData(){
		var sql ="select p.plan_invoice_id,p.submite_number,tp.project_name,i.org_abbreviation,t.invoices_id,t.invoices_no,decode(t.if_input,'1','已调剂')if_input,t.create_date,u.user_name,p.compile_date,u2.user_name as apply_name from gms_mat_demand_plan_invoice p left join (GMS_MAT_TEAMMAT_INVOICES t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0'and t.invoices_type='2') on p.plan_invoice_id=t.plan_invoice_id and t.bsflag='0' inner join gp_task_project tp on p.project_info_no=tp.project_info_no and tp.bsflag='0' inner join comm_org_information i on p.org_id=i.org_id and i.bsflag='0'inner join common_busi_wf_middle wm on wm.business_id=p.plan_invoice_id  and wm.proc_status = '3' inner join gms_mat_demand_plan pd on p.plan_invoice_id=pd.plan_invoice_id left join p_auth_user u2 on u2.user_id=p.creator_id and u2.bsflag='0'  where p.bsflag='0' and pd.regulate_num is not null group by p.plan_invoice_id,tp.project_name,p.submite_number,i.org_abbreviation,t.invoices_id,t.invoices_no,if_input,t.create_date,u.user_name,p.compile_date,u2.user_name order by p.compile_date desc";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/multiproject/matescrow/matEscList.jsp";
		queryData(1);
	}
	function loadDataDetail(shuaId){
		taskShow(shuaId);
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
		document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+shuaId;    
		    
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSubmit(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			if(userId == 'C105'){
				var retObj = jcdpCallService("MatItemSrv", "deleteMatLedger", "matId="+ids);
			}
			else{
				var retObj = jcdpCallService("MatItemSrv", "deleteMatLedgerWTC", "matId="+ids);
				}
			queryData(cruConfig.currentPage);
		}  
	}

	  function toAdd(){ 
		  ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
		    else{
		    	popWindow('<%=contextPath%>/mat/multiproject/matDeployment/findEscDep.srq?laborId='+ids,'1024:800');
			    }

	 }  
	  
	  function toEdit(){ 
		  ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}else{
				 popWindow('<%=contextPath%>/mat/multiproject/matLedger/queryMatEscList.srq?laborId='+getCheckId(),'1024:800');
			}
			
		}
	  function getCheckId(){
		 	var ckeckId="";
			var tab = document.getElementById("queryRetTable");
			var row = tab.rows;
			for(var i=1;i<row.length;i++){
				if(row[i].cells[0].firstChild.checked==true){
					var id= row[i].cells[0].firstChild.value+","+row[i].cells[6].innerHTML;
					ckeckId+=id;
					}
				}
			return ckeckId;
		  }
      function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  
       function simpleSearch(){
    	   var sql ="select p.plan_invoice_id,p.submite_number,tp.project_name,i.org_abbreviation,t.invoices_id,t.invoices_no,decode(t.if_input,'1','已调剂')if_input,t.create_date,u.user_name,p.compile_date,u2.user_name as apply_name from gms_mat_demand_plan_invoice p left join (GMS_MAT_TEAMMAT_INVOICES t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0'and t.invoices_type='2') on p.plan_invoice_id=t.plan_invoice_id and t.bsflag='0' inner join gp_task_project tp on p.project_info_no=tp.project_info_no and tp.bsflag='0' inner join comm_org_information i on p.org_id=i.org_id and i.bsflag='0'inner join common_busi_wf_middle wm on wm.business_id=p.plan_invoice_id  and wm.proc_status = '3' inner join gms_mat_demand_plan pd on p.plan_invoice_id=pd.plan_invoice_id left join p_auth_user u2 on u2.user_id=p.creator_id and u2.bsflag='0'  where p.bsflag='0' and pd.regulate_num is not null ";
			var project_name = document.getElementById("s_project_name").value;
			var s_apply_name = document.getElementById("s_apply_name").value;
			var s_mix_date = document.getElementById("s_mix_date").value;
			if(project_name !='' && project_name != null ||s_apply_name !='' && s_apply_name != null || s_mix_date !='' && s_mix_date != null){
				if(project_name !=''){
					sql += " and tp.project_name like'%"+project_name+"%'";
				}
				if(s_apply_name !=''){
					 sql +=" and u.user_name='"+s_apply_name+"'"
					}
				if(s_mix_date !=''){
					sql +=" and t.create_date like to_date('"+s_mix_date+"','yyyy-mm-dd')"
					}
			}
			else{
				alert('请输入查询内容！');
				} 
			sql +=" group by p.plan_invoice_id,tp.project_name,p.submite_number,i.org_abbreviation,t.invoices_id,t.invoices_no,if_input,t.create_date,u.user_name,p.compile_date,u2.user_name order by p.compile_date desc";
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/multiproject/matLedger/matItemList.jsp";
			queryData(1);
			
	}
   	
       function clearQueryText(){
   		document.getElementById("s_wz_name").value = "";
   	} 
       //调剂信息
  	 function taskShow(value){
  			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
  				document.getElementById("taskTable").deleteRow(j);
  			}
  			var retObj = jcdpCallService("MatItemSrv", "findEscrow", "ids="+value);
  			var taskList = retObj.matInfo;
  			for(var i =0; taskList!=null && i < taskList.length; i++){
  				var wz_id = taskList[i].wz_id;
  				var wz_name = taskList[i].wz_name;
  				var wz_prickie = taskList[i].wz_prickie;
  				var total_money = taskList[i].total_money;
  				var actual_price = taskList[i].actual_price;
  				var mat_num = taskList[i].mat_num;
  				var autoOrder = document.getElementById("taskTable").rows.length;
  				var newTR = document.getElementById("taskTable").insertRow(autoOrder);
  				var tdClass = 'even';
  				if(autoOrder%2==0){
  					tdClass = 'odd';
  				}
  		        var td = newTR.insertCell(0);

  		      	td.innerHTML = autoOrder;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}

  		        td = newTR.insertCell(1);
  		        td.innerHTML = wz_id;
  		        //debugger;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  		        
  		        td = newTR.insertCell(2);
  				
  		        td.innerHTML = wz_name;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
	    		    td = newTR.insertCell(3);
	  		        td.innerHTML = wz_prickie;
	  		        //debugger;
	  		        td.className =tdClass+'_even'
	  		        if(autoOrder%2==0){
	  					td.style.background = "#FFFFFF";
	  				}else{
	  					td.style.background = "#ebebeb";
	  				}
	  		        
	  		        td = newTR.insertCell(4);
	  				
	  		        td.innerHTML = actual_price;
	  		        td.className = tdClass+'_odd';
	  		        if(autoOrder%2==0){
	  					td.style.background = "#f6f6f6";
	  				}else{
	  					td.style.background = "#e3e3e3";
	  				}
	  		        td = newTR.insertCell(5);
  		        td.innerHTML = mat_num;
  		        //debugger;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  		      td = newTR.insertCell(6);
				
		        td.innerHTML = total_money;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}

  		        	        newTR.onclick = function(){
  		        	// 取消之前高亮的行
  		       		for(var i=1;i<document.getElementById("taskTable").rows.length;i++){
  		    			var oldTr = document.getElementById("taskTable").rows[i];
  		    			var cells = oldTr.cells;
  		    			for(var j=0;j<cells.length;j++){
  		    				cells[j].style.background="#96baf6";
  		    				// 设置列样式
  		    				if(i%2==0){
  		    					if(j%2==1) cells[j].style.background = "#FFFFFF";
  		    					else cells[j].style.background = "#f6f6f6";
  		    				}else{
  		    					if(j%2==1) cells[j].style.background = "#ebebeb";
  		    					else cells[j].style.background = "#e3e3e3";
  		    				}
  		    			}
  		       		}
  					// 设置新行高亮
  					var cells = this.cells;
  					for(var i=0;i<cells.length;i++){
  						cells[i].style.background="#ffc580";
  					}
  				}
  			}
  			
  		} 
  	/*
  	*查询结果的显示
  	*/
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
  					if(cells[6].innerHTML != '&nbsp;'){
  						loadDataDetail(cells[0].childNodes[0].value+","+cells[6].innerHTML);
  					}
  					else{
  						loadDataDetail(cells[0].childNodes[0].value);
  	  					}
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
  				}
  			}
  		}
  		createNewTitleTable();
  		resizeNewTitleTable();
  	}    
</script>

</html>

