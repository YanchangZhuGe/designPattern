<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/gms4/js/calendar.js"></script>
<script type="text/JavaScript" src="/gms4/js/calendar-zh.js"></script>
<script type="text/javascript" src="/gms4/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="/gms4/css/calendar-blue.css" /> 

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>项目页面</title> 
  <style type="text/css">
.input_width2 {
	width:91.5%;
	height:20px;
	line-height:20px;
	border:1px solid #a4b2c0;
	float:left;
}
</style>
 </head> 
 
 <body style="background:#cdddef" onload="searchDevData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input"><input id="s_self_num" name="s_self_num" type="text" /></td>
			      <td class="ali_cdn_name">消耗备件</td>
			    <td class="ali_cdn_input" style="width:110px;">
			    	<input id="s_wz_name" name="s_wz_name" type="text" readonly/>
			    	<input id="s_wz_id" name="s_wz_id" type="hidden"  />
			    </td>
			    <td class="ali_cdn_input" style="width:50px;">
					<img src="/gms4/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showMatTreePage()"  />
			    </td>
			    
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>	
			    <td align="right">
			    <a  href="/gms4/mat/singleproject/mattemplate/download.jsp?path=/rm/dm/kkzy/bywx.xls&filename=bywx.xls">下载模板</a>
			    </td>
			    		          			
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyXgll()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelXgll()'" title="JCDP_btn_delete"></auth:ListButton>
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
			     <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{bywx_id}' id='rdo_entity_id_{bywx_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
						<td class="bt_info_even" exp="{self_num}">自编号</td>
					<td class="bt_info_odd" exp="{bywx_date}">日期</td>
					<td class="bt_info_odd" exp="{work_hours}">累计工作小时</td>
						<td class="bt_info_odd" exp="{falut_desc}">故障现象</td>
					<td class="bt_info_odd" exp="{falut_case}">故障解决办法</td>
					<td class="bt_info_odd" exp="{maintenance_level}">保养级别</td>
					<td class="bt_info_odd" exp="{legacy}">遗留问题</td>
					<!--  <td class="bt_info_odd" exp="{repair_unit}">承修单位</td>
					<td class="bt_info_odd" exp="{repair_men}">主修</td>-->
					<td class="bt_info_odd" exp="{bak}">备注</td>
			
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
			   <li id="tag3_1" ><a href="#" onclick="getTab3(1);loaddata('',1)">消耗备件</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    		<tr>
						    <td width="5%" align="right">自编号:</td>
						    <td  width="20%"><input id="self_num" name="self_num" class="input_width" type="text" /></td>
						    <td width="5%" align="right">累计工作小时:</td>
						    <td width="20%"><input id="work_hours" name="work_hours" class="input_width" type="text" /></td>
						    <td  width="5%" align="right">保养级别:	</td>
						    <td  width="20%"><input id="maintenance_level" name="maintenance_level" class="input_width" type="text" /></td>
						    <td width="5%" align="right">日期:</td>
						    <td width="20%"><input id="bywx_date" name="bywx_date" class="input_width" type="text" /></td>
						    
						    
						 </tr>
						 <tr>
					
						    <td align="right">故障现象:</td>
						    <td  colspan=3><input id="falut_desc" name="falut_desc" class="input_width2" type="text" /></td>
						    <td align="right">主要保养内容:</td>
						    <td colspan=3><input id="maintenance_desc" name="maintenance_desc" class="input_width2" type="text" /></td>
						  </tr>
						   <tr>
						   <td align="right">故障原因:</td>
						    <td  colspan=3><input id="falut_reason" name="falut_reason" class="input_width2" type="text" /></td>
						    <td align="right">承修单位:</td>
						    <td ><input id="repair_unit" name="repair_unit" class="input_width" type="text" /></td>
						     <td align="right">主修人:</td>
						    <td ><input id="repair_men" name="repair_men" class="input_width" type="text" /></td>
						    </tr>
						    <tr>
						    <td align="right">故障解决办法:</td>
						    <td   colspan=3><input id="falut_case" name="falut_case" class="input_width2" type="text" /></td>
						     <td align="right">遗留问题:</td>
						    <td  colspan=3><input id="legacy" name="legacy" class="input_width2" type="text" /></td>
						  </tr>
						    <tr>
						     <td align="right">主要总成件名称:</td>
						    <td ><input id="zcj_type" name="zcj_type" class="input_width" type="text" /></td>
						    <td align="right">性能描述:</td>
						    <td ><input id="performance_desc" name="performance_desc" class="input_width" type="text" /></td>
						   <td align="right">备注:</td>
						    <td  colspan=3><input id="bak" name="bak" class="input_width2" type="text" /></td>

						  </tr>
						  
						               
			        </table>
				</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<table id="yzMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					    <tr>   
					  
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">物料编码</td>
						<td class="bt_info_odd">序列号</td>
					    <td class="bt_info_even">物料名称</td>
					    <td class="bt_info_odd">单价</td>
						<td class="bt_info_even">计量单位</td>
						<td class="bt_info_odd">库存数量</td>
						<td class="bt_info_even">消耗数量</td>
						<td class="bt_info_odd">备件类别</td>
					 </tr>	
					<tbody id="assign_body"></tbody>
				</table>
			</div>
		
			<div id="tab_box_content9" class="tab_box_content" style="display:none;">
			
			</div>
			<div id="tab_box_content10" class="tab_box_content" style="display:none;">
				<table id="remarkTab" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">备注</td>
						    <td class="inquire_form6"><input id="dev_acc_remark" name=""  class="input_width" type="text" /></td>
						 </tr>
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
		var v_self_num = document.getElementById("s_self_num").value;
		var s_wz_id = document.getElementById("s_wz_id").value;
		refreshData(v_self_num,s_wz_id);
	}
	 //清空查询条件
    function clearQueryText(){
		document.getElementById("s_self_num").value="";
		document.getElementById("s_wz_id").value="";
		document.getElementById("s_wz_name").value="";
    }
    function refreshData(v_self_num,s_wz_id){
		var projectInfoNo='<%=projectInfoNo%>';
		var str = "";
		str+="";
		str+=" select    (case when l.bywx_type='0' then '更换' when l.bywx_type='1' then '维修' end) as bywx_type, (case when d.coding_name is null then '无' when d.coding_name is not null then d.coding_name end)  as zcj_type, l.bywx_id,l.bywx_date,l.work_hours,l.falut_desc,l.falut_case,l.maintenance_level,l.maintenance_desc, (case  when l.performance_desc = '0' then    '良好'    when l.performance_desc = '1' then '待修'  when l.performance_desc = '2' then '待查' end) as performance_desc,l.falut_reason, l.legacy,l.repair_unit,l.repair_men,l.bak, dui.self_num, dui.dev_acc_id  from gms_device_zy_bywx l  left join gms_device_account_dui dui on dui.dev_acc_id = l.dev_acc_id  left join comm_coding_sort_detail d on d.coding_code_id=l.zcj_type      where  l.project_info_id='"+projectInfoNo+"' and l.bsflag='0'";
		if(v_self_num!=undefined && v_self_num!=''){
			str += "and dui.self_num like '%"+v_self_num+"%' ";
		}
		if(s_wz_id!=undefined && s_wz_id!=''){
			str += "   and l.usemat_id in ( select mat.usemat_id from gms_device_zy_wxbymat mat where mat.wz_id='"+s_wz_id+"'  order by  create_date desc)  ";
		}
		
		str+="   order  by l.create_date desc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
	//打开新增界面
	 function toAdd(){   
	 	popWindow("<%=contextPath%>/rm/dm/kkzy/acceptLedgerAdd.jsp",'1024:800'); 
	 }

	 function toModifyXgll(){
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
		    	alert("请选择一条记录");
		 		return;
		    }
		    var temp = ids.split(",");
			var wz_ids = "";
			for(var i=0;i<temp.length;i++){
				if(wz_ids!=""){
					wz_ids += ","; 
				}
				wz_ids += "'"+temp[i]+"'";
			}
			popWindow('<%=contextPath%>/rm/dm/kkzy/acceptLedgerAdd.jsp?wx_ids='+wz_ids,'1350:680');
			
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
			 retObj = jcdpCallService("DevInsSrv", "getDevBywxInfo", "wx_id="+shuaId);		
			 yzjl(shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			   //alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("DevInsSrv", "getDevBywxInfo", "wx_id="+ids);
		     yzjl(ids);
		}
		
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
	        for (i=0; i<obj.length; i++){   
	            obj[i].checked = false;
	        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+retObj.deviceaccMap.bywx_id).attr("checked","checked");
		//------------------------------------------------------------------------------------
		document.getElementById("bywx_date").value =retObj.deviceaccMap.bywx_date;
		document.getElementById("work_hours").value =retObj.deviceaccMap.work_hours;
		document.getElementById("falut_desc").value =retObj.deviceaccMap.falut_desc;
		document.getElementById("falut_case").value =retObj.deviceaccMap.falut_case;
		document.getElementById("falut_reason").value =retObj.deviceaccMap.falut_reason;
		document.getElementById("maintenance_level").value =retObj.deviceaccMap.maintenance_level;
		document.getElementById("maintenance_desc").value =retObj.deviceaccMap.maintenance_desc;
		document.getElementById("performance_desc").value =retObj.deviceaccMap.performance_desc;
		document.getElementById("legacy").value =retObj.deviceaccMap.legacy;
		document.getElementById("repair_unit").value =retObj.deviceaccMap.repair_unit;
		document.getElementById("repair_men").value =retObj.deviceaccMap.repair_men;
		document.getElementById("bak").value =retObj.deviceaccMap.bak;		
		document.getElementById("self_num").value =retObj.deviceaccMap.self_num;
		document.getElementById("zcj_type").value =retObj.deviceaccMap.zcj_type;
    }
	
    function toDelXgll(){
    	var ids = getSelIds('rdo_entity_id');
        if(ids==''){ 
        	alert("请选择一条记录");
     		return;
        }
        var temp = ids.split(",");
    	var wz_ids = "";
    	for(var i=0;i<temp.length;i++){
    		if(wz_ids!=""){
    			wz_ids += ","; 
    		}
    		wz_ids += "'"+temp[i]+"'";
    	}
    		if(confirm("是否执行删除操作?")){
    			 retObj = jcdpCallService("DevInsSrv", "deletebywxInfo", "wx_ids="+wz_ids);
    			refreshData('');
    		}
    	
    }
	
    /**
	 * 延迟加载*****************************************************************************************************************************
	 * @param {Object} index
	 */
	function loaddata(ids,index){		
		 var ids = getSelIds('rdo_entity_id');
	        if(ids==''){ 
	        	//alert("请选择一条记录");
	     		return;
	        }

	}
	 /**
		 * 消耗备件****************************************************************************************************************************
		 * @param {Object} shuaId
	*/
	function yzjl(shuaId){
		var retObj;
		
        var querySql = "select info.wz_sequence,info.wz_id,info.actual_price,info.stock_num,i.wz_name,i.wz_prickie,mat.use_num,d.coding_name from gms_device_zy_wxbymat mat   left join gms_device_zy_bywx l on  l.usemat_id=mat.usemat_id ";
            querySql +=" left join gms_mat_recyclemat_info info on info.wz_id=mat.wz_id and info.bsflag='0'  and info.project_info_id='<%=projectInfoNo%>' ";
            querySql +=" left join comm_coding_sort_detail d on d.coding_code_id=mat.coding_code_id ";
            querySql +=" inner join(gms_mat_infomation i  inner join gms_mat_coding_code c on i.coding_code_id = c.coding_code_id ";
            querySql +=" and i.bsflag = '0' and c.bsflag = '0') on mat.wz_id=i.wz_id   where l.bywx_id='"+shuaId+"'	 ";
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
				newTd1.innerText = retObj[i].wz_id;
				var newTd2 = newTr.insertCell();
				newTd2.innerText = retObj[i].wz_sequence;
				var newTd3 = newTr.insertCell();
				newTd3.innerText = retObj[i].wz_name;
				newTr.insertCell().innerText=retObj[i].actual_price;
				newTr.insertCell().innerText=retObj[i].wz_prickie;
				newTr.insertCell().innerText='-';
				newTr.insertCell().innerText=retObj[i].use_num;
				newTr.insertCell().innerText=retObj[i].coding_name;
			
			}
		}
		$("#assign_body>tr:odd>td:odd",'#tab_box_content1').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content1').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content1').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content1').addClass("even_even");
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
			 popWindow("<%=contextPath%>/rm/dm/kkzy/excelBywxAdd.jsp");
			}
		

</script>
</html>