<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String devappid = request.getParameter("devappid");

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
  <title>���������Ŀ������ϸҳ��</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali3">���뵥��</td>
			    <td class="ali1"><input id="s_device_app_no" name="s_device_app_no" type="text" onkeypress="simpleRefreshData()"/></td>
			    <td class="ali3">��Ŀ����</td>
			    <td class="ali1"><input id="s_project_name" name="s_project_name" type="text" onkeypress="simpleRefreshData()"/></td>
			    <td>&nbsp;</td>
			    <td><span class="gl"><a href="#" onclick=""></a></span></td>
			    <td><span class="ck"><a href="#" onclick="searchDevData()"></a></span></td>
			    <td><span class="jh"><a href="#" onclick="toMixDetail();"></a></span></td>
				<td><span class="fh"><a href="#"  onclick="javascript:window.history.back();"></a></span></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_mix_id}' name='device_mix_id'>
			        <td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_mix_id}' id='selectedbox_{device_mix_id}'  onclick='chooseOne(this)'/>" >ѡ��</td>
					<td class="bt_info_even" autoOrder="1">���</td>
					<td class="bt_info_odd" exp="{project_name_1}">��Ŀ����</td>
					<td class="bt_info_even" exp="{job_line}">��ҵ����</td>
					<td class="bt_info_odd" exp="{dev_ci_name}">�豸����</td>
					<td class="bt_info_even" exp="{dev_ci_model}">����ͺ�</td>
					<td class="bt_info_odd" exp="{apply_num}">��������</td>
					<td class="bt_info_even" exp="{approve_num}">��������</td>
					<td class="bt_info_even" exp="{employee_name}">������</td>
					<td class="bt_info_odd" exp="{plan_start_date}">�ƻ���ʼʱ��</td>
					<td class="bt_info_even" exp="{plan_end_date}">�ƻ�����ʱ��</td>
					<td class="bt_info_odd" exp="{assign_num}">��������</td>
					<td class="bt_info_even" exp="{assign_emp_name}">������</td>
					<td class="bt_info_odd" exp="{record}">������ϸ����</td>
					<td class="bt_info_even" exp="{assigned_num}">������ϸ����</td>
			     </tr> 
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">��1/1ҳ����0����¼</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">�� 
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">������Ϣ</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">����</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(2)">������ϸ��Ϣ</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="devdetailMap" name="devdetailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td   class="inquire_item6">��Ŀ���ƣ�</td>
				      <td   class="inquire_form6" ><input id="project_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">&nbsp;��ҵ���ƣ�</td>
				      <td  class="inquire_form6"  ><input id="job_line" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">�豸���ƣ�</td>
				     <td  class="inquire_form6"><input id="dev_ci_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;����ͺţ�</td>
				     <td  class="inquire_form6"><input id="dev_ci_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				    </tr>
				    <tr> 
				     <td  class="inquire_item6">�ƻ���ʼʱ�䣺</td>
				     <td  class="inquire_form6"><input id="plan_start_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;�ƻ�����ʱ�䣺</td>
				     <td  class="inquire_form6"><input id="plan_end_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				     <td  class="inquire_item6">����������</td>
				     <td  class="inquire_form6"><input id="apply_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;�����ˣ�</td>
				     <td  class="inquire_form6"><input id="apply_user" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				     <td  class="inquire_item6">����������</td>
				     <td  class="inquire_form6"><input id="approve_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;�����ˣ�</td>
				     <td  class="inquire_form6"><input id="approve_user" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				     <td  class="inquire_item6">����������</td>
				     <td  class="inquire_form6"><input id="assign_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;�����ˣ�</td>
				     <td  class="inquire_form6"><input id="mix_user" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
					</table>
				</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
			
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

