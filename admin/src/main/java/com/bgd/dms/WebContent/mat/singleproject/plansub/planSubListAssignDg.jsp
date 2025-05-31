<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//String projectName=user.getProjectName();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	//String projectInfoNo = user.getProjectInfoNo();
	//SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	//String appDate = df.format(new Date());
	//String projectType = user.getProjectType();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>大港</title>
</head>

<body style="background: #fff" onload="refreshData()">
<div id="list_table">

<div id="table_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	<tr>
		<td class="bt_info_odd"
			exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{plan_invoice_id},{assign_type}' onclick='chooseOne(this);'/>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td>
		<td class="bt_info_odd" exp="{project_name}">项目名称</td>
		<td class="bt_info_even" exp="{plan_name}">计划名称</td> 
		<td class="bt_info_odd" exp="{total_money}">计划金额</td>
		<td class="bt_info_even" exp="{plan_invoice_type}">计划指向</td>
		<td class="bt_info_odd" exp="{submite_number}">申请单号</td>
		<td class="bt_info_even" exp="{user_name}">申请人</td>
		<td class="bt_info_odd" exp="{compile_date}">提交时间</td>
		<td class="bt_info_even" exp="{assign_type}">分配状态</td>
		<td class="bt_info_odd" exp="<span onclick=select('{plan_invoice_id}','{assign_type}')>查看</span>">调配进度</td>
	</tr>
</table>
</div>
<div id="fenye_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0"
	id="fenye_box_table">
	<tr>
		<td align="right">第1/1页，共0条记录</td>
		<td width="10">&nbsp;</td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
			width="20" height="20" /></td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
			width="20" height="20" /></td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
			width="20" height="20" /></td>
		<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
			width="20" height="20" /></td>
		<td width="50">到 <label> <input type="text"
			name="textfield" id="textfield" style="width: 20px;" /> </label></td>
		<td align="left"><img src="<%=contextPath%>/images/fenye_go.png"
			width="22" height="22" /></td>
	</tr>
</table>
</div>
<div class="lashen" id="line"></div>
<div id="tag-container_3">
<ul id="tags" class="tags">
	<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">分配出库</a></li>
	<span style="float: right;left:10px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
	<auth:ListButton functionId="" css="bc" style="float: right;" event="onclick='toAdd()'" title="保存"></auth:ListButton>
	<span style="float: right;left:30px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
	<auth:ListButton functionId="" css="xg" style="float: right;" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
</ul>
</div>

<div id="tab_box" class="tab_box">
<div id="tab_box_content0" class="tab_box_content">
<table border="0" cellpadding="0" cellspacing="0" id='taskTable'
	class="tab_line_height" width="100%" style="background: #efefef">
	<tr>
		<td class="bt_info_even" >序号</td>
		<td class="bt_info_odd" >物资名称</td>
		<td class="bt_info_even" >需求数量</td>
		<td class="bt_info_odd" >计量单位</td>
		<td class="bt_info_even" >参考单价</td>
		<td class="bt_info_odd" >计划金额</td>
		<td class="bt_info_even" >需求日期</td>
		<td class="bt_info_odd" >出库单位</td>
		
		</tr>
