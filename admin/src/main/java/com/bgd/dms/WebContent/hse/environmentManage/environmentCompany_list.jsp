<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_subjection_id = user.getOrgSubjectionId();
	String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	String father_id = "";
	String sub_id = "";
//	String father_organ_flag = "";
	String organ_flag = "";
	if(list.size()>1){
	 	Map map = (Map)list.get(0);
/*	 	Map mapOrg = (Map)list.get(1);
	 	father_id = (String)map.get("orgSubId");
	 	sub_id = (String)mapOrg.get("orgSubId");
	 	father_organ_flag = (String)map.get("organFlag");
	 	organ_flag = (String)mapOrg.get("organFlag");
*/	
	 	sub_id = (String)map.get("orgSubId");
	 	organ_flag = (String)map.get("organFlag");
	 	
	 	if(organ_flag.equals("0")){
	 		father_id = "C105";
	 		organ_flag = "0";
	 	}
	}else{
		father_id = "C105";
 		organ_flag = "0";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
<style type="text/css">
.ali_cdn_input{
	width: 180px;
	text-align: left; 
}

.ali_cdn_input input{
	width: 80%;
}

</style>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">单位</td>
			    <td class="ali_cdn_input">
			    <input id="third_org_name" name="third_org_name" type="text" />
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			     <auth:ListButton functionId="F_HSE_ENVIRON_006" css="sz" event="onclick='toSet()'" title="设置"></auth:ListButton>
			     <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="提交"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_environment_id},{status},{org_sub_id}' id='rdo_entity_id_{hse_environment_id}'  onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{third_org_name}">单位</td>
			      <td class="bt_info_even" exp="{year}">年</td>
			      <td class="bt_info_odd" exp="{month}">月</td>
			      <td class="bt_info_even" exp="{status}">状态</td>
			      <td class="bt_info_odd" exp="{submit_person}">提交人</td>
			      <td class="bt_info_even" exp="{submit_date}">提交日期</td>
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
		  </div>
