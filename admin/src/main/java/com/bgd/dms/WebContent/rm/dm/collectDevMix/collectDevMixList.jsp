<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>采集设备调配单</title>
		<meta charset="utf-8" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
			rel="stylesheet" />
		<script src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script src="<%=contextPath%>/js/gms_list.js"></script>
		<script src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
		<script src="<%=contextPath%>/js/dialog_open1.js"></script>
	</head>

	<body style="background:#fff" onload="refreshData()">
		<div id="list_table">
			<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="6">
							<img src="<%=contextPath%>/images/list_13.png" width="6"
								height="36" />
						</td>
						<td background="<%=contextPath%>/images/list_15.png">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="ali_cdn_name">
										申请单单号
									</td>
									<td class="ali_cdn_input">
										<input id="device_app_no" name="device_app_no" type="text"
											class="input_width" />
									</td>
									<td class="ali_cdn_name">
										项目名称
									</td>
									<td class="ali_cdn_input">
										<input id="project_name" name="project_name" type="text"
											class="input_width" />
										<input id="project_info_no" name="project_info_no" type="hidden"/>
									</td>
									<td class="ali_query">
										<span class="cx"><a href="#"
											onclick="searchDevAppData()" title="查询"></a>
										</span>
									</td>
									<td class="ali_query">
										<span class="qc"><a href="#" onclick="clearQueryText()"
											title="清除"></a>
										</span>
									</td>
									<td>
										&nbsp;
									</td>
									<auth:ListButton functionId="" css="zj"
										event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
									<auth:ListButton functionId="" css="xg"
										event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
									<auth:ListButton functionId="" css="tj"
										event="onclick='toSubmit()'" title="JCDP_btn_edit"></auth:ListButton>
									<auth:ListButton functionId="" css="dc"
										event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
								</tr>
							</table>
						</td>
						<td width="4">
							<img src="<%=contextPath%>/images/list_17.png" width="4"
								height="36" />
						</td>
					</tr>
				</table>
			</div>
			<div id="table_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0"
					class="tab_info" id="queryRetTable">
					<tr>
						<td class="bt_info_even"
							exp="<input type='checkbox' name='selectedbox' value='{device_app_id}~{device_mixinfo_id}' id='selectedbox_{device_app_id}~{device_mixinfo_id}'  onclick='chooseOne(this);'/>">
							选择
						</td>
						<td class="bt_info_odd" exp="{device_app_no}">
							申请单单号
						</td>
						<td class="bt_info_even" exp="{device_app_name}">
							申请单名称
						</td>
						<td class="bt_info_odd" exp="{project_name}">
							项目名称
						</td>
						<td class="bt_info_odd" exp="{org_name}">
							组织机构
						</td>
						<td class="bt_info_odd" exp="{in_org_name}">
							转入单位
						</td>
						<td class="bt_info_even" exp="{mixinfo_no}">
							调配单号
						</td>
						<td class="bt_info_even" exp="{out_org_name}">
							转出单位
						</td>
						<td class="bt_info_even" exp="{state}">
							状态
						</td>
					</tr>
				</table>
			</div>
			<div id="fenye_box" style="display:block">
				<table width="100%" border="0" cellspacing="0" cellpadding="0"
					id="fenye_box_table">
					<tr>
						<td align="right">
							第1/1页，共0条记录
						</td>
						<td width="10">
							&nbsp;
						</td>
						<td width="30">
							<img src="<%=contextPath%>/images/fenye_01.png" width="20"
								height="20" />
						</td>
						<td width="30">
							<img src="<%=contextPath%>/images/fenye_02.png" width="20"
								height="20" />
						</td>
						<td width="30">
							<img src="<%=contextPath%>/images/fenye_03.png" width="20"
								height="20" />
						</td>
						<td width="30">
							<img src="<%=contextPath%>/images/fenye_04.png" width="20"
								height="20" />
						</td>
						<td width="50">
							到
							<label>
								<input type="text" name="textfield" id="textfield"
									style="width:20px;" />
							</label>
						</td>
						<td align="left">
							<img src="<%=contextPath%>/images/fenye_go.png" width="22"
								height="22" />
						</td>
					</tr>
				</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
				<ul id="tags" class="tags">
					<li class="selectTag" id="tag3_0">
						<a href="#" onclick="getContentTab(this,0)">基本信息</a>
					</li>
					<li id="tag3_1">
						<a href="#" onclick="getContentTab(this,1)">明细信息</a>
					</li>
					<li id="tag3_2">
						<a href="#" onclick="getContentTab(this,2)">附件</a>
					</li>
					<li id="tag3_3">
						<a href="#" onclick="getContentTab(this,3)">审批明细</a>
					</li>
					<li id="tag3_4">
						<a href="#" onclick="getContentTab(this,4)">备注</a>
					</li>
					<li id="tag3_5">
						<a href="#" onclick="getContentTab(this,5)">分类码</a>
					</li>
				</ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0"
					class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0"
						cellspacing="0" class="tab_line_height" width="100%"
						style="margin-top:10px;background:#efefef">
						<tr>
							<td class="inquire_item6">
								申请单号
							</td>
							<td class="inquire_form6">
								<input id="device_app_no" class="input_width" type="text"
									value="" />
								&nbsp;
							</td>
							<td class="inquire_item6">
								申请单名称
							</td>
							<td class="inquire_form6">
								<input id="device_app_name" class="input_width" type="text"
									value="" />
								&nbsp;
							</td>
							<td class="inquire_item6">
								调配单号
							</td>
							<td class="inquire_form6">
								<input id="mixinfo_no" class="input_width" type="text" value="" />
								&nbsp;
							</td>
						</tr>
						<tr>
							<td class="inquire_item6">
								项目名称
							</td>
							<td class="inquire_form6">
								<input id="project_name" class="input_width" type="text"
									value="" />
								
								&nbsp;
							</td>
							<td class="inquire_item6">
								转入单位
							</td>
							<td class="inquire_form6">
								<input id="in_org_name" class="input_width" type="text" value="" />
								&nbsp;
							</td>
							<td class="inquire_item6">
								申请人
							</td>
							<td class="inquire_form6">
								<input id="employee_name" class="input_width" type="text"
									value="" />
								&nbsp;
							</td>
						</tr>
						<tr>
							<td class="inquire_item6">
								转出单位
							</td>
							<td class="inquire_form6">
								<input id="out_org_name" class="input_width" type="text"
									value="" />
								&nbsp;
							</td>
							<td class="inquire_item6">
								组织机构
							</td>
							<td class="inquire_form6">
								<input id="org_name" class="input_width" type="text" value="" />
								&nbsp;
							</td>
							<td class="inquire_item6">
								组织机构隶属
							</td>
							<td class="inquire_form6">
								<input id="org_subjection_name" class="input_width" type="text"
									value="" />
								&nbsp;
							</td>
						</tr>
						<tr>
							<td class="inquire_item6">
								状态
							</td>
							<td class="inquire_form6">
								<input id="state" class="input_width" type="text" value="" />
								&nbsp;
							</td>
							<td class="inquire_item6">
								开据人
							</td>
							<td class="inquire_form6">
								<input id="print_emp_name" class="input_width" type="text"
									value="" />
								&nbsp;
							</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo=""
					class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"
						class="tab_line_height" width="100%"
						style="margin-top:10px;background:#efefef">
						<tr class="bt_info">
							<td name="order_num" class="bt_info_even">
								序号
							</td>
							<td name="device_name" class="bt_info_odd">
								设备名称
							</td>
							<td name="device_model" class="bt_info_even">
								规格型号
							</td>
							<td name="device_slot_num" class="bt_info_odd">
								道数
							</td>
							<td name="device_num" class="bt_info_even">
								计划数量
							</td>
							<td name="mix_num" class="bt_info_odd">
								调配数量
							</td>
							<td name="unit_id" class="bt_info_even">
								计量单位
							</td>
						</tr>
						<tbody id="detailMap" name="detailMap"></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2"
					class="tab_box_content" style="display:none">

				</div>
				<div id="tab_box_content3" name="tab_box_content3"
					class="tab_box_content" style="display:none">
					<wf:startProcessInfo buttonFunctionId="F_OP_002" title="" />
				</div>
				<div id="tab_box_content4" name="tab_box_content2"
					class="tab_box_content" style="display:none">

				</div>
				<div id="tab_box_content5" name="tab_box_content2"
					class="tab_box_content" style="display:none">

				</div>
			</div>
		</div>
	</body>
	<script>
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
			var currentid ;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked == true){
					currentid = this.value;
				}
			});
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid == undefined){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				var sql = 	"SELECT device_mif_subid,\n" + 
							"       device_detsubid,\n" + 
							"       device_id,\n" + 
							"       device_name,\n" + 
							"       device_model,\n" + 
							"       device_slot_num,\n" + 
							"       device_num,\n" + 
							"       mix_num,\n" + 
							"       (SELECT cd.coding_name\n" + 
							"          FROM comm_coding_sort_detail cd\n" + 
							"         WHERE cd.coding_code_id = t.unit_id) AS unit_id\n" + 
							"  FROM gms_device_coll_mixsub t where t.device_mixinfo_id = '"+currentid+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
				var datas = queryRet.datas;
				var detailMap = "#detailMap";
				$(detailMap).empty();
				if(datas!=undefined && datas.length>=1){
					var names = $("td",".bt_info").map(function(){return $(this).attr('name')}).get();
					for(var i = 0 ,length = datas.length; i < length ;i++){
						var tr = $("<tr>"),data = datas[i];
						data["order_num"] = i+1;
						for(var j=0 , len =  names.length ; j< len ; j++){
							var td = $("<td>").text(data[names[j]]);
							tr.append(td);
						}
						$(detailMap).append(tr);
					}
				}
				$(detailMap+">tr:odd>td:odd").addClass("odd_odd");
				$(detailMap+">tr:odd>td:even").addClass("odd_even");
				$(detailMap+">tr:even>td:odd").addClass("even_odd");
				$(detailMap+">tr:even>td:even").addClass("even_even");
				$(filterobj).attr("idinfo",currentid);
			}
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	$(document).ready(lashen);
</script>

	<script>

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }
    function loadDataDetail(devMixinfoId){
    	return ;
    	var info = devMixinfoId.split("~"),
    		devMixinfoId = info[1],
    		devAppId = info[0],
    		retObj;
		if(devMixinfoId){
			 var sql = "SELECT t.bsflag,\n" +
					"       t.create_date,\n" + 
					"       t.creator_id,\n" + 
					"       t.device_app_id,\n" + 
					"       c.device_app_no,\n" + 
					"       c.device_app_name,\n" + 
					"       t.device_mixinfo_id,\n" + 
					"       t.in_org_id,\n" + 
					"       s.org_abbreviation  AS in_org_name,\n" + 
					"       t.mixinfo_no,\n" + 
					"       t.modifi_date,\n" + 
					"       t.org_id,\n" + 
					"       s2.org_abbreviation AS org_name,\n" + 
					"       t.org_subjection_id,\n" + 
					"       s3.org_abbreviation AS org_subjection_name,\n" + 
					"       t.out_org_id,\n" + 
					"       s1.org_abbreviation AS out_org_name,\n" + 
					"       t.print_emp_id,\n" + 
					"       (select pu.user_name from p_auth_user pu where pu.user_id = t.print_emp_id) as print_emp_name,\n"+
					"       t.project_info_no,\n" + 
					"       p.project_name,\n" + 
					"       t.search_mix_mainid,\n" + 
					"       case t.state when '0' then '未提交' else '已提交' end as state,\n" + 
					"       t.updator_id\n" + 
					"  FROM gms_device_collmix_form t\n" + 
					" INNER JOIN gms_device_collapp c\n" + 
					"    ON c.device_app_id = t.device_app_id\n" + 
					"  LEFT JOIN gp_task_project p\n" + 
					"    ON p.project_info_no = t.project_info_no\n" + 
					"  LEFT JOIN comm_org_information s\n" + 
					"    ON s.org_id = t.in_org_id\n" + 
					"  LEFT JOIN comm_org_information s1\n" + 
					"    ON s1.org_id = t.out_org_id\n" + 
					"  LEFT JOIN comm_org_information s2\n" + 
					"    ON s2.org_id = t.org_id\n" + 
					"  LEFT JOIN comm_org_information s3\n" + 
					"    ON s3.org_id = t.org_subjection_id where t.device_mixinfo_id = '"+devMixinfoId+"'";
			 retObj = jcdpQueryRecord(sql);
		}else{
			/*var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getMixAppBaseInfo", "deviceappid="+ids);*/
		}
		$("#selectedbox_"+devMixinfoId).attr("checked","checked");
		if(retObj.data){
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.data.device_mixinfo_id+"']").removeAttr("checked");
			for(var i in retObj.data){
				$('#'+i,'#projectMap').val(retObj.data[i]);
			}
		}
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }

	function searchDevAppData(){
		var device_app_no = document.getElementById("device_app_no").value;
		var project_name = document.getElementById("project_name").value;
		refreshData(device_app_no, project_name);
	}
	function clearQueryText(){
		document.getElementById("device_app_no").value = '';
		document.getElementById("project_name").value = '';
	}
	
	function refreshData(params){
		var project_info_id = '<%=user.getProjectInfoNo() == null ? "" : user.getProjectInfoNo()%>'
		var org_sub_id = '<%=user.getOrgSubjectionId() == null ? "" : user.getOrgSubjectionId()%>';
		var sql = " SELECT ga.device_app_no,ga.project_info_no,ga.device_app_id,gf.device_mixinfo_id,ga.device_app_name, p.project_name, ga.app_org_id,"+ 
				  " c.org_abbreviation AS app_org_name,c.org_abbreviation as in_org_name, gf.mixinfo_no, c1.org_abbreviation AS org_name,"+
				  " CASE WHEN gf.state IS NULL THEN '' WHEN gf.state = '9' THEN '已提交' ELSE '未提交' END AS state,"+
				  " gf.out_org_id, (SELECT c.org_abbreviation FROM comm_org_information c WHERE c.org_id = gf.out_org_id) AS out_org_name"+
				  " FROM gms_device_collapp ga LEFT JOIN gms_device_collmix_form gf ON gf.device_app_id = ga.device_app_id LEFT JOIN gp_task_project p"+
				  " ON ga.project_info_no = p.project_info_no LEFT JOIN comm_org_information c1 ON c1.org_id = ga.org_id"+
				  " LEFT JOIN comm_org_information c ON c.org_id = ga.app_org_id WHERE ga.state = '9' AND ga.bsflag = '0'"+
				  " AND ga.project_info_no = '"+project_info_id+"' AND ga.org_subjection_id LIKE '"+org_sub_id+"%'";
		if(typeof params == "object"){
			for(var i in params){
				sql += " and ga."+i+" like '"+params[i]+"%'";
			}
		}		
		cruConfig.queryStr = sql;
		queryData(cruConfig.currentPage);;
		$("#newTitleTable").hide();
		$("tr td input","#tab_box_content0").val('');
		$("li","#tag-container_3").removeClass("selectTag");
		$("#tag3_0").css("selectTag");
	}
	function dbclickRow(shuaId){
		var info = shuaId.split("~");
		var index = $("#queryRetTable").attr("selectedRow"),
			text = $("tr:eq("+index+") td:last-child","#queryRetTable").text();
		if("已提交" == text){
			alert("该调配单已经提交");
			return;
		}
		var tdValuesArrays = $("td:has(input[value='"+shuaId+"'])","#queryRetTable").siblings("td").map(function(){
			return $(this).text();
		}).get();
		var tdIdArrays = $("td[exp]","#queryRetTable").slice(1).map(function(elem, i, elem ){
			return $(this).attr('exp').replace(/[\{|\}]/ig,'');
		}).get();
		var urlParam = "";
		for(var i = 0 ; i< tdIdArrays.length ;i++){
			urlParam += ("&"+tdIdArrays[i]+"="+tdValuesArrays[i]);
		}
		urlParam += ("&project_info_no="+$("#project_info_no").val());
		var url = "<%=contextPath%>/rm/dm/collectDevMix/collectDevMixDetail.jsp?device_app_id="+info[0]+"&device_mixinfo_id="+info[1]+urlParam;
		popWindow(url,"950:680");

	} 
	function toAdd(){
		var url = "<%=contextPath%>/rm/dm/collectDevMix/toAdd.jsp";
		popWindow(url);
	}
	function toEdit(){
		
	}
	function toSubmit(){
		var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
		cruConfig.contextPath = '<%=contextPath%>';
		var deviceMixInfoId =  $("#queryRetTable").attr("selectedValue");
		if(deviceMixInfoId!=undefined){
			var sql = "update gms_device_collmix_form set state = '9' where device_mixinfo_id = '"+deviceMixInfoId+"'";
			var retObj = syncRequest("post",path,"sql="+sql+"&ids=");
			if(retObj.returnCode == "0"){
				alert("调配单提交成功!");
			}else{
				alert(retObj.returnMsg);
			}
			refreshData();
		}
	}
</script>
</html>
