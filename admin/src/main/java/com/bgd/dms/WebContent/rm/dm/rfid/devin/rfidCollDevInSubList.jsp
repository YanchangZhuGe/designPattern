<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");
	String devicebackappid = request.getParameter("id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

  <title>已添加的返还明细页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_name" name="s_dev_ci_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_model" name="s_dev_ci_model" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jl" event="onclick='toSumbitDevApp()'" title="提交"></auth:ListButton>
			    <auth:ListButton functionId="" css="fh" event="onclick='javascript:window.history.back();'" title="返回"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_coll_backdet_id}~{dev_acc_id}' id='selectedbox_{device_coll_backdet_id}~{dev_acc_id}' leavinginfo='{isleaving}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{dev_unit_name}">单位</td>
					<td class="bt_info_odd" exp="{mix_num}">返还数量</td>
					<td class="bt_info_even" exp="{actual_in_time}">实际进场时间</td>
					<td class="bt_info_odd" exp="{devremark}">备注</td>
					<td class="bt_info_even" exp="{isleaving}">是否验收</td>
					<td class="bt_info_odd" exp="{alter_date}">验收时间</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <!-- <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">验收信息</a></li> -->
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getContentTab(this,3)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,4)">分类码</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,5)">明细数据</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="detailMap" name="detailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">设备名称：</td>
				      <td  class="inquire_form6" ><input id="dev_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">规格型号：</td>
				      <td  class="inquire_form6"><input id="dev_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;单位：</td>
				      <td  class="inquire_form6"  ><input id="dev_unit" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">返还数量：</td>
				     <td  class="inquire_form6"><input id="back_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     
				    
				     
				     <td  class="inquire_item6">实际进场时间：</td>
				     <td  class="inquire_form6"><input id="actual_in_time" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;实际离场时间：</td>
				     <td  class="inquire_form6"><input id="planning_out_time" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
							<td class="bt_info_even" width="11%">验收时间</td>
							<td class="bt_info_odd" width="11%">完好数量</td>
							<td class="bt_info_even" width="11%">维修数量</td>
							<td class="bt_info_odd" width="11%">毁损数量</td>
							<td class="bt_info_even" width="11%">盘亏数量</td>
				        </tr>
				        <tbody id="checkdetailMap" name="checkdetailMap" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				
				</div>
				<div id="tab_box_content3" name="tab_box_content2" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content4" name="tab_box_content3" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
							<td class="bt_info_even" width="10%">序号</td>
							<td class="bt_info_odd" width="30%">设备名称</td>
							<td class="bt_info_even" width="30%">设备型号</td>
							<td class="bt_info_odd" width="30%">实物标识号</td>
				        </tr>
				        <tbody id="inDataDet" name="inDataDet" ></tbody>
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
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		if(index == 1){
			//动态查询明细
			var currentid;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					currentid = this.value;
				}
			});
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = "select firm.good_num,firm.torepair_num,firm.tocheck_num,firm.destroy_num,firm.create_date as check_date ";
				str += "from gms_device_coll_account_firm firm ";
				str += "where firm.dev_dym_id='"+currentid+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#checkdetailMap";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#checkdetailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}
		
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			
			var innerHTML = "<tr>";
			innerHTML += "<td>"+datas[i].check_date+"</td><td>"+datas[i].good_num+"</td><td>"+datas[i].torepair_num+"</td>";
			innerHTML += "<td>"+datas[i].destroy_num+"</td><td>"+datas[i].tocheck_num+"</td>";
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
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';

	function searchDevData(){
		var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
		var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
		refreshData(v_dev_ci_name, v_dev_ci_model);
	}
	var isleaving="";
	function refreshData(v_dev_ci_name,v_dev_ci_model){
	
		var str = "select dui.dev_acc_id,t.device_coll_backdet_id,t.back_num as mix_num,dui.dev_name,dui.dev_model, case t.is_leaving when '0' then '未验收' when '1' then '已验收' end as isleaving, dui.dev_unit,dui.total_num,dui.unuse_num,dui.use_num,dui.actual_in_time,unitsd.coding_name as dev_unit_name,t.in_date as alter_date from gms_device_coll_back_detail t  left join gms_device_coll_account_dui dui on t.dev_acc_id2 = dui.dev_acc_id left join comm_coding_sort_detail unitsd on dui.dev_unit = unitsd.coding_code_id  where t.device_coll_mixinfo_id ='<%=devicebackappid%>' ";
		
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += " and dui.dev_name like '%"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += " and dui.dev_model like '%"+v_dev_ci_model+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		
	}
