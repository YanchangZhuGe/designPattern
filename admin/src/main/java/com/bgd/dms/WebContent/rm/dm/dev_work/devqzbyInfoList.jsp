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
  <title>强制保养</title> 
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
			     
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{repair_info}' id='rdo_entity_id_{repair_info}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
						<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{repair_start_date}">保养日期</td>
					<td class="bt_info_odd" exp="{repair_detail}">修理详情</td>
					<td class="bt_info_odd" exp="{repair_start_date}">送修日期</td>
					<td class="bt_info_odd" exp="{repair_end_date}">竣工日期</td>
					<td class="bt_info_odd" exp="{work_hour}">工时</td>
					<td class="bt_info_odd" exp="{human_cost}">工时费</td>
					<td class="bt_info_odd" exp="{material_cost}">材料费</td>
					<td class="bt_info_odd" exp="{repairer}">承修人</td>
					<td class="bt_info_odd" exp="{accepter}">验收人</td>
				<!--	<td class="bt_info_odd" exp="{record_status}">单据状态</td> -->
			
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    	   <li id="tag3_2" ><a href="#" onclick="getTab3(2);">保养项目</a></li>
			   <li id="tag3_1" ><a href="#" onclick="getTab3(1);">消耗备件</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						     	<td class="inquire_item6">设备名称</td>
						    <td class="inquire_form6"><input id="dev_name" name="dev_name" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">规格型号</td>
						    <td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text"  readonly/></td>
						    <td class="inquire_item6">自编号</td>
						    <td class="inquire_form6"><input id="self_num" name="self_num" class="input_width" type="text"  readonly/></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">牌照号	</td>
						    <td class="inquire_form6"><input id="license_num" name="license_num" class="input_width" type="text" readonly /></td>
						    <td class="inquire_item6">修理类别</td>
						    <td class="inquire_form6"><input id="repairType" name="repairType" class="input_width" type="text"  readonly/></td>
						    <td class="inquire_item6">修理项目</td>
						    <td class="inquire_form6"><input id="repairItem" name="repairItem" class="input_width" type="text" readonly /></td>
						  </tr>
						   <tr>
						    <td class="inquire_item6">送修日期</td>
						    <td class="inquire_form6"><input id="REPAIR_START_DATE" name="REPAIR_START_DATE" class="input_width" type="text"  readonly/></td>
						    <td class="inquire_item6">竣工日期</td>
						    <td class="inquire_form6"><input id="REPAIR_END_DATE" name="REPAIR_END_DATE" class="input_width" type="text"  readonly/></td>
						    <td class="inquire_item6">工时</td>
						    <td class="inquire_form6"><input id="WORK_HOUR" name="WORK_HOUR" class="input_width" type="text" readonly/></td>
						  </tr>
						    <tr>
						      <td class="inquire_item6">工时费</td>
						    <td class="inquire_form6"><input id="HUMAN_COST" name="HUMAN_COST" class="input_width" type="text" readonly/></td>
						     <td class="inquire_item6">材料费</td>
						    <td class="inquire_form6"><input id="MATERIAL_COST" name="MATERIAL_COST" class="input_width" type="text" readonly/></td>
						    <td class="inquire_item6">承修人</td>
						    <td class="inquire_form6"><input id="REPAIRER" name="REPAIRER" class="input_width" type="text" readonly/></td>
						   
						  </tr>
						  <tr>
						   <td class="inquire_item6">验收人</td>
						    <td class="inquire_form6"><input id="ACCEPTER" name="ACCEPTER" class="input_width" type="text" readonly/></td>
						  </tr>
						  <tr>
						  <td class="inquire_item6" >修理详情</td>
			<td class="inquire_form6" colspan="3">
				<textarea id="REPAIR_DETAIL" name="REPAIR_DETAIL" rows="3" cols="60" class="textarea" readonly></textarea>
			</td>
						  </tr>
						               
			        </table>
				</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<table id="yzMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					    <tr>   
					    <td class="bt_info_even">序号</td>
				 	 <td class="bt_info_odd">计划单号</td>
				 	 <td class="bt_info_even">材料名称</td>
					  <td class="bt_info_odd">材料编号</td>
				   <td class="bt_info_even">计量单位</td>
				  <td class="bt_info_odd">单价</td>
				  <td class="bt_info_even">出库数量</td>
				  <td class="bt_info_odd">消耗数量</td>
				  <td class="bt_info_even">总价</td>	
					 </tr>	
					<tbody id="assign_body"></tbody>
				</table>
			</div>
			<div id="tab_box_content2" class="tab_box_content" style="display:none;">
						<table id="yzMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					    <tr>   
					    <td class="bt_info_even">序号</td>
				 	 <td class="bt_info_odd">保养项目</td>
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
		var str = "select info.*,account.dev_sign,account.dev_name,account.dev_model,account.self_num,account.license_num    from bgp_comm_device_repair_info info  LEFT JOIN GMS_DEVICE_ACCOUNT ACCOUNT on ACCOUNT.DEV_ACC_ID=INFO.DEVICE_ACCOUNT_ID ";
		str+=" where repair_level = '605' AND ACCOUNT.OWNING_SUB_ID LIKE '<%=orgSubId%>%' ";
		if(s_dev_name!=undefined && s_dev_name!=''){
			str += "and ACCOUNT.DEV_NAME like '%"+s_dev_name+"%' ";
		}
		if(s_dev_model!=undefined && s_dev_model!=''){
			str += "and ACCOUNT.DEV_MODEL like '%"+s_dev_model+"%' ";
		}
		if(s_start_date!=undefined && s_start_date!=''){
			str += "and info.repair_start_date >=to_date('"+s_start_date+"','yyyy/mm/dd') ";
		}
		if(s_end_date!=undefined && s_end_date!=''){
			str += "and info.repair_start_date <=to_date('"+s_end_date+"','yyyy/mm/dd') ";
		}
		str +=" order by repair_start_date desc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
    }

	//打开新增界面
	 function toAdd(){   
		 popWindow("<%=contextPath%>/rm/dm/dev_work/qzby.jsp",'950:580','-填写保养内容'); 
	 }

	 function toModify(){
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
		    	alert("请选择一条记录");
		 		return;
		    }
			var sql = "  select info.device_account_id from bgp_comm_device_repair_info info where info.repair_info='"+ids+"'";
			var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
		var dev_id;
			if(retObj!=null && retObj.returnCode=='0'){
				dev_id = retObj.datas[0].device_account_id;
			}
			popWindow("<%=contextPath%>/rm/dm/dev_work/qzby.jsp?ids="+dev_id+"&repair_info="+ids,'950:580','-修改保养内容'); 
			
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
    	var retObj;
		if(shuaId!=null){		     
			 retObj = jcdpCallService("DevInsSrv", "getRepairInfo", "repair_info="+shuaId);		
			 yzjl(shuaId);
			  byxm(shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("DevInsSrv", "getRepairInfo", "repair_info="+ids);
		     yzjl(ids);
		     byxm(ids);
		}
		
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
	        for (i=0; i<obj.length; i++){   
	            obj[i].checked = false;
	        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+retObj.deviceaccMap.repair_info).attr("checked","checked");
		//------------------------------------------------------------------------------------
		document.getElementById("dev_name").value =retObj.deviceaccMap.dev_name;
		document.getElementById("dev_model").value =retObj.deviceaccMap.dev_model;
		document.getElementById("self_num").value =retObj.deviceaccMap.self_num;
		document.getElementById("license_num").value =retObj.deviceaccMap.license_num;
		document.getElementById("repairType").value =retObj.deviceaccMap.repairtype;
		document.getElementById("repairItem").value =retObj.deviceaccMap.repairitem;
		document.getElementById("REPAIR_START_DATE").value =retObj.deviceaccMap.repair_start_date;
		document.getElementById("REPAIR_END_DATE").value =retObj.deviceaccMap.repair_end_date;
		document.getElementById("HUMAN_COST").value =retObj.deviceaccMap.human_cost;
		document.getElementById("MATERIAL_COST").value =retObj.deviceaccMap.material_cost;
		document.getElementById("REPAIRER").value =retObj.deviceaccMap.repairer;
		document.getElementById("ACCEPTER").value =retObj.deviceaccMap.accepter;	
		document.getElementById("WORK_HOUR").value =retObj.deviceaccMap.work_hour;
		document.getElementById("REPAIR_DETAIL").value =retObj.deviceaccMap.repair_detail;

    }
	
    function toDelete(){
    	var ids = getSelIds('rdo_entity_id');
        if(ids==''){ 
        	alert("请选择一条记录");
     		return;
        }
      
    		if(confirm("是否执行删除操作?")){
    			var retObj = jcdpCallService("DevCommInfoSrv", "deleteQZBY", "deviceId="+ids);
    			refreshData('','','','');
    		}
    	
    }
    
	 /**
		 * 消耗备件****************************************************************************************************************************
		 * @param {Object} shuaId
	*/
	function yzjl(shuaId){
		var retObj;
		
        var querySql = "select * from BGP_COMM_DEVICE_REPAIR_DETAIL d left join gms_mat_infomation i on d.material_coding=i.wz_id  where d.repair_info ='"+shuaId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			retObj= queryRet.datas;

		var size = $("#assign_body", "#tab_box_content1").children("tr").size();
		if (size > 0) {
			$("#assign_body", "#tab_box_content1").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content1")[0];
		if (retObj != undefined) {
			for (var i = 0; i < retObj.length; i++) {
				var columnsObj ;
				$("input[type='checkbox']", "#queryRetTable").each(function(){
					if(this.checked){
						columnsObj = this.parentNode.parentNode.cells;
					}
				});
				var newTr = by_body1.insertRow();
					
				var newTd = newTr.insertCell();
				newTd.innerText = i+1;
				var newTd1 = newTr.insertCell();
				newTd1.innerText = retObj[i].teammat_out_id;
				var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].material_name;
				var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].material_coding;
				newTr.insertCell().innerText=retObj[i].material_unit;
				newTr.insertCell().innerText=retObj[i].unit_price;
				newTr.insertCell().innerText=retObj[i].out_num;
				newTr.insertCell().innerText=retObj[i].material_amout;
				newTr.insertCell().innerText=retObj[i].total_charge;
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content1').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content1').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content1').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content1').addClass("even_even");
	}
		 
			function byxm(shuaId){
				var retObj;
				
		        var querySql = " select d.coding_name from COMM_CODING_SORT_DETAIL d where d.CODING_SORT_ID = '5110000159' and d.bsflag = '0' and d.coding_code_id not  in( ";
				querySql+="  select p.type_id from BGP_COMM_DEVICE_REPAIR_TYPE p where p.repair_info='"+shuaId+"')";
		        var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
					retObj= queryRet.datas;

				var size = $("#assign_body", "#tab_box_content2").children("tr").size();
				if (size > 0) {
					$("#assign_body", "#tab_box_content2").children("tr").remove();
				}
				var by_body1 = $("#assign_body", "#tab_box_content2")[0];
				if (retObj != undefined) {
					for (var i = 0; i < retObj.length; i++) {
						var columnsObj ;
						$("input[type='checkbox']", "#queryRetTable").each(function(){
							if(this.checked){
								columnsObj = this.parentNode.parentNode.cells;
							}
						});
						var newTr = by_body1.insertRow();
							
						var newTd = newTr.insertCell();
						newTd.innerText = i+1;
						var newTd1 = newTr.insertCell();
						newTd1.innerText = retObj[i].coding_name;
					}
				}
				$("#assign_body>tr:odd>td:odd",'#tab_box_content2').addClass("odd_odd");
				$("#assign_body>tr:odd>td:even",'#tab_box_content2').addClass("odd_even");
				$("#assign_body>tr:even>td:odd",'#tab_box_content2').addClass("even_odd");
				$("#assign_body>tr:even>td:even",'#tab_box_content2').addClass("even_even");
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


</script>
</html>