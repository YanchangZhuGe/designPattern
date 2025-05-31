<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	String countryId=request.getParameter("countryId");
	String likeSymbol="76547876";
	if(countryId==null||"".equals(countryId)){
		likeSymbol="%";
	}
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
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

  <title>市场招投标管理</title>
 </head>

 <body style="background:#fff" >
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath %>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">国家：</td>
								<td class="ali_cdn_input"><input id="countryName" name="countryName" type="text" class="input_width" /></td>
								<td class="ali_query"><span class="cx"><a href="#" onclick="simpleRefreshData()" title="JCDP_btn_query"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span></td>
							 	<td>&nbsp;</td>
							    <auth:ListButton css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								<auth:ListButton css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
								<auth:ListButton css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{market_bid_id}' id='rdo_entity_id_{market_bid_id}'   />">选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{region_name}">地区</td>
					<td class="bt_info_even" exp="{country_name}">国家</td>
					<td class="bt_info_odd" exp="{workarea}">工区</td>
					<td class="bt_info_even" exp="{owner_name}">甲方</td>
					<td class="bt_info_odd" exp="{start_bid_date}">邀标时间</td>
					<td class="bt_info_even" exp="{end_bid_date}">闭标时间</td>
					<td class="bt_info_odd" exp="{start_date}">开工日期</td>
					<td class="bt_info_even" exp="{result_name}">评标结果</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display:block">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
					<td width="50">到 <label> <input type="text" name="textfield" id="textfield" style="width:20px;" /> </label></td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
				<li id="tag3_1"><a href="#" onclick="getTab3(1)">文档</a></li>
				<li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
				<li id="tag3_3"><a href="#" onclick="getTab3(3)">分类码</a></li>
			</ul>
		</div>
		<div id="tab_box" class="tab_box" style="overflow:hidden;">
			<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					<tr>
						<td class="inquire_item4">国家：</td>
						<td class="inquire_form4" id="item0_0"><input type="text" id="country_name" name="project_name" class="input_width" />
						</td>
						<td class="inquire_item4">工区：</td>
						<td class="inquire_form4" id="item0_1"><input type="text" id="workarea" name="project_id" class="input_width_no_color" class="input_width" />
						</td>
					</tr>
					<tr>	
						<td class="inquire_item4">甲方：</td>
						<td class="inquire_form4" id="item0_2"><input type="text" id="owner_name" name="project_id" class="input_width_no_color" class="input_width" />
						</td>
					
						<td class="inquire_item4">工作量：</td>
						<td class="inquire_form4" id="item0_3"><input type="text" id="workload" name="acquire_start_time" value="" class="input_width" readOnly="readonly" /></td>
					</tr>
					<tr>	
						<td class="inquire_item4">邀标时间：</td>
						<td class="inquire_form4" id="item0_4"><input type="text" id="start_bid_date" name="start_bid_date" value="" class="input_width" readOnly="readonly" /></td>
						
						<td class="inquire_item4">闭标时间：</td>
						<td class="inquire_form4" id="item0_5"><input type="text" id="end_bid_date" name="end_bid_date" value="" class="input_width" readOnly="readonly" /></td>
					</tr>
					<tr>
						<td class="inquire_item4">开工日期：</td>
						<td class="inquire_form4" id="item0_3"><input type="text" id="start_date" name="" start_date"" value="" class="input_width" readOnly="readonly" /></td>
						
						<td class="inquire_item4">立项日期：</td>
						<td class="inquire_form4" id="item0_4"><input type="text" id="approve_date" name="approve_date" value="" class="input_width" readOnly="readonly" /></td>
					</tr>
					<tr>	
						<td class="inquire_item4">评标结果：</td>
						<td class="inquire_form4" id="item0_5"><input type="text" id="result_name" name="result_name" value="" class="input_width" readOnly="readonly" /></td>
					</tr>
					<tr>
						<td class="inquire_item4">落/弃标原因分析：</td>
						<td class="inquire_form4" colspan="3"><textarea name="reason" id="reason" value="" class="textarea"></textarea></td>
					</tr>
					<tr>
						<td class="inquire_item4">备注：</td>
						<td class="inquire_form4" colspan="3"><textarea name="remark" id="remark" value="" class="textarea"></textarea></td>
					</tr>
				</table>
			</div>
			<div id="tab_box_content1" class="tab_box_content">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0"> </iframe>
			</div>
			<div id="tab_box_content2" class="tab_box_content">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0"> </iframe>
			</div>
			<div id="tab_box_content3" class="tab_box_content">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0" scrolling="auto"
					style="overflow: scroll;"></iframe>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">
	$(document).ready(readyForSetHeight);
	frameSize();
	$(document).ready(lashen);

	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var type_id = "";
	var type_name = "";
	var parent_name = "";
	var likeSymbol ="";
	// 简单查询
	function simpleRefreshData(){
		refreshData();
	}
	function refreshData(typeId ,typeName ,parentName){
		if(parentName==null || parentName=='' || parentName=='null'){
			parentName = parent_name;
		}
		type_id = typeId;
		type_name = typeName;
		parent_name = parentName;
		var countryId = type_id
		cruConfig.queryStr = "SELECT t.*, '"+parent_name+"' region_name ,decode(t.eva_result,'1','落标','2','弃标','3','未揭标',4,'正在制作','中标') result_name, sd1.type_name country_name, sd2.company_short_name owner_name FROM BGP_MARKET_BID T inner join bgp_market_company_type sd1    on t.country = sd1.type_id inner join bgp_market_oil_company sd2    on t.owner = sd2.company_id WHERE t.BSFLAG = '0' and t.country like '"+countryId+"%' ";
		var countryName=document.getElementById("countryName").value;
		if(countryName!=null&&countryName!=""&&countryName!=undefined){
			cruConfig.queryStr+=" and sd1.coding_name  like '%"+countryName+"%'";
		}
		cruConfig.currentPageUrl = "/market/marketBid/makertBidList.jsp";
		queryData(1);
	}
	refreshData('null','');
	function toAdd(){
		popWindow('<%=contextPath%>/market/marketBid/marketBidEdit.jsp?type_id='+type_id+'&type_name='+type_name);
	}
	function toEdit() {
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/market/marketBid/marketBidEdit.jsp?market_bid_id='+ids);
	}
	function toDelete(){

		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update BGP_MARKET_BID t set t.bsflag='1' where t.MARKET_BID_ID ='"+ids+"'";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		syncRequest('Post',path,params);
		refreshData();
	}

	var bidInfo = {
			country_name:'',
			workarea:'',
			owner_name:'',
			start_bid_date:'',
			end_bid_date:'',
			workload:'',
			start_date:'',
			approve_date:'',
			result_name:'',
			reason:'',
			remark:''
	};
	
	function loadDataDetail(ids){
		
		//载入费用详细信息
		var querySql = "SELECT t.*, '"+parent_name+"' region_name ,decode(t.eva_result,'1','落标','2','弃标','3','未揭标',4,'正在制作','中标') result_name, sd1.type_name country_name, sd2.company_short_name owner_name FROM BGP_MARKET_BID T inner join bgp_market_company_type sd1    on t.country = sd1.type_id inner join bgp_market_oil_company sd2    on t.owner = sd2.company_id WHERE t.BSFLAG = '0' and t.market_bid_id ='"+ids+"' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas != null&&datas.length>0){
			setOneDataInfo(bidInfo,datas[0]);
		}else{
			setOneDataInfo(bidInfo,null);
		}
		
		//载入文档信息
		document.getElementById("attachement").src="<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids;
		//载入备注信息
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
		//载入分类吗信息
		document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=4&relationId="+ids
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
</script>
</html>