</table>
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
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	cruConfig.contextPath =  "<%=contextPath%>";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var projectInfoNo = "";
	var assign="";
	
	// function chooseOne(cb){   
	//        var obj = document.getElementsByName("rdo_entity_id");   
	 //       for (i=0; i<obj.length; i++){   
	 //           if (obj[i]!=cb) obj[i].checked = false;   
	  //          else obj[i].checked = true;   
	  //      }   
	  //  } 
	
	function refreshData(){
		
		var sql ="select t.plan_invoice_type,t.compile_date,t.total_money,t.plan_invoice_id,t.submite_number,o.org_abbreviation org_name,u.user_name,p.project_name,t.plan_name,t.main_part,t.memo,decode(t.assign_type, '0', '未分配', '1', '已分配', '', '未分配') assign_type from gms_mat_demand_plan_invoice t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' where t.plan_invoice_id in(select t.plan_invoice_id from gms_mat_demand_plan_invoice t  inner join common_busi_wf_middle t3 on t3.business_id =t.plan_invoice_id    where t.org_subjection_id like 'C105007%'  and t3.proc_status='3' and t.bsflag='0') and t.plan_invoice_type!='物资供应' order by t.assign_type nulls first,t.compile_date desc";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/suppliesAllocate/planSubListAssignDg.jsp";
		queryData(1);
	}
	function org_select(){
		var select =document.createElement("select");
		select.style.width="130px";
		var retObj = jcdpCallService("MatItemSrv", "select_org", "ids=");
		var taskList = retObj.list;
		for(var i =0; taskList!=null && i < taskList.length; i++){
			select.options.add(new Option(taskList[i].org_abbreviation, taskList[i].org_id));
			}
		
		return select;
		}
	function loadDataDetail(shuaId){
		var ids=shuaId.split(",");
		projectInfoNo=ids[0];
		assign=ids[1];
		for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
				document.getElementById("taskTable").deleteRow(j);
			}
			var retObj = jcdpCallService("MatItemSrv", "findSubListAssignDg", "ids="+projectInfoNo);
			var taskList = retObj.list;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				var wz_id = taskList[i].wz_id;       //物资ID
				var wz_name = taskList[i].wz_name;	 //物资名称
				var wz_price = taskList[i].wz_price; //参考单价
				var demand_num = taskList[i].demand_num; //使用数量
				
				var wz_prickie = taskList[i].wz_prickie; //计量单位
				var demand_date = taskList[i].demand_date;  //需求日期
				var plan_detail_id = taskList[i].plan_detail_id;  //主键 

				var outbound_org_id = taskList[i].outbound_org_id;  //出库单位
				var autoOrder = document.getElementById("taskTable").rows.length;
				var newTR = document.getElementById("taskTable").insertRow(autoOrder);
				var tdClass = 'even';
				if(autoOrder%2==0){
					tdClass = 'odd';
				}
		        var td = newTR.insertCell(0);
				td.id=plan_detail_id;
		      	td.innerHTML = autoOrder;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}

		        td = newTR.insertCell(1);
		        td.id=wz_id;
		        td.innerHTML = wz_name;
		        //debugger;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(2);
				
		        td.innerHTML = demand_num;
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
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
  		        
  		        td = newTR.insertCell(4);
  				
  		        td.innerHTML = wz_price;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		        td = newTR.insertCell(5);
		        td.innerHTML = Math.round(wz_price*demand_num);
		        //debugger;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		      td = newTR.insertCell(6);
			
	        td.innerHTML = demand_date;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
			
				        td = newTR.insertCell(7);
				        if(assign!="未分配"){
				        	td.innerHTML =outbound_org_id;
					        }else{
				        td.appendChild(org_select());
					        }
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
	

	 
	 function toAdd(){
		 if(assign=="未分配"){
			 var tdStr = document.getElementById("taskTable").getElementsByTagName("TR");
			 var sql="update gms_mat_demand_plan_invoice set assign_type='1' where plan_invoice_id='"+projectInfoNo+"' ";
			 for(var i=1; i<tdStr.length; i++)
			 {
				var td= tdStr[i].getElementsByTagName("TD");
				var plan_detail_id  = td[0].id;   //主键
				var wz_id           = td[1].id;	  //需求申请主键
				var outbound_org_id = td[7].getElementsByTagName("select")[0].value;  //出库组织id
				var outbound_number = td[2].innerHTML;			//出库数量
						 sql +=" @update gms_mat_demand_plan_detail set outbound_org_id='"+outbound_org_id+"',outbound_number='"+outbound_number+"' where plan_detail_id='"+plan_detail_id+"' ";
					
			}
			  var aaa=jcdpCallService("MatItemSrv", "updateAssignDg", "sql="+sql);
			  if(aaa!=null){
				  location.reload();
				  }
			 }else{
				alert("该计划已经指定出库单位");

			}
		
	 }  
	 function chooseOne(cb){  
	        //先取得同name的chekcBox的集合物件   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
	            //else  obj[i].checked = cb.checked;   
	            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
	            else obj[i].checked = true;   
	        }   
	    }
	 function select(id,type){
		
		// var valReturn=window.showModalDialog("<%=contextPath%>/mat/multiproject/suppliesAllocate/viewSuppliesAllocate.jsp?plan_invoice_id="+id+"","","dialogWidth:750px;dialogHeight:500px");
			if(type=="未分配"){
				alert("该单没有指定出库单位,暂不能查看详细调配信息");
				}else{
					popWindow('<%=contextPath%>/mat/multiproject/suppliesAllocate/viewSuppliesAllocate.jsp?plan_invoice_id='+id,'1024:800');
			}
		
		 }
	 function toEdit(){
		 if(assign=="已分配"){
		 var retObj = jcdpCallService("MatItemSrv", "select_assign_type", "plan_invoice_id="+projectInfoNo);
			var taskList = retObj.matInfo.flatType;
			if(parseInt(taskList,10)>0){
				alert("该单已经调配出库，不能修改出库单位");
				}else{
					assign="未分配";
					for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
						document.getElementById("taskTable").deleteRow(j);
					}
					var retObj = jcdpCallService("MatItemSrv", "findSubListAssignDg", "ids="+projectInfoNo);
					var taskList = retObj.list;
					for(var i =0; taskList!=null && i < taskList.length; i++){
						var wz_id = taskList[i].wz_id;       //物资ID
						var wz_name = taskList[i].wz_name;	 //物资名称
						var wz_price = taskList[i].wz_price; //参考单价
						var demand_num = taskList[i].demand_num; //使用数量
						
						var wz_prickie = taskList[i].wz_prickie; //计量单位
						var demand_date = taskList[i].demand_date;  //需求日期
						var plan_detail_id = taskList[i].plan_detail_id;  //主键 

						var outbound_org_id = taskList[i].outbound_org_id;  //出库单位
						var outbound_number = taskList[i].outbound_number;	//出库数量
						var flat_org_id = taskList[i].flat_org_id;			//平库单位
						var flat_number = taskList[i].flat_number;			//平库数量
						
						var autoOrder = document.getElementById("taskTable").rows.length;
						var newTR = document.getElementById("taskTable").insertRow(autoOrder);
						var tdClass = 'even';
						if(autoOrder%2==0){
							tdClass = 'odd';
						}
						  var td = newTR.insertCell(0);
							td.id=plan_detail_id;
					      	td.innerHTML = autoOrder;
					        td.className = tdClass+'_odd';
					        if(autoOrder%2==0){
								td.style.background = "#f6f6f6";
							}else{
								td.style.background = "#e3e3e3";
							}

					        td = newTR.insertCell(1);
					        td.id=wz_id;
					        td.innerHTML = wz_name;
					        //debugger;
					        td.className =tdClass+'_even'
					        if(autoOrder%2==0){
								td.style.background = "#f6f6f6";
							}else{
								td.style.background = "#e3e3e3";
							}
					        
					        td = newTR.insertCell(2);
							
					        td.innerHTML = demand_num;
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
								td.style.background = "#f6f6f6";
							}else{
								td.style.background = "#e3e3e3";
							}
			  		        
			  		        td = newTR.insertCell(4);
			  				
			  		        td.innerHTML = wz_price;
			  		        td.className = tdClass+'_odd';
			  		        if(autoOrder%2==0){
			  					td.style.background = "#f6f6f6";
			  				}else{
			  					td.style.background = "#e3e3e3";
			  				}
			  		        td = newTR.insertCell(5);
					        td.innerHTML = Math.round(wz_price*demand_num);
					        //debugger;
					        td.className =tdClass+'_even'
					        if(autoOrder%2==0){
								td.style.background = "#f6f6f6";
							}else{
								td.style.background = "#e3e3e3";
							}
					      td = newTR.insertCell(6);
						
				        td.innerHTML = demand_date;
				        td.className = tdClass+'_odd';
				        if(autoOrder%2==0){
							td.style.background = "#f6f6f6";
						}else{
							td.style.background = "#e3e3e3";
						}
						
							        td = newTR.insertCell(7);
							        if(assign!="未分配"){
							        	td.innerHTML =flat_org_id;
								        }else{
							        td.appendChild(org_select());
								        }
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
					}//11
					}
		 	}
		 }
</script>

</html>

