<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();

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
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">姓名</td>
			    <td class="ali_cdn_input"><input id="person_name" name="person_name" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_driving_id}' id='rdo_entity_id_{hse_driving_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">二级单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">基层单位</td>
			      <td class="bt_info_odd" exp="{name}">姓名</td>
			      <td class="bt_info_even" exp="{car_type}">准驾车型</td>
			      <td class="bt_info_odd" exp="{driving_number}">准驾证编号</td>
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
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" id="tag000" onclick="getTab3(0)">准驾证</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<div id="type_A">
					<form name="form0" id="form0"  method="post" action="">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	             	 </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
						<input type="hidden" id="driving_type" name="driving_type" value=""></input>
						<input type="hidden" id="hse_driving_id" name="hse_driving_id" value=""></input>
						<input type="hidden" id="remark_id" name="remark_id" value=""></input>
					  <tr>
					     	<td class="inquire_item6"><font color="red">*</font>二级单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="second_org" name="second_org" class="input_width"  value=""/>
					      	<input type="text" id="second_org2" name="second_org2" class="input_width"  value="" readonly="readonly"/>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
					      	</td>
					     	<td class="inquire_item6"><font color="red">*</font>基层单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="third_org" name="third_org" class="input_width"  value="" />
					      	<input type="text" id="third_org2" name="third_org2" class="input_width"   value="" readonly="readonly"/>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
					      	</td>
					    	<td class="inquire_item6"><font color="red">*</font>姓名：</td>
					      	<td class="inquire_form6"><input type="text" id="name" name="name" class="input_width"  value=""/></td>
					     </tr>
						 <tr>
					     	<td class="inquire_item6"><font color="red">*</font>性别：</td>
					      	<td class="inquire_form6">
					      		<select id="sex" name="sex" class="select_width">
						          <option value="" >请选择</option>
						          <option value="1" >男</option>
						          <option value="2" >女</option>
							    </select>
					      	</td>
					    	<td class="inquire_item6"><font color="red">*</font>出生年月：</td>
					      	<td class="inquire_form6"><input type="text" id="birthday" name="birthday" class="input_width"   value="" readonly="readonly"/>
					      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(birthday,tributton1);" />&nbsp;</td>
					     	<td class="inquire_item6"><font color="red">*</font>身份证号：</td>
					      	<td class="inquire_form6"><input type="text" id="card_id" name="card_id" class="input_width"  value=""/></td>
					     </tr>
					     <tr>
						    <td class="inquire_item6"><font color="red">*</font>准驾证档案编号：</td>
						    <td class="inquire_form6"><input type="text" id="file_number" name="file_number" class="input_width" value=""/></td>
						    <td class="inquire_item6"><font color="red">*</font>准驾车型：</td>
						    <td class="inquire_form6"><input type="text" id="car_type" name="car_type" class="input_width" value=""/></td>
						  <td class="inquire_item6"><font color="red">*</font>准驾证编号：</td>
						    <td class="inquire_form6"><input type="text" id="driving_number" name="driving_number" class="input_width" value=""></input></td>
						  </tr>
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>发证单位：</td>
						    <td class="inquire_form6"><input type="text" id="sign_org" name="sign_org" class="input_width" value=""/></td>
						   <td class="inquire_item6"><font color="red">*</font>签发人：</td>
						    <td class="inquire_form6"><input type="text" id="signer" name="signer" class="input_width" value=""/></td>
						    <td class="inquire_item6"><font color="red">*</font>签发日期：</td>
						    <td class="inquire_form6"><input type="text" id="sign_date" name="sign_date" class="input_width" value="" readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(sign_date,tributton3);" />&nbsp;</td>
						  </tr>
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>有效期：</td>
						    <td class="inquire_form6"><input type="text" id="expiry_date" name="expiry_date" class="input_width" value="" readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(expiry_date,tributton4);" />&nbsp;</td>
						    <td class="inquire_item6"><font color="red">*</font>二级单位联系人：</td>
						    <td class="inquire_form6"><input type="text" id="contract_person" name="contract_person" class="input_width" value=""/></td>
						   <td class="inquire_item6"><font color="red">*</font>联系电话：</td>
						    <td class="inquire_form6"><input type="text" id="contract_phone" name="contract_phone" class="input_width" value=""/></td>
						  </tr>
					  <tr>
					  	<td class="inquire_item6">备注：</td>
					  	<td class="inquire_form6" colspan="5"><textarea id="memo" name="memo" class="textarea"></textarea></td>
					  </tr>
					</table>
				</form>
				</div>
				<div id="type_B" style="display: none;">
				<form name="form1" id="form1"  method="post" action="">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()"></a></span></td>
		                  <td width="5"></td>
		                </tr>
	             	 </table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
						<input type="hidden" id="driving_type1" name="driving_type" value=""></input>
						<input type="hidden" id="hse_driving_id1" name="hse_driving_id" value=""></input>
						<input type="hidden" id="remark_id1" name="remark_id" value=""></input>
					  <tr>
					     	<td class="inquire_item6"><font color="red">*</font>二级单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="second_org1" name="second_org" class="input_width"  value=""/>
					      	<input type="text" id="second_org21" name="second_org2" class="input_width"  value="" readonly="readonly"/>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
					      	</td>
					     	<td class="inquire_item6"><font color="red">*</font>基层单位：</td>
					      	<td class="inquire_form6">
					      	<input type="hidden" id="third_org1" name="third_org" class="input_width"  value="" />
					      	<input type="text" id="third_org21" name="third_org2" class="input_width"   value="" readonly="readonly"/>
					      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
					      	</td>
					    	<td class="inquire_item6"><font color="red">*</font>姓名：</td>
					      	<td class="inquire_form6"><input type="text" id="name1" name="name" class="input_width"  value=""/></td>
					     </tr>
						 <tr>
					     	<td class="inquire_item6"><font color="red">*</font>性别：</td>
					      	<td class="inquire_form6">
					      		<select id="sex1" name="sex" class="select_width">
						          <option value="" >请选择</option>
						          <option value="1" >男</option>
						          <option value="2" >女</option>
							    </select>
					      	</td>
					    	<td class="inquire_item6"><font color="red">*</font>出生年月：</td>
					      	<td class="inquire_form6"><input type="text" id="birthday1" name="birthday" class="input_width"   value="" readonly="readonly"/>
					      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(birthday,tributton1);" />&nbsp;</td>
					      	<td class="inquire_item6"><font color="red">*</font>人员职务：</td>
					      	<td class="inquire_form6">
					      		<select id="duty1" name="duty" class="select_width">
						          <option value="" >请选择</option>
						          <option value="1" >处级</option>
						          <option value="2" >科级</option>
						          <option value="3" >其他</option>
							    </select>
					      	</td>
					     </tr>
					     <tr>
					     	<td class="inquire_item6"><font color="red">*</font>身份证号：</td>
					      	<td class="inquire_form6"><input type="text" id="card_id1" name="card_id" class="input_width"  value=""/></td>
						    <td class="inquire_item6"><font color="red">*</font>准驾证档案编号：</td>
						    <td class="inquire_form6"><input type="text" id="file_number1" name="file_number" class="input_width" value=""/></td>
						    <td class="inquire_item6"><font color="red">*</font>准驾车型：</td>
						    <td class="inquire_form6"><input type="text" id="car_type1" name="car_type" class="input_width" value=""/></td>
						  </tr>
						  <tr>
						  <td class="inquire_item6"><font color="red">*</font>准驾证编号：</td>
						    <td class="inquire_form6"><input type="text" id="driving_number1" name="driving_number" class="input_width" value=""></input></td>
						    <td class="inquire_item6"><font color="red">*</font>发证单位：</td>
						    <td class="inquire_form6"><input type="text" id="sign_org1" name="sign_org" class="input_width" value=""/></td>
						   <td class="inquire_item6"><font color="red">*</font>签发人：</td>
						    <td class="inquire_form6"><input type="text" id="signer1" name="signer" class="input_width" value=""/></td>
						  </tr>
						  <tr>
						    <td class="inquire_item6"><font color="red">*</font>签发日期：</td>
						    <td class="inquire_form6"><input type="text" id="sign_date1" name="sign_date" class="input_width" value="" readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(sign_date,tributton3);" />&nbsp;</td>
						    <td class="inquire_item6"><font color="red">*</font>有效期：</td>
						    <td class="inquire_form6"><input type="text" id="expiry_date1" name="expiry_date" class="input_width" value="" readonly="readonly"/>
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(expiry_date,tributton4);" />&nbsp;</td>
						    <td class="inquire_item6"><font color="red">*</font>二级单位联系人：</td>
						    <td class="inquire_form6"><input type="text" id="contract_person1" name="contract_person" class="input_width" value=""/></td>
						  </tr>
						  <tr>
   						    <td class="inquire_item6"><font color="red">*</font>联系电话：</td>
						    <td class="inquire_form6"><input type="text" id="contract_phone1" name="contract_phone" class="input_width" value=""/></td>
   						    <td class="inquire_item6"></td>
						    <td class="inquire_form6"></td>
   						    <td class="inquire_item6"></td>
						    <td class="inquire_form6"></td>
						  </tr>
						  <tr>
						  	<td class="inquire_item6">备注：</td>
						  	<td class="inquire_form6" colspan="5"><textarea id="memo1" name="memo" class="textarea"></textarea></td>
						  </tr>
					</table>
				</form>
				</div>
				</div>
			</div>
		  </div>

</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
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
	var driving_type = "";
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select t.hse_driving_id,t.second_org,t.third_org,t.name,t.car_type,t.driving_number, r.notes,oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name, t.create_date,t.modifi_date,months_between(t.expiry_date,to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd')) color  from bgp_hse_control_driving t join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join bgp_comm_remark r on t.hse_driving_id = r.foreign_key_id and r.bsflag='0' where t.bsflag = '0' order by modifi_date desc";
		cruConfig.currentPageUrl = "/hse/yxControl/safeManage/jazheng/driving_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/yxControl/safeManage/jazheng/driving_list.jsp";
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
			var name = document.getElementById("person_name").value;
				if(name!=''&&name!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "select t.hse_driving_id,t.second_org,t.third_org,t.name,t.car_type,t.driving_number, r.notes,oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name, t.create_date,t.modifi_date,months_between(t.expiry_date,to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd')) color  from bgp_hse_control_driving t join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join bgp_comm_remark r on t.hse_driving_id = r.foreign_key_id and r.bsflag='0' where t.bsflag = '0' and t.name like '%"+name+"%' order by modifi_date desc";
					cruConfig.currentPageUrl = "/hse/yxControl/safeManage/jazheng/driving_list.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("person_name").value = "";
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "queryDriving", "hse_driving_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "queryDriving", "hse_driving_id="+ids);
		}
		driving_type = retObj.map.drivingType;
		document.getElementById("driving_type1").value =retObj.map.drivingType;
		document.getElementById("driving_type").value =retObj.map.drivingType;
		if(driving_type=="2"){
			document.getElementById("type_B").style.display = "";
			document.getElementById("type_A").style.display = "none";
			document.getElementById("tag000").innerHTML = "乙类准驾证";
		}else if(driving_type=="1"){
			document.getElementById("type_B").style.display = "none";
			document.getElementById("type_A").style.display = "";
			document.getElementById("tag000").innerHTML = "甲类准驾证";
		}else if(driving_type=="3"){
			document.getElementById("type_B").style.display = "none";
			document.getElementById("type_A").style.display = "";
			document.getElementById("tag000").innerHTML = "丙类准驾证";
		}
		document.getElementById("hse_driving_id").value =retObj.map.hseDrivingId;
		document.getElementById("remark_id").value =retObj.map.remarkId;
		document.getElementById("second_org").value =retObj.map.secondOrg;
		document.getElementById("third_org").value =retObj.map.thirdOrg;
		document.getElementById("second_org2").value =retObj.map.secondOrgName;
		document.getElementById("third_org2").value =retObj.map.thirdOrgName;
		document.getElementById("name").value =retObj.map.name;
		document.getElementById("sex").value = retObj.map.sex;
		document.getElementById("birthday").value = retObj.map.birthday;
		document.getElementById("card_id").value = retObj.map.cardId;
		document.getElementById("file_number").value = retObj.map.fileNumber;
		document.getElementById("car_type").value = retObj.map.carType;
		document.getElementById("driving_number").value = retObj.map.drivingNumber;
		document.getElementById("sign_org").value = retObj.map.signOrg;
		document.getElementById("signer").value = retObj.map.signer;
		document.getElementById("sign_date").value = retObj.map.signDate;
		document.getElementById("expiry_date").value = retObj.map.expiryDate;
		document.getElementById("contract_person").value = retObj.map.contractPerson;
		document.getElementById("contract_phone").value = retObj.map.contractPhone;
		document.getElementById("memo").value = retObj.map.notes;
		
		document.getElementById("hse_driving_id1").value =retObj.map.hseDrivingId;
		document.getElementById("remark_id1").value =retObj.map.remarkId;
		document.getElementById("second_org1").value =retObj.map.secondOrg;
		document.getElementById("third_org1").value =retObj.map.thirdOrg;
		document.getElementById("second_org21").value =retObj.map.secondOrgName;
		document.getElementById("third_org21").value =retObj.map.thirdOrgName;
		document.getElementById("name1").value =retObj.map.name;
		document.getElementById("sex1").value = retObj.map.sex;
		document.getElementById("birthday1").value = retObj.map.birthday;
		document.getElementById("duty1").value = retObj.map.duty;
		document.getElementById("card_id1").value = retObj.map.cardId;
		document.getElementById("file_number1").value = retObj.map.fileNumber;
		document.getElementById("car_type1").value = retObj.map.carType;
		document.getElementById("driving_number1").value = retObj.map.drivingNumber;
		document.getElementById("sign_org1").value = retObj.map.signOrg;
		document.getElementById("signer1").value = retObj.map.signer;
		document.getElementById("sign_date1").value = retObj.map.signDate;
		document.getElementById("expiry_date1").value = retObj.map.expiryDate;
		document.getElementById("contract_person1").value = retObj.map.contractPerson;
		document.getElementById("contract_phone1").value = retObj.map.contractPhone;
		document.getElementById("memo1").value = retObj.map.notes;
		
		
	}
	
	
	/*
	*查询结果的显示
	*/
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
		if(datas!=null){
			debugger;
			for(var i=0;i<datas.length;i++){
				var data = datas[i];
				var month = data.color;
				var vTr = tbObj.insertRow();
				vTr.orderNum = i+1;
				
				// 选中行高亮
				vTr.onclick = function(){
					//alert(tbObj.selectedRow);
					// 取消之前高亮的行
					if(tbObj.selectedRow>0){
						debugger;
						var oldTr = tbObj.rows[tbObj.selectedRow];
						month = datas[tbObj.selectedRow-1].color;
						var cells = oldTr.cells;
						for(var j=0;j<cells.length;j++){
							cells[j].style.background="#96baf6";
							// 设置列样式
							if(tbObj.selectedRow%2==0){
								if(j%2==1) {
									cells[j].style.background = "#FFFFFF";
									if(month>0&&month<2){
										cells[j].style.background="yellow";
									}else if(month<0){
										cells[j].style.background="red";
									}
								}
								else {
									cells[j].style.background = "#f6f6f6";
									if(month>0&&month<2){
										cells[j].style.background="yellow";
									}else if(month<0){
										cells[j].style.background="red";
									}
								}
							}else{
								if(j%2==1) {
									cells[j].style.background = "#ebebeb";
									if(month>0&&month<2){
										cells[j].style.background="yellow";
									}else if(month<0){
										cells[j].style.background="red";
									}
								}
								else{
									cells[j].style.background = "#e3e3e3";
									if(month>0&&month<2){
										cells[j].style.background="yellow";
									}else if(month<0){
										cells[j].style.background="red";
									}
								}
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
				vTr.ondblclick = function(){
					var cells = this.cells;
					dbclickRow(cells[0].childNodes[0].value);
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
						if(j%2==1){
							vCell.className = "even_even";
							if(month>0&&month<2){
								vCell.style.background="yellow";
							}else if(month<0){
								vCell.style.background="red";
							}
						}
						else{
							vCell.className = "even_odd";
							if(month>0&&month<2){
								vCell.style.background="yellow";
							}else if(month<0){
								vCell.style.background="red";
							}
						}
					}else{
						if(j%2==1){
							vCell.className = "odd_even";
							if(month>0&&month<2){
								vCell.style.background="yellow";
							}else if(month<0){
								vCell.style.background="red";
							}
						}
						else{ 
							vCell.className = "odd_odd";
							if(month>0&&month<2){
								vCell.style.background="yellow";
							}else if(month<0){
								vCell.style.background="red";
							}
						}
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
		}
		createNewTitleTable();
		resizeNewTitleTable();
	}
	
	

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function toAdd(){
		var obj = new Object();
		popWindow("<%=contextPath%>/hse/yxControl/safeManage/jiazheng/selectDriving.jsp");
	//	window.showModalDialog("<%=contextPath%>/hse/yxControl/safeManage/jiazheng/selectDriving.jsp",obj,"dialogWidth=520px;dialogHeight=200px");
		
	}
	
	function toEdit(){  
		var hse_driving_id = document.getElementById("hse_driving_id").value;
	  	if(hse_driving_id==''||hse_driving_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	popWindow("<%=contextPath%>/hse/driving/queryDriving.srq?hse_driving_id="+hse_driving_id);
	  	
	} 
	
	
	
	function toUpdate(){  
		var form = "";
		if(driving_type=="2"){
			if(checkText1()){
				return;
			}
			form = document.getElementById("form1");
		}else{
			if(checkText0()){
				return;
			}
			form = document.getElementById("form0");
		}
		form.action="<%=contextPath%>/hse/driving/saveDriving.srq";
		form.submit();
	} 
	
	
	function checkText0(){
		var driving_type = document.getElementById("driving_type").value;
		var second_org=document.getElementById("second_org").value;
		var third_org=document.getElementById("third_org").value;
		var name=document.getElementById("name").value;
		var sex=document.getElementById("sex").value;
		var birthday=document.getElementById("birthday").value;
		var card_id=document.getElementById("card_id").value;
		var file_number=document.getElementById("file_number").value;
		var car_type = document.getElementById("car_type").value;
		var driving_number = document.getElementById("driving_number").value;
		var sign_org = document.getElementById("sign_org").value;
		var signer = document.getElementById("signer").value;
		var sign_date = document.getElementById("sign_date").value;
		var expiry_date = document.getElementById("expiry_date").value;
		var contract_person = document.getElementById("contract_person").value;
		var contract_phone = document.getElementById("contract_phone").value;
		if(second_org==""){
			alert("二级单位不能为空，请填写！");
			return true;
		}
		if(third_org==""){
			alert("基层单位不能为空，请填写！");
			return true;
		}
		if(name==""){
			alert("姓名不能为空，请填写！");
			return true;
		}
		if(sex==""){
			alert("性别不能为空，请选择！");
			return true;
		}
		if(birthday==""){
			alert("出生日期不能为空，请选择！");
			return true;
		}
		if(card_id==""){
			alert("身份证号不能为空，请填写！");
			return true;
		}
		if(file_number==""){
			alert("驾驶证编号不能为空，请填写！");
			return true;
		}
		if(car_type==""){
			alert("准驾车型不能为空，请选择！");
			return true;
		}
		if(driving_number==""){
			alert("准驾证编号不能为空，请填写！");
			return true;
		}
		if(sign_org==""){
			alert("发证单位不能为空，请填写！");
			return true;
		}
		if(signer==""){
			alert("签发人不能为空，请填写！");
			return true;
		}
		if(sign_date==""){
			alert("签发日期不能为空，请填写！");
			return true;
		}
		if(expiry_date==""){
			alert("有效期不能为空，请填写！");
			return true;
		}
		if(contract_person==""){
			alert("二级单位联系人不能为空，请填写！");
			return true;
		}
		if(contract_phone==""){
			alert("联系电话不能为空，请填写！");
			return true;
		}
		return false;
	}

	function checkText1(){
		var driving_type = document.getElementById("driving_type1").value;
		var second_org=document.getElementById("second_org1").value;
		var third_org=document.getElementById("third_org1").value;
		var name=document.getElementById("name1").value;
		var sex=document.getElementById("sex1").value;
		var birthday=document.getElementById("birthday1").value;
		var card_id=document.getElementById("card_id1").value;
		var file_number=document.getElementById("file_number1").value;
		var car_type = document.getElementById("car_type1").value;
		var driving_number = document.getElementById("driving_number1").value;
		var sign_org = document.getElementById("sign_org1").value;
		var signer = document.getElementById("signer1").value;
		var sign_date = document.getElementById("sign_date1").value;
		var expiry_date = document.getElementById("expiry_date1").value;
		var contract_person = document.getElementById("contract_person1").value;
		var contract_phone = document.getElementById("contract_phone1").value;
		if(second_org==""){
			alert("二级单位不能为空，请填写！");
			return true;
		}
		if(third_org==""){
			alert("基层单位不能为空，请填写！");
			return true;
		}
		if(name==""){
			alert("姓名不能为空，请填写！");
			return true;
		}
		if(sex==""){
			alert("性别不能为空，请选择！");
			return true;
		}
		if(birthday==""){
			alert("出生日期不能为空，请选择！");
			return true;
		}
		if(driving_type=="2"){
			var duty=document.getElementById("duty1").value;
			if(duty==""){
				alert("人员职务不能为空，请选择！");
				return true;
			}
		}
		if(card_id==""){
			alert("身份证号不能为空，请填写！");
			return true;
		}
		if(file_number==""){
			alert("驾驶证编号不能为空，请填写！");
			return true;
		}
		if(car_type==""){
			alert("准驾车型不能为空，请选择！");
			return true;
		}
		if(driving_number==""){
			alert("准驾证编号不能为空，请填写！");
			return true;
		}
		if(sign_org==""){
			alert("发证单位不能为空，请填写！");
			return true;
		}
		if(signer==""){
			alert("签发人不能为空，请填写！");
			return true;
		}
		if(sign_date==""){
			alert("签发日期不能为空，请填写！");
			return true;
		}
		if(expiry_date==""){
			alert("有效期不能为空，请填写！");
			return true;
		}
		if(contract_person==""){
			alert("二级单位联系人不能为空，请填写！");
			return true;
		}
		if(contract_phone==""){
			alert("联系电话不能为空，请填写！");
			return true;
		}
		return false;
	}


	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteDriving", "hse_driving_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/yxControl/safeManage/jiazheng/driving_search.jsp");
	}
	
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second_orgId = document.getElementById("second_org").value;
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	 document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	        if(second_orgId!=teamInfo.fkValue){
	        	document.getElementById("third_org").value = "";
		        document.getElementById("third_org2").value = "";
	        }
	    }
	}
	
	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("second_org").value;
	    if(second==""||second==null){
	    	alert("请先选择二级单位！");
	    }else{
		    var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				var org_id = datas[0].org_id; 
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("third_org").value = teamInfo.fkValue;
			        document.getElementById("third_org2").value = teamInfo.value;
			    }
			}
	    }
	}
	
</script>

</html>

