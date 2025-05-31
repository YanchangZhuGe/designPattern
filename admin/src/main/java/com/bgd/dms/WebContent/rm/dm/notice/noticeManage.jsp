<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String org_sub_id = user.getOrgSubjectionId();
	String org_id = user.getOrgId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>通知公告</title>
</head>
<body style="background: #fff" onload="refreshData()">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png"><table
							width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">标题</td>
								<td class="ali_cdn_input"><input class="input_width"
									id="s_notice_title" name="s_notice_title" type="text" /></td>

								<auth:ListButton functionId="" css="cx"
									event="onclick='refreshData()'" title="JCDP_btn_query"></auth:ListButton>
								<auth:ListButton functionId="" css="qc"
									event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
								<td>&nbsp;&nbsp;</td>
								<td>&nbsp;&nbsp;</td>
								<td>&nbsp;&nbsp;</td>
								<auth:ListButton functionId="" css="zj"
									event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								<auth:ListButton functionId="" css="xg"
									event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
								<auth:ListButton functionId="" css="sc"
									event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
								<auth:ListButton functionId="" css="dc"
									event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table></td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png"
						width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_odd"
						exp="<input name = 'rdo_entity_name' id='rdo_entity_id_{notice_id}' type='checkbox' value='{notice_id}' onclick='chooseOne(this)'/>">选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{notice_title}">标题</td>
					<td class="bt_info_odd" exp="{real_user_name}">创建人</td>
					<td class="bt_info_even" exp="{create_date}">创建时间</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display: block">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="../images/fenye_01.png" width="20"
						height="20" /></td>
					<td width="30"><img
						src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
					<td width="30"><img
						src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
					<td width="30"><img
						src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
					<td width="50">到 <label> <input type="text"
							name="textfield" id="textfield" style="width: 20px;" />
					</label></td>
					<td align="left"><img
						src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#"
					onclick="getContentTab(this,0)">基本信息</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">附件</a></li>
			</ul>
		</div>

		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content"  name="tab_box_content0">
				<table border="0" cellpadding="0" cellspacing="0"
					class="tab_line_height" width="100%" style="background: #efefef">
					<tr>
						<td class="inquire_item6">标题：</td>
						<td class="inquire_form6"><input id="notice_title"
							class="input_width_no_color" type="text" value=""
							readonly="readonly" /> &nbsp;</td>
						<td class="inquire_item6">&nbsp;创建人：</td>
						<td class="inquire_form6"><input id="real_user_name"
							class="input_width_no_color" type="text" value=""
							readonly="readonly" /> &nbsp;</td>
						<td class="inquire_item6">&nbsp;创建时间：</td>
						<td class="inquire_form6"><input id="create_date"
							class="input_width_no_color" type="text" value=""
							readonly="readonly" /> &nbsp;</td>
					</tr>
					<tr>
						<td class="inquire_item6">通告类型：</td>
						<td class="inquire_form6"><input id="notice_type"
							class="input_width_no_color" type="text" value=""
							readonly="readonly" /> &nbsp;</td>
						<td class="inquire_item6">&nbsp;通告内容：</td>
						<td class="inquire_form6" colspan="3"><input
							id="notice_content" class="input_width_no_color" type="text"
							value="" readonly="readonly" /> &nbsp;</td>

					</tr>
				</table>
			</div>

			<div id="tab_box_content1" class="tab_box_content"  name="tab_box_content1"
				style="display: none;">
				<iframe width="100%" height="100%" name="attachement"
					id="attachement" frameborder="0" src="" marginheight="0"
					marginwidth="0"> </iframe>
			</div>

		</div>
	</div>
</body>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
function frameSize(){
	setTabBoxHeight();
}
frameSize();
$(function(){
	$(window).resize(function(){
  		frameSize();
	});
});	
$(document).ready(lashen);
</script>

<script type="text/javascript">
var user_id='<%=userId%>';
var org_id='<%=org_id%>';
var org_sub_id='<%=org_sub_id%>';
   //初始化数据
	function refreshData(){
	   var title=$("#s_notice_title").val();
	   var sql ="select * from dms_comm_notice  t    where t.bsflag='0' and t.creater='"+user_id+"' ";
	   if(title!=""&&title!=undefined){
		   sql+="  and notice_title  like '%"+title+"%'";
	   }
	   sql+=" order by  notice_type  desc,create_date desc";
		cruConfig.queryStr = sql;
		queryData(1);
	}
