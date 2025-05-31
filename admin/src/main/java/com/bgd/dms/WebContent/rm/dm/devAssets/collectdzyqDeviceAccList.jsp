<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String code = request.getParameter("code");
	String is_leaf = request.getParameter("is_leaf");
	String node_level = request.getParameter("node_level");
	String userOrgId = user == null || user.getOrgId() == null ? "" : user.getOrgId().trim();
	String subOrgId = user.getSubOrgIDofAffordOrg();
	
	String userSubid = user.getOrgSubjectionId();
	//String orgId= user.getOrgId();
	String orgType="";
	String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
	//大港8个服务中心判断标志
	if(dgOrg.contains(userOrgId)){
		orgType="Y";
	}else{
		orgType="N";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>项目页面</title> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<link id="artDialogSkin" href="<%=contextPath %>/js/artDialog/skins/blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/artDialog.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/iframeTools.js"></script>
 </head> 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="query_dev_name" name="query_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">设备型号</td>
			    <td class="ali_cdn_input">
			    <input id="type_id" name="type_id" type="text" />
      			</td>
      			<td class="ali_cdn_name">国内/国外</td>
			    <td class="ali_cdn_input">
			  		<select id="country" name="country">
						<option value="">请选择</option>
						<option value="国内">国内</option>		
						<option value="国外">国外</option>					  		
			  		</select>
      			</td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			         			
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' dev_name='{dev_name}' dev_model='{dev_model}' usage_org ='{org_abbreviation}' total_num='{total_num}' unuse_num='{unuse_num}' use_num='{use_num}' other_num='{other_num}' value='{rm}' id='rdo_entity_id_{rm}' />" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">采集设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">采集设备型号</td>
					<td class="bt_info_even" exp="{dev_unit}">计量单位</td>
					<td class="bt_info_even" exp="{org_abbreviation}">所在单位</td>
					<td class="bt_info_odd" exp="{total_num}">总数量</td>
					<td class="bt_info_even" exp="{unuse_num}">闲置数量</td>
					<td class="bt_info_odd" exp="{use_num}">在用数量</td>
					<td class="bt_info_even" exp="{other_num}">其他数量</td>
					<td class="bt_info_odd" exp="{ifcountry}">国内/国外</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">技术状况</a></li>
 
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	 <tr>
						    <td class="inquire_item6">采集设备名称</td>
						    <td class="inquire_form6"><input id="dev_name" name="dev_name"  class="input_width" type="text" /></td>
						    <td class="inquire_item6">采集设备类型</td>
						    <td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text" /></td>
						    <td class="inquire_item6">采集设备型号</td>
						    <td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">所在单位</td>
						    <td class="inquire_form6"><input id="usage_org" name="usage_org" class="input_width" type="text" /></td>
						     <td class="inquire_item6">计量单位</td>
						    <td class="inquire_form6"><input id="unit_name" name="unit_name" class="input_width" type="text" value='台'/></td>
						    <td class="inquire_item6">所在位置</td>
						    <td class="inquire_form6"><input id="dev_position" name="dev_position" class="input_width" type="text" /></td>
						 </tr>
						 	 <tr>
						    <td class="inquire_item6">总数量</td>
						    <td class="inquire_form6"><input id="total_num" name="total_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">闲置数量</td>
						    <td class="inquire_form6"><input id="unuse_num" name="unuse_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">在用数量</td>
						    <td class="inquire_form6"><input id="use_num" name="use_num" class="input_width" type="text" /></td>
						 </tr>
						  <tr>
						    <td class="inquire_item6">其它数量</td>
						    <td class="inquire_form6"><input id="other_num" name="other_num" class="input_width" type="text" /></td>
						 </tr>
					
			        </table>
				</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				  	<tr align="right">
				  		<td class="ali_cdn_name" ></td>
				  		<td class="ali_cdn_input" ></td>
				  		<td class="ali_cdn_name" ></td>
				  		<td class="ali_cdn_input" ></td>
				  		<td>&nbsp;</td>
						<!--<auth:ListButton functionId="" css="xg" event="onclick='toEditTech()'" title="JCDP_btn_edit"></auth:ListButton>-->
					</tr>
				</table>
				<table id="tab_dev_tech" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">完好</td>
						    <td class="inquire_form6"><input id="good_num" name="good_num"  class="input_width" type="text" /></td>
						    <td class="inquire_item6">待报废</td>
						    <td class="inquire_form6"><input id="touseless_num" name="touseless_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">待修</td>
						    <td class="inquire_form6"><input id="torepair_num" name="torepair_num" class="input_width" type="text" /></td>
						</tr>
						<tr>   
						 <td class="inquire_item6">在修</td>
						    <td class="inquire_form6"><input id="repairing_num" name="repairing_num" class="input_width" type="text" /></td> 
						    <td class="inquire_item6">盘亏</td>
						    <td class="inquire_form6"><input id="tocheck_num" name="tocheck_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">毁损</td>
						    <td class="inquire_form6"><input id="destroy_num" name="destroy_num" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						   <td class="inquire_item6">未交回</td>
						    <td class="inquire_form6"><input id="noreturn_num" name="noreturn_num" class="input_width" type="text" /></td>
						 </tr>
				</table>
			</div>
			 
		 </div>
</div>

<script >
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var orgtype = '<%=orgType%>';//大港8个专业化中心判断
	var usersubid = '<%=userSubid%>';
	var node_level = '<%=node_level%>';
	var is_leaf = '<%=is_leaf%>';
	var code = '<%=code%>';
	var userOrgId = '<%=userOrgId%>';
	var selectedTagIndex = 0;
	var userid = '<%=subOrgId%>';
	var orgLength = userid.length;
	//下拉时查询
	function selectRefreshData(){
	    searchDevData();
	}
	function searchDevData(){
		var query_dev_name = document.getElementById("query_dev_name").value;
		var query_dev_type = document.getElementById("type_id").value;
	 	var query_dev_country=document.getElementById("country").value;
		refreshData(query_dev_name,query_dev_type,query_dev_country);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("query_dev_name").value="";
		document.getElementById("type_id").value="";
		document.getElementById("country").value="";
		searchDevData();
    }
	//点击树节点查询
	function refreshData(query_dev_name,query_dev_type,query_dev_country){
		debugger;
		var sql = "select rownum rm,t.*,(use_num+unuse_num+other_num) total_num from (select info.org_abbreviation， b.dev_name,b.dev_model,temp.dev_code,'台' dev_unit,b.ifcountry, sum(decode(b.using_stat, '0110000007000000001', 1, 0)) as use_num, sum(decode(b.using_stat, '0110000007000000002', 1, 0)) as unuse_num, sum(decode(b.using_stat, '0110000007000000006',1, 0)) as other_num from gms_device_account_b b left join comm_org_information info on info.org_id = b.owning_org_id left join (select ci.device_id,ci.dev_code,ci.dev_name,ci.dev_model, dci.dev_ci_code,dci.dev_ci_name,dci.dev_ci_model from gms_device_collectinfo ci left join gms_device_coll_mapping cm on ci.device_id = cm.device_id left join gms_device_codeinfo dci on cm.dev_ci_code=dci.dev_ci_code) temp on temp.dev_ci_code=b.dev_type where ( b.dev_type like 'S14050104%'or b.dev_type like 'S14050102%' or b.dev_type like 'S14050103%')   and info.bsflag='0' and b.bsflag='0' and b.account_stat = '0110000013000000003'  "
		if((typeof(query_dev_name)!="undefined"&&query_dev_name!='')  ){
		sql=sql+" and b.dev_name like'%"+query_dev_name+"%'";
		}
		if((typeof(query_dev_type)!="undefined"&&query_dev_type!='')  ){
		sql=sql+" and b.dev_model like'%"+query_dev_type+"%'";
		}
		if((typeof(query_dev_country)!="undefined"&&query_dev_country!='')  ){
		sql=sql+" and b.ifcountry like'"+query_dev_country+"%'";
		}
		sql=sql+" group by info.org_abbreviation,b.dev_name,b.dev_model,temp.dev_code,ifcountry) t ";
		cruConfig.queryStr = sql;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
	}
	 
    
	  
    //点击记录查询明细信息
    function loadDataDetail(shuaId){
    	var retObj;
		 
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
        for (i=0; i<obj.length; i++){   
            obj[i].checked = false;   
        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+shuaId).attr("checked","checked");
		//------------------------------------------------------------------------------------
	 
		$("#total_num").val($("#rdo_entity_id_"+shuaId).attr('total_num'));
		$("#other_num").val($("#rdo_entity_id_"+shuaId).attr('other_num'));
		$("#unuse_num").val($("#rdo_entity_id_"+shuaId).attr('unuse_num'));
		$("#use_num").val($("#rdo_entity_id_"+shuaId).attr('use_num'));
		
			$("#dev_name").val($("#rdo_entity_id_"+shuaId).attr('dev_name'));
		$("#dev_type").val($("#rdo_entity_id_"+shuaId).attr('dev_type'));
		$("#dev_model").val($("#rdo_entity_id_"+shuaId).attr('dev_model'));
		$("#usage_org").val($("#rdo_entity_id_"+shuaId).attr('usage_org'));
	    retObj = jcdpCallService("DevCommInfoSrv", "getCollDevAppInfosForJSZT", "dev_name="+$("#rdo_entity_id_"+shuaId).attr('dev_name')+"&dev_model="+$("#rdo_entity_id_"+shuaId).attr('dev_model')+"&org_abbreviation="+$("#rdo_entity_id_"+shuaId).attr('usage_org'));
   	  
   			var map=retObj.datas[0];
   			 
   			$("#good_num").val(map.wanhao);//完好数
   			$("#touseless_num").val(map.daibaofei);//带报废
   			$("#torepair_num").val(map.daixiu);//待修
   	 
    }
    function dialogClose(str){
    	if(str!=''){
    		art.dialog.list['KDf435'].close();
    	}
    }
    function dialogValue(str){
    	if(str!=''){
    	 art.dialog({
    		 id:'KDf435',
    		 left:200,
    		 opacity: 0.17,
    		    padding: 0,
    		    width: '300',
    		    height: 80,
    		    title: '台帐变更明细',
    		    content: str   
    		});
    	}
    }
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr style='cursor:hand' onmouseout='dialogClose("+"\""+datas[i].remark+"\""+")' onmouseover='dialogValue("+"\""+datas[i].remark+"\""+")' >";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].rectype+"</td><td>"+datas[i].recdate+"</td>";
			innerHTML += "<td>"+datas[i].opr_num+"</td>";
			innerHTML += "<td>"+datas[i].wanhao_num+"</td><td>"+datas[i].weixiu_num+"</td><td>"+datas[i].zaixiu_num+"</td>";
			innerHTML += "<td>"+datas[i].pankui_num+"</td><td>"+datas[i].huisun_num+"</td><td>"+datas[i].touseless_num+"</td><td>"+datas[i].noreturn_num+"</td><td>"+datas[i].bak+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	function appendDataToDetailPro(filterobj,datas){
		for(var i=0;i<datas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].project_name+"</td><td>"+datas[i].unuse_num+"</td>";
			innerHTML += "<td>"+datas[i].org_abbreviation+"</td><td>"+datas[i].actual_in_time+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	function toDelete(){
 		var ids = getSelIds('rdo_entity_id');
		if(ids==''){ 
			alert("请先选中一条记录!");
		    return;
		 }			    
		if(confirm('确定要删除吗?')){
			var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
			var sql = "update GMS_DEVICE_COLL_ACCOUNT set bsflag = '1' where dev_acc_id = '{id}'";
			var paramStr = "sql="+sql+"&ids="+ids;
			syncRequest('post',path,paramStr); 
			queryData(cruConfig.currentPage);				
		}
	}
	//打开查询条件页面
    function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/collectTreeNew/devquery.jsp');
    }
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	
	$(document).ready(lashen);
	
	function toEditTech(){		
		var ids = getSelIds('rdo_entity_id');
		if(ids==''){ 
			alert("请先选中一条记录!");
	     	return;
		 }
		 popWindow('<%=contextPath%>/rm/dm/collectTreeNew/editTech.jsp?devaccid='+ids); 		
	}
	function createNewTitleTable(){
		// 如果是dialog
		if(window.dialogArguments){
			return;
		}
		
		// 如果声明了不出现固定表头
		if(window.showNewTitle==false){
			return;
		}
		
		var newTitleTable = document.getElementById("newTitleTable");
		if(newTitleTable!=null) return;
		var queryRetTable = document.getElementById("queryRetTable");
		if(queryRetTable==null) return;
		var titleRow = queryRetTable.rows(0);
		
		var newTitleTable = document.createElement("table");
		newTitleTable.id = "newTitleTable";
		newTitleTable.className="tab_info";
		newTitleTable.border="0";
		newTitleTable.cellSpacing="0";
		newTitleTable.cellPadding="0";
		newTitleTable.style.width = queryRetTable.clientWidth;
		newTitleTable.style.position="absolute";
		var x = getAbsLeft(queryRetTable);
		newTitleTable.style.left=x+"px";
		var y = getAbsTop(queryRetTable);
		newTitleTable.style.top=y+"px";
				
		var tbody = document.createElement("tbody");
		var tr = titleRow.cloneNode(true);
		
		tbody.appendChild(tr);
		newTitleTable.appendChild(tbody);
		document.body.appendChild(newTitleTable);
		// 设置每一列的宽度
		for(var i=0;i<tr.cells.length;i++){
			tr.cells[i].style.width=titleRow.cells[i].clientWidth;
			if(i%2==0){
				tr.cells[i].className="bt_info_odd";
			}else{
				tr.cells[i].className="bt_info_even";
			}
			// 设置是否显示
			if(titleRow.cells[i].isShow=="Hide"){
				tr.cells[i].style.display='none';
			}
		}
		
		document.getElementById("table_box").onscroll = resetNewTitleTablePos;		
	}
	function showOrgTreePage(){

		var returnValue = window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var orgidnames = names[1];
		document.getElementById("s_own_org_name").value = orgidnames;
		
		var orgId = strs[1].split(":");
		var orgidvalue = orgId[1];
		document.getElementById("owning_org_id").value = orgidvalue;

		var orgSubId = strs[2].split(":");
		var orgSubIdValue = orgSubId[1];
		document.getElementById("owning_sub_org_id").value = orgSubIdValue;
	}
</script>
</body>
</html>