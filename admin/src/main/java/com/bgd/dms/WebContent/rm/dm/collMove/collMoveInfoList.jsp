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
  <title>配置计划申请</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddDevInfo()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyMainPlanPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelPlanPage()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSumbitDevApp()'" title="提交"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{dev_mov_id}' name='dev_mov_id' idinfo='{dev_mov_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{dev_mov_id}' id='selectedbox_{dev_mov_id}' />" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_mov_no}">转移单号</td>
					<td class="bt_info_even" exp="{dev_mov_name}">转移单名称</td>
					<td class="bt_info_odd" exp="{out_project_name}"> 转出项目名称</td>
					<td class="bt_info_even" exp="{in_project_name}">转入项目名称</td>
					<td class="bt_info_odd" exp="{opertor}">经办人</td>
					<td class="bt_info_even" exp="{apply_date}">申请时间</td>
					<td class="bt_info_odd" exp="{mov_state}">转移状态</td>
					<td class="bt_info_even" exp="{state_desc}">审批状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">转移单号：</td>
				      <td  class="inquire_form6" ><input id="dev_mov_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">转移单名称：</td>
				      <td  class="inquire_form6"><input id="dev_mov_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;转出项目名称：</td>
				      <td  class="inquire_form6"  ><input id="out_project_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">转入项目名称：</td>
				     <td  class="inquire_form6"><input id="in_project_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;经办人：</td>
				     <td  class="inquire_form6"><input id="opertor" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     <td  class="inquire_item6">申请时间：</td>
				     <td  class="inquire_form6"><input id="apply_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				     <td  class="inquire_item6">&nbsp;转移状态：</td>
				     <td  class="inquire_form6"><input id="mov_state" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;审核状态：</td>
				     <td  class="inquire_form6"><input id="state_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td colspan='2'>&nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table id="detailtitletable" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" style="margin-top:10px;background:#efefef;width:98.5%"> 
						<tr class="bt_info">
				            <td class="bt_info_even">序号</td>
							<td class="bt_info_even" width="10%">设备名称</td>
							<td class="bt_info_odd" width="10%">规格型号</td>
							<td class="bt_info_even" width="5%">单位</td>
							<td class="bt_info_odd" width="8%">总数量</td>
							<td class="bt_info_even" width="8%">在队数量</td>
							<td class="bt_info_odd" width="8%">离队数量</td>
							<td class="bt_info_even" width="8%">本次转移数量</td>
							<td class="bt_info_odd" width="13%">实际进场时间</td>
							<td class="bt_info_even" width="13%">实际离场时间</td>
				    </tr>
					</table>
					<div style="height:70%;overflow:auto;">
				      	<table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					   		<tbody id="detailMap" name="detailMap" >
					   		</tbody>
				      	</table>
			        </div>
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
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				currentid = this.value;
			}
		});
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = "select dui.dev_name,dui.dev_model,d.coding_name as dev_unit,dui.total_num,dui.unuse_num,nvl(dui.use_num,0) as use_num,t.mov_num,dui.actual_in_time,t.actual_out_time from gms_device_move_detail t left join gms_device_coll_account_dui dui on t.dev_acc_id=dui.dev_acc_id left join comm_coding_sort_detail d on dui.dev_unit=d.coding_code_id  where t.dev_mov_id='"+currentid+"'";
				
				var param = new Object();
				
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
		}else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
		//对标题行的宽度进行设置
		var titletrid = "#detailtitletable";
		var contentid = "#detailMap";
		aligntitle(titletrid,contentid);
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].dev_unit+"</td><td>"+datas[i].total_num+"</td><td>"+datas[i].unuse_num+"</td>";
			innerHTML += "<td>"+datas[i].use_num+"</td><td>"+datas[i].mov_num+"</td><td>"+datas[i].actual_in_time+"</td>";
			innerHTML += "<td>"+datas[i].actual_out_time+"</td>";
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
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function clearQueryText(){
		$("#s_project_name").val("");
		$("#s_org_name").val("");
	}
	function searchDevData(){
		var v_project_name = document.getElementById("s_project_name").value;
		var v_org_name = document.getElementById("s_org_name").value;
		refreshData(v_project_name, v_org_name);
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
	
    function refreshData(v_project_name,v_org_name){
		var str = "select t.dev_mov_id,t.dev_mov_no,t.dev_mov_name,outgp.project_name as out_project_name,ingp.project_name as in_project_name,u.user_name as opertor,t.apply_date, case when t.out_project_info_id='"+projectInfoNos+"' then '转出' else '转入' end as mov_state,case wfmiddle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc from gms_device_move t left join gp_task_project outgp on t.out_project_info_id=outgp.project_info_no left join gp_task_project ingp on t.in_project_info_id=ingp.project_info_no left join p_auth_user u on t.opertor_id=u.user_id left join common_busi_wf_middle wfmiddle on t.dev_mov_id=wfmiddle.business_id where (t.out_project_info_id='"+projectInfoNos+"' or t.in_project_info_id='"+projectInfoNos+"') and t.dev_type='coll' and t.bsflag='0'"
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
    function loadDataDetail(dev_mov_id){
    	var retObj;
		if(dev_mov_id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevMovBaseInfo", "devMovId="+dev_mov_id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevMovBaseInfo", "devMovId="+ids);
		}
		//取消其他选中的 
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.dev_mov_id+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj.deviceappMap.dev_mov_id+"']").attr("checked",'checked');
		//给数据回填
		$("#dev_mov_no","#projectMap").val(retObj.deviceappMap.dev_mov_no);
		$("#dev_mov_name","#projectMap").val(retObj.deviceappMap.dev_mov_name);
		$("#out_project_name","#projectMap").val(retObj.deviceappMap.out_project_name);
		$("#in_project_name","#projectMap").val(retObj.deviceappMap.in_project_name);
		$("#state_desc","#projectMap").val(retObj.deviceappMap.state_desc);
		$("#opertor","#projectMap").val(retObj.deviceappMap.opertor);
		$("#apply_date","#projectMap").val(retObj.deviceappMap.apply_date);
		$("#mov_state","#projectMap").val(retObj.deviceappMap.mov_state);
		$("#state_desc","#projectMap").val(retObj.deviceappMap.state_desc);
		var dev_mov_name = retObj.deviceappMap.dev_mov_name;
		var dev_mov_no = retObj.deviceappMap.dev_mov_no;
		var dev_mov_id = retObj.deviceappMap.dev_mov_id;
		var curbusinesstype = "";
		if(project_type == '5000100004000000008'){//井中
			curbusinesstype = "5110000004100001060";
		}else{
			curbusinesstype = "5110000004100000097";
		}
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		//工作流信息
		var submitdate =getdate();
    	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"gms_device_move",    			//置入流程管控的业务表的主表表明
			businessType:curbusinesstype,    //业务类型 即为之前设置的业务大类
			businessId:dev_mov_id,           				//业务主表主键值
			businessInfo:"设备转移审批信息<设备转移单名称:"+dev_mov_name+">",
			applicantDate:submitdate       						//流程发起时间
		};
		processAppendInfo={ 
			projectName:projectName,								//流程引擎附加临时变量信息
			projectInfoNo:projectInfoNos,
			devMovId:dev_mov_id
		};
    	loadProcessHistoryInfo();
    }
    //过滤界面查询
	function toFilterPage(){
		//popWindow('<%=contextPath%>/doc/singleproject/doc_search.jsp');
	}
	
	//新增
	function toAddDevInfo(){
		
		popWindow('<%=contextPath%>/rm/dm/collMove/collMoveNewApply.jsp?projectInfoNo=<%=projectInfoNo%>','950:680');
		
	}
	function toModifyMainPlanPage(){
		var devMovId='';
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				devMovId = this.value;
			}
		});
		if(devMovId==''){ 
		    alert("请先选中一条记录!");
     		return;
	    }
		//判断状态如果是已提交，那么不能删除
		var str = "select devapp.dev_mov_id,nvl(wfmiddle.proc_status,'') as proc_status ";
			str += "from gms_device_move devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.dev_mov_id  ";
			str += "where devapp.dev_mov_id ='"+devMovId+"'";
		
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//只要不在流程中，都可以修改
		if(unitRet.datas[0].proc_status == ''||unitRet.datas[0].proc_status == '4' ){
			var deviceallappid ;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked == true){
					deviceallappid = this.value;
				}
			});
			popWindow('<%=contextPath%>/rm/dm/collMove/collMoveNewModefy.jsp?projectInfoNo=<%=projectInfoNo%>&devMovId='+devMovId,'950:680');
		}else{
			alert("本单据已提交，不能修改!");
			return;
		}
	}
	function toDelPlanPage(){
		var devMovId ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				devMovId = this.value;
			}
		});
		//判断状态如果是已提交，那么不能删除
		var str = "select devapp.dev_mov_id,nvl(wfmiddle.proc_status,'') as proc_status ";
			str += "from gms_device_move devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.dev_mov_id  ";
			str += "where devapp.dev_mov_id ='"+devMovId+"'";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//什么状态不能删除，和业务专家确定
		if(unitRet.datas[0].proc_status == null||unitRet.datas[0].proc_status == ''||unitRet.datas[0].proc_status == '4'){
			if(confirm("是否执行删除操作?")){
				var sql = "update gms_device_move set bsflag='1' where dev_mov_id ='"+devMovId+"'";
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
		var devMovId ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				devMovId = this.value;
			}
		});
		//判断状态如果是已提交，那么不能删除
		var str = "select devapp.dev_mov_id,nvl(wfmiddle.proc_status,'') as proc_status ";
			str += "from gms_device_move devapp  ";
			str += "left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.dev_mov_id  ";
			str += "where devapp.dev_mov_id ='"+devMovId+"'";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		//什么状态不能删除，和业务专家确定
		if(unitRet.datas[0].state == null || unitRet.datas[0].proc_status == '' || unitRet.datas[0].proc_status == '4'){
			if (!window.confirm("确认要提交吗?")) {
				return;
			}
			submitProcessInfo();
			//给申请时添加的实际离场时间，更新到队级台账中
			//var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			//var detsql = "update gms_device_account_dui dui set dui.actual_out_time=(select t.actual_out_time from gms_device_move_detail t where t.dev_mov_id in ('"+devMovId+"') and t.dev_acc_id=dui.dev_acc_id) ";
			//detsql += "where exists(select 1 from gms_device_move_detail t where t.dev_acc_id=dui.dev_acc_id and t.dev_mov_id in ('"+devMovId+"'))";
			//var params = "deleteSql="+detsql;
			//params += "&ids=";
			//var retObject = syncRequest('Post',path,params);
			refreshData();
			alert('提交成功！');
		}
		else{
			alert("单据已提交！");
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
		window.location.href='<%=contextPath%>/rm/dm/devPlan/devplan_app_frame.jsp?projectInfoNo=<%=projectInfoNo%>&deviceallappid='+idinfo;
	}
	
    //chooseOne()函式，參數為觸發該函式的元素本身   
   function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }
</script>
</html>