<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String devappid = request.getParameter("devAppId");
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
  <title>自有设备调配单列表</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='{device_app_detid}' name='{device_app_detid}'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_app_detid}' id='selectedbox_{device_app_detid}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_type}">设备型号</td>
					<td class="bt_info_even" exp="{apply_num}">申请数量</td>
					<td class="bt_info_odd" exp="{plan_start_date}">计划开始时间</td>
					<td class="bt_info_even" exp="{plan_end_date}">计划结束时间</td>
					<td class="bt_info_odd" exp="{out_org_name}">出库单位</td>
					<td class="bt_info_even" exp="{purpose}">备注</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">调配明细</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">设备编号</td>
							<td class="bt_info_odd" width="13%">自编号</td>
							<td class="bt_info_even" width="10%">实物标识号</td>
							<td class="bt_info_odd" width="13%">牌照号</td>
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
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
	var selectedTagIndex = 0;
	
	function appendDataToDetailTab(filterobj,datas){
			for(var i=0;i<basedatas.length;i++){
				var innerHTML = "<tr>";
				innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td>";
				innerHTML += "<td>"+datas[i].asset_coding+"</td><td>"+datas[i].self_num+"</td>";
				innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].license_num+"</td>";
				innerHTML += "</tr>";
				
				$(filterobj).append(innerHTML);
			}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}

	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function refreshData(){
		var str = "select d.*,org.org_abbreviation as out_org_name from gms_device_app_detail d left join comm_org_information org on d.dev_out_org_id=org.org_id where d.device_app_id='<%=devappid%>'";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	function dbclickRow(shuaId){
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			popWindow('<%=contextPath%>/rm/dm/devmixForm/devMixInfoFormNew.jsp?mixInfoId='+info[0]+'&devappid='+info[1],'1050:680');
		}
	}
	
    function chooseOne(cb){   
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }
    }   
    function loadDataDetail(shuaId){
    	var filtermapid = "#detailList";
    	var retObj;
    	var ids;
		if(shuaId!=null){
			ids = shuaId;
		}else{
			ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		}
		var prosql = "select ";
		prosql += "ci.dev_ci_name,ci.dev_ci_model, ";
		prosql += "amd.asset_coding,amd.self_num,amd.dev_sign,amd.license_num,org.org_abbreviation ";
		prosql += "from gms_device_appmix_detail amd ";
		prosql += "left join gms_device_appmix_main amm on amm.device_mix_subid=amd.device_mix_subid ";
		prosql += "left join gms_device_codeinfo ci on amd.dev_ci_code=ci.dev_ci_code ";
		prosql += "left join gms_device_account account on account.dev_acc_id=amd.dev_acc_id  ";
		prosql += "left join comm_org_information org on account.owning_org_id=org.org_id "
		prosql += "where amm.device_app_detid='"+shuaId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=1000');
		basedatas = queryRet.datas;
		appendDataToDetailTab(filtermapid,basedatas);
    }
</script>
</html>