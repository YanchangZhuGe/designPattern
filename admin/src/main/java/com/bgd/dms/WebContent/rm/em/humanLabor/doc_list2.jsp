<%@ page contentType="text/html;charset=GBK" language="java" pageEncoding="GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String laborCategory = request.getParameter("laborCategory");
ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String folderId = "";
	if(request.getParameter("folderid") != null){
		folderId = request.getParameter("folderid");
	}
	String orgSubId = request.getParameter("orgSubId");
	System.out.println(orgSubId);
	
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getOrgSubjectionId();
	String orgId = (user==null)?"":user.getCodeAffordOrgID();
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>人员信息</title>
<style type="text/css">
.select_height{width:150px;}
SELECT {
	margin-bottom:0;
    margin-top:0;
	border:1px #52a5c4 solid;
	color: #333333;
	FONT-FAMILY: "微软雅黑";font-size:9pt;
    width:150px;
}
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
		 	    <code:codeSelect name='s_org_id1' option="orgCommOps" addAll="true"  cssClass="select_height"    selectedValue=""  />
		 	    </td>
			    <td class="ali_cdn_name">姓名</td>
		 	    <td class="ali_cdn_input"><input id="s_employee_name" class="input_width" style="width:100px;"  name="s_employee_name" type="text"   />
			 	   <input id="orgIdParam" class="input_width"  name="orgIdParam" type="hidden"   />
		 	    </td>
			    <td class="ali_cdn_name">身份证号</td>
			    <td class="ali_cdn_input">  <input type='hidden' id="checkall" name="checkall" value="0"/>  <input id="s_employee_coid" class="input_width"  style="width:100px;"  name="s_employee_coid" type="text"  /></td>
			    <td class="ali_query">
			    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
		       </td>
		       <td class="ali_query">
			    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
		    	</td>

		    	  <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			    
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="dr" event="onclick='toUploadFile()'" title="导入基本信息"></auth:ListButton>
			    <auth:ListButton functionId="" css="dr" event="onclick='toUploadFileG()'" title="导入国际部信息"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				<auth:ListButton functionId="" css="xz" event="onclick='toExportExcel()'" title="导出信息"></auth:ListButton>
			   
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{labor_id}' id='rdo_entity_id_{labor_id}' />" ><input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"/></td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{employee_name}" isExport='Hide' >姓名</td>
			      <td class="bt_info_odd" exp="{employee_gender_name}" isExport='Hide' >性别</td>
			      <td class="bt_info_even" exp="{employee_nation_name}" isExport='Hide' >民族</td>
			      <td class="bt_info_odd" exp="{employee_id_code_no}" isExport='Hide' >身份证号</td>
			      <td class="bt_info_even" exp="{employee_education_level_name}" isExport='Hide' >文化程度</td>
			      <td class="bt_info_odd" exp="{cont_num}" isExport='Hide' >劳动合同编号</td>
			      <td class="bt_info_even" exp="{if_project_name}" isExport='Hide' >项目状态</td>
			      <td class="bt_info_odd" exp="{apply_teams}" isExport='Hide' >班组</td>
			      <td class="bt_info_even" exp="{posts}" isExport='Hide' >岗位</td>
			      <td class="bt_info_odd" exp="{years}" isExport='Hide' >服务年限</td>
			      <td class="bt_info_even" exp="{fsflag}" isExport='Hide' >黑名单</td>
			      
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_8"><a href="#" onclick="getTab3(8)">国际业务信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">项目经历</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">培训经历</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">资格证书</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">黑名单</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">附件</a></li>
			    <li id="tag3_6"><a href="#" onclick="getTab3(6)">备注</a></li>
			    <li id="tag3_7"><a href="#" onclick="getTab3(7)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
				      <td   class="inquire_item6">姓名：</td>
				      <td   class="inquire_form6" ><input id="employee_name" class="input_width" type="text" value=""/> &nbsp; <input id="labor_id" class="input_width" type="hidden" value=""/></td>
				      <td  class="inquire_item6">&nbsp;性别：</td>
				      <td  class="inquire_form6"  ><input id="employee_gender_name" class="input_width" type="text"  value=""/> &nbsp;</td>
				      <td  class="inquire_item6">健康信息：</td>
					  <td  class="inquire_form6"><input id="employee_health_info" class="input_width" type="text"  value=""/> &nbsp;</td>
				      </tr>
				     <tr >
				     <td  class="inquire_item6">出生年月：</td>
				     <td  class="inquire_form6"><input id="employee_birth_date" class="input_width" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;民族：</td>
				     <td  class="inquire_form6"><input id="employee_nation_name" class="input_width" type="text"  value=""/> &nbsp;</td>  
				     <td  class="inquire_item6">&nbsp;是否骨干：</td>
					  <td  class="inquire_form6"><input id="elite_if_name" class="input_width" type="text"  value=""/> &nbsp;</td>
				     </tr>
				    <tr> 
				    <td  class="inquire_item6">身份证号：</td>
				    <td  class="inquire_form6"><input id="employee_id_code_no" class="input_width" type="text"  value=""/> &nbsp;</td> 
				    <td  class="inquire_item6">&nbsp;文化程度：</td>
				    <td  class="inquire_form6"><input id="employee_education_level_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				    <td  class="inquire_item6">家庭住址：</td>
					<td  class="inquire_form6"><input id="employee_address" class="input_width" type="text"  value=""/> &nbsp;</td>
				    </tr>
			 
				 <tr >
				 <td  class="inquire_item6">班组：</td>
				 <td  class="inquire_form6"><input id="apply_teams" class="input_width" type="text"  value=""/> &nbsp;</td> 
				 <td  class="inquire_item6">&nbsp;岗位：</td>
				 <td  class="inquire_form6"><input id="posts" class="input_width" type="text"  value=""/> &nbsp;</td> 
				 <td  class="inquire_item6">&nbsp;联系电话：</td>
				   <td  class="inquire_form6"><input id="phone_num" class="input_width" type="text"  value=""/> &nbsp;</td> 
				</tr>
				<tr>
				<td  class="inquire_item6">用工来源：</td>
				<td  class="inquire_form6"><input id="workerfrom_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">&nbsp;技术职称：</td>
				<td  class="inquire_form6"><input id="technical_title_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">手机号码：</td>
				<td  class="inquire_form6"><input id="mobile_number" class="input_width" type="text"  value=""/> &nbsp;</td>
				</tr>
		 
				<tr >
				<td  class="inquire_item6">组织机构：</td>
				<td  class="inquire_form6"><input id="org_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">&nbsp;用工性质：</td>
				<td  class="inquire_form6"><input id="if_engineer_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">&nbsp;项目状态：</td>
				<td  class="inquire_form6"><input id="if_project_name" class="input_width" type="text"  value=""/> &nbsp;</td>
				</tr>
				<tr>
				<td  class="inquire_item6">邮编：</td>
				<td  class="inquire_form6"><input id="postal_code" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">&nbsp;劳动合同：</td>
				<td  class="inquire_form6"><input id="cont_num" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">技能：</td>
				<td  class="inquire_form6"  ><input id="specialty" class="input_width" type="text"  value=""/> &nbsp;</td>
				</tr>
				<tr>
				<td  class="inquire_item6">用工分布：</td>
				<td  class="inquire_form6"><input id="labor_distribution" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">国籍：</td>
				<td  class="inquire_form6"><input id="nationality_name" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">户籍类型：</td>
				<td  class="inquire_form6"><input id="household_type"  class="input_width" type="text" readonly />&nbsp;</td> 
				
				</tr>
				<tr>
				<td  class="inquire_item6">岗位类型：</td>
				<td  class="inquire_form6"><input id="position_type" class="input_width" type="text"  value=""/> &nbsp;</td> 
				<td  class="inquire_item6">岗位国别：</td>
				<td  class="inquire_form6"><input id="position_nationality" class="input_width" type="text"  value=""/> &nbsp;</td> 
		 
				</tr>
				
				  </table>
				</div>
				
				<div id="tab_box_content8" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
				      <td class="inquire_item6">机构类别：</td>
				      <td class="inquire_form6" ><input id="institutions_type" class="input_width" type="text" readonly/></td>
				      <td class="inquire_item6">基层单位：</td>
				      <td class="inquire_form6" ><input id="grass_root_unit" class="input_width" type="text" readonly/></td> 
				      <td class="inquire_item6">出国(或国内上班)时间：</td>
				      <td class="inquire_form6" ><input id="go_abroad_time" class="input_width" type="text" readonly/></td>
			    </tr>
			    
			    <tr>				   
			      <td class="inquire_item6">回国时间：</td>
			      <td class="inquire_form6" ><input id="home_time" class="input_width" type="text" readonly/></td> 			     
			      <td class="inquire_item6">目前状态：</td>
			      <td class="inquire_form6" ><input id="present_state" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item6"> 现岗位起始日期：</td>
			      <td class="inquire_form6" ><input id="now_start_date" class="input_width" type="text" readonly/></td> 
		       </tr>
			    <tr>
			      <td class="inquire_item6">执行日期：</td>
			      <td class="inquire_form6" ><input id="implementation_date" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item6"> 户口所在地：</td>
			      <td class="inquire_form6" ><input id="account_place" class="input_width" type="text" readonly/></td> 
			      <td class="inquire_item6">起薪日期：</td>
			      <td class="inquire_form6" ><input id="start_salary_date" class="input_width" type="text" readonly/></td>
		       </tr>
			    <tr> 
			      <td class="inquire_item6">技术职称资格时间：</td>
			      <td class="inquire_form6" ><input id="technical_time" class="input_width" type="text" readonly/></td>  
			      <td class="inquire_item6">岗位序列：</td>
			      <td class="inquire_form6" ><input id="post_sequence" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item6"> 岗位对应考试标准：</td>
			      <td class="inquire_form6" ><input id="post_exam" class="input_width" type="text" readonly/></td> 
		       </tr> 
			    <tr>
			      <td class="inquire_item6">托福总分：</td>
			      <td class="inquire_form6" ><input id="toefl_score" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item6"> 托福听力：</td>
			      <td class="inquire_form6" ><input id="tofel_listening" class="input_width" type="text" readonly/></td> 
			      <td class="inquire_item6">是否合格：</td>
			      <td class="inquire_form6" ><input id="if_qualified" class="input_width" type="text" readonly/></td>
		       </tr>
			    <tr> 
			      <td class="inquire_item6"> 900句成绩：</td>
			      <td class="inquire_form6" ><input id="nine_result" class="input_width" type="text" readonly/></td>  
			      <td class="inquire_item6">是否合格：</td>
			      <td class="inquire_form6" ><input id="if_qualifieds" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item6"> 托业成绩：</td>
			      <td class="inquire_form6" ><input id="holds_result" class="input_width" type="text" readonly/></td> 
		       </tr> 
			</table>
			</div>
				
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				   <table id="projectMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    	    <td  class="bt_info_odd">序号</td>
			            <td  class="bt_info_even">项目名称</td>
			            <td class="bt_info_odd">班组</td>
			            <td class="bt_info_even">岗位</td>
			            <td class="bt_info_odd">进入项目时间</td>
			            <td class="bt_info_even"> 离开项目时间</td>
			        </tr>
			        </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<table id="peixunMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
		    	<tr>
		    	    <td  class="bt_info_odd">序号</td>
		            <td class="bt_info_even">起止时间</td>
		            <td class="bt_info_odd">培训项目名称</td>		
		            <td class="bt_info_even">证书编号</td>
		            <td class="bt_info_odd">签发机构</td>			
		            <td class="bt_info_even">签发日期</td>          
		            <td class="bt_info_odd">发证地点</td>
		        </tr>
		        </table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<table id="zigeMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
		    	<tr>
		    	  <td  class="bt_info_even">序号</td>
		    	  <td class="bt_info_odd">证书名称</td>
		            <td class="bt_info_even">证书类别</td>
		            <td class="bt_info_odd">证书编号</td>		
		            <td class="bt_info_even">培训机构</td>
		            <td class="bt_info_odd">签发单位</td>			
		            <td class="bt_info_even">签发日期</td>          
		            <td class="bt_info_odd">有效期</td>
		        </tr>
		        </table>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td class="ali3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    <td class="ali1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    <td class="ali3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    <td class="ali1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				    <td>&nbsp;</td>
				    <td colspan='7'>
			 
				        <auth:ListButton functionId="" css="zj" event="onclick='toAddBlack()'" title="JCDP_btn_add"></auth:ListButton>
					    <auth:ListButton functionId="" css="xg" event="onclick='toEditBlack()'" title="JCDP_btn_edit"></auth:ListButton>
					    <auth:ListButton functionId="" css="sc" event="onclick='toDeleteBlack()'" title="JCDP_btn_delete"></auth:ListButton>
				    </td>
				  </tr>
				</table>
				</td>
				    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				  </tr>
				</table>
					<table  id="blackListMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					 
					  <tr>
					    <td class="bt_info_odd">选择</td>
			    	    <td class="bt_info_even">序号</td>
			            <td  class="bt_info_odd">项目名称</td>
			            <td class="bt_info_even">列入黑名单日期</td>		
			            <td  class="bt_info_odd">列入黑名单原因</td>
					  </tr>
					</table>
				</div>
				
				<div id="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content6" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				<div id="tab_box_content7" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
		
			</div>
		  </div>

