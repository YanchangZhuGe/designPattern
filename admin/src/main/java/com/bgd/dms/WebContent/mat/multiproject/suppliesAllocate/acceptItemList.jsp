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
	String projectInfoNo = user.getProjectInfoNo();
	String orgName = user.getOrgName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>专业化入库</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">入库信息：</td>
		 	     <td class="ali_cdn_input"><select  onchange="simpleSearch(this)"><option value="0">未入库</option><option value="1">已入库</option></select></td>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>

			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_warehouse_entry"></auth:ListButton>
			   <!--  <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='toOutExcel()'" title="导出"></auth:ListButton> -->
			    <td></td>
			    <td></td>
			    <td></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{out_info_detail_id}' onclick='loadDataDetail();chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{wz_name}">物资名称</td>
			      <td class="bt_info_odd" exp="{out_num}">退库数量</td>
			      <td class="bt_info_even" exp="{out_price}">实际单价</td>
			      <td class="bt_info_odd" exp="{operator}">退货人</td>
			      <td class="bt_info_even" exp="{org_abbreviation}">退货单位</td>
			      <td class="bt_info_odd" exp="{bsflag}">验收状态</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			
			
			<div id="tab_box" class="tab_box" >
				<div id="tab_box_content0" class="tab_box_content" >
					   <div id="tag-container_3">
							<ul id="tags" class="tags">
								<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">物资调配</a></li>
							</ul>
							</div>
					   <table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#90d7ec" >
				    	 <tr>
				      <td  class="inquire_item6">物资编号：</td>
				      <td  class="inquire_form6" ><input id="wz_id" class="input_width_no_color" style="margin-top:3px;" type="text" value="" readonly/> &nbsp;</td>
				      <td  class="inquire_item6">物资名称：</td>
				      <td  class="inquire_form6"  ><input id="wz_name" class="input_width_no_color"style="margin-top:3px;" type="text"  value="" readonly/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;物资分类码：</td>
				      <td  class="inquire_form6"  ><input id="wz_prickie" class="input_width_no_color"style="margin-top:3px;" type="text"  value="" readonly/> &nbsp;</td>
				     </tr>
				        </table>
					</div>
				
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
	cruConfig.contextPath =  "<%=contextPath%>";
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	var codeId = getQueryString("codeId");
	function refreshData(){
		var sql ="select q.out_info_detail_id ,wz_name,i.wz_id,out_num,out_price,operator,comm.org_abbreviation,case when q.bsflag ='0' then '未验收' else '已验收' end bsflag from GMS_MAT_OUT_INFO_DETAIL q inner join GMS_MAT_OUT_INFO q1 on q1.out_info_id=q.out_info_id inner join comm_org_information comm on q1.org_id=comm.org_id  inner join gms_mat_infomation i on q.wz_id=i.wz_id  where receive_org_id='<%=user.getOrgId()%>' and q.bsflag='0'";
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		//cruConfig.currentPageUrl = "/mat/singleproject/warehouseDg/accept/selfaccept/acceptItemList.jsp";
		queryData(1);
	}

	function loadDataDetail(ids){
		var  retObj = jcdpCallService("MatItemSrv", "getWz", "wz_id="+ids);
		document.getElementById("wz_id").value = retObj.matInfo.wzId;
		document.getElementById("wz_name").value = retObj.matInfo.wzName;
		document.getElementById("wz_prickie").value = retObj.matInfo.wzPrickie;
		}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	  function toAdd(){ 
		  ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
		    var id=ids.split(",");
		    debugger;
		  //  if(id[2]!="")
		    popWindow("<%=contextPath%>/mat/multiproject/suppliesAllocate/acceptLedgerAdd.jsp?ids="+id+"&orgId="+id[2],'1024:800');
			
	 }  
		
       
       function simpleSearch(select){
    	   var sql ='';
			var type = select.value;
			if(type==0){
				var sql ="select q.out_info_detail_id,wz_name,i.wz_id,out_num,out_price,operator,comm.org_abbreviation,case when q.bsflag ='0' then '未验收' else '已验收' end bsflag from GMS_MAT_OUT_INFO_DETAIL q inner join GMS_MAT_OUT_INFO q1 on q1.out_info_id=q.out_info_id inner join comm_org_information comm on q1.org_id=comm.org_id  inner join gms_mat_infomation i on q.wz_id=i.wz_id  where receive_org_id='<%=user.getOrgId()%>' and q.bsflag='0'";
				}else{
					var sql ="select q.out_info_detail_id,wz_name,i.wz_id,out_num,out_price,operator,comm.org_abbreviation,case when q.bsflag ='0' then '未验收' else '已验收' end bsflag from GMS_MAT_OUT_INFO_DETAIL q inner join GMS_MAT_OUT_INFO q1 on q1.out_info_id=q.out_info_id inner join comm_org_information comm on q1.org_id=comm.org_id  inner join gms_mat_infomation i on q.wz_id=i.wz_id  where receive_org_id='<%=user.getOrgId()%>' and q.bsflag='5'";
					}
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/multiproject/suppliesAllocate/acceptItemList.jsp";
			queryData(1);
			
	}
       function clearQueryText(){
   		document.getElementById("s_wz_name").value = "";
   	} 
	 	function dbclickRow(ids){
	 	//	ids = getSelIds('rdo_entity_id');
	 		var id=ids.split(",");
	 		if(id[2]!=""){
	 		//var ids=document.getElementById("rdo_entity_id");
	 		 popWindow("<%=contextPath%>/mat/multiproject/suppliesAllocate/acceptLedgerAdd.jsp?ids="+id[0]+"&orgId="+id[2],'1024:800');
	 				}
		 		}
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
</script>

</html>

