<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
	String projectType = user.getProjectType();
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>装备调配单列表(新)</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
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
			    <!-- <td class="ali_cdn_name">调配申请单号</td>
			    <td class="ali_cdn_input"><input id="s_appinfo_no" name="s_appinfo_no" type="text" /></td>
			    <td class="ali_cdn_name">调配单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td> -->
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
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddDetailPage()'" title="调配"></auth:ListButton>
			    <!--<auth:ListButton functionId="" css="xg" event="onclick='toAddDetailPage()'" title="修改"></auth:ListButton>
			    toModifyDetailPage -->
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
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_mixinfo_id_{device_mixinfo_id}' name='device_mixinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' mixstate='{opr_state}' value='{device_app_id}~{mix_type_id}' id='selectedbox_{device_app_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="<a onclick=viewProject('{project_info_no}')>{project_name}</a>">项目名称</td>
					<td class="bt_info_odd" isShow='Hide' exp="{project_name}">项目名称</td>
					<td class="bt_info_odd" exp="{device_app_name}">调配申请单名称</td>
					<td class="bt_info_even" exp="{device_app_no}">调配申请单号</td>
					<td class="bt_info_odd" exp="{app_org_name}">申请单位名称</td>
					<td class="bt_info_even" exp="{appdate}">申请时间</td>
					<td class="bt_info_odd" exp="{opr_state_desc}">处理状态</td>
					<td class="bt_info_even" exp="{mix_org_name}">调配单位</td>
					<!-- <td class="bt_info_even" exp="{mix_state_desc}">调配状态</td> -->
					<td class="bt_info_odd" exp="<a onclick=viewMixedStore('{device_app_id}','{opr_state}')>查看</a>">调配单查看</td>
					<!-- <td class="bt_info_even" exp="{mixinfo_no}">调配单号</td>
					<td class="bt_info_odd" exp="{out_org_name}">转出单位</td>
					<td class="bt_info_even" exp="{employee_name}">调配人</td>
					<td class="bt_info_odd" exp="{mix_date}">调配时间</td> -->
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
				<td class="inquire_form6"><input id="project_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调配申请单名称</td>
				<td class="inquire_form6"><input id="device_app_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调配申请单号</td>
				<td class="inquire_form6"><input id="device_app_no" name="" class="input_width" type="text" /></td>
			  </tr>
			   <tr>
			  <td class="inquire_item6">申请单位名称</td>
				<td class="inquire_form6"><input id="app_org_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">申请时间</td>
				<td class="inquire_form6"><input id="appdate" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">调配单位</td>
				<td class="inquire_form6"><input id="mix_org_name" name="" class="input_width" type="text" /></td>
			  </tr>
			  <tr>
			   <td class="inquire_item6">申请处理状态</td>
				<td class="inquire_form6"><input id="opr_state_desc" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_even" width="5%">序号</td>
				    		<td class="bt_info_odd" width="11%">明细类别</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">调配数量</td>
							<td class="bt_info_odd" width="11%">备注</td>
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">					
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>				
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
			    <div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
		 </div>
</div>
</body>
<script type="text/javascript">
var project_type="<%=projectType%>";
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
		var currentid;
		var currentid_tmp
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
				currentid_tmp = currentid.split("~" , -1);
				if(index == 3){
					$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid_tmp[0]);
				}else if(index == 4){
					$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid_tmp[0]);
				}else if(index == 5){
					$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid_tmp[0]);
				}else if(index == 2){					
					var device_app_id = currentid_tmp[0];
					var mixtypeid = currentid_tmp[1];
					var curbusinesstype = "";
					if(project_type == '5000100004000000008'){//井中
							if(mixtypeid == 'S0623'){
								curbusinesstype = "5110000004100001070";//装备震源单台
							}else{
								curbusinesstype = "5110000004100001062";//装备测量单台
							}
					}else{
							if(mixtypeid == 'S0623'){
								curbusinesstype = "5110000004100000069";//装备震源单台
							}else{
								curbusinesstype = "5110000004100000080";//装备测量单台
							}
					}
					//工作流信息
			    	processNecessaryInfo={        							//流程引擎关键信息
						businessTableName:"gms_device_app",    			//置入流程管控的业务表的主表表明
						businessType:curbusinesstype,    				//业务类型 即为之前设置的业务大类
						businessId:device_app_id           				//业务主表主键值
					};
					
					loadProcessHistoryInfo();
				}
			}			
		});
		
		if(index == 1){
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid == undefined || (currentid != undefined && idinfo == currentid)){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				var info = currentid.split("~" , -1);
				if(info[0]!=''){
					//先进行查询
// 					var prosql = "select type,showtype,dev_name,dev_model,assign_num,devremark from (";
// 					prosql += "select '1' as type,'调配明细' as showtype,";
// 					prosql += "case cms.isdevicecode when 'N' then ci.dev_ci_name else ct.dev_ct_name end as dev_name,";
// 					prosql += "case cms.isdevicecode when 'N' then ci.dev_ci_model else '' end as dev_model,cms.assign_num,cms.devremark ";
// 					prosql += "from gms_device_appmix_main cms ";
// 					prosql += "left join gms_device_codeinfo ci on cms.dev_ci_code=ci.dev_ci_code ";
// 					prosql += "left join gms_device_codetype ct on cms.dev_ci_code=ct.dev_ct_code ";
// 					prosql += "where cms.device_mixinfo_id='"+info[0]+"' and cms.assign_num is not null ";
// 					prosql += "union select '2' as type,'补充明细' as showtype,dev_name,dev_model,assign_num,devremark ";
// 					prosql += "from gms_device_appmix_added ";
// 					prosql += "where device_mixinfo_id='"+info[0]+"') order by type";
					
					var prosql = "select '调配明细' as showtype,";					
					prosql += "appdet.dev_name,appdet.dev_type as dev_model,nvl(appdet.apply_num,0) assign_num ";
					prosql += "from gms_device_app_detail appdet ";
					prosql += "left join gms_device_codeinfo ci ";
					prosql += "on ci.dev_ci_code=appdet.dev_ci_code ";
					prosql += "left join gms_device_codetype ct on appdet.dev_ci_code = ct.dev_ct_code ";
					//prosql += "left join ";
					//prosql += "(select device_app_detid,sum(assign_num) as mixed_num from gms_device_appmix_main amm ";
					//prosql += "where amm.bsflag='0' group by device_app_detid) tmp ";
					//prosql += "on tmp.device_app_detid = appdet.device_app_detid ";
					prosql += "left join comm_coding_sort_detail teamsd on teamsd.coding_code_id=appdet.team ";
					prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=appdet.unitinfo ";
					prosql += "where appdet.bsflag='0' and appdet.device_app_id='"+info[0]+"' ";
					
					//prosql += "union all select '补充明细' as showtype,dev_name,dev_model,assign_num  ";
					//prosql += "from gms_device_appmix_added bc ";
					//prosql += "where bc.device_mixinfo_id='"+currentid+"'";
					var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+'&pageSize=1000');
					basedatas = queryRet.datas;
					if(basedatas!=undefined && basedatas.length>=1){
						//先清空
						var filtermapid = "#detailList";
						$(filtermapid).empty();
						appendDataToDetailTab(filtermapid,basedatas);
						//设置当前标签页显示的主键
						$(filterobj).attr("idinfo",info[0]);
					}else{
						var filtermapid = "#detailList";
						$(filtermapid).empty();
						$(filterobj).attr("idinfo",info[0]);
					}
				}else{
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",info[0]);
				}
			}
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].showtype+"</td><td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td><td>"+datas[i].assign_num+"</td><td>"+""+"</td>";
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
		var mixstate;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				shuaId = this.value;
				mixstate = this.mixstate;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		if(mixstate!='9'){
			alert("本调配单状态不是'已调配'，不能打印!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			//调用打印方法
			var path = cruConfig.contextPath+"/rm/dm/common/DmDocToExcel.srq";
			var submitStr = "baseTableName=gms_device_mixinfo_form&baseid="+info[0]+"&baseid1="+info[1]+"&subTableName=gms_device_appmix_main";
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
		//var v_appinfo_no = document.getElementById("s_appinfo_no").value;
		var v_opr_state_desc = document.getElementById("s_opr_state_desc").value;
		var v_appinfo_name = document.getElementById("s_appinfo_name").value;
		var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_opr_state_desc, v_appinfo_name, v_project_name);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_opr_state_desc").value="";
    	document.getElementById("s_appinfo_name").value="";
		document.getElementById("s_project_name").value="";
    }
	
	function refreshData(v_opr_state_desc, v_appinfo_name, v_project_name){
		var str = "select devapp.mix_type_id,devapp.project_info_no,devapp.device_app_id,devapp.device_app_no,to_char(devapp.appdate, 'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
		+"tp.project_name,mixorg.org_abbreviation as mix_org_name,devapp.device_app_name,"
		+"case devapp.opr_state when '1' then '处理中' when '9' then '已处理' when '4' then '已关闭' else '未处理' end as opr_state_desc,devapp.opr_state "
		+"from gms_device_app devapp "
		+"left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id "
		+"left join gp_task_project tp on devapp.project_info_no=tp.project_info_no " 
		+"left join comm_org_information apporg on devapp.app_org_id=apporg.org_id "
		+"left join comm_org_information mixorg on devapp.mix_org_id=mixorg.org_id "
		//加机构权限
		+"left join comm_org_subjection orgsub on devapp.mix_org_id=orgsub.org_id and orgsub.bsflag='0' "
		+"where wfmiddle.proc_status='3' and devapp.bsflag='0' and devapp.mix_type_id != 'S0000' and devapp.mix_type_id !='S14050208' and devapp.mix_type_id !='S14059999' ";
		//加机构权限
		str += "and orgsub.org_subjection_id like '<%=orgsubid%>%' ";

		if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
			if(v_opr_state_desc == '1'){//处理中
				str += "and devapp.opr_state = '1' ";
			}else if(v_opr_state_desc == '9'){//已处理
				str += "and devapp.opr_state = '9' ";
			}else if(v_opr_state_desc == '4'){//已关闭
				str += "and devapp.opr_state = '4' ";				
			}else{//未处理
				str += "and ((devapp.opr_state != '1' and devapp.opr_state != '9' and devapp.opr_state != '4') or devapp.opr_state is null) ";
			}					
		}
		if(v_appinfo_name!=undefined && v_appinfo_name!=''){
			str += "and devapp.device_app_name like '%"+v_appinfo_name+"%' ";
		}
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and tp.project_name like '%"+v_project_name+"%' ";
		}
		str += "order by devapp.opr_state nulls first,devapp.modifi_date desc,devapp.project_info_no ";
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
			popWindow('<%=contextPath%>/rm/dm/collectDevMixDantai/collDevMixInfoNew.jsp?devappid='+info[0]+'&oprstate='+mixstate,'1080:680');
		}
	}
	function toModifyDetailPage(){
		var shuaId ;
		var mixstate ;
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
		if(mixstate=='9'){
			alert("本出库单已提交，不能修改!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			popWindow('<%=contextPath%>/rm/dm/collectDevMixDantai/collDevMixInfoModify.jsp?mixInfoId='+info[0]+'&devappid='+info[1],'1050:680');
		}else{
			alert("您尚未开据本调配单对应的出库单，请查看!");
			return;
		}
	}
	function dbclickRow(shuaId){
		var mixstate ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				mixstate = this.mixstate;
			}
		});
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			//collDevMixInfoModify.jsp
		//	popWindow('<%=contextPath%>/rm/dm/collectDevMixDantai/collDevMixInfoNew.jsp?mixInfoId='+info[0]+'&devappid='+info[1],'1050:680');
		//}else{
			popWindow('<%=contextPath%>/rm/dm/collectDevMixDantai/collDevMixInfoNew.jsp?devappid='+info[0]+'&oprstate='+mixstate,'1050:680');
		}
	}
	function toDelRecord(){

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
		if(confirm("是否执行关闭操作?")){
			var sql = "update gms_device_app set opr_state='4' where device_app_id = '"+info[0]+"' ";
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
			//根据ids去查找 申请单
			var str = "select devapp.device_app_name,devapp.mix_type_id,devapp.device_app_id,devapp.device_app_no,to_char(devapp.appdate,'yyyy-mm-dd') as appdate,"
			+"tp.project_name,apporg.org_abbreviation as app_org_name,mixorg.org_abbreviation as mix_org_name,"
			+"case devapp.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as opr_state_desc "
			+"from gms_device_app devapp "
			+"left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id "
			+"left join gp_task_project tp on devapp.project_info_no=tp.project_info_no " 
			+"left join comm_org_information apporg on devapp.app_org_id=apporg.org_id "
			+"left join comm_org_information mixorg on devapp.mix_org_id=mixorg.org_id "
			+"where wfmiddle.proc_status='3' and devapp.bsflag='0' and devapp.mix_type_id!='S0000' and devapp.device_app_id='"+info[0]+"'";
			
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = unitRet.datas;
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_app_id+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_app_id+"']").attr("checked",'true');
			//选中这一条checkbox
			//------------------------------------------------------------------------------------
			$("#project_name").val(retObj[0].project_name);
			$("#device_app_no").val(retObj[0].device_app_no);
			$("#device_app_name").val(retObj[0].device_app_name);
			$("#app_org_name").val(retObj[0].app_org_name);
			$("#appdate").val(retObj[0].appdate);
			$("#mix_org_name").val(retObj[0].mix_org_name);
			$("#mix_state_desc").val(retObj[0].mix_state_desc);
			$("#opr_state_desc").val(retObj[0].opr_state_desc);
		
		//var device_app_id = retObj[0].device_app_id;
		//var device_app_name = retObj[0].device_app_name;
		//var project_name = retObj[0].project_name;
		//var project_info_no = retObj[0].project_info_no;
		//var mixtypeid = retObj[0].mix_type_id;
		//var curbusinesstype = "";
		//if(project_type == '5000100004000000008'){//井中
			//if(mixtypeid == 'S0623'){
			//	curbusinesstype = "5110000004100001070";//装备震源单台
			//}else{
			//	curbusinesstype = "5110000004100001062";//装备测量单台
		//	}
		//}else{
		//	if(mixtypeid == 'S0623'){
		//		curbusinesstype = "5110000004100000069";//装备震源单台
		//	}else{
		//		curbusinesstype = "5110000004100000080";//装备测量单台
		//	}
		//}
		
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		//工作流信息		
	//	var submitdate =getdate();
    //	processNecessaryInfo={        							//流程引擎关键信息
		//	businessTableName:"gms_device_app",    			//置入流程管控的业务表的主表表明
		//	businessType:curbusinesstype,    				//业务类型 即为之前设置的业务大类
		//	businessId:device_app_id,           				//业务主表主键值
		//	businessInfo:"设备调配申请审批信息<设备调配申请单名称:"+device_app_name+">",
		//	applicantDate:submitdate       						//流程发起时间
		//};
		//processAppendInfo={ 
		//	projectName:project_name,									//流程引擎附加临时变量信息
		//	projectInfoNo:project_info_no,
		//	deviceappid:device_app_id
	//	};
	//	loadProcessHistoryInfo();
    }

    function viewMixedStore(id,state){
		if(state =='1' || state =='9' || state =='4'){
			if(state =='4'){
				var querySql = "select count(1) as app_num from gms_device_mixinfo_form mif ";
				querySql += "left join gms_device_app devapp on mif.device_app_id = devapp.device_app_id ";
				querySql += "where devapp.bsflag = '0' and (mif.bsflag is null or mif.bsflag = '0') and devapp.device_app_id = '"+id+"' ";
					
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
					basedatas = queryRet.datas;
				if(basedatas[0].app_num == 0){
					alert("该单据尚未调配,暂不能查看调配单信息!");
					return;
				}
			}
			if(id != ''){
				popWindow('<%=contextPath%>/rm/dm/collectDevMixDantai/collDevMixedInfoList.jsp?devAppId='+id,'1050:680');
			}			
		}else{
			alert("该单据尚未调配,暂不能查看调配单信息!");
			return;
			
		}		
	}
    function viewProject(projectNo){
		if(projectNo != ''){
			popWindow('<%=contextPath%>/rm/dm/project/viewProject.jsp?projectInfoNo='+projectNo,'1080:680');						
		}		
	}
    function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
</script>
</html>