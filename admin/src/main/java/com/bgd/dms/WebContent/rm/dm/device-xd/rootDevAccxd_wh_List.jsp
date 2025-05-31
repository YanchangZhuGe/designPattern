<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
    String code = request.getParameter("code");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>项目页面</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
<div id="list_table">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="s_dev_ci_name" name="s_dev_ci_name" type="text" onkeypress="simpleRefreshData()"/></td>
			    <td class="ali_cdn_name">在账状态</td>
			    <td class="ali_cdn_input">
			    	<select id="s_dev_ci_model" name="select" id="select"  class="select_width" onchange="selectRefreshData()">
     				 	<option value="">全部</option>
      					<option value="0">账内</option>
      					<option value="1">账外</option>
      					<option value="2">外租</option>
      				</select>
      			</td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="selectRefreshData()" title="JCDP_btn_query"></a></span>
			    </td>
      			 <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
      			
			    <td>&nbsp;</td>
				<auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
				<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
				<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
				
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
	</div>
	<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			      <tr >
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}'/>" >选择</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{stat_desc}">资产状况</td>
					<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{asset_coding}">资产编码</td>  
					<td class="bt_info_even" exp="{owning_org_name}">所属单位</td>
					<!--<td class="bt_info_odd" exp="{usage_org_name}">所在单位</td>
					<td class="bt_info_even" exp="{dev_position}">所在地</td>-->
					<td class="bt_info_odd" exp="{using_stat}">使用情况</td>
					<td class="bt_info_even" exp="{tech_stat}">技术状况</td>
					<!--<td class="bt_info_odd" exp="">设备负责人</td>
					<td class="bt_info_even" exp="{asset_value}">固定资产原值</td>
					<td class="bt_info_odd" exp="{net_value}">固定资产净值</td>
					<td class="bt_info_even" exp="">出厂日期</td>
					<td class="bt_info_odd" exp="">投产日期</td>
					<td class="bt_info_even" exp="">批次</td>  -->
					<td class="bt_info_odd" exp="{asset_value}">固定资产原值</td>
			     </tr> 
			  </table>
	</div>
	<div id="fenye_box"  style="display:block">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
		    	<li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li>
			  </ul>
	</div>
	
	<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<div style="overflow:auto">
			      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  	<tr align="right">
					  		<td class="ali_cdn_name" ></td>
					  		<td class="ali_cdn_input" ></td>
					  		<td class="ali_cdn_name" ></td>
					  		<td class="ali_cdn_input" ></td>
					  		<td>&nbsp;</td>
					    	<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
							<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
						</tr>
					  </table>
				  </div>
					<table id="educationMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						<tr>  
						<td class="bt_info_odd">选择</td>
					    <td class="bt_info_even">设备名称</td>
					    <td class="bt_info_odd">规格型号</td>
					    <td class="bt_info_even">自编号</td>
					    <td class="bt_info_odd">牌照号</td>
					    <td class="bt_info_even">修理类别</td>        
					    <td class="bt_info_odd">修理项目</td>
					    <td class="bt_info_even">修理详情</td>
					    <td class="bt_info_odd">送修日期</td>
					    <td class="bt_info_even">竣工日期</td>
					    <td class="bt_info_odd">工时费</td>
					    <td class="bt_info_even">材料费</td>
					    <td class="bt_info_odd">承修人</td>
					    <td class="bt_info_even">验收人</td>
					    <td class="bt_info_odd">单据状态</td>
					  </tr>
					  <tbody id="assign_body"></tbody>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
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
 
