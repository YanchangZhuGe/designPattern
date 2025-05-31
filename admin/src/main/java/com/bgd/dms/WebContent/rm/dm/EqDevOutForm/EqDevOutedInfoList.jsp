<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
	String devmixid = request.getParameter("devMixId");
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

  <title>装备设备出库单列表</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			 <div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			   <!-- <td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="s_project_name" name="s_project_name" type="text" /></td>
			    <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input"><input id="s_appinfo_name" name="s_appinfo_name" type="text" /></td>
			    <td class="ali_cdn_name">调配单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>-->
			    <td class="ali_cdn_name">出库单号</td>
			    <td class="ali_cdn_input"><input id="s_outinfo_no" name="s_outinfo_no" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
 			    <!--<auth:ListButton functionId="" css="zj" event="onclick='toAddDetailPage()'" title="出库"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyDetailPage()'" title="编辑"></auth:ListButton>
 					<auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="关闭"></auth:ListButton>-->
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
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' outstate='{state}' value='{device_outinfo_id}~{device_mixinfo_id}' id='selectedbox_{device_outinfo_id}~{device_mixinfo_id}' />" >选择</td>
					<!-- <td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{project_name}">项目名称</td>
					<td class="bt_info_odd" exp="{device_app_name}">申请单名称</td>
					<td class="bt_info_even" exp="{device_app_no}">调配申请单号</td>
					<td class="bt_info_odd" exp="{mixinfo_no}">调配单号</td>
					<td class="bt_info_even" exp="{create_date}">调配时间</td>
					<td class="bt_info_odd" exp="{in_org_name}">接收单位</td> -->
					<td class="bt_info_even" exp="{out_org_name}">转出单位</td>
					<!-- <td class="bt_info_odd" exp="{opr_state_desc}">处理状态</td> -->
					<td class="bt_info_even" exp="{outinfo_no}">出库单号</td>
					<td class="bt_info_odd" exp="{employee_name}">经办人</td>
					<td class="bt_info_even" exp="{out_date}">出库时间</td>
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
			    <!-- <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">审批信息</a></li> -->
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <!--<li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li> -->
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
				<td class="inquire_item6">申请时间</td>
				<td class="inquire_form6"><input id="dev_create_date" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="11%">AMIS资产编号</td>
							<td class="bt_info_odd" width="6%">自编号</td>
							<td class="bt_info_even" width="6%">实物标识号</td>
							<td class="bt_info_odd" width="6%">牌照号</td>
							<td class="bt_info_even" width="6%">设备类别</td>
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
		var currentid;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
				currentid = currentid.split("~")[0];
			}
		});
		if(index == 1){
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && currentid == idinfo){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//看是否有outid信息，有的话，则查询其明细
				var idinfos = currentid.split("~" , -1);
				if(idinfos[0]!=null){
					//先进行查询
					var prosql = "select ct.dev_ct_name, ci.dev_ci_name,ci.dev_ci_model,asset_coding,self_num,license_num,dev_sign,'调剂明细' as devtye ";
					prosql += "from gms_device_equ_outdetail od ";
					prosql += "left join gms_device_codeinfo ci on od.dev_ci_code=ci.dev_ci_code ";
					prosql += "left join gms_device_codetype ct on ct.dev_ct_code=ci.dev_ct_code ";
					prosql += "left join gms_device_equ_outsub os on os.device_oif_subid=od.device_oif_subid ";
					prosql += "where os.device_outinfo_id='"+idinfos[0]+"'";
					prosql += "union all ";
					prosql += "select ct.dev_ct_name, ci.dev_ci_name,ci.dev_ci_model,asset_coding,self_num,license_num,dev_sign,'补充明细' as devtye ";
					prosql += "from gms_device_equ_outdetail_added od ";
					prosql += "left join gms_device_codeinfo ci on od.dev_ci_code=ci.dev_ci_code ";
					prosql += "left join gms_device_codetype ct on ct.dev_ct_code=ci.dev_ct_code ";
					prosql += "where od.device_outinfo_id='"+idinfos[0]+"'";
					var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql+"&pageSize=1000");
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
					$(filterobj).attr("idinfo",currentid)
				}
			}
		}
		else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/multiproject/common_doc_list_eps.jsp?relationId="+currentid);
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
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_ci_name+"</td><td>"+datas[i].dev_ci_model+"</td>";
			innerHTML += "<td>"+datas[i].asset_coding+"</td><td>"+datas[i].self_num+"</td>";
			innerHTML += "<td>"+datas[i].dev_sign+"</td><td>"+datas[i].license_num+"</td><td>"+datas[i].dev_ct_name+"</td>";
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
		if(outstate=='9'||outstate=='0'){
			
		}
		else{
			alert("本调配单状态不是'已调配'，不能打印!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			//调用打印方法
			var path = cruConfig.contextPath+"/rm/dm/common/DmDocToExcel.srq";
			var submitStr = "baseTableName=gms_device_equ_outform&baseid="+info[0]+"&subTableName=gms_device_equ_outdetail";
			var retObj = syncRequest("post", path, submitStr);
			var filename=retObj.excelName;
			filename = encodeURI(filename);
			filename = encodeURI(filename);
			var showname=retObj.showName;
			showname = encodeURI(showname);
			showname = encodeURI(showname);
			window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
		}else{
			alert("您尚未开据本申请单对应的调配单，请查看!");
			return;
		}
	}
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function searchDevData(){
		//var v_appinfo_name = document.getElementById("s_appinfo_name").value;
		//var v_mixinfo_no = document.getElementById("s_mixinfo_no").value;
		var v_outinfo_no = document.getElementById("s_outinfo_no").value;
		//var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_outinfo_no);
	}
	
	//清空查询条件
    function clearQueryText(){
    	//document.getElementById("s_appinfo_name").value="";
    	//document.getElementById("s_mixinfo_no").value="";
		document.getElementById("s_outinfo_no").value="";
		//document.getElementById("s_project_name").value="";
    }
	
	function refreshData(v_outinfo_no){
		var str = "select mix.device_mixinfo_id,mix.mixinfo_no,pro.project_name,mix.create_date,devapp.device_app_no,devapp.device_app_name,"+
				"inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,"+
				"he.employee_name,outform.device_outinfo_id,outform.outinfo_no,outform.receive_state,outform.out_date, "+
				"outform.state,case mix.opr_state when '1' then '处理中' when '9' then '已处理' when '4' then '已关闭' else '未处理' end as opr_state_desc  "+
				"from gms_device_mixinfo_form mix "+
				"left join gms_device_app devapp on mix.device_app_id=devapp.device_app_id " +
				"left join gp_task_project pro on mix.project_info_no=pro.project_info_no "+
				"left join comm_org_information inorg on mix.in_org_id=inorg.org_id "+
				"left join comm_org_information outorg on mix.out_org_id=outorg.org_id "+
				"left join gms_device_equ_outform outform on outform.device_mixinfo_id=mix.device_mixinfo_id and outform.bsflag='0' "+
				"left join comm_human_employee he on outform.print_emp_id=he.employee_id ";
				//加机构权限
		str += "left join comm_org_subjection orgsub on mix.out_org_id=orgsub.org_id and orgsub.bsflag='0' ";
		str += "where mix.bsflag='0' and mix.device_mixinfo_id = '<%=devmixid%>' ";

		//if(v_appinfo_name!=undefined && v_appinfo_name!=''){
		//	str += "and devapp.device_app_name like '%"+v_appinfo_name+"%' ";
		//}
		//if(v_mixinfo_no!=undefined && v_mixinfo_no!=''){
		//	str += "and mix.mixinfo_no like '%"+v_mixinfo_no+"%' ";
		//}
		if(v_outinfo_no!=undefined && v_outinfo_no!=''){
			str += "and outform.outinfo_no like '%"+v_outinfo_no+"%' ";
		}
		//if(v_project_name!=undefined && v_project_name!=''){
		//	str += "and pro.project_name like '%"+v_project_name+"%' ";
		//}
		str += "order by outform.state nulls first,outform.modifi_date desc,mix.modifi_date desc,mix.project_info_no ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	function toAddDetailPage(){
		var shuaId ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				shuaId = this.value;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[1]!=''){
			popWindow('<%=contextPath%>/rm/dm/EqDevOutForm/eqDevOutInfoNew.jsp?mixInfoId='+info[1],'950:680');
		}
	}
	function toModifyDetailPage(){
		var shuaId ;
		var outstate ;
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
		if(outstate=='9'){
			alert("本出库单已提交，不能修改!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			popWindow('<%=contextPath%>/rm/dm/EqDevOutForm/eqDevOutInfoModify.jsp?outInfoId='+info[0]+'&mixInfoId='+info[1],'950:680');
		}else{
			alert("您尚未开据本调配单对应的出库单，请查看!");
			return;
		}
	}
	//function dbclickRow(shuaId){
	//	var info = shuaId.split("~" , -1);
	//	if(info[0]!=''){
	//		var outstate ;
//			$("input[type='checkbox'][name='selectedbox']").each(function(){
	//			if(this.checked){
//					outstate = this.outstate;
//				}
//			});
//			if(outstate=='9'){
//				alert("本出库单已提交，不能修改!");
//				return;
//			}
//			popWindow('<%=contextPath%>/rm/dm/EqDevOutForm/eqDevOutInfoModify.jsp?outInfoId='+info[0]+'&mixInfoId='+info[1],'950:680');
//		}else{
//			popWindow('<%=contextPath%>/rm/dm/EqDevOutForm/eqDevOutInfoNew.jsp?mixInfoId='+info[1],'950:680');
//		}
//	}
	function toDelRecord(){
		var length = 0;
		var idinfo;
		var delflag = false;
		var addflag = 0;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
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
				length = length+1;
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
			var sql = "update gms_device_equ_outform set bsflag='1' where device_outinfo_id in ("+idinfos+")";
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
			var str = "select mix.device_mixinfo_id,mix.mixinfo_no,pro.project_name,mix.create_date, "+
			"inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,"+
			"he.employee_name,outform.device_outinfo_id,outform.outinfo_no,outform.receive_state,outform.out_date,outform.state, "+
			"case outform.state when '0' then '出库中' when '9' then '已出库' else '待出库' end as outstate_desc  "+
			"from gms_device_mixinfo_form mix "+
			"left join gp_task_project pro on mix.PROJECT_INFO_NO=pro.project_info_no "+
			"left join comm_org_information inorg on mix.in_org_id=inorg.org_id "+
			"left join comm_org_information outorg on mix.out_org_id=outorg.org_id "+
			"left join comm_human_employee he on mix.print_emp_id=he.employee_id "+
			"left join gms_device_equ_outform outform on outform.device_mixinfo_id=mix.device_mixinfo_id "+
			"where mix.bsflag='0' and outform.device_outinfo_id='"+info[0]+"'";
			var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
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
			$("#dev_state").val(retObj[0].receive_state);
		}else{
			//根据ids去查找 调配单
			var str = "select cmf.device_mixinfo_id,tp.project_name,inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name ";
				str += "from gms_device_mixinfo_form cmf  "
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