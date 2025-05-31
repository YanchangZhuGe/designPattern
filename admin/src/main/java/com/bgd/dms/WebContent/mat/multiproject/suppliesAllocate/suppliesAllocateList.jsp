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
	String projectName=user.getProjectName();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String projectInfoNo = user.getProjectInfoNo();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectType = user.getProjectType();
	String user_org_id=user.getOrgId();
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
<title>物资调配</title>
</head>

<body style="background: #fff" onload="refreshData();">
<div id="list_table">
<div id="inq_tool_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="6"><img src="<%=contextPath%>/images/list_13.png"
			width="6" height="36" /></td>
		<td background="<%=contextPath%>/images/list_15.png">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="ali_cdn_name">申请单位：</td>
		 	    <td class="ali_cdn_input" style="width: 120px;"><input class="input_width" id="s_create_date" name="s_create_date" type="text"  style="width: 80%;"/>&nbsp;</td>
		 	    <td class="ali_cdn_name">申请人：</td>
		 	    <td class="ali_cdn_input" style="width: 120px;"><input class="input_width" id="s_create_date" name="s_create_date" type="text"  style="width: 80%;"/>&nbsp;</td>
		 	    <td class="ali_cdn_name">调配状态：</td>
		 	    <td class="ali_cdn_input" style="width: 120px;"><input class="input_width" id="s_create_date" name="s_create_date" type="text"  style="width: 80%;"/>&nbsp;</td>
		 	   <!-- 
		 	    <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
		 	    -->
				<td>&nbsp;</td>
				<td></td>
			   <!-- 
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
				<auth:ListButton functionId="" css="dr" event="onclick='AddExcelData()'" title="导入excel"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='outExcelData()'" title="导出excel"></auth:ListButton>
				<auth:ListButton functionId="" css="gb" event="onclick='closeData()'" title="关闭"></auth:ListButton>
			    -->
				<td></td>
				<td></td>
				<td></td>
			</tr>
		</table>
		</td>
		<td width="4"><img src="<%=contextPath%>/images/list_17.png"
			width="4" height="36" /></td>
	</tr>
</table>
</div>
<div id="table_box">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	<tr>
		<td class="bt_info_odd"
			exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{plan_invoice_id},{status},{submite_number},{project_info_no}' onclick='chooseOne(this);loadDataDetail();'/>">选择</td>
		<td class="bt_info_even" autoOrder="1">序号</td>
		<td class="bt_info_odd" exp="{submite_number}">申请单号</td>
		<td class="bt_info_even" exp="{org_name}">申请单位</td>
		<td class="bt_info_odd" exp="{user_name}">申请人</td>
		<td class="bt_info_even" exp="{compile_date}">需求日期</td>
		<td class="bt_info_even" exp="审批通过">审批状态</td>
		<td class="bt_info_odd" exp="{type}">调配状态</td>
		<!-- <td class="bt_info_even" exp="{status}">表单状态</td> --><!-- 整个表单的状态 -->
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
	<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">物资调配</a></li>
	<auth:ListButton functionId="" css="bc" style="float: right;" event="onclick='toAdd()'" title="保存"></auth:ListButton>
</ul>
</div>

<div id="tab_box" class="tab_box">
<div id="tab_box_content0" class="tab_box_content">
<table border="0" cellpadding="0" cellspacing="0" id='taskTable'
	class="tab_line_height" width="100%" style="background: #efefef">
	<tr>
		<td class="bt_info_even" >序号</td>
		<td class="bt_info_odd" >物资名称</td>
		<td class="bt_info_even" >计量单位</td>
		<td class="bt_info_odd" >参考单价</td>
		<td class="bt_info_even" >需求日期</td>
		<td class="bt_info_odd" >需求数量</td>
		<td class="bt_info_even" >在帐库存</td>
		<td class="bt_info_odd" >已调配</td>
		<td class="bt_info_even" >本次调配</td>
		<td class="bt_info_odd" >可重复库存</td>
		<td class="bt_info_even" >已调配</td>
		<td class="bt_info_odd" >本次调配</td>
		<!-- <td class="bt_info_odd" >调配状态</td> -->
		</tr>
