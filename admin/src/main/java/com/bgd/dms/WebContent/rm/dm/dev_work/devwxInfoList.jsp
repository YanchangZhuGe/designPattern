<%@ page contentType="text/html;charset=UTF-8"%>
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
<meta http-equiv="Content-Type" content="text/html;" />
 <%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
  <title>项目页面</title> 
 </head> 
 
 <body style="background:#cdddef" onload="searchDevData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			       <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input" style="width:6%;"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <!-- <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_model" name="s_dev_model" type="text" /></td> -->
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input" style="width:6%;"><input id="s_license_num" name="s_license_num" type="text" /></td>
			    <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input" style="width:6%;"><input id="s_self_num" name="s_self_num" type="text" /></td>
			    <td class="ali_cdn_name">实物标识号</td>
			    <td class="ali_cdn_input" style="width:6%;"><input id="s_dev_sign" name="s_dev_sign" type="text" /></td>
			    <td class="ali_cdn_name">维修日期&nbsp;&nbsp;</td>
			<td class="ali_cdn_input">
				<input id="s_start_date"
									name="s_start_date" style="width:100px" class="input_width easyui-datebox" type="text" /> </td>
									<td>至</td><td > <input id="s_end_date" name="s_end_date"
									  style="width:100px" class="input_width easyui-datebox" type="text" /></td>

			    
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>			          			
			  <td class="ali_cdn_name">
			    	<a href="javascript:downloadModel('设备维修导入模板')">下载模板</a>
			    </td>  
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModify()'" title="JCDP_btn_edit"></auth:ListButton>
			        <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			   <auth:ListButton functionId="" css="dr" event="onclick='AddExcelData()'" title="导入excel"></auth:ListButton> 
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
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{repair_info}' id='rdo_entity_id_{repair_info}'   />" >选择</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{repairtype}">修理类别</td>
					<td class="bt_info_even" exp="{repairitem}">修理项目</td>
					<td class="bt_info_odd" exp="{repairlevel}">修理级别</td>
					<td class="bt_info_odd" exp="<a title='{repair_detail}' >{repair_detail1}</a>">修理详情</td>
					<td class="bt_info_odd" exp="{repair_start_date}">送修日期</td>
					<td class="bt_info_even" exp="{repair_end_date}">修复验收日期</td>
					<td class="bt_info_odd" exp="{human_cost}">工时费</td>
					<td class="bt_info_even" exp="{material_cost}">材料费</td>
					<td class="bt_info_odd" exp="{repairer}">承修人</td>
					<td class="bt_info_even" exp="{accepter}">修复验收人</td>
					<td class="bt_info_odd" exp="{record_status_desc}">单据状态</td>		
					<td class="bt_info_even" exp="{data_from_name}">数据来源</td>	
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
			   <li id="tag3_1" ><a href="#" onclick="getTab3(1);">消耗备件</a></li>
			    <li id="tag3_2" ><a href="#" onclick="getTab3(2);">附件</a></li>
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
						    <td class="inquire_item6">修理级别</td>
						    <td class="inquire_form6"><input id="repairLevel" name="repairLevel" class="input_width" type="text" readonly /></td>
						    <td class="inquire_item6">送修日期</td>
						    <td class="inquire_form6"><input id="REPAIR_START_DATE" name="REPAIR_START_DATE" class="input_width" type="text"  readonly/></td>
						    <td class="inquire_item6">修复验收日期</td>
						    <td class="inquire_form6"><input id="REPAIR_END_DATE" name="REPAIR_END_DATE" class="input_width" type="text"  readonly/></td>
						    
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
						  <td class="inquire_item6">修复验收人</td>
						  <td class="inquire_form6"><input id="ACCEPTER" name="ACCEPTER" class="input_width" type="text" readonly/></td>
						   <td class="inquire_item6">承修单位</td>
						  <td class="inquire_form6"><input id="REPAIR_POSTION" name="REPAIR_POSTION" class="input_width" type="text" readonly/></td>
						  </tr>
						  <tr>
							  <td class="inquire_item6" >检修内容</td>
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
				 	 	<td class="bt_info_even">材料名称</td>
					  	<td class="bt_info_odd">材料编号</td>
				   		<td class="bt_info_even">计量单位</td>
				  		<td class="bt_info_odd">单价</td>
				  		<td class="bt_info_odd">消耗数量</td>
				  		<td class="bt_info_even">总价</td>	
					 </tr>	
					<tbody id="assign_body"></tbody>
				</table>
			</div>	
			<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >1231</iframe>
			</div>
		 </div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
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
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_license_num = document.getElementById("s_license_num").value;
		var v_self_num = document.getElementById("s_self_num").value;
		var v_dev_sign = document.getElementById("s_dev_sign").value;
		var v_start_date = $("#s_start_date").datebox("getValue");
		var v_end_date = $("#s_end_date").datebox("getValue");
		refreshData(v_dev_name,v_license_num,v_self_num,v_dev_sign,v_start_date,v_end_date);
	}
	 //清空查询条件
    function clearQueryText(){
		document.getElementById("s_dev_name").value = "";
		document.getElementById("s_license_num").value = "";
		document.getElementById("s_self_num").value = "";
		document.getElementById("s_dev_sign").value = "";
		$("#s_start_date").datebox("setValue","");
		$("#s_end_date").datebox("setValue","");
    }
    function refreshData(v_dev_name,v_license_num,v_self_num,v_dev_sign,v_start_date,v_end_date){
		var str = " select substr(info.repair_detail,0,15) repair_detail1,info.*,case info.record_status when '1' then '修理完' when '0' then '修理中' else '修理完' end as record_status_desc,account.dev_name,"
				+ " case when datafrom='YD' then '手持机' when datafrom='SAP' then 'SAP' else '平台录入' end as data_from_name,"		
				+ " account.dev_model,account.self_num,account.license_num,account.dev_sign,(select coding_name from comm_coding_sort_detail where coding_code_id=info.repair_type)as repairtype,"
				+ " (select coding_name from comm_coding_sort_detail where coding_code_id=info.repair_item )as repairitem,(select coding_name from comm_coding_sort_detail"
				+ " where coding_code_id=info.repair_level)as repairlevel,nvl(info.datafrom,'wt') dataf from bgp_comm_device_repair_info info inner join gms_device_account account"
				+ " on account.dev_acc_id=info.device_account_id and account.bsflag='0' where info.bsflag='0' and repair_level <> '605' and (info.datafrom <> 'SAP' or info.datafrom is null) "
				+ " and account.owning_sub_id like '<%=orgSubId%>%'  "
				+ " and account.account_stat in ('0110000013000000003', '0110000013000000001', '0110000013000000006') "
				+ " and (account.dev_type like 'S06%' or account.dev_type like 'S07%' or account.dev_type like 'S08%' or account.dev_type like 'S09%' or account.dev_type like 'S1507%') ";
				
		if(v_dev_name!=undefined && v_dev_name!=''){
			str += "and account.dev_name like '%"+v_dev_name+"%' ";
		}
		if(v_license_num!=undefined && v_license_num!=''){
			str += "and account.license_num like '%"+v_license_num+"%' ";
		}
		if(v_self_num!=undefined && v_self_num!=''){
			str += "and account.self_num like '%"+v_self_num+"%' ";
		}
		if(v_dev_sign!=undefined && v_dev_sign!=''){
			str += "and account.dev_sign like '%"+v_dev_sign+"%' ";
		}
		if(v_start_date!=undefined && v_start_date!=''){
			str += "and info.repair_start_date >= to_date('"+v_start_date+"','yyyy/mm/dd') ";
		}
		if(v_end_date!=undefined && v_end_date!=''){
			str += "and info.repair_start_date <= to_date('"+v_end_date+"','yyyy/mm/dd') ";
		}
		str += " order by info.repair_start_date desc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
    }

	//打开新增界面
	 function toAdd(){   
		 popWindow("<%=contextPath%>/rm/dm/dev_work/DEVICE_REPAIR_INFO.jsp",'930:520',"-添加设备维修"); 
	 }

	 function toModify(){
		var ids = getSelIds('rdo_entity_id');
		if(ids==''){ 
		    alert("请选择一条记录");
		 	return;
		 }
		var sql = "select info.device_account_id,nvl(info.datafrom,'wt') dataf from bgp_comm_device_repair_info info where info.repair_info='"+ids+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
		var dev_id;
		var datafrom='1';
			if(retObj!=null && retObj.returnCode=='0'){
				dev_id = retObj.datas[0].device_account_id;
				datafrom=retObj.datas[0].dataf;
			}
			
			if(datafrom=='SAP'){
				alert("ERP系统导入数据，不允许修改！");return;
			}else{
				popWindow("<%=contextPath%>/rm/dm/dev_work/DEVICE_REPAIR_INFO.jsp?ids="+dev_id+"&repair_info="+ids,'950:520',"-修改设备维修"); 
			}	
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
			 $("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     $("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids);
		     retObj = jcdpCallService("DevInsSrv", "getRepairInfo", "repair_info="+ids);
		     yzjl(ids);
		   
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
		document.getElementById("repairLevel").value =retObj.deviceaccMap.repairlevel;
		document.getElementById("repairItem").value =retObj.deviceaccMap.repairitem;
		document.getElementById("REPAIR_START_DATE").value =retObj.deviceaccMap.repair_start_date;
		document.getElementById("REPAIR_END_DATE").value =retObj.deviceaccMap.repair_end_date;
		document.getElementById("HUMAN_COST").value =retObj.deviceaccMap.human_cost;
		document.getElementById("MATERIAL_COST").value =retObj.deviceaccMap.material_cost;
		document.getElementById("REPAIRER").value =retObj.deviceaccMap.repairer;
		document.getElementById("ACCEPTER").value =retObj.deviceaccMap.accepter;	
		document.getElementById("REPAIR_POSTION").value =retObj.deviceaccMap.repair_postion;	
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
				var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].material_name;
				var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].material_coding;
				newTr.insertCell().innerText=retObj[i].wz_prickie;
				newTr.insertCell().innerText=retObj[i].unit_price;
				newTr.insertCell().innerText=retObj[i].material_amout;
				newTr.insertCell().innerText=retObj[i].total_charge;
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content1').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content1').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content1').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content1').addClass("even_even");
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
	 function AddExcelData(){
		 	popWindow("<%=contextPath%>/rm/dm/dev_work/excelSbwxAdd.jsp");
	 }
		function downloadModel(filename){
			filename = encodeURI(filename);
			filename = encodeURI(filename);
			window.location.href="<%=contextPath%>/mat/singleproject/mattemplate/download.jsp?path=/pm/exportTemplate/dxm-sbwx.xlsx&filename="+filename+".xlsx";
		}
  function toDelete(){
    	var ids = getSelIds('rdo_entity_id');
        if(ids==''){ 
        	alert("请选择一条记录");
     		return;
        }
      
    		if(confirm("是否执行删除操作?")){
    			var retObj = jcdpCallService("DevInsSrv", "delDeviceRepair", "repair_info="+ids);
    			refreshData('','','','');
    		}
    	
    }
</script>
</html>