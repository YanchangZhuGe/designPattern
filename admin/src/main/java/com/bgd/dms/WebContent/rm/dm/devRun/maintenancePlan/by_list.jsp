<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>保养计划</title> 
 </head> 
 
 <body style="background:#cdddef" onload="searchDevData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			       <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_cdn_name">保养日期&nbsp;&nbsp;</td>
								<td style="width: 280px;"><input id="s_start_date"
									name="s_start_date" type="text" size="12" /><img
									src="<%=contextPath%>/images/calendar.gif" id="tributton1"
									width="16" height="16" style="cursor: hand;"
									onmouseover="calDateSelector(s_start_date,tributton1);" />
									&nbsp;至&nbsp; <input id="s_end_date" name="s_end_date"
									type="text" size="12" /><img
									src="<%=contextPath%>/images/calendar.gif" id="tributton2"
									width="16" height="16" style="cursor: hand;"
									onmouseover="calDateSelector(s_end_date,tributton2);" /></td>

			    
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>			          			
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSerach()'" title="过滤器"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>				
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr >	     
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{fk_dev_acc_id}' id='rdo_entity_id_{fk_dev_acc_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{plan_num}">已定保养计划次数</td>
<!-- 					<td class="bt_info_odd" exp="{plan_date}">保养时间</td> -->
			     </tr> 
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">保养计划</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">				
					<table id="planTab" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					   <tr>   
					      <td class="bt_info_odd">保养次序</td>
					      <td class="bt_info_even">计划保养时间</td>
					       <td class="bt_info_even">计划累计里程</td>
					       <td class="bt_info_even">计划工作小时</td>
					   </tr>	
					  <tbody id="assign_body"></tbody>
					</table>
				</div>
		 </div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
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
	cruConfig.cdtType = 'form';
	//下拉时查询
	function selectRefreshData(){
	    searchDevData();
	}
	function searchDevData(){
		var s_dev_name = document.getElementById("s_dev_name").value;
		var s_dev_model = document.getElementById("s_dev_model").value;
		var s_start_date = document.getElementById("s_start_date").value;
		var s_end_date = document.getElementById("s_end_date").value;
		refreshData(s_dev_name,s_dev_model,s_start_date,s_end_date);
	}
	 //清空查询条件
    function clearQueryText(){
		document.getElementById("s_dev_name").value="";
		document.getElementById("s_dev_model").value="";
		document.getElementById("s_start_date").value="";
		document.getElementById("s_end_date").value="";
    }
    function refreshData(s_dev_name,s_dev_model,s_start_date,s_end_date){
		var str = "select mp.fk_dev_acc_id,max(mp.plan_num) plan_num,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign from gms_device_maintenance_plan mp ";
		str+="left join gms_device_account acc on mp.fk_dev_acc_id = acc.dev_acc_id where acc.bsflag='0' and acc.owning_sub_id like '<%=orgSubId%>%'  ";
		if(s_dev_name!=undefined && s_dev_name!=''){
			str += "and acc.DEV_NAME like '%"+s_dev_name+"%' ";
		}
		if(s_dev_model!=undefined && s_dev_model!=''){
			str += "and acc.DEV_MODEL like '%"+s_dev_model+"%' ";
		}
		if(s_start_date!=undefined && s_start_date!=''){
			str += "and mp.plan_date >=to_date('"+s_start_date+"','yyyy/mm/dd') ";
		}
		if(s_end_date!=undefined && s_end_date!=''){
			str += "and mp.plan_date <=to_date('"+s_end_date+"','yyyy/mm/dd') ";
		}
		str +="group by fk_dev_acc_id,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
    }

	//打开新增界面
	 function toAdd(){   
		 popWindow("<%=contextPath%>/rm/dm/devRun/maintenancePlan/by_add.jsp",'950:480','-添加保养计划'); 
	 }

	 function toModify(){
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
		    	alert("请选择一条记录");
		 		return;
		    }
			popWindow("<%=contextPath%>/rm/dm/devRun/maintenancePlan/by_edit.jsp?ids="+ids,'950:480','-修改保养计划'); 
			
		}
	  //选择一条记录
	  function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");  
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else 
	             {obj[i].checked = true;  
	              checkvalue = obj[i].value;
	             } 
	        }   
	    }   
	
	  var selectedTagIndex = 0;
    //点击记录查询明细信息
    function loadDataDetail(shuaId){  
    	//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
	        for (i=0; i<obj.length; i++){   
	            obj[i].checked = false;
	        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+shuaId).attr("checked","checked");
    	if (shuaId != null) {
			var querySql="select mp.fk_dev_acc_id,mp.plan_date,mp.plan_num,acc.dev_name,acc.dev_model,mp.mileage,mp.work_hour, ";
			querySql+="acc.self_num,acc.license_num from gms_device_maintenance_plan mp  ";
			querySql+="left join gms_device_account acc on mp.fk_dev_acc_id = acc.dev_acc_id where acc.bsflag='0' ";
			querySql+="and fk_dev_acc_id ='"+shuaId+"' order by mp.plan_num ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj = queryRet.datas;
			var size = $("#assign_body", "#tab_box_content0").children("tr").size();
			if (size > 0) {
				$("#assign_body", "#tab_box_content0").children("tr").remove();
			}
			var jh_body1 = $("#assign_body", "#tab_box_content0")[0];
			if (retObj != undefined) {
				for (var i = 0; i < retObj.length; i++) {
					var columnsObj ;
					$("input[type='checkbox']", "#queryRetTable").each(function(){
						if(this.checked){
							columnsObj = this.parentNode.parentNode.cells;
						}
					});
					var newTr=jh_body1.insertRow();
					newTr.id=retObj[i].maintenance_id;
					var newTd1=newTr.insertCell();
					newTd1.innerText="第"+retObj[i].plan_num+"次保养";
					newTr.insertCell().innerText=retObj[i].plan_date;
					newTr.insertCell().innerText=retObj[i].mileage;
					newTr.insertCell().innerText=retObj[i].work_hour;
				}
			}
		}
		$("#assign_body>tr:odd>td:odd", '#tab_box_content0').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even", '#tab_box_content0').addClass("odd_even");
		$("#assign_body>tr:even>td:odd", '#tab_box_content0').addClass("even_odd");
		$("#assign_body>tr:even>td:even", '#tab_box_content0').addClass("even_even");

    }
	
    function toDelete(){
    	var ids = getSelIds('rdo_entity_id');
        if(ids==''){ 
        	alert("请选择一条记录");
     		return;
        }
      
    		if(confirm("是否执行删除操作?")){
    			var retObj = jcdpCallService("DevInsSrv", "delDeviceAccMaintenancePlan", "fkDevId="+ids);
    			queryData(cruConfig.currentPage);
    		}
    	
    }
    	 
	function searchRepairItem(){
		var queryRet = null;
		var  datas =null;		
		debugger;
		//手持机传的数据，是没有选中的选项存在表中
		querySql = "select * from BGP_COMM_DEVICE_REPAIR_TYPE t where t.repair_info='"+repair_info+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+encodeURI(encodeURI(querySql)));
 
		datas = queryRet.datas;
		if(datas != null&&datas!=""){		 
			var qzby = document.getElementsByName("qzby");
			for(var j=0;j<qzby.length;j++){
			 	qzby[j].checked=true;
				for(var i=0;i<datas.length;i++){
		  			if(qzby[j].value == datas[i].type_id){	
		  				qzby[j].checked=false;
		  			}
			 	}
			}	    		 
		}
	}	
 
 
 function showMatTreePage(){
	 var obj = new Object();
		var vReturnValue = window.showModalDialog('<%=contextPath%>/rm/dm/kkzy/selectMatList.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~',-1);
			var wz_id = returnvalues[0];
			var wz_name = returnvalues[1];
			document.getElementById("s_wz_name").value = wz_name;
			document.getElementById("s_wz_id").value = wz_id;
			}
	}

 function toSerach(){
		popWindow('<%=contextPath%>/rm/dm/devRun/maintenancePlan/by_search.jsp');
	}
 function popSearch(str){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = str;
		cruConfig.currentPageUrl = "/rm/dm/devRun/maintenancePlan/by_list.jsp";
		queryData(1);
	}
</script>
</html>