<script type="text/javascript"><!--

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var taskIds = '<%=taskId%>';
	var projectInfoNos = '<%=projectInfoNo%>';

	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
			var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
			refreshData();
		}
	}
	function selectRefreshData(){
	    var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
			var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
			refreshData();
	}
	function searchDevData(){
		var inp=$("#queryRetTable :checked");
		loadDataDetail(inp[0]);
	}
	function clearQueryText(){
		var v_dev_ci_name = document.getElementById("s_dev_ci_name");
		var v_dev_ci_model = document.getElementById("s_dev_ci_model")
		v_dev_ci_name.value="";
		v_dev_ci_model.value=""
	}
	//点击树节点查询
	var code = '<%=code%>';
	code = code.replace("S","");//点根节点时去除S,只有根节点带S
	function refreshData(arrObj){
		
		var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
		var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
		
		var str = "select dev_acc_id, dev_name,dev_model,dev_sign,self_num,license_num,asset_coding,owning_org_name,usage_org_name,dev_position,using_stat,tech_stat,asset_value,net_value,case account_stat when '0' then '账内' when '1' then '账外' else '外租' end as stat_desc from GMS_DEVICE_ACCOUNT_DUI t where t.bsflag='0' and dev_type like"+"'S"+code+"%' ";
		
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and dev_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and account_stat like '"+v_dev_ci_model+"%' ";
		}
		
		for(var key in arrObj) { 
			//alert(arrObj[key].label+arrObj[key].value);
			if(arrObj[key].value!=undefined && arrObj[key].value!='')
			str += "and "+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
		}
		
		cruConfig.queryStr = str;
		
		queryData(cruConfig.currentPage);
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		popWindow('<%=contextPath%>/doc/singleproject/doc_search.jsp');
	}
	//打开新增界面
	 function toAdd(){   
		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
	 	popWindow("<%=contextPath%>/rm/dm/device-xd/DEVICE_REPAIR_INFO.jsp?ids="+ids); 
	 	
	 }

    //修改界面
     function toEdit(obj){ 
     	if(obj==undefined){
     		obj=$("#assign_body :checked")[0].parentNode.parentNode;
     	}
     	var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
    	popWindow("<%=contextPath%>/rm/dm/device-xd/DEVICE_REPAIR_INFO.jsp?ids="+ids+"&repair_info="+obj.id); 
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
	
	
	function toSubmit() {	    
	//	popWindow('<%=contextPath%>/rm/singleHuman/humanRequest/submit_planModify.jsp?taskId=<%=taskId%>&projectInfoNo=<%=projectInfoNo%>');
		
		//jcdpCallService("HumanCommInfoSrv","submitHumanPlan","projectInfoNo=<%=projectInfoNo%>&procStatus=1");	
		alert("提交成功");
	}
	

    //chooseOne()函式，參數為觸發該函式的元素本身   
    /*function chooseOne2(cb){   
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
    }  */ 
	
    function loadDataDetail(obj){
    	var shuaId=obj;
    	$("#queryRetTable :checked").removeAttr("checked");
    	$("#rdo_entity_id_"+shuaId).attr("checked","checked");
    	var retObj;
		if(shuaId!=null){
		    
			//retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfoWh", "deviceId="+shuaId);
		
			var querySql="select (select coding_name from comm_coding_sort_detail where coding_code_id=a.REPAIR_TYPE)as repairtype,(select coding_name from comm_coding_sort_detail where coding_code_id=a.repair_item )as repairitem ,a.* from BGP_COMM_DEVICE_REPAIR_INFO a where a.DEVICE_ACCOUNT_ID= '"+shuaId+"' order by a.repair_start_date desc";
			//var querySql="select dev_acc_id, dev_name,dev_model,dev_sign,self_num,license_num,asset_coding,owning_org_name,usage_org_name,dev_position,using_stat,tech_stat,asset_value,net_value,case account_stat when '0' then '账内' when '1' then '账外' else '外租' end as stat_desc from GMS_DEVICE_ACCOUNT_DUI " ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			 retObj= queryRet.datas;
			
			var columnsObj = $("#queryRetTable  :checked")[0].parentNode.parentNode.cells;
			var str="";
			$("#assign_body tr").remove();
			
			for(var i=0;i<retObj.length;i++){
				var newTr=assign_body.insertRow()
				newTr.id=retObj[i].repair_info;
				newTr.onclick=function(){setGl(this);}
				//newTr.ondblclick=function(){toEdit();}
				newTr.insertCell().innerHTML="<input type=checkbox id=repair_info"+retObj[i].repair_info+" value="+retObj[i].repair_info+">"; 
				newTr.insertCell().innerText=columnsObj(1).innerText; 
				newTr.insertCell().innerText=columnsObj(2).innerText; 
				newTr.insertCell().innerText=columnsObj(5).innerText; 
				newTr.insertCell().innerText=columnsObj(6).innerText; 
				newTr.insertCell().innerText=retObj[i].repairtype;
				newTr.insertCell().innerText=retObj[i].repairitem;
				newTr.insertCell().innerText=retObj[i].repair_detail;
				newTr.insertCell().innerText=retObj[i].repair_start_date;
				newTr.insertCell().innerText=retObj[i].repair_end_date;
				newTr.insertCell().innerText=retObj[i].human_cost;
				newTr.insertCell().innerText=retObj[i].material_cost;
				newTr.insertCell().innerText=retObj[i].repairer;
				newTr.insertCell().innerText=retObj[i].accepter;
				newTr.insertCell().innerText=retObj[i].record_status;
				
			}
		}
		$("#assign_body>tr:odd>td:odd").addClass("odd_odd");
		$("#assign_body>tr:odd>td:even").addClass("odd_even");
		$("#assign_body>tr:even>td:odd").addClass("even_odd");
		$("#assign_body>tr:even>td:even").addClass("even_even");
    }
	
	function toDelete(){
 		ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteUpdate", "deviceId="+ids);
				queryData(cruConfig.currentPage);
			}

	}
  
   function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/device-xd/devquery.jsp');
    }      
	
--></script>
</html>