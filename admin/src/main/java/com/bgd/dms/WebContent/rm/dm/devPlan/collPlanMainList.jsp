<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link id="artDialogSkin" href="<%=contextPath %>/js/artDialog/skins/blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/artDialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>装备设备申请</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_project_name" name="s_project_name" type="text" class="input_width" />
			    </td>
			  <td class="ali_cdn_name">项目状态</td>
			    <td class="ali_cdn_input">
			    	<select id="projectStatus" name="projectStatus" class="select_width" >
			    	    <option value="" selected="selected">--请选择--</option>
						<option value="5000100001000000001">项目启动</option>
						<option value="5000100001000000002">正在运行</option>
						<option value="5000100001000000003">项目结束</option>
						<option value="5000100001000000004">项目暂停</option>
						<option value="5000100001000000005">施工结束</option>
			    	</select>
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
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
			     <tr id='device_appdet_id_{device_allapp_id}' name='device_allapp_id' idinfo='{device_allapp_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{project_info_no}' id='selectedbox_{project_info_no}' />" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" isExport='Hide' exp="<a onclick=viewProject('{project_info_no}') onmouseout=dialogClose('{projectfull}') onmouseover=dialogValue('{projectfull}')>{project_name}</a>">项目名称</td>
					<td class="bt_info_odd" isShow='Hide' exp="{project_name}">项目名称</td>
					<td class="bt_info_even" isExport='Hide' exp="<a onclick=viewCollDevice('{project_info_no}','1')>{dyztotal}</a>">电源站</td>
					<td class="bt_info_even" isShow='Hide' exp="{dyztotal}">电源站</td>
					<td class="bt_info_odd" isExport='Hide' exp="<a onclick=viewCollDevice('{project_info_no}','2')>{cjztotal}</a>">采集站</td>
					<td class="bt_info_odd" isShow='Hide' exp="{cjztotal}">采集站</td>
					<td class="bt_info_even" isExport='Hide' exp="<a onclick=viewCollDevice('{project_info_no}','3')>{jcztotal}</a>">交叉站</td>
					<td class="bt_info_even" isShow='Hide' exp="{jcztotal}">交叉站</td>
					<td class="bt_info_odd" isExport='Hide' exp="<a onclick=viewCollDevice('{project_info_no}','4')>{jcxtotal}</a>">交叉线</td>
					<td class="bt_info_odd" isShow='Hide' exp="{jcxtotal}">交叉线</td>
					<td class="bt_info_even" isExport='Hide' exp="<a onclick=viewCollDevice('{project_info_no}','5')>{pldltotal}</a>">排列电缆</td>
					<td class="bt_info_even" isShow='Hide' exp="{pldltotal}">排列电缆</td>
					<td class="bt_info_odd" isExport='Hide' exp="<a onclick=viewDevice('{project_info_no}','6')>{fstotal}</a>">仪器附属</td>
					<td class="bt_info_odd" isShow='Hide' exp="{fstotal}">仪器附属</td>
					<td class="bt_info_even" isExport='Hide' exp="<a onclick=viewDevice('{project_info_no}','7')>{zytotal}</a>">可控震源</td>
					<td class="bt_info_even" isShow='Hide' exp="{zytotal}">可控震源</td>
					<td class="bt_info_odd" isExport='Hide' exp="<a onclick=viewDevice('{project_info_no}','8')>{cltotal}</a>">测量仪器</td>
					<td class="bt_info_odd" isShow='Hide' exp="{cltotal}">测量仪器</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">地震仪器调配记录</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">可控震源调配记录</a></li>
			    <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">测量仪器调配记录</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" idinfo="" class="tab_box_content" >
					<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  	<tr align="right">
					  		<td class="ali_cdn_name" ></td>
					  		<td class="ali_cdn_input" ></td>
					  		<td class="ali_cdn_name" ></td>
					  		<td class="ali_cdn_input" ></td>
					  		<td>&nbsp;</td>
					    	<auth:ListButton functionId="" css="zj" event="onclick='toAddDZYD()'" title="JCDP_btn_add"></auth:ListButton>
					    	<auth:ListButton functionId="" css="jh" event="onclick='toViewDZYD()'" title="查看明细"></auth:ListButton>
							<auth:ListButton functionId="" css="xg" event="onclick='toViewDZYD()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="" css="sc" event="onclick='toDeleteQZBY()'" title="JCDP_btn_delete"></auth:ListButton>
							<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="提交"></auth:ListButton>
						</tr>
					  </table>
					<table id="detailtitletable" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" > 
						<tr class="bt_info">
							<td class="bt_info_odd">选择</td>
				            <td class="bt_info_even">序号</td>
							<td class="bt_info_odd">调配申请单名称</td>
							<td class="bt_info_even">调配申请单号</td>
							<td class="bt_info_odd">调配设备类别</td>
							<td class="bt_info_even">申请单位名称</td>
							<td class="bt_info_odd">申请人</td>
							<td class="bt_info_even">申请时间</td>
							<td class="bt_info_odd">状态</td>
				        </tr>				        
				        <tbody id="dzDetailMap" name="dzDetailMap" >
					   	</tbody>				   	 
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
					<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  	<tr align="right">
					  		<td class="ali_cdn_name" ></td>
					  		<td class="ali_cdn_input" ></td>
					  		<td class="ali_cdn_name" ></td>
					  		<td class="ali_cdn_input" ></td>
					  		<td>&nbsp;</td>
					    	<auth:ListButton functionId="" css="zj" event="onclick=toAddCLZY('Z')" title="JCDP_btn_add"></auth:ListButton>
					    	<auth:ListButton functionId="" css="jh" event="onclick='toViewKKZY()'" title="查看明细"></auth:ListButton>
							<auth:ListButton functionId="" css="xg" event="onclick='toViewKKZY()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="" css="sc" event="onclick='toDeleteQZBY()'" title="JCDP_btn_delete"></auth:ListButton>
							<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="提交"></auth:ListButton>
						</tr>
					  </table>
					<table id="detailtitletable" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" > 
						<tr class="bt_info">
							<td class="bt_info_odd">选择</td>
				            <td class="bt_info_even">序号</td>
							<td class="bt_info_odd">调配申请单名称</td>
							<td class="bt_info_even">调配申请单号</td>
							<td class="bt_info_odd">调配设备类别</td>
							<td class="bt_info_even">申请单位名称</td>
							<td class="bt_info_odd">经办人</td>
							<td class="bt_info_even">申请时间</td>
							<td class="bt_info_odd">状态</td>
				        </tr>				        
				        <tbody id="zyDetailMap" name="zyDetailMap" >
					   	</tbody>				   	 
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  	<tr align="right">
					  		<td class="ali_cdn_name" ></td>
					  		<td class="ali_cdn_input" ></td>
					  		<td class="ali_cdn_name" ></td>
					  		<td class="ali_cdn_input" ></td>
					  		<td>&nbsp;</td>
					    	<auth:ListButton functionId="" css="zj" event="onclick=toAddCLZY('C')" title="JCDP_btn_add"></auth:ListButton>
					    	<auth:ListButton functionId="" css="jh" event="onclick='toViewKKZY()'" title="查看明细"></auth:ListButton>
							<auth:ListButton functionId="" css="xg" event="onclick='toViewKKZY()'" title="JCDP_btn_edit"></auth:ListButton>
							<auth:ListButton functionId="" css="sc" event="onclick='toDeleteQZBY()'" title="JCDP_btn_delete"></auth:ListButton>
							<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="提交"></auth:ListButton>
						</tr>
					  </table>
					<table id="detailtitletable" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" > 
						<tr class="bt_info">
							<td class="bt_info_odd">选择</td>
				            <td class="bt_info_even">序号</td>
							<td class="bt_info_odd">调配申请单名称</td>
							<td class="bt_info_even">调配申请单号</td>
							<td class="bt_info_odd">调配设备类别</td>
							<td class="bt_info_even">申请单位名称</td>
							<td class="bt_info_odd">经办人</td>
							<td class="bt_info_even">申请时间</td>
							<td class="bt_info_odd">状态</td>
				        </tr>				        
				        <tbody id="clDetailMap" name="clDetailMap" >
					   	</tbody>				   	 
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