</table>
</div>
<div id="tab_box_content1" class="tab_box_content" >
			<wf:startProcessInfo   title=""/>
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
	var plan_invoice_id = "";
	var assign="";
	var submite_number="";
	var project_info_no="";//项目ID
	function refreshData(){
	//	var retObj=jcdpCallService("MatItemSrv", "getsuppliesDg", "ids=");
	//	debugger;
	//	var taskList = retObj.list;
	//	var id="";
	//	if(taskList!=null)
	//	if(taskList!=null&&taskList.length>1){
	//		for(var i =0; taskList!=null && i < taskList.length; i++){
	//			if(id==""){
	//				id=taskList[i].plan_invoice_id+"' ";
	//				}else{
	//					id=id+"  or plan_invoice_id='"+taskList[i].plan_invoice_id+"'";
	//					}
	//		}
	//		}
		
		var sql ="select t.compile_date,t.total_money,t.plan_invoice_id,t.submite_number,o.org_abbreviation org_name,u.user_name,p.project_name,t.plan_name,t.main_part,t.memo,p.project_info_no, decode(t.flat_type, '0', '未调配', '1', '调配中', '2', '调配完成','','未调配') status,decode(bzg.flat_type, '0', '未调配', '1', '调配中', '2', '调配完成','','未调配') type, t.plan_invoice_type from gms_mat_demand_plan_invoice t inner join p_auth_user u on t.creator_id=u.user_id and u.bsflag='0' inner join comm_org_information o on t.org_id=o.org_id and o.bsflag='0' inner join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' inner join (select distinct bz.plan_invoice_id,flat_type from GMS_MAT_DEMAND_PLAN_DETAIL t inner join GMS_MAT_DEMAND_PLAN_BZ bz on t.submite_number=bz.submite_number where outbound_org_id ='<%=user_org_id%>' ) bzg  on t.plan_invoice_id=bzg.plan_invoice_id   where t.plan_invoice_id in (select distinct bz.plan_invoice_id from GMS_MAT_DEMAND_PLAN_DETAIL t inner join GMS_MAT_DEMAND_PLAN_BZ bz on t.submite_number=bz.submite_number  where outbound_org_id ='<%=user_org_id%>') and t.assign_type='1' and t.plan_invoice_type !='物资供应'";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mateta/singleproject/suppliesAllocate/suppliesAllocateList.jsp";
		queryData(1);
	}
	//var projectInfoNo = '<%=projectInfoNo%>';
	function loadDataDetail(shuaId){
		var ids=shuaId.split(",");
		plan_invoice_id=ids[0];
		assign=ids[1];
		submite_number=ids[2];
		project_info_no=ids[3];
		for(var j =1;j <document.getElementById("taskTable")!=null && j < document.getElementById("taskTable").rows.length ;){
				document.getElementById("taskTable").deleteRow(j);
			}
			var retObj = jcdpCallService("MatItemSrv", "findAllocateList", "ids="+plan_invoice_id);
			var taskList = retObj.list;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				var wz_id			= taskList[i].wz_id;       //物资ID
				var wz_name     	= taskList[i].wz_name;	 //物资名称
				var wz_price    	= taskList[i].wz_price; //参考单价
				var wz_prickie 	 	=taskList[i].wz_prickie; //计量单位
				var demand_date 	= taskList[i].demand_date;  //需求日期
				var demand_num  	= taskList[i].demand_num;
				var plan_detail_id  = taskList[i].plan_detail_id;  //主键 
				var mat_num         = taskList[i].mat_num;              //调配数量
				var create_date     = taskList[i].create_date;          //创建时间
				var outbound_number = taskList[i].outbound_number;	//出库数量
				var submite_id      = taskList[i].submite_id;       //计划单号
				var stock_num  		= taskList[i].stock_num;         //在帐库存 
				var stock_num1  	= taskList[i].stock_num1;    //可重复库存
				var actual_price    = taskList[i].actual_price;
				var actual_price1   = taskList[i].actual_price1;
				var plan_num        = taskList[i].plan_num;
				var plan_num1       = taskList[i].plan_num1;
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
		        td.innerHTML = wz_name;
		        td.id=wz_id;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		        
		        td = newTR.insertCell(2);
				td.id=plan_detail_id;
		        td.innerHTML = wz_prickie;
		        td.className = tdClass+'_odd';
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
    		    td = newTR.insertCell(3);
  		        td.innerHTML = wz_price;
  		        td.id=project_info_no;
  		        //debugger;
  		        td.className =tdClass+'_even'
  		      	if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
  		        
  		        td = newTR.insertCell(4);
  				
  		        td.innerHTML = demand_date;
  		        td.className = tdClass+'_odd';
  		        if(autoOrder%2==0){
  					td.style.background = "#f6f6f6";
  				}else{
  					td.style.background = "#e3e3e3";
  				}
  		        td = newTR.insertCell(5);
		        td.innerHTML = demand_num;
		        //debugger;
		        td.className =tdClass+'_even'
		        if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
		      td = newTR.insertCell(6);
			if(stock_num>0){
				td.innerHTML =stock_num;
				}else{
					 td.innerHTML = "—";
					}
	        td.id=actual_price;
			
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}

			td = newTR.insertCell(7);
			if(plan_num==0){
				td.innerHTML = "—";   
				}else{
					td.innerHTML = plan_num;   
					}
			td.id= plan_num;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
			td = newTR.insertCell(8);   
			if(stock_num==0||demand_num-plan_num<=0||parseInt(plan_num1,10)+parseInt(plan_num,10)==parseInt(demand_num,10)){
				 td.innerHTML = "—";
	        }else{
				var input = document.createElement("input");
				input.id="pingku_number"
				input.value="0";
				input.style.width="25px";
				input.onkeyup=function(){
					var re = /^[0-9]+\.?[0-9]*$/; 
				    if (!re.test(this.value))
				   {
					   this.value=0;
				       alert("请输入数字！");
				       return true;
				    }
				    debugger;
				    var abc=this.parentNode.parentNode.childNodes;
				    var value=parseInt(this.value,10);  //本次调配数量
				    var td_5=parseInt(abc[5].innerHTML,10); //需求数量
				    var td_6=parseInt(abc[6].innerHTML=="—"?0:abc[6].innerHTML,10); //在帐库存
				    var td_7=abc[7].id;			 //在帐已调配数量
					var td_10=abc[10].id;        //可重复已调配数量
					var input =abc[11].getElementsByTagName("input");  //可重复本次调配数量
					var input_number=0;
					if(input.length<=0){
						input_number=0;          
						}else{
							input_number=input[0].value;
							}
						var sum = parseInt(td_7,10)+parseInt(td_10,10)+parseInt(input_number,10); //在帐已调配+可重复已调配+可重复本次调配
						if(value>=td_5){
									if(td_5-sum>=0){
										if(value<td_6){
											this.value=td_5-sum;
											}else{
												if(td_5-sum==td_5){
													if(td_6>td_5){
														this.value=td_5;
														}else{
															this.value=td_6;
															}
													}else{
														this.value=td_5-sum;
														}
												}
										}else{
											this.value=0;
											}
							}else{
									if(td_5-sum>=value){
											if(value<=td_6){}else{this.value=td_6;}
										}else{
											this.value=td_5-sum;
											}
								}
					}
				td.appendChild(input);
			        }
	       
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
			td = newTR.insertCell(9);   
			if(stock_num1>0){
				td.innerHTML =stock_num1;
				}else{
					 td.innerHTML = "—";
					}
			td.id=actual_price1;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
			td = newTR.insertCell(10);
	        if(plan_num1==0){
				td.innerHTML = "—";   
				}else{
					td.innerHTML = plan_num1;   
					}
			td.id= plan_num1;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
			td = newTR.insertCell(11);  //实际金额
			if(stock_num1==0||stock_num1-plan_num1<=0||parseInt(plan_num1,10)+parseInt(plan_num,10)==parseInt(demand_num,10)){
					td.innerHTML = "—";
	        }else{
				var input = document.createElement("input");
				input.id="pingku_number"
				input.value="0";
				input.style.width="25px";
				input.onkeyup=function(){
					var re = /^[0-9]+\.?[0-9]*$/; 
				    if (!re.test(this.value))
				   {
					   this.value=0;
				       alert("请输入数字！");
				       return true;
				    }
				    debugger;
				    var abc=this.parentNode.parentNode.childNodes;
				    var value=parseInt(this.value,10);  //本次调配数量
				    var td_5=parseInt(abc[5].innerHTML,10); //需求数量
				    var td_6=parseInt(abc[9].innerHTML=="—"?0:abc[9].innerHTML,10); //在帐库存
				    var td_7=abc[7].id;			 //在帐已调配数量
					var td_10=abc[10].id;        //可重复已调配数量
					var input =abc[8].getElementsByTagName("input");  //在帐调配数量
					var input_number=0;
					if(input.length<=0){
						input_number=0;          
						}else{
							input_number=input[0].value;
							}
						var sum = parseInt(td_7,10)+parseInt(td_10,10)+parseInt(input_number,10); //在帐已调配+可重复已调配+可重复本次调配
						if(value>=td_5){
									if(td_5-sum>=0){
										if(value<td_6){
											this.value=td_5-sum;
											}else{
												if(td_5-sum==td_5){
													if(td_6>td_5){
														this.value=td_5;
														}else{
															this.value=td_6;
															}
													}else{
														this.value=td_5-sum;
														}
												}
										}else{
											this.value=0;
											}
							}else{
									if(td_5-sum>=value){
											if(value<=td_6){}else{this.value=td_6;}
										}else{
											this.value=td_5-sum;
											}
								}
					}
				td.appendChild(input);
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
		   //调配的状态
		 if(assign!="调配完成"){
			  //项目编号、单号
			 var project_info_ids=project_info_no+","+plan_invoice_id;
			 var plan_detail_id="";
			 var wz_list="";
			 var isboolean=true;
			 var ids = document.getElementById('rdo_entity_id').value;
			 var tdStr = document.getElementById("taskTable").getElementsByTagName("TR");
			 for(var i=1; i<tdStr.length; i++)
			 {
				debugger;
				 var wz_number =0; //总数 本次调配数、历史调配数  
				    var td= tdStr[i].getElementsByTagName("TD");
						if(plan_detail_id==""){
							plan_detail_id=td[2].id;
						}else{
							plan_detail_id+=","+td[2].id;
							}
				    
						var wz_id   = td[1].id;	  //需求申请主键
						if(wz_list==""){
							wz_list=wz_id;
							}else{
								wz_list+="@"+wz_id;
								}
						var number= td[8].getElementsByTagName("input")[0];   //专业化单位ORG_ID
						
						if(number!=undefined){
							wz_list+=","+number.value;
							wz_number+=parseInt(number.value,10);
							}else{
								wz_list+=","+0;
								wz_number+=0;
								}
						var actual_price =td[6].id;
						wz_list+=","+actual_price;
						
						var number1 = td[11].getElementsByTagName("input")[0]; 		//大港分中心出库数量
						if(number1!=undefined){
							wz_list+=","+number1.value;
							wz_number+=parseInt(number1.value,10);
						}else{
							wz_list+=","+0;
							wz_number+=0;
							}  
						var actual_price1 =td[9].id;
						wz_list+=","+actual_price1;
						//获取历史调配数量
						if(wz_number+parseInt(td[7].id,10)+parseInt(td[10].id,10)==parseInt(td[5].innerHTML,10)){
							}else{
								isboolean=false;
								}
						
						
						
						

						
			}			
				 		var type=jcdpCallService("MatItemSrv", "allocateList", "project_info_ids="+project_info_ids+"&wz_list="+wz_list);
						 if(isboolean){
							 	 jcdpCallService("MatItemSrv", "allocateType", "ids=2,"+plan_detail_id);
							 }else{
								 jcdpCallService("MatItemSrv", "allocateType", "ids=3,"+plan_detail_id);
							 }
				 		jcdpCallService("MatItemSrv", "allocateType", "ids=1,"+plan_invoice_id);
							 
			}else {
				
				alert("该计划已经调配完成");
				
				}
		 location.reload();
		
	 }
	

       
    		 
    		 
		    
		    
		   	
		     
			
			
</script>

</html>

