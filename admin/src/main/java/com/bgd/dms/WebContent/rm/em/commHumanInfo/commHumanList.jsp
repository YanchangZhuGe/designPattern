<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String paramsType = request.getParameter("paramsType");
	String orgSubId = request.getParameter("orgSubId");
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getSubOrgIDofAffordOrg();
	String orgId = (user==null)?"":user.getCodeAffordOrgID();
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <title>JCDP_em_human_employee</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">姓名</td>
			    <td class="ali_cdn_input"><input id="s_employee_name" name="s_employee_name" class="input_width" type="text"/></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				<td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dr" style="display:none;" event="onclick='toUploadFile()'" title="导入基本信息"></auth:ListButton>
				<auth:ListButton functionId="" css="gl" event="onclick='toSerach()'" title="JCDP_btn_filter"></auth:ListButton>
				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> 
			    <auth:ListButton functionId="" css="dr" event="onclick='toUploadFileG()'" title="导入国际部信息"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{employee_id}' id='rdo_entity_id_{employee_id}'  onclick='chooseOne(this);' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{employee_name}" isExport='Hide' >姓名</td>
			      <td class="bt_info_even" exp="{employee_cd}" isExport='Hide'>编号</td>
			      <td class="bt_info_odd" exp="{employee_gender_name}" isExport='Hide'>性别</td>
			      <td class="bt_info_even" exp="{org_name}" isExport='Hide'>组织机构</td>
			      <td class="bt_info_odd" exp="{age}" isExport='Hide'>年龄</td>
			      <td class="bt_info_even" exp="{work_date}" isExport='Hide'>工作时间</td>
			      <td class="bt_info_odd" exp="{post}" isExport='Hide'>岗位</td>
			      <td class="bt_info_even" exp="{post_level_name}" isExport='Hide'>职位级别</td>
			      <td class="bt_info_odd" exp="{employee_education_level_name}" isExport='Hide' >学历</td> 
			      
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">人员基本信息</a></li>
			    <li id="tag3_8"><a href="#" onclick="getTab3(8)">国际业务信息</a></li>
			    <li id="tag3_9"><a href="#" onclick="getTab3(9)">借聘信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">工作履历</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">项目经历</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">培训信息</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">教育经历</a></li>
			    <li id="tag3_10"><a href="#" onclick="getTab3(10)">资格证书</a></li>
			    <li id="tag3_5"><a href="#" onclick="getTab3(5)">附件</a></li>
			    <li id="tag3_6"><a href="#" onclick="getTab3(6)">备注</a></li>
			    <li id="tag3_7"><a href="#" onclick="getTab3(7)">分类码</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
			      <td class="inquire_item8">人员编号：</td>
			      <td class="inquire_form8" ><input id="employee_cd" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">姓名：</td>
			      <td class="inquire_form8" ><input id="employee_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">性别：</td>
			      <td class="inquire_form8" ><input id="employee_gender"  class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">年龄：</td>
			      <td class="inquire_form8" ><input id="age" class="input_width" type="text" readonly/></td>
			      <td rowspan="5">
			      		<img id="human_image" src="<%=contextPath%>/humanPhoto/zhaopian.JPG"
							style="width: 85px; height: 120px" /></td>
			      </tr>
			    <tr>
			      <td class="inquire_item8">出生年月：</td>
			      <td class="inquire_form8" ><input id="employee_birth_date" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">民族：</td>
			      <td class="inquire_form8" ><input id="employee_nation_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">国籍：</td>
			      <td class="inquire_form8" ><input id="nationality_name" class="input_width" type="text" readonly/> </td>
			      <td class="inquire_item8">文化程度：</td>
			      <td class="inquire_form8" ><input id="employee_education_level_name" class="input_width" type="text" readonly/> </td>
			    </tr>
			    <tr>
			      <td class="inquire_item8">组织机构：</td>
			      <td class="inquire_form8" ><input id="org_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">岗位：</td>
			      <td class="inquire_form8" ><input id="post" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">岗位类别：</td>
			      <td class="inquire_form8" ><input id="post_sort_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">职位级别：</td>
			      <td class="inquire_form8" ><input id="post_level_name" class="input_width" type="text" readonly/></td>
			      </tr>
			    <tr>
			      <td class="inquire_item8">用工来源：</td>
			      <td class="inquire_form8" ><input id="workerfrom_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">员工类型：</td>
			      <td class="inquire_form8" ><input id="employee_gz_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">参加工作时间：</td>
			      <td class="inquire_form8" ><input id="work_date" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">进入中石油时间：</td>
			      <td class="inquire_form8" ><input id="work_cnpc_date" class="input_width" type="text" readonly/></td>
			      </tr>
			    <tr>			     
			      <td class="inquire_item8">设置班组：</td>
			      <td class="inquire_form8" ><input id="set_team_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">设置岗位：</td>
			      <td class="inquire_form8" ><input id="set_post_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">用工分布：</td>
			      <td class="inquire_form8" ><input id="spare7" class="input_width" type="text" readonly/></td> 
			      <td class="inquire_item8">邮箱：</td>
			      <td class="inquire_form8" ><input id="mail_address" class="input_width" type="text" readonly/></td>
			      </tr>     
			     <tr> 			     			      
			      <td class="inquire_item8">外语语种：</td>
			      <td class="inquire_form8" ><input id="language_sort_name"class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">外语级别：</td>
			      <td class="inquire_form8" ><input id="language_level_name" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">固定电话：</td>
			      <td class="inquire_form8" ><input id="phone_num" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">手机：</td>
			      <td class="inquire_form8" ><input id="employee_mobile_phone" class="input_width" type="text" readonly/></td>
			    </tr>
			    <tr> 
			      <td class="inquire_item8">家庭住址：</td>
			      <td class="inquire_form8" ><input id="home_address" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">常用邮箱：</td>
			      <td class="inquire_form8" ><input id="e_mail" class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">QQ号码：</td>
			      <td class="inquire_form8"><input id="qq"  class="input_width" type="text" readonly/></td>
			      <td class="inquire_item8">户口所在地：</td>
			      <td class="inquire_form8"><input id="account_place" class="input_width" type="text" readonly/></td>
	 
			      
			    </tr>
			    <tr> 
			      <td class="inquire_item8">项目状态：</td>
			      <td class="inquire_form8" ><input id="person_status" class="input_width" type="text" readonly/></td>
			     
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
				      <td class="inquire_item6"> 户籍类型：</td>
				      <td class="inquire_form6" ><input id="household_type"  class="input_width" type="text" readonly/></td>
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
				
				<div id="tab_box_content9" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				     <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					 <td background="<%=contextPath%>/images/list_15.png">
					    <table width="100%" border="0" cellspacing="0" cellpadding="0">			  
						  <tr>			    
						    <td>&nbsp;</td>			   
						    <auth:ListButton functionId="" css="bc" event="onclick='toAddPin()'" title="JCDP_btn_submit"></auth:ListButton>		 
						  </tr>			  
					   </table>
					</td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				 </tr>
				</table><br>

				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			    <tr>
				      <td class="inquire_item6">是否借聘：</td>
				      <td class="inquire_form6" >
					      <select id="pin_whether" name="pin_whether" onchange="selectChang()" class="select_width">
					       <option value="" >请选择</option>
					       <option value="0" >是</option>
					       <option value="1" >否</option> 
						  </select> 
				      </td>
				      
				      <td class="inquire_item6"><div id="divState" name="divState" style="display:block;" >借聘单位：</div></td>
				      <td class="inquire_form6" ><div id="divStates" name="divStates" style="display:block;" >
				      <input id="pin_unit" name="pin_unit" class="input_width" type="hidden"  />
				      <input id="pin_unit_name" name="pin_unit_name" class="input_width" type="text" readonly />
			          <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				      </div>
				      </td> 
			    </tr>
				</table>
				</div>
				
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				   <table id="recordMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr  class="bt_info">
			    	    <td>序号</td>
			            <td>开始时间</td>
			            <td>结束时间</td>		
			            <td>工作单位</td>
			            <td>岗位</td>			
			            <td>行政级别</td>           
			            <td>技术职称</td>
			            <td>技能级别</td>
			        </tr>
			        </table>		
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				   <table id="projectMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr  class="bt_info">
			    	    <td>序号</td>
			            <td>项目名称</td>
			            <td>类型</td>		
			            <td>项目开始日期</td>
			            <td>项目结束日期</td>			
			            <td>进入项目日期</td>           
			            <td>离开项目日期</td>
			            <td>班组</td>
			            <td>岗位</td>
			            <td>人员评价</td>
			        </tr>            
			        </table>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
					<table id="trainMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr  class="bt_info">
				    	    <td>序号</td>
				            <td>培训开始日期</td>
				            <td>培训结束日期</td>		
				            <td>培训班名称</td>
				            <td>培训内容</td>			
				            <td>组织单位级别</td>          
				            <td>培训项目类别</td>
				            <td>培训形式</td>
				            <td>主办单位</td>
				            <td>培训详细地点</td>
				            <td>培训结果</td>
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
					<table id="educationMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr  class="bt_info">
				    	    <td>序号</td>
				            <td>开始时间</td>
				            <td>结束时间</td>		
				            <td>毕业院校</td>
				            <td>所学专业</td>			
				            <td>学历</td> 
				        </tr>            
			        </table>
				</div>	
				<div id="tab_box_content10" class="tab_box_content" style="display:none;">
					<table id="certificateMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">	
				    		<td>序号</td>
				    		<td>资格证名称</td>
				            <td>资格证编号</td>
				            <td>培训机构</td>			
				            <td>签发单位</td>          
				            <td>签发日期</td>
				            <td>有效期</td>
				            <td>附件</td>
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