</body>

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	var org_id = '';
	var organ_flag = "<%=organ_flag%>";
	// 复杂查询
	function refreshData(){
		
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select en.hse_environment_id,en.org_sub_id,to_char(en.create_date,'yyyy') year,to_char(en.create_date,'MM') month,en.submit_person,en.submit_date,decode(en.status,'0','未填写','1','已填写','2','已提交 ','3','审批通过','4','审批未通过') status,oi1.org_abbreviation third_org_name,oi2.org_abbreviation second_org_name from bgp_hse_environment en left join bgp_hse_org ho on en.org_sub_id=ho.org_sub_id left join comm_org_subjection os1 on os1.org_subjection_id=en.org_sub_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on ho.father_org_sub_id=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0'";
		if(organ_flag=="0"){
			cruConfig.queryStr += " where ho.father_org_sub_id = '<%=father_id%>'"; 
		}else{
			cruConfig.queryStr += " where ho.org_sub_id = '<%=sub_id%>'"; 
		}
		cruConfig.queryStr += " order by en.create_date desc,en.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/environmentManage/environment_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/environmentManage/environment_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
			var third_org_name = document.getElementById("third_org_name").value;
				if(third_org_name!=''&&third_org_name!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "select en.hse_environment_id,en.org_sub_id,to_char(en.create_date,'yyyy') year,to_char(en.create_date,'MM') month,en.submit_person,en.submit_date,decode(en.status,'0','未填写','1','已填写','2','已提交 ','3','审批通过','4','审批未通过') status,oi1.org_abbreviation third_org_name,oi2.org_abbreviation second_org_name from bgp_hse_environment en left join bgp_hse_org ho on en.org_sub_id=ho.org_sub_id left join comm_org_subjection os1 on os1.org_subjection_id=en.org_sub_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on ho.father_org_sub_id=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0'";
					if(organ_flag=="0"){
						cruConfig.queryStr += " where ho.father_org_sub_id = '<%=father_id%>'"; 
					}else{
						cruConfig.queryStr += " where ho.org_sub_id = '<%=sub_id%>'"; 
					}
					cruConfig.queryStr += " and oi1.org_abbreviation like '%"+third_org_name+"%' order by en.create_date desc,en.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/environmentManage/environment_list.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("third_org_name").value = "";
	}
	
	
	function renderTable(tbObj,tbCfg){
		//更新导航栏
		renderNaviTable(tbObj,tbCfg);
		//删除上次的查询结果
		var headChxBox = getObj("headChxBox");
		if(headChxBox!=undefined) headChxBox.checked = false;
		for(var i=tbObj.rows.length-1;i>0;i--)
			tbObj.deleteRow(i);

		var titleRow = tbObj.rows(0);

		//设置选中的行号为0 
		tbObj.selectedRow = 0;
		tbObj.selectedValue = '';
		
		//给每一类添加exp属性，在ie9+iframe的情况下，td标签内的exp属性识别不出
		for(var j=0;j<titleRow.cells.length;j++){
			var tCell = titleRow.cells(j);
			tCell.exp = tCell.getAttribute("exp");
			tCell.cellClass = tCell.getAttribute("cellClass");
		}// end
		
		var datas = tbCfg.items;
		if(datas!=null)
		for(var i=0;i<datas.length;i++){
			var data = datas[i];
			var vTr = tbObj.insertRow();
			vTr.orderNum = i+1;
			// 选中行高亮
			vTr.ondblclick = function(){
				//alert(tbObj.selectedRow);
				// 取消之前高亮的行
				if(tbObj.selectedRow>0){
					var oldTr = tbObj.rows[tbObj.selectedRow];
					var cells = oldTr.cells;
					for(var j=0;j<cells.length;j++){
						cells[j].style.background="#96baf6";
						// 设置列样式
						if(tbObj.selectedRow%2==0){
							if(j%2==1) cells[j].style.background = "#FFFFFF";
							else cells[j].style.background = "#f6f6f6";
						}else{
							if(j%2==1) cells[j].style.background = "#ebebeb";
							else cells[j].style.background = "#e3e3e3";
						}
					}
				}
				tbObj.selectedRow=this.orderNum;
				// 设置新行高亮
				var cells = this.cells;
				for(var i=0;i<cells.length;i++){
					cells[i].style.background="#ffc580";
				}
				tbObj.selectedValue = cells[0].childNodes[0].value;
				// 加载Tab数据
				loadDataDetail(cells[0].childNodes[0].value);
			}
			
			if(cruConfig.cruAction=='list2Link'){//列表页面选择坐父页面某元素的外键
				vTr.onclick = function(){
					eval(rowSelFuncName+"(this)");
				}
				vTr.onmouseover = function(){this.className = "trSel";}
				vTr.onmouseout = function(){this.className = this.initClassName;}
			}

			for(var j=0;j<titleRow.cells.length;j++){
				var tCell = titleRow.cells(j);
				var vCell = vTr.insertCell();
				// 设置列样式
				if(i%2==1){
					if(j%2==1) vCell.className = "even_even";
					else vCell.className = "even_odd";
				}else{
					if(j%2==1) vCell.className = "odd_even";
					else vCell.className = "odd_odd";
				}
				// 自动计算序号
				if(tCell.autoOrder=='1' || tCell.getAttribute('autoOrder')=='1'){
					vCell.innerHTML=((tbCfg.currentPage-1) * tbCfg.pageSize + 1 + i);
					continue;
				}
				
				var outputValue = getOutputValue(tCell,data);
				var cellValue = outputValue;
				
				if(tCell.isShow=="Edit"){
					cellValue = "<input type=text onclick=tableInputEditable(this) onkeydown=tableInputkeydown(this) class=rtTableInputReadOnly";
					if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName
					else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2);
					if(tCell.size!=undefined) cellValue += " size="+tCell.size;
					else cellValue += " size=8";
					cellValue += " value='"+outputValue+"'>";
				}
				else if(tCell.isShow=="Hide"){
					cellValue = "<input type=text value="+outputValue;
					if(tCell.fieldName!=undefined) cellValue += " name="+tCell.fieldName+">"
					else cellValue += " name="+tCell.exp.substr(1,tCell.exp.length-2)+">";
					vCell.style.display = 'none';
				}else if(tCell.isShow=="TextHide"){
					vCell.style.display = 'none';
				}
	//alert(typeof cellValue);alert(cellValue == undefined);
				if(cellValue == undefined || cellValue == 'undefined') cellValue = "";
				if(cellValue=='') {cellValue = "&nbsp;";}
				else if(cellValue.indexOf("undefined")!=-1){
				   cellValue = cellValue.replace("undefined","");
				}

				vCell.innerHTML = cellValue;
			}
		}
		for(var i=datas.length;i<tbCfg.pageSize;i++){
			var vTr = tbObj.insertRow();
			for(var j=0;j<titleRow.cells.length;j++){
				var tCell = titleRow.cells(j);
				var vCell = vTr.insertCell();
				// 设置列样式
				if(i%2==1){
					if(j%2==1) vCell.className = "even_even";
					else vCell.className = "even_odd";
				}else{
					if(j%2==1) vCell.className = "odd_even";
					else vCell.className = "odd_odd";
				}
				vCell.innerHTML = "&nbsp;";
			}
		}
		
		createNewTitleTable();
		resizeNewTitleTable();
}
	
	function loadDataDetail(shuaId){
		var retObj;
		var hse_environment_ids = "";
		if(shuaId!=null){
			hse_environment_ids = shuaId;
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    hse_environment_ids = ids;
		}
		var temp = hse_environment_ids.split(',');
		var hse_environment_id = temp[0];
		popWindow("<%=contextPath%>/hse/yxControl/IntoAddJsp.srq?hse_environment_id="+hse_environment_id,"1000:680");
	}

	
	function toSubmit(){
		    ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }
		    var temp = ids.split(',');
			var hse_environment_id = temp[0];
			var status = temp[1];
			var org_sub_id = temp[2];
			if(org_sub_id=="<%=sub_id%>"){
				if(status=="已提交"||status=="审批通过"){
				    	alert("该记录"+status+"，不能提交!");
				    	return;
				}else{
					var sql = "update bgp_hse_environment set status='2' where  bsflag='0' and hse_environment_id='"+hse_environment_id+"'";
					if (!window.confirm("确认要提交吗?")) {
						return;
					}
					var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
					var params = "sql="+sql;
					params += "&ids="+ids;
					var retObject = syncRequest('Post',path,params);
					if(retObject.returnCode!=0){
						alert(retObject.returnMsg);
					}else{
						retObj = jcdpCallService("HseSrv", "submitMethod", "hse_environment_id="+hse_environment_id);
						queryData(cruConfig.currentPage);
					}
				}
			}else{
				alert("只能对本单位记录进行操作！");
		    	return;
			}
		}
	
	function toSet(){
		window.showModalDialog('<%=contextPath%>/hse/environmentManage/setOrgTree.jsp');
		
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/environmentManage/environmentCompany_search.jsp");
	}
	
</script>

</html>

