<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
    String code = request.getParameter("code");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

  <title>��Ŀҳ��</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali3">�豸���</td>
			    <td class="ali1"><input id="s_dev_ci_name" name="s_dev_ci_name" type="text" onkeypress="simpleRefreshData()"/></td>
			    <td class="ali3">����ͺ�</td>
			    <td class="ali1"><input id="s_dev_ci_model" name="s_dev_ci_model" type="text" onkeypress="simpleRefreshData()"/></td>
			    <td>&nbsp;</td>
			   <td><span class="gl"><a href="#" onclick="searchDevData()"></a></span></td>
			    <td><span class="ck"><a href="#" onclick="searchDevData()"></a></span></td>
			    <td><span class="zj"><a href="#" onclick="toAdd();"></a></span></td>
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
					<td class="bt_info_odd" autoOrder="1">���</td>
					<td class="bt_info_even" exp="{dev_name}">�豸���</td>
					<td class="bt_info_odd" exp="">����ͺ�</td>
					<td class="bt_info_even" exp="{account_stat}">����״̬</td>
					<td class="bt_info_odd" exp="{dev_sign}">ʵ���ʶ��</td>
					<td class="bt_info_even" exp="{dev_model}">�豸����</td>
					<td class="bt_info_odd" exp="{self_num}">�Ա��</td>
					<td class="bt_info_even" exp="{license_num}">���պ�</td>
					<td class="bt_info_odd" exp="{asset_coding}">�ʲ����</td>
					<td class="bt_info_even" exp="{owning_org_name}">������λ</td>
					<td class="bt_info_odd" exp="{usage_org_name}">���ڵ�λ</td>
					<td class="bt_info_even" exp="{dev_position}">���ڵ�</td>
					<td class="bt_info_odd" exp="{using_stat}">ʹ�����</td>
					<td class="bt_info_even" exp="{tech_stat}">����״��</td>
					<td class="bt_info_odd" exp="">�豸������</td>
					<td class="bt_info_even" exp="{asset_value}">�̶��ʲ�ԭֵ</td>
					<td class="bt_info_odd" exp="{net_value}">�̶��ʲ�ֵ</td>
					<td class="bt_info_even" exp="">��������</td>
					<td class="bt_info_odd" exp="">Ͷ������</td>
					<td class="bt_info_even" exp="">���</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">����Ϣ</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">����</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="educationMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>��Ŀ���</td>
				            <td>��ҵ���</td>
				            <td>�ƻ���ʼʱ��</td>		
				            <td>�ƻ�����ʱ��</td>
				            <td>�豸���</td>			
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
	var taskIds = '<%=taskId%>';
	var projectInfoNos = '<%=projectInfoNo%>';

	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
			var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
			refreshData(v_dev_ci_name, v_dev_ci_model);
		}
	}
	
	function searchDevData(){
		var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
		var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
		refreshData(v_dev_ci_name, v_dev_ci_model);
	}
	var code = '<%=code%>';
	function refreshData(v_dev_ci_name,v_dev_ci_model){
		var str = "select dev_name,dev_model,dev_sign,self_num,license_num,asset_coding,owning_org_name,usage_org_name,dev_position,using_stat,tech_stat,asset_value,net_value,account_stat from GMS_DEVICE_ACCOUNT_DUI where dev_type like"+"'"+code+"%'";
		alert(str);
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and dev_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and dev_model like '"+v_dev_ci_model+"%' ";
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
	function toAdd(){
		popWindow('<%=contextPath%>/rm/dm/devPlan/devdetail_new_apply.jsp?projectInfoNo=<%=projectInfoNo%>&taskId=<%=taskId%>');
	}

	
	function toSubmitDetail() {	    
		
		//jcdpCallService("DeviceCommInfoSrv","submitDevDetail","");	
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