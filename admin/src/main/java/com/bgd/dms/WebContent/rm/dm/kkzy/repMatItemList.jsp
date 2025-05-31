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
	String userId = user.getSubOrgIDofAffordOrg();
	//  userId = "C105001";
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String codeId = "";
	codeId = request.getParameter("codeId");
	String orgSubId = user.getOrgSubjectionId();
	String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<title>无标题文档</title>
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
								<td class="ali_cdn_name" style="width: 60px;">物资名称</td>
								<td class="ali_cdn_input" style="width: 120px;"><input
									class="input_width" id="s_wz_name" name="s_wz_name" type="text" /></td>
								<td class="ali_cdn_name" style="width: 60px;">物资编码</td>
								<td class="ali_cdn_input" style="width: 120px;"><input
									class="input_width" id="s_wz_id" name="s_wz_id" type="text" /></td>
								<auth:ListButton functionId="" css="cx"
									event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
								<auth:ListButton functionId="" css="qc"
									event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
								<td align="right"><a
									href="<%=contextPath%>/mat/singleproject/mattemplate/download.jsp?path=/rm/dm/kkzy/repMat.xlsx&filename=repMat.xlsx">下载模板</a>
								</td>
								<auth:ListButton functionId="" css="zj"
									event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								<!--<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>-->
								<auth:ListButton functionId="" css="sc"
									event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
								<auth:ListButton functionId="" css="dr"
									event="onclick='AddExcelData()'" title="导入excel"></auth:ListButton>
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
						exp="<input name = 'rdo_entity_name' id='rdo_entity_id_{recyclemat_info}' type='checkbox' value='{recyclemat_info}' onclick='loadDataDetail();chooseOne(this);'/>"></td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{wz_sequence}">系列号</td>
					<td class="bt_info_odd" exp="{wz_id}">物资编码</td>
					<td class="bt_info_even" exp="{wz_name}">物资名称</td>
					<td class="bt_info_odd" exp="{wz_prickie}">计量单位</td>
					 <td class="bt_info_even" exp="{wz_price}">计划单价(元)</td> 
					<!--<td class="bt_info_odd" exp="{actual_price}">实际单价(元)</td>
					<td class="bt_info_even" exp="{stock_num}">库存数量</td>  -->
					<td class="bt_info_odd" exp="{code_name}">分类</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
						width="20" height="20" /></td>
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
					onclick="getTab3(0)">基本信息</a></li>
				<!-- 			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">附件</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">分类码</a></li>
 -->
			</ul>
		</div>

		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content">
				<table border="0" cellpadding="0" cellspacing="0"
					class="tab_line_height" width="100%" style="background: #efefef">
					<tr>
						<td class="inquire_item6">物资名称：</td>
						<td class="inquire_form6"><input id="wz_name"
							class="input_width_no_color" type="text" value="" /> &nbsp;</td>
						<td class="inquire_item6">&nbsp;系列号：</td>
						<td class="inquire_form6"><input id="wz_sequence"
							class="input_width_no_color" type="text" value="" /> &nbsp;</td>
						<td class="inquire_item6">&nbsp;物资编码：</td>
						<td class="inquire_form6"><input id="wz_id"
							class="input_width_no_color" type="text" value="" /> &nbsp;</td>
					</tr>
					<tr>
						<td class="inquire_item6">实际单价：</td>
						<td  class="inquire_form6"><input id="actual_price"
							class="input_width_no_color" type="text" value="" /> &nbsp;</td>
							<td class="inquire_item6">&nbsp;计划单价：</td>
						<td class="inquire_form6"><input id="wz_price"
							class="input_width_no_color" type="text" value="" /> &nbsp;</td>
						<td class="inquire_item6"></td>
						<td  class="inquire_form6"></td>
						<!-- 
						<td class="inquire_item6">&nbsp;库存数量：</td>
						<td class="inquire_form6"><input id="stock_num"
							class="input_width_no_color" type="text" value="" /> &nbsp;</td> -->
					</tr>
				</table>
			</div>
			<!-- 				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
 -->
		</div>
	</div>
</body>
<script type="text/javascript">
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }

function frameSize(){
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
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
	var rootId = "8ad889f13759d014013759d3de520003";
	cruConfig.contextPath =  "<%=contextPath%>";
	var userId = '<%=userId%>';
	var orgSubjectionId = "<%=user.getOrgSubjectionId()%>";
	var orgId = "<%=user.getOrgId()%>";
	
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var codeId = getQueryString("codeId");
	function refreshData(){
		var sql='';
		 	sql +="select i.*, c.code_name,tt.postion, tt.stock_num,tt.actual_price,tt.wz_sequence, tt.recyclemat_info from (select  t.wz_id,t.wz_sequence,   t.recyclemat_info,t.stock_num,t.actual_price ,  t.postion  from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '3'   and t.project_info_id='<%=projectInfoNo%>'  ) tt left join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on tt.wz_id=i.wz_id order by tt.postion  asc, i.coding_code_id asc ,i.wz_id asc";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/rm/dm/kkzy/repMatItemList.jsp";
		queryData(1);
	}

	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!= undefined){
			 retObj = jcdpCallService("DevInsSrv", "getMatRep", "laborId="+shuaId);
			
		}else{
			var ids = document.getElementsByName('rdo_entity_name').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("DevInsSrv", "getMatRep", "laborId="+ids);
		}
		//取消选中框--------------------------------------------------------------------------
		var obj = document.getElementsByName("rdo_entity_name");  
	        for (i=0; i<obj.length; i++){   
	            obj[i].checked = false;
	        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+retObj.matInfo.recyclemat_info).attr("checked","checked");
		
		document.getElementById("wz_name").value = retObj.matInfo.wz_name;
		document.getElementById("wz_sequence").value = retObj.matInfo.wz_sequence;
		document.getElementById("wz_id").value = retObj.matInfo.wz_id;
		document.getElementById("wz_price").value = retObj.matInfo.wz_price;
		document.getElementById("stock_num").value = retObj.matInfo.stock_num;
		document.getElementById("actual_price").value = retObj.matInfo.actual_price;
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

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
       function simpleSearch(){
    	   var sql ="select i.*,c.code_name,t.stock_num,t.recyclemat_info,t.actual_price,t.wz_sequence  from gms_mat_recyclemat_info t inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on t.wz_id=i.wz_id  where t.bsflag='0'and t.wz_type='3' and t.project_info_id='<%=projectInfoNo%>'  ";
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
			cruConfig.currentPageUrl = "/rm/dm/kkzy/repMatItemList.jsp";
			queryData(1);
			
	}
   	
       function clearQueryText(){
   		document.getElementById("s_wz_name").value = "";
   		document.getElementById("s_wz_id").value = "";
   	} 
     
 	function toAdd(){
 	 	popWindow("<%=contextPath%>/rm/dm/kkzy/repMatLedgerEdit.jsp?orgSubjectionId="+orgSubjectionId+"&orgId="+orgId,'1024:800');
 	 	}
	
	function toDelete(){
		 ids = getSelIds('rdo_entity_name');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    else{
		 	   if(confirm('确定要删除吗?')){  
			   var retObj = jcdpCallService("DevInsSrv", "deleteRepMat", "matId="+ids+"&orgSubjectionId="+orgSubjectionId);
			 	queryData(cruConfig.currentPage);
		       }
		    }
		}
	function AddExcelData(){
		 popWindow("<%=contextPath%>/rm/dm/kkzy/excelRepMatAdd.jsp");
	}
</script>

</html>