//	cruConfig.queryStr = "";
	cruConfig.cdtType = 'form';
//	cruConfig.queryService = "HumanCommInfoSrv";
//	cruConfig.queryOp = "queryCommHumanInfo";
//  cruConfig.queryRetTable_id = "";
	var orgSubId = "<%=orgSubId%>";	
	if("C105005001031"==orgSubId){
		orgSubId="C105005001";
	}
	
	// 简单查询
	function simpleSearch(){
		var s_employee_name = document.getElementById("s_employee_name").value;
		if(s_employee_name!=''){
			cruConfig.cdtStr = "employee_name like '%"+s_employee_name+"%' ";
		}else{
			cruConfig.cdtStr = "";
		}
		refreshData(undefined);
	}
	
	function refreshData(id){ 
		if(id!=undefined){
			orgSubId = id;
		} 

	 <%-- 	cruConfig.queryStr = "select t.*, nvl(d11.coding_name, t.set_teamw) set_team_name,    nvl(d12.coding_name, t.set_postw) set_post_name   from (select h.employee_cd, e.employee_id, e.org_id, e.employee_name, decode(e.employee_gender, '0', '女', '1', '男') employee_gender_name, (to_char(sysdate, 'YYYY') - to_char(e.employee_birth_date, 'YYYY')) age,  h.spare7,i.org_abbreviation org_name, h.post, h.post_level, d1.coding_name post_level_name, e.employee_education_level, d2.coding_name employee_education_level_name, s.org_subjection_id,e.modifi_date,h.home_address,h.qq,h.e_mail,h.employee_gz ,  cft.coding_code as dalei,cft.coding_code_id as xiaolei ,h.if_qualified,h.if_qualifieds ,to_char(e.employee_birth_date, 'yyyy-MM-dd') employee_birth_date,  nvl(d3.coding_name, e.employee_nation) employee_nation_name,   nvl(d7.coding_name, h.nationality) nationality_name,   e.mail_address,  e.phone_num,  e.employee_mobile_phone,  nvl(d4.coding_name, h.employee_gz) employee_gz_name, nvl(d8.coding_name, h.post_sort) post_sort_name,  nvl(d5.coding_name, h.df_workerfrom) workerfrom_name,   nvl(d9.coding_name, h.language_sort) language_sort_name,  nvl(d10.coding_name, h.language_level) language_level_name,    nvl(d6.coding_name, e.employee_health_info) employee_health_info_name,  to_char(h.work_date, 'yyyy-MM-dd') work_date,  to_char(h.work_cnpc_date, 'yyyy-MM-dd') work_cnpc_date,   e.employee_id_code_no,  nvl(phr.work_post,  h.set_post) set_postw,  nvl(phr.team, h.set_team) set_teamw,  decode(h.spare7,  '0',  '一线员工',  '1',  '境外一线',  '2',  '二线员工',  '4',  '三线员工',  '3',  '境外二三线',  '') spare7_name,  h.spare2,   decode(h.household_type, '0', '农业', '1', '非农业') household_type,  decode(h.institutions_type, '0', '境外项目', '1', '总部机关') institutions_type,  h.grass_root_unit,  h.go_abroad_time,  h.home_time,  nvl(d13.coding_name, h.present_state) present_state_name,  h.now_start_date,  h.implementation_date,  h.account_place,  h.start_salary_date,  h.technical_time,  h.post_sequence,  h.post_exam,  h.toefl_score,  h.tofel_listening,  decode(h.if_qualified, '0', '是', '1', '否') if_qualified_n,  h.nine_result,  decode(h.if_qualifieds, '0', '是', '1', '否') if_qualifieds_n,  h.holds_result,  h.pin_whether,  h.pin_unit,  pin2.org_hr_short_name as pin_unit_name    from comm_human_employee e inner join comm_human_employee_hr h on e.employee_id = h.employee_id left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' left join comm_org_information i on e.org_id = i.org_id and i.bsflag = '0' left join comm_coding_sort_detail d1 on h.post_level = d1.coding_code_id and d1.bsflag = '0' left join comm_coding_sort_detail d2 on e.employee_education_level = d2.coding_code_id and d2.bsflag = '0'   left join  bgp_comm_human_certificate cft  on cft.employee_id= e.employee_id  and cft.bsflag='0'   left join comm_coding_sort_detail d3  on e.employee_nation = d3.coding_code_id  and d3.bsflag = '0'         left join comm_coding_sort_detail d4  on h.employee_gz = d4.coding_code_id  and d4.bsflag = '0'    left join comm_coding_sort_detail d5  on h.df_workerfrom = d5.coding_code_id  and d5.bsflag = '0'  left join comm_coding_sort_detail d6  on e.employee_health_info = d6.coding_code_id  and d6.bsflag = '0'  left join comm_coding_sort_detail d7  on h.nationality = d7.coding_code_id  and d7.bsflag = '0'  left join comm_coding_sort_detail d8  on h.post_sort = d8.coding_code_id  and d8.bsflag = '0'  left join comm_coding_sort_detail d9  on h.language_sort = d9.coding_code_id  and d9.bsflag = '0'  left join comm_coding_sort_detail d10  on h.language_level = d10.coding_code_id  and d10.bsflag = '0'   left join   (    select d2.*  from (select d1.*  from (   select hr.team,hr.work_post,hr.employee_id,    hr.actual_start_date,    hr.actual_end_date , row_number() over(partition by hr.employee_id order by hr.actual_end_date  desc) numa  from bgp_project_human_relation hr      where hr.bsflag='0'  and hr.locked_if='1'  ) d1  where d1.numa = 1) d2   )  phr  on   e.employee_id= phr.employee_id   left join comm_coding_sort_detail d13  on h.present_state = d13.coding_code_id  left join comm_org_subjection pin  on h.pin_unit = pin.org_subjection_id  and pin.bsflag = '0'  left join bgp_comm_org_hr_gms pin1  on pin1.org_gms_id = pin.org_id  left join bgp_comm_org_hr pin2  on pin2.org_hr_id = pin1.org_hr_id   where e.bsflag = '0' and h.bsflag='0'  and h.employee_gz ='<%=paramsType%>' and ( s.org_subjection_id like '"+orgSubId+"%' or  h.pin_unit = '"+orgSubId+"' ) order by e.modifi_date desc,e.employee_name desc ) t  left join comm_coding_sort_detail d11    on t.set_teamw = d11.coding_code_id  left join comm_coding_sort_detail d12    on t.set_postw = d12.coding_code_id    "; --%>
		cruConfig.queryStr = "select t.*, nvl(d11.coding_name, t.set_teamw) set_team_name,    nvl(d12.coding_name, t.set_postw) set_post_name   from (select h.employee_cd, e.employee_id, e.org_id, e.employee_name, decode(e.employee_gender, '0', '女', '1', '男') employee_gender_name, (to_char(sysdate, 'YYYY') - to_char(e.employee_birth_date, 'YYYY')) age,     cft.coding_code as dalei,     cft.coding_code_id as xiaolei,  h.if_qualified,     nvl(phr.work_post, h.set_post) set_postw,  nvl(phr.team, h.set_team) set_teamw,   h.if_qualifieds,    h.employee_gz, h.spare7,i.org_abbreviation org_name, h.post, h.post_level, d1.coding_name post_level_name, e.employee_education_level, d2.coding_name employee_education_level_name, s.org_subjection_id,e.modifi_date  from comm_human_employee e inner join comm_human_employee_hr h on e.employee_id = h.employee_id left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' left join comm_org_information i on e.org_id = i.org_id and i.bsflag = '0' left join comm_coding_sort_detail d1 on h.post_level = d1.coding_code_id and d1.bsflag = '0' left join comm_coding_sort_detail d2 on e.employee_education_level = d2.coding_code_id and d2.bsflag = '0'    left join bgp_comm_human_certificate cft    on cft.employee_id = e.employee_id    and cft.bsflag = '0'   left join   (    select d2.*  from (select d1.*  from (   select hr.team,hr.work_post,hr.employee_id,    hr.actual_start_date,    hr.actual_end_date , row_number() over(partition by hr.employee_id order by hr.actual_end_date  desc) numa  from bgp_project_human_relation hr      where hr.bsflag='0'  and hr.locked_if='1'  ) d1  where d1.numa = 1) d2   )  phr  on   e.employee_id= phr.employee_id   left join comm_coding_sort_detail d13  on h.present_state = d13.coding_code_id  left join comm_org_subjection pin  on h.pin_unit = pin.org_subjection_id  and pin.bsflag = '0'  left join bgp_comm_org_hr_gms pin1  on pin1.org_gms_id = pin.org_id  left join bgp_comm_org_hr pin2  on pin2.org_hr_id = pin1.org_hr_id   where e.bsflag = '0' and h.bsflag='0'  and h.employee_gz ='<%=paramsType%>' and ( s.org_subjection_id like '"+orgSubId+"%' or  h.pin_unit = '"+orgSubId+"' ) order by e.modifi_date desc,e.employee_name desc ) t  left join comm_coding_sort_detail d11    on t.set_teamw = d11.coding_code_id  left join comm_coding_sort_detail d12    on t.set_postw = d12.coding_code_id    ";
		cruConfig.currentPageUrl = "/rm/em/commHumanInfo/commHumanList.lpmd";
//		cruConfig.submitStr = "org_subjection_id like '"+orgSubId+"%' ";			
//		cruConfig.submitStr = "orgSubId="+orgSubId;	
		queryData(1);

	}


	function loadDataDetail(ids){
		
	    document.getElementById("attachement").src = "<%=contextPath%>/doc/multiproject/common_doc_list_eps.jsp?relationId="+ids;
	    
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	    
	    document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+ids;
				
		var retObj = jcdpCallService("HumanCommInfoSrv", "getCommInfo", "employeeId="+ids);
		var employee_cd = retObj.employeeMap.employee_cd; 
		document.getElementById("employee_cd").value = employee_cd;
		document.getElementById("employee_name").value = retObj.employeeMap.employee_name;
		document.getElementById("employee_gender").value = retObj.employeeMap.employee_gender;
		document.getElementById("age").value = retObj.employeeMap.age;
		document.getElementById("employee_birth_date").value = retObj.employeeMap.employee_birth_date;
		document.getElementById("employee_nation_name").value = retObj.employeeMap.employee_nation_name;
		document.getElementById("nationality_name").value = retObj.employeeMap.nationality_name;
		document.getElementById("employee_education_level_name").value = retObj.employeeMap.employee_education_level_name;
		document.getElementById("post").value = retObj.employeeMap.post;
		document.getElementById("post_sort_name").value = retObj.employeeMap.post_sort_name;
		document.getElementById("post_level_name").value = retObj.employeeMap.post_level_name;
		document.getElementById("workerfrom_name").value = retObj.employeeMap.workerfrom_name;
		document.getElementById("employee_gz_name").value = retObj.employeeMap.employee_gz_name;
		document.getElementById("language_sort_name").value = retObj.employeeMap.language_sort_name;
		document.getElementById("language_level_name").value = retObj.employeeMap.language_level_name;
		document.getElementById("work_date").value = retObj.employeeMap.work_date;
		document.getElementById("work_cnpc_date").value = retObj.employeeMap.work_cnpc_date;
		document.getElementById("org_name").value = retObj.employeeMap.org_name;
		document.getElementById("mail_address").value = retObj.employeeMap.mail_address;
		document.getElementById("phone_num").value = retObj.employeeMap.phone_num;
		document.getElementById("employee_mobile_phone").value = retObj.employeeMap.employee_mobile_phone;
		document.getElementById("set_team_name").value = retObj.employeeMap.set_team_name;
		document.getElementById("set_post_name").value = retObj.employeeMap.set_post_name;
		document.getElementById("spare7").value = retObj.employeeMap.spare7;
		document.getElementById("home_address").value = retObj.employeeMap.home_address;
		document.getElementById("qq").value = retObj.employeeMap.qq;
		document.getElementById("e_mail").value = retObj.employeeMap.e_mail;
		document.getElementById("household_type").value = retObj.employeeMap.household_type;		
		document.getElementById("human_image").src = "http://10.88.2.241:8080/hr_photo/"+employee_cd.substr(0,5)+"/"+employee_cd+".JPG";
		 
	 
		document.getElementById("person_status").value = retObj.employeeMap.person_status_name;
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
		
	    document.getElementById("pin_whether").value=retObj.employeeMap.pin_whether;
		if(retObj.employeeMap.pin_whether == "1"){       	
        	document.getElementById("divState").style.display="none";
        	document.getElementById("divStates").style.display="none";
        }else if(retObj.employeeMap.pin_whether == "0"){       	
        	document.getElementById("divState").style.display="block";
        	document.getElementById("divStates").style.display="block";
        }else if(retObj.employeeMap.pin_whether == ""){       	
        	document.getElementById("divState").style.display="block";
        	document.getElementById("divStates").style.display="block";
        }
		
	    document.getElementById("pin_unit").value=retObj.employeeMap.pin_unit;
	    document.getElementById("pin_unit_name").value=retObj.employeeMap.pin_unit_name;
	    
		//删除列表中所有的行
		deleteTableTr("recordMap");
		deleteTableTr("projectMap");
		deleteTableTr("trainMap");
		deleteTableTr("educationMap");
		deleteTableTr("certificateMap");
     
     
		if(retObj.recordMap != null){			
			for(var i=0;i<retObj.recordMap.length;i++){
				var record = retObj.recordMap[i];					
				var tr = document.getElementById("recordMap").insertRow();	
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
            	
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = record.start_date;
				
				var td = tr.insertCell(2);
				td.innerHTML = record.end_date;

				var td = tr.insertCell(3);
				td.innerHTML = record.company;
				
				var td = tr.insertCell(4);
				td.innerHTML = record.post;
				
				var td = tr.insertCell(5);
				td.innerHTML = record.administration;
				
				var td = tr.insertCell(6);
				td.innerHTML = record.technology;
				
				var td = tr.insertCell(7);
				td.innerHTML = record.skillname;

			}
		}
		
		if(retObj.projectMap != null){			
			for(var i=0;i<retObj.projectMap.length;i++){
				var project = retObj.projectMap[i];					
				var tr = document.getElementById("projectMap").insertRow();	
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
            	
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = project.project_name;
				
				var td = tr.insertCell(2);
				td.innerHTML = project.project_type_name;

				var td = tr.insertCell(3);
				td.innerHTML = project.plan_start_date;
				
				var td = tr.insertCell(4);
				td.innerHTML = project.plan_end_date;
				
				var td = tr.insertCell(5);
				td.innerHTML = project.actual_start_date;
				
				var td = tr.insertCell(6);
				td.innerHTML =  project.actual_end_date;
				
				var td = tr.insertCell(7);
				td.innerHTML = project.teamname;

				var td = tr.insertCell(8);
				td.innerHTML = project.postname;
				
				var td = tr.insertCell(9);
				td.innerHTML = project.project_evaluate_name;	
						
			}
		}
		var querySql1="";
		var queryRet1=null;
		var train =null;
  
			   querySql1 = "select  er.employee_name,ch.employee_id ,ch.employee_cd, tr.class_name,tr.train_content,SUBSTR(tr.train_start_date,0,10) train_start_date,decode(SUBSTR(tr.train_end_date,0,10),'9999-12-31',to_char(sysdate,'yyyy-MM-dd'), SUBSTR(tr.train_end_date,0,10) )train_end_date,tr.unit_level,tr.program_category,tr.train_form,tr.organizer,tr.train_address,tr.train_results from bgp_human_train_hr tr left join comm_human_employee_hr  ch on tr.employee_cd=ch.employee_cd  and ch.bsflag='0' left join comm_human_employee er on er.employee_id=ch.employee_id and er.bsflag='0'  where er.employee_id='"+ids+"'";
			   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
				if(queryRet1.returnCode=='0'){
					train = queryRet1.datas;	

					if(train != null && train != ''){		 
						for(var i = 0; i<train.length; i++){	 	
				    
							   	var tr = document.getElementById("trainMap").insertRow();	
								
				              	if(i % 2 == 1){  
				              		tr.className = "odd";
								}else{ 
									tr.className = "even";
								}
				            	
								var td = tr.insertCell(0);
								td.innerHTML = i+1;
					 
								var td = tr.insertCell(1);
								td.innerHTML = train[i].train_start_date;
								
								var td = tr.insertCell(2);
								td.innerHTML = train[i].train_end_date;
			
								var td = tr.insertCell(3);
								td.innerHTML = train[i].class_name;
								
								var td = tr.insertCell(4);
								td.innerHTML = train[i].train_content;
								
								var td = tr.insertCell(5);
								td.innerHTML = train[i].unit_level;
								
								var td = tr.insertCell(6);
								td.innerHTML = train[i].program_category;
								
								var td = tr.insertCell(7);
								td.innerHTML = train[i].train_form;
			
								var td = tr.insertCell(8);
								td.innerHTML = train[i].organizer;
								
								var td = tr.insertCell(9);
								td.innerHTML = train[i].train_address;	
								
								var td = tr.insertCell(10);
								td.innerHTML = train[i].train_results;		
							       
				       
						}
					}
			    }	

				
//		if(retObj.trainMap != null){			
//			for(var i=0;i<retObj.trainMap.length;i++){
//				var train = retObj.trainMap[i];					
//				var tr = document.getElementById("trainMap").insertRow();	
//				
//              	if(i % 2 == 1){  
//              		tr.className = "odd";
//				}else{ 
//					tr.className = "even";
//				}
//            	
//				var td = tr.insertCell(0);
//				td.innerHTML = i+1;
//				alert(train.train_start_date);
//				var td = tr.insertCell(1);
//				td.innerHTML = train.train_start_date;
//				
//				var td = tr.insertCell(2);
//				td.innerHTML = train.train_end_date;
//
//				var td = tr.insertCell(3);
//				td.innerHTML = train.class_name;
//				
//				var td = tr.insertCell(4);
//				td.innerHTML = train.train_content;
//				
//				var td = tr.insertCell(5);
//				td.innerHTML = train.unit_level;
//				
//				var td = tr.insertCell(6);
//				td.innerHTML = train.program_category;
//				
//				var td = tr.insertCell(7);
//				td.innerHTML = train.train_form;
//
//				var td = tr.insertCell(8);
//				td.innerHTML = train.organizer;
//				
//				var td = tr.insertCell(9);
//				td.innerHTML = train.train_address;	
//				
//				var td = tr.insertCell(10);
//				td.innerHTML = train.train_results;	
//		
//			}
//		}

		if(retObj.educationMap != null){			
			for(var i=0;i<retObj.educationMap.length;i++){
				var education = retObj.educationMap[i];					
				var tr = document.getElementById("educationMap").insertRow();
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
            	
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = education.start_date;
				
				var td = tr.insertCell(2);
				td.innerHTML = education.finish_date;

				var td = tr.insertCell(3);
				td.innerHTML = education.school_name;
				
				var td = tr.insertCell(4);
				td.innerHTML = education.profess;
				
				var td = tr.insertCell(5);
				td.innerHTML = education.education;
				
			}
		}
		
		if(retObj.certificateMap != null){			
			for(var i=0;i<retObj.certificateMap.length;i++){
				var certificate = retObj.certificateMap[i];					
				var tr = document.getElementById("certificateMap").insertRow();

		     	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
		     	
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = certificate.qualification_name;
				
				var td = tr.insertCell(2);
				td.innerHTML = certificate.certificate_num;
				
				var td = tr.insertCell(3);
				td.innerHTML = certificate.training_institutions;
				
				var td = tr.insertCell(4);
				td.innerHTML = certificate.issuing_agency;
				
				var td = tr.insertCell(5);
				td.innerHTML = certificate.issuing_date;
				
				var td = tr.insertCell(6);
				td.innerHTML = certificate.validity;
				
				var td = tr.insertCell(7);
				var document_id = certificate.document_id;
				if(document_id !=''){
					td.innerHTML = "<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+document_id+"&emflag=0>下载</a>";
				}else{
					td.innerHTML = "";
				}
				
			}
		}

	}
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		popWindow('<%=contextPath%>/doc/singleproject/doc_search.jsp');
	}
	
	function selectChang(){
		var selectObj = document.getElementById("pin_whether");     
	    for(var i = 0; i<selectObj.length; i++){  
	      	if(selectObj.options[i].selected==true){
				if(selectObj.options[i].value == "1"){       	
		        	document.getElementById("divState").style.display="none";
		        	document.getElementById("divStates").style.display="none";
		    		document.getElementById("pin_unit").value="";		  
		    		document.getElementById("pin_unit_name").value="";	
		        }   
		        if (selectObj.options[i].value == "0"){		        	
		        	document.getElementById("divState").style.display="block"; 
		        	document.getElementById("divStates").style.display="block"; 
		        }
		       
	      	}
	       }  
		
        
	}
	function toExportExcel(){ 
		window.open("<%=contextPath%>/rm/em/exportHummanList.srq?employeeGz=<%=paramsType%>&orgSubId="+orgSubId);
 
	}
 
	function toAddPin(){ 
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		var pin_whether=document.getElementById("pin_whether").value;
		var pin_unit=document.getElementById("pin_unit").value;
		if (pin_whether == '') {
			alert("请选择是否借聘!");
			return;
		}
	     var querySql1="";
         var queryRet1=null;
         var datas1 =null; 
         querySql1 = "select hr.employee_hr_id   from  comm_human_employee er left join comm_human_employee_hr hr  on er.employee_id=hr.employee_id   where er.bsflag='0' and er.employee_id='"+ ids +"'";
         queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
         	if(queryRet1.returnCode=='0'){
	       	  datas1 = queryRet1.datas;	 
	       		if(datas1 != null && datas1 != ''){	  	       			
				   var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
					var submitStr = 'JCDP_TABLE_NAME=COMM_HUMAN_EMPLOYEE_HR&JCDP_TABLE_ID='+datas1[0].employee_hr_id +'&pin_whether='+pin_whether
					+'&updator=<%=userName%>&modifi_date=<%=curDate%>&pin_unit='+pin_unit;
				   syncRequest('Post',path,encodeURI(encodeURI(submitStr))); 
		
     	    	   }
	       		
	        }
 		   loadDataDetail(ids);
		   alert("保存成功!");
	}
	function selectOrg2(){ 
			    var teamInfo = {
				        fkValue:"",
				        value:""
				    };
				    window.showModalDialog('<%=contextPath%>/rm/em/commHumanInfo/selectOrgSubPin.jsp',teamInfo);
				    if(teamInfo.fkValue!=""){
				    	 document.getElementById("pin_unit").value = teamInfo.fkValue; 
					        document.getElementById("pin_unit_name").value = teamInfo.value;
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
	
	function toEdit() {
	    
		ids = getSelectedValue();//getSelIds('rdo_entity_id');

		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/rm/em/commHumanInfo/comm_human_Info.upmd?pagerAction=edit2Edit&id='+ids);
	}
	
	 function toUploadFile(){
		   var orgId='<%=orgId%>';
		   var subId='<%=orgSubjectionId%>';
			popWindow('<%=contextPath%>/rm/em/commHumanInfo/humanImportFile.jsp?paramsType=<%=paramsType%>&orgId='+orgId+'&subId='+subId);
	 }
	 
	 function toUploadFileG(){
		   var orgId='<%=orgId%>';
		   var subId='<%=orgSubjectionId%>';
			popWindow('<%=contextPath%>/rm/em/commHumanInfo/humanImportFileG.jsp?paramsType=<%=paramsType%>&orgId='+orgId+'&subId='+subId);
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

	function toSerach(){
		popWindow('<%=contextPath%>/rm/em/commHumanInfo/doc_search.jsp');
	}
	
	function popSearch(str){
		document.getElementById("s_employee_name").value='';
		cruConfig.cdtStr = str;
		refreshData(undefined);
	}
	
	function clearQueryText(){ 
		document.getElementById("s_employee_name").value='';
		cruConfig.cdtStr = "";
	}
</script>
</html>