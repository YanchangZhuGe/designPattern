<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
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

<title>采集设备出库单列表</title> 
</head>
 
<body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="s_project_name" name="s_project_name" type="text" /></td>
			    <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input"><input id="s_appinfo_name" name="s_appinfo_name" type="text" /></td>
			    <td class="ali_cdn_name">调配单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>
			    <td class="ali_cdn_name">出库单号</td>
			    <td class="ali_cdn_input"><input id="s_outinfo_no" name="s_outinfo_no" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddDetailPage()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyDetailPage()'" title="编辑"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportDataDoc()'" title="导出excel"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_outinfo_id_{device_outinfo_id}' name='device_outinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' device_outinfo_id='{device_outinfo_id}' outstate='{state}' value='{device_outinfo_id}~{device_mixinfo_id}' id='selectedbox_{device_outinfo_id}~{device_mixinfo_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_odd" exp="{device_app_name}">申请单名称</td>
					<td class="bt_info_even" exp="{device_app_no}">调配申请单号</td>
					<td class="bt_info_odd" exp="{mixinfo_no}">调配单号</td>
					<td class="bt_info_even" exp="{mix_date}">调配时间</td>
					<td class="bt_info_even" exp="{out_org_name}">转出单位</td>
					<td class="bt_info_odd" exp="{in_org_name}">接收单位</td>
					<td class="bt_info_odd" exp="{outstate_desc}">出库状态</td>
					<td class="bt_info_even" exp="{outinfo_no}">出库单号</td>
					<td class="bt_info_odd" exp="{employee_name}">经办人</td>
					<td class="bt_info_even" exp="{print_date}">出库时间</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			    <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">审批信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
				<td class="inquire_item6">项目名称</td>
				<td class="inquire_form6"><input id="dev_project_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">转出单位</td>
				<td class="inquire_form6"><input id="dev_out_org" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">转入单位</td>
				<td class="inquire_form6"><input id="dev_in_org" name="" class="input_width" type="text" /></td>
			  </tr>
				<tr>
				<td class="inquire_item6">出库单号</td>
				<td class="inquire_form6"><input id="dev_outinfo_no" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">开据人</td>
				<td class="inquire_form6"><input id="dev_print_emp" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">接收状态</td>
				<td class="inquire_form6"><input id="dev_state" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
							<td class="bt_info_even" width="5%">序号</td>
				    		<td class="bt_info_odd" width="10%">出库类别</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="11%">自编号</td>
							<td class="bt_info_odd" width="11%">牌照号</td>
							<td class="bt_info_even" width="11%">实物标识号</td>
							<td class="bt_info_odd" width="10%">出库数量</td>
							<td class="bt_info_even" width="13%">接收状态</td>
							<td class="bt_info_odd" width="7%">明细数据</td>
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
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
		//动态查询明细
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				currentid = this.value;
				currentid = currentid.split("~")[0];
			}
		});
		if(index == 1){
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				var searchkeyid = currentid.split("~", -1);
				currentid
				//先进行查询
				var prosql = "select cos.device_oif_subid,cos.device_outinfo_id,'1' as type,'' as self_num,'' as dev_sign,'' as license_num,'调配出库' as showtype,cos.device_name,cos.device_model,cos.out_num,cos.receive_state,";
				prosql += "case cos.receive_state when '0' then '未接收' when '1' then '接收完毕' when '9' then '接收中' when 'U' then '' else '异常状态' end as recstate_desc ";
				prosql += "from gms_device_coll_outsub cos ";
				prosql += "left join gms_device_coll_outform cof on cos.device_outinfo_id=cof.device_outinfo_id ";
				prosql += "where cof.device_outinfo_id='"+searchkeyid[0]+"'";
// 				prosql += "union (select '2' as type,'补充调配出库' as showtype,cos.device_name,cos.device_model,cos.out_num,cos.receive_state,";
// 				prosql += "case cos.receive_state when '0' then '未接收' when '1' then '接收中' when '9' then '接收完毕' when 'U' then '' else '异常状态' end as recstate_desc ";
// 				prosql += "from gms_device_coll_outsubadd cos ";
// 				prosql += "left join gms_device_coll_outform cof on cos.device_outinfo_id=cof.device_outinfo_id ";
// 				prosql += "where cof.device_outinfo_id='"+searchkeyid[0]+"' and device_mif_subid is not null) ";
				prosql += "union (select cos.device_oif_subid,cos.device_outinfo_id,'3' as type,'' as self_num,'' as dev_sign,'' as license_num,'补充出库' as showtype,cos.device_name,cos.device_model,cos.out_num,cos.receive_state,";
				prosql += "case cos.receive_state when '0' then '未接收' when '1' then '接收完毕' when '9' then '接收中' when 'U' then '' else '异常状态' end as recstate_desc ";
				prosql += "from gms_device_coll_outsubadd cos ";
				prosql += "left join gms_device_coll_outform cof on cos.device_outinfo_id=cof.device_outinfo_id ";
				prosql += "where cof.device_outinfo_id='"+searchkeyid[0]+"' and device_mif_subid is null) ";
				prosql += "union ";
				prosql += "(select eq.device_oif_detid,eq.device_outinfo_id,'3' as type,eq.self_num,eq.dev_sign,eq.license_num,'补充出库' as showtype,acc.dev_name as device_name,acc.dev_model as device_model, 1 as out_num,";
				prosql += "eq.state as receive_state,case eq.state when '1' then '接收中' ";
				prosql += "when '9' then '接收完毕' else '未接收' end as recstate_desc ";
				prosql += "from gms_device_equ_outdetail_added eq left join gms_device_account acc ";
				prosql += "on eq.dev_acc_id=acc.dev_acc_id ";
				prosql += "where eq.device_outinfo_id='"+searchkeyid[0]+"')";
				var queryRet = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}
		else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].showtype+"</td><td>"+datas[i].device_name+"</td>";
			innerHTML += "<td>"+datas[i].device_model+"</td><td>"+datas[i].self_num+"</td><td>"+datas[i].license_num+"</td><td>"+datas[i].dev_sign+"</td><td>"+datas[i].out_num+"</td><td>"+datas[i].recstate_desc+"</td><td><a href='#' onclick=loadDetList('"+datas[i].device_oif_subid+"','"+datas[i].device_outinfo_id+"')>查看明细</a></td>";
			innerHTML += "</tr>";
			
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}

	function loadDetList(subid,outid){
		window.showModalDialog("<%=contextPath%>/rm/dm/rfid/devout/rfidCollDevOutSubDetail.jsp",{'outid':outid,'subid':subid});
	}
	
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	
	function exportDataDoc(){
		//获得当前行的状态，如果不是已提交，那么不能打印
		var shuaId;
		var outstate;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				shuaId = this.value;
				outstate = this.outstate;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		if(outstate=='9' || outstate=='0'){
			
		}//if(outstate!='9')
			
		else{
			alert("本调配单状态不是'已调配'，不能打印!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			//调用打印方法
			var path = cruConfig.contextPath+"/rm/dm/common/DmDocToExcel.srq";
			var submitStr = "baseTableName=gms_device_coll_outform&baseid="+info[0]+"&subTableName=gms_device_coll_outsub";
			var retObj = syncRequest("post", path, submitStr);
			var filename=retObj.excelName;
			filename = encodeURI(filename);
			filename = encodeURI(filename);
			var showname=retObj.showName;
			showname = encodeURI(showname);
			showname = encodeURI(showname);
			window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
			//window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+retObj.excelName+"&showname="+retObj.showName;
		}else{
			alert("您尚未开据本申请单对应的调配单，请查看!");
			return;
		}
	}
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function searchDevData(){
		var v_appinfo_name = document.getElementById("s_appinfo_name").value;
		var v_mixinfo_no = document.getElementById("s_mixinfo_no").value;
		var v_outinfo_no = document.getElementById("s_outinfo_no").value;
		var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_appinfo_name, v_mixinfo_no, v_outinfo_no, v_project_name);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_appinfo_name").value="";
    	document.getElementById("s_mixinfo_no").value="";
		document.getElementById("s_outinfo_no").value="";
		document.getElementById("s_project_name").value="";
    }
    
	function refreshData(v_appinfo_name, v_mixinfo_no, v_outinfo_no, v_project_name){
		var str = "select cmf.device_mixinfo_id,cof.device_outinfo_id,cmf.mixinfo_no,cmf.modifi_date as mix_date,he.employee_name,tp.project_name,"
		+"inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,cof.outinfo_no,cof.modifi_date as print_date, " 
		+"collapp.device_app_no,collapp.device_app_name,"
		+"case cof.state when '0' then '出库中' when '9' then '已出库' else '待出库' end as outstate_desc,cof.state, "
		+"case cof.receive_state when '0' then '未接受' when '1' then '接收中' when '9' then '接收完毕' else '' end as recstate_desc "
		+"from gms_device_collmix_form cmf "
		+"left join gms_device_collapp collapp on cmf.device_app_id=collapp.device_app_id " 
		+"left join gp_task_project tp on cmf.project_info_no=tp.project_info_no " 
		+"left join comm_org_information inorg on cmf.in_org_id=inorg.org_id "
		+"left join comm_org_information outorg on cmf.out_org_id=outorg.org_id "
		+"left join gms_device_coll_outform cof on cof.device_mixinfo_id=cmf.device_mixinfo_id " 
		+"left join comm_human_employee he on cof.print_emp_id=he.employee_id "
		//加机构权限
		+"left join comm_org_subjection orgsub on cmf.out_org_id=orgsub.org_id and orgsub.bsflag='0' "
		+"where cmf.state='9' and cmf.bsflag='0' and (cof.devouttype is null or cof.devouttype = '1') and (cof.bsflag is null or cof.bsflag='0') ";
		//加机构权限
		str += "and orgsub.org_subjection_id like '<%=orgsubid%>%' ";
		if(v_appinfo_name!=undefined && v_appinfo_name!=''){
			str += "and collapp.device_app_name like '%"+v_appinfo_name+"%' ";
		}
		if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
			str += "and cmf.mixinfo_no like '%"+v_mixinfo_no+"%' ";
		}
		if(v_outinfo_no!=undefined && v_outinfo_no!=''){
			str += "and cof.outinfo_no like '%"+v_outinfo_no+"%' ";
		}
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and tp.project_name like '%"+v_project_name+"%' ";
		}
		str += " order by cof.state nulls first,cof.modifi_date desc,cmf.modifi_date desc,cmf.project_info_no ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	function toAddDetailPage(){
		var shuaId;
		var stat;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				shuaId = this.value;
				stat = this.outstate;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		if(stat=='9'){
			alert("已完成出库!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[1]!=''){
			popWindow('<%=contextPath%>/rm/dm/rfid/devout/rfidCollDevOutAdd.jsp?mixInfoId='+info[1],'950:680');
		}
	}
	function toModifyDetailPage(){
		var shuaId;
		var outstate;
		var device_outinfo_id;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				shuaId = this.value;
				outstate = this.outstate;
				device_outinfo_id = this.device_outinfo_id;
			}
		});
		if(!device_outinfo_id){
			alert("请先创建出库单!");
			return;
		}
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		if(outstate=='9'){
			alert("本出库单已提交，不能修改!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			popWindow('<%=contextPath%>/rm/dm/rfid/devout/rfidCollDevOutUpdate.jsp?outInfoId='+info[0]+'&mixInfoId='+info[1]+'&outid1='+device_outinfo_id,'970:680');
		}else{
			alert("您尚未开据本调配单对应的出库单，请查看!");
			return;
		}
	}
	function dbclickRow(shuaId){
		var info = shuaId.split("~" , -1);
		var outstate;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				outstate = this.outstate;
			}
		});
		if(outstate=='9'){
			alert("本出库单已提交，不能修改!");
			return;
		}
		if(info[0]!=''){
			popWindow('<%=contextPath%>/rm/dm/collDevOutForm/collDevOutInfoModify.jsp?outInfoId='+info[0]+'&mixInfoId='+info[1],'950:680');
		}else{
			popWindow('<%=contextPath%>/rm/dm/collDevOutForm/collDevOutInfoNew.jsp?mixInfoId='+info[1],'950:680');
		}
	}
	function toDelRecord(){
		//判断状态如果是已提交，那么不能删除,或者没建新纪录，不能删除
		var length = 0;
		var idinfo;
		var delflag = false;
		var addflag = 0;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				length = length+1;
				var curvalue = this.value;
				var outstate = this.outstate;
				var curvalues = curvalue.split("~",-1);
				if(curvalues[0]==''||outstate=='9'){
					delflag = true;
				}else{
					if(addflag==0){
						idinfo = curvalues[0];
					}else{
						idinfo += "~"+curvalues[0];
					}
					addflag ++;
				}
			}
		});
		if(length == 0){
			alert("请选择删除的记录！");
			return;
		}
		if(delflag){
			alert("您只能选择状态为'出库中'的记录删除!");
			return;
		}
		if(confirm("是否执行删除操作?")){
			var idinfos = idinfo.replace(/[~]/g,"','");
			idinfos = "'"+idinfos+"'";
			var sql = "update gms_device_coll_outform set bsflag='1' where device_outinfo_id in ("+idinfos+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
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
		var info = ids.split("~",-1);
		if(info[0]!=''){
			//根据ids去查找
			var str = "select cmf.device_mixinfo_id,cof.device_outinfo_id,cmf.mixinfo_no,cmf.modifi_date as mix_date,he.employee_name,tp.project_name,"
				+"inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,cof.outinfo_no,cof.modifi_date as print_date, " 
				+"collapp.device_app_no,collapp.device_app_name,"
				+"case cof.state when '0' then '出库中' when '9' then '已出库' else '待出库' end as outstate_desc,cof.state, "
				+"case cof.opr_state when '0' then '未接受' when '1' then '接收中' when '9' then '接收完毕' else '' end as recstate_desc "
				+"from gms_device_collmix_form cmf "
				+"left join gms_device_collapp collapp on cmf.device_app_id=collapp.device_app_id " 
				+"left join gp_task_project tp on cmf.project_info_no=tp.project_info_no " 
				+"left join comm_org_information inorg on cmf.in_org_id=inorg.org_id "
				+"left join comm_org_information outorg on cmf.out_org_id=outorg.org_id "
				+"left join gms_device_coll_outform cof on cof.device_mixinfo_id=cmf.device_mixinfo_id " 
				+"left join comm_human_employee he on cof.print_emp_id=he.employee_id "
				//加机构权限
				+"left join comm_org_subjection orgsub on cmf.out_org_id=orgsub.org_id and orgsub.bsflag='0' "
				+"where cmf.state='9' and cmf.bsflag='0' and (cof.devouttype is null or cof.devouttype = '1') and (cof.bsflag is null or cof.bsflag='0')"
				+" and cof.device_outinfo_id='"+info[0]+"'";
			var unitRet = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = unitRet.datas;
			//取消选中框--------------------------------------------------------------------------
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_outinfo_id+"~"+retObj[0].device_mixinfo_id+"']").attr("checked",'true');
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_outinfo_id+"~"+retObj[0].device_mixinfo_id+"']").removeAttr("checked");
			//------------------------------------------------------------------------------------
			$("#dev_project_name").val(retObj[0].project_name);
			$("#dev_outinfo_no").val(retObj[0].outinfo_no);
			$("#dev_in_org").val(retObj[0].in_org_name);
			$("#dev_out_org").val(retObj[0].out_org_name);
			$("#dev_print_emp").val(retObj[0].employee_name);
			$("#dev_create_date").val(retObj[0].create_date);
			$("#dev_state").val(retObj[0].recstate_desc);
		}else{
			//根据ids去查找 调配单
			var str = "select cmf.device_mixinfo_id,tp.project_name,inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name ";
				str += "from gms_device_collmix_form cmf  "
				+"left join gp_task_project tp on cmf.project_info_no=tp.project_info_no " 
				+"left join comm_org_information inorg on cmf.in_org_id=inorg.org_id "
				+"left join comm_org_information outorg on cmf.out_org_id=outorg.org_id "
				+"where cmf.bsflag='0' and cmf.device_mixinfo_id='"+info[1]+"'";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = unitRet.datas;
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_~"+retObj[0].device_mixinfo_id+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_~"+retObj[0].device_mixinfo_id+"']").attr("checked",'true');
			//选中这一条checkbox
			//------------------------------------------------------------------------------------
			$("#dev_project_name").val(retObj[0].project_name);
			$("#dev_outinfo_no").val(retObj[0].outinfo_no);
			$("#dev_in_org").val(retObj[0].in_org_name);
			$("#dev_out_org").val(retObj[0].out_org_name);
			$("#dev_print_emp").val("");
			$("#dev_create_date").val("");
			$("#dev_state").val("");
		}
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
</script>
</html>