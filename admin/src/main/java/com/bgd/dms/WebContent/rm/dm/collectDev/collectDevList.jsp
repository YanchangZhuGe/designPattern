<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>采集设备按台调配单管理</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" />
	</head>
	<body style="background:#fff">
		<div id="list_table">
			<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  		<tr>
			    		<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    		<td background="<%=contextPath%>/images/list_15.png">
			    			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  					<tr>
					    			<td class="ali_cdn_name">申请单名称</td>
					    			<td class="ali_cdn_input">
					    				<input id="s_device_app_name" name="s_device_app_name" coninfo="device_app_name" type="text" />
					    			</td>
					    			<td class="ali_cdn_name">申请单单号</td>
					    			<td class="ali_cdn_input">
					    				<input id="s_device_app_no" name="s_device_app_no" coninfo="device_app_no" type="text" />
					    			</td>
					    			<td class="ali_cdn_name">调配单单号</td>
					    			<td class="ali_cdn_input">
					    				<input id="s_mixinfo_no" name="s_mixinfo_no" coninfo="mixinfo_no" type="text" />
					    			</td>
					    			<td class="ali_query">
						    			<span class="cx">
						    				<a href="#" onclick="searchDevData()" title="查询"></a>
						    			</span>
					    			</td>
								    <td class="ali_query">
									    <span class="qc">
									    	<a href="#" onclick="clearQueryText()" title="清除"></a>
									    </span>
								    </td>
								    <td>&nbsp;</td>
								    <auth:ListButton functionId="" css="gl" event="onclick='toQuery()'" title="JCDP_btn_filter"></auth:ListButton>
								    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新增"></auth:ListButton>
								    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="编辑"></auth:ListButton>
								    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="删除"></auth:ListButton>
								    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="提交"></auth:ListButton>
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
			    	<tr>
				     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_app_id}~{device_mixinfo_id}' id='selectedbox_{device_app_id}~{device_mixinfo_id}' mix_state='{state}' issubmit={issubmit}  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
						<td class="bt_info_odd" autoOrder="1">序号</td>
						<td class="bt_info_even" exp="{project_info_name}">项目名称</td>
						<td class="bt_info_odd" exp="{device_app_no}">申请单号</td>
						<td class="bt_info_odd" exp="{device_app_name}">申请名称</td>
						<td class="bt_info_odd" exp="{app_org_name}">申请单位名称</td>
						<td class="bt_info_even" exp="{appdate}">申请时间</td>
						<td class="bt_info_odd" exp="{opr_state_desc}">申请处理状态</td>
						<td class="bt_info_even" exp="{mixinfo_no}">调配单号</td>
						<td class="bt_info_odd" exp="{state_name}">调配状态</td>
						<td class="bt_info_even" exp="{out_org_name}">转出单位</td>
						<td class="bt_info_odd" exp="{print_emp_name}">调配人</td>
						<td class="bt_info_even" exp="{modifi_date}">调配时间</td>
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
			      			</label>
			      		</td>
			    		<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  		</tr>
				</table>
			</div>
			<div id="tag-container_3">
				<ul id="tags" class="tags">
				    <li class="selectTag" id="tag3_0" >
				    	<a href="#" onclick="getContentTab(this,0)">基本信息</a>
				    </li>
				    <li id="tag3_1">
				    	<a href="#" onclick="getContentTab(this,1)">明细信息</a>
				    </li>
				    <li id="tag3_2">
				    	<a href="#" onclick="getContentTab(this,2)">审批信息</a>
				    </li>
				    <li id="tag3_3">
				   		<a href="#" onclick="getContentTab(this,3)">附件</a>
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
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  			<tr>
						<td class="inquire_item6">项目名称</td>
						<td class="inquire_form6"><input id="project_name" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">调配申请单号</td>
						<td class="inquire_form6"><input id="device_app_no" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">申请时间</td>
						<td class="inquire_form6"><input id="appdate" name="" class="input_width" type="text" /></td>
					  </tr>
					  <tr>
						<td class="inquire_item6">调配单位</td>
						<td class="inquire_form6"><input id="mix_org_name" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">调配状态</td>
						<td class="inquire_form6"><input id="mix_state_desc" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">转出单位</td>
						<td class="inquire_form6"><input id="out_org_name" name="" class="input_width" type="text" /></td>
					  </tr>
					  <tr>
						<td class="inquire_item6">调配单号</td>
						<td class="inquire_form6"><input id="mixinfo_no" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">调配人</td>
						<td class="inquire_form6"><input id="employee_name" name="" class="input_width" type="text" /></td>
						<td class="inquire_item6">调配时间</td>
						<td class="inquire_form6"><input id="mix_date" name="" class="input_width" type="text" /></td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    	
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
				</div>
			    <div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none">
				</div>
		 	</div>
		</div>
		<script>var _path = '<%=contextPath%>'</script>
		<script src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script src="<%=contextPath%>/js/gms_list.js"></script>
		<script src="<%=contextPath%>/js/dialog_open1.js"></script>
		<script>
			$(function() {
				init();
				$(window).resize(function() {
					setTabBoxHeight();
				});
			})
			function init() {
				cruConfig.contextPath =  _path;
				setTabBoxHeight();
				refreshData();
			}
			function refreshData(params) {
				var sql = 	"SELECT *\n" +
							"  FROM (SELECT (SELECT gp.project_name\n" + 
							"                  FROM gp_task_project gp\n" + 
							"                 WHERE gp.project_info_no = ga.project_info_no) AS project_info_name,\n" + 
							"               ga.project_info_no,\n" + 
							"               ga.device_app_no,ga.device_app_name,\n" + 
							"               ga.appdate,\n" + 
							"               (SELECT c.org_abbreviation\n" + 
							"                  FROM comm_org_information c\n" + 
							"                 WHERE c.org_id = ga.app_org_id) AS app_org_name,\n" + 
							"               ga.app_org_id,\n" + 
							"               gf.mixinfo_no,\n" + 
							"               CASE\n" + 
							"                 WHEN EXISTS\n" + 
							"                  (SELECT 1\n" + 
							"                         FROM gms_device_appmix_main gm,\n" + 
							"                              gms_device_app_detail  gd\n" + 
							"                        WHERE gm.device_app_detid = gd.device_app_detid\n" + 
							"                          AND gd.device_app_id = ga.device_app_id\n" + 
							"                          AND gm.bsflag = '0'\n" + 
							"                          AND gm.device_mixinfo_id = gf.device_mixinfo_id) THEN\n" + 
							"                  1\n" + 
							"                 ELSE\n" + 
							"                  0\n" + 
							"               END AS issubmit,\n" + 
							"               CASE\n" + 
							"                 WHEN gf.state IS NULL THEN\n" + 
							"                  ''\n" + 
							"                 WHEN gf.state = '9' THEN\n" + 
							"                  '已调配'\n" + 
							"                 ELSE\n" + 
							"                  '调配中'\n" + 
							"               END AS state_name,\n" + 
							"				CASE ga.opr_state\n" + 
							"                 WHEN '1' THEN\n" + 
							"                  '处理中'\n" + 
							"                 WHEN '9' THEN\n" + 
							"                  '已处理'\n" + 
							"                 ELSE\n" + 
							"                  '未处理'\n" + 
							"               END AS opr_state_desc,\n" + 
							"               gf.state,\n" + 
							"               (SELECT c.org_abbreviation\n" + 
							"                  FROM comm_org_information c\n" + 
							"                 WHERE c.org_id = gf.out_org_id) AS out_org_name,\n" + 
							"               gf.out_org_id,gf.modifi_date,\n" + 
							"               (SELECT u.employee_name\n" + 
							"                  FROM comm_human_employee u\n" + 
							"                 WHERE u.employee_id = ga.mix_user_id) AS mix_user_name,\n" + 
							"               gf.mix_user_id,\n" + 
							"               (SELECT u.employee_name\n" + 
							"                  FROM comm_human_employee u\n" + 
							"                 WHERE u.employee_id = gf.print_emp_id) AS print_emp_name,\n" + 
							"               gf.print_emp_id,\n" + 
							"               ga.device_app_id,\n" + 
							"               gf.device_mixinfo_id\n" + 
							"          FROM gms_device_app ga\n" + 
							"          LEFT JOIN common_busi_wf_middle mid\n" + 
							"            ON ga.device_app_id = mid.business_id\n" + 
							"          LEFT JOIN gms_device_mixinfo_form gf\n" + 
							"            ON ga.device_app_id = gf.device_app_id\n" + 
							"           AND gf.bsflag = '0'\n" + 
							"         WHERE ga.bsflag = '0'\n" + 
							"           AND ga.mix_type_id != 'S0000'\n" + 
							"           AND mid.proc_status = '3' order by gf.state nulls first,ga.project_info_no,gf.modifi_date desc)\n" + 
							" WHERE 1 = 1";
				if($.isPlainObject(params)){
					for(var i in params){
						sql += " and ("+i+" like '%"+params[i]+"%' or "+i+" is null)";
					}
				}
				cruConfig.queryStr = sql;
				queryData(cruConfig.currentPage);;
			}		
		</script>
		<script>
			function refreshDataParam(context){
				var params = {};
				$("input[id]","#"+context).each(function(){
					params[$(this).attr("coninfo")] = $(this).val();
				});
				return params;
			}
			function searchDevData() {
				var params = refreshDataParam("inq_tool_box");
				refreshData(params);
			}
			function clearQueryText() {
				document.getElementById("s_device_app_no").value = "";
				document.getElementById("s_mixinfo_no").value = "";
				document.getElementById("s_device_app_name").value = "";
			}
			function toQuery(){
				
			}
			function toAdd(){
				var info = checkClick();
				if(info !== false){
					info = info.split("~");
					popWindow(
					'<%=contextPath%>/rm/dm/collectDev/collectDevDetail.jsp?dev_app_id='+info[0]+'&dev_mix_id=','950:680'
					);
				}
			}
			function toEdit(){
				var info  = checkClick();
				if(info !== false){
					dbclickRow(info);
				}
			}
			
			function toDelete(){
				var info  = checkClick()
				if(info !== false){
					info = info.split("~");
					if(!info[1]){
						alert("请先为申请单分配调配单");
					}else{
						var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
						var sql = "update gms_device_mixinfo_form set bsflag = '1' where device_mixinfo_id = '"+info[1]+"'";
						var retObj = syncRequest("post",path,"sql="+sql+"&ids=");
						if(retObj.returnCode == "0"){
							alert("调配单删除成功");
							searchDevData();
						}else{
							alert(retObj.returnMsg);
						}
					}
				}
			}
			function toSubmit(){
				var info  = checkClick();
				if(info !== false){
					info = info.split("~");
					if(!info[1]){
						alert("请先为申请单开据调配单!");
					}else{
						var index = $("#queryRetTable").attr("selectedRow");
						var issubmit;
						$("input[type='checkbox'][name='selectedbox']").each(function(i){
							if(this.checked == true){
								issubmit = this.issubmit;
							}
						});
						if(issubmit == "1"){
							var deviceappid = info[0];
							//更新调配单的处理状态 2012-10-23 start deviceappid
							var updatesql1 = "update gms_device_app devapp set opr_state='1' "+
												"where exists (select 1 from gms_device_app_detail devappdet "+ 
												"join (select device_app_detid,nvl(sum(assign_num),0) as assignnum from gms_device_appmix_main dam " +
												"where exists(select 1 from gms_device_app_detail dad where dad.device_app_detid=dam.device_app_detid " +
												"and dad.device_app_id='"+deviceappid+"') "+
												"and exists(select 1 from gms_device_mixinfo_form mif where mif.device_mixinfo_id=dam.device_mixinfo_id and mif.state='9') "+
												"group by device_app_detid) assign "+ 
												"on devappdet.device_app_detid=assign.device_app_detid and devappdet.bsflag='0' "+
												"and devappdet.device_app_id='"+deviceappid+"' "+
												"where devappdet.apply_num>assign.assignnum and devappdet.device_app_id ='"+deviceappid+"') "+
												"and devapp.device_app_id = '"+deviceappid+"'"; 
							
							var updatesql2 = "update gms_device_app devapp set opr_state='9' "+
												"where not exists (select 1 from gms_device_app_detail devappdet "+ 
												"join (select device_app_detid,nvl(sum(assign_num),0) as assignnum from gms_device_appmix_main dam " +
												"where exists(select 1 from gms_device_app_detail dad where dad.device_app_detid=dam.device_app_detid " +
												"and dad.device_app_id='"+deviceappid+"') "+
												"and exists(select 1 from gms_device_mixinfo_form mif where mif.device_mixinfo_id=dam.device_mixinfo_id and mif.state='9') "+
												"group by device_app_detid) assign "+ 
												"on devappdet.device_app_detid=assign.device_app_detid and devappdet.bsflag='0' "+
												"and devappdet.device_app_id='"+deviceappid+"' "+
												"where devappdet.apply_num>assign.assignnum and devappdet.device_app_id ='"+deviceappid+"') "+
												"and devapp.device_app_id = '"+deviceappid+"'";
							var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
							var sql = "update gms_device_mixinfo_form set state = '9' where device_mixinfo_id = '"+info[1]+"'";
							//更新主表的处理状态 start
							syncRequest("post",path,"sql="+updatesql1+"&ids=");
							syncRequest("post",path,"sql="+updatesql2+"&ids=");
							//更新主表的处理状态 end 
							var retObj = syncRequest("post",path,"sql="+sql+"&ids=");
							if(retObj.returnCode == "0"){
								alert("调配单提交成功!");
								searchDevData();
							}else{
								alert(retObj.returnMsg);
							}
						}else{
							alert("请先填写分配明细!");
						}
					}
				}
			}
		</script>
		<script>
			function checkClick(){
				var shuaId;
				$("input[type='checkbox'][name='selectedbox']").each(function(i){
					if(this.checked == true){
						shuaId = this.value;
					}
				});
				if(shuaId == undefined){
					alert("请选择一条记录!");
					return false;
				}else{
					return shuaId;
				}
			}
			function dbclickRow(shuaId,type) {
				var info = shuaId.split("~");
				if(info[1] != ""){
					var state = $(":checkbox[checked=checked]" , "#queryRetTable").attr("mix_state");
					if(state == "9"){
						alert("该调配单已经提交");
						return false;
					}
				}
				popWindow(
					'<%=contextPath%>/rm/dm/collectDev/collectDevDetail.jsp?dev_app_id='+info[0]+'&dev_mix_id='+ info[1],'950:680'
				);
			}
			function getContentTab(obj, index) {
				$("li", "#tag-container_3").removeClass("selectTag");
				var contentSelectedTag = obj.parentElement;
				contentSelectedTag.className = "selectTag";
				var filterobj = ".tab_box_content[name=tab_box_content" + index + "]";
				var filternotobj = ".tab_box_content[name!=tab_box_content" + index + "]";
				if (index == 1) {
					// 动态查询明细
					var currentid;
					$("input[type='checkbox'][name='selectedbox']").each(function(i){
						if(this.checked == true){
							currentid = this.value;
						}
					});
					var idinfo = $(filterobj).attr("idinfo");
					if (currentid != undefined && idinfo == currentid) {
						// 已经有值，且完成钻取，那么不再钻取
					} else {
						// 先进行查询
						var sql = "";
						var queryRet = syncRequest('Post', _path + appConfig.queryListAction, 'querySql=' + prosql);
						
						var prosql = "select cos.device_name,cos.device_model,cos.out_num,cos.receive_state,";
						prosql += "case cos.receive_state when '0' then '未接受' when '1' then '接收中' when '9' then '接收完毕' else '异常状态' end as recstate_desc ";
						prosql += "from gms_device_coll_outsub cos ";
						prosql += "left join gms_device_coll_outform cof on cos.device_outinfo_id=cof.device_outinfo_id ";
						prosql += "where cof.device_outinfo_id='" + currentid + "'";
						var queryRet = syncRequest('Post', '<%=contextPath%>'
										+ appConfig.queryListAction, 'querySql=' + prosql);
						basedatas = queryRet.datas;
						if (basedatas != undefined && basedatas.length >= 1) {
							// 先清空
							var filtermapid = "#detailList";
							$(filtermapid).empty();
							appendDataToDetailTab(filtermapid, basedatas);
							// 设置当前标签页显示的主键
							$(filterobj).attr("idinfo", currentid);
						} else {
							var filtermapid = "#detailList";
							$(filtermapid).empty();
							$(filterobj).attr("idinfo", currentid);
						}
					}
				}
				$(filternotobj).hide();
				$(filterobj).show();
			}
			function appendDataToDetailTab(filterobj, datas) {
				for (var i = 0; i < basedatas.length; i++) {
					var innerHTML = "<tr>";
					innerHTML += "<td>" + (i + 1) + "</td><td>" + datas[i].device_name
							+ "</td><td>" + datas[i].device_model + "</td>";
					innerHTML += "<td>" + datas[i].out_num + "</td><td>"
							+ datas[i].recstate_desc + "</td>";
					innerHTML += "</tr>";
			
					$(filterobj).append(innerHTML);
				}
				$(filterobj + ">tr:odd>td:odd").addClass("odd_odd");
				$(filterobj + ">tr:odd>td:even").addClass("odd_even");
				$(filterobj + ">tr:even>td:odd").addClass("even_odd");
				$(filterobj + ">tr:even>td:even").addClass("even_even");
			}
			
			function toAddDetailPage() {
				var shuaId;
				$("input[type='checkbox'][name='selectedbox']").each(function(i){
					if(this.checked == true){
						shuaId = this.value;
					}
				});
				if (shuaId == undefined) {
					alert("请选择一条记录!");
					return;
				}
				var info = shuaId.split("~", -1);
				if (info[1] != '') {
					popWindow(
							'<%=contextPath%>/rm/dm/collDevOutForm/collDevOutInfoNew.jsp?mixInfoId='
									+ info[1], '950:680');
				}
			}
			function toModifyDetailPage() {
				var shuaId;
				$("input[type='checkbox'][name='selectedbox']").each(function(i){
					if(this.checked == true){
						shuaId = this.value;
					}
				});
				if (shuaId == undefined) {
					alert("请选择一条记录!");
					return;
				}
				var info = shuaId.split("~", -1);
				if (info[0] != '') {
					popWindow(
							'<%=contextPath%>/rm/dm/collDevOutForm/collDevOutInfoModify.jsp?outInfoId='
									+ info[0] + '&mixInfoId=' + info[1], '950:680');
				} else {
					alert("您尚未开据本调配单对应的出库单，请查看!");
					return;
				}
			}
			
			function toDelRecord() {
				var length = 0;
				$("input[type='checkbox'][name='selectedbox']").each(function(i){
					if(this.checked == true){
						length = length+1;
					}
				});
				if (length == 0) {
					alert("请选择删除的记录！");
					return;
				}
				// 判断状态如果是已提交，那么不能删除,或者没建新纪录，不能删除
				var idinfo;
				var delflag = false;
				var addflag = 0;
				$("input[type='checkbox'][name='selectedbox']").each(function(i){
					if(this.checked == true){
						var curvalue = this.value;
						var outstate = this.outstate;
						var curvalues = curvalue.split("~", -1);
						if (curvalues[0] == '' || outstate == '9') {
							delflag = true;
						} else {
							if (addflag == 0) {
								idinfo = curvalues[0];
							} else {
								idinfo += "~" + curvalues[0];
							}
							addflag++;
						}
					}
				});
				if (delflag) {
					alert("您只能选择状态为'出库中'的记录删除!");
					return;
				}
				if (confirm("是否执行删除操作?")) {
					var idinfos = idinfo.replace(/[~]/g, "','");
					idinfos = "'" + idinfos + "'";
					alert(idinfos)
					var sql = "update gms_device_coll_outform set bsflag='1' where device_outinfo_id in ("
							+ idinfos + ")";
					var path = cruConfig.contextPath + "/rad/asyncDelete.srq";
					var params = "deleteSql=" + sql;
					params += "&ids=";
					var retObject = syncRequest('Post', path, params);
					refreshData();
				}
			}
			function chooseOne(cb) {
				var obj = document.getElementsByName("selectedbox");
				for (i = 0; i < obj.length; i++) {
					if (obj[i] != cb)
						obj[i].checked = false;
					else
						obj[i].checked = true;
				}
			}
			
			function loadDataDetail(shuaId) {
				var e = window.event,
					checkbox = $(e.srcElement).closest("tr").find(":checkbox").attr("checked","checked");
				$(":checkbox","#queryRetTable").not(checkbox).removeAttr("checked");
				var retObj;
				var ids;
				if (shuaId != null) {
					ids = shuaId;
				} else {
					ids = getSelIds('selectedbox');
					if (ids == '') {
						alert("请先选中一条记录!");
						return;
					}
				}
				//{device_app_id}~{device_mixinfo_id}
				var info = ids.split("~", -1);
				if (info[1] != '') {
					//根据ids去查找
					var str = "select devapp.device_app_id,devapp.device_app_no,to_char(devapp.appdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
					+"mif.device_mixinfo_id,mif.mixinfo_no,tp.project_name,mixorg.org_abbreviation as mix_org_name,"
					+"outorg.org_abbreviation as out_org_name,he.employee_name,to_char(mif.modifi_date,'yyyy-mm-dd') as mix_date,"
					+"case mif.state when '0' then '调配中' when '9' then '已调配' else '待调配' end as mix_state_desc,mif.state "
					+"from gms_device_app devapp "
					+"left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id "
					+"left join gp_task_project tp on devapp.project_info_no=tp.project_info_no " 
					+"left join gms_device_mixinfo_form mif on mif.device_app_id=devapp.device_app_id " 
					+"left join comm_human_employee he on mif.print_emp_id=he.employee_id "
					+"left join comm_org_information apporg on devapp.app_org_id=apporg.org_id "
					+"left join comm_org_information mixorg on devapp.mix_org_id=mixorg.org_id "
					+"left join comm_org_information outorg on mif.out_org_id=outorg.org_id "
					+"where wfmiddle.proc_status='3' and mif.device_mixinfo_id='"+info[1]+"'";
					var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
					retObj = unitRet.datas;
					//取消选中框--------------------------------------------------------------------------
					//取消其他选中的
					$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_app_id+"']"+"~"+retObj[0].device_mixinfo_id).removeAttr("checked");
					//选中这一条checkbox
					$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_app_id+"']"+"~"+retObj[0].device_mixinfo_id).attr("checked",'true');
					//------------------------------------------------------------------------------------
					$("#project_name").val(retObj[0].project_name);
					$("#device_app_no").val(retObj[0].device_app_no);
					$("#app_org_name").val(retObj[0].app_org_name);
					$("#appdate").val(retObj[0].appdate);
					$("#mix_org_name").val(retObj[0].mix_org_name);
					$("#mix_state_desc").val(retObj[0].mix_state_desc);
					$("#mixinfo_no").val(retObj[0].mixinfo_no);
					
					$("#out_org_name").val(retObj[0].out_org_name);
					$("#employee_name").val(retObj[0].employee_name);
					$("#mix_date").val(retObj[0].mix_date);
				} else {
					//根据ids去查找 申请单
					var str = "select devapp.device_app_id,devapp.device_app_no,to_char(devapp.appdate,'yyyy-mm-dd') as appdate,apporg.org_abbreviation as app_org_name,"
					+"tp.project_name,mixorg.org_abbreviation as mix_org_name,'待调配' as mix_state_desc "
					+"from gms_device_app devapp "
					+"left join common_busi_wf_middle wfmiddle on devapp.device_app_id=wfmiddle.business_id "
					+"left join gp_task_project tp on devapp.project_info_no=tp.project_info_no " 
					+"left join comm_org_information apporg on devapp.app_org_id=apporg.org_id "
					+"left join comm_org_information mixorg on devapp.mix_org_id=mixorg.org_id "
					+"where wfmiddle.proc_status='3' and devapp.device_app_id='"+info[0]+"'";
					var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
					retObj = unitRet.datas;
					//取消其他选中的
					$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_app_id+"~']").removeAttr("checked");
					//选中这一条checkbox
					$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_app_id+"~']").attr("checked",'true');
					//选中这一条checkbox
					//------------------------------------------------------------------------------------
					$("#project_name").val(retObj[0].project_name);
					$("#device_app_no").val(retObj[0].device_app_no);
					$("#app_org_name").val(retObj[0].app_org_name);
					$("#appdate").val(retObj[0].appdate);
					$("#mix_org_name").val(retObj[0].mix_org_name);
					$("#mix_state_desc").val(retObj[0].mix_state_desc);
					
					$("#out_org_name").val("");
					$("#employee_name").val("");
					$("#mix_date").val("");
				}
			}
		</script>
	</body>
</html>