</body>
<script type="text/javascript">
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
 
//	cruConfig.queryStr = "";
//	cruConfig.queryService = "ucmSrv";
//	cruConfig.queryOp = "getDocsInFolder";
//  cruConfig.queryRetTable_id = "";
 
	 
	
	function toSearch(){
		popWindow('<%=contextPath%>/rm/em/humanLabor/doc_search.jsp');
	}
	
	function head_chx_box_changed(headChx){
		var chxBoxes = document.getElementsByName("rdo_entity_id");
		if(chxBoxes==undefined) return;
		for(var i=0;i<chxBoxes.length;i++){
		  if(!chxBoxes[i].disabled){
				chxBoxes[i].checked = headChx.checked;	
		  }
		  
		}
		if(headChx.checked){
			document.getElementById("checkall").value="1";
		}else{
			document.getElementById("checkall").value="0";
		}
	}
	
	
	function simpleSearch(){ 
			var q_file_name = document.getElementById("s_employee_name").value; 
			var s_employee_coid=document.getElementById("s_employee_coid").value;  
			var str = " 1=1 "; 
			if(q_file_name!=''&& q_file_name!=null || s_employee_coid!=''&& s_employee_coid!=null){ 
				if(q_file_name!=''){
					str += " and employee_name like '%"+q_file_name+"%' ";
				} 
				if(s_employee_coid!=''){
					str += " and employee_id_code_no like '%"+s_employee_coid+"%' ";
				}
			} 	
			cruConfig.cdtStr = str; 
			refreshData();
		 
	}
	function clearQueryText(){ 
		 document.getElementById("s_employee_name").value=''; 
		 document.getElementById("s_employee_coid").value='';
		 document.getElementsByName("s_org_id1")[0].value='';
	}
	var orgSubId = "<%=orgSubId%>";	
	function refreshData(arrObj){	 
		var orgIdParam=document.getElementById("orgIdParam").value;
		if(orgIdParam !="" ){orgSubId = orgIdParam;}
		var s_org_id = document.getElementsByName("s_org_id1")[0].value;
		if(s_org_id !="" ){orgSubId = s_org_id;}else{orgSubId="<%=orgSubId%>";}

		cruConfig.cdtType = 'form';
		<%--  var str= "select * from  (select distinct l.*, d3.coding_name posts, d4.coding_name apply_teams from ( select  distinct  l.bsflag,l.labor_id, l.employee_name, d11.coding_name position_name,decode(l.position_type,'0110000021000000003','技能操作类','0110000021000000002','专业技术类','0110000021000000001','管理类','')position_type,decode(l.labor_category, '0', '临时季节性用工', '1', '再就业人员', '2', '劳务派遣人员', '3', '其他用工', l.labor_category) labor_category, nvl(t1.post ,l.post ) post, nvl(t1.apply_team,l.apply_team ) apply_team, l.employee_nation, d1.coding_name employee_nation_name, l.employee_gender, l.owning_org_id, l.owning_subjection_org_id, decode(l.employee_gender, '0', '女', '1', '男', l.employee_gender) employee_gender_name, decode(nvl(l.if_project, 0), '0', '不在项目', '1', '在项目', l.if_project) if_project_name, l.if_project, l.if_engineer, d5.coding_name if_engineer_name, l.cont_num, l.employee_birth_date, l.employee_id_code_no, l.employee_education_level, d2.coding_name employee_education_level_name, l.employee_address, l.phone_num, l.employee_health_info, l.specialty, l.elite_if, l.workerfrom,  case when lt.nu  is null then '否' else '是' end fsflag, case when lt.nu is null then '' else 'red' end bgcolor, nvl(t.years, 0) years,l.create_date  , cft.coding_code as dalei,cft.coding_code_id as xiaolei ,decode(l.labor_distribution,  '0',  '一线员工',  '1',  '境外一线',  '2',  '二线员工',  '4',  '三线员工', '3',  '境外二三线',  l.labor_distribution) labor_distribution,    i.org_name,  l.postal_code,  l.mobile_number,  decode(nvl(l.elite_if, 0), '0', '否', '1', '是', l.elite_if) elite_if_name,    decode(l.household_type, '0', '农业', '1', '非农业') household_type,  d6.coding_name workerfrom_name,  l.technical_title,  d7.coding_name technical_title_name,  d8.coding_name nationality_name,   decode(l.institutions_type, '0', '境外项目', '1', '总部机关') institutions_type,  l.grass_root_unit,  l.go_abroad_time,  l.home_time,  nvl(d10.coding_name, l.present_state) present_state_name,  l.now_start_date,  l.implementation_date,  l.account_place,  l.start_salary_date,  l.technical_time,  l.post_sequence,  l.post_exam,  l.toefl_score,  l.tofel_listening,  decode(l.if_qualified, '0', '是', '1', '否') if_qualified,  l.nine_result,   decode(l.if_qualifieds, '0', '是', '1', '否') if_qualifieds,  l.holds_result  from bgp_comm_human_labor l left join (select lt.labor_id, count(1) nu   from bgp_comm_human_labor_list lt left join  bgp_comm_human_labor l on   l.labor_id = lt.labor_id     where lt.bsflag = '0' and l.bsflag='0'   group by lt.labor_id) lt on l.labor_id = lt.labor_id  left join (select d2.* from (select d1.* from (select d.apply_team, d.post, l1.labor_id, row_number() over(partition by l1.labor_id order by d.start_date desc) numa from bgp_comm_human_deploy_detail d left join bgp_comm_human_labor_deploy l1 on d.labor_deploy_id = l1.labor_deploy_id where d.bsflag = '0') d1 where d1.numa = 1) d2) t1  on l.labor_id = t1.labor_id  left join comm_coding_sort_detail d1 on l.employee_nation = d1.coding_code_id left join comm_coding_sort_detail d2 on l.employee_education_level = d2.coding_code_id left join comm_coding_sort_detail d5 on l.if_engineer = d5.coding_code_id left join comm_org_subjection cn on l.owning_org_id = cn.org_id and cn.bsflag='0'      left join comm_org_information i    on l.owning_org_id = i.org_id   left join comm_coding_sort_detail d6    on l.workerfrom = d6.coding_code_id  left join comm_coding_sort_detail d7    on l.technical_title = d7.coding_code_id  left join comm_coding_sort_detail d8    on l.nationality = d8.coding_code_id  left join comm_coding_sort_detail d10    on l.present_state = d10.coding_code_id   left join comm_coding_sort_detail d11  on l.position_nationality = d11.coding_code_id   left join (select count(distinct to_char(t.start_date, 'yyyy')) years, t.labor_id from bgp_comm_human_labor_deploy t group by t.labor_id) t on l.labor_id = t.labor_id   left join  bgp_comm_human_certificate cft  on cft.employee_id= l.labor_id  and cft.bsflag='0'     where l.bsflag = '0' and l.if_engineer ='<%=laborCategory%>' and l.owning_subjection_org_id like '%"+orgSubId+"%' ) l  left join comm_coding_sort_detail d3 on l.post = d3.coding_code_id left join comm_coding_sort_detail d4 on l.apply_team = d4.coding_code_id ) t where t.bsflag='0'  "; --%>
		 var str= "select * from  (select distinct l.*, d3.coding_name posts, d4.coding_name apply_teams from ( select  distinct  l.bsflag,  l.labor_id,     cft.coding_code as dalei,    cft.coding_code_id as xiaolei,  l.employee_address, l.elite_if,  l.employee_name,    decode(l.employee_gender,  '0',  '女',  '1',  '男',  l.employee_gender) employee_gender_name,  d1.coding_name employee_nation_name,  l.employee_id_code_no,  d2.coding_name employee_education_level_name,  l.cont_num,  nvl(t1.post, l.post) post,  nvl(t1.apply_team, l.apply_team) apply_team,  l.create_date,  decode(nvl(l.if_project, 0),  '0',  '不在项目',  '1',  '在项目',  l.if_project) if_project_name,  l.if_project,  l.employee_education_level,  nvl(t.years, 0) years,   case  when lt.nu is null then  '否'  else  '是'  end fsflag,  case  when lt.nu is null then  ''  else 'red'  end bgcolor  from bgp_comm_human_labor l left join (select lt.labor_id, count(1) nu   from bgp_comm_human_labor_list lt left join  bgp_comm_human_labor l on   l.labor_id = lt.labor_id     where lt.bsflag = '0' and l.bsflag='0'   group by lt.labor_id) lt on l.labor_id = lt.labor_id  left join (select d2.* from (select d1.* from (select d.apply_team, d.post, l1.labor_id, row_number() over(partition by l1.labor_id order by d.start_date desc) numa from bgp_comm_human_deploy_detail d left join bgp_comm_human_labor_deploy l1 on d.labor_deploy_id = l1.labor_deploy_id where d.bsflag = '0') d1 where d1.numa = 1) d2) t1  on l.labor_id = t1.labor_id  left join comm_coding_sort_detail d1 on l.employee_nation = d1.coding_code_id left join comm_coding_sort_detail d2 on l.employee_education_level = d2.coding_code_id     left join (select count(distinct to_char(t.start_date, 'yyyy')) years, t.labor_id from bgp_comm_human_labor_deploy t group by t.labor_id) t on l.labor_id = t.labor_id   left join  bgp_comm_human_certificate cft  on cft.employee_id= l.labor_id  and cft.bsflag='0'     where l.bsflag = '0' and l.if_engineer ='<%=laborCategory%>' and l.owning_subjection_org_id like '%"+orgSubId+"%' ) l  left join comm_coding_sort_detail d3 on l.post = d3.coding_code_id left join comm_coding_sort_detail d4 on l.apply_team = d4.coding_code_id ) t where t.bsflag='0'  ";
		
		 for(var key in arrObj) { 
			//alert(arrObj[key].label+arrObj[key].value);
			if(arrObj[key].value!=undefined && arrObj[key].value!='')
			str += "and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
		}
	    var str1="   order by t.create_date desc";
	    str=str+str1;
		cruConfig.queryStr=str;
		cruConfig.currentPageUrl = "/rm/em/humanLabor/doc_list2.jsp";
		queryData(1);
	}

	function toExportExcel(){ 
		window.open("<%=contextPath%>/rm/em/exportLaborList.srq?ifEngineer=<%=laborCategory%>&orgSubId="+orgSubId);
 
	}
	
	function loadDataDetail(shuaId){
	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+shuaId;
	    
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId;
	    
	    document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+shuaId;
	
	    var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HumanLaborMessageSrv", "getLaborInfo", "laborId="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("HumanLaborMessageSrv", "getLaborInfo", "laborId="+ids);
		}
	
		document.getElementById("employee_name").value =retObj.employeeMap.employee_name;
		document.getElementById("employee_gender_name").value = retObj.employeeMap.employee_gender_name;
		document.getElementById("employee_birth_date").value = retObj.employeeMap.employee_birth_date;
		document.getElementById("employee_nation_name").value = retObj.employeeMap.employee_nation_name;
		document.getElementById("employee_id_code_no").value = retObj.employeeMap.employee_id_code_no;
		document.getElementById("employee_education_level_name").value = retObj.employeeMap.employee_education_level_name;
		document.getElementById("employee_address").value = retObj.employeeMap.employee_address;
		document.getElementById("phone_num").value = retObj.employeeMap.phone_num;
		document.getElementById("employee_health_info").value = retObj.employeeMap.employee_health_info;
		document.getElementById("elite_if_name").value = retObj.employeeMap.elite_if_name;
		document.getElementById("apply_teams").value = retObj.employeeMap.apply_teams;
		document.getElementById("posts").value = retObj.employeeMap.posts;
		document.getElementById("workerfrom_name").value = retObj.employeeMap.workerfrom_name;
		document.getElementById("technical_title_name").value = retObj.employeeMap.technical_title_name;
		document.getElementById("mobile_number").value = retObj.employeeMap.mobile_number;
		document.getElementById("if_project_name").value = retObj.employeeMap.if_project_name;
		document.getElementById("org_name").value = retObj.employeeMap.org_name;
		document.getElementById("if_engineer_name").value = retObj.employeeMap.if_engineer_name;
		document.getElementById("postal_code").value = retObj.employeeMap.postal_code;
		document.getElementById("cont_num").value = retObj.employeeMap.cont_num;
		document.getElementById("specialty").value = retObj.employeeMap.specialty;
		document.getElementById("labor_id").value = retObj.employeeMap.labor_id;
		document.getElementById("labor_distribution").value = retObj.employeeMap.labor_distribution;
		document.getElementById("nationality_name").value = retObj.employeeMap.nationality_name;
		document.getElementById("household_type").value = retObj.employeeMap.household_type; 
		document.getElementById("position_type").value = retObj.employeeMap.position_type;
		document.getElementById("position_nationality").value = retObj.employeeMap.position_name;
		
	 
		document.getElementById("institutions_type").value = retObj.employeeMap.institutions_type;
		document.getElementById("grass_root_unit").value = retObj.employeeMap.grass_root_unit;
		document.getElementById("go_abroad_time").value = retObj.employeeMap.go_abroad_time;
		document.getElementById("home_time").value = retObj.employeeMap.home_time;
		document.getElementById("present_state").value = retObj.employeeMap.present_state_name;
		document.getElementById("now_start_date").value = retObj.employeeMap.now_start_date;
		document.getElementById("implementation_date").value = retObj.employeeMap.implementation_date;
		document.getElementById("account_place").value = retObj.employeeMap.account_place;
		document.getElementById("start_salary_date").value = retObj.employeeMap.start_salary_date;
		document.getElementById("technical_time").value = retObj.employeeMap.technical_time;
		document.getElementById("post_sequence").value = retObj.employeeMap.post_sequence;
		document.getElementById("post_exam").value = retObj.employeeMap.post_exam;
		document.getElementById("toefl_score").value = retObj.employeeMap.toefl_score;
		document.getElementById("tofel_listening").value = retObj.employeeMap.tofel_listening;
		document.getElementById("if_qualified").value = retObj.employeeMap.if_qualified;
		document.getElementById("nine_result").value = retObj.employeeMap.nine_result;
		document.getElementById("if_qualifieds").value = retObj.employeeMap.if_qualifieds;
		document.getElementById("holds_result").value = retObj.employeeMap.holds_result;
		
		
		deleteTableTr("projectMap");	   //项目信息  
		if(retObj.projectMap != null){
			
			for(var i=0;i<retObj.projectMap.length;i++){
				var project = retObj.projectMap[i];					
				var tr = document.getElementById("projectMap").insertRow();		
              	if(i % 2 == 1){  
              		classCss = "even_";
				}else{ 
					classCss = "odd_";
				}
              	var td = tr.insertCell(0);
				td.className=classCss+"odd";
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.className=classCss+"even";
				td.innerHTML = project.project_name;
				
				var td = tr.insertCell(2);
				td.className=classCss+"odd";
				td.innerHTML = project.apply_team_name;

				var td = tr.insertCell(3);
				td.className=classCss+"even";
				td.innerHTML = project.post_name;				
 
				var td = tr.insertCell(4);
				td.className=classCss+"odd";
				td.innerHTML =project.start_date;
				
				var td = tr.insertCell(5);
				td.className=classCss+"even";
				td.innerHTML = project.end_date;
				
 			
			}
		}
		
		deleteTableTr("blackListMap");    //黑名单信息
		if(retObj.blackListMap != null){
			
			for(var i=0;i<retObj.blackListMap.length;i++){
				var blackList = retObj.blackListMap[i];					
				var tr2 = document.getElementById("blackListMap").insertRow();	
	         	if(i % 2 == 1){  
              		classCss = "even_";
				}else{ 
					classCss = "odd_";
				}
	         	var td2 = tr2.insertCell(0);
				td2.className=classCss+"odd";
				td2.innerHTML = '<input type="radio" name="chx_entity_id" value="'+blackList.list_id+'">';
				
				var td2 = tr2.insertCell(1);
				td2.className=classCss+"even";
				td2.innerHTML = i+1;
				
	         	var td2 = tr2.insertCell(2);
				td2.className=classCss+"odd";
				td2.innerHTML =blackList.project_name;
				
				var td2 = tr2.insertCell(3);
				td2.className=classCss+"even";
				td2.innerHTML = blackList.list_date;
				
	         	var td2 = tr2.insertCell(4);
				td2.className=classCss+"odd";
				td2.innerHTML =blackList.list_reason;
				
			 	
			}
		}
		     
	}
	
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	
	 function toUploadFile(){
		   var orgId='<%=orgId%>';
		   var subId='<%=orgSubjectionId%>';
			popWindow('<%=contextPath%>/rm/em/humanLabor/humanImportFile.jsp?laborCategory=<%=laborCategory%>&orgId='+orgId+'&subId='+subId);
	 }
	 function toUploadFileG(){
		   var orgId='<%=orgId%>';
		   var subId='<%=orgSubjectionId%>';
			popWindow('<%=contextPath%>/rm/em/humanLabor/humanImportFileG.jsp?laborCategory=<%=laborCategory%>&orgId='+orgId+'&subId='+subId);
	 }
	 
	
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toAdds(){
		popWindow('<%=contextPath%>/doc/singleproject/upload_file.jsp?id='+folderid);
		//popWindow('<%=contextPath%>/doc/singleproject/close_page.jsp');
	}
	  function init_down(){
			 
		  	var ids = getSelIds("chx_entity_id");
		  	if(ids==""){
		  		 ids = getObj("chx_entity_id").value;
		  	}		
			self.parent.frames["mainFrame"].location="<%=contextPath %>/rm/em/getLaborInfo.srq?laborId="+ids; 	  	
		}
	 
	
	 

 
	  function toAdd(){ 
		  popWindow("<%=contextPath%>/rm/em/humanLabor/laborModify.upmd?laborCategory=<%=laborCategory%>&pagerAction=edit2Add");
	  }  
	  
	  function toEdit(){  
		  ids = getSelectedValue();
	  	  if(ids==''){  
	  		  alert("请选择一条信息!");  
	  		  return;  
	  	  }  
	      selId = ids.split(',')[0]; 
	      editUrl = "<%=contextPath%>/rm/em/humanLabor/laborModify.upmd?laborCategory=<%=laborCategory%>&id={id}";  
	      editUrl = editUrl.replace('{id}',selId); 
 
	      editUrl += '&pagerAction=edit2Edit';
	      popWindow(editUrl); 
	  } 
	  
	 
		function toDelete(){
	 		
		    ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
		    var tempIds = ids.split(",");		
			var laborIds = "";	
			for(var i=0;i<tempIds.length;i++){			
				laborIds = laborIds + "," + "'" + tempIds[i] + "'";
		 
			}
			
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("HumanLaborMessageSrv", "deleteUpdate", "laborId="+laborIds.substr(1));
				queryData(cruConfig.currentPage);
			}
		}
		
		function toAddBlack(){
			var namet=document.getElementById("employee_name").value;
			var userName="userName="+namet+"";
			var userGex=document.getElementById("employee_id_code_no").value;
			var  laborId=document.getElementById("labor_id").value;
		    if(laborId==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
			popWindow("<%=contextPath%>/rm/em/humanLabor/blackLabor.jsp?"+userName+"&userGex="+userGex+"&laborId="+laborId);  
			//window.open ('<%=contextPath%>/rm/em/humanLabor/laborBlistModify.jsp?pagerAction=edit2Add&action=add&'+userName+'&userGex='+userGex+'&laborId='+laborId, 'newwindow', 'height=450, width=600, top=150,left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
	  	
		}
		function toEditBlack(){
			var namet=document.getElementById("employee_name").value;
			var userName="&userName="+namet;
		 
			var userGex=document.getElementById("employee_id_code_no").value;
			var  laborId=document.getElementById("labor_id").value;
			var obj=document.getElementsByName("chx_entity_id");
 
		    var ids='';
			for (i=0;i<obj.length;i++){  //遍历Radio  
				if(obj[i].checked){
					    ids=obj[i].value;	
					 
				}  
			}
	 
			if (ids==''){ 
				alert('请选中一条记录！');
			}else{ 
				 popWindow("<%=contextPath%>/rm/em/humanLabor/blackLabor.jsp?id="+ids+userName+"&laborId="+laborId+"&userGex="+userGex);
			     queryData(cruConfig.currentPage);
			}	 
 
			
		}
		
       function toDeleteBlack(){
	 		
    		var obj=document.getElementsByName("chx_entity_id");
    		 
   		    var ids='';
   			for (i=0;i<obj.length;i++){  //遍历Radio  
   				if(obj[i].checked){
   					    ids=obj[i].value;	
   					 
   				}  
   			}
   	 
   			if (ids==''){
   				
   				alert('请选中一条记录！');
   			}else{
			    
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("HumanLaborMessageSrv", "deleteUpdateBlack", "listId="+ids);
				var shuaId=document.getElementById("labor_id").value;
				loadDataDetail(shuaId);
			}
   			}	
		}
       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
       
</script>

</html>

