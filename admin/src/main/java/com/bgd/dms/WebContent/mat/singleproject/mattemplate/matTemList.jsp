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

<body onload = "refreshData()" style="background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">模板名称:</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_tamplate_name" name="s_tamplate_name" type="text" /></td>
		 	    <td class="ali_cdn_name">创建时间:</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_create_date" name="s_create_date" type="text" />
		 	    </td>
		 	    <td class="ali_cdn_input">
		 	    <img src='<%=contextPath%>/images/calendar.gif'id='tributton_create_date' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(s_create_date,tributton_create_date);'/>
		 	    </td>
				<auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="" css="dr" event="onclick='AddExcelData()'" title="导入excel"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='outExcelData()'" title="导出excel"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{tamplate_id}' onclick='loadDataDetail();chooseOne(this)'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{tamplate_name}">模板名称</td>
			      <td class="bt_info_odd" exp="{tname}">班组/设备</td>
			      <td class="bt_info_even" exp="{loacked_if}">是否通用</td>
			      <td class="bt_info_odd" exp="{user_name}">创建人</td>
			      <td class="bt_info_even" exp="{create_date}">创建时间</td>
			      <td class="bt_info_odd" exp="{note}">备注</td>
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="taskTable" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				   <tr>
				   		<td class="bt_info_odd" exp="<input type='checkbox' name='task_entity_id' 
							value='' onclick=doCheck(this)/>" >
	  						 <input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
			    	    <td  class="bt_info_odd">序号</td>
			            <td  class="bt_info_even">物资编码</td>
			            <td  class="bt_info_odd">物资分类码</td>
			            <td class="bt_info_even">物资名称</td>
			            <td  class="bt_info_odd">计量单位</td>
			            <td class="bt_info_even">物资单价</td>
			            <td  class="bt_info_odd">单元用量</td>
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
	var userId = '<%=userId%>';
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	function refreshData(){
		var sql ='';
		sql +="select decode(t.loacked_if,'0','是','1','否') loacked_if,t.tamplate_id,t.tamplate_name,t.create_date,c.coding_name,u.user_name, nvl(c.coding_name,(d.dev_ci_name||d.dev_ci_model))as tname from gms_mat_demand_tamplate t left join gms_device_codeinfo d on t.device_id = d.dev_ci_code left join comm_coding_sort_detail c on t.coding_code_id = c.coding_code_id and c.bsflag='0' inner join p_auth_user u on t.creator_id = u.user_id and u.bsflag='0' where t.bsflag='0'order by t.create_date desc";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/mattemplate/matTemList.jsp";
		queryData(1);
	}

	function loadDataDetail(shuaId){
		if(shuaId!= undefined){
			taskShow(shuaId);
			document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
			document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;
			document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+shuaId;    
			
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    taskShow(ids);
		}
		
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			
			var retObj = jcdpCallService("MatItemSrv", "deleteMatTem", "matId="+ids);
			queryData(cruConfig.currentPage);
		}  
	}

	  function toAdd(){ 
		 
			  popWindow('<%=contextPath%>/mat/singleproject/mattemplate/matAddTemList.jsp','1024:800');
			
	 }  

	  function toEdit(){ 
		  ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    else{
			  popWindow('<%=contextPath%>/mat/singleproject/mattemplate/getMatTem.srq?ids='+ids,'1024:800');
		    }
			
	 }  

       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  
       function simpleSearch(){
    	   var sql ="select decode(t.loacked_if,'0','是','1','否') loacked_if,t.tamplate_id,t.tamplate_name,t.create_date,c.coding_name,u.user_name, nvl(c.coding_name,(d.dev_ci_name||d.dev_ci_model))as tname from gms_mat_demand_tamplate t left join gms_device_codeinfo d on t.device_id = d.dev_ci_code left join comm_coding_sort_detail c on t.coding_code_id = c.coding_code_id and c.bsflag='0' inner join p_auth_user u on t.creator_id = u.user_id and u.bsflag='0' where";
			var tamplate_name = document.getElementById("s_tamplate_name").value;
			var create_date = document.getElementById("s_create_date").value;
			if(tamplate_name !='' && tamplate_name != null || create_date !='' && create_date != null){
				if(tamplate_name !=''){
				sql+=" t.tamplate_name like'%"+tamplate_name+"%'and t.bsflag='0'";
				}
				if(create_date !=''){
				sql +=" t.create_date like to_date('"+create_date+"','yyyy-mm-dd') ";
					}
			}
			else{
				alert('请输入查询内容！');
				}
			
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/singleproject/mattemplate/matTemList.jsp";
			queryData(1);
			
	}
       function clearQueryText(){
   		document.getElementById("s_tamplate_name").value = "";
   		document.getElementById("s_create_date").value = "";
   	} 
     //汇总信息
  	 function taskShow(value){
  			for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
  				document.getElementById("taskTable").deleteRow(j);
  			}
  			var retObj = jcdpCallService("MatItemSrv", "getTemList", "ids="+value);
  			var taskList = retObj.matInfo;
  			for(var i =0; taskList!=null && i < taskList.length; i++){
  				var wzName = taskList[i].wzName;
  				var wzId = taskList[i].wzId;
  				var codingCodeId = taskList[i].codingCodeId; 
  				var wzPrickie = taskList[i].wzPrickie;
  				var wzPrice = taskList[i].wzPrice;
  				var unitNum = taskList[i].unitNum;
  				var autoOrder = document.getElementById("taskTable").rows.length;
  				var newTR = document.getElementById("taskTable").insertRow(autoOrder);
  				var tdClass = 'even';
  				if(autoOrder%2==0){
  					tdClass = 'odd';
  				}
  		        var td = newTR.insertCell(0);

  		        td.innerHTML = "<input type='checkbox' name='task_entity_id' value=''/>";
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}

  		        td = newTR.insertCell(1);
  		        td.innerHTML = autoOrder;
  		        //debugger;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  		        
  		        td = newTR.insertCell(2);
  				
  		        td.innerHTML = wzId;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		        
  		        td = newTR.insertCell(3);

  		        td.innerHTML = codingCodeId;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  				td = newTR.insertCell(4);
  				
  		        td.innerHTML = wzName;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		        td = newTR.insertCell(5);

  		        td.innerHTML = wzPrickie;
  		        td.className =tdClass+'_even'
  		        if(autoOrder%2==0){
  					td.style.background = "#FFFFFF";
  				}else{
  					td.style.background = "#ebebeb";
  				}
  		      td = newTR.insertCell(6);

		        td.innerHTML = wzPrice;
		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		      td = newTR.insertCell(7);

		        td.innerHTML = unitNum;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
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
  	var checked = false;
  	function check(){
		var chk = document.getElementsByName("task_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
    function AddExcelData(){
    	popWindow('<%=contextPath%>/mat/singleproject/mattemplate/matExcelAddTemList.jsp','1024:800');
        }   
    function outExcelData(){
    	 ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    else{
		    	window.location = '<%=contextPath%>/mat/singleproject/mattemplate/matExcelOutTemList.srq?tamplateId='+ids;
		    }
    	
        }
</script>

</html>

