<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = request.getParameter("projectInfoNo");

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
  <title>����������ҳ��</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali3">ת����λ</td>
			    <td class="ali1"><input id="s_out_org_id" name="s_out_org_id" type="text" onkeypress="simpleRefreshData()"/></td>
			    <td class="ali3">�ƻ��볡ʱ��</td>
			    <td class="ali1"><input id="s_dev_plan_end_date" name="s_dev_plan_end_date" type="text" onkeypress="simpleRefreshData()"/></td>
			    <td>&nbsp;</td>
			    <td><span class="ck"><a href="#" onclick="searchDevData()"></a></span></td>
			    <td><span class="zj"><a href="#" onclick="toAddPage();"></a></span></td>
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
			     <tr id='device_appdet_id_{device_appdet_id}' name='device_appdet_id'>
					<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{dev_acc_id}' id='selectedbox_{dev_acc_id}' onclick='chooseOne(this)'/>" >ѡ��</td>
					<td class="bt_info_even" autoOrder="1">���</td>
					<td class="bt_info_odd" exp="{project_name}">��Ŀ����</td>
					<td class="bt_info_even" exp="{out_org_name}">ת����λ</td>
					<td class="bt_info_odd" exp="{dev_coding}">�豸����</td>
					<td class="bt_info_even" exp="{dev_name}">�豸����</td>
					<td class="bt_info_odd" exp="{dev_model}">����ͺ�</td>
					<td class="bt_info_even" >�豸���</td>
					<td class="bt_info_odd" exp="{planning_in_time}">�ƻ�����ʱ��</td>
					<td class="bt_info_even" exp="{planning_out_time}">�ƻ��볡ʱ��</td>
					<td class="bt_info_odd" exp="{actual_in_time}">ʵ�ʽ���ʱ��</td>
					<td class="bt_info_even">״̬</td>
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(2)">��ת��¼</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="educationMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>��Ŀ����</td>
				            <td>��ҵ����</td>
				            <td>�ƻ���ʼʱ��</td>		
				            <td>�ƻ�����ʱ��</td>
				            <td>�豸����</td>			
				            <td>����ͺ�</td> 
				            <td>����</td>
				            <td>������</td>			
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
	var projectInfoNos = '<%=projectInfoNo%>';

	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var v_out_org_id = document.getElementById("s_out_org_id").value;
			var v_dev_plan_end_date = document.getElementById("s_dev_plan_end_date").value;
			refreshData(v_out_org_id, v_dev_plan_end_date);
		}
	}
	
	function searchDevData(){
		var v_out_org_id = document.getElementById("s_out_org_id").value;
		var v_dev_plan_end_date = document.getElementById("s_dev_plan_end_date").value;
		refreshData(v_out_org_id, v_dev_plan_end_date);
	}
	
	function refreshData(v_out_org_id,v_dev_plan_end_date){
		var str = "select duiacc.dev_acc_id,duiacc.project_info_id,pro.project_name,duiacc.dev_coding,";
			str += "duiacc.dev_name,duiacc.dev_model,";
			str += "duiacc.planning_in_time,duiacc.planning_out_time,";
			str += "duiacc.actual_in_time,duiacc.account_stat,org.org_name as out_org_name ";
			str += "from gms_device_account_dui duiacc ";
			str += "left join gp_task_project pro on duiacc.project_info_id = pro.project_info_no ";
			str += "left join comm_org_information org on duiacc.out_org_id = org.org_id ";
			str += "where duiacc.project_info_id = '"+projectInfoNos+"' ";
			str += "and not exists(select 1 from gms_device_backapp_detail detail left join gms_device_backapp backapp ";
			str += "on detail.device_backapp_id=backapp.device_backapp_id ";
			str += "where detail.dev_acc_id =duiacc.fk_dev_acc_id and backapp.project_info_id='"+projectInfoNos+"') ";
		if(v_out_org_id!=undefined && v_out_org_id!=''){
			str += "and duiacc.v_out_org_id = '"+v_out_org_id+"' ";
		}
		if(v_dev_plan_end_date!=undefined && v_dev_plan_end_date!=''){
			str += "and duiacc.planning_in_time =to_date('"+v_dev_plan_end_date+"','yyyy-mm-dd') ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		popWindow('<%=contextPath%>/doc/singleproject/doc_search.jsp');
	}
	//����������
	function toAddPage(){
		//�����е�ѡ����е���Ϣƴ����
		var length = 0;
		var selectedStr = "";
		var id;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedStr += ",";
				}
				selectedStr+= this.value;
				id = this.value;
				length = length+1;
			}
		});
		if(length==0){
			alert("����ӷ�����ϸ��");
			return;
		};
		popWindow('<%=contextPath%>/rm/dm/devback/devdetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>&selectedStr='+selectedStr);
	}

	
	function toSubmit() {	    
	//	popWindow('<%=contextPath%>/rm/singleHuman/humanRequest/submit_planModify.jsp?projectInfoNo=<%=projectInfoNo%>');
		
		jcdpCallService("HumanCommInfoSrv","submitHumanPlan","projectInfoNo=<%=projectInfoNo%>&procStatus=1");	
		alert("�ύ�ɹ�");
	}
	

    //chooseOne()��ʽ���������|�lԓ��ʽ��Ԫ�ر���   
    function chooseOne(cb){   
        //��ȡ��ͬname��chekcBox�ļ������   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //�Д�obj�����е�iԪ���Ƿ��cb������t��ʾδ���c�x   
            if (obj[i]!=cb) obj[i].checked = false;   
            //���� ��ԭ��δ�����x �t׃�ɹ��x����֮ �t׃��δ���x   
            //else  obj[i].checked = cb.checked;   
            //��Ҫ���ٹ��xһ����Ԓ���t����������else�õ����Q����������   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(){
    	
    }
	
</script>
</html>