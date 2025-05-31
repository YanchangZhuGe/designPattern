<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
	String s_opr_state_desc = request.getParameter("opr_state");
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
  <title>多项目-设备出库-设备出库(装备按量)</title> 
 </head> 
 
 <body style="background:#cdddef">
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
			    <!-- <td class="ali_cdn_name">出库单号</td>
			    <td class="ali_cdn_input"><input id="s_outinfo_no" name="s_outinfo_no" type="text" /></td> -->
			    <td class="ali_cdn_name">申请处理状态</td>
			    <td class="ali_cdn_input">
			    	<select id="s_opr_state_desc" name="s_opr_state_desc" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>
						<option value="0">未处理</option>
						<option value="1">处理中</option>
						<option value="9">已处理</option>
						<option value="4">已关闭</option>
			    	</select>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddDetailPage()'" title="出库"></auth:ListButton>
			    <!--<auth:ListButton functionId="" css="xg" event="onclick='toModifyDetailPage()'" title="编辑"></auth:ListButton>-->
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="关闭"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
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
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' mixstate='{opr_state}' value='{device_mixinfo_id}~{mix_type_id}' id='selectedbox_{device_mixinfo_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="<a onclick=viewProject('{project_info_no}')>{project_name}</a>">项目名称</td>					
					<td class="bt_info_odd" exp="{project_name}" isShow='Hide' >项目名称</td>
					<td class="bt_info_odd" exp="{device_app_name}">申请单名称</td>
					<td class="bt_info_even" exp="{device_app_no}">调配申请单号</td>
					<td class="bt_info_odd" exp="{mixinfo_no}">调配单号</td>
					<td class="bt_info_even" exp="{mix_date}">调配时间</td>
					<td class="bt_info_even" exp="{out_org_name}">转出单位</td>
					<td class="bt_info_odd" exp="{in_org_name}">接收单位</td>
					<td class="bt_info_odd" exp="{opr_state_desc}">处理状态</td>
					<td class="bt_info_odd" exp="<a onclick=viewMixedStore('{device_mixinfo_id}','{opr_state}')>查看</a>">出库单查看</td>
					<!-- <td class="bt_info_even" exp="{outinfo_no}">出库单号</td>
					<td class="bt_info_odd" exp="{employee_name}">经办人</td>
					<td class="bt_info_even" exp="{out_date}">出库时间</td> -->
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
				<td class="inquire_item6">申请单名称</td>
				<td class="inquire_form6"><input id="dev_devapp_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调配申请单号</td>
				<td class="inquire_form6"><input id="dev_mixinfo_no" name="" class="input_width" type="text" /></td>
			  </tr>
				<tr>
				<td class="inquire_item6">调配单号</td>
				<td class="inquire_form6"><input id="dev_devapp_no" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调配时间</td>
				<td class="inquire_form6"><input id="dev_mix_date" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">转出单位</td>
				<td class="inquire_form6"><input id="dev_outorg_name" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
				<td class="inquire_item6">接收单位</td>
				<td class="inquire_form6"><input id="dev_inorg_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">处理状态</td>
				<td class="inquire_form6"><input id="dev_oprstate_desc" name="" class="input_width" type="text" /></td>
			  </tr>
			  
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_even" width="5%">序号</td>
				    		<td class="bt_info_odd" width="11%">调配类别</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">调配数量</td>
							<td class="bt_info_odd" width="11%">备注</td>
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
		refreshData('','','<%=s_opr_state_desc%>');
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
		var mixtype;
		var info;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				currentid = this.value;
				info = currentid.split("~" , -1);
			}
		});
		if(index == 1){
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//var info = currentid.split("~" , -1);
				var prosql
				if(info[0]!=''){
					if(info[1] == 'S14059999'){
						prosql = "select '仪器附属' as showtype,appdet.dev_name as device_name,appdet.dev_type as device_model,amm.assign_num as mix_num,amm.devremark ";					
						prosql += "from gms_device_appmix_main amm ";
						prosql += "left join gms_device_codeinfo ci on ci.dev_ci_code=amm.dev_ci_code ";
						prosql += "left join gms_device_codetype ct on amm.dev_ci_code = ct.dev_ct_code ";
						prosql += "left join gms_device_app_detail appdet on amm.device_app_detid = appdet.device_app_detid ";
						prosql += "where amm.bsflag='0' and amm.assign_num is not null and amm.device_mixinfo_id='"+info[0]+"' ";
					}else{
						var prosql = "select type,showtype,device_name,device_model,mix_num,devremark from (";
						prosql += "select '1' as type,'调配明细' as showtype,cms.device_name,cms.device_model,cms.mix_num,cms.devremark ";
						prosql += "from gms_device_coll_mixsub cms ";
						prosql += "left join gms_device_collmix_form cmf on cmf.device_mixinfo_id=cms.device_mixinfo_id ";
						prosql += "where cmf.device_mixinfo_id='"+info[0]+"'";
						prosql += "union all select '2' as type,'补充明细' as showtype,device_name,device_model,mix_num,devremark ";
						prosql += "from gms_device_coll_mixsubadd ";
						prosql += "where device_mixinfo_id='"+info[0]+"') order by type";
					}	
					var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
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
				}else{
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/multiproject/common_doc_list_eps.jsp?relationId="+info[0]);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+info[0]);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+info[0]);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].showtype+"</td><td>"+datas[i].device_name+"</td>";
			innerHTML += "<td>"+datas[i].device_model+"</td><td>"+datas[i].mix_num+"</td><td>"+datas[i].devremark+"</td>";
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
			
		}else{
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
		var v_opr_state_desc = document.getElementById("s_opr_state_desc").value;
		var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_appinfo_name, v_mixinfo_no, v_opr_state_desc, v_project_name);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_appinfo_name").value="";
    	document.getElementById("s_mixinfo_no").value="";
		document.getElementById("s_opr_state_desc").value="";
		document.getElementById("s_project_name").value="";
    }
	
	function refreshData(v_appinfo_name, v_mixinfo_no, v_opr_state_desc, v_project_name){
		var str = "select * from ( select '' as mix_type_id,cmf.project_info_no,cmf.device_mixinfo_id,cmf.mixinfo_no,cmf.modifi_date as mix_date,tp.project_name,"
		+"inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name," 
		+"collapp.device_app_no,collapp.device_app_name,"
		+"cmf.opr_state,case cmf.opr_state when '1' then '处理中' when '9' then '已处理' when '4' then '已关闭' else '未处理' end as opr_state_desc "
		+"from gms_device_collmix_form cmf "
		+"left join gms_device_collapp collapp on cmf.device_app_id=collapp.device_app_id " 
		+"left join gp_task_project tp on cmf.project_info_no=tp.project_info_no " 
		+"left join comm_org_information inorg on cmf.in_org_id=inorg.org_id "
		+"left join comm_org_information outorg on cmf.out_org_id=outorg.org_id "
		//加机构权限
		+"left join comm_org_subjection orgsub on cmf.out_org_id=orgsub.org_id and orgsub.bsflag='0' "
		+"where cmf.state='9' and cmf.bsflag='0' "
		//加机构权限
		+"and orgsub.org_subjection_id like '<%=orgsubid%>%' "
		+"union all "
		+"select mix.mix_type_id,mix.project_info_no,mix.device_mixinfo_id,mix.mixinfo_no,mix.modifi_date as mix_date,"
	    +"pro.project_name,inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,devapp.device_app_no,devapp.device_app_name,"
	    +"mix.opr_state,case mix.opr_state when '1' then '处理中' when '9' then '已处理' when '4' then '已关闭' else '未处理' end as opr_state_desc "
		+"from gms_device_mixinfo_form mix left join gms_device_app devapp on mix.device_app_id = devapp.device_app_id left join gp_task_project pro on mix.project_info_no = pro.project_info_no "
		+"left join comm_org_information inorg on mix.in_org_id = inorg.org_id left join comm_org_information outorg on mix.out_org_id = outorg.org_id "
		+"left join comm_org_subjection orgsub on mix.out_org_id = orgsub.org_id and orgsub.bsflag = '0' "
		+"where mix.state = '9' and mix.bsflag = '0' and mix.mix_type_id = 'S14059999' "
		+"and orgsub.org_subjection_id like '<%=orgsubid%>%' ) where 1=1 ";
	    
		if(v_appinfo_name!=undefined && v_appinfo_name!=''){
			str += "and device_app_name like '%"+v_appinfo_name+"%' ";
		}
		if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
			str += "and mixinfo_no like '%"+v_mixinfo_no+"%' ";
		}
		if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
			if(v_opr_state_desc == '1'){//处理中
				str += "and opr_state = '1' ";
			}else if(v_opr_state_desc == '9'){//已处理
				str += "and opr_state = '9' ";
			}else if(v_opr_state_desc == '4'){//已关闭
				str += "and opr_state = '4' ";				
			}else if(v_opr_state_desc == '0'){//未处理
				str += "and opr_state = '0' ";				
			}						
		}
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and project_name like '%"+v_project_name+"%' ";
		}
		str += "order by opr_state nulls first,mix_date desc,project_info_no ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	function toAddDetailPage(){
		var shuaId;
		var mixstate;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				shuaId = this.value;
				mixstate = this.mixstate;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			if(info[1] == 'S14059999'){
				popWindow('<%=contextPath%>/rm/dm/collDevOutForm/insDevOutInfoNew.jsp?mixInfoId='+info[0]+'&oprstate='+mixstate,'1050:680');
			}else{
				popWindowAuto('<%=contextPath%>/rm/dm/collDevOutForm/collDevOutInfoNew.jsp?mixInfoId='+info[0]+'&oprstate='+mixstate,'1200:780');
			}
		}
	}
	function toModifyDetailPage(){
		var shuaId;
		var outstate;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				shuaId = this.value;
				outstate = this.outstate;
			}
		});
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
			popWindow('<%=contextPath%>/rm/dm/collDevOutForm/collDevOutInfoModify.jsp?outInfoId='+info[0]+'&mixInfoId='+info[1],'950:680');
		}else{
			alert("您尚未开据本调配单对应的出库单，请查看!");
			return;
		}
	}
	function dbclickRow(shuaId){
		var mixstate;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				mixstate = this.mixstate;
			}
		});
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			if(info[1] == 'S14059999'){
				popWindow('<%=contextPath%>/rm/dm/collDevOutForm/insDevOutInfoNew.jsp?mixInfoId='+info[0]+'&oprstate='+mixstate,'1050:680');
			}else{
				popWindowAuto('<%=contextPath%>/rm/dm/collDevOutForm/collDevOutInfoNew.jsp?mixInfoId='+info[0]+'&oprstate='+mixstate,'1200:780');
			}
		}
	}
	function toDelRecord(){
		//判断状态如果是已提交，那么不能删除,或者没建新纪录，不能删除
		var length = 0;
		var curvalue;
		var mixstate;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked==true){
				curvalue = this.value;
				mixstate = this.mixstate;
				length = length+1;
			}		
		});
		if(length == 0){
			alert("请勾选需要关闭的记录！");
			return;
		}
		if(mixstate == '9'){
			alert("'已处理'的记录不能关闭!");
			return;
		}
		if(mixstate == '4'){
			alert("调配申请单已关闭!");
			return;
		}
		var info = curvalue.split("~" , -1);
		var sql;
		if(confirm("是否执行关闭操作?")){
			
			if(info[1] == 'S14059999'){
				sql = "update gms_device_mixinfo_form set opr_state='4' where device_mixinfo_id = '"+info[0]+"' ";
			}else{
				sql = "update gms_device_collmix_form set opr_state='4' where device_mixinfo_id = '"+info[0]+"' ";
			}
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
		//alert(info);
		var str
		if(info[0]!=''){
			if(info[1] == 'S14059999'){
				str = "select pro.project_name,devapp.device_app_name,mix.mixinfo_no,devapp.device_app_no,mix.modifi_date as mix_date, "
					+"inorg.org_abbreviation  as in_org_name,outorg.org_abbreviation as out_org_name,"
					+"case mix.opr_state when '1' then '处理中' when '9' then '已处理' when '4' then '已关闭' else '未处理' end as opr_state_desc "
					+"from gms_device_mixinfo_form mix  "
					+"left join gms_device_app devapp on mix.device_app_id = devapp.device_app_id " 
					+"left join gp_task_project pro on mix.project_info_no = pro.project_info_no "
					+"left join comm_org_information inorg on mix.in_org_id = inorg.org_id "
					+"left join comm_org_information outorg on mix.out_org_id = outorg.org_id "
					+"where mix.state = '9' and mix.bsflag = '0' and mix.device_mixinfo_id='"+info[0]+"' ";
			}else{			
				str = "select tp.project_name,collapp.device_app_name,cmf.mixinfo_no,collapp.device_app_no,cmf.modifi_date as mix_date,"
					+"outorg.org_abbreviation as out_org_name,inorg.org_abbreviation  as in_org_name,"
					+"case cmf.opr_state when '1' then '处理中' when '9' then '已处理' when '4' then '已关闭' else '未处理' end as opr_state_desc "
					+"from gms_device_collmix_form cmf  "
					+"left join gms_device_collapp collapp on cmf.device_app_id = collapp.device_app_id " 
					+"left join gp_task_project tp on cmf.project_info_no = tp.project_info_no left join comm_org_information inorg on cmf.in_org_id = inorg.org_id "
					+"left join comm_org_information outorg on cmf.out_org_id = outorg.org_id "
					+"where cmf.state = '9' and cmf.bsflag='0' and cmf.device_mixinfo_id='"+info[0]+"'";
			}
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = unitRet.datas;
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+info[0]+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+info[0]+"']").attr("checked",'true');
			//选中这一条checkbox
			//------------------------------------------------------------------------------------
			$("#dev_project_name").val(retObj[0].project_name);
			$("#dev_devapp_name").val(retObj[0].device_app_name);
			$("#dev_mixinfo_no").val(retObj[0].mixinfo_no);
			$("#dev_devapp_no").val(retObj[0].device_app_no);
			$("#dev_mix_date").val(retObj[0].mix_date);
			$("#dev_outorg_name").val(retObj[0].out_org_name);
			$("#dev_inorg_name").val(retObj[0].in_org_name);
			$("#dev_oprstate_desc").val(retObj[0].out_org_name);
		}
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
    function viewMixedStore(id,state){
		if(state !='1' && state !='9' && state !='4'){
			alert("该单据尚未处理,暂不能查看出库单信息!");
		}else{		
			if(id != ''){
				//window.location.href='<%=contextPath%>/rm/dm/collectDevMixDantai/collDevMixedInfoList.jsp?devAppId='+id;							
				popWindow('<%=contextPath%>/rm/dm/collDevOutForm/collDevOutedInfoList.jsp?devMixId='+id,'1050:680');
			}			
		}			
	}
    function viewProject(projectNo){
		if(projectNo != ''){
			popWindow('<%=contextPath%>/rm/dm/project/viewProject.jsp?projectInfoNo='+projectNo,'1080:680');						
		}		
	}
</script>
</html>