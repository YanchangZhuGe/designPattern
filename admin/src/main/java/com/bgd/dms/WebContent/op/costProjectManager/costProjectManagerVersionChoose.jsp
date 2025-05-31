<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user=OMSMVCUtil.getUserToken(request);
	String userId=user.getUserId();
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

  <title>虚拟项目维护</title>
 </head>

 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	 <td class="ali_cdn_name">项目：</td>
			    <td class="ali_cdn_input">
			    <input id="projectInfoNo" name="projectInfoNo" type="text" value=""/>
			    </td>
			    <td class="ali_cdn_name">甲方：</td>
			    <td class="ali_cdn_input">
			    <input id="manageOrg" name="manageOrg" type="text" value=""/>
			    </td>
			     <td class="ali_query">
				    <span class="cx"><a href="#" onclick="refreshData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <auth:ListButton css="tj" event="onclick='toConfirm()'" title="JCDP_btn_confirm"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			     <tr>
			      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{project_info_no},{cost_project_schema_id}' id='rdo_entity_id_{project_info_no}_{cost_project_schema_id}'   />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="{schema_name}">方案名称</td>
			      <td class="bt_info_odd" exp="{manage_org}">甲方</td>
			      <td class="bt_info_even" exp="{team}">施工队伍</td>
			      <td class="bt_info_odd" exp="{surface_type}">地表类型</td>
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
			<!-- <div class="lashen" id="line"></div>
			<div id="tag-container_3">
				  <ul id="tags" class="tags">
				    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
				    <li id="tag3_1"><a href="#" onclick="getTab3(1)">标签2</a></li>
				    <li id="tag3_2"><a href="#" onclick="getTab3(2)">标签3</a></li>
				    <li id="tag3_3"><a href="#" onclick="getTab3(3)">标签4</a></li>
				    <li id="tag3_4"><a href="#" onclick="getTab3(4)">标签5</a></li>
				  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				    <div id="tab_box_content0" class="tab_box_content">
				    
				    </div>
				    <div id="tab_box_content1" class="tab_box_content"></div>
				    <div id="tab_box_content2" class="tab_box_content"></div>
				    <div id="tab_box_content3" class="tab_box_content"></div>
				    <div id="tab_box_content4" class="tab_box_content"></div>
			</div> -->
</div>
</body>

<script type="text/javascript">


var selectedTagIndex = 0;
$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#fenye_box").height()-8);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			refreshData();
		}
	}
	
	function clearQueryText(){
		$("#projectInfoNo").val('');
		$("#manageOrg").val('');
		refreshData();
	}
	
	function refreshData(){
		
		var projectInfoNo=$("#projectInfoNo").val();
		var manageOrg=$("#manageOrg").val();
		cruConfig.queryStr = "select pv.*,ps.cost_project_schema_id,ps.schema_name from  bgp_op_cost_project_basic pv left outer join  bgp_op_cost_project_schema ps on pv.project_info_no = ps.project_info_no and ps.bsflag='0' where pv.bsflag='0' and pv.org_subjection_id like'<%=org_subjection_id%>%'";
		if(manageOrg!=null&&manageOrg!=''&&manageOrg!=undefined){
			cruConfig.queryStr+=" and pv.manage_org like  '%"+manageOrg+"%'";
		}
		if(projectInfoNo!=null&&projectInfoNo!=''&&projectInfoNo!=undefined){
			cruConfig.queryStr+=" and pv.project_name like '%"+projectInfoNo+"%'";
		}
		cruConfig.querySt+=" order by pv.create_date desc,ps.project_info_no,ps.schema_name";
		cruConfig.currentPageUrl = "/op/costProjectManager/costProjectManager.jsp";
		queryData(1);
	}

	function loadDataDetail(){

	}
    //chooseOne()函式，參數為觸發該函式的元素本身
    function chooseOne(cb){
        //先取得同name的chekcBox的集合物件
        var obj = document.getElementsByName("rdo_entity_id");
        for (i=0; i<obj.length; i++){
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選
            if (obj[i]!=cb) obj[i].checked = false;
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選
            //else  obj[i].checked = cb.checked;
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行
            else obj[i].checked = true;
        }
    }
    function toConfirm(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		 var obj = window.dialogArguments;
		 obj.value=ids;
		 window.close();
	}
</script>
</html>