function dialogClose(str){
	if(str!=''&&str.length>=16){
		//alert(str.length);
		art.dialog.list['KDf435'].close();
	}
}

function dialogValue(str){
	//alert(str.length);
	if(str!=''&&str.length>=16){
	 art.dialog({
		 id:'KDf435',
		 left:200,
		 opacity: 0.87,
		    padding: 0,
		    width: '300',
		    height: 80,
		    title: '调配备注',
		    content: str   
		});
	}
}

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
			if(this.checked == true){
				currentid = this.value;
			}
		});
		if(currentid==undefined){
			return;
        }
        var info = currentid.split("~" , -1); 
        

		if(index == 0 || index == 1 || index == 2){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			var filtermapid = "";
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				if(index == 0){
					filtermapid = "#dzDetailMap";
				}else if(index == 1){
					filtermapid = "#zyDetailMap";
				}else if(index == 2){
					filtermapid = "#clDetailMap";
				}else{
					alert("未知类型!");
					return;
				}
				if(index == 1 || index == 2){
					//先进行查询
					var str = "select devapp.device_app_name,devapp.device_app_no,org.org_abbreviation as org_name,";
					if(index == 1){
						str +="'专业化震源' as mix_type_name,";
					}else{
						str +="'专业化测量' as mix_type_name,";
					}
					str += "emp.employee_name,devapp.appdate,wfmiddle.proc_status,case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc ";
					str += "from gms_device_app devapp left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id and wfmiddle.bsflag = '0' ";
					str += "left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id and allapp.bsflag = '0' ";
					str += "left join common_busi_wf_middle allwfmiddle on allwfmiddle.business_id = allapp.device_allapp_id and allwfmiddle.bsflag = '0' ";
					str += "left join comm_org_information org on devapp.org_id = org.org_id left join comm_human_employee emp on devapp.employee_id = emp.employee_id ";
					str += "left join gp_task_project pro on devapp.project_info_no = pro.project_info_no ";
					str += "where devapp.bsflag = '0' and devapp.project_info_no = '"+info[0]+"' ";
					str += "and allwfmiddle.proc_status = '3' ";
					if(index == 1){
						str += "and devapp.mix_type_id = 'S0623' ";						
					}else{
						str += "and devapp.mix_type_id = 'S1404' ";						
					}
					str += "order by wfmiddle.proc_status nulls first,devapp.modifi_date desc ";
				}else{
					//先进行查询
					var str = "select devapp.device_app_name,devapp.device_app_no,org.org_abbreviation as org_name, ";
					str +="'地震仪器' as mix_type_name,";
					str += "emp.employee_name,devapp.appdate,wfmiddle.proc_status,case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc ";
					str += "from gms_device_collapp devapp left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id and wfmiddle.bsflag = '0' ";
					str += "left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id and allapp.bsflag = '0' ";
					str += "left join common_busi_wf_middle allwfmiddle on allwfmiddle.business_id = allapp.device_allapp_id and allwfmiddle.bsflag = '0' ";
					str += "left join comm_org_information org on devapp.org_id = org.org_id left join comm_human_employee emp on devapp.employee_id = emp.employee_id ";
					str += "left join gp_task_project pro on devapp.project_info_no = pro.project_info_no ";
					str += "where devapp.bsflag = '0' and devapp.project_info_no = '"+info[0]+"' ";
					str += "and allwfmiddle.proc_status = '3' ";
					str += "order by wfmiddle.proc_status nulls first,devapp.modifi_date desc ";
				}				
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
					basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
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
			innerHTML += "<td><input type='checkbox' name='idinfo' id='trid' onclick='chooseOne(this)'/></td>";
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].device_app_name+"</td><td>"+datas[i].device_app_no+"</td><td>"+datas[i].mix_type_name+"</td>";
			innerHTML += "<td>"+datas[i].org_name+"</td><td>"+datas[i].employee_name+"</td><td>"+datas[i].appdate+"</td><td>"+datas[i].state_desc+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	//调用此方法，可以实现上下两个table的方式实现表头固定和对齐，参考planMaininfoList.jsp的#detailtitletable和#detailMap
	function aligntitle(titletrid,filterobj){
		var titlecells = $("tr",titletrid)[0].cells;
		var contenttr = $("tr",filterobj)[0];
		if(contenttr==undefined)
			return;
		var contentcells = contenttr.cells
		for(var index=0;index<titlecells.length;index++){
			var widthinfo = contentcells[index].offsetWidth;
			if(widthinfo>0){
				titlecells[index].width = widthinfo+'px';
			}
		}
	}
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	var projectInfoNos = '<%=projectInfoNo%>';
	var projectName = '<%=projectName%>';
	var projectType="<%=projectType%>";
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function clearQueryText(){
		$("#s_project_name").val("");
		$("#projectStatus").val("");
	}
	function searchDevData(){
		var v_project_name = document.getElementById("s_project_name").value;
		var v_projectStatus = document.getElementById("projectStatus").value;
		refreshData(v_project_name, v_projectStatus);
	}
	function getdate() { 
		var now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}

    function refreshData(v_project_name, v_projectStatus){

		var str = "select * from(select tmp.project_info_no,tmp.project_name as projectfull, ";
			str += "case when length(tmp.project_name) < 16 then tmp.project_name else substr(tmp.project_name, 0, 16) || '...' end as project_name,tmp.project_status,";
			str += "sum(case when colname = '专业化测量' then sumtotal else 0 end) cltotal,";
			str += "sum(case when colname = '专业化震源' then sumtotal else 0 end) zytotal,";
			str += "sum(case when colname = '仪器附属' then sumtotal else 0 end) fstotal,";
			str += "sum(case when colname = '采集站' then sumtotal else 0 end) cjztotal,";
			str += "sum(case when colname = '电源站' then sumtotal else 0 end) dyztotal,";
			str += "sum(case when colname = '交叉站' then sumtotal else 0 end) jcztotal,";
			str += "sum(case when colname = '交叉线' then sumtotal else 0 end) jcxtotal,";
			str += "sum(case when colname = '排列电缆' then sumtotal else 0 end) pldltotal ";
			str += "from (select '专业化测量' as colname,p.project_info_no,p.project_name,p.project_status, ";
			str += "case when dui.project_info_id is null then 0 else count(1) end as sumtotal ";
			str += "from gp_task_project p left join gp_task_project_dynamic dy on dy.project_info_no = p.project_info_no ";
			str += "left join gms_device_account_dui dui on p.project_info_no = dui.project_info_id and dui.bsflag = '0' and dui.mix_type_id = 'S1404' ";
			str += "where dy.org_subjection_id like 'C105005004%' and p.project_status = '5000100001000000001' group by p.project_info_no, p.project_name, dui.project_info_id,p.project_status ";
			str += "union all ";
			str += "select '专业化震源' as colname,p.project_info_no,p.project_name,p.project_status,case when dui.project_info_id is null then 0 else count(1) end as sumtotal ";
			str += "from gp_task_project p left join gp_task_project_dynamic dy on dy.project_info_no = p.project_info_no left join gms_device_account_dui dui ";
			str += "on p.project_info_no = dui.project_info_id and dui.bsflag = '0' and dui.mix_type_id = 'S0623' where dy.org_subjection_id like 'C105005004%' ";
			str += "and p.project_status = '5000100001000000001' group by p.project_info_no, p.project_name, dui.project_info_id,p.project_status ";
			str += "union all ";
			str += "select '仪器附属' as colname,p.project_info_no,p.project_name,p.project_status,case when dui.project_info_id is null then 0 else count(1) end as sumtotal ";
			str += "from gp_task_project p left join gp_task_project_dynamic dy on dy.project_info_no = p.project_info_no left join gms_device_account_dui dui ";
			str += "on p.project_info_no = dui.project_info_id and dui.bsflag = '0' and (dui.mix_type_id = 'S1405' or dui.mix_type_id = 'S14059999') ";
			str += "where dy.org_subjection_id like 'C105005004%' and p.project_status = '5000100001000000001' group by p.project_info_no, p.project_name, dui.project_info_id,p.project_status ";
			str += "union all ";
			str += "select '采集站' as colname,p.project_info_no,p.project_name,p.project_status,case when colltmp.project_info_id is null then 0 else sum(colltmp.total_num) end as sumtotal ";
			str += "from gp_task_project p left join gp_task_project_dynamic dy on dy.project_info_no = p.project_info_no ";
			str += "left join (select colldui.total_num, colldui.project_info_id from gms_device_coll_account_dui colldui left join gms_device_collectinfo info ";
			str += "on info.device_id = colldui.device_id where info.dev_code like '01%') colltmp on colltmp.project_info_id = p.project_info_no ";
			str += "where dy.org_subjection_id like 'C105005004%' and p.project_status = '5000100001000000001' group by colltmp.project_info_id, p.project_info_no, p.project_name,p.project_status ";
			str += "union all ";
			str += "select '电源站' as colname,p.project_info_no,p.project_name,p.project_status,case when colltmp.project_info_id is null then 0 else sum(colltmp.total_num) end as sumtotal ";
			str += "from gp_task_project p left join gp_task_project_dynamic dy on dy.project_info_no = p.project_info_no ";
			str += "left join (select colldui.total_num, colldui.project_info_id from gms_device_coll_account_dui colldui left join gms_device_collectinfo info on info.device_id = colldui.device_id ";
			str += "where info.dev_code like '02%') colltmp on colltmp.project_info_id = p.project_info_no where dy.org_subjection_id like 'C105005004%' and p.project_status = '5000100001000000001' ";
			str += "group by colltmp.project_info_id, p.project_info_no, p.project_name,p.project_status ";
			str += "union all ";
			str += "select '交叉站' as colname,p.project_info_no,p.project_name,p.project_status,case when colltmp.project_info_id is null then 0 else sum(colltmp.total_num) end as sumtotal ";
			str += "from gp_task_project p left join gp_task_project_dynamic dy on dy.project_info_no = p.project_info_no left join (select colldui.total_num, colldui.project_info_id ";
			str += "from gms_device_coll_account_dui colldui left join gms_device_collectinfo info on info.device_id = colldui.device_id where info.dev_code like '03%') colltmp on colltmp.project_info_id = p.project_info_no ";
			str += "where dy.org_subjection_id like 'C105005004%' and p.project_status = '5000100001000000001' group by colltmp.project_info_id, p.project_info_no, p.project_name,p.project_status ";
			str += "union all ";
			str += "select '交叉线' as colname,p.project_info_no,p.project_name,p.project_status,case when colltmp.project_info_id is null then 0 else sum(colltmp.total_num) end as sumtotal ";
			str += "from gp_task_project p left join gp_task_project_dynamic dy on dy.project_info_no = p.project_info_no left join (select colldui.total_num, colldui.project_info_id from gms_device_coll_account_dui colldui ";
			str += "left join gms_device_collectinfo info on info.device_id = colldui.device_id where info.dev_code like '0501%' or info.dev_code like '0502%' or info.dev_code like '0503%' or info.dev_code like '0504%' or info.dev_code like '0505%' ";
			str += "or info.dev_code like '0508%') colltmp on colltmp.project_info_id = p.project_info_no where dy.org_subjection_id like 'C105005004%' and p.project_status = '5000100001000000001' group by colltmp.project_info_id, p.project_info_no, p.project_name,p.project_status ";
			str += "union all ";
			str += "select '排列电缆' as colname,p.project_info_no,p.project_name,p.project_status,case when colltmp.project_info_id is null then 0 else sum(colltmp.total_num) end as sumtotal from gp_task_project p ";
			str += "left join gp_task_project_dynamic dy on dy.project_info_no = p.project_info_no left join (select colldui.total_num, colldui.project_info_id from gms_device_coll_account_dui colldui left join gms_device_collectinfo info on info.device_id = colldui.device_id ";
			str += "where info.dev_code like '0506%' or info.dev_code like '0507%') colltmp on colltmp.project_info_id = p.project_info_no where dy.org_subjection_id like 'C105005004%' and p.project_status = '5000100001000000001' group by colltmp.project_info_id, p.project_info_no, p.project_name,p.project_status) tmp ";
			str += "group by tmp.project_info_no, tmp.project_name,tmp.project_status ) where 1=1 ";			
			
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and projectfull like '%"+v_project_name+"%' ";
		}
		if(v_projectStatus!=undefined && v_projectStatus!=''){
			str += "and project_status = '"+v_projectStatus+"' ";
		}
		
		str += "order by project_info_no ";
		
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
    function loadDataDetail(projectno){
        //var info = device_allapp_id.split("~" , -1); 
        
    	//var retObj;
		//if(device_allapp_id!=null){
		//	 retObj = jcdpCallService("DevCommInfoSrv", "getDevAllAppBaseInfo", "deviceallappid="+info[0]);
			
		//}else{
		//	var ids = getSelIds('selectedbox');
		//    if(ids==''){ 
		//	    alert("请先选中一条记录!");
	   //  		return;
		//    }
		//    info = ids.split("~" , -1); 
		    
		//    retObj = jcdpCallService("DevCommInfoSrv", "getDevAllAppBaseInfo", "deviceallappid="+info[0]);
		//}
		//选中这一条checkbox
		$("#selectedbox_"+projectno).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+projectno+"']").removeAttr("checked");
		//给数据回填
		//$("#project_name","#projectMap").val(retObj.deviceappMap.project_name);
		//$("#device_allapp_name","#projectMap").val(retObj.deviceappMap.device_allapp_name);
		//$("#device_allapp_no","#projectMap").val(retObj.deviceappMap.device_allapp_no);
		//$("#state_desc","#projectMap").val(retObj.deviceappMap.state_desc);
		//$("#org_name","#projectMap").val(retObj.deviceappMap.org_name);
		//$("#employee_name","#projectMap").val(retObj.deviceappMap.employee_name);
		//$("#appdate","#projectMap").val(retObj.deviceappMap.appdate);
		//$("#createdate","#projectMap").val(retObj.deviceappMap.createdate);
		//$("#approvedate","#projectMap").val(retObj.deviceappMap.approve_date);

		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
	function toAddMainPlanPage(){
		if('<%=projectInfoNo%>' == 'null'){
			alert("未选择项目信息!");
			return;
		}
		
		popWindow('<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevplan_new.jsp?');
	}
	function toModifyMainPlanPage(){
		var length = 0;
		var deviceallappid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				deviceallappid = this.value;
				length = length+1;
			}
		});
		
		if(length == 0){
			alert("请选择记录！");
			return;
		}
	      var info = deviceallappid.split("~" , -1); 
		//判断状态如果是已提交，那么不能修改
		var str = "select devapp.device_allapp_id,nvl(wfmiddle.proc_status,'') as proc_status ,devapp.allapp_type ";
			str += "from gms_device_allapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_allapp_id  ";
			str += "where devapp.allapp_type = 'S10002' and devapp.bsflag = '0' ";
			str += "and devapp.device_allapp_id='"+info[0]+"' ";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//只要不在流程中，都可以修改
		var atype = unitRet.datas[0].allapp_type
		if(unitRet.datas[0].proc_status == '' ){
			popWindow('<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevmain_modify.jsp?deviceallappid='+info[0]);
		}else{
			alert("本单据已提交，不能修改!");
			return;
		}
	}
	function toDelPlanPage(){
		var length = 0;
		var deviceallappid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				deviceallappid = this.value;
				length = length+1;
			}
		});
			
		if(length == 0){
			alert("请选择记录！");
			return;
		}
	      var info = deviceallappid.split("~" , -1); 
			
		//判断状态如果是已提交，那么不能删除
		var str = "select devapp.device_allapp_id,nvl(wfmiddle.proc_status,'') as proc_status ";
			str += "from gms_device_allapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_allapp_id  ";
			str += "where devapp.bsflag = '0' and devapp.allapp_type = 'S10002' ";
			str += "and devapp.device_allapp_id='"+info[0]+"' ";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//什么状态不能删除
		if(unitRet.datas[0].proc_status == null||unitRet.datas[0].proc_status == ''||unitRet.datas[0].proc_status == '4'){
			if(confirm("是否执行删除操作?")){
				var sql = "update gms_device_allapp set bsflag='1' where device_allapp_id = '"+info[0]+"' ";
				var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
				var params = "deleteSql="+sql;
				params += "&ids=";
				var retObject = syncRequest('Post',path,params);
				refreshData();
			}
		}else{
			alert("本单据已提交，不能删除!");
			return;
		}
	}
	function toSumbitDevApp(){
		var length = 0;
		var deviceallappid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				deviceallappid = this.value;
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
	      var info = deviceallappid.split("~" , -1); 
			
		//判断状态如果是已提交
		var str = "select devapp.device_allapp_id,nvl(wfmiddle.proc_status,'') as proc_status,devapp.state ";
			str += "from gms_device_allapp devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_allapp_id  ";
			str += "where devapp.bsflag = '0' and devapp.allapp_type = 'S10002' ";
			str += "and devapp.device_allapp_id='"+info[0]+"' ";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//什么状态不能删除，和业务专家确定
		if(unitRet.datas[0].state == null || unitRet.datas[0].proc_status == '' || unitRet.datas[0].proc_status == '4'){
			//判断主记录中是否有明细
			var querySql = "select count(1) as subcount ";
			querySql += "from (select device_allapp_detid from gms_device_allapp_detail appdet where appdet.device_allapp_id ='"+info[0]+"' ) ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			if(basedatas[0].subcount==0){
				alert("您提交的记录没有添加明细,请查看!");
				return;
			}
			if (!window.confirm("确认要提交吗?")) {
				return;
			}
			retObj = jcdpCallService("DevCommInfoSrv", "createAppGetAllappSS", "device_allapp_id="+info[0]);
			submitProcessInfo();
			refreshData();
			alert('提交成功！');
		}else{
			alert("单据已提交，不能重复提交!");
			return;
		}
	}
	
	function toModifyDetail(obj){
		var idinfo = null;
		if(obj!=undefined){
			idinfo = obj.idinfo;
		}else{
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked == true){
					idinfo = this.value;
				}
			});
		}
	      var info = idinfo.split("~" , -1); 

		//window.location.href='<%=contextPath%>/rm/dm/devPlan/devplan_app_frame.jsp?projectInfoNo=<%=projectInfoNo%>&allappType='+info[1]+'&deviceallappid='+info[0]+'&dgFlag='+dgFlag;
		window.location.href='<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevplan_main.jsp?deviceallappid='+info[0];	
	}
	
	//function dbclickRow(shuaId){
	//      var info = shuaId.split("~" , -1); 

	//	window.location.href='<%=contextPath%>/rm/dm/wellsDevCenterPlan/wellsdevplan_main.jsp?deviceallappid='+info[0];
	//}  
	function viewProject(projectNo){
		if(projectNo != ''){
			popWindow('<%=contextPath%>/rm/dm/project/viewProject.jsp?projectInfoNo='+projectNo,'1080:680');						
		}		
	}
	function viewDevice(projectNo,index){
		var typeid="";
		if(index == 6){
			typeid='S1405';
		}
		if(index == 7){
			typeid='S0623';
		}
		if(index == 8){
			typeid='S1404';
		}
		if(projectNo != ''){
			popWindow('<%=contextPath%>/rm/dm/devPlan/viewDevAccountList.jsp?projectInfoNo='+projectNo+'&mixtypeid='+typeid,'1080:680');						
		}		
	}
	function viewCollDevice(projectNo,index){
		if(projectNo != ''){
			popWindow('<%=contextPath%>/rm/dm/devPlan/viewCollAccountList.jsp?projectInfoNo='+projectNo+'&mixtypeid='+index,'1080:680');						
		}		
	}
	function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }
    function toAddDZYD(){
    	popWindow('<%=contextPath%>/rm/dm/devPlan/collDevApply_New.jsp','1080:680');
    }
    //查看明细
    function toViewDZYD(){
    	popWindow('<%=contextPath%>/rm/dm/devPlan/collDevAppList.jsp','1080:680');
    }
  //查看明细
    function toViewKKZY(){
    	popWindow('<%=contextPath%>/rm/dm/devPlan/zyPlanDetailList.jsp','1080:680');
    }
    function toAddCLZY(str){
    	popWindow('<%=contextPath%>/rm/dm/devPlan/zyclAddPlanApply.jsp?zcFlag='+str,'1080:680');
    }
    function toSubmit(){
        alert("提交成功!");
        return;
    }
</script>
</html>