</script>
<script type="text/javascript">	
	//打开新增界面
	function toAddPage(){
		popWindow('<%=contextPath%>/rm/dm/collectDevBack/backdetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>&devicebackappid=<%=devicebackappid%>','900:680');
	}
	//打开修改界面
	function toModifyPage(){
		var length = 0;
		var selectedid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				selectedid = this.value;
				length = length+1;
			}
		});
		if(length!=1){
			alert("请选择一条记录！");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/collectDevBack/backdetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&devicebackappid=<%=devicebackappid%>&devicebackdetids='+selectedid,'950:680');
	}
	function dbclickRow(shuaId){
		//popWindow('<%=contextPath%>/rm/dm/collectDevBack/backdetail_modify_apply.jsp?projectInfoNo=<%=projectInfoNo%>&devicebackappid=<%=devicebackappid%>&devicebackdetids='+shuaId,'950:680');
		
		toSumbitDevApp();
	}
	function toDelRecord(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value.split("~")[0]+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		if(confirm("一共选择了"+length+"条记录，是否执行删除？")){
			var sql = "update gms_device_collbackapp_detail set bsflag='1' where device_backdet_id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("selectedbox");   
        for (var i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb){obj[i].checked = false;}
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else {obj[i].checked = true;}   
        }   
    }   

	function toSumbitDevApp(){
	  ids = getSelIds('selectedbox');
	  if(ids==''){  alert("请选择一条信息!");  return;  }  
	  //selId = ids.split('~')[0]; 
	  selId = ids;
	  //check的状态
	  var leavinginfo = $("input[type='checkbox'][name='selectedbox'][value='"+selId+"']").attr("leavinginfo");
	  
	  if(leavinginfo=="已验收"){
		alert("本设备已验收，请查看!");
	  	return;
	  }
	  var _t = ids.split('~');
	  selId = _t[0]; 
	  editUrl = "<%=contextPath%>/rm/dm/rfid/devin/rfidCollDevInSubmit.jsp?id="+selId+"&duiid="+_t[1];  
	  popWindow(editUrl);
	  
	}
	
	function loadDataDetail(device_backdet_id){
		//取消其他选中的 
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+device_backdet_id+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+device_backdet_id+"']").attr("checked",'checked');
		var retObj;
    	var devicebackdetid;
		if(device_backdet_id!=null){
			devicebackdetid = device_backdet_id.split("~")[0];
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    devicebackdetid = ids.split("~")[0];
		}
		var str = "select t.device_coll_backdet_id,t.back_num as mix_num,backdet.*, case t.is_leaving when '0' then '未验收' when '1' then '已验收' end as isleaving, account.dev_unit,account.total_num,account.unuse_num,account.use_num,account.actual_in_time,unitsd.coding_name as dev_unit_name from gms_device_coll_back_detail t left join gms_device_collbackapp_detail backdet on t.device_backdet_id = backdet.device_backdet_id left join gms_device_coll_account_dui account on backdet.dev_acc_id = account.dev_acc_id left join comm_coding_sort_detail unitsd on account.dev_unit = unitsd.coding_code_id ";
		str += "where t.device_coll_backdet_id ='"+devicebackdetid+"'";
		
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		$("#dev_name","#detailMap").val(retObj[0].dev_name);
		$("#dev_model","#detailMap").val(retObj[0].dev_model);
		$("#dev_unit","#detailMap").val(retObj[0].dev_unit_name);
		$("#back_num","#detailMap").val(retObj[0].mix_num);
		$("#total_num","#detailMap").val(retObj[0].total_num);
		$("#unuse_num","#detailMap").val(retObj[0].unuse_num);
		$("#use_num","#detailMap").val(retObj[0].use_num);
		
		$("#actual_in_time","#detailMap").val(retObj[0].actual_in_time);
		$("#planning_out_time","#detailMap").val(retObj[0].planning_out_time);
		isleaving = retObj[0].isleaving;
		
		//入库明细
		$("#inDataDet").empty();
		var innHtml = "";
		var d_ = jcdpCallService("DevCommInfoSrv", "getInDetBySubID", "id="+devicebackdetid);
		$.each(d_.rfidlist,function(i,k){
			var _index = i+1;
			var dev_name = !k.dev_name?'':k.dev_name;
			var dev_sign = !k.dev_sign?'':k.dev_sign;
			var dev_model = !k.dev_model?'':k.dev_model;
			innHtml = innHtml + "<tr><td>"+_index+"</td><td>"+dev_name+"</td><td>"+dev_model+"</td><td>"+dev_sign+"</td></tr>";
		});
		$("#inDataDet").html(innHtml);
		$("#inDataDet>tr:odd>td:odd").addClass("odd_odd");
		$("#inDataDet>tr:odd>td:even").addClass("odd_even");
		$("#inDataDet>tr:even>td:odd").addClass("even_odd");
		$("#inDataDet>tr:even>td:even").addClass("even_even");
		
		getContentTab(undefined,selectedTagIndex);
	}
	<%-- function loadDataDetail(device_backdet_id){
    	var retObj;
    	var devicebackdetid;
		if(device_backdet_id!=null){
			devicebackdetid = device_backdet_id;
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    devicebackdetid = ids.split("~")[0];
		}
		var str = "select t.device_coll_backdet_id,t.back_num as mix_num,backdet.*, case t.is_leaving when '0' then '未验收' when '1' then '已验收' end as isleaving, account.dev_unit,account.total_num,account.unuse_num,account.use_num,account.actual_in_time,unitsd.coding_name as dev_unit_name from gms_device_coll_back_detail t left join gms_device_collbackapp_detail backdet on t.device_backdet_id = backdet.device_backdet_id left join gms_device_coll_account_dui account on backdet.dev_acc_id = account.dev_acc_id left join comm_coding_sort_detail unitsd on account.dev_unit = unitsd.coding_code_id ";
		str += "where t.device_coll_backdet_id ='"+devicebackdetid+"'";
		
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		//取消其他选中的 
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_coll_backdet_id+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_coll_backdet_id+"']").attr("checked",'checked');
		$("#dev_name","#detailMap").val(retObj[0].dev_name);
		$("#dev_model","#detailMap").val(retObj[0].dev_model);
		$("#dev_unit","#detailMap").val(retObj[0].dev_unit_name);
		$("#back_num","#detailMap").val(retObj[0].mix_num);
		$("#total_num","#detailMap").val(retObj[0].total_num);
		$("#unuse_num","#detailMap").val(retObj[0].unuse_num);
		$("#use_num","#detailMap").val(retObj[0].use_num);
		
		$("#actual_in_time","#detailMap").val(retObj[0].actual_in_time);
		$("#planning_out_time","#detailMap").val(retObj[0].planning_out_time);
		isleaving = retObj[0].isleaving;
		getContentTab(undefined,selectedTagIndex);
    } --%>
</script>
</html>