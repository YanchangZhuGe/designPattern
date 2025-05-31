<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userSubId = user.getOrgSubjectionId();
	String orgId = user.getSubOrgIDofAffordOrg();
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
		<title>多项目-单台设备流动变更</title>
	</head>

	<body style="background: #fff" onload="refreshData()">
		<div id="list_table">
			<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
						<td background="<%=contextPath%>/images/list_15.png">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="ali_cdn_name">变更单名称</td>
									<td class="ali_cdn_input">
										<input id="s_device_app_name" name="s_device_app_name" type="text" /> 
										<input type='hidden' id="szButton" name="szButton" value="" />
									</td>
									<td class="ali_cdn_name">变更单号</td>
									<td class="ali_cdn_input">
										<input id="s_mixinfo_no" name="s_mixinfo_no" type="text" />
									</td>
									<td id="s_opr_state_name" name="s_opr_state_name" class="ali_cdn_name">状态</td>
									<td id="s_opr_state" name="s_opr_state" class="ali_cdn_input">
										<select id="s_opr_state_desc" name="s_opr_state_desc" class="select_width">
											<option value="" selected="selected">--请选择--</option>
											<option value="0">未提交</option>
											<option value="1">待接收</option>
											<option value="2">已接收</option>
											<option value="3">退回</option>
										</select>
									</td>
									<td class="ali_cdn_name">角色切换</td>
									<td class="ali_cdn_input">
										<select id="state_role" name="state_role" class="select_width">
											<option value="0" selected="selected">申请方</option>
											<option value="1">接收方</option>
										</select>
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
									<td id="add" name="add" class='ali_btn'>
										<span class='zj'>
											<a href='#' onclick='toAddDtPlan()' title='新增'></a>
										</span>
									</td>
									<td id="modify" name="modify" class='ali_btn'>
										<span class='xg'>
											<a href='#' onclick='toModifyDtPlan()' title='修改'></a>
										</span>
									</td>
									<td id="delete" name="delete" class='ali_btn'>
										<span class='sc'>
											<a href='#' onclick='toDelDtPlan()' title='删除'></a>
										</span>
									</td>
									<td id="submit" name="submit" class='ali_btn'>
										<span class='tj'>
											<a href='#' onclick='toSummitDtPlan()' title='提交'></a>
										</span>
									</td>
									<td id="jieshou" name="jieshou" style="display: none;" class='ali_btn'>
										<span class='jh'>
											<a href='####' onclick='toDetailDtPlan()' title='验收'></a>
										</span>
									</td>
									<td class='ali_btn'>
										<span class='dc'>
											<a href='#' onclick='exportData()' title='导出excel'></a>
										</span>
									</td>
								</tr>
							</table>
						</td>
						<td width="4">
							<img src="<%=contextPath%>/images/list_17.png" width="4" height="36" />
						</td>
					</tr>
				</table>
			</div>
			<div id="table_box">
				<table style="width: 98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
					<tr id='moveapp_id_{moveapp_id}' name='moveapp_id'>
						<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' mixstate='{state}' value='{moveapp_id}' id='selectedbox_{moveapp_id}' />">选择</td>
						<td class="bt_info_odd" autoOrder="1">序号</td>
						<td class="bt_info_even" exp="{moveapp_name}">申请单名称</td>
						<td class="bt_info_odd" exp="{moveapp_no}">变更单号</td>
						<td class="bt_info_even" exp="{inorgname}">转入单位</td>
						<td class="bt_info_even" exp="{outorgname}">转出单位</td>
						<td class="bt_info_odd" exp="{opertor_id}">开据人</td>
						<td class="bt_info_even" exp="{apply_date}">申请时间</td>
						<td class="bt_info_odd" exp="{state}">状态</td>
					</tr>
				</table>
			</div>
			<div id="fenye_box" style="display: block">
				<table width="100%" border="0" cellspacing="0" cellpadding="0"
					id="fenye_box_table">
					<tr>
						<td align="right">第1/1页，共0条记录</td>
						<td width="10">&nbsp;</td>
						<td width="30">
							<img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" />
						</td>
						<td width="30">
							<img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" />
						</td>
						<td width="30">
							<img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" />
						</td>
						<td width="30">
							<img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" />
						</td>
						<td width="50">到 
							<label> 
								<input type="text" name="textfield" id="textfield" style="width: 20px;" />
							</label>
						</td>
						<td align="left">
							<img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" />
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
					<li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">转出明细</a></li>
					<li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">接收明细</a></li>
					<li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
					<li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
					<li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
				</ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
						<tr>
							<td class="inquire_item6">变更单号</td>
							<td class="inquire_form6">
								<input id="moveapp_no" name="" class="input_width" type="text" />
							</td>
							<td class="inquire_item6">变更单名称</td>
							<td class="inquire_form6">
								<input id="moveapp_name" name="" class="input_width" type="text" />
							</td>
							<td class="inquire_item6">开据人</td>
							<td class="inquire_form6">
								<input id="opertor_id" name="" class="input_width" type="text" />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6">转入单位</td>
							<td class="inquire_form6">
								<input id="in_org_name" name="" class="input_width" type="text" />
							</td>
							<td class="inquire_item6">转出单位</td>
							<td class="inquire_form6">
								<input id="out_org_name" name="" class="input_width" type="text" />
							</td>
							<td class="inquire_item6">变更时间</td>
							<td class="inquire_form6">
								<input id="apply_date" name="" class="input_width" type="text" />
							</td>
						</tr>
						<tr>
							<td class="inquire_item6">处理状态</td>
							<td class="inquire_form6">
								<input id="state" name="" class="input_width" type="text" />
							</td>
						</tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display: none">
					<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%" style="margin-top: 10px; background: #efefef">
						<tr class="bt_info">
							<td class="bt_info_even" width="4%">序号</td>
							<td class="bt_info_odd" width="20%">设备名称</td>
							<td class="bt_info_even" width="20%">规格型号</td>
							<td class="bt_info_odd" width="18%">自编号</td>
							<td class="bt_info_even" width="18%">牌照号</td>
							<td class="bt_info_odd" width="20%">实物标识号</td>
						</tr>
						<tbody id="detailMap" name="detailMap"></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" idinfo="" class="tab_box_content" style="display: none">
					<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%" style="margin-top: 10px; background: #efefef">
						<tr class="bt_info">
							<td class="bt_info_even" width="4%">序号</td>
							<td class="bt_info_odd" width="20%">设备名称</td>
							<td class="bt_info_even" width="20%">规格型号</td>
							<td class="bt_info_odd" width="18%">自编号</td>
							<td class="bt_info_even" width="18%">牌照号</td>
							<td class="bt_info_odd" width="20%">实物标识号</td>
						</tr>
						<tbody id="detailMap1" name="detailMap1"></tbody>
					</table>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display: none;">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0"></iframe>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display: none;">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0"></iframe>
				</div>
				<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display: none;">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0" scrolling="auto" style="overflow: scroll;"></iframe>
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
		});	
	
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
			var currentid ;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					currentid = this.value;
					currentid = currentid.split("~")[0];
				}
			});
			if(index == 1){
				//动态查询明细
				var idinfo = $(filterobj).attr("idinfo");
				if(currentid != undefined && idinfo == currentid){
					//已经有值，且完成钻取，那么不再钻取
				}else{
					//先进行查询
					var str = " select t.dev_name,t.dev_model,t.self_num,t.license_num,t.dev_sign from gms_device_moveapp_detail d inner join gms_device_account t on t.dev_acc_id=d.out_dev_id  where d.moveapp_id='"+currentid+"' order by t.dev_coding ";
					var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
					basedatas = queryRet.datas;
					if(basedatas!=undefined && basedatas.length>=1){
						//先清空
						var filtermapid = "#detailMap";
						$(filtermapid).empty();
						appendDataToDetailTab(filtermapid,basedatas);
						//设置当前标签页显示的主键
						$(filterobj).attr("idinfo",currentid);
					}else{
						var filtermapid = "#detailMap";
						$(filtermapid).empty();
						$(filterobj).attr("idinfo",currentid);
					}
				}
			}
			if(index == 2){
				//动态查询明细
				var str = " select t.dev_name,t.dev_model,t.self_num,t.license_num,t.dev_sign from gms_device_moveapp_detail d inner join gms_device_account t on t.dev_acc_id=d.in_dev_id  where d.moveapp_id='"+currentid+"' order by t.dev_coding ";
					var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
					basedatas = queryRet.datas;
					if(basedatas!=undefined && basedatas.length>=1){
						//先清空
						var filtermapid = "#detailMap1";
						$(filtermapid).empty();
						appendDataToDetailTab1(filtermapid,basedatas);
						//设置当前标签页显示的主键
						$(filterobj).attr("idinfo",currentid);
					}else{
						var filtermapid = "#detailMap1";
						$(filtermapid).empty();
						$(filterobj).attr("idinfo",currentid);
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
				innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
				innerHTML += "<td>"+datas[i].self_num+"</td><td>"+datas[i].license_num+"</td><td>"+datas[i].dev_sign+"</td>";
				innerHTML += "</tr>";
				$(filterobj).append(innerHTML);
			}
			$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
			$(filterobj+">tr:odd>td:even").addClass("odd_even");
			$(filterobj+">tr:even>td:odd").addClass("even_odd");
			$(filterobj+">tr:even>td:even").addClass("even_even");
		}
		function appendDataToDetailTab1(filterobj,datas){
			for(var i=0;i<basedatas.length;i++){
				var innerHTML = "<tr>";
				innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
				innerHTML += "<td>"+datas[i].self_num+"</td><td>"+datas[i].license_num+"</td><td>"+datas[i].dev_sign+"</td>";
				innerHTML += "</tr>";
				$(filterobj).append(innerHTML);
			}
			$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
			$(filterobj+">tr:odd>td:even").addClass("odd_even");
			$(filterobj+">tr:even>td:odd").addClass("even_odd");
			$(filterobj+">tr:even>td:even").addClass("even_even");
		}
		$(document).ready(lashen);
		
		cruConfig.contextPath =  "<%=contextPath%>";
		cruConfig.cdtType = 'form';
		function searchDevData(){
			var v_opr_state_desc = document.getElementById("s_opr_state_desc").value;
			var v_device_app_name = document.getElementById("s_device_app_name").value;
			var v_mixinfo_no = document.getElementById("s_mixinfo_no").value;
			var state_role = document.getElementById("state_role").value;
			if(state_role=='1'){
				document.getElementById("add").style.display = "none"; 
				document.getElementById("modify").style.display = "none"; 
				document.getElementById("delete").style.display = "none"; 
				document.getElementById("submit").style.display = "none"; 
				document.getElementById("s_opr_state").style.display = "none"; 
				document.getElementById("s_opr_state_name").style.display = "none"; 
				document.getElementById("jieshou").style.display = "block"; 
			}
			if(state_role=='0'){
				document.getElementById("add").style.display = "block"; 
				document.getElementById("modify").style.display = "block"; 
				document.getElementById("delete").style.display = "block"; 
				document.getElementById("submit").style.display = "block"; 
				document.getElementById("s_opr_state").style.display = "block";
				document.getElementById("s_opr_state_name").style.display = "block"; 
				document.getElementById("jieshou").style.display = "none"; 
			}
			refreshData(v_device_app_name, v_mixinfo_no,v_opr_state_desc,state_role);
		}
		//清空查询条件
	    function clearQueryText(){
	    	var state_role = document.getElementById("state_role").value;
	    	var v_device_app_name =document.getElementById("s_device_app_name").value="";
	    	var v_mixinfo_no =document.getElementById("s_mixinfo_no").value="";
	    	if(state_role=='0'){
	        	var v_opr_state_desc=document.getElementById("s_opr_state_desc").value="";
	        	document.getElementById("add").style.display = "block"; 
				document.getElementById("modify").style.display = "block"; 
				document.getElementById("delete").style.display = "block"; 
				document.getElementById("submit").style.display = "block"; 
				document.getElementById("s_opr_state").style.display = "block";
				document.getElementById("s_opr_state_name").style.display = "block"; 
				document.getElementById("jieshou").style.display = "none"; 
				refreshData(v_device_app_name, v_mixinfo_no,v_opr_state_desc,state_role);
			}
	    	if(state_role=='1'){
	    		document.getElementById("add").style.display = "none"; 
				document.getElementById("modify").style.display = "none"; 
				document.getElementById("delete").style.display = "none"; 
				document.getElementById("submit").style.display = "none"; 
				document.getElementById("s_opr_state").style.display = "none"; 
				document.getElementById("s_opr_state_name").style.display = "none"; 
				document.getElementById("jieshou").style.display = "block"; 
				refreshData(v_device_app_name, v_mixinfo_no,'',state_role);
			}
	    }
		function refreshData(v_device_app_name,v_mixinfo_no,v_opr_state_desc,state_role){
			if(state_role=="" || state_role==undefined){
				state_role="0";
			}
			var str = " select f.moveapp_id, f.moveapp_no,  f.moveapp_name, inorg.org_abbreviation as inorgname, outorg.org_abbreviation as outorgname,f.apply_date, ";
				str+= "  (case  when f.state = '0' then '未提交'  when f.state = '1' then  '待接收'  when f.state = '2' then '已接收'  when f.state = '3' then ";
				str+= "  '退回'  end) as state, f.opertor_id  from gms_device_moveapp f  left join(comm_org_subjection sub  left join comm_org_information inorg on sub.org_id = inorg.org_id) on f.in_org_id = sub.org_subjection_id ";
				str+= "  left join(comm_org_subjection sub  left join comm_org_information outorg on sub.org_id = outorg.org_id) on f.out_org_id = sub.org_subjection_id";  
				str+= " where   f.bsflag='0' and f.move_type ='1' ";
			if(state_role!=undefined && state_role=='0'){
				str += "and f.out_org_id like '<%=orgId%>%' ";
				if(v_opr_state_desc!=undefined && v_opr_state_desc!=''){
					str += "and f.state='"+v_opr_state_desc+"' ";
				}	
			}
			if(state_role!=undefined && state_role=='1'){
				str += "and f.in_org_id like '<%=orgId%>%' and f.state!='0' ";
			}
			if(v_device_app_name!=undefined && v_device_app_name!=''){
				str += "and f.moveapp_name like '%"+v_device_app_name+"%' ";
			}
			if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
				str += "and f.moveapp_no like '%"+v_mixinfo_no+"%' ";
			}
			
			str+="  order by  case  when f.state = '0' then  '0'   when f.state = '1' then  '1'   when f.state = '2' then   '3'  when f.state = '3' then  '2' end    asc, f.create_date desc ";
			cruConfig.queryStr = str;
			queryData(cruConfig.currentPage);
			
		}
		
		var selectedTagIndex = 0;
		var showTabBox = document.getElementById("tab_box_content0");
		
	    function chooseOne(cb){   
	        var obj = document.getElementsByName("selectedbox");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
	
	    function loadDataDetail(shuaId){
	    	var retObj;
			if(shuaId!=null){
				shuaId = shuaId.split("~")[0];
				retObj = jcdpCallService("DevProSrv", "getmoveAppInfo", "devrecId="+shuaId);
			}else{
				var ids = getSelIds('selectedbox');
			    if(ids==''){ 
				    alert("请先选中一条记录!");
		     		return;
			    }
			    ids = ids.split("~")[0];
			    retObj = jcdpCallService("DevProSrv", "getmoveAppInfo", "devrecId="+ids);
			}
			//取消其他选中的
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceaccMap.moveapp_id+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj.deviceaccMap.moveapp_id+"']").attr("checked",'true');
			document.getElementById("moveapp_no").value =retObj.deviceaccMap.moveapp_no;
			document.getElementById("moveapp_name").value =retObj.deviceaccMap.moveapp_name;
			document.getElementById("in_org_name").value =retObj.deviceaccMap.inorgname;
			document.getElementById("out_org_name").value =retObj.deviceaccMap.outorgname;
			document.getElementById("apply_date").value =retObj.deviceaccMap.apply_date;
			document.getElementById("opertor_id").value =retObj.deviceaccMap.opertor_id;
			document.getElementById("state").value =retObj.deviceaccMap.state;;
			//重新加载当前标签页信息
			getContentTab(undefined,selectedTagIndex);
	    }
	    
	    function toAddDtPlan(){
	    	popWindow('<%=contextPath%>/rm/dm/dev_work/sinDevMoveApply.jsp?flag=add','950:680');
	    	
	    }
	    function toModifyDtPlan(){
	    	var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
	    	var result='0';
	    	$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					var mixstate = this.mixstate;
					if(mixstate=='退回'){
						result='0';
						return;
					}
					if(mixstate!='未提交'){
						alert("只有未提交的单据才能修改!");
						result='1';
						return;
					}
				}
			});
			if(result=='1'){
				return;
			}
	    	popWindow('<%=contextPath%>/rm/dm/dev_work/sinDevMoveApply.jsp?flag=update&mixId='+ids,'950:680');
	    }
	    
	    function toDelDtPlan(){
	    	var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
	    	var result='0';
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					var mixstate = this.mixstate;
					if(mixstate=='退回'){
						result='0';
						return;
						}
					if(mixstate!='未提交'){
					alert("只有未提交的单据才能删除!");
					result='1';
					}
				}
			});
			if(result=='1'){
				return;
			}
			if(confirm("是否执行删除操作?")){
				jcdpCallService("DevProSrv", "deleteMoveAppInfo", "id="+ids);
				refreshData();
			}
	    }
	   function toSummitDtPlan(){
	   		var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
	   		var orgSubId='<%=userSubId%>';
			//判断状态如果是已提交，那么不能删除,或者没建新纪录，不能删除
			var result = '0';
			$("input[type='checkbox'][name='selectedbox']").each(function() {
				if (this.checked) {
					var mixstate = this.mixstate;
					if (mixstate != '未提交') {
						alert("只有未提交的单据才能提交!");
						result = '1';
						return;
					}
				}
			});
			if (result == '1') {
				return;
			}
			var state = '';//0未提交 1审核通过 2待审核 3审核失败
			if (confirm("提交后不能修改删除,是否提交?")) {
				var sql = "update gms_device_moveapp  set state='" + 1
						+ "' where moveapp_id ='" + ids + "'";
				var path = cruConfig.contextPath + "/rad/asyncDelete.srq";
				var params = "deleteSql=" + sql;
				params += "&ids=";
				syncRequest('Post', path, params);
				refreshData();
			}
		}
		function toDetailDtPlan() {
			var ids = getSelIds('selectedbox');
			if (ids == '') {
				alert("请先选中一条记录!");
				return;
			}
			var result = '0';
			$("input[type='checkbox'][name='selectedbox']").each(function() {
				if (this.checked) {
					var mixstate = this.mixstate;
					if (mixstate == '未提交') {
						alert("未提交的变更单不能重复验收!");
						result = '1';
						return;
					}
					if (mixstate == '已接收') {
						alert("已接收的变更单不能重复验收!");
						result = '1';
						return;
					}
					if (mixstate == '退回') {
						alert("退回的变更单不能重复验收!");
						result = '1';
						return;
					}
				}
			});
			if (result == '1') {
				return;
			}
			popWindow('<%=contextPath%>/rm/dm/dev_work/sinDevMoveCheck.jsp?mixId='+ids,'950:680');
	   }
	</script>
</html>