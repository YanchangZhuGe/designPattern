<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
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
  <title>装备内部返还</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">返还申请单号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_device_backapp_no" name="s_device_backapp_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">返还单名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_backapp_name" name="s_backapp_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">接收单位</td>
			    <td class="ali_cdn_input">
			    	<input id="s_org_name" name="s_org_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddBackPlanPage()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyBackPlanPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelMixPlanPage()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
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
			     <tr>
			     	<td class="bt_info_odd" exp="<input type='checkbox' id='selectedbox_{device_repapp_id}' name='selectedbox' value='{device_repapp_id}' stateinfo='{state}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{device_repapp_no}">返还申请单号</td>
					<td class="bt_info_even" exp="{repapp_name}">返还申请单名称</td>
					<td class="bt_info_odd" exp="{rep_org_name}">返还申请单位</td>
					<td class="bt_info_even" exp="{receive_org_name}">接收单位</td>
					<td class="bt_info_odd" exp="{rep_employee_name}">申请人</td>
					<td class="bt_info_even" exp="{repdate}">申请时间</td>
					<td class="bt_info_odd" exp="{state_desc}">状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td   class="inquire_item6">返还申请单号：</td>
				      <td   class="inquire_form6" ><input id="device_repapp_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">返还申请单名称</td>
				      <td  class="inquire_form6" ><input id="repapp_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">申请时间：</td>
				      <td  class="inquire_form6"><input id="repdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				     </tr>
				    <tr>
				      
				     <td  class="inquire_item6">返还单位：</td>
				     <td  class="inquire_form6"><input id="rep_org_name" class="input_width" type="text"  value="" disabled/>&nbsp;</td>
				     <td  class="inquire_item6">接收单位：</td>
				     <td  class="inquire_form6"><input id="receive_org_name" class="input_width" type="text"  value="" disabled/>&nbsp;</td>
				     <td  class="inquire_item6">申请人：</td>
				     <td  class="inquire_form6"><input id="rep_employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				 </table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="11%">计量单位</td>
							<td class="bt_info_odd" width="9%">返还数量</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
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
    var selectedTagIndex=0;
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
				var str = "select dev_name,dev_model,rep_num,sd.coding_name as unit_name from gms_device_collrepapp_detail det "+
					"left join comm_coding_sort_detail sd on det.dev_unit=sd.coding_code_id where device_repapp_id='"+currentid+"' and det.bsflag='0'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
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
	}
	
	function appendDataToDetailTab(filterobj,datas){
		
		for(var i=0;i<basedatas.length;i++){
			
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].dev_name+"</td>";
			innerHTML += "<td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].unit_name+"</td>";
			innerHTML += "<td>"+datas[i].rep_num+"</td>";
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

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
	
    function refreshData(v_device_backapp_no, v_backapp_name, v_org_name){
		var str = "select collrep.device_repapp_id,collrep.device_repapp_no,collrep.repapp_name,pro.project_name,"
			+"org.org_abbreviation as rep_org_name,recvorg.org_abbreviation as receive_org_name,"
			+"emp.employee_name as rep_employee_name,collrep.repdate,collrep.state,"
			+"case middle.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end as state_desc "
			+"from gms_device_collrepapp collrep "
			+"left join common_busi_wf_middle middle on middle.business_id = collrep.device_repapp_id and  middle.bsflag='0' "
			+"left join gp_task_project pro on collrep.project_info_id = pro.project_info_no "
			+"left join comm_org_information org on collrep.rep_org_id = org.org_id "
			+"left join comm_org_information recvorg on collrep.receive_org_id = recvorg.org_id "
			+"left join comm_human_employee emp on collrep.rep_employee_id = emp.employee_id ";
			str += "where collrep.bsflag = '0' and repapptype='2' ";
		if(v_device_backapp_no!=undefined && v_device_backapp_no!=''){
			str += "and colback.device_repapp_no like '%"+v_device_backapp_no+"%' ";
		}
		if(v_backapp_name!=undefined && v_backapp_name!=''){
			str += "and colback.repapp_name like '%"+v_backapp_name+"%' ";
		}
		if(v_org_name!=undefined && v_org_name!=''){
			str += "and recvorg.org_name like '%"+v_org_name+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	function searchDevData(){
		var v_device_backapp_no = document.getElementById("s_device_backapp_no").value;
		var v_backapp_name = document.getElementById("s_backapp_name").value;
		var v_org_name = document.getElementById("s_org_name").value;
		refreshData(v_device_backapp_no, v_backapp_name, v_org_name);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_device_backapp_no").value="";
		document.getElementById("s_backapp_name").value="";
		document.getElementById("s_org_name").value="";
    }
	function loadDataDetail(devicebackappid){
    	var retObj;
    	var querySql = "select collrep.device_repapp_id,collrep.device_repapp_no,collrep.repapp_name,pro.project_name,"
			+"org.org_abbreviation as rep_org_name,recvorg.org_abbreviation as receive_org_name,"
			+"emp.employee_name as rep_employee_name,collrep.repdate,"
			+"case collrep.state when '0' then '未提交' when '9' then '已提交' end as state_desc "
			+"from gms_device_collrepapp collrep "
			+"left join gp_task_project pro on collrep.project_info_id = pro.project_info_no "
			+"left join comm_org_information org on collrep.rep_org_id = org.org_id "
			+"left join comm_org_information recvorg on collrep.receive_org_id = recvorg.org_id "
			+"left join comm_human_employee emp on collrep.rep_employee_id = emp.employee_id ";
		if(devicebackappid!=null){
			querySql += " where collrep.device_repapp_id='"+devicebackappid+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    querySql += " where collrep.device_repapp_id='"+ids+"'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			
		}
		retObj = queryRet.datas;
		//取消其他选中的 
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_repapp_id+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_repapp_id+"']").attr("checked",'checked');
		//给数据回填
		$("#device_repapp_no","#projectMap").val(retObj[0].device_repapp_no);
		$("#repapp_name","#projectMap").val(retObj[0].repapp_name);
		$("#rep_org_name","#projectMap").val(retObj[0].rep_org_name);
		$("#receive_org_name","#projectMap").val(retObj[0].receive_org_name);
		$("#rep_employee_name","#projectMap").val(retObj[0].rep_employee_name);
		$("#repdate","#projectMap").val(retObj[0].repdate);
		
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		//工作流信息
		var submitdate =getdate();
    	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"gms_device_collrepapp",    		//置入流程管控的业务表的主表表明
			businessType:"5110000004100000071",    				//业务类型 即为之前设置的业务大类
			businessId:retObj[0].device_repapp_id,           				//业务主表主键值
			businessInfo:"设备配置计划审批列表信息<申请单名称:"+retObj[0].repapp_name+";申请单单号:"+retObj[0].device_repapp_no+">",
			applicantDate:submitdate       						//流程发起时间
		};
		processAppendInfo={ 									//流程引擎附加临时变量信息
			devicerepappid:retObj[0].device_repapp_id
		};
    	loadProcessHistoryInfo();
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
	//新增
	function toAddBackPlanPage(){
		popWindow('<%=contextPath%>/rm/dm/collectTransferBack/plan_new_apply.jsp');
	}
	//修改 需要调整 用新界面
	function toModifyBackPlanPage(){
		var devicerepappid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				devicerepappid = this.value;
			}
		});
		if(devicerepappid==undefined){
			alert("请选择需要修改的申请单记录!");
			return;
		}
		var icount = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(i){
			if(this.checked){
				if(icount!=0){
					selectedid += ",";
				}
				selectedid += this.value;
			}
		});
		//判断状态
		var querySql = "select device_repapp_id,wf.proc_status as state ";
		querySql += "from gms_device_collrepapp repapp left join common_busi_wf_middle wf on repapp.device_repapp_id=wf.business_id ";
		querySql += "where device_repapp_id ='"+selectedid+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		var alertinfo ;
		if(basedatas[0].state == '1' ){
			stateflag = true;
			alertinfo = "您选择的记录已提交,不能修改!";
			alert(alertinfo)
			return;
		}else if(basedatas[0].state == '3' ){
			stateflag = true;
			alertinfo = "您选择的记录已审批,不能修改!";
			alert(alertinfo)
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/collectTransferBack/plan_new_modefy.jsp?devicerepappid='+devicerepappid);
	}
	//删除
	function toDelMixPlanPage(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += this.value;
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		//判断状态
		var querySql = "select device_repapp_id,wf.proc_status as state ";
		querySql += "from gms_device_collrepapp repapp left join common_busi_wf_middle wf on repapp.device_repapp_id=wf.business_id ";
		querySql += "where device_repapp_id ='"+selectedid+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		var alertinfo ;
		if(basedatas[0].state == '1' ){
			stateflag = true;
			alertinfo = "您选择的记录已提交,不能删除!";
			alert(alertinfo)
			return;
		}else if(basedatas[0].state == '3' ){
			stateflag = true;
			alertinfo = "您选择的记录已审批,不能删除!";
			alert(alertinfo)
			return;
		}
		if(confirm("是否执行删除操作?")){
			var sql = "update gms_device_collrepapp set bsflag='1' where device_repapp_id in ('"+selectedid+"')";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
	//提交
	function toSumbitDevApp(){
		var id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
		if(id==undefined){
			alert("请选择需要提交的返还单记录!");
			return;
		}
		//查询是否有明细，有则才能提交
		var str = "select repadddet.device_repdet_id from gms_device_collrepapp_detail repadddet ";
		str += "where repadddet.device_repapp_id='"+id+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		basedatas = queryRet.datas;
		if(basedatas==undefined||basedatas.length==0){
			alert("请添加明细信息之后再提交!");
			return;
		}
		//提交主表单据，触发审批流程
		submitProcessInfo();
		refreshData();
		alert('提交成功！');
	}
	
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }
</script>
</html>