$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var v_device_app_no = document.getElementById("s_device_app_no").value;
			var v_project_name = document.getElementById("s_project_name").value;
			refreshData(v_device_app_no, v_project_name);
		}
	}
	
	function searchDevData(){
		var v_device_app_no = document.getElementById("s_device_app_no").value;
		var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_device_app_no, v_project_name);
	}
	
	function refreshData(v_device_app_no,v_project_name){
		var str = "select '����' as project_name_1,pro.project_name,det.device_appdet_id,det.project_info_id,";
		str += "det.job_line, ci.dev_ci_name, ci.dev_ci_model, det.apply_num, det.approve_num,det.team, det.purpose,";
		str += "det.employee_id, det.plan_start_date,det.plan_end_date,employee.employee_name,approveemp.employee_name as approve_name,";
		str += "mixmain.device_mix_id,mixmain.assign_num,mixmain.assign_emp_id,mixmainemp.employee_name as assign_emp_name,tmp.assigned_num,tmp.record ";
		str += "from gms_device_app_detail det left join gms_device_app devapp on det.device_app_id=devapp.device_app_id ";
		str += "left join gp_task_project pro on det.project_info_id=pro.project_info_no ";
		str += "left join gms_device_codeinfo ci on det.dev_ci_code=ci.dev_ci_code ";
		str += "left join gms_device_appmix_main mixmain on mixmain.device_appdet_id = det.device_appdet_id ";
		str += "left join comm_human_employee mixmainemp on mixmain.assign_emp_id = mixmainemp.employee_id ";
		str += "left join (select mdm.device_mix_id, sum(real_assign_num) as assigned_num, count(1) as record from gms_device_mixdetail_main mdm group by device_mix_id) tmp";
		str += " on tmp.device_mix_id = mixmain.device_mix_id ";
		str += "left join comm_human_employee employee on det.employee_id=employee.employee_id ";
		str += "left join comm_human_employee approveemp on det.approve_id=approveemp.employee_id ";
		str += "where devapp.bsflag='0' and devapp.device_app_id='<%=devappid%>' and mixmain.state='9' ";
		if(v_device_app_no!=undefined && v_device_app_no!=''){
			str += "and devapp.v_device_app_no = '"+v_device_app_no+"' ";
		}
		//TODO �������ƵĲ�ѯ����
		/*
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and project.v_project_name like '"+v_dev_ci_model+"%' ";
		}
		*/
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}

	function toMixDetail(){
		var id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
    	popWindow('<%=contextPath%>/rm/dm/devmixdetail/planMixDetail.jsp?device_mix_id='+id);
    }  
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

    //chooseOne()��ʽ���������|�lԓ��ʽ��Ԫ�ر���   
    function chooseOne(cb){   
        //��ȡ��ͬname��chekcBox�ļ������   
        var obj = document.getElementsByName("selectedbox");   
        for (i=0; i<obj.length; i++){   
            //�Д�obj�����е�iԪ���Ƿ��cb������t��ʾδ���c�x   
            if (obj[i]!=cb) obj[i].checked = false;   
            //���� ��ԭ��δ�����x �t׃�ɹ��x����֮ �t׃��δ���x   
            //else  obj[i].checked = cb.checked;   
            //��Ҫ���ٹ��xһ����Ԓ���t����������else�õ����Q����������   
            else obj[i].checked = true;   
        }   
    }
    function loadDataDetail(device_mix_id){
    	var retObj;
		if(device_mix_id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevMixMainInfo", "devicemixid="+device_mix_id);
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("����ѡ��һ����¼!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevMixMainInfo", "devicemixid="+ids);
		}
		//ѡ����һ��checkbox
		$("#selectedbox_"+retObj.devicedetailMap.device_mix_id).attr("checked",'true');
		//ȡ������ѡ�е�
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.devicedetailMap.device_mix_id+"']").removeAttr("checked");
		
		//�����ݻ���
		$("#project_name","#devdetailMap").val(retObj.devicedetailMap.project_name_1);
		$("#job_line","#devdetailMap").val(retObj.devicedetailMap.job_line);
		$("#dev_ci_name","#devdetailMap").val(retObj.devicedetailMap.dev_ci_name);
		$("#dev_ci_model","#devdetailMap").val(retObj.devicedetailMap.dev_ci_model);
		$("#plan_start_date","#devdetailMap").val(retObj.devicedetailMap.plan_start_date);
		$("#plan_end_date","#devdetailMap").val(retObj.devicedetailMap.plan_end_date);
		
		$("#apply_num","#devdetailMap").val(retObj.devicedetailMap.apply_num);
		$("#apply_user","#devdetailMap").val(retObj.devicedetailMap.employee_name);
		$("#approve_num","#devdetailMap").val(retObj.devicedetailMap.approve_num);
		$("#approve_user","#devdetailMap").val(retObj.devicedetailMap.employeename);
		//TODO ����Ե����˺͵��������ĵ���  mix_num ~ mix_user
		$("#assign_num","#devdetailMap").val(retObj.devicedetailMap.assign_num);
    }
	
</script>
</html>