//增加
function toAdd(){
 	 	popWindow("<%=contextPath%>/rm/dm/notice/noticeEdit.jsp?org_id="+org_id+"&org_sub_id="+org_sub_id,'1024:800');
 }
//修改
function toEdit(){
	var notice_id ="";
    var  isSelectedData=false;
	$("input[type='checkbox'][name='rdo_entity_name']").each(function(i,n){
		if($(n).attr("checked")=='checked'){
			notice_id=$(n).val();
			isSelectedData=true;
		}
		
	});
	if(isSelectedData){
		popWindow("<%=contextPath%>/rm/dm/notice/noticeEdit.jsp?notice_id="+notice_id,'1024:800');
	}else{
		 alert("请先选中一条记录!");
  		return;
	}
 	 	
 }
 

	function loadDetail(id){
		var retObj="";
		if(id!= ""){
			 retObj = jcdpCallService("DevInsSrv", "getNoticeDetail", "notice_id="+id);
		}else{
	     		return;
		}
		document.getElementById("notice_title").value = retObj.notice.NOTICE_TITLE;
		if(retObj.notice.NOTICE_TYPE=='0'){
			document.getElementById("notice_type").value = '普通';
		}else{
			document.getElementById("notice_type").value = '置顶';
		}
		
		document.getElementById("notice_content").value = retObj.notice.NOTICE_CONTENT;
		document.getElementById("real_user_name").value = retObj.notice.REAL_USER_NAME;
		var date=retObj.notice.CREATE_DATE;
		document.getElementById("create_date").value = retObj.notice.CREATE_DATE;
		
	
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function chooseOne(cb){
	   var checkedId=$(cb).attr("id");
	   var notice_id=$(cb).val();
	   $("input[type='checkbox'][name='rdo_entity_name'][id='"+checkedId+"']").attr("checked",'checked');
	   $("input[type='checkbox'][name='rdo_entity_name'][id!='"+checkedId+"']").removeAttr("checked");
	   loadDetail(notice_id);
	     
	}   
       function simpleSearch(){
    	   var sql ="select i.*,c.code_name,t.stock_num,t.recyclemat_info,t.actual_price,t.wz_sequence    from gms_mat_recyclemat_info t inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on t.wz_id=i.wz_id  where t.bsflag='0'and t.wz_type='3' and t.project_info_id is null   and t.org_subjection_id like '"+orgSubjectionId+"%'  ";
    	   var wz_name = document.getElementById("s_wz_name").value;
			var wz_id = document.getElementById("s_wz_id").value;
			if(wz_name !='' && wz_name != null || wz_id !='' && wz_id != null){
				if(wz_name !=''){
					sql += "  and i.wz_name like'%"+wz_name+"%'";
				}
				if(wz_id !='' && wz_id != null){
					sql += " and t.wz_id like'%"+wz_id+"%'";
					}
			}
			//else{
				//alert('请输入查询内容！');
				//}  
			sql +=" order by i.coding_code_id asc ,i.wz_id asc";
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/rm/dm/kkzy/mutiPorject/repMatItemLists.jsp";
			queryData(1);
			
	}
   	
      
     
 	
	function toDelete(){
		 ids = getSelIds('rdo_entity_name');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    else{
		 	   if(confirm('确定要删除吗?')){  
			   var retObj = jcdpCallService("DevInsSrv", "deleteNotice", "notice_id="+ids);
			 	queryData(cruConfig.currentPage);
		       }
		    }
		}
	function AddExcelData(){
		 popWindow("<%=contextPath%>/rm/dm/kkzy/mutiPorject/excelRepMatAdd.jsp");
		}
	function clearQueryText(){
		document.getElementById("s_notice_title").value="";
	}
//	<div id="tag-container_3">
	//<ul id="tags" class="tags">
	//	<li class="selectTag" id="tag3_0"><a href="#"
	//		onclick="getContentTab(this,0)">基本信息</a></li>
	//	<li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">附件</a></li>
	//</ul>
//</div>
    var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		if(obj!=undefined){
			$("li","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='rdo_entity_name']").each(function(){
			if(this.checked){
				currentid = this.value;
			}
		});
		if(index == 0){
			var baseData;
			var ids = getSelIds('rdo_entity_name');
			if(ids!=""&&ids!=undefined){
				 loadDetail(ids);
			}
		}
		else if(index == 1){
			var ids = getSelIds('rdo_entity_name');
			if(ids!=""&&ids!=undefined){
			$("#attachement").attr("src","<%=contextPath%>/rm/dm/notice/common_doc_list.jsp?relationId="+ids);
			}
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
</script>

</html>

